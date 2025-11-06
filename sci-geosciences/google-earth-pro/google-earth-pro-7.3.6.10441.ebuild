# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U14, F23

# To find the version use:
# dpkg -I 'google-earth-pro-stable_7.3.3_amd64.deb'

MY_PN="${PN}"
MY_PN="${MY_PN//-/}"
MY_PN="${MY_PN//pro/}"
MY_PV=$(ver_cut 1-3 ${PV})

DOWNLOAD_PAGE_URI="https://support.google.com/earth/answer/168344?hl=en"
EXPAT_PV="2.2.1"
FFMPEG_PV="4.4.2"
FFMPEG_SLOT="56.58.58"
GDAL_PV="2.4.4" # approximate
ICU_PV="54.1"
LIBPNG_PV="1.2.56"
LIBTIFF_PV="4.0.10"
OPENSSL_PV="1.0.2u"
POSTGIS_PV="5.2.0"
QA_PREBUILT="*"
QT_CATEGORY="dev-qt"
QT_SLOT="5"
QT_VERSION="5.5.1" # The version distributed with ${PN}
SRC_FN_AMD64="${PN}-stable_${MY_PV}_amd64.deb"
ZLIB_PV="1.2.3"

# EXPECTED_SHA512 must go before DEST_FN_AMD64 \
EXPECTED_SHA512="\
417ed01656a1cd698a8f85b3c9664606bab781bc4048fd9244f64f7d42441cb1\
d3659c7782d7dea64ceb69dbe0ad256280de3c27622572456301adda4e66314d\
"
DEST_FN_AMD64="${PN}-stable_${MY_PV}_${EXPECTED_SHA512:0:7}_amd64.deb" # This line goes after EXPECTED_SHA512.

LANGS=(
	"ar"
	"bg"
	"ca"
	"cs"
	"da"
	"de"
	"el"
	"en"
	"es-419"
	"es"
	"fa"
	"fil"
	"fi"
	"fr"
	"he"
	"hi"
	"hr"
	"hu"
	"id"
	"it"
	"ja"
	"ko"
	"lt"
	"lv"
	"nl"
	"no"
	"pl"
	"pt-PT"
	"pt"
	"ro"
	"ru"
	"sk"
	"sl"
	"sr"
	"sv"
	"th"
	"tr"
	"uk"
	"vi"
	"zh-Hans"
	"zh-Hant-HK"
	"zh-Hant"
)

inherit desktop pax-utils unpacker xdg

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
	amd64? (
		${DEST_FN_AMD64}
	)
"

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="https://earth.google.com/"
# See opt/google/earth/pro/resources/licenses.rcc or Help > About for the full
# license list.
LICENSE="
	Apache-2.0
	BSD
	Boost-1.0
	CC-BY-SA-2.5
	FIPL-1.0
	FTL
	GEOTRANS
	Google-Earth-Pro-7.3.6
	Google-Maps-Google-Earth-Additional-Terms-of-Service
	Google-Privacy-Policy
	Google-Terms-of-Service
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
	ZLIB
	!system-expat? (
		MIT
	)
	!system-ffmpeg? (
		BSD
		LGPL-2.1
	)
	!system-gdal? (
		BSD
		HDF-EOS
		gdal-degrib-and-g2clib
		Info-ZIP
		MIT
		Qhull
		SunPro
	)
	!system-gpsbabel? (
		GPL-2+
	)
	!system-icu? (
		BSD
	)
	!system-openssl? (
		openssl
	)
	!system-qt5? (
		BSD
		BSD-2
		Google-Earth-Pro-7.3.6
		LGPL-2.1
	)
	!system-spnav? (
		BSD
	)
