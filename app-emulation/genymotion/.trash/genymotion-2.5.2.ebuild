# Copyright open-overlay 2015-2017 by Alex
EAPI=6
inherit eutils 

DESCRIPTION="Genymotion Emulator"
HOMEPAGE="http://genymotion.com"
SRC_URI="genymotion-2.5.2_x64_debian.bin"
LICENSE="Genymotion"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="fetch"
RDEPEND="|| ( >=app-emulation/virtualbox-4.3.12 >=app-emulation/virtualbox-bin-4.3.12 )
	app-crypt/qca[qt4]
	=dev-libs/protobuf-2.4.1
        dev-qt/qtwebkit:4
 	dev-libs/openssl
"
#	media-video/ffmpeg:0/52.55.55
#	media-libs/nas
#	media-libs/gst-plugins-base:0.10
#	media-libs/libpng:1.2
IUSE="+arm-support_1_0 -arm-support_1_1 gapps_4_2 gapps_4_3"

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
	tail -n +388 ${DISTDIR}/${A} > ${T}/t.tgz
	tar -xf "${T}/t.tgz" -C "${WORKDIR}" || die "failed to extract"
	cd "${S}"
	rm libQt*
	rm -rf imageformats
	rm -rf sqldrivers
	rm libqca.so.2
	rm libcrypto.so
	rm libssl.so

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
	einfo "First turn on the emulator.  When it runs the home screen"
	einfo "If ARM translator version 1.0 doesn't work then try version 1.1 but not both."
	if use gapps_4_2; then
		if use arm-support_1_0; then
			einfo "cp Genymotion-ARM-Translation.zip to ${DISTFILES}"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp Genymotion-ARM-Translation_v1.1.zip to ${DISTFILES}"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-1a.sh"
		fi
		einfo "cp gapps-jb-20130813-signed.zip to ${DISTFILES}"
		einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-2.sh"
	fi
	if use gapps_4_3; then
		if use arm-support_1_0; then
			einfo "cp Genymotion-ARM-Translation.zip to ${DISTFILES}"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp Genymotion-ARM-Translation_v1.1.zip to ${DISTFILES}"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-1a.sh"
		fi
		einfo "cp gapps-jb-20130813-signed.zip to ${DISTFILES}"
		einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-2.sh"
	fi

}
