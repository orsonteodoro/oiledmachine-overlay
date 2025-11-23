# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PyAV"
MY_P="${MY_PN}-${PV}"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit cython check-compiler-switch distutils-r1 flag-o-matic

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
		>=media-video/ffmpeg-7.1.1:59.61.61[${PYTHON_SINGLE_USEDEP}]
		>=media-video/ffmpeg-7.1.1:0[${PYTHON_SINGLE_USEDEP}]
	)
	media-video/ffmpeg:=
"
# Cython relaxed
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cython-3.1.0_beta1[${PYTHON_USEDEP}]
		=dev-python/cython-3*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/setuptools-61[${PYTHON_USEDEP}]
		lint? (
			>=dev-python/mypy-1.15.0[${PYTHON_USEDEP}]
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
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
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
	cython_set_cython_slot "3"
	cython_python_configure
}

src_configure() {
	distutils-r1_src_configure
}

src_install() {
	distutils-r1_src_install

	# Multislot
	if has_version ">=media-video/ffmpeg-7.1.1:59.61.61" ; then
		local x
		for x in $(find "${ED}" -name "*.so") ; do
			if ldd "${x}" | grep -q -E -e "(libavutil.so|libavcodec.so)" ; then
einfo "Updating RPATH for ${x}"
				patchelf --add-rpath "/usr/lib/ffmpeg/59.61.61/$(get_libdir)" "${x}" || die
			fi
		done
	# else
	#	unislot
	fi
}
