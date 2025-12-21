# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# We use partial offline to avoid "argument list too long" for go modules.
# We don't use go-module but just sandbox changes.

# TODO package:
# accelerate
# bark
# gguf
# mlx-audio
# piper-phonemize
# upx-ucl

# TODO:
# Change build files to make kleidai offline install.

MY_PN2="local-ai"

#
# To update use this run `ebuild ollama-0.4.2.ebuild digest clean unpack`
# changing GEN_EBUILD with the following transition states 0 -> 1 -> 2 -> 0
#
GEN_EBUILD=0

ABSEIL_CPP_SLOT="20240722" # The abseil-cpp version is the same used by same Protobuf slot for all of the backends.
CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="daemon security-critical server"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE"
GRPC_SLOT="5" # Same as the backends.  Ignore the /Makefile
PROTOBUF_CPP_SLOT="5"
PROTOBUF_PYTHON_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..12} )
RE2_SLOT="20250512"

ONNXRUNTIME_PV="1.20.0" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/go/silero-vad/Makefile#L5

BARK_CPP_COMMIT="5d5be84f089ab9ea53b7a793f088d3fbf7247495" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/go/bark-cpp/Makefile#L15
ENCODEC_CPP_COMMIT="1cc279db4da979455651fbac1cbd151a2d121609" # For bark.cpp, from https://github.com/PABannier/bark.cpp/tree/5d5be84f089ab9ea53b7a793f088d3fbf7247495
ESPEAK_NG_COMMIT="8593723f10cfd9befd50de447f14bf0a9d2a14a4" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
GGML_COMMIT_1="c18f9baeea2f3aea1ffc4afa4ad4496e51b7ff8a" # For bark.cpp/encodec.cpp, from https://github.com/PABannier/encodec.cpp/tree/1cc279db4da979455651fbac1cbd151a2d121609
GGML_COMMIT_2="5fdc78fff274094e2a1b155928131983362d8a71" # For stable-diffusion.cpp, from https://github.com/leejet/stable-diffusion.cpp/tree/0ebe6fe118f125665939b27c89f34ed38716bff8
GO_PIPER_COMMIT="e10ca041a885d4a8f3871d52924b47792d5e5aa0" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/go/piper/Makefile#L4
LLAMA_CPP_COMMIT="583cb83416467e8abf9b37349dcf1f6a0083745a" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/cpp/llama-cpp/Makefile#L2
PIPER_COMMIT="0987603ebd2a93c3c14289f3914cd9145a7dddb5" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
PIPER_PHONEMIZE_COMMIT="fccd4f335aa68ac0b72600822f34d84363daa2bf" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
STABLE_DIFFUSION_CPP_COMMIT="0ebe6fe118f125665939b27c89f34ed38716bff8" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/go/stablediffusion-ggml/Makefile#L22
WHISPER_CPP_COMMIT="19ceec8eac980403b714d603e5ca31653cd42a3f" # From https://github.com/mudler/LocalAI/blob/v3.8.0/backend/go/whisper/Makefile#L9

# Yes the Protobuf situation is a mess.
# Protobuf 6 needed by go-tools (protoc-gen-go@v1.34.2, protoc-gen-go-grpc@1958fcb) in https://github.com/mudler/LocalAI/blob/v3.8.0/Makefile#L267

# Protobuf 5
CPP_BACKENDS=(
	"llama-cpp"
)

# Protobuf 5
GOLANG_BACKENDS=(
	"bark-cpp"
	"huggingface"
	"local-store"
	"piper"
	"silero-vad"
	"stablediffusion-ggml"
	"whisper"
)

# Protobuf 5
PYTHON_BACKENDS=(
	# From backend/python
	"bark"
	"chatterbox"
	"coqui"
	"diffusers"
	"exllama2"
	"faster-whisper"
	"kitten-tts"
	"kokoro"
	"mlx"
	"mlx-audio"
	"mlx-vlm"
	"neutts"
	"rerankers"
	"rfdetr"
	"transformers"
	"vllm"
)

