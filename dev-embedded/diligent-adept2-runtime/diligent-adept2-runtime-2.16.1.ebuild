# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Digilent Adept 2 Runtime"
HOMEPAGE="https://reference.digilentinc.com/digilent_adept_2#software_downloads"
SRC_URI="abi_x86_64? ( http://cloud.digilentinc.com/Software/Adept2/digilent.adept.runtime_2.16.1-x86_64.tar.gz )
	 abi_x86_32? ( http://cloud.digilentinc.com/Software/Adept2/digilent.adept.runtime_2.16.1-i686.tar.gz )"

LICENSE="DIGILENT-ADEPT2-RUNTIME-EULA ftdi-driver? ( EULA_FTDI )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-fs/udev"
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="abi_x86_64 abi_x86_32 ftdi-driver"

LIBFTD2XX_FTDI_VER="1.0.4"

S="${WORKDIR}"

pkg_setup() {
	#the ftdi installer is dumb.  it is using a cached list.
	${ROOT}/sbin/ldconfig
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/digilent/adept/data"
	mkdir -p "${D}/etc/ld.so.conf.d/"
	mkdir -p "${D}/etc/udev/rules.d/"
	if use abi_x86_64; then
		mkdir -p "${D}/usr/lib64/diligent/adept/bin"
		cd "${S}/digilent.adept.runtime_${PV}-x86_64"
		sed -i -e "s|/etc|${D}/etc|g" install.sh
		sed -i -e "s|elif \[ \"\${szVmjr}\" = \"3\" \]|elif (( \"\${szVmjr}\" >= \"3\" ))|" install.sh
		sed -i -e "s|/sbin/ldconfig|true|" install.sh #don't trigger sandbox error
		sed -i -e "s|/sbin/udevadm|/bin/udevadm|g" install.sh
		einfo "Installing runtime..."
		./install.sh datapath="${D}/usr/share/digilent/adept/data" libpath="${D}/usr/lib64"  sbinpath="${D}/usr/lib64/diligent/adept/sbin/" silent=1
		dodoc CHANGELOG README

		if use ftdi-driver; then
			cd "${S}/digilent.adept.runtime_${PV}-x86_64/ftdi.drivers_${LIBFTD2XX_FTDI_VER}-x86_64"
			sed -i -e "s|/etc|${D}/etc|g" install.sh
			sed -i -e "s|/sbin/ldconfig|true|" install.sh #don't trigger sandbox error
			einfo "Installing FTID libftd2xx driver..."
			./install.sh instpath="${D}/usr/lib64" silent=1
			sed -i -e "s|${D}||" "${D}/etc/ld.so.conf.d/ftdi-drivers.conf"
		fi
	fi
	if use abi_x86_32; then
		mkdir -p "${D}/usr/lib32/diligent/adept/bin"
		cd "${S}/digilent.adept.runtime_${PV}-i686"
		sed -i -e "s|/etc|${D}/etc|g" install.sh
		sed -i -e "s|elif \[ \"\${szVmjr}\" = \"3\" \]|elif (( \"\${szVmjr}\" >= \"3\" ))|" install.sh
		sed -i -e "s|/sbin/ldconfig|true|" install.sh #don't trigger sandbox error
		sed -i -e "s|/sbin/udevadm|/bin/udevadm|g" install.sh
		einfo "Installing runtime..."
		./install.sh datapath="${D}/usr/share/digilent/adept/data" libpath="${D}/usr/lib32"  sbinpath="${D}/usr/lib32/diligent/adept/sbin/" silent=1
		dodoc CHANGELOG README

		if use ftdi-driver; then
			cd "${S}/digilent.adept.runtime_${PV}-i686/ftdi.drivers_${LIBFTD2XX_FTDI_VER}-i686"
			sed -i -e "s|/etc|${D}/etc|g" install.sh
			sed -i -e "s|/sbin/ldconfig|true|" install.sh #don't trigger sandbox error
			einfo "Installing FTID libftd2xx driver..."
			./install.sh instpath="${D}/usr/lib32" silent=1
			sed -i -e "s|${D}||" "${D}/etc/ld.so.conf.d/ftdi-drivers.conf"
		fi
	fi

	mkdir -p "${D}/lib/udev/rules.d"
	mv "${D}/etc/udev/rules.d/52-digilent-usb.rules" "${D}/lib/udev/rules.d"/
	rm -rf "${D}/etc/udev"

	#remove references to image
	sed -i -e "s|${D}|/|" "${D}/etc/digilent-adept.conf"
	sed -i -e "s|${D}|/|" "${D}/lib/udev/rules.d/52-digilent-usb.rules"
}

pkg_postinst() {
	${ROOT}/sbin/ldconfig
	einfo "Reloading udev..."
	udevadm control --reload-rules
}
