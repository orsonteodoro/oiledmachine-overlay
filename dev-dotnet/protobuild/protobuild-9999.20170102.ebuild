# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Protobuild is a Cross-platform project generation for C#"
HOMEPAGE="https://protobuild.org/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND="dev-util/nant"
DEPEND="${RDEPEND}"
USE_DOTNET="net45"
inherit dotnet eutils mono
EGIT_COMMIT="35a15c0a1755e15bc4109fffa6c812fd834b7c85"
SRC_URI="https://github.com/Protobuild/Protobuild/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
SLOT="0"
S="${WORKDIR}/${PN^}-${EGIT_COMMIT}"

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
	mono ${PN^}.exe -generate Linux
        exbuild ${PN^}.Linux.sln || die
}

src_install() {
	exeinto /usr/bin
	doexe ${PN^}/bin/Linux/AnyCPU/$(usex debug "Debug" "Release")/${PN^}.exe

	dotnet_multilib_comply
}
