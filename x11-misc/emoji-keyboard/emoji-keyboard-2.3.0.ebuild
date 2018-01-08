# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )

inherit eutils distutils-r1 linux-info


DESCRIPTION="Virtual keyboard-like emoji picker for Linux. "
HOMEPAGE="https://github.com/OzymandiasTheGreat/emoji-keyboard"
SRC_URI="https://github.com/OzymandiasTheGreat/emoji-keyboard/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wayland X"

RDEPEND="dev-python/python-evdev[${PYTHON_USEDEP}]
         dev-python/pygobject[${PYTHON_USEDEP}]
         dev-libs/gobject-introspection[${PYTHON_USEDEP}]
	 x11-libs/gtk+:3[introspection]
	 dev-libs/libappindicator[introspection]
	 wayland? ( sys-apps/systemd )
	 X? ( >=dev-python/python-xlib-0.19[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists ; then
		eerror "You are missing a .config file in your kernel source."
		die
	fi

	if ! linux_chkconfig_present INPUT_EVDEV ; then
		eerror "You need CONFIG_INPUT_EVDEV=y or CONFIG_INPUT_EVDEV=m for this to work."
		die
	fi
	python_setup
}

python_prepare_all() {
	if ! use wayland ; then
		epatch "${FILESDIR}/emoji-keyboard-2.3.0-no-wayland.patch"
	fi

	distutils-r1_python_prepare_all

	python_copy_sources
}

python_compile() {
	distutils-r1_python_compile
}

pkg_postinst() {
	if ! use X ; then
		ewarn "You are not installing X support and is highly recommended.  Settings > On selecting emoji > Type will not work without X USE flag."
	fi
}
