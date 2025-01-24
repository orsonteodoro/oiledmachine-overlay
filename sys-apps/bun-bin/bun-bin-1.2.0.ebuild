# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LOCKFILE_VER="1.2"

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}"
SRC_URI="
	https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz
	arm64? (
		elibc_glibc? (
https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-aarch64.zip
		)
		elibc_musl? (
https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-aarch64-musl.zip
		)
	)
	amd64? (
		elibc_glibc? (
https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64.zip
		)
		elibc_musl? (
https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64-musl.zip
		)
	)
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
		perl
		MIT
	)
	|| (
		BSD
		GPL-2
	)
"
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}"
IUSE+=" doc ebuild_revision_1"
CDEPEND+="
	!sys-apps/npm:0
	|| (
		>=net-libs/nodejs-20.17.0:20[corepack,ssl?]
		>=net-libs/nodejs-22.9.0[corepack,ssl?]
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

src_unpack() {
	unpack ${A}
}

get_dir() {
	if [[ "${ABI}" == "arm64" && "${ELIBC}" == "musl" ]] ; then
		echo "bun-linux-aarch64-musl"
	elif [[ "${ABI}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
		echo "bun-linux-aarch64"
	elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "musl" ]] ; then
		echo "bun-linux-x64-musl"
	elif [[ "${ABI}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
		echo "bun-linux-x64"
	else
eerror "ABI=${ABI} and ELIBC=${ELIBC} not supported"
		die
	fi
}

src_install() {
	local d=$(get_dir)
	pushd "${d}" >/dev/null 2>&1 || die
		exeinto "/opt/bun"
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
