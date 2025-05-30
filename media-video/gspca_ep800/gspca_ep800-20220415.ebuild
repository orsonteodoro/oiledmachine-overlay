# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
CONFIG_CHECK="~INPUT MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT MEDIA_USB_SUPPORT USB USB_GSPCA VIDEO_V4L2"
EGIT_COMMIT="7cc32fce082fd3f439bdce2a2914fa8a187b2c23"
ERROR_INPUT="${P} requires Generic input layer (CONFIG_INPUT) for snapshot-button support"
ERROR_MEDIA_CAMERA_SUPPORT="${P} requires Cameras/video grabbers support (CONFIG_MEDIA_CAMERA_SUPPORT)"
ERROR_MEDIA_SUPPORT="${P} requires Multimedia support (CONFIG_MEDIA_SUPPORT)"
ERROR_MEDIA_USB_SUPPORT="${P} requires Media USB Adapters (CONFIG_MEDIA_USB_SUPPORT)"
ERROR_USB="${P} requires Support for Host-side USB (CONFIG_USB)"
ERROR_USB_GSPCA="${P} requires GSPCA based webcams (CONFIG_USB_GSPCA)"
ERROR_VIDEO_V4L2="${P} requires CONFIG_VIDEO_V4L2"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
MODULE_NAMES="ep800(kernel/drivers/media/usb/gspca:${S})"

inherit flag-o-matic linux-mod

KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}/trunk"
SRC_URI="
https://github.com/orsonteodoro/${PN}/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Kernel Modules for Endpoints EP800/SE402/SE401*"
HOMEPAGE="https://github.com/orsonteodoro/gspca_ep800"
LICENSE="GPL-2"
RESTRICT="mirror"
SLOT="0"

src_configure() {
	export CC=$(grep -E -e "CONFIG_CC_VERSION_TEXT" "${KERNEL_DIR}/.config" \
		| cut -f 1 -d " " \
		| cut -f 2 -d "=" \
		| sed -e "s/[\"|']//g")
	export CPP="${CC} -E"
	strip-unsupported-flags
	einfo "CC: ${CC}"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "Your module is called ep800.  You can do a modprobe ep800 to use it."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
