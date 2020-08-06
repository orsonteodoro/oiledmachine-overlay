# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# To find the version use:
# dpkg -I 'google-earth-pro-stable_7.3.2_amd64.deb'

EAPI=5

inherit eapi7-ver eutils fdo-mime gnome2-utils unpacker pax-utils

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="https://earth.google.com/"
# See https://support.google.com/earth/answer/168344?hl=en for list of direct links
EXPECTED_SHA256="57b6c970609dc2960e9255b08a7ddf3af2581cb7c06ff92d16820269d0b2530d"
MY_PV=$(ver_cut 1-3 ${PV})
SRC_FN_AMD64="google-earth-pro-stable_${MY_PV}_amd64.deb"
DEST_FN_AMD64="GoogleEarthProLinux-${MY_PV}_${EXPECTED_SHA256}_amd64.deb"
SRC_URI="amd64? ( https://dl.google.com/dl/linux/direct/${SRC_FN_AMD64}
			-> ${DEST_FN_AMD64} )"
# See opt/google/earth/pro/resources/licenses.rcc or Help > About for full license list
LICENSE="googleearthpro-7.3.2
	Apache-2.0
	BSD
	Boost-1.0
	FIPL-1.0
	FTL
	GEOTRANS
	GPL-2
	IJG
	Info-ZIP
	LGPL-2
	LGPL-2.1
	libpng
	libtiff
	MIT
	MS-RL
	SCEA
	!system-expat? ( MIT )
	!system-ffmpeg? ( LGPL-2.1 BSD )
	!system-gdal? ( BSD Info-ZIP MIT Qhull HDF-EOS gdal-degrib-and-g2clib e_log.c )
	!system-icu? ( BSD )
	!system-openssl? ( openssl )
	!system-qt5? ( BSD-2 BSD LGPL-2.1 googleearthpro-7.3.2 )
	!system-spnav? ( BSD )
	ZLIB"
# libvpx is BSD.  libvpx is referenced in ffmpeg and possibly internally
# Qt5WebKit BSD-2, BSD (ANGLE), LGPL-2.1 (for WebCore), plus possibly custom code
# More custom licenses are located in googleearthpro-7.3.2
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror splitdebug fetch" # fetch for more control and determinism
IUSE="system-expat system-ffmpeg system-icu system-gdal system-openssl system-qt5 system-spnav"
MY_PN="${PN//pro/}"

QA_PREBUILT="*"

# TODO: find a way to unbundle libQt

# You can run /opt/googleearthpro/libQt5Core.so.5 and get the version number.  Only minor versions are compatible in Qt.

# ${PN} requires Ubuntu 14.04 libraries minimum

# Using system-openssl, system-icu USE flags requires custom slotting

EXPAT_V="2.1"
GDAL_V="1.11.5"
FFMPEG_V="3.2.4"
ICU_V="54"
OPENSSL_V="1.0.2o"
QT_VERSION="5.5.1" # The version distributed with ${PN}

