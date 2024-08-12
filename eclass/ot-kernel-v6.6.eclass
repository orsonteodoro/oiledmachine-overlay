# Copyright 2020-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v6.6.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 6.6.x kernel
# @DESCRIPTION:
# The ot-kernel-v6.6 eclass defines specific applicable patching for the 6.6.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v6.6/Documentation/process/changes.rst
# For compiler versions, see
# https://github.com/torvalds/linux/blob/v6.6/scripts/min-tool-version.sh#L26

# To update the array sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

# TODO:  Update patchsets
# TODO:  Update versions

# PV is for 9999 (live) context check
MY_PV="${PV}" # ver_test context
KERNEL_RELEASE_DATE="20231029" # of first stable release
KV_MAJOR=$(ver_cut 1 "${MY_PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${MY_PV}")
if ver_test "${MY_PV}" -eq "${KV_MAJOR_MINOR}" ; then
	# Normalize versioning
	UPSTREAM_PV="${KV_MAJOR_MINOR}.0" # file context
else
	UPSTREAM_PV="${MY_PV/_/-}" # file context
fi

BBRV2_COMMITS=( # oldest
1ca5498fa4c6d4d8d634b1245d41f1427482824f
#46ddceed8f8dad02a97e79c40893c385b859d1c8 # already applied
#94af063d5a381af0e2063cfd97dcce9783ed25c6 # already applied
2bab755134b19856f11a2f693f4bc40f864b00f2
50b614c0a65125d5c22fca6605fdcf88e0a9258a
41ceaf5611bf5b9384e3f2aec5b591d5734126f9
0511a3cf52a609f30c1f3f4ebb5924ddce7daca1
16ac0c6cb9ecb89e4815cfedf15d7bfd456f5ae4
7636a4ccf0f51e69a1e37bff97851dff0d344919
e46c8a0354f91d6e0d5c20f812212ddc39f0a550
1e924b1343bfa67d78ab3293c63e6cff8062dc48
73f8adbd5afbe316ed091b073c5ec2efea8b8b36
602b949a1c191599c6243a7bef62e5f6dcbc7553
3ff0ac8e14d8b260ba04a980fc62fabbf61db1aa
5ab6f739f03ff9bd533c43e7c7e0fa904b84236f
c6ef88ba01cc47ac4c6a2cfe51e15eaa4d833476
51b6837ecb1ab7d4dacdcc0be92e56ba7b99fbb8
f1097cdeb6d4b2413bbd4cf6fb824993c0808e5a
a20075fb0483240680164d7117bb48eb14c4d221
cf413174f0934b09b6537a7bec41690c4ee3a52d
6f7df9135aed2181681cc57c4dd167efed4052be
e707a7fbb949daa7214c597ebdb56dbb89466853
e77879755ff930875d0747fa5c7d94923d248a22
41b842efcd2a6b70b94068d106c1cff19f88a416
0e156e93538efa4c03b60f763ceb23bdbd6e52bc
d29d596279f9ce7a33c7cc68277886e49381ea05
1a45fd4faf30229a3d3116de7bfe9d2f933d3562
cf9b1dacabb1ef62481a452f7f169e1679e2da49
a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361
) # newest
BBRV2_KV="5.13.12"
BBRV2_VERSION="v2alpha-2022-08-28"

