# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libstdcxx-slot qt6-build

DESCRIPTION="Qt module for keyframe-based timeline construction"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[${LIBSTDCXX_USEDEP}]
	dev-qt/qtbase:=
	~dev-qt/qtdeclarative-${PV}:6[${LIBSTDCXX_USEDEP}]
	dev-qt/qtdeclarative:=
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libstdcxx-slot_verify
}
