# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5

LOCKFILE_VER="1.2"
CPU_FLAGS_X86=(
	cpu_flags_x86_avx2
)
WEBKIT_PV="621.1.11"

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}"
SRC_URI="
https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz
"

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one"
HOMEPAGE="
https://bun.sh/
https://github.com/oven-sh/bun
"
LICENSE="
	(
		BSD
		BSD-2
		CC0-1.0
		public-domain
	)
	(
		BSD
		ISC
		MIT
		openssl
		SSLeay
	)
	Apache-2.0
	BSD
	BSD-2
	icu-72.1
	LGPL-2
	LGPL-2.1
	MIT
	ZLIB
	|| (
		MIT
		|| (
			Artistic
			GPL-1+
		)
	)
	|| (
		BSD
		GPL-2
	)
"
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}"
IUSE+="
${CPU_FLAGS_X86[@]}
doc ebuild_revision_1
"
RDEPEND+="
	sys-apps/bun-webkit:${LOCKFILE_VER}-${WEBKIT_PV%%.*}
	sys-apps/bun-webkit:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/cmake
"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWEBKIT_PATH="/usr/share/bun-webkit/${LOCKFILE_VER}-${WEBKIT_PV%%.*}"
	)
	ARCH="${arch}" cmake_src_configure
}

get_bun_arch() {
	if [[ "${ELIBC}" == "glibc" ]] ; then
		echo "glibc"
	elif [[ "${ELIBC}" == "musl" ]] ; then
		echo "musl"
	else
eerror "ELIBC=${ELIBC} is not supported"
		die
	fi
}

src_compile() {
	cmake_src_compile
}

src_install() {
	local d=$(get_dir)
	pushd "${d}" >/dev/null 2>&1 || die
		exeinto "/usr/bin"
		doexe "bun"
	popd >/dev/null 2>&1 || die
	pushd "${WORKDIR}/bun-bun-v${PV}" >/dev/null 2>&1 || die
		docinto "licenses"
		dodoc "LICENSE.md"
		if use doc ; then
			docinto "readmes"
			dodoc "README.md"
			insinto "/usr/share/${PN}"
			doins -r "docs"
		fi
	popd >/dev/null 2>&1 || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
