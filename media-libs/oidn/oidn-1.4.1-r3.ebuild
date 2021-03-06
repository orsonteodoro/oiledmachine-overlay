# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils eutils flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Intel(R) Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"
KEYWORDS="~amd64"
LICENSE="Apache-2.0"
# MKL_DNN is oneDNN 1.6.2 with additional custom commits.
MKL_DNN_COMMIT="eb3e9670053192258d5a66f61486e3cfe25618b3"
OIDN_WEIGHTS_COMMIT="a34b7641349c5a79e46a617d61709c35df5d6c28"
ORG_GH="https://github.com/OpenImageDenoise"
SLOT="0/${PV}"
IUSE+=" +apps +built-in-weights +clang doc disable-sse41-check gcc icc openimageio"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	^^ ( clang gcc icc )"
# Clang is more smoother multitask-wise
# c++11 minimal
MIN_CLANG_V="3.3"
MIN_GCC_V="4.8.1"
MIN_ICC_V="17.0" # 15.0 has c++11 support, but project only supports 17
# SSE4.1 hardware release in 2008
# See scripts/build.py for release versioning
CDEPEND=" ${PYTHON_DEPS}"
ONETBB_SLOT="12"
DEPEND+=" ${CDEPEND}
	|| (
		<dev-cpp/tbb-2021:0=
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
	)
	virtual/libc
	openimageio? ( media-libs/openimageio )"
RDEPEND+=" ${DEPEND}"
CLANG_DEPENDS="
	(
		sys-devel/clang:10
		sys-devel/llvm:10
		=sys-devel/clang-runtime-10*
		>=sys-devel/lld-10
	)
	(
		sys-devel/clang:11
		sys-devel/llvm:11
		=sys-devel/clang-runtime-11*
		>=sys-devel/lld-11
	)
	(
		sys-devel/clang:12
		sys-devel/llvm:12
		=sys-devel/clang-runtime-12*
		>=sys-devel/lld-12
	)
	(
		sys-devel/clang:13
		sys-devel/llvm:13
		=sys-devel/clang-runtime-13*
		>=sys-devel/lld-13
	)"
BDEPEND+=" ${CDEPEND}
	|| (
		clang? (
			|| (
				${CLANG_DEPENDS}
			)
		)
		gcc? ( >=sys-devel/gcc-${MIN_GCC_V} )
		icc? ( >=dev-lang/icc-${MIN_ICC_V} )
	)
	>=dev-lang/ispc-1.15.0
	>=dev-util/cmake-3.1"
if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${ORG_GH}/oidn.git"
	EGIT_BRANCH="master"
else
	SRC_URI="
${ORG_GH}/${PN}/releases/download/v${PV}/${P}.src.tar.gz
	-> ${P}.tar.gz
${ORG_GH}/mkl-dnn/archive/${MKL_DNN_COMMIT}.tar.gz
	-> ${PN}-mkl-dnn-${MKL_DNN_COMMIT:0:7}.tar.gz
built-in-weights? (
${ORG_GH}/oidn-weights/archive/${OIDN_WEIGHTS_COMMIT}.tar.gz
	-> ${PN}-weights-${OIDN_WEIGHTS_COMMIT:0:7}.tar.gz )"
fi
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md readme.pdf )
PATCHES_=(
	"${FILESDIR}/${PN}-1.4.1-findtbb-print-paths.patch"
)

pkg_setup() {
	if [[ ! -f /proc/cpuinfo ]] ; then
		die "Cannot find /proc/cpuinfo"
	fi
	if ! use disable-sse41-check ; then
		if ! grep -F -e "sse4_1" /proc/cpuinfo ; then
			die \
"You need SSE4.1 to use this product.  Add disable-sse41-check to the USE\n\
flag to build and emerge anyways."
		fi
	fi
	python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/mkl-dnn" || die
	ln -s "${WORKDIR}/mkl-dnn-${MKL_DNN_COMMIT}" "${S}/mkl-dnn" || die
	if use built-in-weights ; then
		ln -s "${WORKDIR}/oidn-weights-${OIDN_WEIGHTS_COMMIT}" \
			"${S}/weights" || die
	else
		rm -rf "${WORKDIR}/oidn-weights-${OIDN_WEIGHTS_COMMIT}" || die
	fi
}

