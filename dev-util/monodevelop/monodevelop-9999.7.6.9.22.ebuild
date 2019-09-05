# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools fdo-mime gnome2-utils dotnet versionator eutils git-r3

ROSLYN_COMMIT="16e117c2400d0ab930e7d89512f9894a169a0e6e"

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"
#SRC_URI="https://github.com/mono/monodevelop/archive/${P}.tar.gz
#	 https://launchpadlibrarian.net/68057829/NUnit-2.5.10.11092.zip
#         https://github.com/mono/roslyn/archive/${ROSLYN_COMMIT}.zip -> roslyn-${ROSLYN_COMMIT}.zip
#"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net40 net45 net46 net472"
IUSE="${USE_DOTNET} -aspnet-addin doc fsharp +git +gnome qtcurve +subversion"
REQUIRED_USE="^^ ( ${USE_DOTNET} ) fsharp? ( !net45 )"

# More libraries are listed in .gitmodules
# gtk-sharp version: main/src/addins/MonoDevelop.GtkCore/MonoDevelop.GtkCore/ReferenceManager.cs #L158
# mono version: main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj #L239
# gnome-sharp version: main/src/addins/MonoDevelop.GtkCore/MonoDevelop.GtkCore/ReferenceManager.cs #L158
# mono should have NET Standard 1.3 and .NET Framework 4.6
# nunit3 version: main/src/addins/MonoDevelop.UnitTesting.NUnit/NUnit3Runner/NUnit3Runner.csproj #L35
# nunit2 version: main/src/addins/MonoDevelop.UnitTesting.NUnit/NUnitRunner/NUnitRunner.csproj #L20
# fsharp version: main/external/fsharpbinding/MonoDevelop.FSharpBinding/FSharpBinding.addin.xml #L213
# libgit2sharp version: .gitmodules #L19 (it was custom patched version)
# system-web-mvc version: main/src/addins/AspNet/Templates/Mvc/WebConfigViews.xft.xml #L33
# xsp version: main/src/addins/AspNet/Execution/AspNetExecutionHandler.cs #L40-48
# nuget version: github.com/mono/nuget-binary.git (master)
# nuget native is 4.3.1 but linux nuget is 2.8.7
#        dev-dotnet/cecil[gac] included in mono

# system-web-webpages is broken as a dependency of system-web-mvc due to System.Net.Mail.SmtpClient removal so it is disabled
COMMON_DEPEND="
	>=dev-lang/mono-4.6
	>=dev-dotnet/gtk-sharp-2.12.21:2
	>=dev-dotnet/nuget-2.8.3
	aspnet-addin? ( >=dev-dotnet/system-web-mvc-5.2.3 )
	>=dev-util/nunit-3.0.1:3
	fsharp? ( >=dev-lang/fsharp-4.0.1.15 )
	net-libs/libssh2
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )
	>=dev-dotnet/libgit2sharp-0.26[gac]
	dev-dotnet/referenceassemblies-pcl
	|| ( dev-dotnet/cli-tools dev-dotnet/dotnetcore-sdk-bin )
"
#        dev-dotnet/gdk-sharp:3
PV_MONODEV="${PV//9999./}"
RDEPEND="${COMMON_DEPEND}
	dev-util/ctags
	sys-apps/dbus[X]
	www-servers/xsp
	doc? ( dev-util/mono-docbrowser )
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2 ${PV_MONODEV})
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2 ${PV_MONODEV})"
DEPEND="${COMMON_DEPEND}
	>=dev-util/mono-packaging-tools-1.4.3
	>=dev-util/nunit-2.6.4:2
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info
	x11-terms/xterm
	app-arch/unzip
	app-text/xmlstarlet"

#	|| ( >=dev-dotnet/icsharpcode-nrefactory-bin-5.5.1 dev-dotnet/icsharpcode-nrefactory )
#	>=dev-util/mono-packaging-tools-0.1.3_p2016082301-r1[gac]

MAKEOPTS="${MAKEOPTS} -j1" #nowarn
S="${WORKDIR}/${PN}-${PV}"

