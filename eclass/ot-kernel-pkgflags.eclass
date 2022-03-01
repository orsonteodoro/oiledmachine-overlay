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

X86_FLAGS=(aes avx avx2 sha sse2 ssse3)
IUSE+=" ${X86_FLAGS[@]/#/cpu_flags_x86_}"

# @FUNCTION: ban_disable_debug
# @DESCRIPTION:
# Makes disable_debug mutually exclusive with kernel pkgflags
#
# Any function that uses the following keywords (DEBUG, TRACE, VERBOSE, LOG,
# PRINT) in kernel flags should be checked
#
ban_disable_debug() {
	local pkgid="${1}"

# pkgid is produced from the following:
# echo -n "${CATEGORY}/${PN}" | sha512sum | cut -f 1 -d " " | cut -c 1-7

	if [[ "${OT_KERNEL_FORCE_APPLY_DISABLE_DEBUG}" == "1" ]] ; then
		:
	elif [[ "${OT_KERNEL_PKGFLAGS_ACCEPT}" =~ "${pkgid}" ]] ; then
		:
	elif use disable_debug ; then
eerror
eerror "Using OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS with the disable_debug"
eerror "USE flag are in conflict with a package with certain set of kernel"
eerror "flags."
eerror
eerror "Choices:"
eerror
eerror "1. Disable the disable_debug USE flag."
eerror "2. Add OT_KERNEL_PKGFLAGS_SKIP=\"${pkgid}\" in the space separated list."
eerror "3. Add OT_KERNEL_PKGFLAGS_ACCEPT=\"${pkgid}\" in the space separated list."
eerror
eerror "Called from ${FUNCNAME[1]}.  See ot-kernel-pkgflags.eclass from the"
eerror "eclass folder for details using ${pkgid} for the conflicting debug"
eerror "flags needed by the package(s)."
eerror
		die
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apply
# @DESCRIPTION:
# The main function to apply all kernel config flags for package.
ot-kernel-pkgflags_apply() {
	[[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && return
	ot-kernel-pkgflags_actkbd
	ot-kernel-pkgflags_bcm_sta
	ot-kernel-pkgflags_bees
	ot-kernel-pkgflags_blueman
	ot-kernel-pkgflags_bluez
	#ot-kernel-pkgflags_boinc
	ot-kernel-pkgflags_bolt
	ot-kernel-pkgflags_bubblewrap
	ot-kernel-pkgflags_clamfs
	ot-kernel-pkgflags_conky
	ot-kernel-pkgflags_cryfs
	ot-kernel-pkgflags_cryptodev
	ot-kernel-pkgflags_cryptsetup
	ot-kernel-pkgflags_db_numa
	ot-kernel-pkgflags_dbus
	ot-kernel-pkgflags_discord
	ot-kernel-pkgflags_distrobuilder
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
	ot-kernel-pkgflags_eventd
	ot-kernel-pkgflags_ff
	ot-kernel-pkgflags_firewalld
	ot-kernel-pkgflags_flatpak
	ot-kernel-pkgflags_firejail
	ot-kernel-pkgflags_fuse
	ot-kernel-pkgflags_glib
	ot-kernel-pkgflags_gpm
	ot-kernel-pkgflags_guestfs
	ot-kernel-pkgflags_hd_idle
	ot-kernel-pkgflags_iptables
	ot-kernel-pkgflags_irqbalance
	ot-kernel-pkgflags_iwd
	ot-kernel-pkgflags_kexec_tools
	ot-kernel-pkgflags_kpatch
	ot-kernel-pkgflags_keyutils
	ot-kernel-pkgflags_libcec
	ot-kernel-pkgflags_libcgroup
	ot-kernel-pkgflags_libnetfilter_conntrack
	ot-kernel-pkgflags_libv4l
	ot-kernel-pkgflags_libvirt
	ot-kernel-pkgflags_lmsensors
	ot-kernel-pkgflags_loopaes
	ot-kernel-pkgflags_lvm2
	ot-kernel-pkgflags_lxc
	ot-kernel-pkgflags_mdadm
	ot-kernel-pkgflags_mesa
	ot-kernel-pkgflags_minijail
	ot-kernel-pkgflags_mono
	ot-kernel-pkgflags_multipath_tools
	ot-kernel-pkgflags_networkmanager
	ot-kernel-pkgflags_nftables
	ot-kernel-pkgflags_nilfs
	ot-kernel-pkgflags_ntfs3g
	ot-kernel-pkgflags_nv
	ot-kernel-pkgflags_openssl
	ot-kernel-pkgflags_oprofile
	ot-kernel-pkgflags_pcmciautils
	ot-kernel-pkgflags_perf
	ot-kernel-pkgflags_portage
	ot-kernel-pkgflags_postgresql
	ot-kernel-pkgflags_powernowd
	ot-kernel-pkgflags_powertop
	ot-kernel-pkgflags_pulseaudio
	ot-kernel-pkgflags_pqiv
	ot-kernel-pkgflags_qemu
	ot-kernel-pkgflags_roct
	ot-kernel-pkgflags_runc
	ot-kernel-pkgflags_shorewall
	ot-kernel-pkgflags_spacenavd
	ot-kernel-pkgflags_spice_vdagent
	ot-kernel-pkgflags_squid
	ot-kernel-pkgflags_suid_sandbox
	ot-kernel-pkgflags_steam
	ot-kernel-pkgflags_systemd
	ot-kernel-pkgflags_tb_us
	ot-kernel-pkgflags_udev
	ot-kernel-pkgflags_udisks
	ot-kernel-pkgflags_undervolt
	ot-kernel-pkgflags_v4l2loopback
	ot-kernel-pkgflags_vbox
	ot-kernel-pkgflags_vhba
	ot-kernel-pkgflags_wavemon
	ot-kernel-pkgflags_wine
	ot-kernel-pkgflags_wpa_supplicant
	ot-kernel-pkgflags_xen
	ot-kernel-pkgflags_xf86_input_evdev
	ot-kernel-pkgflags_xf86_input_libinput
	ot-kernel-pkgflags_xf86_video_ati
	ot-kernel-pkgflags_xfce4_battery_plugin
	ot-kernel-pkgflags_xpra
	ot-kernel-pkgflags_zfs
}

# @FUNCTION: ot-kernel-pkgflags_actkbd
# @DESCRIPTION:
# Applies kernel config flags for the actkbd
ot-kernel-pkgflags_actkbd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1ee4e36" ]] && return
	if has_version "app-misc/actkbd" ; then
		einfo "Applying kernel config flags for actkbd (id: 1ee4e36)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcm_sta
# @DESCRIPTION:
# Applies kernel config flags for the bcm-sta
ot-kernel-pkgflags_bcm_sta() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "155d9fc" ]] && return
	if has_version "net-wireless/broadcom-sta" ; then
		einfo "Applying kernel config flags for bcm-sta (id: 155d9fc)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "27ea6ce" ]] && return
	if has_version "sys-fs/bees" ; then
		einfo "Applying kernel config flags for bees package (id: 27ea6ce)"
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blueman
# @DESCRIPTION:
# Applies kernel config flags for the blueman package
ot-kernel-pkgflags_blueman() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c3a2203" ]] && return
	if has_version "net-wireless/blueman[network]" ; then
		einfo "Applying kernel config flags for the blueman package (id: c3a2203)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "73d2a26" ]] && return
	if has_version "sys-apps/bluez" ; then
		einfo "Applying kernel config flags for the bluez package (id: 73d2a26)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e9d3694" ]] && return
	if has_version "sci-misc/boinc" ; then
		einfo "Applying kernel config flags for the boinc package (id: e9d3694)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0bf997d" ]] && return
	if has_version "sys-apps/bolt[kernel_linux]" ; then
		einfo "Applying kernel config flags for the bolt package (id: 0bf997d)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4255ad7" ]] && return
	if has_version "sys-apps/bubblewrap" ; then
		einfo "Applying kernel config flags for the bubblewrap package (id: 4255ad7)"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clamfs
