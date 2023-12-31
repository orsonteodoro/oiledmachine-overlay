# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="oneTBB"
PV1="$(ver_cut 1)"
PV2="$(ver_cut 2)"
MY_PV="${PV1}_U${PV2}"

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic multilib-minimal python-r1 toolchain-funcs

DESCRIPTION="oneAPI Threading Building Blocks (oneTBB)"
HOMEPAGE="https://www.threadingbuildingblocks.org"
LICENSE="Apache-2.0"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux
~x86-linux
"

#
# Distinct archive filenames are required prevent wrong hashing.
#
VER_SCH="semver" # valid values (left column):
#
# marketing ~ YYYY_Un
# semver ~ YYYY.m.p
# live-snapshot ~ YYYY.m.p_pYYYYMMDD
#
# YYYY_Un == YYYY.m in later releases
#
# Details on versioning can be found in:
# https://github.com/oneapi-src/oneTBB/issues/143
#

if [[ "${VER_SCH}" == "marketing" ]] ; then
	SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz
	-> ${PN}-$(ver_cut 1-2 ${PV}).tar.gz
	"
elif [[ "${VER_SCH}" == "semver" ]] ; then
	SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
	"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
	SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/heads/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

SLOT_MAJOR="0"
SLOT="${SLOT_MAJOR}/${PV}"
# Upstream enables tests by default.
IUSE+=" -X debug doc -examples -python +tbbmalloc -test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	X? ( examples )
"
RDEPEND+="
	sys-apps/hwloc:=
	examples? (
		sci-libs/mkl[${MULTILIB_USEDEP}]
		X? (
			x11-libs/libX11[${MULTILIB_USEDEP}]
			x11-libs/libXext[${MULTILIB_USEDEP}]
		)
	)
	python? (
		${PYTHON_DEPS}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.1
	dev-util/patchelf
	doc? (
		app-doc/doxygen[dot]
	)
	python? (
		${PYTHON_DEPS}
	)
"

if [[ "${VER_SCH}" == "marketing" ]] ; then
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	S_BAK="${WORKDIR}/${MY_PN}-${MY_PV}"
elif [[ "${VER_SCH}" == "semver" ]] ; then
	S="${WORKDIR}/${MY_PN}-${PV}"
	S_BAK="${WORKDIR}/${MY_PN}-${PV}"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
	S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
	S_BAK="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
fi

DOCS=( README.md )
RESTRICT="mirror"
PATCHES=(
	# Should be in.. 2022?
	"${FILESDIR}"/${PN}-2021.5.0-musl-deepbind.patch
	# Need to verify this is in master
	"${FILESDIR}"/${PN}-2021.5.0-musl-mallinfo.patch
)

pkg_setup()
{
	if use test ; then
		if [[ ${FEATURES} =~ test ]] ; then
einfo
einfo "Testing enabled."
einfo
		else
ewarn
ewarn "Testing disabled.  Add FEATURES=test before ebuild."
ewarn
		fi
	fi

	use python && python_setup
	[[ ${FEATURES} =~ test ]] \
		&& use test \
		&& ver_test ${PV} -eq 2021.2.0 \
		&& ewarn "${PV} is expected to fail test"
}

src_prepare()
{
	cd "${S}" || die
	eapply "${FILESDIR}/tbb-2021.2.0-fix-missing-header-cholesky.patch"

	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare

	src_prepare_abi()
	{
		if use python ; then
			prepare_python_impl() {
				cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}" || die
			}
			python_foreach_impl prepare_python_impl
		else
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		fi
	}
	multilib_foreach_abi src_prepare_abi
}

