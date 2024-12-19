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
MODELS=(
	# models_ncnn_interpolate
	"rife-v4.6.tar.gz;MIT"
	"rife-v4.7.tar.gz;MIT"
	"rife-v4.15.tar.gz;MIT"
	"rife-v4.18.tar.gz;MIT"
	"rife-v4.22.tar.gz;MIT"
	"rife-v4.22-lite.tar.gz;MIT"
	"rife-v4.25.tar.gz;MIT"

	# models_ncnn_upscayl
	"2x_ModernSpanimationV2.tar.gz;AGPL-3"
	"4xNomos8k_span_otf_weak.tar.gz;CC-BY-4.0"
	"4xNomos8k_span_otf_medium.tar.gz;CC-BY-4.0"
	"4xNomos8k_span_otf_strong.tar.gz;CC-BY-4.0"
	"up2x-conservative.tar.gz;MIT"
	"up2x-conservative.tar.gz;MIT"
	"2x_OpenProteus_Compact_i2_70K.tar.gz;CC-BY-NC-4.0"
	"2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.tar.gz;CC-BY-NC-SA-4.0"
	"realesr-animevideov3-x2.tar.gz;BSD"
	"realesr-animevideov3-x3.tar.gz;BSD"
	"realesr-animevideov3-x4.tar.gz;BSD"
	"realesrgan-x4plus.tar.gz;BSD"
	"realesrgan-x4plus-anime.tar.gz;BSD"

	# models_pytorch_interpolate
	"GMFSS.pkl;MIT"
	"GMFSS_PRO.pkl;MIT"
	"GIMMVFI_RAFT.pth;BSD"
	"rife4.6.pkl;MIT"
	"rife4.7.pkl;MIT"
	"rife4.15.pkl;MIT"
	"rife4.18.pkl;MIT"
	"rife4.22.pkl;MIT"
	"rife4.22-lite.pkl;MIT"
	"rife4.25.pkl;MIT"

	# models_pytorch_upscayl
	"2x_ModernSpanimationV2.pth;AGPL-3"
	"4xNomos8k_span_otf_weak.pth;CC-BY-4.0"
	"4xNomos8k_span_otf_medium.pth;CC-BY-4.0"
	"4xNomos8k_span_otf_strong.pth;CC-BY-4.0"
	"2x_OpenProteus_Compact_i2_70K.pth;CC-BY-NC-4.0"
	"2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.pth;CC-BY-NC-SA-4.0"

	# models_pytorch_denoise
	"scunet_color_real_psnr.pth;Apache-2.0"
)
MY_PN="${PN}-RVE"

inherit python-single-r1

get_model_use() {
	local fn="${1}"
	local id="${fn}"
	id="${id/.pkl}"
	id="${id/.tar.gz}"
	id="${id/pth}"
	id="${id/./_}"
	if [[ "${id}" =~ "_"$ ]] ; then
		id="${id::-1}"
	fi
	echo "rve_models_${id}"
}

gen_models_iuse() {
	local row
	for row in ${MODELS[@]} ; do
		local fn="${row%;*}"
		local u=$(get_model_use "${fn}")
		echo "${u}"
	done
}
IUSE_MODELS=(
	$(gen_models_iuse)
)
IUSE+="${IUSE_MODELS[@]}"

gen_models_uris() {
	local row
	for row in ${MODELS[@]} ; do
		local fn="${row%;*}"
		local u=$(get_model_use "${fn}")
		echo "
			${u}? (
https://github.com/TNTwise/real-video-enhancer-models/releases/download/models/${fn}
			)
		"
	done
}

