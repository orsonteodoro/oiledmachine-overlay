# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data sensitive-data system-set"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AFW BO OOBR TOCTOU"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gzip.asc
inherit cflags-hardened eapi9-ver flag-o-matic verify-sig

DESCRIPTION="Standard GNU compressor"
HOMEPAGE="https://www.gnu.org/software/gzip/"

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="3a74eb1c4b6ec09e03461a9a2063da9d8f0c1f98"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://https.git.savannah.gnu.org/git/gzip.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
		mirror://gnu/gzip/${P}.tar.xz
		verify-sig? (
			mirror://gnu/gzip/${P}.tar.xz.sig
		)
	"
fi

LICENSE="GPL-3+"
SLOT="0"
if [[ ${PV} != *_p* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE+=" doc pic static"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gzip )"
RDEPEND="!app-arch/pigz[symlink(-)]"
PDEPEND="
	app-alternatives/gzip
"

PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
	# TODO add verify-sig
		unpack ${A}
	fi
}

src_prepare() {
	default
	./bootstrap || die
	eapply "${FILESDIR}/${PN}-1.3.8-install-symlinks.patch"
}

src_configure() {
	cflags-hardened_append
	use static && append-flags -static

	# Avoid text relocation in gzip
	use pic && export DEFS="NO_ASM"

	# embeds the path to grep detected at build time into installed scripts;
	# use the canonical USE="split-usr" agnostic path. bug #935721
	export GREP="${EPREFIX}/bin/grep"

	# bug #663928
	econf --disable-gcc-warnings
}

src_install() {
	default

	if use doc ; then
		docinto txt
		dodoc algorithm.doc

		docinto texi
		dodoc doc/gzip.texi

		doinfo doc/gzip.info
	fi

	# Avoid conflict with app-arch/ncompress
	rm "${ED}"/usr/bin/uncompress || die

	# keep most things in /usr, just the fun stuff in /
	# also rename them to avoid conflict with app-alternatives/gzip
	dodir /bin
	local x
	for x in gunzip gzip zcat; do
		mv "${ED}/usr/bin/${x}" "${ED}/bin/${x}-reference" || die
	done
	mv "${ED}"/usr/share/man/man1/gzip{,-reference}.1 || die
	rm "${ED}"/usr/share/man/man1/{gunzip,zcat}.1 || die
}

pkg_postinst() {
	if ver_replacing -lt "1.12-r2"; then
		ewarn "This package no longer installs 'uncompress'."
		ewarn "Please use 'gzip -d' to decompress .Z files."
	fi

	# ensure to preserve the symlinks before app-alternatives/gzip
	# is installed
	local x
	for x in gunzip gzip zcat; do
		if [[ ! -h ${EROOT}/bin/${x} ]]; then
			ln -s "${x}-reference" "${EROOT}/bin/${x}" || die
		fi
	done
}
