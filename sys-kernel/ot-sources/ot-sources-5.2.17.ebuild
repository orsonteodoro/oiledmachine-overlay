# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

K_GENPATCHES_VER="17"
PATCH_BMQ_VER="099"

function ot-kernel-common_apply_genpatch_base_patchset() {
	_tpatch "${PATCH_OPS} -N" "$d/1500_XATTR_USER_PREFIX.patch"
	_tpatch "${PATCH_OPS} -N" "$d/1510_fs-enable-link-security-restrictions-by-default.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2600_enable-key-swapping-for-apple-mac.patch"
}

inherit ot-kernel-v5.2

KEYWORDS="~amd64 ~x86"

pkg_setup() {
        kernel-2_pkg_setup
	ot-kernel-common_pkg_setup
}

src_unpack() {
	ot-kernel-common_src_unpack
}

src_compile() {
	ot-kernel-common_src_compile
}

src_install() {
	ot-kernel-common_src_install
	kernel-2_src_install
}

pkg_postinst() {
	unset K_SECURITY_UNSUPPORTED
	kernel-2_pkg_postinst
	ot-kernel-common_pkg_postinst
}

pkg_postrm() {
	ot-kernel-common_pkg_postrm
}

