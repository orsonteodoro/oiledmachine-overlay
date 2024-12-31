# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/tremor.git"
	FALLBACK_COMMIT="9b78f57f4335f7158dbb82df00645d2ba57e0d33"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	SRC_URI="
	"
	die "FIXME"
fi

DESCRIPTION="A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec)"
HOMEPAGE="https://wiki.xiph.org/Tremor"
LICENSE="BSD"
SLOT="0"
IUSE+=" low-accuracy"
RDEPEND="
	>=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-9999-9b78f57-autoconf.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf $(use_enable low-accuracy)
}

multilib_src_install_all() {
	HTML_DOCS=( "doc/." )
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
