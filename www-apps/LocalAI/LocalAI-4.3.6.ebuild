# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# Contains AI generated synthetic data in metadata.xml

# We use partial offline to avoid "argument list too long" for go modules.
# We don't use go-module but just sandbox changes.

# TODO add/update backend Python deps.

# TODO package:
# accelerate
# gguf
# mlx-audio
# piper-phonemize
# upx-ucl

# TODO:
# Change build files to make kleidai offline install.
# Sandbox local-llm

MY_PN2="local-ai"

#
# To update use this run `ebuild ollama-0.4.2.ebuild digest clean unpack`
# changing GEN_EBUILD with the following transition states 0 -> 1 -> 2 -> 0
#
GEN_EBUILD=0

MAINTAINER_MODE=0

ABSEIL_CPP_SLOT="20240722" # The abseil-cpp version is the same used by same Protobuf slot for all of the backends.
CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="daemon network p2p security-critical sensitive-data server untrusted-data" # May process sensitive emails or photos.
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE CSRF SSRF XSS"
GRPC_SLOT="5" # Same as the backends.  Ignore the /Makefile
NODE_SLOT="22"
PROTOBUF_CPP_SLOT="5"
PROTOBUF_PYTHON_SLOT="5"
PYTHON_COMPAT=( "python3_"{11..14} ) # Based on NumPy
RE2_SLOT="20250512"

MODES=(
	"single"
	"federated-load-balancer"
	"federated-worker-node"
	"worker"
)

ONNXRUNTIME_PV="1.20.0" # From https://github.com/mudler/LocalAI/blob/v4.3.6/backend/go/silero-vad/Makefile#L5
VULKAN_PV="1.4.350.0" # Version relaxed.  Originally 1.4.350.1.  From the last vulkan-sdk-<ver> tag in https://github.com/KhronosGroup/Vulkan-Tools/tags relative to LLAMA_CPP_COMMIT commit date.  llama.cpp uses https://vulkan.lunarg.com/sdk/latest/linux.txt

ESPEAK_NG_COMMIT="8593723f10cfd9befd50de447f14bf0a9d2a14a4" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
GGML_COMMIT_2="0ce7ad348a3151e1da9f65d962044546bcaad421" # For stable-diffusion.cpp, from https://github.com/leejet/stable-diffusion.cpp/tree/0e4ee04488159b81d95a9ffcd983a077fd5dcb77
GO_PIPER_COMMIT="e10ca041a885d4a8f3871d52924b47792d5e5aa0" # From https://github.com/mudler/LocalAI/blob/v4.3.6/backend/go/piper/Makefile#L4
HUGO_THEME_RELEARN_COMMIT="8bb66fa674351f3a0b0917a7552caac686eca920" # From https://github.com/mudler/LocalAI/tree/v4.3.6/docs/themes
KOKOROS_COMMIT="7089168f0ca2d8e1fcd8e523c9d75d915c6afdff" # From https://github.com/mudler/LocalAI/tree/v4.3.6/backend/rust/kokoros/sources
LLAMA_CPP_COMMIT="22d66b567eef11cf2e9832f04db64ee0323a0fd0" # From https://github.com/mudler/LocalAI/blob/v4.3.6/backend/cpp/llama-cpp/Makefile#L2
PIPER_COMMIT="0987603ebd2a93c3c14289f3914cd9145a7dddb5" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
PIPER_PHONEMIZE_COMMIT="fccd4f335aa68ac0b72600822f34d84363daa2bf" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
STABLE_DIFFUSION_CPP_COMMIT="0e4ee04488159b81d95a9ffcd983a077fd5dcb77" # From https://github.com/mudler/LocalAI/blob/v4.3.6/backend/go/stablediffusion-ggml/Makefile#L22
WHISPER_CPP_COMMIT="f24588a272ae8e23280d9c220536437164e6ed28" # From https://github.com/mudler/LocalAI/blob/v4.3.6/backend/go/whisper/Makefile#L9

