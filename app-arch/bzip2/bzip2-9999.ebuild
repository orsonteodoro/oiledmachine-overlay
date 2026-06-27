# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There are three versions
# 1.0.8 - classic stable - sourceware.org - distro unpatched - oiledmachine-overlay live patched
# 1.1.0 - experimental c - vulnerable - gitlab - vulnerable - CVE-2026-42250 - OOBR, MC, DoS
# rustify - rust port - gitlab - unreviewed
# Usually the stable is audited not the development branch in general.

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE CRSH DOS IO MC OOBW UAF"

if [[ "${PV}" =~ "9999" ]] ; then
	MY_PV="1.0.8"
else
	MY_PV="${PV}"
fi

inherit cflags-hardened check-compiler-switch multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	FALLBACK_COMMIT="f153ef257a8e8901d8f8ed96fd1a2467806e8755"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://sourceware.org/git/bzip2"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos"
	SRC_URI="https://sourceware.org/pub/${PN}/${P}.tar.gz"
fi

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://gitlab.com/bzip2/bzip2"
LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME

IUSE+="
static static-libs
ebuild_revision_3
"
PDEPEND="
	app-alternatives/bzip2
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.0.4-makefile-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.0.8-saneso.patch
	"${FILESDIR}"/${PN}-1.0.4-man-links.patch #172986
	"${FILESDIR}"/${PN}-1.0.6-progress.patch
	"${FILESDIR}"/${PN}-1.0.3-no-test.patch
	"${FILESDIR}"/${PN}-1.0.8-mingw.patch #393573
	"${FILESDIR}"/${PN}-1.0.8-out-of-tree-build.patch
)

pkg_setup() {
einfo "This is the classic stable 1.0.x for ${PN}.  Security reviewed version."
	check-compiler-switch_start
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
	multilib_copy_sources
}

src_prepare() {
	default

	# - Use right man path
	# - Generate symlinks instead of hardlinks
	# - pass custom variables to control libdir
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s -f :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		Makefile || die
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
}

bemake() {
	emake \
		VPATH="${S}" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		"$@"
}

multilib_src_compile() {
	bemake -f "${S}"/Makefile-libbz2_so all
	# Make sure we link against the shared lib #504648
	ln -s libbz2.so.${PV} libbz2.so || die
	bemake -f "${S}"/Makefile all LDFLAGS="${LDFLAGS} $(usex static -static '')"
}

multilib_src_test() {
	cp "${S}"/sample* "${BUILD_DIR}" || die
	bemake -f "${S}"/Makefile check
}

multilib_src_install() {
	into /usr

	local pv="${MY_PV}"

	# Install the shared lib manually.  We install:
	#  .x.x.x - standard shared lib behavior
	#  .x.x   - SONAME some distros use #338321
	#  .x     - SONAME Gentoo uses
	dolib.so libbz2.so.${pv}
	local v
	for v in libbz2.so{,.{${pv%%.*},${pv%.*}}} ; do
		dosym libbz2.so.${pv} /usr/$(get_libdir)/${v}
	done

	use static-libs && dolib.a libbz2.a

	if multilib_is_native_abi ; then
		dobin bzip2recover$(get_exeext)
		into /
		newbin bzip2$(get_exeext) bzip2-reference$(get_exeext)
	fi
}

multilib_src_install_all() {
	# `make install` doesn't cope with out-of-tree builds, nor with
	# installing just non-binaries, so handle things ourselves.
	insinto /usr/include
	doins bzlib.h
	into /usr
	dobin bz{diff,grep,more}
	doman bz{diff,grep,more}.1
	newman bzip2.1 bzip2-reference.1

	dosym bzdiff /usr/bin/bzcmp
	dosym bzdiff.1 /usr/share/man/man1/bzcmp.1

	dosym bzmore /usr/bin/bzless
	dosym bzmore.1 /usr/share/man/man1/bzless.1

	dosym bzip2-reference.1 /usr/share/man/man1/bzip2recover.1
	local x
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
		dosym bzgrep.1 /usr/share/man/man1/${x}.1
	done

	einstalldocs
}

pkg_postinst() {
	# ensure to preserve the symlinks before app-alternatives/bzip2
	# is installed
	local x
	for x in bzip2 bunzip2 bzcat; do
		if [[ ! -h ${EROOT}/bin/${x} ]]; then
			ln -s bzip2-reference$(get_exeext) "${EROOT}/bin/${x}$(get_exeext)" || die
		fi
	done
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive/integration-test) 9515e7f live
# Double emerge:  passed
# Compress/decompress with sha512sum comparison:  passed
