# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl flag-o-matic secure-version toolchain-funcs multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_VERSION="1.4.6"
	SOVER=$(ver_cut 1 "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="3dbba4baa3cbdc3baf06d3ba086d8094bd98cd88"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/RHash-${PV}"
	EGIT_REPO_URI="https://github.com/rhash/RHash.git"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut 1 "${PV}")
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}-src.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Console utility and library for computing and verifying file hash sums"
HOMEPAGE="https://rhash.sourceforge.net/"

LICENSE="0BSD"
SLOT="0/${SOVER}"
IUSE="cpu_flags_x86_sha debug nls ssl static-libs"
S="${WORKDIR}/RHash-${PV}"

RDEPEND="
	ssl? (
		$(secure-version_gen_openssl_depends '' '[MULTILIB_USEDEP]')
	)
"


DEPEND="
	${RDEPEND}
"

BDEPEND="
	nls? ( sys-devel/gettext )
"

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
	local actual_sover=$(grep -E -o -e "[0-9.]+" "${S}/version.h" | cut -f 1 -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update PV or INTERNAL_VERSION"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] ; then
		# we lack posix_memalign
		sed -i -e '/if _POSIX_VERSION/s/if .*$/if 0/' \
			librhash/util.h || die
	fi

	# upstream fix for BSD and others, but was only applied for BSD
	# we need support for Solaris, where we use a GNU toolchain, so use
	# the original hack, hopefully next release has this fixed
	# https://github.com/rhash/RHash/issues/238
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/^elif linux; then/else/' configure || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	set -- \
		./configure \
		--target="${CHOST}" \
		--cc="$(tc-getCC)" \
		--ar="$(tc-getAR)" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--sysconfdir="${EPREFIX}"/etc \
		--disable-openssl-runtime \
		--disable-static \
		--enable-lib-shared \
		$(usev !cpu_flags_x86_sha '--disable-shani') \
		$(use_enable debug) \
		$(use_enable nls gettext) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs lib-static)

	echo "${@}"
	"${@}" || die "configure failed"
}

multilib_src_compile() {
	emake all \
		$(multilib_is_native_abi && use nls && echo compile-gmo)
}

multilib_src_install() {
	# -j1 needed due to race condition.
	emake DESTDIR="${D}" -j1 \
		install{,-lib-headers,-pkg-config} \
		$(multilib_is_native_abi && use nls && echo install-gmo) \
		install-lib-so-link
}

multilib_src_test() {
	emake test
}
