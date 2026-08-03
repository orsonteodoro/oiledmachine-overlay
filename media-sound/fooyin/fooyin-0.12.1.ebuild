# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild used AI inference to clarify USE flags purpose.

# D12, D13, F42, F43, F44, U24, U25, U26

CFLAGS_HARDENED_USE_CASES="modular-app network plugin untrusted-data"
CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

PLUGINS=(
	"+alsa"
	"+discord"
	"+equaliser"
	"+fileops"
	"+filters"
	"+gme"
	"+libarchive"
	"+lyrics"
	"mediacontrol"
	"+mpris"
	"+notify"
	"nowplaying"
	"+oscilloscope"
	"+openmpt"
	"+pipewire"
	"+pulseaudio"
	"+quicktagger"
	"+projectm"
	"+rawaudio"
	"+radiobrowser"
	"+rgscanner"
	"+scrobbler"
	"+sdl"
	"+sleepinhibitor"
	"+sndfile"
	"+spectrogram"
	"+spectrum"
	"+soundtouch"
	"+soxresampler"
	"+tageditor"
	"thumbnailtoolbar"
	"+vumeter"
	"+wavebar"
)

FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_8[@]}"
	"${FFMPEG_COMPAT_SLOTS_7[@]}"
	"${FFMPEG_COMPAT_SLOTS_6[@]}"
	"${FFMPEG_COMPAT_SLOTS_5[@]}"
)

CHKL_TIMESTAMPS=(
	"app-arch/libarchive-9999"
	"dev-libs/icu-79.0.9999"
	"dev-libs/qcoro-9999"
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtsvg-6.9999"
	"media-libs/libsdl2-9999"
	"media-libs/alsa-lib-9999"
	"media-libs/libsndfile-9999"
	"media-video/pipewire-9999"
)

inherit cflags-hardened cmake ffmpeg libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	#FALLBACK_COMMIT="FIXME"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rec/tdir.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/fooyin/fooyin/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A customisable music player"
HOMEPAGE="
	https://fooyin.org/
"
LICENSE="
	GPL-3
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
${PLUGINS[@]/+}
nls test wayland X
"
REQUIRED_USE="
	|| (
		alsa
		pipewire
		pulseaudio
		sdl
	)
	|| (
		wayland
		X
	)
"
RDEPEND+="
	$(secure-version_gen_ffmpeg_depends '5.1-8.1')
	>=dev-libs/icu-${ICU_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-qt/qtbase-${QTBASE6_PV}:6=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},concurrent,gui,network,sql,widgets,wayland?,X?]
	>=dev-qt/qtsvg-${QTBASE6_PV}:6=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=media-libs/taglib-${TAGLIB_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	dev-libs/kdsingleapplication:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-libs/qcoro-${QCORO_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	alsa? (
		>=media-libs/alsa-lib-${ALSA_LIB_PV}:=
	)
	gme? (
		>=media-libs/game-music-emu-${GAME_MUSIC_EMU_PV}:=
	)
	libarchive? (
		>=app-arch/libarchive-${LIBARCHIVE_PV}:=
	)
	projectm? (
		>=media-libs/libprojectm-4:=
	)
	nls? (
		>=dev-qt/qtbase-${QTBASE6_PV}:6=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},linguist]
	)
	openmpt? (
		media-libs/libopenmpt:=
	)
	pipewire? (
		>=media-video/pipewire-${PIPEWIRE_PV}:=
	)
	rgscanner? (
		>=media-libs/libebur128-1.2.4:=
	)
	sdl? (
		>=media-libs/libsdl2-${LIBSDL2_PV}:=
	)
	sndfile? (
		>=media-libs/libsndfile-${LIBSNDFILE_PV}:=
	)
	soundtouch? (
		media-libs/libsoundtouch:=
	)
	soxresampler? (
		media-libs/soxr:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.18
	virtual/pkgconfig
	test? (
		dev-cpp/gtest[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	ffmpeg_src_configure
	local mycmakeargs=(
		-DBUILD_ALSA=$(usex alsa)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_TRANSLATIONS=$(usex nls)
		-DBUILD_PLUGINS=ON
	)

	local list=""
	local x
	for x in "${PLUGINS[@]/+}" ; do
		if use "${x}" ; then
			list+=";${x}"
		fi
	done
	mycmakeargs+=(
		-DPLUGIN_SELECTION="${list:1}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "COPYING"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