_gen_doc_conf() {
	use doc || return
	pushd "${S}/doc" || die
		doxygen -g Doxyfile-dev.in || die
		sed -i -e "s|My Project|${MY_PN}|g" \
	-e "s|GENERATE_XML           = NO|GENERATE_XML           = YES|g" \
	-e "s|GENERATE_LATEX         = YES|GENERATE_LATEX         = NO|g" \
	-e "s|\
INPUT                  =|\
INPUT                  = ${S}/src/tbb ${S}/src/tbbbind ${S}/src/tbbmalloc \
${S}/src/tbbmalloc_proxy|g" \
	-e "s|JAVADOC_AUTOBRIEF      = NO|JAVADOC_AUTOBRIEF      = YES|g" \
	-e "s|AUTOLINK_SUPPORT       = YES|AUTOLINK_SUPPORT       = NO|g" \
	-e "s|XML_OUTPUT             = xml|XML_OUTPUT             = doxyxml|g" \
	-e "s|MACRO_EXPANSION        = NO|MACRO_EXPANSION        = YES|g" \
	-e "s|\
INCLUDE_PATH           =|\
INCLUDE_PATH           = ${S}/include/oneapi ${S}/include/tbb|g" \
			Doxyfile-dev.in || die
	popd
}

_src_configure() {
	sed -i -e "s|@CMAKE_CURRENT_SOURCE_DIR@|${S}|g" \
		"${S}/doc/Doxyfile.in" || die

	_gen_doc_conf

	local comp arch

	case ${MULTILIB_ABI_FLAG} in
		abi_x86_64) arch=x86_64 ;;
		abi_x86_32) arch=ia32 ;;
#		abi_ppc_64) arch=ppc64 ;;
#		abi_ppc_32) arch=ppc32 ;;
	esac

	case "$(tc-getCXX)" in
		*clang*) comp="clang" ;;
		*g++*) comp="gcc" ;;
		*ic*c) comp="icc" ;;
		*) die "compiler $(tc-getCXX) not supported by build system" ;;
	esac

	mycmakeargs=(
#		-DCMAKE_INSTALL_INCLUDEDIR="include/${MY_PN}/${SLOT_MAJOR}"
#		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/${MY_PN}/${SLOT_MAJOR}"
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DCMAKE_C_COMPILER=${comp}
		-DCMAKE_CXX_COMPILER=${comp}
		-DTBB_EXAMPLES=$(usex examples)
		-DTBB_STRICT=OFF
		-DTBB_TEST=$(usex test)
		-DTBBMALLOC_BUILD=$(usex tbbmalloc)
		-DTBB4PY_BUILD=$(multilib_native_usex python)
	)
	if use examples ; then
		mycmakeargs+=(
			-DEXAMPLES_UI_MODE=$(usex X "x" "con")
		)
	fi
	cmake_src_configure
}

src_configure()
{
	src_configure_abi() {
		if use python ; then
			src_configure_py() {
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}_build"
				cd "${CMAKE_USE_DIR}" || die
				_src_configure
			}
			python_foreach_impl src_configure_py
		else
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
			cd "${CMAKE_USE_DIR}" || die
			_src_configure
		fi
	}
	multilib_foreach_abi src_configure_abi
}

gen_pkg_config() {
	local c="${1}"
	local v="${SLOT_MAJOR}"

	# The pc files are for debian and fedora compatibility.
	# Some dependencies use them.

cat <<-EOF > ${PN}.pc.template
prefix=${EPREFIX}/usr
libdir=\${prefix}/$(get_libdir)
includedir=\${prefix}/include
Name: ${MY_PN}
Description: ${DESCRIPTION}
Version: ${PV}
URL: ${HOMEPAGE}
Cflags: -I\${includedir}
EOF

	cp ${PN}.pc.template ${PN}${c}.pc || die

cat <<-EOF >> ${PN}${c}.pc
Libs: -L\${libdir} -ltbb${c}
Libs.private: -lm -lrt
EOF

	cp ${PN}.pc.template ${PN}malloc${c}.pc || die

cat <<-EOF >> ${PN}malloc${c}.pc
Libs: -L\${libdir} -ltbbmalloc${c}
Libs.private: -lm -lrt
EOF

	cp ${PN}.pc.template ${PN}malloc_proxy${c}.pc || die

cat <<-EOF >> ${PN}malloc_proxy${c}.pc
Libs: -L\${libdir} -ltbbmalloc_proxy${c}
Libs.private: -lrt
Requires: tbbmalloc${c}
EOF

}

src_compile_pkg_config()
{
	cd "${BUILD_DIR}"
	[[ -f "${T}/pkg_config_generated_${ABI}" ]] && return
	gen_pkg_config ""
	touch "${T}/pkg_config_generated_${ABI}"
}

