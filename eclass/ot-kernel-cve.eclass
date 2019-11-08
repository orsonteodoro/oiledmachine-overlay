#1234567890123456789012345678901234567890123456789012345678901234567890123456789
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
# The ot-kernel-cve eclass resolves CVE vulnerabilities for any linux kernel
# version, preferably latest stable.

# WARNING: The patch tests assume the whole commit or patch is used.  Do not
# try to manually apply a custom patch to attempt to rig the result as pass.

# These are not enabled by default because of licensing, government interest,
# no crypto applied (as in PGP/GPG signed emails) to messages to authenticate
# or verify them.
IUSE+=" cve_hotfix"
LICENSE+=" cve_hotfix? ( GPL-2 )"

DEPEND+=" dev-libs/libpcre"

# _PM = patch message from person who fixed it, _FN = patch file name

inherit ot-kernel-cve-en

# based on my last edit in unix timestamp (date -u +%Y%m%d_%I%M_%p_%Z)
LATEST_CVE_KERNEL_INDEX="20191108_0444_AM_UTC"
LATEST_CVE_KERNEL_INDEX="${LATEST_CVE_KERNEL_INDEX,,}"

# this will trigger a kernel re-install based on use flag timestamp
# there is no need to set this flag but tricks the emerge system to re-emerge.
if [[ -n "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" \
	&& "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" == "1" ]] ; \
then
	IUSE+=" cve_update_${LATEST_CVE_KERNEL_INDEX}"
fi

CVE_DELAY="${CVE_DELAY:=1}"

CVE_LANG="${CVE_LANG:=en}" # You can define this in your make.conf.  Currently en is only supported.

CVE_2007_3732_FIX_SRC_URI=""
CVE_2007_3732_FN="CVE-2007-3732-fix--linux.patch"
CVE_2007_3732_SEVERITY_LANG="CVE_2007_3732_SEVERITY_${CVE_LANG}"
CVE_2007_3732_SEVERITY="${!CVE_2007_3732_SEVERITY_LANG}"
CVE_2007_3732_PM=""
CVE_2007_3732_SUMMARY_LANG="CVE_2007_3732_SUMMARY_${CVE_LANG}"
CVE_2007_3732_SUMMARY="${!CVE_2007_3732_SUMMARY_LANG}"

CVE_2010_2243_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=ad6759fbf35d104dbf573cd6f4c6784ad6823f7e"
CVE_2010_2243_FN="CVE-2010-2243-fix--linux-kernel-time-clocksource-timekeeping-Prevent-oops-when-GENERIC_TIME-is-n.patch"
CVE_2010_2243_SEVERITY_LANG="CVE_2010_2243_SEVERITY_${CVE_LANG}"
CVE_2010_2243_SEVERITY="${!CVE_2010_2243_SEVERITY_LANG}"
CVE_2010_2243_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ad6759fbf35d104dbf573cd6f4c6784ad6823f7e"
CVE_2010_2243_SUMMARY_LANG="CVE_2010_2243_SUMMARY_${CVE_LANG}"
CVE_2010_2243_SUMMARY="${!CVE_2010_2243_SUMMARY_LANG}"

CVE_2014_3180_FIX_SRC_URI="https://lkml.org/lkml/diff/2014/9/7/29/1"
CVE_2014_3180_FN="CVE-2014-3180-fix--linux-kernel-compat-timer-updates-for-3.17.patch"
CVE_2014_3180_SEVERITY_LANG="CVE_2014_3180_SEVERITY_${CVE_LANG}"
CVE_2014_3180_SEVERITY="${!CVE_2014_3180_SEVERITY_LANG}"
CVE_2014_3180_PM="https://lkml.org/lkml/2014/9/7/29"
CVE_2014_3180_SUMMARY_LANG="CVE_2014_3180_SUMMARY_${CVE_LANG}"
CVE_2014_3180_SUMMARY="${!CVE_2014_3180_SUMMARY_LANG}"

CVE_2019_16746_FIX_SRC_URI="https://marc.info/?l=linux-wireless&m=156901391225058&q=mbox"
CVE_2019_16746_FN="CVE-2019-16746-fix--linux-net-wireless-nl80211-validate-beacon-head.patch"
CVE_2019_16746_SEVERITY_LANG="CVE_2019_16746_SEVERITY_${CVE_LANG}"
CVE_2019_16746_SEVERITY="${!CVE_2019_16746_SEVERITY_LANG}"
CVE_2019_16746_PM="https://marc.info/?l=linux-wireless&m=156901391225058&w=2"
CVE_2019_16746_SUMMARY_LANG="CVE_2019_16746_SUMMARY_${CVE_LANG}"
CVE_2019_16746_SUMMARY="${!CVE_2019_16746_SUMMARY_LANG}"

CVE_2019_14814_FIX_SRC_URI="https://github.com/torvalds/linux/commit/7caac62ed598a196d6ddf8d9c121e12e082cac3a.patch"
CVE_2019_14814_FN="CVE-2019-14814-fix--linux-drivers-net-wireless-marvel-mwifiex-fix-three-heap-overflow-at-parsing-element-in-cfg80211_ap_settings.patch"
CVE_2019_14814_SEVERITY_LANG="CVE_2019_14814_SEVERITY_${CVE_LANG}"
CVE_2019_14814_SEVERITY="${!CVE_2019_14814_SEVERITY_LANG}"
CVE_2019_14814_PM="https://github.com/torvalds/linux/commit/7caac62ed598a196d6ddf8d9c121e12e082cac3a"
CVE_2019_14814_SUMMARY_LANG="CVE_2019_14814_SUMMARY_${CVE_LANG}"
CVE_2019_14814_SUMMARY="${!CVE_2019_14814_SUMMARY_LANG}"

CVE_2019_14821_FIX_SRC_URI="https://github.com/torvalds/linux/commit/b60fe990c6b07ef6d4df67bc0530c7c90a62623a.patch"
CVE_2019_14821_FN="CVE-2019-14821-fix--linux-virt-kvm-coalesced-mmio-add-bounds-checking.patch"
CVE_2019_14821_FN_4_9="CVE-2019-14821-fix--linux-virt-kvm-coalesced-mmio-add-bounds-checking-for-4.9.182.patch"
CVE_2019_14821_SEVERITY_LANG="CVE_2019_14821_SEVERITY_${CVE_LANG}"
CVE_2019_14821_SEVERITY="${!CVE_2019_14821_SEVERITY_LANG}"
CVE_2019_14821_PM="https://github.com/torvalds/linux/commit/b60fe990c6b07ef6d4df67bc0530c7c90a62623a"
CVE_2019_14821_SUMMARY_LANG="CVE_2019_14821_SUMMARY_${CVE_LANG}"
CVE_2019_14821_SUMMARY="${!CVE_2019_14821_SUMMARY_LANG}"

CVE_2019_16921_FIX_SRC_URI="https://github.com/torvalds/linux/commit/df7e40425813c50cd252e6f5e348a81ef1acae56.patch"
CVE_2019_16921_FN="CVE-2019-16921-fix--linux-drivers-infiniband-rdma-hns-fix-init-resp-when-alloc-ucontext.patch"
CVE_2019_16921_SEVERITY_LANG="CVE_2019_16921_SEVERITY_${CVE_LANG}"
CVE_2019_16921_SEVERITY="${!CVE_2019_16921_SEVERITY_LANG}"
CVE_2019_16921_PM="https://github.com/torvalds/linux/commit/df7e40425813c50cd252e6f5e348a81ef1acae56"
CVE_2019_16921_SUMMARY_LANG="CVE_2019_16921_SUMMARY_${CVE_LANG}"
CVE_2019_16921_SUMMARY="${!CVE_2019_16921_SUMMARY_LANG}"

