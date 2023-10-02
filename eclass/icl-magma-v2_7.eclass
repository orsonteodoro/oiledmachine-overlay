# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PV _pabbcc corresponds to rocm a.bb.cc

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
	sm_60
	sm_70
	sm_75
	sm_80
	sm_90
)
FORTRAN_STANDARD="77 90"
MY_PV=$(ver_cut 1-3)
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic fortran-2 python-any-r1 rocm toolchain-funcs

SRC_URI="https://icl.cs.utk.edu/projectsfiles/${PN}/downloads/${PN}-${MY_PV}.tar.gz"

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="
	https://icl.cs.utk.edu/magma/
	https://bitbucket.org/icl/magma
"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="
doc examples -ilp64 mkl openblas tbb openmp test
"

GPU_FRAMEWORKS=""
if [[ "${MAGMA_CUDA}" == "1" ]] ; then
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
			>=dev-util/nvidia-cuda-toolkit-7.5:=
			sys-devel/gcc:11
			cuda_targets_sm_35? (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
			)
			cuda_targets_sm_37? (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
			)
			cuda_targets_sm_50? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
			cuda_targets_sm_60? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
			cuda_targets_sm_70? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
			cuda_targets_sm_75? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
			cuda_targets_sm_80? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
			cuda_targets_sm_90? (
				|| (
					=dev-util/nvidia-cuda-toolkit-11.8*:=
					=dev-util/nvidia-cuda-toolkit-12*:=
				)
			)
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
					~dev-util/hip-${pv}:${slot}
					~sci-libs/hipBLAS-${pv}:${slot}
					~sci-libs/hipSPARSE-${pv}:${slot}
				)
			"
		done
	}
	RDEPEND+="
		rocm? (
			dev-util/hip:=
			dev-util/rocm-compiler[system-llvm=]
			|| (
				$(gen_rocm_rdepend)
			)
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
		openblas
		mkl
	)
"
# TODO: do not enforce openblas
#	hip? ( sci-libs/hipBLAS )
RDEPEND+="
	!openblas? (
		virtual/blas
		virtual/lapack
	)
	sci-libs/hipBLAS
	sys-devel/gcc[fortran]
	mkl? (
		sci-libs/mkl
	)
	openblas? (
		sci-libs/lapack
		sci-libs/openblas
	)
	tbb? (
		dev-cpp/tbb:0
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
		>=app-doc/doxygen-1.8.14-r1[dot]
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.7.1-path-changes.patch"
	"${FILESDIR}/${PN}-2.7.1-make-inc.patch"
	"${FILESDIR}/${PN}-2.7.1-mkl.patch"
)
S="${WORKDIR}/${PN}-${MY_PV}"

icl-magma-v2_7_pkg_setup() {
	fortran-2_pkg_setup
	python-any-r1_pkg_setup
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		rocm_pkg_setup
	fi
	tc-check-openmp || die "Need OpenMP to compile ${P}"
	if use mkl ; then
		source "/opt/intel/oneapi/mkl/latest/env/vars.sh"
	fi
}