BBRV3_COMMITS=( # oldest
# wget -q -O - https://github.com/google/bbr/compare/ba2274dcfda859b8a27193e68ad37bfe4da28ddc^..7542cc7c41c0492a0cdbeb77e295cbfdcd9f5e11.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
#ba2274dcfda859b8a27193e68ad37bfe4da28ddc # Already applied
f601c9f8eee1585892530f6e4d847c6801b3bd2d
9cb2d74a55ce4d621666a93c59f8635a91c03975
767930979dacb584aa07b9f492f521d1f06a9bc3
4e589c6069b75bf559f59e09fa19871fd92fb44d
ade2a0e3f26b45f0de9fe9b368c9bef6609a2c8f
1f4015e7004cea97a458feb4bb847a78a3367607
f82a3d3f940c5220b37a2e0884ef399fc8b952c2
bfa26db027f29177f05a9772094ed16c8c88c488
0fa4869b2177bafeadc4a15a5d9c37dad13b147b
c20e56d9661031647ddc99c47ae8971d0a7b99b7
a5cc0063dc64f3d43c82390567ec9ddf16f4727c
4fef7ac2a9ccc4402d8d079002c65e42e9187068
dc4a1f8de1f074d505b3f539df47635af22621f9
9f5cbd8717f7c95c7def5af51972316ea92cbf7b
40f1ce936f1a1732add87dd3518fdd6e5fa0982c
aa27c22a2ebe5696b5b42002337425e2a53b2f79
5ad789ec25187629f09d7636ebd05ae1391fe916
a1d32ad82d426f29c71dd837393b3d7ea8501b5e
#a7743a2757fae9b06613c201cce6416a95d5f345 # Don't need kernel config
04ed1b49454dd2ce5d19a877b34612039a069a69
7ce213b7ed213c55a5f71b1b85bbdbb6d664f4b4
d0d8043bc8e63e445224ac29085b694b01980fff
#fea8e5afef8fee4ec491a8841b08854d8e87e503 # Don't need kernel config
c27c87b3b097705828db63a23c79a8e83f39c809
#ca7f11ebc4d4a99ccfd44be8555d505b26996c12 # Comment junk
cc97916dc4f073730d747c9a5fdfc081460ca7e1
#537b1b761e1d0036923adba7a80d3655cfff095d # Comment junk
a59d131c35ce04e7be84c3cf3fe3a7c7a4cf8457
#107339d7f48c95ae8a7461150e143fc53b08fea9 # Comment junk
7542cc7c41c0492a0cdbeb77e295cbfdcd9f5e11
)
BBRV3_KV="6.4.0" # According to Makefile, but the net folder has tagged net-6.5-rc1 commit
BBRV3_VERSION="7542cc7" # Latest commit in the branch

C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
# For CFI users, KCFI merged in 6.1
CLANG_PGO_SUPPORTED=1
CXX_STD="-std=gnu++14" # See https://github.com/torvalds/linux/blob/v6.6/tools/build/feature/Makefile#L331
DISABLE_DEBUG_PV="1.4.2"
EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	ia64
	mips
	ppc
	ppc64
	riscv
	s390
	sparc
	x86
)
EXTRAVERSION="-ot"
GCC_COMPAT=( {13..5} )
GCC_MAX_SLOT=${GCC_COMPAT[0]}
GCC_MIN_SLOT=${GCC_COMPAT[-1]}
GENPATCHES_VER="${GENPATCHES_VER:?1}"
LLVM_COMPAT=( {18..10} )
LLVM_MAX_SLOT=${LLVM_COMPAT[0]}
LLVM_MIN_SLOT=${LLVM_COMPAT[-1]}
PATCH_ALLOW_O3_COMMIT="e9c30caa3436b9ca4292e6a483186551c706f369" # id from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor ~ oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant ~ newest
PATCH_BFQ_DEFAULT="76cd9ca820dcf5780b2515ec29427e2442441854" # id from zen repo
PATCH_KCP_COMMIT="923c2322267d0034a7ede819145d4f98d4a1fd8c" # id from zen repo ; aka more-uarches
PATCH_KYBER_DEFAULT="05e785fb1ebe9f939360c993637bf9790b0933ab" # id from zen repo
PATCH_OPENRGB_COMMIT="dc61e6c116012e03d6367d8f0facc0865542ca80" # id from zen repo
PATCH_TRESOR_VER="3.18.5"
PATCH_ZEN_SAUCE_BRANDING="2ffc45fae2417c332726d98b4c75ab0227a5485e" # id from zen repo

PATCH_ZEN_SAUCE_BLACKLISTED_COMMITS=(
# Avoid merge conflict or duplicates with already upstreamed.
	${PATCH_ZEN_SAUCE_BRANDING}
# Disabled ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.
)

PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v6.6...zen-kernel:zen-kernel:6.6/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/2ffc45fae2417c332726d98b4c75ab0227a5485e^..f0d1b5037d24ee5b94bb79b790597ecf6897c447.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
2ffc45fae2417c332726d98b4c75ab0227a5485e
98c9b99c3d9351380be5a9660f7d64c3cd9aec38
dc61e6c116012e03d6367d8f0facc0865542ca80
089b5a2a3852730f69c17c05ab177d4299832224
86da31dc0b4f191e8c2a75592b853799458113ea
923c2322267d0034a7ede819145d4f98d4a1fd8c
e9c30caa3436b9ca4292e6a483186551c706f369
833eb351999cb588c87ded98e4c052f555a1a724
1554998f36ae43c9c7c1a04ed8111b5f552d5e4f
a1b7aab9dd867d77630444cbc3172247449e181c
bb3cd4dee836e57d3bd5e6370c9c88df5f501638
369ef2b1d76de9069fe0d0ff2b47f1485fb06b0e
013af604fad9724cd00724d8a8893f1824642468
c00adbbc24b3fec41c0e56691b3ad39b7e919a07
d22e337dca65bd7056e27b93c212df25a9b4c376
5f726a5d1a1f3e5e8f9a932c20625bfff1902dcb
a5772fa315ec0d8d054de294e5868511f669dd64
b1a09e7e94b1086892f6c5db11277842b8b682b1
2ec75d0127b337b4b8bc01cf8359d9d9ab90010e
017822df73d73da6edb27fb09c552fc53aa92074
06d932d7a5f858bba3354ba4fce7c2f976b2cf03
f6c3711eb1e59ab536de7fca01d37f2a0dff27b3
1c93b5c6a2f8397c935fbce3c25d1754b1da2845
d48ede166e96c0f4c5f7d7f0aba971e5801e4e1d
b89c1c4f696fb706e7857c944930845a6271664a
c9f01c61d1105c0510608e41ac63b2d1c073394d
d85161a38042b69051a546d614fd46704d0451b2
966ceff868923fefccaef09a60e9f097a0c4236d
c1ee9b8be367026cb13c8202e9297ea0de6b498d
9a3bd63bdee9819618d36dbe52aa1d1544234887
b774e19c2b9336cecdbc4a38bbc1d2a6addd9143
f0d1b5037d24ee5b94bb79b790597ecf6897c447
4deded679db72f26a78e8134688c20f9289367df
)

# FIXME:
# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
# commits [oldest] a b c d e... [newest]
# b:a
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE=(
)

# Message marked with INTERACTIVE:
PATCH_ZEN_TUNE_COMMITS=(
# Semi generated from and copy and paste:
# wget -q -O - https://github.com/torvalds/linux/compare/a5772fa315ec0d8d054de294e5868511f669dd64^..f0d1b5037d24ee5b94bb79b790597ecf6897c447.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
a5772fa315ec0d8d054de294e5868511f669dd64
b1a09e7e94b1086892f6c5db11277842b8b682b1
2ec75d0127b337b4b8bc01cf8359d9d9ab90010e
017822df73d73da6edb27fb09c552fc53aa92074
06d932d7a5f858bba3354ba4fce7c2f976b2cf03
f6c3711eb1e59ab536de7fca01d37f2a0dff27b3
1c93b5c6a2f8397c935fbce3c25d1754b1da2845
d48ede166e96c0f4c5f7d7f0aba971e5801e4e1d
b89c1c4f696fb706e7857c944930845a6271664a
c9f01c61d1105c0510608e41ac63b2d1c073394d
d85161a38042b69051a546d614fd46704d0451b2
966ceff868923fefccaef09a60e9f097a0c4236d
c1ee9b8be367026cb13c8202e9297ea0de6b498d
9a3bd63bdee9819618d36dbe52aa1d1544234887
b774e19c2b9336cecdbc4a38bbc1d2a6addd9143
f0d1b5037d24ee5b94bb79b790597ecf6897c447
4deded679db72f26a78e8134688c20f9289367df
)

