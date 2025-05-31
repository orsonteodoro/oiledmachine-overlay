# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_SANITIZERS_COMPAT="gcc"
CFLAGS_HARDENED_TOLERANCE="4.00"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO SO"
# CVE-2015-8863 - network zero click attack, heap-based overflow (ASAN), off-by-one (UBSAN)

inherit autotools cflags-hardened check-compiler-switch flag-o-matic

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"
ONIGURUMA_PV="6.9.3" # Keep this in sync with bundled modules/oniguruma/

KEYWORDS="
~alpha amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux
~arm64-macos ~x64-macos ~x64-solaris
"
S="${WORKDIR}/${PN}-${MY_P}"
SRC_URI="
https://github.com/jqlang/jq/archive/refs/tags/${MY_P}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.io/jq/"
LICENSE="MIT CC-BY-3.0"
SLOT="0"
IUSE="
+oniguruma static-libs test
ebuild_revision_31
"
DEPEND="
	>=sys-devel/bison-3.0
	app-alternatives/lex
	oniguruma? (
		>=dev-libs/oniguruma-${ONIGURUMA_PV}:=[static-libs?]
	)
"
RDEPEND="
	!static-libs? (
		oniguruma? (
			>=dev-libs/oniguruma-${ONIGURUMA_PV}[static-libs?]
		)
	)
"
PATCHES=(
	"${FILESDIR}/jq-1.6-r3-never-bundle-oniguruma.patch"
	"${FILESDIR}/jq-1.7.1-runpath.patch"
)

#RESTRICT="
#	!test? (
#		test
#	)
#"
REQUIRED_USE="
	test? (
		oniguruma
	)
"

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	sed -i \
		-e '/^dist_doc_DATA/d; s:-Wextra ::' \
		"Makefile.am" \
		|| die
	printf \
		"#!/bin/sh\\nprintf '%s'\\n\n" "${MY_PV}" \
		> \
		"scripts/version" \
		|| die

	# jq-1.6-r3-never-bundle-oniguruma makes sure we build with the system oniguruma,
	# but the bundled copy of oniguruma still gets eautoreconf'd since it
	# exists; save the cycles by nuking it.
	sed -i \
		-e '/modules\/oniguruma/d' \
		"Makefile.am" \
		|| die
	rm -rf \
		"${S}/modules/oniguruma" \
		|| die

	default

	sed -i "s/\[jq_version\]/[${MY_PV}]/" "configure.ac" || die

	eautoreconf
}

src_configure() {
	# Build time breakage when building with clang
	export CC="gcc"
	export CXX="g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# TODO: Drop on next release > 1.7.1
	# bug #944014
	append-cflags -std=gnu17

	cflags-hardened_append

	local econfargs=(
		$(use_enable static-libs static)
		$(use_with oniguruma oniguruma yes)
		# Don't try to rebuild docs \
		--disable-docs
		--disable-valgrind
		--disable-maintainer-mode
	)
	econf "${econfargs[@]}"
}

src_test() {
	if ! LD_LIBRARY_PATH="${S}/.libs" nonfatal emake check ; then
		if [[ -r "${S}/test-suite.log" ]]; then
eerror "Tests failed, outputting testsuite log"
			cat "${S}/test-suite.log" || die
		fi
eerror "Tests failed"
		die
	fi
}

src_install() {
	local DOCS=( "AUTHORS" "NEWS.md" "README.md" "SECURITY.md" )
	default
	use static-libs || { find "${D}" -name '*.la' -delete || die; }
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (20250429)
# test-suite:  pass
# hello-world json object:  pass
