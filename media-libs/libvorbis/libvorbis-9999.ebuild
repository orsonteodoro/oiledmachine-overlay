# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS IO OOBR"

CHKL_TIMESTAMPS=(
	"media-libs/libogg-9999"
)

inherit autotools cflags-hardened chkl multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="e3c9861ff096d52378e131ff8c334552e09cdffa"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/vorbis.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://downloads.xiph.org/releases/vorbis/${P}.tar.xz"
fi

DESCRIPTION="The Ogg Vorbis sound file format library"
HOMEPAGE="https://xiph.org/vorbis/"

LICENSE="BSD"
SLOT="0"
IUSE+="
static-libs test
ebuild_revision_9
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=media-libs/libogg-9999:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
#	"${FILESDIR}"/${PN}-1.3.7-mismatched-free.patch
#	"${FILESDIR}"/${PN}-1.3.7-macro-wstrict-prototypes.patch
#	"${FILESDIR}"/${PN}-1.3.7-ubsan-shift.patch
#	"${FILESDIR}"/${PN}-1.3.7-psy-bounds.patch
)

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

src_prepare() {
	default

	sed -i \
		-e '/CFLAGS/s:-O20::' \
		-e '/CFLAGS/s:-mcpu=750::' \
		-e '/CFLAGS/s:-mno-ieee-fp::' \
		configure.ac || die

	# Un-hack docdir redefinition.
	find -name 'Makefile.am' \
		-exec sed -i \
			-e 's:$(datadir)/doc/$(PACKAGE)-$(VERSION):@docdir@/html:' \
			{} + || die

	eautoreconf
}

multilib_src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	local myconf=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable test oggtest)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
}
