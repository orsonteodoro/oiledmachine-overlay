# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit cflags-hardened dot-a flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="https://xxhash.com/"
if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="dev"
	EGIT_REPO_URI="https://github.com/Cyan4973/xxHash.git"
	FALLBACK_COMMIT="2ec67caeb18ec15ae60c0853174331089acddfc0"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/xxHash-${PV}
fi

LICENSE="BSD-2 GPL-2+"
SOVER="0"
SLOT="0/${SOVER}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+=" static-libs"

src_prepare() {
	default

	multilib_copy_sources
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		default
	fi
	local actual_sover=$(grep "XXH_VERSION_MAJOR" "${S}/lib/xxh_api.h" | head -n 1 | sed -E -e "s|[ ]+| |g"| cut -f 3 -d " ")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "Bump SOVER"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	cflags-hardened_append
	# Needed for -Og to be buildable, otherwise fails a/ always_inline (bug #961093)
	# https://github.com/Cyan4973/xxHash?tab=readme-ov-file#binary-size-control
	is-flagq '-Og' && append-cppflags -DXXH_NO_INLINE_HINTS
	multilib-minimal_src_configure

	use static-libs && lto-guarantee-fat
}

myemake() {
	# need LIBDIR set during compile too for Darwin, bug #966267
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		MANDIR='$(man1dir)' \
		"${@}"
}

multilib_src_compile() {
	myemake
}

multilib_src_test() {
	# Injecting CPPFLAGS into CFLAGS is needed for test_sanity
	myemake CFLAGS="${CPPFLAGS} ${CFLAGS}" check
}

multilib_src_install() {
	myemake DESTDIR="${D}" install
	einstalldocs

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/libxxhash.a || die
	else
		strip-lto-bytecode
	fi
}
