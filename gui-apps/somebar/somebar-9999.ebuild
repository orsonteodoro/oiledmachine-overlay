# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic git-r3 meson

DESCRIPTION="dwm-like bar for dwl"
HOMEPAGE="https://git.sr.ht/~raphi/somebar"
EGIT_REPO_URI="https://git.sr.ht/~raphi/somebar"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

CONTRIB_PATCHES_IUSE=(
colorless-status hide-vacant-tags indicator-size-props ipc
markup-in-status-messages show-status-on-selected-monitor
)
IUSE+="
	${CONTRIB_PATCHES_IUSE[@]}
"
DEPEND="
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
"

src_prepare() {
	default
	local u
	for u in ${CONTRIB_PATCHES_IUSE[@]} ; do
		if use ${u} ; then
ewarn "${u} is a contrib patch.  Enabling too many contribs may result in merge conflicts."
			if use ipc && [[ "${u}" == "ipc" ]] ; then
				eapply "${FILESDIR}/${PN}-9999-ipc.patch"
			elif use ${u} && ! [[ "${u}" == "ipc" ]] ; then
				eapply "contrib/${u}.patch"
			fi
		fi
	done
	if ! [[ -f src/config.hpp ]] ; then
		cat src/config.def.hpp > src/config.hpp || die
	fi
}

set_font() {
	local font=${SOMEBAR_FONT:-Sans 12}
	sed -i -e "s|Sans 12|${font}|g" "src/config.hpp" || die
einfo "SOMEBAR_FONT:\t\t${font}"
}

set_termcmd() {
	local cmd=${SOMEBAR_TERMCMD:-foot}
	sed -i -e "s|foot|${cmd}|g" "src/config.hpp" || die
einfo "SOMEBAR_TERMCMD:\t\t${cmd}"
}

set_topbar() {
	local topbar=${SOMEBAR_TOPBAR:-true}
	sed -i -e "s|topbar = true|topbar = ${topbar}|g" "src/config.hpp" || die
einfo "SOMEBAR_TOPBAR:\t\t${topbar}"
}

set_padding() {
	local paddingx=${SOMEBAR_PADDINGX:-10}
	sed -i -e "s|paddingX = 10|paddingX = ${paddingx}|g" "src/config.hpp" || die
einfo "SOMEBAR_PADDINGX:\t\t${paddingx}"

	local paddingy=${SOMEBAR_PADDINGY:-3}
	sed -i -e "s|paddingY = 3|paddingY = ${paddingy}|g" "src/config.hpp" || die
einfo "SOMEBAR_PADDINGY:\t\t${paddingy}"
}

set_colors() {
	local ic1=${SOMEBAR_INACTIVECOLOR_FG:-0xbb, 0xbb, 0xbb}
	sed -i -e "s|0xbb, 0xbb, 0xbb|${ic1}|g" "src/config.hpp" || die
einfo "SOMEBAR_INACTIVECOLOR_FG:\t${ic1}"

	local ic2=${SOMEBAR_INACTIVECOLOR_BG:-0x22, 0x22, 0x22}
	sed -i -e "s|0x22, 0x22, 0x22|${ic2}|g" "src/config.hpp" || die
einfo "SOMEBAR_INACTIVECOLOR_BG:\t${ic2}"

	local ac1=${SOMEBAR_ACTIVECOLOR_FG:-0xee, 0xee, 0xee}
	sed -i -e "s|0xee, 0xee, 0xee|${ac1}|g" "src/config.hpp" || die
einfo "SOMEBAR_ACTIVECOLOR_FG:\t${ac1}"

	local ac2=${SOMEBAR_ACTIVECOLOR_BG:-0x00, 0x55, 0x77}
	sed -i -e "s|0x00, 0x55, 0x77|${ac2}|g" "src/config.hpp" || die
einfo "SOMEBAR_ACTIVECOLOR_BG:\t${ac2}"
}

src_configure() {
einfo "Environment variables:"
	set_font
	set_termcmd
	set_topbar
	set_padding
	set_colors
	meson_src_configure
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	if use ipc && has_version "gui-wm/dwl[-somebar]" ; then
ewarn
ewarn "The gui-wm/dwl[somebar] USE flag must be enabled."
ewarn
	fi
}
