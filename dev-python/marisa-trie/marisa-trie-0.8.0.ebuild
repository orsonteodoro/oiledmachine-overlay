# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Static memory-efficient Trie-like structures for Python"
HOMEPAGE="https://pypi.org/project/marisa-trie/"
SRC_URI="https://github.com/pytries/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/marisa-0.2.6
"
RDEPEND="${DEPEND}"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/readme_renderer[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/system-marisa-lib.patch"
)

distutils_enable_tests pytest
