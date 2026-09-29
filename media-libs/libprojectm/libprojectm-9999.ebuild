# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=14

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX14[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"media-libs/libglvnd-9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot secure-version cmake-multilib

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="https://github.com/projectM-visualizer/projectm"

if [[ ${PV} == *9999 ]] ; then
	FALLBACK_COMMIT=""
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/projectM-visualizer/projectm.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/projectM-visualizer/projectm/releases/download/v${MY_PV}/libprojectM-${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
	S="${WORKDIR}/libprojectM-${MY_PV}"
fi

LICENSE="LGPL-2"
SOVER="4"
SLOT="${SOVER}"
IUSE+="
gles2-only static-libs test
ebuild_revision_1
"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/glm:=
	>=media-libs/libglvnd-${LIBGLVND_PV}:=[X(+)]
"

DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
			git-r3_fetch
			git-r3_checkout
		fi
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -e "PROJECTM_SO_VERSION" "${S}/CMakeLists.txt" | head -n 1 | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "Update SOVER or ${PV}"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DENABLE_SDL_UI=OFF
		-DENABLE_CXX_INTERFACE=OFF
		-DENABLE_GLES=$(usex gles2-only)
		-DENABLE_SYSTEM_GLM=ON
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
	)

	cmake_src_configure
}

pkg_postinst() {
einfo
einfo "This package comes without presets."
einfo
einfo "Find presets at https://github.com/projectM-visualizer/projectm/tree/v${PV}#presets"
einfo
einfo "The default preset is the \"Cream of the Crop Pack\" which can found at"
einfo "https://github.com/projectM-visualizer/presets-cream-of-the-crop"
einfo
einfo "Install the presets to ~/.projectM/presets and configure the plugin to search there."
einfo
}