inherit hip-versions

AMDGPU_TARGETS_COMPAT=(
	"gfx900"
	"gfx906"
	"gfx908"
	"gfx940"
	"gfx941"
	"gfx942"
	"gfx90a"
	"gfx1030"
	"gfx1031"
	"gfx1100"
	"gfx1101"
)

CPU_FLAGS_ARM=(
	"cpu_flags_arm_dotprod"
	"cpu_flags_arm_i8mm"
	"cpu_flags_arm_sme"
)

CPU_FLAGS_LOONG=(
	"cpu_flags_loong_lasx"
	"cpu_flags_loong_lsx"
)

CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_rvv"
	"cpu_flags_riscv_rv_zfh"
)

CPU_FLAGS_S390=(
	"cpu_flags_s390_vxe"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_amx_bf16"
	"cpu_flags_x86_amx_int8"
	"cpu_flags_x86_amx_tile"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512_vbmi"
	"cpu_flags_x86_avx512_vnni"
	"cpu_flags_x86_avx512_bf16"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_avx_vnni"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_sse4_2"
)

EGO_SUM=(
)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_4[@]}"
)

ROCM_SLOTS=(
	"${HIP_6_4_VERSION}"
)

inherit abseil-cpp cflags-hardened dep-prepare desktop edo flag-o-matic go-download-cache
inherit grpc protobuf python-single-r1 re2 sandbox-changes toolchain-funcs xdg

#
# Used go-download-cache to avoid:
# OSError: [Errno 7] Argument list too long: '/usr/local/bin/wget'
#
# The go-download-cache eclass works like the npm eclass, storing
# the downloads in the distdir folder.
#

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mudler/LocalAI.git"
	FALLBACK_COMMIT="d6274eaf4ab0bf10fb130ec5e762c73ae6ea3feb" # Aug 4, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
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
https://github.com/PABannier/bark.cpp/archive/${BARK_CPP_COMMIT}.tar.gz
	-> bark-cpp-${BARK_CPP_COMMIT:0:7}.tar.gz
