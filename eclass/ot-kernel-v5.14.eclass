# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.14.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.14.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.14 eclass defines specific applicable patching for the 5.14.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="40fecdec8599c28fc9d1003c301d2202e39db8a6"
PATCH_BBRV2_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_BBRV2_COMMIT_A="5da5aaa858dd7fac0afd439de4ff7565a00d4f32" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="fc632709b757850d62d2b295f749e80c19093da3" # descendant / newest
PATCH_CFI_X86_COMMIT_A_PARENT="d0ee23f9d78be5531c4b055ea424ed0b489dfe9b"
PATCH_CFI_X86_COMMIT_A="e4a7957ae2ae2b22476bdf71199afa5a2bc9142b" # ancestor / oldest
PATCH_CFI_X86_COMMIT_D="5140d56af9b8ee5584a90014c86ce6b174a7653f" # descendant / newest
PATCH_CK_COMMIT_A_PARENT=""
PATCH_CK_COMMIT_A="" # ancestor / oldest
PATCH_CK_COMMIT_D="" # descendant / newest (EOL 5.12-ck is the last patchset)
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # newest
PATCH_FUTEX_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_FUTEX_COMMIT_A="cba204184fc7af716d29bb3659ccfe9d6c84ecd0" # ancestor / oldest
PATCH_FUTEX_COMMIT_D="bff1c1603cc294ddcbbd7612b1806d7c8f55e7bd" # descendant / newest
PATCH_FUTEX2_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_FUTEX2_COMMIT_A="cc20b5f100d4f345e0b090a7a76daea256e6097d" # ancestor / oldest
PATCH_FUTEX2_COMMIT_D="fa99bbb4cf0a5c6ed18cf58ecca678e82e008cb9" # descendant / newest
PATCH_KCP_COMMIT="b9369c4a4f43b8cf182c9726dc5c7e6eb4115722"
PATCH_LRU_GEN_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_LRU_GEN_COMMIT_A="1d1d59e750744b3c6b7cb51006cb59392e2fef65" # ancestor / oldest
PATCH_LRU_GEN_COMMIT_D="58423b0ba935bb76ff3f6754703e8fb8533ecae3" # descendant / newest
PATCH_ZEN_MUQSS_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_ZEN_MUQSS_COMMIT_A="8ded360073512fd443a98a988a1e96fa265fe124" # ancestor / oldest
PATCH_ZEN_MUQSS_COMMIT_D="9b274548a67017db47e964756f0cc903bf69c3b6" # descendant / newest
PATCH_ZEN_LRU_GEN_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_ZEN_LRU_GEN_COMMIT_A="502566438ca9e8ad3d32107e3ef6ace65e307a0c" # ancestor / oldest
PATCH_ZEN_LRU_GEN_COMMIT_D="604cd836f7e6aff5346527d869ecac3868135aea" # descendant / newest
# Corresponding to [5.15-rc1, x86-cfi-v3]
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant
PATCH_ZENSAUCE_COMMITS=(
6c19e74f92407b935262366c90fcd1259d939fcf
40cbbf2a2215c36d24676746ae98b20c77806355
7ab2a592090c1cf843bb10d267bb585317d0e289
b9369c4a4f43b8cf182c9726dc5c7e6eb4115722
40fecdec8599c28fc9d1003c301d2202e39db8a6
04fcedd90e574042883f5ba655903fcfc7f2cfae
67f2b942ab4f2eab6dfafee23ad4c27575ec95f3
fed9cf973d6c74ed9736d2b95c42075894d53ed2
39376e2c9e2d20de215dc154cc27c3a1c44e0288
5ce4b72d373ab3fad2b1cc45450f59370e6ffb5a
1a931f871e849e85123de286919641e6c4d502e4
76933ae58372a45bfad754d242ff2124758b07de
0902f17304380ccf89112984a099b08505f3535c
a655ad71e371e811943afdb533d52946155a2a6b
149d85a8e32e7802340e8288829a126d711d8e58
a04d09fad3419e0db39db29f9fd35b3eed5948a6
c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73
2a92000db1307319f691020858a443495e40f7e5
c7ab6359906def4fbdbfd2510f8038826f27060f
4c7ea2cb54eaa2d1d76722b4f7b2e28a837ef138
f69969a3ab15a2b66a535791dc5c23242099fce3
2aeeaeba306699007a9a9295a2f43f639b2415d0
1c8509527a7a90511fdefba4df904fc5c2fa543d
f05a76bbac2ea8737c5b6a64a1e842da8c52a146
146ae111c1c1a112b0f267a0bd72794cc3c70013
0d419b3e995b3dfbd5f9261d1604a3c6656c825d
2c10658071555b23a397ed3a9c0969a4f36d1f12
5ae84d6ea7fa6c05bb9017baab3a3de93d707149
5ad20a83f37c759f74c00397fd144c85e882b9a6
1cef3393a74deef8acc864392e9e73c3857fbd59
f79f04d6d36298431febf69d06dd0ac4e3fbb337
)

