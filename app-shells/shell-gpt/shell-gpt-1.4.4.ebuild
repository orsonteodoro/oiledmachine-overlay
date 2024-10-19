# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# instructor
# pyreadline3

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{9..11} ) # Upstream tests up to 3.11

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="https://github.com/TheR1D/shell_gpt/archive/refs/tags/${PV}.tar.gz"

DESCRIPTION="A command-line productivity tool powered by OpenAI's GPT models."
HOMEPAGE="https://github.com/TheR1D/shell_gpt"
LICENSE="MIT"
RESTRICT="test" # untested
SLOT="0"
IUSE="dev openai ollama test"
REQUIRED_USE="
	|| (
		openai
		ollama
	)
"
RDEPEND="
	>=dev-python/click-7.1.1[${PYTHON_USEDEP}]
	>=dev-python/distro-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/instructor-0.4.5[${PYTHON_USEDEP}]
	>=dev-python/pyreadline3-3.4.1[${PYTHON_USEDEP}]
	>=dev-python/rich-13.1.0[${PYTHON_USEDEP}]
	>=dev-python/typer-0.7.0[${PYTHON_USEDEP}]
	ollama? (
		dev-python/litellm[${PYTHON_USEDEP}]
		app-misc/ollama
	)
	openai? (
		>=dev-python/openai-1.34.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev? (
		>=dev-util/ruff-0.0.256[${PYTHON_USEDEP}]
		>=dev-vcs/pre-commit-3.1.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-7.2.2[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.12.0[${PYTHON_USEDEP}]
		>=dev-python/black-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.28.11.17[${PYTHON_USEDEP}]
		>=dev-python/codespell-2.2.5[${PYTHON_USEDEP}]
	)
"

src_unpack() {
	if [[ -n "${A}" ]]; then
		unpack ${A}
		S="${WORKDIR}/shell_gpt-${PV}"
	fi
}

pkg_postinst() {
	if use ollama ; then
einfo
einfo "Upstream recommends mistral:7b-instruct llm for ollama for best results."
einfo
einfo "You must add/change the following in ~/.config/shell_gpt/.sgptrc:"
einfo
einfo "  DEFAULT_MODEL=\"ollama/mistral:7b-instruct\""
einfo "  OPENAI_USE_FUNCTIONS=\"false\""
einfo "  USE_LITELLM=\"true\""
einfo
	fi
}
