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
# rebuild can cost 4-7 hours on older machines.  Extra required flags
# should manually edit the .config instead of modifying this eclass.

# This eclass is biased towards built in (=y) instead of modules (=m) for security reasons.

inherit ot-kernel-kutils

# These are discovered by doing one of the following:
# 1: grep --exclude-dir=.git --exclude-dir=distfiles -r -e "CONFIG_CHECK=" ./
# 2: grep --exclude-dir=.git --exclude-dir=distfiles -r -e "linux_chkconfig_" ./

X86_FLAGS=(aes avx avx2 avx512vl sha sse2 ssse3)
IUSE+=" ${X86_FLAGS[@]/#/cpu_flags_x86_}"

# @FUNCTION: warn_lowered_security
# @DESCRIPTION:
# Shows a warning or halts if security is lowered.
warn_lowered_security() {
	local pkgid="${1}"
	if [[ "${OT_KERNEL_HALT_ON_LOWERED_SECURITY}" == "1" ]] ; then
eerror "Lowered security was detected for id = ${pkgid}."
eerror "To permit security lowering set OT_KERNEL_HALT_ON_LOWERED_SECURITY=0."
eerror "Search the id ot-kernel-pkgflags.eclass in the eclass folder for details."
		die
	else
ewarn "Security is lowered for id = ${pkgid}."
ewarn "To halt on lowered security, set OT_KERNEL_HALT_ON_LOWERED_SECURITY=1."
ewarn "Search the id in ot-kernel-pkgflags.eclass in the eclass folder for details."
	fi
}

# @FUNCTION: ban_disable_debug
# @DESCRIPTION:
# Makes disable_debug mutually exclusive with kernel pkgflags
#
# Any function that uses the following keywords (DEBUG, TRACE, VERBOSE, LOG,
# PRINT) in kernel flags should be checked in addition to netfilter log
# depending on if disable_debug is set to PERMIT_NETFILTER_SYMBOL_REMOVAL=1.
#
# Currently OT_KERNEL_PKGFLAGS_ACCEPT is used to override
# PERMIT_NETFILTER_SYMBOL_REMOVAL and to prevent more code creep.
#
ban_disable_debug() {
	local pkgid="${1}"
	local types="${2}" # can be unset or NETFILTER

# pkgid is produced from the following:
# echo -n "${CATEGORY}/${PN}" | sha512sum | cut -f 1 -d " " | cut -c 1-7

	if [[ "${OT_KERNEL_FORCE_APPLY_DISABLE_DEBUG}" == "1" ]] ; then
		:
	elif [[ "${OT_KERNEL_PKGFLAGS_ACCEPT}" =~ "${pkgid}" ]] ; then
		:
	elif [[ "${types}" =~ "NETFILTER" ]] \
		&& [[ -z "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" \
			|| "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" == "0" ]] ; then
		: # No feature conflict
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
	ot-kernel-pkgflags_acpi_call
	ot-kernel-pkgflags_acpid
	ot-kernel-pkgflags_actkbd
	ot-kernel-pkgflags_apcupsd
	ot-kernel-pkgflags_arcconf
	ot-kernel-pkgflags_audit
	ot-kernel-pkgflags_atop
	ot-kernel-pkgflags_autofs
	ot-kernel-pkgflags_avahi
	ot-kernel-pkgflags_bcc
	ot-kernel-pkgflags_bcm_sta
	ot-kernel-pkgflags_bees
	ot-kernel-pkgflags_blktrace
	ot-kernel-pkgflags_blueman
	ot-kernel-pkgflags_bluez
	ot-kernel-pkgflags_bmon
	ot-kernel-pkgflags_bpftool
	ot-kernel-pkgflags_bpftrace
	ot-kernel-pkgflags_boinc
	ot-kernel-pkgflags_bolt
	ot-kernel-pkgflags_bootchart2
	ot-kernel-pkgflags_btrfs_progs
	ot-kernel-pkgflags_bubblewrap
	ot-kernel-pkgflags_caja_dbox
	ot-kernel-pkgflags_catalyst
	ot-kernel-pkgflags_cifs_utils
	ot-kernel-pkgflags_chroot_wrapper
	ot-kernel-pkgflags_clamav
	ot-kernel-pkgflags_clamfs
	ot-kernel-pkgflags_clsync
	ot-kernel-pkgflags_cni_plugins
	ot-kernel-pkgflags_conky
	ot-kernel-pkgflags_conntrack_tools
	ot-kernel-pkgflags_crda
	ot-kernel-pkgflags_criu
	ot-kernel-pkgflags_cryfs
	ot-kernel-pkgflags_cryptodev
	ot-kernel-pkgflags_cryptmount
	ot-kernel-pkgflags_cryptsetup
	ot-kernel-pkgflags_cups
	ot-kernel-pkgflags_db_numa
	ot-kernel-pkgflags_dbus
	ot-kernel-pkgflags_dccutil
	ot-kernel-pkgflags_discord
	ot-kernel-pkgflags_distrobuilder
	ot-kernel-pkgflags_docker
	ot-kernel-pkgflags_dracut
	ot-kernel-pkgflags_dropwatch
	ot-kernel-pkgflags_ecryptfs
	ot-kernel-pkgflags_ell
	ot-kernel-pkgflags_elogind
	ot-kernel-pkgflags_embree
	ot-kernel-pkgflags_encfs
	ot-kernel-pkgflags_epcam
	ot-kernel-pkgflags_epoch
	ot-kernel-pkgflags_espeakup
	ot-kernel-pkgflags_eudev
	ot-kernel-pkgflags_eventd
	ot-kernel-pkgflags_extfatprogs
	ot-kernel-pkgflags_ff
	ot-kernel-pkgflags_firecracker_bin
	ot-kernel-pkgflags_firehol
	ot-kernel-pkgflags_firewalld
	ot-kernel-pkgflags_flatpak
	ot-kernel-pkgflags_firejail
	ot-kernel-pkgflags_fuse
	ot-kernel-pkgflags_fwknop
	ot-kernel-pkgflags_glances
	ot-kernel-pkgflags_glib
	ot-kernel-pkgflags_gnome_boxes
	ot-kernel-pkgflags_gpm
	ot-kernel-pkgflags_guestfs
	ot-kernel-pkgflags_hamachi
	ot-kernel-pkgflags_haproxy
	ot-kernel-pkgflags_hd_idle
	ot-kernel-pkgflags_hdapsd
	ot-kernel-pkgflags_hplip
	ot-kernel-pkgflags_htop
	ot-kernel-pkgflags_i8kutils
	ot-kernel-pkgflags_iwlmvm
	ot-kernel-pkgflags_incron
	ot-kernel-pkgflags_iodine
	ot-kernel-pkgflags_iotop
	ot-kernel-pkgflags_ipcm
	ot-kernel-pkgflags_ipset
	ot-kernel-pkgflags_iptables
	ot-kernel-pkgflags_irqbalance
	ot-kernel-pkgflags_isatapd
	ot-kernel-pkgflags_iwd
	ot-kernel-pkgflags_kexec_tools
	ot-kernel-pkgflags_keyutils
	ot-kernel-pkgflags_kio_fuse
	ot-kernel-pkgflags_kodi
	ot-kernel-pkgflags_kpatch
	ot-kernel-pkgflags_ksmbd_tools
	ot-kernel-pkgflags_latencytop
	ot-kernel-pkgflags_libcec
	ot-kernel-pkgflags_libcgroup
	ot-kernel-pkgflags_libnetfilter_conntrack
	ot-kernel-pkgflags_libnetfilter_cttimeout
	ot-kernel-pkgflags_libnetfilter_log
	ot-kernel-pkgflags_libnetfilter_queue
	ot-kernel-pkgflags_libnfnetlink
	ot-kernel-pkgflags_libsdl2
	ot-kernel-pkgflags_libteam
	ot-kernel-pkgflags_libugpio
	ot-kernel-pkgflags_libv4l
	ot-kernel-pkgflags_libvirt
	ot-kernel-pkgflags_likwid
	ot-kernel-pkgflags_linux_smaps
	ot-kernel-pkgflags_lirc
	ot-kernel-pkgflags_lmsensors
	ot-kernel-pkgflags_loopaes
	ot-kernel-pkgflags_lttng_modules
	ot-kernel-pkgflags_lvm2
	ot-kernel-pkgflags_lxc
	ot-kernel-pkgflags_lxd
	ot-kernel-pkgflags_madwimax
	ot-kernel-pkgflags_mdadm
	ot-kernel-pkgflags_mesa
	ot-kernel-pkgflags_minijail
	ot-kernel-pkgflags_mono
	ot-kernel-pkgflags_mpm_itk
	ot-kernel-pkgflags_mptcpd
	ot-kernel-pkgflags_multipath_tools
	ot-kernel-pkgflags_msr_tools
	ot-kernel-pkgflags_networkmanager
	ot-kernel-pkgflags_nemu
	ot-kernel-pkgflags_nfs_utils
	ot-kernel-pkgflags_nftables
	ot-kernel-pkgflags_nilfs
	ot-kernel-pkgflags_nstx
	ot-kernel-pkgflags_ntfs3g
	ot-kernel-pkgflags_numad
	ot-kernel-pkgflags_nv
	ot-kernel-pkgflags_open_iscsi
	ot-kernel-pkgflags_open_vm_tools
	ot-kernel-pkgflags_openafs
	ot-kernel-pkgflags_openconnect
	ot-kernel-pkgflags_openfortivpn
	ot-kernel-pkgflags_openssl
	ot-kernel-pkgflags_openvpn
	ot-kernel-pkgflags_oprofile
	ot-kernel-pkgflags_osmo_fl2k
	ot-kernel-pkgflags_pcmciautils
	ot-kernel-pkgflags_perf
	ot-kernel-pkgflags_plocate
	ot-kernel-pkgflags_ply
	ot-kernel-pkgflags_ponyprog
	ot-kernel-pkgflags_portage
	ot-kernel-pkgflags_postgresql
	ot-kernel-pkgflags_powernowd
	ot-kernel-pkgflags_powertop
	ot-kernel-pkgflags_ppp
	ot-kernel-pkgflags_pulseaudio
	ot-kernel-pkgflags_pqiv
	ot-kernel-pkgflags_pv
	ot-kernel-pkgflags_qdmr
	ot-kernel-pkgflags_qemu
	ot-kernel-pkgflags_r8152
	ot-kernel-pkgflags_read_edid
	ot-kernel-pkgflags_roct
	ot-kernel-pkgflags_rr
	ot-kernel-pkgflags_rsyslog
	ot-kernel-pkgflags_rtirq
	ot-kernel-pkgflags_rtkit
	ot-kernel-pkgflags_rtsp_conntrack
	ot-kernel-pkgflags_runc
	ot-kernel-pkgflags_samba
	ot-kernel-pkgflags_sane
	ot-kernel-pkgflags_sanewall
	ot-kernel-pkgflags_simplevirt
	ot-kernel-pkgflags_sshuttle
	ot-kernel-pkgflags_shorewall
	ot-kernel-pkgflags_snapd
	ot-kernel-pkgflags_spacenavd
	ot-kernel-pkgflags_spice_vdagent
	ot-kernel-pkgflags_squid
	ot-kernel-pkgflags_suid_sandbox
	ot-kernel-pkgflags_sssd
	ot-kernel-pkgflags_sstp_client
	ot-kernel-pkgflags_steam
	ot-kernel-pkgflags_stress_ng
	ot-kernel-pkgflags_suricata
	ot-kernel-pkgflags_sysdig_kmod
	ot-kernel-pkgflags_systemd
	ot-kernel-pkgflags_systemd_bootchart
	ot-kernel-pkgflags_systemtap
	ot-kernel-pkgflags_tas
	ot-kernel-pkgflags_tb_us
	ot-kernel-pkgflags_thinkfinger
	ot-kernel-pkgflags_tp_smapi
	ot-kernel-pkgflags_tpb
	ot-kernel-pkgflags_tpm2_tss
	ot-kernel-pkgflags_trace_cmd
	ot-kernel-pkgflags_tracker
	ot-kernel-pkgflags_trousers
	ot-kernel-pkgflags_tup
	ot-kernel-pkgflags_tvheadend
	ot-kernel-pkgflags_udev
	ot-kernel-pkgflags_udisks
	ot-kernel-pkgflags_ufw
	ot-kernel-pkgflags_uksmd
	ot-kernel-pkgflags_undervolt
	ot-kernel-pkgflags_usb
	ot-kernel-pkgflags_usb_midi_fw
	ot-kernel-pkgflags_usb_modeswitch
	ot-kernel-pkgflags_usbtop
	ot-kernel-pkgflags_usbview
	ot-kernel-pkgflags_v4l2loopback
	ot-kernel-pkgflags_vbox
	ot-kernel-pkgflags_vendor_reset
	ot-kernel-pkgflags_vhba
	ot-kernel-pkgflags_vinagre
	ot-kernel-pkgflags_vpnc
	ot-kernel-pkgflags_vtun
	ot-kernel-pkgflags_wacom
	ot-kernel-pkgflags_wavemon
	ot-kernel-pkgflags_wine
	ot-kernel-pkgflags_wireguard_modules
	ot-kernel-pkgflags_wireguard_tools
	ot-kernel-pkgflags_wpa_supplicant
	ot-kernel-pkgflags_xboxdrv
	ot-kernel-pkgflags_xe_guest_utilities
	ot-kernel-pkgflags_xen
	ot-kernel-pkgflags_xf86_input_evdev
	ot-kernel-pkgflags_xf86_input_libinput
	ot-kernel-pkgflags_xf86_input_synaptics
	ot-kernel-pkgflags_xf86_video_ati
	ot-kernel-pkgflags_xf86_video_intel
	ot-kernel-pkgflags_xf86_video_vesa
	ot-kernel-pkgflags_x86info
	ot-kernel-pkgflags_xfce4_battery_plugin
	ot-kernel-pkgflags_xoscope
	ot-kernel-pkgflags_xpadneo
	ot-kernel-pkgflags_xpra
	ot-kernel-pkgflags_xtables_addons
	ot-kernel-pkgflags_zfs
	ot-kernel-pkgflags_zfs_kmod
}

