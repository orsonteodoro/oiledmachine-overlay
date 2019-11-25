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
LATEST_CVE_KERNEL_INDEX="20191125_0305_AM_UTC"
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

CVE_2007_3732_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=a10d9a71bafd3a283da240d2868e71346d2aef6f"
CVE_2007_3732_FN="CVE-2007-3732-fix--linux-arch-i386-fixup-TRACE_IRQ-breakage.patch"
CVE_2007_3732_SEVERITY_LANG="CVE_2007_3732_SEVERITY_${CVE_LANG}"
CVE_2007_3732_SEVERITY="${!CVE_2007_3732_SEVERITY_LANG}"
CVE_2007_3732_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a10d9a71bafd3a283da240d2868e71346d2aef6f"
CVE_2007_3732_SUMMARY_LANG="CVE_2007_3732_SUMMARY_${CVE_LANG}"
CVE_2007_3732_SUMMARY="${!CVE_2007_3732_SUMMARY_LANG}"

CVE_2010_2243_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=ad6759fbf35d104dbf573cd6f4c6784ad6823f7e"
CVE_2010_2243_FN="CVE-2010-2243-fix--linux-kernel-time-clocksource-timekeeping-Prevent-oops-when-GENERIC_TIME-is-n.patch"
CVE_2010_2243_SEVERITY_LANG="CVE_2010_2243_SEVERITY_${CVE_LANG}"
CVE_2010_2243_SEVERITY="${!CVE_2010_2243_SEVERITY_LANG}"
CVE_2010_2243_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ad6759fbf35d104dbf573cd6f4c6784ad6823f7e"
CVE_2010_2243_SUMMARY_LANG="CVE_2010_2243_SUMMARY_${CVE_LANG}"
CVE_2010_2243_SUMMARY="${!CVE_2010_2243_SUMMARY_LANG}"

CVE_2010_4661_FIX_SRC_URI=""
CVE_2010_4661_SEVERITY_LANG="CVE_2010_4661_SEVERITY_${CVE_LANG}"
CVE_2010_4661_SEVERITY="${!CVE_2010_4661_SEVERITY_LANG}"
CVE_2010_4661_PM=""
CVE_2010_4661_SUMMARY_LANG="CVE_2010_4661_SUMMARY_${CVE_LANG}"
CVE_2010_4661_SUMMARY="${!CVE_2010_4661_SUMMARY_LANG}"

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
CVE_2019_17075_FN_4_9="CVE-2019-17075-fix--linux-drivers-infiniband-PATCH-v2-cxgb4-do-not-dma-memory-off-of-the-stack-for-4.9.x.patch"
CVE_2019_17075_FN_4_14="CVE-2019-17075-fix--linux-drivers-infiniband-PATCH-v2-cxgb4-do-not-dma-memory-off-of-the-stack-for-4.14.x.patch"
CVE_2019_17075_FIX_SRC_URI_4_9="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/?id=84f5b67df81a9f333afa81855f6fa3fdcd954463"
CVE_2019_17075_FIX_SRC_URI_4_14="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/?id=1db19d6805d9dc5c79f8a19dddde324dbf0a33f9"
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

CVE_2019_18885_FIX_SRC_URI="https://github.com/torvalds/linux/commit/09ba3bc9dd150457c506e4661380a6183af651c1.patch"
CVE_2019_18885_FN="CVE-2019-18885-fix--linux-fs-btrfs-merge-btrfs_find_device-and-find_device.patch"
CVE_2019_18885_SEVERITY_LANG="CVE_2019_18885_SEVERITY_${CVE_LANG}"
CVE_2019_18885_SEVERITY="${!CVE_2019_18885_SEVERITY_LANG}"
CVE_2019_18885_PM="https://github.com/torvalds/linux/commit/09ba3bc9dd150457c506e4661380a6183af651c1"
CVE_2019_18885_SUMMARY_LANG="CVE_2019_18885_SUMMARY_${CVE_LANG}"
CVE_2019_18885_SUMMARY="${!CVE_2019_18885_SUMMARY_LANG}"



CVE_2019_19036_FIX_SRC_URI=""
CVE_2019_19036_FN="CVE-2019-19036-fix--linux-.patch"
CVE_2019_19036_SEVERITY_LANG="CVE_2019_19036_SEVERITY_${CVE_LANG}"
CVE_2019_19036_SEVERITY="${!CVE_2019_19036_SEVERITY_LANG}"
CVE_2019_19036_PM=""
CVE_2019_19036_SUMMARY_LANG="CVE_2019_19036_SUMMARY_${CVE_LANG}"
CVE_2019_19036_SUMMARY="${!CVE_2019_19036_SUMMARY_LANG}"

CVE_2019_19037_FIX_SRC_URI=""
CVE_2019_19037_FN="CVE-2019-19037-fix--linux-.patch"
CVE_2019_19037_SEVERITY_LANG="CVE_2019_19037_SEVERITY_${CVE_LANG}"
CVE_2019_19037_SEVERITY="${!CVE_2019_19037_SEVERITY_LANG}"
CVE_2019_19037_PM=""
CVE_2019_19037_SUMMARY_LANG="CVE_2019_19037_SUMMARY_${CVE_LANG}"
CVE_2019_19037_SUMMARY="${!CVE_2019_19037_SUMMARY_LANG}"

CVE_2019_19039_FIX_SRC_URI=""
CVE_2019_19039_FN="CVE-2019-19039-fix--linux-.patch"
CVE_2019_19039_SEVERITY_LANG="CVE_2019_19039_SEVERITY_${CVE_LANG}"
CVE_2019_19039_SEVERITY="${!CVE_2019_19039_SEVERITY_LANG}"
CVE_2019_19039_PM=""
CVE_2019_19039_SUMMARY_LANG="CVE_2019_19039_SUMMARY_${CVE_LANG}"
CVE_2019_19039_SUMMARY="${!CVE_2019_19039_SUMMARY_LANG}"



CVE_2019_19043_FIX_SRC_URI="https://github.com/torvalds/linux/commit/27d461333459d282ffa4a2bdb6b215a59d493a8f.patch"
CVE_2019_19043_FN="CVE-2019-19043-fix--linux-drivers-net-ethernet-intel-i40e-i40e_main-prevent-memory-leak-in-i40e_setup_macvlans.patch"
CVE_2019_19043_SEVERITY_LANG="CVE_2019_19043_SEVERITY_${CVE_LANG}"
CVE_2019_19043_SEVERITY="${!CVE_2019_19043_SEVERITY_LANG}"
CVE_2019_19043_PM="https://github.com/torvalds/linux/commit/27d461333459d282ffa4a2bdb6b215a59d493a8f"
CVE_2019_19043_SUMMARY_LANG="CVE_2019_19043_SUMMARY_${CVE_LANG}"
CVE_2019_19043_SUMMARY="${!CVE_2019_19043_SUMMARY_LANG}"

CVE_2019_19044_FIX_SRC_URI="https://github.com/torvalds/linux/commit/29cd13cfd7624726d9e6becbae9aa419ef35af7f.patch"
CVE_2019_19044_FN="CVE-2019-19044-fix--linux-drivers-gpu-drm-v3d-Fix-memory-leak-in-v3d_submit_cl_ioctl.patch"
CVE_2019_19044_SEVERITY_LANG="CVE_2019_19044_SEVERITY_${CVE_LANG}"
CVE_2019_19044_SEVERITY="${!CVE_2019_19044_SEVERITY_LANG}"
CVE_2019_19044_PM="https://github.com/torvalds/linux/commit/29cd13cfd7624726d9e6becbae9aa419ef35af7f"
CVE_2019_19044_SUMMARY_LANG="CVE_2019_19044_SUMMARY_${CVE_LANG}"
CVE_2019_19044_SUMMARY="${!CVE_2019_19044_SUMMARY_LANG}"

CVE_2019_19045_FIX_SRC_URI="https://github.com/torvalds/linux/commit/c8c2a057fdc7de1cd16f4baa51425b932a42eb39.patch"
CVE_2019_19045_FN="CVE-2019-19045-fix--linux-drivers-net-ethernet-mellanox-mlx5-core-fpga-prevent-memory-leak-in-mlx5_fpga_conn_create_cq.patch"
CVE_2019_19045_SEVERITY_LANG="CVE_2019_19045_SEVERITY_${CVE_LANG}"
CVE_2019_19045_SEVERITY="${!CVE_2019_19045_SEVERITY_LANG}"
CVE_2019_19045_PM="https://github.com/torvalds/linux/commit/c8c2a057fdc7de1cd16f4baa51425b932a42eb39"
CVE_2019_19045_SUMMARY_LANG="CVE_2019_19045_SUMMARY_${CVE_LANG}"
CVE_2019_19045_SUMMARY="${!CVE_2019_19045_SUMMARY_LANG}"

CVE_2019_19046_FIX_SRC_URI="https://github.com/torvalds/linux/commit/4aa7afb0ee20a97fbf0c5bab3df028d5fb85fdab.patch"
CVE_2019_19046_FN="CVE-2019-19046-fix--linux-drivers-char-ipmi-Fix-memory-leak-in-__ipmi_bmc_register.patch"
CVE_2019_19046_SEVERITY_LANG="CVE_2019_19046_SEVERITY_${CVE_LANG}"
CVE_2019_19046_SEVERITY="${!CVE_2019_19046_SEVERITY_LANG}"
CVE_2019_19046_PM="https://github.com/torvalds/linux/commit/4aa7afb0ee20a97fbf0c5bab3df028d5fb85fdab"
CVE_2019_19046_SUMMARY_LANG="CVE_2019_19046_SUMMARY_${CVE_LANG}"
CVE_2019_19046_SUMMARY="${!CVE_2019_19046_SUMMARY_LANG}"

CVE_2019_19047_FIX_SRC_URI="https://github.com/torvalds/linux/commit/c7ed6d0183d5ea9bc31bcaeeba4070bd62546471.patch"
CVE_2019_19047_FN="CVE-2019-19047-fix--linux-drivers-net-ethernet-mellanox-mlx5-core-health-fix-memory-leak-in-mlx5_fw_fatal_reporter_dump.patch"
CVE_2019_19047_SEVERITY_LANG="CVE_2019_19047_SEVERITY_${CVE_LANG}"
CVE_2019_19047_SEVERITY="${!CVE_2019_19047_SEVERITY_LANG}"
CVE_2019_19047_PM="https://github.com/torvalds/linux/commit/c7ed6d0183d5ea9bc31bcaeeba4070bd62546471"
CVE_2019_19047_SUMMARY_LANG="CVE_2019_19047_SUMMARY_${CVE_LANG}"
CVE_2019_19047_SUMMARY="${!CVE_2019_19047_SUMMARY_LANG}"

