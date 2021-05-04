# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit autotools distutils-r1

DESCRIPTION="Breezy is a friendly powerful distributed version control system."
HOMEPAGE="https://launchpad.net/brz"
LICENSE="GPL-2+ Apache-2.0"
# tools/rst2pdf.py is Apache-2.0
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" gpg sftp test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND="
	$(python_gen_cond_dep 'dev-python/configobj[${PYTHON_USEDEP}]' \
		python3_{6,7,8,9})
	$(python_gen_cond_dep '>=dev-python/dulwich-0.19.12[${PYTHON_USEDEP}]' \
		python3_{6,7,8,9})
	$(python_gen_cond_dep 'dev-python/patiencediff[${PYTHON_USEDEP}]' \
		python3_{6,7,8,9})
	$(python_gen_cond_dep 'dev-python/python-fastimport[${PYTHON_USEDEP}]' \
		python3_{6,7,8,9})
	$(python_gen_cond_dep '>=dev-python/six-1.9.0[${PYTHON_USEDEP}]' \
		python3_{6,7,8,9})
	gpg? (
		$(python_gen_cond_dep 'app-crypt/gpgme[${PYTHON_USEDEP}]' \
			python3_{6,7,8,9})
	)
	sftp? (
		$(python_gen_cond_dep 'dev-python/paramiko[${PYTHON_USEDEP}]' \
			python3_{6,7,8,9})
		$(python_gen_cond_dep 'dev-python/pycrypto[${PYTHON_USEDEP}]' \
			python3_{6,7,8,9})
	)"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/testtools[${PYTHON_USEDEP}]' \
			python3_{6,7,8,9})
	)"
SRC_URI=\
"https://launchpad.net/brz/$(ver_cut 1-2 ${PV})/${PV}/+download/${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/man" "${ED}/usr/share" || die
}
