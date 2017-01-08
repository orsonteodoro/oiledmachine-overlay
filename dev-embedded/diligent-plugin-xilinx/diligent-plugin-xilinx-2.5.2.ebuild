# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Digilent Plugin for Xilinx Tools"
HOMEPAGE="https://reference.digilentinc.com/digilent_plugin_xilinx_tools"
SRC_URI="abi_x86_64? ( http://cloud.digilentinc.com/Software/Digilent_Plugin/libCseDigilent_${PV}-x86_64.tar.gz )
	 abi_x86_32? ( http://cloud.digilentinc.com/Software/Digilent_Plugin/libCseDigilent_${PV}-i686.tar.gz )"

LICENSE="DIGILENT-ADEPT2-RUNTIME-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-embedded/xilinx-ise-webpack:14"
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="abi_x86_64 abi_x86_32"
REQUIRED_USE=""

S="${WORKDIR}"

src_prepare() {
	eapply_user
}

src_install() {
	cd "${ROOT}/opt/Xilinx"
	ISE_VER=$(ls | tail -n 1)

	if use abi_x86_64; then
		S="${WORKDIR}/libCseDigilent_${PV}-x86_64"
		cd "${S}"
		mkdir -p "${D}"/opt/Xilinx/${ISE_VER}/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent/
		cp ISE14x/plugin/* "${D}"/opt/Xilinx/${ISE_VER}/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent/
		dodoc "ISE14x/Digilent_Plug-in_Xilinx_v14.pdf"
	fi

	if use abi_x86_32; then
		S="${WORKDIR}/libCseDigilent_${PV}-i686"
		cd "${S}"
		mkdir -p "${D}"/opt/Xilinx/${ISE_VER}/ISE_DS/ISE/lib/lin/plugins/Digilent/libCseDigilent/
		cp ISE14x/plugin/* "${D}"/opt/Xilinx/${ISE_VER}/ISE/ISE_DS/lib/lin/plugins/Digilent/libCseDigilent/
		dodoc "ISE14x/Digilent_Plug-in_Xilinx_v14.pdf"
	fi
}
