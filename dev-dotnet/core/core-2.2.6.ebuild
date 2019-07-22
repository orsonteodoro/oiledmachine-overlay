# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CORE_V=${PV}

DESCRIPTION="Home repository for .NET Core"
HOMEPAGE="https://github.com/dotnet/core"
LICENSE="MIT"

IUSE="samples docs"

SRC_URI="https://github.com/dotnet/core/archive/v${CORE_V}.tar.gz -> core-${CORE_V}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}
CORE_S="${S}/core-${CORE_V}"

src_unpack() {
	unpack "core-${CORE_V}.tar.gz"
}

src_install() {
	local dest="/usr/share/dotnetcore-sdk"
	local ddest="${D}/${dest}"
	local dest_core="${dest}/core"
	local ddest_core="${ddest}/core"

	dodir "${dest_core}"

	if use samples ; then
		cp -a "${CORE_S}/"/samples "${ddest_core}"/ || die
	else
		rm -rf "${CORE_S}/"/samples || die
	fi
	if use docs ; then
		cp -a "${CORE_S}/"/* "${ddest_core}"/ || die
	fi
}

pkg_postinst() {
	einfo "Samples and documents were installed in /usr/share/dotnetcore-sdk/core"
}
