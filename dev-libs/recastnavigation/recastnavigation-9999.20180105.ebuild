# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Recast & Detour is a navigation-mesh toolset for games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="zlib"
SLOT="0"
KEYWORDS="amd64"
DEPEND="
	dev-util/premake:5
"
RDEPEND="${DEPEND}"
IUSE="static debug"
COMMIT="5d4186046c8b6aec6a0784f07fb1fe5c771e6b98"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/${COMMIT}.zip -> ${P}.zip"

S="${WORKDIR}/${PN}-${COMMIT}"

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
