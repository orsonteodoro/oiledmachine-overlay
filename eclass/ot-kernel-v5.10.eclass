# Copyright 2020-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.10.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 5.10.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.10 eclass defines specific applicable patching for the 5.10.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v5.10/Documentation/process/changes.rst

KERNEL_RELEASE_DATE="20201213" # of first stable release
CXX_STD="-std=gnu++11" # See https://github.com/torvalds/linux/blob/v5.10/tools/build/feature/Makefile#L318
GCC_MAX_SLOT=13
GCC_MIN_SLOT=6
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=10
DISABLE_DEBUG_PV="1.4.1"
EXTRAVERSION="-ot"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KV_MAJOR=$(ver_cut 1 "${PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${PV}")
MUQSS_VER="0.205"
PATCH_ALLOW_O3_COMMIT="228e792a116fd4cce8856ea73f2958ec8a241c0c" # from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="2c85ebc57b3e1817b6ce1a6b703928e113a90442" # 5.10
PATCH_BBRV2_COMMIT_A="c13e23b9782c9a7f4bcc409bfde157e44a080e82" # ancestor ~ oldest
PATCH_BBRV2_COMMIT_D="3d76056b85feab3aade8007eb560c3451e7d3433" # descendant ~ newest
PATCH_KCP_COMMIT="986ea2483af3ba52c0e6c9e647c05c753a548fb8" # from zen repo
PATCH_OPENRGB_COMMIT="5b3d9f2372600c3b908b1bd0e8c9b8c6ed351fa2" # apply from zen repo
PATCH_TRESOR_VER="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

#C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020

CK_KV="5.10.0"
CK_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.10...ckolivas:5.10-ck
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/35f6640868573a07b1291c153021f5d75749c15e^..13f5f8abb25489af1cc019a4a3bc83cced6da67c.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# Corrected missing commit
35f6640868573a07b1291c153021f5d75749c15e
ea9b4218b46eae24eef6162be269934f4bb5dfb6
aa59b50641d91d37ca28bfadbcd5281ff40f148d
e123b4092b42207e6b73373e5d583533e5f81d57
0b9ec366834a7cb054ac486230b52706c5c100bf
2ea8fdb7dc4d79679a7f77e483a8fc54ef5a727f
04468a7eb2c75c6e0bdfdcbe754674c8e50c0c08
6ca339e2a03ab0281cacfe684bd0f1c538f485c5
202d57347034c71c786cd37310a3f4bdb0900744
8a04d624810bc8abe736c704c5f918999b6f95cd
21fef3fefa84f136104c32c150c038dac7ea0edf
8a06fc83fb4698eed8580738d449a05c4604b38f
fa98200feaf4f5e593326b19261bee010e66d533
6ad64c43e446bd13db9758bf254be544461a76cb
0be1591cfd163660fe0fdb850e013e29ba355351
9cdf59bc2dbfb640dbb057757e4101b147275e86
a2fb34e34d157c303d07ee16b1ad42c8720ab320
13f5f8abb25489af1cc019a4a3bc83cced6da67c
)

# Avoid merge conflict or dupes
CK_COMMITS_BL=(
9cdf59bc2dbfb640dbb057757e4101b147275e86 # -ck1 extraversion
a2fb34e34d157c303d07ee16b1ad42c8720ab320 # Update Kconfig [It makes muqss the default and CPU_FREQ_DEFAULT_GOV_ONDEMAND depend on muqss.]
)

