# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, see https://tracker.debian.org/pkg/unzip

MY_PV="${PV//.}"
MY_PV="${MY_PV%_p*}"
MY_P="${PN}${MY_PV}"

# Add retpoline for passwords
CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE HO"

inherit cflags-hardened flag-o-matic multilib secure-version toolchain-funcs

DESCRIPTION="unzipper for pkzip-compressed files"
HOMEPAGE="https://infozip.sourceforge.net/UnZip.html"
SRC_URI="
	https://downloads.sourceforge.net/infozip/${MY_P}.tar.gz
	mirror://debian/pool/main/u/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"
S="${WORKDIR}/${MY_P}"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="bzip2 natspec unicode"

DEPEND="
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	natspec? ( dev-libs/libnatspec:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
# RTFseries
"${WORKDIR}/debian/patches/manpages-in-section-1-not-in-section-1l.patch"
"${WORKDIR}/debian/patches/this-is-debian-unzip.patch"
"${WORKDIR}/debian/patches/include-unistd-for-kfreebsd.patch"
"${WORKDIR}/debian/patches/handle-pkware-verification-bit.patch"
"${WORKDIR}/debian/patches/fix-uid-gid-handling.patch"
"${WORKDIR}/debian/patches/initialize-the-symlink-flag.patch"
"${WORKDIR}/debian/patches/increase-size-of-cfactorstr.patch"
"${WORKDIR}/debian/patches/allow-greater-hostver-values.patch"
"${WORKDIR}/debian/patches/cve-2014-8139-crc-overflow.patch"
"${WORKDIR}/debian/patches/cve-2014-8140-test-compr-eb.patch"
"${WORKDIR}/debian/patches/cve-2014-8141-getzip64data.patch"
"${WORKDIR}/debian/patches/cve-2014-9636-test-compr-eb.patch"
"${WORKDIR}/debian/patches/remove-build-date.patch"
"${WORKDIR}/debian/patches/cve-2015-7696.patch"
"${WORKDIR}/debian/patches/cve-2015-7697.patch"
"${WORKDIR}/debian/patches/fix-integer-underflow-csiz-decrypted.patch"
"${WORKDIR}/debian/patches/restore-unix-timestamps-accurately.patch"
"${WORKDIR}/debian/patches/cve-2014-9913-unzip-buffer-overflow.patch"
"${WORKDIR}/debian/patches/cve-2016-9844-zipinfo-buffer-overflow.patch"
"${WORKDIR}/debian/patches/cve-2018-1000035-unzip-buffer-overflow.patch"
"${WORKDIR}/debian/patches/fix-warning-messages-on-big-files.patch"
"${WORKDIR}/debian/patches/cve-2019-13232-fix-bug-in-undefer-input.patch"
"${WORKDIR}/debian/patches/cve-2019-13232-zip-bomb-with-overlapped-entries.patch"
"${WORKDIR}/debian/patches/cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch"
"${WORKDIR}/debian/patches/cve-2019-13232-fix-bug-in-uzbunzip2.patch"
"${WORKDIR}/debian/patches/cve-2019-13232-fix-bug-in-uzinflate.patch"
"${WORKDIR}/debian/patches/zipgrep-avoid-test-errors.patch"
"${WORKDIR}/debian/patches/cve-2022-0529-and-cve-2022-0530.patch"
"${WORKDIR}/debian/patches/handle-windows-zip64-files.patch"
"${WORKDIR}/debian/patches/drop-conflicting-declarations.patch"
"${WORKDIR}/debian/patches/fix-zipgrep.patch"
"${WORKDIR}/debian/patches/can-2026-2034440.patch"
"${WORKDIR}/debian/patches/can-2026-2034443.patch"
"${WORKDIR}/debian/patches/can-2026-2034442.patch"
"${WORKDIR}/debian/patches/print-newline-on-interrupt.patch"
"${WORKDIR}/debian/patches/harden-parsing-of-up-extra-field.patch"

	"${FILESDIR}"/${PN}-6.0-no-exec-stack.patch
	"${FILESDIR}"/${PN}-6.0-format-security.patch
	"${FILESDIR}"/${PN}-6.0-fix-false-overlap-detection-on-32bit-systems.patch
	"${FILESDIR}"/${PN}-6.0-c99-configure.patch

	# oiledmachine-overlay:  Fix issues with -fstrict-flex-arrays=3
	# Verify with unpacking app-arch/zip
	#"${FILESDIR}/extra-patches/${PN}-6.0_p29-remove-struct-hack.patch" # Broken

	"${FILESDIR}/extra-patches/${PN}-6.0_p29-strcpy-fix.patch"

	# oiledmachine-overlay patches
	"${FILESDIR}/extra-patches/${PN}-6.0_p29-uaf-warning.patch"
	"${FILESDIR}/extra-patches/${PN}-6.0_p29-format-overflow-warning.patch"
	"${FILESDIR}/extra-patches/${PN}-6.0_p29-maybe-uninitialized.patch"
)

