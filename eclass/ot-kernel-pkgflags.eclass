# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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


X86_FLAGS=(
	aes
	avx
	avx2
	avx512vl
	sha
	sse2
	sse4_2
	ssse3
)

ARM_FLAGS=(
	neon
)

IUSE+="
	${X86_FLAGS[@]/#/cpu_flags_x86_}
	${ARM_FLAGS[@]/#/cpu_flags_arm_}
	cpu_flags_ppc_altivec
"

# @FUNCTION: needs_debugfs
# @DESCRIPTION:
# Put warning that debugfs is used as a potential vulnerability dependency.
needs_debugfs() {
	local pkgname="${1}"
	local id="${2}"
ewarn
ewarn "${pkgname} uses debugfs and is a developer only config option.  It"
ewarn "should be disabled to prevent abuse and a possible prerequisite for"
ewarn "attacks."
ewarn
ewarn "To remove this warning disable the relevant USE flag or add ${id}"
ewarn "to OT_KERNEL_PKGFLAGS_REJECT.  In addition, edit the CONFIG_DEBUG_FS"
ewarn "to unset or use the disable_debug USE flag."
ewarn
	export NEED_DEBUGFS=1
}

# @FUNCTION: warn_lowered_security
# @DESCRIPTION:
# Shows a warning or halts if security is lowered.
warn_lowered_security() {
	local pkgid="${1}"
	if [[ "${OT_KERNEL_HALT_ON_LOWERED_SECURITY}" == "1" ]] ; then
eerror
eerror "Lowered security was detected for id = ${pkgid}."
eerror
eerror "To permit security lowering set OT_KERNEL_HALT_ON_LOWERED_SECURITY=0."
eerror "Search the id in the ot-kernel-pkgflags.eclass in the eclass folder for"
eerror "details."
eerror
		die
	else
ewarn
ewarn "Security is lowered for id = ${pkgid}."
eerror
ewarn "To halt on lowered security, set OT_KERNEL_HALT_ON_LOWERED_SECURITY=1."
ewarn "Search the id in the ot-kernel-pkgflags.eclass in the eclass folder for"
ewarn "details."
ewarn
	fi
}

# @FUNCTION: ban_dma_attack
# @DESCRIPTION:
# Warn of the use of kernel options that may used for DMA attacks.
ban_dma_attack() {
	local pkgid="${1}"
	local kopt="${2}"
	local ot_kernel_dma_attack_mitigations=${OT_KERNEL_DMA_ATTACK_MITIGATIONS:-1}
	[[ -n "${ot_kernel_dma_attack_mitigations}" ]] \
		&& (( ${ot_kernel_dma_attack_mitigations} == 0 )) \
		&& return
eerror
eerror "The ${kopt} kernel option may be used as a possible prerequisite for"
eerror "DMA side-channel attacks."
eerror
eerror "Set OT_KERNEL_DMA_ATTACK_MITIGATIONS=0 to continue or"
eerror "set OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1."
eerror
	die
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
	elif [[ "${OT_KERNEL_PKGFLAGS_ACCEPT[S${pkgid}]}" == "1" ]] ; then
		:
	elif [[ "${types}" =~ "NETFILTER" ]] \
		&& [[ -z "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" \
			|| "${PERMIT_NETFILTER_SYMBOL_REMOVAL}" == "0" ]] ; then
		: # No feature conflict
	elif ot-kernel_use disable_debug ; then
eerror
eerror "Using OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS with the disable_debug"
eerror "USE flag are in conflict with a package with certain set of kernel"
eerror "flags."
eerror
eerror "Choices:"
eerror
eerror "1. Disable the disable_debug USE flag."
eerror "2. Add OT_KERNEL_PKGFLAGS_REJECT[S${pkgid}]=1."
eerror "3. Add OT_KERNEL_PKGFLAGS_ACCEPT[S${pkgid}]=1."
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
# The main function to apply all kernel config flags in preparation for using the package.
ot-kernel-pkgflags_apply() {
	[[ "${OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS}" != "1" ]] && return
	[[ "${arch}" =~ "arm" ]] && _ot-kernel-pkgflags_neon

	# Hint below packages whenever possible
	ot-kernel-pkgflags_iucode
	ot-kernel-pkgflags_linux_firmware

	ot-kernel-pkgflags_abseil_cpp
	ot-kernel-pkgflags_accel_ppp
	ot-kernel-pkgflags_acpi_call
	ot-kernel-pkgflags_acpid
	ot-kernel-pkgflags_actkbd
	ot-kernel-pkgflags_alsa
	ot-kernel-pkgflags_amt_check
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
	ot-kernel-pkgflags_bridge_utils
	ot-kernel-pkgflags_btrfs_progs
	ot-kernel-pkgflags_bubblewrap
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
	ot-kernel-pkgflags_conntrack_tools
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
	ot-kernel-pkgflags_discord
	ot-kernel-pkgflags_distrobuilder
	ot-kernel-pkgflags_docker
	ot-kernel-pkgflags_doas
	ot-kernel-pkgflags_dosemu
	ot-kernel-pkgflags_dpdk
	ot-kernel-pkgflags_dracut
	ot-kernel-pkgflags_drbd_utils
	ot-kernel-pkgflags_droidcam
	ot-kernel-pkgflags_dropwatch
	ot-kernel-pkgflags_dvd
	ot-kernel-pkgflags_e2fsprogs
	ot-kernel-pkgflags_ecryptfs
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
	ot-kernel-pkgflags_eventd
	ot-kernel-pkgflags_external_modules
	ot-kernel-pkgflags_f2fs_tools
	ot-kernel-pkgflags_ff
	ot-kernel-pkgflags_ffmpeg
	ot-kernel-pkgflags_firecracker_bin
	ot-kernel-pkgflags_firehol
	ot-kernel-pkgflags_firewalld
	ot-kernel-pkgflags_flatpak
	ot-kernel-pkgflags_firejail
	ot-kernel-pkgflags_fuse
	ot-kernel-pkgflags_fwknop
	ot-kernel-pkgflags_g15daemon
	ot-kernel-pkgflags_gambas
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
	ot-kernel-pkgflags_incron
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
	ot-kernel-pkgflags_knem
	ot-kernel-pkgflags_kodi
	ot-kernel-pkgflags_kpatch
	ot-kernel-pkgflags_ksmbd_tools
	ot-kernel-pkgflags_latencytop
	ot-kernel-pkgflags_libcec
	ot-kernel-pkgflags_libcgroup
	ot-kernel-pkgflags_libcxx
	ot-kernel-pkgflags_libcxxabi
	ot-kernel-pkgflags_libfido2
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
	ot-kernel-pkgflags_libsdl2
	ot-kernel-pkgflags_libteam
	ot-kernel-pkgflags_libu2f_host
	ot-kernel-pkgflags_libugpio
	ot-kernel-pkgflags_libv4l
	ot-kernel-pkgflags_libvirt
	ot-kernel-pkgflags_lightdm
	ot-kernel-pkgflags_likwid
	ot-kernel-pkgflags_linux_atm
	ot-kernel-pkgflags_linux_enable_ir_emitter
	ot-kernel-pkgflags_linux_smaps
	ot-kernel-pkgflags_linuxptp
	ot-kernel-pkgflags_lirc
	ot-kernel-pkgflags_lkrg
	ot-kernel-pkgflags_lksctp_tools
	ot-kernel-pkgflags_llvm
	ot-kernel-pkgflags_lm_sensors
	ot-kernel-pkgflags_lmms
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
	ot-kernel-pkgflags_mariadb
	ot-kernel-pkgflags_mbpfan
	ot-kernel-pkgflags_mcelog
	ot-kernel-pkgflags_mcproxy
	ot-kernel-pkgflags_mdadm
	ot-kernel-pkgflags_mesa
	ot-kernel-pkgflags_mesa_amber
	ot-kernel-pkgflags_midi
	ot-kernel-pkgflags_minidlna
	ot-kernel-pkgflags_minijail
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
	ot-kernel-pkgflags_ntfs3g
	ot-kernel-pkgflags_numad
	ot-kernel-pkgflags_nv
	ot-kernel-pkgflags_nvtop
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
	ot-kernel-pkgflags_openssl
	ot-kernel-pkgflags_openvpn
	ot-kernel-pkgflags_openvswitch
	ot-kernel-pkgflags_oprofile
	ot-kernel-pkgflags_orca
	ot-kernel-pkgflags_osmo_fl2k
	ot-kernel-pkgflags_oss
	ot-kernel-pkgflags_pam_u2f
	ot-kernel-pkgflags_pcmciautils
	ot-kernel-pkgflags_pesign
	ot-kernel-pkgflags_perf
	ot-kernel-pkgflags_perl
	ot-kernel-pkgflags_pglinux
	ot-kernel-pkgflags_php
	ot-kernel-pkgflags_pipewire
	ot-kernel-pkgflags_plocate
	ot-kernel-pkgflags_ply
	ot-kernel-pkgflags_plymouth
	ot-kernel-pkgflags_polkit
	ot-kernel-pkgflags_pommed
	ot-kernel-pkgflags_ponyprog
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
	ot-kernel-pkgflags_read_edid
	ot-kernel-pkgflags_recoil
	ot-kernel-pkgflags_roct
	ot-kernel-pkgflags_rocksdb
	ot-kernel-pkgflags_rr
	ot-kernel-pkgflags_ruby
	ot-kernel-pkgflags_rsyslog
	ot-kernel-pkgflags_rtirq
	ot-kernel-pkgflags_rtkit
	ot-kernel-pkgflags_rtsp_conntrack
	ot-kernel-pkgflags_runc
	ot-kernel-pkgflags_rust
	ot-kernel-pkgflags_samba
	ot-kernel-pkgflags_sandbox
	ot-kernel-pkgflags_sane
	ot-kernel-pkgflags_sanewall
	ot-kernel-pkgflags_sanlock
	ot-kernel-pkgflags_sbsigntools
	ot-kernel-pkgflags_sc_controller
	ot-kernel-pkgflags_sddm
	ot-kernel-pkgflags_shadow
	ot-kernel-pkgflags_simplevirt
	ot-kernel-pkgflags_singularity
	ot-kernel-pkgflags_slim
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
	ot-kernel-pkgflags_steam
	ot-kernel-pkgflags_stress_ng
	ot-kernel-pkgflags_sudo
	ot-kernel-pkgflags_suricata
	ot-kernel-pkgflags_sysdig_kmod
	ot-kernel-pkgflags_systemd
	ot-kernel-pkgflags_systemd_bootchart
	ot-kernel-pkgflags_systemtap
	ot-kernel-pkgflags_tas
	ot-kernel-pkgflags_tb_us
	ot-kernel-pkgflags_tbb
	ot-kernel-pkgflags_tboot
	ot-kernel-pkgflags_thinkfinger
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
	ot-kernel-pkgflags_tuxedo_keyboard
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
	ot-kernel-pkgflags_util_linux
	ot-kernel-pkgflags_v4l_dvb_saa716x
	ot-kernel-pkgflags_v4l2loopback
	ot-kernel-pkgflags_vala
	ot-kernel-pkgflags_vbox
	ot-kernel-pkgflags_vcrypt
	ot-kernel-pkgflags_vendor_reset
	ot-kernel-pkgflags_vhba
	ot-kernel-pkgflags_vim
	ot-kernel-pkgflags_vinagre
	ot-kernel-pkgflags_vlc
	ot-kernel-pkgflags_vpnc
	ot-kernel-pkgflags_vtun
	ot-kernel-pkgflags_wacom
	ot-kernel-pkgflags_watchdog
	ot-kernel-pkgflags_wlgreet
	ot-kernel-pkgflags_wavemon
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
	ot-kernel-pkgflags_xorg_server
	ot-kernel-pkgflags_xoscope
	ot-kernel-pkgflags_xpadneo
	ot-kernel-pkgflags_xpra
	ot-kernel-pkgflags_xtables_addons
	ot-kernel-pkgflags_zfs
	ot-kernel-pkgflags_zfs_kmod
	ot-kernel-pkgflags_zoom

	# Post apply
	# General commonly used kernel features goes here.
	_ot-kernel-pkgflags_squashfs
	_ot-kernel_set_futex
	_ot-kernel_set_futex2
	_ot-kernel_set_ldt
	_ot-kernel_set_multiuser
	_ot-kernel_realtime_packages

	# Out of source modules
}

# @FUNCTION: ot-kernel-pkgflags_abseil_cpp
# @DESCRIPTION:
# Applies kernel config flags for the abseil-cpp package
ot-kernel-pkgflags_abseil_cpp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8476275]}" == "1" ]] && return
	if ot-kernel_has_version "dev-cpp/abseil-cpp" ; then
		einfo "Applying kernel config flags for the abseil-cpp package (id: 8476275)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_accel_ppp
# @DESCRIPTION:
# Applies kernel config flags for the accel-ppp package
ot-kernel-pkgflags_accel_ppp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb80fb54]}" == "1" ]] && return
	if ot-kernel_has_version "net-dialup/accel-ppp" ; then
		einfo "Applying kernel config flags for the accel-ppp package (id: b80fb54)"
		ot-kernel_y_configopt "CONFIG_L2TP"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_PPTP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_acpi_call
# @DESCRIPTION:
# Applies kernel config flags for the acpi_call package
ot-kernel-pkgflags_acpi_call() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2d5c2ed]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/acpi_call" ; then
		einfo "Applying kernel config flags for the acpi_call package (id: 2d5c2ed)"
		ot-kernel_y_configopt "CONFIG_ACPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_acpid
# @DESCRIPTION:
# Applies kernel config flags for the acpid package
ot-kernel-pkgflags_acpid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S316efa6]}" =~ "1" ]] && return
	if ot-kernel_has_version "sys-power/acpid" ; then
		einfo "Applying kernel config flags for the acpid package (id: 316efa6)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_actkbd
# @DESCRIPTION:
# Applies kernel config flags for the actkbd package
ot-kernel-pkgflags_actkbd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1ee4e36]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/actkbd" ; then
		einfo "Applying kernel config flags for the actkbd package (id: 1ee4e36)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_alsa
# @DESCRIPTION:
# Applies kernel config flags for the alsa package
ot-kernel-pkgflags_alsa() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S542ac66]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/alsa-lib" ; then
		einfo "Applying kernel config flags for alsa (id: 542ac66)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S44d0a26]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/mei-amt-check" ; then
		einfo "Applying kernel config flags for the amt-check package (id: 44d0a26)"
		ot-kernel_y_configopt "CONFIG_INTEL_MEI_ME"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apache
# @DESCRIPTION:
# Applies kernel config flags for the apache package
ot-kernel-pkgflags_apache() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb4e8350]}" == "1" ]] && return
	if ot-kernel_has_version "www-servers/apache" ; then
		einfo "Applying kernel config flags for the apache package (id: b4e8350)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apcupsd
# @DESCRIPTION:
# Applies kernel config flags for the apcupsd package
ot-kernel-pkgflags_apcupsd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S491c232]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/apcupsd[usb]" ; then
		einfo "Applying kernel config flags for the apcupsd package (id: 491c232)"
		ot-kernel_y_configopt "CONFIG_USB_HIDDEV"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_appimage
# @DESCRIPTION:
# Applies kernel config flags for appimage packages
ot-kernel-pkgflags_appimage() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9d13cec]}" == "1" ]] && return
	if ot-kernel_has_version "app-arch/AppImageKit" \
		|| ot-kernel_has_version "app-arch/appimaged" \
		|| ot-kernel_has_version "app-arch/go-appimage" ; then
		einfo "Applying kernel config flags for the appimage packages (id: 9d13cec)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"

	fi
	if ot-kernel_has_version "app-arch/go-appimage" ; then
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"
	fi
	if ot-kernel_has_version "app-arch/appimaged[firejail]" \
		|| ot-kernel_has_version "app-arch/go-appimage[firejail]" ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_apptainer
# @DESCRIPTION:
# Applies kernel config flags for the apptainer package
ot-kernel-pkgflags_apptainer() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S183ad96]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/apptainer" ; then
		einfo "Applying kernel config flags for the apptainer package (id: 183ad96)"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_aqtion
# @DESCRIPTION:
# Applies kernel config flags for the aqtion package
ot-kernel-pkgflags_aqtion() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf9ab142]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/AQtion" ; then
		einfo "Applying kernel config flags for the aqtion package (id: f9ab142)"
		ot-kernel_unset_configopt "CONFIG_AQTION"
		ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK"
		ot-kernel_y_configopt "CONFIG_CRC_ITU_T"
		if ot-kernel_has_version "net-misc/AQtion[lro]" ; then
			ot-kernel_unset_configopt "CONFIG_BRIDGE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_arcconf
# @DESCRIPTION:
# Applies kernel config flags for the arcconf package
ot-kernel-pkgflags_arcconf() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5b48d6a]}" == "1" ]] && return
	if ot-kernel_has_version "sys-block/arcconf" ; then
		einfo "Applying kernel config flags for the arcconf package (id: 5b48d6a)"
		warn_lowered_security "5b48d6a"
		ot-kernel_unset_configopt "CONFIG_HARDENED_USERCOPY_PAGESPAN"
		ot-kernel_unset_configopt "CONFIG_LEGACY_VSYSCALL_NONE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_asterisk
# @DESCRIPTION:
# Applies kernel config flags for the asterisk package
ot-kernel-pkgflags_asterisk() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S903f673]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/asterisk" ; then
		einfo "Applying kernel config flags for the asterisk package (id: 903f673)"
		ot-kernel_unset_configopt "CONFIG_NF_CONNTRACK_SIP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_atop
# @DESCRIPTION:
# Applies kernel config flags for the atop package
ot-kernel-pkgflags_atop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S54e024f]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/atop" ; then
		einfo "Applying kernel config flags for the atop package (id: 54e024f)"
		ot-kernel_y_configopt "CONFIG_BSD_PROCESS_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_audacity
# @DESCRIPTION:
# Applies kernel config flags for the audacity package
ot-kernel-pkgflags_audacity() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scef3994]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/audacity" ; then
		einfo "Applying kernel config flags for the audacity package (id: cef3994)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_audit
# @DESCRIPTION:
# Applies kernel config flags for the audit package
ot-kernel-pkgflags_audit() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0e477ba]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/audit" ; then
		einfo "Applying kernel config flags for the audit package (id: 0e477ba)"
		ot-kernel_y_configopt "CONFIG_AUDIT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_autofs
# @DESCRIPTION:
# Applies kernel config flags for the autofs package
ot-kernel-pkgflags_autofs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S49dac9d]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/autofs" ; then
		einfo "Applying kernel config flags for the autofs package (id: 49dac9d)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1ea9c64]}" == "1" ]] && return
	if ot-kernel_has_version "net-dns/avahi" ; then
		einfo "Applying kernel config flags for the avahi package (id: 1ea9c64)"
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_batctl
# @DESCRIPTION:
# Applies kernel config flags for the batctl package
ot-kernel-pkgflags_batctl() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se9cc0fc]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/batctl" ; then
		einfo "Applying kernel config flags for the batctl package (id: e9cc0fc)"
		ot-kernel_y_configopt "CONFIG_BATMAN_ADV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcache_tools
# @DESCRIPTION:
# Applies kernel config flags for the bcache-tools package
ot-kernel-pkgflags_bcache_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1c16a04]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/bcache-tools" ; then
		einfo "Applying kernel config flags for the bcache-tools package (id: 1c16a04)"
		ot-kernel_y_configopt "CONFIG_BCACHE"
		ot-kernel_y_configopt "CONFIG_MD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcc
# @DESCRIPTION:
# Applies kernel config flags for the bcc
ot-kernel-pkgflags_bcc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9e67059]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/bcc" ; then
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
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "9e67059" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
		ot-kernel_y_configopt "CONFIG_KPROBES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bcm_sta
# @DESCRIPTION:
# Applies kernel config flags for the bcm-sta
ot-kernel-pkgflags_bcm_sta() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S155d9fc]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/broadcom-sta" ; then
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

		if ver_test "${MY_PV}" -ge "3.8.8" ; then
			_s1
			_s2
			ot-kernel_y_configopt "CONFIG_CFG80211"
			ewarn "Cannot use PREEMPT_RCU OR PREEMPT with bcm-sta"
			ot-kernel_unset_configopt "CONFIG_PREEMPT_RCU"
			# This package does not like PREEMPT
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
	if which getfacl "${f}" 2>/dev/null 1>/dev/null ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdbffbca]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/beep" ; then
		einfo "Applying kernel config flags for the beep package (id: dbffbca)"
		STD_PC_SPEAKER="${STD_PC_SPEAKER:-1}"
		ALSA_PC_SPEAKER="${ALSA_PC_SPEAKER:-0}"
		if [[ "${STD_PC_SPEAKER}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_INPUT_MISC"
			# pcspkr.ko mentioned in package docs
			ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"
			ot-kernel_unset_configopt "CONFIG_SND_PCSP"
		elif [[ "${ALSA_PC_SPEAKER}" == "1" ]] ; then
			# Second to avoid sound card problems
			ot-kernel_y_configopt "CONFIG_SOUND"
			ot-kernel_unset_configopt "CONFIG_UML"
			ot-kernel_y_configopt "CONFIG_SND"
			ot-kernel_y_configopt "CONFIG_SND_DRIVERS"
			ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM"
			ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
			ot-kernel_y_configopt "CONFIG_INPUT"
			ot-kernel_y_configopt "CONFIG_SND_PCSP"
		fi

		if ot-kernel_has_version "virtual/libudev" \
			&& _ot-kernel-pkgflags_has_beep_udev_rules ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2d99dc4]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/blink1" ; then
		einfo "Applying kernel config flags for the blink1 package (id: 2d99dc4)"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blktrace
# @DESCRIPTION:
# Applies kernel config flags for the blktrace package
ot-kernel-pkgflags_blktrace() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S029d340]}" == "1" ]] && return
	if ot-kernel_has_version "sys-block/blktrace" ; then
		einfo "Applying kernel config flags for the blktrace package (id: 029d340)"
		ban_disable_debug "029d340"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_IO_TRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_blueman
# @DESCRIPTION:
# Applies kernel config flags for the blueman package
ot-kernel-pkgflags_blueman() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc3a2203]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/blueman[network]" ; then
		einfo "Applying kernel config flags for the blueman package (id: c3a2203)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0794a5e]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/boost" ; then
		einfo "Applying kernel config flags for the boost package (id: 0794a5e)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4ac3437]}" == "1" ]] && return
	if ot-kernel_has_version "net-analyzer/bmon" ; then
		einfo "Applying kernel config flags for the bmon package (id: 4ac3437)"
		ot-kernel_y_configopt "CONFIG_NET_SCHED"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bluez
# @DESCRIPTION:
# Applies kernel config flags for the bluez package
ot-kernel-pkgflags_bluez() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S73d2a26]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/bluez" ; then
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
		if ot-kernel_has_version "net-wireless/bluez[mesh]" \
			|| ot-kernel_has_version "net-wireless/bluez[test]" ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API"
			ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_AEAD"
			_ot-kernel-pkgflags_aes CCM
			ot-kernel_y_configopt "CONFIG_CRYPTO_CCM"
			ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CMAC"

			ot-kernel_y_configopt "CONFIG_CRYPTO_MD5"
			ot-kernel_y_configopt "CONFIG_CRYPTO_SHA1"
			ot-kernel_y_configopt "CONFIG_KEY_DH_OPERATIONS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bpftool
# @DESCRIPTION:
# Applies kernel config flags for the bpftool package
ot-kernel-pkgflags_bpftool() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17f8f06]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/bpftool" ; then
		einfo "Applying kernel config flags for the bpftool package (id: 17f8f06)"
		ban_disable_debug "17f8f06"
		ot-kernel_y_configopt "CONFIG_DEBUG_INFO_BTF"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bpftrace
# @DESCRIPTION:
# Applies kernel config flags for the bpftrace package
ot-kernel-pkgflags_bpftrace() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Saa54616]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/bpftrace" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se9d3694]}" == "1" ]] && return
	if ot-kernel_has_version "sci-misc/boinc" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0bf997d]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/bolt[kernel_linux]" ; then
		einfo "Applying kernel config flags for the bolt package (id: 0bf997d)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc913230]}" == "1" ]] && return
	if ot-kernel_has_version "app-benchmarks/bootchart2" ; then
		einfo "Applying kernel config flags for the bootchart2 package (id: c913230)"
		ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		ot-kernel_y_configopt "CONFIG_TASKSTATS"
		ot-kernel_y_configopt "CONFIG_TASK_DELAY_ACCT"
		ot-kernel_y_configopt "CONFIG_TMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bridge_utils
# @DESCRIPTION:
# Applies kernel config flags for the bridge-utils package
ot-kernel-pkgflags_bridge_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8f12596]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/bridge-utils" ; then
		einfo "Applying kernel config flags for the bridge-utils package (id: 8f12596)"
		ot-kernel_y_configopt "CONFIG_BRIDGE_UTILS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_btrfs_progs
