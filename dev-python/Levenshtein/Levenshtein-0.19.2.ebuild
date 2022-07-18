# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The Levenshtein Python C extension module contains functions for
fast computation of Levenshtein distance and string similarity"
LICENSE="GPL-2+"
HOMEPAGE="https://github.com/maxbachmann/Levenshtein"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/maxbachmann/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
