# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/RapidFuzz"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+="
	${PYTHON_DEPS}
	(
		>=dev-python/JaroWinkler-1.1.0
		<dev-python/JaroWinkler-2.0.0
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/maxbachmann/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
