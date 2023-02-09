# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} ) # Upstream tests up to to 3.10
inherit cmake flag-o-matic llvm multilib-minimal python-any-r1 toolchain-funcs

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="amd64 ~x86"
X86_CPU_FEATURES=(
	sse2:sse2
	sse3:sse3
	ssse3:ssse3
	sse4_1:sse4.1
	sse4_2:sse4.2
	avx:avx
	avx2:avx2
	avx512f:avx512f
	f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
LLVM_SUPPORT=(15 14 13) # Upstream supports llvm:9 to llvm:15 but only >=14 available on the distro.
LLVM_SUPPORT_=( ${LLVM_SUPPORT[@]/#/llvm-} )
IUSE+="
${CPU_FEATURES[@]%:*}
${LLVM_SUPPORT_[@]}
doc optix partio python qt5 static-libs test
"
REQUIRED_USE+="
	^^ ( ${LLVM_SUPPORT_[@]} )
"
# See https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.12.6.2/INSTALL.md
# For optix requirements, see
#   https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.12.6.2/src/cmake/externalpackages.cmake
QT_MIN=5.6
PATCHES=(
	"${FILESDIR}/${PN}-1.11.17.0-stddef-includes-path.patch"
)

gen_llvm_depend()
{
	local s
	for s in ${LLVM_SUPPORT[@]} ; do
		echo "
		llvm-${s}? (
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
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
				sys-devel/llvm:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
				sys-devel/clang:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
				>=sys-devel/lld-${s}
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
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				>=sys-devel/lld-${s}
			)
		)
		"
	done
}

OPENEXR_V2="2.5.7 2.5.8"
OPENEXR_V3="3.1.4 3.1.5"
gen_openexr_pairs() {
	local v
	for v in ${OPENEXR_V2} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~media-libs/ilmbase-${v}:=[${MULTILIB_USEDEP}]
			)
		"
	done
	for v in ${OPENEXR_V3} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~dev-libs/imath-${v}:=
			)
		"
	done
}

# Multilib requires openexr built as multilib.
RDEPEND+=" "$(gen_llvm_depend)
RDEPEND+="
	|| ( $(gen_openexr_pairs) )
	>=dev-libs/boost-1.55:=[${MULTILIB_USEDEP}]
	dev-libs/libfmt[${MULTILIB_USEDEP}]
	dev-libs/pugixml[${MULTILIB_USEDEP}]
	$(python_gen_any_dep '>=media-libs/openimageio-2:=[${PYTHON_SINGLE_USEDEP}]')
	$(python_gen_any_dep '<media-libs/openimageio-2.5:=[${PYTHON_SINGLE_USEDEP}]')
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	optix? (
		>=dev-libs/optix-5.1
		>=dev-util/nvidia-cuda-toolkit-8
		$(python_gen_any_dep '>=media-libs/openimageio-1.8:=[${PYTHON_SINGLE_USEDEP}]')
		|| ( $(gen_opx_llvm_rdepend) )
	)
	partio? ( media-libs/partio )
	qt5? (
		>=dev-qt/qtcore-${QT_MIN}:5
		>=dev-qt/qtgui-${QT_MIN}:5
		>=dev-qt/qtwidgets-${QT_MIN}:5
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/pybind11-2.4.2[${PYTHON_USEDEP}]')
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" "$(gen_llvm_depend)
BDEPEND+="
	|| (
		(
			<sys-devel/gcc-12.2
			>=sys-devel/gcc-6.1
		)
		$(gen_llvm_bdepend)
		(
			>=dev-lang/icc-17[${MULTILIB_USEDEP}]
		)
	)
	>=dev-util/cmake-3.12
	>=sys-devel/bison-2.7
	>=sys-devel/flex-2.5.35[${MULTILIB_USEDEP}]
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
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
		export CC="clang"
		export CXX="clang++"
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
				-DUSE_QT=$(usex qt5)
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
