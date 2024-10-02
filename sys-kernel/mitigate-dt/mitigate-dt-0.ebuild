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

# Arch specific
MULTISLOT_KERNEL_KVM_ARM64_26598=("5.4.269" "5.10.209" "5.15.148" "6.1.75" "6.6.14" "6.7.2")
MULTISLOT_KERNEL_KVM_POWERPC_41070=("5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11")

# More than one row is added to increase LTS coverage.
MULTISLOT_KERNEL_AACRAID=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.108" "6.6.49" "6.10.8")
MULTISLOT_KERNEL_AMDGPU=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9")
MULTISLOT_KERNEL_ATA_41087=("4.19.317" "5.4.279" "5.10.221" "5.15.162" "6.1.97" "6.6.37" "6.9.8")
MULTISLOT_KERNEL_BLUETOOTH_48878=("5.10.165" "5.15.90" "6.1.8")
MULTISLOT_KERNEL_BTRFS_46687=("6.6.49" "6.10.8")
MULTISLOT_KERNEL_BRCM80211=("6.6.48" "6.10.7")
MULTISLOT_KERNEL_CDROM=("6.1.98" "6.6.39" "6.9.9")
MULTISLOT_KERNEL_COUGAR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_EXT4=("6.10.1")
MULTISLOT_KERNEL_F2FS=("6.6.47" "6.10.6")
MULTISLOT_KERNEL_FS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.106" "6.6.47" "6.10.6")
MULTISLOT_KERNEL_FSCACHE=("6.6.51" "6.10.10")
MULTISLOT_KERNEL_HFSPLUS=("4.19.319" "5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_I915=("5.10.221" "5.15.162" "6.1.97" "6.6.37")
MULTISLOT_KERNEL_ICE=("6.10.10")
MULTISLOT_KERNEL_IMA_39494=("6.1.97" "6.6.35" "6.9.6")
MULTISLOT_KERNEL_IPV4_42154=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9")
MULTISLOT_KERNEL_IPV6=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7")
MULTISLOT_KERNEL_IP_36971=("4.19.316" "5.4.278" "5.10.219" "5.15.161" "6.1.94" "6.6.34" "6.9.4")
MULTISLOT_KERNEL_IWLWIFI_48787=("4.14.268" "4.19.231" "5.4.181" "5.10.102" "5.15.25" "5.16.11")
MULTISLOT_KERNEL_JFS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_MLX5=("5.4.185" "5.10.106" "5.15.29" "5.16.15")
MULTISLOT_KERNEL_MD_RAID1=("6.10.7")
MULTISLOT_KERNEL_MPTCP_44974=("6.6.48" "6.10.7" "6.11")
MULTISLOT_KERNEL_MT76=("5.15.163" "6.1.98" "6.6.39" "6.9.9")
MULTISLOT_KERNEL_NET_BRIDGE=("5.15.165" "6.1.105" "6.6.46" "6.10.5")
MULTISLOT_KERNEL_NFSD=("6.10.8")
MULTISLOT_KERNEL_NILFS2=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9")
MULTISLOT_KERNEL_NOUVEAU=("5.0.21" "5.4.284")
MULTISLOT_KERNEL_NTFS3_45896=("5.15.V" "6.1.V" "6.6" "6.10" "6.11")
MULTISLOT_KERNEL_NVME_41073=("5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_PCI_42302=("5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_SELINUX_46695=("6.6.49" "6.10.8")
MULTISLOT_KERNEL_SELINUX_48740=("5.10.99" "5.15.22" "5.16.8")
MULTISLOT_KERNEL_SMB_46796=("6.6.51" "6.10.10")
MULTISLOT_KERNEL_SMACK=("6.6.49" "6.10.8")
MULTISLOT_KERNEL_SMB_46795=("5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_TIPC=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_TLS_0646=("5.4.267" "5.10.208" "5.15.147" "6.1.69" "6.6.7")
MULTISLOT_KERNEL_V3D=("6.10.8")
MULTISLOT_KERNEL_VMCI=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10")
MULTISLOT_KERNEL_VMWGFX=("6.6.49" "6.9" "6.10.8")
MULTISLOT_KERNEL_XE=("6.10.8")

CVE_AMDGPU="CVE-2024-46725"
CVE_ATA_41087="CVE-2024-41087"
CVE_BLUETOOTH_48878="CVE-2022-48878"
CVE_BTRFS_46687="CVE-2024-46687"
CVE_BRCM80211="CVE-2024-46672"
CVE_CDROM="CVE-2024-42136"
CVE_COUGAR="CVE-2024-46747"
CVE_EXT4="CVE-2024-42257"
CVE_F2FS="CVE-2024-44942"
CVE_FS="CVE-2024-43882"
CVE_FSCACHE="CVE-2024-46786"
CVE_HFSPLUS="CVE-2024-41059"
CVE_I915="CVE-2024-41092"
CVE_ICE="CVE-2024-46766"
CVE_IMA_39494="CVE-2024-39494"
CVE_IPV4_42154="CVE-2024-42154"
CVE_IPV6="CVE-2024-44987"
CVE_IP_36971="CVE-2024-36971"
CVE_IWLWIFI_48787="CVE-2022-48787"
CVE_JFS="CVE-2024-43858"
CVE_KVM_ARM64_26598="CVE-2024-26598"
CVE_KVM_POWERPC_41070="CVE-2024-41070"
CVE_MD_RAID1="CVE-2024-45023"
CVE_MLX5="CVE-2022-48858"
CVE_MPTCP_44974="CVE-2024-44974"
CVE_MT76="CVE-2024-42225"
CVE_NET_BRIDGE="CVE-2024-44934"
CVE_NFSD="CVE-2024-46696"
CVE_NILFS2="CVE-2024-42104"
CVE_NOUVEAU="CVE-2023-0030"
CVE_NTFS3_45896="CVE-2023-45896"
CVE_NVME_41073="CVE-2024-41073"
CVE_PCI_42302="CVE-2024-42302"
CVE_SELINUX_46695="CVE-2024-46695"
CVE_SELINUX_48740="CVE-2022-48740"
CVE_SMACK="CVE-2024-46695"
CVE_SMB_46796="CVE-2024-46796"
CVE_SMB_46795="CVE-2024-46795"
CVE_TIPC="CVE-2024-42284"
CVE_TLS_0646="CVE-2024-0646"
CVE_V3D="CVE-2024-46699"
CVE_VMCI="CVE-2024-46738"
CVE_VMWGFX="CVE-2024-46709"
CVE_XE="CVE-2024-46683"

inherit mitigate-dt toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-dt" to downstream package if the downstream ebuild uses:
# Server (financial, banking, legal, voting)
# Web Browser (For voting, financial, banking, legal, voting)
# Network Software
# Realtime manufacturing

S="${WORKDIR}"

DESCRIPTION="Enforce Denial of Service mitigations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_nouveau
	video_cards_nvidia
	video_cards_v3d
	video_cards_vmware
)
IUSE="
${VIDEO_CARDS[@]}
aacraid
ata
bluetooth
bridge
btrfs
cdrom
cougar
ext4
f2fs
fscache
hfsplus
ice
ima
ipv4
ipv6
iwlwifi
jfs
kvm
md-raid1
mlx5
mptcp
mt76
nfs
nilfs2
ntfs
nvme
pci
samba
selinux
smack
tipc
tls
vmware
zero-tolerance
"
REQUIRED_USE="
	ipv6? (
		ipv4
	)
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

# Ebuild policy for automatic classification for rows marked *unofficial*:
#
# Sensitive data read || incomplete sanitization of sensitive data : ID
# Possible privilege escalation || data corruption || altered permissions : DT
# Possible crash || kernel panic || (!ID && !DT) : DoS

#
# The latest to near past vulnerabilities are reported below.
#
# aacraid? https://nvd.nist.gov/vuln/detail/CVE-2024-46673 # DoS, DT, ID
# ata? https://nvd.nist.gov/vuln/detail/CVE-2024-41087 # DoS, DT, ID
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2022-48878 # DoS, DT, ID
# bridge? https://nvd.nist.gov/vuln/detail/CVE-2024-44934 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46687 # DoS, DT, ID
# cdrom? https://nvd.nist.gov/vuln/detail/CVE-2024-42136 # DoS, DT, ID
# cougar? https://nvd.nist.gov/vuln/detail/CVE-2024-46747 # DoS, DT, ID
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-42257 # DoS, DT, ID
# f2fs? https://nvd.nist.gov/vuln/detail/CVE-2024-44942 # DoS, DT, ID
# fs? https://nvd.nist.gov/vuln/detail/CVE-2024-43882 # PE, DoS, DT, ID
# fscache? https://nvd.nist.gov/vuln/detail/CVE-2024-46786 # DoS, DT, ID UAF
# hfsplus? https://nvd.nist.gov/vuln/detail/CVE-2024-41059 # DoS, DT, ID
# ice? https://nvd.nist.gov/vuln/detail/CVE-2024-46766 # DoS, DT, ID
# ima? https://nvd.nist.gov/vuln/detail/CVE-2024-39494 # DoS, DT, ID
# ip? https://nvd.nist.gov/vuln/detail/CVE-2024-36971 # DoS, DT, ID
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-42154 # DoS, DT, ID
# ipv6? https://nvd.nist.gov/vuln/detail/CVE-2024-44987 # DoS, DT, ID, UAF
# iwlwifi? [2] https://nvd.nist.gov/vuln/detail/CVE-2022-48787 # DoS, DT, ID
# jfs https://nvd.nist.gov/vuln/detail/CVE-2024-43858 # DoS, DT, ID
# kvm https://nvd.nist.gov/vuln/detail/CVE-2024-26598 # DoS, DT, ID
# kvm https://nvd.nist.gov/vuln/detail/CVE-2024-41070 # DoS, DT, ID
# md-raid1? https://nvd.nist.gov/vuln/detail/CVE-2024-45023 # DT, DoS
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2022-48858 # DoS, DT, ID
# mptcp? https://nvd.nist.gov/vuln/detail/CVE-2024-44974 # DoS, DT, ID
# mt76? https://nvd.nist.gov/vuln/detail/CVE-2024-42225 # DoS, DT, ID
# nfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46696 # DoS, DT, ID
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-42104 # DoS, DT, ID
# ntfs? https://nvd.nist.gov/vuln/detail/CVE-2023-45896 # DoS, ID; RH rated it DT (I:L)
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-41073 # DoS, DT, ID
# pci? https://nvd.nist.gov/vuln/detail/CVE-2024-42302 # DoS, DT, ID
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2022-48740 # DoS, DT, ID
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2024-46695 # DT
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-46796 # DoS, DT, ID
# smack? https://nvd.nist.gov/vuln/detail/CVE-2024-46695 # DT
# tls? https://nvd.nist.gov/vuln/detail/CVE-2024-0646 # DoS, DT, ID
# tipc? https://nvd.nist.gov/vuln/detail/CVE-2024-42284 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2023-0030 # PE, ID, DoS, DT.  Fixed in >= 5.0.
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2021-20292 # PE, CE, ID, DoS, DT.  Fixed in >= 5.9.
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_v3d? https://nvd.nist.gov/vuln/detail/CVE-2024-46699 # DoS, DT, ID
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2022-22942 # PE, DoS, DT, ID
# vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46738 # DoS, DT, ID
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#
FS_RDEPEND="
	$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FS[@]})
