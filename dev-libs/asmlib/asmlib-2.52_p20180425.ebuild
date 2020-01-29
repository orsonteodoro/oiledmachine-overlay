# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils flag-o-matic multilib multilib-minimal

MY_P="asmlib-${PV}"
DESCRIPTION="asmlib"
HOMEPAGE="http://www.agner.org/optimize/"
SRC_URI="http://www.agner.org/optimize/asmlib.zip"

#RESTRICT="fetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

IUSE="abi_x86_32 abi_x86_64"

RDEPEND="
"

DEPEND="${RDEPEND}
	=dev-util/objconv-9999
	dev-lang/yasm
	app-arch/zip
"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	unpack "${A}"
}

src_prepare() {
	cd "${WORKDIR}/${P}"
	mkdir asm
	unzip asmlibSrc.zip -d ./asm
	mkdir lib
	mkdir obj
	mv lib* lib
	eapply "${FILESDIR}/${PN}-9999.patch"

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	cd "${WORKDIR}/${PN}-${PV}-${MULTILIB_ABI_FLAG}.${ABI}"
	if [[ ${ABI} == "x86" ]]; then
		emake `ls asm/*32.asm | sed -r -e "s|.asm|.o32|g" -e "s|asm/|obj/|g"`
		emake lib/libaelf32.a
		emake `ls asm/*32.asm | sed -r -e "s|.asm|.o32pic|g" -e "s|asm/|obj/|g"`
		emake lib/libaelf32p.a
	elif [[ ${ABI} == "amd64" ]] ; then
		emake `ls asm/*64.asm | sed -r -e "s|.asm|.o64|g" -e "s|asm/|obj/|g"`
		emake lib/libaelf64.a
	fi
}

multilib_src_install() {
	cd "${WORKDIR}/${PN}-${PV}-${MULTILIB_ABI_FLAG}.${ABI}"
	if [[ ${ABI} == "x86" ]]; then
		mkdir -p "${D}/usr/lib32"
		cp lib/libaelf32.a  "${D}/usr/lib32"
		chmod 644 "${D}/usr/lib32/libaelf32.a"
		cp lib/libaelf32p.a  "${D}/usr/lib32"
		chmod 644 "${D}/usr/lib32/libaelf32p.a"
	elif [[ ${ABI} == "amd64" ]] ; then
		mkdir -p "${D}/usr/lib64"
		cp lib/libaelf64.a  "${D}/usr/lib64"
		chmod 644 "${D}/usr/lib64/libaelf64.a"
	fi
	mkdir -p "${D}/usr/include"
	cp asmlib.h "${D}/usr/include"
	cp asmlibran.h "${D}/usr/include"
	dodoc asmlib-instructions.pdf
	dodoc license.txt
}
