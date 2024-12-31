# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security:  update every kernel version bump

declare -A _ALL_VERSIONS=(
["_0"]="EOL"
["_1"]="EOL"
["_2"]="EOL"
["_3"]="EOL"
["_4_0"]="EOL"
["_4_1"]="EOL"
["_4_2"]="EOL"
["_4_3"]="EOL"
["_4_4"]="EOL"
["_4_5"]="EOL"
["_4_6"]="EOL"
["_4_7"]="EOL"
["_4_8"]="EOL"
["_4_8"]="EOL"
["_4_9"]="EOL"
["_4_10"]="EOL"
["_4_11"]="EOL"
["_4_12"]="EOL"
["_4_13"]="EOL"
["_4_14"]="EOL"
["_4_15"]="EOL"
["_4_16"]="EOL"
["_4_17"]="EOL"
["_4_18"]="EOL"
["_4_19"]="4.19"
["_4_20"]="EOL"
["_5_0"]="EOL"
["_5_1"]="EOL"
["_5_2"]="EOL"
["_5_3"]="EOL"
["_5_4"]="5.4"
["_5_5"]="EOL"
["_5_6"]="EOL"
["_5_7"]="EOL"
["_5_8"]="EOL"
["_5_9"]="EOL"
["_5_10"]="5.10"
["_5_11"]="EOL"
["_5_12"]="EOL"
["_5_13"]="EOL"
["_5_14"]="EOL"
["_5_15"]="5.15"
["_5_16"]="EOL"
["_5_17"]="EOL"
["_5_18"]="EOL"
["_5_19"]="EOL"
["_6_0"]="EOL"
["_6_1"]="6.1"
["_6_2"]="EOL"
["_6_3"]="EOL"
["_6_4"]="EOL"
["_6_5"]="EOL"
["_6_6"]="6.6"
["_6_7"]="EOL"
["_6_8"]="EOL"
["_6_9"]="EOL"
["_6_10"]="EOL"
["_6_11"]="EOL"
["_6_12"]="6.12"
["_6_13"]="6.13"
)
_INTEL_MICROCODE_PV=0
_LINUX_FIRMWARE_PV=0

LTS_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6" "6.12")
ACTIVE_VERSIONS=("4.19" "5.4" "5.10" "5.15" "6.1" "6.6" "6.12" "6.13")
STABLE_OR_MAINLINE_VERSIONS=("6.11")
ALL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.10" "5.11" "5.12" "5.13" "5.14" "5.15" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.1" "6.2" "6.3" "6.4" "6.5" "6.6" "6.7" "6.8" "6.9" "6.11" "6.12" "6.13"
)
EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9" "6.10" "6.11"
)

# For zero-tolerance mode
MULTISLOT_LATEST_KERNEL_RELEASE=("5.4.288" "5.10.232" "5.15.175" "6.1.122" "6.6.68" "6.12.7")

# Core
MULTISLOT_KERNEL_MM_47745=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")

# Arch specific
MULTISLOT_KERNEL_KVM_ARM64_26598=("5.4.269" "5.10.209" "5.15.148" "6.1.75" "6.6.14" "6.7.2" "6.8_rc1")
MULTISLOT_KERNEL_KVM_POWERPC_41070=("5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.10")

