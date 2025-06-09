# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="736d55ca94b5e0a4140c9cc3bfe762152b2dffba"
PSDOOM_DATA_PV="2000.05.03"
QUICKCHECK_COMMIT="ef816accb377a5be05c5debf096dd038eee98aa8"

inherit autotools dep-prepare

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="psdoom-ng"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/orsonteodoro/psdoom-ng1.git"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/psdoom-ng1-psdoom-ng-${PV}"
	SRC_URI="
https://github.com/orsonteodoro/psdoom-ng1/archive/refs/tags/psdoom-ng-${PV}.tar.gz
	-> ${PN}-${FALLBACK_COMMIT:0:7}.tar.gz
https://github.com/chocolate-doom/quickcheck/archive/${QUICKCHECK_COMMIT}.tar.gz
	-> chocolate-doom-quickcheck-${QUICKCHECK_COMMIT:0:7}.tar.gz
	"
fi
SRC_URI+="
	psdoom-wads? (
http://downloads.sourceforge.net/project/psdoom/psdoom-data/${PSDOOM_DATA_PV}/psdoom-${PSDOOM_DATA_PV}-data.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpsdoom%2Ffiles%2Fpsdoom-data%2F${PSDOOM_DATA_PV}%2F&ts=1452812220&use_mirror=tcpdiag
	-> psdoom-data-${PSDOOM_DATA_PV}.tar.gz
	)
"

DESCRIPTION="A First Person Shooter (FPS) process killer"
HOMEPAGE="https://github.com/orsonteodoro/psdoom-ng"
LICENSE="GPL-2"
SLOT="0"
IUSE+="
bash-completion cloudfoundry fluidsynth kms libsamplerate png psdoom-wads
sdl2mixer sound X wayland
ebuild_revision_1
"
REQUIRED_USE="
	|| (
		kms
		wayland
		X
	)
"
RDEPEND="
	>=media-libs/libsdl2-2.0.14[kms?,libsamplerate?,sound?,wayland?,X?]
	fluidsynth? (
		>=media-sound/fluidsynth-2.2.0
	)
	libsamplerate? (
		>=media-libs/libsamplerate-0.1.8
	)
	sdl2mixer? (
		>=media-libs/sdl2-mixer-2.0.2
	)
	wayland? (
		gnome-extra/zenity
		gui-libs/gtk[gles2,video,wayland]
	)
	X? (
		gnome-extra/zenity
		gui-libs/gtk[video,X]
	)
"
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack "${PN}-${FALLBACK_COMMIT:0:7}.tar.gz"
	fi
	cd "${WORKDIR}" || die
	unpack "chocolate-doom-quickcheck-${QUICKCHECK_COMMIT:0:7}.tar.gz"
	if use psdoom-wads ; then
		unpack "psdoom-data-${PSDOOM_DATA_PV}.tar.gz"
	fi
	dep_prepare_mv "${WORKDIR}/quickcheck-${QUICKCHECK_COMMIT}" "${S}/quickcheck"
}

src_prepare() {
	default
	eautoreconf || die
}

src_configure(){
	local myconf=(
		$(use_enable bash-completion)
		$(use_enable cloudfoundry)
		$(use_enable sdl2mixer)
		$(use_with fluidsynth)
		$(use_with libsamplerate)
		$(use_with png libpng)
		--disable-all-games

	# For security reasons.  It is possible to use psdoom-ng for any reason
	# but most use cases it is for killing pid.
		--disable-sdl2net
	)
	econf ${myconf[@]} || die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install
	insinto "/usr/share/psdoom-ng"
	if use psdoom-wads ; then
		doins "${WORKDIR}/psdoom-data/psdoom1.wad" || die
		doins "${WORKDIR}/psdoom-data/psdoom2.wad" || die
		newins "${WORKDIR}/psdoom-data/README" "README.wad" || die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
