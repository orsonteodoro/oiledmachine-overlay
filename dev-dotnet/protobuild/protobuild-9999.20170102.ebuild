# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND="dev-util/nant"
DEPEND="${RDEPEND}"

inherit dotnet eutils mono

COMMIT="35a15c0a1755e15bc4109fffa6c812fd834b7c85"
DESCRIPTION="Protobuild is a Cross-platform project generation for C#"
HOMEPAGE="https://protobuild.org/"
SRC_URI="https://github.com/Protobuild/Protobuild/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN^}-${COMMIT}"

pkg_setup() {
	ewarn "You will be bootstrapping protobuild from Protobuild.exe.  We cannot guarantee that this specific binary is safe.  Use at your own risk."
	ewarn "Press ctrl+x now to exit or else wait 30 seconds."
#	sleep 30
}

src_prepare() {
	dotnet_pkg_setup

	eapply_user
}

src_compile() {
        einfo "Building solution"
	mono ${PN^}.exe -generate Linux
        exbuild ${PN^}.Linux.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	exeinto /usr/bin
	doexe ${PN^}/bin/Linux/AnyCPU/${mydebug}/${PN^}.exe

	dotnet_multilib_comply
}
