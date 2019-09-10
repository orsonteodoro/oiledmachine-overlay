# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug gac test"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
LIBBULLETC_PV="9999.20190814"
RDEPEND=">=sci-physics/bullet-${LIBBULLETC_PV}"
DEPEND="${RDEPEND}"

inherit cmake-utils dotnet eutils multilib-minimal multilib-build

DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
BULLET_COMMIT="cb654ddc803a56567fdc8f6dcc4eb3e8291b3e98"
COMMIT="498e8b8d0f57d43b55ad9179e3daf416eae33dcb"
MY_PV="${COMMIT}"
SRC_URI="https://github.com/AndresTraks/BulletSharpPInvoke/archive/${COMMIT}.zip -> ${PN}-${MY_PV}.zip
	 https://github.com/bulletphysics/bullet3/archive/${BULLET_COMMIT}.zip -> bullet-${LIBBULLETC_PV}.zip"

inherit gac

LICENSE="MIT zlib"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

S="${WORKDIR}/${PN}-${MY_PV}"

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

	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	compile_impl() {
		dotnet_copy_dllmap_config "${FILESDIR}/BulletSharp.dll.config"

		# Build C# wrapper
		cd BulletSharp || die
		exbuild BulletSharp.sln /p:Configuration=${mydebug}  || die
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
		mydebug="Release"
		if use debug; then
			mydebug="Debug"
		fi

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
