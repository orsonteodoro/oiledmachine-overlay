# Copyright open-overlay 2015-2017 by Alex
EAPI=6
inherit eutils pax-utils

DESCRIPTION="Genymotion Emulator"
HOMEPAGE="http://genymotion.com"
DL_PAGE="https://www.genymotion.com/fun-zone/"
SRC_URI="abi_x86_64? ( genymotion-${PV}-linux_x64.bin )
         arm-support_1_0? ( Genymotion-ARM-Translation.zip )
	 arm-support_1_1? ( Genymotion-ARM-Translation_v1.1.zip )
	 gapps_4_2? ( gapps-jb-20130812-signed.zip )
	 gapps_4_3? ( gapps-jb-20130813-signed.zip )"
 #        abi_x86_32? ( genymotion-${PV}-linux_x86.bin )
#         abi_x86_32? ( genymotion-${PV}-linux_x86.bin )
LICENSE="Genymotion"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="fetch"
#RDEPEND="|| ( >=app-emulation/virtualbox-4.3.12 >=app-emulation/virtualbox-bin-4.3.12 )
RDEPEND="|| ( >=app-emulation/virtualbox-5.0.28 >=app-emulation/virtualbox-bin-5.0.28 )
	app-crypt/qca[qt4,qt5]
	system-protobuf? ( >=dev-libs/protobuf-2.6.1 )
        >=dev-qt/qtwebkit-5
	system-openssl? ( dev-libs/openssl )
	dev-qt/qtscript:5
	dev-qt/qtx11extras:5
	media-libs/gst-plugins-base:0.10
	system-ffmpeg? ( media-video/ffmpeg:0/52.55.55 )
	system-qtdeclarative? ( dev-qt/qtdeclarative:5[localstorage,widgets,xml] )
	dev-qt/qtgui:5[egl,evdev]

	system-qtquickcontrols? ( dev-qt/qtquickcontrols:5[widgets] )

	dev-qt/qtopengl:5
	dev-qt/qtwebsockets:5
	dev-qt/qtsvg:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgraphicaleffects:5
"
#	media-libs/nas
#	media-libs/libpng:1.2
IUSE="+arm-support_1_0 -arm-support_1_1 gapps_4_2 gapps_4_3 abi_x86_64 abi_x86_32 system-protobuf system-ffmpeg system-openssl system-qtgui-xcb hardened system-qtdeclarative system-qtquickcontrols"
REQUIRED_USE="^^ ( abi_x86_64 ) !abi_x86_32"

pkg_nofetch() {
    einfo "Please download"
    if use abi_x86_64 ; then
	    einfo "genymotion-${PV}-linux_x64.bin"
    fi
    if use abi_x86_32 ; then
            einfo "genymotion-${PV}-linux_x86.bin"
    fi
    einfo "from ${DL_PAGE} and place them in your DISTDIR directory."
}


