# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit toolchain-funcs subversion eutils git-r3 \
	multilib multilib-minimal multilib-build

DESCRIPTION="okcupid-pidgin"
HOMEPAGE="https://code.google.com/p/okcupid-pidgin/"
COMMIT="b2ff1ecd2f397f0d358fb1a825c73992bc5f4efb"
SRC_URI="https://github.com/EionRobb/okcupid-pidgin/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE+=" ${_ABIS}"
#REQUIRED_USE="^^ ( ${_ABIS} )"

RDEPEND="net-im/pidgin
         dev-libs/json-glib"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	EPATCH_OPTS="-F 500" epatch "${FILESDIR}/${PN}.patch"
	cd "${S}"
	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	if [[ "${ABI}" == "amd64" ]] ; then
		emake libokcupid64.so CC="$(tc-getCC)" || die "emake failed"
	elif [[ "${ABI}" == "x86" ]] ; then
		emake libokcupid.so CC="$(tc-getCC)" || die "emake failed"
	fi
}

multilib_src_install() {
	insinto "/usr/$(get_libdir)/purple-2/"
	if [[ "${ABI}" == "amd64" ]] ; then
		doins libokcupid64.so
	elif [[ "${ABI}" == "x86" ]] ; then
		doins libokcupid.so
	fi
	insinto "/usr/share/pixmaps/pidgin/protocols/16"
	doins icons/16/okcupid.png
	insinto "/usr/share/pixmaps/pidgin/protocols/22"
	doins icons/22/okcupid.png
	insinto "/usr/share/pixmaps/pidgin/protocols/48"
	doins icons/48/okcupid.png
}