ZEN_KV="5.10.0"
PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.10...zen-kernel:zen-kernel:5.10/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/dda238180bacda4c39f71dd16d754a48da38e676^..e1b127aa22601f9cb2afa3daad4c69e6a42a89f5.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
dda238180bacda4c39f71dd16d754a48da38e676
9a2e0d950bfd77fb51a42a5fc7e81a9187606c38
5b3d9f2372600c3b908b1bd0e8c9b8c6ed351fa2
986ea2483af3ba52c0e6c9e647c05c753a548fb8
228e792a116fd4cce8856ea73f2958ec8a241c0c
b81ab9b618d694217a54b5d2de70c7f37d3f3e07
4ace3c6c50dbd58ee5f200a5461289d0491873a6
0bf1b8c445de4481942ca8ace8dc209ece865bd3
513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3
28eaff69b01d9248cac394cce37361d0d6a52714
973d42f99af15b2e610204fbe8252251ed7cc8c1
890ac858741436a40c274efb3514c5f6a96c7c80
0cbcc41992693254e5e4c7952853c6aa7404f28e
9b6c7af596e209356850e0991969df68f396aea6
b5e9497d44347c16e732f6ea8838a79a64694b36
7e5629d0fc7ed407babc036c1bc7910d9c73dbef
0e9fea26940d7e6e784dcf57909428138b8109e8
fade4cc2bf56ce6c563c04764224b6b84a45587f
b7b24b494b62e02c21a9a349da2d036849f9dd8b
b7b984993f303b89dd738c26f8742cfcf0ac98ea
8cd3f16931b2a05a693bbfc093d44fd504c67700
843f85a8fb80f3b8e4de4ca3c0cab34730cc1b33
5dc3c67b4c2497187c2e4331a4822cb52db9aa65
3f2c3d43bb1330953e090c01f8dfb6a4701bbac4
223b7e095efa96045c164f3bf3576e1d1f599946
2b52b792670d6c1a93d086a10c6872575e849c17
e1b127aa22601f9cb2afa3daad4c69e6a42a89f5
)

# Avoid merge conflict.
PATCH_ZEN_SAUCE_BRANDING="
dda238180bacda4c39f71dd16d754a48da38e676
"

# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE="
0cbcc41992693254e5e4c7952853c6aa7404f28e:513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3
" # \
# ZEN: INTERACTIVE: Use BFQ as our elevator (0cbcc41) requires \
# ZEN: Add CONFIG to rename the mq-deadline scheduler (513af58)

# ancestor ~ oldest ~ top, descendant ~ newest ~ bottom
PATCH_ZEN_TUNE_COMMITS=(
890ac858741436a40c274efb3514c5f6a96c7c80
0cbcc41992693254e5e4c7952853c6aa7404f28e
9b6c7af596e209356850e0991969df68f396aea6
b5e9497d44347c16e732f6ea8838a79a64694b36
7e5629d0fc7ed407babc036c1bc7910d9c73dbef
0e9fea26940d7e6e784dcf57909428138b8109e8
fade4cc2bf56ce6c563c04764224b6b84a45587f
b7b24b494b62e02c21a9a349da2d036849f9dd8b
)
PATCH_BFQ_DEFAULT="0cbcc41992693254e5e4c7952853c6aa7404f28e"
PATCH_ZEN_SAUCE_BL=(
	${PATCH_KCP_COMMIT}
	${PATCH_ZEN_SAUCE_BRANDING}
)

# Backport from 5.9, updated to 5.10, with zen changes
ZEN_MUQSS_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.10...zen-kernel:zen-kernel:5.10/muqss
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/9d6b3eef3a1ec22d4d3c74e0b773ff52d3b3a209^..1ee7b1ab0da8b81ad41bf83e795ba80cf1288739.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
9d6b3eef3a1ec22d4d3c74e0b773ff52d3b3a209
3b17bfa60ca1e8d94cb7a4c490dd79a14c53a074
25b07958996a2d2dcff8b54917c01bf01196e68e
c68e24eb9e7ff9cf585ca395a9a95023404ddea4
e52e9340936ec51702e13997519a36279f848b47
f4a3f1a4685f1c2453535dc10c5a4c1cb9d2c37e
cd185b24202c18832ee493cf1e7f3d38cadefb3f
31a1b5cfd19718a53b207ee66850516a97964c9a
cb705098cd4fbc5da1dd898642602d98f265e74c
81170db5534ada1574b366fd7df75080ce5a50de
a809bb5c75fc246f155872631258828a6df3485d
14891c776915dcbabab79d89e9b819114bfa794c
e610927931872d67a868b14bdb6f48d83dd992ed
e219172bbe43aed68943e72b19897191b6bd8f8f
37fa42a7ec254ecbec319f603cd595d6308021ea
4d8602abd84dbc4219e337331f7d8bd7a91ce8c6
aa17b2d1d0c2814b2cdd33e2b1cf171b5ac30b86
9089e95bb3d0e64dc64ae90eb509da5075f49248
16b6c9f2c576d43096a216a802c61573286ae5a7
f52ed229284681b01ba3785a581fefb89cb91d87
5e029bcb673aa73c2a432f5f78f60351821f5b33
2da693aab6562ed337fd383bdd368d65081cb955
76154be76bebec4ef22db220f7e98bc2f7ed940c
abcc55ee0e4b908af47d67d2a594d63862a5e914
780ad761cfe51dfdd178db93be8443355a7597d7
1ee7b1ab0da8b81ad41bf83e795ba80cf1288739
)
ZEN_MUQSS_EXCLUDED_COMMITS=(
)

