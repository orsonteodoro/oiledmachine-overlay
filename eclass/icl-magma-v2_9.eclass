# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PV _pabbcc corresponds to rocm a.bb.cc

MY_PV=$(ver_cut 1-3)

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx702
	gfx703
	gfx704
	gfx705
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx909
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1033
)
CUDA_TARGETS_COMPAT=(
#	sm_20 # Dropped.  SDK version not in distro.  Fork ebuild for support.
#	sm_30 # Dropped.  SDK version not in distro.  Fork ebuild for support.
	sm_35
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_87
	sm_89
	sm_90
	sm_90a
)
inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
)
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)
FORTRAN_STANDARD="77 90"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit check-compiler-switch cmake flag-o-matic fortran-2 libcxx-slot libstdcxx-slot python-any-r1 toolchain-funcs
if [[ "${MAGMA_ROCM}" == "1" ]] ; then
	inherit rocm
else
	inherit llvm
fi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="https://icl.cs.utk.edu/projectsfiles/${PN}/downloads/${PN}-${MY_PV}.tar.gz"

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="
	https://icl.cs.utk.edu/magma/
	https://bitbucket.org/icl/magma
"
LICENSE="BSD"
IUSE+="
atlas doc examples -ilp64 mkl openblas tbb openmp test
ebuild_revision_7
"
if ! [[ "${MAGMA_ROCM}" == "1" ]] ; then
	IUSE+="
		${LLVM_COMPAT[@]/#/llvm_slot_}
	"
	REQUIRED_USE+="
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	"
fi

GPU_FRAMEWORKS=""
if [[ "${MAGMA_CUDA}" == "1" ]] ; then
	CUDA_TOOLKIT_11_8="
		(
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
	"
	CUDA_TOOLKIT_12_3="
		(
			=dev-util/nvidia-cuda-toolkit-12.3*
		)
	"
	CUDA_TOOLKIT_12_4="
		(
			=dev-util/nvidia-cuda-toolkit-12.4*
		)
	"
	CUDA_TOOLKIT_12_5="
		(
			=dev-util/nvidia-cuda-toolkit-12.5*
		)
	"
	CUDA_TOOLKIT_12_5="
		(
			=dev-util/nvidia-cuda-toolkit-12.6*
		)
	"
	IUSE+="
		${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		cuda
	"
	gen_cuda_required_use() {
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			echo "
				cuda_targets_${x}? (
					cuda
				)
			"
		done
	}
	REQUIRED_USE+="
		cuda? (
			$(gen_cuda_required_use)
			|| (
				${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
			)
		)
		examples? (
			cuda? (
				|| (
					cuda_targets_sm_70
					cuda_targets_sm_75
					cuda_targets_sm_80
				)
			)
		)
	"
	GPU_FRAMEWORKS+="
		cuda
	"
	RDEPEND+="
		cuda? (
			cuda_targets_sm_35? (
				|| (
					${CUDA_TOOLKIT_11_8}
				)
			)
			cuda_targets_sm_37? (
				|| (
					${CUDA_TOOLKIT_11_8}
				)
			)
			cuda_targets_sm_50? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_5}
					${CUDA_TOOLKIT_12_6}
				)
			)
			cuda_targets_sm_60? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_5}
					${CUDA_TOOLKIT_12_6}
				)
			)
			cuda_targets_sm_70? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_5}
					${CUDA_TOOLKIT_12_6}
				)
			)
			cuda_targets_sm_75? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_6}
					${CUDA_TOOLKIT_12_5}
				)
			)
			cuda_targets_sm_80? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_5}
					${CUDA_TOOLKIT_12_6}
				)
			)
			cuda_targets_sm_90? (
				|| (
					${CUDA_TOOLKIT_11_8}
					${CUDA_TOOLKIT_12_3}
					${CUDA_TOOLKIT_12_4}
					${CUDA_TOOLKIT_12_5}
					${CUDA_TOOLKIT_12_6}
				)
			)
			dev-util/nvidia-cuda-toolkit:=
		)
	"
fi

