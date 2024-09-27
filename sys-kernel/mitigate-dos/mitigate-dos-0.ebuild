# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security:  update every kernel version bump

LTS_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6")
ACTIVE_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6" "6.10" "6.11")
STABLE_OR_MAINLINE_VERSIONS=("6.10" "6.11")
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9"
)

# For zero-tolerance mode
MULTISLOT_LATEST_KERNEL_RELEASE=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.111" "6.6.52" "6.10.11" "6.11")

# More than one row is added to increase LTS coverage.
MULTISLOT_KERNEL_AMDGPU=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9")
MULTISLOT_KERNEL_APPARMOR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9")
MULTISLOT_KERNEL_ATA_41087=("4.19.317" "5.4.279" "5.10.221" "5.15.162" "6.1.97" "6.6.37" "6.9.8")
MULTISLOT_KERNEL_BLUETOOTH_46749=("6.6.51" "6.10.10")
MULTISLOT_KERNEL_BLUETOOTH_48878=("5.10.165" "5.15.90" "6.1.8")
MULTISLOT_KERNEL_BPF_45020=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_BTRFS_46687=("6.6.49" "6.10.8")
MULTISLOT_KERNEL_BTRFS_46749=("6.10.10")
MULTISLOT_KERNEL_BRCM80211=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_CFG80211=("5.10.244" "5.15.165" "6.1.106" "6.6.47" "6.9.9")
MULTISLOT_KERNEL_COUGAR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_HFS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_HFSPLUS=("4.19.319" "5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_EXT4=("5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_I915=("5.10.221" "5.15.162" "6.1.97" "6.6.37")
MULTISLOT_KERNEL_ICE=("6.10.10")
MULTISLOT_KERNEL_IPV6=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_IWLWIFI_48918=("5.15.27" "5.16.13")
MULTISLOT_KERNEL_IWLWIFI_48787=("4.14.268" "4.19.231" "5.4.181" "5.10.102" "5.15.25" "5.16.11")
MULTISLOT_KERNEL_JFS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_MD_RAID1=("6.10.7")
MULTISLOT_KERNEL_MD_RAID5=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.105" "6.6.46" "6.10.5")
MULTISLOT_KERNEL_MLX5=("6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_MSM=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_NET_BRIDGE=("5.15.165" "6.1.105" "6.6.46" "6.10.5")
MULTISLOT_KERNEL_NFSD=("6.10.8")
MULTISLOT_KERNEL_NVME_45013=("6.10.7")
MULTISLOT_KERNEL_NVME_41073=("5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_NOUVEAU=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_RADEON=("5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_F2FS=("6.6.47" "6.10.6")
MULTISLOT_KERNEL_FS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.106" "6.6.47" "6.10.6")
MULTISLOT_KERNEL_MAC80211=("6.10.5")
MULTISLOT_KERNEL_NETFILTER=("5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_NF_TABLES=("4.19.313" "5.4.275" "5.10.216" "5.15.157" "6.1.88" "6.6.29" "6.8.8")
MULTISLOT_KERNEL_RTW88=("6.6.51" "6.10.10")
MULTISLOT_KERNEL_SCTP=("5.4.282" "5.10.224" "5.15.165" "6.1.105" "6.6.46" "6.10.5")
MULTISLOT_KERNEL_SELINUX=("5.10.99" "5.15.22" "5.16.8")
MULTISLOT_KERNEL_SMB_46796=("6.6.51" "6.10.10")
MULTISLOT_KERNEL_SMB_46795=("5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_TCP_42154=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9")
MULTISLOT_KERNEL_TLS=("5.10.219" "5.15.161" "6.1.93" "6.6.33" "6.9.4")
MULTISLOT_KERNEL_V3D=("6.10.8")
MULTISLOT_KERNEL_VMCI=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_VMWGFX=("6.6.49" "6.9" "6.10.8")
MULTISLOT_KERNEL_XE=("6.10.8")
MULTISLOT_KERNEL_XEN=("6.6.51" "6.10.10")

CVE_AMDGPU="CVE-2024-46725"
CVE_APPARMOR="CVE-2024-46721"
CVE_ATA_41087="CVE-2024-41087"
CVE_BLUETOOTH_46749="CVE-2024-46749"
CVE_BLUETOOTH_48878="CVE-2022-48878"
CVE_BPF_45020="CVE-2024-45020"
CVE_BTRFS_46687="CVE-2024-46687"
CVE_BTRFS_46749="CVE-2024-46749"
CVE_BRCM80211="CVE-2024-46672"
CVE_CFG80211="CVE-2024-42114"
CVE_COUGAR="CVE-2024-46747"
CVE_EXT4="CVE-2024-43828"
CVE_F2FS="CVE-2024-44942"
CVE_FS="CVE-2024-43882"
CVE_HFS="CVE-2024-42311"
CVE_HFSPLUS="CVE-2024-41059"
CVE_I915="CVE-2024-41092"
CVE_ICE="CVE-2024-46766"
CVE_JFS="CVE-2024-43858"
CVE_MD_RAID1="CVE-2024-45023"
CVE_MD_RAID5="CVE-2024-43914"
CVE_MSM="CVE-2024-45015"
CVE_NET_BRIDGE="CVE-2024-44934"
CVE_NFSD="CVE-2024-46696"
CVE_NOUVEAU="CVE-2024-45012"
CVE_RADEON="CVE-2024-41060"
CVE_IPV6="CVE-2024-44987"
CVE_IWLWIFI_48918="CVE-2022-48918"
CVE_IWLWIFI_48787="CVE-2022-48787"
CVE_MAC80211="CVE-2024-43911"
CVE_MLX5="CVE-2024-45019"
CVE_NETFILTER="CVE-2024-45018"
CVE_NF_TABLES="CVE-2024-27020"
CVE_NVME_45013="CVE-2024-45013"
CVE_NVME_41073="CVE-2024-41073"
CVE_RTW88="CVE-2024-46760"
CVE_SCTP="CVE-2024-44935"
CVE_SELINUX="CVE-2022-48740"
CVE_SMB_46796="CVE-2024-46796"
CVE_SMB_46795="CVE-2024-46795"
CVE_TCP_42154="CVE-2024-42154"
CVE_TLS="CVE-2024-36489"
CVE_V3D="CVE-2024-46699"
CVE_VMCI="CVE-2024-46738"
CVE_VMWGFX="CVE-2024-46709"
CVE_XE="CVE-2024-46683"
CVE_XEN="CVE-2024-46762"

inherit mitigate-dos toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dos" to downstream package if the downstream ebuild uses:
# Server
# Web Browser (For test taking, emergency service, voting)
# Network Software

S="${WORKDIR}"

DESCRIPTION="Enforce Denial of Service mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_freedreno
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_radeon
	video_cards_v3d
	video_cards_vmware
)
IUSE="
${VIDEO_CARDS[@]}
ata
apparmor
bcrm80211
bluetooth
bpf
bridge
btrfs
cougar
ext4
f2fs
hfs
hfsplus
ice
ipv6
iwlwifi
jfs
samba
max-uptime
md-raid1
md-raid5
mlx5
netfilter
nfs
nftables
nvme
rtw88
sctp
selinux
tcp
tls
vmware
xen
"
REQUIRED_USE="
"
# CE - Code Execution
# DoS - Denial of Service (CVSS A:H)
# DT - Data Tampering (CVSS I:H)
# ID - Information Disclosure (CVSS C:H)
# PE - Privilege Escalation

#
# In the kernel changelog, you can do a common keywords search of the following
# to look up the formulaic results:
#
# Arbitrary code execution, CVSS 9.8 # DoS, DT, ID
# Buffer overflow, CVSS 6.7 # DoS, DT, ID
# Crash, CVSS 5.5 # DoS
# Data corruption, CVSS 7.1 # DT, DoS
# Data race, CVSS 7.0 # DoS, DT, ID
# Deadlock, CVSS 5.5 # DoS
# Double free, CVSS 7.8 # DoS, DT, ID
# Local privilege escalation, CVSS 7.8 # DoS, DT, ID
# Memory leak, CVSS 5.5 # DoS
# NULL pointer dereference, CVSS 5.5 # DoS
# Out of bounds read, CVSS 7.1, # DoS, ID
# Out of bounds write, CVSS 7.8, # DoS, ID, DT
# Race condition, CVSS 4.7 # DoS
# ToCToU race, CVSS 7.0 # PE, DoS, DT, ID
# Use after free, use-after-free, UAF, CVSS 7.8 # DoS, DT, ID
# VM guest makes host slow and responsive, CVSS 6.0 # DoS
#

#
# The latest to near past vulnerabilities are reported below.
#
# apparmor? https://nvd.nist.gov/vuln/detail/CVE-2024-46721 # DoS
# ata? https://nvd.nist.gov/vuln/detail/CVE-2024-41087 # DoS, DT, ID
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2024-46749 # DoS
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2022-48878 # DoS, DT, ID
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-45020 # DoS
# bridge? https://nvd.nist.gov/vuln/detail/CVE-2024-44934 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46749 # DoS
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46687 # DoS, DT, ID
# bcrm80211? https://nvd.nist.gov/vuln/detail/CVE-2024-46672 # DoS
# cfg80211? https://nvd.nist.gov/vuln/detail/CVE-2024-42114 # DoS
# cougar? https://nvd.nist.gov/vuln/detail/CVE-2024-46747 # DoS, DT, ID
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-43828 # DoS
# f2fs? https://nvd.nist.gov/vuln/detail/CVE-2024-44942 # DoS, DT, ID
# fs? https://nvd.nist.gov/vuln/detail/CVE-2024-43882 # EP, DoS, DT, ID
# hfs? https://nvd.nist.gov/vuln/detail/CVE-2024-42311 # DoS
# hfsplus? https://nvd.nist.gov/vuln/detail/CVE-2024-41059 # DoS, DT, ID
# ice? https://nvd.nist.gov/vuln/detail/CVE-2024-46766 # DoS, DT, ID
# ipv6? https://nvd.nist.gov/vuln/detail/CVE-2024-44987 # DoS, DT, ID, UAF
# iwlwifi? [1] https://nvd.nist.gov/vuln/detail/CVE-2022-48918 # DoS
# iwlwifi? [2] https://nvd.nist.gov/vuln/detail/CVE-2022-48787 # DoS, DT, ID
# jfs https://nvd.nist.gov/vuln/detail/CVE-2024-43858 # DoS, DT, ID
# mac80211? https://nvd.nist.gov/vuln/detail/CVE-2024-43911 # DoS
# md-raid1? https://nvd.nist.gov/vuln/detail/CVE-2024-45023 # DT, DoS
# md-raid5? https://nvd.nist.gov/vuln/detail/CVE-2024-43914 # DOS
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2024-45019 # DoS
# msm? https://nvd.nist.gov/vuln/detail/CVE-2024-45015 # DoS
# nfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46696 # DoS, DT, ID
# netfilter? https://nvd.nist.gov/vuln/detail/CVE-2024-45018 # DoS
# nf_tables? https://nvd.nist.gov/vuln/detail/CVE-2022-48935 # DoS UAF
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-45013 # DoS
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-41073 # DoS, DT, ID
# rtw88? https://nvd.nist.gov/vuln/detail/CVE-2024-46760 # DoS
# sctp? https://nvd.nist.gov/vuln/detail/CVE-2024-44935 # DoS
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2022-48740 # DoS, DT, ID
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-46796 # DoS, DT, ID
# tcp? https://nvd.nist.gov/vuln/detail/CVE-2024-42154 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2023-52913 # DoS
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-45012 # DoS; requires >= 6.11 for fix
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-42101 # DoS; requires >= 6.10 for fix
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_radeon? https://nvd.nist.gov/vuln/detail/CVE-2024-41060 # DoS
# video_cards_v3d? https://nvd.nist.gov/vuln/detail/CVE-2024-46699 # DoS, DT, ID
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46709 # DoS
# vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46738 # DoS, DT, ID
# xen? https://nvd.nist.gov/vuln/detail/CVE-2024-46762 # DoS
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#
FS_RDEPEND="
	$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FS[@]})
"
WIFI_RDEPEND="
	$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CFG80211[@]})
	$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MAC80211[@]})