RDEPEND="
	>=app-arch/bzip2-1.0.6
	>=dev-db/sqlite-3.8.2:3
	>=dev-lang/orc-0.4
	  dev-libs/double-conversion
	>=dev-libs/glib-2.0:2
	>=dev-libs/gmp-5.1.3
	>=dev-libs/libbsd-0.6.0
	>=dev-libs/libffi-3.0.13
	  dev-libs/libpcre
	>=dev-libs/libtasn1-3.4
	  dev-libs/libunistring
	>=dev-libs/libxml2-2.9.1
	  dev-libs/nettle
	>=media-libs/alsa-lib-1.0.27.2
	>=media-libs/fontconfig-2.11.0
	>=media-libs/freetype-2.5.2
	>=media-libs/glu-9.0
	>=media-libs/harfbuzz-0.9.27
	>=media-libs/libpng-1.6
	>=media-plugins/gst-plugins-meta-1.2.3:1.0
	>=net-dns/libidn2-0.9
	>=net-libs/gnutls-3.4.10
	>=net-libs/libproxy-0.4.11
	>=net-print/cups-1.7.2
	>=sys-apps/dbus-1.6.18
	>=sys-apps/util-linux-2.20.1
	>=sys-devel/gcc-4.8.5[cxx]
	>=sys-libs/zlib-1.2.8
	virtual/opengl
	virtual/ttf-fonts
	>=x11-libs/libICE-1.0.8
	>=x11-libs/libSM-1.2.1
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXau-1.0.8
	>=x11-libs/libXcomposite-0.4.4
	>=x11-libs/libXdmcp-1.1.1
	>=x11-libs/libXext-1.3.2
	>=x11-libs/libXfixes-5.0.1
	>=x11-libs/libXi-1.7.1
	>=x11-libs/libXrender-0.9.8
	>=x11-libs/libXxf86vm-1.1.3
	>=x11-libs/libdrm-2.4.52
	>=x11-libs/libxcb-1.10
	>=x11-libs/libxshmfence-1.1
	system-expat? ( >=dev-libs/expat-${EXPAT_V} )
	system-ffmpeg? (
		<media-video/ffmpeg-4
		>=media-video/ffmpeg-${FFMPEG_V}
	)
	system-gdal? ( >=sci-libs/gdal-${GDAL_V}:1 )
	system-icu? ( dev-libs/icu:${ICU_V} )
	system-openssl? ( >=dev-libs/openssl-${OPENSSL_V}:1.0 )
	system-qt5? (
		=dev-qt/qtcore-${QT_VERSION}*:5[icu]
		=dev-qt/qtdbus-${QT_VERSION}*:5
		=dev-qt/qtdeclarative-${QT_VERSION}*:5
		=dev-qt/qtgui-${QT_VERSION}*:5[dbus,gif,jpeg,png,xcb]
		=dev-qt/qtmultimedia-${QT_VERSION}*:5[widgets,alsa]
		=dev-qt/qtnetwork-${QT_VERSION}*:5[ssl]
		=dev-qt/qtopengl-${QT_VERSION}*:5
		=dev-qt/qtpositioning-${QT_VERSION}*:5
		=dev-qt/qtprintsupport-${QT_VERSION}*:5
		=dev-qt/qtscript-${QT_VERSION}*:5[scripttools]
		=dev-qt/qtsensors-${QT_VERSION}*:5
		=dev-qt/qtsql-${QT_VERSION}*:5[sqlite]
		=dev-qt/qtsvg-${QT_VERSION}*:5
		=dev-qt/qtwebchannel-${QT_VERSION}*:5
		=dev-qt/qtwebkit-${QT_VERSION}*:5
		=dev-qt/qtwebsockets-${QT_VERSION}*:5[ssl]
		=dev-qt/qtwidgets-${QT_VERSION}*:5
		=dev-qt/qtx11extras-${QT_VERSION}*:5
	)
	system-spnav? ( >=dev-libs/libspnav-0.2.3 )
"
DEPEND="dev-util/patchelf"

S=${WORKDIR}/opt/google/earth/pro

