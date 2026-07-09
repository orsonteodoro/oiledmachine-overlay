# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# CI: U24
# Min supported:  U16, D11
# EOL Q1 2025, See https://github.com/Xpra-org/xpra/wiki/Versions

# TODO:
# 6.2.5 -> 6.5.1 update features

MY_PV="$(ver_cut 1-4)"

CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan"
CFLAGS_HARDENED_LANGS="c-lang python"
CFLAGS_HARDENED_USE_CASES="daemon security-critical sensitive-data server untrusted-data"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)
PYTHON_COMPAT=( "python3_"{10..14} ) # See pyproject.toml but disagrees in https://github.com/Xpra-org/xpra/blob/v6.5/.github/workflows/build.yml#L15

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
	"dev-libs/glib-2.89.9999"
	"gnome-base/librsvg-9999"
	"media-libs/libavif-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpulse-9999"
	"media-libs/libwebp-9999"
	"media-libs/libva-9999"
	"media-libs/libvpx-9999"
	"media-libs/mesa-9999"
	"media-libs/opencv-4.9999"
	"media-libs/openh264-9999"
	"net-dns/avahi-9999"
	"net-print/cups-9999"
	"sys-apps/dbus-9999"
	"sys-apps/systemd-9999"
	"sys-process/procps-9999"
	"x11-base/xorg-server-9999"
	"x11-libs/libX11-9999"
	"x11-libs/gtk+-3.24.9999"
)

inherit cflags-hardened chkl cuda cython distutils-r1 flag-o-matic linux-info prefix
inherit secure-version tmpfiles udev user-info xdg

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
	BSD-2
	CC-BY-SA-3.0
	GPL-2+
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
KEYWORDS="~amd64"
GSTREAMER_IUSE=(
aac alsa aom flac jack lame matroska mp3 ogg opus oss pulseaudio speex vorbis
wavpack
)

# wireshark disabled by default for security.
IUSE+="
${GSTREAMER_IUSE[@]}
${PATENT_STATUS_IUSE[@]}

aes amf appindicator +audio +avahi avif brotli +cairo -cityhash clang +client +clipboard
cpu-percent +csc_cython csc_libyuv cuda +cuda_rebuild +cups cups-forwarding
+cython -cythonize-more +dbus +doc -drm evdi firejail gcc gnome-shell +gtk3 gssapi
html5-client html5_gzip html5_brotli +http ibus ism jpeg kerberos +keyboard-layout
keycloak ldap ldap3 +lz4 lzo +mdns +mmap mysql +netdev +notifications -nvdec nvenc
nvfbc nvjpeg +opengl +openh264 openrc osmesa otp +pam pinentry png proc +proxy
-pyglet pyinotify +torch qrencode +quic -qt6 remote-encoder -rencode +rencodeplus +rfb
sd_listen selinux +server +socks sound-forwarding sql sqlite +ssh sshpass
+ssl systemd +tcp-wrappers test tiff -tk u2f -uinput +v4l2 vaapi vpx vsock
wayland +webcam webcam-forwarding webp +websockets +websockets-browser-cookie
-wireshark +X x264 +xdg xdummy +xinput +yaml zeroconf zlib
ebuild_revision_26
"
# Upstream enables uinput by default.  Disabled because ebuild exists.
# Upstream enables drm by default.  Disabled because unfinished.

# See https://github.com/Xpra-org/xpra/blob/v6.5.1/docs/Build/Dependencies.md
CLIENT_OPTIONS="
	client? (
		|| (
			gtk3
			qt6
			pyglet
			tk
		)
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

PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!aac
		!amf
		!nvdec
		!nvenc
		!openh264
		!vaapi
		!x264
	)
	aac? (
		patent_status_nonfree
	)
	amf? (
		patent_status_nonfree
	)
	nvdec? (
		patent_status_nonfree
	)
	nvenc? (
		patent_status_nonfree
	)
	openh264? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
"

