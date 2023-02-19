# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake flag-o-matic llvm python-single-r1 toolchain-funcs

DESCRIPTION="Intel(R) Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"
KEYWORDS="~amd64"
LICENSE="Apache-2.0"
# MKL_DNN is oneDNN 2.2.4 with additional custom commits.
MKL_DNN_COMMIT="eb3e9670053192258d5a66f61486e3cfe25618b3"
OIDN_WEIGHTS_COMMIT="59bad6bb6344f8fb8205772df3f795c2dc72e23b"
ORG_GH="https://github.com/OpenImageDenoise"
# SSE4.1 hardware was released in 2008.
# See scripts/build.py for release versioning.
# Clang is more smoother multitask-wise.
# c++11 is the minimum required.
MIN_CLANG_V="3.3"
MIN_GCC_V="4.8.1"
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_SLOTS=(15 14 13 12 11 10)
IUSE+="
${LLVM_SLOTS[@]/#/llvm-}
+apps +built-in-weights clang custom-tc doc gcc openimageio
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	^^ ( ${LLVM_SLOTS[@]/#/llvm-} )
	^^ ( clang gcc )
"
gen_clang_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		llvm-${s}? (
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
			=sys-devel/clang-runtime-${s}*
			>=sys-devel/lld-${s}
		)
		"
	done
}

gen_ispc_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		llvm-${s}? (
			>=dev-lang/ispc-1.15.0[llvm-${s}]
		)
		"
	done
}
DEPEND+="
	${PYTHON_DEPS}
	${CDEPEND}
	virtual/libc
	openimageio? (
		media-libs/openimageio
	)
	|| (
		(
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
			!<dev-cpp/tbb-2021:0=
		)
		>=dev-cpp/tbb-2021.1.1:${ONETBB_SLOT}=
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(gen_ispc_depends)
	${PYTHON_DEPS}
	>=dev-util/cmake-3.1
	|| (
		clang? (
			$(gen_clang_depends)
		)
		gcc? (
			>=sys-devel/gcc-${MIN_GCC_V}
		)
	)
"
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
	-> ${PN}-weights-${OIDN_WEIGHTS_COMMIT:0:7}.tar.gz
	)
https://github.com/OpenImageDenoise/oidn/commit/4180502f326dccd5e46ab67176b53cc800e32f7b.patch
	-> oidn-commit-4180502.patch
	"
fi
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md readme.pdf )
PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-findtbb-print-paths.patch"
	"${FILESDIR}/${PN}-1.4.1-findtbb-alt-lib-path.patch"
	"${FILESDIR}/${PN}-commit-4180502-backport-for-1.3.0.patch"
)

pkg_setup() {
	if [[ "${CHOST}" == "${CBUILD}" ]] && use kernel_linux ; then
		if [[ ! -e "${BROOT}/proc/cpuinfo" ]] ; then
ewarn
ewarn "Cannot find ${BROOT}/proc/cpuinfo.  Skipping CPU flag check."
ewarn
		elif ! grep -F -e "sse4_1" "${BROOT}/proc/cpuinfo" ; then
ewarn
ewarn "You need SSE4.1 to use this product."
ewarn
		fi
	fi

	if tc-is-clang || use clang ; then
		local s
		for s in ${LLVM_SLOTS[@]} ; do
			if use llvm-${s} ; then
				LLVM_MAX_SLOT=${s}
				llvm_pkg_setup
				break
			fi
		done
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

src_configure() {
	mycmakeargs=()

	if use gcc ; then
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		test-flags-CXX "-std=c++11" 2>/dev/null 1>/dev/null \
	                || die "Switch to a c++11 compatible compiler."
		# Prevent lock up
		tc-is-gcc && export MAKEOPTS="-j1"
	elif use clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		test-flags-CXX "-std=c++11" 2>/dev/null 1>/dev/null \
	                || die "Switch to a c++11 compatible compiler."
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
	fi

einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo "CHOST:\t${CHOST}"
einfo

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
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
			-DTBB_SOVER=$(echo $(basename $(realpath "${ESYSROOT}/usr/$(get_libdir)/libtbb.so")) | cut -f 3 -d ".")
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_SOVER="${LEGACY_TBB_SLOT}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
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
				patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
