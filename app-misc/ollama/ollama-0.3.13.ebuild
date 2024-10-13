# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Snapshot code came from go-appimage ebuild.

# U20
# For depends see
# https://github.com/ollama/ollama/blob/main/docs/development.md
# ROCm:  https://github.com/ollama/ollama/blob/main/.github/workflows/test.yaml#L119
# CUDA:  https://github.com/ollama/ollama/blob/main/.github/workflows/release.yaml#L194
GEN_EBUILD=0
ROCM_VERSION="6.1.2"
if ! [[ "${PV}" =~ "9999" ]] ; then
	export S_GO="${WORKDIR}/go_build"
fi

inherit go-module hip-versions lcnr

gen_go_dl_gh_url()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local tag="${3}"
	unset tag_split
	readarray -d - -t tag_split <<<"${tag}"
	local tag_commit="${tag_split[2]}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"

	if [[ -n "${tag_commit}" ]] ; then
		echo "
https://codeload.github.com/${uri_frag}/tar.gz/${tag_commit}
	-> ${dest_name}.tar.gz
		"
	else
		echo "
https://github.com/${uri_frag}/archive/refs/tags/${tag//+incompatible}.tar.gz
	-> ${dest_name}.tar.gz
		"
	fi
}

get_col3() {
	local uri="${1}"
	local ver="${2}"
	if [[ "${uri}" =~ "github.com/ollama/${PN}" ]] ; then
		echo "\${MY_PV}"
	else
		echo "${ver}"
	fi
}

get_col2_unpack() {
	local uri="${1}"
	unset REPO_URI_FRAG
	declare -A REPO_URI_FRAG=(
		# The right value is based on GH URI fragment as in the repository section.
#		[""]=""
		["golang.org/x/arch"]="golang/arch"
		["golang.org/x/crypto"]="golang/crypto"
		["golang.org/x/exp"]="golang/exp"
		["golang.org/x/image"]="golang/image"
		["golang.org/x/net"]="golang/net"
		["golang.org/x/sys"]="golang/sys"
		["golang.org/x/term"]="golang/term"
		["golang.org/x/text"]="golang/text"
		["golang.org/x/sync"]="golang/sync"
		["golang.org/x/xerrors"]="golang/xerrors"
		["go.lsp.dev/uri"]="go-language-server/uri"
		["go4.org/unsafe/assume-no-moving-gc"]="go4org/unsafe-assume-no-moving-gc"
		["google.golang.org/protobuf"]="protocolbuffers/protobuf-go"
		["gopkg.in/ini.v1"]="go-ini/ini"
		["gopkg.in/src-d/go-billy.v4"]="src-d/go-billy"
		["gopkg.in/src-d/go-git.v4"]="src-d/go-git"
		["gopkg.in/warnings.v0"]="go-warnings/warnings"
		["gopkg.in/yaml.v3"]="go-yaml/yaml"
		["gonum.org/v1/gonum"]="gonum/gonum"
		["gorgonia.org/vecf32"]="gorgonia/vecf32"
		["gorgonia.org/vecf64"]="gorgonia/vecf64"
	)
	if [[ "${uri}" =~ "github.com/" ]] ; then
		echo "${uri}" | cut -f 2-3 -d "/"
	else
		local t="${REPO_URI_FRAG[${uri}]}"
		if [[ -z "${t}" ]] ; then
eerror "Missing get_col2_unpack() entry for ${uri}"
			die
		else
			echo "${t}"
		fi
	fi
}

