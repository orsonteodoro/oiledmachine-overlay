# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"

inherit cmake linux-info

if [[ ${PV} == *"9999" ]] ; then
	FALLBACK_COMMIT="e112c935057434897bb12d9ab3910380a8bd5f58" # Mar 19, 2024
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP-CPU.git"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	EGIT_COMMIT="e112c935057434897bb12d9ab3910380a8bd5f58" # Mar 19, 2024
	S="${WORKDIR}/HIP-CPU-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/ROCm/HIP-CPU/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="An implementation of HIP that works on CPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP-CPU"
LICENSE="
	Boost-1.0
	MIT
	ISC
"
RESTRICT="mirror" # Speed up downloads
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
	if [[ "${PV}" == *"9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q \
			-e "VERSION $(ver_cut 1-3 ${PV})" \
			"${S}/CMakeLists.txt" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
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