CVE_2019_19048_FIX_SRC_URI="https://github.com/torvalds/linux/commit/e0b0cb9388642c104838fac100a4af32745621e2.patch"
CVE_2019_19048_FN="CVE-2019-19048-fix--linux-drivers-virt-vboxguest-vboxguest_utils-fix-memory-leak-in-hgcm_call_preprocess_linaddr.patch"
CVE_2019_19048_SEVERITY_LANG="CVE_2019_19048_SEVERITY_${CVE_LANG}"
CVE_2019_19048_SEVERITY="${!CVE_2019_19048_SEVERITY_LANG}"
CVE_2019_19048_PM="https://github.com/torvalds/linux/commit/e0b0cb9388642c104838fac100a4af32745621e2"
CVE_2019_19048_SUMMARY_LANG="CVE_2019_19048_SUMMARY_${CVE_LANG}"
CVE_2019_19048_SUMMARY="${!CVE_2019_19048_SUMMARY_LANG}"

CVE_2019_19049_FIX_SRC_URI="https://github.com/torvalds/linux/commit/e13de8fe0d6a51341671bbe384826d527afe8d44.patch"
CVE_2019_19049_FN="CVE-2019-19049-fix--linux-drivers-of-unittest-fix-memory-leak-in-unittest_data_add.patch"
CVE_2019_19049_SEVERITY_LANG="CVE_2019_19049_SEVERITY_${CVE_LANG}"
CVE_2019_19049_SEVERITY="${!CVE_2019_19049_SEVERITY_LANG}"
CVE_2019_19049_PM="https://github.com/torvalds/linux/commit/e13de8fe0d6a51341671bbe384826d527afe8d44"
CVE_2019_19049_SUMMARY_LANG="CVE_2019_19049_SUMMARY_${CVE_LANG}"
CVE_2019_19049_SUMMARY="${!CVE_2019_19049_SUMMARY_LANG}"


CVE_2019_19050_FIX_SRC_URI="https://github.com/torvalds/linux/commit/c03b04dcdba1da39903e23cc4d072abf8f68f2dd.patch"
CVE_2019_19050_FN="CVE-2019-19050-fix--linux-crypto-crypto_user_stat-fix-memory-leak-in-crypto_reportstat.patch"
CVE_2019_19050_SEVERITY_LANG="CVE_2019_19050_SEVERITY_${CVE_LANG}"
CVE_2019_19050_SEVERITY="${!CVE_2019_19050_SEVERITY_LANG}"
CVE_2019_19050_PM="https://github.com/torvalds/linux/commit/c03b04dcdba1da39903e23cc4d072abf8f68f2dd"
CVE_2019_19050_SUMMARY_LANG="CVE_2019_19050_SUMMARY_${CVE_LANG}"
CVE_2019_19050_SUMMARY="${!CVE_2019_19050_SUMMARY_LANG}"

CVE_2019_19051_FIX_SRC_URI="https://github.com/torvalds/linux/commit/6f3ef5c25cc762687a7341c18cbea5af54461407.patch"
CVE_2019_19051_FN="CVE-2019-19051-fix--linux-drivers-net-wimax-i2400m-op-rfkill-Fix-memory-leak-in-i2400m_op_rfkill_sw_toggle.patch"
CVE_2019_19051_SEVERITY_LANG="CVE_2019_19051_SEVERITY_${CVE_LANG}"
CVE_2019_19051_SEVERITY="${!CVE_2019_19051_SEVERITY_LANG}"
CVE_2019_19051_PM="https://github.com/torvalds/linux/commit/6f3ef5c25cc762687a7341c18cbea5af54461407"
CVE_2019_19051_SUMMARY_LANG="CVE_2019_19051_SUMMARY_${CVE_LANG}"
CVE_2019_19051_SUMMARY="${!CVE_2019_19051_SUMMARY_LANG}"

CVE_2019_19052_FIX_SRC_URI="https://github.com/torvalds/linux/commit/fb5be6a7b4863ecc44963bb80ca614584b6c7817.patch"
CVE_2019_19052_FN="CVE-2019-19052-fix--linux-drivers-net-can-usb-gs_usb-gs_can_open-function-prevent-memory-leak.patch"
CVE_2019_19052_SEVERITY_LANG="CVE_2019_19052_SEVERITY_${CVE_LANG}"
CVE_2019_19052_SEVERITY="${!CVE_2019_19052_SEVERITY_LANG}"
CVE_2019_19052_PM="https://github.com/torvalds/linux/commit/fb5be6a7b4863ecc44963bb80ca614584b6c7817"
CVE_2019_19052_SUMMARY_LANG="CVE_2019_19052_SUMMARY_${CVE_LANG}"
CVE_2019_19052_SUMMARY="${!CVE_2019_19052_SUMMARY_LANG}"

CVE_2019_19053_FIX_SRC_URI="https://github.com/torvalds/linux/commit/bbe692e349e2a1edf3fe0a29a0e05899c9c94d51.patch"
CVE_2019_19053_FN="CVE-2019-19053-fix--linux-drivers-rpmsg-rpmsg_char-release-allocated-memory.patch"
CVE_2019_19053_SEVERITY_LANG="CVE_2019_19053_SEVERITY_${CVE_LANG}"
CVE_2019_19053_SEVERITY="${!CVE_2019_19053_SEVERITY_LANG}"
CVE_2019_19053_PM="https://github.com/torvalds/linux/commit/bbe692e349e2a1edf3fe0a29a0e05899c9c94d51"
CVE_2019_19053_SUMMARY_LANG="CVE_2019_19053_SUMMARY_${CVE_LANG}"
CVE_2019_19053_SUMMARY="${!CVE_2019_19053_SUMMARY_LANG}"

CVE_2019_19054_FIX_SRC_URI="https://github.com/torvalds/linux/commit/a7b2df76b42bdd026e3106cf2ba97db41345a177.patch"
CVE_2019_19054_FN="CVE-2019-19054-fix--linux-drivers-media-pci-cx23885-cx23888-ir-prevent-memory-leak-in-cx23888_ir_probe.patch"
CVE_2019_19054_SEVERITY_LANG="CVE_2019_19054_SEVERITY_${CVE_LANG}"
CVE_2019_19054_SEVERITY="${!CVE_2019_19054_SEVERITY_LANG}"
CVE_2019_19054_PM="https://github.com/torvalds/linux/commit/a7b2df76b42bdd026e3106cf2ba97db41345a177"
CVE_2019_19054_SUMMARY_LANG="CVE_2019_19054_SUMMARY_${CVE_LANG}"
CVE_2019_19054_SUMMARY="${!CVE_2019_19054_SUMMARY_LANG}"

CVE_2019_19055_FIX_SRC_URI="https://github.com/torvalds/linux/commit/1399c59fa92984836db90538cf92397fe7caaa57.patch"
CVE_2019_19055_FN="CVE-2019-19055-fix--linux-net-wireless-nl80211-fix-memory-leak-in-nl80211_get_ftm_responder_stats.patch"
CVE_2019_19055_SEVERITY_LANG="CVE_2019_19055_SEVERITY_${CVE_LANG}"
CVE_2019_19055_SEVERITY="${!CVE_2019_19055_SEVERITY_LANG}"
CVE_2019_19055_PM="https://github.com/torvalds/linux/commit/1399c59fa92984836db90538cf92397fe7caaa57"
CVE_2019_19055_SUMMARY_LANG="CVE_2019_19055_SUMMARY_${CVE_LANG}"
CVE_2019_19055_SUMMARY="${!CVE_2019_19055_SUMMARY_LANG}"

CVE_2019_19056_FIX_SRC_URI="https://github.com/torvalds/linux/commit/db8fd2cde93227e566a412cf53173ffa227998bc.patch"
CVE_2019_19056_FN="CVE-2019-19056-fix--linux-drivers-net-wireless-marvell-mwifiex-pcie-Fix-memory-leak-in-mwifiex_pcie_alloc_cmdrsp_buf.patch"
CVE_2019_19056_SEVERITY_LANG="CVE_2019_19056_SEVERITY_${CVE_LANG}"
CVE_2019_19056_SEVERITY="${!CVE_2019_19056_SEVERITY_LANG}"
CVE_2019_19056_PM="https://github.com/torvalds/linux/commit/db8fd2cde93227e566a412cf53173ffa227998bc"
CVE_2019_19056_SUMMARY_LANG="CVE_2019_19056_SUMMARY_${CVE_LANG}"
CVE_2019_19056_SUMMARY="${!CVE_2019_19056_SUMMARY_LANG}"

CVE_2019_19057_FIX_SRC_URI="https://github.com/torvalds/linux/commit/d10dcb615c8e29d403a24d35f8310a7a53e3050c.patch"
CVE_2019_19057_FN="CVE-2019-19057-fix--linux-drivers-net-wireless-marvell-mwifiex-pcie-Fix-memory-leak-in-mwifiex_pcie_init_evt_ring.patch"
CVE_2019_19057_SEVERITY_LANG="CVE_2019_19057_SEVERITY_${CVE_LANG}"
CVE_2019_19057_SEVERITY="${!CVE_2019_19057_SEVERITY_LANG}"
CVE_2019_19057_PM="https://github.com/torvalds/linux/commit/d10dcb615c8e29d403a24d35f8310a7a53e3050c"
CVE_2019_19057_SUMMARY_LANG="CVE_2019_19057_SUMMARY_${CVE_LANG}"
CVE_2019_19057_SUMMARY="${!CVE_2019_19057_SUMMARY_LANG}"

CVE_2019_19058_FIX_SRC_URI="https://github.com/torvalds/linux/commit/b4b814fec1a5a849383f7b3886b654a13abbda7d.patch"
CVE_2019_19058_FN="CVE-2019-19058-fix--linux-drivers-net-wireless-intel-iwlwifi-fw-dbg-fix-memory-leak-in-alloc_sgtable.patch"
CVE_2019_19058_SEVERITY_LANG="CVE_2019_19058_SEVERITY_${CVE_LANG}"
CVE_2019_19058_SEVERITY="${!CVE_2019_19058_SEVERITY_LANG}"
CVE_2019_19058_PM="https://github.com/torvalds/linux/commit/b4b814fec1a5a849383f7b3886b654a13abbda7d"
CVE_2019_19058_SUMMARY_LANG="CVE_2019_19058_SUMMARY_${CVE_LANG}"
CVE_2019_19058_SUMMARY="${!CVE_2019_19058_SUMMARY_LANG}"

CVE_2019_19059_FIX_SRC_URI="https://github.com/torvalds/linux/commit/0f4f199443faca715523b0659aa536251d8b978f.patch"
CVE_2019_19059_FN="CVE-2019-19059-fix--linux-drivers-net-wireless-intel-iwlwifi-pcie-ctxt-info-gen3-fix-memory-leaks-in-iwl_pcie_ctxt_info_gen3_init.patch"
CVE_2019_19059_SEVERITY_LANG="CVE_2019_19059_SEVERITY_${CVE_LANG}"
CVE_2019_19059_SEVERITY="${!CVE_2019_19059_SEVERITY_LANG}"
CVE_2019_19059_PM="https://github.com/torvalds/linux/commit/0f4f199443faca715523b0659aa536251d8b978f"
CVE_2019_19059_SUMMARY_LANG="CVE_2019_19059_SUMMARY_${CVE_LANG}"
CVE_2019_19059_SUMMARY="${!CVE_2019_19059_SUMMARY_LANG}"