generate_ebuild_snapshot() {
	cd "${S}" || die
	IFS=$'\n'
	L=(
		"github.com/ollama/${PN} MY_PV"
		$(grep -E "/" "${S}/go.mod" | sed -e "1d" | sed -e "s|// indirect.*||g")
	)


einfo
einfo "Replace SRC_URI section:"
einfo
	for row in ${L[@]} ; do
		local c1=$(echo "${row}" | cut -f 1 -d " " | sed -E -e "s|[[:space:]]+||g")

		local n_frags=$(echo "${c1}" | tr '/' $'\n' | wc -l)
		if [[ "${c1}" =~ "github.com" ]] && (( ${n_frags} != 3 )) ; then
			c1=$(echo "${c1}" | cut -f 1-3 -d "/")
		fi

		local c2=$(get_col2_unpack "${c1}")
		local ver=$(echo "${row}" | cut -f 2 -d " ")
		local c3=$(get_col3 "${c1}" "${ver}")
echo -e "\$(gen_go_dl_gh_url ${c1} ${c2} ${c3})"
	done

einfo
einfo "Replace unpack_go section:"
einfo
	for row in ${L[@]} ; do
		local c1=$(echo "${row}" | cut -f 1 -d " " | sed -E -e "s|[[:space:]]+||g")

		local n_frags=$(echo "${c1}" | tr '/' $'\n' | wc -l)
		if [[ "${c1}" =~ "github.com" ]] && (( ${n_frags} != 3 )) ; then
			c1=$(echo "${c1}" | cut -f 1-3 -d "/")
		fi

		local c2=$(get_col2_unpack "${c1}")
		local ver=$(echo "${row}" | cut -f 2 -d " ")
		local c3=$(get_col3 "${c1}" "${ver}")
echo -e "\tunpack_go_pkg ${c1} ${c2} ${c3}"
	done
	IFS=$' \t\n'
einfo
einfo "Please update the ebuild with the following above information."
einfo
	die
}

unpack_go_pkg()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local proj_name="${2#*/}"
	local tag="${3}"
	local dest="${S_GO}/src/${pkg_name}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"
einfo "Unpacking ${dest_name}.tar.gz"

	local n_frags=$(echo "${pkg_name}" | tr '/' $'\n' | wc -l)
	if [[ "${pkg_name}" =~ "github.com" ]] && (( "${n_frags}" != 3 )) ; then
		local path=$(echo "${pkg_name}" | cut -f 1-3 -d "/")
		dest="${S_GO}/src/${path}"
	fi

	mkdir -p "${dest}" || die

	tar \
		--strip-components=1 \
		-x \
		-C "${dest}" \
		-f "${DISTDIR}/${dest_name}.tar.gz" \
		|| die
}

# From:  date -d "${EGIT_COMMIT_TIMESTAMP}" -u
TIMESTAMP_YYMMDD="20240414"
TIMESTAMP_HHMMSS="155828" # In UTC without :

# Version template obtained from https://pkg.go.dev/github.com/probonopd/go-appimage?tab=versions
#MY_PV="v0.0.0-${TIMESTAMP_YYMMDD}${TIMESTAMP_HHMMSS}-${EGIT_COMMIT:0:12}" # Keep below TIMESTAMP_*
MY_PV="v${PV}"

