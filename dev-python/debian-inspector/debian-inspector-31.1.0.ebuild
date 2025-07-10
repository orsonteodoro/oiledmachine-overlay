# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" ) # Lists up to 3.10

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nexB/debian-inspector.git"
	FALLBACK_COMMIT="6ee51fb05e4b0d1c61b0ae501b45a9a920a11ff4" # Feb 19, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/nexB/debian-inspector/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Utilities to parse Debian package, copyright and control files"
HOMEPAGE="
	https://github.com/nexB/debian-inspector
	https://pypi.org/project/debian-inspector
"
LICENSE="
	(
		Apache-2.0
		BSD
		MIT
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
# boolean.py -> boolean-py
# extractcode-7z -> extractcode_7z
# jaraco.functools -> jaraco-functools
# packageurl-python -> packageurl
# pdfminer.six - > pdfminer
RDEPEND+="
	>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
	>=dev-python/banal-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	>=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/boolean-py-4.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2022.6.15[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.15.1[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.5[${PYTHON_USEDEP}]
	>=dev-python/commoncode-31.0.0[${PYTHON_USEDEP}]
	>=dev-python/construct-2.10.68[${PYTHON_USEDEP}]
	>=dev-python/container-inspector-31.1.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-37.0.4[${PYTHON_USEDEP}]
	>=dev-python/dockerfile-parse-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/dparse2-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/extractcode-31.0.0[${PYTHON_USEDEP}]
	>=dev-python/extractcode_7z-16.5.210531[${PYTHON_USEDEP}]
	>=dev-python/extractcode-libarchive-3.5.1.210531[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.17.3[${PYTHON_USEDEP}]
	>=dev-python/fingerprints-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/ftfy-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/future-0.18.2[${PYTHON_USEDEP}]
	>=dev-python/gemfileparser-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/idna-3.3[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/intbitset-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/javaproperties-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/Jinja2-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/jsonstreams-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/license-expression-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.1[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-8.13.0[${PYTHON_USEDEP}]
	>=dev-python/normality-2.3.3[${PYTHON_USEDEP}]
	>=dev-python/packageurl-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/parameter-expansion-patched-0.3.1[${PYTHON_USEDEP}]
	>=app-text/pdfminer-20220524[${PYTHON_USEDEP}]
	>=dev-python/pefile-2022.5.30[${PYTHON_USEDEP}]
	>=dev-python/pip-requirements-parser-31.2.0[${PYTHON_USEDEP}]
	>=dev-python/pkginfo2-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/plugincode-31.0.0_beta1[${PYTHON_USEDEP}]
	>=dev-python/ply-3.11[${PYTHON_USEDEP}]
	>=dev-python/publicsuffix2-2.20191221[${PYTHON_USEDEP}]
	>=dev-python/pyahocorasick-2.0.0_beta1[${PYTHON_USEDEP}]
	>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
	>=dev-python/pygmars-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/pymaven-patch-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/rdflib-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.28.1[${PYTHON_USEDEP}]
	>=dev-python/saneyaml-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-2.3.2_p1[${PYTHON_USEDEP}]
	>=dev-python/spdx-tools-0.7.0_alpha3[${PYTHON_USEDEP}]
	>=dev-python/text-unidecode-1.3[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/typecode-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/typecode-libmagic-5.39.210531[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.11[${PYTHON_USEDEP}]
	>=dev-python/urlpy-0.5[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/xmltodict-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.8.1[${PYTHON_USEDEP}]

	>=dev-python/chardet-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	!=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml(+)]
	dev? (
		>=dev-python/aboutcode-toolkit-7.0.2[${PYTHON_USEDEP}]
		>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
		>=dev-python/bleach-5.0.1[${PYTHON_USEDEP}]
		>=dev-python/build-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/commonmark-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
		>=dev-python/et-xmlfile-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/execnet-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
		>=dev-python/jeepney-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/keyring-23.7.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-extensions-0.4.3[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.0.10[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pep517-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/pkginfo-1.8.3[${PYTHON_USEDEP}]
		>=dev-python/platformdirs-2.5.2[${PYTHON_USEDEP}]
		>=dev-python/py-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-forked-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/readme-renderer-35.0[${PYTHON_USEDEP}]
		>=dev-python/requests-toolbelt-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/rfc3986-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/rich-12.5.1[${PYTHON_USEDEP}]
		>=dev-python/secretstorage-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.64.0[${PYTHON_USEDEP}]
		>=dev-python/twine-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-5.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-apidoc-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.11.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-dark-mode-1.3.0[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-7.0.2[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/commoncode[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"1.8.2\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "apache-2.0.LICENSE" "bsd-new.LICENSE" "mit.LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
