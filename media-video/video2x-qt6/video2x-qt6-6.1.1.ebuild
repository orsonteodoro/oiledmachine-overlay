# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

GLSLANG_COMMIT_1="4afd69177258d0636f78d2c4efb823ab6382a187"
GLSLANG_COMMIT_2="4420f9b33ba44928d5c82d9eae0c3bb4d5674c05"
LIBREALESRGAN_NCNN_VULKAN="790b1468acfcbfe6476febee9210cad7ba72e3f7"
NCNN_COMMIT_1="6125c9f47cd14b589de0521350668cf9d3d37e3c"
NCNN_COMMIT_2="9b5f6a39b4a4962accaad58caa771487f61f732a"
PYBIND11_COMMIT_1="70a58c577eaf067748c2ec31bfd0b0a614cffba6"
PYBIND11_COMMIT_2="3e9dfa2866941655c56877882565e7577de6fc7b"
VIDEO2K_COMMIT="56afd0e6292d89f7821a44bc6d7ea4841566cc56"

PYTHON_COMPAT=( "python3_12" )

inherit cmake dep-prepare flag-o-matic python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/k4yt3x/video2x-qt6.git"
	FALLBACK_COMMIT="abb3ee2ed71291ec3dbebc74d123279518cd634e" # Nov 7, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
#	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/k4yt3x/librealesrgan-ncnn-vulkan/archive/${LIBREALESRGAN_NCNN_VULKAN}.tar.gz
	-> librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN}.tar.gz
https://github.com/k4yt3x/video2x-qt6/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/k4yt3x/video2x/archive/${VIDEO2K_COMMIT}.tar.gz
	-> video2x-${VIDEO2K_COMMIT}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_1}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_2}.tar.gz
	-> ncnn-${NCNN_COMMIT_2}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_1}.tar.gz
	-> ncnn-${NCNN_COMMIT_1}.tar.gz
	"
fi

DESCRIPTION="A GUI for Video2X written in Python with Qt 6"
HOMEPAGE="
	https://github.com/k4yt3x/video2x-qt6
"
LICENSE="
	(
		BSD
		BSD-2
		ZLIB
	)
	(
		Apache-2.0
		BSD
		BSD-2
		custom
		GPL-3-with-special-bison-exception
		MIT
	)
	AGPL-3
	BSD
	ISC
	MIT
"
# ISC video2x-qt6
# AGPL-3 - video2x
# Apache-2.0 BSD BSD-2 custom GPL-3-with-special-bison-exception MIT - glslang
# BSD BSD-2 ZLIB - ncnn
# BSD - pybind11
# MIT - librealesrgan-ncnn-vulkan
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" -system-ncnn wayland X"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
RDEPEND+="
	>=dev-libs/spdlog-1.12.0
	>=media-libs/vulkan-loader-1.3.275.0
	dev-qt/qttools:6[linguist]
	dev-qt/qttools:=
	dev-qt/qtbase:6[gui,widgets,wayland?,X?]
	dev-qt/qtbase:=
	media-libs/libplacebo[glslang,vulkan]
	system-ncnn? (
		>=dev-libs/ncnn-20240924[openmp,vulkan]
	)
	|| (
		media-video/ffmpeg:58.60.60[libplacebo,x264]
		media-video/ffmpeg:0/58.60.60[libplacebo,x264]
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-1.3.275.0
"
BDEPEND+="
	>=dev-build/cmake-3.14
	sys-devel/gcc[openmp]
	virtual/pkgconfig
"
#	[${PYTHON_USEDEP}]
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/video2x-${VIDEO2K_COMMIT}" "${S}/third_party/video2x"

		dep_prepare_mv "${WORKDIR}/librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN}" "${S}/third_party/video2x/third_party/librealesrgan-ncnn-vulkan"
		dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_1}" "${S}/third_party/video2x/third_party/librealesrgan-ncnn-vulkan/src/ncnn"
		dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/third_party/video2x/third_party/librealesrgan-ncnn-vulkan/src/ncnn/glslang"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/third_party/video2x/third_party/librealesrgan-ncnn-vulkan/python/pybind11"

		dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_2}" "${S}/third_party/video2x/third_party/ncnn"
		dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/video2x/third_party/ncnn/src/ncnn/glslang"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/video2x/third_party/ncnn/python/pybind11"
	fi
}

src_configure() {
	# Force GCC to simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	local mycmakeargs=(
		-DUSE_SYSTEM_NCNN=$(usex system-ncnn)
	)
	cmake_src_configure
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
