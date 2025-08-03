# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFFI_PV="1.0.0"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} "pypy3" )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/libvips/pyvips/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python bindings for libvips"
HOMEPAGE="https://github.com/libvips/pyvips"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc sdist test tox"
RDEPEND+="
	>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.5[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pyperf[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	!test? (
		media-libs/vips
	)
	sdist? (
		dev-python/build
	)
	test? (
		dev-python/pyperf[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		media-libs/vips[jpeg,png]
	)
	tox? (
		dev-python/tox[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "doc"
distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
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