# @DESCRIPTION:
# Applies kernel config flags for the btrfs_progs package
ot-kernel-pkgflags_btrfs_progs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8276066]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/btrfs-progs" ; then
		einfo "Applying kernel config flags for the btrfs_progs package (id: 8276066)"
		ot-kernel_y_configopt "CONFIG_BTRFS_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_bubblewrap
# @DESCRIPTION:
# Applies kernel config flags for the bubblewrap package
ot-kernel-pkgflags_bubblewrap() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4255ad7]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/bubblewrap" ; then
		einfo "Applying kernel config flags for the bubblewrap package (id: 4255ad7)"
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_c2tcp
# @DESCRIPTION:
# Applies kernel config flags for the c2tcp package
ot-kernel-pkgflags_c2tcp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sedcf537]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/c2tcp" ; then
		einfo "Applying kernel config flags for the c2tcp package (id: edcf537)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5d91a4b]}" == "1" ]] && return
	if ot-kernel_has_version "x11-libs/cairo" ; then
		einfo "Applying kernel config flags for cairo (id: 5d91a4b)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_caja_dbox
# @DESCRIPTION:
# Applies kernel config flags for caja_dbox
ot-kernel-pkgflags_caja_dbox() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S57a6a4b]}" == "1" ]] && return
	if ot-kernel_has_version "mate-extra/caja-dropbox" ; then
		einfo "Applying kernel config flags for caja_dbox (id: 57a6a4b)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_catalyst
# @DESCRIPTION:
# Applies kernel config flags for the catalyst package
ot-kernel-pkgflags_catalyst() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S14ce6b4]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/catalyst" ; then
		einfo "Applying kernel config flags for the catalyst package (id: 14ce6b4)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5e2da8b]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/cdm" ; then
		einfo "Applying kernel config flags for the cdm package (id: 5e2da8b)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc3a2b46]}" == "1" ]] && return
	einfo "Applying kernel config flags for CD-ROM packages(s) (id: c3a2b46)"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	if [[ "${CDROM_FS_ZISOFS:-0}" ]] ; then
		ot-kernel_y_configopt "CONFIG_ZISOFS"
	fi
	if [[ "${CDROM_FS_UDF:-0}" ]] ; then
		ot-kernel_y_configopt "CONFIG_UDF_FS"
	fi

	ot-kernel_y_configopt "CONFIG_ACPI"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf8ae20a]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/cifs-utils" ; then
		einfo "Applying kernel config flags for the cifs-utils package (id: f8ae20a)"
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
		:
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
	if ot-kernel-pkgflags_has_kflag "CONFIG_SCTP_COOKIE_HMAC_SHA1" \
		|| ot-kernel-pkgflags_has_kflag "SCTP_DEFAULT_COOKIE_HMAC_SHA1" ; then
		_ot-kernel-pkgflags_sha1
	fi
	if ot-kernel-pkgflags_has_kflag "CONFIG_SCTP_COOKIE_HMAC_MD5" \
		|| ot-kernel-pkgflags_has_kflag "SCTP_DEFAULT_COOKIE_HMAC_MD5" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4a45383]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/chroot-wrapper" ; then
		einfo "Applying kernel config flags for the chroot-wrapper package (id: 4a45383)"
		ot-kernel_y_configopt "CONFIG_TMPFS"
		_ot-kernel_set_ipc_ns
		_ot-kernel_set_uts_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clamav
# @DESCRIPTION:
# Applies kernel config flags for the clamav package
ot-kernel-pkgflags_clamav() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1545fdb]}" == "1" ]] && return
	if ot-kernel_has_version "app-antivirus/clamav" ; then
		einfo "Applying kernel config flags for the clamav package (id: 1545fdb)"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_FANOTIFY_ACCESS_PERMISSIONS"

		# Defined but not used
		# ot-kernel_y_configopt "CONFIG_EXPERT"
		# ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		# ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbbd28c4]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/clamfs" ; then
		einfo "Applying kernel config flags for the clamfs package (id: bbd28c4)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clang
# @DESCRIPTION:
# Applies kernel config flags for the clang package
ot-kernel-pkgflags_clang() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Safc5318]}" == "1" ]] && return
	if ot-kernel_has_version "sys-devel/clang" ; then
		einfo "Applying kernel config flags for the clang package (id: afc5318)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_clsync
# @DESCRIPTION:
# Applies kernel config flags for the clsync package
ot-kernel-pkgflags_clsync() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scbd5946]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/clsync[clsync]" ; then
		einfo "Applying kernel config flags for the clsync package (id: cbd5946)"
		if ot-kernel_has_version "app-admin/clsync[inotify]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
		if ot-kernel_has_version "app-admin/clsync[namespaces]" ; then
			_ot-kernel_set_ipc_ns
			_ot-kernel_set_net_ns
			_ot-kernel_set_pid_ns
			_ot-kernel_set_user_ns
			_ot-kernel_set_uts_ns
		fi
		if ot-kernel_has_version "app-admin/clsync[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cni_plugins
# @DESCRIPTION:
# Applies kernel config flags for the cni-plugins package
ot-kernel-pkgflags_cni_plugins() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdec3486]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/cni-plugins" ; then
		einfo "Applying kernel config flags for the cni-plugins package (id: dec3486)"
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_collectd
# @DESCRIPTION:
# Applies kernel config flags for the collectd package
ot-kernel-pkgflags_collectd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc086216]}" == "1" ]] && return
	if ot-kernel_has_version "app-metrics/collectd" ; then
		einfo "Applying kernel config flags for the collectd package (id: c086216)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_battery]" && ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_cgroups]" && ot-kernel_y_configopt "CONFIG_CGROUPS"
		if ot-kernel_has_version "app-metrics/collectd[collectd_plugins_cpufreq]" ; then
			ot-kernel_y_configopt "CONFIG_SYSFS"
			ot-kernel_y_configopt "CONFIG_CPU_FREQ_STAT"
		fi
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_drbd]" && ot-kernel_y_configopt "CONFIG_BLK_DEV_DRBD"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_conntrack]" && ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_fscache]" && ot-kernel_y_configopt "CONFIG_FSCACHE"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_nfs]" && ot-kernel_y_configopt "CONFIG_NFS_COMMON"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_serial]" && ot-kernel_y_configopt "CONFIG_SERIAL_CORE"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_swap]" && ot-kernel_y_configopt "CONFIG_SWAP"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_thermal]" && ot-kernel_y_configopt "CONFIG_ACPI_THERMAL"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_turbostat]" && ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_vmem]" && ot-kernel_y_configopt "CONFIG_VM_EVENT_COUNTERS"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_vserver]" && ot-kernel_y_configopt "CONFIG_VSERVER"
		ot-kernel_has_version "app-metrics/collectd[collectd_plugins_uuid]" && ot-kernel_y_configopt "CONFIG_SYSFS"
		if ot-kernel_has_version "app-metrics/collectd[collectd_plugins_wireless]" ; then
			ot-kernel_y_configopt "CONFIG_WIRELESS"
			ot-kernel_y_configopt "CONFIG_MAC80211"
			ot-kernel_y_configopt "CONFIG_IEEE80211"
		fi
		if ot-kernel_has_version "app-metrics/collectd[collectd_plugins_zfs_arc]" ; then
			ot-kernel_y_configopt "CONFIG_SPL"
			ot-kernel_y_configopt "CONFIG_ZFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_compiler_rt_sanitizers
# @DESCRIPTION:
# Applies kernel config flags for the compiler-rt-sanitizers package
ot-kernel-pkgflags_compiler_rt_sanitizers() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa0dc43a]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/compiler-rt-sanitizers" ; then
		einfo "Applying kernel config flags for the compiler-rt-sanitizers package (id: a0dc43a)"
	        ot-kernel_y_configopt "CONFIG_SYSVIPC"
		if ot-kernel_has_version "sys-libs/compiler-rt-sanitizers[test]" ; then
			ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0a83d3b]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/conky" ; then
		einfo "Applying kernel config flags for the conky package (id: 0a83d3b)"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_conntrack_tools
# @DESCRIPTION:
# Applies kernel config flags for the conntrack-tools package
ot-kernel-pkgflags_conntrack_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf6a25e5]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/conntrack-tools" ; then
		einfo "Applying kernel config flags for the conntrack-tools package (id: f6a25e5)"
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

# @FUNCTION: ot-kernel-pkgflags_coreutils
# @DESCRIPTION:
# Applies kernel config flags for the coreutils package
ot-kernel-pkgflags_coreutils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3d041d8]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/coreutils" ; then
		einfo "Applying kernel config flags for the coreutils package (id: 3d041d8)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_corosync
# @DESCRIPTION:
# Applies kernel config flags for the corosync package
ot-kernel-pkgflags_corosync() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S63be96c]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/corosync[watchdog]" ; then
		einfo "Applying kernel config flags for the corosync package (id: 63be96c)"
		ot-kernel_y_configopt "CONFIG_WATCHDOG"
		_ot-kernel-pkgflags_add_watchdog_drivers
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_cr_suid_sandbox_settings
# @DESCRIPTION:
# Add config settings for suid sandbox support
_ot-kernel-pkgflags_cr_suid_sandbox_settings() { # DONE
	_ot-kernel_set_net_ns
	_ot-kernel_set_pid_ns
	_ot-kernel_set_user_ns
	ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
	ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
	ot-kernel_unset_configopt "CONFIG_COMPAT_VDSO"
	if grep -q -e "^CONFIG_GRKERNSEC=y" "${path_config}" ; then
		# Still added because user may add patch via /etc/portage/patches
eerror
eerror "Lowered security detected:"
eerror "The CONFIG_GRKERNSEC flag will break the suid sandbox."
eerror "Either set OT_KERNEL_PKGFLAGS_REJECT[S4aa6a9f]=1 or disable CONFIG_GRKERNSEC."
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
media-video/obs-studio
net-im/caprine
net-im/discord
net-im/discord-bin
net-im/discord-canary-bin
net-im/discord-ptb-bin
net-im/element-desktop-bin
net-im/guilded-bin
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

# @FUNCTION: _ot-kernel-pkgflags_cr_based
# @DESCRIPTION:
# Returns 0 if it is a cr based package.
_ot-kernel-pkgflags_cr_based() {
	local pkg
	for pkg in ${CR_PKGS[@]} ; do
		ot-kernel_has_version "${pkg}" && return 0
	done
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_cr
# @DESCRIPTION:
# Applies kernel config flags for the cr based packages
ot-kernel-pkgflags_cr() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4aa6a9f]}" == "1" ]] && return
	if _ot-kernel-pkgflags_cr_based \
		|| [[ "${USE_SUID_SANDBOX:-0}" == "1" ]] ; then
		einfo "Applying kernel config flags for cr and derivatives (id: 4aa6a9f)"
		_ot-kernel-pkgflags_cr_suid_sandbox_settings
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"

		# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss
		# LDT referenced
	fi
}

# @FUNCTION: ot-kernel-pkgflags_crda
# @DESCRIPTION:
# Applies kernel config flags for the crda package
ot-kernel-pkgflags_crda() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2ac64d4]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/crda" ; then
		ot-kernel_has_version "net-wireless/wireless-regdb" || die "Install the wireless-regdb package first"
		einfo "Applying kernel config flags for the crda package (id: 2ac64d4)"
		ot-kernel_y_configopt "CONFIG_CFG80211_CRDA_SUPPORT"

		einfo "Auto adding wireless-regdb firmware."
		local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
		firmware=$(echo "${firmware}" \
			| tr " " "\n" \
			| sed -r -e 's|regulatory.db(.p7s)?$||g' \
			| tr "\n" " ") # dedupe
		firmware="${firmware} regulatory.db regulatory.db.p7s" # Dump firmware relpaths
		firmware=$(echo "${firmware}" \
			| sed -r -e "s|[ ]+| |g" \
				-e "s|^[ ]+||g" \
				-e 's|[ ]+$||g') # Trim mid/left/right spaces
		ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
		local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
		einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S484c86a]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/criu" ; then
		einfo "Applying kernel config flags for the criu package (id: 484c86a)"
		ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"

		_ot-kernel_set_pid_ns

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_UNIX_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_DIAG"
		ot-kernel_y_configopt "CONFIG_INET_UDP_DIAG"
		ot-kernel_y_configopt "CONFIG_PACKET_DIAG"
		ot-kernel_y_configopt "CONFIG_NETLINK_DIAG"
		_ot-kernel-pkgflags_tun
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4cd1f23]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/cryfs" ; then
		einfo "Applying kernel config flags for the cryfs package (id: 4cd1f23)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cryptodev
# @DESCRIPTION:
# Applies kernel config flags for the cryptodev package
ot-kernel-pkgflags_cryptodev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5bfeb14]}" == "1" ]] && return
	if ot-kernel_has_version "sys-kernel/cryptodev" ; then
		einfo "Applying kernel config flags for the cryptodev package (id: 5bfeb14)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S42b9891]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/cryptmount" ; then
		einfo "Applying kernel config flags for the cryptmount package (id: 42b9891)"
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
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM_BS"
			fi
			if [[ "${modes}" =~ ("CBC"|"CTR"|"ECB"|"XTS") ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_AES_ARM_CE"
			fi
			if [[ "${modes}" =~ "GCM" ]] ; then
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
			if [[ "${modes}" =~ "GCM" ]] ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_ARM64_CE"
			fi
			if [[ "${modes}" =~ "CCM" ]] ; then
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
	ot-kernel_y_configopt "CONFIG_CRYPTO_AES"
}

# @FUNCTION: _ot-kernel-pkgflags_anubis
# @DESCRIPTION:
# Wrapper for the anubis option.
_ot-kernel-pkgflags_anubis() {
	[[ "${OT_KERNEL_HAVE_CRYPTO_DEV_ANUBIS}" == "1" ]] && continue
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
		ot-kernel_y_configopt "CONFIG_CRYPTO_BLAKE2S_X86"
	fi
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
		if ot-kernel_use cpu_flags_x86_avx2 && ot-kernel_use cpu_flags_x86_aesni && [[ "${modes}" =~ ("CBC"|"ECB"|"XTS") ]] ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64"
			ot-kernel_y_configopt "CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64"
		elif ot-kernel_use cpu_flags_x86_avx && ot-kernel_use cpu_flags_x86_aesni && [[ "${modes}" =~ ("CBC"|"ECB"|"XTS") ]] ; then
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
	if [[ "${arch}" == "x86_64" ]] ; then
		if ot-kernel_use cpu_flags_x86_avx512vl ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif ot-kernel_use cpu_flags_x86_avx2 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		elif ot-kernel_use cpu_flags_x86_ssse3 ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20_X86_64"
		fi
	fi
	ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA20"
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
		if ot-kernel_use cpu_flags_x86_aes ; then
			ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL"
		fi
	fi
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
	ot-kernel_y_configopt "CONFIG_CRYPTO_SHA512"
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
	ot-kernel_y_configopt "CONFIG_CRYPTO_SERPENT"
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
		else
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
	ot-kernel_y_configopt "CONFIG_CRYPTO_POLY1305"
	ot-kernel_y_configopt "CONFIG_CRYPTO_LIB_POLY1305_GENERIC"
}

# @FUNCTION: ot-kernel-pkgflags_cryptsetup
# @DESCRIPTION:
# Applies kernel config flags for the cryptsetup package
ot-kernel-pkgflags_cryptsetup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sde0f460]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/cryptsetup" ; then
		einfo "Applying kernel config flags for the cryptsetup package (id: de0f460)"
		ot-kernel_y_configopt "CONFIG_MODULES"
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

		[[ "${cryptsetup_ciphers}" =~ "aes" ]] && _ot-kernel-pkgflags_aes ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "anubis" ]] && _ot-kernel-pkgflags_anubis ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "camellia" ]] && _ot-kernel-pkgflags_camellia ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "cast6" ]] && _ot-kernel-pkgflags_cast6 ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "serpent" ]] && _ot-kernel-pkgflags_serpent ${cryptsetup_modes}
		[[ "${cryptsetup_ciphers}" =~ "twofish" ]] && _ot-kernel-pkgflags_twofish ${cryptsetup_modes}

		[[ "${cryptsetup_hashes}" =~ "blake2b" ]] && _ot-kernel-pkgflags_blake2b
		[[ "${cryptsetup_hashes}" =~ "blake2s" ]] && _ot-kernel-pkgflags_blake2s
		[[ "${cryptsetup_hashes}" =~ "rmd160" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_RMD160"
		[[ "${cryptsetup_hashes}" =~ "sha256" ]] && _ot-kernel-pkgflags_sha256
		[[ "${cryptsetup_hashes}" =~ "sha512" ]] && _ot-kernel-pkgflags_sha512
		[[ "${cryptsetup_hashes}" =~ "sha3" ]] && _ot-kernel-pkgflags_sha3
		[[ "${cryptsetup_hashes}" =~ "wp512" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_WP512"

		[[ "${cryptsetup_ivs}" =~ "essiv" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_ESSIV"	# For compatibility, do not use for newer deployments

		[[ "${cryptsetup_modes}" =~ "cbc" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CBC"	# From ebuild
		[[ "${cryptsetup_modes}" =~ "cfb" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CFB"
		[[ "${cryptsetup_modes}" =~ "ctr" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CTR"
		[[ "${cryptsetup_modes}" =~ "cts" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_CTS"
		[[ "${cryptsetup_modes}" =~ "ofb" ]] && ot-kernel_y_configopt "CONFIG_CRYPTO_OFB"
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
			_ot-kernel-pkgflags_chacha20 # Uses actually XChaCha12 for stream cipher
			_ot-kernel-pkgflags_nhpoly1305 # A hash function from this module
			# AES already added above.
			# AES is as the block cipher is used upstream, but any 16 byte block size with 256 bit key
			# Possibly compatible blockciphers:
			#   aes (belgian)
			#   anubis (belgian - brazilian)
			#   cast6 (canadian)
			#   serpent (canadian - israeli - danish)
			#   sm4 (chinese)
			#   twofish (american)
			ot-kernel_y_configopt "CONFIG_CRYPTO_MANAGER"
			ot-kernel_y_configopt "CONFIG_CRYPTO_ADIANTUM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cups
# @DESCRIPTION:
# Applies kernel config flags for the cups package
ot-kernel-pkgflags_cups() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdbb3834]}" == "1" ]] && return
	if ot-kernel_has_version "net-print/cups[-usb]" ; then
		# The usb USE flag is a misnomer.
		# usb = support via libusb
		# -usb = kernel usb printer driver

		# Implied ot-kernel_has_version "net-print/cups[linux_kernel]"
		einfo "Applying kernel config flags for the cups package (id: dbb3834)"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_cvmfs
# @DESCRIPTION:
# Applies kernel config flags for the cvmfs package
ot-kernel-pkgflags_cvmfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S967ed28]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/cvmfs" ; then
		einfo "Applying kernel config flags for the cvmfs package (id: 967ed28)"
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dahdi
# @DESCRIPTION:
# Applies kernel config flags for the dahdi package
ot-kernel-pkgflags_dahdi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S31c5fa5]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/dahdi" ; then
		einfo "Applying kernel config flags for numa support for the dahdi package (id: 31c5fa5)"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_CRC_CCITT"
		if ot-kernel_has_version "net-misc/dahdi[oslec]" ; then
			ot-kernel_y_configopt "CONFIG_ECHO"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_db_numa
# @DESCRIPTION:
# Applies kernel config flags for the db package with numa support
ot-kernel-pkgflags_db_numa() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb150cb7]}" == "1" ]] && return
	if ot-kernel_has_version "dev-db/mysql[numa]" \
		|| ot-kernel_has_version "dev-db/percona-server[numa]" ; then
		einfo "Applying kernel config flags for numa support for a database package (id: b150cb7)"
		ot-kernel_y_configopt "CONFIG_NUMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dbus
# @DESCRIPTION:
# Applies kernel config flags for the dbus package
ot-kernel-pkgflags_dbus() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb9e31e7]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/dbus" ; then
		# Implied ot-kernel_has_version "sys-apps/dbus[linux_kernel]"
		einfo "Applying kernel config flags for the dbus package (id: b9e31e7)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL" # Did not find in scan but ebuild suggested.
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dccutil
# @DESCRIPTION:
# Applies kernel config flags for the dccutil package
ot-kernel-pkgflags_dccutil() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6805d71]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/ddcutil" ; then
		einfo "Applying kernel config flags for the dccutil package (id: 6805d71)"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		if ot-kernel_has_version "app-misc/ddcutil[usb-monitor]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa70d302]}" == "1" ]] && return
	if ot-kernel_has_version "gui-apps/ddlm" ; then
		einfo "Applying kernel config flags for the ddlm package (id: a70d302)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_deepcc
# @DESCRIPTION:
# Applies kernel config flags for the deepcc package
ot-kernel-pkgflags_deepcc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S600cf83]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/deepcc" ; then
		einfo "Applying kernel config flags for the deepcc package (id: 600cf83)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S88334b9]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/dietlibc" ; then
		einfo "Applying kernel config flags for dietlibc (id: 88334b9)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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

# @FUNCTION: ot-kernel-pkgflags_discord
# @DESCRIPTION:
# Applies kernel config flags for discord
ot-kernel-pkgflags_discord() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbcc3f54]}" == "1" ]] && return
	if ot-kernel_has_version "net-im/discord-bin" \
		|| ot-kernel_has_version "net-im/discord" ; then
		einfo "Applying kernel config flags for discord (id: bcc3f54)"
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_distrobuilder
# @DESCRIPTION:
# Applies kernel config flags for the distrobuilder package
ot-kernel-pkgflags_distrobuilder() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9ed33e8]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/distrobuilder" ; then
		einfo "Applying kernel config flags for distrobuilder package (id: 9ed33e8)"
		ot-kernel_y_configopt "CONFIG_OVERLAY_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_drbd_utils
# @DESCRIPTION:
# Applies kernel config flags for the drbd-utils package
ot-kernel-pkgflags_drbd_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S99eaf4d]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/drbd-utils" ; then
		einfo "Applying kernel config flags for the drbd-utils package (id: 99eaf4d)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DRBD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_droidcam
# @DESCRIPTION:
# Applies kernel config flags for the droidcam package
ot-kernel-pkgflags_droidcam() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S82100d3]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/droidcam" ; then
		einfo "Applying kernel config flags for the droidcam package (id: 82100d3)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S494db6b]}" == "1" ]] && return
	if ot-kernel_has_version "sys-kernel/dracut" ; then
		einfo "Applying kernel config flags for the dracut package (id: 494db6b)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_INITRD"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dropwatch
# @DESCRIPTION:
# Applies kernel config flags for the dropwatch package
ot-kernel-pkgflags_dropwatch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7422820]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/dropwatch" ; then
		einfo "Applying kernel config flags for the dropwatch package (id: 7422820)"
		ot-kernel_y_configopt "CONFIG_NET_DROP_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dvd
# @DESCRIPTION:
# Applies kernel config flags for the DVD packages
ot-kernel-pkgflags_dvd() { #
	[[ "${DVD:-1}" == "1" ]] || return
	# Simplified code without autodetection
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S080b6ff]}" == "1" ]] && return
	einfo "Applying kernel config flags for DVD package(s) (id: 080b6ff)"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_UDF_FS"
}

# @FUNCTION: ot-kernel-pkgflags_latencytop
# @DESCRIPTION:
# Applies kernel config flags for the latencytop package
ot-kernel-pkgflags_latencytop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1e47c47]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/latencytop" ; then
		einfo "Applying kernel config flags for the latencytop package (id: 1e47c47)"
		ot-kernel_y_configopt "CONFIG_LATENCYTOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcec
# @DESCRIPTION:
# Applies kernel config flags for the libcec package
ot-kernel-pkgflags_libcec() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc7a68c0]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/libcec" ; then
		einfo "Applying kernel config flags for the libcec package (id: c7a68c0)"
		ot-kernel_y_configopt "CONFIG_USB_ACM"
		if ot-kernel_has_version "dev-libs/libcec[-udev]" ; then
			ot-kernel_y_configopt "CONFIG_SYSFS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_docker
# @DESCRIPTION:
# Applies kernel config flags for the docker package
ot-kernel-pkgflags_docker() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S05309e2]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/docker" ; then
		einfo "Applying kernel config flags for the docker package (id: 05309e2)"
		_ot-kernel_set_posix_mqueue
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_MEMCG"
		if ver_test "${KV_MAJOR_MINOR}" -le "5.7" ; then
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP"
			ot-kernel_y_configopt "CONFIG_MEMCG_SWAP_ENABLED"
		fi
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_CGROUP"
		if ver_test "${KV_MAJOR_MINOR}" -le "5.2" ; then
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
		if has_version "app-containers/docker[device-mapper]" ; then
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

		if has_version "app-containers/docker[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP" # Referenced in file path but not in code ; requested by ebuild
			ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		fi

		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
