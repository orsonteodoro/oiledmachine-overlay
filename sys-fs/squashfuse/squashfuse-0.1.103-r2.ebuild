# Copyright 2016-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The libappimage uses 1f98030 dated in 2016.
# This 0.1.103 is dated 2018

EAPI=7
inherit flag-o-matic squashfuse

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
COMMIT_SQUASHFUSE_PATCHES="ae0258ab484c1259facc8fd85aaa8c7857c3e155"
SRC_URI="https://github.com/vasi/squashfuse/releases/download/${PV}/${P}.tar.gz
libsquashfuse-appimage? (
https://raw.githubusercontent.com/AppImage/libappimage/${COMMIT_SQUASHFUSE_PATCHES}/src/patches/squashfuse_dlopen.c \
	-> squashfuse_dlopen.c.${COMMIT_SQUASHFUSE_PATCHES}
https://raw.githubusercontent.com/AppImage/libappimage/${COMMIT_SQUASHFUSE_PATCHES}/src/patches/squashfuse_dlopen.h \
	-> squashfuse_dlopen.h.${COMMIT_SQUASHFUSE_PATCHES}
)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="lz4 lzma lzo static-libs +zlib zstd"
REQUIRED_USE="|| ( lz4 lzma lzo zlib zstd )"
REQUIRED_USE+=" libsquashfuse-appimage? ( lzma static-libs )"

COMMON_DEPEND="
	>=sys-fs/fuse-2.8.6:0=
	libsquashfuse-appimage? ( >=app-arch/xz-utils-5.0.4:=[static-libs] )
	lzma? ( >=app-arch/xz-utils-5.0.4:= )
	zlib? ( >=sys-libs/zlib-1.2.5-r2:= )
	lzo? ( >=dev-libs/lzo-2.06:= )
	lz4? ( >=app-arch/lz4-0_p106:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/automake:1.15
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	squashfuse_copy_sources
	prepare() {
		cd "${BUILD_DIR}" || die
		if [[ "${ESQUASHFUSE_TYPE}" == "libsquashfuse-appimage" ]] ; then
			eapply "${FILESDIR}/${PN}.patch"
			eapply "${FILESDIR}/${PN}_dlopen.patch"
			eapply "${FILESDIR}/${PN}-0.1.103-r1-pkconfig-appimage.patch"
			cp -a "${DISTDIR}/${PN}_dlopen.c.${COMMIT_SQUASHFUSE_PATCHES}" \
				"${BUILD_DIR}/${PN}_dlopen.c" || die
			cp -a "${DISTDIR}/${PN}_dlopen.h.${COMMIT_SQUASHFUSE_PATCHES}" \
				"${BUILD_DIR}/${PN}_dlopen.h" || die
			sed -i "s/typedef off_t sqfs_off_t/typedef int64_t sqfs_off_t/g" \
				common.h || die
		fi
	}
	squashfuse_foreach_impl prepare
}

src_configure() {
	configure() {
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
		if [[ "${ESQUASHFUSE_TYPE}" == "libsquashfuse-appimage" ]] ; then
			# disjointed install
			econfargs+=(
				--disable-high-level
				--bindir="/usr/$(get_libdir)/${PN}_appimage/bin"
				--libdir="/usr/$(get_libdir)/${PN}_appimage/lib"
				--includedir="/usr/include/${PN}_appimage"
				--with-pkgconfigdir="/usr/$(get_libdir)/pkgconfig"
			)
		fi

		econf "${econfargs[@]}"
	}
	squashfuse_foreach_impl configure
}

src_compile() {
	compile() {
		cd "${BUILD_DIR}" || die
		emake
	}
	squashfuse_foreach_impl compile
}

src_install() {
	install() {
		cd "${BUILD_DIR}" || die
		default
		find "${ED}" -name "*.la" -delete || die
		if [[ "${ESQUASHFUSE_TYPE}" == "libsquashfuse-appimage" ]] ; then
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
				nonstd.h \
				squashfs_fs.h \
				squashfuse_dlopen.h \
				stack.h \
				table.h \
				traverse.h \
				util.h \
				xattr.h
		fi
	}
	squashfuse_foreach_impl install
}
