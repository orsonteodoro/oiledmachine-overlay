# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit cflags-hardened cmake-multilib

SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64"
IUSE+="
ebuild_revision_14
"
RDEPEND+="
	>=app-arch/brotli-1.0.1[${MULTILIB_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
"

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DCANONICAL_PREFIXES=ON #661942
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	install_bin() {
		if multilib_is_native_abi ; then
			dobin "${BUILD_DIR}/woff2_compress"
			dobin "${BUILD_DIR}/woff2_decompress"
			dobin "${BUILD_DIR}/woff2_info"
		fi
		multilib_check_headers
	}
	multilib_foreach_abi install_bin
	multilib_src_install_all
}

multilib_src_install_all() {
	einstalldocs
}