# @FUNCTION: ot-kernel-pkgflags_acpi_call
# @DESCRIPTION:
# Applies kernel config flags for the acpi_call
ot-kernel-pkgflags_acpi_call() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2d5c2ed" ]] && return
	if has_version "sys-power/acpi_call" ; then
		einfo "Applying kernel config flags for acpi_call (id: 2d5c2ed)"
		ot-kernel_y_configopt "CONFIG_ACPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_acpid
# @DESCRIPTION:
# Applies kernel config flags for the acpid
ot-kernel-pkgflags_acpid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "316efa6" ]] && return
	if has_version "sys-power/acpid" ; then
		einfo "Applying kernel config flags for acpid (id: 316efa6)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
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

# @FUNCTION: ot-kernel-pkgflags_apcupsd
# @DESCRIPTION:
# Applies kernel config flags for the apcupsd
ot-kernel-pkgflags_apcupsd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "491c232" ]] && return
	if has_version "sys-power/apcupsd[usb]" ; then
		einfo "Applying kernel config flags for apcupsd (id: 491c232)"
		ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_arcconf
# @DESCRIPTION:
# Applies kernel config flags for the arcconf
ot-kernel-pkgflags_arcconf() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5b48d6a" ]] && return
	if has_version "sys-block/arcconf" ; then
		einfo "Applying kernel config flags for arcconf (id: 5b48d6a)"
		warn_lowered_security "5b48d6a"
		ot-kernel_unset_configopt "CONFIG_HARDENED_USERCOPY_PAGESPAN"
		ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_audit
# @DESCRIPTION:
# Applies kernel config flags for the audit
ot-kernel-pkgflags_audit() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0e477ba" ]] && return
	if has_version "sys-process/audit" ; then
		einfo "Applying kernel config flags for audit (id: 0e477ba)"
		ot-kernel_y_configopt "CONFIG_AUDIT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_atop
# @DESCRIPTION:
# Applies kernel config flags for the atop
ot-kernel-pkgflags_atop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "54e024f" ]] && return
	if has_version "sys-process/atop" ; then
		einfo "Applying kernel config flags for atop (id: 54e024f)"
		ot-kernel_y_configopt "CONFIG_BSD_PROCESS_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_autofs
# @DESCRIPTION:
# Applies kernel config flags for the autofs
ot-kernel-pkgflags_autofs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "49dac9d" ]] && return
	if has_version "net-fs/autofs" ; then
		einfo "Applying kernel config flags for autofs (id: 49dac9d)"
		if ver_test ${K_MAJOR_MINOR} -ge 4.18 ; then
			ot-kernel_y_configopt "CONFIG_AUTOFS_FS"
		else
			ot-kernel_y_configopt "CONFIG_AUTOFS4_FS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_avahi
# @DESCRIPTION:
# Applies kernel config flags for the avahi
ot-kernel-pkgflags_avahi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1ea9c64" ]] && return
	if has_version "net-dns/avahi" ; then
		einfo "Applying kernel config flags for avahi (id: 1ea9c64)"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcc
# @DESCRIPTION:
# Applies kernel config flags for the bcc
ot-kernel-pkgflags_bcc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9e67059" ]] && return
	if has_version "dev-util/bcc" ; then
		einfo "Applying kernel config flags for bcc (id: 9e67059)"
		ot-kernel_y_configopt "CONFIG_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_NET_CLS_BPF"
		ot-kernel_y_configopt "CONFIG_NET_ACT_BPF"
		ot-kernel_y_configopt "CONFIG_HAVE_EBPF_JIT"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
		ban_disable_debug "9e67059"
		ot-kernel_y_configopt "CONFIG_DEBUG_INFO"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
		ot-kernel_y_configopt "CONFIG_KPROBES"
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

# @FUNCTION: ot-kernel-pkgflags_bees
# @DESCRIPTION:
# Applies kernel config flags for the bees
ot-kernel-pkgflags_bees() { # DONE
	# See ot-kernel-pkgflags_btrfs_progs
	:
}

# @FUNCTION: ot-kernel-pkgflags_blktrace
# @DESCRIPTION:
# Applies kernel config flags for the blktrace package
ot-kernel-pkgflags_blktrace() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "029d340" ]] && return
	if has_version "sys-block/blktrace" ; then
		einfo "Applying kernel config flags for the blktrace package (id: 029d340)"
		ban_disable_debug "029d340"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
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

# @FUNCTION: ot-kernel-pkgflags_bmon
# @DESCRIPTION:
# Applies kernel config flags for the bmon package
ot-kernel-pkgflags_bmon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4ac3437" ]] && return
	if has_version "net-analyzer/bmon" ; then
		einfo "Applying kernel config flags for the bmon package (id: 4ac3437)"
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
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

# @FUNCTION: ot-kernel-pkgflags_bpftool
# @DESCRIPTION:
# Applies kernel config flags for the bpftool package
ot-kernel-pkgflags_bpftool() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "17f8f06" ]] && return
	if has_version "dev-util/bpftool" ; then
		einfo "Applying kernel config flags for the bpftool package (id: 17f8f06)"
		ban_disable_debug "17f8f06"
		ot-kernel_y_configopt "CONFIG_DEBUG_INFO_BTF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bpftrace
# @DESCRIPTION:
# Applies kernel config flags for the bpftrace package
ot-kernel-pkgflags_bpftrace() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "aa54616" ]] && return
	if has_version "dev-util/bpftrace" ; then
		einfo "Applying kernel config flags for the bpftrace package (id: aa54616)"
		ot-kernel_y_configopt "CONFIG_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
		ot-kernel_y_configopt "CONFIG_BPF_JIT"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ban_disable_debug "aa54616"
		ot-kernel_y_configopt "CONFIG_FTRACE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_HAVE_EBPF_JIT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_boinc
# @DESCRIPTION:
# Applies kernel config flags for the boinc package
ot-kernel-pkgflags_boinc() { # TESTING
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e9d3694" ]] && return
	if has_version "sci-misc/boinc" ; then
		einfo "Applying kernel config flags for the boinc package (id: e9d3694)"
		if grep -q -E -e "^CONFIG_LEGACY_VSYSCALL_NONE=y" "${path_config}" ; then
			VSYSCALL_MODE="${VSYSCALL_MODE:-emulate}" # kernel default
			if [[ "${VSYSCALL_MODE}" == "full" ]] ; then
				# Full emulation is recommended by ebuild
				ewarn "Re-assigning vsyscall table:  none -> full emulation"
				warn_lowered_security "e9d3694"
				ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_EMULATE" # no mitigation
			elif [[ "${VSYSCALL_MODE}" == "emulate" ]] ; then
				ewarn "Re-assigning vsyscall table:  none -> emulate execution only"
				ot-kernel_y_configopt "CONFIG_LEGACY_VSYSCALL_XONLY" # more mitigation, but no reads
			else
				eerror "vsyscall table mode none is not supported"
				die
			fi
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

# @FUNCTION: ot-kernel-pkgflags_bootchart2
# @DESCRIPTION:
# Applies kernel config flags for the bootchart2 package
ot-kernel-pkgflags_bootchart2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c913230" ]] && return
	if has_version "app-benchmarks/bootchart2" ; then
		einfo "Applying kernel config flags for the bootchart2 package (id: c913230)"
		ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_btrfs_progs
# @DESCRIPTION:
# Applies kernel config flags for the btrfs_progs package
ot-kernel-pkgflags_btrfs_progs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "8276066" ]] && return
	if has_version "sys-fs/btrfs-progs" ; then
		einfo "Applying kernel config flags for the btrfs_progs package (id: 8276066)"
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
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