CVE_2019_16994_FIX_SRC_URI="https://github.com/torvalds/linux/commit/07f12b26e21ab359261bf75cfcb424fdc7daeb6d.patch"
CVE_2019_16994_FN="CVE-2019-16994-fix--linux-net-sit-fix-memory-leak-in-sit_init_net.patch"
CVE_2019_16994_SEVERITY_LANG="CVE_2019_16994_SEVERITY_${CVE_LANG}"
CVE_2019_16994_SEVERITY="${!CVE_2019_16994_SEVERITY_LANG}"
CVE_2019_16994_PM="https://github.com/torvalds/linux/commit/07f12b26e21ab359261bf75cfcb424fdc7daeb6d"
CVE_2019_16994_SUMMARY_LANG="CVE_2019_16994_SUMMARY_${CVE_LANG}"
CVE_2019_16994_SUMMARY="${!CVE_2019_16994_SUMMARY_LANG}"

CVE_2019_16995_FIX_SRC_URI="https://github.com/torvalds/linux/commit/6caabe7f197d3466d238f70915d65301f1716626.patch"
CVE_2019_16995_FN="CVE-2019-16995-fix--linux-net-hsr-fix-memory-leak-in-hsr_dev_finalize.patch"
CVE_2019_16995_SEVERITY_LANG="CVE_2019_16995_SEVERITY_${CVE_LANG}"
CVE_2019_16995_SEVERITY="${!CVE_2019_16995_SEVERITY_LANG}"
CVE_2019_16995_PM="https://github.com/torvalds/linux/commit/6caabe7f197d3466d238f70915d65301f1716626"
CVE_2019_16995_SUMMARY_LANG="CVE_2019_16995_SUMMARY_${CVE_LANG}"
CVE_2019_16995_SUMMARY="${!CVE_2019_16995_SUMMARY_LANG}"

CVE_2019_17052_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=0614e2b73768b502fc32a75349823356d98aae2c"
CVE_2019_17052_FN="CVE-2019-17052-fix--linux-net-ax25-enforce-CAP_NET_RAW-for-raw-sockets.patch"
CVE_2019_17052_SEVERITY_LANG="CVE_2019_17052_SEVERITY_${CVE_LANG}"
CVE_2019_17052_SEVERITY="${!CVE_2019_17052_SEVERITY_LANG}"
CVE_2019_17052_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0614e2b73768b502fc32a75349823356d98aae2c"
CVE_2019_17052_SUMMARY_LANG="CVE_2019_17052_SUMMARY_${CVE_LANG}"
CVE_2019_17052_SUMMARY="${!CVE_2019_17052_SUMMARY_LANG}"

CVE_2019_17053_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=e69dbd4619e7674c1679cba49afd9dd9ac347eef"
CVE_2019_17053_FN="CVE-2019-17053-fix--linux-net-ieee802154-enforce-CAP_NET_RAW-for-raw-sockets.patch"
CVE_2019_17053_SEVERITY_LANG="CVE_2019_17053_SEVERITY_${CVE_LANG}"
CVE_2019_17053_SEVERITY="${!CVE_2019_17053_SEVERITY_LANG}"
CVE_2019_17053_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e69dbd4619e7674c1679cba49afd9dd9ac347eef"
CVE_2019_17053_SUMMARY_LANG="CVE_2019_17053_SUMMARY_${CVE_LANG}"
CVE_2019_17053_SUMMARY="${!CVE_2019_17053_SUMMARY_LANG}"

CVE_2019_17054_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=6cc03e8aa36c51f3b26a0d21a3c4ce2809c842ac"
CVE_2019_17054_FN="CVE-2019-17054-fix--linux-net-appletalk-enforce-CAP_NET_RAW-for-raw-sockets.patch"
CVE_2019_17054_SEVERITY_LANG="CVE_2019_17054_SEVERITY_${CVE_LANG}"
CVE_2019_17054_SEVERITY="${!CVE_2019_17054_SEVERITY_LANG}"
CVE_2019_17054_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6cc03e8aa36c51f3b26a0d21a3c4ce2809c842ac"
CVE_2019_17054_SUMMARY_LANG="CVE_2019_17054_SUMMARY_${CVE_LANG}"
CVE_2019_17054_SUMMARY="${!CVE_2019_17054_SUMMARY_LANG}"

CVE_2019_17055_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=b91ee4aa2a2199ba4d4650706c272985a5a32d80"
CVE_2019_17055_FN="CVE-2019-17055-fix--linux-drivers-mISDN-enforce-CAP_NET_RAW-for-raw-sockets.patch"
CVE_2019_17055_SEVERITY_LANG="CVE_2019_17055_SEVERITY_${CVE_LANG}"
CVE_2019_17055_SEVERITY="${!CVE_2019_17055_SEVERITY_LANG}"
CVE_2019_17055_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b91ee4aa2a2199ba4d4650706c272985a5a32d80"
CVE_2019_17055_SUMMARY_LANG="CVE_2019_17055_SUMMARY_${CVE_LANG}"
CVE_2019_17055_SUMMARY="${!CVE_2019_17055_SUMMARY_LANG}"

CVE_2019_17056_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=3a359798b176183ef09efb7a3dc59abad1cc7104"
CVE_2019_17056_FN="CVE-2019-17056-fix--linux-net-nfc-enforce-CAP_NET_RAW-for-raw-sockets.patch"
CVE_2019_17056_SEVERITY_LANG="CVE_2019_17056_SEVERITY_${CVE_LANG}"
CVE_2019_17056_SEVERITY="${!CVE_2019_17056_SEVERITY_LANG}"
CVE_2019_17056_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a359798b176183ef09efb7a3dc59abad1cc7104"
CVE_2019_17056_SUMMARY_LANG="CVE_2019_17056_SUMMARY_${CVE_LANG}"
CVE_2019_17056_SUMMARY="${!CVE_2019_17056_SUMMARY_LANG}"

CVE_2019_17075_FIX_SRC_URI="https://lore.kernel.org/lkml/20191001165611.GA3542072@kroah.com/raw"
CVE_2019_17075_FN="CVE-2019-17075-fix--linux-drivers-infiniband-PATCH-v2-cxgb4-do-not-dma-memory-off-of-the-stack.patch"
CVE_2019_17075_FN_4_9="CVE-2019-17075-fix--linux-drivers-infiniband-PATCH-v2-cxgb4-do-not-dma-memory-off-of-the-stack-for-4.9.182.patch"
CVE_2019_17075_SEVERITY_LANG="CVE_2019_17075_SEVERITY_${CVE_LANG}"
CVE_2019_17075_SEVERITY="${!CVE_2019_17075_SEVERITY_LANG}"
CVE_2019_17075_PM="https://lore.kernel.org/lkml/20191001165611.GA3542072@kroah.com/"
CVE_2019_17075_SUMMARY_LANG="CVE_2019_17075_SUMMARY_${CVE_LANG}"
CVE_2019_17075_SUMMARY="${!CVE_2019_17075_SUMMARY_LANG}"