# Yes the Protobuf situation is a mess.
# Protobuf 6 needed by go-tools (protoc-gen-go@v1.34.2, protoc-gen-go-grpc@1958fcb) in https://github.com/mudler/LocalAI/blob/v4.3.6/Makefile#L267

# Protobuf 5
CPP_BACKENDS=(
	"llama-cpp"
)

# Protobuf 5
GOLANG_BACKENDS=(
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
	"outetts"
	"rerankers"
	"rfdetr"
	"tinygrad"
	"transformers"
	"vibevoice"
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
	"cpu_flags_riscv_v"
	"cpu_flags_riscv_xthreadvector"
	"cpu_flags_riscv_zfh"
	"cpu_flags_riscv_zicbop"
	"cpu_flags_riscv_zvfh"
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
inherit grpc npm protobuf python-single-r1 re2 sandbox-changes toolchain-funcs xdg

#
# Used go-download-cache to avoid:
# OSError: [Errno 7] Argument list too long: '/usr/local/bin/wget'
#
# The go-download-cache eclass works like the npm eclass, storing
# the downloads in the distdir folder.
#

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mudler/LocalAI.git"
	FALLBACK_COMMIT="aee4611ab2d1400869de7e78fad5cb41cce0c5d0" # May 30, 2026
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
https://github.com/ggml-org/ggml/archive/${GGML_COMMIT_2}.tar.gz
	-> ggml-${GGML_COMMIT_2:0:7}.tar.gz
https://github.com/ggml-org/llama.cpp/archive/${LLAMA_CPP_COMMIT}.tar.gz
	-> llama-cpp-${LLAMA_CPP_COMMIT:0:7}.tar.gz
https://github.com/ggml-org/whisper.cpp/archive/${WHISPER_CPP_COMMIT}.tar.gz
	-> whisper-cpp-${WHISPER_CPP_COMMIT:0:7}.tar.gz
https://github.com/leejet/stable-diffusion.cpp/archive/${STABLE_DIFFUSION_CPP_COMMIT}.tar.gz
	-> leejet-stable-diffusion-cpp-${STABLE_DIFFUSION_CPP_COMMIT:0:7}.tar.gz
https://github.com/lucasjinreal/Kokoros/archive/${KOKOROS_COMMIT}.tar.gz
	-> ${KOKOROS_COMMIT:0:7}.tar.gz
https://github.com/McShelby/hugo-theme-relearn/archive/${HUGO_THEME_RELEARN_COMMIT}.tar.gz
	-> hugo-theme-relearn-${HUGO_THEME_RELEARN_COMMIT:0:7}.tar.gz
https://github.com/mudler/go-piper/archive/${GO_PIPER_COMMIT}.tar.gz
	-> go-piper-${GO_PIPER_COMMIT:0:7}.tar.gz
https://github.com/mudler/LocalAI/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/rhasspy/piper/archive/${PIPER_COMMIT}.tar.gz
	-> piper-${PIPER_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/espeak-ng/archive/${ESPEAK_NG_COMMIT}.tar.gz
	-> rhasspy-espeak-ng-${ESPEAK_NG_COMMIT:0:7}.tar.gz
https://github.com/rhasspy/piper-phonemize/archive/${PIPER_PHONEMIZE_COMMIT}.tar.gz
	-> piper-phonemize-${PIPER_PHONEMIZE_COMMIT:0:7}.tar.gz
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
# Upstream does not use a sandbox.  This is a oiledmachine-overlay exclusive
# feature.  It is enabled by default to mitigate against drive by download of
# unreviewed trojanized LLM models which may contain malicious payloads.
IUSE+="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPP_BACKENDS[@]/#/localai_backends_}
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
${GOLANG_BACKENDS[@]/#/localai_backends_}
${MODES[@]/+}
${PYTHON_BACKENDS[@]/#/localai_backends_}
ci cuda debug devcontainer docker +firejail native openblas opencl
openrc rag rocm stt sycl-f16 sycl-f32 systemd tts vulkan
ebuild_revision_53
"
REQUIRED_USE="
	!ci
	!devcontainer
	^^ (
		${MODES[@]/+}
	)
	?? (
		cuda
		openblas
		opencl
		rocm
		sycl-f16
		sycl-f32
		vulkan
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
	localai_backends_neutts? (
		|| (
			python_single_target_python3_13
		)
	)
	localai_backends_outetts? (
		|| (
			python_single_target_python3_13
			python_single_target_python3_14
		)
	)
	localai_backends_tinygrad? (
		|| (
			python_single_target_python3_13
			python_single_target_python3_14
		)
	)
	localai_backends_transformers? (
		|| (
			python_single_target_python3_13
			python_single_target_python3_14
		)
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
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
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
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/scikit-build-core[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	')
"

PIPER_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/librosa-0.9.2[${PYTHON_USEDEP}]
			<dev-python/librosa-1[${PYTHON_USEDEP}]
		)
		>=dev-python/cython-0.29.0:0.29[${PYTHON_USEDEP}]
		>=dev-python/piper-phonemize-1.1.0[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/pytorch-1.11.0[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/pytorch-2[${PYTHON_SINGLE_USEDEP}]
	)
	>=dev-python/pytorch-lightning-1.7.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP},python]
"

PIPER_BENCHMARK_RDEPEND="
	>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP},python]
	>=sci-ml/torch-1.11.0[${PYTHON_SINGLE_USEDEP}]
"

PIPER_RUN_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/piper-phonemize-1.1.0[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/onnxruntime-1.11.0[${PYTHON_SINGLE_USEDEP},python]
		<sci-ml/onnxruntime-2[${PYTHON_SINGLE_USEDEP},python]
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
		>=dev-python/gguf-0.1.0[${PYTHON_USEDEP}]
		>=sci-ml/sentencepiece-0.1.98[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/transformers-4.35.2[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/transformers-5.0.0[${PYTHON_SINGLE_USEDEP}]
	)
	>=dev-python/accelerate-0.19.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/keras-3.5.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/tensorflow-2.18.0[${PYTHON_SINGLE_USEDEP},python]
	>=sci-ml/pytorch-2.5.1[${PYTHON_SINGLE_USEDEP}]
"

TRANSFORMERS_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/scipy-1.15.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/grpcio:'${GRPC_SLOT}'[${PYTHON_USEDEP}]
		dev-python/protobuf:'${PROTOBUF_PYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
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

VIBEVOICE_RDEPEND="
	
"

# CUDA versions:  https://github.com/mudler/LocalAI/blob/v4.3.6/Dockerfile#L20
#		  https://github.com/mudler/LocalAI/blob/v4.3.6/.github/workflows/image_build.yml#L20
# ROCm versions:
#		  https://github.com/mudler/LocalAI/blob/v4.3.6/backend/python/kokoro/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v4.3.6/backend/python/vllm/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v4.3.6/.github/workflows/image.yml#L42
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
	docker? (
		app-containers/docker
	)
	firejail? (
		sys-apps/firejail
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
		>=media-libs/vulkan-loader-${VULKAN_PV}
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
		>=dev-util/vulkan-headers-${VULKAN_PV}
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
# go, cmake versions:  https://github.com/mudler/LocalAI/blob/v4.3.6/Dockerfile#L118
# protoc-gen-go, protoc-gen-go-grpc versions:  https://github.com/mudler/LocalAI/blob/v4.3.6/Dockerfile#L154
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
	(
		net-libs/nodejs:22
		net-libs/nodejs:=
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
	"${FILESDIR}/${PN}-4.3.6-offline-install.patch"
	"${FILESDIR}/${PN}-4.3.6-package-sh-fix.patch"
	"${FILESDIR}/${PN}-3.8.0-cwd-change.patch"
	"${FILESDIR}/${PN}-4.3.6-libbackend-sh.patch"
	"${FILESDIR}/${PN}-3.8.0-proto-reorder.patch"
	"${FILESDIR}/${PN}-3.8.0-llama-cpp-config.patch"
)

pkg_setup() {
ewarn "This ebuild is still in development"
	sandbox-changes_no_network_sandbox "For downloading micropackages"
	python-single-r1_pkg_setup
	npm_pkg_setup
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

	if [[ "${MAINTAINER_MODE}" != "1" ]] ; then
		mkdir -p "${S}/core/http/react-ui" || die
		pushd "${S}/core/http/react-ui" >/dev/null 2>&1 || die
			npm_hydrate
			enpm install
			enpm run build
		popd >/dev/null 2>&1 || die
	fi
}

get_onnx_arch() {
	[[ "${ARCH}" == "amd64" ]] && echo "x64"
	[[ "${ARCH}" == "arm64" ]] && echo "aarch64"
}

src_prepare() {
	default
	# S_GO should appear at this point
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

	dep_prepare_mv "${WORKDIR}/hugo-theme-relearn-${HUGO_THEME_RELEARN_COMMIT}" "${S}/docs/themes/hugo-theme-relearn"
	dep_prepare_mv "${WORKDIR}/Kokoros-${KOKOROS_COMMIT}" "${S}/backend/rust/kokoros/sources/Kokoros"

	local L=(
		"backend/python/neutts/install.sh"
		"backend/python/kitten-tts/install.sh"
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
	if use firejail ; then
		if [[ ! -e "/etc/firejail/local-ai.profile" ]] ; then
eerror "Re-emerge sys-apps/firejail::oiledmachine-overlay to add the local-ai.profile."
			die
		fi
	fi

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

	if ! use localai_backends_llama-cpp ; then
ewarn "You are disabling the llama-cpp backend."
ewarn "The localai_backends_llama-cpp USE flag is the recommended default for LLMs support."
	fi

	if use cuda || use opencl || use rocm || use sycl-f16 || use sycl-f32 || use vulkan ; then
		:
	else
ewarn "You are using very slow CPU based inferencing."
ewarn "For GPU inferencing, use either cuda, opencl, rocm, sycl-f16, sycl-f32, vulkan USE flag."
	fi

	if use opencl && [[ "${ARCH}" != "arm64" ]] ; then
eerror "OpenCL is only supported on ARCH=${ARCH}.  Disable the opencl USE flag to continue."
		die
	fi

	export LIBDIR=$(get_libdir)
	export DOCKER=0
}

src_compile() {
	go-download-cache_setup
	local go_tags=()
	use debug && go_tags+=( "debug" )

	if ! use single ; then
		go_tags+=( "p2p" )
	fi

	if ! use single ; then
		:
	elif use debug || use tts ; then
		:
	else
		go_tags+=( "none" )
	fi

	local build_type

	# Sort by tokens/sec
	if use cuda ; then
		build_type="cublas"
	elif use rocm ; then
		build_type="hipblas"
	elif use vulkan ; then
		build_type="vulkan"
	elif use sycl-f16 ; then
		build_type="sycl_f16"
	elif use sycl-f32 ; then
		build_type="sycl_f32"
	elif use opencl ; then
		build_type="clblas"
	elif use openblas ; then
		build_type="openblas"
	else
		build_type="cpu"
	fi

	local cmake_args=(
		$(abseil-cpp_append_cmake)
		$(protobuf_append_cmake)
		$(grpc_append_cmake)
		-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16 "ON" "OFF")
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8 "ON" "OFF")
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile "ON" "OFF")
		-DGGML_AVX=$(usex cpu_flags_x86_avx "ON" "OFF")
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni "ON" "OFF")
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2 "ON" "OFF")
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512f "ON" "OFF")
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16 "ON" "OFF")
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512_vbmi "ON" "OFF")
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni "ON" "OFF")
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2 "ON" "OFF")
		-DGGML_F16C=$(usex cpu_flags_x86_f16c "ON" "OFF")
		-DGGML_FMA=$(usex cpu_flags_x86_fma "ON" "OFF")
		-DGGML_LASX=$(usex cpu_flags_loong_lasx "ON" "OFF")
		-DGGML_LSX=$(usex cpu_flags_loong_lsx "ON" "OFF")
		-DGGML_NATIVE=$(usex native "ON" "OFF")
		-DGGML_RVV=$(usex cpu_flags_riscv_v "ON" "OFF")
		-DGGML_RV_ZFH=$(usex cpu_flags_riscv_zfh "ON" "OFF")
		-DGGML_RV_ZICBOP=$(usex cpu_flags_riscv_zicbop "ON" "OFF")
		-DGGML_RV_ZVFH=$(usex cpu_flags_riscv_zvfh "ON" "OFF")
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2 "ON" "OFF")
		-DGGML_XTHEADVECTOR=$(usex cpu_flags_riscv_xthreadvector "ON" "OFF")
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

	# For llama.cpp
	export CMAKE_ARGS="${cmake_args[@]}"

	# Old patch
	if [[ -e "${S}/backend/cpp/llama/patches/01-llava.patch" ]] ; then
		rm -f "${S}/backend/cpp/llama"*"/patches/01-llava.patch"
	else