https://github.com/PABannier/encodec.cpp/archive/${ENCODEC_CPP_COMMIT}.tar.gz
	-> encodec-cpp-${ENCODEC_CPP_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/piper/archive/${PIPER_COMMIT}.tar.gz
	-> piper-${PIPER_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/espeak-ng/archive/${ESPEAK_NG_COMMIT}.tar.gz
	-> rhasspy-espeak-ng-${ESPEAK_NG_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/piper-phonemize/archive/${PIPER_PHONEMIZE_COMMIT}.tar.gz
	-> piper-phonemize-${PIPER_PHONEMIZE_COMMIT:0:7}.tar.gz
https://github.com/leejet/stable-diffusion.cpp/archive/${STABLE_DIFFUSION_CPP_COMMIT}.tar.gz
	-> leejet-stable-diffusion-cpp-${STABLE_DIFFUSION_CPP_COMMIT:0:7}.tar.gz
	amd64? (
https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_PV}/onnxruntime-linux-x64-${ONNXRUNTIME_PV}.tgz
	)
	arm64? (
https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_PV}/onnxruntime-linux-aarch64-${ONNXRUNTIME_PV}.tgz
	)
	"
fi

DESCRIPTION="A self hosted local AI alternative with text, audio, speech, video, images, voice cloning, WebUI, REST API, P2P inferencing support"
HOMEPAGE="
	https://localai.io/
	https://github.com/mudler/LocalAI
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPP_BACKENDS[@]/#/localai_backends_}
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
${GOLANG_BACKENDS[@]/#/localai_backends_}
${PYTHON_BACKENDS[@]/#/localai_backends_}
ci cuda debug devcontainer native openblas opencl openrc p2p rag rocm stt
sycl-f16 sycl-f32 systemd tts vulkan
ebuild_revision_28
"
REQUIRED_USE="
	!ci
	!devcontainer
	?? (
		cuda
		opencl
		rocm
		sycl-f16
		sycl-f32
	)
	amd64? (
		^^ (
			native
			cpu_flags_x86_sse4_2
		)
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_x86_bmi2? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
		cpu_flags_x86_fma
	)
	cpu_flags_x86_avx_vnni? (
		cpu_flags_x86_avx2
		cpu_flags_x86_bmi2
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)

	cpu_flags_x86_avx512_vnni? (
		cpu_flags_x86_avx512bw
	)
	cpu_flags_x86_avx512_vbmi? (
		cpu_flags_x86_avx512bw
	)
	cpu_flags_x86_avx512_bf16? (
		cpu_flags_x86_avx512_vnni
	)

	cpu_flags_x86_amx_bf16? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
	)
	cpu_flags_x86_amx_int8? (
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_tile
	)
	cpu_flags_x86_amx_tile? (
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
	)
	localai_backends_mlx-audio? (
		localai_backends_mlx
	)
	localai_backends_mlx-vlm? (
		localai_backends_mlx
	)
	rag? (
		localai_backends_local-store
		localai_backends_rerankers
		|| (
			localai_backends_huggingface
			localai_backends_llama-cpp
		)
		|| (
			localai_backends_exllama2
			localai_backends_huggingface
			localai_backends_llama-cpp
			localai_backends_mlx
			localai_backends_transformers
			localai_backends_vllm
		)
	)
	stt? (
		localai_backends_silero-vad
		|| (
			localai_backends_faster-whisper
			localai_backends_whisper
		)
	)
	tts? (
		|| (
			localai_backends_bark
			localai_backends_bark-cpp
			localai_backends_chatterbox
			localai_backends_coqui
			localai_backends_kitten-tts
			localai_backends_kokoro
			localai_backends_mlx-audio
			localai_backends_neutts
			localai_backends_piper
		)
	)
	rocm? (
		|| (
			${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
	)
	|| (
		openrc
		systemd
	)
	|| (
		localai_backends_diffusers
		localai_backends_exllama2
		localai_backends_huggingface
		localai_backends_llama-cpp
		localai_backends_mlx
		localai_backends_mlx-vlm
		localai_backends_rfdetr
		localai_backends_stablediffusion-ggml
		localai_backends_transformers
		localai_backends_vllm
	)
"
gen_rocm_rdepend() {
	local s
	for s in "${ROCM_SLOTS[@]}" ; do
		echo "
			(
				~sci-libs/hipBLAS-${s}
				~sci-libs/rocBLAS-${s}
			)
		"
	done
}

BARK_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/bark-0.1.5[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

BARK_CPP_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	>=dev-python/huggingface_hub-0.14.1[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"

# For bark-cpp
GGML_1_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/accelerate-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/gguf-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.24.4[${PYTHON_USEDEP}]
		>=sci-ml/sentencepiece-0.1.98[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/transformers-4.35.2[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/transformers-5.0.0[${PYTHON_SINGLE_USEDEP}]
	)
	>=dev-python/keras-2.15.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/tensorflow-2.15.0[${PYTHON_SINGLE_USEDEP},python]
	>=dev-python/pytorch-2.2.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
"
# TODO add https://download.pytorch.org/whl/cpu

CHATTERBOX_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/poetry[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

COQUI_COMMON_TEMPLATE_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/grpcio-tools:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

COQUI_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/packaging-24.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

DIFFUSERS_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

EXLLAMA2_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"

FASTER_WHISPER_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/grpcio-tools:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

KITTEN_TTS_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/kitten-tts-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

KOKORO_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/packaging-24.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

MLX_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

MLX_AUDIO_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/mlx-audio[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
"

MLX_VLM_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

NEUTTS_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-2.2.6[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/scikit-build-core[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

PIPER_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/librosa-0.9.2[${PYTHON_USEDEP}]
			<dev-python/librosa-1[${PYTHON_USEDEP}]
		)
		>=dev-python/cython-0.29.0:0.29[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19.0[${PYTHON_USEDEP}]
		>=dev-python/piper-phonemize-1.1.0[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/pytorch-1.11.0[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/pytorch-2[${PYTHON_SINGLE_USEDEP}]
	)
	>=dev-python/pytorch-lightning-1.7.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP}]
"

PIPER_BENCHMARK_RDEPEND="
	>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/torch-1.11.0[${PYTHON_SINGLE_USEDEP}]
"

PIPER_RUN_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/piper-phonemize-1.1.0[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/onnxruntime-2[${PYTHON_SINGLE_USEDEP}]
	)
"

PYTHON_COMMON_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/grpcio-tools:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

RERANKERS_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

RFDETR_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/grpcio-tools:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
	')
"

STABLEDIFFUSION_GGML_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/accelerate-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/gguf-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.0.2[${PYTHON_USEDEP}]
		>=sci-ml/sentencepiece-0.1.98[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/transformers-4.35.2[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/transformers-5.0.0[${PYTHON_SINGLE_USEDEP}]
	)
	>=dev-python/keras-3.5.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/tensorflow-2.18.0[${PYTHON_SINGLE_USEDEP},python]
	>=sci-ml/pytorch-2.5.1[${PYTHON_SINGLE_USEDEP}]
"
# TODO package and add above https://download.pytorch.org/whl/cpu

TRANSFORMERS_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.15.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

VLLM_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

# CUDA versions:  https://github.com/mudler/LocalAI/blob/v3.8.0/Dockerfile#L20
#		  https://github.com/mudler/LocalAI/blob/v3.8.0/.github/workflows/image_build.yml#L20
# ROCm versions:
#		  https://github.com/mudler/LocalAI/blob/v3.8.0/backend/python/kokoro/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v3.8.0/backend/python/vllm/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v3.8.0/.github/workflows/image.yml#L42
RDEPEND+="
	(
		|| (
			media-video/ffmpeg:56.58.58
			media-video/ffmpeg:0/56.58.58
		)
		media-video/ffmpeg:=
	)
	>=app-accessibility/espeak-ng-1.51
	acct-group/${MY_PN2}
	acct-user/${MY_PN2}
	x11-misc/xdg-utils
	cuda? (
		=dev-util/nvidia-cuda-toolkit-12.0*
		dev-util/nvidia-cuda-toolkit:=
	)
	localai_backends_bark? (
		${PYTHON_COMMON_RDEPEND}
		${BARK_RDEPEND}
	)
	localai_backends_bark-cpp? (
		${BARK_CPP_RDEPEND}
		${GGML_1_RDEPEND}
	)
	localai_backends_chatterbox? (
		${PYTHON_COMMON_RDEPEND}
		${CHATTERBOX_RDEPEND}
	)
	localai_backends_coqui? (
		${PYTHON_COMMON_RDEPEND}
		${COQUI_RDEPEND}
		${COQUI_COMMON_TEMPLATE_RDEPEND}
	)
	localai_backends_diffusers? (
		${PYTHON_COMMON_RDEPEND}
		${DIFFUSERS_RDEPEND}
	)
	localai_backends_exllama2? (
		${PYTHON_COMMON_RDEPEND}
		${EXLLAMA2_RDEPEND}
	)
	localai_backends_faster-whisper? (
		${PYTHON_COMMON_RDEPEND}
		${FASTER_WHISPER_RDEPEND}
	)
	localai_backends_kitten-tts? (
		${PYTHON_COMMON_RDEPEND}
		${KITTEN_TTS_RDEPEND}
	)
	localai_backends_kokoro? (
		${PYTHON_COMMON_RDEPEND}
		${KOKORO_RDEPEND}
	)
	localai_backends_mlx? (
		${PYTHON_COMMON_RDEPEND}
		${MLX_RDEPEND}
	)
	localai_backends_mlx-audio? (
		${PYTHON_COMMON_RDEPEND}
		${MLX_AUDIO_RDEPEND}
	)
	localai_backends_mlx-vlm? (
		${PYTHON_COMMON_RDEPEND}
		${MLX_VLM_RDEPEND}
	)
	localai_backends_neutts? (
		${PYTHON_COMMON_RDEPEND}
		${NEUTTS_RDEPEND}
	)
	localai_backends_piper? (
		${PIPER_RDEPEND}
		${PIPER_BENCHMARK_RDEPEND}
		${PIPER_RUN_RDEPEND}
	)
	localai_backends_rerankers? (
		${PYTHON_COMMON_RDEPEND}
		${RERANKERS_RDEPEND}
	)
	localai_backends_rfdetr? (
		${PYTHON_COMMON_RDEPEND}
		${RFDETR_RDEPEND}
	)
	localai_backends_stablediffusion-ggml? (
		${STABLEDIFFUSION_GGML_RDEPEND}
	)
	localai_backends_transformers? (
		${PYTHON_COMMON_RDEPEND}
		${TRANSFORMERS_RDEPEND}
	)
	localai_backends_vllm? (
		${PYTHON_COMMON_RDEPEND}
		${VLLM_RDEPEND}
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
	dev-libs/protobuf:${PROTOBUF_CPP_SLOT}
	dev-libs/protobuf:=
	net-libs/grpc:${PROTOBUF_CPP_SLOT}
	net-libs/grpc:=
"
DEPEND+="
	${RDEPEND}
	vulkan? (
		>=dev-util/vulkan-headers-1.3.275.0
		dev-util/vulkan-headers:=
	)
"
DISABLED_DEPEND="
	cpu_flags_arm_dotprod? (
		>=dev-cpp/kleidiai-1.5.0
		dev-cpp/kleidiai:=
	)
	cpu_flags_arm_i8mm? (
		>=dev-cpp/kleidiai-1.5.0
		dev-cpp/kleidiai:=
	)
	cpu_flags_arm_sme? (
		>=dev-cpp/kleidiai-1.5.0
		dev-cpp/kleidiai:=
	)
"
# iputils, rhash, wget are for custom downloader in src_unpack() only.
# go, cmake versions:  https://github.com/mudler/LocalAI/blob/v3.8.0/Dockerfile#L118
# protoc-gen-go, protoc-gen-go-grpc versions:  https://github.com/mudler/LocalAI/blob/v3.8.0/Dockerfile#L154
# TODO:  Review dev-go/protobuf-go multislot
BDEPEND+="
	${PYTHON_DEPS}
	(
		>=dev-cpp/abseil-cpp-${ABSEIL_CPP_SLOT}:${ABSEIL_CPP_SLOT%%.*}
		dev-cpp/abseil-cpp:=
	)
	(
		dev-go/protobuf-go:${PROTOBUF_CPP_SLOT}
		dev-go/protobuf-go:=
	)
	(
		dev-go/protoc-gen-go-grpc:${GRPC_SLOT}
		dev-go/protoc-gen-go-grpc:=
	)
	(
		dev-libs/protobuf:${PROTOBUF_CPP_SLOT}
		dev-libs/protobuf:=
	)
	>=dev-build/cmake-3.26.4
	>=dev-lang/go-1.22.6
	app-arch/upx
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
	"${FILESDIR}/${PN}-3.8.0-offline-install.patch"
	"${FILESDIR}/${PN}-3.8.0-package-sh-fix.patch"
	"${FILESDIR}/${PN}-3.8.0-cwd-change.patch"
	"${FILESDIR}/${PN}-3.8.0-libbackend-sh.patch"
)

pkg_setup() {
ewarn "This ebuild is still in development"
	sandbox-changes_no_network_sandbox "For downloading micropackages"
	python-single-r1_pkg_setup
}

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add * || die
		git commit -m "Dummy" || die
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
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
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		gen_git_tag "${S}" "v${PV}"
	fi
}

get_onnx_arch() {
	[[ "${ARCH}" == "amd64" ]] && echo "x64"
	[[ "${ARCH}" == "arm64" ]] && echo "aarch64"
}

src_prepare() {
	default
	# S_GO should appear at this point
	dep_prepare_mv "${WORKDIR}/bark.cpp-${BARK_CPP_COMMIT}" "${S}/backend/go/bark-cpp/sources/bark.cpp"
	dep_prepare_mv "${WORKDIR}/encodec.cpp-${ENCODEC_CPP_COMMIT}" "${S}/backend/go/bark-cpp/sources/bark.cpp/encodec.cpp"
	dep_prepare_mv "${WORKDIR}/ggml-${GGML_COMMIT_1}" "${S}/backend/go/bark-cpp/sources/bark.cpp/encodec.cpp/ggml"

	dep_prepare_mv "${WORKDIR}/stable-diffusion.cpp-${STABLE_DIFFUSION_CPP_COMMIT}" "${S}/backend/go/stablediffusion-ggml/sources/stablediffusion-ggml.cpp"
	dep_prepare_mv "${WORKDIR}/ggml-${GGML_COMMIT_2}" "${S}/backend/go/stablediffusion-ggml/sources/stablediffusion-ggml.cpp/ggml"

	dep_prepare_mv "${WORKDIR}/go-piper-${GO_PIPER_COMMIT}" "${S}/backend/go/piper/sources/go-piper"
	dep_prepare_mv "${WORKDIR}/espeak-ng-${ESPEAK_NG_COMMIT}" "${S}/backend/go/piper/sources/go-piper/espeak"
	dep_prepare_mv "${WORKDIR}/piper-${PIPER_COMMIT}" "${S}/backend/go/piper/sources/go-piper/piper"
	dep_prepare_mv "${WORKDIR}/piper-phonemize-${PIPER_PHONEMIZE_COMMIT}" "${S}/backend/go/piper/sources/go-piper/piper-phonemize"

	dep_prepare_mv "${WORKDIR}/whisper.cpp-${WHISPER_CPP_COMMIT}" "${S}/backend/go/whisper/sources/whisper.cpp"

	dep_prepare_mv "${WORKDIR}/llama.cpp-${LLAMA_CPP_COMMIT}" "${S}/backend/cpp/llama-cpp/llama.cpp"

	local onnx_arch=$(get_onnx_arch)
	dep_prepare_mv "${WORKDIR}/onnxruntime-linux-${onnx_arch}-${ONNXRUNTIME_PV}" "${S}/backend/go/silero-vad/sources/onnxruntime"

	local L=(
		"backend/python/neutts/install.sh"
		"backend/python/kitten-tts/install.sh"
		"backend/python/bark/install.sh"
		"backend/python/common/template/install.sh"
		"backend/python/diffusers/install.sh"
		"backend/python/rerankers/install.sh"
		"backend/python/chatterbox/install.sh"
		"backend/python/kokoro/install.sh"
		"backend/python/coqui/install.sh"
		"backend/python/transformers/install.sh"
		"backend/python/faster-whisper/install.sh"
		"backend/python/vllm/install.sh"
		"backend/python/rfdetr/install.sh"
	)

	if ! has_version "dev-python/uv" ; then
		local x
		for x in "${L[@]}" ; do
		# This is a uv arg not pip.
			sed -i -e "s|--index-strategy=unsafe-first-match||g" "${x}" || die
		done
	fi
}

src_configure() {
	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure
	ffmpeg_src_configure
	export PATH="${ESYSROOT}/usr/lib/protobuf-go/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	cflags-hardened_append

	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
einfo "CFLAGS: ${CFLAGS}"
einfo "CXXFLAGS: ${CXXFLAGS}"
einfo "CPPLAGS: ${CPPFLAGS}"
einfo "LDFLAGS: ${LDFLAGS}"
	export MAKEOPTS="-j1"
	if ! has_version "dev-python/uv" ; then
		export USE_PIP="true"
	fi

	use localai_backends_llama-cpp || ewarn "You are disabling the llama-cpp backend.  It is the recommended default for LLMs support."
}

src_compile() {
	go-download-cache_setup
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

	local cmake_args=(
		$(abseil-cpp_append_cmake)
		$(protobuf_append_cmake)
		$(grpc_append_cmake)
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16 "ON" "OFF")
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8 "ON" "OFF")
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile "ON" "OFF")
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni "ON" "OFF")
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2 "ON" "OFF")
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512f "ON" "OFF")
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512_vbmi)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni)
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2)
		-DGGML_FMA=$(usex cpu_flags_x86_fma "ON" "OFF")
		-DGGML_F16C=$(usex cpu_flags_x86_f16c "ON" "OFF")
		-DGGML_LASX=$(usex cpu_flags_loong_lasx "ON" "OFF")
		-DGGML_LSX=$(usex cpu_flags_loong_lsx "ON" "OFF")
		-DGGML_NATIVE=$(usex native "ON" "OFF")
		-DGGML_RVV=$(usex cpu_flags_riscv_rvv "ON" "OFF")
		-DGGML_RV_ZFH=$(usex cpu_flags_riscv_rv_zfh "ON" "OFF")
		-DGGML_VXE=$(usex cpu_flags_s390_vxe "ON" "OFF")
	)

	if \
		   use cpu_flags_arm_dotprod \
		|| use cpu_flags_arm_i8mm \
		|| use cpu_flags_arm_sme \
	; then
		cmake_args+=(
			-DGGML_CPU_KLEIDIAI=ON
		)
	else
		cmake_args+=(
			-DGGML_CPU_KLEIDIAI=OFF
		)
	fi

	export CMAKE_ARGS="${cmake_args[@]}"

	# Old patch
	if [[ -e "${S}/backend/cpp/llama/patches/01-llava.patch" ]] ; then
		rm -f "${S}/backend/cpp/llama"*"/patches/01-llava.patch"
	else
ewarn "Q/A:  Remove 01-llava.patch conditional block"
	fi

	emake \
		BUILD_TYPE="${build_type[@]}" \
		GO_TAGS="${go_tags[@]}" \
		OFFLINE="true" \
		build


	local x

	for x in "${CPP_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Building backend/cpp/${x}"
			pushd "backend/cpp/${x}" >/dev/null 2>&1 || die
				if use rocm ; then
einfo "Building ${x} for ROCm"
				elif [[ "${ARCH}" == "arm64" ]] ; then
einfo "Building ${x} for CPU"
				else
einfo "Building ${x} for CPU"
					use cpu_flags_x86_avx && emake "llama-cpp-avx"
					use cpu_flags_x86_avx2 && emake "llama-cpp-avx2"
					use cpu_flags_x86_avx512f && emake "llama-cpp-avx512"
				fi
				emake "llama-cpp-fallback"
				emake "llama-cpp-grpc"
				emake "llama-cpp-rpc-server"
			popd >/dev/null 2>&1 || die

			emake -BC "backend/cpp/${x}" "package"
		fi
	done

	for x in "${GOLANG_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Building backend/go/${x}"
			emake -C "backend/go/${x}" "build"
		fi
	done

	for x in "${PYTHON_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Building backend/python/${x}"
			pushd "backend/python/${x}" || die
				cp -a "${S}/backend/backend.proto" "./" || die
				cp -a "${S}/backend/python/common/" "common" || die
				emake
			popd
		fi
	done
}

sanitize_file_permissions() {
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		[[ -L "${path}" ]] && continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF.*shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF.*executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "OpenRC script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

install_init_services() {
	sed \
		-e "s|@EPYTHON@|${EPYTHON}|g" \
		"${FILESDIR}/${MY_PN2}-start-server" \
			> \
		"${T}/${MY_PN2}-start-server" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${MY_PN2}-start-server"

	# From https://github.com/mudler/LocalAI/blob/v2.28.0/.env
	insinto "/etc/conf.d"
	sed \
		-e "s|@LOCAL_AI_HOST@|${local_ai_hostname}|g" \
		-e "s|@LOCAL_AI_PORT@|${local_ai_port}|g" \
		-e "s|@GO_TAGS@|${go_tags}|g" \
		"${FILESDIR}/${MY_PN2}.conf" \
			> \
		"${T}/${MY_PN2}.conf" \
		|| die
	if use cuda ; then
		sed -i \
			-e "s|@BUILD_TYPE@|cublas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use openblas ; then
		sed -i \
			-e "s|@BUILD_TYPE@|openblas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use opencl ; then
		sed -i \
			-e "s|@BUILD_TYPE@|clblas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	else
		sed -i \
			-e "s|@BUILD_TYPE@|openblas|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	fi
	doins "${T}/${MY_PN2}.conf"

	if use openrc ; then
		exeinto "/etc/init.d"
		newexe "${FILESDIR}/${MY_PN2}.openrc" "${MY_PN2}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		newins "${FILESDIR}/${MY_PN2}.systemd" "${MY_PN2}.service"
	fi
}

src_install() {
	local local_ai_hostname=${LOCAL_AI_HOSTNAME:-"127.0.0.1"}
	local local_ai_port=${LOCAL_AI_PORT:-8080}

einfo "LOCAL_AI_HOSTNAME:  ${local_ai_hostname} (user-definable, per-package environment variable)"
einfo "LOCAL_AI_PORT:  ${local_ai_port} (user-definable, per-package environment variable)"

	local local_ai_uri=${LOCAL_AI_URI:-"http://${local_ai_hostname}:${local_ai_port}"}
einfo "LOCAL_AI_URI:  ${local_ai_uri}"

	docinto "licenses"
	dodoc "LICENSE"
	local dest="/opt/local-ai"

	exeinto "${dest}"
	doexe "local-ai"

	insinto "${dest}"
	doins -r "backend"

	local x

	for x in "${CPP_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Keeping backend/cpp/${x}"
		else
einfo "Removing backend/cpp/${x}"
			rm -rf "${ED}/opt/local-ai/backend/cpp/${x}"
		fi
	done

	for x in "${GOLANG_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Keeping backend/go/${x}"
		else
einfo "Removing backend/go/${x}"
			rm -rf "${ED}/opt/local-ai/backend/go/${x}"
		fi
	done

	for x in "${PYTHON_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Keeping backend/python/${x}"
		else
einfo "Removing backend/python/${x}"
			rm -rf "${ED}/opt/local-ai/backend/python/${x}"
		fi
	done

	keepdir "${dest}/models"

	install_init_services

	if [[ -e "sources/go-piper/piper-phonemize/pi/lib/" ]] ; then
		exeinto "${dest}"
		doexe "sources/go-piper/piper-phonemize/pi/lib/"*
	fi

	newicon \
		"core/http/static/logo.png" \
		"${MY_PN2}.png"

	make_desktop_entry \
		"${MY_PN2}" \
		"${PN}" \
		"${MY_PN2}.png" \
		"Education;ArtificialIntelligence"

	keepdir "/var/lib/${MY_PN2}/"
	keepdir "/var/lib/${MY_PN2}/generated/images"
	keepdir "/var/lib/${MY_PN2}/huggingface/hub"
	keepdir "/var/lib/${MY_PN2}/models"
	keepdir "/var/lib/${MY_PN2}/backends"

	fowners -R "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}"

	sanitize_file_permissions

	fowners -R "${MY_PN2}:${MY_PN2}" "/opt/${MY_PN2}/configuration"
	fowners -R "${MY_PN2}:${MY_PN2}" "/opt/${MY_PN2}/backends"
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  N/A
