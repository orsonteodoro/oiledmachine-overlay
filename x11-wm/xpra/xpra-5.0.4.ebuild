# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-4)"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream only tests with 3.10

inherit cuda distutils-r1 flag-o-matic linux-info prefix tmpfiles udev
inherit user-info xdg

SRC_URI="
https://github.com/Xpra-org/xpra/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based \
on wimpiggy"
HOMEPAGE="
	http://xpra.org/
	https://github.com/Xpra-org/xpra
"
LICENSE="
	GPL-2+
	BSD-2
	CC-BY-SA-3.0
	LGPL-3+
	MIT
"
# BSD-2 - xpra/buffers/xxhash.c
# CC-BY-3.0 - xpra/platform/win32/printer_notify.py
# GPL-2+ - xpra/gtk_common/about.p
#	- fs/lib/cups/xpraforwarder
# LGPL-3+ - xpra/gtk_common/gtk_notifier.py
# MIT - xpra/platform/win32/lsa_logon_lib.py
#	- xpra/client/gl/gl_colorspace_conversions.py
KEYWORDS="~amd64 ~arm64 ~x86"
GSTREAMER_IUSE+="
aac alsa flac jack lame matroska ogg opus oss pulseaudio speex twolame vorbis
wavpack
"

CUDA_TARGETS_COMPAT=(
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_75
	sm_80
	sm_86
	sm_90 # Added by ebuild
)

IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${GSTREAMER_IUSE}

aes appindicator +audio +avahi avif brotli +client +clipboard cpu-percent
+csc_cython csc_libyuv cuda +cuda_rebuild +cups cups-forwarding +cython +dbus
+doc -drm ffmpeg evdi firejail gnome-shell +gtk3 gssapi html5-client html5_gzip
html5_brotli +http ibus jpeg kerberos +keyboard-layout keycloak ldap ldap3 +lz4
lzo +mdns mysql +netdev +notifications nvenc nvfbc nvjpeg +opengl +openh264
openrc osmesa +pam pinentry png proc +proxy pyinotify qrencode +quic -rencode
+rencodeplus +rfb sd_listen selinux +server +socks sound-forwarding spng sqlite
+ssh sshpass +ssl systemd +tcp-wrappers test tiff u2f -uinput +v4l2 vaapi vpx
vsock -wayland +webcam webcam-forwarding webp +websockets +X x264 -x265 +xdg
+xinput yaml zeroconf zlib
"
# Upstream enables uinput by default.  Disabled because ebuild exists.
# Upstream enables drm by default.  Disabled because unfinished.

# See https://github.com/Xpra-org/xpra/blob/v5.0.4/docs/Build/Dependencies.md
CLIENT_OPTIONS="
	ffmpeg? (
		client
	)
	opengl? (
		client
	)
	sshpass? (
		client
	)
"

SERVER_OPTIONS="
	avahi? (
		server
	)
	cups-forwarding? (
		server
	)
	gssapi? (
		server
	)
	kerberos? (
		server
	)
	ldap? (
		server
	)
	ldap3? (
		server
	)
	nvenc? (
		server
	)
	rfb? (
		server
	)
	sound-forwarding? (
		server
	)
	u2f? (
		server
	)
	x264? (
		server
	)
	webcam-forwarding? (
		server
	)
	zeroconf? (
		server
	)
"

gen_required_use_cuda_targets() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}

