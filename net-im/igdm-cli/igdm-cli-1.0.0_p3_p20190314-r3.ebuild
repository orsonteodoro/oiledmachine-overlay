# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Instagram Direct Messages in your terminal"
HOMEPAGE="https://github.com/mathdroid/igdm-cli"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
inherit eutils npm-secaudit npm-utils
EGIT_COMMIT="e32789f40a9c5a1145be01ea8c1a6bc4a16bc972"
SRC_URI=\
"https://github.com/mathdroid/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DEBUG_V="2.6.9"

fix_vulnerabilities() {
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=0 per-package-wise."
	sed -i -e "s|\"debug\": \"~0.8.1\",|\"debug\": \"${DEBUG_V}\",|" \
		node_modules/git-spawned-stream/package.json || die
	pushd node_modules/git-spawned-stream || die
		npm i debug@"${DEBUG_V}" --save-prod || die
		rm package-lock.json || die
		npm i --package-lock-only
		npm audit fix --force
	popd
}

npm-secaudit_src_postprepare() {
	if [[ "${NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL}" == "1" ]] ; then
		fix_vulnerabilities
	fi
	rm package-lock.json || die
	npm i --package-lock-only
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	npm-secaudit_install "*"

	exeinto /usr/bin
	cp "${FILESDIR}/${PN}" "${T}"
	sed -i -e "s|\${NPM_SECAUDIT_INSTALL_PATH}|${NPM_SECAUDIT_INSTALL_PATH}|" \
		"${T}/${PN}"
	doexe "${T}/${PN}"
}
