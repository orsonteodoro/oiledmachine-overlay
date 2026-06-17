# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE CRSH DOS IO MC OOBW UAF"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/bzip2.gpg"

inherit cflags-hardened check-compiler-switch meson-multilib

if [[ ${PV} == 9999 ]] ; then
	FALLBACK_COMMIT="9515e7ff78facd349ba3d86a637be71acaccc02e"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.com/bzip2/bzip2"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
fi

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://gitlab.com/bzip2/bzip2"
LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME

IUSE+=" static-libs"

PDEPEND="
	app-alternatives/bzip2
"

pkg_setup() {
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
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		# Requires whole tex stack
		-Ddocs="disabled"
	)

	meson_src_configure
}

multilib_src_install_all() {
	dodir /bin
	mv "${ED}"/usr/bin/bzip2 "${ED}"/bin/bzip2-reference || die
	mv "${ED}"/usr/share/man/man1/bzip2{,-reference}.1 || die

	# moved to app-alternatives/bzip2
	rm "${ED}"/usr/bin/{bzcat,bunzip2} || die
	rm "${ED}"/usr/share/man/man1/{bzcat,bunzip2.1} || die

	dosym bzdiff /usr/bin/bzcmp
	dosym bzmore /usr/bin/bzless
	local x
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
	done

	dosym bzip2-reference.1 /usr/share/man/man1/bzip2recover.1

	einstalldocs
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive/integration-test) 9515e7f live
# Double emerge:  passed