CVE_2019_19060_FIX_SRC_URI="https://github.com/torvalds/linux/commit/ab612b1daf415b62c58e130cb3d0f30b255a14d0.patch"
CVE_2019_19060_FN="CVE-2019-19060-fix--linux-drivers-iio-imu-adis_buffer-adis16400-release-allocated-memory-on-failure.patch"
CVE_2019_19060_SEVERITY_LANG="CVE_2019_19060_SEVERITY_${CVE_LANG}"
CVE_2019_19060_SEVERITY="${!CVE_2019_19060_SEVERITY_LANG}"
CVE_2019_19060_PM="https://github.com/torvalds/linux/commit/ab612b1daf415b62c58e130cb3d0f30b255a14d0"
CVE_2019_19060_SUMMARY_LANG="CVE_2019_19060_SUMMARY_${CVE_LANG}"
CVE_2019_19060_SUMMARY="${!CVE_2019_19060_SUMMARY_LANG}"

CVE_2019_19061_FIX_SRC_URI="https://github.com/torvalds/linux/commit/9c0530e898f384c5d279bfcebd8bb17af1105873.patch"
CVE_2019_19061_FN="CVE-2019-19061-fix--linux-drivers-iio-imu-adis_buffer-adis16400-fix-memory-leak.patch"
CVE_2019_19061_SEVERITY_LANG="CVE_2019_19061_SEVERITY_${CVE_LANG}"
CVE_2019_19061_SEVERITY="${!CVE_2019_19061_SEVERITY_LANG}"
CVE_2019_19061_PM="https://github.com/torvalds/linux/commit/9c0530e898f384c5d279bfcebd8bb17af1105873"
CVE_2019_19061_SUMMARY_LANG="CVE_2019_19061_SUMMARY_${CVE_LANG}"
CVE_2019_19061_SUMMARY="${!CVE_2019_19061_SUMMARY_LANG}"

CVE_2019_19062_FIX_SRC_URI="https://github.com/torvalds/linux/commit/ffdde5932042600c6807d46c1550b28b0db6a3bc.patch"
CVE_2019_19062_FN="CVE-2019-19062-fix--linux-crypto-crypto_user_base-fix-memory-leak-in-crypto_report.patch"
CVE_2019_19062_SEVERITY_LANG="CVE_2019_19062_SEVERITY_${CVE_LANG}"
CVE_2019_19062_SEVERITY="${!CVE_2019_19062_SEVERITY_LANG}"
CVE_2019_19062_PM="https://github.com/torvalds/linux/commit/ffdde5932042600c6807d46c1550b28b0db6a3bc"
CVE_2019_19062_SUMMARY_LANG="CVE_2019_19062_SUMMARY_${CVE_LANG}"
CVE_2019_19062_SUMMARY="${!CVE_2019_19062_SUMMARY_LANG}"

CVE_2019_19063_FIX_SRC_URI="https://github.com/torvalds/linux/commit/3f93616951138a598d930dcaec40f2bfd9ce43bb.patch"
CVE_2019_19063_FN="CVE-2019-19063-fix--linux-drivers-net-wireless-realtek-rtlwifi-usb-prevent-memory-leak-in-rtl_usb_probe.patch"
CVE_2019_19063_SEVERITY_LANG="CVE_2019_19063_SEVERITY_${CVE_LANG}"
CVE_2019_19063_SEVERITY="${!CVE_2019_19063_SEVERITY_LANG}"
CVE_2019_19063_PM="https://github.com/torvalds/linux/commit/3f93616951138a598d930dcaec40f2bfd9ce43bb"
CVE_2019_19063_SUMMARY_LANG="CVE_2019_19063_SUMMARY_${CVE_LANG}"
CVE_2019_19063_SUMMARY="${!CVE_2019_19063_SUMMARY_LANG}"

CVE_2019_19064_FIX_SRC_URI="https://github.com/torvalds/linux/commit/057b8945f78f76d0b04eeb5c27cd9225e5e7ad86.patch"
CVE_2019_19064_FN="CVE-2019-19064-fix--linux-drivers-spi-spi-fsl-lpspi-fix-memory-leak-in-fsl_lpspi_probe.patch"
CVE_2019_19064_SEVERITY_LANG="CVE_2019_19064_SEVERITY_${CVE_LANG}"
CVE_2019_19064_SEVERITY="${!CVE_2019_19064_SEVERITY_LANG}"
CVE_2019_19064_PM="https://github.com/torvalds/linux/commit/057b8945f78f76d0b04eeb5c27cd9225e5e7ad86"
CVE_2019_19064_SUMMARY_LANG="CVE_2019_19064_SUMMARY_${CVE_LANG}"
CVE_2019_19064_SUMMARY="${!CVE_2019_19064_SUMMARY_LANG}"

CVE_2019_19065_FIX_SRC_URI="https://github.com/torvalds/linux/commit/34b3be18a04ecdc610aae4c48e5d1b799d8689f6.patch"
CVE_2019_19065_FN="CVE-2019-19065-fix--linux-drivers-infiniband-hw-hfi1-sdma-RDMA-hfi1-Prevent-memory-leak-in-sdma_init.patch"
CVE_2019_19065_SEVERITY_LANG="CVE_2019_19065_SEVERITY_${CVE_LANG}"
CVE_2019_19065_SEVERITY="${!CVE_2019_19065_SEVERITY_LANG}"
CVE_2019_19065_PM="https://github.com/torvalds/linux/commit/34b3be18a04ecdc610aae4c48e5d1b799d8689f6"
CVE_2019_19065_SUMMARY_LANG="CVE_2019_19065_SUMMARY_${CVE_LANG}"
CVE_2019_19065_SUMMARY="${!CVE_2019_19065_SUMMARY_LANG}"

CVE_2019_19066_FIX_SRC_URI="https://github.com/torvalds/linux/commit/0e62395da2bd5166d7c9e14cbc7503b256a34cb0.patch"
CVE_2019_19066_FN="CVE-2019-19066-fix--linux-drivers-scsi-bfa-bfad_attr-release-allocated-memory-in-case-of-error.patch"
CVE_2019_19066_SEVERITY_LANG="CVE_2019_19066_SEVERITY_${CVE_LANG}"
CVE_2019_19066_SEVERITY="${!CVE_2019_19066_SEVERITY_LANG}"
CVE_2019_19066_PM="https://github.com/torvalds/linux/commit/0e62395da2bd5166d7c9e14cbc7503b256a34cb0"
CVE_2019_19066_SUMMARY_LANG="CVE_2019_19066_SUMMARY_${CVE_LANG}"
CVE_2019_19066_SUMMARY="${!CVE_2019_19066_SUMMARY_LANG}"

CVE_2019_19067_FIX_SRC_URI="https://github.com/torvalds/linux/commit/57be09c6e8747bf48704136d9e3f92bfb93f5725.patch"
CVE_2019_19067_FN="CVE-2019-19067-fix--linux-drivers-gpu-drm-amd-amdgpu-amdgpu_acp-fix-multiple-memory-leaks-in-acp_hw_init.patch"
CVE_2019_19067_SEVERITY_LANG="CVE_2019_19067_SEVERITY_${CVE_LANG}"
CVE_2019_19067_SEVERITY="${!CVE_2019_19067_SEVERITY_LANG}"
CVE_2019_19067_PM="https://github.com/torvalds/linux/commit/57be09c6e8747bf48704136d9e3f92bfb93f5725"
CVE_2019_19067_SUMMARY_LANG="CVE_2019_19067_SUMMARY_${CVE_LANG}"
CVE_2019_19067_SUMMARY="${!CVE_2019_19067_SUMMARY_LANG}"

CVE_2019_19068_FIX_SRC_URI="https://github.com/torvalds/linux/commit/a2cdd07488e666aa93a49a3fc9c9b1299e27ef3c.patch"
CVE_2019_19068_FN="CVE-2019-19068-fix--linux-drivers-net-wireless-realtek-rtl8xxxu-rtl8xxxu_core-prevent-leaking-urb.patch"
CVE_2019_19068_SEVERITY_LANG="CVE_2019_19068_SEVERITY_${CVE_LANG}"
CVE_2019_19068_SEVERITY="${!CVE_2019_19068_SEVERITY_LANG}"
CVE_2019_19068_PM="https://github.com/torvalds/linux/commit/a2cdd07488e666aa93a49a3fc9c9b1299e27ef3c"
CVE_2019_19068_SUMMARY_LANG="CVE_2019_19068_SUMMARY_${CVE_LANG}"
CVE_2019_19068_SUMMARY="${!CVE_2019_19068_SUMMARY_LANG}"

CVE_2019_19069_FIX_SRC_URI="https://github.com/torvalds/linux/commit/fc739a058d99c9297ef6bfd923b809d85855b9a9.patch"
CVE_2019_19069_FN="CVE-2019-19069-fix--linux-drivers-misc-fastrpc-prevent-memory-leak-in-fastrpc_dma_buf_attach.patch"
CVE_2019_19069_SEVERITY_LANG="CVE_2019_19069_SEVERITY_${CVE_LANG}"
CVE_2019_19069_SEVERITY="${!CVE_2019_19069_SEVERITY_LANG}"
CVE_2019_19069_PM="https://github.com/torvalds/linux/commit/fc739a058d99c9297ef6bfd923b809d85855b9a9"
CVE_2019_19069_SUMMARY_LANG="CVE_2019_19069_SUMMARY_${CVE_LANG}"
CVE_2019_19069_SUMMARY="${!CVE_2019_19069_SUMMARY_LANG}"


CVE_2019_19070_FIX_SRC_URI="https://github.com/torvalds/linux/commit/d3b0ffa1d75d5305ebe34735598993afbb8a869d.patch"
CVE_2019_19070_FN="CVE-2019-19070-fix--linux-drivers-spi-spi-gpio-prevent-memory-leak-in-spi_gpio_probe.patch"
CVE_2019_19070_SEVERITY_LANG="CVE_2019_19070_SEVERITY_${CVE_LANG}"
CVE_2019_19070_SEVERITY="${!CVE_2019_19070_SEVERITY_LANG}"
CVE_2019_19070_PM="https://github.com/torvalds/linux/commit/d3b0ffa1d75d5305ebe34735598993afbb8a869d"
CVE_2019_19070_SUMMARY_LANG="CVE_2019_19070_SUMMARY_${CVE_LANG}"
CVE_2019_19070_SUMMARY="${!CVE_2019_19070_SUMMARY_LANG}"

