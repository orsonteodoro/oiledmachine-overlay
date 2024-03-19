# Copyright 2019-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel eclass defines common patching steps for any linux
# kernel version.

# BBR v2:
#	https://github.com/google/bbr/compare/2c85ebc...v2alpha-2021-07-07
#	https://github.com/google/bbr/compare/f428e49...v2alpha-2021-08-21
#	2c85ebc f428e49 comes from /Makefile commit history in v2alpha branch
#		that corresponds to the same version for that tag
# BBR v3:
#       https://github.com/google/bbr/tree/v3
#       https://github.com/google/bbr/compare/ba2274dcfda859b8a27193e68ad37bfe4da28ddc...v3					# 6.4 to v3 tip
# BMQ CPU Scheduler:
#	https://cchalpha.blogspot.com/search/label/BMQ
#	https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
# C2TCP:
#	https://github.com/Soheil-ab/c2tcp
# CFI:
#	https://github.com/torvalds/linux/compare/v5.15...samitolvanen:cfi-5.15
# Clear Linux patches:
#       https://github.com/clearlinux-pkgs/linux
# PGO (clang) support:
#	Upstream acquaintances used 5.13.0_rc2
#       https://patchwork.kernel.org/project/linux-kbuild/patch/20210407211704.367039-1-morbo@google.com/mbox/			# Earlier Clang PGO v9.
#       https://patchwork.kernel.org/project/linux-kbuild/patch/20210407211704.367039-1-morbo@google.com/#24246189		# Context of above patch
#	https://lore.kernel.org/all/20210621231822.2848305-1-ndesaulniers@google.com/T/#u					# Add __no_profile
#       https://github.com/ClangBuiltLinux/linux/issues/1405
# PGO (gcc) support:
#	https://wiki.gentoo.org/wiki/Kernel/Optimization#GCC_PGO
#       http://coolypf.com/kpgo.htm
# DeepCC:
#	https://github.com/Soheil-ab/DeepCC.v1.0
# KCFI:
#	https://github.com/torvalds/linux/compare/v6.0...samitolvanen:kcfi-v5
# genpatches:
#	https://gitweb.gentoo.org/proj/linux-patches.git/
#	https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=4.19
#	https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=5.4
#	https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=5.10
#	https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=5.15
#	https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=6.1
#       https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=6.6
#       https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=6.7
# kernel_compiler_patch:
#	https://github.com/graysky2/kernel_compiler_patch
# MUQSS CPU Scheduler (official, EOL 5.12):
#	https://github.com/torvalds/linux/compare/v4.19...ckolivas:4.19-ck
#	https://github.com/torvalds/linux/compare/v5.4...ckolivas:5.4-ck
#	https://github.com/torvalds/linux/compare/v5.10...ckolivas:5.10-ck
# Multigenerational LRU:
#	https://github.com/torvalds/linux/compare/v5.15...zen-kernel:5.15/lru
#	https://github.com/torvalds/linux/compare/v6.0...zen-kernel:6.0/mglru
# Nest:
#       https://gitlab.inria.fr/nest-public/nest-artifact
#       https://gitlab.inria.fr/nest-public/nest-artifact/-/tree/main/extras
#       https://gitlab.inria.fr/nest-public/nest-artifact/-/tree/main/image_creation
# O3 (Allow O3):
#	https://github.com/torvalds/linux/commit/4edc8050a41d333e156d2ae1ed3ab91d0db92c7e	# 5.4
#	https://github.com/torvalds/linux/commit/228e792a116fd4cce8856ea73f2958ec8a241c0c	# 5.10
# O3 (Optimize Harder):
#	https://github.com/torvalds/linux/commit/7d0295dc49233d9ddff5d63d5bdc24f1e80da722	# 4.9 (-O3)
#	https://github.com/torvalds/linux/commit/562a14babcd56efc2f51c772cb2327973d8f90ad	# ~2018 (infiniband O3 read overflow fix)
#	The Patch for >= 5.4 can be found on zen-sauce.
# Orca:
#	https://github.com/Soheil-ab/Orca
# PDS CPU Scheduler:
#	https://cchalpha.blogspot.com/search/label/PDS
#	https://gitlab.com/alfredchen/PDS-mq/-/tree/master
# PREEMPT_RT:
#	https://wiki.linuxfoundation.org/realtime/start
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/4.19/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.4/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.10/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.15/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/6.1/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/6.6/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/6.7/
#	http://cdn.kernel.org/pub/linux/kernel/projects/rt/6.8/
# Project C CPU Scheduler:
#	https://cchalpha.blogspot.com/search/label/Project%20C
#	https://gitlab.com/alfredchen/projectc/-/tree/master
# TRESOR:
#	https://www1.informatik.uni-erlangen.de/tresor
# UKSM:
#	https://github.com/dolohow/uksm
# zen-sauce, zen-tune:
#	https://github.com/torvalds/linux/compare/v4.19...zen-kernel:zen-kernel:4.19/zen-tune	# aka part 1 of zen-sauce
#	https://github.com/torvalds/linux/compare/v4.19...zen-kernel:zen-kernel:4.19/misc	# aka part 2 of zen-sauce
#	https://github.com/torvalds/linux/compare/v5.4...zen-kernel:5.4/zen-sauce
#	https://github.com/torvalds/linux/compare/v5.10...zen-kernel:5.10/zen-sauce
#	https://github.com/torvalds/linux/compare/v5.15...zen-kernel:5.15/zen-sauce
#	https://github.com/torvalds/linux/compare/v6.1...zen-kernel:6.1/zen-sauce
#	https://github.com/torvalds/linux/compare/v6.5...zen-kernel:6.5/zen-sauce
#	https://github.com/torvalds/linux/compare/v6.6...zen-kernel:6.6/zen-sauce
#	https://github.com/torvalds/linux/compare/v6.7...zen-kernel:6.7/zen-sauce

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# I did a grep -i -r -e "SPDX" ./ | cut -f 3 -d ":" | sort | uniq
# and looked it up through github.com or my copy to confirm the license on the file.

# Solo licenses detected by:
#	`grep -E -r -e "SPDX.*GPL-2" ./ | grep -i -v "GPL"`
# Replace GPL-2 with SPDX identifier

# For kernel license templates see:
# https://github.com/torvalds/linux/tree/master/LICENSES
# See also https://github.com/torvalds/linux/blob/master/Documentation/process/license-rules.rst
LICENSE+=" GPL-2 Linux-syscall-note" #  Applies to whole source  \
	# that are GPL-2 compatible.  See paragraph 3 of the above link for details.

# The following licenses applies to individual files:

# The distro BSD license template does have all rights reserved and implied.
# The distro GPL licenses templates do not have all rights reserved but it's
# found in the headers.
# The distro MIT license template does not have all rights reserved.
LICENSE+=" ( GPL-2 all-rights-reserved )" # See mm/list_lru.c
LICENSE+=" ( GPL-2+ all-rights-reserved )" # See drivers/gpu/drm/meson/meson_plane.c
LICENSE+=" ( all-rights-reserved BSD || ( GPL-2 BSD ) )" # See lib/zstd/compress.c
LICENSE+=" ( all-rights-reserved MIT || ( GPL-2 MIT ) )" # See drivers/gpu/drm/ttm/ttm_execbuf_util.c
LICENSE+=" ( custom GPL-2+ )" # See drivers/scsi/esas2r/esas2r_main.c, ... ; # \
	# Samples warranty/liability paragraphs from maybe EPL-2.0
LICENSE+=" 0BSD" # See lib/math/cordic.c

# It is missing SPDX: compared to the other all-rights-reserved files.
LICENSE+=" all-rights-reserved" # See lib/dynamic_debug.c

LICENSE+=" BSD" # See include/linux/packing.h, ...
LICENSE+=" BSD-2" # See include/linux/firmware/broadcom/tee_bnxt_fw.h
LICENSE+=" Clear-BSD" # See drivers/net/wireless/ath/ath11k/core.h, ...
LICENSE+=" custom" # See crypto/cts.c
LICENSE+=" ISC" # See linux/drivers/net/wireless/ath/wil6210/trace.c, \
	# linux/drivers/net/wireless/ath/ath5k/Makefile, ...
LICENSE+=" LGPL-2.1" # See fs/ext4/migrate.c, ...
LICENSE+=" LGPL-2+ Linux-syscall-note" # See arch/x86/include/uapi/asm/mtrr.h
LICENSE+=" MIT" # See drivers/gpu/drm/drm_dsc.c
LICENSE+=" Prior-BSD-License" # See drivers/net/slip/slhc.c
LICENSE+=" unicode" # See fs/nls/mac-croatian.c ; 3 clause data files
LICENSE+=" Unlicense" # See tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
LICENSE+=" ZLIB" # See lib/zlib_dfltcc/dfltcc.c, ...

LICENSE+=" || ( BSD GPL-2 )" # See lib/test_parman.c
LICENSE+=" || ( GPL-2 Apache-2.0 )" # See drivers/net/wireless/silabs/wfx/hif_api_cmd.h
LICENSE+=" || ( GPL-2 MIT )" # See lib/crypto/poly1305-donna32.c
LICENSE+=" || ( GPL-2 BSD-2 )" # See arch/x86/crypto/sha512-ssse3-asm.S

HOMEPAGE+="
https://algo.ing.unimo.it/people/paolo/disk_sched/
https://cchalpha.blogspot.com/search/label/BMQ
https://cchalpha.blogspot.com/search/label/PDS
https://cchalpha.blogspot.com/search/label/Project%20C
https://ck-hack.blogspot.com/
https://dev.gentoo.org/~mpagano/genpatches/
https://github.com/dolohow/uksm
https://github.com/graysky2/kernel_compiler_patch
https://liquorix.net/
https://wiki.linuxfoundation.org/realtime/start
https://www1.informatik.uni-erlangen.de/tresor
"

OT_KERNEL_SLOT_STYLE=${OT_KERNEL_SLOT_STYLE:-"MAJOR_MINOR"}
SLOT=${SLOT:-${PV}}
K_EXTRAVERSION="ot"
S="${WORKDIR}/linux-${UPSTREAM_PV}-${K_EXTRAVERSION}"
#PROPERTIES="interactive" # The menuconfig is broken because of emerge or sandbox.  All things were disabled but still doesn't work.
OT_KERNEL_PGO_DATA_DIR="/var/lib/ot-sources/${MY_PV}"

# Upstream keeps reiserfs
IUSE+="
bzip2 cpu_flags_arm_thumb graphicsmagick gtk gzip imagemagick intel-microcode
linux-firmware lz4 lzma lzo +ncurses openssl pcc +reiserfs qt5 xz zstd
${EBUILD_REV}
"
GCC_PKG="sys-devel/gcc"
NEEDS_DEBUGFS=0
PYTHON_COMPAT=( python3_{10..11} ) # Slots based on dev-python/selenium
inherit check-reqs flag-o-matic python-r1 ot-kernel-pkgflags
inherit ot-kernel-kutils security-scan toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
fi

# For firmware security update availability, see
# https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/blob/main/releasenote.md
# SEV firmware mitigations needs to be bumped also.
# Search "SEV FW" version and "μcode" for patch number to bump versions below.
LINUX_FIRMWARE_PV="20230625_p20230724" # Based on latest available patch level cross referenced to the μcode column.
LINUX_FIRMWARE_TIMESTAMP="2023-07-24 08:29:07 -0400" # Same as above from the git log.
INTEL_MICROCODE_PV="20240312_p20240312"
RDEPEND+="
	intel-microcode? (
		>=sys-firmware/intel-microcode-${INTEL_MICROCODE_PV}
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
	)
"

DEPEND+="
	intel-microcode? (
		>=sys-firmware/intel-microcode-${INTEL_MICROCODE_PV}
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
	)
"
# lscpu needs sys-apps/util-linux
BDEPEND+="
	dev-util/patchutils
	sys-apps/findutils
	sys-apps/util-linux
	imagemagick? (
		media-gfx/imagemagick
		app-crypt/rhash
	)
	intel-microcode? (
		>=sys-firmware/intel-microcode-${INTEL_MICROCODE_PV}
	)
	graphicsmagick? (
		media-gfx/graphicsmagick[imagemagick]
		app-crypt/rhash
	)
"

if [[ -n "${C2TCP_VER}" ]] ; then
	PDEPEND+="
		deepcc? (
			sys-apps/deepcc
		)
		orca? (
			sys-apps/orca
		)
	"
fi

PGT_CRYPTO_DEPEND="
	sys-fs/cryptsetup
"
PGT_TRAINERS=(
	2d
	3d
	crypto_std
	crypto_kor
	crypto_chn
	crypto_rus
	crypto_common
	crypto_less_common
	crypto_deprecated
	custom
	emerge1
	emerge2
	filesystem
	memory
	network
	p2p
	webcam
	yt
)
IUSE+="
	${PGT_TRAINERS[@]/#/ot_kernel_pgt_}
"
REQUIRED_USE+="
	ot_kernel_pgt_2d? (
		pgo
	)
	ot_kernel_pgt_3d? (
		pgo
	)
	ot_kernel_pgt_crypto_std? (
		pgo
	)
	ot_kernel_pgt_crypto_kor? (
		pgo
	)
	ot_kernel_pgt_crypto_chn? (
		pgo
	)
	ot_kernel_pgt_crypto_rus? (
		pgo
	)
	ot_kernel_pgt_crypto_common? (
		pgo
	)
	ot_kernel_pgt_crypto_less_common? (
		pgo
	)
	ot_kernel_pgt_crypto_deprecated? (
		pgo
	)
	ot_kernel_pgt_custom? (
		pgo
	)
	ot_kernel_pgt_emerge1? (
		pgo
	)
	ot_kernel_pgt_emerge2? (
		pgo
	)
	ot_kernel_pgt_filesystem? (
		pgo
	)
	ot_kernel_pgt_memory? (
		pgo
	)
	ot_kernel_pgt_network? (
		pgo
	)
	ot_kernel_pgt_p2p? (
		pgo
	)
	ot_kernel_pgt_webcam? (
		pgo
	)
	ot_kernel_pgt_yt? (
		pgo
	)
"
PDEPEND+="
	sys-apps/coreutils
	sys-apps/grep[pcre]
	ot_kernel_pgt_2d? (
		sys-apps/findutils
		sys-process/procps
		x11-misc/xscreensaver[X]
	)
	ot_kernel_pgt_3d? (
		sys-apps/findutils
		sys-process/procps
		x11-misc/xscreensaver[X,opengl]
		virtual/opengl
	)
	ot_kernel_pgt_crypto_std? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_kor? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_chn? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_rus? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_common? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_less_common? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_crypto_deprecated? (
		${PGT_CRYPTO_DEPEND}
	)
	ot_kernel_pgt_emerge1? (
		sys-apps/findutils
	)
	ot_kernel_pgt_filesystem? (
		sys-apps/findutils
	)
	ot_kernel_pgt_memory? (
		${PYTHON_DEPS}
		sys-apps/util-linux
		sys-process/procps
	)
	ot_kernel_pgt_network? (
		net-analyzer/traceroute
		net-misc/curl
		net-misc/iputils
	)
	ot_kernel_pgt_p2p? (
		net-p2p/ctorrent
		sys-apps/util-linux
		sys-process/procps
	)
	ot_kernel_pgt_webcam? (
		media-tv/v4l-utils
		media-video/ffmpeg[encode,v4l]
	)
	ot_kernel_pgt_yt? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/selenium[${PYTHON_USEDEP}]')
		|| (
			(
				www-client/chromium
			)
			(
				www-client/google-chrome
				www-apps/chromedriver-bin
			)
			(
				www-client/firefox[geckodriver]
			)
		)
	)
	pcc? (
		sys-kernel/pcc
	)
"

EXPORT_FUNCTIONS \
	pkg_pretend \
	pkg_setup \
	src_unpack \
	src_prepare \
	src_configure \
	src_compile \
	src_install \
	pkg_postinst

# @FUNCTION: gen_kernel_seq
# @DESCRIPTION:
# Generates a sequence for point releases
# @CODE
# Parameters:
# $1 - x >= 2
# @CODE
gen_kernel_seq()
{
	# 1-2 2-3 3-4, $1 >= 2
	local s=""
	local to
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" ${s} $((${to}-1))-${to}"
	done
	echo $s
}

# @FUNCTION: gen_zen_sauce_uris
# @DESCRIPTION:
# Generates zen secret sauce URIs
ZEN_SAUCE_BASE_URI="https://github.com/torvalds/linux/commit/"
gen_zen_sauce_uris()
{
	local commits=(${@})
	local len="${#commits[@]}"
	local s=""
	local c
	for (( c=0 ; c < ${len} ; c+=1 )) ; do
		local id="${commits[c]}"
		s="
			${s}
			${ZEN_SAUCE_BASE_URI}${id}.patch
				-> zen-sauce-${ZEN_KV}-${id:0:7}.patch
		"
	done
	echo "$s"
}

BMQ_FN="${BMQ_FN:-v${KV_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch}"
BMQ_BASE_URI="https://gitlab.com/alfredchen/bmq/raw/master/${KV_MAJOR_MINOR}/"
BMQ_SRC_URI="${BMQ_BASE_URI}${BMQ_FN}"

CLANG_PGO_FN="clang-pgo-v9.patch"

BBRV2_BASE_URI="https://github.com/google/bbr/commit/"
gen_bbrv2_uris() {
	local s=""
	local c
	for c in ${BBRV2_COMMITS[@]} ; do
		s+=" ${BBRV2_BASE_URI}${c}.patch -> bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${BBRV2_KV}" ]] ; then
	BBRV2_SRC_URIS=" "$(gen_bbrv2_uris)
fi

BBRV3_BASE_URI="https://github.com/google/bbr/commit/"
gen_bbrv3_uris() {
	local s=""
	local c
	for c in ${BBRV3_COMMITS[@]} ; do
		s+=" ${BBRV3_BASE_URI}${c}.patch -> bbrv3-${BBRV3_VERSION}-${BBRV3_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${BBRV3_KV}" ]] ; then
	BBRV3_SRC_URIS=" "$(gen_bbrv3_uris)
fi

if [[ -n "${C2TCP_VER}" ]] ; then
	C2TCP_FN="linux-${C2TCP_KV//./-}-orca-c2tcp-${C2TCP_EXTRA}.patch"
	C2TCP_BASE_URI="https://raw.githubusercontent.com/Soheil-ab/c2tcp/${C2TCP_COMMIT}/linux-patch"
	C2TCP_URIS="
		${C2TCP_BASE_URI}/${C2TCP_FN}
		https://raw.githubusercontent.com/Soheil-ab/c2tcp/master/copyright
			-> copyright.c2tcp.${C2TCP_COMMIT:0:7}
	"
fi

CLEAR_LINUX_PATCHES_FN="clear-linux-patches-${CLEAR_LINUX_PATCHES_VER}.tar.gz"
CLEAR_LINUX_PATCHES_URI="https://github.com/clearlinux-pkgs/linux/archive/refs/tags/${CLEAR_LINUX_PATCHES_VER}.tar.gz -> ${CLEAR_LINUX_PATCHES_FN}"

GENPATCHES_URI_BASE_URI="https://gitweb.gentoo.org/proj/linux-patches.git/snapshot/"
GENPATCHES_MAJOR_MINOR_REVISION="${KV_MAJOR_MINOR}-${GENPATCHES_VER}"
GENPATCHES_FN="linux-patches-${GENPATCHES_MAJOR_MINOR_REVISION}.tar.bz2"
GENPATCHES_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_FN}"

KCP_COMMIT_SNAPSHOT="c409515574bd4d69af45ad74d4e7ba7151010516" # 20240221

KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
KERNEL_SERIES_TARBALL_FN="linux-${KV_MAJOR_MINOR}.tar.xz"
KERNEL_INC_BASE_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/incr/"
KERNEL_PATCH_0_TO_1_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/patch-${KV_MAJOR_MINOR}.1.xz"

KCP_CORTEX_A72_BN=\
"build-with-mcpu-for-cortex-a72"

if ver_test ${KV_MAJOR_MINOR} -ge 6.8 ; then
	KCP_9_1_BN="more-uarches-for-kernel-6.8-rc4%2B"
elif ver_test ${KV_MAJOR_MINOR} -ge 6.1 ; then
	KCP_9_1_BN="more-uarches-for-kernel-6.1.79-6.8-rc3"
elif ver_test ${KV_MAJOR_MINOR} -ge 5.17 ; then
	KCP_9_1_BN="more-uarches-for-kernel-5.17%2B"
elif ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
	KCP_9_1_BN="more-uarches-for-kernel-5.15-5.16"
elif ver_test ${KV_MAJOR_MINOR} -ge 5.8 ; then
	KCP_9_1_BN="more-uarches-for-kernel-5.8-5.14"
elif ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
	KCP_9_1_BN="more-uarches-for-kernel-4.19-5.4"
elif ver_test ${KV_MAJOR_MINOR} -ge 4.13 ; then
	KCP_8_1_BN="enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B"
	KCP_4_9_BN="enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B"
fi
KCP_URI_BASE=\
"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/${KCP_COMMIT_SNAPSHOT}/"
if [[ -n "${KCP_4_9_BN}" ]] ; then
	KCP_SRC_4_9_URI="
		${KCP_URI_BASE}/outdated_versions/${KCP_4_9_BN}.patch
			-> ${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch
	"
fi
if [[ -n "${KCP_8_1_BN}" ]] ; then
	KCP_SRC_8_1_URI="
		${KCP_URI_BASE}/outdated_versions/${KCP_8_1_BN}.patch
			-> ${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch
	"
fi
if [[ -n "${KCP_9_1_BN}" ]] ; then
	KCP_SRC_9_1_URI="
		${KCP_URI_BASE}${KCP_9_1_BN}.patch
			-> ${KCP_9_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch
	"
fi
KCP_SRC_CORTEX_A72_URI="${KCP_URI_BASE}${KCP_CORTEX_A72_BN}.patch -> ${KCP_CORTEX_A72_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch"

MULTIGEN_LRU_COMMITS=\
"${PATCH_MULTIGEN_LRU_COMMIT_A}^..${PATCH_MULTIGEN_LRU_COMMIT_D}" # [oldest,newest] [top,bottom]
MULTIGEN_LRU_COMMITS_SHORT=\
"${PATCH_MULTIGEN_LRU_COMMIT_A:0:7}-${PATCH_MULTIGEN_LRU_COMMIT_D:0:7}" # [oldest,newest] [top,bottom]
MULTIGEN_LRU_BASE_URI=\
"https://github.com/torvalds/linux/compare/${MULTIGEN_LRU_COMMITS}"
if [[ -n "${ZEN_KV}" ]] ; then
	MULTIGEN_LRU_FN="multigen_lru-${ZEN_KV}-${MULTIGEN_LRU_COMMITS_SHORT}.patch"
	MULTIGEN_LRU_SRC_URI="
		${MULTIGEN_LRU_BASE_URI}.patch -> ${MULTIGEN_LRU_FN}
	"
fi

ZEN_MULTIGEN_LRU_COMMITS=\
"${PATCH_ZEN_MULTIGEN_LRU_COMMIT_A}^..${PATCH_ZEN_MULTIGEN_LRU_COMMIT_D}" # [oldest,newest] [top,bottom]
ZEN_MULTIGEN_LRU_COMMITS_SHORT=\
"${PATCH_ZEN_MULTIGEN_LRU_COMMIT_A:0:7}-${PATCH_ZEN_MULTIGEN_LRU_COMMIT_D:0:7}" # [oldest,newest] [top,bottom]
ZEN_MULTIGEN_LRU_BASE_URI=\
"https://github.com/torvalds/linux/compare/${ZEN_MULTIGEN_LRU_COMMITS}"
if [[ -n "${ZEN_KV}" ]] ; then
	ZEN_MULTIGEN_LRU_FN="zen-multigen_lru-${ZEN_KV}-${ZEN_MULTIGEN_LRU_COMMITS_SHORT}.patch"
	ZEN_MULTIGEN_LRU_SRC_URI="
		${ZEN_MULTIGEN_LRU_BASE_URI}.patch -> ${ZEN_MULTIGEN_LRU_FN}
	"
fi

ZEN_MUQSS_BASE_URI=\
"https://github.com/torvalds/linux/commit/"

is_zen_muquss_excluded() {
	local wanted_commit="${1}"
	local bad_commit
	for bad_commit in ${ZEN_MUQSS_EXCLUDED_COMMITS[@]} ; do
		[[ "${bad_commit}" == "${wanted_commit}" ]] && return 0
	done
	return 1
}

gen_zen_muqss_uris() {
	local s=""
	local c
	for c in ${ZEN_MUQSS_COMMITS[@]} ; do
		s+=" ${ZEN_MUQSS_BASE_URI}${c}.patch -> zen-muqss-${ZEN_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${ZEN_KV}" ]] ; then
	ZEN_MUQSS_SRC_URIS=" "$(gen_zen_muqss_uris)
fi

CK_BASE_URI=\
"https://github.com/torvalds/linux/commit/"
gen_ck_uris() {
	local s=""
	local c
	for c in ${CK_COMMITS[@]} ; do
		s+=" ${CK_BASE_URI}${c}.patch -> ck-${MUQSS_VER}-${CK_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${CK_KV}" ]] ; then
	CK_SRC_URIS=" "$(gen_ck_uris)
fi

CFI_BASE_URI=\
"https://github.com/torvalds/linux/commit/"
gen_cfi_uris() {
	local s=""
	local c
	for c in ${CFI_COMMITS[@]} ; do
		s+=" ${CFI_BASE_URI}${c}.patch -> cfi-${CFI_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${CFI_KV}" ]] ; then
	CFI_SRC_URIS=" "$(gen_cfi_uris)
fi

gen_kcfi_uris() {
	local s=""
	local c
	for c in ${KCFI_COMMITS[@]} ; do
		s+=" ${CFI_BASE_URI}${c}.patch -> kcfi-${KCFI_KV}-${c:0:7}.patch"
	done
	echo "${s}"
}
if [[ -n "${KCFI_KV}" ]] ; then
	KCFI_SRC_URIS=" "$(gen_kcfi_uris)
fi

LINUX_REPO_URI=\
"https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

if ver_test "${KV_MAJOR_MINOR}" -ge "6.7" ; then
NEST_FN="nest_patch_with_spinning_6.7" # Similar to 6.6 behavior
NEST_FN_ALT="nest_patch_nospin_6.7" # New change
NEST_URI="
https://gitlab.inria.fr/nest-public/nest-artifact/-/raw/main/extras/nest_patch_with_spinning_6.7?inline=false -> ${NEST_FN}
https://gitlab.inria.fr/nest-public/nest-artifact/-/raw/main/extras/nest_patch_nospin_6.7?inline=false -> ${NEST_FN_ALT}
"
elif ver_test "${KV_MAJOR_MINOR}" -ge "6.1" ; then
NEST_FN="Nest_v6.6.patch"
NEST_URI="https://gitlab.inria.fr/nest-public/nest-artifact/-/raw/main/extras/Nest_v6.6.patch?inline=false -> ${NEST_FN}"
elif ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
NEST_FN="Nest_v5.15.patch"
NEST_URI="https://gitlab.inria.fr/nest-public/nest-artifact/-/raw/main/extras/Nest_v5.15_patch?inline=false -> ${NEST_FN}"
fi

O3_SRC_URI="https://github.com/torvalds/linux/commit/"
O3_ALLOW_FN="O3-allow-unrestricted-${PATCH_ALLOW_O3_COMMIT:0:7}.patch"
O3_ALLOW_SRC_URI="${O3_SRC_URI}${PATCH_ALLOW_O3_COMMIT}.patch -> ${O3_ALLOW_FN}"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT:0:7}.patch"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT:0:7}.patch"
O3_CO_SRC_FN="${PATCH_O3_CO_COMMIT}.patch"
O3_RO_SRC_FN="${PATCH_O3_RO_COMMIT}.patch"
O3_CO_SRC_URI="${O3_SRC_URI}${O3_CO_SRC_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URI="${O3_SRC_URI}${O3_RO_SRC_FN} -> ${O3_RO_FN}"

PDS_URI_BASE=\
"https://gitlab.com/alfredchen/PDS-mq/raw/master/${KV_MAJOR_MINOR}/"
PDS_FN="v${KV_MAJOR_MINOR}_pds${PATCH_PDS_VER}.patch"
PDS_SRC_URI="${PDS_URI_BASE}${PDS_FN}"

PRJC_URI_BASE=\
"https://gitlab.com/alfredchen/projectc/-/raw/master/${KV_MAJOR_MINOR}${PRJC_LTS}/"
PRJC_FN="prjc_v${PATCH_PROJC_VER}.patch"
PRJC_SRC_URI="${PRJC_URI_BASE}${PRJC_FN}"

RT_BASE_URI=\
"http://cdn.kernel.org/pub/linux/kernel/projects/rt/${KV_MAJOR_MINOR}/"
RT_FN="patches-${PATCH_RT_VER}.tar.xz"
RT_SRC_URI="${RT_BASE_URI}${RT_FN}"
RT_ALT_FN="patches-${PATCH_RT_VER}.tar.gz"
RT_SRC_ALT_URI="${RT_BASE_URI}${RT_ALT_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_VER}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_VER}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_PDF_FN="tresor.pdf"
TRESOR_DOMAIN_URI="www1.informatik.uni-erlangen.de"
TRESOR_BASE_URI=\
"https://${TRESOR_DOMAIN_URI}/filepool/projects/tresor/"
TRESOR_AESNI_SRC_URI="${TRESOR_BASE_URI}${TRESOR_AESNI_FN}"
TRESOR_I686_SRC_URI="${TRESOR_BASE_URI}${TRESOR_I686_FN}"
TRESOR_SYSFS_SRC_URI="${TRESOR_BASE_URI}${TRESOR_SYSFS_FN}"
TRESOR_README_SRC_URI=\
"https://${TRESOR_DOMAIN_URI}/tresor?q=content/readme"
TRESOR_RESEARCH_PDF_SRC_URI=\
"${TRESOR_BASE_URI}${TRESOR_PDF_FN}"
TRESOR_README_SRC_URI="${TRESOR_README_SRC_URI} -> ${TRESOR_README_FN}"

UKSM_BASE_URI=\
"https://raw.githubusercontent.com/dolohow/uksm/master/v${KV_MAJOR}.x/"
UKSM_FN="uksm-${KV_MAJOR_MINOR}.patch"
UKSM_SRC_URI="${UKSM_BASE_URI}${UKSM_FN}"

if [[ -n "${ZEN_KV}" ]] ; then
	ZEN_SAUCE_URIS=$(gen_zen_sauce_uris "${PATCH_ZEN_SAUCE_COMMITS[@]}")
fi

if ver_test ${MY_PV} -eq ${KV_MAJOR_MINOR} ; then
	KERNEL_NO_POINT_RELEASE="1"
elif ver_test ${MY_PV} -eq ${KV_MAJOR_MINOR}.1 ; then
	KERNEL_0_TO_1_ONLY="1"
fi

if [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
	KERNEL_PATCH_URIS=()
elif [[ -n "${KERNEL_0_TO_1_ONLY}" && "${KERNEL_0_TO_1_ONLY}" == "1" ]] ; then
	KERNEL_PATCH_URIS=(
		${KERNEL_PATCH_0_TO_1_URI}
	)
	KERNEL_PATCH_FNS_EXT=(
		patch-${KV_MAJOR_MINOR}.1.xz
	)
	KERNEL_PATCH_FNS_NOEXT=(
		patch-${KV_MAJOR_MINOR}.1
	)
else
	KERNEL_PATCH_TO_FROM=(
		$(gen_kernel_seq $(ver_cut 3 ${MY_PV}))
	)
	KERNEL_PATCH_FNS_EXT=(
		${KERNEL_PATCH_TO_FROM[@]/%/.xz}
	)
	KERNEL_PATCH_FNS_EXT=(
		${KERNEL_PATCH_FNS_EXT[@]/#/patch-${KV_MAJOR_MINOR}.}
	)
	KERNEL_PATCH_FNS_NOEXT=(
		${KERNEL_PATCH_TO_FROM[@]/#/patch-${KV_MAJOR_MINOR}.}
	)
	KERNEL_PATCH_URIS=(
		${KERNEL_PATCH_0_TO_1_URI}
		${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASE_URI}}
	)

	# Do not change the order
	KERNEL_PATCH_FNS_EXT=(
		patch-${KV_MAJOR_MINOR}.1.xz
		${KERNEL_PATCH_FNS_EXT[@]}
	)

	# Do not change the order
	KERNEL_PATCH_FNS_NOEXT=(
		patch-${KV_MAJOR_MINOR}.1
		${KERNEL_PATCH_TO_FROM[@]/#/patch-${KV_MAJOR_MINOR}.}
	)
fi

# Keep the sources clean upon install.
PATCH_OPTS="--no-backup-if-mismatch -r - -p1"

RESTRICT="mirror strip" # See ot-kernel_src_install() for reasons why stripping is not allowed.

# @FUNCTION: _fpatch
# @DESCRIPTION:
# Filtered patch
# @CODE
# Parameters:
# $1 - path of the patch
# @CODE
_fpatch() {
	local path="${1}"
	local msg_extra="${2}"
	if declare -f ot-kernel_filter_patch_cb > /dev/null ; then
		ot-kernel_filter_patch_cb "${path}" "${msg_extra}"
	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: _dpatch
# @DESCRIPTION:
# Patch with die
_dpatch() {
	local opts="${1}"
	local path="${2}"
	local msg_extra="${3}"
einfo "Applying ${path} ${msg_extra}"
	patch ${opts} -i "${path}" || die
}

# @FUNCTION: _tpatch
# @DESCRIPTION:
# Patch with no die used for conflict resolution.
# Refrain from using it though because it requires periodic revaluation in
# larger patchsets that are not split which future FAILED hunks may not be
# caught.
_tpatch() {
	local opts="${1}"
	local path="${2}"
	local n_failures_expected="${3}" # must be the same as n_failures_actual (Part 1)
	local n_reversed_expected="${4}" # must be the same as n_reversed_actual (Part 2)
	local msg_extra="${5}"
einfo
einfo "Applying ${path} ${msg_extra}"
einfo "  with ${n_failures_expected} expected hunk(s) failed and"
einfo "  with ${n_reversed_expected} expected reversed / previous-patch detected"
einfo "which will be resolved or patched immediately."
einfo
einfo "These estimates may be far less than the actual."
einfo

	# Part 1
	local n_failures_actual=0
	local x_i
	for x_i in $(patch ${opts} --dry-run -i "${path}" \
		| grep -E -e "hunks? FAILED" | cut -f 1 -d " ") ; do
		n_failures_actual=$((${n_failures_actual}+${x_i}))
	done
	if (( ${n_failures_actual} != ${n_failures_expected} )) ; then
eerror
eerror "${path} needs a rebase. n_failures_actual=${n_failures_actual} \
n_failures_expected=${n_failures_expected}"
eerror
		die
	fi

	# Part 2
	local n_reversed_actual=$(patch ${opts} --dry-run -i "${path}" \
			| grep -F -e "Reversed (or previously applied) patch detected!" \
			| wc -l)
	if (( ${n_reversed_actual} != ${n_reversed_expected} )) ; then
eerror
eerror "${path} needs a rebase. n_reversed_actual=${n_reversed_actual} \
n_reversed_expected=${n_reversed_expected}"
eerror
		die
	fi

	if (( ${n_reversed_expected} > 0 )) ; then
		opts="-N ${opts}"
	fi

	patch ${opts} -i "${path}" || true
}

# @FUNCTION: ot-kernel_pkg_pretend
# @DESCRIPTION:
# Perform checks and warnings before emerging
ot-kernel_pkg_pretend() {
	if declare -f ot-kernel_pkg_pretend_cb > /dev/null ; then
		ot-kernel_pkg_pretend_cb
	fi
}

# @FUNCTION: _report_eol
# @DESCRIPTION:
# Reports the estimated End Of Life (EOL).  Sourced from
# https://www.kernel.org/category/releases.html
_report_eol() {
	if [[ "${KV_MAJOR_MINOR}" == "6.6" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2026."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "6.1" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2026."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "5.15" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2026."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "5.10" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2026."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "5.4" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2025."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "4.19" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel series is"
einfo "Dec 2024."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${KV_MAJOR_MINOR}" == "4.14" ]] ; then
einfo
einfo "This kernel is now End Of Life (EOL) for the ${KV_MAJOR_MINOR} kernel"
einfo "since Jan 2024.  It will be removed as soon as it is delisted from"
einfo "The Linux Kernel Archives."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	else
ewarn
ewarn "The ${KV_MAJOR_MINOR} kernel series is not a Long Term Support (LTS)"
ewarn "kernel.  It may suddenly stop receiving security updates completely"
ewarn "between a week to several months."
ewarn
einfo
einfo "Use the virtual/ot-sources-stable meta package to ensure a smooth"
einfo "update between stable releases differing between major.minor branches"
einfo
	fi
}

# @FUNCTION: check_zen_tune_deps
# @DESCRIPTION:
# Checks zen-tune's dependency on zen-sauce.  This function resolves
# commit dependencies (as in left commit requires right commit) only for
# the zen tune commit set.
#
# ot-kernel_load_config must be called before using this function.
#
check_zen_tune_deps() {
	local zen_tune_commit="${1}" # c in C, where C is all zen tune commits.
	local v="ZEN_SAUCE_WHITELIST"
	if ver_test ${KV_MAJOR_MINOR} -ge 5.10 ; then
		local p
		for p in ${PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE[@]} ; do
			local zleft=$(echo "${p}" | cut -f 1 -d ":") # Left
			local zright=$(echo "${p}" | cut -f 2 -d ":") # Right
	# The left commit depends on right commit.
			if [[ "${zleft}" == "${zen_tune_commit}" ]] ; then
	# haystack =~ needle, where haystack is all commits in ZEN_SAUCE_WHITELIST
				if [[ \
					   "${!v}" =~ "${zright}" \
					|| "${!v}" =~ "${zright:0:7}" \
					|| "${!v}" =~ "*" \
					|| "${!v}" =~ "all" \
				]] ; then
					:
				else
eerror
eerror "zen-tune requires one of the following..."
eerror
eerror "  *"
eerror "  all"
eerror "  ${zright:0:7}"
eerror "  ${zright}"
eerror
eerror "be added to ${v} and also the zen-sauce USE flag to continue."
eerror
eerror "QA:  !v -> |${!v}|"
eerror
					die
				fi
			fi
		done
	fi
}

# @FUNCTION: zen_tune_setup
# @DESCRIPTION:
# Checks zen-tune's dependency on zen-sauce at pkg_setup
zen_tune_setup() {
	:
}

# @FUNCTION: zen_sauce_setup
# @DESCRIPTION:
# Checks the existance for the ZEN_SAUCE_WHITELIST variable
zen_sauce_setup() {
	if use zen-sauce ; then
		if [[ -z "${ZEN_SAUCE_WHITELIST}" ]] ; then
ewarn
ewarn "Detected empty ZEN_SAUCE_WHITELIST.  Some zen-sauce commits will not be"
ewarn "added."
ewarn
ewarn "For details, see metadata.xml"
ewarn "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)"
ewarn
		fi
	fi
}

# @FUNCTION: _check_network_sandbox
# @DESCRIPTION:
# Check if sandbox is more lax when downloading in unpack phase
_check_network_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to use live sources or to download logos."
eerror
		die
	fi
}

NO_INSTR_FIX_COMMIT="193e41c987127aad86d0380df83e67a85266f1f1"
NO_INSTR_FIX_TIMESTAMP="1624048424" # Fri Jun 18 08:33:44 PM UTC 2021

NO_INSTRUMENT_FUNCTION="a63d4f6cbab133b0f1ce9afb562546fcc5bb2680"
NO_INSTRUMENT_FUNCTION_TIMESTAMP="1624300463" # Mon Jun 21 06:34:23 PM UTC 2021

PGO_LLVM_SUPPORTED_VERSIONS=(
# Bump also IPD_RAW_VER_MAX when profraw version bumped
# Search for INSTR_PROF_RAW_VERSION in
#	"19.0.0.9999" # profraw v9
	"18.1.0" # profraw v9
	"17.0.6" # profraw v8
	"17.0.5"
	"17.0.4"
	"17.0.3"
	"17.0.2"
	"17.0.1"
	"17.0.0"
	"16.0.6" # profraw v8
	"16.0.5"
	"16.0.4"
	"16.0.3"
	"16.0.2"
	"16.0.1"
	"16.0.0"
	"15.0.7" # profraw v8
	"15.0.6"
	"15.0.5"
	"15.0.4"
	"15.0.3"
	"15.0.2"
	"15.0.1"
	"15.0.0"
	"14.0.6" # profraw v8
	"14.0.5"
	"14.0.4"
	"14.0.3"
	"14.0.2"
	"14.0.1"
	"14.0.0"
	"13.0.1" # profraw v7
	"13.0.0"
)

# IPD_RAW_VER* is the same as INSTR_PROF_RAW_VERSION.
IPD_RAW_VER=5 # < llvm-13 Dec 28, 2020
IPD_RAW_VER_MIN=6
IPD_RAW_VER_MAX=9
verify_profraw_compatibility() {
einfo "Verifying profraw version compatibility"
	# The profiling data format is very version sensitive.
	# If wrong version, expect something like this:
	# warning: /usr/src/linux/vmlinux.profraw: unsupported instrumentation profile format version
	# error: no profile can be merged

# This data structure must be kept in sync.
# https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/tree/kernel/pgo/fs.c?h=for-next/clang/pgo#n63
# https://github.com/llvm/llvm-project/blob/main/compiler-rt/include/profile/InstrProfData.inc                     # Search for INSTR_PROF_RAW_VERSION

	local found_upstream_version=0 # corresponds to original patch requirements for < llvm 13 (broken)
	local found_patched_version=0 # corresponds to oiledmachine patches to use >= llvm 13 (fixed)
	local pv
	for pv in ${PGO_LLVM_SUPPORTED_VERSIONS[@]} ; do
		( ! ot-kernel_has_version "~sys-devel/llvm-${pv}" ) && continue
einfo "pv=${pv}"
		local instr_prof_raw_ver=$(cat \
"${ESYSROOT}/usr/lib/llvm/$(ver_cut 1 ${found_ver})/include/llvm/ProfileData/InstrProfData.inc" \
			| grep "INSTR_PROF_RAW_VERSION" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
einfo "instr_prof_raw_ver=${instr_prof_raw_ver}"
		if (( ${instr_prof_raw_ver} == ${IPD_RAW_VER} )) ; then
			found_upstream_version=1
		fi
		if (( ${instr_prof_raw_ver} >= ${IPD_RAW_VER_MIN} && ${instr_prof_raw_ver} <= ${IPD_RAW_VER_MAX} )) ; then
			found_patched_version=1
		fi
	done
einfo "DEBUG:  instr_prof_raw_ver=${instr_prof_raw_ver}"
einfo "DEBUG:  IPD_RAW_VER_MIN=${IPD_RAW_VER_MIN}"
einfo "DEBUG:  IPD_RAW_VER_MAX=${IPD_RAW_VER_MAX}"
	if (( ${found_upstream_version} != 1 )) ; then
eerror
eerror "No installed LLVM versions are with compatible."
eerror "INSTR_PROF_RAW_VERSION == ${IPD_RAW_VER} is required"
eerror
	fi
	if (( ${found_patched_version} != 1 )) ; then
eerror
eerror "INSTR_PROF_RAW_VERSION >= ${IPD_RAW_VER_MIN} and"
eerror "INSTR_PROF_RAW_VERSION <= ${IPD_RAW_VER_MAX} is required"
eerror
eerror "No installed LLVM versions are compatible.  Please send an issue"
eerror "request with your LLVM version.  If you are using a live LLVM version,"
eerror "send the EGIT_VERSION found in"
eerror "\${ESYSROOT}/var/db/pkg/sys-devel/llvm-\${pv}*/environment.bz2"
eerror
eerror "You may also use one of the supported LLVM versions for PGO support below:"
eerror "${PGO_LLVM_SUPPORTED_VERSIONS[@]}"
eerror
		die
	fi
}

# @FUNCTION: display_required_clang
# @DESCRIPTION:
# Show a user message of the clang versions supported for the profraw raw version.
display_required_clang() {
einfo
einfo "For Clang PGO support, if you use a live ebuild, only the latest commit"
einfo "for one of these live versions (with the 9999 version) is supported."
einfo "You may also use one of the Clang versions listed for Clang PGO:"
einfo
einfo "${PGO_LLVM_SUPPORTED_VERSIONS[@]}"
einfo
}

# @FUNCTION: ot-kernel_use
# @DESCRIPTION:
# Analog of use keyword but in the context of per build env
ot-kernel_use() {
	for u in ${OT_KERNEL_USE} ; do
		[[ "${u}" =~ ^"-" ]] && continue
		[[ "${u}" =~ ^"+" ]] && u="${u:1}"
		has ${u} ${IUSE_EFFECTIVE} || continue
	# IUSE will say false if hard mask
		use ${u} && [[ "${1}" == "${u}" ]] && return 0
	done
	return 1
}

# @FUNCTION: verify_gcc_header_compat_with_clang
# @DESCRIPTION:
# Check and avoid header incompatibility
verify_gcc_header_compat_with_clang() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local GCC_SLOT_PGO_MAX="12"
	if ver_test "${GCC_SLOT_PGO_MAX}" -ne "${gcc_current_profile_slot}" ; then
ewarn
ewarn "Detected possible header incompability between GCC and Clang."
ewarn
ewarn "Actual GCC slot:  ${gcc_current_profile_slot}"
ewarn "Expected GCC slot:  ${GCC_SLOT_PGO_MAX}"
ewarn
	fi
ewarn
ewarn "The \"Assumed value of MB_LEN_MAX wrong\" error appears, you must switch"
ewarn "switch to == GCC ${GCC_SLOT_PGO_MAX}.  Do"
ewarn
ewarn "  eselect gcc list"
ewarn "  eselect gcc set <CHOST>-${GCC_SLOT_PGO_MAX}"
ewarn "  source /etc/profile"
ewarn
ewarn "or whatever gcc version works."
ewarn
ewarn "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
ewarn "to the default immediately after this package has been merged."
ewarn
}

# @FUNCTION: ot-kernel_pkg_setup
# @DESCRIPTION:
# Perform checks, warnings, and initialization before emerging
ot-kernel_pkg_setup() {
ewarn
ewarn "The defaults use cfs (or the stock CPU scheduler) per build"
ewarn "configuration."
ewarn
ewarn "The build configuration scheme has changed.  Please see"
ewarn "metadata.xml (or \`epkginfo -x ot-sources::oiledmachine-overlay\`) for"
ewarn "documentation to customize the per environment build variable and"
ewarn "patching process to build more secure and higher performant"
ewarn "configurations and to override the scheduler default."
ewarn
	_report_eol

	if declare -f ot-kernel_pkg_setup_cb > /dev/null ; then
		ot-kernel_pkg_setup_cb
	fi
	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		if use zen-sauce ; then
			zen_sauce_setup
			zen_tune_setup
		fi
	fi
	if [[ "${PV}" =~ "9999" ]] ; then
		_check_network_sandbox
	fi

	if [[ -n "${OT_KERNEL_LOGO_URI}" ]] ; then
		_check_network_sandbox
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if [[ -z "${OT_KERNEL_DEVELOPER}" ]] && use tresor && ! tc-is-cross-compiler ; then
			if [[ "${arch}" == "x86" ]] ; then
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
ewarn "Tresor for i686 requires SSE2 CPU support."
#					die
				fi
				if ! grep -F -q "mmx" /proc/cpuinfo ; then
ewarn "Tresor for i686 requires MMX CPU support."
#					die
				fi
			elif [[ "${arch}" == "x86_64" ]] && ! ot-kernel_use cpu_flags_x86_aes ; then
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
ewarn "Tresor for x86_64 requires SSE2 CPU support."
#					die
				fi
				if ! grep -F -q "mmx" /proc/cpuinfo ; then
ewarn "Tresor for x86_64 requires MMX CPU support."
#					die
				fi
			elif [[ "${arch}" == "x86_64" ]] && ot-kernel_use cpu_flags_x86_aes ; then
				if ! grep -F -q "aes" /proc/cpuinfo ; then
ewarn "Tresor for x86_64 with aesni requires AES-NI CPU support."
#					die
				fi
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
ewarn "Tresor for x86_64 with aesni requires SSE2 CPU support."
#					die
				fi
			fi
		fi
	fi

	if has clang ${IUSE_EFFECTIVE} ; then
		if use clang ; then
			display_required_clang
			#verify_profraw_compatibility
			verify_gcc_header_compat_with_clang
		fi
	fi

	if ot-kernel_has_version "sys-boot/mokutil" ; then
		if ! ( mokutil --test-key "${OT_KERNEL_PUBLIC_KEY}" | grep "is already enrolled" ) ; then
ewarn "Did not find key in MOK"
			if [[ "${OT_KERNEL_ADD_KEY_TO_MOK}" ]] ; then
einfo "Auto adding key in MOK"
				mokutil --root-pw -import "${OT_KERNEL_PUBLIC_KEY}" || die
			fi
		fi
	fi

	if (( $(find "/etc/portage/ot-sources/${KV_MAJOR_MINOR}/" -type f -name "env" | wc -l) == 0 )) ; then
eerror
eerror "Missing per extraconfig env file."
eerror "See the 'The config file-directory structure' section metadata.xml"
eerror "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for instructions for"
eerror "creating per extraconfig env files."
eerror
		die
	fi

#
# PGO transfer paths overview:
#
# In memory PGO profile -> outside ebuild cache
# outside ebuild cache -> inside ebuild staging area
#
	dump_profraw
	dump_gcda

	export PATH_ORIG="${PATH}"

# TODO: place in build context
	if [[ "${OT_KERNEL_USE_GCC_KPGO}" == "1" ]] ; then
		if has_version "sys-devel/gcc-kpgo" && use pgo ; then
einfo "Detected sys-devel/gcc-kpgo"
			export PATH="${ESYSROOT}/usr/lib/gcc-kpgo/usr/bin:${PATH}"
			if [[ "${FEATURES}" =~ "ccache" ]] ; then
				export CCACHE_PATH="${ESYSROOT}/usr/lib/gcc-kpgo/usr/bin"
			fi
			GCC_PKG="sys-devel/gcc-kpgo"
		else
			GCC_PKG="sys-devel/gcc"
		fi

		if ( has ccache ${FEATURES} && use pgo && has clang ${IUSE_EFFECTIVE} && ! use clang ) \
			|| ( has ccache ${FEATURES} && use pgo && ! has clang ${IUSE_EFFECTIVE} ) ; then
ewarn
ewarn "ccache is not supported in FEATURES with GCC PGO."
ewarn "Trying to disable."
ewarn
einfo "PATH=${PATH} (before)"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -E -e "/ccache/d" \
				| tr "\n" ":" \
				| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_COMPAT[0]}/bin:${PWD}/install/bin|g")
einfo "PATH=${PATH} (after)"
		fi
	fi
}

# @FUNCTION: dump_profraw
# @DESCRIPTION:
# Copies the profraw for Clang PGO.
# It has to be done outside of the sandbox.
dump_profraw() {
	if [[ "${FORCE_PGO_PHASE}" =~ ("PGI"|"PGO"|"PG0") ]] ; then
		return
	fi
	local profraw_spath
	local profraw_spath="/sys/kernel/debug/pgo/vmlinux.profraw" # new patch
	if ! [[ -e "${profraw_spath}" ]] ; then
		profraw_spath="/sys/kernel/debug/pgo/profraw" # old patch
	fi
	[[ -e "${profraw_spath}" ]] || return
	local arch=$(cat /proc/version | cut -f 3 -d " ")
	arch="${arch##*-}"
	local extraversion=$(cat /proc/version | cut -f 3 -d " " | sed -e "s|-${arch}||g" | cut -f 2- -d "-")
	local version=$(cat /proc/version | cut -f 3 -d " " | cut -f 1 -d "-")
	[[ "${version}" != "${MY_PV}" ]] && return
	local profraw_dpath="${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/llvm/vmlinux.profraw"
	if [[ "${FORCE_PGO_PHASE}" =~ ("PGI"|"PG0") ]] ; then
		rm -rf "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/llvm"
	fi
	mkdir -p "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/llvm" || die
	if [[ -e "${profraw_spath}" ]] ; then
		cat "${profraw_spath}" > "${profraw_dpath}" 2>/dev/null || true
	fi
	if [[ -e "${profraw_spath}" && ! -e "${profraw_dpath}" ]] ; then
einfo "Copying ${profraw_spath}"
		cat "${profraw_spath}" > "${profraw_dpath}" || die
		chmod 0644 "${profraw_dpath}" || die
	else
		if [[ -e "${profraw_dpath}" ]] ; then
einfo
einfo "Using a cached ${profraw_dpath}.  Delete *.profraw and *.profdata if"
einfo "stale or to force a PGO profile update."
einfo
		fi
	fi
	chown -R portage:portage "${OT_KERNEL_PGO_DATA_DIR}"
}

# @FUNCTION: dump_gcda
# @DESCRIPTION:
# Copies the profraw for GCC PGO.
# It has to be done outside of the sandbox.
dump_gcda() {
#/sys/kernel/debug/gcov/var/tmp/portage/sys-kernel/ot-sources-6.5.2/work/linux-6.5.2-builder/sound/usb/clock.gcno ; symlink to deleted file
#/sys/kernel/debug/gcov/var/tmp/portage/sys-kernel/ot-sources-6.5.2/work/linux-6.5.2-builder/sound/usb/clock.gcda ; profile data
	local workdir
	local s
	[[ -e "/sys/kernel/debug/gcov/var" ]] || return
	cd "/sys/kernel/debug/gcov" || die
	local arch=$(cat /proc/version | cut -f 3 -d " ")
	arch="${arch##*-}"
	local extraversion=$(cat /proc/version | cut -f 3 -d " " | sed -e "s|-${arch}||g" | cut -f 2- -d "-")
	local version=$(cat /proc/version | cut -f 3 -d " " | cut -f 1 -d "-")
	[[ "${version}" != "${MY_PV}" ]] && return
	if [[ "${FORCE_PGO_PHASE}" =~ ("PGI"|"PG0") ]] ; then
		rm -rf "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc"
	fi
	mkdir -p "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc" || true
	local n_gcda=$(find "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc" -name "*.gcda" 2>/dev/null | wc -l)
	[[ -z "${n_gcda}" ]] && n_gcda=0
	if (( ${n_gcda} == 0 )) ; then
einfo "Copying GCC profile data"
		IFS=$'\n'
		local L=(
			$(find . -type f -name "*.gcda")
		)
		local f
		for f in ${L[@]} ; do
			local new_fn=$(echo "${f}" \
				| sed -e "s|^\.||g" \
				| sed -e "s|/|#|g")
			cat \
				"${f}" \
				> \
				"${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc/${new_fn}" \
				|| die
		done
		IFS=$' \t\n'
	else
		if [[ -e "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc" ]] ; then
einfo
einfo "Using a cached GCC profile data from"
einfo "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}/gcc.  Delete *.gcda if"
einfo "stale or to force a PGO profile update."
einfo
		fi
	fi
	chown -R portage:portage "${OT_KERNEL_PGO_DATA_DIR}"
}

# @FUNCTION: get_current_tag_for_k_major_minor_branch
# @DESCRIPTION:
# Gets the tag name at HEAD
get_current_tag_for_k_major_minor_branch() {
	d="${EDISTDIR}/ot-sources-src/linux"
	pushd "${d}" >/dev/null 2>&1 || die
		echo $(git --no-pager tag --points-at HEAD)
	popd >/dev/null 2>&1 || die
}

# @FUNCTION: get_current_commit_for_k_major_minor_branch
# @DESCRIPTION:
# Gets the commit ID at HEAD
get_current_commit_for_k_major_minor_branch() {
	d="${EDISTDIR}/ot-sources-src/linux"
	pushd "${d}" >/dev/null 2>&1 || die
		echo $(git rev-parse HEAD)
	popd >/dev/null 2>&1 || die
}

# @FUNCTION: ot-kernel_unpack_live
# @DESCRIPTION:
# Fetches a live copy of the linux kernel repo.
ot-kernel_unpack_live() {
einfo "Fetching the vanilla Linux kernel sources.  It may take hours."

	if use fallback-commit && [[ -n "${LINUX_SOURCES_FALLBACK_COMMIT}" ]] ; then
		EGIT_COMMIT="${LINUX_SOURCES_FALLBACK_COMMIT}"
	fi
	EGIT_BRANCH="master"
	EGIT_REPO_URI=${EGIT_LINUX_SOURCES_URI:-"https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"}
	EGIT_CHECKOUT_DIR="${S}"

	git-r3_fetch
	git-r3_checkout

	cd "${S}" || die
}

# @FUNCTION: ot-kernel_unpack_tarball
# @DESCRIPTION:
# Unpacks the main tarball
ot-kernel_unpack_tarball() {
	cd "${WORKDIR}" || die
	unpack "${KERNEL_SERIES_TARBALL_FN}"
}

# @FUNCTION: ot-kernel_unpack_point_releases
# @DESCRIPTION:
# Unpacks all point release tarballs
ot-kernel_unpack_point_releases() {
	cd "${T}" || die
	local p
	for p in ${KERNEL_PATCH_FNS_EXT[@]} ; do
		unpack "${p}"
	done
}

# @FUNCTION: apply_rt
# @DESCRIPTION:
# Apply the PREEMPT_RT patches.
apply_rt() {
	if [[ \
		   "${arch}" == "arm" \
		|| "${arch}" == "arm64" \
		|| "${arch}" == "powerpc" \
		|| "${arch}" == "x86" \
		|| "${arch}" == "x86_64" \
	]] ; then
einfo "Applying PREEMPT_RT patches"
	else
einfo "Skipping PREEMPT_RT patches which is not supported for ARCH=${arch}"
		return
	fi
	mkdir -p "${T}/rt" || die
	pushd "${T}/rt" >/dev/null 2>&1 || die
		if [[ -e "${EDISTDIR}/${RT_FN}" ]] ; then
			unpack "${EDISTDIR}/${RT_FN}"
		elif [[ -e "${EDISTDIR}/${RT_ALT_FN}" ]] ; then
			unpack "${EDISTDIR}/${RT_ALT_FN}"
		fi
	popd >/dev/null 2>&1 || die
	local p
	for p in $(cat "${T}/rt/patches/series" | grep -E -e "^[^#]") ; do
		_fpatch "${T}/rt/patches/${p}"
	done
}

# @FUNCTION: apply_zen_sauce
# @DESCRIPTION:
# Applies whitelisted zen sauce patches.
apply_zen_sauce() {
	local whitelisted=""
	local blacklisted=""

	local c
	for c in "${ZEN_SAUCE_WHITELIST}" ; do
	# Add commit hashes only
		[[ "${c}" == "*" ]] && continue
		[[ "${c}" == "all" ]] && continue
		[[ "${c}" == "zen-sauce" ]] && continue
		[[ "${c}" == "zen-tune" ]] && continue
		whitelisted+=" ${c:0:7}"
	done

	for c in "${ZEN_SAUCE_BLACKLIST}" ; do
	# Add commit hashes only
		[[ "${c}" == "*" ]] && continue
		[[ "${c}" == "all" ]] && continue
		[[ "${c}" == "zen-sauce" ]] && continue
		[[ "${c}" == "zen-tune" ]] && continue
		blacklisted+=" ${c:0:7}"
	done

	if [[ "${CFLAGS}" =~ "-O3" ]] ; then
		if ver_test ${KV_MAJOR_MINOR} -eq 4.19 ; then
			whitelisted+=" ${PATCH_O3_CO_COMMIT:0:7}"
			whitelisted+=" ${PATCH_O3_RO_COMMIT:0:7}"
		else
			whitelisted+=" ${PATCH_ALLOW_O3_COMMIT:0:7}"
		fi
	fi

	local kcp_provider=$(ot-kernel_get_kcp_provider)
	if ! [[ "${kcp_provider}" =~ "zen-sauce" ]] ; then
		blacklisted+=" ${PATCH_KCP_COMMIT:0:7}"
	fi

	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		local bl_all_zen_sauce=0
		local bl_all_zen_tune=0
		local wl_all_zen_sauce=0
		local wl_all_zen_tune=0
		for c in "${ZEN_SAUCE_BLACKLIST}" ; do
			if [[ \
				   "${c}" == "*" \
				|| "${c}" == "all" \
				|| "${c}" == "zen-tune" \
			]] ; then
				bl_all_zen_tune=1
			fi
			if [[ \
				   "${c}" == "*" \
				|| "${c}" == "all" \
				|| "${c}" == "zen-sauce" \
			]] ; then
				bl_all_zen_sauce=1
			fi
		done
		for c in "${ZEN_SAUCE_WHITELIST}" ; do
			if [[ \
				   "${c}" == "*" \
				|| "${c}" == "all" \
				|| "${c}" == "zen-tune" \
			]] ; then
				wl_all_zen_tune=1
			fi
			if [[ \
				   "${c}" == "*" \
				|| "${c}" == "all" \
				|| "${c}" == "zen-sauce" \
			]] ; then
				wl_all_zen_sauce=1
			fi
		done

		if ot-kernel_use zen-sauce && (( ${bl_all_zen_tune} == 1 )) ; then
			for c in "${PATCH_ZEN_TUNE_COMMITS[@]}" ; do
				blacklisted+=" ${c:0:7}"
			done
		fi
		if ot-kernel_use zen-sauce && (( ${bl_all_zen_sauce} == 1 )) ; then
			for c in "${PATCH_ZEN_SAUCE_COMMITS[@]}" ; do
				blacklisted+=" ${c:0:7}"
			done
		fi
		if ot-kernel_use zen-sauce && (( ${wl_all_zen_tune} == 1 )) ; then
			for c in "${PATCH_ZEN_TUNE_COMMITS[@]}" ; do
				whitelisted+=" ${c:0:7}"
			done
		fi
		if ot-kernel_use zen-sauce && (( ${wl_all_zen_sauce} == 1 )) ; then
			for c in "${PATCH_ZEN_SAUCE_COMMITS[@]}" ; do
				whitelisted+=" ${c:0:7}"
			done
		fi
	fi

	local use_blacklisted+=" ${PATCH_ZEN_SAUCE_BL[@]}"

	whitelisted=$(echo "${whitelisted}" \
		| tr " " "\n" \
		| sort \
		| uniq \
		| tr "\n" " ")
	blacklisted=$(echo "${blacklisted}" \
		| tr " " "\n" \
		| sort \
		| uniq \
		| tr "\n" " ")
	use_blacklisted=$(echo "${use_blacklisted}" \
		| tr " " "\n" \
		| sort \
		| uniq \
		| tr "\n" " ")

einfo "Applying zen-sauce patches"
	local has_use_flag_patch=0
	for c in ${PATCH_ZEN_SAUCE_COMMITS[@]} ; do
		local subject=$(grep -e "^Subject:" "${EDISTDIR}/zen-sauce-${ZEN_KV}-${c:0:7}.patch" \
			| head -n 1 \
			| sed -e "s|^Subject: ||")
		local is_whitelisted=0
		local c_wl
		for c_wl in ${whitelisted[@]} ; do
			if [[ "${c:0:7}" == "${c_wl:0:7}" ]] ; then
				is_whitelisted=1
				break
			fi
		done
		(( ${is_whitelisted} == 0 )) && continue

		local is_blacklisted=0
		if [[ -n "${#use_blacklisted}" ]] ; then
			local c_bl
			for c_bl in ${use_blacklisted} ; do
				if [[ "${c:0:7}" == "${c_bl:0:7}" ]] ; then
ewarn "Skipping zen-sauce ${c} -- ${subject} -- Use the USE flag instead."
					has_use_flag_patch=1
					is_blacklisted=1
					break
				fi
			done
		fi
		(( ${is_blacklisted} == 1 )) && continue

		local is_blacklisted=0
		if [[ -n "${#blacklisted}" ]] ; then
			local c_bl
			for c_bl in ${blacklisted} ; do
				if [[ "${c:0:7}" == "${c_bl:0:7}" ]] ; then
ewarn "Skipping zen-sauce ${c} -- ${subject}"
					is_blacklisted=1
					break
				fi
			done
		fi
		(( ${is_blacklisted} == 1 )) && continue

		_fpatch "${EDISTDIR}/zen-sauce-${ZEN_KV}-${c:0:7}.patch" "-- ${subject}"
	done
	if (( ${has_use_flag_patch} == 1 )) ; then
ewarn
ewarn "Rows marked \"USE flag\" should be applied with both the USE flag"
ewarn "and OT_KERNEL_USE instead.  Please remove these IDs from the"
ewarn "ZEN_SAUCE_WHITELIST.  This is to ensure the BDEPENDS/RDEPENDS/DEPENDs"
ewarn "are met."
ewarn
	fi
}

# @FUNCTION: apply_cfi
# @DESCRIPTION:
# Adds cfi protection for the x86-64 platform
apply_cfi() {
	local c
	for c in ${CFI_COMMITS[@]} ; do
		_fpatch "${EDISTDIR}/cfi-${CFI_KV}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_custom_logo
# @DESCRIPTION:
# Adds custom logo patch
apply_custom_logo() {
	if [[ -n "${OT_KERNEL_LOGO_URI}" ]] ; then
		if ver_test ${KV_MAJOR_MINOR} -ge 5.2 ; then
			_fpatch "${FILESDIR}/custom-logo-for-6.1.patch"
		elif ver_test ${KV_MAJOR_MINOR} -ge 4.19 ; then
			_fpatch "${FILESDIR}/custom-logo-for-4.19.patch"
		else
			_fpatch "${FILESDIR}/custom-logo-for-4.14.patch"
		fi
	fi
}

# @FUNCTION: apply_kcfi
# @DESCRIPTION:
# Adds kcfi protection for the x86-64 platform
apply_kcfi() {
	local c
	for c in ${KCFI_COMMITS[@]} ; do
		_fpatch "${EDISTDIR}/kcfi-${KCFI_KV}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_bbrv2
# @DESCRIPTION:
# Adds BBRv2 to have ~ 1% retransmits in comparison to BBRv1 at ~ 5%
# the expense of some bandwidth (~ 10 mbps) relative to BBR but significantlly
# better than CUBIC.  BBRv1 will will still maintain ~ 38% throughput after
# some packet loss 3% but CUBIC will have < 1% thoughput when there is a
# few percent of packet loss.
apply_bbrv2() {
	local c
	for c in ${BBRV2_COMMITS[@]} ; do
		_fpatch "${EDISTDIR}/bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-${c:0:7}.patch"
		rm config.gce 2>/dev/null # It was included in the bbrv2 patch.
	done
}

# @FUNCTION: apply_bbrv3
# @DESCRIPTION:
# Adds BBRv3 to have 12% reduction in retransmission, 0.2% lower latency, +/- 1%
# throughput with all figures relative to BBRv1.
apply_bbrv3() {
	local c
	for c in ${BBRV3_COMMITS[@]} ; do
		_fpatch "${EDISTDIR}/bbrv3-${BBRV3_VERSION}-${BBRV3_KV}-${c:0:7}.patch"
		rm config.gce 2>/dev/null # It was included in the bbrv2 patch.
	done
}

# @FUNCTION: apply_multigen_lru
# @DESCRIPTION:
# Uses multigenerational LRU to improve page reclamation.
apply_multigen_lru() {
	_fpatch "${EDISTDIR}/${MULTIGEN_LRU_FN}"
}

# @FUNCTION: apply_zen_multigen_lru
# @DESCRIPTION:
# Uses zen's modified multigenerational LRU to improve page reclamation.
apply_zen_multigen_lru() {
	_fpatch "${EDISTDIR}/${ZEN_MULTIGEN_LRU_FN}"
}

# @FUNCTION: ot-kernel_get_kcp_provider
# @DESCRIPTION:
# Gets the kernel_compiler_patch_provider.
ot-kernel_get_kcp_provider() {
	local kcp_provider
	if [[ "${PV}" =~ "9999" ]] ; then
		kcp_provider="${OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER:-zen-sauce}"
	else
		kcp_provider="${OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER:-graysky2}"
	fi
}

# @FUNCTION: _filter_genpatches
# @DESCRIPTION:
# Applies a genpatch if not blacklisted.
#
# Define GENPATCHES_BLACKLIST as a space seperated string in make.conf or
# as a per-package env
#
# For example,
# GENPATCHES_BLACKLIST="2500 2600"
_filter_genpatches() {
	P_GENPATCHES_BLACKLIST=""
	if ! ot-kernel_use genpatches_1510 ; then
	# Possibly locks up computer during OOM tests
		P_GENPATCHES_BLACKLIST+=" 1510"
	fi
	# Already applied since 5.13.14
	P_GENPATCHES_BLACKLIST+=" 2700"
	local kcp_provider=$(ot-kernel_get_kcp_provider)
	if ! [[ "${kcp_provider}" =~ "genpatches" ]] ; then
	# Already applied 5010-5013 GraySky2's kernel_compiler_patches
		P_GENPATCHES_BLACKLIST+=" 5010 5011 5012 5013"
	fi

	if ( has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo ) && ! [[ "${GENPATCHES_BLACKLIST}" =~ "1500" ]] ; then
ewarn
ewarn "Clang PGO is not compatible with Genpatches 1500 and cause boot failure."
ewarn "Disable clang pgo in OT_KERNEL_USE or add 1500 to GENPATCHES_BLACKLIST"
ewarn
ewarn "Adding 1500 GENPATCHES_BLACKLIST is not recommended for secure"
ewarn "configurations."
ewarn
		die
	fi

	if [[ "${KV_MAJOR_MINOR}" == "4.19" ]] ; then
	# Patch failures
		P_GENPATCHES_BLACKLIST+=" 2600"
	elif [[ "${KV_MAJOR_MINOR}" == "5.4" ]] ; then
	# Patch failures
		P_GENPATCHES_BLACKLIST+=" 2600"
	fi
	# Already applied 5000-5007 ZSTD patches
	P_GENPATCHES_BLACKLIST+=" 5000 5001 5002 5003 5004 5005 5006 5007"
	# Already applied bmq.
	P_GENPATCHES_BLACKLIST+=" 5020 5021"
	# Already applied the pelt.h patch conditionally.
	P_GENPATCHES_BLACKLIST+=" 5022"
	if declare -f ot-kernel_filter_genpatches_blacklist_cb > /dev/null ; then
	# Disable failing patches
		P_GENPATCHES_BLACKLIST+=$(ot-kernel_filter_genpatches_blacklist_cb)
	fi

	if [[ "${KV_MAJOR_MINOR}" == "6.6" && "${PV}" =~ "9999" ]] ; then
		P_GENPATCHES_BLACKLIST+=" 1500" # fail to patch
	fi

	pushd "${d}" >/dev/null 2>&1 || die
		local f
		for f in $(ls -1) ; do
#einfo "Processing ${f}"
			if [[ "${f}" =~ \.patch$ ]] ; then
				local l=$(echo "${f}" | cut -f 1 -d"_")
				if (( ${l} < 1500 )) ; then
					# vanilla kernel inc patches
					# already applied
					continue
				fi
				local is_blacklisted
				is_blacklisted=0
				local x
				for x in ${P_GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklisted=1
						break
					fi
				done
				if [[ "${is_blacklisted}" == "1" ]] ; then
ewarn "Skipping genpatches ${f}"
					continue
				fi

				is_blacklisted=0
				for x in ${GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklisted=1
						break
					fi
				done
				if [[ "${is_blacklisted}" == "1" ]] ; then
ewarn "Skipping genpatches ${f}"
					continue
				fi

				pushd "${BUILD_DIR}" >/dev/null 2>&1 || die
					_fpatch "${d}/${f}"
				popd >/dev/null 2>&1 || die
			fi
		done
	popd >/dev/null 2>&1 || die
}

# @FUNCTION: apply_bmq
# @DESCRIPTION:
# Apply the BMQ CPU scheduler patchset.
apply_bmq() {
	cd "${BUILD_DIR}" || die
einfo "Applying bmq"
	_fpatch "${EDISTDIR}/${BMQ_FN}"
}

# @FUNCTION: apply_ck
# @DESCRIPTION:
# applies the ck patchset
apply_ck() {
	local c
	for c in ${CK_COMMITS[@]} ; do
		local blacklisted=0
		local b
		for b in ${CK_COMMITS_BL[@]} ; do
			if [[ "${c}" == "${b}" ]] ; then
				blacklisted=1
				break
			fi
			if ver_test ${KV_MAJOR_MINOR} -eq 4.14 ; then
				if ! ot-kernel_use bfq-mq ; then
					local b2
					for b2 in ${CK_BFQ_MQ[@]} ; do
						if [[ "${c}" == "${b2}" ]] ; then
							blacklisted=1
							break
						fi
					done
				fi
			fi
			(( ${blacklisted} == 1 )) && break
		done
		(( ${blacklisted} == 1 )) && continue
		_fpatch "${EDISTDIR}/ck-${MUQSS_VER}-${CK_KV}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_genpatches
# @DESCRIPTION:
# Apply the base genpatches patchset.
apply_genpatches() {
	local d
	if [[ "${PV}" =~ "9999" ]] ; then
einfo "Using genpatches from repo"
		EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/linux-patches.git"
		if use fallback-commit && [[ -n "GENPATCHES_FALLBACK_COMMIT" ]] ; then
			EGIT_COMMIT="${GENPATCHES_FALLBACK_COMMIT}"
			EGIT_CHECKOUT_DIR="${T}/linux-patches-${KV_MAJOR_MINOR}-${EGIT_COMMIT:0:7}"
		else
			EGIT_CHECKOUT_DIR="${T}/linux-patches-${KV_MAJOR_MINOR}-head"
		fi
		EGIT_BRANCH="$(ver_cut 1-2 ${MY_PV})"

		git-r3_fetch
		git-r3_checkout
		d="${EGIT_CHECKOUT_DIR}"
		[[ "${d}/0000_README" ]] || die
	else
einfo "Using genpatches from tarball"
		local dn="${GENPATCHES_FN%.tar.bz2}"
		local d="${T}/${dn}"
		if [[ ! -d "${d}" ]] ; then
			mkdir -p "${d}" || die
			cd "${d}" || die
			unpack "${GENPATCHES_FN}"
		fi
		d="${T}/${dn}/${dn}"
	fi
einfo "Applying the genpatches"
	cd "${BUILD_DIR}" || die
	_filter_genpatches
}

# @FUNCTION: apply_o3
# @DESCRIPTION:
# Apply the O3 patchset.
#
# ot-kernel_apply_o3_fixes - callback for fix to O3 patches
#
apply_o3() {
	cd "${BUILD_DIR}" || die
	if ver_test "${KV_MAJOR_MINOR}" -eq 4.14 ; then
		# fix patch
		sed -e 's|-1028,6 +1028,13|-1076,6 +1076,13|' \
			"${EDISTDIR}/${O3_CO_FN}" \
			> "${T}/${O3_CO_FN}" || die

einfo "Applying O3"
einfo "Applying ${O3_CO_FN}"
		_fpatch "${T}/${O3_CO_FN}"

einfo "Applying ${O3_RO_FN}"
		mkdir -p drivers/gpu/drm/amd/display/dc/basics/
		# trick patch for unattended patching
		touch drivers/gpu/drm/amd/display/dc/basics/logger.c
		_fpatch "${EDISTDIR}/${O3_RO_FN}"
	fi
}

# @FUNCTION: apply_pds
# @DESCRIPTION:
# Apply the PDS CPU scheduler patchset.
apply_pds() {
	cd "${BUILD_DIR}" || die
einfo "Applying PDS"
	_fpatch "${EDISTDIR}/${PDS_FN}"
}

# @FUNCTION: apply_prjc
# @DESCRIPTION:
# Apply the Project C CPU scheduler patchset.
apply_prjc() {
	cd "${BUILD_DIR}" || die
einfo "Applying Project C"
	_fpatch "${EDISTDIR}/${PRJC_FN}"
}

# @FUNCTION: apply_tresor
# @DESCRIPTION:
# Apply the TRESOR AES cold boot resistant patchset.
#
# ot-kernel_apply_tresor_fixes - callback to apply tresor fixes
#
apply_tresor() {
	[[ "${arch}" == "x86_64" || "${arch}" == "x86" ]] || return
	cd "${BUILD_DIR}" || die
	local platform

	if [[ "${TRESOR_TARGET_OVERRIDE}" == "x86_64_aesni_256" ]] ; then
		# For development
einfo "Applying TRESOR for x86_64 with AES-NI"
		platform="aesni"
	elif [[ "${TRESOR_TARGET_OVERRIDE}" == "x86_64_generic_256" ]] ; then
		# For development
einfo "Applying TRESOR for x86_64"
		platform="i686"
	elif [[ "${TRESOR_TARGET_OVERRIDE}" == "x86_64_generic_128" ]] ; then
		# For development
einfo "Applying TRESOR for x86_64"
		platform="i686"
	elif [[ "${TRESOR_TARGET_OVERRIDE}" == "x86_generic_128" ]] ; then
		# For development
einfo "Applying TRESOR for x86"
		platform="i686"
	elif [[ "${arch}" == "x86_64" ]] && ot-kernel_use cpu_flags_x86_aes ; then
einfo "Applying TRESOR for x86_64 with AES-NI"
		platform="aesni"
	elif [[ "${arch}" == "x86_64" ]] ; then
einfo "Applying TRESOR for x86_64"
		platform="i686"
	elif [[ "${arch}" == "x86" ]] ; then
einfo "Applying TRESOR for x86"
		platform="i686"
	fi

	_fpatch "${EDISTDIR}/tresor-patch-${PATCH_TRESOR_VER}_${platform}"
	sed -i -E -e "s|[ ]?-tresor[0-9.]+||g" "${BUILD_DIR}/Makefile" || die
}

# @FUNCTION: apply_uksm
# @DESCRIPTION:
# Apply the UKSM patches.
#
# ot-kernel_uksm_fixes - callback to fix the patch
#
apply_uksm() {
	_fpatch "${EDISTDIR}/${UKSM_FN}"
}

# @FUNCTION: apply_vanilla_point_releases
# @DESCRIPTION:
# Applies all the point releases
apply_vanilla_point_releases() {
	[[ -n "${KERNEL_NO_POINT_RELEASE}" \
		&& "${KERNEL_NO_POINT_RELEASE}" == "1" ]] && return

einfo "Applying vanilla point releases"
	# genpatches places kernel incremental patches starting at 1000
	local a
	for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
		local f="${T}/${a}"
		cd "${T}" || die
		unpack "$a.xz"
		cd "${BUILD_DIR}" || die

		local output=$(patch --dry-run ${PATCH_OPTS} -N -i "${f}")
		echo "${output}" | grep -F -e "FAILED at"
		if [[ "$?" == "1" ]]; then
			# Already patched or good
			_fpatch "${f}"
		else
eerror
eerror "Failed ${a}"
eerror
eerror "Patch details:"
eerror
echo -e "${output}"
eerror
			die
		fi
	done
}

# @FUNCTION: apply_zen_muqss
# @DESCRIPTION:
# Apply a fork of MuQSS maintained by the zen-kernel team.
apply_zen_muqss() {
einfo "Applying some of the zen-kernel MuQSS patches"
	local x
	for x in ${ZEN_MUQSS_COMMITS[@]} ; do
		local id="${x:0:7}"
		is_zen_muquss_excluded "${x}" && continue
		_fpatch "${EDISTDIR}/zen-muqss-${ZEN_KV}-${id}.patch"
	done
}

# @FUNCTION: apply_clang_pgo
# @DESCRIPTION:
# Apply the PGO patch for use with clang
apply_clang_pgo() {
einfo "Applying the Clang PGO patch"
	_fpatch "${FILESDIR}/${CLANG_PGO_FN}"
}

# @FUNCTION: apply_c2tcp_v2
# @DESCRIPTION:
# Apply the C2TCP / DeepCC / Orca patch
apply_c2tcp_v2() {
einfo "Applying the C2TCP / DeepCC / Orca patch"
	_fpatch "${EDISTDIR}/${C2TCP_FN}"
}

# @FUNCTION: ot-kernel_compiler_not_found
# @DESCRIPTION:
# Show compiler is not found message
ot-kernel_compiler_not_found() {
	local msg="${1}"
eerror
eerror "These are the required slot ranges.  Either choose..."
eerror
eerror "GCC_MIN_SLOT: ${GCC_COMPAT[-1]}"
eerror "GCC_MAX_SLOT: ${GCC_COMPAT[0]}"
eerror
eerror "  or"
eerror
eerror "LLVM_MIN_SLOT: ${LLVM_COMPAT[-1]}"
eerror "LLVM_MAX_SLOT: ${LLVM_COMPAT[0]}"
eerror
eerror "You should re-emerge the one of the allowed compiler slots."
eerror
eerror "Reason:  ${msg}"
eerror
			die
}

# @FUNCTION: verify_point_release
# @DESCRIPTION:
# Checks if the final point release was applied.
# If not it will break genkernel.
verify_point_release() {
	local c0=$(grep "^VERSION = " "${BUILD_DIR}/Makefile" | cut -f 2 -d "=" | sed -e "s| ||g")
	local c1=$(grep "^PATCHLEVEL = " "${BUILD_DIR}/Makefile" | cut -f 2 -d "=" | sed -e "s| ||g")
	local c2=$(grep "^SUBLEVEL = " "${BUILD_DIR}/Makefile" | cut -f 2 -d "=" | sed -e "s| ||g")
	local actual_pv="${c0}.${c1}.${c2}"
	local expected_pv=$(ver_cut 1-3 "${MY_PV}")

	local nparts=$(echo "${expected_pv}" | tr "." "\n" | wc -l)
	(( ${nparts} == 2 )) && return # Not a point release

	if [[ "${expected_pv}" != "${actual_pv}" ]] ; then
eerror
eerror "Applying point release patches failed."
eerror
eerror "Actual PV:  ${actual_pv}"
eerror "Expected PV:  ${expected_pv}"
eerror
		if [[ "${PV}" == "9999" ]] ; then
eerror
eerror "Bump the live major and minor versions to ${c0}.${c1}."
eerror
		fi
		die
	fi
	if [[ "${PV}" == "9999" ]] ; then
		local rc_pv=""
		if [[ -n "${RC_PV}" ]] ; then
			rc_pr="-${RC_PV}"
		fi
		if ! grep -q -o -e "EXTRAVERSION = ${rc_pv}" "Makefile" ; then
			local actual_suffix=$(grep -e "EXTRAVERSION =" \
				| cut -f 2 -d "=" \
				| sed -e "s| -||g")
eerror
eerror "The suffix does not match."
eerror
eerror "Expected:  ${RC_PV}"
eerror "Actual:    ${actual_suffix}"
eerror
eerror "QA:  Update RC_PV in ot-kernel-v${KV_MAJOR_MINOR}.eclass."
eerror
			die
		fi
	fi
}

# @FUNCTION: ot-kernel_apply_kcp
# @DESCRIPTION:
# Applies graysky's kernel_compiler_patch
ot-kernel_apply_kcp() {
	local patches=()

	local wants_kcp=0
	local wants_kcp_rpi=0

	if [[ "${CFLAGS}" =~ ("-march") ]] ; then
		wants_kcp=1
	fi
	if [[ -n "${X86_MICROARCH_OVERRIDE}" ]] ; then
		wants_kcp=1
	fi
	if [[ "${CFLAGS}" =~ "-mcpu=cortex-a72" ]] ; then
		wants_kcp_rpi=1
	fi

	local kcp_provider=$(ot-kernel_get_kcp_provider)
	if ! [[ "${kcp_provider}" =~ "graysky2" ]] ; then
		wants_kcp=0
		wants_kcp_rpi=0
	fi

	# Verify Toolchain (TC) requirement for kernel_compiler_patch (KCP)
	# because of multislot TC.
	if (( ${wants_kcp} == 1 || ${wants_kcp_rpi} == 1 )) ; then
		local llvm_slot=$(get_llvm_slot)
		local gcc_slot=$(get_gcc_slot)
		local gcc_pv=$(best_version "${GCC_PKG}:$(ver_cut 1 ${gcc_slot})" | sed -r -e "s|${GCC_PKG}-||" -e "s|-r[0-9]+||")
		local clang_pv=$(best_version "sys-devel/clang:${llvm_slot}" | sed -r -e "s|sys-devel/clang-||" -e "s|-r[0-9]+||")
		#local vendor_id=$(cat /proc/cpuinfo | grep vendor_id | head -n 1 | cut -f 2 -d ":" | sed -E -e "s|[ ]+||g")
		#local cpu_family=$(printf "%02x" $(cat /proc/cpuinfo | grep -F -e "cpu family" | head -n 1 | grep -E -o "[0-9]+"))
		#local cpu_model=$(printf "%02x" $(cat /proc/cpuinfo | grep -F -e "model" | head -n 1 | grep -E -o "[0-9]+"))
einfo
einfo "llvm_slot:\t${llvm_slot}"
einfo "gcc_slot:\t${gcc_slot}"
einfo "Best GCC version:  ${gcc_pv}"
einfo "Best Clang version:  ${clang_pv}"
einfo
		if [[ -z "${gcc_pv}" && -z "${clang_pv}" ]] ; then
			ot-kernel_compiler_not_found "Empty compiler versions found for both gcc and clang"
		fi
	fi

	tc-is-clang && LLVM_SLOT="${clang_pv%%.*}"

	# KCP is applied globally
	if (( ${wants_kcp} == 1 )) ; then
		if (  (				 $(ver_test ${gcc_pv}   -ge 9.1) ) \
		   || ( [[ -n "${clang_pv}" ]] && $(ver_test ${clang_pv} -ge 10.0) ) \
		   ) \
			&& test -f "${EDISTDIR}/${KCP_9_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 9.1 or clang >= 10.0."
			patches+=( "${EDISTDIR}/${KCP_9_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch")
			export GCC_COMPAT_KPC=( $(seq ${gcc_pv%%.*} -1 9 ) )
			export LLVM_COMPAT_KPC=( $(seq ${clang_pv%%.*} -1 9 ) )
		elif ( tc-is-gcc && $(ver_test ${gcc_pv} -ge 8.1) ) \
			&& test -f "${EDISTDIR}/${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 8.1"
			patches+=( "${EDISTDIR}/${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
			export GCC_COMPAT_KPC=( $(seq ${gcc_pv%%.*} -1 8 ) )
			export LLVM_COMPAT_KPC=( $(seq ${clang_pv%%.*} -1 9 ) ) # Undefined for this release
		elif ( tc-is-gcc && $(ver_test ${gcc_pv} -ge 4.9) ) \
			&& test -f "${EDISTDIR}/${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 4.9"
			patches+=( "${EDISTDIR}/${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
			export GCC_COMPAT_KPC=( $(seq ${gcc_pv%%.*} -1 4 ) )
			export LLVM_COMPAT_KPC=( $(seq ${clang_pv%%.*} -1 9 ) ) # Undefined for this release
		else
ewarn
ewarn "Cannot find a compatible kernel_compiler_patch for gcc_pv = ${gcc_pv}"
ewarn "and kernel ${KV_MAJOR_MINOR}.  Skipping the kernel_compiler_patch."
ewarn
		fi
	else
		export GCC_COMPAT_KPC=( )
		export LLVM_COMPAT_KPC=( )
	fi

	# KCP-RPI is applied globally
	if (( ${wants_kcp_rpi} == 1 )) ; then
einfo "Queuing the kernel_compiler_patch for the Cortex A72"
		patches+=( "${EDISTDIR}/${KCP_CORTEX_A72_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
	fi

#	if ver_test "${KV_MAJOR_MINOR}" -eq 5.15 ; then
#		eapply "${FILESDIR}/external-modules-linking-changes-for-5.15.138.patch"
#	elif ver_test "${KV_MAJOR_MINOR}" -eq 5.10 ; then
#		eapply "${FILESDIR}/external-modules-linking-changes-for-5.4.260.patch"
#	elif ver_test "${KV_MAJOR_MINOR}" -eq 5.4 ; then
#		eapply "${FILESDIR}/external-modules-linking-changes-for-5.4.260.patch"
#	fi

	if (( ${#patches[@]} > 0 )) ; then
		eapply ${patches[@]}
	fi
}


# @FUNCTION: ot-kernel_src_unpack
# @DESCRIPTION:
# Applies patch sets in order.
ot-kernel_src_unpack() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	export BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${K_EXTRAVERSION}"
	if [[ "${PV}" =~ "9999" ]] ; then
		ot-kernel_unpack_live
	else
		ot-kernel_unpack_tarball
		mv "linux-${KV_MAJOR_MINOR}" "${BUILD_DIR}" || die
		apply_vanilla_point_releases
	fi
einfo "Done unpacking."
	verify_point_release
}

# @FUNCTION: apply_gcc_full_pgo
# @DESCRIPTION:
# Applies a patchset for Full PGO with GCC.
apply_gcc_full_pgo() {
eerror
eerror "GCC full pgo is on hold indefinitely.  See metadata.xml"
eerror "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)."
eerror
eerror "Change OT_KERNEL_PGO_FLAVOR to either GCC_PGO_CFG, GCC_PDO, or"
eerror "CLANG_PGO or disable the pgo USE flag."
eerror
	die
einfo "Applying patchset for Full PGO with GCC"
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.4" ; then
		eapply "${FILESDIR}/gcc-pgo-6.5.7.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		eapply "${FILESDIR}/gcc-pgo-6.5.7.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.10" ; then
		eapply "${FILESDIR}/gcc-pgo-6.5.7.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
		eapply "${FILESDIR}/gcc-pgo-5.4.258.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.19" ; then
		eapply "${FILESDIR}/gcc-pgo-4.19.296.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		eapply "${FILESDIR}/gcc-pgo-4.14.327.patch"
	fi
}

# @FUNCTION: apply_clear_linux_patches
# @DESCRIPTION:
# Applies Clear Linux patches
apply_clear_linux_patches() {
einfo "Applying Clear Linux patches"
	if ver_test ${PV} -eq ${CLEAR_LINUX_PATCHES_VER%-*} ; then
		mkdir -p "${T}/clear-linux-patches"
		pushd "${T}/clear-linux-patches" >/dev/null 2>&1 || die
			unpack "${CLEAR_LINUX_PATCHES_FN}"
		popd >/dev/null 2>&1 || die
		local P=(
			$(grep -E -e "^Patch[0-9]+:" "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/linux.spec" \
				| cut -f 2 -d ":" \
				| sed -E -e "s|^[ ]+||g")
		)
		local p
		local blacklisted="${OT_KERNEL_CLEAR_LINUX_PATCHSET_BLACKLIST}"
		if ! [[ "${cpu_sched}" =~ "cfs" ]] ; then
			blacklisted+=" 0001-mm-memcontrol-add-some-branch-hints-based-on-gcov-an.patch"
		fi
		local upstream_blacklisted=$(grep -E -e "#%?patch[0-9]+" "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/linux.spec" \
			| cut -f 1 -d " " \
			| sed -r -e "s|#%?patch||g")
		for p in ${P[@]} ; do
			local is_blacklisted=0
			local bl
			for bl in ${upstream_blacklisted} ; do
				local fn=$(grep -E -e "^Patch${bl}" "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/linux.spec" \
					| cut -f 2 -d " ")
				if [[ "${p}" == "${fn}" ]] ; then
					is_blacklisted=1
					break
				fi
			done

			for bl in ${blacklisted} ; do
				if [[ "${p}" == "${bl}" ]] ; then
					is_blacklisted=1
					break
				fi
			done
			if ! [[ "${cpu_sched}" =~ "cfs" ]] ; then
				if grep -q -F -e "kernel/sched" "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/${p}" ; then
ewarn "Skipping ${p} which makes reference to kernel/sched implying CFS.  ${cpu_sched} != cfs"
					is_blacklisted=1
				fi
			fi
			if (( ${is_blacklisted} == 1 )) ; then
ewarn "${p} is blacklisted.  Skipping..."
				continue
			fi
			_fpatch "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/${p}"
		done

		# Apply extra patches after official
		local P=(
			"${OT_KERNEL_CLEAR_LINUX_PATCHSET_EXTRA}"
		)
		for p in ${P[@]} ; do
			local subject=$(grep -e "^Subject:" "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/${p}" \
				| head -n 1 \
				| sed -e "s|^Subject: ||")
			local bl=""
			for bl in ${blacklisted} ; do
				if [[ "${p}" == "${bl}" ]] ; then
ewarn "Skipping clear linux patchset ${p} -- ${subject}"
					continue
				fi
			done
			_fpatch "${T}/clear-linux-patches/linux-${CLEAR_LINUX_PATCHES_VER}/${p}" "-- ${subject}"
		done

		if [[ "${CFLAGS}" =~ "-march=westmere" ]] ; then
einfo "Keeping -march=westmere from Clear Linux patch."
		else
ewarn "Removing -march=westmere from Clear Linux patch.  Set CFLAGS with -march=westmere to keep it."
			sed -i -e "s|-march=westmere||g" "arch/x86/Makefile" || die
		fi

		if [[ "${CFLAGS}" =~ "-O3" ]] ; then
einfo "Keeping -O3 from Clear Linux patch."
		else
ewarn "Removing -O3 from Clear Linux patch.  Set CFLAGS with -O3 to keep it."
			sed -i -e "s|-O3||g" "arch/x86/Makefile" || die
		fi
	else
ewarn
ewarn "The Clear Linux patches version mismatch.  Skipping."
ewarn
ewarn "Actual version:  ${PV}"
ewarn "Expected version:  ${CLEAR_LINUX_PATCHES_VER%-*}"
ewarn
ewarn "The patchset estimated bump is 2-7 days after the point release."
ewarn
	fi
}

# @FUNCTION: apply_nest
# @DESCRIPTION:
# Apply the Nest scheduler.
apply_nest() {
einfo "Applying the Nest scheduler patch"
	if [[ "${NEST_SPINNING:-1}" == "0" ]] ; then
		_fpatch "${DISTDIR}/${NEST_FN_ALT}"
	else
		_fpatch "${DISTDIR}/${NEST_FN}"
	fi
}

# @FUNCTION: apply_all_patchsets
# @DESCRIPTION:
# Apply the patches conditionally based on extraversion or cpu_sched
apply_all_patchsets() {
	if has clear ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use clear ; then
			apply_clear_linux_patches
		fi
	fi

	if has pgo ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use pgo && [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" ]] ; then
			apply_gcc_full_pgo
		fi
	fi

	if has rt ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use rt ; then
			apply_rt
		fi
	fi

	if has uksm ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use uksm ; then
			apply_uksm
		fi
	fi

	if has multigen_lru ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use multigen_lru ; then
			apply_multigen_lru
		fi
	fi

	if has zen-multigen_lru ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use zen-multigen_lru ; then
			apply_zen_multigen_lru
		fi
	fi

	if has bmq ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use bmq && [[ "${cpu_sched}" == "bmq" ]] ; then
			apply_bmq
		fi
	fi

	if has pds ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use pds && [[ "${cpu_sched}" == "pds" ]] ; then
			apply_pds
		fi
	fi

	if has prjc ${IUSE_EFFECTIVE} ; then
		if \
		ot-kernel_use prjc \
		&& \
		[[ \
			   "${cpu_sched}" == "prjc" \
			|| "${cpu_sched}" == "prjc-bmq" \
			|| "${cpu_sched}" == "prjc-pds" \
		]] ; then
			apply_prjc
		fi
	fi

	if has muqss ${IUSE_EFFECTIVE} ; then
		if \
			ot-kernel_use muqss \
				&& \
			[[ \
				   "${cpu_sched}" == "muqss" \
				|| "${cpu_sched}" == "muqss-latency" \
				|| "${cpu_sched}" == "muqss-throughput" \
			]] \
		; then
			apply_ck
		fi
	fi

	if has zen-muqss ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use zen-muqss && [[ "${cpu_sched}" == "zen-muqss" ]] ; then
			apply_zen_muqss
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use tresor ; then
			apply_tresor
		fi
	fi

	if has genpatches ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use genpatches ; then
			apply_genpatches
		fi
	fi

	if [[ "${CFLAGS}" =~ "-O3" ]] ; then
		apply_o3
	fi

	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use zen-sauce ; then
			apply_zen_sauce
		fi
	fi

	if has bbrv2 ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use bbrv2 ; then
			apply_bbrv2
		fi
	fi

	if has bbrv3 ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use bbrv3 ; then
			apply_bbrv3
		fi
	fi

	if has clang ${USE} ; then
		if ot-kernel_use clang && ot-kernel_use pgo ; then
			apply_clang_pgo
		fi
	fi

	if has cfi ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use cfi && [[ "${arch}" == "x86_64" ]] ; then
			apply_cfi
		fi
	fi

	if has kcfi ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use kcfi && [[ "${arch}" == "x86_64" ]] ; then
			apply_kcfi
		fi
	fi

	if \
		   ( has c2tcp ${IUSE_EFFECTIVE}  && ot-kernel_use c2tcp ) \
		|| ( has deepcc ${IUSE_EFFECTIVE} && ot-kernel_use deepcc ) \
		|| ( has orca ${IUSE_EFFECTIVE}   && ot-kernel_use orca ) \
	; then
		if [[ "${C2TCP_MAJOR_VER}" == "2" ]] ; then
			apply_c2tcp_v2
		fi
	fi

	if has nest ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use nest && [[ "${cpu_sched}" == "nest" ]] ; then
			apply_nest
		fi
	fi

	apply_custom_logo

	ot-kernel_apply_kcp

	if [[ "${PV}" =~ "9999" ]] ; then
		# Disable + suffix
		sed -i -e "s|echo \"+\"|#echo \"+\"|g" "scripts/setlocalversion" || die

		# Disable -dirty
		sed -i -e "s|\${scm_version}||" "scripts/setlocalversion" || die
	fi
}

# @FUNCTION: ot-kernel_rm_exfat
# @DESCRIPTION:
# Deletes the exFAT filesystem from the source code.
ot-kernel_rm_exfat() {
einfo "Removing exFAT"
	sed -i -e "\|fs/exfat/Kconfig|d" \
		"fs/Kconfig" || die
	sed -i -e "/CONFIG_EXFAT_FS/d" \
		"fs/Makefile" || die
	sed -i -e "s|/EXFAT/|/|g" \
		"fs/Kconfig" || die
	rm -rf "fs/exfat" || die
	for path in $(find "arch" \
		-name "*_defconfig") ; do
		sed -i -e "/CONFIG_EXFAT_FS/d" \
			"${path}" || die
	done
}

# @FUNCTION: ot-kernel_rm_reiserfs
# @DESCRIPTION:
# Deletes references to both ReiserFS and Reiser4 filesystems from
# the source code.
ot-kernel_rm_reiserfs() {
einfo "Canceling ReiserFS"
	sed -i -e "\|fs/reiserfs/Kconfig|d" \
		"fs/Kconfig" || die
	sed -i -e "/CONFIG_REISERFS_FS/d" \
		"fs/Makefile" || die

	sed -i -e "/REISER/d" \
		"include/uapi/linux/magic.h" || die
	sed -i -e "/__reiserfs_panic/d" \
		"tools/objtool/check.c" || die
	sed -i -e "s|, reiserfs||g" \
		"fs/btrfs/tree-log.c" || die

	sed -i -e "s|and reiserfs||g" \
		"fs/quota/Kconfig" || die
	sed -i -e "s/|reiserfs//g" \
		"scripts/selinux/install_policy.sh" || die
	sed -i -e "/reiserfs/d" \
		"include/linux/stringhash.h" || die

	sed -i -e "/Reiserfs/d" \
		"scripts/ver_linux" || die

	if ver_test ${KV_MAJOR_MINOR} -ge 5.3 ; then
		sed -i -e "/reiserfs/d" \
			"Documentation/kbuild/makefiles.rst" || die
	else
		sed -i -e "/reiserfs/d" \
			"Documentation/kbuild/makefiles.txt" || die
	fi

	sed -i -r \
		-e "s|. We use \"r5\" hash borrowed from reiserfs||g" \
		-e "s| \(borrowed from reiserfs\)||g" \
		"fs/ubifs/key.h" || die

	if ver_test ${KV_MAJOR_MINOR} -ge 5.3 ; then
		sed -i \
			-e "s|/reiserfs||" \
			-e "s|or ReiserFS filesystems||" \
			-e "s|\"reiserfs\"||g" \
			"Documentation/admin-guide/laptops/laptop-mode.rst" \
			|| die
	else
		sed -i \
			-e "s|/reiserfs||" \
			-e "s|or ReiserFS filesystems||" \
			-e "s|\"reiserfs\"||g" \
			"Documentation/laptops/laptop-mode.txt" \
			|| die
	fi

	cat "Documentation/process/changes.rst" \
		| sed -e "/reiserfsprogs/d" \
		| sed -e "0,/^Reiserfsprogs/ s|^Reiserfsprogs|1Reiserfsprogs|" \
		| sed -e "0,/^Reiserfsprogs/ s|^Reiserfsprogs|2Reiserfsprogs|" \
		| sed -e "/1Reiserfsprogs/,/reiserfsck/d" -e "/2Reiserfsprogs/,/reiserfs/d" \
		> "Documentation/process/changes.rst.t" || die
	mv "Documentation/process/changes.rst"{.t,} || die
	if ver_test ${KV_MAJOR_MINOR} -ge 5.1 ; then
		cat "Documentation/translations/it_IT/process/changes.rst" \
			| sed -e "/reiserfsprogs/d" \
			| sed -e "0,/^Reiserfsprogs/ s|^Reiserfsprogs|1Reiserfsprogs|" \
			| sed -e "0,/^Reiserfsprogs/ s|^Reiserfsprogs|2Reiserfsprogs|" \
			| sed -e "/1Reiserfsprogs/,/reiserfsck/d" -e "/2Reiserfsprogs/,/reiserfs/d" \
			> "Documentation/translations/it_IT/process/changes.rst.t" || die
		mv "Documentation/translations/it_IT/process/changes.rst"{.t,} || die
	fi

	sed -i \
		-e "s|;.*reiserfs does this.*|;|" \
		"fs/buffer.c" || die
	sed -i \
		-e "s|blockdev.  Not true|blockdev.|" \
		-e "/reiserfs/d" \
		"fs/buffer.c" || die

	if ver_test ${KV_MAJOR_MINOR} -ge 4.17 ; then
		sed -i -e "s|reiserfs_||g" \
			"Documentation/trace/ftrace.rst" \
			|| die
	else
		sed -i -e "s|reiserfs_||g" \
			"Documentation/trace/ftrace.txt" \
			|| die
	fi

	if ver_test ${KV_MAJOR_MINOR} -ge 6.7 ; then
		sed -i -e "s|Reiserfs does not tolerate errors returned from the block device.||g" \
			"Documentation/arch/powerpc/eeh-pci-error-recovery.rst" \
			|| die
	elif ver_test ${KV_MAJOR_MINOR} -ge 6.0 && [[ "${PV}" =~ "9999" ]] ; then
		sed -i -e "s|Reiserfs does not tolerate errors returned from the block device.||g" \
			"Documentation/arch/powerpc/eeh-pci-error-recovery.rst" \
			|| die
	elif ver_test ${KV_MAJOR_MINOR} -ge 5.3 ; then
		sed -i -e "s|Reiserfs does not tolerate errors returned from the block device.||g" \
			"Documentation/powerpc/eeh-pci-error-recovery.rst" \
			|| die
	else
		sed -i -e "s|Reiserfs does not tolerate errors returned from the block device.||g" \
			"Documentation/powerpc/eeh-pci-error-recovery.txt" \
			|| die
	fi
	if ver_test ${KV_MAJOR_MINOR} -ge 4.20 ; then
		sed -i -e "s|, JFS, and ReiserFS| and JFS|g" \
			"Documentation/admin-guide/ext4.rst" \
			|| die
	elif ver_test ${KV_MAJOR_MINOR} -eq 4.19 ; then
		sed -i -e "s|, JFS, and ReiserFS| and JFS|g" \
			"Documentation/filesystems/ext4/ext4.rst" \
			|| die
	elif ver_test ${KV_MAJOR_MINOR} -le 4.18 ; then
		sed -i -e "s|, JFS, and ReiserFS| and JFS|g" \
			"Documentation/filesystems/ext4.txt" \
			|| die
	fi
	if ver_test ${KV_MAJOR_MINOR} -ge 5.5 ; then
		sed -i -e "s|linux/reiserfs_fs.h|Reserved|g" \
			"Documentation/userspace-api/ioctl/ioctl-number.rst" \
			|| die
	elif ver_test ${KV_MAJOR_MINOR} -ge 5.3 \
		&& ver_test ${KV_MAJOR_MINOR} -le 5.4 ; then
		sed -i -e "s|linux/reiserfs_fs.h|Reserved|g" \
			"Documentation/ioctl/ioctl-number.rst" \
			|| die
	else
		sed -i -e "s|linux/reiserfs_fs.h|Reserved|g" \
			"Documentation/ioctl/ioctl-number.txt" \
			|| die
	fi
	sed -i -e "/REISERFS/,/\/reiserfs/d" \
		"MAINTAINERS" || die
	sed -i -e "s|like reiserfs, ||g" \
		"drivers/block/Kconfig" || die
	sed -i -e "s|ifdef CONFIG_REISERFS_FS_SECURITY|if 0|g" \
		"scripts/selinux/mdp/mdp.c" || die
	sed -i -e "/reiserfs/d" \
		"scripts/selinux/mdp/mdp.c" || die
	rm -rf \
		"fs/reiserfs" \
		"include/uapi/linux/reiserfs_xattr.h" \
		"include/uapi/linux/reiserfs_fs.h" \
		|| die
		for path in $(find "arch" \
			-name "*_defconfig") ; do
			sed -i -e "/CONFIG_REISERFS_FS/d" \
				"${path}" || die
		done

einfo "Canceling Reiser4"
	sed -i -e "/Reiser4/d" \
		"scripts/ver_linux" || die
	sed -i -e "/The Reiser4/,/kernel\./d" \
		"Documentation/process/3.Early-stage.rst" || die
	if ver_test ${KV_MAJOR_MINOR} -ge 5.0 ; then
		sed -i -e "/Il filesystem Reiser4/,/kernel./d" \
			"Documentation/translations/it_IT/process/3.Early-stage.rst" || die
	fi
	if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
		sed -i -e "/Reiser4文/,/Reiser4置/d" \
			"Documentation/translations/zh_TW/process/3.Early-stage.rst" || die
	fi
	if ver_test ${KV_MAJOR_MINOR} -ge 5.2 ; then
		sed -i -e "/Reiser4文/,/Reiser4置/d" \
			"Documentation/translations/zh_CN/process/3.Early-stage.rst" || die
	fi
}

# @FUNCTION: ot-kernel_src_prepare
# @DESCRIPTION:
# Patch the kernel a bit
ot-kernel_src_prepare() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export BUILD_DIR_MASTER="${WORKDIR}/linux-${UPSTREAM_PV}-${K_EXTRAVERSION}"
	export BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${K_EXTRAVERSION}"

	cd "${BUILD_DIR}" || die

	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			cat "${EDISTDIR}/tresor_sysfs.c" > "tresor_sysfs.c"
		fi
	fi

	if use disable_debug ; then
		cat "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_PV}" \
			> "disable_debug" || die
	fi

	cat "${FILESDIR}/all-kernel-options-as-modules" \
		> "all-kernel-options-as-modules" || die
	cat "${FILESDIR}/all-kernel-options-as-yes" \
		> "all-kernel-options-as-yes" || die

	if use pgo ; then
		cat "${FILESDIR}/pgo-trainer.sh" \
			> "pgo-trainer.sh" || die
	fi

	cat "${FILESDIR}/ep800/ep800.c" \
		> "drivers/media/usb/gspca/ep800.c" || die
	cat "${FILESDIR}/ep800/ep800.h" \
		> "drivers/media/usb/gspca/ep800.h" || die

	# Patch for the nv driver.
	sed -i -e "s|select FB_CMDLINE|select FB_CMDLINE\n\tselect DRM_KMS_HELPER|" \
		"drivers/gpu/drm/Kconfig" || die

	if ver_test ${KV_MAJOR_MINOR} -ge 5.7 \
		&& [[ "${IUSE_EFFECTIVE}" =~ "exfat" ]] \
		&& ! use exfat ; then
		ot-kernel_rm_exfat
	fi

	if ! use reiserfs \
		&& [[ -e "fs/reiserfs" ]] ; then
		ot-kernel_rm_reiserfs
	fi

	eapply_user

	#if [[ -e "/lib/firmware/regulatory.db.p7s" ]] ; then
	#	cp -a "/lib/firmware/regulatory.db.p7s" "${BUILD_DIR}/"
	#fi

	if ver_test ${KV_MAJOR_MINOR} -ge 5.18 ; then
		eapply "${FILESDIR}/ep800/add-ep800-to-build-for-5.18.patch"
	else
		eapply "${FILESDIR}/ep800/add-ep800-to-build.patch"
	fi

	if ver_test "${KV_MAJOR_MINOR}" -ge "6.4" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-5.6.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-5.15.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.10" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-5.4.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-5.4.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.19" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-4.19.patch"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		eapply "${FILESDIR}/gcc-pgo-flags-4.14.patch"
	fi

	local moved=0

	mkdir -p "${WORKDIR}/pgodata" || die

	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		check_zen_tune_deps
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		local arch="${OT_KERNEL_ARCH}" # ARCH in raw form.

		if use pgo ; then
			if [[ -e "${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}" ]] ; then
				cp -a \
					"${OT_KERNEL_PGO_DATA_DIR}/${extraversion}-${arch}" \
					"${WORKDIR}/pgodata" || die
			fi
		fi

		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		if (( ${moved} == 0 )) ; then
einfo "Renaming for -${extraversion}"
			if [[ "${extraversion}" == "${K_EXTRAVERSION}" ]] ; then
				: # Avoid copy into self error
			else
				mv "${BUILD_DIR_MASTER}" "${BUILD_DIR}" || die
			fi
			mkdir -p "${S}" || die # Dummy dir for portage... Do not remove.
			export BUILD_DIR_MASTER="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
			moved=1
		else
einfo
einfo "Copying sources for -${extraversion}"
einfo "${BUILD_DIR_MASTER} -> ${BUILD_DIR}"
einfo
			cp -a "${BUILD_DIR_MASTER}" "${BUILD_DIR}" || die
		fi
	done

	(( ${moved} == 0 )) && die "You need to enable a profile"

	if [[ "${OT_KERNEL_SIGN_KERNEL}" =~ ("uefi"|"efi"|"kexec") ]] ; then
eerror
eerror "OT_KERNEL_SIGN_KERNEL=${OT_KERNEL_SIGN_KERNEL} is incomplete."
eerror "Fork or submit patch."
eerror
		die
	fi

	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		local arch="${OT_KERNEL_ARCH}" # ARCH in raw form.
		local cpu_sched="${OT_KERNEL_CPU_SCHED}"
		[[ -z "${cpu_sched}" ]] && cpu_sched="cfs"
		ot-kernel_use rt && cpu_sched="cfs"
		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		cd "${BUILD_DIR}" || die
einfo
einfo "Applying patchsets for -${extraversion}"
einfo
		apply_all_patchsets
		cd "${BUILD_DIR}" || die
einfo "Setting the extra version for the -${extraversion} build"
		if [[ "${PV}" =~ "9999" ]] ; then
			local rc_pv=""
			if [[ -n "${RC_PV}" ]] ; then
				rc_pv="-${RC_PV}"
			fi
			sed -i -e "s|EXTRAVERSION = ${rc_pv}\$|EXTRAVERSION = ${rc_pv}-${extraversion}|g" \
				"Makefile" || die
		else
			sed -i -e "s|EXTRAVERSION =\$|EXTRAVERSION = -${extraversion}|g" \
				"Makefile" || die
		fi
		if ot-kernel_use disable_debug ; then
			chmod +x "disable_debug" || die
		fi
		if [[ -n "${OT_KERNEL_PRIVATE_KEY}" ]] ; then
			[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing .pem private key"
			[[ -e "${OT_KERNEL_SHARED_KEY}" ]] || die "Missing .x509 shared key"
einfo "Copying private/shared signing keys"
			cp -a "${OT_KERNEL_PRIVATE_KEY}" "certs/signing_key.pem" \
				|| die "Cannot copy private key"
			cp -a "${OT_KERNEL_SHARED_KEY}" "certs/signing_key.x509" \
				|| die "Cannot copy shared key"
		fi
		if ot-kernel_is_full_sources_required ; then
			:
		elif [[ "${OT_KERNEL_PRUNE_EXTRA_ARCHES}" == "1" ]] \
			&& ! [[ "${OT_KERNEL_INSTALL_SOURCE_CODE:-1}" =~ ("1"|"y") ]] ; then
			# This is allowed if no external modules.

			# We can't prune earlier than multi arch patches.
			# Prune now for a faster source code install

			rm -rf "${T}/pruned"
			# Save Kconfig* for make olddefconfig.
			# Save arch/um/scripts/Makefile.rules for make mrproper.
			mkdir -p "${T}/pruned"
			cp --parents -a $(find arch \
				-name "Kconfig*") \
				"${T}/pruned" || die
			cp --parents -a arch/um/scripts/Makefile.rules \
				"${T}/pruned" || die

			ot-kernel_prune_arches

			# Restore Kconfig for make olddefconfig.
			# Restore arch/um/scripts/Makefile.rules for make mrproper.
			cp -aT "${T}/pruned" \
				"${BUILD_DIR}" || die
		fi
	done

	if [[ -n "${PEM_PATH}" ]] ; then
		register_die_hook ot-kernel_clear_keys
	fi
}

# @FUNCTION:  ot-kernel_clear_keys
# @DESCRIPTION:
# Wipe the keys upon build failure
ot-kernel_clear_keys() {
	# The private Key is stored in and reasons:
	# 1:  ${BUILD_DIR}/certs/signing_key.pem -- by either auto generated, or user supplied
	# 2:  ${T}/keys/${extraversion}-${arch}/certs/signing_key.pem -- temporary moved here before calling `make mrproper`
	# 3:  /usr/src/linux/certs/signing_key.pem -- stored by install for signing external modules but should be removed in within 24 hours.
	# 4:  Secured storage -- secured from malicious user or forensics

	# HOWEVER, it will not wipe all keys in a power outage.  One solution is storing
	# the private key first in a temporary secured storage, but it is in the clear
	# in unprotected unencrypted memory through the compilation process.  The
	# solution has not been implemented but may require Makefile changes to mitigate
	# plaintext private key extracted through forensics in blackout scenario.  This
	# is necessary if the key is a user supplied one.
	# TODO/FIXME:  Secure the private key on brownout

	local keys=()
	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		local p="${BUILD_DIR}/certs/signing_key.pem"
		if [[ -e "${p}" ]] ; then
ewarn "Securely wiping private keys for ${extraversion}"
			shred -f "${p}"
		fi
		local k="${T}/keys/${extraversion}-${arch}/certs/signing_key.pem"
		[[ -e "${k}" ]] && shred -f "${k}"
	done
	sync
}

# Constant enums
# For Profile Guided Optimization (PGO) or Profile Directed Optimization (PDO)
PGO_PHASE_UNK="UNK" # Unset
PGO_PHASE_PGI="PGI" # Instrumentation step
PGO_PHASE_PGT="PGT" # Training step
PGO_PHASE_PGO="PGO" # Optimization step
PGO_PHASE_PG0="PG0" # No PGO
PGO_PHASE_DONE="DONE" # DONE

# @FUNCTION: is_clang_ready
# @DESCRIPTION:
# Checks if the compiler has no problems
is_clang_ready() {
	which clang-${llvm_slot} >/dev/null 2>&1 || return 1
	local has_error=0
	if clang-${llvm_slot} --help | grep -q -F -e "symbol lookup error" ; then
ewarn "Found clang error"
		has_error=1
	fi
	if clang-${llvm_slot} --help | grep -q -F -e "undefined symbol:" ; then
ewarn "Found library error"
		has_error=1
	fi
	if CXX=clang-${llvm_slot} test-flags-CXX ${CXX_STD} >/dev/null 2>&1 ; then
		:
	else
ewarn "Found unsupported ${CXX_STD} with clang++-${llvm_slot}"
		has_error=1
	fi
	if (( ${has_error} == 1 )) ; then
ewarn
ewarn "Found missing symbols for clang and needs a rebuild for Clang +"
ewarn "LLVM ${llvm_slot}.  This has reduced security implications if using the"
ewarn "fallback gcc if relying on software security implementations."
ewarn
ewarn "You may skip this warning if a working Clang + LLVM was found."
ewarn
		return 1
	fi
	return 0
}

# @FUNCTION: is_gcc_ready
# @DESCRIPTION:
# Checks if the compiler has no problems
is_gcc_ready() {
einfo "Testing gcc slot ${gcc_slot}"
	which gcc-${gcc_slot} >/dev/null 2>&1 || return 1
	local has_error=0
	if gcc-${gcc_slot} --help | grep -q -F -e "symbol lookup error" ; then
ewarn "Found gcc error"
		has_error=1
	fi
	if gcc-${gcc_slot} --help | grep -q -F -e "undefined symbol:" ; then
ewarn "Found library error"
		has_error=1
	fi
	if CXX=g++-${gcc_slot} test-flags-CXX ${CXX_STD} >/dev/null 2>&1 ; then
		:
	else
ewarn "Found unsupported ${CXX_STD} with g++-${gcc_slot}"
		has_error=1
	fi
	if (( ${has_error} == 1 )) ; then
ewarn
ewarn "Found missing symbols in either in gcc or one of the libraries it is using."
ewarn "The library or gcc needs to be rebuild in order to properly continue."
ewarn
		return 1
	fi
	return 0
}

# @FUNCTION: is_firmware_ready
# @DESCRIPTION:
# Checks if all firmware is installed to avoid build time failure
is_firmware_ready() {
einfo
einfo "Performing a firmware roll call"
einfo
	local fw_relpaths=(
		$(grep "CONFIG_EXTRA_FIRMWARE" "${BUILD_DIR}/.config" \
			| head -n 1 | cut -f 2 -d "\"")
	)
	local found_missing=0
	local p
	for p in ${fw_relpaths[@]} ; do
		[[ "${p}" =~ "amdgpu-" ]] && continue
		if [[ ! -e "/lib/firmware/${p}" ]] ; then
eerror "Missing firmware file for /lib/firmware/${p}"
			found_missing=1
		else
einfo "/lib/firmware/${p} is present"
		fi
	done
	if (( ${found_missing} == 1 )) ; then
eerror "Remove the entries from CONFIG_EXTRA_FIRMWARE in ${config}"
		die
	fi

	local fw_abspaths=()
	for p in ${fw_relpaths[@]} ; do
		fw_abspaths+=(
			"/lib/firmware/${p}"
		)
	done

	# This scan is done because of the existence of non distro overlays,
	# local repos, live ebuilds.
	security-scan_avscan "${fw_abspaths[@]}"
}

# Remove blacklisted firmware relpath.
_remove_blacklisted_firmware_paths() {
	local ARG=$(</dev/stdin)
	local BLACKLISTED
	local BLACKLISTED=(
		${OT_KERNEL_BLACKLIST_FIRMWARE_PATHS}
	)
	local x
	for x in ${ARG} ; do
		local blacklisted=0
		local b
		for b in ${BLACKLISTED[@]} ; do
			[[ "${x#./}" == "${b}" ]] && blacklisted=1
		done
		(( ${blacklisted} == 1 )) && continue
	        echo -e "${x}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_firmware
# @DESCRIPTION:
# Adds firmware to the kernel config
ot-kernel_set_kconfig_firmware() {
	# OT_KERNEL_FIRMWARE recognizes the wildcard patterns:
	# 1. Add by wildcard.  file*.bin dir* d*r
	# 2. Add by literal.  file.bin dir/file.bin

	# When you use OT_KERNEL_FIRMWARE envvar, it is implied it will wipe the
	# previous setting.
	#

	local ot_kernel_firmware="${OT_KERNEL_FIRMWARE}"
	if [[ -n "${ot_kernel_firmware}" ]] ; then
		local firmware=()
		if ! ot-kernel_has_version "sys-kernel/linux-firmware" ; then
ewarn "sys-kernel/linux-firmware should be installed first"
		fi
einfo "Adding firmware"
		pushd /lib/firmware >/dev/null 2>&1 || die "Missing firmware"
			for l in $(echo ${ot_kernel_firmware} | tr " " "\n") ; do
				firmware+=(
					$(find . -path "*${l}*" \
						| _remove_blacklisted_firmware_paths \
						| sed -e "s|^\./||g")
				)
			done
		popd >/dev/null 2>&1 || die
		firmware=($(echo "${firmware[@]}" | tr " " "\n" | sort))
		firmware="${firmware[@]}" # bash problems
		firmware=$(echo "${firmware}" \
			| sed -r \
				-e "s|[ ]+| |g" \
				-e "s|^[ ]+||g" \
				-e 's|[ ]+$||g') # Trim mid/left/right spaces
		ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""

		# Removes slotted firmware
		firmware=$(echo "${firmware}" \
			| tr " " "\n" \
			| sed -e "/amdgpu-/d" \
			| tr "\n" " " )
		ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""

		local list=$(grep "CONFIG_EXTRA_FIRMWARE" \
			"${BUILD_DIR}/.config" \
			| head -n 1 \
			| cut -f 2 -d "\"")
einfo "CONFIG_EXTRA_FIRMWARE:  ${list}"
	fi
}

# @FUNCTION: ot-kernel_check_firmware
# @DESCRIPTION:
# Check firmware for vulnerability fixes
ot-kernel_check_firmware() {
	[[ "${OT_KERNEL_CHECK_FIRMWARE_VULNERABILITY_FIXES:-1}" == "1" ]] || return
	if has_version "=sys-kernel/linux-firmware-99999999" ; then
		local current_firmware_update=$(cat "${EROOT}/var/db/pkg/sys-kernel/linux-firmware"*"/BUILD_TIME")
		local fix_firmware_date=$(date -d "${LINUX_FIRMWARE_TIMESTAMP}" "+%s")
		if (( ${current_firmware_update} < ${fix_firmware_date} )) ; then
eerror
eerror "Re-emerge =sys-kernel/linux-firmware-99999999 for CPU microcode security"
eerror "updates."
eerror
		fi
		die
	fi
}

# @FUNCTION: ot-kernel_get_envs
# @DESCRIPTION:
# Gets list of envs
ot-kernel_get_envs() {
	# The envs /etc/portage/ot-sources/${KV_MAJOR_MINOR}/${extraversion}/${arch}/env
	find "/etc/portage/ot-sources/${KV_MAJOR_MINOR}/" -type f -name "env"
}

# @FUNCTION: check_environment_variable_renames
# @DESCRIPTION:
# Check if the variable name is still being used.
check_environment_variable_renames() {
	if [[ -n "${OT_KERNEL_EP800}" ]] ; then
eerror "OT_KERNEL_EP800 new name is now CAMERAS=\"ep800\".  Please rename to continue."
	fi
	if [[ -n "${WEBCAMS}" ]] ; then
eerror "WEBCAMS new name is now CAMERAS.  Please rename to continue."
	fi
	if [[ -n "${WEBCAMS_UVC_SNAPSHOT_BUTTON}" ]] ; then
eerror "WEBCAMS_UVC_SNAPSHOT_BUTTON new name is now CAMERAS_SNAPSHOT_BUTTON.  Please rename to continue."
	fi
	if [[ -n "${ZENSAUCE_BLACKLIST}" || -n "${ZENSAUCE_WHITELIST}" ]] ; then
eerror
eerror "ZENSAUCE_BLACKLIST new name is now ZEN_SAUCE_BLACKLIST.  Please rename to continue."
eerror "ZENSAUCE_WHITELIST new name is now ZEN_SAUCE_WHITELIST.  Please rename to continue."
eerror "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
eerror "details."
eerror
		die
	fi

	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BAD}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BAD has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BULK_FG}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BULK_FG has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BULK_SEND}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BULK_SEND has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_FAIR_SERVER}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_FAIR_SERVER has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HOME_SERVER_FAIR.  Please rename to continue."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMING_CLIENT}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMING_CLIENT has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMES.  Please rename to continue."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMES}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMES has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMING.  Please rename to continue."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_BG}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_BG has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_LARGE}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_LARGE has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_SMALL}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MULTI_SMALL has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_POWER}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_POWER has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GREEN.  Please rename to continue"
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_REC}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_REC has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VOIP.  Please rename to continue."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RELIABLE}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RELIABLE has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RURAL}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RURAL has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RESET}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_RESET has been removed."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_THROUGHPUT_SERVER}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_THROUGHPUT_SERVER has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HOME_SERVER_THROUGHPUT.  Please rename to continue."
	fi
	if [[ -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WWW_CLIENT}" ]] ; then
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WWW_CLIENT has been renamed to OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WWW.  Please rename to continue."
	fi

ewarn
ewarn "The interpretation of the OT_KERNEL_HARDENING_LEVEL values has changed."
ewarn "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
ewarn "details."
ewarn
}

# @FUNCTION: ot-kernel_clear_env
# @DESCRIPTION:
# Clears the configuration environment variables for the next
# buildconfig being evaluated.
ot-kernel_clear_env() {
	check_environment_variable_renames

	# The OT_KERNEL_ prefix is to avoid naming collisions.
	unset OT_KERNEL_ARCH
	unset OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS
	unset OT_KERNEL_BOOT_ARGS
	unset OT_KERNEL_BOOT_ARGS_LOCKDOWN
	unset OT_KERNEL_BOOT_DECOMPRESSOR
	unset OT_KERNEL_BOOT_KOPTIONS
	unset OT_KERNEL_BOOT_KOPTIONS_APPEND
	unset OT_KERNEL_BUILD
	unset OT_KERNEL_BUILD_ALL_MODULES_AS
	unset OT_KERNEL_BUILD_CHECK_MOUNTED
	unset OT_KERNEL_CHECK_FIRMWARE_VULNERABILITY_FIXES
	unset OT_KERNEL_COLD_BOOT_MITIGATIONS
	unset OT_KERNEL_CONFIG
	unset OT_KERNEL_CONFIG_MODE
	unset OT_KERNEL_CPU_MICROCODE
	unset OT_KERNEL_CPU_SCHED
	unset OT_KERNEL_DISABLE
	unset OT_KERNEL_DISABLE_USB_AUTOSUSPEND
	unset OT_KERNEL_DMA_ATTACK_MITIGATIONS
	unset OT_KERNEL_DMESG
	unset OT_KERNEL_EARLY_KMS
	unset OT_KERNEL_EFI_PARTITION
	unset OT_KERNEL_EP800
	unset OT_KERNEL_EXTRAVERSION
	unset OT_KERNEL_FAST_SOURCE_CODE_INSTALL
	unset OT_KERNEL_FIRMWARE
	unset OT_KERNEL_FIRMWARE_AVSCAN
	unset OT_KERNEL_FORCE_APPLY_DISABLE_DEBUG
#	unset OT_KERNEL_HALT_ON_LOWERED_SECURITY		# global var
	unset OT_KERNEL_HARDENING_LEVEL
	unset OT_KERNEL_HDD
	unset OT_KERNEL_HWRAID
	unset OT_KERNEL_IMA
	unset OT_KERNEL_IMA_HASH_ALG
	unset OT_KERNEL_IMA_POLICIES
	unset OT_KERNEL_INIT
	unset OT_KERNEL_INSTALL_SOURCE_CODE
	unset OT_KERNEL_IOMMU
	unset OT_KERNEL_IOSCHED
	unset OT_KERNEL_IOSCHED_OPENRC
	unset OT_KERNEL_IOSCHED_OVERRIDE
	unset OT_KERNEL_IOSCHED_SYSTEMD
	unset OT_KERNEL_KCONFIG
	unset OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER
	unset OT_KERNEL_KERNEL_DIR
	unset OT_KERNEL_KEXEC
	unset OT_KERNEL_LOGO_COUNT
	unset OT_KERNEL_LOGO_FOOTNOTES
	unset OT_KERNEL_LOGO_FOOTNOTES_ON_INIT
	unset OT_KERNEL_LOGO_LICENSE_URI
	unset OT_KERNEL_LOGO_MAGICK_ARGS
	unset OT_KERNEL_LOGO_MAGICK_PACKAGE
	unset OT_KERNEL_LOGO_URI
	unset OT_KERNEL_LOGO_PREPROCESS_PATH
	unset OT_KERNEL_LOGO_PREPROCESS_SHA512
	unset OT_KERNEL_LOGO_PREPROCESS_BLAKE2B
	unset OT_KERNEL_LSMS
	unset OT_KERNEL_MENUCONFIG_COLORS
	unset OT_KERNEL_MENUCONFIG_RUN_AT
	unset OT_KERNEL_MENUCONFIG_UI
	unset OT_KERNEL_MESSAGE
	unset OT_KERNEL_MODULE_SUPPORT
	unset OT_KERNEL_MODULES_COMPRESSOR
	unset OT_KERNEL_NEST_FREQ_GOV
	unset OT_KERNEL_NET_NETFILTER
	unset OT_KERNEL_NET_QOS_ACTIONS
	unset OT_KERNEL_NET_QOS_CLASSIFIERS
	unset OT_KERNEL_NET_QOS_SCHEDULERS
	unset OT_KERNEL_PAGE_SIZE
	unset OT_KERNEL_PCIE_MPS
	unset OT_KERNEL_PGO_FLAVOR
	unset OT_KERNEL_PHYS_MEM_TOTAL_GIB
	unset OT_KERNEL_PKGFLAGS_ACCEPT
	unset OT_KERNEL_PKGFLAGS_REJECT
	unset OT_KERNEL_PKU
#	unset OT_KERNEL_PRIMARY_EXTRAVERSION			# global var
#	unset OT_KERNEL_PRIMARY_EXTRAVERSION_WITH_TRESOR	# global var
	unset OT_KERNEL_PRIVATE_KEY
	unset OT_KERNEL_PRESERVE_HEADER_NOTICES
	unset OT_KERNEL_PRESERVE_HEADER_NOTICES_CACHED
	unset OT_KERNEL_PRUNE_EXTRA_ARCHES
	unset OT_KERNEL_PUBLIC_KEY
	unset OT_KERNEL_REISUB
	unset OT_KERNEL_SATA_LPM_MAX
	unset OT_KERNEL_SATA_LPM_MID
	unset OT_KERNEL_SATA_LPM_MIN
	unset OT_KERNEL_SGX
	unset OT_KERNEL_SLAB_ALLOCATOR
	unset OT_KERNEL_SME
	unset OT_KERNEL_SME_DEFAULT_ON
	unset OT_KERNEL_SHARED_KEY
	unset OT_KERNEL_SIGN_KERNEL
	unset OT_KERNEL_SIGN_MODULES
	unset OT_KERNEL_SSD
	unset OT_KERNEL_BOOT_SUBSYSTEMS
	unset OT_KERNEL_BOOT_SUBSYSTEMS_APPEND
	unset OT_KERNEL_SWAP_COMPRESSION
	unset OT_KERNEL_USE_LSM_UPSTREAM_ORDER
	unset OT_KERNEL_TARGET_TRIPLE
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BGDL
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BROADCAST
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GREEN
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_FTP
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMING
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MUSIC
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_P2P
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_PODCAST
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_PODCAST_UPLOAD
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_SOCIAL_GAMES
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_STREAMING
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_TORRENT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VIDEO_CHAT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VIDEO_UPLOAD
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VOIP
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WWW

	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_FAIR
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_REALTIME
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_THROUGHPUT

	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_FAIR
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_REALTIME
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_THROUGHPUT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_FAIR
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_REALTIME
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_THROUGHPUT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_FAIR
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_REALTIME
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_THROUGHPUT
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_FAIR
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_REALTIME
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_THROUGHPUT

	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HIGH_BDP
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INTRA_DC
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INTER_DC
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_SATELLITE
	unset OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WIRELESS_DC

	unset OT_KERNEL_USE
	unset OT_KERNEL_VERBOSITY
	unset OT_KERNEL_WORK_PROFILE
	unset OT_KERNEL_ABIS
	unset OT_KERNEL_ZSWAP_ALLOCATOR
	unset OT_KERNEL_ZSWAP_COMPRESSOR
	unset PERMIT_NETFILTER_SYMBOL_REMOVAL

	# Unset ot-kernel-pkgflags.
	# These fields toggle the building of additional sets of kernel configs.
	unset AMDGPU_DEEP_COLOR
	unset AMDGPU_DIRECT_DMA_FOR_SSG
	unset AMDGPU_EXP_HW_SUPPORT
	unset AMDGPU_OVERDRIVE
	unset AMDGPU_VM_FRAGMENT_SIZE
	unset ALSA_PC_SPEAKER
	unset BPF_JIT
	unset CAMERAS
	unset CAMERAS_SNAPSHOT_BUTTON
	unset CRYPTSETUP_CIPHERS
	unset CRYPTSETUP_INTEGRITIES
	unset CRYPTSETUP_HASHES
	unset CRYPTSETUP_MODES
	unset CRYPTSETUP_TCRYPT
	unset EMU_16BIT
	unset HPLIP_PARPORT
	unset HPLIP_USB
	unset I915_GEN9_HWACCEL_LOW_POWER_VIDEO_ENCODING
	unset IPTABLES_CLIENT
	unset IPTABLES_ROUTER
	unset KVM_GUEST_MEM_HOTPLUG
	unset KVM_GUEST_PCI_HOTPLUG
	unset KVM_GUEST_VIRTIO_BALLOON
	unset KVM_GUEST_VIRTIO_CONSOLE_DEVICE
	unset KVM_GUEST_VIRTIO_MEM
	unset LM_SENSORS_MODULES
	unset MEMCARD_MMC
	unset MEMCARD_SDIO
	unset MEMCARD_SD
	unset MEMSTICK
	unset MDADM_RAID
	unset MICROCODE_SIGNATURES
	unset MICROCODE_BLACKLIST
	unset MOBO_AUDIO
	unset MOBO_AUDIO_LEGACY
	unset NEST_SPINNING
	unset NFS_CLIENT
	unset NFS_SERVER
	unset OSS
	unset OSS_MIDI
	unset RADEON_DEEP_COLOR
	unset SANE_SCSI
	unset SANE_USB
	unset SQUASHFS_4K_BLOCK_SIZE
	unset SQUASHFS_DECOMPRESSORS_PER_CORE
	unset SQUASHFS_NFRAGS_CACHED
	unset SQUASHFS_NSTEP_DECOMPRESS
	unset SQUASHFS_XATTR
	unset SQUASHFS_ZLIB
	unset STD_PC_SPEAKER
	unset TRESOR_MAX_KEY_SIZE
	unset TRESOR_TARGET_OVERRIDE
	unset TTY_DRIVER
	unset QEMU_GUEST_LINUX
	unset QEMU_HOST
	unset QEMU_KVMGT
	unset SEV
	unset USB_FLASH_EXT2
	unset USB_FLASH_EXT4
	unset USB_FLASH_F2FS
	unset USB_FLASH_UDF
	unset USB_MASS_STORAGE
	unset USE_SUID_SANDBOX
	unset VIRTUALBOX_GUEST_LINUX
	unset VSYSCALL_MODE
	unset WATCHDOG_DRIVERS
	unset X86_MICROARCH_OVERRIDE
	unset XEN_PCI_PASSTHROUGH
	unset YUBIKEY
	unset ZEN_DOM0
	unset ZEN_DOMU

	unset GENPATCHES_BLACKLIST

	unset ZEN_SAUCE_BLACKLIST
	unset ZEN_SAUCE_WHITELIST
}

# @FUNCTION: ot-kernel_load_config
# @DESCRIPTION:
# Clear load config
ot-kernel_load_config() {
	source "${env_path}"

	if declare -p OT_KERNEL_PKGFLAGS_ACCEPT >/dev/null 2>&1 \
		&& [[ "${!OT_KERNEL_PKGFLAGS_ACCEPT[@]}" == "0" ]] ; then
eerror
eerror "The OT_KERNEL_PKGFLAGS_ACCEPT has been changed from a string to an"
eerror "associative array (for faster O(1) lookups)."
eerror
eerror "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
eerror "details."
eerror
		die
	fi

	if declare -p OT_KERNEL_PKGFLAGS_REJECT >/dev/null 2>&1 \
		&& [[ "${!OT_KERNEL_PKGFLAGS_REJECT[@]}" == "0" ]] ; then
eerror
eerror "The OT_KERNEL_PKGFLAGS_REJECT has been changed from a string to an"
eerror "associative array (for faster O(1) lookups)."
eerror
eerror "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
eerror "details."
eerror
		die
	fi

	if [[ -z "${OT_KERNEL_USE}" ]] ; then
		export OT_KERNEL_USE="${PKGUSE}"
	fi

	if [[ -z "${OT_KERNEL_BUILD}" ]] && ( use build || ot-kernel_use build ) ; then
		export OT_KERNEL_BUILD=1
	fi

	local kcp_provider=$(ot-kernel_get_kcp_provider)

	if [[ "${kcp_provider}" =~ ("graysky2") ]] && [[ "${PV}" =~ "9999" ]] ; then
eerror
eerror "The current value of OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER is not"
eerror "acceptable for live sources.  In addition the corresponding USE flag"
eerror "(for either genpatches or zen-sauce) must be enabled."
eerror
eerror "Allowed values:  disable, none, zen-sauce"
eerror "Actual value:  ${OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER:-graysky2}"
eerror
		die
	fi

	if [[ "${kcp_provider}" =~ ("zen-sauce") ]] && ! use zen-sauce ; then
eerror
eerror "The zen-sauce USE flag must be enabled for"
eerror "OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER=\"zen-sauce\""
eerror
		die
	fi
	if [[ "${kcp_provider}" =~ ("genpatches") ]] && ! use genpatches ; then
eerror
eerror "The zen-sauce USE flag must be enabled for"
eerror "OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER=\"genpatches\""
eerror
		die
	fi
}

# @FUNCTION: ot-kernel_is_build
# @DESCRIPTION:
# Checks if build flag is set per build
ot-kernel_is_build() {
	[[ "${OT_KERNEL_BUILD}" == "1" ]] && return 0
	[[ "${OT_KERNEL_BUILD,,}" == "yes" ]] && return 0
	[[ "${OT_KERNEL_BUILD,,}" == "true" ]] && return 0
	[[ "${OT_KERNEL_BUILD,,}" == "build" ]] && return 0
	return 1
}

# ot-kernel_set_kconfig_mem need rework

# @FUNCTION: ot-kernel_validate_tcp_congestion_controls_default
# @DESCRIPTION:
# Check if the default for TCP Congestion Control is valid
ot-kernel_validate_tcp_congestion_controls_default() {
	local DEFAULT_ALGS=(
		BIC
		CUBIC
		HTCP
		HYBLA
		VEGAS
		VENO
		WESTWOOD
		DCTCP
		CDG
		BBR
		BBR2
		BBR3
		RENO
	)
	local picked_alg=$(echo "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" \
		| tr " " "\n" \
		| head -n 1)
	local found=0
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		if [[ "${alg}" == "${picked_alg^^}" ]] ; then
			found=1
			break
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "${picked_alg} cannot be used as a default TCP Congestion Control"
eerror "algorithm."
eerror
eerror "OT_KERNEL_TCP_CONGESTION_CONTROLS:  ${OT_KERNEL_TCP_CONGESTION_CONTROLS}"
eerror
		die
	fi
}

# @FUNCTION: ot-kernel_get_tcp_congestion_controls_default
# @DESCRIPTION:
# Gets the default TCP Congestion Control algorithm from
# OT_KERNEL_TCP_CONGESTION_CONTROLS.
#
# The result is the non-canonical name.
ot-kernel_get_tcp_congestion_controls_default() {
	local picked_alg=$(echo "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" \
		| tr " " "\n" \
		| head -n 1)
	echo "${picked_alg}"
}

# @FUNCTION: _ot-kernel_set_kconfig_get_init_tcp_congestion_controls
# @DESCRIPTION:
# Get the initial defaults for OT_KERNEL_TCP_CONGESTION_CONTROLS
_ot-kernel_set_kconfig_get_init_tcp_congestion_controls() {
	local v

	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	if [[ \
		   "${work_profile}" == "custom" \
		|| "${work_profile}" == "manual" \
	]] ; then
		:
	elif [[ \
		   "${work_profile}" == "realtime-hpc" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr3 dctcp illinois"}
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr2 dctcp illinois"}
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr dctcp illinois"}
		fi
	elif [[ \
		   "${work_profile}" == "hpc" \
		|| "${work_profile}" == "throughput-hpc" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"dctcp bbr3 illinois"}
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"dctcp bbr2 illinois"}
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"dctcp bbr illinois"}
		fi
	elif [[ \
		   "${work_profile}" == "green-hpc" \
		|| "${work_profile}" == "greenest-hpc" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
# Energy savings is unknown.
# We are interested in deterministic power savings.
eerror
eerror "Remove bbrv3 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr or dctcp instead."
eerror
			die
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
# Patching may cause an unintended consequence (e.g. increased energy use).
eerror
eerror "Remove bbrv2 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr or dctcp instead"
eerror
			die
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr dctcp illinois"}
		fi
	elif [[ \
		   "${work_profile}" == "game-server" \
		|| "${work_profile}" == "http-server-busy" \
		|| "${work_profile}" == "http-server-relaxed" \
	]] ; then
	# vegas for production mode
	# bbr for maintenance mode
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"vegas bbr3"}
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"vegas bbr2"}
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"vegas bbr"}
		fi
	elif [[ \
		   "${work_profile}" == "distributed-computing-server" \
		|| "${work_profile}" == "dvr" \
		|| "${work_profile}" == "file-server" \
		|| "${work_profile}" == "jukebox" \
		|| "${work_profile}" == "media-server" \
		|| "${work_profile}" == "pi-audio-player" \
		|| "${work_profile}" == "pi-video-player" \
		|| "${work_profile}" == "pi-web-browser" \
		|| "${work_profile}" == "sdr" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr3"}
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr2"}
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr"}
		fi
	elif [[ \
		   "${work_profile}" == "smartphone" \
		|| "${work_profile}" == "smartphone-voice" \
		|| "${work_profile}" == "tablet" \
		|| "${work_profile}" == "video-smartphone" \
		|| "${work_profile}" == "video-tablet" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
eerror
eerror "Remove bbrv3 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr instead."
eerror
			die
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
eerror
eerror "Remove bbrv2 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr instead"
eerror
			die
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr htcp hybla vegas westwood"}
		fi
	elif [[ \
		   "${work_profile}" == "casual-gaming-laptop" \
		|| "${work_profile}" == "cryptocurrency-miner-dedicated" \
		|| "${work_profile}" == "cryptocurrency-miner-workstation" \
		|| "${work_profile}" == "green-pc" \
		|| "${work_profile}" == "greenest-pc" \
		|| "${work_profile}" == "gpu-gaming-laptop" \
		|| "${work_profile}" == "laptop" \
		|| "${work_profile}" == "solar-desktop" \
		|| "${work_profile}" == "solar-gaming" \
		|| "${work_profile}" == "touchscreen-laptop" \
	]] ; then
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
eerror
eerror "Remove bbrv3 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr instead."
eerror
			die
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
eerror
eerror "Remove bbrv2 from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile}.  Use bbr instead."
eerror
			die
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr htcp hybla lp vegas westwood"}
		fi
	else
		if has bbrv3 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv3 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr3 htcp hybla lp vegas westwood"}
		elif has bbrv2 ${IUSE_EFFECTIVE} && ot-kernel_use bbrv2 ; then
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr2 htcp hybla lp vegas westwood"}
		else
			v=${OT_KERNEL_TCP_CONGESTION_CONTROLS:-"bbr htcp hybla lp vegas westwood"}
		fi
	fi

	echo "${v}"
}

# @FUNCTION: ot-kernel_set_kconfig_set_tcp_congestion_controls
# @DESCRIPTION:
# Sets the kernel config for selecting multiple TCP congestion controls for
# different scenaros.
ot-kernel_set_kconfig_set_tcp_congestion_controls() {
	# Design note:
	# The work profile may alter the tcp_congestion_controls to benefit
	# certain scenarios but has been dropped.
	OT_KERNEL_TCP_CONGESTION_CONTROLS=$(_ot-kernel_set_kconfig_get_init_tcp_congestion_controls)
	local DEFAULT_ALGS=(
		BIC
		CUBIC
		HTCP
		HYBLA
		VEGAS
		VENO
		WESTWOOD
		DCTCP
		CDG
		BBR
		BBR2
		BBR3
		RENO
	)
	local ALGS=(
		BIC
		CUBIC
		WESTWOOD
		HTCP
		HSTCP
		HYBLA
		VEGAS
		NV
		SCALABLE
		LP
		VENO
		YEAH
		ILLINOIS
		DCTCP
		CDG
		BBR
		BBR2
		BBR3
	)
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_DEFAULT_${alg}"
	done

	for alg in ${ALGS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_TCP_CONG_${alg}"
	done

	# clear is for configurations without network.
	if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" != "clear" ]] ; then
		for alg in ${OT_KERNEL_TCP_CONGESTION_CONTROLS} ; do
	#
	# Non-canonical means what the ebuild accepts to easily identify the
	# exact needs of the user.  It is the informal name.
	#
	# Canonical means what the kernel formally accepts or only accepts.
	#
			local alg_canonical="${alg}"
			if [[ "${alg}" == "bbr3" ]] ; then
				alg_canonical="bbr"
			fi
			if [[ "${alg}" == "bbr2" ]] ; then
				if has bbrv2 ${IUSE_EFFECTIVE} \
					&& ! ot-kernel_use bbrv2 ; then
					# Skip it if not patched.
					continue
				fi
			fi
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"
			[[ "${alg}" == "pcc" ]] && continue
			if [[ "${ALGS[@]}" =~ "${alg^^}"( |$) ]] ; then
einfo "Adding ${alg}"
				# reno is only a default not advanced option
				ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
				ot-kernel_y_configopt "CONFIG_TCP_CONG_${alg_canonical^^}"
			fi
		done

		ot-kernel_validate_tcp_congestion_controls_default
		local picked_alg=$(ot-kernel_get_tcp_congestion_controls_default)
		picked_alg="${picked_alg,,}"
		local picked_alg_canonical="${picked_alg}"
		if [[ "${picked_alg}" == "bbr3" ]] ; then
			picked_alg_canonical="bbr"
		fi
		if [[ "${picked_alg}" == "bbr2" ]] ; then
			if has bbrv2 ${IUSE_EFFECTIVE} \
				&& ! ot-kernel_use bbrv2 ; then
				# Skip it if not patched.
				return
			fi
		fi
		[[ "${alg}" == "pcc" ]] && return
einfo "Using ${picked_alg} as the default TCP congestion control"
		ot-kernel_y_configopt "CONFIG_DEFAULT_${picked_alg_canonical^^}"
		ot-kernel_set_configopt "CONFIG_DEFAULT_TCP_CONG" "\"${picked_alg_canonical}\""
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_tcp_congestion_control_default
# @DESCRIPTION:
# Sets the kernel config for the TCP congestion control making it the default.
ot-kernel_set_kconfig_set_tcp_congestion_control_default() {
	local picked_alg="${1^^}" # non-canonical
einfo "Using ${picked_alg} as the default TCP congestion control"
	local picked_alg_canonical="${picked_alg}"
	if [[ "${picked_alg}" == "bbr3" ]] ; then
		picked_alg_canonical="bbr"
	fi
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_${picked_alg_canonical}"
	ot-kernel_y_configopt "CONFIG_DEFAULT_${picked_alg_canonical}"
	ot-kernel_set_configopt "CONFIG_DEFAULT_TCP_CONG" "\"${picked_alg_canonical,,}\""
}

# @FUNCTION: ot-kernel_validate_net_qos_schedulers_default
# @DESCRIPTION:
# Does validity checks the default net QoS default
ot-kernel_validate_net_qos_schedulers_default() {
	local DEFAULT_ALGS=(
		FQ
		CODEL
		FQ_CODEL
		FQ_PIE
		SFQ
		PFIFO_FAST
	)
	local picked_alg=$(echo "${OT_KERNEL_NET_QOS_SCHEDULERS}" \
		| tr " " "\n" \
		| head -n 1)

	local found=0
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		if [[ "${alg}" == "${picked_alg^^}" ]] ; then
			found=1
			break
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "${picked_alg} cannot be used as a default network QoS"
eerror "algorithm."
eerror
eerror "OT_KERNEL_NET_QOS_SCHEDULERS:  ${OT_KERNEL_NET_QOS_SCHEDULERS}"
eerror
		die
	fi
}

# @FUNCTION: ot-kernel_get_net_qos_schedulers_default
# @DESCRIPTION:
# Get the default net QoS default
ot-kernel_get_net_qos_schedulers_default() {
	local picked_alg=$(echo "${OT_KERNEL_NET_QOS_SCHEDULERS}" \
		| tr " " "\n" \
		| head -n 1)
	echo "${picked_alg}"
}

# @FUNCTION: ot-kernel_set_kconfig_set_net_qos_actions
# @DESCRIPTION:
# Setup network QoS classifier support
ot-kernel_set_kconfig_set_net_qos_actions() {
	[[ -z "${OT_KERNEL_NET_QOS_ACTIONS}" ]] && return
	local ALGS=(
		POLICE
		GACT
		MIRRED
		SAMPLE
		IPT
		NAT
		PEDIT
		SIMP
		SKBEDIT
		CSUM
		MPLS
		VLAN
		BPF
		SKBMOD
		IFE
		TUNNEL_KEY
		GATE
	)
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_NET_ACT_${alg}"
	done
	if [[ "${OT_KERNEL_NET_QOS_ACTIONS}" != "clear" ]] ; then
		ot-kernel_y_configopt "CONFIG_NET_CLS_ACT"
		for alg in ${OT_KERNEL_NET_QOS_ACTIONS} ; do
			ot-kernel_y_configopt "CONFIG_NET_ACT_${alg^^}"
		done
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_net_qos_classifiers
# @DESCRIPTION:
# Setup network QoS classifier support
ot-kernel_set_kconfig_set_net_qos_classifiers() {
	[[ -z "${OT_KERNEL_NET_QOS_CLASSIFIERS}" ]] && return
	local ALGS=(
		BASIC
		TCINDEX
		ROUTE4
		FW
		U32
		RSVP
		RSVP6
		FLOW
		CGROUP
		BPF
		FLOWER
		MATCHALL

		EMATCH
	)
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		if [[ "${alg}" == "EMATCH" ]] ; then
			ot-kernel_unset_configopt "CONFIG_NET_EMATCH"
			continue
		fi
		ot-kernel_unset_configopt "CONFIG_NET_CLS_${alg}"
		if [[ "${alg}" == "U32" ]] ; then
			ot-kernel_unset_configopt "CONFIG_CLS_U32_PERF"
			ot-kernel_unset_configopt "CONFIG_CLS_U32_MARK"
		fi
	done
	ot-kernel_unset_configopt "CONFIG_NET_EMATCH"
	if [[ "${OT_KERNEL_NET_QOS_CLASSIFIERS}" != "clear" ]] ; then
		for alg in ${OT_KERNEL_NET_QOS_CLASSIFIERS} ; do
			if [[ "${alg,,}" == "ematch" ]] ; then
				ot-kernel_y_configopt "CONFIG_CONFIG_NET_EMATCH"
				continue
			fi
			ot-kernel_y_configopt "CONFIG_NET_CLS_${alg^^}"
			if [[ "${alg,,}" == "u32" ]] ; then
				ot-kernel_y_configopt "CONFIG_CLS_U32_PERF"
				ot-kernel_y_configopt "CONFIG_CLS_U32_MARK"
			fi
		done
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_net_qos_schedulers
# @DESCRIPTION:
# Setup network QoS to reduce jitter or latency classification
ot-kernel_set_kconfig_set_net_qos_schedulers() {
	[[ -z "${OT_KERNEL_NET_QOS_SCHEDULERS}" ]] && return
	local DEFAULT_ALGS=(
		FQ
		CODEL
		FQ_CODEL
		FQ_PIE
		SFQ
		PFIFO_FAST
	)
	local ALGS=(
		CBQ
		HTB
		HFSC
		ATM
		PRIO
		MULTIQ
		RED
		SFB
		SFQ
		TEQL
		TBF
		CBS
		ETF
		TAPRIO
		GRED
		DSMARK
		NETEM
		DRR
		MQPRIO
		SKBPRIO
		CHOKE
		QFQ
		CODEL
		FQ_CODEL
		CAKE
		FQ
		HHF
		PIE
		FQ_PIE
		INGRESS
		PLUG
		ETS
	)
	local alg
	for alg in ${DEFAULT_ALGS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_DEFAULT_${alg}"
	done

	for alg in ${ALGS[@]} ; do
		ot-kernel_unset_configopt "NET_SCH_${alg^^}"
	done

	# clear is for configurations without network.

	if [[ "${OT_KERNEL_NET_QOS_SCHEDULERS}" != "clear" ]] ; then
		for alg in ${OT_KERNEL_NET_QOS_SCHEDULERS} ; do
			[[ "${alg,,}" == "pfifo_fast" ]] && continue
			ot-kernel_y_configopt "CONFIG_${alg^^}"
		done

		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
		ot-kernel_y_configopt "CONFIG_NET_SCH_DEFAULT"

		ot-kernel_validate_net_qos_schedulers_default
		local picked_alg=$(ot-kernel_get_net_qos_schedulers_default)
		picked_alg="${picked_alg,,}"
einfo "Using ${picked_alg} as the default network QoS"
		ot-kernel_y_configopt "CONFIG_DEFAULT_${picked_alg^^}"
	fi
}

# @FUNCTION: ot-kernel_set_mobo_audio
# @DESCRIPTION:
# Common motherboard audio, pci cards for budget gamer, or laptop audio.
ot-kernel_set_mobo_audio() {
	# 2005 - present (2023)
	if [[ "${MOBO_AUDIO:-1}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
		ot-kernel_set_configopt "CONFIG_SND_HDA_INTEL" "m"
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_CA0110" "m" # 2008
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_CA0132" "m" # 2011
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_REALTEK" "m" # 2004
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" "m" # 2005
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_VIA" "m" # 2006-2009
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
		ot-kernel_set_configopt "CONFIG_SND_VIRTUOSO" "m" # 2008
	fi
	# 1997 - 2004
	if [[ "${MOBO_AUDIO_LEGACY:-0}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
		ot-kernel_set_configopt "CONFIG_SND_ATIIXP" "m" # 2003-2004
		ot-kernel_set_configopt "CONFIG_SND_AU8810" "m" # 1999
		ot-kernel_set_configopt "CONFIG_SND_AU8820" "m" # 1997
		ot-kernel_set_configopt "CONFIG_SND_AU8830" "m" # 1998
		ot-kernel_set_configopt "CONFIG_SND_CTXFI" "m" # 2005
		ot-kernel_set_configopt "CONFIG_SND_EMU10K1" "m" # 1998
		ot-kernel_set_configopt "CONFIG_SND_INTEL8X0" "m" # 1999
		ot-kernel_set_configopt "CONFIG_SND_CA0106" "m" # 2004
		ot-kernel_set_configopt "CONFIG_SND_VIA82XX" "m" # 2002
	fi
}

# @FUNCTION: ot-kernel_set_webcam
# @DESCRIPTION:
# Enable webcam drivers.
ot-kernel_set_webcam() {
	cd "${BUILD_DIR}" || die
	local wants_gspca=0
	local wants_usb_webcam=0
	local wants_uvc_webcam=0
	local cameras="${CAMERAS,,}"
	if [[ "${cameras}" == "gspca" || "${cameras}" == "all" ]] ; then
		wants_gspca=1
		local ALL_GSPCA=(
			$(grep -r -e "config USB_GSPCA" $(find drivers/media/usb -name "Kconfig*") \
				| cut -f 2 -d ":" \
				| cut -f 2 -d " " \
				| cut -f 3 -d "_" \
				| sort \
				| sed -e "/^$/d")
			"USB_GL860"
			"USB_M5602"
			"USB_STV06XX"
		)
		local m # gspca module
		for m in ${ALL_GSPCA[@]} ; do
			ot-kernel_set_configopt "CONFIG_${m}" "m"
			wants_usb_webcam=1
			wants_gspca=1
		done
	fi

	# Add requested GSPCA drivers
	if [[ -n "${cameras}" ]] ; then
		local ALL_GSPCA=(
			$(grep -r -e "config USB_GSPCA" $(find drivers/media/usb -name "Kconfig*") \
				| cut -f 2 -d ":" \
				| cut -f 2 -d " " \
				| cut -f 3 -d "_" \
				| sort \
				| sed -e "/^$/d")
			"USB_GL860"
			"USB_M5602"
			"USB_STV06XX"
		)
		local x
		for x in ${cameras^^} ; do
			local m
			for m in ${ALL_GSPCA[@]} ; do
				if [[ "${x}" =~ "${m}" ]] ; then
					ot-kernel_set_configopt "CONFIG_${m}" "m"
					wants_usb_webcam=1
					wants_gspca=1
				fi
			done
		done
	fi

	if [[ "${cameras}" =~ ("all"|"pwc") ]] ; then
		ot-kernel_set_configopt "CONFIG_USB_PWC" "m"
		wants_usb_webcam=1
	fi

	if [[ "${cameras}" =~ ("all"|"uvc") ]] ; then
		ot-kernel_set_configopt "CONFIG_USB_VIDEO_CLASS" "m"
		wants_usb_webcam=1
		if [[ "${CAMERAS_SNAPSHOT_BUTTON:-1}" == "1" ]] ; then
			# Take snapshot button
			ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
		fi
	fi

	if (( ${wants_usb_webcam} == 1 )) ; then
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi

	if (( ${wants_gspca} == 1 )) ; then
		ot-kernel_set_configopt "CONFIG_USB_GSPCA" "m"
	fi

	# For testing build time breakage
	ot-kernel_set_kconfig_ep800
}

# @FUNCTION: ot-kernel_set_mobile_camera
# @DESCRIPTION:
# Enable camera drivers for smartphone or mobile devices
ot-kernel_set_mobile_camera() {
	cd "${BUILD_DIR}" || die
	local cameras="${CAMERAS,,}"
	local wants_i2c_camera=0
	if [[ "${cameras}" == "i2c" || "${cameras}" == "all" ]] ; then
		local ALL_I2C_CAMERAS=(
			$(grep -r -e "^config VIDEO_" $(find drivers/media/i2c -name "Kconfig*") \
				| cut -f 2- -d ":" \
				| cut -f 2 -d " " \
				| sort)
		)
		local x
		for x in ${cameras^^} ; do
			local m
			for m in ${ALL_I2C_CAMERAS[@]} ; do
				if [[ "${x}" =~ "${m}" ]] ; then
					ot-kernel_set_configopt "CONFIG_${m}" "m"
					wants_i2c_camera=1
				fi
			done
		done
	fi
	if (( ${wants_i2c_camera} == 1 )) ; then
		ot-kernel_y_configopt "CONFIG_VIDEO_CAMERA_SENSOR"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_I2C"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_boot_args
# @DESCRIPTION:
# Sets the kernel config for boot_args
ot-kernel_set_kconfig_boot_args() {
	local cmd
	if [[ -n "${OT_KERNEL_BOOT_ARGS}" ]] ; then
		ot-kernel_set_kconfig_kernel_cmdline "${OT_KERNEL_BOOT_ARGS}"
	fi
	if [[ "${OT_KERNEL_BOOT_ARGS_LOCKDOWN}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_CMDLINE_OVERRIDE"
	elif [[ "${OT_KERNEL_BOOT_ARGS_LOCKDOWN}" == "0" ]] ; then
		ot-kernel_unset_configopt "CONFIG_CMDLINE_OVERRIDE"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_cfi
# @DESCRIPTION:
# Sets the kernel config for Control Flow Integrity (CFI)
ot-kernel_set_kconfig_cfi() {
	_ot-kernel_validate_hardening_level
	if \
		[[ \
			   "${hardening_level}" == "custom" \
			|| "${hardening_level}" == "manual" \
		]] \
	; then
		:
	elif \
		[[ \
			   "${hardening_level}" == "default" \
			|| "${hardening_level}" == "practical" \
			|| "${hardening_level}" == "secure" \
		]] \
	; then
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG"
	elif \
		[[ \
			   "${hardening_level}" == "secure-af" \
			|| "${hardening_level}" == "secure-as-fuck" \
		]] \
			&&
		has cfi ${IUSE_EFFECTIVE} && ot-kernel_use cfi \
			&& \
		[[ \
			   "${arch}" == "x86_64"
			|| "${arch}" == "arm64" \
		]] \
	; then
		if [[ "${arch}" == "arm64" ]] && (( ${llvm_slot} < 12 )) ; then
eerror
eerror "CFI requires LLVM >= 12 on arm64"
eerror
			die
		fi
		if [[ "${arch}" == "x86_64" ]] && (( ${llvm_slot} < 13 )) ; then
eerror
eerror "CFI requires LLVM >= 13.0.1 on x86_64"
eerror
			die
		fi
einfo "Enabling CFI support in the in the .config."
		ot-kernel_y_configopt "CONFIG_ARCH_SUPPORTS_CFI_CLANG"
		ot-kernel_y_configopt "CONFIG_CFI_CLANG"
		ot-kernel_unset_configopt "CONFIG_CFI_PERMISSIVE"
		ban_dma_attack_use "cfi" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
	elif [[ \
		   "${hardening_level}" == "fast" \
		|| "${hardening_level}" == "fast-af" \
		|| "${hardening_level}" == "fast-as-fuck" \
		|| "${hardening_level}" == "performance" \
	]] ; then
einfo "Disabling CFI support in the in the .config."
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG"
	fi

	if \
		[[ \
			   "${hardening_level}" == "secure-af" \
			|| "${hardening_level}" == "secure-as-fuck" \
		]] \
		&& has cfi ${IUSE_EFFECTIVE} && ot-kernel_use cfi \
		&& [[ "${arch}" == "arm64" ]] \
	; then
		# Need to recheck
ewarn "You must manually set arm64 CFI in the .config."
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_kcfi
# @DESCRIPTION:
# Sets the kernel config for Control Flow Integrity (CFI)
ot-kernel_set_kconfig_kcfi() {
	_ot-kernel_validate_hardening_level
	if \
		[[ \
			   "${hardening_level}" == "custom" \
			|| "${hardening_level}" == "manual" \
		]] \
	; then
		:
	elif \
		[[ \
			   "${hardening_level}" == "default" \
			|| "${hardening_level}" == "practical" \
			|| "${hardening_level}" == "secure" \
		]] \
	; then
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG"
	elif \
		[[ \
			   "${hardening_level}" == "secure-af" \
			|| "${hardening_level}" == "secure-as-fuck" \
		]] \
			&& \
		has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi \
			&& \
		[[ "${arch}" == "x86_64" || "${arch}" == "arm64" ]] \
	; then
		if [[ "${arch}" == "arm64" ]] && (( ${llvm_slot} < 15 )) ; then
eerror
eerror "CFI requires LLVM >= 15 on arm64"
eerror
			die
		fi
		if [[ "${arch}" == "x86_64" ]] && (( ${llvm_slot} < 15 )) ; then
eerror
eerror "CFI requires LLVM >= 15 on x86_64"
eerror
			die
		fi
		if ! test-flags -fsanitize=kcfi >/dev/null 2>&1 ; then
eerror
eerror "Both >=sys-devel/clang-15 and >=sys-devel/llvm-15 must be patched for"
eerror "-fsanitize=kcfi support."
eerror
eerror "See https://reviews.llvm.org/D119296 for details."
eerror "See also https://wiki.gentoo.org/wiki//etc/portage/patches"
eerror
			die
		fi
einfo "Enabling KCFI support in the in the .config."
		ot-kernel_y_configopt "CONFIG_ARCH_SUPPORTS_CFI_CLANG"
		ot-kernel_y_configopt "CONFIG_CFI_CLANG"
		ot-kernel_unset_configopt "CONFIG_CFI_PERMISSIVE"
		ban_dma_attack_use "cfi" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
	elif \
		[[ \
			   "${hardening_level}" == "fast" \
			|| "${hardening_level}" == "fast-af" \
			|| "${hardening_level}" == "fast-as-fuck" \
			|| "${hardening_level}" == "performance" \
		]] \
	; then
einfo "Disabling KCFI support in the in the .config."
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG"
	fi

	if \
		[[ \
			   "${hardening_level}" == "secure-af" \
			|| "${hardening_level}" == "secure-as-fuck" \
		]] \
			&& \
		has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi \
			&& \
		[[ "${arch}" == "arm64" ]] \
	; then
		# Need to recheck
ewarn "You must manually set arm64 KCFI in the .config."
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_kexec
# @DESCRIPTION:
# Sets kexec in the kernel
ot-kernel_set_kconfig_kexec() {
	if [[ "${OT_KERNEL_KEXEC}" == "1" ]] ; then
einfo "Enabling kexec"
		ot-kernel_y_configopt "CONFIG_KEXEC"
	elif [[ "${OT_KERNEL_KEXEC}" == "0" ]] ; then
einfo "Disabling kexec"
		ot-kernel_unset_configopt "CONFIG_KEXEC"
	else
einfo "Using manual settings for kexec"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_reisub
# @DESCRIPTION:
# Allow REISUB in the kernel.
ot-kernel_set_kconfig_reisub() {
	if [[ "${OT_KERNEL_REISUB:-0}" == "1" ]] ; then
einfo "Enabling REISUB"
		ot-kernel_y_configopt "CONFIG_MAGIC_SYSRQ"
	else
einfo "Disabling REISUB"
		ot-kernel_unset_configopt "CONFIG_MAGIC_SYSRQ"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_dma_attack_mitigation
# @DESCRIPTION:
# Sets the kernel config to mitigate against DMA attacks.
OT_KERNEL_DMA_ATTACK_MITIGATIONS_ENABLED=0
OT_KERNEL_SHOWED_KEXEC_MITIGATION_WARNING=0
ot-kernel_set_kconfig_dma_attack_mitigation() {
	local ot_kernel_dma_attack_mitigations=${OT_KERNEL_DMA_ATTACK_MITIGATIONS:-1}
	if (( "${ot_kernel_dma_attack_mitigations}" >= 1 )) ; then
		export OT_KERNEL_DMA_ATTACK_MITIGATIONS_ENABLED=1
einfo "Mitigating against DMA attacks (EXPERIMENTAL / WORK IN PROGRESS)"

		if grep -q -E -e "(CONFIG_IOMMU_DEFAULT_DMA_STRICT=y|CONFIG_IOMMU_DEFAULT_DMA_LAZY=y)" "${path_config}" ; then
			:
		else
einfo "Using lazy as the default IOMMU domain type for mitigation against DMA attack."
			ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_PASSTHROUGH"
			ot-kernel_y_configopt "CONFIG_IOMMU_DEFAULT_DMA_LAZY"
			ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_STRICT"
		fi

		# Don't use lscpu/cpuinfo autodetect if using distcc or
		# Cross-compile but use the config itself to guestimate.
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			local found=0
			if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
einfo "Adding IOMMU support (VT-d)"
				ot-kernel_y_configopt "CONFIG_MMU"
				ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
				ot-kernel_y_configopt "CONFIG_ACPI"
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_PCI_MSI"
				ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
				ot-kernel_y_configopt "CONFIG_INTEL_IOMMU"
				found=1
			fi
			if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
einfo "Adding IOMMU support (Vi)"
				ot-kernel_y_configopt "CONFIG_MMU"
				ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
				ot-kernel_y_configopt "CONFIG_ACPI"
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
				ot-kernel_y_configopt "CONFIG_AMD_IOMMU"
				found=1
			fi
			if (( ${found} == 0 )) ; then
eerror
eerror "Failed to set IOMMU for DMA mitigation.  Set the CPU_MFG environment"
eerror "variable."
eerror
eerror "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
eerror "details."
eerror
				die
			fi
		fi

		# The set below breaks the bootstrapping shellcode process or
		# necessary prerequiste details for the attack.
		ot-kernel_unset_configopt "CONFIG_KALLSYMS"

ewarn "Coredump is going to be disabled"
		ot-kernel_unset_configopt "CONFIG_COREDUMP"

ewarn "KDB/KGDB_KDB is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_KGDB"
		ot-kernel_unset_configopt "CONFIG_KGDB_KDB"

		# Prevent obtaining addresses
		ot-kernel_set_kconfig_dmesg "0"
		ot-kernel_y_configopt "CONFIG_SECURITY_DMESG_RESTRICT"

		if [[ "${OT_KERNEL_KEXEC}" == "0" ]] ; then
			:
		elif [[ "${OT_KERNEL_IMA}" == "fix" ]] \
			&& grep -q -E -e "^CONFIG_KEXEC=y" "${path_config}" ; then
ewarn
ewarn "Allowing kexec during fixing of IMA appraisal, but these unknown kernels"
ewarn "need to have the same DMA mitigation settings.  See the ot-kernel eclass"
ewarn "for details."
ewarn
		elif [[ "${OT_KERNEL_IMA_POLICIES}" =~ "secure_boot" ]] ; then
ewarn
ewarn "Using signed IMA kernels but you are responsible for those kernels"
ewarn "having the same DMA mitigation settings.  See the ot-kernel eclass."
ewarn "for details."
ewarn
		else
einfo "Disabling kexec"
			ot-kernel_unset_configopt "CONFIG_KEXEC"
		fi
	fi
	if python -c "import sys; sys.exit(0) if (${ot_kernel_dma_attack_mitigations}>=1.5) else sys.exit(1)" ; then
einfo "Using strict as the default IOMMU domain type for mitigation against DMA attack."
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_PASSTHROUGH"
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_LAZY"
		ot-kernel_y_configopt "CONFIG_IOMMU_DEFAULT_DMA_STRICT"
	fi
	if (( "${ot_kernel_dma_attack_mitigations}" >= 2 )) ; then
		# This level is a preventative measure, but some attacks do not require these
		# settings below as a prerequisite or maybe assume they are automatically enabled
		# and active.

		# TODO:  Disable all DMA devices and ports.
		# This list is incomplete
ewarn "USB4 is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_USB4"
ewarn "XHCI USB3 is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_USB_XHCI_HCD"
ewarn "USB Type-C is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_TYPEC"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_cold_boot_mitigation
# @DESCRIPTION:
# Sets the kernel config to mitigate against cold boot attacks
ot-kernel_set_kconfig_cold_boot_mitigation() {
	# See also ot-kernel-pkgflags_tboot in ot-kernel-pkgflags

	# Cold boot attack mitigation
	# This section is incomplete and a Work In Progress (WIP)
	# The problem is common to many full disk encryption implementations.
	local ot_kernel_cold_boot_mitigations=${OT_KERNEL_COLD_BOOT_MITIGATIONS:-1}
	if (( "${ot_kernel_cold_boot_mitigations}" >= 1 )) ; then
einfo "Hardening kernel against cold boot attacks. (EXPERIMENTAL / WORK IN PROGRESS)"

		# These two may need a separate option.  We assume desktop,
		# but some users may use the kernel on laptop.  For now,
		# every user must cold-boot in suspend times 1-15 minutes.
ewarn "Suspend is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_SUSPEND"
ewarn "Hibernation is going to be disabled."
		ot-kernel_unset_configopt "CONFIG_HIBERNATION"

ewarn "Enabling memory sanitation for faster clearing of sensitive data and keys"
		if ver_test ${KV_MAJOR_MINOR} -ge 5.9 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL_ZERO"
		fi
		ot-kernel_y_configopt "CONFIG_INIT_ON_ALLOC_DEFAULT_ON"
		ot-kernel_y_configopt "CONFIG_INIT_ON_FREE_DEFAULT_ON"	# Production symbol.  The option's help does mention cold boot attacks.
		ot-kernel_unset_configopt "CONFIG_PAGE_POISONING"	# Test symbol.
		# CONFIG_PAGE_POISONING uses a fixed pattern and slower compared
		# to CONFIG_INIT_ON_FREE_DEFAULT_ON.
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_compiler_toolchain
# @DESCRIPTION:
# Sets the kernel config using the compiler toolchain
ot-kernel_set_kconfig_compiler_toolchain() {
	if \
		( \
		   ( has cfi ${IUSE_EFFECTIVE} && ot-kernel_use cfi ) \
		|| ( has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi ) \
		|| ( has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ) \
		|| ( has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang) \
		) \
		&& ! tc-is-cross-compiler \
		&& is_clang_ready \
	; then
einfo "Using Clang ${llvm_slot}"
		if ! ot-kernel_has_version "sys-devel/llvm:${llvm_slot}" ; then
eerror "sys-devel/llvm:${llvm_slot} is missing"
			die
		fi
		ot-kernel_y_configopt "CONFIG_AS_IS_LLVM"
		ot-kernel_set_configopt "CONFIG_AS_VERSION" "${llvm_slot}0000"
		ot-kernel_y_configopt "CONFIG_CC_IS_CLANG"
		ot-kernel_set_configopt "CONFIG_CC_VERSION_TEXT" "\"clang version ${llvm_slot}.0.0\""
		ot-kernel_set_configopt "CONFIG_GCC_VERSION" "0"
		ot-kernel_set_configopt "CONFIG_CLANG_VERSION" "${llvm_slot}0000"
		ot-kernel_y_configopt "CONFIG_LD_IS_LLD"
		ot-kernel_set_configopt "CONFIG_LD_VERSION" "0"
		ot-kernel_set_configopt "CONFIG_LLD_VERSION" "${llvm_slot}0000"
	else
		is_gcc_ready || ot-kernel_compiler_not_found "Failed compiler sanity check for gcc"
einfo "Using GCC ${gcc_slot}"
		ot-kernel_unset_configopt "CONFIG_AS_IS_LLVM"
		ot-kernel_unset_configopt "CONFIG_CC_IS_CLANG"
		ot-kernel_unset_configopt "CONFIG_LD_IS_LLD"
		local gcc_pv=$(gcc --version \
			| head -n 1 \
			| grep -o -E -e " [0-9]+.[0-9]+.[0-9]+" \
			| head -n 1 \
			| sed -e "s|[ ]*||g")
		local gcc_pv_major=$(printf "%02d" $(echo ${gcc_pv} | cut -f 1 -d "."))
		local gcc_pv_minor=$(printf "%02d" $(echo ${gcc_pv} | cut -f 2 -d "."))
		ot-kernel_set_configopt "CONFIG_GCC_VERSION" "${gcc_pv_major}${gcc_pv_minor}00"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_compressors
# @DESCRIPTION:
# Sets the kernel config for compressor related options specifically initramfs
# decompression, module (de)compression, verification of readiness, applying
# architecture optimizations
ot-kernel_set_kconfig_compressors() {
	# The default profile sets this to none by default.
	local ot_kernel_modules_compressor="${OT_KERNEL_MODULES_COMPRESSOR}"
	if [[ -n "${ot_kernel_modules_compressor}" ]] ; then
		local alg
		local mod_comp_algs=(
			NONE
			GZIP
			XZ
			ZSTD
		)
		for alg in ${mod_comp_algs[@]} ; do
			ot-kernel_n_configopt "CONFIG_MODULE_COMPRESS_${alg}" # Reset
		done
		if ver_test ${KV_MAJOR_MINOR} -le 5.10 ; then
			if [[ "${ot_kernel_modules_compressor^^}" == "ZSTD" ]] ; then
eerror "ZSTD is not supported for ${KV_MAJOR_MINOR} in OT_KERNEL_MODULES_COMPRESSOR."
				die
			fi
einfo "Changing config to compress modules with ${ot_kernel_modules_compressor}"
			if [[ "${ot_kernel_modules_compressor^^}" == "NONE" ]] ; then
				ot-kernel_n_configopt "CONFIG_MODULE_COMPRESS"
			else
				ot-kernel_y_configopt "CONFIG_MODULE_COMPRESS"
				ot-kernel_y_configopt "CONFIG_MODULE_COMPRESS_${ot_kernel_modules_compressor^^}" # Reset
			fi
		else
einfo "Changing config to compress modules with ${ot_kernel_modules_compressor}"
			ot-kernel_y_configopt "CONFIG_MODULE_COMPRESS_${ot_kernel_modules_compressor^^}" # Reset
		fi
	else
einfo "Using manual setting for compressed modules"
	fi

	local decompressors=(
		BZIP2
		GZIP
		LZ4
		LZMA
		LZ4
		LZO
		UNCOMPRESSED
		XZ
		ZSTD
	)
	if ver_test ${KV_MAJOR_MINOR} -lt 5.10 && [[ "${boot_decomp^^}" == "ZSTD" ]] ; then
eerror "ZSTD is only supported in 5.10+"
		die
	fi
	local d
	for d in ${decompressors[@]} ; do
		# Reset settings
		d="${d^^}"
		ot-kernel_n_configopt "CONFIG_KERNEL_${d}"
		if [[ "${d}" != "UNCOMPRESSED" ]] ; then
			ot-kernel_n_configopt "CONFIG_RD_${d}"
			# If another module needs a compressor, it really should
			# not be disabled.
			ot-kernel_n_configopt "CONFIG_DECOMPRESS_${d}"
			if [[ "${d}" =~ ("LZ4"|"ZSTD") ]] ; then
				:
			#elif [[ "${d}" =~ ("XZ") ]] ; then
			#	# Used by multiple drivers.
			#	ot-kernel_n_configopt "CONFIG_XZ_DEC"
			elif [[ "${d}" =~ ("GZIP") ]] ; then
			#	# Used by multiple drivers.
				ot-kernel_n_configopt "CONFIG_DECOMPRESS_GZIP"
			#	ot-kernel_n_configopt "CONFIG_ZLIB_INFLATE"
			fi
		fi
	done
	if [[ "${boot_decomp}" == "default" ]] ; then
ewarn "Using the default boot decompressor settings"
		ot-kernel_y_configopt "CONFIG_KERNEL_GZIP"
		for d in ${decompressors[@]} ; do
			if [[ "${d}" != "UNCOMPRESSED" ]] ; then
				ot-kernel_y_configopt "CONFIG_RD_${d}"
				ot-kernel_y_configopt "CONFIG_DECOMPRESS_${d}"
				if [[ "${d}" =~ ("LZ4"|"ZSTD") ]] ; then
					:
				elif [[ "${d}" =~ ("XZ") ]] ; then
					ot-kernel_y_configopt "CONFIG_XZ_DEC"
					ot-kernel_y_configopt "CONFIG_CRC32"
					ot-kernel_y_configopt "CONFIG_BITREVERSE"
				elif [[ "${d}" =~ ("GZIP") ]] ; then
					ot-kernel_y_configopt "CONFIG_ZLIB_INFLATE"
				fi
			fi
		done
	elif [[ "${boot_decomp}" == "manual" ]] ; then
einfo "Using the manually chosen boot decompressor settings"
	else
einfo "Using the ${boot_decomp} boot decompressor settings"
		d="${boot_decomp^^}"
		ot-kernel_y_configopt "CONFIG_KERNEL_${d}"
		if [[ "${d}" != "UNCOMPRESSED" ]] ; then
			ot-kernel_y_configopt "CONFIG_RD_${d}"
			ot-kernel_y_configopt "CONFIG_DECOMPRESS_${d}"
			if [[ "${d}" =~ ("LZ4"|"ZSTD") ]] ; then
				:
			elif [[ "${d}" =~ ("XZ") ]] ; then
				ot-kernel_y_configopt "CONFIG_XZ_DEC"
				ot-kernel_y_configopt "CONFIG_CRC32"
				ot-kernel_y_configopt "CONFIG_BITREVERSE"
			elif [[ "${d}" =~ ("GZIP") ]] ; then
				ot-kernel_y_configopt "CONFIG_ZLIB_INFLATE"
			fi
		fi
	fi

	local XZ_DECS=(
		ARM
		ARMTHUMB
		IA64
		POWERPC
		SPARC
		X86
	)

	local x
	for x in ${XZ_DECS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_XZ_DEC_${x}"
	done

	# The BCJ filters improves compression ratios.
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] && grep -q -E -e "^CONFIG_XZ_DEC=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_X86"
	fi

	if [[ "${arch}" == "powerpc" ]] && grep -q -E -e "^CONFIG_XZ_DEC=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_POWERPC"
	fi

	if [[ "${arch}" == "arm" || "${arch}" == "arm64" ]] && grep -q -E -e "^CONFIG_XZ_DEC=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_ARM"
	fi

	if [[ "${arch}" == "arm" ]] && ot-kernel_use cpu_flags_arm_thumb ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_ARMTHUMB"
	fi

	if [[ "${arch}" == "sparc" || "${arch}" == "sparc32" || "${arch}" == "sparc64" ]] && grep -q -E -e "^CONFIG_XZ_DEC=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_SPARC"
	fi

	if [[ "${arch}" == "ia64" ]] && grep -q -E -e "^CONFIG_XZ_DEC=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XZ_DEC_IA64"
	fi

	if grep -q -E -e "^CONFIG_MODULE_COMPRESS_GZIP=y" "${path_config}" ; then
		use gzip || die "Enable the gzip USE flag"
	fi
	if grep -q -E -e "^CONFIG_MODULE_COMPRESS_XZ=y" "${path_config}" ; then
		use xz || die "Enable the xz USE flag"
	fi
	if grep -q -E -e "^CONFIG_MODULE_COMPRESS_ZSTD=y" "${path_config}" ; then
		use zstd || die "Enable the zstd USE flag"
	fi

	if grep -q -E -e "^CONFIG_RD_BZIP2=y" "${path_config}" ; then
		use bzip2 || die "Enable the bzip2 USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_LZ4=y" "${path_config}" ; then
		use lz4 || die "Enable the lz4 USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_LZMA=y" "${path_config}" ; then
		use lzma || die "Enable the lzma USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_LZO=y" "${path_config}" ; then
		use lzo || die "Enable the lzo USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_GZIP=y" "${path_config}" ; then
		use gzip || die "Enable the gzip USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_ZSTD=y" "${path_config}" ; then
		use zstd || die "Enable the zstd USE flag"
	fi
	if grep -q -E -e "^CONFIG_RD_XZ=y" "${path_config}" ; then
		use xz || die "Enable the xz USE flag"
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_muqss
# @DESCRIPTION:
# Set muqss kernel config flags
_ot-kernel_set_kconfig_muqss() {
	if has muqss ${IUSE_EFFECTIVE} && ot-kernel_use muqss ; then
		:
	else
		return
	fi

	if [[ \
		   "${arch}" == "alpha" \
		|| "${arch}" == "arm" \
		|| "${arch}" == "arm64" \
		|| "${arch}" == "powerpc" \
		|| "${arch}" == "x86" \
		|| "${arch}" == "x86_64" \
	]] ; then
		:
	else
eerror
eerror "MuQSS is not supported on ARCH=${arch}.  Remove muqss from"
eerror "OT_KERNEL_USE."
eerror
		die
	fi

	# Drop references to dl_bw_free, dl_bw_alloc from kernel/sched/deadline.c
	ot-kernel_unset_configopt "CONFIG_CPUSETS"
	ot-kernel_unset_configopt "CONFIG_PROC_PID_CPUSET"

einfo "Changed .config to use MuQSS"
	ot-kernel_y_configopt "CONFIG_SCHED_MUQSS"
	cpu_sched_config_applied=1

	ot-kernel_unset_pat_kconfig_kernel_cmdline "rqshare=(none|smt|mc|llc|smp|all)"

	_set_muqss_mc() {
		ot-kernel_unset_configopt "CONFIG_RQ_NONE"
		ot-kernel_unset_configopt "CONFIG_RQ_SMT"
		ot-kernel_y_configopt "CONFIG_RQ_MC"
		ot-kernel_unset_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_unset_configopt "CONFIG_RQ_SMP"
		ot-kernel_unset_configopt "CONFIG_RQ_ALL"
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=none"
	}
	_set_muqss_mc_llc() {
		ot-kernel_unset_configopt "CONFIG_RQ_NONE"
		ot-kernel_unset_configopt "CONFIG_RQ_SMT"
		ot-kernel_unset_configopt "CONFIG_RQ_MC"
		ot-kernel_y_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_unset_configopt "CONFIG_RQ_SMP"
		ot-kernel_unset_configopt "CONFIG_RQ_ALL"
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=llc"
	}
	_set_muqss_none() {
		ot-kernel_y_configopt "CONFIG_RQ_NONE"
		ot-kernel_unset_configopt "CONFIG_RQ_SMT"
		ot-kernel_unset_configopt "CONFIG_RQ_MC"
		ot-kernel_unset_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_unset_configopt "CONFIG_RQ_SMP"
		ot-kernel_unset_configopt "CONFIG_RQ_ALL"
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=none"
	}
	_set_muqss_numa() {
		ot-kernel_unset_configopt "CONFIG_RQ_NONE"
		ot-kernel_unset_configopt "CONFIG_RQ_SMT"
		ot-kernel_unset_configopt "CONFIG_RQ_MC"
		ot-kernel_unset_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_unset_configopt "CONFIG_RQ_SMP"
		ot-kernel_y_configopt "CONFIG_RQ_ALL" # 1 runqueue period
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=all"
	}
	_set_muqss_smp() {
		ot-kernel_unset_configopt "CONFIG_RQ_NONE"
		ot-kernel_unset_configopt "CONFIG_RQ_SMT"
		ot-kernel_unset_configopt "CONFIG_RQ_MC"
		ot-kernel_unset_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_y_configopt "CONFIG_RQ_SMP"
		ot-kernel_unset_configopt "CONFIG_RQ_ALL"
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=smp"
	}
	_set_muqss_smt() {
		ot-kernel_unset_configopt "CONFIG_RQ_NONE"
		ot-kernel_y_configopt "CONFIG_RQ_SMT"
		ot-kernel_unset_configopt "CONFIG_RQ_MC"
		ot-kernel_unset_configopt "CONFIG_RQ_MC_LLC"
		ot-kernel_unset_configopt "CONFIG_RQ_SMP"
		ot-kernel_unset_configopt "CONFIG_RQ_ALL"
		ot-kernel_set_kconfig_kernel_cmdline "rqshare=smt"
	}

	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	local processor_class="${OT_KERNEL_PROCESSOR_CLASS,,}"

	local multicore=0
	local multicore_with_level3_cache=0
	local ncpus=1
	local nnuma=0
	local smp=0
	local smt=0
	local tpc=1

	if ! tc-is-cross-compiler ; then
		ncpus=$(lscpu \
			| grep "CPU(s)" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
		(( ${ncpus} > 0 )) && smp=1

		nnuma=$(lscpu \
			| grep "NUMA node(s)" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
		[[ -z "${nnuma}" ]] && nnuma=0

		tpc=$(lscpu \
			| grep  -e "Thread(s) per core:.*" \
			| head -n 1 \
			| grep -E -o "[0-9]+")
		(( ${tpc} > 1 )) && smt=1


		local ncores=$(cat /proc/cpuinfo \
			| grep "cpu cores" \
			| grep -E -o "[0-9]+" \
			| head -n 1)
		(( ${ncores} > 1 )) && multicore=1

		if \
			lscpu | grep -q -E "L3.*[0-9]+" \
				&&
			(( ${multicore} == 1 )) \
		; then
			multicore_with_level3_cache=1
		fi
	fi

	if [[ \
		   "${work_profile}" == "realtime-hpc" \
	]] ; then
	# Low latency
		_set_muqss_numa
	elif [[ \
		   "${work_profile}" == "gamedev" \
		|| "${work_profile}" == "hpc" \
		|| "${work_profile}" == "throughput-hpc" \
		|| "${work_profile}" == "workstation" \
	]] ; then
	# Throughput
		_set_muqss_none
	elif [[ \
		   "${work_profile}" == "digital-audio-workstation" \
		|| "${work_profile}" == "musical-live-performance" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
	# Low latency
		if [[ \
			   "${hardening_level}" == "fast" \
			|| "${hardening_level}" == "fast-af" \
			|| "${hardening_level}" == "fast-as-fuck" \
			|| "${hardening_level}" == "performance" \
		]] ; then
			if \
				[[ \
					   "${smt}" == "1" \
					|| "${processor_class}" == "multicore-smt" \
				]] \
			; then
				_set_muqss_smt
			elif \
				[[ \
					   "${multicore}" == "1" \
					|| "${processor_class}" =~ "multicore" \
				]] \
			; then
				_set_muqss_mc
			elif \
				[[ \
					   "${processor_class}" =~ "smp" \
					|| "${smp}" == "1" \
				]] \
			; then
				_set_muqss_smp
			else
				_set_muqss_none
			fi
		elif \
			[[ \
				"${multicore_with_level3_cache}" == "1" \
			]] \
		; then
	# The documentation is kind of cryptic.
			_set_muqss_mc_llc
		elif \
			[[ \
				   "${multicore}" == "1" \
				|| "${processor_class}" =~ "multicore" \
			]] \
		; then
			_set_muqss_mc
		elif \
			[[ \
				   "${processor_class}" =~ "smp" \
				|| "${smp}" == "1" \
			]] \
		; then
			_set_muqss_smp
		else
			_set_muqss_none
		fi
	else
		if [[ "${cpu_sched}" == "muqss" || "${cpu_sched}" == "muqss-latency" ]] ; then
			if \
				[[ \
					   "${nnuma}" -gt "1" \
					|| "${processor_class}" =~ "numa" \
				]] \
			; then
				_set_muqss_numa
			elif \
				[[ \
					( \
						   "${hardening_level}" == "fast" \
						|| "${hardening_level}" == "fast-af" \
						|| "${hardening_level}" == "fast-as-fuck" \
						|| "${hardening_level}" == "performance" \
					) \
						&& \
					( \
						   "${processor_class}" == "multicore-smt" \
						|| "${smt}" == "1" \
					) \
				]] \
			; then
				_set_muqss_smt
			elif \
				[[ \
					   "${multicore_with_level3_cache}" == "1" \
				]] \
			; then
				_set_muqss_mc_llc
			elif \
				[[ \
					   "${multicore}" == "1" \
					|| "${processor_class}" =~ "multicore" \
				]] \
			; then
				_set_muqss_mc
			elif \
				[[ \
					   "${processor_class}" =~ "smp" \
					|| "${smp}" == "1" \
				]] \
			; then
				_set_muqss_smp
			else
				_set_muqss_none
			fi
		else
			_set_muqss_none
		fi
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_prjc
# @DESCRIPTION:
# Set prjc kernel config flags
_ot-kernel_set_kconfig_prjc() {
	if has prjc ${IUSE_EFFECTIVE} && ot-kernel_use prjc ; then
		:
	else
		return
	fi

	if [[ \
		   "${cpu_sched}" == "prjc" \
		|| "${cpu_sched}" == "prjc-bmq" \
	]] ; then
einfo "Changed .config to use Project C with BMQ"
		ot-kernel_y_configopt "CONFIG_SCHED_ALT"
		ot-kernel_y_configopt "CONFIG_SCHED_BMQ"
		ot-kernel_unset_configopt "CONFIG_SCHED_PDS"
		cpu_sched_config_applied=1
ewarn
ewarn "Changed .config to disable SCHED_CORE on Project C (unsupported by project)"
ewarn "Lowers security in SMT/HT"
ewarn
		ot-kernel_unset_configopt "CONFIG_SCHED_CORE"
	elif [[ "${cpu_sched}" == "prjc-pds" ]] ; then
einfo "Changed .config to use Project C with PDS"
		ot-kernel_y_configopt "CONFIG_SCHED_ALT"
		ot-kernel_unset_configopt "CONFIG_SCHED_BMQ"
		ot-kernel_y_configopt "CONFIG_SCHED_PDS"
		cpu_sched_config_applied=1
ewarn
ewarn "Changed .config to disable SCHED_CORE on Project C (unsupported by project)"
ewarn "Lowers security in SMT/HT"
ewarn
		ot-kernel_unset_configopt "CONFIG_SCHED_CORE"
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_bmq
# @DESCRIPTION:
# Set bmq kernel config flags
_ot-kernel_set_kconfig_bmq() {
	if \
		has bmq ${IUSE_EFFECTIVE} && ot-kernel_use bmq \
			&& \
		[[ "${cpu_sched}" == "bmq" ]] \
	; then
einfo "Changed .config to use BMQ"
		ot-kernel_y_configopt "CONFIG_SCHED_BMQ"
		cpu_sched_config_applied=1
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_pds
# @DESCRIPTION:
# Set pds kernel config flags
_ot-kernel_set_kconfig_pds() {
	if \
		has pds ${IUSE_EFFECTIVE} && ot-kernel_use pds \
			&& \
		[[ "${cpu_sched}" == "pds" ]] \
	; then
einfo "Changed .config to use PDS"
		ot-kernel_y_configopt "CONFIG_SCHED_PDS"
		cpu_sched_config_applied=1
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_cfs
# @DESCRIPTION:
# Set cfs kernel config flags
_ot-kernel_set_kconfig_cfs() {
	if has cfs ${IUSE_EFFECTIVE} && ot-kernel_use cfs ; then
		:
	else
		return
	fi

	if [[ \
		   "${cpu_sched}" == "cfs-throughput" \
		|| "${cpu_sched}" == "cfs-interactive" \
		|| "${cpu_sched}" == "cfs-autogroup" \
	]] ; then
		ot-kernel_unset_configopt "CONFIG_SCHED_ALT"
		ot-kernel_unset_configopt "CONFIG_SCHED_BMQ"
		ot-kernel_unset_configopt "CONFIG_SCHED_PDS"
		ot-kernel_unset_configopt "CONFIG_SCHED_MUQSS"
	fi

	if [[ \
		   "${cpu_sched}" == "cfs-autogroup" \
		|| "${cpu_sched}" == "cfs-interactive" \
	]] ; then
einfo "Changed .config to use CFS with autogroup"
		ot-kernel_y_configopt "CONFIG_SCHED_AUTOGROUP"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_FAIR_GROUP_SCHED"
		cpu_sched_config_applied=1
	elif [[ "${cpu_sched}" == "cfs-throughput" ]] ; then
einfo "Changed .config to use CFS without autogroup"
		ot-kernel_unset_configopt "CONFIG_SCHED_AUTOGROUP"
		cpu_sched_config_applied=1
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_cpu_scheduler_post
# @DESCRIPTION:
# Unbreak build for incompatible flags
ot-kernel_set_kconfig_cpu_scheduler_post() {
	if [[ "${cpu_sched}" =~ "muqss" ]] ; then
		if grep -q -E -e "^CONFIG_CPUSETS=y" "${path_config}" ; then
ewarn "Dropping CONFIG_CPUSETS for muqss.  If you do not like this, switch to change to cfs or other scheduler."
			# Drop references to dl_bw_free, dl_bw_alloc from kernel/sched/deadline.c
			ot-kernel_unset_configopt "CONFIG_CPUSETS"
		fi
		if grep -q -E -e "^CONFIG_PROC_PID_CPUSET=y" "${path_config}" ; then
ewarn "Dropping CONFIG_PROC_PID_CPUSET for muqss.  If you do not like this, switch to change to cfs or other scheduler."
			ot-kernel_unset_configopt "CONFIG_PROC_PID_CPUSET"
		fi
	fi
	if [[ "${cpu_sched}" == "nest" ]] ; then
# Based on the graphs, schedutil has 6 highest bars versus performance with 3
# highest bars.  Both are provided for flexiblity during runtime.  The best
# choice between schedutil and performance depends on the application,  but it
# is marginal.
		local freq_gov="${OT_KERNEL_NEST_FREQ_GOV:-schedutil}"
		if [[ "${freq_gov}" == "schedutil" ]] ; then
einfo "Optimizing Nest with OT_KERNEL_NEST_FREQ_GOV=schedutil"
			ot-kernel_y_configopt "CONFIG_SMP"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		else
einfo "Optimizing Nest with OT_KERNEL_NEST_FREQ_GOV=performance"
			ot-kernel_y_configopt "CONFIG_SMP"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		fi
	fi
}

# @FUNCTION: _ot-kernel_set_kconfig_nest
# @DESCRIPTION:
# Set CPU scheduler to Nest for low latency
_ot-kernel_set_kconfig_nest() {
	[[ "${cpu_sched}" =~ "nest" ]] || return
	if ! grep -q -E -e "^CONFIG_SMP=y" "${path_config}" ; then
eerror
eerror "Problem:"
eerror
eerror "  Nest requires SMP."
eerror
eerror
eerror "Solutions:"
eerror
eerror "  Remove nest from OT_KERNEL_USE and OT_KERNEL_CPU_SCHED."
eerror
eerror "    or"
eerror
eerror "  Pick another CPU scheduler."
eerror
		die
	fi
	if ! grep -q -E -e "^CONFIG_SCHED_MC=y" "${path_config}" ; then
eerror
eerror "Problem:"
eerror
eerror "  Nest requires SCHED_MC."
eerror
eerror
eerror "Solutions:"
eerror
eerror "  Remove nest from OT_KERNEL_USE and OT_KERNEL_CPU_SCHED."
eerror
eerror "    or"
eerror
eerror "  Pick another CPU scheduler."
eerror
		die
	fi

	ot-kernel_unset_configopt "CONFIG_SCHED_ALT"
	ot-kernel_unset_configopt "CONFIG_SCHED_BMQ"
	ot-kernel_unset_configopt "CONFIG_SCHED_PDS"
	ot-kernel_unset_configopt "CONFIG_SCHED_MUQSS"
# Same as grid5000_config.patch
einfo "Changed .config to use NEST with autogroup"
	ot-kernel_y_configopt "CONFIG_SCHED_AUTOGROUP"
	ot-kernel_y_configopt "CONFIG_CGROUPS"
	ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
	ot-kernel_y_configopt "CONFIG_FAIR_GROUP_SCHED"
	cpu_sched_config_applied=1
}

# @FUNCTION: ot-kernel_set_kconfig_cpu_scheduler
# @DESCRIPTION:
# Sets the CPU scheduler kernel config
ot-kernel_set_kconfig_cpu_scheduler() {
	local cpu_sched_config_applied=0

	_ot-kernel_set_kconfig_bmq
	_ot-kernel_set_kconfig_cfs
	_ot-kernel_set_kconfig_muqss
	_ot-kernel_set_kconfig_nest
	_ot-kernel_set_kconfig_pds
	_ot-kernel_set_kconfig_prjc

	if [[ "${cpu_sched}" =~ ("muqss"|"prjc"|"bmq"|"pds") ]] ; then
einfo "Changed .config to disable autogroup"
		ot-kernel_unset_configopt "CONFIG_SCHED_AUTOGROUP"
	fi

	if (( ${cpu_sched_config_applied} == 0 )) \
		&& ! [[ "${cpu_sched}" =~ "cfs" ]] ; then
ewarn
ewarn "The chosen cpu_sched ${cpu_sched} config was not applied"
ewarn "because the use flag was not enabled."
ewarn
	fi

	if [[ "${cpu_sched}" == "cfs" ]] || (( ${cpu_sched_config_applied} == 0 )) ; then
einfo "Changed .config to use CFS (Completely Fair Scheduler)"
		ot-kernel_unset_configopt "CONFIG_SCHED_ALT"
		ot-kernel_unset_configopt "CONFIG_SCHED_BMQ"
		ot-kernel_unset_configopt "CONFIG_SCHED_MUQSS"
		ot-kernel_unset_configopt "CONFIG_SCHED_PDS"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_dmesg
# @DESCRIPTION:
# Shows or hides early printk or dmesg
_OT_KERNEL_PRINK_DISABLED=0
ot-kernel_set_kconfig_dmesg() {
	local dmesg
	local override="${1}"
	if [[ -n "${override}" ]] ; then
		dmesg="${override}"
	else
		dmesg="${OT_KERNEL_DMESG:-0}"
	fi
	ot-kernel_y_configopt "CONFIG_EXPERT"
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		ot-kernel_unset_configopt "CONFIG_EARLY_PRINTK"
		ot-kernel_unset_configopt "CONFIG_X86_VERBOSE_BOOTUP"
	fi
	if [[ "${dmesg}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_PRINTK"
#		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
#			ot-kernel_y_configopt "CONFIG_EARLY_PRINTK"
#		fi
	elif [[ "${dmesg}" == "0" ]] ; then
		ot-kernel_unset_configopt "CONFIG_PRINTK"
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			ot-kernel_unset_configopt "CONFIG_EARLY_PRINTK"
			ot-kernel_unset_configopt "CONFIG_X86_VERBOSE_BOOTUP"
		fi
		_OT_KERNEL_PRINK_DISABLED=1
	elif [[ "${dmesg}" == "default" ]] ; then
		ot-kernel_y_configopt "CONFIG_PRINTK"
#		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
#			ot-kernel_y_configopt "CONFIG_EARLY_PRINTK"
#		fi
		# See https://www.kernel.org/doc/html/latest/core-api/printk-basics.html
		ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_DEFAULT" "7" # Excludes >= pr_info
		ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_QUIET" "4"
		ot-kernel_set_configopt "CONFIG_MESSAGE_LOGLEVEL_DEFAULT" "4"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_ep800
# @DESCRIPTION:
# Sets the kernel config for the ep800 driver
ot-kernel_set_kconfig_ep800() {
	[[ -e "${BUILD_DIR}/drivers/media/usb/gspca/ep800.c" ]] || return
	if [[ "${CAMERAS,,}" =~ "ep800" ]] ; then
		# Added driver to test driver across all LTS versions
einfo "Enabled the ep800 driver"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_EP800"
	else
		ot-kernel_unset_configopt "CONFIG_USB_GSPCA_EP800"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_exfat
# @DESCRIPTION:
# Sets the kernel config for the exFAT driver
ot-kernel_set_kconfig_exfat() {
	if has exfat ${IUSE_EFFECTIVE} && ot-kernel_use exfat ; then
		ot-kernel_y_configopt "CONFIG_EXFAT_FS"
	else
		ot-kernel_unset_configopt "CONFIG_EXFAT_FS"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_l1tf_mitigations
# @DESCRIPTION:
# Set or remove the l1tf mitigation.
ot-kernel_set_kconfig_l1tf_mitigations() {
	local mode="${1}" # 1=enable, 0=disable
	[[ $(ot-kernel_get_cpu_mfg_id) != "intel" ]] && return
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		local family
		if tc-is-cross-compiler ; then
			family=6
		else
			family=$(cat /proc/cpuinfo \
				| grep "cpu family" \
				| grep -Eo "[0-9]+" \
				| head -n 1)
		fi
		if (( ${family} != 6 )) ; then
			ot-kernel_unset_pat_kconfig_kernel_cmdline "l1tf=off"
			return
		fi

		if [[ "${mode}" == "1" ]] ; then
	# SMT off, full hypervisor mitigation
			ot-kernel_unset_pat_kconfig_kernel_cmdline "l1tf=full,force"
		elif [[ "${mode}" == "0.5" ]] ; then
	# SMT on, default hypervisor mitigation
			ot-kernel_unset_pat_kconfig_kernel_cmdline "l1tf=flush"
		else
	# SMT on, no mitigation
			ot-kernel_unset_pat_kconfig_kernel_cmdline "l1tf=off"
		fi
	# Upstream uses SMT on, partial hypervisor mitigation.
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_hardening_level
# @DESCRIPTION:
# Sets the kernel config related to kernel hardening
ot-kernel_set_kconfig_hardening_level() {
	_ot-kernel_validate_hardening_level
einfo "Using ${hardening_level} hardening level"
	ot-kernel_y_configopt "CONFIG_EXPERT"

	local gcc_pv_major
	local gcc_pv_minor
	local clang_major_v
	local clang_minor_v
	if tc-is-gcc ; then
		local gcc_pv=$(gcc --version \
			| head -n 1 \
			| grep -o -E -e " [0-9]+.[0-9]+.[0-9]+" \
			| head -n 1 \
			| sed -e "s|[ ]*||g")
		gcc_pv_major=$(printf "%02d" $(echo ${gcc_pv} | cut -f 1 -d "."))
		gcc_pv_minor=$(printf "%02d" $(echo ${gcc_pv} | cut -f 2 -d "."))
	fi
	if tc-is-clang ; then
		local clang_pv=$(clang-${llvm_slot} --version | head -n 1 | cut -f 3 -d " ")
		clang_major_v=$(echo "${clang_pv}" | cut -f 1 -d ".")
		clang_minor_v=$(echo "${clang_pv}" | cut -f 2 -d ".")
	fi

	if [[ \
		   "${hardening_level}" == "custom" \
		|| "${hardening_level}" == "manual" \
	]] ; then
		:
	else
		ot-kernel_unset_pat_kconfig_kernel_cmdline "mitigations=(off|auto|auto,nosmt)" # no mitigations=full?
		ot-kernel_unset_pat_kconfig_kernel_cmdline "gather_data_sampling=(force|off)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "kpti=(1|0)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm-intel.vmentry_l1d_flush=(always|cond|never)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm.nx_huge_pages=(force|off|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "l1d_flush=on"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "l1tf=(full|full,force|flush|flush,nosmt|flush,nowarn|off)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "no_entry_flush"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "no_uaccess_flush"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "mds=(full|full,nosmt|off)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "mmio_stale_data=(full|full,nosmt|off)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nobp=(0|1)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nosmt=force"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nosmt"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nopti"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nospec_store_bypass_disable" # Same as spec_store_bypass_disable=off
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nospectre_bhb"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nospectre_v1"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nospectre_v2"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "pti=(on|off|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "reg_file_data_sampling=(on|off)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "retbleed=(off|auto|auto,nosmt|ibpb|ibpb,nosmt|unret|unret,nosmt)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "retbleed=(off|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "smt=(-1|[0-9]+)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "srbds=off"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "spec_store_bypass_disable=(on|off|auto|prctl|seccomp)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "spectre_v2=(on|off|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "spectre_v2=(retpoline|retpoline,generic|retpoline,lfence|retpoline,amd|eibrs|eibrs,retpoline|eibrs,lfence|ibrs)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "spectre_v2_user=(on|off|prctl|prctl,ibpb|seccomp|seccomp,ibpb|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "ssbd=(force-on|force-off|kernel)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "tsx=(on|off|auto)"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "tsx_async_abort=(full|full,nosmt|off)"
	# For setters, it is stated twice for CONFIG_CMDLINE_FORCE=y.
	fi

	_y_retpoline() {
		ot-kernel_y_configopt "CONFIG_RETPOLINE"
		local ready=0
		if tc-is-gcc && ver_test $(gcc-version) -ge 8.1 ; then
			ready=1
		elif tc-is-clang && ver_test $(clang-version) -ge 7 ; then
			ready=1
		fi
		if (( ${ready} == 0 )) ; then
			local gcc_version=$(gcc-version)
			local clang_version=$(clang-version)
eerror
eerror "Switch to >=gcc-8.1 or >=clang-7 for retpoline support"
eerror
eerror "Actual GCC version:  ${gcc_version}"
eerror "Actual Clang version:  ${clang_version}"
eerror
			die
		fi
	}

	_y_ibt() {
		ot-kernel_y_configopt "CONFIG_X86_KERNEL_IBT"
		local ready=0
		if tc-is-gcc && ver_test $(gcc-version) -ge 9 && ot-kernel_has_version ">=sys-devel/binutils-2.29" ; then
			ready=1
		elif tc-is-clang && ver_test $(clang-version) -ge 14 ; then
			ready=1
		fi
		if (( ${ready} == 0 )) ; then
			local gcc_version=$(gcc-version)
			local clang_version=$(clang-version)
eerror
eerror "Switch to >=gcc-9 with >=binutils-2.2.9, or >=clang-14 for IBT support"
eerror
eerror "Actual GCC version:  ${gcc_version}"
eerror "Actual Clang version:  ${clang_version}"
eerror
			die
		fi
	}


	if [[ \
		   "${hardening_level}" == "custom" \
		|| "${hardening_level}" == "manual" \
	]] ; then
		:
	elif [[ \
		   "${hardening_level}" == "fast" \
		|| "${hardening_level}" == "fast-af" \
		|| "${hardening_level}" == "fast-as-fuck" \
		|| "${hardening_level}" == "performance" \
	]] ; then
	# Disable all hardening
	# All randomization is disabled because it increases instruction latency
	# or adds more noise to the pipeline.
	# CFI and SCS handled later
		ot-kernel_y_configopt "CONFIG_COMPAT_BRK"
		ot-kernel_unset_configopt "CONFIG_FORTIFY_SOURCE"
		ot-kernel_unset_configopt "CONFIG_GENTOO_KERNEL_SELF_PROTECTION" # Disabled for customization
		ot-kernel_unset_configopt "CONFIG_HARDENED_USERCOPY"
		ot-kernel_unset_configopt "CONFIG_INIT_ON_ALLOC_DEFAULT_ON"
		ot-kernel_unset_configopt "CONFIG_INIT_ON_FREE_DEFAULT_ON"

		ot-kernel_unset_configopt "CONFIG_GCC_PLUGINS"

		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.9 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
		fi

		if ver_test ${KV_MAJOR_MINOR} -ge 5.19 ; then
			ot-kernel_y_configopt "CONFIG_RANDSTRUCT_NONE"
			ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_FULL"
			ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_PERFORMANCE"
			if [[ "${arch}" == "x86" ]] && grep -q -E -e "^CONFIG_X86_PAE=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			elif [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_unset_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_unset_configopt "CONFIG_MODIFY_LDT_SYSCALL"
		ot-kernel_unset_configopt "CONFIG_RELOCATABLE"
		ot-kernel_unset_configopt "CONFIG_RANDOMIZE_BASE"
		ot-kernel_unset_configopt "CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT"
		if [[ "${arch}" == "s390" ]] ; then
			ot-kernel_unset_configopt "CONFIG_EXPOLINE"
			ot-kernel_y_configopt "CONFIG_EXPOLINE_OFF"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_AUTO"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_ON"
		elif [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
			ot-kernel_unset_configopt "CONFIG_RANDOMIZE_MEMORY"
			ot-kernel_unset_configopt "CONFIG_RETPOLINE"
		fi
		ot-kernel_y_configopt "CONFIG_SHUFFLE_PAGE_ALLOCATOR"
		ot-kernel_unset_configopt "CONFIG_SLAB_FREELIST_HARDENED"
		ot-kernel_unset_configopt "CONFIG_SLAB_FREELIST_RANDOM"
		ot-kernel_y_configopt "CONFIG_SLAB_MERGE_DEFAULT"
		ot-kernel_unset_configopt "CONFIG_STACKPROTECTOR"
		ot-kernel_unset_configopt "CONFIG_STACKPROTECTOR_STRONG"
		if tc-is-gcc ; then
			ot-kernel_unset_configopt "CONFIG_ZERO_CALL_USED_REGS"
		fi
		ot-kernel_unset_configopt "CONFIG_SCHED_CORE"
		if ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "arm64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "kpti=0"
				ot-kernel_set_kconfig_kernel_cmdline "nospectre_v2"
				ot-kernel_set_kconfig_kernel_cmdline "ssbd=force-off"
			fi

			if [[ "${arch}" == "powerpc" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nopti"
				if grep -q -E -e "^CONFIG_PPC_E500=y" "${path_config}" ; then # >= 6.2
					ot-kernel_set_kconfig_kernel_cmdline "nospectre_v1"
				elif grep -q -E -e "^CONFIG_PPC_FSL_BOOK3E=y" "${path_config}" ; then # < 6.1
					ot-kernel_set_kconfig_kernel_cmdline "nospectre_v1"
				fi
				ot-kernel_set_kconfig_kernel_cmdline "nospectre_v2"
				ot-kernel_set_kconfig_kernel_cmdline "no_entry_flush"
				ot-kernel_set_kconfig_kernel_cmdline "no_uaccess_flush"
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=off" # Based on mitigations=off documentation
			fi

			if [[ "${arch}" == "s390" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nospectre_v2"
				ot-kernel_unset_configopt "CONFIG_KERNEL_NOBP"
				ot-kernel_set_kconfig_kernel_cmdline "nobp=0"
			fi

			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nospectre_v1"
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=off" # Based on mitigations=off documentation
				ot-kernel_set_kconfig_kernel_cmdline "spectre_v2_user=off"
				if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
					ot-kernel_set_kconfig_kernel_cmdline "kvm.nx_huge_pages=off"
				fi
				if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
					ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_OFF"
					ot-kernel_y_configopt "CONFIG_X86_INTEL_TSX_MODE_ON"
					ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_AUTO"
					ot-kernel_unset_configopt "CONFIG_GDS_FORCE_MITIGATION"
					ot-kernel_set_kconfig_kernel_cmdline "gather_data_sampling=off"
					ot-kernel_set_kconfig_kernel_cmdline "mds=off"
					ot-kernel_set_kconfig_kernel_cmdline "mmio_stale_data=off"
					ot-kernel_set_kconfig_kernel_cmdline "srbds=off"
					ot-kernel_set_kconfig_kernel_cmdline "tsx=on"
					ot-kernel_set_kconfig_kernel_cmdline "tsx_async_abort=off"
					if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
						ot-kernel_set_kconfig_kernel_cmdline "kvm-intel.vmentry_l1d_flush=never"
					fi
				fi
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.10 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_unset_configopt "CONFIG_SPECULATION_MITIGATIONS"
				ot-kernel_unset_configopt "CONFIG_CPU_UNRET_ENTRY"
			fi
			ot-kernel_unset_configopt "CONFIG_RETHUNK"
			ot-kernel_unset_configopt "CONFIG_CPU_IBPB_ENTRY"
			ot-kernel_unset_configopt "CONFIG_CPU_IBRS_ENTRY"
			ot-kernel_unset_configopt "CONFIG_SLS"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.14 ; then
			ot-kernel_set_kconfig_l1tf_mitigations "0"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=off"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=off"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.18 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_unset_configopt "CONFIG_X86_KERNEL_IBT"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.1 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "reg_file_data_sampling=off"
				ot-kernel_unset_configopt "CONFIG_MITIGATION_RFDS"
			fi
			if [[ "${arch}" == "arm64" ]] ; then
				ot-kernel_unset_configopt "nospectre_bhb"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.2 ; then
			ot-kernel_unset_configopt "CONFIG_CALL_DEPTH_TRACKING"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.4 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_ADDRESS_MASKING" # SLAM
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.5 ; then
			ot-kernel_unset_configopt "CONFIG_CPU_SRSO"
		fi
	elif [[ \
		   "${hardening_level}" == "default" \
		|| "${hardening_level}" == "practical" \
		|| "${hardening_level}" == "secure" \
	]] ; then
	# Resets back to upstream defaults.

		ot-kernel_unset_configopt "CONFIG_COMPAT_BRK"
		ot-kernel_unset_configopt "CONFIG_FORTIFY_SOURCE"
		ot-kernel_unset_configopt "CONFIG_GENTOO_KERNEL_SELF_PROTECTION" # Disabled for customization
		ot-kernel_unset_configopt "CONFIG_HARDENED_USERCOPY"
		ot-kernel_unset_configopt "CONFIG_INIT_ON_ALLOC_DEFAULT_ON"
		ot-kernel_unset_configopt "CONFIG_INIT_ON_FREE_DEFAULT_ON"

		if \
			tc-is-gcc \
				&& \
			test -e $(${CHOST}-gcc-${gcc_slot} -print-file-name=plugin)/include/plugin-version.h \
				&& \
			grep -q -E -e "^CONFIG_HAVE_GCC_PLUGINS=y" "${path_config}" \
				&& \
			! ot-kernel_use rust \
		; then
			ot-kernel_y_configopt "CONFIG_GCC_PLUGINS"
		else
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGINS"
		fi

		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			else
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.9 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
			ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL"
			ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.19 ; then
			ot-kernel_y_configopt "CONFIG_RANDSTRUCT_NONE"
			ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_FULL"
			ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_PERFORMANCE"
			if [[ "${arch}" == "x86" ]] && grep -q -E -e "^CONFIG_X86_PAE=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			elif [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MODIFY_LDT_SYSCALL"
		ot-kernel_y_configopt "CONFIG_RELOCATABLE"
		ot-kernel_y_configopt "CONFIG_RANDOMIZE_BASE"
		ot-kernel_unset_configopt "CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT"
		if [[ "${arch}" == "s390" ]] ; then
			ot-kernel_y_configopt "CONFIG_EXPOLINE"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_OFF"
			ot-kernel_y_configopt "CONFIG_EXPOLINE_AUTO"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_ON"
		elif [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_RANDOMIZE_MEMORY"
			_y_retpoline
		fi
		ot-kernel_unset_configopt "CONFIG_SHUFFLE_PAGE_ALLOCATOR"
		ot-kernel_unset_configopt "CONFIG_SLAB_FREELIST_HARDENED"
		ot-kernel_unset_configopt "CONFIG_SLAB_FREELIST_RANDOM"
		ot-kernel_y_configopt "CONFIG_SLAB_MERGE_DEFAULT"
		ot-kernel_y_configopt "CONFIG_STACKPROTECTOR"
		ot-kernel_y_configopt "CONFIG_STACKPROTECTOR_STRONG"
		if tc-is-gcc ; then
			ot-kernel_unset_configopt "CONFIG_ZERO_CALL_USED_REGS"
		fi
		ot-kernel_unset_configopt "CONFIG_SCHED_CORE"
		if ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "arm64" ]] ; then
	# KPTI:  This assumes unforced default
	# SSBD:  Rely on automagic
				:
			fi

			if [[ "${arch}" == "powerpc" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=auto"
			fi

			if [[ "${arch}" == "s390" ]] ; then
				ot-kernel_unset_configopt "CONFIG_KERNEL_NOBP"
				#ot-kernel_set_kconfig_kernel_cmdline "nobp=0"
			fi

			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=auto"
				ot-kernel_set_kconfig_kernel_cmdline "spectre_v2=auto"
				ot-kernel_set_kconfig_kernel_cmdline "spectre_v2_user=auto"
				if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
					ot-kernel_set_kconfig_kernel_cmdline "kvm.nx_huge_pages=auto"
				fi
				if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
					ot-kernel_y_configopt "CONFIG_X86_INTEL_TSX_MODE_OFF"
					ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_ON"
					ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_AUTO"
	# GDS:  Rely on automagic
					ot-kernel_unset_configopt "CONFIG_GDS_FORCE_MITIGATION"
					ot-kernel_set_kconfig_kernel_cmdline "mds=full"
					ot-kernel_set_kconfig_kernel_cmdline "mmio_stale_data=full"
					ot-kernel_set_kconfig_kernel_cmdline "tsx=off"
					ot-kernel_set_kconfig_kernel_cmdline "tsx_async_abort=full"
					if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
						ot-kernel_set_kconfig_kernel_cmdline "kvm-intel.vmentry_l1d_flush=cond"
					fi
				fi
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.10 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_SPECULATION_MITIGATIONS"
				ot-kernel_y_configopt "CONFIG_CPU_UNRET_ENTRY"
			fi
			ot-kernel_y_configopt "CONFIG_RETHUNK"
			ot-kernel_y_configopt "CONFIG_CPU_IBPB_ENTRY"
			ot-kernel_y_configopt "CONFIG_CPU_IBRS_ENTRY"
			ot-kernel_unset_configopt "CONFIG_SLS"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.14 ; then
			ot-kernel_set_kconfig_l1tf_mitigations "0.5"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=auto"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=auto"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.18 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				_y_ibt
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.1 \
			&& [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] \
			&& [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] \
		; then
			ot-kernel_set_kconfig_kernel_cmdline "reg_file_data_sampling=on"
			ot-kernel_y_configopt "CONFIG_MITIGATION_RFDS"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.2 ; then
			ot-kernel_y_configopt "CONFIG_CALL_DEPTH_TRACKING"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.4 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_unset_configopt "CONFIG_ADDRESS_MASKING" # SLAM
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.5 ; then
			ot-kernel_y_configopt "CONFIG_CPU_SRSO"
		fi
	elif [[ \
		   "${hardening_level}" == "secure-af" \
		|| "${hardening_level}" == "secure-as-fuck" \
	]] ; then
	# CFI and SCS handled later

		ot-kernel_unset_configopt "CONFIG_COMPAT_BRK"
		ot-kernel_y_configopt "CONFIG_FORTIFY_SOURCE"
		ot-kernel_unset_configopt "CONFIG_GENTOO_KERNEL_SELF_PROTECTION" # Disabled for customization
		ot-kernel_y_configopt "CONFIG_HARDENED_USERCOPY"
		ot-kernel_y_configopt "CONFIG_INIT_ON_ALLOC_DEFAULT_ON"
		ot-kernel_y_configopt "CONFIG_INIT_ON_FREE_DEFAULT_ON"

		if \
			tc-is-gcc \
				&& \
			test -e $(${CHOST}-${gcc_slot} -print-file-name=plugin)/include/plugin-version.h \
				&& \
			grep -q -E -e "^CONFIG_HAVE_GCC_PLUGINS=y" "${path_config}" \
				&& \
			! ot-kernel_use rust \
		; then
			ot-kernel_y_configopt "CONFIG_GCC_PLUGINS"
		else
			ot-kernel_unset_configopt "CONFIG_GCC_PLUGINS"
		fi

		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			elif grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			elif grep -q -E -e "^CONFIG_GCC_PLUGINS=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			else
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.9 ; then
			if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			elif grep -q -E -e "^CONFIG_GCC_PLUGINS=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
			else
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_PATTERN"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL_ZERO"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STACKLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
			if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_INIT_STACK_ALL"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			elif grep -q -E -e "^CONFIG_GCC_PLUGINS=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL"
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_NONE"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_y_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			else
				ot-kernel_unset_configopt "CONFIG_INIT_STACK_ALL"
				ot-kernel_y_configopt "CONFIG_INIT_STACK_NONE"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
				ot-kernel_unset_configopt "CONFIG_GCC_PLUGIN_STRUCTLEAK_USER"
			fi
		fi

		if ver_test ${KV_MAJOR_MINOR} -ge 5.19 ; then
			if tc-is-gcc && grep -q -E -e "^CONFIG_GCC_PLUGINS=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_NONE"
				ot-kernel_y_configopt "CONFIG_RANDSTRUCT_FULL"
				ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_PERFORMANCE"
			else
				ot-kernel_y_configopt "CONFIG_RANDSTRUCT_NONE"
				ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_FULL"
				ot-kernel_unset_configopt "CONFIG_RANDSTRUCT_PERFORMANCE"
			fi
			if [[ "${arch}" == "x86" ]] && grep -q -E -e "^CONFIG_X86_PAE=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			elif [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_PAGE_TABLE_ISOLATION"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_unset_configopt "CONFIG_MODIFY_LDT_SYSCALL"
		ot-kernel_y_configopt "CONFIG_RELOCATABLE"
		ot-kernel_y_configopt "CONFIG_RANDOMIZE_BASE"
		ot-kernel_y_configopt "CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT"
		if [[ "${arch}" == "s390" ]] ; then
			ot-kernel_y_configopt "CONFIG_EXPOLINE"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_OFF"
			ot-kernel_y_configopt "CONFIG_EXPOLINE_AUTO"
			ot-kernel_unset_configopt "CONFIG_EXPOLINE_ON"
		elif [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_RANDOMIZE_MEMORY"
			_y_retpoline
		fi
		ot-kernel_y_configopt "CONFIG_SHUFFLE_PAGE_ALLOCATOR"
		ot-kernel_y_configopt "CONFIG_SLAB_FREELIST_HARDENED"
		ot-kernel_unset_configopt "CONFIG_SLAB_MERGE_DEFAULT"
		ot-kernel_y_configopt "CONFIG_SLAB_FREELIST_RANDOM"
		ot-kernel_y_configopt "CONFIG_STACKPROTECTOR"
		ot-kernel_y_configopt "CONFIG_STACKPROTECTOR_STRONG"
		if tc-is-gcc ; then
			ot-kernel_y_configopt "CONFIG_ZERO_CALL_USED_REGS"
		fi
		if [[ "${cpu_sched}" =~ "cfs" && "${HT:-3}" =~ ("1"|"2"|"3"|"custom"|"manual") ]] ; then
			ot-kernel_y_configopt "CONFIG_SCHED_CORE"
ewarn
ewarn "The behavior the HT environment variable has changed.  See metadata.xml"
ewarn "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for details."
ewarn
			if [[ "${HT}" =~ ("custom"|"manual") ]] ; then
				:
			elif ver_test ${KV_MAJOR_MINOR} -ge 6.6 && [[ "${HT}" =~ ("2") ]] && [[ "${arch}" == "powerpc" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nosmt"
			elif ver_test ${KV_MAJOR_MINOR} -ge 6.6 && [[ "${HT}" =~ ("3") ]] && [[ "${arch}" == "powerpc" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nosmt=force"
			elif ver_test ${KV_MAJOR_MINOR} -ge 6.5 && [[ "${HT}" =~ ("2"|"3") ]] && [[ "${arch}" == "mips" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nosmt"
			elif ver_test ${KV_MAJOR_MINOR} -ge 4.10 && [[ "${HT}" =~ ("2"|"3") ]] && [[ "${arch}" == "s390" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nosmt"
			elif ver_test ${KV_MAJOR_MINOR} -ge 4.14 && [[ "${HT}" =~ ("3") ]] && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "nosmt=force"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "arm64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "kpti=1"
				ot-kernel_set_kconfig_kernel_cmdline "ssbd=force-on"
			fi

			if [[ "${arch}" == "powerpc" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=auto"
			fi

			if [[ "${arch}" == "s390" ]] ; then
				ot-kernel_y_configopt "CONFIG_KERNEL_NOBP"
				ot-kernel_set_kconfig_kernel_cmdline "nobp=1"
			fi

			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_X86_INTEL_TSX_MODE_OFF"
				ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_ON"
				ot-kernel_unset_configopt "CONFIG_X86_INTEL_TSX_MODE_AUTO"
				ot-kernel_set_kconfig_kernel_cmdline "spec_store_bypass_disable=auto"
				ot-kernel_set_kconfig_kernel_cmdline "spectre_v2=auto"
				ot-kernel_set_kconfig_kernel_cmdline "spectre_v2_user=auto"
				ot-kernel_set_kconfig_kernel_cmdline "tsx=off"
				if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
					ot-kernel_set_kconfig_kernel_cmdline "kvm.nx_huge_pages=auto"
				fi
				if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
					if ot-kernel_has_version "sys-firmware/intel-microcode" ; then
						ot-kernel_unset_configopt "CONFIG_GDS_FORCE_MITIGATION"
					elif ot-kernel_use cpu_flags_x86_avx ; then
						ot-kernel_y_configopt "CONFIG_GDS_FORCE_MITIGATION"
					fi
					ot-kernel_set_kconfig_kernel_cmdline "mds=full"
					ot-kernel_set_kconfig_kernel_cmdline "mmio_stale_data=full,nosmt"
					ot-kernel_set_kconfig_kernel_cmdline "tsx_async_abort=full,nosmt"
					if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
						ot-kernel_set_kconfig_kernel_cmdline "kvm-intel.vmentry_l1d_flush=always"
					fi
				fi
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.10 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_SPECULATION_MITIGATIONS"
			fi
			ot-kernel_y_configopt "CONFIG_RETHUNK"
			if ! test-flags "-mfunction-return=thunk-extern" >/dev/null 2>&1 ; then
				# For rethunk
				local gcc_version=$(gcc-version)
				local clang_version=$(clang-version)
eerror
eerror "Please rebuild =clang-15.0.0.9999 or switch to >= gcc-8.1"
eerror
eerror "Actual GCC version:  ${gcc_version}"
eerror "Actual Clang version:  ${clang_version}"
eerror
				die
			fi
			if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
				ot-kernel_y_configopt "CONFIG_CPU_IBPB_ENTRY"
				if [[ "${arch}" == "x86_64" ]] ; then
					ot-kernel_y_configopt "CONFIG_CPU_UNRET_ENTRY"
				fi
			elif [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
				ot-kernel_y_configopt "CONFIG_CPU_IBRS_ENTRY"
			elif [[ $(ot-kernel_get_cpu_mfg_id) == "hygon" ]] ; then
				ot-kernel_y_configopt "CONFIG_CPU_UNRET_ENTRY"
			fi
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_SLS"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.14 ; then
			ot-kernel_set_kconfig_l1tf_mitigations "1"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.15 ; then
			ot-kernel_set_kconfig_kernel_cmdline "l1d_flush=on"
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=auto"
			fi
		elif ver_test ${KV_MAJOR_MINOR} -ge 4.14 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "retbleed=auto"
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 5.18 ; then
			if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
				_y_ibt
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.1 \
			&& [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] \
			&& [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] \
		; then
			ot-kernel_set_kconfig_kernel_cmdline "reg_file_data_sampling=on"
			ot-kernel_y_configopt "CONFIG_MITIGATION_RFDS"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.2 ; then
			ot-kernel_y_configopt "CONFIG_CALL_DEPTH_TRACKING"
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.4 ; then
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_unset_configopt "CONFIG_ADDRESS_MASKING" # SLAM
			fi
		fi
		if ver_test ${KV_MAJOR_MINOR} -ge 6.5 ; then
			if [[ "${arch}" == "x86_64" ]] && grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
				if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
					ot-kernel_y_configopt "CONFIG_CPU_SRSO"
				fi
			fi
		fi
	# See https://en.wikipedia.org/wiki/Kernel_same-page_merging#Security_risks
		ot-kernel_unset_configopt "CONFIG_KSM"
		ot-kernel_unset_configopt "CONFIG_UKSM"
		if has uksm ${IUSE_EFFECTIVE} && ot-kernel_use uksm ; then
# This disables patching with uksm or unintended consequences of patching with"
# it.
eerror
eerror "Please disable uksm for OT_KERNEL_HARDENING_LEVEL=${hardening_level}"
eerror "for OT_KERNEL_EXTRAVERSION=\"${extraversion}\"."
eerror
			die
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_ima
# @DESCRIPTION:
# Configures IMA (Integrity Measurement Architecture) used to protect
# root and boot files and customized setups
ot-kernel_set_kconfig_ima() {
	[[ -z "${OT_KERNEL_IMA}" ]] && return
einfo "Configuring IMA"
	local algs=(
		sha1
		sha256
		sha512
		wp512
	)
	local a
	for a in ${algs[@]} ; do
		ot-kernel_unset_configopt "CONFIG_IMA_DEFAULT_HASH_${a^^}"
	done
	ot-kernel_y_configopt "CONFIG_INTEGRITY"
	ot-kernel_y_configopt "CONFIG_IMA"
	ot-kernel_y_configopt "CONFIG_IMA_APPRAISE"
	local hash_alg="${OT_KERNEL_IMA_HASH_ALG^^}"
	if [[ "${hash_alg}" == "default" ]] ; then
einfo "Using sha1 for IMA hashing"
		ot-kernel_y_configopt "CONFIG_IMA_DEFAULT_HASH_SHA1"
		ot-kernel_y_configopt "CONFIG_SHA1"
	elif [[ "${hash_alg}" == "manual" ]] ; then
einfo "Using manual for IMA hashing"
	elif [[ -n "${hash_alg}" ]] ; then
einfo "Using ${hash_alg,,} for IMA hashing"
		ot-kernel_y_configopt "CONFIG_IMA_DEFAULT_HASH_${hash_alg}"
		ot-kernel_y_configopt "CONFIG_${hash_alg}"
		if [[ "${hash_alg}" != "SHA1" ]] ; then
			ot-kernel_unset_configopt "CONFIG_IMA_TEMPLATE"
		fi
	else
einfo "Using manual for IMA hashing"
	fi
	if [[ "${OT_KERNEL_IMA}" == "fix" ]] ; then
einfo "Using fix for IMA mode"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "ima_appraise=(fix|enforce|off)"
		ot-kernel_set_kconfig_kernel_cmdline "ima_appraise=fix"
		export _OT_KERNEL_IMA_USED=1
	elif [[ "${OT_KERNEL_IMA}" == "enforce" ]] ; then
einfo "Using enforce for IMA mode"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "ima_appraise=(fix|enforce|off)"
		ot-kernel_set_kconfig_kernel_cmdline "ima_appraise=enforce"
		export _OT_KERNEL_IMA_USED=1
	elif [[ "${OT_KERNEL_IMA}" == "off" ]] ; then
einfo "Disabling IMA"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "ima_appraise=(fix|enforce|off)"
		ot-kernel_set_kconfig_kernel_cmdline "ima_appraise=off"
	fi
	ot-kernel_unset_pat_kconfig_kernel_cmdline "appraise_tcb" # Reset
	ot-kernel_unset_pat_kconfig_kernel_cmdline "critical_data"
	ot-kernel_unset_pat_kconfig_kernel_cmdline "secure_boot"
	ot-kernel_unset_pat_kconfig_kernel_cmdline "tcb"
	local ima_policies=""
	if [[ "${OT_KERNEL_IMA_POLICIES}" =~ "appraise_tcb" ]] ; then
einfo "Using appraise_tcb IMA policy"
		ima_policies+=" ima_policy=appraise_tcb"
	fi
	if [[ "${OT_KERNEL_IMA_POLICIES}" =~ "critical_data" ]] ; then
einfo "Using critical_data IMA policy"
		ima_policies+=" ima_policy=critical_data"
	fi
	if [[ "${OT_KERNEL_IMA_POLICIES}" =~ "fail_securely" ]] ; then
einfo "Using fail_securely IMA policy"
		ima_policies+=" ima_policy=fail_securely"
	fi
	if [[ "${OT_KERNEL_IMA_POLICIES}" =~ "secure_boot" ]] ; then
einfo "Using secure_boot IMA policy"
		ima_policies+=" ima_policy=secure_boot"
	fi
	if [[ "${OT_KERNEL_IMA_POLICIES}" =~ "tcb" ]] ; then
einfo "Using tcb IMA policy"
		ima_policies+=" ima_policy=tcb"
	fi
	if [[ -n "${OT_KERNEL_IMA_POLICIES}" ]] ; then
		ot-kernel_set_kconfig_kernel_cmdline "${ima_policies}"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_iommu_domain_type
# @DESCRIPTION:
# Sets the default IOMMU domain_type
ot-kernel_set_kconfig_iommu_domain_type() {
	local iommu="${OT_KERNEL_IOMMU}"
	if [[ "${iommu}" =~ ("custom"|"manual") ]] ; then
		:
	elif [[ "${iommu}" == "disable" ]] ; then
		ot-kernel_unset_configopt "CONFIG_IOMMU_SUPPORT"
	elif [[ "${iommu}" == "pt" ]] ; then
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_STRICT"
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_LAZY"
		ot-kernel_y_configopt "CONFIG_IOMMU_DEFAULT_PASSTHROUGH"
	elif [[ "${iommu}" == "lazy" ]] ; then
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_STRICT"
		ot-kernel_y_configopt "CONFIG_IOMMU_DEFAULT_DMA_LAZY"
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_PASSTHROUGH"
	elif [[ "${iommu}" == "strict" ]] ; then
		ot-kernel_y_configopt "CONFIG_IOMMU_DEFAULT_DMA_STRICT"
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_DMA_LAZY"
		ot-kernel_unset_configopt "CONFIG_IOMMU_DEFAULT_PASSTHROUGH"
	fi
	if [[ "${iommu}" =~ ("pt"|"lazy"|"strict") ]] ; then
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
		if [[ "${arch}" == "x86_64" && "${OT_KERNEL_IRQ_REMAP:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_MMU"
			ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
			ot-kernel_y_configopt "CONFIG_PCI_MSI"
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_IRQ_REMAP"
		fi
	fi
	if [[ "${OT_KERNEL_IRQ_REMAP}" == "0" ]] ; then
		ot-kernel_unset_configopt "CONFIG_IRQ_REMAP"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_march
# @DESCRIPTION:
# Sets the kernel config for the -march associated with the microarchitecture.
# Takes in consideration the kernel_compiler_patch.
ot-kernel_set_kconfig_march() {
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		if [[ "${X86_MICROARCH_OVERRIDE}" =~ ("manual"|"custom") ]] ; then
einfo "Setting .config with ${X86_MICROARCH_OVERRIDE} march setting"
		else
			local microarches=(
				$(grep -r -e "config M" "${BUILD_DIR}/arch/x86/Kconfig.cpu" | sed -e "s|config ||g")
			)
			local m
			for m in ${microarches[@]} ; do
				# Reset to avoid ambiguous config
				ot-kernel_unset_configopt "CONFIG_${m}"
			done
			local march_flags=()
			local kflag="CONFIG_GENERIC_CPU"
			ot-kernel_unset_configopt "${kflag}"
			if [[ -n "${X86_MICROARCH_OVERRIDE}" ]] ; then
einfo "Setting .config with CONFIG_${X86_MICROARCH_OVERRIDE}=y"
				kflag="CONFIG_${KCP_MICROARCH_OVERRIDE}"
			elif grep -q -E -e "MNATIVE_" "${BUILD_DIR}/arch/x86/Kconfig.cpu" ; then
				local mfg=$(ot-kernel_get_cpu_mfg_id)
				mfg=${mfg^^}
				kflag="CONFIG_MNATIVE_${mfg}"
			elif grep -q -F -e "MNATIVE" "${BUILD_DIR}/arch/x86/Kconfig.cpu" ; then
einfo "Setting .config with -march=native"
				kflag="CONFIG_MNATIVE"
			elif grep -q -F -e "GENERIC_CPU" "${BUILD_DIR}/arch/x86/Kconfig.cpu" ; then
ewarn
ewarn "Setting .config with -march=generic"
ewarn
ewarn "See X86_MICROARCH_OVERRIDE in metadata.xml"
ewarn "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`) to optimize."
ewarn
				kflag="CONFIG_GENERIC_CPU"
			else
ewarn "Falling back to ${kflag}"
			fi
			ot-kernel_y_configopt "${kflag}"

			local march_flags=($(cat arch/x86/Makefile{,_32.cpu} \
				| sed -e "s|call tune,|-mtune=|g" \
				| grep -E  -e "CONFIG.*(march|mtune)=" \
				| grep -E -e "(march|mtune)" \
				| grep -e "${kflag}" \
				| grep -E -o -e "(-march=|-mtune=)[a-z0-9_.-]+"))
			for x in ${march_flags[@]} ; do
				if ! test-flags "${x}" >/dev/null 2>&1 ; then
					# This test is for kernel_compiler_patch.
eerror
eerror "Failed compiler flag test for ${x}."
eerror
eerror "You need to make sure the compiler for that any slot install does"
eerror "support the failed compiler flag."
eerror
					die
				else
einfo "Passed check for ${x}"
				fi
			done
		fi
	fi

	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		if tc-is-cross-compiler ; then
			# Cannot use -march=native if doing distcc.
			if grep "^CONFIG_MNATIVE" "${path_config}" ; then
einfo
einfo "Detected cross-compiling.  Converting -march=native -> -mtune=generic"
einfo "In the future, change the setting to the microarchitecture instead."
einfo
				ot-kernel_unset_configopt "CONFIG_MNATIVE_AMD"
				ot-kernel_unset_configopt "CONFIG_MNATIVE_INTEL"
				ot-kernel_unset_configopt "CONFIG_MNATIVE"
				ot-kernel_y_configopt "CONFIG_GENERIC_CPU"
			else
einfo
einfo "Detected cross-compiling.  Using previous generic or microarchitecture"
einfo "setting."
einfo
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_init_systems
# @DESCRIPTION:
# Sets the kernel config for the init systems
ot-kernel_set_kconfig_init_systems() {
	if has genpatches ${IUSE_EFFECTIVE} && ot-kernel_use genpatches ; then
		ot-kernel_unset_configopt "CONFIG_GENTOO_PRINT_FIRMWARE_INFO" # Debug
		if ot-kernel_has_version "sys-apps/openrc" ; then
			ot-kernel_y_configopt "CONFIG_GENTOO_LINUX_INIT_SCRIPT"
		else
			ot-kernel_unset_configopt "CONFIG_GENTOO_LINUX_INIT_SCRIPT"
		fi
		if ot-kernel_has_version "sys-apps/systemd" ; then
			ot-kernel_y_configopt "CONFIG_GENTOO_LINUX_INIT_SYSTEMD"
		else
			ot-kernel_unset_configopt "CONFIG_GENTOO_LINUX_INIT_SYSTEMD"
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_lsms
# @DESCRIPTION:
# Sets the kernel config for Linux Security Modules (LSM) selection.
ot-kernel_set_kconfig_lsms() {
	# Allow to customize and trim LSMs without running the menuconfig in unattended install.
	local ot_kernel_lsms_choice
	if (( ${is_default_config} == 1 )) && [[ -z "${OT_KERNEL_LSMS}" ]] ; then
		ot_kernel_lsms_choice="auto"
	else
		ot_kernel_lsms_choice="${OT_KERNEL_LSMS:-manual}"
	fi
	local ot_kernel_lsms=()
	if [[ "${ot_kernel_lsms_choice}" == "manual" ]] ; then
einfo "Using the manual LSM settings"
einfo "LSMs:  "$(grep -r -e "CONFIG_LSM=" "${path_config}" | cut -f 2 -d "\"")
	elif [[ "${ot_kernel_lsms_choice}" == "default" ]] ; then
einfo "Using the default LSM settings"
		OT_KERNEL_USE_LSM_UPSTREAM_ORDER="1"
		ot_kernel_lsms="integrity,selinux,bpf" # Equivalent upstream settings
	elif [[ "${ot_kernel_lsms_choice}" == "auto" ]] ; then
einfo "Using the auto LSM settings"
		OT_KERNEL_USE_LSM_UPSTREAM_ORDER="1"
		ot_kernel_lsms="integrity"
		if ot-kernel_has_version "sec-policy/selinux-base" ; then
			ot_kernel_lsms+=",selinux"
			if ot-kernel_has_version "sys-apps/smack-utils" ; then
				ot_kernel_lsms+=",smack"
			fi
			if ot-kernel_has_version "sys-apps/tomoyo-tools" ; then
				ot_kernel_lsms+=",tomoyo"
			fi
			if ot-kernel_has_version "sys-apps/apparmor" ; then
				ot_kernel_lsms+=",apparmor"
			fi
			ot_kernel_lsms+=",bpf"
		elif ot-kernel_has_version "sys-apps/smack-utils" ; then
			ot_kernel_lsms+=",smack"
			if ot-kernel_has_version "sec-policy/selinux-base" ; then
				ot_kernel_lsms+=",selinux"
			fi
			if ot-kernel_has_version "sys-apps/tomoyo-tools" ; then
				ot_kernel_lsms+=",tomoyo"
			fi
			if ot-kernel_has_version "sys-apps/apparmor" ; then
				ot_kernel_lsms+=",apparmor"
			fi
			ot_kernel_lsms+=",bpf"
		elif ot-kernel_has_version "sys-apps/tomoyo-tools" ; then
			ot_kernel_lsms+=",tomoyo"
			ot_kernel_lsms+=",bpf"
		elif ot-kernel_has_version "sys-apps/apparmor" ; then
			ot_kernel_lsms+=",apparmor"
			if ot-kernel_has_version "sec-policy/selinux-base" ; then
				ot_kernel_lsms+=",selinux"
			fi
			if ot-kernel_has_version "sys-apps/smack-utils" ; then
				ot_kernel_lsms+=",smack"
			fi
			if ot-kernel_has_version "sys-apps/tomoyo-tools" ; then
				ot_kernel_lsms+=",tomoyo"
			fi
			ot_kernel_lsms+=",bpf"
		else
			ot_kernel_lsms+=",bpf"
		fi
	else
		ot_kernel_lsms="${OT_KERNEL_LSMS}"
		ot_kernel_lsms="${ot_kernel_lsms,,}"
		ot_kernel_lsms="${ot_kernel_lsms// /}"
einfo "Using the custom LSM settings:  ${ot_kernel_lsms}"
	fi

	if [[ -n "${ot_kernel_lsms}" ]] ; then
		unset LSM_MODULES
		declare -A LSM_MODULES=(
			[landlock]="LANDLOCK"
			[lockdown]="LOCKDOWN_LSM"
			[yama]="YAMA"
			[loadpin]="LOADPIN"
			[safesetid]="SAFESETID"
			[integrity]="INTEGRITY"
			[smack]="SMACK"
			[bpf]="DAC"
			[apparmor]="APPARMOR"
			[tomoyo]="TOMOYO"
			[selinux]="SELINUX"
		)

		unset LSM_LEGACY
		declare -A LSM_LEGACY=(
			[selinux]="SELINUX"
			[smack]="SMACK"
			[tomoyo]="TOMOYO"
			[apparmor]="APPARMOR"
			[bpf]="DAC"
		)

		ot-kernel_unset_configopt "CONFIG_LSM"

		# Enable modules
		local l
		for l in ${LSM_MODULES[@]} ; do
			ot-kernel_unset_configopt "CONFIG_SECURITY_${l^^}" # Reset
		done
		IFS=','
		for l in ${ot_kernel_lsms[@]} ; do
			local k="${LSM_MODULES[${l}]}"
			ot-kernel_y_configopt "CONFIG_SECURITY_${k^^}" # Add requested
		done
		IFS=$' \t\n'

		for l in ${LSM_LEGACY[@]} ; do
			ot-kernel_unset_configopt "CONFIG_DEFAULT_SECURITY_${l}" # Reset
		done

		# Pick the default legacy
		l=$(echo "${ot_kernel_lsms,,}" | sed -e "s| ||g" | grep -E -o -e "(selinux|smack|tomoyo|apparmor|bpf)" | head -n 1)
einfo "ot_kernel_lsms=${ot_kernel_lsms,,}"
einfo "Default LSM: ${l}"
		ot-kernel_y_configopt "CONFIG_DEFAULT_SECURITY_${LSM_LEGACY[${l}]}" # Implied

		local lsms=()
		# This is the upstream order but allow user to customize it
		[[ "${ot_kernel_lsms}" =~ "landlock" ]] && lsms+=( landlock )
		[[ "${ot_kernel_lsms}" =~ "lockdown" ]] && lsms+=( lockdown )
		[[ "${ot_kernel_lsms}" =~ "yama" ]] && lsms+=( yama )
		[[ "${ot_kernel_lsms}" =~ "loadpin" ]] && lsms+=( loadpin )
		[[ "${ot_kernel_lsms}" =~ "safesetid" ]] && lsms+=( safesetid )
		[[ "${ot_kernel_lsms}" =~ "integrity" ]] && lsms+=( integrity )
		if [[ "${ot_kernel_lsms}" =~ "selinux" ]] ; then
			lsms+=( selinux )
			[[ "${ot_kernel_lsms}" =~ "smack" ]] && lsms+=( smack )
			[[ "${ot_kernel_lsms}" =~ "tomoyo" ]] && lsms+=( tomoyo )
			[[ "${ot_kernel_lsms}" =~ "apparmor" ]] && lsms+=( apparmor )
			lsms+=( bpf )
		elif [[ "${ot_kernel_lsms}" =~ "smack" ]] ; then
			lsms+=( smack )
			[[ "${ot_kernel_lsms}" =~ "selinux" ]] && lsms+=( selinux )
			[[ "${ot_kernel_lsms}" =~ "tomoyo" ]] && lsms+=( tomoyo )
			[[ "${ot_kernel_lsms}" =~ "apparmor" ]] && lsms+=( apparmor )
			lsms+=( bpf )
		elif [[ "${ot_kernel_lsms}" =~ "tomoyo" ]] ; then
			lsms+=( tomoyo )
			lsms+=( bpf )
		elif [[ "${ot_kernel_lsms}" =~ "apparmor" ]] ; then
			lsms+=( apparmor )
			[[ "${ot_kernel_lsms}" =~ "selinux" ]] && lsms+=( selinux )
			[[ "${ot_kernel_lsms}" =~ "smack" ]] && lsms+=( smack )
			[[ "${ot_kernel_lsms}" =~ "tomoyo" ]] && lsms+=( tomoyo )
			lsms+=( bpf )
		elif [[ "${ot_kernel_lsms}" =~ "bpf" ]] ; then
			lsms+=( bpf )
		fi

		if [[ "${OT_KERNEL_USE_LSM_UPSTREAM_ORDER}" == "1" ]] ; then
			local arg=$(echo "${lsms[@]}" | tr " " ",")
			ot-kernel_set_configopt "CONFIG_LSM" "\"${arg}\""
einfo "LSMs:  ${arg}"
		else
			ot-kernel_set_configopt "CONFIG_LSM" "\"${ot_kernel_lsms}\""
einfo "LSMs:  ${ot_kernel_lsms}"
		fi
	fi

	if [[ "${OT_KERNEL_IMA}" =~ ("fix"|"enforce") ]] ; then
		local lsms_=$(grep -r -e "CONFIG_LSM=" "${path_config}" | cut -f 2 -d "\"")
		if [[ "${lsms_}" =~ "integrity" ]] ; then
			:
		else
eerror
eerror "integrity must be added to OT_KERNEL_LSMS or CONFIG_LSM"
eerror
			die
		fi
	fi
}

# @FUNCTION: ban_dma_attack_use
# @DESCRIPTION:
# Warn of the use of kernel options that may used for DMA attacks.
ban_dma_attack_use() {
	local u="${1}"
	local kopt="${2}"
	[[ -n "${OT_KERNEL_DMA_ATTACK_MITIGATIONS}" ]] \
		&& (( ${OT_KERNEL_DMA_ATTACK_MITIGATIONS} == 0 )) \
		&& return
eerror
eerror "The ${kopt} kernel option may be used as a possible prerequisite for"
eerror "DMA side-channel attacks."
eerror
eerror "Set OT_KERNEL_DMA_ATTACK_MITIGATIONS=0 to continue or disable the"
eerror "${u} USE flag."
eerror
	die
}

# @FUNCTION: ot-kernel_show_llvm_requirement
# @DESCRIPTION:
# Show LLVM toolchain requirements and quit
ot-kernel_show_llvm_requirement() {
	local msg="${1}"
eerror
eerror "Make sure the following valid slots is installed:"
eerror
eerror "LLVM_MIN_SLOT: ${LLVM_COMPAT[-1]}"
eerror "LLVM_MAX_SLOT: ${LLVM_COMPAT[0]}"
eerror
eerror "Reason:  ${msg}"
eerror
#	die
}


# @FUNCTION: ot-kernel_set_kconfig_lto
# @DESCRIPTION:
# Sets the kernel config for Link Time Optimization (LTO)
ot-kernel_set_kconfig_lto() {
	if has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ; then
		if (( ${llvm_slot} < 11 )) ; then
			if [[ ! -e "/usr/lib/llvm/${slot}/bin/clang" ]] ; then
				ot-kernel_show_llvm_requirement "Missing clang"
			fi
			ot-kernel_show_llvm_requirement "LTO requires clang:\${SLOT} == llvm:\${SLOT} and \${SLOT} >= 11"
		fi
einfo "Enabling LTO"
		ot-kernel_y_configopt "CONFIG_ARCH_SUPPORTS_LTO_CLANG"
		ot-kernel_y_configopt "CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN"
		ot-kernel_unset_configopt "CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT"
		ot-kernel_unset_configopt "CONFIG_GCOV_KERNEL"
		ot-kernel_y_configopt "CONFIG_HAS_LTO_CLANG"
		ban_dma_attack_use "lto" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_unset_configopt "CONFIG_KASAN"
		ot-kernel_unset_configopt "CONFIG_KASAN_HW_TAGS"
		ot-kernel_y_configopt "CONFIG_LTO"
		ot-kernel_y_configopt "CONFIG_LTO_CLANG"
		ot-kernel_unset_configopt "CONFIG_LTO_CLANG_FULL"
		ot-kernel_y_configopt "CONFIG_LTO_CLANG_THIN"
		ot-kernel_unset_configopt "CONFIG_LTO_NONE"
	else
einfo "Disabling LTO"
		ot-kernel_unset_configopt "CONFIG_HAS_LTO_CLANG"
		ot-kernel_unset_configopt "CONFIG_LTO"
		ot-kernel_unset_configopt "CONFIG_LTO_CLANG_FULL"
		ot-kernel_unset_configopt "CONFIG_LTO_CLANG_THIN"
		ot-kernel_y_configopt "CONFIG_LTO_NONE"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_memory_protection
# @DESCRIPTION:
# Sets the memory protection for mitigation against cold boot attacks
# or for required access to DRM (premium content).
ot-kernel_set_kconfig_memory_protection() {
	if [[ "${arch}" == "x86_64" ]] ; then
		local has_sgx=0
		if [[ "${OT_KERNEL_SGX:-auto}" == "auto" ]] ; then
			if !  tc-is-cross-compiler  \
			   && grep -q -e " sgx " "/proc/cpuinfo" ; then
				has_sgx=1
			fi
		fi
		if [[ "${OT_KERNEL_SGX}" == "1" || "${has_sgx}" == "1" ]] ; then
einfo "Enabling SGX"
			ot-kernel_y_configopt "CONFIG_X86_SGX"
		else
einfo "Disabling SGX"
			ot-kernel_unset_configopt "CONFIG_X86_SGX"
		fi
		ot-kernel_unset_configopt "CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT"
		local has_sme=0
		if [[ "${OT_KERNEL_SME:-auto}" == "auto" ]] ; then
			if !  tc-is-cross-compiler  \
			   && grep -q -e " sme " "/proc/cpuinfo" ; then
				has_sme=1
			fi
		fi
		if [[ "${OT_KERNEL_SME}" == "1" || "${has_sme}" == "1" ]] ; then
einfo "Allowing SME"
			ot-kernel_y_configopt "CONFIG_AMD_MEM_ENCRYPT"
			if [[ "${OT_KERNEL_SME_DEFAULT_ON}" == "1" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "mem_encrypt=on"
				ot-kernel_y_configopt "CONFIG_CMDLINE_OVERRIDE" # Disallow changing
			else
ewarn "Set OT_KERNEL_SME_DEFAULT_ON=1 when testing is successful."
			fi
		else
einfo "Disabling SME"
			ot-kernel_unset_configopt "CONFIG_AMD_MEM_ENCRYPT"
		fi
		local has_pku=0
		if [[ "${OT_KERNEL_PKU:-auto}" == "auto" ]] ; then
			if ! tc-is-cross-compiler \
			   && grep -q -e " pku " "/proc/cpuinfo" ; then
				has_pku=1
			fi
		fi
		if [[ "${OT_KERNEL_PKU}" == "1" || "${has_pku}" == "1" ]] ; then
einfo "Enabling PKU"
			ot-kernel_y_configopt "CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS"
		else
einfo "Disabling PKU"
			ot-kernel_unset_configopt "CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS"
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_memstick
# @DESCRIPTION:
# Add mem stick support
ot-kernel_set_kconfig_memstick() {
	[[ "${MEMSTICK:-0}" == "1" ]] || return
einfo "Adding Memory Stick support"
	local hosts=(
		$(grep -r "config " drivers/memstick/host/Kconfig \
			| cut -f 2 -d " ")
	)
	local x
	ot-kernel_set_configopt "CONFIG_MEMSTICK" "m"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_MS_BLOCK"
	ot-kernel_y_configopt "CONFIG_MSPRO_BLOCK"
	for x in ${hosts[@]} ; do
		ot-kernel_set_configopt "CONFIG_${x}" "m"
	done
	ot-kernel_unset_configopt "CONFIG_MEMSTICK_UNSAFE_RESUME"

	# Depends
	ot-kernel_y_configopt "CONFIG_PCI"
}

# @FUNCTION: ot-kernel_set_kconfig_mmc_sd_sdio
# @DESCRIPTION:
# Add support for MMC/SD/SDIO support
ot-kernel_set_kconfig_mmc_sd_sdio() {
	[[ "${MEMCARD_MMC:-0}" == "1" || "${MEMCARD_SD:-0}" == "1" || "${MEMCARD_SDIO:-0}" == "1" ]] || return
	if [[ "${MEMCARD_MMC}" == "1" ]] ; then
einfo "Adding MMC support"
	fi
	if [[ "${MEMCARD_SD}" == "1" ]] ; then
einfo "Adding SD support"
	fi
	if [[ "${MEMCARD_SDIO}" == "1" ]] ; then
einfo "Adding SDIO support"
	fi
	local hosts=(
		$(grep -r "config " drivers/mmc/host/Kconfig \
			| cut -f 2 -d " ")
	)
	local x
	ot-kernel_set_configopt "CONFIG_MMC" "m"
	for x in ${hosts[@]} ; do
		ot-kernel_set_configopt "CONFIG_${x}" "m"
	done

	# Depends
	local deps=(
		$(grep -r -e "depends on"  drivers/mmc/host/Kconfig \
			| sed -e "s|depends on|;|g" \
			| cut -f 2 -d " " \
			| sort \
			| uniq \
			| sed -e "s#[\(\|\)]##g")
	)
	local skippable=(
		ARCH_
		ARC
		ARM
		ARM64
		PPC
		MIPS
	)
	for x in ${deps[@]} ; do
		local skip=0
		for y in ${skippable[@]} ; do
			[[ "${x}" == "${y}" ]] && skip=1
			[[ "${x}" == "ARCH_" ]] && skip=1
		done
		(( ${skip} )) && continue
		ot-kernel_y_configopt "CONFIG_${x}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_module_signing
# @DESCRIPTION:
# Sets the kernel config for signed kernel modules
ot-kernel_set_kconfig_module_signing() {
	grep -q -e "^CONFIG_MODULES=y" "${BUILD_DIR}/.config" || return
	# The default profile does not have module signing default on.
	if [[ "${OT_KERNEL_SIGN_MODULES}" == "0" ]] ; then
einfo "Disabling auto-signed modules"
		ot-kernel_unset_configopt "CONFIG_MODULE_SIG"
		ot-kernel_unset_configopt "CONFIG_MODULE_SIG_ALL"
	elif [[ "${OT_KERNEL_SIGN_MODULES,,}" == "manual" ]] ; then
einfo "Using the manual setting for auto-signed modules"
	elif [[ -n "${OT_KERNEL_SIGN_MODULES}" ]] ; then
		if [[ "${OT_KERNEL_SIGN_MODULES,,}" == "sha512" ]] ; then
			:
		elif [[ "${OT_KERNEL_SIGN_MODULES,,}" == "sha384" ]] ; then
			:
		else
			OT_KERNEL_SIGN_MODULES="sha384"
		fi

einfo "Changing config to auto-signed modules with ${OT_KERNEL_SIGN_MODULES^^}"
		ot-kernel_y_configopt "CONFIG_MODULE_SIG_FORMAT"
		ot-kernel_y_configopt "CONFIG_MODULE_SIG"
		ot-kernel_y_configopt "CONFIG_MODULE_SIG_ALL"
		ot-kernel_y_configopt "CONFIG_MODULE_SIG_FORCE"
		local alg
		local sign_algs=(
			SHA1
			SHA224
			SHA256
			SHA384
			SHA512
		)
		for alg in ${sign_algs[@]} ; do
			# Reset
			ot-kernel_n_configopt "CONFIG_MODULE_SIG_${alg}"
			#ot-kernel_n_configopt "CONFIG_CRYPTO_${alg}" # Disabled because it can interfere with other modules.
		done
		ot-kernel_y_configopt "CONFIG_MODULE_SIG_${OT_KERNEL_SIGN_MODULES^^}"
		ot-kernel_y_configopt "CONFIG_CRYPTO_${OT_KERNEL_SIGN_MODULES^^}"
		ot-kernel_set_configopt "CONFIG_MODULE_SIG_HASH" "\"${OT_KERNEL_SIGN_MODULES,,}\""
	else
einfo "Using the manual setting for auto-signed modules"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_module_support
# @DESCRIPTION:
# Sets module support
ot-kernel_set_kconfig_module_support() {
	if [[ -z "${OT_KERNEL_MODULES_SUPPORT}" ]] ; then
einfo "Using manual settings for modules support"
	elif [[ "${OT_KERNEL_MODULES_SUPPORT}" =~ ("y"|"1") ]] \
		&& grep -q -e "^.*=m" "${BUILD_DIR}/.config" ; then
einfo "Modules support enabled"
		ot-kernel_y_configopt "CONFIG_MODULES"
	else
einfo "Modules support disabled"
		ot-kernel_unset_configopt "CONFIG_MODULES"
		ot-kernel_unset_configopt "CONFIG_MODULE_FORCE_LOAD"
		ot-kernel_unset_configopt "CONFIG_MODULE_UNLOAD"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_multigen_lru
# @DESCRIPTION:
# Sets the kernel config for Multi-Gen LRU
ot-kernel_set_kconfig_multigen_lru() {
	if ( has multigen_lru ${IUSE_EFFECTIVE} && ot-kernel_use multigen_lru ) \
		|| ( has zen-multigen_lru ${IUSE_EFFECTIVE} && ot-kernel_use zen-multigen_lru ) ; then
einfo "Changed .config to use Multi-Gen LRU"
		ot-kernel_y_configopt "CONFIG_LRU_GEN"
		ot-kernel_y_configopt "CONFIG_LRU_GEN_ENABLED"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_oflag
# @DESCRIPTION:
# Sets the kernel config for the compiler flag based on CFLAGS.
ot-kernel_set_kconfig_oflag() {
	ot-kernel_optimize_gaming_oflag
	ot-kernel_optimize_gaming_tornament_oflag
	ot-kernel_unset_configopt "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE"
	ot-kernel_unset_configopt "CONFIG_CC_OPTIMIZE_FOR_SIZE"
	ot-kernel_unset_configopt "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3"
	if [[ "${CFLAGS}" =~ "O3" ]] ; then
einfo "Setting .config with -O3 from CFLAGS"
		ot-kernel_y_configopt "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3"
	elif [[ "${CFLAGS}" =~ "O2" ]] ; then
einfo "Setting .config with -O2 from CFLAGS"
		ot-kernel_y_configopt "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE"
	elif [[ "${CFLAGS}" =~ "Os" ]] ; then
einfo "Setting .config with -Os from CFLAGS"
		ot-kernel_y_configopt "CONFIG_CC_OPTIMIZE_FOR_SIZE"
	else
einfo "Setting .config with -O2 from CFLAGS"
		ot-kernel_y_configopt "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_page_size
# @DESCRIPTION:
# Controls the page size.  This setting has security and performance
# implications.
# High values - lowered security, less page faults, more energy savings
# Low values - higher security, more overhead, more energy waste
ot-kernel_set_kconfig_page_size() {
	local page_size
	if [[ -n "${1}" ]] ; then
		page_size="${1}"
	else
		page_size="${OT_KERNEL_PAGE_SIZE:-custom}"
	fi
	if [[ "${page_size}" == "custom" || "${page_size}" =~ "disable" ]] ; then
		return
	fi
	if [[ "${arch}" == "alpha" ]] ; then
einfo "Page size:  8 KB"
	fi
	if [[ "${arch}" == "arm" ]] ; then
einfo "Page size:  4 KB"
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "default" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "pgsql" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_y_configopt "CONFIG_ARM64_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_ARM64_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_ARM64_64K_PAGES"
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "sql" \
		]] ; then
einfo "Page size:  16 KB"
			ot-kernel_unset_configopt "CONFIG_ARM64_4K_PAGES"
			ot-kernel_y_configopt "CONFIG_ARM64_16K_PAGES"
			ot-kernel_uset_configopt "CONFIG_ARM64_64K_PAGES"
		elif [[ \
			   "${page_size}" == "64" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "max" \
			|| "${page_size}" == "low-power" \
		]] ; then
einfo "Page size:  64 KB"
			ot-kernel_unset_configopt "CONFIG_ARM64_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_ARM64_16K_PAGES"
			ot-kernel_y_configopt "CONFIG_ARM64_64K_PAGES"
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 16, 64"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "ia64" ]] ; then
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_64KB"
		elif [[ \
			   "${page_size}" == "8" \
			|| "${page_size}" == "pgsql" \
		]] ; then
einfo "Page size:  8 KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_4KB"
			ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_64KB"
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "default" \
			|| "${page_size}" == "sql" \
		]] ; then
einfo "Page size:  16 KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_8KB"
			ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_64KB"
		elif [[ \
			"${page_size}" == "64" \
		]] ; then
einfo "Page size:  64 KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_64KB"

			if grep -q -E -e "^CONFIG_ITANIUM=y" "${path_config}" ; then
eerror
eerror "64 KB pages is not suppored for CONFIG_ITANIUM=y"
eerror
				die
			fi
		elif [[ \
			   "${page_size}" == "max" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "low-power" \
		]] ; then
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_IA64_PAGE_SIZE_64KB"

			if ! grep -q -E -e "^CONFIG_ITANIUM=y" "${path_config}" ; then
einfo "Page size:  64 KB"
				ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_64KB"
			else
einfo "Page size:  16 KB"
				ot-kernel_y_configopt "CONFIG_IA64_PAGE_SIZE_16KB"
			fi
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 8, 16, 64"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "loongarch" ]] ; then
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "pgsql" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_unset_configopt "CONFIG_4KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_4KB_4LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_3LEVEL"

			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_4LEVEL"

			if grep -q -E -e "^CONFIG_64BIT=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_4KB_3LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_4KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_3LEVEL"
			else
				ot-kernel_y_configopt "CONFIG_4KB_4LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_4KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_4LEVEL"
			fi
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "default" \
			|| "${page_size}" == "sql" \
		]] ; then
einfo "Page size:  16 KB"
			ot-kernel_unset_configopt "CONFIG_4KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_4KB_4LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_3LEVEL"

			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_4LEVEL"

			if grep -q -E -e "^CONFIG_64BIT=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_16KB_3LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_16KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_3LEVEL"
			else
				ot-kernel_y_configopt "CONFIG_16KB_2LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_16KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_2LEVEL"
			fi
		elif [[ \
			   "${page_size}" == "64" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "low-power" \
			|| "${page_size}" == "max" \
		]] ; then
einfo "Page size:  64 KB"
			ot-kernel_unset_configopt "CONFIG_4KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_4KB_4LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_16KB_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_64KB_3LEVEL"

			ot-kernel_unser_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_2LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_3LEVEL"
			ot-kernel_unset_configopt "CONFIG_PGTABLE_4LEVEL"

			if grep -q -E -e "^CONFIG_64BIT=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_64KB_2LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_64KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_2LEVEL"
			else
				ot-kernel_y_configopt "CONFIG_64KB_3LEVEL"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_64KB"
				ot-kernel_y_configopt "CONFIG_PGTABLE_3LEVEL"
			fi
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 16, 64"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "m68k" ]] ; then
		if grep -q -E -e "^CONFIG_SUN3=y" "${path_config}" \
		|| grep -q -E -e "^CONFIG_COLDFIRE=y" "${path_config}" ; then
einfo "Page size:  8 KB"
		else
einfo "Page size:  4 KB"
		fi
	fi
	if [[ "${arch}" == "parisc" || "${arch}" == "parisc64" ]] ; then
		# hppa
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "default" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "pgsql" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_y_configopt "CONFIG_PARISC_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_64KB"
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "sql" \
		]] ; then
			if grep -q -E -e "^CONFIG_PA8X00=y" "${path_config}" ; then
ewarn "Page size:  16 KB.  Marked broken upstream."
				ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_4KB"
				ot-kernel_y_configopt "CONFIG_PARISC_PAGE_SIZE_16KB"
				ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_64KB"
				ot-kernel_y_configopt "CONFIG_BROKEN"
			fi
		elif [[ \
			   "${page_size}" == "64" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "low-power" \
			|| "${page_size}" == "max" \
		]] ; then
			if grep -q -E -e "^CONFIG_PA8X00=y" "${path_config}" ; then
ewarn "Page size:  64 KB.  Marked broken upstream."
				ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_4KB"
				ot-kernel_unset_configopt "CONFIG_PARISC_PAGE_SIZE_16KB"
				ot-kernel_y_configopt "CONFIG_PARISC_PAGE_SIZE_64KB"
				ot-kernel_y_configopt "CONFIG_BROKEN"
			fi
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 16, 64"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "pgsql" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_y_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_256K_PAGES"
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "sql" \
		]] ; then
einfo "Page size:  16 KB"
			ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_y_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_256K_PAGES"
			if grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			|| grep -q -E -e "^CONFIG_PPC_8xx=y" "${path_config}" ; then
				:
			else
eerror
eerror "16 KB pages not supported and it requires CONFIG_44x=y or"
eerror "CONFIG_PPC_8xx=y"
eerror
				die
			fi
		elif [[ \
			   "${page_size}" == "64" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "low-power" \
		]] ; then
einfo "Page size:  64 KB"
			ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_y_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_256K_PAGES"
			if grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			|| grep -q -E -e "^CONFIG_PPC_BOOK3S_64=y" "${path_config}" ; then
				:
			else
eerror
eerror "64 KB pages not supported and it requires CONFIG_44x=y or"
eerror "CONFIG_PPC_BOOK3S_64=y"
eerror
				die
			fi
		elif [[ \
			"${page_size}" == "256" \
		]] ; then
ewarn
ewarn "Page size:  256 KB.  This requires a crossdev built binutils with"
ewarn "bfd/elf32-ppc.c modifications for MAXPAGESIZE=0x40000."
ewarn
ewarn "Please use 64 KB instead if the system was built with the distro's"
ewarn "stage3 tarball."
ewarn
			ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_y_configopt "CONFIG_PPC_256K_PAGES"
			if   grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			&& ! grep -q -E -e "^CONFIG_PPC_47x=y" "${path_config}" ; then
				:
			else
eerror
eerror "256 KB pages not supported and it requires CONFIG_44x=y and"
eerror "CONFIG_PPC_47x=n"
eerror
				die
			fi
		elif [[ \
			"${page_size}" == "default" \
		]] ; then
			ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_256K_PAGES"

			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_256KB"

			if grep -q -E -e "^CONFIG_PPC_BOOK3S_64=y" "${path_config}" ; then
einfo "Page size:  64 KB"
				ot-kernel_y_configopt "CONFIG_PPC_64K_PAGES"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_64KB"
			else
einfo "Page size:  4 KB"
				ot-kernel_y_configopt "CONFIG_PPC_4K_PAGES"
				ot-kernel_y_configopt "CONFIG_PAGE_SIZE_4KB"
			fi
		elif [[ \
			   "${page_size}" == "max" \
		]] ; then
			ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			ot-kernel_unset_configopt "CONFIG_PPC_256K_PAGES"
			if   grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			&& ! grep -q -E -e "^CONFIG_PPC_47x=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PPC_256K_PAGES"
ewarn
ewarn "Page size:  256 KB.  This requires a crossdev built binutils with"
ewarn "bfd/elf32-ppc.c modifications for MAXPAGESIZE=0x40000."
ewarn
ewarn "Please use 64 KB instead if the system was built with the distro's"
ewarn "stage3 tarball."
ewarn
			elif grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			||   grep -q -E -e "^CONFIG_PPC_BOOK3S_64=y" "${path_config}" ; then
				ot-kernel_unset_configopt "CONFIG_PPC_64K_PAGES"
			elif grep -q -E -e "^CONFIG_44x=y" "${path_config}" \
			||   grep -q -E -e "^CONFIG_PPC_8xx=y" "${path_config}" ; then
einfo "Page size:  16 KB"
				ot-kernel_unset_configopt "CONFIG_PPC_16K_PAGES"
			else
einfo "Page size:  4 KB"
				ot-kernel_unset_configopt "CONFIG_PPC_4K_PAGES"
			fi
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 16, 64, 256"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if [[ \
			   "${page_size}" == "4" \
			|| "${page_size}" == "compact" \
			|| "${page_size}" == "default" \
			|| "${page_size}" == "min" \
			|| "${page_size}" == "security" \
		]] ; then
einfo "Page size:  4 KB"
			ot-kernel_y_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_32KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"

			# Conflict
			ot-kernel_unset_configopt "CONFIG_CPU_MIPS32_R5_XPA"
ewarn
ewarn "Disabling CONFIG_CPU_MIPS32_R5_XPA.  This will affect allocation and"
ewarn "indexing."
ewarn

			if grep -q -E -e "^CONFIG_CPU_LOONGSON2=y" "${path_config}" ; then
eerror
eerror "4 KB pages are not suppored with CONFIG_CPU_LOONGSON2=y"
eerror
				die
			fi
			if grep -q -E -e "^CONFIG_CPU_LOONGSON3=y" "${path_config}" ; then
eerror
eerror "4 KB pages are not suppored with CONFIG_CPU_LOONGSON3=y"
eerror
				die
			fi
		elif [[ \
			   "${page_size}" == "8" \
			|| "${page_size}" == "pgsql" \
		]] ; then
einfo "Page size:  8 KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_y_configopt "CONFIG_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_32KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"

			# Conflict
			ot-kernel_unset_configopt "CONFIG_MIPS_VA_BITS_48"

			if ! grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
eerror
eerror "8 KB pages requires CONFIG_CPU_CAVIUM_OCTEON=y"
eerror
				die
			fi
		elif [[ \
			   "${page_size}" == "16" \
			|| "${page_size}" == "sql" \
		]] ; then
einfo "Page size:  16 KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_8KB"
			ot-kernel_y_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_32KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"

			if grep -q -E -e "^CONFIG_CPU_R3000=y" "${path_config}" ; then
eerror
eerror "16 KB pages is not suppored for CONFIG_CPU_R3000=y"
eerror
				die
			fi
			if grep -q -E -e "^CONFIG_CPU_TX39XX=y" "${path_config}" ; then
eerror
eerror "16 KB pages is not suppored for CONFIG_CPU_TX39XX=y"
eerror
				die
			fi
		elif [[ \
			"${page_size}" == "32" \
		]] ; then
einfo "Page size:  32 KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_y_configopt "CONFIG_PAGE_SIZE_32KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_64KB"

			# Conflict
			ot-kernel_unset_configopt "CONFIG_MIPS_VA_BITS_48"

			if ! grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
eerror
eerror "8 KB pages requires CONFIG_CPU_CAVIUM_OCTEON=y"
eerror
				die
			fi
		elif [[ \
			   "${page_size}" == "64" \
			|| "${page_size}" == "big-data" \
			|| "${page_size}" == "low-power" \
			|| "${page_size}" == "max" \
		]] ; then
einfo "Page size:  64 KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_4KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_8KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_16KB"
			ot-kernel_unset_configopt "CONFIG_PAGE_SIZE_32KB"
			ot-kernel_y_configopt "CONFIG_PAGE_SIZE_64KB"

			if grep -q -E -e "^CONFIG_CPU_R3000=y" "${path_config}" ; then
eerror
eerror "64 KB pages is not suppored for CONFIG_CPU_R3000=y"
eerror
				die
			fi
			if grep -q -E -e "^CONFIG_CPU_TX39XX=y" "${path_config}" ; then
eerror
eerror "64 KB pages is not suppored for CONFIG_CPU_TX39XX=y"
eerror
				die
			fi
		else
eerror
eerror "Incorrect value for OT_KERNEL_PAGE_SIZE."
eerror
eerror "Actual:  ${OT_KERNEL_PAGE_SIZE}"
eerror "Expected:  default, min, max, big-data, security, low-power, 4, 8, 16, 64"
eerror
			die
		fi
	fi
	if [[ "${arch}" == "riscv" ]] ; then
einfo "Page size:  4 KB"
	fi
	if [[ "${arch}" == "s390" ]] ; then
einfo "Page size:  4 KB"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc32" || "${arch}" == "sparc64" ]] ; then
# Based on the compiler
		if tc-cpp-is-true "defined(__sparc__) && defined(__arch64__)" ; then
einfo "Page size:  8 KB" # 64-bit
		else
einfo "Page size:  4 KB" # 32-bit
		fi
	fi
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
einfo "Page size:  4 KB"
	fi
	if [[ -n "${AMDGPU_VM_FRAGMENT_SIZE}" ]] ; then
		ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=(-1|4|5|6|7|8|9)"
		if [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "clear" ]] ; then
einfo "amdgpu.vm_fragment_size:   (autodetect, cleared)"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "-1" ]] ; then
einfo "amdgpu.vm_fragment_size:  -1 (autodetect)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=-1"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "4" ]] ; then
einfo "amdgpu.vm_fragment_size:  4 (4 KB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=4"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "5" ]] ; then
einfo "amdgpu.vm_fragment_size:  5 (128 KB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=5"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "6" ]] ; then
einfo "amdgpu.vm_fragment_size:  6 (256 KB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=6"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "7" ]] ; then
einfo "amdgpu.vm_fragment_size:  7 (512 KB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=7"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "8" ]] ; then
einfo "amdgpu.vm_fragment_size:  8 (1 MB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=8"
		elif [[ "${AMDGPU_VM_FRAGMENT_SIZE}" == "9" ]] ; then
einfo "amdgpu.vm_fragment_size:  9 (2 MB)"
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=9"
		else
einfo "amdgpu.vm_fragment_size:   (autodetect, default)"
		fi
	else
		ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.vm_fragment_size=(-1|4|5|6|7|8|9)"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_pcie_mps
# @DESCRIPTION:
# Sets the kernel config for MPS (Max Payload Size) for performance or stability
ot-kernel_set_kconfig_pcie_mps() {
	grep -q -E -e "^CONFIG_PCI=y" "${path_config}" || return
	if [[ "${OT_KERNEL_PCIE_MPS}" =~ ("p2p-safe"|"hotplug-safe") ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_BUS_PEER2PEER"
	elif [[ "${OT_KERNEL_PCIE_MPS}" == "performance" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_BUS_PERFORMANCE"
	elif [[ "${OT_KERNEL_PCIE_MPS}" == "safe" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_BUS_SAFE"
	elif [[ "${OT_KERNEL_PCIE_MPS}" =~ ("default"|"hotplug-optimal") ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_BUS_DEFAULT"
	elif [[ "${OT_KERNEL_PCIE_MPS}" == "bios" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_BUS_TUNE_OFF"
	fi
}

# @FUNCTION: _ot-kernel_disable_clang_pgi
# @DESCRIPTION:
# Disable clang -fprofile-generate
_ot-kernel_disable_clang_pgi() {
	if [[ "${NEEDS_DEBUGFS}" == "1" ]] ; then
ewarn "debugfs disabled failed.  Unfortunately, a package still requires it."
	else
einfo "debugfs disabled success"
		ot-kernel_unset_configopt "CONFIG_DEBUG_FS"
	fi

	ot-kernel_unset_configopt "CONFIG_PGO_CLANG"
}

# @FUNCTION: ot-kernel_set_kconfig_clang
# @DESCRIPTION:
# Sets the kernel config for Profile Guided Optimizations (PGO) for the configure phase.
_ot-kernel_set_kconfig_pgo_clang() {
	local pgo_compiler_fingerprint_file="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/compiler_fingerprint"
	local pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/pgophase"
	local profraw_dpath="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/vmlinux.profraw"
	local profdata_dpath="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/vmlinux.profdata"
	if has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo ; then
		(( ${llvm_slot} < 13 )) && die "PGO requires LLVM >= 13"
		local clang_pv=$(clang-${llvm_slot} --version | head -n 1 | cut -f 3 -d " ")
		local clang_pv_major=$(echo "${clang_pv}" | cut -f 1 -d ".")
		#ot-kernel_y_configopt "CONFIG_PGO_CLANG_LLVM_SELECT"
		ot-kernel_n_configopt "CONFIG_PROFRAW_V8" # Reset
		ot-kernel_n_configopt "CONFIG_PROFRAW_V7_LLVM14"
		ot-kernel_n_configopt "CONFIG_PROFRAW_V7_LLVM13"
		ot-kernel_n_configopt "CONFIG_PROFRAW_V6"
		ot-kernel_n_configopt "CONFIG_PROFRAW_V5"
		# See grep -r -e "INSTR_PROF_RAW_VERSION" /usr/lib/llvm/${llvm_slot}/include/llvm/ProfileData/InstrProfData.inc
		if (( ${llvm_slot} == 19 && ${clang_pv_major} == 19 )) ; then
einfo "Using profraw v9 for LLVM 19"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V9"
		elif (( ${llvm_slot} == 18 && ${clang_pv_major} == 18 )) ; then
einfo "Using profraw v9 for LLVM 18"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V9"
		elif (( ${llvm_slot} == 17 && ${clang_pv_major} == 17 )) ; then
einfo "Using profraw v8 for == LLVM 17"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 16 && ${clang_pv_major} == 16 )) ; then
einfo "Using profraw v8 for == LLVM 16"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 15 && ${clang_pv_major} == 15 )) ; then
einfo "Using profraw v8 for == LLVM 15"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.6" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.5" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.4" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.3" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.2" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.1" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 14 && ${clang_pv_major} == 14 )) && ot-kernel_has_version "~sys-devel/clang-14.0.0" ; then
einfo "Using profraw v8 for LLVM 14"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V8"
		elif (( ${llvm_slot} == 13 && ${clang_pv_major} == 13 )) && ot-kernel_has_version "~sys-devel/clang-13.0.1" ; then
einfo "Using profraw v7 for LLVM 13"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V7"
		elif (( ${llvm_slot} == 13 && ${clang_pv_major} == 13 )) && ot-kernel_has_version "~sys-devel/clang-13.0.0" ; then
einfo "Using profraw v7 for LLVM 13"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V7"
		elif (( ${llvm_slot} <= 12 && ${clang_pv_major} == 12 )) && ot-kernel_has_version "~sys-devel/clang-12.0.1" ; then
einfo "Using profraw v5 for LLVM 12"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V5"
		elif (( ${llvm_slot} <= 12 && ${clang_pv_major} == 11 )) && ot-kernel_has_version "~sys-devel/clang-11.1.0" ; then
einfo "Using profraw v5 for LLVM 11"
			ot-kernel_y_configopt "CONFIG_PROFRAW_V5"
		else
eerror
eerror "PGO is not supported for ${clang_pv}.  Ask the ebuild maintainer to"
eerror "update ot-kernel.eclass with the exact version to match the profraw"
eerror "version, or update the patch for a newer profraw format. Currently only"
eerror "profraw versions 5 to 8 are support."
eerror
			die
		fi

		if [[ -n "${FORCE_PGO_PHASE}" ]] ; then
			pgo_phase="${FORCE_PGO_PHASE}"
		elif [[ -e "${pgo_phase_statefile}" ]] ; then
			pgo_phase=$(cat "${pgo_phase_statefile}")
		else
			pgo_phase="${PGO_PHASE_PGI}"
		fi
		# Convert deprecated
		[[ "${pgo_phase}" == "PDI" ]] && pgo_phase="PGI"
		[[ "${pgo_phase}" == "PDT" ]] && pgo_phase="PGT"
		[[ "${pgo_phase}" == "PDO" ]] && pgo_phase="PGO"
		[[ "${pgo_phase}" == "PD0" ]] && pgo_phase="PG0"

		if [[ -e "${profdata_dpath}" ]] ; then
			local clang_slot=$(clang-major-version)
			local sys_index_ver=$(grep -E \
				-e "INSTR_PROF_INDEX_VERSION [0-9]+" \
				"${ESYSROOT}/usr/lib/llvm/${clang_slot}/include/llvm/ProfileData/InstrProfData.inc" \
				| cut -f 3 -d " ")
			local pgo_slot="${sys_index_ver}" # For stable ABI.
			local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
			local actual="${pgo_slot};${ABI};${triple}"
			local expected=$(cat "${profdata_dpath}")
			if [[ "${actual}" != "${expected}" ]] ; then
einfo "Detected compiler mismatch.  Restarting at PGI."
				pgo_phase="${PGO_PHASE_PGI}" # Restart
			fi
		fi

#
#            R          R          R                       R    = Resume
#	    ___        ___        ___                      S    = Start
#	    | V        | V        | V                     V(p) = Verify it is the same compiler major.minor or PGO profile compatibility of that phase
#	S-> PGI -----> PGT        PGO ------> DONE
#           ^          |            ^         |  ^
#           |          |            | y       |  |
#           |          |            |         |  | R|y
#           |          |----------> v(p) <----|  |
#           |                       | |          |
#           |_______________________| +----------+
#                      n
#
		if [[ "${pgo_phase}" == "${PGO_PHASE_PGI}" ]] ; then
einfo "Forcing PGI flags and config"
			ot-kernel_y_configopt "CONFIG_CC_HAS_NO_PROFILE_FN_ATTR"
			ot-kernel_y_configopt "CONFIG_CC_IS_CLANG"
			ot-kernel_y_configopt "CONFIG_DEBUG_FS"
			ot-kernel_y_configopt "CONFIG_PGO_CLANG"
ewarn
ewarn "The pgo USE flag uses debugfs and is a developer only config option.  It"
ewarn "should be disabled to prevent abuse and a possible prerequisite for"
ewarn "attacks.  It may be disabled in the PGO step if no dependency on this"
ewarn "kernel option."
ewarn

	# For ot_kernel_pgt_memory
			ot-kernel_set_kconfig_dmesg "default"

	# For profile compatibility checks
	# Profile compatibility based on either specific .profraw version or
	# flexible merged .prodata version.
			local clang_slot=$(clang-major-version)
			local sys_index_ver=$(grep -E \
				-e "INSTR_PROF_INDEX_VERSION [0-9]+" \
				"${ESYSROOT}/usr/lib/llvm/${clang_slot}/include/llvm/ProfileData/InstrProfData.inc" \
				| cut -f 3 -d " ")
			local pgo_slot="${sys_index_ver}" # For stable ABI.
			local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
			local fingerprint="${pgo_slot};${ABI};${triple}"
			mkdir -p $(dirname "${pgo_compiler_fingerprint_file}")
			echo "${fingerprint}" > "${pgo_compiler_fingerprint_file}"
		elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGO}"|"${PGO_PHASE_PGT}"|"${PGO_PHASE_DONE}") && -e "${profdata_dpath}" ]] ; then
einfo "Forcing PGO flags and config"
			_ot-kernel_disable_clang_pgi
		fi
	fi
}

# @FUNCTION: _ot-kernel_get_build_time
# @DESCRIPTION:
# Gets the build time
_ot-kernel_get_build_time() {
# Same as portageq metadata "/${BROOT}" "installed" "sys-devel/gcc-${raw_pv}" "BUILD_TIME"
	local root="${1}"
	local p="${2}"
	local fn="${3}"
	local f="/${BROOT}/var/db/pkg/sys-devel/gcc-${raw_pv}/BUILD_TIME"
	if [[ -e "${f}" ]] ; then
		cat "${f}"
	else
		echo "0"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_gcc
# @DESCRIPTION:
# Sets the kernel config for Profile Guided Optimizations (PGO) for the configure phase.
_ot-kernel_set_kconfig_pgo_gcc() {
	local pgo_compiler_fingerprint_file="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc/compiler_fingerprint"
	local pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc/pgophase"
	local n_gcda=$(find "${WORKDIR}/pgodata/${extraversion}-${arch}/gcc" -name "*.gcda" 2>/dev/null | wc -l)
	[[ -z "${n_gcda}" ]] && n_gcda=0
	if [[ -n "${FORCE_PGO_PHASE}" ]] ; then
		pgo_phase="${FORCE_PGO_PHASE}"
	elif [[ -e "${pgo_phase_statefile}" ]] ; then
		pgo_phase=$(cat "${pgo_phase_statefile}")
	else
		pgo_phase="${PGO_PHASE_PGI}"
	fi
	# Convert deprecated
	[[ "${pgo_phase}" == "PDI" ]] && pgo_phase="PGI"
	[[ "${pgo_phase}" == "PDT" ]] && pgo_phase="PGT"
	[[ "${pgo_phase}" == "PDO" ]] && pgo_phase="PGO"
	[[ "${pgo_phase}" == "PD0" ]] && pgo_phase="PG0"
#
#            R          R          R                       R    = Resume
#	    ___        ___        ___                      S    = Start
#	    | V        | V        | V                     V(p) = Verify it is the same compiler major.minor or PGO profile compatibility of that phase
#	S-> PGI -----> PGT        PGO ------> DONE
#           ^          |            ^         |  ^
#           |          |            | y       |  |
#           |          |            |         |  | R|y
#           |          |----------> v(p) <----|  |
#           |                       | |          |
#           |_______________________| +----------+
#                      n

	if [[ -e "${pgo_compiler_fingerprint_file}" ]] ; then
		local compile_major_pv="$(gcc-major-version)"
		local compiler_pv="$(gcc-version)" # major.minor
		local raw_pv=$(best_version "=sys-devel/gcc-${compile_major_pv}*" \
			| sed -e "s|sys-devel/gcc-||g")
		local pgo_slot=$(ver_cut 1-2 "${compiler_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live unstable ABI.
			local build_timestamp=$(_ot-kernel_get_build_time)
			pgo_slot="${raw_pv}-${build_timestamp}"
		elif [[ "${raw_pv}" =~ "_pre" ]] ; then
			# Live snapshot with unstable ABI.
			pgo_slot="${raw_pv}"
		#elif [[ "${raw_pv}" =~ "_p"[0-9]+ ]] ; then
			# Weekly snapshot of a stable branch.  ABI change unlikely.
		fi
		local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
		local actual="${pgo_slot};${ABI};${triple}"
		local expected=$(cat "${pgo_compiler_fingerprint_file}")
		if [[ "${actual}" != "${expected}" ]] ; then
einfo "Detected compiler mismatch.  Restarting at PGI."
			pgo_phase="${PGO_PHASE_PGI}"
		fi
	fi

	if [[ "${pgo_phase}" == "${PGO_PHASE_PGI}" ]] ; then
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		ot-kernel_y_configopt "CONFIG_GCOV_KERNEL"
		ot-kernel_y_configopt "CONFIG_GCOV_PROFILE_ALL"
		if ver_test ${KV_MAJOR_MINOR} -le 4.17 ; then
			ot-kernel_y_configopt "CONFIG_GCOV_FORMAT_AUTODETECT"
		fi
		ot-kernel_n_configopt "CONFIG_COMPILE_TEST"

	# For profile compatibility checks
	# Profile compatibility based on a bytestring of the compiler version.
	# 1 byte contains the hexadecimal major version.
	# 2 bytes contains the minor version.
	# 1 byte contains e for experimental build, or R for release version.
	# Examples:
	# 400e - 4.00.x experimental
	# A01R - 10.1.x release
		local compile_major_pv="$(gcc-major-version)"
		local compiler_pv="$(gcc-version)" # major.minor
		local raw_pv=$(best_version "=sys-devel/gcc-${compile_major_pv}*" \
			| sed -e "s|sys-devel/gcc-||g")
		local pgo_slot=$(ver_cut 1-2 "${compiler_pv}") # For stable ABI.
		if [[ "${raw_pv}" =~ "9999" ]] ; then
			# Live unstable ABI.
			local build_timestamp=$(_ot-kernel_get_build_time)
			pgo_slot="${raw_pv}-${build_timestamp}"
		elif [[ "${raw_pv}" =~ "_pre" ]] ; then
			# Live snapshot with unstable ABI.
			pgo_slot="${raw_pv}"
		#elif [[ "${raw_pv}" =~ "_p"[0-9]+ ]] ; then
			# Weekly snapshot of a stable branch.  ABI change unlikely.
		fi
		local triple=$(${CC} -dumpmachine) # For ABI and LIBC consistency.
		local fingerprint="${pgo_slot};${ABI};${triple}"
		mkdir -p $(dirname "${pgo_compiler_fingerprint_file}")
		echo "${fingerprint}" > "${pgo_compiler_fingerprint_file}"
	elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGO}"|"${PGO_PHASE_PGT}"|"${PGO_PHASE_DONE}") ]] && (( ${n_gcda} > 0 )) ; then
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		ot-kernel_n_configopt "CONFIG_GCOV_KERNEL"
		ot-kernel_n_configopt "CONFIG_GCOV_PROFILE_ALL"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_pgo
# @DESCRIPTION:
# Sets the kernel config for Profile Guided Optimizations (PGO) for the configure phase.
ot-kernel_set_kconfig_pgo() {
	if use pgo ; then
		:
	else
		return
	fi
	if has clang ${IUSE_EFFECTIVE} && use clang ; then
		_ot-kernel_set_kconfig_pgo_clang
	else
		_ot-kernel_set_kconfig_pgo_gcc
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_processor_class
# @DESCRIPTION:
# Sets the kernel config for the processor_class
ot-kernel_set_kconfig_processor_class() {
	local processor_class="${OT_KERNEL_PROCESSOR_CLASS,,}"
	if [[ -z "${processor_class}" ]] ; then
		:
	elif [[ \
		   "${processor_class}" == "custom" \
		|| "${processor_class}" == "manual" \
	]] ; then
		:
	elif [[ \
		   "${processor_class}" == "auto" \
	]] ; then
		local ncpus=$(lscpu | grep "CPU(s):" \
			| head -n 1 \
			| grep -o -E -e "[0-9]+") # ncores * nsockets * tpc
		local ncores=$(lscpu \
			| grep "Core(s) per socket:" \
			| head -n 1 \
			| grep -o -E -e "[0-9]+")
		local nsockets=$(lscpu \
			| grep "Socket(s):" \
			| head -n 1 \
			| grep -o -E -e "[0-9]+")
		local tpc=$(lscpu \
			| grep "Thread(s) per core:" \
			| head -n 1 \
			| grep -o -E -e "[0-9]+")
		local n_numa_nodes=$(lscpu \
			| grep "NUMA node(s):" \
			| head -n 1 \
			| grep -o -E -e "[0-9]+")
		if (( ${ncpus} > 1 )) ; then
			ot-kernel_y_configopt "CONFIG_SMP"
		else
			ot-kernel_unset_configopt "CONFIG_SMP"
		fi
		if (( ${ncores} > 1 )) ; then
			ot-kernel_y_configopt "CONFIG_SCHED_MC"
		fi
		if (( ${nsockets} > 1 )) ; then
			ot-kernel_y_configopt "CONFIG_NUMA"
			if [[ "${arch}" == "x86_64" ]] ; then
				ot-kernel_y_configopt "CONFIG_X86_64_ACPI_NUMA"
			fi
			ot-kernel_set_configopt "CONFIG_NODES_SHIFT" \
				$(python -c "import math; print(math.ceil(math.log(${nsockets})/math.log(2)))")
		fi
	elif [[ \
		   "${processor_class}" == "unicore" \
		|| "${processor_class}" == "uniprocessor" \
	]] ; then
		ot-kernel_unset_configopt "CONFIG_NUMA"
		ot-kernel_unset_configopt "CONFIG_SCHED_MC"
		ot-kernel_unset_configopt "CONFIG_SMP"
	elif [[ \
		   "${processor_class}" == "smp" \
		|| "${processor_class}" == "smp-legacy" \
		|| "${processor_class}" == "smp-unicore" \
	]] ; then
		ot-kernel_unset_configopt "CONFIG_NUMA"
		ot-kernel_unset_configopt "CONFIG_SCHED_MC"
		ot-kernel_y_configopt "CONFIG_SMP"
	elif [[ \
		   "${processor_class}" == "multicore" \
		|| "${processor_class}" == "multicore-smt" \
	]] ; then
		ot-kernel_unset_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_SCHED_MC"
		ot-kernel_y_configopt "CONFIG_SMP"
	elif [[ \
		   "${processor_class}" == "numa-unicore" \
	]] ; then
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_unset_configopt "CONFIG_SCHED_MC"
		ot-kernel_y_configopt "CONFIG_SMP"
	elif [[ \
		   "${processor_class}" == "numa" \
		|| "${processor_class}" == "numa-multicore" \
	]] ; then
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_SCHED_MC"
		ot-kernel_y_configopt "CONFIG_SMP"
	fi
	[[ -z "${processor_class}" ]] && processor_class="not set (manual)"
einfo "Processor class is ${processor_class}"
	local ncpus="${OT_KERNEL_N_CPUS}"
	if [[ "${ncpus}" == "auto" ]] ; then
		ncpus=$(lscpu | grep "CPU(s):" | head -n 1 | grep -o -E -e "[0-9]+")
		ot-kernel_set_configopt "CONFIG_NR_CPUS" "${ncpus}"
	elif [[ -n "${ncpus}" ]] ; then
		ot-kernel_set_configopt "CONFIG_NR_CPUS" "${ncpus}"
	fi
	ncpus=$(grep -r -e "CONFIG_NR_CPUS=" "${BUILD_DIR}/.config" | grep -o -E -e "[0-9]+")
einfo "Processor count maximum:  ${ncpus}"
}

# @FUNCTION: _ot-kernel_validate_hardening_level
# @DESCRIPTION:
# Check settings
_ot-kernel_validate_hardening_level() {
	if [[ -z "${hardening_level}" ]] ; then
eerror
eerror "QA:  Set hardening_level from OT_KERNEL_HARDENING_LEVEL."
eerror
		die
	fi
	if [[ \
		   "${hardening_level}" == "custom" \
		|| "${hardening_level}" == "default" \
		|| "${hardening_level}" == "fast" \
		|| "${hardening_level}" == "fast-af" \
		|| "${hardening_level}" == "fast-as-fuck" \
		|| "${hardening_level}" == "manual" \
		|| "${hardening_level}" == "performance" \
		|| "${hardening_level}" == "practical" \
		|| "${hardening_level}" == "secure" \
		|| "${hardening_level}" == "secure-af" \
		|| "${hardening_level}" == "secure-as-fuck" \
	]] ; then
		:
	else
eerror
eerror "OT_KERNEL_HARDENING_LEVEL is invalid."
eerror
eerror "Acceptable values:"
eerror
eerror "  custom      - User defined setting"
eerror "  default     - Upstream defaults, practically secure"
eerror "  manual      - Alias for custom"
eerror "  performance - All mitigations disabled"
eerror "  practical   - Practically secure or balanced security-performance (same as upstream defaults, alias for default)"
eerror "  secure-af   - Mitigation against theoretical attacks, difficult to achieve attacks, data exfiltration"
eerror
eerror "Actual value:"
eerror
eerror "  ${hardening_level}"
eerror
		die
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_scs
# @DESCRIPTION:
# Sets the kernel config for ShadowCallStack (SCS)
ot-kernel_set_kconfig_scs() {
	_ot-kernel_validate_hardening_level
	if \
		[[ \
			   "${hardening_level}" == "custom" \
			|| "${hardening_level}" == "manual" \
		]] \
	; then
		:
	elif \
		[[ \
			   "${hardening_level}" == "default" \
			|| "${hardening_level}" == "practical" \
			|| "${hardening_level}" == "secure" \
		]] \
	; then
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG_SHADOW"
	elif \
		[[ \
			   "${hardening_level}" == "secure" \
			|| "${hardening_level}" == "secure-af" \
			|| "${hardening_level}" == "secure-as-fuck" \
		]] \
			&& \
		has shadowcallstack ${IUSE_EFFECTIVE} && ot-kernel_use shadowcallstack \
			&& \
		[[ "${arch}" == "arm64" ]] \
	; then
		if (( ${llvm_slot} < 10 )) ; then
eerror
eerror "Shadow call stack (SCS) requires LLVM >= 10"
eerror
			die
		fi
einfo "Enabling SCS support in the in the .config."
		ot-kernel_y_configopt "CONFIG_CFI_CLANG_SHADOW"
		ot-kernel_y_configopt "CONFIG_MODULES"
	elif \
		[[ \
			   "${hardening_level}" == "fast" \
			|| "${hardening_level}" == "fast-af" \
			|| "${hardening_level}" == "fast-as-fuck" \
			|| "${hardening_level}" == "performance" \
		]] \
	; then
einfo "Disabling SCS support in the in the .config."
		ot-kernel_unset_configopt "CONFIG_CFI_CLANG_SHADOW"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_slab_allocator
# @DESCRIPTION:
# Sets the kernel config for a slab allocator
ot-kernel_set_kconfig_slab_allocator() {
	local alloc_name="${1^^}"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	local slub_tiny=0
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.8" ; then
		alloc_name="SLUB"
		if [[ "${alloc_name}" == "SLAB" ]] ; then
ewarn "Changing SLAB -> SLUB.  SLAB has been removed.  Please update OT_KERNEL_SLAB_ALLOCATOR"
			alloc_name="SLUB"
		elif [[ "${alloc_name}" == "SLOB" ]] ; then
ewarn "Changing SLOB -> SLUB_TINY.  SLOB has been removed.  Please update OT_KERNEL_SLAB_ALLOCATOR"
			alloc_name="SLUB"
			slub_tiny=1
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "6.7" ; then
		if [[ "${alloc_name}" == "SLAB" ]] ; then
			alloc_name="SLAB_DEPRECATED"
		elif [[ "${alloc_name}" == "SLOB" ]] ; then
ewarn "Changing SLOB -> SLUB_TINY.  SLOB has been removed.  Please update OT_KERNEL_SLAB_ALLOCATOR"
			alloc_name="SLUB"
			slub_tiny=1
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "6.5" ; then
		if [[ "${alloc_name}" == "SLAB" ]] ; then
			alloc_name="SLAB_DEPRECATED"
		elif [[ "${alloc_name}" == "SLOB" ]] ; then
ewarn "Changing SLOB -> SLUB_TINY.  SLOB has been removed.  Please update OT_KERNEL_SLAB_ALLOCATOR"
			alloc_name="SLUB"
			slub_tiny=1
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "6.4" ; then
		if [[ "${alloc_name}" == "SLOB" ]] ; then
ewarn "Changing SLOB -> SLUB_TINY.  SLOB has been removed.  Please update OT_KERNEL_SLAB_ALLOCATOR"
			alloc_name="SLUB"
			slub_tiny=1
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "6.2" ; then
		if [[ "${alloc_name}" == "SLOB" ]] ; then
			alloc_name="SLOB_DEPRECATED"
		fi
	fi
	[[ "${alloc_name}" == "SLUB-TINY" ]] && slub_tiny=1
	ot-kernel_unset_configopt "CONFIG_SLUB_CPU_PARTIAL"
	ot-kernel_unset_configopt "CONFIG_SLUB_TINY"
	ot-kernel_unset_configopt "CONFIG_SLAB" # For cache benefits, < ~2% CPU usage and >= ~10% network throughput compared to slub
	ot-kernel_unset_configopt "CONFIG_SLAB_DEPRECATED"
	ot-kernel_unset_configopt "CONFIG_SLUB" # For mainframes
	ot-kernel_unset_configopt "CONFIG_SLOB" # For embedded
	ot-kernel_unset_configopt "CONFIG_SLOB_DEPRECATED"
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.2" && (( ${slub_tiny} == 1 )) ; then
		alloc_name="SLUB"
		ot-kernel_y_configopt "CONFIG_SLUB_TINY"
	fi

	ot-kernel_y_configopt "CONFIG_${alloc_name}"
einfo "Using ${alloc_name}"
	if [[ "${alloc_name}" == "SLUB" ]] ; then
		ot-kernel_y_configopt "CONFIG_SLUB_CPU_PARTIAL"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_auto_set_slab_allocator
# @DESCRIPTION:
# Auto sets the slab allocator
ot-kernel_set_kconfig_auto_set_slab_allocator() {
	local slab_allocator="${OT_KERNEL_SLAB_ALLOCATOR:-auto}"
	if [[ "${slab_allocator}" =~ ("custom"|"manual") ]] ; then
		local x=$(grep -E -e "CONFIG_(SLAB|SLOB|SLUB|SLAB_DEPRECATED|SLOB_DEPRECATED)=y" "${BUILD_DIR}/.config" \
			| cut -f 2 -d "_" \
			| cut -f "1" -d "=")
einfo "Using ${x}"
	elif [[ "${slab_allocator}" == "auto" ]] ; then
		if grep -q -E -e "^CONFIG_EMBEDDED=y" "${path_config}" ; then
			if ver_test "${KV_MAJOR_MINOR}" -lt 6.4 ; then
				ot-kernel_set_kconfig_slab_allocator "slob"
			else
				ot-kernel_set_kconfig_slab_allocator "slub"
			fi
		elif grep -q -E -e "^CONFIG_NUMA=y" "${path_config}" \
			|| [[ "${processor_class}" =~ "numa" ]] ; then
			ot-kernel_set_kconfig_slab_allocator "slub"
		else
			ot-kernel_set_kconfig_slab_allocator "slub"
		fi
	elif [[ \
		   "${slab_allocator}" == "slab" \
		|| "${slab_allocator}" == "slob" \
		|| "${slab_allocator}" == "slub" \
		|| "${slab_allocator}" == "slub-tiny" \
	]] ; then
		ot-kernel_set_kconfig_slab_allocator "${slab_allocator}"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_swap
# @DESCRIPTION:
# Sets the kernel config for swap file support
ot-kernel_set_kconfig_swap() {
	[[ "${_OT_KERNEL_FORCE_SWAP_OFF}" == "1" ]] && OT_KERNEL_SWAP="0"
	if [[ "${OT_KERNEL_SWAP}" == "1" || "${OT_KERNEL_SWAP^^}" == "Y" ]] ; then
einfo "Swap enabled"
		ot-kernel_y_configopt "CONFIG_SWAP"
	elif [[ "${OT_KERNEL_SWAP}" == "0" || "${OT_KERNEL_SWAP^^}" == "N" ]] ; then
einfo "Swap disabled"
		ot-kernel_unset_configopt "CONFIG_SWAP"
	else
einfo "Using manual swap settings"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_tresor
# @DESCRIPTION:
# Sets the kernel config for TRESOR
ot-kernel_set_kconfig_tresor() {
	if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor && [[ "${arch}" == "x86" ]] ; then
einfo "Changed .config to use TRESOR (i686)"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AES"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER2"
		if ot-kernel_use tresor_prompt ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR_PROMPT" # default on upstream
einfo "Disabling boot output for TRESOR early prompt."
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_DEFAULT" "2" # 7 is default
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_QUIET" "2" # 4 is default
			ot-kernel_set_configopt "CONFIG_MESSAGE_LOGLEVEL_DEFAULT" "2" # 4 is default
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor && [[ "${arch}" == "x86_64" ]] ; then
einfo "Changed .config to use TRESOR (x86_64)"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AES"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER2"
		if ot-kernel_use tresor_prompt ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR_PROMPT" # default on upstream
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor && [[ "${arch}" == "x86_64" ]] && ot-kernel_use cpu_flags_x86_aes ; then
einfo "Changed .config to use TRESOR (AES-NI)"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER2"
		if ot-kernel_use tresor_prompt ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR_PROMPT" # default on upstream
		fi
	fi

	if has tresor_sysfs ${IUSE_EFFECTIVE} && ot-kernel_use tresor_sysfs && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
einfo "Changed .config to use the TRESOR sysfs interface"
		ot-kernel_y_configopt "CONFIG_CRYPTO_TRESOR_SYSFS"

ewarn
ewarn "The sysfs interface for TRESOR is not compatible with suspend or"
ewarn "hibernation, so disabling both of these."
ewarn
		ot-kernel_n_configopt "CONFIG_SUSPEND"
		ot-kernel_n_configopt "CONFIG_HIBERNATION"
	fi

	if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor && [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use tresor_prompt ; then
einfo "Disabling boot output for TRESOR early prompt."
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_DEFAULT" "2" # 7 is default
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_QUIET" "2" # 4 is default
			ot-kernel_set_configopt "CONFIG_MESSAGE_LOGLEVEL_DEFAULT" "2" # 4 is default
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_uksm
# @DESCRIPTION:
# Sets the kernel config for UKSM
ot-kernel_set_kconfig_uksm() {
	[[ "${_OT_KERNEL_FORCE_SWAP_OFF}" == "1" ]] && OT_KERNEL_SWAP=0
	if [[ "${OT_KERNEL_SWAP}" == "0" || "${OT_KERNEL_SWAP^^}" == "N" ]] ; then
einfo "Disabling UKSM"
		ot-kernel_unset_configopt "CONFIG_KSM"
		ot-kernel_unset_configopt "CONFIG_UKSM"
		if has uksm ${IUSE_EFFECTIVE} && ot-kernel_use uksm ; then
eerror
eerror "Please remove uksm from OT_KERNEL_USE for OT_KERNEL_USE=\"uksm\" for"
eerror "OT_KERNEL_SWAP=\"0\"."
eerror
			die
		fi

		return
	fi
	if has uksm ${IUSE_EFFECTIVE} && ot-kernel_use uksm && has rt ${IUSE_EFFECTIVE} && ot-kernel_use rt ; then
eerror
eerror "Please remove uksm from OT_KERNEL_USE for OT_KERNEL_USE=\"rt\" for"
eerror "OT_KERNEL_EXTRAVERSION=\"${extraversion}\"."
eerror
		die
	fi
	if has uksm ${IUSE_EFFECTIVE} && ot-kernel_use uksm ; then
einfo "Changed .config to use UKSM"
		ot-kernel_y_configopt "CONFIG_KSM"
		ot-kernel_y_configopt "CONFIG_UKSM"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_usb_autosuspend
# @DESCRIPTION:
# Sets the kernel config for USB autosuspend
ot-kernel_set_kconfig_usb_autosuspend() {
	[[ -z "${OT_KERNEL_USB_AUTOSUSPEND}" ]] && return
	if (( "${OT_KERNEL_USB_AUTOSUSPEND:-2}" > -1 )) ; then
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_configopt "CONFIG_USB_AUTOSUSPEND_DELAY" "${OT_KERNEL_USB_AUTOSUSPEND}"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_usb_flash_disk
# @DESCRIPTION:
# Sets kernel config the USB flash disks
ot-kernel_set_kconfig_usb_flash_disk() {
	local usb_flash=0
	if [[ "${USB_FLASH_EXT2:-0}" == "1" ]] ; then
einfo "Adding EXT2 support"
		usb_flash=1
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_EXT2_FS"
	fi
	if [[ "${USB_FLASH_EXT4:-1}" == "1" ]] ; then
einfo "Adding EXT4 support"
		usb_flash=1
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_EXT4_FS"
	fi
	if [[ "${USB_FLASH_F2FS:-0}" == "1" ]] ; then
einfo "Adding F2FS support"
		usb_flash=1
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_F2FS_FS"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_XATTR"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_SECURITY"

	fi
	if [[ "${USB_FLASH_UDF:-0}" == "1" ]] ; then
einfo "Adding UDF support"
		usb_flash=1
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_UDF_FS"
	fi

	if [[ "${usb_flash}" == "1" ]] ; then
einfo "Adding USB thumb drive support"
		ot-kernel_y_configopt "CONFIG_SCSI"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_STORAGE"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SD"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_usb_mass_storage
# @DESCRIPTION:
# Add support for USB mass storage
ot-kernel_set_kconfig_usb_mass_storage() {
	[[ "${USB_MASS_STORAGE:-0}" == "1" ]] || return
einfo "Adding USB mass storage support"
	local hosts=( $(grep -r "config "  | cut -f 2 -d " ") )
	local not_tristate=(
		REALTEK_AUTOPM
		USB_STORAGE_DEBUG
	)
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE"

	for x in ${hosts[@]} ; do
		local tristate=1
		for y in ${not_tristate[@]} ; do
			[[ "${x}" == "${y}" ]] && tristate=0
		done
		(( ${tristate} )) && ot-kernel_set_configopt "CONFIG_${x}" "m"
	done

	# Depends
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
}

# @FUNCTION: ot-kernel_set_kconfig_reset_timer_hz_alpha
# @DESCRIPTION:
# Initializes the hz kernel config
ot-kernel_set_kconfig_reset_timer_hz_alpha() {
	local HZ=(
		HZ_32
		HZ_64
		HZ_128
		HZ_256
		HZ_1024
		HZ_1200
	)
	local hz
	for hz in ${HZ[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${hz}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_reset_timer_hz_arm
# @DESCRIPTION:
# Initializes the hz kernel config
ot-kernel_set_kconfig_reset_timer_hz_arm() {
	local HZ=(
		HZ_100
		HZ_200
		HZ_250
		HZ_300
		HZ_350
		HZ_1000
	)
	local hz
	for hz in ${HZ[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${hz}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_reset_timer_hz_mips
# @DESCRIPTION:
# Initializes the hz kernel config
ot-kernel_set_kconfig_reset_timer_hz_mips() {
	local HZ=(
		HZ_24
		HZ_48
		HZ_100
		HZ_128
		HZ_250
		HZ_256
		HZ_1000
		HZ_1024
	)
	local hz
	for hz in ${HZ[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${hz}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_reset_timer_hz
# @DESCRIPTION:
# Initializes the hz kernel config
ot-kernel_set_kconfig_reset_timer_hz() {
	local HZ=(
		HZ_100
		HZ_250
		HZ_300
		HZ_1000
	)
	local hz
	for hz in ${HZ[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${hz}"
	done
}

# @FUNCTION: ot-kernel_set_kconfig_set_default_timer_hz
# @DESCRIPTION:
# Initializes the hz to the default
ot-kernel_set_kconfig_set_default_timer_hz() {
	if [[ "${arch}" == "alpha" ]] ; then
		if grep -q -E -e "^CONFIG_ALPHA_QEMU=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_HZ_128"
			ot-kernel_set_configopt "CONFIG_HZ" "128"
		elif grep -q -E -e "^CONFIG_HZ_1200=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_HZ_1200"
			ot-kernel_set_configopt "CONFIG_HZ" "1200"
		else
			ot-kernel_y_configopt "CONFIG_HZ_1024"
			ot-kernel_set_configopt "CONFIG_HZ" "1024"
		fi
	elif [[ "${arch}" == "arm" ]] ; then
		if grep -q -E -e "^CONFIG_SOC_AT91RM9200=y" "${path_config}" ; then
			ot-kernel_set_configopt "CONFIG_HZ_FIXED" "128"
			ot-kernel_y_configopt "CONFIG_HZ_128"
			ot-kernel_set_configopt "CONFIG_HZ" "128"
		else
			ot-kernel_y_configopt "CONFIG_HZ_100"
			ot-kernel_set_configopt "CONFIG_HZ" "100"
		fi
	else
		ot-kernel_y_configopt "CONFIG_HZ_250"
		ot-kernel_set_configopt "CONFIG_HZ" "250"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_timer_hz
# @DESCRIPTION:
# Wrapper for setting the HZ
ot-kernel_set_kconfig_set_timer_hz() {
	local v="${1}"
	ot-kernel_y_configopt "CONFIG_HZ_${v}"
	ot-kernel_set_configopt "CONFIG_HZ" "${v}"
	local x=$(grep -r -e "CONFIG_HZ=" "${BUILD_DIR}/.config" | cut -f 2 -d "=")
einfo "Timer frequency is ${x} Hz"
}

# @FUNCTION: ot-kernel_set_kconfig_set_timer_hz
# @DESCRIPTION:
# Fits the HZ based on FPS
ot-kernel_set_kconfig_set_video_timer_hz() {
	if [[ \
		   "${OT_KERNEL_FPS}" == "30" \
		|| "${OT_KERNEL_FPS}" == "60" \
		|| "${OT_KERNEL_FPS}" == "90" \
		|| "${OT_KERNEL_FPS}" == "120" \
		|| "${OT_KERNEL_FPS}" == "150" \
		|| "${OT_KERNEL_FPS}" == "180" \
		|| "${OT_KERNEL_FPS}" == "210" \
		|| "${OT_KERNEL_FPS}" == "240" \
		|| "${OT_KERNEL_FPS}" == "300" \
	]] ; then
		ot-kernel_set_kconfig_set_timer_hz "300"
	elif [[ \
		   "${OT_KERNEL_FPS}" == "25" \
		|| "${OT_KERNEL_FPS}" == "50" \
		|| "${OT_KERNEL_FPS}" == "100" \
		|| "${OT_KERNEL_FPS}" == "200" \
		|| "${OT_KERNEL_FPS}" == "250" \
	]] ; then
		ot-kernel_set_kconfig_set_timer_hz "250"
	else
		if [[ "${arch}" == "mips" ]] ; then
			ot-kernel_set_kconfig_set_timer_hz "250"
		else
			ot-kernel_set_kconfig_set_timer_hz "300"
		fi
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_highest_timer_hz
# @DESCRIPTION:
# Fits the HZ to maximum
ot-kernel_set_kconfig_set_highest_timer_hz() {
	if [[ "${arch}" == "mips" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "1024"
	else
		ot-kernel_set_kconfig_set_timer_hz "1000"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_lowest_timer_hz
# @DESCRIPTION:
# Fits the HZ to maximum
ot-kernel_set_kconfig_set_lowest_timer_hz() {
	if [[ "${arch}" == "mips" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "24"
	else
		ot-kernel_set_kconfig_set_timer_hz "100"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_mouse_hz
# @DESCRIPTION:
# Fits the HZ to mouse scroll (>= 125 Hz)
ot-kernel_set_kconfig_set_mouse_hz() {
	if [[ "${arch}" == "alpha" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "128"
	elif [[ "${arch}" == "arm" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "100"
	elif [[ "${arch}" == "mips" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "128"
	else
		ot-kernel_set_kconfig_set_timer_hz "100"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_set_keypress_hz
# @DESCRIPTION:
# Fits the HZ to keypress (>= 15.6 Hz)
ot-kernel_set_kconfig_set_keypress_hz() {
	if [[ "${arch}" == "alpha" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "32"
	elif [[ "${arch}" == "arm" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "100"
	elif [[ "${arch}" == "mips" ]] ; then
		ot-kernel_set_kconfig_set_timer_hz "24"
	else
		ot-kernel_set_kconfig_set_timer_hz "100"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_clear_hz
# @DESCRIPTION:
# Clears the current hz setting
ot-kernel_set_kconfig_clear_hz() {
	if [[ \
		"${arch}" == "alpha" \
	]] ; then
		ot-kernel_set_kconfig_reset_timer_hz_alpha
	elif [[ \
		"${arch}" == "arm" \
	]] ; then
		ot-kernel_set_kconfig_reset_timer_hz_arm
	elif [[ \
		"${arch}" == "mips" \
	]] ; then
		ot-kernel_set_kconfig_reset_timer_hz_mips
	elif [[ \
		   "${arch}" == "arm64" \
		|| "${arch}" == "csky" \
		|| "${arch}" == "hexagon" \
		|| "${arch}" == "ia64" \
		|| "${arch}" == "microblaze" \
		|| "${arch}" == "nds32" \
		|| "${arch}" == "nios2" \
		|| "${arch}" == "openrisc" \
		|| "${arch}" == "parisc" \
		|| "${arch}" == "parisc64" \
		|| "${arch}" == "powerpc" \
		|| "${arch}" == "riscv" \
		|| "${arch}" == "s390" \
		|| "${arch}" == "sh" \
		|| "${arch}" == "sparc" \
		|| "${arch}" == "sparc32" \
		|| "${arch}" == "sparc64" \
		|| "${arch}" == "x86" \
		|| "${arch}" == "x86_64" \
	]] ; then
		ot-kernel_set_kconfig_reset_timer_hz
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_work_profile_init
# @DESCRIPTION:
# Initializes the work kernel config
ot-kernel_set_kconfig_work_profile_init() {
	ot-kernel_set_kconfig_clear_hz

	local TIMERS=(
		HZ_PERIODIC
		NO_HZ_IDLE
		NO_HZ_FULL
	)

	local timer
	for timer in ${TIMERS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${timer}"
	done

	local CPU_FREQ_GOV_DEFAULTS=(
		PERFORMANCE
		POWERSAVE
		USERSPACE
		ONDEMAND
		CONSERVATIVE
		GOV_SCHEDUTIL
	)
	local s
	for s in ${CPU_FREQ_GOV_DEFAULTS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_${s}"
	done

	local PCI_ASPM=(
		DEFAULT
		POWERSAVE
		POWER_SUPERSAVE
		PERFORMANCE
	)
	if grep -q -E -e "^CONFIG_PCI=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_PCIEASPM"
		for s in ${PCI_ASPM[@]} ; do
			ot-kernel_unset_configopt "CONFIG_PCIEASPM_${s}"
		done
	fi

	local PCI_HEIR_OPT=(
		TUNE_OFF
		DEFAULT
		SAFE
		PERFORMANCE
		PEER2PEER
	)

	if grep -q -E -e "^CONFIG_PCI=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		for s in ${PCI_HEIR_OPT[@]} ; do
			ot-kernel_unset_configopt "CONFIG_PCIE_BUS_${s}"
		done
	fi

	local PREEMPTION_MODELS=(
		PREEMPT_NONE
		PREEMPT_VOLUNTARY
		PREEMPT
	)

	for s in ${PREEMPTION_MODELS[@]} ; do
		ot-kernel_unset_configopt "CONFIG_${s}"
	done

	ot-kernel_unset_configopt "CONFIG_SUSPEND"
	ot-kernel_unset_configopt "CONFIG_HIBERNATION"
	if grep -q -E -e "^CONFIG_SND_AC97_CODEC=(y|m)" "${path_config}" ; then
		ot-kernel_unset_configopt "CONFIG_SND_AC97_POWER_SAVE"
	fi
	ot-kernel_unset_configopt "CONFIG_CFG80211_DEFAULT_PS"
	ot-kernel_unset_configopt "CONFIG_PM"
	ot-kernel_unset_configopt "CONFIG_RCU_FAST_NO_HZ"
}

# @FUNCTION: ot-kernel_set_kconfig_endianess
# @DESCRIPTION:
# Sets the endianess (aka byte order) based on CHOST
ot-kernel_set_kconfig_endianess() {
	local endianess=$(tc-endian)
	if [[ "${endianess}" == "big" ]] ; then
		ot-kernel_y_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_n_configopt "CONFIG_CPU_LITTLE_ENDIAN"
	elif [[ "${endianess}" == "little" ]] ; then
		ot-kernel_n_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_y_configopt "CONFIG_CPU_LITTLE_ENDIAN"
	fi
einfo "Using ${endianess} endian"
}

# @FUNCTION: ot-kernel_get_lib_bitness
# @DESCRIPTION:
# Attempt to get the bitness of the parent arch.  If x32abi, it returns 64
# so that it can enable both 64bit and x32 compatibility.  Similar
# expectations with those that have the compat flag.
ot-kernel_get_lib_bitness() {
	local path="${1}"
	# See binutils/testsuite/binutils-all/objdump.exp in binutils package
	if objdump -f "${path}" | grep -q -e "file format .*x86-64" ; then
		echo "64"
	elif objdump -f "${path}" | grep -q -e "file format .*i386" ; then
		echo "32"
	elif objdump -f "${path}" | grep -q -e "file format .*aarch64" ; then
		echo "64"
	elif objdump -f "${path}" | grep -q -e "file format .*arm" ; then
		echo "32"
	elif objdump -f "${path}" | grep -q -e "file format elf64.*" ; then
		echo "64" # elf64-.*{alpha,hppa,ia64,mips,powerpc,riscv,sparc}.*
	elif objdump -f "${path}" | grep -q -e "file format elf32.*" ; then
		echo "32" # elf32-.*{m68k,hppa,mips,powerpc,riscv,sparc}.*
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_abis
# @DESCRIPTION:
# Adds support for ABIs
ot-kernel_set_kconfig_abis() {
	[[ "${OT_KERNEL_ABIS,,}" =~ "manual" ]] && return
	[[ -z "${OT_KERNEL_ABIS}" ]] && OT_KERNEL_ABIS="auto"
	local lib_bitness=""
	# Assumes stage3 tarball installed
	[[ -e "/usr/lib/libbz2.so" ]] && lib_bitness=$(ot-kernel_get_lib_bitness $(readlink -f /usr/lib/libbz2.so))
	if [[ "${arch}" == "alpha" ]] ; then
einfo "Added support for alpha"
		ot-kernel_y_configopt "CONFIG_64BIT"
	fi
	if [[ "${arch}" == "arm" || "${arch}" == "arm64" ]] ; then
		if [[ "${OT_KERNEL_ABIS,,}" == "arm64" \
			|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "64" ) \
			|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64" ) ]] ; then
einfo "Added support for arm64"
			ot-kernel_y_configopt "CONFIG_64BIT"
			if [[ "${OT_KERNEL_ABIS,,}" =~ ("arm "|"arm"$) ]] ; then
einfo "Added support for arm"
				ot-kernel_y_configopt "CONFIG_COMPAT"
			fi
		else
einfo "Added support for arm"
			ot-kernel_n_configopt "CONFIG_64BIT"
		fi
		ot-kernel_set_kconfig_endianess
	fi
	if [[ "${arch}" == "i386" ]] ; then
eerror
eerror "OT_KERNEL_ARCH=\"i386\" is not supported.  Use OT_KERNEL_ARCH=\"x86\" instead."
eerror
		die
	fi
	if [[ "${arch}" == "ia64" ]] ; then
einfo "Added support for ia64"
		ot-kernel_y_configopt "CONFIG_64BIT"
	fi
	if [[ "${arch}" == "m68k" ]] ; then
einfo "Added support for m68k"
		ot-kernel_unset_configopt "CONFIG_64BIT"
		ot-kernel_n_configopt "CONFIG_CPU_BIG_ENDIAN"
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if [[ "${OT_KERNEL_ABIS,,}" =~ ("n32"|"n64")  \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "64" ) \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64" ) ]] ; then
			ot-kernel_n_configopt "CONFIG_32BIT"
			ot-kernel_y_configopt "CONFIG_64BIT"
			if [[ "${OT_KERNEL_ABIS,,}" =~ "o32" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" ) ]] ; then
einfo "Added support for o32"
				ot-kernel_n_configopt "CONFIG_MIPS32_O32"
			fi
			if [[ "${OT_KERNEL_ABIS,,}" =~ "n32" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib32" ) ]] ; then
einfo "Added support for n32"
				ot-kernel_n_configopt "CONFIG_MIPS32_N32"
			fi
			if [[ "${OT_KERNEL_ABIS,,}" =~ "n64" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64" ) ]] ; then
einfo "Added support for n64"
			fi
		else
			ot-kernel_y_configopt "CONFIG_32BIT"
			ot-kernel_n_configopt "CONFIG_64BIT"
		fi
		ot-kernel_set_kconfig_endianess
	fi
	if [[ "${arch}" == "parisc" || "${arch}" == "parisc64" ]] ; then
einfo "Added support for hppa"
		if [[ "${lib_bitness}" == "64" ]] ; then
			ot-kernel_y_configopt "CONFIG_PA8X00"
			ot-kernel_y_configopt "CONFIG_64BIT"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if [[ "${OT_KERNEL_ABIS,,}" =~ "ppc64" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "64" ) \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64" ) ]] ; then
einfo "Added support for ppc64"
			ot-kernel_y_configopt "CONFIG_64BIT"
			if [[ "${OT_KERNEL_ABIS,,}" =~ "ppc" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "32" ) \
				]] ; then
einfo "Added support for ppc"
				ot-kernel_y_configopt "CONFIG_COMPAT"
			fi
		else
			ot-kernel_n_configopt "CONFIG_64BIT"
		fi
		ot-kernel_set_kconfig_endianess
	fi
	if [[ "${arch}" == "riscv" ]] ; then
		if [[ "${OT_KERNEL_ABIS,,}" =~ "lp64d" \
				|| "${OT_KERNEL_ABIS,,}" =~ "lp64" \
                                || ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64/lp64d" ) \
                                || ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64/lp64" ) \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64" ) \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "64" ) \
			]] ; then
			ot-kernel_y_configopt "CONFIG_ARCH_RV64I"
			ot-kernel_n_configopt "CONFIG_ARCH_RV32I"
			if [[ "${OT_KERNEL_ABIS,,}" =~ "lp64d" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64/lp64d" ) ]] ; then
einfo "Added support for lp64d"
				ot-kernel_y_configopt "CONFIG_FPU"
			fi
			if [[ "${OT_KERNEL_ABIS,,}" =~ "lp64" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib64/lp64" ) ]] ; then
einfo "Added support for lp64"
				:
			fi
			if [[ "${OT_KERNEL_ABIS,,}" =~ "ilp32d" \
					|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib32/ilp32d" ) ]] ; then
einfo "Added support for ilp32d"
				ot-kernel_y_configopt "CONFIG_FPU"
			fi
			if [[ "${OT_KERNEL_ABIS,,}" =~ "ilp32" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib32/ilp32" ) ]] ; then
einfo "Added support for ilp32"
				:
			fi
		else
			ot-kernel_n_configopt "CONFIG_ARCH_RV64I"
			ot-kernel_y_configopt "CONFIG_ARCH_RV32I"
			if [[ "${OT_KERNEL_ABIS,,}" =~ "ilp32d" \
				|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib32/ilp32d" ) ]] ; then
einfo "Added support for ilp32d"
				ot-kernel_y_configopt "CONFIG_FPU"
			fi
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
einfo "Added support for s390x"
		ot-kernel_y_configopt "CONFIG_64BIT"
		if [[ "${OT_KERNEL_ABIS,,}" =~ ("s390"$|"s390 ") \
			|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "32" ) \
			]] ; then
einfo "Added support for s390"
			ot-kernel_y_configopt "CONFIG_COMPAT"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_unset_configopt "CONFIG_CPU_LITTLE_ENDIAN"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if [[ "${OT_KERNEL_ABIS,,}" =~ "sparc64" \
			|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/lib" && "${lib_bitness}" == "64" ) \
			]] ; then
einfo "Added support for sparc64"
			ot-kernel_y_configopt "CONFIG_64BIT"
		else
einfo "Added support for sparc32"
			ot-kernel_n_configopt "CONFIG_64BIT"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_unset_configopt "CONFIG_CPU_LITTLE_ENDIAN"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
einfo "Added support for x86_64"
		ot-kernel_y_configopt "CONFIG_64BIT"
		ot-kernel_y_configopt "CONFIG_X86_32"
		ot-kernel_unset_configopt "CONFIG_X86_64"
		if [[ "${OT_KERNEL_ABIS,,}" =~ "x32" \
			|| ( "${OT_KERNEL_ABIS,,}" =~ "auto" && -d "/usr/libx32" ) ]] ; then
einfo "Added support for x32"
			ot-kernel_y_configopt "CONFIG_X86_X32"
		fi
		if [[ \
		           ( "${OT_KERNEL_ABIS,,}" == "x86" ) \
		        || ( "${OT_KERNEL_ABIS,,}" == "x86_64" ) \
			|| ( "${OT_KERNEL_ABIS,,}" == "auto" && -e "/usr/lib32" ) \
			|| ( "${OT_KERNEL_ABIS,,}" == "auto" && -d "/usr/lib" && "${lib_bitness}" == "32" ) \
		]] ; then
einfo "Added support for x86"
			ot-kernel_y_configopt "CONFIG_IA32_EMULATION"
		fi
	fi
	if [[ "${arch}" == "x86" ]] ; then
einfo "Added support for x86"
		ot-kernel_unset_configopt "CONFIG_64BIT"
		ot-kernel_y_configopt "CONFIG_X86_32"
		ot-kernel_unset_configopt "CONFIG_X86_64"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_no_hz_full
# @DESCRIPTION:
# Sets the kernel command line to enable CONFIG_NO_HZ_FULL properly
ot-kernel_set_kconfig_no_hz_full() {
	ot-kernel_y_configopt "CONFIG_NO_HZ_FULL"
	ot-kernel_set_kconfig_kernel_cmdline "nohz_full=all"
}

# @FUNCTION: ot-kernel_set_rcu_powersave
# @DESCRIPTION:
# Saves more power at the expense of latency
ot-kernel_set_rcu_powersave() {
	if grep -q -E -e "^CONFIG_SMP=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_NO_HZ_COMMON"
		ot-kernel_y_configopt "CONFIG_RCU_EXPERT"
		ot-kernel_y_configopt "CONFIG_RCU_FAST_NO_HZ"
	fi
}

# @FUNCTION: ot-kernel_have_ssd
# @DESCRIPTION:
# Checks if ssd (non-rotational) is in system
ot-kernel_have_ssd() {
	local option="${OT_KERNEL_SSD:-auto}"
	if [[ "${option}" == "1" ]] ; then
		return 0
	elif [[ "${option}" == "auto" ]] ; then
		grep -q "0" /sys/block/*/queue/rotational && return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel_have_hdd
# @DESCRIPTION:
# Checks if hdd (rotational) is in system
ot-kernel_have_hdd() {
	local option="${OT_KERNEL_HDD:-auto}"
	if [[ "${option}" == "1" ]] ; then
		return 0
	elif [[ "${option}" == "auto" ]] ; then
		grep -q "1" /sys/block/*/queue/rotational && return 0
	fi
	return 1
}

ot-kernel_get_iosched_override_values() {
	local x
	for x in ${OT_KERNEL_IOSCHED_OVERRIDE} ; do
		local id="${x%:*}"
		local iosched="${x#*:}"
		echo "${iosched}"
	done
}

# @FUNCTION: ot-kernel_set_iosched
# @DESCRIPTION:
# Sets the I/O scheds(s).
# @USAGE: [ssd_iosched] [hdd_iosched]
ot-kernel_set_iosched() {
	local ssd_iosched="${1}"
	local hdd_iosched="${2}"
	# noop for guest vm to eliminate overhead.
	# Let the host handle IO scheduling.
	ot-kernel_unset_configopt "CONFIG_MQ_IOSCHED_DEADLINE"
	ot-kernel_unset_configopt "CONFIG_MQ_IOSCHED_KYBER"
	ot-kernel_unset_configopt "CONFIG_IOSCHED_BFQ"
	ot-kernel_unset_configopt "CONFIG_BFQ_GROUP_IOSCHED"
	if ver_test "${KV_MAJOR_MINOR}" -lt 5 ; then
		ot-kernel_y_configopt "CONFIG_IOSCHED_NOOP"
		ot-kernel_unset_configopt "CONFIG_IOSCHED_DEADLINE"
		ot-kernel_unset_configopt "CONFIG_IOSCHED_CFQ"
		ot-kernel_unset_configopt "CONFIG_CFQ_GROUP_IOSCHED"
		ot-kernel_unset_configopt "CONFIG_DEFAULT_IOSCHED"
	fi

	# Translate.  eclass simplifies to 5.x iosched
	if ver_test ${KV_MAJOR_MINOR} -ge 5 ; then
		[[ "${ssd_iosched}" == "noop" ]] && ssd_iosched="none"
		[[ "${hdd_iosched}" == "noop" ]] && hdd_iosched="none"
	fi

	# Translate to 4.x iosched
	if ver_test ${KV_MAJOR_MINOR} -lt 5 ; then
		[[ "${ssd_iosched}" == "none" ]] && ssd_iosched="noop"
		[[ "${hdd_iosched}" == "none" ]] && hdd_iosched="noop"
	fi

	[[ -z "${hdd_iosched}" ]] && hdd_iosched="${ssd_iosched}"
	[[ -z "${ssd_iosched}" ]] && ssd_iosched="${hdd_iosched}"

	local s_first=""
	local s
	for s in ${ssd_iosched} ${hdd_iosched} $(ot-kernel_get_iosched_override_values) ; do
		s="${s,,}"

		# Translate:
		[[ "${s}" == "rotational" ]] && s="${hdd_iosched}"
		[[ "${s}" == "flash" ]] && s="${ssd_iosched}"
		[[ "${s}" == "hdd" ]] && s="${hdd_iosched}"
		[[ "${s}" == "ssd" ]] && s="${ssd_iosched}"

		[[ -z "${s}" ]] && continue

		if [[ "${s}" == "bfq-low-latency" || "${s}" == "bfq" ]] ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_BFQ"
			s="bfq"
		elif [[ "${s}" == "bfq-throughput" ]] ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_BFQ"
			s="bfq"
		elif [[ "${s}" == "bfq-custom-interactive" ]] ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_BFQ"
			s="bfq"
		elif [[ "${s}" == "deadline" ]] && ver_test ${KV_MAJOR_MINOR} -lt 5  ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_DEADLINE"
		elif [[ "${s}" == "mq-deadline" ]] ; then
			ot-kernel_y_configopt "CONFIG_MQ_IOSCHED_DEADLINE"
		elif [[ "${s}" == "cfq" ]] && ver_test ${KV_MAJOR_MINOR} -lt 5 ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_CFQ"
		elif [[ "${s}" == "kyber" ]] ; then
			ot-kernel_y_configopt "CONFIG_MQ_IOSCHED_KYBER"
		elif [[ "${s}" == "noop" ]] && ver_test ${KV_MAJOR_MINOR} -lt 5 ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_NOOP"
		elif [[ "${s}" == "none" ]] && ver_test ${KV_MAJOR_MINOR} -ge 5 ; then
			:
		else
			continue
		fi
		if ver_test "${KV_MAJOR_MINOR}" -lt 5 \
			&& [[ -z "${s_first}" ]] \
			&& [[ "${s}" =~ ("cfq"|"deadline"|"noop") ]] ; then
			s_first="${s}"
		fi
einfo "Enabled ${s} as an I/O scheduler"
	done
	if ver_test "${KV_MAJOR_MINOR}" -lt 5 && [[ -n "${s_first}" ]] ; then
einfo "${s_first} is set as the default I/O scheduler"
		ot-kernel_set_configopt "CONFIG_DEFAULT_IOSCHED" "\"${s_first}\""
	elif ver_test "${KV_MAJOR_MINOR}" -lt 5 && [[ -z "${s_first}" ]] ; then
		#
		# We need either cfq, deadline, noop or it may result in a null
		# pointer dereference.
		#
		if ot-kernel_have_ssd ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_NOOP"
			s_first="noop"
		else
			ot-kernel_y_configopt "CONFIG_IOSCHED_CFQ"
			s_first="cfq"
		fi
einfo "${s_first} is set as the default I/O scheduler"
		ot-kernel_set_configopt "CONFIG_DEFAULT_IOSCHED" "\"${s_first}\""
	fi

	ot-kernel_gen_iosched_config
}

# @FUNCTION: ot-kernel_iosched_custom
# @DESCRIPTION:
# Configures the I/O scheduler for custom work profile
ot-kernel_iosched_custom() {
	if [[ -n "${OT_KERNEL_IOSCHED}" ]] ; then
		local scheds=(${OT_KERNEL_IOSCHED})
		local ssd_iosched=$(echo "${OT_KERNEL_IOSCHED[0]}")
		local hdd_iosched=$(echo "${OT_KERNEL_IOSCHED[1]}")
		ot-kernel_set_iosched "${ssd_iosched}" "${hdd_iosched}"
	fi
}

# @FUNCTION: ot-kernel_iosched_max_throughput
# @DESCRIPTION:
# Configures the I/O scheduler for high throughput
ot-kernel_iosched_max_throughput() {
	if ot-kernel_have_ssd && ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "none" "bfq-throughput"
	elif ot-kernel_have_ssd ; then
		ot-kernel_set_iosched "none" ""
	elif ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "" "bfq-throughput"
	else
		ot-kernel_set_iosched "none" "none"
	fi
}

# @FUNCTION: ot-kernel_iosched_builder_throughput
# @DESCRIPTION:
# Configures the I/O scheduler for high throughput when compiling or emerging
ot-kernel_iosched_builder_throughput() {
	if ot-kernel_have_ssd && ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "none" "mq-deadline"
	elif ot-kernel_have_ssd ; then
		ot-kernel_set_iosched "none" ""
	elif ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "" "mq-deadline"
	else
		ot-kernel_set_iosched "none" "none"
	fi
}

# @FUNCTION: ot-kernel_iosched_interactive
# @DESCRIPTION:
# Configures the I/O scheduler for saturated heavy I/O prioritizing web browsing I/O
ot-kernel_iosched_interactive() {
	if ot-kernel_have_ssd && ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "none" "bfq-low-latency"
	elif ot-kernel_have_ssd ; then
		ot-kernel_set_iosched "none" ""
	elif ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "" "bfq-low-latency"
	else
		ot-kernel_set_iosched "none" "none"
	fi
}

# @FUNCTION: ot-kernel_iosched_custom_interactive
# @DESCRIPTION:
# Configures the I/O scheduler for manual interactivity adjustments via
# ionice.
ot-kernel_iosched_custom_interactive() {
	if ot-kernel_have_ssd && ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "none" "bfq-custom-interactive"
	elif ot-kernel_have_ssd ; then
		ot-kernel_set_iosched "none" ""
	elif ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "" "bfq-custom-interactive"
	else
		ot-kernel_set_iosched "none" "none"
	fi
}

# @FUNCTION: ot-kernel_iosched_streaming
# @DESCRIPTION:
# Configures the I/O scheduler for dropped frames avoidance
ot-kernel_iosched_streaming() {
	if ot-kernel_have_ssd && ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "none" "bfq-streaming"
	elif ot-kernel_have_ssd ; then
		ot-kernel_set_iosched "none" ""
	elif ot-kernel_have_hdd ; then
		ot-kernel_set_iosched "" "bfq-streaming"
	else
		ot-kernel_set_iosched "none" "none"
	fi
}

# @FUNCTION: ot-kernel_iosched_max_tps
# @DESCRIPTION:
# Configures the I/O scheduler for maximium transactions per second
ot-kernel_iosched_max_tps() {
	ot-kernel_set_iosched "none" "none"
}

# @FUNCTION: ot-kernel_iosched_default
# @DESCRIPTION:
# Configures the I/O scheduler with the upstream default
ot-kernel_iosched_default() {
	if ver_test ${KV_MAJOR_MINOR} -lt 5 ; then
		ot-kernel_set_iosched "cfq" "cfq"
	else
		ot-kernel_set_iosched "mq-deadline" "mq-deadline"
	fi
}

# @FUNCTION: ot-kernel_iosched_lowest_power
# @DESCRIPTION:
# Configures the I/O scheduler for the lowest power consumption
ot-kernel_iosched_lowest_power() {
	# NCQ does reordering
	# This assumes that the device has NCQ.

	# The hard drive setting is debatable since academic papers don't exist
	# on the subject.

	# BFQ is chosen because of idle waits.

	# The low latency is disabled to minimize head movement.
	ot-kernel_set_iosched "none" "bfq-throughput"
}

FALLBACK_PREEMPT=""
FALLBACK_PREEMPT_IS_RT_WORK_PROFILE=0
# @FUNCTION: ot-kernel_set_kconfig_fallback_preempt
# @DESCRIPTION:
# Demote/reset to the fallback setting if no realtime packages detected.
ot-kernel_set_kconfig_fallback_preempt() {
	[[ -z "${FALLBACK_PREEMPT}" ]] && return
	if ! grep -q -E -e "^CONFIG_RT_PACKAGE_FOUND=y" "${path_config}" ; then
		if [[ "${FALLBACK_PREEMPT}" == "CONFIG_PREEMPT" && "${FALLBACK_PREEMPT_IS_RT_WORK_PROFILE}" == "1" ]] ; then
			ot-kernel_set_preempt "${FALLBACK_PREEMPT}"
			if ot-kernel_use rt ; then
ewarn
ewarn "No realtime packages detected.  Consider removing rt from OT_KERNEL_USE"
ewarn "from OT_KERNEL_EXTRAVERSION=\"${extraversion}\"."
ewarn
			fi
		else
eerror "ot-kernel_set_kconfig_fallback_preempt():  Add new case"
			die
		fi
	fi
}

# @FUNCTION: ot-kernel_set_rt_rcu
# @DESCRIPTION:
# Optimize RCU for realtime.
# RCU manages the destruction and pre read access to data marked to be destroyed.
ot-kernel_set_rt_rcu() {
	ot-kernel_y_configopt "CONFIG_RCU_EXPERT"

	ot-kernel_y_configopt "CONFIG_PREEMPT_RCU"
	ot-kernel_y_configopt "CONFIG_RCU_BOOST"

	ot-kernel_y_configopt "CONFIG_TREE_RCU"
	ot-kernel_y_configopt "CONFIG_RCU_FAST_NO_HZ"
}

# @FUNCTION: ot-kernel_set_kconfig_work_profile
# @DESCRIPTION:
# Configures the default power policies and latencies for the kernel.
ot-kernel_set_kconfig_work_profile() {
	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	FALLBACK_PREEMPT=""
	FALLBACK_PREEMPT_IS_RT_WORK_PROFILE=0
einfo "Using the ${work_profile} work profile"
	if [[ \
		   "${work_profile}" == "custom" \
		|| "${work_profile}" == "manual" \
	]] ; then
		:
	else
einfo "Changed .config to use the ${work_profile} work profile"
		ot-kernel_set_kconfig_work_profile_init
	fi

	if [[ \
		   "${work_profile}" =~ "green" \
		|| "${work_profile}" =~ "solar" \
	]] \
		&& \
	! use disable_debug ; then
ewarn
ewarn "OT_KERNEL_WORK_PROFILE=${OT_KERNEL_WORK_PROFILE} should use"
ewarn "USE=disable_debug to improve energy reduction."
ewarn
	fi

	if ot-kernel_use rt ; then
		if [[ \
			-z "${work_profile}" \
			|| "${work_profile}" == "custom" \
			|| "${work_profile}" == "digital-audio-workstation" \
			|| "${work_profile}" == "manual" \
			|| "${work_profile}" == "musical-live-performance" \
			|| "${work_profile}" == "pi-deep-learning" \
			|| "${work_profile}" == "pi-music-production" \
			|| "${work_profile}" == "radio-broadcaster" \
			|| "${work_profile}" == "realtime-hpc" \
			|| "${work_profile}" == "ros" \
			|| "${work_profile}" == "voip" \
		]] ; then
			:
		else
ewarn "rt should be removed from OT_KERNEL_USE for OT_KERNEL_WORK_PROFILE=${work_profile} and for OT_KERNEL_EXTRAVERSION=\"${extraversion}\"."
		fi
	fi

	if [[ "${work_profile}" == "arcade" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"arcade\" is deprecated.  Use either pi-gaming or pro-gaming instead."
		die
	elif [[ "${work_profile}" == "lan-tournament" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"lan-tournament\" is deprecated.  Use gaming-tournament instead."
		die
	elif [[ "${work_profile}" == "sbc" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"sbc\" is deprecated.  Use pi-audio-player, pi-deep-learning, pi-gaming, pi-music-production, pi-video-player, pi-web-browser instead."
		die
	elif [[ "${work_profile}" == "streamer-desktop" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"streamer-desktop\" is deprecated.  Use live-video-reporter or streamer-gamer instead."
		die
	elif [[ "${work_profile}" == "live-video-reporting" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"live-video-reporting\" is deprecated.  Use live-video-reporter instead."
		die
	elif [[ "${work_profile}" == "streamer-gamer" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"streamer-gamer\" is deprecated.  Use live-gamer-streamer instead."
		die
	elif [[ "${work_profile}" == "streamer-reporter" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"streamer-reporter\" is deprecated.  Use live-video-reporter instead."
		die
	elif [[ "${work_profile}" == "tournament" ]] ; then
# Prevent ambiguous connection to robotics tournament.
ewarn "OT_KERNEL_WORK_PROFILE=\"tournament\" is deprecated.  Use gaming-tournament instead."
		die
	elif [[ "${work_profile}" == "video-smartphone" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"video-smartphone\" is deprecated.  Use smartphone or smartphone-voice instead."
		die
	elif [[ "${work_profile}" == "video-tablet" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"video-tablet\" is deprecated.  Use tablet instead."
		die
	elif [[ "${work_profile}" == "web-server" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"web-server\" is deprecated.  Use either distributed-computing-server, http-server-busy, http-server-relaxed, file-server, media-server instead."
		die
	elif [[ "${work_profile}" == "http-server" ]] ; then
ewarn "OT_KERNEL_WORK_PROFILE=\"http-server\" is deprecated.  Use either http-server-busy, http-server-relaxed instead."
		die
	fi

	if [[ \
		-z "${work_profile}" \
		|| "${work_profile}" == "custom" \
		|| "${work_profile}" == "manual" \
	]] ; then
		ot-kernel_iosched_custom
	elif [[ \
		   "${work_profile}" == "smartphone" \
		|| "${work_profile}" == "smartphone-voice" \
		|| "${work_profile}" == "tablet" \
	]] ; then
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_set_kconfig_set_video_timer_hz # For webcams or streaming video
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_SUSPEND"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		if grep -q -E -e "^CONFIG_CFG80211=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_DEFAULT_PS"
		fi
		if [[ "${work_profile}" == "smartphone-voice" ]] ; then
			ot-kernel_set_preempt "CONFIG_PREEMPT"
		else
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		fi
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_rcu_powersave
		ot-kernel_iosched_lowest_power
	elif [[ \
		   "${work_profile}" == "laptop" \
		|| "${work_profile}" == "green-pc" \
		|| "${work_profile}" == "greenest-pc" \
		|| "${work_profile}" == "solar-desktop" \
		|| "${work_profile}" == "touchscreen-laptop" \
	]] ; then
		ot-kernel_set_kconfig_set_video_timer_hz # For power savings
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_SUSPEND"
		ot-kernel_y_configopt "CONFIG_HIBERNATION"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		if [[ "${work_profile}" == "touchscreen-laptop" ]] ; then
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		else
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_USERSPACE"
		if grep -q -E -e "^CONFIG_CFG80211=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_DEFAULT_PS"
		fi
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			if [[ \
				   "${work_profile}" == "solar-desktop" \
				|| "${work_profile}" == "greenest-pc" \
			]] ; then
				ot-kernel_y_configopt "CONFIG_PCIEASPM_POWER_SUPERSAVE"
			else
				ot-kernel_y_configopt "CONFIG_PCIEASPM_POWERSAVE"
			fi
		fi
		if grep -q -E -e "^CONFIG_SND_AC97_CODEC=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_SND_AC97_POWER_SAVE"
		fi
		if grep -q -E -e "^CONFIG_ARCH_SUPPORTS_ACPI=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_ACPI_BUTTON"
			ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
			ot-kernel_y_configopt "CONFIG_ACPI_AC"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		if [[ "${work_profile}" == "laptop" ]] ; then
			ot-kernel_y_configopt "CONFIG_VGA_SWITCHEROO"
		fi
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_rcu_powersave
		ot-kernel_iosched_lowest_power
	elif [[ \
		   "${work_profile}" == "casual-gaming-laptop" \
		|| "${work_profile}" == "gpu-gaming-laptop" \
		|| "${work_profile}" == "pi-gaming" \
		|| "${work_profile}" == "solar-gaming" \
	]] ; then
		# It is assumed that the other laptop/solar-desktop profile is built also.
		if [[ \
			   "${work_profile}" == "gpu-gaming-laptop" \
			|| "${work_profile}" == "solar-gaming" \
		]] ; then
	# 3D allowed, intense worse case
			ot-kernel_set_kconfig_set_highest_timer_hz # For input and reduced audio studdering
			ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
		else
	# 2D mostly, less intense
	# Avoid leg burn on long use
			ot-kernel_set_kconfig_set_video_timer_hz # For power savings
			ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Lower temperature and fan noise
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE"
		fi
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_USERSPACE"
		ot-kernel_unset_configopt "CONFIG_CFG80211_DEFAULT_PS"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		if grep -q -E -e "^CONFIG_ARCH_SUPPORTS_ACPI=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_ACPI_BUTTON"
			ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
			ot-kernel_y_configopt "CONFIG_ACPI_AC"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT"
		if [[ "${work_profile}" == "gpu-gaming-laptop" ]] ; then
			ot-kernel_y_configopt "CONFIG_VGA_SWITCHEROO"
		fi
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_configopt "CONFIG_USB_AUTOSUSPEND_DELAY" "-1" # disable
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		ot-kernel_iosched_interactive
	elif [[ \
		"${work_profile}" == "casual-gaming" \
	]] ; then
	# Assumes on desktop
	# 2D mostly, less intense
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_set_kconfig_set_highest_timer_hz # For input and reduced audio studdering
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Lower temperature and fan noise
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		ot-kernel_unset_configopt "CONFIG_CFG80211_DEFAULT_PS"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT"
		ot-kernel_set_configopt "CONFIG_USB_AUTOSUSPEND_DELAY" "-1" # disable
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		ot-kernel_iosched_interactive
	elif [[ \
		   "${work_profile}" == "desktop-guest-vm" \
		|| "${work_profile}" == "gaming-guest-vm" \
	]] ; then
		ot-kernel_set_kconfig_set_lowest_timer_hz # Reduce cpu overhead
		ot-kernel_set_preempt "CONFIG_PREEMPT"
		ot-kernel_set_iosched "none" "none"
	elif [[ \
		   "${work_profile}" == "game-server" \
		|| "${work_profile}" == "gaming-tournament" \
		|| "${work_profile}" == "pro-gaming" \
		|| "${work_profile}" == "presentation" \
	]] ; then
		if [[ "${work_profile}" != "game-server" ]] ; then
			_OT_KERNEL_FORCE_SWAP_OFF="1"
		fi
		ot-kernel_set_kconfig_set_highest_timer_hz # For input and reduced audio studdering
		ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		if [[ "${work_profile}" == "game-server" ]] ; then
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		else
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_USERSPACE"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_unset_configopt "CONFIG_CFG80211_DEFAULT_PS"
	# The presentation could just be slides with few clicks or a gaming demo
	# with a lot of clicks.
		ot-kernel_set_preempt "CONFIG_PREEMPT"
		ot-kernel_set_configopt "CONFIG_USB_AUTOSUSPEND_DELAY" "-1" # disable
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		ot-kernel_iosched_interactive
		if [[ "${work_profile}" == "pro-gaming" ]] ; then
			ot-kernel_optimize_gaming "pro-gaming"
		elif [[ "${work_profile}" == "gaming-tournament" ]] ; then
			ot-kernel_optimize_gaming "gaming-tournament"
		fi
	elif [[ \
		   "${work_profile}" == "digital-audio-workstation" \
		|| "${work_profile}" == "gamedev" \
		|| "${work_profile}" == "musical-live-performance" \
		|| "${work_profile}" == "workstation" \
	]] ; then
		if [[ \
			   "${work_profile}" == "digital-audio-workstation" \
			|| "${work_profile}" == "musical-live-performance" \
		]] ; then
			_OT_KERNEL_FORCE_SWAP_OFF="1"
			ot-kernel_set_kconfig_no_hz_full
			ot-kernel_set_rt_rcu
			ot-kernel_set_kconfig_set_highest_timer_hz # For reduced audio studdering
			if   [[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
	# Set blanket policy
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
			elif [[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && ver_test ${KV_MAJOR_MINOR} -lt 5.4 ; then
	# Set blanket policy
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT_FULL"
			else
	# Fallback to disable Hard RT if nothing uses it during auto configure.
				FALLBACK_PREEMPT="CONFIG_PREEMPT"
				FALLBACK_PREEMPT_IS_RT_WORK_PROFILE=1
			fi
		elif [[ "${work_profile}" == "gamedev" ]] ; then
			ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
			ot-kernel_set_kconfig_set_highest_timer_hz # For reduced audio studdering, reduce skippy input
			ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		elif [[ "${work_profile}" == "workstation" ]] ; then
			ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
			ot-kernel_set_kconfig_set_video_timer_hz # For video production
			ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_set_configopt "CONFIG_USB_AUTOSUSPEND_DELAY" "-1" # disable
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		if [[ \
			   "${work_profile}" == "digital-audio-workstation" \
			|| "${work_profile}" == "musical-live-performance" \
		]] ; then
			ot-kernel_iosched_streaming
		else
			ot-kernel_iosched_interactive
		fi
	elif [[ \
		   "${work_profile}" == "builder-dedicated" \
		|| "${work_profile}" == "builder-interactive" \
	]] ; then
		if [[ "${work_profile}" == "builder-dedicated" ]] ; then
			ot-kernel_set_kconfig_set_lowest_timer_hz # For decreased build times
			ot-kernel_y_configopt "CONFIG_NONE"
		else
			ot-kernel_set_kconfig_set_default_timer_hz
			ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		fi
		ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		if [[ "${work_profile}" == "builder-dedicated" ]] ; then
			ot-kernel_iosched_builder_throughput
		else
			ot-kernel_iosched_custom_interactive
		fi
	elif [[ \
		   "${work_profile}" == "renderfarm-dedicated" \
		|| "${work_profile}" == "renderfarm-workstation" \
	]] ; then
		ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		if [[ "${work_profile}" == "renderfarm-workstation" ]] ; then
			ot-kernel_set_kconfig_set_default_timer_hz
			ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		else
			ot-kernel_set_kconfig_set_lowest_timer_hz
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		fi
		if [[ "${work_profile}" == "builder-dedicated" ]] ; then
			ot-kernel_iosched_max_throughput
		else
			ot-kernel_iosched_interactive
		fi
	elif [[ \
		   "${work_profile}" == "distributed-computing-server" \
		|| "${work_profile}" == "file-server" \
		|| "${work_profile}" == "http-server-busy" \
		|| "${work_profile}" == "http-server-relaxed" \
		|| "${work_profile}" == "media-server" \
	]] ; then
		if [[ \
			   "${work_profile}" == "http-server-busy" \
			|| "${work_profile}" == "http-server-relaxed" \
		]] ; then
			ot-kernel_set_kconfig_set_keypress_hz
		elif [[ "${work_profile}" == "media-server" ]] ; then
			ot-kernel_set_kconfig_set_video_timer_hz
		else
			ot-kernel_set_kconfig_set_lowest_timer_hz
		fi
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_POWERSAVE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		if [[ "${work_profile}" == "http-server-busy" ]] ; then
			ot-kernel_iosched_max_tps
		elif [[ "${work_profile}" == "file-server" ]] ; then
			ot-kernel_iosched_max_throughput
		else
			ot-kernel_iosched_interactive
		fi
	elif [[ \
		   "${work_profile}" == "live-streaming-gamer" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "streamer-reporter" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_set_kconfig_set_video_timer_hz
		ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		if [[ \
			   "${work_profile}" == "radio-broadcaster" \
			|| "${work_profile}" == "voip" \
		]] ; then
			if   [[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
	# Set blanket policy
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
			elif [[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && ver_test ${KV_MAJOR_MINOR} -lt 5.4 ; then
	# Set blanket policy
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT_FULL"
			else
	# Fallback to disable Hard RT if nothing uses it during auto configure.
				FALLBACK_PREEMPT="CONFIG_PREEMPT"
				FALLBACK_PREEMPT_IS_RT_WORK_PROFILE=1
			fi
		else
			ot-kernel_set_preempt "CONFIG_PREEMPT"
		fi
		ot-kernel_iosched_interactive
	elif [[ \
		   "${work_profile}" == "dvr" \
		|| "${work_profile}" == "jukebox" \
		|| "${work_profile}" == "mainstream-desktop" \
		|| "${work_profile}" == "pi-audio-player" \
		|| "${work_profile}" == "pi-video-player" \
		|| "${work_profile}" == "pi-web-browser" \
		|| "${work_profile}" == "sdr" \
	]] ; then
	# sdr = radio
		if [[ \
			   "${work_profile}" == "dvr" \
			|| "${work_profile}" == "mainstream-desktop" \
			|| "${work_profile}" == "pi-video-player" \
			|| "${work_profile}" == "pi-web-browser" \
		]] ; then
			ot-kernel_set_kconfig_set_video_timer_hz # Minimize dropped frames
		fi
		if [[ \
			   "${work_profile}" == "jukebox" \
			|| "${work_profile}" == "pi-audio-player" \
			|| "${work_profile}" == "sdr" \
		]] ; then
			ot-kernel_set_kconfig_set_highest_timer_hz # Reduce studder
		fi
		if [[ \
			   "${work_profile}" == "dvr" \
			|| "${work_profile}" == "jukebox" \
			|| "${work_profile}" == "pi-audio-player" \
			|| "${work_profile}" == "pi-video-player" \
			|| "${work_profile}" == "sdr" \
		]] ; then
			_OT_KERNEL_FORCE_SWAP_OFF="1"
		#else
		#	Allow to use more browswer tabs with swap.
		fi
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_POWERSAVE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT"
		if [[ \
			   "${work_profile}" == "mainstream-desktop" \
			|| "${work_profile}" == "pi-web-browser" \
		]] ; then
			ot-kernel_y_configopt "CONFIG_PM"
		else
			ot-kernel_unset_configopt "CONFIG_PM"
		fi
		ot-kernel_iosched_streaming
	elif [[ \
		"${work_profile}" == "cryptocurrency-miner-dedicated" \
	]] ; then
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_set_kconfig_set_lowest_timer_hz # For energy and throughput
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_USERSPACE"
		if grep -q -E -e "^CONFIG_CFG80211=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_DEFAULT_PS"
		fi
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_rcu_powersave
		ot-kernel_iosched_lowest_power
	elif [[ \
		"${work_profile}" == "cryptocurrency-miner-workstation" \
	]] ; then
		ot-kernel_set_kconfig_set_default_timer_hz # For balance
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE" # Save power
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_USERSPACE"
		if grep -q -E -e "^CONFIG_CFG80211=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_DEFAULT_PS"
		fi
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_set_rcu_powersave
		ot-kernel_iosched_lowest_power
	elif [[ \
		   "${work_profile}" == "green-hpc" \
		|| "${work_profile}" == "greenest-hpc" \
		|| "${work_profile}" == "hpc" \
		|| "${work_profile}" == "realtime-hpc" \
		|| "${work_profile}" == "throughput-hpc" \
	]] ; then
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_SCHEDUTIL"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_POWERSAVE"
		if [[ "${work_profile}" == "green-hpc" ]] ; then
			ot-kernel_set_kconfig_set_lowest_timer_hz # Power savings
			ot-kernel_set_kconfig_no_hz_full
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
			if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PCIEASPM_POWERSAVE"
			fi
			ot-kernel_y_configopt "CONFIG_PM"
			ot-kernel_set_rcu_powersave
			ot-kernel_iosched_lowest_power
		elif [[ "${work_profile}" == "greenest-hpc" ]] ; then
			ot-kernel_set_kconfig_set_lowest_timer_hz # Power savings
			ot-kernel_set_kconfig_no_hz_full
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
			if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PCIEASPM_POWER_SUPERSAVE"
			fi
			ot-kernel_y_configopt "CONFIG_PM"
			ot-kernel_set_rcu_powersave
			ot-kernel_iosched_lowest_power
		elif [[ \
			   "${work_profile}" == "hpc" \
			|| "${work_profile}" == "throughput-hpc" \
		]] ; then
			ot-kernel_set_kconfig_set_lowest_timer_hz # Shorter runtimes
			ot-kernel_set_kconfig_slab_allocator "slub"
			ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
			if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
			fi
			ot-kernel_iosched_max_throughput
		elif [[ "${work_profile}" == "realtime-hpc" ]] ; then
			ot-kernel_set_kconfig_set_highest_timer_hz # Minimize jitter
			ot-kernel_set_kconfig_no_hz_full
			ot-kernel_set_rt_rcu
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
			if   ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
			elif ver_test ${KV_MAJOR_MINOR} -lt 5.4 ; then
				ot-kernel_set_preempt "CONFIG_PREEMPT_RT_FULL"
			fi
			if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
			fi
			ot-kernel_iosched_max_throughput
		fi
	elif [[ \
		"${work_profile}" == "distributed-computing-client" \
	]] ; then
		# Example: BOINC
		ot-kernel_set_kconfig_set_default_timer_hz # For balance
		ot-kernel_y_configopt "CONFIG_HZ_PERIODIC"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		if grep -q -E -e "^CONFIG_PCIEASPM=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_PCIEASPM_PERFORMANCE"
		fi
		ot-kernel_set_preempt "CONFIG_PREEMPT_VOLUNTARY"
		ot-kernel_iosched_interactive
	elif [[ \
		   "${work_profile}" == "pi-deep-learning" \
		|| "${work_profile}" == "pi-music-production" \
		|| "${work_profile}" == "ros" \
	]] ; then
	# ros ~ robotics
		if [[ "${work_profile}" == "ros" ]] ; then
			ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		fi
		_OT_KERNEL_FORCE_SWAP_OFF="1"
		ot-kernel_set_kconfig_set_highest_timer_hz
		ot-kernel_set_kconfig_no_hz_full
		ot-kernel_set_rt_rcu
		# ML/DL case for self-driving car/drone
		if   ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
			ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
		elif ver_test ${KV_MAJOR_MINOR} -lt 5.4 ; then
			ot-kernel_set_preempt "CONFIG_PREEMPT_RT_FULL"
		fi
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_PERFORMANCE"
		ot-kernel_y_configopt "CONFIG_SCHED_OMIT_FRAME_POINTER"
		ot-kernel_iosched_streaming
	fi

	local sata_lpm_max="${OT_KERNEL_SATA_LPM_MAX:-1}"
	local sata_lpm_mid="${OT_KERNEL_SATA_LPM_MID:-0}"
	local sata_lpm_min="${OT_KERNEL_SATA_LPM_MIN:-0}"

	if [[ \
		-z "${work_profile}" \
		|| "${work_profile}" == "custom" \
		|| "${work_profile}" == "manual" \
	]] ; then
		:
	elif \
		   grep -q -E -e "^CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y" "${path_config}" \
		; then
		if \
			   grep -q -E -e "^CONFIG_ATA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_HAS_DMA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_SATA_AHCI=(y|m)" "${path_config}" ; then
			ot-kernel_set_configopt "CONFIG_SATA_MOBILE_LPM_POLICY" "${sata_lpm_max}"
		fi
	elif \
		   grep -q -E -e "^CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y" "${path_config}" \
		|| grep -q -E -e "^CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y" "${path_config}" \
		|| grep -q -E -e "^CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y" "${path_config}" \
		; then
		if \
			   grep -q -E -e "^CONFIG_ATA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_HAS_DMA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_SATA_AHCI=(y|m)" "${path_config}" \
		; then
			ot-kernel_set_configopt "CONFIG_SATA_MOBILE_LPM_POLICY" "${sata_lpm_mid}"
		fi
	elif \
		   grep -q -E -e "^CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y" "${path_config}" \
		; then
		if \
			   grep -q -E -e "^CONFIG_ATA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_HAS_DMA=(y|m)" "${path_config}" \
			&& grep -q -E -e "^CONFIG_SATA_AHCI=(y|m)" "${path_config}" ; then
			ot-kernel_set_configopt "CONFIG_SATA_MOBILE_LPM_POLICY" "${sata_lpm_min}"
		fi
	else
		ot-kernel_set_configopt "CONFIG_SATA_MOBILE_LPM_POLICY" "0" # firmware default
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_zswap
# @DESCRIPTION:
# Sets the kernel config for ZSWAP (aka compressed swap)
ot-kernel_set_kconfig_zswap() {
	[[ "${_OT_KERNEL_FORCE_SWAP_OFF}" == "1" ]] && OT_KERNEL_SWAP="0"
	if [[ "${OT_KERNEL_SWAP}" == "0" || "${OT_KERNEL_SWAP^^}" == "N" ]] ; then
einfo "Disabling swap compressors"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD"

		ot-kernel_unset_configopt "CONFIG_ZPOOL"
		ot-kernel_unset_configopt "CONFIG_ZSWAP"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC"
		ot-kernel_unset_configopt "CONFIG_ZBUD"
		ot-kernel_unset_configopt "CONFIG_Z3FOLD"

		ot-kernel_unset_configopt "CONFIG_FRONTSWAP"
		return
	fi
	if [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "MANUAL" ]] ; then
einfo "Using manual zswap compressor"
	elif [[ -n "${OT_KERNEL_ZSWAP_COMPRESSOR}" ]] ; then
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD"
		if [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "DEFLATE" ]] ; then
einfo "Using deflate for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE"
			ot-kernel_y_configopt "CONFIG_CRYPTO_DEFLATE"
		elif [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "LZO" \
			|| "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "auto" ]] ; then
einfo "Using lzo for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LZO"
		elif [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "842" ]] ; then
einfo "Using 842 for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842"
			ot-kernel_y_configopt "CONFIG_CRYPTO_842"
		elif [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "LZ4" ]] ; then
einfo "Using lz4 for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LZ4"
		elif [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "LZ4HC" ]] ; then
einfo "Using lz4hc for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LZ4HC"
		elif [[ "${OT_KERNEL_ZSWAP_COMPRESSOR^^}" == "ZSTD" ]] ; then
einfo "Using zstd for zswap"
			ot-kernel_y_configopt "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ZSTD"
		fi

		ot-kernel_y_configopt "CONFIG_SWAP"
		ot-kernel_y_configopt "CONFIG_FRONTSWAP"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_ZSWAP"
		ot-kernel_y_configopt "CONFIG_ZSWAP_DEFAULT_ON"
	else
einfo "Using manual zswap compressor"
	fi

	if [[ "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "MANUAL" ]] ; then
einfo "Using manual zswap allocator"
	elif [[ -n "${OT_KERNEL_ZSWAP_ALLOCATOR}" ]] ; then
		ot-kernel_unset_configopt "CONFIG_ZPOOL"
		ot-kernel_unset_configopt "CONFIG_ZSWAP"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD"
		ot-kernel_unset_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC"
		ot-kernel_unset_configopt "CONFIG_ZBUD"
		ot-kernel_unset_configopt "CONFIG_Z3FOLD"
		if [[ "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "ZSMALLOC" \
			|| "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "XN" \
			|| "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "auto" \
			]] ; then
einfo "Using zsmalloc for zswap"
			ot-kernel_y_configopt "CONFIG_MMU"
			ot-kernel_y_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC"
			ot-kernel_y_configopt "CONFIG_ZSMALLOC"
		elif [[ "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "ZBUD" \
			|| "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "X2" \
			]] ; then
einfo "Using zbud for zswap"
			ot-kernel_y_configopt "CONFIG_ZPOOL"
			ot-kernel_y_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD"
			ot-kernel_y_configopt "CONFIG_ZBUD"
		elif [[ "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "Z3FOLD" \
			|| "${OT_KERNEL_ZSWAP_ALLOCATOR^^}" == "X3" ]] ; then
einfo "Using z3fold for zswap"
			ot-kernel_y_configopt "CONFIG_ZPOOL"
			ot-kernel_y_configopt "CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD"
			ot-kernel_y_configopt "CONFIG_Z3FOLD"
		fi

		ot-kernel_y_configopt "CONFIG_SWAP"
		ot-kernel_y_configopt "CONFIG_FRONTSWAP"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_ZSWAP"
		ot-kernel_y_configopt "CONFIG_ZSWAP_DEFAULT_ON"
	else
einfo "Using manual zswap allocator"
	fi
}

# @FUNCTION: ot-kernel_convert_tristate_m
# @DESCRIPTION:
# Converts CONFIG_[0-9A-Z_]=y to CONFIG_[0-9A-Z_]=m
ot-kernel_convert_tristate_m() {
	cp -a "${orig}" "${bak}" || die
	make allmodconfig "${args[@]}" || die
	cp -a "${orig}" "${conv}" || die
	cp -a "${bak}" "${orig}" || die
	local symbols=(
		$(grep -E -e "^CONFIG_[0-9A-Z_]+=(y|m|n)" "${orig}" | sed -E -e "s/=(y|n|m)//g")
	)
einfo "Changing .config from CONFIG...=y to CONFIG...=m"
	for s in ${symbols[@]} ; do
		if grep -q -e "^${s}=m" "${conv}" && grep -q -e "^${s}=y" "${bak}" ; then
einfo "${s}=m"
			sed -r -i -e "s/${s}=[ymn]/${s}=m/g" "${orig}" || die
		fi
	done
}

# @FUNCTION: ot-kernel_convert_tristate_y
# @DESCRIPTION:
# Sets all CONFIG...=m to CONFIG...=y
ot-kernel_convert_tristate_y() {
	local symbols=(
		$(grep -E -e "^CONFIG_[0-9A-Z_]+=(y|m|n)" "${orig}" | sed -E -e "s/=(y|n|m)//g")
	)
	symbols=($(echo "${symbols[@]}" | tr " " "\n" | sort))
einfo "Changing .config from CONFIG...=m to CONFIG...=y"
	for s in ${symbols[@]} ; do
		sed -r -i -e "s/${s}=[ymn]/${s}=y/g" "${orig}" || die
	done
}

# @FUNCTION: ot-kernel_fix_config_for_boot
# @DESCRIPTION:
# Sets some to CONFIG...=y required for initramfs or logins boot process to work properly
# You may supply a space separated OT_KERNEL_BOOT_OPTIONS containing all modules CONFIG_... to
# be converted.  Setting this will override the auto additions for more control.
ot-kernel_fix_config_for_boot() {
	local symbols
	local subsystem
	if [[ -n "${OT_KERNEL_BOOT_SUBSYSTEMS}" ]] ; then
		subsystems=( ${OT_KERNEL_BOOT_SUBSYSTEMS} )
	else
		subsystems=(
			# All related to boot initialization and logins
			crypto
			drivers/ata
			drivers/block
			drivers/hid
			drivers/md
			drivers/scsi
			drivers/usb
			drivers/input/keyboard
			fs
			${OT_KERNEL_BOOT_SUBSYSTEMS_APPEND}
		)
		if [[ "${OT_KERNEL_EARLY_KMS:-1}" == "1" ]] ; then
			subsystems+=(
				drivers/char/agp
				drivers/gpu
				drivers/video
			)
		fi
	fi
	subsystems=($(echo "${subsystems[@]}" | tr " " "\n" | sort))

	if [[ "${subsystems[@]}" =~ "drivers/char/agp" \
		&& "${subsystems[@]}" =~ "drivers/gpu" ]] ; then
einfo "Early KMS is enabled"
	else
ewarn
ewarn "Detected Early KMS is disabled.  For early KMS, add"
ewarn "drivers/char/agp, drivers/gpu, drivers/video, to OT_KERNEL_BOOT_SUBSYSTEMS_APPEND"
ewarn "or similar."
ewarn
	fi

	if [[ -n "${OT_KERNEL_BOOT_KOPTIONS}" ]] ; then
		symbols=( "${OT_KERNEL_BOOT_KOPTIONS}" )
	else
		symbols=(
			$(grep -E -e "^(config|menuconfig) [0-9A-Za-z_]+" $(find ${subsystems[@]} -name "Kconfig*") \
				| cut -f 2 -d ":" \
				| sed -r -e "s/^(config|menuconfig) //g" \
				| sed -e "s|^|CONFIG_|g")
		)
	fi

	symbols=($(echo "${symbols[@]}" | tr " " "\n" | sort))
einfo "Fixing config for boot"
	for s in ${symbols[@]} ; do
		if grep -q -e "^${s}=m" "${orig}" ; then
einfo "${s}=y"
			sed -r -i -e "s/${s}=[ymn]/${s}=y/g" "${orig}" || die
		fi
	done

	# Fix default TCP congestion
	if grep -q -e "^CONFIG_DEFAULT_TCP_CONG=" "${orig}" ; then
		local alg=$(grep "CONFIG_DEFAULT_TCP_CONG" "${orig}" \
			| cut -f 2 -d '"')
		ot-kernel_y_configopt "CONFIG_TCP_CONG_${alg^^}"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_eudev
# @DESCRIPTION:
# Fixes kernel config when OT_KERNEL_BUILD_ALL_MODULES_AS=m or fixes
# undocumented genkernel dependency requirements for the kernel.
ot-kernel_set_kconfig_eudev() {
einfo "Fixing config for genkernel"
	# Genkernel does not add the unix module
	# This is required for initramfs's eudev (udevadm)
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_UNIX"
}

# @FUNCTION: ot-kernel_convert_tristate_fix
# @DESCRIPTION:
# Fix =y conflicts when a user wants both drivers install.
ot-kernel_convert_tristate_fix() {
	if ot-kernel_has_version "x11-drivers/nvidia-drivers" \
		&& grep -q -e "^CONFIG_DRM_NOUVEAU=y" "${BUILD_DIR}/.config" ; then
ewarn "Enabling modules support for nouveau."
ewarn "Early KMS is disabled for the nouveau driver."
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_set_configopt "CONFIG_DRM_NOUVEAU" "m"
	fi
	if ot-kernel_has_version "x11-drivers/nvidia-drivers" \
		&& grep -q -e "^CONFIG_DRM_SIMPLEDRM=y" "${BUILD_DIR}/.config" ; then
ewarn "Enabling modules support for simpledrm."
ewarn "Early KMS is disabled for the simpledrm driver."
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_set_configopt "CONFIG_DRM_SIMPLEDRM" "m"
	fi

	if \
		has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms \
	; then
	# For sys-kernel/rock-dkms not installed yet scenario.
ewarn "Enabling modules support for sys-kernel/rock-dkms."
ewarn "Early KMS is disabled for the amdgpu driver."
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"
	elif \
		   has rock-dkms ${IUSE_EFFECTIVE} \
		&& ot-kernel_use rock-dkms \
		&& ( \
			   ver_test "${KV_MAJOR_MINOR}" -eq "5.4" \
			|| ver_test "${KV_MAJOR_MINOR}" -eq "5.15" \
		) \
	; then
ewarn "Enabling modules support for sys-kernel/rock-dkms."
ewarn "Early KMS is disabled for the amdgpu driver."
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_build_all_modules_as
# @DESCRIPTION:
# Converts all options as modules (m) or builtins (y).
ot-kernel_set_kconfig_build_all_modules_as() {
	local orig="${BUILD_DIR}/.config"
	local bak="${BUILD_DIR}/.config.orig"
	local conv="${BUILD_DIR}/.config.conv"
	if ! grep -q -e "^CONFIG_MODULES=y" "${BUILD_DIR}/.config" ; then
einfo "Detected modules support disabled"
		ot-kernel_convert_tristate_y
		ot-kernel_convert_tristate_fix
		return
	fi
	if [[ "${OT_KERNEL_BUILD_ALL_MODULES_AS}" == "m" ]] ; then
		ot-kernel_convert_tristate_m
		ot-kernel_fix_config_for_boot
		ot-kernel_convert_tristate_fix
	elif [[ "${OT_KERNEL_BUILD_ALL_MODULES_AS}" == "y" ]] ; then
		ot-kernel_convert_tristate_y
		ot-kernel_convert_tristate_fix
	else
einfo "Building all kernel options as manual"
	fi
	rm "${bak}" "${conv}" 2>/dev/null
}

# @FUNCTION: ot-kernel_menuconfig
# @DESCRIPTION:
# Sets up wrappers for menuconfig and halts for kernel config edits if requested.
ot-kernel_menuconfig() {
	local run_at="${1}"
	local user_run_at="${OT_KERNEL_MENUCONFIG_RUN_AT:-post}"
	if [[ "${run_at}" == "${user_run_at}" ]] ; then
		local menuconfig_ui="${OT_KERNEL_MENUCONFIG_UI:-disabled}"
		menuconfig_ui="${menuconfig_ui,,}"
		if [[ "${menuconfig_ui}" =~ ("none"|"disable") ]] ; then
			:
		elif [[ -n "${menuconfig_ui}" ]] ; then
			if [[ "${menuconfig_ui}" =~ ("menuconfig"|"nconfig") ]] ; then
				use ncurses || die "Enable the ncurses USE flag for nconfig or menuconfig support"
			elif [[ "${menuconfig_ui}" == "gconfig" ]] ; then
				use gtk || die "Enable the gtk USE flag for gconfig support"
			elif [[ "${menuconfig_ui}" == "xconfig" ]] ; then
				use qt5 || die "Enable the qt5 USE flag for xconfig support"
			fi
#			https://github.com/torvalds/linux/blob/master/scripts/kconfig/Makefile#L118
#			All menuconfig/xconfig/gconfig works outside of emerge but not when sandbox is completely disabled.
#			The interactive support doesn't work as advertised but limited to just alphanumeric and no arrow keys in text only mode.
#
#			# Does not work because the arrow keys are broken in interactive mode
			local menuconfig_colors
			if [[ -n "${menuconfig_ui}" ]] ; then
				menuconfig_colors="MENUCONFIG_COLOR=${OT_KERNEL_MENUCONFIG_COLORS}"
			fi
			if [[ \
				   "${menuconfig_ui,,}" == "menuconfig"  \
				|| "${menuconfig_ui,,}" == "gconfig"  \
				|| "${menuconfig_ui,,}" == "nconfig"  \
				|| "${menuconfig_ui,,}" == "xconfig"  \
			]] ; then
				:
			else
eerror
eerror "Detected OT_KERNEL_MENUCONFIG_UI as invalid value."
eerror
eerror "Actual value:  ${OT_KERNEL_MENUCONFIG_UI}"
eerror "Valid values:  menuconfig, nconfig, xconfig, none, disable, unset"
eerror
				die
			fi
einfo "Running:  ARCH=${arch} make ${menuconfig_ui} ${menuconfig_colors} ${args[@]}"
			cat <<EOF > "${BUILD_DIR}/menuconfig.sh" || die
#!/bin/bash
export PATH="/usr/lib/llvm/${llvm_slot}/bin:\${PATH}"
cd "${BUILD_DIR}"
ARCH=${arch} make ${menuconfig_ui} ${menuconfig_colors} ${args[@]}
echo "Update settings to ${config}? (Y/N)"
read answer
if [[ "\${answer^^}" =~ ("Y"|"yes") ]] ; then
	echo "Copying ${BUILD_DIR}/.config -> ${config}"
	mkdir -p $(dirname "${config}")
	cp "${BUILD_DIR}/.config" "${config}"
fi
EOF
eerror
eerror "A wrapper script is provided to edit the config.  This menuconfig"
eerror "wrapper is to ensure to access compiler specific features."
eerror
eerror "Set OT_KERNEL_MENUCONFIG_UI=\"disabled\" when done."
eerror
eerror "To use the menu run:  ${BUILD_DIR}/menuconfig.sh"
eerror
eerror "For more info, see metadata.xml"
eerror "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)."
eerror
			chmod +x "${BUILD_DIR}/menuconfig.sh"
			die
		fi
	fi
}

# @FUNCTION: ot-kernel_check_kernel_signing_prereqs
# @DESCRIPTION:
# Check kernel signing prereqs
ot-kernel_check_kernel_signing_prereqs() {
	if [[ "${OT_KERNEL_SIGN_MODULES}" != "0" && -n "${OT_KERNEL_SIGN_MODULES}" ]] ; then
		use openssl || die "Enable the openssl USE flag for module signing"
	fi
	if [[ "${OT_KERNEL_SIGN_KERNEL}" =~ ("uefi"|"efi"|"kexec") ]] ; then
		use openssl || die "Enable the openssl USE flag for kernel signing"
	fi
}

# @FUNCTION: _ot-kernel_is_upstream_logo
# @DESCRIPTION:
# Is the file mentioned a logo found in the kernel source?
_ot-kernel_is_upstream_logo() {
	IFS=$'\n'
	local L=(
		$(find "${BUILD_DIR}/drivers/video/logo" -name "*.ppm")
	)
	local path
	for path in ${L[@]} ; do
		if [[ "${path}" =~ "${OT_KERNEL_LOGO_URI}" ]] ; then
			return 0
		fi
	done
	IFS=$' \t\n'
	return 1
}

# @FUNCTION: ot-kernel_set_kconfig_logo
# @DESCRIPTION:
# Fetch and use a kernel boot logo
ot-kernel_set_kconfig_logo() {
	if [[ -n "${OT_KERNEL_LOGO_URI}" ]] ; then
einfo "Using boot logo from ${OT_KERNEL_LOGO_URI}"
		if _ot-kernel_is_upstream_logo ; then
			:
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ ("http://"|"https://"|"ftp://") ]] ; then
			_check_network_sandbox
			wget -O "${T}/boot.logo" "${OT_KERNEL_LOGO_URI}" || die
		else
			local path="${OT_KERNEL_LOGO_URI}"
			path=$(echo "${path}" | sed -e "s|^file://||g")
			[[ -e "${path}" ]] || die "File not found"
			cat "${path}" > "${T}/boot.logo" || die

		fi
		local image_type=$(file "${T}/boot.logo")

		local gfx_pkg
		if ot-kernel_has_version "media-gfx/imagemagick" ; then
			gfx_pkg="media-gfx/imagemagick"
		elif ot-kernel_has_version "media-gfx/graphicsmagick" ; then
			gfx_pkg="media-gfx/graphicsmagick[imagemagick]"
		else
eerror
eerror "media-gfx/imagemagick or media-gfx/graphicsmagick[imagemagick] required"
eerror "for OT_KERNEL_LOGO_URI."
eerror
			die
		fi

		security-scan_avscan "${T}/boot.logo"

		local image_in_path=""
		if [[ "${image_type}" =~ "AVIF Image" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as avif."
			image_in_path="${T}/boot.avif"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "PC bitmap" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as bmp."
			image_in_path="${T}/boot.bmp"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "GIF image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as gif."
			ot-kernel_has_version "${gfx_pkg}" \
				|| die "Missing ${gfx_pkg} package"
			image_in_path="${T}/boot.gif"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "JPEG image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as jpeg."
			ot-kernel_has_version "${gfx_pkg}[jpeg]" \
				|| die "Missing image codec in ${gfx_pkg}[jpeg] package"
			image_in_path="${T}/boot.jpg"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "JPEG 2000 Part 1 (JP2)" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as jpeg2k."
			ot-kernel_has_version "${gfx_pkg}[jpeg2k]" \
				|| die "Missing image codec in ${gfx_pkg}[jpeg2k] package"
			image_in_path="${T}/boot.jp2"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "Netpbm image data".*"pixmap" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as ppm (colored pixmap)."
			image_in_path="${T}/boot.ppm"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "Netpbm image data".*"pixmap" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as pbm (b&w bitmap)."
			image_in_path="${T}/boot.pbm"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "OpenEXR image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as openexr."
			ot-kernel_has_version "${gfx_pkg}[openexr]" \
				|| die "Missing image codec in ${gfx_pkg}[openexr] package"
			image_in_path="${T}/boot.exr"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "PNG image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as png."
			ot-kernel_has_version "${gfx_pkg}[png]" \
				|| die "Missing image codec in ${gfx_pkg}[pkg] package"
			image_in_path="${T}/boot.png"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "SVG Scalable Vector Graphics image" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as svg."
			ot-kernel_has_version "${gfx_pkg}[svg]" \
				|| die "Missing image codec in ${gfx_pkg}[svg] package"
			image_in_path="${T}/boot.svg"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "Targa image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as tga."
			ot-kernel_has_version "${gfx_pkg}" \
				|| die "Missing ${gfx_pkg} package"
			image_in_path="${T}/boot.tga"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "TIFF image data" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as tiff."
			ot-kernel_has_version "${gfx_pkg}[tiff]" \
				|| die "Missing image codec in ${gfx_pkg}[tiff] package"
			image_in_path="${T}/boot.tiff"
			mv "${T}/boot.logo" "${image_in_path}" || die
		elif [[ "${image_type}" =~ "Web/P image" ]] ; then
einfo "${OT_KERNEL_LOGO_URI} accepted as webp."
			ot-kernel_has_version "${gfx_pkg}[webp]" \
				|| die "Missing image codec in ${gfx_pkg}[webp] package"
			image_in_path="${T}/boot.webp"
			mv "${T}/boot.logo" "${image_in_path}" || die
		else
eerror
eerror "Image not supported for ${OT_KERNEL_LOGO_URI}."
eerror
			die
		fi

		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_LOGO"
		ot-kernel_n_configopt "CONFIG_LOGO_LINUX_MONO"
		ot-kernel_n_configopt "CONFIG_LOGO_LINUX_VGA16"
		ot-kernel_n_configopt "CONFIG_LOGO_LINUX_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_DEC_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_MAC_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_PARISC_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_SGI_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_SUN_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_SUPERH_MONO"
		ot-kernel_n_configopt "CONFIG_LOGO_SUPERH_VGA16"
		ot-kernel_n_configopt "CONFIG_LOGO_SUPERH_CLUT224"
		ot-kernel_n_configopt "CONFIG_LOGO_CUSTOM_MONO"
		ot-kernel_n_configopt "CONFIG_LOGO_CUSTOM_VGA16"
		ot-kernel_n_configopt "CONFIG_LOGO_CUSTOM_CLUT224"
		if [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_dec_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_DEC_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_linux_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_LINUX_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_linux_mono.pbm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_LINUX_MONO"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_linux_vga16.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_LINUX_VGA16"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_mac_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_MAC_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_parisc_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_PARISC_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_sgi_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_SGI_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_spe_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_SPU_BASE"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_sun_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_SUN_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_superh_clut224.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_SUPERH_CLUT224"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_superh_mono.pbm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_SUPERH_MONO"
		elif [[ "${OT_KERNEL_LOGO_URI}" =~ "logo_superh_vga16.ppm" ]] ; then
			ot-kernel_y_configopt "CONFIG_LOGO_SUPERH_VGA16"
		elif [[ -n "${OT_KERNEL_LOGO_URI}" ]] ; then
			if [[ -n "${OT_KERNEL_LOGO_MAGICK_ARGS}" ]] ; then
				if [[ -z "${OT_KERNEL_LOGO_MAGICK_ARGS}" ]] ; then
eerror
eerror "OT_KERNEL_LOGO_MAGICK_ARGS must be defined."
eerror "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
eerror "details."
eerror
					die
				fi
				ot-kernel_has_version "${gfx_pkg}" || die
				if [[ -n "${OT_KERNEL_LOGO_PREPROCESS_PATH}" ]] ; then
einfo "Running preprocessing script"
					local access_permissions=$(stat -c "%a" "${OT_KERNEL_LOGO_PREPROCESS_PATH}")
					if [[ "${access_permissions}" != "700" ]] ; then
eerror
eerror "Chmod permissions:\t${access_permissions}"
eerror
eerror "${OT_KERNEL_LOGO_PREPROCESS_PATH} must be 700"
eerror "Check if the contents of the script if it has been compromised."
eerror
						die
					fi
					local group_name=$(stat -c "%G" "${OT_KERNEL_LOGO_PREPROCESS_PATH}")
					if [[ "${group_name}" != "root" ]] ; then
eerror
eerror "Group name:\t${group_name}"
eerror
eerror "${OT_KERNEL_LOGO_PREPROCESS_PATH} must be root"
eerror "Check if the contents of the script if it has been compromised."
eerror
						die
					fi
					local owner_name=$(stat -c "%G" "${OT_KERNEL_LOGO_PREPROCESS_PATH}")
					if [[ "${owner_name}" != "root" ]] ; then
eerror
eerror "Owner name:\t${owner_name}"
eerror
eerror "${OT_KERNEL_LOGO_PREPROCESS_PATH} must be root"
eerror "Check if the contents of the script if it has been compromised."
eerror
						die
					fi
					local preprocess_script_sha512=$(sha512sum "${OT_KERNEL_LOGO_PREPROCESS_PATH}" \
						| cut -f 1 -d " ")
					local preprocess_script_blake2b=$(rhash --blake2b "${OT_KERNEL_LOGO_PREPROCESS_PATH}" \
						| cut -f 1 -d " ")
					if [[ "${OT_KERNEL_LOGO_PREPROCESS_SHA512}" != "${preprocess_script_sha512}" \
						|| "${OT_KERNEL_LOGO_PREPROCESS_BLAKE2B}" != "${preprocess_script_blake2b}" ]] ; then
eerror
eerror "Detected failed integrity with logo preprocess script"
eerror
eerror "Actual sha512:\t${preprocess_script_sha512}"
eerror "Expected sha512:\t${OT_KERNEL_LOGO_PREPROCESS_SHA512}"
eerror
eerror "Actual blake2b:\t${preprocess_script_blake2b}"
eerror "Expected blake2b:\t${OT_KERNEL_LOGO_PREPROCESS_BLAKE2B}"
eerror
						die
					fi
					export image_in_path
					"${OT_KERNEL_LOGO_PREPROCESS_PATH}"
				fi
				local colors_suffix=""
				local colors_ext=""
				if [[ "${OT_KERNEL_LOGO_MAGICK_ARGS}" =~ "-colors 1" ]] ; then
einfo "Enabling custom logo (mono)"
					ot-kernel_y_configopt "CONFIG_LOGO_CUSTOM_MONO"
					colors_suffix="mono"
					colors_ext="pbm"
				elif [[ "${OT_KERNEL_LOGO_MAGICK_ARGS}" =~ "-colors 16" ]] ; then
einfo "Enabling custom logo (16 colors)"
					ot-kernel_y_configopt "CONFIG_LOGO_CUSTOM_VGA16"
					colors_suffix="vga16"
					colors_ext="ppm"
				elif [[ "${OT_KERNEL_LOGO_MAGICK_ARGS}" =~ "-colors 224" ]] ; then
einfo "Enabling custom logo (224 colors)"
					ot-kernel_y_configopt "CONFIG_LOGO_CUSTOM_CLUT224"
					colors_suffix="clut224"
					colors_ext="ppm"
				else
eerror
eerror "You need to add one of the following rows to"
eerror "OT_KERNEL_LOGO_MAGICK_ARGS:"
eerror
eerror "  -colors 1"
eerror "  -colors 16"
eerror "  -colors 224"
eerror
					die
				fi
				magick \
					"${image_in_path}" \
					-compress None \
					${OT_KERNEL_LOGO_MAGICK_ARGS} \
					"${BUILD_DIR}/drivers/video/logo/logo_custom_${colors_suffix}.${colors_ext}" \
					|| die

				security-scan_avscan "${BUILD_DIR}/drivers/video/logo/logo_custom_${colors_suffix}.${colors_ext}"

				if [[ "${OT_KERNEL_LOGO_URI}" =~ ("http://"|"https://"|"ftp://") ]] ; then
					if [[ "${OT_KERNEL_LOGO_LICENSE_URI}" =~ ("http://"|"https://"|"ftp://") ]] ; then
						wget -O "${BUILD_DIR}/drivers/video/logo/logo_custom_${colors_suffix}.ppm.license" \
						"${OT_KERNEL_LOGO_LICENSE_URI}" || die
					fi
				else
					local path
					path="${OT_KERNEL_LOGO_LICENSE_URI}"
					path=$(echo "${path}" | sed -e "s|^file://||g")
					if [[ -e "${path}" ]] ; then
						cat "${path}" "${BUILD_DIR}/drivers/video/logo/logo_custom_${colors_suffix}.ppm.license" \
							|| die
					fi
				fi
			fi
		fi

		# If loglevel_default <= loglevel_quiet, then disable logo.
		# (Kernel commit: 1099350)
ewarn
ewarn "The OT_KERNEL_LOGO_URI will restore the console log levels to defaults."
ewarn "This may decrease security."
ewarn
		if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor ; then
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_DEFAULT" "2"
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_QUIET" "1"
		else
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_DEFAULT" "4"
			ot-kernel_set_configopt "CONFIG_CONSOLE_LOGLEVEL_QUIET" "3"
		fi

		ot-kernel_unset_pat_kconfig_kernel_cmdline "fbcon=logo-count:[-]?[0-9]*"
		if [[ "${OT_KERNEL_LOGO_COUNT:-auto}" == "auto" ]] ; then
			:
		elif [[ "${OT_KERNEL_LOGO_COUNT}" =~ [0-9][0-9]* ]] ; then
			if ver_test ${KV_MAJOR_MINOR} -ge 5.6 ; then
				ot-kernel_set_kconfig_kernel_cmdline "fbcon=logo-count:${OT_KERNEL_LOGO_COUNT}"
			else
				sed -i -e "s|num_online_cpus()|${OT_KERNEL_LOGO_COUNT}|g" \
					"${BUILD_DIR}/drivers/video/fbdev/core/fbmem.c" || die
			fi
		elif [[ "${OT_KERNEL_LOGO_COUNT}" =~ "-" ]] ; then
			:
		else
eerror
eerror "OT_KERNEL_LOGO_COUNT must be auto or an integer."
eerror
			die

		fi

		if [[ -n "${OT_KERNEL_LOGO_FOOTNOTES_ON_INIT}" ]] ; then
einfo "Adding logo footnote on init:  ${OT_KERNEL_LOGO_FOOTNOTES}"
			local file_path="init/main.c"
			grep -F -q -n "argv_init[0] = init_filename;" \
				"${BUILD_DIR}/${file_path}" || die "Missing fragment"
			local offset
			offset=$(grep -F -n "argv_init[0] = init_filename;" \
				"${BUILD_DIR}/${file_path}" \
				| cut -f 1 -d ":")
			sed -i -e "${offset}a\\\tpr_alert(\"${OT_KERNEL_LOGO_FOOTNOTES}\\\\n\");" \
				"${BUILD_DIR}/${file_path}"
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_PRINTK"
#			if [[ "${arch}" == "x86" ]] ; then
#				ot-kernel_y_configopt "CONFIG_EARLY_PRINTK"
#			fi
ewarn
ewarn "OT_KERNEL_LOGO_FOOTNOTES_ON_INIT will enable early printk which may"
ewarn "lower security."
ewarn
		fi
	fi
}

# @FUNCTION: ot-kernel_set_at_system
# @DESCRIPTION:
# Required unconditionally for `emerge @system`
ot-kernel_set_at_system() {
# Maybe someday we can start with a complete empty .config which the user just
# enables the drivers they need.  This function can enable the rest of the
# required.  This isn't possible at the moment and the reason why we start
# with the default .config setting.
	ot-kernel_y_configopt "CONFIG_BINFMT_ELF"
	ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT"
}

# @FUNCTION: ot-kernel_set_tcca
# @DESCRIPTION:
# Required for the tcca script
ot-kernel_set_tcca() {
	[[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT:-1}" == "1" ]] || return
	ot-kernel_y_configopt "CONFIG_PROC_FS"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_PROC_SYSCTL" # For /proc/sys support
}

# @FUNCTION: ot-kernel_set_iosched_kconfig
# @DESCRIPTION:
# Required for the iosched openrc script
ot-kernel_set_iosched_kconfig() {
	[[ \
		   "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" \
		|| "${OT_KERNEL_IOSCHED_SYSTEMD:-1}" == "1" \
	]] \
	|| return
	ot-kernel_y_configopt "CONFIG_SYSFS"
}

# @FUNCTION: ot-kernel_set_message
# @DESCRIPTION:
# Prints a message at the end of the kernel init.
ot-kernel_set_message() {
	if [[ -n "${OT_KERNEL_MESSAGE}" ]] ; then
einfo "Adding message on init:  ${OT_KERNEL_MESSAGE}"
		local file_path="init/main.c"
		grep -F -q -n "argv_init[0] = init_filename;" \
			"${BUILD_DIR}/${file_path}" || die "Missing fragment"
		local offset
		offset=$(grep -F -n "argv_init[0] = init_filename;" \
			"${BUILD_DIR}/${file_path}" \
			| cut -f 1 -d ":")
		sed -i -e "${offset}a\\\tpr_alert(\"${OT_KERNEL_MESSAGE}\\\\n\");" \
			"${BUILD_DIR}/${file_path}"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PRINTK"
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_from_envvar_array
# @DESCRIPTION:
# Set flag(s) or a string in the the kernel config from an environment variable.
ot-kernel_set_kconfig_from_envvar_array() {
	local sym
	for sym in ${!OT_KERNEL_KCONFIG[@]} ; do
		if [[ "${OT_KERNEL_KCONFIG[${sym}]}" == "n" \
			|| "${OT_KERNEL_KCONFIG[${sym}]}" == " " ]] ; then
einfo "Unsetted ${sym} in .config"
			ot-kernel_unset_configopt "${sym}"
		else
einfo "Changed to ${sym}=${OT_KERNEL_KCONFIG[${sym}]} in .config"
			ot-kernel_set_configopt "${sym}" "${OT_KERNEL_KCONFIG[${sym}]}"
		fi
	done
}

# @FUNCTION: ot-kernel_set_rust
# @DESCRIPTION:
# Sets config for support for drivers programmed in Rust and Rust related kernel
# options.
#
# CONFIG_RUST is not supported on distro because it is an old version.
#
# Kernel docs say it requires a specific version and no forward compatible
# guarantees
#
ot-kernel_set_rust() {
	ot-kernel_use rust || return
	if has_version "~virtual/rust-${RUST_PV}" ; then
		ot-kernel_y_configopt "CONFIG_RUST"
		ot-kernel_unset_configopt "CONFIG_MODVERSIONS"
		ot-kernel_unset_configopt "CONFIG_GCC_PLUGINS"
		ot-kernel_unset_configopt "CONFIG_RANDSTRUCT"
		ot-kernel_unset_configopt "CONFIG_DEBUG_INFO_BTF"
	fi
}


# @FUNCTION: ot-kernel_set_kconfig_amdgpu_override_mask
# @DESCRIPTION:
#
# !!! DANGEROUS:  EXPERTS ONLY !!!
#
# Enable or disable the flag to allow for overclocking or voltage changes.
#
ot-kernel_set_kconfig_amdgpu_override_mask() {
	ver_test ${KV_MAJOR_MINOR} -lt 4.18 && return
	if [[ "${AMDGPU_OVERDRIVE}" == "1" ]] ; then
		if [[ -e "/sys/module/amdgpu/parameters/ppfeaturemask" ]] ; then
ewarn "Enabling overdrive on the amdgpu driver."
			local current_value=$(cat /sys/module/amdgpu/parameters/ppfeaturemask)
			local pp_override_mask="0x00004000"
			local result=$((${current_value} | ${pp_override_mask}))
# https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/include/amd_shared.h#L222
			result=$((${result} & 0xffffffff)) # Truncate to 32 bits
			result=$(printf 'amdgpu.ppfeaturemask=0x%x\n' ${result})
			ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.ppfeaturemask=[x0-9]+"
			ot-kernel_set_kconfig_kernel_cmdline "${result}"
		fi
	elif [[ "${AMDGPU_OVERDRIVE}" == "0" ]] ; then
		if [[ -e "/sys/module/amdgpu/parameters/ppfeaturemask" ]] ; then
einfo "Disabling overdrive on the amdgpu driver."
			local current_value=$(cat /sys/module/amdgpu/parameters/ppfeaturemask)
			local pp_override_mask="0x00004000"
			local result=$((${current_value} & ~${pp_override_mask}))
			result=$((${result} & 0xffffffff)) # Truncate to 32 bits
			result=$(printf 'amdgpu.ppfeaturemask=0x%x\n' ${result})
			ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.ppfeaturemask=[x0-9]+"
			ot-kernel_set_kconfig_kernel_cmdline "${result}"
		fi
	fi
}

# @FUNCTION: ot-kernel_optimize_gaming_oflag
# @DESCRIPTION:
# Set gaming optimizations before main set.
ot-kernel_optimize_gaming_oflag() {
	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	[[ "${work_profile}" == "pro-gaming" ]] || return
	filter-flags '-O*'
	append-flags '-O3' # This is in testing
	if ! ot-kernel_use zen-sauce ; then
ewarn "-O3 requires zen-sauce in both OT_KERNEL_USE and USE."
	fi
}

# @FUNCTION: ot-kernel_optimize_gaming_tournament_oflag
# @DESCRIPTION:
# Set game-tournament optimizations before main set
ot-kernel_optimize_gaming_tornament_oflag() {
	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	[[ "${work_profile}" == "gaming-tournament" ]] || return
	filter-flags '-O*'
	# Stability is more important that FPS.
	append-flags '-O3' # This is in testing.
	if ! ot-kernel_use zen-sauce ; then
ewarn "-O3 requires zen-sauce in both OT_KERNEL_USE and USE."
	fi
}

# @FUNCTION: ot-kernel_optimize_gaming
# @DESCRIPTION:
# Optimize the kernel for gaming performance for the top 1%.
ot-kernel_optimize_gaming() {
	local work_profile="${1}"
ewarn
ewarn "OT_KERNEL_WORK_PROFILE=\"${work_profile}\" is still in development."
ewarn
	if [[ "${hardening_level}" =~ ("default"|"practical"|"secure"|"secure-af"|"secure-as-fuck") ]] ; then
eerror
eerror "Please change to OT_KERNEL_HARDENING_LEVEL=\"performance\" and remove"
eerror "all hardening flags from OT_KERNEL_EXTRAVERSION=\"${extraversion}\""
eerror
		die
	fi
	if [[ "${work_profile}" == "gaming-tournament" \
		&& "${OT_KERNEL_CPU_MICROCODE}" == "1" ]] ; then
ewarn
ewarn "Disabling microcode for OT_KERNEL_WORK_PROFILE=\"${work_profile}\".  If"
ewarn "you do not like this, use the pro-gaming profile instead."
ewarn
# Drops FPS.
		ot-kernel_unset_configopt "CONFIG_MICROCODE"
		ot-kernel_unset_configopt "CONFIG_MICROCODE_LATE_LOADING"
	fi
	if ot-kernel_use uksm ; then
# Remove the unintended consequences of applying the patch.
# UKSM also thrashes a lot so lets get rid of that.
eerror
eerror "Please remove uksm from OT_KERNEL_USE in"
eerror "OT_KERNEL_EXTRAVERSION=\"${extraversion}\""
eerror
		die
	fi
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		if ! tc-is-cross-compiler ; then
			local tpc=$(lscpu \
				| grep  -e "Thread(s) per core:.*" \
				| head -n 1 \
				| grep -E -o "[0-9]+")
			if (( tpc > 1 )) && ver_test ${KV_MAJOR_MINOR} -ge 4.10 ; then
				# Already set in ot-kernel_set_kconfig_processor_class
				# ot-kernel_y_configopt "CONFIG_SMP"
				# ot-kernel_y_configopt "CONFIG_SCHED_MC"
				if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
					ot-kernel_y_configopt "CONFIG_SCHED_MC_PRIO"
				else
					ot-kernel_unset_configopt "CONFIG_SCHED_MC_PRIO"
				fi
			fi
		fi
	fi

# Avoid huge latency spike or trashing.
	if has_version "sys-apps/systemd-utils" ; then
		if has_version "sys-apps/systemd-utils[tmpfiles]" ; then
			if tc-is-cross-compiler ; then
ewarn
ewarn "You need to disable the tmpfiles USE flag in sys-apps/systemd-utils to"
ewarn "avoid middle of the game lag spike or match/game loss."
ewarn
			else
eerror
eerror "You need to disable the tmpfiles USE flag in sys-apps/systemd-utils to"
eerror "avoid middle of the game lag spike or match/game loss."
eerror
				die
			fi
		fi
	fi
	ot-kernel_unset_configopt "CONFIG_SLUB_CPU_PARTIAL"
}

# @FUNCTION: ot-kernel_optimize_realtime
# @DESCRIPTION:
# Remove sources of latency and jitter
ot-kernel_optimize_realtime() {
	if \
		   grep -q -e "^CONFIG_PREEMPT_RT=y"      "${path_config}" \
		|| grep -q -e "^CONFIG_PREEMPT_RT_BASE=y" "${path_config}" \
		|| grep -q -e "^CONFIG_PREEMPT_RT_FULL=y" "${path_config}" \
	; then
		_OT_KERNEL_FORCE_SWAP_OFF=1

		ot-kernel_unset_pat_kconfig_kernel_cmdline "nosmt=force"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nosmt"

# Avoid lock contention penalty
ewarn "Disabling smt for PREEMPT_RT=y.  If you do not like this, disable rt from OT_KERNEL_USE."
		if ver_test ${KV_MAJOR_MINOR} -ge 6.6 && [[ "${arch}" == "mips" || "${arch}" == "powerpc" || "${arch}" == "s390" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt"
		elif ver_test ${KV_MAJOR_MINOR} -ge 6.6 && [[ "${arch}" == "x86" || "${arch}" == "x86_64" || "${arch}" == "powerpc" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt=force"

		elif ver_test ${KV_MAJOR_MINOR} -ge 6.5 && [[ "${arch}" == "mips" || "${arch}" == "s390" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt"
		elif ver_test ${KV_MAJOR_MINOR} -ge 6.5 && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt=force"

		elif ver_test ${KV_MAJOR_MINOR} -ge 4.19 && [[ "${arch}" == "s390" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt"
		elif ver_test ${KV_MAJOR_MINOR} -ge 4.19 && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt=force"

		elif ver_test ${KV_MAJOR_MINOR} -eq 4.10 && [[ "${arch}" == "s390" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nosmt"
		fi

		if grep -q -e "^CONFIG_TRANSPARENT_HUGEPAGE=y" "${path_config}" ; then
ewarn "Disabling Transparent HugePage (THP) for PREEMPT_RT=y.  If you do not like this, disable rt from OT_KERNEL_USE."
			ot-kernel_unset_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
		fi

		if [[ "${hardening_level}" != "performance" ]] ; then
eerror
eerror "Please change to OT_KERNEL_HARDENING_LEVEL=\"performance\" and remove"
eerror "all hardening flags from OT_KERNEL_EXTRAVERSION=\"${extraversion}\""
eerror
			die
		fi

# It does mutex locking.
ewarn "Disabling 16-bit support.  If you do not like this, disable rt from OT_KERNEL_USE."
		ot-kernel_unset_configopt "CONFIG_MODIFY_LDT_SYSCALL"

# This may drain the battery faster.
		ot-kernel_set_kconfig_kernel_cmdline "skew_tick=1"

# Avoid huge latency spike or trashing.
		if has_version "sys-apps/systemd-utils" ; then
			if has_version "sys-apps/systemd-utils[tmpfiles]" ; then
				if tc-is-cross-compiler ; then
ewarn
ewarn "You need to disable the tmpfiles USE flag in sys-apps/systemd-utils to"
ewarn "avoid production quality failure/degration."
ewarn
				else
eerror
eerror "You need to disable the tmpfiles USE flag in sys-apps/systemd-utils to"
eerror "avoid production quality failure/degration."
eerror
					die
				fi
			fi
		fi
	else
# nosmt is resetted in ot-kernel_set_kconfig_hardening_level()
		ot-kernel_unset_pat_kconfig_kernel_cmdline "skew_tick=(0|1)"
	fi
	ot-kernel_unset_configopt "CONFIG_SLUB_CPU_PARTIAL"
}

_OT_KERNEL_FORCE_SWAP_OFF=0

# @FUNCTION: ot-kernel_src_configure_assisted
# @DESCRIPTION:
# More assisted configuration
ot-kernel_src_configure_assisted() {
einfo "Using assisted config mode"
	local path_config="${BUILD_DIR}/.config"
	if [[ -e "${config}" ]] ; then
einfo "Copying the savedconfig:  ${config} -> ${path_config}"
		cat "${config}" > "${path_config}" || die
einfo "Auto updating the .config"
einfo "Running:  make olddefconfig ${args[@]}"
		make olddefconfig "${args[@]}" || die
	fi

	local is_default_config=0
	if [[ ! -e "${path_config}" ]] ; then
ewarn "Missing ${path_config} so generating a new default config."
		make defconfig "${args[@]}" || die
		is_default_config=1
		[[ -z "${boot_decomp}" ]] && boot_decomp="default" # Reason why is for compatibility issues.
	else
		[[ -z "${boot_decomp}" ]] && boot_decomp="manual" # Assumes it was tested and working.
	fi

einfo "Changing config options for -${extraversion}"
	[[ -e "${path_config}" ]] || die ".config is missing"

	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		local mfg=$(ot-kernel_get_cpu_mfg_id)
# It is wrong when CBUILD != CHOST/CTARGET.
einfo
einfo "The CPU vendor is set to ${mfg}.  If it is wrong, please manually change"
einfo "it with the CPU_MFG envvar."
einfo
einfo "For more info, see metadata.xml"
einfo "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)."
einfo
	fi

	local hardening_level="${OT_KERNEL_HARDENING_LEVEL:-manual}"

	local llvm_slot=$(get_llvm_slot)
	local gcc_slot=$(get_gcc_slot)
	ot-kernel_set_kconfig_compiler_toolchain # Inits llvm_slot, gcc_slot
	ot-kernel_menuconfig "pre" # Uses llvm_slot

	ot-kernel_set_kconfig_march
	ot-kernel_set_kconfig_oflag
	ot-kernel_set_kconfig_lto # Uses llvm_slot
	ot-kernel_set_kconfig_abis
	#ot-kernel_set_kconfig_mem

	ot-kernel_set_kconfig_init_systems
	ot-kernel_set_kconfig_boot_args
	ot-kernel_set_kconfig_processor_class
	ot-kernel_set_kconfig_page_size
	ot-kernel_set_kconfig_auto_set_slab_allocator
	ot-kernel_set_kconfig_cpu_scheduler
	ot-kernel_set_kconfig_multigen_lru
	ot-kernel_set_kconfig_compressors
	ot-kernel_set_kconfig_set_tcp_congestion_controls # Place before ot-kernel_set_kconfig_work_profile
	ot-kernel_set_kconfig_set_net_qos_schedulers
	ot-kernel_set_kconfig_set_net_qos_classifiers
	ot-kernel_set_kconfig_set_net_qos_actions
	# See also ot-kernel-pkgflags.eclass: _ot-kernel_set_netfilter()
	ot-kernel_set_kconfig_work_profile # Sets PREEMPT*
	ot-kernel_set_kconfig_pcie_mps
	ot-kernel_set_kconfig_usb_autosuspend
	ot-kernel_set_kconfig_usb_flash_disk

	ot-kernel_set_kconfig_usb_mass_storage
	ot-kernel_set_kconfig_mmc_sd_sdio
	ot-kernel_set_kconfig_memstick
	ot-kernel_set_kconfig_exfat
	ot-kernel_set_kconfig_amdgpu_override_mask

	ot-kernel_set_kconfig_firmware
	ot-kernel_check_firmware

	ot-kernel_set_mobo_audio
	ot-kernel_set_webcam
	ot-kernel_set_mobile_camera

	_OT_KERNEL_FORCE_SWAP_OFF=0

	# The ot-kernel-pkgflags_apply has higher weight than ot-kernel_set_kconfig_work_profile for PREEMPT*
	ot-kernel-pkgflags_apply # Sets PREEMPT*, uses hardening_level
	ot-kernel_set_kconfig_fallback_preempt
	ot-kernel_optimize_realtime
	ot-kernel_set_kconfig_swap
	ot-kernel_set_kconfig_zswap
	ot-kernel_set_kconfig_uksm
	ot-kernel_set_at_system
	ot-kernel_set_tcca
	ot-kernel_set_iosched_kconfig

	is_firmware_ready

	if ot-kernel_use disable_debug ; then
einfo "Disabling all debug and shortening logging buffers"
		./disable_debug || die
		rm "${BUILD_DIR}/.config.dd_backup" 2>/dev/null
	fi
	ot-kernel_set_kconfig_dmesg ""
	ot-kernel_set_kconfig_kexec
	ot-kernel_set_kconfig_reisub

	ot-kernel_set_kconfig_logo

	# Continue hardening_level context:
		ot-kernel_set_kconfig_hardening_level
		ot-kernel_set_kconfig_scs # Uses llvm_slot
		ot-kernel_set_kconfig_cfi # Uses llvm_slot
		ot-kernel_set_kconfig_kcfi # Uses llvm_slot
	ot-kernel_set_kconfig_iommu_domain_type
	ot-kernel-pkgflags_cipher_optional
	ot-kernel_set_kconfig_cold_boot_mitigation
	ot-kernel_set_kconfig_dma_attack_mitigation
	ot-kernel_set_kconfig_memory_protection
	ot-kernel_set_kconfig_tresor
	ot-kernel_set_kconfig_ima
	ot-kernel_set_kconfig_lsms

	ot-kernel_set_kconfig_pgo # Uses llvm_slot

	ot-kernel_set_kconfig_module_support
	ot-kernel_set_kconfig_build_all_modules_as
	ot-kernel_set_kconfig_eudev
	ot-kernel_check_kernel_signing_prereqs
	ot-kernel_set_kconfig_module_signing
	ot-kernel_set_message

	ot-kernel_set_rust
	ot-kernel_set_kconfig_cpu_scheduler_post

	ot-kernel_set_kconfig_from_envvar_array

	if [[ -e "${BUILD_DIR}/.config" ]] ; then
		if has exfat ${IUSE_EFFECTIVE} && ! use exfat ; then
			sed -i -e "/CONFIG_EXFAT_FS/d" "${BUILD_DIR}/.config"
		fi

		if ! use reiserfs ; then
			sed -i -e "/CONFIG_REISERFS_FS/d" "${BUILD_DIR}/.config"
		fi
	fi

einfo "Updating the .config for defaults for the newly enabled options."
einfo "Running:  make olddefconfig ${args[@]}"
	make olddefconfig "${args[@]}" || die
	ot-kernel_menuconfig "post" # Uses llvm_slot
}

# @FUNCTION: ot-kernel_src_configure_custom
# @DESCRIPTION:
# More customized
ot-kernel_src_configure_custom() {
einfo "Using custom config mode"
	local path_config="${BUILD_DIR}/.config"
	if [[ -e "${config}" ]] ; then
einfo "Copying the savedconfig:  ${config} -> ${path_config}"
		cat "${config}" > "${path_config}" || die
	fi

	if [[ ! -e "${path_config}" ]] ; then
ewarn "Missing ${path_config} so generating a new default config."
		make defconfig "${args[@]}" || die
	fi

	local llvm_slot=$(get_llvm_slot)
	local gcc_slot=$(get_gcc_slot)
	ot-kernel_set_kconfig_compiler_toolchain # Inits llvm_slot, gcc_slot
	ot-kernel_menuconfig "pre" # Uses llvm_slot
	ot-kernel_menuconfig "post" # Uses llvm_slot
}

# @FUNCTION: _ot-kernel_check_versions
# @DESCRIPTION:
# A wrapper for version checks.
_ot-kernel_check_versions() {
	local _catpn="${1}"
	local _pv="${2}"
	local _kconfig_symbol="${3}"
	local _p="${_catpn}-${_pv}"
	local path_config="${BUILD_DIR}/.config"
	if has_version ">=${_p}" ; then
		:
	elif has_version "<${_p}" && [[ -n "${_kconfig_symbol}" ]] ; then
ewarn ">=${_p} is required for ${_kconfig_symbol} support."
	elif has_version "<${_p}" && [[ -z "${_kconfig_symbol}" ]] ; then
ewarn ">=${_p} is required by the kernel."
	elif ! has_version "${_catpn}" \
		&& [[ -n "${_kconfig_symbol}" ]] \
		&& grep -q -E -e "^${_kconfig_symbol}=(y|m)" "${path_config}" ; then
ewarn ">=${_p} is maybe required for ${_kconfig_symbol} support."
	elif ! has_version "${_catpn}" \
		&& [[ -z "${_kconfig_symbol}" ]] ; then
ewarn ">=${_p} is maybe required by the kernel."
	fi
}

# @FUNCTION: ot-kernel_src_configure
# @DESCRIPTION:
# Run menuconfig
ot-kernel_src_configure() {
	ot-kernel_is_build || return
	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue

		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		local config="${OT_KERNEL_CONFIG}"
		local arch="${OT_KERNEL_ARCH}" # ARCH in raw form.
		local default_config="/etc/kernels/kernel-config-${KV_MAJOR_MINOR}-${extraversion}-${arch}"
		[[ -z "${config}" ]] && config="${default_config}"
		local target_triple="${OT_KERNEL_TARGET_TRIPLE}"
		local cpu_sched="${OT_KERNEL_CPU_SCHED}"
		local boot_decomp="${OT_KERNEL_BOOT_DECOMPRESSOR}"
		local kernel_dir="${OT_KERNEL_KERNEL_DIR:-/boot}"
		local check_mounted="${OT_KERNEL_BUILD_CHECK_MOUNTED:-1}"
		[[ "${target_triple}" == "CHOST" ]] && target_triple="${CHOST}"
		[[ "${target_triple}" == "CBUILD" ]] && target_triple="${CBUILD}"
		[[ -z "${cpu_sched}" ]] && cpu_sched="cfs"
		ot-kernel_use rt && cpu_sched="cfs"
		[[ -z "${target_triple}" ]] && target_triple="${CHOST}"
		#[[ -z "${boot_decomp}" ]] && boot_decomp="manual"
		[[ -z "${extraversion}" ]] && die "extraversion cannot be empty"
		[[ -z "${config}" ]] && die "config cannot be empty"
		[[ -z "${arch}" ]] && die "arch cannot be empty"
		[[ -z "${target_triple}" ]] && die "target_triple cannot be empty"
		[[ -z "${cpu_sched}" ]] && die "cpu_sched cannot be empty"
		#[[ -z "${boot_decomp}" ]] && die "boot_decomp cannot be empty"
		[[ -z "${kernel_dir}" ]] && die "OT_KERNEL_KERNEL_DIR cannot be empty"
		if [[ "${OT_KERNEL_BUILD_CHECK_MOUNTED}" == "1" && "${OT_KERNEL_BUILD}" == "1" ]] ; then
			if mount | grep "${kernel_dir}" ; then
				:
			else
eerror
eerror "OT_KERNEL_KERNEL_DIR=${OT_KERNEL_KERNEL_DIR}"
eerror "Directory is not mounted."
eerror
eerror "To disable this check, set OT_KERNEL_BUILD_CHECK_MOUNTED=0"
eerror
				die
			fi
		fi

		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		cd "${BUILD_DIR}" || die

		local args=()
		ot-kernel_setup_tc

		if [[ "${OT_KERNEL_CONFIG_MODE:-assisted}" =~ "assist" ]] ; then
			ot-kernel_src_configure_assisted
		else
			ot-kernel_src_configure_custom
		fi

		if declare -f ot-kernel_check_versions >/dev/null ; then
			ot-kernel_check_versions
		fi
	done
}

# @FUNCTION: get_llvm_slot
# @DESCRIPTION:
# Gets a ready to use clang compiler
get_llvm_slot() {
	local llvm_slot
	for llvm_slot in $(seq ${LLVM_COMPAT[0]} -1 ${LLVM_COMPAT[-1]}) ; do
		ot-kernel_has_version "sys-devel/llvm:${llvm_slot}" && is_clang_ready && break
	done
	echo "${llvm_slot}"
}

# @FUNCTION: get_llvm_slot
# @DESCRIPTION:
# Gets a ready to use gcc compiler
get_gcc_slot() {
	local gcc_slot
	for gcc_slot in $(seq ${GCC_COMPAT[0]} -1 ${GCC_COMPAT[-1]}) ; do
		ot-kernel_has_version "${GCC_PKG}:${gcc_slot}" && is_gcc_ready && break
	done
	echo "${gcc_slot}"
}

# @FUNCTION: ot-kernel_setup_tc
# @DESCRIPTION:
# Setup toolchain args to pass to make
ot-kernel_setup_tc() {
	# The make command likes to complain before the build when trying to make menuconfig.
einfo "Setting up the build toolchain"
	args+=(
		"${MAKEOPTS}"
		"ARCH=${arch}"
		"INSTALL_MOD_PATH=${ED}"
		"INSTALL_PATH=${ED}${kernel_dir}"
	)
	local llvm_slot=$(get_llvm_slot)
	local gcc_slot=$(get_gcc_slot)
	if [[ -n "${cross_compile_target}" ]] ; then
		args+=(
			"CROSS_COMPILE=${target_triple}-"
		)
	fi

	# tresor is broken with clang?  puts missing.
	# ld.lld: error: undefined symbol: puts

#			|| ( has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo ) \
	if \
		( \
			   ( has cfi ${IUSE_EFFECTIVE} && ot-kernel_use cfi ) \
			|| ( has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi ) \
			|| ( has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ) \
			|| ( has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang ) \
		) \
		&& ! tc-is-cross-compiler \
		&& is_clang_ready \
	; then
		if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor ; then
# Ask to disable to remove clang patches or force GCC PGO.
eerror
eerror "TRESOR is not compatable with clang."
eerror
eerror "To resolve, do of the following below"
eerror
eerror "1.Change OT_KERNEL_USE=\"... -clang\" in /etc/portage/ot-sources/${KV_MAJOR_MINOR}/<extraversion>/<arch>/env"
eerror "2.Change OT_KERNEL_USE=\"... -tresor\" in /etc/portage/ot-sources/${KV_MAJOR_MINOR}/<extraversion>/<arch>/env"
eerror
			die
		fi

einfo "Using Clang ${llvm_slot}"
		ot-kernel_has_version "sys-devel/llvm:${llvm_slot}" || die "sys-devel/llvm:${llvm_slot} is missing"
		# Assumes we are not cross-compiling or we are only building on CBUILD=CHOST.
		args+=(
			"CC=${CHOST}-clang-${llvm_slot}"
			"CXX=${CHOST}-clang++-${llvm_slot}"
			"LD=ld.lld"
			"AR=llvm-ar"
			"NM=llvm-nm"
			"STRIP=llvm-strip"
			"OBJCOPY=llvm-objcopy"
			"OBJDUMP=llvm-objdump"
			"READELF=llvm-readelf"
			"HOSTCC=${CBUILD}-clang-${llvm_slot}"
			"HOSTCXX=${CBUILD}-clang++-${llvm_slot}"
			"HOSTAR=llvm-ar"
			"HOSTLD=ld.lld"
		)
		# For flag-o-matic
		CC="${CHOST}-clang-${llvm_slot}"
		CXX="${CHOST}-clang++-${llvm_slot}"
		LD="ld.lld"
einfo "PATH=${PATH} (before)"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "/llvm/d" \
				| tr "\n" ":" \
				| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${llvm_slot}/bin:${PWD}/install/bin|g")
einfo "PATH=${PATH} (after)"
	else
#		if has_version "sys-devel/gcc-kpgo" && use pgo ; then
#einfo "Detected sys-devel/gcc-kpgo"
#			export PATH="${ESYSROOT}/usr/lib/gcc-kpgo/usr/bin:${PATH}"
#			if [[ "${FEATURES}" =~ "ccache" ]] ; then
#				export CCACHE_PATH="${ESYSROOT}/usr/lib/gcc-kpgo/usr/bin"
#			fi
#		fi

		is_gcc_ready || ot-kernel_compiler_not_found "Failed compiler sanity check for gcc"
		args+=(
			"CC=${CHOST}-gcc-${gcc_slot}"
			"CXX=${CHOST}-g++-${gcc_slot}"
			"LD=${CHOST}-ld.bfd"
			"AR=${CHOST}-ar"
			"NM=${CHOST}-nm"
			"STRIP=${CHOST}-strip"
			"OBJCOPY=${CHOST}-objcopy"
			"OBJDUMP=${CHOST}-objdump"
			"READELF=${CHOST}-readelf"
			"HOSTCC=${CBUILD}-gcc-${gcc_slot}"
			"HOSTCXX=${CBUILD}-g++-${gcc_slot}"
			"HOSTAR=${CBUILD}-ar"
			"HOSTLD=${CBUILD}-ld.bfd"
		)
		# For flag-o-matic
		CC="${CHOST}-gcc-${gcc_slot}"
		CXX="${CHOST}-g++-${gcc_slot}"
		LD="ld.bfd"
	fi

	#filter-flags '-march=*' '-mtune=*' '-flto*' '-fuse-ld=*' '-f*inline*'
	strip-unsupported-flags
einfo "PATH=${PATH}"
einfo "CC:  ${CC}"
${CC} --version || die
einfo "LD:  ${LD}"
${LD} --version || die
einfo
einfo "Kernel CFLAGS:"
einfo
einfo "CFLAGS=${CFLAGS}"
einfo "CXXFLAGS=${CXXFLAGS}"
einfo "LDFLAGS=${LDFLAGS}"
einfo

	if [[ -z "${HOSTCFLAGS}" ]] ; then
		HOSTCFLAGS="${CFLAGS}"
		HOSTLDFLAGS="${LDFLAGS}"
	fi

einfo
einfo "Host programs CFLAGS:"
einfo
einfo "HOSTCFLAGS=${HOSTCFLAGS}"
einfo "HOSTLDFLAGS=${HOSTLDFLAGS}"
einfo
	if tc-is-cross-compiler ; then
		args+=(
			"'HOSTCFLAGS=-O1 -pipe'"
			"'HOSTLDFLAGS=-O1 -pipe'"
		)
	else
		args+=(
			"'HOSTCFLAGS=${HOSTCFLAGS}'"
			"'HOSTLDFLAGS=${HOSTLDFLAGS}'"
		)
	fi

	if has tresor ${IUSE_EFFECTIVE} && ot-kernel_use tresor && tc-is-clang ; then
		args+=(
			"LLVM_IAS=0"
		)
	fi

	local march_flags=($(echo "${CFLAGS}" \
		| grep -E -e "(-march=[^[:space:]]+|-mcpu=[^[:space:]]+)"))
	for x in ${march_flags[@]} ; do
		if ! test-flags "${x}" >/dev/null 2>&1 ; then
			# This test is for kernel_compiler_patch.
eerror
eerror "Failed compiler flag test for ${x}."
eerror
eerror "You need to make sure the compiler for that any slot install does"
eerror "support the failed compiler flag."
eerror
			die
		else
einfo "Passed check for ${x}"
		fi
	done
}

# @FUNCTION: ot-kernel_build_tresor_sysfs
# @DESCRIPTION:
# Builds the tresor_sysfs program.
ot-kernel_build_tresor_sysfs() {
	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if ot-kernel_use tresor_sysfs ; then
einfo "Running:  $(tc-getCC) ${CFLAGS} -Wno-unused-result tresor_sysfs.c -o \
tresor_sysfs"
			$(tc-getCC) ${CFLAGS} -Wno-unused-result \
				tresor_sysfs.c -o tresor_sysfs || die
			chmod 0700 tresor_sysfs || die
		fi
	fi
}

# @FUNCTION: ot-kernel_has_efi_prereqs
# @DESCRIPTION:
# Checks if user wants EFI boot indirectly.
ot-kernel_has_efi_prereqs() {
	if ot-kernel_has_version "app-crypt/pesign" \
		&& ot-kernel_has_version "dev-libs/openssl" \
		&& ot-kernel_has_version "dev-libs/nss[utils]" \
		&& ot-kernel_has_version "sys-boot/mokutil" ; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_uefi_prereqs
# @DESCRIPTION:
# Checks if user wants UEFI secure boot indirectly.
ot-kernel_has_uefi_prereqs() {
	if ot-kernel_has_version "app-crypt/efitools" \
		&& ot-kernel_has_version "app-crypt/sbsigntools" \
		&& ot-kernel_has_version "dev-libs/openssl" \
		; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_uefi_sign_and_install
# @DESCRIPTION:
# Sign the kernel for UEFI systems
ot-kernel_uefi_sign_and_install() {
	# Both db.key and db.crt must be generated before emerging and kernel signing.
	local dbkey="${OT_KERNEL_UEFI_DBKEY}" # folder containing db.key
	local dbcrt="${OT_KERNEL_UEFI_DBCERT}" # folder containing db.crt
	local skpath="${1}"
	local dkpath="${2}"
einfo "Signing kernel"
	sbsign --cert "${dbcert}" \
		--key "${dbkey}" \
		-o "${dkpath}.t" \
		"${skpath}" || die
	mv "${dkpath}.t" "${dkpath}" || die
}

# @FUNCTION: ot-kernel_efi_sign_and_install
# @DESCRIPTION:
# Signs the kernel for EFI systems
ot-kernel_efi_sign_and_install() {
	local skpath="${1}"
	local dkpath="${1}.efi"
	local signed_attrs="${1}.sattrs"
	local signed_attrs_sig="${1}.sattrs.sig"
	local certdb_path="${BUILD_DIR}/certs/certdb" # just the root folder
	local certs_path="${BUILD_DIR}/certs" # just the root folder
	ot-kernel_has_version "app-crypt/pesign" || die "You must emerge app-crypt/pesign"
	ot-kernel_has_version "dev-libs/openssl" || die "You mst emerge dev-libs/openssl"
	ot-kernel_has_version "dev-libs/nss[utils]" || die "You must emerge dev-libs/nss[utils]"
	[[ -e "${OT_KERNEL_PUBLIC_KEY}" ]] || die "Missing public key"
	[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing private key"
einfo "Sign prepare:"
	mkdir -p "${certdb_path}" || die
	# Populate certdb using public key \
	certutil \
		-d "${certdb_path}" \
		-A \
			-i "${certs_path}/signing_key.x509" \
			-n cert \
			-t CT,CT,CT || die
	# Extract signed attribs from kernel \
	pesign -n "${certdb_path}" -i "${skpath}" -E "${signed_attr}" || die
	openssl dgst -sha256 \
		-sign "${OT_KERNEL_PRIVATE_KEY}" \
		"${signed_attrs}" \
		> "${signed_attrs_sig}" || die
einfo "Signing kernel:"
	pesign -n "${certdb_path}" \
		-c cert \
		-i "${skpath}" \
		-I "${signed_attrs}" \
		-R "${signed_attrs_sig}" \
		-o "${dkpath}" || die
einfo "Signatures:"
	pesign -S \
		-i "${dkpath}" || die
}

# @FUNCTION: ot-kernel_kexec_sign_and_install
# @DESCRIPTION:
# Signs the kernel for kexec
ot-kernel_kexec_sign_and_install() {
	local skpath="${1}"
	local dkpath="${1}.signed"
	"${BUILD_DIR}/sign-file" \
		\
		"${OT_KERNEL_PRIVATE_KEY}" \
		"${OT_KERNEL_PUBLIC_KEY}" \
		"${kimage_spath}.signed"
}

# @FUNCTION: ot-kernel_install_built_kernel
# @DESCRIPTION:
# Installs the built kernel, and a replacement of the upstream's
# arch/*/install.sh installer.  It works the same as make install.
# It doesn't do kernel sources install.
ot-kernel_install_built_kernel() {
	dodir "${kernel_dir}"
	[[ -z "${kernel_dir}" ]] && die "OT_KERNEL_KERNEL_DIR cannot be empty"

	local arch_=$(ot-kernel_get_my_arch "${arch}")
	local zimage_paths=(
		$(find "${BUILD_DIR}/arch/${arch_}${kernel_dir}" \
			"${BUILD_DIR}" \
			-maxdepth 1 \
			-name "Image.gz" \
			-o -name "bzImage" \
			-o -name "zImage" \
			-o -name "vmlinuz" \
			-o -name "vmlinux.gz" \
			-o -name "vmlinux.bz2" )
	)
	local image_paths=(
		$(find "${BUILD_DIR}/arch/${arch_}${kernel_dir}" \
			"${BUILD_DIR}" \
			-maxdepth 1 \
			-name "Image" \
			-o -name "vmImage" \
			-o -name "vmlinux" \
			-o -name "Image" \
			-o -name "uImage")
	)

	if [[ "${arch}" == "nios2" ]] ; then
		zimage_paths=(${image_paths[@]})
	fi

	insinto "${kernel_dir}"
	local system_map_spath="${BUILD_DIR}/System.map"
	local system_map_dpath="System.map-${UPSTREAM_PV}-${extraversion}-${arch}"
	newins "${system_map_spath}" "${system_map_dpath}"

	local kimage_spath
	local kimage_dpath
	local name
	for f in ${zimage_paths[@]} ; do
		if [[ -e "${f}" ]] ; then
			kimage_spath="${f}"
			name="vmlinuz"
			image_paths=()
			break
		fi
	done
	for f in ${image_paths[@]} ; do
		if [[ -e "${f}" ]] ; then
			kimage_spath="${f}"
			name="vmlinux"
			break
		fi
	done

	# FIXME:  Complete signing kernel
	local kimage_dpath="${name}-${UPSTREAM_PV}-${extraversion}-${arch}"
	if true ; then
einfo "Installing unsigned kernel"
		newins "${kimage_spath}" "${kimage_dpath}"
	elif [[ "${OT_KERNEL_SIGN_KERNEL}" =~ "uefi" && -n "${OT_KERNEL_PRIVATE_KEY}" && -n "${OT_KERNEL_PUBLIC_KEY}" && -n "${OT_KERNEL_EFI_PARTITION}" ]] \
		&& ot-kernel_has_uefi_prereqs \
		&& grep -q -e "^CONFIG_EFI_STUB=y" "${BUILD_DIR}/.config" ; then
		[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing private key"
		[[ -e "${OT_KERNEL_PUBLIC_KEY}" ]] || die "Missing public key"
einfo "Signing and installing kernel for UEFI"
		ot-kernel_uefi_sign_and_install
	elif [[ "${OT_KERNEL_SIGN_KERNEL}" =~ "efi" && -n "${OT_KERNEL_PRIVATE_KEY}" && -n "${OT_KERNEL_PUBLIC_KEY}" ]] \
		&& ot-kernel_has_efi_prereqs \
		&& grep -q -e "^CONFIG_EFI_STUB=y" "${BUILD_DIR}/.config" ; then
		[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing private key"
		[[ -e "${OT_KERNEL_PUBLIC_KEY}" ]] || die "Missing public key"
einfo "Signing and installing kernel for EFI"
		ot-kernel_efi_sign_and_install
	elif [[ "${OT_KERNEL_SIGN_KERNEL}" =~ "kexec" && -n "${OT_KERNEL_PRIVATE_KEY}" && -n "${OT_KERNEL_PUBLIC_KEY}" ]] ; then
		[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing private key"
		[[ -e "${OT_KERNEL_PUBLIC_KEY}" ]] || die "Missing public key"
einfo "Signing and installing kernel for kexec"
		ot-kernel_kexec_sign_and_install
	else
einfo "Installing unsigned kernel"
		newins "${kimage_spath}" "${kimage_dpath}"
	fi
	export IFS=$'\n'
	cd "${ED}" || die
	local f
	for f in $(find boot -type f) ; do
		(
			if file "${f}" | grep -q -E -e 'Linux kernel.*executable' ; then
				fperms -x "/${f}"
			fi
		) &
		local njobs=$(jobs -r -p | wc -l)
		[[ ${njobs} -ge ${nprocs} ]] && wait -n
	done
	wait
	export IFS=$' \t\n'
}

# @FUNCTION: ot-kernel_install_source_code
# @DESCRIPTION:
# Installs the kernel source code.  Installing the source code implies
# installing the copyright notices.
ot-kernel_install_source_code() {
einfo "Installing the kernel sources"
	if [[ "${OT_KERNEL_FAST_SOURCE_CODE_INSTALL:-0}" == "1" ]] ; then
		cp -a "${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}/.config" "${T}"
		rm -rf "${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}"
		dodir /usr/src
		mv "${BUILD_DIR}" "${ED}/usr/src" || die
		cp -a "${T}/.config" "${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}/.config"
	else
		insinto /usr/src
		doins -r "${BUILD_DIR}" # Sanitize file permissions

		local nprocs=$(ot-kernel_get_nprocs)
einfo
einfo "nprocs:  ${nprocs}"
einfo "Restoring +x bit"
einfo
		cd "${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}" || die
		export IFS=$'\n'
		local f
		for f in $(find . -type f) ; do
			(
				if file "${f}" | grep -q -F -e 'executable' ; then
					fperms 0755 "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/${f#./}"
				fi
			) &
			local njobs=$(jobs -r -p | wc -l)
			[[ ${njobs} -ge ${nprocs} ]] && wait -n
		done
		wait
		export IFS=$' \t\n'
	fi
}

# @FUNCTION: ot-kernel_get_boot_decompressor
# @DESCRIPTION:
# Reports the boot decompressor used for kernel image
ot-kernel_get_boot_decompressor() {
	local decompressors=(
		BZIP2
		GZIP
		LZ4
		LZMA
		LZ4
		LZO
		XZ
		ZSTD
	)
	local BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
	local d
	for d in ${decompressors[@]} ; do
		if grep -q -E -e "^CONFIG_KERNEL_${d}=y" "${BUILD_DIR}/.config" 2>/dev/null ; then
			echo -n "${d}"
			return
		fi
	done
	echo -n ""
}

# @FUNCTION: ot-kernel_build_kernel
# @DESCRIPTION:
# Compiles the kernel
ot-kernel_build_kernel() {
	if ot-kernel_is_build ; then
		[[ "${BUILD_DIR}/.config" ]] || die "Missing .config to build the kernel"
		local llvm_slot=$(get_llvm_slot)
		local pgo_phase # pgophase file
		local makefile_pgo_phase
		if has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && ot-kernel_use pgo ; then
			local pgo_compiler_fingerprint_file="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/compiler_fingerprint"
			local pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/pgophase"
			local profraw_dpath="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/vmlinux.profraw"
			local profdata_dpath="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/vmlinux.profdata"
			local pgo_phase="${PGO_PHASE_UNK}"
			(( ${llvm_slot} < 13 )) && die "PGO requires LLVM >= 13"
			if [[ -n "${FORCE_PGO_PHASE}" ]] ; then
				pgo_phase="${FORCE_PGO_PHASE}"
			elif [[ ! -e "${pgo_phase_statefile}" ]] ; then
				pgo_phase="${PGO_PHASE_PGI}"
			else
				pgo_phase=$(cat "${pgo_phase_statefile}")
			fi
			# Convert deprecated
			[[ "${pgo_phase}" == "PDI" ]] && pgo_phase="PGI"
			[[ "${pgo_phase}" == "PDT" ]] && pgo_phase="PGT"
			[[ "${pgo_phase}" == "PDO" ]] && pgo_phase="PGO"
			[[ "${pgo_phase}" == "PD0" ]] && pgo_phase="PG0"

			if [[ "${pgo_phase}" == "${PGO_PHASE_PGI}" ]] ; then
einfo "Building PGI"
			elif [[ "${pgo_phase}" == "${PGO_PHASE_PGT}" && -e "${profraw_dpath}" ]] ; then
einfo "Merging PGT profiles"
einfo "DEBUG:  clang-major-version=$(clang-major-version)"
				PATH="/usr/lib/llvm/$(clang-major-version)/bin:${PATH}" \
				which llvm-profdata >/dev/null 2>&1 || die "Cannot find llvm-profdata"
				local actual_profraw_ver=$(od -An -j 8 -N 1 -t d1 "${profraw_dpath}" | grep -E -o -e "[0-9]+")
				local expected_profraw_ver=$(grep -r -e "INSTR_PROF_RAW_VERSION" "/usr/lib/llvm/${llvm_slot}/include/llvm/ProfileData/InstrProfData.inc" \
					| head -n 1 | cut -f 3 -d " ")
				[[ -z "${expected_profraw_ver}" ]] && die "Missing INSTR_PROF_RAW_VERSION"
				if (( ${actual_profraw_ver} != ${expected_profraw_ver} )) ; then
eerror
eerror "Detected a profraw version inconsistency.  Please remove the"
eerror "${OT_KERNEL_PGO_DATA_DIR} folder and restart the PGO process again."
eerror "Make sure that the CHOST/CTARGETs are using the same LLVM version"
eerror "as the builder machine (CBUILD)."
eerror
eerror "Actual profraw version:  ${actual_profraw_ver}"
eerror "Expected profraw version:  ${expected_profraw_ver}"
eerror
					die
				fi
				PATH="/usr/lib/llvm/$(clang-major-version)/bin" \
				llvm-profdata merge --output="${profdata_dpath}" \
					"${profraw_dpath}" || die "PGO profile merging failed"
				pgo_phase="${PGO_PHASE_PGO}"
				echo "${pgo_phase}" > "${pgo_phase_statefile}" || die
				_ot-kernel_disable_clang_pgi
einfo "Building PGO"
				args+=(
					"KCFLAGS=-fprofile-use=${profdata_dpath}"
				)
			elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGO}"|"${PGO_PHASE_DONE}") && -e "${profdata_dpath}" ]] ; then
				_ot-kernel_disable_clang_pgi
# For resuming or rebuilding as PGO phase
einfo "Building PGO"
				args+=(
					"KCFLAGS=-fprofile-use=${profdata_dpath}"
				)
			elif [[ "${pgo_phase}" == "${PGO_PHASE_PGT}" && ! -e "${profraw_dpath}" ]] ; then
einfo "Resuming as PGI since no profile generated"
				echo "${PGO_PHASE_PGI}" > "${pgo_phase_statefile}" || die
				ot-kernel_set_kconfig_pgo
			fi
		elif \
			( \
				( has clang ${IUSE_EFFECTIVE} && ! ot-kernel_use clang ) \
				|| \
				( ! has clang ${IUSE_EFFECTIVE} ) \
			) \
			&& \
			( \
				   ot-kernel_use pgo \
			) \
		; then
			local pgo_compiler_fingerprint_file="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc/compiler_fingerprint"
			local pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc/pgophase"
			local pgo_profile_dir="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc"
			local pgo_phase="${PGO_PHASE_UNK}"
			if [[ -n "${FORCE_PGO_PHASE}" ]] ; then
				pgo_phase="${FORCE_PGO_PHASE}"
			elif [[ ! -e "${pgo_phase_statefile}" ]] && ot-kernel_use pgo ; then
				pgo_phase="${PGO_PHASE_PGI}"
			else
				pgo_phase=$(cat "${pgo_phase_statefile}")
			fi
			# Convert deprecated
			[[ "${pgo_phase}" == "PDI" ]] && pgo_phase="PGI"
			[[ "${pgo_phase}" == "PDT" ]] && pgo_phase="PGT"
			[[ "${pgo_phase}" == "PDO" ]] && pgo_phase="PGO"
			[[ "${pgo_phase}" == "PD0" ]] && pgo_phase="PG0"

			if [[ -z "${OT_KERNEL_PGO_FLAVOR}" ]] ; then
eerror
eerror "OT_KERNEL_PGO_FLAVOR needs to be defined as either GCC_PDO, GCC_PGO,"
eerror "GCC_PGO_CFG for GCC PGO support."
eerror
				die
			fi

			if tc-is-cross-compiler ; then
# libbfd.a is always native ${CHOST}.
eerror
eerror "GCC PGO builds does not support cross-compile."
eerror
				die
			fi

einfo "GCC PATH:  "$(which ${CHOST}-gcc-${gcc_slot})

			local n_gcda=$(find "${pgo_profile_dir}" -name "*.gcda" 2>/dev/null | wc -l)
			[[ -z "${n_gcda}" ]] && n_gcda=0
			if [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGI}") ]] ; then
				if [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PDO" ]] ; then
					makefile_pgo_phase="GCC_PDI"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" ]] ; then
					makefile_pgo_phase="GCC_PGI"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO_CFG" ]] ; then
					makefile_pgo_phase="GCC_PGI_CFG"
				fi
einfo "Building ${pgo_phase}"
				local gcc_slot=$(gcc-major-version)
				local current_abi="LIBDIR_${DEFAULT_ABI}"
				local binutils_pv=$(best_version sys-devel/binutils \
					| sed -e "s|sys-devel/binutils-||g")
				binutils_pv=$(ver_cut 1-2 "${binutils_pv}")
				if [[ -n "${GCC_GCOV_DIR}" ]] ; then
					args+=(
						"GCC_GCOV_DIR=${GCC_GCOV_DIR}"
						"GCC_PGO_PHASE=${makefile_pgo_phase}"
						"GCC_PLUGINS_INCLUDE=${GCC_PLUGINS_INCLUDE}"
						"KBUILD_MODPOST_WARN=1"
						"LIBBFD_DIR=${LIBBFD_DIR}"
						"LIBC_DIR=${LIBC_DIR}"
					)
				elif [[ "${arch}" == "x86_64" ]] ; then
					args+=(
						"GCC_GCOV_DIR=${ESYSROOT}/usr/lib/gcc/${CHOST_amd64}/${gcc_slot}"
						"GCC_PGO_PHASE=${makefile_pgo_phase}"
						"GCC_PLUGINS_INCLUDE=${ESYSROOT}/usr/lib/gcc/${CHOST_amd64}/${gcc_slot}/plugin/include"
						"KBUILD_MODPOST_WARN=1"
						"LIBBFD_DIR=${ESYSROOT}/usr/${!current_abi}/binutils/${CHOST_amd64}/${binutils_pv}"
						"LIBC_DIR=${ESYSROOT}/usr/${LIBDIR_amd64}"
					)
				else
eerror
eerror "Unknown arch:  ${arch}"
eerror
eerror "You must define GCC_GCOV_DIR to the absolute path containing libgcov.a."
eerror "You must define GCC_PLUGINS_INCLUDE to the absolute path containing coretypes.h, tsystem.h."
eerror "You must define LIBBFD_DIR to the absolute path containing libbfd.a."
eerror "You must define LIBC_DIR to the absolute path containing libc.a."
eerror
eerror "Only native GCC PGO builds are supported."
eerror
					die
				fi
			elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGT}") ]] && (( ${n_gcda} > 0 )) ; then
				pgo_phase="PGO"
				if [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PDO" ]] ; then
					makefile_pgo_phase="GCC_PDO"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" ]] ; then
					makefile_pgo_phase="GCC_PGO"

# FIXME?:  This may trigger a sandbox violation.  This is why we dump the profile in pkg_setup() outside the sandbox.
					if ! use "kpgo-utils" ; then
eerror
eerror "The kpgo-utils USE flag must be enabled in order to complete the"
eerror "PGO profile."
eerror
eerror "Alternatively, you may switch to another PGO method and start at the"
eerror "beginning or disable PGO."
eerror
					fi
					cp -a "/usr/$(get_libdir)/kpgo-utils" "${WORKDIR}" || die
					pushd "${WORKDIR}/kpgo-utils" >/dev/null 2>&1 || die
einfo "Gathering initial PGO profile"
						./gather.sh profile.tar.gz || die
einfo "Generating counter summary and histogram and adding to the PGO profile"
						./process.sh profile.tar.gz || die
					popd >/dev/null 2>&1 || die
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO_CFG" ]] ; then
					makefile_pgo_phase="GCC_PGO_CFG"
				fi
				echo "${pgo_phase}" > "${pgo_phase_statefile}" || die
einfo "Building ${pgo_phase}"
				args+=(
					"GCC_PGO_PHASE=${makefile_pgo_phase}"
					"GCC_PGO_PROFILE_DIR=${pgo_profile_dir}"
				)
			elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGO}"|"${PGO_PHASE_DONE}") && -e "${profdata_dpath}" ]] ; then
				if [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PDO" && "${PGO_PHASE_PGO}" == "PGO" ]] ; then
					makefile_pgo_phase="GCC_PDO"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" && "${PGO_PHASE_PGO}" == "PGO" ]] ; then
					makefile_pgo_phase="GCC_PGO"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO_CFG" && "${PGO_PHASE_PGO}" == "PGO" ]] ; then
					makefile_pgo_phase="GCC_PGO_CFG"

				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PDO" && "${PGO_PHASE_PGO}" == "DONE" ]] ; then
					makefile_pgo_phase="GCC_PDO"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" && "${PGO_PHASE_PGO}" == "DONE" ]] ; then
					makefile_pgo_phase="GCC_PGO"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO_CFG" && "${PGO_PHASE_PGO}" == "DONE" ]] ; then
					makefile_pgo_phase="GCC_PGO_CFG"
				fi
# For resuming or rebuilding as PDO phase
einfo "Building ${pgo_phase}"
				args+=(
					"GCC_PGO_PHASE=${makefile_pgo_phase}"
					"GCC_PGO_PROFILE_DIR=${pgo_profile_dir}"
				)
			elif [[ "${pgo_phase}" =~ ("${PGO_PHASE_PGT}") ]] && (( ${n_gcda} == 0 )) ; then
				if [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PDO" ]] ; then
					makefile_pgo_phase="GCC_PDI"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO" ]] ; then
					makefile_pgo_phase="GCC_PGI"
				elif [[ "${OT_KERNEL_PGO_FLAVOR}" == "GCC_PGO_CFG" ]] ; then
					makefile_pgo_phase="GCC_PGI_CFG"
				fi
				echo "${PGO_PHASE_PGI}" > "${pgo_phase_statefile}" || die
				ot-kernel_set_kconfig_pgo

einfo "Resuming as ${makefile_pgo_phase} since no profile generated"
				local gcc_slot=$(gcc-major-version)
				local current_abi="LIBDIR_${DEFAULT_ABI}"
				local binutils_pv=$(best_version sys-devel/binutils \
					| sed -e "s|sys-devel/binutils-||g")
				binutils_pv=$(ver_cut 1-2 "${binutils_pv}")
				if [[ -n "${GCC_GCOV_DIR}" ]] ; then
					args+=(
						"GCC_GCOV_DIR=${GCC_GCOV_DIR}"
						"GCC_PGO_PHASE=${makefile_pgo_phase}"
						"GCC_PLUGINS_INCLUDE=${GCC_PLUGINS_INCLUDE}"
						"KBUILD_MODPOST_WARN=1"
						"LIBBFD_DIR=${LIBBFD_DIR}"
						"LIBC_DIR=${LIBC_DIR}"
					)
				elif [[ "${arch}" == "x86_64" ]] ; then
					args+=(
						"GCC_GCOV_DIR=${ESYSROOT}/usr/lib/gcc/${CHOST_amd64}/${gcc_slot}"
						"GCC_PGO_PHASE=${makefile_pgo_phase}"
						"GCC_PLUGINS_INCLUDE=${ESYSROOT}/usr/lib/gcc/${CHOST_amd64}/${gcc_slot}/plugin/include"
						"KBUILD_MODPOST_WARN=1"
						"LIBBFD_DIR=${ESYSROOT}/usr/${!current_abi}/binutils/${CHOST_amd64}/${binutils_pv}"
						"LIBC_DIR=${ESYSROOT}/usr/${LIBDIR_amd64}"
					)
				else
eerror
eerror "Unknown arch:  ${arch}"
eerror
eerror "You must define GCC_GCOV_DIR to the absolute path containing libgcov.a."
eerror "You must define GCC_PLUGINS_INCLUDE to the absolute path containing coretypes.h, tsystem.h."
eerror "You must define LIBBFD_DIR to the absolute path containing libbfd.a."
eerror "You must define LIBC_DIR to the absolute path containing libc.a."
eerror
eerror "Only native GCC PGO builds are supported."
eerror
					die
				fi
			fi

		fi

einfo "Running:  make all ${args[@]}"
		dodir "${kernel_dir}"
		make all "${args[@]}" || die
	fi
}

# @FUNCTION: ot-kernel_src_compile
# @DESCRIPTION:
# Compiles the userland programs and the kernel
ot-kernel_src_compile() {
	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		local build_flag="${OT_KERNEL_BUILD}" # Can be 0, 1, true, false, yes, no, nobuild, build, unset
		local config="${OT_KERNEL_CONFIG}"
		local arch="${OT_KERNEL_ARCH}" # ARCH in raw form.
		local default_config="/etc/kernels/kernel-config-${KV_MAJOR_MINOR}-${extraversion}-${arch}"
		[[ -z "${config}" ]] && config="${default_config}"
		local target_triple="${OT_KERNEL_TARGET_TRIPLE}"
		local cpu_sched="${OT_KERNEL_CPU_SCHED}"
		local boot_decomp=$(ot-kernel_get_boot_decompressor)
		local kernel_dir="${OT_KERNEL_KERNEL_DIR:-/boot}"
		[[ "${target_triple}" == "CHOST" ]] && target_triple="${CHOST}"
		[[ "${target_triple}" == "CBUILD" ]] && target_triple="${CBUILD}"
		[[ -z "${cpu_sched}" ]] && cpu_sched="cfs"
		ot-kernel_use rt && cpu_sched="cfs"
		[[ -z "${target_triple}" ]] && target_triple="${CHOST}"
		if [[ -z "${build_config}" ]] ; then
			if ot-kernel_is_build ; then
				build_config="1"
			else
				build_config="0"
			fi
		fi
		[[ -z "${extraversion}" ]] && die "extraversion cannot be empty"
		[[ -z "${build_flag}" ]] && die "build_flag cannot be empty"
		[[ -z "${config}" ]] && die "config cannot be empty"
		[[ -z "${arch}" ]] && die "arch cannot be empty"
		[[ -z "${target_triple}" ]] && die "target_triple cannot be empty"
		[[ -z "${cpu_sched}" ]] && die "cpu_sched cannot be empty"

		local path_config="${BUILD_DIR}/.config"
		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		cd "${BUILD_DIR}" || die

		# Summary for this compile
einfo
einfo "Compiling with the following:"
einfo
einfo "ARCH:  ${arch}"
einfo "Boot decompressor:  ${boot_decomp}"
einfo "Build flag:  ${build_flag}"
einfo "Config:  ${path_config}"
einfo "EXTRAVERSION:  ${extraversion}"
einfo "Target triple:  ${target_triple}"
einfo

		local args=()
		if [[ -n "${OT_KERNEL_VERBOSITY}" ]] ; then
			# 0=minimal, 1=compiler flags, 2=rebuild reasons
			args+=(
				"V=${OT_KERNEL_VERBOSITY}"
			)
		fi
		ot-kernel_setup_tc
		local gcc_slot=$(get_gcc_slot)
		ot-kernel_build_tresor_sysfs
		ot-kernel_build_kernel
	done
}



# @FUNCTION: ot-kernel_keep_keys
# @DESCRIPTION:
# Saves keys for external modules
ot-kernel_keep_keys() {
	local d="${T}/keys/${extraversion}-${arch}/certs"
	mkdir -p "${d}" || die
	local files=(
		certs/signing_key.pem		# private key
		certs/signing_key.x509		# public key
		certs/x509.genkey		# key geneneration config file
	)
	cp -a ${files[@]} \
		"${d}" || die
einfo "Wiping keys securely"
	shred -f ${files[@]} || die
	sync
}

# @FUNCTION: ot-kernel_restore_keys
# @DESCRIPTION:
# Restores keys in the certs folder
ot-kernel_restore_keys() {
	local s="${T}/keys/${extraversion}-${arch}/certs"
	local files=(
		"${s}/signing_key.pem"		# private key
		"${s}/signing_key.x509"		# public key
		"${s}/x509.genkey"		# key geneneration config file
	)
	local d="${}"
	cp -a ${files[@]} \
		"${BUILD_DIR}/certs" || die
	chmod 0600 "${BUILD_DIR}/certs/signing_key.pem" || die
einfo "Wiping keys securely"
	shred -f ${files[@]} || die
	sync
}

# @FUNCTION: ot-kernel_gen_iosched_config
# @DESCRIPTION:
# Generates an init script config for iosched
OT_KERNEL_IOSCHED_CONFIG_INSTALL=0
ot-kernel_gen_iosched_config() {
	[[ \
		   "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" \
		|| "${OT_KERNEL_IOSCHED_SYSTEMD:-1}" == "1" \
	]] \
	|| return
	OT_KERNEL_IOSCHED_CONFIG_INSTALL=1
	if [[ "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" ]] \
		&& ot-kernel_has_version "sys-apps/openrc" \
		&& ! ot-kernel_has_version "sys-apps/openrc[bash]" ; then
eerror
eerror "Re-emerge sys-apps/openrc[bash]"
eerror
eerror "You may set OT_KERNEL_IOSCHED_OPENRC=0 to disable this requirement/feature."
eerror
		die
	fi
	mkdir -p "${T}/etc/ot-sources/iosched/conf"

	local salt=$(dd if=/dev/random bs=40 count=1 2>/dev/null | sha256sum | cut -f 1 -d " ")

################################################################################
	cat <<EOF > "${T}/etc/ot-sources/iosched/conf/${UPSTREAM_PV}-${extraversion}-${arch}" || die
# See metadata.xml (or epkginfo -x ${PN}::oiledmachine-overlay) for details
IOSCHED_OVERRIDES="${OT_KERNEL_IOSCHED_OVERRIDE}"

# Produced from:
# SALT="..." ; t="ata-XXX_XXXXXXXX-XXXXXXX_XX-XXXXXXXXXXXX;\${SALT}" ; echo "\${t}" | sha256sum | cut -f 1 -d " "
# sha256sum, sha384sum, sha512sum supported
# "echo \${t}" and "echo -n \${t}" supported
IOSCHED_ANON_OVERRIDES=""

# Changing this means to redo all anon ids in IOSCHED_ANON_OVERRIDES so don't
# change it if already set.  This value prevents from brute force dictionary
# lookup.
SALT="${salt}"

IOSCHED_HDD="${hdd_iosched}" # Do not change
IOSCHED_SSD="${ssd_iosched}" # Do not change

HW_RAID="${OT_KERNEL_HWRAID:-0}"
EOF
################################################################################
}

# @FUNCTION: ot-kernel_get_nprocs
# @INTERNAL
# @DESCRIPTION:
# Gets the number N from -jN defined by MAKEOPTS.
ot-kernel_get_nprocs() {
	local nprocs=$(echo "${MAKEOPTS}" \
		| grep -E -e "-j[ ]*[0-9]+" \
		| grep -E -o -e "[0-9]+")
	[[ -z "${nprocs}" ]] && nprocs=1
	echo "${nprocs}"
}

# @FUNCTION: ot-kernel_get_my_arch
# @INTERNAL
# @DESCRIPTION:
# Gets the /usr/src/linux/arch folder name from OT_KERNEL_ARCH in raw form.
ot-kernel_get_my_arch() {
	local arch="${1}"
	case "${arch}" in
		parisc64)
			echo "parisc" ;;
		sparc32|sparc64)
			echo "sparc" ;;
		x86_64|i386)
			echo "x86" ;;
		sh64)
			echo "sh" ;;
		tilepro|tilegx)
			echo "tile" ;;
		*)
			echo "${arch}" ;;
	esac
}

# @FUNCTION: ot-kernel_prune_arches
# @DESCRIPTION:
# Deletes source code for other arches in the arch folder from ${BUILD_DIR}.
ot-kernel_prune_arches() {
	local is_final="${1}"
	local my_arch=$(ot-kernel_get_my_arch "${OT_KERNEL_ARCH}")
	local all_arches=($(ls arch \
		| sed -e "/Kconfig/d"))
	local arch
	for arch in ${all_arches[@]} ; do
		[[ "${arch}" =~ "${my_arch}" ]] && continue
einfo "Pruning ${arch} from ${extraversion}"
		rm -rf "arch/${arch}"
	done
	if ! [[ -e "arch/${my_arch}" ]] ; then
eerror "arch/${my_arch} is not supported"
		die
	fi
}

# @FUNCTION: ot-kernel_is_full_sources_required
# @DESCRIPTION:
# Check if sources required.  This is because of possible varations.
ot-kernel_is_full_sources_required() {
	if [[ "${OT_KERNEL_EXTERNAL_MODULES}" == "1" ]] ; then
		return 0
	elif [[ "${OT_KERNEL_INSTALL_SOURCE_CODE:-1}" =~ ("1"|"y") ]] ; then
		return 0
	elif ot-kernel-pkgflags_has_external_module ; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel_add_amdgpu_wrapper
# @DESCRIPTION:
# Add a wrapper for install of vanilla amdgpu kernel driver as a fallback.
ot-kernel_add_amdgpu_wrapper() {
# For multiple slot support.
dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/install-amdgpu-kernel-module-for-${PV}-${extraversion}.sh"
#!/bin/bash
echo "Switching to the vanilla amdgpu kernel module for \${kernel_release}"
kernel_release="${canonical_target}"
modules_path="/lib/modules/\${kernel_release}"

KERNEL_MODULES=(
	"amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
)

# Entries from all versions of the rock-dkms driver and the vanilla amdgpu kernel driver.
_DKMS_MODULES=(
	"amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
	"amdttm /kernel/drivers/gpu/drm/ttm"
	"amdkcl /kernel/drivers/gpu/drm/amd/amdkcl"
	"amd-sched /kernel/drivers/gpu/drm/scheduler"
	"amddrm_ttm_helper /kernel/drivers/gpu/drm"
	"amddrm_buddy /kernel/drivers/gpu/drm"
	"amdxcp /kernel/drivers/gpu/drm/amd/amdxcp"
)

IFS=\$'\n'

for x in \${_DKMS_MODULES[@]} ; do
	built_name=\$(echo "\${x}" | cut -f 1 -d " ")
	dest_location=\$(echo "\${x}" | cut -f 2 -d " ")
	rm -fv "\${modules_path}\${dest_location}/\${built_name}.ko"*
done

for x in \${KERNEL_MODULES[@]} ; do
	built_name=\$(echo "\${x}" | cut -f 1 -d " ")
	dest_location=\$(echo "\${x}" | cut -f 2 -d " ")
	FN=(
		"\${built_name}.ko"
		"\${built_name}.ko.gz"
		"\${built_name}.ko.xz"
		"\${built_name}.ko.zst"
	)
	for fn in \${FN[@]} ; do
		if [[ -e "/lib/modules-amdgpu/\${kernel_release}/\${dest_location}/\${fn}" ]] ; then
			mkdir -p "\${modules_path}\${dest_location}"
			rm -f "\${modules_path}\${dest_location}/\${built_name}.ko"{,.gz,.xz,.zst}
			cp -a "/lib/modules-amdgpu/\${kernel_release}/\${dest_location}/\${fn}" "\${modules_path}\${dest_location}"
		fi
	done
done

IFS=\$' \t\n'

echo "Updating /lib/modules/\${kernel_release}/module.dep for \`modprobe amdgpu\`"
depmod -a \${kernel_release}
EOF
	fperms 0750 "/usr/bin/install-amdgpu-kernel-module-for-${PV}-${extraversion}.sh"
}

# @FUNCTION: ot-kernel_slotify_amdgpu
# @DESCRIPTION:
# Backup the amdgpu modules as a fallback for the rock-dkms ebuild.
ot-kernel_slotify_amdgpu() {
	local KERNEL_MODULES=(
		"amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
	)
	local canonical_target="${UPSTREAM_PV}-${extraversion}-${arch}" # ex. 6.6.0-builder-${arch}
	local x
	IFS=$'\n'
	for x in ${KERNEL_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local dest_location=$(echo "${x}" | cut -f 2 -d " ")
		local FN=(
			"${built_name}.ko"
			"${built_name}.ko.gz"
			"${built_name}.ko.xz"
			"${built_name}.ko.zst"
		)
		local fn
		for fn in ${FN[@]} ; do
			if [[ -e "${ED}/lib/modules/${canonical_target}${dest_location}/${fn}" ]] ; then
				dodir "/lib/modules-amdgpu/${canonical_target}${dest_location}"
				cp -a \
					"${ED}/lib/modules/${canonical_target}${dest_location}/${fn}" \
					"${ED}/lib/modules-amdgpu/${canonical_target}${dest_location}"
			fi
		done
	done
	IFS=$' \t\n'
}


# @FUNCTION: ot-kernel_install_tcca
# @DESCRIPTION:
# Configure and install tcca
ot-kernel_install_tcca() {
	OT_KERNEL_TCP_CONGESTION_CONTROLS=$(_ot-kernel_set_kconfig_get_init_tcp_congestion_controls)
	if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT:-1}" == "1" \
		&& -n "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" ]] ; then
		# Each kernel config may have different a combo.

		local default_tcca=$(ot-kernel_get_tcp_congestion_controls_default)

		_tcc_intra_dc() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_intra_dc=$(_tcc_intra_dc)

		_tcc_inter_dc() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "illinois" ]] ; then
				tcc="illinois"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_inter_dc=$(_tcc_inter_dc)

		_tcc_satellite() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hybla" ]] ; then
				tcc="hybla"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_satellite=$(_tcc_satellite)

		_tcc_wireless() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "veno" ]] ; then
				tcc="veno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_wireless=$(_tcc_wireless)

		_tcc_high_bdp() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "htcp" ]] ; then
				tcc="htcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bic" ]] ; then
				tcc="bic"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_high_bdp=$(_tcc_high_bdp)



		_tcc_hs_fair() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hstcp" ]] ; then
				tcc="hstcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "htcp" ]] ; then
				tcc="htcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "illinois" ]] ; then
				tcc="illinois"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hybla" ]] ; then
				tcc="hybla"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bic" ]] ; then
				tcc="bic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "reno" ]] ; then
				tcc="reno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "yeah" ]] ; then
				tcc="yeah"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "veno" ]] ; then
				tcc="veno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_hs_fair=$(_tcc_hs_fair)

		_tcc_hs_realtime() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_hs_realtime=$(_tcc_hs_realtime)

		_tcc_hs_throughput() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hstcp" ]] ; then
				tcc="hstcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "illinois" ]] ; then
				tcc="illinois"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "htcp" ]] ; then
				tcc="htcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hybla" ]] ; then
				tcc="hybla"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bic" ]] ; then
				tcc="bic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "reno" ]] ; then
				tcc="reno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "yeah" ]] ; then
				tcc="yeah"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "veno" ]] ; then
				tcc="veno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_hs_throughput=$(_tcc_hs_throughput)


		# UCDC - ultra cap data center O(100,000) - top 500 supercomputers
		# HCDC - high cap data center O(10,000) - big tech
		# MCDC - mid cap data center O(1,000) - university super computer
		# LCDC - low cap data center O(100) - university HPC/ML/DL

		_tcc_lcdc_fair() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		_tcc_lcdc_realtime() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		_tcc_lcdc_throughput() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}


		_tcc_mcdc_fair() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		_tcc_mcdc_realtime() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		_tcc_mcdc_throughput() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		local tcca_lcdc_fair=$(_tcc_lcdc_fair)
		local tcca_lcdc_realtime=$(_tcc_lcdc_realtime)
		local tcca_lcdc_throughput=$(_tcc_lcdc_throughput)

		local tcca_mcdc_fair=$(_tcc_mcdc_fair)
		local tcca_mcdc_realtime=$(_tcc_mcdc_realtime)
		local tcca_mcdc_throughput=$(_tcc_mcdc_throughput)

		local tcca_hcdc_fair=$(_tcc_mcdc_fair)
		local tcca_hcdc_realtime=$(_tcc_mcdc_realtime)
		local tcca_hcdc_throughput=$(_tcc_mcdc_throughput)

		local tcca_ucdc_fair=$(_tcc_mcdc_fair)
		local tcca_ucdc_realtime=$(_tcc_mcdc_realtime)
		local tcca_ucdc_throughput=$(_tcc_mcdc_throughput)

		_tcc_streaming() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_streaming=$(_tcc_streaming)

		# It should not be loss based.
		_tcc_low_latency() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "c2tcp" ]] ; then
				tcc="c2tcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}

		local tcca_music=$(_tcc_streaming)
		local tcca_podcast=$(_tcc_streaming)
		local tcca_streaming=$(_tcc_streaming)

		local tcca_broadcast=$(_tcc_low_latency)
		local tcca_gaming=$(_tcc_low_latency)
		local tcca_social_games=$(_tcc_low_latency)
		local tcca_video_chat=$(_tcc_low_latency)
		local tcca_voip=$(_tcc_low_latency)

		# sendrate ~ avg throughput based on self clocking.
		# Sorted by completion time, then avg send rate
		_tcc_send_rate() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "pcc" ]] ; then
				tcc="pcc"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hstcp" ]] ; then
				tcc="hstcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "illinois" ]] ; then
				tcc="illinois"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "htcp" ]] ; then
				tcc="htcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hybla" ]] ; then
				tcc="hybla"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bic" ]] ; then
				tcc="bic"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "reno" ]] ; then
				tcc="reno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr3" ]] ; then
				tcc="bbr3"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr2" ]] ; then
				tcc="bbr2"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "yeah" ]] ; then
				tcc="yeah"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "veno" ]] ; then
				tcc="veno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			else
				tcc="${default_tcca}"
			fi
			echo "${tcc}"
		}
		local tcca_ftp=$(_tcc_send_rate)
		local tcca_p2p=$(_tcc_send_rate)
		local tcca_podcast_upload=$(_tcc_send_rate)
		local tcca_torrent=$(_tcc_send_rate)
		local tcca_video_upload=$(_tcc_send_rate)

		_tcc_green() {
			local tcc
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "bbr"( |$) ]] ; then
				tcc="bbr"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "westwood" ]] ; then
				tcc="westwood"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "hstcp" ]] ; then
				tcc="hstcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "scalable" ]] ; then
				tcc="scalable"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "reno" ]] ; then
				tcc="reno"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "vegas" ]] ; then
				tcc="vegas"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "dctcp" ]] ; then
				tcc="dctcp"
			elif [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "cubic" ]] ; then
				tcc="cubic"
			else
				tcc="${default_tcca}"
			fi
		}

		local tcca_green=$(_tcc_green)

		_tcc_bgdl() {
			if [[ "${OT_KERNEL_TCP_CONGESTION_CONTROLS}" =~ "lp" ]] ; then
				tcc="lp"
			else
				tcc="${default_tcca}"
			fi
		}
		local tcca_bgdl=$(_tcc_bgdl)

		tcca_elevate_priv="none" # Same as already root
		if ot-kernel_has_version "sys-auth/polkit" ; then
			tcca_elevate_priv="polkit"
		elif ot-kernel_has_version "app-admin/sudo" ; then
			tcca_elevate_priv="sudo"
		fi

		cat <<EOF > "${T}/tcca.conf" || die
# Client
TCCA_BGDL="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BGDL:-${tcca_bgdl}}"
TCCA_BROADCAST="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_BROADCAST:-${tcca_broadcast}}"
TCCA_FTP="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_FTP:-${tcca_ftp}}"
TCCA_GAMING="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GAMING:-${tcca_gaming}}"
TCCA_GREEN="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_GREEN:-${tcca_green}}"
TCCA_MUSIC="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MUSIC:-${tcca_music}}"
TCCA_P2P="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_P2P:-${tcca_p2p}}"
TCCA_PODCAST="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_PODCAST:-${tcca_podcast}}"
TCCA_PODCAST_UPLOAD="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_PODCAST_UPLOAD:-${tcca_podcast_upload}}"
TCCA_SOCIAL_GAMES="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_SOCIAL_GAMES:-${tcca_social_games}}"
TCCA_STREAMING="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_STREAMING:-${tcca_streaming}}"
TCCA_TORRENT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_TORRENT:-${tcca_torrent}}"
TCCA_VIDEO_CHAT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VIDEO_CHAT:-${tcca_video_chat}}"
TCCA_VIDEO_UPLOAD="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VIDEO_UPLOAD:-${tcca_video_upload}}"
TCCA_VOIP="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_VOIP:-${tcca_voip}}"
TCCA_WWW="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WWW:-${tcca_www}}"

# Home server
TCCA_HS_FAIR="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_FAIR:-${tcca_hs_fair}}"
TCCA_HS_REALTIME="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_REALTIME:-${tcca_hs_realtime}}"
TCCA_HS_THROUGHPUT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HS_THROUGHPUT:-${tcca_hs_throughput}}"

# Intra datacenter refined
TCCA_LCDC_FAIR="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_FAIR:-${tcca_lcdc_fair}}"
TCCA_LCDC_REALTIME="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_REALTIME:-${tcca_lcdc_realtime}}"
TCCA_LCDC_THROUGHPUT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_LCDC_THROUGHPUT:-${tcca_lcdc_throughput}}"
TCCA_MCDC_FAIR="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_FAIR:-${tcca_mcdc_fair}}"
TCCA_MCDC_REALTIME="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_REALTIME:-${tcca_mcdc_realtime}}"
TCCA_MCDC_THROUGHPUT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_MCDC_THROUGHPUT:-${tcca_mcdc_throughput}}"
TCCA_HCDC_FAIR="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_FAIR:-${tcca_hcdc_fair}}"
TCCA_HCDC_REALTIME="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_REALTIME:-${tcca_hcdc_realtime}}"
TCCA_HCDC_THROUGHPUT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HCDC_THROUGHPUT:-${tcca_hcdc_throughput}}"
TCCA_UCDC_FAIR="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_FAIR:-${tcca_ucdc_fair}}"
TCCA_UCDC_REALTIME="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_REALTIME:-${tcca_ucdc_realtime}}"
TCCA_UCDC_THROUGHPUT="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_UCDC_THROUGHPUT:-${tcca_ucdc_throughput}}"

# General
TCCA_HIGH_BDP="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_HIGH_BDP:-${tcca_high_bdp}}"
TCCA_INTER_DC="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INTER_DC:-${tcca_inter_dc}}"
TCCA_INTRA_DC="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INTRA_DC:-${tcca_intra_dc}}"
TCCA_SATELLITE="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_SATELLITE:-${tcca_satellite}}"
TCCA_WIRELESS="${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_WIRELESS:-${tcca_wireless}}"
TCCA_ELEVATE_PRIV="${tcca_elevate_priv}"
EOF
		cat "${FILESDIR}/tcca" > "${T}/tcca" || die
		sed -i -e "s|__EXTRAVERSION__|${extraversion}|" "${T}/tcca" || die
		sed -i -e "s|__PV__|${MY_PV}|" "${T}/tcca" || die
		sed -i -e "s|__ARCH__|${arch}|" "${T}/tcca" || die
		insinto /etc
		newins "${T}/tcca.conf" "tcca-${UPSTREAM_PV}-${extraversion}-${arch}.conf"
		OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INSTALL=1
	fi

	if         has c2tcp ${IUSE_EFFECTIVE} \
		|| has deepcc ${IUSE_EFFECTIVE} \
		|| has orca ${IUSE_EFFECTIVE} ; then
		if         ot-kernel_use c2tcp \
			|| ot-kernel_use deepcc \
			|| ot-kernel_use orca ; then
			if [[ "${C2TCP_MAJOR_VER}" == "2" ]] ; then
				docinto licenses
				dodoc "${EDISTDIR}/copyright.c2tcp.${C2TCP_COMMIT:0:7}"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel_install_iosched_scripts
# @DESCRIPTION:
# Install iosched scripts
ot-kernel_install_iosched_scripts() {
	if [[ \
		   "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" \
		|| "${OT_KERNEL_IOSCHED_SYSTEMD:-1}" == "1" \
	]] ; then
einfo "Installing iosched script settings"
		insinto "/etc/ot-sources/iosched/conf"
		doins "${T}/etc/ot-sources/iosched/conf/${UPSTREAM_PV}-${extraversion}-${arch}"
	fi
}


# @FUNCTION: ot-kernel_fix_modules
# @DESCRIPTION:
# Fix modules folders
ot-kernel_fix_modules() {
	local NC_VERSION=""
	if [[ -n "${RC_PV}" ]] ; then
		NC_VERSION="${KV_MAJOR_MINOR}-${RC_PV}"
	else
		NC_VERSION="${KV_MAJOR_MINOR}"
	fi

	[[ -e "${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}/include/config/kernel.release" ]] || die
	local non_canonical_target1="${NC_VERSION}-${extraversion}-${arch}" # ex. 6.6-builder-${arch}
	local non_canonical_target2="${NC_VERSION}-${extraversion}" # ex. 6.6-builder
	local non_canonical_target3="${UPSTREAM_PV}-${extraversion}" # ex. 6.6.0-builder
	local non_canonical_target4="${MY_PV}-${extraversion}" # ex. 6.6.8-builder
	local non_canonical_target5="${MY_PV}-${arch}" # ex. 6.6.8-${arch}
	local canonical_target="${UPSTREAM_PV}-${extraversion}-${arch}" # ex. 6.6.0-builder-${arch}

	mkdir -p "${ED}/lib/modules/${canonical_target}"
	if [[ -e "${ED}/lib/modules/${non_canonical_target1}" ]] ; then
		cp -a \
			"${ED}/lib/modules/${non_canonical_target1}/"* \
			"${ED}/lib/modules/${canonical_target}" \
			|| die
		rm -rf "${ED}/lib/modules/${non_canonical_target1}" \
			|| true
	fi
	if [[ -e "${ED}/lib/modules/${non_canonical_target2}" ]] ; then
		cp -a \
			"${ED}/lib/modules/${non_canonical_target2}/"* \
			"${ED}/lib/modules/${canonical_target}" \
			|| die
		rm -rf "${ED}/lib/modules/${non_canonical_target2}" \
			|| true
	fi
	if [[ -e "${ED}/lib/modules/${non_canonical_target3}" ]] ; then
		cp -a \
			"${ED}/lib/modules/${non_canonical_target3}/"* \
			"${ED}/lib/modules/${canonical_target}" \
			|| die
		rm -rf "${ED}/lib/modules/${non_canonical_target3}" \
			|| true
	fi
	if [[ -e "${ED}/lib/modules/${non_canonical_target4}" ]] ; then
		cp -a \
			"${ED}/lib/modules/${non_canonical_target4}/"* \
			"${ED}/lib/modules/${canonical_target}" \
			|| die
		rm -rf "${ED}/lib/modules/${non_canonical_target4}" \
			|| true
	fi
	if [[ -e "${ED}/lib/modules/${non_canonical_target5}" ]] ; then
		cp -a \
			"${ED}/lib/modules/${non_canonical_target5}/"* \
			"${ED}/lib/modules/${canonical_target}" \
			|| die
		rm -rf "${ED}/lib/modules/${non_canonical_target5}" \
			|| true
	fi

	rm -rf "${ED}/lib/modules/${canonical_target}/build" \
		|| true
	rm -rf "${ED}/lib/modules/${canonical_target}/source" \
		|| true

	dosym \
		"/usr/src/linux-${UPSTREAM_PV}-${extraversion}" \
		"/lib/modules/${canonical_target}/build"
	dosym \
		"/usr/src/linux-${UPSTREAM_PV}-${extraversion}" \
		"/lib/modules/${canonical_target}/source"
}

# @FUNCTION: ot_kernel_install_logos
# @DESCRIPTION:
# Install logos
ot_kernel_install_logos() {
	cd "${BUILD_DIR}" || die
	local logo_license_path=$(find "drivers/video/logo" \
		-name "logo_custom_*.*.license" \
		2>/dev/null)
	if [[ -n "${logo_license_path}" && -e "${logo_license_path}" ]] ; then
		insinto "/usr/share/${PN}/${MY_PV}-${extraversion}/licenses/logo"
		doins "${logo_license_path}"
		if [[ -n "${OT_KERNEL_LOGO_FOOTNOTES}" ]] ; then
			echo "${OT_KERNEL_LOGO_FOOTNOTES}" > "${T}/logo_footnotes" || die
			doins "${T}/logo_footnotes"
		fi
	fi
}

# @FUNCTION: ot_kernel_fix_kernel_release
# @DESCRIPTION:
# Fixes the kernel.release file
ot_kernel_fix_kernel_release() {
	# kernel.release is used by genkernel.
	# The file generated is missing the arch so replace it with ours.
	# Add for genkernel because mrproper erases it
	mkdir -p "include/config" || die
	echo "${UPSTREAM_PV}-${extraversion}-${arch}" \
		> include/config/kernel.release || die
}

# @FUNCTION: ot-kernel_fix_certs_permissions
# @DESCRIPTION:
# Fix the certs file permissions
ot-kernel_fix_certs_permissions() {
	local cert
	for cert in $(find certs -type f) ; do
		fperms 600 "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/${cert}"
	done
}

# @FUNCTION: ot-kernel_install_genkernel_required
# @DESCRIPTION:
# Install genkernel required files
ot-kernel_install_genkernel_required() {
	if ! [[ "${OT_KERNEL_INSTALL_SOURCE_CODE:-1}" =~ ("1"|"y") ]] ; then
		# No longer building (binary only)
		rm -rf arch/um/scripts/Makefile.rules
	fi

	cd "${BUILD_DIR}" || die

	# Required for genkernel
	insinto "/usr/src/linux-${UPSTREAM_PV}-${extraversion}"
	doins "Makefile" # Also required for linux-info.eclass: getfilevar() VARNAME ${KERNEL_MAKEFILE}
	insinto "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/include/config"
	doins "include/config/kernel.release"

	# Required for building external modules
	insinto "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/certs"
	ls "certs/"*".pem" >/dev/null 2>&1 \
		&& doins "certs/"*".pem"
	ls "certs/"*".x509" >/dev/null 2>&1 \
		&& doins "certs/"*".x509"
	ls "certs/"*".genkey" >/dev/null 2>&1 \
		&& doins "certs/"*".genkey"

	# Add files to pass version and kernel config checks for linux-info.eclass.
	# Required for linux-info.eclass: getfilevar() VARNAME ${KERNEL_MAKEFILE}
	local ed_kernel_path="${ED}/usr/src/linux-${UPSTREAM_PV}-${extraversion}"
	insinto "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/scripts"
	doins scripts/Kbuild.include
	doins scripts/Makefile.extrawarn
	doins scripts/subarch.include
	local path
	for path in $(find arch/* -maxdepth 1 -name "Makefile") ; do
		insinto "/usr/src/linux-${UPSTREAM_PV}-${extraversion}/"$(dirname "${path}")
		doins "${path}"
	done
}

# @FUNCTION: ot_kernel_serialize_pgo_state
# @DESCRIPTION:
# Saves the pgo state
ot_kernel_serialize_pgo_state() {
	local pgo_phase # pgophase file
	if [[ -n "${FORCE_PGO_PHASE}" ]] ; then
		pgo_phase="${FORCE_PGO_PHASE}"
	elif [[ ! -e "${pgo_phase_statefile}" ]] ; then
		pgo_phase="${PGO_PHASE_PGI}"
	else
		pgo_phase=$(cat "${pgo_phase_statefile}")
	fi
	# Convert deprecated
	[[ "${pgo_phase}" == "PDI" ]] && pgo_phase="PGI"
	[[ "${pgo_phase}" == "PDT" ]] && pgo_phase="PGT"
	[[ "${pgo_phase}" == "PDO" ]] && pgo_phase="PGO"
	[[ "${pgo_phase}" == "PD0" ]] && pgo_phase="PG0"
	local pgo_phase_statefile
	if has clang ${IUSE_EFFECTIVE} && ot-kernel_use clang && use pgo ; then
		pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/llvm/pgophase"
	elif use pgo ; then
		pgo_phase_statefile="${WORKDIR}/pgodata/${extraversion}-${arch}/gcc/pgophase"
	fi
	if [[ -n "${pgo_phase_statefile}" ]] ; then
		mkdir -p $(dirname "${pgo_phase_statefile}")
		if [[ "${pgo_phase}" == "${PGO_PHASE_PGI}" ]] ; then
			echo "${PGO_PHASE_PGT}" > "${pgo_phase_statefile}" || die
		elif [[ "${pgo_phase}" == "${PGO_PHASE_PGO}" ]] ; then
			echo "${PGO_PHASE_DONE}" > "${pgo_phase_statefile}" || die
		fi
	fi
}

# @FUNCTION: ot-kernel_strink_install
# @DESCRIPTION:
# Shrink install by pruning
ot-kernel_strink_install() {
	if [[ "${OT_KERNEL_PRUNE_EXTRA_ARCHES}" == "1" ]] \
		&& ! [[ "${OT_KERNEL_INSTALL_SOURCE_CODE:-1}" =~ ("1"|"y") ]] ; then
		# This is allowed if no external modules.

		# Prune all config arches
		# Prune now for a faster source code install or header preservation

		# Preserve build files because they are mostly unconditional includes.
		# Save arch/um/scripts/Makefile.rules for make mrproper.
		cp --parents -a arch/um/scripts/Makefile.rules \
			"${T}/pruned" || die
		ot-kernel_prune_arches
		# Restore arch/um/scripts/Makefile.rules for make mrproper.
		cp -aT "${T}/pruned" \
			"${BUILD_DIR}" || die
		rm -rf $(find arch -name "Kconfig*") # Delete if not using any make *config.
	fi

	if [[ "${OT_KERNEL_PRESERVE_HEADER_NOTICES:-0}" == "1" ]] \
		&& ! [[ "${OT_KERNEL_INSTALL_SOURCE_CODE:-1}" =~ ("1"|"y") ]] ; then
		local last_version=$(best_version "=sys-kernel/${PN}-${KV_MAJOR_MINOR}*" \
			| sed -e "s|sys-kernel/${PN}-||g")
		local license_preserve_path_src="/usr/share/${PN}/${last_version}-${extraversion}/licenses"
		local license_preserve_path_dest="/usr/share/${PN}/${MY_PV}-${extraversion}/licenses"
		dodir "${license_preserve_path_dest}"
		if [[ "${OT_KERNEL_PRESERVE_HEADER_NOTICES_CACHED:-1}" == "1" \
			&& -e "${license_preserve_path_src}" ]] ; then
ewarn "Preserving copyright notices (cached)."
			cp -aT "${license_preserve_path_src}" \
				"${ED}/${license_preserve_path_dest}" || die
		else
ewarn "Preserving copyright notices.  This may take hours."
			cat "${FILESDIR}/header-preserve-kernel" \
				> "${BUILD_DIR}/header-preserve-kernel" || die
			pushd "${BUILD_DIR}" >/dev/null 2>&1 || die
				export MULTI_HEADER_DEST_PATH="${ED}/${license_preserve_path_dest}"
				chmod +x header-preserve-kernel || die
				./header-preserve-kernel || die
			popd >/dev/null 2>&1 || die
		fi
	fi
}

# @FUNCTION: ot-kernel_push_clean
# @DESCRIPTION:
# Save files before wiped by mrproper.
ot-kernel_push_clean() {
	save_paths=(
	# For module checks in linux-mod-r1.eclass.
		"Module.symvers"

	# Save generated headers
		"include/generated"
		"tools/virtio/generated"
		"tools/testing/radix-tree/generated"
		"tools/net/ynl/generated"

	# For app-emulation/virtualbox-modules
		"include/config"
		"include/generated"
		"scripts"
		"scripts/basic/fixdep"
		"scripts/genksyms/genksyms"
		"scripts/mod/modpost"
	)

	local arches=(
		$(ls arch)
	)
	local _arch # arch already defined
	for _arch in "${arches[@]}" ; do
	# Save generated headers, required for app-emulation/virtualbox-modules
		save_paths+=(
			"arch/${_arch}/include/generated"
#			"arch/${_arch}/include/generated/asm/rwonce.h"
		)
	done

	local path
	for path in "${save_paths[@]}" ; do
		[[ -e "${path}" ]] || continue
		if [[ -d "${path}" ]] ; then
			mkdir -p "${cache}/${path}" || true
			cp -aT "${path}" "${cache}/${path}" || true
		elif [[ -f "${path}" || -x "${path}" ]] ; then
			local d=$(dirname "${path}")
			if [[ "${d}" == "." ]] ; then
				cp -a "${path}" "${cache}" || true
			else
				mkdir -p "${cache}/${d}" || true
				cp -a "${path}" "${cache}/${d}" || true
			fi
		fi
	done
}

# @FUNCTION: ot-kernel_pop_clean
# @DESCRIPTION:
# Restore the important files
ot-kernel_pop_clean() {
	cp -aT "${cache}" ./ || true
	rm -rf "${cache}" || true
}

# @FUNCTION: ot-kernel_install_kernel_config
# @DESCRIPTION:
# Install config
ot-kernel_install_kernel_config() {
	local default_config_bn="kernel-config-${KV_MAJOR_MINOR}-${extraversion}-${arch}"
	local default_config_dir="/etc/kernels"
	local default_config="${default_config_dir}/${default_config_bn}"
einfo "Saving the config for ${extraversion} to ${default_config}"
	insinto /etc/kernels
	newins "${BUILD_DIR}/.config" "${default_config_bn}"
	# dosym src_relpath_real dest_abspath_symlink

	# For genkernel
	dosym \
		"${default_config_bn}" \
		"${default_config_dir}/kernel-config-${UPSTREAM_PV}-${extraversion}-${arch}"

	# For linux-info.eclass config checks
	dosym \
		"${default_config_dir}/kernel-config-${UPSTREAM_PV}-${extraversion}-${arch}" \
		"/usr/src/linux-${UPSTREAM_PV}-${extraversion}/.config"
}

# @FUNCTION: ot-kernel_install_pgo_state
# @DESCRIPTION:
# Installs the pgo state data
ot-kernel_install_pgo_state() {
	if use pgo ; then
		insinto "${OT_KERNEL_PGO_DATA_DIR}"
		doins -r "${WORKDIR}/pgodata/"* # Sanitize file permissions
	fi
}

# @FUNCTION: ot-kernel_src_install
# @DESCRIPTION:
# Removes patch cruft.
OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INSTALL=0
ot-kernel_src_install() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export STRIP="/bin/true" # See https://github.com/torvalds/linux/blob/v5.16/init/Kconfig#L2169
	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			docinto /usr/share/${PF}
			dodoc "${EDISTDIR}/${TRESOR_README_FN}"
			dodoc "${EDISTDIR}/${TRESOR_PDF_FN}"
		fi
	fi

	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		local build_flag="${OT_KERNEL_BUILD}" # Can be 0, 1, true, false, yes, no, nobuild, build, unset
		local kernel_dir="${OT_KERNEL_KERNEL_DIR:-/boot}"
		if [[ -z "${build_config}" ]] ; then
			if ot-kernel_is_build ; then
				build_config="1"
			else
				build_config="0"
			fi
		fi
		local arch="${OT_KERNEL_ARCH}" # ARCH in raw form.
		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		cd "${BUILD_DIR}" || die

		if ot-kernel_is_full_sources_required ; then
	# Everything will be installed
			:
		else
			ot-kernel_strink_install
		fi

		if ot-kernel_is_build ; then
			local args=(
				INSTALL_MOD_PATH="${ED}"
				INSTALL_PATH="${ED}${kernel_dir}"
				${MAKEOPTS}
				ARCH="${arch}"
			)

			ot-kernel_install_built_kernel # It works the same as make install.
			cd "${BUILD_DIR}" || die
einfo "Running:  make modules_install ${args[@]}"
			make modules_install "${args[@]}" || die
			if [[ "${arch}" =~ "arm" ]] ; then
				make dtbs_install "${args[@]}" || die
			fi
			if [[ "${OT_KERNEL_SIGN_MODULES}" == "1" && -z "${OT_KERNEL_PRIVATE_KEY}" ]] ; then
				ot-kernel_keep_keys
			fi

			ot-kernel_install_kernel_config

	# The cache is used to save/restore important data required by ebuild system, external modules before cleaning.
			local cache="${T}/save_cache"
			mkdir -p "${cache}" || true

			local save_paths=()

			ot-kernel_push_clean

einfo "Running:  make mrproper ARCH=${arch}" # Reverts everything back to before make menuconfig
			#make mrproper ARCH=${arch} || die # more agressive wipe
			make clean ARCH="${arch}" || die # For external modules

			ot-kernel_pop_clean

			if [[ "${OT_KERNEL_SIGN_MODULES}" == "1" && -z "${OT_KERNEL_PRIVATE_KEY}" ]] ; then
				ot-kernel_restore_keys
			fi

			ot_kernel_serialize_pgo_state
		fi

		ot_kernel_fix_kernel_release

		cd "${BUILD_DIR}" || die
		ot_kernel_install_logos

		if ot-kernel_is_full_sources_required ; then
			ot-kernel_install_source_code
		else
			ot-kernel_install_genkernel_required
		fi

		ot-kernel_fix_certs_permissions
		ot-kernel_install_iosched_scripts
		ot-kernel_install_tcca
		ot-kernel_fix_modules

		if has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ; then
			ot-kernel_slotify_amdgpu
			ot-kernel_add_amdgpu_wrapper
		fi
	done

	ot-kernel_install_pgo_state
}

# @FUNCTION: ot-kernel_postinst_tresor
# @DESCRIPTION:
# Send user messages for tresor
ot-kernel_postinst_tresor() {
	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			local highest_tresor_pv=$(best_version "sys-kernel/ot-sources[tresor_sysfs]" \
				| sed -r -e "s|sys-kernel/ot-sources-||" -e "s|-r[0-9]+||")

			# Avoid symlink collisons between multiple installs.
			# dosym src_relpath_real dest_abspath_symlink
			dosym \
../../usr/src/linux-${highest_tresor_pv}-${main_extraversion_with_tresor}/tresor_sysfs \
				/usr/bin/tresor_sysfs
			# It's the same hash for 5.1 and 5.0.13 for tresor_sysfs.
einfo
einfo "The /usr/bin/tresor_sysfs CLI command which uses /sys/kernel/tresor/key too"
einfo "is provided to set your TRESOR key directly.  Your key should be a"
einfo "case-insensitive hex string without spaces and without any prefixes at least"
einfo "{128,192,256}-bits corresponding to AES-128, AES-192, AES-256.  Because"
einfo "it is custom, you may supply your own key deriviation function (KDF) and/or"
einfo "hashing algorithm, the result from gpg, or hardware key."
einfo
einfo "If using /sys/kernel/tresor/password for plaintext passwords, they can only"
einfo "be 53 characters maxiumum without the null character.  They will be sent to"
einfo "a key derivation function that is 2000 iterations of SHA256."
einfo
einfo "It's recommend that new users use /sys/kernel/tresor/password or set the"
einfo "password at boot."
einfo
einfo "Advanced users may use /sys/kernel/tresor/key instead."
einfo
		else
			if has tresor ${IUSE_EFFECTIVE} ; then
				if use tresor ; then
ewarn
ewarn "You can only enter a password that is 53 characters long without the null"
ewarn "character though the boot time TRESOR prompt."
ewarn
				fi
			fi
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
einfo
einfo "To prevent the prompt on boot from scrolling off the screen, you can do"
einfo "one of the following:"
einfo
einfo "  Set CONSOLE_LOGLEVEL_QUIET <= 5 AND add \`quiet\` as a kernel"
einfo "  parameter to the bootloader config."
einfo
einfo "or"
einfo
einfo "  Set CONFIG_CONSOLE_LOGLEVEL_DEFAULT <= 5 (if you didn't set the"
einfo "  \`quiet\` kernel parameter.)"
einfo
einfo "Setting CONFIG_CONSOLE_LOGLEVEL_DEFAULT and CONSOLE_LOGLEVEL_QUIET to"
einfo "<= 2 will wipe out all the boot time verbosity leaking into the TRESOR"
einfo "prompt from drivers."
einfo
einfo
ewarn "TRESOR was not designed for parallel usage.  Only one TRESOR device at a"
ewarn "time can be used."
ewarn
ewarn "TRESOR AES-192 and AES-256 is only available for the tresor_aesni"
ewarn "USE flag."
ewarn
ewarn "For 4.14, TRESOR with ECB and CBC are only available."
ewarn "CBC is recommended for production in the 4.14 series."
ewarn
ewarn "Modes of operation status with TRESOR:"
ewarn
ewarn "ECB:  stable (DO NOT USE, for testing purposes only)"
ewarn "CBC:  stable (recommended for production, used upstream)"
ewarn "CTR:  stable (4.14, 4.19, 5.4, 5.10 only)"
ewarn "XTS:  deprecated (256 XTS only with 128-bit key; 64-bit ABI only)"
ewarn "      (reason:  xts glue helper [glue_helper.c] removed upstream.)"
ewarn
ewarn "Support for TRESOR may require modding in the kernel source code level."
ewarn
ewarn "The kernel may require modding the setkey portions to support different"
ewarn "crypto systems whenever crypto_cipher_setkey or crypto_skcipher_setkey"
ewarn "gets called.  The module tries to avoid copies the key to memory and"
ewarn "needs the key dump to registers at the time the user enters the key."
ewarn "See CONFIG_CRYPTO_TRESOR code blocks in crypto/testmgr.c for details."
ewarn
ewarn "Because it uses hardware breakpoint debug address registers, these"
ewarn "debugging features are mutually exclusive when TRESOR is being used."
ewarn
ewarn "Using TRESOR with fscrypt is currently not supported."
ewarn
		fi
ewarn
ewarn "TRESOR for AES-NI has not been tested.  It's left for users to test and"
ewarn "fix."
ewarn
	fi
	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
ewarn
ewarn "TRESOR is currently not compatible with Integrated Assembler used by Clang/LLVM."
ewarn "Add LLVM_IAS=0 to make all to build it with Clang/LLVM."
ewarn
		fi
	fi
}

# @FUNCTION: ot-kernel_postinst_exfat
# @DESCRIPTION:
# Send user message about exfat
ot-kernel_postinst_exfat() {
	if has exfat ${IUSE_EFFECTIVE} && use exfat ; then
einfo
einfo "exFAT users:  You must be a member of OIN and agree to the OIN license"
einfo "for patent use legal protections and royalty free benefits."
einfo
einfo "An overview of the legal status of exFAT can be found at"
einfo "https://en.wikipedia.org/wiki/ExFAT#Legal_status"
einfo
einfo "An exFAT patent license can also be obtained from"
einfo "https://www.microsoft.com/en-us/legal/intellectualproperty/mtl/exfat-licensing.aspx"
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_network
# @DESCRIPTION:
# Send user messages about network modules
ot-kernel_postinst_network() {
	if (( ${OT_KERNEL_TCP_CONGESTION_CONTROLS_SCRIPT_INSTALL} == 1 )) ; then
einfo "Installing tcca"
		cat "${FILESDIR}/tcca" \
			> "${EROOT}/usr/bin/tcca"
		chmod 0755 "${EROOT}/usr/bin/tcca"
		chown root:root "${EROOT}/usr/bin/tcca"
	fi

	if has bbrv2 ${IUSE_EFFECTIVE} ; then
		if use bbrv2 ; then
einfo
einfo "To enable BBRv2 go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > BBR2 TCP"
einfo
einfo "To make BBRv2 the default go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > Default TCP congestion control > BBR2"
einfo
		fi
	fi

	if has bbrv3 ${IUSE_EFFECTIVE} ; then
		if use bbrv3 ; then
einfo
einfo "To enable BBRv3 go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > BBR TCP"
einfo
einfo "To make BBRv3 the default go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > Default TCP congestion control > BBR"
einfo
einfo "[BBR is not a typo for choosing BBRv3.]"
einfo
		fi
	fi

	if has c2tcp ${IUSE_EFFECTIVE} && use c2tcp ; then
einfo
einfo "C2TCP is disabled by default."
einfo
einfo "See epkginfo -x sys-apps/c2tcp::oiledmachine-overlay for details about"
einfo "enabling and the tunable target delay knob."
einfo
	fi
	if has deepcc ${IUSE_EFFECTIVE} && use deepcc ; then
einfo
einfo "DeepCC is disabled by default and needs the DRL Agent or learned models"
einfo "loaded."
einfo
einfo "See epkginfo -x sys-apps/deepcc::oiledmachine-overlay for details about"
einfo "enabling and loading the DRL Agent and learned model(s) and tunable"
einfo "target delay knob."
einfo
	fi
	if has orca ${IUSE_EFFECTIVE} && use orca ; then
einfo
einfo "Orca needs the DRL Agent or learned models loaded."
einfo
einfo "See epkginfo -x sys-apps/orca::oiledmachine-overlay for details about"
einfo "loading the DRL Agent with learned model."
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_initramfs
# @DESCRIPTION:
# Send user message about initramfs
ot-kernel_postinst_initramfs() {
	if has build ${IUSE_EFFECTIVE} && use build ; then
einfo
einfo "The kernel(s) still needs to complete the following steps:"
einfo
einfo "    1.  Run etc-update"
einfo "    2.  Build and install the initramfs per each kernel."
einfo "    3.  Update the bootloader with the new entries"
einfo "    4.  Reboot with the new kernel"
einfo
einfo "For details, see metadata.xml"
einfo "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)"
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_pgo
# @DESCRIPTION:
# Send user message about pgo
ot-kernel_postinst_pgo() {
	if use pgo && has build ${IUSE_EFFECTIVE} && use build ; then
einfo
einfo "The kernel(s) still needs to complete the following steps:"
einfo
einfo "    1.  Run etc-update"
einfo "    2.  Build and install the initramfs per each kernel."
einfo "    3.  Update the bootloader with a new entries"
einfo "    4.  Reboot with the PGIed kernel"
einfo "    5.  mount -t debugfs none /sys/kernel/debug"
einfo "        (For GCC PGO if /sys/kernel/debug is not mounted yet by init"
einfo "        scripts.)"
einfo "    6.  Train the kernel with benchmarks or the typical uses"
einfo "    7.  Re-emerging the package"
einfo "    8.  Reboot with optimized kernel"
einfo
einfo "For details, see metadata.xml"
einfo "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`)"
einfo
	fi
	if use pgo ; then
einfo
einfo "The pgo-trainer.sh has been provided in the root directory of the kernel"
einfo "sources for PGO training.  The script can be customized for automation."
einfo "if modded keep it in /home/\${USER} or /etc/portage folder.  This"
einfo "customization is used to capture typical use, but any non-typical use"
einfo "can result in performance degration.  It should only be run as a"
einfo "non-root user because it does PGO training on the network code as well."
einfo
einfo "You can add an additional pgo-custom.sh in the same directory as the"
einfo "script to extend PGO training."
einfo
einfo "Additional packages are required to run this particular"
einfo "automated trainer and can be found in"
einfo
einfo "  https://github.com/orsonteodoro/oiledmachine-overlay/blob/6de2332092a475bc2bc4f4aff350c36fce8f4c85/sys-kernel/genkernel/genkernel-4.2.6-r2.ebuild#L279"
einfo
einfo "You can use your own training scripts or test suites to perform PGO training."
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_iosched
# @DESCRIPTION:
# Send user message about iosched scripts
ot-kernel_postinst_iosched() {
	if [[ "${OT_KERNEL_IOSCHED_SYSTEMD:-1}" == "1" ]] ; then
einfo "Installing ot-kernel-iosched (systemd)"
		# Installed here to avoid merge conflict.
		mkdir -p "${EROOT}/lib/systemd/system"
		cat \
			"${FILESDIR}/ot-kernel-iosched.service" \
			> \
			"${EROOT}/lib/systemd/system/ot-kernel-iosched.service"
		chmod 0755 "${EROOT}/lib/systemd/system/ot-kernel-iosched.service"
		chown root:root "${EROOT}/lib/systemd/system/ot-kernel-iosched.service"

ewarn
ewarn "You need to do the following to make the work profile fully effective:"
ewarn
ewarn "  systemctl enable ot-kernel-iosched.service"
ewarn "  systemctl start ot-kernel-iosched.service"
ewarn
	fi

	if [[ "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" ]] ; then
einfo "Installing ot-kernel-iosched (OpenRC)"
		# Installed here to avoid merge conflict.
		mkdir -p "${EROOT}/etc/init.d"
		cat \
			"${FILESDIR}/ot-kernel-iosched.openrc" \
			> \
			"${EROOT}/etc/init.d/ot-kernel-iosched"
		chmod 0755 "${EROOT}/etc/init.d/ot-kernel-iosched"
		chown root:root "${EROOT}/etc/init.d/ot-kernel-iosched"

ewarn
ewarn "The iosched has been changed to ${EPREFIX}/etc/init.d/ot-kernel-iosched"
ewarn "You need to do the following to make the work profile fully effective:"
ewarn
ewarn "  rc-update add ot-kernel-iosched"
ewarn "  /etc/init.d/ot-kernel-iosched start"
ewarn
	fi

	if [[ \
		   "${OT_KERNEL_IOSCHED_OPENRC:-1}" == "1" \
		|| "${OT_KERNEL_IOSCHED_SYSTEMD:-1}" == "1" \
	]] ; then
		# Installed here to avoid merge conflict.
		cat \
			"${FILESDIR}/ot-kernel-iosched.sh" \
			> \
			"${EROOT}/usr/bin/ot-kernel-iosched.sh"
		chmod 0755 "${EROOT}/usr/bin/ot-kernel-iosched.sh"
		chown root:root "${EROOT}/usr/bin/ot-kernel-iosched.sh"
	fi
}

# @FUNCTION: ot-kernel_postinst_disable_debug
# @DESCRIPTION:
# Send user mesage about disable_debug
ot-kernel_postinst_disable_debug() {
	if use disable_debug ; then
einfo
einfo "The disable debug scripts have been placed in the root folder of the"
einfo "kernel folder."
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_initramfs_compression
# @DESCRIPTION:
# Send user mesage about initramfs compression
ot-kernel_postinst_initramfs_compression() {
einfo
einfo "For Genkernel users.  It's recommended to add either"
einfo
einfo "  --compress-initramfs-type=zstd"
einfo
einfo "or"
einfo
einfo "  --compress-initramfs-type=lz4"
einfo
einfo "to genkernel invocation if the compression type is present in the"
einfo "kernel series."
einfo
}

# @FUNCTION: ot-kernel_postinst_rt_patchset
# @DESCRIPTION:
# Send user message about rt patchset
ot-kernel_postinst_rt_patchset() {
	local rt_option
	if   ver_test ${KV_MAJOR_MINOR} -ge 5.4 ; then
		rt_option="CONFIG_PREEMPT_RT"
	elif ver_test ${KV_MAJOR_MINOR} -lt 5.4 ; then
		rt_option="CONFIG_PREEMPT_RT_FULL"
	fi
	if has rt ${FEATURES} ; then
		if use rt ; then
einfo
einfo "Don't forget to set ${rt_option} found at \"General setup\" in"
einfo "newer kernels or in \"Processor type and features\" in older kernels"
einfo "> Preemption Model >  Fully Preemptible Kernel (Real-Time)."
einfo
		fi
	fi
}

# @FUNCTION: ot-kernel_postinst_clang_built_linux
# @DESCRIPTION:
# Send messages for clang built linux
ot-kernel_postinst_clang_built_linux() {
	local has_llvm=0
	local llvm_ver_maj=12 # set to highest kcp arch requirement
	local wants_cfi=0
	local wants_kcfi=0
	local wants_lto=0
	local gcc_pv=$(best_version "${GCC_PKG}" \
		| sed -r -e "s|${GCC_PKG}-||g" \
		-e "s|-r[0-9]+||"| cut -f 1-3 -d ".")
	if ot-kernel_has_version "sys-devel/clang" ; then
		has_llvm=1
		llvm_ver_maj=$(best_version "sys-devel/clang" \
		| sed -r -e "s|sys-devel/clang-||g" \
		-e "s|-r[0-9]+||" | cut -f 1 -d ".")
	fi

	if has cfi ${IUSE_EFFECTIVE} ; then
		if use cfi ; then
			wants_cfi=1
		fi
	fi
	if has kcfi ${IUSE_EFFECTIVE} ; then
		if use kcfi ; then
			wants_kcfi=1
		fi
	fi
	if has lto ${IUSE_EFFECTIVE} ; then
		if use lto ; then
			wants_lto=1
		fi
	fi

	if (( ${wants_lto} == 1 || ${wants_cfi} == 1 || ${wants_kcfi} == 1 )) ; then
einfo
einfo "It's recommend to use sys-devel/genpatches[llvm]::oiledmachine-overlay"
einfo "when building with LTO and/or (K)CFI with the --llvm passed to genkernel."
einfo
einfo "To present the (K)CFI/LTO options, you must:"
einfo
einfo "  \`make menuconfig \
AR=/usr/lib/llvm/${llvm_ver_maj}/bin/llvm-ar \
AS=/usr/lib/llvm/${llvm_ver_maj}/bin/llvm-as \
CC=clang-${llvm_ver_maj} \
LD=/usr/bin/ld.lld \
NM=/usr/lib/llvm/${llvm_ver_maj}/bin/llvm-nm"
einfo
einfo "(K)CFI or LTO requires that the menuconfig settings are changed to:"
einfo
einfo "  General architecture-dependent options > Link Time Optimization (LTO) > Clang ThinLTO (EXPERIMENTAL)"
einfo
einfo "For (K)CFI, the menuconfig item is found at:"
einfo
einfo "  General architecture-dependent options > Use Clang's Control Flow Integrity (CFI)"
einfo
einfo "For ShadowCallStack, the menuconfig item is found at:"
einfo
einfo "  General architecture-dependent options > Clang Shadow Call Stack"
einfo
	fi

einfo
einfo "The kernel_compiler patch requires that you either add"
einfo
einfo "  --kernel-cc=/usr/bin/\${CHOST}-gcc-\${gcc_pv}"
einfo
einfo "    or"
einfo
einfo "  use the sys-devel/genpatches[llvm]::oiledmachine-overlay package"
einfo "  with the --llvm argument passed to genkernel"
einfo
einfo "to optimize for newer microarchitectures."
einfo
}

# @FUNCTION: ot-kernel_postinst_proton
# @DESCRIPTION:
# Send message about proton
ot-kernel_postinst_proton() {
	if has_version "app-emulation/wine-proton" \
		&& ver_test ${KV_MAJOR_MINOR} -ge 5.16 ; then
einfo
einfo "You may need to set the environment variable WINEFSYNC=1 for futex2"
einfo "support for the app-emulation/wine-proton package."
einfo
einfo "futex2 yields benefits of less than 5% CPU usage."
einfo
	fi
}

# @FUNCTION: ot-kernel_postinst_security_notices
# @DESCRIPTION:
# Send user messages about security
ot-kernel_postinst_security_notices() {
ewarn
ewarn "Any crypto algorithm or password store that stores keys in memory or"
ewarn "registers are vulnerable.  This includes TRESOR as well."
ewarn
ewarn "To properly use full disk encryption, do not use suspend to RAM and"
ewarn "shutdown the computer immediately on idle."
ewarn
ewarn "Futher mitigation recommendations can be found at"
ewarn
ewarn "  https://en.wikipedia.org/wiki/Cold_boot_attack#Mitigation"
ewarn

ewarn
ewarn "Multiple built kernels require a corresponding initramfs especially if"
ewarn "modules are signed with their corresponding build's private key and"
ewarn "embedded in the initramfs."
ewarn

	if [[ "${OT_KERNEL_SIGN_MODULES}" == "1" ]] ; then
ewarn
ewarn "The private key in the /usr/src/linux/certs folder should be kept in a"
ewarn "safe space (e.g. by keychain encrypted storage or by steganography) or"
ewarn "be cryptographically securely destroyed in the certs folder after"
ewarn "being transfered into secure storage.  The key temporarily stored in"
ewarn "the certs folder should be securely destroyed in within 24 hours."
ewarn "Each build configuration with have a unique private-shared keys if"
ewarn "using autogenerated, so all keys need to be stored and properly"
ewarn "labeled to prevent mixup."
ewarn
ewarn "Keep the private key if you have external modules that still need to be"
ewarn "signed.  Any driver not signed will be rejected by the kernel."
ewarn
ewarn "If using genkernel, you must add --no-strip since the modules are"
ewarn "signed."
ewarn
	fi

	local private_keys=(
		$(find /var/tmp/portage/sys-kernel/ot-sources*/work/*/certs/ -maxdepth 1 -name "*.pem")
		$(find /var/tmp/portage/sys-kernel/ot-sources*/work/*/ -maxdepth 1 -name "*.pem")
	)
	if (( ${#private_keys[@]} > 0 )) ; then
elog "Detected the following previous install or partial build of the ${PN}"
elog "package with these private keys: ${private_keys[@]}"
elog "Please run shred -f on every file listed as a precaution."
	fi
	if [[ "${OT_KERNEL_SME}" == "1" && "${OT_KERNEL_SME_DEFAULT_ON}" != "1" ]] ; then
ewarn
ewarn "SME is allowed but requires testing before permanent setting on."
ewarn "See metadata.xml (or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for"
ewarn "details."
ewarn
	fi
	if [[ "${_OT_KERNEL_IMA_USED}" == "1" ]] ; then
einfo
einfo "To optimize IMA hashing add iversion to fstab mount option for / (aka root)."
einfo
	fi
	if [[ "${OT_KERNEL_DMA_ATTACK_MITIGATIONS_ENABLED}" == "1" ]] ; then
	# For possible impractical passthough (pt) DMA attack, see
	# https://link.springer.com/article/10.1186/s13173-017-0066-7#Fn1
ewarn
ewarn "Please upgrade both the motherboard and CPU with support with either"
ewarn "VT-d or Vi to mitigate against a DMA attack.  Ensure that that"
ewarn "IOMMU is being used.  Do not disable IOMMU or use passthrough (pt)."
ewarn "See"
ewarn
ewarn "  https://en.wikipedia.org/wiki/List_of_IOMMU-supporting_hardware"
ewarn
ewarn "for IOMMU supported hardware.  For details about the DMA side-channel"
ewarn "attack, see"
ewarn
ewarn "  https://en.wikipedia.org/wiki/DMA_attack"
ewarn
ewarn "If you cannot afford the hardware, you may consider removing DMA based"
ewarn "ports, soldering connections, hardware based encrypted RAM, and"
ewarn "disabling DMA to mitigate against a DMA attack."
ewarn
ewarn "You must enable the BIOS password to mitigate against DMA attacks"
ewarn "and prevent the disablement of IOMMU.  Also, VT-d/Vi must be enabled in"
ewarn "the BIOS."
ewarn
	else
ewarn
ewarn "You have disabled DMA attack mitigation.  It is not recommended if"
ewarn "you use full disk encryption."
ewarn
	fi
	if [[ "${_OT_KERNEL_PRINK_DISABLED}" == "1" ]] ; then
ewarn
ewarn "All the /var/log/dmesg* files need to be shred (or other cryptographic"
ewarn "erase tool) to prevent obtaining details for a possible DMA attack or"
ewarn "vulnerability scans.  This is to be done after booting into a kernel"
ewarn "with dmesg disabled."
ewarn
	fi


ewarn
ewarn "For full L1TF mitigation for HT processors, read the Wikipedia article."
ewarn "https://en.wikipedia.org/wiki/Foreshadow"
ewarn "https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/core-scheduling.html"
ewarn

ewarn
ewarn "For mitigations of side-channels because of hardware flaws, see also"
ewarn "https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/index.html"
ewarn
ewarn
ewarn "Numerous CPU (or hardware) vulnerabilities have been identified recently:"
ewarn
ewarn "For an overview about affected processors, see"
ewarn
ewarn "  https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability"
ewarn
ewarn "Mitigation techniques:"
ewarn
ewarn "  Kernel source code:  Supported by the kernel development team"
ewarn "  CPU microcode:       Supported by the firmware packages"
ewarn "  BIOS update:         Supported by the motherboard manufacturer, which"
ewarn "                       may require dual booting.  (It may be hinted by"
ewarn "                       the motherboard support download page under the"
ewarn "                       words AGESA™)"
ewarn
ewarn "The mitigation fix may sometimes only be available in one of the rows above."
ewarn
ewarn "Requirements to mitigate:"
ewarn
ewarn "  (1) AMD CPUs:    USE=\"linux-firmware\""
ewarn "      Intel CPUs:  USE=\"intel-microcode\""
ewarn "  (2) For config assist mode, set OT_KERNEL_CPU_MICROCODE=1"
ewarn "      For config custom mode, see"
ewarn "      https://wiki.gentoo.org/wiki/AMD_microcode"
ewarn "      https://wiki.gentoo.org/wiki/Intel_microcode"
ewarn "  (3) Re-emerge this package after the changes have been made."
ewarn "  (4) etc-update"
ewarn "  (5) Build/update initramfs"
ewarn "  (6) Reboot into new kernels"
ewarn
}

# @FUNCTION: ot-kernel_postinst_experimental_kernel
# @DESCRIPTION:
# Sends a user message to always have a backup kernel
ot-kernel_postinst_experimental_kernel() {
ewarn
ewarn "The ot-kernel is always considered experimental grade.  Always have a"
ewarn "rescue/fallback kernel with possibly an older version or with another"
ewarn "kernel package."
ewarn
}

# @FUNCTION: ot-kernel_pkg_postinst
# @DESCRIPTION:
# Present warnings and avoid collision checks.
#
# ot-kernel_pkg_postinst_cb - callback if any to handle after emerge phase
#
ot-kernel_pkg_postinst() {
	local env_path
	for env_path in $(ot-kernel_get_envs) ; do
		[[ -e "${env_path}" ]] || continue
		ot-kernel_clear_env
		declare -A OT_KERNEL_KCONFIG
		declare -A OT_KERNEL_PKGFLAGS_ACCEPT
		declare -A OT_KERNEL_PKGFLAGS_REJECT
		ot-kernel_load_config
		[[ "${OT_KERNEL_DISABLE}" == "1" ]] && continue
		local extraversion="${OT_KERNEL_EXTRAVERSION}"
		BUILD_DIR="${WORKDIR}/linux-${UPSTREAM_PV}-${extraversion}"
		if [[ -e "${BUILD_DIR}/certs/signing_key.pem" ]] ; then
			cd "${BUILD_DIR}" || die
einfo "Secure wiping the private key in build directory for ${extraversion}"
			# Secure wipe the private keys if custom config bypassing envvars as well
			shred -f "${BUILD_DIR}/certs/signing_key.pem" || die
		fi
	done

	local main_extraversion=${OT_KERNEL_PRIMARY_EXTRAVERSION:-ot}
	local main_extraversion_with_tresor=${OT_KERNEL_PRIMARY_EXTRAVERSION_WITH_TRESOR:-ot}

	local highest_pv=$(best_version "sys-kernel/ot-sources" \
			| sed -r -e "s|sys-kernel/ot-sources-||" -e "s|-r[0-9]+||")

	if use symlink ; then
		# dosym src_relpath_real dest_abspath_symlink
		dosym linux-${highest_pv}-${main_extraversion} /usr/src/linux
	fi

	if declare -f ot-kernel_pkg_postinst_cb > /dev/null ; then
		ot-kernel_pkg_postinst_cb
	fi

	ot-kernel_postinst_security_notices
	ot-kernel_postinst_tresor
	ot-kernel_postinst_disable_debug
	ot-kernel_postinst_initramfs_compression
	ot-kernel_postinst_rt_patchset
	ot-kernel_postinst_clang_built_linux
	ot-kernel_postinst_pgo
	ot-kernel_postinst_initramfs
	ot-kernel_postinst_iosched
	ot-kernel_postinst_network
	ot-kernel_postinst_exfat
	ot-kernel_postinst_proton
	ot-kernel_postinst_experimental_kernel
}

# @FUNCTION: pkg_prerm
# @DESCRIPTION:
# Remove wrappers
pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
einfo "Removing tcca"
		rm "${EROOT}/usr/bin/tcca" 2>/dev/null
einfo "Removing ot-kernel-iosched"
		rm "${EROOT}/etc/init.d/ot-kernel-iosched" 2>/dev/null
	fi
}