ewarn "Q/A:  Remove 01-llava.patch conditional block"
	fi

	export VERBOSE=1

	emake \
		BUILD_TYPE="${build_type}" \
		GO_TAGS="${go_tags[@]}" \
		OFFLINE="true" \
		build

	local x

	for x in "${CPP_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Building backend/cpp/${x}"
			pushd "backend/cpp/${x}" >/dev/null 2>&1 || die
				local build_desc="CPU"

	# Sort by tokens/sec
				if use cuda ; then
					build_desc="GPU (CUDA)"
					export BUILD_TYPE="cublas"
				elif use rocm ; then
					build_desc="GPU (ROCm)"
					export BUILD_TYPE="hipblas"
				elif use vulkan ; then
					build_desc="GPU (Vulkan)"
					export BUILD_TYPE="vulkan"
				elif use sycl-f16 ; then
					build_desc="GPU (SYCL F16)"
					export BUILD_TYPE="sycl_f16"
				elif use sycl-f32 ; then
					build_desc="GPU (SYCL F32)"
					export BUILD_TYPE="sycl_f32"
				elif use opencl ; then
					build_desc="GPU (OpenCL)"
					export BUILD_TYPE="clblas"
				elif use openblas ; then
					build_desc="CPU (OpenBLAS)"
					export BUILD_TYPE="openblas"
				else
					build_desc="CPU (Generic, Unaccelerated BLAS)"
					export BUILD_TYPE="cpu"
				fi