"

RDEPEND="
	${MITIGATE_DOS_RDEPEND}
	!custom-kernel? (
		zero-tolerance? (
			$(gen_zero_tolerance_kernel_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
		)
		$(gen_eol_kernels_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
	)
	apparmor? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_APPARMOR[@]})
		)
	)
	ata? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATA_41087[@]})
		)
	)
	bcrm80211? (
		!custom-kernel? (
			${WIFI_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BRCM80211[@]})
		)
	)
	bluetooth? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_46749[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]})
		)
	)
	bpf? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_45020[@]})
		)
	)
	bridge? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_BRIDGE[@]})
		)
	)
	btrfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_46687[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_46749[@]})
		)
	)
	cougar? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_COUGAR[@]})
		)
	)
	ext4? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4[@]})
		)
	)
	f2fs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_F2FS[@]})
		)
	)
	hfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HFS[@]})
		)
	)
	hfsplus? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HFSPLUS[@]})
		)
	)
	ice? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ICE[@]})
		)
	)
	iwlwifi? (
		!custom-kernel? (
			${WIFI_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_48918[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_48787[@]})
		)
	)
	jfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS[@]})
		)
	)
	md-raid1? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID1[@]})
		)
	)
	md-raid5? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID5[@]})
		)
	)
	mlx5? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5[@]})
		)
	)
	nfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD[@]})
		)
	)
	netfilter? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NETFILTER[@]})
		)
	)
	nftables? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NF_TABLES[@]})
		)
	)
	nvme? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_45013[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_41073[@]})
		)
	)
	rtw88? (
		!custom-kernel? (
			${WIFI_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RTW88[@]})
		)
	)
	samba? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46796[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46795[@]})
		)
	)
	sctp? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SCTP[@]})
		)
	)
	selinux? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SELINUX[@]})
		)
	)
	tcp? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TCP_42154[@]})
		)
	)
	tls? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TLS[@]})
		)
	)
	video_cards_amdgpu? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU[@]})
		)
	)
	video_cards_freedreno? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MSM[@]})
		)
	)
	video_cards_intel? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_I915[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE[@]})
		)
	)
	video_cards_nouveau? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NOUVEAU[@]})
		)
	)
	video_cards_nvidia? (
		|| (
			>=x11-drivers/nvidia-drivers-550.90.07:0/550
			>=x11-drivers/nvidia-drivers-535.183.01:0/535
			>=x11-drivers/nvidia-drivers-470.256.02:0/470
		)
	)
	video_cards_radeon? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RADEON[@]})
		)
	)
	video_cards_v3d? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_V3D[@]})
		)
	)
	video_cards_vmware? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_VMWGFX[@]})
		)
	)
	vmware? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_VMCI[@]})
		)
	)
	xen? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XEN[@]})
		)
	)
