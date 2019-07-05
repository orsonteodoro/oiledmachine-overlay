# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit dotnet multilib gac

DESCRIPTION="Drivers and libraries for the Xbox Kinect device on Windows, Linux, and OS X"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"

LICENSE="|| ( Apache-2.0 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
COMMIT="7cb0d3c3c43c9cc25a39492668858fd554c46e99"
SRC_URI="https://github.com/OpenKinect/${PN}/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"
S="${WORKDIR}/${PN}-${COMMIT}"

PYTHON_DEPEND="!bindist? 2"

COMMON_DEP=">=dev-lang/mono-4
            =dev-libs/libfreenect-${PV}"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" wrappers/csharp/src/lib/KinectNative.cs || die

	egenkey

	sed -i -r -e "s|using System.Runtime.CompilerServices;|using System.Runtime.CompilerServices;\n[assembly:AssemblyKeyFileAttribute(\"${PN}-keypair.snk\")]|" wrappers/csharp/src/test/ConsoleTest/AssemblyInfo.cs || die
	sed -i -r -e "s|using System.Runtime.CompilerServices;|using System.Runtime.CompilerServices;\n[assembly:AssemblyKeyFileAttribute(\"${PN}-keypair.snk\")]|" wrappers/csharp/src/lib/AssemblyInfo.cs || die

	cp -a ${PN}-keypair.snk wrappers/csharp/src/lib/VS2010/ || die

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	addpredict /etc/mono/registry/last-btime
	cd "${S}/wrappers/csharp/src/lib/VS2010"

        einfo "Building solution"
        exbuild /p:Configuration=${mydebug} "freenectdotnet.sln" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/wrappers/csharp/bin/freenectdotnet.dll"
                insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/wrappers/csharp/bin/freenectdotnet.dll.mdb"
        done

	eend

        FILES=$(find "${D}" -name "freenectdotnet.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/freenectdotnet.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
