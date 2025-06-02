# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Hardened because of CVE-2024-37032 implications of similar attacks.

# TODO:  Fix or remove bwrap
# FIXME:  Fix model download issue

#
# SECURITY:
#
# (1) Check the security advisories each month for both ollama and llama.cpp.
# (2) if llama.cpp has a critical vulnerability, either bump ollama or manually force bump LLAMA_CPP_COMMIT and LLAMA_CPP_UPDATE=1.
#

# Scan the following for dependencies
# //go:generate

# TODO:  Re-evaluate/assess the security of file permissions related if the environment
# variable were changed to having one folder of models.

# U20
# For depends see
# https://github.com/ollama/ollama/blob/main/docs/development.md
# ROCm:  https://github.com/ollama/ollama/blob/v0.4.7/.github/workflows/test.yaml
# CUDA:  https://github.com/ollama/ollama/blob/v0.4.7/.github/workflows/release.yaml#L194
# Hardware support:  https://github.com/ollama/ollama/blob/v0.4.7/docs/gpu.md
AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_plus
	gfx90a_xnack_minus
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
I8MM_ARCHES=(
	armv8.2-a
	armv8.3-a
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
	armv8-r
)
SVE_ARCHES=(
	armv8.2-a
	armv8.3-a
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)
CPU_FLAGS_ARM=(
	cpu_flags_arm_i8mm
	cpu_flags_arm_sve
)
CPU_FLAGS_X86=(
	cpu_flags_x86_f16c
	cpu_flags_x86_fma
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512bf16
	cpu_flags_x86_avx512dq
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512vbmi
	cpu_flags_x86_avx512vl
	cpu_flags_x86_avx512vnni
	cpu_flags_x86_avxvnni
	cpu_flags_x86_avxvnniint8
	cpu_flags_x86_sse
	cpu_flags_x86_sse2
	cpu_flags_x86_sse3
	cpu_flags_x86_ssse3
)
CUDA_FATTN_TARGETS_COMPAT=(
	sm_60
	sm_61
	sm_70
	sm_75
	sm_80
	sm_86
	sm_89
	sm_90
	sm_90a
)
CUDA_TARGETS_COMPAT=(
	sm_50
	sm_52
	sm_60
	sm_61
	sm_70
	sm_75
	sm_80
	sm_86
	sm_89
	sm_90
	sm_90a
)
LLMS=(
adens-quran-guide agcobra-liberated-qwen1.5-72b akx-viking-7b alfred
ALIENTELLIGENCE-christiancounselor ALIENTELLIGENCE-crisisintervention
ALIENTELLIGENCE-doomsdayurvivalist ALIENTELLIGENCE-enriquecastillorincon
ALIENTELLIGENCE-gamemasterroleplaying ALIENTELLIGENCE-holybible
ALIENTELLIGENCE-mentalwellness ALIENTELLIGENCE-pcarchitect
ALIENTELLIGENCE-prayerline ALIENTELLIGENCE-sarah ALIENTELLIGENCE-sarahv2
ALIENTELLIGENCE-whiterabbit ALIENTELLIGENCE-whiterabbitv2 all-minilm
Artalius-lixi aya aya-expanse bakllava artifish-mlewd-v2.4 athene-v2
benevolentjoker-belial benevolentjoker-bethanygpt benevolentjoker-nsfwmonika
benevolentjoker-nsfwvanessa benevolentjoker-satan bespoke-minicheck bge-large
bge-m3 canadiangamer-neena canadiangamer-priya captainkyd-whiterabbitneo7b
chatgph-70b-instruct chatgph-gph-main chatgph-medix-ph codebooga codegeex4
codegemma codellama codeqwen codestral codeup command-r command-r-plus dbrx
deepseek-coder deepseek-coder-v2 deepseek-llm deepseek-v2 deepseek-v2.5
disinfozone-telos dolphin-llama3 dolphin-mistral dolphin-mixtral dolphin-phi
dolphincoder duckdb-nsql ehartford-theprofessor eramax-aura_v3 everythinglm
falcon falcon2 firefunction-v2 gemma gemma2 glm4 fixt-home-3b-v3 fixt-home-3b-v2
goliath granite-code granite3-dense granite3-guardian granite3-moe
hemanth-chessplayer hermes3 hookingai-monah-8b internlm2
jimscard-adult-film-screenwriter-nsfw jimscard-whiterabbit-neo joefamous-grok-1
leeplenty-lumimaid-v0.2 llama-guard3 llama-pro llama2 llama2-chinese
llama2-uncensored llama3 llama3-chatqa llama3-gradient llama3-groq-tool-use
llama3.1 llama3.2 llama3.2-vision llava llava-llama3 llava-phi3 magicoder
mannix-replete-adapted-llama3-8b mannix-llamax3-8b-alpaca mannix-smaug-qwen2-72b
mannix-replete-coder-llama3-8b marco-o1 mathstral meditron medllama2 megadolphin
minicpm-v mistral mistral-large mistral-nemo mistral-openorca mistral-small
mistrallite mixtral monotykamary-whiterabbitneo-v1.5a moondream
mxbai-embed-large nemotron nemotron-mini neural-chat nexusraven nomic-embed-text
notus notux nous-hermes nous-hermes2 nous-hermes2-mixtral nqduc-gemsura
nqduc-mixsura nqduc-mixsura-sft nuextract open-orca-platypus2 openchat
openhermes orca-mini orca2 paraphrase-multilingual partai-dorna-llama3 phi phi3
phi3.5 phind-codellama qwen qwen2 qwen2-math qwen2.5 qwen2.5-coder qwq reader-lm
reefer-her2 reefer-minimonica reefer-monica reflection rfc-whiterabbitneo
rouge-replete-coder-qwen2-1.5b samantha-mistral sammcj-smaug-mixtral-v0.1
savethedoctor-whiterabbitneo13bq8_0 shieldgemma smollm snowflake-arctic-embed
solar solar-pro sparksammy-samantha sparksammy-samantha-3.1
sparksammy-samantha-eggplant sparksammy-samantha-v3-uncensored
sparksammy-tinysam-goog sparksammy-tinysam-msft sqlcoder stable-beluga
stable-code stablelm-zephyr stablelm2 starcoder starcoder2 starling-lm
themanofrod-travel-agent tinydolphin tinyllama tulu3 vicuna wizard-math
wizard-vicuna wizard-vicuna-uncensored wizardcoder wizardlm wizardlm-uncensored
wizardlm2 xwinlm yarn-llama2 yarn-mistral yi yi-coder zephyr
)
LLVM_COMPAT=( 17 )
CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="daemon network server untrusted-data"
#
# To update use this run `ebuild ollama-0.4.2.ebuild digest clean unpack`
# changing GEN_EBUILD with the following transition states 0 -> 1 -> 2 -> 0
#
GEN_EBUILD=0
EGO_PN="github.com/ollama/ollama"
LLAMA_CPP_UPDATE=0
ROCM_SLOTS=(
	# Limited by libhipblas.so.2 hardcoded SOVERSION
	"6.1"
)
gen_rocm_iuse() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}
		"
	done
}
ROCM_IUSE=( $(gen_rocm_iuse) )
inherit hip-versions
declare -A ROCM_VERSIONS=(
	["6_1"]="${HIP_6_1_VERSION}"
)
if ! [[ "${PV}" =~ "9999" ]] ; then
	export S_GO="${WORKDIR}/go-mod"
fi

inherit cflags-hardened check-compiler-switch dep-prepare edo flag-o-matic go-module lcnr multiprocessing optfeature rocm


