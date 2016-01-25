# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils

DESCRIPTION="SharpFont"
HOMEPAGE="https://github.com/assimp/assimp-net"
SRC_URI="https://github.com/assimp/assimp-net/archive/${PV}.tar.gz"

LICENSE="ASSIMPNET"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

# This build is not parallel build friendly
MAKEOPTS="${MAKEOPTS} -j1"

S="${WORKDIR}/assimp-net-${PV}"

src_compile() {
	mydebug="Net45-Release"
	if use debug; then
		mydebug="Net45-Debug"
	fi
	cd "${S}/AssimpNet.Interop.Generator"
	xbuild AssimpNet.Interop.Generator.csproj /p:Configuration=${mydebug}

	cd "${S}"
	sn -k "${PN}-keypair.snk"

	cd "${S}"
	A='"$(SolutionDir)AssimpNet.Interop.Generator\bin\$(Configuration)\AssimpNet.Interop.Generator.exe" "$(TargetDir)$(TargetFileName)" "$(ProjectDir)AssimpKey.snk"' \
	B='mono $(ProjectDir)..\AssimpNet.Interop.Generator\bin\$(Configuration)\AssimpNet.Interop.Generator.exe "$(TargetDir)$(TargetFileName)" "$(ProjectDir)assimp-net-keypair.snk"' \
	 perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' AssimpNet/AssimpNet.csproj

	cd "${S}/AssimpNet"
	xbuild AssimpNet.csproj /p:Configuration=${mydebug}
}

src_install() {
	mydebug="Net45-Release"
	if use debug; then
		mydebug="Net45-Debug"
	fi

        ebegin "Installing dlls into the GAC"

	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	mkdir -p "${D}/usr/lib/mono/AssimpNet.Interop.Generator/${PV}"
	cp "${S}/AssimpNet.Interop.Generator/obj/${mydebug}"/* "${D}/usr/lib/mono/AssimpNet.Interop.Generator/${PV}"/

	cd "${S}/AssimpNet"
	#strong_sign "${S}/${PN}-keypair.snk" "${S}/AssimpNet/obj/${mydebug}/AssimpNet.dll"
        gacutil -i "${S}/AssimpNet/obj/${mydebug}/AssimpNet.dll" -root "${D}/usr/$(get_libdir)" \
                -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"

	eend


	cd "${S}/AssimpNet"
	dodoc AssimpLicense.txt
	cd "${S}"
	dodoc -r Docs/*

        #mono_multilib_comply
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" || die "ilasm failed"
	popd
}
