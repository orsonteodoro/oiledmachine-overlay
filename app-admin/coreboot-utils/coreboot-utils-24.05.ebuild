# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/coreboot-${PV}"
SRC_URI="https://coreboot.org/releases/coreboot-${PV}.tar.xz"

DESCRIPTION="A selection from coreboot/utils useful in general"
HOMEPAGE="https://www.coreboot.org/"
LICENSE="GPL-2+ GPL-2"
SLOT="0"
DEPEND="
	sys-apps/pciutils
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
"
PATCHES=(
	"${FILESDIR}/${PN}-24.02.01-flags.patch"
	"${FILESDIR}/${PN}-4.22.01-drop-inline-cpuid_ext.patch"
)

# selection from README.md that seem useful outside coreboot
coreboot_utils=(
	#cbfstool  has textrels and is not really necessary outside coreboot
	cbmem
	ifdtool
	intelmetool
	inteltool
	me_cleaner
	nvramtool
	pmh7tool
	superiotool
)

src_prepare() {
	default
	# drop some CFLAGS that hurt compilation on modern toolchains or
	# force optimisation
	# can't do this in one sed, because it all happens back-to-back
	for e in '-O[01234567s]' '-g' '-Werror' '-ansi' '-pendantic' ; do
		sed \
			-i \
			-e 's/\( \|=\)'"${e}"'\( \|$\)/\1/g' \
			util/*/Makefile{.mk,} \
			|| die
	done
}

src_compile() {
	tc-export CC
	export HOSTCFLAGS="${CFLAGS}"
	for tool in ${coreboot_utils[*]} ; do
		[[ -f util/${tool}/Makefile ]] || continue
		emake -C util/${tool} V=1
	done
}

src_install() {
	exeinto /usr/sbin
	for tool in ${coreboot_utils[*]} ; do
		[[ -e util/${tool}/${tool} ]]    && doexe util/${tool}/${tool}
		[[ -e util/${tool}/${tool}.py ]] && doexe util/${tool}/${tool}.py
		[[ -e util/${tool}/${tool}.8 ]]  && doman util/${tool}/${tool}.8
		[[ -d util/${tool}/man ]]        && doman util/${tool}/man/*.[12345678]
	done
}