# protobuf-go 1.34.1 tests with protobuf 5.27.0-rc1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ollama/ollama.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	FALLBACK_COMMIT="5f8051180e3b9aeafc153f6b5056e7358a939c88" # Nov 29, 2024
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${P}"

	EGO_SUM=(
		"github.com/golang/protobuf v1.5.0"
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/google/go-cmp v0.5.5"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"github.com/davecgh/go-spew v1.1.0"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/testify v1.1.4"
		"github.com/stretchr/testify v1.1.4/go.mod"
		"github.com/chewxy/math32 v1.0.0"
		"github.com/chewxy/math32 v1.0.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/testify v1.1.4"
		"github.com/stretchr/testify v1.1.4/go.mod"
		"rsc.io/pdf v0.1.1"
		"rsc.io/pdf v0.1.1/go.mod"
		"golang.org/x/mod v0.17.0"
		"golang.org/x/mod v0.17.0/go.mod"
		"golang.org/x/sync v0.9.0"
		"golang.org/x/sync v0.9.0/go.mod"
		"golang.org/x/tools v0.21.1-0.20240508182429-e35e4ccd0d2d"
		"golang.org/x/tools v0.21.1-0.20240508182429-e35e4ccd0d2d/go.mod"
		"github.com/google/go-cmp v0.5.8"
		"github.com/google/go-cmp v0.5.8/go.mod"
		"golang.org/x/mod v0.14.0"
		"golang.org/x/mod v0.14.0/go.mod"
		"golang.org/x/sync v0.5.0"
		"golang.org/x/sys v0.14.0"
		"golang.org/x/sys v0.14.0/go.mod"
		"golang.org/x/tools v0.15.0"
		"golang.org/x/tools v0.15.0/go.mod"
		"golang.org/x/sys v0.20.0"
		"golang.org/x/sys v0.20.0/go.mod"
		"golang.org/x/crypto v0.23.0"
		"golang.org/x/crypto v0.23.0/go.mod"
		"golang.org/x/sys v0.20.0"
		"golang.org/x/sys v0.20.0/go.mod"
		"golang.org/x/term v0.20.0"
		"golang.org/x/term v0.20.0/go.mod"
		"golang.org/x/text v0.15.0"
		"golang.org/x/text v0.15.0/go.mod"
		"golang.org/x/net v0.21.0"
		"golang.org/x/net v0.21.0/go.mod"
		"golang.org/x/sys v0.20.0"
		"golang.org/x/sys v0.20.0/go.mod"
		"golang.org/x/term v0.20.0"
		"golang.org/x/term v0.20.0/go.mod"
		"golang.org/x/text v0.15.0"
		"golang.org/x/text v0.15.0/go.mod"
		"golang.org/x/text v0.20.0"
		"golang.org/x/text v0.20.0/go.mod"
		"git.sr.ht/~sbinet/cmpimg v0.1.0"
		"git.sr.ht/~sbinet/gg v0.5.0"
		"git.sr.ht/~sbinet/gg v0.5.0/go.mod"
		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/ajstarks/deck v0.0.0-20200831202436-30c9fc6549a9/go.mod"
		"github.com/ajstarks/deck/generate v0.0.0-20210309230005-c3f852c02e19/go.mod"
		"github.com/ajstarks/svgo v0.0.0-20211024235047-1546f124cd8b"
		"github.com/ajstarks/svgo v0.0.0-20211024235047-1546f124cd8b/go.mod"
		"github.com/campoy/embedmd v1.0.0"
		"github.com/campoy/embedmd v1.0.0/go.mod"
		"github.com/go-fonts/dejavu v0.3.2"
		"github.com/go-fonts/latin-modern v0.3.2"
		"github.com/go-fonts/liberation v0.3.2"
		"github.com/go-fonts/liberation v0.3.2/go.mod"
		"github.com/go-latex/latex v0.0.0-20231108140139-5c1ce85aa4ea"
		"github.com/go-latex/latex v0.0.0-20231108140139-5c1ce85aa4ea/go.mod"
		"github.com/go-pdf/fpdf v0.9.0"
		"github.com/go-pdf/fpdf v0.9.0/go.mod"
		"github.com/goccmack/gocc v0.0.0-20230228185258-2292f9e40198"
		"github.com/goccmack/gocc v0.0.0-20230228185258-2292f9e40198/go.mod"
		"github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0"
		"github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0/go.mod"
		"github.com/google/go-cmp v0.6.0"
		"github.com/google/go-cmp v0.6.0/go.mod"
		"github.com/kisielk/gotool v1.0.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/yuin/goldmark v1.2.1/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
		"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa/go.mod"
		"golang.org/x/image v0.14.0"
		"golang.org/x/image v0.14.0/go.mod"
		"golang.org/x/mod v0.3.0/go.mod"
		"golang.org/x/mod v0.14.0"
		"golang.org/x/mod v0.14.0/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
		"golang.org/x/sys v0.0.0-20210119212857-b64e53b001e4/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.14.0"
		"golang.org/x/text v0.14.0/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.1.0/go.mod"
		"golang.org/x/tools v0.15.0"
		"golang.org/x/tools v0.15.0/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
		"gonum.org/v1/plot v0.14.0"
		"gonum.org/v1/plot v0.14.0/go.mod"
		"honnef.co/go/tools v0.1.3/go.mod"
		"rsc.io/pdf v0.1.1"
		"rsc.io/pdf v0.1.1/go.mod"
		"github.com/kr/pretty v0.2.1"
		"github.com/kr/pretty v0.2.1/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/text v0.1.0"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/creack/pty v1.1.9/go.mod"
		"github.com/kr/pretty v0.1.0/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/text v0.1.0"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/kr/text v0.2.0"
		"github.com/kr/text v0.2.0/go.mod"
		"github.com/rogpeppe/go-internal v1.6.1"
		"github.com/rogpeppe/go-internal v1.6.1/go.mod"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
		"gopkg.in/errgo.v2 v2.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/testify v1.8.4"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"github.com/mattn/go-runewidth v0.0.9"
		"github.com/mattn/go-runewidth v0.0.9/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/objx v0.5.2/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"github.com/cpuguy83/go-md2man/v2 v2.0.2"
		"github.com/cpuguy83/go-md2man/v2 v2.0.2/go.mod"
		"github.com/inconshreveable/mousetrap v1.1.0"
		"github.com/inconshreveable/mousetrap v1.1.0/go.mod"
		"github.com/russross/blackfriday/v2 v2.1.0"
		"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
		"github.com/spf13/pflag v1.0.5"
		"github.com/spf13/pflag v1.0.5/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"cloud.google.com/go v0.26.0/go.mod"
		"cloud.google.com/go v0.34.0/go.mod"
		"dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9/go.mod"
		"gioui.org v0.0.0-20210308172011-57750fc8a0a6/go.mod"
		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
		"github.com/ajstarks/svgo v0.0.0-20180226025133-644b8db467af/go.mod"
		"github.com/antihax/optional v1.0.0/go.mod"
		"github.com/boombuler/barcode v1.0.0/go.mod"
		"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
		"github.com/client9/misspell v0.3.4/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20201120205902-5459f2c99403/go.mod"
		"github.com/cncf/xds/go v0.0.0-20210312221358-fbca930ec8ed/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.1-0.20191026205805-5f8ba28d4473/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.4/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20201210154907-fd9021fe5dad/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210217033140-668b12f5399d/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210512163311-63b5d3c536b0/go.mod"
		"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
		"github.com/fogleman/gg v1.2.1-0.20190220221249-0403632d5b90/go.mod"
		"github.com/fogleman/gg v1.3.0/go.mod"
		"github.com/ghodss/yaml v1.0.0/go.mod"
		"github.com/go-fonts/dejavu v0.1.0/go.mod"
		"github.com/go-fonts/latin-modern v0.2.0/go.mod"
		"github.com/go-fonts/liberation v0.1.1/go.mod"
		"github.com/go-fonts/stix v0.1.0/go.mod"
		"github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1/go.mod"
		"github.com/go-latex/latex v0.0.0-20210118124228-b3d85cf34e07/go.mod"
		"github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0/go.mod"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
		"github.com/golang/mock v1.1.1/go.mod"
		"github.com/golang/protobuf v1.2.0/go.mod"
		"github.com/golang/protobuf v1.3.2/go.mod"
		"github.com/golang/protobuf v1.3.3/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
		"github.com/golang/protobuf v1.4.0/go.mod"
		"github.com/golang/protobuf v1.4.1/go.mod"
		"github.com/golang/protobuf v1.4.2/go.mod"
		"github.com/golang/protobuf v1.4.3/go.mod"
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/golang/protobuf v1.5.2"
		"github.com/golang/protobuf v1.5.2/go.mod"
		"github.com/golang/snappy v0.0.3"
		"github.com/golang/snappy v0.0.3/go.mod"
		"github.com/google/flatbuffers v2.0.0+incompatible"
		"github.com/google/flatbuffers v2.0.0+incompatible/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/google/go-cmp v0.3.0/go.mod"
		"github.com/google/go-cmp v0.3.1/go.mod"
		"github.com/google/go-cmp v0.4.0/go.mod"
		"github.com/google/go-cmp v0.5.0/go.mod"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"github.com/google/go-cmp v0.5.6"
		"github.com/google/go-cmp v0.5.6/go.mod"
		"github.com/google/uuid v1.1.2/go.mod"
		"github.com/grpc-ecosystem/grpc-gateway v1.16.0/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.0/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.3-0.20190309125859-24315acbbda5/go.mod"
		"github.com/klauspost/compress v1.13.1"
		"github.com/klauspost/compress v1.13.1/go.mod"
		"github.com/phpdave11/gofpdf v1.4.2/go.mod"
		"github.com/phpdave11/gofpdi v1.0.12/go.mod"
		"github.com/pierrec/lz4/v4 v4.1.8"
		"github.com/pierrec/lz4/v4 v4.1.8/go.mod"
		"github.com/pkg/errors v0.8.1/go.mod"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
		"github.com/rogpeppe/fastuuid v1.2.0/go.mod"
		"github.com/ruudk/golang-pdf417 v0.0.0-20181029194003-1af4ab5afa58/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.2.2/go.mod"
		"github.com/stretchr/testify v1.5.1/go.mod"
		"github.com/stretchr/testify v1.7.0"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/yuin/goldmark v1.3.5/go.mod"
		"go.opentelemetry.io/proto/otlp v0.7.0/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
		"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
		"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
		"golang.org/x/exp v0.0.0-20180321215751-8460e604b9de/go.mod"
		"golang.org/x/exp v0.0.0-20180807140117-3d87b88a115f/go.mod"
		"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
		"golang.org/x/exp v0.0.0-20190125153040-c74c464bbbf2/go.mod"
		"golang.org/x/exp v0.0.0-20190306152737-a1d7652674e8/go.mod"
		"golang.org/x/exp v0.0.0-20191002040644-a1355ae1e2c3"
		"golang.org/x/exp v0.0.0-20191002040644-a1355ae1e2c3/go.mod"
		"golang.org/x/image v0.0.0-20180708004352-c73c2afc3b81/go.mod"
		"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
		"golang.org/x/image v0.0.0-20190802002840-cff245a6509b/go.mod"
		"golang.org/x/image v0.0.0-20190910094157-69e4b8554b2a/go.mod"
		"golang.org/x/image v0.0.0-20200119044424-58c23975cae1/go.mod"
		"golang.org/x/image v0.0.0-20200430140353-33d19683fad8/go.mod"
		"golang.org/x/image v0.0.0-20200618115811-c13761719519/go.mod"
		"golang.org/x/image v0.0.0-20201208152932-35266b937fa6/go.mod"
		"golang.org/x/image v0.0.0-20210216034530-4410531fe030/go.mod"
		"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
		"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
		"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
		"golang.org/x/lint v0.0.0-20210508222113-6edffad5e616/go.mod"
		"golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028/go.mod"
		"golang.org/x/mod v0.1.0/go.mod"
		"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
		"golang.org/x/mod v0.4.2/go.mod"
		"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
		"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
		"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
		"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
		"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20200822124328-c89045814202/go.mod"
		"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
		"golang.org/x/net v0.0.0-20210614182718-04defd469f4e"
		"golang.org/x/net v0.0.0-20210614182718-04defd469f4e/go.mod"
		"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
		"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d/go.mod"
		"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
		"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
		"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
		"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210304124612-50617c2ba197/go.mod"
		"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
		"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
		"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
		"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c"
		"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.5/go.mod"
		"golang.org/x/text v0.3.6"
		"golang.org/x/text v0.3.6/go.mod"
		"golang.org/x/tools v0.0.0-20180525024113-a5b4c53f6e8b/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
		"golang.org/x/tools v0.0.0-20190206041539-40960b6deb8e/go.mod"
		"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
		"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
		"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
		"golang.org/x/tools v0.0.0-20190927191325-030b2cf1153e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7/go.mod"
		"golang.org/x/tools v0.1.4/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
		"gonum.org/v1/gonum v0.0.0-20180816165407-929014505bf4/go.mod"
		"gonum.org/v1/gonum v0.8.2/go.mod"
		"gonum.org/v1/gonum v0.9.3"
		"gonum.org/v1/gonum v0.9.3/go.mod"
		"gonum.org/v1/netlib v0.0.0-20190313105609-8cb42192e0e0"
		"gonum.org/v1/netlib v0.0.0-20190313105609-8cb42192e0e0/go.mod"
		"gonum.org/v1/plot v0.0.0-20190515093506-e2840ee46a6b/go.mod"
		"gonum.org/v1/plot v0.9.0/go.mod"
		"google.golang.org/appengine v1.1.0/go.mod"
		"google.golang.org/appengine v1.4.0/go.mod"
		"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
		"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
		"google.golang.org/genproto v0.0.0-20200513103714-09dca8ec2884/go.mod"
		"google.golang.org/genproto v0.0.0-20200526211855-cb27e3aa2013/go.mod"
		"google.golang.org/genproto v0.0.0-20210630183607-d20f26d13c79"
		"google.golang.org/genproto v0.0.0-20210630183607-d20f26d13c79/go.mod"
		"google.golang.org/grpc v1.19.0/go.mod"
		"google.golang.org/grpc v1.23.0/go.mod"
		"google.golang.org/grpc v1.25.1/go.mod"
		"google.golang.org/grpc v1.27.0/go.mod"
		"google.golang.org/grpc v1.33.1/go.mod"
		"google.golang.org/grpc v1.36.0/go.mod"
		"google.golang.org/grpc v1.38.0/go.mod"
		"google.golang.org/grpc v1.39.0"
		"google.golang.org/grpc v1.39.0/go.mod"
		"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
		"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
		"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
		"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
		"google.golang.org/protobuf v1.21.0/go.mod"
		"google.golang.org/protobuf v1.22.0/go.mod"
		"google.golang.org/protobuf v1.23.0/go.mod"
		"google.golang.org/protobuf v1.23.1-0.20200526195155-81db48ad09cc/go.mod"
		"google.golang.org/protobuf v1.25.0/go.mod"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"google.golang.org/protobuf v1.26.0/go.mod"
		"google.golang.org/protobuf v1.27.1"
		"google.golang.org/protobuf v1.27.1/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v2 v2.2.2/go.mod"
		"gopkg.in/yaml.v2 v2.2.3/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
		"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
		"golang.org/x/net v0.17.0"
		"golang.org/x/net v0.17.0/go.mod"
		"github.com/golang/snappy v0.0.3"
		"github.com/golang/snappy v0.0.3/go.mod"
		"golang.org/x/sys v0.0.0-20220704084225-05e143d24a9e"
		"golang.org/x/sys v0.0.0-20220704084225-05e143d24a9e/go.mod"
		"golang.org/x/sys v0.5.0"
		"golang.org/x/sys v0.5.0/go.mod"
		"github.com/yuin/goldmark v1.4.13/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
		"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
		"golang.org/x/mod v0.8.0/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
		"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
		"golang.org/x/net v0.6.0/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
		"golang.org/x/sync v0.1.0/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
		"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
		"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
		"golang.org/x/sys v0.5.0/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
		"golang.org/x/term v0.5.0/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.7/go.mod"
		"golang.org/x/text v0.7.0/go.mod"
		"golang.org/x/text v0.14.0"
		"golang.org/x/text v0.14.0/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.1.12/go.mod"
		"golang.org/x/tools v0.6.0/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"github.com/arbovm/levenshtein v0.0.0-20160628152529-48b4e1c0c4d0"
		"github.com/arbovm/levenshtein v0.0.0-20160628152529-48b4e1c0c4d0/go.mod"
		"github.com/dgryski/trifles v0.0.0-20200323201526-dd97f9abfb48"
		"github.com/dgryski/trifles v0.0.0-20200323201526-dd97f9abfb48/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/gabriel-vasile/mimetype v1.4.3"
		"github.com/gabriel-vasile/mimetype v1.4.3/go.mod"
		"github.com/go-playground/assert/v2 v2.2.0"
		"github.com/go-playground/assert/v2 v2.2.0/go.mod"
		"github.com/go-playground/locales v0.14.1"
		"github.com/go-playground/locales v0.14.1/go.mod"
		"github.com/go-playground/universal-translator v0.18.1"
		"github.com/go-playground/universal-translator v0.18.1/go.mod"
		"github.com/leodido/go-urn v1.4.0"
		"github.com/leodido/go-urn v1.4.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/stretchr/testify v1.8.4"
		"golang.org/x/crypto v0.19.0"
		"golang.org/x/crypto v0.19.0/go.mod"
		"golang.org/x/net v0.21.0"
		"golang.org/x/net v0.21.0/go.mod"
		"golang.org/x/sys v0.17.0"
		"golang.org/x/sys v0.17.0/go.mod"
		"golang.org/x/text v0.14.0"
		"golang.org/x/text v0.14.0/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"github.com/go-playground/locales v0.14.1"
		"github.com/go-playground/locales v0.14.1/go.mod"
		"github.com/yuin/goldmark v1.4.13/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
		"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
		"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
		"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
		"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.7/go.mod"
		"golang.org/x/text v0.3.8"
		"golang.org/x/text v0.3.8/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.1.12/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/knz/go-libedit v1.10.1"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.7.0"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"nullprogram.com/x/optparse v1.0.0"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"github.com/bytedance/sonic/loader v0.1.1"
		"github.com/bytedance/sonic/loader v0.1.1/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"github.com/bytedance/sonic/loader v0.1.1"
		"github.com/bytedance/sonic/loader v0.1.1/go.mod"
		"github.com/cloudwego/base64x v0.1.4"
		"github.com/cloudwego/base64x v0.1.4/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"github.com/twitchyliquid64/golang-asm v0.15.1"
		"github.com/twitchyliquid64/golang-asm v0.15.1/go.mod"
		"golang.org/x/arch v0.0.0-20210923205945-b76863e36670"
		"golang.org/x/arch v0.0.0-20210923205945-b76863e36670/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
		"github.com/bytedance/sonic v1.11.6"
		"github.com/bytedance/sonic v1.11.6/go.mod"
		"github.com/bytedance/sonic/loader v0.1.1"
		"github.com/bytedance/sonic/loader v0.1.1/go.mod"
		"github.com/cloudwego/base64x v0.1.4"
		"github.com/cloudwego/base64x v0.1.4/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/creack/pty v1.1.9/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/gabriel-vasile/mimetype v1.4.3"
		"github.com/gabriel-vasile/mimetype v1.4.3/go.mod"
		"github.com/gin-contrib/sse v0.1.0"
		"github.com/gin-contrib/sse v0.1.0/go.mod"
		"github.com/gin-gonic/gin v1.9.1"
		"github.com/gin-gonic/gin v1.9.1/go.mod"
		"github.com/go-playground/assert/v2 v2.2.0"
		"github.com/go-playground/locales v0.14.1"
		"github.com/go-playground/locales v0.14.1/go.mod"
		"github.com/go-playground/universal-translator v0.18.1"
		"github.com/go-playground/universal-translator v0.18.1/go.mod"
		"github.com/go-playground/validator/v10 v10.20.0"
		"github.com/go-playground/validator/v10 v10.20.0/go.mod"
		"github.com/goccy/go-json v0.10.2"
		"github.com/goccy/go-json v0.10.2/go.mod"
		"github.com/google/go-cmp v0.5.5"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/json-iterator/go v1.1.12"
		"github.com/json-iterator/go v1.1.12/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/klauspost/cpuid/v2 v2.2.7"
		"github.com/klauspost/cpuid/v2 v2.2.7/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/kr/pretty v0.1.0/go.mod"
		"github.com/kr/pretty v0.2.1/go.mod"
		"github.com/kr/pretty v0.3.0"
		"github.com/kr/pretty v0.3.0/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/kr/text v0.2.0"
		"github.com/kr/text v0.2.0/go.mod"
		"github.com/leodido/go-urn v1.4.0"
		"github.com/leodido/go-urn v1.4.0/go.mod"
		"github.com/mattn/go-isatty v0.0.20"
		"github.com/mattn/go-isatty v0.0.20/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
		"github.com/modern-go/reflect2 v1.0.2"
		"github.com/modern-go/reflect2 v1.0.2/go.mod"
		"github.com/pelletier/go-toml/v2 v2.2.1"
		"github.com/pelletier/go-toml/v2 v2.2.1/go.mod"
		"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/rogpeppe/go-internal v1.6.1/go.mod"
		"github.com/rogpeppe/go-internal v1.8.0"
		"github.com/rogpeppe/go-internal v1.8.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/objx v0.5.2/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"github.com/twitchyliquid64/golang-asm v0.15.1"
		"github.com/twitchyliquid64/golang-asm v0.15.1/go.mod"
		"github.com/ugorji/go/codec v1.2.12"
		"github.com/ugorji/go/codec v1.2.12/go.mod"
		"golang.org/x/arch v0.0.0-20210923205945-b76863e36670/go.mod"
		"golang.org/x/arch v0.7.0"
		"golang.org/x/arch v0.7.0/go.mod"
		"golang.org/x/crypto v0.22.0"
		"golang.org/x/crypto v0.22.0/go.mod"
		"golang.org/x/net v0.24.0"
		"golang.org/x/net v0.24.0/go.mod"
		"golang.org/x/sys v0.5.0/go.mod"
		"golang.org/x/sys v0.6.0/go.mod"
		"golang.org/x/sys v0.19.0"
		"golang.org/x/sys v0.19.0/go.mod"
		"golang.org/x/text v0.14.0"
		"golang.org/x/text v0.14.0/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
		"google.golang.org/protobuf v1.34.0"
		"google.golang.org/protobuf v1.34.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
		"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
		"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
		"gopkg.in/errgo.v2 v2.1.0/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
		"github.com/davecgh/go-spew v1.1.0"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.3.0"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/bytedance/sonic v1.11.6"
		"github.com/bytedance/sonic v1.11.6/go.mod"
		"github.com/bytedance/sonic/loader v0.1.1"
		"github.com/bytedance/sonic/loader v0.1.1/go.mod"
		"github.com/cloudwego/base64x v0.1.4"
		"github.com/cloudwego/base64x v0.1.4/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/gabriel-vasile/mimetype v1.4.3"
		"github.com/gabriel-vasile/mimetype v1.4.3/go.mod"
		"github.com/gin-contrib/sse v0.1.0"
		"github.com/gin-contrib/sse v0.1.0/go.mod"
		"github.com/go-playground/assert/v2 v2.2.0"
		"github.com/go-playground/locales v0.14.1"
		"github.com/go-playground/locales v0.14.1/go.mod"
		"github.com/go-playground/universal-translator v0.18.1"
		"github.com/go-playground/universal-translator v0.18.1/go.mod"
		"github.com/go-playground/validator/v10 v10.20.0"
		"github.com/go-playground/validator/v10 v10.20.0/go.mod"
		"github.com/goccy/go-json v0.10.2"
		"github.com/goccy/go-json v0.10.2/go.mod"
		"github.com/google/go-cmp v0.5.5"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/json-iterator/go v1.1.12"
		"github.com/json-iterator/go v1.1.12/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/klauspost/cpuid/v2 v2.2.7"
		"github.com/klauspost/cpuid/v2 v2.2.7/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/leodido/go-urn v1.4.0"
		"github.com/leodido/go-urn v1.4.0/go.mod"
		"github.com/mattn/go-isatty v0.0.20"
		"github.com/mattn/go-isatty v0.0.20/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
		"github.com/modern-go/reflect2 v1.0.2"
		"github.com/modern-go/reflect2 v1.0.2/go.mod"
		"github.com/pelletier/go-toml/v2 v2.2.2"
		"github.com/pelletier/go-toml/v2 v2.2.2/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/objx v0.5.2/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"github.com/twitchyliquid64/golang-asm v0.15.1"
		"github.com/twitchyliquid64/golang-asm v0.15.1/go.mod"
		"github.com/ugorji/go/codec v1.2.12"
		"github.com/ugorji/go/codec v1.2.12/go.mod"
		"golang.org/x/arch v0.0.0-20210923205945-b76863e36670/go.mod"
		"golang.org/x/arch v0.8.0"
		"golang.org/x/arch v0.8.0/go.mod"
		"golang.org/x/crypto v0.23.0"
		"golang.org/x/crypto v0.23.0/go.mod"
		"golang.org/x/net v0.25.0"
		"golang.org/x/net v0.25.0/go.mod"
		"golang.org/x/sys v0.5.0/go.mod"
		"golang.org/x/sys v0.6.0/go.mod"
		"golang.org/x/sys v0.20.0"
		"golang.org/x/sys v0.20.0/go.mod"
		"golang.org/x/text v0.15.0"
		"golang.org/x/text v0.15.0/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
		"google.golang.org/protobuf v1.34.1"
		"google.golang.org/protobuf v1.34.1/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
		"github.com/kisielk/errcheck v1.1.0"
		"github.com/kisielk/errcheck v1.1.0/go.mod"
		"github.com/kisielk/errcheck v1.2.0"
		"github.com/kisielk/errcheck v1.2.0/go.mod"
		"github.com/kisielk/errcheck v1.5.0"
		"github.com/kisielk/errcheck v1.5.0/go.mod"
		"github.com/kisielk/gotool v1.0.0"
		"github.com/kisielk/gotool v1.0.0/go.mod"
		"github.com/yuin/goldmark v1.1.27/go.mod"
		"github.com/yuin/goldmark v1.2.1/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
		"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
		"golang.org/x/mod v0.2.0"
		"golang.org/x/mod v0.2.0/go.mod"
		"golang.org/x/mod v0.3.0"
		"golang.org/x/mod v0.3.0/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
		"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
		"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635"
		"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563"
		"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f"
		"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod"
		"golang.org/x/tools v0.0.0-20210106214847-113979e3529a"
		"golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
		"github.com/rivo/uniseg v0.2.0"
		"github.com/rivo/uniseg v0.2.0/go.mod"
		"golang.org/x/sys v0.6.0"
		"golang.org/x/sys v0.6.0/go.mod"
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/google/go-cmp v0.5.5"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"google.golang.org/protobuf v1.26.0"
		"google.golang.org/protobuf v1.26.0/go.mod"
		"google.golang.org/protobuf v1.33.0"
		"google.golang.org/protobuf v1.33.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/objx v0.5.2"
		"github.com/stretchr/objx v0.5.2/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"github.com/kr/pretty v0.1.0"
		"github.com/kr/pretty v0.1.0/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/text v0.1.0"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e"
		"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e/go.mod"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
		"gopkg.in/errgo.v2 v2.1.0"
		"gopkg.in/errgo.v2 v2.1.0/go.mod"
		"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c"
		"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c/go.mod"
		"cloud.google.com/go v0.26.0/go.mod"
		"cloud.google.com/go v0.34.0/go.mod"
		"dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9/go.mod"
		"gioui.org v0.0.0-20210308172011-57750fc8a0a6/go.mod"
		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
		"github.com/ajstarks/svgo v0.0.0-20180226025133-644b8db467af/go.mod"
		"github.com/antihax/optional v1.0.0/go.mod"
		"github.com/apache/arrow/go/arrow v0.0.0-20211112161151-bc219186db40"
		"github.com/apache/arrow/go/arrow v0.0.0-20211112161151-bc219186db40/go.mod"
		"github.com/boombuler/barcode v1.0.0/go.mod"
		"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
		"github.com/chewxy/hm v1.0.0"
		"github.com/chewxy/hm v1.0.0/go.mod"
		"github.com/chewxy/math32 v1.0.0/go.mod"
		"github.com/chewxy/math32 v1.10.1"
		"github.com/chewxy/math32 v1.10.1/go.mod"
		"github.com/client9/misspell v0.3.4/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20201120205902-5459f2c99403/go.mod"
		"github.com/cncf/xds/go v0.0.0-20210312221358-fbca930ec8ed/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.1-0.20191026205805-5f8ba28d4473/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.4/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20201210154907-fd9021fe5dad/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210217033140-668b12f5399d/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210512163311-63b5d3c536b0/go.mod"
		"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
		"github.com/fogleman/gg v1.2.1-0.20190220221249-0403632d5b90/go.mod"
		"github.com/fogleman/gg v1.3.0/go.mod"
		"github.com/ghodss/yaml v1.0.0/go.mod"
		"github.com/go-fonts/dejavu v0.1.0/go.mod"
		"github.com/go-fonts/latin-modern v0.2.0/go.mod"
		"github.com/go-fonts/liberation v0.1.1/go.mod"
		"github.com/go-fonts/stix v0.1.0/go.mod"
		"github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1/go.mod"
		"github.com/go-latex/latex v0.0.0-20210118124228-b3d85cf34e07/go.mod"
		"github.com/gogo/protobuf v1.3.2"
		"github.com/gogo/protobuf v1.3.2/go.mod"
		"github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0/go.mod"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
		"github.com/golang/mock v1.1.1/go.mod"
		"github.com/golang/protobuf v1.2.0/go.mod"
		"github.com/golang/protobuf v1.3.2/go.mod"
		"github.com/golang/protobuf v1.3.3/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
		"github.com/golang/protobuf v1.4.0/go.mod"
		"github.com/golang/protobuf v1.4.1/go.mod"
		"github.com/golang/protobuf v1.4.2/go.mod"
		"github.com/golang/protobuf v1.4.3/go.mod"
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/golang/protobuf v1.5.2/go.mod"
		"github.com/golang/protobuf v1.5.4"
		"github.com/golang/protobuf v1.5.4/go.mod"
		"github.com/golang/snappy v0.0.3"
		"github.com/golang/snappy v0.0.3/go.mod"
		"github.com/google/flatbuffers v2.0.0+incompatible/go.mod"
		"github.com/google/flatbuffers v24.3.25+incompatible"
		"github.com/google/flatbuffers v24.3.25+incompatible/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/google/go-cmp v0.3.0/go.mod"
		"github.com/google/go-cmp v0.3.1/go.mod"
		"github.com/google/go-cmp v0.4.0/go.mod"
		"github.com/google/go-cmp v0.5.0/go.mod"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"github.com/google/go-cmp v0.5.6/go.mod"
		"github.com/google/go-cmp v0.6.0"
		"github.com/google/go-cmp v0.6.0/go.mod"
		"github.com/google/uuid v1.1.2/go.mod"
		"github.com/grpc-ecosystem/grpc-gateway v1.16.0/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.0/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.3-0.20190309125859-24315acbbda5/go.mod"
		"github.com/kisielk/errcheck v1.5.0/go.mod"
		"github.com/kisielk/gotool v1.0.0/go.mod"
		"github.com/klauspost/compress v1.13.1"
		"github.com/klauspost/compress v1.13.1/go.mod"
		"github.com/phpdave11/gofpdf v1.4.2/go.mod"
		"github.com/phpdave11/gofpdi v1.0.12/go.mod"
		"github.com/pierrec/lz4/v4 v4.1.8"
		"github.com/pierrec/lz4/v4 v4.1.8/go.mod"
		"github.com/pkg/errors v0.8.1/go.mod"
		"github.com/pkg/errors v0.9.1"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
		"github.com/rogpeppe/fastuuid v1.2.0/go.mod"
		"github.com/ruudk/golang-pdf417 v0.0.0-20181029194003-1af4ab5afa58/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.1.4/go.mod"
		"github.com/stretchr/testify v1.2.2/go.mod"
		"github.com/stretchr/testify v1.5.1/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"github.com/xtgo/set v1.0.0"
		"github.com/xtgo/set v1.0.0/go.mod"
		"github.com/yuin/goldmark v1.1.27/go.mod"
		"github.com/yuin/goldmark v1.2.1/go.mod"
		"github.com/yuin/goldmark v1.3.5/go.mod"
		"go.opentelemetry.io/proto/otlp v0.7.0/go.mod"
		"go4.org/unsafe/assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6"
		"go4.org/unsafe/assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
		"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
		"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
		"golang.org/x/exp v0.0.0-20180321215751-8460e604b9de/go.mod"
		"golang.org/x/exp v0.0.0-20180807140117-3d87b88a115f/go.mod"
		"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
		"golang.org/x/exp v0.0.0-20190125153040-c74c464bbbf2/go.mod"
		"golang.org/x/exp v0.0.0-20190306152737-a1d7652674e8/go.mod"
		"golang.org/x/exp v0.0.0-20191002040644-a1355ae1e2c3/go.mod"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa/go.mod"
		"golang.org/x/image v0.0.0-20180708004352-c73c2afc3b81/go.mod"
		"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
		"golang.org/x/image v0.0.0-20190802002840-cff245a6509b/go.mod"
		"golang.org/x/image v0.0.0-20190910094157-69e4b8554b2a/go.mod"
		"golang.org/x/image v0.0.0-20200119044424-58c23975cae1/go.mod"
		"golang.org/x/image v0.0.0-20200430140353-33d19683fad8/go.mod"
		"golang.org/x/image v0.0.0-20200618115811-c13761719519/go.mod"
		"golang.org/x/image v0.0.0-20201208152932-35266b937fa6/go.mod"
		"golang.org/x/image v0.0.0-20210216034530-4410531fe030/go.mod"
		"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
		"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
		"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
		"golang.org/x/lint v0.0.0-20210508222113-6edffad5e616/go.mod"
		"golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028/go.mod"
		"golang.org/x/mod v0.1.0/go.mod"
		"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
		"golang.org/x/mod v0.2.0/go.mod"
		"golang.org/x/mod v0.3.0/go.mod"
		"golang.org/x/mod v0.4.2/go.mod"
		"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
		"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
		"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
		"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
		"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
		"golang.org/x/net v0.0.0-20200822124328-c89045814202/go.mod"
		"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
		"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
		"golang.org/x/net v0.0.0-20210614182718-04defd469f4e/go.mod"
		"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
		"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d/go.mod"
		"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
		"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
		"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
		"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
		"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
		"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
		"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210304124612-50617c2ba197/go.mod"
		"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
		"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
		"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
		"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.5/go.mod"
		"golang.org/x/text v0.3.6/go.mod"
		"golang.org/x/tools v0.0.0-20180525024113-a5b4c53f6e8b/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
		"golang.org/x/tools v0.0.0-20190206041539-40960b6deb8e/go.mod"
		"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
		"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
		"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
		"golang.org/x/tools v0.0.0-20190927191325-030b2cf1153e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7/go.mod"
		"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod"
		"golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod"
		"golang.org/x/tools v0.1.4/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
		"gonum.org/v1/gonum v0.0.0-20180816165407-929014505bf4/go.mod"
		"gonum.org/v1/gonum v0.8.2/go.mod"
		"gonum.org/v1/gonum v0.9.3/go.mod"
		"gonum.org/v1/gonum v0.15.0"
		"gonum.org/v1/gonum v0.15.0/go.mod"
		"gonum.org/v1/netlib v0.0.0-20190313105609-8cb42192e0e0/go.mod"
		"gonum.org/v1/plot v0.0.0-20190515093506-e2840ee46a6b/go.mod"
		"gonum.org/v1/plot v0.9.0/go.mod"
		"google.golang.org/appengine v1.1.0/go.mod"
		"google.golang.org/appengine v1.4.0/go.mod"
		"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
		"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
		"google.golang.org/genproto v0.0.0-20200513103714-09dca8ec2884/go.mod"
		"google.golang.org/genproto v0.0.0-20200526211855-cb27e3aa2013/go.mod"
		"google.golang.org/genproto v0.0.0-20210630183607-d20f26d13c79/go.mod"
		"google.golang.org/grpc v1.19.0/go.mod"
		"google.golang.org/grpc v1.23.0/go.mod"
		"google.golang.org/grpc v1.25.1/go.mod"
		"google.golang.org/grpc v1.27.0/go.mod"
		"google.golang.org/grpc v1.33.1/go.mod"
		"google.golang.org/grpc v1.36.0/go.mod"
		"google.golang.org/grpc v1.38.0/go.mod"
		"google.golang.org/grpc v1.39.0/go.mod"
		"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
		"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
		"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
		"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
		"google.golang.org/protobuf v1.21.0/go.mod"
		"google.golang.org/protobuf v1.22.0/go.mod"
		"google.golang.org/protobuf v1.23.0/go.mod"
		"google.golang.org/protobuf v1.23.1-0.20200526195155-81db48ad09cc/go.mod"
		"google.golang.org/protobuf v1.25.0/go.mod"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"google.golang.org/protobuf v1.26.0/go.mod"
		"google.golang.org/protobuf v1.27.1/go.mod"
		"google.golang.org/protobuf v1.33.0"
		"google.golang.org/protobuf v1.33.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v2 v2.2.2/go.mod"
		"gopkg.in/yaml.v2 v2.2.3/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"gorgonia.org/vecf32 v0.9.0"
		"gorgonia.org/vecf32 v0.9.0/go.mod"
		"gorgonia.org/vecf64 v0.9.0"
		"gorgonia.org/vecf64 v0.9.0/go.mod"
		"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
		"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/google/gofuzz v1.0.0"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/reflect2 v1.0.2"
		"github.com/modern-go/reflect2 v1.0.2/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.3.0"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"cloud.google.com/go v0.26.0/go.mod"
		"cloud.google.com/go v0.34.0/go.mod"
		"dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9/go.mod"
		"gioui.org v0.0.0-20210308172011-57750fc8a0a6/go.mod"
		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
		"github.com/agnivade/levenshtein v1.1.1"
		"github.com/agnivade/levenshtein v1.1.1/go.mod"
		"github.com/ajstarks/svgo v0.0.0-20180226025133-644b8db467af/go.mod"
		"github.com/antihax/optional v1.0.0/go.mod"
		"github.com/apache/arrow/go/arrow v0.0.0-20211112161151-bc219186db40"
		"github.com/apache/arrow/go/arrow v0.0.0-20211112161151-bc219186db40/go.mod"
		"github.com/arbovm/levenshtein v0.0.0-20160628152529-48b4e1c0c4d0"
		"github.com/arbovm/levenshtein v0.0.0-20160628152529-48b4e1c0c4d0/go.mod"
		"github.com/boombuler/barcode v1.0.0/go.mod"
		"github.com/bytedance/sonic v1.11.6"
		"github.com/bytedance/sonic v1.11.6/go.mod"
		"github.com/bytedance/sonic/loader v0.1.1"
		"github.com/bytedance/sonic/loader v0.1.1/go.mod"
		"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
		"github.com/chewxy/hm v1.0.0"
		"github.com/chewxy/hm v1.0.0/go.mod"
		"github.com/chewxy/math32 v1.0.0/go.mod"
		"github.com/chewxy/math32 v1.11.0"
		"github.com/chewxy/math32 v1.11.0/go.mod"
		"github.com/client9/misspell v0.3.4/go.mod"
		"github.com/cloudwego/base64x v0.1.4"
		"github.com/cloudwego/base64x v0.1.4/go.mod"
		"github.com/cloudwego/iasm v0.2.0"
		"github.com/cloudwego/iasm v0.2.0/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f/go.mod"
		"github.com/cncf/udpa/go v0.0.0-20201120205902-5459f2c99403/go.mod"
		"github.com/cncf/xds/go v0.0.0-20210312221358-fbca930ec8ed/go.mod"
		"github.com/containerd/console v1.0.3"
		"github.com/containerd/console v1.0.3/go.mod"
		"github.com/cpuguy83/go-md2man/v2 v2.0.2/go.mod"
		"github.com/creack/pty v1.1.9/go.mod"
		"github.com/d4l3k/go-bfloat16 v0.0.0-20211005043715-690c3bdd05f1"
		"github.com/d4l3k/go-bfloat16 v0.0.0-20211005043715-690c3bdd05f1/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/dgryski/trifles v0.0.0-20200323201526-dd97f9abfb48"
		"github.com/dgryski/trifles v0.0.0-20200323201526-dd97f9abfb48/go.mod"
		"github.com/emirpasic/gods v1.18.1"
		"github.com/emirpasic/gods v1.18.1/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.1-0.20191026205805-5f8ba28d4473/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.4/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20201210154907-fd9021fe5dad/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210217033140-668b12f5399d/go.mod"
		"github.com/envoyproxy/go-control-plane v0.9.9-0.20210512163311-63b5d3c536b0/go.mod"
		"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
		"github.com/fogleman/gg v1.2.1-0.20190220221249-0403632d5b90/go.mod"
		"github.com/fogleman/gg v1.3.0/go.mod"
		"github.com/gabriel-vasile/mimetype v1.4.3"
		"github.com/gabriel-vasile/mimetype v1.4.3/go.mod"
		"github.com/ghodss/yaml v1.0.0/go.mod"
		"github.com/gin-contrib/cors v1.7.2"
		"github.com/gin-contrib/cors v1.7.2/go.mod"
		"github.com/gin-contrib/sse v0.1.0"
		"github.com/gin-contrib/sse v0.1.0/go.mod"
		"github.com/gin-gonic/gin v1.10.0"
		"github.com/gin-gonic/gin v1.10.0/go.mod"
		"github.com/go-fonts/dejavu v0.1.0/go.mod"
		"github.com/go-fonts/latin-modern v0.2.0/go.mod"
		"github.com/go-fonts/liberation v0.1.1/go.mod"
		"github.com/go-fonts/stix v0.1.0/go.mod"
		"github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1/go.mod"
		"github.com/go-latex/latex v0.0.0-20210118124228-b3d85cf34e07/go.mod"
		"github.com/go-playground/assert/v2 v2.2.0"
		"github.com/go-playground/assert/v2 v2.2.0/go.mod"
		"github.com/go-playground/locales v0.14.1"
		"github.com/go-playground/locales v0.14.1/go.mod"
		"github.com/go-playground/universal-translator v0.18.1"
		"github.com/go-playground/universal-translator v0.18.1/go.mod"
		"github.com/go-playground/validator/v10 v10.20.0"
		"github.com/go-playground/validator/v10 v10.20.0/go.mod"
		"github.com/goccy/go-json v0.10.2"
		"github.com/goccy/go-json v0.10.2/go.mod"
		"github.com/gogo/protobuf v1.3.2"
		"github.com/gogo/protobuf v1.3.2/go.mod"
		"github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0/go.mod"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
		"github.com/golang/mock v1.1.1/go.mod"
		"github.com/golang/protobuf v1.2.0/go.mod"
		"github.com/golang/protobuf v1.3.2/go.mod"
		"github.com/golang/protobuf v1.3.3/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
		"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
		"github.com/golang/protobuf v1.4.0/go.mod"
		"github.com/golang/protobuf v1.4.1/go.mod"
		"github.com/golang/protobuf v1.4.2/go.mod"
		"github.com/golang/protobuf v1.4.3/go.mod"
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/golang/protobuf v1.5.2/go.mod"
		"github.com/golang/protobuf v1.5.4"
		"github.com/golang/protobuf v1.5.4/go.mod"
		"github.com/golang/snappy v0.0.3"
		"github.com/golang/snappy v0.0.3/go.mod"
		"github.com/google/flatbuffers v2.0.0+incompatible/go.mod"
		"github.com/google/flatbuffers v24.3.25+incompatible"
		"github.com/google/flatbuffers v24.3.25+incompatible/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/google/go-cmp v0.3.0/go.mod"
		"github.com/google/go-cmp v0.3.1/go.mod"
		"github.com/google/go-cmp v0.4.0/go.mod"
		"github.com/google/go-cmp v0.5.0/go.mod"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"github.com/google/go-cmp v0.5.6/go.mod"
		"github.com/google/go-cmp v0.6.0"
		"github.com/google/go-cmp v0.6.0/go.mod"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/google/uuid v1.1.2/go.mod"
		"github.com/google/uuid v1.6.0"
		"github.com/google/uuid v1.6.0/go.mod"
		"github.com/grpc-ecosystem/grpc-gateway v1.16.0/go.mod"
		"github.com/inconshreveable/mousetrap v1.1.0"
		"github.com/inconshreveable/mousetrap v1.1.0/go.mod"
		"github.com/json-iterator/go v1.1.12"
		"github.com/json-iterator/go v1.1.12/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.0/go.mod"
		"github.com/jung-kurt/gofpdf v1.0.3-0.20190309125859-24315acbbda5/go.mod"
		"github.com/kisielk/errcheck v1.5.0/go.mod"
		"github.com/kisielk/gotool v1.0.0/go.mod"
		"github.com/klauspost/compress v1.13.1"
		"github.com/klauspost/compress v1.13.1/go.mod"
		"github.com/klauspost/cpuid/v2 v2.0.9/go.mod"
		"github.com/klauspost/cpuid/v2 v2.2.7"
		"github.com/klauspost/cpuid/v2 v2.2.7/go.mod"
		"github.com/knz/go-libedit v1.10.1/go.mod"
		"github.com/kr/pretty v0.3.0"
		"github.com/kr/pretty v0.3.0/go.mod"
		"github.com/kr/text v0.2.0"
		"github.com/kr/text v0.2.0/go.mod"
		"github.com/leodido/go-urn v1.4.0"
		"github.com/leodido/go-urn v1.4.0/go.mod"
		"github.com/mattn/go-isatty v0.0.20"
		"github.com/mattn/go-isatty v0.0.20/go.mod"
		"github.com/mattn/go-runewidth v0.0.9/go.mod"
		"github.com/mattn/go-runewidth v0.0.14"
		"github.com/mattn/go-runewidth v0.0.14/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
		"github.com/modern-go/reflect2 v1.0.2"
		"github.com/modern-go/reflect2 v1.0.2/go.mod"
		"github.com/nlpodyssey/gopickle v0.3.0"
		"github.com/nlpodyssey/gopickle v0.3.0/go.mod"
		"github.com/olekukonko/tablewriter v0.0.5"
		"github.com/olekukonko/tablewriter v0.0.5/go.mod"
		"github.com/pdevine/tensor v0.0.0-20240510204454-f88f4562727c"
		"github.com/pdevine/tensor v0.0.0-20240510204454-f88f4562727c/go.mod"
		"github.com/pelletier/go-toml/v2 v2.2.2"
		"github.com/pelletier/go-toml/v2 v2.2.2/go.mod"
		"github.com/phpdave11/gofpdf v1.4.2/go.mod"
		"github.com/phpdave11/gofpdi v1.0.12/go.mod"
		"github.com/pierrec/lz4/v4 v4.1.8"
		"github.com/pierrec/lz4/v4 v4.1.8/go.mod"
		"github.com/pkg/errors v0.8.1/go.mod"
		"github.com/pkg/errors v0.9.1"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
		"github.com/rivo/uniseg v0.2.0"
		"github.com/rivo/uniseg v0.2.0/go.mod"
		"github.com/rogpeppe/fastuuid v1.2.0/go.mod"
		"github.com/rogpeppe/go-internal v1.8.0"
		"github.com/rogpeppe/go-internal v1.8.0/go.mod"
		"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
		"github.com/ruudk/golang-pdf417 v0.0.0-20181029194003-1af4ab5afa58/go.mod"
		"github.com/spf13/cobra v1.7.0"
		"github.com/spf13/cobra v1.7.0/go.mod"
		"github.com/spf13/pflag v1.0.5"
		"github.com/spf13/pflag v1.0.5/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.4.0/go.mod"
		"github.com/stretchr/objx v0.5.0/go.mod"
		"github.com/stretchr/objx v0.5.2/go.mod"
		"github.com/stretchr/testify v1.1.4/go.mod"
		"github.com/stretchr/testify v1.2.2/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/stretchr/testify v1.5.1/go.mod"
		"github.com/stretchr/testify v1.7.0/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.8.0/go.mod"
		"github.com/stretchr/testify v1.8.1/go.mod"
		"github.com/stretchr/testify v1.8.4/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"github.com/twitchyliquid64/golang-asm v0.15.1"
		"github.com/twitchyliquid64/golang-asm v0.15.1/go.mod"
		"github.com/ugorji/go/codec v1.2.12"
		"github.com/ugorji/go/codec v1.2.12/go.mod"
		"github.com/x448/float16 v0.8.4"
		"github.com/x448/float16 v0.8.4/go.mod"
		"github.com/xtgo/set v1.0.0"
		"github.com/xtgo/set v1.0.0/go.mod"
		"github.com/yuin/goldmark v1.1.27/go.mod"
		"github.com/yuin/goldmark v1.2.1/go.mod"
		"github.com/yuin/goldmark v1.3.5/go.mod"
		"go.opentelemetry.io/proto/otlp v0.7.0/go.mod"
		"go4.org/unsafe/assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6"
		"go4.org/unsafe/assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6/go.mod"
		"golang.org/x/arch v0.0.0-20210923205945-b76863e36670/go.mod"
		"golang.org/x/arch v0.8.0"
		"golang.org/x/arch v0.8.0/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
		"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
		"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
		"golang.org/x/crypto v0.23.0"
		"golang.org/x/crypto v0.23.0/go.mod"
		"golang.org/x/exp v0.0.0-20180321215751-8460e604b9de/go.mod"
		"golang.org/x/exp v0.0.0-20180807140117-3d87b88a115f/go.mod"
		"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
		"golang.org/x/exp v0.0.0-20190125153040-c74c464bbbf2/go.mod"
		"golang.org/x/exp v0.0.0-20190306152737-a1d7652674e8/go.mod"
		"golang.org/x/exp v0.0.0-20191002040644-a1355ae1e2c3/go.mod"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa"
		"golang.org/x/exp v0.0.0-20231110203233-9a3e6036ecaa/go.mod"
		"golang.org/x/image v0.0.0-20180708004352-c73c2afc3b81/go.mod"
		"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
		"golang.org/x/image v0.0.0-20190802002840-cff245a6509b/go.mod"
		"golang.org/x/image v0.0.0-20190910094157-69e4b8554b2a/go.mod"
		"golang.org/x/image v0.0.0-20200119044424-58c23975cae1/go.mod"
		"golang.org/x/image v0.0.0-20200430140353-33d19683fad8/go.mod"
		"golang.org/x/image v0.0.0-20200618115811-c13761719519/go.mod"
		"golang.org/x/image v0.0.0-20201208152932-35266b937fa6/go.mod"
		"golang.org/x/image v0.0.0-20210216034530-4410531fe030/go.mod"
		"golang.org/x/image v0.22.0"
		"golang.org/x/image v0.22.0/go.mod"
		"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
		"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
		"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
		"golang.org/x/lint v0.0.0-20210508222113-6edffad5e616/go.mod"
		"golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028/go.mod"
		"golang.org/x/mod v0.1.0/go.mod"
		"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
		"golang.org/x/mod v0.2.0/go.mod"
		"golang.org/x/mod v0.3.0/go.mod"
		"golang.org/x/mod v0.4.2/go.mod"
		"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
		"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
		"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
		"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
		"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
		"golang.org/x/net v0.0.0-20200822124328-c89045814202/go.mod"
		"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
		"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
		"golang.org/x/net v0.0.0-20210614182718-04defd469f4e/go.mod"
		"golang.org/x/net v0.25.0"
		"golang.org/x/net v0.25.0/go.mod"
		"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
		"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d/go.mod"
		"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
		"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
		"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
		"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
		"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
		"golang.org/x/sync v0.9.0"
		"golang.org/x/sync v0.9.0/go.mod"
		"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
		"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c/go.mod"
		"golang.org/x/sys v0.0.0-20210304124612-50617c2ba197/go.mod"
		"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
		"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
		"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
		"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
		"golang.org/x/sys v0.5.0/go.mod"
		"golang.org/x/sys v0.6.0/go.mod"
		"golang.org/x/sys v0.20.0"
		"golang.org/x/sys v0.20.0/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/term v0.20.0"
		"golang.org/x/term v0.20.0/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.5/go.mod"
		"golang.org/x/text v0.3.6/go.mod"
		"golang.org/x/text v0.20.0"
		"golang.org/x/text v0.20.0/go.mod"
		"golang.org/x/tools v0.0.0-20180525024113-a5b4c53f6e8b/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
		"golang.org/x/tools v0.0.0-20190206041539-40960b6deb8e/go.mod"
		"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
		"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
		"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
		"golang.org/x/tools v0.0.0-20190927191325-030b2cf1153e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7/go.mod"
		"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod"
		"golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod"
		"golang.org/x/tools v0.1.4/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
		"gonum.org/v1/gonum v0.0.0-20180816165407-929014505bf4/go.mod"
		"gonum.org/v1/gonum v0.8.2/go.mod"
		"gonum.org/v1/gonum v0.9.3/go.mod"
		"gonum.org/v1/gonum v0.15.0"
		"gonum.org/v1/gonum v0.15.0/go.mod"
		"gonum.org/v1/netlib v0.0.0-20190313105609-8cb42192e0e0/go.mod"
		"gonum.org/v1/plot v0.0.0-20190515093506-e2840ee46a6b/go.mod"
		"gonum.org/v1/plot v0.9.0/go.mod"
		"google.golang.org/appengine v1.1.0/go.mod"
		"google.golang.org/appengine v1.4.0/go.mod"
		"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
		"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
		"google.golang.org/genproto v0.0.0-20200513103714-09dca8ec2884/go.mod"
		"google.golang.org/genproto v0.0.0-20200526211855-cb27e3aa2013/go.mod"
		"google.golang.org/genproto v0.0.0-20210630183607-d20f26d13c79/go.mod"
		"google.golang.org/grpc v1.19.0/go.mod"
		"google.golang.org/grpc v1.23.0/go.mod"
		"google.golang.org/grpc v1.25.1/go.mod"
		"google.golang.org/grpc v1.27.0/go.mod"
		"google.golang.org/grpc v1.33.1/go.mod"
		"google.golang.org/grpc v1.36.0/go.mod"
		"google.golang.org/grpc v1.38.0/go.mod"
		"google.golang.org/grpc v1.39.0/go.mod"
		"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
		"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
		"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
		"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
		"google.golang.org/protobuf v1.21.0/go.mod"
		"google.golang.org/protobuf v1.22.0/go.mod"
		"google.golang.org/protobuf v1.23.0/go.mod"
		"google.golang.org/protobuf v1.23.1-0.20200526195155-81db48ad09cc/go.mod"
		"google.golang.org/protobuf v1.25.0/go.mod"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"google.golang.org/protobuf v1.26.0/go.mod"
		"google.golang.org/protobuf v1.27.1/go.mod"
		"google.golang.org/protobuf v1.34.1"
		"google.golang.org/protobuf v1.34.1/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
		"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
		"gopkg.in/yaml.v2 v2.2.2/go.mod"
		"gopkg.in/yaml.v2 v2.2.3/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
		"gorgonia.org/vecf32 v0.9.0"
		"gorgonia.org/vecf32 v0.9.0/go.mod"
		"gorgonia.org/vecf64 v0.9.0"
		"gorgonia.org/vecf64 v0.9.0/go.mod"
		"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
		"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
		"nullprogram.com/x/optparse v1.0.0/go.mod"
		"rsc.io/pdf v0.1.1/go.mod"
	)
	go-module_set_globals

	if [[ "${GEN_EBUILD}" != "1" ]] ; then
		SRC_URI+="
			${EGO_SUM_SRC_URI}
		"
	fi
	SRC_URI+="