"
BDEPEND="
	sys-apps/util-linux
"

check_kernel_version() {
	local driver_name="${1}"
	shift
	local cve="${1}"
	shift
	local PATCHED_VERSIONS=( ${@} )
	if ! tc-is-cross-compiler && use custom-kernel ; then
		local required_version="${kv}"
		local prev_kernel_dir="${KERNEL_DIR}"
		local FOUND_VERSIONS_MAKEFILES=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local makefile_path
		for makefile_path in ${FOUND_VERSIONS_MAKEFILES[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${makefile_path}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${makefile_path}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
			local found_version="${pv_major}.${pv_minor}.${pv_patch}"
	# linux-info's get_version() is spammy.

			local vulnerable=1

	# Last version of patched versions
			local patched_version=${PATCHED_VERSIONS[-1]}
			if ! is_eol "${found_version}" && ver_test ${found_version} -ge ${patched_version} ; then
				vulnerable=0
			fi

	# Check LTS versions
			local patched_version
			for patched_version in ${PATCHED_VERSIONS[@]} ; do
				if is_lts ${patched_version} ; then
					local s1=$(ver_cut 1-2 ${found_version})
					local s2=$(ver_cut 1-2 ${patched_version})
					if ver_test ${s1} -eq ${s2} && ver_test ${found_version} -ge ${patched_version} ; then
						vulnerable=0
						break
					fi
				fi
			done

			if (( ${vulnerable} == 1 )) ; then
ewarn "${cve}:  not mitigated, component name - ${driver_name}, found version - ${found_version}"
			else
einfo "${cve}:  mitigated, component name - ${driver_name}, found version - ${found_version}"
			fi
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

check_drivers() {
	# Check for USE=custom-kernels only which bypass RDEPEND
	use custom-kernel || return
	local wifi=0
	local fs=0
	if use apparmor ; then
		check_kernel_version "apparmor" "${CVE_APPARMOR}" ${MULTISLOT_KERNEL_APPARMOR[@]}
	fi
	if use ata ; then
		check_kernel_version "ata" "${CVE_ATA_41087}" ${MULTISLOT_KERNEL_ATA_41087[@]}
	fi
	if use bcrm80211 ; then
		wifi=1
		check_kernel_version "bcrm80211" "${CVE_BRCM80211}" ${MULTISLOT_KERNEL_BRCM80211[@]}
	fi
	if use bluetooth ; then
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_46749}" ${MULTISLOT_KERNEL_BLUETOOTH_46749[@]}
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_48878}" ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
	fi
	if use bpf ; then
		check_kernel_version "bpf" "${CVE_BPF_45020}" ${MULTISLOT_KERNEL_BPF_45020[@]}
	fi
	if use bridge ; then
		check_kernel_version "net/bridge" "${CVE_NET_BRIDGE}" ${MULTISLOT_KERNEL_NET_BRIDGE[@]}
	fi
	if use btrfs ; then
		fs=1
		check_kernel_version "btrfs" "${CVE_BTRFS_46687}" ${MULTISLOT_KERNEL_BTRFS_46687[@]}
		check_kernel_version "btrfs" "${CVE_BTRFS_46749}" ${MULTISLOT_KERNEL_BTRFS_46749[@]}
	fi
	if use cougar ; then
		check_kernel_version "hid/hid-cougar" "${CVE_COUGAR}" ${MULTISLOT_KERNEL_COUGAR[@]}
	fi
	if use ext4 ; then
		fs=1
		check_kernel_version "ext4" "${CVE_EXT4}" ${MULTISLOT_KERNEL_EXT4[@]}
	fi
	if use f2fs ; then
		fs=1
		check_kernel_version "f2fs" "${CVE_F2FS}" ${MULTISLOT_KERNEL_F2FS[@]}
	fi
	if use hfs ; then
		fs=1
		check_kernel_version "hfs" "${CVE_HFS}" ${MULTISLOT_KERNEL_HFS[@]}
	fi
	if use hfsplus ; then
		fs=1
		check_kernel_version "hfsplus" "${CVE_HFSPLUS}" ${MULTISLOT_KERNEL_HFSPLUS[@]}
	fi
	if use ice ; then
		check_kernel_version "net/ethernet/intel/ice" "${CVE_ICE}" ${MULTISLOT_KERNEL_ICE[@]}
	fi
	if use ipv6 ; then
		check_kernel_version "ipv6" "${CVE_IPV6}" ${MULTISLOT_KERNEL_IPV6[@]}
	fi
	if use iwlwifi ; then
		wifi=1
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_48918}" ${MULTISLOT_KERNEL_IWLWIFI_48918[@]}
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_48787}" ${MULTISLOT_KERNEL_IWLWIFI_48787[@]}
	fi
	if use jfs ; then
		fs=1
		check_kernel_version "jfs" "${CVE_JFS}" ${MULTISLOT_KERNEL_JFS[@]}
	fi
	if use mlx5 ; then
		check_kernel_version "mlx5" "${CVE_MLX5}" ${MULTISLOT_KERNEL_MLX5[@]}
	fi
	if use md-raid1 ; then
		check_kernel_version "md/raid1" "${CVE_MD_RAID1}" ${MULTISLOT_KERNEL_MD_RAID1[@]}
	fi
	if use md-raid5 ; then
		check_kernel_version "md/raid5" "${CVE_MD_RAID5}" ${MULTISLOT_KERNEL_MD_RAID5[@]}
	fi
	if use nfs ; then
		fs=1
		check_kernel_version "nfsd" "${CVE_NFSD}" ${MULTISLOT_KERNEL_NFSD[@]}
	fi
	if use netfilter ; then
		check_kernel_version "netfilter" "${CVE_NETFILTER}" ${MULTISLOT_KERNEL_NETFILTER[@]}
	fi
	if use nftables ; then
		check_kernel_version "nf_tables" "${CVE_NF_TABLES}" ${MULTISLOT_KERNEL_NF_TABLES[@]}
	fi
	if use nvme ; then
		check_kernel_version "nvme" "${CVE_NVME_45013}" ${MULTISLOT_KERNEL_NVME_45013[@]}
		check_kernel_version "nvme" "${CVE_NVME_41073}" ${MULTISLOT_KERNEL_NVME_41073[@]}
	fi
	if use rtw88 ; then
		wifi=1
		check_kernel_version "rtw88" "${CVE_RTW88}" ${MULTISLOT_KERNEL_RTW88[@]}
	fi
	if use samba ; then
		fs=1
		check_kernel_version "smb" "${CVE_SMB_46796}" ${MULTISLOT_KERNEL_SMB_46796[@]}
		check_kernel_version "smb" "${CVE_SMB_46795}" ${MULTISLOT_KERNEL_SMB_46795[@]}
	fi
	if use sctp ; then
		check_kernel_version "sctp" "${CVE_SCTP}" ${MULTISLOT_KERNEL_SCTP[@]}
	fi
	if use selinux ; then
		check_kernel_version "selinux" "${CVE_SELINUX}" ${MULTISLOT_KERNEL_SELINUX[@]}
	fi
	if use tcp ; then
		check_kernel_version "tcp" "${CVE_TCP_42154}" ${MULTISLOT_KERNEL_TCP_42154[@]}
	fi
	if use tls ; then
		check_kernel_version "tls" "${CVE_TLS}" ${MULTISLOT_KERNEL_TLS[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu" "${CVE_AMDGPU}" ${MULTISLOT_KERNEL_AMDGPU[@]}
	fi
	if use video_cards_freedreno ; then
		check_kernel_version "msm" "${CVE_MSM}" ${MULTISLOT_KERNEL_MSM[@]}
	fi
	if use video_cards_intel ; then
		check_kernel_version "i915" "${CVE_I915}" ${MULTISLOT_KERNEL_I915[@]}
		check_kernel_version "xe" "${CVE_XE}" ${MULTISLOT_KERNEL_XE[@]}
	fi
	if use video_cards_radeon ; then
		check_kernel_version "radeon" "${CVE_RADEON}" ${MULTISLOT_KERNEL_RADEON[@]}
	fi
	if use video_cards_v3d ; then
		check_kernel_version "v3d" "${CVE_V3D}" ${MULTISLOT_KERNEL_V3D[@]}
	fi
	if use video_cards_vmware ; then
		check_kernel_version "vmwgfx" "${CVE_VMWGFX}" ${MULTISLOT_KERNEL_VMWGFX[@]}
	fi
	if use vmware ; then
		check_kernel_version "vmci" "${CVE_VMCI}" ${MULTISLOT_KERNEL_VMCI[@]}
	fi
	if use xen ; then
		check_kernel_version "xen" "${CVE_XEN}" ${MULTISLOT_KERNEL_XEN[@]}
	fi
	if (( ${wifi} == 1 )) ; then
		check_kernel_version "cfg80211" "${CVE_CFG80211}" ${MULTISLOT_KERNEL_CFG80211[@]}
		check_kernel_version "mac80211" "${CVE_MAC80211}" ${MULTISLOT_KERNEL_MAC80211[@]}
	fi
	if (( ${fs} == 1 )) ; then
		check_kernel_version "fs" "${CVE_FS}" ${MULTISLOT_KERNEL_FS[@]}
	fi
}

_check_y() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		${kconfig_setting}
	"
}