#EGIT_COMMIT="0a0ba3c4593e9adb1c6ff6324e641036146af376" #refers to tagged commit of ${PV} (It may break for clean install.  Use 9999.${PV} to fetch then cancel it after fetching the sources. Then, use this ebuild again.)
EGIT_COMMIT="monodevelop-${PV//9999./}" # the head of this tag
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_SUBMODULES=( '*' ) # todo: replace certain submodules with system packages

_git_checkout_submodule() {
	cd "${S}/$1"
	git checkout $2
}

monodevelop_git_checkout_submodule() {
	# For determinism, we force using specific working commits instead of head.
	# Snapshot of commits collected as of 20190903
	_git_checkout_submodule "main/external/debugger-libs" "cd477ba951d50b6f2f56dcf107a2f16fed18bfd6"
	_git_checkout_submodule "main/external/guiunit" "dd094e78b49d90873a5f62acb48a4843e7845fe7"
	_git_checkout_submodule "main/external/libgit-binary" "d8b2acad2fdb0f6cc8823f8dc969576f1962f6a2"
	_git_checkout_submodule "main/external/libgit-binary/external/libgit2" "e8b8948f5a07cd813ccad7b97490b7f040d364c4"
	_git_checkout_submodule "main/external/libgit-binary/external/libssh2" "418be878ad3ffbe90d85e3905096add9592a1fa1"
	_git_checkout_submodule "main/external/libgit2" "e8b8948f5a07cd813ccad7b97490b7f040d364c4"
	_git_checkout_submodule "main/external/libgit2sharp" "319fa363ef12bba42680d880ac00a127d335fb49"
	_git_checkout_submodule "main/external/macdoc" "09751517e1fa5fae9ca38369fdfcdbe27122a9dd"
	_git_checkout_submodule "main/external/mdtestharness" "424f53e08c48dee8accaa68820b1cd7147cf1ba4"
	_git_checkout_submodule "main/external/mono-addins" "293cbf213be1ac0ec36c52d143c58bda2f95e494"
	_git_checkout_submodule "main/external/mono-tools" "d858f5f27fa8b10d734ccce7ffba631b995093e5"
	_git_checkout_submodule "main/external/monomac" "1d878426361aea31f9e31b509783703fbd797c8c"
	_git_checkout_submodule "main/external/monomac/maccore" "ef6a975d648137cad41050d11493a7820a28f93a"
	_git_checkout_submodule "main/external/nrefactory" "0607a4ad96ebdd16817e47dcae85b1cfcb5b5bf5"
	_git_checkout_submodule "main/external/nuget-binary" "ebedbf8b90e2f138fa9bc120807abced307fbfb4"
	_git_checkout_submodule "main/external/RefactoringEssentials" "0148f6ad41ce4a53f8d44ad9a3be2eb6f4d9dc22"
	_git_checkout_submodule "main/external/sharpsvn-binary" "6e60e6156aec55789404f04215d2b67ce6047c6a"
	_git_checkout_submodule "main/external/xwt" "f3e63c35fa8dfe62aaa4385a6a3ea48cb0ebb01b"
}

pkg_pretend() {
	# the sandbox won't allow us to use dotnet restore properly so sandbox restrictions must be dropped
	#if has sandbox $FEATURES || has usersandbox $FEATURES || has network-sandbox $FEATURES ; then
	if has network-sandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox and network-sandbox to be disabled in FEATURES."
	fi
}

pkg_setup() {
	ewarn "This ebuild is currently work-in-progress / in-development and will not work.  for ebuild/package developers to research or provide suggestions to get it to work."
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
	#cd "${T}"
	#unpack NUnit-2.5.10.11092.zip

	#cd "${WORKDIR}"
	#unpack "${P}.tar.gz"

	git-r3_fetch
	git-r3_checkout
	nuget restore "${S}"

	monodevelop_git_checkout_submodule

	# LibGit2Sharp is now portage dependency
	rm -rf "${S}/main/external/libgit2" || die
	rm -rf "${S}/main/external/libgit2sharp" || die

	# roslyn dlls are missing from monodevelop tarball
	#cd "${S}/main/external"
	#unpack "roslyn-${ROSLYN_COMMIT}.zip"
	#rm -rf "roslyn"
	#mv "roslyn-${ROSLYN_COMMIT}" "roslyn"
}

