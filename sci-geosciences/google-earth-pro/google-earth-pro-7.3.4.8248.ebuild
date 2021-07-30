# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# To find the version use:
# dpkg -I 'google-earth-pro-stable_7.3.3_amd64.deb'

EAPI=7

inherit desktop eutils pax-utils unpacker xdg

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="https://earth.google.com/"
# See https://support.google.com/earth/answer/168344?hl=en for list of direct links
EXPECTED_SHA512="05d5507240275cf30221f28f1d3170dae392ea66ddbb350c7df1b604c37853\
2f454531989f8427e80acf62613eda92c924a0a6a851c6f5367a8f8422c63cb07e"
MY_PV=$(ver_cut 1-3 ${PV})
SRC_FN_AMD64="${PN}-stable_${MY_PV}_amd64.deb"
DEST_FN_AMD64="${PN}-stable_$(ver_cut 1-3 ${PV})_${EXPECTED_SHA512:0:7}_amd64.deb"
SRC_URI="amd64? ( ${DEST_FN_AMD64} )"
# See opt/google/earth/pro/resources/licenses.rcc or Help > About for the full
# license list.
LICENSE="google-earth-pro-7.3.4
	Apache-2.0
	BSD
	Boost-1.0
	CC-BY-SA-2.5
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
	!system-gdal? ( BSD Info-ZIP MIT Qhull HDF-EOS gdal-degrib-and-g2clib SunPro )
	!system-icu? ( BSD )
	!system-openssl? ( openssl )
	!system-qt5? ( BSD-2 BSD LGPL-2.1 google-earth-pro-7.3.4 )
	!system-spnav? ( BSD )
	ZLIB"
# libvpx is BSD.  libvpx is referenced in ffmpeg and possibly internally
# WebKit BSD-2, BSD (ANGLE), LGPL-2.1 (for WebCore), plus possibly some
#   custom code
# More custom licenses and copyright notices are located in google-earth-pro-7.3.4
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch strip" # fetch for more control and determinism
LANGS=( ar bg ca cs da de el en es-419 es fa fil fi fr he hi hr hu id it ja ko \
lt lv nl no pl pt-PT pt ro ru sk sl sr sv th tr uk vi zh-Hans zh-Hant-HK \
zh-Hant )
IUSE=" +l10n_en ${LANGS[@]/#/l10n_} system-expat system-ffmpeg system-icu
system-gdal system-gpsbabel system-openssl system-qt5 system-spnav"
LANGS+=( en )
MY_PN="${PN}"
MY_PN="${MY_PN//-/}"
MY_PN="${MY_PN//pro/}"

QA_PREBUILT="*"

# TODO: find a way to unbundle libQt

# You can run /opt/google/earth/pro/libQt5Core.so.5 and get the version number.
# Only minor versions are compatible in Qt.

# ${PN} requires Ubuntu 14.04 libraries minimum

# Using system-openssl, system-icu USE flags requires custom slotting

EXPAT_V="2.2.1"
GDAL_V="2.4.4" # approximate
  LIBPNG_V="1.2.56"
  LIBTIFF_V="4.0.10"
  POSTGIS_V="5.2.0"
  ZLIB="1.2.3"
FFMPEG_V="3.2.4"
ICU_V="54.1"
OPENSSL_V="1.0.2u"
QT_VERSION="5.5.1" # The version distributed with ${PN}

