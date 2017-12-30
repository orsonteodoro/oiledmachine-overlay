# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib-minimal multilib-build multilib

DESCRIPTION="Virtual for Rust language compiler"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="|| ( =dev-lang/rust-${PV}*[${MULTILIB_USEDEP}] =dev-lang/rust-bin-${PV}*[${MULTILIB_USEDEP}] )"

_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE+=" ${_ABIS}"
REQUIRED_USE="^^ ( ${_ABIS} )"

S="${WORKDIR}"