# LIMD # ATM, GEN 5-12
# LID # C2M, GEN 5-9
REQUIRED_USE+="
	${CLIENT_OPTIONS}
	${PATENT_STATUS_REQUIRED_USE}
	${SERVER_OPTIONS}
	avif
	cython
	gtk3
	rencodeplus
	^^ (
		clang
		gcc
	)
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
		cython
		rencodeplus
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
	X? (
		cairo
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
PYCUDA_PV="2022.1"
RENCODE_PV="1.0.6"
# From my experience, firejail doesn't need pillow with webp or with jpeg.
# The encoding when set to auto may require jpeg and webp.
# See https://github.com/Xpra-org/xpra/blob/v6.2.1/docs/Build/Dependencies.md for the full list.

PILLOW_DEPEND="
	$(python_gen_cond_dep "
		virtual/pillow[\${PYTHON_USEDEP},jpeg?,tiff?,webp?,zlib?]
	")
"

PYOPENGL_VER=(
	"3.1.9"
)

gen_opengl_rdepend() {
	local s
	for s in ${PYOPENGL_VER[@]} ; do
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo "
				python_single_target_${impl}? (
					~dev-python/pyopengl-${s}[python_targets_${impl}(-)]
					~dev-python/pyopengl-accelerate-${s}[python_targets_${impl}(-)]
				)
			"
		done
	done
}

PATENT_STATUS_RDEPEND="
	virtual/patent-status:*[patent_status_nonfree=]
	!patent_status_nonfree? (
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=[-amf]
		>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[aom?,ogg?,-vaapi,vpx?,-x264]
		audio? (
			!media-plugins/gst-plugins-faac
			!media-plugins/gst-plugins-faad
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[-aac,alsa?,flac?,jack?,lame?,mp3?,ogg?,opus?,oss?,-patent_status_nonfree,pulseaudio?,speex?,vorbis?,wavpack?]
		)
		nvdec? (
			>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=[-nvcodec]
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[-nvcodec]
		)
		nvenc? (
			>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=[-nvcodec]
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[-nvcodec]
		)
	)
	patent_status_nonfree? (
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=[amf?]
		>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[aom?,ogg?,vaapi?,vpx?,x264?]
		audio? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[aac?,alsa?,flac?,jack?,lame?,mp3?,ogg?,opus?,oss?,patent_status_nonfree,pulseaudio?,speex?,vorbis?,wavpack?]
		)
		nvdec? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[nvcodec]
		)
		nvenc? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:=[nvcodec]
		)
	)
"