src_prepare() {
	# Remove the git rev-parse (changelog?)
	sed -i '/<Exec.*rev-parse/ d' "${S}/main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" || die
	# Set specific_version to prevent binding problem
	# when gtk#-3 is installed alongside gtk#-2
	find "${S}" -name '*.csproj' -exec sed -i 's#<SpecificVersion>.*</SpecificVersion>#<SpecificVersion>True</SpecificVersion>#' {} + || die

	# bundled nuget is missing => use system nuget.
	sed -i 's|mono .nuget/NuGet.exe|nuget|g' ./main/Makefile* || die

	# fix for https://github.com/gentoo/dotnet/issues/42
	eapply "${FILESDIR}/monodevelop-7.6.9.22-aspnet-template-references-fix.patch"
	use qtcurve && eapply "${FILESDIR}/monodevelop-6.1.3.19-kill-qtcurve-warning.patch"

	# copy missing binaries
	#mkdir -p "${S}"/main/external/cecil/Test/libs/nunit-2.5.10/ || die
	#cp -fR "${T}"/NUnit-2.5.10.11092/bin/net-2.0/framework/* "${S}"/main/external/cecil/Test/libs/nunit-2.5.10/ || die

	use fsharp || eapply "${FILESDIR}"/monodevelop-7.6.9.22-no-fsharp-check.patch
	sed -i "s|all: update_submodules all-recursive|all: all-recursive|g" Makefile || die

	# use the system cecil
	L=$(find . -name "*.csproj" -print0 | grep -r -e "Mono.Cecil.csproj" | grep ProjectReference | sed -r -e "s|(.*csproj):.*|\1|g")
	for f in $L ; do
		sed -i 's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' ${f} || die
		xml ed -d "//ProjectReference[contains(@Include,'Mono.Cecil.csproj')]" ${f} | \
			xml ed -s "/Project/ItemGroup[1]" -t elem -name "Reference" | \
			xml ed -i "/Project/ItemGroup[1]/Reference[last()]" -t attr -n "Include" -v "Mono.Cecil" > ${f}.1 || die
		xml ed -i "/Project" -t attr -n "xmlns" -v "http://schemas.microsoft.com/developer/msbuild/2003" ${f}.1 > ${f} || die
	done

	# use the system LibGit2Sharp
	L=$(find . -name "*.csproj" -print0 | grep -r -e "LibGit2Sharp.csproj" | grep ProjectReference | sed -r -e "s|(.*csproj):.*|\1|g")
	for f in $L ; do
		sed -i 's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' ${f} || die
		xml ed -d "//ProjectReference[contains(@Include,'LibGit2Sharp.csproj')]" ${f} | \
			xml ed -s "/Project/ItemGroup[1]" -t elem -name "Reference" | \
			xml ed -i "/Project/ItemGroup[1]/Reference[last()]" -t attr -n "Include" -v "LibGit2Sharp" > ${f}.1 || die
		xml ed -i "/Project" -t attr -n "xmlns" -v "http://schemas.microsoft.com/developer/msbuild/2003" ${f}.1 > ${f} || die
	done

	# don't build libgit2
	local f="main/src/addins/VersionControl/MonoDevelop.VersionControl.Git/MonoDevelop.VersionControl.Git.csproj"
	sed -i 's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' ${f} || die
	xml ed -d "//Target[contains(@Name,'BeforeBuild')]" ${f} > ${f}.1
	xml ed -i "/Project" -t attr -n "xmlns" -v "http://schemas.microsoft.com/developer/msbuild/2003" ${f}.1 > ${f} || die

	#eapply "${FILESDIR}/monodevelop-6.1.2.44-refs-1.patch"

	if ! use aspnet-addin ; then
		rm -rf main/src/addins/AspNet || die
		sed -i -e "s|src/addins/AspNet/Makefile||g" main/configure.ac || die
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|AspNet \\\r\n\t||' main/src/addins/Makefile.am || die
	fi

	# fix restore.  The preview versions are not listed in nuget
	L=$(grep -l -r -e "15.7.153-preview-g7d0635149a")
	for f in $L ; do
		sed -i -e "s|15.7.153-preview-g7d0635149a|15.8.525|g" "${f}" || die
	done

	L=$(grep -l -r -e "2.6.0-vs-for-mac-62303-01" ./)
	for f in $L ; do
		sed -i -e "s|2.6.0-vs-for-mac-62303-01|2.9.0-beta4-63001-02|g" "${f}"
	done

	# remove possibly deprecated and unlisted package
	xml ed -d "//package[@id='Microsoft.VisualStudio.Text.Internal']" main/src/core/MonoDevelop.Core/packages.config > main/src/core/MonoDevelop.Core/packages.config.t || die
	mv main/src/core/MonoDevelop.Core/packages.config{.t,} || die

	eapply "${FILESDIR}/monodevelop-7.6.9.22-no-msbuild-restore-for-refactoringessentials.patch"

	eapply_user
}

