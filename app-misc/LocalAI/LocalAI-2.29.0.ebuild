# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# We use partial offline to avoid "argument list too long" for go modules.
# We don't use go-module but just sandbox changes.

# TODO package:
# upx-ucl
# rice (https://github.com/GeertJohan/go.rice)

# TODO:
# Change build files to make kleidai offline install.

MY_PN2="local-ai"

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
CPU_FLAGS_ARM=(
	cpu_flags_arm_dotprod
	cpu_flags_arm_i8mm
	cpu_flags_arm_sme
)
CPU_FLAGS_LOONG=(
	cpu_flags_loong_lasx
	cpu_flags_loong_lsx
)
CPU_FLAGS_RISCV=(
	cpu_flags_riscv_rvv
	cpu_flags_riscv_rv_zfh
)
CPU_FLAGS_S390=(
	cpu_flags_s390_vxe
)
CPU_FLAGS_X86=(
	cpu_flags_x86_amx_bf16
	cpu_flags_x86_amx_int8
	cpu_flags_x86_amx_tile
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512_vbmi
	cpu_flags_x86_avx512_vnni
	cpu_flags_x86_avx512_bf16
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512cd
	cpu_flags_x86_avx512dq
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512vl
	cpu_flags_x86_avx_vnni
	cpu_flags_x86_bmi2
	cpu_flags_x86_f16c
	cpu_flags_x86_fma
	cpu_flags_x86_sse4_2
)
#
# To update use this run `ebuild ollama-0.4.2.ebuild digest clean unpack`
# changing GEN_EBUILD with the following transition states 0 -> 1 -> 2 -> 0
#
GEN_EBUILD=0
GRPC_PROTOBUF_PAIRS=(
# GRPC versions:
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/.github/workflows/generate_grpc_cache.yaml#L88
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/backend/cpp/grpc/Makefile#L5
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/backend/Dockerfile.golang#L113C95-L113C97
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/backend/python/coqui/requirements.txt#L1
	#grpc:protobuf
	"1.72:6.30" # For python backends (coqui, kokoro, transformers)
	#"1.65:5.26"
	#"1.59:4.24"
	#"1.54:3.21"
	#"1.53:3.21"
	#"1.52:3.21"
)
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOTS=(
	"${HIP_6_1_VERSION}"
)

BARK_CPP_PV="1.0.0" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L21
CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="daemon execution-integrity server"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE"
ENCODEC_CPP_COMMIT="05513e7f03d8d349734a2b7a47b2e9921f0adeb0" # For bark.cpp, from https://github.com/PABannier/bark.cpp/tree/v1.0.0
ESPEAK_NG_COMMIT="8593723f10cfd9befd50de447f14bf0a9d2a14a4" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
GGML_COMMIT_1="aa00e1676417d8007dbaa47d2ee1a6e06c60d546" # For bark.cpp/encodec.cpp, from https://github.com/PABannier/encodec.cpp/tree/05513e7f03d8d349734a2b7a47b2e9921f0adeb0
GGML_COMMIT_2="dddef738b2d5a95323188ed019877d4e20568b7e" # For stable-diffusion.cpp, from https://github.com/richiejp/stable-diffusion.cpp/tree/53e3b17eb3d0b5760ced06a1f98320b68b34aaae
ONNXRUNTIME_PV="1.20.0" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L30
GO_PIPER_COMMIT="e10ca041a885d4a8f3871d52924b47792d5e5aa0" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L17
KOMPUTE_COMMIT="4565194ed7c32d1d2efa32ceab4d3c6cae006306" # For llama.cpp, from https://github.com/ggml-org/llama.cpp/tree/9a390c4829cd3058d26a2e2c09d16e3fd12bf1b1/ggml/src/ggml-kompute
LLAMA_CPP_COMMIT="9a390c4829cd3058d26a2e2c09d16e3fd12bf1b1" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L9
PIPER_COMMIT="0987603ebd2a93c3c14289f3914cd9145a7dddb5" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
PIPER_PHONEMIZE_COMMIT="fccd4f335aa68ac0b72600822f34d84363daa2bf" # For go-piper, from https://github.com/mudler/go-piper/tree/e10ca041a885d4a8f3871d52924b47792d5e5aa0
STABLE_DIFFUSION_CPP_COMMIT="53e3b17eb3d0b5760ced06a1f98320b68b34aaae" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L25
WHISPER_CPP_COMMIT="2e310b841e0b4e7cf00890b53411dd9f8578f243" # From https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L13

