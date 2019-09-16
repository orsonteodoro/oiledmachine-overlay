# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils

DESCRIPTION="QB64 is a modern extended BASIC+OpenGL language that retains QB4.5/QBasic compatibility and compiles native binaries for Windows (XP and up), Linux and macOS."
HOMEPAGE="http://www.qb64.net/"
# Many licenses because of the mingw compiler and internal third party packages
LICENSE="Apache-2.0 BSD CC-BY-SA-3.0 CC0-1.0 FTL gcc-runtime-library-exception-3.1 GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT openssl SGI-B-2.0 ZLIB ZPL"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Galleondragon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE="android samples"
RDEPEND="android? ( dev-util/android-studio )
         media-libs/libsdl
	 media-libs/sdl-image
	 media-libs/sdl-mixer
         media-libs/sdl-net
	 media-libs/sdl-ttf"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${PV}"
CHECKREQS_DISK_BUILD="808M"
CHECKREQS_DISK_USR="795M"

src_prepare() {
	default
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;
}

src_compile() {
	sed -i "s|./${PN} &||g" setup_lnx.sh || die
	sed -i "s|cat > ~/.local/share/applications/${PN}.desktop <<EOF|cat > ${T}/${PN}.desktop <<EOF|g" setup_lnx.sh || die
	./setup_lnx.sh
}

# Sets file permissions and owner to get product working
fpo() {
	fperms g+w $@
	fowners root:users $@
}

# Recursive version
fpor() {
	fperms -R g+w $@
	fowners -R root:users $@
}

src_install() {
	local prefix="/opt/${PN}"
	exeinto "${prefix}"
	doexe ${PN}

	insinto "${prefix}"
	doins -r internal source LICENSE

	insinto "${prefix}/programs"
	use samples && doins -r programs/samples
	use android && doins -r programs/android

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i -e "s|/usr/lib64/qb64|${prefix}|" "${D}/usr/bin/${PN}" || die

	# Relax permissions in order for it to function properly.
	fpo "${prefix}" \
	    "${prefix}/internal/" \
	    "${prefix}/internal/temp" \
	    "${prefix}/internal/c/libqb/os/lnx" \
	    "${prefix}/internal/c/parts/core/gl_header_for_parsing/temp/gl_helper_code.h" \
	    $(find "${D}${prefix}/internal/temp/" -name "*.bin" -o -name "*.rc" -o -name "*.txt" | sed -e "s|${D}||") \
	    $(find "${D}${prefix}/source/virtual_keyboard" -name "*.bas" | sed -e "s|${D}||")


	# Fix running examples
	fpo $(find "${D}${prefix}/programs" -name "*.bas" | sed -e "s|${D}||") \
	    "${prefix}/internal/c/makeline_lnx.txt" \
	    "${prefix}/internal/c/makedat_lnx32.txt" \
	    "${prefix}/internal/c/makedat_lnx64.txt"
	fpor $(find "${D}${prefix}/internal/c" -name "temp" | sed -e "s|${D}||") \
	     $(find "${D}${prefix}/internal/c" -name "lnx" | sed -e "s|${D}||")

	newicon internal/source/${PN}icon32.png ${PN}.png
	make_desktop_entry "/usr/bin/${PN}" "${PN^^} Programming IDE" "/usr/share/pixmaps/${PN}.png" "Development;IDE"
}

pkg_postinst() {
	einfo "If you are playing sound, ${PN} may not run your program.  Close the other sound program and try running again."
	einfo "You need to be part of the users group in order to run ${PN}."
}
