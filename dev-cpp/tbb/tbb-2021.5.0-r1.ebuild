# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils flag-o-matic multilib-minimal python-r1 toolchain-funcs

DESCRIPTION="oneAPI Threading Building Blocks (oneTBB)"
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
MY_PN="oneTBB"
if [[ "${VER_SCH}" == "marketing" ]] ; then
PV1="$(ver_cut 1)"
PV2="$(ver_cut 2)"
MY_PV="${PV1}_U${PV2}"
SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz
	-> ${PN}-$(ver_cut 1-2 ${PV}).tar.gz"
elif [[ "${VER_SCH}" == "semver" ]] ; then
# always 3 periods in ${PV}
SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
SRC_URI="
https://github.com/oneapi-src/${MY_PN}/archive/refs/heads/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
fi
LICENSE="Apache-2.0"
SLOT_MAJOR="12" # Same as __TBB_BINARY_VERSION in include/oneapi/tbb/version.h or the M in libtbb.so.M.m
SLOT="${SLOT_MAJOR}/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86
~amd64-linux ~x86-linux"
IUSE+=" -X debug doc -examples -python +tbbmalloc +test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	X? ( examples )"
RDEPEND+="
	sys-apps/hwloc:=
	examples? (
		sci-libs/mkl[${MULTILIB_USEDEP}]
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
S="${WORKDIR}/${MY_PN}-${MY_PV}"
elif [[ "${VER_SCH}" == "semver" ]] ; then
S="${WORKDIR}/${MY_PN}-${PV}"
elif [[ "${VER_SCH}" == "live-snapshot" ]] ; then
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
fi
DOCS=( README.md )
RESTRICT="mirror"
PATCHES=(
	# should be in.. 2022?
	"${FILESDIR}"/${PN}-2021.4.0-lto.patch
	"${FILESDIR}"/${PN}-2021.5.0-musl-deepbind.patch
	# need to verify this is in master
	"${FILESDIR}"/${PN}-2021.5.0-musl-mallinfo.patch
)

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
	eapply "${FILESDIR}/tbb-2021.2.0-fix-missing-header-cholesky.patch"
	cmake-utils_src_prepare

	src_prepare_abi() {
		cd "${BUILD_DIR}" || die
		if use python ; then
			python_copy_sources
		fi
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
		-DCMAKE_INSTALL_INCLUDEDIR="include/${MY_PN}/${SLOT_MAJOR}"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/${MY_PN}/${SLOT_MAJOR}"
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
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	cmake-utils_src_configure
}

src_configure()
{
	src_configure_abi() {
		cd "${BUILD_DIR}" || die
		if use python ; then
			src_configure_py() {
				cd "${BUILD_DIR}" || die
				SUFFIX="_${ABI}_${EPYTHON/./_}"
				_src_configure
			}
			python_foreach_impl src_configure_py
		else
			SUFFIX="_${ABI}"
			_src_configure
		fi
	}
	multilib_foreach_abi src_configure_abi
}

gen_pkg_config() {
	local c="${1}"
	local v="${SLOT_MAJOR}"
	# pc files are for debian and fedora compatibility
	# some deps use them
	cat <<-EOF > ${PN}.pc.template
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)/${MY_PN}/${SLOT_MAJOR}
		includedir=\${prefix}/include/${MY_PN}/${SLOT_MAJOR}
		Name: ${MY_PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Cflags: -I\${includedir}
	EOF
	cp ${PN}.pc.template ${PN}${c}-${v}.pc || die
	cat <<-EOF >> ${PN}${c}-${v}.pc
		Libs: -L\${libdir} -ltbb${c}
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc${c}-${v}.pc || die
	cat <<-EOF >> ${PN}malloc${c}-${v}.pc
		Libs: -L\${libdir} -ltbbmalloc${c}
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc_proxy${c}-${v}.pc || die
	cat <<-EOF >> ${PN}malloc_proxy${c}-${v}.pc
		Libs: -L\${libdir} -ltbbmalloc_proxy${c}
		Libs.private: -lrt
		Requires: tbbmalloc${c}
	EOF
}

src_compile_pkg_config()
{
	[[ -f "${T}/pkg_config_generated_${ABI}" ]] && return
	gen_pkg_config ""
	touch "${T}/pkg_config_generated_${ABI}"
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
		if use python ; then
			src_compile_py() {
				cd "${BUILD_DIR}" || die
				SUFFIX="_${ABI}_${EPYTHON/./_}"
				_src_compile
			}
			python_foreach_impl src_compile_py
		else
			SUFFIX="_${ABI}"
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
		if use python ; then
			src_test_py() {
				cd "${BUILD_DIR}" || die
				SUFFIX="_${ABI}_${EPYTHON/./_}"
				_src_test
			}
		else
			SUFFIX="_${ABI}"
			_src_test
		fi
		python_foreach_impl src_test_py
	}
	multilib_foreach_abi src_test_abi
}