# More than one row is added to increase LTS coverage.
MULTISLOT_KERNEL_AACRAID=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.108" "6.6.49" "6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_ACPI=("5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_AEAD=("5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_AMDGPU_46725=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_46871=("6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_49989=("6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_AMDGPU_49969=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_ATA_41087=("4.19.317" "5.4.279" "5.10.221" "5.15.162" "6.1.97" "6.6.37" "6.9.8" "6.10")
MULTISLOT_KERNEL_ATH11K_49930=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_ATH12K_49931=("6.6.55" "6.10.14" "6.11.3")
MULTISLOT_KERNEL_BFQ_49854=("5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_BFQ_18ad4df=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_BLUETOOTH_48878=("5.10.165" "5.15.90" "6.1.8" "6.2")
MULTISLOT_KERNEL_BLUETOOTH_50029=("6.6.57" "6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_BPF_47675=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_BTRFS_46687=("6.6.49" "6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_BTRFS_49869=("6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_BUS=("6.6.57" "6.11.4" "6.12_rc1")
MULTISLOT_KERNEL_CDROM=("6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_COUGAR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_ECDH=("4.19.V" "5.4.V" "5.15.162" "6.1.97" "6.6.37" "6.10", "6.11")
MULTISLOT_KERNEL_EXT4_42257=("6.10.1" "6.11_rc1")
MULTISLOT_KERNEL_EXT4_c6b72f5=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_EXT4_49889=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_EXT4_49880=("6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_F2FS=("6.6.47" "6.10.6" "6.11_rc1")
MULTISLOT_KERNEL_FS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.106" "6.6.47" "6.10.6" "6.11_rc4")
MULTISLOT_KERNEL_FSCACHE=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_FUSE=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_HFSPLUS=("4.19.319" "5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.11")
MULTISLOT_KERNEL_HUGETLBFS_47676=("6.10.13" "6.11.2" "6.12")
MULTISLOT_KERNEL_I915=("5.10.211" "5.15.162" "6.1.97" "6.6.37" "6.9.8" "6.10")
MULTISLOT_KERNEL_IAA=("6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_ICE=("6.10.10" "6.11")
MULTISLOT_KERNEL_IMA_39494=("6.1.97" "6.6.35" "6.9.6" "6.10_rc1")
MULTISLOT_KERNEL_IMA_21505=("5.4.208" "5.15.58" "6.1" "6.6" "6.10" "6.11")
MULTISLOT_KERNEL_IP_36971=("4.19.316" "5.4.278" "5.10.219" "5.15.161" "6.1.94" "6.6.34" "6.9.4" "6.10_rc2")
MULTISLOT_KERNEL_IPV4_42154=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_IPV6=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_IPV6_NETFILTER=("5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_IWLWIFI=("4.14.268" "4.19.231" "5.4.181" "5.10.102" "5.15.25" "5.16.11")
MULTISLOT_KERNEL_JFS_43858=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_JFS_49903=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_MLX5=("5.4.185" "5.10.106" "5.15.29" "5.16.15" "5.17")
MULTISLOT_KERNEL_MPTCP_44974=("6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_MPTCP_46858=("6.1.111" "6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_MT76=("5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_NET_50036=("6.6.57" "6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_NET_BRIDGE=("5.15.165" "6.1.105" "6.6.46" "6.10.5" "6.11_rc3")
MULTISLOT_KERNEL_NET_XEN_NETBACK=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_NETFILTER=("5.15" "6.1.107" "6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_NFSD_46696=("6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_NFSD_50043=("6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_NILFS2=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_NILFS2_47757=("4.19.V" "5.4.V" "5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_NF_TABLES=("4.19.313" "5.4.275" "5.10.216" "5.15.157" "6.1.88" "6.6.29" "6.8.8" "6.9_rc5")
MULTISLOT_KERNEL_NOUVEAU=("5.0.21" "5.4.284")
MULTISLOT_KERNEL_NTFS3_45896=("5.15.V" "6.1.V" "6.6" "6.10" "6.11")
MULTISLOT_KERNEL_NVME_41073=("5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.10")
MULTISLOT_KERNEL_NVME_41079=("6.1.101" "6.6.42" "6.10" "6.11")
MULTISLOT_KERNEL_PCI_42302=("5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_POWERCAP=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_RTW88_0e735a4=("5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_SCSI_SD=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_SELINUX=("5.10.99" "5.15.22" "5.16.8" "5.17")
MULTISLOT_KERNEL_SMACK_47659=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_SMB_46796=("6.6.51" "6.10.10" "5.11")
MULTISLOT_KERNEL_SMB_49996=("6.6.55" "6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_SQUASHFS=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_TIPC=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_V3D=("6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_XE_46683=("6.10.8" "6.11_rc5")
MULTISLOT_KERNEL_XE_49876=("6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_VMCI=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_VMWGFX=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.111" "6.6.52")
MULTISLOT_KERNEL_XFS=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.V" "6.10.V" "6.11_rc1")

CVE_AACRAID="CVE-2024-46673"
CVE_ACPI="CVE-2024-49860"
CVE_AEAD="CVE-2024-42229"
CVE_AMDGPU_46725="CVE-2024-46725"
CVE_AMDGPU_46871="CVE-2024-46871"
CVE_AMDGPU_49989="CVE-2024-49989"
CVE_AMDGPU_49969="CVE-2024-49969"
CVE_ATA_41087="CVE-2024-41087"
CVE_ATH11K_49930="CVE-2024-49930"
CVE_ATH12K_49931="CVE-2024-49931"
CVE_BFQ_49854="CVE-2024-49854"
CVE_BFQ_18ad4df="UAF"
CVE_BLUETOOTH_48878="CVE-2022-48878"
CVE_BLUETOOTH_50029="CVE-2024-50029"
CVE_BPF_47675="CVE-2024-47675"
CVE_BTRFS_46687="CVE-2024-46687"
CVE_BTRFS_49869="CVE-2024-49869"
CVE_BUS="CVE-2024-50055"
CVE_CDROM="CVE-2024-42136"
CVE_COUGAR="CVE-2024-46747"
CVE_ECDH="CVE-2024-42098"
CVE_EXT4_42257="CVE-2024-42257"
CVE_EXT4_c6b72f5="UAF"
CVE_EXT4_49889="CVE-2024-49889"
CVE_EXT4_49880="CVE-2024-49880"
CVE_F2FS="CVE-2024-44942"
CVE_FS="CVE-2024-43882"
CVE_FSCACHE="CVE-2024-46786"
CVE_FUSE="CVE-2024-44947"
CVE_HFSPLUS="CVE-2024-41059"
CVE_HUGETLBFS_47676="CVE-2024-47676"
CVE_I915="CVE-2024-41092"
CVE_IAA="CVE-2024-47732"
CVE_ICE="CVE-2024-46766"
CVE_IMA_39494="CVE-2024-39494"
CVE_IMA_21505="CVE-2022-21505" # unlisted
CVE_IPV4_42154="CVE-2024-42154"
CVE_IPV6="CVE-2024-44987"
CVE_IPV6_NETFILTER="CVE-2024-47685"
CVE_IP_36971="CVE-2024-36971"
CVE_IWLWIFI="CVE-2022-48787"
CVE_JFS_43858="CVE-2024-43858"
CVE_JFS_49903="CVE-2024-49903"
CVE_KVM_ARM64_26598="CVE-2024-26598"
CVE_KVM_POWERPC_41070="CVE-2024-41070"
CVE_MLX5="CVE-2022-48858"
CVE_MM_47745="CVE-2024-47745"
CVE_MPTCP_44974="CVE-2024-44974"
CVE_MPTCP_46858="CVE-2024-46858"
CVE_MT76="CVE-2024-42225"
CVE_NET_50036="CVE-2024-50036"
CVE_NET_BRIDGE="CVE-2024-44934"
CVE_NET_XEN_NETBACK="CVE-2024-49936"
CVE_NETFILTER="CVE-2024-44983"
CVE_NFSD_46696="CVE-2024-46696"
CVE_NFSD_50043="CVE-2024-50043"
CVE_NF_TABLES="CVE-2024-27020"
CVE_NILFS2="CVE-2024-42104"
CVE_NILFS2_47757="CVE-2024-47757"
CVE_NOUVEAU="CVE-2023-0030"
CVE_NTFS3_45896="CVE-2023-45896"
CVE_NVME_41073="CVE-2024-41073"
CVE_NVME_41079="CVE-2024-41079"
CVE_PCI_42302="CVE-2024-42302"
CVE_POWERCAP="CVE-2024-49862"
CVE_RTW88_0e735a4="UAF"
CVE_SCSI_SD="CVE-2024-47682"
CVE_SELINUX="CVE-2022-48740"
CVE_SMACK_47659="CVE-2024-47659"
CVE_SMB_46796="CVE-2024-46796"
CVE_SMB_49996="CVE-2024-49996"
CVE_SQUASHFS="CVE-2024-46744"
CVE_TIPC="CVE-2024-42284"
CVE_V3D="CVE-2024-46699"
CVE_VMCI="CVE-2024-46738"
CVE_VMWGFX="CVE-2022-22942"
CVE_XE_46683="CVE-2024-46683"
CVE_XE_49876="CVE-2024-49876"
CVE_XFS="CVE-2024-41014"

inherit mitigate-id toolchain-funcs

# Add RDEPEND+=" sys-kernel/mitigate-id" to downstream package if the downstream ebuild uses:
# JavaScript
# WebAssembly
# Keychains
# Passwords
# Digital currency wallets
# Databases that that typically store sensitive data

# It is used to mitigate against cross process exfiltration.

S="${WORKDIR}"

DESCRIPTION="Enforce Information Disclosure mitigations"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_v3d
	video_cards_vmware
)
IUSE+="
${VIDEO_CARDS[@]}
aacraid
acpi
aead
ata
ath11k
ath12k
bfq
bluetooth
bridge
btrfs
cdrom
cougar
ecdh
ext4
f2fs
fscache
fuse
hfsplus
hugetlbfs
iaa
ice
ima
ipv4
ipv6
iwlwifi
jfs
kvm
mlx5
mptcp
mt76
nfs
netfilter
nftables
nilfs2
ntfs
nvme
pci
powercap
rtw88
scsi-sd
samba
selinux
smack
squashfs
tipc
vmware
xen
xfs
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
# Double free # CVSS 7.8 # DoS, DT, ID
# Local privilege escalation, CVSS 7.8 # DoS, DT, ID
# Memory leak, CVSS 5.5 # DoS
# NULL pointer dereference, NPD, CVSS 5.5 # DoS
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
# mm - https://nvd.nist.gov/vuln/detail/CVE-2024-47745 # DoS, DT, ID
#
# aacraid? https://nvd.nist.gov/vuln/detail/CVE-2024-46673 # DoS, DT, ID
# acpi? https://nvd.nist.gov/vuln/detail/CVE-2024-49860 # DoS, ID
# aead? https://nvd.nist.gov/vuln/detail/CVE-2024-42229 # ID
# ata? https://nvd.nist.gov/vuln/detail/CVE-2024-41087 # DoS, DT, ID
# ath11k? https://nvd.nist.gov/vuln/detail/CVE-2024-49930 # DoS, DT, ID
# ath12k? https://nvd.nist.gov/vuln/detail/CVE-2024-49931 # DoS, DT, ID
# bfq? https://nvd.nist.gov/vuln/detail/CVE-2024-49854 # DoS, DT, ID UAF
# bfq? 18ad4df # Unofficial: DoS, DT, ID UAF # Added as a precaution
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2022-48878 # DoS, DT, ID
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2024-50029 # DoS, DT, ID
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-47675 # DoS, DT, ID
# bridge? https://nvd.nist.gov/vuln/detail/CVE-2024-44934 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46687 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-49869 # DoS, DT, ID
# bus? https://nvd.nist.gov/vuln/detail/CVE-2024-50055 # DoS, DT, ID
# cdrom? https://nvd.nist.gov/vuln/detail/CVE-2024-42136 # DoS, DT, ID
# cougar? https://nvd.nist.gov/vuln/detail/CVE-2024-46747 # DoS, DT, ID
# ecdh? https://nvd.nist.gov/vuln/detail/CVE-2024-46747 # Unofficial: ID
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-42257 # DoS, DT, ID
# ext4? c6b72f5 # Unofficial: DoS, DT, ID UAF # Added for precaution
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-49889 # DoS, DT, ID
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-49880 # DoS, DT, ID
# f2fs? https://nvd.nist.gov/vuln/detail/CVE-2024-44942 # DoS, DT, ID
# fs? https://nvd.nist.gov/vuln/detail/CVE-2024-43882 # EP, DoS, DT, ID
# fscache? https://nvd.nist.gov/vuln/detail/CVE-2024-46786 # DoS, DT, ID UAF
# fuse? https://nvd.nist.gov/vuln/detail/CVE-2024-44947 # ID
# hfsplus? https://nvd.nist.gov/vuln/detail/CVE-2024-41059 # DoS, DT, ID
# hugetlbfs? https://nvd.nist.gov/vuln/detail/CVE-2024-47676 # DoS, DT, ID
# iaa? https://nvd.nist.gov/vuln/detail/CVE-2024-47732 # DoS, DT, ID
# ice? https://nvd.nist.gov/vuln/detail/CVE-2024-46766 # DoS, DT, ID
# ima? https://nvd.nist.gov/vuln/detail/CVE-2024-39494 # DoS, DT, ID
# ima? https://nvd.nist.gov/vuln/detail/CVE-2022-21505 # DoS, DT, ID, PE
# ip? https://nvd.nist.gov/vuln/detail/CVE-2024-36971 # DoS, DT, ID
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-42154 # DoS, DT, ID
# ipv6? https://nvd.nist.gov/vuln/detail/CVE-2024-44987 # DoS, DT, ID, UAF
# iwlwifi? https://nvd.nist.gov/vuln/detail/CVE-2022-48787 # DoS, DT, ID
# jfs https://nvd.nist.gov/vuln/detail/CVE-2024-43858 # DoS, DT, ID
# jfs https://nvd.nist.gov/vuln/detail/CVE-2024-49903 # DoS, DT, ID
# kvm https://nvd.nist.gov/vuln/detail/CVE-2024-41070 # DoS, DT, ID
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2022-48858 # DoS, DT, ID
# mptcp? https://nvd.nist.gov/vuln/detail/CVE-2024-44974 # DoS, DT, ID
# mptcp? https://nvd.nist.gov/vuln/detail/CVE-2024-46858 # DoS, DT, ID
# mt76? https://nvd.nist.gov/vuln/detail/CVE-2024-42225 # DoS, DT, ID
# net? https://nvd.nist.gov/vuln/detail/CVE-2024-50036 # DoS, DT, ID
# nfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46696 # DoS, DT, ID
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-42104 # DoS, DT, ID
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-47757 # DoS, ID
# ntfs? https://nvd.nist.gov/vuln/detail/CVE-2023-45896 # DoS, ID; RH rated it DT (I:L)
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-41073 # DoS, DT, ID
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-41079 # ID
# netfilter? https://nvd.nist.gov/vuln/detail/CVE-2024-44983 # DoS, ID
# pci? https://nvd.nist.gov/vuln/detail/CVE-2024-42302 # DoS, DT, ID
# powercap? https://nvd.nist.gov/vuln/detail/CVE-2024-49862 # DoS, ID
# rtw88? # 0e735a4 Unofficial: DoS, DT, ID UAF # Added for precaution
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2022-48740 # DoS, DT, ID
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-46796 # DoS, DT, ID
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-49996 # DoS, DT, ID
# scsi-sd? https://nvd.nist.gov/vuln/detail/CVE-2024-47682 # DoS, DT, ID
# smack? https://nvd.nist.gov/vuln/detail/CVE-2024-47659 # DoS, DT, ID
# squashfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46744 # DoS, DT, ID
# tipc? https://nvd.nist.gov/vuln/detail/CVE-2024-42284 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46871 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-49989 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-49969 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-46683 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-49876 # DoS, DT, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2023-0030 # PE, ID, DoS, DT.  Fixed in >= 5.0.
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2021-20292 # PE, CE, ID, DoS, DT.  Fixed in >= 5.9.
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5586 # DoS, ID, DT, CE, PE
# video_cards_v3d? https://nvd.nist.gov/vuln/detail/CVE-2024-46699 # DoS, DT, ID
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2022-22942 # PE, DoS, DT, ID
# xfs? https://nvd.nist.gov/vuln/detail/CVE-2024-41014 # Unofficial: DoS.  RH added ID (C:L) ; Added to ID ebuild as a precaution.
# xen? https://nvd.nist.gov/vuln/detail/CVE-2024-49936 # DoS, DT, ID
#

#
# For Spectre v1, v2 mitigations, see https://nvidia.custhelp.com/app/answers/detail/a_id/4611
# It needs >=x11-drivers/nvidia-drivers-390.31 for V1, V2 mitigation.
# Now, we have these recent past drivers with vulnerabilities of the same class.
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports, so we prune
# those.  The other reason why we prune them is because they may leak sensitive
# debug info (ID) in plain text.
#
core_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BUS[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MM_47745[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_50036[@]}
}
fs_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FS[@]}
}
all_rdepend() {
	mitigate_id_rdepend
	if _use aacraid ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AACRAID[@]}
		fi
	fi
	if _use acpi ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ACPI[@]}
		fi
	fi
	if _use aead ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AEAD[@]}
		fi
	fi
	if _use ata ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATA_41087[@]}
		fi
	fi
	if _use ath11k ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATH11K_49930[@]}
		fi
	fi
	if _use ath12k ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATH12K_49931[@]}
		fi
	fi
	if _use bfq ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BFQ_49854[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BFQ_18ad4df[@]}
		fi
	fi
	if _use bluetooth ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_50029[@]}
		fi
	fi
	if _use bpf ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_47675[@]}
		fi
	fi
	if _use bridge ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_BRIDGE[@]}
		fi
	fi
	if _use btrfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_46687[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_49869[@]}
		fi
	fi
	if _use cdrom ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CDROM[@]}
		fi
	fi
	if _use cougar ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_COUGAR[@]}
		fi
	fi
	if _use ecdh ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ECDH[@]}
		fi
	fi
	if _use ext4 ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_42257[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_c6b72f5[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_49889[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_49880[@]}
		fi
	fi
	if _use f2fs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_F2FS[@]}
		fi
	fi
	if _use fscache ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FSCACHE[@]}
		fi
	fi
	if _use fuse ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FUSE[@]}
		fi
	fi
	if _use hfsplus ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HFSPLUS[@]}
		fi
	fi
	if _use hugetlbfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HUGETLBFS_47676[@]}
		fi
	fi
	if _use iaa ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IAA[@]}
		fi
	fi
	if _use ice ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ICE[@]}
		fi
	fi
	if _use ima ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IMA_39494[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IMA_21505[@]}
		fi
	fi
	if _use ipv4 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_42154[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]}
		fi
	fi
	if _use ipv6 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV6[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]}
		fi
	fi
	if _use jfs ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_43858[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_49903[@]}
		fi
	fi
	if _use kvm ; then
		if ! _use custom-kernel ; then
			if _use arm64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]}
			fi
			if _use ppc64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]}
			fi
		fi
	fi
	if _use mlx5 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5[@]}
		fi
	fi
	if _use mptcp ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MPTCP_44974[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MPTCP_46858[@]}
		fi
	fi
	if _use mt76 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT76[@]}
		fi
	fi
	if _use netfilter ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NETFILTER[@]}
			if _use ipv6 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV6_NETFILTER[@]}
			fi
		fi
	fi
	if _use nfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD_46696[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD_50043[@]}
		fi
	fi
	if _use nftables ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NF_TABLES[@]}
		fi
	fi
	if _use nilfs2 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2_47757[@]}
		fi
	fi
	if _use ntfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NTFS3_45896[@]}
		fi
	fi
	if _use nvme ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_41073[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_41079[@]}
		fi
	fi
	if _use pci ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PCI_42302[@]}
		fi
	fi
	if _use powercap ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_POWERCAP[@]}
		fi
	fi
	if _use rtw88 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RTW88_0e735a4[@]}
		fi
	fi
	if _use samba ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46796[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_49996[@]}
		fi
	fi
	if _use scsi-sd ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SCSI_SD[@]}
		fi
	fi
	if _use selinux ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SELINUX[@]}
		fi
	fi
	if _use smack ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMACK_47659[@]}
		fi
	fi
	if _use squashfs ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SQUASHFS[@]}
		fi
	fi
	if _use tipc ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TIPC[@]}
		fi
	fi
	if _use video_cards_amdgpu ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46725[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46871[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_49989[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_49969[@]}
		fi
	fi
	if _use video_cards_intel ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_I915[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE_46683[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE_49876[@]}
		fi
	fi
	if _use video_cards_nouveau ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NOUVEAU[@]}
		fi
	fi
	if _use video_cards_v3d ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_V3D[@]}
		fi
	fi
	if _use video_cards_vmware ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_VMWGFX[@]}
		fi
	fi
	if _use vmware ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_VMCI[@]}
		fi
	fi
	if _use xfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XFS[@]}
		fi
	fi
	if _use xen ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XEN_49936[@]}
		fi
	fi
	if ! _use custom-kernel ; then
		if _use zero-tolerance ; then
			gen_zero_tolerance_kernel_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]}
		fi
		core_rdepend
	fi
}
all_rdepend
RDEPEND="
	enforce? (
		!custom-kernel? (
			$(gen_render_kernels_list ${MULTISLOT_LATEST_KERNEL_RELEASE[@]})
		)
		video_cards_nvidia? (
			|| (
				>=x11-drivers/nvidia-drivers-565.57.01:0/565
				>=x11-drivers/nvidia-drivers-550.127.05:0/550
				>=x11-drivers/nvidia-drivers-535.216.01:0/535
				>=x11-drivers/nvidia-drivers-470.256.02:0/470
			)
			x11-drivers/nvidia-drivers:=
		)
	)
