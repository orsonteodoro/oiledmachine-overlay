# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs versionator

DESCRIPTION="Recast & Detour is a navigation-mesh toolset for games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="zlib"
SLOT="0"
KEYWORDS="amd64"
CDEPEND="media-libs/libsdl2"
DEPEND="
	dev-util/premake:5
	>=sys-devel/gcc-8.0
	${CDEPEND}
"
RDEPEND="${DEPEND}
	 ${CDEPEND}
"
IUSE="static debug"
COMMIT="c40188c796f089f89a42e0b939d934178dbcfc5c"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/${COMMIT}.zip -> ${P}.zip"

S="${WORKDIR}/${PN}-${COMMIT}"

pkg_setup() {
	GCC_V=$(gcc-fullversion)
	if ! $(version_is_at_least "8.0.0" ${GCC_V}) ; then
		die "You need at least gcc 8.0.0 to compile."
	fi
}

src_compile() {
	BUILD_TYPE="release"
	if use debug ; then
		BUILD_TYPE="debug"
	fi

	if use static; then
		true
	else
		sed -i -e "s|StaticLib|SharedLib|g" RecastDemo/premake5.lua
	fi

	cd "${S}/RecastDemo"
	premake5 gmake
	cd "${S}/RecastDemo/Build/gmake"
	make config=${BUILD_TYPE} || die "make failed"
}

src_install() {
	BUILD_TYPE="Release"
	if use debug ; then
		BUILD_TYPE="Debug"
	fi

	insinto /usr/$(get_libdir)
	cd "${S}/RecastDemo/Build/gmake/lib/${BUILD_TYPE}"
	if use static; then
		doins libDetour.a  libDetourCrowd.a  libDetourTileCache.a  libRecast.a
	else
		doins libDetour.so  libDetourCrowd.so  libDetourTileCache.so  libRecast.so
	fi

	insinto /usr/include/Recast
	cd "${S}/Recast/Include"
	doins Recast.h  RecastAlloc.h  RecastAssert.h

	insinto /usr/include/Detour
	cd "${S}/Detour/Include"
	doins DetourAlloc.h  DetourAssert.h  DetourCommon.h  DetourMath.h  DetourNavMesh.h  DetourNavMeshBuilder.h  DetourNavMeshQuery.h  DetourNode.h  DetourStatus.h

	insinto /usr/include/DetourTileCache
	cd "${S}/DetourTileCache/Include"
	doins DetourTileCache.h  DetourTileCacheBuilder.h

	insinto /usr/include/DetourCrowd
	cd "${S}/DetourCrowd/Include"
	doins DetourCrowd.h  DetourLocalBoundary.h  DetourObstacleAvoidance.h  DetourPathCorridor.h  DetourPathQueue.h  DetourProximityGrid.h
}
