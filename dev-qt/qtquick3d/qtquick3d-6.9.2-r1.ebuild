# Copyright 2021-2025 Gentoo Authors
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

QT6_HAS_STATIC_LIBS=1

inherit libcxx-slot libstdcxx-slot qt6-build

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	EGIT_SUBMODULES=() # skip qtquick3d-assimp
fi

IUSE="opengl vulkan"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},concurrent,gui,opengl=,vulkan=,widgets]
	dev-qt/qtbase:=
	~dev-qt/qtdeclarative-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-qt/qtdeclarative:=
	~dev-qt/qtquicktimeline-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-qt/qtquicktimeline:=
	~dev-qt/qtshadertools-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-qt/qtshadertools:=
	media-libs/assimp[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-libs/assimp:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
	test? (
		~dev-qt/qtbase-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},network]
		dev-qt/qtbase:=
	)
	vulkan? ( dev-util/vulkan-headers )
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
	"${FILESDIR}"/${PN}-6.9.2-assimp6.patch
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		# TODO: if someone wants it, openxr should likely have its own
		# USE and be packaged rather than use the bundled copy (if use
		# bundled, note need to setup python-any-r1)
		-DQT_FEATURE_quick3dxr_openxr=OFF
	)

	qt6-build_src_configure
}
