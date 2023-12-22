# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="static-tools runtime"
HOMEPAGE="https://github.com/probonopd/static-tools"
LICENSE="
	all-rights-reserved
	MIT
"
IUSE="fallback-commit +runtime"
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=sys-fs/squashfuse-0.1.105[static-libs,zstd]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-util/strace
	sys-apps/util-linux
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
"
SRC_URI=" "
RESTRICT="mirror"
PATCHES=(
)

src_unpack() {
	if use fallback-commit ; then
		EGIT_COMMIT="9bf80ec81e5a8e4a6556c3422001ec48b040b68d"
	fi
	git-r3_fetch
	git-r3_checkout
}

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

build_runtime() {
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
	export GIT_COMMIT=$(cat src/runtime/version)
	cd src/runtime || die
	make runtime-fuse2 || die
	file runtime-fuse2 || die
	strip runtime-fuse2 || die
	ls -lh runtime-fuse2 || die
	echo -ne 'AI\x02' | dd of="runtime-fuse2" bs=1 count=3 seek=8 conv="notrunc" || die # magic bytes, always do AFTER strip
	cd - || die
	mkdir -p out || die
	cp src/runtime/runtime-fuse2 out/runtime-fuse2-${ARCHITECTURE} || die
}

src_compile() {
	if ! use elibc_musl ; then
ewarn "Upstream intends that artifacts be built from a musl chroot or container."
	fi
	local ARCHITECTURE=$(get_arch)
	build_runtime
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	exeinto /usr/share/static-tools
	doexe out/runtime-fuse2-${ARCHITECTURE}
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
