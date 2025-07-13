# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Default enable brotli at some point? But in 2.70.0 not advertised to servers yet - https://gitlab.gnome.org/GNOME/libsoup/issues/146

CFLAGS_HARDENED_CI_SANITIZERS="asan"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="9" # F31
CFLAGS_HARDENED_LANGS="c-lang"
CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS IO IU NPD OOBR SO UAF"
VALA_USE_DEPEND="vapigen"

inherit cflags-hardened gnome.org meson-multilib vala xdg

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

DESCRIPTION="HTTP client/server library for GNOME"
HOMEPAGE="https://libsoup.gnome.org"
LICENSE="LGPL-2.1+"
SLOT="2.4"
IUSE="
brotli gssapi gtk-doc +introspection samba ssl sysprof test +vala
ebuild_revision_26
"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	vala? (
		introspection
	)
"
DEPEND="
	>=dev-libs/glib-2.58:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=net-libs/libpsl-0.20[${MULTILIB_USEDEP}]
	sys-libs/zlib
	brotli? (
		>=app-arch/brotli-1.0.6-r1:=[${MULTILIB_USEDEP}]
	)
	gssapi? (
		virtual/krb5[${MULTILIB_USEDEP}]
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.54:=
	)
	samba? (
		net-fs/samba
	)
	sysprof? (
		>=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}
	>=net-libs/glib-networking-2.38.2[ssl?,${MULTILIB_USEDEP}]
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	dev-libs/glib
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? (
		>=dev-util/gtk-doc-1.20
		app-text/docbook-xml-dtd:4.1.2
	)
	vala? (
		$(vala_depend)
	)
"
DISABLED_BDEPEND="
	test? (
		www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
		dev-lang/php[apache2,xmlrpc]
		net-misc/curl
		net-libs/glib-networking[ssl])
"

PATCHES=(
	# Disable apache tests until they are usable on Gentoo, bug #326957
	"${FILESDIR}/disable-apache-tests.patch"
	# libxml2-2.12 fix, bug #917556
	"${FILESDIR}/libxml2-2.12.patch"
)

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
	# https://gitlab.gnome.org/GNOME/libsoup/issues/159 - could work with libnss-myhostname
	sed -i \
		-e '/hsts/d' \
		"tests/meson.build" \
		|| die
}

src_configure() {
	cflags-hardened_append
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	# But necessary while apache tests are disabled
	#addpredict /usr/share/snmp/mibs/.index
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature brotli)
		$(meson_feature gssapi)
		$(meson_feature samba ntlm)
		$(meson_feature sysprof)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala vapi)
		$(meson_use test tests)
		# Avoid automagic, built-in feature of meson \
		-Dauto_features=enabled
		-Dgnome=false
		-Dinstalled_tests=false
		-Dkrb5_config="${CHOST}-krb5-config"
		-Dntlm_auth="${EPREFIX}/usr/bin/ntlm_auth"
		-Dtls_check=false # disables check, we still rdep on glib-networking
	)
	meson_src_configure
}
