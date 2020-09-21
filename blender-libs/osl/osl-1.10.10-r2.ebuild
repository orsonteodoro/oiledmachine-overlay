# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-static-libs cmake-utils llvm multilib-minimal toolchain-funcs

# check this on updates
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

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*}"

RDEPEND="
	sys-devel/llvm:${LLVM_V}
	dev-libs/boost:=
	dev-libs/pugixml
	media-libs/openexr:=
	media-libs/openimageio:=
	<sys-devel/clang-10:=
	sys-libs/zlib:=
	partio? ( media-libs/partio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.5-fix-install-shaders.patch"
)

# Restricting tests as Make file handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
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

# Abbreviated PreFiX
apfx() {
	echo "/usr/$(get_libdir)/blender/osl/${LLVM_V}"
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
			local mycmakeargs=(
				-DCMAKE_INSTALL_PREFIX="$(apfx)"
				-DCMAKE_INSTALL_BINDIR="$(apfx)/usr/$(get_libdir)/osl/bin"
				-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
				-DENABLERTTI=OFF
				-DINSTALL_DOCS=$(usex doc)
				-DLLVM_STATIC=ON
				-DOSL_BUILD_TESTS=$(usex test)
				-DSTOP_ON_WARNING=OFF
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
#		if multilib_is_native_abi ; then
#			dosym $(apfx)/usr/$(get_libdir)/osl/bin/oslc /usr/bin/oslc
#			dosym $(apfx)/usr/$(get_libdir)/osl/bin/oslinfo /usr/bin/oslinfo
#		fi
	}
	multilib_foreach_abi install_abi
	mv "${ED}/usr/share" "${ED}/$(apfx)/usr" || die
}
