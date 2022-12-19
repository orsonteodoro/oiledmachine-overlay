# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit autotools distutils-r1 lcnr

DESCRIPTION="Breezy is a friendly powerful distributed version control system."
HOMEPAGE="https://launchpad.net/brz"
LICENSE="
	GPL-2+
	Apache-2.0
"
# tools/rst2pdf.py is Apache-2.0
LICENSE+="
	custom
	Apache-2.0
	BSD
	BSD-4
	MIT
	PSF-2.4
	openssl
	tcltk
	Unicode-DFS-2016
	Unlicense
" # Third party cargo licenses
# homedir/.cargo/registry/src/github.com-1ecc6299db9ec823/pyo3-0.15.2 - custom
# homedir/.cargo/registry/src/github.com-1ecc6299db9ec823/regex-1.6.0 - custom
# homedir/.cargo/registry/src/github.com-1ecc6299db9ec823/pkg-version-1.0.0 - custom
# homedir/.cargo/registry/src/github.com-1ecc6299db9ec823/regex-syntax-0.6.27/src/unicode_tables/LICENSE-UNICODE - Unicode-DFS-2016
# homedir/.cargo/registry/src/github.com-1ecc6299db9ec823/unicode-ident-1.0.5/LICENSE-UNICODE - Unicode-DFS-2016
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" cext doc fastimport git gpg sftp test workspace"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# See also:  https://github.com/breezy-team/breezy/blob/upstream-3.2.2/setup.py#L60
DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '>=dev-python/dulwich-0.20.23[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/fastbencode-0.0.5[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/urllib3-1.24.1[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/configobj[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/patiencediff[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	cext? ( $(python_gen_cond_dep '>=dev-python/cython-0.29[${PYTHON_USEDEP}]') )
	fastimport? ( $(python_gen_cond_dep 'dev-python/fastimport[${PYTHON_USEDEP}]') )
	gpg? (
		$(python_gen_cond_dep 'app-crypt/gpgme[${PYTHON_USEDEP}]')
	)
	sftp? (
		$(python_gen_cond_dep 'dev-python/paramiko[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/pycrypto[${PYTHON_USEDEP}]')
	)
	workspace? ( $(python_gen_cond_dep 'dev-python/pyinotify[${PYTHON_USEDEP}]') )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/setuptools-rust[${PYTHON_USEDEP}]')
	doc? (
		$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/sphinx-epytext[${PYTHON_USEDEP}]')
	)
	test? (
		$(python_gen_cond_dep '>=dev-python/dulwich-0.20.29[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/testtools[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/subunit[${PYTHON_USEDEP}]')
	)
"
SRC_URI="
https://launchpad.net/brz/$(ver_cut 1-2 ${PV})/${PV}/+download/${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi
	python_setup
}

src_install() {
	LCNR_SOURCE="${HOME}/.cargo"
	LCNR_TAG="third_party"
	lcnr_install_files

	distutils-r1_src_install
	mv "${ED}/usr/man" "${ED}/usr/share" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