# @FUNCTION: ot-kernel-pkgflags_caja_dbox
# @DESCRIPTION:
# Applies kernel config flags for caja_dbox
ot-kernel-pkgflags_caja_dbox() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "57a6a4b" ]] && return
	if has_version "mate-extra/caja-dropbox" ; then
		einfo "Applying kernel config flags for caja_dbox (id: 57a6a4b)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_catalyst
# @DESCRIPTION:
# Applies kernel config flags for the catalyst package
ot-kernel-pkgflags_catalyst() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "14ce6b4" ]] && return
	if has_version "dev-util/catalyst" ; then
		einfo "Applying kernel config flags for the catalyst package (id: 14ce6b4)"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_ZLIB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cifs_utils
# @DESCRIPTION:
# Applies kernel config flags for the cifs-utils package
ot-kernel-pkgflags_cifs_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f8ae20a" ]] && return
	if has_version "net-fs/cifs-utils" ; then
		einfo "Applying kernel config flags for the cifs-utils package (id: f8ae20a)"
		ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_CIFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_chroot_wrapper
# @DESCRIPTION:
# Applies kernel config flags for the chroot-wrapper package
ot-kernel-pkgflags_chroot_wrapper() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4a45383" ]] && return
	if has_version "dev-util/chroot-wrapper" ; then
		einfo "Applying kernel config flags for the chroot-wrapper package (id: 4a45383)"
		ot-kernel_y_configopt "CONFIG_TMPFS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clamav
# @DESCRIPTION:
# Applies kernel config flags for the clamav package
ot-kernel-pkgflags_clamav() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1545fdb" ]] && return
	if has_version "app-antivirus/clamav" ; then
		einfo "Applying kernel config flags for the clamav package (id: 1545fdb)"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"
		ot-kernel_y_configopt "CONFIG_FANOTIFY_ACCESS_PERMISSIONS"
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

# @FUNCTION: ot-kernel-pkgflags_clsync
# @DESCRIPTION:
# Applies kernel config flags for the clsync package
ot-kernel-pkgflags_clsync() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "cbd5946" ]] && return
	if has_version "app-admin/clsync[clsync]" ; then
		einfo "Applying kernel config flags for the clsync package (id: cbd5946)"
		if has_version "app-admin/clsync[inotify]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
		if has_version "app-admin/clsync[namespaces]" ; then
			ot-kernel_y_configopt "CONFIG_NAMESPACES"
			ot-kernel_y_configopt "CONFIG_UTS_NS"
			ot-kernel_y_configopt "CONFIG_IPC_NS"
			ot-kernel_y_configopt "CONFIG_USER_NS"
			ot-kernel_y_configopt "CONFIG_PID_NS"
			ot-kernel_y_configopt "CONFIG_NET_NS"
		fi
		if has_version "app-admin/clsync[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cni_plugins
# @DESCRIPTION:
# Applies kernel config flags for the cni-plugins package
ot-kernel-pkgflags_cni_plugins() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dec3486" ]] && return
	if has_version "net-misc/cni-plugins" ; then
		einfo "Applying kernel config flags for the cni-plugins package (id: dec3486)"
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
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

# @FUNCTION: ot-kernel-pkgflags_conntrack_tools
# @DESCRIPTION:
# Applies kernel config flags for the conntrack-tools package
ot-kernel-pkgflags_conntrack_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f6a25e5" ]] && return
	if has_version "net-firewall/conntrack-tools" ; then
		einfo "Applying kernel config flags for the conntrack-tools package (id: f6a25e5)"
		if ver_test ${PV} -lt 2.6.20 ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
		fi
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_EVENTS"
		if grep -q -E -e "^CONFIG_INET=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		fi
		if grep -q -E -e "^CONFIG_IPV6=(y|m)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV6"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_crda
# @DESCRIPTION:
# Applies kernel config flags for the crda package
ot-kernel-pkgflags_crda() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2ac64d4" ]] && return
	if has_version "net-wireless/crda" ; then
		has_version "net-wireless/wireless-regdb" || die "Install the wireless-regdb package first"
		einfo "Applying kernel config flags for the crda package (id: 2ac64d4)"
		ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"

		einfo "Auto adding CRDA firmware."
		local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
		firmware=$(echo "${firmware}" | tr " " "\n" | sed -r -e 's|regulatory.db(.p7s)?$||g' | tr "\n" " ") # dedupe
		firmware="${firmware} regulatory.db regulatory.db.p7s"
		firmware=$(echo "${firmware}" \
			| sed -r -e "s|[ ]+| |g" \
				-e "s|^[ ]+||g" \
				-e 's|[ ]+$||g') # Trim mid/left/right spaces
		ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
		local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
		einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_criu
# @DESCRIPTION:
# Applies kernel config flags for the criu package
ot-kernel-pkgflags_criu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "484c86a" ]] && return
	if has_version "sys-process/criu" ; then
		einfo "Applying kernel config flags for the criu package (id: 484c86a)"
		ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_UNIX_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_UDP_DIAG"
		ot-kernel_y_configopt "CONFIG_PACKET_DIAG"
		ot-kernel_y_configopt "CONFIG_NETLINK_DIAG"
		ot-kernel_y_configopt "CONFIG_TUN"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
		if [[ "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_IA32_EMULATION"
		fi
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

# @FUNCTION: ot-kernel-pkgflags_cryptmount
# @DESCRIPTION:
# Applies kernel config flags for the cryptmount package
ot-kernel-pkgflags_cryptmount() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "42b9891" ]] && return
	if has_version "sys-fs/cryptmount" ; then
		einfo "Applying kernel config flags for the cryptmount package (id: 42b9891)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
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
		CRYPTSETUP_TCRYPT="${CRYPTSETUP_TCRYPT:-1}"
		if [[ "${CRYPTSETUP_TCRYPT}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_HASH"
			ot-kernel_y_configopt "CONFIG_CRYPTO_RMD160"
			_ot-kernel-pkgflags_sha512
			ot-kernel_y_configopt "CONFIG_CRYPTO_WP512"
			ot-kernel_y_configopt "CONFIG_CRYPTO_LRW"	# Block mode
			_ot-kernel-pkgflags_serpent
			_ot-kernel-pkgflags_twofish
		fi
		CRYPTSETUP_ADIANTUM="${CRYPTSETUP_ADIANTUM:-1}"
		if [[ "${CRYPTSETUP_ADIANTUM}" == "1" ]] ; then
			_ot-kernel-pkgflags_chacha20
			ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
			_ot-kernel-pkgflags_nhpoly1305
			ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ADIANTUM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cups
# @DESCRIPTION:
# Applies kernel config flags for the cups package
ot-kernel-pkgflags_cups() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dbb3834" ]] && return
	if has_version "net-print/cups[-usb]" ; then
		# Implied has_version "net-print/cups[linux_kernel]"
		einfo "Applying kernel config flags for the cups package (id: dbb3834)"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
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

# @FUNCTION: ot-kernel-pkgflags_dccutil
# @DESCRIPTION:
# Applies kernel config flags for the dccutil package
ot-kernel-pkgflags_dccutil() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6805d71" ]] && return
	if has_version "app-misc/ddcutil" ; then
		einfo "Applying kernel config flags for the dccutil package (id: 6805d71)"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		if has_version "app-misc/ddcutil[usb-monitor]" ; then
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_HID"
			ot-kernel_y_configopt "CONFIG_HIDRAW"
			ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		fi
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

# @FUNCTION: ot-kernel-pkgflags_latencytop
# @DESCRIPTION:
# Applies kernel config flags for the latencytop package
ot-kernel-pkgflags_latencytop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1e47c47" ]] && return
	if has_version "sys-process/latencytop" ; then
		einfo "Applying kernel config flags for the latencytop package (id: 1e47c47)"
		ot-kernel_y_configopt "CONFIG_LATENCYTOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcec
# @DESCRIPTION:
# Applies kernel config flags for the libcec package
ot-kernel-pkgflags_libcec() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c7a68c0" ]] && return
	if has_version "dev-libs/libcec" ; then
		einfo "Applying kernel config flags for the libcec package (id: c7a68c0)"
		ot-kernel_y_configopt "CONFIG_USB_ACM"
		if has_version "dev-libs/libcec[-udev]" ; then
			ot-kernel_y_configopt "CONFIG_SYSFS"
		fi
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

# @FUNCTION: ot-kernel-pkgflags_ell
# @DESCRIPTION:
# Applies kernel config flags for the ell package
ot-kernel-pkgflags_ell() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "07b5e1f" ]] && return
	if has_version "dev-libs/ell" ; then
		einfo "Applying kernel config flags for the elogind package (id: 07b5e1f)"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API"
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		ot-kernel_y_configopt "CONFIG_CRYPTO_MD5"
		_ot-kernel-pkgflags_sha1
		ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
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

# @FUNCTION: ot-kernel-pkgflags_encfs
# @DESCRIPTION:
# Applies kernel config flags for the encfs package
ot-kernel-pkgflags_encfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "3e70419" ]] && return
	if has_version "sys-fs/encfs" ; then
		einfo "Applying kernel config flags for the encfs package (id: 3e70419)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
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

# @FUNCTION: ot-kernel-pkgflags_extfatprogs
# @DESCRIPTION:
# Applies kernel config flags for the extfatprogs package
ot-kernel-pkgflags_extfatprogs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "93be18b" ]] && return
	if has_version "sys-fs/exfatprogs" ; then
		einfo "Applying kernel config flags for the extfatprogs package (id: 93be18b)"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_EXFAT_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ff
