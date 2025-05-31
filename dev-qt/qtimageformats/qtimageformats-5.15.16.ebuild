# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc64 ~riscv x86"
fi

inherit cflags-hardened qt5-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"
IUSE="
mng
ebuild_revision_8
"
DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	media-libs/libwebp:=
	media-libs/tiff:=
	mng? ( media-libs/libmng:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	cflags-hardened_append
	sed -e 's/qtConfig(jasper)/false:/' \
		-i src/plugins/imageformats/imageformats.pro || die
	qt_use_disable_config mng mng src/plugins/imageformats/imageformats.pro

	qt5-build_src_configure
}