# ancestor / oldest, descendant / newest
# Diced to let user can choose between UKSM, KSWAPD, OOMD
PATCH_DEFER_MADVISE_COMMIT=\
"519eab42710cd0b9abab9dc4d5a313f80b66ecec"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73:39376e2c9e2d20de215dc154cc27c3a1c44e0288
1cef3393a74deef8acc864392e9e73c3857fbd59:5ad20a83f37c759f74c00397fd144c85e882b9a6
)
#ZEN: INTERACTIVE: Use BFQ as our elevator (c6d1cd) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (39376e2)
# fixup! ZEN: INTERACTIVE: Increase max number of tasks rebalanced at once (1cef339) needs
# ZEN: Reduce up threshold for all non-muqss schedulers (5ad20a8)

PATCH_ZENTUNE_COMMITS=(
a04d09fad3419e0db39db29f9fd35b3eed5948a6
c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73
2a92000db1307319f691020858a443495e40f7e5
c7ab6359906def4fbdbfd2510f8038826f27060f
4c7ea2cb54eaa2d1d76722b4f7b2e28a837ef138
f69969a3ab15a2b66a535791dc5c23242099fce3
2aeeaeba306699007a9a9295a2f43f639b2415d0
1c8509527a7a90511fdefba4df904fc5c2fa543d
5ae84d6ea7fa6c05bb9017baab3a3de93d707149
1cef3393a74deef8acc864392e9e73c3857fbd59
f79f04d6d36298431febf69d06dd0ac4e3fbb337
)
PATCH_BFQ_DEFAULT="c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73"
PATCH_ZENSAUCE_BL=(
	${PATCH_KCP_COMMIT}
)

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

ZEN_MUQSS_COMMITS=(
8ded360073512fd443a98a988a1e96fa265fe124
8a76ca15ee7f8e596a2ba69636c224b91000da65
0675730a57fe0d8e15bf1f473e3140a23f452d3a
3e15c06a6ec87197145d7b72ca375881648f568e
ab0fc26bc0c024d22a308ae63a9400df4eea19fb
0c52e6745e8384802a99e59347b47845108f45e8
34c0ab34802a189ac7fc20473729f69cde964891
b44e58da8ed481ac608b3e78f74a85e7d91c1a24
a842bb58f27a847d5f4069f429e05d1167b75340
10222c78262730b91a5e150757a99ee516f93dbf
a2ccbab45f1d3ff4bf5d41b270e6b771490d8fae
31893dcb7295fd17af9277103d16cf9565f2f105
1d5feee490a36788d1929a57e02d649b98f10e0d
73b30acfbe4524667d961cb2e99e4eb50b84bde0
a1b3431fbd525c30c52a138a72dfba17e4c31a63
6e4aab0c82cbf44dae51a91fd7633b49b1f4114d
339325b9f946004ed40b0fc03c393197391a70b6
eab5dba7687b961da03f552ac2b0db42dd1655b7
335141fd7c7ef892e928e83c9448f99dd7f663e4
aed98074a89d6fedbde4c42eb18c9eee5bf7f960
8ca62f8e77cd3059c4d53dadf52f28709f7d958d
10b79808773f52ab90e1620ab22d63aa3c2ade2a
23173edfedbc9611a828360ba3c49d5d3782fb72
1ecfdc3687207a970d5268e177c3992e05d4583d
573eae0fd4af4c513a34e761a6bd9d7a6b5bb254
4406a8b509517e53ddd609bbf9a1806590e9a9d2
6c0482407412960b79f4d3491f5af02d934a93ae
2d8e0c2b5305e2a6433706571bf0ff27e11f65c2
1ca9d4f5a95acbcd642b386767c0d77760e03ffc
7948b2a127c511898204cce5643fbdbd0b33fa61
cead0a476acdf95f96656294eb9269daabe34d0f
5b4a33cf5fd55257b2bf19d085067e79c00dada0
59526f23b3dd89b45618d5a2b2defd2275b68a2f
3eb61cbfa1c8d008b732074f2e598895bcae626c
6010ea0ca9ce264595fa5d2e74832e1974cdc15c
d272fdf9eb456d6e1b92d95a1d56367ff900a68c
7f375f4e05fe9ec2b82a21486992f04f49ef0776
4de1b7547e11004d329b736089b4f82495da2829
9df1781f9202adc2a32901deb007f63e6bd85878
8f47fdc6f18bb48d147c2cb0a7dda853a9e8ec96
cdb7953afd1ad6b262642ec0a27012ba54182e4c
1333f264d6c0de818eb9778cbe97fddf81ab063b
3bbe5d74e8f9b2579647b521ea2bb4c95c318c69
039be2c88c309271eedcd91d6b73d77f1a1cf6b7
8b91d104d3bae383fce0228088c2612fa53aa088
faba2cc75d0a7ab8bb5e4a66b2d24323513b7d2f
1b37f0566b443b6e94458fed7c6e6a5b2984d45b
c036bcb894c974a8c91cc35eae14142107425545
654c9ac965150c2243aa6a2181aa9ef220a57543
3104c885d8a960a39923e5839c546cd472b361be
7479ef1c9ea56ec6acc1cea9117177eb4f7e409b
af392798312ef558ded78c5268d3a7eccef2f345
f86b44da0b2cf869cb2c84a0d8a21a6f855a1aeb
4710c31d3ccab2c0c5bbd83a76e5fd5bb3e1d5ba
175580d5adeaaaef1939cb7763a95d86b062606c
f4795d85cf20f41708626772152afadf10c415b0
1d265af2be4b2b96d5e2e003355cd81dfa164681
e676ac55d70594735cba80c3a64de22ba4126a9c
9b274548a67017db47e964756f0cc903bf69c3b6
)
ZEN_MUQSS_EXCLUDED_COMMITS=(
)

