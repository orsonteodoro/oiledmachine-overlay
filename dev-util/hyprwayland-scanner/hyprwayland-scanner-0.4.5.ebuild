# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)

inherit cmake libstdcxx-slot toolchain-funcs

DESCRIPTION="A Hyprland implementation of wayland-scanner, in and for C++"
HOMEPAGE="https://github.com/hyprwm/hyprwayland-scanner/"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/hyprwm/hyprwayland-scanner.git"
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/hyprwayland-scanner/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-libs/pugixml-1.14[${LIBSTDCXX_USEDEP}]
	dev-libs/pugixml:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
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
	libstdcxx-slot_verify
}