# Using system Qt may likely require the older exact libraries.  Choices are...
#
# 1) same cat but ebuilds place in same folder but different SLOT=gep/5.5.1
#    and revision (as in -r551000)
# 2) different category (gep-qt) and same SLOT=5
#
# Both will require changes to src_configure to build against older set
# and src_install to prevent library conflict
#
# This ebuild needs to copy those libraries overriding them or use LD_PRELOAD
# to use these libraries.
#
# One may try to replace the Qt libs but there is a chance that they have been
# modified by upstream.
#
QT_CATEGORY="dev-qt" # user can either choose to keep ebuild in same folder or \
# seperate
QT_SLOT="5" # may requires seperate SLOT depending on choice
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
	  media-libs/gstreamer:1.0=
	  media-libs/gst-plugins-base:1.0=
	>=media-libs/harfbuzz-0.9.27
	>=media-libs/libpng-1.6
	>=media-plugins/gst-plugins-meta-1.2.3:1.0
	>=net-dns/libidn2-0.9
	>=net-libs/gnutls-3.4.10
	>=net-libs/libproxy-0.4.11
	>=net-print/cups-1.7.2
	>=sys-apps/dbus-1.6.18
	>=sys-apps/util-linux-2.20.1
	>=sys-devel/gcc-4.9.4[cxx]
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
	system-gdal? ( >=sci-libs/gdal-${GDAL_V}:2 )
	system-gpsbabel? ( >=sci-geosciences/gpsbabel-1.6.0 )
	system-icu? ( dev-libs/icu:${ICU_V} )
	system-openssl? ( >=dev-libs/openssl-${OPENSSL_V}:1.0 )
	system-qt5? (
		=${QT_CATEGORY}/qtcore-${QT_VERSION}*:${QT_SLOT}[icu]
		=${QT_CATEGORY}/qtdbus-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtdeclarative-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtgui-${QT_VERSION}*:${QT_SLOT}[dbus,gif,jpeg,png,xcb]
		=${QT_CATEGORY}/qtmultimedia-${QT_VERSION}*:${QT_SLOT}[widgets,alsa]
		=${QT_CATEGORY}/qtnetwork-${QT_VERSION}*:${QT_SLOT}[ssl]
		=${QT_CATEGORY}/qtopengl-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtpositioning-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtprintsupport-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtscript-${QT_VERSION}*:${QT_SLOT}[scripttools]
		=${QT_CATEGORY}/qtsensors-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtsql-${QT_VERSION}*:${QT_SLOT}[sqlite]
		=${QT_CATEGORY}/qtsvg-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtwebchannel-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtwebkit-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtwebsockets-${QT_VERSION}*:${QT_SLOT}[ssl]
		=${QT_CATEGORY}/qtwidgets-${QT_VERSION}*:${QT_SLOT}
		=${QT_CATEGORY}/qtx11extras-${QT_VERSION}*:${QT_SLOT}
	)
	system-spnav? ( >=dev-libs/libspnav-0.2.3 )"
S="${WORKDIR}"

pkg_setup() {
	if use system-expat ; then
ewarn
ewarn "Using system-expat has not been tested"
ewarn
	else
ewarn
ewarn "The internal Expat ${EXPAT_V} library may contain CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=expat&search_type=all"
ewarn
	fi
	if use system-ffmpeg ; then
ewarn
ewarn "Using system-ffmpeg has not been tested"
ewarn
	else
ewarn
ewarn "The internal FFmpeg ${FFMPEG_V} may contain CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=ffmpeg%20$(ver_cut 1-2 ${FFMPEG_V})&search_type=all"
ewarn
	fi
	if use system-gdal ; then
ewarn
ewarn "Using system-gdal has not been tested"
ewarn
	else
ewarn
ewarn "The internal GDAL ${GDAL_V} library may contain CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=gdal&search_type=all"
ewarn
	fi
	if use system-icu ; then
ewarn
ewarn "Using system-icu has not been tested"
ewarn
	else
ewarn
ewarn "The internal ICU ${ICU_V} library may contain known CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=International%20Components%20for%20Unicode&search_type=all"
ewarn
	fi
	if use system-openssl ; then
ewarn
ewarn "Using system-openssl has not been tested"
ewarn
	else
ewarn
ewarn "The internal OpenSSL ${OPENSSL_V} contains known CVE advisories and is End Of Life (EOL).  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=openssl%20$(ver_cut 1-3 ${OPENSSL_V})&search_type=all"
ewarn "https://www.openssl.org/policies/releasestrat.html"
ewarn
	fi
	if use system-qt5 ; then
		"${EROOT}/usr/$(get_libdir)/libQt5Core.so.5" | grep ${QT_VERSION}
		if [[ "$?" != "0" ]] ; then
eerror
eerror "You need ${QT_VERSION} in order to use the Qt system libraries.  This"
eerror "binary is sensitive to minor Qt changes."
eerror
			die
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
		local hash_cmd="\$(sha512sum ${SRC_FN_AMD64} | cut -f 1 -d ' ' | cut -c 1-7)"
		dest_fn="${PN}-stable_$(ver_cut 1-3 ${PV})_${hash_cmd}_amd64.deb"
	else
		die "${ARCH} is not supported"
	fi
	einfo
	einfo "Please download"
	einfo
	einfo "  ${src_fn}"
	einfo
	einfo "from ${HOMEPAGE} and place them in ${distdir} as ${dest_fn}"
	einfo "The shell assumes bash."
	einfo
}

