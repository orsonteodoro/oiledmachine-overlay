# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}" # based on liri-base/liri-shell
RDEPEND="liri-base/session:${SLOT}
	 liri-base/shell:${SLOT}"
RESTRICT="mirror"
