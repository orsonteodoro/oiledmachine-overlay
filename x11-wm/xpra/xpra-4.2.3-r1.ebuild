# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1-4)"

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 eutils flag-o-matic linux-info prefix tmpfiles udev user
inherit xdg

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based
on wimpiggy"
HOMEPAGE="
	http://xpra.org/
	https://github.com/Xpra-org/xpra
"
LICENSE="GPL-2+ BSD-2 CC-BY-SA-3.0 MIT LGPL-3+"
# BSD-2 - xpra/buffers/xxhash.c
# CC-BY-3.0 - xpra/platform/win32/printer_notify.py
# GPL-2+ - xpra/gtk_common/about.p
#	- fs/lib/cups/xpraforwarder
# LGPL-3+ - xpra/gtk_common/gtk_notifier.py
# MIT - xpra/platform/win32/lsa_logon_lib.py
#	- xpra/client/gl/gl_colorspace_conversions.py
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
GSTREAMER_IUSE+="
aac alsa flac jack lame matroska ogg opus oss pulseaudio speex twolame vorbis
wavpack
"
IUSE+="
${GSTREAMER_IUSE}

avahi +client +clipboard csc_swscale csc_libyuv cuda_rebuild cups dbus
dec_avcodec2 doc enc_ffmpeg enc_x264 enc_x265 firejail gtk3 gss html5-client
html5_gzip html5_brotli jpeg kerberos ldap ldap3 +lz4 lzo opengl openrc mdns
mysql +notifications nvenc nvfbc nvjpeg pam pillow png sd_listen selinux +server
sound sqlite ssh sshpass +ssl systemd test u2f vaapi vpx vsock v4l2 webcam webp
websockets X xdg zeroconf zlib
"

