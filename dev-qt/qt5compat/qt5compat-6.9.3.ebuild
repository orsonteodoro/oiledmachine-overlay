# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit libcxx-slot libstdcxx-slot qt6-build

DESCRIPTION="Qt module containing the unsupported Qt 5 APIs"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
fi

IUSE="+gui icu qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui=,icu=,network,xml]
	dev-qt/qtbase:=
	icu? (
		dev-libs/icu[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/icu:=
	)
	!icu? ( virtual/libiconv )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qtdeclarative:=
		~dev-qt/qtshadertools-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qtshadertools:=
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
	)

	qt6-build_src_configure
}

src_test() {
	# tst_qxmlinputsource sometimes hang without -j1
	qt6-build_src_test -j1
}
