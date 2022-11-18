# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3_{10..11} )

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg
inherit multilib-minimal

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"
SLOT="0/1" # subslot = suffix of libgcr-base-3 and co
IUSE+=" gtk gtk-doc +introspection systemd +vala"
REQUIRED_USE+=" vala? ( introspection )"
# For dependencies see: gcr-3.40.0/meson.build
# Upstream says GPG is optional to avoid circular dependency
DEPEND+="
	>=app-crypt/gnupg-2.3.6
	>=app-crypt/libsecret-0.20[${MULTILIB_USEDEP}]
	>=app-crypt/p11-kit-0.19.0[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	gtk? ( >=x11-libs/gtk+-3.22:3[introspection?,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.58:= )
	systemd? ( sys-apps/systemd:=[${MULTILIB_USEDEP}] )
"
RDEPEND+=" ${DEPEND}
	app-crypt/gnupg
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk? ( dev-libs/libxml2:2[${MULTILIB_USEDEP}] )
	gtk-doc? (
		>=dev-util/gtk-doc-1.9
		>=dev-util/gi-docgen-2022.1
	)
	>=sys-devel/gettext-0.19.8[${MULTILIB_USEDEP}]
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/3.38.0-optional-vapi.patch
)

pkg_setup() {
	use vala && vala_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}"
		local emesonargs=(
			$(multilib_native_usex introspection -Dintrospection=true -Dintrospection=false)
			$(meson_use gtk)
			$(meson_use gtk-doc gtk_doc)
			-Dgpg_path=/usr/bin/gpg
			$(multilib_native_usex vala -Dvapi=true -Dvapi=false)
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
	}
	multilib_foreach_abi install_abi
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/{gck-1,gcr-3,gcr-ui-3} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
