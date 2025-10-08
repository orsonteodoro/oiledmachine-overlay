# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++17
	"gcc_slot_12_5" # Support -std=c++17
	"gcc_slot_13_4" # Support -std=c++17
	"gcc_slot_14_3" # Support -std=c++17
)

inherit libstdcxx-slot qt6-build

DESCRIPTION="Qt APIs and Tools for Graphics Pipelines"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[${LIBSTDCXX_USEDEP},gui]
	dev-qt/qtbase:=
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libstdcxx-slot_verify
}
