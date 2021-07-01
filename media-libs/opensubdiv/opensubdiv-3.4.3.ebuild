# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake
PYTHON_COMPAT=( python2_7 )

inherit cmake flag-o-matic python-utils-r1 toolchain-funcs

MY_PV="$(ver_rs "1-3" '_')"
DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="https://graphics.pixar.com/opensubdiv/docs/intro.html"
SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

# Modfied Apache-2.0 license, where section 6 has been replaced.
# See for example CMakeLists.txt for details.
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="cuda doc examples opencl openmp ptex tbb test tutorials"

ONETBB_SLOT="12"
RDEPEND="
	${PYTHON_DEPS}
	media-libs/glew:=
	media-libs/glfw:=
	x11-libs/libXinerama
	cuda? ( dev-util/nvidia-cuda-toolkit:* )
	opencl? ( virtual/opencl )
	ptex? ( media-libs/ptex )
"
DEPEND="
	${RDEPEND}
	tbb? (
		<dev-cpp/tbb-2021:0=
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
	)
"
BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/docutils
	)
	cuda? ( <sys-devel/gcc-9[cxx] )
"

S="${WORKDIR}/OpenSubdiv-${MY_PV}"

PATCHES_=(
	"${FILESDIR}/${PN}-3.3.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${PN}-3.3.0-add-CUDA9-compatibility.patch"
	"${FILESDIR}/${PN}-3.4.0-0001-documentation-CMakeLists.txt-force-python2.patch"
	"${FILESDIR}/${P}-install-tutorials-into-bin.patch"
)

RESTRICT="!test? ( test )"

pkg_pretend() {
	if use cuda; then
		[[ $(gcc-major-version) -gt 8 ]] && \
		eerror "USE=cuda requires gcc < 9. Run gcc-config to switch your default compiler" && \
		die "Need gcc version earlier than 9"
	fi
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	eapply ${PATCHES_[@]}
	if use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/${PN}-3.4.3-findtbb-onetbb-changes.patch"
		eapply "${FILESDIR}/${PN}-3.4.3-use-task-arena.patch"
	fi
	cmake_src_prepare
}

src_configure() {
	# GLTESTS are disabled as portage is unable to open a display during test phase
	local mycmakeargs=(
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DNO_CLEW=ON
		-DNO_CUDA=$(usex !cuda)
		-DNO_DOC=$(usex !doc)
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_GLTESTS=ON
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_PTEX=$(usex !ptex)
		-DNO_REGRESSION=$(usex !test)
		-DNO_TBB=$(usex !tbb)
		-DNO_TESTS=$(usex !test)
		-DNO_TUTORIALS=$(usex !tutorials)
	)

	if use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="/usr/include/oneTBB/${ONETBB_SLOT}"
			-DTBB_LIBRARY_PATH="/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}"
		)
	fi

	append-cxxflags -DUSE_ONETBB

	# fails with building cuda kernels when using multiple jobs
	export MAKEOPTS="-j1"
	cmake_src_configure
}

src_test() {
	# Version tested: 3.4.3
	# Results dated Wed Jun 30 07:27:52 PM PDT 2021 (1625106472)

#ctest -j 1 --test-load 999
#Test project /var/tmp/portage/media-libs/opensubdiv-3.4.3/work/opensubdiv-3.4.3_build
#    Start 1: far_regression
#1/2 Test #1: far_regression ...................   Passed    4.31 sec
#    Start 2: far_perf
#2/2 Test #2: far_perf .........................   Passed    4.40 sec
#
#100% tests passed, 0 tests failed out of 2
#
#Total Test time (real) =   8.73 sec
# * Tests succeeded.

	cmake_src_test
}

src_install() {
	cmake_src_install
	if use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}