# @DESCRIPTION:
# Applies kernel config flags for the ff package
ot-kernel-pkgflags_ff() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b5b1507" ]] && return
	if has_version "www-client/firefox" \
		|| has_version "www-client/firefox-bin" \
		|| has_version "www-client/torbrowser" ; then
		einfo "Applying kernel config flags for ff and derivatives (id: b5b1507)"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firecracker_bin
# @DESCRIPTION:
# Applies kernel config flags for the firecracker_bin package
ot-kernel-pkgflags_firecracker_bin() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "16d1550" ]] && return
	if has_version "app-emulation/firecracker-bin" ; then
		einfo "Applying kernel config flags for the firecracker_bin package (id: 16d1550)"
		ot-kernel_y_configopt "CONFIG_KVM"
		ot-kernel_y_configopt "CONFIG_TUN"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
		if [[ "${arch}" == "x86_64" ]] ; then
			# Don't use lscpu/cpuinfo autodetect if using distcc or
			# cross-compile but use the config itself to guestimate.
			if grep -q -E -e "(CONFIG_MICROCODE_INTEL=y|CONFIG_INTEL_IOMMU=y)" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_KVM_INTEL"
			fi
			if grep -q -E -e "(CONFIG_MICROCODE_AMD=y|CONFIG_AMD_IOMMU=y)" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_KVM_AMD"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firehol
# @DESCRIPTION:
# Applies kernel config flags for the firehol package
ot-kernel-pkgflags_firehol() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c2c3d67" ]] && return
	if has_version "net-firewall/firehol" ; then
		einfo "Applying kernel config flags for the firehol package (id: c2c3d67)"
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
		ban_disable_debug "6c85b82" "NETFILTER"
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

# @FUNCTION: ot-kernel-pkgflags_fwknop
# @DESCRIPTION:
# Applies kernel config flags for the fwknop package
ot-kernel-pkgflags_fwknop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2f507ac" ]] && return
	if has_version "net-firewall/fwknop" ; then
		einfo "Applying kernel config flags for the fwknop package (id: 2f507ac)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		if has_version "net-firewall/fwknop[nfqueue]" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glances
# @DESCRIPTION:
# Applies kernel config flags for the glances package
ot-kernel-pkgflags_glances() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "71ea7b8" ]] && return
	if has_version "sys-process/glances" ; then
		einfo "Applying kernel config flags for the glances package (id: 71ea7b8)"
		ot-kernel_y_configopt "CONFIG_TASK_IO_ACCOUNTING"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
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

# @FUNCTION: ot-kernel-pkgflags_gnome_boxes
# @DESCRIPTION:
# Applies kernel config flags for the gnome-boxes package
ot-kernel-pkgflags_gnome_boxes() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "768ed31" ]] && return
	if has_version "gnome-extra/gnome-boxes" ; then
		einfo "Applying kernel config flags for the gnome-boxes package (id: 768ed31)"
		# Use .config hints to guestimate
		if grep -q -E -e "(CONFIG_MICROCODE_INTEL=y|CONFIG_INTEL_IOMMU=y)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KVM_INTEL"
		fi
		if grep -q -E -e "(CONFIG_MICROCODE_AMD=y|CONFIG_AMD_IOMMU=y)" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KVM_AMD"
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

# @FUNCTION: ot-kernel-pkgflags_hamachi
# @DESCRIPTION:
# Applies kernel config flags for hamachi
ot-kernel-pkgflags_hamachi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "d871dfa" ]] && return
	if has_version "net-vpn/logmein-hamachi" ; then
		einfo "Applying kernel config flags for the hamachi package (id: d871dfa)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_haproxy
# @DESCRIPTION:
# Applies kernel config flags for haproxy
ot-kernel-pkgflags_haproxy() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5bc6d06" ]] && return
	if has_version "net-proxy/haproxy" ; then
		einfo "Applying kernel config flags for the haproxy package (id: 5bc6d06)"
		ot-kernel_y_configopt "CONFIG_NET_NS"
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

# @FUNCTION: ot-kernel-pkgflags_hdapsd
# @DESCRIPTION:
# Applies kernel config flags for the hdapsd package
ot-kernel-pkgflags_hdapsd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2458b68" ]] && return
	if has_version "app-laptop/hdapsd" ; then
		einfo "Applying kernel config flags for the hdapsd package (id: 2458b68)"
		ot-kernel_y_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_htop
# @DESCRIPTION:
# Applies kernel config flags for the htop package
ot-kernel-pkgflags_htop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "843cb8b" ]] && return
	if has_version "sys-process/htop" ; then
		einfo "Applying kernel config flags for the htop package (id: 843cb8b)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "45f5321" ]] && return
	if has_version "net-print/hplip" ; then
		einfo "Applying kernel config flags for the hplip package (id: 45f5321)"
		HPLIP_USB="${HPLIP_USB:-1}"
		if [[ "${HPLIP_USB}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_USB"
			ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
			ot-kernel_y_configopt "CONFIG_USB_PRINTER"
		fi
		HPLIP_PARPORT="${HPLIP_PARPORT:-1}"
		if [[ "${HPLIP_PARPORT}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_PARPORT"
			ot-kernel_y_configopt "CONFIG_PPDEV"
			ot-kernel_y_configopt "CONFIG_PARPORT_1284"
		fi
		if ! has_version "net-print/cups[zeroconf]" ; then
			# See ot-kernel-pkgflags_avahi
ewarn "Re-emerge net-print/cups[zerconf] and ${PN} for network printing."
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_i8kutils
# @DESCRIPTION:
# Applies kernel config flags for the i8kutils package
ot-kernel-pkgflags_i8kutils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ab2316b" ]] && return
	if has_version "app-laptop/i8kutils" ; then
		einfo "Applying kernel config flags for the i8kutils package (id: ab2316b)"
		ot-kernel_y_configopt "CONFIG_I8K"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwlmvm
# @DESCRIPTION:
# Applies kernel config flags for the iwlmvm package
ot-kernel-pkgflags_iwlmvm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c947ca0" ]] && return
	if \
		has_version "sys-firmware/iwl3160-7260-bt-ucode" \
		|| has_version "sys-firmware/iwl7260-ucode" \
		|| has_version "sys-firmware/iwl8000-ucode" \
		|| has_version "sys-firmware/iwl3160-ucode" \
	; then
		einfo "Applying kernel config flags for the iwl firmware package(s) (id: c947ca0)"
		ot-kernel_y_configopt "CONFIG_IWLMVM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_incron
# @DESCRIPTION:
# Applies kernel config flags for the incron package
ot-kernel-pkgflags_incron() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2f90fde" ]] && return
	if has_version "sys-process/incron" ; then
		einfo "Applying kernel config flags for the incron package (id: 2f90fde)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iodine
# @DESCRIPTION:
# Applies kernel config flags for the iodine package
ot-kernel-pkgflags_iodine() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "031191b" ]] && return
	if has_version "net-vpn/iodine" ; then
		einfo "Applying kernel config flags for the iodine package (id: 031191b)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipcm
# @DESCRIPTION:
# Applies kernel config flags for ipcm
ot-kernel-pkgflags_ipcm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b50e578" ]] && return
	if has_version "sys-apps/intel-performance-counter-monitor" ; then
		einfo "Applying kernel config flags for the ipcm package (id: b50e578)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipset
# @DESCRIPTION:
# Applies kernel config flags for the ipset package
ot-kernel-pkgflags_ipset() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "45b1cc4" ]] && return
	if has_version "net-firewall/ipset" ; then
		einfo "Applying kernel config flags for the ipset package (id: 45b1cc4)"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_unset_configopt "CONFIG_PAX_CONSTIFY_PLUGIN"
		if has_version "net-firewall/ipset[modules]" ; then
			ot-kernel_unset_configopt "CONFIG_IP_NF_SET"
			ot-kernel_unset_configopt "CONFIG_IP_SET"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iptables
# @DESCRIPTION:
# Applies kernel config flags for the iptables package
ot-kernel-pkgflags_iptables() { # MOSTLY DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "351365c" ]] && return
	if has_version "net-firewall/iptables" ; then
		einfo "Applying kernel config flags for the iptables package (id: 351365c)"
		IPTABLES_CLIENT="${IPTABLES_CLIENT:-1}"
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
			ban_disable_debug "351365c" "NETFILTER"
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
		IPTABLES_ROUTER="${IPTABLES_ROUTER:-1}"
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
			ban_disable_debug "351365c" "NETFILTER"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "af7106d" ]] && return
	if has_version "sys-process/iotop" \
		|| has_version "sys-process/iotop-c" ; then
		einfo "Applying kernel config flags for the iotop package (id: af7106d)"
		ot-kernel_y_configopt "CONFIG_TASK_IO_ACCOUNTING"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_VM_EVENT_COUNTERS"
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

# @FUNCTION: ot-kernel-pkgflags_isatapd
# @DESCRIPTION:
# Applies kernel config flags for the isatapd package
ot-kernel-pkgflags_isatapd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "fa75afb" ]] && return
	if has_version "net-vpn/isatapd" ; then
		einfo "Applying kernel config flags for the isatapd package (id: fa75afb)"
		ot-kernel_y_configopt "CONFIG_TUN"
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
			: # See ot-kernel-pkgflags_crda
			has_version "net-wireless/crda" || die "Install net-wireless/crda first"
		fi

		if [[ "${arch}" == "x86_64" ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_DES3_EDE_X86_64"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 4.20 ; then
			# Implied has_version "net-wireless/iwd[linux_kernel]"
			ot-kernel_y_configopt "CONFIG_PKCS8_PRIVATE_KEY_PARSER"
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

# @FUNCTION: ot-kernel-pkgflags_kio_fuse
# @DESCRIPTION:
# Applies kernel config flags for the kio-fuse package
ot-kernel-pkgflags_kio_fuse() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "70d6e85" ]] && return
	if has_version "kde-misc/kio-fuse" ; then
		einfo "Applying kernel config flags for the kio-fuse package (id: 70d6e85)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kodi
# @DESCRIPTION:
# Applies kernel config flags for the kodi package
ot-kernel-pkgflags_kodi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "70fdec1" ]] && return
	if has_version "media-tv/kodi" ; then
		einfo "Applying kernel config flags for the kodi package (id: 70fdec1)"
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
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

# @FUNCTION: ot-kernel-pkgflags_ksmbd_tools
# @DESCRIPTION:
# Applies kernel config flags for the ksmbd-tools package
ot-kernel-pkgflags_ksmbd_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "3dd8506" ]] && return
	if has_version "net-fs/ksmbd-tools" ; then
		einfo "Applying kernel config flags for the ksmbd-tools package (id: 3dd8506)"
		ot-kernel_y_configopt "CONFIG_SMB_SERVER"
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

