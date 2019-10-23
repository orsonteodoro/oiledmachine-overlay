# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Getopt.Long-inspired option parsing library for CSharp"
HOMEPAGE="http://tirania.org/blog/archive/2008/Oct-14.html"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
USE_DOTNET="net45"
IUSE="+${USE_DOTNET} gac nupkg"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg gac? ( net45 )"
DEPEND="dev-lang/mono[external-mono-options]"
RDEPEND="${DEPEND}"
inherit nupkg pc-file
EGIT_COMMIT="3abbe5b7e6cb6fed2cd1f85598ccd5d5f63a3bda"
SRC_URI="https://github.com/mono/mono/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/mono-${EGIT_COMMIT}"
SLOT="0/${PV}"
NUSPEC_VERSION=${PV}
ASSEMBLY_VERSION=${PV}

src_configure() {
	# dont' call default configure for the whole mono package, because it is slow
	cat <<-METADATA >AssemblyInfo.cs || die
	  [assembly: System.Reflection.AssemblyVersion("${ASSEMBLY_VERSION}")]
		METADATA
}

src_compile() {
	mcs $(usex gac "-keyfile:mcs/class/mono.snk" "") \
		-sdk:${EBF} \
		-r:System.Core mcs/class/Mono.Options/Mono.Options/Options.cs \
		AssemblyInfo.cs -t:library -out:"Mono.Options.dll" \
		|| die "compilation failed"
	enuspec "${FILESDIR}/Mono.Options.nuspec"
}

src_install() {
	dotnet_install_loc
	doins "Mono.Options.dll"
	egacinstall Mono.Options.dll
	einstall_pc_file ${PN} ${ASSEMBLY_VERSION} Mono.Options
	enupkg "${WORKDIR}/Mono.Options.${NUSPEC_VERSION}.nupkg"
	dotnet_multilib_comply
}
