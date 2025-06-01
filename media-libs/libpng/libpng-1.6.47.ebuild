# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APNG_REPO="libpng-apng" # Sometimes libpng-apng is more up to date.
APNG_PV="1.6.47"
CFLAGS_HARDENED_ASSEMBLERS="gas inline"
##CFLAGS_HARDENED_CI_SANITIZERS="asan lsan msan ubsan" # Beta only
CFLAGS_HARDENED_CI_SANITIZERS="asan lsan" # Before .travis.yml removal
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="13"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DOS HO IO NPD MC OOBR SO UAF UM"

inherit cflags-hardened check-compiler-switch flag-o-matic libtool multilib-minimal

KEYWORDS="
~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc
x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
SRC_URI="
https://downloads.sourceforge.net/${PN}/${P}.tar.xz
	apng? (
https://downloads.sourceforge.net/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_PV}))/${PV}/${PN}-${APNG_PV}-apng.patch.gz
	-> ${PN}-${APNG_PV}-${APNG_REPO}-apng.patch.gz
https://downloads.sourceforge.net/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_PV}))/${PN}-${APNG_PV}-apng.patch.gz
	-> ${PN}-${APNG_PV}-${APNG_REPO}-apng.patch.gz
	)
"

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
LICENSE="libpng2"
SLOT="0/16"
IUSE="
apng cpu_flags_x86_sse static-libs test
ebuild_revision_15
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

DOCS=( "ANNOUNCE" "CHANGES" "libpng-manual.txt" "README" "TODO" )

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	default
	if use apng ; then
		case ${APNG_REPO} in
			apng)
				eapply -p0 "${WORKDIR}/${PN}-${APNG_PV}-${APNG_REPO}-apng.patch"
				;;
			libpng-apng)
				eapply "${WORKDIR}/${PN}-${APNG_PV}-${APNG_REPO}-apng.patch"
				;;
			*)
eerror "Unknown APNG_REPO!"
				die
				;;
		esac

	# Don't execute symbols check with apng patch, bug #378111
		sed -i \
			-e '/^check/s:scripts/symbols.chk::' \
			"Makefile.in" \
			|| die
	fi

	elibtoolize
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	local myeconfargs=(
		$(multilib_native_enable tools)
		$(use_enable test tests)
		$(use_enable cpu_flags_x86_sse intel-sse)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" \( -type f -o -type l \) -name '*.la' -delete || die
}
