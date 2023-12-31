# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="https://kcat.strangesoft.net/alure.html"
LICENSE="MIT"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="dumb examples flac fluidsynth mp3 modplug sndfile static-libs vorbis"
inherit cmake-multilib
RDEPEND="
	>=media-libs/openal-1.1[${MULTILIB_USEDEP}]
	dumb? ( media-libs/dumb[${MULTILIB_USEDEP}] )
	flac? ( media-libs/flac[${MULTILIB_USEDEP}] )
	fluidsynth? ( >=media-sound/fluidsynth-1.1.1:=[${MULTILIB_USEDEP}] )
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	modplug? ( media-libs/libmodplug[${MULTILIB_USEDEP}] )
	sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
	vorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
EGIT_COMMIT="e9d4fb8a6a3dd367fc4611fcdc48a22d0c7da6a5"
SRC_URI=\
"https://repo.or.cz/alure.git/snapshot/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT:0:7}"
RESTRICT="mirror"

src_prepare() {
	cmake_src_prepare
	sed -i -e "/DESTINATION/s:doc/alure:doc/${PF}:" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DMODPLUG=$(usex modplug)
		-DDUMB=$(usex dumb)
		-DBUILD_EXAMPLES=$(usex examples)
		-DFLAC=$(usex flac)
		-DFLUIDSYNTH=$(usex fluidsynth)
		-DMPG123=$(usex mp3)
		-DSNDFILE=$(usex sndfile)
		-DBUILD_STATIC=$(usex static-libs)
		-DVORBIS=$(usex vorbis)
	)
	cmake-multilib_src_configure
}
