# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PyAV"
MY_P="${MY_PN}-${PV}"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_8[@]}"
)

inherit cython check-compiler-switch distutils-r1 flag-o-matic

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/PyAV-Org/PyAV/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Pythonic bindings for FFmpeg's libraries."
HOMEPAGE="
	https://github.com/PyAV-Org/PyAV
	https://pypi.org/project/av/
"
LICENSE="BSD"
SLOT="0"
IUSE="
lint test
ebuild_revision_6
"
RESTRICT="
	!test? (
		test
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "README.md" )
RDEPEND="
	!dev-python/ha-av
	|| (
		media-video/ffmpeg:60.62.62[${PYTHON_SINGLE_USEDEP}]
		media-video/ffmpeg:0/60.62.62[${PYTHON_SINGLE_USEDEP}]
	)
	media-video/ffmpeg:=
"
# Cython relaxed
BDEPEND="
	$(python_gen_cond_dep '
		=dev-python/cython-3.1*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/setuptools-77.0[${PYTHON_USEDEP}]
		lint? (
			>=dev-python/mypy-1.16.1[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/ruff[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/cython[${PYTHON_USEDEP}]
			dev-python/cython:=
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		)
	')
	sys-devel/gcc
	virtual/pkgconfig
	dev-util/patchutils
"

distutils_enable_tests "pytest"

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

python_configure() {
	cython_set_cython_slot "3.1"
	cython_python_configure
	ffmpeg_python_configure
}

src_configure() {
	distutils-r1_src_configure
}

src_install() {
	distutils-r1_src_install
}
