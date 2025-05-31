# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PyAV"
MY_P="${MY_PN}-${PV}"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
PYTHON_COMPAT=( "python3_"{10..13} )

inherit check-compiler-switch distutils-r1 flag-o-matic

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
ebuild_revision_3
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
		>=dev-python/cython-3.1.0_beta1:3.1[${PYTHON_USEDEP}]
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
	python_setup
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

check_cython() {
	if ! which cython ; then
eerror
eerror "Missing symlink.  Use \`eselect cython set 3.1\` to continue and make"
eerror "sure that dev-python/cython:3.1 is installed."
eerror
		die
	fi
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|b|_beta|g" -e "s|a|_alpha|g" -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="3.1"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
eerror "Actual cython slot:  ${actual_cython_slot}"
eerror "Expected cython slot:  ${expected_cython_slot}"
eerror
		die
	fi
}

src_configure() {
	check_cython
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