CVE_2019_17133_FIX_SRC_URI="https://marc.info/?l=linux-wireless&m=157018270915487&q=mbox"
CVE_2019_17133_FN="CVE-2019-17133-fix--linux-net-wireless-wext-sme-cfg80211-wext-Reject-malformed-SSID-elements.patch"
CVE_2019_17133_SEVERITY_LANG="CVE_2019_17133_SEVERITY_${CVE_LANG}"
CVE_2019_17133_SEVERITY="${!CVE_2019_17133_SEVERITY_LANG}"
CVE_2019_17133_PM="https://marc.info/?l=linux-wireless&m=157018270915487&w=2"
CVE_2019_17133_SUMMARY_LANG="CVE_2019_17133_SUMMARY_${CVE_LANG}"
CVE_2019_17133_SUMMARY="${!CVE_2019_17133_SUMMARY_LANG}"

CVE_2019_17351_FIX_SRC_URI="https://github.com/torvalds/linux/commit/6ef36ab967c71690ebe7e5ef997a8be4da3bc844.patch"
CVE_2019_17351_FN="CVE-2019-17351-fix--linux-drivers-xen-let-alloc_xenballooned_pages-fail-if-not-enough-memory-free.patch"
CVE_2019_17351_SEVERITY_LANG="CVE_2019_17351_SEVERITY_${CVE_LANG}"
CVE_2019_17351_SEVERITY="${!CVE_2019_17351_SEVERITY_LANG}"
CVE_2019_17351_PM="https://github.com/torvalds/linux/commit/6ef36ab967c71690ebe7e5ef997a8be4da3bc844"
CVE_2019_17351_SUMMARY_LANG="CVE_2019_17351_SUMMARY_${CVE_LANG}"
CVE_2019_17351_SUMMARY="${!CVE_2019_17351_SUMMARY_LANG}"

CVE_2019_17666_FIX_SRC_URI="https://lkml.org/lkml/diff/2019/10/16/1226/1"
CVE_2019_17666_FN="CVE-2019-17666-fix--linux-drivers-net-wireless-realtek-rtlwifi-Fix-potential-overflow-on-P2P-code.patch"
CVE_2019_17666_SEVERITY_LANG="CVE_2019_17666_SEVERITY_${CVE_LANG}"
CVE_2019_17666_SEVERITY="${!CVE_2019_17666_SEVERITY_LANG}"
CVE_2019_17666_PM="https://lkml.org/lkml/2019/10/16/1226"
CVE_2019_17666_SUMMARY_LANG="CVE_2019_17666_SUMMARY_${CVE_LANG}"
CVE_2019_17666_SUMMARY="${!CVE_2019_17666_SUMMARY_LANG}"

CVE_2019_18198_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=ca7a03c4175366a92cee0ccc4fec0038c3266e26"
CVE_2019_18198_FN="CVE-2019-18198-fix--linux-net-ipv6-do-not-free-rt-if-FIB_LOOKUP_NOREF-is-set-on-suppress-rule.patch"
CVE_2019_18198_SEVERITY_LANG="CVE_2019_18198_SEVERITY_${CVE_LANG}"
CVE_2019_18198_SEVERITY="${!CVE_2019_18198_SEVERITY_LANG}"
CVE_2019_18198_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca7a03c4175366a92cee0ccc4fec0038c3266e26"
CVE_2019_18198_SUMMARY_LANG="CVE_2019_18198_SUMMARY_${CVE_LANG}"
CVE_2019_18198_SUMMARY="${!CVE_2019_18198_SUMMARY_LANG}"

CVE_2019_18680_FIX_SRC_URI="https://github.com/torvalds/linux/commit/91573ae4aed0a49660abdad4d42f2a0db995ee5e.patch"
CVE_2019_18680_FN="CVE-2019-18680-fix--linux-net-rds-tcp-Fix-NULL-ptr-use-in-rds_tcp_kill_sock.patch"
CVE_2019_18680_SEVERITY_LANG="CVE_2019_18680_SEVERITY_${CVE_LANG}"
CVE_2019_18680_SEVERITY="${!CVE_2019_18680_SEVERITY_LANG}"
CVE_2019_18680_PM="https://github.com/torvalds/linux/commit/91573ae4aed0a49660abdad4d42f2a0db995ee5e"
CVE_2019_18680_SUMMARY_LANG="CVE_2019_18680_SUMMARY_${CVE_LANG}"
CVE_2019_18680_SUMMARY="${!CVE_2019_18680_SUMMARY_LANG}"

CVE_2019_18683_FIX_SRC_URI="https://lore.kernel.org/lkml/20191103221719.27118-1-alex.popov@linux.com/raw"
CVE_2019_18683_FN="CVE-2019-18683-fix--linux-drivers-media-platform-vivid-Fix-wrong-locking-that-causes-race-conditions-on-streaming-stop.patch"
CVE_2019_18683_SEVERITY_LANG="CVE_2019_18683_SEVERITY_${CVE_LANG}"
CVE_2019_18683_SEVERITY="${!CVE_2019_18683_SEVERITY_LANG}"
CVE_2019_18683_PM="https://lore.kernel.org/lkml/20191103221719.27118-1-alex.popov@linux.com/"
CVE_2019_18683_SUMMARY_LANG="CVE_2019_18683_SUMMARY_${CVE_LANG}"
CVE_2019_18683_SUMMARY="${!CVE_2019_18683_SUMMARY_LANG}"

CVE_2019_18786_FIX_SRC_URI="https://patchwork.linuxtv.org/patch/59542/mbox/"
CVE_2019_18786_FN="CVE-2019-18786-fix--linux-drivers-media-platform-rcar_drif-media-rcar_drif-fix-a-memory-disclosure.patch"
CVE_2019_18786_SEVERITY_LANG="CVE_2019_18786_SEVERITY_${CVE_LANG}"
CVE_2019_18786_SEVERITY="${!CVE_2019_18786_SEVERITY_LANG}"
CVE_2019_18786_PM="https://patchwork.linuxtv.org/patch/59542/"
CVE_2019_18786_SUMMARY_LANG="CVE_2019_18786_SUMMARY_${CVE_LANG}"
CVE_2019_18786_SUMMARY="${!CVE_2019_18786_SUMMARY_LANG}"

CVE_2019_18805_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=19fad20d15a6494f47f85d869f00b11343ee5c78"
CVE_2019_18805_FN="CVE-2019-18805-fix--linux-net-ipv4-sysctl_net_ipv4-set-the-tcp_min_rtt_wlen-range-from-0-to-one-day.patch"
CVE_2019_18805_SEVERITY_LANG="CVE_2019_18805_SEVERITY_${CVE_LANG}"
CVE_2019_18805_SEVERITY="${!CVE_2019_18805_SEVERITY_LANG}"
CVE_2019_18805_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=19fad20d15a6494f47f85d869f00b11343ee5c78"
CVE_2019_18805_SUMMARY_LANG="CVE_2019_18805_SUMMARY_${CVE_LANG}"
CVE_2019_18805_SUMMARY="${!CVE_2019_18805_SUMMARY_LANG}"

