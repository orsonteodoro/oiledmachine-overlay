# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
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
_XEN_PV=0

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
MULTISLOT_KERNEL_LOCKING=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_MM_46847=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_MM_47674=("6.1.111" "6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_MM_47745=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_SCHED_44958=("5.15.165" "6.1.105" "6.6.46" "6.10.5" "6.11_rc2")
MULTISLOT_KERNEL_KTHREAD=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.3" "6.11.2")

# Arch specific
MULTISLOT_KERNEL_PARISC_40918=("6.6.35" "6.9.6" "6.10_rc4")
MULTISLOT_KERNEL_POWERPC_46797=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_KVM_ARM64_26598=("5.4.269" "5.10.209" "5.15.148" "6.1.75" "6.6.14" "6.7.2" "6.8_rc1")
MULTISLOT_KERNEL_KVM_ARM64_46707=("5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_KVM_POWERPC_41070=("5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.10")
MULTISLOT_KERNEL_KVM_RISCV_47d40d9=("6.10.13" "6.11.2")
MULTISLOT_KERNEL_KVM_S390_43819=("6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_KVM_X86_39483=("6.4" "6.6.34" "6.9.5" "6.10_rc3")

# More than one row is added to increase LTS coverage.
MULTISLOT_KERNEL_AACRAID=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.108" "6.6.49" "6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_ACPI=("5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_AMDGPU_46725=("5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_46851=("5.10.V" "5.15.V" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_46850=("6.10.11" "6.11")
MULTISLOT_KERNEL_AMDGPU_47661=("6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_47683=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_AMDGPU_46871=("6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_AMDGPU_49989=("6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_AMDGPU_49969=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_APPARMOR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_ATA_41087=("4.19.317" "5.4.279" "5.10.221" "5.15.162" "6.1.97" "6.6.37" "6.9.8" "6.10")
MULTISLOT_KERNEL_ATH11K_49930=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_ATH12K_46827=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_ATH12K_49931=("6.6.55" "6.10.14" "6.11.3")
MULTISLOT_KERNEL_BFQ_49854=("5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_BFQ_18ad4df=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_BLOCK_43854=("5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_BLUETOOTH_46749=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_BLUETOOTH_48878=("5.10.165" "5.15.90" "6.1.8" "6.2")
MULTISLOT_KERNEL_BLUETOOTH_50029=("6.6.57" "6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_BPF_45020=("6.6.48" "6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_BPF_49850=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_BPF_47675=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_BPF_49861=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_BRCM80211=("6.6.48" "6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_BTRFS_46687=("6.6.49" "6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_BTRFS_46841=("6.10.10" "6.11")
MULTISLOT_KERNEL_BTRFS_49869=("6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_BUS=("6.6.57" "6.11.4" "6.12_rc1")
MULTISLOT_KERNEL_CCP=("6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_CDROM=("6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_CFG80211=("5.10.244" "5.15.165" "6.1.106" "6.6.47" "6.9.9" "6.10")
MULTISLOT_KERNEL_COUGAR=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_CPUSET=("6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_CRYPTO_KEYS=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_HFS=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3")
MULTISLOT_KERNEL_HFSPLUS=("4.19.319" "5.4.281" "5.10.223" "5.15.164" "6.1.101" "6.6.42" "6.9.11")
MULTISLOT_KERNEL_EXFAT_47677=("6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_EXFAT_50013=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_EXT4_43828=("5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_EXT4_c6b72f5=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_EXT4_49889=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_EXT4_49880=("6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_F2FS_44942=("6.6.47" "6.10.6" "6.11_rc1")
MULTISLOT_KERNEL_F2FS_930c6ab=("6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_F2FS_49859=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_FS_43882=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.106" "6.6.47" "6.10.6" "6.11_rc4")
MULTISLOT_KERNEL_FS_46701=("6.10.7" "6.11" "6.11_rc4")
MULTISLOT_KERNEL_FSCACHE=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_FUSE_47746=("6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_HUGETLBFS_47676=("6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_HYPERV=("5.10.V" "5.15.V" "6.1.V" "6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_I40E=("4.19.313" "5.4.275" "5.10.216" "5.15.158" "6.1.90" "6.6.30" "6.8.9" "6.9")
MULTISLOT_KERNEL_I915=("5.10.221" "5.15.162" "6.1.97" "6.6.37" "6.9.8" "6.10")
MULTISLOT_KERNEL_IAA=("6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_ICE=("6.10.10" "6.11")
MULTISLOT_KERNEL_IGB=("6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_IGC=("5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_IMA_40947=("6.1.98" "6.6.39" "6.9.7" "6.10_rc5")
MULTISLOT_KERNEL_IMA_21505=("5.4.208" "5.15.58" "6.1" "6.6" "6.10" "6.11")
MULTISLOT_KERNEL_IOMMU_IOPF=("6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_IPV4_36927=("4.14.315" "4.19.283" "5.4.243" "5.10.180" "5.15.111" "6.1.28" "6.2.15" "6.3.2" "6.6.31" "6.8.10" "6.9")
MULTISLOT_KERNEL_IPV4_41041=("4.19.V" "5.4.280" "5.10.222" "5.15.163" "6.1.100" "6.6.41" "6.10" "6.11")
MULTISLOT_KERNEL_IPV4_42154=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_IPV4_44991=("6.1.107" "6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_IPV6_44987=("4.19.321" "5.4.283" "5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_IPV6_04ccecf=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_IPV6_NETFILTER=("5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_IP_36971=("4.19.316" "5.4.278" "5.10.219" "5.15.161" "6.1.94" "6.6.34" "6.9.4" "6.10_rc2")
MULTISLOT_KERNEL_IVTV=("6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_IWLWIFI_48918=("5.15.27" "5.16.13" "5.17")
MULTISLOT_KERNEL_IWLWIFI_48787=("4.14.268" "4.19.231" "5.4.181" "5.10.102" "5.15.25" "5.16.11")
MULTISLOT_KERNEL_IWLWIFI_49857=("6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_JFS_43858=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_JFS_44938=("6.6.47" "6.10.6" "6.11_rc1")
MULTISLOT_KERNEL_JFS_MULTISLOT_KERNEL_JFS_e63866a=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_JFS_49903=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_KVM_47744=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_LANDLOCK=("6.1.95" "6.6.35" "6.9.6" "6.10_rc2")
MULTISLOT_KERNEL_MD_RAID1=("6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_MD_RAID456=("5.15.V" "6.1.V" "6.6.V" "6.7.12" "6.8.3" "6.9_rc1" "6.10" "6.11")
MULTISLOT_KERNEL_MD_RAID5=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.105" "6.6.46" "6.10.5" "6.11_rc1")
MULTISLOT_KERNEL_MLX5_45019=("6.1.107" "6.6.48" "6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_MLX5_46857=("6.1.111" "6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_MLX5_112e6e8=("6.11.2")
MULTISLOT_KERNEL_MPTCP_46858=("6.1.111" "6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_MSM=("6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_MT76=("5.15.163" "6.1.98" "6.6.39" "6.9.9" "6.10")
MULTISLOT_KERNEL_MT76_862bf7c=("6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_MT7921=("6.6.52" "6.10.11" "6.11")
MULTISLOT_KERNEL_MT7925_9679ca7=("6.10.13" "6.11.2")
MULTISLOT_KERNEL_MT7996E_47681=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_MWIFIEX=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_NTFS3_45896=("5.15.V" "6.1.V" "6.6" "6.10" "6.11")
MULTISLOT_KERNEL_NTFS3_42299=("6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_NET_50036=("6.6.57" "6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_NET_BRIDGE=("5.15.165" "6.1.105" "6.6.46" "6.10.5" "6.11_rc3")
MULTISLOT_KERNEL_NET_SOCK_MSG_46783=("5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_NET_XEN_NETBACK=("5.10.227" "5.15.168" "6.1.113" "6.6.55" "6.10.14" "6.11.3" "6.12_rc1")
MULTISLOT_KERNEL_NILFS2_46781=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_NILFS2_47757=("4.19.V" "5.4.V" "5.10.227" "5.15.168" "6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_NILFS2_47669=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_NFSD_46696=("6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_NFSD_22451a1=("5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_NFSD_50043=("6.11.4" "6.12_rc3")
MULTISLOT_KERNEL_NVME_45013=("6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_NVME_41073=("5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.10")
MULTISLOT_KERNEL_NOUVEAU=("6.6.48" "6.10.7" "6.11_rc5")
MULTISLOT_KERNEL_MAC80211=("6.10.5" "6.11_rc1")
MULTISLOT_KERNEL_NETFILTER=("5.10.225" "5.15.166" "6.1.107" "6.6.48" "6.10.7" "6.11_rc4")
MULTISLOT_KERNEL_NF_TABLES=("4.19.313" "5.4.275" "5.10.216" "5.15.157" "6.1.88" "6.6.29" "6.8.8" "6.9_rc5")
MULTISLOT_KERNEL_PCI_46750=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_PCI_42302=("5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_PCI_HOTPLUG_46761=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_POWERCAP=("6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_QAT_cd8d2d7=("6.10.13" "6.11.2")
MULTISLOT_KERNEL_RADEON=("5.15.164" "6.1.101" "6.6.42" "6.9.11" "6.10")
MULTISLOT_KERNEL_RTW88_46760=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_RTW88_0e735a4=("5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2")
MULTISLOT_KERNEL_SCSI_SD=("6.1.113" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_SCTP=("5.4.282" "5.10.224" "5.15.165" "6.1.105" "6.6.46" "6.10.5" "6.11_rc3")
MULTISLOT_KERNEL_SELINUX=("5.10.99" "5.15.22" "5.16.8" "5.17")
MULTISLOT_KERNEL_SMACK_47659=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.109" "6.6.50" "6.10.9" "6.11")
MULTISLOT_KERNEL_SMB_46796=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_SMB_46795=("5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_SMB_49996=("6.6.55" "6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_SQUASHFS=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_TCP_47684=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.54" "6.10.13" "6.11.2" "6.12_rc1")
MULTISLOT_KERNEL_TIPC=("4.19.320" "5.4.282" "5.10.224" "5.15.165" "6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_TLS=("5.10.219" "5.15.161" "6.1.93" "6.6.33" "6.9.4" "6.10_rc1")
MULTISLOT_KERNEL_USB=("4.19.318" "5.4.280" "5.10.222" "5.15.163" "6.1.100" "6.6.41" "6.9.10" "6.10")
MULTISLOT_KERNEL_V3D=("6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_V4L2_43833=("6.1.103" "6.6.44" "6.10.3" "6.11_rc1")
MULTISLOT_KERNEL_VMCI=("4.19.322" "5.4.284" "5.10.226" "5.15.167" "6.1.110" "6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_VMWGFX=("6.6.49" "6.9" "6.10.8" "6.11_rc6")
MULTISLOT_KERNEL_VMXNET3=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.35" "6.10_rc3" "6.11")
MULTISLOT_KERNEL_WIREGUARD=("5.10.222" "5.15.163" "6.1.100" "6.6.41" "6.9.10" "6.10")
MULTISLOT_KERNEL_XE_46683=("6.10.8" "6.11_rc5")
MULTISLOT_KERNEL_XE_46867=("6.10.11" "6.11")
MULTISLOT_KERNEL_XE_49876=("6.10.14" "6.11.3" "6.12_rc2")
MULTISLOT_KERNEL_XEN_46762=("6.6.51" "6.10.10" "6.11")
MULTISLOT_KERNEL_XFS=("4.19.V" "5.4.V" "5.10.V" "5.15.V" "6.1.V" "6.6.V" "6.10.V" "6.11_rc1")

CVE_AACRAID="CVE-2024-46673"
CVE_ACPI="CVE-2024-49860"
CVE_AMDGPU_46725="CVE-2024-46725"
CVE_AMDGPU_46851="CVE-2024-46851"
CVE_AMDGPU_46850="CVE-2024-46850"
CVE_AMDGPU_47661="CVE-2024-47661"
CVE_AMDGPU_47683="CVE-2024-47683"
CVE_AMDGPU_46871="CVE-2024-46871"
CVE_AMDGPU_49989="CVE-2024-49989"
CVE_AMDGPU_49969="CVE-2024-49969"
CVE_APPARMOR="CVE-2024-46721"
CVE_ATA_41087="CVE-2024-41087"
CVE_ATH11K_49930="CVE-2024-49930"
CVE_ATH12K_46827="CVE-2024-46827"
CVE_ATH12K_49931="CVE-2024-49931"
CVE_BFQ_49854="CVE-2024-49854"
CVE_BFQ_18ad4df="UAF"
CVE_BLOCK_43854="CVE-2024-43854"
CVE_BLUETOOTH_46749="CVE-2024-46749"
CVE_BLUETOOTH_48878="CVE-2022-48878"
CVE_BLUETOOTH_50029="CVE-2024-50029"
CVE_BPF_45020="CVE-2024-45020"
CVE_BPF_49850="CVE-2024-49850"
CVE_BPF_47675="CVE-2024-47675"
CVE_BPF_49861="CVE-2024-49861"
CVE_BRCM80211="CVE-2024-46672"
CVE_BTRFS_46687="CVE-2024-46687"
CVE_BTRFS_46841="CVE-2024-46841"
CVE_BUS="CVE-2024-50055"
CVE_CCP="CVE-2024-43874"
CVE_CDROM="CVE-2024-42136"
CVE_CFG80211="CVE-2024-42114"
CVE_COUGAR="CVE-2024-46747"
CVE_CPUSET="CVE-2024-44975"
CVE_CRYPTO_KEYS="CVE-2024-47743"
CVE_EXFAT_47677="CVE-2024-47677"
CVE_EXFAT_50013="CVE-2024-50013"
CVE_EXT4_43828="CVE-2024-43828"
CVE_EXT4_c6b72f5="OOB or UAF"
CVE_EXT4_49889="CVE-2024-49889"
CVE_EXT4_49880="CVE-2024-49880"
CVE_F2FS_44942="CVE-2024-44942"
CVE_F2FS_49859="CVE-2024-49859"
CVE_F2FS_930c6ab="RC"
CVE_FS_43882="CVE-2024-43882"
CVE_FS_46701="CVE-2024-46701"
CVE_FSCACHE="CVE-2024-46786"
CVE_FUSE_47746="CVE-2024-47746"
CVE_HFS="CVE-2024-42311"
CVE_HFSPLUS="CVE-2024-41059"
CVE_HUGETLBFS_47676="CVE-2024-47676"
CVE_HYPERV="CVE-2024-46864"
CVE_I40E="CVE-2024-36004"
CVE_I915="CVE-2024-41092"
CVE_IAA="CVE-2024-47732"
CVE_ICE="CVE-2024-46766"
CVE_IGB="CVE-2024-45030"
CVE_IGC="CVE-2024-42116"
CVE_IMA_40947="CVE-2024-40947"
CVE_IMA_21505="CVE-2022-21505" # unlisted
CVE_IOMMU_IOPF="CVE-2024-44994"
CVE_IPV4_36927="CVE-2024-36927"
CVE_IPV4_41041="CVE-2024-41041"
CVE_IPV4_42154="CVE-2024-42154"
CVE_IPV4_44991="CVE-2024-44991"
CVE_IPV6_44987="CVE-2024-44987"
CVE_IPV6_04ccecf="NPD"
CVE_IPV6_NETFILTER="CVE-2024-47685"
CVE_IP_36971="CVE-2024-36971"
CVE_IVTV="CVE-2024-43877"
CVE_IWLWIFI_48918="CVE-2022-48918"
CVE_IWLWIFI_48787="CVE-2022-48787"
CVE_IWLWIFI_49857="CVE-2024-49857"
CVE_JFS_43858="CVE-2024-43858"
CVE_JFS_e63866a="OOB"
CVE_JFS_44938="CVE-2024-44938"
CVE_JFS_49903="CVE-2024-49903"
CVE_KTHREAD="RC"
CVE_KVM_47744="CVE-2024-47744"
CVE_KVM_ARM64_26598="CVE-2024-26598"
CVE_KVM_ARM64_46707="CVE-2024-46707"
CVE_KVM_POWERPC_41070="CVE-2024-41070"
CVE_KVM_RISCV_47d40d9="NPD"
CVE_KVM_S390_43819="CVE-2024-43819"
CVE_KVM_X86_39483="CVE-2024-39483"
CVE_LOCKING="CVE-2024-46829"
CVE_LANDLOCK="CVE-2024-40938"
CVE_MAC80211="CVE-2024-43911"
CVE_MD_RAID1="CVE-2024-45023"
CVE_MD_RAID5="CVE-2024-43914"
CVE_MD_RAID456="CVE-2024-26962"
CVE_MM_46847="CVE-2024-46847"
CVE_MM_47674="CVE-2024-47674"
CVE_MM_47745="CVE-2024-47745"
CVE_NET_50036="CVE-2024-50036"
CVE_NET_BRIDGE="CVE-2024-44934"
CVE_NFSD_46696="CVE-2024-46696"
CVE_NFSD_22451a1="NPD"
CVE_NFSD_50043="CVE-2024-50043"
CVE_MLX5_45019="CVE-2024-45019"
CVE_MLX5_46857="CVE-2024-46857"
CVE_MLX5_112e6e8="NPD"
CVE_MSM="CVE-2024-45015"
CVE_MPTCP_46858="CVE-2024-46858"
CVE_MT76="CVE-2024-42225"
CVE_MT76_862bf7c="OOPS"
CVE_MT7925_9679ca7="OOB"
CVE_MT7921="CVE-2024-46860"
CVE_MT7996E_47681="CVE-2024-47681"
CVE_MWIFIEX="CVE-2024-46755"
CVE_NETFILTER="CVE-2024-45018"
CVE_NET_SOCK_MSG_46783="CVE-2024-46783"
CVE_NET_XEN_NETBACK="CVE-2024-49936"
CVE_NF_TABLES="CVE-2024-27020"
CVE_NILFS2_46781="CVE-2024-46781"
CVE_NILFS2_47757="CVE-2024-47757"
CVE_NILFS2_47669="CVE-2024-47669"
CVE_NOUVEAU="CVE-2024-45012"
CVE_NTFS3_45896="CVE-2023-45896"
CVE_NTFS3_42299="CVE-2024-42299"
CVE_NVME_45013="CVE-2024-45013"
CVE_NVME_41073="CVE-2024-41073"
CVE_RADEON="CVE-2024-41060"
CVE_PARISC_40918="CVE-2024-40918"
CVE_PCI_46750="CVE-2024-46750"
CVE_PCI_42302="CVE-2024-42302"
CVE_PCI_HOTPLUG_46761="CVE-2024-46761"
CVE_POWERCAP="CVE-2024-49862"
CVE_POWERPC_46797="CVE-2024-46797"
CVE_QAT_cd8d2d7="RC"
CVE_RTW88_46760="CVE-2024-46760"
CVE_RTW88_0e735a4="UAF"
CVE_SCHED_44958="CVE-2024-44958"
CVE_SCSI_SD="CVE-2024-47682"
CVE_SCTP="CVE-2024-44935"
CVE_SELINUX="CVE-2022-48740"
CVE_SMACK_47659="CVE-2024-47659"
CVE_SMB_46796="CVE-2024-46796"
CVE_SMB_46795="CVE-2024-46795"
CVE_SMB_49996="CVE-2024-49996"
CVE_SQUASHFS="CVE-2024-46744"
CVE_TCP_47684="CVE-2024-47684"
CVE_TIPC="CVE-2024-42284"
CVE_TLS="CVE-2024-36489"
CVE_USB="CVE-2024-41035"
CVE_V3D="CVE-2024-46699"
CVE_V4L2_43833="CVE-2024-43833"
CVE_VMCI="CVE-2024-46738"
CVE_VMWGFX="CVE-2024-46709"
CVE_VMXNET3="CVE-2024-40923"
CVE_WIREGUARD="CVE-2024-42247"
CVE_XE_46683="CVE-2024-46683"
CVE_XE_46867="CVE-2024-46867"
CVE_XE_49876="CVE-2024-49876"
CVE_XEN_46762="CVE-2024-46762"
CVE_XFS="CVE-2024-41014"

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
IUSE+="
${VIDEO_CARDS[@]}
aacraid
acpi
ata
ath11k
ath12k
apparmor
bcrm80211
bfq
bluetooth
bpf
bpf-stream-parser
bridge
btrfs
cdrom
ccp
cougar
cpuset
crypto-keys
esp-in-tcp
exfat
ext4
f2fs
fscache
fuse
hfs
hfsplus
hugetlbfs
hyperv
i40e
iaa
ice
igb
igc
ima
ipv4
ipv6
ivtv
iwlwifi
kvm
jfs
landlock
samba
max-uptime
mptcp
md-raid1
md-raid456
md-raid5
mlx5
mt76
mt7921
mt7925
mt7996e
mwifiex
netfilter
nfs
nftables
nilfs2
ntfs
nvme
pci
pci-hotplug
powercap
qat
rtw88
scsi-sd
sctp
selinux
smack
smmu-v3-sva
squashfs
tcp
tipc
tls
usb
v4l2
vmware
wireguard
xen
xfs
"
REQUIRED_USE="
	bpf-stream-parser? (
		ipv4
	)
	esp-in-tcp? (
		ipv4
	)
	ipv6? (
		ipv4
	)
	pci-hotplug? (
		pci
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
# locking - https://nvd.nist.gov/vuln/detail/CVE-2024-46829 # DoS
# mm - https://nvd.nist.gov/vuln/detail/CVE-2024-46847 # DoS
# mm - https://nvd.nist.gov/vuln/detail/CVE-2024-47674 # DoS
# mm - https://nvd.nist.gov/vuln/detail/CVE-2024-47745 # DoS, DT, ID
# sched - https://nvd.nist.gov/vuln/detail/CVE-2024-44958 # DoS
# workqueue - https://nvd.nist.gov/vuln/detail/CVE-2024-46839 # Rejected
#
# aacraid? https://nvd.nist.gov/vuln/detail/CVE-2024-46673 # DoS, DT, ID
# acpi? https://nvd.nist.gov/vuln/detail/CVE-2024-49860 # DoS, ID
# apparmor? https://nvd.nist.gov/vuln/detail/CVE-2024-46721 # DoS
# ata? https://nvd.nist.gov/vuln/detail/CVE-2024-41087 # DoS, DT, ID
# ath11k? https://nvd.nist.gov/vuln/detail/CVE-2024-49930 # DoS, DT, ID
# ath12k? https://nvd.nist.gov/vuln/detail/CVE-2024-46827 # Unofficial: DoS
# ath12k? https://nvd.nist.gov/vuln/detail/CVE-2024-49931 # DoS, DT, ID
# bcrm80211? https://nvd.nist.gov/vuln/detail/CVE-2024-46672 # DoS
# bfq? https://nvd.nist.gov/vuln/detail/CVE-2024-49854 # DoS, DT, ID UAF
# bfq? 18ad4df # Unofficial: DoS, DT, ID UAF # Added as a precaution
# block? https://nvd.nist.gov/vuln/detail/CVE-2024-43854 # DoS
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2024-46749 # DoS
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2022-48878 # DoS, DT, ID
# bluetooth? https://nvd.nist.gov/vuln/detail/CVE-2024-50029 # DoS, DT, ID
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-45020 # DoS
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-46783 # DoS
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-49850 # DoS
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-47675 # DoS, DT, ID
# bpf? https://nvd.nist.gov/vuln/detail/CVE-2024-49861 # DoS, DT
# bridge? https://nvd.nist.gov/vuln/detail/CVE-2024-44934 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46841 # DoS
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46687 # DoS, DT, ID
# btrfs? https://nvd.nist.gov/vuln/detail/CVE-2024-49869 # DoS, DT, ID
# bus? https://nvd.nist.gov/vuln/detail/CVE-2024-50055 # DoS, DT, ID
# ccp? https://nvd.nist.gov/vuln/detail/CVE-2024-43874 # DoS
# cdrom? https://nvd.nist.gov/vuln/detail/CVE-2024-42136 # DoS, DT, ID
# cfg80211? https://nvd.nist.gov/vuln/detail/CVE-2024-42114 # DoS
# cougar? https://nvd.nist.gov/vuln/detail/CVE-2024-46747 # DoS, DT, ID
# cpuset? https://nvd.nist.gov/vuln/detail/CVE-2024-44975 # DoS
# crypto-keys? https://nvd.nist.gov/vuln/detail/CVE-2024-47743 # DoS
# exfat? https://nvd.nist.gov/vuln/detail/CVE-2024-47677 # DoS
# exfat? https://nvd.nist.gov/vuln/detail/CVE-2024-50013 # DoS
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-43828 # DoS
# ext4? c6b72f5 # Unofficial: DoS, DT, ID UAF
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-49889 # DoS, DT, ID
# ext4? https://nvd.nist.gov/vuln/detail/CVE-2024-49880 # DoS, DT, ID
# f2fs? https://nvd.nist.gov/vuln/detail/CVE-2024-44942 # DoS, DT, ID
# f2fs? https://nvd.nist.gov/vuln/detail/CVE-2024-49859 # DoS
# f2fs? 930c6ab # Unofficial: DoS
# fs? https://nvd.nist.gov/vuln/detail/CVE-2024-43882 # EP, DoS, DT, ID
# fs? https://nvd.nist.gov/vuln/detail/CVE-2024-46701 # DoS
# fscache? https://nvd.nist.gov/vuln/detail/CVE-2024-46786 # DoS, DT, ID UAF
# fuse? https://nvd.nist.gov/vuln/detail/CVE-2024-47746 # DoS
# i40e? https://nvd.nist.gov/vuln/detail/CVE-2024-36004 # Unofficial: DoS
# igb? https://nvd.nist.gov/vuln/detail/CVE-2024-45030 # DoS
# igc? https://nvd.nist.gov/vuln/detail/CVE-2024-42116 # Unofficial: DoS
# ima? https://nvd.nist.gov/vuln/detail/CVE-2024-40947 # Unofficial: DoS
# ima? https://nvd.nist.gov/vuln/detail/CVE-2022-21505 # DoS, DT, ID, PE
# hfs? https://nvd.nist.gov/vuln/detail/CVE-2024-42311 # DoS
# hfsplus? https://nvd.nist.gov/vuln/detail/CVE-2024-41059 # DoS, DT, ID
# hugetlbfs? https://nvd.nist.gov/vuln/detail/CVE-2024-47676 # DoS, DT, ID
# hyperv? https://nvd.nist.gov/vuln/detail/CVE-2024-46864 # Unofficial: DoS
# iaa? https://nvd.nist.gov/vuln/detail/CVE-2024-47732 # DoS, DT, ID
# ice? https://nvd.nist.gov/vuln/detail/CVE-2024-46766 # DoS, DT, ID
# ip? https://nvd.nist.gov/vuln/detail/CVE-2024-36971 # DoS, DT, ID
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-36927 # DoS
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-44991 # Unofficial: DoS
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-41041 # Unofficial: DoS
# ipv4? https://nvd.nist.gov/vuln/detail/CVE-2024-42154 # DoS, DT, ID
# ipv6? https://nvd.nist.gov/vuln/detail/CVE-2024-44987 # DoS, DT, ID, UAF
# ipv6? 04ccecf # Unofficial: DoS
# ivtv? https://nvd.nist.gov/vuln/detail/ # Unofficial: DoS
# hppa? [same as parisc] (https://nvd.nist.gov/vuln/detail/CVE-2024-40918) # Unofficial: DoS
# iwlwifi? [1] https://nvd.nist.gov/vuln/detail/CVE-2022-48918 # DoS
# iwlwifi? [2] https://nvd.nist.gov/vuln/detail/CVE-2022-48787 # DoS, DT, ID
# iwlwifi? https://nvd.nist.gov/vuln/detail/CVE-2024-49857 49857 # DoS
# jfs? https://nvd.nist.gov/vuln/detail/CVE-2024-43858 # DoS, DT, ID
# jfs? https://nvd.nist.gov/vuln/detail/CVE-2024-44938 # DoS
# jfs? e63866a # Unofficial: DoS
# jfs https://nvd.nist.gov/vuln/detail/CVE-2024-49903 # DoS, DT, ID
# landlock? https://nvd.nist.gov/vuln/detail/CVE-2024-40938 # Unofficial: DoS
# kvm? https://nvd.nist.gov/vuln/detail/CVE-2024-46707 # DoS
# kvm? https://nvd.nist.gov/vuln/detail/CVE-2024-43819 # DoS
# kvm? https://nvd.nist.gov/vuln/detail/CVE-2024-41070 # DoS, DT, ID
# kvm? https://nvd.nist.gov/vuln/detail/CVE-2024-39483 # DoS
# kvm? https://nvd.nist.gov/vuln/detail/CVE-2024-47744 # DoS
# kvm? 47d40d9 # Unofficial: DoS NPD
# mac80211? https://nvd.nist.gov/vuln/detail/CVE-2024-43911 # DoS
# md-raid1? https://nvd.nist.gov/vuln/detail/CVE-2024-45023 # DT, DoS
# md-raid456? https://nvd.nist.gov/vuln/detail/CVE-2024-26962 # Unofficial: DoS
# md-raid5? https://nvd.nist.gov/vuln/detail/CVE-2024-43914 # DOS
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2024-45019 # DoS
# mlx5? https://nvd.nist.gov/vuln/detail/CVE-2024-46857 # Unofficial: DoS
# mlx5? 112e6e8 # Unofficial: DoS
# mptcp? https://nvd.nist.gov/vuln/detail/CVE-2024-46858 # DoS, DT, ID
# msm? https://nvd.nist.gov/vuln/detail/CVE-2024-45015 # DoS
# mt76? https://nvd.nist.gov/vuln/detail/CVE-2024-42225 # DoS, DT, ID
# mt76? 862bf7c # Unofficial: DoS OOPS
# mt7921? https://nvd.nist.gov/vuln/detail/CVE-2024-46860 # Unofficial: DoS
# mt7925? 9679ca7 # Unofficial: DoS
# mwifiex? https://nvd.nist.gov/vuln/detail/CVE-2024-46755 # DoS
# net? https://nvd.nist.gov/vuln/detail/CVE-2024-50036 # DoS, DT, ID
# netfilter? https://nvd.nist.gov/vuln/detail/CVE-2024-45018 # DoS
# nfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46696 # DoS, DT, ID
# nfs? 22451a1 # Unofficial: DoS
# nf_tables? https://nvd.nist.gov/vuln/detail/CVE-2022-48935 # DoS UAF
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-46781 # DoS
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-47757 # DoS, ID
# nilfs2? https://nvd.nist.gov/vuln/detail/CVE-2024-47669 # DoS
# ntfs? https://nvd.nist.gov/vuln/detail/CVE-2023-45896 # DoS, ID; RH rated it DT (I:L)
# ntfs? https://nvd.nist.gov/vuln/detail/CVE-2024-42299 # DoS
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-45013 # DoS
# nvme? https://nvd.nist.gov/vuln/detail/CVE-2024-41073 # DoS, DT, ID
# pci? https://nvd.nist.gov/vuln/detail/CVE-2024-46750 # DoS
# pci? https://nvd.nist.gov/vuln/detail/CVE-2024-42302 # DoS, DT, ID
# pci? https://nvd.nist.gov/vuln/detail/CVE-2024-46761 # DoS
# powercap? https://nvd.nist.gov/vuln/detail/CVE-2024-49862 # DoS, ID
# powerpc? https://nvd.nist.gov/vuln/detail/CVE-2024-46797 # DoS
# qat? cd8d2d7 # Unofficial: DoS RC
# rtw88? https://nvd.nist.gov/vuln/detail/CVE-2024-46760 # DoS
# rtw88? # 0e735a4 Unofficial: DoS, DT, ID UAF
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-46796 # DoS, DT, ID
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-46795 # DoS
# samba? https://nvd.nist.gov/vuln/detail/CVE-2024-49996 # DoS, DT, ID
# scsi-sd? https://nvd.nist.gov/vuln/detail/CVE-2024-47682 # DoS, DT, ID
# sctp? https://nvd.nist.gov/vuln/detail/CVE-2024-44935 # DoS
# selinux? https://nvd.nist.gov/vuln/detail/CVE-2022-48740 # DoS, DT, ID
# smack? https://nvd.nist.gov/vuln/detail/CVE-2024-47659 # DoS, DT, ID
# smmu-v3-sva? https://nvd.nist.gov/vuln/detail/CVE-2024-44994 # Unofficial: DoS
# squashfs? https://nvd.nist.gov/vuln/detail/CVE-2024-46744 # DoS, DT, ID
# tcp? https://nvd.nist.gov/vuln/detail/CVE-2024-47684 # DoS
# tipc? https://nvd.nist.gov/vuln/detail/CVE-2024-42284 # DoS, DT, ID
# tls? https://nvd.nist.gov/vuln/detail/CVE-2024-36489 # DoS
# usb? https://nvd.nist.gov/vuln/detail/CVE-2024-41035 # Unofficial: DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46725 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46851 # Unofficial: DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46850 # Unofficial: DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-47661 # DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-47683 # DoS
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-46871 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-49989 # DoS, DT, ID
# video_cards_amdgpu? https://nvd.nist.gov/vuln/detail/CVE-2024-49969 # DoS, DT, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-41092 # DoS, ID
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-46867 # Unofficial: DoS
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-46683 # DoS, ID, DT
# video_cards_intel? https://nvd.nist.gov/vuln/detail/CVE-2024-49876 # DoS, DT, ID
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-45012 # DoS; requires >= 6.11 for fix
# video_cards_nouveau? https://nvd.nist.gov/vuln/detail/CVE-2024-42101 # DoS; requires >= 6.10 for fix
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5551 # DoS, ID, DT, CE, PE
# video_cards_nvidia? https://nvidia.custhelp.com/app/answers/detail/a_id/5586 # DoS, ID, DT, CE, PE
# video_cards_radeon? https://nvd.nist.gov/vuln/detail/CVE-2024-41060 # DoS
# video_cards_v3d? https://nvd.nist.gov/vuln/detail/CVE-2024-46699 # DoS, DT, ID
# video_cards_vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46709 # DoS
# vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-46738 # DoS, DT, ID
# vmware? https://nvd.nist.gov/vuln/detail/CVE-2024-40923 # Unofficial: DoS
# wireguard? https://nvd.nist.gov/vuln/detail/CVE-2024-42247 # DoS
# xen? https://nvd.nist.gov/vuln/detail/CVE-2024-46762 # DoS
# xen? https://nvd.nist.gov/vuln/detail/CVE-2024-49936 # DoS, DT, ID
# xfs? https://nvd.nist.gov/vuln/detail/CVE-2024-41014 # Unofficial: DoS.  RH added ID (C:L)
#
# Usually stable versions get security checked.
# The betas and dev versions usually do not get security reports.
#

# From the kernel/ or mm/ subfolder
core_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BUS[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_LOCKING[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MM_46847[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MM_47674[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MM_47745[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_50036[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SCHED_44958[@]}

	if _use hppa ; then
		gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PARISC_40918[@]}
	fi
}

block_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLOCK_43854[@]}
}
fs_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FS_43882[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FS_46701[@]}
}
wifi_rdepend() {
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CFG80211[@]}
	gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MAC80211[@]}
}

squashfs_rdepend() {
	block_rdepend
	fs_rdepend
}
all_rdepend() {
	squashfs_rdepend
	mitigate_dos_rdepend
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
	if _use ath11k ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATH11K_49930[@]}
		fi
	fi
	if _use ath12k ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATH12K_46827[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATH12K_49931[@]}
		fi
	fi
	if _use apparmor ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_APPARMOR[@]}
		fi
	fi
	if _use ata ; then
		if ! _use custom-kernel ; then
			block_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_ATA_41087[@]}
		fi
	fi
	if _use bcrm80211 ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BRCM80211[@]}
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
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_46749[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BLUETOOTH_50029[@]}
		fi
	fi
	if _use bpf ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_45020[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_49850[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_47675[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BPF_49861[@]}
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
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_46841[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_BTRFS_49869[@]}
		fi
	fi
	if _use ccp ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CCP[@]}
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
	if _use cpuset ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CPUSET[@]}
		fi
	fi
	if _use crypto-keys ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_CRYPTO_KEYS[@]}
		fi
	fi
	if _use exfat ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXTFAT_47677[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXTFAT_50013[@]}
		fi
	fi
	if _use ext4 ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_43828[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_c6b72f5[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_49889[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_EXT4_49880[@]}
		fi
	fi
	if _use f2fs ; then
		if ! _use custom-kernel ; then
			block_rdepend
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_F2FS_44942[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_F2FS_49859[@]}
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
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_FUSE_47746[@]}
		fi
	fi
	if _use igb ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IGB[@]}
		fi
	fi
	if _use igc ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IGC[@]}
		fi
	fi
	if _use ima ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IMA_40947[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IMA_21505[@]}
		fi
	fi
	if _use hfs ; then
		if ! _use custom-kernel ; then
			block_rdepend
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HFS[@]}
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
	if _use hyperv ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_HYPERV[@]}
		fi
	fi
	if _use i40e ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_I40E[@]}
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
	if _use ipv4 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_36927[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_44991[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_41041[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV4_42154[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]}
			if _use bpf-stream-parser ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_SOCK_MSG_46783[@]}
			fi
			if _use esp-in-tcp ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NET_SOCK_MSG_46783[@]}
			fi
		fi
	fi
	if _use ipv6 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV6_44987[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IP_36971[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IPV6_04ccecf[@]}
		fi
	fi
	if _use ivtv ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IVTV[@]}
		fi
	fi
	if _use iwlwifi ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_48918[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_48787[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IWLWIFI_49857[@]}
		fi
	fi
	if _use jfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_43858[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_44938[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_e63866a[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_JFS_49903[@]}
		fi
	fi
	if _use kvm ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_47744[@]}
			if _use amd64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_X86_39483[@]}
			fi
			if _use arm64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]}
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_ARM64_46707[@]}
			fi
			if _use ppc64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]}
			fi
			if _use riscv ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_RISCV_47d40d9[@]}
			fi
			if _use s390 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_KVM_S390_43819[@]}
			fi
		fi
	fi
	if _use landlock ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_LANDLOCK[@]}
		fi
	fi
	if _use md-raid1 ; then
		if ! _use custom-kernel ; then
			block_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID1[@]}
		fi
	fi
	if _use md-raid456 ; then
		if ! _use custom-kernel ; then
			block_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID456[@]}
		fi
	fi
	if _use md-raid5 ; then
		if ! _use custom-kernel ; then
			block_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MD_RAID5[@]}
		fi
	fi
	if _use mlx5 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5_45019[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5_46857[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MLX5_112e6e8[@]}
		fi
	fi
	if _use mptcp ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MPTCP_46858[@]}
		fi
	fi
	if _use mt76 ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT76[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT76_862bf7c[@]}
		fi
	fi
	if _use mt7921 ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT7921[@]}
		fi
	fi
	if _use mt7925 ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT7925_9679ca7[@]}
		fi
	fi
	if _use mt7996e ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MT7996E_47681[@]}
		fi
	fi
	if _use mwifiex ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MWIFIEX[@]}
		fi
	fi
	if _use nfs ; then
		if ! _use custom-kernel ; then
			block_rdepend
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD_46696[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD_22451a1[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NFSD_50043[@]}
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
	if _use nftables ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NF_TABLES[@]}
		fi
	fi
	if _use nilfs2 ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2_46781[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2_47757[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NILFS2_47669[@]}
		fi
	fi
	if _use ntfs ; then
		if ! _use custom-kernel ; then
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NTFS3_42299[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NTFS3_45896[@]}
		fi
	fi
	if _use nvme ; then
		if ! _use custom-kernel ; then
			block_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_45013[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NVME_41073[@]}
		fi
	fi
	if _use pci ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PCI_46750[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PCI_42302[@]}
		fi
	fi
	if _use pci-hotplug ; then
		if ! _use custom-kernel ; then
			if _use ppc64 ; then
				gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_PCI_HOTPLUG_46761[@]}
			fi
		fi
	fi
	if _use powercap ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_POWERCAP[@]}
		fi
	fi
	if _use ppc ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_POWERPC_46797[@]}
		fi
	fi
	if _use ppc64 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_POWERPC_46797[@]}
		fi
	fi
	if _use qat ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_QAT_cd8d2d7[@]}
		fi
	fi
	if _use rtw88 ; then
		if ! _use custom-kernel ; then
			wifi_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RTW88_46760[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RTW88_0e735a4[@]}
		fi
	fi
	if _use samba ; then
		if ! _use custom-kernel ; then
			block_rdepend
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46796[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_46795[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SMB_49996[@]}
		fi
	fi
	if _use scsi-sd ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SCSI_SD[@]}
		fi
	fi
	if _use sctp ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SCTP[@]}
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
	if _use smmu-v3-sva ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_IOMMU_IOPF[@]}
		fi
	fi
	if _use squashfs ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_SQUASHFS[@]}
		fi
	fi
	if _use tcp ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TCP_47684[@]}
		fi
	fi
	if _use tipc ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TIPC[@]}
		fi
	fi
	if _use tls ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_TLS[@]}
		fi
	fi
	if _use usb ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_USB[@]}
		fi
	fi
	if _use v4l2 ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_V4L2_43833[@]}
		fi
	fi
	if _use video_cards_amdgpu ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46725[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46851[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46850[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_47661[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_47683[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_46871[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_49989[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_AMDGPU_49969[@]}
		fi
	fi
	if _use video_cards_freedreno ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_MSM[@]}
		fi
	fi
	if _use video_cards_intel ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_I915[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE_46683[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE_46867[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XE_49876[@]}
		fi
	fi
	if _use video_cards_nouveau ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_NOUVEAU[@]}
		fi
	fi
	if _use video_cards_radeon ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_RADEON[@]}
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
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_VMXNET3[@]}
		fi
	fi
	if _use wireguard ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_WIREGUARD[@]}
		fi
	fi
	if _use xen ; then
		if ! _use custom-kernel ; then
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XEN_46762[@]}
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XEN_49936[@]}
		fi
	fi
	if _use xfs ; then
		if ! _use custom-kernel ; then
			block_rdepend
			fs_rdepend
			gen_patched_kernel_driver_list ${MULTISLOT_KERNEL_XFS[@]}
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
		xen? (
			>=app-emulation/xen-${_XEN_PV}
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
	local block=0
	local fs=0
	local wifi=0

	# For squashfs
	block=1
	fs=1

einfo
einfo "Glossary of common Denial of Service (DoS) bugs"
einfo
einfo "NPD:  Null Pointer Dereference"
einfo "OOPS:  Restart on Crash if oops=panic [BSOD restart]"
einfo "OOB:  Out of Bounds"
einfo "RC:  Race Condition"
einfo "UAF:  Use After Free"
einfo

	# Core
	check_kernel_version "bus" "${CVE_CORE}" ${MULTISLOT_KERNEL_CORE[@]}
	check_kernel_version "kernel/kthread" "${CVE_KTHREAD}" ${MULTISLOT_KERNEL_KTHREAD[@]}
	check_kernel_version "kernel/locking" "${CVE_LOCKING}" ${MULTISLOT_KERNEL_LOCKING[@]}
	check_kernel_version "kernel/sched" "${CVE_SCHED_44958}" ${MULTISLOT_KERNEL_SCHED_44958[@]}
	check_kernel_version "mm" "${CVE_MM_46847}" ${MULTISLOT_KERNEL_MM_46847[@]}
	check_kernel_version "mm" "${CVE_MM_47674}" ${MULTISLOT_KERNEL_MM_47674[@]}
	check_kernel_version "mm" "${CVE_MM_47745}" ${MULTISLOT_KERNEL_MM_47745[@]}
	check_kernel_version "net" "${CVE_NET_50036}" ${MULTISLOT_KERNEL_NET_50036[@]}

	if use aacraid ; then
		check_kernel_version "scsi/aacraid" "${CVE_AACRAID}" ${MULTISLOT_KERNEL_AACRAID[@]}
	fi
	if use acpi ; then
		check_kernel_version "acpi" "${CVE_ACPI}" ${MULTISLOT_KERNEL_ACPI[@]}
	fi
	if use ath11k ; then
		wifi=1
		check_kernel_version "ath11k" "${CVE_ATH11K_49930}" ${MULTISLOT_KERNEL_ATH11K_49930[@]}
	fi
	if use ath12k ; then
		wifi=1
		check_kernel_version "ath12k" "${CVE_ATH12K_46827}" ${MULTISLOT_KERNEL_ATH12K_46827[@]}
		check_kernel_version "ath12k" "${CVE_ATH12K_49931}" ${MULTISLOT_KERNEL_ATH12K_49931[@]}
	fi
	if use apparmor ; then
		check_kernel_version "apparmor" "${CVE_APPARMOR}" ${MULTISLOT_KERNEL_APPARMOR[@]}
	fi
	if use ata ; then
		block=1
		check_kernel_version "ata" "${CVE_ATA_41087}" ${MULTISLOT_KERNEL_ATA_41087[@]}
	fi
	if use bcrm80211 ; then
		wifi=1
		check_kernel_version "bcrm80211" "${CVE_BRCM80211}" ${MULTISLOT_KERNEL_BRCM80211[@]}
	fi
	if use bfq ; then
		check_kernel_version "bfq" "${CVE_BFQ_49854}" ${MULTISLOT_KERNEL_BFQ_49854[@]}
		check_kernel_version "bfq" "${CVE_BFQ_18ad4df}" ${MULTISLOT_KERNEL_BFQ_18ad4df[@]}
	fi
	if use bluetooth ; then
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_46749}" ${MULTISLOT_KERNEL_BLUETOOTH_46749[@]}
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_48878}" ${MULTISLOT_KERNEL_BLUETOOTH_48878[@]}
		check_kernel_version "bluetooth" "${CVE_BLUETOOTH_50029}" ${MULTISLOT_KERNEL_BLUETOOTH_50029[@]}
	fi
	if use bpf ; then
		check_kernel_version "bpf" "${CVE_BPF_45020}" ${MULTISLOT_KERNEL_BPF_45020[@]}
		check_kernel_version "bpf" "${CVE_BPF_49850}" ${MULTISLOT_KERNEL_BPF_49850[@]}
		check_kernel_version "bpf" "${CVE_BPF_47675}" ${MULTISLOT_KERNEL_BPF_47675[@]}
		check_kernel_version "bpf" "${CVE_BPF_49861}" ${MULTISLOT_KERNEL_BPF_49861[@]}
	fi
	if use bridge ; then
		check_kernel_version "net/bridge" "${CVE_NET_BRIDGE}" ${MULTISLOT_KERNEL_NET_BRIDGE[@]}
	fi
	if use btrfs ; then
		fs=1
		check_kernel_version "btrfs" "${CVE_BTRFS_46687}" ${MULTISLOT_KERNEL_BTRFS_46687[@]}
		check_kernel_version "btrfs" "${CVE_BTRFS_46749}" ${MULTISLOT_KERNEL_BTRFS_46841[@]}
		check_kernel_version "btrfs" "${CVE_BTRFS_49869}" ${MULTISLOT_KERNEL_BTRFS_49869[@]}
	fi
	if use ccp ; then
		check_kernel_version "crypto/ccp" "${CVE_CCP}" ${MULTISLOT_KERNEL_CCP[@]}
	fi
	if use cdrom ; then
		check_kernel_version "cdrom" "${CVE_CDROM}" ${MULTISLOT_KERNEL_CDROM[@]}
	fi
	if use cougar ; then
		check_kernel_version "hid/hid-cougar" "${CVE_COUGAR}" ${MULTISLOT_KERNEL_COUGAR[@]}
	fi
	if use cpuset ; then
		check_kernel_version "kernel/cgroup/cpuset" "${CVE_CPUSET}" ${MULTISLOT_KERNEL_CPUSET[@]}
	fi
	if use crypto-keys ; then
		check_kernel_version "crypto/keys" "${CVE_CRYPTO_KEYS}" ${MULTISLOT_KERNEL_CRYPTO_KEYS[@]}
	fi
	if use exfat ; then
		fs=1
		check_kernel_version "exfat" "${CVE_EXFAT_47677}" ${MULTISLOT_KERNEL_EXFAT_47677[@]}
		check_kernel_version "exfat" "${CVE_EXFAT_47677}" ${MULTISLOT_KERNEL_EXFAT_50013[@]}
	fi
	if use ext4 ; then
		fs=1
		check_kernel_version "ext4" "${CVE_EXT4_43828}" ${MULTISLOT_KERNEL_EXT4_43828[@]}
		check_kernel_version "ext4" "${CVE_EXT4_c6b72f5}" ${MULTISLOT_KERNEL_c6b72f5[@]}
		check_kernel_version "ext4" "${CVE_EXT4_49889}" ${MULTISLOT_KERNEL_49889[@]}
		check_kernel_version "ext4" "${CVE_EXT4_49880}" ${MULTISLOT_KERNEL_49880[@]}
	fi
	if use f2fs ; then
		block=1
		fs=1
		check_kernel_version "f2fs" "${CVE_F2FS_44942}" ${MULTISLOT_KERNEL_F2FS_44942[@]}
		check_kernel_version "f2fs" "${CVE_F2FS_49859}" ${MULTISLOT_KERNEL_F2FS_49859[@]}
	fi
	if use fscache ; then
		fs=1
		check_kernel_version "fscache" "${CVE_FSCACHE}" ${MULTISLOT_KERNEL_FSCACHE[@]}
	fi
	if use fuse ; then
		fs=1
		check_kernel_version "fuse" "${CVE_FUSE_47746}" ${MULTISLOT_KERNEL_FUSE_47746[@]}
	fi
	if use hfs ; then
		block=1
		fs=1
		check_kernel_version "hfs" "${CVE_HFS}" ${MULTISLOT_KERNEL_HFS[@]}
	fi
	if use hugetlbfs ; then
		fs=1
		check_kernel_version "hugetlbfs" "${CVE_HUGETLBFS_47676}" ${MULTISLOT_KERNEL_HUGETLBFS_47676[@]}
	fi
	if use hfsplus ; then
		fs=1
		check_kernel_version "hfsplus" "${CVE_HFSPLUS}" ${MULTISLOT_KERNEL_HFSPLUS[@]}
	fi
	if use hppa ; then
		check_kernel_version "parisc" "${CVE_PARISC_40918}" ${MULTISLOT_KERNEL_PARISC_40918[@]}
	fi
	if use hyperv ; then
		check_kernel_version "x86/hyperv" "${CVE_HYPERV}" ${MULTISLOT_KERNEL_HYPERV[@]}
	fi
	if use i40e ; then
		check_kernel_version "net/ethernet/intel/i40e" "${CVE_I40E}" ${MULTISLOT_KERNEL_I40E[@]}
	fi
	if use iaa ; then
		check_kernel_version "crypto/iaa" "${CVE_IAA}" ${MULTISLOT_KERNEL_IAA[@]}
	fi
	if use ice ; then
		check_kernel_version "net/ethernet/intel/ice" "${CVE_ICE}" ${MULTISLOT_KERNEL_ICE[@]}
	fi
	if use igb ; then
		check_kernel_version "igb" "${CVE_IGB}" ${MULTISLOT_KERNEL_IGB[@]}
	fi
	if use igc ; then
		check_kernel_version "igc" "${CVE_IGC}" ${MULTISLOT_KERNEL_IGC[@]}
	fi
	if use ima ; then
		check_kernel_version "ima" "${CVE_IMA_40947}" ${MULTISLOT_KERNEL_IMA_40947[@]}
		check_kernel_version "ima" "${CVE_IMA_21505}" ${MULTISLOT_KERNEL_IMA_21505[@]}
	fi
	local ip=0
	if use ipv4 ; then
		ip=1
		check_kernel_version "ipv4" "${CVE_IPV4_36927}" ${MULTISLOT_KERNEL_IPV4_36927[@]}
		check_kernel_version "ipv4" "${CVE_IPV4_42154}" ${MULTISLOT_KERNEL_IPV4_42154[@]}
		check_kernel_version "ipv4/udp" "${CVE_IPV4_41041}" ${MULTISLOT_KERNEL_IPV4_41041[@]}
		check_kernel_version "ipv4" "${CVE_IPV4_44991}" ${MULTISLOT_KERNEL_IPV4_44991[@]}
		if use bpf-stream-parser ; then
			check_kernel_version "ipv4" "${CVE_NET_SOCK_MSG_46783}" ${MULTISLOT_KERNEL_NET_SOCK_MSG_46783[@]}
		fi
		if use esp-in-tcp ; then
			check_kernel_version "ipv4" "${CVE_NET_SOCK_MSG_46783}" ${MULTISLOT_KERNEL_NET_SOCK_MSG_46783[@]}
		fi
	fi
	if use ipv6 ; then
		ip=1
		check_kernel_version "ipv6" "${CVE_IPV6_44987}" ${MULTISLOT_KERNEL_IPV6_44987[@]}
		check_kernel_version "ipv6" "${CVE_IPV6_04ccecf}" ${MULTISLOT_KERNEL_IPV6_04ccecf[@]}
	fi
	if (( ${ip} == 1 )) ; then
		check_kernel_version "ip" "${CVE_IP_36971}" ${MULTISLOT_KERNEL_IP_36971[@]}
	fi
	if use iwlwifi ; then
		wifi=1
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_48918}" ${MULTISLOT_KERNEL_IWLWIFI_48918[@]}
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_48787}" ${MULTISLOT_KERNEL_IWLWIFI_48787[@]}
		check_kernel_version "iwlwifi" "${CVE_IWLWIFI_49857}" ${MULTISLOT_KERNEL_IWLWIFI_49857[@]}
	fi
	if use ivtv ; then
		check_kernel_version "ivtv" "${CVE_IVTV}" ${MULTISLOT_KERNEL_IVTV[@]}
	fi
	if use jfs ; then
		fs=1
		check_kernel_version "jfs" "${CVE_JFS_43858}" ${MULTISLOT_KERNEL_JFS_43858[@]}
		check_kernel_version "jfs" "${CVE_JFS_44938}" ${MULTISLOT_KERNEL_JFS_44938[@]}
		check_kernel_version "jfs" "${CVE_JFS_e63866a}" ${MULTISLOT_KERNEL_JFS_e63866a[@]}
		check_kernel_version "jfs" "${CVE_JFS_49903}" ${MULTISLOT_KERNEL_JFS_49903[@]}
	fi
	if use landlock ; then
		check_kernel_version "landlock" "${CVE_LANDLOCK}" ${MULTISLOT_KERNEL_LANDLOCK[@]}
	fi
	if use kvm ; then
		check_kernel_version "kvm" "${CVE_KVM_47744}" ${MULTISLOT_KERNEL_KVM_47744[@]}
		if use amd64 ; then
			check_kernel_version "x86/kvm" "${CVE_KVM_X86_39483}" ${MULTISLOT_KERNEL_KVM_X86_39483[@]}
		elif use arm64 ; then
			check_kernel_version "arm64/kvm" "${CVE_KVM_ARM64_26598}" ${MULTISLOT_KERNEL_KVM_ARM64_26598[@]}
			check_kernel_version "arm64/kvm" "${CVE_KVM_ARM64_46707}" ${MULTISLOT_KERNEL_KVM_ARM64_46707[@]}
		elif use ppc64 ; then
			check_kernel_version "powerpc/kvm" "${CVE_KVM_POWERPC_41070}" ${MULTISLOT_KERNEL_KVM_POWERPC_41070[@]}
		elif use riscv ; then
			check_kernel_version "riscv/kvm" "${CVE_KVM_RISCV_47d40d9}" ${MULTISLOT_KERNEL_KVM_RISCV_47d40d9[@]}
		elif use s390 ; then
			check_kernel_version "s390/kvm" "${CVE_KVM_S390_43819}" ${MULTISLOT_KERNEL_KVM_S390_43819[@]}
		fi
	fi
	if use mlx5 ; then
		check_kernel_version "mlx5" "${CVE_MLX5_45019}" ${MULTISLOT_KERNEL_MLX5_45019[@]}
		check_kernel_version "mlx5" "${CVE_MLX5_46857}" ${MULTISLOT_KERNEL_MLX5_46857[@]}
		check_kernel_version "mlx5" "${CVE_MLX5_112e6e8}" ${MULTISLOT_KERNEL_MLX5_112e6e8[@]}
	fi
	if use md-raid1 ; then
		block=1
		check_kernel_version "md/raid1" "${CVE_MD_RAID1}" ${MULTISLOT_KERNEL_MD_RAID1[@]}
	fi
	if use md-raid456 ; then
		block=1
		check_kernel_version "md/raid456" "${CVE_MD_RAID456}" ${MULTISLOT_KERNEL_MD_RAID456[@]}
	fi
	if use md-raid5 ; then
		block=1
		check_kernel_version "md/raid5" "${CVE_MD_RAID5}" ${MULTISLOT_KERNEL_MD_RAID5[@]}
	fi
	if use mptcp ; then
		check_kernel_version "mptcp" "${CVE_MPTCP_46858}" ${MULTISLOT_KERNEL_MPTCP_46858[@]}
	fi
	if use mt76 ; then
		check_kernel_version "mt76" "${CVE_MT76}" ${MULTISLOT_KERNEL_MT76[@]}
		check_kernel_version "mt76" "${CVE_MT76_862bf7c}" ${MULTISLOT_KERNEL_MT76_862bf7c[@]}
	fi
	if use mt7921 ; then
		check_kernel_version "mt7921" "${CVE_MT7921}" ${MULTISLOT_KERNEL_MT7921[@]}
	fi
	if use mt7925 ; then
		check_kernel_version "mt7925" "${CVE_MT7925_9679ca7}" ${MULTISLOT_KERNEL_MT7925_9679ca7[@]}
	fi
	if use mt7996e ; then
		check_kernel_version "mt7996e" "${CVE_MT7996E_47681}" ${MULTISLOT_KERNEL_MT7996E_47681[@]}
	fi
	if use mwifiex ; then
		check_kernel_version "mwifiex" "${CVE_MWIFIEX}" ${MULTISLOT_KERNEL_MWIFIEX[@]}
	fi
	if use nfs ; then
		block=1
		fs=1
		check_kernel_version "nfsd" "${CVE_NFSD_46696}" ${MULTISLOT_KERNEL_NFSD_46696[@]}
		check_kernel_version "nfsd" "${CVE_NFSD_22451a1}" ${MULTISLOT_KERNEL_NFSD_22451a1[@]}
		check_kernel_version "nfsd" "${CVE_NFSD_50043}" ${MULTISLOT_KERNEL_NFSD_50043[@]}
	fi
	if use netfilter ; then
		check_kernel_version "netfilter" "${CVE_NETFILTER}" ${MULTISLOT_KERNEL_NETFILTER[@]}
		if use ipv6 ; then
			check_kernel_version "net/ipv6/netfilter" "${CVE_IPV6_NETFILTER}" ${MULTISLOT_KERNEL_IPV6_NETFILTER[@]}
		fi
	fi
	if use nftables ; then
		check_kernel_version "nf_tables" "${CVE_NF_TABLES}" ${MULTISLOT_KERNEL_NF_TABLES[@]}
	fi
	if use nilfs2 ; then
		fs=1
		check_kernel_version "nilfs2" "${CVE_NILFS2_46781}" ${MULTISLOT_KERNEL_NILFS2_46781[@]}
		check_kernel_version "nilfs2" "${CVE_NILFS2_47757}" ${MULTISLOT_KERNEL_NILFS2_47757[@]}
		check_kernel_version "nilfs2" "${CVE_NILFS2_47669}" ${MULTISLOT_KERNEL_NILFS2_47669[@]}
	fi
	if use ntfs ; then
		fs=1
		check_kernel_version "ntfs3" "${CVE_NTFS3_42299}" ${MULTISLOT_KERNEL_NTFS3_42299[@]}
		check_kernel_version "ntfs3" "${CVE_NTFS3_45896}" ${MULTISLOT_KERNEL_NTFS3_45896[@]}
	fi
	if use nvme ; then
		block=1
		check_kernel_version "nvme" "${CVE_NVME_45013}" ${MULTISLOT_KERNEL_NVME_45013[@]}
		check_kernel_version "nvme" "${CVE_NVME_41073}" ${MULTISLOT_KERNEL_NVME_41073[@]}
	fi
	if use pci ; then
		check_kernel_version "pci" "${CVE_PCI_46750}" ${MULTISLOT_KERNEL_PCI_46750[@]}
		check_kernel_version "pci" "${CVE_PCI_42302}" ${MULTISLOT_KERNEL_PCI_42302[@]}
	fi
	if use pci-hotplug ; then
		if use ppc64 ; then
			check_kernel_version "pci/hotplug" "${CVE_PCI_HOTPLUG_46761}" ${MULTISLOT_KERNEL_PCI_HOTPLUG_46761[@]}
		fi
	fi
	if use powercap ; then
		check_kernel_version "powercap" "${CVE_POWERCAP}" ${MULTISLOT_KERNEL_POWERCAP[@]}
	fi
	if use ppc64 || use ppc ; then
		check_kernel_version "powerpc" "${CVE_POWERPC_46797}" ${MULTISLOT_KERNEL_POWERPC_46797[@]}
	fi
	if use qat ; then
		check_kernel_version "crypto/intel/qat" "${CVE_QAT_cd8d2d7}" ${MULTISLOT_KERNEL_QAT_cd8d2d7[@]}
	fi
	if use rtw88 ; then
		wifi=1
		check_kernel_version "rtw88" "${CVE_RTW88_46760}" ${MULTISLOT_KERNEL_RTW88_46760[@]}
		check_kernel_version "rtw88" "${CVE_RTW88_0e735a4}" ${MULTISLOT_KERNEL_RTW88_0e735a4[@]}
	fi
	if use samba ; then
		block=1
		fs=1
		check_kernel_version "smb" "${CVE_SMB_46796}" ${MULTISLOT_KERNEL_SMB_46796[@]}
		check_kernel_version "smb" "${CVE_SMB_46795}" ${MULTISLOT_KERNEL_SMB_46795[@]}
		check_kernel_version "smb" "${CVE_SMB_49996}" ${MULTISLOT_KERNEL_SMB_49996[@]}
	fi
	if use scsi-sd ; then
		check_kernel_version "scsi/sd" "${CVE_SCSI_SD}" ${MULTISLOT_KERNEL_SCSI_SD[@]}
	fi
	if use sctp ; then
		check_kernel_version "sctp" "${CVE_SCTP}" ${MULTISLOT_KERNEL_SCTP[@]}
	fi
	if use selinux ; then
		check_kernel_version "selinux" "${CVE_SELINUX}" ${MULTISLOT_KERNEL_SELINUX[@]}
	fi
	if use smack ; then
		check_kernel_version "smack" "${CVE_SMACK_47659}" ${MULTISLOT_KERNEL_SMACK_47659[@]}
	fi
	if use smmu-v3-sva ; then
		check_kernel_version "iommu/iopf" "${CVE_IOMMU_IOPF}" ${MULTISLOT_KERNEL_IOMMU_IOPF[@]}
	fi
	if use squashfs ; then
		fs=1
		check_kernel_version "squashfs" "${CVE_SQUASHFS}" ${MULTISLOT_KERNEL_SQUASHFS[@]}
	fi
	if use tcp ; then
		check_kernel_version "net/tcp" "${CVE_TCP_47684}" ${MULTISLOT_KERNEL_TCP_47684[@]}
	fi
	if use tipc ; then
		check_kernel_version "tipc" "${CVE_TIPC}" ${MULTISLOT_KERNEL_TIPC[@]}
	fi
	if use tls ; then
		check_kernel_version "tls" "${CVE_TLS}" ${MULTISLOT_KERNEL_TLS[@]}
	fi
	if use usb ; then
		check_kernel_version "usb" "${CVE_USB}" ${MULTISLOT_KERNEL_USB[@]}
	fi
	if use v4l2 ; then
		check_kernel_version "v4l2" "${CVE_V4L2_43833}" ${MULTISLOT_KERNEL_V4L2_43833[@]}
	fi
	if use video_cards_amdgpu ; then
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46725}" ${MULTISLOT_KERNEL_AMDGPU_46725[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46851}" ${MULTISLOT_KERNEL_AMDGPU_46851[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46850}" ${MULTISLOT_KERNEL_AMDGPU_46850[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_47661}" ${MULTISLOT_KERNEL_AMDGPU_47661[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_47683}" ${MULTISLOT_KERNEL_AMDGPU_47683[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_46871}" ${MULTISLOT_KERNEL_AMDGPU_46871[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_49989}" ${MULTISLOT_KERNEL_AMDGPU_49989[@]}
		check_kernel_version "amdgpu" "${CVE_AMDGPU_49969}" ${MULTISLOT_KERNEL_AMDGPU_49969[@]}
	fi
	if use video_cards_freedreno ; then
		check_kernel_version "msm" "${CVE_MSM}" ${MULTISLOT_KERNEL_MSM[@]}
	fi
	if use video_cards_intel ; then
		check_kernel_version "i915" "${CVE_I915}" ${MULTISLOT_KERNEL_I915[@]}
		check_kernel_version "xe" "${CVE_XE_46683}" ${MULTISLOT_KERNEL_XE_46683[@]}
		check_kernel_version "xe" "${CVE_XE_46867}" ${MULTISLOT_KERNEL_XE_46867[@]}
		check_kernel_version "xe" "${CVE_XE_49876}" ${MULTISLOT_KERNEL_XE_49876[@]}
	fi
	if use video_cards_nouveau ; then
		check_kernel_version "noveau" "${CVE_NOUVEAU}" ${MULTISLOT_KERNEL_NOUVEAU[@]}
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
		check_kernel_version "vmxnet3" "${CVE_VMXNET3}" ${MULTISLOT_KERNEL_VMXNET3[@]}
	fi
	if use wireguard ; then
		check_kernel_version "wireguard" "${CVE_WIREGUARD}" ${MULTISLOT_KERNEL_WIREGUARD[@]}
	fi
	if use xen ; then
		check_kernel_version "xen" "${CVE_XEN_46762}" ${MULTISLOT_KERNEL_XEN_46762[@]}
		check_kernel_version "xen/xen-netback" "${CVE_XEN_49936}" ${MULTISLOT_KERNEL_XEN_49936[@]}
	fi
	if use xfs ; then
		block=1
		fs=1
		check_kernel_version "xfs" "${CVE_XFS}" ${MULTISLOT_KERNEL_XFS[@]}
	fi
	if (( ${wifi} == 1 )) ; then
		check_kernel_version "cfg80211" "${CVE_CFG80211}" ${MULTISLOT_KERNEL_CFG80211[@]}
		check_kernel_version "mac80211" "${CVE_MAC80211}" ${MULTISLOT_KERNEL_MAC80211[@]}
	fi
	if (( ${block} == 1 )) ; then
		check_kernel_version "block" "${CVE_BLOCK_43854}" ${MULTISLOT_KERNEL_BLOCK_43854[@]}
	fi
	if (( ${fs} == 1 )) ; then
		check_kernel_version "fs" "${CVE_FS_43882}" ${MULTISLOT_KERNEL_FS_43882[@]}
		check_kernel_version "fs" "${CVE_FS_46701}" ${MULTISLOT_KERNEL_FS_46701[@]}
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
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "14" && ot-kernel_has_version ">=llvm-core/lld-${compiler_version}" ; then
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
	elif [[ "${compiler}" =~ "clang" ]] && ver_test "${compiler_version%%.*}" -ge "6" && ot-kernel_has_version ">=llvm-core/lld-6" ; then
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
	use enforce || return
	mitigate-dos_pkg_setup
ewarn "This ebuild is a Work In Progress (WIP)."
	check_drivers
	check_zero_tolerance
	use max-uptime && verify_max_uptime_kernel_config
	verify_disable_ksm
}

src_compile() {
	use enforce || ewarn "The USE enforce flag is disabled."
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
