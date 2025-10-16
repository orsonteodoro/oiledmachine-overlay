# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# Patch snapshot parts are from ollama ebuild.

# See integration_test.go:protobufVersion for bindings compatibility
GEN_EBUILD=0
MY_PV="v${PV}"
PROTOBUF_SLOT="3.15" # https://github.com/protocolbuffers/protobuf-go/blob/v1.27.1/integration_test.go#L38
export S_GO="${WORKDIR}/go_build"

inherit go-module

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
	if [[ "${uri}" =~ "github.com/protocolbuffers/${PN}" ]] ; then
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
		"github.com/protocolbuffers/${PN} MY_PV"
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

MY_PV="v${PV}"

unpack_go()
{
	unpack_go_pkg github.com/protocolbuffers/protobuf-go protocolbuffers/protobuf-go ${MY_PV}
	unpack_go_pkg github.com/golang/protobuf golang/protobuf v1.5.0
	unpack_go_pkg github.com/google/go-cmp google/go-cmp v0.5.5
	mkdir -p "${WORKDIR}/go_build/src/google.golang.org" || die
	ln -s \
		"${WORKDIR}/go_build/src/github.com/protocolbuffers/protobuf-go" \
		"${WORKDIR}/go_build/src/google.golang.org/protobuf" \
		|| die
}

KEYWORDS="~amd64"
SRC_URI="
	https://github.com/protocolbuffers/protobuf-go/archive/v${PV}.tar.gz -> ${P}.tar.gz
$(gen_go_dl_gh_url github.com/protocolbuffers/protobuf-go protocolbuffers/protobuf-go ${MY_PV})
$(gen_go_dl_gh_url github.com/golang/protobuf golang/protobuf v1.5.0)
$(gen_go_dl_gh_url github.com/google/go-cmp google/go-cmp v0.5.5)
"

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="http://protobuf.dev"
LICENSE="BSD"
SLOT="0/${PROTOBUF_SLOT}"
# KISS (Keep It Simple Stupid).  About the version gaurantees...
# protobuf-go 1.27.1 was released in Jun 2021.
# It supports 1 year previous, so the protobuf allowed is no less than Jun 2020.
# 0/3.21 (21.12) released on Dec 2022, no
# 0/3.19 (3.19.6) released on Sep 2022, no
# 0/3.12 (3.12.4) released on Jul 2020, yes
RDEPEND="
	|| (
		dev-libs/protobuf:0/3.12
	)
	dev-libs/protobuf:=
"
BDEPEND="
	>=dev-lang/go-1.11.13
"

src_unpack() {
	unpack "${P}.tar.gz"
	[[ "${GEN_EBUILD}" == "1" ]] && generate_ebuild_snapshot
	unpack_go
}

src_compile() {
	export GOPATH="${WORKDIR}/go_build"
	export GOBIN="${GOPATH}/bin"
	export GO111MODULE=auto
	mkdir -p "${GOBIN}"
	pushd "${GOBIN}/" >/dev/null 2>&1 || die
		go build "github.com/protocolbuffers/${PN}/cmd/protoc-gen-go" || die
	popd >/dev/null 2>&1 || die
}

src_install() {
	dobin "${GOBIN}/protoc-gen-go"
}