CVE_2019_18806_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=1acb8f2a7a9f10543868ddd737e37424d5c36cf4"
CVE_2019_18806_FN="CVE-2019-18806-fix--linux-drivers-net-ethernet-qlogic-qla3xxx-Fixmemory-leak-in-ql_alloc_large_buffers.patch"
CVE_2019_18806_SEVERITY_LANG="CVE_2019_18806_SEVERITY_${CVE_LANG}"
CVE_2019_18806_SEVERITY="${!CVE_2019_18806_SEVERITY_LANG}"
CVE_2019_18806_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1acb8f2a7a9f10543868ddd737e37424d5c36cf4"
CVE_2019_18806_SUMMARY_LANG="CVE_2019_18806_SUMMARY_${CVE_LANG}"
CVE_2019_18806_SUMMARY="${!CVE_2019_18806_SUMMARY_LANG}"

CVE_2019_18807_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=68501df92d116b760777a2cfda314789f926476f"
CVE_2019_18807_FN="CVE-2019-18807-fix--linux-drivers-net-dsa-sja1105-sja1105_spi-Prevent-leaking-memory.patch"
CVE_2019_18807_SEVERITY_LANG="CVE_2019_18807_SEVERITY_${CVE_LANG}"
CVE_2019_18807_SEVERITY="${!CVE_2019_18807_SEVERITY_LANG}"
CVE_2019_18807_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=68501df92d116b760777a2cfda314789f926476f"
CVE_2019_18807_SUMMARY_LANG="CVE_2019_18807_SUMMARY_${CVE_LANG}"
CVE_2019_18807_SUMMARY="${!CVE_2019_18807_SUMMARY_LANG}"

CVE_2019_18808_FIX_SRC_URI="https://github.com/torvalds/linux/commit/128c66429247add5128c03dc1e144ca56f05a4e2.patch"
CVE_2019_18808_FN="CVE-2019-18808-fix--linux-drivers-crypto-ccp-Release-all-allocated-memory-if-sha-type-is-invalid.patch"
CVE_2019_18808_SEVERITY_LANG="CVE_2019_18808_SEVERITY_${CVE_LANG}"
CVE_2019_18808_SEVERITY="${!CVE_2019_18808_SEVERITY_LANG}"
CVE_2019_18808_PM="https://github.com/torvalds/linux/commit/128c66429247add5128c03dc1e144ca56f05a4e2"
CVE_2019_18808_SUMMARY_LANG="CVE_2019_18808_SUMMARY_${CVE_LANG}"
CVE_2019_18808_SUMMARY="${!CVE_2019_18808_SUMMARY_LANG}"

CVE_2019_18809_FIX_SRC_URI="https://github.com/torvalds/linux/commit/2289adbfa559050d2a38bcd9caac1c18b800e928.patch"
CVE_2019_18809_FN="CVE-2019-18809-fix--linux-drivers-media-usb-dvb-usb-af9005-fix-memory-leak-in-af9005_identify_state.patch"
CVE_2019_18809_SEVERITY_LANG="CVE_2019_18809_SEVERITY_${CVE_LANG}"
CVE_2019_18809_SEVERITY="${!CVE_2019_18809_SEVERITY_LANG}"
CVE_2019_18809_PM="https://github.com/torvalds/linux/commit/2289adbfa559050d2a38bcd9caac1c18b800e928"
CVE_2019_18809_SUMMARY_LANG="CVE_2019_18809_SUMMARY_${CVE_LANG}"
CVE_2019_18809_SUMMARY="${!CVE_2019_18809_SUMMARY_LANG}"

CVE_2019_18810_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=a0ecd6fdbf5d648123a7315c695fb6850d702835"
CVE_2019_18810_FN="CVE-2019-18810-fix--linux-drivers-gpu-drm-arm-display-komeda-komeda_wb_connector-prevent-memory-leak-in-komeda_wb_connector_add.patch"
CVE_2019_18810_SEVERITY_LANG="CVE_2019_18810_SEVERITY_${CVE_LANG}"
CVE_2019_18810_SEVERITY="${!CVE_2019_18810_SEVERITY_LANG}"
CVE_2019_18810_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0ecd6fdbf5d648123a7315c695fb6850d702835"
CVE_2019_18810_SUMMARY_LANG="CVE_2019_18810_SUMMARY_${CVE_LANG}"
CVE_2019_18810_SUMMARY="${!CVE_2019_18810_SUMMARY_LANG}"

CVE_2019_18811_FIX_SRC_URI="https://github.com/torvalds/linux/commit/45c1380358b12bf2d1db20a5874e9544f56b34ab.patch"
CVE_2019_18811_FN="CVE-2019-18811-fix--linux-sound-soc-sof-ipc-Fix-memory-leak-in-sof_set_get_large_ctrl_data.patch"
CVE_2019_18811_SEVERITY_LANG="CVE_2019_18811_SEVERITY_${CVE_LANG}"
CVE_2019_18811_SEVERITY="${!CVE_2019_18811_SEVERITY_LANG}"
CVE_2019_18811_PM="https://github.com/torvalds/linux/commit/45c1380358b12bf2d1db20a5874e9544f56b34ab"
CVE_2019_18811_SUMMARY_LANG="CVE_2019_18811_SUMMARY_${CVE_LANG}"
CVE_2019_18811_SUMMARY="${!CVE_2019_18811_SUMMARY_LANG}"

CVE_2019_18812_FIX_SRC_URI="https://github.com/torvalds/linux/commit/c0a333d842ef67ac04adc72ff79dc1ccc3dca4ed.patch"
CVE_2019_18812_FN="CVE-2019-18812-fix--linux-sound-soc-sof-debug-Fix-memory-leak-in-sof_dfsentry_write.patch"
CVE_2019_18812_FN_FILESDIR="CVE-2019-18812-fix--linux-sound-soc-sof-debug-Fix-memory-leak-in-sof_dfsentry_write-for-5.3.4.patch"
CVE_2019_18812_SEVERITY_LANG="CVE_2019_18812_SEVERITY_${CVE_LANG}"
CVE_2019_18812_SEVERITY="${!CVE_2019_18812_SEVERITY_LANG}"
CVE_2019_18812_PM="https://github.com/torvalds/linux/commit/c0a333d842ef67ac04adc72ff79dc1ccc3dca4ed"
CVE_2019_18812_SUMMARY_LANG="CVE_2019_18812_SUMMARY_${CVE_LANG}"
CVE_2019_18812_SUMMARY="${!CVE_2019_18812_SUMMARY_LANG}"

CVE_2019_18813_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=9bbfceea12a8f145097a27d7c7267af25893c060"
CVE_2019_18813_FN="CVE-2019-18813-fix--linux-drivers-usb-dwc3-dwc3-pci-prevent-memory-leak-in-dwc3_pci_probe.patch"
CVE_2019_18813_SEVERITY_LANG="CVE_2019_18813_SEVERITY_${CVE_LANG}"
CVE_2019_18813_SEVERITY="${!CVE_2019_18813_SEVERITY_LANG}"
CVE_2019_18813_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9bbfceea12a8f145097a27d7c7267af25893c060"
CVE_2019_18813_SUMMARY_LANG="CVE_2019_18813_SUMMARY_${CVE_LANG}"
CVE_2019_18813_SUMMARY="${!CVE_2019_18813_SUMMARY_LANG}"

