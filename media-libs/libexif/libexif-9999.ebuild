# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# It can process GPS coords
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO ID IO OOBR UAF UM"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/marcusmeissner.asc
inherit autotools cflags-hardened multilib-minimal verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	SO_CURRENT=15
	SO_AGE=3
	SOVER=$(( ${SO_CURRENT} - ${SO_AGE} ))
	FALLBACK_COMMIT="7915d4f6e7d637b5cac41d7c2332fe3e610e1392"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/libexif/libexif.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SO_CURRENT=15
	SO_AGE=3
	SOVER=$(( ${SO_CURRENT} - ${SO_AGE} ))
	SRC_URI="
https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz
verify-sig? ( https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz.asc )
	"
fi

DESCRIPTION="Library for parsing, editing, and saving EXIF data"
HOMEPAGE="https://libexif.github.io/"

LICENSE="LGPL-2+"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+="
doc nls
ebuild_revision_1
"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-marcusmeissner )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.13-pkgconfig.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	localtime_s # bug #898318
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		verify-sig_src_unpack
	fi
	local c=$(grep -e "LIBEXIF_CURRENT=" "${S}/configure.ac" | cut -f 2 -d "=")
	local a=$(grep -e "LIBEXIF_AGE=" "${S}/configure.ac" | cut -f 2 -d "=")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SO_CURRENT, SO_AGE, SOVER, or PV"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default

	# bug #390249
	sed -i -e '/FLAGS=/s:-g::' configure.ac || die

	# Previously elibtoolize for BSD
	eautoreconf
}

multilib_src_configure() {
	cflags-hardened_append
	local myeconfargs=(
		$(multilib_native_use_enable doc docs)
		$(use_enable nls)
		--with-doc-dir="${EPREFIX}"/usr/share/doc/${PF}
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	rm -f "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING} || die
}
