# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils flag-o-matic multilib-minimal python-r1 static-libs toolchain-funcs

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
# Clear distinction is made to prevent wrong hashing
VER_SCH="semver" # valid values (left column):
# marketing ~ YYYY_Un
# semver ~ YYYY.m.p
# live-snapshot ~ YYYY.m.p_pYYYYMMDD
#
# YYYY_Un == YYYY.m in later releases
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86
~amd64-linux ~x86-linux"
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
			einfo \
"Testing enabled."
		else
			ewarn \
"Testing disabled.  Add FEATURES=test before ebuild."
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
	src_prepare_abi() {
		cd "${BUILD_DIR}" || die
		src_compile_stsh() {
			cd "${BUILD_DIR}" || die
			if use python ; then
				src_prepare_py() {
					cd "${BUILD_DIR}" || die
					if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
						SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}_${EPYTHON/./_}"
						CMAKE_USE_DIR="${BUILD_DIR}" \
						BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
						cmake-utils_src_prepare
						eapply "${FILESDIR}/tbb-2021.2.0-move-assert-definitions.patch"
						sed -i -e "s|MALLOC_UNIXLIKE_OVERLOAD_ENABLED __linux__|MALLOC_UNIXLIKE_OVERLOAD_ENABLED 0|g" \
							src/tbbmalloc_proxy/proxy.h || die
					else
						SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
						CMAKE_USE_DIR="${BUILD_DIR}" \
						BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
						cmake-utils_src_prepare
					fi
				}
				python_copy_sources
				python_foreach_impl src_prepare_py
			else
				if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
					CMAKE_USE_DIR="${BUILD_DIR}" \
					BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
					cmake-utils_src_prepare
					eapply "${FILESDIR}/tbb-2021.2.0-move-assert-definitions.patch"
					sed -i -e "s|MALLOC_UNIXLIKE_OVERLOAD_ENABLED __linux__|MALLOC_UNIXLIKE_OVERLOAD_ENABLED 0|g" \
						src/tbbmalloc_proxy/proxy.h || die
				else
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
					CMAKE_USE_DIR="${BUILD_DIR}" \
					BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
					cmake-utils_src_prepare
				fi
			fi
		}
		static-libs_copy_sources
		static-libs_foreach_impl src_compile_stsh
	}
	multilib_copy_sources
	multilib_foreach_abi src_prepare_abi
}

_src_configure() {
	cd "${BUILD_DIR}" || die

	sed -i -e "s|@CMAKE_CURRENT_SOURCE_DIR@|${S}|g" \
		"${S}/doc/Doxyfile.in" || die

	pushd "${S}/doc" || die
		doxygen -g Doxyfile-dev.in || die
		sed -i -e "s|My Project|${PN}|g" \
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


	filter-flags -fPIC -D__TBB_DYNAMIC_LOAD_ENABLED=*

	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DCMAKE_C_COMPILER=${comp}
		-DCMAKE_CXX_COMPILER=${comp}
		-DTBB_EXAMPLES=$(usex examples)
		-DTBB_STRICT=OFF
		-DTBB4PY_BUILD=$(usex python)
	)
	if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
		if use static-libs ; then
			append-cxxflags -fPIC
			append-cppflags -D__TBB_DYNAMIC_LOAD_ENABLED=0
		fi
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
			-DTBB_TEST=OFF
		)
	else
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=ON
			-DTBB_TEST=$(usex test)
		)
	fi
	if use examples ; then
		mycmakeargs+=(
			-DEXAMPLES_UI_MODE=$(usex X "x" "con")
		)
	fi
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	cmake-utils_src_configure
}

src_configure()
{
	src_configure_abi() {
		cd "${BUILD_DIR}" || die
		src_configure_stsh() {
			cd "${BUILD_DIR}" || die
			if use python ; then
				src_configure_py() {
					cd "${BUILD_DIR}" || die
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}_${EPYTHON/./_}"
					_src_configure
				}
				python_foreach_impl src_configure_py
			else
				SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
				_src_configure
			fi
		}
		static-libs_foreach_impl src_configure_stsh
	}
	multilib_foreach_abi src_configure_abi
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

_src_compile() {
	cd "${BUILD_DIR}" || die
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
	CMAKE_USE_DIR="${BUILD_DIR}" \
	cmake-utils_src_compile
	if use python ; then
		cd "${BUILD_DIR}" || die
		einfo "pwd="$(pwd)
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

src_compile()
{
	src_compile_abi() {
		cd "${BUILD_DIR}" || die
		src_compile_stsh() {
			cd "${BUILD_DIR}" || die
			if use python ; then
				src_compile_py() {
					cd "${BUILD_DIR}" || die
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}_${EPYTHON/./_}"
					_src_compile
				}
				python_foreach_impl src_compile_py
			else
				SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
				_src_compile
			fi
		}
		static-libs_foreach_impl src_compile_stsh
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
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
	CMAKE_USE_DIR="${BUILD_DIR}" \
	cmake-utils_src_test
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
	run_python_tests
}

src_test()
{
	src_test_abi() {
		cd "${BUILD_DIR}" || die
		src_test_stsh() {
			cd "${BUILD_DIR}" || die
			if use python ; then
				src_test_py() {
					cd "${BUILD_DIR}" || die
					if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
						ewarn "Skipping test for the static-libs USE flag."
					else
						SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}_${EPYTHON/./_}"
						_src_test
					fi
				}
			else
				if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
					ewarn "Skipping test for the static-libs USE flag."
				else
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
					_src_test
				fi
			fi
			python_foreach_impl src_test_py
		}
		static-libs_foreach_impl src_test_stsh
	}
	multilib_foreach_abi src_test_abi
}

src_install_pkgconfig()
{
	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins *.pc
}

_src_install() {
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
	CMAKE_USE_DIR="${BUILD_DIR}" \
	cmake-utils_src_install
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

src_install()
{
	src_install_abi() {
		cd "${BUILD_DIR}" || die
		src_install_stsh() {
			cd "${BUILD_DIR}" || die
			if use python ; then
				src_install_py() {
					cd "${BUILD_DIR}" || die
					SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}_${EPYTHON/./_}"
					_src_install
				}
				python_foreach_impl src_install_py
			else
				SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
				_src_install
			fi
		}
		static-libs_foreach_impl src_install_stsh
	}
	multilib_foreach_abi src_install_abi
}
