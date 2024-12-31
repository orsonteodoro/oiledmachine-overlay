# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

S="${WORKDIR}"
KEYWORDS="
~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~ppc-macos
~x64-macos
"

DESCRIPTION="Symlinks to use LLVM on a binutils-free system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
LICENSE="public-domain"
SLOT="${PV}"
IUSE="multilib-symlinks +native-symlinks"
RDEPEND="
	llvm-core/llvm:${SLOT}
"

src_install() {
	use native-symlinks || return

	local tools=(
		"addr2line"
		"ar"
		"dlltool"
		"nm"
		"objcopy"
		"objdump"
		"ranlib"
		"readelf"
		"size"
		"strings"
		"strip"
		"windres"
	)
	local chosts=( "${CHOST}" )
	if use multilib-symlinks; then
		local abi
		for abi in $(get_all_abis); do
			chosts+=(
				$(get_abi_CHOST "${abi}")
			)
		done
	fi

	local chost
	local dest="/usr/lib/llvm/${SLOT}/bin"
	local t
	dodir "${dest}"
	for t in "${tools[@]}"; do
		dosym \
			"llvm-${t}" \
			"${dest}/${t}"
	done
	for chost in "${chosts[@]}"; do
		for t in "${tools[@]}"; do
			dosym \
				"llvm-${t}" \
				"${dest}/${chost}-${t}"
		done
	done
}
