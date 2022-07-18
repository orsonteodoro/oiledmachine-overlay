# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/RapidFuzz"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" cpp"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+="
	${PYTHON_DEPS}
	(
		>=dev-python/JaroWinkler-1.1.0
		<dev-python/JaroWinkler-2.0.0
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	cpp? (
		>=dev-python/cython-3.0.0_alpha10[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-capi-1.05[${PYTHON_USEDEP}]
		>=dev-python/setuptools-42[${PYTHON_USEDEP}]
		  dev-python/scikit-build[${PYTHON_USEDEP}]
		  dev-python/typing-extensions
		  dev-util/cmake
		  dev-util/ninja
	)
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	export RAPIDFUZZ_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}