https://github.com/ollama/ollama/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other local large language models (LLMs) synonymous with AI chatbots or AI assistants."
HOMEPAGE="https://ollama.com"
# If the LLM is marked all-rights-reserved, it is a placeholder until it is
# resolved by the model gallery or on discovery.
LLM_LICENSES="
	ollama_llms_adens-quran-guide? (
		llama3_2-LICENSE
		llama3_2-USE_POLICY.md
	)
	ollama_llms_agcobra-liberated-qwen1.5-72b? (
		Tongyi-Qianwen-LICENSE-AGREEMENT
	)
	ollama_llms_akx-viking-7b? (
		Apache-2.0
	)
	ollama_llms_alfred? (
		Apache-2.0
	)
	ollama_llms_ALIENTELLIGENCE-christiancounselor? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-crisisintervention? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-doomsdayurvivalist? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-enriquecastillorincon? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-gamemasterroleplaying? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-holybible? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-mentalwellness? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-pcarchitect? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-prayerline? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-sarah? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-sarahv2? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_ALIENTELLIGENCE-whiterabbit? (
		llama3-LICENSE
		llama3-USE_POLICY.md
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_ALIENTELLIGENCE-whiterabbitv2? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_all-minilm? (
		Apache-2.0
	)
	ollama_llms_Artalius-lixi? (
		llama3_2-LICENSE
		llama3_2-USE_POLICY.md
	)
	ollama_llms_artifish-mlewd-v2.4? (
		CC-BY-NC-4.0
	)
	ollama_llms_athene-v2? (
		Nexusflow.ai-License-Terms-for-Personal-Use
	)
	ollama_llms_aya? (
		CC-BY-NC-4.0
		C4AI-Acceptable-Use-Policy
	)
	ollama_llms_aya-expanse? (
		CC-BY-NC-4.0
		C4AI-Acceptable-Use-Policy
	)
	ollama_llms_bakllava? (
		Apache-2.0
	)
	ollama_llms_benevolentjoker-belial? (
		benevolentjoker-Use-Agreement
	)
	ollama_llms_benevolentjoker-bethanygpt? (
		benevolentjoker-Use-Agreement
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_benevolentjoker-nsfwmonika? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_benevolentjoker-nsfwvanessa? (
		all-rights-reserved
	)
	ollama_llms_benevolentjoker-satan? (
		all-rights-reserved
	)
	ollama_llms_bespoke-minicheck? (
		CC-BY-NC-4.0
	)
	ollama_llms_bge-large? (
		MIT
	)
	ollama_llms_bge-m3? (
		MIT
	)
	ollama_llms_canadiangamer-neena? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_canadiangamer-priya? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_captainkyd-whiterabbitneo7b? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_chatgph-70b-instruct? (
		Apache-2.0
	)
	ollama_llms_chatgph-gph-main? (
		all-rights-reserved
	)
	ollama_llms_chatgph-medix-ph? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_codebooga? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_codegeex4? (
		glm-4-9b-LICENSE
	)
	ollama_llms_codegemma? (
		Gemma-Terms-of-Use-20240221
	)
	ollama_llms_codellama? (
		llama2-LICENSE
		codellama-USE_POLICY.md
	)
	ollama_llms_codeqwen? (
		Tongyi-Qianwen-LICENSE-AGREEMENT
	)
	ollama_llms_codestral? (
		MNPL-0.1.md
	)
	ollama_llms_codeup? (
		CreativeML-Open-RAIL++-M-License-20230726
	)
	ollama_llms_command-r? (
		CC-BY-NC-4.0
	)
	ollama_llms_command-r-plus? (
		CC-BY-NC-4.0
	)
	ollama_llms_dbrx? (
		Databricks-Open-Model-License
		Databricks-Open-Model-Acceptable-Use-Policy
	)
	ollama_llms_deepseek-coder? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
	)
	ollama_llms_deepseek-coder-v2? (
		MIT
		DEEPSEEK-LICENSE-AGREEMENT-1.0
	)
	ollama_llms_deepseek-v2? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
	)
	ollama_llms_deepseek-v2.5? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
	)
	ollama_llms_deepseek-llm? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
	)
	ollama_llms_disinfozone-telos? (
		all-rights-reserved
	)
	ollama_llms_dolphin-llama3? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_dolphin-mistral? (
		Apache-2.0
	)
	ollama_llms_dolphin-mixtral? (
		Apache-2.0
	)
	ollama_llms_dolphin-phi? (
		MICROSOFT-RESEARCH-LICENSE-TERMS
	)
	ollama_llms_dolphincoder? (
		BigCode-Open-RAIL-M-v1-License-Agreement
	)
	ollama_llms_duckdb-nsql? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_ehartford-theprofessor? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_eramax-aura_v3? (
		Apache-2.0
	)
	ollama_llms_everythinglm? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_falcon? (
		Apache-2.0
	)
	ollama_llms_falcon2? (
		Falcon-2-11B-TII-License-1.0
		Falcon-2-11B-TII-Acceptable-Use-Policy-1.0
	)
	ollama_llms_firefunction-v2? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_fixt-home-3b-v3? (
		STABILITY-AI-NON-COMMERCIAL-RESEARCH-COMMUNITY-LICENSE-AGREEMENT
	)
	ollama_llms_gemma? (
		Gemma-Terms-of-Use-20240221
		Gemma-Prohibited-Use-Policy-20240221
	)
	ollama_llms_gemma2? (
		Gemma-Terms-of-Use-20240221
		Gemma-Prohibited-Use-Policy-20240221
	)
	ollama_llms_glm4? (
		glm-4-9b-LICENSE
	)
	ollama_llms_goliath? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_granite-code? (
		Apache-2.0
	)
	ollama_llms_granite3-dense? (
		Apache-2.0
	)
	ollama_llms_granite3-guardian? (
		Apache-2.0
	)
	ollama_llms_granite3-moe? (
		Apache-2.0
	)
	ollama_llms_hemanth-chessplayer? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_hermes3? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_hookingai-monah-8b? (
		Apache-2.0
	)
	ollama_llms_internlm2? (
		Apache-2.0
	)
	ollama_llms_jimscard-adult-film-screenwriter-nsfw? (
		Apache-2.0
	)
	ollama_llms_jimscard-whiterabbit-neo? (
		llama2-LICENSE
		llama2-USE_POLICY.md
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_joefamous-grok-1? (
		Apache-2.0
	)
	ollama_llms_llama-guard3? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_llama-pro? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_llama2? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_llama2-chinese? (
		Apache-2.0
	)
	ollama_llms_llama2-uncensored? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_llama3? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_llama3-chatqa? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_llama3-gradient? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_llama3-groq-tool-use? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_llama3.1? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_llama3.2? (
		llama3_2-LICENSE
		llama3_2-USE_POLICY.md
	)
	ollama_llms_llama3.2-vision? (
		llama3_2-LICENSE
		llama3_2-USE_POLICY.md
	)
	ollama_llms_llava? (
		Apache-2.0
	)
	ollama_llms_llava-llama3? (
		all-rights-reserved
	)
	ollama_llms_llava-phi3? (
		all-rights-reserved
	)
	ollama_llms_leeplenty-lumimaid-v0.2? (
		Apache-2.0
		CC-BY-NC-4.0
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_magicoder? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_mannix-llamax3-8b-alpaca? (
		MIT
	)
	ollama_llms_mannix-smaug-qwen2-72b? (
		Tongyi-Qianwen-LICENSE-AGREEMENT
	)
	ollama_llms_mannix-replete-adapted-llama3-8b? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_mannix-replete-coder-llama3-8b? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_marco-o1? (
		Apache-2.0
	)
	ollama_llms_mathstral? (
		Apache-2.0
	)
	ollama_llms_meditron? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_medllama2? (
		MIT
	)
	ollama_llms_megadolphin? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_minicpm-v? (
		Apache-2.0
	)
	ollama_llms_mistral? (
		Apache-2.0
	)
	ollama_llms_mistral-large? (
		MRL-0.1.md
	)
	ollama_llms_mistral-nemo? (
		Apache-2.0
	)
	ollama_llms_mistral-openorca? (
		Apache-2.0
	)
	ollama_llms_mistral-small? (
		Apache-2.0
		MRL-0.1.md
	)
	ollama_llms_mistrallite? (
		Apache-2.0
	)
	ollama_llms_mixtral? (
		Apache-2.0
	)
	ollama_llms_mxbai-embed-large? (
		Apache-2.0
	)
	ollama_llms_nemotron? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
		Meta-Privacy-Policy
	)
	ollama_llms_nemotron-mini? (
		NVIDIA-AI-Foundation-Models-Community-License-Agreement
	)
	ollama_llms_moondream? (
		Apache-2.0
	)
	ollama_llms_monotykamary-whiterabbitneo-v1.5a? (
		DEEPSEEK-LICENSE-AGREEMENT-1.0
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_neural-chat? (
		Apache-2.0
	)
	ollama_llms_nexusraven? (
		NexusRaven-V2-13B-LICENSE
	)
	ollama_llms_nomic-embed-text? (
		Apache-2.0
	)
	ollama_llms_notus? (
		MIT
	)
	ollama_llms_notux? (
		MIT
	)
	ollama_llms_nous-hermes? (
		MIT
		GPL-2+
	)
	ollama_llms_nous-hermes2? (
		Apache-2.0
	)
	ollama_llms_nous-hermes2-mixtral? (
		Apache-2.0
	)
	ollama_llms_nqduc-gemsura? (
		Apache-2.0
	)
	ollama_llms_nqduc-mixsura? (
		Apache-2.0
	)
	ollama_llms_nqduc-mixsura-sft? (
		Apache-2.0
	)
	ollama_llms_nuextract? (
		MIT
	)
	ollama_llms_open-orca-platypus2? (
		CC-BY-NC-4.0
	)
	ollama_llms_openchat? (
		Apache-2.0
	)
	ollama_llms_openhermes? (
		Apache-2.0
	)
	ollama_llms_orca-mini? (
		CC-BY-NC-SA-4.0
	)
	ollama_llms_orca2? (
		MICROSOFT-RESEARCH-LICENSE-TERMS
	)
	ollama_llms_paraphrase-multilingual? (
		Apache-2.0
	)
	ollama_llms_partai-dorna-llama3? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_phi? (
		MIT
	)
	ollama_llms_phi3? (
		MIT
	)
	ollama_llms_phi3.5? (
		MIT
	)
	ollama_llms_phind-codellama? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_qwen? (
		Tongyi-Qianwen-LICENSE-AGREEMENT
		Tongyi-Qianwen-RESEARCH-LICENSE-AGREEMENT
	)
	ollama_llms_qwen2? (
		Apache-2.0
		Tongyi-Qianwen-LICENSE-AGREEMENT
	)
	ollama_llms_qwen2-math? (
		Apache-2.0
	)
	ollama_llms_qwen2.5? (
		Apache-2.0
	)
	ollama_llms_qwen2.5-coder? (
		Apache-2.0
	)
	ollama_llms_qwq? (
		Apache-2.0
	)
	ollama_llms_reader-lm? (
		CC-BY-NC-4.0
	)
	ollama_llms_reefer-her2? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_reefer-minimonica? (
		all-rights-reserved
	)
	ollama_llms_reefer-monica? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_reflection? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_rfc-whiterabbitneo? (
		llama2-LICENSE
		llama2-USE_POLICY.md
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_rouge-replete-coder-qwen2-1.5b? (
		Apache-2.0
	)
	ollama_llms_samantha-mistral? (
		Apache-2.0
	)
	ollama_llms_sammcj-smaug-mixtral-v0.1? (
		Apache-2.0
	)
	ollama_llms_savethedoctor-whiterabbitneo13bq8_0? (
		llama2-LICENSE
		llama2-USE_POLICY.md
		WhiteRabbitNeo-Terms-of-Use
		WhiteRabbitNeo-Usage-Restrictions
	)
	ollama_llms_shieldgemma? (
		Gemma-Terms-of-Use-20240401
	)
	ollama_llms_smollm? (
		Apache-2.0
	)
	ollama_llms_snowflake-arctic-embed? (
		Apache-2.0
	)
	ollama_llms_solar? (
		CC-BY-NC-4.0
	)
	ollama_llms_solar-pro? (
		MIT
	)
	ollama_llms_sparksammy-samantha? (
		Apache-2.0
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_sparksammy-samantha-3.1? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_sparksammy-samantha-eggplant? (
		Apache-2.0
		MICROSOFT-RESEARCH-LICENSE-TERMS
		STABILITY-AI-NON-COMMERCIAL-RESEARCH-COMMUNITY-LICENSE-AGREEMENT
		SPL-R5-SR1
	)
	ollama_llms_sparksammy-samantha-v3-uncensored? (
		llama3-LICENSE
		llama3-USE_POLICY.md
	)
	ollama_llms_sparksammy-tinysam-goog? (
		Gemma-Terms-of-Use-20240221
	)
	ollama_llms_sparksammy-tinysam-msft? (
		MIT
	)
	ollama_llms_sqlcoder? (
		CC-BY-SA-4.0
	)
	ollama_llms_stable-beluga? (
		STABLE-BELUGA-NON-COMMERCIAL-COMMUNITY-LICENSE-AGREEMENT
	)
	ollama_llms_stable-code? (
		STABILITY-AI-NON-COMMERCIAL-RESEARCH-COMMUNITY-LICENSE-AGREEMENT
	)
	ollama_llms_stablelm-zephyr? (
		STABILITY-AI-NON-COMMERCIAL-RESEARCH-COMMUNITY-LICENSE-AGREEMENT
	)
	ollama_llms_stablelm2? (
		STABILITY-AI-NON-COMMERCIAL-RESEARCH-COMMUNITY-LICENSE-AGREEMENT
	)
	ollama_llms_starcoder? (
		BigCode-Open-RAIL-M-v1-License-Agreement
	)
	ollama_llms_starcoder2? (
		BigCode-Open-RAIL-M-v1-License-Agreement
	)
	ollama_llms_starling-lm? (
		Apache-2.0
	)
	ollama_llms_themanofrod-travel-agent? (
		Gemma-Terms-of-Use-20240221
	)
	ollama_llms_tinydolphin? (
		Apache-2.0
	)
	ollama_llms_tinyllama? (
		Apache-2.0
	)
	ollama_llms_tulu3? (
		llama3_1-LICENSE
		llama3_1-USE_POLICY.md
	)
	ollama_llms_vicuna? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_yarn-llama2? (
		all-rights-reserved
	)
	ollama_llms_yarn-mistral? (
		Apache-2.0
	)
	ollama_llms_wizard-math? (
		MICROSOFT-RESEARCH-LICENSE-TERMS
	)
	ollama_llms_wizard-vicuna? (
		all-rights-reserved
	)
	ollama_llms_wizard-vicuna-uncensored? (
		all-rights-reserved
	)
	ollama_llms_wizardcoder? (
		MICROSOFT-RESEARCH-LICENSE-TERMS
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_wizardlm? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_wizardlm-uncensored? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_wizardlm2? (
		Apache-2.0
	)
	ollama_llms_xwinlm? (
		llama2-LICENSE
		llama2-USE_POLICY.md
	)
	ollama_llms_yi? (
		Apache-2.0
	)
	ollama_llms_yi-coder? (
		Apache-2.0
	)
	ollama_llms_zephyr? (
		MIT
	)
"
# Apache-2.0 - solar
# Apache-2.0 - mistral
# Apache-2.0 - neural-chat
# Apache-2.0 - qwen2
# Apache-2.0 - qwen2.5
# Apache-2.0 - nomic-embed-text
# Apache-2.0 - mxbai-embed-large
# Apache-2.0 - mixtral
# Apache-2.0 - starling-lm
# Apache-2.0 - llava
# Apache-2.0 - moondream
# CC-BY-NC-4.0 - solar:instruct
# Gemma-Terms-of-Use-20240221 Gemma-Prohibited-Use-Policy-20240221 - gemma
# Gemma-Terms-of-Use-20240221 Gemma-Prohibited-Use-Policy-20240221 - gemma2
# llama2-LICENSE llama2-USE_POLICY.md - llama2
# llama2-LICENSE llama2-USE_POLICY.md - llama2-uncensored
# llama3-LICENSE llama3-USE_POLICY.md - llama3 - chat, trivia
# llama3_1-LICENSE llama3_1-USE_POLICY.md - llama3.1
# llama3_2-LICENSE llama3_2-USE_POLICY.md - llama3.2
# llama2-LICENSE codellama-USE_POLICY.md - codellama
# MIT - phi3
# MIT - phi3:medium
# Tongyi-Qianwen-LICENSE-AGREEMENT - qwen:72b, qwen-14b, qwen-7b
# Tongyi-Qianwen-RESEARCH-LICENSE-AGREEMENT - qwen:1.8b
LICENSE="
	${LLM_LICENSES}
	(
		Apache-2.0
		BSD
		BSD-2
		MIT
		UoI-NCSA
	)
	(
		BSD-2
		ISC
	)
	Apache-2.0
	BSD
	GO-PATENTS
	MIT
	Boost-1.0
	W3C-Test-Suite-Licence
"
# Apache-2.0 BSD BSD-2 MIT UoI-NCSA - go-mod/github.com/apache/arrow/NOTICE.txt
# Apache-2.0 - go-mod/golang.org/x/exp/shiny/materialdesign/icons/LICENSE
# BSD - go-mod/go4.org/unsafe/assume-no-moving-gc/LICENSE
# MIT - go-mod/gorgonia.org/vecf64/LICENSE
# Boost-1.0 - go-mod/github.com/bytedance/sonic/licenses/LICENSE-Drachennest
# BSD-2 - go-mod/github.com/nlpodyssey/gopickle/LICENSE
# BSD-2 ISC - go-mod/github.com/emirpasic/gods/LICENSE
# GO-PATENTS - go-mod/golang.org/x/arch/PATENTS
# W3C Test Suite License, W3C 3-clause BSD License - go-mod/gonum.org/v1/gonum/graph/formats/rdf/testdata/LICENSE.md

SLOT="0"

IUSE+="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLMS[@]/#/ollama_llms_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_IUSE[@]}
blis chroot cuda debug emoji flash lapack mkl openblas openrc rocm
sandbox systemd unrestrict video_cards_intel
ebuild_revision_73
"
gen_rocm_required_use() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}? (
				rocm
			)
		"
	done
}
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
# OpenCL support (via CLBlast) removed in >= 0.1.45 in favor of vulkan which is not supported yet.
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	?? (
		${ROCM_IUSE[@]}
	)
	?? (
		cuda
		rocm
		video_cards_intel
	)
	?? (
		blis
		lapack
		mkl
		openblas
	)
	!rocm? (
		|| (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	chroot? (
		openrc
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_sse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512vl
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	flash? (
		|| (
			cuda
		)
		cuda? (
			|| (
				${CUDA_FATTN_TARGETS_COMPAT[@]/#/cuda_targets_}
			)
		)
	)
	rocm? (
		|| (
			${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
		^^ (
			${ROCM_IUSE[@]}
		)
	)
	sandbox? (
		openrc
	)
	video_cards_intel? (
		openrc
	)
	|| (
		${LLMS[@]/#/ollama_llms_}
	)
"
RDEPEND="
	acct-group/ollama
	acct-user/ollama
	emoji? (
		>=media-libs/fontconfig-2.15.0
		>=media-libs/freetype-2.13.2[png]
		>=x11-libs/cairo-1.16.0
		|| (
			media-fonts/noto-color-emoji
			media-fonts/noto-color-emoji-bin
			media-fonts/noto-emoji
			media-fonts/twemoji
		)
	)
	openrc? (
		sys-apps/openrc[bash]
		|| (
			app-admin/sysklogd
			sys-apps/util-linux[logger]
		)
	)
"
IDEPEND="
	${RDEPEND}
"
# The CUDA 11 requirement is relaxed.  Upstream tests with 11.3, 12.4.
CUDA_11_8_BDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-11.8*
		=sys-devel/gcc-11*[cxx]
	)
"
CUDA_12_4_BDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.4*
		=sys-devel/gcc-13*[cxx]
	)
"
gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo  "
		llvm_slot_${s}? (
			llvm-core/clang:${s}
			llvm-core/llvm:${s}
		)
		"
	done
}
gen_rocm_bdepend() {
	# DEPENDs listed in llama/llama.go
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s1="${s/./_}"
		local gcc_slot="HIP_${s1}_GCC_SLOT"
		echo "
			rocm_${s/./_}? (
				~dev-util/hip-${ROCM_VERSIONS[${s1}]}:${s}[lc,rocm]
				~sys-devel/llvm-roc-${ROCM_VERSIONS[${s1}]}:${s}[llvm_targets_AMDGPU,llvm_targets_X86]
			)
		"
	done
}
gen_rocm_rdepend() {
	# DEPENDs listed in llama/llama.go
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s1="${s/./_}"
		local gcc_slot="HIP_${s1}_GCC_SLOT"
		echo "
			rocm_${s/./_}? (
				~dev-libs/rocm-comgr-${ROCM_VERSIONS[${s1}]}:${s}
				~dev-libs/rocm-opencl-runtime-${ROCM_VERSIONS[${s1}]}:${s}
				~dev-libs/rocr-runtime-${ROCM_VERSIONS[${s1}]}:${s}
				~dev-util/hip-${ROCM_VERSIONS[${s1}]}:${s}[lc,rocm]
				~sci-libs/hipBLAS-${ROCM_VERSIONS[${s1}]}:${s}[rocm]
				~sci-libs/rocBLAS-${ROCM_VERSIONS[${s1}]}:${s}$(get_rocm_usedep ROCBLAS)
				~sci-libs/rocBLAS-${ROCM_VERSIONS[${s1}]}:${s}[cpu_flags_x86_f16c=]
				~sci-libs/rocSPARSE-${ROCM_VERSIONS[${s1}]}:${s}$(get_rocm_usedep ROCSPARSE)
				~sci-libs/rocSOLVER-${ROCM_VERSIONS[${s1}]}:${s}$(get_rocm_usedep ROCSOLVER)
				~sys-devel/llvm-roc-${ROCM_VERSIONS[${s1}]}:${s}[llvm_targets_AMDGPU,llvm_targets_X86]
			)
		"
	done
}
# Missing mkl_sycl_blas in =dev-libs/intel-compute-runtime-2023*
RDEPEND="
	blis? (
		sci-libs/blis:=
	)
	lapack? (
		sci-libs/lapack:=
	)
	mkl? (
		sci-libs/mkl:=
	)
	openblas? (
		sci-libs/openblas:=
	)
	rocm? (
		$(gen_rocm_rdepend)
		sci-libs/rocBLAS:=
		x11-libs/libdrm[video_cards_amdgpu]
	)
	sandbox? (
		sys-apps/sandbox
	)
	video_cards_intel? (
		>=dev-libs/intel-compute-runtime-2024[l0]
		dev-libs/intel-compute-runtime:=
		sci-libs/mkl:=
		sys-devel/DPC++:=
	)
"
DEPEND="
	${RDEPEND}
"
gen_rocm_bdepend() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s1="${s/./_}"
		local gcc_slot="HIP_${s1}_GCC_SLOT"
		echo "
			rocm_${s/./_}? (
				=sys-devel/gcc-${!gcc_slot}*
			)
		"
	done
}
BDEPEND="
	$(gen_clang_bdepend)
	$(gen_rocm_bdepend)
	(
		>=dev-go/protobuf-go-1.34.2
		dev-go/protobuf-go:=
	)
	(
		>=dev-go/protoc-gen-go-grpc-1.5.1
		dev-go/protoc-gen-go-grpc:=
	)
	>=dev-build/cmake-3.24
	>=dev-lang/go-1.23.4
	>=sys-devel/gcc-11.4.0
	app-arch/pigz
	app-shells/bash
	dev-build/make
	dev-util/patchelf
	dev-vcs/git
	virtual/pkgconfig
	|| (
		<dev-util/ragel-7.0.0.10
		>=dev-util/ragel-7.0.1
	)
	cuda? (
		cuda_targets_sm_50? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_52? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_60? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_61? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_70? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_75? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_80? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_86? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_89? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_90? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_90? (
			|| (
				${CUDA_11_8_BDEPEND}
				${CUDA_12_4_BDEPEND}
			)
		)
		cuda_targets_sm_90a? (
			|| (
				${CUDA_12_4_BDEPEND}
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		$(gen_rocm_bdepend)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.4.2-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-0.3.13-rename-CUDA_ARCHITECTURES.patch"
	"${FILESDIR}/${PN}-0.4.2-fix-os-arch-pair.patch"
	"${FILESDIR}/${PN}-0.4.2-gpu-libs-path.patch"
	"${FILESDIR}/${PN}-0.4.6-cmd-changes.patch"
	"${FILESDIR}/${PN}-0.4.7-nvcc-flags.patch"
)

pkg_pretend() {
	if use video_cards_intel ; then
ewarn "USE=video_cards_intel support for ${PN} is experimental."
	fi
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

check_libstdcxx() {
	local slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${slot}" ; then
eerror
eerror "You must switch to GCC ${slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

pkg_setup() {
	check-compiler-switch_start
ewarn "If the prebuilt LLM is marked all-rights-reserved, it is a placeholder and the actual license is still trying to be resolved.  See the LLM project for the actual license."
	local llvm_base_path
	if use rocm ; then
		if use rocm_6_1 ; then
			export ROCM_SLOT="6.1"
			export LLVM_SLOT=17
			export ROCM_VERSION="${HIP_6_1_VERSION}"
		elif use rocm_6_0 ; then
			export ROCM_SLOT="6.0"
			export LLVM_SLOT=17
			export ROCM_VERSION="${HIP_6_0_VERSION}"
		fi
		rocm_pkg_setup
	else
		local llvm_slot
		if use llvm_slot_17 ; then
			llvm_slot=17
		fi
		llvm_base_path="/usr/lib/llvm/${llvm_slot}"
einfo "PATH (before):  ${PATH}"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}${llvm_base_path}/bin|g")
einfo "PATH (after):  ${PATH}"
	fi
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
		git-r3_src_unpack
		go-module_live_vendor
	else
		unpack \
			"${P}.tar.gz"

	# Generating requires 2 phases for dependency of dependency
		if [[ "${GEN_EBUILD}" == "1" ]] ; then
	# Phase 1, direct deps
			gen_unpack
		elif [[ "${GEN_EBUILD}" == "2" ]] ; then
	# Phase 2, dep of dep [of dep ...]
			go-module_src_unpack
			gen_unpack
		else
			go-module_src_unpack
		fi

		cd "${S}" || die
		gen_git_tag "${S}" "v${PV}"
	fi
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	echo "${olast}"
}

src_prepare() {
	default
	# S_GO should appear at this point
	[[ -e "${WORKDIR}/go-mod" ]] || die "Retry, but upgrade dev-lang/go first."
	sed -i -e "s|// import \"gorgonia.org/tensor\"||g" "${S_GO}/github.com/pdevine/tensor@"*"/tensor.go" || die
	sed -i -e "s|// import \"gorgonia.org/tensor/internal/storage\"||g" "${S_GO}/github.com/pdevine/tensor@"*"/internal/storage/header.go" || die
	sed -i -e "s|// import \"gorgonia.org/tensor/internal/execution\"||g" "${S_GO}/github.com/pdevine/tensor@"*"/internal/execution/e.go" || die
	if use rocm ; then
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
		PATCH_PATHS=(
			"${S}/cmd/cmd.go"
			"${S}/discover/amd_linux.go"
			"${S}/discover/gpu_linux.go"
			"${S}/gpu/amd_linux.go"
			"${S}/gpu/gpu_linux.go"
			"${S}/llama/Makefile"
			"${S}/llama/llama.go"
			"${S}/llama/make/Makefile.cuda_v11"
			"${S}/llama/make/Makefile.cuda_v12"
			"${S}/llama/make/Makefile.rocm"
			"${S}/llama/make/common-defs.make"
			"${S}/llama/make/cuda.make"
			"${S}/llama/sync.sh"
			"${S}/llm/generate/gen_common.sh"
			"${S}/llm/generate/gen_linux.sh"
			"${S}/llm/llama.cpp/Makefile"
			"${S}/llm/llama.cpp/ggml/src/CMakeLists.txt"
			"${S}/scripts/install.sh"
		)

		rocm_src_prepare
	fi

	if has_version ">=dev-util/ragel-7.0.1" ; then
		local L=(
			$(grep -l -r "ragel -Z" "${WORKDIR}/go-mod")
		)
		local x
		for x in ${L[@]} ; do
einfo "Editing ${x} for ragel -Z -> ragel-go"
			sed -i -e "s|ragel -Z|ragel-go|g" "${x}" || die
		done
		sed -i \
			-e "s|\(RAGEL\) -Z|(RAGEL) |g" \
			-e "s|RAGEL := ragel|RAGEL := ragel-go|g" \
			"${WORKDIR}/go-mod/github.com/leodido/go-urn@"*"/makefile" \
			|| die
		sed -i \
			-e "s|\"ragel\"|\"ragel-go\"|g" \
			"${WORKDIR}/go-mod/github.com/dgryski/trifles@"*"/matcher/main.go" \
			|| die
	fi

	if [[ "${CFLAGS}" =~ "-march=armv8.6-a" ]] ; then
		sed -i \
			-e "s|armv8.6-a||g" \
			"llama/llama.go" \
			|| die
	fi

	if ! use cpu_flags_x86_f16c ; then
		sed -i \
			-e "s|-mf16c||g" \
			"llama/make/Makefile.rocm" \
			|| die
	fi

	if ! use cpu_flags_x86_fma ; then
		sed -i \
			-e "s|-mfma||g" \
			"llama/make/Makefile.rocm" \
			|| die
	fi

	if ! use cpu_flags_x86_avx ; then
		if use amd64 || use x86 ; then
			export GPU_RUNNER_CPU_FLAGS="no-avx"
		fi
		sed -i \
			-e "s|-mfma||g" \
			"llama/make/Makefile.rocm" \
			|| die
	fi

	# Allow to use GPU without AVX.
	sed -i \
		-e "s|GPURunnerCPUCapability = CPUCapabilityAVX|GPURunnerCPUCapability = CPUCapabilityNone|" \
		"discover/types.go" \
		|| die
}

check_toolchain() {
	# The project doesn't check it so it creates strange error messages and
	# an undocumented list of required tools.
einfo "Checking toolchain"
	# Still check if *DEPEND is bypassed via `emerge -O` or `ebuild`
	clang --version || die
	protoc --version || die
	protoc-gen-go-grpc --version || die
	pigz --version || die
	git --version || die
	pkg-config --version || die
	if has_version ">=dev-util/ragel-7.0.1" ; then
		ragel-go --version || die
	else
		ragel --version || die
		ragel_pv=$(ragel --version | head -n 1 | cut -f 6 -d " ")
		if ver_test ${ragel_pv} -lt "7.0.0.10" ; then
			:
		else
eerror
eerror "Detected an old version of ragel."
eerror
eerror "Actual:  ${ragel_pv}"
eerror "Required:"
eerror
eerror "One of the following"
eerror
eerror "  <dev-util/ragel-7.0.0.10"
eerror "  >=dev-util/ragel-7.0.1"
eerror
eerror "Do the following:"
eerror
eerror "emaint sync -A"
eerror "emerge dev-util/ragel"
eerror
			die
		fi
	fi
}

get_cuda_flags() {
	local arches=""
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use "cuda_targets_${x}" ; then
			arches+=";${x#*_}"
		fi
	done
	arches="${arches:1}"
	echo "${arches}"
}

_NVCC_FLAGS=""
src_configure() {
	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		export CPP="${CC} -E"
		export CUDA_SLOT=12
		export CMAKE_CUDA_ARCHITECTURES="$(get_cuda_flags)"
		check_libstdcxx "13"
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		export CUDA_SLOT=11
		export CMAKE_CUDA_ARCHITECTURES="$(get_cuda_flags)"
		check_libstdcxx "11"
	elif use rocm ; then
		local _gcc_slot="HIP_${ROCM_SLOT/./_}_GCC_SLOT"
		local gcc_slot="${!_gcc_slot}"
		export CC="${CHOST}-gcc-${gcc_slot}"
		export CXX="${CHOST}-g++-${gcc_slot}"
		export CPP="${CC} -E"
		export AMDGPU_TARGETS="$(get_amdgpu_flags)"
		check_libstdcxx "${gcc_slot}"
		local libs=(
			"amd_comgr:dev-libs/rocm-comgr"
			"amdhip64:dev-util/hip"
			"amdocl64:dev-libs/rocm-opencl-runtime"
			"hipblas:sci-libs/hipBLAS"
			"hsa-runtime64:dev-libs/rocr-runtime"
			"rocblas:sci-libs/rocBLAS"
			"rocsparse:sci-libs/rocSPARSE"
			"rocsolver:sci-libs/rocSOLVER"
		)
		local glibcxx_ver="HIP_${ROCM_SLOT/./_}_GLIBCXX"
	# Avoid missing versioned symbols
	# # ld: /opt/rocm-6.1.2/lib/librocblas.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
		rocm_verify_glibcxx "${!glibcxx_ver}" ${libs[@]}

		# Speed up build
		local gpus="${AMDGPU_TARGETS}"
		sed -i -e "s|HIP_ARCHS_COMMON := gfx900 gfx940 gfx941 gfx942 gfx1010 gfx1012 gfx1030 gfx1100 gfx1101 gfx1102|HIP_ARCHS_COMMON := ${gpus//;/ }|g" \
			"llama/make/Makefile.rocm" \
			|| die
		sed -i -e "s|HIP_ARCHS_LINUX := gfx906:xnack- gfx908:xnack- gfx90a:xnack+ gfx90a:xnack-|HIP_ARCHS_LINUX := |g" \
			"llama/make/Makefile.rocm" \
			|| die
	fi

	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	if use debug ; then
	# Increase build verbosity
		append-flags -g
	fi

	if use rocm ; then
	# Fixes
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_queue_load_write_index_relaxed'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_executable_get_symbol_by_name'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_code_object_reader_destroy'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_amd_signal_value_pointer'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_iterate_agents'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `numa_node_to_cpus'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_amd_signal_create'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_signal_destroy'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_amd_svm_attributes_set'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_init'
# ld: /opt/rocm-6.1.2/lib/libamdhip64.so: undefined reference to `hsa_status_string'
		filter-flags "-Wl,--as-needed"
	fi

	# Fixes --version needed by loz
	export VERSION="${PV}"

	# For sgemm.cpp, ggml.c
	if use cpu_flags_x86_sse ; then
		append-flags -msse
		_NVCC_FLAGS+=" -Xcompiler -msse"
	fi

	if use cpu_flags_x86_sse2 ; then
		append-flags -msse2
		_NVCC_FLAGS+=" -Xcompiler -msse2"
	fi

	if use cpu_flags_x86_sse3 ; then
		append-flags -msse3
		_NVCC_FLAGS+=" -Xcompiler -msse3"
	fi

	if use cpu_flags_x86_ssse3 ; then
		append-flags -mssse3
		_NVCC_FLAGS+=" -Xcompiler -mssse3"
	fi

	if use cpu_flags_x86_f16c ; then
		append-flags -mf16c
		_NVCC_FLAGS+=" -Xcompiler -mf16c"
	fi

	if use cpu_flags_x86_fma ; then
		append-flags -mfma
		_NVCC_FLAGS+=" -Xcompiler -mfma"
	fi

	if use cpu_flags_x86_avxvnni ; then
		append-flags -mavxvnni
		_NVCC_FLAGS+=" -Xcompiler -mavxvnni"
	fi

	if use cpu_flags_x86_avxvnniint8 ; then
		append-flags -mavxvnniint8
		_NVCC_FLAGS+=" -Xcompiler -mavxvnniint8"
	fi

	if use cpu_flags_x86_avx512f ; then
		append-flags -mavx512f
		_NVCC_FLAGS+=" -Xcompiler -mavx512f"
	fi

	if use cpu_flags_x86_avx512dq ; then
		append-flags -mavx512dq
		_NVCC_FLAGS+=" -Xcompiler -mavx512dq"
	fi

	if use cpu_flags_x86_avx512vl ; then
		append-flags -mavx512vl
		_NVCC_FLAGS+=" -Xcompiler -mavx512vl"
	fi

	if use cpu_flags_x86_avx512bf16 ; then
		append-flags -mavx512bf16
		_NVCC_FLAGS+=" -Xcompiler -mavx512bf16"
	fi

	if use cpu_flags_x86_avx512vbmi ; then
		append-flags -mavx512vbmi
		_NVCC_FLAGS+=" -Xcompiler -mavx512vbmi"
	fi

	if use cpu_flags_x86_avx512vnni ; then
		append-flags -mavx512vnni
		_NVCC_FLAGS+=" -Xcompiler -mavx512vnni"
	fi

	local arm_ext=""
	if use cpu_flags_arm_i8mm ; then
		local found=0
		for a in ${I8MM_ARCHES[@]} ; do
			if [[ "${CFLAGS}" =~ "-march=${a}" ]] ; then
				arm_ext+="+i8mm"
				found=1
				break
			fi
		done
		if (( ${found} == 1 )) ; then
eerror "You need to set -march= to one of ${I8MM_ARCHES[@]}"
			die
		fi
	fi

	if use cpu_flags_arm_sve ; then
		local found=0
		for a in ${SVE_ARCHES[@]} ; do
			if [[ "${CFLAGS}" =~ "-march=${a}" ]] ; then
				arm_ext+="+sve"
				found=1
				break
			fi
		done
		if (( ${found} == 1 )) ; then
eerror "You need to set -march= to one of ${SVE_ARCHES[@]}"
			die
		fi
	fi

	if [[ -n "${arm_ext}" ]] && ( use cpu_flags_arm_i8mm || use cpu_flags_arm_sve ) ; then
		for a in ${I8MM_ARCHES[@]} ; do
			if [[ "${CFLAGS}" =~ "-march=${a}" ]] ; then
				sed -i \
					-e "s|armv8.6-a+sve|${a}${arm_ext}|g" \
					"llama/llama.go" \
					|| die
				replace-flags "-march=${a}*" "-march=${a}${arm_ext}"
				break
			fi
		done
	fi

	# -Ofast breaks nvcc
	# -D_FORTIFY_SOURCE needs -O1 or higher
	replace-flags '-Ofast' '-O2'
	replace-flags '-O4' '-O2'
	replace-flags '-O3' '-O2'
	replace-flags '-Os' '-O2'
	replace-flags '-Oz' '-O2'
	replace-flags '-O0' '-O1'

	local olast=$(get_olast)

	replace-flags "-O*" "${olast}"

	# For -Ofast, -ffast-math
	if tc-is-gcc && ! use cuda ; then
		append-flags -fno-finite-math-only
	fi

	sed -i \
		-e "s|-Ofast|${olast}|g" \
		-e "s|-O2|${olast}|g" \
		-e "s|-O3|${olast}|g" \
		"llama/llama.go" \
		"llama/make/cuda.make" \
		"llama/make/Makefile.rocm" \
		|| die

	_NVCC_FLAGS+=" -Xcompiler ${olast}"

	if use cuda ; then
		filter-flags -fno-finite-math-only
		export NVCC_FLAGS="${_NVCC_FLAGS}"
	else
		export NVCC_FLAGS=""
	fi

	# Allow custom -Oflag
	export CMAKE_BUILD_TYPE=" "

	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
einfo "CFLAGS: ${CFLAGS}"
einfo "CXXFLAGS: ${CXXFLAGS}"
einfo "CPPLAGS: ${CPPFLAGS}"
einfo "LDFLAGS: ${LDFLAGS}"

	if use unrestrict ; then
		sed -i -e "s|@UNRESTRICT@|1|g" "cmd/cmd.go" || die
	else
		sed -i -e "s|@UNRESTRICT@|0|g" "cmd/cmd.go" || die
	fi

	declare -A use_alias=(
		["adens-quran-guide"]="adens/quran-guide"
		["agcobra-liberated-qwen1.5-72b"]="agcobra/liberated-qwen1.5-72b"
		["akx-viking-7b"]="akx/viking-7b"
		["ALIENTELLIGENCE-christiancounselor"]="ALIENTELLIGENCE/christiancounselor"
		["ALIENTELLIGENCE-crisisintervention"]="ALIENTELLIGENCE/crisisintervention"
		["ALIENTELLIGENCE-doomsdayurvivalist"]="ALIENTELLIGENCE/doomsdayurvivalist"
		["ALIENTELLIGENCE-enriquecastillorincon"]="ALIENTELLIGENCE/enriquecastillorincon"
		["ALIENTELLIGENCE-gamemasterroleplaying"]="ALIENTELLIGENCE/gamemasterroleplaying"
		["ALIENTELLIGENCE-holybible"]="ALIENTELLIGENCE/holybible"
		["ALIENTELLIGENCE-mentalwellness"]="ALIENTELLIGENCE/mentalwellness"
		["ALIENTELLIGENCE-pcarchitect"]="ALIENTELLIGENCE/pcarchitect"
		["ALIENTELLIGENCE-prayerline"]="ALIENTELLIGENCE/prayerline"
		["ALIENTELLIGENCE-sarah"]="ALIENTELLIGENCE/sarah"
		["ALIENTELLIGENCE-sarahv2"]="ALIENTELLIGENCE/sarahv2"
		["ALIENTELLIGENCE-whiterabbit"]="ALIENTELLIGENCE/whiterabbit"
		["ALIENTELLIGENCE-whiterabbitv2"]="ALIENTELLIGENCE/whiterabbitv2"
		["Artalius-lixi"]="Artalius/lixi"
		["artifish-mlewd-v2.4"]="artifish/mlewd-v2.4"
		["benevolentjoker-belial"]="benevolentjoker/belial"
		["benevolentjoker-bethanygpt"]="benevolentjoker/bethanygpt"
		["benevolentjoker-nsfwmonika"]="benevolentjoker/nsfwmonika"
		["benevolentjoker-nsfwvanessa"]="benevolentjoker/nsfwvanessa"
		["benevolentjoker-satan"]="benevolentjoker/satan"
		["canadiangamer-neena"]="canadiangamer/neena"
		["canadiangamer-priya"]="canadiangamer/priya"
		["captainkyd-whiterabbitneo7b"]="captainkyd/whiterabbitneo7b"
		["chatgph-70b-instruct"]="chatgph/70b-instruct"
		["chatgph-gph-main"]="chatgph/gph-main"
		["chatgph-medix-ph"]="chatgph/medix-ph"
		["disinfozone-telos"]="disinfozone/telos"
		["ehartford-theprofessor"]="ehartford/theprofessor"
		["eramax-aura_v3"]="eramax/aura_v3"
		["fixt-home-3b-v3"]="fixt/home-3b-v3"
		["fixt-home-3b-v2"]="fixt/home-3b-v2"
		["hemanth-chessplayer"]="hemanth/chessplayer"
		["hookingai-monah-8b"]="hookingai/monah-8b"
		["jimscard-adult-film-screenwriter-nsfw"]="jimscard/adult-film-screenwriter-nsfw"
		["jimscard-whiterabbit-neo"]="jimscard/whiterabbit-neo"
		["joefamous-grok-1"]="joefamous/grok-1"
		["leeplenty-lumimaid-v0.2"]="leeplenty/lumimaid-v0.2"
		["mannix-llamax3-8b-alpaca"]="mannix/llamax3-8b-alpaca"
		["mannix-replete-adapted-llama3-8b"]="mannix/replete-adapted-llama3-8b"
		["mannix-replete-coder-llama3-8b"]="mannix/replete-coder-llama3-8b"
		["monotykamary-whiterabbitneo-v1.5a"]="monotykamary/whiterabbitneo-v1.5a"
		["nqduc-gemsura"]="nqduc/gemsura"
		["nqduc-mixsura"]="nqduc/mixsura"
		["nqduc-mixsura-sft"]="nqduc/mixsura-sft"
		["partai-dorna-llama3"]="partai/dorna-llama3"
		["reefer-her2"]="reefer/her2"
		["reefer-minimonica"]="reefer/minimonica"
		["reefer-monica"]="reefer/monica"
		["rfc-whiterabbitneo"]="rfc/whiterabbitneo"
		["rouge-replete-coder-qwen2-1.5b"]="rouge/replete-coder-qwen2-1.5b"
		["savethedoctor-whiterabbitneo13bq8_0"]="savethedoctor/whiterabbitneo13bq8_0"
		["sparksammy-samantha"]="sparksammy/samantha"
		["sparksammy-samantha-3.1"]="sparksammy/samantha-3.1"
		["sparksammy-samantha-eggplant"]="sparksammy/samantha-eggplant"
		["sparksammy-samantha-v3-uncensored"]="sparksammy/samantha-v3-uncensored"
		["sparksammy-tinysam-goog"]="sparksammy/tinysam-goog"
		["sparksammy-tinysam-msft"]="sparksammy/tinysam-msft"
		["themanofrod-travel-agent"]="themanofrod/travel-agent"
	)

	# Toggle LLM in whitelist to filter out LLM support by license.
	local n
	for n in ${LLMS[@]} ; do
		local key="${use_alias[${n}]}"
		if [[ -n "${key}" ]] ; then
			if use "ollama_llms_${n}" ; then
				sed -i -e "s|\"${key}\": 1|\"${key}\": 1|g" "cmd/cmd.go" || die
			else
				sed -i -e "s|\"${key}\": 1|\"${key}\": 0|g" "cmd/cmd.go" || die
			fi
		elif use "ollama_llms_${n}" ; then
			sed -i -e "s|\"${n}\": 1|\"${n}\": 1|g" "cmd/cmd.go" || die
		else
			sed -i -e "s|\"${n}\": 1|\"${n}\": 0|g" "cmd/cmd.go" || die
		fi
	done


	# MAKEOPTS breaks ROCm build during cp -af
	# make[1]: *** [make/gpu.make:102: <REDACTED>] Error 1
	local jobs
	if use rocm || use cuda ; then
		export MAKEOPTS="-j1"
		jobs=1
	else
		# CPU only
		jobs=$(get_makeopts_jobs)
	fi
	sed -i -e "s|make -j 8|make -j ${jobs}|g" "llama/llama.go" || die

	if ! use cuda ; then
		export OLLAMA_SKIP_CUDA_GENERATE=1
	else
		[[ "${ARCH}" == "amd64" && "${ABI}" == "amd64" ]] || die "ARCH=${ARCH} ABI=${ABI} not supported for USE=cuda"
		filter-flags -pipe # breaks NVCC
	fi

	if ! use rocm ; then
		export OLLAMA_SKIP_ROCM_GENERATE=1
	else
		[[ "${ARCH}" == "amd64" && "${ABI}" == "amd64" ]] || die "ARCH=${ARCH} ABI=${ABI} not supported for USE=rocm"
	fi

	if ! use video_cards_intel ; then
		export OLLAMA_SKIP_ONEAPI_GENERATE=1
	else
		[[ "${ARCH}" == "amd64" && "${ABI}" == "amd64" ]] || die "ARCH=${ARCH} ABI=${ABI} not supported for USE=video_cards_intel"
	fi

	if use flash ; then
		export OLLAMA_FAST_BUILD=1
	fi

	local gpu_args=()

	if use cpu_flags_x86_sse ; then
		gpu_args+=( sse )
	fi

	if use cpu_flags_x86_sse2 ; then
		gpu_args+=( sse2 )
	fi

	if use cpu_flags_x86_sse3 ; then
		gpu_args+=( sse3 )
	fi

	if use cpu_flags_x86_ssse3 ; then
		gpu_args+=( ssse3 )
	fi

	if use cpu_flags_x86_avx ; then
		gpu_args+=( avx )
	fi

	if use cpu_flags_x86_avx2 ; then
		gpu_args+=( avx2 )
	fi

	if use cpu_flags_x86_avxvnni ; then
		gpu_args+=( avxvnni )
	fi

	if use cpu_flags_x86_avxvnniint8 ; then
		gpu_args+=( avxvnniint8 )
	fi

	if use cpu_flags_x86_avx512f ; then
		gpu_args+=( avx512f )
	fi

	if use cpu_flags_x86_fma ; then
		gpu_args+=( fma )
	fi

	if use cpu_flags_x86_f16c ; then
		gpu_args+=( f16c )
	fi

	if use cpu_flags_x86_avx512vbmi ; then
		gpu_args+=( avx512vbmi )
	fi

	if use cpu_flags_x86_avx512vnni ; then
		gpu_args+=( avx512vnni )
	fi

	if use cpu_flags_x86_avx512bf16 ; then
		gpu_args+=( avx512bf16 )
	fi

	if [[ -n "${gpu_args[@]}" ]] ; then
		export GPU_RUNNER_CPU_FLAGS="${gpu_args[@]}"
	else
		export GPU_RUNNER_CPU_FLAGS="no-avx"
	fi

	check_toolchain

	if use blis ; then
		local cflags="-I/usr/include/blis"
		local libs="-lblis"
		sed -i \
			-e "s|linux CFLAGS: -D_GNU_SOURCE|linux CFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux CXXFLAGS: -D_GNU_SOURCE|linux CXXFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64 ${libs}|g" \
			-e "s|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64 ${libs}|g" \
			"llama/llama.go" \
			|| die
	elif use mkl ; then
		[[ "${ARCH}" == "amd64" && "${ABI}" == "amd64" ]] || die "ARCH=${ARCH} ABI=${ABI} not supported for USE=mkl"
		local mkl_pv=$(best_version "sci-libs/mkl" | sed -e "s|sci-libs/mkl-||g")
		mkl_pv=$(ver_cut 1-3 ${pv})
	# We force tbb to dedupe thread libs.  GPU acceleration already uses tbb unconditionally.
		local cflags=$(pkg-config --cflags mkl-dynamic-lp64-tbb)
		local libs=$(pkg-config --libs mkl-dynamic-lp64-tbb)
		sed -i \
			-e "s|linux CFLAGS: -D_GNU_SOURCE|linux CFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS -DGGML_BLAS_USE_MKL=1 ${cflags}|g" \
			-e "s|linux CXXFLAGS: -D_GNU_SOURCE|linux CXXFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS -DGGML_BLAS_USE_MKL=1 ${cflags}|g" \
			-e "s|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64 ${libs}|g" \
			"llama/llama.go" \
			|| die
		local path="/opt/intel/oneapi/mkl/${mkl_pv}/env/vars.sh"
		[[ -e "${path}" ]] || die
		source "${path}"
	elif use lapack ; then
		local cflags=$(pkg-config --cflags blas)
		local libs=$(pkg-config --libs blas)
		sed -i \
			-e "s|linux CFLAGS: -D_GNU_SOURCE|linux CFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux CXXFLAGS: -D_GNU_SOURCE|linux CXXFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64 ${libs}|g" \
			-e "s|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64 ${libs}|g" \
			"llama/llama.go" \
			|| die
	elif use openblas ; then
		local cflags=$(pkg-config --cflags openblas)
		local libs=$(pkg-config --libs openblas)
		sed -i \
			-e "s|linux CFLAGS: -D_GNU_SOURCE|linux CFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux CXXFLAGS: -D_GNU_SOURCE|linux CXXFLAGS: -D_GNU_SOURCE -DGGML_USE_BLAS ${cflags}|g" \
			-e "s|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64|linux,amd64 LDFLAGS: -L\${SRCDIR}/build/linux-amd64 ${libs}|g" \
			-e "s|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64|linux,arm64 LDFLAGS: -L\${SRCDIR}/build/linux-arm64 ${libs}|g" \
			"llama/llama.go" \
			|| die
	fi

	strip-unsupported-flags

	local max_retries=${OLLAMA_MAX_RETRIES:-6}
	sed -i -e "s|maxRetries = 6|maxRetries = ${max_retries}|g" "server/download.go" || die
einfo "OLLAMA_MAX_RETRIES:  ${max_retries}"

	local num_download_parts=${OLLAMA_NUM_DOWNLOAD_PARTS:-1}
	sed -i -e "s|numDownloadParts          = 16|numDownloadParts          = ${num_download_parts}|g" "server/download.go" || die
einfo "OLLAMA_NUM_DOWNLOAD_PARTS:  ${num_download_parts}"

	local min_download_part_size=${OLLAMA_MIN_DOWNLOAD_PART_SIZE:-1}
	sed -i -e "s|minDownloadPartSize int64 = 100|minDownloadPartSize int64 = ${min_download_part_size}|g" "server/download.go" || die
einfo "OLLAMA_MIN_DOWNLOAD_PART_SIZE:  ${min_download_part_size}"

	local max_download_part_size=${OLLAMA_MAX_DOWNLOAD_PART_SIZE:-2}
	sed -i -e "s|maxDownloadPartSize int64 = 1000|maxDownloadPartSize int64 = ${max_download_part_size}|g" "server/download.go" || die
einfo "OLLAMA_MAX_DOWNLOAD_PART_SIZE:  ${max_download_part_size}"
}

build_new_runner_cpu() {
	# The documentation is sloppy.

	export OLLAMA_SKIP_CUDA_GENERATE=1
	export OLLAMA_SKIP_ROCM_GENERATE=1
	export OLLAMA_SKIP_ONEAPI_GENERATE=1

	# See also
	# https://github.com/ollama/ollama/blob/v0.4.7/llama/llama.go
	local args=(
		-p $(get_makeopts_jobs)
		-x
		-v
	)

	local cpu_flags_args=""

	if use cpu_flags_x86_f16c ; then
		cpu_flag_args+="|-mf16c"
	fi

	if use cpu_flags_x86_fma ; then
		cpu_flag_args+="|-mfma"
	fi

	if use cpu_flags_x86_f16c || use cpu_flags_x86_fma ; then
		cpu_flag_args="${cpu_flag_args:1}"
		go env -w "CGO_CFLAGS_ALLOW=${cpu_flag_args}"
		go env -w "CGO_CXXFLAGS_ALLOW=${cpu_flags_args}"
		export CGO_CFLAGS_ALLOW=${cpu_flag_args}
		export CGO_CXXFLAGS_ALLOW=${cpu_flag_args}
	fi

	if use cpu_flags_arm_sve ; then
		args+=(
			-tags sve
		)
	elif use cpu_flags_x86_avx2 ; then
		args+=(
			-tags avx,avx2
		)
	elif use cpu_flags_x86_avx ; then
		args+=(
			-tags avx
		)
	fi

	if ! tc-enables-pie ; then
		args+=(
	# ASLR (buffer overflow mitigation)
			-buildmode=pie
		)
	fi

einfo "Building CPU runner"
	emake -C llama

	edo go build ${args[@]} .
}

build_new_runner_gpu() {
	# The documentation is sloppy.

	if use cuda || use rocm ; then
		:
	else
		return
	fi

	if use cuda ; then
		unset OLLAMA_SKIP_CUDA_GENERATE
	fi

	if use rocm ; then
		unset OLLAMA_SKIP_ROCM_GENERATE
	fi

	if use video_cards_intel ; then
		unset OLLAMA_SKIP_ONEAPI_GENERATE
	fi

	# See also
	# https://github.com/ollama/ollama/blob/v0.4.7/llama/llama.go
	local args=(
		-p $(get_makeopts_jobs)
		-x
		-v
	)

	local cpu_flags_args=""

	if use cpu_flags_x86_f16c ; then
		cpu_flag_args+="|-mf16c"
	fi

	if use cpu_flags_x86_fma ; then
		cpu_flag_args+="|-mfma"
	fi

	if use cpu_flags_x86_f16c || use cpu_flags_x86_fma ; then
		cpu_flag_args="${cpu_flag_args:1}"
		go env -w "CGO_CFLAGS_ALLOW=${cpu_flag_args}"
		go env -w "CGO_CXXFLAGS_ALLOW=${cpu_flags_args}"
		export CGO_CFLAGS_ALLOW=${cpu_flag_args}
		export CGO_CXXFLAGS_ALLOW=${cpu_flag_args}
	fi

	local cuda_impl=""
	if use cuda ; then
		if has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
			cuda_impl="cuda_v12"
		elif has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
			cuda_impl="cuda_v11"
		fi
	fi

	if use cpu_flags_x86_avx2 && use cuda ; then
		args+=(
			-tags avx,avx2,cuda,${cuda_impl}
		)
	elif use cpu_flags_x86_avx && use cuda ; then
		args+=(
			-tags avx,cuda,${cuda_impl}
		)
	elif use cuda ; then
		args+=(
			-tags cuda,${cuda_impl}
		)
	elif use cpu_flags_x86_avx2 && use rocm ; then
		args+=(
			-tags avx,avx2,rocm
		)
	elif use cpu_flags_x86_avx && use rocm ; then
		args+=(
			-tags avx,rocm
		)
	elif use rocm ; then
		args+=(
			-tags rocm
		)
	fi

	if ! tc-enables-pie ; then
		args+=(
	# ASLR (buffer overflow mitigation)
			-buildmode=pie
		)
	fi

	if use cuda ; then
		# Breaks nvcc
		filter-flags '-m*'

		export CGO_CFLAGS="${CFLAGS}"
		export CGO_CXXFLAGS="${CXXFLAGS}"
		export CGO_CPPFLAGS="${CPPFLAGS}"
		export CGO_LDFLAGS="${LDFLAGS}"
einfo "CFLAGS: ${CFLAGS}"
einfo "CXXFLAGS: ${CXXFLAGS}"
einfo "CPPLAGS: ${CPPFLAGS}"
einfo "LDFLAGS: ${LDFLAGS}"

		if has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
einfo "Building for CUDA v12"
			emake -C llama cuda_v12
		elif has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
einfo "Building for CUDA v11"
			emake -C llama cuda_v11
		fi
	elif use rocm ; then
einfo "Building for ROCm"
		emake -C llama rocm
	fi

	edo go build ${args[@]} .
}

src_compile() {
	if [[ "${PV}" =~ "9999" ]] ; then
		VERSION=$(
			git describe --tags --first-parent --abbrev=7 --long --dirty --always \
				| sed -e "s/^v//g"
			assert
		)
	fi
	export GOFLAGS="'-ldflags=-w -s \"-X=github.com/${PN}/${PN}/version.Version=${VERSION}\"'"

	if [[ "${PV}" =~ "9999" ]] ; then
		:
	else
		export GOPATH="${WORKDIR}/go-mod"
		export GO111MODULE=on
		pushd "${WORKDIR}/${P}" >/dev/null 2>&1 || die
			:
		popd >/dev/null 2>&1 || die
	fi
	build_new_runner_cpu
	build_new_runner_gpu
	if grep -q -e "warning: undefined reference" "${T}/build.log" ; then
ewarn "QA:  Verify linking with GPU libs"
	fi
	if grep -q -F -e "): undefined reference" "${T}/build.log" ; then
eerror "Detected error"
		die
	fi
}

get_arch() {
	if use amd64 ; then
		echo "amd64"
	elif use arm64 ; then
		echo "arm64"
	else
eerror "ARCH=${ARCH} ABI=${ABI} is not supported"
		die
	fi
}

install_cpu_runner() {
	local runner_path1
	local runner_path2="${S}/dist/linux-$(get_arch)/lib/ollama"

	local name
	if use cpu_flags_x86_avx2 ; then
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/cpu_avx2"
		name="cpu_avx2"
	elif use cpu_flags_x86_avx ; then
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/cpu_avx"
		name="cpu_avx"
	else
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/cpu"
		name="cpu"
	fi

	[[ -e "${runner_path1}" ]] || return

	exeinto "/usr/$(get_libdir)/${PN}/${name}"
	pushd "${runner_path1}" >/dev/null 2>&1 || die
		doexe "ollama_llama_server"
	popd >/dev/null 2>&1 || die
	patchelf \
		--add-rpath '$ORIGIN' \
		"${ED}/usr/$(get_libdir)/${PN}/${name}/ollama_llama_server" \
		|| die
}

install_gpu_runner() {
	local runner_path1
	local runner_path2="${S}/dist/linux-$(get_arch)/lib/ollama"

	local name=""
	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/cuda_v12"
		name="cuda_v12"
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/cuda_v11"
		name="cuda_v11"
	elif use rocm ; then
		runner_path1="${S}/dist/linux-$(get_arch)/lib/ollama/runners/rocm"
		name="rocm"
	fi

	[[ -z "${name}" ]] && return
	[[ -e "${runner_path1}" ]] || return

	exeinto "/usr/$(get_libdir)/${PN}/${name}"
	pushd "${runner_path1}" >/dev/null 2>&1 || die
		doexe "ollama_llama_server"
	popd >/dev/null 2>&1 || die

	pushd "${runner_path2}" >/dev/null 2>&1 || die
		if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
			doexe "libggml_cuda_v12.so"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
			doexe "libggml_cuda_v11.so"
		elif use rocm ; then
			doexe "libggml_rocm.so"
		fi
	popd >/dev/null 2>&1 || die

	local list=(
		"libggml_${name}.so"
		"ollama_llama_server"
	)
	local n
	if use cuda ; then
		for n in ${list[@]} ; do
			patchelf \
				--add-rpath '$ORIGIN' \
				"${ED}/usr/$(get_libdir)/${PN}/${name}/${n}" \
				|| die
			patchelf \
				--add-rpath "/opt/cuda/$(get_libdir)" \
				"${ED}/usr/$(get_libdir)/${PN}/${name}/${n}" \
				|| die
		done
	elif use rocm ; then
		for n in ${list[@]} ; do
			patchelf \
				--add-rpath '$ORIGIN' \
				"${ED}/usr/$(get_libdir)/${PN}/${name}/${n}" \
				|| die
			patchelf \
				--add-rpath "/opt/rocm-${ROCM_VERSION}/lib" \
				"${ED}/usr/$(get_libdir)/${PN}/${name}/${n}" \
				|| die
		done
	fi
}

src_install() {
	exeinto "/usr/$(get_libdir)/${PN}"
	doexe "${PN}"

	local ld_library_path=""
	if use cuda ; then
		local name=""
		if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
			name="cuda_v12"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
			name="cuda_v11"
		fi
		patchelf \
			--add-rpath "/opt/cuda/$(get_libdir)" \
			"${ED}/usr/$(get_libdir)/${PN}/${PN}" \
			|| die
		patchelf \
			--add-rpath "/usr/$(get_libdir)/${PN}/${name}" \
			"${ED}/usr/$(get_libdir)/${PN}/${PN}" \
			|| die
		ld_library_path+="/opt/cuda/$(get_libdir):/usr/$(get_libdir)"
	elif use rocm ; then
		local name="rocm"
		patchelf \
			--add-rpath "/opt/rocm-${ROCM_VERSION}/lib" \
			"${ED}/usr/$(get_libdir)/${PN}/${PN}" \
			|| die
		patchelf \
			--add-rpath "/usr/$(get_libdir)/${PN}/${name}" \
			"${ED}/usr/$(get_libdir)/${PN}/${PN}" \
			|| die
	elif use video_cards_intel ; then
		ld_library_path+="/usr/$(get_libdir)"
	fi

	cat "${FILESDIR}/${PN}-muxer" > "${T}/${PN}-muxer"

	# Prune generators
	sed -i \
		-e "/START IUSE_GENERATOR/,/END IUSE_GENERATOR/d" \
		-e "/START LICENSE_ARRAY_GENERATOR/,/END LICENSE_ARRAY_GENERATOR/d" \
		-e "/START USE_DESC_GENERATOR/,/END USE_DESC_GENERATOR/d" \
		"${T}/${PN}-muxer" \
		|| die

	# Set default backend for wrapper
	local backend=""
	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
		backend="cuda_v12"
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
		backend="cuda_v11"
	elif use rocm ; then
		backend="rocm"
	elif use cpu_flags_x86_avx2 ; then
		backend="cpu_avx2"
	elif use cpu_flags_x86_avx ; then
		backend="cpu_avx"
	else
		backend="cpu"
	fi

	sed -i -e "s|@OLLAMA_BACKEND@|${backend}|g" \
		"${T}/${PN}-muxer" \
		|| die

	exeinto "/usr/bin"
	newexe "${T}/${PN}-muxer" "${PN}"

	#
	# We build/install two backends for scenarios
	#
	# * Gaming with GPU with LLM search with CPU runner.
	# * Live streaming GPU encoding with LLM search with CPU runner.
	#
	install_cpu_runner
	install_gpu_runner

	local chroot=$(usex chroot "1" "0")
	local flash_attention=$(usex flash "1" "0")
	local sandbox=$(usex sandbox "sandbox" "")

	if use openrc ; then
		doinitd "${FILESDIR}/${PN}"
		if use rocm ; then
			sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" \
				"${ED}/etc/init.d/${PN}" \
				"${ED}/usr/bin/${PN}" \
				|| die
		fi
		sed -i \
			-e "/@OLLAMA_CONTEXT_LENGTH@/d" \
			-e "s|@OLLAMA_BACKEND@|${backend}|g" \
			-e "s|@OLLAMA_CHROOT@|${chroot}|g" \
			-e "s|@OLLAMA_FLASH_ATTENTION@|${flash_attention}|g" \
			-e "s|@OLLAMA_SANDBOX_PROVIDER@|${sandbox}|g" \
			-e "s|@LD_LIBRARY_PATH@|${ld_library_path}|g" \
			"${ED}/etc/init.d/${PN}" \
			|| die
		sed -i \
			-e "/OLLAMA_KV_CACHE_TYPE/d" \
			"${ED}/etc/init.d/${PN}" \
			|| die
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		doins "${FILESDIR}/${PN}.service"
		if use rocm ; then
			sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" \
				"${ED}/usr/bin/${PN}" \
				|| die
		fi
		sed -i \
			-e "/@OLLAMA_CONTEXT_LENGTH@/d" \
			-e "s|@OLLAMA_FLASH_ATTENTION@|${flash_attention}|g" \
			-e "s|@LD_LIBRARY_PATH@|${ld_library_path}|g" \
			"${ED}/usr/lib/systemd/system/${PN}.service" \
			|| die
		sed -i \
			-e "/OLLAMA_KV_CACHE_TYPE/d" \
			"${ED}/usr/lib/systemd/system/${PN}.service" \
			|| die
	fi

	sed -i \
		-e "s|@OLLAMA_BACKEND@|${backend}|g" \
		-e "s|@OLLAMA_MALLOC_PROVIDER@|${malloc}|g" \
		-e "s|@OLLAMA_SANDBOX_PROVIDER@|${sandbox}|g" \
		"${ED}/usr/bin/${PN}" \
		|| die

	LCNR_SOURCE="${WORKDIR}/go-mod"
	LCNR_TAG="third_party"
	lcnr_install_files

	LCNR_SOURCE="${S}"
	LCNR_TAG="ollama"
	lcnr_install_files
}

pkg_preinst() {
	keepdir "/var/log/${PN}"
	fowners "${PN}:${PN}" "/var/log/${PN}"
}

pkg_postinst() {
einfo
einfo "Quick guide:"
einfo
	if use openrc ; then
printf " \e[32m*\e[0m  %-40s%-40s\n" "rc-service ${PN} start"		"# Start server"
	elif use systemd ; then
printf " \e[32m*\e[0m  %-40s%-40s\n" "systemctl start ${PN}"		"# Start server"
	else
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} serve"			"# Start server, note you are reponsible for adding it to your init system."
	fi
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} avail"			"# Lists whitelisted models available to download"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} run llama3:70b"		"# Downloads, load, and chat to a llama3 Large Language Model (LLM) with 70 billion parameters"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} show llama3 --tags"		"# Shows descriptive tags, capabilities, personality of the llama3 model"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} show llama3 --website"	"# Shows the ${PN} website entry for the llama3 model"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} show llama3 --licence"	"# Shows the model license of the llama3 model"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} find-size 500MB"		"# Shows the models to download that are 500MB or less"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} find-size 4GB"		"# Shows the models to download that are 4GB or less"
printf " \e[32m*\e[0m  %-40s%-40s\n" "${PN} find-size 4GB | grep orca"	"# Shows orca models less than or equal to 4GB"
einfo
einfo "You still need to download a pregenerated model.  The full list can be"
einfo "found at:"
einfo
einfo "  https://ollama.com/library"
einfo
einfo "Tip:  Use LLM models that are 2 orders of magnitude lighter for optimal"
einfo "inference latency, optimal load latency, and minimal thrashing."
einfo
einfo "    O(100) MB RAM   =    O(1) MB model"
einfo "      O(1) GB RAM   =   O(10) MB model"
einfo "     O(10) GB RAM   =  O(100) MB model"
einfo "    O(100) GB RAM   =    O(1) GB model"
einfo "      O(1) TB RAM   =   O(10) GB model"
einfo
einfo "                   or"
einfo
einfo "         1 GB RAM       99 M or less parameters"
einfo "         4 GB RAM       99 M or less parameters"
einfo "         8 GB RAM       99 M or less parameters"
einfo "        16 GB RAM      999 M or less parameters"
einfo "        32 GB RAM      999 M or less parameters"
einfo "        64 GB RAM      999 M or less parameters"
einfo "       128 GB RAM        9 G or less parameters"
einfo "       256 GB RAM        9 G or less parameters"
einfo "       512 GB RAM        9 G or less parameters"
einfo "         1 TB RAM       99 G or less parameters"
einfo
einfo
einfo "Tip:  Use LLM models that are 1 order of magnitude lighter or N/4"
einfo "parameters for programs that have a particular model as a hard"
einfo "requirement and lack of availability of a smaller parameter choice."
einfo
einfo "    O(100) MB RAM   =   O(10) MB model"
einfo "      O(1) GB RAM   =  O(100) MB model"
einfo "     O(10) GB RAM   =    O(1) GB model"
einfo "    O(100) GB RAM   =   O(10) GB model"
einfo "      O(1) TB RAM   =  O(100) GB model"
einfo
einfo "                  or"
einfo
einfo "         1 GB RAM     256 M or less parameters"
einfo "         4 GB RAM       1 B or less parameters"
einfo "         8 GB RAM       2 B or less parameters"
einfo "        16 GB RAM       4 B or less parameters"
einfo "        32 GB RAM       8 B or less parameters"
einfo "        64 GB RAM      16 B or less parameters"
einfo "       128 GB RAM      32 B or less parameters"
einfo "       256 GB RAM      64 B or less parameters"
einfo "       512 GB RAM     128 B or less parameters"
einfo "         1 TB RAM     256 B or less parameters"
einfo
einfo "Tip:  If the words per minute is slower than 130, use a smaller model.  Using a slow model may affect text-to-speech."
einfo "Tip:  If the cold start time is more than 20 seconds, use a smaller model."
einfo
	if use systemd ; then
ewarn "The chroot and sandbox mitigation edits has not been implemented for systemd init script."
	fi

	# TODO:  Add more orphaned packages or move into overlay's README.md
	optfeature_header "Install optional packages:"
	optfeature "Electron GUI frontend" "app-misc/llocal"
	optfeature "GTK4 GUI frontend" "app-misc/alpaca"
	optfeature "Tauri GUI frontend with speech synthesis and speech recognition" "app-misc/amica"
	optfeature "Piped AI command line execution" "app-shells/loz"
	optfeature "AI text-to-speech and speech-to-text" "app-misc/june"
	optfeature "LLM roleplay" "games-rpg/RisuAI"
}

# OILEDMACHINE-OVERLAY-TEST:  passed (0.3.13, 20241020)
# cpu test: passed