# Have to pull and apply one-by-one because of already applied commits
CFI_X86_COMMITS=(
e4a7957ae2ae2b22476bdf71199afa5a2bc9142b
1f848174ef6d4fbc580105a82a84ab620b914f93
1bc37159cde1584960e084349c4ca8682d2c73d2
ed25076c4c69a4713a845ed94c76e66cc392a581
640709f99a33f9d69e916581faed36e895219454
a4d746a3e8ae8218e77edef716979ef84a8a632f
0f99cdb7d089ce4148d0c3fcb7efd69cd9a8471f
f1f57f9b88b951d2746c0e8cb521f530690b8526
c3399a0a37a474635ae779d41bd1f55e9ac70cc1
82e2c6d52b822d601c6f9be7c004c894c5268e5d
782ee7f04a7780d11b9e64b6e6fc9b963f2b1892
08ac163623b2cadb66f974df6c5a2af402c36609
1041fe21a424a065e7c862f63ceb4ee5abb34ebb
5d5535be3a316f800843d1da3a96257eccbfb315
d710665e6be5b9b820f85787951288c2885ad964
5140d56af9b8ee5584a90014c86ce6b174a7653f
)

CFI_EXCLUDE_COMMITS=(
)

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 cfi +cfs clang disable_debug futex-wait-multiple
futex2 +genpatches +kernel-compiler-patch lru_gen lto +O3 prjc rt
shadowcallstack tresor tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64
tresor_x86_64-256-bit-key-support uksm zen-lru_gen zen-muqss zen-sauce
zen-sauce-all -zen-tune"
IUSE+=" clang-pgo"
REQUIRED_USE+="
	^^ ( cfs prjc zen-muqss )
	O3? ( zen-sauce )
	lru_gen? ( !zen-lru_gen )
	prjc? ( !rt )
	shadowcallstack? ( cfi )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-lru_gen? ( !lru_gen )
	zen-sauce-all? ( zen-sauce )
	zen-tune? ( zen-sauce )"

EXCLUDE_SCS=( alpha amd64 arm hppa ia64 mips ppc ppc64 riscv s390 sparc x86 )
gen_scs_exclusion() {
        for a in ${EXCLUDE_SCS[@]} ; do
                echo " ${a}? ( !shadowcallstack )"
	done
}
REQUIRED_USE+=" "$(gen_scs_exclusion)

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	prjc? ( !rt )
	zen-muqss? ( !rt )
	rt? ( cfs !prjc !zen-muqss )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel \
patchset, GraySky2's kernel_compiler_patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" bbrv2? ( GPL-2 )" # tcp_bbr2.c is Dual BSD/GPL but other parts are based on licensing of original file
LICENSE+=" clang-pgo? ( GPL-2 )"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" futex2? ( GPL-2 Linux-syscall-note GPL-2+ )" # same as original file
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
gen_kcp_license() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		out+=" kernel-compiler-patch-${a}? ( GPL-2 )"
	done
	echo "${out}"
}
LICENSE+=" "$(gen_kcp_license)
LICENSE+=" lru_gen? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no defaults license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)
LICENSE+=" zen-muqss? ( GPL-2 )"
LICENSE+=" zen-tune? ( GPL-2 )"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_cfi_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
		)
		     "
	done
}