# @FUNCTION: ot-kernel-pkgflags_libnfnetlink
# @DESCRIPTION:
# Applies kernel config flags for the libnfnetlink package
ot-kernel-pkgflags_libnfnetlink() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "731aa2e" ]] && return
	if has_version "net-libs/libnfnetlink" ; then
		einfo "Applying kernel config flags for the libnfnetlink package (id: 731aa2e)"
		if ver_test ${PV} -lt 2.6.20 ; then
			ot-kernel_y_configopt "CONFIG_IP_NF_CONNTRACK_NETLINK"
		else
			ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK"
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

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_cttimeout
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_cttimeout package
ot-kernel-pkgflags_libnetfilter_cttimeout() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7cab068" ]] && return
	if has_version "net-libs/libnetfilter_cttimeout" ; then
		einfo "Applying kernel config flags for the libnetfilter_cttimeout package (id: 7cab068)"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_TIMEOUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_log
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_log package
ot-kernel-pkgflags_libnetfilter_log() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0359211" ]] && return
	if has_version "net-libs/libnetfilter_log" ; then
		einfo "Applying kernel config flags for the libnetfilter_log package (id: 0359211)"
		ban_disable_debug "0359211" "NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_queue
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_queue package
ot-kernel-pkgflags_libnetfilter_queue() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "cd31a5e" ]] && return
	if has_version "net-libs/libnetfilter_queue" ; then
		einfo "Applying kernel config flags for the libnetfilter_queue package (id: cd31a5e)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
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

# @FUNCTION: ot-kernel-pkgflags_libsdl2
# @DESCRIPTION:
# Applies kernel config flags for the libsdl2 package
ot-kernel-pkgflags_libsdl2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6f67af3" ]] && return
	if has_version "media-libs/libsdl2" \
		|| has_version "dev-games/urho3d" \
		|| has_version "dev-libs/hidapi" ; then
		einfo "Applying kernel config flags for the libsdl2 / hidapi package(s) (id: 6f67af3)"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libteam
# @DESCRIPTION:
# Applies kernel config flags for the libteam package
ot-kernel-pkgflags_libteam() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9bb3f42" ]] && return
	if has_version "net-misc/libteam" ; then
		einfo "Applying kernel config flags for the libteam package (id: 9bb3f42)"
		ot-kernel_y_configopt "CONFIG_NET_TEAM"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_ROUNDROBIN"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_ACTIVEBACKUP"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_BROADCAST"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_RANDOM"
		ot-kernel_y_configopt "CONFIG_NET_TEAM_MODE_LOADBALANCE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libugpio
# @DESCRIPTION:
# Applies kernel config flags for the libugpio package
ot-kernel-pkgflags_libugpio() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dd45062" ]] && return
	if has_version "dev-libs/libugpio" ; then
		einfo "Applying kernel config flags for the libv4l package (id: dd45062)"
		ot-kernel_y_configopt "CONFIG_GPIO_SYSFS"
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

# @FUNCTION: ot-kernel-pkgflags_likwid
# @DESCRIPTION:
# Applies kernel config flags for the likwid package
ot-kernel-pkgflags_likwid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e64272e" ]] && return
	if has_version "sys-apps/likwid" ; then
		einfo "Applying kernel config flags for the likwid package (id: e64272e)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_smaps
# @DESCRIPTION:
# Applies kernel config flags for the Linux-Smaps package
ot-kernel-pkgflags_linux_smaps() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e76e66e" ]] && return
	if has_version "dev-perl/Linux-Smaps" ; then
		einfo "Applying kernel config flags for the Linux-Smaps package (id: e76e66e)"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PROC_PAGE_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lirc
# @DESCRIPTION:
# Applies kernel config flags for the lirc package
ot-kernel-pkgflags_lirc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1f8b392" ]] && return
	if has_version "app-misc/lirc" ; then
		einfo "Applying kernel config flags for the lirc package (id: 1f8b392)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
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

# @FUNCTION: ot-kernel-pkgflags_lttng_modules
# @DESCRIPTION:
# Applies kernel config flags for the lttng-modules package
ot-kernel-pkgflags_lttng_modules() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "18dd1d9" ]] && return
	if has_version "dev-util/lttng-modules" ; then
		einfo "Applying kernel config flags for the lttng-modules package (id: 18dd1d9)"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ban_disable_debug "18dd1d9"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		ot-kernel_y_configopt "CONFIG_EVENT_TRACING"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_KRETPROBES"
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

# @FUNCTION: ot-kernel-pkgflags_lxd
# @DESCRIPTION:
# Applies kernel config flags for the lxd package
ot-kernel-pkgflags_lxd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "cf50245" ]] && return
	if has_version "app-containers/lxd" ; then
		einfo "Applying kernel config flags for the lxd package (id: cf50245)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_IPC_NS"
		ot-kernel_y_configopt "CONFIG_NET_NS"
		ot-kernel_y_configopt "CONFIG_PID_NS"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_USER_NS"
		ot-kernel_y_configopt "CONFIG_UTS_NS"
		ot-kernel_y_configopt "CONFIG_KVM"
		ot-kernel_y_configopt "CONFIG_MACVTAP"
		ot-kernel_y_configopt "CONFIG_VHOST_VSOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_madwimax
# @DESCRIPTION:
# Applies kernel config flags for the madwimax package
ot-kernel-pkgflags_madwimax() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6f56e53" ]] && return
	if has_version "net-wireless/madwimax" ; then
		einfo "Applying kernel config flags for the madwimax package (id: 6f56e53)"
		ot-kernel_unset_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mdadm
# @DESCRIPTION:
# Applies kernel config flags for the mdadm package
ot-kernel-pkgflags_mdadm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2c79f42" ]] && return
	if has_version "sys-fs/mdadm" ; then
		MDADM_RAID="${MDADM_RAID:-1}"
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

# @FUNCTION: ot-kernel-pkgflags_mpm_itk
# @DESCRIPTION:
# Applies kernel config flags for the mpm_itk package
ot-kernel-pkgflags_mpm_itk() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c76089a" ]] && return
	if has_version "www-apache/mpm_itk" ; then
		einfo "Applying kernel config flags for the mpm_itk package (id: c76089a)"
		ot-kernel_y_configopt "CONFIG_MPM_ITK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mptcpd
# @DESCRIPTION:
# Applies kernel config flags for the mptcpd package
ot-kernel-pkgflags_mptcpd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c69e109" ]] && return
	if has_version "net-misc/mptcpd" ; then
		einfo "Applying kernel config flags for the mono package (id: c69e109)"
		ot-kernel_y_configopt "CONFIG_MPTCP"
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

# @FUNCTION: ot-kernel-pkgflags_msr_tools
# @DESCRIPTION:
# Applies kernel config flags for the msr-tools package
ot-kernel-pkgflags_msr_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "222a4a5" ]] && return
	if has_version "sys-apps/msr-tools" ; then
		einfo "Applying kernel config flags for the msr-tools package (id: 222a4a5)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
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

# @FUNCTION: ot-kernel-pkgflags_nemu
# @DESCRIPTION:
# Applies kernel config flags for the nemu package
ot-kernel-pkgflags_nemu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "04da78e" ]] && return
	if has_version "app-emulation/nemu" ; then
		einfo "Applying kernel config flags for the nemu package (id: 04da78e)"
		ot-kernel_y_configopt "CONFIG_VETH"
		ot-kernel_y_configopt "CONFIG_MACVTAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nfs_utils
# @DESCRIPTION:
# Applies kernel config flags for the nfs-utils package
ot-kernel-pkgflags_nfs_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "a06f942" ]] && return
	if has_version "net-fs/nfs-utils" ; then
		einfo "Applying kernel config flags for the nfs-utils package (id: a06f942)"
		if has_version "net-fs/nfs-utils[nfsv4,-nfsdcld]" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_MD5"
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
			if ver_test ${K_MAJOR_MINOR} -gt 4.5 ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "70aa284" ]] && return
	if has_version "net-firewall/nftables" && ver_test ${K_MAJOR_MINOR} -ge 3.13 ; then
		einfo "Applying kernel config flags for the nftables package (id: 70aa284)"
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
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

# @FUNCTION: ot-kernel-pkgflags_nstx
# @DESCRIPTION:
# Applies kernel config flags for the nstx package
ot-kernel-pkgflags_nstx() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5741385" ]] && return
	if has_version "net-vpn/nstx" ; then
		einfo "Applying kernel config flags for the nstx package (id: 5741385)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_numad
# @DESCRIPTION:
# Applies kernel config flags for the numad package
ot-kernel-pkgflags_numad() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4113a11" ]] && return
	if has_version "sys-process/numad" ; then
		einfo "Applying kernel config flags for the numad package (id: 4113a11)"
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
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
		warn_lowered_security "f314ac3"
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

# @FUNCTION: ot-kernel-pkgflags_osmo_fl2k
# @DESCRIPTION:
# Applies kernel config flags for the osmo-fl2k package
ot-kernel-pkgflags_osmo_fl2k() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9830cb3" ]] && return
	if has_version "net-wireless/osmo-fl2k" ; then
		einfo "Applying kernel config flags for the osmo-fl2k package (id: 9830cb3)"
		ot-kernel_y_configopt "CONFIG_CMA"
		ot-kernel_y_configopt "CONFIG_DMA_CMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_iscsi
# @DESCRIPTION:
# Applies kernel config flags for the open-iscsi package
ot-kernel-pkgflags_open_iscsi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "636a064" ]] && return
	if has_version "sys-block/open-iscsi" ; then
		einfo "Applying kernel config flags for the open-iscsi package (id: 636a064)"
		if has_version "sys-block/open-iscsi[tcp]" ; then
			ot-kernel_y_configopt "CONFIG_SCSI_ISCSI_ATTRS"
			ot-kernel_y_configopt "CONFIG_ISCSI_TCP"
		fi
		if has_version "sys-block/open-iscsi[infiniband]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_IPOIB"
			ot-kernel_y_configopt "CONFIG_INIBAND_USER_MAD"
			ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
		fi
		if has_version "sys-block/open-iscsi[rdma]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_ISER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_vm_tools
