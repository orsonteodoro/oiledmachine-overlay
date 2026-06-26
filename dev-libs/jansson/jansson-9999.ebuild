# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH DOS OOBR"

inherit autotools cflags-hardened

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="a83a3476cdad203f6069a77adc7adf7acacb0236"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/akheron/jansson.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/akheron/jansson/releases/download/v${PV}/${P}.tar.bz2"
fi

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="https://www.digip.org/jansson/"

LICENSE="MIT"
SOVER="4"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="doc static-libs"

BDEPEND="
	dev-build/autoconf-archive
	doc? ( dev-python/sphinx )
"

PATCHES=(
	"${FILESDIR}"/jansson-2.14.1-default-symver-test.patch
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

	local actual_sover=$(grep -F -r -e "set(JANSSON_SOVERSION" "${S}/CMakeLists.txt" | cut -f 2 -d " " | sed -e "s|)||g")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER"
eerror "QA:  Actual sover:  ${actual_sover}"
eerror "QA:  Expected sover:  ${expected_sover}"
		die
	fi
}

src_configure() {
	cflags-hardened_append
	econf $(use_enable static-libs static)
}

src_compile() {
	default

	if use doc ; then
		emake html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