gen_shadowcallstack_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
		)
		     "
	done
}

gen_lto_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*
			>=sys-devel/lld-${v}
		)
		"
	done
}

gen_clang_pgo_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*
		)
		"
	done
}

RDEPEND+=" cfi? (
		arm64? (
			|| ( $(gen_cfi_rdepend 12 14) )
		)
		amd64? (
			|| ( $(gen_cfi_rdepend 13 14) )
		)
	)
"
RDEPEND+=" clang-pgo? (
		|| ( $(gen_clang_pgo_rdepend 13 14) )
		sys-kernel/genkernel[clang-pgo]
	   )"
RDEPEND+=" lto? ( || ( $(gen_lto_rdepend 11 14) ) )"
RDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_rdepend 10 14) ) ) )"

gen_clang_gcc_pair() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
		)
		     "
	done
}

KCP_RDEPEND="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-6.5.0
		)
		$(gen_clang_gcc_pair 10 14)
	)
"

KCP_TC0="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC1="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10.3
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC2="
	clang? ( $(gen_clang_gcc_pair 12 14) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_gcc_pair 12 14)
	)"

KCP_MA_RDEPEND="
	kernel-compiler-patch-zen3? ( ${KCP_TC1} )
	kernel-compiler-patch-cooper_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-tiger_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-sapphire_rapids? ( ${KCP_TC2} )
	kernel-compiler-patch-rocket_lake? ( ${KCP_TC2} )
	kernel-compiler-patch-alder_lake? ( ${KCP_TC2} )"

RDEPEND+=" ${KCP_MA_RDEPEND}
	   kernel-compiler-patch? ( ${KCP_RDEPEND} )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

# For CPU microarchitectures >= year 2020, assumes mutually exclusive
# kernel-compiler-patch* USE flag usage
gen_kcp_ma_uri() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		[[ "${a}" =~ cortex-a72 ]] && continue
		out+="
	   kernel-compiler-patch-${a}? (
		${KCP_SRC_9_0_URI}
	   )"
	done
	echo "${out}"
}

# Not on the servers yet
NOT_READY_YET="
"

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   cfi? ( amd64? ( ${CFI_X86_SRC_URIS} ) )
	   clang-pgo? ( ${CLANG_PGO_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_0_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   lru_gen? ( ${LRU_GEN_SRC_URI} )
	   prjc? ( ${PRJC_SRC_URI} )
	   rt? ( ${RT_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-lru_gen? ( ${ZEN_LRU_GEN_SRC_URI} )
	   zen-muqss? ( ${ZEN_MUQSS_SRC_URIS} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	if use tresor ; then
		if [[ -n "${OT_KERNEL_DEVELOPER}" && "${OT_KERNEL_DEVELOPER}" == "1" ]] ; then
			:;
		else
eerror
eerror "Building for TRESOR is currently broken for ${PV}.  Use the older LTS"
eerror "branches instead.  Disable the tresor USE flag for this series to"
eerror "continue."
eerror
			die
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
ewarn
ewarn "The zen-tune patch might cause lock up or slow io under heavy load"
ewarn "like npm.  These use flags are not recommended."
ewarn
		fi
	fi

#	if use tresor ; then
#ewarn
#ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
#ewarn
#	fi

	if ! use arm64 && use shadowcallstack ; then
ewarn
ewarn "ShadowCallStack is only offered on the arm64 platform."
ewarn
	fi

	if use cfi && use amd64 ; then
ewarn
ewarn "The CFI patch for x86-64 is in development and originally for the"
ewarn "5.15 series."
ewarn
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_aesni.patch"
	fi

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
		fi
	fi

	if ! use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
		else
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
		fi
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
einfo
einfo "You may require the genkernel 4.x series to build the ${K_MAJOR_MINOR}.x"
einfo "kernel series."
einfo
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	:;
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
function ot-kernel_filter_patch_cb() {
	local path="${1}"
	if [[ "${path}" =~ "prjc_v5.12-r1.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ prjc_v5.12 ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
ewarn
ewarn "Applying genpatches 5022 kernel/sched/pelt.h fix for newer Project C."
ewarn "It still needs testing.  Remove this notice or codeblock if it is a"
ewarn "success or fixed upstream."
ewarn
		_dpatch "${PATCH_OPS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"
	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "${CK_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-dont-attach-ckversion.patch"
	elif [[ "${path}" =~ "${PRJC_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/clang-pgo-support-profraw-v6-and-v7.patch"
	elif [[ "${path}" =~ "cfi-x86-5.14-5140d56.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"

		# Add this to the end of the cfi commit list
		_dpatch "${PATCH_OPS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
