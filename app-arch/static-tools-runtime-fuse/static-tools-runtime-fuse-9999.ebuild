# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/probonopd/static-tools.git"
EGIT_BRANCH="master"
SRC_URI=""

# You can build this in a musl container to get strictly musl libs.

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="runtime-fuse for static-tools"
HOMEPAGE="https://github.com/probonopd/static-tools"
LICENSE="
	all-rights-reserved
	MIT
"
IUSE="fallback-commit fuse3"
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	app-arch/static-tools-squashfuse:=[fuse3=]
	app-arch/xz-utils:=[static-libs]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-util/strace
	sys-apps/file
	sys-apps/util-linux
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/static-tools-runtime-fuse2-9999-9bf80ec-flags.patch"
	"${FILESDIR}/static-tools-runtime-fuse2-9999-9bf80ec-link-to-lzma.patch" # Required by squashfuse
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
	export GIT_COMMIT=$(cat src/runtime/version)
# /usr/share/static-tools/squashfuse/lib64/pkgconfig
	export CPPFLAGS="-I/usr/share/static-tools/squashfuse/include"
	export LDFLAGS="-L/usr/share/static-tools/squashfuse/lib64"
	cd src/runtime || die
	local fuse_slot
	local libc=$(get_libc)
	export SQUASHFUSE_INCLUDES="-I/usr/share/static-tools/${libc}/squashfuse/include"
	export SQUASHFUSE_LIBDIR="/usr/share/static-tools/${libc}/squashfuse/$(get_libdir)"
	if use fuse3 ; then
ewarn
ewarn "fuse3 is not widely portable."
ewarn
		export FUSE3_INCLUDES="-I/usr/include/fuse3"
		export FUSE3_LIBDIR="/usr/$(get_libdir)"
		fuse_slot=3
	else
		export FUSE2_INCLUDES="-I/usr/include/fuse"
		export FUSE2_LIBDIR="/usr/$(get_libdir)"
		fuse_slot=2
	fi
	make "runtime-fuse${fuse_slot}" || die
	file "runtime-fuse${fuse_slot}" || die
	strip "runtime-fuse${fuse_slot}" || die
	ls -lh "runtime-fuse${fuse_slot}" || die
	echo -ne 'AI\x02' \
		| dd of="runtime-fuse${fuse_slot}" bs=1 count=3 seek=8 conv="notrunc" \
		|| die # magic bytes, always do AFTER strip
	cd "${S}" || die
	mkdir -p out || die
	cp \
		"src/runtime/runtime-fuse${fuse_slot}" \
		"out/runtime-fuse${fuse_slot}-${ARCHITECTURE}" \
		|| die
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	local libc=$(get_libc)
	exeinto "/usr/share/static-tools/${libc}"
	local fuse_slot
	if use fuse3 ; then
		fuse_slot=3
	else
		fuse_slot=2
	fi
	doexe "out/runtime-fuse${fuse_slot}-${ARCHITECTURE}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