BBRV2_KV="5.10.0"
BBRV2_VERSION="v2alpha-2021-07-07"
BBRV2_COMMITS=( # oldest
# From https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1...v2alpha-2021-07-07
#
# Generated from:
# f428e49 - comes from Makefile
# wget -q -O - https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1^..v2alpha-2021-07-07.patch \
#       | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
c13e23b9782c9a7f4bcc409bfde157e44a080e82
89fe5fca59f015a7370543d9c906548a6ac7c7ac
f6da35cbef6549b1141a4a5631b91748d2ed0922
cf201e3528890c96645167f6dbb4a6b285d03580
f85b140f08ad704091af612e6abdc2d32def89b9
cd58ed7eb9645b2e54136cf52be6279dbdebe936
98e9594ea12f91b83309d9153ea1eb9a82175e9d
5c8358928dccb808566494aaf17f5ce3dc1b3357
2f3913b4f30c18f9da90d02a39a7d84f4e85fe53
40746a8365da9e096efb7a893e9adeec26d621d8
deafdb32913ce4aa0509ba0e422c6eb03cf5ebdf
aeabbacac09d7d0e7908369ac95591149ee42960
862ad4d62437e19a69d4a65c6ccc96dede981b97
b8d3909fa091fabfbc084ed89b16de30409d9d31
1079d54e66bd8fc301367db40deba0f4e33d157c
819ea23298351f49fb69bab72e27c15102762f0e
65c4ae957f9db04d0fc81f70d91b2a39df7bf50f
629fcdc2efbaa9cff5b765b9410e0bc22f2de29d
cddec48ad515cccbfa37d7780bf770eb27b7fdd9
13d090b12311d0981a3873bc72e3c5684d23825d
af303e47dad6085d9436a3038908c50185caf74c
d3760c4d93ed59d2992f94044e2f75d3150f3e34
fe6b56a9c48b934d2ffaafd60eb89b9dae6e912d
627fad86219ccb869260469eaab13f7f0ebab428
63217d9a2fe9f05967b5a2b5b966ae2921b4b725
74f603c704691b97cf6dbadcafd1f24ce74fe46c
3d76056b85feab3aade8007eb560c3451e7d3433
) # newest

IUSE+="
bbrv2 build c2tcp +cfs clang deepcc disable_debug -exfat +genpatches
-genpatches_1510 muqss orca pgo prjc rock-dkms rt symlink tresor tresor_aesni
tresor_i686 tresor_prompt tresor_sysfs tresor_x86_64
tresor_x86_64-256-bit-key-support uksm zen-muqss zen-sauce
"
REQUIRED_USE+="
	genpatches_1510? (
		genpatches
	)
	tresor? (
		^^ (
			tresor_aesni
			tresor_i686
			tresor_x86_64
		)
	)
	tresor_aesni? (
		tresor
	)
	tresor_i686? (
		tresor
	)
	tresor_prompt? (
		tresor
	)
	tresor_sysfs? (
		|| (
			tresor_aesni
			tresor_i686
			tresor_x86_64
		)
	)
	tresor_x86_64? (
		tresor
	)
	tresor_x86_64-256-bit-key-support? (
		tresor
		tresor_x86_64
	)
"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="\
A customizable kernel package with \
BBRv2, \
C2TCP, \
CVE fixes, \
DeepCC, \
genpatches, \
kernel_compiler_patch, \
MuQSS, \
Orca, \
Project C (BMQ, PDS-mq), \
RT_PREEMPT (-rt), \
TRESOR, \
UKSM, \
zen-muqss, \
zen-sauce. \
"

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" c2tcp? ( MIT )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" prjc? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" orca? ( MIT )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no defaults license
	#   found in the project.  (The implementation is based on an academic paper
	#   from public universities.)
LICENSE+=" zen-muqss? ( GPL-2 )"
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
		)
		$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
	)
"

