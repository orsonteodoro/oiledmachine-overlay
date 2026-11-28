# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see https://tracker.debian.org/pkg/zip

MY_PV="${PV//.}"
MY_PV="${MY_PV%_p*}"
MY_P="${PN}${MY_PV}"

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"

inherit cflags-hardened edo toolchain-funcs flag-o-matic secure-version

DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="https://infozip.sourceforge.net/Zip.html"
SRC_URI="
	https://downloads.sourceforge.net/infozip/${MY_P}.zip
	mirror://debian/pool/main/z/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"
S="${WORKDIR}"/${MY_P}

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="bzip2 crypt natspec unicode"

DEPEND="
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	natspec? ( dev-libs/libnatspec:= )
"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

src_prepare() {
	PATCHES=(
		"${WORKDIR}/debian/patches/typo-it-is-transferring-not-transfering.patch"
		"${WORKDIR}/debian/patches/typo-it-is-privileges-not-priviliges.patch"
		"${WORKDIR}/debian/patches/manpages-in-section-1-not-in-section-1l.patch"
		"${WORKDIR}/debian/patches/do-not-set-unwanted-cflags.patch"
		"${WORKDIR}/debian/patches/typo-it-is-preceding-not-preceeding.patch"
		"${WORKDIR}/debian/patches/stack-markings-to-avoid-executable-stack.patch"
		"${WORKDIR}/debian/patches/fclose-in-file-not-fclose-x.patch"
		"${WORKDIR}/debian/patches/hardening-build-fix-1.patch"
		"${WORKDIR}/debian/patches/hardening-build-fix-2.patch"
		"${WORKDIR}/debian/patches/remove-build-date.patch"
		"${WORKDIR}/debian/patches/typo-it-is-ambiguities-not-amgibuities.patch"
		"${WORKDIR}/debian/patches/fix-build-with-gcc-14.patch"
		"${WORKDIR}/debian/patches/typo-it-is-os-2-not-risc-os-2.patch"
		"${WORKDIR}/debian/patches/buffer-overflow-unicode-filename.patch"
		"${WORKDIR}/debian/patches/buffer-overflow-cve-2018-13410.patch"
		"${WORKDIR}/debian/patches/fix-symlink-update-detection.patch"
		"${WORKDIR}/debian/patches/fix-command-injection.patch"

		"${FILESDIR}"/${PN}-3.0-no-crypt.patch # bug #238398
		"${FILESDIR}"/${PN}-3.0-pic.patch
		"${FILESDIR}"/${PN}-3.0_p16-zipnote-freeze.patch # bug #322047
	)

	# bug #275244
	use natspec && PATCHES+=( "${FILESDIR}"/${PN}-3.0-natspec.patch )
	default
}

src_configure() {
	# Needed for tricky configure tests w/ C23 (bug #943727)
	export CC="$(tc-getCC) -std=gnu89"

	cflags-hardened_append

	# Needed for Clang 16
	append-flags -std=gnu89

	append-cppflags \
		-DLARGE_FILE_SUPPORT \
		-DUIDGID_NOT_16BIT \
		-D$(usev !bzip2 'NO')BZIP2_SUPPORT \
		-D$(usev !crypt 'NO')CRYPT \
		-D$(usev !unicode 'NO')UNICODE_SUPPORT

	# - We use 'sh' because: 1. lacks +x bit, easier; 2. it tries to load bashdb
	# - Third arg disables bzip2 logic as we handle it ourselves above.
	edo sh ./unix/configure "$(tc-getCC)" "-I. -DUNIX ${CFLAGS} ${CPPFLAGS}" "${T}"

	if use bzip2 ; then
		sed -i -e "s:LFLAGS2=:&'-lbz2 ':" flags || die
	fi
}

src_compile() {
	emake \
		CPP="$(tc-getCPP)" \
		-f unix/Makefile generic
}

src_install() {
	dobin zip zipnote zipsplit
	doman man/zip{,note,split}.1
	if use crypt ; then
		dobin zipcloak
		doman man/zipcloak.1
	fi
	dodoc BUGS CHANGES README* TODO WHATSNEW WHERE proginfo/*.txt
}