# @DESCRIPTION:
# Applies kernel config flags for the open-vm-tools package
ot-kernel-pkgflags_open_vm_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1628573" ]] && return
	if has_version "app-emulation/open-vm-tools" ; then
		einfo "Applying kernel config flags for the open-vm-tools package (id: 1628573)"
		ot-kernel_y_configopt "CONFIG_VMWARE_BALLOON"
		ot-kernel_y_configopt "CONFIG_VMWARE_PVSCSI"
		ot-kernel_y_configopt "CONFIG_VMXNET3"
		if has_version "app-emulation/open-vm-tools[X]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_VMWGFX"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 3.9 ; then
			ot-kernel_y_configopt "CONFIG_VMWARE_VMCI"
			ot-kernel_y_configopt "CONFIG_VMWARE_VMCI_VSOCKETS"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 3 ; then
			ot-kernel_y_configopt "CONFIG_FUSE_FS"
		fi
		if ver_test ${K_MAJOR_MINOR} -ge 5.5 ; then
			ot-kernel_y_configopt "CONFIG_X86_IOPL_IOPERM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openafs
# @DESCRIPTION:
# Applies kernel config flags for the openafs
ot-kernel-pkgflags_openafs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dc8ba5a" ]] && return
	if has_version "net-fs/openafs" && ver_test ${K_MAJOR_MINOR} -lt 5.17 ; then
		einfo "Applying kernel config flags for openafs (id: dc8ba5a)"
		if has_version "net-fs/openafs[modules]" ; then
			ot-kernel_unset_configopt "CONFIG_AFS_FS"
		else
			ot-kernel_y_configopt "CONFIG_AFS_FS"
		fi
		ot-kernel_y_configopt "CONFIG_KEYS"
	elif has_version "net-fs/openafs" && ver_test ${K_MAJOR_MINOR} -ge 5.17 ; then
		ewarn "Kernel ${K_MAJOR_MINOR}.x is not supported for autofs"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openconnect
# @DESCRIPTION:
# Applies kernel config flags for the openconnect package
ot-kernel-pkgflags_openconnect() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "98e7109" ]] && return
	if has_version "net-vpn/openconnect" ; then
		einfo "Applying kernel config flags for the openconnect package (id: 98e7109)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openfortivpn
# @DESCRIPTION:
# Applies kernel config flags for the openfortivpn package
ot-kernel-pkgflags_openfortivpn() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "64cf079" ]] && return
	if has_version "net-vpn/openfortivpn" ; then
		einfo "Applying kernel config flags for the openfortivpn package (id: 64cf079)"
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
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

# @FUNCTION: ot-kernel-pkgflags_openvpn
# @DESCRIPTION:
# Applies kernel config flags for the openvpn package
ot-kernel-pkgflags_openvpn() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "d507034" ]] && return
	if has_version "net-vpn/openvpn" ; then
		einfo "Applying kernel config flags for the openvpn package (id: d507034)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qdmr
# @DESCRIPTION:
# Applies kernel config flags for the qdmr package
ot-kernel-pkgflags_qdmr() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f56d1a2" ]] && return
	if has_version "net-wireless/qdmr" ; then
		einfo "Applying kernel config flags for the qdmr package (id: f56d1a2)"
		ot-kernel_y_configopt "CONFIG_USB_ACM"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
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
		QEMU_LINUX_GUEST="${QEMU_LINUX_GUEST:-1}"
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

# @FUNCTION: ot-kernel-pkgflags_plocate
# @DESCRIPTION:
# Applies kernel config flags for the plocate package
ot-kernel-pkgflags_plocate() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "38b20ed" ]] && return
	if has_version "sys-apps/plocate[io-uring]" ; then
		einfo "Applying kernel config flags for the plocate package (id: 38b20ed)"
		ot-kernel_y_configopt "CONFIG_IO_URING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ply
# @DESCRIPTION:
# Applies kernel config flags for the ply package
ot-kernel-pkgflags_ply() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "da5a055" ]] && return
	if has_version "dev-util/ply" ; then
		einfo "Applying kernel config flags for the ply package (id: da5a055)"
		ot-kernel_y_configopt "CONFIG_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_NET_CLS_BPF"
		ot-kernel_y_configopt "CONFIG_NET_ACT_BPF"
		ot-kernel_y_configopt "CONFIG_BPF_JIT"
		ot-kernel_y_configopt "CONFIG_HAVE_BPF_JIT"
		ot-kernel_y_configopt "CONFIG_BPF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ponyprog
# @DESCRIPTION:
# Applies kernel config flags for the ponyprog package
ot-kernel-pkgflags_ponyprog() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dacf3ee" ]] && return
	if has_version "dev-embedded/ponyprog" ; then
		einfo "Applying kernel config flags for the ponyprog package (id: dacf3ee)"
		ot-kernel_y_configopt "CONFIG_SERIO"
		ot-kernel_y_configopt "CONFIG_SERIO_SERPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT_PC"
		ot-kernel_y_configopt "CONFIG_PPDEV"
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
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
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

# @FUNCTION: ot-kernel-pkgflags_pv
# @DESCRIPTION:
# Applies kernel config flags for the pv package
ot-kernel-pkgflags_pv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "af7a9a9" ]] && return
	if has_version "sys-apps/pv" ; then
		einfo "Applying kernel config flags for the pv package (id: af7a9a9)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
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

# @FUNCTION: ot-kernel-pkgflags_ppp
# @DESCRIPTION:
# Applies kernel config flags for the ppp package
ot-kernel-pkgflags_ppp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4f2e9a1" ]] && return
	if has_version "net-dialup/ppp" ; then
		einfo "Applying kernel config flags for the ppp package (id: 4f2e9a1)"
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
		ot-kernel_y_configopt "CONFIG_PPP_SYNC_TTY"
		if has_version "net-dialup/ppp[activefilter]" ; then
			ot-kernel_y_configopt "CONFIG_PPP_FILTER"
		fi
		ot-kernel_y_configopt "CONFIG_PPP_DEFLATE"
		ot-kernel_y_configopt "CONFIG_PPP_BSDCOMP"
		ot-kernel_y_configopt "CONFIG_PPP_MPPE"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_PACKET"
		if has_version "net-dialup/ppp[atm]" ; then
			ot-kernel_y_configopt "CONFIG_PPPOATM"
		fi
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
		ban_disable_debug "87ebe78"
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

# @FUNCTION: ot-kernel-pkgflags_r8152
# @DESCRIPTION:
# Applies kernel config flags for r8152
ot-kernel-pkgflags_r8152() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5e191f3" ]] && return
	if has_version "net-misc/realtek-r8152" ; then
		einfo "Applying kernel config flags for r8152 (id: 5e191f3)"
		ot-kernel_set_configopt "CONFIG_USB_USBNET" "m"
		ot-kernel_set_configopt "CONFIG_USB_NET_CDC_NCM" "m"
		ot-kernel_set_configopt "CONFIG_USB_NET_CDCETHER" "m"
		ot-kernel_y_configopt "CONFIG_MII"
		ot-kernel_unset_configopt "CONFIG_USB_RTL8152"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_read_edid
# @DESCRIPTION:
# Applies kernel config flags for the read-edid package
ot-kernel-pkgflags_read_edid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ec45905" ]] && return
	if has_version "x11-misc/read-edid" ; then
		einfo "Applying kernel config flags for read-edid (id: ec45905)"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
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

# @FUNCTION: ot-kernel-pkgflags_rr
# @DESCRIPTION:
# Applies kernel config flags for rr
ot-kernel-pkgflags_rr() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "889cc93" ]] && return
	if has_version "dev-util/rr" ; then
		einfo "Applying kernel config flags for roct (id: 889cc93)"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rsyslog
# @DESCRIPTION:
# Applies kernel config flags for the rsyslog package
ot-kernel-pkgflags_rsyslog() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "16bb03d" ]] && return
	if has_version "dev-libs/rsyslog" ; then
		einfo "Applying kernel config flags for the rsyslog package (id: 16bb03d)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtirq
# @DESCRIPTION:
# Applies kernel config flags for the rtirq package
ot-kernel-pkgflags_rtirq() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "7a6a27c" ]] && return
	if has_version "sys-process/rtirq" ; then
		einfo "Applying kernel config flags for rtirq (id: 7a6a27c)"
		ot-kernel_y_configopt "CONFIG_PREEMPT_RT" # Chosen because it is easier
		# or
		# ot-kernel_y_configopt "CONFIG_IRQ_FORCED_THREADING" # must have threadirqs in kernel cmdline
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtkit
# @DESCRIPTION:
# Applies kernel config flags for the rtkit package
ot-kernel-pkgflags_rtkit() { # DONE, NEEDS REVIEW
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e07e9e3" ]] && return
	if has_version "sys-auth/rtkit" ; then
		einfo "Applying kernel config flags for rtkit (id: e07e9e3)"
		ot-kernel_unset_configopt "CONFIG_RT_GROUP_SCHED"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtsp_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the rtsp-conntrack package
ot-kernel-pkgflags_rtsp_conntrack() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "682cf36" ]] && return
	if has_version "net-firewall/rtsp-conntrack" ; then
		einfo "Applying kernel config flags for the rtsp-conntrack package (id: 682cf36)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_runc
# @DESCRIPTION:
# Applies kernel config flags for the runc package
ot-kernel-pkgflags_runc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5c1dafb" ]] && return
	if has_version "app-containers/runc" ; then
		einfo "Applying kernel config flags for the runc package (id: 5c1dafb)"
		ot-kernel_y_configopt "CONFIG_USER_NS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_samba
# @DESCRIPTION:
# Applies kernel config flags for the samba package
ot-kernel-pkgflags_samba() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f22efc1" ]] && return
	if has_version "net-fs/samba" ; then
		einfo "Applying kernel config flags for the samba package (id: f22efc1)"
		ot-kernel_y_configopt "CONFIG_NETWORK_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_CIFS"
		ot-kernel_y_configopt "CONFIG_CIFS_STATS2"
		ot-kernel_y_configopt "CONFIG_CIFS_XATTR"
		ot-kernel_y_configopt "CONFIG_CIFS_POSIX"
		if ver_test ${K_MAJOR_MINOR} -le 4.12 ; then
			ot-kernel_y_configopt "CONFIG_CIFS_SMB2"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sane