# @DESCRIPTION:
# Applies kernel config flags for the clamfs package
ot-kernel-pkgflags_clamfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bbd28c4" ]] && return
	if has_version "sys-fs/clamfs" ; then
		einfo "Applying kernel config flags for the clamfs package (id: bbd28c4)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_conky
# @DESCRIPTION:
# Applies kernel config flags for the conky package
ot-kernel-pkgflags_conky() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0a83d3b" ]] && return
	if has_version "app-admin/conky" ; then
		einfo "Applying kernel config flags for the conky package (id: 0a83d3b)"
		ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryfs
# @DESCRIPTION:
# Applies kernel config flags for the cryfs package
ot-kernel-pkgflags_cryfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4cd1f23" ]] && return
	if has_version "sys-fs/cryfs" ; then
		einfo "Applying kernel config flags for the cryfs package (id: 4cd1f23)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryptodev
# @DESCRIPTION:
# Applies kernel config flags for the cryptodev package
ot-kernel-pkgflags_cryptodev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5bfeb14" ]] && return
	if has_version "sys-kernel/cryptodev" ; then
		einfo "Applying kernel config flags for the cryptodev package (id: 5bfeb14)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "de0f460" ]] && return
	if has_version "sys-fs/cryptsetup" ; then
		einfo "Applying kernel config flags for the cryptsetup package (id: de0f460)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b150cb7" ]] && return
	if has_version "dev-db/mysql[numa]" \
		|| has_version "dev-db/percona-server[numa]" ; then
		einfo "Applying kernel config flags for numa support for a database package (id: b150cb7)"
		ot-kernel_y_configopt "CONFIG_NUMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dbus
# @DESCRIPTION:
# Applies kernel config flags for the dbus package
ot-kernel-pkgflags_dbus() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b9e31e7" ]] && return
	if has_version "sys-apps/dbus" ; then
		# Implied has_version "sys-apps/dbus[linux_kernel]"
		einfo "Applying kernel config flags for the dbus package (id: b9e31e7)"
		ot-kernel_y_configopt "CONFIG_EPOLL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_discord
# @DESCRIPTION:
# Applies kernel config flags for discord
ot-kernel-pkgflags_discord() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bcc3f54" ]] && return
	if has_version "net-im/discord-bin" ; then
		einfo "Applying kernel config flags for discord (id: bcc3f54)"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_distrobuilder
# @DESCRIPTION:
# Applies kernel config flags for the distrobuilder package
ot-kernel-pkgflags_distrobuilder() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9ed33e8" ]] && return
	if has_version "app-containers/distrobuilder" ; then
		einfo "Applying kernel config flags for distrobuilder package (id: 9ed33e8)"
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dropwatch
# @DESCRIPTION:
# Applies kernel config flags for the dropwatch package
ot-kernel-pkgflags_dropwatch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7422820" ]] && return
	if has_version "dev-util/dropwatch" ; then
		einfo "Applying kernel config flags for the dropwatch package (id: 7422820)"
		ot-kernel_y_configopt "CONFIG_NET_DROP_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dracut
