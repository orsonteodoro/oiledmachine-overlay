# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils check-reqs

DESCRIPTION="Xilinx ISE WebPack"
HOMEPAGE="http://www.xilinx.com/products/design-tools/ise-design-suite.html"
SRC_URI="Xilinx_ISE_DS_Lin_14.7_1015_1.tar"

LICENSE="XILINX-EULA XILINX-THIRD-PARTY-EULAS"
SLOT="14"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="abi_x86_64 abi_x86_32"

MYVER="14.7"

CHECKREQS_DISK_BUILD="24128M"
CHECKREQS_DISK_USR="18216M"

S="${WORKDIR}/Xilinx_ISE_DS_Lin_${MYVER}_1015_1"

F="Xilinx_ISE_DS_Lin_${MYVER}_1015_1.tar"
pkg_setup() {
	if [[ ! -f "${DISTDIR}/${F}" ]]; then
		die "Place ${F} in /usr/portage/distfiles"
	fi
}

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	if use abi_x86_64; then
		cd "${S}"/bin/lin64
	elif use abi_x86_32; then
		cd "${S}"/bin/lin32
	fi

	./batchxsetup -samplebatchscript mybatchscript
	sed -i -e "s|destination_dir=[/]opt[/]Xilinx|destination_dir=${D}/opt/Xilinx|" mybatchscript

	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|# package=ISE WebPACK::0\n# application=setupEnv.sh::0\n# application=Install Linux System Generator Info XML::0\n# application=Ensure Linux System Generator Symlinks::0\n# application=Install Cable Drivers::0|package=ISE WebPACK::0\napplication=setupEnv.sh::0\napplication=Install Linux System Generator Info XML::0\napplication=Ensure Linux System Generator Symlinks::0\napplication=Install Cable Drivers::0|' mybatchscript

	eapply_user
}

src_install() {
	mkdir -p "${D}/opt/Xilinx"
	if use abi_x86_64; then
		cd "${S}"/bin/lin64
	elif use abi_x86_32; then
		cd "${S}"/bin/lin32
	fi

	echo "Y" > yes
	for X in $(seq 1 10000)
	do
	        echo "Y" >> yes
	done

	cat yes | ./batchxsetup --batch mybatchscript

	mkdir -p "${D}/usr/bin"
	if use abi_x86_64; then
		echo "#!/bin/bash" > "${D}/usr/bin/ise64"
		echo "unset LANG" >> "${D}/usr/bin/ise64"
		echo "unset QT_PLUGIN_PATH" >> "${D}/usr/bin/ise64"
		echo "source /opt/Xilinx/${MYVER}/ISE_DS/settings64.sh" >> "${D}/usr/bin/ise64"
		echo "ise \$*" >> "${D}/usr/bin/ise64"
		chmod +x "${D}/usr/bin/ise64"
		make_desktop_entry "/usr/bin/ise64" "ISE WebPACK (64-bit)" "/opt/Xilinx/${MYVER}/ISE_DS/ISE/data/images/pn-ise.png" "Development;IDE"
	fi

	if use abi_x86_32; then
		echo "#!/bin/bash" > "${D}/usr/bin/ise32"
		echo "unset LANG" >> "${D}/usr/bin/ise32"
		echo "unset QT_PLUGIN_PATH" >> "${D}/usr/bin/ise32"
		echo "source /opt/Xilinx/${MYVER}/ISE_DS/settings32.sh" >> "${D}/usr/bin/ise32"
		echo "ise \$*" >> "${D}/usr/bin/ise32"
		chmod +x "${D}/usr/bin/ise32"
		make_desktop_entry "/usr/bin/ise32" "ISE WebPACK (32-bit)" "/opt/Xilinx/${MYVER}/ISE_DS/ISE/data/images/pn-ise.png" "Development;IDE"
	fi

	#fix the path
	sed -i -e "s|${D}|/|" "${D}/opt/Xilinx/${MYVER}/ISE_DS/settings64."{sh,csh}
	sed -i -e "s|${D}|/|" "${D}/opt/Xilinx/${MYVER}/ISE_DS/settings32."{sh,csh}
}

pkg_postinst() {
	elog "Copy your Xilinx ISE WebPack license to ~/.Xilinx or /opt/Xilinx/${MYVER}/ISE_DS/ISE/coregen/core_licenses ."
}
