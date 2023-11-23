# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit linux-info meson python-r1 security-scan

SRC_URI="
https://github.com/EmixamPP/linux-enable-ir-emitter/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Provides support for infrared cameras that are not directly enabled out-of-the box."
HOMEPAGE="
https://github.com/EmixamPP/linux-enable-ir-emitter
"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
openrc systemd r1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ (
		openrc
		systemd
	)
"
# U 22.04
GCC_PV="11.4.0"
RDEPEND+="
	${PYTHON_DEPS}
	>=media-libs/opencv-4.8.1[gtk3,v4l]
	>=sys-apps/kmod-29[tools]
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/glibc-2.35
	>=x11-libs/gtk+-3.24.33:3
	virtual/udev
	openrc? (
		sys-apps/openrc
	)
	systemd? (
		>=sys-apps/systemd-249.11
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.22.1
	>=dev-util/meson-1.0.0
	>=dev-util/ninja-1.10.1
	>=net-misc/curl-7.81.0
	>=sys-devel/gcc-${GCC_PV}
	virtual/pkgconfig
"
RESTRICT="mirror"

pkg_pretend() {
	CONFIG_CHECK="
		~MEDIA_CAMERA_SUPPORT
		~MEDIA_SUPPORT
		~MEDIA_USB_SUPPORT
		~USB
		~USB_VIDEO_CLASS
		~VIDEO_DEV
	"
	check_extra_config
}

pkg_setup() {
	CONFIG_CHECK="
		~MEDIA_CAMERA_SUPPORT
		~MEDIA_SUPPORT
		~MEDIA_USB_SUPPORT
		~USB
		~USB_VIDEO_CLASS
		~VIDEO_DEV
	"
	check_extra_config
}

src_configure() {
	local emesonargs=(
	)
	if use openrc ; then
		emesonargs=(
			-Dboot_service="openrc"
		)
	fi
	if use systemd ; then
		emesonargs=(
			-Dboot_service="systemd"
		)
	fi
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
