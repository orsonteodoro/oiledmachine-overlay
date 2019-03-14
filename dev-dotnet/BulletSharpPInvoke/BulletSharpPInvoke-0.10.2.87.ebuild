# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils dotnet gac multilib-minimal multilib-build versionator

DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
MY_PV="$(get_version_component_range 1-2)"
LIBBULLETC_PV="$(get_version_component_range 3-4)"
SRC_URI="https://github.com/AndresTraks/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
         https://github.com/bulletphysics/bullet3/archive/${LIBBULLETC_PV}.tar.gz -> bullet-${LIBBULLETC_PV}.tar.gz"

LICENSE="MIT zlib"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net40 net45 net46"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND="sci-physics/bullet:0/2.87"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S_BASE="${WORKDIR}/${PN}-${MY_PV}"
S="${S_BASE}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
	unpack ${A}
	mv bullet3-${LIBBULLETC_PV} bullet
}

src_prepare() {
	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" BulletSharpPInvoke/Native.cs || die

	egenkey

	sed -i -e "s|<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>|<TargetFrameworkVersion>${EBF}</TargetFrameworkVersion>|" BulletSharpPInvoke/BulletSharpPInvoke.csproj || die

	sed -i -e 's|ADD_SUBDIRECTORY\(test\)||g' libbulletc/CMakeLists.txt || die

	S="${S_BASE}/libbulletc"

	cp ${PN}-keypair.snk BulletSharpPInvoke/ || die
	sed -i -r -e "s|using System.Runtime.InteropServices;|using System.Runtime.InteropServices;\n[assembly:AssemblyKeyFileAttribute(\"${PN}-keypair.snk\")]|" BulletSharpPInvoke/Properties/AssemblyInfo.cs || die

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
	cd "${S_BASE}"/BulletSharpPInvoke || die
	addpredict /etc/mono/registry
	exbuild BulletSharpPInvoke.sln /p:Configuration=${mydebug}  || die
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
		egacinstall "${S_BASE}/BulletSharpPInvoke/bin/${mydebug}/BulletSharp.dll"
        done

	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins BulletSharpPInvoke/bin/${mydebug}/BulletSharp.dll.mdb
	fi

        FILES=$(find "${D}" -name "BulletSharp.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/BulletSharp.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
