# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris"

RDEPEND+=" app-arch/brotli[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
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
	}
	multilib_foreach_abi install_bin

	einstalldocs
}