pkg_setup() {
	if use arm-support_1_1; then
		elog "We do not recommend arm-support_1_1 instead use arm-support_1_0 or you might get runtime trash."
		F="Genymotion-ARM-Translation_v1.1.zip"
		if [[ ! "${DISTDIR}/${F}" ]]; then
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
		if [[ ! "${DISTDIR}/${F}" ]]; then
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
		if [[ ! "${DISTDIR}/${F}" ]]; then
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
		if [[ ! "${DISTDIR}/${F}" ]]; then
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
		tail -n +455 ${DISTDIR}/genymotion-${PV}-linux_x64.bin > ${T}/t.tgz
	elif use abi_x86_32; then
		tail -n +455 ${DISTDIR}/genymotion-${PV}-linux_x86.bin > ${T}/t.tgz
	fi
	tar -xf "${T}/t.tgz" -C "${WORKDIR}" || die "failed to extract"
	cd "${S}"
	rm libQt*
	rm -rf imageformats
	rm -rf sqldrivers
	#rm libqca.so.2
	if use system-openssl ; then
		rm libcrypto.so libcrypto.so.1.0.0
		rm libssl.so libssl.so.1.0.0
		rm -rf crypto
	fi

	if use system-protobuf ; then
		rm libprotobuf.so.7
	fi
	#rm libswscale.so.2
	if use system-ffmpeg ; then
		rm libavutil.so.51
	fi
	if use system-qtgui-xcb ; then
		rm platforms/libqxcb.so
	fi
	if use system-qtdeclarative || use system-qtquickcontrols; then
		rm -rf QtQuick.2
		rm -rf QtQuick
	fi
}
src_install() {
	local dir="/opt/${PN}"
	insinto ${dir}
	doins -r *

	if use hardened ; then
		pax-mark -cm "${ED%/}/opt/${PN}/${PN}"
		pax-mark -cm "${ED%/}/opt/${PN}/gmtool"
	fi

	# Workaround -testing
	dosym "${ED%/}/"usr/$(get_libdir)/qt5/plugins/imageformats/libqsvg.so /opt/${PN}/imageformats/libqsvg.so
	dosym "${ED%/}/"usr/$(get_libdir)/qt5/plugins/sqldrivers/libqsqlite.so /opt/${PN}/sqldrivers/libqsqlite.so

	if use system-qtdeclarative ; then
		rm -rf "${D}/opt/${PN}/QtQuick"
		rm -rf "${D}/opt/${PN}/QtQuick.2"
		dosym "${ED%/}/"usr/$(get_libdir)/qt5/qml/QtQuick/ /opt/${PN}/QtQuick
		dosym "${ED%/}/"usr/$(get_libdir)/qt5/qml/QtQuick.2/ /opt/${PN}/QtQuick.2
	fi

	if use system-qtgui-xcb ; then
		dosym "${ED%/}/"/usr/$(get_libdir)/qt5/plugins/platforms/libqxcb.so /opt/${PN}/platforms/libqxcb.so
		mkdir -p "${ED}/opt/${PN}/xcbglintegrations"
		dosym "${ED%/}/"/usr/$(get_libdir)/qt5/plugins/xcbglintegrations/libqxcb-egl-integration.so /opt/${PN}/xcbglintegrations/libqxcb-egl-integration.so
		dosym "${ED%/}/"/usr/$(get_libdir)/qt5/plugins/xcbglintegrations/libqxcb-glx-integration.so /opt/${PN}/xcbglintegrations/libqxcb-glx-integration.so
	fi

	fperms 755 "${dir}/genymotion" "${dir}/player"
	fperms 755 "${dir}/tools/adb" "${dir}/tools/aapt"
	newicon "icons/icon.png" "genymotion.png"
	mkdir -p "${ED}/usr/bin/"
	echo "#!/bin/sh" > "${ED}/usr/bin/${PN}"
	echo "export PATH=\"/opt/VirtualBox:\${PATH}\"" >> "${ED}/usr/bin/${PN}"
	echo "exec /opt/genymotion/genymotion \"$@\"" >> "${ED}/usr/bin/${PN}"
	fperms 755 "/usr/bin/${PN}"
	#make_wrapper ${PN} ${dir}/genymotion
	make_desktop_entry ${PN} "Genymotion" ${PN} "System;Emulator"
	mkdir -p "${D}/usr/share/${PN}/extras"
	cp "${FILESDIR}"/ua* "${D}"/usr/share/"${PN}"/extras/
}

pkg_postinst() {
	einfo "If ARM translator version 1.0 doesn't work then try version 1.1 but not both."
	einfo "Futher instructions to install if any..."
	einfo "First turn on the emulator.  When it runs the home screen"
	if use gapps_4_2; then
		if use arm-support_1_0; then
			einfo "cp Genymotion-ARM-Translation.zip to distdir"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp Genymotion-ARM-Translation_v1.1.zip to distdir"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-1a.sh"
		fi
		einfo "cp gapps-jb-20130813-signed.zip to distdir"
		einfo "run ${ROOT}/usr/share/${PN}/extras/ua422-2.sh"
	fi
	if use gapps_4_3; then
		if use arm-support_1_0; then
			einfo "cp Genymotion-ARM-Translation.zip to distdir"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-1.sh"
		fi
		if use arm-support_1_1; then
			einfo "cp Genymotion-ARM-Translation_v1.1.zip to distdir"
			einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-1a.sh"
		fi
		einfo "cp gapps-jb-20130813-signed.zip to distdir"
		einfo "run ${ROOT}/usr/share/${PN}/extras/ua43-2.sh"
	fi
}
