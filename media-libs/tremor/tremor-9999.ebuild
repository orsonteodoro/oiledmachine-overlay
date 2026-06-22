# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"

CHKL_TIMESTAMPS=(
	"media-libs/libogg-9999"
)

inherit autotools cflags-hardened chkl multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/tremor.git"
	FALLBACK_COMMIT="820fb3237ea81af44c9cc468c8b4e20128e3e5ad"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="
	"
	die "FIXME"
fi

DESCRIPTION="A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec)"
HOMEPAGE="https://wiki.xiph.org/Tremor"
LICENSE="BSD"
SLOT="0"
IUSE+="
low-accuracy
ebuild_revision_24
"
RDEPEND="
	>=media-libs/libogg-9999:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-9999-820fb32-autoconf.patch"
)

src_prepare() {
	default
	eautoreconf
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

multilib_src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	ECONF_SOURCE="${S}" \
	econf $(use_enable low-accuracy)
}

multilib_src_install_all() {
	HTML_DOCS=( "doc/." )
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
