# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
LICENSE="OpenTK"
KEYWORDS="~amd64 ~x86"
DL_PV="$(ver_cut 6)"
MY_PV="${DL_PV:0:4}-${DL_PV:4:2}-${DL_PV:6:2}"
MY_P="${PN}-${MY_PV}"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND=">=dev-lang/mono-2.0
	   media-libs/openal
	   virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/p7zip"
inherit dotnet eutils mono
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
inherit gac
S="${WORKDIR}/${MY_P}"
RESTRICT="mirror"

src_unpack() {
	mkdir -p "${S}"; cd "${S}"
	unpack ${A};
	rm -fr "${PN}/Binaries"
}

src_prepare() {
	default
	#required by monogame 3.5.1
	eapply "${FILESDIR}/${PN}-20140723-opentk-expose-joystick-guid.patch" || die "failed to patch joystick guid"
}

src_compile() {
	exbuild OpenTK.sln ${STRONG_ARGS_NETFX}"${WORKDIR}/OpenTK.snk" /t:OpenTK || die "build failed"
}

src_install() {
	mydebug="Release"
	if use debug ; then
		mydebug="Debug"
	fi

	ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.Compatibility.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.GLControl.dll"
        done

	eend

	dodoc Documentation/*.txt

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins Binaries/OpenTK/Release/{OpenTK.dll.mdb,OpenTK.GLControl.xml,OpenTK.pdb,OpenTK.xml}
	fi

        FILES=$(find "${D}" -name "OpenTK.Compatibility.dll")
        for f in $FILES
        do
		cp -a "Binaries/OpenTK/${mydebug}/OpenTK.Compatibility.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "OpenTK.dll")
        for f in $FILES
        do
		cp -a "Binaries/OpenTK/${mydebug}/OpenTK.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "OpenTK.GLControl.dll")
        for f in $FILES
        do
		cp -a "Binaries/OpenTK/${mydebug}/OpenTK.GLControl.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
