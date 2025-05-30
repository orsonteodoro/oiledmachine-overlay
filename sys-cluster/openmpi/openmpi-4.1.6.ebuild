# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-mpi}"

FLAG_O_MATIC_FILTER_LTO=1
FORTRAN_NEEDED="fortran"
IUSE_OPENMPI_FABRICS="
	openmpi_fabrics_knem
	openmpi_fabrics_ofed
"

IUSE_OPENMPI_RM="
	openmpi_rm_pbs
	openmpi_rm_slurm
"

IUSE_OPENMPI_OFED_FEATURES="
	openmpi_ofed_features_control-hdr-padding
	openmpi_ofed_features_dynamic-sl
	openmpi_ofed_features_udcm
	openmpi_ofed_features_rdmacm
"
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/mpi.h"
	"/usr/include/openmpi/mpiext/mpiext_cuda_c.h"
)
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
)
gen_rocm_iuse() {
	local pv
	for pv in ${ROCM_VERSIONS[@]} ; do
		local s="${pv%.*}"
		s="${s/./_}"
		echo " rocm_${s}"
	done
}
ROCM_IUSE=(
	$(gen_rocm_iuse)
)

inherit cuda flag-o-matic fortran-2 libtool multilib-minimal rocm

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://www.open-mpi.org/software/ompi/v$(ver_cut 1-2)/downloads/${MY_P}.tar.bz2"

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="
	https://www.open-mpi.org
	https://github.com/open-mpi/ompi
"
LICENSE="BSD"
SLOT="0"
IUSE="
${IUSE_OPENMPI_FABRICS}
${IUSE_OPENMPI_OFED_FEATURES}
${IUSE_OPENMPI_RM}
${ROCM_IUSE[@]}
cma cuda custom-kernel cxx fortran hcoll ipv6 knem libompitrace peruse rocm romio
system-ucx ucx valgrind xpmem
ebuild_revision_4
"

gen_rocm_iuse_required_use() {
	local pv
	for pv in ${ROCM_VERSIONS[@]} ; do
		local s="${pv%.*}"
		s="${s/./_}"
		echo "
			rocm_${s}? (
				rocm
			)
		"
	done

}

REQUIRED_USE="
	$(gen_rocm_iuse_required_use)
	openmpi_rm_slurm? (
		!openmpi_rm_pbs
	)
	openmpi_rm_pbs? (
		!openmpi_rm_slurm
	)
	openmpi_ofed_features_control-hdr-padding? (
		openmpi_fabrics_ofed
	)
	openmpi_ofed_features_dynamic-sl? (
		openmpi_fabrics_ofed
	)
	openmpi_ofed_features_udcm? (
		openmpi_fabrics_ofed
	)
	openmpi_ofed_features_rdmacm? (
		openmpi_fabrics_ofed
	)
	rocm? (
		|| (
			${ROCM_IUSE[@]}
		)
	)
	system-ucx? (
		ucx
	)
"

RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/nullmpi
	!sys-cluster/pmix
	>=dev-libs/libevent-2.0.22:=[${MULTILIB_USEDEP},threads(+)]
	>=sys-apps/hwloc-2.0.2:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	cma? (
		>=sys-libs/glibc-2.15
		!custom-kernel? (
			|| (
				>=sys-kernel/gentoo-sources-3.2
				>=sys-kernel/vanilla-sources-3.2
				>=sys-kernel/git-sources-3.2
				>=sys-kernel/mips-sources-3.2
				>=sys-kernel/pf-sources-3.2
				>=sys-kernel/rt-sources-3.2
				>=sys-kernel/zen-sources-3.2
				>=sys-kernel/raspberrypi-sources-3.2
				>=sys-kernel/gentoo-kernel-3.2
				>=sys-kernel/gentoo-kernel-bin-3.2
				>=sys-kernel/vanilla-kernel-3.2
				>=sys-kernel/linux-next-3.2
				>=sys-kernel/asahi-sources-3.2
				>=sys-kernel/ot-sources-3.2
			)
		)
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-6.5.19-r1:=
		dev-util/nvidia-cuda-toolkit:=
	)
	hcoll? (
		dev-util/DOCA-Host[hcoll]
	)
	openmpi_fabrics_ofed? (
		sys-cluster/rdma-core
	)
	openmpi_fabrics_knem? (
		sys-cluster/knem
	)
	openmpi_rm_pbs? (
		sys-cluster/torque
	)
	openmpi_rm_slurm? (
		sys-cluster/slurm
	)
	openmpi_ofed_features_rdmacm? (
		sys-cluster/rdma-core
	)
	system-ucx? (
		sys-cluster/ucx
	)
"
DEPEND="
	${RDEPEND}
	valgrind? (
		>=dev-debug/valgrind-3.2.0
	)
"
BDEPEND="
	>=dev-build/automake-1.15
	>=dev-build/autoconf-2.69.0
	>=dev-build/libtool-2.4.6
	>=sys-devel/flex-2.5.4
