# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="appimaged is a daemon that monitors the system and integrates \
AppImages."
HOMEPAGE="https://github.com/AppImage/appimaged"
LICENSE="MIT" # appimaged project's default license
LICENSE+=" all-rights-reserved" # src/main.c ; \
# The vanilla MIT license doesn't have all-rights-reserved
KEYWORDS="~amd64 ~x86"
inherit cmake git-r3 linux-info user-info xdg
IUSE+="
disable_watching_user_downloads_folder disable_watching_opt_folder firejail
openrc +systemd system-inotify-tools
"
SLOT="0/9999"
#	x11-libs/cairo:=[static-libs]
RDEPEND="${RDEPEND}
	app-arch/libarchive[lz4]
	dev-libs/glib:=[static-libs]
	dev-libs/libappimage:=[static-libs]
	dev-libs/xdg-utils-cxx:=[static-libs]
	sys-fs/squashfuse:=[appimage,lz4,static-libs]
	sys-libs/glibc:=
	x11-libs/cairo:=
	firejail? (
		sys-apps/firejail
	)
	openrc? (
		sys-apps/openrc[bash]
		sys-apps/grep[pcre]
	)
	systemd? (
		sys-apps/systemd
	)
	system-inotify-tools? (
		sys-fs/inotify-tools:=[static-libs]
	)
"
DEPEND+=" ${RDEPEND}"
REQUIRED_USE="
	system-inotify-tools
	|| ( openrc systemd )
"
if [[ "${PV}" =~ 9999 ]] ; then
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-9999"
else
	EGIT_COMMIT="11b249848d7d0d9b3b7154ae5fca0328afa167d4"
	SRC_URI="
https://github.com/AppImage/appimaged/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi
RESTRICT="mirror"
_PATCHES=(
	"${FILESDIR}/${PN}-9999_p20200724-fill-git-commit.patch"
	"${FILESDIR}/${PN}-9999_p20200724-use-find_package.patch"
	"${FILESDIR}/${PN}-9999_p20200724-add-libappimage-include-directories.patch"
	"${FILESDIR}/${PN}-9999_p20200724-rename-input-lib-to-appimage_static.patch"
	"${FILESDIR}/${PN}-9999_p20200724-add-missing-libs.patch"
	"${FILESDIR}/${PN}-9999_p20200724-add-watch-opt-AppImage.patch"
)

# See scripts/build.sh

pkg_setup() {
	if has_version "app-arch/go-appimage[appimaged]" ; then
eerror
eerror "You must disable the appimaged USE flag in app-arch/go-appimage to"
eerror "continue."
eerror
		die
	fi

ewarn
ewarn "This product is EOL (End Of Life) and will no longer receive security"
ewarn "updates.  Use go-appimage instead."
ewarn
	if ! use system-inotify-tools ; then
		if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES in order to"
eerror "download internal dependencies."
eerror
			die
		fi
	fi

	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
ewarn
	fi
	if use firejail ; then
		if ! linux_chkconfig_builtin BLK_DEV_LOOP \
			&& ! linux_chkconfig_module BLK_DEV_LOOP ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_BLK_DEV_LOOP=y or"
ewarn "CONFIG_BLK_DEV_LOOP=m"
ewarn
		fi
	fi

	# Server only
	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi
}

src_prepare() {
	cmake_src_prepare
	xdg_src_prepare
	eapply ${_PATCHES[@]}

	if use disable_watching_user_downloads_folder ; then
		sed -i -e "/G_USER_DIRECTORY_DOWNLOAD/d" src/main.c || die
	fi
	if use disable_watching_opt_folder ; then
		sed -i -e "/[/]opt\"/d" src/main.c || die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="11b249848d7d0d9b3b7154ae5fca0328afa167d4"
		EGIT_REPO_URI="https://github.com/AppImageCommunity/appimaged.git"
		EGIT_BRANCH="master"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_INOTIFY_TOOLS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	if use openrc ; then
		cp "${FILESDIR}/${PN}-openrc" "${T}/${PN}" || die
		exeinto /etc/init.d
		doexe "${T}/${PN}"
	fi
}

pkg_postinst() {
	if use openrc ; then
eerror
eerror "OpenRC support is experimental.  It may or not work for encrypted home."
eerror
eerror "Do \`rc-update add appimaged\` to run the service on boot."
eerror
eerror "You can \`/etc/init.d/${PN} start\` to start it now."
eerror
	fi
	if use systemd ; then
einfo
einfo "You must \`systemctl --user enable appimaged\` inside the user account"
einfo "to add the service on login.  You can"
einfo
einfo "  \`systemctl --user start appimaged\`"
einfo
einfo "to start it now."
einfo
	fi
einfo
einfo "The user may need to be added to the \"disk\" group in order for"
einfo "firejail rules to work.  This can be done with \`gpasswd -a USER disk\`"
einfo
einfo "Security:  Please only download .AppImages only from a trusted"
einfo "distribution site.  Old .AppImages may likely pose a security risk."
einfo
einfo "The AppImageHub (https://appimage.github.io/apps/) was recommended"
einfo "from the README.md.   More can be found in the \"Home\" link."
einfo
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
