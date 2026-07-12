# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For deps see nix/package.nix
# For non-essential deps, they been moved to optfeature.

PYTHON_COMPAT=( "python3_"{12..14} )

inherit optfeature python-single-r1

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="a48885b9fec485c903c955749a7da6e30147cd38"
	EGIT_BRANCH="legacy-v4"
	EGIT_REPO_URI="https://github.com/noctalia-dev/noctalia-shell.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/noctalia-dev/noctalia-shell/archive/refs/tags/v${PV}.tar.gz -> ${P}.tag.tar.gz
	"
fi

DESCRIPTION="A sleek and minimal desktop shell thoughtfully crafted for Wayland"
HOMEPAGE="
	https://noctalia.dev/
	https://github.com/noctalia-dev/noctalia-shell
"
LICENSE="MIT"
SLOT="0/4" # 4 = stable, Qt Quickshell based; 5 = pre-alpha GLES based
IUSE+="
calendar wayland X
ebuild_revision_3
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
# TODO:  test other icons
RDEPEND="
	${PYTHON_DEPS}
	dev-util/wayland-scanner:=
	media-gfx/imagemagick:=
	net-misc/wget:=
	|| (
		x11-themes/papirus-icon-theme
	)
	calendar? (
		gnome-extra/evolution-data-server:=[introspection]
		dev-libs/libical:=[introspection]
		dev-libs/glib:=[introspection]
		net-libs/libsoup:3.0=[introspection]
		dev-libs/json-glib:=[introspection]
		dev-libs/gobject-introspection:=
	)
"
DEPEND+="
	${RDEPEND}
	!gui-apps/quickshell
	dev-qt/qtbase:6=[gui,wayland?,X?]
	gui-apps/noctalia-qs:${SLOT}[wayland?,X?]
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	insinto "/etc/xdg/quickshell/noctalia-shell"
	insopts "-m0755"
	doins -r .

	python_optimize "${ED}/etc/xdg/quickshell/${PN}/Scripts/python/src"
	python_fix_shebang "${ED}/etc/xdg/quickshell/${PN}/Scripts/python/src"
}

pkg_postinst() {
	:
	optfeature "clipboard history support" "app-misc/cliphist"
	optfeature "external display brightness control" "app-misc/ddcutil"
	optfeature "night light functionality" "gui-apps/wlsunset"
	optfeature "notification sounds" "dev-qt/qtmultimedia:6"
	optfeature "power profile management" "sys-power/power-profiles-daemon"
	optfeature "screen brightness control" "app-misc/brightnessctl"
	optfeature "system information" "app-misc/fastfetch"
	optfeature "turning on/off monitors" "gui-apps/wlr-randr"
	optfeature "wayland clipboard utilities" "gui-apps/wl-clipboard"
}
