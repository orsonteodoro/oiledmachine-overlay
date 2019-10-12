# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
LICENSE="MIT zlib"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug gac test"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
LIBBULLETC_PV="2.88_p20190702"
RDEPEND="sci-physics/bullet:0/${LIBBULLETC_PV}"
DEPEND="${RDEPEND}"
BULLET_COMMIT="113c2a83ded447159c30bcb2a2e353b154c3879d"
EGIT_COMMIT="23159ab02e69cea88709d8cd383aef86d56329f8"
inherit cmake-utils dotnet eutils multilib-minimal
SRC_URI="https://github.com/AndresTraks/BulletSharpPInvoke/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	 https://github.com/bulletphysics/bullet3/archive/${BULLET_COMMIT}.tar.gz -> bullet-${LIBBULLETC_PV}.tar.gz"
inherit gac
SLOT="0/${PV}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	unpack ${A}
	mv bullet3-${BULLET_COMMIT} bullet || die
}

src_prepare() {
	default
	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" BulletSharp/Native.cs || die

	if ! use test ; then
		sed -i -e 's|ADD_SUBDIRECTORY\(test\)||g' libbulletc/CMakeLists.txt || die
	fi

	estrong_assembly_info "using System.Runtime.InteropServices;" "${DISTDIR}/mono.snk" "BulletSharp/Properties/AssemblyInfo.cs"

	multilib_copy_sources

	ml_prepare() {
		cd "${BUILD_DIR}/libbulletc" || die
		S="${BUILD_DIR}/libbulletc" \
		cmake-utils_src_prepare
	}
	multilib_foreach_abi ml_prepare

	dotnet_copy_sources
}

src_configure() {
	ml_configure() {
		cd "${BUILD_DIR}/libbulletc" || die
	        local mycmakeargs=( -DBUILD_BULLET3=1 )
		cmake-utils_src_configure
	}
	multilib_foreach_abi ml_configure
}

src_compile() {
	ml_compile() {
		cd "${BUILD_DIR}/libbulletc" || die
		# Build native shared library wrapper
		cmake-utils_src_compile
	}
	multilib_foreach_abi ml_compile

	compile_impl() {
		dotnet_copy_dllmap_config "${FILESDIR}/BulletSharp.dll.config"

		# Build C# wrapper
		cd BulletSharp || die
		exbuild BulletSharp.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	ml_install() {
		cd "${BUILD_DIR}"
		insinto /usr/$(get_libdir)
		doins "libbulletc.so"
	}
	multilib_foreach_abi ml_install

	install_impl() {
		local mydebug=$(usex debug "Debug" "Release")

		dotnet_install_loc

		if [[ "${EDOTNET}" == "net40" ]] ; then
			egacinstall "BulletSharp/bin/${mydebug}/BulletSharp.dll"
		fi

		doins BulletSharp/bin/${mydebug}/BulletSharp.dll
		doins BulletSharp.dll.config

		if use developer ; then
			doins BulletSharp/bin/${mydebug}/BulletSharp.dll.mdb
		fi

		dotnet_distribute_dllmap_config "BulletSharp.dll"
	}
	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}