src_prepare() {
	eapply ${PATCHES_[@]}
	if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/${PN}-1.4.1-findtbb-alt-lib-path.patch"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=()
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
	einfo "CHOST=${CHOST}"
	if use clang ; then
		CC=clang
		CXX=clang++
	elif use gcc ; then
		CC=gcc
		CXX=g++
	elif use icc ; then
		CC=icc
		CXX=icpc
	fi
	local gcc_v
	local target_v=""

	# gcc flags that clang++ dislikes:
	filter-flags \
		-fopt-info* \
		-frename-registers

	if use gcc && \
	ls /usr/${CHOST}/gcc-bin/*/g++ 2>/dev/null 1>/dev/null ; then
		# GCC 9.3.0 will freeze indefinitely if -jN,
		# where N is number of cores

		# g++ 9.3.0 (gentoo latest stable as of 20200712) with -j1 still doesn't work:
		# FAILED: CMakeFiles/OpenImageDenoise.dir/weights/rt_ldr.cpp.o
		# g++: fatal error: Killed signal terminated program cc1plus

		# g++ 7.5.0 works
		V=$(ls /usr/${CHOST}/gcc-bin/ | sort -rV \
			| tr "\n"  " " | tr " " "\n")
		for v in ${V} ; do
			einfo "Checking ${v}"
			export CC="/usr/${CHOST}/gcc-bin/${v}/gcc"
			export CXX="/usr/${CHOST}/gcc-bin/${v}/g++"
			cc_v=$(gcc-version)
			if ver_test $(ver_cut 1-3 ${v}) -eq 9.3.0 ; then
				continue
			elif ver_test ${cc_v} -ne 7.5.0 && ver_test ${cc_v} -ge ${MIN_GCC_V} ; then
				if \
[[ -n "${OIDN_I_PROMISE_TO_SAVE_MY_DATA_BEFORE_COMPILING_WITH_UNTESTED_GCC}" \
&& "${OIDN_I_PROMISE_TO_SAVE_MY_DATA_BEFORE_COMPILING_WITH_UNTESTED_GCC^^}" == "AGREE" ]]
				then
					target_v="${v}"
					break
				else
					die \
"\n\
This package may be problematic with GCC especially 9.3.0 and cause an\n\
indefinite freeze when compiling.  It's recommended to use the clang\n\
USE flag instead, but you may proceed by setting\n\
\n\
  OIDN_I_PROMISE_TO_SAVE_MY_DATA_BEFORE_COMPILING_WITH_UNTESTED_GCC=\"AGREE\"\n\
\n\
as a per-package environmental variable or in front of emerge command\n\
to continue.\n
\n"
				fi
			elif ver_test ${cc_v} -eq 7.5.0 ; then
				target_v="${v}"
				break
			fi
		done
		if [[ -z "${target_v}" ]] ; then
			die "You need >=sys-devel/gcc-${MIN_GCC_V} to continue."
		fi
		cc_v=$(gcc-version)
		einfo "Falling back to gcc ${target_v}"
		mycmakeargs+=(
		-DCMAKE_CXX_COMPILER="/usr/${CHOST}/gcc-bin/${target_v}/g++"
		-DCMAKE_C_COMPILER="/usr/${CHOST}/gcc-bin/${target_v}/gcc"
		)
	elif use clang \
	&& ls /usr/lib/llvm/*/bin/clang 2>/dev/null 1>/dev/null ; then
		for v in $(ls /usr/lib/llvm/ | tr "\n" " " \
				| tr " " "\n" | sort -rV) ; do
			einfo "Checking ${v}"
			[[ "${v}" == "roc" ]] && continue
			if [[ -f "/usr/lib/llvm/${v}/bin/clang" ]] ; then
				export CC="/usr/lib/llvm/${v}/bin/clang"
				export CXX="/usr/lib/llvm/${v}/bin/clang++"
				cc_v=$(clang-version)
				if ver_test ${cc_v} -lt ${MIN_CLANG_V} ; then
					continue
				else
					target_v="${v}"
					break
				fi
			fi
		done
		if [[ -z "${target_v}" ]] ; then
			die "You need >=sys-devel/clang-${MIN_CLANG_V} to continue."
		fi
		cc_v=$(gcc-version)
		einfo "Falling back to clang ${target_v}"
		mycmakeargs+=(
		-DCMAKE_CXX_COMPILER="/usr/lib/llvm/${target_v}/bin/clang++"
		-DCMAKE_C_COMPILER="/usr/lib/llvm/${target_v}/bin/clang"
		)
	elif use icc \
	&& has_version '>=sys-devel/icc-${MIN_ICC_V}' ; then
		if [[ -z "${OIDN_ICPC_CXX_PATH}" ]] ; then
			die \
"You must set OIDN_ICPC_CXX_PATH to the absolute path to icpc without EROOT."
		fi
		if [[ -z "${OIDN_ICC_C_PATH}" ]] ; then
			die \
"You must set OIDN_ICC_C_PATH to the absolute path to icc without EROOT."
		fi
		if [[ ! -f "/${OIDN_ICPC_CXX_PATH}" ]] ; then
			die \
"Cannot find${OIDN_ICPC_CXX_PATH}."
		fi
		if [[ ! -f "/${OIDN_ICC_C_PATH}" ]] ; then
			die \
"Cannot find${OIDN_ICC_CXX_PATH}."
		fi
		local cxx_v=$("/${OIDN_ICPC_CXX_PATH}" --version \
				| head -n 1 | cut -f 3 -d " ")
		einfo "Falling back to icpc ${cc_v}"
		if ver_test ${cxx_v} -lt ${MIN_ICC_V} ; then
			die \
"icpc version ${cxx_v} not supported"
		fi
		local cc_v=$("/${OIDN_ICC_C_PATH}" --version \
				| head -n 1 | cut -f 3 -d " ")
		if ver_test ${cc_v} -lt ${MIN_ICC_V} ; then
			die \
"icc version ${cc_v} not supported"
		fi
		mycmakeargs+=(
			-DCMAKE_CXX_COMPILER="/${OIDN_ICPC_CXX_PATH}"
			-DCMAKE_C_COMPILER="/${OIDN_ICC_C_PATH}"
		)
	else
		die "The compiler is not supported."
	fi
	if use openimageio ; then
		mycmakeargs+=(
			-DOIDN_APPS_OPENIMAGEIO=$(usex openimageio)
		)
	fi
	if use apps ; then
		mycmakeargs+=(
			-DOIDN_APPS=$(usex apps)
		)
	fi

	if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR=/usr/include/oneTBB/${ONETBB_SLOT}
			-DTBB_LIBRARY_DIR=/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}
			-DTBB_SOVER="${ONETBB_SLOT}"
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if ! use doc ; then
		rm -vrf "${ED}/usr/share/doc/oidn-${PV}/readme.pdf" || die
	fi
	use doc && einstalldocs
	docinto licenses
	dodoc LICENSE.txt \
		third-party-programs.txt \
		third-party-programs-oneDNN.txt \
		third-party-programs-oneTBB.txt
	if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
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
