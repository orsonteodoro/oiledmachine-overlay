# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# We use partial offline to avoid "argument list too long" for go modules.
# We don't use go-module but just sandbox changes.

# TODO package:
# upx-ucl

inherit hip-versions

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx940
	gfx941
	gfx942
	gfx90a
	gfx1030
	gfx1031
	gfx1100
	gfx1101
)
#
# To update use this run `ebuild ollama-0.4.2.ebuild digest clean unpack`
# changing GEN_EBUILD with the following transition states 0 -> 1 -> 2 -> 0
#
GEN_EBUILD=0
GRPC_PROTOBUF_PAIRS=(
	"1.65:5.26"
)
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOTS=(
	"${HIP_5_5_VERSION}"
)

BARK_CPP_PV="1.0.0"
ENCODEC_CPP_COMMIT="05513e7f03d8d349734a2b7a47b2e9921f0adeb0" # For bark.cpp
ESPEAK_NG_COMMIT="8593723f10cfd9befd50de447f14bf0a9d2a14a4" # For go-piper
GGML_COMMIT_1="aa00e1676417d8007dbaa47d2ee1a6e06c60d546" # For bark.cpp/encodec.cpp
GGML_COMMIT_2="dddef738b2d5a95323188ed019877d4e20568b7e" # For stable-diffusion.cpp
ONNXRUNTIME_PV="1.20.0"
GO_PIPER_COMMIT="e10ca041a885d4a8f3871d52924b47792d5e5aa0"
KOMPUTE_COMMIT="4565194ed7c32d1d2efa32ceab4d3c6cae006306" # For llama.cpp
LLAMA_CPP_COMMIT="d6d2c2ab8c8865784ba9fef37f2b2de3f2134d33"
PIPER_COMMIT="0987603ebd2a93c3c14289f3914cd9145a7dddb5" # For go-piper
PIPER_PHONEMIZE_COMMIT="fccd4f335aa68ac0b72600822f34d84363daa2bf" # For go-piper
STABLE_DIFFUSION_CPP_COMMIT="53e3b17eb3d0b5760ced06a1f98320b68b34aaae"
WHISPER_CPP_COMMIT="6266a9f9e56a5b925e9892acf650f3eb1245814d"

inherit dep-prepare edo python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mudler/LocalAI.git"
	FALLBACK_COMMIT="e495b89f18412c77a0d05422cab03d39511d67cd" # Apr 19, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	#go-module_set_globals

	if [[ "${GEN_EBUILD}" != "1" ]] ; then
		SRC_URI+="
			${EGO_SUM_SRC_URI}
		"
	fi
	SRC_URI+="
https://github.com/ggml-org/ggml/archive/${GGML_COMMIT_1}.tar.gz
	-> ggml-${GGML_COMMIT_1:0:7}.tar.gz
https://github.com/ggml-org/ggml/archive/${GGML_COMMIT_2}.tar.gz
	-> ggml-${GGML_COMMIT_2:0:7}.tar.gz
https://github.com/ggml-org/llama.cpp/archive/${LLAMA_CPP_COMMIT}.tar.gz
	-> llama-cpp-${LLAMA_CPP_COMMIT:0:7}.tar.gz
https://github.com/ggml-org/whisper.cpp/archive/${WHISPER_CPP_COMMIT}.tar.gz
	-> whisper-cpp-${WHISPER_CPP_COMMIT:0:7}.tar.gz
https://github.com/mudler/go-piper/archive/${GO_PIPER_COMMIT}.tar.gz
	-> go-piper-${GO_PIPER_COMMIT:0:7}.tar.gz
https://github.com/mudler/LocalAI/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/nomic-ai/kompute/archive/${KOMPUTE_COMMIT}.tar.gz
	-> kompute-${KOMPUTE_COMMIT:0:7}.tar.gz
https://github.com/PABannier/bark.cpp/archive/refs/tags/v${BARK_CPP_PV}.tar.gz
	-> bark-cpp-${BARK_CPP_PV}.tar.gz