pkg_setup() {
	ewarn "This version may contain vulnerabilities.  See https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=google%20earth%20$(ver_cut 1-2 ${PV})&search_type=all"
	if use system-expat ; then
		ewarn "Using system-expat has not been tested"
	else
		ewarn "The internal Expat ${EXPAT_V} library may contain CVE advisories.  For details see"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=expat%20${EXPAT_V}&search_type=all"
	fi

	if use system-ffmpeg ; then
		ewarn "Using system-ffmpeg has not been tested"
	else
		ewarn "The internal FFMpeg ${FFMPEG_V} may contain CVE advisories.  For details see"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=ffmpeg%20$(ver_cut 1-2 ${FFMPEG_V})&search_type=all"
	fi

	if use system-gdal ; then
		ewarn "Using system-gdal has not been tested"
	else
		ewarn "The internal GDAL ${GDAL_V} library may contain CVE advisories.  For details see"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=gdal&search_type=all"
	fi

	if use system-icu ; then
		ewarn "Using system-icu has not been tested"
	else
		ewarn "The internal ICU ${ICU_V} library contains known CVE advisories.  For details see"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=International%20Components%20for%20Unicode%20${ICU_V}&search_type=all"
	fi

	if use system-openssl ; then
		ewarn "Using system-openssl has not been tested"
	else
		ewarn "The internal OpenSSL ${OPENSSL_V} contains known CVE advisories.  For details see"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=openssl%20$(ver_cut 1-3 ${OPENSSL_V})&search_type=all"
	fi

	if use system-qt5 ; then
		/usr/lib/libQt5Core.so.5 | grep ${QT_VERSION}
		if [[ "$?" != "0" ]] ; then
			die "You need ${QT_VERSION} in order to use the Qt system libraries.  This binary is sensitive to minor Qt changes."
		fi

		QTCORE_PV=$(pkg-config --modversion Qt5Core)
		QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
		QTGUI_PV=$(pkg-config --modversion Qt5Gui)
		QTMULTIMEDIA_PV=$(pkg-config --modversion Qt5Multimedia)
		QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
		QTOPENGL_PV=$(pkg-config --modversion Qt5OpenGL)
		QTPOSITIONING_PV=$(pkg-config --modversion Qt5Positioning)
		QTPRINTSUPPORT_PV=$(pkg-config --modversion Qt5PrintSupport)
		QTQML_PV=$(pkg-config --modversion Qt5Qml)
		QTSCRIPT_PV=$(pkg-config --modversion Qt5Script)
		QTSENSORS_PV=$(pkg-config --modversion Qt5Sensors)
		QTSQL_PV=$(pkg-config --modversion Qt5Sql)
		QTSVG_PV=$(pkg-config --modversion Qt5Svg)
		QTWEBCHANNEL_PV=$(pkg-config --modversion Qt5WebChannel)
		QTWEBKIT_PV=$(pkg-config --modversion Qt5WebKit)
		QTWEBSOCKETS_PV=$(pkg-config --modversion Qt5WebSockets)
		QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
		QTX11EXTRAS_PV=$(pkg-config --modversion Qt5X11Extras)
		# Qt5XcbQpa covered by Qt5Gui
		if ver_test ${QT_VERSION} -ne ${QTCORE_PV} ; then
			die "QT_VERSION is not the same version as Qt5Core"
		fi
		if ver_test ${QT_VERSION} -ne ${QTDBUS_PV} ; then
			die "QT_VERSION is not the same version as Qt5DBus"
		fi
		if ver_test ${QT_VERSION} -ne ${QTGUI_PV} ; then
			die "QT_VERSION is not the same version as Qt5Gui"
		fi
		if ver_test ${QT_VERSION} -ne ${QTMULTIMEDIA_PV} ; then
			die "QT_VERSION is not the same version as Qt5Multimedia"
		fi
		if ver_test ${QT_VERSION} -ne ${QTNETWORK_PV} ; then
			die "QT_VERSION is not the same version as Qt5Network"
		fi
		if ver_test ${QT_VERSION} -ne ${QTOPENGL_PV} ; then
			die "QT_VERSION is not the same version as Qt5OpenGL"
		fi
		if ver_test ${QT_VERSION} -ne ${QTPOSITIONING_PV} ; then
			die "QT_VERSION is not the same version as Qt5Positioning"
		fi
		if ver_test ${QT_VERSION} -ne ${QTPRINTSUPPORT_PV} ; then
			die "QT_VERSION is not the same version as Qt5PrintSupport"
		fi
		if ver_test ${QT_VERSION} -ne ${QTQML_PV} ; then
			die "QT_VERSION is not the same version as Qt5Qml (qtdeclarative)"
		fi
		if ver_test ${QT_VERSION} -ne ${QTSCRIPT_PV} ; then
			die "QT_VERSION is not the same version as Qt5Script"
		fi
		if ver_test ${QT_VERSION} -ne ${QTSENSORS_PV} ; then
			die "QT_VERSION is not the same version as Qt5Sensors"
		fi
		if ver_test ${QT_VERSION} -ne ${QTSQL_PV} ; then
			die "QT_VERSION is not the same version as Qt5Sql"
		fi
		if ver_test ${QT_VERSION} -ne ${QTSVG_PV} ; then
			die "QT_VERSION is not the same version as Qt5Svg"
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBCHANNEL_PV} ; then
			die "QT_VERSION is not the same version as Qt5WebChannel"
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBKIT_PV} ; then
			die "QT_VERSION is not the same version as Qt5WebKit"
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBSOCKETS_PV} ; then
			die "QT_VERSION is not the same version as Qt5WebSockets"
		fi
		if ver_test ${QT_VERSION} -ne ${QTWIDGETS_PV} ; then
			die "QT_VERSION is not the same version as Qt5Widgets"
		fi
		if ver_test ${QT_VERSION} -ne ${QTX11EXTRAS_PV} ; then
			die "QT_VERSION is not the same version as Qt5X11Extras"
		fi
	fi

	if use system-spnav ; then
		ewarn "Using system-spnav has not been tested"
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local src_fn
	local dest_fn
	if use amd64 ; then
		src_fn="${SRC_FN_AMD64}"
		dest_fn="GoogleEarthProLinux-${MY_PV}_\$(sha256sum ${SRC_FN_AMD64} | cut -f 1 -d ' ')_amd64.deb"
	else
		die "${ARCH} is not supported"
	fi

	einfo "Please download"
	einfo "  ${src_fn}"
	einfo "from ${HOMEPAGE} and place them in ${distdir} as ${dest_fn}"
	einfo "The shell assumes bash."
}