"
# libvpx is BSD.  libvpx is referenced in ffmpeg and possibly internally
# WebKit BSD-2, BSD (ANGLE), LGPL-2.1 (for WebCore), plus possibly some
#   custom code
# More custom licenses and copyright notices are located in Google-Earth-Pro-7.3.6
RESTRICT="binchecks bindist mirror fetch strip" # fetch for more control and determinism
SLOT="0"
IUSE="
${LANGS[@]/#/l10n_}
+l10n_en system-expat system-ffmpeg system-icu system-gdal system-gpsbabel
system-openssl system-qt5 system-spnav
"

# TODO: find a way to unbundle libQt

# You can run /opt/google/earth/pro/libQt5Core.so.5 and get the version number.
# Only minor versions are compatible in Qt.

# ${PN} requires U14.04 libraries minimum

# Using system-openssl, system-icu USE flags requires custom slotting

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
# User can either choose to keep ebuild in same folder, or it may require a
# seperate SLOT depending on the choice.
#
DPKG_RDEPEND="
	>=dev-libs/glib-2.56.1:2
	>=dev-libs/libxml2-2.9.4
	>=media-libs/alsa-lib-1.1.3
	>=media-libs/fontconfig-2.12.6
	>=media-libs/freetype-2.8.1
	>=media-libs/gstreamer-1.14.0:1.0
	>=media-libs/gst-plugins-base-1.14.0:1.0
	>=media-libs/mesa-9.0.0
	>=media-plugins/gst-plugins-meta-1.14.0:1.0
	>=net-libs/libproxy-0.4.15
	>=net-print/cups-2.2.7
	>=sys-apps/dbus-1.12.2
	>=sys-devel/gcc-8[cxx]
	>=sys-libs/glibc-2.27
	>=x11-libs/libSM-1.2.2
	>=x11-libs/libX11-1.6.4
	>=x11-libs/libxcb-1.13
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXrender-0.9.10
	>=x11-libs/libXtst-1.2.3
"
DYN_RDEPEND="
	>=dev-db/sqlite-3.22.0:3
	>=media-libs/glu-9.0
	>=sys-libs/zlib-1.2.11
	>=x11-libs/libICE-1.0.8
	>=x11-libs/libXcomposite-0.4.4
	>=x11-libs/libXi-1.7.1
"
INTERNAL_DEPS="
	system-expat? (
		>=dev-libs/expat-${EXPAT_PV}
	)
	system-ffmpeg? (
		>=media-video/ffmpeg-${FFMPEG_PV}:0/56.58.58
	)
	system-gdal? (
		>=sci-libs/gdal-${GDAL_PV}:2
	)
	system-gpsbabel? (
		>=sci-geosciences/gpsbabel-1.6.0
	)
	system-icu? (
		dev-libs/icu:${ICU_PV}
	)
	system-qt5? (
		~${QT_CATEGORY}/qtcore-${QT_VERSION}:${QT_SLOT}[icu]
		~${QT_CATEGORY}/qtdbus-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtdeclarative-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtgui-${QT_VERSION}:${QT_SLOT}[dbus,gif,jpeg,png,xcb]
		~${QT_CATEGORY}/qtmultimedia-${QT_VERSION}:${QT_SLOT}[widgets,alsa]
		~${QT_CATEGORY}/qtnetwork-${QT_VERSION}:${QT_SLOT}[ssl]
		~${QT_CATEGORY}/qtopengl-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtpositioning-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtprintsupport-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtscript-${QT_VERSION}:${QT_SLOT}[scripttools]
		~${QT_CATEGORY}/qtsensors-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtsql-${QT_VERSION}:${QT_SLOT}[sqlite]
		~${QT_CATEGORY}/qtsvg-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtwebchannel-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtwebkit-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtwidgets-${QT_VERSION}:${QT_SLOT}
		~${QT_CATEGORY}/qtx11extras-${QT_VERSION}:${QT_SLOT}
	)
	system-openssl? (
		>=dev-libs/openssl-${OPENSSL_PV}:0
	)
	system-spnav? (
		>=dev-libs/libspnav-0.2.3
	)
"
RDEPEND="
	${DPKG_RDEPEND}
	${DYN_RDEPEND}
	${INTERNAL_DEPS}
	virtual/ttf-fonts
"

pkg_setup() {
	if use system-expat ; then
ewarn "Using system-expat has not been tested"
	else
ewarn
ewarn "The internal Expat ${EXPAT_PV} library may contain CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=expat&search_type=all"
ewarn
	fi
	# The FFmpeg 4.4.2 critical was patched
	if use system-ffmpeg ; then
ewarn "Using system-ffmpeg has not been tested"
	fi
	if use system-gdal ; then
ewarn "Using system-gdal has not been tested"
	else
ewarn
ewarn "The internal GDAL ${GDAL_PV} library may contain CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=gdal&search_type=all"
ewarn
	fi
	if use system-icu ; then
ewarn "Using system-icu has not been tested"
	else
ewarn
ewarn "The internal ICU ${ICU_PV} library may contain known CVE advisories.  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=International%20Components%20for%20Unicode&search_type=all"
ewarn
	fi
	if use system-openssl ; then
ewarn "Using system-openssl has not been tested"
	else
ewarn
ewarn "The internal OpenSSL ${OPENSSL_PV} contains known CVE advisories and is End Of Life (EOL).  For details see"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=openssl%20$(ver_cut 1-3 ${OPENSSL_PV})&search_type=all"
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
eerror "QT_VERSION is not the same version as Qt5Core"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTDBUS_PV} ; then
eerror "QT_VERSION is not the same version as Qt5DBus"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTGUI_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Gui"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTMULTIMEDIA_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Multimedia"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTNETWORK_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Network"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTOPENGL_PV} ; then
eerror "QT_VERSION is not the same version as Qt5OpenGL"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTPOSITIONING_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Positioning"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTPRINTSUPPORT_PV} ; then
eerror "QT_VERSION is not the same version as Qt5PrintSupport"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTQML_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Qml (qtdeclarative)"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTSCRIPT_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Script"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTSENSORS_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Sensors"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTSQL_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Sql"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTSVG_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Svg"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBCHANNEL_PV} ; then
eerror "QT_VERSION is not the same version as Qt5WebChannel"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBKIT_PV} ; then
eerror "QT_VERSION is not the same version as Qt5WebKit"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTWEBSOCKETS_PV} ; then
eerror "QT_VERSION is not the same version as Qt5WebSockets"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTWIDGETS_PV} ; then
eerror "QT_VERSION is not the same version as Qt5Widgets"
			die
		fi
		if ver_test ${QT_VERSION} -ne ${QTX11EXTRAS_PV} ; then
