# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-pkgflags.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-pkgflags eclass auto enables kernel config flags based on
# packages installed.  Each set are a "one size fits all" or a general
# solution to get at least a functional working program with minimal
# problems with minimal kernel configuration time cost.  Each kernel
# rebuild can cost 4 hours on older machines.  Extra required flags
# should manually edit the .config instead of modifying this eclass.

inherit ot-kernel-kutils

# These are discovered by doing one of the following:
# 1: grep --exclude-dir=.git --exclude-dir=distfiles -r -e "CHECK=" ./
# 2: grep --exclude-dir=.git --exclude-dir=distfiles -r -e "linux_chkconfig_" ./

X86_FLAGS=(sse2 ssse3 avx avx2 sha)
IUSE+="${X86_FLAGS[@]/#/cpu_flags_x86_}"

# @FUNCTION: ot-kernel-pkgflags_apply
# @DESCRIPTION:
# The main function to apply all kernel config flags for package.
ot-kernel-pkgflags_apply() {
	[[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && return
	ot-kernel-pkgflags_bcm_sta
	ot-kernel-pkgflags_bees
	ot-kernel-pkgflags_blueman
	ot-kernel-pkgflags_bluez
	#ot-kernel-pkgflags_boinc
	ot-kernel-pkgflags_bolt
	ot-kernel-pkgflags_bubblewrap
	ot-kernel-pkgflags_cryfs
	ot-kernel-pkgflags_cryptodev
	ot-kernel-pkgflags_cryptsetup
	ot-kernel-pkgflags_db_numa
	ot-kernel-pkgflags_dbus
	ot-kernel-pkgflags_discord
	ot-kernel-pkgflags_docker
	ot-kernel-pkgflags_dracut
	ot-kernel-pkgflags_dropwatch
	ot-kernel-pkgflags_ecryptfs
	ot-kernel-pkgflags_elogind
	ot-kernel-pkgflags_embree
	ot-kernel-pkgflags_epcam
	ot-kernel-pkgflags_epoch
	ot-kernel-pkgflags_espeakup
	ot-kernel-pkgflags_eudev
	ot-kernel-pkgflags_ff
	ot-kernel-pkgflags_flatpak
	ot-kernel-pkgflags_firejail
	ot-kernel-pkgflags_glib
	ot-kernel-pkgflags_hd_idle
	ot-kernel-pkgflags_irqbalance
	ot-kernel-pkgflags_iwd
	ot-kernel-pkgflags_kexec_tools
	ot-kernel-pkgflags_kpatch
	ot-kernel-pkgflags_keyutils
	ot-kernel-pkgflags_libcec
	ot-kernel-pkgflags_libcgroup
	ot-kernel-pkgflags_libv4l
	ot-kernel-pkgflags_libvirt
	ot-kernel-pkgflags_lmsensors
	ot-kernel-pkgflags_lvm2
	ot-kernel-pkgflags_loopaes
	ot-kernel-pkgflags_mdadm
	ot-kernel-pkgflags_mesa
	ot-kernel-pkgflags_mono
	ot-kernel-pkgflags_multipath_tools
	ot-kernel-pkgflags_networkmanager
	ot-kernel-pkgflags_nilfs
	ot-kernel-pkgflags_ntfs3g
	ot-kernel-pkgflags_openrc
	ot-kernel-pkgflags_openssl
	ot-kernel-pkgflags_oprofile
	ot-kernel-pkgflags_pcmciautils
	ot-kernel-pkgflags_perf
	ot-kernel-pkgflags_portage
	ot-kernel-pkgflags_postgresql
	ot-kernel-pkgflags_powertop
	ot-kernel-pkgflags_pulseaudio
	ot-kernel-pkgflags_pqiv
	ot-kernel-pkgflags_qemu
	ot-kernel-pkgflags_roct
	ot-kernel-pkgflags_suid_sandbox
	ot-kernel-pkgflags_steam
	ot-kernel-pkgflags_systemd
	ot-kernel-pkgflags_udev
	ot-kernel-pkgflags_udisks
	ot-kernel-pkgflags_vbox
	ot-kernel-pkgflags_vhba
	ot-kernel-pkgflags_wavemon
	ot-kernel-pkgflags_wine
	ot-kernel-pkgflags_wpa_supplicant
	ot-kernel-pkgflags_xen
	ot-kernel-pkgflags_xpra
	ot-kernel-pkgflags_zfs
}

# @FUNCTION: ot-kernel-pkgflags_bcm_sta
# @DESCRIPTION:
# Applies kernel config flags for the bcm-sta
ot-kernel-pkgflags_bcm_sta() { # DONE
	if has_version "net-wireless/broadcom-sta" ; then
		einfo "Applying kernel config flags for bcm-sta"
		_s1() {
			ot-kernel_unset_configopt "CONFIG_B43"
			ot-kernel_unset_configopt "CONFIG_BCMA"
			ot-kernel_unset_configopt "CONFIG_SSB"
			ot-kernel_unset_configopt "CONFIG_X86_INTEL_LPSS"
		}

		_s2() {
			ot-kernel_y_configopt "CONFIG_LIB80211"
			ot-kernel_unset_configopt "CONFIG_MAC80211"
			ot-kernel_y_configopt "CONFIG_LIB80211_CRYPT_TKIP"
		}

		if ver_test ${PV} -ge 3.8.8 ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_CFG80211"
			ewarn "Cannot use PREEMPT_RCU OR PREEMPT with bcm-sta"
			ot-kernel_unset_configopt "CONFIG_PREEMPT_RCU"
			ot-kernel_unset_configopt "CONFIG_PREEMPT"
		elif ver_test ${PV} -ge 2.6.32 ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_CFG80211"
		elif ver_test ${PV} -ge 2.6.31 ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_WIRELESS_EXT"
			ot-kernel_unset_configopt "CONFIG_MAC80211"
		elif ver_test ${PV} -ge 2.6.29 ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_WIRELESS_EXT"
			ot-kernel_y_configopt "CONFIG_COMPAT_NET_DEV_OPS"
		else
			_s1
			ot-kernel_y_configopt "CONFIG_IEEE80211"
			ot-kernel_y_configopt "CONFIG_IEEE80211_CRYPT_TKIP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcm_sta
# @DESCRIPTION:
# Applies kernel config flags for the bcm-sta
ot-kernel-pkgflags_bees() { # DONE
	if has_version "sys-fs/bees" ; then
		einfo "Applying kernel config flags for bees package"
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blueman
# @DESCRIPTION:
# Applies kernel config flags for the blueman package
ot-kernel-pkgflags_blueman() { # DONE
	if has_version "net-wireless/blueman[network]" ; then
		einfo "Applying kernel config flags for the blueman package"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bluez
# @DESCRIPTION:
# Applies kernel config flags for the bluez package
ot-kernel-pkgflags_bluez() { # DONE
	if has_version "sys-apps/bluez" ; then
		einfo "Applying kernel config flags for the bluez package"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_BT"
		ot-kernel_y_configopt "CONFIG_BT_RFCOMM"
		ot-kernel_y_configopt "CONFIG_BT_RFCOMM_TTY"
		ot-kernel_y_configopt "CONFIG_BT_BNEP"
		ot-kernel_y_configopt "CONFIG_BT_BNEP_MC_FILTER"
		ot-kernel_y_configopt "CONFIG_BT_BNEP_PROTO_FILTER"
		ot-kernel_y_configopt "CONFIG_BT_HIDP"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_RFKILL"
		if has_version "sys-apps/bluez[mesh]" \
			|| has_version "sys-apps/bluez[test]" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_AEAD"
			_ot-kernel-pkgflags_aes
			ot-kernel_y_configopt "CONFIG_CRYPTO_CCM"
			ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_boinc
# @DESCRIPTION:
# Applies kernel config flags for the boinc package
ot-kernel-pkgflags_boinc() { # UNFINISHED
	if has_version "sci-misc/boinc" ; then
		einfo "Applying kernel config flags for the boinc package"
		# The ebuild mentions security changes.  This is why it is on hold.
		# Also the ebuild recommendation is old.
		if grep -q -E -e "^CONFIG_LEGACY_VSYSCALL_NONE=y" "${path_config}" ; then
			ewarn "Re-assigning vsyscall none -> full emulation"
			ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE" # no mitigation
#			ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_XONLY" # more mitigation, but no reads
			die
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bolt
# @DESCRIPTION:
# Applies kernel config flags for the bolt package
ot-kernel-pkgflags_bolt() { # DONE
	if has_version "sys-apps/bolt[kernel_linux]" ; then
		einfo "Applying kernel config flags for the bolt package"
		if ver_test ${K_MAJOR_MINOR} -lt 5.6 ; then
			ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		else
			ot-kernel_y_configopt "CONFIG_USB4"
		fi
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bubblewrap
# @DESCRIPTION:
# Applies kernel config flags for the bubblewrap package
ot-kernel-pkgflags_bubblewrap() { # DONE
	if has_version "sys-apps/bubblewrap" ; then
		einfo "Applying kernel config flags for the bubblewrap package"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryfs
# @DESCRIPTION:
# Applies kernel config flags for the cryfs package
ot-kernel-pkgflags_cryfs() { # DONE
	if has_version "sys-fs/cryfs" ; then
		einfo "Applying kernel config flags for the cryfs package"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryptodev
# @DESCRIPTION:
# Applies kernel config flags for the cryptodev package
ot-kernel-pkgflags_cryptodev() { # DONE
	if has_version "sys-kernel/cryptodev" ; then
		einfo "Applying kernel config flags for the cryptodev package"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
		if ver_test ${K_MAJOR_MINOR} -lt 4.8 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_BLKCIPHER"
		else
			ot-kernel_y_configopt "CONFIG_CRYPTO_SKCIPHER"
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_aes
# @DESCRIPTION:
# Wrapper for the aes option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_aes() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_aes ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_AES_NI_INTEL"
		elif ver_test ${K_MAJOR_MINOR} -le 5.3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_AES_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_AES"
}

# @FUNCTION: _ot-kernel-pkgflags_sha1
# @DESCRIPTION:
# Wrapper for the sha1 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha1() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_sha ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1"
}

# @FUNCTION: _ot-kernel-pkgflags_sha256
# @DESCRIPTION:
# Wrapper for the sha256 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha256() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_sha ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256"
}

# @FUNCTION: _ot-kernel-pkgflags_sha512
# @DESCRIPTION:
# Wrapper for the sha512 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha512() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		elif use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		elif use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512"
}

# @FUNCTION: _ot-kernel-pkgflags_serpent
# @DESCRIPTION:
# Wrapper for the serpent option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_serpent() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_AVX2_X86_64"
		elif use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_AVX_X86_64"
		elif use cpu_flags_x86_sse2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_SSE2_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT"
}

# @FUNCTION: _ot-kernel-pkgflags_twofish
# @DESCRIPTION:
# Wrapper for the twofish option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_twofish() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_AVX_X86_64"
		else
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64_3WAY"
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH"
}

# @FUNCTION: _ot-kernel-pkgflags_chacha20
# @DESCRIPTION:
# Wrapper for the chacha20 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_chacha20() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_avx512vl ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20"
}

# @FUNCTION: _ot-kernel-pkgflags_nhpoly1305
# @DESCRIPTION:
# Wrapper for the nhpoly1305 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_nhpoly1305() {
	if [[ "${arch}" == "x86_64" ]] ; then
		if use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_AVX2"
		else
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_SSE2"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305"
}

# @FUNCTION: ot-kernel-pkgflags_cryptsetup
# @DESCRIPTION:
# Applies kernel config flags for the cryptsetup package
ot-kernel-pkgflags_cryptsetup() { # DONE
	if has_version "sys-fs/cryptsetup" ; then
		einfo "Applying kernel config flags for the cryptsetup package"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"	# From ebuild
		ot-kernel_y_configopt "CONFIG_CRYPTO_XTS"
		_ot-kernel-pkgflags_sha256
		_ot-kernel-pkgflags_aes
		# Auto detection (cpuinfo) is not performing because of cross compiling.
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		if [[ "${CRYPTSETUP_TCRYPT}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_HASH"
			ot-kernel_y_configopt "CONFIG_CRYPTO_RMD160"
			_ot-kernel-pkgflags_sha512
			ot-kernel_y_configopt "CONFIG_CRYPTO_WP512"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LRW"	# Block mode
			_ot-kernel-pkgflags_serpent
			_ot-kernel-pkgflags_twofish
		fi
		if [[ "${CRYPTSETUP_ADIANTUM}" == "1" ]] ; then
			_ot-kernel-pkgflags_chacha20
			ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
			_ot-kernel-pkgflags_nhpoly1305
			ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ADIANTUM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_db_numa
# @DESCRIPTION:
# Applies kernel config flags for the db package with numa support
ot-kernel-pkgflags_db_numa() { # DONE
	if has_version "dev-db/mysql[numa]" \
		|| has_version "dev-db/percona-server[numa]" ; then
		einfo "Applying kernel config flags for numa support for a database package"
		ot-kernel_y_configopt "CONFIG_NUMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dbus
# @DESCRIPTION:
# Applies kernel config flags for the dbus package
ot-kernel-pkgflags_dbus() { # DONE
	if has_version "sys-apps/dbus" ; then
		# Implied has_version "sys-apps/dbus[linux_kernel]"
		einfo "Applying kernel config flags for the dbus package"
		ot-kernel_y_configopt "CONFIG_EPOLL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_discord
# @DESCRIPTION:
# Applies kernel config flags for discord
ot-kernel-pkgflags_discord() { # DONE
	if has_version "net-im/discord-bin" ; then
		einfo "Applying kernel config flags for discord"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dropwatch
# @DESCRIPTION:
# Applies kernel config flags for the dropwatch package
ot-kernel-pkgflags_dropwatch() { # DONE
	if has_version "dev-util/dropwatch" ; then
		einfo "Applying kernel config flags for the dropwatch package"
		ot-kernel_y_configopt "CONFIG_NET_DROP_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dracut
# @DESCRIPTION:
# Applies kernel config flags for the dracut package
ot-kernel-pkgflags_dracut() { # DONE
	if has_version "sys-kernel/dracut" ; then
		einfo "Applying kernel config flags for the dracut package"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcec
# @DESCRIPTION:
# Applies kernel config flags for the libcec package
ot-kernel-pkgflags_libcec() { # DONE
	if has_version "dev-libs/libcec[-udev]" ; then
		einfo "Applying kernel config flags for the libcec package"
		ot-kernel_y_configopt "CONFIG_SYSFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_docker
# @DESCRIPTION:
# Applies kernel config flags for the docker package
ot-kernel-pkgflags_docker() { # DONE
	if has_version "app-containers/docker" ; then
		einfo "Applying kernel config flags for the docker package"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_POSIX_MQUEUE"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		if ver_test ${K_MAJOR_MINOR} -le 5.7 ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP"
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP_ENABLED"
		fi
		ot-kernel_y_configopt "CONFIG_BLK_CGROUP"
		if ver_test ${K_MAJOR_MINOR} -le 5.2 ; then
			ot-kernel_y_configopt "CONFIG_DEBUG_BLK_CGROUP"
		fi
		ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_FAIR_GROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_CFS_BANDWIDTH"
		ot-kernel_y_configopt "CONFIG_RT_GROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_CGROUP_PIDS"
		ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
		ot-kernel_y_configopt "CONFIG_CGROUP_HUGETLB"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
		ot-kernel_y_configopt "CONFIG_PROC_PID_CPUSET"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_CGROUP_CPUACCT"
		ot-kernel_y_configopt "CONFIG_CGROUP_PERF"
		ot-kernel_unset_configopt "CGROUP_DEBUG" # Same as "Example controller"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_THROTTLING"
		if ver_test ${K_MAJOR_MINOR} -lt 5.0 ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_CFQ"
			ot-kernel_y_configopt "CONFIG_CFQ_GROUP_IOSCHED"
		fi
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
		ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_IPVS"
		ot-kernel_y_configopt "CONFIG_IP_VS"
		ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_TCP"
		ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_UDP"
		ot-kernel_set_configopt "CONFIG_IP_VS_RR" "m"
		ot-kernel_y_configopt "CONFIG_IP_VS_NFCT"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
		if ver_test ${K_MAJOR_MINOR} -le 5.0 ; then
			ot-kernel_y_configopt "CONFIG_NF_NAT_IPV4"
		fi
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_NETMAP"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REDIRECT"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_DM_THIN_PROVISIONING"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_set_configopt "CONFIG_DUMMY" "m"
		ot-kernel_set_configopt "CONFIG_MACVLAN" "m"
		ot-kernel_set_configopt "CONFIG_IPVLAN" "m"
		ot-kernel_set_configopt "CONFIG_VXLAN" "m"
		ot-kernel_y_configopt "CONFIG_VETH"
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
		ot-kernel_y_configopt "CONFIG_HUGETLBFS"
		ot-kernel_y_configopt "CONFIG_KEYS"
		ot-kernel_y_configopt "CONFIG_PERSISTENT_KEYRINGS"
		ot-kernel_set_configopt "CONFIG_ENCRYPTED_KEYS" "m"
		ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ecryptfs
# @DESCRIPTION:
# Applies kernel config flags for the ecryptfs package
ot-kernel-pkgflags_ecryptfs() { # DONE
	if has_version "sys-fs/ecryptfs-utils" ; then
		einfo "Applying kernel config flags for the ecryptfs package"
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_ECRYPT_FS"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_elogind
# @DESCRIPTION:
# Applies kernel config flags for the elogind package
ot-kernel-pkgflags_elogind() { # DONE
	if has_version "sys-auth/elogind" ; then
		einfo "Applying kernel config flags for the elogind package"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_embree
# @DESCRIPTION:
# Applies kernel config flags for the embree package
ot-kernel-pkgflags_embree() { # DONE
	if has_version "media-libs/embree" ; then
		einfo "Applying kernel config flags for the embree package"
		ot-kernel_y_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_epcam
# @DESCRIPTION:
# Applies kernel config flags for the epcam package
ot-kernel-pkgflags_epcam() { # DONE
	if has_version "media-video/epcam" ; then
		einfo "Applying kernel config flags for the epcam package"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_epoch
# @DESCRIPTION:
# Applies kernel config flags for the epoch package
ot-kernel-pkgflags_epoch() { # DONE
	if has_version "sys-apps/epoch" ; then
		einfo "Applying kernel config flags for the epoch package"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_espeakup
# @DESCRIPTION:
# Applies kernel config flags for the espeakup package
ot-kernel-pkgflags_espeakup() { # DONE
	if has_version "app-accessibility/espeakup" ; then
		einfo "Applying kernel config flags for the espeakup package"
		ot-kernel_y_configopt "CONFIG_SPEAKUP"
		ot-kernel_y_configopt "CONFIG_SPEAKUP_SYNTH_SOFT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eudev
# @DESCRIPTION:
# Applies kernel config flags for the eudev package
ot-kernel-pkgflags_eudev() { # DONE
	if has_version "sys-fs/eudev" ; then
		einfo "Applying kernel config flags for the eudev package"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_UNIX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ff
# @DESCRIPTION:
# Applies kernel config flags for the ff package
ot-kernel-pkgflags_ff() { # DONE
	if has_version "www-client/firefox" ; then
		einfo "Applying kernel config flags for the ff package"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_flatpak
# @DESCRIPTION:
# Applies kernel config flags for the flatpak package
ot-kernel-pkgflags_flatpak() { # DONE
	if has_version " sys-apps/flatpak" ; then
		einfo "Applying kernel config flags for the flatpak package"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firejail
# @DESCRIPTION:
# Applies kernel config flags for the firejail package
ot-kernel-pkgflags_firejail() { # DONE
	if has_version "sys-apps/firejail" ; then
		einfo "Applying kernel config flags for the firejail package"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		if has_version "app-arch/appimaged" \
			|| has_version "app-arch/go-appimage" ; then
			ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
			ot-kernel_y_configopt "CONFIG_SQUASHFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glib
# @DESCRIPTION:
# Applies kernel config flags for the glib package
ot-kernel-pkgflags_glib() { # DONE
	if has_version "dev-libs/glib" ; then
		einfo "Applying kernel config flags for the glib package"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		if has_version "dev-libs/glib[test]" ; then
			ot-kernel_y_configopt "CONFIG_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hd_idle
# @DESCRIPTION:
# Applies kernel config flags for the hd-idle package
ot-kernel-pkgflags_hd_idle() { # DONE
	if has_version "sys-apps/hd-idle" ; then
		einfo "Applying kernel config flags for the hd-idle package"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_irqbalance
# @DESCRIPTION:
# Applies kernel config flags for the irqbalance package
ot-kernel-pkgflags_irqbalance() { # DONE
	if has_version "sys-apps/irqbalance" ; then
		einfo "Applying kernel config flags for the irqbalance package"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwd
# @DESCRIPTION:
# Applies kernel config flags for the iwd package
ot-kernel-pkgflags_iwd() { # DONE
	if has_version "net-wireless/iwd" ; then
		einfo "Applying kernel config flags for the iwd package"
		ot-kernel_y_configopt "CONFIG_ASYMMETRIC_KEY_TYPE"
		ot-kernel_y_configopt "CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE"
		ot-kernel_y_configopt "CONFIG_CFG80211"
		_ot-kernel-pkgflags_aes
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_DES"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ECB"
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MD4"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MD5"
		ot-kernel_y_configopt "CONFIG_CRYPTO_RSA"
		_ot-kernel-pkgflags_sha1
		_ot-kernel-pkgflags_sha256
		_ot-kernel-pkgflags_sha512
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		ot-kernel_y_configopt "CONFIG_PKCS7_MESSAGE_PARSER"
		ot-kernel_y_configopt "CONFIG_RFKILL"
		ot-kernel_y_configopt "CONFIG_X509_CERTIFICATE_PARSER"

		if has_version "net-wireless/iwd[crda]" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"
		fi

		if [[ "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_DES3_EDE_X86_64"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 4.20 ; then
			# Implied has_version "net-wireless/iwd[linux_kernel]"
			ot-kernel_y_configopt "CONFIG_PKCS8_PRIVATE_KEY_PARSER"
		fi
		if has_version "net-wireless/wireless-regdb" && has_version "net-wireless/iwd[crda]" ; then
			einfo "Auto adding CRDA firmware."
			local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
			firmware=$(echo "${firmware}" | tr " " "\n" | sed -r -e "s|regulatory.db(.p7s)?$||g" | tr "\n" " ") # dedupe
			firmware="${firmware} regulatory.db regulatory.db.p7s"
			ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
			firmware=$(echo "${firmware}" | tr " " "\n" | sed -r -e "s|regulatory.db(.p7s)?$||g") # dedupe
			einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kexec_tools
# @DESCRIPTION:
# Applies kernel config flags for the kexec-tools package
ot-kernel-pkgflags_kexec_tools() { # DONE
	if has_version "sys-apps/kexec-tools" ; then
		einfo "Applying kernel config flags for the kexec-tools package"
		ot-kernel_y_configopt "CONFIG_KEXEC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_keyutils
# @DESCRIPTION:
# Applies kernel config flags for the keyutils package
ot-kernel-pkgflags_keyutils() { # DONE
	einfo "Applying kernel config flags for the keyutils package"
	if has_version "sys-apps/keyutils" ; then
		ot-kernel_y_configopt "CONFIG_KEYS"
		if has_version "sys-apps/keyutils[test]" \
			&& ${PV} -ge 2.6.10 && ${K_MAJOR_MINOR} -lt 4.0 ; then
			ot-kernel_y_configopt "CONFIG_KEYS_DEBUG_PROC_KEYS"
		fi
		if has_version ${K_MAJOR_MINOR} -ge 4.7 ; then
			ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kpatch
# @DESCRIPTION:
# Applies kernel config flags for the kpatch package
ot-kernel-pkgflags_kpatch() { # DONE
	if has_version "sys-kernel/kpatch" ; then
		einfo "Applying kernel config flags for the kpatch package"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_HAVE_FENTRY"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcgroup
# @DESCRIPTION:
# Applies kernel config flags for the libcgroup package
ot-kernel-pkgflags_libcgroup() { # DONE
	if has_version "media-libs/libcgroup" ; then
		einfo "Applying kernel config flags for the libcgroup package"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		if has_version "media-libs/libcgroup[daemon]" ; then
			ot-kernel_y_configopt "CONFIG_CONNECTOR"
			ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libv4l
# @DESCRIPTION:
# Applies kernel config flags for the libv4l package
ot-kernel-pkgflags_libv4l() { # DONE
	if has_version "media-libs/libv4l" ; then
		einfo "Applying kernel config flags for the libv4l package"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libvirt
# @DESCRIPTION:
# Applies kernel config flags for the libvirt package
ot-kernel-pkgflags_libvirt() { # DONE
	if has_version "app-emulation/libvirt" ; then
		einfo "Applying kernel config flags for the libvirt package"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
		ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_MARK_T"
		ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_CHECKSUM"
		ot-kernel_y_configopt "CONFIG_IP6_NF_NAT"
		ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_T_NAT"
		ot-kernel_y_configopt "CONFIG_NET_ACT_POLICE"
		ot-kernel_y_configopt "CONFIG_NET_CLS_FW"
		ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
		ot-kernel_y_configopt "CONFIG_NET_SCH_HTB"
		ot-kernel_y_configopt "CONFIG_NET_SCH_INGRESS"
		ot-kernel_y_configopt "CONFIG_NET_SCH_SFQ"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lmsensors
# @DESCRIPTION:
# Applies kernel config flags for the lm-sensors package
ot-kernel-pkgflags_lmsensors() { # DONE
	if has_version "sys-apps/lm-sensors" ; then
		einfo "Applying kernel config flags for the lm-sensors package"
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		ot-kernel_y_configopt "CONFIG_I2C"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_loopaes
# @DESCRIPTION:
# Applies kernel config flags for the loopaes package
ot-kernel-pkgflags_loopaes() { # DONE
	if has_version "sys-fs/loop-aes" ; then
		einfo "Applying kernel config flags for the loop-aes package"
		ot-kernel_unset_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lvm2
# @DESCRIPTION:
# Applies kernel config flags for the lvm2 package
ot-kernel-pkgflags_lvm2() { # DONE
	if has_version "sys-fs/lvm2" ; then
		einfo "Applying kernel config flags for the lvm2 package"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		if has_version "sys-fs/lvm2[udev]" ; then
			ot-kernel_set_configopt "CONFIG_UEVENT_HELPER_PATH" "\"\""
		fi

		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_DM_SNAPSHOT"
		ot-kernel_y_configopt "CONFIG_DM_MIRROR"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH_QL"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH_ST"
		# For raid see also ot-kernel-pkgflags_mdadm
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mdadm
# @DESCRIPTION:
# Applies kernel config flags for the mdadm package
ot-kernel-pkgflags_mdadm() { # DONE
	if has_version "sys-fs/mdadm" ; then
		if [[ "${MDADM_RAID}" == "1" ]] ; then
			einfo "Applying kernel config flags for the mdadm package for software raid"
			ot-kernel_y_configopt "CONFIG_MD"
			ot-kernel_y_configopt "CONFIG_BLK_DEV_MD"
			ot-kernel_y_configopt "CONFIG_MD_AUTODETECT"
			ot-kernel_y_configopt "CONFIG_MD_LINEAR"
			ot-kernel_y_configopt "CONFIG_MD_RAID0"
			ot-kernel_y_configopt "CONFIG_MD_RAID1"
			ot-kernel_y_configopt "CONFIG_MD_RAID10"
			ot-kernel_y_configopt "CONFIG_MD_RAID456"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mesa
# @DESCRIPTION:
# Applies kernel config flags for the mesa package
ot-kernel-pkgflags_mesa() { # DONE
	if has_version "media-libs/mesa" ; then
		einfo "Applying kernel config flags for the mesa package"
		if ver_test ${K_MAJOR_MINOR} -ge 5 ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		else
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mono
# @DESCRIPTION:
# Applies kernel config flags for the mono package
ot-kernel-pkgflags_mono() { # DONE
	if has_version "dev-lang/mono" ; then
		einfo "Applying kernel config flags for the mono package"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_multipath_tools
# @DESCRIPTION:
# Applies kernel config flags for the multipath-tools package
ot-kernel-pkgflags_multipath_tools() { # DONE
	if has_version "sys-fs/multipath-tools" ; then
		einfo "Applying kernel config flags for the multipath-tools package"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_networkmanager
# @DESCRIPTION:
# Applies kernel config flags for the networkmanager package
ot-kernel-pkgflags_networkmanager() { # DONE
	if has_version "net-misc/networkmanager" ; then
		einfo "Applying kernel config flags for the networkmanager package"
		if has_version "net-misc/networkmanager[connection-sharing]" ; then
			if ver_test ${K_MAJOR_MINOR} -lt 5.1 ; then
				ot-kernel_y_configopt "CONFIG_NF_NAT_IPV4"
				ot-kernel_y_configopt "CONFIG_NF_NAT_MASQUERADE_IPV4"
			else
				ot-kernel_y_configopt "CONFIG_NF_NAT"
				ot-kernel_y_configopt "CONFIG_NF_NAT_MASQUERADE"
			fi
		fi
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nilfs
# @DESCRIPTION:
# Applies kernel config flags for the nilfs package
ot-kernel-pkgflags_nilfs() { # DONE
	if has_version "sys-fs/nilfs-utils" ; then
		einfo "Applying kernel config flags for the nilfs package"
		ot-kernel_y_configopt "CONFIG_POSIX_MQUEUE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ntfs3g
# @DESCRIPTION:
# Applies kernel config flags for the ntfs3g package
ot-kernel-pkgflags_ntfs3g() { # DONE
	if has_version "sys-fs/ntfs3g" ; then
		einfo "Applying kernel config flags for the ntfs3g package"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oprofile
# @DESCRIPTION:
# Applies kernel config flags for the oprofile package
ot-kernel-pkgflags_oprofile() { # DONE
	if has_version "dev-util/oprofile" ; then
		einfo "Applying kernel config flags for the oprofile package"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openssl
# @DESCRIPTION:
# Applies kernel config flags for the openssl package
ot-kernel-pkgflags_openssl() { # DONE
	if has_version "dev-libs/openssl[ktls]" && ver_test ${K_MAJOR_MINOR} -ge 4.18 ; then
		einfo "Applying kernel config flags for the openssl package"
		ot-kernel_y_configopt "CONFIG_TLS"
		ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qemu
# @DESCRIPTION:
# Applies kernel config flags for the qemu package
ot-kernel-pkgflags_qemu() { # DONE
	if has_version "app-emulation/qemu" ; then
		einfo "Applying kernel config flags for the qemu package"
		ot-kernel_y_configopt "CONFIG_VIRTUALIZATION"
		ot-kernel_y_configopt "CONFIG_KVM"
		# Don't use lscpu/cpuinfo autodetect if using distcc or
		# cross-compile but use the config itself to guestimate.
		if grep -q -E -e "(CONFIG_MICROCODE_INTEL=y|CONFIG_INTEL_IOMMU=y)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KVM_INTEL"
		fi
		if grep -q -E -e "(CONFIG_MICROCODE_AMD=y|CONFIG_AMD_IOMMU=y)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KVM_AMD"
		fi
		ot-kernel_y_configopt "CONFIG_VHOST_MENU"
		ot-kernel_y_configopt "CONFIG_VHOST_NET"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_y_configopt "CONFIG_TUN"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		QEMU_LINUX_GUEST="1"
		if [[ "${QEMU_LINUX_GUEST}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_HYPERVISOR_GUEST"
			ot-kernel_y_configopt "CONFIG_PARAVIRT"
			ot-kernel_y_configopt "CONFIG_KVM_GUEST"
			ot-kernel_y_configopt "CONFIG_VIRTIO_MENU"
			ot-kernel_y_configopt "CONFIG_VIRTIO_PCI"
			ot-kernel_y_configopt "CONFIG_BLK_DEV"
			ot-kernel_y_configopt "CONFIG_VIRTIO_BLK"
			ot-kernel_y_configopt "CONFIG_SCSI"
			ot-kernel_y_configopt "CONFIG_SCSI_LOWLEVEL"
			ot-kernel_y_configopt "CONFIG_SCSI_VIRTIO"
			ot-kernel_y_configopt "CONFIG_HW_RANDOM"
			ot-kernel_y_configopt "CONFIG_HW_RANDOM_VIRTIO"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_portage
# @DESCRIPTION:
# Applies kernel config flags for the portage package
ot-kernel-pkgflags_portage() { # DONE
	if has_version "sys-apps/portage" ; then
		einfo "Applying kernel config flags for the portage package"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libomp
# @DESCRIPTION:
# Applies kernel config flags for the libomp package
ot-kernel-pkgflags_libomp() { # DONE
	if has_version "sys-libs/libomp" ; then
		ewarn "Severe performance degration with libomp is expected with the PDS scheduler."
		if [[ "${cpu_sched}" =~ ("pds"|"prjc-pds") ]] ; then
			ewarn "Detected use of the PDS scheduler."
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pcmciautils
# @DESCRIPTION:
# Applies kernel config flags for the pcmciautils package
ot-kernel-pkgflags_pcmciautils() { # DONE
	if has_version "sys-apps/pcmciautils" ; then
		einfo "Applying kernel config flags for the pcmciautils package"
		ot-kernel_y_configopt "CONFIG_PCMCIA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_perf
# @DESCRIPTION:
# Applies kernel config flags for the perf package
ot-kernel-pkgflags_perf() { # DONE
	if has_version "dev-util/perf" ; then
		einfo "Applying kernel config flags for the perf package"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pulseaudio
# @DESCRIPTION:
# Applies kernel config flags for the pulseaudio package
ot-kernel-pkgflags_pulseaudio() { # DONE
	if has_version "media-sound/pulseaudio" ; then
		einfo "Applying kernel config flags for the pulseaudio package"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_set_configopt "CONFIG_CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pqiv
# @DESCRIPTION:
# Applies kernel config flags for the pqiv package
ot-kernel-pkgflags_pqiv() { # DONE
	if has_version "media-gfx/pqiv" ; then
		einfo "Applying kernel config flags for the pqiv package"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_postgresql
# @DESCRIPTION:
# Applies kernel config flags for the postgresql package
ot-kernel-pkgflags_postgresql() { # DONE
	if has_version "dev-db/postgresql[server]" ; then
		einfo "Applying kernel config flags for the postgresql package"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powertop
# @DESCRIPTION:
# Applies kernel config flags for the powertop package
ot-kernel-pkgflags_powertop() { # DONE
	if has_version "sys-power/powertop" ; then
		einfo "Applying kernel config flags for the powertop package"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_y_configopt "CONFIG_HPET_TIMER"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_STAT"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
		ot-kernel_y_configopt "CONFIG_TRACING"

		if ver_test ${K_MAJOR_MINOR} -lt 3.7 ; then
			if grep -q -E -e "^SND_HDA_INTEL=(y|m)" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_SND_HDA_POWER_SAVE"
			fi
		fi
		if ver_test ${K_MAJOR_MINOR} -lt 3.9 ; then
			ot-kernel_y_configopt "CONFIG_EVENT_POWER_TRACING_DEPRECATED"
		fi
		if ver_test ${K_MAJOR_MINOR} -lt 3.13 ; then
			ot-kernel_y_configopt "CONFIG_PM_RUNTIME"
		else
			ot-kernel_y_configopt "CONFIG_PM"
		fi
		if ver_test ${K_MAJOR_MINOR} -lt 4.11 ; then
			ot-kernel_y_configopt "CONFIG_TIMER_STATS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_suid_sandbox
# @DESCRIPTION:
# Applies kernel config flags for the suid sandbox
ot-kernel-pkgflags_suid_sandbox() { # DONE
	if has_version "www-client/chromium[suid]" \
		|| [[ "${USE_SUID_SANDBOX}" == "1" ]] ; then
		einfo "Applying kernel config flags for the suid sandbox"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		if grep -q -e "^CONFIG_COMPAT_VDSO=y" "${path_config}" ; then
eerror
eerror "The suid sandbox will break with the CONFIG_COMPAT_VDSO kernel config."
eerror
			die
		fi
		if grep -q -e "^CONFIG_GRKERNSEC=y" "${path_config}" ; then
			# Still added because may add patch via /etc/patches
eerror
eerror "The CONFIG_GRKERNSEC flag will break the suid sandbox."
eerror
			die
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_udev
# @DESCRIPTION:
# Applies kernel config flags for the udev package
ot-kernel-pkgflags_udev() { # DONE
	if has_version "sys-fs/udev" ; then
		einfo "Applying kernel config flags for the udev package"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_unset_configopt "CONFIG_FW_LOADER_USER_HELPER"
		ot-kernel_y_configopt "CONFIG_UNIX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_udisks
# @DESCRIPTION:
# Applies kernel config flags for the udisks package
ot-kernel-pkgflags_udisks() { # DONE
	if has_version "sys-fs/udisks" \
		&& [[ \
			"${arch}" == "arm" \
			|| "${arch}" == "ppc" \
			|| "${arch}" == "ppc64" \
			|| "${arch}" == "x86" \
			|| "${arch}" == "x86_64" \
		]] ; then
		einfo "Applying kernel config flags for the udisks package"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_NLS_UTF8"
		if ver_test ${K_MAJOR_MINOR} -lt 3.10 ; then
			ot-kernel_y_configopt "CONFIG_USB_SUSPEND"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vbox
# @DESCRIPTION:
# Applies kernel config flags for the vbox package
ot-kernel-pkgflags_vbox() { # DONE
	if has_version "app-emulation/virtualbox" ; then
		einfo "Applying kernel config flags for the vbox package"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_VIRTUALIZATION"
		GENTOO_AS_VIRTUALBOX_GUEST="1"
		if [[ "${GENTOO_AS_VIRTUALBOX_GUEST}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_ATA"
			ot-kernel_y_configopt "CONFIG_SATA_AHCI"
			ot-kernel_y_configopt "CONFIG_ATA_SFF"
			ot-kernel_y_configopt "CONFIG_ATA_BMDMA"
			ot-kernel_y_configopt "CONFIG_ATA_PIIX"
			ot-kernel_y_configopt "CONFIG_NETDEVICES"
			ot-kernel_y_configopt "CONFIG_ETHERNET"
			ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
			ot-kernel_y_configopt "CONFIG_E1000"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
			ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD"
			ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
			ot-kernel_y_configopt "CONFIG_MOUSE_PS2"
			ot-kernel_y_configopt "CONFIG_VIRTIO_MENU"
			ot-kernel_y_configopt "CONFIG_VIRTIO_PCI"
			ot-kernel_y_configopt "CONFIG_DRM"
			ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
			ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"
			ot-kernel_y_configopt "CONFIG_FB"
			ot-kernel_y_configopt "CONFIG_DRM_VMWGFX"
			ot-kernel_y_configopt "CONFIG_DRM_VMWGFX_FBCON"
			ot-kernel_y_configopt "CONFIG_FIRMWARE_EDID"
			ot-kernel_y_configopt "CONFIG_FB_SIMPLE"
			ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
			ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY"
			ot-kernel_y_configopt "CONFIG_SOUND"
			ot-kernel_y_configopt "CONFIG_SND"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
			ot-kernel_y_configopt "CONFIG_SND_INTEL8X0"
			ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
			ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD"
			ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_roct
# @DESCRIPTION:
# Applies kernel config flags for roct
ot-kernel-pkgflags_roct() { # DONE
	if has_version "dev-libs/roct-thunk-interface" ; then
		einfo "Applying kernel config flags for roct"
		ot-kernel_y_configopt "CONFIG_HSA_AMD"
		ot-kernel_y_configopt "CONFIG_HMM_MIRROR"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_USERPTR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_steam
# @DESCRIPTION:
# Applies kernel config flags for the steam-meta package
ot-kernel-pkgflags_steam() { # DONE
	if has_version "games-utils/steam-meta" ; then
		einfo "Applying kernel config flags for the steam package"
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemd
# @DESCRIPTION:
# Applies kernel config flags for the systemd package
ot-kernel-pkgflags_systemd() { # DONE
	if has_version "sys-apps/systemd" ; then
		einfo "Applying kernel config flags for the systemd package"
		ot-kernel_y_configopt "CONFIG_AUTOFS4_FS"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		ot-kernel_y_configopt "CONFIG_TMPFS_XATTR"
		ot-kernel_y_configopt "CONFIG_UNIX"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		_ot-kernel-pkgflags_sha256
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_unset_configopt "CONFIG_GRKERNSEC_PROC"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"

		if has_version "sys-apps/systemd[acl]" ; then
			ot-kernel_unset_configopt "CONFIG_TMPFS_POSIX_ACL"
		fi
		if has_version "sys-apps/systemd[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP"
			ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		fi

		if ver_test ${K_MAJOR_MINOR} -lt 3.7 ; then
			ot-kernel_y_configopt "CONFIG_HOTPLUG"
		fi

		if ver_test ${K_MAJOR_MINOR} -ge 4.7 ; then
			ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
		fi

		if ver_test ${K_MAJOR_MINOR} -ge 4.10 ; then
			ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
		fi
		ot-kernel_set_configopt "CONFIG_UEVENT_HELPER_PATH" "\"\""

		if grep -q -e "CONFIG_X86=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vhba
# @DESCRIPTION:
# Applies kernel config flags for the vhba package
ot-kernel-pkgflags_vhba() { # DONE
	if has_version "sys-fs/vhba" ; then
		einfo "Applying kernel config flags for the vhba package"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wavemon
# @DESCRIPTION:
# Applies kernel config flags for the wavemon package
ot-kernel-pkgflags_wavemon() { # DONE
	if has_version "net-wireless/wavemon" ; then
		einfo "Applying kernel config flags for the wavemon package"
		ot-kernel_y_configopt "CONFIG_CFG80211"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wine
# @DESCRIPTION:
# Applies kernel config flags for the wine package
ot-kernel-pkgflags_wine() { # DONE
	if \
		has_version "app-emulation/wine-staging" \
		|| has_version "app-emulation/wine-mono" \
		|| has_version "app-emulation/wine-vanilla" \
		|| has_version "app-emulation/wine-d3d9" \
		|| has_version "app-emulation/wine-any" \
		; then
		einfo "Applying kernel config flags for the wine package"
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"		# For .NET
		if [[ "${arch}" =~ ("x86_64"|"x86") ]] ; then
			ot-kernel_y_configopt "CONFIG_IA32_EMULATION"	# For Legacy 32-bit
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wpa_supplicant
# @DESCRIPTION:
# Applies kernel config flags for the wpa_supplicant package
ot-kernel-pkgflags_wpa_supplicant() { # DONE
	if has_version "net-wireless/wpa_supplicant[crda]" ; then
		einfo "Applying kernel config flags for the wpa_supplicant package"
		ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xen
# @DESCRIPTION:
# Applies kernel config flags for the xen package
ot-kernel-pkgflags_xen() { # DONE
	if has_version "app-emulation/xen" ; then
		einfo "Applying kernel config flags for the xen package"
		ot-kernel_y_configopt "CONFIG_HYPERVISOR_GUEST"
		ot-kernel_y_configopt "CONFIG_PARAVIRT"
		ot-kernel_y_configopt "CONFIG_XEN"
		ot-kernel_y_configopt "CONFIG_XEN_PVH"

		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_HVC_XEN"
		ot-kernel_y_configopt "CONFIG_HVC_XEN_FRONTEND"

		ot-kernel_y_configopt "CONFIG_BLK_DEV"
		ot-kernel_y_configopt "CONFIG_XEN_BLKDEV_FRONTEND"

		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_XEN_NETDEV_FRONTEND"

		if [[ "${XEN_PCI_PASSTHROUGH}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_XEN_PCIDEV_FRONTEND"
		fi

		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
		ot-kernel_y_configopt "CONFIG_INPUT_XEN_KBDDEV_FRONTEND"
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_XEN_FBDEV_FRONTEND"

		ot-kernel_y_configopt "CONFIG_ACPI"

		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
		ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"

		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_TUN"

		ot-kernel_y_configopt "CONFIG_BLK_DEV"
		ot-kernel_y_configopt "CONFIG_XEN_BLKDEV_BACKEND"

		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_XEN_NETDEV_BACKEND"

		ot-kernel_y_configopt "CONFIG_XEN_BALLOON"
		ot-kernel_y_configopt "CONFIG_XEN_SCRUB_PAGES_DEFAULT"
		ot-kernel_y_configopt "CONFIG_XEN_DEV_EVTCHN"
		ot-kernel_y_configopt "CONFIG_XEN_BACKEND"
		ot-kernel_y_configopt "CONFIG_XENFS"
		ot-kernel_y_configopt "CONFIG_XEN_COMPAT_XENFS"
		ot-kernel_y_configopt "CONFIG_XEN_SYS_HYPERVISOR"
		ot-kernel_y_configopt "CONFIG_XEN_GNTDEV"
		ot-kernel_y_configopt "CONFIG_XEN_GRANT_DEV_ALLOC"
		ot-kernel_set_configopt "CONFIG_XEN_PCIDEV_BACKEND" "m"
		ot-kernel_y_configopt "CONFIG_XEN_ACPI_PROCESSOR"
		ot-kernel_y_configopt "CONFIG_XEN_SYMS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpra
# @DESCRIPTION:
# Applies kernel config flags for the xpra package
ot-kernel-pkgflags_xpra() { # DONE
	if has_version "x11-wm/xpra[v4l2]" ; then
		einfo "Applying kernel config flags for the xpra package"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zfs
# @DESCRIPTION:
# Applies kernel config flags for the zfs package
ot-kernel-pkgflags_zfs() { # DONE
	if has_version "sys-fs/zfs[test-suite]" ; then
		einfo "Applying kernel config flags for the zfs package"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}