_src_compile() {
	cd "${CMAKE_USE_DIR}"
	cmake_src_compile
	if use python && [[ "${ABI}" == "${DEFAULT_ABI}" ]] ; then
		cd "${BUILD_DIR}"
		eninja python_build || die
	fi
	if use doc ; then
		pushd "${S}/doc" || die
			einfo "Generating documentation"
			use test && doxygen Doxyfile.in || die
			doxygen Doxyfile-dev.in || die
		popd
	fi
	src_compile_pkg_config
}

src_compile()
{
	src_compile_abi() {
		if use python ; then
			src_compile_py() {
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}_build"
				cd "${CMAKE_USE_DIR}" || die
				_src_compile
			}
			python_foreach_impl src_compile_py
		else
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
			cd "${CMAKE_USE_DIR}" || die
			_src_compile
		fi
	}
	multilib_foreach_abi src_compile_abi
}

run_native_tests()
{
# Results for 2021.2.0 (native)
#
#99% tests passed, 1 tests failed out of 129
#
#Total Test time (real) =  98.14 sec
#
#The following tests FAILED:
#	 55 - test_semaphore (Child aborted)
	cmake_src_test
}

run_python_tests()
{
	if use python ; then
# Results for 2021.2.0 (python bindings)
#    Start 130: python_test
#1/1 Test #130: python_test ......................   Passed   10.49 sec
#
#100% tests passed, 0 tests failed out of 1
#
#Total Test time (real) =  10.55 sec
		ctest -R python_test --output-on-failure || die
	fi
}

_src_test() {
	run_native_tests
	if use python && [[ "${ABI}" == "${DEFAULT_ABI}" ]] ; then
		run_python_tests
	fi
}

src_test()
{
	src_test_abi() {
		if use python ; then
			src_test_py() {
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}_build"
				cd "${BUILD_DIR}" || die
				_src_test
			}
			python_foreach_impl src_test_py
		else
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
			cd "${BUILD_DIR}" || die
			_src_test
		fi
	}
	multilib_foreach_abi src_test_abi
}

src_install_pkgconfig()
{
	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	[[ -f tbb-${SLOT_MAJOR}.pc ]] && doins *.pc
}

_install_examples() {
	local examples_exe=(
		binpack
		cholesky
		convex_hull_bench
		convex_hull_sample
		count_strings
		dining_philosophers
		fgbzip2
		fibonacci
		fractal
		game_of_life
		logic_sim
		parallel_preorder
		polygon_overlay
		primes
		seismic
		shortpath
		som
		square
		sub_string_finder_extended
		sub_string_finder_pretty
		sub_string_finder_simple
		sudoku
		tachyon
	)
	exeinto /usr/share/${PF}/examples/build
	built_demo_dir=$(find "${BUILD_DIR}" -name "*gentoo" \
		-type d)
	pushd "${built_demo_dir}" || die
		doexe ${examples_exe[@]}
		if [[ -f cholesky ]] ; then
			doexe cholesky
		fi
	popd
	insinto /usr/share/doc/${PF}
	doins -r examples
	find "${ED}/usr/share/doc/${PF}/examples/" -name "*.o" -delete || die
	docompress -x "/usr/share/doc/${PF}/examples"
}

_install_docs() {
	pushd "${S}" || die
		einstalldocs
		insinto /usr/share/${P}
		if use test ; then
			doins -r doc/test_spec
		fi
		doins -r doc/html
	popd
}

_src_install() {

	cmake_src_install
	src_install_pkgconfig
	if multilib_is_native_abi ; then
		use doc && _install_docs
		use examples && _install_examples
	fi
}

src_install()
{
	src_install_abi() {
		if use python ; then
			src_install_py() {
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${EPYTHON}_build"
				cd "${BUILD_DIR}" || die
				_src_install
			}
			python_foreach_impl src_install_py
		else
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
			cd "${BUILD_DIR}" || die
			_src_install
		fi
		multilib_check_headers
	}
	multilib_foreach_abi src_install_abi
}

pkg_postinst()
{
einfo
einfo "Packages that depend on ${CATEGORY}/${PN}:${SLOT_MAJOR} must"
einfo "either set the RPATH or add a LD_LIBRARY_PATH wrapper to use"
einfo "this slot.  You must verify that the linking is proper via ldd."
einfo
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot
