# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils dotnet gac multilib-minimal multilib-build versionator

DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
LIBBULLETC_PV="9999.20190702"
BULLET_COMMIT="113c2a83ded447159c30bcb2a2e353b154c3879d"
COMMIT="0d0bceb4f3a4be94fbfded04f7b088f150b48424"
MY_PV="${COMMIT}"
SRC_URI="https://github.com/AndresTraks/BulletSharpPInvoke/archive/${COMMIT}.zip -> ${PN}-${MY_PV}.zip
	 https://github.com/bulletphysics/bullet3/archive/${BULLET_COMMIT}.zip -> bullet-${LIBBULLETC_PV}.zip"

LICENSE="MIT zlib"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net40 net45 net46"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND="=sci-physics/bullet-${LIBBULLETC_PV}"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S_BASE="${WORKDIR}/${PN}-${MY_PV}"
S="${S_BASE}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
	unpack ${A}
	mv bullet3-${BULLET_COMMIT} bullet || die
}

src_prepare() {
	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" BulletSharp/Native.cs || die

	egenkey

	sed -i -e "s|<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>|<TargetFrameworkVersion>${EBF}</TargetFrameworkVersion>|" BulletSharp/BulletSharp.csproj || die

	sed -i -e 's|ADD_SUBDIRECTORY\(test\)||g' libbulletc/CMakeLists.txt || die

	S="${S_BASE}/libbulletc"

	cp ${PN}-keypair.snk BulletSharp/ || die
	sed -i -r -e "s|using System.Runtime.InteropServices;|using System.Runtime.InteropServices;\n[assembly:AssemblyKeyFileAttribute(\"${PN}-keypair.snk\")]|" BulletSharp/Properties/AssemblyInfo.cs || die

	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
        local mycmakeargs=(
		-DBUILD_BULLET3=1
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	# Build native shared library wrapper
	cmake-utils_src_compile

	# Build C# wrapper
	cd "${S_BASE}"/BulletSharp || die
	addpredict /etc/mono/registry
	exbuild BulletSharp.sln /p:Configuration=${mydebug}  || die
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	mkdir -p "${D}/usr/$(get_libdir)"
	cp -a "${S_BASE}/libbulletc-${MULTILIB_ABI_FLAG}.${ABI}/libbulletc.so" "${D}/usr/$(get_libdir)" || die

	esavekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
		egacinstall "${S_BASE}/BulletSharp/bin/${mydebug}/BulletSharp.dll"
        done

	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins BulletSharp/bin/${mydebug}/BulletSharp.dll.mdb
	fi

        FILES=$(find "${D}" -name "BulletSharp.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/BulletSharp.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
