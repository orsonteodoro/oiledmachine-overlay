# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from virtualbox-bin

EAPI=5

inherit eutils linux-mod user git-r3

DESCRIPTION="Kernel Modules for Endpoints EP800/SE402/SE401*"
HOMEPAGE="https://github.com/orsonteodoro/gspca_ep800"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="snapshot-button"

RDEPEND=""

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}/trunk"

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="ep800(kernel/drivers/media/usb/gspca:${S})"
BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"

pkg_setup() {
	CONFIG_CHECK="MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT MEDIA_USB_SUPPORT USB_GSPCA"
	ERROR_MEDIA_SUPPORT="${P} requires Multimedia support (CONFIG_MEDIA_SUPPORT)"
	ERROR_MEDIA_CAMERA_SUPPORT="${P} requires Cameras/video grabbers support (CONFIG_MEDIA_CAMERA_SUPPORT)":
	ERROR_MEDIA_USB_SUPPORT="${P} requires Media USB Adapters (CONFIG_MEDIA_USB_SUPPORT)"
	ERROR_USB_GSPCA="${P} requires GSPCA based webcams (CONFIG_USB_GSPCA)"

	if use snapshot-button; then
		BUILD_PARAMS+=" ${BUILD_PARAMS} SNAPSHOT=1"
	fi

	linux-mod_pkg_setup
}

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/orsonteodoro/gspca_ep800.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="547f10b27909177e884339ef8c5c4a66220070b7"
        git-r3_fetch
        git-r3_checkout
}

src_compile() {
        linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "Your module is called ep800.  You can do a modprobe ep800 to use it."
}