# Manual edit
# github.com/bytedance/sonic needs v0.1.1 -> loader/v0.1.1 tag
unpack_go()
{
	unpack_go_pkg github.com/ollama/ollama ollama/ollama ${MY_PV}
	unpack_go_pkg github.com/containerd/console containerd/console v1.0.3
	unpack_go_pkg github.com/emirpasic/gods emirpasic/gods v1.18.1
	unpack_go_pkg github.com/gin-gonic/gin gin-gonic/gin v1.10.0
	unpack_go_pkg github.com/golang/protobuf golang/protobuf v1.5.4
	unpack_go_pkg github.com/google/uuid google/uuid v1.1.2
	unpack_go_pkg github.com/olekukonko/tablewriter olekukonko/tablewriter v0.0.5
	unpack_go_pkg github.com/spf13/cobra spf13/cobra v1.7.0
	unpack_go_pkg github.com/stretchr/testify stretchr/testify v1.9.0
	unpack_go_pkg github.com/x448/float16 x448/float16 v0.8.4
	unpack_go_pkg golang.org/x/sync golang/sync v0.3.0
	unpack_go_pkg github.com/agnivade/levenshtein agnivade/levenshtein v1.1.1
	unpack_go_pkg github.com/d4l3k/go-bfloat16 d4l3k/go-bfloat16 v0.0.0-20211005043715-690c3bdd05f1
	unpack_go_pkg github.com/google/go-cmp google/go-cmp v0.6.0
	unpack_go_pkg github.com/mattn/go-runewidth mattn/go-runewidth v0.0.14
	unpack_go_pkg github.com/nlpodyssey/gopickle nlpodyssey/gopickle v0.3.0
	unpack_go_pkg github.com/pdevine/tensor pdevine/tensor v0.0.0-20240510204454-f88f4562727c
	unpack_go_pkg github.com/apache/arrow apache/arrow v0.0.0-20211112161151-bc219186db40
	unpack_go_pkg github.com/bytedance/sonic bytedance/sonic loader/v0.1.1
	unpack_go_pkg github.com/chewxy/hm chewxy/hm v1.0.0
	unpack_go_pkg github.com/chewxy/math32 chewxy/math32 v1.10.1
	unpack_go_pkg github.com/cloudwego/base64x cloudwego/base64x v0.1.4
	unpack_go_pkg github.com/cloudwego/iasm cloudwego/iasm v0.2.0
	unpack_go_pkg github.com/davecgh/go-spew davecgh/go-spew v1.1.1
	unpack_go_pkg github.com/gogo/protobuf gogo/protobuf v1.3.2
	unpack_go_pkg github.com/google/flatbuffers google/flatbuffers v24.3.25+incompatible
	unpack_go_pkg github.com/kr/text kr/text v0.2.0
	unpack_go_pkg github.com/pkg/errors pkg/errors v0.9.1
	unpack_go_pkg github.com/pmezard/go-difflib pmezard/go-difflib v1.0.0
	unpack_go_pkg github.com/rivo/uniseg rivo/uniseg v0.2.0
	unpack_go_pkg github.com/xtgo/set xtgo/set v1.0.0
	unpack_go_pkg go4.org/unsafe/assume-no-moving-gc go4org/unsafe-assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6
	unpack_go_pkg golang.org/x/xerrors golang/xerrors v0.0.0-20200804184101-5ec99f83aff1
	unpack_go_pkg gonum.org/v1/gonum gonum/gonum v0.15.0
	unpack_go_pkg gorgonia.org/vecf32 gorgonia/vecf32 v0.9.0
	unpack_go_pkg gorgonia.org/vecf64 gorgonia/vecf64 v0.9.0
	unpack_go_pkg github.com/bytedance/sonic bytedance/sonic v1.11.6
	unpack_go_pkg github.com/gabriel-vasile/mimetype gabriel-vasile/mimetype v1.4.3
	unpack_go_pkg github.com/gin-contrib/cors gin-contrib/cors v1.7.2
	unpack_go_pkg github.com/gin-contrib/sse gin-contrib/sse v0.1.0
	unpack_go_pkg github.com/go-playground/locales go-playground/locales v0.14.1
	unpack_go_pkg github.com/go-playground/universal-translator go-playground/universal-translator v0.18.1
	unpack_go_pkg github.com/go-playground/validator go-playground/validator v10.20.0
	unpack_go_pkg github.com/goccy/go-json goccy/go-json v0.10.2
	unpack_go_pkg github.com/inconshreveable/mousetrap inconshreveable/mousetrap v1.1.0
	unpack_go_pkg github.com/json-iterator/go json-iterator/go v1.1.12
	unpack_go_pkg github.com/klauspost/cpuid klauspost/cpuid v2.2.7
	unpack_go_pkg github.com/leodido/go-urn leodido/go-urn v1.4.0
	unpack_go_pkg github.com/mattn/go-isatty mattn/go-isatty v0.0.20
	unpack_go_pkg github.com/modern-go/concurrent modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd
	unpack_go_pkg github.com/modern-go/reflect2 modern-go/reflect2 v1.0.2
	unpack_go_pkg github.com/pelletier/go-toml pelletier/go-toml v2.2.2
	unpack_go_pkg github.com/spf13/pflag spf13/pflag v1.0.5
	unpack_go_pkg github.com/twitchyliquid64/golang-asm twitchyliquid64/golang-asm v0.15.1
	unpack_go_pkg github.com/ugorji/go ugorji/go v1.2.12
	unpack_go_pkg golang.org/x/arch golang/arch v0.8.0
	unpack_go_pkg golang.org/x/crypto golang/crypto v0.23.0
	unpack_go_pkg golang.org/x/exp golang/exp v0.0.0-20231110203233-9a3e6036ecaa
	unpack_go_pkg golang.org/x/net golang/net v0.25.0
	unpack_go_pkg golang.org/x/sys golang/sys v0.20.0
	unpack_go_pkg golang.org/x/term golang/term v0.20.0
	unpack_go_pkg golang.org/x/text golang/text v0.15.0
	unpack_go_pkg google.golang.org/protobuf protocolbuffers/protobuf-go v1.34.1
	unpack_go_pkg gopkg.in/yaml.v3 go-yaml/yaml v3.0.1
}

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ollama/ollama.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	FALLBACK_COMMIT="c3d321d405df2076768de49cf999a3542224eabd" # Oct 12, 2024
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"

