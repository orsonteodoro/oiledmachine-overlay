# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg
inherit multilib-minimal

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/1" # subslot = suffix of libgcr-base-3 and co

IUSE+=" gtk gtk-doc +introspection +vala"
REQUIRED_USE+=" vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

DEPEND+="
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}]
	>=app-crypt/p11-kit-0.19.0[${MULTILIB_USEDEP}]
	gtk? ( >=x11-libs/gtk+-3.12:3[X,introspection?,${MULTILIB_USEDEP}] )
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.58:= )"
RDEPEND+=" ${DEPEND}
	app-crypt/gnupg"
BDEPEND+="
	${PYTHON_DEPS}
	gtk? ( dev-libs/libxml2:2[${MULTILIB_USEDEP}] )
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.9
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8[${MULTILIB_USEDEP}]
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	vala? ( $(vala_depend) )"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-gck-slot-test.patch
	"${FILESDIR}"/${PV}-meson-vapi-deps.patch
	"${FILESDIR}"/${PV}-meson-enum-race.patch
	"${FILESDIR}"/${PV}-avoid-gnupg-circular-dep.patch
	"${FILESDIR}"/${PV}-optional-vapi.patch
	"${FILESDIR}"/${PV}-meson-fix-gtk-doc-without-ui.patch
	"${FILESDIR}"/${PV}-add-multiabi-suffix.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}"
		local emesonargs=(
			$(multilib_native_usex introspection -Dintrospection=true -Dintrospection=false)
			$(meson_use gtk)
			$(meson_use gtk-doc gtk_doc)
			-Dgpg_path="${EPREFIX}"/usr/bin/gpg
			$(multilib_native_usex vala -Dvapi=true -Dvapi=false)
			-Dabi="${ABI}"
		)
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		cd "${BUILD_DIR}"
		dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_install
		dosym /usr/bin/gcr-viewer.${ABI} /usr/bin/gcr-viewer
		dosym /usr/libexec/gcr-prompter.${ABI} /usr/libexec/gcr-prompter
		dosym /usr/libexec/gcr-ssh-askpass.${ABI} /usr/libexec/gcr-ssh-askpass
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
