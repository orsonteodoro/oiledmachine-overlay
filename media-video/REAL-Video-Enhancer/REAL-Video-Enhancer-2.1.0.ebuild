# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# pytorch-triton-rocm
# tensorrt
# tensorrt_cu12
# tensorrt-cu12_libs
# tensorrt_cu12_bindings
# torch-tensorrt

# U20

#CMAKE_MAKEFILE_GENERATOR="emake"

BACKEND_PV="2.0.5"
PYTHON_COMPAT=( "python3_11" )
MODEL_FILES=(
# models_ncnn_interpolate
rife-v4.6.tar.gz
rife-v4.7.tar.gz
rife-v4.15.tar.gz
rife-v4.18.tar.gz
rife-v4.22.tar.gz
rife-v4.22-lite.tar.gz
rife-v4.25.tar.gz

# models_ncnn_upscayl
2x_ModernSpanimationV2.tar.gz
4xNomos8k_span_otf_weak.tar.gz
4xNomos8k_span_otf_medium.tar.gz
4xNomos8k_span_otf_strong.tar.gz
up2x-conservative.tar.gz
up2x-conservative.tar.gz
2x_OpenProteus_Compact_i2_70K.tar.gz
2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.tar.gz
realesr-animevideov3-x2.tar.gz
realesr-animevideov3-x3.tar.gz
realesr-animevideov3-x4.tar.gz
realesrgan-x4plus.tar.gz
realesrgan-x4plus-anime.tar.gz

# models_pytorch_interpolate
GMFSS.pkl
rife4.6.pkl
rife4.7.pkl
rife4.15.pkl
rife4.18.pkl
rife4.22.pkl
rife4.22-lite.pkl
rife4.25.pkl

# models_pytorch_upscayl
2x_ModernSpanimationV2.pth
4xNomos8k_span_otf_weak.pth
4xNomos8k_span_otf_medium.pth
4xNomos8k_span_otf_strong.pth
2x_OpenProteus_Compact_i2_70K.pth
2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.pth
)
MY_PN="${PN}-RVE"

inherit python-single-r1

gen_models_uris() {
	local fn
	for fn in ${MODEL_FILES[@]} ; do
		echo "
https://github.com/TNTwise/real-video-enhancer-models/releases/download/models/${fn}
		"
	done
}

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
	$(gen_models_uris)
https://github.com/TNTwise/REAL-Video-Enhancer/archive/refs/tags/RVE-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/TNTwise/real-video-enhancer-models/releases/download/models/backend-v2.0.5.tar.gz
	-> ${PN}-backend-${BACKEND_PV}.tar.gz
	"
fi

DESCRIPTION="Interpolate for faster framerates and AI upscale video easily"
HOMEPAGE="
	https://github.com/TNTwise/REAL-Video-Enhancer
"
LICENSE="
	AGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# cx-Freeze is currently broken
IUSE+="
cuda rocm tensorrt vulkan wayland X
"
# cuda, rocm, tenssort USE flags are missing dependency packages.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	!cuda
	!rocm
	!tensorrt
	vulkan
	|| (
		cuda
		rocm
		tensorrt
		vulkan
	)
	|| (
		wayland
		X
	)
"
# Dropped dev-python/opencv-python-headless
# See https://github.com/TNTwise/REAL-Video-Enhancer/blob/RVE-2.1.0/src/DownloadDeps.py
COMMON_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		dev-python/mpmath[${PYTHON_USEDEP}]
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
		>=dev-python/ncnn-20240820[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/rife-ncnn-vulkan-python-tntwise-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/sympy-1.13.1[${PYTHON_USEDEP}]
		>=dev-python/upscale-ncnn-py-1.2.0[${PYTHON_USEDEP}]
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
		dev-libs/lief[${PYTHON_USEDEP},python]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
		dev-python/pyinstaller[${PYTHON_USEDEP}]
		dev-python/pypresence[${PYTHON_USEDEP}]
		dev-python/pyside6[${PYTHON_USEDEP},gui,network,qml,quick,widgets]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/validators[${PYTHON_USEDEP}]
		net-misc/yt-dlp[${PYTHON_USEDEP}]
		|| (
			>=dev-python/cx-Freeze-7.0.0[${PYTHON_USEDEP}]
			>=dev-python/cx-Freeze-bin-7.0.0[${PYTHON_USEDEP}]
		)
	')
	dev-qt/qtbase:6[gui,wayland?,widgets,X?]
	dev-qt/qtbase:=
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
# scikit_build_core needs exceptiongroup
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
		dev-python/pyside6-tools[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-disable-downloads.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
einfo "EPYTHON:  ${EPYTHON}"
}

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
	local backends=""
	if use cuda || use rocm ; then
		backends+=",pytorch"
	fi
	if use tensorrt ; then
		backends+=",tensorrt"
	fi
	if use vulkan ; then
		backends+=",ncnn"
	fi

	sed -i -e "s|@BACKENDS_LIST@|[${backends:1}]|g" \
		"REAL-Video-Enhancer.py" \
		|| die

# Fixes:
# sh: line 1: pyside6-uic: command not found
# sh: line 1: pyside6-rcc: command not found
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s \
		"/usr/lib64/qt6/libexec/uic" \
		"${WORKDIR}/bin/pyside6-uic" \
		|| die
	ln -s \
		"/usr/lib64/qt6/libexec/rcc" \
		"${WORKDIR}/bin/pyside6-rcc" \
		|| die
	export PYTHONPATH="/usr/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
einfo "PYTHONPATH:  ${PYTHONPATH}"
	sed -i \
		-e "s|python3.10|${EPYTHON}|g" \
		"build.py" \
		|| die
}

src_compile() {
einfo "EPYTHON:  ${EPYTHON}"
	local args=(
		--build_exe
	)
	${EPYTHON} build.py ${args[@]} || die
	grep -q "Traceback" "${T}/build.log" && die
}

# TODO install models and/or backend to destination

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
