# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based \
on wimpiggy"
HOMEPAGE="http://xpra.org/ \
	  http://xpra.org/src/"
LICENSE="GPL-2 BSD html5? ( MPL-2.0 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# PyCObject_Check and PyCObject_AsVoidPtr vanished with python 3.3
PYTHON_COMPAT=( python3_{6,7,8} )
IUSE="  avahi +client +clipboard csc_swscale csc_libyuv cuda cuda_rebuild cups \
	dbus dec_avcodec2 enc_ffmpeg enc_x264 enc_x265 gtk3 html5 \
	html5_gzip html5_brotli jpeg libav +lz4 lzo opengl minify \
	+notifications nvenc nvfbc pam pillow pulseaudio sd_listen ssl server \
	sound systemd test vpx vsock v4l2 webcam webp websockets X xdg"
REQUIRED_USE="  ^^ (	python_targets_python3_6 \
			python_targets_python3_7 \
			python_targets_python3_8 ) \
		^^ ( gtk3 ) \
		python_targets_python3_6 ( gtk3 ) \
		python_targets_python3_7 ( gtk3 )
		python_targets_python3_8 ( gtk3 )"
SLOT="0/${PV}"
MY_PV="$(ver_cut 1-4)"
inherit distutils-r1
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( client server )
	avahi? ( dbus )
	client? ( enc_x264? ( dec_avcodec2 )
		  enc_x265? ( dec_avcodec2 ) )
	clipboard? ( || ( client server )
		     || ( gtk3 ) )
	cups? ( dbus )
	gtk3? ( X )
	opengl? ( client )
	sd_listen? ( systemd )
	X? ( gtk3 )"
inherit multilib-build
COMMON_DEPEND="${PYTHON_DEPS}
	dev-lang/python[ssl?]
	dev-python/pygtk:2[python_targets_python2_7]
	gtk3? (	dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-libs/gobject-introspection
		x11-libs/gtk+:3 )
	csc_libyuv? ( media-libs/libyuv )
	csc_swscale? ( !libav? ( >=media-video/ffmpeg-1.2.2:0= )
			libav? ( media-video/libav:0= ) )
	cuda? ( dev-python/pycuda[${PYTHON_USEDEP}]
	      >=x11-drivers/nvidia-drivers-352.31 )
	dec_avcodec2? ( !libav? ( >=media-video/ffmpeg-3.1:0=[x264,x265] )
			 libav? ( media-video/libav:0=[x264,x265] ) )
	enc_ffmpeg? ( !libav? ( >=media-video/ffmpeg-4.0:0= )
		       libav? ( media-video/libav:0= ) )
	enc_x264? ( !libav? ( >=media-video/ffmpeg-1.0.4:0=[x264] )
		     libav? ( media-video/libav:0=[x264] )
		     media-libs/x264 )
	enc_x265? ( !libav? ( >=media-video/ffmpeg-2:0=[x264] )
		     libav? ( media-video/libav:0=[x264] )
		     media-libs/x265 )
	jpeg? ( >=media-libs/libjpeg-turbo-1.4 )
	minify? ( || ( dev-util/yuicompressor dev-util/uglifyjs ) )
	nvenc? ( dev-python/numpy[${PYTHON_USEDEP}]
		 dev-python/pycuda[${PYTHON_USEDEP}]
		 media-video/nvidia-video-codec
	       >=x11-drivers/nvidia-drivers-418.30 )
	nvfbc? ( dev-python/numpy[${PYTHON_USEDEP}]
		 dev-python/pycuda[${PYTHON_USEDEP}]
	       >=x11-drivers/nvidia-drivers-410.66 )
	opengl? (  dev-python/numpy[${PYTHON_USEDEP}] )
	pam? ( sys-libs/pam )
	pillow? ( dev-python/pillow[${PYTHON_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio )
	sound? ( dev-libs/gobject-introspection
		 dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		 media-libs/gstreamer:1.0
		 media-libs/gst-plugins-base:1.0 )
	systemd? ( sys-apps/systemd )
	v4l2? ( media-video/v4l2loopback
		sys-kernel/linux-headers )
	vpx? ( >=media-libs/libvpx-1.4 virtual/ffmpeg )
	vsock? ( sys-kernel/linux-headers )
	webp? ( >=media-libs/libwebp-0.5[opengl?] )
	websockets? ( dev-python/websockify[${PYTHON_USEDEP}] )
	X? ( x11-libs/libX11
	     x11-libs/libXcomposite
	     x11-libs/libXdamage
	     x11-libs/libXfixes
	     x11-libs/libXi
	     x11-libs/libXrandr
	     x11-libs/libXtst
	     x11-libs/libxkbfile )
	xdg? ( x11-misc/xdg-utils )"
RDEPEND="${COMMON_DEPEND}
	cups? ( dev-python/pycups[${PYTHON_USEDEP}] )
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/rencode[${PYTHON_USEDEP}]
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	lzo? ( >=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}] )
	opengl? ( client? ( dev-python/pyopengl_accelerate[${PYTHON_USEDEP}] )
		  x11-base/xorg-drivers[video_cards_dummy] )
	server? ( x11-base/xorg-server[-minimal,xvfb]
		  x11-drivers/xf86-input-void )
	virtual/ssh
	webcam? ( dev-python/numpy[${PYTHON_USEDEP}]
		  dev-python/pyinotify[${PYTHON_USEDEP}]
		>=media-libs/opencv-2.0[python] )"
