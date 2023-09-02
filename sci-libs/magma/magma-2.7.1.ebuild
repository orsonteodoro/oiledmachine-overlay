# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#50200000
#5.623356

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
MY_PV=$(ver_rs 3 '-')
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SKIP_COMMON_PATHS_PATCHES=1

inherit cmake flag-o-matic fortran-2 python-any-r1 rocm toolchain-funcs

SRC_URI="https://icl.cs.utk.edu/projectsfiles/${PN}/downloads/${PN}-${MY_PV}.tar.gz"

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="
	https://icl.cs.utk.edu/magma/
	https://bitbucket.org/icl/magma
"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${ROCM_IUSE}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
doc cuda rocm openblas examples test
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
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
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
ROCM_SLOTS=(
	"5.6.0"
	"5.5.1"
	"5.4.3"
	"5.3.3"
)
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
# TODO: do not enforce openblas
#	hip? ( sci-libs/hipBLAS )
RDEPEND="
	!openblas? (
		virtual/blas
		virtual/lapack
	)
	sci-libs/hipBLAS
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-7.5:=
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
	openblas? (
		sci-libs/openblas
	)
	rocm? (
		dev-util/hip:=
		|| (
			$(gen_rocm_rdepend)
		)
	)
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
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
)

pkg_setup() {
	fortran-2_pkg_setup
	python-any-r1_pkg_setup
	tc-check-openmp || die "Need OpenMP to compile ${P}"
}

gen_pc_file() {
# The distributed pc file is not so useful so replace it.
cat <<-EOF > ${PN}.pc || die
prefix=${EPREFIX}/usr
libdir=\${prefix}/$(get_libdir)
includedir=\${prefix}/include/${PN}
Name: ${PN}
Description: ${DESCRIPTION}
Version: ${PV}
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
	if has_version "~dev-util/hip-5.6.0" ; then
		llvm_slot=16
	elif has_version "~dev-util/hip-5.5.1" ; then
		llvm_slot=16
	elif has_version "~dev-util/hip-5.4.3"; then
		llvm_slot=15
	elif has_version "~dev-util/hip-5.3.3" ; then
		llvm_slot=15
	elif has_version "~dev-util/hip-5.1.3" ; then
		llvm_slot=14
	else
		# Not installed or disable
		llvm_slot=-1
	fi

	# For GPU
	# /opt/aomp/@AOMP_SLOT@/ for multislotted aomp
	local aomp_slot # If 0, then unislot.
	if has_version "=sys-devel/aomp-16*:16" && has_version "~dev-util/hip-5.6.0" ; then
		aomp_slot=16
	elif has_version "=sys-devel/aomp-16*:16" && has_version "~dev-util/hip-5.5.1" ; then
		aomp_slot=16
	elif has_version "=sys-devel/aomp-15*:15" && has_version "~dev-util/hip-5.4.3"; then
		aomp_slot=15
	elif has_version "=sys-devel/aomp-15*:16" && has_version "~dev-util/hip-5.3.3" ; then
		aomp_slot=15
	elif has_version "=sys-devel/aomp-14*:14" && has_version "~dev-util/hip-5.1.3" ; then
		aomp_slot=14
	elif has_version "=sys-devel/aomp-16*:0" && has_version "~dev-util/hip-5.6.0" ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-16*:0" && has_version "~dev-util/hip-5.5.1" ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-15*:0" && has_version "~dev-util/hip-5.4.3"; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-15*:0" && has_version "~dev-util/hip-5.3.3" ; then
		aomp_slot=0
	elif has_version "=sys-devel/aomp-14*:0" && has_version "~dev-util/hip-5.1.3" ; then
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
einfo "Using LLVM only"
		sed -i -e "s|-I/opt/aomp/@AOMP_SLOT@/include|-I/usr/lib/llvm/@LLVM_SLOT@/include|g" \
			$(grep -r -l -e "@AOMP_SLOT@/include" "${WORKDIR}") \
			|| true
		sed -i -e "s|-L/opt/aomp/@AOMP_SLOT@/@LIBDIR@|-L/usr/lib/llvm/@LLVM_SLOT@/@LIBDIR@|g" \
			$(grep -r -l -e "@AOMP_SLOT@/@LIBDIR@" "${WORKDIR}") \
			|| true
		sed -i -e "s|@LLVM_SLOT@|${llvm_slot}|g" \
			$(grep -r -l -e "@LLVM_SLOT@" "${WORKDIR}") \
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

src_prepare() {

	gen_pc_file

	if use cuda ; then
		echo -e 'BACKEND = cuda' > make.inc || die
		export gpu="$(get_cuda_flags)"
		echo -e "GPU_TARGET = ${gpu}" >> make.inc || die
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
	elif use rocm ; then
		echo -e 'BACKEND = hip' > make.inc || die
		export gpu="$(get_amdgpu_flags)"
		echo -e "GPU_TARGET = ${gpu}" >> make.inc || die
	fi
	echo -e 'FORT = true' >> make.inc || die
	emake generate

	rm -r blas_fix || die

	cmake_src_prepare

	replace_symbols
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

src_configure() {
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DMAGMA_ENABLE_CUDA=$(usex cuda ON OFF)
		-DMAGMA_ENABLE_HIP=$(usex rocm ON OFF)
		-DUSE_FORTRAN=ON
	)

	if use openblas ; then
		mycmakeargs+=(
			-DBLA_VENDOR="OpenBLAS"
		)
	fi

	if use cuda ; then
		mycmakeargs+=(
			-DGPU_TARGET="$(get_cuda_flags)"
		)
	fi
	if use rocm ; then
		local a
		local b
		local c
		local hip_pv=$(grep -r -e "set(PACKAGE_VERSION" \
			"${ESYSROOT}/usr/$(get_libdir)/cmake/hip/hip-config-version.cmake" \
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

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	insinto "/usr/include/${PN}"
	doins include/*.h
	insinto "/usr/$(get_libdir)/pkgconfig"
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
