# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"

CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_SANITIZERS_COMPAT="gcc"
CFLAGS_HARDENED_TOLERANCE="4.00"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO SO"

ONIGURUMA_PV="6.9.10"

inherit autotools cflags-hardened check-compiler-switch flag-o-matic

if [[ "${PV}" == "9999" ]] ; then
	FALLBACK_COMMIT="579e6f76cffd7643ba4002a2c3618a5ea710589a"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${MY_P}"
	EGIT_REPO_URI="https://github.com/jqlang/jq.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~arm64-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/jqlang/jq/archive/refs/tags/${MY_P}.tar.gz -> ${P}.gh.tar.gz"
fi
S="${WORKDIR}/${PN}-${MY_P}"

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.io/jq/"
LICENSE="MIT icu CC-BY-3.0"
RESTRICT="!test? ( test )"
SOVER="1"
SLOT="0/${SOVER}"
IUSE="
+oniguruma static-libs test
ebuild_revision_11
"
REQUIRED_USE="test? ( oniguruma )"
RDEPEND="
	oniguruma? (
		>=dev-libs/oniguruma-${ONIGURUMA_PV}:=[static-libs?]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND+="
	>=sys-devel/bison-3.0
	app-alternatives/lex:*
"
DOCS=( AUTHORS NEWS.md README.md )
PATCHES=(
	"${FILESDIR}"/jq-1.6-r3-never-bundle-oniguruma.patch
)

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" == "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local c
	local r
	local a
	c=$(grep -E -o -e "-version-info [0-9:]+" "${S}/Makefile.am" | sed -e "s|-version-info ||g" | cut -f 1 -d ":")
	r=$(grep -E -o -e "-version-info [0-9:]+" "${S}/Makefile.am" | sed -e "s|-version-info ||g" | cut -f 2 -d ":")
	a=$(grep -E -o -e "-version-info [0-9:]+" "${S}/Makefile.am" | sed -e "s|-version-info ||g" | cut -f 3 -d ":")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump SOVER in ebuild."
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	sed -e '/^dist_doc_DATA/d; s:-Wextra ::' -i Makefile.am || die
	printf "#!/bin/sh\\nprintf '%s'\\n\n" "${MY_PV}" > scripts/version || die

	# jq-1.6-r3-never-bundle-oniguruma makes sure we build with the system oniguruma,
	# but the bundled copy of oniguruma still gets eautoreconf'd since it
	# exists; save the cycles by nuking it.
	sed -e '/vendor\/oniguruma/d' -i Makefile.am || die
	rm -rf "${S}"/vendor/oniguruma || die

	default

	sed -i "s/\[jq_version\]/[${MY_PV}]/" configure.ac || die

	eautoreconf
}

src_configure() {
	# Build time breakage when building with clang
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# TODO: Drop on next release > 1.7.1
	# bug #944014
	append-cflags -std=gnu17

	cflags-hardened_append

	local econfargs=(
		# don't try to rebuild docs
		--disable-docs
		--enable-valgrind=no
		--disable-maintainer-mode
		$(use_enable static-libs static)
		$(use_with oniguruma oniguruma yes)
	)
	econf "${econfargs[@]}"
}

src_test() {
	if ! LD_LIBRARY_PATH="${S}/.libs" nonfatal emake check; then
		if [[ -r "${S}/test-suite.log" ]]; then
			eerror "Tests failed, outputting testsuite log"
			cat "${S}/test-suite.log"
		fi
		die "Tests failed"
	fi
}

src_install() {
	default

	use static-libs || { find "${D}" -name '*.la' -delete || die; }
}
