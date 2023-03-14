# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The Levenshtein Python C extension module contains functions for \
fast computation of Levenshtein distance and string similarity"
LICENSE="GPL-2+"
HOMEPAGE="https://github.com/maxbachmann/Levenshtein"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
DEPEND+="
	(
		<dev-python/RapidFuzz-3
		>=dev-python/RapidFuzz-2.3
	)
"
RDEPEND+="
	${DEPEND}
"
# See CI
BDEPEND+="
	>=dev-python/cython-3.0.0_alpha11[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-63.1.0[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.22.5
	>=dev-util/ninja-1.10.2.3
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g")
	if ver_test ${cython_pv} -lt 3 && use cpp ; then
		eerror "Switch cython to >= 3.0.0_alpha10 via eselect-cython"
		die
	fi
	distutils-r1_src_configure
}

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
