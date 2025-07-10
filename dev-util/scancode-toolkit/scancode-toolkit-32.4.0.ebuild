# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This package is unfinished.

# Why package this?
#
# 1. Has AI/ML scanning
# 2. Saves time scanning for licenses
# 3. Can train a model based on distro's license folder
# 4. Can detect missed licenses in source code
# 5. Frees developer time to do other things.

# TODO package (rdepend):
# extractcode
# extractcode_7z
# extractcode-libarchive

# TODO package (dev)
# aboutcode-toolkit
# vendorize

# TODO package (doc)
# sphinx-rtd-dark-mode

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aboutcode-org/scancode-toolkit.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Unfinished
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/scancode-toolkit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="ScanCode detects licenses, copyrights, package manifests, direct dependencies, and more"
HOMEPAGE="
	https://github.com/aboutcode-org/scancode-toolkit
"
LICENSE="
	Apache-2.0
	CC-BY-4.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc full native"
REQUIRED_USE="
	dev? (
		doc
	)
"

# packageurl-python -> packageurl
# pdfminer.six -> pdfminer
# extractcode-7z -> extractcode_7z
RDEPEND+="
	>=dev-python/attrs-25.3.0[${PYTHON_USEDEP}]
	>=dev-python/banal-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.13.4[${PYTHON_USEDEP}]
	>=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/beartype-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/boolean-py-5.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2025.6.15[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.17.1[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.2.1[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/commoncode-32.3.0[${PYTHON_USEDEP}]
	>=dev-python/construct-2.10.70[${PYTHON_USEDEP}]
	>=dev-python/container-inspector-33.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-45.0.4[${PYTHON_USEDEP}]
	>=dev-python/debian-inspector-31.1.0[${PYTHON_USEDEP}]
	>=dev-python/dockerfile-parse-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/dparse2-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/extractcode-31.0.0[${PYTHON_USEDEP},full(+)]
	>=dev-python/extractcode_7z-16.5.210531[${PYTHON_USEDEP}]
	>=dev-python/extractcode-libarchive-3.5.1.210531[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.19[${PYTHON_USEDEP}]
	>=dev-python/fingerprints-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/ftfy-6.3.1[${PYTHON_USEDEP}]
	>=dev-python/future-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/gemfileparser2-0.9.4[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/idna-3.10[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-6.2.1[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/intbitset-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/javaproperties-0.8.2[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
	>=dev-python/jsonstreams-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/license-expression-30.4.3[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.4.0[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-10.7.0[${PYTHON_USEDEP}]
	>=dev-python/normality-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/packageurl-0.17.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-25.0[${PYTHON_USEDEP}]
	>=dev-python/packvers-21.5[${PYTHON_USEDEP}]
	>=dev-python/parameter-expansion-patched-0.3.1[${PYTHON_USEDEP}]
	>=app-text/pdfminer-20250506[${PYTHON_USEDEP}]
	>=dev-python/pefile-2024.8.26[${PYTHON_USEDEP}]
	>=dev-python/pip-requirements-parser-32.0.1[${PYTHON_USEDEP}]
	>=dev-python/pkginfo2-30.0.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/plugincode-32.0.0[${PYTHON_USEDEP}]
	>=dev-python/ply-3.11[${PYTHON_USEDEP}]
	>=dev-python/publicsuffix2-2.20191221[${PYTHON_USEDEP}]
	>=dev-python/pyahocorasick-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pycparser-2.22[${PYTHON_USEDEP}]
	>=dev-python/pygmars-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.13.0[${PYTHON_USEDEP}]
	>=dev-python/pymaven-patch-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.2.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/rdflib-7.1.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.4[${PYTHON_USEDEP}]
	>=dev-python/saneyaml-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/semantic-version-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-2.7[${PYTHON_USEDEP}]
	>=dev-python/spdx-tools-0.8.2[${PYTHON_USEDEP}]
	>=dev-python/text-unidecode-1.3[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/typecode-30.0.2[${PYTHON_USEDEP},full(+)]
	>=dev-python/typecode-libmagic-5.39.210531[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
	>=dev-python/uritools-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/urlpy-0.5[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.2.13[${PYTHON_USEDEP}]
	>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/xmltodict-0.14.2[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.23.0[${PYTHON_USEDEP}]
	app-arch/bzip2
	app-arch/xz-utils
	app-arch/zstd
	dev-db/sqlite:3
	dev-libs/libgcrypt
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/popt
	sys-devel/gcc[openmp]
	sys-libs/zlib
	full? (
		>=dev-python/extractcode-31.0.0[${PYTHON_USEDEP},full]
		>=dev-python/typecode-30.0.0[${PYTHON_USEDEP},full]
	)
	kernel_linux? (
		>=dev-python/packagedcode-msitools-0.101.210706[${PYTHON_USEDEP}]
		>=dev-python/regipy-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/rpm-inspector-rpm-4.16.1.3.210404[${PYTHON_USEDEP}]
		>=dev-python/go-inspector-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/rust-inspector-0.1.0[${PYTHON_USEDEP}]
	)
	native? (
		>=dev-python/cffi-1.17.1[${PYTHON_USEDEP}]
		>=dev-python/intbitset-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-5.4.0[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/pyahocorasick-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/aboutcode-toolkit-11.1.1[${PYTHON_USEDEP}]
		>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
		>=dev-python/bleach-5.0.1[${PYTHON_USEDEP}]
		>=dev-python/build-1.2.2_p1[${PYTHON_USEDEP}]
		>=dev-python/CommonMark-0.9.1[${PYTHON_USEDEP}]
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
		>=dev-python/pkginfo-1.12.1.2[${PYTHON_USEDEP}]
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
		>=dev-python/twine-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
		>=dev-python/vendorize-0.3.0[${PYTHON_USEDEP}]

		dev-util/ruff
		dev-python/pytest-rerunfailures
	)
	doc? (
		>=dev-python/sphinx-5.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-dark-mode-1.3.0[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "NOTICE" "README.rst" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

pkg_setup() {
ewarn "This ebuild is under construction"
	python_setup
}
