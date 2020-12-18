# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils llvm multilib-minimal static-libs toolchain-funcs

# check this on updates
CXXABI=11
LLVM_V=9
LLVM_MAX_SLOT=${LLVM_V}

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="${LLVM_V}/${PV}"
KEYWORDS="amd64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc optix partio test ${CPU_FEATURES[@]%:*}"
#IUSE+=" -qt5"
#REQUIRED_USE="!qt5"

# See https://github.com/imageworks/OpenShadingLanguage/blob/Release-1.10.13/INSTALL.md
# For optix requirements, see
#   https://github.com/imageworks/OpenShadingLanguage/blob/Release-1.10.13/src/cmake/externalpackages.cmake
#   https://github.com/imageworks/OpenShadingLanguage/releases/tag/Release-1.10.2
RDEPEND="
	sys-devel/llvm:${LLVM_V}
	>=blender-libs/boost-1.55:${CXXABI}=
	dev-libs/pugixml
	>=media-libs/openexr-2:=
	>=media-libs/ilmbase-2:=
	>=media-libs/openimageio-1.8.5:=
	sys-devel/clang:${LLVM_V}=
	sys-devel/llvm:${LLVM_V}=
	sys-libs/zlib:=
	optix? (
		>=dev-libs/optix-5.1
		>=dev-util/nvidia-cuda-toolkit-8
		>=media-libs/openimageio-1.8:=
		>=sys-devel/llvm-6[llvm_targets_NVPTX]
		>=sys-devel/clang-6[llvm_targets_NVPTX]
	)
	partio? ( media-libs/partio )
"
#RDEPEND+="
#	qt5? (
#		dev-qt/qtcore:5
#		dev-qt/qtgui:5
#		dev-qt/qtwidgets:5
#	)
#"

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
	if use optix ; then
		ewarn \
"The optix USE flag is untested.  Left for owners of those kinds of GPUs to \
test and fix."
		if [[ -z "${CUDA_TOOLKIT_ROOT_DIR}" ]] ; then
			ewarn \
"CUDA_TOOLKIT_ROOT_DIR is not set.  Please add it in your make.conf or as a \
per-package environmental variable."
		fi
	fi

	llvm_pkg_setup
}

src_prepare() {
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_prepare() {
			cd "${BUILD_DIR}" || die
		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ESTSH_LIB_TYPE}" \
			cmake-utils_src_prepare
		}
		static-libs_copy_sources
		static-libs_foreach_impl \
			static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

# Abbreviated PreFiX
apfx() {
	echo "/usr/$(get_libdir)/blender/osl/${LLVM_V}/usr"
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		export LD_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI}/usr/$(get_libdir)"
		static-libs_configure() {
			cd "${BUILD_DIR}" || die

			unset CMAKE_INCLUDE_PATH
			unset CMAKE_LIBRARY_PATH

			export BOOST_ROOT="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI}/usr"

			local cpufeature
			local mysimd=()
			for cpufeature in "${CPU_FEATURES[@]}"; do
				use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
			done

			# If no CPU SIMDs were used, completely disable them
			[[ -z ${mysimd} ]] && mysimd=("0")

			local bin_suffix=
			if multilib_is_native_abi ; then
				# Blender expects oslc to be placed in $OSL_ROOT_DIR/bin
				bin_suffix=""
			else
				# avoid collision
				bin_suffix="-${ABI}"
			fi


# Qt is disabled in Blender.
# See https://github.com/blender/blender/blob/v2.83/build_files/build_environment/cmake/osl.cmake
# Enabling Qt causes: ld: osltoyapp.cpp:(.text+0x2d74): undefined reference to `OSL_v1_10::OSLQuery::~OSLQuery()

			local gcc=$(tc-getCC)
			# LLVM needs CPP11. Do not disable.
			# For some reason LLVM_STATIC=ON links as shared.
			local mycmakeargs=(
				-DCMAKE_CXX_STANDARD=${CXXABI}
				-DCMAKE_INSTALL_PREFIX="$(apfx)"
				-DCMAKE_INSTALL_BINDIR="$(apfx)/bin${bin_suffix}"
				-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
				-DENABLERTTI=OFF
				-DINSTALL_DOCS=$(usex doc)
				-DLLVM_STATIC=OFF
				-DOSL_BUILD_TESTS=$(usex test)
				-DSTOP_ON_WARNING=OFF
				-DUSE_CPP=${CXXABI}
				-DUSE_OPTIX=$(usex optix)
				-DUSE_PARTIO=$(usex partio)
				-DUSE_QT=OFF
				-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
			)

			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				mycmakeargs+=( -DBUILDSTATIC=OFF )
			else
				mycmakeargs+=( -DBUILDSTATIC=ON )
			fi

			append-cxxflags -fPIC

		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ESTSH_LIB_TYPE}" \
			cmake-utils_src_configure
		}
		static-libs_foreach_impl \
			static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
		        S="${BUILD_DIR}" \
		        CMAKE_USE_DIR="${BUILD_DIR}" \
		        BUILD_DIR="${WORKDIR}/${P}_${ESTSH_LIB_TYPE}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			pushd "${BUILD_DIR}" || die
			        S="${BUILD_DIR}" \
			        CMAKE_USE_DIR="${BUILD_DIR}" \
			        BUILD_DIR="${WORKDIR}/${P}_${ESTSH_LIB_TYPE}" \
				cmake-utils_src_install
			popd
		}
		static-libs_foreach_impl \
			static-libs_install
#		if multilib_is_native_abi ; then
#			dosym $(apfx)/usr/$(get_libdir)/osl/bin/oslc /usr/bin/oslc
#			dosym $(apfx)/usr/$(get_libdir)/osl/bin/oslinfo /usr/bin/oslinfo
#		fi
	}
	multilib_foreach_abi install_abi
	mv "${ED}/usr/share" "${ED}/$(apfx)" || die
}
