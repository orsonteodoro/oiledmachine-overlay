# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
FALLBACK_COMMIT="e112c935057434897bb12d9ab3910380a8bd5f58"

inherit cmake linux-info

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP-CPU.git"
	IUSE+=" fallback-commit"
	inherit git-r3
fi

DESCRIPTION="An implementation of HIP that works on CPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP-CPU"
LICENSE="
	Boost-1.0
	MIT
	ISC
"
SLOT="0/$(ver_cut 1-2)"
RDEPEND="
	dev-cpp/tbb
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.12
"
PATCHES=(
)

src_unpack() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
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