#		# _ot-kernel_y_thp # References it but no madvise/fadvise
		# LDT referenced

		if ver_test "${KV_MAJOR_MINOR}" -le "4.8" ; then
			ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
			ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -le "5.2" ; then
			ot-kernel_y_configopt "CONFIG_NF_NAT_NEEDED"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.15" ; then
			ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
			ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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

		if has_version "app-containers/docker[selinux]" ; then
			ot-kernel_y_configopt "CONFIG_SECURITY_SELINUX"
			ot-kernel_y_configopt "CONFIG_SYSFS"
			ot-kernel_y_configopt "CONFIG_MULTIUSER"
			ot-kernel_y_configopt "CONFIG_SECURITY"
			ot-kernel_y_configopt "CONFIG_SECURITY_NETWORK"
			ot-kernel_y_configopt "CONFIG_AUDIT"
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"
		fi

		if has_version "app-containers/docker[apparmor]" ; then
			ot-kernel_y_configopt "CONFIG_SECURITY_APPARMOR"
			ot-kernel_y_configopt "CONFIG_SYSFS"
			ot-kernel_y_configopt "CONFIG_MULTIUSER"
			ot-kernel_y_configopt "CONFIG_SECURITY"
			ot-kernel_y_configopt "CONFIG_NET"
		fi

		ot-kernel_y_configopt "CONFIG_EXT4_FS"
		ot-kernel_y_configopt "CONFIG_EXT4_FS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_EXT4_FS_SECURITY"

		ot-kernel_y_configopt "CONFIG_VXLAN"
		ot-kernel_y_configopt "CONFIG_BRIDGE_VLAN_FILTERING"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_AEAD"
		ot-kernel_y_configopt "CONFIG_CRYPTO_GCM"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SEQIV"
		ot-kernel_y_configopt "CONFIG_CRYPTO_GHASH"
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

		#if has_version "app-containers/docker[aufs]" ; then
		#	ot-kernel_y_configopt "CONFIG_AUFS_FS"
		#fi

		if has_version "app-containers/docker[btrfs]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3aa143d]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/doas" ; then
		einfo "Applying kernel config flags for the doas package (id: 3aa143d)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dosemu
# @DESCRIPTION:
# Applies kernel config flags for the dosemu package
ot-kernel-pkgflags_dosemu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4e97be4]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/dosemu" ; then
		einfo "Applying kernel config flags for the dosemu package (id: 4e97be4)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		warn_lowered_security "4e97be4"
		ot-kernel_y_configopt "CONFIG_MODIFY_LDT_SYSCALL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_dpdk
# @DESCRIPTION:
# Applies kernel config flags for the dpdk package
ot-kernel-pkgflags_dpdk() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7a815b4]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/dpdk" ; then
		einfo "Applying kernel config flags for the dpdk package (id: 7a815b4)"
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
		ot-kernel_y_configopt "CONFIG_ACPI"
		ot-kernel_y_configopt "CONFIG_HPET"
		ot-kernel_y_configopt "CONFIG_HPET_MMAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_e2fsprogs
# @DESCRIPTION:
# Applies kernel config flags for the e2fsprogs package
ot-kernel-pkgflags_e2fsprogs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0d4e223]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/e2fsprogs" ; then
		einfo "Applying kernel config flags for the e2fsprogs package (id: 0d4e223)"
		if [[ "${EXT4_ENCRYPTION:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_EXT4_FS"
			ot-kernel_y_configopt "CONFIG_FS_ENCRYPTION"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ecryptfs
# @DESCRIPTION:
# Applies kernel config flags for the ecryptfs package
ot-kernel-pkgflags_ecryptfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7e08ae3]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/ecryptfs-utils" ; then
		einfo "Applying kernel config flags for the ecryptfs package (id: 7e08ae3)"
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_ECRYPT_FS"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_efibootmgr
# @DESCRIPTION:
# Applies kernel config flags for the efibootmgr package
ot-kernel-pkgflags_efibootmgr() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc19b4be]}" == "1" ]] && return
	if ot-kernel_has_version "sys-boot/efibootmgr" ; then
		einfo "Applying kernel config flags for the efibootmgr package (id: c19b4be)"
		ot-kernel_y_configopt "CONFIG_EFI_VARS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ekeyd
# @DESCRIPTION:
# Applies kernel config flags for the ekeyd package
ot-kernel-pkgflags_ekeyd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb71bfeb]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/ekeyd" ; then
		einfo "Applying kernel config flags for the ekeyd package (id: b71bfeb)"
		ot-kernel_y_configopt "CONFIG_USB_ACM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ell
# @DESCRIPTION:
# Applies kernel config flags for the ell package
ot-kernel-pkgflags_ell() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S07b5e1f]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/ell" ; then
		einfo "Applying kernel config flags for the ell package (id: 07b5e1f)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se7308d9]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/elogind" ; then
		einfo "Applying kernel config flags for the elogind package (id: e7308d9)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_emacs
# @DESCRIPTION:
# Applies kernel config flags for the emacs package
ot-kernel-pkgflags_emacs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdc900bc]}" == "1" ]] && return
	if ot-kernel_has_version "app-editors/emacs" ; then
		einfo "Applying kernel config flags for the emacs package (id: dc900bc)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S121bc50]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/embree" ; then
		einfo "Applying kernel config flags for the embree package (id: 121bc50)"
		_ot-kernel_y_thp # ~5 - ~10% improvement
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ena_driver
# @DESCRIPTION:
# Applies kernel config flags for the ena_driver package
ot-kernel-pkgflags_ena_driver() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0fd4edf]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/ena-driver" ; then
		einfo "Applying kernel config flags for the ena-driver package (id: 0fd4edf)"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
		ot-kernel_unset_configopt "CONFIG_CPU_BIG_ENDIAN"
		ot-kernel_y_configopt "CONFIG_DIMLIB"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_encfs
# @DESCRIPTION:
# Applies kernel config flags for the encfs package
ot-kernel-pkgflags_encfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3e70419]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/encfs" ; then
		einfo "Applying kernel config flags for the encfs package (id: 3e70419)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_epoch
# @DESCRIPTION:
# Applies kernel config flags for the epoch package
ot-kernel-pkgflags_epoch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5e952fe]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/epoch" ; then
		einfo "Applying kernel config flags for the epoch package (id: 5e952fe)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_espeakup
# @DESCRIPTION:
# Applies kernel config flags for the espeakup package
ot-kernel-pkgflags_espeakup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5202028]}" == "1" ]] && return
	if ot-kernel_has_version "app-accessibility/espeakup" ; then
		einfo "Applying kernel config flags for the espeakup package (id: 5202028)"
		ot-kernel_y_configopt "CONFIG_SPEAKUP"
		ot-kernel_y_configopt "CONFIG_SPEAKUP_SYNTH_SOFT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_eudev
# @DESCRIPTION:
# Applies kernel config flags for the eudev package
ot-kernel-pkgflags_eudev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9c95acb]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/eudev" ; then
		einfo "Applying kernel config flags for the eudev package (id: 9c95acb)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_unset_configopt "CONFIG_IDE"
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

# @FUNCTION: ot-kernel-pkgflags_eventd
# @DESCRIPTION:
# Applies kernel config flags for the eventd package
ot-kernel-pkgflags_eventd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9baffe9]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/eventd[ipv6]" ; then
		einfo "Applying kernel config flags for the eventd package (id: 9baffe9)"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_f2fs_tools
# @DESCRIPTION:
# Applies kernel config flags for the f2fs-tools package
ot-kernel-pkgflags_f2fs_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3a3a096]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/f2fs-tools" ; then
		einfo "Applying kernel config flags for the f2fs-tools package (id: 3a3a096)"
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

# @FUNCTION: _ot-kernel-pkgflags_ff_based
# @DESCRIPTION:
# Returns 0 if ff based
_ot-kernel-pkgflags_ff_based() {
	local pkg
	for pkg in ${FF_PKGS[@]} ; do
		ot-kernel_has_version "${pkg}" && return 0
	done
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_ff
# @DESCRIPTION:
# Applies kernel config flags for the ff based packages
ot-kernel-pkgflags_ff() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb5b1507]}" == "1" ]] && return
	if _ot-kernel-pkgflags_ff_based ; then
		einfo "Applying kernel config flags for ff and derivatives (id: b5b1507)"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"

		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_TIMERFD"

		# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ffmpeg
# @DESCRIPTION:
# Applies kernel config flags for the ffmpeg package
ot-kernel-pkgflags_ffmpeg() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S13c68c4]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/ffmpeg[X]" ; then
		einfo "Applying kernel config flags for the ffmpeg package (id: 13c68c4)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firecracker_bin
# @DESCRIPTION:
# Applies kernel config flags for the firecracker_bin package
ot-kernel-pkgflags_firecracker_bin() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S16d1550]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/firecracker-bin" ; then
		einfo "Applying kernel config flags for the firecracker_bin package (id: 16d1550)"
		ot-kernel-pkgflags_kvm_host_required
		_ot-kernel-pkgflags_tun
		ot-kernel_y_configopt "CONFIG_BRIDGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_firehol
# @DESCRIPTION:
# Applies kernel config flags for the firehol package
ot-kernel-pkgflags_firehol() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc2c3d67]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/firehol" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6c85b82]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/firewalld" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S427345a]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/flatpak" ; then
		einfo "Applying kernel config flags for the flatpak package (id: 427345a)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S222b6c4]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/firejail" ; then
		einfo "Applying kernel config flags for the firejail package (id: 222b6c4)"
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_fuse
# @DESCRIPTION:
# Applies kernel config flags for the fuse package
ot-kernel-pkgflags_fuse() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7a6e898]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/fuse" ; then
		einfo "Applying kernel config flags for the fuse package (id: 7a6e898)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_fwknop
# @DESCRIPTION:
# Applies kernel config flags for the fwknop package
ot-kernel-pkgflags_fwknop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2f507ac]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/fwknop" ; then
		einfo "Applying kernel config flags for the fwknop package (id: 2f507ac)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_COMMENT"
		if ot-kernel_has_version "net-firewall/fwknop[nfqueue]" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_g15daemon
# @DESCRIPTION:
# Applies kernel config flags for the g15daemon package
ot-kernel-pkgflags_g15daemon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S602f7e1]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/g15daemon" ; then
		einfo "Applying kernel config flags for the g15daemon package (id: 602f7e1)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gambas
# @DESCRIPTION:
# Applies kernel config flags for the gambas package
ot-kernel-pkgflags_gambas() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5d0a192]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/gambas" ; then
		einfo "Applying kernel config flags for the gambas package (id: 5d0a192)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gcc
# @DESCRIPTION:
# Applies kernel config flags for the gcc package
ot-kernel-pkgflags_gcc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb22a134]}" == "1" ]] && return
	if ot-kernel_has_version "sys-devel/gcc" ; then
		einfo "Applying kernel config flags for the gcc package (id: b22a134)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		# _ot-kernel_y_thp # Referenced but no noted performance gain/loss
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gdm
# @DESCRIPTION:
# Applies kernel config flags for the gdm package
ot-kernel-pkgflags_gdm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc879f86]}" == "1" ]] && return
	if ot-kernel_has_version "gnome-base/gdm" ; then
		einfo "Applying kernel config flags for the gdm package (id: c879f86)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gerbera
# @DESCRIPTION:
# Applies kernel config flags for the gerbera package
ot-kernel-pkgflags_gerbera() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Seca1a38]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/gerbera" ; then
		einfo "Applying kernel config flags for the gerbera package (id: eca1a38)"
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ghc
# @DESCRIPTION:
# Applies kernel config flags for the ghc package
ot-kernel-pkgflags_ghc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4d6a688]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/ghc" ; then
		einfo "Applying kernel config flags for the ghc package (id: 4d6a688)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glances
# @DESCRIPTION:
# Applies kernel config flags for the glances package
ot-kernel-pkgflags_glances() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S71ea7b8]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/glances" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8210745]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/glib" ; then
		einfo "Applying kernel config flags for the glib package (id: 8210745)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		if ot-kernel_has_version "dev-libs/glib[test]" ; then
		        _ot-kernel-pkgflags_tcpip
		        ot-kernel_y_configopt "CONFIG_IPV6"
		fi

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_glibc
# @DESCRIPTION:
# Applies kernel config flags for the glibc package
ot-kernel-pkgflags_glibc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa8f0ac7]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/glibc" ; then
		einfo "Applying kernel config flags for the glibc package (id: a8f0ac7)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa4db0bd]}" == "1" ]] && return
	if ot-kernel_has_version "app-mobilephone/gnokii" ; then
		einfo "Applying kernel config flags for the gnokii package (id: a4db0bd)"
		ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gnome_boxes
# @DESCRIPTION:
# Applies kernel config flags for the gnome-boxes package
ot-kernel-pkgflags_gnome_boxes() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S768ed31]}" == "1" ]] && return
	if ot-kernel_has_version "gnome-extra/gnome-boxes" ; then
		einfo "Applying kernel config flags for the gnome-boxes package (id: 768ed31)"
		: # See ot-kernel-pkgflags_qemu
	fi
}

# @FUNCTION: ot-kernel-pkgflags_go
# @DESCRIPTION:
# Applies kernel config flags for the go package
ot-kernel-pkgflags_go() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se5375a0]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/go" ; then
		einfo "Applying kernel config flags for the go package (id: e5375a0)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sed780a3]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/gpm" ; then
		einfo "Applying kernel config flags for the gpm package (id: ed780a3)"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_greetd
# @DESCRIPTION:
# Applies kernel config flags for the greetd package
ot-kernel-pkgflags_greetd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se08f82d]}" == "1" ]] && return
	if ot-kernel_has_version "gui-libs/greetd" ; then
		einfo "Applying kernel config flags for the greetd package (id: e08f82d)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_grs
# @DESCRIPTION:
# Applies kernel config flags for the grs package
ot-kernel-pkgflags_grs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5cf3aa9]}" == "1" ]] && return
	if ot-kernel_has_version "app-portage/grs" ; then
		einfo "Applying kernel config flags for the grs package (id: 5cf3aa9)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gspca_ep800
# @DESCRIPTION:
# Applies kernel config flags for the gspca_ep800 package
ot-kernel-pkgflags_gspca_ep800() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3302dae]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/gspca_ep800" ; then
		einfo "Applying kernel config flags for the gspca_ep800 package (id: 3302dae)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa9b82da]}" == "1" ]] && return
	if ot-kernel_has_version "media-plugins/gst-plugins-ximagesrc" ; then
		einfo "Applying kernel config flags for the gst-plugins-ximagesrc package (id: a9b82da)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gstreamer
# @DESCRIPTION:
# Applies kernel config flags for the gstreamer package
ot-kernel-pkgflags_gstreamer() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf295763]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/gstreamer" ; then
		einfo "Applying kernel config flags for the gstreamer package (id: f295763)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gtkgreet
# @DESCRIPTION:
# Applies kernel config flags for the gtkgreet package
ot-kernel-pkgflags_gtkgreet() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2c93edf]}" == "1" ]] && return
	if ot-kernel_has_version "gui-apps/gtkgreet" ; then
		einfo "Applying kernel config flags for the gtkgreet package (id: 2c93edf)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_guestfs
# @DESCRIPTION:
# Applies kernel config flags for the guestfs package(s)
ot-kernel-pkgflags_guestfs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S59d09c6]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/libguestfs" \
		|| ot-kernel_has_version "app-emulation/guestfs-tools" ; then
		einfo "Applying kernel config flags for the guestfs package(s) (id: 59d09c6)"
		: # See ot-kernel-pkgflags_qemu
		ot-kernel_y_configopt "CONFIG_VIRTIO" # For guest
	fi
}

# @FUNCTION: ot-kernel-pkgflags_gvrpcd
# @DESCRIPTION:
# Applies kernel config flags for the gvrpcd package(s)
ot-kernel-pkgflags_gvrpcd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6af1f7a]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/gvrpcd" ; then
		einfo "Applying kernel config flags for the gvrpcd package(s) (id: 6af1f7a)"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q_GVRP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hamachi
# @DESCRIPTION:
# Applies kernel config flags for hamachi
ot-kernel-pkgflags_hamachi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd871dfa]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/logmein-hamachi" ; then
		einfo "Applying kernel config flags for the hamachi package (id: d871dfa)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_haproxy
# @DESCRIPTION:
# Applies kernel config flags for haproxy
ot-kernel-pkgflags_haproxy() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5bc6d06]}" == "1" ]] && return
	if ot-kernel_has_version "net-proxy/haproxy" ; then
		einfo "Applying kernel config flags for the haproxy package (id: 5bc6d06)"
		ot-kernel_y_configopt "CONFIG_NET"

		_ot-kernel_set_net_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hd_idle
# @DESCRIPTION:
# Applies kernel config flags for the hd-idle package
ot-kernel-pkgflags_hd_idle() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc6f5c62]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/hd-idle" ; then
		einfo "Applying kernel config flags for the hd-idle package (id: c6f5c62)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hdapsd
# @DESCRIPTION:
# Applies kernel config flags for the hdapsd package
ot-kernel-pkgflags_hdapsd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2458b68]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/hdapsd" ; then
		einfo "Applying kernel config flags for the hdapsd package (id: 2458b68)"
		ot-kernel_y_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_hid_nin
# @DESCRIPTION:
# Applies kernel config flags for the hid nin controllers
ot-kernel-pkgflags_hid_nin() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1169f20]}" == "1" ]] && return
	if ot-kernel_has_version "games-util/hid-nintendo" ; then
		einfo "Applying kernel config flags for the hid nin controllers (id: 1169f20)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S714f5dd]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/htbinit" ; then
		einfo "Applying kernel config flags for the hbtinit package (id: 714f5dd)"
		ot-kernel_y_configopt "CONFIG_NET_SCH_HTB"
		ot-kernel_y_configopt "CONFIG_NET_SCH_SFQ"
		ot-kernel_y_configopt "CONFIG_NET_CLS_FW"
		ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
		ot-kernel_y_configopt "CONFIG_NET_CLS_ROUTE4"
		if ot-kernel_has_version "net-misc/htbinit[esfq]" ; then
			ot-kernel_y_configopt "CONFIG_NET_SCH_ESFQ"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_htop
# @DESCRIPTION:
# Applies kernel config flags for the htop package
ot-kernel-pkgflags_htop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S843cb8b]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/htop" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S45f5321]}" == "1" ]] && return
	if ot-kernel_has_version "net-print/hplip" ; then
		einfo "Applying kernel config flags for the hplip package (id: 45f5321)"
		# The ebuild pulls in virtual/libusb unconditionally
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
		if ot-kernel_has_version "net-print/hplip[parport]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8fa85cb]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/i2c-tools" ; then
		einfo "Applying kernel config flags for the i8kutils package (id: 8fa85cb)"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		ot-kernel_y_configopt "CONFIG_I2C_HELPER_AUTO"

		local O=$(grep -E -e "config I2C_.*" $(find drivers/i2c/busses -name "Kconfig*") \
			| cut -f 2 -d ":" \
			| sed -e "s|config ||g" \
			| sed -e "s|^|CONFIG_|g")
		local found=0
		for o in ${O[@]} ; do
			if grep -q -e "^${o}=" "${path_config}" ; then
				found=1
				break
			fi
		done
		(( ${found} == 0 )) \
			&& ewarn "You may need to have at least one CONFIG_I2C_... for i2c-tools."
	fi
}

# @FUNCTION: ot-kernel-pkgflags_i8kutils
# @DESCRIPTION:
# Applies kernel config flags for the i8kutils package
ot-kernel-pkgflags_i8kutils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sab2316b]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/i8kutils" ; then
		einfo "Applying kernel config flags for the i8kutils package (id: ab2316b)"
		ot-kernel_y_configopt "CONFIG_I8K"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ifenslave
# @DESCRIPTION:
# Applies kernel config flags for the ifenslave package
ot-kernel-pkgflags_ifenslave() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3d1462a]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/ifenslave" ; then
		einfo "Applying kernel config flags for the ifensave package (id: 3d1462a)"
		ot-kernel_y_configopt "CONFIG_BONDING"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwlmvm
# @DESCRIPTION:
# Applies kernel config flags for the iwlmvm package
ot-kernel-pkgflags_iwlmvm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc947ca0]}" == "1" ]] && return
	if \
		ot-kernel_has_version "sys-firmware/iwl3160-7260-bt-ucode" \
		|| ot-kernel_has_version "sys-firmware/iwl7260-ucode" \
		|| ot-kernel_has_version "sys-firmware/iwl8000-ucode" \
		|| ot-kernel_has_version "sys-firmware/iwl3160-ucode" \
	; then
		einfo "Applying kernel config flags for the iwl firmware package(s) (id: c947ca0)"
		ot-kernel_y_configopt "CONFIG_IWLMVM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_igmpproxy