eerror "QT_VERSION is not the same version as Qt5X11Extras"
			die
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
eerror "${ARCH} is not supported"
		die
	fi
ewarn
ewarn "To use/download/install this the following steps are required:"
ewarn
ewarn "1.  Navigate to ${HOMEPAGE} for a general overview."
ewarn "2.  Read and agree to the Google Terms of Service at https://policies.google.com/terms"
ewarn "    Read and agree to the Google Maps/Google Earth Additional Terms of Service at https://www.google.com/help/terms_maps/"
ewarn "    Read and agree to the Privacy Policy at https://policies.google.com/privacy?hl=en"
ewarn "    Read and agree to the third party licenses and copyright notices at https://htmlpreview.github.io/?https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/google-earth-pro-7.3.6"
ewarn "3.  You will eventually land on ${DOWNLOAD_PAGE_URI}"
ewarn "4.  Download ${src_fn}"
ewarn "5.  Rename the file as ${dest_fn}"
ewarn "6.  Place the file into ${distdir}"
ewarn "7.  Sanitize download file permissions:"
ewarn "    chmod 664 ${distdir}/${dest_fn}"
ewarn "    chown portage:portage ${distdir}/${dest_fn}"
ewarn "8.  Tell the package manager that you accepted the licenses:"
ewarn "    mkdir -p /etc/portage/package.license"
ewarn "    echo \"${CATEGORY}/${PN} Google-Earth-Pro-7.3.6 Google-Terms-of-Service Google-Maps-Google-Earth-Additional-Terms-of-Service Google-Privacy-Policy\" >> /etc/portage/package.license/${PN}"
ewarn "9.  Re-emerge ebuild."
ewarn
}

