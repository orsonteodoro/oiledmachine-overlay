# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-cve.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for CVE patching the kernel
# @DESCRIPTION:
# The ot-kernel-cve eclass resolves CVE vulnerabilities for any linux kernel version, preferably latest stable.

# These are not enabled by default because of licensing, government interest, no crypto applied (as in PGP/GPG signed emails) to messages to authenticate or verify them.
IUSE+=" cve_hotfix"
LICENSE+=" cve_hotfix? ( GPL-2 )"

# _PM = patch message from person who fixed it, _FN = patch file name

inherit ot-kernel-cve-en

# based on my last edit in unix timestamp (date -u +%Y%m%d_%I%M_%p_%Z)
LATEST_CVE_KERNEL_INDEX="20190927_1122_PM_UTC"
LATEST_CVE_KERNEL_INDEX="${LATEST_CVE_KERNEL_INDEX,,}"

# this will trigger a kernel re-install based on use flag timestamp
# there is no need to set this flag but tricks the emerge system to re-emerge.
if [[ -n "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" && "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" == "1" ]] ; then
	IUSE+=" cve_update_${LATEST_CVE_KERNEL_INDEX}"
fi

CVE_LANG="${CVE_LANG:=en}" # You can define this in your make.conf.  Currently en is only supported.

CVE_2019_16746_FIX_SRC_URI="https://marc.info/?l=linux-wireless&m=156901391225058&q=mbox"
CVE_2019_16746_FN="CVE-2019-16746-fix--linux-wireless-20190920-nl80211-validate-beacon-head.patch"
CVE_2019_16746_SEVERITY_LANG="CVE_2019_16746_SEVERITY_${CVE_LANG}"
CVE_2019_16746_SEVERITY="${!CVE_2019_16746_SEVERITY_LANG}"
CVE_2019_16746_PM="https://marc.info/?l=linux-wireless&m=156901391225058&w=2"
CVE_2019_16746_SUMMARY_LANG="CVE_2019_16746_SUMMARY_${CVE_LANG}"
CVE_2019_16746_SUMMARY="${!CVE_2019_16746_SUMMARY_LANG}"

CVE_2019_14814_FIX_SRC_URI="https://github.com/torvalds/linux/commit/7caac62ed598a196d6ddf8d9c121e12e082cac3a.patch"
CVE_2019_14814_FN="CVE-2019-14814-fix--linux-mwifiex-fix-three-heap-overflow-at-parsing-element-in-cfg80211_ap_settings.patch"
CVE_2019_14814_SEVERITY_LANG="CVE_2019_14814_SEVERITY_${CVE_LANG}"
CVE_2019_14814_SEVERITY="${!CVE_2019_14814_SEVERITY_LANG}"
CVE_2019_14814_PM="https://github.com/torvalds/linux/commit/7caac62ed598a196d6ddf8d9c121e12e082cac3a"
CVE_2019_14814_SUMMARY_LANG="CVE_2019_14814_SUMMARY_${CVE_LANG}"
CVE_2019_14814_SUMMARY="${!CVE_2019_14814_SUMMARY_LANG}"

CVE_2019_14821_FIX_SRC_URI="https://github.com/torvalds/linux/commit/b60fe990c6b07ef6d4df67bc0530c7c90a62623a.patch"
CVE_2019_14821_FN="CVE-2019-14821-fix--linux-kvm-20190916-coalesced-mmio-add-bounds-checking.patch"
CVE_2019_14821_SEVERITY_LANG="CVE_2019_14821_SEVERITY_${CVE_LANG}"
CVE_2019_14821_SEVERITY="${!CVE_2019_14821_SEVERITY_LANG}"
CVE_2019_14821_PM="https://github.com/torvalds/linux/commit/b60fe990c6b07ef6d4df67bc0530c7c90a62623a"
CVE_2019_14821_SUMMARY_LANG="CVE_2019_14821_SUMMARY_${CVE_LANG}"
CVE_2019_14821_SUMMARY="${!CVE_2019_14821_SUMMARY_LANG}"

