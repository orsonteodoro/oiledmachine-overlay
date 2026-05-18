# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="92308bf784883e9dd12c37901b50ab3f63f633d4" # Sep 14, 2025
	EGIT_REPO_URI="https://github.com/geany/geany-themes.git"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	SRC_URI="https://github.com/geany/geany-themes/archive/refs/tags/"$(ver_cut "1-2" "${PV}")".zip"
fi

DESCRIPTION="A collection of colour schemes for Geany"
HOMEPAGE="
	https://www.geany.org/download/themes/
	https://github.com/geany/geany-themes
"

LICENSE="
	BSD-2
	GPL-3
	LGPL-2.1
	MIT
"
SLOT="0"
KEYWORDS="amd64 x86"
RDEPEND="
	>=dev-util/geany-${PV:0:4}
"
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_compile() {
	:
}

src_install() {
	default
	insinto "/usr/share/geany"
	doins -r "colorschemes"
}
