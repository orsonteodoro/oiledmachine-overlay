# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PNPM_SLOT=9
NODE_VERSION=20
PNPM_INSTALL_ARGS="--frozen-lockfile"
WEBKIT_GTK_STABLE=(
	"2.46"
	"2.44"
	"2.42"
	"2.40"
	"2.38"
	"2.36"
	"2.34"
	"2.32"
	"2.30"
	"2.28"
)

inherit electron-app lcnr pnpm

#KEYWORDS="~amd64" # Build broken, install untested
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/kwaroran/RisuAI/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Make your own story. User-friendly software for LLM roleplaying"
LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
electron ollama tauri tray wayland X
"
REQUIRED_USE="
	^^ (
		tauri
		electron
	)
	|| (
		X
		wayland
	)
"
gen_webkit_depend() {
	local s
	for s in ${WEBKIT_GTK_STABLE[@]} ; do
	# TODO:  add audio minimum requirement for webkit-gtk for tts/stt
	# onnxruntime-web needs webassembly
		echo "
			=net-libs/webkit-gtk-${s}*:4[javascript,jit,introspection,wayland?,webassembly,X?,webgl]
		"
	done
}
RUST_BINDINGS_DEPEND="
	>=app-accessibility/at-spi2-core-2.35.1[introspection]
	>=dev-libs/glib-2.48:2
	>=dev-libs/gobject-introspection-1.64.0
	>=net-libs/libsoup-2.70.0:2.4[introspection]
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.32[introspection]
	>=x11-libs/gtk+-3.18:3[introspection,wayland?,X?]
	>=x11-libs/pango-1.38[introspection]
	elibc_glibc? (
		>=sys-libs/glibc-2.31
	)
	elibc_musl? (
		>=sys-libs/musl-1.1.24
	)
	tray? (
		|| (
			>=dev-libs/libappindicator-12.10.1_p20200408:3
			>=dev-libs/libayatana-appindicator-0.5.4
		)
	)
	|| (
		$(gen_webkit_depend)
	)
"
RUST_BINDINGS_BDEPEND="
	virtual/pkgconfig
"
RDEPEND+="
	ollama? (
		app-misc/ollama
	)
	tauri? (
		|| (
			$(gen_webkit_depend)
		)
		${RUST_BINDINGS_DEPEND}
		|| (
			(
				=dev-lang/rust-bin-1.82*
				dev-lang/rust-bin:=
			)
			(
				=dev-lang/rust-1.82*
				dev-lang/rust:=
			)
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_VERSION}
	sys-apps/pnpm:${PNPM_SLOT}
"

pkg_setup() {
ewarn "This ebuild is still in development"
	pnpm_pkg_setup
	local rust_pv=$(rustc --version | cut -f 2 -d " ")
}

src_unpack() {
	if ver_test "${rust_pv%.*}" -ne "1.82" ; then
eerror "Switch rust to ${rust_pv%.*} via \`eselect rust\`"
		die
	fi
	unpack ${A}
	pnpm_unpack
}

src_compile() {
	pnpm_hydrate
	epnpm --version
	epnpm add -D vite
	epnpm build
	epnpm run tauri build
}

src_install() {
	exeinto "/usr/lib/${PN}"
	if use debug ; then
		doexe "src-tauri/target/debug/${PN}"
	else
		doexe "src-tauri/target/release/${PN}"
	fi

	newicon -s 48 "app-icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Utility;"
	docinto "licenses"
	dodoc "LICENSE"

#	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
#	LCNR_TAG="third_party_cargo"
#	lcnr_install_files

#	LCNR_SOURCE="${S_PROJECT}/node_modules"
#	LCNR_TAG="third_party_npm"
#	lcnr_install_files


	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/${PN}" || die
#!/bin/bash
"/usr/lib/${PN}/${PN}" \$@
EOF
	fperms 0755 "/usr/bin/${PN}"
	fowners "root:root" "/usr/bin/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
