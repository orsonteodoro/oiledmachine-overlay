# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

ARM_CPU_FLAGS=(
	"neon:neon"
	"neon2x:neon2x"
)
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)
PYTHON_COMPAT=( "python3_12" )
X86_CPU_FLAGS=(
	"avx2:avx2"
	"avx512f:avx512f"
	"avx512bw:avx512bw"
	"avx512cd:avx512cd"
	"avx512dq:avx512dq"
	"avx512vl:avx512vl"
	"bmi:bmi"
	"bmi2:bmi2"
	"f16c:f16c"
	"fma:fma"
	"lzcnt:lzcnt"
	"sse2:sse2"
	"sse4_1:sse4_1"
	"sse4_2:sse4_2"
)
CPU_FLAGS=(
	"${ARM_CPU_FLAGS[@]/#/+cpu_flags_arm_}"
	"${X86_CPU_FLAGS[@]/#/+cpu_flags_x86_}"
)

inherit cmake flag-o-matic python-any-r1 toolchain-funcs libstdcxx-slot

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV/_/-}"
SRC_URI="
https://github.com/OpenPathGuidingLibrary/openpgl/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Implements a set of representations and training algorithms needed to integrate path guiding into a renderer"
LICENSE="
	Apache-2.0
	BSD
"
HOMEPAGE="http://www.openpgl.org/"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS[@]%:*}
debug doc tbb
ebuild_revision_6
"
REQUIRED_USE+="
	tbb
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_sse4_2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_bmi? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_bmi
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
	)
	|| (
		cpu_flags_arm_neon
		cpu_flags_arm_neon2x
		cpu_flags_x86_sse4_1
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
"
RDEPEND+="
	!tbb? (
		|| (
			>=sys-devel/gcc-11[openmp]
			>=llvm-runtimes/clang-runtime-14[openmp]
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021.5.0[${LIBSTDCXX_USEDEP}]
		dev-cpp/tbb:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.22.1
"
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/926890
	#
	# Upstream "solved" this by setting -fno-strict-aliasing themselves.
	# Do not trust with LTO.
	filter-lto

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use cpu_flags_arm_neon && append-flags -flax-vector-conversions

	# Disable asserts
	append-cppflags $(usex debug '' '-DNDEBUG')

	local mycmakeargs=(
		-DOPENPGL_BUILD_STATIC=OFF
		-DOPENPGL_ISA_NEON=$(usex cpu_flags_arm_neon)
		-DOPENPGL_ISA_NEON2X=$(usex cpu_flags_arm_neon2x)
		-DOPENPGL_ISA_SSE4=$(usex cpu_flags_x86_sse4_2)
		-DOPENPGL_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DOPENPGL_ISA_AVX512=$(usex cpu_flags_x86_avx512f)
		-DOPENPGL_USE_OMP_THREADING=$(usex tbb "OFF" "ON")
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc \
		"third-party-programs.txt" \
		"third-party-programs-Embree.txt" \
		"third-party-programs-TBB.txt"
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  blender-3.4
