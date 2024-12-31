# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/jliljebl/flowblade.git"
	FALLBACK_COMMIT="13736f8e5882a469a0f794d8e81da9db4741ed80" # Dec 18, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/flowblade-trunk"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/flowblade-trunk"
	SRC_URI="
https://github.com/jliljebl/flowblade/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Non-linear video editor"
HOMEPAGE="
	https://github.com/jliljebl/flowblade
"
LICENSE="
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# Assume X and not Wayland since libsdl2 is not supported.
IUSE+="
alsa frei0r jack jpeg mp3 nvenc opencv opus oss pulseaudio rtaudio rubberband
sox vaapi vidstab vorbis vpx x264 x265
ebuild_revision_4
"
REQUIRED_USE="
	alsa? (
		|| (
			jack
			rtaudio
		)
	)
	oss? (
		jack
	)
	pulseaudio? (
		|| (
			rtaudio
			jack
		)
	)
	rtaudio? (
		|| (
			alsa
			pulseaudio
		)
	)
	|| (
		jack
		rtaudio
	)
	|| (
		mp3
		opus
		vorbis
	)
	|| (
		vaapi
		vpx
		x264
		x265
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/libusb1-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.21[${PYTHON_USEDEP}]
		>=virtual/pillow-9.0.1[${PYTHON_USEDEP}]
	')
	>=dev-lang/python-3.10.4
	>=dev-libs/dbus-glib-0.112
	>=dev-libs/gobject-introspection-1.72.0[${PYTHON_SINGLE_USEDEP}]
	>=gnome-base/librsvg-2.52.5[introspection]
	>=media-libs/mlt-flowblade-7.4.0[${PYTHON_SINGLE_USEDEP},alsa?,ffmpeg,frei0r?,gtk,jack?,libsamplerate,opencv?,oss?,pulseaudio?,python,rtaudio?,rubberband?,sdl,sox?,vidstab?,xml]
	>=media-plugins/swh-plugins-0.4.17
	>=media-video/ffmpeg-4.4.1[encode,mp3?,nvenc?,vaapi?,vpx?,x264?,x265?]
	>=media-video/movit-1.6.3
	>=media-gfx/gmic-2.9.4[cli]
	>=x11-libs/pango-1.50.6[introspection]
	>=x11-libs/gdk-pixbuf-2.42.8[introspection,jpeg?,png(+)]
	>=x11-libs/gtk+-3.24.33[introspection,X]
	frei0r? (
		>=media-plugins/frei0r-plugins-1.7.0
	)
	sox? (
		>=media-sound/sox-14.4.2
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
DOCS=( )
PATCHES=(
	"${FILESDIR}/${PN}-2.18-change-paths.patch"
	"${FILESDIR}/${PN}-2.18-credit-scroll-fixes.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	default
	sed -i \
		-e "s|@EPYTHON@|${EPYTHON}|g" "${PN}" \
		|| die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "AUTHORS"
	dodoc "COPYING"
	dodoc "copyrights"
	mv "${ED}/usr/bin/"{"","."}"flowblade" || die
cat <<EOF > "${ED}/usr/bin/flowblade"
#!/bin/bash
export SDL12COMPAT_NO_QUIT_VIDEO=1
export GDK_BACKEND="x11"
export SDL_VIDEODRIVER="x11"
export LD_LIBRARY_PATH="/usr/lib/mlt-flowblade/$(get_libdir):\${LD_LIBRARY_PATH}"
export PYTHONPATH="/usr/lib/mlt-flowblade/lib/${EPYTHON}/site-packages:\${PYTHONPATH}"
${EPYTHON} "/usr/bin/.flowblade" "\$@"
EOF
	fperms 0755 "/usr/bin/flowblade"
	docinto "readmes"
	dodoc "${WORKDIR}/${P}/README.md"
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASS (2.18, 20241225)
# Audio playback with RtAudio and ALSA - pass
# GUI load - pass
# JPEG show - partial, broken on media thumbnail.
# PNG show - pass
# Save video composition - pass
# Text generators placed on timeline and playback - fail
# Widget show and play video - pass
