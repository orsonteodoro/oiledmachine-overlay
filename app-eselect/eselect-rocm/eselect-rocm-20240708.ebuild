# Copyright 2019-2024 Orson Teodoro
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

KEYWORDS="~amd64"
SRC_URI=""

DESCRIPTION="Manages the rocm symlinks"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-rocm"
LICENSE="GPL-2+"
RESTRICT="fetch"
SLOT="0"
IUSE+=" ebuild_revision_1"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cat \
		"${FILESDIR}/rocm-${PVR}.eselect" \
		> \
		"${S}/rocm.eselect" \
		|| die
	sed -i \
		-e "s|@ABI_LIBDIR@|lib64|g" \
		-e "s|@EPREFIX@|${EPREFIX}|g" \
		-e "s|@ROCM_LIBDIR@|lib|g" \
		"${S}/rocm.eselect" \
		|| die
}

src_install() {
	insinto "/usr/share/eselect/modules"
	doins "rocm.eselect"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
