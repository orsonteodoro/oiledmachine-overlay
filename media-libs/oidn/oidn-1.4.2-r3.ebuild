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
# MKL_DNN is oneDNN 2.2.4 with additional custom commits.
MKL_DNN_COMMIT="f53274c9fef211396655fc4340cb838452334089"
OIDN_WEIGHTS_COMMIT="a34b7641349c5a79e46a617d61709c35df5d6c28"
ORG_GH="https://github.com/OpenImageDenoise"
SLOT="0/${PV}"
IUSE+=" +apps +built-in-weights custom-tc doc disable-sse41-check gcc icc openimageio"
IUSE+=" +clang gcc icc"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	^^ ( clang gcc icc )
"
# Clang is more smoother multitask-wise
# c++11 minimal
MIN_CLANG_V="3.3"
MIN_GCC_V="4.8.1"
MIN_ICC_V="17.0" # 15.0 has c++11 support, but project only supports 17
# SSE4.1 hardware release in 2008
# See scripts/build.py for release versioning
CDEPEND=" ${PYTHON_DEPS}"
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
DEPEND+=" ${CDEPEND}
	|| (
		(
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
			!<dev-cpp/tbb-2021:0=
		)
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
	)
	virtual/libc
	openimageio? ( media-libs/openimageio )"
RDEPEND+=" ${DEPEND}"
LLVM_SLOTS=(14 13 12 11 10)
gen_depends() {
	local o
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
			=sys-devel/clang-runtime-${s}*
			>=sys-devel/lld-${s}
		)
		"
	done
	echo "${o}"
}
CLANG_DEPENDS=$(gen_depends)
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
	"${FILESDIR}/${PN}-1.4.1-findtbb-alt-lib-path.patch"
)

pkg_setup() {
	if [[ ! -f /proc/cpuinfo ]] ; then
		die "Cannot find /proc/cpuinfo"
	fi
	if ! use disable-sse41-check ; then
		if ! grep -F -e "sse4_1" /proc/cpuinfo ; then
eerror
eerror "You need SSE4.1 to use this product.  Add disable-sse41-check to the"
eerror "USE flag to build and emerge anyways."
eerror
			die
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
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=()

	if use gcc ; then
		export CC="gcc"
		export CXX="g++"
		test-flags-CXX "-std=c++11" 2>/dev/null 1>/dev/null \
	                || die "Switch to a c++11 compatible compiler."
		# Prevent lock up
		tc-is-gcc && export MAKEOPTS="-j1"
	elif use clang ; then
		export CC="clang"
		export CXX="clang++"
		test-flags-CXX "-std=c++11" 2>/dev/null 1>/dev/null \
	                || die "Switch to a c++11 compatible compiler."
	elif use icc ; then
		export CC=icc
		export CXX=icpc
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
	fi

	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
	einfo "CHOST=${CHOST}"

	mycmakeargs+=(
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_C_COMPILER="${CC}"
	)

	strip-unsupported-flags
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

	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR=/usr/include
			-DTBB_LIBRARY_DIR=/usr/$(get_libdir)
			-DTBB_SOVER=$(echo $(basename $(realpath /usr/$(get_libdir)/libtbb.so)) | cut -f 3 -d ".")
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR=/usr/include/tbb/${LEGACY_TBB_SLOT}
			-DTBB_LIBRARY_DIR=/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}
			-DTBB_SOVER="${LEGACY_TBB_SLOT}"
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
	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}
