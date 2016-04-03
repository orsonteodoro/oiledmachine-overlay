# Copyright open-overlay 2015 by Alex
EAPI=5
inherit eutils git-2

DESCRIPTION="Recast & Detour"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="zlib"
SLOT="0"
KEYWORDS="amd64"
DEPEND="
	dev-util/premake:4
"
RDEPEND="${DEPEND}"
EGIT_REPO_URI="https://github.com/memononen/recastnavigation.git"
EGIT_BRANCH="master"
IUSE="static"

S="${WORKDIR}"
src_unpack() {
	git-2_src_unpack
}
src_compile() {
	if use static; then
		true
	else
		sed -i -e "s|StaticLib|SharedLib|g" RecastDemo/premake5.lua
	fi

	cd "${WORKDIR}/RecastDemo"
	premake5 gmake
	cd "${WORKDIR}/RecastDemo/Build/gmake"
	ls
	make || die "make failed"
}
src_install() {
	insinto /usr/lib
	cd "${WORKDIR}/RecastDemo/Build/gmake/lib/Debug"
	if use static; then
		doins libDetour.a  libDetourCrowd.a  libDetourTileCache.a  libRecast.a
	else
		doins libDetour.so  libDetourCrowd.so  libDetourTileCache.so  libRecast.so
	fi

	insinto /usr/include/Recast
	cd "${WORKDIR}/Recast/Include"
	doins Recast.h  RecastAlloc.h  RecastAssert.h

	insinto /usr/include/Detour
	cd "${WORKDIR}/Detour/Include"
	doins DetourAlloc.h  DetourAssert.h  DetourCommon.h  DetourMath.h  DetourNavMesh.h  DetourNavMeshBuilder.h  DetourNavMeshQuery.h  DetourNode.h  DetourStatus.h

	insinto /usr/include/DetourTileCache
	cd "${WORKDIR}/DetourTileCache/Include"
	doins DetourTileCache.h  DetourTileCacheBuilder.h

	insinto /usr/include/DetourCrowd
	cd "${WORKDIR}/DetourCrowd/Include"
	doins DetourCrowd.h  DetourLocalBoundary.h  DetourObstacleAvoidance.h  DetourPathCorridor.h  DetourPathQueue.h  DetourProximityGrid.h
}
