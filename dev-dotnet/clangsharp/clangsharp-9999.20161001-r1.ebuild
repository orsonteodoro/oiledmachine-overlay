# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Clang bindings for .NET and Mono written in C#"
HOMEPAGE="https://github.com/Microsoft/ClangSharp"
LICENSE="UIUC"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="ClangSharp"
SLOT="0/${PV}"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
RDEPEND="media-gfx/mojoshader"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
EGIT_COMMIT="9b5f81a1ac7f0348f8ff82d041d57c3bf36bbe65"
SRC_URI=\
"https://github.com/Microsoft/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	sed -i -e "s|libclang|libclang.dll|g" \
		ClangSharpPInvokeGenerator/Generated.cs
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
		doins bin/${mydebug}/${PROJECT_NAME}.dll
		if use developer ; then
			doins "bin/${mydebug}/ClangSharp.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/${PROJECT_NAME}.dll" \
				"bin/${mydebug}/ClangSharp.dll.mdb"
		fi
		doins \
	ClangSharpPInvokeGenerator/bin/Release/ClangSharpPInvokeGenerator.exe
		doins "${FILESDIR}/ClangSharp.dll.config"
		dotnet_distribute_file_matching_dll_in_gac \
			"bin/${mydebug}/${PROJECT_NAME}.dll" \
			"${FILESDIR}/ClangSharp.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
