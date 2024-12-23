# Copyright 2024 Orson Teodoro
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Restrict=test needs unpackaged 'kwalify'
# rtaudio will use OSS on non linux OSes
# Qt already needs FFTW/PLUS so let's just always have it on to ensure
# MLT is useful: bug #603168.

MY_PN="mlt"

PYTHON_COMPAT=( "python3_"{10..13} )
inherit python-single-r1 cmake flag-o-matic

KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/mltframework/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}.tar.gz
"

DESCRIPTION="MLT Multimedia Framework for the flowblade ebuild"
HOMEPAGE="https://www.mltframework.org/"
LICENSE="GPL-3"
SLOT="0/7"
IUSE="
debug ffmpeg frei0r gtk jack libsamplerate opencv opengl python qt6 rtaudio
rubberband sdl sdl2 sox test vdpau vidstab xine xml
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
RESTRICT="
	test
"
DEPEND="
	>=media-libs/libebur128-1.2.2:=
	sci-libs/fftw:3.0
	sci-libs/fftw:=
	ffmpeg? (
		media-video/ffmpeg:0[vdpau?]
		media-video/ffmpeg:=
	)
	frei0r? (
		media-plugins/frei0r-plugins
	)
	gtk? (
		media-libs/libexif
		x11-libs/pango
	)
	jack? (
		>=dev-libs/libxml2-2.5
		media-libs/ladspa-sdk
		virtual/jack
	)
	libsamplerate? (
		>=media-libs/libsamplerate-0.1.2
	)
	opencv? (
		>=media-libs/opencv-4.5.1:=[contrib]
		|| (
			media-libs/opencv[ffmpeg,gstreamer]
		)
	)
	opengl? (
		media-libs/libglvnd
		media-video/movit
	)
	python? (
		${PYTHON_DEPS}
	)
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
		dev-qt/qtsvg:6
		media-libs/libexif
		x11-libs/libX11
	)
	rtaudio? (
		>=media-libs/rtaudio-4.1.2
		kernel_linux? (
			media-libs/alsa-lib
		)
	)
	rubberband? (
		media-libs/rubberband:=
	)
	sdl? (
		media-libs/libsdl[X,opengl,video]
		media-libs/sdl-image
	)
	sdl2? (
		media-libs/libsdl2[X,opengl,video]
		media-libs/sdl2-image
	)
	sox? (
		media-sound/sox
	)
	vidstab? (
		media-libs/vidstab
	)
	xine? (
		>=media-libs/xine-lib-1.1.2_pre20060328-r7
	)
	xml? (
		>=dev-libs/libxml2-2.5
	)
"
_TRASH="
	java? (
		>=virtual/jre-1.8:*
	)
	perl? (
		dev-lang/perl
	)
	php? (
		dev-lang/php
	)
	ruby? (
		${RUBY_DEPS}
	)
	tcl? (
		dev-lang/tcl:0=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	python? (
		>=dev-lang/swig-2.0
	)
"
DOCS=( "AUTHORS" "NEWS" "README.md" )
PATCHES=(
	# Downstream
	"${FILESDIR}/${MY_PN}-6.10.0-swig-underlinking.patch"
	"${FILESDIR}/${MY_PN}-6.22.1-no_lua_bdepend.patch"
	"${FILESDIR}/${MY_PN}-7.0.1-cmake-symlink.patch"
	# In git master, https://github.com/mltframework/mlt/issues/1020
	"${FILESDIR}/${MY_PN}-7.28.0-fix-32bit.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	if use python; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" \
			"src/swig/python/build" \
			|| die
		python_fix_shebang "src/swig/python"
	fi

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #919981
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/lib/mtl-flowblade"
		-DBUILD_TESTING=OFF # Needs unpackaged 'kwalify'; restricted anyway.
		-DCLANG_FORMAT=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DGPL=ON
		-DGPL3=ON
		-DMOD_AVFORMAT=$(usex ffmpeg)
		-DMOD_GLAXNIMATE=OFF
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_GLAXNIMATE_QT6=$(usex qt6)
		-DMOD_JACKRACK=$(usex jack)
		-DMOD_KDENLIVE=ON
		-DMOD_MOVIT=$(usex opengl)
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_PLUS=ON
		-DMOD_SDL1=$(usex sdl)
		-DMOD_SOX=$(usex sox)
		-DMOD_QT6=$(usex qt6)
		-DMOD_QT=OFF
		-DMOD_RESAMPLE=$(usex libsamplerate)
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband)
		-DMOD_SDL2=$(usex sdl)
		-DMOD_SPATIALAUDIO=OFF # TODO: package libspatialaudio
		-DMOD_VIDSTAB=$(usex vidstab)
		-DMOD_XINE=$(usex xine)
		-DMOD_XML=$(usex xml)
		-DUSE_LV2=OFF	# TODO
		-DUSE_VST2=OFF	# TODO
	)

	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python; then
		mycmakeargs+=(
			-DPython3_EXECUTABLE="${PYTHON}"
			-DSWIG_PYTHON=ON
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/usr/share/${PN}"
	doins -r "demo"

	#
	# Install SWIG bindings
	#

	docinto "swig"

	if use python; then
		dodoc "${S}/src/swig/python/play.py"
		python_optimize
	fi
}
