# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-compiler-switch flag-o-matic

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/squashfs-tools-${PV}/squashfs-tools"
SRC_URI="
https://github.com/plougher/squashfs-tools/archive/refs/tags/${PV}.tar.gz -> squashfs-tools-${PV}.tar.gz
"

# You can build this in a musl container to get strictly musl libs.

DESCRIPTION="squashfuse for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://github.com/plougher/squashfs-tools
"
LICENSE="
	GPL-2
"
IUSE=""
REQUIRED_USE+="
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	sys-libs/zlib:=[static-libs]
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
	if ! use elibc_musl ; then
ewarn "Upstream intends that artifacts be built from a musl chroot or container."
	fi
	local ARCHITECTURE=$(get_arch)

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

	# Build static squashfs-tools
	sed -i -e 's|#ZSTD_SUPPORT = 1|ZSTD_SUPPORT = 1|g' Makefile || die
	emake \
		LDFLAGS="-static" \
		|| die
	file mksquashfs unsquashfs || die
	strip mksquashfs unsquashfs || die
	mkdir -p out
	cp "mksquashfs" "out/mksquashfs-${ARCHITECTURE}" || die
	cp "unsquashfs" "out/unsquashfs-${ARCHITECTURE}" || die
	emake \
		INSTALL_PREFIX="$(pwd)/out" \
		install
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
	doexe "out/mksquashfs-${ARCHITECTURE}"
	doexe "out/unsquashfs-${ARCHITECTURE}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