if [[ "${MAGMA_ROCM}" == "1" ]] ; then
	IUSE+="
		${ROCM_IUSE}
		rocm
		system-llvm
	"
	gen_rocm_required_use() {
		local x
		for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			echo "
				amdgpu_targets_${x}? (
					rocm
				)
			"
		done
	}
	REQUIRED_USE+="
		examples? (
			rocm? (
				|| (
					amdgpu_targets_gfx900
					amdgpu_targets_gfx906
					amdgpu_targets_gfx908
				)
			)
		)
		rocm? (
			$(gen_rocm_required_use)
			|| (
				${ROCM_REQUIRED_USE}
			)
		)
	"
	GPU_FRAMEWORKS+="
		rocm
	"
	gen_rocm_rdepend() {
		local pv
		for pv in ${ROCM_SLOTS[@]} ; do
			local slot="0/${pv%.*}"
			echo "
				(
					>=dev-libs/rocm-core-${pv}:${slot}
					dev-libs/rocm-core:=
					>=dev-util/hip-${pv}:${slot}[rocm]
					dev-util/hip:=
					>=sci-libs/hipBLAS-${pv}:${slot}[rocm]
					sci-libs/hipBLAS:=
					>=sci-libs/hipSPARSE-${pv}:${slot}[rocm]
					sci-libs/hipSPARSE:=
				)
			"
		done
	}
	RDEPEND+="
		rocm? (
			|| (
				$(gen_rocm_rdepend)
			)
			dev-util/hip:=
		)
	"
fi

if [[ -n "${GPU_FRAMEWORKS}" ]] ; then
	REQUIRED_USE+="
		^^ (
			${GPU_FRAMEWORKS}
		)
	"
fi


REQUIRED_USE+="
	ilp64? (
		mkl
	)
	openmp? (
		mkl
	)
	tbb? (
		mkl
	)
	^^ (
		atlas
		openblas
		mkl
	)
"
# TODO: do not enforce openblas
#	hip? ( sci-libs/hipBLAS )
RDEPEND+="
	sci-libs/hipBLAS
	sys-devel/gcc[fortran]
	!openblas? (
		virtual/blas
		virtual/lapack
	)
	atlas? (
		sci-libs/atlas
	)
	mkl? (
		sci-libs/mkl
	)
	openblas? (
		sci-libs/lapack
		sci-libs/openblas
	)
	tbb? (
		dev-cpp/tbb:0
		dev-cpp/tbb:=
	)
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	sys-devel/gcc-config
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.8.14-r1[dot]
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
)

icl-magma-v2_9_pkg_setup() {
	check-compiler-switch_start
	fortran-2_pkg_setup
	python-any-r1_pkg_setup
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		if use rocm ; then
			rocm_pkg_setup
		fi
	else
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_MAX_SLOT="${LLVM_SLOT}"
				break
			fi
		done
		llvm_pkg_setup
	fi
	#tc-check-openmp || die "Need OpenMP to compile ${P}"
	if use mkl ; then
		source "/opt/intel/oneapi/mkl/latest/env/vars.sh"
	fi
	libstdcxx-slot_verify
}

gen_pc_file() {
	local _prefix
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		_prefix="${EPREFIX}/${EROCM_PATH}"
	elif [[ "${MAGMA_CUDA}" == "1" ]] ; then
		_prefix="${EPREFIX}/usr"
	else
		_prefix="${EPREFIX}/usr"
	fi

# The distributed pc file is not so useful so replace it.
cat <<-EOF > ${PN}.pc || die
prefix=${_prefix}
libdir=\${prefix}/$(get_libdir)
includedir=\${prefix}/include/${PN}
Name: ${PN}
Description: ${DESCRIPTION}
Version: ${MY_PV}
URL: ${HOMEPAGE}
Libs: -L\${libdir} -lmagma
Libs.private: -lm -lpthread -ldl
Cflags: -I\${includedir}
Requires: $(usex openblas "openblas" "blas lapack")
EOF
}

# Replace symbols for cuda builds even if not inheriting rocm eclass.
replace_symbols() {
	IFS=$'\n'

	local llvm_slot
	if [[ "${ROCM_SLOT}" == "7.0" ]] ; then
		llvm_slot=19
	elif [[ "${ROCM_SLOT}" == "6.4" ]] ; then
		llvm_slot=19
	else
		# Not installed or disable
		llvm_slot=-1
	fi


	IFS=$' \t\n'
}