"

ALL_RDEPEND="
	${MITIGATE_DT_RDEPEND}
	!custom-kernel? (
		zero-tolerance? (
			$(gen_zero_tolerance_kernel_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
		)
		$(gen_eol_kernels_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
	)
	aacraid? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AACRAID[@]})
		)
	)
	ata? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATA_41087[@]})
		)
	)
	bluetooth? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]})
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
		)
	)
	cdrom? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CDROM[@]})
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
	fscache? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FSCACHE[@]})
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
	ima? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IMA_39494[@]})
		)
	)
	ipv4? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_42154[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]})
		)
	)
	ipv6? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV6[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]})
		)
	)
	iwlwifi? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_48787[@]})
		)
	)
	jfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS[@]})
		)
	)
	kvm? (
		!custom-kernel? (
			arm64? (
				$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]})
			)
			ppc64? (
				$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]})
			)
		)
	)
	md-raid1? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID1[@]})
		)
	)
	mlx5? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5[@]})
		)
	)
	mptcp? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MPTCP_44974[@]})
		)
	)
	mt76? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT76[@]})
		)
	)
	nfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD[@]})
		)
	)
	nilfs2? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2[@]})
		)
	)
	ntfs? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NTFS3_45896[@]})
		)
	)
	nvme? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_41073[@]})
		)
	)
	pci? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PCI_42302[@]})
		)
	)
	samba? (
		!custom-kernel? (
			${FS_RDEPEND}
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46796[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46795[@]})
		)
	)
	selinux? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SELINUX_46695[@]})
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SELINUX_48740[@]})
		)
	)
	smack? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMACK[@]})
		)
	)
	tipc? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TIPC[@]})
		)
	)
	tls? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TLS_0646[@]})
		)
	)
	video_cards_amdgpu? (
		!custom-kernel? (
			$(gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU[@]})
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
"
ARDEPEND="
	enforce? (
		${ALL_RDEPEND}
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
					if ver_test ${s1} -eq ${s2} && [[ "${patched_version}" =~ "V" ]] ; then
						vulnerable=1
						break
					elif ver_test ${s1} -eq ${s2} && ver_test ${found_version} -ge ${patched_version} ; then
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
	local fs=0
	if use aacraid ; then
		check_kernel_version "scsi/aacraid" "${CVE_AACRAID}" ${MULTISLOT_KERNEL_AACRAID[@]}
	fi
	if use ata ; then
		check_kernel_version "ata" "${CVE_ATA_41087}" ${MULTISLOT_KERNEL_ATA_41087[@]}
	fi
	if use bluetooth ; then
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_48878}" ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
	fi
	if use bridge ; then
		check_kernel_version "net/bridge" "${CVE_NET_BRIDGE}" ${MULTISLOT_KERNEL_NET_BRIDGE[@]}
	fi
	if use btrfs ; then
		fs=1
		check_kernel_version "btrfs" "${CVE_BTRFS_46687}" ${MULTISLOT_KERNEL_BTRFS_46687[@]}
	fi
	if use cdrom ; then
		check_kernel_version "cdrom" "${CVE_CDROM}" ${MULTISLOT_KERNEL_CDROM[@]}
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
	if use fscache ; then
		fs=1
		check_kernel_version "fscache" "${CVE_FSCACHE}" ${MULTISLOT_KERNEL_FSCACHE[@]}
	fi
	if use hfsplus ; then
		fs=1
		check_kernel_version "hfsplus" "${CVE_HFSPLUS}" ${MULTISLOT_KERNEL_HFSPLUS[@]}
	fi
	if use ice ; then
		check_kernel_version "net/ethernet/intel/ice" "${CVE_ICE}" ${MULTISLOT_KERNEL_ICE[@]}
	fi
	if use ima ; then
		check_kernel_version "ima" "${CVE_IMA_39494}" ${MULTISLOT_KERNEL_IMA_39494[@]}
	fi
	local ip=0
	if use ipv4 ; then
		ip=1
		check_kernel_version "ipv4" "${CVE_IPV4_42154}" ${MULTISLOT_KERNEL_IPV4_42154[@]}
	fi
	if use ipv6 ; then
		ip=1
		check_kernel_version "ipv6" "${CVE_IPV6}" ${MULTISLOT_KERNEL_IPV6[@]}
	fi
	if (( ${ip} == 1 )) ; then
		check_kernel_version "ip" "${CVE_IP_36971}" ${MULTISLOT_KERNEL_IP_36971[@]}
	fi
	if use iwlwifi ; then
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_48787}" ${MULTISLOT_KERNEL_IWLWIFI_48787[@]}
	fi
	if use jfs ; then
		fs=1
		check_kernel_version "jfs" "${CVE_JFS}" ${MULTISLOT_KERNEL_JFS[@]}
	fi
	if use kvm ; then
		if use arm64 ; then
			check_kernel_version "arm64/kvm" "${CVE_KVM_ARM64_26598}" ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]}
		elif use ppc64 ; then
			check_kernel_version "powerpc/kvm" "${CVE_KVM_POWERPC_41070}" ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]}
		fi
	fi
	if use md-raid1 ; then
		check_kernel_version "md/raid1" "${CVE_MD_RAID1}" ${MULTISLOT_KERNEL_MD_RAID1[@]}
	fi
	if use mlx5 ; then
		check_kernel_version "mlx5" "${CVE_MLX5}" ${MULTISLOT_KERNEL_MLX5[@]}
	fi
	if use mptcp ; then
		check_kernel_version "mptcp" "${CVE_MPTCP_44974}" ${MULTISLOT_KERNEL_MPTCP_44974[@]}
	fi
	if use mt76 ; then
		check_kernel_version "mt76" "${CVE_MT76}" ${MULTISLOT_KERNEL_MT76[@]}
	fi
	if use nfs ; then
		fs=1
		check_kernel_version "nfsd" "${CVE_NFSD}" ${MULTISLOT_KERNEL_NFSD[@]}
	fi
	if use nilfs2 ; then
		check_kernel_version "nilfs2" "${CVE_NILFS2}" ${MULTISLOT_KERNEL_NILFS2[@]}
	fi
	if use ntfs ; then
		fs=1
		check_kernel_version "ntfs3" "${CVE_NTFS3_45896}" ${MULTISLOT_KERNEL_NTFS3_45896[@]}
	fi
	if use nvme ; then
		check_kernel_version "nvme" "${CVE_NVME_41073}" ${MULTISLOT_KERNEL_NVME_41073[@]}
	fi
	if use pci ; then
		check_kernel_version "pci" "${CVE_PCI_42302}" ${MULTISLOT_KERNEL_PCI_42302[@]}
	fi
	if use samba ; then
		fs=1
		check_kernel_version "smb" "${CVE_SMB_46796}" ${MULTISLOT_KERNEL_SMB_46796[@]}
		check_kernel_version "smb" "${CVE_SMB_46795}" ${MULTISLOT_KERNEL_SMB_46795[@]}
	fi
	if use selinux ; then
		check_kernel_version "selinux" "${CVE_SELINUX_46695}" ${MULTISLOT_KERNEL_SELINUX_46695[@]}
		check_kernel_version "selinux" "${CVE_SELINUX_48740}" ${MULTISLOT_KERNEL_SELINUX_48740[@]}
	fi
	if use smack ; then
		check_kernel_version "smack" "${CVE_SMACK}" ${MULTISLOT_KERNEL_SMACK[@]}
	fi
	if use tipc ; then
		check_kernel_version "tipc" "${CVE_TIPC}" ${MULTISLOT_KERNEL_TIPC[@]}
	fi
	if use tls ; then
		check_kernel_version "tls" "${CVE_TLS_0646}" ${MULTISLOT_KERNEL_TLS_0646[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu" "${CVE_AMDGPU}" ${MULTISLOT_KERNEL_AMDGPU[@]}
	fi
	if use video_cards_nouveau ; then
		check_kernel_version "nouveau" "${CVE_NOUVEAU}" ${MULTISLOT_KERNEL_NOUVEAU[@]}
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
	use enforce || return
	mitigate-dt_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_drivers
	check_zero_tolerance
	verify_disable_ksm
}

# Unconditionally check
src_compile() {
	use enforce || return
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
