# Copyright open-overlay 2015 by Alex
EAPI=5
inherit eutils 

DESCRIPTION="Genymotion Emulator"
HOMEPAGE="http://genymotion.com"
SRC_URI="abi_x86_64? ( genymotion-2.6.0-linux_x64.bin )
         abi_x86_32? ( genymotion-2.6.0-linux_x86.bin )"
#         abi_x86_32? ( genymotion-2.6.0-linux_x86.bin )"
LICENSE="Genymotion"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="fetch"
RDEPEND="|| ( >=app-emulation/virtualbox-4.3.12 >=app-emulation/virtualbox-bin-4.3.12 )
	app-crypt/qca[qt4]
	=dev-libs/protobuf-2.4.1
        >=dev-qt/qtwebkit-5
 	dev-libs/openssl
	dev-qt/qtscript:5
"
#	media-video/ffmpeg:0/52.55.55
#	media-libs/nas
#	media-libs/gst-plugins-base:0.10
#	media-libs/libpng:1.2
IUSE="+arm-support_1_0 -arm-support_1_1 gapps_4_2 gapps_4_3 abi_x86_64 abi_x86_32 32-bit 64-bit"
#REQUIRED_USE="^^ ( abi_x86_32 abi_x86_64 )"

pkg_setup() {
	if use arm-support_1_1; then
		elog "We do not recommend arm-support_1_1 instead use arm-support_1_0 or you might get runtime trash."
		F="Genymotion-ARM-Translation_v1.1.zip"
		if [[ ! -f "${DISTDIR}/${F}" ]]; then
			die "You need to copy ${F} to ${DISTDIR}"
		else
			echo $(sha1sum "${DISTDIR}/${F}") | grep "96bcad1131d4537d644e58c2b24aa52d44e676ea" &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "${F} is the wrong download."
			fi
		fi
	fi
	if use arm-support_1_0; then
		F="Genymotion-ARM-Translation.zip"
		if [[ ! -f "${DISTDIR}/${F}" ]]; then
			die "You need to copy ${F} to ${DISTDIR}"
		else
			echo $(sha1sum "${DISTDIR}/${F}") | grep "a1e571c4fe18e66aa4dbf954efd30e587ce7ed29" &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "${F} is the wrong download."
			fi
		fi
	fi
	if use gapps_4_2; then
		F="gapps-jb-20130812-signed.zip"
		if [[ ! -f "${DISTDIR}/${F}" ]]; then
			die "You need to copy ${F} to ${DISTDIR}"
		else
			echo $(sha1sum "${DISTDIR}/${F}") | grep "bfdc0439185bc41d835b47113935aae5fa3fbde1" &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "${F} is the wrong download."
			fi
		fi
	fi
	if use gapps_4_3; then
		F="gapps-jb-20130813-signed.zip"
		if [[ ! -f "${DISTDIR}/${F}" ]]; then
			die "You need to copy ${F} to ${DISTDIR}"
		else
			echo $(sha1sum "${DISTDIR}/${F}") | grep "74f71871796fe0ffde2689e97babfe747b175d24" &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "${F} is the wrong download."
			fi
		fi
	fi
}
pkg_postinst() {
               echo 
               elog "Welcome to Genymotion Emulator"
               elog "To run Genymotion virtual devices, you must install Oracle VM VirtualBox 4.1 or above."
               elog "However, for performance reasons, we recommend using version 4.3.12."
               elog "Thanks open-overlay 2015 by Alex"
               echo 
}
S="${WORKDIR}"
src_unpack() {
	if use abi_x86_64; then
		tail -n +455 ${DISTDIR}/genymotion-2.6.0-linux_x64.bin > ${T}/t.tgz
	elif use abi_x86_32; then
		tail -n +455 ${DISTDIR}/genymotion-2.6.0-linux_x86.bin > ${T}/t.tgz
	fi
	tar -xf "${T}/t.tgz" -C "${WORKDIR}" || die "failed to extract"
	cd "${S}"
	rm libQt*
	rm -rf imageformats
	rm -rf sqldrivers
	#rm libqca.so.2
	#rm libcrypto.so
	#rm libssl.so

	rm libprotobuf.so.7
	#rm libswscale.so.2
	#rm libavutil.so.51

	rm -rf crypto
}
src_install() {
	local dir="/opt/${PN}"
	insinto ${dir}
	doins -r *
	fperms 755 "${dir}/genymotion" "${dir}/player"   
	fperms 755 "${dir}/tools/adb" "${dir}/tools/aapt"
	newicon "icons/icon.png" "genymotion.png" 
	make_wrapper ${PN} ${dir}/genymotion 
	make_desktop_entry ${PN} "Genymotion" ${PN} "System;Emulator"
	mkdir -p "${D}/usr/share/${PN}/extras"
	cp "${FILESDIR}"/ua* "${D}"/usr/share/"${PN}"/extras/
}

pkg_postinst() {
	einfo "Futher instructions to install if any..."
	if use gapps_4_2; then
		if use arm-support_1_0; then
			einfo "cp ${ROOT}/usr/share/${PN}/extras/ua422-1.sh to your home"
			einfo "cp ${DISTFILES}/Genymotion-ARM-Translation.zip to your home"
			einfo "run ./ua422-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp ${ROOT}/usr/share/${PN}/extras/ua422-1a.sh to your home"
			einfo "cp ${DISTFILES}/Genymotion-ARM-Translation_v1.1.zip to your home"
			einfo "run ./ua422-1a.sh"
		fi
		einfo "cp ${ROOT}/usr/share/${PN}/extras/ua422-2.sh to your home"
		einfo "cp ${DISTFILES}/gapps-jb-20130813-signed.zip to your home"
		einfo "run ./ua422-2.sh"
	fi
	if use gapps_4_3; then
		if use arm-support_1_0; then
			einfo "cp ${ROOT}/usr/share/${PN}/extras/ua43-1.sh to your home"
			einfo "cp ${DISTFILES}/Genymotion-ARM-Translation.zip to your home"
			einfo "run ./ua43-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp ${ROOT}/usr/share/${PN}/extras/ua43-1a.sh to your home"
			einfo "cp ${DISTFILES}/Genymotion-ARM-Translation_v1.1.zip to your home"
			einfo "run ./ua43-1a.sh"
		fi
		einfo "cp ${ROOT}/usr/share/${PN}/extras/ua43-2.sh to your home"
		einfo "cp ${DISTFILES}/gapps-jb-20130813-signed.zip to your home"
		einfo "run ./ua43-2.sh"
	fi
}
