# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2016-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The libappimage uses 1f98030 dated in 2016.
# This 0.1.103 is dated 2018

EAPI=8

inherit autotools flag-o-matic

COMMIT_SQUASHFUSE_PATCHES="718cfda5a1f668059d8e34cf28a037e7ec0ce200"
SRC_URI="
https://github.com/vasi/squashfuse/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	appimage? (
https://raw.githubusercontent.com/AppImage/libappimage/${COMMIT_SQUASHFUSE_PATCHES}/src/patches/squashfuse_dlopen.c
	-> squashfuse_dlopen.c.${COMMIT_SQUASHFUSE_PATCHES:0:7}
https://raw.githubusercontent.com/AppImage/libappimage/${COMMIT_SQUASHFUSE_PATCHES}/src/patches/squashfuse_dlopen.h
	-> squashfuse_dlopen.h.${COMMIT_SQUASHFUSE_PATCHES:0:7}
	)
"

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE+="
fuse2 fuse3
vanilla appimage
lz4 lzma lzo static-libs +zlib zstd
r7
"
REQUIRED_USE+="
	^^ (
		fuse3
		fuse2
	)
	appimage? (
		fuse2
		lzma
		static-libs
	)
	|| (
		lz4
		lzma
		lzo
		zlib
		zstd
	)
	|| (
		appimage
		vanilla
	)
"
DEPEND+="
	appimage? (
		>=app-arch/xz-utils-5.0.4:=[static-libs]
	)
	fuse2? (
		>=sys-fs/fuse-2.8.6:0=
	)
	fuse3? (
		>=sys-fs/fuse-3:3=
	)
	lz4? (
		>=app-arch/lz4-0_p106:=
	)
	lzma? (
		>=app-arch/xz-utils-5.0.4:=
	)
	lzo? (
		>=dev-libs/lzo-2.06:=
	)
	zlib? (
		>=sys-libs/zlib-1.2.5-r2:=
	)
	zstd? (
		app-arch/zstd:=
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	sys-devel/automake:1.15
	virtual/pkgconfig
"
RESTRICT="mirror strip"

get_variants() {
	use appimage && echo "appimage"
	use vanilla && echo "vanilla"
}

src_prepare() {
	default
	cd "${S}" || die

	eapply "${FILESDIR}/${PN}-0.1.105-with-fuse-slot.patch"

	eautoreconf

	local variant
	for variant in $(get_variants) ; do
		cp -a "${S}" "${S}_${variant}" || die
		export BUILD_DIR="${S}_${variant}"
		cd "${BUILD_DIR}" || die
		if [[ "${variant}" == "appimage" ]] ; then
			eapply "${FILESDIR}/${PN}-0.1.105-${PN}.patch"
			eapply "${FILESDIR}/${PN}-0.1.105-${PN}_dlopen.patch"
			eapply "${FILESDIR}/${PN}-0.1.105-pkgconfig-appimage.patch"
			cat "${DISTDIR}/${PN}_dlopen.c.${COMMIT_SQUASHFUSE_PATCHES:0:7}" \
				> "${BUILD_DIR}/${PN}_dlopen.c" || die
			cat "${DISTDIR}/${PN}_dlopen.h.${COMMIT_SQUASHFUSE_PATCHES:0:7}" \
				> "${BUILD_DIR}/${PN}_dlopen.h" || die
			sed -i "s/typedef off_t sqfs_off_t/typedef int64_t sqfs_off_t/g" \
				common.h || die
		fi
	done
}

src_configure() {
	local variant
	for variant in $(get_variants) ; do
		export BUILD_DIR="${S}_${variant}"
		cd "${BUILD_DIR}" || die
		filter-flags -flto* -fwhole-program -fno-common
		local econfargs=(
			$(use_enable static-libs static)
			$(use lz4 || echo --without-lz4)
			$(use lzma || echo  --without-xz)
			$(use lzo || echo --without-lzo)
			$(use zlib || echo --without-zlib)
			$(use zstd || echo --without-zstd)
		)
		if use fuse3 ; then
			econfargs+=(
				--with-fuse-slot=3
			)
		else
			econfargs+=(
				--with-fuse-slot=2
			)
		fi
		if [[ "${variant}" == "appimage" ]] ; then
			econfargs+=(
				--disable-high-level
				--bindir="/usr/$(get_libdir)/${PN}_appimage/bin"
				--includedir="/usr/include/${PN}_appimage"
				--libdir="/usr/$(get_libdir)/${PN}_appimage/lib"
				--with-pkgconfigdir="/usr/$(get_libdir)/pkgconfig"
			)
		fi
		econf "${econfargs[@]}"
		if [[ "${variant}" == "appimage" ]] ; then
			sed -i -e "s|XZ_LIBS = |XZ_LIBS = -Bstatic|g" Makefile || die
		fi
	done
}

src_compile() {
	local variant
	for variant in $(get_variants) ; do
		cd "${BUILD_DIR}" || die
		emake
	done
}

src_install() {
	local variant
	for variant in $(get_variants) ; do
		export BUILD_DIR="${S}_${variant}"
		cd "${BUILD_DIR}" || die
		default
		find "${ED}" -name "*.la" -delete || die
		if [[ "${variant}" == "appimage" ]] ; then
			insinto /usr/include/${PN}_appimage
			# for appimage packages
			doins \
				cache.h \
				common.h \
				config.h \
				dir.h \
				decompress.h \
				file.h \
				fs.h \
				fuseprivate.h \
				nonstd.h \
				squashfs_fs.h \
				squashfuse_dlopen.h \
				stack.h \
				table.h \
				traverse.h \
				util.h \
				xattr.h
			insinto /usr/$(get_libdir)/${PN}_appimage/lib
			doins .libs/libsquashfuse_ll.a
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-REVDEP:  appimaged, AppImageKit
