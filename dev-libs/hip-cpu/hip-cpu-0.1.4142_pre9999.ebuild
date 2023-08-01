# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP-CPU.git"
	inherit git-r3
	IUSE+=" fallback-commit"
fi

DESCRIPTION="An implementation of HIP that works on CPUs, across OSes."
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP-CPU"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
RDEPEND="
	dev-cpp/tbb
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.12
"
CMAKE_BUILD_TYPE="Release"
PATCHES=(
)

src_unpack() {
	use fallback-commit && EGIT_COMMIT="06186c545308173babda129d6f0cb795b322a5c7"
	git-r3_fetch
	git-r3_checkout
	grep -q \
		-e "VERSION $(ver_cut 1-3 ${PV})" \
		"${S}/CMakeLists.txt" \
		|| die "QA:  Bump version"
}

src_prepare() {
	cmake_src_prepare
	# Fix collsions
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip-cpu"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
