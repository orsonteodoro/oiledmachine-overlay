# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Wayland protocol extensions for Hyprland"
HOMEPAGE="https://github.com/hyprwm/hyprland-protocols"

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="1cb6db5fd6bb8aee419f4457402fa18293ace917"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/${PN}.git"
	SUBSLOT="0.7"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SUBSLOT=$(ver_cut "1-2" "${PV}")
	SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0/${SUBSLOT}"

BDEPEND="
	>=dev-build/meson-0.60.3
	app-alternatives/ninja
	dev-util/wayland-scanner
	virtual/pkgconfig
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
	local actual_subslot=$(cat "${S}/VERSION" | cut -f "1-2" -d ".")
	local expected_subslot="${SUBSLOT}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update SUBSLOT in ebuild"
eerror "Actual SUBSLOT:  ${actual_subslot}"
eerror "Expected SUBSLOT:  ${expected_subslot}"
		die
	fi
}