# @DESCRIPTION:
# Applies kernel config flags for the dracut package
ot-kernel-pkgflags_dracut() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "494db6b" ]] && return
	if has_version "sys-kernel/dracut" ; then
		einfo "Applying kernel config flags for the dracut package (id: 494db6b)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcec
# @DESCRIPTION:
# Applies kernel config flags for the libcec package
ot-kernel-pkgflags_libcec() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c7a68c0" ]] && return
	if has_version "dev-libs/libcec[-udev]" ; then
		einfo "Applying kernel config flags for the libcec package (id: c7a68c0)"
		ot-kernel_y_configopt "CONFIG_SYSFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_docker
# @DESCRIPTION:
# Applies kernel config flags for the docker package
ot-kernel-pkgflags_docker() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "05309e2" ]] && return
	if has_version "app-containers/docker" ; then
		einfo "Applying kernel config flags for the docker package (id: 05309e2)"
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
			ban_disable_debug "05309e2"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7e08ae3" ]] && return
	if has_version "sys-fs/ecryptfs-utils" ; then
		einfo "Applying kernel config flags for the ecryptfs package (id: 7e08ae3)"
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_ECRYPT_FS"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_elogind
# @DESCRIPTION:
# Applies kernel config flags for the elogind package
ot-kernel-pkgflags_elogind() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e7308d9" ]] && return
	if has_version "sys-auth/elogind" ; then
		einfo "Applying kernel config flags for the elogind package (id: e7308d9)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "121bc50" ]] && return
	if has_version "media-libs/embree" ; then
		einfo "Applying kernel config flags for the embree package (id: 121bc50)"
		ot-kernel_y_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_epcam
# @DESCRIPTION:
# Applies kernel config flags for the epcam package
ot-kernel-pkgflags_epcam() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6922e7a" ]] && return
	if has_version "media-video/epcam" ; then
		einfo "Applying kernel config flags for the epcam package (id: 6922e7a)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5e952fe" ]] && return
	if has_version "sys-apps/epoch" ; then
		einfo "Applying kernel config flags for the epoch package (id: 5e952fe)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_espeakup
# @DESCRIPTION:
# Applies kernel config flags for the espeakup package
ot-kernel-pkgflags_espeakup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5202028" ]] && return
	if has_version "app-accessibility/espeakup" ; then
		einfo "Applying kernel config flags for the espeakup package (id: 5202028)"
		ot-kernel_y_configopt "CONFIG_SPEAKUP"
		ot-kernel_y_configopt "CONFIG_SPEAKUP_SYNTH_SOFT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eudev
# @DESCRIPTION:
# Applies kernel config flags for the eudev package
ot-kernel-pkgflags_eudev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9c95acb" ]] && return
	if has_version "sys-fs/eudev" ; then
		einfo "Applying kernel config flags for the eudev package (id: 9c95acb)"
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

# @FUNCTION: ot-kernel-pkgflags_eventd
# @DESCRIPTION:
# Applies kernel config flags for the eventd package
ot-kernel-pkgflags_eventd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9baffe9" ]] && return
	if has_version "net-misc/eventd[ipv6]" ; then
		einfo "Applying kernel config flags for the eventd package (id: 9baffe9)"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ff
# @DESCRIPTION:
# Applies kernel config flags for the ff package
ot-kernel-pkgflags_ff() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b5b1507" ]] && return
	if has_version "www-client/firefox" ; then
		einfo "Applying kernel config flags for the ff package (id: b5b1507)"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firewalld
# @DESCRIPTION:
# Applies kernel config flags for the firewalld package
ot-kernel-pkgflags_firewalld() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6c85b82" ]] && return
	if has_version "net-firewall/firewalld" ; then
		einfo "Applying kernel config flags for the firewalld package (id: 6c85b82)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
		ot-kernel_y_configopt "CONFIG_NETFILTER_INGRESS"
		ot-kernel_y_configopt "CONFIG_NF_NAT_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_NF_NAT_REDIRECT"
		ot-kernel_y_configopt "CONFIG_NF_TABLES_INET"
		ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV6"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_BROADCAST"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_NETBIOS"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_TFTP"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_HELPER"
		ot-kernel_y_configopt "CONFIG_NF_DEFRAG_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_DEFRAG_IPV6"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NF_NAT_TFTP"
		ot-kernel_y_configopt "CONFIG_NF_REJECT_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_REJECT_IPV6"
		ot-kernel_y_configopt "CONFIG_NF_SOCKET_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_SOCKET_IPV6"
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
		ot-kernel_y_configopt "CONFIG_NF_TABLES_SET"
		ot-kernel_y_configopt "CONFIG_NF_TPROXY_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_TPROXY_IPV6"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
		ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
		ot-kernel_y_configopt "CONFIG_IP_NF_SECURITY"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		ot-kernel_y_configopt "CONFIG_IP6_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
		ot-kernel_y_configopt "CONFIG_IP6_NF_NAT"
		ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
		ot-kernel_y_configopt "CONFIG_IP6_NF_SECURITY"
		ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_REJECT"
		ot-kernel_y_configopt "CONFIG_IP_SET"
		ot-kernel_y_configopt "CONFIG_NETFILTER_CONNCOUNT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_OSF"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_SYNPROXY"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_NAT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_NFT_COMPAT"
		ot-kernel_y_configopt "CONFIG_NFT_COUNTER"
		ot-kernel_y_configopt "CONFIG_NFT_CT"
		ot-kernel_y_configopt "CONFIG_NFT_FIB"
		ot-kernel_y_configopt "CONFIG_NFT_FIB_INET"
		ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV4"
		ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV6"
		ot-kernel_y_configopt "CONFIG_NFT_HASH"
		ot-kernel_y_configopt "CONFIG_NFT_LIMIT"
		ban_disable_debug "6c85b82"
		ot-kernel_y_configopt "CONFIG_NFT_LOG"
		ot-kernel_y_configopt "CONFIG_NFT_MASQ"
		ot-kernel_y_configopt "CONFIG_NFT_NAT"
		ot-kernel_y_configopt "CONFIG_NFT_NET"
		ot-kernel_y_configopt "CONFIG_NFT_OBJREF"
		ot-kernel_y_configopt "CONFIG_NFT_QUEUE"
		ot-kernel_y_configopt "CONFIG_NFT_QUOTA"
		ot-kernel_y_configopt "CONFIG_NFT_REDIR"
		ot-kernel_y_configopt "CONFIG_NFT_REJECT"
		ot-kernel_y_configopt "CONFIG_NFT_REJECT_INET"
		ot-kernel_y_configopt "CONFIG_NFT_REJECT_IPV4"
		ot-kernel_y_configopt "CONFIG_NFT_REJECT_IPV6"
		ot-kernel_y_configopt "CONFIG_NFT_SOCKET"
		ot-kernel_y_configopt "CONFIG_NFT_SYNPROXY"
		ot-kernel_y_configopt "CONFIG_NFT_TPROXY"
		ot-kernel_y_configopt "CONFIG_NFT_TUNNEL"
		ot-kernel_y_configopt "CONFIG_NFT_XFRM"
		if ver_test ${K_MAJOR_MINOR} -lt 4.19 ; then
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_flatpak
# @DESCRIPTION:
# Applies kernel config flags for the flatpak package
ot-kernel-pkgflags_flatpak() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "427345a" ]] && return
	if has_version "sys-apps/flatpak" ; then
		einfo "Applying kernel config flags for the flatpak package (id: 427345a)"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firejail