_check_n() {
	local kconfig_setting="${1}"
	CONFIG_CHECK+="
		!${kconfig_setting}
	"
}

_disable_gentoo_self_protection() {
	# Disabled for fine grained customization.
	_check_n "GENTOO_KERNEL_SELF_PROTECTION"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_COMMON"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_X86_64"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_X86_32"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_ARM64"
	_check_n "GENTOO_KERNEL_SELF_PROTECTION_ARM"
}

_check_kernel_cmdline() {
	local arg="${1}"
ewarn "${arg} should be added to the kernel command line for max-uptime."
}

_unset_pat_kconfig_kernel_cmdline() {
	local arg="${1}"
ewarn "${arg} should be unset to the kernel command line for max-uptime."
}

_y_retpoline() {
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.9" ; then
		_check_y "MITIGATION_RETPOLINE"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
		_check_y "RETPOLINE"
	else
ewarn "Retpoline not supported for < 4.15"
		return
	fi
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version}" -ge "7.3.0" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version}" -ge "5.0.2" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then

		local gcc_version=$(gcc-version)
		local clang_version=$(clang-version)
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "Switch to >=gcc-7.3 or >=clang-5.0.2 for retpoline support"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
#		die
	fi
}

_y_cet_ibt() {
	_check_y "X86_KERNEL_IBT"
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version%%.*}" -ge "9" && ot-kernel_has_version ">=sys-devel/binutils-2.29" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "14" && ot-kernel_has_version ">=sys-devel/lld-${compiler_version}" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "For CET-IBT (Indirect Branch Tracking) support for hardware forward edge CFI, switch to"
eerror
eerror "  >=gcc-9 with >=binutils-2.29"
eerror
eerror "    or"
eerror
eerror "  >=clang-14 with >=lld-14"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
		if has cet ${IUSE_EFFECTIVE} && use cet ; then
			die
		else
			:
		fi
	fi
}
_y_cet_ss() {
	_check_y "X86_USER_SHADOW_STACK"
	local ready=0
	if [[ "${compiler}" =~ "gcc" ]] && ver_test "${compiler_version%%.*}" -ge "8" && ot-kernel_has_version ">=sys-devel/binutils-2.31" ; then
		ready=1
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "6" && ot-kernel_has_version ">=sys-devel/lld-6" ; then
		ready=1
	fi
	if (( ${ready} == 0 )) ; then
		local compiler_name
		if [[ "${compiler}" =~ "gcc" ]] ; then
			compiler_name="gcc"
		elif [[ "${compiler}" =~ "clang" ]] ; then
			compiler_name="clang"
		fi
eerror
eerror "For CET-SS User Shadow Stack support for hardware backward edge CFI, switch to"
eerror
eerror "  >=gcc-8 with >=binutils-2.31"
eerror
eerror "    or"
eerror
eerror "  >=clang-6 with >=lld-6"
eerror
eerror "Actual ${compiler_name} version:  ${compiler_version}"
eerror
eerror "Tip:  Add/remove clang in OT_KERNEL_USE and in USE."
eerror
		if has cet ${IUSE_EFFECTIVE} && use cet ; then
			die
		else
			:
		fi
	fi
}

