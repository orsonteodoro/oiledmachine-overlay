# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Purely experimental playground for Go implementation of AppImage\
tools"
HOMEPAGE="https://github.com/probonopd/go-appimage"
LICENSE="MIT" # go-appimage project's default license
LICENSE+=" Apache-2.0 BSD BSD-2 EPL-1.0 GPL-3 ISC MPL-2.0" # dependencies of go various micropackages
# static libraries below
# aid = included in appimaged ; ait = included in appimagetool
LICENSE+=" BSD BSD-2 BSD-4 public-domain" # libarchive aid
LICENSE+=" GPL-2" # squashfs-tools ait aid
LICENSE+=" GPL-2+" # desktop-file-utils ait
LICENSE+=" GPL-3" # patchelf # ait
LICENSE+=" all-rights-reserved MIT" # runtime from runtime.c from AppImageKit # MIT license does not have all rights reserved
LICENSE+=" MIT" # upload tool
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="firejail gnome travis-ci kde"
RDEPEND="
	!app-arch/appimaged
	firejail? ( sys-apps/firejail )
	gnome? ( gnome-base/gvfs[udisks] )
	kde? ( kde-frameworks/solid )
	sys-apps/dbus
	sys-apps/systemd
	travis-ci? (
		dev-libs/openssl
		dev-vcs/git
	)"
DEPEND="${RDEPEND}
	>=dev-lang/go-1.13.4"
REQUIRED_USE="|| ( gnome kde )"
SLOT="0/${PV}"
EGIT_COMMIT="4ac0e102e05507f43c82beef558d0eedba0e50ae"
SRC_URI=\
"https://github.com/probonopd/go-appimage/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-9999_p20200722-gentooize.patch" )
inherit linux-info

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
		die "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	if ! linux_chkconfig_builtin BINFMT_MISC && ! linux_chkconfig_module BINFMT_MISC ; then
		die "You need to change your kernel .config to CONFIG_BINFMT_MISC=y or CONFIG_BINFMT_MISC=m"
	fi

	if ! linux_chkconfig_builtin SQUASHFS && ! linux_chkconfig_module SQUASHFS ; then
		die "You need to change your kernel .config to CONFIG_SQUASHFS=y or CONFIG_SQUASHFS=m"
	fi

	local found_appimage_type=0
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ]] \
		&& grep -F -e "enabled" "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ; then
		found_appimage_type=1
		eerror "You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type1"
		die
	fi
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ]] \
		&& grep -F -e "enabled" "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ; then
		eerror "You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type2"
		die
	fi

	if [[ "${found_appimage_type}" == "1" ]] ; then
		eerror "See issue: https://github.com/probonopd/go-appimage/issues/7"
		eerror
		eerror "See also:"
		eerror "https://github.com/probonopd/go-appimage/blob/4ac0e102e05507f43c82beef558d0eedba0e50ae/src/appimaged/prerequisites.go#L216"
		eerror "https://www.kernel.org/doc/Documentation/admin-guide/binfmt-misc.rst"
		die
	fi

	if [[ -f "${EROOT}/usr/bin/AppImageLauncher" ]] ; then
		die "AppImageLauncher is not compatible and needs to be uninstalled."
	fi
	ewarn "This package is a Work In Progress (WIP)."
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	chmod +x ./scripts/build.sh || die
	eapply ${PATCHES[@]}
	sed -i -e "s|\tensureRunningFromLiveSystem|\t//ensureRunningFromLiveSystem|g" \
		"src/appimaged/prerequisites.go" || die
	# Workaround emerge policy concerning downloads in src_compile phase.
	./scripts/build.sh
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
	exeinto /usr/bin
	BUILD_DIR="${WORKDIR}/go_build/src"
	# No support for multi go yet the other is false
	doexe "${BUILD_DIR}/"appimaged-${ARCH//x86/386}
	doexe "${BUILD_DIR}/"appimagetool-${ARCH//x86/386}
	dosym ../../../usr/bin/appimaged-${ARCH//x86/386} /usr/bin/appimaged
	dosym ../../../usr/bin/appimagetool-${ARCH//x86/386} /usr/bin/appimagetool
	install_licenses "${BUILD_DIR}"
	docinto licenses
	dodoc "${S}/LICENSE"
	docinto readme
	dodoc "${S}/README.md"
	cp "${S}/src/appimaged/README.md" > "${T}/appimaged-README.md"
	dodoc "${T}/appimaged-README.md"
	cp "${S}/src/appimagetool/README.md" > "${T}/appimagetool-README.md"
	dodoc "${T}/appimagetool-README.md"
}
