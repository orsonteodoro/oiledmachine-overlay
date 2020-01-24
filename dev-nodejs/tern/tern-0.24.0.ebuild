# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A JavaScript code analyzer for deep, cross-editor language support"
LICENSE="MIT"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~ppc ~ppc64 ~x86 ~x64-macos"
IUSE="doc"
SLOT="${PV}"
RDEPEND="net-libs/nodejs[npm]"
DEPEND="${RDEPEND}"
SRC_URI=\
"https://github.com/ternjs/tern/archive/${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
inherit npm-secaudit
DOCS=( AUTHORS CONTRIBUTING.md LICENSE README.md )

npm-secaudit_src_compile() {
	:;
}

src_install() {
	npm-secaudit_install "*"

	#create wrapper
	exeinto /usr/bin
	echo "#!/bin/bash" > "${T}/${PN}"
	echo "/usr/$(get_libdir)/node/${PN}/${SLOT}/bin/tern \$@" \
		>> "${T}/${PN}"
	doexe "${T}/${PN}"
}
