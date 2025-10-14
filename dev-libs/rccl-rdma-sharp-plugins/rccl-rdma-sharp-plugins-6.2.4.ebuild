# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit autotools linux-info rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/rccl-rdma-sharp-plugins/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="rccl-rdma-sharp plugin enables RDMA and Switch based collectives \
(SHARP) with AMD's RCCL library"
HOMEPAGE="https://github.com/ROCm/rccl-rdma-sharp-plugins"
LICENSE="
	BSD
"
SLOT="0/${ROCM_SLOT}"
IUSE="sharp ucx verbs ebuild_revision_0"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}
	dev-util/hip:=
	sharp? (
		dev-util/DOCA-Host[sharp]
	)
	ucx? (
		sys-cluster/ucx[rocm,rocm_6_2]
	)
	verbs? (
		sys-cluster/rdma-core
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
"
PATCHES=(
)

check_kernel_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="
		~NET
		~INET
		~MLXSW_CORE
		~NET_SWITCHDEV
		~MLXSW_SWITCHIB
	"
	WARNING_NET="CONFIG_NET is required for SwitchIB-2 support."
	WARNING_INET="CONFIG_INET is required for SwitchIB-2 support."
	WARNING_MLXSW_CORE="CONFIG_MLXSW_CORE is required for SwitchIB-2 support."
	WARNING_NET_SWITCHDEV="CONFIG_NET_SWITCHDEV is required for SwitchIB-2 support."
	WARNING_MLXSW_SWITCHIB="CONFIG_MLXSW_SWITCHIB is required for SwitchIB-2 support." # Kernel 5.4
	check_extra_config

	CONFIG_CHECK="
		~NETDEVICES
		~ETHERNET
		~NET_VENDOR_MELLANOX
		~MLX5_CORE
		~MLX5_INFINIBAND
	"
	WARNING_NETDEVICES="CONFIG_NETDEVICES=y is required for ConnectX-5 or later support."
	WARNING_ETHERNET="CONFIG_ETHERNET=y is required for ConnectX-5 or later support."
	WARNING_MLX5_CORE="CONFIG_MLX5_CORE=y is required for ConnectX-5 or later support."
	WARNING_MLX5_INFINIBAND="CONFIG_MLX5_INFINIBAND=y is required for ConnectX-5 or later support."
	check_extra_config

	CONFIG_CHECK="
		~NET
		~INET
		~IPV6
		~INFINIBAND
		~INFINIBAND_USER_ACCESS
	"
	WARNING_NET="CONFIG_NET=y is required for InfiniBand or RoCE support."
	WARNING_INET="CONFIG_INET=y is required for InfiniBand or RoCE support."
	WARNING_IPV6="CONFIG_IPV6=y is required for InfiniBand or RoCE support."
	WARNING_INFINIBAND="CONFIG_INFINIBAND=y is required for InfiniBand or RoCE support."
	check_extra_config

	if use verbs ; then
		WARNING_INFINIBAND_USER_ACCESS="CONFIG_INFINIBAND_USER_ACCESS=y is required for InfiniBand Verbs support."
		check_extra_config
	fi
}

pkg_setup() {
	check_kernel_setup
	rocm_pkg_setup
}

src_prepare() {
	default
	rocm_src_prepare
	eautoreconf
}

src_configure() {
	rocm_set_default_hipcc
	local myconf=(
		--prefix="${EROCM_PATH}"
		--with-hip="${EROCM_PATH}"
	)
	if use ucx ; then
		myconf+=(
			--with-ucx="${ESYSROOT}/opt/rocm"
		)
	else
		myconf+=(
			--without-ucx
		)
	fi
	if use sharp ; then
		myconf+=(
			--with-sharp="${ESYSROOT}/opt/mellanox/sharp"
		)
	else
		myconf+=(
			--without-sharp
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
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	docinto "licenses"
	dodoc "LICENSE"
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
