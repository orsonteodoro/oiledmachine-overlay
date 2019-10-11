# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Validator.nu HTML Parser, a HTML5 parser, port from Java Version 1.4 to C#"
HOMEPAGE="https://archive.codeplex.com/?p=slntools"
LICENSE="MIT" # https://github.com/jamietre/HtmlParserSharp/blob/master/LICENSE.txt
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
# cli = do install command line interface
IUSE="${USE_DOTNET} developer gac nupkg debug cli"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg"
DEPEND="${RDEPEND}
	sys-apps/sed"
inherit dotnet nupkg
NAME="slntools"
EGIT_COMMIT="03089e380ed240680834bc6444116b9888715461"
SRC_URI="https://github.com/mtherien/slntools/archive/${EGIT_COMMIT}.tar.gz -> ${PF}.tar.gz"
inherit gac
SLOT=0
RESTRICT="mirror"
S="${WORKDIR}/${NAME}-${EGIT_COMMIT}"
SLN_FILE=SLNTools.sln
METAFILETOBUILD="${S}/${SLN_FILE}"

src_prepare() {
	eapply "${FILESDIR}/slntools-1.1.3_p20180912-remove-wix-project-from-sln-file.patch"

	# System.EntryPointNotFoundException: GetStdHandle
	#   at (wrapper managed-to-native) CWDev.SLNTools.CommandLine.Parser:GetStdHandle (int)
	#   at CWDev.SLNTools.CommandLine.Parser.GetConsoleWindowWidth () [0x00000] in <filename unknown>:0 
	#   at CWDev.SLNTools.CommandLine.Parser.ArgumentsUsage (System.Type argumentType) [0x00000] in <filename unknown>:0 
	#   at CWDev.SLNTools.Program.Main (System.String[] args) [0x00000] in <filename unknown>:0 
	# http://stackoverflow.com/questions/23824961/c-sharp-to-mono-getconsolewindow-exception
	eapply -p2 "${FILESDIR}/console-window-width.patch"

	# no need to restore if all dependencies are from GAC
	# nuget restore "${METAFILETOBUILD}" || die

	default
}

src_compile() {
	exbuild /p:Configuration=$(usex debug "Debug" "Release")
		/p:DebugSymbols=$(usex developer "True" "False")
		${ARGS} \
		${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
		${METAFILETOBUILD}

	if use nupkg; then
		nuget pack "${FILESDIR}/slntools-1.1.3_p20180912-${SLN_FILE}.nuspec" -Properties $(usex debug "Configuration=Debug" "Configuration=Release") -BasePath "${S}" -OutputDirectory "${WORKDIR}" -NonInteractive -Verbosity detailed
	fi
}

src_install() {
	default

	DIR=""
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	insinto "/usr/share/slntools/"

	doins SLNTools.exe/bin/${DIR}/CWDev.SLNTools.Core.dll
	if use developer; then
		doins SLNTools.exe/bin/${DIR}/CWDev.SLNTools.Core.dll.mdb
	fi
	einfo "Strong signing dll again"
	estrong_resign SLNTools.exe/bin/${DIR}/CWDev.SLNTools.Core.dll "${DISTDIR}"/mono.snk
	einfo "GAC install"
	egacinstall SLNTools.exe/bin/${DIR}/CWDev.SLNTools.Core.dll

	if use cli; then
		doins SLNTools.exe/bin/${DIR}/CWDev.SLNTools.UIKit.dll
		doins SLNTools.exe/bin/${DIR}/SLNTools.exe
		if use developer; then
			doins SLNTools.exe/bin/${DIR}/CWDev.SLNTools.UIKit.dll.mdb
			doins SLNTools.exe/bin/${DIR}/SLNTools.exe.mdb
		fi
		make_wrapper slntools "mono /usr/share/slntools/SLNTools.exe"
	fi

	if use nupkg; then
		if [ -d "/var/calculate/remote/distfiles" ]; then
			# Control will enter here if the directory exist.
			# this is necessary to handle calculate linux profiles feature (for corporate users)
			elog "Installing .nupkg into /var/calculate/remote/packages/NuGet"
			insinto /var/calculate/remote/packages/NuGet
		else
			# this is for all normal gentoo-based distributions
			elog "Installing .nupkg into /usr/local/nuget/nupkg"
			insinto /usr/local/nuget/nupkg
		fi
		doins "${WORKDIR}/SLNTools.1.1.3.nupkg"
	fi

	dotnet_multilib_comply
}
