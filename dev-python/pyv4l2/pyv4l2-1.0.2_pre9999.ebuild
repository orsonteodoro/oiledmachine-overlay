# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U16

CYTHON_SLOT="0.29"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" ) # Upstream only tests up to 3.8

inherit cython distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/duanhongyi/pyv4l2.git"
	EGIT_BRANCH="master"
	FALLBACK_COMMIT="f12f0b3a14e44852f0a0d13ab561cbcae8b5e0c3" # May 15, 2019
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="FIXME"
fi

DESCRIPTION="A simple Video4Linux2 (v4l2) library for Python"
HOMEPAGE="https://github.com/duanhongyi/pyv4l2"
LICENSE="
	BSD
	LGPL-3
"
# LICENSE - LGPL-3
# setup.py - BSD in classifiers section of https://github.com/duanhongyi/pyv4l2/blob/master/setup.py#L43
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
examples
ebuild_revision_1
"
REQUIRED_USE+="
"
RDEPEND+="
	media-libs/libv4l
	examples? (
		dev-python/numpy[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-python/cython-0.18:${CYTHON_SLOT}[${PYTHON_USEDEP}]
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/pyv4l2-9999_p20190515-select-cython-by-envvar.patch"
)

pkg_setup() {
	export EUSE_CYTHON="True"
	python_setup
}

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	grep -E -e "__version__ = '$(ver_cut 1-3 ${PV})'" \
		"${S}/pyv4l2/__init__.py" \
		|| die "QA:  Bump version"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
