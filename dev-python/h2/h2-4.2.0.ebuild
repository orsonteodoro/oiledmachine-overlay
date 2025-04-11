# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="
	https://python-hyper.org/projects/h2/en/stable/
	https://github.com/python-hyper/h2/
	https://pypi.org/project/h2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc linting packaging test"

RDEPEND="
	(
		>=dev-python/hyperframe-6.1[${PYTHON_USEDEP}]
		<dev-python/hyperframe-7[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/hpack-4.1[${PYTHON_USEDEP}]
		<dev-python/hpack-5[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	doc? (
		>=dev-python/sphinx-7.4.7[${PYTHON_USEDEP}]
	)
	packaging? (
		>=dev-python/build-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/check-manifest-0.50[${PYTHON_USEDEP}]
		>=dev-python/readme-renderer-44.0[${PYTHON_USEDEP}]
		>=dev-python/twine-5.1.1[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.45.0[${PYTHON_USEDEP}]
	)
	linting? (
		>=dev-util/ruff-0.8.0
		>=dev-python/mypy-1.13.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/hypothesis-6.119.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-toml-compat.patch"
)

distutils_enable_tests "pytest"

python_test() {
	local -x CI=1
	epytest -p "hypothesis"
}
