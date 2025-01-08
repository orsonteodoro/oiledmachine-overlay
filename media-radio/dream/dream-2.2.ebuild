# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATENT_STATUS_IUSE=(
	patent_status_nonfree
)
QT_PV="5"

inherit flag-o-matic qmake-utils toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="mirror://sourceforge/drm/${PN}_${PV}.orig.tar.gz"

DESCRIPTION="A software radio for AM and Digital Radio Mondiale (DRM)"
HOMEPAGE="https://sourceforge.net/projects/drm/"
LICENSE="GPL-2+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${PATENT_STATUS_IUSE[@]}
alsa -faad -faac -fdk gps gui hamlib jack +opus portaudio pulseaudio qt${QT_PV}
qtmultimedia sound sndfile speexdsp webengine
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!faac
		!faad
		!fdk
	)
	faac? (
		patent_status_nonfree
	)
	faad? (
		patent_status_nonfree
	)
	fdk? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	gui? (
		qt${QT_PV}
	)
	qtmultimedia? (
		qt${QT_PV}
	)
	sound? (
		|| (
			pulseaudio
			portaudio
		)
	)
"
RDEPEND+="
	net-libs/libpcap
	sci-libs/fftw
	sys-libs/zlib
	virtual/patent-status[patent_status_nonfree=]
	alsa? (
		media-libs/alsa-lib
	)
	faac? (
		media-libs/faac
	)
	faad? (
		media-libs/faad2
	)
	fdk? (
		media-libs/fdk-aac
	)
	gps? (
		sci-geosciences/gpsd
	)
	gui? (
		dev-qt/qtconcurrent:${QT_PV}
		dev-qt/qtnetwork:${QT_PV}
		dev-qt/qtsvg:${QT_PV}
		dev-qt/qtwidgets:${QT_PV}
		x11-libs/qwt:${QT_PV}
	)
	hamlib? (
		media-libs/hamlib
	)
	jack? (
		virtual/jack
	)
	opus? (
		media-libs/opus
	)
	portaudio? (
		media-libs/portaudio
	)
	pulseaudio? (
		media-sound/pulseaudio
	)
	qt5? (
		dev-qt/qtcore:${QT_PV}
		dev-qt/qtxml:${QT_PV}
	)
	qtmultimedia? (
		dev-qt/qtmultimedia
	)
	sndfile? (
		media-libs/libsndfile
	)
	speexdsp? (
		media-libs/speex
		media-libs/speexdsp
	)
	webengine? (
		dev-qt/qtwebengine:${QT_PV}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	sys-devel/gcc
	dev-build/make
"
DOCS=(
	AUTHORS
	ChangeLog
	COPYING
	NEWS
	README
)
PATCHES=(
	"${FILESDIR}/dream-2.2-compat-with-gspd-3.23.1.patch"
)

src_configure() {
	local myqmakeargs=()
	use faac && append-cppflags -DUSE_FAAC_LIBRARY
	use faad && append-cppflags -DUSE_FAAD2_LIBRARY
	use jack && append-cppflags -DUSE_JACK
	use qtmultimedia && append-cppflags -DQT_MULTIMEDIA_LIB
	tc-is-cross-compiler && myqmakeargs+=(
		CONFIG+=cross_compile
	)
	if use portaudio || use pulseaudio || use qtmultimedia ; then
		myqmakeargs+=(
			CONFIG+=sound
		)
	fi
	myqmakeargs+=(
		$(usex alsa CONFIG+=alsa '')
		$(usex fdk CONFIG+=fdk-sdk '')
		$(usex gps CONFIG+=gps '')
		$(usex hamlib CONFIG+=hamlib '')
		$(usex opus CONFIG+=opus '')
		$(usex portaudio CONFIG+=portaudio '')
		$(usex pulseaudio CONFIG+=pulseaudio '')
		$(usex qtmultimedia QT+=multimedia '')
		$(usex sndfile CONFIG+=sndfile '')
		$(usex speexdsp CONFIG+=speexdsp '')
		$(usex webengine QT+=webenginewidgets '')
	)
	if ! use qt${QT_PV} && ! use gui ; then
		myqmakeargs+=(
			CONFIG+=console
		)
	elif use qt${QT_PV} && ! use gui ; then
		myqmakeargs+=(
			CONFIG+=qtconsole
		)
	elif use qt${QT_PV} && use gui ; then
		myqmakeargs+=(
			QT+=gui
		)
	elif ! use qt${QT_PV} && use gui ; then
		die "gui requires qt${QT_PV}"
	fi
	einfo "Running:  eqmake${QT_PV} ${PN}.pro ${myqmakeargs[@]}"
	eqmake${QT_PV} ${PN}.pro "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