DEPEND="${COMMON_DEPEND}
	cuda? ( dev-util/nvidia-cuda-sdk )
	>=dev-python/cython-0.16[${PYTHON_USEDEP}]
	virtual/pkgconfig"
PATCHES=( "${FILESDIR}"/${PN}-2.5.0_rc5-ignore-gentoo-no-compile.patch
	  "${FILESDIR}"/${PN}-2.0-suid-warning.patch
	  "${FILESDIR}"/${PN}-2.5.0_rc5-openrc-init-fix.patch
	  "${FILESDIR}"/${PN}-3.0_rc1-ldconfig-skip.patch )
inherit eutils flag-o-matic linux-info prefix user tmpfiles xdg
SRC_URI="http://xpra.org/src/${PN}-${MY_PV//_/-}.tar.xz"
S="${WORKDIR}/xpra-${MY_PV//_/-}"
RESTRICT="mirror"

pkg_setup() {
	if use v4l2 ; then
		CONFIG_CHECK="~VIDEO_V4L2"
		WARNING_VIDEO_V4L2="You need CONFIG_VIDEO_V4L2 kernel config"
		WARNING_VIDEO_V4L2+=" in order to use v4l2 support."
		linux-info_pkg_setup
	fi
}

pkg_postinst() {
	enewgroup ${PN}
	tmpfiles_process /usr/lib/tmpfiles.d/xpra.conf

	xdg_pkg_postinst
}

python_prepare_all() {
	hprefixify -w '/os.path/' setup.py
	hprefixify tmpfiles.d/xpra.conf xpra/server/{server,socket}_util.py \
		xpra/platform{/xposix,}/paths.py xpra/scripts/server.py

	if use opengl ; then
		echo \
'xvfb=Xorg -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -config xorg.dummy.conf' \
			>> "${S}"/etc/xpra/xpra.conf.in || die
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	sed -e \
	  "/'pulseaudio'/s:DEFAULT_PULSEAUDIO:$(usex pulseaudio True False):" \
		-i setup.py || die

	mydistutilsargs=(
		$(use_with avahi mdns)
		$(use_with client)
		$(use_with clipboard)
		$(use_with cuda cuda_kernels)
		$(use_with cuda_rebuild)
		$(use_with csc_swscale)
		$(use_with csc_libyuv)
		$(use_with cups printing)
		--without-debug
		$(use_with dbus)
		$(use_with dec_avcodec2)
		$(use_with enc_ffmpeg)
		$(use_with enc_x264)
		$(use_with enc_x265)
		$(use_with html5)
		$(use_with html5_gzip)
		$(use_with html5_brotli)
		$(use_with jpeg jpeg_encoder)
		$(use_with jpeg jpeg_decoder)
		$(use_with minify)
		$(use_with opengl)
		$(use_with pam)
		--without-PIC
		$(use_with pillow)
		$(use_with notifications)
		$(use_with nvenc)
		$(use_with server)
		$(use_with server shadow)
		$(use_with sound)
		$(use_with sd_listen)
		--with-strict
		$(use_with vpx)
		$(use_with vsock)
		$(use_with v4l2)
		--with-warn
		$(use_with webcam)
		$(use_with webp)
		$(use_with xdg xdg_open)
		$(use_with X x11)
		--without-Xdummy
	)

	if use gtk3 ; then
		mydistutilsargs+=( --without-gtk2 --with-gtk3 )
	else
		mydistutilsargs+=( --without-gtk2 --without-gtk3 )
	fi

	# see https://www.xpra.org/trac/ticket/1080
	# and http://trac.cython.org/ticket/395
	append-cflags -fno-strict-aliasing

	export XPRA_SOCKET_DIRS="${EPREFIX}/run/xpra"
}

python_install_all() {
	distutils-r1_python_install_all
	fperms 0750 /etc/init.d/xpra
	dodir /etc/X11
	cp "${D}"/etc/xpra/xorg.conf "${D}"/etc/X11/xorg.dummy.conf || die

	if use websockets ; then
		dodir /usr/share/xpra
		./setup_html5.py "${D}/usr/share/xpra"
	fi
}

pkg_postinst() {
	einfo "You need to add yourself to the xpra, tty, dialout groups."
	if use opengl ; then
	  einfo "If you are using the amdgpu-pro driver, make sure you are"
	  einfo "using the xorg-x11 driver and update your"
	  einfo "/etc/X11/xorg.conf.d/20opengl.conf so that it has"
	  einfo "/usr/$(get_libdir)/xorg/modules/drivers at the top as follows:"
	  einfo ""
	  einfo "Section \"Files\""
	  einfo "        ModulePath \"/usr/$(get_libdir)/xorg/modules/drivers\""
	  einfo "        ModulePath \"/usr/$(get_libdir)/xorg/modules\""
	  einfo "EndSection"
	  einfo ""
	fi
	if use pillow ; then
		einfo "Manually add jpeg or webp optional USE flags to pillow"
		einfo "package to enable support for them."
	fi
}
