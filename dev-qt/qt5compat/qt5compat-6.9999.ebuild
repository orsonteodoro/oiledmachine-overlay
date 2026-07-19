# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

FALLBACK_COMMIT="eefa5025da20d74b06a38b59f7e0666fa87721da"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/icu-79.0.9999"
	"dev-qt/qtbase-6.9999"
)

inherit chkl libcxx-slot libstdcxx-slot secure-version qt6-build

DESCRIPTION="Qt module containing the unsupported Qt 5 APIs"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE+="
+gui icu qml
ebuild_revision_2
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[gui=,icu=,network,xml]
	icu? ( >=dev-libs/icu-${ICU_PV}:= )
	!icu? ( virtual/libiconv:= )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=
		~dev-qt/qtshadertools-${PV}:6=
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
	)

	qt6-build_src_configure
}

src_test() {
	# tst_qxmlinputsource sometimes hang without -j1
	qt6-build_src_test -j1
}
