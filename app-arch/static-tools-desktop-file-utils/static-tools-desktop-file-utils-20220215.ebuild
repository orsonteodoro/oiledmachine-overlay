# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-compiler-switch flag-o-matic

# You can build this in a musl container to get strictly musl libs.
COMMIT="56d220dd679c7c3a8f995a41a27a7d6f3df49dea"
COMMIT2="28ea239c53a2d5d8800c472bc2452eaa16e37af2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/desktop-file-utils-${COMMIT}"
SRC_URI="
	https://gitlab.freedesktop.org/xdg/desktop-file-utils/-/archive/${COMMIT}/desktop-file-utils-${COMMIT}.tar.gz
	https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=${COMMIT2} -> desktop-file-utils-${COMMIT2:0:5}-config.guess
	https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=${COMMIT2} -> desktop-file-utils-${COMMIT2:0:5}-config.sub
"

DESCRIPTION="desktop-file-utils for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://gitlab.freedesktop.org/xdg/desktop-file-utils
"
LICENSE="
	GPL-2+
	GPL-3+-with-autoconf-exception
"
IUSE=""
REQUIRED_USE+="
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	dev-libs/glib:=[static-libs]
	elibc_musl? (
		dev-libs/libintl:=[static-libs]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-debug/strace
	sys-apps/file
	sys-apps/util-linux
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
"
PATCHES=(
)

get_arch() {
	if use arm ; then
		echo "armhf"
	elif use arm64 ; then
		echo "aarch64"
	elif use amd64 ; then
		echo "x86_64"
	elif use x86 ; then
		echo "i686"
	fi
}

pkg_setup() {
	check-compiler-switch_start
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

src_compile() {
# MIT License
#
# Copyright (c) 2019 probonopd
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
	if ! use elibc_musl ; then
ewarn "Upstream intends that artifacts be built from a musl chroot or container."
	fi
	local ARCHITECTURE=$(get_arch)

	# Build static desktop-file-utils
	# apk add glib-static glib-dev
	# The next 2 lines are a workaround for: checking build system type... ./config.guess: unable to guess system type
	cp -a "${DISTDIR}/desktop-file-utils-${COMMIT2:0:5}-config.guess" config.guess || die
	cp -a "${DISTDIR}/desktop-file-utils-${COMMIT2:0:5}-config.sub" config.sub || die
	autoreconf --install # https://github.com/shendurelab/LACHESIS/issues/31#issuecomment-283963819
	./configure \
		CFLAGS="-no-pie" \
		LDFLAGS="-static" \
		|| die
	emake
	cd src/ || die
	local LIBS=""
	if use elibc_musl ; then
		LIBS="-lintl"
	fi
	gcc -static -o desktop-file-validate keyfileutils.o validate.o validator.o mimeutils.o -lglib-2.0 ${LIBS} || die
	gcc -static -o update-desktop-database  update-desktop-database.o mimeutils.o -lglib-2.0 ${LIBS} || die
	gcc -static -o desktop-file-install keyfileutils.o validate.o install.o mimeutils.o -lglib-2.0 ${LIBS} || die
	strip desktop-file-install desktop-file-validate update-desktop-database || die
	cd ../
	mkdir -p out || die
	cp "src/desktop-file-install" "out/desktop-file-install-${ARCHITECTURE}" || die
	cp "src/desktop-file-validate" "out/desktop-file-validate-${ARCHITECTURE}" || die
	cp "src/update-desktop-database" "out/update-desktop-database-${ARCHITECTURE}" || die
}

get_libc() {
	local libc
	if use elibc_glibc ; then
		libc="glibc"
	elif use elibc_musl ; then
		libc="musl"
	else
		libc="native"
	fi
	echo "${libc}"
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	local libc=$(get_libc)
	exeinto "/usr/share/static-tools/${libc}"
	doexe "out/desktop-file-install-${ARCHITECTURE}"
	doexe "out/desktop-file-validate-${ARCHITECTURE}"
	doexe "out/update-desktop-database-${ARCHITECTURE}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
