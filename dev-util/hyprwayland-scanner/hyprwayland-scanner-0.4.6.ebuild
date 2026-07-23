# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libstdcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)

LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-libs/pugixml-9999"
)

inherit chkl cmake libstdcxx-slot secure-version toolchain-funcs

DESCRIPTION="A Hyprland implementation of wayland-scanner, in and for C++"
HOMEPAGE="https://github.com/hyprwm/hyprwayland-scanner/"

if [[ "${PV}" == "9999" ]] ; then
	SUBSLOT="0.7"
	FALLBACK_COMMIT="b8632713a6beaf28b56f2a7b0ab2fb7088dbb404"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprwayland-scanner.git"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SUBSLOT=$(ver_cut "1-2" "${PV}")
	SRC_URI="https://github.com/hyprwm/hyprwayland-scanner/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/${SUBSLOT}"

RDEPEND="
	>=dev-libs/pugixml-${PUGIXML_PV}:=[${LIBSTDCXX_USEDEP_LTS}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.19
	virtual/pkgconfig
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)

	if tc-is-gcc && ver_test $(gcc-version) -lt 11 ; then
eerror
eerror "${PN} requires >=sys-devel/gcc-11 to build"
eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
eerror "GCC version is too old to compile Hyprland!"
eerror
		die
	elif tc-is-clang && ver_test $(clang-version) -lt 13 ; then
eerror
eerror "${PN} requires >=llvm-core/clang-13 to build"
eerror "Please upgrade Clang: emerge -v1 llvm-core/clang"
eerror "Clang version is too old to compile Hyprland!"
eerror
		die
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_subslot=$(cat "${S}/VERSION" | cut -f "1-2" -d ".")
	local expected_subslot="${SUBSLOT}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update SUBSLOT in ebuild"
eerror "Actual SUBSLOT:  ${actual_subslot}"
eerror "Expected SUBSLOT:  ${expected_subslot}"
		die
	fi
}


src_configure() {
	chkl_check_many_timestamps
	cmake_src_configure
}