# LIMD # ATM, GEN 5-12
# LID # C2M, GEN 5-9
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	gtk3
	avahi? (
		dbus
		mdns
	)
	client? (
		enc_x264? (
			dec_avcodec2
		)
		enc_x265? (
			dec_avcodec2
		)
	)
	clipboard? (
		gtk3
		|| (
			client
			server
		)
	)
	cups? (
		dbus
	)
	firejail? (
		client
		server
	)
	html5-client? (
		websockets
	)
	gtk3? (
		X
		client? (
			webp
			opengl? (
				jpeg
			)
		)
	)
	jpeg? (
		pillow
	)
	mdns? (
		|| (
			avahi
			zeroconf
		)
	)
	notifications? (
		dbus
	)
	opengl? (
		client
	)
	png? (
		pillow
		zlib
	)
	sd_listen? (
		systemd
	)
	sound? (
		pulseaudio
	)
	sshpass? (
		ssh
	)
	webp? (
		pillow
	)
	X? (
		gtk3
	)
	zeroconf? (
		mdns
	)
	|| (
		client
		server
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"
CUDA_7_5_DRV_V="352.31"
NVFBC_MIN_DRV_V="410.66"
NVJPEG_MIN_DRV_V="450.36.06"
# From my experience, firejail doesn't need pillow with webp or with jpeg.
# The encoding when set to auto may require jpeg and webp.
# See https://github.com/Xpra-org/xpra/blob/v4.2/docs/Build/Dependencies.md for the full list.
DEPEND+="
	${PYTHON_DEPS}
	acct-group/xpra
	app-admin/sudo
	dev-lang/python[sqlite?,ssl?]
	dev-libs/glib[dbus?]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/rencode[${PYTHON_USEDEP}]
	avahi? (
		net-dns/avahi[${PYTHON_USEDEP},python]
	)
	csc_libyuv? (
		media-libs/libyuv
	)
	csc_swscale? (
		>=media-video/ffmpeg-1.2.2:0=
	)
	cups? (
		dev-python/pycups[${PYTHON_USEDEP}]
	)
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)
	dec_avcodec2? (
		>=media-video/ffmpeg-3.1:0=[vpx?,x264,x265]
	)
	enc_ffmpeg? (
		>=media-video/ffmpeg-4.0:0=
	)
	enc_x264? (
		>=media-video/ffmpeg-1.0.4:0=[x264]
		media-libs/x264
	)
	enc_x265? (
		>=media-video/ffmpeg-2:0=[x265]
		media-libs/x265
	)
	gss? (
		dev-python/gssapi[${PYTHON_USEDEP}]
	)
	gtk3? (
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
		dev-libs/gobject-introspection
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
	html5-client? (
		www-apps/xpra-html5
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-1.4
	)
	kerberos? (
		dev-python/pykerberos[${PYTHON_USEDEP}]
	)
	ldap? (
		dev-python/python-ldap[${PYTHON_USEDEP}]
	)
	ldap3? (
		dev-python/ldap3[${PYTHON_USEDEP}]
	)
	lz4? (
		dev-python/lz4[${PYTHON_USEDEP}]
	)
	lzo? (
		>=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-connector-python[${PYTHON_USEDEP}]
	)
	nvenc? (
		>=dev-python/pynvml-10.418[${PYTHON_USEDEP}]
		>=dev-util/nvidia-cuda-toolkit-7.5:=
		>=x11-drivers/nvidia-drivers-${CUDA_7_5_DRV_V}
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pycuda[${PYTHON_USEDEP}]
		media-video/nvidia-video-codec
	)
	nvfbc? (
		>=dev-util/nvidia-cuda-toolkit-10.0:=
		>=x11-drivers/nvidia-drivers-${NVFBC_MIN_DRV_V}
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pycuda[${PYTHON_USEDEP}]
	)
	nvjpeg? (
	        >=dev-util/nvidia-cuda-toolkit-11.1.1:=
	        >=x11-drivers/nvidia-drivers-${NVJPEG_MIN_DRV_V}
		dev-python/pycuda[${PYTHON_USEDEP}]
	)
	opengl? (
		x11-base/xorg-drivers[video_cards_dummy]
		client? (
			dev-python/pyopengl_accelerate[${PYTHON_USEDEP}]
		)
	)
	openrc? (
		sys-apps/net-tools
		sys-apps/openrc[bash]
	)
	pam? (
		sys-libs/pam[selinux?]
	)
	pillow? (
		dev-python/pillow[${PYTHON_USEDEP},jpeg?,webp?,zlib?]
	)
	pulseaudio? (
		media-sound/pulseaudio[dbus?]
	)
	server? (
		x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
	)
	sound? (
		dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		media-libs/gst-plugins-base:1.0[introspection]
		media-libs/gstreamer:1.0[introspection]
		media-plugins/gst-plugins-meta:1.0\
[aac?,alsa?,flac?,jack?,lame?,ogg?,opus?,oss?,pulseaudio?,vorbis?,wavpack?]
		aac? (
			media-plugins/gst-plugins-faac:1.0
			media-plugins/gst-plugins-faad:1.0
		)
		matroska? (
			media-libs/gst-plugins-good:1.0
		)
		speex? (
			media-plugins/gst-plugins-speex:1.0
		)
		twolame? (
			media-plugins/gst-plugins-twolame:1.0
		)
	)
	ssh? (
		sshpass? (
			net-misc/sshpass
		)
		|| (
			dev-python/paramiko[${PYTHON_USEDEP}]
			virtual/ssh
		)
	)
	systemd? (
		sys-apps/systemd
	)
	u2f? (
		dev-python/pyu2f[${PYTHON_USEDEP}]
	)
	v4l2? (
		media-video/v4l2loopback
		sys-kernel/linux-headers
	)
	vaapi? (
		>=media-video/ffmpeg-4.4:0=[vaapi]
		>=media-libs/libva-2.1.0
		media-libs/vaapi-drivers
	)
	vpx? (
		>=media-libs/libvpx-1.4
		virtual/ffmpeg
	)
	vsock? (
		sys-kernel/linux-headers
	)
	webcam? (
		>=media-libs/opencv-2.0[${PYTHON_USEDEP},python]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
	)
	webp? (
		>=media-libs/libwebp-0.5[opengl?]
	)
	websockets? (
		dev-python/websockify[${PYTHON_USEDEP}]
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXtst
		x11-libs/libxkbfile
	)
	xdg? (
		x11-misc/xdg-utils
	)
	zeroconf? (
		dev-python/zeroconf[${PYTHON_USEDEP}]
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cython-0.16[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		app-text/pandoc
	)
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.0.2_ignore-gentoo-no-compile.patch"
	"${FILESDIR}/${PN}-4.2-suid-warning.patch"
	"${FILESDIR}/${PN}-4.2.2-true-false-bin-path.patch"
	"${FILESDIR}/${PN}-4.2.3-dup-ip.patch"
	"${FILESDIR}/${PN}-4.2.2-bad-tests.patch"
	"${FILESDIR}/${PN}-4.2.3-ldconfig-skip.patch"
	"${FILESDIR}/${PN}-4.2.2-openrc-init-fix-v3.patch"
	"${FILESDIR}/${PN}-4.1.3-change-init-config-path.patch"
	"${FILESDIR}/${PN}-4.2-udev-path.patch"
	"${FILESDIR}/${PN}-4.3-translate-flags.patch"
)
SRC_URI="
https://github.com/Xpra-org/xpra/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	if use nvenc ; then
einfo
einfo "The nvenc USE flag has not been tested.  It is left for ebuild"
einfo "developers with that kind of GPU to work on."
einfo
	fi
	if use nvfbc ; then
einfo
einfo "The nvfbc USE flag has not been tested.  It is left for ebuild"
einfo "developers with that kind GPU to work on."
einfo
	fi

	if use v4l2 ; then
		CONFIG_CHECK="~VIDEO_V4L2"
		WARNING_VIDEO_V4L2="You need CONFIG_VIDEO_V4L2 kernel config"
		WARNING_VIDEO_V4L2+=" in order to use v4l2 support."
		linux-info_pkg_setup
	fi

	# server only
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	python_setup
einfo "EPYTHON=${EPYTHON}"
	[[ -z "${EPYTHON}" ]] && die "EPYTHON is empty"
	if use opengl ; then
		PYOPENGL_PV=$(cat \
"${EROOT}/usr/lib/${EPYTHON}/site-packages/OpenGL/version.py" \
			| grep -F -e "__version__" \
			| grep -E -o -e "[0-9\.]+")
		PYOPENGL_ACCELERATE_PV=$(cat \
"${EROOT}/usr/lib/${EPYTHON}/site-packages/OpenGL_accelerate/__init__.py" \
			| grep -F -e "__version__" \
			| grep -E -o -e "[0-9.]+")
		if ver_test ${PYOPENGL_PV} -ne ${PYOPENGL_ACCELERATE_PV} ; then
eerror
eerror "${PN} demands pyopengl-${PYOPENGL_PV} and"
eerror "pyopengl_accelerate-${PYOPENGL_ACCELERATE_PV} be the same version."
eerror
			die
		fi
	fi
	if use selinux && use pam ; then
		if \
		[[ ! -e "${EROOT}/$(get_libdir)/security/pam_selinux.so" ]]
		then
eerror
eerror "You are missing pam_selinux.so.  Reinstall pam[selinux]."
eerror
			die
		fi
	fi
}

