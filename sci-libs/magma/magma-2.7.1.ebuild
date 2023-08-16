# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx703
	gfx704
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx906
	gfx908
)
CUDA_TARGETS_COMPAT=(
	sm_30
	sm_35
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

inherit cmake fortran-2 rocm python-any-r1 toolchain-funcs

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
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	^^ (
		cuda
		rocm
	)
	cuda? (
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
	|| (
		${ROCM_REQUIRED_USE}
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
				~dev-util/hip-${PV}:${slot}
				~sci-libs/hipBLAS-${PV}:${slot}
				~sci-libs/hipSPARSE-${PV}:${slot}
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
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
			)
		)
		cuda_targets_sm_50? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
			)
		)
		cuda_targets_sm_60? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
			)
		)
		cuda_targets_sm_70? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
			)
		)
		cuda_targets_sm_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
			)
		)
		cuda_targets_sm_80? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
			)
		)
		cuda_targets_sm_90? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.8*:=
				=dev-util/nvidia-cuda-toolkit-12:=
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

src_prepare() {
	export gpu="$(get_amdgpu_flags)"

	gen_pc_file

	if use cuda ; then
		echo -e 'BACKEND = cuda' > make.inc || die
	elif use hip ; then
		echo -e 'BACKEND = hip' > make.inc || die
	fi
	echo -e 'FORT = true' >> make.inc || die
	echo -e "GPU_TARGET = ${gpu}" >> make.inc || die
	emake generate

	rm -r blas_fix || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_CXX_COMPILER=hipcc
		-DGPU_TARGET="${gpu}"
		-DMAGMA_ENABLE_CUDA=$(usex cuda ON OFF)
		-DMAGMA_ENABLE_HIP=$(usex hip ON OFF)
		-DUSE_FORTRAN=ON
	)

	if use openblas ; then
		mycmakeargs+=(
			-DBLA_VENDOR="OpenBLAS"
		)
	fi

	if use rocm ; then
		export CXX="${HIP_CXX:-hipcc}"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
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
