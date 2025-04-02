# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

PYTHON_COMPAT=( "python3_"{10..12} ) # U24 uses 3.12

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
openrc systemd ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ (
		openrc
		systemd
	)
"
GCC_PV="13.2.0"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-cpp/argparse-3.1.0
	>=dev-cpp/yaml-cpp-0.8.0
	>=dev-libs/spdlog-1.12.0
	>=media-libs/opencv-4.10.0[gtk3,v4l]
	>=sys-apps/kmod-31[tools]
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/glibc-2.39
	>=x11-libs/gtk+-3.24.41:3
	virtual/udev
	openrc? (
		sys-apps/openrc
	)
	systemd? (
		>=sys-apps/systemd-255.4
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.28.3
	>=dev-build/meson-1.3.2
	>=dev-build/ninja-1.11.1
	>=net-misc/curl-8.5.0
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
	python_setup
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