src_install_pkgconfig()
{
	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	[[ -f tbb-${SLOT_MAJOR}.pc ]] && doins *.pc
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
		fi
	fi
	sed -i -e "s|/include|/include/${MY_PN}/${SLOT_MAJOR}|g" \
		"${ED}/usr/$(get_libdir)/${MY_PN}/${SLOT_MAJOR}/cmake/TBB/TBBTargets.cmake" || die
}

src_install()
{
	src_install_abi() {
		cd "${BUILD_DIR}" || die
		if use python ; then
			src_install_py() {
				cd "${BUILD_DIR}" || die
				SUFFIX="_${ABI}_${EPYTHON/./_}"
				_src_install
			}
			python_foreach_impl src_install_py
		else
			SUFFIX="_${ABI}"
			_src_install
		fi
	}
	multilib_foreach_abi src_install_abi

	# Change RPATHS for python .so files and examples matching ABI
	for f in $(find "${ED}") ; do
		test -L "${f}" && continue
		if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
			local old_rpath
			einfo "Old unsanitized rpath for ${f}:"
			local old_rpath=$(patchelf --print-rpath "${f}")
			echo -e "${old_rpath}"
			einfo "Old sanitized rpath for ${f}:"
			local old_rpath=$(echo "${old_rpath}" \
				| sed -E -e "s|/var/tmp[^:]+||g" -e "s|^:||g" -e "s|:$||g")
			echo -e "${old_rpath}"
			einfo "Setting rpath for ${f}:"
			local a_dl=$(ldd "${f}" 2>/dev/null | grep "libdl.so" | cut -f 2 -d "/")
			local a_libc=$(ldd "${f}" 2>/dev/null | grep "libc.so" | cut -f 2 -d "/")
			if (( ${#a_dl} > 0 )) ; then
				if (( ${#old_rpath} == 0 )) ; then
					patchelf --set-rpath "/usr/${a_dl}/oneTBB/${SLOT_MAJOR}" \
						"${f}" || die
				else
					patchelf --set-rpath "${old_rpath}:/usr/${a_dl}/oneTBB/${SLOT_MAJOR}" \
						"${f}" || die
				fi
			elif (( ${#a_libc} > 0 )) ; then
				if (( ${#old_rpath} == 0 )) ; then
					patchelf --set-rpath "/usr/${a_libc}/oneTBB/${SLOT_MAJOR}" \
						"${f}" || die
				else
					patchelf --set-rpath "${old_rpath}:/usr/${a_libc}/oneTBB/${SLOT_MAJOR}" \
						"${f}" || die
				fi
			fi
			einfo "New rpath:"
			patchelf --print-rpath "${f}"
			echo
		fi
	done
}

pkg_postinst()
{
	einfo \
"Packages that depend on ${CATEGORY}/${PN}:${SLOT_MAJOR} must either set the\n\
RPATH or add a LD_LIBRARY_PATH wrapper to use ${MY_PN} instead of legacy TBB.\n\
You must verify that the linking is proper via ldd."
}
