# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Home repository for .NET Core"
HOMEPAGE="https://github.com/dotnet/core"
LICENSE="all-rights-reserved MIT"
# The vanilla MIT license does not contain all rights reserved
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="doc examples"
CORE_V=${PV}
SRC_URI="\
https://github.com/dotnet/core/archive/v${CORE_V}.tar.gz \
	-> core-${CORE_V}.tar.gz"
SLOT="${PV}"
S="${WORKDIR}/core-${CORE_V}"
RESTRICT="mirror"

src_unpack() {
	unpack "core-${CORE_V}.tar.gz"
}

src_install() {
	local dest="/usr/share/dotnetcore-sdk/${SLOT}"
	local ddest="${D}/${dest}"
	local dest_core="${dest}/core"
	local ddest_core="${ddest}/core"
	if use examples ; then
		insinto "${dest}"
		doins -r "${S}/samples"
	fi
	rm -rf "${S}/samples" || die
	if use doc ; then
		insinto "${dest_core}"
		doins -r "${S}/"*
	fi

	docinto license
	dodoc LICENSE.TXT
}

pkg_postinst() {
	einfo \
"Samples and documents were installed in /usr/share/dotnetcore-sdk/${SLOT}/core"
}