# @DESCRIPTION:
# Applies kernel config flags for the sane package
ot-kernel-pkgflags_sane() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "949520d" ]] && return
	if has_version "media-gfx/sane-backends" ; then
		einfo "Applying kernel config flags for the sane package (id: 949520d)"
		SANE_SCSI="${SANE_SCSI:-1}"
		if [[ "${SANE_SCSI}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_SCSI"
		fi
		SANE_USB="${SANE_USB:-1}"
		if [[ "${SANE_USB}" == "1" ]] ; then
			# See ot-kernel-pkgflags_usb
			if has_version "media-gfx/sane-backends[-usb]" ; then
ewarn "Re-emerge media-gfx/sane-backends[usb] and ${PN} for USB scanner support."
			fi
			if ver_test ${K_MAJOR_MINOR} -le 3.4 ; then
				ot-kernel_y_configopt "CONFIG_USB_DEVICEFS"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sanewall
# @DESCRIPTION:
# Applies kernel config flags for the sanewall package
ot-kernel-pkgflags_sanewall() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "745f3ee" ]] && return
	if has_version "net-firewall/sanewall" ; then
		einfo "Applying kernel config flags for the sanewall package (id: 745f3ee)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		ot-kernel_y_configopt "CONFIG_NF_NAT"
		ot-kernel_y_configopt "CONFIG_NF_NAT_FTP"
		ot-kernel_y_configopt "CONFIG_NF_NAT_IRC"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_IP_NF_FILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		ban_disable_debug "745f3ee" "NETFILTER"
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

# @FUNCTION: ot-kernel-pkgflags_snapd
# @DESCRIPTION:
# Applies kernel config flags for the snapd package
ot-kernel-pkgflags_snapd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "487fece" ]] && return
	if has_version "app-containers/snapd" ; then
		einfo "Applying kernel config flags for the snapd package (id: 487fece)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_CGROUP_DEVICE"
		ot-kernel_y_configopt "CONFIG_CGROUP_FREEZER"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_ZLIB"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_LZO"
		ot-kernel_y_configopt "CONFIG_SQUASHFS_XZ"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		if has_version "app-containers/snapd[apparmord]" ; then
			ot-kernel_y_configopt "CONFIG_SECURITY_APPARMOR"
		fi
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
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_UNIX"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SYSFS"

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

# @FUNCTION: ot-kernel-pkgflags_ufw
# @DESCRIPTION:
# Applies kernel config flags for the ufw package
ot-kernel-pkgflags_ufw() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "18d6a56" ]] && return
	if has_version "net-firewall/ufw" ; then
		einfo "Applying kernel config flags for the ufw package (id: 18d6a56)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_HL"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_LIMIT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_MULTIPORT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_RECENT"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_STATE"
		if ver_test ${PV} -ge 2.6.39 ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE"
		else
			ot-kernel_y_configopt "CONFIG_IP_NF_MATCH_ADDRTYPE"
		fi
		if ver_test ${PV} -ge 3.4 ; then
			ban_disable_debug "18d6a56" "NETFILTER"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_LOG"
		else
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_LOG"
			if has_version "net-firewall/ufw[ipv6]" ; then
				ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_LOG"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		if has_version "net-firewall/ufw[ipv6]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6b83c24" ]] && return
	if has_version "sys-process/uksmd" ; then
		einfo "Applying kernel config flags for the uksmd package (id: 6b83c24)"
		ot-kernel_y_configopt "CONFIG_KSM"
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

# @FUNCTION: ot-kernel-pkgflags_usb
# @DESCRIPTION:
# Applies kernel config flags for usb
ot-kernel-pkgflags_usb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "33a5d46" ]] && return
	if has_version "virtual/libusb" \
		|| has_version "dev-libs/libusb" ; then
		einfo "Applying kernel config flags for usb support (id: 33a5d46)"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "41122e0" ]] && return
	if has_version "sys-firmware/midisport-firmware" ; then
		einfo "Applying kernel config flags for the usb_modeswitch package (id: 41122e0)"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb_modeswitch
# @DESCRIPTION:
# Applies kernel config flags for the usb_modeswitch package
ot-kernel-pkgflags_usb_modeswitch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1a2ff9d" ]] && return
	if has_version "sys-apps/usb_modeswitch" ; then
		einfo "Applying kernel config flags for the usb_modeswitch package (id: 1a2ff9d)"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbtop
# @DESCRIPTION:
# Applies kernel config flags for the usbtop package
ot-kernel-pkgflags_usbtop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "8091306" ]] && return
	if has_version "sys-process/usbtop" ; then
		einfo "Applying kernel config flags for the usbtop package (id: 8091306)"
		ot-kernel_y_configopt "CONFIG_USB_MON"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbview
# @DESCRIPTION:
# Applies kernel config flags for the usbview package
ot-kernel-pkgflags_usbview() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "3e735de" ]] && return
	if has_version "app-admin/usbview" ; then
		einfo "Applying kernel config flags for the usbview package (id: 3e735de)"
		ban_disable_debug "3e735de"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_simplevirt
# @DESCRIPTION:
# Applies kernel config flags for the simplevirt package
ot-kernel-pkgflags_simplevirt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "9dc3745" ]] && return
	if has_version "app-emulation/simplevirt" ; then
		einfo "Applying kernel config flags for the simplevirt package (id: 9dc3745)"
		ot-kernel_y_configopt "CONFIG_TUN"
		ot-kernel_y_configopt "CONFIG_BRIDGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sshuttle
# @DESCRIPTION:
# Applies kernel config flags for the sshuttle package
ot-kernel-pkgflags_sshuttle() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5f97f7a" ]] && return
	if has_version "net-proxy/sshuttle" ; then
		einfo "Applying kernel config flags for the sshuttle package (id: 5f97f7a)"
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

# @FUNCTION: ot-kernel-pkgflags_sssd
# @DESCRIPTION:
# Applies kernel config flags for the sssd package
ot-kernel-pkgflags_sssd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "17d280b" ]] && return
	if has_version "sys-auth/sssd" ; then
		einfo "Applying kernel config flags for the sssd package (id: 17d280b)"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sstp_client
# @DESCRIPTION:
# Applies kernel config flags for the sstp-client package
ot-kernel-pkgflags_sstp_client() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "17dced4" ]] && return
	if has_version "net-misc/sstp-client" ; then
		einfo "Applying kernel config flags for the sstp-client package (id: 17dced4)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
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
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "3af5aaa" ]] && return
	if has_version "app-benchmarks/stress-ng[apparmor]" ; then
		einfo "Applying kernel config flags for the stress-ng package (id: 3af5aaa)"
		ot-kernel_y_configopt "CONFIG_SECURITY_APPARMOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_suricata
# @DESCRIPTION:
# Applies kernel config flags for the suricata package
ot-kernel-pkgflags_suricata() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "5a1ebf8" ]] && return
	if has_version "net-analyzer/suricata" ; then
		einfo "Applying kernel config flags for the suricata package (id: 5a1ebf8)"
		ot-kernel_y_configopt "CONFIG_XDP_SOCKETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sysdig_kmod
# @DESCRIPTION:
# Applies kernel config flags for the sysdig-kmod package
ot-kernel-pkgflags_sysdig_kmod() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "0e9fdcf" ]] && return
	if has_version "dev-util/sysdig-kmod" ; then
		einfo "Applying kernel config flags for the sysdig-kmod package (id: 0e9fdcf)"
		ban_disable_debug "0e9fdcf"
		ot-kernel_y_configopt "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
		ot-kernel_y_configopt "CONFIG_TRACEPOINTS"
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
		warn_lowered_security "297eb15"
		ot-kernel_unset_configopt "CONFIG_GRKERNSEC_PROC"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"

		if has_version "sys-apps/systemd[acl]" ; then
			ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
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

# @FUNCTION: ot-kernel-pkgflags_systemd_bootchart
# @DESCRIPTION:
# Applies kernel config flags for the systemd-bootchart package
ot-kernel-pkgflags_systemd_bootchart() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "11dfb63" ]] && return
	if has_version "sys-apps/systemd-bootchart" ; then
		einfo "Applying kernel config flags for the systemd-bootchart package (id: 11dfb63)"
		ot-kernel_y_configopt "CONFIG_SCHEDSTATS"
		ban_disable_debug "11dfb63"
		ot-kernel_y_configopt "CONFIG_SCHED_DEBUG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemtap
# @DESCRIPTION:
# Applies kernel config flags for the systemtap package
ot-kernel-pkgflags_systemtap() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "78ae7b9" ]] && return
	if has_version "dev-util/systemtap" ; then
		einfo "Applying kernel config flags for systemtap (id: 78ae7b9)"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_RELAY"
		ban_disable_debug "78ae7b9"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tas
# @DESCRIPTION:
# Applies kernel config flags for the tas package
ot-kernel-pkgflags_tas() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b362784" ]] && return
	if has_version "sys-apps/tas" ; then
		einfo "Applying kernel config flags for tas (id: b362784)"
		ot-kernel_y_configopt "CONFIG_IPMI_DEVICE_INTERFACE"
		ot-kernel_y_configopt "CONFIG_IPMI_HANDLER"
		ot-kernel_y_configopt "CONFIG_IPMI_SI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tb_us
# @DESCRIPTION:
# Applies kernel config flags for the tb_us package
ot-kernel-pkgflags_tb_us() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c800aa5" ]] && return
	if has_version "sys-apps/thunderbolt-software-user-space" ; then
		einfo "Applying kernel config flags for tb-us (id: c800aa5)"
		ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_thinkfinger
# @DESCRIPTION:
# Applies kernel config flags for the thinkfinger package
ot-kernel-pkgflags_thinkfinger() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "f096b24" ]] && return
	if has_version "sys-auth/thinkfinger[pam]" ; then
		einfo "Applying kernel config flags for thinkfinger (id: f096b24)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tp_smapi
# @DESCRIPTION:
# Applies kernel config flags for the tp_smapi package
ot-kernel-pkgflags_tp_smapi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "fb3a3a0" ]] && return
	if has_version "app-laptop/tp_smapi[hdaps]" ; then
		einfo "Applying kernel config flags for tp_smapi (id: fb3a3a0)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_unset_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpb
# @DESCRIPTION:
# Applies kernel config flags for the tpb package
ot-kernel-pkgflags_tpb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1ee9ffd" ]] && return
	if has_version "app-laptop/tpb" ; then
		einfo "Applying kernel config flags for tpb (id: 1ee9ffd)"
		ot-kernel_y_configopt "CONFIG_NVRAM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpm2_tss
