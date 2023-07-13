# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake flag-o-matic llvm multilib-minimal python-any-r1 toolchain-funcs

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="amd64 ~x86"
X86_CPU_FEATURES=(
	avx:avx
	avx2:avx2
	avx512f:avx512f
	f16c:f16c
	sse2:sse2
	sse3:sse3
	sse4_1:sse4.1
	sse4_2:sse4.2
	ssse3:ssse3
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
LLVM_SLOTS=( 16 15 14 13 )
LLVM_SUPPORT=( ${LLVM_SLOTS[@]} ) # Upstream supports llvm:9 to llvm:15 but only >=14 available on the distro.
LLVM_SUPPORT_=( ${LLVM_SUPPORT[@]/#/llvm-} )
IUSE+="
${CPU_FEATURES[@]%:*}
${LLVM_SUPPORT_[@]}
doc optix partio python qt5 qt6 static-libs test wayland X

r3
"
REQUIRED_USE+="
	^^ (
		${LLVM_SUPPORT_[@]}
	)
	qt5? (
		|| (
			wayland
			X
		)
	)
	qt6? (
		|| (
			wayland
			X
		)
	)
"
# See https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.12.12.0/INSTALL.md
# For optix requirements, see
#   https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.12.12.0/src/cmake/externalpackages.cmake
QT5_MIN="5.6"
QT6_MIN="6"
PATCHES=(
)

gen_llvm_depend()
{
	local s
	for s in ${LLVM_SUPPORT[@]} ; do
		echo "
		llvm-${s}? (
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
		)
		"
	done
}

gen_opx_llvm_rdepend() {
	local s
	for s in ${LLVM_SUPPORT[@]} ; do
		echo "
		llvm-${s}? (
			(
				sys-devel/clang:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
				sys-devel/lld:${s}
				sys-devel/llvm:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

gen_llvm_bdepend() {
	local s
	for s in ${LLVM_SUPPORT[@]} ; do
		echo "
		llvm-${s}? (
			(
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/lld:${s}
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

OPENEXR_V2_PV="2.5.8 2.5.7"
OPENEXR_V3_PV="3.1.7 3.1.5 3.1.4"
gen_openexr_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=
			)
		"
	done
	for pv in ${OPENEXR_V2_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~media-libs/ilmbase-${pv}:=[${MULTILIB_USEDEP}]
			)
		"
	done
}

# Multilib requires openexr built as multilib.
# >= python_single_target_python3_11 : openimageio-2.4.12.0
# >= python_single_target_python3_10 : openimageio-2.3.19.0
RDEPEND+="
	$(gen_llvm_depend)
	$(python_gen_any_dep '
		>=media-libs/openimageio-2.4.12.0:=[${PYTHON_SINGLE_USEDEP}]
		<media-libs/openimageio-2.5:=[${PYTHON_SINGLE_USEDEP}]
	')
	>=dev-libs/boost-1.55:=[${MULTILIB_USEDEP}]
	>=dev-libs/pugixml-1.8[${MULTILIB_USEDEP}]
	dev-libs/libfmt[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	optix? (
		$(python_gen_any_dep '>=media-libs/openimageio-1.8:=[${PYTHON_SINGLE_USEDEP}]')
		>=dev-libs/optix-5.1
		>=dev-util/nvidia-cuda-toolkit-8
		|| (
			$(gen_opx_llvm_rdepend)
		)
	)
	partio? (
		media-libs/partio
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			>=dev-python/pybind11-2.4.2[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		>=dev-qt/qtcore-${QT5_MIN}:5
		>=dev-qt/qtgui-${QT5_MIN}:5[wayland?,X?]
		>=dev-qt/qtwidgets-${QT5_MIN}:5[X?]
	)
	qt6? (
		>=dev-qt/qtbase-${QT6_MIN}:6[gui,wayland?,widgets,X?]
		wayland? (
			>=dev-qt/qtdeclarative-${QT6_MIN}:6[opengl]
			>=dev-qt/qtwayland-${QT6_MIN}:6
		)
	)
	|| (
		$(gen_openexr_pairs)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(gen_llvm_depend)
"
BDEPEND+="
	>=dev-util/cmake-3.12
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/bison-2.7
	>=sys-devel/flex-2.5.35[${MULTILIB_USEDEP}]
	|| (
		$(gen_llvm_bdepend)
		(
			<sys-devel/gcc-12.2
			>=sys-devel/gcc-6.1
		)
		(
			>=dev-lang/icc-17[${MULTILIB_USEDEP}]
		)
	)
"
SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
# Restricting tests as Make file handles them differently
RESTRICT="mirror test"
S="${WORKDIR}/OpenShadingLanguage-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

get_lib_type() {
	use static-libs && echo "static"
	echo "shared"
}

pkg_setup() {
	# See https://github.com/imageworks/OpenShadingLanguage/blob/master/INSTALL.md
	# Supports LLVM-{7..13} but should be the same throughout the system.
	local s
	for s in ${LLVM_SUPPORT[@]} ; do
		if use llvm-${s} ; then
			einfo "Linking with LLVM-${s}"
			export LLVM_MAX_SLOT=${s}
			break
		fi
	done

	if use qt5 ; then
ewarn
ewarn "Enabling the qt5 USE flag with this ebuild may cause build time"
ewarn "failures.  It may need to be disabled."
ewarn
	fi

	if use optix ; then
ewarn
ewarn "The optix USE flag is untested.  Left for owners of those kinds of GPUs"
ewarn "to test and fix."
ewarn
		if [[ -z "${CUDA_TOOLKIT_ROOT_DIR}" ]] ; then
ewarn
ewarn "CUDA_TOOLKIT_ROOT_DIR is not set.  Please add it in your make.conf or as"
ewarn "a per-package environmental variable."
ewarn
		fi
	fi

	if use python ; then
		python-any-r1_pkg_setup
	fi

	llvm_pkg_setup
}

src_prepare() {
	if ! use test ; then
		sed -i -e "s|osl_add_all_tests|#osl_add_all_tests|g" \
			"CMakeLists.txt" || die
	fi
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare # patcher only patches relative to CMAKE_USE_DIR not $(pwd)
}

src_configure() {
	configure_abi() {
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		strip-unsupported-flags
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die

			local cpufeature
			local mysimd=()
			for cpufeature in "${CPU_FEATURES[@]}"; do
				use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
			done

			# If no CPU SIMDs were used, completely disable them
			[[ -z ${mysimd} ]] && mysimd=("0")

			local gcc=$(tc-getCC)
			# LLVM needs CPP11. Do not disable.
			# LLVM_STATIC=ON is broken for llvm:10

			local has_qt="OFF"
			if use qt5 || use qt6 ; then
				has_qt="ON"
			fi

			local mycmakeargs=(
				-DCMAKE_CXX_STANDARD=14
				-DCMAKE_INSTALL_BINDIR="${EPREFIX}/usr/$(get_libdir)/osl/bin"
				-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
				-DINSTALL_DOCS=$(usex doc)
				-DLLVM_STATIC=OFF
				-DOSL_BUILD_TESTS=$(usex test)
				#-DOSL_SHADER_INSTALL_DIR="include/OSL/shaders"
				-DSTOP_ON_WARNING=OFF
				#-DUSE_CCACHE=OFF
				-DUSE_OPTIX=$(usex optix)
				-DUSE_PARTIO=$(usex partio)
				-DUSE_PYTHON=$(usex python)
				-DUSE_QT=${has_qt}
				-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
			)

			if [[ "${lib_type}" == "shared" ]] ; then
				mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			else
				mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
			fi

			append-cxxflags -fPIC
			if ver_test $(clang-major-version) -ge 16 ; then
				export CXX_INCLUDES_PATH="${ESYSROOT}/usr/lib/clang/$(clang-major-version)/include"
			else
				export CXX_INCLUDES_PATH="${ESYSROOT}/usr/lib/clang/$(clang-fullversion)/include"
			fi
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		if multilib_is_native_abi ; then
			dosym /usr/$(get_libdir)/osl/bin/oslc /usr/bin/oslc
			dosym /usr/$(get_libdir)/osl/bin/oslinfo /usr/bin/oslinfo
		fi
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, static-libs