KMOD_PV="13"
CDEPEND+="
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.23
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=sys-devel/make-3.81
	app-arch/cpio
	app-shells/bash
	dev-util/pkgconf
	sys-apps/grep[pcre]
	virtual/libelf
	virtual/pkgconfig
	bzip2? (
		app-arch/bzip2
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
	xz? (
		>=sys-apps/kmod-${KMOD_PV}[lzma]
		app-arch/xz-utils
	)
	zstd? (
		>=sys-apps/kmod-${KMOD_PV}[zstd]
		app-arch/zstd
	)
"

RDEPEND+="
	!build? (
		${CDEPEND}
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
	pgo? (
		>=sys-devel/gcc-4.9
	)
"

DEPEND+="
	${RDEPEND}
"

BDEPEND+="
	build? (
		${CDEPEND}
	)
"

RDEPEND+="
	${KCP_RDEPEND}
"

PDEPEND+="
	rock-dkms? (
		|| (
			~sys-kernel/rock-dkms-5.4.3
			~sys-kernel/rock-dkms-5.3.3
			~sys-kernel/rock-dkms-5.1.3
		)
	)
"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:
else
	KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
	SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}
	"
fi

if [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${C2TCP_URIS}
		${CK_SRC_URIS}
		${GENPATCHES_URI}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		${PRJC_SRC_URI}
		${RT_SRC_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${UKSM_SRC_URI}
		${ZEN_MUQSS_SRC_URIS}
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
		c2tcp? (
			${C2TCP_URIS}
		)
		deepcc? (
			${C2TCP_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		muqss? (
			${CK_SRC_URIS}
		)
		orca? (
			${C2TCP_URIS}
		)
		prjc? (
			${PRJC_SRC_URI}
		)
		rt? (
			${RT_SRC_URI}
		)
		tresor? (
			${TRESOR_AESNI_SRC_URI}
			${TRESOR_I686_SRC_URI}
			${TRESOR_README_SRC_URI}
			${TRESOR_RESEARCH_PDF_SRC_URI}
			${TRESOR_SYSFS_SRC_URI}
		)
		uksm? (
			${UKSM_SRC_URI}
		)
		zen-muqss? (
			${ZEN_MUQSS_SRC_URIS}
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
	if use tresor ; then
ewarn
ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
ewarn
ewarn "Please migrate your data outside the XTS(tresor) partition(s) into a different"
ewarn "partition.  Keep the commit frozen, or checkout kept rewinded to commit"
ewarn "20a1c90 before the XTS(tresor) key changes to backup and restore from"
ewarn "it. Checkout repo as HEAD when you have migrated the data are ready to"
ewarn "use the updated XTS(tresor) with setkey changes.  This new XTS setkey"
ewarn "change will not be backwards compatible."
ewarn
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPTS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPTS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_aesni.patch"
	fi

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
		fi
	fi

	if ! ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
		else
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
		fi
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi
	_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-in-kconfig.patch"
	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-xts-setkey-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-xts-setkey-5.4-aesni.patch"
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

# @FUNCTION: ot-kernel_filter_genpatches_blacklist_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_filter_genpatches_blacklist_cb() {
	# remove patches that have been already applied upstream
	echo " 2400"
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

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "prjc_v5.10-r2.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${path}"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "prjc_v5.10-lts-r3.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/prjc_v5.10-lts-r3-fix-for-5.10.194.patch"
	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-f6da35c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-f6da35c-fix-for-5.10.129.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-f85b140.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-f85b140-fix-for-5.10.129.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-cd58ed7.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cd58ed7-fix-for-5.10.129.patch"

	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-b8d3909.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-b8d3909-fix-for-5.10.160.patch"
	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
einfo "See ${path}"
die
		_tpatch "${PATCH_OPTS}" "${path}" 10 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/"
	elif [[ "${path}" =~ "ck-0.205-5.10.0-35f6640.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.205-5.10.0-35f6640-fix-for-5.10.194.patch"

	elif [[ "${path}" =~ "ck-0.205-5.10.0-04468a7.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.205-5.10.0-04468a7-fix-for-5.10.194.patch"

	elif [[ "${path}" =~ "0255-cpuset-Convert-callback_lock-to-raw_spinlock_t.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/rt-patchset-0255-cpuset-Convert-callback_lock-to-raw_spinlock_t-fix-for-5.10.194.patch"

	elif [[ "${path}" =~ "zen-sauce-5.10.0-28eaff6.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-5.10.0-28eaff6-fix-for-5.10.194.patch"

	elif [[ "${path}" =~ "zen-sauce-5.10.0-e1b127a.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-5.10.0-e1b127a-fix-for-5.10.194.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}"
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "dev-util/oprofile" "0.9" "CONFIG_OPROFILE"
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