# Manual edit
# github.com/bytedance/sonic needs v0.1.1 -> loader/v0.1.1 tag
	SRC_URI="
https://github.com/ollama/ollama/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
$(gen_go_dl_gh_url github.com/ollama/ollama ollama/ollama ${MY_PV})
$(gen_go_dl_gh_url github.com/containerd/console containerd/console v1.0.3)
$(gen_go_dl_gh_url github.com/emirpasic/gods emirpasic/gods v1.18.1)
$(gen_go_dl_gh_url github.com/gin-gonic/gin gin-gonic/gin v1.10.0)
$(gen_go_dl_gh_url github.com/golang/protobuf golang/protobuf v1.5.4)
$(gen_go_dl_gh_url github.com/google/uuid google/uuid v1.1.2)
$(gen_go_dl_gh_url github.com/olekukonko/tablewriter olekukonko/tablewriter v0.0.5)
$(gen_go_dl_gh_url github.com/spf13/cobra spf13/cobra v1.7.0)
$(gen_go_dl_gh_url github.com/stretchr/testify stretchr/testify v1.9.0)
$(gen_go_dl_gh_url github.com/x448/float16 x448/float16 v0.8.4)
$(gen_go_dl_gh_url golang.org/x/sync golang/sync v0.3.0)
$(gen_go_dl_gh_url github.com/agnivade/levenshtein agnivade/levenshtein v1.1.1)
$(gen_go_dl_gh_url github.com/d4l3k/go-bfloat16 d4l3k/go-bfloat16 v0.0.0-20211005043715-690c3bdd05f1)
$(gen_go_dl_gh_url github.com/google/go-cmp google/go-cmp v0.6.0)
$(gen_go_dl_gh_url github.com/mattn/go-runewidth mattn/go-runewidth v0.0.14)
$(gen_go_dl_gh_url github.com/nlpodyssey/gopickle nlpodyssey/gopickle v0.3.0)
$(gen_go_dl_gh_url github.com/pdevine/tensor pdevine/tensor v0.0.0-20240510204454-f88f4562727c)
$(gen_go_dl_gh_url github.com/apache/arrow apache/arrow v0.0.0-20211112161151-bc219186db40)
$(gen_go_dl_gh_url github.com/bytedance/sonic bytedance/sonic loader/v0.1.1)
$(gen_go_dl_gh_url github.com/chewxy/hm chewxy/hm v1.0.0)
$(gen_go_dl_gh_url github.com/chewxy/math32 chewxy/math32 v1.10.1)
$(gen_go_dl_gh_url github.com/cloudwego/base64x cloudwego/base64x v0.1.4)
$(gen_go_dl_gh_url github.com/cloudwego/iasm cloudwego/iasm v0.2.0)
$(gen_go_dl_gh_url github.com/davecgh/go-spew davecgh/go-spew v1.1.1)
$(gen_go_dl_gh_url github.com/gogo/protobuf gogo/protobuf v1.3.2)
$(gen_go_dl_gh_url github.com/google/flatbuffers google/flatbuffers v24.3.25+incompatible)
$(gen_go_dl_gh_url github.com/kr/text kr/text v0.2.0)
$(gen_go_dl_gh_url github.com/pkg/errors pkg/errors v0.9.1)
$(gen_go_dl_gh_url github.com/pmezard/go-difflib pmezard/go-difflib v1.0.0)
$(gen_go_dl_gh_url github.com/rivo/uniseg rivo/uniseg v0.2.0)
$(gen_go_dl_gh_url github.com/xtgo/set xtgo/set v1.0.0)
$(gen_go_dl_gh_url go4.org/unsafe/assume-no-moving-gc go4org/unsafe-assume-no-moving-gc v0.0.0-20231121144256-b99613f794b6)
$(gen_go_dl_gh_url golang.org/x/xerrors golang/xerrors v0.0.0-20200804184101-5ec99f83aff1)
$(gen_go_dl_gh_url gonum.org/v1/gonum gonum/gonum v0.15.0)
$(gen_go_dl_gh_url gorgonia.org/vecf32 gorgonia/vecf32 v0.9.0)
$(gen_go_dl_gh_url gorgonia.org/vecf64 gorgonia/vecf64 v0.9.0)
$(gen_go_dl_gh_url github.com/bytedance/sonic bytedance/sonic v1.11.6)
$(gen_go_dl_gh_url github.com/gabriel-vasile/mimetype gabriel-vasile/mimetype v1.4.3)
$(gen_go_dl_gh_url github.com/gin-contrib/cors gin-contrib/cors v1.7.2)
$(gen_go_dl_gh_url github.com/gin-contrib/sse gin-contrib/sse v0.1.0)
$(gen_go_dl_gh_url github.com/go-playground/locales go-playground/locales v0.14.1)
$(gen_go_dl_gh_url github.com/go-playground/universal-translator go-playground/universal-translator v0.18.1)
$(gen_go_dl_gh_url github.com/go-playground/validator go-playground/validator v10.20.0)
$(gen_go_dl_gh_url github.com/goccy/go-json goccy/go-json v0.10.2)
$(gen_go_dl_gh_url github.com/inconshreveable/mousetrap inconshreveable/mousetrap v1.1.0)
$(gen_go_dl_gh_url github.com/json-iterator/go json-iterator/go v1.1.12)
$(gen_go_dl_gh_url github.com/klauspost/cpuid klauspost/cpuid v2.2.7)
$(gen_go_dl_gh_url github.com/leodido/go-urn leodido/go-urn v1.4.0)
$(gen_go_dl_gh_url github.com/mattn/go-isatty mattn/go-isatty v0.0.20)
$(gen_go_dl_gh_url github.com/modern-go/concurrent modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd)
$(gen_go_dl_gh_url github.com/modern-go/reflect2 modern-go/reflect2 v1.0.2)
$(gen_go_dl_gh_url github.com/pelletier/go-toml pelletier/go-toml v2.2.2)
$(gen_go_dl_gh_url github.com/spf13/pflag spf13/pflag v1.0.5)
$(gen_go_dl_gh_url github.com/twitchyliquid64/golang-asm twitchyliquid64/golang-asm v0.15.1)
$(gen_go_dl_gh_url github.com/ugorji/go ugorji/go v1.2.12)
$(gen_go_dl_gh_url golang.org/x/arch golang/arch v0.8.0)
$(gen_go_dl_gh_url golang.org/x/crypto golang/crypto v0.23.0)
$(gen_go_dl_gh_url golang.org/x/exp golang/exp v0.0.0-20231110203233-9a3e6036ecaa)
$(gen_go_dl_gh_url golang.org/x/net golang/net v0.25.0)
$(gen_go_dl_gh_url golang.org/x/sys golang/sys v0.20.0)
$(gen_go_dl_gh_url golang.org/x/term golang/term v0.20.0)
$(gen_go_dl_gh_url golang.org/x/text golang/text v0.15.0)
$(gen_go_dl_gh_url google.golang.org/protobuf protocolbuffers/protobuf-go v1.34.1)
$(gen_go_dl_gh_url gopkg.in/yaml.v3 go-yaml/yaml v3.0.1)
	"
