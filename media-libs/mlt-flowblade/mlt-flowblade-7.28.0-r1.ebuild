# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is based on the distro's mlt ebuild but without the
# politics of for or against libsdl1.  In the distro ebuild, the
# libsdl1 is forced off but Flowblade or it's dependencies needs
# libsdl1.  In the bug reports, the ebuild maintainer(s) refuse
# to add libsdl1 support, so you cannot have Flowblade with distro
# ebuild (bug #592380).  The newer mlt is likely incompatible
# with Flowblade or LTS because it is C++ standard 20.

# restrict=test needs unpackaged 'kwalify'
# rtaudio will use OSS on non linux OSes.
#
# Qt already needs FFTW/PLUS, so let's ensure it is always on.
# MLT is useful.  See bug #603168.

MY_PN="mlt"

CXX_STANDARD=17
CFLAGS_HARDENED_USE_CASES="untrusted-data"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream tests up to 3.11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_4[@]}"
)

inherit python-single-r1 cflags-hardened cmake flag-o-matic libcxx-slot libstdcxx-slot

KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/mltframework/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}.tar.gz
"

DESCRIPTION="MLT Multimedia Framework for the flowblade ebuild"
HOMEPAGE="
	https://www.mltframework.org/
	https://github.com/mltframework/mlt
"
LICENSE="
	GPL-2+
	GPL-3+
	LGPL-2.1+
"
SLOT="0/7"
IUSE="
alsa debug +ffmpeg +frei0r +gtk +jack +libsamplerate opencv oss pulseaudio +python
+rtaudio +rubberband +sdl +sox test vdpau +vidstab +xine +xml
ebuild_revision_3
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
	alsa? (
		media-libs/alsa-lib
	)
	ffmpeg? (
		|| (
			media-video/ffmpeg:56.58.58[vdpau?]
			media-video/ffmpeg:0/56.58.58[vdpau?]
		)
		media-video/ffmpeg:=
	)
	frei0r? (
		media-plugins/frei0r-plugins[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		media-plugins/frei0r-plugins:=
	)
	gtk? (
		media-libs/libexif
		x11-libs/pango
	)
	jack? (
		>=dev-libs/libxml2-2.5
		media-libs/ladspa-sdk[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		media-libs/ladspa-sdk:=
		virtual/jack
		alsa? (
			|| (
				(
					media-sound/jack2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},alsa]
					media-sound/jack2:=
				)
				media-sound/jack-audio-connection-kit[alsa]
				media-video/pipewire
			)
		)
		oss? (
			media-sound/jack-audio-connection-kit[oss]
		)
		pulseaudio? (
			media-video/pipewire
		)
	)
	libsamplerate? (
		>=media-libs/libsamplerate-0.1.2
	)
	opencv? (
		>=media-libs/opencv-4.5.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},contrib]
		media-libs/opencv:=
		|| (
			media-libs/opencv[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},ffmpeg,gstreamer]
		)
	)
	pulseaudio? (
		media-libs/libpulse
	)
	python? (
		${PYTHON_DEPS}
	)
	rtaudio? (
		>=media-libs/rtaudio-4.1.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},alsa?,pulseaudio?]
		media-libs/rtaudio:=
		kernel_linux? (
			media-libs/alsa-lib
		)
	)
	rubberband? (
		media-libs/rubberband[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		media-libs/rubberband:=
	)
	sdl? (
		media-libs/libsdl[X,opengl,video]
		media-libs/sdl-image
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
DEPEND_DISABLED="
	java? (
		>=virtual/jre-1.8:*
		virtual/jre:=
	)
	opengl? (
		media-libs/libglvnd
		media-video/movit[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	perl? (
		dev-lang/perl
	)
	php? (
		dev-lang/php
	)
	qt6? (
		dev-qt/qt5compat:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qt5compat:=
		dev-qt/qtbase:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,network,opengl,widgets,xml]
		dev-qt/qtbase:=
		dev-qt/qtsvg:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qtsvg:=
		media-libs/libexif
		x11-libs/libX11
	)
	ruby? (
		${RUBY_DEPS}
	)
	sdl2? (
		media-libs/libsdl2[X,opengl,video]
		media-libs/sdl2-image
	)
	tcl? (
		dev-lang/tcl:0
		dev-lang/tcl:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	python? (
		>=dev-lang/swig-2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
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
	"${FILESDIR}/${MY_PN}-7.28.0-lib-path.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	# Respect CFLAGS LDFLAGS when building shared libraries.
	# See bug #308873
	if use python ; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" \
			"src/swig/python/build" \
			|| die
		python_fix_shebang "src/swig/python"
	fi

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #919981
	append-ldflags $(test-flags-CCLD "-Wl,--undefined-version")

	cflags-hardened_append
	ffmpeg_src_configure

	local libdir=$(get_libdir)
	sed -i \
		-e "s|@LIBDIR@|${libdir}|g" \
		"src/framework/mlt_factory.c" \
		|| die

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/lib/mlt-flowblade"
	# Testing needs unpackaged 'kwalify'.  It's restricted anyway. \
		-DBUILD_TESTING=OFF
		-DCLANG_FORMAT=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DGPL=ON
		-DGPL3=ON
		-DMOD_AVFORMAT=$(usex ffmpeg)
		-DMOD_GLAXNIMATE=OFF
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_GLAXNIMATE_QT6=OFF
		-DMOD_JACKRACK=$(usex jack)
		-DMOD_KDENLIVE=ON
		-DMOD_MOVIT=OFF
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_PLUS=ON
		-DMOD_SDL1=$(usex sdl)
		-DMOD_SOX=$(usex sox)
		-DMOD_QT6=OFF
		-DMOD_QT=OFF
		-DMOD_RESAMPLE=$(usex libsamplerate)
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband)
		-DMOD_SDL2=$(usex sdl)
	# TODO: package libspatialaudio \
		-DMOD_SPATIALAUDIO=OFF
		-DMOD_VIDSTAB=$(usex vidstab)
		-DMOD_XINE=$(usex xine)
		-DMOD_XML=$(usex xml)
	# TODO \
		-DUSE_LV2=OFF
	# TODO \
		-DUSE_VST2=OFF
	)

	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python ; then
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
	# Install SWIG bindings
	docinto "swig"
	if use python ; then
		dodoc "${S}/src/swig/python/play.py"
		python_optimize
	fi
	mv "${ED}/usr/share/man/man1/melt"{"","-flowblade"}"-7.1" || die
	mv "${ED}/usr/share/man/man1/melt"{"","-flowblade"}".1" || die
}

