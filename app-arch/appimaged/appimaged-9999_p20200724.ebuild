# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="appimaged is a daemon that monitors the system and integrates \
AppImages."
HOMEPAGE="https://github.com/AppImage/appimaged"
LICENSE="MIT" # appimaged project's default license
LICENSE+=" all-rights-reserved" # src/main.c ; The vanilla MIT license doesn't have all-rights-reserved
KEYWORDS="~amd64 ~x86"
IUSE="firejail openrc systemd system-inotify-tools"
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
	sys-fs/squashfuse:=[static-libs]
	sys-libs/glibc:=
	system-inotify-tools? ( sys-fs/inotify-tools:=[static-libs] )
	x11-libs/cairo:=[static-libs]"
DEPEND="${RDEPEND}"
REQUIRED_USE=""
SLOT="0/${PV}"
EGIT_COMMIT="8e248f5afe975b8ef65c7e3e5596ab13c6af3a4d"
SRC_URI=\
"https://github.com/AppImage/appimaged/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
inherit cmake-utils linux-info user
PATCHES=(
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
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
internal dependencies."
		fi
	fi

	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
		die "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	# server only
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
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
		einfo "OpenRC support is experimental.  It may or not work for encrypted home."
		einfo
		einfo "Do \`rc-update add appimaged\` to run the service on boot."
		einfo "You can \`/etc/init.d/${PN} start\` to start it now."
	elif use systemd ; then
		einfo "You must \`systemctl --user enable appimaged\` inside the user account to add the service on login."
		einfo "You can \`systemctl --user start appimaged\` to start it now."
	fi
}
