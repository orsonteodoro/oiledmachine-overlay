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

BACKEND_PV="2.1.5"
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
GMFSS_PRO.pkl
GIMMVFI_RAFT.pth
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

# models_pytorch_denoise
scunet_color_real_psnr.pth
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
	KEYWORDS="~amd64"
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
fp16 cuda rocm tensorrt vulkan wayland X
ebuild-revision-4
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
# Downloaded packages locally but not in lockfile or requirements
MISSING_DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/charset-normalizer-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
		>=dev-python/idna-3.10[${PYTHON_USEDEP}]
		>=dev-python/pbr-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/pip-24.1.2[${PYTHON_USEDEP}]
		>=dev-python/platformdirs-4.3.6[${PYTHON_USEDEP}]
		>=dev-python/portalocker-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-2.2.3[${PYTHON_USEDEP}]
	')
"
# Dropped dev-python/opencv-python-headless
# See https://github.com/TNTwise/REAL-Video-Enhancer/blob/RVE-2.1.0/src/DownloadDeps.py
# Upstream uses numpy 1.26.4
COMMON_DEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
		>=dev-python/mpmath-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
		>=dev-python/pypresence-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		>=dev-python/scenedetect-0.6.5[${PYTHON_USEDEP}]
		>=dev-python/sympy-1.13.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.67.1[${PYTHON_USEDEP}]
		>=dev-python/testresources-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
		>=media-libs/opencv-4.10.0[${PYTHON_USEDEP},ffmpeg,python]
		>=virtual/pillow-11.0.0[${PYTHON_USEDEP}]
	')
"
# Upstream uses pytorch 2.6.0 with cuda 12.6
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
		>=dev-python/mpmath-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/ncnn-20240820[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/rife-ncnn-vulkan-python-tntwise-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/sympy-1.13.1[${PYTHON_USEDEP}]
		>=dev-python/upscale-ncnn-py-1.2.0[${PYTHON_USEDEP}]
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
	${MISSING_DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/certifi-2024.12.14[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/pypresence-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		dev-libs/lief[${PYTHON_USEDEP},python]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
		dev-python/pyinstaller[${PYTHON_USEDEP}]
		dev-python/pyside6[${PYTHON_USEDEP},gui,network,qml,quick,widgets]
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
	|| (
		=media-video/ffmpeg-6.1*:58.60.60
		=media-video/ffmpeg-6.1*:0/58.60.60
		=media-video/ffmpeg-4*:56.58.58
		=media-video/ffmpeg-4*:0/56.58.58
	)
	media-video/ffmpeg:=
"
# Upstream uses FFmpeg 7.0, but changed here for OpenCV
DEPEND+="
	${RDEPEND}
"
# scikit_build_core needs exceptiongroup
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-70.3.0[${PYTHON_USEDEP}]
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
		dev-python/pyside6-tools[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.1.5-disable-downloads.patch"
	"${FILESDIR}/${PN}-2.1.5-move-logs-into-homedir.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
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
		backends+=",\"pytorch\""
	fi
	if use tensorrt ; then
		backends+=",\"tensorrt\""
	fi
	if use vulkan ; then
		backends+=",\"ncnn\""
	fi

	sed -i -e "s|@BACKENDS_LIST@|[${backends:1}]|g" \
		"REAL-Video-Enhancer.py" \
		|| die

	local has_bf16=$(usex fp16 "true" "false")

	sed -i -e "s|@PYTORCH_HALF_PRECISION_SUPPORT@|${has_bf16}|g" \
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

	mkdir -p "${S}/venv/lib/${EPYTHON}/site-packages/PySide6/Qt/libexec" || die

	ln -s \
		"/usr/lib64/qt6/libexec/uic" \
		"${S}/venv/lib/${EPYTHON}/site-packages/PySide6/Qt/libexec/uic" \
		|| die

	ln -s \
		"/usr/lib64/qt6/libexec/rcc" \
		"${S}/venv/lib/${EPYTHON}/site-packages/PySide6/Qt/libexec/rcc" \
		|| die

	export PYTHONPATH="/usr/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
	sed -i \
		-e "s|python3.10|${EPYTHON}|g" \
		"build.py" \
		|| die
}

src_compile() {
	local args=(
		--build_exe
	)
	${EPYTHON} build.py ${args[@]} || die
	grep -q "Traceback" "${T}/build.log" && die "Detected error"
	grep -q "error:" "${T}/build.log" && die "Detected error"
}

src_install() {
	dodir "/usr/bin"
	insinto "/usr/$(get_libdir)/${PN}"
	doins -r  "bin/"*

cat <<EOF > "${ED}/usr/bin/${PN}"
#!/bin/bash
export LD_LIBRARY_PATH="/usr/$(get_libdir)/${PN}/lib"
cd "/usr/$(get_libdir)/${PN}"
"./${PN}" "\$@"
EOF
	fperms 0755 "/usr/bin/${PN}"
	fperms 0755 "/usr/$(get_libdir)/${PN}/${PN}"

	docinto "licenses/freeze"
	dodoc "bin/frozen_application_license.txt"

	local models=(
		"2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k"
		"2x_ModernSpanimationV2"
		"2x_OpenProteus_Compact_i2_70K"
		"4xNomos8k_span_otf_medium"
		"4xNomos8k_span_otf_strong"
		"4xNomos8k_span_otf_weak"
		"realesr-animevideov3-x2"
		"realesr-animevideov3-x3"
		"realesr-animevideov3-x4"
		"realesrgan-x4plus"
		"realesrgan-x4plus-anime"
		"rife-v4.15"
		"rife-v4.18"
		"rife-v4.22"
		"rife-v4.22-lite"
		"rife-v4.25"
		"rife-v4.6"
		"rife-v4.7"
		"up2x-conservative"
	)
	for m in ${models[@]} ; do
		insinto "/usr/$(get_libdir)/${PN}/models"
		doins -r "${WORKDIR}/${m}"
	done

	insinto "/usr/$(get_libdir)/${PN}"
	doins -r "${WORKDIR}/backend"

	dodir "/usr/$(get_libdir)/${PN}/bin"
	if has_version "=media-video/ffmpeg-7.0*:59.61.61" ; then
		dosym \
			"/usr/lib/ffmpeg/59.61.61/bin/ffmpeg" \
			"/usr/$(get_libdir)/${PN}/bin/ffmpeg"
	else
		dosym \
			"/usr/bin/ffmpeg" \
			"/usr/$(get_libdir)/${PN}/bin/ffmpeg"
	fi

	keepdir "/usr/$(get_libdir)/${PN}/custom_models"

	dodir "/usr/$(get_libdir)/${PN}/python/python/bin/"
	dosym "/usr/bin/${EPYTHON}" "/usr/$(get_libdir)/${PN}/python/python/bin/python3"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  fail (2.1.5, 20241217)
# UI load - pass
# convert (with anime 2x upscale) - fail
