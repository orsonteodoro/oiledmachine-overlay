# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..14} )

inherit flag-o-matic toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/GrapheneOS/hardened_malloc/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A hardened allocator designed for modern systems"
HOMEPAGE="
https://github.com/GrapheneOS/hardened_malloc
"
LICENSE="
	MIT
	public-domain
	|| (
		Boost-1.0
		ZLIB
	)
"
# third_party/libdivide.h - || ( Boost-1.0 ZLIB )
# chacha.c - public-domain
# See https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
MTE_COMPAT=(
	8_5-a
	8_6-a
	8_7-a
	8_8-a
	8_9-a
	9-a
	9_1-a
	9_2-a
	9_3-a
	9_4-a
)
CPU_FLAGS_ARM=(
	cpu_flags_arm_mte
	${MTE_COMPAT[@]/#/cpu_flags_arm_v}
)
SLOT="0"
IUSE="
${CPU_FLAGS_ARM[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
bindist clang custom-kernel test
"
REQUIRED_USE="
	cpu_flags_arm_mte? (
		^^ (
			${MTE_COMPAT[@]/#/cpu_flags_arm_v}
		)
	)
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
"
# @FUNCTION: gen_patched_kernel_list
# @INTERNAL
# @DESCRIPTION:
# Generate the patched kernel list
gen_patched_kernel_list() {
	local kv="${1}"
	echo "
		|| (
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/gentoo-kernel-${kv}
			>=sys-kernel/gentoo-sources-${kv}
			>=sys-kernel/vanilla-sources-${kv}
			>=sys-kernel/git-sources-${kv}
			>=sys-kernel/mips-sources-${kv}
			>=sys-kernel/pf-sources-${kv}
			>=sys-kernel/rt-sources-${kv}
			>=sys-kernel/zen-sources-${kv}
			>=sys-kernel/raspberrypi-sources-${kv}
			>=sys-kernel/gentoo-kernel-${kv}
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/vanilla-kernel-${kv}
			>=sys-kernel/linux-next-${kv}
			>=sys-kernel/asahi-sources-${kv}
			>=sys-kernel/ot-sources-${kv}
		)
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/gentoo-kernel-${kv}
		!<sys-kernel/gentoo-sources-${kv}
		!<sys-kernel/vanilla-sources-${kv}
		!<sys-kernel/git-sources-${kv}
		!<sys-kernel/mips-sources-${kv}
		!<sys-kernel/pf-sources-${kv}
		!<sys-kernel/rt-sources-${kv}
		!<sys-kernel/zen-sources-${kv}
		!<sys-kernel/raspberrypi-sources-${kv}
		!<sys-kernel/gentoo-kernel-${kv}
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/vanilla-kernel-${kv}
		!<sys-kernel/linux-next-${kv}
		!<sys-kernel/asahi-sources-${kv}
		!<sys-kernel/ot-sources-${kv}
	"
}
gen_clang_pairs() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
			)
		"
	done
}
RDEPEND="
	!custom-kernel? (
		$(gen_patched_kernel_list 6.1)
	)
	elibc_glibc? (
		>=sys-libs/glibc-2.36
	)
	elibc_musl? (
		>=sys-libs/musl-1.1.20
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(gen_clang_pairs)
	>=sys-devel/gcc-12.2.0
	dev-build/make
"
DOCS=( "CREDITS" "README.md" )

pkg_setup() {
	:
}

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf=(
		CONFIG_NATIVE=$(usex bindist false true)
	)
	if use cpu_flags_arm_mte ; then
		append-cppflags -DHAS_ARM_MTE
		local x
		for x in ${MTE_COMPAT[@]} ; do
			if use "cpu_flags_arm_v${x}" ; then
				filter-flags '-march=*'
				append-flags -march=armv${x/_/.}+memtag
				break
			fi
		done
	fi
	emake ${myconf[@]}
}

src_test() {
	emake test
}

src_install() {
	dolib.so "out/libhardened_malloc.so"
	docinto "licenses"
	dodoc "LICENSE"
}

pkg_postinst() {
	if use custom-kernel ; then
ewarn "You are responsible for using/providing a >= 6.1 Linux kernel."
	fi
}
