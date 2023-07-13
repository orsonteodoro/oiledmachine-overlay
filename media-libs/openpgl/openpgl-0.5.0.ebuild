# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Generated headers and sources for OpenXR loader."
LICENSE="
	Apache-2.0
	BSD
"
KEYWORDS="~amd64"
HOMEPAGE="http://www.openpgl.org/"
SLOT="0/$(ver_cut 1-2 ${PV})"
X86_CPU_FLAGS=(
	sse4_1:sse4_1
	sse4_2:sse4_2
	avx2:avx2
	avx512f:avx512f
	avx512dq:avx512dq
	avx512pf:avx512pf
	avx512vl:avx512vl

)
ARM_CPU_FLAGS=(
	neon:neon
	neon2x:neon2x
)
CPU_FLAGS=(
	${X86_CPU_FLAGS[@]/#/+cpu_flags_x86_}
	${ARM_CPU_FLAGS[@]/#/+cpu_flags_arm_}
)

IUSE+="
${CPU_FLAGS[@]%:*}
doc tbb
"
REQUIRED_USE+="
	|| (
		cpu_flags_arm_neon
		cpu_flags_arm_neon2x
		cpu_flags_x86_sse4_1
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	tbb
	cpu_flags_x86_avx2? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512pf? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
"
DEPEND+="
	!tbb? (
		|| (
			sys-devel/gcc[openmp]
			sys-devel/clang-runtime[openmp]
		)
	)
	tbb? (
		>=dev-cpp/tbb-2017
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.1
"
RESTRICT="mirror"
SRC_URI="
https://github.com/OpenPathGuidingLibrary/openpgl/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV/_/-}"
DOCS=( CHANGELOG.md README.md )

src_configure() {
	local has_sse4="OFF"

	if use cpu_flags_x86_sse4_1 \
		|| use cpu_flags_x86_sse4_2
	then
		has_sse4="ON"
	fi

	# Disable asserts
	append-cppflags $(usex debug '' '-DNDEBUG')

	local mycmakeargs=(
		-DOPENPGL_BUILD_STATIC=OFF
		-DOPENPGL_ISA_NEON=$(usex cpu_flags_arm_neon)
		-DOPENPGL_ISA_NEON2X=$(usex cpu_flags_arm_neon2x)
		-DOPENPGL_ISA_SSE4="${has_sse4}"
		-DOPENPGL_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DOPENPGL_ISA_AVX512=$(usex cpu_flags_x86_avx512f)
		-DOPENPGL_USE_OMP_THREADING=$(usex tbb "OFF" "ON")
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc \
		third-party-programs.txt \
		third-party-programs-Embree.txt \
		third-party-programs-TBB.txt
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  blender-3.4
