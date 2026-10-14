# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GEN_EBUILD=0 # To update, cycle as follows 0 -> 1 -> 0

inherit secure-version go-module #git-r3

EGO_SUM=(
	"golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8"
	"golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8/go.mod"
)
go-module_set_globals # This goes after inherit go-module

KEYWORDS="~amd64 ~arm64"
SRC_URI="https://github.com/evanw/esbuild/archive/v${PV}.tar.gz -> ${P}.tar.gz"
if [[ "${GEN_EBUILD}" != "1" ]] ; then
	SRC_URI+="
		${EGO_SUM_SRC_URI}
	"
fi

DESCRIPTION="A modern, extremely fast, JavaScript and CSS bundler and minifier"
HOMEPAGE="https://esbuild.github.io/"
LICENSE="BSD MIT"
SLOT="${PV}"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-lang/go-${GO_PV}:=
"
RESTRICT="test" # tests require more work, but chromium needs esbuild already.

_gen_unpack() {
	IFS=$'\n'
	local path
	local rows
	for path in $(find "${WORKDIR}" -name "go.sum") ; do
		for rows in $(cat "${path}" | cut -f 1-2 -d " ") ; do
			echo -e "\t\"${rows}\""
		done
	done
	IFS=$' \t\n'
}

gen_unpack() {
einfo "Replace EGO_SUM contents with the following:"
	_gen_unpack | sort | uniq
	die
}

src_unpack() {
	unpack "${P}.tar.gz"
	#die
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
}

src_compile() {
	ego build \
		-v \
		-ldflags="-s -w" \
		"./cmd/esbuild"
}

src_install() {
	newbin "esbuild" "esbuild-${PV}"
}

src_test() {
	ego test \
		-v \
		-ldflags="-s -w" \
		"./cmd/esbuild"
}
