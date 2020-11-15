# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-static-libs cmake-utils llvm multilib-minimal toolchain-funcs

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*} llvm-9 +llvm-10"
REQUIRED_USE="^^ ( llvm-9 llvm-10 )"

# See https://github.com/imageworks/OpenShadingLanguage/blob/Release-1.10.13/INSTALL.md
QT_MIN=5.6
RDEPEND="
	llvm-9? (
		sys-devel/llvm:9
		sys-devel/clang:9
	)
	llvm-10? (
		sys-devel/llvm:10
		sys-devel/clang:10
	)
	>=dev-libs/boost-1.55:=
	dev-libs/pugixml
	>=media-libs/openexr-2:=
	>=media-libs/ilmbase-2:=
	>=media-libs/openimageio-1.8.5:=
	sys-libs/zlib:=
	partio? ( media-libs/partio )
	qt5? (
		>=dev-qt/qtcore-${QT_MIN}:5
		>=dev-qt/qtgui-${QT_MIN}:5
		>=dev-qt/qtwidgets-${QT_MIN}:5
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.12
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.5-fix-install-shaders.patch"
)

# Restricting tests as Make file handles them differently
RESTRICT="mirror test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	# See https://github.com/imageworks/OpenShadingLanguage/blob/master/INSTALL.md
	# Supports LLVM-{7,8,9,10} but should be the same throughout the system.
	if use llvm-9 ; then
		einfo "Linking with LLVM-9"
		export LLVM_MAX_SLOT=9
	elif use llvm-10 ; then
		einfo "Linking with LLVM-10"
		export LLVM_MAX_SLOT=10
	fi

	if use qt5 ; then
		ewarn \
"Enabling the qt5 USE flag with this ebuild may cause build time failures.  \
It may need to be disabled."
	fi

	llvm_pkg_setup
}

src_prepare() {
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_prepare() {
			cd "${BUILD_DIR}" || die
		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ECMAKE_LIB_TYPE}" \
			cmake-utils_src_prepare
		}
		cmake-static-libs_copy_sources
		cmake-static-libs_foreach_impl \
			cmake-static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_configure() {
			cd "${BUILD_DIR}" || die

			local cpufeature
			local mysimd=()
			for cpufeature in "${CPU_FEATURES[@]}"; do
				use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
			done

			# If no CPU SIMDs were used, completely disable them
			[[ -z ${mysimd} ]] && mysimd=("0")

			local gcc=$(tc-getCC)
			# LLVM needs CPP11. Do not disable.
			# For some reason LLVM_STATIC=ON links as shared.
			local mycmakeargs=(
				-DCMAKE_CXX_STANDARD=$(usex llvm-9 11 14)
				-DCMAKE_INSTALL_BINDIR="/usr/$(get_libdir)/osl/bin"
				-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
				-DENABLERTTI=OFF
				-DINSTALL_DOCS=$(usex doc)
				-DLLVM_STATIC=OFF
				-DOSL_BUILD_TESTS=$(usex test)
				-DSTOP_ON_WARNING=OFF
				-DUSE_CPP=$(usex llvm-9 11 14)
				-DUSE_PARTIO=$(usex partio)
				-DUSE_QT=$(usex qt5)
				-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
			)

			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				mycmakeargs+=( -DBUILDSTATIC=OFF )
			else
				mycmakeargs+=( -DBUILDSTATIC=ON )
			fi

			append-cxxflags -fPIC

		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ECMAKE_LIB_TYPE}" \
			cmake-utils_src_configure
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_compile() {
			cd "${BUILD_DIR}" || die
		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ECMAKE_LIB_TYPE}" \
			cmake-utils_src_compile
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_install() {
			pushd "${BUILD_DIR}" || die
			        S="${BUILD_DIR}" \
			        CMAKE_USE_DIR="${BUILD_DIR}" \
			        BUILD_DIR="${WORKDIR}/${P}_${ECMAKE_LIB_TYPE}" \
				cmake-utils_src_install
			popd
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_install
		if multilib_is_native_abi ; then
			dosym /usr/$(get_libdir)/osl/bin/oslc /usr/bin/oslc
			dosym /usr/$(get_libdir)/osl/bin/oslinfo /usr/bin/oslinfo
		fi
	}
	multilib_foreach_abi install_abi
}
