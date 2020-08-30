# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="appimaged is a daemon that monitors the system and integrates \
AppImages."
HOMEPAGE="https://github.com/AppImage/appimaged"
LICENSE="MIT" # appimaged project's default license
LICENSE+=" all-rights-reserved" # src/main.c ; \
# The vanilla MIT license doesn't have all-rights-reserved
KEYWORDS="~amd64 ~x86"
IUSE="disable_watching_user_downloads_folder disable_watching_opt_folder \
firejail openrc +systemd system-inotify-tools"
RDEPEND="
	!app-arch/go-appimage
	dev-libs/glib:=[static-libs]
	dev-libs/libappimage:=[static-libs]
	dev-libs/xdg-utils-cxx:=[static-libs]
	firejail? ( sys-apps/firejail )
	openrc? (
		sys-apps/openrc
		sys-apps/grep[pcre]
	)
	systemd? ( sys-apps/systemd )
	sys-fs/squashfuse:=[libsquashfuse-appimage,static-libs]
	sys-libs/glibc:=
	system-inotify-tools? ( sys-fs/inotify-tools:=[static-libs] )
	x11-libs/cairo:=[static-libs]"
DEPEND="${RDEPEND}"
REQUIRED_USE="|| ( openrc systemd )"
SLOT="0/${PV}"
EGIT_COMMIT="8e248f5afe975b8ef65c7e3e5596ab13c6af3a4d"
SRC_URI=\
"https://github.com/AppImage/appimaged/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
inherit cmake-utils linux-info user xdg
_PATCHES=(
	"${FILESDIR}/${PN}-${PV}-fill-git-commit.patch"
	"${FILESDIR}/${PN}-9999_p20200724-use-find_package.patch"
	"${FILESDIR}/${PN}-9999_p20200724-add-libappimage-include-directories.patch"
	"${FILESDIR}/${PN}-9999_p20200724-rename-input-lib-to-appimage_static.patch"
	"${FILESDIR}/${PN}-9999_p20200724-add-missing-libs.patch"
)

# See scripts/build.sh

pkg_setup() {
	if ! use system-inotify-tools ; then
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to\n\
download internal dependencies."
		fi
	fi

	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
		die \
"You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	if use firejail ; then
		if ! linux_chkconfig_builtin BLK_DEV_LOOP \
			&& ! linux_chkconfig_module BLK_DEV_LOOP ; then
			die \
"You need to change your kernel .config to CONFIG_BLK_DEV_LOOP=y or \
CONFIG_BLK_DEV_LOOP=m"
		fi
	fi
	# server only
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	eapply ${_PATCHES[@]}
	cmake-utils_src_prepare
	xdg_src_prepare

	if use disable_watching_user_downloads_folder ; then
		sed -i -e "/G_USER_DIRECTORY_DOWNLOAD/d" src/main.c || die
	fi
	if use disable_watching_opt_folder ; then
		sed -i -e "/opt/d" src/main.c || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_INOTIFY_TOOLS=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
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
\n\
Do \`rc-update add appimaged\` to run the service on boot.\n\
You can \`/etc/init.d/${PN} start\` to start it now."
	fi
	if use systemd ; then
		einfo \
"\n\
You must \`systemctl --user enable appimaged\` inside the user account to\n\
add the service on login.  You can \`systemctl --user start appimaged\` to\n\
start it now."
	fi
	einfo \
"The user may need to be added to the \"disk\" group in order for firejail\n\
rules to work.\n\
This can be done with \`gpasswd -a USER disk\`\n\
\n\
Security:  Please only download .AppImages only from a trusted distribution\n\
site.  Old .AppImages may likely pose a security risk.\n\
\n\
The AppImageHub (https://appimage.github.io/apps/) was recommended\n\
from the README.md.   More can be found in the \"Home\" link."
	xdg_pkg_postinst
}
