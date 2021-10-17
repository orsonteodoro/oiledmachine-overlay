# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit autotools distutils-r1

DESCRIPTION="Breezy is a friendly powerful distributed version control system."
HOMEPAGE="https://launchpad.net/brz"
LICENSE="GPL-2+ Apache-2.0"
# tools/rst2pdf.py is Apache-2.0
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" cext doc fastimport git gpg sftp test workspace"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND=" ${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/configobj[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/patiencediff[${PYTHON_USEDEP}]')
	cext? ( $(python_gen_cond_dep 'dev-python/cython[${PYTHON_USEDEP}]') )
	fastimport? ( $(python_gen_cond_dep 'dev-python/fastimport[${PYTHON_USEDEP}]') )
	git? ( $(python_gen_cond_dep '>=dev-python/dulwich-0.20.23[${PYTHON_USEDEP}]') )
	gpg? (
		$(python_gen_cond_dep 'app-crypt/gpgme[${PYTHON_USEDEP}]')
	)
	sftp? (
		$(python_gen_cond_dep 'dev-python/paramiko[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/pycrypto[${PYTHON_USEDEP}]')
	)
	workspace? ( $(python_gen_cond_dep 'dev-python/pyinotify[${PYTHON_USEDEP}]') )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	doc? (
		$(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/sphinx-epytext[${PYTHON_USEDEP}]')
	)
	test? (
		$(python_gen_cond_dep 'dev-python/testtools[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/subunit[${PYTHON_USEDEP}]')
	)"
SRC_URI="
https://launchpad.net/brz/$(ver_cut 1-2 ${PV})/${PV}/+download/${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/man" "${ED}/usr/share" || die
}
