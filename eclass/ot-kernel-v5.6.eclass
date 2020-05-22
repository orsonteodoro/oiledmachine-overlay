#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2020 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.6.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 5.6.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.6 eclass defines specific applicable patching for the 5.6.x
# linux kernel.

ETYPE="sources"

K_MAJOR_MINOR="5.6"
K_PATCH_XV="5.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.6"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.6"
PATCH_ALLOW_O3_COMMIT="651fb09094936c829a4d430908c7e523e357cfbd"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.6"
PATCH_CK_REVISION="2"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?10}"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_BFQ_VER="5.6"
PATCH_BMQ_MAJOR_MINOR="5.6"
DISABLE_DEBUG_V="1.1"
ZENTUNE_5_6_COMMIT="ef3a3e65c6f4eb74afe3b42024753aadc1c80672..d33eeeb62ca70eeba3234089e7bc61ac11e8d351"

IUSE="  bfq bmq bmq-quick-fix \
	+cfs disable_debug +graysky2 muqss +o3 uksm \
	futex-wait-multiple \
	zenmisc \
	-zentune"
REQUIRED_USE="^^ ( muqss cfs bmq )"

# no released patch yet
REQUIRED_USE+=" !bmq-quick-fix"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED=${K_SECURITY_UNSUPPORTED:="1"}

inherit kernel-2 toolchain-funcs
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel patchset, GraySky's GCC \
Patches, MUQSS CPU Scheduler, BMQ CPU Scheduler, \
Genpatches, BFQ updates, CVE fixes"

CK_URL_BASE=\
"http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

inherit check-reqs ot-kernel-common

#BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.patch"
#BMQ_SRC_URL+=" https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}"

SRC_URI+=" ${CK_SRC_URL}"

SRC_URI+=" ${KERNEL_URI}
	   ${GENPATCHES_URI}
	   ${ARCH_URI}
	   ${O3_ALLOW_SRC_URL}
	   ${GRAYSKY_SRC_4_9_URL}
	   ${GRAYSKY_SRC_8_1_URL}
	   ${GRAYSKY_SRC_9_1_URL}
	   ${BMQ_SRC_URL}
	   ${GENPATCHES_BASE_SRC_URL}
	   ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	   ${GENPATCHES_EXTRAS_SRC_URL}
	   ${KERNEL_PATCH_URLS[@]}
"
SRC_URI+=" ${UKSM_SRC_URL}"

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	if use zentune || use muqss ; then
		ewarn \
"The zen-tune patch or muqss might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
	fi
}

# @FUNCTION: ot-kernel-common_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL and\n\
Idle dynticks system (tickless idle) CONFIG_NO_HZ_IDLE may cause the system\n\
  to lock up.\n\
You must choose Periodic timer ticks (constant rate, no dynticks)\n\
  CONFIG_HZ_PERIODIC for it not to lock up.\n\
The MuQSS scheduler may have random system hard pauses for few seconds to\n\
  around a minute when resource usage is high."
	fi

	if use bmq ; then
		ewarn \
"Using bmq with lots of resources may leave zombie processes, or high CPU\n\
  processes/threads with little processing.\n\
This might result in a denial of service that may require rebooting."
	fi
}
