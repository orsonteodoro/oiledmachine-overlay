# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Nuget - .NET Package Manager"
HOMEPAGE="http://nuget.codeplex.com"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
SLOT="0"
DEPEND=">=dev-lang/mono-3.2.3
	<=dev-dotnet/xdt-for-monodevelop-2.8.2[gac]
	 !dev-dotnet/nuget-codeplex
	  app-misc/ca-certificates"
RDEPEND="${DEPEND}"
inherit dotnet eutils
# This ebuild provides a forked version of nuget modified to work with MonoDevelop.
# See https://bugzilla.xamarin.com/show_bug.cgi?id=27693
# dev-dotnet/nuget-codeplex provides the upstream version.
SRC_URI="https://github.com/mrward/nuget/archive/Release-${PV}-MonoDevelop.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/nuget-Release-${PV}-MonoDevelop"

pkg_setup() {
	dotnet_pkg_setup
	cert-sync /etc/ssl/certs/ca-certificates.crt

        if has sandbox $FEATURES || has usersandbox $FEATURES ; then
                die "${PN} require sandbox and usersandbox to be disabled in FEATURES on a per-package basis."
        fi
        if has network-sandbox $FEATURES ; then
                die "${PN} require network-sandbox to be disabled in FEATURES on a per-package basis."
        fi
}

src_prepare() {
	default
	sed -i -e 's@RunTests@ @g' "${S}/Build/Build.proj" || die
	cp "${FILESDIR}/rsa-4096.snk" "${S}/src/Core/" || die
	eapply "${FILESDIR}/add-keyfile-option-to-csproj-r2.patch"
	sed -i -E -e "s#(\[assembly: InternalsVisibleTo(.*)\])#/* \1 */#g" "src/Core/Properties/AssemblyInfo.cs" || die
	eapply "${FILESDIR}/strongnames-for-ebuild-2.8.1-r2.patch"
}

src_configure() {
	export EnableNuGetPackageRestore="true"
}

src_compile() {
#	xbuild Build/Build.proj /p:Configuration=Release /p:TreatWarningsAsErrors=false /tv:4.0 /p:TargetFrameworkVersion="v${FRAMEWORK}" /p:Configuration="Mono Release" /t:GoMono || die
	source ./build.sh || die
	elog "Signing src/Core/obj/Mono Release/NuGet.Core.dll with rsa-4096.snk"
	estrong_resign "src/Core/obj/Mono Release/NuGet.Core.dll" src/Core/rsa-4096.snk
}

src_install() {
	elog "Installing NuGet.Core.dll into GAC"
	egacinstall "src/Core/obj/Mono Release/NuGet.Core.dll"
	elog "Installing NuGet console application"
	insinto /usr/lib/mono/NuGet/"${FRAMEWORK}"/
	doins src/CommandLine/obj/Mono\ Release/NuGet.exe
	make_wrapper nuget "mono /usr/lib/mono/NuGet/${FRAMEWORK}/NuGet.exe"
}