fi

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models."
HOMEPAGE="https://ollama.com"
LICENSE="
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
	MIT
	Boost-1.0
	W3C-Test-Suite-Licence
"
# Apache-2.0 BSD BSD-2 MIT UoI-NCSA - go_build/src/github.com/apache/arrow/NOTICE.txt
# Apache-2.0 - go_build/src/golang.org/x/exp/shiny/materialdesign/icons/LICENSE
# BSD - go_build/src/go4.org/unsafe/assume-no-moving-gc/LICENSE
# MIT - go_build/src/gorgonia.org/vecf64/LICENSE
# Boost-1.0 - go_build/src/github.com/bytedance/sonic/licenses/LICENSE-Drachennest
# BSD-2 - go_build/src/github.com/nlpodyssey/gopickle/LICENSE
# BSD-2 ISC - go_build/src/github.com/emirpasic/gods/LICENSE
# W3C Test Suite License, W3C 3-clause BSD License - go_build/src/gonum.org/v1/gonum/graph/formats/rdf/testdata/LICENSE.md

SLOT="0"
IUSE+=" cuda rocm systemd"
RDEPEND="
	acct-group/ollama
	acct-user/ollama
"
IDEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.24
	>=dev-lang/go-1.22.5
	>=sys-devel/gcc-11.4.0
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
			=dev-util/nvidia-cuda-toolkit-12.4*
		)
	)
	rocm? (
		~dev-libs/rocm-opencl-runtime-${HIP_6_1_VERSION}:${ROCM_VERSION%.*}
		sci-libs/clblast
	)
