# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org meson-multilib python-any-r1 vala xdg

DESCRIPTION="HTTP client/server library for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"
LICENSE="LGPL-2.1+"
SLOT="3/${PV}"
# TODO: Default enable brotli at some point? But in 2.70.0 not advertised to
# servers yet - https://gitlab.gnome.org/GNOME/libsoup/issues/146
# tests are enabled by default upstream
# The value of introspection depends on super project but set to auto by default.
IUSE+=" brotli gssapi -doc +introspection samba ssl sysprof test
-test-fuzzing test-http2 test-pkcs11 test-regression test-websockets +vala
winbind"
REQUIRED_USE+="
	test? ( || ( test-fuzzing test-http2 test-pkcs11 test-regression test-websockets ) )
	test-fuzzing? ( test )
	test-http2? ( test )
	test-pkcs11? ( test )
	test-regression? ( test )
	test-websockets? ( test )
	vala? ( introspection )
	winbind? ( samba )
"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86"
# For CI OS and dependency list, See
# https://gitlab.gnome.org/GNOME/libsoup/-/blob/2.99.8/.gitlab-ci/Dockerfile#L1
# Uses F34
GLIB_V="2.67.4" # glib on F34 is 2.68.2, glib-utils on F34 is 2.68.1
GLIB_NETWORKING_V="2.68.1"
# The GCC version is relaxed for now.  F34 uses GCC 11.0.1 but CI uses 11.1.1.
# The Clang version is relaxed for now.  F34 uses 12 for clang-analyzer
DEPEND+="
	>=dev-db/sqlite-3.34.1:3[${MULTILIB_USEDEP}]
	>=dev-libs/glib-${GLIB_V}:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.10:2[${MULTILIB_USEDEP}]
	>=net-libs/libpsl-0.20[${MULTILIB_USEDEP}]
	>=net-libs/nghttp2-1.43.0[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	virtual/libc
	brotli? ( >=app-arch/brotli-1.0.9:=[${MULTILIB_USEDEP}] )
	gssapi? (
		virtual/krb5[${MULTILIB_USEDEP}]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.68:= )
	samba? ( >=net-fs/samba-4.14.2[${MULTILIB_USEDEP},winbind?] )
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
"
RDEPEND+=" ${DEPEND}
	>=net-libs/glib-networking-${GLIB_NETWORKING_V}[ssl?,${MULTILIB_USEDEP}]
"
# CI uses gcc
# Selective testing used here so that users don't have be forced to add unused
# features or reduce rebuild cost.
BDEPEND+="
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	>=dev-libs/glib-${GLIB_V}[${MULTILIB_USEDEP}]
	>=dev-util/glib-utils-${GLIB_V}
	>=dev-util/meson-0.53
	>=sys-devel/gettext-0.21[${MULTILIB_USEDEP}]
	doc? ( >=dev-util/gtk-doc-1.33.2
		app-text/docbook-xml-dtd:4.3 )
	test? (
		test-fuzzing? (
			sys-devel/gcc[sanitize]
			sys-devel/clang[${MULTILIB_USEDEP}]
			sys-libs/compiler-rt-sanitizers[libfuzzer,asan,ubsan]
		)
		test-http2? (
			${PYTHON_DEPS}
			$(python_gen_any_dep 'dev-python/quart[${PYTHON_USEDEP}]')
		)
		test-pkcs11? (
			>=net-libs/gnutls-3.7.1[${MULTILIB_USEDEP},pkcs11]
		)
		test-regression? (
			>=dev-lang/php-7.4.16[apache2,xmlrpc]
			>=www-servers/apache-2.4.46[\
apache2_modules_alias,\
apache2_modules_auth_basic,\
apache2_modules_auth_digest,\
apache2_modules_authn_file,\
apache2_modules_authz_host,\
apache2_modules_authz_user,\
apache2_modules_dir,\
apache2_modules_mime,\
apache2_modules_proxy,\
apache2_modules_proxy_connect,\
apache2_modules_proxy_http,\
apache2_modules_unixd,\
ssl]
		)
		test-websockets? (
			${PYTHON_DEPS}
			$(python_gen_any_dep 'dev-python/autobahn-testsuite[${PYTHON_USEDEP}]')
		)
	)
	>=net-misc/curl-7.76.0
	>=net-libs/glib-networking-${GLIB_NETWORKING_V}[ssl]
	vala? ( $(vala_depend) )
"
SRC_URI="
https://gitlab.gnome.org/GNOME/libsoup/-/archive/${PV}/libsoup-${PV}.tar.bz2
"
RESTRICT="!test? ( test )"
PATCHES=(
	"${FILESDIR}/${PN}-2.99.8-regression_tests-option.patch"
)

pkg_setup() {
	if use gssapi ; then
		if has '<app-crypt/mit-krb5-1.19.1' ; then
			# virtual/krb5 probs or virtuals in general
			die ">=app-crypt/mit-krb5-1.19.1 is required"
		fi
	fi
	if use test ; then
		if [[ "${FEATURES}" =~ test ]] ; then
			:;
		else
			die \
"You must add FEATURES=test before emerge to run test suite."
		fi
		python-any-r1_pkg_setup
	fi
	local abis=( $(multilib_get_enabled_abis) )
	if (( ${#abis[@]} > 1 )) ; then
		einfo "Checking multi ABIS for clang"
		# `emerge -1 libsoup` is not good enough to make fuzzer test happy.
		if ! has 'sys-devel/clang[${MULTILIB_USEDEP}]' ; then
			die \
"Inconsistency with MULTLIB_USEDEP.  Run emerge with --deep or -D."
		fi
	fi
}

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
	# Note below originally was about a disable apache-test patch being applied.
	# https://gitlab.gnome.org/GNOME/libsoup/issues/159 - could work with \
	#   libnss-myhostname
	sed -e '/hsts/d' -i tests/meson.build || die
}

src_configure() {
	if use test-fuzzing ; then
		local chost=$(get_abi_CHOST ${ABI})
		CC=${chost}-clang
	fi
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	# But necessary while apache tests are disabled
	#addpredict /usr/share/snmp/mibs/.index
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		-Dgnome=false
		-Dkrb5_config="${CHOST}-krb5-config"
		-Dntlm_auth="${EPREFIX}/usr/bin/ntlm_auth"
		-Dinstalled_tests=false
		-Dtls_check=false # disables check, we still rdep on
				  # glib-networking
		$(meson_feature brotli)
		$(meson_feature gssapi)
		$(meson_feature samba ntlm)
		$(meson_feature sysprof)
		$(meson_feature test-fuzzing fuzzing)
		$(meson_feature test-http2 http2_tests)
		$(meson_feature test-pkcs11 pkcs11_tests)
		$(meson_feature test-regression regression_tests)
		$(meson_feature test-websockets autobahn)
		$(meson_native_use_bool doc gtk_doc)
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala vapi)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	meson test || die
}
