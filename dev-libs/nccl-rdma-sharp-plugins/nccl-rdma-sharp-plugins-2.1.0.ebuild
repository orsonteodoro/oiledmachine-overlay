# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/Mellanox/nccl-rdma-sharp-plugins/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="RDMA and SHARP plugins for the NCCL library"
HOMEPAGE="https://github.com/Mellanox/nccl-rdma-sharp-plugins"
LICENSE="
	BSD
"
SLOT="0"
IUSE="sharp ucx verbs ebuild_revision_0"
RDEPEND="
	dev-util/nvidia-cuda-toolkit:=
	sharp? (
		dev-util/DOCA-Host[sharp]
	)
	ucx? (
		sys-cluster/ucx[cuda]
	)
	verbs? (
		sys-cluster/rdma-core
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
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
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--prefix="/usr"
		--with-cuda="${ESYSROOT}/opt/cuda"
	)
	if use ucx ; then
		myconf+=(
			--with-ucx="${ESYSROOT}/usr"
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
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