"

pkg_pretend() {
	if use rocm ; then
ewarn "ROCm support for ${PN} is experimental and incomplete on ebuild level."
	fi
	if use cuda ; then
ewarn "CUDA support for ${PN} is experimental."
	fi
}

gen_git_tag() {
einfo "Generating tag start"
	cd "${S}" || die
	git init || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_src_unpack
		go-module_live_vendor
	else
		unpack "${P}.tar.gz"
		[[ "${GEN_EBUILD}" == "1" ]] && generate_ebuild_snapshot
		unpack_go
		export S="${S_GO}/src/github.com/ollama/${PN}"
		cd "${S}" || die
		gen_git_tag
	fi
}

src_prepare() {
	default
	sed -i -e "s|// import \"gorgonia.org/tensor\"||g" "${S_GO}/src/github.com/pdevine/tensor/tensor.go" || die
	sed -i -e "s|// import \"gorgonia.org/tensor/internal/storage\"||g" "${S_GO}/src/github.com/pdevine/tensor/internal/storage/header.go" || die
	sed -i -e "s|// import \"gorgonia.org/tensor/internal/execution\"||g" "${S_GO}/src/github.com/pdevine/tensor/internal/execution/e.go" || die
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
		ego generate ./...
		ego build .
	else
		export GOPATH="${WORKDIR}/go_build"
		export GOBIN="${GOPATH}/bin"
		export GO111MODULE=auto
		mkdir -p "${GOBIN}" || die
		pushd "${GOBIN}" || die
			go build "github.com/ollama/${PN}" || die
		popd
	fi
}

src_install() {
	if ! [[ "${PV}" =~ "9999" ]] ; then
		cd "${S_GO}/bin" || die
	fi
	dobin "${PN}"
	if use systemd ; then
		doinitd "${FILESDIR}/${PN}"
	fi
	if ! [[ "${PV}" =~ "9999" ]] ; then
		LCNR_SOURCE="${S_GO}/src"
		lcnr_install_files
	# TODO:  handle live case
	fi
}

pkg_preinst() {
	keepdir "/var/log/${PN}"
	fowners "${PN}:${PN}" "/var/log/${PN}"
}

pkg_postinst() {
einfo
einfo "Quick guide:"
einfo
einfo "  ${PN} serve"
einfo "  ${PN} run llama3:70b"
einfo
einfo "Models are available at https://ollama.com/library"
einfo
}
