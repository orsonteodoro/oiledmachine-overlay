# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit meson-multilib python-any-r1 verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="8057b299308828aeefb97076b1b0a0649f8fcae5"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/emersion/libdisplay-info.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	SOVER="4"
	SLOT="0/${SOVER}"
	inherit git-r3
else
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
	SLOT="0/"$(ver_cut "2" "${PV}")
	SRC_URI="
https://gitlab.freedesktop.org/emersion/${PN}/-/releases/${PV}/downloads/${P}.tar.xz
https://gitlab.freedesktop.org/emersion/${PN}/-/releases/${PV}/downloads/${P}.tar.xz.sig
	"
fi

DESCRIPTION="EDID and DisplayID library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libdisplay-info"
LICENSE="MIT"
IUSE+=" ebuild_revision_1"
BDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-emersion )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
PATCHES=(
	"${FILESDIR}/${PN}-772d506-remove-dev-suffix.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		local actual_slot=$(grep -e "version:" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'" | cut -f 2 -d ".")
		local expected_slot="${SOVER}"
		if ver_test "${actual_slot}" "-ne" "${expected_slot}" ; then
eerror "QA:  Update SOVER"
eerror "QA:  Expected slot:  ${expected_slot}"
eerror "QA:  Actual slot:  ${actual_slot}"
			die
		fi
	else
		unpack ${A}
	fi
	die
}
