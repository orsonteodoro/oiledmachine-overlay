# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
HOMEPAGE="https://github.com/haf/DotNetZip.Semverd"
DESCRIPTION="create, extract, or update zip files with C# (=DotNetZip+SemVer)"
LICENSE="MS-PL" # https://github.com/haf/DotNetZip.Semverd/blob/master/LICENSE
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
USE_DOTNET="net45"
S="${WORKDIR}/DotNetZip.Semverd-${PV}"
IUSE="net45 +gac +nupkg developer debug doc"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg gac? ( net45 )"
inherit dotnet pc-file
SRC_URI="https://github.com/haf/DotNetZip.Semverd/archive/v1.9.3.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/version-${PV}.patch"
}

src_compile() {
	exbuild ${STRONG_ARGS_NETFX}"${S}/src/Ionic.snk" "src/Zip Reduced/Zip Reduced.csproj"
}

src_install() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi
	egacinstall "src/Zip Reduced/bin/${DIR}/Ionic.Zip.Reduced.dll"
	einstall_pc_file "${PN}" "${PV}" "Ionic.Zip.Reduced.dll"

	dotnet_multilib_comply
}

