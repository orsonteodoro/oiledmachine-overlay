# A redirect ebuild

EAPI=8

inherit multilib-build

SLOT="0"
RDEPEND="~dev-dotnet/${PN}-${PV}[${MULTILIB_USEDEP}]"
