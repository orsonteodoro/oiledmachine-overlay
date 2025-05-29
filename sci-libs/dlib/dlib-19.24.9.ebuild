# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# doc needs a bunch of deps not in portage

CFLAGS_HARDENED_USE_CASES="facial-embedding security-critical sensitive-data untrusted-data" # Biometrics TFA

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
CPU_FLAGS_X86=(
	cpu_flags_x86_avx
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_1
)

inherit cflags-hardened cmake cuda distutils-r1

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SRC_URI="
https://github.com/davisking/dlib/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="https://dlib.net/"
LICENSE="Boost-1.0"
SLOT="0/${PV}"
IUSE="
${CPU_FLAGS_X86[@]}
cblas cuda debug examples ffmpeg gif jpeg lapack mkl png python sqlite test webp X
ebuild_revision_9
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
		png
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	cblas? (
		virtual/cblas
	)
	cuda? (
		dev-libs/cudnn:=
	)
	ffmpeg? (
		media-video/ffmpeg:=[X?]
	)
	gif? (
		media-libs/giflib:=
	)
	jpeg? (
		media-libs/libjpeg-turbo:0
		media-libs/libjpeg-turbo:=
	)
	lapack? (
		virtual/lapack
	)
	mkl? (
		sci-libs/mkl
	)
	png? (
		media-libs/libpng:0
		media-libs/libpng:=
	)
	python? (
		${PYTHON_DEPS}
	)
	sqlite? (
		dev-db/sqlite:3
	)
	webp? (
		media-libs/libwebp:=
	)
	X? (
		x11-libs/libX11
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
		test? (
			dev-python/pip[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	)
"
DOCS=( "docs/README.txt" )
PATCHES=(
	"${FILESDIR}/${PN}-19.24.2-simd-changes.patch"
	"${FILESDIR}/${PN}-19.24.8-disable-upstream-flags.patch"
)

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DDLIB_ENABLE_ASSERTS=$(usex debug)
		-DDLIB_ENABLE_STACK_TRACE=$(usex debug)
		-DDLIB_GIF_SUPPORT=$(usex gif)
		-DDLIB_JPEG_SUPPORT=$(usex jpeg)
		-DDLIB_LINK_WITH_SQLITE3=$(usex sqlite)
		-DDLIB_NO_GUI_SUPPORT=$(usex X OFF ON)
		-DDLIB_PNG_SUPPORT=$(usex png)
		-DDLIB_USE_BLAS=$(usex cblas)
		-DDLIB_USE_CUDA=$(usex cuda)
		-DDLIB_USE_FFMPEG=$(usex ffmpeg)
		-DDLIB_USE_LAPACK=$(usex lapack)
		-DDLIB_WEBP_SUPPORT=$(usex webp)
		-DUSE_AVX_INSTRUCTIONS=$(usex cpu_flags_x86_avx)
		-DUSE_SSE2_INSTRUCTIONS=$(usex cpu_flags_x86_sse2)
		-DUSE_SSE4_INSTRUCTIONS=$(usex cpu_flags_x86_sse4_1)
		-DUSE_AUTO_VECTOR=OFF
	)
	cmake_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	use python && distutils-r1_src_compile
}

src_test() {
	(
		local BUILD_DIR="${BUILD_DIR}/dlib/test"
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" >/dev/null 2>&1 || die
		local CMAKE_USE_DIR="${S}/dlib/test"
		cmake_src_configure
		cmake_build
		./dtest --runall || die "Tests failed"
	)
	use python && distutils-r1_src_test
}

python_test() {
	epytest
}

src_install() {
	cmake_src_install
	use python && distutils-r1_src_install
	if use examples ; then
		dodoc -r "examples"
		docompress -x "/usr/share/doc/${PF}"
	fi
}

pkg_postinst() {
ewarn
ewarn "The selected BLAS or LAPACK should match the vendor."
ewarn
ewarn "sci-libs/blis - For non-Intel CPUs (BLAS)"
ewarn "sci-libs/mkl - For Intel® CPUs/GPUs (BLAS, LAPACK)"
ewarn "sci-libs/openblas - For non-Intel CPUs (BLAS, LAPACK)"
ewarn
	if use lapack ; then
		if cat "/proc/cpuinfo" | grep -q "GenuineIntel" ; then
			if ! eselect lapack show | grep -q "mkl" ; then
ewarn "Run \`eselect lapack set mkl\` to optimize for Intel® CPUs/GPUs."
			fi
		elif cat "/proc/cpuinfo" | grep -q "AuthenticAMD" ; then
			if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for AMD CPUs."
			fi
		else
			if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for ${ARCH}."
			fi
		fi
	fi

	if use cblas ; then
		if cat "/proc/cpuinfo" | grep -q "GenuineIntel" ; then
			if ! eselect blas show | grep -q "mkl" ; then
ewarn "Run \`eselect blas set mkl\` to optimize for Intel® CPUs/GPUs."
			fi
		elif cat "/proc/cpuinfo" | grep -q "AuthenticAMD" ; then
			if has_version "sci-libs/blis" && ! eselect blas show | grep -q "blis" ; then
ewarn "Run \`eselect blas set blis\` to optimize for AMD CPUs."
			fi
			if has_version "sci-libs/openblas" && ! eselect blas show | grep -q "openblas" ; then
ewarn "Run \`eselect blas set openblas\` to optimize for AMD CPUs."
			fi
		else
			if has_version "sci-libs/blis" && ! eselect blas show | grep -q "blis" ; then
ewarn "Run \`eselect blas set blis\` to optimize for ${ARCH}."
			fi
			if has_version "sci-libs/openblas" && ! eselect blas show | grep -q "openblas" ; then
ewarn "Run \`eselect blas set openblas\` to optimize for ${ARCH}"
			fi
		fi
	fi
}
