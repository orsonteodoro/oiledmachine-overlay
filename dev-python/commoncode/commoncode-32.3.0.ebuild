# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aboutcode-org/commoncode.git"
	FALLBACK_COMMIT="30869cb2c4bf2eb3f251c4b38173e3918420b706" # Jun 11, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/commoncode/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Set of common utilities, originally split from ScanCode"
HOMEPAGE="
	https://github.com/aboutcode-org/commoncode
	https://pypi.org/project/commoncode
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/attrs-25.3.0[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.13.4[${PYTHON_USEDEP}]
	>=dev-python/certifi-2025.4.26[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.2.1[${PYTHON_USEDEP}]
	>=dev-python/idna-3.10[${PYTHON_USEDEP}]
	>=dev-python/pip-25.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.2[${PYTHON_USEDEP}]
	>=dev-python/saneyaml-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools-80.3.1[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-2.7[${PYTHON_USEDEP}]
	>=dev-python/text-unidecode-1.3[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.13.2[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.20[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.38.4[${PYTHON_USEDEP}]

	>=dev-python/attrs-22.1.0[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.13.0[${PYTHON_USEDEP},chardet(+)]
	>=dev-python/click-8.2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP},use_chardet_on_py3(+)]
	>=dev-python/saneyaml-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/text_unidecode-1.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
# boolean.py -> boolean-py
# jaraco.classes -> jaraco-classes
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml]
	dev-python/wheel[${PYTHON_USEDEP}]

	dev? (
		>=dev-python/aboutcode-toolkit-11.1.1[${PYTHON_USEDEP}]
		>=dev-python/black-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/bleach-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/boolean-py-4.0[${PYTHON_USEDEP}]
		>=dev-python/cffi-1.15.1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-39.0.1[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
		>=dev-python/et-xmlfile-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/exceptiongroup-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/execnet-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/isort-6.0.1[${PYTHON_USEDEP}]
		>=dev-python/jaraco-classes-3.2.3[${PYTHON_USEDEP}]
		>=dev-python/jeepney-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
		>=dev-python/keyring-23.13.1[${PYTHON_USEDEP}]
		>=dev-python/license-expression-30.1.0[${PYTHON_USEDEP}]
		>=dev-python/markdown-it-py-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.1.2[${PYTHON_USEDEP}]
		>=dev-python/mdurl-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/more-itertools-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-extensions-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.1.1[${PYTHON_USEDEP}]
		>=dev-python/packageurl-python-0.10.4[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.0[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/pkginfo-1.9.6[${PYTHON_USEDEP}]
		>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.13.0[${PYTHON_USEDEP}]
		>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/readme-renderer-37.3[${PYTHON_USEDEP}]
		>=dev-python/requests-toolbelt-0.10.1[${PYTHON_USEDEP}]
		>=dev-python/rfc3986-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.3.1[${PYTHON_USEDEP}]
		>=dev-python/secretstorage-3.3.3[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/twine-4.0.2[${PYTHON_USEDEP}]
		>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.14.0[${PYTHON_USEDEP}]


		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-11.1.1[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.11.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-dark-mode-1.3.0[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "README.rst" )

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
	dodoc "apache-2.0.LICENSE" "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
