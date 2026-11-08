# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED="fortran"
MY_P="${P/-mpi}"

IUSE_OPENMPI_FABRICS="
	openmpi_fabrics_knem
	openmpi_fabrics_ofed
"

IUSE_OPENMPI_RM="
	openmpi_rm_pbs
	openmpi_rm_slurm
"

CHKL_TIMESTAMPS=(
	"dev-libs/libevent-9999"
	"sci-ml/therock-9999"
)

inherit chkl cuda flag-o-matic fortran-2 libtool rocm-r1 secure-version

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://www.open-mpi.org/software/ompi/v$(ver_cut 1-2)/downloads/${MY_P}.tar.bz2"

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="https://www.open-mpi.org"
LICENSE="BSD"
SLOT="0"
IUSE="
${IUSE_OPENMPI_FABRICS}
${IUSE_OPENMPI_RM}
cma cuda custom-kernel fortran hcoll ipv6 peruse rocm romio system-ucx ucx valgrind
ebuild_revision_6
"

REQUIRED_USE="
	openmpi_rm_pbs? (
		!openmpi_rm_slurm
	)
	openmpi_rm_slurm? (
		!openmpi_rm_pbs
	)
	system-ucx? (
		ucx
	)
"

RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/nullmpi
	!sys-cluster/prrte
	>=dev-libs/libevent-${LIBEVENT_PV}:=[threads(+)]
	>=sys-apps/hwloc-2.7.1:=
	>=virtual/zlib-${ZLIB_PV}:=
	sys-cluster/pmix:=
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
	openmpi_fabrics_knem? (
		sys-cluster/knem:=
	)
	openmpi_fabrics_ofed? (
		sys-cluster/rdma-core:=
	)
	openmpi_rm_pbs? (
		sys-cluster/torque:=
	)
	openmpi_rm_slurm? (
		sys-cluster/slurm:=
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
	>=dev-build/automake-1.16.5
	>=dev-build/autoconf-2.69.0
	>=dev-build/libtool-2.4.6
	>=sys-devel/flex-2.5.4
	rocm? (
		>=sci-ml/therock-${THEROCK_PV}:=
	)
"

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
		$(use_enable ipv6)
		$(use_enable peruse)
		$(use_enable romio io-romio)
		$(use_with cma)
		$(use_with openmpi_fabrics_knem knem "${ESYSROOT}/usr")
		$(use_with openmpi_rm_pbs tm)
		$(use_with openmpi_rm_slurm slurm)
		$(use_with valgrind)

		--disable-mpi-java
	# configure takes a looooong time, but upstream currently forced
	# the constriants on caching base on
	# https://github.com/open-mpi/ompi/blob/9eec56222a5c98d13790c9ee74877f1562ac27e8/config/opal_config_subdir.m4#L118
	# so no --cache-dir option for now.
		--enable-mpi-fortran=$(usex fortran all no)
		--enable-prte-prefix-by-default
		--enable-pretty-print-stacktrace
		--sysconfdir="${ESYSROOT}/etc/${PN}"
		--with-hwloc=external
		--with-libevent=external
	#
	# Originally heterogeneous was supposed to be re-enabled for 5.0!
	#
	# See
	#
	#   https://github.com/open-mpi/ompi/issues/9697#issuecomment-1003746357
	#
	# and
	#
	#   https://bugs.gentoo.org/828123#c14
	#
	# However as of 5.0.3 the docs still say:
	#
	#   As such, supporting data heterogeneity is a feature that has fallen
	#   into disrepair and is currently known to be broken in this release
	#   of Open MPI.
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
	else
		myconf+=(
			$(use_with cuda cuda "${ESYSROOT}/opt/cuda")
			--prefix="/usr"
			--without-rocm
		)
	fi

	CONFIG_SHELL="${BROOT}/bin/bash" \
	econf "${myconf[@]}"
}

_compile() {
	emake V=1
}

src_configure() {
	:
}

src_compile() {
einfo "Building for system"
	USE_ROCM=0 _configure
	_compile
	if use rocm ; then
		pushd "${S}_rocm" >/dev/null 2>&1 || die
einfo "Building for ROCm ${pv}"
			USE_ROCM=1 _configure
			_compile
		popd >/dev/null 2>&1 || die
	fi
}

src_test() {
	emake -C "test" "check"
}

src_install() {
	default
	if use rocm ; then
einfo "Installing for ROCm"
		pushd "${S}_rocm" >/dev/null 2>&1 || die
			default
		popd >/dev/null 2>&1 || die
		# TODO: verify rocm rpath
	fi

	# Remove la files, no static libs are installed and we have pkg-config
	find "${ED}" -name '*.la' -delete || die
}
