# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Purely experimental playground for Go implementation of AppImage\
tools"
HOMEPAGE="https://github.com/probonopd/go-appimage"
LICENSE="MIT" # go-appimage project's default license
# dependencies of go various micropackages
LICENSE+=" Apache-2.0 BSD BSD-2 EPL-1.0 GPL-3 ISC MPL-2.0"
# Static libraries follow below
# aid = included in appimaged ; ait = included in appimagetool
LICENSE+=" BSD BSD-2 BSD-4 public-domain" # libarchive aid
LICENSE+=" GPL-2" # squashfs-tools ait aid
LICENSE+=" GPL-2+" # desktop-file-utils ait
LICENSE+=" GPL-3" # patchelf # ait
LICENSE+=" all-rights-reserved MIT" # \
# The runtime archive comes from runtime.c from AppImageKit \
# MIT license does not have all rights reserved
LICENSE+=" MIT" # upload tool
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="disable_watching_desktop_folder disable_watching_downloads_folder \
firejail gnome kde openrc overlayfs systemd travis-ci"
RDEPEND="
	!app-arch/appimaged
	!app-arch/appimagetool
	firejail? ( sys-apps/firejail )
	gnome? ( gnome-base/gvfs[udisks] )
	kde? ( kde-frameworks/solid )
	openrc? ( sys-apps/openrc )
	sys-apps/dbus
	>=sys-fs/squashfs-tools-4.4
	sys-fs/udisks[daemon]
	systemd? ( sys-apps/systemd )
	travis-ci? (
		dev-libs/openssl
		dev-vcs/git
	)"
DEPEND="${RDEPEND}
	>=dev-lang/go-1.13.4:="
REQUIRED_USE="|| ( gnome kde )"
SLOT="0/${PV}"
EGIT_COMMIT="0c02e035e6a93d6e9bb6e3c5623dcc4333540087"
SRC_URI=\
"https://github.com/probonopd/go-appimage/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-${PV}-gentooize.patch" )
inherit linux-info user

# See scripts/build.sh

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
micropackages."
	fi
	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
		die \
"You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	if ! linux_chkconfig_builtin BINFMT_MISC \
		&& ! linux_chkconfig_module BINFMT_MISC ; then
		die \
"You need to change your kernel .config to CONFIG_BINFMT_MISC=y or \
CONFIG_BINFMT_MISC=m"
	fi

	if ! linux_chkconfig_builtin SQUASHFS \
		&& ! linux_chkconfig_module SQUASHFS ; then
		die \
"You need to change your kernel .config to CONFIG_SQUASHFS=y or \
CONFIG_SQUASHFS=m"
	fi

	local found_appimage_type=0
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ]] \
		&& grep -F -e "enabled" \
			"${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ; then
		found_appimage_type=1
		eerror \
"You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type1"
		die
	fi
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ]] \
		&& grep -F -e "enabled" \
			"${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ; then
		eerror \
"You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type2"
		die
	fi

	if [[ "${found_appimage_type}" == "1" ]] ; then
		eerror \
"See issue: https://github.com/probonopd/go-appimage/issues/7"
		eerror
		eerror "See also:"
		eerror \
"https://github.com/probonopd/go-appimage/blob/\
4ac0e102e05507f43c82beef558d0eedba0e50ae/src/appimaged/prerequisites.go#L216"
		eerror \
"https://www.kernel.org/doc/Documentation/admin-guide/binfmt-misc.rst"
		die
	fi

	if [[ -f "${EROOT}/usr/bin/AppImageLauncher" ]] ; then
		die \
"AppImageLauncher is not compatible and needs to be uninstalled."
	fi
	if use firejail ; then
		if ! linux_chkconfig_builtin BLK_DEV_LOOP \
			&& ! linux_chkconfig_module BLK_DEV_LOOP ; then
			die \
"You need to change your kernel .config to CONFIG_BLK_DEV_LOOP=y or \
CONFIG_BLK_DEV_LOOP=m"
		fi
		if use overlayfs && ! linux_chkconfig_builtin OVERLAY_FS \
			&& ! linux_chkconfig_module OVERLAY_FS ; then
			die \