# @DESCRIPTION:
# Applies kernel config flags for the igmpproxy package
ot-kernel-pkgflags_igmpproxy() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7464f82]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/igmpproxy" ; then
		einfo "Applying kernel config flags for the igmpproxy package (id: 7464f82)"
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ima_evm_utils
# @DESCRIPTION:
ot-kernel-pkgflags_ima_evm_utils() {
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se993bff]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/ima-evm-utils" ; then
		einfo "Applying kernel config flags for the ima-evm-utils package (id: e993bff)"
		if [[ "${EVM:-1}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_KEYS"
			ot-kernel_y_configopt "CONFIG_TRUSTED_KEYS"
			ot-kernel_y_configopt "CONFIG_ENCRYPTED_KEYS"
			ot-kernel_y_configopt "CONFIG_SECURITY"
			ot-kernel_y_configopt "CONFIG_INTEGRITY"
			ot-kernel_y_configopt "CONFIG_INTEGRITY_SIGNATURE"
			ot-kernel_y_configopt "CONFIG_EVM"
			if ot-kernel_has_version "dev-crypt/tpm-utils" \
				|| ot-kernel_has_version "app-crypt/tpm-tools" \
				|| ot-kernel_has_version "app-crypt/tpm2-tools" \
				|| [[ "${TPM:-0}" == "1" ]] ; then
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

# @FUNCTION: ot-kernel-pkgflags_incron
# @DESCRIPTION:
# Applies kernel config flags for the incron package
ot-kernel-pkgflags_incron() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2f90fde]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/incron" ; then
		einfo "Applying kernel config flags for the incron package (id: 2f90fde)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iucode
# @DESCRIPTION:
# Applies kernel config flags for the intel-microcode package
ot-kernel-pkgflags_iucode() {
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc9acc57]}" == "1" ]] && return
	if ot-kernel_has_version "sys-firmware/intel-microcode" ; then
		if [[ "${OT_KERNEL_CPU_MICROCODE}" == "1" || -e "${OT_KERNEL_CPU_MICROCODE}" ]] ; then
			einfo "Applying kernel config flags for the intel-microcode package (id: c9acc57)"

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

			if ! which iucode_tool 2>/dev/null 1>/dev/null ; then
				ewarn "Missing iucode_tool"
			elif iucode_tool ${args[@]} -l /lib/firmware/intel-ucode/* ; then
				local signatures=( $(iucode_tool ${args[@]} -l /lib/firmware/intel-ucode/* | grep -o -E -e "0x[0-9a-f]+") )
				for signature in ${signatures[@]} ; do
					#    ee     # initials hi
					#    fm fms # initials lo
					#0123456789 # bash string index
					#0x000306c3 # processor signature
					local ef=${signature:4:1}
					local f=${signature:7:1}
					local em=${signature:5:1}
					local m=${signature:8:1}
					local s=${signature:9:1}
					local fn="${ef}${f}-${em}${m}-${s}"
					[[ -e "/lib/firmware/intel-ucode/${fn}" ]] \
						|| eerror "/lib/firmware/intel-ucode/${fn} is missing"
					bucket["${fn}"]="intel-ucode/${fn}"
				done
				(( ${#signatures[@]} == 0 )) && ewarn "Found no CPU signatures"
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
					| sed -r -e "s|[ ]+| |g" \
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

# @FUNCTION: ot-kernel-pkgflags_lkrg
# @DESCRIPTION:
# Applies kernel config flags for the lkrg package
ot-kernel-pkgflags_lkrg() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S70df33c]}" == "1" ]] && return
	if ot-kernel_has_version "app-antivirus/lkrg" ; then
		einfo "Applying kernel config flags for the lkrg package (id: 70df33c)"
		ot-kernel_y_configopt "CONFIG_HAVE_KRETPROBES"
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "70df33c" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_JUMP_LABEL"
		ot-kernel_y_configopt "CONFIG_MODULE_UNLOAD"
ewarn "app-antivirus/lkrg does not like PREEMPT_RT"
		ot-kernel_set_preempt "CONFIG_PREEMPT_AUTOMAGIC"
		ban_disable_debug "70df33c"
		ot-kernel_y_configopt "CONFIG_STACKTRACE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_llvm
# @DESCRIPTION:
# Applies kernel config flags for the llvm package
ot-kernel-pkgflags_llvm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8f5a656]}" == "1" ]] && return
	if ot-kernel_has_version "sys-devel/llvm" ; then
		einfo "Applying kernel config flags for the llvm package (id: 8f5a656)"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		if ot-kernel_has_version "sys-devel/llvm[bolt]" ; then
			_ot-kernel_y_thp # for bolt --hugify
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lksctp_tools
# @DESCRIPTION:
# Applies kernel config flags for the lksctp-tools package
ot-kernel-pkgflags_lksctp_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8767e0d]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/lksctp-tools" ; then
		einfo "Applying kernel config flags for the lksctp-tools package (id: 8767e0d)"
		ot-kernel_y_configopt "CONFIG_IP_SCTP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iodine
# @DESCRIPTION:
# Applies kernel config flags for the iodine package
ot-kernel-pkgflags_iodine() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S031191b]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/iodine" ; then
		einfo "Applying kernel config flags for the iodine package (id: 031191b)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipcm
# @DESCRIPTION:
# Applies kernel config flags for ipcm
ot-kernel-pkgflags_ipcm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb50e578]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/intel-performance-counter-monitor" ; then
		einfo "Applying kernel config flags for the ipcm package (id: b50e578)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iproute2
# @DESCRIPTION:
# Applies kernel config flags for the iproute2 package
ot-kernel-pkgflags_iproute2() {
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4102555]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/iproute2" ; then  # For tc QoS
		einfo "Applying kernel config flags for the iproute2 package (id: 4102555)"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NET_INET"
		ot-kernel_y_configopt "CONFIG_IP_ADVANCED_ROUTER"
		ot-kernel_y_configopt "CONFIG_SYN_COOKIES"
		ot-kernel_set_configopt "CONFIG_IPV6" "m"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S45b1cc4]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/ipset" ; then
		einfo "Applying kernel config flags for the ipset package (id: 45b1cc4)"
		ot-kernel_y_configopt "CONFIG_NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
		ot-kernel_unset_configopt "CONFIG_PAX_CONSTIFY_PLUGIN" # old
		if ot-kernel_has_version "net-firewall/ipset[modules]" ; then
			ot-kernel_unset_configopt "CONFIG_IP_NF_SET"
			ot-kernel_unset_configopt "CONFIG_IP_SET"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ipt_netflow
# @DESCRIPTION:
# Applies kernel config flags for the ipt-netflow package
ot-kernel-pkgflags_ipt_netflow() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2544e60]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/ipt_netflow" ; then
		einfo "Applying kernel config flags for the ipt_netflow package (id: 2544e60)"
		ot-kernel_y_configopt "CONFIG_BRIDGE_NETFILTER"
		ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
		ot-kernel_y_configopt "CONFIG_VLAN_8021Q"
		if ot-kernel_has_version "net-firewall/ipt_netflow[debug]" ; then
			ban_disable_debug "2544e60"
			ot-kernel_y_configopt "CONFIG_DEBUG_FS"
			needs_debugfs "net-firewall/ipt_netflow[debug]" "2544e60"
		fi
		if ot-kernel_has_version "net-firewall/ipt_netflow[natevents]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S351365c]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/iptables" ; then
		einfo "Applying kernel config flags for the iptables package (id: 351365c)"
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
			ban_disable_debug "351365c" "NETFILTER"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Saf7106d]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/iotop" \
		|| ot-kernel_has_version "sys-process/iotop-c" ; then
		einfo "Applying kernel config flags for the iotop package (id: af7106d)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S115a3c8]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/irqbalance" ; then
		einfo "Applying kernel config flags for the irqbalance package (id: 115a3c8)"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_isatapd
# @DESCRIPTION:
# Applies kernel config flags for the isatapd package
ot-kernel-pkgflags_isatapd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sfa75afb]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/isatapd" ; then
		einfo "Applying kernel config flags for the isatapd package (id: fa75afb)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jack_audio_connection_kit
# @DESCRIPTION:
# Applies kernel config flags for the jack-audio-connection-kit package
ot-kernel-pkgflags_jack_audio_connection_kit() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa4243ca]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/jack-audio-connection-kit" ; then
		einfo "Applying kernel config flags for the jack-audio-connection-kit package (id: a4243ca)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jack2
# @DESCRIPTION:
# Applies kernel config flags for the jack2 package
ot-kernel-pkgflags_jack2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7c60608]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/jack2" ; then
		einfo "Applying kernel config flags for the jack2 package (id: 7c60608)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_jemalloc
# @DESCRIPTION:
# Applies kernel config flags for the jemalloc package
ot-kernel-pkgflags_jemalloc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8cc11b9]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/jemalloc" ; then
		einfo "Applying kernel config flags for the jemalloc package (id: 8cc11b9)"
		_ot-kernel_y_thp # Supported but not on by default.
	fi
}

# @FUNCTION: ot-kernel-pkgflags_joycond
# @DESCRIPTION:
# Applies kernel config flags for the joycond package
ot-kernel-pkgflags_joycond() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5c83d42]}" == "1" ]] && return
	if ot-kernel_has_version "games-util/joycond" ; then
		einfo "Applying kernel config flags for the joycond package (id: 5c83d42)"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_NINTENDO"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_k3s
# @DESCRIPTION:
# Applies kernel config flags for the k3s package
ot-kernel-pkgflags_k3s() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2fd0506]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/k3s" ; then
		einfo "Applying kernel config flags for the k3s package (id: 2fd0506)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S06561a4]}" == "1" ]] && return
	if ot-kernel_has_version "media-gfx/iscan-plugin-network-nt" ; then
		einfo "Applying kernel config flags for the iscan-plugin package (id: 06561a4)"
		ot-kernel_y_configopt "CONFIG_SYN_COOKIES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_iwd
# @DESCRIPTION:
# Applies kernel config flags for the iwd package
ot-kernel-pkgflags_iwd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc4eefdd]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/iwd" ; then
		einfo "Applying kernel config flags for the iwd package (id: c4eefdd)"
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

		if ot-kernel_has_version "net-wireless/iwd[crda]" ; then
			: # See ot-kernel-pkgflags_crda
			ot-kernel_has_version "net-wireless/crda" || die "Install net-wireless/crda first"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.20" ; then
			# Implied ot-kernel_has_version "net-wireless/iwd[linux_kernel]"
			ot-kernel_y_configopt "CONFIG_PKCS8_PRIVATE_KEY_PARSER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kexec_tools
# @DESCRIPTION:
# Applies kernel config flags for the kexec-tools package
ot-kernel-pkgflags_kexec_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S39aeb63]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/kexec-tools" ; then
		OT_KERNEL_SIGN="${OT_KERNEL_SIGN_KERNEL:-0}" # signing the kernel is not ready yet
		if [[ "${OT_KERNEL_SIGN_KERNEL}" =~ ("uefi"|"efi"|"kexec") && -n "${OT_KERNEL_PRIVATE_KEY}" && -n "${OT_KERNEL_PUBLIC_KEY}" ]] ; then
			einfo "Applying kernel config flags for the kexec-tools package for signed kernels (id: 39aeb63)"
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
		einfo "Applying kernel config flags for the kexec-tools package for unsigned kernels (id: 39aeb63)"
		ot-kernel_y_configopt "CONFIG_KEXEC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_keyutils
# @DESCRIPTION:
# Applies kernel config flags for the keyutils package
ot-kernel-pkgflags_keyutils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2082e35]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/keyutils" ; then
		einfo "Applying kernel config flags for the keyutils package (id: 2082e35)"
		ot-kernel_y_configopt "CONFIG_KEYS"
		if ot-kernel_has_version "sys-apps/keyutils[test]" \
			&& ver_test "${MY_PV}" -ge "2.6.10" \
			&& ver_test "${KV_MAJOR_MINOR}" -lt "4.0" ; then
			ban_disable_debug "2082e35"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S70d6e85]}" == "1" ]] && return
	if ot-kernel_has_version "kde-misc/kio-fuse" ; then
		einfo "Applying kernel config flags for the kio-fuse package (id: 70d6e85)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_knem
# @DESCRIPTION:
# Applies kernel config flags for the knem package
ot-kernel-pkgflags_knem() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4fb8de2]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/knem" ; then
		einfo "Applying kernel config flags for the knem package (id: 4fb8de2)"
		ot-kernel_y_configopt "CONFIG_DMA_ENGINE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kodi
# @DESCRIPTION:
# Applies kernel config flags for the kodi package
ot-kernel-pkgflags_kodi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S70fdec1]}" == "1" ]] && return
	if ot-kernel_has_version "media-tv/kodi" ; then
		einfo "Applying kernel config flags for the kodi package (id: 70fdec1)"
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_kpatch
# @DESCRIPTION:
# Applies kernel config flags for the kpatch package
ot-kernel-pkgflags_kpatch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd26d135]}" == "1" ]] && return
	if ot-kernel_has_version "sys-kernel/kpatch" ; then
		einfo "Applying kernel config flags for the kpatch package (id: d26d135)"
		ban_disable_debug "d26d135"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
		ot-kernel_y_configopt "CONFIG_HAVE_FENTRY"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_DEBUG_KERNEL"
		ban_dma_attack "d26d135" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS_ALL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ksmbd_tools
# @DESCRIPTION:
# Applies kernel config flags for the ksmbd-tools package
ot-kernel-pkgflags_ksmbd_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3dd8506]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/ksmbd-tools" ; then
		einfo "Applying kernel config flags for the ksmbd-tools package (id: 3dd8506)"
		ot-kernel_y_configopt "CONFIG_SMB_SERVER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libfido2
# @DESCRIPTION:
# Applies kernel config flags for the libfido2 package
ot-kernel-pkgflags_libfido2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4130caa]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/libfido2" ; then
		einfo "Applying kernel config flags for the libfido2 package (id: 4130caa)"
		ot-kernel_y_configopt "CONFIG_USB_HID"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libmtp
# @DESCRIPTION:
# Applies kernel config flags for the libmtp package
ot-kernel-pkgflags_libmtp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sca6ee71]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/libmtp" ; then
		einfo "Applying kernel config flags for the libmtp package (id: ca6ee71)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcxx
# @DESCRIPTION:
# Applies kernel config flags for the libcxx package
ot-kernel-pkgflags_libcxx() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2c54027]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/libcxx" ; then
		einfo "Applying kernel config flags for the libcxx package (id: 2c54027)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcxxabi
# @DESCRIPTION:
# Applies kernel config flags for the libcxxabi package
ot-kernel-pkgflags_libcxxabi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3e507a4]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/libcxxabi" ; then
		einfo "Applying kernel config flags for the libcxxabi package (id: 3e507a4)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libcgroup
# @DESCRIPTION:
# Applies kernel config flags for the libcgroup package
ot-kernel-pkgflags_libcgroup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sfe830d2]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/libcgroup" ; then
		einfo "Applying kernel config flags for the libcgroup package (id: fe830d2)"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		if ot-kernel_has_version "media-libs/libcgroup[daemon]" ; then
			ot-kernel_y_configopt "CONFIG_CONNECTOR"
			ot-kernel_y_configopt "CONFIG_PROC_EVENTS"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_atm
# @DESCRIPTION:
# Applies kernel config flags for the linux-atm package
ot-kernel-pkgflags_linux_atm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6df59e4]}" == "1" ]] && return
	if ot-kernel_has_version "net-dialup/linux-atm" ; then
		einfo "Applying kernel config flags for the linux-atm package (id: 6df59e4)"
		ot-kernel_y_configopt "CONFIG_ATM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_enable_ir_emitter
# @DESCRIPTION:
# Applies kernel config flags for the linux-enable-ir-emitter package
ot-kernel-pkgflags_linux_enable_ir_emitter() {
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa3e323a]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/linux-enable-ir-emitter" ; then
		einfo "Applying kernel config flags for the media-video/linux-enable-ir-emitter package (id: a3e323a)"
		# Assumes udev, ^^ ( openrc systemd ) kernel config has been already applied.
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_firmware
# @DESCRIPTION:
# Applies kernel config flags for the linux-firmware package
ot-kernel-pkgflags_linux_firmware() {
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4e8e0af]}" == "1" ]] && return
	if ot-kernel_has_version "sys-kernel/linux-firmware" ; then
		if [[ "${OT_KERNEL_CPU_MICROCODE}" == "1" || -e "${OT_KERNEL_CPU_MICROCODE}" ]] ; then
			einfo "Applying kernel config flags for the linux-firmware package (id: 4e8e0af)"
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
eerror "You must set OT_KERNEL_CPU_MICROCODE.  See metadata.xml for details."
eerror
					die
				fi
			fi
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
				if [[ "${cpu_family}" =~ (16|17|18|20) ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd.bin"
				elif [[ "${cpu_family}" =~ 21 ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam15h.bin"
				elif [[ "${cpu_family}" =~ 22 ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam16h.bin"
				elif [[ "${cpu_family}" =~ 23 && "${cpu_model_name}" =~ "zen" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam17h.bin"
				elif [[ "${cpu_family}" =~ "EPYC 7"..1 ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam17h_model0xh.sbin"
				elif [[ "${cpu_family}" =~ "EPYC 7"..2 ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam17h_model3xh.sbin"
				elif [[ "${cpu_family}" =~ 25 && "${cpu_model_name}" =~ "zen" ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd-ucode/microcode_amd_fam19h.bin"
				elif [[ "${cpu_family}" =~ "EPYC 7"..3 ]] ; then
					bucket["${cpu_family}:${cpu_model_name}"]="amd/amd_sev_fam19h_model0xh.sbin"
				fi
			done
			IFS=$' \t\n'
			if [[ -n "${bucket[@]}" ]] ; then
				local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" \
					| head -n 1 \
					| cut -f 2 -d "\"")
				firmware=$(echo "${firmware}" \
					| tr " " "\n" \
					| sed -r \
						-e 's|amd-ucode/microcode.*$||g' \
						-e 's|amd/amd_sev_fam..h_model.xh.sbin$||g' \
					| tr "\n" " ") # dedupe
				firmware="${firmware} ${bucket[@]}" # Dump microcode relpaths
				firmware=$(echo "${firmware}" \
					| sed -r \
						-e "s|[ ]+| |g" \
						-e "s|^[ ]+||g" \
						-e 's|[ ]+$||g') # Trim mid/left/right spaces
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
						| cut -f 2 -d "\"")
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd543959]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/linuxptp" ; then
		einfo "Applying kernel config flags for the linuxptp package (id: d543959)"
		ot-kernel_y_configopt "CONFIG_PPS"
		ot-kernel_y_configopt "CONFIG_NETWORK_PHY_TIMESTAMPING"
		ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnftnl
# @DESCRIPTION:
# Applies kernel config flags for the libnftnl package
ot-kernel-pkgflags_libnftnl() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S65c6821]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnftnl" ; then
		einfo "Applying kernel config flags for the libnftnl package (id: 65c6821)"
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnfnetlink
# @DESCRIPTION:
# Applies kernel config flags for the libnfnetlink package
ot-kernel-pkgflags_libnfnetlink() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S731aa2e]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnfnetlink" ; then
		einfo "Applying kernel config flags for the libnfnetlink package (id: 731aa2e)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scc408fd]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_acct" ; then
		einfo "Applying kernel config flags for the libnetfilter_acct package (id: cc408fd)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_cthelper
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_cthelper package
ot-kernel-pkgflags_libnetfilter_cthelper() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S563a05c]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_cthelper" ; then
		einfo "Applying kernel config flags for the libnetfilter_cthelper package (id: 563a05c)"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_HELPER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_conntrack package
ot-kernel-pkgflags_libnetfilter_conntrack() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2616787]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_conntrack" ; then
		einfo "Applying kernel config flags for the libnetfilter_conntrack package (id: 2616787)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7cab068]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_cttimeout" ; then
		einfo "Applying kernel config flags for the libnetfilter_cttimeout package (id: 7cab068)"
		ot-kernel_y_configopt "CONFIG_NF_CT_NETLINK_TIMEOUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_log
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_log package
ot-kernel-pkgflags_libnetfilter_log() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0359211]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_log" ; then
		einfo "Applying kernel config flags for the libnetfilter_log package (id: 0359211)"
		ban_disable_debug "0359211" "NETFILTER"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_LOG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libnetfilter_queue
# @DESCRIPTION:
# Applies kernel config flags for the libnetfilter_queue package
ot-kernel-pkgflags_libnetfilter_queue() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scd31a5e]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/libnetfilter_queue" ; then
		einfo "Applying kernel config flags for the libnetfilter_queue package (id: cd31a5e)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_QUEUE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libomp
# @DESCRIPTION:
# Applies kernel config flags for the libomp package
ot-kernel-pkgflags_libomp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S90741ba]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/libomp" ; then
		einfo "Applying kernel config flags for the libomp package (id: 90741ba)"
		if [[ "${cpu_sched}" =~ ("pds"|"prjc-pds") ]] ; then
			ewarn "Detected use of the PDS scheduler."
			ewarn "Severe performance degration with libomp is expected with the PDS scheduler. (id: 90741ba)"
			ewarn "If performance degradion is unacceptable, disable the PDS scheduler."
		fi
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libpulse
# @DESCRIPTION:
# Applies kernel config flags for the libpulse package
ot-kernel-pkgflags_libpulse() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdb14cb5]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/libpulse" ; then
		einfo "Applying kernel config flags for the libpulse package (id: db14cb5)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libsdl2
# @DESCRIPTION:
# Applies kernel config flags for the libsdl2 package
ot-kernel-pkgflags_libsdl2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6f67af3]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/libsdl2" \
		|| ot-kernel_has_version "dev-libs/hidapi" ; then
		einfo "Applying kernel config flags for the libsdl2 / hidapi package(s) (id: 6f67af3)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9bb3f42]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/libteam" ; then
		einfo "Applying kernel config flags for the libteam package (id: 9bb3f42)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5513bd3]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/libu2f-host" ; then
		einfo "Applying kernel config flags for the libu2f-host package (id: 5513bd3)"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libugpio
# @DESCRIPTION:
# Applies kernel config flags for the libugpio package
ot-kernel-pkgflags_libugpio() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdd45062]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/libugpio" ; then
		einfo "Applying kernel config flags for the libv4l package (id: dd45062)"
		ot-kernel_y_configopt "CONFIG_GPIO_SYSFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libv4l
# @DESCRIPTION:
# Applies kernel config flags for the libv4l package
ot-kernel-pkgflags_libv4l() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4b528f3]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/libv4l" ; then
		einfo "Applying kernel config flags for the libv4l package (id: 4b528f3)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_libvirt
# @DESCRIPTION:
# Applies kernel config flags for the libvirt package
ot-kernel-pkgflags_libvirt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7953656]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/libvirt" ; then
		einfo "Applying kernel config flags for the libvirt package (id: 7953656)"

		if ot-kernel_has_version "app-emulation/libvirt[lvm]" ; then
			ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
			ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
			ot-kernel_y_configopt "CONFIG_DM_SNAPSHOT"
		fi

		if ot-kernel_has_version "app-emulation/libvirt[lxc]" ; then
			# See also ot-kernel-pkgflags_lxc
			ot-kernel_y_configopt "CONFIG_CGROUPS"
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_BLK_CGROUP"
			ot-kernel_y_configopt "CONFIG_CGROUP_NET_PRIO"
			ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
			ot-kernel_y_configopt "CONFIG_CGROUP_PERF"
			ot-kernel_y_configopt "CONFIG_NET_CLS_CGROUP"
			ot-kernel_y_configopt "CONFIG_SECURITYFS"
			if ver_test "${KV_MAJOR_MINOR}" -lt "4.7" ; then
				ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
				ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
			fi
		fi


		if ot-kernel_has_version "app-emulation/libvirt[virt-network]" ; then
			ot-kernel_y_configopt "CONFIG_NET"
			ot-kernel_y_configopt "CONFIG_INET"

			ot-kernel_y_configopt "CONFIG_NETFILTER"
			ot-kernel_y_configopt "CONFIG_IP_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
			ot-kernel_y_configopt "CONFIG_IP_NF_MANGLE"

			ot-kernel_y_configopt "CONFIG_IPV6"
			ot-kernel_y_configopt "CONFIG_IP6_NF_IPTABLES"
			ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_REJECT"
			ot-kernel_y_configopt "CONFIG_IP6_NF_MANGLE"
			ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"

			ot-kernel_y_configopt "CONFIG_BRIDGE"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XTABLES"

			ot-kernel_y_configopt "CONFIG_NETFILTER_ADVANCED"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_CONNMARK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MARK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_CONNTRACK"
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_CHECKSUM"
			ot-kernel_y_configopt "CONFIG_IP6_NF_NAT"

			ot-kernel_y_configopt "CONFIG_BRIDGE_NF_EBTABLES"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_T_NAT"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_MARK"
			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_MARK_T"

			ot-kernel_y_configopt "CONFIG_BRIDGE_EBT_T_NAT"
			ot-kernel_y_configopt "CONFIG_NET_ACT_POLICE" # Traffic Policing
			ot-kernel_y_configopt "CONFIG_NET_CLS_FW"
			ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
			ot-kernel_y_configopt "CONFIG_NET_SCH_HTB"
			ot-kernel_y_configopt "CONFIG_NET_SCH_INGRESS"
			ot-kernel_y_configopt "CONFIG_NET_SCH_SFQ"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se64272e]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/likwid" ; then
		einfo "Applying kernel config flags for the likwid package (id: e64272e)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lightdm
# @DESCRIPTION:
# Applies kernel config flags for the lightdm package
ot-kernel-pkgflags_lightdm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S973ff0e]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/lightdm" ; then
		einfo "Applying kernel config flags for the lightdm package (id: 973ff0e)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_linux_smaps
# @DESCRIPTION:
# Applies kernel config flags for the Linux-Smaps package
ot-kernel-pkgflags_linux_smaps() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se76e66e]}" == "1" ]] && return
	if ot-kernel_has_version "dev-perl/Linux-Smaps" ; then
		einfo "Applying kernel config flags for the Linux-Smaps package (id: e76e66e)"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PROC_PAGE_MONITOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lirc
# @DESCRIPTION:
# Applies kernel config flags for the lirc package
ot-kernel-pkgflags_lirc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1f8b392]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/lirc" ; then
		einfo "Applying kernel config flags for the lirc package (id: 1f8b392)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lm_sensors
# @DESCRIPTION:
# Applies kernel config flags for the lm-sensors package
ot-kernel-pkgflags_lm_sensors() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Saef80f1]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/lm-sensors" ; then
		einfo "Applying kernel config flags for the lm-sensors package (id: aef80f1)"
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

		if [[ "${LM_SENSORS_MODULES:-0}" == "1" ]] ; then
			einfo "Adding referenced modules for the lm-sensors package."
			# Slice sections of the file and extract options
			local sidx1=$(grep -n "PC SMBus host controller drivers" drivers/i2c/busses/Kconfig | cut -f 1 -d ":")
			local eidx1=$(grep -n "if ACPI" drivers/i2c/busses/Kconfig | cut -f 1 -d ":")
			local sidx2=$(grep -n "Other I2C/SMBus bus drivers" drivers/i2c/busses/Kconfig | cut -f 1 -d ":")
			local eidx2=$(wc -l drivers/i2c/busses/Kconfig | cut -f 1 -d " ")
			# Module options for sensors, i2c, smbus
			local OPTS=(
				$(sed -n ${sidx1},${eidx1}p drivers/i2c/busses/Kconfig \
					| grep "config " \
					| cut -f 2 -d " " \
					| sed -e "s|^|CONFIG_|g")
				$(sed -n ${sidx2},${eidx2}p drivers/i2c/busses/Kconfig \
					| grep "config " \
					| cut -f 2 -d " " \
					| sed -e "s|^|CONFIG_|g")
				$(grep -e "config SENSORS" drivers/hwmon/Kconfig \
					| cut -f 2 -d " " \
					| sed -e "s|^|CONFIG_|g")
			)
			local o
			for o in ${OPTS[@]} ; do
				ot-kernel_set_configopt "${o}" "m"
			done

			local NOT_TRISTATE=(
				CONFIG_SENSORS_W83795_FANCTRL
				CONFIG_SENSORS_BT1_PVT_ALARMS
				CONFIG_SENSORS_LTQ_CPUTEMP
				CONFIG_SENSORS_S3C_RAW
			)

			local o
			for o in ${NOT_TRISTATE[@]} ; do
				ot-kernel_y_configopt "${o}"
			done
		fi


		local O=$(grep -E -e "config SENSORS_.*" $(find drivers/hwmon -name "Kconfig*") \
			| cut -f 2 -d ":" \
			| sed -e "s|config ||g" \
			| sed -e "s|^|CONFIG_|g")
		local found=0
		for o in ${O[@]} ; do
			if grep -q -e "^${o}=" "${path_config}" ; then
				found=1
				break
			fi
		done
		(( ${found} == 0 )) \
			&& ewarn "You may need to have at least one CONFIG_SENSOR_... for lm-sensors."
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lmms
# @DESCRIPTION:
# Applies kernel config flags for the lmms package
ot-kernel-pkgflags_lmms() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se8ebc69]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/lmms" ; then
		einfo "Applying kernel config flags for the lmms package (id: e8ebc69)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_longrun
# @DESCRIPTION:
# Applies kernel config flags for the longrun package
ot-kernel-pkgflags_longrun() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17c1e45]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/longrun" ; then
		einfo "Applying kernel config flags for the longrun package (id: 17c1e45)"
		ot-kernel_unset_configopt "CONFIG_X86_MSR"
		ot-kernel_unset_configopt "CONFIG_X86_CPUID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_loopaes
# @DESCRIPTION:
# Applies kernel config flags for the loopaes package
ot-kernel-pkgflags_loopaes() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbba669f]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/loop-aes" ; then
		einfo "Applying kernel config flags for the loop-aes package (id: bba669f)"
		ot-kernel_unset_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lttng_modules
# @DESCRIPTION:
# Applies kernel config flags for the lttng-modules package
ot-kernel-pkgflags_lttng_modules() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S18dd1d9]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/lttng-modules" ; then
		einfo "Applying kernel config flags for the lttng-modules package (id: 18dd1d9)"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ban_dma_attack "18dd1d9" "CONFIG_KALLSYMS"
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

# @FUNCTION: ot-kernel-pkgflags_lttng_ust
# @DESCRIPTION:
# Applies kernel config flags for the lttng-ust package
ot-kernel-pkgflags_lttng_ust() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S06a36a9]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/lttng-ust" ; then
		einfo "Applying kernel config flags for the lttng-ust package (id: 06a36a9)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lvm2
# @DESCRIPTION:
# Applies kernel config flags for the lvm2 package
ot-kernel-pkgflags_lvm2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S48609ad]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/lvm2" ; then
		einfo "Applying kernel config flags for the lvm2 package (id: 48609ad)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		if ot-kernel_has_version "sys-fs/lvm2[udev]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7e097b4]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/lxc" ; then
		einfo "Applying kernel config flags for the lxc package (id: 7e097b4)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scf50245]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/lxd" ; then
		einfo "Applying kernel config flags for the lxd package (id: cf50245)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S90eb5cb]}" == "1" ]] && return
	if ot-kernel_has_version "lxde-base/lxdm" ; then
		einfo "Applying kernel config flags for the lxdm package (id: 90eb5cb)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_lxqt_sudo
# @DESCRIPTION:
# Applies kernel config flags for the lxqt-sudo package
ot-kernel-pkgflags_lxqt_sudo() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scd536cf]}" == "1" ]] && return
	if ot-kernel_has_version "lxqt-base/lxqt-sudo" ; then
		einfo "Applying kernel config flags for the lxqt-sudo package (id: cd536cf)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_madwimax
# @DESCRIPTION:
# Applies kernel config flags for the madwimax package
ot-kernel-pkgflags_madwimax() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6f56e53]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/madwimax" ; then
		einfo "Applying kernel config flags for the madwimax package (id: 6f56e53)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mahimahi
# @DESCRIPTION:
# Applies kernel config flags for the mahimahi package
ot-kernel-pkgflags_mahimahi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se1f96ab]}" == "1" ]] && return
	if ot-kernel_has_version "www-misc/mahimahi" ; then
		einfo "Applying kernel config flags for the mahimahi package (id: e1f96ab)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_INET"

		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_CORE"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_TUN"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mariadb
# @DESCRIPTION:
# Applies kernel config flags for the mariadb package
ot-kernel-pkgflags_mariadb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1216e49]}" == "1" ]] && return
	if ot-kernel_has_version "dev-db/mariadb" ; then
		einfo "Applying kernel config flags for the mariadb package (id: 1216e49)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mbpfan
# @DESCRIPTION:
# Applies kernel config flags for the mbpfan package
ot-kernel-pkgflags_mbpfan() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb9f381e]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/mbpfan" ; then
		einfo "Applying kernel config flags for the mbpfan package (id: b9f381e)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3683419]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/mcelog" ; then
		einfo "Applying kernel config flags for the mcelog package (id: 3683419)"
		ot-kernel_y_configopt "CONFIG_X86_MCE"
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.12" ; then
			ban_disable_debug "3683419"
			ot-kernel_y_configopt "CONFIG_X86_MCELOG_LEGACY"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mcproxy
# @DESCRIPTION:
# Applies kernel config flags for the mcproxy package
ot-kernel-pkgflags_mcproxy() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb648130]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/mcproxy" ; then
		einfo "Applying kernel config flags for the mcproxy package (id: b648130)"
		ot-kernel_y_configopt "CONFIG_IP_MULTICAST"
		ot-kernel_y_configopt "CONFIG_IP_MROUTE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mdadm
# @DESCRIPTION:
# Applies kernel config flags for the mdadm package
ot-kernel-pkgflags_mdadm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2c79f42]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/mdadm" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb184220]}" == "1" ]] && return
	if \
		[[ "${ALSA_MIDI}" == "1" ]] \
		|| _ot-kernel-pkgflags_has_midi \
	; then
		einfo "Applying kernel config flags for midi support (id: b184220)"
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

# @FUNCTION: ot-kernel-pkgflags_mesa
# @DESCRIPTION:
# Applies kernel config flags for the mesa package
ot-kernel-pkgflags_mesa() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa7c616c]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/mesa" ; then
		einfo "Applying kernel config flags for the mesa package (id: a7c616c)"
		if ver_test "${KV_MAJOR_MINOR}" -ge "5" ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		else
			ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
		fi
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		if ot-kernel_has_version "media-libs/mesa[vulkan,video_cards_radeonsi]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
		if ot-kernel_has_version "media-libs/mesa[video_cards_vmware]" ; then
			ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
			_ot-kernel_y_thp # See 8afe12b2
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mesa_amber
# @DESCRIPTION:
# Applies kernel config flags for the mesa-amber package
ot-kernel-pkgflags_mesa_amber() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S58b098b]}" == "1" ]] && return
	if ot-kernel_has_version "media-libs/mesa-amber" ; then
		einfo "Applying kernel config flags for the mesa-amber package (id: 58b098b)"
		ot-kernel_y_configopt "CONFIG_KCMP"
		ot-kernel_y_configopt "CONFIG_CHECKPOINT_RESTORE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_minidlna
# @DESCRIPTION:
# Applies kernel config flags for the minidlna package
ot-kernel-pkgflags_minidlna() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se282260]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/minidlna" ; then
		einfo "Applying kernel config flags for the minidlna package (id: e282260)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_minijail
# @DESCRIPTION:
# Applies kernel config flags for the minijail package
ot-kernel-pkgflags_minijail() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S792b443]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/minijail" ; then
		einfo "Applying kernel config flags for the minijail package (id: 792b443)"

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		_ot-kernel_set_uts_ns

		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mono
# @DESCRIPTION:
# Applies kernel config flags for the mono package
ot-kernel-pkgflags_mono() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8c7d25b]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/mono" ; then
		einfo "Applying kernel config flags for the mono package (id: 8c7d25b)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S74673fe]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/mpd[eventfd]" ; then
		einfo "Applying kernel config flags for the mpd package (id: 74673fe)"
		if ot-kernel_has_version "media-sound/mpd[eventfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_EVENTFD"
		fi
		if ot-kernel_has_version "media-sound/mpd[signalfd]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_SIGNALFD"
		fi
		if ot-kernel_has_version "media-sound/mpd[inotify]" ; then
			ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mpg123
# @DESCRIPTION:
# Applies kernel config flags for the mpg123 package
ot-kernel-pkgflags_mpg123() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0f9fa80]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/mpg123" ; then
		einfo "Applying kernel config flags for the mpg123 package (id: 0f9fa80)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mplayer
# @DESCRIPTION:
# Applies kernel config flags for the mplayer package
ot-kernel-pkgflags_mplayer() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S457e322]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/mplayer" ; then
		einfo "Applying kernel config flags for the mplayer package (id: 457e322)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
	# LDT referenced and dated 2004 for older glibcs
}

# @FUNCTION: ot-kernel-pkgflags_mpm_itk
# @DESCRIPTION:
# Applies kernel config flags for the mpm_itk package
ot-kernel-pkgflags_mpm_itk() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc76089a]}" == "1" ]] && return
	if ot-kernel_has_version "www-apache/mpm_itk" ; then
		einfo "Applying kernel config flags for the mpm_itk package (id: c76089a)"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mptcpd
# @DESCRIPTION:
# Applies kernel config flags for the mptcpd package
ot-kernel-pkgflags_mptcpd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc69e109]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/mptcpd" ; then
		einfo "Applying kernel config flags for the mptcpd package (id: c69e109)"
		ot-kernel_y_configopt "CONFIG_MPTCP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mpv
# @DESCRIPTION:
# Applies kernel config flags for the mpv package
ot-kernel-pkgflags_mpv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sfdeb27b]}" == "1" ]] && return
	if \
		ot-kernel_has_version "media-video/mpv[X]" \
		|| ot-kernel_has_version "media-video/mpv[xv]" \
		; then
		einfo "Applying kernel config flags for the mpv package (id: fdeb27b)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_msr_tools
# @DESCRIPTION:
# Applies kernel config flags for the msr-tools package
ot-kernel-pkgflags_msr_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S222a4a5]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/msr-tools" ; then
		einfo "Applying kernel config flags for the msr-tools package (id: 222a4a5)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_mswatch
# @DESCRIPTION:
# Applies kernel config flags for the mswatch package
ot-kernel-pkgflags_mswatch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17b4fad]}" == "1" ]] && return
	if ot-kernel_has_version "net-mail/mswatch" ; then
		einfo "Applying kernel config flags for the mswatch package (id: 17b4fad)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_multipath_tools
# @DESCRIPTION:
# Applies kernel config flags for the multipath-tools package
ot-kernel-pkgflags_multipath_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S18a1928]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/multipath-tools" ; then
		einfo "Applying kernel config flags for the multipath-tools package (id: 18a1928)"
		ot-kernel_y_configopt "CONFIG_DM_MULTIPATH"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_networkmanager
# @DESCRIPTION:
# Applies kernel config flags for the networkmanager package
ot-kernel-pkgflags_networkmanager() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf8aec8c]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/networkmanager" ; then
		einfo "Applying kernel config flags for the networkmanager package (id: f8aec8c)"
		if ot-kernel_has_version "net-misc/networkmanager[connection-sharing]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S32191c8]}" == "1" ]] && return
	if ot-kernel_has_version "sys-libs/musl" ; then
		einfo "Applying kernel config flags for the musl package (id: 32191c8)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb150cb7]}" == "1" ]] && return
	if ot-kernel_has_version "dev-db/mysql" ; then
		einfo "Applying kernel config flags for the mysql package (id: b150cb7)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		if ot-kernel_has_version "dev-db/mysql[numa]" ; then
			ot-kernel_y_configopt "CONFIG_NUMA"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nbfc
# @DESCRIPTION:
# Applies kernel config flags for the nbfc package
ot-kernel-pkgflags_nbfc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0ff68ed]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/nbfc-linux" ; then
		einfo "Applying kernel config flags for the nbfc package (id: 0ff68ed)"
		ban_disable_debug "0ff68ed"
		ot-kernel_y_configopt "CONFIG_ACPI_EC_DEBUGFS"
		ot-kernel_y_configopt "CONFIG_HWMON"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nemu
# @DESCRIPTION:
# Applies kernel config flags for the nemu package
ot-kernel-pkgflags_nemu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S04da78e]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/nemu" ; then
		einfo "Applying kernel config flags for the nemu package (id: 04da78e)"
		ot-kernel_y_configopt "CONFIG_VETH"
		ot-kernel_y_configopt "CONFIG_MACVTAP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nfacct
# @DESCRIPTION:
# Applies kernel config flags for the nfacct package
ot-kernel-pkgflags_nfacct() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbaddb97]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/nfacct" ; then
		einfo "Applying kernel config flags for the nfacct package (id: baddb97)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK_ACCT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nfs_utils
# @DESCRIPTION:
# Applies kernel config flags for the nfs-utils package
ot-kernel-pkgflags_nfs_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa06f942]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/nfs-utils" ; then
		einfo "Applying kernel config flags for the nfs-utils package (id: a06f942)"
		if ot-kernel_has_version "net-fs/nfs-utils[nfsv4,-nfsdcld]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S70aa284]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/nftables" \
		&& ver_test "${KV_MAJOR_MINOR}" -ge "3.13" ; then
		einfo "Applying kernel config flags for the nftables package (id: 70aa284)"
		ot-kernel_y_configopt "CONFIG_NF_TABLES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nilfs_utils
# @DESCRIPTION:
# Applies kernel config flags for the nilfs-utils package
ot-kernel-pkgflags_nilfs_utils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S908989f]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/nilfs-utils" ; then
		einfo "Applying kernel config flags for the nilfs-utils package (id: 908989f)"
		_ot-kernel_set_posix_mqueue
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nodejs
# @DESCRIPTION:
# Applies kernel config flags for the nodejs package
ot-kernel-pkgflags_nodejs() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S21e5d87]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/nodejs" ; then
		einfo "Applying kernel config flags for the nodejs package (id: 21e5d87)"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		_ot-kernel_y_thp # See issue 16198
		if ot-kernel_has_version "net-libs/nodejs[-system-ssl]" ; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_AIO"
		fi

		if [[ "${arch}" =~ "ppc" ]]; then
			ot-kernel_y_configopt "CONFIG_EXPERT"
			ot-kernel_y_configopt "CONFIG_SHMEM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nftlb
# @DESCRIPTION:
# Applies kernel config flags for the nftlb package
ot-kernel-pkgflags_nftlb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd509fc7]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/nftlb" ; then
		einfo "Applying kernel config flags for the nftlb package (id: d509fc7)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se2ca215]}" == "1" ]] && return
	if ot-kernel_has_version "www-servers/nginx" ; then
		einfo "Applying kernel config flags for the nginx package (id: e2ca215)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sed423cb]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/ntfs3g" ; then
		einfo "Applying kernel config flags for the ntfs3g package (id: ed423cb)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nstx
# @DESCRIPTION:
# Applies kernel config flags for the nstx package
ot-kernel-pkgflags_nstx() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5741385]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/nstx" ; then
		einfo "Applying kernel config flags for the nstx package (id: 5741385)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_numad
# @DESCRIPTION:
# Applies kernel config flags for the numad package
ot-kernel-pkgflags_numad() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4113a11]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/numad" ; then
		einfo "Applying kernel config flags for the numad package (id: 4113a11)"
		ot-kernel_y_configopt "CONFIG_NUMA"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_tty_fallback
# @DESCRIPTION:
# Adds a video driver for TTY as the fallback to binary GPU drivers.
_ot-kernel-pkgflags_tty_fallback() {
	if [[ "${TTY_DRIVER}" == "efi" ]] \
		&& [[ "${arch}" != "ia64" ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_set_configopt "CONFIG_FB_EFI" "y"
		ot-kernel_unset_configopt "CONFIG_FB_SIMPLE"
	elif [[ "${TTY_DRIVER}" == "simple" ]] \
		&& ver_test "${MY_PV}" -lt "5.8.13" ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_set_configopt "CONFIG_FB_SIMPLE" "m"
		ot-kernel_unset_configopt "CONFIG_DRM_SIMPLEDRM"
	elif [[ "${TTY_DRIVER}" == "vesa" \
		&& "${arch}" =~ ("x86") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_set_configopt "CONFIG_FB_VESA" "y"
		ot-kernel_unset_configopt "CONFIG_FB_SIMPLE"
	elif [[ "${TTY_DRIVER}" =~ ("headless"|"none") ]] ; then
		ot-kernel_unset_configopt "CONFIG_FB_EFI"
		ot-kernel_unset_configopt "CONFIG_FB_SIMPLE"
		ot-kernel_unset_configopt "CONFIG_FB_VESA"
	else
eerror
eerror "You must choose one of the following:"
eerror
eerror "  TTY_DRIVER=efi"
eerror "  TTY_DRIVER=simple    ${message}"
eerror "  TTY_DRIVER=vesa"
eerror "  TTY_DRIVER=headless"
eerror "  TTY_DRIVER=none"
eerror
		die
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nv
# @DESCRIPTION:
# Applies kernel config flags for the nv driver
ot-kernel-pkgflags_nv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf314ac3]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/nvidia-drivers" ; then
		einfo "Applying kernel config flags for the nv driver (id: f314ac3)"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_AMD64"
		fi
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_unset_configopt "CONFIG_LOCKDEP"
		ot-kernel_unset_configopt "CONFIG_DEBUG_MUTEXES"

		if ver_test "${KV_MAJOR_MINOR}" -ge "5.8" ; then
			ot-kernel_y_configopt "CONFIG_X86_PAT"
		fi
		# Workaround mentioned in the ebuild
		# It's better to modify the Kconfig.

		if ot-kernel_has_version ">=x11-drivers/nvidia-drivers-515.86[kernel-open]" ; then
			ot-kernel_y_configopt "CONFIG_MMU_NOTIFIER"
		fi

		if ot-kernel_has_version ">=x11-drivers/nvidia-drivers-470.161" ; then
			ot-kernel_unset_configopt "CONFIG_SLUB_DEBUG_ON"
		fi

		if ot-kernel_has_version "=x11-drivers/nvidia-drivers-515.86*" \
			|| ot-kernel_has_version "=x11-drivers/nvidia-drivers-510.108*" \
			|| ot-kernel_has_version "=x11-drivers/nvidia-drivers-470.161*" \
			|| ot-kernel_has_version "=x11-drivers/nvidia-drivers-390.157*" \
			; then
			warn_lowered_security "f314ac3"
			ot-kernel_unset_configopt "CONFIG_X86_KERNEL_IBT"
		fi
		if ot-kernel_has_version "=x11-drivers/nvidia-drivers-470.161*" \
			|| ot-kernel_has_version "=x11-drivers/nvidia-drivers-390.157*" \
			; then
			warn_lowered_security "f314ac3"
			ot-kernel_unset_configopt "CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT"
		fi

		local message="# Broken with the x11-drivers/nvidia-drivers package for >= 5.18.13"
		_ot-kernel-pkgflags_tty_fallback
	fi
}

# @FUNCTION: ot-kernel-pkgflags_nvtop
# @DESCRIPTION:
# Applies kernel config flags for nvtop
ot-kernel-pkgflags_nvtop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd30a310]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/nvtop" ; then
		einfo "Applying kernel config flags for the nvtop (id: d30a310)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		if ot-kernel_has_version "sys-process/nvtop[video_cards_amdgpu]" ; then
			if ! has rock-dkms ${IUSE_EFFECTIVE} ; then
				ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
			elif has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ; then
	# For sys-kernel/rock-dkms not installed yet scenario.
				ot-kernel_y_configopt "CONFIG_MODULES"
				ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"
			else
				ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
			fi
			ot-kernel_y_configopt "CONFIG_SYSFS"
		fi
		if ot-kernel_has_version "sys-process/nvtop[video_cards_intel]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915"
		fi
		if ot-kernel_has_version "sys-process/nvtop[video_cards_freedreno]" ; then
			ot-kernel_y_configopt "CONFIG_DRM_MSM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oomd
# @DESCRIPTION:
# Applies kernel config flags for the oomd package
ot-kernel-pkgflags_oomd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S05187fc]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/oomd" ; then
		einfo "Applying kernel config flags for the oomd package (id: 05187fc)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sde97c50]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/opal-utils" ; then
		einfo "Applying kernel config flags for the opal-utils package (id: de97c50)"
		ot-kernel_y_configopt "CONFIG_MTD_POWERNV_FLASH"
		ot-kernel_y_configopt "CONFIG_OPAL_PRD"
		ot-kernel_y_configopt "CONFIG_PPC_DT_CPU_FTRS"
		ban_disable_debug "de97c50"
		ot-kernel_y_configopt "CONFIG_SCOM_DEBUGFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_oprofile
# @DESCRIPTION:
# Applies kernel config flags for the oprofile package
ot-kernel-pkgflags_oprofile() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S18e7433]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/oprofile" ; then
		einfo "Applying kernel config flags for the oprofile package (id: 18e7433)"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		_ot-kernel-pkgflags_cpu_pmu_events_oprofile
	fi
}

# @FUNCTION: ot-kernel-pkgflags_orca
# @DESCRIPTION:
# Applies kernel config flags for the orca package
ot-kernel-pkgflags_orca() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1247837]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/orca" ; then
		einfo "Applying kernel config flags for the orca package (id: 1247837)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb360c7e]}" == "1" ]] && return
	if [[ "${OSS}" == "1" ]] \
		|| _ot-kernel-pkgflags_has_oss_use ; then
		einfo "Applying kernel config flags for oss (id: b360c7e)"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"

		ot-kernel_y_configopt "CONFIG_SND_MIXER_OSS" # /dev/mixer*
		ot-kernel_y_configopt "CONFIG_SND_PCM_OSS" # /dev/dsp*

		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"

		ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"
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
dev-libs/libgpiod
dev-util/lttng-modules
dev-util/sysdig-kmod
games-util/hid-nintendo
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
sys-fs/exfat-nofuse
sys-fs/loop-aes
sys-fs/vhba
sys-fs/zfs
sys-fs/zfs-kmod
sys-kernel/compat-drivers
sys-kernel/cryptodev
sys-kernel/fragattacks-drivers58
sys-kernel/ft60x_driver
sys-kernel/kpatch
sys-kernel/pcc
sys-kernel/pf_ring-kmod
sys-kernel/rte_kni-kmod
sys-kernel/tirdad
sys-kernel/ummunotify
sys-kernel/xpmem
sys-kernel/zenpower3
sys-libs/safeclib
sys-power/acpi_call
sys-power/bbswitch
sys-power/phc-intel
sys-power/tuxedo-cc-wmi
sys-process/atop
sys-process/falco-bin
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd44ca7a]}" == "1" ]] && return
	local external_module=0

	if ot-kernel-pkgflags_has_external_module ; then
		einfo "Detected external kernel module"
		external_module=1
	fi
	[[ "${OT_KERNEL_EXTERNAL_MODULES}" ]] && external_module=1

	if (( ${external_module} == 1 )) ; then
		einfo "Applying kernel config flags for external kernel modules packages (id: d44ca7a)"
		ot-kernel_unset_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		ot-kernel_y_configopt "CONFIG_MODULES"
	elif grep -q -E -e "^CONFIG_MODULES=y" "${path_config}" ; then
		einfo "Trimming unused ksyms to improve LTO (id: d44ca7a)"
		# Upstream claims that this improves LTO
		ot-kernel_y_configopt "CONFIG_TRIM_UNUSED_KSYMS"
	fi
}


# @FUNCTION: ot-kernel-pkgflags_osmo_fl2k
# @DESCRIPTION:
# Applies kernel config flags for the osmo-fl2k package
ot-kernel-pkgflags_osmo_fl2k() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9830cb3]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/osmo-fl2k" ; then
		einfo "Applying kernel config flags for the osmo-fl2k package (id: 9830cb3)"
		ot-kernel_y_configopt "CONFIG_CMA"
		ot-kernel_y_configopt "CONFIG_DMA_CMA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_iscsi
# @DESCRIPTION:
# Applies kernel config flags for the open-iscsi package
ot-kernel-pkgflags_open_iscsi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S636a064]}" == "1" ]] && return
	if ot-kernel_has_version "sys-block/open-iscsi" ; then
		einfo "Applying kernel config flags for the open-iscsi package (id: 636a064)"
		if ot-kernel_has_version "sys-block/open-iscsi[tcp]" ; then
			ot-kernel_y_configopt "CONFIG_SCSI_ISCSI_ATTRS"
			ot-kernel_y_configopt "CONFIG_ISCSI_TCP"
		fi
		if ot-kernel_has_version "sys-block/open-iscsi[infiniband]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_IPOIB"
			ot-kernel_y_configopt "CONFIG_INIBAND_USER_MAD"
			ot-kernel_y_configopt "CONFIG_INFINIBAND_USER_ACCESS"
		fi
		if ot-kernel_has_version "sys-block/open-iscsi[rdma]" ; then
			ot-kernel_y_configopt "CONFIG_INFINIBAND_ISER"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_open_vm_tools
# @DESCRIPTION:
# Applies kernel config flags for the open-vm-tools package
ot-kernel-pkgflags_open_vm_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1628573]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/open-vm-tools" ; then
		einfo "Applying kernel config flags for the open-vm-tools package (id: 1628573)"
		ot-kernel_y_configopt "CONFIG_VMWARE_BALLOON"
		ot-kernel_y_configopt "CONFIG_VMWARE_PVSCSI"
		ot-kernel_y_configopt "CONFIG_VMXNET3"
		if ot-kernel_has_version "app-emulation/open-vm-tools[X]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdc8ba5a]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/openafs" \
		&& ver_test "${KV_MAJOR_MINOR}" -lt "5.17" ; then
		einfo "Applying kernel config flags for openafs (id: dc8ba5a)"
		if ot-kernel_has_version "net-fs/openafs[modules]" ; then
			ot-kernel_unset_configopt "CONFIG_AFS_FS"
		else
			ot-kernel_y_configopt "CONFIG_AFS_FS"
		fi
		ot-kernel_y_configopt "CONFIG_KEYS"
	elif ot-kernel_has_version "net-fs/openafs" \
		&& ver_test "${KV_MAJOR_MINOR}" -ge "5.17" ; then
		ewarn "Kernel ${KV_MAJOR_MINOR}.x is not supported for openafs"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openconnect
# @DESCRIPTION:
# Applies kernel config flags for the openconnect package
ot-kernel-pkgflags_openconnect() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S98e7109]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/openconnect" ; then
		einfo "Applying kernel config flags for the openconnect package (id: 98e7109)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openl2tp
# @DESCRIPTION:
# Applies kernel config flags for the openl2tp package
ot-kernel-pkgflags_openl2tp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S83d4ba7]}" == "1" ]] && return
	if ot-kernel_has_version "net-dialup/openl2tp" ; then
		einfo "Applying kernel config flags for the openl2tp package (id: 83d4ba7)"
		ot-kernel_y_configopt "CONFIG_PPPOL2TP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openfortivpn
# @DESCRIPTION:
# Applies kernel config flags for the openfortivpn package
ot-kernel-pkgflags_openfortivpn() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S64cf079]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/openfortivpn" ; then
		einfo "Applying kernel config flags for the openfortivpn package (id: 64cf079)"
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openrc
# @DESCRIPTION:
# Applies kernel config flags for the openrc package
ot-kernel-pkgflags_openrc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2904f07]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/openrc" ; then
		einfo "Applying kernel config flags for the OpenRC package (id: 2904f07)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openrgb
# @DESCRIPTION:
# Applies kernel config flags for the openrgb package
ot-kernel-pkgflags_openrgb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4b52b16]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/openrgb" ; then
		einfo "Applying kernel config flags for the OpenRGB package (id: 4b52b16)"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_I2C_I801"
			ot-kernel_y_configopt "CONFIG_I2C_NCT6775"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_PCI"
			ot-kernel_y_configopt "CONFIG_I2C_PIIX4"
		fi
		if [[ "${OPENRGB_RESOLVE_ACPI_SMBUS_CONFLICT:-0}" == "1" ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "acpi_enforce_resources=lax"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openssl
# @DESCRIPTION:
# Applies kernel config flags for the openssl package
ot-kernel-pkgflags_openssl() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0dcc9b8]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/openssl[ktls]" \
		&& ver_test "${KV_MAJOR_MINOR}" -ge "4.18" ; then
		einfo "Applying kernel config flags for the openssl package (id: 0dcc9b8)"
		ot-kernel_y_configopt "CONFIG_TLS"
		ot-kernel_y_configopt "CONFIG_TLS_DEVICE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openvpn
# @DESCRIPTION:
# Applies kernel config flags for the openvpn package
ot-kernel-pkgflags_openvpn() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd507034]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/openvpn" ; then
		einfo "Applying kernel config flags for the openvpn package (id: d507034)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_openvswitch
# @DESCRIPTION:
# Applies kernel config flags for the openvswitch package
ot-kernel-pkgflags_openvswitch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S956a1b4]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/openvswitch" ; then
		einfo "Applying kernel config flags for the openvswitch package (id: 956a1b4)"
		ot-kernel_y_configopt "CONFIG_NET_CLS_ACT"
		ot-kernel_y_configopt "CONFIG_NET_CLS_U32"
		ot-kernel_y_configopt "CONFIG_NET_SCH_INGRESS"
		ot-kernel_y_configopt "CONFIG_NET_ACT_POLICE"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
		_ot-kernel-pkgflags_tun
		if ot-kernel_has_version "net-misc/openvswitch[modules]" ; then
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
	if ot-kernel_has_version "app-admin/keepassxc[yubikey]" \
		|| ot-kernel_has_version "app-admin/passwordsafe[yubikey]" \
		|| ot-kernel_has_version "sys-auth/ykpers" ; then
		return 0
	fi
	return 1
}

# @FUNCTION: ot-kernel-pkgflags_pam_u2f
# @DESCRIPTION:
# Applies kernel config flags for the pam_u2f package
ot-kernel-pkgflags_pam_u2f() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S79bf4ef]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/pam_u2f" \
		&& ( _ot-kernel-pkgflags_has_yubikey || [[ "${YUBIKEY}" == "1" ]] ) ; then
		einfo "Applying kernel config flags for pam_u2f (id: 79bf4ef)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf56d1a2]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/qdmr" ; then
		einfo "Applying kernel config flags for the qdmr package (id: f56d1a2)"
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
	ot-kernel_y_configopt "CONFIG_KVM"
	# Don't use lscpu/cpuinfo autodetect if using distcc or
	# cross-compile but use the config itself to guestimate.
	if [[ "${arch}" == "x86_64" ]] ; then
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_KVM_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sca52c24]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/qingy" ; then
		einfo "Applying kernel config flags for the quingy package (id: ca52c24)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qemu
# @DESCRIPTION:
# Applies kernel config flags for the QEMU package.
ot-kernel-pkgflags_qemu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S00f70b8]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/qemu" ; then
		einfo "Applying kernel config flags for the qemu package (id: 00f70b8)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		if [[ "${QEMU_HOST:-1}" == "1" ]] ; then
			ot-kernel-pkgflags_kvm_host_required
			ot-kernel-pkgflags_kvm_host_extras
		fi
		if ot-kernel_has_version "app-emulation/qemu[vhost-net]" ; then
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
		if ot-kernel_has_version "app-emulation/qemu[python]" ; then
			ot-kernel_y_configopt "CONFIG_DEBUG_FS"
			needs_debugfs "app-emulation/qemu[python]" "00f70b8"
		fi

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"

		if ot-kernel_has_version "app-emulation/qemu[test]" ; then
			ot-kernel_y_configopt "CONFIG_SHMEM"
		fi

		# _ot-kernel_y_thp # slower but supported
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qtcore
# @DESCRIPTION:
# Applies kernel config flags for the qtcore package.
ot-kernel-pkgflags_qtcore() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S00f70b8]}" == "1" ]] && return
	if ot-kernel_has_version "dev-qt/qtcore" ; then
		einfo "Applying kernel config flags for the qtcore package (id: 00f70b8)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_qtgreet
# @DESCRIPTION:
# Applies kernel config flags for the qtgreet package
ot-kernel-pkgflags_qtgreet() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8a87594]}" == "1" ]] && return
	if ot-kernel_has_version "gui-apps/qtgreet" ; then
		einfo "Applying kernel config flags for the qtgreet package (id: 8a87594)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_portage
# @DESCRIPTION:
# Applies kernel config flags for the portage package
ot-kernel-pkgflags_portage() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0be29dc]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/portage" ; then
		einfo "Applying kernel config flags for the portage package (id: 0be29dc)"

		_ot-kernel_set_ipc_ns
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pcmciautils
# @DESCRIPTION:
# Applies kernel config flags for the pcmciautils package
ot-kernel-pkgflags_pcmciautils() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S04119e0]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/pcmciautils" ; then
		einfo "Applying kernel config flags for the pcmciautils package (id: 04119e0)"
		ot-kernel_y_configopt "CONFIG_PCMCIA"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pesign
# @DESCRIPTION:
# Applies kernel config flags for the pesign package
ot-kernel-pkgflags_pesign() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4f9bc98]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/pesign" ; then
		einfo "Applying kernel config flags for the pesign package (id: 4f9bc98)"
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_unset_configopt "CONFIG_X86_USE_3DNOW"
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
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_CPU_SUP_INTEL"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_UNCORE" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_RAPL" "m"
			ot-kernel_set_configopt "CONFIG_PERF_EVENTS_INTEL_CSTATE" "m"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sef529b7]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/perf" ; then
		einfo "Applying kernel config flags for the perf package (id: ef529b7)"
		ot-kernel_y_configopt "CONFIG_PERF_EVENTS"
		_ot-kernel-pkgflags_cpu_pmu_events_perf
		ban_dma_attack "ef529b7" "CONFIG_KALLSYMS"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S72f69a5]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/perl" ; then
		einfo "Applying kernel config flags for the perl package (id: 72f69a5)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pglinux
# @DESCRIPTION:
# Applies kernel config flags for the pglinux package
ot-kernel-pkgflags_pglinux() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf219c77]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/pglinux" ; then
		einfo "Applying kernel config flags for the pglinux package (id: f219c77)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S98e977e]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/php" ; then
		einfo "Applying kernel config flags for the php package (id: 98e977e)"
		_ot-kernel_y_thp # ~3% improvement
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pipewire
# @DESCRIPTION:
# Applies kernel config flags for the pipewire package
ot-kernel-pkgflags_pipewire() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4aefe06]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/pipewire" ; then
		einfo "Applying kernel config flags for the pipewire package (id: 4aefe06)"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_plocate
# @DESCRIPTION:
# Applies kernel config flags for the plocate package
ot-kernel-pkgflags_plocate() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S38b20ed]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/plocate[io-uring]" ; then
		einfo "Applying kernel config flags for the plocate package (id: 38b20ed)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_io_uring
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ply
# @DESCRIPTION:
# Applies kernel config flags for the ply package
ot-kernel-pkgflags_ply() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sda5a055]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/ply" ; then
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

# @FUNCTION: ot-kernel-pkgflags_plymouth
# @DESCRIPTION:
# Applies kernel config flags for the plymouth package
ot-kernel-pkgflags_plymouth() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17c3464]}" == "1" ]] && return
	if ot-kernel_has_version "sys-boot/plymouth" ; then
		einfo "Applying kernel config flags for the plymouth package (id: 17c3464)"
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

# @FUNCTION: ot-kernel-pkgflags_polkit
# @DESCRIPTION:
# Applies kernel config flags for the polkit package
ot-kernel-pkgflags_polkit() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sce79cdd]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/polkit" ; then
		einfo "Applying kernel config flags for the polkit package (id: ce79cdd)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX" # For better performance
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pommed
# @DESCRIPTION:
# Applies kernel config flags for the pommed package
ot-kernel-pkgflags_pommed() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd197558]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/pommed" ; then
		einfo "Applying kernel config flags for the pommed package (id: d197558)"
		ot-kernel_y_configopt "CONFIG_DMIID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ponyprog
# @DESCRIPTION:
# Applies kernel config flags for the ponyprog package
ot-kernel-pkgflags_ponyprog() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdacf3ee]}" == "1" ]] && return
	if ot-kernel_has_version "dev-embedded/ponyprog" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S40b66c8]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/pulseaudio" ; then
		einfo "Applying kernel config flags for the pulseaudio package (id: 40b66c8)"
		ot-kernel_y_configopt "CONFIG_HIGH_RES_TIMERS"
		ot-kernel_set_configopt "CONFIG_SND_HDA_PREALLOC_SIZE" "2048"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pulseaudio_daemon
# @DESCRIPTION:
# Applies kernel config flags for the pulseaudio_daemon package
ot-kernel-pkgflags_pulseaudio_daemon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S738aa6b]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/pulseaudio-daemon" ; then
		einfo "Applying kernel config flags for the pulseaudio-daemon package (id: 738aa6b)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pqiv
# @DESCRIPTION:
# Applies kernel config flags for the pqiv package
ot-kernel-pkgflags_pqiv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S85b64bd]}" == "1" ]] && return
	if ot-kernel_has_version "media-gfx/pqiv" ; then
		einfo "Applying kernel config flags for the pqiv package (id: 85b64bd)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_pv
# @DESCRIPTION:
# Applies kernel config flags for the pv package
ot-kernel-pkgflags_pv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Saf7a9a9]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/pv" ; then
		einfo "Applying kernel config flags for the pv package (id: af7a9a9)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_python
# @DESCRIPTION:
# Applies kernel config flags for the python package
ot-kernel-pkgflags_python() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S70ba67b]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/python" ; then
		einfo "Applying kernel config flags for the python package (id: 70ba67b)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_DNOTIFY"
		if ot-kernel_has_version ">=dev-lang/python-3.8" ; then
			_ot-kernel_y_thp # Has symbol but not used
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_postgresql
# @DESCRIPTION:
# Applies kernel config flags for the postgresql package
ot-kernel-pkgflags_postgresql() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb3f021a]}" == "1" ]] && return
	if ot-kernel_has_version "dev-db/postgresql[server]" ; then
		einfo "Applying kernel config flags for the postgresql package (id: b3f021a)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powernowd
# @DESCRIPTION:
# Applies kernel config flags for the powernowd package
ot-kernel-pkgflags_powernowd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scceb5ce]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/powernowd" ; then
		einfo "Applying kernel config flags for the powernowd package (id: cceb5ce)"
		ot-kernel_y_configopt "CONFIG_CPU_FREQ"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ppp
# @DESCRIPTION:
# Applies kernel config flags for the ppp package
ot-kernel-pkgflags_ppp() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4f2e9a1]}" == "1" ]] && return
	if ot-kernel_has_version "net-dialup/ppp" ; then
		einfo "Applying kernel config flags for the ppp package (id: 4f2e9a1)"
		ot-kernel_y_configopt "CONFIG_PPP"
		ot-kernel_y_configopt "CONFIG_PPP_ASYNC"
		ot-kernel_y_configopt "CONFIG_PPP_SYNC_TTY"
		if ot-kernel_has_version "net-dialup/ppp[activefilter]" ; then
			ot-kernel_y_configopt "CONFIG_PPP_FILTER"
		fi
		ot-kernel_y_configopt "CONFIG_PPP_DEFLATE"
		ot-kernel_y_configopt "CONFIG_PPP_BSDCOMP"
		ot-kernel_y_configopt "CONFIG_PPP_MPPE"
		ot-kernel_y_configopt "CONFIG_PPPOE"
		ot-kernel_y_configopt "CONFIG_PACKET"
		if ot-kernel_has_version "net-dialup/ppp[atm]" ; then
			ot-kernel_y_configopt "CONFIG_PPPOATM"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_procps
# @DESCRIPTION:
# Applies kernel config flags for the procps package
ot-kernel-pkgflags_procps() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf553965]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/procps" ; then
		einfo "Applying kernel config flags for the procps (id: f553965)"
		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROC_SYSCTL" # For sysctl
	fi
}

# @FUNCTION: ot-kernel-pkgflags_powertop
# @DESCRIPTION:
# Applies kernel config flags for the powertop package
ot-kernel-pkgflags_powertop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S87ebe78]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/powertop" ; then
		einfo "Applying kernel config flags for the powertop package (id: 87ebe78)"
		ot-kernel_y_configopt "CONFIG_X86_MSR"
		ban_disable_debug "87ebe78" # Applies to DEBUG, FTRACE, TRACING, TRACEPOINTS keywords in this function
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		needs_debugfs "sys-power/powertop" "87ebe78"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbb3ced9]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/r8125" ; then
		einfo "Applying kernel config flags for r8125 (id: bb3ced9)"
		ot-kernel_unset_configopt "CONFIG_R8169"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_r8152
# @DESCRIPTION:
# Applies kernel config flags for r8152
ot-kernel-pkgflags_r8152() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5e191f3]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/realtek-r8152" ; then
		einfo "Applying kernel config flags for r8152 (id: 5e191f3)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf055b9c]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/r8168" ; then
		einfo "Applying kernel config flags for r8168 (id: f055b9c)"
		ot-kernel_unset_configopt "CONFIG_R8169"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rasdaemon
# @DESCRIPTION:
# Applies kernel config flags for the rasdaemon package
ot-kernel-pkgflags_rasdaemon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S86fee76]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/rasdaemon" ; then
		einfo "Applying kernel config flags for rasdaemon (id: 86fee76)"
		ban_disable_debug "86fee76"
		ot-kernel_y_configopt "CONFIG_ACPI_EXTLOG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_read_edid
# @DESCRIPTION:
# Applies kernel config flags for the read-edid package
ot-kernel-pkgflags_read_edid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sec45905]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/read-edid" ; then
		einfo "Applying kernel config flags for read-edid (id: ec45905)"
		ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_recoil
# @DESCRIPTION:
# Applies kernel config flags for the recoil package
ot-kernel-pkgflags_recoil() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S009d7a4]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/recoll" ; then
		einfo "Applying kernel config flags for recoil (id: 009d7a4)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_roct
# @DESCRIPTION:
# Applies kernel config flags for roct
ot-kernel-pkgflags_roct() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2967135]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/roct-thunk-interface" \
		|| ( has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ) ; then
		einfo "Applying kernel config flags for roct (id: 2967135)"
		ot-kernel_y_configopt "CONFIG_HSA_AMD"
		ot-kernel_y_configopt "CONFIG_HMM_MIRROR"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		if ! has rock-dkms ${IUSE_EFFECTIVE} ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		elif has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdd76993]}" == "1" ]] && return
	if ot-kernel_has_version "dev-libs/rocksdb" ; then
		einfo "Applying kernel config flags for rocksdb (id: dd76993)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		_ot-kernel_set_io_uring
		if ot-kernel_has_version "<dev-libs/rocksdb-7" ; then
			ot-kernel_y_configopt "CONFIG_FUTEX"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rr
# @DESCRIPTION:
# Applies kernel config flags for rr
ot-kernel-pkgflags_rr() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S889cc93]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/rr" ; then
		einfo "Applying kernel config flags for roct (id: 889cc93)"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ruby
# @DESCRIPTION:
# Applies kernel config flags for ruby
ot-kernel-pkgflags_ruby() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6d648f2]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/ruby" ; then
		einfo "Applying kernel config flags for ruby (id: 6d648f2)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		# ot-kernel_y_configopt "CONFIG_DNOTIFY" # Not really used
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rsyslog
# @DESCRIPTION:
# Applies kernel config flags for the rsyslog package
ot-kernel-pkgflags_rsyslog() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S16bb03d]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/rsyslog" ; then
		einfo "Applying kernel config flags for the rsyslog package (id: 16bb03d)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtirq
# @DESCRIPTION:
# Applies kernel config flags for the rtirq package
ot-kernel-pkgflags_rtirq() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7a6a27c]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/rtirq" ; then
		einfo "Applying kernel config flags for rtirq (id: 7a6a27c)"
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
ot-kernel-pkgflags_rtkit() { # DONE, NEEDS REVIEW
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se07e9e3]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/rtkit" ; then
		einfo "Applying kernel config flags for rtkit (id: e07e9e3)"
		ot-kernel_unset_configopt "CONFIG_RT_GROUP_SCHED"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rtsp_conntrack
# @DESCRIPTION:
# Applies kernel config flags for the rtsp-conntrack package
ot-kernel-pkgflags_rtsp_conntrack() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S682cf36]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/rtsp-conntrack" ; then
		einfo "Applying kernel config flags for the rtsp-conntrack package (id: 682cf36)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_runc
# @DESCRIPTION:
# Applies kernel config flags for the runc package
ot-kernel-pkgflags_runc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5c1dafb]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/runc" ; then
		einfo "Applying kernel config flags for the runc package (id: 5c1dafb)"
		_ot-kernel_set_user_ns
	fi
}

# @FUNCTION: ot-kernel-pkgflags_rust
# @DESCRIPTION:
# Applies kernel config flags for the rust package
ot-kernel-pkgflags_rust() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf89b140]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/rust" \
		|| ot-kernel_has_version "dev-lang/rust-bin" ; then
		einfo "Applying kernel config flags for the rust package (id: f89b140)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS"
		ot-kernel_y_configopt "CONFIG_AIO"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
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

# @FUNCTION: ot-kernel-pkgflags_samba
# @DESCRIPTION:
# Applies kernel config flags for the samba package
ot-kernel-pkgflags_samba() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf22efc1]}" == "1" ]] && return
	if ot-kernel_has_version "net-fs/samba" ; then
		einfo "Applying kernel config flags for the samba package (id: f22efc1)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S553f342]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/sandbox" ; then
		einfo "Applying kernel config flags for the sandbox package (id: 553f342)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SHMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sane
# @DESCRIPTION:
# Applies kernel config flags for the sane package
ot-kernel-pkgflags_sane() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S949520d]}" == "1" ]] && return
	if ot-kernel_has_version "media-gfx/sane-backends" ; then
		einfo "Applying kernel config flags for the sane package (id: 949520d)"
		SANE_SCSI="${SANE_SCSI:-0}"
		if [[ "${SANE_SCSI}" == "1" ]] ; then
			ot-kernel_y_configopt "CONFIG_BLOCK"
			ot-kernel_y_configopt "CONFIG_SCSI"
		fi
		SANE_USB="${SANE_USB:-1}"
		if [[ "${SANE_USB}" == "1" ]] ; then
			# See ot-kernel-pkgflags_usb
			if ot-kernel_has_version "media-gfx/sane-backends[-usb]" ; then
ewarn "Re-emerge media-gfx/sane-backends[usb] and ${PN} for USB scanner support."
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S745f3ee]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/sanewall" ; then
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

# @FUNCTION: ot-kernel-pkgflags_sanlock
# @DESCRIPTION:
# Applies kernel config flags for the sanlock package
ot-kernel-pkgflags_sanlock() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb54f34e]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/sanlock" ; then
		einfo "Applying kernel config flags for the sanlock package (id: b54f34e)"
		ot-kernel_y_configopt "CONFIG_SOFT_WATCHDOG"
		_ot-kernel-pkgflags_add_watchdog_drivers
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sbsigntools
# @DESCRIPTION:
# Applies kernel config flags for the sbsigntools package
ot-kernel-pkgflags_sbsigntools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scc4c186]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/sbsigntools" ; then
		einfo "Applying kernel config flags for the sbsigntools package (id: cc4c186)"
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_unset_configopt "CONFIG_X86_USE_3DNOW"
		ot-kernel_y_configopt "CONFIG_EFI_STUB"
		ot-kernel_y_configopt "CONFIG_CMDLINE_BOOL"
		ot-kernel_set_kconfig_kernel_cmdline "" # FIXME
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8775f3d]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/slim" ; then
		einfo "Applying kernel config flags for the slim package (id: 8775f3d)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_snapd
# @DESCRIPTION:
# Applies kernel config flags for the snapd package
ot-kernel-pkgflags_snapd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S487fece]}" == "1" ]] && return
	if ot-kernel_has_version "app-containers/snapd" ; then
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
		if ot-kernel_has_version "app-containers/snapd[apparmord]" ; then
			ot-kernel_y_configopt "CONFIG_SECURITY_APPARMOR"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_souper
# @DESCRIPTION:
# Applies kernel config flags for the souper package
ot-kernel-pkgflags_souper() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scbbf7b0]}" == "1" ]] && return
	if ot-kernel_has_version "sys-devel/souper[external-cache,tcp]" ; then
		einfo "Applying kernel config flags for the souper package (id: cbbf7b0)"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
	if ot-kernel_has_version "sys-devel/souper[external-cache,usockets]" ; then
		einfo "Applying kernel config flags for the souper package (id: cbbf7b0)"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_UNIX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spacenavd
# @DESCRIPTION:
# Applies kernel config flags for the spacenavd package
ot-kernel-pkgflags_spacenavd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7c0022c]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/spacenavd" ; then
		einfo "Applying kernel config flags for the spacenavd package (id: 7c0022c)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_spice_vdagent
# @DESCRIPTION:
# Applies kernel config flags for the spice-vdagent package
ot-kernel-pkgflags_spice_vdagent() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S239cc81]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/spice-vdagent" ; then
		einfo "Applying kernel config flags for the spice-vdagent package (id: 239cc81)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_VIRTIO_CONSOLE"
	fi
}

# @FUNCTION: _ot-kernel-pkgflags_squashfs
# @DESCRIPTION:
# Applies kernel config flags for the squashfs packages
_ot-kernel-pkgflags_squashfs() {
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
				| grep "Thread(s) per core:" \
				| grep -E -o -e "[0-9]+")
			local mc=$(lscpu \
				| grep "CPU(s):" \
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
		if ot-kernel_has_version "sys-fs/squashfs-tools[lz4]" ; then
			einfo "Added SquashFS LZ4 decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_LZ4"
		fi
		if ot-kernel_has_version "sys-fs/squashfs-tools[lzo]" ; then
			einfo "Added SquashFS LZO decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_LZO"
		fi
		if ot-kernel_has_version "sys-fs/squashfs-tools[lzma]" ; then
			einfo "Added SquashFS XZ decompression support"
			ot-kernel_y_configopt "CONFIG_SQUASHFS_XZ"
		fi
		if ot-kernel_has_version "sys-fs/squashfs-tools[zstd]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S7a8aba0]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/squashfs-tools" ; then
		einfo "Applying kernel config flags for the squashfs-tools package (id: 7a8aba0)"
		ot-kernel_y_configopt "CONFIG_MISC_FILESYSTEMS"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_squid
# @DESCRIPTION:
# Applies kernel config flags for the squid package
ot-kernel-pkgflags_squid() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5350ae6]}" == "1" ]] && return
	if ot-kernel_has_version "net-proxy/squid[tproxy]" ; then
		einfo "Applying kernel config flags for the squid package (id: 5350ae6)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_MATCH_SOCKET"
		ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_TPROXY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sc_controller
# @DESCRIPTION:
# Applies kernel config flags for the sc-controller package
ot-kernel-pkgflags_sc_controller() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb573d49]}" == "1" ]] && return
	if ot-kernel_has_version "games-util/sc-controller" ; then
		einfo "Applying kernel config flags for the sc-controller package (id: b573d49)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sddm
# @DESCRIPTION:
# Applies kernel config flags for the sddm package
ot-kernel-pkgflags_sddm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4669e71]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/sddm" ; then
		einfo "Applying kernel config flags for the sddm package (id: 4669e71)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
		ot-kernel_y_configopt "CONFIG_DRM" # has flag dependencies
	fi
}

# @FUNCTION: ot-kernel-pkgflags_shadow
# @DESCRIPTION:
# Applies kernel config flags for the shadow package
ot-kernel-pkgflags_shadow() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se80984f]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/shadow" ; then
		einfo "Applying kernel config flags for the shadow package (id: e80984f)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_simplevirt
# @DESCRIPTION:
# Applies kernel config flags for the simplevirt package
ot-kernel-pkgflags_simplevirt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9dc3745]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/simplevirt" ; then
		einfo "Applying kernel config flags for the simplevirt package (id: 9dc3745)"
		_ot-kernel-pkgflags_tun
		ot-kernel_y_configopt "CONFIG_BRIDGE"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_singularity
# @DESCRIPTION:
# Applies kernel config flags for the singularity package
ot-kernel-pkgflags_singularity() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17d606f]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/singularity" ; then
		einfo "Applying kernel config flags for the singularity package (id: 17d606f)"
		ot-kernel_y_configopt "CONFIG_SQUASHFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_solaar
# @DESCRIPTION:
# Applies kernel config flags for the solaar package
ot-kernel-pkgflags_solaar() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S338edae]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/solaar" ; then
		einfo "Applying kernel config flags for the solaar package (id: 338edae)"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH_DJ"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sonic_snap
# @DESCRIPTION:
# Applies kernel config flags for the sonic_snap package
ot-kernel-pkgflags_sonic_snap() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S16c9288]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/sonic-snap" ; then
		einfo "Applying kernel config flags for the sonic-snap package (id: 16c9288)"
		ot-kernel_set_configopt "CONFIG_USB_SN9C102" "m"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sshuttle
# @DESCRIPTION:
# Applies kernel config flags for the sshuttle package
ot-kernel-pkgflags_sshuttle() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5f97f7a]}" == "1" ]] && return
	if ot-kernel_has_version "net-proxy/sshuttle" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6596c21]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/shorewall" ; then
		einfo "Applying kernel config flags for the shorewall package (id: 6596c21)"
		ot-kernel_y_configopt "CONFIG_NF_CONNTRACK"
		if ver_test "${KV_MAJOR_MINOR}" -lt "4.19" ; then
			if ot-kernel_has_version "net-firewall/shorewall[ipv4]" ; then
				_ot-kernel-pkgflags_tcpip
				ot-kernel_y_configopt "CONFIG_NF_CONNTRACK_IPV4"
			fi
			if ot-kernel_has_version "net-firewall/shorewall[ipv6]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17d280b]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/sssd" ; then
		einfo "Applying kernel config flags for the sssd package (id: 17d280b)"
		ot-kernel_y_configopt "CONFIG_KEYS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sstp_client
# @DESCRIPTION:
# Applies kernel config flags for the sstp-client package
ot-kernel-pkgflags_sstp_client() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17dced4]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/sstp-client" ; then
		einfo "Applying kernel config flags for the sstp-client package (id: 17dced4)"
		ot-kernel_y_configopt "CONFIG_NETFILTER_NETLINK"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_speedtouch_usb
# @DESCRIPTION:
# Applies kernel config flags for the speedtouch-usb package
ot-kernel-pkgflags_speedtouch_usb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd90675b]}" == "1" ]] && return
	if ot-kernel_has_version "net-dialup/speedtouch-usb" ; then
		einfo "Applying kernel config flags for the speedtouch-usb package (id: d90675b)"
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

# @FUNCTION: ot-kernel-pkgflags_steam
# @DESCRIPTION:
# Applies kernel config flags for the steam-meta package
ot-kernel-pkgflags_steam() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf2d2736]}" == "1" ]] && return
	if ot-kernel_has_version "games-utils/steam-meta" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3af5aaa]}" == "1" ]] && return
	if ot-kernel_has_version "app-benchmarks/stress-ng[apparmor]" ; then
		einfo "Applying kernel config flags for the stress-ng package (id: 3af5aaa)"
		ot-kernel_y_configopt "CONFIG_SECURITY_APPARMOR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sudo
# @DESCRIPTION:
# Applies kernel config flags for the sudo package
ot-kernel-pkgflags_sudo() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S40b9c7e]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/sudo" ; then
		einfo "Applying kernel config flags for the sudo package (id: 40b9c7e)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_suricata
# @DESCRIPTION:
# Applies kernel config flags for the suricata package
ot-kernel-pkgflags_suricata() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S5a1ebf8]}" == "1" ]] && return
	if ot-kernel_has_version "net-analyzer/suricata" ; then
		einfo "Applying kernel config flags for the suricata package (id: 5a1ebf8)"
		ot-kernel_y_configopt "CONFIG_XDP_SOCKETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_sysdig_kmod
# @DESCRIPTION:
# Applies kernel config flags for the sysdig-kmod package
ot-kernel-pkgflags_sysdig_kmod() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0e9fdcf]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/sysdig-kmod" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S297eb15]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/systemd" ; then
		einfo "Applying kernel config flags for the systemd package (id: 297eb15)"
		ot-kernel_y_configopt "CONFIG_AUTOFS4_FS"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_BSG"
		ot-kernel_y_configopt "CONFIG_CGROUPS"
		ot-kernel_y_configopt "CONFIG_DEVTMPFS"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_FANOTIFY"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"

		_ot-kernel_set_net_ns
		_ot-kernel_set_user_ns

		ot-kernel_y_configopt "CONFIG_PROC_FS"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		ot-kernel_y_configopt "CONFIG_TMPFS_XATTR"
		ot-kernel_y_configopt "CONFIG_UNIX"
		ot-kernel_y_configopt "CONFIG_CRYPTO_HMAC"
		_ot-kernel-pkgflags_sha256
		ot-kernel_y_configopt "CONFIG_CRYPTO_USER_API_HASH"
		warn_lowered_security "297eb15"
		ot-kernel_unset_configopt "CONFIG_GRKERNSEC_PROC"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED"
		ot-kernel_unset_configopt "CONFIG_SYSFS_DEPRECATED_V2"

		if ot-kernel_has_version "sys-apps/systemd[acl]" ; then
			ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
		fi
		if ot-kernel_has_version "sys-apps/systemd[seccomp]" ; then
			ot-kernel_y_configopt "CONFIG_SECCOMP"
			ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -lt "3.7" ; then
			ot-kernel_y_configopt "CONFIG_HOTPLUG"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.7" ; then
			ot-kernel_y_configopt "CONFIG_DEVPTS_MULTIPLE_INSTANCES"
		fi

		if ver_test "${KV_MAJOR_MINOR}" -ge "4.10" ; then
			ot-kernel_y_configopt "CONFIG_CGROUP_BPF"
		fi
		ot-kernel_set_configopt "CONFIG_UEVENT_HELPER_PATH" "\"\""

		if grep -q -e "^CONFIG_X86=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_KCMP"
		fi

		ot-kernel_y_configopt "CONFIG_SYSVIPC"

		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		#ot-kernel_y_configopt "CONFIG_FHANDLE"
		#ot-kernel_y_configopt "CONFIG_TIMERFD"
		#ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_SHMEM"

		# LDT referended in sys-apps/systemd
	fi
}

# @FUNCTION: ot-kernel-pkgflags_systemd_bootchart
# @DESCRIPTION:
# Applies kernel config flags for the systemd-bootchart package
ot-kernel-pkgflags_systemd_bootchart() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S11dfb63]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/systemd-bootchart" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S78ae7b9]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/systemtap" ; then
		einfo "Applying kernel config flags for systemtap (id: 78ae7b9)"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_RELAY"
		ban_disable_debug "78ae7b9"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		needs_debugfs "dev-util/systemtap" "78ae7b9"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tas
# @DESCRIPTION:
# Applies kernel config flags for the tas package
ot-kernel-pkgflags_tas() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb362784]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/tas" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc800aa5]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/thunderbolt-software-user-space" ; then
		einfo "Applying kernel config flags for tb-us (id: c800aa5)"
		ot-kernel_y_configopt "CONFIG_THUNDERBOLT"
		ot-kernel_y_configopt "CONFIG_HOTPLUG_PCI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tbb
# @DESCRIPTION:
# Applies kernel config flags for the tbb package
ot-kernel-pkgflags_tbb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbe4a184]}" == "1" ]] && return
	if ot-kernel_has_version "dev-cpp/tbb" ; then
		einfo "Applying kernel config flags for tbb (id: be4a184)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tboot
# @DESCRIPTION:
# Applies kernel config flags for the tboot package
ot-kernel-pkgflags_tboot() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se4d2001]}" == "1" ]] && return
	if ot-kernel_has_version "sys-boot/tboot" ; then
		einfo "Applying kernel config flags for tb-us (id: e4d2001)"
		ot-kernel_y_configopt "CONFIG_INTEL_TXT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_thinkfinger
# @DESCRIPTION:
# Applies kernel config flags for the thinkfinger package
ot-kernel-pkgflags_thinkfinger() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf096b24]}" == "1" ]] && return
	if ot-kernel_has_version "sys-auth/thinkfinger[pam]" ; then
		einfo "Applying kernel config flags for thinkfinger (id: f096b24)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_torque
# @DESCRIPTION:
# Applies kernel config flags for the torque package
ot-kernel-pkgflags_torque() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbe14777]}" == "1" ]] && return
	if ot-kernel_has_version "sys-cluster/torque[cpusets]" ; then
		einfo "Applying kernel config flags for torque (id: be14777)"
		ot-kernel_y_configopt "CONFIG_CPUSETS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tp_smapi
# @DESCRIPTION:
# Applies kernel config flags for the tp_smapi package
ot-kernel-pkgflags_tp_smapi() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sfb3a3a0]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/tp_smapi[hdaps]" ; then
		einfo "Applying kernel config flags for tp_smapi (id: fb3a3a0)"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_unset_configopt "CONFIG_SENSORS_HDAPS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpb
# @DESCRIPTION:
# Applies kernel config flags for the tpb package
ot-kernel-pkgflags_tpb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1ee9ffd]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/tpb" ; then
		einfo "Applying kernel config flags for tpb (id: 1ee9ffd)"
		ot-kernel_y_configopt "CONFIG_NVRAM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpm_emulator
# @DESCRIPTION:
# Applies kernel config flags for the tpm-emulator package
ot-kernel-pkgflags_tpm_emulator() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb9d0068]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/tpm-emulator" ; then
		einfo "Applying kernel config flags for tpm-emulator (id: b9d0068)"
		ot-kernel_y_configopt "CONFIG_MODULES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tpm2_tss
# @DESCRIPTION:
# Applies kernel config flags for the tpm2_tss package
ot-kernel-pkgflags_tpm2_tss() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sde73f41]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/tpm2-tss" ; then
		einfo "Applying kernel config flags for tpm2-tss (id: de73f41)"
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trace_cmd
# @DESCRIPTION:
# Applies kernel config flags for the trace-cmd package
ot-kernel-pkgflags_trace_cmd() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbb847a6]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/trace-cmd" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa6270fb]}" == "1" ]] && return
	if ot-kernel_has_version "app-misc/tracker" ; then
		einfo "Applying kernel config flags for tracker (id: a6270fb)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_trousers
# @DESCRIPTION:
# Applies kernel config flags for the trousers package
ot-kernel-pkgflags_trousers() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1041159]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/trousers" ; then
		einfo "Applying kernel config flags for trousers (id: 1041159)"
		ot-kernel_y_configopt "CONFIG_TCG_TPM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tuigreet
# @DESCRIPTION:
# Applies kernel config flags for the tuigreet package
ot-kernel-pkgflags_tuigreet() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa6754c0]}" == "1" ]] && return
	if ot-kernel_has_version "gui-apps/tuigreet" ; then
		einfo "Applying kernel config flags for the tuigreet package (id: a6754c0)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tup
# @DESCRIPTION:
# Applies kernel config flags for the tup package
ot-kernel-pkgflags_tup() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4257724]}" == "1" ]] && return
	if ot-kernel_has_version "dev-util/tup" ; then
		einfo "Applying kernel config flags for tup (id: 4257724)"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
		ot-kernel_y_configopt "CONFIG_NAMESPACES"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_tuxedo_keyboard
# @DESCRIPTION:
# Applies kernel config flags for the tuxedo_keyboard package
ot-kernel-pkgflags_tuxedo_keyboard() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sae30b00]}" == "1" ]] && return
	if ot-kernel_has_version "app-laptop/tuxedo-keyboard" ; then
		einfo "Applying kernel config flags for tuxedo-keyboard (id: ae30b00)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2a10779]}" == "1" ]] && return
	if ot-kernel_has_version "media-tv/tvheadend" ; then
		einfo "Applying kernel config flags for tvheadhead (id: 2a10779)"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_udev
# @DESCRIPTION:
# Applies kernel config flags for the udev package
ot-kernel-pkgflags_udev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2841205]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/udev" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S98b0478]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/udisks" \
		&& [[ \
			"${arch}" == "arm" \
			|| "${arch}" == "powerpc" \
			|| "${arch}" == "ppc" \
			|| "${arch}" == "ppc64" \
			|| "${arch}" == "x86" \
			|| "${arch}" == "x86_64" \
		]] ; then
		einfo "Applying kernel config flags for the udisks package (id: 98b0478)"
ewarn "CONFIG_IDE is being unset for udisks (id: 98b0478)"
		ot-kernel_unset_configopt "CONFIG_IDE"
		ot-kernel_y_configopt "CONFIG_TMPFS_POSIX_ACL"
		ot-kernel_y_configopt "CONFIG_NLS_UTF8"
		if ver_test "${KV_MAJOR_MINOR}" -lt "3.10" ; then
			ot-kernel_y_configopt "CONFIG_USB_SUSPEND"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_ufw
# @DESCRIPTION:
# Applies kernel config flags for the ufw package
ot-kernel-pkgflags_ufw() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S18d6a56]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/ufw" ; then
		einfo "Applying kernel config flags for the ufw package (id: 18d6a56)"
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
		ban_disable_debug "18d6a56" "NETFILTER"
		if ver_test "${MY_PV}" -ge "3.4" ; then
			ot-kernel_y_configopt "CONFIG_NETFILTER_XT_TARGET_LOG"
		else
			ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_LOG"
			if ot-kernel_has_version "net-firewall/ufw[ipv6]" ; then
				ot-kernel_y_configopt "CONFIG_IP6_NF_TARGET_LOG"
			fi
		fi
		ot-kernel_y_configopt "CONFIG_IP_NF_TARGET_REJECT"
		if ot-kernel_has_version "net-firewall/ufw[ipv6]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6b83c24]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/uksmd" ; then
		einfo "Applying kernel config flags for the uksmd package (id: 6b83c24)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S4047b49]}" == "1" ]] && return
	if ot-kernel_has_version "sys-power/intel-undervolt" ; then
		einfo "Applying kernel config flags for the undervolt package (id: 4047b49)"
		_ot-kernel-pkgflags_rapl
		ot-kernel_y_configopt "CONFIG_X86_MSR"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb
# @DESCRIPTION:
# Applies kernel config flags for usb
ot-kernel-pkgflags_usb() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S33a5d46]}" == "1" ]] && return
	if ot-kernel_has_version "virtual/libusb" \
		|| ot-kernel_has_version "dev-libs/libusb" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S41122e0]}" == "1" ]] && return
	if ot-kernel_has_version "sys-firmware/midisport-firmware" ; then
		einfo "Applying kernel config flags for the usb midi fw package (id: 41122e0)"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usb_modeswitch
# @DESCRIPTION:
# Applies kernel config flags for the usb_modeswitch package
ot-kernel-pkgflags_usb_modeswitch() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1a2ff9d]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/usb_modeswitch" ; then
		einfo "Applying kernel config flags for the usb_modeswitch package (id: 1a2ff9d)"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbtop
# @DESCRIPTION:
# Applies kernel config flags for the usbtop package
ot-kernel-pkgflags_usbtop() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8091306]}" == "1" ]] && return
	if ot-kernel_has_version "sys-process/usbtop" ; then
		einfo "Applying kernel config flags for the usbtop package (id: 8091306)"
		ot-kernel_y_configopt "CONFIG_USB_MON"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_usbview
# @DESCRIPTION:
# Applies kernel config flags for the usbview package
ot-kernel-pkgflags_usbview() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3e735de]}" == "1" ]] && return
	if ot-kernel_has_version "app-admin/usbview" ; then
		einfo "Applying kernel config flags for the usbview package (id: 3e735de)"
		ban_disable_debug "3e735de"
		ot-kernel_y_configopt "CONFIG_DEBUG_FS"
		needs_debugfs "app-admin/usbview" "3e735de"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_util_linux
# @DESCRIPTION:
# Applies kernel config flags for the util-linux package
ot-kernel-pkgflags_util_linux() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3267f74]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/util-linux[su]" ; then
		einfo "Applying kernel config flags for the util-linux package (id: 3267f74)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_v4l_dvb_saa716x
# @DESCRIPTION:
# Applies kernel config flags for the v4l-dvb-saa716x package
ot-kernel-pkgflags_v4l_dvb_saa716x() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdbf8e9f]}" == "1" ]] && return
	if ot-kernel_has_version "media-tv/v4l-dvb-saa716x" ; then
		einfo "Applying kernel config flags for the v4l-dvb-saa716x package (id: dbf8e9f)"
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_STV6110x"
		ot-kernel_y_configopt "CONFIG_DVB_STV090x"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_v4l2loopback
# @DESCRIPTION:
# Applies kernel config flags for the v4l2loopback package
ot-kernel-pkgflags_v4l2loopback() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb4a9c8a]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/v4l2loopback" ; then
		einfo "Applying kernel config flags for the v4l2loopback package (id: b4a9c8a)"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vala
# @DESCRIPTION:
# Applies kernel config flags for the vala package
ot-kernel-pkgflags_vala() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Scdcd65b]}" == "1" ]] && return
	if ot-kernel_has_version "dev-lang/vala" ; then
		einfo "Applying kernel config flags for the vala package (id: cdcd65b)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vbox
# @DESCRIPTION:
# Applies kernel config flags for the vbox package
ot-kernel-pkgflags_vbox() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc12b08e]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/virtualbox" ; then
		einfo "Applying kernel config flags for the vbox package (id: c12b08e)"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_y_configopt "CONFIG_VIRTUALIZATION"
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

# @FUNCTION: ot-kernel-pkgflags_vcrypt
# @DESCRIPTION:
# Applies kernel config flags for vcrypt
ot-kernel-pkgflags_vcrypt() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se98f261]}" == "1" ]] && return
	if ot-kernel_has_version "app-crypt/veracrypt" ; then
		einfo "Applying kernel config flags for vcrypt (id: e98f261)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_DM"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_XTS"
		ot-kernel_y_configopt "CONFIG_DM_CRYPT"
		ot-kernel_y_configopt "CONFIG_FUSE_FS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vendor_reset
# @DESCRIPTION:
# Applies kernel config flags for the vendor-reset package
ot-kernel-pkgflags_vendor_reset() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S3bae162]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/vendor-reset" ; then
		einfo "Applying kernel config flags for the vendor-reset package (id: 3bae162)"
		ban_disable_debug "3bae162"
		ot-kernel_y_configopt "CONFIG_FTRACE"
		ot-kernel_y_configopt "CONFIG_KPROBES"
		ot-kernel_y_configopt "CONFIG_PCI_QUIRKS"
		ban_dma_attack "3bae162" "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_KALLSYMS"
		ot-kernel_y_configopt "CONFIG_FUNCTION_TRACER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vhba
# @DESCRIPTION:
# Applies kernel config flags for the vhba package
ot-kernel-pkgflags_vhba() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sce86ab8]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/vhba" ; then
		einfo "Applying kernel config flags for the vhba package (id: ce86ab8)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vim
# @DESCRIPTION:
# Applies kernel config flags for the vim package
ot-kernel-pkgflags_vim() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0795e0f]}" == "1" ]] && return
	if ot-kernel_has_version "app-editors/vim" ; then
		einfo "Applying kernel config flags for the vim package (id: 0795e0f)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		#ot-kernel_y_configopt "CONFIG_SYSVIPC" # Used in config check and .vim files only
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vinagre
# @DESCRIPTION:
# Applies kernel config flags for the vinagre package
ot-kernel-pkgflags_vinagre() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2356e75]}" == "1" ]] && return
	if ot-kernel_has_version "net-misc/vinagre" ; then
		einfo "Applying kernel config flags for the vinagre package (id: 2356e75)"
	        _ot-kernel-pkgflags_tcpip
	        ot-kernel_y_configopt "CONFIG_IPV6"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vlc
# @DESCRIPTION:
# Applies kernel config flags for the vlc package
ot-kernel-pkgflags_vlc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc99c6c8]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/vlc" ; then
		einfo "Applying kernel config flags for the vlc package (id: c99c6c8)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vpnc
# @DESCRIPTION:
# Applies kernel config flags for the vpnc package
ot-kernel-pkgflags_vpnc() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sac51429]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/vpnc" ; then
		einfo "Applying kernel config flags for the vpnc package (id: ac51429)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_vtun
# @DESCRIPTION:
# Applies kernel config flags for the vtun package
ot-kernel-pkgflags_vtun() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S205c74a]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/vtun" ; then
		einfo "Applying kernel config flags for the vtun package (id: 205c74a)"
		_ot-kernel-pkgflags_tun
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wacom
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-wacom package
ot-kernel-pkgflags_wacom() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sdc77e36]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-input-wacom" ; then
		einfo "Applying kernel config flags for the xf86-input-wacom package (id: dc77e36)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1b4f71b]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/watchdog" ; then
		einfo "Applying kernel config flags for the watchdog package (id: 1b4f71b)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S75439ce]}" == "1" ]] && return
	if ot-kernel_has_version "gui-apps/wlgreet" ; then
		einfo "Applying kernel config flags for the wlgreet package (id: 75439ce)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wavemon
# @DESCRIPTION:
# Applies kernel config flags for the wavemon package
ot-kernel-pkgflags_wavemon() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S8960610]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/wavemon" ; then
		einfo "Applying kernel config flags for the wavemon package (id: 8960610)"
		if ot-kernel_has_version "~net-wireless/wavemon-0.9.3" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211_WEXT"
		elif ot-kernel_has_version ">=net-wireless/wavemon-0.9.4" ; then
			ot-kernel_y_configopt "CONFIG_CFG80211"
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wdm
# @DESCRIPTION:
# Applies kernel config flags for the wdm package
ot-kernel-pkgflags_wdm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9f65492]}" == "1" ]] && return
	if ot-kernel_has_version "x11-misc/wdm" ; then
		einfo "Applying kernel config flags for the wdm package (id: 9f65492)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_webkit_gtk
# @DESCRIPTION:
# Applies kernel config flags for the webkit-gtk package
ot-kernel-pkgflags_webkit_gtk() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb605226]}" == "1" ]] && return
	if ot-kernel_has_version "net-libs/webkit-gtk" ; then
		einfo "Applying kernel config flags for the webkit-gtk package (id: b605226)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_ADVISE_SYSCALLS" # __NR_process_madvise
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wine
# @DESCRIPTION:
# Applies kernel config flags for the wine packages
ot-kernel-pkgflags_wine() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sab3aa13]}" == "1" ]] && return
	if \
		ot-kernel_has_version "app-emulation/wine-d3d9" \
		|| ot-kernel_has_version "app-emulation/wine-proton" \
		|| ot-kernel_has_version "app-emulation/wine-staging" \
		|| ot-kernel_has_version "app-emulation/wine-vanilla" \
		|| ot-kernel_has_version "app-emulation/wine-wayland" \
		; then
		einfo "Applying kernel config flags for the wine package (id: ab3aa13)"
		ot-kernel_y_configopt "CONFIG_COMPAT_32BIT_TIME"
		ot-kernel_y_configopt "CONFIG_BINFMT_MISC"		# For .NET
		if [[ "${arch}" =~ ("x86_64"|"x86") ]] ; then
			ot-kernel_y_configopt "CONFIG_IA32_EMULATION"	# For Legacy 32-bit
		fi
		ot-kernel_y_configopt "CONFIG_INOTIFY_USER"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
	fi
	if \
		( \
			ot-kernel_has_version "app-emulation/wine-staging" \
		) \
		&& [[ "${BPF_JIT}" == "1" ]] \
		; then
		# For syscall overhead reduction
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_SECCOMP_FILTER"
		ot-kernel_y_configopt "CONFIG_BPF_JIT"
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
}

# @FUNCTION: ot-kernel-pkgflags_wireguard_modules
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-modules package
ot-kernel-pkgflags_wireguard_modules() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa2dab07]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/wireguard-modules" ; then
		einfo "Applying kernel config flags for the wireguard-modules package (id: a2dab07)"
		_ot-kernel-pkgflags_tcpip
		ot-kernel_y_configopt "CONFIG_NET_UDP_TUNNEL"
		ot-kernel_y_configopt "CONFIG_CRYPTO_ALGAPI"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireguard_tools
# @DESCRIPTION:
# Applies kernel config flags for the wireguard-tools package
ot-kernel-pkgflags_wireguard_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sd0dd1be]}" == "1" ]] && return
	if ot-kernel_has_version "net-vpn/wireguard-tools[wg-quick]" ; then
		einfo "Applying kernel config flags for the wireguard-tools package (id: d0dd1be)"
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
	if ot-kernel_has_version "net-vpn/wireguard-tools" ; then
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
			if grep -q -E -e "^CONFIG_CPU_MIPS32_R2=y" "${path_config}" ; then
				ot-kernel_y_configopt "CONFIG_CRYPTO_CHACHA_MIPS"
			fi
		fi
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wireless_tools
# @DESCRIPTION:
# Applies kernel config flags for the wireless-tools package
ot-kernel-pkgflags_wireless_tools() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S0861c19]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/wireless-tools" ; then
		einfo "Applying kernel config flags for the wireless-tools package (id: 0861c19)"
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf9df425]}" == "1" ]] && return
	if ot-kernel_has_version "media-video/wireplumber" ; then
		einfo "Applying kernel config flags for the wireplumber package (id: f9df425)"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_unset_configopt "CONFIG_UML"
		ot-kernel_y_configopt "CONFIG_SND_PROC_FS"
		ban_disable_debug "f9df425"
		ot-kernel_y_configopt "CONFIG_SND_VERBOSE_PROCFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_wpa_supplicant
# @DESCRIPTION:
# Applies kernel config flags for the wpa_supplicant package
ot-kernel-pkgflags_wpa_supplicant() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se0a4d03]}" == "1" ]] && return
	if ot-kernel_has_version "net-wireless/wpa_supplicant[crda]" ; then
		einfo "Applying kernel config flags for the wpa_supplicant package (id: e0a4d03)"
		: # See ot-kernel-pkgflags_crda
		ot-kernel_has_version "net-wireless/crda" || die "Install net-wireless/crda first"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xboxdrv
# @DESCRIPTION:
# Applies kernel config flags for the xboxdrv package
ot-kernel-pkgflags_xboxdrv() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se7ec6f5]}" == "1" ]] && return
	if ot-kernel_has_version "games-util/xboxdrv" ; then
		einfo "Applying kernel config flags for the xboxdrv package (id: e7ec6f5)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xdm
# @DESCRIPTION:
# Applies kernel config flags for the xdm package
ot-kernel-pkgflags_xdm() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S9080d05]}" == "1" ]] && return
	if ot-kernel_has_version "x11-apps/xdm" ; then
		einfo "Applying kernel config flags for the xdm package (id: 9080d05)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xe_guest_utilities
# @DESCRIPTION:
# Applies kernel config flags for the xe_guest_utilities package
ot-kernel-pkgflags_xe_guest_utilities() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sfec348c]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/xe-guest-utilities" ; then
		einfo "Applying kernel config flags for the xe-guest-utilities package (id: fec348c)"
		ot-kernel_y_configopt "CONFIG_XEN_COMPAT_XENFS"
		ot-kernel_y_configopt "CONFIG_XENFS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xen
# @DESCRIPTION:
# Applies kernel config flags for the xen package
ot-kernel-pkgflags_xen() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc729ba1]}" == "1" ]] && return
	if ot-kernel_has_version "app-emulation/xen" ; then
		einfo "Applying kernel config flags for the xen package (id: c729ba1)"
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

			ot-kernel_y_configopt "CONFIG_ACPI"

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
			ban_disable_debug "c729ba1"
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
			ban_disable_debug "c729ba1"
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
		ot-kernel_y_configopt "CONFIG_BPF_SYSCALL"
		ot-kernel_y_configopt "CONFIG_EPOLL"
		ot-kernel_y_configopt "CONFIG_EVENTFD"
		ot-kernel_y_configopt "CONFIG_FHANDLE"
		ot-kernel_y_configopt "CONFIG_FUTEX"
		_ot-kernel_set_io_uring
		ot-kernel_y_configopt "CONFIG_MEMBARRIER"
		ot-kernel_y_configopt "CONFIG_POSIX_TIMERS"
		ot-kernel_y_configopt "CONFIG_SECCOMP"
		ot-kernel_y_configopt "CONFIG_SIGNALFD"
		ot-kernel_y_configopt "CONFIG_SHMEM"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
		# _ot-kernel_y_thp # References it but unknown apparent performance gain/loss

		# LDT referenced
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_evdev
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-evdev package
ot-kernel-pkgflags_xf86_input_evdev() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sa9b2291]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-input-evdev" ; then
		einfo "Applying kernel config flags for the xf86-input-evdev package (id: a9b2291)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_libinput
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-libinput package
ot-kernel-pkgflags_xf86_input_libinput() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc4e47ff]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-input-libinput" ; then
		einfo "Applying kernel config flags for the xf86-input-libinput package (id: c4e47ff)"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TIMERFD"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_input_synaptics
# @DESCRIPTION:
# Applies kernel config flags for the xf86-input-synaptics package
ot-kernel-pkgflags_xf86_input_synaptics() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc940a05]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-input-synaptics" ; then
		einfo "Applying kernel config flags for the xf86-input-synaptics package (id: c940a05)"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_amdgpu
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-amdgpu package
ot-kernel-pkgflags_xf86_video_amdgpu() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Saffcbb4]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-video-amdgpu" \
		|| ( has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ) ; then
		einfo "Applying kernel config flags for the rock-dkms/xf86-video-amdgpu package (id: affcbb4)"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTPLUG"
		ot-kernel_y_configopt "CONFIG_MEMORY_HOTREMOVE"
		ot-kernel_y_configopt "CONFIG_ZONE_DEVICE"
		ot-kernel_y_configopt "CONFIG_DEVICE_PRIVATE"
		ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_AMD64"
		fi
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_MMU"
		if ! has rock-dkms ${IUSE_EFFECTIVE} ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMDGPU"
		elif has rock-dkms ${IUSE_EFFECTIVE} && ot-kernel_use rock-dkms ; then
	# For sys-kernel/rock-dkms not installed yet scenario.
			ot-kernel_y_configopt "CONFIG_MODULES"
			ot-kernel_set_configopt "CONFIG_DRM_AMDGPU" "m"

			if ver_test ${KV_MAJOR_MINOR} -le 5.5 ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2c2d347]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-video-ati" ; then
		einfo "Applying kernel config flags for the xf86-video-ati package (id: 2c2d347)"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
		ot-kernel_y_configopt "CONFIG_AGP"
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_AGP_INTEL"
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbc32011]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-video-intel" ; then
		einfo "Applying kernel config flags for the xf86-video-intel package (id: bc32011)"
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
			ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.6" ; then
			ot-kernel_y_configopt "CONFIG_DRM_I915_USERPTR"
		fi
		if ver_test "${KV_MAJOR_MINOR}" -ge "4.10" ; then
			warn_lowered_security "bc32011"
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

		if ver_test "sys-kernel/linux-firmware" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S411e952]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-video-nouveau" ; then
		einfo "Applying kernel config flags for the xf86-video-nouveau package (id: 411e952)"
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
		ot-kernel_y_configopt "CONFIG_DRM_NOUVEAU"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xf86_video_vesa
# @DESCRIPTION:
# Applies kernel config flags for the xf86-video-vesa package
ot-kernel-pkgflags_xf86_video_vesa() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S1940044]}" == "1" ]] && return
	if ot-kernel_has_version "x11-drivers/xf86-video-vesa" ; then
		einfo "Applying kernel config flags for the xf86-video-vesa package (id: 1940044)"
		ot-kernel_y_configopt "CONFIG_DEVMEM"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_x86info
# @DESCRIPTION:
# Applies kernel config flags for the x86info package
ot-kernel-pkgflags_x86info() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc7f9852]}" == "1" ]] && return
	if ot-kernel_has_version "sys-apps/x86info" ; then
		einfo "Applying kernel config flags for the x86info package (id: c7f9852)"
		ot-kernel_y_configopt "CONFIG_MTRR"
		ot-kernel_y_configopt "CONFIG_X86_CPUID"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xfce4_battery_plugin
# @DESCRIPTION:
# Applies kernel config flags for the xfce4-battery-plugin package
ot-kernel-pkgflags_xfce4_battery_plugin() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sf54e65c]}" == "1" ]] && return
	if ot-kernel_has_version "xfce-extra/xfce4-battery-plugin" ; then
		einfo "Applying kernel config flags for the xfce4-battery-plugin package (id: f54e65c)"
		ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xmms2
# @DESCRIPTION:
# Applies kernel config flags for the xmms2
ot-kernel-pkgflags_xmms2() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S17be4ae]}" == "1" ]] && return
	if ot-kernel_has_version "media-sound/xmms2" ; then
		einfo "Applying kernel config flags for the xmms2 package (id: 17be4ae)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xorg_server
# @DESCRIPTION:
# Applies kernel config flags for the xorg-server package
ot-kernel-pkgflags_xorg_server() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbab5cc6]}" == "1" ]] && return
	if ot-kernel_has_version "x11-base/xorg-server" ; then
		einfo "Applying kernel config flags for the xorg-server package (id: bab5cc6)"
		ot-kernel_y_configopt "CONFIG_SYSVIPC"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xoscope
# @DESCRIPTION:
# Applies kernel config flags for the xoscope package
ot-kernel-pkgflags_xoscope() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S6a3c3e1]}" == "1" ]] && return
	if ot-kernel_has_version "sci-electronics/xoscope" ; then
		einfo "Applying kernel config flags for the xoscope package (id: 6a3c3e1)"
		ot-kernel_y_configopt "SND_PCM_OSS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpadneo
# @DESCRIPTION:
# Applies kernel config flags for the xpadneo package
ot-kernel-pkgflags_xpadneo() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sb38bb16]}" == "1" ]] && return
	if ot-kernel_has_version "games-util/xpadneo" ; then
		einfo "Applying kernel config flags for the xpadneo package (id: b38bb16)"
		ot-kernel_y_configopt "CONFIG_INPUT_FF_MEMLESS"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_xpra
# @DESCRIPTION:
# Applies kernel config flags for the xpra package
ot-kernel-pkgflags_xpra() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S15db603]}" == "1" ]] && return
	if ot-kernel_has_version "x11-wm/xpra[v4l2]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[S2b5f5b4]}" == "1" ]] && return
	if ot-kernel_has_version "net-firewall/xtables-addons[modules]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sbdf10dc]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/zfs[test-suite]" ; then
		einfo "Applying kernel config flags for the zfs package (id: bdf10dc)"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	fi
}

# @FUNCTION: ot-kernel-pkgflags_zfs_kmod
# @DESCRIPTION:
# Applies kernel config flags for the zfs-kmod package
ot-kernel-pkgflags_zfs_kmod() { # DONE
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Sc0bec20]}" == "1" ]] && return
	if ot-kernel_has_version "sys-fs/zfs-kmod" ; then
		einfo "Applying kernel config flags for the zfs-kmod package (id: c0bec20)"
		ban_disable_debug "c0bec20"
		ot-kernel_unset_configopt "CONFIG_DEBUG_LOCK_ALLOC"
		ot-kernel_y_configopt "CONFIG_PARTITION_ADVANCED"
		ot-kernel_y_configopt "CONFIG_EFI_PARTITION"
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_unset_configopt "CONFIG_PAX_KERNEXEC_PLUGIN_METHOD_OR" # old
		ot-kernel_unset_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		ot-kernel_y_configopt "CONFIG_ZLIB_DEFLATE"
		ot-kernel_y_configopt "CONFIG_ZLIB_INFLATE"
		if ot-kernel_has_version "sys-fs/zfs-kmod[debug]" ; then
			ot-kernel_y_configopt "CONFIG_FRAME_POINTER"
			ot-kernel_y_configopt "CONFIG_DEBUG_INFO"
			ot-kernel_unset_configopt "CONFIG_DEBUG_INFO_REDUCED"
		fi
		if ot-kernel_has_version "sys-fs/zfs-kmod[rootfs]" ; then
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
	[[ "${OT_KERNEL_PKGFLAGS_REJECT[Se8903fa]}" == "1" ]] && return
	if ot-kernel_has_version "net-im/zoom" ; then
		einfo "Applying kernel config flags for the zoom package (id: e8903fa)"
		_ot-kernel_set_net_ns
		_ot-kernel_set_pid_ns
		_ot-kernel_set_user_ns
		ot-kernel_unset_configopt "CONFIG_NET"
		ot-kernel_unset_configopt "CONFIG_SECCOMP_FILTER"
	fi
}

# @FUNCTION: _ot-kernel_set_netfilter
# @DESCRIPTION:
# Checks and enables various netfilter support used for firewalls, NAT,
# packet filtering.
_ot-kernel_set_netfilter() {
	[[ -z "${OT_KERNEL_NETFILTER}" ]] && return

	if [[ "${BPF_JIT}" == "1" ]] ; then
		ot-kernel_y_configopt "CONFIG_BPF_JIT"
	fi

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
		warn_lowered_security "4e97be4"
		ot-kernel_y_configopt "CONFIG_X86_16BIT"
		ot-kernel_y_configopt "CONFIG_MODIFY_LDT_SYSCALL"
	fi
}

# @FUNCTION: _ot-kernel_set_multiuser
# @DESCRIPTION:
# Add compatibility for multiuser
_ot-kernel_set_multiuser() {
	if [[ -e "${EROOT}/var/db/pkg/acct-group" \
		|| -e "${EROOT}/var/db/pkg/acct-user" ]] ; then
einfo "Enabling multiuser / multigroup support"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_MULTIUSER"
	fi
}

# @FUNCTION: _ot-kernel_set_ipc_ns
# @DESCRIPTION:
# Enable IPC_NS and flag dependencies
_ot-kernel_set_ipc_ns() {
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_SYSVIPC"
	_ot-kernel_set_posix_mqueue
	ot-kernel_y_configopt "CONFIG_IPC_NS"
}

# @FUNCTION: _ot-kernel_set_pid_ns
# @DESCRIPTION:
# Enable PID_NS and flag dependencies
_ot-kernel_set_pid_ns() {
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_PID_NS"
}

# @FUNCTION: _ot-kernel_set_net_ns
# @DESCRIPTION:
# Enable NET_NS and flag dependencies
_ot-kernel_set_net_ns() {
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NET_NS"
}

# @FUNCTION: _ot-kernel_set_time_ns
# @DESCRIPTION:
# Enable TIME_NS and flag dependencies
_ot-kernel_set_time_ns() {
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_GENERIC_VDSO_TIME_NS"
	ot-kernel_y_configopt "CONFIG_TIME_NS"
}

# @FUNCTION: _ot-kernel_set_user_ns
# @DESCRIPTION:
# Enable USER_NS and flag dependencies
_ot-kernel_set_user_ns() {
	ot-kernel_y_configopt "CONFIG_NAMESPACES"
	ot-kernel_y_configopt "CONFIG_USER_NS"
}

# @FUNCTION: _ot-kernel_set_uts_ns
# @DESCRIPTION:
# Enable UTS_NS and flag dependencies
_ot-kernel_set_uts_ns() {
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

# @FUNCTION: _ot-kernel_set_io_uring
# @DESCRIPTION:
# Enable asynchronous IO using circular queue buffers
#
# See also:
#
#   https://en.wikipedia.org/wiki/Io_uring#Security
#
_ot-kernel_set_io_uring() {
	if [[ "${hardening_level}" =~ ("manual"|"custom") ]] ; then
		:;
	elif [[ "${hardening_level}" == "untrusted" \
		|| "${hardening_level}" == "untrusted-distant" ]] ; then
	# Increased security
		ot-kernel_unset_configopt "CONFIG_IO_URING"
	elif [[ "${hardening_level}" == "performance" \
		|| "${hardening_level}" == "trusted" ]] ; then
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_IO_URING"
	else
eerror
eerror "OT_KERNEL_HARDENING_LEVEL is invalid."
eerror
eerror "Acceptable values:  custom, manual, performance, trusted, untrusted, untrusted-distant"
eerror "Actual value:  ${hardening_level}"
eerror
		die
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
        ["digital-audio-workstation"]="audio"
        ["distributed-computing-server"]="server"
        ["distributed-computing-client"]="throughput-interactive"
        ["desktop-guest-vm"]="video"
        ["dvr"]="video"
        ["file-server"]="server"
        ["gamedev"]="throughput-interactive"
        ["gaming-guest-vm"]="input"
        ["gpu-gaming-laptop"]="input"
        ["green-hpc"]="power"
        ["green-pc"]="power"
        ["greenest-hpc"]="power"
        ["greenest-pc"]="power"
        ["jukebox"]="audio"
        ["laptop"]="power"
        ["live-streaming-gamer"]="input"
        ["live-video-reporting"]="audio"
        ["mainstream-desktop"]="video"
        ["manual"]="input" # placeholder
        ["media-player"]="video"
        ["media-server"]="server"
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
        ["realtime-hpc"]="jitter"
        ["renderfarm-dedicated"]="throughput-headless"
        ["renderfarm-workstation"]="throughput-interactive"
        ["sdr"]="audio"
        ["smartphone"]="power"
        ["smartphone-voice"]="audio"
        ["solar-desktop"]="input"
        ["solar-gaming"]="input"
        ["tablet"]="power"
        ["throughput-hpc"]="throughput"
        ["touchscreen-laptop"]="video"
        ["video-conferencing"]="audio"
        ["voip"]="audio"
        ["web-server"]="server"
        ["workstation"]="throughput-interactive"
)

# intermediate value -> canonical value without PREEMPT_RT
unset WORK_PROFILE_LATENCY_BIAS_SETTING
declare -A WORK_PROFILE_LATENCY_BIAS_SETTING=(
	["audio"]="CONFIG_PREEMPT"
	["input"]="CONFIG_PREEMPT"
	["jitter"]="CONFIG_PREEMPT"
	["power"]="CONFIG_PREEMPT_NONE"
	["server"]="CONFIG_PREEMPT_NONE"
	["throughput-headless"]="CONFIG_PREEMPT_NONE"
	["throughput-interactive"]="CONFIG_PREEMPT_VOLUNTARY"
	["video"]="CONFIG_PREEMPT_VOLUNTARY"
)

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
		ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
		ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
		if ot-kernel_use rt ; then
ewarn "The rt patchset is not compatible with ARCH=${arch}.  Forcing PREEMPT_NONE=y.  Remove rt from OT_KERNEL_USE to silence this error."
		fi
	else
		if ot-kernel_supports_rt && ot-kernel_use rt ; then
			if grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" ; then
	# Real time cannot be stopped or dropped.
				:;
			else
	# Promote/demote
				if [[ "${preempt_option}" == "CONFIG_PREEMPT" ]] ; then
					ot-kernel_y_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_NONE" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_RT" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_y_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_y_configopt "CONFIG_PREEMPT_VOLUNTARY"
				fi
			fi
		else
	# Non RT case
			if [[ \
				   "${preempt_option}" == "CONFIG_PREEMPT_RT" \
				|| "${preempt_option}" == "CONFIG_PREEMPT_AUTOMAGIC" \
			]] ; then
				local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
				local key="${WORK_PROFILE_LATENCY_BIAS_KEY[work_profile]}"
				if [[ \
					   "${work_profile}" == "custom" \
					|| "${work_profile}" == "manual" \
				]] ; then
					:;
				elif [[ -n "${key}" ]] ; then
	# Downgrade latency based on user hint
					local setting="${WORK_PROFILE_LATENCY_BIAS_SETTING[${key}]}"
					ot-kernel_y_configopt "${setting}"
					if [[ "${setting}" == "CONFIG_PREEMPT" ]] ; then
						ot-kernel_y_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
					elif [[ "${setting}" == "CONFIG_PREEMPT_NONE" ]] ; then
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
					elif [[ "${setting}" == "CONFIG_PREEMPT_RT" ]] ; then
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_y_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
					elif [[ "${setting}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
						ot-kernel_unset_configopt "CONFIG_PREEMPT"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
						ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
						ot-kernel_y_configopt "CONFIG_PREEMPT_VOLUNTARY"
					fi
				else
	# Downgrade
					ot-kernel_y_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				fi
			else
	# Promote/demote
				if [[ "${preempt_option}" == "CONFIG_PREEMPT" ]] ; then
					ot-kernel_y_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_NONE" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_y_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_RT" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_y_configopt "CONFIG_PREEMPT_RT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_VOLUNTARY"
				elif [[ "${preempt_option}" == "CONFIG_PREEMPT_VOLUNTARY" ]] ; then
					ot-kernel_unset_configopt "CONFIG_PREEMPT"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_NONE"
					ot-kernel_unset_configopt "CONFIG_PREEMPT_RT"
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
	elif grep -q -e "^CONFIG_PREEMPT_VOLUNTARY=y" "${path_config}" ; then
einfo "Using PREEMPT_VOLUNTARY"
	elif grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" ; then
einfo "Using PREEMPT_RT"
	fi
}

# @FUNCTION: _ot-kernel_y_thp
# @DESCRIPTION:
# Enables transparent huge pages
_ot-kernel_y_thp() {
	if   grep -q -e "^CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y" \
	&& ! grep -q -e "^CONFIG_PREEMPT_RT=y" "${path_config}" ; then
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
		if ot-kernel_use rt ; then
ewarn "Detected ${prio_class} package for ${pkg}.  Using PREEMPT_RT=y"
			ot-kernel_set_preempt "CONFIG_PREEMPT_RT"
		else
ewarn "Detected ${prio_class} package for ${pkg}.  Using PREEMPT=y"
			ot-kernel_set_preempt "CONFIG_PREEMPT"
		fi
	fi
}

# @FUNCTION: _ot-kernel_realtime_packages
# @DESCRIPTION:
# Change the kernel for realtime programs
_ot-kernel_realtime_packages() {
	# Boost based on profile
	local work_profile="${OT_KERNEL_WORK_PROFILE:-manual}"
	if [[ "${work_profile}" == "digital-audio-workstation" ]] ; then
		_ot-kernel_realtime_pkg "dev-lang/faust" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/libpulse" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/libsoundio" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/rtaudio" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/roc-toolkit" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/distrho-ports" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/ir_lv2" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-plugins/nekobi" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-plugins/x42-avldrums" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-plugins/x42-plugins" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/6pm" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/aeolus" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/amsynth" "SCHED_FIFO" # needs ebuild changes to explicitly enable
		_ot-kernel_realtime_pkg "media-sound/ardour" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/bristol" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/carla" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/csound" "SCHED_RR"
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
		_ot-kernel_realtime_pkg "media-sound/mpd" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/museseq" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/pulseaudio-daemon" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/pulseeffects" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/pure-data" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/rosegarden" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/sc3-plugins" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/seq24" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/sequencer64" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/supercollider" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/terminatorx" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/timidity++[alsa]" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/yoshimi" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-sound/zynaddsubfx[alsa]" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-video/pipewire" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "sys-apps/das_watchdog" "SCHED_RR" # Used in audio overlay
		_ot-kernel_realtime_pkg "sys-auth/rtkit" "SCHED_FIFO|SCHED_RR"
	fi
	if [[ \
		   "${work_profile}" == "radio-broadcaster" \
		|| "${work_profile}" == "live-video-reporting" \
		|| "${work_profile}" == "video-conferencing" \
		|| "${work_profile}" == "voip" \
	]] ; then
		_ot-kernel_realtime_pkg "media-libs/libtgvoip" "SCHED_FIFO|SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/portaudio" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/roc-toolkit" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-libs/tg_owt" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/webrtc-audio-processing" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-video/pipewire" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-voip/mumble" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "net-voip/umurmur" "SCHED_RR"
		_ot-kernel_realtime_pkg "net-voip/yate" "SCHED_FIFO|SCHED_RR"
		# _ot-kernel_realtime_pkg "net-voip/twinkle" "SCHED_FIFO" # present but disabled in source code
	fi

	if [[ "${work_profile}" == "jukebox" ]] ; then
		_ot-kernel_realtime_pkg "media-sound/mpg123" "SCHED_RR"
		_ot-kernel_realtime_pkg "media-sound/sndpeek" "SCHED_RR"
	fi

	if [[ "${work_profile}" == "sdr" ]] ; then
		_ot-kernel_realtime_pkg "net-wireless/gnuradio" "SCHED_FIFO|SCHED_RR"
	fi

	if [[ \
		   "${work_profile}" == "gpu-gaming-laptop" \
		|| "${work_profile}" == "pro-gaming" \
		|| "${work_profile}" == "solar-gaming" \
	]] ; then
		_ot-kernel_realtime_pkg "net-voip/mumble" "SCHED_FIFO"
		_ot-kernel_realtime_pkg "media-libs/openal" "SCHED_RR" # Assumes PREEMPT=y
	fi

	if [[ "${work_profile}" == "web-server" ]] ; then
		_ot-kernel_realtime_pkg "dev-php/hhvm" "SCHED_RR"
	fi

	# TODO:  create a work profile that demands realtime analysis
	# The question is but why?  Benefits?
	#_ot-kernel_realtime_pkg "net-analyzer/netdata" "SCHED_FIFO" # Disabled for security.

	#_ot-kernel_realtime_pkg "dev-db/mysql" "SCHED_FIFO|SCHED_RR" # contains realtime references, #718068

	# _ot-kernel_realtime_pkg "media-video/dvgrab" "SCHED_RR"
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