# LIMD # ATM, GEN 5-12
# LID # C2M, GEN 5-9
REQUIRED_USE+="
	$(gen_required_use_cuda_targets)
	${CLIENT_OPTIONS}
	${SERVER_OPTIONS}
	gtk3
	audio? (
		pulseaudio
	)
	avahi? (
		dbus
		mdns
	)
	clipboard? (
		gtk3
		|| (
			client
			server
		)
	)
	cuda? (
		^^ (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
		|| (
			nvenc
			nvfbc
			nvjpeg
		)
	)
	cups? (
		dbus
	)
	cups-forwarding? (
		cups
	)
	firejail? (
		client
		server
	)
	gnome-shell? (
		appindicator
	)
	html5-client? (
		websockets
	)
	gtk3? (
		|| (
			X
			wayland
		)
		client? (
			webp
			opengl? (
				jpeg
			)
		)
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
	nvenc? (
		|| (
			cuda_targets_sm_52
			cuda_targets_sm_53
			cuda_targets_sm_60
			cuda_targets_sm_61
			cuda_targets_sm_62
			cuda_targets_sm_70
			cuda_targets_sm_75
			cuda_targets_sm_86
		)
	)
	nvfbc? (
		|| (
			cuda_targets_sm_52
			cuda_targets_sm_61
			cuda_targets_sm_75
			cuda_targets_sm_86
			cuda_targets_sm_90
		)
	)
	nvjpeg? (
		|| (
			cuda_targets_sm_80
		)
	)
	opengl? (
		client
	)
	osmesa? (
		server
	)
	png? (
		zlib
	)
	sd_listen? (
		systemd
	)
	sound-forwarding? (
		pulseaudio
	)
	sshpass? (
		ssh
	)
	test? (
		aes
		rencode
	)
	vpx? (
		ffmpeg
	)
	X? (
		gtk3
	)
	x264? (
		ffmpeg
	)
	x265? (
		ffmpeg
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
PYCUDA_PV="2022.1"
RENCODE_PV="1.0.6"
# From my experience, firejail doesn't need pillow with webp or with jpeg.
# The encoding when set to auto may require jpeg and webp.
# See https://github.com/Xpra-org/xpra/blob/v4.2/docs/Build/Dependencies.md for the full list.

PILLOW_DEPEND="
	dev-python/pillow[${PYTHON_USEDEP},jpeg?,tiff?,webp?,zlib?]
"

RDEPEND+="
	acct-group/xpra
	app-admin/sudo
	dev-lang/python[sqlite?,ssl?]
	dev-libs/gobject-introspection
	dev-libs/glib[dbus?]
	dev-python/pygobject[${PYTHON_USEDEP}]
	aes? (
		dev-python/cryptography[${PYTHON_USEDEP}]
	)
	appindicator? (
		dev-libs/libappindicator[introspection]
		gnome-base/librsvg[introspection]
	)
	audio? (
		dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		media-libs/gst-plugins-bad:1.0[introspection]
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
	avif? (
		>=media-libs/libavif-0.9
	)
	avahi? (
		dev-python/netifaces[${PYTHON_USEDEP}]
		net-dns/avahi[${PYTHON_USEDEP},python]
	)
	brotli? (
		app-arch/brotli[${PYTHON_USEDEP}]
	)
	cuda_targets_sm_52? (
		>=dev-util/nvidia-cuda-toolkit-6.5:=
	)
	cuda_targets_sm_53? (
		>=dev-util/nvidia-cuda-toolkit-6.5:=
	)
	cuda_targets_sm_60? (
		>=dev-util/nvidia-cuda-toolkit-8:=
	)
	cuda_targets_sm_61? (
		>=dev-util/nvidia-cuda-toolkit-8:=
	)
	cuda_targets_sm_62? (
		>=dev-util/nvidia-cuda-toolkit-8:=
	)
	cuda_targets_sm_70? (
		>=dev-util/nvidia-cuda-toolkit-9:=
	)
	cuda_targets_sm_75? (
		>=dev-util/nvidia-cuda-toolkit-10:=
	)
	cuda_targets_sm_80? (
		>=dev-util/nvidia-cuda-toolkit-10:=
	)
	cuda_targets_sm_86? (
		>=dev-util/nvidia-cuda-toolkit-11.1:=
	)
	cuda_targets_sm_90? (
		>=dev-util/nvidia-cuda-toolkit-11.8:=
	)
	cpu-percent? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
	csc_libyuv? (
		media-libs/libyuv
	)
	cups? (
		dev-python/pycups[${PYTHON_USEDEP}]
		cups-forwarding? (
			net-print/cups
			net-print/cups-filters
			net-print/cups-pdf
		)
	)
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		sys-apps/dbus[X?]
	)
	drm? (
		>=x11-libs/libdrm-2.4
	)
	evdi? (
		>=x11-drivers/evdi-1.9
	)
	ffmpeg? (
		>=media-video/ffmpeg-4.0:0=[vpx?,x264?,x265?]
	)
	gnome-shell? (
		gnome-extra/gnome-shell-extension-appindicator
		gnome-extra/gnome-shell-extension-topicons-plus
	)
	gssapi? (
		dev-python/gssapi[${PYTHON_USEDEP}]
	)
	gtk3? (
		>=dev-python/pycairo-1.20.0[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
		dev-libs/gobject-introspection
		x11-libs/gtk+:3[wayland?,X?,introspection]
		x11-libs/pango[introspection]
	)
	html5-client? (
		www-apps/xpra-html5
	)
	ibus? (
		app-i18n/ibus[${PYTHON_USEDEP},gtk3]
	)
	jpeg? (
		${PILLOW_DEPEND}
		>=media-libs/libjpeg-turbo-1.4
	)
	kerberos? (
		dev-python/pykerberos[${PYTHON_USEDEP}]
	)
	keycloak? (
		dev-python/oauthlib[${PYTHON_USEDEP}]
	)
	ldap? (
		dev-python/python-ldap[${PYTHON_USEDEP}]
	)
	ldap3? (
		dev-python/ldap3[${PYTHON_USEDEP}]
	)
	lz4? (
		>=dev-python/lz4-4.0.2[${PYTHON_USEDEP}]
	)
	lzo? (
		>=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-connector-python[${PYTHON_USEDEP}]
	)
	nvenc? (
		>=dev-python/pycuda-${PYCUDA_PV}[${PYTHON_USEDEP}]
		>=dev-util/nvidia-cuda-toolkit-5:=
		dev-python/pynvml[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		media-video/nvidia-video-codec
	)
	nvfbc? (
		>=dev-python/pycuda-${PYCUDA_PV}[${PYTHON_USEDEP}]
		>=dev-util/nvidia-cuda-toolkit-11:=
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	nvjpeg? (
		>=dev-python/pycuda-${PYCUDA_PV}[${PYTHON_USEDEP}]
	        >=dev-util/nvidia-cuda-toolkit-10:=
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	opengl? (
		x11-base/xorg-drivers[video_cards_dummy]
		client? (
			>=dev-python/pyopengl_accelerate-3.1.5[${PYTHON_USEDEP}]
		)
		server? (
			media-libs/mesa[osmesa?]
		)
	)
	openh264? (
		media-libs/openh264
	)
	openrc? (
		sys-apps/net-tools
		sys-apps/openrc[bash]
	)
	pam? (
		sys-libs/pam[selinux?]
	)
	pinentry? (
		app-crypt/pinentry[gtk]
	)
	png? (
		${PILLOW_DEPEND}
	)
	proc? (
		sys-process/procps
	)
	pulseaudio? (
		media-sound/pulseaudio[dbus?]
		sound-forwarding? (
			media-libs/libpulse
		)
	)
	qrencode? (
		media-gfx/qrencode[${PYTHON_USEDEP}]
	)
	quic? (
		dev-python/aioquic[${PYTHON_USEDEP}]
	)
	rencode? (
		>=dev-python/rencode-${RENCODE_PV}[${PYTHON_USEDEP}]
	)
	socks? (
		dev-python/PySocks[${PYTHON_USEDEP}]
	)
	server? (
		x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
		x11-themes/adwaita-icon-theme
	)
	proxy? (
		dev-python/setproctitle[${PYTHON_USEDEP}]
	)
	server? (
		pyinotify? (
			dev-python/pyinotify[${PYTHON_USEDEP}]
		)
	)
	spng? (
		>=media-libs/libspng-0.7
	)
	ssh? (
		dev-python/dnspython[${PYTHON_USEDEP}]
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
	tcp-wrappers? (
		sys-apps/tcp-wrappers
	)
	tiff? (
		${PILLOW_DEPEND}
	)
	u2f? (
		>=dev-python/pyu2f-0.1.5[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
	)
	uinput? (
		>=dev-python/python-uinput-0.11.2[${PYTHON_USEDEP}]
	)
	v4l2? (
		sys-kernel/linux-headers
	)
	vaapi? (
		>=media-libs/libva-2.1.0[drm(+),X?,wayland?]
		>=media-video/ffmpeg-4.4:0=[vaapi]
		media-libs/vaapi-drivers
	)
	vpx? (
		>=media-libs/libvpx-1.4
	)
	vsock? (
		sys-kernel/linux-headers
	)
	webcam? (
		client? (
			>=media-libs/opencv-2.0[${PYTHON_USEDEP},python]
		)
		pyinotify? (
			dev-python/pyinotify[${PYTHON_USEDEP}]
		)
		webcam-forwarding? (
			kernel_linux? (
				media-video/v4l2loopback
			)
		)
	)
	webp? (
		${PILLOW_DEPEND}
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
		x11-libs/libxkbfile
		x11-libs/libXrandr
		x11-libs/libXres
		x11-libs/libXtst
	)
	xdg? (
		dev-python/pyxdg[${PYTHON_USEDEP}]
		x11-misc/xdg-utils
	)
	yaml? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
	zeroconf? (
		dev-python/zeroconf[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	virtual/pkgconfig
	cython? (
		>=dev-python/cython-3.0.0_alpha11[${PYTHON_USEDEP}]
	)
	doc? (
		app-text/pandoc
	)
	test? (
		>=dev-python/rencode-${RENCODE_PV}[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		client? (
			sys-libs/zlib
			X? (
				x11-misc/xclip
			)
		)
	)
	|| (
		sys-devel/gcc[cxx]
		sys-devel/clang
	)
"
RESTRICT="mirror"
S="${WORKDIR}/${P}"
PATCHES=(
	"${FILESDIR}/${PN}-3.0.2_ignore-gentoo-no-compile.patch"
	"${FILESDIR}/${PN}-4.3-openrc-init-fix-v3.patch"
	"${FILESDIR}/${PN}-4.1.3-change-init-config-path.patch"
	"${FILESDIR}/${PN}-4.2-udev-path.patch"
	"${FILESDIR}/${PN}-4.4.3-translate-flags.patch"
)

check_cython() {
	local actual_cython_pv=$(cython --version \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3.0.0_alpha11"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -lt ${required_cython_major} ; then
eerror
eerror "Switch cython to >= ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
}

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

	# Server only
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi

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
	if use nvenc || use nvfbc || use nvjpeg ; then
		cuda_src_prepare
	fi
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
	use cython && check_cython
	if use evdi && [[ ! -e "${ESYSROOT}/usr/$(get_libdir)/pkgconfig/evdi.pc" ]] ; then
eerror
eerror "Missing evdi.pc"
eerror
eerror "See https://github.com/Xpra-org/xpra/issues/3390#issuecomment-1118194059"
eerror
		die
	fi

	sed -i \
	-e "/'pulseaudio'/s:DEFAULT_PULSEAUDIO:$(usex pulseaudio True False):" \
		setup.py || die

	mydistutilsargs=(
		$(use_with audio)
		$(use_with avif)
		$(use_with brotli)
		$(use_with client)
		$(use_with clipboard)
		$(use_with cython)
		$(use_with doc docs)
		$(use_with drm)
		$(use_with netdev)
		$(use_with nvenc cuda_kernels)
		$(use_with nvjpeg nvjpeg_decoder)
		$(use_with nvjpeg nvjpeg_encoder)
		$(use_with csc_cython)
		$(use_with csc_libyuv)
		$(use_with cuda_rebuild)
		$(use_with cups printing)
		$(use_with dbus)
		$(use_with evdi)
		$(use_with ffmpeg csc_swscale)
		$(use_with ffmpeg dec_avcodec2)
		$(use_with ffmpeg enc_ffmpeg)
		$(use_with jpeg jpeg_decoder)
		$(use_with jpeg jpeg_encoder)
		$(use_with keyboard-layout keyboard)
		$(use_with lz4)
		$(use_with mdns)
		$(use_with notifications)
		$(use_with nvenc)
		$(use_with nvfbc)
		$(use_with opengl)
		$(use_with pam)
		$(use_with proc)
		$(use_with proxy)
		$(use_with qrencode)
		$(use_with rfb)
		$(use_with rencodeplus)
		$(use_with server)
		$(use_with server service)
		$(use_with server shadow)
		$(use_with spng spng_decoder)
		$(use_with spng spng_encoder)
		$(use_with sd_listen)
		$(use_with uinput)
		$(use_with vpx)
		$(use_with vsock)
		$(use_with v4l2)
		$(use_with webcam)
		$(use_with webp)
		$(use_with X x11)
		$(use_with x264 enc_x264)
		$(use_with x265 enc_x265)
		$(use_with xdg xdg_open)
		$(use_with xinput)
		--with-strict
		--with-verbose
		--with-warn
		--without-debug
		--without-example
		--without-PIC
		--without-Xdummy
	)

	if use jpeg || use png || use tiff || use webp || use test ; then
		mydistutilsargs+=(
			--with-pillow
		)
	else
		mydistutilsargs+=(
			--without-pillow
		)
	fi

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