src_prepare() {
	distutils-r1_src_prepare
	if use firejail ; then
		eapply "${FILESDIR}"/${PN}-4.1.3-envar-sound-override-on-start.patch
	fi
	if use pam ; then
		if ! use selinux ; then
			sed -r -i -e \
		"s|^session(.*)pam_selinux.so|#session\1pam_selinux.so|g" \
				fs/etc/pam.d/xpra || die
		fi
		if ! use systemd ; then
			sed -r -i -e \
		"s|^session(.*)pam_systemd.so|#session\1pam_systemd.so|g" \
				fs/etc/pam.d/xpra || die
		fi
	fi
}

python_prepare_all() {
	hprefixify -w '/os.path/' setup.py
	hprefixify \
		tmpfiles.d/xpra.conf xpra/server/server_util.py \
		xpra/platform{/xposix,}/paths.py xpra/scripts/server.py

	sed -r -e "/\bdoc_dir =/s:/${PN}\":/${PF}/html\":" \
		-i setup.py || die

	sed -i -e "s|^opengl =|#opengl =|g" \
		fs/etc/xpra/conf.d/40_client.conf.in || die
	if use opengl ; then
		sed -i -e "s|#opengl = yes|opengl = yes|g" \
			fs/etc/xpra/conf.d/40_client.conf.in || die
	else
		sed -i -e "s|#opengl = no|opengl = no|g" \
			fs/etc/xpra/conf.d/40_client.conf.in || die
		sed -i -e 's|"+extension", "GLX"|"-extension", "GLX"|g' \
			xpra/scripts/config.py || die
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	sed -i \
	-e "/'pulseaudio'/s:DEFAULT_PULSEAUDIO:$(usex pulseaudio True False):" \
		setup.py || die

	mydistutilsargs=(
		$(use_with client)
		$(use_with clipboard)
		$(use_with doc docs)
		$(use_with nvenc cuda_kernels)
		$(use_with nvjpeg)
		$(use_with cuda_rebuild)
		$(use_with csc_swscale)
		$(use_with csc_libyuv)
		$(use_with cups printing)
		$(use_with dbus)
		$(use_with dec_avcodec2)
		$(use_with enc_ffmpeg)
		$(use_with enc_x264)
		$(use_with enc_x265)
		$(use_with jpeg jpeg_encoder)
		$(use_with jpeg jpeg_decoder)
		$(use_with mdns)
		$(use_with opengl)
		$(use_with pam)
		$(use_with pillow)
		$(use_with notifications)
		$(use_with nvenc)
		$(use_with server)
		$(use_with server shadow)
		$(use_with sound)
		$(use_with sd_listen)
		$(use_with vpx)
		$(use_with vsock)
		$(use_with v4l2)
		$(use_with webcam)
		$(use_with webp)
		$(use_with xdg xdg_open)
		$(use_with X x11)
		--with-strict
		--with-verbose
		--with-warn
		--without-debug
		--without-PIC
		--without-Xdummy
	)

	if use gtk3 ; then
		mydistutilsargs+=(
			--with-gtk3
			--with-gtk_x11
		)
	else
		mydistutilsargs+=(
			--without-gtk3
			--without-gtk_x11
		)
	fi

	# See
	# https://www.xpra.org/trac/ticket/1080
	# http://trac.cython.org/ticket/395
	append-cflags -fno-strict-aliasing

	export XPRA_SOCKET_DIRS="${EPREFIX}/run/xpra"
	export UDEVDIR=$(get_udevdir)
}

