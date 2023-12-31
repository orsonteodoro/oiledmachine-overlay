# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="python binding for libvips using cffi"
HOMEPAGE="https://github.com/libvips/pyvips"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
CDEPEND="
	>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${CDEPEND}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pyperf[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-flake8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	!test? (
		media-libs/vips
	)
	test? (
		media-libs/vips[jpeg,png]
	)
"
SRC_URI="
https://github.com/libvips/pyvips/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "doc"
distutils_enable_tests "pytest"

pkg_setup() {
	if use test ; then
		if ! has_version "media-libs/vips" ; then
eerror
eerror "Test require media-libs/vips be installed"
eerror
			die
		fi
		if has_version "media-libs/vips[-jpeg]" ; then
eerror
eerror "Test require media-libs/vips[jpeg]"
eerror
			die
		fi
		if has_version "media-libs/vips[-png]" ; then
eerror
eerror "Test require media-libs/vips[png]"
eerror
			die
		fi
	fi
}
