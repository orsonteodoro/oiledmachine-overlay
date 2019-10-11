# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Clang bindings for .NET and Mono written in C#"
HOMEPAGE="https://github.com/Microsoft/ClangSharp"
LICENSE="UIUC"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="ClangSharp"
SLOT="0"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND="media-gfx/mojoshader"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
EGIT_COMMIT="9b5f81a1ac7f0348f8ff82d041d57c3bf36bbe65"
SRC_URI="https://github.com/Microsoft/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	sed -i -e "s|libclang|libclang.dll|g" ./ClangSharpPInvokeGenerator/Generated.cs
}

src_compile() {
	cd "${S}"
	exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
		insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/bin/${mydebug}/ClangSharp.dll.mdb"
        done

	eend

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins ClangSharpPInvokeGenerator/bin/Release/ClangSharpPInvokeGenerator.exe

        FILES=$(find "${D}" -name "ClangSharp.dll")
        for f in $FILES
        do
		cp -a "${FILESDIR}/ClangSharp.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