"You need to change your kernel .config to CONFIG_OVERLAY_FS=y or \
CONFIG_OVERLAY_FS=m"
		fi
	fi
	ewarn \
"This package is a Work In Progress (WIP) upstream."
	# server only
	enewgroup appimaged
	enewuser appimaged -1 -1 /var/lib/appimaged appimaged
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	chmod +x ./scripts/build.sh || die
	cp -a "${FILESDIR}/apply-patches-${PV}.sh" "${WORKDIR}" || die
	chmod +x "${WORKDIR}/apply-patches-${PV}.sh"
	eapply ${PATCHES[@]}
	# required for public key embedding
	git init || die
	git add . || die
	export GIT_ROOT="${S}"
	# required for mounting when calling:
	#   ./appimagetool-2020-08-17_00:47:34-amd64.AppImage ./appimaged.AppDir
	addwrite /dev/fuse
	if use disable_watching_downloads_folder ; then
		export USE_DISABLE_WATCHING_DOWNLOADS_FOLDER=1
	fi
	if use disable_watching_desktop_folder ; then
		export USE_DISABLE_WATCHING_DESKTOP_FOLDER=1
	fi
	export EGIT_COMMIT
	# Workaround emerge policy concerning downloads in src_compile phase.
	./scripts/build.sh || die
}

src_prepare() {
	# fork to add patches
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
}

src_compile() {
	:;
}

# @FUNCTION: install_licenses
# @DESCRIPTION:
# Installs all licenses from main package and micropackages
# Standardizes the process.
install_licenses() {
	local source_dir="${1}"
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${source_dir}" \
	  -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -r -e "s|^${source_dir}||")
		else
			d=$(echo "${f}" | sed -r -e "s|^${source_dir}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}



src_install() {
	local goArch=$(go env GOHOSTARCH)
	exeinto /usr/bin
	BUILD_DIR="${WORKDIR}/go_build/src"
	# No support for multi go yet the other is false
	# Gentoo's Go is not multilib that's why.
	local aits=$(basename $(realpath "${BUILD_DIR}/appimaged-*-${goArch}.AppImage") \
		| cut -f 2-4 -d "-")
	local aid_fn="appimaged-${aits}-${goArch}.AppImage"
	local ait_fn="appimagetool-${aits}-${goArch}.AppImage"
	doexe "${BUILD_DIR}/${aid_fn}"
	doexe "${BUILD_DIR}/${ait_fn}"
	dosym ../../../usr/bin/${aid_fn} /usr/bin/appimaged
	dosym ../../../usr/bin/${ait_fn} /usr/bin/appimagetool
	install_licenses "${BUILD_DIR}"
	docinto licenses
	dodoc "${S}/LICENSE"
	docinto readme
	dodoc "${S}/README.md"
	cp "${S}/src/appimaged/README.md" \
		"${T}/appimaged-README.md" || die
	dodoc "${T}/appimaged-README.md"
	cp "${S}/src/appimagetool/README.md" \
		"${T}/appimagetool-README.md" || die
	dodoc "${T}/appimagetool-README.md"
	if use openrc ; then
		cp "${FILESDIR}/${PN}-openrc" \
			"${T}/${PN}" || die
		exeinto /etc/init.d
		doexe "${T}/${PN}"
	fi
}

pkg_postinst() {
	if use openrc ; then
		einfo \
"\n\
OpenRC support is experimental.  It may or not work for encrypted home.\n\
Do \`rc-update add appimaged\` to run the service on boot.\n\
\n\
You can \`/etc/init.d/${PN} start\` to start it now.\n\
\n"
	fi
	if use systemd ; then
		einfo \
"\n\
You must run appimaged as non-root to generate the systemd service files in\n\
~/.\n\
\n\
You must \`systemctl --user enable appimaged\` inside the user account to add\n\
the service on login.\n\
\n\
You can \`systemctl --user start appimaged\` to start it now.\n\
\n"
	fi
	einfo
	einfo "The appimaged daemon will randomly quit when watching files"
	einfo "and needs to be restarted."
	einfo
	einfo \
"The user may need to be added to the \"disk\" group in order for firejail\n\
rules to work."
}
