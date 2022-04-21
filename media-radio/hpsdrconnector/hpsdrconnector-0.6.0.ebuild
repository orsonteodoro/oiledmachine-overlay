# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/jancona/hpsdrconnector"
inherit golang-build go-module

EGO_SUM=(
	"github.com/hashicorp/logutils v1.0.0"
	"github.com/jancona/hpsdr v0.4.0"
)
go-module_set_globals
DESCRIPTION="An OpenWebRX connector for HPSDR radios"
HOMEPAGE="https://github.com/jancona/hpsdrconnector"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
RESTRICT="mirror"
SRC_URI="
https://github.com/jancona/hpsdrconnector/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
${EGO_SUM_SRC_URI}
"
DOCS=( LICENSE NOTICE README.md )
S="${WORKDIR}/${P}"

src_unpack() {
	go-module_src_unpack
}

src_prepare() {
	default
	ln -s "${GOMODCACHE}" "${GOMODCACHE}/src" || die
	ln -s "${GOMODCACHE}/github.com/hashicorp/logutils@v1.0.0" \
		"${GOMODCACHE}/github.com/hashicorp/logutils" || die
	ln -s "${GOMODCACHE}/github.com/jancona/hpsdr@v0.4.0" \
		"${GOMODCACHE}/github.com/jancona/hpsdr" || die
}

src_compile() {
	export GO111MODULE=auto
	rm "go.mod" || die
	export GOPATH="${S}:${GOMODCACHE}"
	#unset GOPATH
	go build -v -o ${PN} || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
