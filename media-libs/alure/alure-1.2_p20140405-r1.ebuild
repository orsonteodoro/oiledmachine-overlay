# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-compiler-switch cmake-multilib flag-o-matic

EGIT_COMMIT="e9d4fb8a6a3dd367fc4611fcdc48a22d0c7da6a5"
SRC_URI="
https://repo.or.cz/alure.git/snapshot/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT:0:7}"

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="https://kcat.strangesoft.net/alure.html"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="dumb examples flac fluidsynth modplug mp3 sndfile static-libs vorbis"
RDEPEND="
	>=media-libs/openal-1.1[${MULTILIB_USEDEP}]
	dumb? (
		media-libs/dumb[${MULTILIB_USEDEP}]
	)
	flac? (
		media-libs/flac[${MULTILIB_USEDEP}]
	)
	fluidsynth? (
		>=media-sound/fluidsynth-1.1.1:=[${MULTILIB_USEDEP}]
	)
	modplug? (
		media-libs/libmodplug[${MULTILIB_USEDEP}]
	)
	mp3? (
		media-sound/mpg123[${MULTILIB_USEDEP}]
	)
	sndfile? (
		media-libs/libsndfile[${MULTILIB_USEDEP}]
	)
	vorbis? (
		media-libs/libvorbis[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
RESTRICT="mirror"

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e "/DESTINATION/s:doc/alure:doc/${PF}:" \
		"CMakeLists.txt" \
		|| die
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_STATIC=$(usex static-libs)
		-DDUMB=$(usex dumb)
		-DFLAC=$(usex flac)
		-DFLUIDSYNTH=$(usex fluidsynth)
		-DMODPLUG=$(usex modplug)
		-DMPG123=$(usex mp3)
		-DSNDFILE=$(usex sndfile)
		-DVORBIS=$(usex vorbis)
	)
	cmake-multilib_src_configure
}