CVE_2019_19071_FIX_SRC_URI="https://github.com/torvalds/linux/commit/d563131ef23cbc756026f839a82598c8445bc45f.patch"
CVE_2019_19071_FN="CVE-2019-19071-fix--linux-drivers-net-wireless-rsi-rsi_91x_mgmt-release-skb-if-rsi_prepare_beacon-fails.patch"
CVE_2019_19071_SEVERITY_LANG="CVE_2019_19071_SEVERITY_${CVE_LANG}"
CVE_2019_19071_SEVERITY="${!CVE_2019_19071_SEVERITY_LANG}"
CVE_2019_19071_PM="https://github.com/torvalds/linux/commit/d563131ef23cbc756026f839a82598c8445bc45f"
CVE_2019_19071_SUMMARY_LANG="CVE_2019_19071_SUMMARY_${CVE_LANG}"
CVE_2019_19071_SUMMARY="${!CVE_2019_19071_SUMMARY_LANG}"

CVE_2019_19072_FIX_SRC_URI="https://github.com/torvalds/linux/commit/96c5c6e6a5b6db592acae039fed54b5c8844cd35.patch"
CVE_2019_19072_FN="CVE-2019-19072-fix--linux-kernel-trace-trace_events_filter-tracing-Have-error-path-in-predicate_parse-function-free-its-allocated-memory.patch"
CVE_2019_19072_SEVERITY_LANG="CVE_2019_19072_SEVERITY_${CVE_LANG}"
CVE_2019_19072_SEVERITY="${!CVE_2019_19072_SEVERITY_LANG}"
CVE_2019_19072_PM="https://github.com/torvalds/linux/commit/96c5c6e6a5b6db592acae039fed54b5c8844cd35"
CVE_2019_19072_SUMMARY_LANG="CVE_2019_19072_SUMMARY_${CVE_LANG}"
CVE_2019_19072_SUMMARY="${!CVE_2019_19072_SUMMARY_LANG}"

CVE_2019_19073_FIX_SRC_URI="https://github.com/torvalds/linux/commit/853acf7caf10b828102d92d05b5c101666a6142b.patch"
CVE_2019_19073_FN="CVE-2019-19073-fix--linux-drivers-net-wireless-ath-ath9k-htc_hst-ath9k_htc-release-allocated-buffer-if-timed-out.patch"
CVE_2019_19073_SEVERITY_LANG="CVE_2019_19073_SEVERITY_${CVE_LANG}"
CVE_2019_19073_SEVERITY="${!CVE_2019_19073_SEVERITY_LANG}"
CVE_2019_19073_PM="https://github.com/torvalds/linux/commit/853acf7caf10b828102d92d05b5c101666a6142b"
CVE_2019_19073_SUMMARY_LANG="CVE_2019_19073_SUMMARY_${CVE_LANG}"
CVE_2019_19073_SUMMARY="${!CVE_2019_19073_SUMMARY_LANG}"

CVE_2019_19074_FIX_SRC_URI="https://github.com/torvalds/linux/commit/728c1e2a05e4b5fc52fab3421dce772a806612a2.patch"
CVE_2019_19074_FN="CVE-2019-19074-fix--linux-drivers-net-wireless-ath-ath9k-wmi-release-allocated-buffer-if-timed-out.patch"
CVE_2019_19074_SEVERITY_LANG="CVE_2019_19074_SEVERITY_${CVE_LANG}"
CVE_2019_19074_SEVERITY="${!CVE_2019_19074_SEVERITY_LANG}"
CVE_2019_19074_PM="https://github.com/torvalds/linux/commit/728c1e2a05e4b5fc52fab3421dce772a806612a2"
CVE_2019_19074_SUMMARY_LANG="CVE_2019_19074_SUMMARY_${CVE_LANG}"
CVE_2019_19074_SUMMARY="${!CVE_2019_19074_SUMMARY_LANG}"

CVE_2019_19075_FIX_SRC_URI="https://github.com/torvalds/linux/commit/6402939ec86eaf226c8b8ae00ed983936b164908.patch"
CVE_2019_19075_FN="CVE-2019-19075-fix--linux-drivers-net-ieee802154-ca8210-prevent-memory-leak.patch"
CVE_2019_19075_SEVERITY_LANG="CVE_2019_19075_SEVERITY_${CVE_LANG}"
CVE_2019_19075_SEVERITY="${!CVE_2019_19075_SEVERITY_LANG}"
CVE_2019_19075_PM="https://github.com/torvalds/linux/commit/6402939ec86eaf226c8b8ae00ed983936b164908"
CVE_2019_19075_SUMMARY_LANG="CVE_2019_19075_SUMMARY_${CVE_LANG}"
CVE_2019_19075_SUMMARY="${!CVE_2019_19075_SUMMARY_LANG}"

CVE_2019_19076_FIX_SRC_URI="https://github.com/torvalds/linux/commit/78beef629fd95be4ed853b2d37b832f766bd96ca.patch"
CVE_2019_19076_FN="CVE-2019-19076-fix--linux-drivers-net-ethernet-netronome-nfp-abm-cls-fix-memory-leak-in-nfp_abm_u32_knode_replace.patch"
CVE_2019_19076_SEVERITY_LANG="CVE_2019_19076_SEVERITY_${CVE_LANG}"
CVE_2019_19076_SEVERITY="${!CVE_2019_19076_SEVERITY_LANG}"
CVE_2019_19076_PM="https://github.com/torvalds/linux/commit/78beef629fd95be4ed853b2d37b832f766bd96ca"
CVE_2019_19076_SUMMARY_LANG="CVE_2019_19076_SUMMARY_${CVE_LANG}"
CVE_2019_19076_SUMMARY="${!CVE_2019_19076_SUMMARY_LANG}"

CVE_2019_19077_FIX_SRC_URI="https://github.com/torvalds/linux/commit/4a9d46a9fe14401f21df69cea97c62396d5fb053.patch"
CVE_2019_19077_FN="CVE-2019-19077-fix--linux-drivers-infiniband-hw-bnxt_re-ib_verbs-RDMA-Fix-goto-target-to-release-the-allocated-memory.patch"
CVE_2019_19077_SEVERITY_LANG="CVE_2019_19077_SEVERITY_${CVE_LANG}"
CVE_2019_19077_SEVERITY="${!CVE_2019_19077_SEVERITY_LANG}"
CVE_2019_19077_PM="https://github.com/torvalds/linux/commit/4a9d46a9fe14401f21df69cea97c62396d5fb053"
CVE_2019_19077_SUMMARY_LANG="CVE_2019_19077_SUMMARY_${CVE_LANG}"
CVE_2019_19077_SUMMARY="${!CVE_2019_19077_SUMMARY_LANG}"

CVE_2019_19078_FIX_SRC_URI="https://github.com/torvalds/linux/commit/b8d17e7d93d2beb89e4f34c59996376b8b544792.patch"
CVE_2019_19078_FN="CVE-2019-19078-fix--linux-drivers-net-wireless-ath-ath10k-usb-fix-memory-leak.patch"
CVE_2019_19078_SEVERITY_LANG="CVE_2019_19078_SEVERITY_${CVE_LANG}"
CVE_2019_19078_SEVERITY="${!CVE_2019_19078_SEVERITY_LANG}"
CVE_2019_19078_PM="https://github.com/torvalds/linux/commit/b8d17e7d93d2beb89e4f34c59996376b8b544792"
CVE_2019_19078_SUMMARY_LANG="CVE_2019_19078_SUMMARY_${CVE_LANG}"
CVE_2019_19078_SUMMARY="${!CVE_2019_19078_SUMMARY_LANG}"

CVE_2019_19079_FIX_SRC_URI="https://github.com/torvalds/linux/commit/a21b7f0cff1906a93a0130b74713b15a0b36481d.patch"
CVE_2019_19079_FN="CVE-2019-19079-fix--linux-net-qrtr-tun-fix-memort-leak-in-qrtr_tun_write_iter.patch"
CVE_2019_19079_SEVERITY_LANG="CVE_2019_19079_SEVERITY_${CVE_LANG}"
CVE_2019_19079_SEVERITY="${!CVE_2019_19079_SEVERITY_LANG}"
CVE_2019_19079_PM="https://github.com/torvalds/linux/commit/a21b7f0cff1906a93a0130b74713b15a0b36481d"
CVE_2019_19079_SUMMARY_LANG="CVE_2019_19079_SUMMARY_${CVE_LANG}"
CVE_2019_19079_SUMMARY="${!CVE_2019_19079_SUMMARY_LANG}"


CVE_2019_19080_FIX_SRC_URI="https://github.com/torvalds/linux/commit/8572cea1461a006bce1d06c0c4b0575869125fa4.patch"
CVE_2019_19080_FN="CVE-2019-19080-fix--linux-drivers-net-ethernet-netronome-nfp-flower-main-prevent-memory-leak-in-nfp_flower_spawn_phy_reprs.patch"
CVE_2019_19080_SEVERITY_LANG="CVE_2019_19080_SEVERITY_${CVE_LANG}"
CVE_2019_19080_SEVERITY="${!CVE_2019_19080_SEVERITY_LANG}"
CVE_2019_19080_PM="https://github.com/torvalds/linux/commit/8572cea1461a006bce1d06c0c4b0575869125fa4"
CVE_2019_19080_SUMMARY_LANG="CVE_2019_19080_SUMMARY_${CVE_LANG}"
CVE_2019_19080_SUMMARY="${!CVE_2019_19080_SUMMARY_LANG}"

CVE_2019_19081_FIX_SRC_URI="https://github.com/torvalds/linux/commit/8ce39eb5a67aee25d9f05b40b673c95b23502e3e.patch"
CVE_2019_19081_FN="CVE-2019-19081-fix--linux-drivers-net-ethernet-netronome-nfp-flower-fix-memory-leak-in-nfp_flower_spawn_vnic_reprs.patch"
CVE_2019_19081_SEVERITY_LANG="CVE_2019_19081_SEVERITY_${CVE_LANG}"
CVE_2019_19081_SEVERITY="${!CVE_2019_19081_SEVERITY_LANG}"
CVE_2019_19081_PM="https://github.com/torvalds/linux/commit/8ce39eb5a67aee25d9f05b40b673c95b23502e3e"
CVE_2019_19081_SUMMARY_LANG="CVE_2019_19081_SUMMARY_${CVE_LANG}"
CVE_2019_19081_SUMMARY="${!CVE_2019_19081_SUMMARY_LANG}"

CVE_2019_19082_FIX_SRC_URI="https://github.com/torvalds/linux/commit/104c307147ad379617472dd91a5bcb368d72bd6d.patch"
CVE_2019_19082_FN="CVE-2019-19082-fix--linux-drivers-gpu-drm-amd-display-dc-dce100-dce100_resource-prevent-memory-leak.patch"
CVE_2019_19082_SEVERITY_LANG="CVE_2019_19082_SEVERITY_${CVE_LANG}"
CVE_2019_19082_SEVERITY="${!CVE_2019_19082_SEVERITY_LANG}"
CVE_2019_19082_PM="https://github.com/torvalds/linux/commit/104c307147ad379617472dd91a5bcb368d72bd6d"
CVE_2019_19082_SUMMARY_LANG="CVE_2019_19082_SUMMARY_${CVE_LANG}"
CVE_2019_19082_SUMMARY="${!CVE_2019_19082_SUMMARY_LANG}"

