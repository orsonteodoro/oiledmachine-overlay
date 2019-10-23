# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Command line utilities for packaging mono assemblies with portage"
HOMEPAGE="http://arsenshnurkov.github.io/mono-packaging-tools"
LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"
USE_DOTNET="net45"
# debug = debug configuration (symbols and defines for debugging)
# test = allow NUnit tests to run
# developer = generate symbols information (to view line numbers in stack traces,
#		either in debug or release configuration)
# aot = compile to machine code and store to disk during install, to save time later
#		during startups
# nupkg = create .nupkg file from .nuspec
# gac = install into gac
# pkg-config = register in pkg-config database
IUSE="+${USE_DOTNET} debug +developer test +aot doc"
TOOLS_VERSION=14.0
COMMON_DEPENDENCIES="|| ( >=dev-lang/mono-4.2 <dev-lang/mono-9999 )
	dev-dotnet/mono-options[gac]
	>=dev-dotnet/slntools-1.1.3_p201508170-r1[gac]
	>=dev-dotnet/eto-parse-1.4.0[gac]"
DEPEND="${COMMON_DEPENDENCIES}
	dev-dotnet/msbuildtasks
	sys-apps/sed"
RDEPEND="${COMMON_DEPENDENCIES}	"
SLOT="0/${PV}"
NAME="mono-packaging-tools"
REPOSITORY_URL="https://github.com/ArsenShnurkov/${NAME}"
LICENSE_URL=\
"https://raw.githubusercontent.com/ArsenShnurkov/mono-packaging-tools/master/LICENSE"
NUSPEC_VERSION=${PV%_p*}
ASSEMBLY_VERSION=${PV%_p*}
SLN_FILE="mono-packaging-tools.sln"
METAFILETOBUILD="${S}/${SLN_FILE}"
NUSPEC_ID="${NAME}"
COMMIT_DATE="$(ver_cut 5 ${PV})"
NUSPEC_FILENAME="${PN}.nuspec"
#ICON_FILENAME="${PN}.png"
#ICON_FINALNAME="${NUSPEC_ID}.${NUSPEC_VERSION}.png"
#ICON_PATH="$(get_nuget_trusted_icons_location)/${ICON_FINALNAME}"
inherit dotnet nupkg
EGIT_COMMIT="2b56244890554778a78c82f685610f31e5ee760f"
SRC_URI="${REPOSITORY_URL}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PVR}.tar.gz"
inherit gac
S="${WORKDIR}/${NAME}-${EGIT_COMMIT}"

install_tool() {
	DIR=$(usex debug "Debug" "Release")
	# installs .exe, .exe.config (if any), .mdb (if exists)
	doins "$1"/bin/${DIR}/*.exe
	if [ -f "$1"/bin/${DIR}/*.exe.config ]; then
		doins "$1"/bin/${DIR}/*.exe.config
	fi
	if use developer; then
		doins "$1"/bin/${DIR}/*.pdb
	fi
	local debug_arg=$(usex debug "--debug" "")
	make_wrapper "$1" \
	  "/usr/bin/mono ${debug_arg} /usr/share/${PN}/slot-${SLOT}/$1.exe"
}

src_prepare() {
	#change version in .nuspec
	# PV = Package version (excluding revision, if any), for example 6.3.
	# It should reflect the upstream versioning scheme
	sed "s/@VERSION@/${NUSPEC_VERSION}/g" \
		"${FILESDIR}/${NUSPEC_ID}.nuspec" >"${S}/${NUSPEC_ID}.nuspec" || die
	# restoring is not necessary after switching to GAC references
	# enuget_restore "${METAFILETOBUILD}"
	default
	estrong_assembly_info "using System.Runtime.CompilerServices;" \
		"${DISTDIR}/mono.snk" "AssemblyInfo.cs"
}

src_compile() {
	exbuild /p:VersionNumber="${ASSEMBLY_VERSION}" "${METAFILETOBUILD}"
	enuspec "${NUSPEC_ID}.nuspec"
}

src_install() {
	local p="/usr/$(get_libdir)/mono/${PN}"
	insinto "${p}/slot-${SLOT}"
	DIR=$(usex debug "Debug" "Release")
	doins mpt-core/bin/${DIR}/mpt-core.dll
	dosym slot-${SLOT}/mpt-core.dll ${p}/mpt-core.dll
	einstall_pc_file ${PN} ${ASSEMBLY_VERSION} mpt-core
	insinto "/usr/share/${PN}/slot-${SLOT}"
	install_tool mpt-gitmodules
	install_tool mpt-sln
	install_tool mpt-csproj
	install_tool mpt-machine
	install_tool mpt-nuget
	enupkg "${WORKDIR}/${NUSPEC_ID}.${NUSPEC_VERSION}.nupkg"
	use doc && dodoc README.md
	egacinstall "mpt-core/bin/${DIR}/mpt-core.dll"
}