# @DESCRIPTION:
# Applies kernel config flags for the firejail package
ot-kernel-pkgflags_firejail() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "222b6c4" ]] && return
	if has_version "sys-apps/firejail" ; then
		einfo "Applying kernel config flags for the firejail package (id: 222b6c4)"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		if has_version "app-arch/appimaged" \
			|| has_version "app-arch/go-appimage" ; then
			ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
			ot-kernel_y_configopt "CONFIG_SQUASHFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_fuse
# @DESCRIPTION:
# Applies kernel config flags for the fuse package
ot-kernel-pkgflags_fuse() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7a6e898" ]] && return
	if has_version "sys-fs/fuse" ; then
		einfo "Applying kernel config flags for the fuse package (id: 7a6e898)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}


# @FUNCTION: ot-kernel-pkgflags_glib
# @DESCRIPTION:
# Applies kernel config flags for the glib package
ot-kernel-pkgflags_glib() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "8210745" ]] && return
	if has_version "dev-libs/glib" ; then
		einfo "Applying kernel config flags for the glib package (id: 8210745)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		if has_version "dev-libs/glib[test]" ; then
			ot-kernel_y_configopt "CONFIG_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gpm
# @DESCRIPTION:
# Applies kernel config flags for the gpm package
ot-kernel-pkgflags_gpm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ed780a3" ]] && return
	if has_version "sys-libs/gpm" ; then
		einfo "Applying kernel config flags for the gpm package (id: ed780a3)"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_guestfs
# @DESCRIPTION:
# Applies kernel config flags for the guestfs package(s)
ot-kernel-pkgflags_guestfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "59d09c6" ]] && return
	if has_version "app-emulation/libguestfs" \
		|| has_version "app-emulation/guestfs-tools" ; then
		einfo "Applying kernel config flags for the guestfs package(s) (id: 59d09c6)"
		ot-kernel_y_configopt "CONFIG_KVM"
		ot-kernel_y_configopt "CONFIG_VIRTIO"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hd_idle
# @DESCRIPTION:
# Applies kernel config flags for the hd-idle package
ot-kernel-pkgflags_hd_idle() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c6f5c62" ]] && return
	if has_version "sys-apps/hd-idle" ; then
		einfo "Applying kernel config flags for the hd-idle package (id: c6f5c62)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iptables
# @DESCRIPTION:
# Applies kernel config flags for the iptables package
ot-kernel-pkgflags_iptables() { # MOSTLY DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "351365c" ]] && return
	if has_version "net-firewall/iptables" ; then
		einfo "Applying kernel config flags for the iptables package (id: 351365c)"
		IPTABLES_CLIENT=1
		if [[ "${IPTABLES_CLIENT}" == "1" ]] ; then # DONE
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_NET_IPVTI"
			if ver_test ${K_MAJOR_MINOR} -le 5.1 ; then
				ot-kernel_y_configopt "CONFIG_INET_XFRM_MODE_TRANSPORT"
				ot-kernel_y_configopt "CONFIG_INET_XFRM_MODE_TUNNEL"
			fi
			ot-kernel_y_configopt "CONFIG_INET_DIAG"
			ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ban_disable_debug "351365c"
			ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
			if ver_test ${K_MAJOR_MINOR} -le 4.18 ; then
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
			fi
			ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
			ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP6_NF_FILTER"
			ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_REJECT"
		fi
		if [[ "${IPTABLES_ROUTER}" == "1" ]] ; then # MAYBE DONE
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"
			ot-kernel_set_configopt "CONFIG_INET_AH" "m"
			ot-kernel_set_configopt "CONFIG_INET_ESP" "m"
			ot-kernel_set_configopt "CONFIG_INET_IPCOMP" "m"

			if ver_test ${K_MAJOR_MINOR} -le 4.5 ; then
				ot-kernel_y_configopt "CONFIG_INET_LRO"
			fi

			if ver_test ${K_MAJOR_MINOR} -le 5.1 ; then
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_TRANSPORT" "m"
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_TUNNEL" "m"
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_BEET" "m"
			fi

			ot-kernel_y_configopt "CONFIG_INET_DIAG"
			ot-kernel_set_configopt "CONFIG_INET_UDP_DIAG" "m"

			ot-kernel_set_configopt "CONFIG_IPV6" "m"

			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
			ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
			ot-kernel_set_configopt "CONFIG_IP_SET" "m"
			ot-kernel_set_configopt "CONFIG_IP_VS" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_HL" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_LIMIT" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT" "m"
			ot-kernel_set_configopt "CONFIG_NETFILTER_XT_MATCH_RECENT" "m"

			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_EVENTS"

			ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
			ban_disable_debug "351365c"
			ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"

			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFLOG"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"

			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNBYTES"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNMARK"

			ot-kernel_set_configopt "CONFIG_BRIDGE_NF_EBTABLES" "m"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_irqbalance
# @DESCRIPTION:
# Applies kernel config flags for the irqbalance package
ot-kernel-pkgflags_irqbalance() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "115a3c8" ]] && return
	if has_version "sys-apps/irqbalance" ; then
		einfo "Applying kernel config flags for the irqbalance package (id: 115a3c8)"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwd
# @DESCRIPTION:
# Applies kernel config flags for the iwd package
ot-kernel-pkgflags_iwd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c4eefdd" ]] && return
	if has_version "net-wireless/iwd" ; then
		einfo "Applying kernel config flags for the iwd package (id: c4eefdd)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "39aeb63" ]] && return
	if has_version "sys-apps/kexec-tools" ; then
		einfo "Applying kernel config flags for the kexec-tools package (id: 39aeb63)"
		ot-kernel_y_configopt "CONFIG_KEXEC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_keyutils
# @DESCRIPTION:
# Applies kernel config flags for the keyutils package
ot-kernel-pkgflags_keyutils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2082e35" ]] && return
	if has_version "sys-apps/keyutils" ; then
		einfo "Applying kernel config flags for the keyutils package (id: 2082e35)"
		ot-kernel_y_configopt "CONFIG_KEYS"
		if has_version "sys-apps/keyutils[test]" \
			&& ver_test ${PV} -ge 2.6.10 && ${K_MAJOR_MINOR} -lt 4.0 ; then
			ban_disable_debug "2082e35"
			ot-kernel_y_configopt "CONFIG_KEYS_DEBUG_PROC_KEYS"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 4.7 ; then
			ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kpatch
# @DESCRIPTION:
# Applies kernel config flags for the kpatch package
ot-kernel-pkgflags_kpatch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "d26d135" ]] && return
	if has_version "sys-kernel/kpatch" ; then
		einfo "Applying kernel config flags for the kpatch package (id: d26d135)"
		ban_disable_debug "d26d135"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "fe830d2" ]] && return
	if has_version "media-libs/libcgroup" ; then
		einfo "Applying kernel config flags for the libcgroup package (id: fe830d2)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		if has_version "media-libs/libcgroup[daemon]" ; then
			ot-kernel_y_configopt "CONFIG_CONNECTOR"
			ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_conntrack package
ot-kernel-pkgflags_libnetfilter_conntrack() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2616787" ]] && return
	if has_version "net-libs/libnetfilter_conntrack" ; then
		einfo "Applying kernel config flags for the libnetfilter_conntrack package (id: 2616787)"
		if ver_test ${PV} -lt 2.6.20 ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libv4l
# @DESCRIPTION:
# Applies kernel config flags for the libv4l package
ot-kernel-pkgflags_libv4l() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4b528f3" ]] && return
	if has_version "media-libs/libv4l" ; then
		einfo "Applying kernel config flags for the libv4l package (id: 4b528f3)"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libvirt
# @DESCRIPTION:
# Applies kernel config flags for the libvirt package
ot-kernel-pkgflags_libvirt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7953656" ]] && return
	if has_version "app-emulation/libvirt" ; then
		einfo "Applying kernel config flags for the libvirt package (id: 7953656)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "aef80f1" ]] && return
	if has_version "sys-apps/lm-sensors" ; then
		einfo "Applying kernel config flags for the lm-sensors package (id: aef80f1)"
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		ot-kernel_y_configopt "CONFIG_I2C"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_loopaes
# @DESCRIPTION:
# Applies kernel config flags for the loopaes package
ot-kernel-pkgflags_loopaes() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bba669f" ]] && return
	if has_version "sys-fs/loop-aes" ; then
		einfo "Applying kernel config flags for the loop-aes package (id: bba669f)"
		ot-kernel_unset_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lvm2
# @DESCRIPTION:
# Applies kernel config flags for the lvm2 package
ot-kernel-pkgflags_lvm2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "48609ad" ]] && return
	if has_version "sys-fs/lvm2" ; then
		einfo "Applying kernel config flags for the lvm2 package (id: 48609ad)"
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

# @FUNCTION: ot-kernel-pkgflags_lxc
# @DESCRIPTION:
# Applies kernel config flags for the lxc package
ot-kernel-pkgflags_lxc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7e097b4" ]] && return
	if has_version "app-containers/lxc" ; then
		einfo "Applying kernel config flags for the lxc package (id: 7e097b4)"
		ot-kernel_unset_configopt "CONFIG_NETPRIO_CGROUP"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_CGROUP_CPUACCT"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
		ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_MACVLAN"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_POSIX_MQUEUE"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_VETH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mdadm