CVE_2019_19083_FIX_SRC_URI="https://github.com/torvalds/linux/commit/055e547478a11a6360c7ce05e2afc3e366968a12.patch"
CVE_2019_19083_FN="CVE-2019-19083-fix--linux-drivers-gpu-drm-amd-display-dc-dce100-dce100_resource-memory-leak.patch"
CVE_2019_19083_SEVERITY_LANG="CVE_2019_19083_SEVERITY_${CVE_LANG}"
CVE_2019_19083_SEVERITY="${!CVE_2019_19083_SEVERITY_LANG}"
CVE_2019_19083_PM="https://github.com/torvalds/linux/commit/055e547478a11a6360c7ce05e2afc3e366968a12"
CVE_2019_19083_SUMMARY_LANG="CVE_2019_19083_SUMMARY_${CVE_LANG}"
CVE_2019_19083_SUMMARY="${!CVE_2019_19083_SUMMARY_LANG}"

CVE_2019_19227_FIX_SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=9804501fa1228048857910a6bf23e085aade37cc"
CVE_2019_19227_FN="CVE-2019-19227-fix--linux-net-appletalk-Fix-potential-NULL-pointer-dereference-in-unregister_snap_client.patch"
CVE_2019_19227_SEVERITY_LANG="CVE_2019_19227_SEVERITY_${CVE_LANG}"
CVE_2019_19227_SEVERITY="${!CVE_2019_19227_SEVERITY_LANG}"
CVE_2019_19227_PM="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9804501fa1228048857910a6bf23e085aade37cc"
CVE_2019_19227_SUMMARY_LANG="CVE_2019_19227_SUMMARY_${CVE_LANG}"
CVE_2019_19227_SUMMARY="${!CVE_2019_19227_SUMMARY_LANG}"



#			 ${CVE_2010_4661_FIX_SRC_URI} -> ${CVE_2010_4661_FN}

#			 ${CVE_2019_19036_FIX_SRC_URI} -> ${CVE_2019_19036_FN}
#			 ${CVE_2019_19037_FIX_SRC_URI} -> ${CVE_2019_19037_FN}
#			 ${CVE_2019_19039_FIX_SRC_URI} -> ${CVE_2019_19039_FN}


SRC_URI+=" cve_hotfix? ( ${CVE_2007_3732_FIX_SRC_URI} -> ${CVE_2007_3732_FN}
			 ${CVE_2010_2243_FIX_SRC_URI} -> ${CVE_2010_2243_FN}
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

			 ${CVE_2019_17075_FIX_SRC_URI_4_9} -> ${CVE_2019_17075_FN_4_9}
			 ${CVE_2019_17075_FIX_SRC_URI_4_14} -> ${CVE_2019_17075_FN_4_14}

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

			 ${CVE_2019_18885_FIX_SRC_URI} -> ${CVE_2019_18885_FN}




			 ${CVE_2019_19043_FIX_SRC_URI} -> ${CVE_2019_19043_FN}
			 ${CVE_2019_19044_FIX_SRC_URI} -> ${CVE_2019_19044_FN}
			 ${CVE_2019_19045_FIX_SRC_URI} -> ${CVE_2019_19045_FN}
			 ${CVE_2019_19046_FIX_SRC_URI} -> ${CVE_2019_19046_FN}
			 ${CVE_2019_19047_FIX_SRC_URI} -> ${CVE_2019_19047_FN}
			 ${CVE_2019_19048_FIX_SRC_URI} -> ${CVE_2019_19048_FN}
			 ${CVE_2019_19049_FIX_SRC_URI} -> ${CVE_2019_19049_FN}

			 ${CVE_2019_19050_FIX_SRC_URI} -> ${CVE_2019_19050_FN}
			 ${CVE_2019_19051_FIX_SRC_URI} -> ${CVE_2019_19051_FN}
			 ${CVE_2019_19052_FIX_SRC_URI} -> ${CVE_2019_19052_FN}
			 ${CVE_2019_19053_FIX_SRC_URI} -> ${CVE_2019_19053_FN}
			 ${CVE_2019_19054_FIX_SRC_URI} -> ${CVE_2019_19054_FN}
			 ${CVE_2019_19055_FIX_SRC_URI} -> ${CVE_2019_19055_FN}
			 ${CVE_2019_19056_FIX_SRC_URI} -> ${CVE_2019_19056_FN}
			 ${CVE_2019_19057_FIX_SRC_URI} -> ${CVE_2019_19057_FN}
			 ${CVE_2019_19058_FIX_SRC_URI} -> ${CVE_2019_19058_FN}
			 ${CVE_2019_19059_FIX_SRC_URI} -> ${CVE_2019_19059_FN}

			 ${CVE_2019_19060_FIX_SRC_URI} -> ${CVE_2019_19060_FN}
			 ${CVE_2019_19061_FIX_SRC_URI} -> ${CVE_2019_19061_FN}
			 ${CVE_2019_19062_FIX_SRC_URI} -> ${CVE_2019_19062_FN}
			 ${CVE_2019_19063_FIX_SRC_URI} -> ${CVE_2019_19063_FN}
			 ${CVE_2019_19064_FIX_SRC_URI} -> ${CVE_2019_19064_FN}
			 ${CVE_2019_19065_FIX_SRC_URI} -> ${CVE_2019_19065_FN}
			 ${CVE_2019_19066_FIX_SRC_URI} -> ${CVE_2019_19066_FN}
			 ${CVE_2019_19067_FIX_SRC_URI} -> ${CVE_2019_19067_FN}
			 ${CVE_2019_19068_FIX_SRC_URI} -> ${CVE_2019_19068_FN}
			 ${CVE_2019_19069_FIX_SRC_URI} -> ${CVE_2019_19069_FN}

			 ${CVE_2019_19070_FIX_SRC_URI} -> ${CVE_2019_19070_FN}
			 ${CVE_2019_19071_FIX_SRC_URI} -> ${CVE_2019_19071_FN}
			 ${CVE_2019_19072_FIX_SRC_URI} -> ${CVE_2019_19072_FN}
			 ${CVE_2019_19073_FIX_SRC_URI} -> ${CVE_2019_19073_FN}
			 ${CVE_2019_19074_FIX_SRC_URI} -> ${CVE_2019_19074_FN}
			 ${CVE_2019_19075_FIX_SRC_URI} -> ${CVE_2019_19075_FN}
			 ${CVE_2019_19076_FIX_SRC_URI} -> ${CVE_2019_19076_FN}
			 ${CVE_2019_19077_FIX_SRC_URI} -> ${CVE_2019_19077_FN}
			 ${CVE_2019_19078_FIX_SRC_URI} -> ${CVE_2019_19078_FN}
			 ${CVE_2019_19079_FIX_SRC_URI} -> ${CVE_2019_19079_FN}

			 ${CVE_2019_19080_FIX_SRC_URI} -> ${CVE_2019_19080_FN}
			 ${CVE_2019_19081_FIX_SRC_URI} -> ${CVE_2019_19081_FN}
			 ${CVE_2019_19082_FIX_SRC_URI} -> ${CVE_2019_19082_FN}
			 ${CVE_2019_19083_FIX_SRC_URI} -> ${CVE_2019_19083_FN}

			 ${CVE_2019_19227_FIX_SRC_URI} -> ${CVE_2019_19227_FN}
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
	local pm="${CVE_ID_}PM"

	if [[ -z "${!cve_fn}" || -z "${!pm}" ]] ; then
		eerror \
"No de-facto patch exists for ${CVE_ID} or the patch is undergoing code review.  No patch\n\
will be applied.  This fix is still being worked on."
	elif use cve_hotfix ; then
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
	local CVE_ID="CVE-2007-3732"
	if grep -F -e \
		"#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq)" \
		"${S}/arch/i386/kernel/traps.c" \
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