gen_pc_file() {
	local _prefix
	if [[ "${MAGMA_CUDA}" == "1" ]] ; then
		_prefix="${EPREFIX}/usr"
	elif [[ "${MAGMA_ROCM}" == "1" ]] ; then
		_prefix="${EPREFIX}/${EROCM_PATH}"
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

replace_symbols() {
	IFS=$'\n'

	local llvm_slot
	if [[ "${ROCM_SLOT}" == "5.7" ]] ; then
		llvm_slot=16
	elif [[ "${ROCM_SLOT}" == "5.6" ]] ; then
		llvm_slot=16
	elif [[ "${ROCM_SLOT}" == "5.5" ]] ; then
		llvm_slot=16
	elif [[ "${ROCM_SLOT}" == "5.4" ]] ; then
		llvm_slot=15
	elif [[ "${ROCM_SLOT}" == "5.3" ]] ; then
		llvm_slot=15
	elif [[ "${ROCM_SLOT}" == "5.2" ]] ; then
		llvm_slot=14
	elif [[ "${ROCM_SLOT}" == "5.1" ]] ; then
		llvm_slot=14
	else
		# Not installed or disable
		llvm_slot=-1
	fi

	# For GPU
	# /opt/aomp/@AOMP_SLOT@/ for multislotted aomp
	local aomp_slot # If 0, then unislot.
	if has_version "=sys-devel/aomp-16*:16" && [[ "${ROCM_SLOT}" == "5.7" ]] ; then
		aomp_slot=16
	elif has_version "=sys-devel/aomp-16*:16" && [[ "${ROCM_SLOT}" == "5.6" ]] ; then
		aomp_slot=16
	elif has_version "=sys-devel/aomp-16*:16" && [[ "${ROCM_SLOT}" == "5.5" ]] ; then
		aomp_slot=16
	elif has_version "=sys-devel/aomp-15*:15" && [[ "${ROCM_SLOT}" == "5.4" ]] ; then
		aomp_slot=15
	elif has_version "=sys-devel/aomp-15*:15" && [[ "${ROCM_SLOT}" == "5.3" ]] ; then
		aomp_slot=15
	elif has_version "=sys-devel/aomp-14*:14" && [[ "${ROCM_SLOT}" == "5.2" ]] ; then
		aomp_slot=14
	elif has_version "=sys-devel/aomp-14*:14" && [[ "${ROCM_SLOT}" == "5.1" ]] ; then
		aomp_slot=14
	elif has_version "=sys-devel/aomp-16*:0" && [[ "${ROCM_SLOT}" == "5.7" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-16*:0" && [[ "${ROCM_SLOT}" == "5.6" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-16*:0" && [[ "${ROCM_SLOT}" == "5.5" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-15*:0" && [[ "${ROCM_SLOT}" == "5.4" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-15*:0" && [[ "${ROCM_SLOT}" == "5.3" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-15*:0" && [[ "${ROCM_SLOT}" == "5.2" ]] ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-14*:0" && [[ "${ROCM_SLOT}" == "5.1" ]] ; then
		aomp_slot=0
	else
		# Not installed or disable
		aomp_slot=-1
	fi

	if (( ${aomp_slot} > 0 )) ; then
einfo "Using AOMP (multislot)"
		sed -i -e "s|@AOMP_SLOT@|${aomp_slot}|g" \
			$(grep -r -l -e "@AOMP_SLOT@" "${WORKDIR}") \
			|| true
	elif (( ${aomp_slot} == 0 )) ; then
einfo "Using AOMP (unislot)"
		# Assumes install in @EPREFIX@/usr/lib/aomp
		sed -i -e "s|-I/opt/aomp/@AOMP_SLOT@/include|-I/usr/aomp/include|g" \
			$(grep -r -l -e "@AOMP_SLOT@/include" "${WORKDIR}") \
			|| true
		sed -i -e "s|-L/opt/aomp/@AOMP_SLOT@/@LIBDIR@|-L/usr/aomp/@LIBDIR@|g" \
			$(grep -r -l -e "@AOMP_SLOT@/@LIBDIR@" "${WORKDIR}") \
			|| true
	elif (( ${llvm_slot} > 0 )) ; then
einfo "Using LLVM proper"
		sed -i -e "s|-I/opt/aomp/@AOMP_SLOT@/include|-I@ESYSROOT_LLVM_PATH@/include|g" \
			$(grep -r -l -e "@AOMP_SLOT@/include" "${WORKDIR}") \
			|| true
		sed -i -e "s|-L/opt/aomp/@AOMP_SLOT@/@LIBDIR@|-L@ESYSROOT_LLVM_PATH@/@LIBDIR@|g" \
			$(grep -r -l -e "@AOMP_SLOT@/@LIBDIR@" "${WORKDIR}") \
			|| true
	else
einfo "Removing AOMP references"
		sed -i -e "s|-I/opt/aomp/@AOMP_SLOT@/include||g" \
			$(grep -r -l -e "@AOMP_SLOT@/include" "${WORKDIR}") \
			|| true
		sed -i -e "s|-L/opt/aomp/@AOMP_SLOT@/@LIBDIR@||g" \
			$(grep -r -l -e "@AOMP_SLOT@/@LIBDIR@" "${WORKDIR}") \
			|| true
	fi

	sed -i -e "s|@LIBDIR@|$(get_libdir)|g" \
		$(grep -r -l -e "@LIBDIR@" "${WORKDIR}") \
		|| true
	sed -i -e "s|@EPREFIX@|${EPREFIX}|g" \
		$(grep -r -l -e "@EPREFIX@" "${WORKDIR}") \
		|| true
	sed -i -e "s|@ESYSROOT@|${ESYSROOT}|g" \
		$(grep -r -l -e "@ESYSROOT@" "${WORKDIR}") \
		|| true

	IFS=$' \t\n'
}

generate_precisions() {
	local inc_file
	if has cuda ${IUSE} && use cuda && use mkl && use ilp64 ; then
		inc_file="make.inc.mkl-gcc-ilp64"
	elif has cuda ${IUSE} && use cuda && use mkl ; then
		inc_file="make.inc.mkl-gcc"
	elif has cuda ${IUSE} && use cuda && use openblas ; then
		inc_file="make.inc.openblas"
	elif has rocm ${IUSE} && use rocm && use mkl && use ilp64 ; then
		inc_file="make.inc.hip-gcc-mkl-ilp64"
	elif has rocm ${IUSE} && use rocm && use mkl ; then
		inc_file="make.inc.hip-gcc-mkl"
	elif has rocm ${IUSE} && use rocm && use openblas ; then
		inc_file="make.inc.hip-gcc-openblas"
	else
		local gpu_targets
		if [[ "${MAGMA_CUDA}" == "1" ]] ; then
			gpu_targets+="cuda "
		fi
		if [[ "${MAGMA_ROCM}" == "1" ]] ; then
			gpu_targets+="rocm "
		fi

eerror
eerror "You must choose one of the following USE flags per row:"
eerror
eerror "GPU target:  ${gpu_targets}"
eerror "CPU target:  mkl openblas"
eerror
		die
	fi

	rm -f make.inc || true
	ln -s \
		"make.inc-examples/${inc_file}" \
		"make.inc" \
		|| die

	if use openblas ; then
		export OPENBLASDIR="/usr"
	fi

	if has cuda ${IUSE} && use cuda ; then
		export CUDADIR="/opt/cuda"
		export gpu="$(get_cuda_flags)"
		local gcc_slot=11
		local gcc_current_profile=$(gcc-config -c)
		local gcc_current_profile_slot=${gcc_current_profile##*-}
		if [[ "${gcc_current_profile_slot}" -ne "${gcc_slot}" ]] ; then
eerror
eerror "You must switch to == GCC ${gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
			die
		fi
	elif has rocm ${IUSE} && use rocm ; then
		export gpu="$(get_amdgpu_flags)"
	fi
	sed -i \
		-e "s|@GPU_TARGET_OVERRIDE@|GPU_TARGET = ${gpu}|g" \
		$(realpath make.inc) \
		|| die

	# Already generated
	sed -i \
		-e "/make.gen.hipMAGMA/d" \
		"Makefile" \
		|| die

	emake generate
}

icl-magma-v2_7_src_prepare() {
	# Let build script handle it.
	unset CC
	unset CXX

	cmake_src_prepare
	replace_symbols
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		rocm_src_prepare
	else
		sed -i -e "s|@ESYSROOT_ROCM_PATH@|/opt/rocm|g" \
			$(grep -r -l -e "@ESYSROOT_ROCM_PATH@" "${WORKDIR}") \
			|| true
		sed -i -e "s|@EPREFIX_ROCM_PATH@|/opt/rocm|g" \
			$(grep -r -l -e "@EPREFIX_ROCM_PATH@" "${WORKDIR}") \
			|| true
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

icl-magma-v2_7_src_configure() {
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DUSE_FORTRAN=ON
	)
	if has cuda ${IUSE} ; then
		mycmakeargs+=(
			-DMAGMA_ENABLE_CUDA=$(usex cuda ON OFF)
		)
	else
		mycmakeargs+=(
			-DMAGMA_ENABLE_CUDA=OFF
		)
	fi

	if has rocm ${IUSE} ; then
		mycmakeargs+=(
			-DMAGMA_ENABLE_HIP=$(usex rocm ON OFF)
		)
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

	if has cuda ${IUSE} && use cuda && use mkl ; then
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
	elif has rocm ${IUSE} && use rocm && use mkl ; then
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

	if has cuda ${IUSE} && use cuda ; then
		mycmakeargs+=(
			-DGPU_TARGET="$(get_cuda_flags)"
		)
	fi
	if has rocm ${IUSE} && use rocm ; then
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

icl-magma-v2_7_src_compile() {
	cmake_src_compile
}

icl-magma-v2_7_src_install() {
	cmake_src_install
	if [[ "${MAGMA_CUDA}" == "1" ]] ; then
		insinto "/usr/include/${PN}"
		doins include/*.h
		insinto "/usr/$(get_libdir)/pkgconfig"
	fi
	if [[ "${MAGMA_ROCM}" == "1" ]] ; then
		insinto "${EROCM_PATH}/include/${PN}"
		doins include/*.h
		insinto "${EROCM_PATH}/$(get_libdir)/pkgconfig"
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