generate_precisions() {
	local inc_file
	if has cuda ${IUSE_EFFECTIVE} && use cuda && use mkl && use ilp64 ; then
		inc_file="make.inc.mkl-gcc-ilp64"
	elif has cuda ${IUSE_EFFECTIVE} && use cuda && use mkl ; then
		inc_file="make.inc.mkl-gcc"
	elif has cuda ${IUSE_EFFECTIVE} && use cuda && use openblas ; then
		inc_file="make.inc.openblas"
	elif has rocm ${IUSE_EFFECTIVE} && use rocm && use mkl && use ilp64 ; then
		inc_file="make.inc.hip-gcc-mkl-ilp64"
	elif has rocm ${IUSE_EFFECTIVE} && use rocm && use mkl ; then
		inc_file="make.inc.hip-gcc-mkl"
	elif has rocm ${IUSE_EFFECTIVE} && use rocm && use openblas ; then
		inc_file="make.inc.hip-gcc-openblas"
	elif has cuda ${IUSE_EFFECTIVE} && use cuda && use atlas ; then
		inc_file="make.inc.atlas"
	elif has rocm ${IUSE_EFFECTIVE} && use rocm && use atlas ; then
		inc_file="make.inc.atlas"
	else
		local gpu_targets=""
		if [[ "${MAGMA_CUDA}" == "1" ]] ; then
			gpu_targets+="cuda "
		fi
		if [[ "${MAGMA_ROCM}" == "1" ]] ; then
			gpu_targets+="rocm "
		fi

eerror
eerror "You must choose one of the following USE flags per row:"
eerror
		if [[ -n "${gpu_targets}" ]] ; then
eerror "GPU target:  ${gpu_targets}"
		fi
eerror "CPU target:  altas mkl openblas"
eerror
		die
	fi

	rm -f "make.inc" || true
	ln -s \
		"make.inc-examples/${inc_file}" \
		"make.inc" \
		|| die

	if use openblas ; then
		export OPENBLASDIR="/usr"
	fi

	if has cuda ${IUSE_EFFECTIVE} && use cuda ; then
		addpredict "/proc/self/task/"
		export CUDADIR="/opt/cuda"
		export gpu="$(get_cuda_flags)"
	fi

	if has cuda ${IUSE_EFFECTIVE} && use cuda ; then
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CC} -E"
		strip-unsupported-flags
	elif has rocm ${IUSE_EFFECTIVE} && use rocm ; then
		export gpu="$(get_amdgpu_flags)"
	fi

	local backend
	if has cuda ${IUSE_EFFECTIVE} use cuda ; then
		backend="cuda"
	elif has rocm ${IUSE_EFFECTIVE} use rocm ; then
		backend="hip"
	else
		backend="cuda"
	fi

	emake generate
}

icl-magma-v2_9_src_prepare() {
	# Let build script handle it.
	unset CC
	unset CXX

	cmake_src_prepare
	replace_symbols
	local applied_rocm_patches=0
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		if use rocm ; then
			applied_rocm_patches=1
			rocm_src_prepare
		fi
	fi

	gen_pc_file

	generate_precisions

	rm -r blas_fix || die
}

get_cuda_flags() {
	local list
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use "cuda_targets_${x}" ; then
			list+=";${x}"
		fi
	done
	list="${list:1}"
	echo "${list}"
}

icl-magma-v2_9_src_configure() {
	replace-flags '-O0' '-O1'

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DUSE_FORTRAN=ON
	)
	if has cuda ${IUSE_EFFECTIVE} ; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
			-DMAGMA_ENABLE_CUDA=$(usex cuda ON OFF)
		)
	else
		mycmakeargs+=(
			-DMAGMA_ENABLE_CUDA=OFF
		)
	fi

	if has rocm ${IUSE_EFFECTIVE} ; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
			-DMAGMA_ENABLE_HIP=$(usex rocm ON OFF)
		)
		append-ldflags \
			-L"${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)"
	else
		mycmakeargs+=(
			-DMAGMA_ENABLE_HIP=OFF
		)
	fi

	local mkl_data_model_vendor
	local mkl_data_model2
	if use ilp64 ; then
# TODO:  Remove ilp64 USE flag.
# TODO:  Resolve install location for ilp64, lp64 implementations.
ewarn "Support or install location may change for ilp64 in the future."
		mkl_data_model_vendor="Intel10_64ilp"
		mkl_data_model="ilp64"
	else
		mkl_data_model_vendor="Intel10_64lp"
		mkl_data_model="lp64"
	fi

	if has cuda ${IUSE_EFFECTIVE} && use cuda && use mkl ; then
		if use tbb ; then
			mycmakeargs+=(
				-DBLA_VENDOR="${mkl_data_model_vendor}"
				-DLAPACK_LIBRARIES:STRING="$(pkg-config --libs mkl-dynamic-${mkl_data_model}-tbb)"
				-DLAPACK_CXXFLAGS:STRING="$(pkg-config --cflags mkl-dynamic-${mkl_data_model}-tbb)"
			)
		elif use openmp ; then
			mycmakeargs+=(
				-DBLA_VENDOR="${mkl_data_model_vendor}"
				-DLAPACK_LIBRARIES:STRING="$(pkg-config --libs mkl-dynamic-${mkl_data_model}-gomp)"
				-DLAPACK_CXXFLAGS:STRING="$(pkg-config --cflags mkl-dynamic-${mkl_data_model}-gomp)"
			)
		else
