# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, ROCm-6.2, ROCm-6.3, ROCm-6.4, ROCm-7.0, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)

inherit cmake-multilib flag-o-matic libstdcxx-slot

DESCRIPTION="Small, safe and fast formatting library"
HOMEPAGE="https://fmt.dev/dev/ https://github.com/fmtlib/fmt"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/fmtlib/fmt.git"
	inherit git-r3
else
	SRC_URI="https://github.com/fmtlib/fmt/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	S="${WORKDIR}/fmt-${PV}"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	# backport of https://github.com/fmtlib/fmt/commit/f4345467fce7edbc6b36c3fa1cf197a67be617e2
	"${FILESDIR}/${P}-libcxx-21-cstdlib.patch"
)

pkg_setup() {
	libstdcxx-slot_verify
}

multilib_src_configure() {
	append-lfs-flags
	local mycmakeargs=(
		-DFMT_CMAKE_DIR="$(get_libdir)/cmake/fmt"
		-DFMT_LIB_DIR="$(get_libdir)"
		-DFMT_TEST=$(usex test)
	)
	cmake_src_configure
}
