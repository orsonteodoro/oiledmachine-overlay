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
	|| ( >=dev-dotnet/icsharpcode-nrefactory-bin-5.5.1 dev-dotnet/icsharpcode-nrefactory )
	>=dev-util/nunit-3.0.1:3
	fsharp? ( >=dev-lang/fsharp-4.0.1.15 )
        dev-dotnet/cecil[gac]
	net-libs/libssh2
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )
	>=dev-dotnet/libgit2sharp-0.22[gac,monodevelop]
	dev-dotnet/referenceassemblies-pcl
"
#        dev-dotnet/gdk-sharp:3
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

#EGIT_COMMIT="0ccfcd52b95305ebd5b7eca0d88c1017035910ae" #6.1.2.44
EGIT_COMMIT="monodevelop-6.1.2.44" #6.1.2.44 (It doesn't break, but it is head for this tag.)
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_SUBMODULES=( '*' ) # todo: replace certain submodules with system packages

_git_checkout_submodule() {
	cd "${S}/$1"
	git checkout $2
}

monodevelop_git_checkout_submodule() {
	#for determinism.  we force using specific working commits instead of head
	#snapshot of commits collected as of 20170804
	_git_checkout_submodule "main/external/RefactoringEssentials" "cbd2d9e1da8a1c39e98397270990a39b86a7709e"
	_git_checkout_submodule "main/external/cecil" "cd2ff63081bd9f65cb293689fa9697cf25ae8c95"
	_git_checkout_submodule "main/external/debugger-libs" "4a74b2cc980df13e5c4076266e66d305ada41cb3"
	_git_checkout_submodule "main/external/guiunit" "2670780396856f043ab5cea9ab856641f56de5ae"
	_git_checkout_submodule "main/external/ikvm" "94d4a298ad560f8674d746dea2d51e26e0a97f2a"
	_git_checkout_submodule "main/external/libgit-binary" "d8b2acad2fdb0f6cc8823f8dc969576f1962f6a2"
	_git_checkout_submodule "main/external/libgit2" "e8b8948f5a07cd813ccad7b97490b7f040d364c4"
	_git_checkout_submodule "main/external/libgit2sharp" "06bbc96251eea534ed66a32e8f2e2edaaa903077"
	_git_checkout_submodule "main/external/macdoc" "eacb7e0d61dec7b3b95a585aaab98fe910b46f6d"
	_git_checkout_submodule "main/external/mdtestharness" "424f53e08c48dee8accaa68820b1cd7147cf1ba4"
	_git_checkout_submodule "main/external/mono-addins" "76cab2dcea207465b2d5d41d88f3f9929da4614d"
	_git_checkout_submodule "main/external/mono-tools" "d858f5f27fa8b10d734ccce7ffba631b995093e5"
	_git_checkout_submodule "main/external/monomac" "1d878426361aea31f9e31b509783703fbd797c8c"
	_git_checkout_submodule "main/external/nrefactory" "a2b55de351be2119b6f0c3a17c36b5b9adbd7c59"
	_git_checkout_submodule "main/external/nuget-binary" "0811ba888a80aaff66a93a4c98567ce904ab2663"
	_git_checkout_submodule "main/external/roslyn" "16e117c2400d0ab930e7d89512f9894a169a0e6e"
	_git_checkout_submodule "main/external/sharpsvn-binary" "6e60e6156aec55789404f04215d2b67ce6047c6a"
	_git_checkout_submodule "main/external/xwt" "9ee2853a1f3d3afeb9bd35044ba44433036cddb0"
}

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

	#eapply "${FILESDIR}/monodevelop-6.1.2.44-refs-1.patch"

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
