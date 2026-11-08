# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-mpi}"

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

CHKL_TIMESTAMPS=(
	"dev-libs/libevent-9999"
	"sci-ml/therock-9999"
)

inherit chkl cuda flag-o-matic fortran-2 libtool multilib-minimal rocm-r1 secure-version

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
cma cuda custom-kernel cxx fortran hcoll ipv6 knem libompitrace peruse rocm romio
system-ucx ucx valgrind xpmem
ebuild_revision_6
"

REQUIRED_USE="
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
	system-ucx? (
		ucx
	)
"

RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/nullmpi
	!sys-cluster/pmix
	>=dev-libs/libevent-${LIBEVENT_PV}:=[${MULTILIB_USEDEP},threads(+)]
	>=sys-apps/hwloc-2.0.2:=[${MULTILIB_USEDEP}]
	>=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	dev-libs/libltdl:=[${MULTILIB_USEDEP}]
	cma? (
		>=sys-libs/glibc-${GLIBC_PV}:=
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
	)
	hcoll? (
		dev-util/DOCA-Host:=[hcoll]
	)
	openmpi_fabrics_ofed? (
		sys-cluster/rdma-core:=
	)
	openmpi_fabrics_knem? (
		sys-cluster/knem:=
	)
	openmpi_rm_pbs? (
		sys-cluster/torque:=
	)
	openmpi_rm_slurm? (
		sys-cluster/slurm:=
	)
	openmpi_ofed_features_rdmacm? (
		sys-cluster/rdma-core:=
	)
	rocm? (
		>=sci-ml/therock-${THEROCK_PV}:=
	)
	system-ucx? (
		sys-cluster/ucx:=
	)
"
DEPEND="
	${RDEPEND}
	valgrind? (
		>=dev-debug/valgrind-3.2.0:=
	)
"
BDEPEND="
	>=dev-build/automake-1.15
	>=dev-build/autoconf-2.69.0
	>=dev-build/libtool-2.4.6
	>=sys-devel/flex-2.5.4
	rocm? (
		>=sci-ml/therock-${THEROCK_PV}:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.1.6-incompatible-pointers.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
	rocm-r1_pkg_setup

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
einfo "Copying sources for ROCm"
		cp -a "${S}" "${S}_rocm" || die
	fi
}

_configure() {
	chkl_check_many_timestamps
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
			--libdir="${ROCM_PATH}/lib"
			--prefix="${ROCM_PATH}"
			--with-rocm="${ESYSROOT}${ROCM_PATH}"
		)

		filter-flags \
			'-fuse-ld=*' \
			'-Wl,-fuse-ld=lld'
		append-flags \
			'-Wl,-fuse-ld=lld'
		_econf_source="${S}_rocm"
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
	econf "${myconf[@]}"
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
		USE_ROCM=0 _configure
		_compile
	done
	if use rocm ; then
		pushd "${S}_rocm" >/dev/null 2>&1 || die
einfo "Building for ROCm ${pv}"
			USE_ROCM=1 _configure
			_compile
		popd >/dev/null 2>&1 || die
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
		prefix="${ROCM_PATH}"
		suffix="_rocm"
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
			prefix="${ROCM_PATH}"
			suffix="_rocm"
			mv "${T}/fortran${suffix}/mpif"* "${ED}${prefix}/include" || die
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
einfo "Installing for ROCm"
		pushd "${S}_rocm" >/dev/null 2>&1 || die
			_install
		popd >/dev/null 2>&1 || die
		# TODO: verify rocm rpath
	fi

	_install_all
}