ewarn
ewarn "Either the tbb or openmp USE flag is recommended for threading.  Falling"
ewarn "back to sequential."
ewarn
			mycmakeargs+=(
				-DBLA_VENDOR="${mkl_data_model_vendor}_seq"
				-DLAPACK_LIBRARIES:STRING="$(pkg-config --libs mkl-dynamic-${mkl_data_model}-seq)"
				-DLAPACK_CXXFLAGS:STRING="$(pkg-config --cflags mkl-dynamic-${mkl_data_model}-seq)"
			)
		fi
	elif has rocm ${IUSE_EFFECTIVE} && use rocm && use mkl ; then
		if use tbb ; then
			mycmakeargs+=(
				-DBLA_VENDOR="${mkl_data_model_vendor}"
				-DLAPACK_LIBRARIES:STRING="$(pkg-config --libs mkl-dynamic-${mkl_data_model}-tbb)"
				-DLAPACK_CXXFLAGS:STRING="$(pkg-config --cflags mkl-dynamic-${mkl_data_model}-tbb)"
			)
# Cannot use OpenMP due to bug below between gcc-12 (/usr/lib/gcc/${CHOST}/12/include/omp.h) and libomp (/usr/include/omp.h).
# __GOMP_NOTHROW __attribute__((__malloc__, __malloc__ (omp_free), error: '__malloc__' attribute takes no arguments
		else
ewarn
ewarn "The tbb USE flag is recommended for threading.  Falling"
ewarn "back to sequential."
ewarn
			mycmakeargs+=(
				-DBLA_VENDOR="${mkl_data_model_vendor}_seq"
				-DLAPACK_LIBRARIES:STRING="$(pkg-config --libs mkl-dynamic-${mkl_data_model}-seq)"
				-DLAPACK_CXXFLAGS:STRING="$(pkg-config --cflags mkl-dynamic-${mkl_data_model}-seq)"
			)
		fi
	fi

	if use openblas ; then
		mycmakeargs+=(
			-DBLA_VENDOR="OpenBLAS"
		)
	fi

	if has cuda ${IUSE_EFFECTIVE} && use cuda ; then
		mycmakeargs+=(
			-DGPU_TARGET="$(get_cuda_flags)"
		)
	fi
	if has rocm ${IUSE_EFFECTIVE} && use rocm ; then
		local a
		local b
		local c
		local hip_pv=$(grep -r -e "set(PACKAGE_VERSION" \
			"${ESYSROOT_ROCM_PATH}/$(get_libdir)/cmake/hip/hip-config-version.cmake" \
			| head -n 1 \
			| cut -f 2 -d " " \
			| cut -f 2 -d '"')
		if [[ -n "${hip_pv}" ]] ; then
			# a.b.c : 5.6.23356 : a=5, b=6, c=23356
			a=$(ver_cut 1 ${hip_pv})
			b=$(ver_cut 2 ${hip_pv})
			c=$(ver_cut 3 ${hip_pv})
			append-cppflags -DHIP_VERSION=$(printf "%d%02d%5d" ${a} ${b} ${c})
		fi

		export CC="${HIP_CC:-hipcc}"
		export CXX="${HIP_CXX:-hipcc}"
		strip-unsupported-flags
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DGPU_TARGET="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	cmake_src_configure
}

icl-magma-v2_9_src_compile() {
	cmake_src_compile
}

icl-magma-v2_9_src_install() {
	cmake_src_install
	if [[ "${MAGMA_CUDA}" == "1" ]] ; then
		insinto "/usr/include/${PN}"
		doins include/*.h
		insinto "/usr/$(get_libdir)/pkgconfig"
	fi
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		insinto "${EROCM_PATH}/include/${PN}"
		doins include/*.h
		insinto "${EROCM_PATH}/$(rocm_get_libdir)/pkgconfig"
	fi
	doins "${PN}.pc"
	local DOCS=(
		README
		ReleaseNotes
	)
	local HTML_DOCS=()
	use doc && HTML_DOCS=(
		docs/html/.
	)
	einstalldocs
}

EXPORT_FUNCTIONS \
	pkg_setup \
	src_prepare \
	src_configure \
	src_compile \
	src_install