# @DESCRIPTION:
# Applies kernel config flags for the mdadm package
ot-kernel-pkgflags_mdadm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2c79f42" ]] && return
	if has_version "sys-fs/mdadm" ; then
		if [[ "${MDADM_RAID}" == "1" ]] ; then
			einfo "Applying kernel config flags for the mdadm package for software raid (id: 2c79f42)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "a7c616c" ]] && return
	if has_version "media-libs/mesa" ; then
		einfo "Applying kernel config flags for the mesa package (id: a7c616c)"
		if ver_test ${K_MAJOR_MINOR} -ge 5 ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		else
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_minijail
# @DESCRIPTION:
# Applies kernel config flags for the minijail package
ot-kernel-pkgflags_minijail() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "792b443" ]] && return
	if has_version "sys-apps/minijail" ; then
		einfo "Applying kernel config flags for the minijail package (id: 792b443)"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mono
# @DESCRIPTION:
# Applies kernel config flags for the mono package
ot-kernel-pkgflags_mono() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "8c7d25b" ]] && return
	if has_version "dev-lang/mono" ; then
		einfo "Applying kernel config flags for the mono package (id: 8c7d25b)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_multipath_tools
# @DESCRIPTION:
# Applies kernel config flags for the multipath-tools package
ot-kernel-pkgflags_multipath_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "18a1928" ]] && return
	if has_version "sys-fs/multipath-tools" ; then
		einfo "Applying kernel config flags for the multipath-tools package (id: 18a1928)"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_networkmanager
# @DESCRIPTION:
# Applies kernel config flags for the networkmanager package
ot-kernel-pkgflags_networkmanager() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f8aec8c" ]] && return
	if has_version "net-misc/networkmanager" ; then
		einfo "Applying kernel config flags for the networkmanager package (id: f8aec8c)"
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

# @FUNCTION: ot-kernel-pkgflags_nftables
# @DESCRIPTION:
# Applies kernel config flags for the nftables package
ot-kernel-pkgflags_nftables() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "70aa284" ]] && return
	if has_version "net-firewall/nftables" && ver_test ${K_MAJOR_MINOR} -ge 3.13 ; then
		einfo "Applying kernel config flags for the nftables package (id: 70aa284)"
		ot-kernel_unset_configopt "CONFIG_NF_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nilfs
# @DESCRIPTION:
# Applies kernel config flags for the nilfs package
ot-kernel-pkgflags_nilfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "908989f" ]] && return
	if has_version "sys-fs/nilfs-utils" ; then
		einfo "Applying kernel config flags for the nilfs package (id: 908989f)"
		ot-kernel_y_configopt "CONFIG_POSIX_MQUEUE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ntfs3g
# @DESCRIPTION:
# Applies kernel config flags for the ntfs3g package
ot-kernel-pkgflags_ntfs3g() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ed423cb" ]] && return
	if has_version "sys-fs/ntfs3g" ; then
		einfo "Applying kernel config flags for the ntfs3g package (id: ed423cb)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nv
# @DESCRIPTION:
# Applies kernel config flags for the nv driver
ot-kernel-pkgflags_nv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f314ac3" ]] && return
	if has_version "x11-drivers/nvidia-drivers" ; then
		einfo "Applying kernel config flags for the nv driver (id: f314ac3)"

		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_unset_configopt "CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT"
		ot-kernel_unset_configopt "CONFIG_LOCKDEP"
		ban_disable_debug "f314ac3"
		ot-kernel_unset_configopt "CONFIG_DEBUG_MUTEXES"

		if ${K_MAJOR_MINOR} -ge 5.8 ; then
			ot-kernel_y_configopt "CONFIG_X86_PAT"
		fi
		# Workaround mentioned in the ebuild
		# It's better to modify the Kconfig.
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oprofile
# @DESCRIPTION:
# Applies kernel config flags for the oprofile package
ot-kernel-pkgflags_oprofile() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "18e7433" ]] && return
	if has_version "dev-util/oprofile" ; then
		einfo "Applying kernel config flags for the oprofile package (id: 18e7433)"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openssl
# @DESCRIPTION:
# Applies kernel config flags for the openssl package
ot-kernel-pkgflags_openssl() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0dcc9b8" ]] && return
	if has_version "dev-libs/openssl[ktls]" && ver_test ${K_MAJOR_MINOR} -ge 4.18 ; then
		einfo "Applying kernel config flags for the openssl package (id: 0dcc9b8)"
		ot-kernel_y_configopt "CONFIG_TLS"
		ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qemu
# @DESCRIPTION:
# Applies kernel config flags for the qemu package
ot-kernel-pkgflags_qemu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "00f70b8" ]] && return
	if has_version "app-emulation/qemu" ; then
		einfo "Applying kernel config flags for the qemu package (id: 00f70b8)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0be29dc" ]] && return
	if has_version "sys-apps/portage" ; then
		einfo "Applying kernel config flags for the portage package (id: 0be29dc)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "90741ba" ]] && return
	if has_version "sys-libs/libomp" ; then
		ewarn "Severe performance degration with libomp is expected with the PDS scheduler. (id: 90741ba)"
		if [[ "${cpu_sched}" =~ ("pds"|"prjc-pds") ]] ; then
			ewarn "Detected use of the PDS scheduler."
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pcmciautils
# @DESCRIPTION:
# Applies kernel config flags for the pcmciautils package
ot-kernel-pkgflags_pcmciautils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "04119e0" ]] && return
	if has_version "sys-apps/pcmciautils" ; then
		einfo "Applying kernel config flags for the pcmciautils package (id: 04119e0)"
		ot-kernel_y_configopt "CONFIG_PCMCIA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_perf