CVE_2019_16921_FIX_SRC_URI="https://github.com/torvalds/linux/commit/df7e40425813c50cd252e6f5e348a81ef1acae56.patch"
CVE_2019_16921_FN="CVE-2019-16921-fix--linux-rdma-hns-fix-init-resp-when-alloc-ucontext.patch"
CVE_2019_16921_SEVERITY_LANG="CVE_2019_16921_SEVERITY_${CVE_LANG}"
CVE_2019_16921_SEVERITY="${!CVE_2019_16921_SEVERITY_LANG}"
CVE_2019_16921_PM="https://github.com/torvalds/linux/commit/df7e40425813c50cd252e6f5e348a81ef1acae56"
CVE_2019_16921_SUMMARY_LANG="CVE_2019_16921_SUMMARY_${CVE_LANG}"
CVE_2019_16921_SUMMARY="${!CVE_2019_16921_SUMMARY_LANG}"

SRC_URI+=" cve_hotfix? ( ${CVE_2019_16746_FIX_SRC_URI} -> ${CVE_2019_16746_FN}
			 ${CVE_2019_14814_FIX_SRC_URI} -> ${CVE_2019_14814_FN}
			 ${CVE_2019_14821_FIX_SRC_URI} -> ${CVE_2019_14821_FN}
			 ${CVE_2019_16921_FIX_SRC_URI} -> ${CVE_2019_16921_FN} )"

# @FUNCTION: _fetch_cve_boilerplate_msg
# @DESCRIPTION:
# Message to report the important items to user about the CVE.
function _fetch_cve_boilerplate_msg() {
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local PS="${CVE_ID_}FIX_SRC_URI"
	local NIST_NVD_CVE_M="https://nvd.nist.gov/vuln/detail/${CVE_ID}"
	local MITRE_M="https://cve.mitre.org/cgi-bin/cvename.cgi?name=${CVE_ID}"
	local summary="${CVE_ID_}SUMMARY"
	local pm="${CVE_ID_}PM"
	PS="${!PS}"
	ewarn
	ewarn "${CVE_ID}"
	ewarn "Severity: ${!cve_severity}"
	ewarn "Synopsis: ${!summary}"
	ewarn "NIST NVD URI: ${NIST_NVD_CVE_M}"
	ewarn "MITRE URI: ${MITRE_M}"
	ewarn "Patch download: ${PS}"
	ewarn "Patch message: ${!pm}"
	ewarn
}

# @FUNCTION: _fetch_cve_boilerplate_msg_footer
# @DESCRIPTION:
# Message to report action to user to fix the CVE.
function _fetch_cve_boilerplate_msg_footer() {
	ewarn "Re-enable the cve_hotfix USE flag to fix this, or you may ignore this and wait for an official fix."
	ewarn
	echo -e "\07" # ring the bell
	sleep 30s
}

# @FUNCTION: fetch_cve_2019_16746_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_16746 patch
function fetch_cve_2019_16746_hotfix() {
	local CVE_ID="CVE-2019-16746"
	if grep -F -e "validate_beacon_head" "${S}/net/wireless/nl80211.c" >/dev/null ; then
		einfo "${CVE_ID} already patched."
		return
	fi
	local cve_fn="${CVE_ID_}FN"
	_fetch_cve_boilerplate_msg
	if use cve_hotfix && test -n "${!cve_fn}"; then
		einfo "A ${CVE_ID} fix will be applied."
	else
		_fetch_cve_boilerplate_msg_footer
	fi
}

# @FUNCTION: fetch_cve_2019_14814_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-14814 patch
function fetch_cve_2019_14814_hotfix() {
	local CVE_ID="CVE-2019-14814"
	if grep -F -e "if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >" "${S}/drivers/net/wireless/marvell/mwifiex/ie.c" >/dev/null ; then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	if ! use cve_hotfix ; then
		_fetch_cve_boilerplate_msg_footer
	fi
}

# @FUNCTION: fetch_cve_2019_14821_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-14821 patch
function fetch_cve_2019_14821_hotfix() {
	local CVE_ID="CVE-2019-14821"
	if grep -F -e "if (!coalesced_mmio_has_room(dev, insert) ||" "${S}/virt/kvm/coalesced_mmio.c" >/dev/null ; then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	if ! use cve_hotfix ; then
		_fetch_cve_boilerplate_msg_footer
	fi
}