CVE_2019_18814_FIX_SRC_URI="https://lore.kernel.org/patchwork/patch/1142523/mbox/"
CVE_2019_18814_FN="CVE-2019-18814-fix--linux-security-apparmor-audit-Fix-use-after-free-in-aa_audit_rule_init-v3.patch"
CVE_2019_18814_SEVERITY_LANG="CVE_2019_18814_SEVERITY_${CVE_LANG}"
CVE_2019_18814_SEVERITY="${!CVE_2019_18814_SEVERITY_LANG}"
CVE_2019_18814_PM="https://lore.kernel.org/patchwork/patch/1142523/"
CVE_2019_18814_SUMMARY_LANG="CVE_2019_18814_SUMMARY_${CVE_LANG}"
CVE_2019_18814_SUMMARY="${!CVE_2019_18814_SUMMARY_LANG}"


#			 ${CVE_2007_3732_FIX_SRC_URI} -> ${CVE_2007_3732_FN}



SRC_URI+=" cve_hotfix? ( ${CVE_2010_2243_FIX_SRC_URI} -> ${CVE_2010_2243_FN}
			 ${CVE_2014_3180_FIX_SRC_URI} -> ${CVE_2014_3180_FN}
			 ${CVE_2019_16746_FIX_SRC_URI} -> ${CVE_2019_16746_FN}
			 ${CVE_2019_14814_FIX_SRC_URI} -> ${CVE_2019_14814_FN}
			 ${CVE_2019_14821_FIX_SRC_URI} -> ${CVE_2019_14821_FN}
			 ${CVE_2019_16921_FIX_SRC_URI} -> ${CVE_2019_16921_FN}
			 ${CVE_2019_16994_FIX_SRC_URI} -> ${CVE_2019_16994_FN}
			 ${CVE_2019_16995_FIX_SRC_URI} -> ${CVE_2019_16995_FN}

			 ${CVE_2019_17052_FIX_SRC_URI} -> ${CVE_2019_17052_FN}
			 ${CVE_2019_17053_FIX_SRC_URI} -> ${CVE_2019_17053_FN}
			 ${CVE_2019_17054_FIX_SRC_URI} -> ${CVE_2019_17054_FN}
			 ${CVE_2019_17055_FIX_SRC_URI} -> ${CVE_2019_17055_FN}
			 ${CVE_2019_17056_FIX_SRC_URI} -> ${CVE_2019_17056_FN}

			 ${CVE_2019_17075_FIX_SRC_URI} -> ${CVE_2019_17075_FN}
			 ${CVE_2019_17133_FIX_SRC_URI} -> ${CVE_2019_17133_FN}
			 ${CVE_2019_17351_FIX_SRC_URI} -> ${CVE_2019_17351_FN}

			 ${CVE_2019_17666_FIX_SRC_URI} -> ${CVE_2019_17666_FN}
			 ${CVE_2019_18198_FIX_SRC_URI} -> ${CVE_2019_18198_FN}

			 ${CVE_2019_18680_FIX_SRC_URI} -> ${CVE_2019_18680_FN}
			 ${CVE_2019_18683_FIX_SRC_URI} -> ${CVE_2019_18683_FN}
			 ${CVE_2019_18786_FIX_SRC_URI} -> ${CVE_2019_18786_FN}

			 ${CVE_2019_18805_FIX_SRC_URI} -> ${CVE_2019_18805_FN}
			 ${CVE_2019_18806_FIX_SRC_URI} -> ${CVE_2019_18806_FN}
			 ${CVE_2019_18807_FIX_SRC_URI} -> ${CVE_2019_18807_FN}
			 ${CVE_2019_18808_FIX_SRC_URI} -> ${CVE_2019_18808_FN}
			 ${CVE_2019_18809_FIX_SRC_URI} -> ${CVE_2019_18809_FN}
			 ${CVE_2019_18810_FIX_SRC_URI} -> ${CVE_2019_18810_FN}
			 ${CVE_2019_18811_FIX_SRC_URI} -> ${CVE_2019_18811_FN}
			 ${CVE_2019_18812_FIX_SRC_URI} -> ${CVE_2019_18812_FN}
			 ${CVE_2019_18813_FIX_SRC_URI} -> ${CVE_2019_18813_FN}
			 ${CVE_2019_18814_FIX_SRC_URI} -> ${CVE_2019_18814_FN}
)"

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
	ewarn \
"${CVE_ID}\n\
Severity: ${!cve_severity}\n\
Synopsis: ${!summary}\n\
NIST NVD URI: ${NIST_NVD_CVE_M}\n\
MITRE URI: ${MITRE_M}\n\
Patch download: ${PS}\n\
Patch message: ${!pm}"
	ewarn
}

# @FUNCTION: _fetch_cve_boilerplate_msg_footer
# @DESCRIPTION:
# Message to report action to user to fix the CVE.
function _fetch_cve_boilerplate_msg_footer() {
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_fn="${CVE_ID_}FN"
	if ! test -n "${!cve_fn}" ; then
		einfo \
"No de-facto patch exists or the patch is undergoing code review.  No patch\n\
will be applied.  This fix is still being worked on."
	elif use cve_hotfix && test -n "${!cve_fn}"; then
		einfo "A ${CVE_ID} fix will be applied."
	else
		ewarn \
"Re-enable the cve_hotfix USE flag to fix this, or you may ignore this and\n\
wait for an official fix in later kernel point releases."
		ewarn
		echo -e "\07" # ring the bell
		[[ "${CVE_DELAY}" == "1" ]] && sleep 30s
	fi
}