"
if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
	RDEPEND+="
		enforce? (
			firmware? (
				>=sys-firmware/intel-microcode-${_INTEL_MICROCODE_PV}
			)
		)
	"
fi
if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
	RDEPEND+="
		enforce? (
			firmware? (
				>=sys-kernel/linux-firmware-${_LINUX_FIRMWARE_PV}
			)
		)
	"
fi
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

	# Core
	check_kernel_version "bus" "${CVE_CORE}" ${MULTISLOT_KERNEL_CORE[@]}
	check_kernel_version "mm" "${CVE_MM_47745}" ${MULTISLOT_KERNEL_MM_47745[@]}
	check_kernel_version "net" "${CVE_NET_50036}" ${MULTISLOT_KERNEL_NET_50036[@]}

	if use aacraid ; then
		check_kernel_version "scsi/aacraid" "${CVE_AACRAID}" ${MULTISLOT_KERNEL_AACRAID[@]}
	fi
	if use acpi ; then
		check_kernel_version "acpi" "${CVE_ACPI}" ${MULTISLOT_KERNEL_ACPI[@]}
	fi
	if use aead ; then
		check_kernel_version "crypto/aead" "${CVE_AEAD}" ${MULTISLOT_KERNEL_AEAD[@]}
	fi
	if use ata ; then
		check_kernel_version "ata" "${CVE_ATA_41087}" ${MULTISLOT_KERNEL_ATA_41087[@]}
	fi
	if use ath11k ; then
		check_kernel_version "ath11k" "${CVE_ATH11K_49930}" ${MULTISLOT_KERNEL_ATH11K_49930[@]}
	fi
	if use ath12k ; then
		check_kernel_version "ath12k" "${CVE_ATH12K_49931}" ${MULTISLOT_KERNEL_ATH12K_49931[@]}
	fi
	if use bfq ; then
		check_kernel_version "bfq" "${CVE_BFQ_49854}" ${MULTISLOT_KERNEL_BFQ_49854[@]}
		check_kernel_version "bfq" "${CVE_BFQ_18ad4df}" ${MULTISLOT_KERNEL_BFQ_18ad4df[@]}
	fi
	if use bluetooth ; then
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_48878}" ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_50029}" ${MULTISLOT_KERNEL_BLUETOOTH_50029[@]}
	fi
	if use bpf ; then
		check_kernel_version "bpf" "${CVE_BPF_47675}" ${MULTISLOT_KERNEL_BPF_47675[@]}
	fi
	if use bridge ; then
		check_kernel_version "net/bridge" "${CVE_NET_BRIDGE}" ${MULTISLOT_KERNEL_NET_BRIDGE[@]}
	fi
	if use btrfs ; then
		fs=1
		check_kernel_version "btrfs" "${CVE_BTRFS_46687}" ${MULTISLOT_KERNEL_BTRFS_46687[@]}
		check_kernel_version "btrfs" "${CVE_BTRFS_49869}" ${MULTISLOT_KERNEL_BTRFS_49869[@]}
	fi
	if use cdrom ; then
		check_kernel_version "cdrom" "${CVE_CDROM}" ${MULTISLOT_KERNEL_CDROM[@]}
	fi
	if use cougar ; then
		check_kernel_version "hid/hid-cougar" "${CVE_COUGAR}" ${MULTISLOT_KERNEL_COUGAR[@]}
	fi
	if use ecdh ; then
		check_kernel_version "crypto/ecdh" "${CVE_ECDH}" ${MULTISLOT_KERNEL_ECDH[@]}
	fi
	if use ext4 ; then
		fs=1
		check_kernel_version "ext4" "${CVE_EXT4_42257}" ${MULTISLOT_KERNEL_EXT4_42257[@]}
		check_kernel_version "ext4" "${CVE_EXT4_c6b72f5}" ${MULTISLOT_KERNEL_c6b72f5[@]}
		check_kernel_version "ext4" "${CVE_EXT4_49889}" ${MULTISLOT_KERNEL_49889[@]}
		check_kernel_version "ext4" "${CVE_EXT4_49880}" ${MULTISLOT_KERNEL_49880[@]}
	fi
	if use f2fs ; then
		fs=1
		check_kernel_version "f2fs" "${CVE_F2FS}" ${MULTISLOT_KERNEL_F2FS[@]}
	fi
	if use fscache ; then
		fs=1
		check_kernel_version "fscache" "${CVE_FSCACHE}" ${MULTISLOT_KERNEL_FSCACHE[@]}
	fi
	if use fuse ; then
		fs=1
		check_kernel_version "fuse" "${CVE_FUSE}" ${MULTISLOT_KERNEL_FUSE[@]}
	fi
	if use hfsplus ; then
		fs=1
		check_kernel_version "hfsplus" "${CVE_HFSPLUS}" ${MULTISLOT_KERNEL_HFSPLUS[@]}
	fi
	if use hugetlbfs ; then
		fs=1
		check_kernel_version "hugetlbfs" "${CVE_HUGETLBFS_47676}" ${MULTISLOT_KERNEL_HUGETLBFS_47676[@]}
	fi
	if use iaa ; then
		check_kernel_version "crypto/iaa" "${CVE_IAA}" ${MULTISLOT_KERNEL_IAA[@]}
	fi
	if use ice ; then
		check_kernel_version "net/ethernet/intel/ice" "${CVE_ICE}" ${MULTISLOT_KERNEL_ICE[@]}
	fi
	if use ima ; then
		check_kernel_version "ima" "${CVE_IMA_39494}" ${MULTISLOT_KERNEL_IMA_39494[@]}
		check_kernel_version "ima" "${CVE_IMA_21505}" ${MULTISLOT_KERNEL_IMA_21505[@]}
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
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI}" ${MULTISLOT_KERNEL_IWLWIFI[@]}
	fi
	if use jfs ; then
		fs=1
		check_kernel_version "jfs" "${CVE_JFS_43858}" ${MULTISLOT_KERNEL_JFS_43858[@]}
		check_kernel_version "jfs" "${CVE_JFS_49903}" ${MULTISLOT_KERNEL_JFS_49903[@]}
	fi
	if use kvm ; then
		if use arm64 ; then
			check_kernel_version "arm64/kvm" "${CVE_KVM_ARM64_26598}" ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]}
		elif use ppc64 ; then
			check_kernel_version "powerpc/kvm" "${CVE_KVM_POWERPC_41070}" ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]}
		fi
	fi
	if use mlx5 ; then
		check_kernel_version "mlx5" "${CVE_MLX5}" ${MULTISLOT_KERNEL_MLX5[@]}
	fi
	if use mptcp ; then
		check_kernel_version "mptcp" "${CVE_MPTCP_44974}" ${MULTISLOT_KERNEL_MPTCP_44974[@]}
		check_kernel_version "mptcp" "${CVE_MPTCP_46858}" ${MULTISLOT_KERNEL_MPTCP_46858[@]}
	fi
	if use mt76 ; then
		check_kernel_version "mt76" "${CVE_MT76}" ${MULTISLOT_KERNEL_MT76[@]}
	fi
	if use nfs ; then
		fs=1
		check_kernel_version "nfsd" "${CVE_NFSD_46696}" ${MULTISLOT_KERNEL_NFSD_46696[@]}
		check_kernel_version "nfsd" "${CVE_NFSD_50043}" ${MULTISLOT_KERNEL_NFSD_50043[@]}
	fi
	if use netfilter ; then
		check_kernel_version "netfilter" "${CVE_NETFILTER}" ${MULTISLOT_KERNEL_NETFILTER[@]}
		if use ipv6 ; then
			check_kernel_version "net/ipv6/netfilter" "${CVE_IPV6_NETFILTER}" ${MULTISLOT_KERNEL_IPV6_NETFILTER[@]}
		fi
	fi
	if use nftables ; then
		check_kernel_version "nftables" "${CVE_NF_TABLES}" ${MULTISLOT_KERNEL_NF_TABLES[@]}
	fi
	if use nilfs2 ; then
		check_kernel_version "nilfs2" "${CVE_NILFS2}" ${MULTISLOT_KERNEL_NILFS2[@]}
		check_kernel_version "nilfs2" "${CVE_NILFS2_47757}" ${MULTISLOT_KERNEL_NILFS2_47757[@]}
	fi
	if use ntfs ; then
		fs=1
		check_kernel_version "ntfs3" "${CVE_NTFS3_45896}" ${MULTISLOT_KERNEL_NTFS3_45896[@]}
	fi
	if use nvme ; then
		check_kernel_version "nvme" "${CVE_NVME_41073}" ${MULTISLOT_KERNEL_NVME_41073[@]}
		check_kernel_version "nvme" "${CVE_NVME_41079}" ${MULTISLOT_KERNEL_NVME_41079[@]}
	fi
	if use pci ; then
		check_kernel_version "pci" "${CVE_PCI_42302}" ${MULTISLOT_KERNEL_PCI_42302[@]}
	fi
	if use powercap ; then
		check_kernel_version "powercap" "${CVE_POWERCAP}" ${MULTISLOT_KERNEL_POWERCAP[@]}
	fi
	if use rtw88 ; then
		check_kernel_version "rtw88" "${CVE_RTW88_0e735a4}" ${MULTISLOT_KERNEL_RTW88_0e735a4[@]}
	fi
	if use samba ; then
		fs=1
		check_kernel_version "smb" "${CVE_SMB_46796}" ${MULTISLOT_KERNEL_SMB_46796[@]}
		check_kernel_version "smb" "${CVE_SMB_49996}" ${MULTISLOT_KERNEL_SMB_49996[@]}
	fi
	if use scsi-sd ; then
		check_kernel_version "scsi/sd" "${CVE_SCSI_SD}" ${MULTISLOT_KERNEL_SCSI_SD[@]}
	fi
	if use selinux ; then
		check_kernel_version "selinux" "${CVE_SELINUX}" ${MULTISLOT_KERNEL_SELINUX[@]}
	fi
	if use smack ; then
		check_kernel_version "smack" "${CVE_SMACK_47659}" ${MULTISLOT_KERNEL_SMACK_47659[@]}
	fi
	if use squashfs ; then
		fs=1
		check_kernel_version "squashfs" "${CVE_SQUASHFS}" ${MULTISLOT_KERNEL_SQUASHFS[@]}
	fi
	if use tipc ; then
		check_kernel_version "tipc" "${CVE_TIPC}" ${MULTISLOT_KERNEL_TIPC[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46725}" ${MULTISLOT_KERNEL_AMDGPU_46725[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46871}" ${MULTISLOT_KERNEL_AMDGPU_46871[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_49989}" ${MULTISLOT_KERNEL_AMDGPU_49989[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_49969}" ${MULTISLOT_KERNEL_AMDGPU_49969[@]}
	fi
	if use video_cards_intel ; then
		check_kernel_version "i915" "${CVE_I915}" ${MULTISLOT_KERNEL_I915[@]}
		check_kernel_version "xe" "${CVE_XE_46683}" ${MULTISLOT_KERNEL_XE_46683[@]}
		check_kernel_version "xe" "${CVE_XE_49876}" ${MULTISLOT_KERNEL_XE_49876[@]}
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
	if use xen ; then
		check_kernel_version "xen/xen-netback" "${CVE_XEN_49936}" ${MULTISLOT_KERNEL_XEN_49936[@]}
	fi
	if use xfs ; then
		fs=1
		check_kernel_version "xfs" "${CVE_XFS}" ${MULTISLOT_KERNEL_XFS[@]}
	fi
	if (( ${fs} == 1 )) ; then
		check_kernel_version "fs" "${CVE_FS}" ${MULTISLOT_KERNEL_FS[@]}
	fi
}

pkg_setup() {
	mitigate-id_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP) and may be renamed."
	check_drivers
}

src_compile() {
	use enforce || ewarn "The USE enforce flag is disabled."
	use enforce || return
	tc-is-cross-compiler && return
einfo "Checking for mitigations against Information Disclosure based Transient Execution Vulnerabilities (e.g. Meltdown/Spectre)"
	if lscpu | grep -q "Vulnerable" ; then
eerror "FAIL:  Detected an unmitigated CPU vulnerability."
eerror "Fix issues to continue."
		lscpu
		die
	else
einfo "PASS"
	fi
}

pkg_postinst() {
	use enforce || return
einfo "The optional sys-kernel/mitigate-dos is also provided and can be emerged directly."
einfo "The optional sys-kernel/mitigate-dt is also provided and can be emerged directly."
}
