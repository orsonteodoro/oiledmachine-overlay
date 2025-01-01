# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

LMDB_PV="0.9.29"
PYTHON_COMPAT=( python3_{10..13} pypy3 )
S_LMDB="${WORKDIR}/openldap-LMDB_${LMDB_PV}/libraries/liblmdb"

inherit python-r1

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/appstream-${PV}"
SRC_URI="
	https://git.openldap.org/openldap/openldap/-/archive/LMDB_${LMDB_PV}/openldap-LMDB_${LMDB_PV}.tar.gz
	https://github.com/ximion/appstream/archive/v${PV}.tar.gz -> appstream-${PV}.tar.gz
"

DESCRIPTION="appstreamcli for static-tools"
HOMEPAGE="
	https://github.com/probonopd/static-tools
	https://github.com/ximion/appstream
"
LICENSE="
	LGPL-2.1+
	GPL-2+
"
IUSE="-libcxx"
REQUIRED_USE+="
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	dev-libs/glib:=[static-libs]
	dev-libs/icu:=[static-libs]
	dev-libs/libffi:=[static-libs]
	dev-libs/libxml2
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-util/gperf
	sys-apps/util-linux:=[static-libs]
"
# pyyaml should be static
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
	dev-build/meson
	dev-debug/strace
	sys-apps/file
	sys-apps/util-linux
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
	python_setup
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

	unset SCCACHE_DIR
	unset RUSTC_WRAPPER

	# Build appstreamcli
	# Compile liblmdb from source as Alpine only ship it as a .so
	cd "${S_LMDB}" || die
	emake liblmdb.a || die

	cd "${S}" || die
	# Ask for static dependencies
	sed -i -E -e "s|(dependency\('.*')|\1, static: true|g" meson.build || die
	# Disable po, docs and tests
	sed -i -e "s|subdir('po/')||" meson.build || die
	sed -i -e "s|subdir('docs/')||" meson.build || die
	sed -i -e "s|subdir('tests/')||" meson.build || die
	# -no-pie is required to statically link to libc

	local LIBSTDCXX_LIBS=""
	local LIBCXX_LIBS=""
	if use libcxx ; then
		LIBCXX_LIBS="-lc++"
	else
		LIBSTDCXX_LIBS="-lstdc++"
	fi

	CFLAGS="-no-pie -I'${WORKDIR}/openldap-LMDB_${LMDB_PV}/libraries/liblmdb'" \
	CPPFLAGS="-DU_STATIC_IMPLEMENTATION" \
	LDFLAGS="-static -L'${WORKDIR}/openldap-LMDB_${LMDB_PV}/libraries/liblmdb' ${LIBSTDCXX_LIBS} ${LIBCXX_LIBS}" \
	meson setup build \
		-Dbuildtype=release \
		--default-library=static \
		--prefix="/prefix" \
		--strip \
		-Db_lto=true \
		-Db_ndebug=if-release \
		-Dstemming=false \
		-Dgir=false \
		-Dapidocs=false \
		|| die
	# Install in a staging enviroment
	mkdir -p out || die
	DESTDIR="out" meson install -C build || die
	file "build/out/prefix/bin/appstreamcli" || die
	cp "build/out/prefix/bin/appstreamcli" "out/appstreamcli-${ARCHITECTURE}" || die
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
	doexe "out/appstreamcli-${ARCHITECTURE}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