# @DESCRIPTION:
# Applies kernel config flags for the perf package
ot-kernel-pkgflags_perf() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ef529b7" ]] && return
	if has_version "dev-util/perf" ; then
		einfo "Applying kernel config flags for the perf package (id: ef529b7)"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pulseaudio
# @DESCRIPTION:
# Applies kernel config flags for the pulseaudio package
ot-kernel-pkgflags_pulseaudio() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "40b66c8" ]] && return
	if has_version "media-sound/pulseaudio" ; then
		einfo "Applying kernel config flags for the pulseaudio package (id: 40b66c8)"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_set_configopt "CONFIG_CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pqiv
# @DESCRIPTION:
# Applies kernel config flags for the pqiv package
ot-kernel-pkgflags_pqiv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "85b64bd" ]] && return
	if has_version "media-gfx/pqiv" ; then
		einfo "Applying kernel config flags for the pqiv package (id: 85b64bd)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_postgresql
# @DESCRIPTION:
# Applies kernel config flags for the postgresql package
ot-kernel-pkgflags_postgresql() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b3f021a" ]] && return
	if has_version "dev-db/postgresql[server]" ; then
		einfo "Applying kernel config flags for the postgresql package (id: b3f021a)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powernowd
# @DESCRIPTION:
# Applies kernel config flags for the powernowd package
ot-kernel-pkgflags_powernowd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "cceb5ce" ]] && return
	if has_version "sys-power/powernowd" ; then
		einfo "Applying kernel config flags for the powernowd package (id: cceb5ce)"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powertop
# @DESCRIPTION:
# Applies kernel config flags for the powertop package
ot-kernel-pkgflags_powertop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "87ebe78" ]] && return
	if has_version "sys-power/powertop" ; then
		einfo "Applying kernel config flags for the powertop package (id: 87ebe78)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ban_disable_debug "87ebe78"
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

# @FUNCTION: ot-kernel-pkgflags_roct
# @DESCRIPTION:
# Applies kernel config flags for roct
ot-kernel-pkgflags_roct() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2967135" ]] && return
	if has_version "dev-libs/roct-thunk-interface" ; then
		einfo "Applying kernel config flags for roct (id: 2967135)"
		ot-kernel_y_configopt "CONFIG_HSA_AMD"
		ot-kernel_y_configopt "CONFIG_HMM_MIRROR"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_USERPTR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_runc
# @DESCRIPTION:
# Applies kernel config flags for runc package
ot-kernel-pkgflags_runc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5c1dafb" ]] && return
	if has_version "app-containers/runc" ; then
		einfo "Applying kernel config flags for runc (id: 5c1dafb)"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spacenavd
# @DESCRIPTION:
# Applies kernel config flags for the spacenavd package
ot-kernel-pkgflags_spacenavd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7c0022c" ]] && return
	if has_version "app-misc/spacenavd" ; then
		einfo "Applying kernel config flags for the spacenavd package (id: 7c0022c)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spice_vdagent
# @DESCRIPTION:
# Applies kernel config flags for the spice-vdagent package
ot-kernel-pkgflags_spice_vdagent() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "239cc81" ]] && return
	if has_version "app-emulation/spice-vdagent" ; then
		einfo "Applying kernel config flags for the spice-vdagent package (id: 239cc81)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_VIRTIO_CONSOLE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_squid
# @DESCRIPTION:
# Applies kernel config flags for the squid package
ot-kernel-pkgflags_squid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5350ae6" ]] && return
	if has_version "net-proxy/squid[tproxy]" ; then
		einfo "Applying kernel config flags for the squid package (id: 5350ae6)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_SOCKET"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_TPROXY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_suid_sandbox
# @DESCRIPTION:
# Applies kernel config flags for the suid sandbox
ot-kernel-pkgflags_suid_sandbox() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4aa6a9f" ]] && return
	if has_version "www-client/chromium[suid]" \
		|| [[ "${USE_SUID_SANDBOX}" == "1" ]] ; then
		einfo "Applying kernel config flags for the suid sandbox (id: 4aa6a9f)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2841205" ]] && return
	if has_version "sys-fs/udev" ; then
		einfo "Applying kernel config flags for the udev package (id: 2841205)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "98b0478" ]] && return
	if has_version "sys-fs/udisks" \
		&& [[ \
			"${arch}" == "arm" \
			|| "${arch}" == "ppc" \
			|| "${arch}" == "ppc64" \
			|| "${arch}" == "x86" \
			|| "${arch}" == "x86_64" \
		]] ; then
		einfo "Applying kernel config flags for the udisks package (id: 98b0478)"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_NLS_UTF8"
		if ver_test ${K_MAJOR_MINOR} -lt 3.10 ; then
			ot-kernel_y_configopt "CONFIG_USB_SUSPEND"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_undervolt
# @DESCRIPTION:
# Applies kernel config flags for the undervolt package
ot-kernel-pkgflags_undervolt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4047b49" ]] && return
	if has_version "sys-power/intel-undervolt" ; then
		einfo "Applying kernel config flags for the undervolt package (id: 4047b49)"
		ot-kernel_y_configopt "CONFIG_INTEL_RAPL"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_shorewall