# The media-video/nvidia-video-codec-sdk is a placeholder.  You need to package
# it yourself locally.  See also
# https://github.com/Xpra-org/xpra/blob/v6.2.1/docs/Usage/NVENC.md?plain=1
# https://developer.nvidia.com/nvidia-video-codec-sdk/download
# https://developer.nvidia.com/video-codec-sdk-archive
RDEPEND+="
	${PATENT_STATUS_RDEPEND}
	$(python_gen_cond_dep "
		dev-python/pygobject[\${PYTHON_USEDEP}]
		aes? (
			dev-python/cryptography[\${PYTHON_USEDEP}]
		)
		audio? (
			dev-python/gst-python[\${PYTHON_USEDEP}]
		)
		avahi? (
			dev-python/netifaces:=[\${PYTHON_USEDEP}]
			>=net-dns/avahi-${AVAHI_PV}:=[\${PYTHON_USEDEP},python]
		)
		brotli? (
			>=app-arch/brotli-${BROTLI_PV}:=[\${PYTHON_USEDEP}]
		)
		cairo? (
			>=dev-python/pycairo-1.20.0[\${PYTHON_USEDEP}]
		)
		cpu-percent? (
			dev-python/psutil[\${PYTHON_USEDEP}]
		)
		cups? (
			dev-python/pycups[\${PYTHON_USEDEP}]
		)
		dbus? (
			dev-python/dbus-python[\${PYTHON_USEDEP}]
		)
		gssapi? (
			dev-python/gssapi[\${PYTHON_USEDEP}]
		)
		gtk3? (
			dev-python/pygobject:=[\${PYTHON_USEDEP},cairo]
		)
		ibus? (
			app-i18n/ibus:=[\${PYTHON_USEDEP},gtk3]
		)
		kerberos? (
			dev-python/pykerberos[\${PYTHON_USEDEP}]
		)
		keycloak? (
			dev-python/oauthlib[\${PYTHON_USEDEP}]
		)
		ldap? (
			dev-python/python-ldap[\${PYTHON_USEDEP}]
		)
		ldap3? (
			dev-python/ldap3[\${PYTHON_USEDEP}]
		)
		lz4? (
			>=dev-python/lz4-4.0.2[\${PYTHON_USEDEP}]
		)
		lzo? (
			>=dev-python/python-lzo-0.7.0[\${PYTHON_USEDEP}]
		)
		mysql? (
			dev-python/mysql-connector-python[\${PYTHON_USEDEP}]
		)
		nvenc? (
			>=dev-python/pycuda-${PYCUDA_PV}[\${PYTHON_USEDEP}]
			>=dev-util/nvidia-cuda-toolkit-5:=
			>=media-video/nvidia-video-codec-sdk-10
			dev-python/pynvml[\${PYTHON_USEDEP}]
			virtual/numpy:=[\${PYTHON_USEDEP}]
		)
		nvfbc? (
			>=dev-python/pycuda-${PYCUDA_PV}[\${PYTHON_USEDEP}]
			>=dev-util/nvidia-cuda-toolkit-11:=
			virtual/numpy:=[\${PYTHON_USEDEP}]
		)
		nvjpeg? (
			>=dev-python/pycuda-${PYCUDA_PV}[\${PYTHON_USEDEP}]
		        >=dev-util/nvidia-cuda-toolkit-10:=
			virtual/numpy:=[\${PYTHON_USEDEP}]
		)
		otp? (
			dev-python/pyotp[\${PYTHON_USEDEP}]
		)
		proxy? (
			dev-python/setproctitle[\${PYTHON_USEDEP}]
		)
		pyglet? (
			dev-python/pyglet[\${PYTHON_USEDEP}]
		)
		qrencode? (
			media-gfx/qrencode[\${PYTHON_USEDEP}]
		)
		qt6? (
			dev-python/pyqt6[\${PYTHON_USEDEP}]
		)
		quic? (
			dev-python/aioquic[\${PYTHON_USEDEP}]
		)
		rencode? (
			>=dev-python/rencode-${RENCODE_PV}[\${PYTHON_USEDEP}]
		)
		sql? (
			dev-python/sqlalchemy[\${PYTHON_USEDEP}]
		)
		server? (
			pyinotify? (
				dev-python/pyinotify[\${PYTHON_USEDEP}]
			)
		)
		socks? (
			dev-python/PySocks[\${PYTHON_USEDEP}]
		)
		ssh? (
			dev-python/dnspython[\${PYTHON_USEDEP}]
			sshpass? (
				net-misc/sshpass:=
			)
			|| (
				(
					dev-python/bcrypt[\${PYTHON_USEDEP}]
					dev-python/paramiko[\${PYTHON_USEDEP}]
				)
				virtual/ssh:*
			)
		)
		tk? (
			dev-lang/python[tk]
		)
		u2f? (
			>=dev-python/pyu2f-0.1.5[\${PYTHON_USEDEP}]
			dev-python/cryptography[\${PYTHON_USEDEP}]
		)
		uinput? (
			>=dev-python/python-uinput-0.11.2[\${PYTHON_USEDEP}]
		)
		webcam? (
			pyinotify? (
				dev-python/pyinotify[\${PYTHON_USEDEP}]
			)
		)
		websockets? (
			dev-python/websockify[\${PYTHON_USEDEP}]
		)
		websockets-browser-cookie? (
			dev-python/browser-cookie3[\${PYTHON_USEDEP}]
			dev-python/keyring[\${PYTHON_USEDEP}]
			dev-python/pbkdf2[\${PYTHON_USEDEP}]
			dev-python/pyaes[\${PYTHON_USEDEP}]
		)
		xdg? (
			dev-python/pyxdg[\${PYTHON_USEDEP}]
			x11-misc/xdg-utils:=
		)
		yaml? (
			dev-python/pyyaml[\${PYTHON_USEDEP}]
		)
		zeroconf? (
			dev-python/zeroconf[\${PYTHON_USEDEP}]
		)
	")
	acct-group/xpra:*
	app-admin/sudo:=
	dev-lang/python:=[sqlite?,ssl?]
	>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=[dbus?]
	appindicator? (
		dev-libs/libappindicator:=[introspection]
		>=gnome-base/librsvg-${LIBRSVG_PV}:=[introspection]
	)
	audio? (
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=[introspection]
		>=media-libs/gst-plugins-base-${GSTREAMER_PV}:=[introspection]
		>=media-libs/gstreamer-${GSTREAMER_PV}:=[introspection]
		matroska? (
			>=media-libs/gst-plugins-good-${GSTREAMER_PV}:=
		)
	)
	avif? (
		>=media-libs/libavif-${LIBAVIF_PV}:=
	)
	csc_libyuv? (
		>=media-libs/libyuv-${LIBYUV_PV}:=
	)
	cups? (
		cups-forwarding? (
			>=net-print/cups-${CUPS_PV}:=
			net-print/cups-filters:=
			net-print/cups-pdf:=
		)
	)
	dbus? (
		>=sys-apps/dbus-${DBUS_PV}:=[X?]
	)
	drm? (
		>=x11-libs/libdrm-${LIBDRM_PV}:=
	)
	evdi? (
		>=x11-drivers/evdi-1.9:=
	)
	gnome-shell? (
		gnome-extra/gnome-shell-extension-appindicator:=
		gnome-extra/gnome-shell-extension-topicons-plus:=
	)
	gtk3? (
		>=dev-libs/gobject-introspection-${GOBJECT_INTROSPECTION_PV}:=
		>=x11-libs/gtk+-${GTK3_PV}:3=[wayland?,X?,introspection]
		>=x11-libs/pango-${PANGO_PV}:=[introspection]
	)
	html5-client? (
		www-apps/xpra-html5:*
	)
	jpeg? (
		${PILLOW_DEPEND}
		>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	)
	opengl? (
		x11-base/xorg-drivers:=[video_cards_dummy]
		client? (
			$(gen_opengl_rdepend)
			dev-python/pyopengl:=
			dev-python/pyopengl-accelerate:=
		)
		server? (
			>=media-libs/mesa-${MESA_PV}:=[osmesa?]
		)
	)
	openh264? (
		>=media-libs/openh264-${OPENH264_PV}:=
	)
	openrc? (
		sys-apps/net-tools:=
		sys-apps/openrc:=[bash]
	)
	pam? (
		sys-libs/pam:=[selinux?]
	)
	pinentry? (
		app-crypt/pinentry:=[gtk]
	)
	png? (
		${PILLOW_DEPEND}
	)
	proc? (
		>=sys-process/procps-${PROCPS_PV}:=
	)
	pulseaudio? (
		>=media-libs/libpulse-${LIBPULSE_PV}:=[dbus?]
		sound-forwarding? (
			>=media-libs/libpulse-${LIBPULSE_PV}:=
		)
	)
	server? (
		>=x11-base/xorg-server-${XORG_SERVER_PV}:=[-minimal,xvfb]
		x11-drivers/xf86-input-void:=
		x11-themes/adwaita-icon-theme:=
	)
	systemd? (
		>=sys-apps/systemd-${SYSTEMD_PV}:=
	)
	tcp-wrappers? (
		sys-apps/tcp-wrappers:=
	)
	tiff? (
		${PILLOW_DEPEND}
	)
	torch? (
		sci-ml/pytorch:=[${PYTHON_SINGLE_USEDEP}]
	)
	v4l2? (
		sys-kernel/linux-headers:=
	)
	vaapi? (
		>=media-libs/libva-${LIBVA_PV}:=[drm(+),X?,wayland?]
		virtual/vaapi:*
	)
	vpx? (
		>=media-libs/libvpx-${LIBVPX_PV}:=
	)
	vsock? (
		sys-kernel/linux-headers:=
	)
	webcam? (
		client? (
			~media-libs/opencv-${OPENCV4_PV}:=[${PYTHON_SINGLE_USEDEP},python]
		)
		webcam-forwarding? (
			kernel_linux? (
				media-video/v4l2loopback:=
			)
		)
	)
	webp? (
		${PILLOW_DEPEND}
		>=media-libs/libwebp-${LIBWEBP_PV}:=
	)
	X? (
		>=x11-base/xorg-server-${XORG_SERVER_PV}:=[xvfb]
		>=x11-libs/libX11-${LIBX11_PV}:=
		x11-libs/libXcomposite:=
		x11-libs/libXdamage:=
		>=x11-libs/libXfixes-${LIBXFIXES_PV}:=
		>=x11-libs/libXi-${LIBXI_PV}:=
		>=x11-libs/libxkbfile-${LIBXKBFILE_PV}:=
		>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
		x11-libs/libXres:=
		>=x11-libs/libXtst-${LIBXTST_PV}:=
		xdummy? (
			x11-drivers/xf86-video-dummy:=
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep "
		cython? (
			>=dev-python/cython-3.0.0_alpha11[\${PYTHON_USEDEP}]
			=dev-python/cython-3*:=
			dev-python/xxhash
		)
		test? (
			>=dev-python/rencode-${RENCODE_PV}[\${PYTHON_USEDEP}]
			dev-python/cryptography[\${PYTHON_USEDEP}]
			virtual/numpy:=[\${PYTHON_USEDEP}]
			client? (
				>=virtual/zlib-${ZLIB_PV}
				X? (
					x11-misc/xclip
				)
			)
		)
	")
	virtual/pkgconfig
	clang? (
		llvm-core/clang:=
	)
	doc? (
		app-text/pandoc
	)
	gcc? (
		sys-devel/gcc:=[cxx]
	)
"
RESTRICT="mirror"
S="${WORKDIR}/${P}"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.4_ignore-gentoo-no-compile.patch"
	"${FILESDIR}/${PN}-4.3-openrc-init-fix-v3.patch"
	"${FILESDIR}/${PN}-4.1.3-change-init-config-path.patch"
	"${FILESDIR}/${PN}-6.5.1-udev-path.patch"
	"${FILESDIR}/${PN}-6.5.1-translate-flags.patch"
	"${FILESDIR}/${PN}-6.5.1-pkgconfig-warn.patch"
)

pkg_setup() {
	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag to continue."
	fi
	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag to continue."
	fi
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

	python-single-r1_pkg_setup
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
#	if use firejail ; then
#		eapply "${FILESDIR}/${PN}-4.1.3-envar-sound-override-on-start.patch"
#		:
#	fi
	if use pam ; then
		if ! use selinux ; then
			sed -r -i \
		-e "s|^session(.*)pam_selinux.so|#session\1pam_selinux.so|g" \
				"fs/etc/pam.d/xpra" \
				|| die
		fi
		if ! use systemd ; then
			sed -r -i \
		-e "s|^session(.*)pam_systemd.so|#session\1pam_systemd.so|g" \
				"fs/etc/pam.d/xpra" \
				|| die
		fi
	fi

	if ! use amf ; then
		eapply "${FILESDIR}/${PN}-6.5.1-disable-amf.patch"
	fi
}

python_prepare_all() {
	hprefixify -w '/os.path/' setup.py
	hprefixify \
		"tmpfiles.d/xpra.conf" \
		"xpra/server/server_util.py" \
		"xpra/platform"{"/xposix",""}"/paths.py" \
		"xpra/scripts/server.py"

	sed -r \
		-i \
		-e "/\bdoc_dir =/s:/${PN}\":/${PF}/html\":" \
		"setup.py" \
		|| die

	sed -i \
		-e "s|^opengl =|#opengl =|g" \
		"fs/etc/xpra/conf.d/40_client.conf.in" \
		|| die
	if use opengl ; then
		sed -i \
			-e "s|#opengl = yes|opengl = yes|g" \
			"fs/etc/xpra/conf.d/40_client.conf.in" \
			|| die
	else
		sed -i \
			-e "s|#opengl = no|opengl = no|g" \
			"fs/etc/xpra/conf.d/40_client.conf.in" \
			|| die
		sed -i \
			-e 's|"+extension", "GLX"|"-extension", "GLX"|g' \
			"xpra/scripts/config.py" \
			|| die
	fi

	distutils-r1_python_prepare_all
}

python_configure() {
	if use cython ; then
		cython_set_cython_slot "3"
		cython_python_configure
	fi
}

python_configure_all() {
	chkl_check_many_timestamps
	cflags-hardened_append
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
		"setup.py" \
		|| die

	# For switches, see https://github.com/Xpra-org/xpra/blob/v6.5.1/setup.py#L429
	DISTUTILS_ARGS=(
		$(use_with amf)
		$(use_with amf amf_encoder)
		#$(use_with aom)
		$(use_with audio)
		$(use_with audio gstreamer_audio)
		$(use_with avif)
		$(use_with brotli)
		$(use_with client)
		$(use_with clipboard)
		$(use_with cython)
		$(use_with doc docs)
		$(use_with doc pandoc_lua)
		$(use_with drm)
		$(use_with netdev)
		$(use_with nvenc cuda_kernels)
		$(use_with nvjpeg nvjpeg_decoder)
		$(use_with nvjpeg nvjpeg_encoder)
		$(use_with cairo)
		$(use_with cityhash)
		$(use_with csc_cython)
		$(use_with csc_libyuv)
		$(use_with cuda_rebuild)
		$(use_with cups printing)
		$(use_with dbus)
		$(use_with evdi)
		$(use_with ism ism_ext)
		$(use_with jpeg jpeg_decoder)
		$(use_with jpeg jpeg_encoder)
		$(use_with keyboard-layout keyboard)
		$(use_with lz4)
		$(use_with mdns)
		$(use_with mmap)
		$(use_with notifications)
		$(use_with nvdec)
		$(use_with nvenc)
		$(use_with nvfbc)
		$(use_with opengl)
		$(use_with openh264)
		$(use_with pam)
		$(use_with proc)
		$(use_with proxy)
		$(use_with pyglet pyglet_client)
		$(use_with qrencode)
		$(use_with qt6 qt6_client)
		$(use_with rfb)
		$(use_with remote-encoder remote_encoder)
		$(use_with rencodeplus)
		$(use_with server)
		$(use_with server service)
		$(use_with server shadow)
		$(use_with sd_listen)
		$(use_with ssl)
		$(use_with tk tk_client)
		$(use_with torch pytorch)
		$(use_with uinput)
		$(use_with vpx)
		$(use_with vsock)
		$(use_with v4l2)
		$(use_with wayland wayland_client)
		$(use_with wayland wayland_server)
		$(use_with webcam)
		$(use_with websockets)
		$(use_with websockets-browser-cookie websockets_browser_cookie)
		$(use_with webp)
		$(use_with wireshark)
		$(use_with X argb)
		$(use_with X x11)
		$(use_with x264 enc_x264)
		$(use_with xdg xdg_open)
		$(use_with xdummy Xdummy)
		$(use_with xinput)
		$(use_with yaml)
		--with-keyboard
#		--with-strict
		--with-verbose
		--without-cython_freethreading # mitigate RC, TOCTOU
		--without-example
		--without-debug
		--without-mf_decoder
		--without-peercred
		--without-PIC
		--without-warn
	)

	if use cythonize-more ; then
		DISTUTILS_ARGS+=(
			--with-cythonize_more
		)
	fi

	if use jpeg || use png || use tiff || use webp || use test ; then
		DISTUTILS_ARGS+=(
			--with-pillow
		)
	else
		DISTUTILS_ARGS+=(
			--without-pillow
		)
	fi

	if use gtk3 ; then
		DISTUTILS_ARGS+=(
			--with-gtk3
		)
		if use X ; then
			DISTUTILS_ARGS+=(
				--with-gtk_x11
			)
		fi
	else
		DISTUTILS_ARGS+=(
			--without-gtk3
			--without-gtk_x11
		)
	fi

	# See
	# https://www.xpra.org/trac/ticket/1080
	# http://trac.cython.org/ticket/395
#	append-cflags -fno-strict-aliasing

	export XPRA_SOCKET_DIRS="${EPREFIX}/run/xpra"
	export UDEVDIR=$(get_udevdir)
	export DISTUTILS_ARGS
	einfo "DISTUTILS_ARGS:  ${DISTUTILS_ARGS[@]}"
	addpredict "/var/lib/rpm/Index.db"
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
	if use doc ; then
		mv \
			"${ED}/usr/share/doc/xpra" \
			"${ED}/usr/share/doc/${PN}-${PVR}" \
			|| die
	fi
	if use openrc && use server && [[ -e "${ED}/etc/init.d/xpra" ]] ; then
		fperms 0750 "/etc/init.d/xpra"
	fi
	if use X && has_version "x11-base/xorg-drivers[video_cards_dummy]" && [[ -e "${ED}/etc/xpra/xorg.conf" ]] ; then
		dodir "/etc/X11"
		cp \
			"${ED}/etc/xpra/xorg.conf" \
			"${ED}/etc/X11/xorg.dummy.conf" \
			|| die
	fi
	if ! use openrc ; then
		rm -f "${ED}/etc/init.d/${PN}"
	fi
	if ! use systemd ; then
		rm -f "${ED}/lib/systemd/system/xpra.service"
		rm -f "${ED}/lib/systemd/system/xpra-nosocketactivation.service"
	fi
	python_fix_shebang "${ED}"
}

pkg_postinst() {
	tmpfiles_process "/usr/lib/tmpfiles.d/xpra.conf"
	xdg_pkg_postinst
einfo
einfo "You need to add yourself to the xpra, tty, dialout groups."
einfo
elog
elog "You need to enable the xpra service for this to work."
elog
	if which rc-update >/dev/null 2>&1 ; then
elog
elog "For OpenRC, do:"
elog
elog "  rc-update add xpra"
elog "  /etc/init.d/xpra restart"
elog
	fi
	if which systemctl >/dev/null 2>&1 ; then
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
# OILEDMACHINE-OVERLAY-TEST:  PASSED (6.2.1, 20250118)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (6.2.5, 20250814)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (6.3.2, 20250814)
# USE="X avif client cython firejail gtk3 rencodeplus server webp -aac -aes
# -alsa -amf -aom -appindicator -audio -avahi -brotli -cityhash -clipboard
# -cpu-percent -csc_cython -csc_libyuv -cuda -cuda_rebuild -cups
# -cups-forwarding -cythonize-more -dbus (-debug) -doc -drm -evdi -flac
# -gnome-shell -gssapi -html5-client -html5_brotli -html5_gzip -http -ibus -jack
# -jpeg -kerberos -keyboard-layout -keycloak -lame -ldap -ldap3 -lz4 -lzo
# -matroska -mdns -mp3 -mysql -netdev -notifications -nvdec -nvenc -nvfbc
# -nvjpeg -ogg -opengl -openh264 -openrc -opus -osmesa -oss -pam -pinentry -png
# -proc -proxy -pulseaudio -pyinotify -qrencode -qt6 -quic -rencode -rfb
# -sd_listen (-selinux) -socks -sound-forwarding -speex -spng -sqlite -ssh
# -sshpass -ssl -systemd -tcp-wrappers -test -tiff -u2f -uinput -v4l2 -vaapi
# -vorbis -vpx -vsock -wavpack -wayland -webcam -webcam-forwarding -websockets
# -x264 -xdg -xinput -yaml -zeroconf -zlib"
# CUDA_TARGETS="-sm_52 -sm_53 -sm_60 -sm_61 -sm_62 -sm_70 -sm_75 -sm_80 -sm_86
# -sm_90"
# EBUILD_REVISION="-2"
# PATENT_STATUS="-nonfree"
# PYTHON_TARGETS="python3_10 -python3_12"