src_unpack() {
	local arch
	if use amd64 ; then
		arch="amd64"
	else
		die "${ARCH} not supported"
	fi
	local FN=${DEST_FN_AMD64}
	X_SHA512=$(sha512sum "${DISTDIR}/${FN}" | cut -f 1 -d " ")
	if [[ "${X_SHA512}" != "${EXPECTED_SHA512}" ]] ; then
eerror
eerror "sha512sum X_SHA512=${X_SHA512} (download) is not"
eerror "EXPECTED_SHA512=${EXPECTED_SHA512} for PV=${PV}"
eerror
		die
	fi
	# default src_unpack fails with deb2targz installed, also this unpacks
	# the data.tar.lzma as well
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
		# TODO
		# rm -rfv plugins/imageformats || die
	fi
}

src_prepare() {
	xdg_src_prepare
	cd "${WORKDIR}" || die
	rm -rf "etc" "usr/share/menu" || die
	cd "${WORKDIR}/opt/google/earth/pro" || die
	rm -rf xdg-mime xdg-settings || die
	mv ${PN}.desktop "${WORKDIR}/usr/share/applications" || die
	if use system-gpsbabel ; then
		einfo "Switching to the system's GPSBabel"
		sed -i -e "s|# if |if |" googleearth || die
		rm gpsbabel || die
	fi
	#
	# QA validation fixes:
	#
	# error: file contains key "MultipleArgs" in group "Desktop Entry", but
	#   keys extending the format should start with "X-"
	#
	# warning: value "Application;Network" for key "Categories" in group
	#   "Desktop Entry" contains a deprecated value "Application"
	#
	sed -i -e "s|^MultipleArgs=|X-MultipleArgs=|" \
		-e "s|Categories=Application;|Categories=|" \
		-e "s|^Name=Google Earth$|Name=Google Earth Pro|" \
		"${WORKDIR}/usr/share/applications/google-earth-pro.desktop" || die
}

src_install() {
	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${PN}-mimetypes.xml" || die
	cd "${WORKDIR}/opt/google/earth/pro" || die
	for size in 16 22 24 32 48 64 128 256 ; do
		newicon -s ${size} product_logo_${size}.png ${PN}.png
	done
	rm -rf product_logo_* || die
	cd "${WORKDIR}" || die
	insinto /
	doins -r *
	fperms +x /opt/google/earth/pro/${MY_PN}{,-bin} \
		/opt/google/earth/pro/{gpsbabel,repair_tool}
	cd "${ED}" || die
	find . -type f -name "*.so*" -exec chmod +x '{}' + || die
	pax-mark -m "${ED%/}"/google/earth/pro/${MY_PN}-bin
	mkdir -p "${T}/langs" || die
	mv "${ED}/opt/google/earth/pro/lang/"* "${T}/langs" || die
	insinto /opt/google/earth/pro/lang
	for l in ${L10N} ; do
		einfo "Installing language ${l}"
		doins "${T}/langs/${l}.qm"
	done
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
einfo
einfo "When you get a crash starting Google Earth, try changing the file"
einfo "~/.config/Google/GoogleEarthPro.conf with the following options:"
einfo
einfo "  lastTip=4"
einfo "  enableTips=false"
einfo
einfo "If it fails to load, you may need to \`killall googleearth-bin\`"
einfo
einfo "Multilingual users must manually set the language in Tools > Options >"
einfo "General > Language Settings"
einfo
	xdg_pkg_postinst
	# Prevent portage from preserving libs after removal or between updates.
	# Remove them https://bugs.gentoo.org/265372
	rm "${ESYSROOT}/var/db/pkg/${CATEGORY}/${PN}-${PVR}/NEEDED"{.ELF.2,} || die
ewarn
ewarn "The save cookies securely to disk, used to save site preferences and"
ewarn "login information, is enabled by default.  It can be disabled at:"
ewarn
ewarn "  Tools > Options > General > Cookies > Save cookies to disk"
ewarn
}

pkg_postrm() {
	xdg_pkg_postrm
}