# @FUNCTION: fetch_cve_2007_3732_hotfix
# @DESCRIPTION:
# Checks for the CVE_2007_3732 patch
function fetch_cve_2007_3732_hotfix() {
	if ver_test ${PV} -ge 2.6.23 ; then
		return 0
	fi
	if ver_test ${PV} -lt 2.6 ; then
		return 0
	fi
	# todo
	return 0
	local CVE_ID="CVE-2007-3732"
	if grep -F -e \
		"" \
		"${S}/" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2010_2243_hotfix
# @DESCRIPTION:
# Checks for the CVE_2010_2243 patch
function fetch_cve_2010_2243_hotfix() {
	if ver_test ${PV} -ge 2.6.33 ; then
		return 0
	fi
	local CVE_ID="CVE-2010-2243"
	if grep -F -e \
		"curr_clocksource = clocksource_default_clock();" \
		"${S}/kernel/time/clocksource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2014_3180_hotfix
# @DESCRIPTION:
# Checks for the CVE_2014_3180 patch
function fetch_cve_2014_3180_hotfix() {
	if ver_test ${PV} -ge 3.17 ; then
		return 0
	fi
	local CVE_ID="CVE-2014-3180"
	if grep -F -e \
		"if (ret == -ERESTART_RESTARTBLOCK) {" \
		"${S}/kernel/compat.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_16746_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_16746 patch
function fetch_cve_2019_16746_hotfix() {
	local CVE_ID="CVE-2019-16746"
	if grep -F -e \
		"validate_beacon_head" \
		"${S}/net/wireless/nl80211.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_14814_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-14814 patch
function fetch_cve_2019_14814_hotfix() {
	local CVE_ID="CVE-2019-14814"
	if grep -F -e \
		"if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >" \
		"${S}/drivers/net/wireless/marvell/mwifiex/ie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_14821_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-14821 patch
function fetch_cve_2019_14821_hotfix() {
	local CVE_ID="CVE-2019-14821"
	if grep -F -e \
		"if (!coalesced_mmio_has_room(dev, insert) ||" \
		"${S}/virt/kvm/coalesced_mmio.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_16921_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-16921 patch
function fetch_cve_2019_16921_hotfix() {
	local CVE_ID="CVE-2019-16921"
	if grep -F -e \
		"struct hns_roce_ib_alloc_ucontext_resp resp = {};" \
		"${S}/drivers/infiniband/hw/hns/hns_roce_main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}


# @FUNCTION: fetch_cve_2019_16994_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-16994 patch
function fetch_cve_2019_16994_hotfix() {
	local CVE_ID="CVE-2019-16994"
	if grep -F -e \
		"free_netdev(sitn->fb_tunnel_dev);" \
		"${S}/net/ipv6/sit.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_16995_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-16995 patch
function fetch_cve_2019_16995_hotfix() {
	local CVE_ID="CVE-2019-16995"
	if grep -F -e \
		"goto err_add_port;" \
		"${S}/net/hsr/hsr_device.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17052_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17052 patch
function fetch_cve_2019_17052_hotfix() {
	local CVE_ID="CVE-2019-17052"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/ax25/af_ax25.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17053_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17053 patch
function fetch_cve_2019_17053_hotfix() {
	local CVE_ID="CVE-2019-17053"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/ieee802154/socket.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17054_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17054 patch
function fetch_cve_2019_17054_hotfix() {
	local CVE_ID="CVE-2019-17054"
	if grep -F -e \
		"if (sock->type == SOCK_RAW && !kern && !capable(CAP_NET_RAW))" \
		"${S}/net/appletalk/ddp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17055_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17055 patch
function fetch_cve_2019_17055_hotfix() {
	local CVE_ID="CVE-2019-17055"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/drivers/isdn/mISDN/socket.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17056_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17056 patch
function fetch_cve_2019_17056_hotfix() {
	local CVE_ID="CVE-2019-17056"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/nfc/llcp_sock.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17075_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17075 patch
function fetch_cve_2019_17075_hotfix() {
	local CVE_ID="CVE-2019-17075"
	if grep -F -e \
		"tpt->valid_to_pdid = cpu_to_be32(FW_RI_TPTE_VALID_F |" \
		"${S}/drivers/infiniband/hw/cxgb4/mem.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17133_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17133 patch
function fetch_cve_2019_17133_hotfix() {
	local CVE_ID="CVE-2019-17133"
	if grep -F -e \
		"if (data->length > IW_ESSID_MAX_SIZE)" \
		"${S}/net/wireless/wext-sme.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17351_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17351 patch
function fetch_cve_2019_17351_hotfix() {
	local CVE_ID="CVE-2019-17351"
	if grep -F -e \
		"balloon_stats.max_retry_count = 4;" \
		"${S}/drivers/xen/balloon.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_17666_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-17666 patch
function fetch_cve_2019_17666_hotfix() {
	local CVE_ID="CVE-2019-17666"
	if grep -F -e \
		"if (noa_num > P2P_MAX_NOA_NUM) {" \
		"${S}/drivers/net/wireless/realtek/rtlwifi/ps.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18198_hotfix
# @DESCRIPTION:
# Checks for the CVE-2019-18198 patch
function fetch_cve_2019_18198_hotfix() {
	local CVE_ID="CVE-2019-18198"
	if grep -F -e \
		"if (!(arg->flags & FIB_LOOKUP_NOREF))" \
		"${S}/net/ipv6/fib6_rules.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18680_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18680 patch
function fetch_cve_2019_18680_hotfix() {
	local CVE_ID="CVE-2019-18680"

	if ! grep -F -e \
		"sk->sk_prot->disconnect(sk, 0);" \
		"${S}/net/rds/tcp.c" \
		>/dev/null ; \
	then
		return 0
	fi

	if grep -F -e \
		"if (tc->t_sock) {" \
		"${S}/net/rds/tcp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18683_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18683 patch
function fetch_cve_2019_18683_hotfix() {
	local CVE_ID="CVE-2019-18683"
	if grep -F -e \
		"schedule_timeout_uninterruptible(1);" \
		"${S}/drivers/media/platform/vivid/vivid-sdr-cap.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18786_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18786 patch
function fetch_cve_2019_18786_hotfix() {
	local CVE_ID="CVE-2019-18786"
	if grep -F -e \
		"memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));" \
		"${S}/drivers/media/platform/rcar_drif.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18805_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18805 patch
function fetch_cve_2019_18805_hotfix() {
	local CVE_ID="CVE-2019-18805"
	if grep -F -e \
		".extra2		= &one_day_secs" \
		"${S}/net/ipv4/sysctl_net_ipv4.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18806_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18806 patch
function fetch_cve_2019_18806_hotfix() {
	local CVE_ID="CVE-2019-18806"
	if grep -F -e \
		"dev_kfree_skb_irq(skb);" \
		"${S}/drivers/net/ethernet/qlogic/qla3xxx.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18807_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18807 patch
function fetch_cve_2019_18807_hotfix() {
	local CVE_ID="CVE-2019-18807"
	if grep -F -e \
		"rc = -ENXIO;" \
		"${S}/drivers/net/dsa/sja1105/sja1105_spi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18808_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18808 patch
function fetch_cve_2019_18808_hotfix() {
	local CVE_ID="CVE-2019-18808"
	if pcregrep -M "kfree\(hmac_buf\);\n\t\t\tret = -EINVAL;" \
		"${S}/drivers/crypto/ccp/ccp-ops.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18809_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18809 patch
function fetch_cve_2019_18809_hotfix() {
	local CVE_ID="CVE-2019-18809"
	if pcregrep -M "if \(\!ret\)\n\t\tdeb_info\(\"Identify state cold = %d\\\\n\", \*cold\);" \
		"${S}/drivers/media/usb/dvb-usb/af9005.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18810_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18810 patch
function fetch_cve_2019_18810_hotfix() {
	local CVE_ID="CVE-2019-18810"
	if grep -F -e \
		"if (err) {" \
		"${S}/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18811_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18811 patch
function fetch_cve_2019_18811_hotfix() {
	local CVE_ID="CVE-2019-18811"
	if pcregrep -M "if \(err < 0\) {\n\t\tkfree\(partdata\);" \
		"${S}/sound/soc/sof/ipc.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18812_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18812 patch
function fetch_cve_2019_18812_hotfix() {
	local CVE_ID="CVE-2019-18812"
	if grep -F -e \
		'strcmp(dentry->d_name.name, "ipc_flood_duration_ms")) {' \
		"${S}/sound/soc/sof/debug.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	if grep -F -e \
		'strcmp(dfse->dfsentry->d_name.name, "ipc_flood_duration_ms")) {' \
		"${S}/sound/soc/sof/debug.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18813_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18813 patch
function fetch_cve_2019_18813_hotfix() {
	local CVE_ID="CVE-2019-18813"
	if pcregrep -M "if \(ret < 0\)\n\t\tgoto err;" \
		"${S}/drivers/usb/dwc3/dwc3-pci.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_18814_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18814 patch
function fetch_cve_2019_18814_hotfix() {
	local CVE_ID="CVE-2019-18814"
	if grep -F -e \
		"int err = PTR_ERR(rule->label);" \
		"${S}/security/apparmor/audit.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: _resolve_hotfix_default
# @DESCRIPTION:
# Applies the fix or warns if not applied
function _resolve_hotfix_default() {
	if use cve_hotfix ; then
		if [ -e "${DISTDIR}/${!cve_fn}" ] ; then
			einfo \
"Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${DISTDIR}/${!cve_fn}"
		else
			ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: _resolve_hotfix_default_filesdir
# @DESCRIPTION:
# Applies the fix or warns if not applied
function _resolve_hotfix_default_filesdir() {
	if use cve_hotfix ; then
		if [ -e "${FILESDIR}/${!cve_fn_filesdir}" ] ; then
			einfo \
"Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${FILESDIR}/${!cve_fn_filesdir}"
		else
			ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: apply_cve_2007_3732_hotfix
# @DESCRIPTION:
# Applies the CVE_2007_3732 patch if it needs to
function apply_cve_2007_3732_hotfix() {
	local CVE_ID="CVE-2007-3732"
	if ver_test ${PV} -ge 2.6.23 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	if ver_test ${PV} -lt 2.6 ; then
		return 0
	fi
	# todo
	return 0
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"" \
		"${S}/" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2010_2243_hotfix
# @DESCRIPTION:
# Applies the CVE_2010_2243 patch if it needs to
function apply_cve_2010_2243_hotfix() {
	local CVE_ID="CVE-2010-2243"
	if ver_test ${PV} -ge 2.6.33 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"curr_clocksource = clocksource_default_clock();" \
		"${S}/kernel/time/clocksource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


# @FUNCTION: apply_cve_2014_3180_hotfix
# @DESCRIPTION:
# Applies the CVE_2014_3180 patch if it needs to
function apply_cve_2014_3180_hotfix() {
	local CVE_ID="CVE-2014-3180"
	if ver_test ${PV} -ge 3.17 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (ret == -ERESTART_RESTARTBLOCK) {" \
		"${S}/kernel/compat.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_16746_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16746 patch if it needs to
function apply_cve_2019_16746_hotfix() {
	local CVE_ID="CVE-2019-16746"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"validate_beacon_head" \
		"${S}/net/wireless/nl80211.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_14814_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_14814 patch if it needs to
function apply_cve_2019_14814_hotfix() {
	local CVE_ID="CVE-2019-14814"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >" \
		"${S}/drivers/net/wireless/marvell/mwifiex/ie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_14821_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_14821 patch if it needs to
function apply_cve_2019_14821_hotfix() {
	local CVE_ID="CVE-2019-14821"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"

	if ver_test ${PV} -le 4.20 ; then
		cve_fn="${CVE_ID_}FN_4_9"
	fi

	if grep -F -e \
		"if (!coalesced_mmio_has_room(dev, insert) ||" \
		"${S}/virt/kvm/coalesced_mmio.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_16921_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16921 patch if it needs to
function apply_cve_2019_16921_hotfix() {
	local CVE_ID="CVE-2019-16921"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"struct hns_roce_ib_alloc_ucontext_resp resp = {};" \
		"${S}/drivers/infiniband/hw/hns/hns_roce_main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_16994_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16994 patch if it needs to
function apply_cve_2019_16994_hotfix() {
	local CVE_ID="CVE-2019-16994"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"free_netdev(sitn->fb_tunnel_dev);" \
		"${S}/net/ipv6/sit.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


# @FUNCTION: apply_cve_2019_16995_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_16995 patch if it needs to
function apply_cve_2019_16995_hotfix() {
	local CVE_ID="CVE-2019-16995"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"goto err_add_port;" \
		"${S}/net/hsr/hsr_device.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17052_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17052 patch if it needs to
function apply_cve_2019_17052_hotfix() {
	local CVE_ID="CVE-2019-17052"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/ax25/af_ax25.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17053_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17053 patch if it needs to
function apply_cve_2019_17053_hotfix() {
	local CVE_ID="CVE-2019-17053"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/ieee802154/socket.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17054_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17054 patch if it needs to
function apply_cve_2019_17054_hotfix() {
	local CVE_ID="CVE-2019-17054"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (sock->type == SOCK_RAW && !kern && !capable(CAP_NET_RAW))"\
		"${S}/net/appletalk/ddp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17055_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17055 patch if it needs to
function apply_cve_2019_17055_hotfix() {
	local CVE_ID="CVE-2019-17055"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/drivers/isdn/mISDN/socket.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17056_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17056 patch if it needs to
function apply_cve_2019_17056_hotfix() {
	local CVE_ID="CVE-2019-17056"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!capable(CAP_NET_RAW))" \
		"${S}/net/nfc/llcp_sock.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17075_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17075 patch if it needs to
function apply_cve_2019_17075_hotfix() {
	local CVE_ID="CVE-2019-17075"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if ver_test ${PV} -le 4.9.197 ; then
		cve_fn="${CVE_ID_}FN_4_9"
	fi
	if ver_test ${PV} -e 4.14.150 ; then
		ewarn "todo testing ${cve_fn}"
	fi
	if grep -F -e \
		"tpt->valid_to_pdid = cpu_to_be32(FW_RI_TPTE_VALID_F |" \
		"${S}/drivers/infiniband/hw/cxgb4/mem.c" \
		>/dev/null ; \
		then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17133_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17133 patch if it needs to
function apply_cve_2019_17133_hotfix() {
	local CVE_ID="CVE-2019-17133"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (data->length > IW_ESSID_MAX_SIZE)" \
		"${S}/net/wireless/wext-sme.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_17351_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17351 patch if it needs to
function apply_cve_2019_17351_hotfix() {
	local CVE_ID="CVE-2019-17351"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"balloon_stats.max_retry_count = 4;" \
		"${S}/drivers/xen/balloon.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


# @FUNCTION: apply_cve_2019_17666_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_17666 patch if it needs to
function apply_cve_2019_17666_hotfix() {
	local CVE_ID="CVE-2019-17666"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (noa_num > P2P_MAX_NOA_NUM) {" \
		"${S}/drivers/net/wireless/realtek/rtlwifi/ps.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18198_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18198 patch if it needs to
function apply_cve_2019_18198_hotfix() {
	local CVE_ID="CVE-2019-18198"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!(arg->flags & FIB_LOOKUP_NOREF))" \
		"${S}/net/ipv6/fib6_rules.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18680_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18680 patch if it needs to
function apply_cve_2019_18680_hotfix() {
	local CVE_ID="CVE-2019-18680"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (tc->t_sock) {" \
		"${S}/net/rds/tcp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	if ! grep -F -e \
		"sk->sk_prot->disconnect(sk, 0);" \
		"${S}/net/rds/tcp.c" \
		>/dev/null ; \
	then
		einfo \
"Did not find ${CVE_ID} flaw.  Skipping"
		return 0
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18683_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18683 patch if it needs to
function apply_cve_2019_18683_hotfix() {
	local CVE_ID="CVE-2019-18683"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"schedule_timeout_uninterruptible(1);" \
		"${S}/drivers/media/platform/vivid/vivid-sdr-cap.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18786_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18786 patch if it needs to
function apply_cve_2019_18786_hotfix() {
	local CVE_ID="CVE-2019-18786"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));" \
		"${S}/drivers/media/platform/rcar_drif.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18805_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18805 patch if it needs to
function apply_cve_2019_18805_hotfix() {
	local CVE_ID="CVE-2019-18805"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		".extra2		= &one_day_secs" \
		"${S}/net/ipv4/sysctl_net_ipv4.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18806_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18806 patch if it needs to
function apply_cve_2019_18806_hotfix() {
	local CVE_ID="CVE-2019-18806"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"dev_kfree_skb_irq(skb);" \
		"${S}/drivers/net/ethernet/qlogic/qla3xxx.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18807_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18807 patch if it needs to
function apply_cve_2019_18807_hotfix() {
	local CVE_ID="CVE-2019-18807"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"rc = -ENXIO;" \
		"${S}/drivers/net/dsa/sja1105/sja1105_spi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18808_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18808 patch if it needs to
function apply_cve_2019_18808_hotfix() {
	local CVE_ID="CVE-2019-18808"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "kfree\(hmac_buf\);\n\t\t\tret = -EINVAL;" \
		"${S}/drivers/crypto/ccp/ccp-ops.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18809_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18809 patch if it needs to
function apply_cve_2019_18809_hotfix() {
	local CVE_ID="CVE-2019-18809"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(\!ret\)\n\t\tdeb_info\(\"Identify state cold = %d\\\\n\", \*cold\);" \
		"${S}/drivers/media/usb/dvb-usb/af9005.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18810_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18810 patch if it needs to
function apply_cve_2019_18810_hotfix() {
	local CVE_ID="CVE-2019-18810"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (err) {" \
		"${S}/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18811_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18811 patch if it needs to
function apply_cve_2019_18811_hotfix() {
	local CVE_ID="CVE-2019-18811"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(err < 0\) {\n\t\tkfree\(partdata\);" \
		"${S}/sound/soc/sof/ipc.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18812_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18812 patch if it needs to
function apply_cve_2019_18812_hotfix() {
	local CVE_ID="CVE-2019-18812"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	local cve_fn_filesdir="${CVE_ID_}FN_FILESDIR"

	if grep -F -e \
		'strcmp(dentry->d_name.name, "ipc_flood_duration_ms"))' \
		"${S}/sound/soc/sof/debug.c" \
		>/dev/null ; \
	then
		_resolve_hotfix_default
		return
	fi

	if grep -F -e \
		'strcmp(dfse->dfsentry->d_name.name, "ipc_flood_duration_ms"))' \
		"${S}/sound/soc/sof/debug.c" \
		>/dev/null ; \
	then
		_resolve_hotfix_default_filesdir
		return
	fi

	if use cve_hotfix ; then
		if [[ ! -e "${DISTDIR}/${!cve_fn}"  ||
		      ! -e "${FILESDIR}/${!cve_fn_filesdir}" ]] ; then
			ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
		fi
	else
		ewarn \
"No ${CVE_ID} fixes applied.  This is a ${!cve_severity} risk vulnerability."
	fi
}

# @FUNCTION: apply_cve_2019_18813_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18813 patch if it needs to
function apply_cve_2019_18813_hotfix() {
	local CVE_ID="CVE-2019-18813"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(ret < 0\)\n\t\tgoto err;" \
		"${S}/drivers/usb/dwc3/dwc3-pci.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_18814_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18814 patch if it needs to
function apply_cve_2019_18814_hotfix() {
	local CVE_ID="CVE-2019-18814"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"int err = PTR_ERR(rule->label);" \
		"${S}/security/apparmor/audit.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


# @FUNCTION: fetch_cve_hotfixes
# @DESCRIPTION:
# Fetches all the CVE kernel patches
function fetch_cve_hotfixes() {
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		einfo
		einfo "--------------------------------------------------"
		einfo

		fetch_cve_2014_3180_hotfix

#		fetch_cve_2007_3732_hotfix
		fetch_cve_2010_2243_hotfix

		fetch_cve_2019_16746_hotfix
		fetch_cve_2019_14814_hotfix
		fetch_cve_2019_14821_hotfix
		fetch_cve_2019_16921_hotfix
		fetch_cve_2019_16994_hotfix
		fetch_cve_2019_16995_hotfix
		fetch_cve_2019_17052_hotfix
		fetch_cve_2019_17053_hotfix
		fetch_cve_2019_17054_hotfix
		fetch_cve_2019_17055_hotfix
		fetch_cve_2019_17056_hotfix
		fetch_cve_2019_17075_hotfix
		fetch_cve_2019_17133_hotfix
		fetch_cve_2019_17351_hotfix
		fetch_cve_2019_17666_hotfix
		fetch_cve_2019_18198_hotfix
		fetch_cve_2019_18680_hotfix
		fetch_cve_2019_18683_hotfix
		fetch_cve_2019_18786_hotfix

		fetch_cve_2019_18805_hotfix
		fetch_cve_2019_18806_hotfix
		fetch_cve_2019_18807_hotfix
		fetch_cve_2019_18808_hotfix
		fetch_cve_2019_18809_hotfix
		fetch_cve_2019_18810_hotfix
		fetch_cve_2019_18811_hotfix
		fetch_cve_2019_18812_hotfix
		fetch_cve_2019_18813_hotfix
		fetch_cve_2019_18814_hotfix

		local cve_copyright1="CVE_COPYRIGHT1_${CVE_LANG}"
		local cve_copyright2="CVE_COPYRIGHT2_${CVE_LANG}"
		einfo \
"\n\
${!cve_copyright1}\n\
${!cve_copyright2}\n\
\n\
--------------------------------------------------\n\
\n\
You may set CVE_SUBSCRIBE_KERNEL_HOTFIXES=1 in your make.conf to get CVE\n\
hotfix updates.\n\
\n"
		[[ "${CVE_DELAY}" == "1" ]] && sleep 10s
	fi
}

# @FUNCTION: apply_cve_hotfixes
# @DESCRIPTION:
# Applies all the CVE kernel patches
function apply_cve_hotfixes() {
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		einfo "Applying CVE hotfixes"
		apply_cve_2014_3180_hotfix

#		apply_cve_2007_3732_hotfix
		apply_cve_2010_2243_hotfix

		apply_cve_2019_16746_hotfix
		apply_cve_2019_14814_hotfix
		apply_cve_2019_14821_hotfix
		apply_cve_2019_16921_hotfix
		apply_cve_2019_16994_hotfix
		apply_cve_2019_16995_hotfix
		apply_cve_2019_17052_hotfix
		apply_cve_2019_17053_hotfix
		apply_cve_2019_17054_hotfix
		apply_cve_2019_17055_hotfix
		apply_cve_2019_17056_hotfix
		apply_cve_2019_17075_hotfix
		apply_cve_2019_17133_hotfix
		apply_cve_2019_17351_hotfix
		apply_cve_2019_17666_hotfix
		apply_cve_2019_18198_hotfix
		apply_cve_2019_18680_hotfix
		apply_cve_2019_18683_hotfix
		apply_cve_2019_18786_hotfix

		apply_cve_2019_18805_hotfix
		apply_cve_2019_18806_hotfix
		apply_cve_2019_18807_hotfix
		apply_cve_2019_18808_hotfix
		apply_cve_2019_18809_hotfix
		apply_cve_2019_18810_hotfix
		apply_cve_2019_18811_hotfix
		apply_cve_2019_18812_hotfix
		apply_cve_2019_18813_hotfix
		apply_cve_2019_18814_hotfix
	fi
}
