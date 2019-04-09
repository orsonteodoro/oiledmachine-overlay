# Copyright 1999-2017 Gentoo Foundation
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
LIBNAME="libfreenect"
SRC_URI="https://github.com/OpenKinect/${LIBNAME}/archive/v${PV}.tar.gz -> ${LIBNAME}-${PV}.tar.gz"

PYTHON_DEPEND="!bindist? 2"

COMMON_DEP=">=dev-lang/mono-4
            dev-libs/libfreenect"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}"
S="${WORKDIR}/${LIBNAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" wrappers/csharp/src/lib/KinectNative.cs

	egenkey

	eapply_user
}

src_compile() {
	cd "${S}/wrappers/csharp/src/lib/VS2010"

        einfo "Building solution"
        exbuild_strong "freenectdotnet.sln" || die
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
