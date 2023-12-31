# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream only tests up to 3.8

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/duanhongyi/pyv4l2.git"
	EGIT_BRANCH="master"
	inherit git-r3
	IUSE+=" fallback-commit"
fi

DESCRIPTION="Simple v4l2 lib for python3"
HOMEPAGE="https://github.com/duanhongyi/pyv4l2"
LICENSE="LGPL-3"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Live ebuilds/snapshots do not gets KEYWORDS
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" examples"
REQUIRED_USE+="
"
RDEPEND+="
	media-libs/libv4l
	examples? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-python/cython-0.18[${PYTHON_USEDEP}]
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/pyv4l2-9999_p20190515-select-cython-by-envvar.patch"
)

pkg_setup() {
	export EUSE_CYTHON="True"
}

unpack_live() {
	use fallback-commit && EGIT_COMMIT="f12f0b3a14e44852f0a0d13ab561cbcae8b5e0c3"
	git-r3_fetch
	git-r3_checkout
	grep -E -e "__version__ = '$(ver_cut 1-3 ${PV})'" \
		"${S}/pyv4l2/__init__.py" \
		|| die "QA:  Bump version"
}

src_unpack() {
	unpack_live
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