python_install_all() {
	distutils-r1_python_install_all
	fperms 0750 /etc/init.d/xpra
	dodir /etc/X11
	cp "${D}"/etc/xpra/xorg.conf "${D}"/etc/X11/xorg.dummy.conf || die
	if ! use openrc ; then
		[[ -e "${ED}/etc/init.d/${PN}" ]] \
			&& rm "${ED}/etc/init.d/${PN}"
	fi
	if ! use systemd ; then
		[[ -e "${ED}/lib/systemd/system/xpra.service" ]] \
			&& rm "${ED}/lib/systemd/system/xpra.service"
		[[ -e "${ED}/lib/systemd/system/xpra-nosocketactivation.service" ]] \
			&& rm "${ED}/lib/systemd/system/xpra-nosocketactivation.service"
	fi
}

pkg_postinst() {
	tmpfiles_process /usr/lib/tmpfiles.d/xpra.conf
	xdg_pkg_postinst
einfo
einfo "You need to add yourself to the xpra, tty, dialout groups."
einfo
	if use pillow ; then
einfo
einfo "Manually add jpeg or webp optional USE flags to pillow"
einfo "package to enable support for them."
einfo
	fi
elog
elog "You need to enable the xpra service for this to work."
elog
	if which rc-update 2>/dev/null 1>/dev/null ; then
elog
elog "For OpenRC, do:"
elog
elog "  rc-update add xpra"
elog "  /etc/init.d/xpra restart"
elog
	fi
	if which systemctl 2>/dev/null 1>/dev/null ; then
elog
elog "For systemd, do:"
elog
elog "  systemctl stop xpra@username"
elog "  systemctl enable xpra@username"
elog "  systemctl start xpra@username"
elog
	fi
einfo
einfo "The init config has been moved to /etc/conf.d/xpra"
einfo
einfo "XPRA_USER_TO_PORT and XPRA_USER_TO_DISPLAY should be set in"
einfo "/etc/conf.d/xpra"
einfo
einfo "For the OpenRC init script, they should be defined as follows:"
einfo
einfo "  XPRA_USER_TO_PORT=\"user0:port0;user1:port1;...;userN:portN\""
einfo "  XPRA_USER_TO_DISPLAY=\"user0:display0;user1:display1;...;userN:displayN\""
einfo
einfo "This is to isolate each user's own session from each other."
einfo
einfo "This change has not been duplicated on the systemd version yet."
einfo
einfo "Xpra proxy creation as root has been disabled by default for the OpenRC"
einfo "script."
einfo
einfo "By default xpra will use SSL.  You need to create a self-signed digital"
einfo "cert."
einfo
einfo "Details can be found at https://xpra.org/trac/wiki/Encryption/SSL"
einfo
einfo "Do:"
einfo
einfo "  openssl req -new -x509 -days 365 -nodes -out cert.pem -keyout key.pem -sha256"
einfo "  cat key.pem cert.pem > /etc/xpra/ssl-cert.pem"
einfo
einfo "The OpenRC scripts expects the cert to be located at /etc/xpra/ssl-cert.pem"
einfo
einfo "Make sure you change the mode in the GUI to SSL."
einfo
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, ebuild-changes
