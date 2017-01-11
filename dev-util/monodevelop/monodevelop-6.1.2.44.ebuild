# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit fdo-mime gnome2-utils dotnet versionator eutils git-r3

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
USE_DOTNET="net45 net40"
IUSE="${USE_DOTNET} +subversion +git doc +gnome qtcurve fsharp"
REQUIRED_USE="^^ ( ${USE_DOTNET} ) fsharp? ( !net45 )"

COMMON_DEPEND="
	>=dev-lang/mono-3.2.8
	>=dev-dotnet/gtk-sharp-2.12.21:2
	>=dev-dotnet/nuget-2.8.7
	>=dev-dotnet/system-web-mvc-5.2.3
	>=dev-dotnet/icsharpcode-nrefactory-bin-5.5.1
	>=dev-util/nunit-3.0.1:3
	fsharp? ( >=dev-lang/fsharp-4.0.1.15 )
        dev-dotnet/gdk-sharp:3
        dev-dotnet/cecil[gac]
	dev-dotnet/referenceassemblies-pcl
	net-libs/libssh2
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )
	>=dev-dotnet/libgit2sharp-0.22[gac,monodevelop]"
RDEPEND="${COMMON_DEPEND}
	dev-util/ctags
	sys-apps/dbus[X]
	>=www-servers/xsp-2
	doc? ( dev-util/mono-docbrowser )
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${COMMON_DEPEND}
	>=dev-util/mono-packaging-tools-0.1.3_p2016082301-r1[gac]
	>=dev-util/nunit-2.6.4:2
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info
	x11-terms/xterm
	app-arch/unzip"

MAKEOPTS="${MAKEOPTS} -j1" #nowarn
S="${WORKDIR}/${PN}-${PV}"

EGIT_COMMIT="0ccfcd52b95305ebd5b7eca0d88c1017035910ae"
EGIT_REPO_URI="git://github.com/mono/monodevelop.git"
EGIT_SUBMODULES=( '*' ) # todo: replace certain submodules with system packages

src_prepare() {
	if use net45 ; then
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
	gnome2_src_prepare
	# Remove the git rev-parse (changelog?)
	sed -i '/<Exec.*rev-parse/ d' "${S}/main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" || die
	# Set specific_version to prevent binding problem
	# when gtk#-3 is installed alongside gtk#-2
	find "${S}" -name '*.csproj' -exec sed -i 's#<SpecificVersion>.*</SpecificVersion>#<SpecificVersion>True</SpecificVersion>#' {} + || die

	# bundled nuget is missing => use system nuget.
	sed -i 's|mono .nuget/NuGet.exe|nuget|g' ./main/Makefile* || die

	# fix for https://github.com/gentoo/dotnet/issues/42
	eapply "${FILESDIR}/monodevelop-6.1.3.19-aspnet-template-references-fix.patch"
	use gnome || eapply "${FILESDIR}/monodevelop-6.1.3.19-kill-gnome.patch" \
                  && eapply "${FILESDIR}/monodevelop-6.1.2.44-kill-gnome.patch"
	use qtcurve && eapply "${FILESDIR}/monodevelop-6.1.3.19-kill-qtcurve-warning.patch"

	# copy missing binaries
	#mkdir -p "${S}"/main/external/cecil/Test/libs/nunit-2.5.10/ || die
	#cp -fR "${T}"/NUnit-2.5.10.11092/bin/net-2.0/framework/* "${S}"/main/external/cecil/Test/libs/nunit-2.5.10/ || die

	sed -i 's=0.9.5.4=0.9.6.20160209=g' ./main/contrib/ICSharpCode.Decompiler/packages.config

	use fsharp || eapply "${FILESDIR}"/monodevelop-6.1.3.19-no-fsharp-check.patch
	sed -i "s|all: update_submodules all-recursive|all: all-recursive|g" Makefile

	eapply "${FILESDIR}/monodevelop-6.1.2.44-cecil-1.patch"
	eapply "${FILESDIR}/monodevelop-6.1.2.44-cecil-2.patch"
	eapply "${FILESDIR}/monodevelop-6.1.2.44-libgit2sharp.patch"
	eapply "${FILESDIR}/monodevelop-6.1.2.44-no-build-libgit2.patch"

	eapply "${FILESDIR}/fsharp-shared-tooltips-tooltip.patch"

	sed -i -e "s|XBUILD_ARGS=|XBUILD_ARGS=/p:TargetFrameworkVersion=v${EBF} |g" ./main/xbuild.include || die
	sed -i -e "s|XBUILD_ARGS=|XBUILD_ARGS=/p:TargetFrameworkVersion=v${EBF} |g" ./main/external/mono-addins/xbuild.include || die

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
	/usr/bin/mpt-sln --sln-file="${S}/main/Main.sln" --remove-proj="LibGit2Sharp" || die

	# add verbosity into package restoring
	# actually this will printout stacktraces without usefull facts
	# sed -i -E -e 's#nuget restore#nuget restore -verbosity detailed#g' "${S}/Makefile" || die

	# fix of https://github.com/gentoo/dotnet/issues/38
	sed -i -E -e 's#(EXE_PATH=")(.*)(/lib/monodevelop/bin/MonoDevelop.exe")#\1'${EPREFIX}'/usr\3#g' "${S}/main/monodevelop.in" || die
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
