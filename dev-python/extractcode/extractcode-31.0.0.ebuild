# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" ) # Tests up to 3.9.  Lists up to 3.10.

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nexB/extractcode.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/nexB/extractcode/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A mostly universal archive extractor using 7zip, libarchive and the Python standard library for reliable archive extraction"
HOMEPAGE="
	https://github.com/nexB/extractcode
	https://pypi.org/project/extractcode
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc full patch test"
# boolean.py -> boolean-py
# extractcode-7z -> extractcode_7z
# jaraco.functools -> jaraco-functools
# pdfminer.six -> pdfminer
RDEPEND+="
	>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
	>=dev-python/banal-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	>=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/boolean-py-3.8[${PYTHON_USEDEP}]
	>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-2.0.12[${PYTHON_USEDEP}]
	>=dev-python/click-8.0.4[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/commoncode-30.2.0[${PYTHON_USEDEP}]
	>=dev-python/construct-2.10.68[${PYTHON_USEDEP}]
	>=dev-python/container-inspector-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.2[${PYTHON_USEDEP}]
	>=dev-python/debian-inspector-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/dockerfile-parse-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/dparse2-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/extractcode_7z-16.5.210531[${PYTHON_USEDEP}]
	>=dev-python/extractcode-libarchive-3.5.1.210531[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.17.3[${PYTHON_USEDEP}]
	>=dev-python/fingerprints-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/ftfy-6.0.3[${PYTHON_USEDEP}]
	>=dev-python/future-0.18.2[${PYTHON_USEDEP}]
	>=dev-python/gemfileparser-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/idna-3.3[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-4.8.3[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/intbitset-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/javaproperties-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/Jinja2-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/jsonstreams-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/license-expression-21.6.14[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-8.13.0[${PYTHON_USEDEP}]
	>=dev-python/normality-2.3.3[${PYTHON_USEDEP}]
	>=dev-python/packagedcode-msitools-0.101.210706[${PYTHON_USEDEP}]
	>=dev-python/packageurl-python-0.9.9[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/parameter-expansion-patched-0.3.1[${PYTHON_USEDEP}]
	>=app-text/pdfminer-20220506[${PYTHON_USEDEP}]
	>=dev-python/pefile-2021.9.3[${PYTHON_USEDEP}]
	>=dev-python/pip-requirements-parser-31.2.0[${PYTHON_USEDEP}]
	>=dev-python/pkginfo2-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/plugincode-21.1.21[${PYTHON_USEDEP}]
	>=dev-python/ply-3.11[${PYTHON_USEDEP}]
	>=dev-python/publicsuffix2-2.20191221[${PYTHON_USEDEP}]
	>=dev-python/pyahocorasick-2.0.0_beta1[${PYTHON_USEDEP}]
	>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
	>=dev-python/pygmars-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/pymaven-patch-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.8[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/rdflib-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/regipy-2.2.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.27.1[${PYTHON_USEDEP}]
	>=dev-python/rpm-inspector-rpm-4.16.1.3.210404[${PYTHON_USEDEP}]
	>=dev-python/saneyaml-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/spdx-tools-0.7.0_alpha3[${PYTHON_USEDEP}]
	>=dev-python/text-unidecode-1.3[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/typecode-21.6.1[${PYTHON_USEDEP}]
	>=dev-python/typecode-libmagic-5.39.210531[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.9[${PYTHON_USEDEP}]
	>=dev-python/urlpy-0.5[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/xmltodict-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.6.0[${PYTHON_USEDEP}]


	>=dev-python/attrs-18.1[${PYTHON_USEDEP}]
	!=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	>=dev-python/commoncode-30.2.0[${PYTHON_USEDEP}]
	>=dev-python/plugincode-21.1.21[${PYTHON_USEDEP}]
	>=dev-python/typecode-21.6.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	full? (
		>=dev-python/extractcode_7z-16.5.210525[${PYTHON_USEDEP}]
		>=dev-python/extractcode_libarchive-3.5.1.210525[${PYTHON_USEDEP}]
		>=dev-python/typecode-21.6.1[${PYTHON_USEDEP},full]
	)
	patch? (
		>=dev-python/patch-1.16[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml(+)]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/aboutcode-toolkit-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/bleach-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/build-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/commonmark-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/et-xmlfile-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/execnet-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/jeepney-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/keyring-23.4.1[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.0.9[${PYTHON_USEDEP}]
		>=dev-python/pep517-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/pkginfo-1.8.2[${PYTHON_USEDEP}]
		>=dev-python/py-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-forked-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/readme-renderer-34.0[${PYTHON_USEDEP}]
		>=dev-python/requests-toolbelt-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/rfc3986-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/rich-12.3.0[${PYTHON_USEDEP}]
		>=dev-python/secretstorage-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/twine-3.8.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.8.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-6.0.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
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
