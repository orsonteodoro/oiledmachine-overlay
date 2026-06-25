# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild uses AI inference for clarification/transparency.

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data sensitive-data system-set"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DR NPD"

inherit cflags-hardened dot-a multilib-minimal preserve-libs

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"

if [[ ${PV} == 9999 ]] ; then
	FALLBACK_COMMIT="c93f9428d17cde4eb35517b58feeae6fb43aba5b"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/libffi/libffi"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit autotools git-r3
else
	inherit libtool
	SRC_URI="https://github.com/libffi/libffi/releases/download/v${MY_PV}/${MY_P}.tar.gz"

	if [[ ${PV} != *@(alpha|beta|pre|rc)* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
	fi
fi

S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
# This is a core package which is depended on by e.g. Python.
# Please use preserve-libs.eclass in pkg_{pre,post}inst to cover users
# with FEATURES="-preserved-libs" or another package manager if SONAME changes.
SOVER="8" # SOVER = CURRENT - AGE, C:R:A in https://github.com/libffi/libffi/blob/master/libtool-version
SLOT="0/${SOVER}" # SONAME=libffi.so.8
IUSE+="
debug +exec-static-trampoline pax-kernel static-libs test
ebuild_revision_1
"

RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-util/dejagnu )"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local c=$(grep -o -E "[0-9]+:[0-9]+:[0-9]+" "${S}/libtool-version" | tail -n 1 | cut -f 1 -d ":")
	local a=$(grep -o -E "[0-9]+:[0-9]+:[0-9]+" "${S}/libtool-version" | tail -n 1 | cut -f 3 -d ":")
	local sover_actual=$(( ${c} - ${a} ))
	local sover_expected=${SLOT#*/}
	if ver_test "${sover_actual}" -ne "${sover_expected}" ; then
eerror "QA:  Update the subslot:"
eerror "sover_actual:  ${sover_actual}"
eerror "sover_expected:  ${sover_expected}"
		die
	fi
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		elibtoolize
	fi

	if [[ ${CHOST} == arm64-*-darwin* ]] ; then
		# ensure we use aarch64 asm, not x86 on arm64
		sed -i -e 's/aarch64\*-\*-\*/arm64*-*-*|&/' \
			configure configure.host || die
	fi
}

src_configure() {
	if use exec-static-trampoline ; then
einfo "exec-static-trampoline:  ON"
einfo "W^X protection:  ON"
einfo "Scripting/bindings compatibility:  OFF"
einfo "Estimated CVSS score:  0.0"
		if has_version "dev-libs/gobject-introspection" ; then
ewarn "Using exec-static-trampoline with dev-libs/gobject-introspection may be degraded."
		fi
		if has_version "gnome-extra/cjs" ; then
ewarn "Using exec-static-trampoline with gnome-extra/cjs may be degraded."
		fi
	else
einfo "exec-static-trampoline:  OFF"
einfo "W^X protection:  OFF"
einfo "Scripting/bindings compatibility:  ON"
einfo "Estimated CVSS score:  8.4"
	fi
	cflags-hardened_append
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	# --includedir= path maintains a few properties:
	# 1. have stable name across libffi versions: some packages like
	#    dev-lang/ghc or kde-frameworks/networkmanager-qt embed
	#    ${includedir} at build-time. Don't require those to be
	#    rebuilt unless SONAME changes. bug #695788
	#
	#    We use /usr/.../${PN} (instead of former /usr/.../${P}).
	#
	# 2. have ${ABI}-specific location as ffi.h is target-dependent.
	#
	#    We use /usr/$(get_libdir)/... to have ABI identifier.
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}"/usr/$(get_libdir)/${PN}/include \
		--disable-multi-os-directory \
		--with-pic \
		$(use_enable static-libs static) \
		$(use_enable exec-static-trampoline exec-static-tramp) \
		$(use_enable pax-kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_test() {
	emake -Onone check
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
	strip-lto-bytecode
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libffi.so.${SOVER}
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libffi.so.${SOVER}
}