einfo "Building llama.cpp for ${build_desc}"

				if use rocm || [[ "${ARCH}" == "arm64" ]] ; then
					:
				else
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
		chown "root:root" "${path}" || die
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

	# Secure key/token permissions
	fperms "0640" "/etc/conf.d/${MY_PN2}"
	fowners "local-ai:local-ai" "/etc/conf.d/${MY_PN2}"
}

get_mode() {
	local mode=""
	if use single ; then
		mode="single"
	elif use federated-load-balancer ; then
		mode="federated-load-balancer"
	elif use federated-worker-node ; then
		mode="federated-worker-node"
	elif use worker ; then
		mode="worker"
	else
eerror "Supported modes:  single, federated-load-balancer, federated-worker-node, worker"
		die
	fi
	echo "${mode}"
}

install_init_services() {
	local mode=$(get_mode)

	sed \
		-e "s|@EPYTHON@|${EPYTHON}|g" \
		-e "s|@LOCAL_AI_FIREJAIL@|${firejail}|g" \
		-e "s|@LOCAL_AI_MODE@|${mode}|g" \
		"${FILESDIR}/${MY_PN2}-start-server" \
			> \
		"${T}/${MY_PN2}-start-server" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${MY_PN2}-start-server"

	# From https://github.com/mudler/LocalAI/blob/v2.28.0/.env
	insinto "/etc/conf.d"
	sed \
		-e "s|@LOCALAI_ADDRESS@|${localai_address}|g" \
		-e "s|@GO_TAGS@|${go_tags}|g" \
		"${FILESDIR}/${MY_PN2}.conf" \
			> \
		"${T}/${MY_PN2}.conf" \
		|| die

	# Keep sorted by tokens/second
	if use cuda ; then
		sed -i \
			-e "s|@BUILD_TYPE@|cublas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use rocm ; then
		sed -i \
			-e "s|@BUILD_TYPE@|hipblas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use vulkan ; then
		sed -i \
			-e "s|@BUILD_TYPE@|vulkan|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use sycl_f16 ; then
		sed -i \
			-e "s|@BUILD_TYPE@|sycl_f16|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use sycl_f32 ; then
		sed -i \
			-e "s|@BUILD_TYPE@|sycl_f32|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use opencl ; then
		sed -i \
			-e "s|@BUILD_TYPE@|clblas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	elif use openblas ; then
		sed -i \
			-e "s|@BUILD_TYPE@|openblas|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
	else
		sed -i \
			-e "s|@BUILD_TYPE@|cpu|g" \
			-e "s|# export BUILD_TYPE|export BUILD_TYPE|g" \
			"${T}/${MY_PN2}.conf" \
			|| die
		die
	fi

	newins "${T}/${MY_PN2}.conf" "${MY_PN2}"

	if use openrc ; then
		exeinto "/etc/init.d"
		cat "${FILESDIR}/${MY_PN2}.openrc" > "${T}/${MY_PN2}.openrc" || die
		sed -i \
			-e "s|@LOCAL_AI_FIREJAIL@|${firejail}|g" \
			-e "s|@LOCAL_AI_MODE@|${mode}|g" \
			"${T}/${MY_PN2}.openrc" \
			|| die
		newexe "${T}/${MY_PN2}.openrc" "${MY_PN2}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		cat "${FILESDIR}/${MY_PN2}.systemd" > "${T}/${MY_PN2}.systemd" || die
		sed -i \
			-e "s|@LOCAL_AI_FIREJAIL@|${firejail}|g" \
			-e "s|@LOCAL_AI_MODE@|${mode}|g" \
			"${T}/${MY_PN2}.systemd" \
			|| die
		newins "${T}/${MY_PN2}.systemd" "${MY_PN2}.service"
	fi
}

src_install() {
	local localai_address=${LOCALAI_ADDRESS:-"127.0.0.1:8080"}
einfo "LOCALAI_ADDRESS:  ${LOCALAI_ADDRESS} (user-definable, per-package environment variable)"

	docinto "licenses"
	dodoc "LICENSE"
	local dest="/opt/local-ai"

	exeinto "${dest}"
	doexe "local-ai"

	local x

	for x in "${CPP_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Installing backend/cpp/${x}"
			insinto "/opt/local-ai/backends"
			doins -r "backend/cpp/${x}"
			fowners "${MY_PN2}:${MY_PN2}" "/opt/local-ai/backends/${x}"
			fperms "+x" "/opt/local-ai/backends/${x}"
		fi
	done

	for x in "${GOLANG_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Installing backend/go/${x}"
			insinto "/opt/local-ai/backends"
			doins -r "backend/go/${x}"
			fowners "${MY_PN2}:${MY_PN2}" "/opt/local-ai/backends/${x}"
			fperms "+x" "/opt/local-ai/backends/${x}"
		fi
	done

	for x in "${PYTHON_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
einfo "Installing backend/python/${x}"
			insinto "/opt/local-ai/backends"
			doins -r "backend/python/${x}"
			fowners "${MY_PN2}:${MY_PN2}" "/opt/local-ai/backends/${x}"
			fperms "+x" "/opt/local-ai/backends/${x}"
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

	cat "${FILESDIR}/${MY_PN2}" > "${T}/${MY_PN2}" || die
	sed -i -e \
		"s|@LOCALAI_ADDRESS@|http://${localai_address}|g" \
		"${T}/${MY_PN2}" \
		|| die
	exeinto "/usr/bin"
	newexe "${T}/${MY_PN2}" "${MY_PN2}"
	dosym "/usr/bin/local-ai" "/usr/bin/LocalAI"
	dosym "/usr/bin/local-ai" "/usr/bin/localai"

	make_desktop_entry \
		"${MY_PN2}" \
		"${PN}" \
		"${MY_PN2}.png" \
		"Education;ArtificialIntelligence"

	keepdir "/var/lib/${MY_PN2}/backends"					# Web UI gallery backends
	keepdir "/var/lib/${MY_PN2}/configuration"
	keepdir "/var/lib/${MY_PN2}/huggingface/hub"				# HF models
	keepdir "/var/lib/${MY_PN2}/models"
	keepdir "/opt/local-ai/data"
	fowners "local-ai:local-ai" "/opt/local-ai/data"

	sanitize_file_permissions
}

pkg_postinst() {
	# The owners is not sticking in src_install
	chown "${MY_PN2}:${MY_PN2}" "/opt/${MY_PN2}/backends/"			# System package manager managed backends
	chown "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}/"			# Required
	chown "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}/backends/"
	chown "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}/configuration/"
	chown "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}/huggingface/hub"
	chown "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}/models/"
	local x
	for x in "${CPP_BACKENDS[@]}" "${GOLANG_BACKENDS[@]}" "${PYTHON_BACKENDS[@]}" ; do
		if use "localai_backends_${x}" ; then
			chown "${MY_PN2}:${MY_PN2}" "/opt/${MY_PN2}/backends/${x}"
		fi
	done

	xdg_pkg_postinst
ewarn
ewarn "By default generated images/videos content will be removed on reset."
ewarn "If you do not like this behavior, change LOCALAI_GENERATED_CONTENT_PATH"
ewarn

# Check if user created their own acct-{user,group}/local-ai ebuilds.
	if ! ( groups "local-ai" | grep -q -e "video" ) ; then
ewarn
ewarn "The local-ai user needs to be added to the video group for GPU hardware"
ewarn "acceleration in ${PN}"
ewarn
	fi

	if use firejail ; then
ewarn
ewarn "You need to etc-update and restart the init service for the new sandbox"
ewarn "changes."
ewarn
ewarn "The /etc/firejail/local-ai.profile assumes single mode USE case."
ewarn "Change the config if using Docker plugins"
ewarn
	fi
	local localai_address=${LOCALAI_ADDRESS:-"127.0.0.1:8080"}
einfo
einfo "To use it first start the ${PN} init script."
einfo
einfo "Then, open ${localai_address} and bookmark it with the web browser,"
einfo "or run via ${PN} in the command line."
einfo
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  3.8.0 (20251220) PASSED
# OILEDMACHINE-OVERLAY-TEST:  4.3.6 (20260602) PASSED
# Web UI - pass
# llama.cpp (CPU, fallback) - passed
# llama.cpp (GPU, vulkan) - passed
# Test message:  What is the speed of light?
# Test message:  show me hello world in python
# LLM (llama2:1b-instruct-q8_0) - passed, but uses CPU when it should use GPU
# LLM (smollm:1.7b-instruct) - passed
# LLM (smollm2:1.7b-instruct) - passed
# TTS (coqui) - untested
# SST (whisper) - untested
# diffusers (image) - untested
# diffusers (video) - untested
# stablediffusion - untested
# Test case:  how many letters in the english language? [Expected answer in 9 seconds]
