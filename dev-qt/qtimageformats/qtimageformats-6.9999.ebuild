# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17

FALLBACK_COMMIT="ae7c18d1e0bdcfce8abc1347a43c9c74ac5a3d37"

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
	"media-libs/libwebp-9999"
	"media-libs/tiff-9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot secure-version qt6-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~x86"
fi

IUSE+="
mng
ebuild_revision_1
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui]
	>=media-libs/libwebp-${LIBWEBP_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	mng? ( media-libs/libmng:= )
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# heif plugin is only for Mac, test is normally auto-skipped but may
	# misbehave with kde-frameworks/kimageformats:6[heif] (bug #927971)
	tst_qheif
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		-DQT_FEATURE_jasper=OFF
		$(qt_feature mng)
		-DQT_FEATURE_tiff=ON
		-DQT_FEATURE_webp=ON
	)

	qt6-build_src_configure
}
