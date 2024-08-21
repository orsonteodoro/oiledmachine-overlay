# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CUDA_TARGETS_COMPAT=(
	sm_35
	sm_60
	sm_70
	sm_72
	sm_75
)
CLANG_COMPAT=( {18..15} )
MY_PV="${PV/_/-}"
inherit hip-versions
ROCM_VERSIONS=(
	"${HIP_6_2_VERSION}"
	"${HIP_6_1_VERSION}"
	"${HIP_6_0_VERSION}"
	"${HIP_5_7_VERSION}"
	"${HIP_5_6_VERSION}"
	"${HIP_5_5_VERSION}"
	"${HIP_5_4_VERSION}"
	"${HIP_5_3_VERSION}"
	"${HIP_5_2_VERSION}"
	"${HIP_5_1_VERSION}"
	"${HIP_4_5_VERSION}"
	"${HIP_4_1_VERSION}"
	# 3.7 inclusive
)
gen_rocm_iuse() {
	for ver in ${ROCM_VERSIONS[@]} ; do
		local s="${ver//./_}"
		s="${s%_*}"
		echo "
			rocm_${s}
		"
	done
}
ROCM_IUSE=(
	$(gen_rocm_iuse)
)
UCG_COMMIT="aaa65c30af52115aa601c9b17529cb295797864f"

inherit autotools dep-prepare flag-o-matic toolchain-funcs

KEYWORDS="~amd64 ~arm64 -riscv ~ppc64 ~x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/openucx/ucx/releases/download/v${PV}/${P}.tar.gz
https://github.com/openucx/xucg/archive/${UCG_COMMIT}.tar.gz
	-> xucg-${UCG_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Unified Communication X"
HOMEPAGE="https://openucx.org"
LICENSE="BSD"
SLOT="0"
IUSE="
${CLANG_COMPAT[@]/#/llvm_slot_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE[@]}
clang cma cuda dc debug devx dm gcc examples gdrcopy hip-clang mlx5-dv +numa
+openmp rc rocm threads tm ud verbs video_cards_intel
"
get_cuda_targets_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_iuse_required_use() {
	local u
	for u in ${ROCM_IUSE[@]} ; do
		echo "
			${u}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_iuse_required_use)
	$(get_cuda_targets_required_use)
	?? (
		cuda
		rocm
	)
	^^ (
		gcc
		clang
		hip-clang
	)
	clang? (
		^^ (
			${CLANG_COMPAT[@]/#/llvm_slot_}
		)
	)
	cuda? (
		gcc
	)
	gdrcopy? (
		cuda
	)
	rocm? (
		^^ (
			${ROCM_IUSE[@]}
		)
	)
"
gen_rocm_rdepend() {
	local u
	for u in ${ROCM_IUSE[@]} ; do
		local s
		s="${u/rocm_}"
		s="${s//./_}"
		echo "
			${u}? (
				dev-util/hip:${s}
			)
		"
	done
}
CUDA_TOOLKIT_11_8_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-11.8*
		=sys-devel/gcc-12*
	)
"
CUDA_TOOLKIT_12_3_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.3*
		=sys-devel/gcc-12*
	)
"
CUDA_TOOLKIT_12_4_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.4*
		=sys-devel/gcc-13*
	)
"
CUDA_TOOLKIT_12_5_DEPENDS="
	(
		=dev-util/nvidia-cuda-toolkit-12.5*
		=sys-devel/gcc-13*
	)
"
RDEPEND="
	$(gen_rocm_rdepend)
	cma? (
		>=sys-libs/glibc-2.15
	)
	cuda_targets_sm_35? (
		${CUDA_TOOLKIT_11_8_DEPENDS}
	)
	cuda_targets_sm_60? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_70? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_72? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda_targets_sm_75? (
		|| (
			${CUDA_TOOLKIT_11_8_DEPENDS}
			${CUDA_TOOLKIT_12_3_DEPENDS}
			${CUDA_TOOLKIT_12_4_DEPENDS}
			${CUDA_TOOLKIT_12_5_DEPENDS}
		)
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-8.0
		dev-util/nvidia-cuda-toolkit:=
	)
	dc? (
		sys-cluster/rdma-core
	)
	debug? (
		sys-libs/binutils-libs:=
	)
	devx? (
		sys-cluster/rdma-core
	)
	dm? (
		sys-cluster/rdma-core
	)
	gdrcopy? (
		dev-libs/gdrcopy
	)
	mlx5-dv? (
		sys-cluster/rdma-core
	)
	numa? (
		sys-process/numactl
	)
	rc? (
		sys-cluster/rdma-core
	)
	rocm? (
		dev-util/hip:=
	)
	ud? (
		sys-cluster/rdma-core
	)
	tm? (
		sys-cluster/rdma-core
	)
	video_cards_intel? (
		dev-libs/intel-compute-runtime[l0]
		dev-libs/level-zero:=
	)
	verbs? (
		sys-cluster/rdma-core
	)
