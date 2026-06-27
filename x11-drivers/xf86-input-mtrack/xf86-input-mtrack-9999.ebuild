# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"x11-base/xorg-server-9999"
)

inherit chkl secure-version vcs-snapshot

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="d38088b4330603fdc8353509eab2387d5dd2ef3b"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/p2rkw/xf86-input-mtrack.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/p2rkw/xf86-input-mtrack/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Xorg Driver for Multitouch Trackpads"
HOMEPAGE="https://github.com/p2rkw/xf86-input-mtrack"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND="
	>=sys-libs/mtdev-1.0:=
	>=x11-base/xorg-server-${XORG_SERVER_PV}:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto:="

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	econf $(use_enable debug)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog
	elog "To enable multitouch support add the following lines"
	elog "to your xorg.conf:"
	elog
	elog "Section \"InputClass\""
	elog "  MatchIsTouchpad \"true\""
	elog "  Identifier      \"Touchpads\""
	elog "  Driver          \"mtrack\""
	elog "EndSection"
	elog
}