# @FUNCTION: fetch_cve_2019_16921_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-16921 patch
function fetch_cve_2019_16921_hotfix() {
	local CVE_ID="CVE-2019-16921"
	if grep -F -e "struct hns_roce_ib_alloc_ucontext_resp resp = {};" "${S}/drivers/infiniband/hw/hns/hns_roce_main.c" >/dev/null ; then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	if ! use cve_hotfix ; then
		_fetch_cve_boilerplate_msg_footer
	fi
}

# @FUNCTION: apply_cve_2019_16746_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16746 patch if it needs to
function apply_cve_2019_16746_hotfix() {
	local CVE_ID="CVE-2019-16746"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e "validate_beacon_head" "${S}/net/wireless/nl80211.c" >/dev/null ; then
		einfo "${CVE_ID} is already patched."
		return
	fi
	if use cve_hotfix ; then
		if [ -e "${DISTDIR}/${!cve_fn}" ] ; then
			einfo "Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${DISTDIR}/${!cve_fn}"
		else
			ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: apply_cve_2019_14814_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_14814 patch if it needs to
function apply_cve_2019_14814_hotfix() {
	local CVE_ID="CVE-2019-14814"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e "if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >" "${S}/drivers/net/wireless/marvell/mwifiex/ie.c" >/dev/null ; then
		einfo "${CVE_ID} is already patched."
		return
	fi
	if use cve_hotfix ; then
		if [ -e "${DISTDIR}/${!cve_fn}" ] ; then
			einfo "Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${DISTDIR}/${!cve_fn}"
		else
			ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: apply_cve_2019_14821_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_14821 patch if it needs to
function apply_cve_2019_14821_hotfix() {
	local CVE_ID="CVE-2019-14821"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e "if (!coalesced_mmio_has_room(dev, insert) ||" "${S}/virt/kvm/coalesced_mmio.c" >/dev/null ; then
		einfo "${CVE_ID} is already patched."
		return
	fi
	if use cve_hotfix ; then
		if [ -e "${DISTDIR}/${!cve_fn}" ] ; then
			einfo "Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${DISTDIR}/${!cve_fn}"
		else
			ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: apply_cve_2019_16921_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16921 patch if it needs to
function apply_cve_2019_16921_hotfix() {
	local CVE_ID="CVE-2019-16921"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e "struct hns_roce_ib_alloc_ucontext_resp resp = {};" "${S}/drivers/infiniband/hw/hns/hns_roce_main.c" >/dev/null ; then
		einfo "${CVE_ID} is already patched."
		return
	fi
	if use cve_hotfix ; then
		if [ -e "${DISTDIR}/${!cve_fn}" ] ; then
			einfo "Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${DISTDIR}/${!cve_fn}"
		else
			ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn "No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: fetch_cve_hotfixes
# @DESCRIPTION:
# Fetches all the CVE kernel patches
function fetch_cve_hotfixes() {
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		einfo
		einfo "--------------------------------------------------"
		einfo
		fetch_cve_2019_16746_hotfix
		fetch_cve_2019_14814_hotfix
		fetch_cve_2019_14821_hotfix
		fetch_cve_2019_16921_hotfix
		local cve_copyright1="CVE_COPYRIGHT1_${CVE_LANG}"
		local cve_copyright2="CVE_COPYRIGHT2_${CVE_LANG}"
		einfo
		einfo "${!cve_copyright1}"
		einfo "${!cve_copyright2}"
		einfo
		einfo "--------------------------------------------------"
		einfo
		einfo "You may set CVE_SUBSCRIBE_KERNEL_HOTFIXES=1 in your make.conf to get CVE hotfix updates."
		einfo
		sleep 10s
	fi
}

# @FUNCTION: apply_cve_hotfixes
# @DESCRIPTION:
# Applies all the CVE kernel patches
function apply_cve_hotfixes() {
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		einfo "Applying CVE hotfixes"
		apply_cve_2019_16746_hotfix
		apply_cve_2019_14814_hotfix
		apply_cve_2019_14821_hotfix
		apply_cve_2019_16921_hotfix
	fi
}
