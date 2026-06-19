# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenJPH"
MY_P="${MY_PN}-${PV}"

CXX_STANDARD=14
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY=""

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX14[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}"
)

inherit cmake cflags-hardened libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aous72/OpenJPH.git"
	FALLBACK_COMMIT="ecc624ea003a0c747f96f531afc28f0cc369504f" # Jun 16, 2026
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="
https://github.com/aous72/OpenJPH/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
HOMEPAGE="
	https://github.com/aous72/OpenJPH
"
LICENSE="
	BSD-2
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut 1-2 "${PV}")
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
"
REQUIRED_USE="
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_sse4? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx512? (
		cpu_flags_x86_avx2
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.12.0
"
DOCS=( "README.md" )

pkg_setup() {
	libstdcxx-slot_verify
	libcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DOJPH_DISABLE_NEON=$(usex !cpu_flags_arm_neon)
		-DOJPH_DISABLE_SSE=$(usex !cpu_flags_x86_sse)
		-DOJPH_DISABLE_SSE2=$(usex !cpu_flags_x86_sse2)
		-DOJPH_DISABLE_SSSE3=$(usex !cpu_flags_x86_ssse3)
		-DOJPH_DISABLE_SSE4=$(usex !cpu_flags_x86_sse4)
		-DOJPH_DISABLE_AVX=$(usex !cpu_flags_x86_avx)
		-DOJPH_DISABLE_AVX2=$(usex !cpu_flags_x86_avx2)
		-DOJPH_DISABLE_AVX512=$(usex !cpu_flags_x86_avx512)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && einstalldocs
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
