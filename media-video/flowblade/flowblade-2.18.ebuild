# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/jliljebl/flowblade.git"
	FALLBACK_COMMIT="13736f8e5882a469a0f794d8e81da9db4741ed80" # Dec 18, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
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
	GPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# Assume X and not wayland since libsdl2 is not supported
IUSE+="
mp3 opus sox vaapi vorbis vpx x264 x265
"
REQUIRED_USE="
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
		>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
		>=dev-python/pycairo-3.42.0[${PYTHON_USEDEP}]
		>=virtual/pillow-9.0.1[${PYTHON_USEDEP}]
	')
	>=dev-lang/python-3.10.4
	>=dev-libs/dbus-glib-0.112
	>=dev-libs/gobject-introspection-1.72.0[${PYTHON_SINGLE_USEDEP}]
	>=gnome-base/librsvg-2.52.5[introspection]
	>=media-libs/mlt-flowblade-7.4.0[${PYTHON_SINGLE_USEDEP},ffmpeg,frei0r,jack,libsamplerate,python,sdl,sox,xml]
	>=media-plugins/frei0r-plugins-1.7.0
	>=media-plugins/swh-plugins-0.4.17
	>=media-video/ffmpeg-4.4.1[encode,mp3?,nvenc,vaapi?,vpx?,x264?,x265?]
	>=media-video/movit-1.6.3
	>=media-gfx/gmic-2.9.4
	>=x11-libs/pango-1.50.6[introspection]
	>=x11-libs/gdk-pixbuf-2.42.8[introspection]
	>=x11-libs/gtk+-3.24.33[introspection,X]
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
	')
	dev-util/patchelf
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	mv "${ED}/usr/bin/flowblade"{"","-gui"}
cat <<EOF > "${ED}/usr/bin/flowblade"
#!/bin/bash
export SDL12COMPAT_NO_QUIT_VIDEO=1
export GDK_BACKEND="x11"
export SDL_VIDEODRIVER="x11"
"/usr/bin/flowblade-gui" "\$@"
EOF
	fperms 0755 "/usr/bin/flowblade"

	patchelf \
		--add-rdepend "/usr/lib/flowblade/$(get_libdir)" \
		"/usr/bin/flowblade-gui" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