https://github.com/PABannier/encodec.cpp/archive/${ENCODEC_CPP_COMMIT}.tar.gz
	-> encodec-cpp-${ENCODEC_CPP_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/piper/archive/${PIPER_COMMIT}.tar.gz
	-> piper-${PIPER_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/espeak-ng/archive/${ESPEAK_NG_COMMIT}.tar.gz
	-> rhasspy-espeak-ng-${ESPEAK_NG_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/piper-phonemize/archive/${PIPER_PHONEMIZE_COMMIT}.tar.gz
	-> piper-phonemize-${PIPER_PHONEMIZE_COMMIT:0:7}.tar.gz
https://github.com/richiejp/stable-diffusion.cpp/archive/${STABLE_DIFFUSION_CPP_COMMIT}.tar.gz
	-> richiejp-stable-diffusion-cpp-${STABLE_DIFFUSION_CPP_COMMIT:0:7}.tar.gz
	amd64? (
https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_PV}/onnxruntime-linux-x64-${ONNXRUNTIME_PV}.tgz
	)
	arm64? (
https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_PV}/onnxruntime-linux-aarch64-${ONNXRUNTIME_PV}.tgz
	)
	"
fi

DESCRIPTION="A REST API featuring integrated WebUI, P2P inference, generation of text, audio, video, images, voice cloning"
HOMEPAGE="
	https://github.com/mudler/LocalAI
	https://localai.io/
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
ci cuda debug devcontainer openblas opencl p2p rocm sycl-f16 sycl-f32 tts vulkan
"
REQUIRED_USE="
	$()
	!ci
	!devcontainer
	?? (
		cuda
		opencl
		rocm
		sycl-f16
		sycl-f32
	)
	rocm? (
		|| (
			${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
	)
"
gen_grpc_rdepend() {
	local row
	for row in ${GRPC_PROTOBUF_PAIRS[@]} ; do
		local grpc_pv="${row%:*}"
		local protobuf_pv="${row#*:}"
		echo "
			(
				=net-libs/grpc-${grpc_pv}*
				=dev-libs/protobuf-${protobuf_pv}*
			)
		"
	done
}
#	>=media-video/ffmpeg-6.1.1:0/58.60.60 is relaxed
gen_rocm_rdepend() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			(
				~sci-libs/hipBLAS-${s}
				~sci-libs/rocBLAS-${s}
			)
		"
	done
}
RDEPEND+="
	(
		>=media-video/ffmpeg-6.1.1
		media-video/ffmpeg:=
	)
	>=app-accessibility/espeak-ng-1.51
	cuda? (
		=dev-util/nvidia-cuda-toolkit-12*
		dev-util/nvidia-cuda-toolkit:=
	)
	openblas? (
		>=sci-libs/openblas-0.3.26
	)
	rocm? (
		|| (
			$(gen_rocm_rdepend)
		)
		sci-libs/hipBLAS:=
		sci-libs/rocBLAS:=
	)
	vulkan? (
		>=media-libs/vulkan-loader-1.3.275.0
		>=sys-apps/pciutils-3.10.0
	)
	|| (
		$(gen_grpc_rdepend)
	)
	dev-libs/protobuf:=
	net-libs/grpc:=
"
DEPEND+="
	${RDEPEND}
	vulkan? (
		>=dev-util/vulkan-headers-1.3.275.0
		dev-util/vulkan-headers:=
	)
"
# iputils, rhash, wget are for custom downloader in src_unpack() only.
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.26.4
	>=dev-lang/go-1.22.6
	app-crypt/rhash
	net-misc/iputils
	net-misc/wget
	ci? (
		app-crypt/gnupg
		app-misc/ca-certificates
		dev-libs/openssl
		dev-python/pip
		dev-vcs/git
		dev-vcs/git-lfs
		net-misc/curl
	)
	devcontainer? (
		sys-apps/less
		net-misc/wget
		virtual/ssh
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.28.0-offline-install.patch"
)

# @FUNCTION: _check_network_sandbox
# @DESCRIPTION:
# Check if sandbox is more lax when downloading in unpack phase
_check_network_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download go micropackages."
eerror
		die
	fi
}

pkg_setup() {
ewarn "This ebuild is still in development"
	python_setup
	_check_network_sandbox
}

gen_unpack() {
einfo "Replace EGO_SUM contents with the following:"
	IFS=$'\n'
	local path
	local rows
	for path in $(find "${WORKDIR}" -name "go.sum") ; do
		for rows in $(cat "${path}" | cut -f 1-2 -d " ") ; do
			echo -e "\t\t\"${rows}\""
		done
	done
	IFS=$' \t\n'
	die
}

_setup_go_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local cache_path_actual="${EDISTDIR}/go-cache/${CATEGORY}/${PN}"
	local modcache_path_actual="${EDISTDIR}/go-modcache/${CATEGORY}/${PN}"
	export GOCACHE="${cache_path_actual}"
	export GOMODCACHE="${modcache_path_actual}"
	addwrite "${EDISTDIR}"

	mkdir -p "${cache_path_actual}"
	addwrite "${cache_path_actual}"

	mkdir -p "${modcache_path_actual}"
	addwrite "${modcache_path_actual}"
	go env
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		_setup_go_offline_cache
		unpack ${A}
	fi
}

