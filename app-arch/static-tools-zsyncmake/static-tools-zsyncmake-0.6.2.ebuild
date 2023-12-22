# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

SRC_URI="
	http://zsync.moria.org.uk/download/zsync-${PV}.tar.bz2
"
S="${WORKDIR}/zsync-${PV}"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="zsyncmake for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	http://zsync.moria.org.uk/server
"
LICENSE="
	Artistic-2
"
IUSE=""
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	dev-libs/glib[static-libs]
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

	# Build static zsyncmake
	find . -type f -exec sed -i -e 's|off_t|size_t|g' {} \; || die
	./configure \
		CFLAGS=-no-pie \
		LDFLAGS=-static \
		--build=$(arch)-unknown-linux-gnu \
		|| die
	emake -j$(nproc) || die
	file zsyncmake || die
	strip zsyncmake || die
	mkdir -p out || die
	cp zsyncmake out/zsyncmake-${ARCHITECTURE} || die
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	exeinto /usr/share/static-tools
	doexe out/zsyncmake-${ARCHITECTURE}
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
