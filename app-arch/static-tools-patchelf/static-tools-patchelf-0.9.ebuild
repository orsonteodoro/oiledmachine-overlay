# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

SRC_URI="
	https://github.com/NixOS/patchelf/archive/${PV}.tar.gz -> patchelf-${PV}.tar.gz
"
S="${WORKDIR}/patchelf-${PV}"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="patchelf for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://github.com/NixOS/patchelf
"
LICENSE="
	GPL-3
"
IUSE=""
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
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
RESTRICT="mirror"
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

	./bootstrap.sh || die
	./configure \
		--prefix="/usr" \
		CFLAGS="-no-pie" \
		LDFLAGS="-static" \
		|| die
	emake || die
	mv src/patchelf . || die
	file patchelf || die
	strip patchelf || die
	ls -lh patchelf || die
	mkdir -p out || die
	cp "patchelf" "out/patchelf-${ARCHITECTURE}" || die
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
	doexe "out/patchelf-${ARCHITECTURE}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
