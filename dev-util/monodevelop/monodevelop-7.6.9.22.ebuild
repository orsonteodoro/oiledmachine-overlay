# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net40 net45 net46 net472"
IUSE="${USE_DOTNET} -aspnet-addin doc fsharp +git +gnome qtcurve +subversion"
REQUIRED_USE="^^ ( ${USE_DOTNET} ) fsharp? ( !net45 )"
# More libraries are listed in .gitmodules
# gtk-sharp version:
#   main/src/addins/MonoDevelop.GtkCore/MonoDevelop.GtkCore/ReferenceManager.cs
#   Line 158
# mono version: main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj #L239
# gnome-sharp version:
#   main/src/addins/MonoDevelop.GtkCore/MonoDevelop.GtkCore/ReferenceManager.cs
#   Line 158
# mono should have NET Standard 1.3 and .NET Framework 4.6
# nunit3 version:
# main/src/addins/MonoDevelop.UnitTesting.NUnit/NUnit3Runner/NUnit3Runner.csproj
#   Line 35
# nunit2 version:
#   main/src/addins/MonoDevelop.UnitTesting.NUnit/NUnitRunner/NUnitRunner.csproj
#   Line 20
# fsharp version:
# main/external/fsharpbinding/MonoDevelop.FSharpBinding/FSharpBinding.addin.xml
#   Line L213
# libgit2sharp version: .gitmodules #L19 (it was custom patched version)
# system-web-mvc version:
#   main/src/addins/AspNet/Templates/Mvc/WebConfigViews.xft.xml
#   Line 33
# xsp version: main/src/addins/AspNet/Execution/AspNetExecutionHandler.cs
#   Lines 40-48
# nuget version: github.com/mono/nuget-binary.git (master)
# nuget native is 4.3.1 but linux nuget is 2.8.7
#   dev-dotnet/cecil[gac] included in mono
# system-web-webpages is broken as a dependency of system-web-mvc due to
#   System.Net.Mail.SmtpClient removal so it is disabled
COMMON_DEPEND="
	aspnet-addin? ( >=dev-dotnet/system-web-mvc-5.2.3 )
	>=dev-dotnet/gtk-sharp-2.12.21:2
	>=dev-dotnet/libgit2sharp-0.26[gac]
	>=dev-dotnet/nuget-2.8.3
	dev-dotnet/referenceassemblies-pcl
	>=dev-lang/mono-4.6
	>=dev-util/nunit-3.0.1:3
	fsharp? ( >=dev-lang/fsharp-4.0.1.15 )
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )
	net-libs/libssh2
	|| ( dev-dotnet/cli-tools
		dev-dotnet/dotnetcore-sdk-bin )"
