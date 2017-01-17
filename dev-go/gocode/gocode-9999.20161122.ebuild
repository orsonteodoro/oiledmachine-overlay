# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

COMMIT="5070dacabf2a80deeaf4ddb0be3761d06fce7be5"
GOLANG_PKG_NAME="gocode"
GOLANG_PKG_IMPORTPATH="github.com/nsf"
GOLANG_PKG_VERSION="${COMMIT}"
GOLANG_PKG_HAVE_TEST=1

inherit golang-single

DESCRIPTION="An autocompletion daemon for the Go programming language"
HOMEPAGE="https://github.com/nsf/gocode"
SRC_URI="https://github.com/nsf/gocode/archive/${COMMIT}.zip"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-fbsd ~x86-fbsd"

RDEPEND="dev-lang/go"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	local alias_abspath="${WORKDIR}/gopath/src/${GOLANG_PKG_IMPORTPATH_ALIAS}/${GOLANG_PKG_NAME}"
	mkdir -p "${alias_abspath%/*}"
	mv "${S}" ${alias_abspath}
	export S="${alias_abspath}"
}
