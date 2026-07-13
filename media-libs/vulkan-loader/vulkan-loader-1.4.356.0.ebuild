# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Loader
COMMIT_ID="9fd87c33d003122d07169230030ed34cc6dd6bca"
FLAVOR="vulkan-tmp" # vulkan-tmp or vulkan-sdk

CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit cmake-multilib cflags-hardened flag-o-matic toolchain-funcs

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="${COMMIT_ID}"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	EGIT_SUBMODULES=()
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
https://github.com/KhronosGroup/Vulkan-Loader/archive/${COMMIT_ID}.tar.gz -> ${P}.${COMMIT_ID:0:7}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/Vulkan-Loader-${COMMIT_ID}"
fi

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Loader"

LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" wayland X"

DEPEND="
	~dev-util/vulkan-headers-${PV}
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-base/xorg-proto
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		local actual_ver
		local expected_ver
		actual_ver=$(cat "${S}/CMakeLists.txt" | grep "VULKAN_LOADER VERSION" | cut -f 3 -d " ")
		expected_ver=$(ver_cut "1-3" "${PV}")
		if ver_test "${actual_ver}" "-ne" "${expected_ver}" ; then
eerror "QA:  Version inconsistency detected.  Fix the COMMIT_ID."
eerror "Actual version:  ${actual_ver}"
eerror "Expected version:  ${expected_ver}"
			die
		fi
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	# Integrated clang assembler doesn't work with x86 - Bug #698164
	if tc-is-clang && [[ ${ABI} == x86 ]]; then
		append-cflags -fno-integrated-as
	fi

	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_TESTS=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="${ESYSROOT}/usr"
		-DGIT_EXECUTABLE="${BROOT}/usr/bin/git"
	)

	if tc-is-cross-compiler; then
		# Python only needed when cross-compiling so don't bother with eclass.
		mycmakeargs+=( -DPython3_EXECUTABLE="${BROOT}/usr/bin/python3" )
	fi

	cmake_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cmake_src_install
}
