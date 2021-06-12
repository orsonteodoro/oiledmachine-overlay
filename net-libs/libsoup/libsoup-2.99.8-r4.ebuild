# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org flag-o-matic llvm meson-multilib python-any-r1 vala xdg

DESCRIPTION="HTTP client/server library for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"
LICENSE="LGPL-2.1+"
SLOT="3/${PV}"
# TODO: Default enable brotli at some point? But in 2.70.0 not advertised to
# servers yet - https://gitlab.gnome.org/GNOME/libsoup/issues/146
# tests are enabled by default upstream
# The value of introspection depends on super project but set to auto by default.
IUSE+=" brotli gssapi -gtk-doc +introspection samba ssl sysprof test
-test-fuzzing test-http2 test-pkcs11 test-regression test-websockets +vala
winbind"
# autobahn-testsuite is python2 only, so test-websockets is disabled.
# https://github.com/crossbario/autobahn-testsuite/issues/107
REQUIRED_USE+="
	!test-websockets
	test? ( || ( test-fuzzing test-http2 test-pkcs11 test-regression
			test-websockets ) )
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
	gtk-doc? ( >=dev-util/gtk-doc-1.33.2
		app-text/docbook-xml-dtd:4.3 )
	test? (
		test-fuzzing? (
			sys-devel/gcc[sanitize]
			|| (
				(
	sys-devel/clang:11[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-11*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	=sys-libs/compiler-rt-sanitizers-11*[libfuzzer,asan,ubsan]
				)
				(
	sys-devel/clang:12[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-12*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	=sys-libs/compiler-rt-sanitizers-12*[libfuzzer,asan,ubsan]
				)
				(
	sys-devel/clang:13[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	=sys-libs/compiler-rt-sanitizers-13*[libfuzzer,asan,ubsan]
				)
			)
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
		if has_version '<app-crypt/mit-krb5-1.19.1' ; then
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
	for a in ${abis[@]} ; do
		for p in ${_MULTILIB_FLAGS[@]} ; do
			if [[ "${p}" =~ "${a}" ]] ; then
				local u=$(echo "${p}" | cut -f 1 -d ":")
				if ! use ${u} ; then
					einfo "Skipped sys-devel/clang[${u}]"
					continue
				fi
				einfo "Checking sys-devel/clang[${u}]"
				# `emerge -1 libsoup` is not good enough to make
				# the fuzzer test happy.
				if has_version "sys-devel/clang[${u}]" ; then
					einfo "sys-devel/clang[${u}] found"
				else
					die \
"Inconsistency with sys-devel/clang[${u}].  Run emerge with --deep or -D."
				fi
			fi
		done
	done

	if ver_test $(ver_cut 1-3 ${PV}) -eq 2.99.8 ; then
		ewarn \
"Expecting test failure(s).  Disable the test USE flag to emerge successfully."
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

multilib_src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	# But necessary while apache tests are disabled
	#addpredict /usr/share/snmp/mibs/.index

	if use test-fuzzing ; then
		if has_version "sys-devel/clang:13" \
			&& has_version "=sys-devel/clang-runtime-13*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-13*" \
			; then
			einfo "Using clang:13"
			LLVM_MAX_SLOT=13
			llvm_pkg_setup
		elif has_version "sys-devel/clang:12" \
			&& has_version "=sys-devel/clang-runtime-12*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-12*" \
			; then
			einfo "Using clang:12"
			LLVM_MAX_SLOT=12
			llvm_pkg_setup
		elif has_version "sys-devel/clang:11" \
			&& has_version "=sys-devel/clang-runtime-11*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-11*" \
			; then
			einfo "Using clang:11"
			LLVM_MAX_SLOT=11
			llvm_pkg_setup
		else
			die \
"Fix the clang toolchain.  It requires \
sys-devel/clang:\${SLOT}, \
=sys-devel/clang-runtime-\${SLOT}*, \
=sys-libs/compiler-rt-sanitizers-\${SLOT}"
		fi
	fi

	local chost=$(get_abi_CHOST ${ABI})
	if use test-fuzzing ; then
		filter-flags -frename-registers
		CC=${chost}-clang
	fi

	local emesonargs=(
		-Dgnome=false
		-Dkrb5_config="${chost}-krb5-config"
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
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala vapi)
		$(meson_use test tests)
	)
	meson_src_configure
}

multilib_src_test() {
	# Test disabled: test-regression test-websockets
	# Test enabled: test-fuzzing test-http2 test-pkcs11
	# Result of 2.99.8
	# Dated Jun 12, 2021

#Summary of Failures:

# 2/35 libsoup / cache-test                   ERROR            1.49s   exit status 1
#33/35 libsoup / ssl-test                     TIMEOUT         60.02s   killed by signal 15 SIGTERM


#Ok:                 32
#Expected Fail:      0
#Fail:               1
#Unexpected Pass:    0
#Skipped:            1
#Timeout:            1

	meson test || die
}
