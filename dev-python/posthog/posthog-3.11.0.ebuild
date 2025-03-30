# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# flake8-print
# langchain-anthropic
# langchain-openai
# langgraph

MY_PN="posthog-python"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/posthog/posthog-python.git"
	FALLBACK_COMMIT="8f43bbc61374272bc5b2d700dcb7c6b98a63a7e2" # Jan 28, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/posthog/posthog-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Integrate PostHog product analytics into any Python application"
HOMEPAGE="
	https://github.com/posthog/posthog-python
	https://pypi.org/project/posthog
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev langchain sentry test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/backoff-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/monotonic-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.7[${PYTHON_USEDEP}]
		>=dev-python/six-1.5[${PYTHON_USEDEP}]
		>dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
		sentry? (
			dev-python/sentry-sdk[${PYTHON_USEDEP}]
			dev-python/django[${PYTHON_USEDEP}]
		)
	')
	langchain? (
		>=dev-python/langchain-0.2.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev? (
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/flake8-print[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/freezegun-0.3.15[${PYTHON_USEDEP}]
			>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
			dev-python/anthropic[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/django[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/langgraph[${PYTHON_USEDEP}]
			dev-python/openai[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/pylint[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		>=dev-python/langchain-anthropic-0.2.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-community-0.2.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-openai-0.2.0[${PYTHON_SINGLE_USEDEP}]
	)
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
