# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Snapshots are done because of abseil-cpp.  We try to prevent a multiple instances conflict.
# This tarball corresponds to protobuf 21.12.

inherit cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
	FALLBACK_COMMIT="72c943dea2b9240cd09efde15191e144bc7c7d38" # Nov 15, 2022
	S="${WORKDIR}/utf8_range-9999"
else
	EGIT_COMMIT="72c943dea2b9240cd09efde15191e144bc7c7d38" # Nov 15, 2022
	SRC_URI="
https://github.com/protocolbuffers/utf8_range/archive/${EGIT_COMMIT}.tar.gz -> utf8_range-${EGIT_COMMIT:0:7}.tar.gz
	"
	S="${WORKDIR}/utf8_range-${EGIT_COMMIT}"
fi

DESCRIPTION="Fast UTF-8 validation with Range algorithm (NEON+SSE4+AVX2)"
HOMEPAGE="https://github.com/protocolbuffers/protobuf/tree/main/third_party/utf8_range"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
SLOT="0/3.21" # Subslot is protobuf slot.
IUSE+=" fallback-commit test"
# See https://github.com/protocolbuffers/utf8_range/blob/main/.github/workflows/cmake_tests.yml#L14
RDEPEND+="
	>=dev-cpp/abseil-cpp-20220623.1:0/20220623
"
BDEPEND+="
	>=dev-build/cmake-3.5
	test? (
		>=dev-cpp/gtest-1.12.1
	)
"
DOCS=( README.md )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && export EGIT_COMMIT="${EGIT_COMMIT}"
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e "s|utf8_range STATIC|utf8_range SHARED|g" \
		"CMakeLists.txt" \
		|| die
	sed -i \
		-e "s|utf8_validity STATIC|utf8_validity SHARED|g" \
		"CMakeLists.txt" \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-Dutf8_range_ENABLE_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: multilib-support EAPI8
# OILEDMACHINE-OVERLAY-META-REVDEP: leveldb
