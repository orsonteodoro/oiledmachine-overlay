# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
CFLAGS_HARDENED_USE_CASES="untrusted-data"

FALLBACK_COMMIT="8a1f66152a083987a8d124014a28ce3e2d6e63b1"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtdeclarative-6.9999"
	"media-libs/assimp-9999"
)


QT6_HAS_STATIC_LIBS=1
inherit cflags-hardened chkl libcxx-slot libstdcxx-slot secure-version qt6-build

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	EGIT_SUBMODULES=() # skip qtquick3d-assimp
fi

IUSE+="
opengl vulkan
ebuild_revision_2
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},concurrent,gui,opengl=,vulkan=,widgets]
	~dev-qt/qtdeclarative-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	~dev-qt/qtquicktimeline-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	~dev-qt/qtshadertools-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/assimp-${ASSIMP_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=virtual/zlib-${ZLIB_PV}:=
"
DEPEND="
	${RDEPEND}
	test? (
		~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},network]
	)
	vulkan? ( dev-util/vulkan-headers:= )
"
BDEPEND="
	~dev-qt/qtshadertools-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-qt/qtshadertools:=
"

CMAKE_SKIP_TESTS=(
	# needs off-by-default assimp[collada] that is masked on some profiles,
	# not worth the extra trouble
	tst_qquick3dassetimport
)

PATCHES=(
	"${FILESDIR}"/${PN}-6.6.2-gcc14.patch
	"${FILESDIR}"/${PN}-6.6.2-x32abi.patch
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	local mycmakeargs=(
		# TODO: if someone wants it, openxr should likely have its own
		# USE and be packaged rather than use the bundled copy (if use
		# bundled, note need to setup python-any-r1)
		-DQT_FEATURE_quick3dxr_openxr=OFF
	)

	qt6-build_src_configure
}
