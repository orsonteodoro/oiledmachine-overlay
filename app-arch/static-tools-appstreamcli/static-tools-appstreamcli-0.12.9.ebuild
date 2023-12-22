# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

LMDB_PV="0.9.29"
SRC_URI="
	https://git.openldap.org/openldap/openldap/-/archive/LMDB_${LMDB_PV}/openldap-LMDB_${LMDB_PV}.tar.gz
	https://github.com/ximion/appstream/archive/v${PV}.tar.gz -> appstream-${PV}.tar.gz
"
S_LMDB="${WORKDIR}/openldap-LMDB_${LMDB_PV}/libraries/liblmdb"
S="${WORKDIR}/appstream-${PV}"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="appstreamcli for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://github.com/ximion/appstream
"
LICENSE="
	LGPL-2.1+
	GPL-2+
"
IUSE=""
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	dev-libs/glib:=[static-libs]
	dev-libs/libxml2
	dev-util/gperf
	dev-python/pyyaml
"
# pyyaml should be static
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-util/meson
	dev-util/strace
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


	# Build appstreamcli
	# Compile liblmdb from source as Alpine only ship it as a .so
	cd "${S_LMDB}" || die
	emake liblmdb.a || die
	insinto /usr/share/static-tools/lmdb/lib
	doins liblmdb.a
	insinto /usr/share/static-tools/lmdb/include
	doins lmdb.h
	cd - || die
	cd "${S}" || die
	# Ask for static dependencies
	sed -i -E -e "s|(dependency\('.*')|\1, static: true|g" meson.build || die
	# Disable po, docs and tests
	sed -i -e "s|subdir('po/')||" meson.build || die
	sed -i -e "s|subdir('docs/')||" meson.build || die
	sed -i -e "s|subdir('tests/')||" meson.build || die
	# -no-pie is required to statically link to libc
	CFLAGS="-no-pie" \
	LDFLAGS="-static" \
	meson setup build \
		--buildtype=release \
		--default-library=static \
		--prefix="$(pwd)/prefix" \
		--strip \
		-Db_lto=true \
		-Db_ndebug=if-release \
		-Dstemming=false \
		-Dgir=false \
		-Dapidocs=false \
		|| die
	# Install in a staging enviroment
	meson install -C build || die
	file prefix/bin/appstreamcli || die
	mkdir -p out || die
	cp prefix/bin/appstreamcli out/appstreamcli-${ARCHITECTURE} || die
}

src_install() {
	local ARCHITECTURE=$(get_arch)
	exeinto /usr/share/static-tools
	doexe out/appstreamcli-${ARCHITECTURE}
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