"
PATCHES=(
	"${FILESDIR}/${PN}-4.1.6-incompatible-pointers.patch"
)

pkg_setup() {
	fortran-2_pkg_setup

elog
elog "OpenMPI has an overwhelming count of configuration options.  Don't forget"
elog "the EXTRA_ECONF environment variable can let you specify configure"
elog "options if you find them necessary."
elog
}

src_prepare() {
	default
	elibtoolize

	# Avoid test which ends up looking at system mounts
	echo \
		"int main() { return 0; }" \
		> \
		"test/util/opal_path_nfs.c" \
		|| die

	# Necessary for scalibility, see
	# http://www.open-mpi.org/community/lists/users/2008/09/6514.php
	echo \
		'oob_tcp_listen_mode = listen_thread' \
		>> \
		"opal/etc/openmpi-mca-params.conf" \
		|| die
	if use rocm ; then
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
einfo "Copying sources for ROCm ${pv}"
				local ROCM_SLOT="${pv%.*}"
				cp -a "${S}" "${S}_rocm_${s}" || die
			fi
		done
	fi
}

_configure() {
einfo "ABI:  ${ABI}"
einfo "get_libdir:  $(get_libdir)"
	# -Werror=lto-type-mismatch, -Werror=strict-aliasing
	# The former even prevents successfully running ./configure, but both appear
	# at `make` time as well.
	# https://bugs.gentoo.org/913040
	# https://github.com/open-mpi/ompi/issues/12674
	# https://github.com/open-mpi/ompi/issues/12675
	append-flags -fno-strict-aliasing
	filter-lto

	local myconf=(
		$(use_enable cxx mpi-cxx)
		$(use_enable ipv6)
		$(use_enable libompitrace)
		$(use_enable peruse)
		$(use_enable romio io-romio)
		$(use_with cma)
		$(multilib_native_use_enable openmpi_ofed_features_control-hdr-padding openib-control-hdr-padding)
		$(multilib_native_use_enable openmpi_ofed_features_dynamic-sl openib-dynamic-sl)
		$(multilib_native_use_enable openmpi_ofed_features_rdmacm openib-rdmacm)
		$(multilib_native_use_enable openmpi_ofed_features_udcm openib-udcm)
		$(multilib_native_use_with valgrind)
		$(multilib_native_use_with openmpi_fabrics_ofed verbs "${ESYSROOT}/usr")
		$(multilib_native_use_with openmpi_fabrics_knem knem "${ESYSROOT}/usr")
		$(multilib_native_use_with openmpi_rm_pbs tm)
		$(multilib_native_use_with openmpi_rm_slurm slurm)
		--disable-mpi-java
	# configure takes a looooong time, but upstream currently forced
	# the constriants on caching based on
	# https://github.com/open-mpi/ompi/blob/9eec56222a5c98d13790c9ee74877f1562ac27e8/config/opal_config_subdir.m4#L118
	# so no --cache-dir option for now.
		--enable-mpi-fortran=$(usex fortran all no)
		--enable-orterun-prefix-by-default
		--enable-pretty-print-stacktrace
		--sysconfdir="${ESYSROOT}/etc/${PN}"
		--with-hwloc="${ESYSROOT}/usr"
		--with-hwloc-libdir="${ESYSROOT}/usr/$(get_libdir)"
		--with-libevent="${ESYSROOT}/usr"
		--with-libevent-libdir="${ESYSROOT}/usr/$(get_libdir)"
		--with-libltdl="${ESYSROOT}/usr"
	# unkeyworded, lacks multilib. Do not automagically build against it.
		--with-pmix=internal
	#
	# Re-enable heterogeneous for 5.0!
	#
	# See
	#
	#   https://github.com/open-mpi/ompi/issues/9697#issuecomment-1003746357
	#
	# and
	#
	#   https://bugs.gentoo.org/828123#c14
	#
		--disable-heterogeneous
	)

	if use hcoll ; then
		myconf+=(
			--with-hcoll="${ESYSROOT}/opt/mellanox/hcoll"
		)
	else
		myconf+=(
			--without-hcoll
		)
	fi

	if use knem ; then
		myconf+=(
			--with-knem="${ESYSROOT}/usr"
		)
	else
		myconf+=(
			--without-knem
		)
	fi

	if use ucx ; then
		if use system-ucx ; then
			myconf+=(
				--with-ucx="${ESYSROOT}/usr"
			)
		else
			myconf+=(
				--with-ucx
			)
		fi
	else
		myconf+=(
			--without-ucx
		)
	fi

	if use xpmem ; then
		myconf+=(
			--with-xpmem="${ESYSROOT}/usr/include"
			--with-xpmem-libdir="${ESYSROOT}/usr/$(get_libdir)"
		)
	else
		myconf+=(
			--without-xpmem
		)
	fi

	local _econf_source
	if [[ "${USE_ROCM}" == "1" ]] ; then
		myconf+=(
			--libdir="/opt/rocm-${ROCM_VERSION}/lib"
			--prefix="/opt/rocm-${ROCM_VERSION}"
			--with-rocm="${ESYSROOT}/opt/rocm-${ROCM_VERSION}"
		)

		local EROCM_PATH="/opt/rocm-${ROCM_VERSION}"
		filter-flags \
			'-fuse-ld=*' \
			'-Wl,-fuse-ld=lld'
		append-flags \
			'-Wl,-fuse-ld=lld'
		_econf_source="${S}_rocm_${s}"
	else
		myconf+=(
			$(multilib_native_use_with cuda cuda "${ESYSROOT}/opt/cuda")
			--prefix="/usr"
			--without-rocm
		)
		_econf_source="${S}"

	fi
	CONFIG_SHELL="${BROOT}/bin/bash" \
	ECONF_SOURCE="${_econf_source}" \
	econf ${myconf[@]}
}