src_configure() {
        MCS=/usr/bin/dmcs CSC=/usr/bin/dmcs GMCS=/usr/bin/dmcs \
		./configure --prefix=/usr --profile=stable
	cd main
	# env vars are added as the fix for https://github.com/gentoo/dotnet/issues/29
	MCS=/usr/bin/dmcs CSC=/usr/bin/dmcs GMCS=/usr/bin/dmcs econf \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		--enable-monoextensions \
		--enable-gnomeplatform \
		$(use_enable subversion) \
		$(use_enable git)

	# Main.sln file is created on the fly during the previous econf call
	# that is why file is patched in src_configure instead of src_prepare

	sed -i '/TextStylePolicy/d' "${S}/main/Main.sln" || die
	sed -i '/XmlFormattingPolicy/d' "${S}/main/Main.sln" || die
	if ! use fsharp ; then
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="FSharpBinding" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.FSharp" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.FSharp.Shared" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.FSharp.Gui" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.FSharpInteractive.Service" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.FSharp.Tests" || die
	fi
	if ! use aspnet-addin ; then
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.AspNet" || die
		/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="MonoDevelop.AspNet.Tests" || die
	fi
	/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="LibGit2Sharp" || die

	# fix of https://github.com/gentoo/dotnet/issues/38
	sed -i -E -e 's#(EXE_PATH=")(.*)(/lib/monodevelop/bin/MonoDevelop.exe")#\1'${EPREFIX}'/usr\3#g' "${S}/main/monodevelop.in" || die

	cd "${S}" || die
	sed -i -e "s|csc.exe|csc|g" main/msbuild/MonoDevelop.BeforeCommon.targets || die
	sed -i -e 's|\$(MSBuildBinPath)\\..\\..\\..\\4.5\\|/usr/bin|g' main/msbuild/MonoDevelop.BeforeCommon.targets || die

	# gets dynamically generated or pulled in the restore phase
	#sed -i -e 's|\$(MSBuildThisFileDirectory)..\\tools|/usr/bin|g' main/external/fsharpbinding/packages/Microsoft.Net.Compilers/build/Microsoft.Net.Compilers.props || die
	#sed -i -e "s|csc.exe|csc|g" main/external/fsharpbinding/packages/Microsoft.Net.Compilers/build/Microsoft.Net.Compilers.props || die
	#sed -i -e "s|vbc.exe|vbc|g" main/external/fsharpbinding/packages/Microsoft.Net.Compilers/build/Microsoft.Net.Compilers.props || die

	local dotnet_folder_name="dotnet" # for cli-tools
	if [ -d /opt/dotnet_core ] ; then
		dotnet_folder_name="dotnet_core" # for dotnetcore-sdk-bin
	fi
	export MSBuildSDKsPath=$(find /opt/${dotnet_folder_name}/sdk/[1-9]*/Sdks -maxdepth 0 | sort | tail -n 1)
	export MSBuildExtensionsPath=$(find /opt/${dotnet_folder_name}/sdk/[1-9]* -maxdepth 0 | sort | tail -n 1)
}

src_compile() {
	addpredict /etc/mono/registry/last-btime
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
