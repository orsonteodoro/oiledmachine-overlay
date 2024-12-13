# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# cx-Freeze
# pytorch-triton-rocm
# rife-ncnn-vulkan-python-tntwise
# scenedetect
# tensorrt
# tensorrt_cu12
# tensorrt-cu12_libs
# tensorrt_cu12_bindings
# torch-tensorrt
# upscale-ncnn-py

# U20

#CMAKE_MAKEFILE_GENERATOR="emake"

PYTHON_COMPAT=( "python3_11" )
MY_PN="${PN}-RVE"

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/TNTwise/REAL-Video-Enhancer.git"
	FALLBACK_COMMIT="712631c6840ffd609fe78569a8a7dc84507ca84f" # Nov 10, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
#	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/TNTwise/REAL-Video-Enhancer/archive/refs/tags/RVE-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Interpolate and upscale video easily"
HOMEPAGE="
	https://github.com/TNTwise/REAL-Video-Enhancer
"
LICENSE="
	AGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
REQUIRED_USE="
	|| (
		cuda
		rocm
		tensorrt
		vulkan
	)
"
IUSE+="
cuda rocm tensorrt vulkan wayland X
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
# See https://github.com/TNTwise/REAL-Video-Enhancer/blob/RVE-2.1.0/src/DownloadDeps.py
COMMON_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		dev-python/mpmath[${PYTHON_USEDEP}]
		dev-python/opencv-python-headless[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pypresence[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scenedetect[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/testresources[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
"
CUDA_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cupy-13.3.0[${PYTHON_USEDEP},cuda]
		dev-python/einops[${PYTHON_USEDEP}]
		sci-libs/safetensors[${PYTHON_USEDEP}]
	')
	>=dev-python/pytorch-9999[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/torchvision-9999[${PYTHON_SINGLE_USEDEP}]
"
NCNN_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/ncnn-20240820[${PYTHON_USEDEP}]
		>=dev-python/rife-ncnn-vulkan-python-tntwise-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/sympy-1.13.1[${PYTHON_USEDEP}]
		>=dev-python/upscale-ncnn-py-1.2.0[${PYTHON_USEDEP}]
		dev-python/opencv-python-headless[${PYTHON_USEDEP}]
		dev-python/mpmath[${PYTHON_USEDEP}]
	')
"
ROCM_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/pytorch-triton-rocm-2.3.1[${PYTHON_USEDEP}]
	')
	=sci-libs/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
	sci-libs/pytorch:=
	=sci-libs/torchvision-0.18*[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision:=
"
TENSORRT_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/tensorrt-10.6.0[${PYTHON_USEDEP}]
		>=dev-python/tensorrt_cu12-10.6.0[${PYTHON_USEDEP}]
		>=dev-python/tensorrt-cu12_libs-10.6.0[${PYTHON_USEDEP}]
		>=dev-python/tensorrt_cu12_bindings-10.6.0[${PYTHON_USEDEP}]
		>=dev-python/torch-tensorrt-2.6.0_pre20241023[${PYTHON_USEDEP}]
	')
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/cx-Freeze-7.0.0[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/lief[${PYTHON_USEDEP}]
		dev-python/opencv-python-headless[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
		dev-python/pyinstaller[${PYTHON_USEDEP}]
		dev-python/pypresence[${PYTHON_USEDEP}]
		dev-python/pyside6[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/validators[${PYTHON_USEDEP}]
		net-misc/yt-dlp[${PYTHON_USEDEP}]
	')
	cuda? (
		${COMMON_DEPEND}
		${CUDA_DEPEND}
	)
	rocm? (
		${COMMON_DEPEND}
		${ROCM_DEPEND}
	)
	tensorrt? (
		${COMMON_DEPEND}
		${TENSORRT_DEPEND}
	)
	vulkan? (
		${COMMON_DEPEND}
		${NCNN_DEPEND}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-disable-downloads.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
}

src_compile() {
	${EPYTHON} build.py --build_exe
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