"
DEPEND="
	${RDEPEND}
"
gen_clang_bdepend() {
	local s
	for s in ${CLANG_COMPAT[@]} ; do
		echo "
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
			sys-devel/lld:${s}
			openmp? (
				sys-libs/libomp:${s}
			)
		"
	done
}
gen_hip_clang_bdepend() {
	local pv
	for pv in ${ROCM_VERSIONS[@]} ; do
		echo "
			=sys-devel/gcc-12*
			~sys-devel/llvm-roc-${pv}:${pv%.*}
			openmp? (
				~sys-libs/llvm-roc-libomp-${pv}:${pv%.*}
			)
		"
	done
}
BDEPEND="
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
	gcc? (
		sys-devel/gcc[openmp?]
		sys-devel/binutils
	)
	clang? (
		$(gen_clang_bdepend)
	)
	hip-clang? (
		$(gen_hip_clang_bdepend)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.13.0-drop-werror.patch"
	"${FILESDIR}/${PN}-1.17.0-no-rpm-sandbox.patch"
)

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

_init_rocm_variables() {
	if use rocm ; then
		local ver
		for ver in ${ROCM_VERSIONS[@]} ; do
			local s="${ver//./_}"
			s="${s%_*}"
			if use "rocm_${s}" ; then
				export ROCM_SLOT="${ver%.*}"
				local n="HIP_${s}_VERSION"
				export ROCM_VERSION="${!n}"
				break
			fi
		done
	fi
}

check_libstdcxx() {
	local slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${slot}" ; then
eerror
eerror "You must switch to GCC ${slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

pkg_setup() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
	_init_rocm_variables
	if use clang ; then
		local s
		for s in ${CLANG_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_SLOT="${s}"
				break
			fi
		done
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "\|/usr/lib/llvm|d" \
			| tr "\n" ":")
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	fi
	if use hip-clang ; then
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/opt/rocm-${ROCM_VERSION}/bin:/opt/rocm-${ROCM_VERSION}/llvm-bin|g")
	fi
}

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/xucg-${UCG_COMMIT}" "${S}/src/ucg"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if use gcc ; then
		local gcc_slot=12
		if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
			gcc_slot="12"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.3*" ; then
			gcc_slot="12"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
			gcc_slot="13"
		elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
			gcc_slot="13"
		elif use rocm ; then
			gcc_slot="12"
		fi
		export CC="${CHOST}-gcc-${gcc_slot}"
		export CXX="${CHOST}-g++-${gcc_slot}"
		filter-flags '-fuse-ld=bfd'
	elif use clang ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		filter-flags '-fuse-ld=lld'
	elif use hip-clang ; then
		export CC="hipcc"
		export CXX="hipcc"
		filter-flags '-fuse-ld=lld'
	fi
	${CC} --version || die
	strip-unsupported-flags
	if use debug ; then
		filter-flags '-fuse-ld=*'
		append-ldflags '-fuse-ld=bfd'
	fi

	BASE_CFLAGS="" \
	local myconf=(
		--disable-doxygen-doc
		--disable-compiler-opt
		--without-fuse3
		--without-go
		--without-java
		$(use_enable examples)
		$(use_enable numa)
		$(use_enable openmp)
		$(use_enable threads mt)
		$(use_with dc)
		$(use_with debug bfd)
		$(use_with devx)
		$(use_with dm)
		$(use_with mlx5-dv)
		$(use_with rc)
		$(use_with ud)
	)

	if use cuda ; then
		myconf+=(
			--with-cuda="${ESYSROOT}/opt/cuda"
		)
	else
		myconf+=(
			--without-cuda
		)
	fi
	if use rocm ; then
		myconf+=(
			--with-rocm="${ESYSROOT}/opt/rocm-${ROCM_VERSION}"
		)
	else
		myconf+=(
			--without-rocm
		)
	fi
	if use gdrcopy ; then
		myconf+=(
			--with-gdrcopy="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-gdrcopy
		)
	fi

	if use clang && use openmp ; then
		append-cxxflags -I"${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/include" -fopenmp=libomp
	fi

	if use hip-clang && use openmp ; then
		append-cxxflags -I"${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm/include" -fopenmp=libomp
	fi

	if use tm ; then
		myconf+=(
			--with-ib-hw-tm=upstream
		)
	else
		myconf+=(
			--without-ib-hw-tm
		)
	fi

	if use verbs ; then
		myconf+=(
			--with-verbs="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-verbs
		)
	fi

	if use video_cards_intel ; then
		myconf+=(
			--with-ze="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-ze
		)
	fi

	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
		check_libstdcxx 12
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.3*" ; then
		check_libstdcxx 12
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
		check_libstdcxx 13
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12.5*" ; then
		check_libstdcxx 13
	elif use rocm ; then
		check_libstdcxx 12
	fi

	econf ${myconf[@]}
}

src_compile() {
	BASE_CFLAGS="" \
	emake
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
