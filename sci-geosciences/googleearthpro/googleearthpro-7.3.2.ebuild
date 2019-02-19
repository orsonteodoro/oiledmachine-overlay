# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit pax-utils eutils unpacker fdo-mime gnome2-utils

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="https://earth.google.com/"
# See https://support.google.com/earth/answer/168344?hl=en for list of direct links
SRC_URI="amd64? ( https://dl.google.com/dl/linux/direct/google-earth-pro-stable_${PV}_amd64.deb
			-> GoogleEarthProLinux-${PV}_amd64.deb )"
LICENSE="googleearth GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror splitdebug"
IUSE="+bundled-libs"
MY_PN="${PN//pro/}"
REQUIRED_USE="bundled-libs" # does not work yet

QA_PREBUILT="*"

# TODO: find a way to unbundle libQt
# ./googleearth-bin: symbol lookup error: ./libbase.so: undefined symbol: _Z34QBasicAtomicInt_fetchAndAddOrderedPVii

# You can run /opt/googleearthpro/libQt5Core.so.5 and get the version number.  Only minor versions are compatible in Qt.

# Qt 5.5 was distributed
QT_VERSION="5.5.1" #version distributed with Google Earth Pro
#QT_VERSION="5.5.2" #version on Gentoo Portage closest to Google Earth Pro.  This doesn't work.

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gstreamer:1.0=
	media-libs/gst-plugins-base:1.0=
	net-libs/libproxy
	net-misc/curl
	sys-devel/gcc[cxx]
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	virtual/ttf-fonts
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp
	!bundled-libs? (
		dev-db/sqlite:3
		dev-libs/expat
		dev-libs/nss
		<sci-libs/gdal-2.0
		sci-libs/proj
		~dev-qt/qtgui-${QT_VERSION}:5[dbus,xcb,gif,jpeg]
		~dev-qt/qtx11extras-${QT_VERSION}:5
		~dev-qt/qtmultimedia-${QT_VERSION}:5[widgets,alsa]
		~dev-qt/qtopengl-${QT_VERSION}:5
		~dev-qt/qtdeclarative-${QT_VERSION}:5
		~dev-qt/qtscript-${QT_VERSION}:5[scripttools]
		~dev-qt/qtsensors-${QT_VERSION}:5
		~dev-qt/qtlocation-${QT_VERSION}:5
		~dev-qt/qtprintsupport-${QT_VERSION}:5
		~dev-qt/qtwebchannel-${QT_VERSION}:5
		~dev-qt/qtwidgets-${QT_VERSION}:5
		~dev-qt/qtnetwork-${QT_VERSION}:5[ssl]
		~dev-qt/qtwebsockets-${QT_VERSION}:5[ssl]
		~dev-qt/qtsql-${QT_VERSION}:5[sqlite]
		~dev-qt/qtwebkit-${QT_VERSION}:5
		dev-libs/leveldb
	)"
DEPEND="dev-util/patchelf"

S=${WORKDIR}/opt/google/earth/pro

pkg_setup() {
	if ! use bundled-libs ; then
		/usr/lib/libQt5Core.so.5 | grep ${QT_VERSION}
		if [[ "$?" != "0" ]] ; then
			die "You need ${QT_VERSION} in order to use the Qt system libraries.  This binary is sensitive to minor Qt changes."
		fi
	fi
}

pkg_nofetch() {
	einfo "Wrong checksum or file size means that Google silently replaced the distfile with a newer version."
	einfo "Note that Gentoo cannot mirror the distfiles due to license reasons, so we have to follow the bump."
	einfo "Please file a version bump bug on https://bugs.gentoo.org (search existing bugs for googleearth first!)."
	einfo "By redigesting the file yourself, you will install a different version than the ebuild says, untested!"
}

src_unpack() {
	# default src_unpack fails with deb2targz installed, also this unpacks the data.tar.lzma as well
	unpack_deb GoogleEarthProLinux-${PV}_$(usex amd64 "amd64" "i386").deb

	if ! use bundled-libs ; then
		einfo "Removing bundled libs"
		cd opt/google/earth/pro || die
		# sci-libs/gdal
		rm -v libgdal.so.1 || die
		# dev-db/sqlite
		#rm -v libsqlite3.so || die
		# dev-libs/nss
		#rm -v libplc4.so libplds4.so libnspr4.so libnssckbi.so libfreebl3.so \
		#	libnssdbm3.so libnss3.so libnssutil3.so libsmime3.so libnsssysinit.so \
		#	libsoftokn3.so libssl3.so || die
		# dev-libs/expat
		rm -v libexpat.so.1 || die
		# sci-libs/proj
		rm -v libproj.so.0 || die
		# dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwebkit:5 ...

		rm -v libQt5Core.so.5 \
		      libQt5XcbQpa.so.5 \
		      libQt5Gui.so.5 \
		      libQt5DBus.so.5 \
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
		      || die

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
	for x in * ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		chmod u+w "${x}"
		if [[ "${x}" =~ "libQt5Core.so.5" ]] ; then
			continue
		fi
		patchelf --set-rpath '$ORIGIN' "${x}" ||
			die "patchelf failed on ${x}"
	done
	# prepare file permissions so that >patchelf-0.8 can work on the files
	chmod u+w plugins/*.so plugins/imageformats/*.so
	for x in plugins/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/..' "${x}" ||
			die "patchelf failed on ${x}"
	done
	for x in plugins/imageformats/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/../..' "${x}" ||
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

	fperms +x /opt/${PN}/${MY_PN}{,-bin}
	cd "${ED}" || die
	find . -type f -name "*.so.*" -exec chmod +x '{}' +

	pax-mark -m "${ED%/}"/opt/${PN}/${MY_PN}-bin
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "When you get a crash starting Google Earth, try changing the file ~/.config/Google/GoogleEarthPlus.conf"
	elog "with the following options:"
	elog "lastTip=4"
	elog "enableTips=false"
	elog ""
	elog "In addition, the use of free video drivers may cause problems associated with using the Mesa"
	elog "library. In this case, Google Earth 7x likely only works with the Gallium3D variant."
	elog "To select the 32bit graphic library use the command:"
	elog "	eselect mesa list"
	elog "For example, for Radeon R300 (x86):"
	elog "	eselect mesa set r300 2"
	elog "For Intel Q33 (amd64):"
	elog "	eselect mesa set 32bit i965 2"
	elog "You may need to restart X afterwards."

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
