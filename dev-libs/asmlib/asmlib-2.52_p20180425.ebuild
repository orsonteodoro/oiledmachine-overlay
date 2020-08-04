# Copyright 1999-2017 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="The Subroutine library is a library of optimized subroutines \
coded in assembly language."
HOMEPAGE="http://www.agner.org/optimize/"
LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~amd64-fbsd ~amd64-linux ~arm ~ia64 ~mips ~ppc ~ppc64 \
~sparc ~ia64-linux ~x86 ~x86-fbsd ~x86-freebsd ~x86-linux ~x86-macos"
SLOT="0/${PV}"
IUSE="doc"
DEPEND="dev-lang/nasm
	>=dev-util/objconv-2.51"
SRC_URI=\
"http://www.agner.org/optimize/asmlib.zip -> ${P}.zip"
inherit autotools eutils flag-o-matic multilib-minimal unpacker
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( asmlib-instructions.pdf )

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	unpack ${A}
	mkdir asm lib obj || die
	pushd asm
		unpack ../asmlibSrc.zip
	popd
	mv $(find . -name "lib*" -type f -maxdepth 1) lib || die
}

src_prepare() {
	default
	cp -a asm/asmlib.make Makefile || die
	sed -i -e 's|{asm\\}.asm{obj\\}.obj32:|obj/%.obj32: asm/%.asm|' \
		-e 's|{asm\\}.asm{obj\\}.o32:|obj/%.o32: asm/%.asm|' \
		-e 's|{asm\\}.asm{obj\\}.o32pic:|obj/%.o32pic: asm/%.asm|' \
		-e 's|{asm\\}.asm{obj\\}.obj64:|obj/%.obj64: asm/%.asm|g' \
		-e 's|{asm\\}.asm{obj\\}.o64:|obj/%.o64: asm/%.asm|' \
		-e 's|wzzip|zip|g' \
		-r -e 's|^[ ]+([a-z])|\t\1|g' \
		Makefile || die
	sed -i -r -e ':a;N;$!ba' \
		-e "s|[\$]\*\.o32\r\n|\$*.o32\r\n\tmv \$*.o32 obj\r\n|" \
		Makefile || die
	sed -i -r -e ':a;N;$!ba' \
	-e "s|[\$]\*\.o32pic\r\n|\$*.o32pic\r\n\tmv \$*.o32pic obj\r\n|" \
		Makefile || die
	sed -i -r -e ':a;N;$!ba' \
	-e "s|[\$]\*\.o64 [\$][<]|\$*.o64 \$<\r\n\tmv \$*.o64 obj\r\n|" \
		Makefile || die
	sed -i -r -e ':a;N;$!ba' \
		-e "s|[ ]+\r\n|\r\n|g" \
		Makefile || die
	multilib_copy_sources
}

multilib_src_compile() {
	cd "${BUILD_DIR}"
	if [[ "${ABI}" == "x86" ]]; then
		emake `ls asm/*32.asm | sed -r -e "s|.asm|.o32|g" \
					-e "s|asm/|obj/|g"`
		emake lib/libaelf32.a
		emake `ls asm/*32.asm | sed -r -e "s|.asm|.o32pic|g" \
					-e "s|asm/|obj/|g"`
		emake lib/libaelf32p.a
	elif [[ "${ABI}" == "amd64" ]] ; then
		emake `ls asm/*64.asm | sed -r -e "s|.asm|.o64|g" \
					-e "s|asm/|obj/|g"`
		emake lib/libaelf64.a
	fi
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	if [[ "${ABI}" == "x86" ]]; then
		dolib.a lib/libaelf32.a
		dolib.a lib/libaelf32p.a
	elif [[ "${ABI}" == "amd64" ]] ; then
		dolib.a lib/libaelf64.a
	fi
	insinto "/usr/include"
	doins asmlib.h
	doins asmlibran.h
	dodoc license.txt
}
