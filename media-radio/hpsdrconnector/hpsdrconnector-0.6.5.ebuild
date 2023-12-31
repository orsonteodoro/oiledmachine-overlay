# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build go-module

HPSDR_PV="0.6.0"
LOGUTILS_PV="1.0.0"
EGO_PN="github.com/jancona/hpsdrconnector"
EGO_SUM=(
	"github.com/hashicorp/logutils v${LOGUTILS_PV}"
	"github.com/jancona/hpsdr v${HPSDR_PV}"
)
go-module_set_globals

SRC_URI="
${EGO_SUM_SRC_URI}
https://github.com/jancona/hpsdrconnector/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="An OpenWebRX connector for HPSDR radios"
HOMEPAGE="https://github.com/jancona/hpsdrconnector"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
BDEPEND="
	>=dev-lang/go-1.20
"
RESTRICT="mirror"
DOCS=( LICENSE NOTICE README.md )
S="${WORKDIR}/${P}"

src_unpack() {
	go-module_src_unpack
}

src_prepare() {
	default
	ln -s \
		"${GOMODCACHE}" \
		"${GOMODCACHE}/src" \
		|| die
	ln -s \
		"${GOMODCACHE}/github.com/hashicorp/logutils@v${LOGUTILS_PV}" \
		"${GOMODCACHE}/github.com/hashicorp/logutils" \
		|| die
	ln -s \
		"${GOMODCACHE}/github.com/jancona/hpsdr@v${HPSDR_PV}" \
		"${GOMODCACHE}/github.com/jancona/hpsdr" \
		|| die
}

src_compile() {
	export GO111MODULE=auto
	rm "go.mod" || die
	export GOPATH="${S}:${GOMODCACHE}"
	go build -v -o ${PN} || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
