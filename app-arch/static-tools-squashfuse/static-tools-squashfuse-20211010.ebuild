# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="e51978cd6bb5c4d16fae9eee43d0b258f570bb0f"
SRC_URI="
https://github.com/vasi/squashfuse/archive/e51978c.tar.gz -> squashfuse-${COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/squashfuse-${COMMIT}"

# You can build this in a musl container to get strictly musl libs.

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="squashfuse for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://github.com/vasi/squashfuse
"
LICENSE="
	BSD-2
"
IUSE="-fuse3"
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
# A uses fuse-2.9.9, U supports only fuse-2.9.9
RDEPEND+="
	!fuse3? (
		=sys-fs/fuse-2*:=[static-libs]
	)
	fuse3? (
		=sys-fs/fuse-3*:=[static-libs]
	)
	sys-libs/zlib:=[static-libs]
	app-arch/zstd:=[static-libs]
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
	"${FILESDIR}/static-tools-squashfuse-20211010-fuse3-enablement.patch"
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
	if use fuse3 ; then
ewarn
ewarn "You are enabling the fuse3 USE flag which is not portable or widely used."
ewarn
	fi
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

	export PKG_CONFIG_PATH="${ESYSROOT}/usr/$(get_libdir)/pkgconfig"
	# Build static squashfuse
	./autogen.sh || die
	./configure --help || die
	local fuse3_arg=$(usex fuse3 "--enable-fuse3" "--disable-fuse3")
	local libc=$(get_libc)
	./configure \
		CFLAGS="-no-pie" \
		LDFLAGS="-static" \
		${fuse3_arg} \
		--prefix="/usr/share/static-tools/${libc}/squashfuse" \
		--datarootdir="/usr/share/static-tools/${libc}/squashfuse/share" \
		--libdir="/usr/share/static-tools/${libc}/squashfuse/$(get_libdir)" \
		|| die
	emake || die
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	emake DESTDIR="${ED}" install || die
	local libc=$(get_libc)
	insinto "/usr/share/static-tools/${libc}/squashfuse/include"
	doins *.h
	insinto "/usr/share/static-tools/${libc}/squashfuse/include/squashfuse"
	doins fuseprivate.h
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