src_prepare() {
	default
	# S_GO should appear at this point
	dep_prepare_mv "${WORKDIR}/bark.cpp-${BARK_CPP_PV}" "${S}/sources/bark.cpp"
	dep_prepare_mv "${WORKDIR}/encodec.cpp-${ENCODEC_CPP_COMMIT}" "${S}/sources/bark.cpp/encodec.cpp"
	dep_prepare_mv "${WORKDIR}/ggml-${GGML_COMMIT_1}" "${S}/sources/bark.cpp/encodec.cpp/ggml"

	dep_prepare_mv "${WORKDIR}/stable-diffusion.cpp-${STABLE_DIFFUSION_CPP_COMMIT}" "${S}/sources/stablediffusion-ggml.cpp"
	dep_prepare_mv "${WORKDIR}/ggml-${GGML_COMMIT_2}" "${S}/sources/stablediffusion-ggml.cpp/ggml"

	dep_prepare_mv "${WORKDIR}/go-piper-${GO_PIPER_COMMIT}" "${S}/sources/go-piper"
	dep_prepare_mv "${WORKDIR}/espeak-ng-${ESPEAK_NG_COMMIT}" "${S}/sources/go-piper/espeak"
	dep_prepare_mv "${WORKDIR}/piper-${PIPER_COMMIT}" "${S}/sources/go-piper/piper"
	dep_prepare_mv "${WORKDIR}/piper-phonemize-${PIPER_PHONEMIZE_COMMIT}" "${S}/sources/go-piper/piper-phonemize"

	dep_prepare_mv "${WORKDIR}/whisper.cpp-${WHISPER_CPP_COMMIT}" "${S}/sources/whisper.cpp"

	dep_prepare_mv "${WORKDIR}/llama.cpp-${LLAMA_CPP_COMMIT}" "${S}/backend/cpp/llama/llama.cpp"
	dep_prepare_mv "${WORKDIR}/kompute-${KOMPUTE_COMMIT}" "${S}/backend/cpp/llama/llama.cpp/ggml/src/ggml-kompute/kompute"

	#local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	mkdir -p "${S}/sources/onnxruntime" || die
	if [[ "${ARCH}" == "amd64" ]] ; then
		cat \
			"${DISTDIR}/onnxruntime-linux-x64-${ONNXRUNTIME_PV}.tgz" \
			> \
			"${S}/sources/onnxruntime/onnxruntime-linux-x64-${ONNXRUNTIME_PV}.tgz" \
			|| die
	elif [[ "${ARCH}" == "arm64" ]] ; then
		cat \
			"${DISTDIR}/onnxruntime-linux-aarch64-${ONNXRUNTIME_PV}.tgz" \
			> \
			"${S}/sources/onnxruntime/onnxruntime-linux-aarch64-${ONNXRUNTIME_PV}.tgz" \
			|| die
	fi
}



src_compile() {
	_setup_go_offline_cache
	local go_tags=()
	use debug && go_tags+=( "debug" )
	use p2p && go_tags+=( "p2p" )
	if use debug || use p2p || use tts ; then
		:
	else
		go_tags+=( "none" )
	fi

	local build_type
	if use cuda ; then
		build_type="cublas"
	elif use opencl ; then
		build_type="clblas"
	elif use rocm ; then
		build_type="hipblas"
	elif use sycl-f16 ; then
		build_type="sycl_f16"
	elif use sycl-f32 ; then
		build_type="sycl_f32"
	fi

	emake \
		BUILD_TYPE="${build_type[@]}" \
		GO_TAGS="${go_tags[@]}" \
		OFFLINE="true" \
		build
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