PV_MONODEV="${PV}"
RDEPEND="${COMMON_DEPEND}
	app-text/xmlstarlet
	app-arch/unzip
	dev-util/ctags
	!<dev-util/monodevelop-boo-$(ver_cut 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-database-$(ver_cut 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-debugger-gdb-$(ver_cut 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-debugger-mdb-$(ver_cut 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-java-$(ver_cut 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-vala-$(ver_cut 1-2 ${PV_MONODEV})
	doc? ( dev-util/mono-docbrowser )
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
	sys-apps/dbus[X]
	www-servers/xsp"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	>=dev-util/nunit-2.6.4:2
	sys-devel/gettext
	x11-misc/shared-mime-info
	x11-terms/xterm
	sys-apps/grep[pcre]
	virtual/pkgconfig"
inherit autotools fdo-mime gnome2-utils dotnet eutils git-r3
MAKEOPTS="${MAKEOPTS} -j1"
S="${WORKDIR}/${PN}-${PV}"
EGIT_COMMIT="monodevelop-${PV}" # the head of this tag
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_SUBMODULES=( '*' ) # TODO: Replace certain submodules with system packages.
# The himestamp is incremented by 1 min to make sure we don't exclude commit.
LAST_COMMIT_TIMESTAMP="Fri 05 Oct 2018 09:11:00 AM PDT"
# For deterministic build, we force using specific working commits instead of head.
EGIT_OVERRIDE_COMMIT_DATE_MONO_MONODEVELOP="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_DEBUGGER_LIBS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_GUIUNIT="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_LIBGIT_BINARY="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_LIBGIT2="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_LIBSSH2_LIBSSH2="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_LIBGIT2="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_LIBGIT2SHARP="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_XAMARIN_MACDOC="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_MDTESTHARNESS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_MONO_ADDINS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_MONO_TOOLS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_MONOMAC="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_MACCORE="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_ICSHARPCODE_NREFACTORY="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_NUGET_BINARY="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_REFACTORINGESSENTIALS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_SHARPSVN_BINARY="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_MONO_XWT="${LAST_COMMIT_TIMESTAMP}"

pkg_pretend() {
	# The sandbox won't allow us to download (or restore dependencies aka
	# fetch from nuget) beyond src_unpack.
	if has network-sandbox $FEATURES ; then
		die "${PN} require network-sandbox to be disabled in FEATURES."
	fi
}

pkg_setup() {
	ewarn \
"This ebuild is currently work-in-progress / in-development and will not\n\
work.  It's for ebuild/package developers to research or provide suggestions\n\
to get it to work."
	if use net472 ; then
		USE_DOTNET="net472" \
		FRAMEWORK="4.72" \
		dotnet_pkg_setup
	elif use net46 ; then
		USE_DOTNET="net46" \
		FRAMEWORK="4.6" \
		dotnet_pkg_setup
	elif use net45 ; then
		USE_DOTNET="net45" \
		dotnet_pkg_setup
	elif use net40 ; then
		USE_DOTNET="net40" \
		dotnet_pkg_setup
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	nuget restore "${S}"
	# LibGit2Sharp is now a system dependency.
	rm -rf "${S}/main/external/libgit2" || die
	rm -rf "${S}/main/external/libgit2sharp" || die
}

src_prepare() {
	default
	# Remove the git rev-parse (changelog?)
	sed -i '/<Exec.*rev-parse/ d' \
		"${S}/main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" \
		|| die
	# Set specific_version to prevent binding problem when gtk# 3 is
	# installed alongside gtk# 2.
	find "${S}" -name '*.csproj' -exec \
		sed -i 's#\
<SpecificVersion>.*</SpecificVersion>#\
<SpecificVersion>True</SpecificVersion>#' {} + || die

	# Bundled nuget is missing instead use the system NuGet.
	sed -i 's|mono .nuget/NuGet.exe|nuget|g' ./main/Makefile* || die

	# A fix for https://github.com/gentoo/dotnet/issues/42
	eapply \
	"${FILESDIR}/monodevelop-7.6.9.22-aspnet-template-references-fix.patch"
	use qtcurve && eapply \
		"${FILESDIR}/monodevelop-6.1.3.19-kill-qtcurve-warning.patch"

	use fsharp || eapply \
		"${FILESDIR}"/monodevelop-7.6.9.22-no-fsharp-check.patch
	sed -i "s|all: update_submodules all-recursive|all: all-recursive|g" \
		Makefile || die

	# Using the system Cecil.
	L=$(find . -name "*.csproj" -print0 \
		| grep -r -e "Mono.Cecil.csproj" \
		| grep ProjectReference \
		| sed -r -e "s|(.*csproj):.*|\1|g")
	for f in $L ; do
		sed -i \
	's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' \
			${f} || die
		xml ed -d \
	"//ProjectReference[contains(@Include,'Mono.Cecil.csproj')]" \
			${f} \
			| xml ed -s "/Project/ItemGroup[1]" \
				-t elem -name "Reference" \
			| xml ed -i \
				"/Project/ItemGroup[1]/Reference[last()]" \
				-t attr -n "Include" -v "Mono.Cecil" \
				> ${f}.1 || die
		xml ed -i "/Project" -t attr -n "xmlns" \
			-v "http://schemas.microsoft.com/developer/msbuild/2003" \
			${f}.1 > ${f} || die
	done

	# Using the system LibGit2Sharp.
	L=$(find . -name "*.csproj" -print0 \
		| grep -r -e "LibGit2Sharp.csproj" \
		| grep ProjectReference \
		| sed -r -e "s|(.*csproj):.*|\1|g")
	for f in $L ; do
		sed -i \
	's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' \
			${f} || die
		xml ed -d \
	"//ProjectReference[contains(@Include,'LibGit2Sharp.csproj')]" \
			${f} \
			| xml ed -s "/Project/ItemGroup[1]" \
				-t elem -name "Reference" \
			| xml ed -i "/Project/ItemGroup[1]/Reference[last()]" \
				-t attr -n "Include" -v "LibGit2Sharp" \
				> ${f}.1 || die
		xml ed -i "/Project" -t attr -n "xmlns" \
			-v "http://schemas.microsoft.com/developer/msbuild/2003" \
			${f}.1 > ${f} || die
	done

	# Don't build libgit2.
	local bd="main/src/addins/VersionControl/MonoDevelop.VersionControl.Git"
	local f="${bd}/MonoDevelop.VersionControl.Git.csproj"
	sed -i \
	's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' \
		${f} || die
	xml ed -d "//Target[contains(@Name,'BeforeBuild')]" ${f} > ${f}.1
	xml ed -i "/Project" -t attr -n "xmlns" \
		-v "http://schemas.microsoft.com/developer/msbuild/2003" \
		${f}.1 > ${f} || die

	if ! use aspnet-addin ; then
		rm -rf main/src/addins/AspNet || die
		sed -i -e "s|src/addins/AspNet/Makefile||g" \
			main/configure.ac || die
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|AspNet \\\r\n\t||' \
			main/src/addins/Makefile.am || die
	fi

	# Fix the restore.  The preview versions are not listed in nuget.
	L=$(grep -l -r -e "15.7.153-preview-g7d0635149a")
	for f in $L ; do
		sed -i -e "s|15.7.153-preview-g7d0635149a|15.8.525|g" "${f}" || die
	done

	L=$(grep -l -r -e "2.6.0-vs-for-mac-62303-01" ./)
	for f in $L ; do
		sed -i -e "s|2.6.0-vs-for-mac-62303-01|2.9.0-beta4-63001-02|g" "${f}"
	done

	# Remove the possibly deprecated and unlisted package.
	xml ed -d "//package[@id='Microsoft.VisualStudio.Text.Internal']" \
		main/src/core/MonoDevelop.Core/packages.config \
		> main/src/core/MonoDevelop.Core/packages.config.t || die
	mv main/src/core/MonoDevelop.Core/packages.config{.t,} || die
}

disable_sln_project() {
	local project_name="$1"
	local sln_path="$2"
	local uuid=$(grep -r \
		-e "\"FSharpBinding\", \"FSharpBinding\"" "${sln_path}" \
		| head -n 1 \
		| grep -o -P -e "{[0-9A-Z-]+}" \
		| tail -n 1 \
		| sed -e "s|[{}]||g")
	[[ -z "${uuid}" ]] && die "Can't find project"

	# {uuid1} = {uuid2}
	# {uuid2} = {uuid1}
	sed -i -r -e "s|\{[0-9A-Z-]+\} = \{${uuid}\}||g" "${sln_path}" || die
	sed -i -r -e "s|\{${uuid}\} = \{[0-9A-Z-]+\}||g" "${sln_path}" || die

	sed -i -r -e "s|\{${uuid}\}\..*||g" "${sln_path}" || die # {uuid}.Debug

	# Project
	# ...
	# EndProject
	sed -i -r -e "/Project.*${uuid}.*/,/EndProject/ s/.*//" || die
}

src_configure() {
        MCS=/usr/bin/dmcs CSC=/usr/bin/dmcs GMCS=/usr/bin/dmcs \
		./configure --prefix=/usr --profile=stable
	cd main
	# Environmental vars are added as the fix for
	# https://github.com/gentoo/dotnet/issues/29
	MCS=/usr/bin/dmcs CSC=/usr/bin/dmcs GMCS=/usr/bin/dmcs econf \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		--enable-monoextensions \
		--enable-gnomeplatform \
		$(use_enable subversion) \
		$(use_enable git)

	# Main.sln file is created on the fly during the previous econf call
	# that is why file is patched in src_configure instead of src_prepare.

	sed -i '/TextStylePolicy/d' "${S}/main/Main.sln" || die
	sed -i '/XmlFormattingPolicy/d' "${S}/main/Main.sln" || die
	if ! use fsharp ; then
		disable_sln_project "FSharpBinding" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.FSharp" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.FSharp.Shared" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.FSharp.Gui" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.FSharpInteractive.Service" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.FSharp.Tests" \
			"${S}/main/Main.sln"
	fi
	if ! use aspnet-addin ; then
		disable_sln_project "MonoDevelop.AspNet" \
			"${S}/main/Main.sln"
		disable_sln_project "MonoDevelop.AspNet.Tests" \
			"${S}/main/Main.sln"
	fi
	disable_sln_project "LibGit2Sharp" "${S}/main/Main.sln"

	# fix of https://github.com/gentoo/dotnet/issues/38
	sed -i -E -e 's#\
(EXE_PATH=")(.*)(/lib/monodevelop/bin/MonoDevelop.exe")#\
\1'${EPREFIX}'/usr\3#g' \
			"${S}/main/monodevelop.in" || die

	cd "${S}" || die
	sed -i -e "s|csc.exe|csc|g" \
		main/msbuild/MonoDevelop.BeforeCommon.targets || die
	sed -i -e 's|\$(MSBuildBinPath)\\..\\..\\..\\4.5\\|/usr/bin|g' \
		main/msbuild/MonoDevelop.BeforeCommon.targets || die

	# fixes main/MonoDevelop.props(10,2): error MSB4019: The imported
	# project "/usr/share/msbuild/15.0/Microsoft.Common.props" was not
	# found.
	local dotnet_folder_name="dotnet" # for cli-tools
	if [ -d /opt/dotnet_core ] ; then
		dotnet_folder_name="dotnet_core" # for dotnetcore-sdk-bin
	fi
	export MSBuildSDKsPath=$(\
		find /opt/${dotnet_folder_name}/sdk/[1-9]*/Sdks -maxdepth 0 \
			| sort | tail -n 1)
	export MSBuildExtensionsPath=$(\
		find /opt/${dotnet_folder_name}/sdk/[1-9]* -maxdepth 0 \
			| sort | tail -n 1)
}

src_compile() {
	default
}

src_install() {
	default
	dotnet_multilib_comply
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
