# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The Levenshtein Python C extension module contains functions for
fast computation of Levenshtein distance and string similarity"
LICENSE="GPL-2+"
HOMEPAGE="https://github.com/maxbachmann/Levenshtein"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Distro repo missing cython 3.0_a10
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+="
	${PYTHON_DEPS}
	(
		>=dev-python/RapidFuzz-2.0.1
		<dev-python/RapidFuzz-3
	)
"
RDEPEND+=" ${DEPEND}"
# See CI
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cython-3.0.0_alpha10[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-63.1.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.22.5
	>=dev-util/ninja-1.10.2.3
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