# @FUNCTION: fetch_cve_2010_4661_hotfix
# @DESCRIPTION:
# Checks for the CVE_2010_4661 patch
function fetch_cve_2010_4661_hotfix() {
	# fixme unpatched
	local CVE_ID="CVE-2010-4661"
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

# @FUNCTION: fetch_cve_2019_18885_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_18885 patch
function fetch_cve_2019_18885_hotfix() {
	local CVE_ID="CVE-2019-18885"
	if grep -F -e \
		"u64 devid, u8 *uuid, u8 *fsid, bool seed);" \
		"${S}/fs/btrfs/volumes.h" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: fetch_cve_2019_19036_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19036 patch
function fetch_cve_2019_19036_hotfix() {
	# fixme unpatched
	local CVE_ID="CVE-2019-19036"
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

# @FUNCTION: fetch_cve_2019_19037_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19037 patch
function fetch_cve_2019_19037_hotfix() {
	# fixme unpatched
	local CVE_ID="CVE-2019-19037"
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

# @FUNCTION: fetch_cve_2019_19039_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19039 patch
function fetch_cve_2019_19039_hotfix() {
	# fixme unpatched
	local CVE_ID="CVE-2019-19039"
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


#---

# @FUNCTION: fetch_cve_2019_19043_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19043 patch
function fetch_cve_2019_19043_hotfix() {
	local CVE_ID="CVE-2019-19043"
	if pcregrep -M "ret = -EINVAL;\n\t\t\tkfree\(ch\);" \
		"${S}/drivers/net/ethernet/intel/i40e/i40e_main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19044_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19044 patch
function fetch_cve_2019_19044_hotfix() {
	local CVE_ID="CVE-2019-19044"
	if grep -F -e \
		"if (!bin) {" \
		"${S}/drivers/gpu/drm/v3d/v3d_gem.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19045_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19045 patch
function fetch_cve_2019_19045_hotfix() {
	local CVE_ID="CVE-2019-19045"
	if pcregrep -M \
		"err = mlx5_vector2eqn\(mdev, smp_processor_id\(\), &eqn, &irqn\);\n\tif \(err\) {\n\t\tkvfree\(in\);" \
		"${S}/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19046_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19046 patch
function fetch_cve_2019_19046_hotfix() {
	local CVE_ID="CVE-2019-19046"
	if grep -F -e \
		"if (rv < 0) {" \
		"${S}/drivers/char/ipmi/ipmi_msghandler.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19047_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19047 patch
function fetch_cve_2019_19047_hotfix() {
	local CVE_ID="CVE-2019-19047"
	if pcregrep -M "err = mlx5_crdump_collect\(dev, cr_data\);\n\t\if \(err\)\n\t\tgoto free_data;" \
		"${S}/drivers/net/ethernet/mellanox/mlx5/core/health.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19048_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19048 patch
function fetch_cve_2019_19048_hotfix() {
	local CVE_ID="CVE-2019-19048"
	if pcregrep -M "if \(\!bounce_buf\)\n\t\treturn -ENOMEM;\n\n\t\*bounce_buf_ret = bounce_buf;" \
		"${S}/drivers/virt/vboxguest/vboxguest_utils.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19049_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19049 patch
function fetch_cve_2019_19049_hotfix() {
	local CVE_ID="CVE-2019-19049"
	if grep -F -e \
		"kfree(unittest_data);" \
		"${S}/drivers/of/unittest.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: fetch_cve_2019_19050_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19050 patch
function fetch_cve_2019_19050_hotfix() {
	local CVE_ID="CVE-2019-19050"
	if grep -F -e \
		"kfree_skb(skb);" \
		"${S}/crypto/crypto_user_stat.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19051_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19051 patch
function fetch_cve_2019_19051_hotfix() {
	local CVE_ID="CVE-2019-19051"
	if pcregrep -M "d_fnend\(4, dev, \"\(wimax_dev %p state %d\) = %d\\\\n\",\n\t\twimax_dev, state, result\);\n\tkfree\(cmd\);" \
		"${S}/drivers/net/wimax/i2400m/op-rfkill.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19052_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19052 patch
function fetch_cve_2019_19052_hotfix() {
	local CVE_ID="CVE-2019-19052"
	if pcregrep -M "usb_unanchor_urb\(urb\);\n\t\t\t\tusb_free_urb\(urb\);" \
		"${S}/drivers/net/can/usb/gs_usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19053_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19053 patch
function fetch_cve_2019_19053_hotfix() {
	local CVE_ID="CVE-2019-19053"
	if grep -F -e \
		"if (!copy_from_iter_full(kbuf, len, from)) {" \
		"${S}/drivers/rpmsg/rpmsg_char.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19054_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19054 patch
function fetch_cve_2019_19054_hotfix() {
	local CVE_ID="CVE-2019-19054"
	if pcregrep -M "if \(kfifo_alloc\(\&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE,\n\t\t\tGFP_KERNEL\)\) {\n\t\tkfree\(state\);" \
		"${S}/drivers/media/pci/cx23885/cx23888-ir.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19055_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19055 patch
function fetch_cve_2019_19055_hotfix() {
	local CVE_ID="CVE-2019-19055"
	if pcregrep -M "\t\t\t     NL80211_CMD_GET_FTM_RESPONDER_STATS\);\n\tif \(\!hdr\)\n\t\tgoto nla_put_failure;" \
		"${S}/net/wireless/nl80211.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19056_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19056 patch
function fetch_cve_2019_19056_hotfix() {
	local CVE_ID="CVE-2019-19056"
	if pcregrep -M "if \(mwifiex_map_pci_memory\(adapter, skb, MWIFIEX_UPLD_SIZE,\n\t\t\t\t   PCI_DMA_FROMDEVICE\)\) {\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/marvell/mwifiex/pcie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19057_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19057 patch
function fetch_cve_2019_19057_hotfix() {
	local CVE_ID="CVE-2019-19057"
	if pcregrep -M "kfree_skb\(skb\);\n\t\t\tkfree\(card->evtbd_ring_vbase\);" \
		"${S}/drivers/net/wireless/marvell/mwifiex/pcie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19058_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19058 patch
function fetch_cve_2019_19058_hotfix() {
	local CVE_ID="CVE-2019-19058"
	if grep -F -e \
		"kfree(table);" \
		"${S}/drivers/net/wireless/intel/iwlwifi/fw/dbg.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19059_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19059 patch
function fetch_cve_2019_19059_hotfix() {
	local CVE_ID="CVE-2019-19059"
	if grep -F -e \
		"err_free_prph_info:" \
		"${S}/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: fetch_cve_2019_19060_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19060 patch
function fetch_cve_2019_19060_hotfix() {
	local CVE_ID="CVE-2019-19060"
	if pcregrep -M "adis->buffer = kcalloc\(indio_dev->scan_bytes, 2, GFP_KERNEL\);\n\tif \(\!adis->buffer\) {\n\t\tkfree\(adis->xfer\);" \
		"${S}/drivers/iio/imu/adis_buffer.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19061_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19061 patch
function fetch_cve_2019_19061_hotfix() {
	local CVE_ID="CVE-2019-19061"
	if pcregrep -M "adis->buffer = kzalloc\(burst_length \+ sizeof\(u16\), GFP_KERNEL\);\n\tif \(\!adis->buffer\) {\n\t\tkfree\(adis->xfer\);" \
		"${S}/drivers/iio/imu/adis_buffer.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19062_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19062 patch
function fetch_cve_2019_19062_hotfix() {
	local CVE_ID="CVE-2019-19062"
	if pcregrep -M "if \(err\) {\n\t\tkfree_skb\(skb\);" \
		"${S}/crypto/crypto_user_base.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19063_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19063 patch
function fetch_cve_2019_19063_hotfix() {
	local CVE_ID="CVE-2019-19063"
	if grep -F -e \
		"if (!rtlpriv->usb_data) {" \
		"${S}/drivers/net/wireless/realtek/rtlwifi/usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19064_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19064 patch
function fetch_cve_2019_19064_hotfix() {
	local CVE_ID="CVE-2019-19064"
	if pcregrep -M "dev_err\(fsl_lpspi->dev, \"failed to enable clock\\\\n\"\);\n\t\tgoto out_controller_put;" \
		"${S}/drivers/spi/spi-fsl-lpspi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19065_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19065 patch
function fetch_cve_2019_19065_hotfix() {
	local CVE_ID="CVE-2019-19065"
	if grep -F -e \
		"kfree(tmp_sdma_rht);" \
		"${S}/drivers/infiniband/hw/hfi1/sdma.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19066_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19066 patch
function fetch_cve_2019_19066_hotfix() {
	local CVE_ID="CVE-2019-19066"
	if grep -F -e \
		"if (rc != BFA_STATUS_OK) {" \
		"${S}/drivers/scsi/bfa/bfad_attr.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19067_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19067 patch
function fetch_cve_2019_19067_hotfix() {
	local CVE_ID="CVE-2019-19067"
	if grep -F -e \
		"failure:" \
		"${S}/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19068_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19068 patch
function fetch_cve_2019_19068_hotfix() {
	local CVE_ID="CVE-2019-19068"
	if pcregrep -M "usb_free_urb\(urb\);\n\t\tgoto error;" \
		"${S}/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19069_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19069 patch
function fetch_cve_2019_19069_hotfix() {
	local CVE_ID="CVE-2019-19069"
	if pcregrep -M "dev_err\(buffer->dev, \"failed to get scatterlist from DMA API\\\\n\"\);\n\t\tkfree\(a\);" \
		"${S}/drivers/misc/fastrpc.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: fetch_cve_2019_19070_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19070 patch
function fetch_cve_2019_19070_hotfix() {
	local CVE_ID="CVE-2019-19070"
	if grep -F -e \
		"spi_master_put(master);" \
		"${S}/drivers/spi/spi-gpio.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19071_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19071 patch
function fetch_cve_2019_19071_hotfix() {
	local CVE_ID="CVE-2019-19071"
	if pcregrep -M "rsi_dbg\(ERR_ZONE, \"Failed to prepare beacon\\\\n\"\);\n\t\tdev_kfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/rsi/rsi_91x_mgmt.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19072_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19072 patch
function fetch_cve_2019_19072_hotfix() {
	local CVE_ID="CVE-2019-19072"
	if grep -F -e \
		"if (top - op_stack > nr_parens) {" \
		"${S}/kernel/trace/trace_events_filter.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19073_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19073 patch
function fetch_cve_2019_19073_hotfix() {
	local CVE_ID="CVE-2019-19073"
	if pcregrep -M "dev_err\(target->dev, \"HTC credit config timeout\\\\n\"\);\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/ath/ath9k/htc_hst.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19074_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19074 patch
function fetch_cve_2019_19074_hotfix() {
	local CVE_ID="CVE-2019-19074"
	if pcregrep -M "wmi_cmd_to_name\(cmd_id\)\);\n\t\tmutex_unlock\(\&wmi->op_mutex\);\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/ath/ath9k/wmi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19075_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19075 patch
function fetch_cve_2019_19075_hotfix() {
	local CVE_ID="CVE-2019-19075"
	if pcregrep -M "priv->spi->dev.platform_data = pdata;\n\tret = ca8210_get_platform_data\(priv->spi, pdata\);" \
		"${S}/drivers/net/ieee802154/ca8210.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19076_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19076 patch
function fetch_cve_2019_19076_hotfix() {
	local CVE_ID="CVE-2019-19076"
	if grep -F -e \
		"return err;" \
		"${S}/drivers/net/ethernet/netronome/nfp/abm/cls.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19077_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19077 patch
function fetch_cve_2019_19077_hotfix() {
	local CVE_ID="CVE-2019-19077"
	if pcregrep -M "bnxt_qplib_destroy_srq\(\&rdev->qplib_res,\n\t\t\t\t\t       \&srq->qplib_srq\);\n\t\t\tgoto fail;" \
		"${S}/drivers/infiniband/hw/bnxt_re/ib_verbs.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19078_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19078 patch
function fetch_cve_2019_19078_hotfix() {
	local CVE_ID="CVE-2019-19078"
	if pcregrep -M "usb_unanchor_urb\(urb\);\n\t\t\tusb_free_urb\(urb\);\n\t\t\tret = -EINVAL;" \
		"${S}/drivers/net/wireless/ath/ath10k/usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19079_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19079 patch
function fetch_cve_2019_19079_hotfix() {
	local CVE_ID="CVE-2019-19079"
	if grep -F -e \
		"kfree(kbuf);" \
		"${S}/net/qrtr/tun.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: fetch_cve_2019_19080_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19080 patch
function fetch_cve_2019_19080_hotfix() {
	local CVE_ID="CVE-2019-19080"
	if pcregrep -M "cmsg_port_id, port, priv->nn->dp.netdev\);\n\t\tif \(err\) {\n\t\t\tkfree\(repr_priv\);" \
		"${S}/drivers/net/ethernet/netronome/nfp/flower/main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19081_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19081 patch
function fetch_cve_2019_19081_hotfix() {
	local CVE_ID="CVE-2019-19081"
	if pcregrep -M "port_id, port, priv->nn->dp.netdev\);\n\t\tif \(err\) {\n\t\t\tkfree\(repr_priv\);" \
		"${S}/drivers/net/ethernet/netronome/nfp/flower/main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19082_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19082 patch
function fetch_cve_2019_19082_hotfix() {
	local CVE_ID="CVE-2019-19082"
	if grep -F -e \
		"kfree(pool);" \
		"${S}/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19083_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19083 patch
function fetch_cve_2019_19083_hotfix() {
	local CVE_ID="CVE-2019-19083"
	if grep -F -e \
		"kfree(clk_src);" \
		"${S}/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

# @FUNCTION: fetch_cve_2019_19227_hotfix
# @DESCRIPTION:
# Checks for the CVE_2019_19227 patch
function fetch_cve_2019_19227_hotfix() {
	local CVE_ID="CVE-2019-19227"
	if grep -F -e \
		'pr_crit("Unable to register DDP with SNAP.\n");' \
		"${S}/net/appletalk/ddp.c"
		>/dev/null ; \
	then
		einfo "${CVE_ID} already patched."
		return
	fi
	_fetch_cve_boilerplate_msg
	_fetch_cve_boilerplate_msg_footer
}

#---

# @FUNCTION: _resolve_hotfix_default
# @DESCRIPTION:
# Applies the fix or warns if not applied
# @CODE
# $1 - overrides patch of copy patch, intended to fix patches (optional)
# @CODE
function _resolve_hotfix_default() {
	local fn
	if [[ -z "${1}" ]] ; then
		fn="${DISTDIR}/${!cve_fn}"
	else
		fn="${1}"
	fi
	if use cve_hotfix ; then
		if [ -e "${fn}" ] ; then
			einfo \
"Resolving ${CVE_ID}.  ${!cve_fn} may break in different kernel versions."
			_dpatch "${PATCH_OPS}" "${fn}"
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
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq)" \
		"${S}/arch/i386/kernel/traps.c" \
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

# @FUNCTION: apply_cve_2010_4661_hotfix
# @DESCRIPTION:
# Applies the CVE_2010_4661 patch if it needs to
function apply_cve_2010_4661_hotfix() {
	# fixme
	return 0
	local CVE_ID="CVE-2010-4661"
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
	if ver_test ${PV} -ge 5.3.0 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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
	if ver_test ${PV} -ge 4.17.0 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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
	if ver_test ${PV} -ge 5.0.3 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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
	if ver_test ${PV} -le 4.9.0 \
	&& ver_test ${PV} -le 4.9.197 ; then
		cve_fn="${CVE_ID_}FN_4_9"
	fi
	if ver_test ${PV} -ge 4.14.0 \
	&& ver_test ${PV} -le 4.14.150 ; then
		cve_fn="${CVE_ID_}FN_4_14"
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

	# fix patch
	einfo "Fixing patch for ${CVE_ID}"
	cat "${DISTDIR}/${!cve_fn}" > "${T}/fixed-${!cve_fn}"
	echo -e "\n" >> "${T}/fixed-${!cve_fn}"

	_resolve_hotfix_default "${T}/fixed-${!cve_fn}"
}

# @FUNCTION: apply_cve_2019_18198_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18198 patch if it needs to
function apply_cve_2019_18198_hotfix() {
	local CVE_ID="CVE-2019-18198"
#	recheck
#	if ver_test ${PV} -ge 5.3.4 ; then
#		einfo "Skipping obsolete ${CVE_ID}"
#		return 0
#	fi
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
	if ver_test ${PV} -ge 5.3.5 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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
	if ver_test ${PV} -ge 5.3.5 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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
	if ver_test ${PV} -ge 5.3.8 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
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

# @FUNCTION: apply_cve_2019_18885_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_18885 patch if it needs to
function apply_cve_2019_18885_hotfix() {
	local CVE_ID="CVE-2019-18885"
	if ver_test ${PV} -ge 5.1.0 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"u64 devid, u8 *uuid, u8 *fsid, bool seed);" \
		"${S}/fs/btrfs/volumes.h" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


#---

# @FUNCTION: apply_cve_2019_19036_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19036 patch if it needs to
function apply_cve_2019_19036_hotfix() {
	# todo
	return 0
	local CVE_ID="CVE-2019-19036"
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

# @FUNCTION: apply_cve_2019_19037_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19037 patch if it needs to
function apply_cve_2019_19037_hotfix() {
	# todo
	return 0
	local CVE_ID="CVE-2019-19037"
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

# @FUNCTION: apply_cve_2019_19039_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19039 patch if it needs to
function apply_cve_2019_19039_hotfix() {
	# todo
	return 0
	local CVE_ID="CVE-2019-19039"
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


#---

# @FUNCTION: apply_cve_2019_19043_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19043 patch if it needs to
function apply_cve_2019_19043_hotfix() {
	local CVE_ID="CVE-2019-19043"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "ret = -EINVAL;\n\t\t\tkfree\(ch\);" \
		"${S}/drivers/net/ethernet/intel/i40e/i40e_main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}


# @FUNCTION: apply_cve_2019_19044_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19044 patch if it needs to
function apply_cve_2019_19044_hotfix() {
	local CVE_ID="CVE-2019-19044"
	if ver_test ${PV} -ge 5.3.11 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!bin) {" \
		"${S}/drivers/gpu/drm/v3d/v3d_gem.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19045_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19045 patch if it needs to
function apply_cve_2019_19045_hotfix() {
	local CVE_ID="CVE-2019-19045"
	if ver_test ${PV} -ge 5.3.11 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M \
		"err = mlx5_vector2eqn\(mdev, smp_processor_id\(\), &eqn, &irqn\);\n\tif \(err\) {\n\t\tkvfree\(in\);" \
		"${S}/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19046_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19046 patch if it needs to
function apply_cve_2019_19046_hotfix() {
	local CVE_ID="CVE-2019-19046"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (rv < 0) {" \
		"${S}/drivers/char/ipmi/ipmi_msghandler.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19047_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19047 patch if it needs to
function apply_cve_2019_19047_hotfix() {
	local CVE_ID="CVE-2019-19047"
	if ver_test ${PV} -ge 5.3.11 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "err = mlx5_crdump_collect\(dev, cr_data\);\n\t\if \(err\)\n\t\tgoto free_data;" \
		"${S}/drivers/net/ethernet/mellanox/mlx5/core/health.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19048_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19048 patch if it needs to
function apply_cve_2019_19048_hotfix() {
	local CVE_ID="CVE-2019-19048"
	if ver_test ${PV} -ge 5.3.9 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(\!bounce_buf\)\n\t\treturn -ENOMEM;\n\n\t\*bounce_buf_ret = bounce_buf;" \
		"${S}/drivers/virt/vboxguest/vboxguest_utils.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19049_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19049 patch if it needs to
function apply_cve_2019_19049_hotfix() {
	local CVE_ID="CVE-2019-19049"
	if ver_test ${PV} -ge 5.3.10 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(unittest_data);" \
		"${S}/drivers/of/unittest.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

#---

# @FUNCTION: apply_cve_2019_19050_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19050 patch if it needs to
function apply_cve_2019_19050_hotfix() {
	local CVE_ID="CVE-2019-19050"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree_skb(skb);" \
		"${S}/crypto/crypto_user_stat.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19051_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19051 patch if it needs to
function apply_cve_2019_19051_hotfix() {
	local CVE_ID="CVE-2019-19051"
	if ver_test ${PV} -ge 5.3.11 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "d_fnend\(4, dev, \"\(wimax_dev %p state %d\) = %d\\\\n\",\n\t\twimax_dev, state, result\);\n\tkfree\(cmd\);" \
		"${S}/drivers/net/wimax/i2400m/op-rfkill.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19052_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19052 patch if it needs to
function apply_cve_2019_19052_hotfix() {
	local CVE_ID="CVE-2019-19052"
	if ver_test ${PV} -ge 5.3.11 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "usb_unanchor_urb\(urb\);\n\t\t\t\tusb_free_urb\(urb\);" \
		"${S}/drivers/net/can/usb/gs_usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19053_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19053 patch if it needs to
function apply_cve_2019_19053_hotfix() {
	local CVE_ID="CVE-2019-19053"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!copy_from_iter_full(kbuf, len, from)) {" \
		"${S}/drivers/rpmsg/rpmsg_char.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19054_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19054 patch if it needs to
function apply_cve_2019_19054_hotfix() {
	local CVE_ID="CVE-2019-19054"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(kfifo_alloc\(\&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE,\n\t\t\tGFP_KERNEL\)\) {\n\t\tkfree\(state\);" \
		"${S}/drivers/media/pci/cx23885/cx23888-ir.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19055_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19055 patch if it needs to
function apply_cve_2019_19055_hotfix() {
	local CVE_ID="CVE-2019-19055"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "\t\t\t     NL80211_CMD_GET_FTM_RESPONDER_STATS\);\n\tif \(\!hdr\)\n\t\tgoto nla_put_failure;" \
		"${S}/net/wireless/nl80211.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19056_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19056 patch if it needs to
function apply_cve_2019_19056_hotfix() {
	local CVE_ID="CVE-2019-19056"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(mwifiex_map_pci_memory\(adapter, skb, MWIFIEX_UPLD_SIZE,\n\t\t\t\t   PCI_DMA_FROMDEVICE\)\) {\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/marvell/mwifiex/pcie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19057_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19057 patch if it needs to
function apply_cve_2019_19057_hotfix() {
	local CVE_ID="CVE-2019-19057"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "kfree_skb\(skb\);\n\t\t\tkfree\(card->evtbd_ring_vbase\);" \
		"${S}/drivers/net/wireless/marvell/mwifiex/pcie.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19058_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19058 patch if it needs to
function apply_cve_2019_19058_hotfix() {
	local CVE_ID="CVE-2019-19058"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(table);" \
		"${S}/drivers/net/wireless/intel/iwlwifi/fw/dbg.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19059_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19059 patch if it needs to
function apply_cve_2019_19059_hotfix() {
	local CVE_ID="CVE-2019-19059"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"err_free_prph_info:" \
		"${S}/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

#---

# @FUNCTION: apply_cve_2019_19060_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19060 patch if it needs to
function apply_cve_2019_19060_hotfix() {
	local CVE_ID="CVE-2019-19060"
	if ver_test ${PV} -ge 5.3.9 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "adis->buffer = kcalloc\(indio_dev->scan_bytes, 2, GFP_KERNEL\);\n\tif \(\!adis->buffer\) {\n\t\tkfree\(adis->xfer\);" \
		"${S}/drivers/iio/imu/adis_buffer.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19061_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19061 patch if it needs to
function apply_cve_2019_19061_hotfix() {
	local CVE_ID="CVE-2019-19061"
	if ver_test ${PV} -ge 5.3.9 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "adis->buffer = kzalloc\(burst_length \+ sizeof\(u16\), GFP_KERNEL\);\n\tif \(\!adis->buffer\) {\n\t\tkfree\(adis->xfer\);" \
		"${S}/drivers/iio/imu/adis_buffer.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19062_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19062 patch if it needs to
function apply_cve_2019_19062_hotfix() {
	local CVE_ID="CVE-2019-19062"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "if \(err\) {\n\t\tkfree_skb\(skb\);" \
		"${S}/crypto/crypto_user_base.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19063_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19063 patch if it needs to
function apply_cve_2019_19063_hotfix() {
	local CVE_ID="CVE-2019-19063"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (!rtlpriv->usb_data) {" \
		"${S}/drivers/net/wireless/realtek/rtlwifi/usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19064_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19064 patch if it needs to
function apply_cve_2019_19064_hotfix() {
	local CVE_ID="CVE-2019-19064"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "dev_err\(fsl_lpspi->dev, \"failed to enable clock\\\\n\"\);\n\t\tgoto out_controller_put;" \
		"${S}/drivers/spi/spi-fsl-lpspi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19065_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19065 patch if it needs to
function apply_cve_2019_19065_hotfix() {
	local CVE_ID="CVE-2019-19065"
	if ver_test ${PV} -ge 5.3.9 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(tmp_sdma_rht);" \
		"${S}/drivers/infiniband/hw/hfi1/sdma.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19066_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19066 patch if it needs to
function apply_cve_2019_19066_hotfix() {
	local CVE_ID="CVE-2019-19066"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (rc != BFA_STATUS_OK) {" \
		"${S}/drivers/scsi/bfa/bfad_attr.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19067_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19067 patch if it needs to
function apply_cve_2019_19067_hotfix() {
	local CVE_ID="CVE-2019-19067"
	if ver_test ${PV} -ge 5.3.8 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"failure:" \
		"${S}/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19068_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19068 patch if it needs to
function apply_cve_2019_19068_hotfix() {
	local CVE_ID="CVE-2019-19068"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "usb_free_urb\(urb\);\n\t\tgoto error;" \
		"${S}/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19069_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19069 patch if it needs to
function apply_cve_2019_19069_hotfix() {
	local CVE_ID="CVE-2019-19069"
	if ver_test ${PV} -ge 5.3.9 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "dev_err\(buffer->dev, \"failed to get scatterlist from DMA API\\\\n\"\);\n\t\tkfree\(a\);" \
		"${S}/drivers/misc/fastrpc.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

#---

# @FUNCTION: apply_cve_2019_19070_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19070 patch if it needs to
function apply_cve_2019_19070_hotfix() {
	local CVE_ID="CVE-2019-19070"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"spi_master_put(master);" \
		"${S}/drivers/spi/spi-gpio.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19071_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19071 patch if it needs to
function apply_cve_2019_19071_hotfix() {
	local CVE_ID="CVE-2019-19071"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "rsi_dbg\(ERR_ZONE, \"Failed to prepare beacon\\\\n\"\);\n\t\tdev_kfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/rsi/rsi_91x_mgmt.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19072_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19072 patch if it needs to
function apply_cve_2019_19072_hotfix() {
	local CVE_ID="CVE-2019-19072"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"if (top - op_stack > nr_parens) {" \
		"${S}/kernel/trace/trace_events_filter.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19073_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19073 patch if it needs to
function apply_cve_2019_19073_hotfix() {
	local CVE_ID="CVE-2019-19073"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "dev_err\(target->dev, \"HTC credit config timeout\\\\n\"\);\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/ath/ath9k/htc_hst.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19074_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19074 patch if it needs to
function apply_cve_2019_19074_hotfix() {
	local CVE_ID="CVE-2019-19074"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "wmi_cmd_to_name\(cmd_id\)\);\n\t\tmutex_unlock\(\&wmi->op_mutex\);\n\t\tkfree_skb\(skb\);" \
		"${S}/drivers/net/wireless/ath/ath9k/wmi.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19075_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19075 patch if it needs to
function apply_cve_2019_19075_hotfix() {
	local CVE_ID="CVE-2019-19075"
	if ver_test ${PV} -ge 5.3.8 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "priv->spi->dev.platform_data = pdata;\n\tret = ca8210_get_platform_data\(priv->spi, pdata\);" \
		"${S}/drivers/net/ieee802154/ca8210.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19076_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19076 patch if it needs to
function apply_cve_2019_19076_hotfix() {
	local CVE_ID="CVE-2019-19076"
	if ver_test ${PV} -ge 5.3.6 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"return err;" \
		"${S}/drivers/net/ethernet/netronome/nfp/abm/cls.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19077_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19077 patch if it needs to
function apply_cve_2019_19077_hotfix() {
	local CVE_ID="CVE-2019-19077"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "bnxt_qplib_destroy_srq\(\&rdev->qplib_res,\n\t\t\t\t\t       \&srq->qplib_srq\);\n\t\t\tgoto fail;" \
		"${S}/drivers/infiniband/hw/bnxt_re/ib_verbs.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19078_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19078 patch if it needs to
function apply_cve_2019_19078_hotfix() {
	local CVE_ID="CVE-2019-19078"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "usb_unanchor_urb\(urb\);\n\t\t\tusb_free_urb\(urb\);\n\t\t\tret = -EINVAL;" \
		"${S}/drivers/net/wireless/ath/ath10k/usb.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19079_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19079 patch if it needs to
function apply_cve_2019_19079_hotfix() {
	local CVE_ID="CVE-2019-19079"
	if ver_test ${PV} -ge 5.3.0 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(kbuf);" \
		"${S}/net/qrtr/tun.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

#---

# @FUNCTION: apply_cve_2019_19080_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19080 patch if it needs to
function apply_cve_2019_19080_hotfix() {
	local CVE_ID="CVE-2019-19080"
	if ver_test ${PV} -ge 5.3.4 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "cmsg_port_id, port, priv->nn->dp.netdev\);\n\t\tif \(err\) {\n\t\t\tkfree\(repr_priv\);" \
		"${S}/drivers/net/ethernet/netronome/nfp/flower/main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19081_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19081 patch if it needs to
function apply_cve_2019_19081_hotfix() {
	local CVE_ID="CVE-2019-19081"
	if ver_test ${PV} -ge 5.3.4 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if pcregrep -M "port_id, port, priv->nn->dp.netdev\);\n\t\tif \(err\) {\n\t\t\tkfree\(repr_priv\);" \
		"${S}/drivers/net/ethernet/netronome/nfp/flower/main.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19082_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19082 patch if it needs to
function apply_cve_2019_19082_hotfix() {
	local CVE_ID="CVE-2019-19082"
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(pool);" \
		"${S}/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19083_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19083 patch if it needs to
function apply_cve_2019_19083_hotfix() {
	local CVE_ID="CVE-2019-19083"
	if ver_test ${PV} -ge 5.3.8 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		"kfree(clk_src);" \
		"${S}/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c" \
		>/dev/null ; \
	then
		einfo "${CVE_ID} is already patched."
		return
	fi
	_resolve_hotfix_default
}

# @FUNCTION: apply_cve_2019_19227_hotfix
# @DESCRIPTION:
# Applies the CVE_2019_19227 patch if it needs to
function apply_cve_2019_19227_hotfix() {
	local CVE_ID="CVE-2019-19227"
	if ver_test ${PV} -ge 5.1.0 ; then
		einfo "Skipping obsolete ${CVE_ID}"
		return 0
	fi
	local CVE_ID_="${CVE_ID//-/_}_"
	local cve_severity="${CVE_ID_}SEVERITY"
	local cve_fn="${CVE_ID_}FN"
	if grep -F -e \
		'pr_crit("Unable to register DDP with SNAP.\n");' \
		"${S}/net/appletalk/ddp.c"
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

		fetch_cve_2007_3732_hotfix
		fetch_cve_2010_2243_hotfix
#		fetch_cve_2010_4661_hotfix

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
		fetch_cve_2019_18885_hotfix


		fetch_cve_2019_19036_hotfix
		fetch_cve_2019_19037_hotfix
		fetch_cve_2019_19039_hotfix


		fetch_cve_2019_19043_hotfix
		fetch_cve_2019_19044_hotfix
		fetch_cve_2019_19045_hotfix
		fetch_cve_2019_19046_hotfix
		fetch_cve_2019_19047_hotfix
		fetch_cve_2019_19048_hotfix
		fetch_cve_2019_19049_hotfix

		fetch_cve_2019_19050_hotfix
		fetch_cve_2019_19051_hotfix
		fetch_cve_2019_19052_hotfix
		fetch_cve_2019_19053_hotfix
		fetch_cve_2019_19054_hotfix
		fetch_cve_2019_19055_hotfix
		fetch_cve_2019_19056_hotfix
		fetch_cve_2019_19057_hotfix
		fetch_cve_2019_19058_hotfix
		fetch_cve_2019_19059_hotfix

		fetch_cve_2019_19060_hotfix
		fetch_cve_2019_19061_hotfix
		fetch_cve_2019_19062_hotfix
		fetch_cve_2019_19063_hotfix
		fetch_cve_2019_19064_hotfix
		fetch_cve_2019_19065_hotfix
		fetch_cve_2019_19066_hotfix
		fetch_cve_2019_19067_hotfix
		fetch_cve_2019_19068_hotfix
		fetch_cve_2019_19069_hotfix

		fetch_cve_2019_19070_hotfix
		fetch_cve_2019_19071_hotfix
		fetch_cve_2019_19072_hotfix
		fetch_cve_2019_19073_hotfix
		fetch_cve_2019_19074_hotfix
		fetch_cve_2019_19075_hotfix
		fetch_cve_2019_19076_hotfix
		fetch_cve_2019_19077_hotfix
		fetch_cve_2019_19078_hotfix
		fetch_cve_2019_19079_hotfix

		fetch_cve_2019_19080_hotfix
		fetch_cve_2019_19081_hotfix
		fetch_cve_2019_19082_hotfix
		fetch_cve_2019_19083_hotfix

		fetch_cve_2019_19227_hotfix

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

		apply_cve_2007_3732_hotfix
		apply_cve_2010_2243_hotfix
#		apply_cve_2010_4661_hotfix

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
		apply_cve_2019_18885_hotfix


		apply_cve_2019_19036_hotfix
		apply_cve_2019_19037_hotfix
		apply_cve_2019_19039_hotfix


		apply_cve_2019_19043_hotfix
		apply_cve_2019_19044_hotfix
		apply_cve_2019_19045_hotfix
		apply_cve_2019_19046_hotfix
		apply_cve_2019_19047_hotfix
		apply_cve_2019_19048_hotfix
		apply_cve_2019_19049_hotfix

		apply_cve_2019_19050_hotfix
		apply_cve_2019_19051_hotfix
		apply_cve_2019_19052_hotfix
		apply_cve_2019_19053_hotfix
		apply_cve_2019_19054_hotfix
		apply_cve_2019_19055_hotfix
		apply_cve_2019_19056_hotfix
		apply_cve_2019_19057_hotfix
		apply_cve_2019_19058_hotfix
		apply_cve_2019_19059_hotfix

		apply_cve_2019_19060_hotfix
		apply_cve_2019_19061_hotfix
		apply_cve_2019_19062_hotfix
		apply_cve_2019_19063_hotfix
		apply_cve_2019_19064_hotfix
		apply_cve_2019_19065_hotfix
		apply_cve_2019_19066_hotfix
		apply_cve_2019_19067_hotfix
		apply_cve_2019_19068_hotfix
		apply_cve_2019_19069_hotfix

		apply_cve_2019_19070_hotfix
		apply_cve_2019_19071_hotfix
		apply_cve_2019_19072_hotfix
		apply_cve_2019_19073_hotfix
		apply_cve_2019_19074_hotfix
		apply_cve_2019_19075_hotfix
		apply_cve_2019_19076_hotfix
		apply_cve_2019_19077_hotfix
		apply_cve_2019_19078_hotfix
		apply_cve_2019_19079_hotfix

		apply_cve_2019_19080_hotfix
		apply_cve_2019_19081_hotfix
		apply_cve_2019_19082_hotfix
		apply_cve_2019_19083_hotfix

		apply_cve_2019_19227_hotfix
	fi
}
