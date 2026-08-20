# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"net-misc/curl-9999"
)

inherit chkl cflags-hardened linux-info multilib-minimal secure-version verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="7922bbd7a9561fc3f8ebd6f5cecdc288dcd4457f"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://git.gnunet.org/libmicrohttpd.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
		mirror://gnu/${PN}/${P}.tar.gz
		verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )
	"
fi

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"

SO_CURRENT=74
SO_AGE=62
SO_VERSION=$(( ${SO_CURRENT} - ${SO_AGE} ))
LICENSE="|| ( LGPL-2.1+ !ssl? ( GPL-2+-with-eCos-exception-2 ) )"
SLOT="0/${SO_VERSION}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
IUSE+=" debug +epoll +eventfd ssl static-libs test +thread-names verify-sig"
REQUIRED_USE="epoll? ( kernel_linux )"
RESTRICT="!test? ( test )"

KEYRING_VER=201906

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20-r0:=[${MULTILIB_USEDEP}] )"
# libcurl and the curl binary are used during tests on CHOST
DEPEND="${RDEPEND}
	test? ( >=net-misc/curl-${CURL_PV}:=[ssl?] )"
BDEPEND="ssl? ( virtual/pkgconfig )
	verify-sig? ( ~sec-keys/openpgp-keys-libmicrohttpd-${KEYRING_VER} )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libmicrohttpd-${KEYRING_VER}.asc

DOCS=( AUTHORS NEWS COPYING README ChangeLog )

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK=""
		use epoll && CONFIG_CHECK+=" ~EPOLL"
		ERROR_EPOLL="EPOLL is not enabled in kernel, but enabled in libmicrohttpd."
		ERROR_EPOLL+=" libmicrohttpd will fail to start with 'automatic' configuration."
		use eventfd && CONFIG_CHECK+=" ~EVENTFD"
		ERROR_EVENTFD="EVENTFD is enabled in libmicrohttpd, but not available in kernel."
		ERROR_EVENTFD+=" libmicrohttpd will not work."
		check_extra_config
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		verify-sig_src_unpack
	fi
	local c=$(grep "^LIB_VERSION_CURRENT=" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "=")
	local a=$(grep "^LIB_VERSION_AGE=" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "=")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SO_VERSION}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SO_VERSION in ebuild"
eerror "QA:  Actual sover:  ${actual_sover}"
eerror "QA:  Expected sover:  ${expected_sover}"
		die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	ECONF_SOURCE="${S}" \
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--enable-bauth \
		--enable-dauth \
		--enable-messages \
		--enable-postprocessor \
		--enable-httpupgrade \
		--disable-examples \
		--disable-tools \
		--disable-experimental \
		--disable-heavy-tests \
		--enable-itc=$(usex eventfd eventfd pipe) \
		$(use_enable debug asserts) \
		$(use_enable thread-names) \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_with ssl gnutls) \
		$(use_enable ssl https)
}

multilib_src_install_all() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
