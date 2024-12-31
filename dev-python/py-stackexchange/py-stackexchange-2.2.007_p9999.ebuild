# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Py-StackExchange"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # Upstream listed 2.7 and 3

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/lucjon/Py-StackExchange.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="18243b192c7a1abe9f67b538c4156507e795bf1c" # Jan 2, 2018
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="FIXME"
fi

DESCRIPTION="A Python binding for the StackExchange API"
HOMEPAGE="https://github.com/lucjon/Py-StackExchange"
LICENSE="BSD"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
S="${WORKDIR}/${P}"

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	local actual_pv=$(grep "version =" "${S}/setup.py" \
		| cut -f 2 -d "'")
	local expected_pv=$(ver_cut 1-3 ${PV})
	if ver_test ${actual_pv} -ne ${expected_pv} ; then
eerror
eerror "A version change detected which may change *DEPENDs:"
eerror
eerror "Expected version:\t${expected_pv}"
eerror "Actual version:\t${expected_pv}"
eerror
eerror "Use the fallback-commit USE flag to continue."
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	fi
}

pkg_postinst() {
einfo
einfo "This is rate limited to 300 requests per day and may require an API key"
einfo "for 10,000 requests per day.  For details see"
einfo "https://github.com/lucjon/Py-StackExchange ."
einfo
}