src_unpack() {
	local arch
	if use amd64 ; then
		arch="amd64"
	else
eerror "${ARCH} is not supported"
		die
	fi
	local FN=${DEST_FN_AMD64}
	X_SHA512=$(sha512sum "${DISTDIR}/${FN}" \
		| cut -f 1 -d " ")
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
		pushd "opt/google/earth/pro" || die
		rm -v "libexpat.so.1" || die
		popd || die
	fi
	if use system-gdal ; then
einfo "Removing bundled gdal"
		pushd "opt/google/earth/pro" || die
		rm -v "libgdal.so.1" || die
		popd || die
	fi
	if use system-icu ; then
einfo "Removing bundled icu"
		pushd "opt/google/earth/pro" || die
		local list=(
			"libicudata.so.54"
			"libicuuc.so.54"
			"libicui18n.so.54"
		)
		rm -v ${list[@]} || die
		popd || die
	fi
	if use system-spnav ; then
einfo "Removing bundled spnav"
		pushd "opt/google/earth/pro" || die
		rm -v "libspnav.so" || die
		popd || die
	fi
	if use system-qt5 ; then
einfo "Removing bundled qt5"
		pushd "opt/google/earth/pro" || die
		local list=(
			"libQt5Core.so.5"
			"libQt5DBus.so.5"
			"libQt5Gui.so.5"
			"libQt5Multimedia.so.5"
			"libQt5MultimediaWidgets.so.5"
			"libQt5Network.so.5"
			"libQt5OpenGL.so.5"
			"libQt5Positioning.so.5"
			"libQt5PrintSupport.so.5"
			"libQt5Qml.so.5"
			"libQt5Quick.so.5"
			"libQt5Script.so.5"
			"libQt5ScriptTools.so.5"
			"libQt5Sensors.so.5"
			"libQt5Sql.so.5"
			"libQt5WebChannel.so.5"
			"libQt5WebKit.so.5"
			"libQt5WebKitWidgets.so.5"
			"libQt5Widgets.so.5"
			"libQt5X11Extras.so.5"
			"libQt5XcbQpa.so.5"
		)
		rm -v ${list[@]} || die
		popd || die
		# TODO
		# rm -rfv plugins/imageformats || die
	fi
}

src_prepare() {
	default
	cd "${WORKDIR}" || die
	rm -rf \
		"etc" \
		"usr/share/menu" \
		|| die
	cd "${WORKDIR}/opt/google/earth/pro" || die
	rm -rf \
		"xdg-mime" \
		"xdg-settings" \
		|| die
	mv \
		"${PN}.desktop" \
		"${WORKDIR}/usr/share/applications" \
		|| die
	if use system-gpsbabel ; then
einfo "Switching to the system's GPSBabel"
		sed -i \
			-e "s|# if |if |" "googleearth" \
			|| die
		rm \
			"gpsbabel" \
			|| die
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
	sed -i \
		-e "s|^MultipleArgs=|X-MultipleArgs=|" \
		-e "s|Categories=Application;|Categories=|" \
		-e "s|^Name=Google Earth$|Name=Google Earth Pro|" \
		"${WORKDIR}/usr/share/applications/google-earth-pro.desktop" \
		|| die
}

src_install() {
	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}/${PN}-mimetypes.xml" || die
	cd "${WORKDIR}/opt/google/earth/pro" || die
	local sizes=(
		16
		22
		24
		32
		48
		64
		128
		256
	)
	local size
	for size in ${sizes[@]} ; do
		newicon \
			-s ${size} \
			"product_logo_${size}.png" \
			"${PN}.png"
	done
	rm -rf "product_logo_"* || die
	cd "${WORKDIR}" || die
	insinto "/"
	doins -r *
	fperms +x \
		"/opt/google/earth/pro/${MY_PN}"{"","-bin"} \
		"/opt/google/earth/pro/"{"gpsbabel","repair_tool"}
	cd "${ED}" || die
	find . -type f -name "*.so*" -exec chmod +x '{}' + || die
	pax-mark -m "${ED%/}/google/earth/pro/${MY_PN}-bin"
	mkdir -p "${T}/langs" || die
	mv \
		"${ED}/opt/google/earth/pro/lang/"* \
		"${T}/langs" \
		|| die
	insinto "/opt/google/earth/pro/lang"
	local l
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

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild-changes, license-transparency, license-completeness
# OILEDMACHINE-OVERLAY-TEST:  passed (7.3.6.9796, 20240406)