src_prepare() {
	# bug #275244
	use natspec && PATCHES+=( "${FILESDIR}"/${PN}-6.0-natspec.patch )

#	rm "${WORKDIR}"/debian/patches/02-this-is-debian-unzip.patch || die

	default

	sed -i \
		-e 's:LFLAGS2="-s":LFLAGS2=:' \
		unix/configure || die
	sed -i -r \
		-e '/^CFLAGS/d' \
		-e '/CFLAGS/s:-O[0-9]?:$(CFLAGS) $(CPPFLAGS):' \
		-e '/^STRIP/s:=.*:=true:' \
		-e "s:\<CC *= *\"?g?cc2?\"?\>:CC=\"$(tc-getCC)\":" \
		-e "s:\<LD *= *\"?(g?cc2?|ld)\"?\>:LD=\"$(tc-getCC)\":" \
		-e "s:\<AS *= *\"?(g?cc2?|as)\"?\>:AS=\"$(tc-getCC)\":" \
		-e 's:LF2 = -s:LF2 = :' \
		-e 's:LF = :LF = $(LDFLAGS) :' \
		-e 's:SL = :SL = $(LDFLAGS) :' \
		-e 's:FL = :FL = $(LDFLAGS) :' \
		-e "/^#L_BZ2/s:^$(use bzip2 && echo .)::" \
		-e 's:$(AS) :$(AS) $(ASFLAGS) :g' \
		unix/Makefile \
		|| die "sed unix/Makefile failed"

	# Delete bundled code to make sure we don't use it.
	rm -r bzip2 || die
}

src_configure() {
	cflags-hardened_append

	case ${CHOST} in
		i?86*-*linux*)       TARGET="linux_asm" ;;
		*linux*)             TARGET="linux_noasm" ;;
		*-darwin*)           TARGET="macosx" ;;
		*-solaris*)          TARGET="linux_noasm" ;;
		*-gnu)               TARGET="generic" ;;
		# generic may work but there may be a better-suited target
		# so we should get people to check.
		*) die "Unknown target; please update the ebuild to handle ${CHOST}" ;;
	esac

	[[ ${CHOST} == *linux* ]] && append-cppflags -DNO_LCHMOD
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DNO_LCHMOD -DBSD4_4
	use bzip2 && append-cppflags -DUSE_BZIP2
	use unicode && append-cppflags -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DUSE_ICONV_MAPPING

	# bug #281473
	append-cppflags -DLARGE_FILE_SUPPORT
}

src_compile() {
	ASFLAGS="${ASFLAGS} $(get_abi_CFLAGS)" emake -f unix/Makefile ${TARGET}
}

src_install() {
	dobin unzip funzip unzipsfx unix/zipgrep
	dosym unzip /usr/bin/zipinfo
	doman man/*.1
	dodoc BUGS History* README ToDo WHERE
}