# @DESCRIPTION:
# Applies kernel config flags for the shorewall package
ot-kernel-pkgflags_shorewall() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6596c21" ]] && return
	if has_version "net-firewall/shorewall" ; then
		einfo "Applying kernel config flags for the shorewall package (id: 6596c21)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		if ver_test ${K_MAJOR_MINOR} 4.19 ; then
			if has_version "net-firewall/shorewall[ipv4]" ; then
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
			fi
			if has_version "net-firewall/shorewall[ipv6]" ; then
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_steam
# @DESCRIPTION:
# Applies kernel config flags for the steam-meta package
ot-kernel-pkgflags_steam() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f2d2736" ]] && return
	if has_version "games-utils/steam-meta" ; then
		einfo "Applying kernel config flags for the steam package (id: f2d2736)"
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemd
# @DESCRIPTION:
# Applies kernel config flags for the systemd package
ot-kernel-pkgflags_systemd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "297eb15" ]] && return
	if has_version "sys-apps/systemd" ; then
		einfo "Applying kernel config flags for the systemd package (id: 297eb15)"
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

# @FUNCTION: ot-kernel-pkgflags_tb_us
# @DESCRIPTION:
# Applies kernel config flags for the systemd package
ot-kernel-pkgflags_tb_us() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c800aa5" ]] && return
	if has_version "sys-apps/thunderbolt-software-user-space" ; then
		einfo "Applying kernel config flags for tb-us (id: c800aa5)"
		ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_v4l2loopback
# @DESCRIPTION:
# Applies kernel config flags for the v4l2loopback package
ot-kernel-pkgflags_v4l2loopback() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b4a9c8a" ]] && return
	if has_version "media-video/v4l2loopback" ; then
		einfo "Applying kernel config flags for the v4l2loopback package (id: b4a9c8a)"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vbox
# @DESCRIPTION:
# Applies kernel config flags for the vbox package
ot-kernel-pkgflags_vbox() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c12b08e" ]] && return
	if has_version "app-emulation/virtualbox" ; then
		einfo "Applying kernel config flags for the vbox package (id: c12b08e)"
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

# @FUNCTION: ot-kernel-pkgflags_vhba
# @DESCRIPTION:
# Applies kernel config flags for the vhba package
ot-kernel-pkgflags_vhba() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ce86ab8" ]] && return
	if has_version "sys-fs/vhba" ; then
		einfo "Applying kernel config flags for the vhba package (id: ce86ab8)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wavemon
# @DESCRIPTION:
# Applies kernel config flags for the wavemon package
ot-kernel-pkgflags_wavemon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "8960610" ]] && return
	if has_version "net-wireless/wavemon" ; then
		einfo "Applying kernel config flags for the wavemon package (id: 8960610)"
		ot-kernel_y_configopt "CONFIG_CFG80211"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wine
# @DESCRIPTION:
# Applies kernel config flags for the wine package
ot-kernel-pkgflags_wine() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ab3aa13" ]] && return
	if \
		has_version "app-emulation/wine-staging" \
		|| has_version "app-emulation/wine-mono" \
		|| has_version "app-emulation/wine-vanilla" \
		|| has_version "app-emulation/wine-d3d9" \
		|| has_version "app-emulation/wine-any" \
		; then
		einfo "Applying kernel config flags for the wine package (id: ab3aa13)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e0a4d03" ]] && return
	if has_version "net-wireless/wpa_supplicant[crda]" ; then
		einfo "Applying kernel config flags for the wpa_supplicant package (id: e0a4d03)"
		ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xen
# @DESCRIPTION:
# Applies kernel config flags for the xen package
ot-kernel-pkgflags_xen() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c729ba1" ]] && return
	if has_version "app-emulation/xen" ; then
		einfo "Applying kernel config flags for the xen package (id: c729ba1)"
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

# @FUNCTION: ot-kernel-pkgflags_xf86_input_evdev
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-evdev package
ot-kernel-pkgflags_xf86_input_evdev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "a9b2291" ]] && return
	if has_version "x11-drivers/xf86-input-evdev" ; then
		einfo "Applying kernel config flags for the xf86-input-evdev package (id: a9b2291)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_libinput
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-libinput package
ot-kernel-pkgflags_xf86_input_libinput() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c4e47ff" ]] && return
	if has_version "x11-drivers/xf86-input-libinput" ; then
		einfo "Applying kernel config flags for the xf86-input-libinput package (id: c4e47ff)"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_ati
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-ati package
ot-kernel-pkgflags_xf86_video_ati() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2c2d347" ]] && return
	if has_version "x11-drivers/xf86-video-ati" ; then
		einfo "Applying kernel config flags for the xf86-video-ati package (id: 2c2d347)"
		if ver_test ${K_MAJOR_MINOR} -ge 3.9 ; then
			ot-kernel_unset_configopt "CONFIG_DRM_RADEON_UMS"
			ot-kernel_unset_configopt "CONFIG_FB_RADEON"
		else
			ot-kernel_y_configopt "CONFIG_DRM_RADEON_KMS"
			ot-kernel_unset_configopt "CONFIG_FB_RADEON"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xfce4_battery_plugin
# @DESCRIPTION:
# Applies kernel config flags for the xfce4-battery-plugin package
ot-kernel-pkgflags_xfce4_battery_plugin() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f54e65c" ]] && return
	if has_version "xfce-extra/xfce4-battery-plugin" ; then
		einfo "Applying kernel config flags for the xfce4-battery-plugin package (id: f54e65c)"
		ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpra
# @DESCRIPTION:
# Applies kernel config flags for the xpra package
ot-kernel-pkgflags_xpra() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "15db603" ]] && return
	if has_version "x11-wm/xpra[v4l2]" ; then
		einfo "Applying kernel config flags for the xpra package (id: 15db603)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bdf10dc" ]] && return
	if has_version "sys-fs/zfs[test-suite]" ; then
		einfo "Applying kernel config flags for the zfs package (id: bdf10dc)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}
