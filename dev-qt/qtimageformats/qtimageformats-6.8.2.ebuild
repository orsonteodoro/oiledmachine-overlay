# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"

inherit cflags-hardened qt6-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc64 ~riscv x86"
fi

IUSE="
mng
ebuild_revision_6
"
RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui]
	media-libs/libwebp:=
	media-libs/tiff:=
	mng? ( media-libs/libmng:= )
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# heif plugin is only for Mac, test is normally auto-skipped but may
	# misbehave with kde-frameworks/kimageformats:6[heif] (bug #927971)
	tst_qheif
)

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DQT_FEATURE_jasper=OFF
		$(qt_feature mng)
		-DQT_FEATURE_tiff=ON
		-DQT_FEATURE_webp=ON
		-DQT_FEATURE_system_tiff=ON
		-DQT_FEATURE_system_webp=ON
	)

	qt6-build_src_configure
}