_set_kconfig_l1tf_mitigations() {
	local mode="${1}" # 1=enable, 0=disable
	[[ "${firmware_vendor}" != "intel" ]] && return
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
			_unset_pat_kconfig_kernel_cmdline "l1tf=off"
			return
		fi

		if [[ "${mode}" == "1" ]] ; then
	# SMT off, full hypervisor mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=full,force"
		elif [[ "${mode}" == "0.5" ]] ; then
	# SMT on, default hypervisor mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=flush"
		else
	# SMT on, no mitigation
			_unset_pat_kconfig_kernel_cmdline "l1tf=off"
		fi
	# Upstream uses SMT on, partial hypervisor mitigation.
	fi
}

# Keep in sync from with ot-kernel's ot-kernel_set_kconfig_hardening_level() default section.
# My explanation why the default setting is the most reliable for max uptime.
# 1.  Less overheating
# 2.  More CI testing for these defaults
# 3.  Mitigations do contribute to reducing fatal crash
# Tested with 62 days uptime with heavy compilation.
_verify_max_uptime_kernel_config_for_one_kernel() {
	local KV_MAJOR_MINOR="${1}"

	# This function resets the .config back to upstream defaults.

	local path_config="${KERNEL_DIR}/.config"
	if ! [[ -f "${path_config}" ]] ; then
ewarn "Missing ${path_config}.  Skipping max-uptime verification"
		return
	fi

	local compiler=$(linux_chkconfig_string "CC_VERSION_TEXT")
	if ! [[ "${compiler}" =~ "gcc" ]] ; then
		ewarn "${compiler} has not been verified for max uptime.  Rebuild with gcc to replicate the results."
	fi

	local compiler_version
	local gcc_slot
	if [[ "${compiler}" =~ "gcc" ]] ; then
		compiler_version=$(grep -e "CONFIG_CC_VERSION_TEXT" "${path_config}" | cut -f 2 -d "=" | cut -f 5 -d " ")
		gcc_slot="${compiler_version%%.*}"
	elif [[ "${compiler}" =~ "clang" ]] ; then
		compiler_version=$(grep -e "CONFIG_CC_VERSION_TEXT" "${path_config}" | cut -f 2 -d "=" | cut -f 3 -d " ")
	else
eerror "gcc or clang only supported for max-uptime in kernel .config.  Skipping check."
		return
	fi

	CONFIG_CHECK="
	"

	local arch=""
	if grep -q -e "Linux/x86" "${path_config}" && grep -q -e "^CONFIG_X86_64=y" "${path_config}" ; then
		arch="x86_64"
	elif grep -q -e "Linux/x86" "${path_config}" && grep -q -e "^CONFIG_X86=y" "${path_config}" ; then
		arch="x86"
	elif grep -q -e "Linux/arm64" "${path_config}" ; then
		arch="arm64"
	elif grep -q -e "Linux/arm" "${path_config}" ; then
		arch="arm"
	elif grep -q -e "Linux/s390" "${path_config}" ; then
		arch="s390"
	elif grep -q -e "Linux/powerpc" "${path_config}" ; then
		arch="powerpc"
	elif grep -q -e "Linux/sparc" "${path_config}" ; then
		arch="sparc"
	elif grep -q -e "Linux/mips" "${path_config}" ; then
		arch="mips"
	elif grep -q -e "Linux/riscv" "${path_config}" ; then
		arch="riscv"
	elif grep -q -e "Linux/mips" "${path_config}" ; then
		arch="mips"
	elif grep -q -e "Linux/loongarch" "${path_config}" ; then
		arch="loongarch"
	elif grep -q -e "Linux/alpha" "${path_config}" ; then
		arch="alpha"
	elif grep -q -e "Linux/parisc" "${path_config}" ; then
		arch="parisc" # HPPA
	elif grep -q -e "Linux/ia64" "${path_config}" ; then
		arch="ia64"
	else
eerror "USE=max-uptime not supported for ARCH=${ARCH}"
		die
	fi

	_check_n "CFI_CLANG"

	local firmware_vendor="${FIRMWARE_VENDOR,,}"
	if [[ -z "${firmware_vendor}" ]] ; then
eerror "FIRMWARE_VENDOR is empty."
eerror "Set FIRMWARE_VENDOR as the fallback corresponding to the CPU manufacturer.  Valid values:  intel, amd, arm, etc."
		die
	fi

	# Force -O2 to reduce encountering bad generated code.
	_check_n "CC_OPTIMIZE_FOR_PERFORMANCE_O3"
	_check_y "CC_OPTIMIZE_FOR_PERFORMANCE"
	_check_n "CC_OPTIMIZE_FOR_SIZE"

	_check_y "COMPAT_BRK"
	_check_n "FORTIFY_SOURCE"
	_disable_gentoo_self_protection
	_check_n "HARDENED_USERCOPY"
	_check_n "INIT_ON_ALLOC_DEFAULT_ON"
	_check_n "INIT_ON_FREE_DEFAULT_ON"

	if \
		[[ "${compiler}" =~ "gcc" ]] \
			&& \
		test -e $("${CHOST}-gcc-${gcc_slot}" -print-file-name=plugin)"/include/plugin-version.h" \
			&& \
		grep -q -E -e "^CONFIG_HAVE_GCC_PLUGINS=y" "${path_config}" \
			&& \
		! linux_chkconfig_present "RUST" \
	; then
		_check_y "GCC_PLUGINS"
	else
		_check_n "GCC_PLUGINS"
	fi

	if ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		if grep -q -E -e "^CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y" "${path_config}" ; then
			_check_n "INIT_STACK_ALL_PATTERN"
			_check_y "INIT_STACK_ALL_ZERO" # Needs >= GCC 12
			_check_n "GCC_PLUGIN_STACKLEAK"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
			_check_n "INIT_STACK_NONE"
		else
			_check_n "INIT_STACK_ALL_PATTERN"
			_check_n "INIT_STACK_ALL_ZERO"
			_check_n "GCC_PLUGIN_STACKLEAK"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
			_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
			_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
			_check_y "INIT_STACK_NONE"
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.9" ; then
		_check_n "INIT_STACK_ALL_PATTERN"
		_check_n "INIT_STACK_ALL_ZERO"
		_check_n "GCC_PLUGIN_STACKLEAK"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
		_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
		_check_y "INIT_STACK_NONE"
	elif ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
		_check_n "INIT_STACK_ALL"
		_check_y "INIT_STACK_NONE"
		_check_n "GCC_PLUGIN_STRUCTLEAK"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF"
		_check_n "GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
		_check_n "GCC_PLUGIN_STRUCTLEAK_USER"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.19" ; then
		# COMPILE_TEST is not default ON.
		_check_y "RANDSTRUCT_NONE"
		_check_n "RANDSTRUCT_FULL"
		_check_n "RANDSTRUCT_PERFORMANCE"
	fi
	_check_y "EXPERT"
	_check_y "MODIFY_LDT_SYSCALL"
	_check_y "RELOCATABLE"
	_check_y "RANDOMIZE_BASE"
	_check_n "RANDOMIZE_KSTACK_OFFSET_DEFAULT"
	if [[ "${arch}" == "s390" ]] ; then
		_check_y "EXPOLINE"
		_check_n "EXPOLINE_OFF"
		_check_y "EXPOLINE_AUTO"
		_check_n "EXPOLINE_ON"
	elif [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_check_y "RANDOMIZE_MEMORY"
	fi
	_y_retpoline
	_check_n "SHUFFLE_PAGE_ALLOCATOR"
	_check_n "SLAB_FREELIST_HARDENED"
	_check_n "SLAB_FREELIST_RANDOM"
	_check_y "SLAB_MERGE_DEFAULT"
	_check_y "STACKPROTECTOR"
	_check_y "STACKPROTECTOR_STRONG"
	if tc-is-gcc ; then
		_check_n "ZERO_CALL_USED_REGS"
	fi
	_check_n "SCHED_CORE"
	if ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
	# GDS:  Rely on automagic
			_check_n "GDS_FORCE_MITIGATION"
		fi
		if [[ "${arch}" == "arm64" ]] ; then
	# KPTI:  This assumes unforced default
	# SSBD:  Rely on automagic
			:
		fi

		if [[ "${arch}" == "powerpc" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi

		if [[ "${arch}" == "s390" ]] ; then
			_check_n "KERNEL_NOBP"
			#_check_kernel_cmdline "nobp=0"
		fi

		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
			_check_kernel_cmdline "spectre_v2=auto"
			_check_kernel_cmdline "spectre_v2_user=auto"
			if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
				_check_kernel_cmdline "kvm.nx_huge_pages=auto"
			fi
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_y "X86_INTEL_TSX_MODE_OFF"
				_check_n "X86_INTEL_TSX_MODE_ON"
				_check_n "X86_INTEL_TSX_MODE_AUTO"
				_check_kernel_cmdline "mds=full"
				_check_kernel_cmdline "mmio_stale_data=full"
				_check_kernel_cmdline "tsx=off"
				_check_kernel_cmdline "tsx_async_abort=full"
				if grep -q -E -e "^CONFIG_KVM=y" "${path_config}" ; then
					_check_kernel_cmdline "kvm-intel.vmentry_l1d_flush=cond"
				fi
			fi
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
		if [[ "${arch}" == "x86" ]] && grep -q -E -e "^CONFIG_X86_PAE=y" "${path_config}" ; then
			_check_y "PAGE_TABLE_ISOLATION"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_y "PAGE_TABLE_ISOLATION"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.8" ; then
		if [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_BTI_KERNEL" ; then
			_check_y "ARM64_VHE"
			_check_y "ARM64_PTR_AUTH"
			_check_y "ARM64_BTI_KERNEL"
			_check_n "GCOV_KERNEL"
			_check_n "FUNCTION_GRAPH_TRACER"
			_check_y "ARM64_BTI"
		elif [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
# TODO:  Make it a fatal errror based on /proc/cpuinfo or lscpu.
ewarn "cpu_flags_arm_bti is default ON for ARMv8.5."
		fi
		if [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
			_check_n "FUNCTION_GRAPH_TRACER"
			_check_y "ARM64_VHE"
			_check_y "ARM64_PTR_AUTH"
		elif [[ "${arch}" == "arm64" ]] && linux_chkconfig_present "ARM64_PTR_AUTH" ; then
# TODO:  Make it a fatal errror based on /proc/cpuinfo or lscpu.
ewarn "cpu_flags_arm_pac is default ON for ARMv8.5."
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.10" ; then
		_check_y "CPU_MITIGATIONS"
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_RFDS"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "CPU_SRSO"
				_check_y "CPU_UNRET_ENTRY"
				_check_kernel_cmdline "spec_rstack_overflow=safe-ret"
			fi
			_check_y "SPECULATION_MITIGATIONS"
			_check_n "SLS"
		fi
		_check_y "RETHUNK"
		_check_y "CPU_IBPB_ENTRY"
		_check_y "CPU_IBRS_ENTRY"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.14" ; then
		_set_kconfig_l1tf_mitigations "0.5"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.15" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_SPECTRE_BHI"
		fi
		if [[ "${arch}" == "powerpc" ]] ; then
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "retbleed=auto"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spectre_bhi=on"
			_check_kernel_cmdline "spec_store_bypass_disable=auto"
		fi
	elif ver_test "${KV_MAJOR_MINOR}" -ge "4.14" ; then
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "retbleed=auto"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "5.18" ; then
		_check_y "SPECULATION_MITIGATIONS"
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_y_cet_ibt
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.1" ; then
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_kernel_cmdline "reg_file_data_sampling=on"
				_check_y "MITIGATION_RFDS"
			fi
		fi
		if [[ "${arch}" == "x86_64" ]] ; then
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "SRSO"
			fi
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.2" ; then
		_check_y "CALL_DEPTH_TRACKING"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.4" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_n "ADDRESS_MASKING" # SLAM
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.5" ; then
		_check_y "CPU_SRSO"
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.6" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_n "X86_CET"
			_y_cet_ibt  # Forward-edge CFI
			_y_cet_ss   # Backward-edge CFI
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.8" ; then
		if [[ "${firmware_vendor}" == "intel" ]] ; then
			_check_y "MITIGATION_SPECTRE_BHI"
		fi
		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			_check_kernel_cmdline "spectre_bhi=on"
		fi
	fi
	if ver_test "${KV_MAJOR_MINOR}" -ge "6.9" ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			_check_y "MITIGATION_PAGE_TABLE_ISOLATION"
			_check_n "MITIGATION_SLS"
			_check_y "MITIGATION_RETHUNK"
			if [[ "${firmware_vendor}" == "amd" ]] ; then
				_check_y "MITIGATION_SRSO"
				_check_y "MITIGATION_UNRET_ENTRY"
				_check_y "MITIGATION_IBPB_ENTRY"
			fi
			if [[ "${firmware_vendor}" == "intel" ]] ; then
				_check_y "MITIGATION_CALL_DEPTH_TRACKING"
				_check_y "MITIGATION_IBRS_ENTRY"
				if has_version "sys-firmware/intel-microcode" ; then
					_check_n "MITIGATION_GDS_FORCE"
				#elif use cpu_flags_x86_avx ; then
				#	_check_y "MITIGATION_GDS_FORCE"
				fi
			fi
		fi
	fi

	# See https://en.wikipedia.org/wiki/Kernel_same-page_merging#Security_risks
	# Rowhammer - PE, DT, PE -> ID, PE -> DoS
	_check_n "KSM"
	_check_n "UKSM"

	if ! linux_chkconfig_present "SWAP" ; then
# See https://github.com/facebookincubator/oomd/blob/v0.5.0/docs/production_setup.md#swap
ewarn
ewarn "CONFIG_SWAP is recommended with 4x the RAM or at least 32 GiB total memory.  Tested with 28 GiB Swap and 8 GiB ram for 62 days of uptime."
ewarn "The CONFIG_SWAP=y recommendation does NOT apply to realtime, music production, or hardcore gameplay."
ewarn
	fi

	check_extra_config
}

verify_max_uptime_kernel_config() {
	if ! tc-is-cross-compiler && use max-uptime ; then
		local prev_kernel_dir="${KERNEL_DIR}"
		local L=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local x
		for x in ${L[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
			KERNEL_DIR=$(dirname "${x}")
einfo
einfo "Verifying max-uptime settings for ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
			_verify_max_uptime_kernel_config_for_one_kernel "${pv_major}.${pv_minor}"
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

verify_disable_ksm_for_one_kernel() {
	CONFIG_CHECK="
		!KSM
		!UKSM
	"
	ERROR_KSM="CONFIG_KSM=n is required to mitigate from ASLR circumvention, information disclosure, Rowhammer (elevated privileges, data tampering)"
	ERROR_UKSM="CONFIG_UKSM=n is required to mitigate against denial of service" # Thrashy
	check_extra_config
}

verify_disable_ksm() {
	if use zero-tolerance ; then
		local prev_kernel_dir="${KERNEL_DIR}"
		local L=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local x
		for x in ${L[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
einfo
einfo "Verifying CONFIG_KSM=n settings for ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
			KERNEL_DIR=$(dirname "${x}")
			verify_disable_ksm_for_one_kernel
		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

check_zero_tolerance() {
	use custom-kernel || return
	if use zero-tolerance ; then
		local prev_kernel_dir="${KERNEL_DIR}"
		local L=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local x
		for x in ${L[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")

			local latest_version
			for latest_version in ${MULTISLOT_LATEST_KERNEL_RELEASE[@]} ; do
				local s1=$(ver_cut 1-2 "${latest_version}")
				local s2="${pv_major}.${pv_minor}"
				if is_eol "${pv_major}.${pv_minor}" ; then
eerror "${pv_major}.${pv_minor}.${pv_patch}${extra_version} is EOL should be unemerged."
				elif ver_test "${s1}" -eq "${s2}" && ver_test "${pv_major}.${pv_minor}.${pv_patch}" -lt "${latest_version}" ; then
eerror "${pv_major}.${pv_minor}.${pv_patch}${extra_version} failed zero-tolerance and should be unemerged."
				fi
			done

		done
		KERNEL_DIR="${prev_kernel_dir}"
	fi
}

pkg_setup() {
	mitigate-dos_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_drivers
	check_zero_tolerance
	use max-uptime && verify_max_uptime_kernel_config
	verify_disable_ksm
}

# Unconditionally check
src_compile() {
	tc-is-cross-compiler && return
# TODO:  Find similar app
#einfo "Checking for mitigations against DoS."
#	if lscpu | grep -q "Vulnerable" ; then
#eerror "FAIL:  Detected an unmitigated CPU vulnerability."
#eerror "Fix issues to continue."
#		lscpu
#		die
#	else
#einfo "PASS"
#	fi
}