RUST_PV="1.71.1"
ZEN_KV="6.6.0"

if ! [[ "${PV}" =~ "9999" ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
IUSE+="
bbrv2 bbrv3 build c2tcp cet +cfs clang clear deepcc disable_debug -exfat
+genpatches -genpatches_1510 kcfi lto nest orca pgo prjc rt -rust
shadowcallstack symlink tresor tresor_prompt tresor_sysfs zen-sauce
"

REQUIRED_USE+="
	bbrv2? (
		!bbrv3
	)
	bbrv3? (
		!bbrv2
	)
	genpatches_1510? (
		genpatches
	)
	tresor_prompt? (
		tresor
	)
	tresor_sysfs? (
		tresor
	)
"

gen_scs_exclusion() {
	local a
        for a in ${EXCLUDE_SCS[@]} ; do
                echo " ${a}? ( !shadowcallstack )"
	done
}
REQUIRED_USE+=" "$(gen_scs_exclusion)

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
	REQUIRED_USE+="
	"
fi

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" bbrv3? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v3
LICENSE+=" c2tcp? ( MIT )"
LICENSE+="
	pgo? (
		clang? (
			GPL-2
		)
	)
"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" clear? ( GPL-2 )"
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" kcfi? ( GPL-2 )"
LICENSE+=" nest? ( GPL-2 )"
LICENSE+=" prjc? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" orca? ( MIT )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" zen-sauce? ( GPL-2 )"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_kcfi_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_shadowcallstack_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*[compiler-rt,sanitize]
			=sys-libs/compiler-rt-${s}*:=
			=sys-libs/compiler-rt-sanitizers-${s}*:=[shadowcallstack?]
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_lto_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_clang_pgo_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_clang_llvm_pair() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

KCP_RDEPEND="
	clang? (
		|| (
			$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
		)
	)
	|| (
		(
			>=sys-devel/gcc-11.1
			hppa? (
				>=sys-devel/gcc-12
			)
		)
		$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
	)
"

# KCFI requires https://reviews.llvm.org/D119296 patch
GCC_PV="5.1"
KMOD_PV="13"
CDEPEND+="
	>=app-shells/bash-4.2
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.25
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=dev-build/make-3.82
	app-arch/cpio
	dev-util/pkgconf
	sys-apps/grep[pcre]
	virtual/libelf
	virtual/pkgconfig
	bzip2? (
		app-arch/bzip2
	)
	cet? (
		!clang? (
			>=sys-devel/binutils-2.31
			>=sys-devel/gcc-9
		)
	)
	cpu_flags_x86_gfni? (
		!clang? (
			>=sys-devel/binutils-2.30
			>=sys-devel/gcc-6
		)
	)
	cpu_flags_x86_tpause? (
		!clang? (
			>=sys-devel/binutils-2.31.1
			>=sys-devel/gcc-9
		)
	)
	gtk? (
		dev-libs/glib:2
		gnome-base/libglade:2.0
		x11-libs/gtk+:2
	)
	gzip? (
		>=sys-apps/kmod-${KMOD_PV}[zlib]
		app-arch/gzip
	)
	lz4? (
		app-arch/lz4
	)
	lzma? (
		app-arch/xz-utils
	)
	lzo? (
		app-arch/lzop
	)
	ncurses? (
		sys-libs/ncurses
	)
	openssl? (
		>=dev-libs/openssl-1.0.0
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	rust? (
		>=dev-util/cbindgen-0.65.1
		~virtual/rust-${RUST_PV}
	)
	xz? (
		>=sys-apps/kmod-${KMOD_PV}[lzma]
		app-arch/xz-utils
	)
	zstd? (
		>=sys-apps/kmod-${KMOD_PV}[zstd]
		app-arch/zstd
	)

	${KCP_RDEPEND}
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
	lto? (
		|| (
			$(gen_lto_rdepend 11 ${LLVM_MAX_SLOT})
		)
	)
	kcfi? (
		arm64? (
			|| (
				$(gen_kcfi_rdepend 16 ${LLVM_MAX_SLOT})
			)
		)
		amd64? (
			|| (
				$(gen_kcfi_rdepend 16 ${LLVM_MAX_SLOT})
			)
		)
	)
	pgo? (
		clang? (
			|| (
				$(gen_clang_pgo_rdepend 13 ${LLVM_MAX_SLOT})
			)
		)
	)
	s390? (
		|| (
			$(gen_clang_pgo_rdepend 15 ${LLVM_MAX_SLOT})
		)
	)
	shadowcallstack? (
		arm64? (
			|| (
				$(gen_shadowcallstack_rdepend 10 ${LLVM_MAX_SLOT})
			)
		)
	)
"

GCC_MIN_KCP_HPPA=12
GCC_MIN_KCP=11
LLVM_MIN_CLANG_PGO_S390=15
LLVM_MIN_KCFI_ARM64=16
LLVM_MIN_KCFI_AMD64=16
LLVM_MIN_KCP=12
LLVM_MIN_LTO=12
LLVM_MIN_PGO=13
LLVM_MIN_SHADOWCALLSTACK_ARM64=10

RDEPEND+="
	!build? (
		${CDEPEND}
	)
"
if ! [[ "${PV}" =~ "9999" ]] ; then
	RDEPEND+="
		!=sys-kernel/ot-sources-${KV_MAJOR_MINOR}.0.9999
	"
fi

DEPEND+="
	${RDEPEND}
"

BDEPEND+="
	build? (
		${CDEPEND}
	)
"
if ! [[ "${PV}" =~ "9999" ]] ; then
	BDEPEND+="
		!=sys-kernel/ot-sources-${KV_MAJOR_MINOR}.0.9999
	"
fi

if [[ "${PV}" =~ "9999" ]] ; then
	:
else
	KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
	SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
		${KERNEL_PATCH_URIS[@]}
	"
fi

# Not on the servers yet
NOT_READY_YET="
"

if [[ "${PV}" =~ "9999" && "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${BBRV3_SRC_URIS}
		${NEST_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	"
elif [[ "${PV}" =~ "9999" ]] ; then
	SRC_URI+="
		bbrv2? (
			${BBRV2_SRC_URIS}
		)
		bbrv3? (
			${BBRV3_SRC_URIS}
		)
		nest? (
			${NEST_URI}
		)
		rt? (
			${RT_SRC_ALT_URI}
		)
		tresor? (
			${TRESOR_AESNI_SRC_URI}
			${TRESOR_I686_SRC_URI}
			${TRESOR_README_SRC_URI}
			${TRESOR_RESEARCH_PDF_SRC_URI}
			${TRESOR_SYSFS_SRC_URI}
		)
	"
elif [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${BBRV3_SRC_URIS}
		${C2TCP_URIS}
		${CLEAR_LINUX_PATCHES_URI}
		${GENPATCHES_URI}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		${NEST_URI}
		${PRJC_SRC_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${ZEN_SAUCE_URIS}
	"
else
	SRC_URI+="
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		bbrv2? (
			${BBRV2_SRC_URIS}
		)
		bbrv3? (
			${BBRV3_SRC_URIS}
		)
		c2tcp? (
			${C2TCP_URIS}
		)
		clear? (
			${CLEAR_LINUX_PATCHES_URI}
		)
		deepcc? (
			${C2TCP_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		nest? (
			${NEST_URI}
		)
		orca? (
			${C2TCP_URIS}
		)
		prjc? (
			${PRJC_SRC_URI}
		)
		rt? (
			${RT_SRC_ALT_URI}
		)
		tresor? (
			${TRESOR_AESNI_SRC_URI}
			${TRESOR_I686_SRC_URI}
			${TRESOR_README_SRC_URI}
			${TRESOR_RESEARCH_PDF_SRC_URI}
			${TRESOR_SYSFS_SRC_URI}
		)
		zen-sauce? (
			${ZEN_SAUCE_URIS}
		)
	"
fi

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	if [[ "${PV}" =~ "9999" ]] ; then
ewarn
ewarn "You are using the live kernel sources.  This may result in data loss,"
ewarn "data format incompatibilities, or vulnerabilities."
ewarn
ewarn "The live sources is intended for people that want to submit commits or"
ewarn "patches to upstream, to use security fixes, for ebuild maintainers or"
ewarn "modders to smooth out updates before stable."
ewarn
	fi

	if use shadowcallstack && ! use arm64 ; then
ewarn
ewarn "ShadowCallStack is only offered on the arm64 platform."
ewarn
	fi

	if use tresor ; then
		if [[ -n "${OT_KERNEL_DEVELOPER}" && "${OT_KERNEL_DEVELOPER}" == "1" ]] ; then
			:
		else
ewarn
ewarn "XTS support for TRESOR has been dropped for the ${KV_MAJOR_MINOR}"
ewarn "series.  Use the older versions 4.19.x, 5.4.x, 5.10.x to convert"
ewarn "xts(tresor) -> cbc(tresor)."
ewarn
ewarn "CTR support for TRESOR is currently on hold for the ${KV_MAJOR_MINOR}"
ewarn "series.  Use the older versions 4.19.x, 5.4.x, 5.10.x for working"
ewarn "ctr(tresor)."
ewarn
		fi
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
ot-kernel_apply_tresor_fixes() {
	if [[ -z "${TRESOR_MAX_KEY_SIZE}" ]] ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			TRESOR_MAX_KEY_SIZE="256"
		else
			TRESOR_MAX_KEY_SIZE="128"
		fi
	fi

	local tresor_patch_target # <arch>_<type>_<max_key_size>
	if [[ -n "${TRESOR_TARGET_OVERRIDE}" ]] ; then
		# For development
		tresor_patch_target="${TRESOR_TARGET_OVERRIDE}"
	elif [[ "${arch}" == "x86_64" ]] && ot-kernel_use cpu_flags_x86_aes ; then
		tresor_patch_target="x86_64_aesni_256"
	elif [[ "${arch}" == "x86_64" ]] && [[ "${TRESOR_MAX_KEY_SIZE}" == "192" || "${TRESOR_MAX_KEY_SIZE}" == "256" ]] ; then
		tresor_patch_target="x86_64_generic_256"
	elif [[ "${arch}" == "x86_64" ]] && [[ "${TRESOR_MAX_KEY_SIZE}" == "128" ]] ; then
		tresor_patch_target="x86_64_generic_128"
	elif [[ "${arch}" == "x86" ]] ; then
		tresor_patch_target="x86_generic_128"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

        _dpatch "${PATCH_OPTS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPTS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-6.6-v4_i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-6.6-v4_aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.6.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi

	# tresor-xts-setkey update applied in these below
	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-i686-256-v1.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-aesni-v1.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-i686-128-v1.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-glue_helper-for-5.15_x86_64.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-for-5.15_i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_256" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-256-for-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-128-for-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-for-6.1_aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-rename-to-freezer_active-for-6.1.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-linux-stdarg-for-6.1_x86_64.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-explicit-int-dont_switch-arg-for-6.1.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-add-crypto-header-for-6.6.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-change-to-for_each_process_thread-for-6.6.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-256-for-6.6_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-128-for-6.6_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		# Already applied in tresor-drop-xts-and-use-ctr-template-for-5.15_i686.patch
		:
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-256-for-6.6_aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-kconfig-crypto-simd-for-6.1.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-access_ok-for-6.6.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		:
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-add-crypto-header-to-tresor_glue-for-6.6_aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-cpuid-aesni-check-for-6.1.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-256-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
	# Patch reuse was tested okay.
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.15_x86_64.patch"
	#elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
	#	Only 64-bit X86 supported.
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
einfo
einfo "You may require the genkernel 4.x series to build the ${KV_MAJOR_MINOR}.x"
einfo "kernel series."
einfo
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
	:
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# The purpose of this function is to apply hunk fixes, resolve merge conflicts,
# or mispatches.
#
# Typical patch patterns:
#
# 1. Apply original patch with _tpatch, then apply a patch to fix hunks with
#    _dpatch.  [_tpatch is patch with no die.  _dpatch is patch with die on
#    fail.]  Essentially, we apply all the correct hunks first and replace the
#    the broken hunks afterwards.
# 2. Replace the original patch with a completely updated patch.
# 3. Copy the original patch then slightly modify and apply the patch.
#    (Modifications may fix the path changes between minor versions.)
#
# The reasons for each above:
#
# 1.  To see where the ebuild maintainer introduced error and to tell upstream
#     how to fix their patchset.  It allows the users to code review the fix.
# 2.  The context has mostly changed outside the edited parts or a mispatch
#     occurred as in hunk placed in the wrong place.
# 3.  Fix renamed files.
#
ot-kernel_filter_patch_cb() {
	local path="${1}"
	local msg_extra="${2}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${path}"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"

	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"

	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes

	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-v9-fix-for-6.6.16.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-__no_profile-for-6.5.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-kconfig-depends-not-ARCH_WANTS_NO_INSTR-or-CC_HAS_NO_PROFILE_FN_ATTR.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-support-profraw-v6-to-v8.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-support-profraw-v9.patch"

	elif [[ "${path}" =~ "kernel-locking-Use-a-pointer-in-ww_mutex_trylock.patch" ]] ; then
		: # already applied

	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-50b614c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-50b614c-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-41ceaf5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-41ceaf5-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-3ff0ac8.patch" ]] ; then
		# Dropped hunk from net/ipv4/bpf_tcp_ca.c
		_tpatch "${PATCH_OPTS}" "${path}" 3 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-3ff0ac8-fix-for-6.3.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-use-get_random_u32_below-for-6.2.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-cf9b1da.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cf9b1da-fix-for-6.3.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-1e924b1.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-1e924b1-fix-for-6.5.2.patch"

	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-ba2274d.patch" ]] ; then
		# Already added upstream
		:
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-9cb2d74.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-9cb2d74-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-c20e56d.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-c20e56d-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-a5cc006.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-a5cc006-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-4fef7ac.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-4fef7ac-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-40f1ce9.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-40f1ce9-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-aa27c22.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-aa27c22-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-6e321d1-6.4.0-a1d32ad.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-a1d32ad-fix-for-6.6.0-git-6bc986a.patch"

	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		if use bbrv3 ; then
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-6-22-orca-c2tcp-0521-bbr3-compat.patch"
		elif use bbrv2 ; then
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-6-22-orca-c2tcp-0521-bbr2-compat.patch"
		else
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-6-22-orca-c2tcp-0521.patch"
		fi
	elif [[ "${path}" =~ "zen-sauce-6.6.0-369ef2b.patch" ]] && [[ "${PV}" =~ "9999" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/zen-sauce-6.6.0-369ef2b-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "zen-sauce-6.6.0-1554998.patch" ]] ; then
		if ot-kernel_use clear ; then
			# Duplicate of 0133-novector.patch
			:
		else
			_dpatch "${PATCH_OPTS}" "${path}"
		fi
	elif [[ "${path}" =~ "zen-sauce-6.6.0-a1b7aab.patch" ]] ; then
		if ot-kernel_use clear ; then
			# Duplicate of 0162-extra-optmization-flags.patch
			:
		else
			_dpatch "${PATCH_OPTS}" "${path}"
		fi

	elif [[ "${path}" =~ "Nest_v6.6.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/nest-6.6-fix-for-6.6.7.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "app-arch/tar" "1.28" ""
	_ot-kernel_check_versions "dev-util/global" "6.6.5" "" # gtags
	_ot-kernel_check_versions "dev-util/pahole" "1.16" "CONFIG_DEBUG_INFO_BTF"
	_ot-kernel_check_versions "net-dialup/ppp" "2.4.0" "CONFIG_PPP"
	_ot-kernel_check_versions "net-firewall/iptables" "1.4.2" "CONFIG_NETFILTER"
	_ot-kernel_check_versions "net-fs/nfs-utils" "1.0.5" "NFS_FS"
	_ot-kernel_check_versions "sys-apps/pcmciautils" "004" "CONFIG_PCMCIA"
	_ot-kernel_check_versions "sys-boot/grub" "0.93" ""
	_ot-kernel_check_versions "sys-fs/btrfs-progs" "0.18" "CONFIG_BTRFS_FS"
	_ot-kernel_check_versions "sys-fs/e2fsprogs" "1.41.4" "CONFIG_EXT2_FS"
	_ot-kernel_check_versions "sys-fs/jfsutils" "1.1.3" "CONFIG_JFS_FS"
	_ot-kernel_check_versions "sys-fs/reiserfsprogs" "3.6.3" "CONFIG_REISERFS_FS"
	_ot-kernel_check_versions "sys-fs/squashfs-tools" "4.0" "CONFIG_SQUASHFS"
	_ot-kernel_check_versions "sys-fs/quota" "3.09" "CONFIG_QUOTA"
	_ot-kernel_check_versions "sys-fs/xfsprogs" "2.6.0" "CONFIG_XFS_FS"
	_ot-kernel_check_versions "sys-process/procps" "3.2.0" ""
	_ot-kernel_check_versions "virtual/udev" "081" ""
}

# @FUNCTION: ot-kernel_get_llvm_min_slot
# @DESCRIPTION:
# Get the min slot for clang
ot-kernel_get_llvm_min_slot() {
	local _llvm_min_slot

	local wants_kcp=0
	local wants_kcp_rpi=0

	if [[ "${CFLAGS}" =~ "-march" ]] ; then
		wants_kcp=1
	fi
	if [[ -n "${X86_MICROARCH_OVERRIDE}" ]] ; then
		wants_kcp=1
	fi
	if [[ "${CFLAGS}" =~ "-mcpu=cortex-a72" ]] ; then
		wants_kcp_rpi=1
	fi

	local kcp_provider=$(ot-kernel_get_kcp_provider)

	# Descending sort
	if has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_ARM64} # 16
	elif has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi && [[ "${arch}" == "amd64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_AMD64} # 16
	elif has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo && [[ "${arch}" == "s390" ]] ; then
		_llvm_min_slot=${LLVM_MIN_CLANG_PGO_S390} # 15
	elif has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo ; then
		_llvm_min_slot=${LLVM_MIN_PGO} # 13
	elif has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ; then
		_llvm_min_slot=${LLVM_MIN_LTO} # 12
	elif (( ${wants_kcp} == 1 )) ; then
		_llvm_min_slot=${LLVM_MIN_KCP} # 12
	elif has shadowcallstack ${IUSE_EFFECTIVE} && ot-kernel_use shadowcallstack && [[ "${arch}" == "amd64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_SHADOWCALLSTACK_ARM64} # 10
	else
		_llvm_min_slot=${LLVM_MIN_SLOT} # 10
	fi
	echo "${_llvm_min_slot}"
}

# @FUNCTION: ot-kernel_get_gcc_min_slot
# @DESCRIPTION:
# Get the min slot for gcc
ot-kernel_get_gcc_min_slot() {
	local _gcc_min_slot
	local kcp_provider=$(ot-kernel_get_kcp_provider)
	if [[ "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "parisc" || "${arch}" == "parisc64" ]] ; then
		# hppa
		_gcc_min_slot=${GCC_MIN_KCP_HPPA} # 12
	elif grep -q -E -e "^CONFIG_INIT_STACK_ALL_ZERO=y" "${path_config}" ; then
	# Prevent:
	# <redacted>-pc-linux-gnu-gcc-11: error: unrecognized command-line option '-ftrivial-auto-var-init=zero'
		_gcc_min_slot=12
	elif [[ "${kcp_provider}" == "graysky2" ]] ; then
		# hppa
		_gcc_min_slot=${GCC_MIN_KCP} # 11
	else
		_gcc_min_slot=${GCC_MIN_SLOT} # 5
	fi
	echo "${_gcc_min_slot}"
}
