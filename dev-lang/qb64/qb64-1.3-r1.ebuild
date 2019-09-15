# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils

DESCRIPTION="QB64 is a modern extended BASIC+OpenGL language that retains QB4.5/QBasic compatibility and compiles native binaries for Windows (XP and up), Linux and macOS."
HOMEPAGE="http://www.qb64.net/"
# Many licenses because of the mingw compiler and internal third parties
LICENSE="Apache-2.0 BSD CC-BY-SA-3.0 CC0-1.0 FTL gcc-runtime-library-exception-3.1 GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT openssl SGI-B-2.0 ZLIB ZPL"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Galleondragon/qb64/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE="android samples"
RDEPEND="android? ( dev-util/android-studio )
         media-libs/libsdl
	 media-libs/sdl-image
	 media-libs/sdl-mixer
         media-libs/sdl-net
	 media-libs/sdl-ttf"
DEPEND="${RDEPEND}"
S="${WORKDIR}/qb64-${PV}"
CHECKREQS_DISK_BUILD="808M"
CHECKREQS_DISK_USR="795M"

src_prepare() {
	default
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;
}

src_compile() {
	sed -i "s|./qb64 &||g" setup_lnx.sh || die
	sed -i "s|cat > ~/.local/share/applications/qb64.desktop <<EOF|cat > ${T}/qb64.desktop <<EOF|g" setup_lnx.sh || die
	./setup_lnx.sh
}

src_install() {
	exeinto /usr/$(get_libdir)/qb64
	doexe qb64

	insinto /usr/$(get_libdir)/qb64
	doins -r internal source

	insinto /usr/share/${PN}
	use samples && doins -r programs/samples
	use android && doins -r programs/android

	exeinto /usr/bin
	doexe "${FILESDIR}/qb64"
	sed -i -e "s|lib64|$(get_libdir)|" "${D}/usr/bin/qb64" || die

	# We need to get IDE to work properly.  It will break if you do not set the permissions.
	fperms o+w /usr/$(get_libdir)/qb64/internal/ \
	    /usr/$(get_libdir)/qb64/internal/c/parts/core/gl_header_for_parsing/temp/gl_helper_code.h \
	    $(find "${D}"/usr/$(get_libdir)/qb64/internal/temp/ -name "*.bin" -o -name "*.txt" -o -name "*.rc" | sed -e "s|${D}||") \
	    /usr/$(get_libdir)/qb64/internal/temp \
	    $(find "${D}"/usr/$(get_libdir)/qb64/source/virtual_keyboard -name "*.bas" | sed -e "s|${D}||")

	# We need the compile function to work.
	fperms o+w /usr/$(get_libdir)/qb64/internal/c/libqb/os/lnx

	# We need to be able to run qb64 normally.
	fperms o+w /usr/$(get_libdir)/qb64

	newicon internal/source/qb64icon32.png qb64.png
	make_desktop_entry "/usr/bin/qb64" "QB64 Programming IDE" "/usr/share/pixmaps/qb64.png" "Development;IDE"
}
