# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} ) # upstream tested it up to 3.9 (inclusive)
inherit cmake-utils llvm multilib-minimal python-any-r1 static-libs toolchain-funcs

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"
X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c )
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
LLVM_SUPPORT=(10 11 12 13) # Upstream supports llvm:9 to llvm:12 but only >=10 available on the distro.
LLVM_SUPPORT_=( ${LLVM_SUPPORT[@]/#/llvm-} )
# The highest stable llvm was used as the default.  Revisions may update this in the future.
IUSE+=" ${CPU_FEATURES[@]%:*} doc ${LLVM_SUPPORT_[@]} +llvm-13 optix partio python qt5 test"
REQUIRED_USE+=" ^^ ( ${LLVM_SUPPORT_[@]} )"
# See https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.11.17.0/INSTALL.md
# For optix requirements, see
#   https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/v1.11.17.0/src/cmake/externalpackages.cmake
QT_MIN=5.6

gen_llvm_depend()
{
	for v in ${LLVM_SUPPORT[@]} ; do
		echo "
		llvm-${v}? (
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
		)

"
	done
}

gen_opx_llvm_rdepend() {
	local o=""
	for s in ${LLVM_SUPPORT[@]} ; do
		o+="
			(
				sys-devel/llvm:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
				sys-devel/clang:${s}[llvm_targets_NVPTX,${MULTILIB_USEDEP}]
				>=sys-devel/lld-${s}
			)
		"
	done
	echo "${o}"
}

gen_llvm_bdepend() {
	local o=""
	for s in ${LLVM_SUPPORT[@]} ; do
		o+="
			(
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				>=sys-devel/lld-${s}
			)
		"
	done
	echo "${o}"
}

# Multilib requires openexr built as multilib.
RDEPEND+=" "$(gen_llvm_depend)
RDEPEND+="
	>=dev-libs/boost-1.55:=[${MULTILIB_USEDEP}]
	dev-libs/libfmt[${MULTILIB_USEDEP}]
	dev-libs/pugixml[${MULTILIB_USEDEP}]
	>=media-libs/openexr-2:=
	>=media-libs/ilmbase-2:=[${MULTILIB_USEDEP}]
	$(python_gen_any_dep '>=media-libs/openimageio-2:=[${PYTHON_SINGLE_USEDEP}]')
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
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" "$(gen_llvm_depend)
BDEPEND+="
	|| (
		(
			<sys-devel/gcc-12
			>=sys-devel/gcc-6
		)
		$(gen_llvm_bdepend)
		>=dev-lang/icc-13[${MULTILIB_USEDEP}]
	)
	>=dev-util/cmake-3.12
	>=sys-devel/bison-2.7
	>=sys-devel/flex-2.5.35[${MULTILIB_USEDEP}]
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
SRC_URI="
https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz
	-> ${P}.tar.gz"
# Restricting tests as Make file handles them differently
RESTRICT="mirror test"
S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	# See https://github.com/imageworks/OpenShadingLanguage/blob/master/INSTALL.md
	# Supports LLVM-{7..13} but should be the same throughout the system.
	if use llvm-10 ; then
		einfo "Linking with LLVM-10"
		export LLVM_MAX_SLOT=10
	elif use llvm-11 ; then
		einfo "Linking with LLVM-11"
		export LLVM_MAX_SLOT=11
	elif use llvm-12 ; then
		einfo "Linking with LLVM-12"
		export LLVM_MAX_SLOT=12
	elif use llvm-13 ; then
		einfo "Linking with LLVM-13"
		export LLVM_MAX_SLOT=13
	fi

	if use qt5 ; then
		ewarn \
"Enabling the qt5 USE flag with this ebuild may cause build time failures.  \
It may need to be disabled."
	fi

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

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_configure() {
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
			# LLVM_STATIC=ON is broken for llvm:10
			local mycmakeargs=(
				-DCMAKE_CXX_STANDARD=14
				-DCMAKE_INSTALL_BINDIR="/usr/$(get_libdir)/osl/bin"
				-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
				-DINSTALL_DOCS=$(usex doc)
				-DLLVM_STATIC=OFF
				-DOSL_BUILD_TESTS=$(usex test)
				#-DOSL_SHADER_INSTALL_DIR="include/OSL/shaders"
				-DSTOP_ON_WARNING=OFF
				-DUSE_OPTIX=$(usex optix)
				-DUSE_PARTIO=$(usex partio)
				-DUSE_PYTHON=$(usex python)
				-DUSE_QT=$(usex qt5)
				-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
			)

			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			else
				mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
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
		if multilib_is_native_abi ; then
			dosym /usr/$(get_libdir)/osl/bin/oslc /usr/bin/oslc
			dosym /usr/$(get_libdir)/osl/bin/oslinfo /usr/bin/oslinfo
		fi
	}
	multilib_foreach_abi install_abi
}
