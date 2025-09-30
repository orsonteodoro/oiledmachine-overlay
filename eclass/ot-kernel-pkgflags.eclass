# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-pkgflags.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-pkgflags eclass auto enables kernel config flags based on
# packages installed.  Each set are a "one size fits all" or a general
# solution to get at least a functional working program with minimal
# problems with minimal kernel configuration time cost.  Each kernel
# rebuild can cost 4-7 hours on older machines.  Extra required flags
# should manually edit the .config instead of modifying this eclass.

# This eclass is biased towards built in (=y) instead of modules (=m) for security reasons.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit ot-kernel-kutils toolchain-funcs

# To find missing package use:
# for x in $(grep -E -r --exclude-dir=.git --exclude-dir=metadata --exclude=Manifest.gz -e "(CHECK_CONFIG|CONFIG_CHECK)(\+|=)" -e "linux_chkconfig_" /usr/portage  | sort | cut -f 1 -d ":" | cut -f 4-5 -d "/") ; do grep -q -e "${x}" ot-kernel-pkgflags.eclass || echo "Missing ${x}" ; done
# for x in $(grep -E -r --exclude-dir=.git --exclude-dir=metadata --exclude=Manifest.gz -e "(CHECK_CONFIG|CONFIG_CHECK)(\+|=)" -e "linux_chkconfig_" /var/db/repos/*  | sort | cut -f 1 -d ":" | cut -f 6-7 -d "/") ; do grep -q -e "${x}" ot-kernel-pkgflags.eclass || echo "Missing ${x}" ; done

# These are discovered by doing one of the following:
# grep -E -r --exclude-dir=.git --exclude-dir=metadata --exclude=Manifest.gz -e "(CHECK_CONFIG|CONFIG_CHECK)(\+|=)" -e "linux_chkconfig_" /usr/portage | sort

# For checking required unsets:
# grep -E -r --exclude-dir=.git --exclude-dir=metadata --exclude=Manifest.gz -e '(CHECK_CONFIG|CONFIG_CHECK).*!' /usr/portage

# linux-info notes:

# Should be set examples
#CONFIG_CHECK="MTRR" # Example of fatal error ; required
#CONFIG_CHECK="~MTRR" # Example of non fatal error ; optional

# Should not be set examples
#CONFIG_CHECK="!MTRR" # Example of fatal ; required
#CONFIG_CHECK="~!MTRR" # Example of non fatal error ; optional

# @FUNCTION: needs_debugfs
# @DESCRIPTION:
# Notifies that CONFIG_DEBUG_FS must be restored after using Clang CFI for
# userland packages that still need it.
needs_debugfs() {
	export _OT_KERNEL_NEEDS_DEBUGFS=1
}

# @FUNCTION: warn_lowered_security
# @DESCRIPTION:
# Shows a warning or halts if security is lowered.
warn_lowered_security() {
	local pkg="${1}"
	local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
	local cause="${2}"
	local evaluation="${3}"
	if [[ "${OT_KERNEL_HALT_ON_LOWERED_SECURITY}" == "1" ]] ; then
eerror
eerror "Lowered security was detected for pkg = ${pkg}, id = ${pkgid}."
eerror "Cause:  ${2}"
		if [[ -n "${evaluation}" ]] ; then
eerror "Security evaluation:  ${3}"
			local severity=""
			[[ "${evaluation}" == "DoS" ]] && severity="Medium"
			[[ "${evaluation}" == "ID" ]] && severity="Medium"
			[[ "${evaluation}" =~ "DoS" && "${evaluation}" =~ "ID" && "${evaluation}" =~ "DT" ]] && severity="High"
eerror "Estimated CVSS 3.1 severity:  ${severity}"
		fi
eerror
eerror "To permit security lowering set OT_KERNEL_HALT_ON_LOWERED_SECURITY=0."
eerror "Search the id in the ot-kernel-pkgflags.eclass in the eclass folder for"
eerror "details."
eerror
		if [[ -n "${evaluation}" ]] ; then
eerror "Glossary:"
eerror
			[[ "${evaluation}" =~ "DoS" ]] && eerror "DoS - Denial of Service"
			[[ "${evaluation}" =~ "DT" ]] && eerror "DT - Data Tampering"
			[[ "${evaluation}" =~ "ID" ]] && eerror "ID - Information Disclosure"
			[[ "${evaluation}" =~ "PE" ]] && eerror "PE - Privilege Escalation"
eerror
		fi
		die
	else
ewarn
ewarn "Security is lowered for pkg = ${pkg}, id = ${pkgid}."
ewarn "Cause:  ${2}"
		if [[ -n "${evaluation}" ]] ; then
ewarn "Security evaluation:  ${3}"
			local severity=""
			[[ "${evaluation}" == "DoS" ]] && severity="Medium"
			[[ "${evaluation}" == "ID" ]] && severity="Medium"
			[[ "${evaluation}" =~ "DoS" && "${evaluation}" =~ "ID" && "${evaluation}" =~ "DT" ]] && severity="High"
ewarn "Estimated CVSS 3.1 severity:  ${severity}"
		fi
ewarn
ewarn "To halt on lowered security, set OT_KERNEL_HALT_ON_LOWERED_SECURITY=1."
ewarn "Search the id in the ot-kernel-pkgflags.eclass in the eclass folder for"
ewarn "details."
ewarn
		if [[ -n "${evaluation}" ]] ; then
ewarn "Glossary:"
ewarn
			[[ "${evaluation}" =~ "DoS" ]] && ewarn "DoS - Denial of Service"
			[[ "${evaluation}" =~ "DT" ]] && ewarn "DT - Data Tampering"
			[[ "${evaluation}" =~ "ID" ]] && ewarn "ID - Information Disclosure"
			[[ "${evaluation}" =~ "PE" ]] && ewarn "PE - Privilege Escalation"
ewarn
		fi
	fi
}

# @FUNCTION: ban_dma_attack
# @DESCRIPTION:
# Warn of the use of kernel options that may used for DMA attacks.
ban_dma_attack() {
	local pkg="${1}"
	local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
	local kopt="${2}"
	local ot_kernel_dma_attack_mitigations=${OT_KERNEL_DMA_ATTACK_MITIGATIONS:-1}
	[[ -n "${ot_kernel_dma_attack_mitigations}" ]] \
		&& (( ${ot_kernel_dma_attack_mitigations} == 0 )) \
		&& return
eerror
eerror "The ${kopt} kernel option may be used as a possible prerequisite for"
eerror "DMA side-channel attacks."
eerror
eerror "Requested by pkg = ${pkg}, id = ${pkgid}."
eerror
eerror "To continue, choose one of the following:"
eerror
eerror "  1. Set OT_KERNEL_DMA_ATTACK_MITIGATIONS=0"
eerror "  2. Set OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1 to not apply flags."
eerror
	die
}

# @FUNCTION: ban_disable_debug
# @DESCRIPTION:
# It makes the disable_debug script mutually exclusive with a certain kernel
# option enabled.
#
# Any function that uses the following keywords (DEBUG, TRACE, VERBOSE, LOG,
# PRINT) in kernel flags should be checked in addition to netfilter log
# depending on if disable_debug is set to PERMIT_NETFILTER_SYMBOL_REMOVAL=1.
#
# Currently OT_KERNEL_PKGFLAGS_ACCEPT is used to override
# PERMIT_NETFILTER_SYMBOL_REMOVAL and to prevent more code creep.
#
ban_disable_debug() {
	local pkg="${1}"
	local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
	local flags="${2}"
	local types="${3}" # can be unset or NETFILTER

# pkgid is produced from the following:
# echo -n "${CATEGORY}/${PN}" | sha512sum | cut -f 1 -d " " | cut -c 1-7

	if [[ "${OT_KERNEL_FORCE_APPLY_DISABLE_DEBUG}" == "1" ]] ; then
		:
	elif [[ "${OT_KERNEL_PKGFLAGS_ACCEPT[S${pkgid}]}" == "1" ]] ; then
		:
	elif \
		[[ \
			"${types}" =~ "NETFILTER" \
		]] \
			&& \
		[[ \
			-z "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" \
			|| "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" == "0" \
		]] \
	; then
		: # No feature conflict
	elif ! ot-kernel_use debug ; then
eerror
eerror "Using OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS with the disabled debug"
eerror "USE flag which will run the disable_debug script are in conflict with a"
eerror "package with certain set of kernel flags."
eerror
eerror "Contested flags:  ${flags}"
eerror "Called from function:  ${FUNCNAME[1]}"
eerror
	if [[ "${flags}" =~ "CONFIG_DEBUG_FS" ]] ; then
eerror
eerror "The CONFIG_DEBUG_FS may be used in possible prerequisite for attacks."
eerror
	fi
eerror
eerror "Choices:"
eerror
eerror "1. Remove the hard mask on the debug USE flag first.  Then, enable the debug USE flag."
eerror "2. Add OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1 to not apply flags."
eerror "3. Add OT_KERNEL_PKGFLAGS_ACCEPT[S${pkgid}]=1 to apply flags."
eerror
		die
	fi
}

# @FUNCTION: __ot-kernel_set_init
# @DESCRIPTION:
# Remove init
__ot-kernel_set_init() {
	local path="${1}"
	ot-kernel_unset_pat_kconfig_kernel_cmdline "init=[A-Za-z0-9/_.-]+"
	ot-kernel_set_kconfig_kernel_cmdline "init=${path}"
}

# @FUNCTION: _ot-kernel_set_init
# @DESCRIPTION:
# Add the init to the internal kernel command line.
_ot-kernel_set_init() {
	local init="${OT_KERNEL_INIT:-custom}"

	#
	# We also want to eventually delete the 4567_distro-Gentoo-Kconfig.patch
	# patch from genpatches and rely on autoconfig of these eclasses.
	#
	# We disable the CONFIG_GENTOO_LINUX_INIT_SYSTEMD in a scenario where
	# the user forgets to disable it when switching between init systems.
	#
	ot-kernel_unset_configopt "CONFIG_GENTOO_LINUX_INIT_SYSTEMD"
	ot-kernel_unset_configopt "CONFIG_GENTOO_LINUX_INIT_SCRIPT"
	ot-kernel_unset_configopt "CONFIG_GENTOO_LINUX_UDEV"

	if [[ "${init}" == "auto" ]] ; then
		if ot-kernel_has_version "sys-process/dinit" ; then
einfo "init:  dinit"
			__ot-kernel_set_init "/sbin/dinit"
		elif ot-kernel_has_version "sys-apps/epoch" ; then
einfo "init:  Epoch"
			__ot-kernel_set_init "/usr/sbin/epoch-init"
		elif ot-kernel_has_version "sys-apps/finit" ; then
einfo "init:  finit"
			__ot-kernel_set_init "/sbin/finit"
		elif ot-kernel_has_version "sys-apps/openrc" ; then
einfo "init:  OpenRC"
			__ot-kernel_set_init "/sbin/openrc-init"
		elif ot-kernel_has_version "sys-process/runit" ; then
einfo "init:  runit"
			__ot-kernel_set_init "/sbin/runit-init"
		elif ot-kernel_has_version "sys-apps/s6-linux-init" ; then
einfo "init:  s6"
			__ot-kernel_set_init "/sbin/init"
		elif ot-kernel_has_version_slow "sys-apps/systemd" ; then
einfo "init:  systemd"
			__ot-kernel_set_init "/lib/systemd/systemd"
		elif ot-kernel_has_version "sys-apps/sysvinit" ; then
einfo "init:  sysvinit"
			__ot-kernel_set_init "/sbin/init"
		fi
	elif [[ "${init}" == "dinit" ]] ; then
einfo "init:  dinit"
		__ot-kernel_set_init "/sbin/dinit"
	elif [[ "${init}" == "none" ]] ; then
		ot-kernel_unset_pat_kconfig_kernel_cmdline "init=[A-Za-z0-9/_.-]+"
	elif [[ "${init}" == "epoch" ]] ; then
einfo "init:  Epoch"
		__ot-kernel_set_init "/usr/sbin/epoch-init"
	elif [[ "${init}" == "finit" ]] ; then
einfo "init:  finit"
		__ot-kernel_set_init "/sbin/finit"
	elif [[ "${init}" == "openrc" ]] ; then
einfo "init:  OpenRC"
		__ot-kernel_set_init "/sbin/openrc-init"
	elif [[ "${init}" == "runit" ]] ; then
einfo "init:  runit"
		__ot-kernel_set_init "/sbin/runit-init"
	elif [[ "${init}" == "s6" ]] ; then
einfo "init:  s6"
		__ot-kernel_set_init "/sbin/init"
	elif [[ "${init}" == "systemd" ]] ; then
einfo "init:  systemd"
		__ot-kernel_set_init "/lib/systemd/systemd"
	elif [[ "${init}" == "sysvinit" ]] ; then
einfo "init:  sysvinit"
		__ot-kernel_set_init "/sbin/init"
	elif [[ "${init}" =~ ^"/" ]] ; then
einfo "init:  ${init}"
		__ot-kernel_set_init "${init}"
	else
ewarn
ewarn "No default init system selected.  You must configure the bootloader"
ewarn "with init= kernel command line."
ewarn
	fi
}

# @FUNCTION: ot-kernel_has_version_pkgflags
# @DESCRIPTION:
# Wrapper for has_version to avoid human error.
# This version avoids the added time cost penalty.
#
# BUG:  If the results could ambigous and be fatal, use ot-kernel_has_version_pkgflags_slow instead.
# Example sys-apps/systemd and sys-apps/systemd-utils with OpenRC.
#
ot-kernel_has_version_pkgflags() {
	local pkg="${1}"
	local hash=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
	hash="${hash:0:7}"
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S${hash}]}" == "1" ]] && return 1
	if ot-kernel_has_version "${pkg}" ; then
einfo "Applying kernel config flags for the ${pkg} package (id: ${hash})"
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_version_pkgflags_slow
# @DESCRIPTION:
# Wrapper for has_version to avoid human error with heavy time cost penalty but more accurate.
# Use this when ambiguous package names may be encountered with regex.
ot-kernel_has_version_pkgflags_slow() {
	local pkg="${1}"
	local hash=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
	hash="${hash:0:7}"
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S${hash}]}" == "1" ]] && return 1
	if has_version "${pkg}" ; then
einfo "Applying kernel config flags for the ${pkg} package (id: ${hash})"
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_apply
# @DESCRIPTION:
# The main function to apply all kernel config flags in preparation for using the package.
ot-kernel-pkgflags_apply() {
	[[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && return
	[[ "${arch}" =~ "arm" ]] && _ot-kernel-pkgflags_neon

	# Verify that the proper packages are installed first so the proper
	# kernel config flags can be applied.
	_ot-kernel_checkpoint_dss_acl_requirement # 1, 7
	_ot-kernel_checkpoint_dss_anti_malware_requirement # 5
	_ot-kernel_checkpoint_dss_audit_logs_requirement # 10
	_ot-kernel_checkpoint_dss_disk_encryption_requirement # 3
	_ot-kernel_checkpoint_dss_firewall_requirement # 1
	_ot-kernel_checkpoint_dss_lsm_requirement # 7
	_ot-kernel_checkpoint_dss_multiuser_requirement # 6
	_ot-kernel_checkpoint_dss_ntp_requirement # 10
	_ot-kernel_checkpoint_dss_tls_requirement # 2

	# Hint below packages whenever possible
	ot-kernel-pkgflags_iucode
	ot-kernel-pkgflags_linux_firmware

	ot-kernel-pkgflags_abseil_cpp
	ot-kernel-pkgflags_accel_ppp
	ot-kernel-pkgflags_acpi_call
	ot-kernel-pkgflags_acpid
	ot-kernel-pkgflags_actkbd
	ot-kernel-pkgflags_aic8800
	ot-kernel-pkgflags_alsa
	ot-kernel-pkgflags_amt_check
	ot-kernel-pkgflags_ananicy_cpp
	ot-kernel-pkgflags_apache
	ot-kernel-pkgflags_apcupsd
	ot-kernel-pkgflags_appimage
	ot-kernel-pkgflags_apptainer
	ot-kernel-pkgflags_aqtion
	ot-kernel-pkgflags_arcconf
	ot-kernel-pkgflags_atop
	ot-kernel-pkgflags_audacity
	ot-kernel-pkgflags_audit
	ot-kernel-pkgflags_autofs
	ot-kernel-pkgflags_avahi
	ot-kernel-pkgflags_batctl
	ot-kernel-pkgflags_bcache_tools
	ot-kernel-pkgflags_bcc
	ot-kernel-pkgflags_bcm_sta
	ot-kernel-pkgflags_beep
	ot-kernel-pkgflags_bees
	ot-kernel-pkgflags_blink1
	ot-kernel-pkgflags_blktrace
	ot-kernel-pkgflags_blueman
	ot-kernel-pkgflags_bluez
	ot-kernel-pkgflags_boost
	ot-kernel-pkgflags_bmon
	ot-kernel-pkgflags_bpftool
	ot-kernel-pkgflags_bpftrace
	ot-kernel-pkgflags_boinc
	ot-kernel-pkgflags_bolt
	ot-kernel-pkgflags_bootchart2
	ot-kernel-pkgflags_bootconfig
	ot-kernel-pkgflags_bridge_utils
	ot-kernel-pkgflags_broadcom_bt_firmware
	ot-kernel-pkgflags_btrfs_progs
	ot-kernel-pkgflags_bubblewrap
	ot-kernel-pkgflags_buildah
	ot-kernel-pkgflags_bustd
	ot-kernel-pkgflags_c2tcp
	ot-kernel-pkgflags_cairo
	ot-kernel-pkgflags_caja_dbox
	ot-kernel-pkgflags_catalyst
	ot-kernel-pkgflags_cdm
	ot-kernel-pkgflags_cdrom
	ot-kernel-pkgflags_cifs_utils
	ot-kernel-pkgflags_chroot_wrapper
	ot-kernel-pkgflags_clamav
	ot-kernel-pkgflags_clamfs
	ot-kernel-pkgflags_clang
	ot-kernel-pkgflags_clsync
	ot-kernel-pkgflags_cni_plugins
	ot-kernel-pkgflags_collectd
	ot-kernel-pkgflags_compiler_rt_sanitizers
	ot-kernel-pkgflags_conky
	ot-kernel-pkgflags_conty
	ot-kernel-pkgflags_conntrack_tools
	ot-kernel-pkgflags_corefreq
	ot-kernel-pkgflags_coreutils
	ot-kernel-pkgflags_corosync
	ot-kernel-pkgflags_cr
	ot-kernel-pkgflags_crda
	ot-kernel-pkgflags_criu
	ot-kernel-pkgflags_cryfs
	ot-kernel-pkgflags_cryptodev
	ot-kernel-pkgflags_cryptmount
	ot-kernel-pkgflags_cryptsetup
	ot-kernel-pkgflags_cups
	ot-kernel-pkgflags_cvmfs
	ot-kernel-pkgflags_dahdi
	ot-kernel-pkgflags_db_numa
	ot-kernel-pkgflags_dbus
	ot-kernel-pkgflags_dccutil
	ot-kernel-pkgflags_ddlm
	ot-kernel-pkgflags_deepcc
	ot-kernel-pkgflags_dietlibc
	ot-kernel-pkgflags_dinit
	ot-kernel-pkgflags_discord
	ot-kernel-pkgflags_distrobuilder
	ot-kernel-pkgflags_docker
	ot-kernel-pkgflags_doas
	ot-kernel-pkgflags_dosemu
	ot-kernel-pkgflags_dpdk
	ot-kernel-pkgflags_dpdk_kmod
	ot-kernel-pkgflags_dracut
	ot-kernel-pkgflags_drbd_utils
	ot-kernel-pkgflags_droidcam
	ot-kernel-pkgflags_dropwatch
	ot-kernel-pkgflags_dvd
	ot-kernel-pkgflags_dwarf_therapist
	ot-kernel-pkgflags_e2fsprogs
	ot-kernel-pkgflags_ec_access
	ot-kernel-pkgflags_ecryptfs
	ot-kernel-pkgflags_eduvpn_common
	ot-kernel-pkgflags_efibootmgr
	ot-kernel-pkgflags_ekeyd
	ot-kernel-pkgflags_ell
	ot-kernel-pkgflags_elogind
	ot-kernel-pkgflags_emacs
	ot-kernel-pkgflags_embree
	ot-kernel-pkgflags_ena_driver
	ot-kernel-pkgflags_encfs
	ot-kernel-pkgflags_epoch
	ot-kernel-pkgflags_espeakup
	ot-kernel-pkgflags_eudev
	ot-kernel-pkgflags_evdi
	ot-kernel-pkgflags_eventd
	ot-kernel-pkgflags_ext4_crypt
	ot-kernel-pkgflags_external_modules
	ot-kernel-pkgflags_expanso
	ot-kernel-pkgflags_f2fs_tools
	ot-kernel-pkgflags_fastd
	ot-kernel-pkgflags_ff
	ot-kernel-pkgflags_ffmpeg
	ot-kernel-pkgflags_finit
	ot-kernel-pkgflags_firecracker_bin
	ot-kernel-pkgflags_firehol
	ot-kernel-pkgflags_firewalld
	ot-kernel-pkgflags_flatpak
	ot-kernel-pkgflags_firejail
	ot-kernel-pkgflags_framework_laptop_kmod
	ot-kernel-pkgflags_fuse
	ot-kernel-pkgflags_fwknop
	ot-kernel-pkgflags_g15daemon
	ot-kernel-pkgflags_gambas
	ot-kernel-pkgflags_game_device_udev_rules
	ot-kernel-pkgflags_gcc
	ot-kernel-pkgflags_gdm
	ot-kernel-pkgflags_gerbera
	ot-kernel-pkgflags_ghc
	ot-kernel-pkgflags_glances
	ot-kernel-pkgflags_glib
	ot-kernel-pkgflags_glibc
	ot-kernel-pkgflags_gnokii
	ot-kernel-pkgflags_gnome_boxes
	ot-kernel-pkgflags_go
	ot-kernel-pkgflags_gpm
	ot-kernel-pkgflags_greetd
	ot-kernel-pkgflags_grs
	ot-kernel-pkgflags_gspca_ep800
	ot-kernel-pkgflags_gst_plugins_ximagesrc
	ot-kernel-pkgflags_gstreamer
	ot-kernel-pkgflags_gtkgreet
	ot-kernel-pkgflags_guestfs
	ot-kernel-pkgflags_guilded_bin
	ot-kernel-pkgflags_gvrpcd
	ot-kernel-pkgflags_hamachi
	ot-kernel-pkgflags_haproxy
	ot-kernel-pkgflags_hd_idle
	ot-kernel-pkgflags_hdapsd
	ot-kernel-pkgflags_hid_nin
	ot-kernel-pkgflags_hplip
	ot-kernel-pkgflags_htbinit
	ot-kernel-pkgflags_htop
	ot-kernel-pkgflags_i2c_tools
	ot-kernel-pkgflags_i8kutils
	ot-kernel-pkgflags_ifenslave
	ot-kernel-pkgflags_igmpproxy
	ot-kernel-pkgflags_ima_evm_utils
	ot-kernel-pkgflags_inception
	ot-kernel-pkgflags_incron
	ot-kernel-pkgflags_incus
	ot-kernel-pkgflags_installkernel
	ot-kernel-pkgflags_iodine
	ot-kernel-pkgflags_iotop
	ot-kernel-pkgflags_ipcm
	ot-kernel-pkgflags_iproute2
	ot-kernel-pkgflags_ipset
	ot-kernel-pkgflags_ipt_netflow
	ot-kernel-pkgflags_iptables
	ot-kernel-pkgflags_irqbalance
	ot-kernel-pkgflags_isatapd
	ot-kernel-pkgflags_iscan_plugin
	ot-kernel-pkgflags_iwd
	ot-kernel-pkgflags_iwlmvm
	ot-kernel-pkgflags_jack_audio_connection_kit
	ot-kernel-pkgflags_jack2
	ot-kernel-pkgflags_jemalloc
	ot-kernel-pkgflags_joycond
	ot-kernel-pkgflags_k3s
	ot-kernel-pkgflags_kexec_tools
	ot-kernel-pkgflags_keyutils
	ot-kernel-pkgflags_kio_fuse
	ot-kernel-pkgflags_kloak
	ot-kernel-pkgflags_knem
	ot-kernel-pkgflags_kodi
	ot-kernel-pkgflags_kpatch
	ot-kernel-pkgflags_ksmbd_tools
	ot-kernel-pkgflags_latencytop
	ot-kernel-pkgflags_libbpf
	ot-kernel-pkgflags_libcec
	ot-kernel-pkgflags_libcgroup
	ot-kernel-pkgflags_libcxx
	ot-kernel-pkgflags_libcxxabi
	ot-kernel-pkgflags_libdex
	ot-kernel-pkgflags_libfido2
	ot-kernel-pkgflags_libforensic1394
	ot-kernel-pkgflags_libgpiod
	ot-kernel-pkgflags_liblinear
	ot-kernel-pkgflags_libmicrohttpd
	ot-kernel-pkgflags_libmtp
	ot-kernel-pkgflags_libnetfilter_acct
	ot-kernel-pkgflags_libnetfilter_cthelper
	ot-kernel-pkgflags_libnetfilter_conntrack
	ot-kernel-pkgflags_libnetfilter_cttimeout
	ot-kernel-pkgflags_libnetfilter_log
	ot-kernel-pkgflags_libnetfilter_queue
	ot-kernel-pkgflags_libnfnetlink
	ot-kernel-pkgflags_libnftnl
	ot-kernel-pkgflags_libomp
	ot-kernel-pkgflags_libpulse
	ot-kernel-pkgflags_libseccomp
	ot-kernel-pkgflags_libsdl2
	ot-kernel-pkgflags_libteam
	ot-kernel-pkgflags_libu2f_host
	ot-kernel-pkgflags_libugpio
	ot-kernel-pkgflags_libv4l
	ot-kernel-pkgflags_libvirt
	ot-kernel-pkgflags_lightdm
	ot-kernel-pkgflags_likwid
	ot-kernel-pkgflags_linux_apfs_rw
	ot-kernel-pkgflags_linux_atm
	ot-kernel-pkgflags_linux_enable_ir_emitter
	ot-kernel-pkgflags_linux_smaps
	ot-kernel-pkgflags_linux_tools_power_x86
	ot-kernel-pkgflags_linuxptp
	ot-kernel-pkgflags_lirc
	ot-kernel-pkgflags_livecd_tools
	ot-kernel-pkgflags_lkrg
	ot-kernel-pkgflags_lksctp_tools
	ot-kernel-pkgflags_llvm
	ot-kernel-pkgflags_lm_sensors
	ot-kernel-pkgflags_lmms
	ot-kernel-pkgflags_logiops
	ot-kernel-pkgflags_longrun
	ot-kernel-pkgflags_loopaes
	ot-kernel-pkgflags_lttng_modules
	ot-kernel-pkgflags_lttng_ust
	ot-kernel-pkgflags_lvm2
	ot-kernel-pkgflags_lxc
	ot-kernel-pkgflags_lxd
	ot-kernel-pkgflags_lxdm
	ot-kernel-pkgflags_lxqt_sudo
	ot-kernel-pkgflags_madwimax
	ot-kernel-pkgflags_mahimahi
	ot-kernel-pkgflags_makemkv
	ot-kernel-pkgflags_mariadb
	ot-kernel-pkgflags_mbpfan
	ot-kernel-pkgflags_mcelog
	ot-kernel-pkgflags_mcproxy
	ot-kernel-pkgflags_mdadm
	ot-kernel-pkgflags_memkind
	ot-kernel-pkgflags_mesa
	ot-kernel-pkgflags_mesa_amber
	ot-kernel-pkgflags_midi
	ot-kernel-pkgflags_minidlna
	ot-kernel-pkgflags_minijail
	ot-kernel-pkgflags_mongodb
	ot-kernel-pkgflags_mono
	ot-kernel-pkgflags_mpd
	ot-kernel-pkgflags_mpg123
	ot-kernel-pkgflags_mplayer
	ot-kernel-pkgflags_mpm_itk
	ot-kernel-pkgflags_mptcpd
	ot-kernel-pkgflags_mpv
	ot-kernel-pkgflags_msr_tools
	ot-kernel-pkgflags_mswatch
	ot-kernel-pkgflags_multipath_tools
	ot-kernel-pkgflags_musl
	ot-kernel-pkgflags_mysql
	ot-kernel-pkgflags_nbfc
	ot-kernel-pkgflags_nccl
	ot-kernel-pkgflags_nemu
	ot-kernel-pkgflags_networkmanager
	ot-kernel-pkgflags_nfs_utils
	ot-kernel-pkgflags_nfacct
	ot-kernel-pkgflags_nftables
	ot-kernel-pkgflags_nftlb
	ot-kernel-pkgflags_nginx
	ot-kernel-pkgflags_nilfs_utils
	ot-kernel-pkgflags_nodejs
	ot-kernel-pkgflags_nstx
	ot-kernel-pkgflags_nsxiv
	ot-kernel-pkgflags_ntfs3g
	ot-kernel-pkgflags_numad
	ot-kernel-pkgflags_nut
	ot-kernel-pkgflags_nv
	ot-kernel-pkgflags_nvtop
	ot-kernel-pkgflags_obsidian
	ot-kernel-pkgflags_oomd
	ot-kernel-pkgflags_opal_utils
	ot-kernel-pkgflags_open_iscsi
	ot-kernel-pkgflags_open_vm_tools
	ot-kernel-pkgflags_openafs
	ot-kernel-pkgflags_openconnect
	ot-kernel-pkgflags_openfortivpn
	ot-kernel-pkgflags_openl2tp
	ot-kernel-pkgflags_openrc
	ot-kernel-pkgflags_openrgb
	ot-kernel-pkgflags_opensnitch
	ot-kernel-pkgflags_opensnitch_ebpf_module
	ot-kernel-pkgflags_openssl
	ot-kernel-pkgflags_opentabletdriver
	ot-kernel-pkgflags_openvpn
	ot-kernel-pkgflags_openvswitch
	ot-kernel-pkgflags_oprofile
	ot-kernel-pkgflags_orca
	ot-kernel-pkgflags_osmo_fl2k
	ot-kernel-pkgflags_oss
	ot-kernel-pkgflags_ovpn_dco
	ot-kernel-pkgflags_pam_u2f
	ot-kernel-pkgflags_pcmciautils
	ot-kernel-pkgflags_pesign
	ot-kernel-pkgflags_perf
	ot-kernel-pkgflags_perl
	ot-kernel-pkgflags_pf_ring_kmod
	ot-kernel-pkgflags_pglinux
	ot-kernel-pkgflags_php
	ot-kernel-pkgflags_pipewire
	ot-kernel-pkgflags_plocate
	ot-kernel-pkgflags_ply
	ot-kernel-pkgflags_plymouth
	ot-kernel-pkgflags_podman
	ot-kernel-pkgflags_polkit
	ot-kernel-pkgflags_pommed
	ot-kernel-pkgflags_ponyprog
	ot-kernel-pkgflags_popura
	ot-kernel-pkgflags_portage
	ot-kernel-pkgflags_postgresql
	ot-kernel-pkgflags_powernowd
	ot-kernel-pkgflags_powertop
	ot-kernel-pkgflags_ppp
	ot-kernel-pkgflags_procps
	ot-kernel-pkgflags_pulseaudio
	ot-kernel-pkgflags_pulseaudio_daemon
	ot-kernel-pkgflags_pqiv
	ot-kernel-pkgflags_pv
	ot-kernel-pkgflags_python
	ot-kernel-pkgflags_qdmr
	ot-kernel-pkgflags_qemu
	ot-kernel-pkgflags_qingy
	ot-kernel-pkgflags_qtcore
	ot-kernel-pkgflags_qtgreet
	ot-kernel-pkgflags_r8125
	ot-kernel-pkgflags_r8152
	ot-kernel-pkgflags_r8168
	ot-kernel-pkgflags_rasdaemon
	ot-kernel-pkgflags_rccl
	ot-kernel-pkgflags_read_edid
	ot-kernel-pkgflags_recoil
	ot-kernel-pkgflags_redis
	ot-kernel-pkgflags_roct
	ot-kernel-pkgflags_rocksdb
	ot-kernel-pkgflags_rr
	ot-kernel-pkgflags_ruby
	ot-kernel-pkgflags_runit
	ot-kernel-pkgflags_rstudio_desktop_bin
	ot-kernel-pkgflags_rsyslog
	ot-kernel-pkgflags_rtirq
	ot-kernel-pkgflags_rtkit
	ot-kernel-pkgflags_rtl8821ce
	ot-kernel-pkgflags_rtl8192eu
	ot-kernel-pkgflags_rtsp_conntrack
	ot-kernel-pkgflags_runc
	ot-kernel-pkgflags_rust
	ot-kernel-pkgflags_s6
	ot-kernel-pkgflags_safeclib
	ot-kernel-pkgflags_samba
	ot-kernel-pkgflags_sandbox
	ot-kernel-pkgflags_sane
	ot-kernel-pkgflags_sanewall
	ot-kernel-pkgflags_sanlock
	ot-kernel-pkgflags_sbsigntools
	ot-kernel-pkgflags_sc_controller
	ot-kernel-pkgflags_scap_driver
	ot-kernel-pkgflags_scaphandre
	ot-kernel-pkgflags_sddm
	ot-kernel-pkgflags_shadow
	ot-kernel-pkgflags_session_desktop_bin
	ot-kernel-pkgflags_simplevirt
	ot-kernel-pkgflags_singularity
	ot-kernel-pkgflags_skopeo
	ot-kernel-pkgflags_slim
	ot-kernel-pkgflags_smcroute
	ot-kernel-pkgflags_snapd
	ot-kernel-pkgflags_solaar
	ot-kernel-pkgflags_sonic_snap
	ot-kernel-pkgflags_souper
	ot-kernel-pkgflags_sshuttle
	ot-kernel-pkgflags_shorewall
	ot-kernel-pkgflags_spacenavd
	ot-kernel-pkgflags_speedtouch_usb
	ot-kernel-pkgflags_spice_vdagent
	ot-kernel-pkgflags_squashfs-tools
	ot-kernel-pkgflags_squid
	ot-kernel-pkgflags_sssd
	ot-kernel-pkgflags_sstp_client
	ot-kernel-pkgflags_steam_launcher
	ot-kernel-pkgflags_stress_ng
	ot-kernel-pkgflags_sudo
	ot-kernel-pkgflags_suricata
	ot-kernel-pkgflags_syd
	ot-kernel-pkgflags_sysdig_kmod
	ot-kernel-pkgflags_systemd
	ot-kernel-pkgflags_systemd_bootchart
	ot-kernel-pkgflags_systemtap
	ot-kernel-pkgflags_sysvinit
	ot-kernel-pkgflags_tas
	ot-kernel-pkgflags_tb_us
	ot-kernel-pkgflags_tbb
	ot-kernel-pkgflags_tboot
	ot-kernel-pkgflags_tcmalloc
	ot-kernel-pkgflags_thermald
	ot-kernel-pkgflags_thinkfinger
	ot-kernel-pkgflags_throttled
	ot-kernel-pkgflags_tidal_hifi_bin
	ot-kernel-pkgflags_tiny_dfr
	ot-kernel-pkgflags_torque
	ot-kernel-pkgflags_tp_smapi
	ot-kernel-pkgflags_tpb
	ot-kernel-pkgflags_tpm_emulator
	ot-kernel-pkgflags_tpm2_tss
	ot-kernel-pkgflags_trace_cmd
	ot-kernel-pkgflags_tracker
	ot-kernel-pkgflags_trousers
	ot-kernel-pkgflags_tuigreet
	ot-kernel-pkgflags_tup
	ot-kernel-pkgflags_tuxedo_drivers
	ot-kernel-pkgflags_tuxedo_keyboard
	ot-kernel-pkgflags_tvheadend
	ot-kernel-pkgflags_udev
	ot-kernel-pkgflags_udisks
	ot-kernel-pkgflags_uefi_mkconfig
	ot-kernel-pkgflags_ufw
	ot-kernel-pkgflags_uksmd
	ot-kernel-pkgflags_undervolt
	ot-kernel-pkgflags_usb
	ot-kernel-pkgflags_usb_midi_fw
	ot-kernel-pkgflags_usb_modeswitch
	ot-kernel-pkgflags_usbtop
	ot-kernel-pkgflags_usbview
	ot-kernel-pkgflags_util_linux
	ot-kernel-pkgflags_v4l_dvb_saa716x
	ot-kernel-pkgflags_v4l2loopback
	ot-kernel-pkgflags_vala
	ot-kernel-pkgflags_vbox
	ot-kernel-pkgflags_vbox_guest_additions
	ot-kernel-pkgflags_vbox_modules
	ot-kernel-pkgflags_vcrypt
	ot-kernel-pkgflags_vdr_imonlcd
	ot-kernel-pkgflags_vendor_reset
	ot-kernel-pkgflags_vesktop_bin
	ot-kernel-pkgflags_vhba
	ot-kernel-pkgflags_vim
	ot-kernel-pkgflags_vivaldi
	ot-kernel-pkgflags_vinagre
	ot-kernel-pkgflags_vlc
	ot-kernel-pkgflags_voiphopper
	ot-kernel-pkgflags_vpnc
	ot-kernel-pkgflags_vtun
	ot-kernel-pkgflags_wacom
	ot-kernel-pkgflags_watchdog
	ot-kernel-pkgflags_wlgreet
	ot-kernel-pkgflags_wavemon
	ot-kernel-pkgflags_waydroid
	ot-kernel-pkgflags_wdm
	ot-kernel-pkgflags_webkit_gtk
	ot-kernel-pkgflags_wine
	ot-kernel-pkgflags_wireguard_modules
	ot-kernel-pkgflags_wireguard_tools
	ot-kernel-pkgflags_wireless_tools
	ot-kernel-pkgflags_wireplumber
	ot-kernel-pkgflags_wpa_supplicant
	ot-kernel-pkgflags_xboxdrv
	ot-kernel-pkgflags_xdm
	ot-kernel-pkgflags_xe_guest_utilities
	ot-kernel-pkgflags_xen
	ot-kernel-pkgflags_xf86_input_evdev
	ot-kernel-pkgflags_xf86_input_libinput
	ot-kernel-pkgflags_xf86_input_synaptics
	ot-kernel-pkgflags_xf86_video_amdgpu
	ot-kernel-pkgflags_xf86_video_ati
	ot-kernel-pkgflags_xf86_video_intel
	ot-kernel-pkgflags_xf86_video_nouveau
	ot-kernel-pkgflags_xf86_video_vesa
	ot-kernel-pkgflags_x86info
	ot-kernel-pkgflags_xfce4_battery_plugin
	ot-kernel-pkgflags_xmms2
	ot-kernel-pkgflags_xone
	ot-kernel-pkgflags_xorg_server
	ot-kernel-pkgflags_xoscope
	ot-kernel-pkgflags_xpadneo
	ot-kernel-pkgflags_xpmem
	ot-kernel-pkgflags_xpra
	ot-kernel-pkgflags_xtables_addons
	ot-kernel-pkgflags_yggdrasil_go
	ot-kernel-pkgflags_zenpower3
	ot-kernel-pkgflags_zenstates
	ot-kernel-pkgflags_zfs
	ot-kernel-pkgflags_zfs_kmod
	ot-kernel-pkgflags_zoom

	# Post apply
	# General commonly used kernel features goes here.
	_ot-kernel_pkgflags_squashfs
	_ot-kernel_set_futex
	_ot-kernel_set_futex2
	_ot-kernel_set_ldt
	_ot-kernel_set_multiuser
	_ot-kernel_realtime_packages
	_ot-kernel_set_init
	_ot-kernel_set_acl
	_ot-kernel_set_shebang_support

	# Out of source modules
}

# @FUNCTION: ot-kernel-pkgflags_abseil_cpp
# @DESCRIPTION:
# Applies kernel config flags for the abseil-cpp package
ot-kernel-pkgflags_abseil_cpp() { # DONE
	if ot-kernel_has_version_pkgflags "dev-cpp/abseil-cpp" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_accel_ppp
# @DESCRIPTION:
# Applies kernel config flags for the accel-ppp package
ot-kernel-pkgflags_accel_ppp() { # DONE
	if ot-kernel_has_version_pkgflags "net-dialup/accel-ppp" ; then
		ot-kernel_y_configopt "CONFIG_L2TP"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_PPTP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_acpi_call
# @DESCRIPTION:
# Applies kernel config flags for the acpi_call package
ot-kernel-pkgflags_acpi_call() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/acpi_call" ; then
		ot-kernel_y_configopt "CONFIG_ACPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_acpid
# @DESCRIPTION:
# Applies kernel config flags for the acpid package
ot-kernel-pkgflags_acpid() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/acpid" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_actkbd
# @DESCRIPTION:
# Applies kernel config flags for the actkbd package
ot-kernel-pkgflags_actkbd() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/actkbd" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_aic8800
# @DESCRIPTION:
# Applies kernel config flags for the aic8800 package
ot-kernel-pkgflags_aic8800() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/aic8800" ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_BT_HCIBTUSB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_alsa
# @DESCRIPTION:
# Applies kernel config flags for the alsa package
ot-kernel-pkgflags_alsa() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/alsa-lib" ; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"

		# USB sound
		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"

		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_amt_check
# @DESCRIPTION:
# Applies kernel config flags for the amt-check package
ot-kernel-pkgflags_amt_check() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/mei-amt-check" ; then
		ot-kernel_y_configopt "CONFIG_INTEL_MEI_ME"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ananicy_cpp
# @DESCRIPTION:
# Applies kernel config flags for the ananicy-cpp package
ot-kernel-pkgflags_ananicy_cpp() { # DONE
	local pkg="app-admin/ananicy-cpp"
	if \
		ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[bpf]" \
	; then
		# See ot-kernel-pkgflags_libbpf
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apache
# @DESCRIPTION:
# Applies kernel config flags for the apache package
ot-kernel-pkgflags_apache() { # DONE
	if ot-kernel_has_version_pkgflags "www-servers/apache" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apcupsd
# @DESCRIPTION:
# Applies kernel config flags for the apcupsd package
ot-kernel-pkgflags_apcupsd() { # DONE
	local pkg="sys-power/apcupsd"
	if \
	           ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[usb]" \
	; then
		ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_appimage
# @DESCRIPTION:
# Applies kernel config flags for appimage packages
ot-kernel-pkgflags_appimage() { # DONE
	if \
		   ot-kernel_has_version_pkgflags "app-arch/AppImageKit" \
		|| ot-kernel_has_version_pkgflags "app-arch/appimaged" \
		|| ot-kernel_has_version_pkgflags "app-arch/go-appimage" \
	; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
		if ot-kernel_has_version "app-arch/go-appimage" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
			ot-kernel_y_configopt "CONFIG_BINFMT_MISC"
		fi
		if \
			   ot-kernel_has_version "app-arch/appimaged[firejail]" \
			|| ot-kernel_has_version "app-arch/go-appimage[firejail]" \
		; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apptainer
# @DESCRIPTION:
# Applies kernel config flags for the apptainer package
ot-kernel-pkgflags_apptainer() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/apptainer" ; then
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_aqtion
# @DESCRIPTION:
# Applies kernel config flags for the aqtion package
ot-kernel-pkgflags_aqtion() { # DONE
	local pkg="net-misc/AQtion"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_unset_configopt "CONFIG_AQTION"
		ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK"
		ot-kernel_y_configopt "CONFIG_CRC_ITU_T"
		if ot-kernel_has_version "${pkg}[lro]" ; then
			ot-kernel_unset_configopt "CONFIG_BRIDGE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_arcconf
# @DESCRIPTION:
# Applies kernel config flags for the arcconf package
ot-kernel-pkgflags_arcconf() { # DONE
	local pkg="sys-block/arcconf"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_unset_configopt "CONFIG_HARDENED_USERCOPY_PAGESPAN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_asterisk
# @DESCRIPTION:
# Applies kernel config flags for the asterisk package
ot-kernel-pkgflags_asterisk() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/asterisk" ; then
		ot-kernel_unset_configopt "CONFIG_NF_CONNTRACK_SIP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_atop
# @DESCRIPTION:
# Applies kernel config flags for the atop package
ot-kernel-pkgflags_atop() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/atop" ; then
		ot-kernel_y_configopt "CONFIG_BSD_PROCESS_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_audacity
# @DESCRIPTION:
# Applies kernel config flags for the audacity package
ot-kernel-pkgflags_audacity() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/audacity" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_audit
# @DESCRIPTION:
# Applies kernel config flags for the audit package
ot-kernel-pkgflags_audit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/audit" ; then
		ot-kernel_y_configopt "CONFIG_NET" # CONFIG_AUDIT dep
		ot-kernel_y_configopt "CONFIG_AUDIT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_autofs
# @DESCRIPTION:
# Applies kernel config flags for the autofs package
ot-kernel-pkgflags_autofs() { # DONE
	if ot-kernel_has_version_pkgflags "net-fs/autofs" ; then
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.18" ; then
			ot-kernel_y_configopt "CONFIG_AUTOFS_FS"
		else
			ot-kernel_y_configopt "CONFIG_AUTOFS4_FS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_avahi
# @DESCRIPTION:
# Applies kernel config flags for the avahi package
ot-kernel-pkgflags_avahi() { # DONE
	if ot-kernel_has_version_pkgflags "net-dns/avahi" ; then
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_batctl
# @DESCRIPTION:
# Applies kernel config flags for the batctl package
ot-kernel-pkgflags_batctl() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/batctl" ; then
		ot-kernel_y_configopt "CONFIG_BATMAN_ADV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcache_tools
# @DESCRIPTION:
# Applies kernel config flags for the bcache-tools package
ot-kernel-pkgflags_bcache_tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/bcache-tools" ; then
		ot-kernel_y_configopt "CONFIG_BCACHE"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcc
# @DESCRIPTION:
# Applies kernel config flags for the bcc
ot-kernel-pkgflags_bcc() { # DONE
	local pkg="dev-util/bcc"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}"
		ot-kernel_y_configopt "CONFIG_NET_CLS_BPF"
		ot-kernel_y_configopt "CONFIG_NET_ACT_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_INFO, CONFIG_FUNCTION_TRACER, CONFIG_DEBUG_KERNEL"
		ot-kernel_y_configopt "CONFIG_DEBUG_INFO"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
		ot-kernel_y_configopt "CONFIG_KPROBES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcm_sta
# @DESCRIPTION:
# Applies kernel config flags for the bcm-sta
ot-kernel-pkgflags_bcm_sta() { # DONE
	local pkg=""
	local pkg1="net-wireless/broadcom-sta"
	local pkg2="net-wireless/broadcom-wl"
	local found=0
	if ot-kernel_has_version_pkgflags "${pkg1}" ; then
		found=1
		pkg="${pkg1}"
	elif ot-kernel_has_version_pkgflags "${pkg2}" ; then
		found=1
		pkg="${pkg2}"
	fi
	if (( ${found} == 1 )) ; then
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

		if ver_test "${MY_PV}" -ge "3.8.8" ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_CFG80211"
			local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
ewarn
ewarn "Cannot use PREEMPT_RCU OR PREEMPT* with ${pkg}."
ewarn "Disabling PREEMPT* and disabling PREEMPT_RT."
ewarn
ewarn "If you need to use PREEMPT_RT, add OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1"
ewarn
			ot-kernel_unset_configopt "CONFIG_PREEMPT_RCU"
			# This package does not like PREEMPT*
			ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		elif ver_test "${MY_PV}" -ge "2.6.32" ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_CFG80211"
		elif ver_test "${MY_PV}" -ge "2.6.31" ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_WIRELESS_EXT"
			ot-kernel_unset_configopt "CONFIG_MAC80211"
		elif ver_test "${MY_PV}" -ge "2.6.29" ; then
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

# @FUNCTION: _ot-kernel-pkgflags_has_beep_udev_rules
# @DESCRIPTION:
# Checks if file permissions applied to beep referenced paths
_ot-kernel-pkgflags_has_beep_udev_rules() {
	# Check if upstream security restrictions applied
	local f="/dev/input/by-path/platform-pcspkr-event-spkr"
	[[ -e "${f}" ]] || return 1
	if which getfacl "${f}" >/dev/null 2>&1 ; then
		if ! getfacl "${f}" "group:beep:-w-" ; then
			grep -q -e "^beep:" /etc/group > /dev/null || return 1
			ls -lH "${f}" | grep -q -e " root beep " || return 1
		fi
	else
		grep -q -e "^beep:" /etc/group > /dev/null || return 1
		ls -lH "${f}" | grep -q -e " root beep " || return 1
	fi
	return 0
}

# @FUNCTION: ot-kernel-pkgflags_beep
# @DESCRIPTION:
# Applies kernel config flags for the beep package
ot-kernel-pkgflags_beep() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/beep" ; then
	# Discussed in beep's manpage
		if \
			   ot-kernel_has_version "virtual/libudev" \
			&& _ot-kernel-pkgflags_has_beep_udev_rules \
		; then
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		else
			ot-kernel_y_configopt "CONFIG_TTY"
			ot-kernel_y_configopt "CONFIG_VT"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bees
# @DESCRIPTION:
# Applies kernel config flags for the bees package
ot-kernel-pkgflags_bees() { # DONE
	# See ot-kernel-pkgflags_btrfs_progs
	:
}

# @FUNCTION: ot-kernel-pkgflags_blink1
# @DESCRIPTION:
# Applies kernel config flags for the blink1 package
ot-kernel-pkgflags_blink1() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/blink1" ; then
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blktrace
# @DESCRIPTION:
# Applies kernel config flags for the blktrace package
ot-kernel-pkgflags_blktrace() { # DONE
	local pkg="sys-block/blktrace"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_BLK_DEV_IO_TRACE"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blueman
# @DESCRIPTION:
# Applies kernel config flags for the blueman package
ot-kernel-pkgflags_blueman() { # DONE
	local pkg="net-wireless/blueman"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[network]" \
	; then
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_boost
# @DESCRIPTION:
# Applies kernel config flags for the boost package
ot-kernel-pkgflags_boost() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/boost" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		_ot-kernel_set_io_uring
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bmon
# @DESCRIPTION:
# Applies kernel config flags for the bmon package
ot-kernel-pkgflags_bmon() { # DONE
	if ot-kernel_has_version_pkgflags "net-analyzer/bmon" ; then
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bluez
# @DESCRIPTION:
# Applies kernel config flags for the bluez package
ot-kernel-pkgflags_bluez() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/bluez" ; then
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_BT"
		ot-kernel_y_configopt "CONFIG_BT_RFCOMM"
		ot-kernel_y_configopt "CONFIG_BT_RFCOMM_TTY"
		ot-kernel_y_configopt "CONFIG_BT_BNEP"
		ot-kernel_y_configopt "CONFIG_BT_BNEP_MC_FILTER"
		ot-kernel_y_configopt "CONFIG_BT_BNEP_PROTO_FILTER"
		ot-kernel_y_configopt "CONFIG_BT_BREDR"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_BT_HIDP"
		ot-kernel_y_configopt "CONFIG_BT_HS"
		ot-kernel_y_configopt "CONFIG_BT_LE"
		ot-kernel_set_configopt "CONFIG_BT_HCIBTUSB" "m"
		ot-kernel_set_configopt "CONFIG_BT_HCIUART" "m"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_RFKILL"
		ot-kernel_y_configopt "CONFIG_UHID"
		if \
			   ot-kernel_has_version "net-wireless/bluez[mesh]" \
			|| ot-kernel_has_version "net-wireless/bluez[test]" \
		; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_AEAD"
			_ot-kernel-pkgflags_aes CCM
			ot-kernel_y_configopt "CONFIG_CRYPTO_CCM"
			ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"

			_ot-kernel-pkgflags_md5
			_ot-kernel-pkgflags_sha1
			ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bpftool
# @DESCRIPTION:
# Applies kernel config flags for the bpftool package
ot-kernel-pkgflags_bpftool() { # DONE
	local pkg="dev-util/bpftool"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}"
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_INFO_BTF"
		ot-kernel_y_configopt "CONFIG_DEBUG_INFO_BTF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bpftrace
# @DESCRIPTION:
# Applies kernel config flags for the bpftrace package
ot-kernel-pkgflags_bpftrace() { # DONE
	local pkg="dev-debug/bpftrace"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
		ban_disable_debug "${pkg}" "CONFIG_FTRACE_SYSCALLS, CONFIG_DEBUG_FS"
		ot-kernel_y_configopt "CONFIG_FTRACE_SYSCALLS"

	# These were not listed in the ebuild but in the self check upstream.
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_KPROBE_EVENTS"
		ot-kernel_y_configopt "CONFIG_UPROBES"
		ot-kernel_y_configopt "CONFIG_UPROBE_EVENTS"
		needs_debugfs
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_boinc
# @DESCRIPTION:
# Applies kernel config flags for the boinc package
ot-kernel-pkgflags_boinc() { # TESTING
	local pkg="sci-misc/boinc"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if grep -q -E -e "^CONFIG_LEGACY_VSYSCALL_NONE=y" "${path_config}" ; then
			VSYSCALL_MODE="${VSYSCALL_MODE:-emulate}" # kernel default

			ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"
			ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE"
			ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_XONLY"
			if \
				[[ "${work_profile}" == "dss" ]] \
					||
				_ot-kernel_is_hardening_level_most_secure \
			; then
ewarn "Setting vsyscall table none -> none may break some ${pkg} projects.  Change OT_KERNEL_HARDENING_LEVEL=default to fix."
				ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"
			elif _ot-kernel_is_hardening_level_secure ; then
				ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE"
			else
				if [[ "${VSYSCALL_MODE}" == "native" ]] && ver_test "${KV_MAJOR_MINOR}" -le "4.15" ; then
ewarn "Setting vsyscall table:  none -> native"
					warn_lowered_security "${pkg}" "vsyscall native may bypass ASLR, ROP gadget attack" "ID"
					ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_NATIVE"
				elif [[ "${VSYSCALL_MODE}" == "xonly" ]] ; then
ewarn "Setting vsyscall table:  none -> xonly"
					ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_XONLY"
				elif [[ "${VSYSCALL_MODE}" == "emulate" ]] ; then
	# Recommended by ebuild
ewarn "Setting vsyscall table:  none -> emulate"
					warn_lowered_security "${pkg}" "vsyscall emulate may bypass ASLR" "ID"
					ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE"
				elif [[ "${VSYSCALL_MODE}" == "none" ]] ; then
ewarn "Setting vsyscall table none -> none which may break some ${pkg} projects.  Change VSYSCALL_MODE=emulate for a fix."
					ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"
				fi

			fi

		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bolt
# @DESCRIPTION:
# Applies kernel config flags for the bolt package
ot-kernel-pkgflags_bolt() { # DONE
	local pkg="sys-apps/bolt"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[kernel_linux]" \
	; then
		if ver_test "${KV_MAJOR_MINOR}" -lt "5.6" ; then
			ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		else
			ot-kernel_y_configopt "CONFIG_USB4"
		fi
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bootchart2
# @DESCRIPTION:
# Applies kernel config flags for the bootchart2 package
ot-kernel-pkgflags_bootchart2() { # DONE
	if ot-kernel_has_version_pkgflags "app-benchmarks/bootchart2" ; then
		ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bootconfig
# @DESCRIPTION:
# Applies kernel config flags for the bootconfig package
ot-kernel-pkgflags_bootconfig() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/bootconfig" ; then
		ot-kernel_y_configopt "CONFIG_BOOT_CONFIG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bridge_utils
# @DESCRIPTION:
# Applies kernel config flags for the bridge-utils package
ot-kernel-pkgflags_bridge_utils() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/bridge-utils" ; then
		ot-kernel_y_configopt "CONFIG_BRIDGE_UTILS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_broadcom_bt_firmware
# @DESCRIPTION:
# Applies kernel config flags for the broadcom-bt-firmware package
ot-kernel-pkgflags_broadcom_bt_firmware() { # DONE
	local pkg="sys-firmware/broadcom-bt-firmware"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.19" ; then
			if ot-kernel_has_version_pkgflags "${pkg}[compress-xz]" ; then
				ot-kernel_y_configopt "CONFIG_FW_LOADER_COMPRESS_XZ"
			fi
			if ot-kernel_has_version_pkgflags "${pkg}[compress-zstd]" ; then
				ot-kernel_y_configopt "CONFIG_FW_LOADER_COMPRESS_ZSTD"
			fi
		else
			if ot-kernel_has_version_pkgflags "${pkg}[compress-xz]" ; then
				ot-kernel_y_configopt "CONFIG_FW_LOADER_COMPRESS"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_btrfs_progs
# @DESCRIPTION:
# Applies kernel config flags for the btrfs_progs package
ot-kernel-pkgflags_btrfs_progs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/btrfs-progs" ; then
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bubblewrap
# @DESCRIPTION:
# Applies kernel config flags for the bubblewrap package
ot-kernel-pkgflags_bubblewrap() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/bubblewrap" ; then
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_buildah
# @DESCRIPTION:
# Applies kernel config flags for the buildah package
ot-kernel-pkgflags_buildah() { # DONE
	local pkg="app-containers/buildah"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[btrfs]" \
	; then
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bustd
# @DESCRIPTION:
# Applies kernel config flags for the bustd package
ot-kernel-pkgflags_bustd() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/bustd" ; then
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.20" ; then
			ot-kernel_y_configopt "CONFIG_PSI"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_c2tcp
# @DESCRIPTION:
# Applies kernel config flags for the c2tcp package
ot-kernel-pkgflags_c2tcp() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/c2tcp" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_CUBIC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cairo
# @DESCRIPTION:
# Applies kernel config flags for cairo
ot-kernel-pkgflags_cairo() { # DONE
	if ot-kernel_has_version_pkgflags "x11-libs/cairo" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_caja_dbox
# @DESCRIPTION:
# Applies kernel config flags for caja_dbox
ot-kernel-pkgflags_caja_dbox() { # DONE
	if ot-kernel_has_version_pkgflags "mate-extra/caja-dropbox" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_catalyst
# @DESCRIPTION:
# Applies kernel config flags for the catalyst package
ot-kernel-pkgflags_catalyst() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/catalyst" ; then
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_uts_ns
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_ZLIB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cdm
# @DESCRIPTION:
# Applies kernel config flags for the cdm package
ot-kernel-pkgflags_cdm() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/cdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cdrom
# @DESCRIPTION:
# Applies kernel config flags for the CD-ROM packages
ot-kernel-pkgflags_cdrom() { #
	[[ "${CDROM:-1}" == "1" ]] || return
	# Simplified code without autodetection
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	if [[ "${CDROM_FS_ZISOFS:-0}" ]] ; then
		ot-kernel_y_configopt "CONFIG_ZISOFS"
	fi
	if [[ "${CDROM_FS_UDF:-0}" ]] ; then
		ot-kernel_y_configopt "CONFIG_UDF_FS"
	fi

	if ot-kernel_has_acpi_support ; then
		ot-kernel_y_configopt "CONFIG_ACPI"
	fi
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_ACPI"
	ot-kernel_y_configopt "CONFIG_SATA_HOST"
	ot-kernel_y_configopt "CONFIG_SATA_PMP"

	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	ot-kernel_y_configopt "CONFIG_ATA_SFF"
	ot-kernel_y_configopt "CONFIG_ATA_BMDMA"

	ot-kernel_y_configopt "CONFIG_ATA_PIIX"

	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"

	ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
}

# @FUNCTION: ot-kernel-pkgflags_cifs_utils
# @DESCRIPTION:
# Applies kernel config flags for the cifs-utils package
ot-kernel-pkgflags_cifs_utils() { # DONE
	if ot-kernel_has_version_pkgflags "net-fs/cifs-utils" ; then
		ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_CIFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_has_kflag
# @DESCRIPTION:
ot-kernel-pkgflags_has_kflag() {
	local kflag="${1}"
	grep -q -E -e "^${kflag}=(y|m)" "${path_config}"
}

# @FUNCTION: ot-kernel-pkgflags_cipher_optional
# @DESCRIPTION:
# Applies optimized ciphers for kernel flags that apply additional flags after required flags.
# This is to avoid the additional cost of another pass with olddefconfig.
ot-kernel-pkgflags_cipher_optional() {
	if ot-kernel-pkgflags_has_kflag "CONFIG_AIRO_CS" ; then
		_ot-kernel-pkgflags_aes CTR
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_BCACHEFS_FS" ; then
		_ot-kernel-pkgflags_chacha20_poly1305
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_BT" ; then
		_ot-kernel-pkgflags_aes ECB
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_BLK_DEV_RBD" ; then
		_ot-kernel-pkgflags_aes CBC GCM # See CONFIG_CEPH_LIB below
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_BTRFS_FS" ; then
		_ot-kernel-pkgflags_blake2b
		_ot-kernel-pkgflags_crc32c
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CEPH_FS" ; then
		_ot-kernel-pkgflags_aes CBC GCM # See CONFIG_CEPH_LIB below
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CEPH_LIB" ; then
		_ot-kernel-pkgflags_aes CBC GCM
		_ot-kernel-pkgflags_gcm
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CIFS" ; then
		_ot-kernel-pkgflags_aes CCM GCM ECB
		_ot-kernel-pkgflags_gcm
		_ot-kernel-pkgflags_md5
		_ot-kernel-pkgflags_sha256
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CFG80211" \
		&& ot-kernel-pkgflags_has_kflag "CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CRYPTO_AEGIS128" ; then
		_ot-kernel-pkgflags_aes
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CRYPTO_ANSI_CPRNG" ; then
		_ot-kernel-pkgflags_aes
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CRYPTO_DRBG_CTR" ; then
		_ot-kernel-pkgflags_aes CTR
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CRYPTO_DRBG_HASH" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_CRYPTO_DRBG_HMAC" ; then
		_ot-kernel-pkgflags_sha512
	fi
	# CONFIG_CRYPTO_DEV_* is ignored
	if ot-kernel-pkgflags_has_kflag "CONFIG_ENCRYPTED_KEYS" ; then
		_ot-kernel-pkgflags_aes CBC
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_EVM" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_F2FS_FS" ; then
		_ot-kernel-pkgflags_crc
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_FS_ENCRYPTION_ALGS" ; then
		_ot-kernel-pkgflags_aes CBC CTS ECB XTS
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_FS_VERITY" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_GENTOO_LINUX_INIT_SYSTEMD" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA_DEFAULT_HASH_SHA1" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA_DEFAULT_HASH_SHA256" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA_DEFAULT_HASH_SHA512" ; then
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA_DEFAULT_HASH_WP512" ; then
		:
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IMA_DEFAULT_HASH_SM3" ; then
		_ot-kernel-pkgflags_sm3
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IP_SCTP" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_IPV6_SEG6_HMAC" ; then
		_ot-kernel-pkgflags_sha1
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_ISCSI_TARGET" ; then
		_ot-kernel-pkgflags_crc32c
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_ISCSI_TCP" ; then
		_ot-kernel-pkgflags_crc32c
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_JBD2" ; then
		_ot-kernel-pkgflags_crc32c
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_KEXEC_FILE" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_LIB80211_CRYPT_CCMP" ; then
		_ot-kernel-pkgflags_aes CCM
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_LIBCRC32C" ; then
		_ot-kernel-pkgflags_crc32c
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MAC80211" ; then
		_ot-kernel-pkgflags_aes CCM GCM
		_ot-kernel-pkgflags_gcm
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MAC802154" ; then
		_ot-kernel-pkgflags_aes CCM CTR
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MACSEC" ; then
		_ot-kernel-pkgflags_aes GCM
		_ot-kernel-pkgflags_gcm
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_EXT4_FS" ; then
		_ot-kernel-pkgflags_crc32c
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MODULE_SIG_SHA1" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MODULE_SIG_SHA224" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MODULE_SIG_SHA384" ; then
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_MODULE_SIG_SHA512" ; then
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_NFSD_V4" ; then
		_ot-kernel-pkgflags_md5
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_NVME_TCP" ; then
		_ot-kernel-pkgflags_crc32c
		_ot-kernel-pkgflags_md5
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_RDMA_RXE" ; then
		_ot-kernel-pkgflags_crc32
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_PPP_MPPE" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_RPCSEC_GSS_KRB5" ; then
		_ot-kernel-pkgflags_aes CBC CTS ECB
		_ot-kernel-pkgflags_des CBC CTS ECB
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_RTL8192U" ; then
		_ot-kernel-pkgflags_aes CCM
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_RTLLIB_CRYPTO_CCMP" ; then
		_ot-kernel-pkgflags_aes CCM
	fi
	if \
		   ot-kernel-pkgflags_has_kflag "CONFIG_SCTP_COOKIE_HMAC_SHA1" \
		|| ot-kernel-pkgflags_has_kflag "SCTP_DEFAULT_COOKIE_HMAC_SHA1" \
	; then
		_ot-kernel-pkgflags_sha1
	fi
	if \
		   ot-kernel-pkgflags_has_kflag "CONFIG_SCTP_COOKIE_HMAC_MD5" \
		|| ot-kernel-pkgflags_has_kflag "SCTP_DEFAULT_COOKIE_HMAC_MD5" \
	; then
		_ot-kernel-pkgflags_md5
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_SIGNATURE" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_SECURITY_APPARMOR_HASH" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_TIPC_CRYPTO" ; then
		_ot-kernel-pkgflags_aes GCM
		_ot-kernel-pkgflags_gcm
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_TEE" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_TLS" ; then
		_ot-kernel-pkgflags_aes GCM
		_ot-kernel-pkgflags_gcm
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_TRUSTED_KEYS" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_SMB_SERVER" ; then
		_ot-kernel-pkgflags_gcm
		_ot-kernel-pkgflags_md5
		_ot-kernel-pkgflags_sha256
		_ot-kernel-pkgflags_sha512
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_USB_RTL8152" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_X86_SGX" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_XFRM_AH" ; then
		_ot-kernel-pkgflags_sha256
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_XFRM_ESP" ; then
		_ot-kernel-pkgflags_aes CBC GCM
		_ot-kernel-pkgflags_gcm
		_ot-kernel-pkgflags_sha256
	fi
}

# @FUNCTION: ot-kernel-pkgflags_chroot_wrapper
# @DESCRIPTION:
# Applies kernel config flags for the chroot-wrapper package
ot-kernel-pkgflags_chroot_wrapper() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/chroot-wrapper" ; then
		ot-kernel_y_configopt "CONFIG_TMPFS"
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_uts_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clamav
# @DESCRIPTION:
# Applies kernel config flags for the clamav package
ot-kernel-pkgflags_clamav() { # DONE
	if ot-kernel_has_version_pkgflags "app-antivirus/clamav" ; then
		ot-kernel_y_configopt "CONFIG_FANOTIFY"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_FANOTIFY_ACCESS_PERMISSIONS"

		# Defined but not used
		# ot-kernel_y_configopt "CONFIG_EXPERT"
		# ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		# ot-kernel_y_configopt "CONFIG_EPOLL"
		# ot-kernel_y_configopt "CONFIG_EVENTFD"
		# ot-kernel_y_configopt "CONFIG_FHANDLE"
		# ot-kernel_y_configopt "CONFIG_FUTEX"
		# ot-kernel_y_configopt "CONFIG_FUTEX2"
		# _ot-kernel_set_io_uring
		# ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		# ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		# ot-kernel_y_configopt "CONFIG_SIGNALFD"
		# ot-kernel_y_configopt "CONFIG_TIMERFD"

		# _ot-kernel_y_thp # References it in cargo package but not really used
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clamfs
# @DESCRIPTION:
# Applies kernel config flags for the clamfs package
ot-kernel-pkgflags_clamfs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/clamfs" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clang
# @DESCRIPTION:
# Applies kernel config flags for the clang package
ot-kernel-pkgflags_clang() { # DONE
	if ot-kernel_has_version_pkgflags "llvm-core/clang" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clsync
# @DESCRIPTION:
# Applies kernel config flags for the clsync package
ot-kernel-pkgflags_clsync() { # DONE
	local pkg="app-admin/clsync"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[clsync]" \
	; then
		if ot-kernel_has_version "${pkg}[inotify]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
		if ot-kernel_has_version "${pkg}[namespaces]" ; then
			_ot-kernel_set_ipc_ns
			_ot-kernel_set_net_ns
			_ot-kernel_set_pid_ns
			_ot-kernel_set_user_ns
			_ot-kernel_set_uts_ns
		fi
		if ot-kernel_has_version "${pkg}[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cni_plugins
# @DESCRIPTION:
# Applies kernel config flags for the cni-plugins package
ot-kernel-pkgflags_cni_plugins() { # DONE
	if ot-kernel_has_version_pkgflags ">=app-containers/cni-plugins-1.1.1" ; then
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT"
	elif ot-kernel_has_version_pkgflags "app-containers/cni-plugins" ; then
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_collectd
# @DESCRIPTION:
# Applies kernel config flags for the collectd package
ot-kernel-pkgflags_collectd() { # DONE
	local pkg="app-metrics/collectd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		if ot-kernel_has_acpi_support ; then
			ot-kernel_has_version "${pkg}[collectd_plugins_battery]" && ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
		fi
		ot-kernel_has_version "${pkg}[collectd_plugins_cgroups]" && ot-kernel_y_configopt "CONFIG_CGROUPS"
		if ot-kernel_has_version "${pkg}[collectd_plugins_cpufreq]" ; then
			ot-kernel_y_configopt "CONFIG_SYSFS"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_STAT"
		fi
		ot-kernel_has_version "${pkg}[collectd_plugins_drbd]" && ot-kernel_y_configopt "CONFIG_BLK_DEV_DRBD"
		ot-kernel_has_version "${pkg}[collectd_plugins_conntrack]" && ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_has_version "${pkg}[collectd_plugins_fscache]" && ot-kernel_y_configopt "CONFIG_FSCACHE"
		ot-kernel_has_version "${pkg}[collectd_plugins_nfs]" && ot-kernel_y_configopt "CONFIG_NFS_COMMON"
		ot-kernel_has_version "${pkg}[collectd_plugins_serial]" && ot-kernel_y_configopt "CONFIG_SERIAL_CORE"
		ot-kernel_has_version "${pkg}[collectd_plugins_swap]" && ot-kernel_y_configopt "CONFIG_SWAP"
		if ot-kernel_has_acpi_support ; then
			ot-kernel_has_version "${pkg}[collectd_plugins_thermal]" && ot-kernel_y_configopt "CONFIG_ACPI_THERMAL"
		fi
		ot-kernel_has_version "${pkg}[collectd_plugins_turbostat]" && ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_has_version "${pkg}[collectd_plugins_vmem]" && ot-kernel_y_configopt "CONFIG_VM_EVENT_COUNTERS"
		ot-kernel_has_version "${pkg}[collectd_plugins_vserver]" && ot-kernel_y_configopt "CONFIG_VSERVER"
		ot-kernel_has_version "${pkg}[collectd_plugins_uuid]" && ot-kernel_y_configopt "CONFIG_SYSFS"
		if ot-kernel_has_version "${pkg}[collectd_plugins_wireless]" ; then
			ot-kernel_y_configopt "CONFIG_WIRELESS"
			ot-kernel_y_configopt "CONFIG_MAC80211"
			ot-kernel_y_configopt "CONFIG_IEEE80211"
		fi
		if ot-kernel_has_version "${pkg}[collectd_plugins_zfs_arc]" ; then
			ot-kernel_y_configopt "CONFIG_SPL"
			ot-kernel_y_configopt "CONFIG_ZFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_compiler_rt_sanitizers
# @DESCRIPTION:
# Applies kernel config flags for the compiler-rt-sanitizers package
ot-kernel-pkgflags_compiler_rt_sanitizers() { # DONE
	local pkg="llvm-runtimes/compiler-rt-sanitizers"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
	        ot-kernel_y_configopt "CONFIG_SYSVIPC"
		if ot-kernel_has_version "${pkg}[test]" ; then
			_ot-kernel_set_seccomp_bpf "${pkg}"
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_conky
# @DESCRIPTION:
# Applies kernel config flags for the conky package
ot-kernel-pkgflags_conky() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/conky" ; then
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}


# @FUNCTION: ot-kernel-pkgflags_conty
# @DESCRIPTION:
# Applies kernel config flags for the conty package
ot-kernel-pkgflags_conty() { # DONE
	if ot-kernel_has_version_pkgflags "games-emulation/conty" ; then
		_ot-kernel_set_ia32_support
		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_conntrack_tools
# @DESCRIPTION:
# Applies kernel config flags for the conntrack-tools package
ot-kernel-pkgflags_conntrack_tools() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/conntrack-tools" ; then
		if ver_test "${MY_PV}" -lt "2.6.20" ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		fi
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_EVENTS"
		if grep -q -E -e "^CONFIG_INET=(y|m)" "${path_config}" ; then
			_ot-kernel-pkgflags_tcpip
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		fi
		if grep -q -E -e "^CONFIG_IPV6=(y|m)" "${path_config}" ; then
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_corefreq
# @DESCRIPTION:
# Applies kernel config flags for the corefreq package
ot-kernel-pkgflags_corefreq() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/corefreq" ; then
	# Required
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_SMP"
		ot-kernel_y_configopt "CONFIG_X86_MSR"

	# Optional
		ot-kernel_y_configopt "CONFIG_HOTPLUG_CPU"
		ot-kernel_y_configopt "CONFIG_CPU_IDLE"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_PM_SLEEP"
		ot-kernel_y_configopt "CONFIG_DMI"
		ot-kernel_y_configopt "CONFIG_HAVE_NMI"
		#ot-kernel_y_configopt "CONFIG_XEN" # See ot-kernel-pkgflags_xen
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AMD_NB"
		fi
		ot-kernel_y_configopt "CONFIG_HAVE_PERF_EVENTS"

	# See OT_KERNEL_CPU_SCHED
		#ot-kernel_y_configopt "CONFIG_SCHED_MUQSS"
		#ot-kernel_y_configopt "CONFIG_SCHED_BMQ"
		#ot-kernel_y_configopt "CONFIG_SCHED_PDS"
		#ot-kernel_y_configopt "CONFIG_SCHED_ALT"
		#ot-kernel_y_configopt "CONFIG_SCHED_BORE"
		#ot-kernel_y_configopt "CONFIG_SCHED_CACHY"

		if ot-kernel_has_acpi_support ; then
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_ACPI_CPPC_LIB"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_coreutils
# @DESCRIPTION:
# Applies kernel config flags for the coreutils package
ot-kernel-pkgflags_coreutils() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/coreutils" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_corosync
# @DESCRIPTION:
# Applies kernel config flags for the corosync package
ot-kernel-pkgflags_corosync() { # DONE
	local pkg="sys-cluster/corosync"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[watchdog]" \
	; then
		ot-kernel_y_configopt "CONFIG_WATCHDOG"
		_ot-kernel-pkgflags_add_watchdog_drivers
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_cr_suid_sandbox_settings
# @DESCRIPTION:
# Add config settings for suid sandbox support
_ot-kernel-pkgflags_cr_suid_sandbox_settings() { # DONE
	local pkg="${1}"
	_ot-kernel_set_net_ns
	_ot-kernel_set_pid_ns
	_ot-kernel_set_user_ns
	_ot-kernel_set_seccomp_bpf "${pkg}"
	ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
	ot-kernel_unset_configopt "CONFIG_COMPAT_VDSO"
	if grep -q -e "^CONFIG_GRKERNSEC=y" "${path_config}" ; then
		# Still added because user may add patch via /etc/portage/patches
		local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
eerror
eerror "Lowered security detected:"
eerror
eerror "The CONFIG_GRKERNSEC flag will break the suid sandbox."
		if [[ "${pkg}" =~ "/" ]] ; then
eerror "Either set OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1 or disable CONFIG_GRKERNSEC."
		else
eerror "Either set USE_SUID_SANDBOX=0 or disable CONFIG_GRKERNSEC."
		fi
eerror
		die
	fi
	ot-kernel_unset_configopt "CONFIG_GRKERNSEC"
}

CR_PKGS=(
# Obtained from
# From /usr/portage \
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "chromium_suid_sandbox_check_kernel_config" ./ | cut -f 2-3 -d "/" | sort | uniq
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "chrome-sandbox" ./ | cut -f 2-3 -d "/" | sort | uniq
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "electron" ./ | grep ".ebuild:" | cut -f 2-3 -d "/"			# Requires manual inspection
# From /var/lib/layman \
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "chrome-sandbox" ./ | cut -f 3-4 -d "/" | sort | uniq
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "electron-app" ./ | grep ".ebuild:" | cut -f 2-3 -d "/" | sort | uniq
# grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -r -e "electron" ./ | grep ".ebuild:" | cut -f 3-4 -d "/" | sort | uniq	# Requires manual inspection
app-admin/bitwarden-desktop-bin
app-editors/epic-journal
app-editors/vscode
app-editors/vscodium
app-office/drawio-desktop-bin
dev-db/dbgate-bin
dev-games/gdevelop
dev-qt/qtwebengine
dev-util/arctype
dev-util/beekeeper-studio-bin
dev-util/clion
dev-util/devhub
dev-util/eclipse-theia
dev-util/electron-bin
dev-util/electron-packager
dev-util/insomnia-bin
dev-util/lepton
dev-util/postman
dev-util/pycharm-community
dev-util/pycharm-professional
dev-util/testmace
media-gfx/blockbench
media-gfx/evoluspencil
media-gfx/texturelab
media-gfx/WebPlotDigitizer-bin
media-sound/nuclear-bin
media-sound/plexamp
media-sound/teamspeak-client
media-sound/tidal-hifi-bin
media-video/obs-studio
net-im/caprine
net-im/discord
net-im/discord-bin
net-im/discord-canary-bin
net-im/discord-ptb-bin
net-im/discord-wayland
net-im/element-desktop-bin
net-im/guilded-bin
net-im/session-desktop-bin
net-im/signal-desktop-bin
net-im/skypeforlinux
net-im/slack
net-im/teams
net-im/whatsapp-desktop-bin
net-libs/cef
net-libs/cef-bin
net-proxy/insomnia-bin
sci-mathematics/rstudio-desktop-bin
www-apps/BloodHound
www-client/chromium
www-client/chromium-bin
www-client/google-chrome
www-client/google-chrome-beta
www-client/google-chrome-unstable
www-client/microsoft-edge
www-client/microsoft-edge-beta
www-client/microsoft-edge-dev
www-client/opera
www-client/opera-beta
www-client/opera-developer
www-client/vivaldi
www-misc/instatron
)

# @FUNCTION: _ot-kernel-pkgflags_apply_cr_kconfig
# @DESCRIPTION:
# Applies kconfig flags for cr based apps
_ot-kernel-pkgflags_apply_cr_kconfig() {
	local pkg="${1}"
	_ot-kernel-pkgflags_cr_suid_sandbox_settings "${pkg}"
	ot-kernel_y_configopt "CONFIG_SYSVIPC"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
	ot-kernel_y_configopt "CONFIG_AIO"
	ot-kernel_y_configopt "CONFIG_EPOLL"
	ot-kernel_y_configopt "CONFIG_EVENTFD"
	ot-kernel_y_configopt "CONFIG_FUTEX"
	ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	_ot-kernel_set_io_uring
	ot-kernel_y_configopt "CONFIG_MEMBARRIER"
	ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	_ot-kernel_set_shmem
	ot-kernel_y_configopt "CONFIG_SIGNALFD"
	ot-kernel_y_configopt "CONFIG_TIMERFD"

	_OT_KERNEL_LSM_ADD_YAMA=1

	_ot-kernel_y_thp # lowers memory access times
	# LDT referenced
}

# @FUNCTION: ot-kernel-pkgflags_cr
# @DESCRIPTION:
# Applies kernel config flags for the cr based packages
ot-kernel-pkgflags_cr() { # DONE
	local pkg
	for pkg in ${CR_PKGS[@]} ; do
		if [[ "${USE_SUID_SANDBOX:-0}" == "1" ]] ; then
einfo "Applying kernel config flags for cr package (USE_SUID_SANDBOX=${USE_SUID_SANDBOX})"
			_ot-kernel-pkgflags_apply_cr_kconfig "USE_SUID_SANDBOX=1"
			break
		elif ot-kernel_has_version_pkgflags_slow "${pkg}" ; then
			_ot-kernel-pkgflags_apply_cr_kconfig "${pkg}"
		fi
	done
}

# @FUNCTION: ot-kernel-pkgflags_crda
# @DESCRIPTION:
# Applies kernel config flags for the crda package
ot-kernel-pkgflags_crda() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/crda" ; then
		ot-kernel_has_version "net-wireless/wireless-regdb" || die "Install the wireless-regdb package first"
		ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_WIRELESS"
		ot-kernel_y_configopt "CONFIG_CFG80211"
		ot-kernel_y_configopt "CONFIG_CFG80211_CERTIFICATION_ONUS"
		ot-kernel_y_configopt "CONFIG_CFG80211_REQUIRE_SIGNED_REGDB"
		ot-kernel_y_configopt "CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_criu
# @DESCRIPTION:
# Applies kernel config flags for the criu package
ot-kernel-pkgflags_criu() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/criu" ; then
		ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"

		_ot-kernel_set_pid_ns

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_UNIX_DIAG"
	        _ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_INET_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_UDP_DIAG"
		ot-kernel_y_configopt "CONFIG_PACKET_DIAG"
		ot-kernel_y_configopt "CONFIG_NETLINK_DIAG"
		_ot-kernel-pkgflags_tun
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
		if [[ "${arch}" == "x86_64" ]] ; then
			_ot-kernel_set_ia32_support
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryfs
# @DESCRIPTION:
# Applies kernel config flags for the cryfs package
ot-kernel-pkgflags_cryfs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/cryfs" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryptodev
# @DESCRIPTION:
# Applies kernel config flags for the cryptodev package
ot-kernel-pkgflags_cryptodev() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/cryptodev" ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.8" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_BLKCIPHER"
		else
			ot-kernel_y_configopt "CONFIG_CRYPTO_SKCIPHER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryptmount
# @DESCRIPTION:
# Applies kernel config flags for the cryptmount package
ot-kernel-pkgflags_cryptmount() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/cryptmount" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_neon
# @DESCRIPTION:
# Adds neon kernel config flags
_ot-kernel-pkgflags_neon() {
	if ot-kernel_use cpu_flags_arm_neon ; then
		ot-kernel_y_configopt "CONFIG_AEABI"
		ot-kernel_y_configopt "CONFIG_NEON"
		ot-kernel_y_configopt "CONFIG_KERNEL_MODE_NEON"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_aes
# @DESCRIPTION:
# Wrapper for the aes option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_aes() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_AES}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM"
		if ot-kernel_use cpu_flags_arm_neon ; then
			if [[ "${modes}" =~ ("CBC"|"CTR"|"CTS"|"ECB"|"XTS") ]] ; then
# FIXME:  Update modes conditonals with CCM GCM to be more open-ended to add the
# hardware accelerated cipher without AEAD.
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM_BS"
			fi
			if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM_CE"
			fi
			if [[ "${modes}" =~ ("GCM") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_ARM_CE"
			fi
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64"
		if ot-kernel_use cpu_flags_arm_neon ; then
			if [[ "${modes}" =~ ("CBC"|"CTR"|"CTS"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64_CE"
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64_CE_BLK"
			fi
			if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64_BS"
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64_NEON_BLK"
			fi
			if [[ "${modes}" =~ ("GCM") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_ARM64_CE"
			fi
			if [[ "${modes}" =~ ("CCM") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM64_CE_CCM"
			fi
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if grep -q -E -e "^CONFIG_SPE_POSSIBLE=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_SPE"
			if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_PPC_SPE"
			fi
		fi
		if grep -q -E -e "^CONFIG_PPC64=y" "${path_config}" ; then
			if grep -q -E -e "^CONFIG_CPU_LITTLE_ENDIAN=y" "${path_config}" ; then
				if grep -q -E -e "^VSX=y" "${path_config}" ; then
					if [[ "${modes}" =~ ("GCM") ]] ; then
						ot-kernel_y_configopt "CONFIG_CRYPTO_AES_GCM_P10"
					fi
				fi
			fi
			if grep -q -E -e "^VSX=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_DEV_VMX"
				ot-kernel_y_configopt "CONFIG_CRYPTO_DEV_VMX_ENCRYPT"
			fi
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_AES_S390"
			ot-kernel_y_configopt "CONFIG_ZCRYPT"
			ot-kernel_y_configopt "CONFIG_PKEY"
			ot-kernel_y_configopt "CONFIG_CRYPTO_PAES_S390"
		fi
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_SPARC64"
			fi
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_aes ; then
			if [[ "${modes}" =~ ("CBC"|"GCM"|"CTR"|"CTS"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_NI_INTEL"
			fi
		elif ver_test "${KV_MAJOR_MINOR}" -le "5.3" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_AES_X86_64"
		fi
	fi
	if [[ "${modes}" =~ ("CCM"|"GCM"|"CTR"|"CMAC"|"XCBC") ]] ; then
		# For mitigation against possible timing side channel attacks
		# with network algorithms overriding the generic version.
		ot-kernel_set_configopt "CONFIG_CRYPTO_AES_TI" "m"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_AES"
}

# @FUNCTION: _ot-kernel-pkgflags_aria
# @DESCRIPTION:
# Wrapper for the aria option.
_ot-kernel-pkgflags_aria() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_ARIA}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CTR"
	if [[ "${arch}" == "x86_64" ]] ; then
		if [[ "${modes}" =~ ("ECB"|"CTR") ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -ge "6.1" ; then
				if \
					   ot-kernel_use cpu_flags_x86_avx \
					&& ot-kernel_use cpu_flags_x86_avx2 \
					&& ot-kernel_use cpu_flags_x86_avx512vl \
					&& ot-kernel_use cpu_flags_x86_gfni \
				; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64"
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64"
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
				elif ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx2 ; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64"
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
				elif ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx ; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
				fi
			elif ver_test "${KV_MAJOR_MINOR}" -ge "6.1" ; then
				if ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx2 ; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
				elif ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx ; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
				fi
			fi
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_ARIA"
}

# @FUNCTION: _ot-kernel-pkgflags_anubis
# @DESCRIPTION:
# Wrapper for the anubis option.
_ot-kernel-pkgflags_anubis() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_ANUBIS}" == "1" ]] && continue
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE"
	ot-kernel_y_configopt "CONFIG_CRYPTO_ANUBIS"
}

# @FUNCTION: _ot-kernel-pkgflags_blake2b
# @DESCRIPTION:
# Wrapper for the blake2b option.
_ot-kernel-pkgflags_blake2b() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_BLAKE2B}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2B_NEON"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2B"
}

# @FUNCTION: _ot-kernel-pkgflags_blake2s
# @DESCRIPTION:
# Wrapper for the blake2s option.
_ot-kernel-pkgflags_blake2s() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_BLAKE2S}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2S_ARM"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		# Can use avx512vl
		ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2S_X86"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2S"
}

# @FUNCTION: _ot-kernel-pkgflags_camellia
# @DESCRIPTION:
# Wrapper for the camellia option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_camellia() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CAMELLIA}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx2 && ot-kernel_use cpu_flags_x86_aes && [[ "${modes}" =~ ("CBC"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64"
		elif ot-kernel_use cpu_flags_x86_avx && ot-kernel_use cpu_flags_x86_aes && [[ "${modes}" =~ ("CBC"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64"
		elif [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_X86_64"
		fi
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			if [[ "${modes}" =~ ("CBC"|"ECB") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_SPARC64"
			fi
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA"
}

# @FUNCTION: _ot-kernel-pkgflags_cast6
# @DESCRIPTION:
# Wrapper for the cast6 option.
_ot-kernel-pkgflags_cast6() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CAST6}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx ; then
			if [[ "${modes}" =~ ("CBC"|"ECB"|"CTR"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_CAST6_AVX_X86_64"
			fi
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CAST6"
}

# @FUNCTION: _ot-kernel-pkgflags_chacha20
# @DESCRIPTION:
# Wrapper for the chacha20 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_chacha20() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CHACHA20}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_NEON"
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_NEON"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_SYS_HAS_CPU_MIPS32_R2=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CPU_MIPS32_R2"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA_MIPS"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if grep -q -E -e "^CONFIG_PPC64=y" "${path_config}" ; then
			if grep -q -E -e "^CONFIG_CPU_LITTLE_ENDIAN=y" "${path_config}" ; then
				if grep -q -E -e "^CONFIG_VSX=y" "${path_config}" ; then
					ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_P10"
				fi
			fi
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA_S390"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx512vl ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif ot-kernel_use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20"
}

# @FUNCTION: _ot-kernel-pkgflags_kuznyechik
# @DESCRIPTION:
# Wrapper for the kuznyechik option.
_ot-kernel-pkgflags_kuznyechik() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_KUZNYECHIK}" == "1" ]] && continue
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	local tls="${TLS:-1}"
	if [[ "${tls}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CTR"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_poly1305
# @DESCRIPTION:
# Wrapper for the poly1305 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_poly1305() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_POLY1305}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_ARM"
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_KERNEL_MODE_NEON"
			ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_NEON"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_MIPS"
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if \
			   grep -q -E -e "^CONFIG_PPC64=y" "${path_config}" \
			&& grep -q -E -e "^CONFIG_CPU_LITTLE_ENDIAN=y" "${path_config}" \
			&& grep -q -E -e "^CONFIG_VSX=y" "${path_config}" \
		; then
	# Power10 or later AND little-endian and 64-bit
			ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_P10"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_X86_64"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305"
}

# @FUNCTION: _ot-kernel-pkgflags_chacha20_poly1305
# @DESCRIPTION:
# Wrapper for the chacha20-poly1305 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_chacha20_poly1305() {
	_ot-kernel-pkgflags_chacha20
	_ot-kernel-pkgflags_poly1305
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20POLY1305"
}

# @FUNCTION: _ot-kernel-pkgflags_crc32
# @DESCRIPTION:
# Wrapper for the crc32 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_crc32() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CRC32}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_ARM_CE"
		fi
	fi
	if [[ "${arch}" == "loongarch" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_LOONGARCH"
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_MIPS_CRC_SUPPORT=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_MIPS"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_S390"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_sse4_2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_PCLMUL"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32"
}

# @FUNCTION: _ot-kernel-pkgflags_crc32c
# @DESCRIPTION:
# Wrapper for the crc32c option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_crc32c() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CRC32C}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_ARM_CE"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_MIPS_CRC_SUPPORT=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_MIPS"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if grep -q -E -e "^CONFIG_PPC64=y" "${path_config}" \
			&& ot-kernel_use cpu_flags_ppc_altivec ; then
			ot-kernel_y_configopt "CONFIG_ALTIVEC"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32C_VPMSUM"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32_S390"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32C_SPARC64"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_sse4_2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32C_INTEL"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CRC32C"
}

# @FUNCTION: _ot-kernel-pkgflags_curve25519
# @DESCRIPTION:
# Wrapper for the Curve25519 option.
_ot-kernel-pkgflags_curve25519() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_CURVE25519}" == "1" ]] && continue
	ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_CURVE25519"
	if [[ "${arch}" == "arm" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_AEABI"
			ot-kernel_y_configopt "CONFIG_NEON"
			ot-kernel_y_configopt "CONFIG_KERNEL_MODE_NEON"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CURVE25519_NEON"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_CURVE25519_X86"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_CURVE25519"
}

# @FUNCTION: _ot-kernel-pkgflags_des
# @DESCRIPTION:
# Wrapper for the DES option.
_ot-kernel-pkgflags_des() {
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_DES}" == "1" ]] && continue
	if [[ "${arch}" == "s390" ]] ; then
		if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_DES_S390"
		fi
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			if [[ "${modes}" =~ ("CBC"|"ECB") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_DES_SPARC64"
			fi
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_DES"
}

# @FUNCTION: _ot-kernel-pkgflags_des3_ede
# @DESCRIPTION:
# Wrapper for the DES3 EDE option.
_ot-kernel-pkgflags_des3_ede() {
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_DES3_EDE}" == "1" ]] && continue
	if [[ "${arch}" == "s390" ]] ; then
		if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_DES_S390"
		fi
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			if [[ "${modes}" =~ ("CBC"|"ECB") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_DES_SPARC64"
			fi
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if [[ "${modes}" =~ ("CBC"|"ECB"|"CTR") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_DES3_EDE_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_DES"
}

# @FUNCTION: _ot-kernel-pkgflags_csprng
# @DESCRIPTION:
# Wrapper for cryptographically secure pseudorandom random number generators.
_ot-kernel-pkgflags_csprng() {
	local region
	local dss_region="${DSS_REGION:-west}"
	local tls_region="${TLS_REGION:-west}"
	if [[ "${work_profile}" == "dss" ]] ; then
		region="${dss_region}"
	else
		region="${tls_region}"
	fi
	if [[ "${region}" =~ ("us") ]] ; then
		_ot-kernel-pkgflags_aes CTR
		_ot-kernel-pkgflags_sha256
		_ot-kernel-pkgflags_sha512
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_DRBG_MENU"
		ot-kernel_y_configopt "CONFIG_CRYPTO_DRBG_HASH" # with SHA256 to SHA512
		ot-kernel_y_configopt "CONFIG_CRYPTO_DRBG_CTR"  # with AES
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
	else
		# The Fallback is TRNG
		# ANSI X9.31 (aka ANSI PRNG) was deprecated in 2011 and removed from FIPS in 2016.
		:
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_gcm
# @DESCRIPTION:
# Wrapper for the gcm option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_gcm() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_GCM}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_ARM_CE" # ghash only
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_ARM64_CE"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_S390"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_aes || ot-kernel_use cpu_flags_x86_clmul_ni ; then
# There is an edge case or processor affected can verified at.
# https://gist.github.com/mmcloughlin/66488e42a8fdbd9ab39c3f6438bb8ed7#file-cpuids-txt-L188
			ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_GCM"
	ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH"
}

# @FUNCTION: _ot-kernel-pkgflags_md5
# @DESCRIPTION:
# Wrapper for the md5 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_md5() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_MD5}" == "1" ]] && continue
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_MD5_OCTEON"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_MD5_PPC"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_MD5_SPARC64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_MD5"
}

# @FUNCTION: _ot-kernel-pkgflags_sha1
# @DESCRIPTION:
# Wrapper for the sha1 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha1() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SHA1}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_ARM"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_ARM_NEON"
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_ARM64_CE"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_OCTEON"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_PPC"
		if grep -q -E -e "^CONFIG_SPE_POSSIBLE=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_SPE"
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_PPC_SPE"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_S390"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SPARC64"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_sha ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif ot-kernel_use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		elif ot-kernel_use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1"
}

# @FUNCTION: _ot-kernel-pkgflags_sha256
# @DESCRIPTION:
# Wrapper for the sha256 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha256() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SHA256}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_ARM"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA2_ARM_CE"
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_ARM64"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA2_ARM64_CE"
		fi
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if grep -q -E -e "^CONFIG_SPE_POSSIBLE=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_SPE"
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_PPC_SPE"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_OCTEON"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_S390"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SPARC64"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_sha ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif ot-kernel_use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		elif ot-kernel_use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256"
}

# @FUNCTION: _ot-kernel-pkgflags_sha3
# @DESCRIPTION:
# Wrapper for the sha3 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha3() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SHA3}" == "1" ]] && continue
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA3_ARM64"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA3_256_S390"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA3_512_S390"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA3"
}

# @FUNCTION: _ot-kernel-pkgflags_sha512
# @DESCRIPTION:
# Wrapper for the sha512 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sha512() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SHA512}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_ARM"
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_ARM64"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_ARM64_CE"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		if grep -q -E -e "^CONFIG_CPU_CAVIUM_OCTEON=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_OCTEON"
		fi
	fi
	if [[ "${arch}" == "s390" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_S390"
	fi
	if [[ "${arch}" == "sparc" || "${arch}" == "sparc64" ]] ; then
		if grep -q -E -e "^CONFIG_SPARC64=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SPARC64"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		elif ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		elif ot-kernel_use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512"
}

# @FUNCTION: _ot-kernel-pkgflags_sm3
# @DESCRIPTION:
# Wrapper for the sm3 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sm3() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SM3}" == "1" ]] && continue
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SM3_AVX_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SM3"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SM3_GENERIC"
}

# @FUNCTION: _ot-kernel-pkgflags_serpent
# @DESCRIPTION:
# Wrapper for the serpent option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_serpent() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SERPENT}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx2 && [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_AVX2_X86_64"
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_AVX_X86_64"
		elif ot-kernel_use cpu_flags_x86_avx && [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_AVX_X86_64"
		elif ot-kernel_use cpu_flags_x86_sse2 && [[ "${modes}" =~ ("CBC"|"ECB"|"CTR") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_SSE2_X86_64"
		fi
	fi
	if [[ "${arch}" == "x86" ]] ; then
		if ot-kernel_use cpu_flags_x86_sse2 && [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT_SSE2_586"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT"
}

# @FUNCTION: _ot-kernel-pkgflags_sm4
# @DESCRIPTION:
# Wrapper for the sm4 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_sm4() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_SM4}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC CTR"
	if [[ "${arch}" == "x86_64" ]] ; then
		if [[ "${modes}" =~ ("ECB"|"CBC"|"CTR") ]] ; then
			if ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx2 ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64"
				ot-kernel_y_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64"
			elif ot-kernel_use cpu_flags_x86_aesni && ot-kernel_use cpu_flags_x86_avx ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64"
			fi
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_SM4_GENERIC"
}

# @FUNCTION: _ot-kernel-pkgflags_twofish
# @DESCRIPTION:
# Wrapper for the twofish option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_twofish() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_TWOFISH}" == "1" ]] && continue
	local modes="${@}"
	[[ -z "${modes}" ]] && modes="ECB CBC"
	if [[ "${arch}" == "x86" ]] ; then
		if [[ "${modes}" =~ ("CTR") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_586"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx && [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_AVX_X86_64"
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64_3WAY"
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64"
		elif [[ "${modes}" =~ ("CBC"|"CTR"|"ECB") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64_3WAY"
			ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_TWOFISH"
}

# @FUNCTION: _ot-kernel-pkgflags_nhpoly1305
# @DESCRIPTION:
# Wrapper for the nhpoly1305 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_nhpoly1305() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_NHPOLY1305}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_NEON"
		fi
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_NEON"
		fi
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_AVX2"
		elif ot-kernel_use cpu_flags_x86_sse2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305_SSE2"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_NHPOLY1305"
	ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
}

# @FUNCTION: _ot-kernel-pkgflags_poly1305
# @DESCRIPTION:
# Wrapper for the poly1305 option.  Adds the simd but implied the generic as well.
_ot-kernel-pkgflags_poly1305() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_POLY1305}" == "1" ]] && continue
	if [[ "${arch}" == "arm" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_ARM"
	fi
	if [[ "${arch}" == "arm64" ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM64_CRYPTO"
		if ot-kernel_use cpu_flags_arm_neon ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_NEON"
		fi
	fi
	if [[ "${arch}" == "mips" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_MIPS"
	fi
	if [[ "${arch}" == "x86_64" ]] ; then
		ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305_X86_64"
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO"
	ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305"
	ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
}

# @FUNCTION: ot-kernel-pkgflags_cryptsetup
# @DESCRIPTION:
# Applies kernel config flags for the cryptsetup package
ot-kernel-pkgflags_cryptsetup() { # DONE
	if [[ "${DSS_DISK_ENCRYPTION}" == "cryptsetup" ]] ; then
ewarn "Detected DSS_DISK_ENCRYPTION=\"cryptsetup\".  Using default settings and industry standard ciphers only."
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"

	# It is assume that the secure system is always encrypted so plausable
	# deniability does not apply.
ewarn
ewarn "The defaults for plain dm-crypt are dropped in the dss work profile."
ewarn "It is assumed LUKS2 will be used instead with cryptsetup."
ewarn

		local cryptsetup_ciphers="aes"
		# aes is default for plain
		# aes is default for luks1

		local cryptsetup_hashes="sha256"
		# rmd160 is default for plain, but requires sha256 for essiv defaults
		# sha256 is default for luks1

		local cryptsetup_integrities=""

		local cryptsetup_ivs="plain64"
		# essiv:sha256 is default for plain
		# plain64 is default for luks2

		local cryptsetup_modes="cbc xts"
		# cbc is default for plain
		# xts is default for luks

		# This section is for secure storage.  For network transmission see
		# _ot-kernel_checkpoint_dss_tls_requirement
		local dss_region="${DSS_REGION:-west}"
		if [[ "${dss_region}" =~ ("west"|"eu"|"us") ]] ; then
			_ot-kernel-pkgflags_aes ${cryptsetup_modes}

			# 2001, American (NSA), Hash Function
			_ot-kernel-pkgflags_sha256

			# 2001, American (NSA), Hash Function
			_ot-kernel-pkgflags_sha512

			# 2006, Belgian
			_ot-kernel-pkgflags_sha3
		elif [[ "${dss_region}" =~ "cn" ]] ; then
			_ot-kernel-pkgflags_sm4 ${cryptsetup_modes}
			_ot-kernel-pkgflags_sm3
		elif [[ "${dss_region}" =~ "jp" ]] ; then
			_ot-kernel-pkgflags_camellia ${cryptsetup_modes}
		elif [[ "${dss_region}" =~ "kr" ]] ; then
			_ot-kernel-pkgflags_aria ${cryptsetup_modes}
		elif [[ "${dss_region}" =~ "ru" ]] ; then
			_ot-kernel-pkgflags_kuznyechik ${cryptsetup_modes}
			if ot-kernel_use gost ; then
	# Already provided in sys-kernel/gostcrypt-linux-crypto
				ot-kernel_unset_configopt "CONFIG_CRYPTO_STREEBOG"
			else
				ot-kernel_y_configopt "CONFIG_CRYPTO_STREEBOG"
			fi
		fi

ewarn "Do not use ECB for disk encryption."
ewarn "Do not use CBC for disk encryption."
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CBC"	# Disabled to prevent integrity attack.  See https://en.wikipedia.org/wiki/Disk_encryption_theory#Malleability_attack
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CFB"	# Not tested upstream?
		ot-kernel_y_configopt "CONFIG_CRYPTO_CTR"
		#ot-kernel_y_configopt "CONFIG_CRYPTO_CTS"	# Used in CONFIG_FS_ENCRYPTION
		ot-kernel_unset_configopt "CONFIG_CRYPTO_OFB"	# Not tested upstream?
		ot-kernel_y_configopt "CONFIG_CRYPTO_XTS"

	# Ciphers changed unconditionally at the end of
	# ot-kernel_src_configure_assisted in the _ot-kernel-pkgflags_dss_*
	# section.

		if ver_test "${KV_MAJOR_MINOR}" -ge "5.16" ; then
			ot-kernel_y_configopt "CONFIG_NET" # CONFIG_AUDIT dep
			ot-kernel_y_configopt "CONFIG_AUDIT"
			ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
			ot-kernel_y_configopt "CONFIG_DM_AUDIT"
		fi

	elif ot-kernel_has_version_pkgflags "sys-fs/cryptsetup" ; then
		if [[ "${work_profile}" == "dss" ]] ; then
# The specs require all weak ciphers disabled.
eerror
eerror "DSS_DISK_ENCRYPTION=\"cryptsetup\" must be explictly used."
eerror
			die
		fi
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		# Defaults are in configure.ac of cryptsetup
		local cryptsetup_ciphers=""
		if [[ -z "${cryptsetup_ciphers}" ]] ; then
			cryptsetup_ciphers="aes"
			# aes is default for plain
			# aes is default for luks1
			# aes is default for adiantum
		else
			cryptsetup_ciphers="${CRYPTSETUP_CIPHERS,,}"
		fi
		local cryptsetup_hashes=""
		if [[ -z "${cryptsetup_hashes}" ]] ; then
			cryptsetup_hashes="rmd160 sha256"
			# rmd160 is default for plain, but requires sha256 for essiv defaults
			# sha256 is default for luks1
		else
			cryptsetup_hashes="${CRYPTSETUP_HASHES,,}"
		fi
		local cryptsetup_integrities=""
		if [[ -z "${cryptsetup_integrities}" ]] ; then
			cryptsetup_integrities=""
		else
			cryptsetup_integrities="${CRYPTSETUP_INTEGRITIES,,}"
		fi
		local cryptsetup_ivs=""
		if [[ -z "${cryptsetup_ivs}" ]] ; then
			cryptsetup_ivs="essiv plain64"
			# essiv:sha256 is default for plain
			# plain64 is default for luks2
		else
			cryptsetup_ivs="${CRYPTSETUP_IVS,,}"
		fi
		local cryptsetup_modes=""
		if [[ -z "${cryptsetup_modes}" ]] ; then
			cryptsetup_modes="adiantum cbc xts"
			# cbc is default for plain
			# xts is default for luks
			# adiantum is for mobile fits all
		else
			cryptsetup_modes="${CRYPTSETUP_MODES,,}"
		fi

		# We do not include weak ciphers which may expose keys during swap out.
		[[ "${cryptsetup_ciphers}" =~ "aes" ]] && _ot-kernel-pkgflags_aes ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "aria" ]] && _ot-kernel-pkgflags_aria ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "anubis" ]] && _ot-kernel-pkgflags_anubis ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "camellia" ]] && _ot-kernel-pkgflags_camellia ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "cast6" ]] && _ot-kernel-pkgflags_cast6 ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "kuznyechik" ]] && _ot-kernel-pkgflags_kuznyechik ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "serpent" ]] && _ot-kernel-pkgflags_serpent ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "sm4" ]] && _ot-kernel-pkgflags_sm4 ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "twofish" ]] && _ot-kernel-pkgflags_twofish ${cryptsetup_modes}

		[[ "${cryptsetup_hashes}" =~ "blake2b" ]] && _ot-kernel-pkgflags_blake2b
		[[ "${cryptsetup_hashes}" =~ "blake2s" ]] && _ot-kernel-pkgflags_blake2s
		[[ "${cryptsetup_hashes}" =~ "rmd160" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_RMD160"
		[[ "${cryptsetup_hashes}" =~ "sha256" ]] && _ot-kernel-pkgflags_sha256
		[[ "${cryptsetup_hashes}" =~ "sha512" ]] && _ot-kernel-pkgflags_sha512
		[[ "${cryptsetup_hashes}" =~ "sha3" ]] && _ot-kernel-pkgflags_sha3
		[[ "${cryptsetup_hashes}" =~ "wp512" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_WP512"

ewarn "ESSIV is deprecated, do not use for newer deployments."
		[[ "${cryptsetup_ivs}" =~ "essiv" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_ESSIV"	# For compatibility, do not use for newer deployments

ewarn "Do not use ECB for disk encryption."
		[[ "${cryptsetup_modes}" =~ "cbc" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"	# From ebuild
		#[[ "${cryptsetup_modes}" =~ "cfb" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CFB"	# Not tested upstream?
		[[ "${cryptsetup_modes}" =~ "ctr" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CTR"
		#[[ "${cryptsetup_modes}" =~ "cts" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CTS"	# Used in CONFIG_FS_ENCRYPTION
		#[[ "${cryptsetup_modes}" =~ "ofb" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_OFB"	# Not tested upstream?
		[[ "${cryptsetup_modes}" =~ "xts" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_XTS"

		#[[ "${cryptsetup_integrities}" =~ "aead" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"	# use only with aes-gcm-random
		[[ "${cryptsetup_integrities}" =~ "poly1305" ]] && _ot-kernel-pkgflags_poly1305			# use only with chacha20
		[[ "${cryptsetup_integrities}" =~ "hmac-sha256" ]] && _ot-kernel-pkgflags_sha256		# use only with aes-xts-plain64
		[[ "${cryptsetup_integrities}" =~ "hmac-sha512" ]] && _ot-kernel-pkgflags_sha512		# use only with aes-xts-plain64
		#[[ "${cryptsetup_integrities}" =~ "cmac-aes" ]] && _ot-kernel-pkgflags_aes			# undocumented combo, missing block cipher for AEAD

		[[ "${cryptsetup_integrities}" =~ "hmac" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		#[[ "${cryptsetup_integrities}" =~ "cmac" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"	# undocumented combo, missing block cipher for AEAD

		if [[ -n "${cryptsetup_integrities}" ]] ; then
ewarn "AEAD cryptsetup support is experimental"
			# CONFIG_BLK_DEV_DM is Added above
			ot-kernel_y_configopt "CONFIG_DM_INTEGRITY"
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_AEAD"
		fi

		CRYPTSETUP_TCRYPT="${CRYPTSETUP_TCRYPT:-1}"
		if [[ "${CRYPTSETUP_TCRYPT}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_HASH"
			ot-kernel_y_configopt "CONFIG_CRYPTO_RMD160"
			_ot-kernel-pkgflags_sha512
			ot-kernel_y_configopt "CONFIG_CRYPTO_WP512"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LRW"	# Block mode
			_ot-kernel-pkgflags_serpent ${cryptsetup_modes}
			_ot-kernel-pkgflags_twofish ${cryptsetup_modes}
		fi
		if [[ "${cryptsetup_modes}" =~ "adiantum" ]] ; then
			# The wrappers below add the hardware accelerated versions if any.
			_ot-kernel-pkgflags_chacha20   # Uses actually XChaCha12 for stream cipher
			_ot-kernel-pkgflags_nhpoly1305 # A hash function from this module.

			# AES already added above.
			# AES is as the block cipher is used upstream, but any 16 byte block size with 256 bit key
			ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ADIANTUM" # Adds the generic versions of chacha20 and nhpoly1305.
		fi

		if [[ "${CRYPTSETUP_VERITY}" == "1" ]] && ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
			ot-kernel_y_configopt "CONFIG_DM_VERITY"
			ot-kernel_y_configopt "CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG"
			if ver_test "${KV_MAJOR_MINOR}" -ge "6.11" ; then
				ot-kernel_y_configopt "CONFIG_KEYS"
				ot-kernel_y_configopt "CONFIG_SIGNATURE"
				ot-kernel_y_configopt "CONFIG_SYSTEM_BLACKLIST_KEYRING"
				ot-kernel_y_configopt "CONFIG_INTEGRITY_ASYMMETRIC_KEYS"

				ot-kernel_y_configopt "CONFIG_ASYMMETRIC_KEY_TYPE"
				ot-kernel_y_configopt "CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE"
				ot-kernel_y_configopt "CONFIG_X509_CERTIFICATE_PARSER"
				ot-kernel_y_configopt "CONFIG_SYSTEM_TRUSTED_KEYRING"
				ot-kernel_y_configopt "CONFIG_SECONDARY_TRUSTED_KEYRING"
				ot-kernel_y_configopt "CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING"

				if _ot-kernel_is_hardening_level_least_secure ; then
eerror
eerror "CRYPTSETUP_VERITY=1 conflicts with"
eerror "OT_KERNEL_HARDENING_LEVEL=fast|fast-af|fast-as-fuck|performance"
eerror
eerror "To continue, change to one of these"
eerror
eerror "  1. OT_KERNEL_HARDENING_LEVEL=secure"
eerror "  2. OT_KERNEL_HARDENING_LEVEL=secure-af"
eerror "  3. CRYPTSETUP_VERITY=0"
eerror
					die
				fi

				ot-kernel_y_configopt "CONFIG_SYSFS"
				ot-kernel_y_configopt "CONFIG_MULTIUSER"
				ot-kernel_y_configopt "CONFIG_SECURITY"
				ot-kernel_y_configopt "CONFIG_INTEGRITY"
				ot-kernel_y_configopt "CONFIG_INTEGRITY_SIGNATURE"
				ot-kernel_y_configopt "CONFIG_INTEGRITY_PLATFORM_KEYRING"
				ot-kernel_y_configopt "CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cups
# @DESCRIPTION:
# Applies kernel config flags for the cups package
ot-kernel-pkgflags_cups() { # DONE
	local pkg="net-print/cups"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[-usb]" \
	; then
		# The usb USE flag is a misnomer.
		# usb = support via libusb
		# -usb = kernel usb printer driver

		# Implied ot-kernel_has_version "net-print/cups[linux_kernel]"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cvmfs
# @DESCRIPTION:
# Applies kernel config flags for the cvmfs package
ot-kernel-pkgflags_cvmfs() { # DONE
	if ot-kernel_has_version_pkgflags "net-fs/cvmfs" ; then
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dahdi
# @DESCRIPTION:
# Applies kernel config flags for the dahdi package
ot-kernel-pkgflags_dahdi() { # DONE
	local pkg="net-misc/dahdi"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_CRC_CCITT"
		if ot-kernel_has_version "${pkg}[oslec]" ; then
			ot-kernel_y_configopt "CONFIG_ECHO"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_db_numa
# @DESCRIPTION:
# Applies kernel config flags for the db package with numa support
ot-kernel-pkgflags_db_numa() { # DONE
	if \
		( \
			ot-kernel_has_version_pkgflags "dev-db/mysql" \
				&& \
			ot-kernel_has_version "dev-db/mysql[numa]" \
		) \
			|| \
		( \
			ot-kernel_has_version_pkgflags "dev-db/percona-server" \
				&& \
			ot-kernel_has_version "dev-db/percona-server[numa]" \
		) \
	; then
		ot-kernel_y_configopt "CONFIG_NUMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dbus
# @DESCRIPTION:
# Applies kernel config flags for the dbus package
ot-kernel-pkgflags_dbus() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/dbus" ; then
		# Implied ot-kernel_has_version "sys-apps/dbus[linux_kernel]"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL" # Did not find in scan but ebuild suggested.
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dccutil
# @DESCRIPTION:
# Applies kernel config flags for the dccutil package
ot-kernel-pkgflags_dccutil() { # DONE
	local pkg="app-misc/ddcutil"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		if ot-kernel_has_version "${pkg}[usb-monitor]" ; then
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_HID"
			ot-kernel_y_configopt "CONFIG_HIDRAW"
			ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ddlm
# @DESCRIPTION:
# Applies kernel config flags for the ddlm package
ot-kernel-pkgflags_ddlm() { # DONE
	if ot-kernel_has_version_pkgflags "gui-apps/ddlm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_deepcc
# @DESCRIPTION:
# Applies kernel config flags for the deepcc package
ot-kernel-pkgflags_deepcc() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/deepcc" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_BBR"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_CUBIC"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_ILLINOIS"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_WESTWOOD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dietlibc
# @DESCRIPTION:
# Applies kernel config flags for dietlibc
ot-kernel-pkgflags_dietlibc() { # DONE
	local pkg="dev-libs/dietlibc"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		#_ot-kernel_set_seccomp_bpf "${pkg}" # Referenced but not used.
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss
		# LDT Referenced in dev-libs/dietlibc
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dinit
# @DESCRIPTION:
# Applies kernel config flags for dinit
ot-kernel-pkgflags_dinit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/dinit " ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_UNIX" # For socket(AF_UNIX, ...)
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! scripts
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_DEVPTS_FS" # For /dev/pts
	fi
}

# @FUNCTION: ot-kernel-pkgflags_discord
# @DESCRIPTION:
# Applies kernel config flags for discord
ot-kernel-pkgflags_discord() { # DONE
	# See ot-kernel-pkgflags_cr
	local pkg
	pkg="net-im/discord"
	if ot-kernel_has_version_slow "${pkg}" ; then
# Download link for stable at https://discord.com/download near the top of the page.
		local pv=$(best_version "${pkg}" | sed -e "s|${pkg}-||g")
		local expected_pv="0.0.101" # 20250713
		if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
ewarn
ewarn "Detected older ${pkg} ebuild.  Bump the ebuild manually in local repo or"
ewarn "send an issue request at distro ebuild."
ewarn
ewarn "Actual PV:  ${actual_pv}"
ewarn "Expected PV:  ${expected_pv}"
ewarn
			warn_lowered_security "${pkg}" "Old ebuild with vulnerabilities" "DoS, DT, ID"
		fi
	fi

	pkg="net-im/discord-canary-bin"
	if ot-kernel_has_version "${pkg}" ; then
# The ebuild should be deleted.
# Download link for canary at https://support.discord.com/hc/en-us/articles/360035675191-Discord-Testing-Clients \
# in section "Where can I download these clients?" > "Linux:"
		local pv=$(best_version "${pkg}" | sed -e "s|${pkg}-||g")
		local expected_pv="0.0.717" # 20250713
		if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
ewarn
ewarn "Detected older ${pkg} ebuild.  Bump the ebuild or use distro ebuild"
ewarn "instead."
ewarn
ewarn "Actual PV:  ${actual_pv}"
ewarn "Expected PV:  ${expected_pv}"
ewarn
			warn_lowered_security "${pkg}" "Old ebuild with vulnerabilities" "DoS, DT, ID"
		fi
# May use breakpad so unconditional
		warn_lowered_security "${pkg}" "Breakpad" "Reconnaissance, vulnerability pre attack scan"
	fi

	pkg="net-im/discord-ptb-bin" # Public Test Build
	if ot-kernel_has_version "${pkg}" ; then
# The ebuild should be deleted.
# Download link for PTB at https://ptb.discord.com/ at bottom of the page.
		local actual_pv=$(best_version "${pkg}" | sed -e "s|${pkg}-||g")
		local expected_pv="0.0.152" # 20250713
		if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
ewarn
ewarn "Detected older ${pkg} ebuild.  Bump the ebuild or use distro ebuild"
ewarn "instead."
ewarn
ewarn "Actual PV:  ${actual_pv}"
ewarn "Expected PV:  ${expected_pv}"
ewarn
			warn_lowered_security "${pkg}" "Old ebuild with vulnerabilities"
		fi
# May use breakpad so unconditional
		warn_lowered_security "${pkg}" "Breakpad" "Reconnaissance, vulnerability pre attack scan"
	fi

	pkg="net-im/discord-wayland"
	if ot-kernel_has_version "${pkg}" ; then
# The ebuild should be deleted.
eerror "Detected older ${pkg} ebuild.  Use the distro ebuild instead."
			warn_lowered_security "${pkg}" "Old ebuild with vulnerabilities" "DoS, DT, ID"
		die
	fi
}

# @FUNCTION: ot-kernel-pkgflags_distrobuilder
# @DESCRIPTION:
# Applies kernel config flags for the distrobuilder package
ot-kernel-pkgflags_distrobuilder() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/distrobuilder" ; then
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_drbd_utils
# @DESCRIPTION:
# Applies kernel config flags for the drbd-utils package
ot-kernel-pkgflags_drbd_utils() { # DONE
	if ot-kernel_has_version_pkgflags "sys-cluster/drbd-utils" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DRBD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_droidcam
# @DESCRIPTION:
# Applies kernel config flags for the droidcam package
ot-kernel-pkgflags_droidcam() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/droidcam" ; then
		ot-kernel_y_configopt "CONFIG_SND_ALOOP"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dracut
# @DESCRIPTION:
# Applies kernel config flags for the dracut package
ot-kernel-pkgflags_dracut() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/dracut" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dropwatch
# @DESCRIPTION:
# Applies kernel config flags for the dropwatch package
ot-kernel-pkgflags_dropwatch() { # DONE
	local pkg="dev-util/dropwatch"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ban_disable_debug "${pkg}" "CONFIG_TRACING_SUPPORT, CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_TRACING_SUPPORT"
		ot-kernel_y_configopt "CONFIG_FTRACE"

	# One of CONFIG_KPROBE_EVENTS or CONFIG_UPROBE_EVENTS required to make
	# the CONFIG_NET_DROP_MONITOR option visible.
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_KPROBE_EVENTS"

		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_UPROBE_EVENTS"

		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_NET_DROP_MONITOR"

		ot-kernel_y_configopt "CONFIG_NET_DEVLINK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dvd
# @DESCRIPTION:
# Applies kernel config flags for the DVD packages
ot-kernel-pkgflags_dvd() { #
	[[ "${DVD:-1}" == "1" ]] || return
	# Simplified code without autodetection
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_UDF_FS"
}

# @FUNCTION: ot-kernel-pkgflags_dwarf_therapist
# @DESCRIPTION:
# Applies kernel config flags for the dwarf-therapist package
ot-kernel-pkgflags_dwarf_therapist() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/dwarf-therapist" ; then
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_CROSS_MEMORY_ATTACH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_latencytop
# @DESCRIPTION:
# Applies kernel config flags for the latencytop package
ot-kernel-pkgflags_latencytop() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/latencytop" ; then
		ot-kernel_y_configopt "CONFIG_LATENCYTOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libbpf
# @DESCRIPTION:
# Applies kernel config flags for the libbpf package
ot-kernel-pkgflags_libbpf() { # DONE
	local pkg="dev-libs/libbpf"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcec
# @DESCRIPTION:
# Applies kernel config flags for the libcec package
ot-kernel-pkgflags_libcec() { # DONE
	local pkg="dev-libs/libcec"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_USB_ACM"
		if ot-kernel_has_version "${pkg}[-udev]" ; then
			ot-kernel_y_configopt "CONFIG_SYSFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_docker
# @DESCRIPTION:
# Applies kernel config flags for the docker package
ot-kernel-pkgflags_docker() { # DONE
	local pkg="app-containers/docker"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_posix_mqueue
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		if ver_test "${KV_MAJOR_MINOR}" -lt "6.1" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -le "5.8" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP_ENABLED"
		fi
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_CGROUP"
		if ver_test "${KV_MAJOR_MINOR}" -le "5.2" ; then
			ban_disable_debug "${pkg}" "CONFIG_DEBUG_BLK_CGROUP"
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
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_CGROUP_PERF"
		ot-kernel_unset_configopt "CGROUP_DEBUG" # Same as "Example controller"

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns

		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_THROTTLING"
		if ver_test "${KV_MAJOR_MINOR}" -lt "5.0" ; then
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
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
		ot-kernel_y_configopt "CONFIG_IP_VS"
		ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_TCP"
		ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_UDP"
		ot-kernel_set_configopt "CONFIG_IP_VS_RR" "m"
		ot-kernel_y_configopt "CONFIG_IP_VS_NFCT"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		if ver_test "${KV_MAJOR_MINOR}" -le "5.0" ; then
			ot-kernel_y_configopt "CONFIG_NF_NAT_IPV4"
		fi
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_NETMAP"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REDIRECT"

		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_NET_CLS_CGROUP"
		ot-kernel_y_configopt "CONFIG_NET_L3_MASTER_DEV"
		ot-kernel_y_configopt "CONFIG_CGROUP_NET_PRIO"
		ot-kernel_y_configopt "CONFIG_CGROUP_NET_CLASSID"

		ot-kernel_y_configopt "CONFIG_MD"
		if ot-kernel_has_version_slow "${pkg}[device-mapper]" ; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
			ot-kernel_y_configopt "CONFIG_DM_THIN_PROVISIONING"
		fi
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_set_configopt "CONFIG_DUMMY" "m"
		ot-kernel_set_configopt "CONFIG_MACVLAN" "m"
		ot-kernel_set_configopt "CONFIG_IPVLAN" "m"
		ot-kernel_set_configopt "CONFIG_VXLAN" "m"
		ot-kernel_y_configopt "CONFIG_VETH"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
		ot-kernel_y_configopt "CONFIG_HUGETLBFS"
		ot-kernel_y_configopt "CONFIG_KEYS"
		ot-kernel_y_configopt "CONFIG_PERSISTENT_KEYRINGS"
		ot-kernel_set_configopt "CONFIG_ENCRYPTED_KEYS" "m"
		ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"


		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"

		if ot-kernel_has_version_slow "${pkg}[seccomp]" ; then
	# Referenced in file path but not in code ; requested by ebuild
			_ot-kernel_set_seccomp_bpf "${pkg}"
		fi

		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
#		# _ot-kernel_y_thp # References it but no madvise/fadvise
		# LDT referenced

		if ver_test "${KV_MAJOR_MINOR}" -lt "4.8" ; then
			ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
			ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -le "5.2" ; then
			ot-kernel_y_configopt "CONFIG_NF_NAT_NEEDED"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
			ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
			_ot-kernel_set_seccomp_bpf "${pkg}" # I think the the distro wiki is wrong.
		fi

		if ver_test "${KV_MAJOR_MINOR}" -lt "6.1" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP"
			ot-kernel_y_configopt "CONFIG_MEMCG"
			ot-kernel_y_configopt "CONFIG_SWAP"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -le "5.8" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP_ENABLED"
		fi

		ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NATIVE"

		if ver_test "${KV_MAJOR_MINOR}" -lt "5.19" ; then
			ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE"
		fi

		ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"

		if ver_test "${KV_MAJOR_MINOR}" -le "4.5" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_KMEM"
			ot-kernel_y_configopt "CONFIG_MEMCG"
		fi

		if ot-kernel_has_version_slow "${pkg}[selinux]" ; then
			_OT_KERNEL_LSM_ADD_SELINUX=1
		fi

		if ot-kernel_has_version_slow "${pkg}[apparmor]" ; then
			_OT_KERNEL_LSM_ADD_APPARMOR=1
		fi

		ot-kernel_y_configopt "CONFIG_EXT4_FS"
		ot-kernel_y_configopt "CONFIG_EXT4_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_EXT4_FS_SECURITY"

		ot-kernel_y_configopt "CONFIG_VXLAN"
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SEQIV"
		_ot-kernel-pkgflags_gcm
		ot-kernel_y_configopt "CONFIG_XFRM"
		ot-kernel_y_configopt "CONFIG_XFRM_USER"
		ot-kernel_y_configopt "CONFIG_XFRM_ALGO"
		ot-kernel_y_configopt "CONFIG_INET_ESP"

		if ver_test "${KV_MAJOR_MINOR}" -le "5.3" ; then
			ot-kernel_y_configopt "CONFIG_INET_XFRM_MODE_TRANSPORT"
		fi

		ot-kernel_set_configopt "CONFIG_IPVLAN" "m"

		ot-kernel_set_configopt "CONFIG_MACVLAN" "m"
		ot-kernel_set_configopt "CONFIG_DUMMY" "m"

		ot-kernel_y_configopt "CONFIG_NF_NAT_FTP"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_FTP"
		ot-kernel_y_configopt "CONFIG_NF_NAT_TFTP"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_TFTP"

		#if ot-kernel_has_version_slow "${pkg}[aufs]" ; then
		#	ot-kernel_y_configopt "CONFIG_AUFS_FS"
		#fi

		if ot-kernel_has_version_slow "${pkg}[btrfs]" ; then
			ot-kernel_y_configopt "CONFIG_BTRFS_FS"
			ot-kernel_y_configopt "CONFIG_BTRFS_FS_POSIX_ACL"
		fi

		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_doas
# @DESCRIPTION:
# Applies kernel config flags for the doas package
ot-kernel-pkgflags_doas() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/doas" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dosemu
# @DESCRIPTION:
# Applies kernel config flags for the dosemu package
ot-kernel-pkgflags_dosemu() { # DONE
	local pkg="app-emulation/dosemu"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		warn_lowered_security "${pkg}" "use-after-free with CONFIG_MODIFY_LDT_SYSCALL" "DoS, DT, ID"
		ot-kernel_y_configopt "CONFIG_MODIFY_LDT_SYSCALL"

		_OT_KERNEL_DEV_MEM=1
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dpdk
# @DESCRIPTION:
# Applies kernel config flags for the dpdk package
ot-kernel-pkgflags_dpdk() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/dpdk" ; then
		ot-kernel_y_configopt "CONFIG_UIO"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_PROC_PAGE_MONITOR"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_SYSCTL"
		ot-kernel_y_configopt "CONFIG_HUGETLBFS" # For performance (optional)

		# This should be the responsibility of the dpdk packager.
ewarn
ewarn "Additional setup required for hugetlbfs for net-libs/dpdk for performance.  See"
ewarn "https://doc.dpdk.org/guides/linux_gsg/sys_reqs.html#running-dpdk-applications"
ewarn

		# Optional group
		if ot-kernel_has_acpi_support ; then
			ot-kernel_y_configopt "CONFIG_ACPI"
		fi
		ot-kernel_y_configopt "CONFIG_HPET"
		ot-kernel_y_configopt "CONFIG_HPET_MMAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dpdk_kmod
# @DESCRIPTION:
# Applies kernel config flags for the dpdk-kmod package
ot-kernel-pkgflags_dpdk_kmod() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/dpdk-kmod" ; then
		ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
		ot-kernel_y_configopt "CONFIG_AMD_IOMMU"
		ot-kernel_y_configopt "CONFIG_VFIO"
		ot-kernel_y_configopt "CONFIG_VFIO_PCI"
		ot-kernel_y_configopt "CONFIG_UIO"
		ot-kernel_y_configopt "CONFIG_UIO_PDRV_GENIRQ"
		ot-kernel_y_configopt "CONFIG_UIO_DMEM_GENIRQ"
		ot-kernel_y_configopt "CONFIG_HPET_MMAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_e2fsprogs
# @DESCRIPTION:
# Applies kernel config flags for the e2fsprogs package
ot-kernel-pkgflags_e2fsprogs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/e2fsprogs" ; then
		if [[ "${EXT4_ENCRYPTION:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_EXT4_FS"
			ot-kernel_y_configopt "CONFIG_FS_ENCRYPTION"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ec_access
# @DESCRIPTION:
# Applies kernel config flags for the ec_access package
ot-kernel-pkgflags_ec_access() { # DONE
	local pkg="sys-power/ec_access"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_ACPI_EC_DEBUGFS"
		ot-kernel_y_configopt "CONFIG_ACPI_EC_DEBUGFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ecryptfs
# @DESCRIPTION:
# Applies kernel config flags for the ecryptfs package
ot-kernel-pkgflags_ecryptfs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/ecryptfs-utils" ; then
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_ECRYPT_FS"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eduvpn_common
# @DESCRIPTION:
# Applies kernel config flags for the eduvpn-common package
ot-kernel-pkgflags_eduvpn_common() { # DONE
	local pkg="net-vpn/eduvpn-common"
	if \
		ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[wireguard]" \
	; then
		ot-kernel_y_configopt "CONFIG_WIREGUARD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_efibootmgr
# @DESCRIPTION:
# Applies kernel config flags for the efibootmgr package
ot-kernel-pkgflags_efibootmgr() { # DONE
	if ot-kernel_has_version_pkgflags "sys-boot/efibootmgr" ; then
		ot-kernel_y_configopt "CONFIG_EFI_VARS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ekeyd
# @DESCRIPTION:
# Applies kernel config flags for the ekeyd package
ot-kernel-pkgflags_ekeyd() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/ekeyd" ; then
		ot-kernel_y_configopt "CONFIG_USB_ACM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ell
# @DESCRIPTION:
# Applies kernel config flags for the ell package
ot-kernel-pkgflags_ell() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/ell" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		_ot-kernel-pkgflags_md5
		_ot-kernel-pkgflags_sha1
		ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_elogind
# @DESCRIPTION:
# Applies kernel config flags for the elogind package
ot-kernel-pkgflags_elogind() { # DONE
	if ot-kernel_has_version_pkgflags "sys-auth/elogind" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		_OT_KERNEL_LSM_ADD_SMACK=1 # It is forced enabled.
	fi
}

# @FUNCTION: ot-kernel-pkgflags_emacs
# @DESCRIPTION:
# Applies kernel config flags for the emacs package
ot-kernel-pkgflags_emacs() { # DONE
	if ot-kernel_has_version_pkgflags "app-editors/emacs" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		# ot-kernel_y_configopt "CONFIG_SHMEM" # Referenced but maybe sample file
	fi
}

# @FUNCTION: ot-kernel-pkgflags_embree
# @DESCRIPTION:
# Applies kernel config flags for the embree package
ot-kernel-pkgflags_embree() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/embree" ; then
		_ot-kernel_y_thp # ~5 - ~10% improvement
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ena_driver
# @DESCRIPTION:
# Applies kernel config flags for the ena_driver package
ot-kernel-pkgflags_ena_driver() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/ena-driver" ; then
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
		ot-kernel_unset_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_y_configopt "CONFIG_DIMLIB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_encfs
# @DESCRIPTION:
# Applies kernel config flags for the encfs package
ot-kernel-pkgflags_encfs() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/encfs" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_epoch
# @DESCRIPTION:
# Applies kernel config flags for the epoch package
ot-kernel-pkgflags_epoch() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/epoch" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! scripts
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_DEVPTS_FS" # For /dev/pts
	fi
}

# @FUNCTION: ot-kernel-pkgflags_espeakup
# @DESCRIPTION:
# Applies kernel config flags for the espeakup package
ot-kernel-pkgflags_espeakup() { # DONE
	if ot-kernel_has_version_pkgflags "app-accessibility/espeakup" ; then
		ot-kernel_y_configopt "CONFIG_SPEAKUP"
		ot-kernel_y_configopt "CONFIG_SPEAKUP_SYNTH_SOFT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eudev
# @DESCRIPTION:
# Applies kernel config flags for the eudev package
ot-kernel-pkgflags_eudev() { # DONE
	local pkg="sys-fs/eudev"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		_ot-kernel-pkgflags_disable_ide "${pkg}"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_UNIX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_evdi
# @DESCRIPTION:
# Applies kernel config flags for the evdi package
ot-kernel-pkgflags_evdi() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/evdi" ; then
		ot-kernel_y_configopt "CONFIG_FB_VIRTUAL"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_ARCH_HAS_HCD"
		ot-kernel_y_configopt "CONFIG_MODULES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eventd
# @DESCRIPTION:
# Applies kernel config flags for the eventd package
ot-kernel-pkgflags_eventd() { # DONE
	local pkg="net-misc/eventd"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[ipv6]" \
	; then
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ext4_crypt
# @DESCRIPTION:
# Applies kernel config flags for the ext4-crypt package
ot-kernel-pkgflags_ext4_crypt() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/ext4-crypt" ; then
	        ot-kernel_y_configopt "CONFIG_EXT4_FS"
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.1" ; then
		        ot-kernel_y_configopt "CONFIG_FS_ENCRYPTION"
		elif ver_test "${KV_MAJOR_MINOR}" -le "5.0" ; then
		        ot-kernel_y_configopt "CONFIG_EXT4_ENCRYPTION"
		        ot-kernel_y_configopt "CONFIG_EXT4_FS_ENCRYPTION"
		fi
	        ot-kernel_y_configopt "CONFIG_EXT4_FS_SECURITY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_expanso
# @DESCRIPTION:
# Applies kernel config flags for the expanso package
ot-kernel-pkgflags_expanso() { # DONE
	local pkg="gui-apps/espanso"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[wayland]" ; then
			ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_f2fs_tools
# @DESCRIPTION:
# Applies kernel config flags for the f2fs-tools package
ot-kernel-pkgflags_f2fs_tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/f2fs-tools" ; then
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_F2FS_FS"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_XATTR"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_SECURITY"
	fi
}

FF_PKGS=(
	"www-client/brave-bin"
	"www-client/firefox"
	"www-client/firefox-bin"
	"www-client/torbrowser"
)

# @FUNCTION: ot-kernel-pkgflags_fastd
# @DESCRIPTION:
# Applies kernel config flags for the fastd package
ot-kernel-pkgflags_fastd() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/fastd" ; then
	        _ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_L2TP"
		ot-kernel_y_configopt "CONFIG_L2TP_V3"
		ot-kernel_y_configopt "CONFIG_L2TP_ETH"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_apply_ff_kconfig
# @DESCRIPTION:
# Apply kernel config for ff package
_ot-kernel-pkgflags_apply_ff_kconfig() {
	local pkg="${1}"
	ot-kernel_y_configopt "CONFIG_DNOTIFY"
	ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	ot-kernel_y_configopt "CONFIG_FANOTIFY"

	ot-kernel_y_configopt "CONFIG_SYSVIPC"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
	_ot-kernel_set_seccomp_bpf "${pkg}"
	ot-kernel_y_configopt "CONFIG_EPOLL"
	ot-kernel_y_configopt "CONFIG_EVENTFD"
	ot-kernel_y_configopt "CONFIG_FHANDLE"
	ot-kernel_y_configopt "CONFIG_FUTEX"
	_ot-kernel_set_io_uring
	ot-kernel_y_configopt "CONFIG_MEMBARRIER"
	ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	_ot-kernel_set_shmem
	ot-kernel_y_configopt "CONFIG_SIGNALFD"
	ot-kernel_y_configopt "CONFIG_TIMERFD"

	# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss
}

# @FUNCTION: ot-kernel-pkgflags_ff
# @DESCRIPTION:
# Applies kernel config flags for the ff based packages
ot-kernel-pkgflags_ff() { # DONE
	local pkg
	for pkg in ${FF_PKGS[@]} ; do
		if ot-kernel_has_version_pkgflags_slow "${pkg}" ; then
			_ot-kernel-pkgflags_apply_ff_kconfig "${pkg}"
		fi
	done
}

# @FUNCTION: ot-kernel-pkgflags_ffmpeg
# @DESCRIPTION:
# Applies kernel config flags for the ffmpeg package
ot-kernel-pkgflags_ffmpeg() { # DONE
	local pkg="media-video/ffmpeg"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[X]" \
	; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_finit
# @DESCRIPTION:
# Applies kernel config flags for the finit package
ot-kernel-pkgflags_finit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/finit" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_UNIX" # For socket(AF_UNIX, ...)
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_DEVPTS_FS" # For /dev/pts
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firecracker_bin
# @DESCRIPTION:
# Applies kernel config flags for the firecracker_bin package
ot-kernel-pkgflags_firecracker_bin() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/firecracker-bin" ; then
		ot-kernel-pkgflags_kvm_host_required
		_ot-kernel-pkgflags_tun
		ot-kernel_y_configopt "CONFIG_BRIDGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firehol
# @DESCRIPTION:
# Applies kernel config flags for the firehol package
ot-kernel-pkgflags_firehol() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/firehol" ; then
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REDIRECT"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_HELPER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_LIMIT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_OWNER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NF_NAT_FTP"
		ot-kernel_y_configopt "CONFIG_NF_NAT_IRC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firewalld
# @DESCRIPTION:
# Applies kernel config flags for the firewalld package
ot-kernel-pkgflags_firewalld() { # DONE
	local pkg="net-firewall/firewalld"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
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
		ban_disable_debug "${pkg}" "CONFIG_NFT_LOG" "NETFILTER"
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
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.19" ; then
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_flatpak
# @DESCRIPTION:
# Applies kernel config flags for the flatpak package
ot-kernel-pkgflags_flatpak() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/flatpak" ; then
		_ot-kernel_set_user_ns
		if grep -q -e "config USER_NS_UNPRIVILEGED" "${BUILD_DIR}/init/Kconfig" ; then
			ot-kernel_y_configopt "CONFIG_USER_NS_UNPRIVILEGED"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firejail
# @DESCRIPTION:
# Applies kernel config flags for the firejail package
ot-kernel-pkgflags_firejail() { # DONE
	local pkg="sys-apps/firejail"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_user_ns
		_ot-kernel_set_seccomp_bpf "${pkg}"

		if ot-kernel_has_version "${pkg}[landlock]" ; then
			_OT_KERNEL_LSM_ADD_LANDLOCK=1
		fi
		if ot-kernel_has_version "${pkg}[selinux]" ; then
			_OT_KERNEL_LSM_ADD_SELINUX=1
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_framework_laptop_kmod
# @DESCRIPTION:
# Applies kernel config flags for the framework-laptop-kmod package
ot-kernel-pkgflags_framework_laptop_kmod() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/framework-laptop-kmod" ; then
		ot-kernel_y_configopt "CONFIG_CROS_EC"
		ot-kernel_y_configopt "CONFIG_CROS_EC_LPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_fuse
# @DESCRIPTION:
# Applies kernel config flags for the fuse package
ot-kernel-pkgflags_fuse() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/fuse" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_fwknop
# @DESCRIPTION:
# Applies kernel config flags for the fwknop package
ot-kernel-pkgflags_fwknop() { # DONE
	local pkg="net-firewall/fwknop"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		if ot-kernel_has_version "${pkg}[nfqueue]" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_g15daemon
# @DESCRIPTION:
# Applies kernel config flags for the g15daemon package
ot-kernel-pkgflags_g15daemon() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/g15daemon" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gambas
# @DESCRIPTION:
# Applies kernel config flags for the gambas package
ot-kernel-pkgflags_gambas() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/gambas" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_game_device_udev_rules
# @DESCRIPTION:
# Applies kernel config flags for the game-device-udev-rules package
ot-kernel-pkgflags_game_device_udev_rules() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/game-device-udev-rules" ; then
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gcc
# @DESCRIPTION:
# Applies kernel config flags for the gcc package
ot-kernel-pkgflags_gcc() { # DONE
	if ot-kernel_has_version_pkgflags "sys-devel/gcc" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
		# _ot-kernel_y_thp # Referenced but no noted performance gain/loss
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gdm
# @DESCRIPTION:
# Applies kernel config flags for the gdm package
ot-kernel-pkgflags_gdm() { # DONE
	if ot-kernel_has_version_pkgflags "gnome-base/gdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gerbera
# @DESCRIPTION:
# Applies kernel config flags for the gerbera package
ot-kernel-pkgflags_gerbera() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/gerbera" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ghc
# @DESCRIPTION:
# Applies kernel config flags for the ghc package
ot-kernel-pkgflags_ghc() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/ghc" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glances
# @DESCRIPTION:
# Applies kernel config flags for the glances package
ot-kernel-pkgflags_glances() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/glances" ; then
		ot-kernel_y_configopt "CONFIG_TASK_IO_ACCOUNTING"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glib
# @DESCRIPTION:
# Applies kernel config flags for the glib package
ot-kernel-pkgflags_glib() { # DONE
	local pkg="dev-libs/glib"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		if ot-kernel_has_version "${pkg}[test]" ; then
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
		fi

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glibc
# @DESCRIPTION:
# Applies kernel config flags for the glibc package
ot-kernel-pkgflags_glibc() { # DONE
	if ot-kernel_has_version_pkgflags "sys-libs/glibc" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		# bpf and seccomp-bpf are referenced but not used
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		_ot-kernel_y_thp # 14-18% improvement
		# ldt Referenced in sys-libs/glibc
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gnokii
# @DESCRIPTION:
# Applies kernel config flags for the gnokii package
ot-kernel-pkgflags_gnokii() { # DONE
	if ot-kernel_has_version_pkgflags "app-mobilephone/gnokii" ; then
		ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gnome_boxes
# @DESCRIPTION:
# Applies kernel config flags for the gnome-boxes package
ot-kernel-pkgflags_gnome_boxes() { # DONE
	if ot-kernel_has_version_pkgflags "gnome-extra/gnome-boxes" ; then
		: # See ot-kernel-pkgflags_qemu
	fi
}

# @FUNCTION: ot-kernel-pkgflags_go
# @DESCRIPTION:
# Applies kernel config flags for the go package
ot-kernel-pkgflags_go() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/go" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		# _ot-kernel_y_thp # References it but not used
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gpm
# @DESCRIPTION:
# Applies kernel config flags for the gpm package
ot-kernel-pkgflags_gpm() { # DONE
	if ot-kernel_has_version_pkgflags "sys-libs/gpm" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_greetd
# @DESCRIPTION:
# Applies kernel config flags for the greetd package
ot-kernel-pkgflags_greetd() { # DONE
	if ot-kernel_has_version_pkgflags "gui-libs/greetd" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_grs
# @DESCRIPTION:
# Applies kernel config flags for the grs package
ot-kernel-pkgflags_grs() { # DONE
	if ot-kernel_has_version_pkgflags "app-portage/grs" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gspca_ep800
# @DESCRIPTION:
# Applies kernel config flags for the gspca_ep800 package
ot-kernel-pkgflags_gspca_ep800() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/gspca_ep800" ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gst_plugins_ximagesrc
# @DESCRIPTION:
# Applies kernel config flags for the gst-plugins-ximagesrc package
ot-kernel-pkgflags_gst_plugins_ximagesrc() { # DONE
	if ot-kernel_has_version_pkgflags "media-plugins/gst-plugins-ximagesrc" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gstreamer
# @DESCRIPTION:
# Applies kernel config flags for the gstreamer package
ot-kernel-pkgflags_gstreamer() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/gstreamer" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gtkgreet
# @DESCRIPTION:
# Applies kernel config flags for the gtkgreet package
ot-kernel-pkgflags_gtkgreet() { # DONE
	if ot-kernel_has_version_pkgflags "gui-apps/gtkgreet" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_guilded_bin
# @DESCRIPTION:
# Applies kernel config flags for the guilded-bin package(s)
ot-kernel-pkgflags_guilded_bin() { # DONE
	if ot-kernel_has_version_pkgflags "net-im/guilded-bin" ; then
		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_guestfs
# @DESCRIPTION:
# Applies kernel config flags for the guestfs package(s)
ot-kernel-pkgflags_guestfs() { # DONE
	if \
		   ot-kernel_has_version_pkgflags "app-emulation/libguestfs" \
		|| ot-kernel_has_version_pkgflags "app-emulation/guestfs-tools" \
	; then
		: # See ot-kernel-pkgflags_qemu
		ot-kernel_y_configopt "CONFIG_VIRTIO" # For guest
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gvrpcd
# @DESCRIPTION:
# Applies kernel config flags for the gvrpcd package(s)
ot-kernel-pkgflags_gvrpcd() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/gvrpcd" ; then
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q_GVRP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hamachi
# @DESCRIPTION:
# Applies kernel config flags for hamachi
ot-kernel-pkgflags_hamachi() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/logmein-hamachi" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_haproxy
# @DESCRIPTION:
# Applies kernel config flags for haproxy
ot-kernel-pkgflags_haproxy() { # DONE
	if ot-kernel_has_version_pkgflags "net-proxy/haproxy" ; then
		ot-kernel_y_configopt "CONFIG_NET"

		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hd_idle
# @DESCRIPTION:
# Applies kernel config flags for the hd-idle package
ot-kernel-pkgflags_hd_idle() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/hd-idle" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hdapsd
# @DESCRIPTION:
# Applies kernel config flags for the hdapsd package
ot-kernel-pkgflags_hdapsd() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/hdapsd" ; then
		ot-kernel_y_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hid_nin
# @DESCRIPTION:
# Applies kernel config flags for the hid nin controllers
ot-kernel-pkgflags_hid_nin() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/hid-nintendo" ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GENERIC"
		ot-kernel_y_configopt "CONFIG_USB_HID"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
		ot-kernel_y_configopt "CONFIG_UHID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hbtinit
# @DESCRIPTION:
# Applies kernel config flags for the hbtinit package
ot-kernel-pkgflags_htbinit() { # DONE
	local pkg="net-misc/htbinit"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NET_SCH_HTB"
		ot-kernel_y_configopt "CONFIG_NET_SCH_SFQ"
		ot-kernel_y_configopt "CONFIG_NET_CLS_FW"
		ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
		ot-kernel_y_configopt "CONFIG_NET_CLS_ROUTE4"
		if ot-kernel_has_version "${pkg}[esfq]" ; then
			ot-kernel_y_configopt "CONFIG_NET_SCH_ESFQ"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_htop
# @DESCRIPTION:
# Applies kernel config flags for the htop package
ot-kernel-pkgflags_htop() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/htop" ; then
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_TASK_XACCT"
		ot-kernel_y_configopt "CONFIG_TASK_IO_ACCOUNTING"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hplip
# @DESCRIPTION:
# Applies kernel config flags for the hplip package
ot-kernel-pkgflags_hplip() { # DONE
	local pkg="net-print/hplip"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		# The ebuild pulls in virtual/libusb unconditionally
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
		if ot-kernel_has_version "${pkg}[parport]" ; then
			ot-kernel_y_configopt "CONFIG_PARPORT"
			ot-kernel_y_configopt "CONFIG_PPDEV"
			ot-kernel_y_configopt "CONFIG_PARPORT_1284"
		fi
		if ! ot-kernel_has_version "net-print/cups[zeroconf]" ; then
			# See ot-kernel-pkgflags_avahi
ewarn "Re-emerge net-print/cups[zerconf] and ${PN} for network printing."
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_i2c_tools
# @DESCRIPTION:
# Applies kernel config flags for the i2c-tools package
ot-kernel-pkgflags_i2c_tools() {
	if ot-kernel_has_version_pkgflags "sys-apps/i2c-tools" ; then
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		ot-kernel_y_configopt "CONFIG_I2C_HELPER_AUTO"

		local O=$(grep -E -e "config I2C_.*" $(find drivers/i2c/busses -name "Kconfig*") \
				| cut -f 2 -d ":" \
				| sed -e "s|config ||g" \
				| sed -e "s|^|CONFIG_|g")
		local found=0
		local o
		for o in ${O[@]} ; do
			if grep -q -e "^${o}=" "${path_config}" ; then
				found=1
				break
			fi
		done
		if (( ${found} == 0 )) ; then
ewarn "You may need to have at least one CONFIG_I2C_... for i2c-tools."
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_i8kutils
# @DESCRIPTION:
# Applies kernel config flags for the i8kutils package
ot-kernel-pkgflags_i8kutils() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/i8kutils" ; then
		ot-kernel_y_configopt "CONFIG_I8K"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ifenslave
# @DESCRIPTION:
# Applies kernel config flags for the ifenslave package
ot-kernel-pkgflags_ifenslave() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/ifenslave" ; then
		ot-kernel_y_configopt "CONFIG_BONDING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwlmvm
# @DESCRIPTION:
# Applies kernel config flags for the iwlmvm package
ot-kernel-pkgflags_iwlmvm() { # DONE
	if \
		   ot-kernel_has_version_pkgflags "sys-firmware/iwl3160-7260-bt-ucode" \
		|| ot-kernel_has_version_pkgflags "sys-firmware/iwl7260-ucode" \
		|| ot-kernel_has_version_pkgflags "sys-firmware/iwl8000-ucode" \
		|| ot-kernel_has_version_pkgflags "sys-firmware/iwl3160-ucode" \
	; then
		ot-kernel_y_configopt "CONFIG_IWLMVM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_igmpproxy
# @DESCRIPTION:
# Applies kernel config flags for the igmpproxy package
ot-kernel-pkgflags_igmpproxy() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/igmpproxy" ; then
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ima_evm_utils
# @DESCRIPTION:
ot-kernel-pkgflags_ima_evm_utils() {
	if ot-kernel_has_version_pkgflags "app-crypt/ima-evm-utils" ; then
		if [[ "${EVM:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_KEYS"
			ot-kernel_y_configopt "CONFIG_TRUSTED_KEYS"
			ot-kernel_y_configopt "CONFIG_ENCRYPTED_KEYS"
			ot-kernel_y_configopt "CONFIG_SECURITY"
			ot-kernel_y_configopt "CONFIG_INTEGRITY"
			ot-kernel_y_configopt "CONFIG_INTEGRITY_SIGNATURE"
			ot-kernel_y_configopt "CONFIG_EVM"
			if \
				   ot-kernel_has_version "dev-crypt/tpm-utils" \
				|| ot-kernel_has_version "app-crypt/tpm-tools" \
				|| ot-kernel_has_version "app-crypt/tpm2-tools" \
				|| [[ "${TPM:-0}" == "1" ]] \
			; then
				ot-kernel_y_configopt "CONFIG_TCG_TPM"
			fi
		fi
		if [[ "${IMA:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_SECURITY"
			ot-kernel_y_configopt "CONFIG_INTEGRITY"
			ot-kernel_y_configopt "CONFIG_IMA"
			ot-kernel_set_configopt "CONFIG_IMA_MEASURE_PCR_IDX" "10"
			ot-kernel_y_configopt "CONFIG_IMA_LSM_RULES"
			ot-kernel_y_configopt "CONFIG_INTEGRITY_SIGNATURE"
			ot-kernel_y_configopt "CONFIG_IMA_APPRAISE"
			ot-kernel_y_configopt "CONFIG_IMA_APPRAISE_BOOTPARAM"
			# TODO:  add kernel command line
ewarn "You still need to set the kernel command line for IMA"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_inception
# @DESCRIPTION:
# Applies kernel config flags for the inception package
ot-kernel-pkgflags_inception() { # DONE
	if ot-kernel_has_version_pkgflags "app-forensics/inception" ; then
		ot-kernel_y_configopt "CONFIG_FIREWIRE_OHCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_incron
# @DESCRIPTION:
# Applies kernel config flags for the incron package
ot-kernel-pkgflags_incron() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/incron" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_installkernel
# @DESCRIPTION:
# Applies kernel config flags for the installkernel package
ot-kernel-pkgflags_installkernel() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/installkernel" ; then
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_y_configopt "CONFIG_EFI_STUB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_incus
# @DESCRIPTION:
# Applies kernel config flags for the incus package
ot-kernel-pkgflags_incus() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/incus" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns
		ot-kernel-pkgflags_kvm_host_required
		ot-kernel_y_configopt "CONFIG_MACVTAP"
		ot-kernel_y_configopt "CONFIG_VHOST_VSOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iucode
# @DESCRIPTION:
# Applies kernel config flags for the intel-microcode package
ot-kernel-pkgflags_iucode() {
	if ot-kernel_has_version_pkgflags "sys-firmware/intel-microcode" ; then
		if [[ "${OT_KERNEL_CPU_MICROCODE}" == "1" || -e "${OT_KERNEL_CPU_MICROCODE}" ]] ; then

			unset bucket
			declare -A bucket

			local args
			if [[ -n "${MICROCODE_SIGNATURES}" || -n "${MICROCODE_BLACKLIST}" ]] ; then
				args=(
					${MICROCODE_SIGNATURES}
					${MICROCODE_BLACKLIST}
				)
			else
				args=(
					--scan-system=exact
				)
			fi

			if ! which iucode_tool >/dev/null 2>&1 ; then
ewarn "Missing iucode_tool"
			elif iucode_tool ${args[@]} -l "/lib/firmware/intel-ucode/"* ; then
				local signatures=( \
					$(iucode_tool ${args[@]} -l "/lib/firmware/intel-ucode/"* \
						| grep -o -E -e "0x[0-9a-f]+") \
				)
				for signature in ${signatures[@]} ; do
					#    ee     # initials hi
					#    fm fms # initials lo
					#0123456789 # bash string index
					#0x000306c3 # processor signature
					local ef="${signature:4:1}"
					local f="${signature:7:1}"
					local em="${signature:5:1}"
					local m="${signature:8:1}"
					local s="${signature:9:1}"
					local fn="${ef}${f}-${em}${m}-${s}"
					if ! [[ -e "/lib/firmware/intel-ucode/${fn}" ]] ; then
eerror "/lib/firmware/intel-ucode/${fn} is missing"
					fi
					bucket["${fn}"]="intel-ucode/${fn}"
				done
				if (( ${#signatures[@]} == 0 )) ; then
ewarn "Found no CPU signatures"
				fi
			else
ewarn "Problem encountered with the iucode_tool."
				return
			fi

			if [[ -n "${bucket[@]}" ]] ; then
				local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
				firmware=$(echo "${firmware}" \
					| tr " " "\n" \
					| sed -r -e 's|intel-ucode/.*$||g' \
					| tr "\n" " ") # dedupe
				firmware="${firmware} ${bucket[@]}" # Dump microcode relpaths
				firmware=$(echo "${firmware}" \
					| sed -r \
						-e "s|[ ]+| |g" \
						-e "s|^[ ]+||g" \
						-e 's|[ ]+$||g') # Trim mid/left/right spaces
				ot-kernel_y_configopt "CONFIG_MICROCODE"
				ot-kernel_y_configopt "CONFIG_MICROCODE_INTEL"
				ot-kernel_y_configopt "CONFIG_EXPERT"
				ot-kernel_y_configopt "CONFIG_FW_LOADER"
				if [[ "${arch}" == "x86_64" ]] ; then
					# Embed in kernel for EFI
					ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
					local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"
				else
ewarn "The CPU microcode needs to be loaded through initramfs instead."
				fi
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_livecd_tools
# @DESCRIPTION:
# Applies kernel config flags for the livecd-tools package
ot-kernel-pkgflags_livecd_tools() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/livecd-tools" ; then
		ot-kernel_y_configopt "CONFIG_SND_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lkrg
# @DESCRIPTION:
# Applies kernel config flags for the lkrg package
ot-kernel-pkgflags_lkrg() { # DONE
	local pkg="app-antivirus/lkrg"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_HAVE_KRETPROBES"
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_JUMP_LABEL"
		ot-kernel_y_configopt "CONFIG_MODULE_UNLOAD"
		local pkgid=$(echo -n "${pkg}" | sha512sum | cut -f 1 -d " " | cut -c 1-7)
ewarn
ewarn "Cannot use PREEMPT_RCU OR PREEMPT* with ${pkg}."
ewarn "Disabling PREEMPT* and disabling PREEMPT_RT."
ewarn
ewarn "If you need to use PREEMPT_RT, add OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1"
ewarn
		ot-kernel_set_preempt "CONFIG_PREEMPT_NONE"
		ban_disable_debug "${pkg}" "CONFIG_STACKTRACE"
		ot-kernel_y_configopt "CONFIG_STACKTRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_llvm
# @DESCRIPTION:
# Applies kernel config flags for the llvm package
ot-kernel-pkgflags_llvm() { # DONE
	local pkg="llvm-core/llvm"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}" # Uses syscall with number
		if ot-kernel_has_version "${pkg}[bolt]" ; then
			_ot-kernel_y_thp # for bolt --hugify
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lksctp_tools
# @DESCRIPTION:
# Applies kernel config flags for the lksctp-tools package
ot-kernel-pkgflags_lksctp_tools() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/lksctp-tools" ; then
		ot-kernel_y_configopt "CONFIG_IP_SCTP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iodine
# @DESCRIPTION:
# Applies kernel config flags for the iodine package
ot-kernel-pkgflags_iodine() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/iodine" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipcm
# @DESCRIPTION:
# Applies kernel config flags for ipcm
ot-kernel-pkgflags_ipcm() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/intel-performance-counter-monitor" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iproute2
# @DESCRIPTION:
# Applies kernel config flags for the iproute2 package
ot-kernel-pkgflags_iproute2() {
	if ot-kernel_has_version_pkgflags "sys-apps/iproute2" ; then  # For tc QoS
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NET_INET"
		ot-kernel_y_configopt "CONFIG_IP_ADVANCED_ROUTER"
		ot-kernel_y_configopt "CONFIG_SYN_COOKIES"
		ot-kernel_set_configopt "CONFIG_IPV6" "m"
	        _ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_INET_DIAG"
		ot-kernel_set_configopt "CONFIG_INET_UDP_DIAG" "m"
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
		ot-kernel_y_configopt "CONFIG_NET_CLS_ACT"
		ot-kernel_set_configopt "CONFIG_NET_SCH_INGRESS" "m"
		ot-kernel_set_configopt "CONFIG_NET_SCH_HTB" "m"
		ot-kernel_set_configopt "CONFIG_NET_SCH_CODEL" "m"
		ot-kernel_set_configopt "CONFIG_NET_CLS_U32" "m"
		ot-kernel_y_configopt "CONFIG_NET_ACT_MIRRED"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_set_configopt "CONFIG_IFB" "m"

		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipset
# @DESCRIPTION:
# Applies kernel config flags for the ipset package
ot-kernel-pkgflags_ipset() { # DONE
	local pkg="net-firewall/ipset"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_unset_configopt "CONFIG_PAX_CONSTIFY_PLUGIN" # old
		if ot-kernel_has_version "${pkg}[modules]" ; then
			ot-kernel_unset_configopt "CONFIG_IP_NF_SET"
			ot-kernel_unset_configopt "CONFIG_IP_SET"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipt_netflow
# @DESCRIPTION:
# Applies kernel config flags for the ipt-netflow package
ot-kernel-pkgflags_ipt_netflow() { # DONE
	local pkg="net-firewall/ipt_netflow"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
		if ot-kernel_has_version "${pkg}[debug]" ; then
			ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS"
			needs_debugfs
			ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		fi
		if ot-kernel_has_version "${pkg}[natevents]" ; then
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_EVENTS"
			if ver_test "${KV_MAJOR_MINOR}" -lt "5.2" ; then
				ot-kernel_y_configopt "CONFIG_NF_NAT_NEEDED"
			else
				ot-kernel_y_configopt "CONFIG_NF_NAT"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iptables
# @DESCRIPTION:
# Applies kernel config flags for the iptables package
ot-kernel-pkgflags_iptables() { # MOSTLY DONE
	local pkg="net-firewall/iptables"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		IPTABLES_CLIENT="${IPTABLES_CLIENT:-1}"
		if [[ "${IPTABLES_CLIENT}" == "1" ]] ; then # DONE
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_NET_IPVTI"
			if ver_test "${KV_MAJOR_MINOR}" -le "5.1" ; then
				ot-kernel_y_configopt "CONFIG_INET_XFRM_MODE_TRANSPORT"
				ot-kernel_y_configopt "CONFIG_INET_XFRM_MODE_TUNNEL"
			fi
			ot-kernel_y_configopt "CONFIG_INET_DIAG"
			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ban_disable_debug "${pkg}" "CONFIG_NETFILTER_NETLINK_LOG" "NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
			if ver_test "${KV_MAJOR_MINOR}" -le "4.18" ; then
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
		IPTABLES_ROUTER="${IPTABLES_ROUTER:-0}"
		if [[ "${IPTABLES_ROUTER}" == "1" ]] ; then # MAYBE DONE
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_set_configopt "CONFIG_INET_AH" "m"
			ot-kernel_set_configopt "CONFIG_INET_ESP" "m"
			ot-kernel_set_configopt "CONFIG_INET_IPCOMP" "m"

			if ver_test "${KV_MAJOR_MINOR}" -le "4.5" ; then
				ot-kernel_y_configopt "CONFIG_INET_LRO"
			fi

			if ver_test "${KV_MAJOR_MINOR}" -le "5.1" ; then
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_TRANSPORT" "m"
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_TUNNEL" "m"
				ot-kernel_set_configopt "CONFIG_INET_XFRM_MODE_BEET" "m"
			fi

			ot-kernel_y_configopt "CONFIG_INET_DIAG"
			ot-kernel_set_configopt "CONFIG_INET_UDP_DIAG" "m"

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
			ban_disable_debug "${pkg}" "CONFIG_NETFILTER_NETLINK_LOG" "NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"

			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFLOG"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"

			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNBYTES"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNMARK"

			ot-kernel_set_configopt "CONFIG_BRIDGE_NF_EBTABLES" "m"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iotop
# @DESCRIPTION:
# Applies kernel config flags for the iotop package
ot-kernel-pkgflags_iotop() { # DONE
	if \
		   ot-kernel_has_version_pkgflags_slow "sys-process/iotop" \
		|| ot-kernel_has_version_pkgflags "sys-process/iotop-c" \
	; then
		ot-kernel_y_configopt "CONFIG_TASK_IO_ACCOUNTING"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_VM_EVENT_COUNTERS"
		ot-kernel_set_kconfig_kernel_cmdline "delayacct"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_irqbalance
# @DESCRIPTION:
# Applies kernel config flags for the irqbalance package
ot-kernel-pkgflags_irqbalance() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/irqbalance" ; then
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_isatapd
# @DESCRIPTION:
# Applies kernel config flags for the isatapd package
ot-kernel-pkgflags_isatapd() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/isatapd" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jack_audio_connection_kit
# @DESCRIPTION:
# Applies kernel config flags for the jack-audio-connection-kit package
ot-kernel-pkgflags_jack_audio_connection_kit() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/jack-audio-connection-kit" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jack2
# @DESCRIPTION:
# Applies kernel config flags for the jack2 package
ot-kernel-pkgflags_jack2() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/jack2" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jemalloc
# @DESCRIPTION:
# Applies kernel config flags for the jemalloc package
ot-kernel-pkgflags_jemalloc() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/jemalloc" ; then
	# Missing kernel config checks in distro ebuild.
		_ot-kernel_y_thp # Supported but not on by default.
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS" # For madvise()
	fi
}

# @FUNCTION: ot-kernel-pkgflags_joycond
# @DESCRIPTION:
# Applies kernel config flags for the joycond package
ot-kernel-pkgflags_joycond() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/joycond" ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_NINTENDO"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_k3s
# @DESCRIPTION:
# Applies kernel config flags for the k3s package
ot-kernel-pkgflags_k3s() { # DONE
	if ot-kernel_has_version_pkgflags "sys-cluster/k3s" ; then
		ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
		ot-kernel_y_configopt "CONFIG_CFS_BANDWIDTH"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_CGROUP_PERF"
		ot-kernel_y_configopt "CONFIG_CGROUP_PIDS"
		ot-kernel_y_configopt "CONFIG_IP_VS"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
		ot-kernel_y_configopt "CONFIG_VXLAN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iscan_plugin
# @DESCRIPTION:
# Applies kernel config flags for the iscan-plugin package
ot-kernel-pkgflags_iscan_plugin() { # DONE
	if ot-kernel_has_version_pkgflags "media-gfx/iscan-plugin-network-nt" ; then
		ot-kernel_y_configopt "CONFIG_SYN_COOKIES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwd
# @DESCRIPTION:
# Applies kernel config flags for the iwd package
ot-kernel-pkgflags_iwd() { # DONE
	local pkg="net-wireless/iwd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_KEYS"
		ot-kernel_y_configopt "CONFIG_ASYMMETRIC_KEY_TYPE"
		ot-kernel_y_configopt "CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE"
		ot-kernel_y_configopt "CONFIG_CFG80211"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		_ot-kernel-pkgflags_aes CBC CTR ECB
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ECB"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CTR"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_DH"
		_ot-kernel-pkgflags_des CBC CTR ECB
		_ot-kernel-pkgflags_des3_ede CBC CTR ECB
		ot-kernel_y_configopt "CONFIG_CRYPTO_ECB"
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MD4"
		_ot-kernel-pkgflags_md5
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
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_WIRELESS"
		ot-kernel_set_configopt "CONFIG_CFG80211" "m"
		ot-kernel_y_configopt "CONFIG_X509_CERTIFICATE_PARSER"
		ot-kernel_y_configopt "CONFIG_PKCS7_MESSAGE_PARSER"
		ot-kernel_set_configopt "CONFIG_PKCS8_PRIVATE_KEY_PARSER" "m"

		if ot-kernel_has_version "${pkg}[crda]" ; then
			: # See ot-kernel-pkgflags_crda
			ot-kernel_has_version "net-wireless/crda" || die "Install net-wireless/crda first"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.20" ; then
			# Implied ot-kernel_has_version "${pkg}[linux_kernel]"
			ot-kernel_y_configopt "CONFIG_PKCS8_PRIVATE_KEY_PARSER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kexec_tools
# @DESCRIPTION:
# Applies kernel config flags for the kexec-tools package
ot-kernel-pkgflags_kexec_tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/kexec-tools" ; then
		OT_KERNEL_SIGN="${OT_KERNEL_SIGN_KERNEL:-0}" # signing the kernel is not ready yet
		if [[ "${OT_KERNEL_SIGN_KERNEL}" =~ ("uefi"|"efi"|"kexec") && -n "${OT_KERNEL_PRIVATE_KEY}" && -n "${OT_KERNEL_PUBLIC_KEY}" ]] ; then
			[[ -e "${OT_KERNEL_PRIVATE_KEY}" ]] || die "Missing private key for kexec signing"
			[[ -e "${OT_KERNEL_PUBLIC_KEY}" ]] || die "Missing public key for kexec signing"
			ot-kernel_y_configopt "CONFIG_KEXEC_FILE"
			if ver_test "${KV_MAJOR_MINOR}" -lt "5" ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO"
				_ot-kernel-pkgflags_sha256
			fi
			if ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
				ot-kernel_y_configopt "CONFIG_KEXEC_SIG"
				ot-kernel_y_configopt "CONFIG_KEXEC_SIG_FORCE"
			else
				ot-kernel_y_configopt "CONFIG_VERIFY_SIG"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_KEXEC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_keyutils
# @DESCRIPTION:
# Applies kernel config flags for the keyutils package
ot-kernel-pkgflags_keyutils() { # DONE
	local pkg="sys-apps/keyutils"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_KEYS"
		if \
			   ot-kernel_has_version "${pkg}[test]" \
			&& ver_test "${MY_PV}" -ge "2.6.10" \
			&& ver_test "${KV_MAJOR_MINOR}" -lt "4.0" \
		; then
			ban_disable_debug "${pkg}" "CONFIG_KEYS_DEBUG_PROC_KEYS"
			ot-kernel_y_configopt "CONFIG_KEYS_DEBUG_PROC_KEYS"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.7" ; then
			ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kio_fuse
# @DESCRIPTION:
# Applies kernel config flags for the kio-fuse package
ot-kernel-pkgflags_kio_fuse() { # DONE
	if ot-kernel_has_version_pkgflags "kde-misc/kio-fuse" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kloak
# @DESCRIPTION:
# Applies kernel config flags for the kloak package
ot-kernel-pkgflags_kloak() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/kloak" ; then
		ot-kernel_y_configopt "CONFIG_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kloak
# @DESCRIPTION:
# Applies kernel config flags for the kloak package
ot-kernel-pkgflags_kloak() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/kloak" ; then
		ot-kernel_y_configopt "CONFIG_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_knem
# @DESCRIPTION:
# Applies kernel config flags for the knem package
ot-kernel-pkgflags_knem() { # DONE
	if ot-kernel_has_version_pkgflags "sys-cluster/knem" ; then
		ot-kernel_y_configopt "CONFIG_DMA_ENGINE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kodi
# @DESCRIPTION:
# Applies kernel config flags for the kodi package
ot-kernel-pkgflags_kodi() { # DONE
	if ot-kernel_has_version_pkgflags "media-tv/kodi" ; then
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kpatch
# @DESCRIPTION:
# Applies kernel config flags for the kpatch package
ot-kernel-pkgflags_kpatch() { # DONE
	local pkg="sys-kernel/kpatch"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_FUNCTION_TRACER, CONFIG_DEBUG_KERNEL"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_HAVE_FENTRY"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ksmbd_tools
# @DESCRIPTION:
# Applies kernel config flags for the ksmbd-tools package
ot-kernel-pkgflags_ksmbd_tools() { # DONE
	if ot-kernel_has_version_pkgflags "net-fs/ksmbd-tools" ; then
		ot-kernel_y_configopt "CONFIG_SMB_SERVER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcgroup
# @DESCRIPTION:
# Applies kernel config flags for the libcgroup package
ot-kernel-pkgflags_libcgroup() { # DONE
	local pkg="dev-libs/libcgroup"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		if ot-kernel_has_version "${pkg}[daemon]" ; then
			ot-kernel_y_configopt "CONFIG_CONNECTOR"
			ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcxx
# @DESCRIPTION:
# Applies kernel config flags for the libcxx package
ot-kernel-pkgflags_libcxx() { # DONE
	if ot-kernel_has_version_pkgflags "llvm-runtimes/libcxx" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcxxabi
# @DESCRIPTION:
# Applies kernel config flags for the libcxxabi package
ot-kernel-pkgflags_libcxxabi() { # DONE
	if ot-kernel_has_version_pkgflags "llvm-runtimes/libcxxabi" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libdex
# @DESCRIPTION:
# Applies kernel config flags for the libdex package
ot-kernel-pkgflags_libdex() { # DONE
	local pkg="dev-libs/libdex"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[eventfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_EVENTFD"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libfido2
# @DESCRIPTION:
# Applies kernel config flags for the libfido2 package
ot-kernel-pkgflags_libfido2() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/libfido2" ; then
		ot-kernel_y_configopt "CONFIG_USB_HID"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libforensic1394
# @DESCRIPTION:
# Applies kernel config flags for the libforensic1394 package
ot-kernel-pkgflags_libforensic1394() { # DONE
	if ot-kernel_has_version_pkgflags "app-forensics/libforensic1394" ; then
		ot-kernel_y_configopt "CONFIG_FIREWIRE_OHCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libgpiod
# @DESCRIPTION:
# Applies kernel config flags for the libgpiod package
ot-kernel-pkgflags_libgpiod() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/libgpiod" ; then
		ot-kernel_y_configopt "CONFIG_GPIO_CDEV_V1"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_liblinear
# @DESCRIPTION:
# Applies kernel config flags for the liblinear package
ot-kernel-pkgflags_liblinear() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/liblinear" ; then
		_ot-kernel_y_thp # Added for performance reasons.  ~36-39% benefit
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libmicrohttpd
# @DESCRIPTION:
# Applies kernel config flags for the libmicrohttpd package
ot-kernel-pkgflags_libmicrohttpd() { # DONE
	local pkg="net-libs/libmicrohttpd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[epoll]" ; then
			ot-kernel_y_configopt "CONFIG_EPOLL"
		fi
		if ot-kernel_has_version "${pkg}[eventfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_EVENTFD"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libmtp
# @DESCRIPTION:
# Applies kernel config flags for the libmtp package
ot-kernel-pkgflags_libmtp() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/libmtp" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_apfs_rw
# @DESCRIPTION:
# Applies kernel config flags for the linux-apfs-rw package
ot-kernel-pkgflags_linux_apfs_rw() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/linux-apfs-rw" ; then
		ot-kernel_y_configopt "CONFIG_LIBCRC32C"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_atm
# @DESCRIPTION:
# Applies kernel config flags for the linux-atm package
ot-kernel-pkgflags_linux_atm() { # DONE
	if ot-kernel_has_version_pkgflags "net-dialup/linux-atm" ; then
		ot-kernel_y_configopt "CONFIG_ATM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_enable_ir_emitter
# @DESCRIPTION:
# Applies kernel config flags for the linux-enable-ir-emitter package
ot-kernel-pkgflags_linux_enable_ir_emitter() {
	if ot-kernel_has_version_pkgflags "media-video/linux-enable-ir-emitter" ; then
		# Assumes udev, ^^ ( openrc systemd ) kernel config has been already applied.
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_firmware
# @DESCRIPTION:
# Applies kernel config flags for the linux-firmware package
ot-kernel-pkgflags_linux_firmware() {
	if ot-kernel_has_version_pkgflags "sys-kernel/linux-firmware" ; then
		if [[ "${OT_KERNEL_CPU_MICROCODE}" == "1" || -e "${OT_KERNEL_CPU_MICROCODE}" ]] ; then
			unset bucket
			declare -A bucket
			IFS=";"
			local path
			if [[ -e "${OT_KERNEL_CPU_MICROCODE}" ]] ; then
				path="${OT_KERNEL_CPU_MICROCODE}"
			else
				path="/proc/cpuinfo"
				if tc-is-cross-compiler ; then
eerror
eerror "You must set OT_KERNEL_CPU_MICROCODE.  See metadata.xml"
eerror "(or \`epkginfo -x ${PN}::oiledmachine-overlay\`) for details."
eerror
					die
				fi
			fi
			local o
			for o in $(cat "${path}" | sed -e "s|^$|;|") ; do
				# Support multiple sockets / NUMA
				echo "${o}" \
					| grep -q -e "AuthenticAMD" \
					|| continue
				local cpu_family=$(echo "${o}" \
					| grep "cpu family" \
					| grep -o -E -e "[0-9]+")
				local cpu_model_name=$(echo "${o}" \
					| grep "model name" \
					| cut -f 2 -d ":" \
					| sed -e "s|^ ||g")
				  if [[ "${cpu_family}" =~ ("16"|"17"|"18"|"20") ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd.bin"
				elif [[ "${cpu_family}" =~ "21" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam15h.bin"
				elif [[ "${cpu_family}" =~ "22" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam16h.bin"
				elif [[ "${cpu_family}" =~ "23" && "${cpu_model_name}" =~ "zen" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam17h.bin"
				elif [[ "${cpu_family}" =~ "23" && "${cpu_model_name}" =~ "EPYC 7".."1" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam17h_model0xh.sbin"
				elif [[ "${cpu_family}" =~ "23" && "${cpu_model_name}" =~ "EPYC 7".."2" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam17h_model3xh.sbin"
				elif [[ "${cpu_family}" =~ "25" && "${cpu_model_name}" =~ "zen" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam19h.bin"
				elif [[ "${cpu_family}" =~ "25" && "${cpu_model_name}" =~ "EPYC 7".."3" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam19h_model0xh.sbin"
				fi
			done
			IFS=$' \t\n'
			if [[ -n "${bucket[@]}" ]] ; then
				local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" \
					| head -n 1 \
					| cut -f 2 -d "\"" \
				)
				firmware=$(echo "${firmware}" \
					| tr " " "\n" \
					| sed -r \
						-e 's|amd-ucode/microcode.*$||g' \
						-e 's|amd/amd_sev_fam..h_model.xh.sbin$||g' \
					| tr "\n" " " \
				) # dedupe
				firmware="${firmware} ${bucket[@]}" # Dump microcode relpaths
				firmware=$(echo "${firmware}" \
					| sed -r \
						-e "s|[ ]+| |g" \
						-e "s|^[ ]+||g" \
						-e 's|[ ]+$||g' \
				) # Trim mid/left/right spaces
				ot-kernel_y_configopt "CONFIG_MICROCODE"
				ot-kernel_y_configopt "CONFIG_MICROCODE_AMD"
				ot-kernel_y_configopt "CONFIG_EXPERT"
				ot-kernel_y_configopt "CONFIG_FW_LOADER"
				if [[ "${arch}" == "x86_64" ]] ; then
					# Embed in kernel for EFI
					ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
					local firmware=$(grep \
						-e "CONFIG_EXTRA_FIRMWARE" \
						".config" \
						| head -n 1 \
						| cut -f 2 -d "\"" \
					)
einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"
				else
ewarn "The CPU microcode needs to be loaded through initramfs instead."
				fi
			fi
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FW_LOADER"
		ot-kernel_y_configopt "CONFIG_FW_LOADER_COMPRESS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linuxptp
# @DESCRIPTION:
# Applies kernel config flags for the linuxptp package
ot-kernel-pkgflags_linuxptp() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/linuxptp" ; then
		ot-kernel_y_configopt "CONFIG_PPS"
		ot-kernel_y_configopt "CONFIG_NETWORK_PHY_TIMESTAMPING"
		ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnftnl
# @DESCRIPTION:
# Applies kernel config flags for the libnftnl package
ot-kernel-pkgflags_libnftnl() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnftnl" ; then
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnfnetlink
# @DESCRIPTION:
# Applies kernel config flags for the libnfnetlink package
ot-kernel-pkgflags_libnfnetlink() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnfnetlink" ; then
		if ver_test "${MY_PV}" -lt "2.6.20" ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_acct
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_acct package
ot-kernel-pkgflags_libnetfilter_acct() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnetfilter_acct" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_cthelper
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_cthelper package
ot-kernel-pkgflags_libnetfilter_cthelper() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnetfilter_cthelper" ; then
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_HELPER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_conntrack package
ot-kernel-pkgflags_libnetfilter_conntrack() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnetfilter_conntrack" ; then
		if ver_test "${MY_PV}" -lt "2.6.20" ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_cttimeout
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_cttimeout package
ot-kernel-pkgflags_libnetfilter_cttimeout() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnetfilter_cttimeout" ; then
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_TIMEOUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_log
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_log package
ot-kernel-pkgflags_libnetfilter_log() { # DONE
	local pkg="net-libs/libnetfilter_log"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_NETFILTER_NETLINK_LOG" "NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_queue
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_queue package
ot-kernel-pkgflags_libnetfilter_queue() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/libnetfilter_queue" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libomp
# @DESCRIPTION:
# Applies kernel config flags for the libomp package
ot-kernel-pkgflags_libomp() { # DONE
	if ot-kernel_has_version_pkgflags "llvm-runtimes/openmp" ; then
		if [[ "${cpu_sched}" =~ ("pds"|"prjc-pds") ]] ; then
ewarn
ewarn "Detected use of the PDS scheduler."
ewarn "If performance degradion is unacceptable, disable the PDS scheduler."
ewarn
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libpulse
# @DESCRIPTION:
# Applies kernel config flags for the libpulse package
ot-kernel-pkgflags_libpulse() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/libpulse" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libseccomp
# @DESCRIPTION:
# Applies kernel config flags for the libseccomp package
ot-kernel-pkgflags_libseccomp() { # DONE
	local pkg="sys-libs/libseccomp"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
	# This was not checked in the distro's ebuild.
		_ot-kernel_set_seccomp_bpf "${pkg}"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libsdl2
# @DESCRIPTION:
# Applies kernel config flags for the libsdl2 package
ot-kernel-pkgflags_libsdl2() { # DONE
	if \
		   ot-kernel_has_version_pkgflags "media-libs/libsdl2" \
		|| ot-kernel_has_version_pkgflags "dev-libs/hidapi" \
	; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HIDRAW"

		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libteam
# @DESCRIPTION:
# Applies kernel config flags for the libteam package
ot-kernel-pkgflags_libteam() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/libteam" ; then
		ot-kernel_y_configopt "CONFIG_NET_TEAM"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_ROUNDROBIN"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_ACTIVEBACKUP"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_BROADCAST"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_RANDOM"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_LOADBALANCE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libu2f_host
# @DESCRIPTION:
# Applies kernel config flags for the libu2f-host package
ot-kernel-pkgflags_libu2f_host() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/libu2f-host" ; then
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libugpio
# @DESCRIPTION:
# Applies kernel config flags for the libugpio package
ot-kernel-pkgflags_libugpio() { # DONE
	if ot-kernel_has_version_pkgflags "dev-libs/libugpio" ; then
		ot-kernel_y_configopt "CONFIG_GPIO_SYSFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libv4l
# @DESCRIPTION:
# Applies kernel config flags for the libv4l package
ot-kernel-pkgflags_libv4l() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/libv4l" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libvirt
# @DESCRIPTION:
# Applies kernel config flags for the libvirt package
ot-kernel-pkgflags_libvirt() { # DONE
	local pkg="app-emulation/libvirt"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[fuse]" ; then
			ot-kernel_y_configopt "CONFIG_FUSE_FS"
		fi

		if ot-kernel_has_version "${pkg}[lvm]" ; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
			ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
			ot-kernel_y_configopt "CONFIG_DM_SNAPSHOT"
		fi

		if ot-kernel_has_version "${pkg}[lxc]" ; then
			# See also ot-kernel-pkgflags_lxc
			ot-kernel_y_configopt "CONFIG_CGROUPS"
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_BLK_CGROUP"
			ot-kernel_y_configopt "CONFIG_CGROUP_CPUACCT"
			ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
			ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
			ot-kernel_y_configopt "CONFIG_CGROUP_NET_PRIO"
			ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
			ot-kernel_y_configopt "CONFIG_CGROUP_PERF"
			ot-kernel_y_configopt "CONFIG_CGROUPS"
			ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
			ot-kernel_y_configopt "CONFIG_CPUSETS"
			_ot-kernel_set_ipc_ns
			ot-kernel_y_configopt "CONFIG_MACVLAN"
			ot-kernel_y_configopt "CONFIG_NET_CLS_CGROUP"
			_ot-kernel_set_net_ns
			_ot-kernel_set_pid_ns
			_ot-kernel_set_posix_mqueue
			ot-kernel_y_configopt "CONFIG_SECURITYFS"
			_ot-kernel_set_user_ns
			_ot-kernel_set_uts_ns
			ot-kernel_y_configopt "CONFIG_VETH"
			ot-kernel_unset_configopt "CONFIG_GRKERNSEC_CHROOT_MOUNT"
			ot-kernel_unset_configopt "CONFIG_GRKERNSEC_CHROOT_DOUBLE"
			ot-kernel_unset_configopt "CONFIG_GRKERNSEC_CHROOT_PIVOT"
			ot-kernel_unset_configopt "CONFIG_GRKERNSEC_CHROOT_CHMOD"
			ot-kernel_unset_configopt "CONFIG_GRKERNSEC_CHROOT_CAPS"
			if ver_test "${KV_MAJOR_MINOR}" -lt "4.7" ; then
				ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
				ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
			fi
		fi

		if ot-kernel_has_version "${pkg}[virt-network]" ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"

			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
			ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
			ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
			ot-kernel_y_configopt "CONFIG_IP_NF_NAT"

			ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_REJECT"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"

			ot-kernel_y_configopt "CONFIG_BRIDGE"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"

			ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_CHECKSUM"
			ot-kernel_y_configopt "CONFIG_IP6_NF_FILTER"
			ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
			ot-kernel_y_configopt "CONFIG_IP6_NF_NAT"

			ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_T_NAT"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_MARK"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_MARK_T"

			ot-kernel_y_configopt "CONFIG_NET_ACT_POLICE" # Traffic Policing
			ot-kernel_y_configopt "CONFIG_NET_CLS_FW"
			ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
			ot-kernel_y_configopt "CONFIG_NET_SCH_HTB"
			ot-kernel_y_configopt "CONFIG_NET_SCH_INGRESS"
			ot-kernel_y_configopt "CONFIG_NET_SCH_SFQ"

			if ver_test "${KV_MAJOR_MINOR}" -lt "5.2" ; then
				ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
			else
				ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_MASQUERADE"
			fi
		fi

		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_CGROUP"

		ot-kernel_y_configopt "CONFIG_MEMORY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_likwid
# @DESCRIPTION:
# Applies kernel config flags for the likwid package
ot-kernel-pkgflags_likwid() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/likwid" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lightdm
# @DESCRIPTION:
# Applies kernel config flags for the lightdm package
ot-kernel-pkgflags_lightdm() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/lightdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_smaps
# @DESCRIPTION:
# Applies kernel config flags for the Linux-Smaps package
ot-kernel-pkgflags_linux_smaps() { # DONE
	if ot-kernel_has_version_pkgflags "dev-perl/Linux-Smaps" ; then
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PROC_PAGE_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_tools_power_x86
# @DESCRIPTION:
# Applies kernel config flags for the linux-tools-power-x86 package
ot-kernel-pkgflags_linux_tools_power_x86() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/linux-tools-power-x86" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lirc
# @DESCRIPTION:
# Applies kernel config flags for the lirc package
ot-kernel-pkgflags_lirc() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/lirc" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lm_sensors
# @DESCRIPTION:
# Applies kernel config flags for the lm-sensors package
ot-kernel-pkgflags_lm_sensors() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/lm-sensors" ; then
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_SMBUS"

		# Checked by sensors-detect
		if [[ "${arch}" =~ "x86" ]] ; then
			ot-kernel_y_configopt "CONFIG_X86_CPUID"
		fi
		if grep -q -E -e "^CONFIG_(PCI|ISA)=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_DEVPORT"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_logiops
# @DESCRIPTION:
# Applies kernel config flags for the logiops package
ot-kernel-pkgflags_logiops() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/logiops" ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_USB_HID"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH_HIDPP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lmms
# @DESCRIPTION:
# Applies kernel config flags for the lmms package
ot-kernel-pkgflags_lmms() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/lmms" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_longrun
# @DESCRIPTION:
# Applies kernel config flags for the longrun package
ot-kernel-pkgflags_longrun() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/longrun" ; then
		ot-kernel_unset_configopt "CONFIG_X86_MSR"
		ot-kernel_unset_configopt "CONFIG_X86_CPUID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_loopaes
# @DESCRIPTION:
# Applies kernel config flags for the loopaes package
ot-kernel-pkgflags_loopaes() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/loop-aes" ; then
		ot-kernel_unset_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lttng_modules
# @DESCRIPTION:
# Applies kernel config flags for the lttng-modules package
ot-kernel-pkgflags_lttng_modules() { # DONE
	local pkg="dev-util/lttng-modules"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_MODULES"
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ban_disable_debug "${pkg}" "CONFIG_TRACEPOINTS, CONFIG_EVENT_TRACING"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_EVENT_TRACING"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_KRETPROBES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lttng_ust
# @DESCRIPTION:
# Applies kernel config flags for the lttng-ust package
ot-kernel-pkgflags_lttng_ust() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/lttng-ust" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lvm2
# @DESCRIPTION:
# Applies kernel config flags for the lvm2 package
ot-kernel-pkgflags_lvm2() { # DONE
	local pkg="sys-fs/lvm2"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		if ot-kernel_has_version "${pkg}[udev]" ; then
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
	if ot-kernel_has_version_pkgflags "app-containers/lxc" ; then
		ot-kernel_unset_configopt "CONFIG_NETPRIO_CGROUP"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_CGROUP_CPUACCT"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
		ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
		ot-kernel_y_configopt "CONFIG_CPUSETS"

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns

		ot-kernel_y_configopt "CONFIG_MACVLAN"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		ot-kernel_y_configopt "CONFIG_NET"
		_ot-kernel_set_posix_mqueue
		ot-kernel_y_configopt "CONFIG_VETH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lxd
# @DESCRIPTION:
# Applies kernel config flags for the lxd package
ot-kernel-pkgflags_lxd() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/lxd" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns

		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel-pkgflags_kvm_host_required
		ot-kernel_y_configopt "CONFIG_MACVTAP"
		ot-kernel_y_configopt "CONFIG_VHOST_VSOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lxdm
# @DESCRIPTION:
# Applies kernel config flags for the lxdm package
ot-kernel-pkgflags_lxdm() { # DONE
	if ot-kernel_has_version_pkgflags "lxde-base/lxdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lxqt_sudo
# @DESCRIPTION:
# Applies kernel config flags for the lxqt-sudo package
ot-kernel-pkgflags_lxqt_sudo() { # DONE
	if ot-kernel_has_version_pkgflags "lxqt-base/lxqt-sudo" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_madwimax
# @DESCRIPTION:
# Applies kernel config flags for the madwimax package
ot-kernel-pkgflags_madwimax() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/madwimax" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mahimahi
# @DESCRIPTION:
# Applies kernel config flags for the mahimahi package
ot-kernel-pkgflags_mahimahi() { # DONE
	if ot-kernel_has_version_pkgflags "www-misc/mahimahi" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_makemkv
# @DESCRIPTION:
# Applies kernel config flags for the makemkv package
ot-kernel-pkgflags_makemkv() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/makemkv" ; then
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mariadb
# @DESCRIPTION:
# Applies kernel config flags for the mariadb package
ot-kernel-pkgflags_mariadb() { # DONE
	if ot-kernel_has_version_pkgflags "dev-db/mariadb" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mbpfan
# @DESCRIPTION:
# Applies kernel config flags for the mbpfan package
ot-kernel-pkgflags_mbpfan() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/mbpfan" ; then
		if [[ "${arch}" =~ "(x86)" ]]; then
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_SENSORS_APPLESMC"
			ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mcelog
# @DESCRIPTION:
# Applies kernel config flags for the mcelog package
ot-kernel-pkgflags_mcelog() { # DONE
	local pkg="app-admin/mcelog"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_X86_MCE"
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.12" ; then
			ban_disable_debug "${pkg}" "CONFIG_X86_MCELOG_LEGACY"
			ot-kernel_y_configopt "CONFIG_X86_MCELOG_LEGACY"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mcproxy
# @DESCRIPTION:
# Applies kernel config flags for the mcproxy package
ot-kernel-pkgflags_mcproxy() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/mcproxy" ; then
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mdadm
# @DESCRIPTION:
# Applies kernel config flags for the mdadm package
ot-kernel-pkgflags_mdadm() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/mdadm" ; then
		MDADM_RAID="${MDADM_RAID:-1}"
		if [[ "${MDADM_RAID}" == "1" ]] ; then
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

# @FUNCTION: _ot-kernel-pkgflags_has_midi
# @DESCRIPTION:
# Samples the midi USE flag or midi packages
# True if user wants midi support
_ot-kernel-pkgflags_has_midi() { # DONE
	if \
		   ot-kernel_has_version "media-libs/portmidi" \
		|| ot-kernel_has_version "media-libs/rtmidi" \
		|| ot-kernel_has_version "media-sound/fluidsynth" \
		|| ot-kernel_has_version "media-sound/timidity++" \
		|| ot-kernel_has_version "media-sound/wildmidi" \
	; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_midi
# @DESCRIPTION:
# Applies kernel config flags for midi support
ot-kernel-pkgflags_midi() { # DONE
	if \
		[[ "${ALSA_MIDI}" == "1" ]] \
		|| _ot-kernel-pkgflags_has_midi \
	; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_unset_configopt "CONFIG_UML"
		ot-kernel_set_configopt "CONFIG_SND_SEQUENCER" "m"
		ot-kernel_set_configopt "CONFIG_SND_SEQ_DUMMY" "m"
		ot-kernel_y_configopt "CONFIG_SND_SEQ_HRTIMER_DEFAULT"
		ot-kernel_y_configopt "CONFIG_SND_VIRMIDI"

		# MIDI port
		ot-kernel_y_configopt "CONFIG_SND_DRIVERS"
		ot-kernel_set_configopt "CONFIG_SND_MPU401" "m"

		# USB audio/midi devices
		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"

		if ver_test "${KV_MAJOR_MINOR}" -le "4.14" ; then
			ot-kernel_y_configopt "CONFIG_SOUND_PRIME" # OSS support
		fi

		if [[ "${OSS_MIDI}" == "1" ]] \
			|| ot-kernel_has_version "media-sound/fluidsynth[oss]" \
			|| ot-kernel_has_version "media-sound/timidity++[oss]" \
			|| ot-kernel_has_version "media-sound/wildmidi[oss]" \
		; then
			ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"
			ot-kernel_y_configopt "CONFIG_SND_SEQUENCER_OSS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_memkind
# @DESCRIPTION:
# Applies kernel config flags for the memkind package
ot-kernel-pkgflags_memkind() { # DONE
	local pkg="dev-libs/memkind"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[daxctl]" ; then
			ot-kernel_y_configopt "CONFIG_DEV_DAX_KMEM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mesa
# @DESCRIPTION:
# Applies kernel config flags for the mesa package
ot-kernel-pkgflags_mesa() { # DONE
	local pkg="media-libs/mesa"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ver_test "${KV_MAJOR_MINOR}" -ge "5" ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		else
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		fi
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		if ot-kernel_has_version "${pkg}[vulkan,video_cards_radeonsi]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
		if ot-kernel_has_version "${pkg}[video_cards_vmware]" ; then
			ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
			_ot-kernel_y_thp # See 8afe12b2
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mesa_amber
# @DESCRIPTION:
# Applies kernel config flags for the mesa-amber package
ot-kernel-pkgflags_mesa_amber() { # DONE
	if ot-kernel_has_version_pkgflags "media-libs/mesa-amber" ; then
		ot-kernel_y_configopt "CONFIG_KCMP"
		ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_minidlna
# @DESCRIPTION:
# Applies kernel config flags for the minidlna package
ot-kernel-pkgflags_minidlna() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/minidlna" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_minijail
# @DESCRIPTION:
# Applies kernel config flags for the minijail package
ot-kernel-pkgflags_minijail() { # DONE
	local pkg="sys-apps/minijail"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns

		_ot-kernel_set_seccomp_bpf "${pkg}"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mongodb
# @DESCRIPTION:
# Applies kernel config flags for the mongodb package
ot-kernel-pkgflags_mongodb() { # DONE
	if ot-kernel_has_version_pkgflags "dev-db/mongodb" ; then
		:
		# The upstream docs say disable.
		#_ot-kernel_y_thp # Added for performance reasons.  ~15-29% benefit.
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mono
# @DESCRIPTION:
# Applies kernel config flags for the mono package
ot-kernel-pkgflags_mono() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/mono" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC" # Optional to run exe directly

		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mpd
# @DESCRIPTION:
# Applies kernel config flags for the mpd package
ot-kernel-pkgflags_mpd() { # DONE
	local pkg="media-sound/mpd"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[eventfd]" \
	; then
		if ot-kernel_has_version "${pkg}[eventfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_EVENTFD"
		fi
		if ot-kernel_has_version "${pkg}[signalfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_SIGNALFD"
		fi
		if ot-kernel_has_version "${pkg}[inotify]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mpg123
# @DESCRIPTION:
# Applies kernel config flags for the mpg123 package
ot-kernel-pkgflags_mpg123() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/mpg123" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mplayer
# @DESCRIPTION:
# Applies kernel config flags for the mplayer package
ot-kernel-pkgflags_mplayer() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/mplayer" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
	# LDT referenced and dated 2004 for older glibcs
}

# @FUNCTION: ot-kernel-pkgflags_mpm_itk
# @DESCRIPTION:
# Applies kernel config flags for the mpm_itk package
ot-kernel-pkgflags_mpm_itk() { # DONE
	local pkg="www-apache/mpm_itk"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
	# The distro ebuild is missing seccomp-bpf flags.
		_ot-kernel_set_seccomp_bpf "${pkg}"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mptcpd
# @DESCRIPTION:
# Applies kernel config flags for the mptcpd package
ot-kernel-pkgflags_mptcpd() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/mptcpd" ; then
		ot-kernel_y_configopt "CONFIG_MPTCP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mpv
# @DESCRIPTION:
# Applies kernel config flags for the mpv package
ot-kernel-pkgflags_mpv() { # DONE
	if \
		   ot-kernel_has_version "media-video/mpv[X]" \
		|| ot-kernel_has_version "media-video/mpv[xv]" \
	; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_msr_tools
# @DESCRIPTION:
# Applies kernel config flags for the msr-tools package
ot-kernel-pkgflags_msr_tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/msr-tools" ; then
		ot-kernel_y_configopt "CONFIG_X86_CPUID"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mswatch
# @DESCRIPTION:
# Applies kernel config flags for the mswatch package
ot-kernel-pkgflags_mswatch() { # DONE
	if ot-kernel_has_version_pkgflags "net-mail/mswatch" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_multipath_tools
# @DESCRIPTION:
# Applies kernel config flags for the multipath-tools package
ot-kernel-pkgflags_multipath_tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/multipath-tools" ; then
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_networkmanager
# @DESCRIPTION:
# Applies kernel config flags for the networkmanager package
ot-kernel-pkgflags_networkmanager() { # DONE
	local pkg="net-misc/networkmanager"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[connection-sharing]" ; then
			if ver_test "${KV_MAJOR_MINOR}" -lt "5.1" ; then
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

# @FUNCTION: ot-kernel-pkgflags_musl
# @DESCRIPTION:
# Applies kernel config flags for the musl package
ot-kernel-pkgflags_musl() { # DONE
	if ot-kernel_has_version_pkgflags "sys-libs/musl" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		# References bpf but not used.
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		# _ot-kernel_y_thp # Has THP symbol but not used within lib.
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		# LDT referenced in sys-libs/musl
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mysql
# @DESCRIPTION:
# Applies kernel config flags for the mysql package
ot-kernel-pkgflags_mysql() { # DONE
	local pkg="dev-db/mysql"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
		if ot-kernel_has_version "${pkg}[numa]" ; then
			ot-kernel_y_configopt "CONFIG_NUMA"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nbfc
# @DESCRIPTION:
# Applies kernel config flags for the nbfc package
ot-kernel-pkgflags_nbfc() { # DONE
	local pkg="sys-power/nbfc-linux"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_ACPI_EC_DEBUGFS"
		ot-kernel_y_configopt "CONFIG_ACPI_EC_DEBUGFS"
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nccl
# @DESCRIPTION:
# Applies kernel config flags for the nccl package
ot-kernel-pkgflags_nccl() { # DONE
	local pkg="dev-libs/nccl"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_DMA_SHARED_BUFFER"
		ot-kernel_y_configopt "CONFIG_DMABUF_MOVE_NOTIFY"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_64BIT"
		ot-kernel_y_configopt "CONFIG_PCI_P2PDMA"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_INFINIBAND"
		ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_ETHERNET"
		ot-kernel_y_configopt "CONFIG_NET_VENDOR_MELLANOX"
		ot-kernel_y_configopt "CONFIG_MLX5_CORE"
		ot-kernel_y_configopt "CONFIG_MLX5_INFINIBAND"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nemu
# @DESCRIPTION:
# Applies kernel config flags for the nemu package
ot-kernel-pkgflags_nemu() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/nemu" ; then
		ot-kernel_y_configopt "CONFIG_VETH"
		ot-kernel_y_configopt "CONFIG_MACVTAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nfacct
# @DESCRIPTION:
# Applies kernel config flags for the nfacct package
ot-kernel-pkgflags_nfacct() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/nfacct" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nfs_utils
# @DESCRIPTION:
# Applies kernel config flags for the nfs-utils package
ot-kernel-pkgflags_nfs_utils() { # DONE
	local pkg="net-fs/nfs-utils"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[nfsv4,-nfsdcld]" ; then
			_ot-kernel-pkgflags_md5
		fi
		NFS_CLIENT="${NFS_CLIENT:-1}"
		if [[ "${NFS_CLIENT}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
			ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
			ot-kernel_y_configopt "CONFIG_NFS_FS"
			ot-kernel_y_configopt "CONFIG_NFS_V3"
			ot-kernel_y_configopt "CONFIG_NFS_V4"
			ot-kernel_y_configopt "CONFIG_NFS_V4_1"
		fi
		NFS_SERVER="${NFS_SERVER:-1}"
		if [[ "${NFS_SERVER}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
			ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
			ot-kernel_y_configopt "CONFIG_NFSD"
			ot-kernel_y_configopt "CONFIG_NFSD_V3"
			ot-kernel_y_configopt "CONFIG_NFSD_V4"
			ot-kernel_y_configopt "CONFIG_NFSD_PNFS"
			if ver_test "${KV_MAJOR_MINOR}" -gt "4.5" ; then
				ot-kernel_y_configopt "CONFIG_NFSD_BLOCKLAYOUT" # Selects NFSD_PNFS
				ot-kernel_y_configopt "CONFIG_NFSD_SCSILAYOUT"  # Selects NFSD_PNFS
				# NFSD_FLEXFILELAYOUT # For testing only not production
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nftables
# @DESCRIPTION:
# Applies kernel config flags for the nftables package
ot-kernel-pkgflags_nftables() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/nftables" \
		&& ver_test "${KV_MAJOR_MINOR}" -ge "3.13" ; then
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nilfs_utils
# @DESCRIPTION:
# Applies kernel config flags for the nilfs-utils package
ot-kernel-pkgflags_nilfs_utils() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/nilfs-utils" ; then
		_ot-kernel_set_posix_mqueue
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nodejs
# @DESCRIPTION:
# Applies kernel config flags for the nodejs package
ot-kernel-pkgflags_nodejs() { # DONE
	local pkg="net-libs/nodejs"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		_ot-kernel_y_thp # See issue 16198
		if ot-kernel_has_version "${pkg}[-system-ssl]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_AIO"
		fi

		if [[ "${arch}" =~ "ppc" ]]; then
			_ot-kernel_set_shmem
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nftlb
# @DESCRIPTION:
# Applies kernel config flags for the nftlb package
ot-kernel-pkgflags_nftlb() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/nftlb" ; then
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
		ot-kernel_y_configopt "CONFIG_NFT_NUMGEN"
		ot-kernel_y_configopt "CONFIG_NFT_HASH"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_IP_NF_NAT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nginx
# @DESCRIPTION:
# Applies kernel config flags for the nginx package
ot-kernel-pkgflags_nginx() { # DONE
	if ot-kernel_has_version_pkgflags "www-servers/nginx" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ntfs3g
# @DESCRIPTION:
# Applies kernel config flags for the ntfs3g package
ot-kernel-pkgflags_ntfs3g() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/ntfs3g" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nstx
# @DESCRIPTION:
# Applies kernel config flags for the nstx package
ot-kernel-pkgflags_nstx() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/nstx" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nsxiv
# @DESCRIPTION:
# Applies kernel config flags for the nsxiv package
ot-kernel-pkgflags_nsxiv() { # DONE
	if ot-kernel_has_version_pkgflags "media-gfx/nsxiv" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_numad
# @DESCRIPTION:
# Applies kernel config flags for the numad package
ot-kernel-pkgflags_numad() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/numad" ; then
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nut
# @DESCRIPTION:
# Applies kernel config flags for the nut package
ot-kernel-pkgflags_nut() { # DONE
	local pkg="sys-power/nut"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[i2c]" ; then
			ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		fi
		if ot-kernel_has_version "${pkg}[usb]" ; then
			ot-kernel_y_configopt "CONFIG_HIDRAW"
			ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		fi
		if ot-kernel_has_version "${pkg}[serial]" ; then
			ot-kernel_y_configopt "CONFIG_SERIAL_8250"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nv
# @DESCRIPTION:
# Applies kernel config flags for the nv driver
ot-kernel-pkgflags_nv() { # DONE
	local pkg="x11-drivers/nvidia-drivers"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_AMD64"
		fi
		ot-kernel_y_configopt "CONFIG_PROC_FS"

	# These two selects DRM_KMS_HELPER indirectly. \
		ot-kernel_y_configopt "CONFIG_DRM"
		_ot-kernel_set_drm_fbdev_emulation

		ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_unset_configopt "CONFIG_LOCKDEP"
		ot-kernel_unset_configopt "CONFIG_DEBUG_MUTEXES"

		if ot-kernel_has_version "${pkg}[powerd]" ; then
			ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		fi

		if [[ "${arch}" == "x86_64" ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -ge "5.8" ; then
				ot-kernel_y_configopt "CONFIG_X86_PAT"
			fi
		fi

		if ot-kernel_has_version ">=${pkg}-515.86[kernel-open]" ; then
			if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_ACPI"
				ot-kernel_y_configopt "CONFIG_AMD_IOMMU"
				ot-kernel_y_configopt "CONFIG_AMD_IOMMU_V2"
	# It enables the MMU_NOTIFIER indirectly.
			elif [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_PCI_MSI"
				ot-kernel_y_configopt "CONFIG_ACPI"
				ot-kernel_y_configopt "CONFIG_INTEL_IOMMU"
				ot-kernel_y_configopt "CONFIG_INTEL_IOMMU_SVM"
	# It enables the MMU_NOTIFIER indirectly.
			fi

			if \
				   has_version "dev-libs/nccl[verbs]" \
				|| has_version "sys-block/libfabric[verbs]" \
			; then
				ot-kernel_y_configopt "CONFIG_NET"
				ot-kernel_y_configopt "CONFIG_INET"
				ot-kernel_y_configopt "CONFIG_MMU"
				ot-kernel_y_configopt "CONFIG_INFINIBAND"
				ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
				ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_MEM"
				ot-kernel_y_configopt "CONFIG_INFINIBAND_ON_DEMAND_PAGING"
	# It enables the MMU_NOTIFIER indirectly.
			fi

			if has_version "app-emulation/qemu" ; then
				: # See ot-kernel-pkgflags_qemu
	# It enables the MMU_NOTIFIER indirectly.
			elif has_version "app-emulation/xen" ; then
				: # See ot-kernel-pkgflags_xen
	# It enables the MMU_NOTIFIER indirectly.
			fi
			ot-kernel_y_configopt "CONFIG_MMU_NOTIFIER"
		fi

		if ot-kernel_has_version ">=${pkg}-470.161" ; then
			ot-kernel_unset_configopt "CONFIG_SLUB_DEBUG_ON"
		fi

		if \
			   ot-kernel_has_version "=${pkg}-535.183*[-kernel-open]" \
			|| ot-kernel_has_version "=${pkg}-525.147*[-kernel-open]" \
			|| ot-kernel_has_version "=${pkg}-515.86*[-kernel-open]" \
			|| ot-kernel_has_version "=${pkg}-510.108*" \
			|| ot-kernel_has_version "=${pkg}-470.256*" \
			|| ot-kernel_has_version "=${pkg}-470.161*" \
			|| ot-kernel_has_version "=${pkg}-390.157*" \
		; then
			warn_lowered_security "${pkg}" "Disables CFI"
			ot-kernel_unset_configopt "CONFIG_X86_KERNEL_IBT"
		fi
		if \
			   ot-kernel_has_version "=${pkg}-470.256*" \
			|| ot-kernel_has_version "=${pkg}-470.161*" \
			|| ot-kernel_has_version "=${pkg}-390.157*" \
		; then
			warn_lowered_security "${pkg}" "Cold Boot Attack" "ID"
			ot-kernel_unset_configopt "CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT"
		fi

	# Add graphical framebuffer support
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_CORE"
		ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
		ot-kernel_y_configopt "CONFIG_VT"

	# The nvidia-drivers can only use the TTY framebuffer with either efifb
	# or nvidia-drm (the proprietary KMS driver) with the two settings
	# below.

	# When both kernel command line options are enabled, the framebuffer is
	# using accelerated KMS.
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nvidia-drm.modeset=1"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nvidia-drm.fbdev=1"
		if ! [[ "${work_profile}" =~ ("vm-guest"|"vm-host") ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nvidia-drm.modeset=1"
			ot-kernel_set_kconfig_kernel_cmdline "nvidia-drm.fbdev=1"
		fi

	# Disable all graphical framebuffer drivers for TTY
		ot-kernel_unset_configopt "CONFIG_DRM_NOUVEAU"
		ot-kernel_unset_configopt "CONFIG_DRM_SIMPLEDRM"
		ot-kernel_unset_configopt "CONFIG_FB_EFI" # This is unaccelerated
		ot-kernel_unset_configopt "CONFIG_FB_NVIDIA"
		ot-kernel_unset_configopt "CONFIG_FB_SIMPLE"
		ot-kernel_unset_configopt "CONFIG_FB_UVESA"
		ot-kernel_unset_configopt "CONFIG_FB_VESA"
		ot-kernel_unset_configopt "CONFIG_FB_VGA16"
		ot-kernel_unset_configopt "CONFIG_VGA_CONSOLE" # This will conflict
ewarn "It is assumed that you will use a bootdisk to fix driver issues with nvidia-drivers package."
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nvtop
# @DESCRIPTION:
# Applies kernel config flags for nvtop
ot-kernel-pkgflags_nvtop() { # DONE
	local pkg="sys-process/nvtop"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		if ot-kernel_has_version "${pkg}[video_cards_amdgpu]" ; then
			if \
					! has rock-dkms ${IUSE_EFFECTIVE} \
			; then
				ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
			elif \
					  has rock-dkms ${IUSE_EFFECTIVE} \
				&& \
					ot-kernel_use rock-dkms \
				&& \
				( \
					   ver_test "${KV_MAJOR_MINOR}" -eq "5.4" \
					|| ver_test "${KV_MAJOR_MINOR}" -eq "5.15" \
				) \
			; then
	# For sys-kernel/rock-dkms not installed yet scenario.
				ot-kernel_y_configopt "CONFIG_MODULES"
				ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"
			else
				ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
			fi
			ot-kernel_y_configopt "CONFIG_SYSFS"
		fi
		if ot-kernel_has_version "${pkg}[video_cards_intel]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915"
		fi
		if ot-kernel_has_version "${pkg}[video_cards_freedreno]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_MSM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_obsidian
# @DESCRIPTION:
# Applies kernel config flags for the obsidian package
ot-kernel-pkgflags_obsidian() { # DONE
	if ot-kernel_has_version_pkgflags "app-office/obsidian" ; then
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oomd
# @DESCRIPTION:
# Applies kernel config flags for the oomd package
ot-kernel-pkgflags_oomd() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/oomd" ; then
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.20" ; then
			ot-kernel_y_configopt "CONFIG_PSI"
		fi
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SWAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_opal_utils
# @DESCRIPTION:
# Applies kernel config flags for the opal-utils package
ot-kernel-pkgflags_opal_utils() { # DONE
	local pkg="sys-apps/opal-utils"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_MTD_POWERNV_FLASH"
		ot-kernel_y_configopt "CONFIG_OPAL_PRD"
		ot-kernel_y_configopt "CONFIG_PPC_DT_CPU_FTRS"
		ban_disable_debug "${pkg}" "CONFIG_SCOM_DEBUGFS"
		needs_debugfs
		ot-kernel_y_configopt "CONFIG_SCOM_DEBUGFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oprofile
# @DESCRIPTION:
# Applies kernel config flags for the oprofile package
ot-kernel-pkgflags_oprofile() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/oprofile" ; then
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		_ot-kernel-pkgflags_cpu_pmu_events_oprofile
	fi
}

# @FUNCTION: ot-kernel-pkgflags_orca
# @DESCRIPTION:
# Applies kernel config flags for the orca package
ot-kernel-pkgflags_orca() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/orca" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
		ot-kernel_y_configopt "CONFIG_TCP_CONG_CUBIC"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_has_oss_use
# @DESCRIPTION:
# Samples apps (or auto-detects) for oss support
# True if popular packages contain oss USE flag
_ot-kernel-pkgflags_has_oss_use() {
	# >= 81 packages with oss USE flag
	if \
		   ot-kernel_has_version "app-emulation/wine-d3d9[oss]" \
		|| ot-kernel_has_version "app-emulation/wine-staging[oss]" \
		|| ot-kernel_has_version "app-emulation/wine-vanilla[oss]" \
		|| ot-kernel_has_version "app-emulation/wine-wayland[oss]" \
		|| ot-kernel_has_version "media-libs/allegro[oss]" \
		|| ot-kernel_has_version "media-libs/libsdl[oss]" \
		|| ot-kernel_has_version "media-libs/libsdl2[oss]" \
		|| ot-kernel_has_version "media-libs/openal[oss]" \
		|| ot-kernel_has_version "media-plugins/alsa-plugins[oss]" \
		|| ot-kernel_has_version "media-sound/jack-audio-connection-kit[oss]" \
		|| ot-kernel_has_version "media-sound/oss" \
		|| ot-kernel_has_version "media-sound/pulseaudio[oss]" \
		|| ot-kernel_has_version "media-sound/sox[oss]" \
		|| ot-kernel_has_version "media-video/ffmpeg[oss]" \
		|| ot-kernel_has_version "media-video/mplayer[oss]" \
	; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_oss
# @DESCRIPTION:
# Applies kernel config flags for oss support
ot-kernel-pkgflags_oss() { # DONE
	if [[ "${OSS}" == "1" ]] || _ot-kernel-pkgflags_has_oss_use ; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"

		ot-kernel_y_configopt "CONFIG_SND_MIXER_OSS" # /dev/mixer*
		ot-kernel_y_configopt "CONFIG_SND_PCM_OSS" # /dev/dsp*

		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"

		ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ovpn_dco
# @DESCRIPTION:
# Applies kernel config flags for the ovpn-dco package
ot-kernel-pkgflags_ovpn_dco() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/ovpn-dco" ; then
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NET_UDP_TUNNEL"
		ot-kernel_y_configopt "CONFIG_DST_CACHE"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		_ot-kernel-pkgflags_aes CCM
		_ot-kernel-pkgflags_chacha20_poly1305
	fi
}

# @FUNCTION: ot-kernel-pkgflags_has_external_module
# @DESCRIPTION:
# Check for external modules
ot-kernel-pkgflags_has_external_module() {
# Discovered with
# out=$(mktemp) ; \
# cd /var/lib/layman ; grep --exclude-dir=.git --exclude-dir=metadata -r -e "linux-mod" -e "sys-kernel/dkms" ./ | cut -f 3-4 -d "/" > "${out}" ; \
# cd /usr/portage ; grep --exclude-dir=metadata --exclude-dir=.git --exclude-dir=distfiles -l -r -e "linux-mod" ./ | cut -f 2-3 -d "/" >> "${out}" ; \
# cat "${out}" | sort | uniq ; rm "${out}"
	local PKGS=(
app-admin/ryzen_smu
app-antivirus/lkrg
app-antivirus/tyton
app-crypt/tpm-emulator
app-emulation/vendor-reset
app-emulation/virtualbox-guest-additions
app-emulation/virtualbox-modules
app-emulation/vmware-modules
app-forensics/kjackal
app-forensics/prochunter
app-laptop/tp_smapi
app-laptop/tuxedo-keyboard
bluetooth-drivers/rtbth
dev-libs/gdrcopy
dev-libs/libgpiod
dev-util/lttng-modules
dev-util/sysdig-kmod
games-util/hid-nintendo
games-util/xone
games-util/xpadneo
media-libs/svgalib
media-sound/netcat-cpi
media-tv/v4l-dvb-saa716x
media-video/droidcam
media-video/v4l2loopback
net-analyzer/pkt-netflow
net-dialup/accel-ppp
net-firewall/ipset
net-firewall/ipt_netflow
net-firewall/ipt-ratelimit
net-firewall/rtsp-conntrack
net-firewall/xtables-addons
net-firewall/xt_dns
net-firewall/xt_nat
net-fs/openafs
net-misc/AQtion
net-misc/dahdi
net-misc/ena-driver
net-misc/openvswitch
net-misc/r8125
net-misc/r8168
net-misc/realtek-r8152
net-vpn/wireguard-modules
net-wireless/broadcom-sta
net-wireless/broadcom-wl
net-wireless/mt7610u_ulli-kroll
net-wireless/rt3070
net-wireless/rtl8192eu
net-wireless/rtl8812au
net-wireless/rtl8812au_aircrack-ng
net-wireless/rtl8821ce
net-wireless/rtl8821cu
net-wireless/rtl8822bu
sci-libs/linux-gpib-modules
sec-policy/selinux-modemmanager
sys-apps/openrazer
sys-apps/smc-sum
sys-cluster/knem
sys-cluster/lustre
sys-cluster/xpmem
sys-fs/exfat-nofuse
sys-fs/loop-aes
sys-fs/vhba
sys-fs/zfs
sys-fs/zfs-kmod
sys-kernel/compat-drivers
sys-kernel/cryptodev
sys-kernel/fragattacks-drivers58
sys-kernel/ft60x_driver
sys-kernel/gostcrypt-linux-crypto
sys-kernel/kpatch
sys-kernel/pcc
sys-kernel/pf_ring-kmod
sys-kernel/rte_kni-kmod
sys-kernel/tirdad
sys-kernel/ummunotify
sys-kernel/zenpower3
sys-libs/safeclib
sys-power/acpi_call
sys-power/bbswitch
sys-power/phc-intel
sys-power/tuxedo-cc-wmi
sys-process/atop
sys-process/falco-bin
x11-drivers/evdi
x11-drivers/nvidia-drivers
x11-misc/openrazer
	)
	local p
	for p in ${PKGS[@]} ; do
		if ot-kernel_has_version "${p}" ; then
			return 0
		fi
	done
	ot-kernel_has_version "sys-kernel/dkms" && return 0
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_external_modules
# @DESCRIPTION:
# Applies kernel config flags for external kernel modules
ot-kernel-pkgflags_external_modules() {
	local external_module=0

	if ot-kernel-pkgflags_has_external_module ; then
einfo "Detected external kernel module"
		external_module=1
	fi
	[[ "${OT_KERNEL_EXTERNAL_MODULES}" ]] && external_module=1

	if (( ${external_module} == 1 )) ; then
		ot-kernel_unset_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		ot-kernel_y_configopt "CONFIG_MODULES"
	elif grep -q -E -e "^CONFIG_MODULES=y" "${path_config}" ; then
		# Upstream claims that this improves LTO
		ot-kernel_y_configopt "CONFIG_TRIM_UNUSED_KSYMS"
	fi

	if \
		[[ "${work_profile}" == "dss" ]] \
			||
		_ot-kernel_is_hardening_level_most_secure \
	; then
		if grep -q -E -e "^CONFIG_MODULES=y" "${path_config}" ; then
	# Prevent loading of unsigned modules.
	# The upstream default is that lockdown is disabled.
			ot-kernel_y_configopt "CONFIG_MODULE_SIG"
			_OT_KERNEL_LSM_ADD_LOCKDOWN=1
		fi
	fi
}


# @FUNCTION: ot-kernel-pkgflags_osmo_fl2k
# @DESCRIPTION:
# Applies kernel config flags for the osmo-fl2k package
ot-kernel-pkgflags_osmo_fl2k() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/osmo-fl2k" ; then
		ot-kernel_y_configopt "CONFIG_CMA"
		ot-kernel_y_configopt "CONFIG_DMA_CMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_iscsi
# @DESCRIPTION:
# Applies kernel config flags for the open-iscsi package
ot-kernel-pkgflags_open_iscsi() { # DONE
	local pkg="sys-block/open-iscsi"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[tcp]" ; then
			ot-kernel_y_configopt "CONFIG_SCSI_ISCSI_ATTRS"
			ot-kernel_y_configopt "CONFIG_ISCSI_TCP"
		fi
		if ot-kernel_has_version "${pkg}[infiniband]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_IPOIB"
			ot-kernel_y_configopt "CONFIG_INIBAND_USER_MAD"
			ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
		fi
		if ot-kernel_has_version "${pkg}[rdma]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_ISER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_vm_tools
# @DESCRIPTION:
# Applies kernel config flags for the open-vm-tools package
ot-kernel-pkgflags_open_vm_tools() { # DONE
	local pkg="app-emulation/open-vm-tools"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_VMWARE_BALLOON"
		ot-kernel_y_configopt "CONFIG_VMWARE_PVSCSI"
		ot-kernel_y_configopt "CONFIG_VMXNET3"
		if ot-kernel_has_version "${pkg}[X]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_VMWGFX"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "3.9" ; then
			ot-kernel_y_configopt "CONFIG_VMWARE_VMCI"
			ot-kernel_y_configopt "CONFIG_VMWARE_VMCI_VSOCKETS"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "3" ; then
			ot-kernel_y_configopt "CONFIG_FUSE_FS"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.5" ; then
			ot-kernel_y_configopt "CONFIG_X86_IOPL_IOPERM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openafs
# @DESCRIPTION:
# Applies kernel config flags for the openafs
ot-kernel-pkgflags_openafs() { # DONE
	local pkg="net-fs/openafs"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ver_test "${KV_MAJOR_MINOR}" -lt "5.17" ; then
			if ot-kernel_has_version "${pkg}[modules]" ; then
				ot-kernel_unset_configopt "CONFIG_AFS_FS"
			else
				ot-kernel_y_configopt "CONFIG_AFS_FS"
			fi
			ot-kernel_y_configopt "CONFIG_KEYS"
		elif ver_test "${KV_MAJOR_MINOR}" -ge "5.17" ; then
ewarn "Kernel ${KV_MAJOR_MINOR}.x is not supported for openafs"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openconnect
# @DESCRIPTION:
# Applies kernel config flags for the openconnect package
ot-kernel-pkgflags_openconnect() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/openconnect" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openl2tp
# @DESCRIPTION:
# Applies kernel config flags for the openl2tp package
ot-kernel-pkgflags_openl2tp() { # DONE
	if ot-kernel_has_version_pkgflags "net-dialup/openl2tp" ; then
		ot-kernel_y_configopt "CONFIG_PPPOL2TP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openfortivpn
# @DESCRIPTION:
# Applies kernel config flags for the openfortivpn package
ot-kernel-pkgflags_openfortivpn() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/openfortivpn" ; then
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openrc
# @DESCRIPTION:
# Applies kernel config flags for the openrc package
ot-kernel-pkgflags_openrc() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/openrc" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! scripts
		ot-kernel_y_configopt "CONFIG_FILE_LOCKING"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		ot-kernel_y_configopt "CONFIG_DEVPTS_FS" # For /dev/pts
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openrgb
# @DESCRIPTION:
# Applies kernel config flags for the openrgb package
ot-kernel-pkgflags_openrgb() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/openrgb" ; then
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_I2C_I801"
			ot-kernel_y_configopt "CONFIG_I2C_NCT6775"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_I2C_PIIX4"
		fi
		if [[ "${OPENRGB_RESOLVE_ACPI_SMBUS_CONFLICT:-0}" == "1" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "acpi_enforce_resources=lax"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_opensnitch
# @DESCRIPTION:
# Applies kernel config flags for the opensnitch package
ot-kernel-pkgflags_opensnitch() { # DONE
	local pkg="app-admin/opensnitch"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
	        _ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_INET_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_TCP_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_UDP_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_RAW_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_DIAG_DESTROY"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_ACCT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		if ot-kernel_has_version_pkgflags "${pkg}[audit]" ; then
			ot-kernel_y_configopt "CONFIG_NET" # CONFIG_AUDIT dep
			ot-kernel_y_configopt "CONFIG_AUDIT"
		fi
		if ot-kernel_has_version_pkgflags "${pkg}[iptables]" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		fi
		if ot-kernel_has_version_pkgflags "${pkg}[nftables]" ; then
			ot-kernel_y_configopt "CONFIG_NFT_CT"
			ot-kernel_y_configopt "CONFIG_NFT_QUEUE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_opensnitch_ebpf_module
# @DESCRIPTION:
# Applies kernel config flags for the opensnitch-ebpf-module package
ot-kernel-pkgflags_opensnitch_ebpf_module() { # DONE
	local pkg="app-admin/opensnitch-ebpf-module"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}" # Uses syscall with number
		ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
		ban_disable_debug "${pkg}" "CONFIG_FTRACE_SYSCALLS, CONFIG_DYNAMIC_FTRACE_WITH_REGS, CONFIG_KPROBES_ON_FTRACE"
		ot-kernel_y_configopt "CONFIG_FTRACE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_DYNAMIC_FTRACE_WITH_REGS"
		ot-kernel_y_configopt "CONFIG_KPROBES_ON_FTRACE"
		ot-kernel_y_configopt "CONFIG_KPROBE_EVENTS"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_UPROBE_EVENTS"
	fi
}

# @FUNCTION: _ot-kernel_tls_support
# @DESCRIPTION:
# Enables KTLS/TLS support
#
# Both _ot-kernel_tls_support and _ot-kernel_checkpoint_dss_tls_requirement
# look similar but there are differences.
#
# _ot-kernel_tls_support assumes traveler or brick-and-mortar customer context
# so open ended.
# _ot-kernel_checkpoint_dss_tls_requirement assumes the possibilities of
# business or government contractor so restrictive.
#
_ot-kernel_tls_support() {
	# See also
	# https://en.wikipedia.org/wiki/Transport_Layer_Security#TLS_1.3
	# https://en.wikipedia.org/wiki/Transport_Layer_Security#Cipher
	# https://github.com/torvalds/linux/blob/v6.9/net/tls/tls_main.c#L102
	if [[ "${work_profile}" =~ "dss" ]] ; then
	# Set in _ot-kernel_checkpoint_dss_tls_requirement
		:
	else
		local tls="${TLS:-1}"
		local tls_region="${TLS_REGION:-west}"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		if [[ "${tls_region}" =~ "cn" && "${tls}" == "1" ]] ; then
	# TLS 1.2, TLS 1.3 on a few websites.
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
		elif [[ "${tls_region}" =~ "ru" && "${tls}" == "1" ]] ; then
	# TLS 1.3
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
		elif [[ "${tls}" != "1" ]] ; then
	# CONFIG_TLS adds AES.
			ot-kernel_unset_configopt "CONFIG_TLS"
			ot-kernel_unset_configopt "CONFIG_TLS_DEVICE"
		else
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"

	# Optional in spec
	# AEAD stream cipher
	# Stream ciphers have lower latency but lowered security guarantees.
			_ot-kernel-pkgflags_chacha20_poly1305
		fi

	# Authenticated Encryption with Associated Data (AEAD) set with
	# confidentiality and authenticity guarantees.
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CCM"
		_ot-kernel-pkgflags_gcm

		if [[ "${tls}" == "1" || "${tls_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
	#
	# Required for TLS.
	# https://datatracker.ietf.org/doc/html/rfc8446#section-9.1
	#
	# We use CBC as a workaround for _ot-kernel-pkgflags_aes to add the
	# accelerated AES cipher because the wrapper is kind of broken.  Most
	# connections observed use GCM.
	#
			_ot-kernel-pkgflags_aes	CCM GCM				# Observed for .cn, .hk, .jp, .ru, .com (us)
			if [[ "${tls_region}" =~ "jp" ]] ; then
				_ot-kernel-pkgflags_sha1			# Observed for .jp, TLS 1.2
			fi
			_ot-kernel-pkgflags_sha256				# Observed for .cn, .hk, .jp, .ru, .com (us)
			_ot-kernel-pkgflags_sha512				# Observed for .cn, .hk. .jp, .ru.  Includes sha384
		fi
		if [[ "${tls_region}" =~ "cn" ]] ; then
			_ot-kernel-pkgflags_sm4
		fi
		if [[ "${tls_region}" =~ "jp" ]] ; then
	# TLS 1.2
			_ot-kernel-pkgflags_camellia
		fi
		if [[ "${tls_region}" =~ "kr" ]] ; then
	# TLS 1.2, but .kr websites use TLS 1.3 with AES-GCM
			_ot-kernel-pkgflags_aria
		fi
		if [[ "${tls_region}" =~ "ru" ]] ; then
	# TLS 1.2
			_ot-kernel-pkgflags_kuznyechik
		fi

	# Key Agreement (TLS Handshaking)
		if [[ "${tls}" == "1" || "${tls_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
	# See also
	# https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-8
			ot-kernel_y_configopt "CONFIG_CRYPTO_RSA"		# Observed for .cn, .hk, .jp, .ru, .com (us)
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDH"		# Observed for .jp
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDSA"		# Observed for .cn, .hk, .jp, .ru
		fi
		if [[ "${tls_region}" =~ "cn" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SM2"
		fi
		if [[ "${tls_region}" =~ "ru" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECRDSA"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openssl
# @DESCRIPTION:
# Applies kernel config flags for the openssl package
ot-kernel-pkgflags_openssl() { # DONE
	local pkg="dev-libs/openssl"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if \
			ot-kernel_has_version "${pkg}[ktls]" \
				&& \
			ver_test "${KV_MAJOR_MINOR}" -ge "4.18" \
		; then
			_ot-kernel_tls_support
			if ot-kernel_has_version "${pkg}[test]" ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_opentabletdriver
# @DESCRIPTION:
# Applies kernel config flags for the opentabletdriver package
ot-kernel-pkgflags_opentabletdriver() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/OpenTabletDriver" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openvpn
# @DESCRIPTION:
# Applies kernel config flags for the openvpn package
ot-kernel-pkgflags_openvpn() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/openvpn" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openvswitch
# @DESCRIPTION:
# Applies kernel config flags for the openvswitch package
ot-kernel-pkgflags_openvswitch() { # DONE
	local pkg="net-misc/openvswitch"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NET_CLS_ACT"
		ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
		ot-kernel_y_configopt "CONFIG_NET_SCH_INGRESS"
		ot-kernel_y_configopt "CONFIG_NET_ACT_POLICE"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
		_ot-kernel-pkgflags_tun
		if ot-kernel_has_version "${pkg}[modules]" ; then
		        ot-kernel_unset_configopt "CONFIG_OPENVSWITCH"
		else
		        ot-kernel_y_configopt "CONFIG_OPENVSWITCH"
		fi
	fi
}


# @FUNCTION: _ot-kernel-pkgflags_has_yubikey
# @DESCRIPTION:
# Autodetects yubikey by packages installed or USE flags requested
_ot-kernel-pkgflags_has_yubikey() {
	if \
		   ot-kernel_has_version "app-admin/keepassxc[yubikey]" \
		|| ot-kernel_has_version "app-admin/passwordsafe[yubikey]" \
		|| ot-kernel_has_version "sys-auth/ykpers" \
	; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_pam_u2f
# @DESCRIPTION:
# Applies kernel config flags for the pam_u2f package
ot-kernel-pkgflags_pam_u2f() { # DONE
	if \
		ot-kernel_has_version_pkgflags "sys-auth/pam_u2f" \
			&& \
		( \
			_ot-kernel-pkgflags_has_yubikey \
				|| \
			[[ \
				"${YUBIKEY}" == "1" \
			]] \
		) \
	; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qdmr
# @DESCRIPTION:
# Applies kernel config flags for the qdmr package
ot-kernel-pkgflags_qdmr() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/qdmr" ; then
		ot-kernel_y_configopt "CONFIG_USB_ACM"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kvm_host_required
# @DESCRIPTION:
# Adds required frags for the KVM host.
ot-kernel-pkgflags_kvm_host_required() {
	ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
	ot-kernel_y_configopt "CONFIG_VIRTUALIZATION"
	# It enables the MMU_NOTIFIER indirectly. \
	ot-kernel_y_configopt "CONFIG_KVM"
	# Don't use lscpu/cpuinfo autodetect if using distcc or
	# cross-compile but use the config itself to guestimate.
	if [[ "${arch}" == "x86_64" ]] ; then
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_KVM_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_KVM_AMD"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kvm_guest_required
# @DESCRIPTION:
# Adds required frags for the KVM guest.
ot-kernel-pkgflags_kvm_guest_required() {
	ot-kernel_y_configopt "CONFIG_HYPERVISOR_GUEST"
	ot-kernel_y_configopt "CONFIG_PARAVIRT"
	ot-kernel_y_configopt "CONFIG_KVM_GUEST"
}

# @FUNCTION: ot-kernel-pkgflags_kvm_host_extras
# @DESCRIPTION:
# Adds extra frags for the KVM host.
ot-kernel-pkgflags_kvm_host_extras() {
	local cmd
	if [[ "${KVMGT:-0}" == "1" ]] \
		&& grep -q -E -e "^CONFIG_KVM=(y|m)" "${path_config}" ; then
		# For hosts only
		ot-kernel_y_configopt "CONFIG_VFIO"
		ot-kernel_y_configopt "CONFIG_VFIO_MDEV"
		if [[ "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915"
			ot-kernel_y_configopt "CONFIG_DRM_I915_GVT"
			ot-kernel_y_configopt "CONFIG_DRM_I915_GVT_KVMGT"
einfo "Adding i915.enable_gvt=1 to kernel command line"
			ot-kernel_set_kconfig_kernel_cmdline "i915.enable_gvt=1"
		fi
	fi

	if [[ "${KVM_ADD_IGNORE_MSRS_EQ_1:-1}" == "1" ]] ; then
einfo "Adding kvm.ignore_msrs=1 to kernel command line"
		ot-kernel_set_kconfig_kernel_cmdline "kvm.ignore_msrs=1"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kvm_guest_extras
# @DESCRIPTION:
# Adds extra frags for the KVM guest.
ot-kernel-pkgflags_kvm_guest_extras() {
	if [[ "${KVM_GUEST_MEM_HOTPLUG:-0}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTPLUG"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTREMOVE"
		ot-kernel_y_configopt "CONFIG_MIGRATION"
	fi
	if [[ "${KVM_GUEST_PCI_HOTPLUG:-0}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI_ACPI"
	fi
	if [[ "${KVM_GUEST_VIRTIO_BALLOON:-0}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_VIRTIO_BALLOON"
	fi
	if [[ "${KVM_GUEST_VIRTIO_CONSOLE:-0}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_VIRTIO_CONSOLE"
	fi
	if [[ "${KVM_GUEST_VIRTIO_MEM:-1}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTPLUG_SPARSE"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTREMOVE"
		ot-kernel_y_configopt "CONFIG_CONTIG_ALLOC"
		ot-kernel_y_configopt "CONFIG_VIRTIO_MEM"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_tun
# @DESCRIPTION:
# Adds support for TUN/TAP.
_ot-kernel-pkgflags_tun() {
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_CORE"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_TUN"
}

# @FUNCTION: _ot-kernel-pkgflags_tcpip
# @DESCRIPTION:
# Adds support for TCP/IP
_ot-kernel-pkgflags_tcpip() {
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_INET"
}

# @FUNCTION: ot-kernel-pkgflags_qingy
# @DESCRIPTION:
# Applies kernel config flags for the qingy package
ot-kernel-pkgflags_qingy() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/qingy" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qemu
# @DESCRIPTION:
# Applies kernel config flags for the QEMU package.
ot-kernel-pkgflags_qemu() { # DONE
	local pkg="app-emulation/qemu"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		if [[ "${QEMU_HOST:-1}" == "1" ]] ; then
			ot-kernel-pkgflags_kvm_host_required
			ot-kernel-pkgflags_kvm_host_extras
		fi
		if ot-kernel_has_version "${pkg}[vhost-net]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_EVENTFD"
			ot-kernel_y_configopt "CONFIG_VHOST_MENU"
			ot-kernel_y_configopt "CONFIG_VHOST_NET"
			_ot-kernel-pkgflags_tun
		fi
		if [[ "${QEMU_ETHERNET_BRIDGING:-1}" == "1" ]] ; then
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_BRIDGE"
		fi
		if [[ "${QEMU_GUEST_LINUX:-0}" == "1" ]] ; then
			ot-kernel-pkgflags_kvm_guest_required
			ot-kernel_y_configopt "CONFIG_VIRTIO_MENU"
			ot-kernel_y_configopt "CONFIG_VIRTIO_PCI"
			ot-kernel_y_configopt "CONFIG_VIRTIO"
			ot-kernel_y_configopt "CONFIG_BLK_DEV"
			ot-kernel_y_configopt "CONFIG_VIRTIO_BLK"
			ot-kernel_y_configopt "CONFIG_SCSI"
			ot-kernel_y_configopt "CONFIG_SCSI_LOWLEVEL"
			ot-kernel_y_configopt "CONFIG_SCSI_VIRTIO"
			ot-kernel_y_configopt "CONFIG_NETDEVICES"
			ot-kernel_y_configopt "CONFIG_NET_CORE"
			ot-kernel_y_configopt "CONFIG_VIRTIO_NET"
			ot-kernel_y_configopt "CONFIG_HW_RANDOM"
			ot-kernel_y_configopt "CONFIG_HW_RANDOM_VIRTIO"
			ot-kernel-pkgflags_kvm_guest_extras
		fi
		if ot-kernel_has_version "${pkg}[python]" ; then
			ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS"
			needs_debugfs
			ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		fi

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"

		if ot-kernel_has_version "${pkg}[test]" ; then
			_ot-kernel_set_shmem
		fi

		# _ot-kernel_y_thp # slower but supported
		local machine_type
		if lscpu | grep -q -e "Virtualization type:.*full" ; then
			machine_type="guest"
		else
			machine_type="host"
		fi

		# Encrypt virtual machine memory (SEV) and registers (SEV-ES)
		if [[ \
			   "${hardening_level}" == "custom" \
			|| "${hardening_level}" == "manual" \
		]] ; then
einfo "SEV is using custom settings for KVM ${machine_type}"
			:
		elif _ot-kernel_is_hardening_level_secure ; then
einfo "SEV is using defaults for KVM ${machine_type}"
			ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm_amd.sev=[01]"
			ot-kernel_unset_pat_kconfig_kernel_cmdline "mem_encrypt=(on|off)"
		elif _ot-kernel_is_hardening_level_least_secure ; then
einfo "SEV is disabled for KVM ${machine_type}"
			ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm_amd.sev=[01]"
			ot-kernel_unset_pat_kconfig_kernel_cmdline "mem_encrypt=(on|off)"
			ot-kernel_set_kconfig_kernel_cmdline "mem_encrypt=off"
			ot-kernel_set_kconfig_kernel_cmdline "kvm_amd.sev=0"
		elif _ot-kernel_is_hardening_level_most_secure ; then
			local sev=0
			for o in $(cat "${path}" | sed -e "s|^$|;|") ; do
				echo "${o}" \
					| grep -q -e "AuthenticAMD" \
					|| continue
				local cpu_family=$(echo "${o}" \
					| grep "cpu family" \
					| grep -o -E -e "[0-9]+")
				local cpu_model_name=$(echo "${o}" \
					| grep "model name" \
					| cut -f 2 -d ":" \
					| sed -e "s|^ ||g")
				if [[ "${cpu_family}" =~ ("23"|"25") ]] ; then
					sev=1
				fi
			done
			if [[ ${SEV:-0} =~ "1" ]] && (( ${sev} == 1 )) ; then
				if ! has_version "sys-kernel/linux-firmware" ; then
eerror
eerror "Install sys-kernel/linux-firmware first to install SEV firmware."
eerror
					die
				fi
				local cmd=$(grep "CONFIG_CMDLINE=" "${BUILD_DIR}/.config" | sed -e "s|CONFIG_CMDLINE=\"||g" -e "s|\"$||g")
				if ! [[ "${cmd}" =~ "amd/amd_sev_fam" ]] ; then
					local hash=$(echo -n "sys-kernel/linux-firmware" \
						| sha512sum \
						| cut -f 1 -d " " \
						| cut -c 1-7)
eerror
eerror "You must add the sev firmware to CONFIG_CMDLINE or remove ${hash} from"
eerror "OT_KERNEL_PKGFLAGS_REJECT."
eerror
					die
				fi
einfo "SEV is enabled for KVM ${machine_type}"
				ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm_amd.sev=[01]"
				ot-kernel_unset_pat_kconfig_kernel_cmdline "mem_encrypt=(on|off)"
				ot-kernel_set_kconfig_kernel_cmdline "mem_encrypt=on"
				ot-kernel_set_kconfig_kernel_cmdline "kvm_amd.sev=1"
			else
einfo "SEV is disabled for KVM ${machine_type}"
				ot-kernel_unset_pat_kconfig_kernel_cmdline "kvm_amd.sev=[01]"
				ot-kernel_set_kconfig_kernel_cmdline "kvm_amd.sev=0"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qtcore
# @DESCRIPTION:
# Applies kernel config flags for the qtcore package.
ot-kernel-pkgflags_qtcore() { # DONE
	if ot-kernel_has_version_pkgflags "dev-qt/qtcore" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qtgreet
# @DESCRIPTION:
# Applies kernel config flags for the qtgreet package
ot-kernel-pkgflags_qtgreet() { # DONE
	if ot-kernel_has_version_pkgflags "gui-apps/qtgreet" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_portage
# @DESCRIPTION:
# Applies kernel config flags for the portage package
ot-kernel-pkgflags_portage() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/portage" ; then

	# These are not required.  It's only used for sandboxing.
	# Portage will still function if you disable them from FEATURES.
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_uts_ns

	# The 4567_distro-Gentoo-Kconfig.patch will enable cgroups but it was
	# dropped and FEATURES=pid-sandbox was recommended instead.

	# Required for USER portage
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pcmciautils
# @DESCRIPTION:
# Applies kernel config flags for the pcmciautils package
ot-kernel-pkgflags_pcmciautils() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/pcmciautils" ; then
		ot-kernel_y_configopt "CONFIG_PCMCIA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pesign
# @DESCRIPTION:
# Applies kernel config flags for the pesign package
ot-kernel-pkgflags_pesign() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/pesign" ; then
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_unset_configopt "CONFIG_X86_USE_3DNOW"
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_y_configopt "CONFIG_EFI_STUB"

		ot-kernel_y_configopt "CONFIG_ASYMMETRIC_KEY_TYPE"
		ot-kernel_y_configopt "CONFIG_SIGNED_PE_FILE_VERIFICATION"
		ot-kernel_y_configopt "CONFIG_PKCS7_MESSAGE_PARSER"
		ot-kernel_y_configopt "CONFIG_SYSTEM_DATA_VERIFICATION"
		ot-kernel_y_configopt "CONFIG_BZIMAGE_VERIFY_SIG"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_cpu_pmu_events_oprofile
# @DESCRIPTION:
# Auto enables extra CPU PMU performance events for oprofile
_ot-kernel-pkgflags_cpu_pmu_events_oprofile() {
	if ver_test "${KV_MAJOR_MINOR}" -le "5.11" ; then
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		if [[ "${arch}" =~ ("arm") ]] ; then
			ot-kernel_y_configopt "CONFIG_ARM_PMU"
			ot-kernel_y_configopt "CONFIG_HW_PERF_EVENTS"
		fi
		if [[ "${arch}" == "sh" ]] ; then
			ot-kernel_y_configopt "CONFIG_HW_PERF_EVENTS"
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_cpu_pmu_events_perf
# @DESCRIPTION:
# Auto enables extra CPU PMU performance events for perf
_ot-kernel-pkgflags_cpu_pmu_events_perf() {
	ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	if [[ "${arch}" =~ ("arm") ]] ; then
		ot-kernel_y_configopt "CONFIG_ARM_PMU"
		ot-kernel_y_configopt "CONFIG_HW_PERF_EVENTS"
	fi
	if [[ "${arch}" == "arm" ]] ; then
		if grep -q -E -e "^CONFIG_CACHE_L2X0=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_CACHE_L2X0_PMU"
		fi
	fi
	if [[ "${arch}" == "sh" ]] ; then
		ot-kernel_y_configopt "CONFIG_HW_PERF_EVENTS"
	fi
	if [[ "${arch}" == "powerpc" ]] ; then
		if \
			     grep -q -E -e "^CONFIG_PPC_HAVE_PMU_SUPPORT=y" "${path_config}" \
			&& ! grep -q -E -e "^CONFIG_FSL_EMB_PERF_EVENT=y" "${path_config}"
		then
			ot-kernel_y_configopt "CONFIG_PPC_PERF_CTRS"
		fi
		if grep -q -E -e "^CONFIG_E500=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_FSL_EMB_PERFMON"
			ot-kernel_y_configopt "CONFIG_FSL_EMB_PERF_EVENT"
			ot-kernel_y_configopt "CONFIG_FSL_EMB_PERF_EVENT_E500"
		fi
		if [[ "${E300C3:-0}" == "1" || "${E300C4:-0}" == "1" ]] \
			|| ( \
				     grep -q -E -e "^CONFIG_PPC_83xx=y" "${path_config}" \
				&& ! grep -q -E -e "^CONFIG_FSL_EMB_PERF_EVENT=y" "${path_config}" \
				&& ! tc-is-cross-compiler \
				&& ( cat /proc/cpuinfo | grep -E -q -e "(e300c3|e300c4)" ) \
			)
		then
			ot-kernel_y_configopt "CONFIG_PPC_8xx_PERF_EVENT"
			ot-kernel_y_configopt "CONFIG_FSL_EMB_PERFMON"
			ot-kernel_y_configopt "CONFIG_FSL_EMB_PERF_EVENT"
		fi
	fi
	if [[ "${arch}" == "riscv" ]] ; then
		ot-kernel_set_configopt "CONFIG_RISCV_BASE_PMU" "m"
	fi
	if [[ "${arch}" =~ ("x86") ]] ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		# Guess based on hints from kconfig
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_CPU_SUP_INTEL"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_UNCORE" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_RAPL" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_CSTATE" "m"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_CPU_SUP_AMD"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_RAPL" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_AMD_POWER" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_AMD_UNCORE" "m"
		fi

		# Dependencies
		ot-kernel_y_configopt "CONFIG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_perf
# @DESCRIPTION:
# Applies kernel config flags for the perf package
ot-kernel-pkgflags_perf() { # DONE
	local pkg="dev-util/perf"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		_ot-kernel-pkgflags_cpu_pmu_events_perf
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"

		if [[ "${arch}" =~ ("arm"|"sh"|"mips") ]] ; then
			ot-kernel_y_configopt "CONFIG_KALLSYMS"
		fi

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_FUTEX2"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_perl
# @DESCRIPTION:
# Applies kernel config flags for the perl package
ot-kernel-pkgflags_perl() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/perl" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pf_ring_kmod
# @DESCRIPTION:
# Applies kernel config flags for the pf_ring-kmod package
ot-kernel-pkgflags_pf_ring_kmod() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/pf_ring-kmod" ; then
		ot-kernel_y_configopt "CONFIG_NET"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pglinux
# @DESCRIPTION:
# Applies kernel config flags for the pglinux package
ot-kernel-pkgflags_pglinux() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/pglinux" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_IPRANGE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_DEFRAG_IPV4"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_php
# @DESCRIPTION:
# Applies kernel config flags for the php package
ot-kernel-pkgflags_php() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/php" ; then
		_ot-kernel_y_thp # ~3% improvement
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pipewire
# @DESCRIPTION:
# Applies kernel config flags for the pipewire package
ot-kernel-pkgflags_pipewire() { # DONE
	local pkg="media-video/pipewire"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_so_attach_filter "${pkg}" # SO_ATTACH_FILTER, BPF_STMT, cBPF
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_plocate
# @DESCRIPTION:
# Applies kernel config flags for the plocate package
ot-kernel-pkgflags_plocate() { # DONE
	local pkg="sys-apps/plocate"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[io-uring]" \
	; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_io_uring
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ply
# @DESCRIPTION:
# Applies kernel config flags for the ply package
ot-kernel-pkgflags_ply() { # DONE
	local pkg="dev-util/ply"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_bpf "${pkg}"
		ot-kernel_y_configopt "CONFIG_NET_CLS_BPF"
		ot-kernel_y_configopt "CONFIG_NET_ACT_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_plymouth
# @DESCRIPTION:
# Applies kernel config flags for the plymouth package
ot-kernel-pkgflags_plymouth() { # DONE
	if ot-kernel_has_version_pkgflags "sys-boot/plymouth" ; then
		ot-kernel_unset_configopt "CONFIG_LOGO"
		if grep -q -E -e "^CONFIG_DRM_I915=(y|m)" "${path_config}" \
			&& ver_test "${KV_MAJOR_MINOR}" -le "4.2"  ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_KMS"
		fi
		if grep -q -E -e "^CONFIG_DRM_RADEON=(y|m)" "${path_config}" \
			&& ver_test "${KV_MAJOR_MINOR}" -le "3.8"  ; then
			ot-kernel_y_configopt "CONFIG_DRM_RADEON_KMS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_podman
# @DESCRIPTION:
# Applies kernel config flags for the podman package
ot-kernel-pkgflags_podman() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/podman" ; then
		_ot-kernel_set_user_ns
		if ot-kernel_has_version "app-containers/podman[btrfs]" ; then
			ot-kernel_y_configopt "CONFIG_BTRFS_FS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_polkit
# @DESCRIPTION:
# Applies kernel config flags for the polkit package
ot-kernel-pkgflags_polkit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-auth/polkit" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX" # For better performance
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pommed
# @DESCRIPTION:
# Applies kernel config flags for the pommed package
ot-kernel-pkgflags_pommed() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/pommed" ; then
		ot-kernel_y_configopt "CONFIG_DMIID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ponyprog
# @DESCRIPTION:
# Applies kernel config flags for the ponyprog package
ot-kernel-pkgflags_ponyprog() { # DONE
	if ot-kernel_has_version_pkgflags "dev-embedded/ponyprog" ; then
		ot-kernel_y_configopt "CONFIG_SERIO"
		ot-kernel_y_configopt "CONFIG_SERIO_SERPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT_PC"
		ot-kernel_y_configopt "CONFIG_PPDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_popura
# @DESCRIPTION:
# Applies kernel config flags for the popura package
ot-kernel-pkgflags_popura() { # DONE
	if ot-kernel_has_version_pkgflags "net-p2p/popura" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pulseaudio
# @DESCRIPTION:
# Applies kernel config flags for the pulseaudio package
ot-kernel-pkgflags_pulseaudio() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/pulseaudio" ; then
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pulseaudio_daemon
# @DESCRIPTION:
# Applies kernel config flags for the pulseaudio_daemon package
ot-kernel-pkgflags_pulseaudio_daemon() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/pulseaudio-daemon" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pqiv
# @DESCRIPTION:
# Applies kernel config flags for the pqiv package
ot-kernel-pkgflags_pqiv() { # DONE
	if ot-kernel_has_version_pkgflags "media-gfx/pqiv" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pv
# @DESCRIPTION:
# Applies kernel config flags for the pv package
ot-kernel-pkgflags_pv() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/pv" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_python
# @DESCRIPTION:
# Applies kernel config flags for the python package
ot-kernel-pkgflags_python() { # DONE
	local pkg="dev-lang/python"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
		if ot-kernel_has_version ">=${pkg}-3.8" ; then
			_ot-kernel_y_thp # Has symbol but not used
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_postgresql
# @DESCRIPTION:
# Applies kernel config flags for the postgresql package
ot-kernel-pkgflags_postgresql() { # DONE
	local pkg="dev-db/postgresql"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[server]" \
	; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powernowd
# @DESCRIPTION:
# Applies kernel config flags for the powernowd package
ot-kernel-pkgflags_powernowd() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/powernowd" ; then
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ppp
# @DESCRIPTION:
# Applies kernel config flags for the ppp package
ot-kernel-pkgflags_ppp() { # DONE
	local pkg="net-dialup/ppp"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
		ot-kernel_y_configopt "CONFIG_PPP_SYNC_TTY"
		if ot-kernel_has_version "${pkg}[activefilter]" ; then
			ot-kernel_y_configopt "CONFIG_PPP_FILTER"
		fi
		ot-kernel_y_configopt "CONFIG_PPP_DEFLATE"
		ot-kernel_y_configopt "CONFIG_PPP_BSDCOMP"
		ot-kernel_y_configopt "CONFIG_PPP_MPPE"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_PACKET"
		if ot-kernel_has_version "${pkg}[atm]" ; then
			ot-kernel_y_configopt "CONFIG_PPPOATM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_procps
# @DESCRIPTION:
# Applies kernel config flags for the procps package
ot-kernel-pkgflags_procps() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/procps" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL" # For sysctl
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powertop
# @DESCRIPTION:
# Applies kernel config flags for the powertop package
ot-kernel-pkgflags_powertop() { # DONE
	local pkg="sys-power/powertop"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS, CONFIG_FTRACE, CONFIG_TRACING_SUPPORT, CONFIG_TRACING, CONFIG_TRACEPOINTS, CONFIG_PM_DEBUG, CONFIG_PM_ADVANCED_DEBUG"
		needs_debugfs
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"

		ot-kernel_y_configopt "CONFIG_TRACING"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_NO_HZ_IDLE"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_y_configopt "CONFIG_HPET_TIMER"

		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ_STAT"
		if ver_test "${KV_MAJOR_MINOR}" -le "4.10" ; then
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_STAT_DETAILS"
		fi

		ot-kernel_y_configopt "CONFIG_PM"
		ot-kernel_y_configopt "CONFIG_PM_DEBUG"
		ot-kernel_y_configopt "CONFIG_PM_ADVANCED_DEBUG"

		ot-kernel_y_configopt "CONFIG_CPU_FREQ_GOV_ONDEMAND"
		ot-kernel_y_configopt "CONFIG_TRACING_SUPPORT"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
		ot-kernel_y_configopt "CONFIG_TRACING"

		if ver_test "${KV_MAJOR_MINOR}" -lt "3.7" ; then
			if grep -q -E -e "^CONFIG_SND_HDA_INTEL=(y|m)" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_SND_HDA_POWER_SAVE"
			fi
		fi
		if ver_test "${KV_MAJOR_MINOR}" -lt "3.9" ; then
			ot-kernel_y_configopt "CONFIG_EVENT_POWER_TRACING_DEPRECATED"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -lt "3.13" ; then
			ot-kernel_y_configopt "CONFIG_PM_RUNTIME"
		else
			ot-kernel_y_configopt "CONFIG_PM"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.11" ; then
			ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
			ot-kernel_y_configopt "CONFIG_PROC_FS"
			ot-kernel_y_configopt "CONFIG_TIMER_STATS"
		fi

		_ot-kernel-pkgflags_rapl
	fi
}

# @FUNCTION: ot-kernel-pkgflags_r8125
# @DESCRIPTION:
# Applies kernel config flags for r8125
ot-kernel-pkgflags_r8125() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/r8125" ; then
		ot-kernel_unset_configopt "CONFIG_R8169"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_r8152
# @DESCRIPTION:
# Applies kernel config flags for r8152
ot-kernel-pkgflags_r8152() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/realtek-r8152" ; then
		ot-kernel_set_configopt "CONFIG_USB_USBNET" "m"
		ot-kernel_set_configopt "CONFIG_USB_NET_CDC_NCM" "m"
		ot-kernel_set_configopt "CONFIG_USB_NET_CDCETHER" "m"
		ot-kernel_y_configopt "CONFIG_MII"
		ot-kernel_unset_configopt "CONFIG_USB_RTL8152"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_r8168
# @DESCRIPTION:
# Applies kernel config flags for r8168
ot-kernel-pkgflags_r8168() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/r8168" ; then
		ot-kernel_unset_configopt "CONFIG_R8169"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rasdaemon
# @DESCRIPTION:
# Applies kernel config flags for the rasdaemon package
ot-kernel-pkgflags_rasdaemon() { # DONE
	local pkg="app-admin/rasdaemon"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_acpi_support ; then
			ban_disable_debug "${pkg}" "CONFIG_ACPI_EXTLOG"
			ot-kernel_y_configopt "CONFIG_ACPI_EXTLOG"
		fi
		needs_debugfs
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rccl
# @DESCRIPTION:
# Applies kernel config flags for the rccl package
ot-kernel-pkgflags_rccl() { # DONE
	local pkg="dev-libs/rccl"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_DMI"
		ot-kernel_y_configopt "CONFIG_DMIID"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_DMA_SHARED_BUFFER"
		ot-kernel_y_configopt "CONFIG_DMABUF_MOVE_NOTIFY"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_64BIT"
		ot-kernel_y_configopt "CONFIG_PCI_P2PDMA"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_INFINIBAND"
		ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_ETHERNET"
		ot-kernel_y_configopt "CONFIG_NET_VENDOR_MELLANOX"
		ot-kernel_y_configopt "CONFIG_MLX5_CORE"
		ot-kernel_y_configopt "CONFIG_MLX5_INFINIBAND"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_read_edid
# @DESCRIPTION:
# Applies kernel config flags for the read-edid package
ot-kernel-pkgflags_read_edid() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/read-edid" ; then
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_recoil
# @DESCRIPTION:
# Applies kernel config flags for the recoil package
ot-kernel-pkgflags_recoil() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/recoll" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_redis
# @DESCRIPTION:
# Applies kernel config flags for the redis package
ot-kernel-pkgflags_redis() { # DONE
	if ot-kernel_has_version_pkgflags "dev-db/redis" ; then
		_ot-kernel_y_thp # Added for performance reasons.  ~8-16% benefit
	fi
}

# @FUNCTION: ot-kernel-pkgflags_roct
# @DESCRIPTION:
# Applies kernel config flags for roct
ot-kernel-pkgflags_roct() { # DONE
	if \
		ot-kernel_has_version_pkgflags "dev-libs/roct-thunk-interface" \
		|| ( has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ) \
	; then
	# It enables the MMU_NOTIFIER indirectly. \
		ot-kernel_y_configopt "CONFIG_HSA_AMD"
		ot-kernel_y_configopt "CONFIG_HMM_MIRROR"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		if \
			 ! has rock-dkms ${IUSE_EFFECTIVE} \
		; then
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		elif \
			   has rock-dkms ${IUSE_EFFECTIVE} \
			&& ot-kernel_use rock-dkms \
			&& ( \
				   ver_test "${KV_MAJOR_MINOR}" -eq "5.4" \
				|| ver_test "${KV_MAJOR_MINOR}" -eq "5.15" \
			) \
		; then
	# For sys-kernel/rock-dkms not installed yet scenario.
			ot-kernel_y_configopt "CONFIG_MODULES"
			ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"
		else
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		fi
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_USERPTR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rocksdb
# @DESCRIPTION:
# Applies kernel config flags for rocksdb
ot-kernel-pkgflags_rocksdb() { # DONE
	local pkg="dev-libs/rocksdb"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_io_uring
		if ot-kernel_has_version "<${pkg}-7" ; then
			ot-kernel_y_configopt "CONFIG_FUTEX"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rr
# @DESCRIPTION:
# Applies kernel config flags for rr
ot-kernel-pkgflags_rr() { # DONE
	local pkg="dev-util/rr"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
	# The distro ebuild is missing seccomp-bpf flags.
		_ot-kernel_set_seccomp_bpf "${pkg}"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ruby
# @DESCRIPTION:
# Applies kernel config flags for ruby
ot-kernel-pkgflags_ruby() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/ruby" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		_ot-kernel_set_shmem
		# ot-kernel_y_configopt "CONFIG_DNOTIFY" # Not really used
	fi
}

# @FUNCTION: ot-kernel-pkgflags_runit
# @DESCRIPTION:
# Applies kernel config flags for the runit package
ot-kernel-pkgflags_runit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/runit" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! scripts
		ot-kernel_y_configopt "CONFIG_FILE_LOCKING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rstudio_desktop_bin
# @DESCRIPTION:
# Applies kernel config flags for the rstudio-desktop-bin package
ot-kernel-pkgflags_rstudio_desktop_bin() { # DONE
	if ot-kernel_has_version_pkgflags "sci-mathematics/rstudio-desktop-bin" ; then
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rsyslog
# @DESCRIPTION:
# Applies kernel config flags for the rsyslog package
ot-kernel-pkgflags_rsyslog() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/rsyslog" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtirq
# @DESCRIPTION:
# Applies kernel config flags for the rtirq package
ot-kernel-pkgflags_rtirq() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/rtirq" ; then
		if grep -q -e "config PREEMPT_RT" "${BUILD_DIR}/kernel/Kconfig.preempt" ; then
			ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
		else
			ot-kernel_unset_configopt "CONFIG_IRQ_FORCED_THREADING" # Set by the arch
			ot-kernel_set_kconfig_kernel_cmdline "threadirqs"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtkit
# @DESCRIPTION:
# Applies kernel config flags for the rtkit package
ot-kernel-pkgflags_rtkit() { # DONE
	if ot-kernel_has_version_pkgflags "sys-auth/rtkit" ; then
# FIXME: most secure
		if _ot-kernel_is_hardening_level_custom ; then
			:
		elif _ot-kernel_is_hardening_level_secure ; then
			ot-kernel_unset_configopt "CONFIG_RT_GROUP_SCHED"
		elif _ot-kernel_is_hardening_level_least_secure ; then
			ot-kernel_unset_configopt "CONFIG_RT_GROUP_SCHED"
		else
			ot-kernel_y_configopt "CONFIG_RT_GROUP_SCHED"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtl8821ce
# @DESCRIPTION:
# Applies kernel config flags for the rtl8821ce package
ot-kernel-pkgflags_rtl8821ce() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/rtl8821ce" ; then
		ot-kernel_unset_configopt "CONFIG_RTW88_8821CE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtl8192eu
# @DESCRIPTION:
# Applies kernel config flags for the rtl8192eu package
ot-kernel-pkgflags_rtl8192eu() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/rtl8192eu" ; then
		ot-kernel_unset_configopt "CONFIG_RTL8XXXU"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtsp_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the rtsp-conntrack package
ot-kernel-pkgflags_rtsp_conntrack() { # DONE
	if ot-kernel_has_version_pkgflags "net-firewall/rtsp-conntrack" ; then
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_runc
# @DESCRIPTION:
# Applies kernel config flags for the runc package
ot-kernel-pkgflags_runc() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/runc" ; then
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rust
# @DESCRIPTION:
# Applies kernel config flags for the rust package
ot-kernel-pkgflags_rust() { # DONE
	local pkg=""
	if ot-kernel_has_version_pkgflags "dev-lang/rust" ; then
		pkg="dev-lang/rust"
	elif ot-kernel_has_version "dev-lang/rust-bin" ; then
		pkg="dev-lang/rust-bin"
	fi
	if [[ -n "${pkg}" ]] ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		# _ot-kernel_set_bpf "${pkg}" # Referenced but not used explicitly
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_FUTEX2"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_s6
# @DESCRIPTION:
# Applies kernel config flags for the s6 package
ot-kernel-pkgflags_s6() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/s6-linux-init" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! scripts
	fi
}

# @FUNCTION: ot-kernel-pkgflags_safeclib
# @DESCRIPTION:
# Applies kernel config flags for the safeclib package
ot-kernel-pkgflags_safeclib() { # DONE
	local pkg="sys-libs/safeclib"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[modules]" \
	; then
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_samba
# @DESCRIPTION:
# Applies kernel config flags for the samba package
ot-kernel-pkgflags_samba() { # DONE
	if ot-kernel_has_version_pkgflags "net-fs/samba" ; then
		ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_CIFS"
		ot-kernel_y_configopt "CONFIG_CIFS_STATS2"
		ot-kernel_y_configopt "CONFIG_CIFS_XATTR"
		ot-kernel_y_configopt "CONFIG_CIFS_POSIX"
		if ver_test "${KV_MAJOR_MINOR}" -le "4.12" ; then
			ot-kernel_y_configopt "CONFIG_CIFS_SMB2"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sandbox
# @DESCRIPTION:
# Applies kernel config flags for the sandbox package
ot-kernel-pkgflags_sandbox() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/sandbox" ; then
		_ot-kernel_set_shmem
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sane
# @DESCRIPTION:
# Applies kernel config flags for the sane package
ot-kernel-pkgflags_sane() { # DONE
	local pkg="media-gfx/sane-backends"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		SANE_SCSI="${SANE_SCSI:-0}"
		if [[ "${SANE_SCSI}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_SCSI"
		fi
		SANE_USB="${SANE_USB:-1}"
		if [[ "${SANE_USB}" == "1" ]] ; then
			# See ot-kernel-pkgflags_usb
			if ot-kernel_has_version "${pkg}[-usb]" ; then
ewarn "Re-emerge ${pkg}[usb] and ${PN} for USB scanner support."
			fi
			if ver_test "${KV_MAJOR_MINOR}" -le "3.4" ; then
				ot-kernel_y_configopt "CONFIG_USB_DEVICEFS"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sanewall
# @DESCRIPTION:
# Applies kernel config flags for the sanewall package
ot-kernel-pkgflags_sanewall() { # DONE
	local pkg="net-firewall/sanewall"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NF_NAT_FTP"
		ot-kernel_y_configopt "CONFIG_NF_NAT_IRC"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		ban_disable_debug "${pkg}" "CONFIG_IP_NF_TARGET_LOG, CONFIG_IP_NF_TARGET_ULOG" "NETFILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_LOG"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_ULOG"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REDIRECT"
		ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_LIMIT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_OWNER"
		if grep -q -e "CONFIG_NF_CONNTRACK_ENABLED" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_ENABLED"
		else
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sanlock
# @DESCRIPTION:
# Applies kernel config flags for the sanlock package
ot-kernel-pkgflags_sanlock() { # DONE
	if ot-kernel_has_version_pkgflags "sys-cluster/sanlock" ; then
		ot-kernel_y_configopt "CONFIG_SOFT_WATCHDOG"
		_ot-kernel-pkgflags_add_watchdog_drivers
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sbsigntools
# @DESCRIPTION:
# Applies kernel config flags for the sbsigntools package
ot-kernel-pkgflags_sbsigntools() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/sbsigntools" ; then
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_unset_configopt "CONFIG_X86_USE_3DNOW"
		ot-kernel_y_configopt "CONFIG_EFI_STUB"
		ot-kernel_y_configopt "CONFIG_CMDLINE_BOOL"
		#ot-kernel_set_kconfig_kernel_cmdline "" # FIXME
		ot-kernel_y_configopt "CONFIG_CMDLINE_OVERRIDE"
		ot-kernel_unset_configopt "CONFIG_DRM_SIMPLEDRM"
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_SIMPLE"

		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_PARTITION_ADVANCED"
		ot-kernel_y_configopt "CONFIG_EFI_PARTITION"
		ot-kernel_y_configopt "CONFIG_NLS"
		ot-kernel_y_configopt "CONFIG_NLS_ISO8859_1"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_slim
# @DESCRIPTION:
# Applies kernel config flags for the slim package
ot-kernel-pkgflags_slim() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/slim" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_smcroute
# @DESCRIPTION:
# Applies kernel config flags for the smcroute package
ot-kernel-pkgflags_smcroute() { # DONE
	local pkg="net-misc/smcroute"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE"
		ot-kernel_y_configopt "CONFIG_IP_PIMSM_V1"
		ot-kernel_y_configopt "CONFIG_IP_PIMSM_V2"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE_MULTIPLE_TABLES"
		ot-kernel_y_configopt "CONFIG_IPV6_MROUTE_MULTIPLE_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_snapd
# @DESCRIPTION:
# Applies kernel config flags for the snapd package
ot-kernel-pkgflags_snapd() { # DONE
	local pkg="app-containers/snapd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_ZLIB"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_LZO"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_XZ"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
		_ot-kernel_set_seccomp_bpf "${pkg}"
		if ot-kernel_has_version "${pkg}[apparmord]" ; then
			_OT_KERNEL_LSM_ADD_APPARMOR=1
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_souper
# @DESCRIPTION:
# Applies kernel config flags for the souper package
ot-kernel-pkgflags_souper() { # DONE
	local pkg="sys-devel/souper"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[external-cache,tcp]" ; then
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
		fi
		if ot-kernel_has_version "${pkg}[external-cache,usockets]" ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_UNIX"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spacenavd
# @DESCRIPTION:
# Applies kernel config flags for the spacenavd package
ot-kernel-pkgflags_spacenavd() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/spacenavd" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spice_vdagent
# @DESCRIPTION:
# Applies kernel config flags for the spice-vdagent package
ot-kernel-pkgflags_spice_vdagent() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/spice-vdagent" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_VIRTIO_CONSOLE"
	fi
}

# @FUNCTION: _ot-kernel_pkgflags_squashfs
# @DESCRIPTION:
# Applies kernel config flags for the squashfs packages
_ot-kernel_pkgflags_squashfs() {
	if grep -q -e "^CONFIG_SQUASHFS=y" "${path_config}" ; then
		if [[ "${SQUASHFS_ZLIB:-1}" == "1" ]] ; then
einfo "Added SquashFS ZLIB decompression support (for fallback and compatibility reasons)"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_ZLIB"
		fi
		if [[ "${SQUASHFS_4K_BLOCK_SIZE:-1}" == "1" ]] ; then
einfo "SquashFS 4k block transfer for optimized increased throughput applied"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_4K_DEVBLK_SIZE"
		else
einfo "SquashFS 1k block transfer for optimized lowered latency applied"
			ot-kernel_n_configopt "CONFIG_SQUASHFS_4K_DEVBLK_SIZE"
		fi
		if [[ "${SQUASHFS_XATTR:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_SQUASHFS_XATTR"
		else
			ot-kernel_n_configopt "CONFIG_SQUASHFS_XATTR"
		fi
		ot-kernel_n_configopt "CONFIG_SQUASHFS_DECOMP_SINGLE"
		ot-kernel_n_configopt "CONFIG_SQUASHFS_DECOMP_MULTI"
		ot-kernel_n_configopt "CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU"
		if [[ "${SQUASHFS_DECOMPRESSORS_PER_CORE:-auto}" == "auto" ]] ; then
			local tpc=$(lscpu \
				| sed -r -e "s|^[ ]+||g" \
				| grep "^Thread(s) per core:" \
				| grep -E -o -e "[0-9]+")
			local mc=$(lscpu \
				| sed -r -e "s|^[ ]+||g" \
				| grep "^CPU(s):" \
				| grep -E -o -e "[0-9]+")
			if (( "${tpc}" >= 2 )) ; then
				ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_MULTI"
			elif (( "${mc}" >= 2 )) ; then
				ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU"
			else
				ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_SINGLE"
			fi
		elif [[ "${SQUASHFS_DECOMPRESSORS_PER_CORE}" =~ ("1uni"|"1up") ]] ; then
			# 1uni = 1up = uniprocessor = single decompression thread total
einfo "SquashFS single thread applied"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_SINGLE"
		elif [[ "${SQUASHFS_DECOMPRESSORS_PER_CORE}" =~ ([a-z]|[A-Z]) ]] ; then
eerror "SQUASHFS_DECOMPRESSORS_PER_CORE must be 1, 2, 1up"
			die
		elif (( ${SQUASHFS_DECOMPRESSORS_PER_CORE} <= 1 )) ; then
einfo "SquashFS multicore decompression applied (CPU Cores: ${mc})"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU"
		elif (( ${SQUASHFS_DECOMPRESSORS_PER_CORE} >= 2 )) ; then
einfo "SquashFS multi-threaded decompression applied (Threads Per Core: ${tpc})"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_DECOMP_MULTI"
		fi
		ot-kernel_n_configopt "CONFIG_SQUASHFS_FILE_CACHE"
		ot-kernel_n_configopt "CONFIG_SQUASHFS_FILE_DIRECT"
		if [[ "${SQUASHFS_NSTEP_DECOMPRESS:-1}" == "1" ]] ; then
einfo "SquashFS direct 1-step copy applied"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_FILE_DIRECT"
		else
einfo "SquashFS 2-step intermediate copy applied"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_FILE_CACHE"
		fi
		local pkg="sys-fs/squashfs-tools"
		if ot-kernel_has_version "${pkg}[lz4]" ; then
einfo "Added SquashFS LZ4 decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_LZ4"
		fi
		if ot-kernel_has_version "${pkg}[lzo]" ; then
einfo "Added SquashFS LZO decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_LZO"
		fi
		if ot-kernel_has_version "${pkg}[lzma]" ; then
einfo "Added SquashFS XZ decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_XZ"
		fi
		if ot-kernel_has_version "${pkg}[zstd]" ; then
einfo "Added SquashFS ZSTD decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_ZSTD"
		fi
		ot-kernel_n_configopt "CONFIG_SQUASHFS_EMBEDDED"
		if [[ -n "${SQUASHFS_NFRAGS_CACHED}" ]] ; then
einfo "Changed SquashFS n-frags cached to ${SQUASHFS_NFRAGS_CACHED}"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_EMBEDDED"
			ot-kernel_set_configopt "CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE" "${SQUASHFS_NFRAGS_CACHED}"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_squashfs-tools
# @DESCRIPTION:
# Applies kernel config flags for the squashfs-tools package or for LIVE CDs
ot-kernel-pkgflags_squashfs-tools() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/squashfs-tools" ; then
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_squid
# @DESCRIPTION:
# Applies kernel config flags for the squid package
ot-kernel-pkgflags_squid() { # DONE
	local pkg="net-proxy/squid"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[tproxy]" \
	; then
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_SOCKET"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_TPROXY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sc_controller
# @DESCRIPTION:
# Applies kernel config flags for the sc-controller package
ot-kernel-pkgflags_sc_controller() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/sc-controller" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_scaphandre
# @DESCRIPTION:
# Applies kernel config flags for the scaphandre package
ot-kernel-pkgflags_scaphandre() { # DONE
	if ot-kernel_has_version_pkgflags "app-metrics/scaphandre" ; then
		ot-kernel_y_configopt "CONFIG_POWERCAP"
		ot-kernel_y_configopt "CONFIG_INTEL_RAPL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_scap_driver
# @DESCRIPTION:
# Applies kernel config flags for the scap-driver package
ot-kernel-pkgflags_scap_driver() { # DONE
	if ot-kernel_has_version_pkgflags "dev-debug/scap-driver" ; then
		ot-kernel_y_configopt "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sddm
# @DESCRIPTION:
# Applies kernel config flags for the sddm package
ot-kernel-pkgflags_sddm() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/sddm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
		ot-kernel_y_configopt "CONFIG_DRM" # has flag dependencies
	fi
}

# @FUNCTION: ot-kernel-pkgflags_session_desktop_bin
# @DESCRIPTION:
# Applies kernel config flags for the session-desktop-bin package
ot-kernel-pkgflags_session_desktop_bin() { # DONE
	if ot-kernel_has_version_pkgflags "net-im/session-desktop-bin" ; then
		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_shadow
# @DESCRIPTION:
# Applies kernel config flags for the shadow package
ot-kernel-pkgflags_shadow() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/shadow" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_simplevirt
# @DESCRIPTION:
# Applies kernel config flags for the simplevirt package
ot-kernel-pkgflags_simplevirt() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/simplevirt" ; then
		_ot-kernel-pkgflags_tun
		ot-kernel_y_configopt "CONFIG_BRIDGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_singularity
# @DESCRIPTION:
# Applies kernel config flags for the singularity package
ot-kernel-pkgflags_singularity() { # DONE
	if ot-kernel_has_version_pkgflags "sys-cluster/singularity" ; then
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_skopeo
# @DESCRIPTION:
# Applies kernel config flags for the skopeo package
ot-kernel-pkgflags_skopeo() { # DONE
	local pkg="app-containers/skopeo"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[btrfs]" ; then
			ot-kernel_y_configopt "CONFIG_BTRFS_FS"
		fi
		if ot-kernel_has_version "${pkg}[device-mapper]" ; then
			ot-kernel_y_configopt "CONFIG_MD"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_solaar
# @DESCRIPTION:
# Applies kernel config flags for the solaar package
ot-kernel-pkgflags_solaar() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/solaar" ; then
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH_DJ"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sonic_snap
# @DESCRIPTION:
# Applies kernel config flags for the sonic_snap package
ot-kernel-pkgflags_sonic_snap() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/sonic-snap" ; then
		ot-kernel_set_configopt "CONFIG_USB_SN9C102" "m"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sshuttle
# @DESCRIPTION:
# Applies kernel config flags for the sshuttle package
ot-kernel-pkgflags_sshuttle() { # DONE
	if ot-kernel_has_version_pkgflags "net-proxy/sshuttle" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_HL"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REDIRECT"
		ot-kernel_y_configopt "CONFIG_IP_NF_MATCH_TTL"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_shorewall
# @DESCRIPTION:
# Applies kernel config flags for the shorewall package
ot-kernel-pkgflags_shorewall() { # DONE
	local pkg="net-firewall/shorewall"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.19" ; then
			if ot-kernel_has_version "${pkg}[ipv4]" ; then
				_ot-kernel-pkgflags_tcpip
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
			fi
			if ot-kernel_has_version "${pkg}[ipv6]" ; then
			        _ot-kernel-pkgflags_tcpip
			        ot-kernel_y_configopt "CONFIG_IPV6"
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sssd
# @DESCRIPTION:
# Applies kernel config flags for the sssd package
ot-kernel-pkgflags_sssd() { # DONE
	if ot-kernel_has_version_pkgflags "sys-auth/sssd" ; then
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sstp_client
# @DESCRIPTION:
# Applies kernel config flags for the sstp-client package
ot-kernel-pkgflags_sstp_client() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/sstp-client" ; then
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_speedtouch_usb
# @DESCRIPTION:
# Applies kernel config flags for the speedtouch-usb package
ot-kernel-pkgflags_speedtouch_usb() { # DONE
	if ot-kernel_has_version_pkgflags "net-dialup/speedtouch-usb" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FW_LOADER"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_PACKET"
		ot-kernel_y_configopt "CONFIG_ATM"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB_DEVICEFS"
		ot-kernel_y_configopt "CONFIG_USB_ATM"
		ot-kernel_y_configopt "CONFIG_USB_SPEEDTOUCH"
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPPOATM"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_ATM_BR2684"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_steam_launcher
# @DESCRIPTION:
# Applies kernel config flags for the steam-launcher package
ot-kernel-pkgflags_steam_launcher() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/steam-launcher" ; then
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"

		# Device
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_STEAM"
		ot-kernel_y_configopt "CONFIG_POWER_SUPPLY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_stress_ng
# @DESCRIPTION:
# Applies kernel config flags for the stress-ng package
ot-kernel-pkgflags_stress_ng() { # DONE
	local pkg="app-benchmarks/stress-ng"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[apparmor]" \
	; then
		_OT_KERNEL_LSM_ADD_APPARMOR=1
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sudo
# @DESCRIPTION:
# Applies kernel config flags for the sudo package
ot-kernel-pkgflags_sudo() { # DONE
	if ot-kernel_has_version_pkgflags "app-admin/sudo" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_suricata
# @DESCRIPTION:
# Applies kernel config flags for the suricata package
ot-kernel-pkgflags_suricata() { # DONE
	if ot-kernel_has_version_pkgflags "net-analyzer/suricata" ; then
		ot-kernel_y_configopt "CONFIG_XDP_SOCKETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_syd
# @DESCRIPTION:
# Applies kernel config flags for the syd package
ot-kernel-pkgflags_syd() { # FIXME
	if ot-kernel_has_version_pkgflags "sys-apps/syd" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev and checking sandbox status, ghost_mode
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_FILE_LOCKING" # For flock
		ot-kernel_y_configopt "CONFIG_UNIX" # For socket(AF_UNIX, ...)
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /run

	# See also https://gitlab.exherbo.org/sydbox/sydbox/-/tree/main
	# It is unknown if these capabilities are a hard requirement.

	# Seccomp kernel config already applied.
	# See ot-kernel-pkgflags_libseccomp

		_OT_KERNEL_LSM_ADD_LANDLOCK=1
		_OT_KERNEL_LSM_ADD_SAFESETID=1
	# For namespace requirements, see
	# https://gitlab.exherbo.org/sydbox/sydbox/-/blob/main/src/unshare/namespace.rs

	#
	# The kernel flags coverage/progress per sandbox capability:
	# If a line is blank, it may not be finished.
	# See http://man.exherbolinux.org/syd.7.html for description of capability
	#
	# 1. ot-kernel-pkgflags_libseccomp
	# 2. ot-kernel-pkgflags_libseccomp
	# 3. ot-kernel-pkgflags_libseccomp
	# 4. ot-kernel-pkgflags_libseccomp CONFIG_MEMFD_CREATE=y, _ot-kernel_set_pid_ns
	# 5. ot-kernel-pkgflags_libseccomp
	# 6.
	# 7. Passed... It requires grsecurity
	# 8. ot-kernel-pkgflags_libseccomp, CONFIG_UNIX=y [unix sockets], CONFIG_INET=y [ipv4], CONFIG_IPV6=y [ipv6], [netlink], CONFIG_CRYPTO_USER_API_SKCIPHER=y [kcapi]
	# 9. _OT_KERNEL_LSM_ADD_LANDLOCK=1
	# 10. CONFIG_CRYPTO_CBC=y, CONFIG_CRYPTO_CTR=y, CONFIG_CRYPTO_AES=y, CONFIG_MEMFD_CREATE=y, _ot-kernel_set_pid_ns
	# 11. _ot-kernel_set_net_ns
	# 12. CONFIG_PROC_FS=y
	# 13. _ot-kernel_set_pid_ns
	# 14. _OT_KERNEL_LSM_ADD_SAFESETID=1
	# 15.
	#

		# Netlink is enabled unconditionally
		ot-kernel_y_configopt "CONFIG_NET" # Dep of INET
		ot-kernel_y_configopt "CONFIG_INET" # ipv4
		ot-kernel_y_configopt "CONFIG_IPV6"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_SKCIPHER" # kcapi

		ot-kernel_y_configopt "CONFIG_MEMFD_CREATE"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CBC" # It needs CONFIG_SKCIPHER
		ot-kernel_y_configopt "CONFIG_CRYPTO_CTR" # It needs CONFIG_SKCIPHER
		_ot-kernel-pkgflags_aes CBC CTR

	# These are disabed by default in the sandbox but a user may want to whitelist.
		# Missing mount ns
		_ot-kernel_set_uts_ns
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_cgroup_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sysdig_kmod
# @DESCRIPTION:
# Applies kernel config flags for the sysdig-kmod package
ot-kernel-pkgflags_sysdig_kmod() { # DONE
	local pkg="dev-util/sysdig-kmod"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_disable_ide
# @DESCRIPTION:
# Warn user that package recommends it disabled.
_ot-kernel-pkgflags_disable_ide() {
	local pkg="${1}"
	if grep -q -E -e "^CONFIG_IDE=y" "${path_config}" ; then
ewarn
ewarn "Detected CONFIG_IDE=y"
ewarn "You should disable CONFIG_IDE for proper ${pkg} support."
ewarn
	# We don't auto disable to avoid broken boot in legacy systems.
		#ot-kernel_unset_configopt "CONFIG_IDE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemd
# @DESCRIPTION:
# Applies kernel config flags for the systemd package
ot-kernel-pkgflags_systemd() { # DONE
	local pkg="sys-apps/systemd"
	if ot-kernel_has_version_pkgflags_slow "${pkg}" ; then
	# See also https://github.com/systemd/systemd/blob/main/README

		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_UNIX" # For socket(AF_UNIX, ...)
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_FHANDLE"

		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED" # bug #652272

		ot-kernel_set_configopt "CONFIG_UEVENT_HELPER_PATH" "\"\""

		ot-kernel_unset_configopt "CONFIG_FW_LOADER_USER_HELPER"

		if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_DMI"
			ot-kernel_y_configopt "CONFIG_DMIID"
		fi

		if [[ "${SYSTEMD_FEATURE_SCSI:-0}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_SCSI"
			ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		fi

		if [[ "${SYSTEMD_FEATURE_PRIVATENETWORK:-1}" == "1" ]] ; then
			_ot-kernel_set_net_ns
		fi
		if [[ "${SYSTEMD_FEATURE_PRIVATEUSERS:-1}" == "1" ]] ; then
			_ot-kernel_set_user_ns
		fi

		if [[ "${SYSTEMD_FEATURE_IPV6:-1}" == "1" ]] ; then
		        ot-kernel_y_configopt "CONFIG_IPV6"
		fi

		ot-kernel_y_configopt "CONFIG_TMPFS" # [W]
		ot-kernel_y_configopt "CONFIG_TMPFS_XATTR"
		if ot-kernel_has_version "${pkg}[acl]" ; then
			__ot-kernel_set_acl_one_package
		fi
		if ot-kernel_has_version "${pkg}[seccomp]" ; then
			_ot-kernel_set_seccomp_bpf "${pkg}"
		fi

		if [[ "${SYSTEMD_FEATURE_FD_COMPARE:-kcmp}" == "kcmp" ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -ge "5.10" ; then
				ot-kernel_y_configopt "CONFIG_KCMP" # >= 5.10.20
			else
				ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
			fi
		fi

	# For fq-codel, see
	# See also https://github.com/systemd/systemd/blob/main/sysctl.d/50-default.conf#L48
	# See issue #7744, bug #642192, commit 755fdff

		if [[ "${SYSTEMD_FEATURE_AUTOFS:-0}" == "1" ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -ge "4.18" ; then
				ot-kernel_y_configopt "CONFIG_AUTOFS_FS"
			else
				ot-kernel_y_configopt "CONFIG_AUTOFS4_FS"
			fi
		fi

		if [[ "${SYSTEMD_FEATURE_CPUSHARES:-0}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CGROUP_SCHED"
			ot-kernel_y_configopt "CONFIG_FAIR_GROUP_SCHED"
		fi

		if [[ "${SYSTEMD_FEATURE_CPUQUOTA:-0}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CFS_BANDWIDTH"
		fi

		if [[ "${SYSTEMD_FEATURE_BPF:-0}" == "1" ]] ; then
			_ot-kernel_set_bpf "${pkg}"
			if ver_test "${KV_MAJOR_MINOR}" -ge "4.10" ; then
				ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
			fi
		fi

		if [[ "${SYSTEMD_UEFI:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_PARTITION_ADVANCED"
			ot-kernel_y_configopt "CONFIG_EFI"
			ot-kernel_y_configopt "CONFIG_EFIVAR_FS"
			ot-kernel_y_configopt "CONFIG_EFI_PARTITION"
		fi

	# We don't auto enable these security options because these are not
	# mainstream features and it would be difficult to debug boot failure
	# for new users.
	# See commit a79b6dc for use scenario.

	# For SYSTEMD_FEATURE_SIGNED_DM_VERITY use CRYPTSETUP_VERITY instead.

		if [[ "${SYSTEMD_FEATURE_SMBIOS:-0}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_DMI"
			ot-kernel_y_configopt "CONFIG_DMI_SYSFS"
		fi

		if [[ "${SYSTEMD_FEATURE_RESTRICT_FS:-0}" == "1" ]] ; then
			_ot-kernel_set_bpf "${pkg}"
			ot-kernel_y_configopt "CONFIG_DEBUG_INFO_BTF"
			_OT_KERNEL_LSM_ADD_BPF=1
		fi

		local rt=0

		if [[ \
			   "${work_profile}" == "digital-audio-workstation" \
			|| "${work_profile}" == "musical-live-performance" \
			|| "${work_profile}" == "pi-deep-learning" \
			|| "${work_profile}" == "pi-music-production" \
			|| "${work_profile}" == "radio-broadcaster" \
			|| "${work_profile}" == "hpc-realtime" \
			|| "${work_profile}" == "ros" \
			|| "${work_profile}" == "voip" \
		]] ; then
			rt=1
		fi

		if \
			   grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" \
			|| grep -q -e "^CONFIG_PREEMPT_RT_BASE=y" "${path_config}" \
			|| grep -q -e "^CONFIG_PREEMPT_RT_FULL=y" "${path_config}" \
		; then
			rt=1
		fi

		if (( ${rt} == 1 )) ; then
			ot-kernel_unset_configopt "CONFIG_RT_GROUP_SCHED"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.7" ; then
			ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
		fi

		if [[ "${SYSTEMD_FEATURE_OOMD:-0}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_PSI"
			ot-kernel_y_configopt "CONFIG_MEMCG"
		fi

		if [[ "${SYSTEMD_CONTAINER:-0}" == "1" ]] ; then
			if [[ "${work_profile}" == "dss" ]] ; then
eerror "Audit is required for dss profile to generate logs.  Set SYSTEMD_CONTAINER=0"
				die
			fi
			ot-kernel_set_kconfig_kernel_cmdline "audit=0"
			ot-kernel_unset_configopt "CONFIG_AUDIT"
		fi

	# Settings undocumented by upstream for the remaining settings.

	# Distro recommended, verified through search
		ot-kernel_y_configopt "CONFIG_FANOTIFY" # [EP]
	        _ot-kernel-pkgflags_tcpip # [EP] Used also for QoS + Codel
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC" # [EP]
		_ot-kernel-pkgflags_sha256 # [EP]
		ot-kernel_y_configopt "CONFIG_FILE_LOCKING" # [P]
		_ot-kernel_set_shmem  # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_EVENTFD" # [P]
		ot-kernel_y_configopt "CONFIG_BLOCK" # [P] References block filesystems (e.g. ext4)

	# Distro recommended, not verified through search
		warn_lowered_security "${pkg}" "Reconnaissance, vulnerability pre attack scan" # For below \
		ot-kernel_unset_configopt "CONFIG_GRKERNSEC_PROC" # [EN]

		#ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH" # [EP] Disabled.  API not being used, but contains reference to AF_ALG.
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2" # bug #652272 [EN] Misnomer option.  It should be CONFIG_SYSFS_DEFAULT_ENABLE_DEPRECATED.
		_ot-kernel-pkgflags_disable_ide "${pkg}"
	# These are auto enabled during `make olddefconfig` found in ot-kernel_src_configure_assisted
		#ot-kernel_y_configopt "CONFIG_ANON_INODES" # [P] Selected by EPOLL, TIMERFD, SIGNALFD
		#ot-kernel_y_configopt "CONFIG_FSNOTIFY" # [P] Selected by FANOTIFY
		#ot-kernel_y_configopt "CONFIG_NLATTR" # [P] Selected by NET
		if [[ "${SYSTEMD_UEFI:-1}" == "1" ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -lt "6.0" ; then
				if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
					ot-kernel_y_configopt "CONFIG_EFI_VARS" # [W]
				fi
			fi
		fi
		#ot-kernel_y_configopt "CONFIG_BFQ_GROUP_IOSCHED" # [W] Did not find recommendedation in repo.

		# [P] - Found in Genpatches 4567
		# [E] - Found in ebuild
		# [W] - Found in wiki
		# [N] - No reason given by ebuild/patch contributor.  These undocumented recommendations could lead to unintended consequences (i.e. bugs).

	# Recommended by eclass packager
		ot-kernel_y_configopt "CONFIG_SYSVIPC" # For msgctl
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # [P] For #! scripts
		ot-kernel_y_configopt "CONFIG_TMPFS" # [P] For /dev/shm, /run
		ot-kernel_y_configopt "CONFIG_DEVPTS_FS" # For /dev/pts
		ot-kernel_y_configopt "CONFIG_SYSCTL" # For sysctl.d/50-default.conf

	# LDT referended in sys-apps/systemd
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemd_bootchart
# @DESCRIPTION:
# Applies kernel config flags for the systemd-bootchart package
ot-kernel-pkgflags_systemd_bootchart() { # DONE
	local pkg="sys-apps/systemd-bootchart"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SCHEDSTATS"
		ban_disable_debug "${pkg}" "CONFIG_SCHED_DEBUG"
		ot-kernel_y_configopt "CONFIG_SCHED_DEBUG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemtap
# @DESCRIPTION:
# Applies kernel config flags for the systemtap package
ot-kernel-pkgflags_systemtap() { # DONE
	local pkg="dev-debug/systemtap"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_RELAY"
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS"
		needs_debugfs
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sysvinit
# @DESCRIPTION:
# Applies kernel config flags for the sysvinit package
ot-kernel-pkgflags_sysvinit() { # DONE
	local pkg="sys-apps/sysvinit"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_DEVTMPFS" # For /dev
		ot-kernel_y_configopt "CONFIG_TMPFS" # For /dev/shm, /run
		_ot-kernel_set_shmem # For mounting /dev/shm needed for glibc
		ot-kernel_y_configopt "CONFIG_PROC_FS" # For /proc
		ot-kernel_y_configopt "CONFIG_SYSFS" # For /sys
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tas
# @DESCRIPTION:
# Applies kernel config flags for the tas package
ot-kernel-pkgflags_tas() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/tas" ; then
		ot-kernel_y_configopt "CONFIG_IPMI_DEVICE_INTERFACE"
		ot-kernel_y_configopt "CONFIG_IPMI_HANDLER"
		ot-kernel_y_configopt "CONFIG_IPMI_SI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tb_us
# @DESCRIPTION:
# Applies kernel config flags for the tb_us package
ot-kernel-pkgflags_tb_us() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/thunderbolt-software-user-space" ; then
		ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tbb
# @DESCRIPTION:
# Applies kernel config flags for the tbb package
ot-kernel-pkgflags_tbb() { # DONE
	if ot-kernel_has_version_pkgflags "dev-cpp/tbb" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tboot
# @DESCRIPTION:
# Applies kernel config flags for the tboot package
ot-kernel-pkgflags_tboot() { # DONE
	if ot-kernel_has_version_pkgflags "sys-boot/tboot" ; then
		ot-kernel_y_configopt "CONFIG_INTEL_TXT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tcmalloc
# @DESCRIPTION:
# Applies kernel config flags for the tcmalloc package
ot-kernel-pkgflags_tcmalloc() { # DONE
	if ot-kernel_has_version_pkgflags "dev-util/google-perftools" ; then
	# The distro ebuild is missing the check.
	# It is assume to be on
	# See https://github.com/google/tcmalloc/blob/master/docs/tuning.md?plain=1#L153
		_ot-kernel_y_thp
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS" # For madvise()
	fi
}

# @FUNCTION: ot-kernel-pkgflags_thermald
# @DESCRIPTION:
# Applies kernel config flags for the thermald package
ot-kernel-pkgflags_thermald() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/thermald" ; then
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS_INTEL_RAPL"
		ot-kernel_y_configopt "CONFIG_X86_INTEL_PSTATE"
		ot-kernel_y_configopt "CONFIG_INTEL_POWERCLAMP"
		ot-kernel_y_configopt "CONFIG_INT340X_THERMAL"
		ot-kernel_y_configopt "CONFIG_ACPI_THERMAL_REL"
		ot-kernel_y_configopt "CONFIG_INT3406_THERMAL"

		ot-kernel_n_configopt "CONFIG_THERMAL_DEFAULT_GOV_BANG_BANG"
		ot-kernel_n_configopt "CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE"
		ot-kernel_n_configopt "CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR"
		ot-kernel_n_configopt "CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE"
		ot-kernel_n_configopt "CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE"

		ot-kernel_y_configopt "CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE"
		ot-kernel_y_configopt "CONFIG_THERMAL_GOV_USER_SPACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_thinkfinger
# @DESCRIPTION:
# Applies kernel config flags for the thinkfinger package
ot-kernel-pkgflags_thinkfinger() { # DONE
	local pkg="sys-auth/thinkfinger"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[pam]" \
	; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_throttled
# @DESCRIPTION:
# Applies kernel config flags for the throttled package
ot-kernel-pkgflags_throttled() { # DONE
	local pkg="sys-power/throttled"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		_OT_KERNEL_DEV_MEM=1
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tidal_hifi_bin
# @DESCRIPTION:
# Applies kernel config flags for the tidal-hifi-bin package
ot-kernel-pkgflags_tidal_hifi_bin() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/tidal-hifi-bin" ; then
		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tiny_dfr
# @DESCRIPTION:
# Applies kernel config flags for the tiny-dfr package
ot-kernel-pkgflags_tiny_dfr() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/tiny-dfr" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_torque
# @DESCRIPTION:
# Applies kernel config flags for the torque package
ot-kernel-pkgflags_torque() { # DONE
	local pkg="sys-cluster/torque"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[cpusets]" \
	; then
		ot-kernel_y_configopt "CONFIG_CPUSETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tp_smapi
# @DESCRIPTION:
# Applies kernel config flags for the tp_smapi package
ot-kernel-pkgflags_tp_smapi() { # DONE
	local pkg="app-laptop/tp_smapi"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[hdaps]" \
	; then
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_unset_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpb
# @DESCRIPTION:
# Applies kernel config flags for the tpb package
ot-kernel-pkgflags_tpb() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/tpb" ; then
		ot-kernel_y_configopt "CONFIG_NVRAM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpm_emulator
# @DESCRIPTION:
# Applies kernel config flags for the tpm-emulator package
ot-kernel-pkgflags_tpm_emulator() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/tpm-emulator" ; then
		ot-kernel_y_configopt "CONFIG_MODULES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpm2_tss
# @DESCRIPTION:
# Applies kernel config flags for the tpm2_tss package
ot-kernel-pkgflags_tpm2_tss() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/tpm2-tss" ; then
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trace_cmd
# @DESCRIPTION:
# Applies kernel config flags for the trace-cmd package
ot-kernel-pkgflags_trace_cmd() { # DONE
	local pkg="dev-util/trace-cmd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_TRACING, CONFIG_TRACING_SUPPORT, CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_TRACING"
		ot-kernel_y_configopt "CONFIG_TRACING_SUPPORT"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tracker
# @DESCRIPTION:
# Applies kernel config flags for the tracker package
ot-kernel-pkgflags_tracker() { # DONE
	if ot-kernel_has_version_pkgflags "app-misc/tracker" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trousers
# @DESCRIPTION:
# Applies kernel config flags for the trousers package
ot-kernel-pkgflags_trousers() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/trousers" ; then
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tuigreet
# @DESCRIPTION:
# Applies kernel config flags for the tuigreet package
ot-kernel-pkgflags_tuigreet() { # DONE
	if ot-kernel_has_version_pkgflags "gui-apps/tuigreet" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tup
# @DESCRIPTION:
# Applies kernel config flags for the tup package
ot-kernel-pkgflags_tup() { # DONE
	if ot-kernel_has_version_pkgflags "dev-build/tup" ; then
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tuxedo_drivers
# @DESCRIPTION:
# Applies kernel config flags for the tuxedo-drivers package
ot-kernel-pkgflags_tuxedo_drivers() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/tuxedo-drivers" ; then
		ot-kernel_y_configopt "CONFIG_ACPI_WMI INPUT_SPARSEKMAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tuxedo_keyboard
# @DESCRIPTION:
# Applies kernel config flags for the tuxedo_keyboard package
ot-kernel-pkgflags_tuxedo_keyboard() { # DONE
	if ot-kernel_has_version_pkgflags "app-laptop/tuxedo-keyboard" ; then
		ot-kernel_y_configopt "CONFIG_X86_PLATFORM_DEVICES"
		ot-kernel_y_configopt "CONFIG_ACPI"
		ot-kernel_y_configopt "CONFIG_ACPI_WMI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_SPARSEKMAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tvheadend
# @DESCRIPTION:
# Applies kernel config flags for the tvheadend package
ot-kernel-pkgflags_tvheadend() { # DONE
	if ot-kernel_has_version_pkgflags "media-tv/tvheadend" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_udev
# @DESCRIPTION:
# Applies kernel config flags for the udev package
ot-kernel-pkgflags_udev() { # DONE
	local pkg="sys-fs/udev"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_UNIX"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SYSFS"

		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		_ot-kernel-pkgflags_disable_ide "${pkg}"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"
		ot-kernel_y_configopt "CONFIG_EXPERT"
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
	local pkg="sys-fs/udisks"
	if ot-kernel_has_version_pkgflags "${pkg}" \
		&& \
	[[ \
		   "${arch}" == "arm" \
		|| "${arch}" == "powerpc" \
		|| "${arch}" == "ppc" \
		|| "${arch}" == "ppc64" \
		|| "${arch}" == "x86" \
		|| "${arch}" == "x86_64" \
	]] ; then
		if grep -q -E -e "^CONFIG_IDE=y" "${path_config}" ; then
ewarn "Please change by hand CONFIG_IDE to CONFIG_PATA_ for proper DVD-RW support.  Explicitly disable CONFIG_IDE also."
		fi
		_ot-kernel-pkgflags_disable_ide "${pkg}"
		ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_NLS_UTF8"
		if ver_test "${KV_MAJOR_MINOR}" -lt "3.10" ; then
			ot-kernel_y_configopt "CONFIG_USB_SUSPEND"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_uefi_mkconfig
# @DESCRIPTION:
# Applies kernel config flags for the uefi-mkconfig package
ot-kernel-pkgflags_uefi_mkconfig() { # DONE
	local pkg="sys-boot/uefi-mkconfig"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_y_configopt "CONFIG_EFI_STUB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ufw
# @DESCRIPTION:
# Applies kernel config flags for the ufw package
ot-kernel-pkgflags_ufw() { # DONE
	local pkg="net-firewall/ufw"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_HL"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_LIMIT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_RECENT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		if ver_test "${MY_PV}" -ge "2.6.39" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE"
		else
			ot-kernel_y_configopt "CONFIG_IP_NF_MATCH_ADDRTYPE"
		fi
		ban_disable_debug "${pkg}" "CONFIG_NETFILTER_XT_TARGET_LOG, CONFIG_IP_NF_TARGET_LOG, CONFIG_IP6_NF_TARGET_LOG" "NETFILTER"
		if ver_test "${MY_PV}" -ge "3.4" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_LOG"
		else
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_LOG"
			if ot-kernel_has_version "${pkg}[ipv6]" ; then
				ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_LOG"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		if ot-kernel_has_version "${pkg}[ipv6]" ; then
			ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_REJECT"
		fi
		ot-kernel_y_configopt "CONFIG_NF_NAT_FTP"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_FTP"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_NETBIOS_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_uksmd
# @DESCRIPTION:
# Applies kernel config flags for the uksmd package
ot-kernel-pkgflags_uksmd() { # DONE
	local pkg="sys-process/uksmd"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		warn_lowered_security "${pkg}" "Kernel Samepage Merging KSM, See Wikipedia for details" "ID, DT"
		ot-kernel_y_configopt "CONFIG_KSM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rapl
# @DESCRIPTION:
# Applies kernel config for RAPL
_ot-kernel-pkgflags_rapl() {
	if grep -q -E -e "^CONFIG_X86=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_POWERCAP"
		ot-kernel_y_configopt "CONFIG_IOSF_MBI"
		ot-kernel_y_configopt "CONFIG_INTEL_RAPL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_undervolt
# @DESCRIPTION:
# Applies kernel config flags for the undervolt package
ot-kernel-pkgflags_undervolt() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/intel-undervolt" ; then
		_ot-kernel-pkgflags_rapl
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb
# @DESCRIPTION:
# Applies kernel config flags for usb
ot-kernel-pkgflags_usb() { # DONE
	if \
		   ot-kernel_has_version_pkgflags "virtual/libusb" \
		|| ot-kernel_has_version_pkgflags "dev-libs/libusb" \
	; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 3.x
		ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2.x
		ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1.x
		ot-kernel_y_configopt "CONFIG_USB_UHCI_HCD" # 1.x
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb_midi_fw
# @DESCRIPTION:
# Applies kernel config flags for usb midi fw
ot-kernel-pkgflags_usb_midi_fw() { # DONE
	if ot-kernel_has_version_pkgflags "sys-firmware/midisport-firmware" ; then
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb_modeswitch
# @DESCRIPTION:
# Applies kernel config flags for the usb_modeswitch package
ot-kernel-pkgflags_usb_modeswitch() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/usb_modeswitch" ; then
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbtop
# @DESCRIPTION:
# Applies kernel config flags for the usbtop package
ot-kernel-pkgflags_usbtop() { # DONE
	if ot-kernel_has_version_pkgflags "sys-process/usbtop" ; then
		ot-kernel_y_configopt "CONFIG_USB_MON"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbview
# @DESCRIPTION:
# Applies kernel config flags for the usbview package
ot-kernel-pkgflags_usbview() { # DONE
	local pkg="app-admin/usbview"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_FS"
		needs_debugfs
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_util_linux
# @DESCRIPTION:
# Applies kernel config flags for the util-linux package
ot-kernel-pkgflags_util_linux() { # DONE
	local pkg="sys-apps/util-linux"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[su]" \
	; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_v4l_dvb_saa716x
# @DESCRIPTION:
# Applies kernel config flags for the v4l-dvb-saa716x package
ot-kernel-pkgflags_v4l_dvb_saa716x() { # DONE
	if ot-kernel_has_version_pkgflags "media-tv/v4l-dvb-saa716x" ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_STV6110x"
		ot-kernel_y_configopt "CONFIG_DVB_STV090x"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_v4l2loopback
# @DESCRIPTION:
# Applies kernel config flags for the v4l2loopback package
ot-kernel-pkgflags_v4l2loopback() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/v4l2loopback" ; then
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vala
# @DESCRIPTION:
# Applies kernel config flags for the vala package
ot-kernel-pkgflags_vala() { # DONE
	if ot-kernel_has_version_pkgflags "dev-lang/vala" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vbox
# @DESCRIPTION:
# Applies kernel config flags for the vbox package
ot-kernel-pkgflags_vbox() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/virtualbox" ; then
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_VIRTUALIZATION"
		if ot-kernel_has_version ">=app-emulation/virtualbox-9999" ; then
			ot-kernel_unset_configopt "CONFIG_SPINLOCK JUMP_LABEL"
		fi
		VIRTUALBOX_GUEST_LINUX="${VIRTUALBOX_GUEST_LINUX:-1}"
		if [[ "${VIRTUALBOX_LINUX_GUEST}" == "1" ]] ; then
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
			_ot-kernel_set_drm_fbdev_emulation
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

# @FUNCTION: ot-kernel-pkgflags_vbox_guest_additions
# @DESCRIPTION:
# Applies kernel config flags for the vbox-guest-additions package
ot-kernel-pkgflags_vbox_guest_additions() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/virtualbox-guest-additions" ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_DRM_TTM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vbox_modules
# @DESCRIPTION:
# Applies kernel config flags for the vbox-modules package
ot-kernel-pkgflags_vbox_modules() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/virtualbox-modules" ; then
		ot-kernel_unset_configopt "CONFIG_SPINLOCK"
		ot-kernel_y_configopt "CONFIG_JUMP_LABEL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vcrypt
# @DESCRIPTION:
# Applies kernel config flags for vcrypt
ot-kernel-pkgflags_vcrypt() { # DONE
	if ot-kernel_has_version_pkgflags "app-crypt/veracrypt" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_XTS"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vdr_imonlcd
# @DESCRIPTION:
# Applies kernel config flags for vdr-imonlcd
ot-kernel-pkgflags_vdr_imonlcd() { # DONE
	if ot-kernel_has_version_pkgflags "media-plugins/vdr-imonlcd" ; then
		ot-kernel_y_configopt "CONFIG_IR_IMON"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vendor_reset
# @DESCRIPTION:
# Applies kernel config flags for the vendor-reset package
ot-kernel-pkgflags_vendor_reset() { # DONE
	local pkg="app-emulation/vendor-reset"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_TRACING_SUPPORT, CONFIG_FTRACE, CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_TRACING_SUPPORT"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_PCI_QUIRKS"
		ban_dma_attack "${pkg}" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vesktop_bin
# @DESCRIPTION:
# Applies kernel config flags for the vesktop-bin package
ot-kernel-pkgflags_vesktop_bin() { # DONE
	if ot-kernel_has_version_pkgflags "net-im/vesktop-bin" ; then
		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vhba
# @DESCRIPTION:
# Applies kernel config flags for the vhba package
ot-kernel-pkgflags_vhba() { # DONE
	if ot-kernel_has_version_pkgflags "sys-fs/vhba" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vim
# @DESCRIPTION:
# Applies kernel config flags for the vim package
ot-kernel-pkgflags_vim() { # DONE
	if ot-kernel_has_version_pkgflags "app-editors/vim" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		#ot-kernel_y_configopt "CONFIG_SYSVIPC" # Used in config check and .vim files only
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vivaldi
# @DESCRIPTION:
# Applies kernel config flags for the vivaldi package
ot-kernel-pkgflags_vivaldi() { # DONE
	if \
		   ot-kernel_has_version_pkgflags_slow "www-client/vivaldi" \
		|| ot-kernel_has_version_pkgflags "www-client/vivaldi-snapshot" \
	; then
# Prevent crash
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vinagre
# @DESCRIPTION:
# Applies kernel config flags for the vinagre package
ot-kernel-pkgflags_vinagre() { # DONE
	if ot-kernel_has_version_pkgflags "net-misc/vinagre" ; then
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vlc
# @DESCRIPTION:
# Applies kernel config flags for the vlc package
ot-kernel-pkgflags_vlc() { # DONE
	if ot-kernel_has_version_pkgflags "media-video/vlc" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_voiphopper
# @DESCRIPTION:
# Applies kernel config flags for the voiphopper package
ot-kernel-pkgflags_voiphopper() { # DONE
	if ot-kernel_has_version_pkgflags "net-analyzer/voiphopper" ; then
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vpnc
# @DESCRIPTION:
# Applies kernel config flags for the vpnc package
ot-kernel-pkgflags_vpnc() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/vpnc" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vtun
# @DESCRIPTION:
# Applies kernel config flags for the vtun package
ot-kernel-pkgflags_vtun() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/vtun" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wacom
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-wacom package
ot-kernel-pkgflags_wacom() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-input-wacom" ; then
		if ver_test "${KV_MAJOR_MINOR}" -lt "3.17" ; then
			ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
			ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
			ot-kernel_y_configopt "CONFIG_USB_ARCH_HAS_HCD"
			ot-kernel_y_configopt "CONFIG_USB"
			ot-kernel_y_configopt "CONFIG_TABLET_USB_WACOM"
		else
			ot-kernel_y_configopt "CONFIG_USB"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_USB_HID"
			ot-kernel_y_configopt "CONFIG_HID"
			ot-kernel_y_configopt "CONFIG_HID_WACOM"
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_add_watchdog_drivers
# @DESCRIPTION:
# Adds a watchdog driver
_ot-kernel-pkgflags_add_watchdog_drivers() {
	if [[ -n "${WATCHDOG_DRIVERS:-SOFT_WATCHDOG}" ]] ; then
		local sym
		for sym in ${WATCHDOG_DRIVERS} ; do
			ot-kernel_set_configopt "CONFIG_${sym}" "m"
		done
	fi
}

# @FUNCTION: ot-kernel-pkgflags_watchdog
# @DESCRIPTION:
# Applies kernel config flags for the watchdog package
ot-kernel-pkgflags_watchdog() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/watchdog" ; then
		ot-kernel_unset_configopt "CONFIG_WATCHDOG"
		if [[ "${WATCHDOG_WAYOUT:-1}" == "1" ]] ; then
			ot-kernel_unset_configopt "CONFIG_WATCHDOG_NOWAYOUT"
		else
			ot-kernel_y_configopt "CONFIG_WATCHDOG_NOWAYOUT"
		fi
		_ot-kernel-pkgflags_add_watchdog_drivers
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wlgreet
# @DESCRIPTION:
# Applies kernel config flags for the wlgreet package
ot-kernel-pkgflags_wlgreet() { # DONE
	if ot-kernel_has_version_pkgflags "gui-apps/wlgreet" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wavemon
# @DESCRIPTION:
# Applies kernel config flags for the wavemon package
ot-kernel-pkgflags_wavemon() { # DONE
	local pkg="net-wireless/wavemon"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "~${pkg}-0.9.3" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_WEXT"
		elif ot-kernel_has_version ">=${pkg}-0.9.4" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_waydroid
# @DESCRIPTION:
# Applies kernel config flags for the waydroid package
ot-kernel-pkgflags_waydroid() { # DONE
	if ot-kernel_has_version_pkgflags "app-containers/waydroid" ; then
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_ANDROID_BINDER_IPC"
		ot-kernel_y_configopt "CONFIG_ANDROID_BINDERFS"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MEMFD_CREATE"

		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_MASQUERADE"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_NAT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wdm
# @DESCRIPTION:
# Applies kernel config flags for the wdm package
ot-kernel-pkgflags_wdm() { # DONE
	if ot-kernel_has_version_pkgflags "x11-misc/wdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_webkit_gtk
# @DESCRIPTION:
# Applies kernel config flags for the webkit-gtk package
ot-kernel-pkgflags_webkit_gtk() { # DONE
	if ot-kernel_has_version_pkgflags "net-libs/webkit-gtk" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS" # __NR_process_madvise
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wine
# @DESCRIPTION:
# Applies kernel config flags for the wine packages
ot-kernel-pkgflags_wine() { # DONE
	local pkg=""
	if ot-kernel_has_version_pkgflags "app-emulation/wine-d3d9" ; then
		pkg="app-emulation/wine-d3d9"
	elif ot-kernel_has_version_pkgflags "app-emulation/wine-proton" ; then
		pkg="app-emulation/wine-proton"
	elif ot-kernel_has_version_pkgflags "app-emulation/wine-staging" ; then
		pkg="app-emulation/wine-staging"
	elif ot-kernel_has_version_pkgflags "app-emulation/wine-vanilla" ; then
		pkg="app-emulation/wine-vanilla"
	elif ot-kernel_has_version_pkgflags "app-emulation/wine-wayland" ; then
		pkg="app-emulation/wine-wayland"
	fi
	if [[ -n "${pkg}" ]] ; then
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"		# For .NET
		if [[ "${arch}" =~ ("x86_64"|"x86") ]] ; then
			# For Legacy 32-bit
			_ot-kernel_set_ia32_support
		fi
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	# Fix for several network games for wine bug #7929
		_ot-kernel_set_so_attach_filter "${pkg}" # SO_ATTACH_FILTER ; commit 5701961
		if ot-kernel_has_version "app-emulation/wine-staging" ; then
	# Fix for a game
	# See https://github.com/wine-staging/wine-staging/blob/v9.16/patches/ntdll-Syscall_Emulation/definition
			_ot-kernel_set_seccomp_bpf "${pkg}"
		fi
		if ot-kernel_has_version ">=app-emulation/wine-proton-6" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_FUTEX"
			ot-kernel_y_configopt "CONFIG_FUTEX2"
		fi
		if ot-kernel_has_version ">=app-emulation/wine-vanilla-5.11" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_FUTEX"
		fi
		if ot-kernel_has_version ">=app-emulation/wine-staging-5.11" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_FUTEX"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireguard_modules
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-modules package
ot-kernel-pkgflags_wireguard_modules() { # DONE
	if ot-kernel_has_version_pkgflags "net-vpn/wireguard-modules" ; then
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_NET_UDP_TUNNEL"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireguard_tools
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-tools package
ot-kernel-pkgflags_wireguard_tools() { # DONE
	local pkg="net-vpn/wireguard-tools"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if ot-kernel_has_version "${pkg}[wg-quick]" ; then
			ot-kernel_y_configopt "CONFIG_IP_ADVANCED_ROUTER"
			ot-kernel_y_configopt "CONFIG_IP_MULTIPLE_TABLES"
			ot-kernel_y_configopt "CONFIG_IPV6_MULTIPLE_TABLES"
			if ot-kernel_has_version "net-firewall/nftables" ; then
				ot-kernel_y_configopt "CONFIG_NF_TABLES"
				ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV4"
				ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV6"
				ot-kernel_y_configopt "CONFIG_NFT_CT"
				ot-kernel_y_configopt "CONFIG_NFT_FIB"
				ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV4"
				ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV6"
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
			elif ot-kernel_has_version "net-firewall/iptables" ; then
				ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
				ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
				ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
				ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
				ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE"
				ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
				ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
				ot-kernel_y_configopt "CONFIG_IP6_NF_FILTER"
				ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
			fi
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.6" ; then
			ot-kernel_y_configopt "CONFIG_WIREGUARD"
			ot-kernel_y_configopt "CONFIG_NET_UDP_TUNNEL"
			ot-kernel_y_configopt "CONFIG_DST_CACHE"
			# Re-optimize if CONFIG_WIREGUARD kernel flags depends already met
			ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_CHACHA20POLY1305"
			_ot-kernel-pkgflags_curve25519
			_ot-kernel-pkgflags_chacha20
			_ot-kernel-pkgflags_poly1305
			_ot-kernel-pkgflags_blake2s
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireless_tools
# @DESCRIPTION:
# Applies kernel config flags for the wireless-tools package
ot-kernel-pkgflags_wireless_tools() { # DONE
	if ot-kernel_has_version_pkgflags "net-wireless/wireless-tools" ; then
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_WIRELESS"
		ot-kernel_y_configopt "CONFIG_CFG80211"
		ot-kernel_y_configopt "CONFIG_CFG80211_WEXT" # for iwlist scanning
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireplumber
# @DESCRIPTION:
# Applies kernel config flags for the wireplumber package
ot-kernel-pkgflags_wireplumber() { # DONE
	local pkg="media-video/wireplumber"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_unset_configopt "CONFIG_UML"
		ot-kernel_y_configopt "CONFIG_SND_PROC_FS"
		ban_disable_debug "${pkg}" "CONFIG_SND_VERBOSE_PROCFS"
		ot-kernel_y_configopt "CONFIG_SND_VERBOSE_PROCFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wpa_supplicant
# @DESCRIPTION:
# Applies kernel config flags for the wpa_supplicant package
ot-kernel-pkgflags_wpa_supplicant() { # DONE
	local pkg="net-wireless/wpa_supplicant"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[crda]" \
	; then
		: # See ot-kernel-pkgflags_crda
		ot-kernel_has_version "net-wireless/crda" || die "Install net-wireless/crda first"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xboxdrv
# @DESCRIPTION:
# Applies kernel config flags for the xboxdrv package
ot-kernel-pkgflags_xboxdrv() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/xboxdrv" ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_UHID"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD_FF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xdm
# @DESCRIPTION:
# Applies kernel config flags for the xdm package
ot-kernel-pkgflags_xdm() { # DONE
	if ot-kernel_has_version_pkgflags "x11-apps/xdm" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xe_guest_utilities
# @DESCRIPTION:
# Applies kernel config flags for the xe_guest_utilities package
ot-kernel-pkgflags_xe_guest_utilities() { # DONE
	if ot-kernel_has_version_pkgflags "app-emulation/xe-guest-utilities" ; then
		ot-kernel_y_configopt "CONFIG_XEN_COMPAT_XENFS"
		ot-kernel_y_configopt "CONFIG_XENFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xen
# @DESCRIPTION:
# Applies kernel config flags for the xen package
ot-kernel-pkgflags_xen() { # DONE
	local pkg="app-emulation/xen"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if [[ "${ZEN_DOM0:-1}" == "1" ]] ; then # priveleged, backend, host
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
			XEN_PCI_PASSTHROUGH="${XEN_PCI_PASSTHROUGH:-0}" # Default off for security reasons but overridable.
			if [[ "${XEN_PCI_PASSTHROUGH}" == "1" ]] ; then
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_XEN_PCIDEV_FRONTEND"
			fi

			ot-kernel_y_configopt "CONFIG_INPUT_MISC"
			ot-kernel_y_configopt "CONFIG_INPUT_XEN_KBDDEV_FRONTEND"
			ot-kernel_y_configopt "CONFIG_FB"
			ot-kernel_y_configopt "CONFIG_XEN_FBDEV_FRONTEND"

			if ot-kernel_has_acpi_support ; then
				ot-kernel_y_configopt "CONFIG_ACPI"
			fi

			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_BRIDGE"
			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
			ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"

			_ot-kernel-pkgflags_tun

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
			ot-kernel_y_configopt "CONFIG_CPU_FREQ"
			ot-kernel_y_configopt "CONFIG_XEN_PV_DOM0"
			ot-kernel_y_configopt "CONFIG_XEN_ACPI_PROCESSOR"
			ot-kernel_y_configopt "CONFIG_XEN_SYMS"
			ban_disable_debug "${pkg}" "CONFIG_XEN_MCE_LOG"
			ot-kernel_y_configopt "CONFIG_XEN_MCE_LOG"
		fi
		if [[ "${ZEN_DOMU:-0}" == "1" ]] ; then # unpriveleged, frontend, guest
			ot-kernel_y_configopt "CONFIG_HYPERVISOR_GUEST"
			ot-kernel_y_configopt "CONFIG_PARAVIRT"
			ot-kernel_y_configopt "CONFIG_XEN"
			ot-kernel_y_configopt "CONFIG_PVH"
			ot-kernel_y_configopt "CONFIG_SMP"
			ot-kernel_y_configopt "CONFIG_PARAVIRT_SPINLOCKS"

			ot-kernel_y_configopt "CONFIG_BLK_DEV"
			ot-kernel_y_configopt "CONFIG_XEN_BLKDEV_FRONTEND"

			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_NETDEVICES"
			ot-kernel_y_configopt "CONFIG_XEN_NETDEV_FRONTEND"

			if [[ "${XEN_PCI_PASSTHROUGH}" == "1" ]] ; then
				ot-kernel_y_configopt "CONFIG_PCI"
				ot-kernel_y_configopt "CONFIG_XEN_PV"
				ot-kernel_y_configopt "CONFIG_XEN_PCIDEV_FRONTEND"
			fi

			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_INPUT_MISC"
			ot-kernel_y_configopt "CONFIG_INPUT_XEN_KBDDEV_FRONTEND"

			ot-kernel_y_configopt "CONFIG_FB"
			ot-kernel_y_configopt "CONFIG_XEN_FBDEV_FRONTEND"

			ot-kernel_y_configopt "CONFIG_XEN_BALLOON"
			ot-kernel_y_configopt "CONFIG_XEN_SCRUB_PAGES_DEFAULT"
			ot-kernel_y_configopt "CONFIG_XEN_DEV_EVTCHN"
			ot-kernel_y_configopt "CONFIG_XENFS"
			ot-kernel_y_configopt "CONFIG_XEN_COMPAT_XENFS"
			ot-kernel_y_configopt "CONFIG_XEN_SYS_HYPERVISOR"
			ot-kernel_y_configopt "CONFIG_XEN_GNTDEV"
			ot-kernel_y_configopt "CONFIG_XEN_GRANT_DEV_ALLOC"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ"
			ot-kernel_y_configopt "CONFIG_XEN_PV_DOM0"
			ot-kernel_y_configopt "CONFIG_XEN_ACPI_PROCESSOR"
			ban_disable_debug "${pkg}" "CONFIG_XEN_MCE_LOG"
			ot-kernel_y_configopt "CONFIG_XEN_MCE_LOG"
		fi

		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS_MOUNT"

		if [[ "${ZEN_DOM0}" == "1" && "${ZEN_DOMU}" == "1" ]] ; then
eerror "Both ZEN_DOM0 or ZEN_DOMU cannot be enabled at the same time."
			die
		fi

		ot-kernel_y_configopt "CONFIG_DNOTIFY"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		_ot-kernel_set_shmem
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss

		# LDT referenced

		# SEV is not supported yet.
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_evdev
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-evdev package
ot-kernel-pkgflags_xf86_input_evdev() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-input-evdev" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_libinput
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-libinput package
ot-kernel-pkgflags_xf86_input_libinput() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-input-libinput" ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_synaptics
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-synaptics package
ot-kernel-pkgflags_xf86_input_synaptics() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-input-synaptics" ; then
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_amdgpu
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-amdgpu package
ot-kernel-pkgflags_xf86_video_amdgpu() { # DONE
	if \
		ot-kernel_has_version_pkgflags "x11-drivers/xf86-video-amdgpu" \
			|| \
		( \
			has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms \
		) \
	; then
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTPLUG"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTREMOVE"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_DEVICE_PRIVATE"
		_ot-kernel_set_drm_fbdev_emulation
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_AMD64"
		fi
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_MMU"
		if \
			 ! has rock-dkms ${IUSE_EFFECTIVE} \
		; then
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		elif \
			   has rock-dkms ${IUSE_EFFECTIVE} \
			&& ot-kernel_use rock-dkms \
			&& ( \
				   ver_test "${KV_MAJOR_MINOR}" -eq "5.4" \
				|| ver_test "${KV_MAJOR_MINOR}" -eq "5.15" \
			) \
		; then
	# For sys-kernel/rock-dkms not installed yet scenario.
			ot-kernel_y_configopt "CONFIG_MODULES"
			ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"

			if ver_test "${KV_MAJOR_MINOR}" -le "5.5" ; then
				# Missing DP_UHBR20 in latest 5.4 but appears in 5.19
				ot-kernel_n_configopt "CONFIG_DRM_AMD_DC_DSC_SUPPORT"
			fi

			# For better multislot support.
			ot-kernel_y_configopt "CONFIG_MODULE_UNLOAD"


			if [[ "${AMDGPU_DIRECT_DMA_FOR_SSG:-0}" == "1" ]] ; then
				ot-kernel_set_kconfig_kernel_cmdline "amdgpu.ssg=1"
				ot-kernel_set_kconfig_kernel_cmdline "amdgpu.direct_gma_size=96"
			else
				ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.ssg=(1|0)"
				ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.direct_gma_size=[0-9]+"
			fi
		else
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		fi

		if [[ "${AMDGPU_DEEP_COLOR:-0}" == "1" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.deep_color=1"
		else
			ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.deep_color=(0|1)"
		fi

		if [[ "${AMDGPU_EXP_HW_SUPPORT:-0}" == "1" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "amdgpu.exp_hw_support=1"
		else
			ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.exp_hw_support=1"
		fi

		ot-kernel_y_configopt "CONFIG_AMD_IOMMU_V2" # For rock-dkms
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_SI"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_CIK"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_USERPTR"
		ot-kernel_y_configopt "CONFIG_DRM_AMD_DC"
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_DCN1_0"
                fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" \
		        && ver_test "${KV_MAJOR_MINOR}" -le "4.17" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_PRE_VEGA"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.17" \
                        && ver_test "${KV_MAJOR_MINOR}" -le "4.18" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_FBC"
                fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.5" \
			&& ver_test "${KV_MAJOR_MINOR}" -le "5.3" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_DCN2_0"
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_DCN"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "5.9" \
			&& ver_test "${KV_MAJOR_MINOR}" -le "5.10" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_DCN"
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_DCN3_0"
		fi
		ot-kernel_y_configopt "CONFIG_DRM_AMD_ACP"
	# It enables the MMU_NOTIFIER indirectly. \
		ot-kernel_y_configopt "CONFIG_HSA_AMD"
		ot-kernel_y_configopt "CONFIG_SND_HDA"
		ot-kernel_y_configopt "CONFIG_SND_HDA_PATCH_LOADER"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI"
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_HDMI" "m"
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_ati
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-ati package
ot-kernel-pkgflags_xf86_video_ati() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-video-ati" ; then
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_AMD64"
		fi
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_DRM_RADEON"
		if ver_test "${KV_MAJOR_MINOR}" -ge "3.9" ; then
			ot-kernel_unset_configopt "CONFIG_DRM_RADEON_UMS"
		else
			ot-kernel_y_configopt "CONFIG_DRM_RADEON_KMS"
		fi
		ot-kernel_unset_configopt "CONFIG_FB_RADEON"

		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
		ot-kernel_y_configopt "CONFIG_SND_HDA_PATCH_LOADER"
		ot-kernel_set_configopt "CONFIG_SND_HDA_CODEC_HDMI" "m"
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"

		if [[ "${RADEON_DEEP_COLOR:-0}" == "1" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "radeon.deep_color=1"
		else
			ot-kernel_unset_pat_kconfig_kernel_cmdline "radeon.deep_color=(0|1)"
		fi

	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_intel
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-intel package
ot-kernel-pkgflags_xf86_video_intel() { # DONE
	local pkg="x11-drivers/xf86-video-intel"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_AGP"
		ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_I915"
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.3" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_KMS"
			ot-kernel_y_configopt "CONFIG_DRM_I915_FBDEV"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.3" ; then
			_ot-kernel_set_drm_fbdev_emulation
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.6" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_USERPTR"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.10" ; then
			warn_lowered_security "${pkg}" "Reconnaissance, vulnerability pre attack scan"
			ot-kernel_y_configopt "CONFIG_DRM_I915_CAPTURE_ERROR" # Debug
			ot-kernel_y_configopt "CONFIG_DRM_I915_COMPRESS_ERROR"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.14" \
			&& ver_test "${KV_MAJOR_MINOR}" -lt "4.19" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_ALPHA_SUPPORT"
		fi

		# For vaapi
		ot-kernel_y_configopt "CONFIG_ACPI"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
		ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
		ot-kernel_y_configopt "CONFIG_INTEL_IOMMU"
		ot-kernel_y_configopt "CONFIG_INTEL_IOMMU_DEFAULT_ON"
		ot-kernel_y_configopt "CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON" # Default on

		if ot-kernel_has_version "sys-kernel/linux-firmware" ; then
			if [[ "${I915_GEN9_HWACCEL_LOW_POWER_VIDEO_ENCODING:-0}" == "1" ]] ; then
				if ver_test "${KV_MAJOR_MINOR}" -ge "4.16" ; then
					ot-kernel_set_kconfig_kernel_cmdline "i915.enable_guc=3"
				else
					ot-kernel_set_kconfig_kernel_cmdline "i915.enable_guc_loading=1"
				fi
			else
				ot-kernel_unset_pat_kconfig_kernel_cmdline "i915.enable_guc=[0-9]"
				ot-kernel_unset_pat_kconfig_kernel_cmdline "i915.enable_guc_loading=[0-9]"
			fi

			if ver_test "${KV_MAJOR_MINOR}" -ge "5.16" ; then
				# For DG2 firmware for HW accelerated media decoding
				ot-kernel_y_configopt "CONFIG_DRM_I915_PXP"
				ot-kernel_y_configopt "CONFIG_INTEL_MEI"
				ot-kernel_y_configopt "CONFIG_INTEL_MEI_ME"
				ot-kernel_y_configopt "CONFIG_INTEL_MEI_PXP"
				ot-kernel_y_configopt "CONFIG_INTEL_MEI_GSC"
				ot-kernel_y_configopt "CONFIG_INTEL_MEI_PXP"
			fi
		else
			if [[ "${I915_GEN9_HWACCEL_LOW_POWER_VIDEO_ENCODING}" == "1" ]] ; then
ewarn
ewarn "Install sys-kernel/linux-firmware for low power video HW accelerated"
ewarn "encoding."
ewarn
			fi

			if ver_test "${KV_MAJOR_MINOR}" -ge "5.16" ; then
ewarn
ewarn "Install sys-kernel/linux-firmware for HW accelerated media decoding."
ewarn
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_nouveau
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-nouveau package
ot-kernel-pkgflags_xf86_video_nouveau() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-video-nouveau" ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_FB"
		_ot-kernel_set_drm_fbdev_emulation
		ot-kernel_y_configopt "CONFIG_DRM_NOUVEAU"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_vesa
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-vesa package
ot-kernel-pkgflags_xf86_video_vesa() { # DONE
	if ot-kernel_has_version_pkgflags "x11-drivers/xf86-video-vesa" ; then
		_OT_KERNEL_DEV_MEM=1
	fi
}

# @FUNCTION: ot-kernel-pkgflags_x86info
# @DESCRIPTION:
# Applies kernel config flags for the x86info package
ot-kernel-pkgflags_x86info() { # DONE
	if ot-kernel_has_version_pkgflags "sys-apps/x86info" ; then
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_X86_CPUID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xfce4_battery_plugin
# @DESCRIPTION:
# Applies kernel config flags for the xfce4-battery-plugin package
ot-kernel-pkgflags_xfce4_battery_plugin() { # DONE
	if ot-kernel_has_version_pkgflags "xfce-extra/xfce4-battery-plugin" ; then
		ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xmms2
# @DESCRIPTION:
# Applies kernel config flags for the xmms2
ot-kernel-pkgflags_xmms2() { # DONE
	if ot-kernel_has_version_pkgflags "media-sound/xmms2" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xone
# @DESCRIPTION:
# Applies kernel config flags for the xone package
ot-kernel-pkgflags_xone() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/xone" ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_UHID"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD_FF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xorg_server
# @DESCRIPTION:
# Applies kernel config flags for the xorg-server package
ot-kernel-pkgflags_xorg_server() { # DONE
	if ot-kernel_has_version_pkgflags "x11-base/xorg-server" ; then
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xoscope
# @DESCRIPTION:
# Applies kernel config flags for the xoscope package
ot-kernel-pkgflags_xoscope() { # DONE
	if ot-kernel_has_version_pkgflags "sci-electronics/xoscope" ; then
		ot-kernel_y_configopt "SND_PCM_OSS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpadneo
# @DESCRIPTION:
# Applies kernel config flags for the xpadneo package
ot-kernel-pkgflags_xpadneo() { # DONE
	if ot-kernel_has_version_pkgflags "games-util/xpadneo" ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_UHID"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_INPUT_FF_MEMLESS"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD_FF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpmem
# @DESCRIPTION:
# Applies kernel config flags for the xpmem package
ot-kernel-pkgflags_xpmem() { # DONE
	local pkg="sys-cluster/xpmem"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		if has_version "dev-libs/rccl" ; then
	# It enables the MMU_NOTIFIER indirectly. \
			: # See ot-kernel-pkgflags_roct
		fi
		if [[ $(ot-kernel_get_cpu_vendor) =~ "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_AMD_IOMMU"
			ot-kernel_y_configopt "CONFIG_AMD_IOMMU_V2"
	# It enables the MMU_NOTIFIER indirectly.
		elif [[ $(ot-kernel_get_cpu_vendor) =~ "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_PCI_MSI"
			ot-kernel_y_configopt "CONFIG_ACPI"
			ot-kernel_y_configopt "CONFIG_INTEL_IOMMU"
			ot-kernel_y_configopt "CONFIG_INTEL_IOMMU_SVM"
	# It enables the MMU_NOTIFIER indirectly.
		fi
		if has_version "app-emulation/qemu" ; then
			: # See ot-kernel-pkgflags_qemu
	# It enables the MMU_NOTIFIER indirectly.
		elif has_version "app-emulation/xen" ; then
			: # See ot-kernel-pkgflags_xen
	# It enables the MMU_NOTIFIER indirectly.
		fi
	fi
}


# @FUNCTION: ot-kernel-pkgflags_xpra
# @DESCRIPTION:
# Applies kernel config flags for the xpra package
ot-kernel-pkgflags_xpra() { # DONE
	local pkg="x11-wm/xpra"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[v4l2]" \
	; then
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xtables_addons
# @DESCRIPTION:
# Applies kernel config flags for the xtables-addons package
ot-kernel-pkgflags_xtables_addons() { # DONE
	local pkg="net-firewall/xtables-addons"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[modules]" \
	; then
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		ot-kernel_y_configopt "CONFIG_CONNECTOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_yggdrasil_go
# @DESCRIPTION:
# Applies kernel config flags for the yggdrasil-go package
ot-kernel-pkgflags_yggdrasil_go() { # DONE
	if ot-kernel_has_version_pkgflags "net-p2p/yggdrasil-go" ; then
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zenpower3
# @DESCRIPTION:
# Applies kernel config flags for the zenpower3 package
ot-kernel-pkgflags_zenpower3() { # DONE
	if ot-kernel_has_version_pkgflags "sys-kernel/zenpower3" ; then
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_AMD_NB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zenstates
# @DESCRIPTION:
# Applies kernel config flags for the zenstates package
ot-kernel-pkgflags_zenstates() { # DONE
	if ot-kernel_has_version_pkgflags "sys-power/ZenStates-Linux" ; then
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zfs
# @DESCRIPTION:
# Applies kernel config flags for the zfs package
ot-kernel-pkgflags_zfs() { # DONE
	local pkg="sys-fs/zfs"
	if \
		   ot-kernel_has_version_pkgflags "${pkg}" \
		&& ot-kernel_has_version "${pkg}[test-suite]" \
	; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zfs_kmod
# @DESCRIPTION:
# Applies kernel config flags for the zfs-kmod package
ot-kernel-pkgflags_zfs_kmod() { # DONE
	local pkg="sys-fs/zfs-kmod"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		ban_disable_debug "${pkg}" "CONFIG_DEBUG_LOCK_ALLOC"
		ot-kernel_unset_configopt "CONFIG_DEBUG_LOCK_ALLOC"
		ot-kernel_y_configopt "CONFIG_PARTITION_ADVANCED"
		ot-kernel_y_configopt "CONFIG_EFI_PARTITION"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_unset_configopt "CONFIG_PAX_KERNEXEC_PLUGIN_METHOD_OR" # old
		ot-kernel_unset_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		ot-kernel_y_configopt "CONFIG_ZLIB_DEFLATE"
		ot-kernel_y_configopt "CONFIG_ZLIB_INFLATE"
		if ot-kernel_has_version "${pkg}[debug]" ; then
			ot-kernel_y_configopt "CONFIG_FRAME_POINTER"
			ot-kernel_y_configopt "CONFIG_DEBUG_INFO"
			ot-kernel_unset_configopt "CONFIG_DEBUG_INFO_REDUCED"
		fi
		if ot-kernel_has_version "${pkg}[rootfs]" ; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
			ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -lt "5" ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_NOOP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zoom
# @DESCRIPTION:
# Applies kernel config flags for the zoom package
ot-kernel-pkgflags_zoom() { # DONE
	local pkg="net-im/zoom"
	if ot-kernel_has_version_pkgflags "${pkg}" ; then
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_seccomp_bpf "${pkg}"
	fi
}

# @FUNCTION: _ot-kernel_set_netfilter
# @DESCRIPTION:
# Checks and enables various netfilter support used for firewalls, NAT,
# packet filtering.
_ot-kernel_set_netfilter() {
	[[ -z "${OT_KERNEL_NETFILTER}" ]] && return

	local symbols_ipv4=(
		$(grep "config " "${BUILD_DIR}/net/ipv4/netfilter/Kconfig" \
			| cut -f 2 -d " ")
	)
	local symbols_ipv6=(
		$(grep "config " "${BUILD_DIR}/net/ipv6/netfilter/Kconfig" \
			| cut -f 2 -d " ")
	)
	local symbols_xtables=(
		$(grep "config " "${BUILD_DIR}/net/netfilter/Kconfig" \
			| cut -f 2 -d " ")
	)
	local symbols_ipset=(
		$(grep "config " "${BUILD_DIR}/net/netfilter/ipset/Kconfig" \
			| cut -f 2 -d " ")
	)
	local symbols_ipvs=(
		$(grep "config " "${BUILD_DIR}/net/netfilter/ipvs/Kconfig" \
			| cut -f 2 -d " ")
	)
	local symbols_ebt=(
		$(grep "config " "${BUILD_DIR}/net/bridge/netfilter/Kconfig" \
			| cut -f 2 -d " ")
	)

	if [[ -n "${OT_KERNEL_NETFILTER}" ]] ; then
		local opt
		local opt_raw
		local flag_ipv4=0
		local flag_ipv6=0
		local flag_xtables=0
		local flag_ipset=0
		local flag_ipvs=0
		local flag_ebt=0
		for opt_raw in ${OT_KERNEL_NETFILTER} ; do
			opt_raw="${opt_raw/CONFIG_/}"
			opt=$(echo "${opt_raw}" | cut -f 1 -d "=")
			if [[ "${symbols_ipv4[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_ipv4=1
				if [[ "${opt}" == "NF_NAT_SNMP_BASIC" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_SNMP"
				fi
				if [[ "${opt}" == "NF_NAT_PPTP" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NF_NAT_H323" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "IP_NF_NAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP_NF_TARGET_REJECT" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
				fi
				if [[ "${opt}" == "IP_NF_TARGET_SYNPROXY" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP_NF_MATCH_RPFILTER" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
				fi
				if [[ "${opt}" == "IP_NF_TARGET_CLUSTERIP" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP_NF_TARGET_ECN" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
				fi
				if [[ "${opt}" == "IP_NF_TARGET_TTL" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
				fi
				if [[ "${opt}" == "IP_NF_SECURITY" ]] ; then
					if _ot-kernel_is_hardening_level_least_secure ; then
eerror
eerror "OT_KERNEL_NETFILTER=IP_NF_SECURITY conflicts with"
eerror "OT_KERNEL_HARDENING_LEVEL=fast|fast-af|fast-as-fuck|performance"
eerror
eerror "To continue, change to one of these"
eerror
eerror "  1. OT_KERNEL_HARDENING_LEVEL=secure"
eerror "  2. OT_KERNEL_HARDENING_LEVEL=secure-af"
eerror "  3. Remove OT_KERNEL_NETFILTER=IP_NF_SECURITY"
eerror
						die
					fi

					ot-kernel_y_configopt "CONFIG_SECURITY"
				fi
			fi
			if [[ "${symbols_ipv6[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_ipv6=1
				if [[ "${opt}" == "IP6_NF_MATCH_RPFILTER" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
				fi
				if [[ "${opt}" == "IP6_NF_TARGET_HL" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
				fi
				if [[ "${opt}" == "IP6_NF_TARGET_REJECT" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP6_NF_FILTER"
				fi
				if [[ "${opt}" == "IP6_NF_TARGET_SYNPROXY" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP6_NF_SECURITY" ]] ; then
					if _ot-kernel_is_hardening_level_least_secure ; then
eerror
eerror "OT_KERNEL_NETFILTER=IP6_NF_SECURITY conflicts with"
eerror "OT_KERNEL_HARDENING_LEVEL=fast|fast-af|fast-as-fuck|performance"
eerror
eerror "To continue, change to one of these"
eerror
eerror "  1. OT_KERNEL_HARDENING_LEVEL=secure"
eerror "  2. OT_KERNEL_HARDENING_LEVEL=secure-af"
eerror "  3. Remove OT_KERNEL_NETFILTER=IP6_NF_SECURITY"
eerror
						die
					fi

					ot-kernel_y_configopt "CONFIG_SECURITY"
				fi
				if [[ "${opt}" == "IP6_NF_NAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
			fi
			if [[ "${symbols_xtables[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_xtables=1
				if [[ "${opt}" == "NETFILTER_NETLINK_HOOK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_TABLES"
				fi
				if [[ "${opt}" == "NF_CONNTRACK_SECMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETWORK_SECMARK"
				fi
				if [[ "${opt}" == "NF_CONNTRACK_PROCFS" ]] ; then
					ot-kernel_y_configopt "CONFIG_PROC_FS"
				fi
				if [[ "${opt}" == "NF_CONNTRACK_H323" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "NF_CT_NETLINK_TIMEOUT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_TIMEOUT"
				fi
				if [[ "${opt}" == "NF_CT_NETLINK_HELPER" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
					ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
					ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_GLUE_CT"
				fi
				if [[ "${opt}" == "NETFILTER_NETLINK_GLUE_CT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
					ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
					ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
				fi
				if [[ "${opt}" == "NF_NAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ \
					   "${opt}" == "NF_NAT_AMANDA" \
					|| "${opt}" == "NF_NAT_FTP" \
					|| "${opt}" == "NF_NAT_IRC" \
					|| "${opt}" == "NF_NAT_SIP" \
					|| "${opt}" == "NF_NAT_TFTP" \
				]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NF_TABLES_INET" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" =~ "NFT_" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_TABLES"
				fi
				if [[ "${opt}" == "NFT_CT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NFT_FLOW_OFFLOAD" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_FLOW_TABLE"
				fi
				if [[ "${opt}" == "NFT_CONNLIMIT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NFT_MASQ" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NFT_REDIR" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NFT_NAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV4"
					ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV6"
				fi
				if [[ "${opt}" == "NFT_QUEUE" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
				fi
				if [[ "${opt}" == "NFT_REJECT" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "NFT_REJECT_INET" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_TABLES_INET"
				fi
				if [[ "${opt}" == "NFT_COMPAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
				fi
				if [[ "${opt}" == "NFT_FIB_INET" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_TABLES_INET"
					ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV4"
					ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV6"
				fi
				if [[ "${opt}" == "NFT_XFRM" ]] ; then
					ot-kernel_y_configopt "CONFIG_XFRM"
				fi
				if [[ "${opt}" == "NFT_SOCKET" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "NFT_TPROXY" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "NFT_SYNPROXY" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NFT_FIB_NETDEV" ]] ; then
					ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV4"
					ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV6"
					ot-kernel_y_configopt "CONFIG_NF_TABLES_NETDEV"
				fi
				if [[ "${opt}" == "NFT_REJECT_NETDEV" ]] ; then
					ot-kernel_y_configopt "CONFIG_NFT_REJECT_IPV4"
					ot-kernel_y_configopt "CONFIG_NFT_REJECT_IPV6"
					ot-kernel_y_configopt "CONFIG_NF_TABLES_NETDEV"
				fi
				if [[ "${opt}" == "NF_FLOW_TABLE_INET" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_FLOW_TABLE"
				fi
				if [[ "${opt}" == "NF_FLOW_TABLE" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_INGRESS"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_TABLES"
				fi
				if [[ "${opt}" == "NF_FLOW_TABLE_PROCFS" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_FLOW_TABLE"
					ot-kernel_y_configopt "CONFIG_PROC_FS"
				fi
				if [[ "${opt}" =~ ("NETFILTER_XT"|"NETFILTER_XTABLES_COMPAT") ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
				fi
				if [[ "${opt}" == "NETFILTER_XTABLES_COMPAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_COMPAT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_CONNMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_SET" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_SET"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_AUDIT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NET" # CONFIG_AUDIT dep
					ot-kernel_y_configopt "CONFIG_AUDIT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_CHECKSUM" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_CONNMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_CONNSECMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_SECMARK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_CT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
					ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_DSCP" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_HL" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_HMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_LED" ]] ; then
					ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
					ot-kernel_y_configopt "CONFIG_LEDS_TRIGGERS"
				fi
				if [[ "${opt}" == "NETFILTER_XT_NAT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_NETMAP" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_NOTRACK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
					ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_REDIRECT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_MASQUERADE" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_NAT"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_TEE" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_TPROXY" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
					ot-kernel_y_configopt "CONFIG_IPV6"
					ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_TRACE" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_RAW"
					ot-kernel_y_configopt "CONFIG_IP6_NF_RAW"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_SECMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETWORK_SECMARK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_TCPMSS" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "NETFILTER_XT_TARGET_TCPOPTSTRIP" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"
					ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CGROUP" ]] ; then
					ot-kernel_y_configopt "CONFIG_CGROUPS"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CLUSTER" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CONNBYTES" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CONNLABEL" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CONNLIMIT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CONNMARK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_CONNTRACK" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_HASHLIMIT" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_HELPER" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_IPVS" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_VS"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_POLICY" ]] ; then
					ot-kernel_y_configopt "CONFIG_XFRM"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_PHYSDEV" ]] ; then
					ot-kernel_y_configopt "CONFIG_BRIDGE"
					ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_SOCKET" ]] ; then
					ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
					ot-kernel_y_configopt "CONFIG_IPV6"
					ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
				fi
				if [[ "${opt}" == "NETFILTER_XT_MATCH_STATE" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
			fi
			if [[ "${symbols_ipset[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_ipset=1
			fi
			if [[ "${symbols_ipvs[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_ipvs=1
				if [[ "${opt}" == "IP_VS" ]] ; then
					ot-kernel_y_configopt "CONFIG_INET"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP_VS_IPV6" ]] ; then
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "IP_VS_FTP" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_TCP"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
					ot-kernel_y_configopt "CONFIG_NF_NAT"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_FTP"
				fi
				if [[ "${opt}" == "IP_VS_NFCT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "IP_VS_PE_SIP" ]] ; then
					ot-kernel_y_configopt "CONFIG_IP_VS_PROTO_UDP"
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_SIP"
				fi
			fi
			if [[ "${symbols_ebt[@]}" =~ "${opt}"( |$) ]] ; then
einfo "Added ${opt_raw}"
				if [[ "${opt_raw}" =~ "=" ]] ; then
					opt_val=$(echo "${opt_raw}" | cut -f 2 -d "=")
					ot-kernel_set_configopt "CONFIG_${opt}" "${opt_val}"
				else
					ot-kernel_y_configopt "CONFIG_${opt}"
				fi
				flag_ebt=1
				if [[ "${opt}" == "NF_TABLES_BRIDGE" ]] ; then
					ot-kernel_y_configopt "CONFIG_BRIDGE"
					ot-kernel_y_configopt "CONFIG_NF_TABLES"
				fi
				if [[ "${opt}" == "NFT_BRIDGE_REJECT" ]] ; then
					ot-kernel_y_configopt "CONFIG_NFT_REJECT"
					ot-kernel_y_configopt "CONFIG_NF_REJECT_IPV4"
					ot-kernel_y_configopt "CONFIG_NF_REJECT_IPV6"
				fi
				if [[ "${opt}" == "NF_CONNTRACK_BRIDGE" ]] ; then
					ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
				fi
				if [[ "${opt}" == "BRIDGE_NF_EBTABLES" ]] ; then
					ot-kernel_y_configopt "CONFIG_BRIDGE"
					ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
				fi
				if [[ "${opt}" == "BRIDGE_EBT_IP6" ]] ; then
					ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
					ot-kernel_y_configopt "CONFIG_IPV6"
				fi
				if [[ "${opt}" == "BRIDGE_EBT_ARPREPLY" ]] ; then
					ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
					ot-kernel_y_configopt "CONFIG_INET"
				fi
			fi
		done
		if (( \
			   ${flag_ipv4} == 1 \
			|| ${flag_ipv6} == 1 \
			|| ${flag_xtables} == 1 \
			|| ${flag_ipset} == 1 \
			|| ${flag_ipvs} == 1 \
			|| ${flag_ebt} == 1 \
		)) ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
		fi
		if (( ${flag_ipv4} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_INET"
			ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		fi
		if (( ${flag_ipv6} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_INET"
			ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
		fi
		if (( ${flag_xtables} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_INET"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"

			ot-kernel_y_configopt "CONFIG_NF_TABLES"
		fi
		if (( ${flag_ipset} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_IP_SET"
			ot-kernel_y_configopt "CONFIG_INET"
		fi
		if (( ${flag_ipvs} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_IP_VS"
		fi
		if (( ${flag_ebt} == 1 )) ; then
			ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
		fi
	fi
}

#
# CONFIG_AIO search keywords:
# io_setup
#

#
# CONFIG_BPF_SYSCALL search keywords:
# BPF_STMT
#

#
# CONFIG_FHANDLE search keywords:
# open_by_handle_at
# name_to_handle_at
#

# @FUNCTION: _ot-kernel_set_futex
# @DESCRIPTION:
# Add compatibility for futex / futex_wait_multiple (31)
#
# Search keywords:
# __NR_futex
# SYS_futex from libc which aliases it with __NR_futex
# syscall.*__NR_futex.*31				; support dropped
#
_ot-kernel_set_futex() {
	if has futex ${IUSE_EFFECTIVE} && ot-kernel_use futex ; then
einfo "Enabling futex in .config"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: _ot-kernel_set_futex2
# @DESCRIPTION:
# Add compatibility for futex2 / futex_wait_multiple (449)
#
# Search keywords:
# __NR_futex_waitv
# __NR_futex_waitv.*449
# SYS_futex_waitv from libc which aliases it with __NR_futex_waitv
# syscall.*__NR_futex_waitv
#
_ot-kernel_set_futex2() {
	if has futex2 ${IUSE_EFFECTIVE} && ot-kernel_use futex2 ; then
einfo "Enabling futex2 in .config"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_FUTEX2"
	fi
}

# @FUNCTION: _ot-kernel_set_ldt
# @DESCRIPTION:
# Add compatibility for 16-bit apps including LDT.
_ot-kernel_set_ldt() {
	if [[ "${EMU_16BIT:-0}" == "1" ]] ; then
einfo "Enabling 16-bit emulation support"
		if [[ "${OT_KERNEL_HALT_ON_LOWERED_SECURITY}" == "1" ]] ; then
eerror
eerror "Lowered security was detected for EMU_16BIT=1."
eerror
eerror "To permit security lowering set OT_KERNEL_HALT_ON_LOWERED_SECURITY=0."
eerror "Search for _ot-kernel_set_ldt in the ot-kernel-pkgflags.eclass in the"
eerror "eclass folder for details."
eerror
			die
		else
ewarn
ewarn "Security is lowered for EMU_16BIT=1."
ewarn
ewarn "To halt on lowered security, set OT_KERNEL_HALT_ON_LOWERED_SECURITY=1."
ewarn "Search FOR _ot-kernel_set_ldt in the ot-kernel-pkgflags.eclass in the"
ewarn "eclass folder for details."
ewarn
		fi
		ot-kernel_y_configopt "CONFIG_X86_16BIT"
		ot-kernel_y_configopt "CONFIG_MODIFY_LDT_SYSCALL" # Lowered security
	fi
}

# @FUNCTION: _ot-kernel_set_multiuser
# @DESCRIPTION:
# Add compatibility for multiuser
_ot-kernel_set_multiuser() {
	if [[ \
		   -e "${EROOT}/var/db/pkg/acct-group" \
		|| -e "${EROOT}/var/db/pkg/acct-user" \
	]] ; then
einfo "Enabling multiuser / multigroup support"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: _ot-kernel_set_cgroup_ns
# @DESCRIPTION:
# Enable CGROUP_NS and flag dependencies
_ot-kernel_set_cgroup_ns() {
	ot-kernel_y_configopt "CONFIG_CGROUPS"
}

# @FUNCTION: _ot-kernel_set_ipc_ns
# @DESCRIPTION:
# Enable IPC_NS and flag dependencies
_ot-kernel_set_ipc_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_SYSVIPC"
	_ot-kernel_set_posix_mqueue
	ot-kernel_y_configopt "CONFIG_IPC_NS"
}

# @FUNCTION: _ot-kernel_set_pid_ns
# @DESCRIPTION:
# Enable PID_NS and flag dependencies
_ot-kernel_set_pid_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_PID_NS"
}

# @FUNCTION: _ot-kernel_set_net_ns
# @DESCRIPTION:
# Enable NET_NS and flag dependencies
_ot-kernel_set_net_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NET_NS"
}

# @FUNCTION: _ot-kernel_set_time_ns
# @DESCRIPTION:
# Enable TIME_NS and flag dependencies
_ot-kernel_set_time_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_GENERIC_VDSO_TIME_NS"
	ot-kernel_y_configopt "CONFIG_TIME_NS"
}

# @FUNCTION: _ot-kernel_set_user_ns
# @DESCRIPTION:
# Enable USER_NS and flag dependencies
_ot-kernel_set_user_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_USER_NS"
}

# @FUNCTION: _ot-kernel_set_uts_ns
# @DESCRIPTION:
# Enable UTS_NS and flag dependencies
_ot-kernel_set_uts_ns() {
	ot-kernel_y_configopt "CONFIG_MULTIUSER"
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_UTS_NS"
}

# @FUNCTION: _ot-kernel_set_posix_mqueue
# @DESCRIPTION:
# Enable POSIX_MQUEUE and flag dependencies
_ot-kernel_set_posix_mqueue() {
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_POSIX_MQUEUE"
}

# @FUNCTION: _ot-kernel_set_shmem
# @DESCRIPTION:
# Enable SHMEM and flag dependencies
_ot-kernel_set_shmem() {
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_SHMEM"
}

# @FUNCTION: _ot-kernel_set_io_uring
# @DESCRIPTION:
# Enable asynchronous IO using circular queue buffers
#
# See also:
#
#   https://en.wikipedia.org/wiki/Io_uring#Security
#
_ot-kernel_set_io_uring() {
	_ot-kernel_validate_hardening_level
	if _ot-kernel_is_hardening_level_custom ; then
		:
	elif _ot-kernel_is_hardening_level_most_secure ; then
	# Increased security
		ot-kernel_unset_configopt "CONFIG_IO_URING"
	else
		ot-kernel_y_configopt "CONFIG_IO_URING"
	fi
}

# @FUNCTION: ot-kernel_supports_rt
# @DESCRIPTION:
# Reports if rt patchset is supported.
ot-kernel_supports_rt() {
	if [[ \
		   "${arch}" == "arm" \
		|| "${arch}" == "arm64" \
		|| "${arch}" == "powerpc" \
		|| "${arch}" == "x86" \
		|| "${arch}" == "x86_64" \
	]] ; then
		return 0
	else
		return 1
	fi
}

# Non canonical value -> intermediate value
# Which is more important?  audio, input, power, jitter, throughput-headless, throughput-interactive, video
unset WORK_PROFILE_LATENCY_BIAS_KEY
declare -A WORK_PROFILE_LATENCY_BIAS_KEY=(
        ["builder-dedicated"]="throughput-headless"
        ["builder-interactive"]="throughput-interactive"
        ["cryptocurrency-miner-dedicated"]="throughput-headless"
        ["cryptocurrency-miner-workstation"]="throughput-interactive"
        ["casual-gaming"]="input"
        ["casual-gaming-laptop"]="input"
        ["custom"]="input" # placeholder
        ["database-server"]="alert-server"
        ["datacenter-backend"]="alert-server"
        ["digital-audio-workstation"]="audio"
        ["distributed-computing-client"]="throughput-interactive"
        ["distributed-computing-server"]="sleepy-server"
        ["vm-guest-desktop"]="video"
        ["dss"]="input"
        ["dvr"]="video"
        ["file-server"]="sleepy-server"
        ["gaming-tournament"]="input"
        ["game-server"]="alert-server"
        ["gamedev"]="throughput-interactive"
        ["vm-guest-gaming"]="input"
        ["gpu-gaming-laptop"]="input"
        ["green-pc"]="power"
        ["hpc"]="throughput-headless"
        ["hpc-green"]="power"
        ["hpc-throughput"]="throughput"
        ["jukebox"]="audio"
        ["laptop"]="power"
        ["live-streaming-gamer"]="input"
        ["live-video-reporter"]="audio"
        ["mainstream-desktop"]="video"
        ["manual"]="input" # placeholder
        ["media-player"]="video"
        ["media-server"]="relaxed-server"
        ["musical-live-performance"]="audio"
        ["pi-audio-player"]="audio"
        ["pi-deep-learning"]="jitter"
        ["pi-gaming"]="input"
        ["pi-media-player"]="video"
        ["pi-music-production"]="audio"
        ["pi-video-player"]="video"
        ["pi-web-browser"]="video"
        ["presentation"]="video"
        ["pro-gaming"]="input"
        ["radio-broadcaster"]="audio"
        ["hpc-realtime"]="jitter"
        ["renderfarm-dedicated"]="throughput-headless"
        ["renderfarm-workstation"]="throughput-interactive"
        ["ros"]="jitter"
        ["sdr"]="audio"
        ["smartphone"]="power"
        ["smartphone-voice"]="audio"
        ["solar-desktop"]="input"
        ["solar-gaming"]="input"
        ["streaming-server"]="alert-server"
        ["tablet"]="power"
        ["touchscreen-laptop"]="video"
        ["video-conferencing"]="audio"
        ["voip"]="audio"
        ["website-enterprise"]="alert-server"
        ["website-interactive"]="alert-server"
        ["website-small"]="relaxed-server"
        ["workstation"]="throughput-interactive"
)

# intermediate value -> canonical value without PREEMPT_RT
unset WORK_PROFILE_LATENCY_BIAS_SETTING
declare -A WORK_PROFILE_LATENCY_BIAS_SETTING=(
	["alert-server"]="CONFIG_PREEMPT"
	["audio"]="CONFIG_PREEMPT"
	["input"]="CONFIG_PREEMPT"
	["jitter"]="CONFIG_PREEMPT"
	["power"]="CONFIG_PREEMPT_NONE"
	["relaxed-server"]="CONFIG_PREEMPT_VOLUNTARY"
	["sleepy-server"]="CONFIG_PREEMPT_NONE"
	["throughput-headless"]="CONFIG_PREEMPT_NONE"
	["throughput-interactive"]="CONFIG_PREEMPT_VOLUNTARY"
	["video"]="CONFIG_PREEMPT_VOLUNTARY"
)

# 4.14:
# 4.19:
#   PREEMPT__LL [aka PREEMPT]
#   PREEMPT_RTB
#   PREEMPT_RT_BASE [aka Basic RT for debugging]
#   PREEMPT_RT_FULL
# 5.4+:
#   PREEMPT_RT
#
# TODO:  init script
#   For SCHED_OTHER -> SCHED_OTHER
#   echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features [low-latency determinism]
#   echo PREEMPT_LAZY >/sys/kernel/debug/sched_features (default on) [higher throughput]

# @FUNCTION: ot-kernel_set_preempt
# @DESCRIPTION:
# Wrapper to set kernel config preempt
ot-kernel_set_preempt() {
	local preempt_option="${1}"
	local coldfire="0"
	if grep -q -e "^CONFIG_COLDFIRE=y" "${path_config}" ; then
		coldfire="1"
	fi
	if [[ \
		 ( "${arch}" == "m86k" && "${coldfire}" == "0" ) \
		|| "${arch}" == "um" \
		|| "${arch}" == "alpha" \
		|| "${arch}" == "hexagon" \
	]] ; then
	# Arches that do not support preempt
		ot-kernel_unset_configopt "CONFIG_PREEMPT"
		ot-kernel_unset_configopt "CONFIG_PREEMPT__LL"
		ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
		if ot-kernel_use rt ; then
ewarn
ewarn "The rt patchset is not compatible with ARCH=${arch}.  Forcing"
ewarn "PREEMPT_NONE=y.  Remove rt from OT_KERNEL_USE to silence this error."
ewarn
		fi
	else
		if ot-kernel_supports_rt && ot-kernel_use rt ; then
			if         grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" \
				|| grep -q -e "^CONFIG_PREEMPT_RT_BASE=y" "${path_config}" \
				|| grep -q -e "^CONFIG_PREEMPT_RT_FULL=y" "${path_config}" \
			; then
	# Real time cannot be stopped or dropped.
				:
			else
	# Promote/demote
				if [[ "${preempt_option}" == "CONFIG_PREEMPT" ]] ; then
					if ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
						ot-kernel_y_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT__LL"
					else
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_y_configopt "CONFIG_PREEMPT__LL"
					fi
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_NONE" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_RT" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					if ver_test "${KV_MAJOR_MINOR}" -ge "5.4" ; then
						ot-kernel_y_configopt "CONFIG_PREEMPT_RT"
					else
						ot-kernel_y_configopt "CONFIG_PREEMPT_RT_FULL"
					fi
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_y_configopt "CONFIG_PREEMPT_VOLUNTARY"
				fi
			fi
		else
	# Non RT case
			if [[ \
				   "${preempt_option}" == "CONFIG_PREEMPT_RT" \
				|| "${preempt_option}" == "CONFIG_PREEMPT_AUTOMAGIC" \
			]] ; then
				local key="${WORK_PROFILE_LATENCY_BIAS_KEY[work_profile]}"
				if [[ \
					   "${work_profile}" == "custom" \
					|| "${work_profile}" == "manual" \
				]] ; then
					:
				elif [[ -n "${key}" ]] ; then
	# Downgrade latency based on user hint
					local setting="${WORK_PROFILE_LATENCY_BIAS_SETTING[${key}]}"
					ot-kernel_y_configopt "${setting}"
					if [[ "${setting}" == "CONFIG_PREEMPT" ]] ; then
						ot-kernel_y_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
					elif [[ "${setting}" == "CONFIG_PREEMPT_NONE" ]] ; then
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
					elif [[ "${setting}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
						ot-kernel_y_configopt "CONFIG_PREEMPT_VOLUNTARY"
					fi
				else
	# Downgrade to low latency
					ot-kernel_y_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				fi
			else
	# Non-realtime direct change
				if [[ "${preempt_option}" == "CONFIG_PREEMPT" ]] ; then
					ot-kernel_y_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_NONE" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_BASE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT_FULL"
					ot-kernel_y_configopt "CONFIG_PREEMPT_VOLUNTARY"
				fi
			fi
		fi
	fi
	if grep -q -e "^CONFIG_TRANSPARENT_HUGEPAGE=y" "${path_config}" && grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" ; then
		ot-kernel_unset_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	fi
	if grep -q -e "^CONFIG_PREEMPT_NONE=y" "${path_config}" ; then
einfo "Using PREEMPT_NONE"
	elif grep -q -e "^CONFIG_PREEMPT=y" "${path_config}" ; then
einfo "Using PREEMPT"
	elif grep -q -e "^CONFIG_PREEMPT__LL=y" "${path_config}" ; then
einfo "Using PREEMPT__LL" # Same as PREEMPT in < 5.4
	elif grep -q -e "^CONFIG_PREEMPT_VOLUNTARY=y" "${path_config}" ; then
einfo "Using PREEMPT_VOLUNTARY"
	elif grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" ; then
einfo "Using PREEMPT_RT"
	elif grep -q -e "^CONFIG_PREEMPT_RT_BASE=y" "${path_config}" ; then
einfo "Using PREEMPT_RT_BASE" # For debugging in < 5.4
	elif grep -q -e "^CONFIG_PREEMPT_RT_FULL=y" "${path_config}" ; then
einfo "Using PREEMPT_RT_FULL" # For production in < 5.4
	fi
}

# @FUNCTION: _ot-kernel_y_thp
# @DESCRIPTION:
# Enables transparent huge pages
_ot-kernel_y_thp() {
	local is_rt=0

	if \
		   grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" \
		|| grep -q -e "^CONFIG_PREEMPT_RT_BASIC=y" "${path_config}" \
		|| grep -q -e "^CONFIG_PREEMPT_RT_FULL=y" "${path_config}" \
	; then
		is_rt=1
	fi

	# Usally low latency or memory intense servers/apps
	if [[ \
		   "${work_profile}" == "database-server" \
		|| "${work_profile}" == "datacenter-backend" \
		|| "${work_profile}" == "hpc" \
		|| "${work_profile}" == "hpc-green" \
		|| "${work_profile}" == "hpc-realtime" \
		|| "${work_profile}" == "hpc-thoughput" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "musical-live-performance" \
		|| "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "streaming-server" \
		|| "${work_profile}" == "website-enterprise" \
		|| "${work_profile}" == "website-interactive" \
		|| "${work_profile}" == "website-small" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
		|| "${work_profile}" == "vm-guest-desktop" \
		|| "${work_profile}" == "vm-guest-gaming" \
	]] ; then
	# Avoid latency spike case
		ot-kernel_unset_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	elif grep -q -e "^CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y" "${path_config}" && (( ${is_rt} != 1 )) ; then
		ot-kernel_y_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	else
		ot-kernel_unset_configopt "CONFIG_TRANSPARENT_HUGEPAGE"
	fi
}

# @FUNCTION: _ot-kernel_realtime_pkg
# @DESCRIPTION:
# Handle SCHED_FIFO/SCHED_RR package.
_ot-kernel_realtime_pkg() {
	local pkg="${1}"
	local prio_class="${2}"
	if ot-kernel_has_version "${pkg}" ; then
		ot-kernel_y_configopt "CONFIG_RT_PACKAGE_FOUND"
		if ot-kernel_use rt ; then
ewarn "Detected ${prio_class} package for ${pkg}.  Using PREEMPT_RT=y"
			ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
		else
ewarn "Detected ${prio_class} package for ${pkg}.  Using PREEMPT=y"
			ot-kernel_set_preempt "CONFIG_PREEMPT"
		fi

		# SCHED_RR is 100 ms here but can be changed with sched_rr_timeslice_ms.
		if [[ "${prio_class}" =~ "SCHED_RR" ]] ; then
			if [[ "${arch}" == "alpha" ]] && ( \
				   grep -q -E -e "^CONFIG_HZ_32=y" "${path_config}" \
				|| grep -q -E -e "^CONFIG_HZ_64=y" "${path_config}" \
			) ; then
				ot-kernel_unset_configopt "CONFIG_HZ_32"
				ot-kernel_unset_configopt "CONFIG_HZ_64"
				ot-kernel_y_configopt "CONFIG_HZ_128"
				ot-kernel_set_configopt "CONFIG_HZ" "128"
			elif [[ "${arch}" == "mips" ]] && ( \
				   grep -q -E -e "^CONFIG_HZ_24=y" "${path_config}" \
				|| grep -q -E -e "^CONFIG_HZ_48=y" "${path_config}" \
			) ; then
				ot-kernel_unset_configopt "CONFIG_HZ_24"
				ot-kernel_unset_configopt "CONFIG_HZ_48"
				ot-kernel_y_configopt "CONFIG_HZ_100"
				ot-kernel_set_configopt "CONFIG_HZ" "100"
			fi
		fi
	fi
}

# @FUNCTION: _ot-kernel_realtime_packages
# @DESCRIPTION:
# Change the kernel for realtime programs
_ot-kernel_realtime_packages() {
	# This is how realtime/preemption is changed.
	# * On demand if OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
	# * Blanket policy if OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=0
	ot-kernel_unset_configopt "CONFIG_RT_PACKAGE_FOUND"

	# TODO:  hard realtime packages.

	# Disabling network could remove it as a source of latency.
	# If a package requires network, the profile could be demoted to PREEMPT=y.

	# General realtime/low-latency support for audio
	if [[ \
		   "${work_profile}" == "digital-audio-workstation" \
		|| "${work_profile}" == "jukebox" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "musical-live-performance" \
		|| "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "sdr" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
		_ot-kernel_realtime_pkg "media-libs/libpulse" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/libsoundio" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/portaudio" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/roc-toolkit" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/bluez-alsa" "SCHED_RR" # It requires bluealsa.service changes.
		_ot-kernel_realtime_pkg "media-sound/darkice" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/jacktrip" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/jamesdsp[pulseaudio]" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/pulseaudio-daemon" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-video/pipewire" "SCHED_FIFO"

		# Disabled since no well known examples.
		# It is used for web based synthesizers like learning music sites.
		#_ot-kernel_realtime_pkg "net-libs/webkit-gtk" "SCHED_RR" # For AudioWorklet
		#_ot-kernel_realtime_pkg "www-client/chromium" "SCHED_RR" # For AudioWorklet
		# TODO:  Include all blink browsers
	fi

	# Music producers
	if [[ "${work_profile}" == "digital-audio-workstation" ]] ; then
		_ot-kernel_realtime_pkg "app-emulation/wine-staging" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "app-emulation/wine-vanilla" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "dev-lang/faust" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/distrho-ports" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/ir_lv2" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-plugins/nekobi" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/x42-avldrums" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-plugins/x42-plugins" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/6pm" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/aeolus" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/amsynth" "SCHED_FIFO" # It needs ebuild changes to explicitly enable.
		_ot-kernel_realtime_pkg "media-sound/ardour" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/bristol" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/carla" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/chuck" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/csound" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/din" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/drumstick" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/fluidsynth" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/guitarix" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/helm" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/hydrogen" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/jack-audio-connection-kit" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/jack2" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/linuxsampler" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/lmms" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/mixxx" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/museseq" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/pulseeffects" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/pure-data" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/rosegarden" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/sc3-plugins" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/seq24" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/sequencer64" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/supercollider" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/terminatorx" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/timidity++[alsa]" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/xwax" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/yoshimi" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/zynaddsubfx[alsa]" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "sys-apps/das_watchdog" "SCHED_RR" # Used in audio overlay
		_ot-kernel_realtime_pkg "sys-auth/rtkit" "SCHED_FIFO|SCHED_RR" # No dependencies
	fi

	# Live voice
	if [[ \
		   "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
		_ot-kernel_realtime_pkg "kde-plasma/kwin" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/libtgvoip" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/mediastreamer2" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/rtaudio" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/svt-av1" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/svt-hevc" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/svt-vp9" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/tg_owt" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/webrtc-audio-processing" "SCHED_FIFO"
		# _ot-kernel_realtime_pkg "net-libs/ortp" "SCHED_FIFO|SCHED_RR" # Set through environment variable.  Default disabled.
		_ot-kernel_realtime_pkg "net-voip/mumble" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-voip/umurmur" "SCHED_RR"
		_ot-kernel_realtime_pkg "net-voip/yate" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "x11-misc/picom" "SCHED_RR"
		_ot-kernel_realtime_pkg "x11-wm/ukui-kwin" "SCHED_RR"
		# _ot-kernel_realtime_pkg "net-voip/twinkle" "SCHED_FIFO" # It's present but disabled in source code.
	fi

	# Live music or presentation by same artist
	if [[ \
		   "${work_profile}" == "jukebox" \
		|| "${work_profile}" == "musical-live-performance" \
	]] ; then
		_ot-kernel_realtime_pkg "media-sound/alsaplayer" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/aqualung" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/cmus" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/gogglesmm" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/mikmod" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/mpd" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/mpg123-base" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/sndpeek" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/squeezelite" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/strawberry[gstreamer]" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/wavplay" "SCHED_FIFO"
	fi

	# Radio
	if [[ "${work_profile}" == "sdr" ]] ; then
		_ot-kernel_realtime_pkg "net-wireless/cubicsdr" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-wireless/gnuradio" "SCHED_FIFO|SCHED_RR"
	fi

	# Video editing
	if [[ \
		   "${work_profile}" == "live-streaming-gamer" \
		|| "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "streamer-reporter" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
		_ot-kernel_realtime_pkg "media-libs/mlt" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-video/dvgrab" "SCHED_RR"
	fi

	# TTS
	if [[ \
		   "${work_profile}" == "live-video-reporter" \
		|| "${work_profile}" == "streamer-reporter" \
	]] ; then
		_ot-kernel_realtime_pkg "app-accessibility/julius[portaudio]" "SCHED_FIFO"
	fi

	# General gaming
	if [[ \
		   "${work_profile}" == "casual-gaming" \
		|| "${work_profile}" == "casual-gaming-laptop" \
		|| "${work_profile}" == "game-server" \
		|| "${work_profile}" == "gamedev" \
		|| "${work_profile}" == "gaming-tournament" \
		|| "${work_profile}" == "gpu-gaming-laptop" \
		|| "${work_profile}" == "pi-gaming" \
		|| "${work_profile}" == "pro-gaming" \
		|| "${work_profile}" == "solar-gaming" \
	]] ; then
		# Assumes PREEMPT=y
		_ot-kernel_realtime_pkg "app-emulation/basiliskii" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "app-emulation/wine-proton" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "app-emulation/wine-staging" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "app-emulation/wine-vanilla" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "games-emulation/desmume" "SCHED_RR"
		_ot-kernel_realtime_pkg "games-emulation/dosbox-x" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "games-emulation/fceux" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "gui-wm/gamescope" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/oaml" "SCHED_RR"
		#_ot-kernel_realtime_pkg "media-sound/pianobooster" "SCHED_FIFO" # It's default off unless built with -DUSE_REALTIME_PRIORITY=1
	fi

	# High end gaming
	if [[ \
		   "${work_profile}" == "gpu-gaming-laptop" \
		|| "${work_profile}" == "pro-gaming" \
		|| "${work_profile}" == "solar-gaming" \
	]] ; then
		# Assumes PREEMPT=y
		_ot-kernel_realtime_pkg "net-voip/mumble" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/openal" "SCHED_RR"
	fi

	# High availability servers
	if [[ \
		   "${work_profile}" == "database-server" \
		|| "${work_profile}" == "datacenter-backend" \
		|| "${work_profile}" == "distributed-computing-server" \
		|| "${work_profile}" == "game-server" \
		|| "${work_profile}" == "hpc-realtime" \
		|| "${work_profile}" == "media-server" \
		|| "${work_profile}" == "streaming-server" \
		|| "${work_profile}" == "website-enterprise" \
		|| "${work_profile}" == "website-interactive" \
		|| "${work_profile}" == "website-small" \
	]] ; then
		_ot-kernel_realtime_pkg "sys-apps/watchdogd" "SCHED_RR"
		_ot-kernel_realtime_pkg "sys-cluster/keepalived" "SCHED_RR"
	fi

	# Time sensitive servers
	if [[ \
		   "${work_profile}" == "database-server" \
		|| "${work_profile}" == "dss" \
		|| "${work_profile}" == "distributed-computing-server" \
		|| "${work_profile}" == "game-server" \
		|| "${work_profile}" == "hpc-realtime" \
		|| "${work_profile}" == "media-server" \
		|| "${work_profile}" == "streaming-server" \
		|| "${work_profile}" == "website-enterprise" \
		|| "${work_profile}" == "website-interactive" \
		|| "${work_profile}" == "website-small" \
	]] ; then
		_ot-kernel_realtime_pkg "net-misc/chrony" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-misc/ntp" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-misc/ntpsec" "SCHED_FIFO"
	fi

	# Realtime website servers
	if [[ \
		   "${work_profile}" == "website-enterprise" \
		|| "${work_profile}" == "website-interactive" \
		|| "${work_profile}" == "website-small" \
	]] ; then
		_ot-kernel_realtime_pkg "dev-php/hhvm" "SCHED_RR"
		_ot-kernel_realtime_pkg "net-analyzer/netdata" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "www-servers/civetweb" "SCHED_RR"
	fi

	# Authentication servers
	if [[ \
		   "${work_profile}" == "dss" \
	]] ; then
		_ot-kernel_realtime_pkg "net-fs/samba[ads]" "SCHED_FIFO"
	fi

	# Realtime database servers
	if [[ \
		   "${work_profile}" == "database-server" \
		|| "${work_profile}" == "datacenter-backend" \
	]] ; then
		_ot-kernel_realtime_pkg "dev-db/keydb" "SCHED_FIFO"
	fi

	# The packages above hint that low latency may be necessary.

	# Discovered but not required for low-latency boosting.
	# Candidates for proactive boost.
	# _ot-kernel_realtime_pkg "dev-util/trace-cmd" "SCHED_FIFO"
	# _ot-kernel_realtime_pkg "dev-db/mysql" "SCHED_FIFO|SCHED_RR" # #718068

	# Denied proactive change.
	# These inherit existing preempt setting instead.
	# _ot-kernel_realtime_pkg "app-benchmarks/interbench" "SCHED_FIFO"
	# _ot-kernel_realtime_pkg "app-benchmarks/stress-ng" "SCHED_FIFO|SCHED_RR"
	# _ot-kernel_realtime_pkg "dev-lang/mono" "SCHED_FIFO" # Inherit from app project
	# _ot-kernel_realtime_pkg "net-p2p/cpuminer-opt" "SCHED_RR"
	# _ot-kernel_realtime_pkg "sys-apps/openrc" "SCHED_FIFO|SCHED_RR"
	# _ot-kernel_realtime_pkg "sys-apps/systemd" "SCHED_FIFO|SCHED_RR"
}

# @FUNCTION: _ot-kernel_checkpoint_dss_anti_malware_requirement
# @DESCRIPTION:
# Check for the anti-malware requirements.
_ot-kernel_checkpoint_dss_anti_malware_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
		if ot-kernel_has_version "app-antivirus/clamav" ; then
			:
		else
# List only production quality for now
eerror
eerror "Please install an antivirus."
eerror
eerror "Acceptable packages:"
eerror
eerror "app-antivirus/clamav"
eerror
			die
		fi
# Integrity checks
		if ot-kernel_has_version "app-forensics/aide" ; then
ewarn "app-forensics/aide should be added for integrity verification for dss work profile."
		fi
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_audit_logs_requirement
# @DESCRIPTION:
# Check for audit logs support.
_ot-kernel_checkpoint_dss_audit_logs_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
		if ! ot-kernel_use debug ; then
eerror
eerror "The debug USE flag should be enabled for the dss work profile"
eerror "to enable logging."
eerror
			die
		fi
		if ot-kernel_has_version "virtual/logger" ; then
			:
		else
eerror
eerror "A logger from virtual/logger is required for the dss work profile."
eerror
			die
		fi
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_firewall_requirement
# @DESCRIPTION:
# Check for the firewall requirement.
_ot-kernel_checkpoint_dss_firewall_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
# This is optional because a hardware firewall may be used instead.
		if [[ "${DSS_FIREWALL_TYPE}" == "waf" ]] ; then
			:
		elif ot-kernel_has_version "net-firewall/iptables" ; then
			:
		elif ot-kernel_has_version "net-firewall/nftables" ; then
			:
		elif ot-kernel_has_version "net-firewall/shorewall" ; then
			:
		else
# List only well known for now
ewarn
ewarn "Please install a firewall for the dss work profile."
ewarn
ewarn "Choose either one of firewall:"
ewarn
ewarn "net-firewall/iptables"
ewarn "net-firewall/nftables"
ewarn "net-firewall/shorewall"
ewarn
ewarn "or"
ewarn
ewarn "A Web Application Firewall (WAF) with DSS_FIREWALL_TYPE=\"waf\" environment variable"
ewarn
		fi
	fi
}

# @FUNCTION: __ot-kernel_set_acl_one_package
# @DESCRIPTION:
# Enable access control list (ACL) support for one package.
__ot-kernel_set_acl_one_package() {
	if grep -q -E -e "^CONFIG_BTRFS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_BTRFS_FS_POSIX_ACL"
	fi
	if grep -q -E -e "^CONFIG_CEPH_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_CEPH_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_CEPH_FS_SECURITY_LABEL"
	fi
	if grep -q -E -e "^CONFIG_CIFS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_CIFS_XATTR"
		ot-kernel_y_configopt "CONFIG_CIFS_POSIX"
	fi
	if grep -q -E -e "^CONFIG_EXT2_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_EXT2_FS_XATTR"
	fi
	if grep -q -E -e "^CONFIG_EXT3_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_EXT3_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_EXT3_FS_SECURITY"
	fi
	if grep -q -E -e "^CONFIG_EXT4_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_EXT4_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_EXT4_FS_SECURITY"
	fi
	if grep -q -E -e "^CONFIG_JFS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_JFS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_JFS_SECURITY"
		fi
	if grep -q -E -e "^CONFIG_XFS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_XFS_POSIX_ACL"
	fi
	if grep -q -E -e "^CONFIG_F2FS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_F2FS_FS_XATTR"
			ot-kernel_y_configopt "CONFIG_F2FS_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_F2FS_FS_SECURITY"
	fi
	if grep -q -E -e "^CONFIG_EROFS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_EROFS_FS_XATTR"
		ot-kernel_y_configopt "CONFIG_EROFS_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_EROFS_FS_SECURITY"
	fi
	if grep -q -E -e "^CONFIG_NFS_FS=(y|m)" "${path_config}" ; then
		if grep -q -E -e "^CONFIG_NFS_V3=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NFS_V3_ACL"
		fi
	fi
	if grep -q -E -e "^CONFIG_NFSD=(y|m)" "${path_config}" ; then
		if grep -q -E -e "^CONFIG_NFSD_V2=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NFSD_V2_ACL"
		fi
		ot-kernel_y_configopt "CONFIG_NFSD_V3_ACL"
		if grep -q -E -e "^CONFIG_NFSD_V4=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NFSD_V4_SECURITY_LABEL"
			ot-kernel_y_configopt "CONFIG_PROC_FS"
		fi
	fi
	if grep -q -E -e "^CONFIG_REISERFS_FS=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_REISERFS_FS_XATTR"
		ot-kernel_y_configopt "CONFIG_REISERFS_FS_POSIX_ACL"
	fi
	if grep -q -E -e "^CONFIG_TMPFS_POSIX_ACL=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
	fi
}

# @FUNCTION: _ot-kernel_set_acl
# @DESCRIPTION:
# Enable access control list (ACL) support typically because the acl USE flag was enabled.
_ot-kernel_set_acl() {
	local PKGS=(
# Manually inspect for false-positives or wrong USE flag.
#
# Generated from:
#
# grep -r -E -l --exclude-dir=.git "IUSE.*acl" $(find /usr/portage -name "*.ebuild") | cut -f 4-5 -d "/" | sort | uniq
# grep -r -E -l --exclude-dir=.git "IUSE.*acl" $(find /var/db/repos/ -name "*.ebuild") | cut -f 6-7 -d "/" | sort | uniq
#
app-admin/logrotate
app-arch/rpm
app-arch/tar
app-backup/bacula
app-backup/bareos
app-backup/burp
app-backup/tarsnap
app-backup/tsm
app-cdr/cdrtools
app-editors/emacs
app-editors/gvim
app-editors/vim
app-editors/vim-core
app-editors/zile
app-forensics/aide
app-forensics/openscap
dev-db/tora
dev-lang/php
dev-libs/libisoburn
dev-libs/libisofs
dev-util/diffoscope
games-util/game-device-udev-rules
kde-frameworks/kio
net-analyzer/check_mk_agent
net-fs/cifs-utils
net-fs/netatalk
net-fs/samba
net-ftp/proftpd
net-misc/rsync
net-print/cups
net-proxy/privoxy
sci-geosciences/qgis
sys-apps/bfs
sys-apps/coreutils
sys-apps/fakeroot
sys-apps/sed
sys-apps/shadow
sys-apps/systemd
sys-apps/systemd-utils
sys-auth/elogind
sys-auth/sssd
sys-cluster/pacemaker
sys-devel/gettext
sys-fs/btrfs-progs
sys-fs/mtd-utils
sys-fs/ntfs3g
sys-fs/udisks
virtual/acl
www-apps/tt-rss
	)

	local pkg
	# Conditional USE flag
	for pkg in ${PKGS[@]} ; do
		  if [[ "${pkg}" == "sys-fs/btrfs-progs" ]] && ot-kernel_has_version "${pkg}[convert]" ; then
			__ot-kernel_set_acl_one_package
		elif [[ "${pkg}" == "sys-fs/mtd-utils" ]]   && ot-kernel_has_version "${pkg}[xattr]" ; then
			__ot-kernel_set_acl_one_package
		elif [[ "${pkg}" == "virtual/acl" ]]        && ot-kernel_has_version "${pkg}[linux_kernel]" ; then
			__ot-kernel_set_acl_one_package
		elif ot-kernel_has_version "${pkg}[acl]" ; then
			__ot-kernel_set_acl_one_package
		fi
	done

PKGS=(
# Manually inspect for false-positives.
#
# Generated from:
#
# grep -r -E -l --exclude-dir=.git "sys-apps/acl" $(find /usr/portage -name "*.ebuild")
# grep -r -E -l --exclude-dir=.git "sys-apps/acl" $(find /var/db/repos/ -name "*.ebuild")
app-backup/snapper
app-crypt/tpm2-tss
app-editors/vis
app-misc/clifm
dev-python/pylibacl
gnome-extra/eiciel
kde-misc/krusader
sys-apps/apply-default-acl
)

	# Unconditional enable
	for pkg in ${PKGS[@]} ; do
		if ot-kernel_has_version "${pkg}" ; then
			__ot-kernel_set_acl_one_package
		fi
	done

}

# @FUNCTION: _ot-kernel_checkpoint_dss_acl_requirement
# @DESCRIPTION:
# Check for OS systems level ACL for firewall
_ot-kernel_checkpoint_dss_acl_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
		__ot-kernel_set_acl_one_package
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_lsm_requirement
# @DESCRIPTION:
# Check for LSM (Linux Security Modules) support.
_ot-kernel_checkpoint_dss_lsm_requirement() {
	# See warn_lsm_changes() section in ot-kernel eclass for reason this is diversified.
	if [[ "${work_profile}" == "dss" ]] ; then
		if ot-kernel_has_version "sys-apps/apparmor" ; then
			:
		elif ot-kernel_has_version "sys-apps/smack-utils" ; then
			:
		elif ot-kernel_has_version "sys-apps/tomoyo-tools" ; then
			:
		elif ot-kernel_has_version "sec-policy/selinux-base" ; then
			:
		else
eerror
eerror "You are missing an access control model implementation for the dss work"
eerror "profile.  Install one of the following to silence this error:"
eerror
eerror "  sys-apps/apparmor"
eerror "  sys-apps/smack-utils"
eerror "  sys-apps/tomoyo-tools"
eerror "  sec-policy/selinux-base"
eerror
			die
		fi
		local is_auto=0
		if [[ -z "${OT_KERNEL_LSMS}" ]] ; then
			: # Auto
		elif [[ "${OT_KERNEL_LSMS}" =~ ("auto"|"default"|"apparmor"|"selinux"|"smack"|"tomoyo") ]] ; then
			:
		else
ewarn
ewarn "Your access control model implementation in OT_KERNEL_LSMS for the dss"
ewarn "work profile is weak while the specification hinted strong.  Set"
ewarn "OT_KERNEL_LSMS of the following rows to silence this error:"
ewarn
ewarn "  OT_KERNEL_LSMS=\"auto\""
ewarn "  OT_KERNEL_LSMS=\"default\""
ewarn "  OT_KERNEL_LSMS=\"apparmor\""
ewarn "  OT_KERNEL_LSMS=\"selinux\""
ewarn "  OT_KERNEL_LSMS=\"smack\""
ewarn "  OT_KERNEL_LSMS=\"tomoyo\""
ewarn
		fi
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_disk_encryption_requirement
# @DESCRIPTION:
# Check for disk encryption support.
_ot-kernel_checkpoint_dss_disk_encryption_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
ewarn
ewarn "The passwords for the encrypted partitions or disk must have no"
ewarn "associated connection with accounts being protected."
ewarn
		local found=0
		if [[ "${DSS_DISK_ENCRYPTION}" =~ "ext4-encryption" ]] ; then
			if ver_test "${KV_MAJOR_MINOR}" -eq "4.19" ; then
				:
			else
eerror
eerror "DSS_DISK_ENCRYPTION=\"ext4-encryption\" is only allowed for the"
eerror "4.8 - 4.20, 5.0 series."
eerror
eerror "For the ${KV_MAJOR_MINOR} series, instead use"
eerror
eerror "  DSS_DISK_ENCRYPTION=\"fs-encryption\""
eerror
eerror "or"
eerror
eerror "  DSS_DISK_ENCRYPTION=\"cryptsetup\""
eerror
				die
			fi
einfo "Using ext4-encryption for dss"
			ot-kernel_y_configopt "CONFIG_EXT4_FS"
			ot-kernel_y_configopt "CONFIG_EXT4_ENCRYPTION"
			found=1
		elif grep -q -E -e "^CONFIG_EXT4_ENCRYPTION=y" "${path_config}" ; then
einfo "Using ext4-encryption for dss"
			found=1
		fi
		if [[ "${DSS_DISK_ENCRYPTION}" =~ "fs-encryption" ]] ; then
einfo "Using fs-encryption for dss"
			ot-kernel_y_configopt "CONFIG_EXT4_FS"
			ot-kernel_y_configopt "CONFIG_FS_ENCRYPTION"
			found=1
		elif grep -q -E -e "^CONFIG_FS_ENCRYPTION=y" "${path_config}" ; then
einfo "Using fs-encryption for dss"
			found=1
		fi
		if [[ "${DSS_DISK_ENCRYPTION}" =~ "cryptsetup" ]] ; then
einfo "Using cryptsetup for dss"
			found=1
		elif ot-kernel_has_version "sys-fs/cryptsetup" ; then
einfo "Using cryptsetup for dss"
			found=1
		fi

		if (( ${found} == 0 )) ; then
eerror
eerror "One of the following must be chosen for storage in non database"
eerror "contexts:"
eerror
eerror "CONFIG_EXT4_ENCRYPTION  (For 4.19 only)"
eerror "CONFIG_FS_ENCRYPTION    (For Ext4, F2FS, UBIFS only)"
eerror "sys-fs/cryptsetup"
eerror
eerror "  or"
eerror
eerror "Set DSS_DISK_ENCRYPTION to either ext4-encryption, fs-encryption, cryptsetup."
eerror
			die
		fi
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_multiuser_requirement
# @DESCRIPTION:
# Check for limited user support
_ot-kernel_checkpoint_dss_multiuser_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
einfo "Enabling multiuser / multigroup support for the dss work profile"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_ntp_requirement
# @DESCRIPTION:
# Check for secure ntp support.
_ot-kernel_checkpoint_dss_ntp_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
		if ot-kernel_has_version "net-misc/chrony" ; then
			:
		elif ot-kernel_has_version "net-misc/ntpsec" ; then
			:
		else
# Listed only only secured or reviewed versions
eerror
eerror "A secure ntp implementation with proper security USE flags connected to"
eerror "a secured ntp server is required for the dss work profile."
eerror
eerror "Install one of the following packages to continue:"
eerror
eerror "net-misc/chrony"
eerror "net-misc/ntpsec"
eerror
			die
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_enable_hmacs
# @DESCRIPTION:
# Setup required Keyed Cryptographic Hash Algorithms.
_ot-kernel-pkgflags_dss_enable_hmacs() {
	if [[ "${work_profile}" == "dss" ]] ; then
		local dss_region="${DSS_REGION:-west}"
	# It must be >= 128 Bit
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		_ot-kernel-pkgflags_gcm # GMAC
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_disable_remaining_mac_algs
# @DESCRIPTION:
# Disable all unused Message Authentication Code (MAC) algorithms for the dss work profile.
_ot-kernel-pkgflags_dss_disable_remaining_mac_algs() {
	if [[ "${work_profile}" == "dss" ]] ; then
	# Disable other MACs
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MICHAEL_MIC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_VMAC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_XCBC"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_disable_remaining_hash_algs
# @DESCRIPTION:
# Disable all unused ciphers for the dss work profile.
_ot-kernel-pkgflags_dss_disable_remaining_hash_algs() {
	if [[ "${work_profile}" == "dss" ]] ; then
		local tls="${TLS:-1}"
		local dss_region="${DSS_REGION:-west}"
ewarn
ewarn "Using the dss work profile may mess up the WiFI kernel config.  Use the"
ewarn "OT_KERNEL_KCONFIG override to fix this."
ewarn
	# Disabled alternative hash algorithms

		if [[ "${tls}" == "1" || "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
			:
		else
	# 2001, American (NSA), Hash Function
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_ARM"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_ARM64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_OCTEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_PPC_SPE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_SPARC64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA256_SSSE3"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA2_ARM_CE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA2_ARM64_CE"
		fi

		if [[ "${dss_region}" =~ ("west"|"eu"|"us") ]] ; then
			:
		else
	# 2016, Belgian et.al. Design, An American NIST Standard; Hash Function
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA3"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA3_256_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA3_512_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA3_ARM64"
		fi

		if [[ "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
			:
		else
	# 2001, American (NSA), Hash Function
	# Used in FSCRYPT
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_ARM"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_ARM64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_ARM64_CE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_OCTEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_SPARC64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA512_SSSE3"
		fi

	# 2012, American et.al., Hash Function
		ot-kernel_unset_configopt "CONFIG_CRYPTO_BLAKE2B_NEON"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_BLAKE2B"

	# 1992, German-Belgian, Hash Function
		ot-kernel_unset_configopt "CONFIG_CRYPTO_RMD160"

		if [[ "${dss_region}" =~ "cn" ]] ; then
			:
		else
	# 2010, Chinese, Hash Function
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM3_GENERIC"
		fi

	# Hash function for Adiantum (mode of operation)
		ot-kernel_unset_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_NHPOLY1305"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_NHPOLY1305_NEON"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_NHPOLY1305_AVX2"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_NHPOLY1305_SSE2"

	# Hash function for HCTR2 (mode of operation)
		ot-kernel_unset_configopt "CONFIG_CRYPTO_POLYVAL"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_POLYVAL_CLMUL_NI"

	# 2000-2003, Belgian-Brazilian, Hash Function
		ot-kernel_unset_configopt "CONFIG_CRYPTO_WP512"

		if [[ "${dss_region}" =~ "ru" ]] ; then
			:
		else
	# 2012, Russian (FSB), Hash Function
			ot-kernel_unset_configopt "CONFIG_CRYPTO_STREEBOG"
		fi


	# Disabled weak hashes
	# For hash cryptoanalysis, see
	# https://en.wikipedia.org/wiki/Hash_function_security_summary
	# https://en.wikipedia.org/wiki/Security_level#Meaning_of_%22broken%22

		if [[ "${dss_region}" =~ "jp" ]] ; then
	# It is present for EV root CA
			:
		else
	# 1992, American (NSA), Hash Function
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_ARM"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_ARM_NEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_ARM64_CE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_OCTEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_PPC_SPE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SHA1_SSSE3"
		fi

	# 1992, American, Hash Function
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MD5"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MD5_OCTEON"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MD5_PPC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MD5_SPARC64"

	# 1990, American, Hash Function
		ot-kernel_unset_configopt "CONFIG_CRYPTO_MD4"

	# 2012, Hash Function (non cryptographic)
		ot-kernel_unset_configopt "CONFIG_CRYPTO_XXHASH"

		if [[ "${tls}" == "1" || "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
			:
		else
	# 2013, AEAD ChaCha20-Poly1305
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA20POLY1305"
	# 2008, American, Stream Cipher
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA20"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA20POLY1305"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA20_NEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA_MIPS"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CHACHA_S390"
	# 2005, American, MAC
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305_ARM"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305_NEON"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305_MIPS"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305_P10"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_POLY1305_X86_64"
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_disable_remaining_block_ciphers
# @DESCRIPTION:
# Disable all unused ciphers for the dss work profile.
_ot-kernel-pkgflags_dss_disable_remaining_block_ciphers() {
	if [[ "${work_profile}" == "dss" ]] ; then
		local tls="${TLS:-1}"
		local dss_region="${DSS_REGION:-west}"
einfo "DSS_REGION:  ${dss_region}"
ewarn
ewarn "Using the dss work profile may mess up the WiFI kernel config.  Use the"
ewarn "OT_KERNEL_KCONFIG override to fix this."
ewarn
	# Strong ciphers are allowed in the USA.
	# Strong encryption may be banned in other countries.
	# Disable alternative block ciphers

	# 2000, Belgian-Brazilian, 128 Bit Block Cipher, 128-256 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_ANUBIS"

		if [[ "${tls}" == "1" || "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
			:
		else
	# 1998, Belgian, 128 Bit Block Size, 128-256 Bit Keys
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM_BS"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM_CE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM64_CE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM64_CE_BLK"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM64_BS"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM64_NEON_BLK"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_ARM64_CE_CCM"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_NI_INTEL"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_PPC_SPE"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_S390"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_SPARC64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_TI"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_AES_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_PAES_S390"
		fi

		if [[ "${dss_region}" =~ "kr" ]] ; then
			:
		else
	# 2003, South Korean, 128 Bit Block Cipher, 128-256 Bit Keys
			ot-kernel_unset_configopt "CONFIG_CRYPTO_ARIA"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64"
		fi

		if [[ "${dss_region}" =~ "jp" ]] ; then
			:
		else
	# 2000, Japanese, 128 Bit Block Cipher, 128-256 Bit Keys
	# Can be used in TLS 1.2
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA_SPARC64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_CAMELLIA_X86_64"
		fi

	# 1996, Canadian, 64 Bit Block Cipher, 40-128 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CAST5"

	# 1998, Canadian, 128 Bit Block Cipher, 128-256 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CAST6"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CAST6_AVX_X86_64"

	# 2000, Brazilian, 64 Bit Block Cipher, 128 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_KHAZAD"

	# 1998, Korean (KISA), 128 Bit Block Cipher, 128 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SEED"

	# 1998, British-Israeli-Danish, 128 Bit Block Cipher, 128-256 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SERPENT"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SERPENT_AVX2_X86_64"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SERPENT_AVX_X86_64"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SERPENT_SSE2_X86_64"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_SERPENT_SSE2_586"

		if [[ "${dss_region}" =~ "cn" ]] ; then
			:
		else
	# 2006, Chinese, 128 Bit Block Cipher, 128 Bit Keys
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64"
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM4_GENERIC"
		fi

	# [TEA] 1994, British, 64 Bit Block Cipher, 128 Bit Keys
	# [XTEA] 1997, British, 64 Bit Block Cipher, 128 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_TEA"

	# 1998, American, 128 Bit Block Cipher, 128-256 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_TWOFISH"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_TWOFISH_AVX_X86_64"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_TWOFISH_X86_64"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_TWOFISH_X86_64_3WAY"


	# Disabled weak ciphers
	# For cipher cryptoanalysis, see
	# https://en.wikipedia.org/wiki/Cipher_security_summary
	# https://en.wikipedia.org/wiki/Security_level#Meaning_of_%22broken%22

	# 1988, 64 Bit Block Size, 64 Bit Keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_FCRYPT"

	# 1993, American, 64 Bit Block Cipher, 32-448 Bit keys
		ot-kernel_unset_configopt "CONFIG_CRYPTO_BLOWFISH"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_BLOWFISH_X86_64"

	# 1975, American, 64 Bit Block Size, 56 Bit Key Size
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DES"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DES_S390"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DES_SPARC64"

	# 1981, American, 64 Bit Block Size, 112-168 Bit Key Size
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DES3_EDE_X86_64"

		if [[ "${dss_region}" =~ "ru" ]] ; then
			:
		else
			if has_version "sys-kernel/gostcrypt-linux-crypto" ; then
eerror
eerror "sys-kernel/gostcrypt-linux-crypto must be unemerged to continue."
eerror
				die
			fi
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_disable_remaining_ecc_algs
# @DESCRIPTION:
# Disable unused ECC algs
_ot-kernel-pkgflags_dss_disable_remaining_ecc_algs() {
# FIXME:  Disable kernel config options that force crypto ciphers/algorithms.
# Examples: CONFIG_CFG80211_REQUIRE_SIGNED_REGDB forces CONFIG_CRYPTO_RSA.
	if [[ "${work_profile}" == "dss" ]] ; then
		local dss_region="${DSS_REGION:-west}"
		local tls="${TLS:-1}"
		if [[ "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
			:
		else
			if [[ "${tls}" != "1" ]] ; then
	# 1977, American-Israeli, 2048-4096 Key Size
				ot-kernel_unset_configopt "CONFIG_CRYPTO_RSA"

	# 1985-1987 DH over ECC
				ot-kernel_unset_configopt "CONFIG_CRYPTO_ECDH"

	# 1992, 1998-2000 standardized; Canadian
				ot-kernel_unset_configopt "CONFIG_CRYPTO_ECDSA"
			fi
		fi

	# 2016
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DH_RFC7919_GROUPS"	# Never used?

	# 1976 original, American; 1999 RFC2631
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DH"			# Never used?

	# 2005, American
		ot-kernel_unset_configopt "CONFIG_CRYPTO_CURVE25519"		# Never used?

		if [[ "${dss_region}" =~ "cn" ]] ; then
			:
		else
	# 2010, Chinese
			ot-kernel_unset_configopt "CONFIG_CRYPTO_SM2"
		fi
		if [[ "${dss_region}" =~ "ru" ]] ; then
			:
		else
	# 2012, Russian
			ot-kernel_unset_configopt "CONFIG_CRYPTO_ECRDSA"
		fi
	fi
}

# @FUNCTION: _ot-kernel_checkpoint_dss_tls_requirement
# @DESCRIPTION:
# Check for TLS enablement
#
# Both _ot-kernel_tls_support and _ot-kernel_checkpoint_dss_tls_requirement
# look similar but there are differences.
#
# _ot-kernel_tls_support assumes traveler or brick-and-mortar customer context
# so open ended.
# _ot-kernel_checkpoint_dss_tls_requirement assumes the possibilities of
# business or government contractor so restrictive.
#
_ot-kernel_checkpoint_dss_tls_requirement() {
	if [[ "${work_profile}" == "dss" ]] ; then
	# TLS 1.3, See
	# https://en.wikipedia.org/wiki/Transport_Layer_Security#TLS_1.3
	# https://en.wikipedia.org/wiki/Transport_Layer_Security#Cipher
	# https://datatracker.ietf.org/doc/html/rfc8446#section-9.1
	# https://github.com/torvalds/linux/blob/v6.9/net/tls/tls_main.c#L102
		local tls="${TLS:-1}"
		local dss_region="${DSS_REGION:-west}"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		if [[ "${dss_region}" =~ "cn" && "${tls}" == "1" ]] ; then
	# TLS 1.2, TLS 1.3 on a few websites.
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
		elif [[ "${dss_region}" =~ "ru" && "${tls}" == "1" ]] ; then
	# TLS 1.3
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
		elif [[ "${tls}" != "1" ]] ; then
	# CONFIG_TLS adds AES.
			ot-kernel_unset_configopt "CONFIG_TLS"
			ot-kernel_unset_configopt "CONFIG_TLS_DEVICE"
		else
			ot-kernel_y_configopt "CONFIG_TLS"
			ot-kernel_y_configopt "CONFIG_TLS_DEVICE"

	# Optional in spec
	# AEAD stream cipher
	# Stream ciphers have lower latency but lowered security guarantees.
			_ot-kernel-pkgflags_chacha20_poly1305
		fi

	# Authenticated Encryption with Associated Data (AEAD) set with
	# confidentiality and authenticity guarantees.
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_CCM"
		_ot-kernel-pkgflags_gcm

		if [[ "${dss_region}" =~ ("west"|"eu"|"us") ]] ; then
	#
	# Required for TLS.
	# https://datatracker.ietf.org/doc/html/rfc8446#section-9.1
	#
	# We use CBC as a workaround for _ot-kernel-pkgflags_aes to add the
	# accelerated AES cipher because the wrapper is kind of broken.  Most
	# connections observed use GCM.
	#
			_ot-kernel-pkgflags_aes CBC GCM
			_ot-kernel-pkgflags_sha256
			_ot-kernel-pkgflags_sha512		# Includes sha384
		elif [[ "${dss_region}" =~ "cn" ]] ; then
			if [[ "${tls}" == "1" ]] ; then
				_ot-kernel-pkgflags_aes CBC GCM	# Observed for .cn, .hk, .ru, .jp, .com (us)
				_ot-kernel-pkgflags_sha256	# Observed for .cn, .hk, .ru, .com (us)
				_ot-kernel-pkgflags_sha512	# Observed for .cn, .hk, .ru.
			fi
			_ot-kernel-pkgflags_sm4
		elif [[ "${dss_region}" =~ "jp" ]] ; then
			_ot-kernel-pkgflags_aes CBC GCM
			_ot-kernel-pkgflags_sha1		# Observed for .jp, TLS 1.2
			_ot-kernel-pkgflags_sha256
			_ot-kernel-pkgflags_sha512

	# TLS 1.2
			_ot-kernel-pkgflags_camellia
		elif [[ "${dss_region}" =~ "kr" ]] ; then
			_ot-kernel-pkgflags_aes CBC GCM
			_ot-kernel-pkgflags_sha256
			_ot-kernel-pkgflags_sha512

	# TLS 1.2
			_ot-kernel-pkgflags_aria
		elif [[ "${dss_region}" =~ "ru" ]] ; then
			if [[ "${tls}" == "1" ]] ; then
				_ot-kernel-pkgflags_aes CBC GCM
				_ot-kernel-pkgflags_sha256
				_ot-kernel-pkgflags_sha512
			fi

	# TLS 1.2
			_ot-kernel-pkgflags_kuznyechik
		elif [[ "${tls}" == "1" ]] ; then
			_ot-kernel-pkgflags_aes CBC GCM
			_ot-kernel-pkgflags_sha256
			_ot-kernel-pkgflags_sha512
		fi

	# Key Agreement (TLS handshake)
		if [[ "${dss_region}" =~ "cn" && "${tls}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_RSA"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDSA"
			ot-kernel_y_configopt "CONFIG_CRYPTO_SM2"
		elif [[ "${dss_region}" =~ "cn" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_SM2"
		elif [[ "${dss_region}" =~ ("west"|"eu"|"us"|"jp"|"kr") ]] ; then
	# See also
	# https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-8
			ot-kernel_y_configopt "CONFIG_CRYPTO_RSA"         # Observed for .cn, .hk, .jp, .com (us)
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDH"        # Observed for .jp
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDSA"       # Observed for .cn, .hk, .jp, .ru
		elif [[ "${dss_region}" =~ "ru" && "${tls}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_RSA"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECDSA"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECRDSA"
		elif [[ "${dss_region}" =~ "ru" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_ECRDSA"
		fi
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_dss_disable_hw_crypto
# @DESCRIPTION:
# Disable hardware crypto devices.
# Note:  This may change to enable/select crypto devices.
_ot-kernel-pkgflags_dss_disable_hw_crypto() {
	if [[ "${work_profile}" == "dss" ]] ; then
	# The software implementation is preferred for review.
	# This can be improved later with better environment variable selection.
ewarn
ewarn "All hardware crypto devices will be disabled in the dss work profile as a precaution."
ewarn "Use the OT_KERNEL_KCONFIG override to re-enable them."
ewarn
ewarn "See _ot-kernel-pkgflags_dss_disable_hw_crypto in ot-kernel-pkgflags.eclass for details."
ewarn
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_AMLOGIC_GXL"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_ATMEL_ECC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_ATMEL_SHA204A"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_CCP"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_CCREE"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_NITROX_CNN55XX"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_PADLOCK"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_4XXX"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_C3XXX"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_C3XXXVF"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_C62X"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_C62XVF"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_DH895xCC"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_QAT_DH895xCCVF"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_DEV_SAFEXCEL"
		ot-kernel_unset_configopt "CONFIG_CRYPTO_HW"
	fi
}

# @FUNCTION: _ot-kernel_set_shebang_support
# @DESCRIPTION:
# It always applies shebang support.
_ot-kernel_set_shebang_support() { # DONE
	local pkgs=(
	# List actively used for now
		app-shells/bash
		app-shells/dash
		app-shells/pwsh-bin
		dev-lang/perl
		dev-lang/python
		dev-lang/ruby
		sys-apps/busybox
	)
	local shebang="${SHEBANG:-auto}"
	if [[ "${shebang}" == "custom" ]] ; then
einfo "#! shebang support:  Determined by kernel .config file."
	elif [[ "${shebang}" == "1" ]] ; then
einfo "#! shebang support:  ON"
		ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! support
	elif [[ "${shebang}" == "auto" ]] ; then
		local pkg
		ot-kernel_unset_configopt "CONFIG_BINFMT_SCRIPT"
		for pkg in ${pkgs[@]} ; do
			if ot-kernel_has_version_pkgflags "${pkg}" ; then
				ot-kernel_y_configopt "CONFIG_BINFMT_SCRIPT" # For #! support
				break
			fi
		done
		if grep -q -E -e "^CONFIG_BINFMT_SCRIPT=y" "${path_config}" ; then
einfo "#! shebang support:  ON for ${pkg}"
		else
einfo "#! shebang support:  OFF"
		fi
	else
einfo "#! shebang support:  OFF"
		ot-kernel_unset_configopt "CONFIG_BINFMT_SCRIPT"
	fi
}


# @FUNCTION: _ot-kernel_set_seccomp_bpf
# @DESCRIPTION:
# Enable Seccomp BPF
_ot-kernel_set_seccomp_bpf() { # DONE
	local pkg="${1}"
	# The userland program will have SECCOMP_MODE_FILTER symbol..
	ot-kernel_y_configopt "CONFIG_NET" # Enables BPF implicitly
	ot-kernel_y_configopt "CONFIG_SECCOMP"
	ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
	warn_lowered_security "${pkg}" "BPF, Spectre Variant 2, Spectre Variant 4" "ID"
}

# @FUNCTION: _ot-kernel_set_bpf
# @DESCRIPTION:
# Enable BPF
_ot-kernel_set_bpf() { # DONE
	local pkg="${1}"
	# The userland program must have bpf(), linux/bpf.h, BPF_STMT.
	ot-kernel_y_configopt "CONFIG_BPF"
	ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
	warn_lowered_security "${pkg}" "BPF, Spectre Variant 2, Spectre Variant 4" "ID"
}

# @FUNCTION: _ot-kernel_set_so_attach_filter
# @DESCRIPTION:
# Enable BPF implicitly
_ot-kernel_set_so_attach_filter() { # DONE
	local pkg="${1}"
	# Enabling CONFIG_NET will build socket.o which allows for SO_ATTACH_FILTER.
	# The userland program must have SO_ATTACH_FILTER.
	ot-kernel_y_configopt "CONFIG_NET"
	warn_lowered_security "${pkg}" "BPF, Spectre Variant 2, Spectre Variant 4" "ID"
}

# @FUNCTION: _ot-kernel_set_ia32_support
# @DESCRIPTION:
# Enable 32-bit implicitly.
# Disables 32-bit for security-critical profiles.
_ot-kernel_set_ia32_support() {
	if [[ \
		   "${hardening_level}" == "manual" \
		|| "${hardening_level}" == "custom" \
	]] ; then
		:
	elif [[ \
		   "${hardening_level}" == "secure-af" \
		|| "${hardening_level}" == "secure-as-fuck" \
		|| "${hardening_level}" == "hard-af" \
		|| "${hardening_level}" == "hard-as-fuck" \
		|| "${hardening_level}" == "epic-boss" \
	]] ; then
	        ot-kernel_unset_configopt "CONFIG_IA32_EMULATION"
	elif [[ "${work_profile}" == "dss" ]] ; then
	        ot-kernel_unset_configopt "CONFIG_IA32_EMULATION"
	else
	        ot-kernel_y_configopt "CONFIG_IA32_EMULATION"
	fi
}

# @FUNCTION: _ot-kernel_set_drm_fbdev_emulation
# @DESCRIPTION:
# Proper "Enable legacy fbdev support for your modesetting driver" setup
_ot-kernel_set_drm_fbdev_emulation() {
	if [[ "${work_profile}" =~ ("vm-host"|"vm-guest") ]] ; then
		ot-kernel_unset_configopt "CONFIG_DRM_FBDEV_EMULATION"
	else
		ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
	fi
}

# CONFIG_ADVISE_SYSCALLS search keywords:  madvise, fadvise

# Transparent Huge Pages notes:
#   Anything commented out is capable of using THP, but
#   disabled if there is no reason to enable it.
#   It is assumed that enabling will cause a performance
#   regression or no benefit.

#
# CONFIG_POSIX_TIMERS search keywords:
# timer_create
# timer_gettime
# __NR_alarm
#

# CONFIG_DNOTIFY search keywords:
# F_NOTIFY

# Scan source code with
# grep -E -r  -e \
# "(__NR_|BPF_STMT|SYS_(alarm|madvise|futex|membarrier|epoll|signalfd|timerfd\
# |fadvise|sgetmask|ssetmask|eventfd)|/dev/shm|io_setup|io_uring|inotify_init\
# |MADV_HUGEPAGE|DN_(ACCESS|MODIFY|CREATE|DELETE|RENAME|ATTRIB)\
# |open_by_handle_at|name_to_handle_at|sys_sysfs|timer_create|timer_gettime\
# |timer_settime|clock_adjtime|io_setup|clock_nanosleep|bpf_jit|msgget|msgsnd\
# |msgrcv|semget|shmget|shmat|shmdt|modify_ldt|F_NOTIFY|fanotify_init\
# |inotify_init|seccomp_init)" \
# "${S}"

# Manual inspection still required