src_unpack() {
	local arch
	if use amd64 ; then
		arch="amd64"
	elif use x86 ; then
		arch="i386"
	else
		die "${ARCH} not supported"
	fi
	local FN=GoogleEarthProLinux-${MY_PV}_${EXPECTED_SHA256}_${arch}.deb

	X_SHA256=$(sha256sum "${DISTDIR}/${FN}" | cut -f 1 -d " ")
	if [[ "${X_SHA256}" != "${EXPECTED_SHA256}" ]] ; then
		die "sha256sum X_SHA256=${X_SHA256} (download) is not EXPECTED_SHA256=${EXPECTED_SHA256} for PV=${PV}"
	fi

	# default src_unpack fails with deb2targz installed, also this unpacks the data.tar.lzma as well
	unpack_deb ${FN}

	if use system-expat ; then
		einfo "Removing bundled expat"
		pushd opt/google/earth/pro || die
		rm -v libexpat.so.1 || die
		popd || die
	fi

	if use system-gdal ; then
		einfo "Removing bundled gdal"
		pushd opt/google/earth/pro || die
		rm -v libgdal.so.1 || die
		popd || die
	fi

	if use system-icu ; then
		einfo "Removing bundled icu"
		pushd opt/google/earth/pro || die
		rm -v libicudata.so.54 libicuuc.so.54 libicui18n.so.54 || die
		popd || die
	fi

	if use system-spnav ; then
		einfo "Removing bundled spnav"
		pushd opt/google/earth/pro || die
		rm -v libspnav.so || die
		popd || die
	fi

	if use system-qt5 ; then
		einfo "Removing bundled qt5"
		pushd opt/google/earth/pro || die
		rm -v \
		      libQt5Core.so.5 \
		      libQt5DBus.so.5 \
		      libQt5Gui.so.5 \
		      libQt5Multimedia.so.5 \
		      libQt5MultimediaWidgets.so.5 \
		      libQt5Network.so.5 \
		      libQt5OpenGL.so.5 \
                      libQt5Positioning.so.5 \
		      libQt5PrintSupport.so.5 \
		      libQt5Qml.so.5 \
                      libQt5Quick.so.5 \
		      libQt5Script.so.5 \
		      libQt5ScriptTools.so.5 \
                      libQt5Sensors.so.5 \
		      libQt5Sql.so.5 \
		      libQt5WebChannel.so.5 \
                      libQt5WebKit.so.5 \
		      libQt5WebKitWidgets.so.5 \
		      libQt5Widgets.so.5 \
                      libQt5X11Extras.so.5 \
		      libQt5XcbQpa.so.5 \
		      || die
		popd || die

		#todo
		#rm -rfv plugins/imageformats || die
	fi
}

src_prepare() {
	# We have no ld-lsb.so.3 symlink.
	# Thanks to Nathan Phillip Brink <ohnobinki@ohnopublishing.net> for suggesting patchelf.
	einfo "Running patchelf"
	#patchelf --set-interpreter /lib/ld-linux$(usex amd64 "-x86-64" "").so.2 ${MY_PN}-bin || die "patchelf failed" #segfaults

	# Set RPATH for preserve-libs handling (bug #265372).
	local x
	for x in * plugins/*.so plugins/imageformats/*.so ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		# prepare file permissions so that >patchelf-0.8 can work on the files
		chmod u+w "${x}"
		if [[ "${x}" =~ "libQt5Core.so.5" ]] ; then
			continue
		fi
		patchelf --set-rpath '$ORIGIN' "${x}" ||
			die "patchelf failed on ${x}"
	done

	epatch "${FILESDIR}"/${PN}-${PV%%.*}-desktopfile.patch
}

src_install() {
	make_wrapper ${PN} ./${MY_PN} /opt/${PN} .

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${PN}-mimetypes.xml" || die

	domenu google-earth-pro.desktop

	for size in 16 22 24 32 48 64 128 256 ; do
		newicon -s ${size} product_logo_${size}.png google-earth-pro.png
	done

	rm -rf xdg-mime xdg-settings google-earth-pro google-earth-pro.desktop product_logo_*

	insinto /opt/${PN}
	doins -r *
	# Missing from licenses.rcc file but mentioned in ${PN} 7.3.3
	doins "${FILESDIR}/e_log.c.LICENSE"
	doins "${FILESDIR}/HDF-EOS.LICENSE"

	fperms +x /opt/${PN}/${MY_PN}{,-bin} \
		/opt/${PN}/{gpsbabel,repair_tool}
	cd "${ED}" || die
	find . -type f -name "*.so*" -exec chmod +x '{}' +

	pax-mark -m "${ED%/}"/opt/${PN}/${MY_PN}-bin
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "When you get a crash starting Google Earth, try changing the file ~/.config/Google/GoogleEarthPro.conf"
	elog "with the following options:"
	elog "lastTip=4"
	elog "enableTips=false"
	elog ""
	elog "If it fails to load, you may need to \`killall googleearth-bin\`"

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
