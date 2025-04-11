# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PyAV"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( "python3_"{10..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 flag-o-matic

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/PyAV-Org/PyAV/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Pythonic bindings for FFmpeg's libraries."
HOMEPAGE="https://github.com/PyAV-Org/PyAV https://pypi.org/project/av/"
LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "README.md" )
RDEPEND="
	!dev-python/ha-av
	$(python_gen_cond_dep '
		dev-python/ha-ffmpeg[${PYTHON_USEDEP}]
	')
	|| (
		>=media-video/ffmpeg-7.1.1:59.61.61[${PYTHON_SINGLE_USEDEP}]
		>=media-video/ffmpeg-7.1.1:0[${PYTHON_SINGLE_USEDEP}]
	)
	media-video/ffmpeg:=
"
BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/cython-3.1.0[${PYTHON_USEDEP}]
			<dev-python/cython-4[${PYTHON_USEDEP}]
		)
		>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	')
	virtual/pkg-config
	sys-devel/gcc
"

distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
}

src_configure() {
	local cython_pv=$(cython --version | cut -f 3 -d " ")
einfo "Cython version:  ${cython_pv}"
	if ver_test "${cython_pv%%.*}" -ne "3" ; then
eerror "Use eselect cython to switch to cython 3."
		die
	fi
	distutils-r1_src_configure
}
