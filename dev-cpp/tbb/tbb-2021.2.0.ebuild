# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake flag-o-matic multilib-minimal python-single-r1 toolchain-funcs

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
# Clear distinction is made to prevent wrong hashing
VER_SCH="semver" # valid values (left column):
# marketing ~ YYYY_Un
# semver ~ YYYY.M.p
# live-snapshot ~ YYYY.M.m_pYYYYMMDD
#
# YYYY_Un == YYYY.M in later releases
#
# Details on versioning can be found in:
# https://github.com/oneapi-src/oneTBB/issues/143
if [[ "${VER_SCH}" == "marketing" ]] ; then
PV1="$(ver_cut 1)"
PV2="$(ver_cut 2)"
MY_PV="${PV1}_U${PV2}"
SRC_URI="
https://github.com/intel/${PN}/archive/refs/tags/${MY_PV}.tar.gz
	-> ${PN}-$(ver_cut 1-2 ${PV}).tar.gz"
elif [[ "${VER_SCH}" == "semver" ]] ; then
# always 3 periods in ${PV}
SRC_URI="
https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
SRC_URI="
https://github.com/intel/${PN}/archive/refs/heads/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
fi
LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE+=" -X debug doc -examples python +test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	X? ( examples )"
RDEPEND+="
	examples? (
		X? (
			x11-libs/libX11[${MULTILIB_USEDEP}]
			x11-libs/libXext[${MULTILIB_USEDEP}]
		)
	)
	python? ( ${PYTHON_DEPS} )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.1
	dev-util/patchelf
	doc? ( app-doc/doxygen[dot] )
	python? ( ${PYTHON_DEPS} )"
if [[ "${VER_SCH}" == "marketing" ]] ; then
S="${WORKDIR}/oneTBB-${MY_PV}"
elif [[ "${VER_SCH}" == "semver" ]] ; then
S="${WORKDIR}/oneTBB-${PV}"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
S="${WORKDIR}/oneTBB-${EGIT_COMMIT}"
fi
DOCS=( README.md )

pkg_setup()
{
	if use test ; then
		if [[ ${FEATURES} =~ test ]] ; then
			einfo "Testing enabled."
		else
			ewarn "Testing disabled.  Add FEATURES=test before ebuild."
		fi
	fi

	use python && python-single-r1_pkg_setup
	[[ ${FEATURES} =~ test ]] \
		&& use test \
		&& ver_test ${PV} -eq 2021.2.0 \
		&& ewarn "${PV} is expected to fail test"
}

multilib_src_configure() {
	cd "${BUILD_DIR}" || die

	sed -i -e "s|@CMAKE_CURRENT_SOURCE_DIR@|${S}|g" \
		"${S}/doc/Doxyfile.in" || die

	pushd "${S}/doc" || die
		doxygen -g Doxyfile-dev.in || die
		sed -i -e "s|My Project|${PN}|g" \
			-e "s|GENERATE_XML           = NO|GENERATE_XML           = YES|g" \
			-e "s|GENERATE_LATEX         = YES|GENERATE_LATEX         = NO|g" \
			-e "s|INPUT                  =|INPUT                  = ${S}/src/tbb ${S}/src/tbbbind ${S}/src/tbbmalloc ${S}/src/tbbmalloc_proxy|g" \
			-e "s|JAVADOC_AUTOBRIEF      = NO|JAVADOC_AUTOBRIEF      = YES|g" \
			-e "s|AUTOLINK_SUPPORT       = YES|AUTOLINK_SUPPORT       = NO|g" \
			-e "s|XML_OUTPUT             = xml|XML_OUTPUT             = doxyxml|g" \
			-e "s|MACRO_EXPANSION        = NO|MACRO_EXPANSION        = YES|g" \
			-e "s|PREDEFINED             =|PREDEFINED             = DOXYGEN=1|g" \
			Doxyfile-dev.in || die
	popd

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
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DCMAKE_C_COMPILER=${comp}
		-DCMAKE_CXX_COMPILER=${comp}
		-DTBB_EXAMPLES=$(usex examples)
		-DTBB_STRICT=OFF
		-DTBB_TEST=$(usex test)
		-DTBB4PY_BUILD=$(usex python)
	)
	if use examples ; then
		mycmakeargs+=(
			-DEXAMPLES_UI_MODE=$(usex X "x" "con")
		)
	fi
	cmake_src_configure
}

src_compile_pkg_config()
{
	# pc files are for debian and fedora compatibility
	# some deps use them
	cat <<-EOF > ${PN}.pc.template
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Cflags: -I\${includedir}
	EOF
	cp ${PN}.pc.template ${PN}.pc || die
	cat <<-EOF >> ${PN}.pc
		Libs: -L\${libdir} -ltbb
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc.pc || die
	cat <<-EOF >> ${PN}malloc.pc
		Libs: -L\${libdir} -ltbbmalloc
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc_proxy.pc || die
	cat <<-EOF >> ${PN}malloc_proxy.pc
		Libs: -L\${libdir} -ltbbmalloc_proxy
		Libs.private: -lrt
		Requires: tbbmalloc
	EOF
}

multilib_src_compile() {
	cmake_src_compile
	if use python ; then
		eninja python_build || die
	fi
	if use doc ; then
		pushd "${S}/doc" || die
			einfo "Generating documentation"
			if use test ; then
				doxygen Doxyfile.in || die
			fi
			doxygen Doxyfile-dev.in || die
		popd
	fi
	src_compile_pkg_config
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

multilib_src_test() {
	run_native_tests
	run_python_tests
}

src_install_pkgconfig()
{
	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins *.pc
}

multilib_src_install() {
	cmake_src_install
	src_install_pkgconfig
	if multilib_is_native_abi ; then
		if use doc ; then
			pushd "${S}" || die
				einstalldocs
				insinto /usr/share/${P}
				if use test ; then
					doins -r doc/test_spec
				fi
				doins -r doc/html
			popd
		fi
		if use examples ; then
			local examples_exe=(
				binpack
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
			built_demo_dir=$(find "${BUILD_DIR}" -name "*gentoo" -type d)
			pushd "${built_demo_dir}" || die
				doexe ${examples_exe[@]}
				if [[ -f cholesky ]] ; then
					doexe cholesky
				fi
			popd
			insinto /usr/share/doc/${PF}
			doins -r examples
			docompress -x "/usr/share/doc/${PF}/examples"
			pushd "${ED}/usr/share/${PF}/examples/build" || die
				for f in $(ls) ; do
					# Removed /var/tmp/portage/dev-cpp/...
					einfo "Removing rpath from ${f}"
					patchelf --remove-rpath "${f}" || die
				done
			popd
		fi
	fi
}