inherit cflags-hardened dep-prepare desktop edo flag-o-matic go-download-cache
inherit python-single-r1 toolchain-funcs xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mudler/LocalAI.git"
	FALLBACK_COMMIT="fd17a3312c4c1f5688152eff227e27d9b7bce365" # May 12, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64 ~arm64"
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
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
ci cuda debug devcontainer native openblas opencl openrc p2p rocm sycl-f16
sycl-f32 systemd tts vulkan
ebuild_revision_15
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
	cpu_flags_x86_amx_bf16? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_amx_int8? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_amx_tile? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512_bf16? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512_vnni
	)
	cpu_flags_x86_avx512_vbmi? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx512_vnni? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx_vnni? (
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
		cpu_flags_x86_bmi2
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_avx
		cpu_flags_x86_sse4_2
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
# CUDA versions:  https://github.com/mudler/LocalAI/blob/v2.29.0/.github/workflows/release.yaml#L169
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/Makefile#L822
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/.github/workflows/image_build.yml#L21
# ROCm versions:  https://github.com/mudler/LocalAI/blob/v2.29.0/.github/workflows/release.yaml#L172
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/backend/python/kokoro/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/backend/python/vllm/requirements-hipblas.txt
#		  https://github.com/mudler/LocalAI/blob/v2.29.0/.github/workflows/image.yml#L64
RDEPEND+="
	(
		>=media-video/ffmpeg-6.1.1
		media-video/ffmpeg:=
	)
	>=app-accessibility/espeak-ng-1.51
	acct-group/${MY_PN2}
	acct-user/${MY_PN2}
	x11-misc/xdg-utils
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
	dev-libs/protobuf:=
	net-libs/grpc:=
"
# Relaxed grpc for compatibility testing
DISABLED_RDEPEND="
	|| (
		$(gen_grpc_rdepend)
	)
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
# go, cmake versions:  https://github.com/mudler/LocalAI/blob/v2.29.0/Dockerfile#L12
# protoc-gen-go, protoc-gen-go-grpc, rice versions:  https://github.com/mudler/LocalAI/blob/v2.29.0/Dockerfile#L50
BDEPEND+="
	${PYTHON_DEPS}
	(
		>=dev-go/protobuf-go-1.34.2
		dev-go/protobuf-go:=
	)
	(
		>=dev-go/protoc-gen-go-grpc-1.65.0
		dev-go/protoc-gen-go-grpc:=
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
	"${FILESDIR}/${PN}-2.28.0-offline-install.patch"
)

pkg_setup() {
ewarn "This ebuild is still in development"
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
		git tag ${tag_name} || die
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
	die
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

src_configure() {
	cflags-hardened_append
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
}

sanitize_file_permissions() {
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
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

	# From https://github.com/mudler/LocalAI/blob/v2.29.0/.env
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
	doins -r "sources"
	doins -r "backend-assets"

	keepdir "${dest}/models"

	install_init_services

	if [[ -e "sources/go-piper/piper-phonemize/pi/lib/" ]] ; then
		exeinto "${dest}"
		doexe "sources/go-piper/piper-phonemize/pi/lib/"*
	fi

	newicon \
		"docs/static/apple-touch-icon.png" \
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

	fowners -R "${MY_PN2}:${MY_PN2}" "/var/lib/${MY_PN2}"

	sanitize_file_permissions
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  N/A