_compile() {
	emake V=1
}

src_configure() {
	:
}

src_compile() {
	local pairs
	for pairs in $(multilib_get_enabled_abi_pairs) ; do
einfo "Building for system"
		ABI="${pairs#*.}"
		_configure
		_compile
	done
	if use rocm ; then
		local USE_ROCM=1
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
				local ROCM_SLOT="${pv%.*}"
				local rocm_version="HIP_${s}_VERSION"
				local ROCM_VERSION="${!rocm_version}"
				local llvm_slot="HIP_${s}_LLVM_SLOT"
				LLVM_SLOT="${!llvm_slot}"
				pushd "${S}_rocm_${s}" >/dev/null 2>&1 || die
einfo "Building for ROCm ${pv}"
					rocm_pkg_setup
					_configure
					_compile
				popd >/dev/null 2>&1 || die
			fi
		done
		USE_ROCM=0
	fi
}

src_test() {
	local pairs
	for pairs in $(multilib_get_enabled_abi_pairs) ; do
		ABI="${pairs#*.}"
		emake -C "test" "check"
	done
}

_install() {
	default

	local prefix
	local suffix
	if [[ "${USE_ROCM}" == "1" ]] ; then
		prefix="/opt/rocm-${ROCM_VERSION}"
		suffix="_rocm_${s}"
	else
		prefix="/usr"
		suffix=""
	fi

	# The fortran header cannot be wrapped (bug #540508), workaround part 1.
	if multilib_is_native_abi && use fortran ; then
		mkdir "${T}/fortran${suffix}" || die
		mv "${ED}${prefix}/include/mpif"* "${T}/fortran" || die
	else
		# some fortran files get installed unconditionally
		rm \
			"${ED}${prefix}/include/mpif"* \
			"${ED}${prefix}/bin/mpif"* \
			|| die
	fi
}

_install_all() {
	# The fortran header cannot be wrapped (bug #540508), workaround part 2.
	if use fortran ; then
		local prefix="/usr"
		local suffix=""
		mv "${T}/fortran/mpif"* "${ED}${prefix}/include" || die

		if use rocm ; then
			local pv
			for pv in ${ROCM_VERSIONS[@]} ; do
				local s="${pv}"
				s="${s%.*}"
				s="${s/./_}"
				if use "rocm_${s}" ; then
					prefix="/opt/rocm-${ROCM_VERSION}"
					suffix="_rocm_${s}"
					mv "${T}/fortran${suffix}/mpif"* "${ED}${prefix}/include" || die
				fi
			done
		fi
	fi

	# Remove la files, no static libs are installed and we have pkg-config
	find "${ED}" -name '*.la' -delete || die

	einstalldocs
}

src_install() {
	local pairs
	for pairs in $(multilib_get_enabled_abi_pairs) ; do
		ABI="${pairs#*.}"
		_install
	done
	if use rocm ; then
		local USE_ROCM=1
		local pv
		for pv in ${ROCM_VERSIONS[@]} ; do
			local s="${pv}"
			s="${s%.*}"
			s="${s/./_}"
			if use "rocm_${s}" ; then
einfo "Installing for ROCm ${pv}"
				local ROCM_SLOT="${pv%.*}"
				local rocm_version="HIP_${s}_VERSION"
				local ROCM_VERSION="${!rocm_version}"
				pushd "${S}_rocm_${s}" >/dev/null 2>&1 || die
					_install
				popd >/dev/null 2>&1 || die
				EROCM_PATH="/opt/rocm-${ROCM_VERSION}"
				EROCM_CLANG_PATH="/opt/rocm-${ROCM_VERSION}/llvm/$(rocm_get_libdir)/clang/${CLANG_SLOT}"
				EROCM_LLVM_PATH="/opt/rocm-${ROCM_VERSION}/llvm"
				rocm_fix_rpath "${ED}/opt/rocm-${ROCM_VERSION}"
			fi
		done
		USE_ROCM=0
	fi

	_install_all
}