# @DESCRIPTION:
# Applies kernel config flags for the tpm2_tss package
ot-kernel-pkgflags_tpm2_tss() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "de73f41" ]] && return
	if has_version "app-crypt/tpm2-tss" ; then
		einfo "Applying kernel config flags for tpm2-tss (id: de73f41)"
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trace_cmd
# @DESCRIPTION:
# Applies kernel config flags for the trace-cmd package
ot-kernel-pkgflags_trace_cmd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bb847a6" ]] && return
	if has_version "dev-util/trace-cmd" ; then
		einfo "Applying kernel config flags for trace-cmd (id: bb847a6)"
		ban_disable_debug "bb847a6"
		ot-kernel_y_configopt "CONFIG_TRACING"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tracker
# @DESCRIPTION:
# Applies kernel config flags for the tracker package
ot-kernel-pkgflags_tracker() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "a6270fb" ]] && return
	if has_version "app-misc/tracker" ; then
		einfo "Applying kernel config flags for tracker (id: a6270fb)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trousers
# @DESCRIPTION:
# Applies kernel config flags for the trousers package
ot-kernel-pkgflags_trousers() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1041159" ]] && return
	if has_version "app-crypt/trousers" ; then
		einfo "Applying kernel config flags for trousers (id: 1041159)"
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tup
# @DESCRIPTION:
# Applies kernel config flags for the tup package
ot-kernel-pkgflags_tup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "4257724" ]] && return
	if has_version "dev-util/tup" ; then
		einfo "Applying kernel config flags for tup (id: 4257724)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tvheadend
# @DESCRIPTION:
# Applies kernel config flags for the tvheadend package
ot-kernel-pkgflags_tvheadend() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2a10779" ]] && return
	if has_version "media-tv/tvheadend" ; then
		einfo "Applying kernel config flags for tvheadhead (id: 2a10779)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
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
		GENTOO_AS_VIRTUALBOX_GUEST="${GENTOO_AS_VIRTUALBOX_GUEST:-1}"
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

# @FUNCTION: ot-kernel-pkgflags_vendor_reset
# @DESCRIPTION:
# Applies kernel config flags for the vendor-reset package
ot-kernel-pkgflags_vendor_reset() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "3bae162" ]] && return
	if has_version "app-emulation/vendor-reset" ; then
		einfo "Applying kernel config flags for the vendor-reset package (id: 3bae162)"
		ban_disable_debug "3bae162"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_PCI_QUIRKS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
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

# @FUNCTION: ot-kernel-pkgflags_vinagre
# @DESCRIPTION:
# Applies kernel config flags for the vinagre package
ot-kernel-pkgflags_vinagre() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2356e75" ]] && return
	if has_version "net-misc/vinagre" ; then
		einfo "Applying kernel config flags for the vinagre package (id: 2356e75)"
		ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vpnc
# @DESCRIPTION:
# Applies kernel config flags for the vpnc package
ot-kernel-pkgflags_vpnc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "ac51429" ]] && return
	if has_version "net-vpn/vpnc" ; then
		einfo "Applying kernel config flags for the vpnc package (id: ac51429)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vtun
# @DESCRIPTION:
# Applies kernel config flags for the vtun package
ot-kernel-pkgflags_vtun() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "205c74a" ]] && return
	if has_version "net-vpn/vtun" ; then
		einfo "Applying kernel config flags for the vtun package (id: 205c74a)"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wacom
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-wacom package
ot-kernel-pkgflags_wacom() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "dc77e36" ]] && return
	if has_version "x11-drivers/xf86-input-wacom" ; then
		einfo "Applying kernel config flags for the xf86-input-wacom package (id: dc77e36)"
		if ver_test ${K_MAJOR_MINOR} -lt 3.17 ; then
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

# @FUNCTION: ot-kernel-pkgflags_wireguard_modules
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-modules package
ot-kernel-pkgflags_wireguard_modules() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "a2dab07" ]] && return
	if has_version "net-vpn/wireguard-modules" ; then
		einfo "Applying kernel config flags for the wireguard-modules package (id: a2dab07)"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_NET_UDP_TUNNEL"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireguard_tools
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-tools package
ot-kernel-pkgflags_wireguard_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "d0dd1be" ]] && return
	if has_version "net-vpn/wireguard-tools[wg-quick]" ; then
		einfo "Applying kernel config flags for the wireguard-tools package (id: d0dd1be)"
		ot-kernel_y_configopt "CONFIG_IP_ADVANCED_ROUTER"
		ot-kernel_y_configopt "CONFIG_IP_MULTIPLE_TABLES"
		ot-kernel_y_configopt "CONFIG_IPV6_MULTIPLE_TABLES"
		if has_version "net-firewall/nftables" ; then
			ot-kernel_y_configopt "CONFIG_NF_TABLES"
			ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV4"
			ot-kernel_y_configopt "CONFIG_NF_TABLES_IPV6"
			ot-kernel_y_configopt "CONFIG_NFT_CT"
			ot-kernel_y_configopt "CONFIG_NFT_FIB"
			ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV4"
			ot-kernel_y_configopt "CONFIG_NFT_FIB_IPV6"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		elif has_version "net-firewall/iptables" ; then
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
	if has_version "net-vpn/wireguard-tools" ; then
		if ver_test ${K_MAJOR_MINOR} -ge 5.6 ; then
			ot-kernel_y_configopt "CONFIG_WIREGUARD"
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
		: # See ot-kernel-pkgflags_crda
		has_version "net-wireless/crda" || die "Install net-wireless/crda first"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xboxdrv
# @DESCRIPTION:
# Applies kernel config flags for the xboxdrv package
ot-kernel-pkgflags_xboxdrv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "e7ec6f5" ]] && return
	if has_version "games-util/xboxdrv" ; then
		einfo "Applying kernel config flags for the xboxdrv package (id: e7ec6f5)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xe_guest_utilities
# @DESCRIPTION:
# Applies kernel config flags for the xe_guest_utilities package
ot-kernel-pkgflags_xe_guest_utilities() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "fec348c" ]] && return
	if has_version "app-emulation/xe-guest-utilities" ; then
		einfo "Applying kernel config flags for the xe-guest-utilities package (id: fec348c)"
		ot-kernel_y_configopt "CONFIG_XEN_COMPAT_XENFS"
		ot-kernel_y_configopt "CONFIG_XENFS"
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
		XEN_PCI_PASSTHROUGH="${XEN_PCI_PASSTHROUGH:-0}" # Default off for security reasons but overridable.
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

# @FUNCTION: ot-kernel-pkgflags_xf86_input_synaptics
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-synaptics package
ot-kernel-pkgflags_xf86_input_synaptics() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c940a05" ]] && return
	if has_version "x11-drivers/xf86-input-synaptics" ; then
		einfo "Applying kernel config flags for the xf86-input-synaptics package (id: c940a05)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
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

# @FUNCTION: ot-kernel-pkgflags_xf86_video_intel
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-intel package
ot-kernel-pkgflags_xf86_video_intel() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "bc32011" ]] && return
	if has_version "x11-drivers/xf86-video-intel" ; then
		einfo "Applying kernel config flags for the xf86-video-intel package (id: bc32011)"
		if ver_test ${K_MAJOR_MINOR} -lt 4.3 ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_KMS"
			ot-kernel_y_configopt "CONFIG_DRM_I915"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_vesa
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-vesa package
ot-kernel-pkgflags_xf86_video_vesa() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "1940044" ]] && return
	if has_version "x11-drivers/xf86-video-vesa" ; then
		einfo "Applying kernel config flags for the xf86-video-vesa package (id: 1940044)"
		ot-kernel_y_configopt "CONFIG_DEVMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_x86info
# @DESCRIPTION:
# Applies kernel config flags for the x86info package
ot-kernel-pkgflags_x86info() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c7f9852" ]] && return
	if has_version "sys-apps/x86info" ; then
		einfo "Applying kernel config flags for the x86info package (id: c7f9852)"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_X86_CPUID"
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

# @FUNCTION: ot-kernel-pkgflags_xoscope
# @DESCRIPTION:
# Applies kernel config flags for the xoscope package
ot-kernel-pkgflags_xoscope() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "6a3c3e1" ]] && return
	if has_version "sci-electronics/xoscope" ; then
		einfo "Applying kernel config flags for the xoscope package (id: 6a3c3e1)"
		ot-kernel_y_configopt "SND_PCM_OSS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpadneo
# @DESCRIPTION:
# Applies kernel config flags for the xpadneo package
ot-kernel-pkgflags_xpadneo() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "b38bb16" ]] && return
	if has_version "games-util/xpadneo" ; then
		einfo "Applying kernel config flags for the xpadneo package (id: b38bb16)"
		ot-kernel_y_configopt "CONFIG_INPUT_FF_MEMLESS"
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

# @FUNCTION: ot-kernel-pkgflags_xtables_addons
# @DESCRIPTION:
# Applies kernel config flags for the xtables-addons package
ot-kernel-pkgflags_xtables_addons() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "2b5f5b4" ]] && return
	if has_version "net-firewall/xtables-addons[modules]" ; then
		einfo "Applying kernel config flags for the xtables-addons package (id: 2b5f5b4)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_MARK"
		ot-kernel_y_configopt "CONFIG_CONNECTOR"
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

# @FUNCTION: ot-kernel-pkgflags_zfs_kmod
# @DESCRIPTION:
# Applies kernel config flags for the zfs-kmod package
ot-kernel-pkgflags_zfs_kmod() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_SKIP}" =~ "c0bec20" ]] && return
	if has_version "sys-fs/zfs-kmod" ; then
		einfo "Applying kernel config flags for the zfs-kmod package (id: c0bec20)"
		ban_disable_debug "c0bec20"
		ot-kernel_unset_configopt "CONFIG_DEBUG_LOCK_ALLOC"
		ot-kernel_y_configopt "CONFIG_EFI_PARTITION"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_unset_configopt "CONFIG_PAX_KERNEXEC_PLUGIN_METHOD_OR"
		ot-kernel_unset_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		ot-kernel_y_configopt "CONFIG_ZLIB_DEFLATE"
		ot-kernel_y_configopt "CONFIG_ZLIB_INFLATE"
		if has_version "sys-fs/zfs-kmod[debug]" ; then
			ot-kernel_y_configopt "CONFIG_FRAME_POINTER"
			ot-kernel_y_configopt "CONFIG_DEBUG_INFO"
			ot-kernel_unset_configopt "CONFIG_DEBUG_INFO_REDUCED"
		fi
		if has_version "sys-fs/zfs-kmod[rootfs]" ; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
			ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		fi
		if ver_test ${K_MAJOR_MINOR} -lt 5 ; then
			ot-kernel_y_configopt "CONFIG_IOSCHED_NOOP"
		fi
	fi
}