gen_models_license() {
	local row
	for row in ${MODELS[@]} ; do
		local fn="${row%;*}"
		local license="${row#*;}"
		local u=$(get_model_use "${fn}")
		echo "
			${u}? (
				${license}
			)
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
#	KEYWORDS="~amd64" # Process video still broken
	S="${WORKDIR}/${MY_PN}-${PV}"
	S_BACKEND="${WORKDIR}/backend"
	SRC_URI="
	${MODELS_URI}
	$(gen_models_uris)
https://github.com/TNTwise/REAL-Video-Enhancer/archive/refs/tags/RVE-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/TNTwise/real-video-enhancer-models/releases/download/models/backend-v${BACKEND_PV}.tar.gz
	-> ${PN}-backend-${BACKEND_PV}.tar.gz
	"
fi

DESCRIPTION="Interpolate for faster framerates and AI upscale video easily"
HOMEPAGE="
	https://github.com/TNTwise/REAL-Video-Enhancer
"
LICENSE="
	$(gen_models_license)
	AGPL-3
	MIT
"
# AGPL-3 - ModernSpanimationV2 (Under the penumbra of the repo license or this software's license, but V1 was MIT)
# Apache-2.0 - scunet_color_real_psnr.pth
# BSD - GIMM
# BSD - realesrgan-x4plus*
# BSD - realesrgan-x4plus-anime*
# BSD - realesr-animevideov3-x*.tar.gz
# CC-BY-4.0 - 4xNomos8k_span*
# CC-BY-NC-4.0 - OpenProteus
# CC-BY-NC-SA-4.0 - 2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.pth
# CC-BY-NC-SA-4.0 - 2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.tar.gz
# MIT - Feather icons
# MIT - GMFSS
# MIT - RealCUGAN Pro up2x-conservative.tar.gz
# MIT - rife-v*.tar.gz
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# cx-Freeze is currently broken
IUSE+="
fp16 cuda rocm svt-av1 tensorrt vpx vulkan wayland X x264 x265
ebuild-revision-13
"
# cuda, rocm, tenssort USE flags are missing dependency packages.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	!cuda
	!rocm
	!tensorrt
	vulkan
	|| (
		svt-av1
		vpx
		x264
		x265
	)
	|| (
		${IUSE_MODELS[@]}
	)
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
		=media-video/ffmpeg-6.1*:58.60.60[encode,svt-av1?,vpx?,x264?,x265?]
		=media-video/ffmpeg-6.1*:0/58.60.60[encode,svt-av1?,vpx?,x264?,x265?]
		=media-video/ffmpeg-4*:56.58.58[encode,svt-av1?,vpx?,x264?,x265?]
		=media-video/ffmpeg-4*:0/56.58.58[encode,svt-av1?,vpx?,x264?,x265?]
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
RVE_PATCHES=(
	"${FILESDIR}/${PN}-2.1.5-disable-downloads.patch"
	"${FILESDIR}/${PN}-2.1.5-move-logs-into-homedir.patch"
	"${FILESDIR}/${PN}-2.1.5-default-encoders.patch"
)
BACKEND_PATCHES=(
	"${FILESDIR}/${PN}-2.1.5-backend-move-logs-into-homedir.patch"
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

	pushd "${S}" >/dev/null 2>&1 || die
		eapply ${RVE_PATCHES[@]}
	popd >/dev/null 2>&1 || die

	pushd "${S_BACKEND}" >/dev/null 2>&1 || die
		eapply ${BACKEND_PATCHES[@]}
	popd >/dev/null 2>&1 || die

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

	local default_encoder=""
	local allowed_encoders=""
	  if use x264 ; then
		default_encoder="libx264"
	elif use x265 ; then
		default_encoder="libx265"
	elif use vpx ; then
		default_encoder="vp9"
	elif use svt-av1 ; then
		default_encoder="av1"
	else
eerror "You must pick a video encoder."
		die
	fi
	if use x264 ; then
		allowed_encoders+=", \"libx264\""
	fi
	if use x265 ; then
		allowed_encoders+=", \"libx265\""
	fi
	if use vpx ; then
		allowed_encoders+=", \"vp9\""
	fi
	if use svt-av1 ; then
		allowed_encoders+=", \"av1\""
	fi

	sed -i \
		-e "s|@DEFAULT_ENCODER@|${default_encoder}|g" \
		-e "s|@ALLOWED_ENCODERS@|${allowed_encoders:1}|g" \
		"backend/src/RenderVideo.py" \
		"src/ui/SettingsTab.py" \
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

	local workdir_models=(
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
	local distdir_models=(
		"GMFSS.pkl"
		"GMFSS_PRO.pkl"
		"GIMMVFI_RAFT.pth"
		"rife4.6.pkl"
		"rife4.7.pkl"
		"rife4.15.pkl"
		"rife4.18.pkl"
		"rife4.22.pkl"
		"rife4.22-lite.pkl"
		"rife4.25.pkl"

		"2x_ModernSpanimationV2.pth"
		"4xNomos8k_span_otf_weak.pth"
		"4xNomos8k_span_otf_medium.pth"
		"4xNomos8k_span_otf_strong.pth"
		"2x_OpenProteus_Compact_i2_70K.pth"
		"2x_AnimeJaNai_HD_V3_Sharp1_Compact_430k.pth"

		"scunet_color_real_psnr.pth"
	)
	for m in ${workdir_models[@]} ; do
		local u=$(get_model_use "${m}")
		if use "${u}" ; then
			insinto "/usr/$(get_libdir)/${PN}/models"
			doins -r "${WORKDIR}/${m}"
		fi
	done

	for m in ${distdir_models[@]} ; do
		local u=$(get_model_use "${m}")
		if use "${u}" ; then
			insinto "/usr/$(get_libdir)/${PN}/models"
			doins $(realpath "${DISTDIR}/${m}")
		fi
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
# OILEDMACHINE-OVERLAY-TEST:  passed (2.1.5, 20241218)
# UI load - pass
# Upscale (with AnimeVideoV3 2x) - pass
# Vulkan (ncnn) - pass
