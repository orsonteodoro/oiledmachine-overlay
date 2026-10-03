# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# @ECLASS: secure-kernel.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Mitigate side channel data tampering attacks
# @DESCRIPTION:
# This ebuild is to perform kernel checks on CPU hardware flaws that may
# cause a Denial of Service.
#
# See also https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability
#

# This eclass uses AI inference to clarify and be consistent with industry
# practice with respect to accepting and rejecting Wi-Fi driver packages.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_DT_ECLASS} ]] ; then
_MITIGATE_DT_ECLASS=1

inherit secure-version

_mitigate_dt_set_globals() {
	FIRMWARE_VENDOR=${FIRMWARE_VENDOR:-""}
	if [[ -z "${FIRMWARE_VENDOR}" ]] ; then
ewarn "FIRMWARE_VENDOR is unset."
ewarn "Set FIRMWARE_VENDOR in /etc/portage/make.conf or as a per-package environment variable for ${CATEGORY}/${PN}."
ewarn "Valid values:  amd, intel, misc"
	fi
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
		FIRMWARE_VENDOR="amd"
	fi
	if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
		FIRMWARE_VENDOR="intel"
	fi
}

_mitigate_dt_set_globals
unset -f _mitigate_dt_set_globals

# We like to delete all of the cpu_target_* but can't because the eclass doesn't
# do auto detect min required kernel via USE=auto.  The cpu_target_x86_* does
# more accurate pruning allowing for better LTS support.  The auto will just
# simplify and prune everything except the latest stable.

# Sometimes the mitigation is not backported to the older kernel series.  This
# is why the min is raised higher for certain microarches.

CPU_TARGET_X86=(
	cpu_target_x86_arrandale
	cpu_target_x86_clarkdale
	cpu_target_x86_gladden
	cpu_target_x86_lynnfield
	cpu_target_x86_bakerville
	cpu_target_x86_nehalem
	cpu_target_x86_nehalem
	cpu_target_x86_westmere
	cpu_target_x86_sandy_bridge
	cpu_target_x86_ivy_bridge
	cpu_target_x86_haswell
	cpu_target_x86_broadwell
	cpu_target_x86_hewitt_lake
	cpu_target_x86_skylake
	cpu_target_x86_kaby_lake_gen7
	cpu_target_x86_amber_lake_gen8
	cpu_target_x86_coffee_lake_gen8
	cpu_target_x86_kaby_lake_gen8
	cpu_target_x86_ice_lake
	cpu_target_x86_sapphire_rapids
	cpu_target_x86_sapphire_rapids_edge_enhanced
	cpu_target_x86_tiger_lake
	cpu_target_x86_alder_lake
	cpu_target_x86_catlow_golden_cove
	cpu_target_x86_rocket_lake
	cpu_target_x86_raptor_lake_gen13
	cpu_target_x86_raptor_lake_gen14
	cpu_target_x86_purley_refresh
	cpu_target_x86_cedar_island
	cpu_target_x86_greenlow
	cpu_target_x86_whitley
	cpu_target_x86_tatlow
	cpu_target_x86_eagle_stream
	cpu_target_x86_catlow_raptor_cove
	cpu_target_x86_idaville
	cpu_target_x86_whiskey_lake
	cpu_target_x86_coffee_lake_gen9
	cpu_target_x86_comet_lake
	cpu_target_x86_meteor_lake

	cpu_target_x86_cooper_lake
	cpu_target_x86_emerald_rapids

	cpu_target_x86_milan
	cpu_target_x86_milan-x
	cpu_target_x86_genoa
	cpu_target_x86_genoa-x
	cpu_target_x86_bergamo
	cpu_target_x86_zen_4
	cpu_target_x86_zen_3
	cpu_target_x86_zen_2
	cpu_target_x86_zen
	cpu_target_x86_naples
	cpu_target_x86_rome
	cpu_target_x86_siena
)

inherit linux-info toolchain-funcs

IUSE+="
	${CPU_TARGET_X86[@]}
	auto
	custom-kernel
	dss
	+enforce
	intel-microcode
	landlock
	linux-firmware
	kvm
	mseal
	spow
"
REQUIRED_USE="
	cpu_target_x86_arrandale? (
		intel-microcode
	)
	cpu_target_x86_clarkdale? (
		intel-microcode
	)
	cpu_target_x86_gladden? (
		intel-microcode
	)
	cpu_target_x86_lynnfield? (
		intel-microcode
	)
	cpu_target_x86_bakerville? (
		intel-microcode
	)
	cpu_target_x86_nehalem? (
		intel-microcode
	)
	cpu_target_x86_nehalem? (
		intel-microcode
	)
	cpu_target_x86_westmere? (
		intel-microcode
	)
	cpu_target_x86_sandy_bridge? (
		intel-microcode
	)
	cpu_target_x86_ivy_bridge? (
		intel-microcode
	)
	cpu_target_x86_haswell? (
		intel-microcode
	)
	cpu_target_x86_broadwell? (
		intel-microcode
	)
	cpu_target_x86_hewitt_lake? (
		intel-microcode
	)
	cpu_target_x86_skylake? (
		intel-microcode
	)
	cpu_target_x86_kaby_lake_gen7? (
		intel-microcode
	)
	cpu_target_x86_amber_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_coffee_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_kaby_lake_gen8? (
		intel-microcode
	)
	cpu_target_x86_ice_lake? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		intel-microcode
	)
	cpu_target_x86_tiger_lake? (
		intel-microcode
	)
	cpu_target_x86_sapphire_rapids? (
		intel-microcode
	)
	cpu_target_x86_alder_lake? (
		intel-microcode
	)
	cpu_target_x86_catlow_golden_cove? (
		intel-microcode
	)
	cpu_target_x86_rocket_lake? (
		intel-microcode
	)
	cpu_target_x86_raptor_lake_gen13? (
		intel-microcode
	)
	cpu_target_x86_raptor_lake_gen14? (
		intel-microcode
	)

	cpu_target_x86_purley_refresh? (
		intel-microcode
	)
	cpu_target_x86_cedar_island? (
		intel-microcode
	)
	cpu_target_x86_greenlow? (
		intel-microcode
	)
	cpu_target_x86_tatlow? (
		intel-microcode
	)
	cpu_target_x86_whiskey_lake? (
		intel-microcode
	)
	cpu_target_x86_coffee_lake_gen9? (
		intel-microcode
	)
	cpu_target_x86_comet_lake? (
		intel-microcode
	)
	cpu_target_x86_cooper_lake? (
		intel-microcode
	)
	cpu_target_x86_emerald_rapids? (
		intel-microcode
	)
	cpu_target_x86_meteor_lake? (
		intel-microcode
	)
	cpu_target_x86_idaville? (
		intel-microcode
	)

	cpu_target_x86_milan? (
		linux-firmware
	)
	cpu_target_x86_milan-x? (
		linux-firmware
	)
	cpu_target_x86_genoa? (
		linux-firmware
	)
	cpu_target_x86_genoa-x? (
		linux-firmware
	)
	cpu_target_x86_bergamo? (
		linux-firmware
	)
	cpu_target_x86_naples? (
		linux-firmware
	)
	cpu_target_x86_rome? (
		linux-firmware
	)
	cpu_target_x86_siena? (
		linux-firmware
	)
"

is_lts() {
	local kv="${1}"
	local x
	for x in ${LTS_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 0
		fi
	done
	return 1
}

is_stable_or_mainline_version() {
	local kv="${1}"
	local x
	for x in ${STABLE_OR_MAINLINE_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 0
		fi
	done
	return 1
}

is_eol() {
	local kv="${1}"
	local x
	for x in ${ACTIVE_VERSIONS[@]} ; do
		local s1=$(ver_cut 1-2 ${kv})
		local s2=$(ver_cut 1-2 ${x})
		if ver_test ${s1} -eq ${s2} ; then
			return 1
		fi
	done
	return 0
}

# These are usually disabled because they are not well maintained on time compared to upstream.
# Many of these are flood the zone ebuilds with vulnerabilies.
DISABLED_FLAVORS=(
	#
	# During this time (Oct 1, 2026), the behind x releases are based on the following version snapshot:
	#
	# live: ce1e0223d8ad4211275c82a17ed6d43ab81e13d9 (2026-10-01 12:47:16 -0700)
	# 7.3-rc5
	# 7.2.8
	# 7.1.13 [EOL]
	# 6.18.54
	# 6.12.111
	# 6.6.157
	# 6.1.188
	# 5.15.221
	# 5.10.270
	# next-20261001
	#

	"sys-kernel/amneziawg-sources" # Out of date, behind a year
	"sys-kernel/barrensea-kernel" # Out of date, 6.12 behind 84 releases, 6.15 behind 219 release
	"sys-kernel/calculate-sources" # Behind 1 point release
	"sys-kernel/clear-sources" # EOL 6.10
	"sys-kernel/dappersec-sources" # EOL 4.9
	"sys-kernel/fake-sources" # Stub
	"sys-kernel/femkvm-kernel" # 6.18 behind 19 releases
	"sys-kernel/femxen-kernel" # 6.18 behind 19 releases
	"sys-kernel/gentoo-cjk-kernel" # Not reviewed yet
	"sys-kernel/gentoo-cjk-kernel-bin" # Not reviewed yet
	"sys-kernel/gentoo-cjk-sources" # Not reviewed yet
	"sys-kernel/gentoo-kernel-ps3" # 6.12 behind 95 releases, 66 behind 90 releases
	"sys-kernel/gentoo-sources-image" # EOL 4.19
	"sys-kernel/gnumach" # Not supported on oiledmachine-overlay, experimental quality
	"sys-kernel/neptune-kernel" # 7.2 behind 4 releases, 6.18 behind 4 releases, EOL 6.16
	"sys-kernel/neptune-sources" # 7.2 behind 4 releases, 6.18 behind 4 releases, EOL 6.16
	"sys-kernel/odroidc4-sources" # EOL 5.11
	"sys-kernel/pentoo-sources" # Behind 1 point release
	"sys-kernel/pf-sources-extended" # EOL 6.19 or earlier
	"sys-kernel/reiser4-sources" # EOL 5.16 and earlier
	"sys-kernel/rockchip-kernel-bin" # 6.1 behind 145 releases for that revision
	"sys-kernel/rockchip-sources"
	"sys-kernel/rocm-sources" # EOL 5.11 and and earlier
	"sys-kernel/rpi-kernel" # Duplicate
	"sys-kernel/torvalds-sources" # Duplicate
	"sys-kernel/uek-sources" # 5.15 not updated since Jul 2024
	"sys-kernel/void-sources-bin" # EOL 5.3 and earlier
	"sys-kernel/void-sources-headers-bin"
	"sys-kernel/vserver-sources" # EOL 4.9 and earlier
	"sys-kernel/wireless-testing" # Not updated since Jul 2025
	"sys-kernel/wsl2-kernel" # Behind 43 point releases
	"sys-kernel/xanmod-apparmor-sources" # EOL 6.0
)

# TODO:  Consider the red-team USE flag to allow access to restricted pentest driver.

# If not needed, the kernel modules are disabled or removed when in a dss state.
# We allow hardware based display, network, storage drivers but reject the others.
DSS_DISABLED_DRIVERS=(
# See also ot-kernel-pkgflags_has_external_module in eclass/ot-kernel-pkgflags.eclass for some kernel modules package names.
# TODO add missing out-of-tree drivers
# AI prompt used to filter:  for <pkg> is this kernel driver essential or non essential for data security (dss) or enterprise audit? is the driver allowed or disallowed?

	#
	# Rank for what Wi-Fi driver is acceptable or rejected:
	#
	# 1. In kernel - Acceptable
	# 2. From distro or OS repo - Acceptable
	# 3. Direct from manufactuer - Restricted
	# 4. Independent (e.g. GitHub repos) - Rejected unless signed and code reviewed
	#

	# Referencing independent repo (e.g. GitHub) for Wi-Fi driver will be
	# rejected by auditor, but if directly from the manufacturer it is
	# accepted.

	# Disabled packages
	"app-admin/ryzen_smu"
	"app-antivirus/lkrg"
	"app-antivirus/tyton"
	"app-backup/tsm"
	"app-crypt/tpm-emulator"
	"app-emulation/la-ow-syscall"
	"app-emulation/vendor-reset"
	"app-emulation/virtualbox"
	"app-emulation/virtualbox-guest-additions"
	"app-emulation/virtualbox-modules"
	"app-emulation/vmware-modules"
	"app-forensics/kjackal"
	"app-forensics/prochunter"
	"app-laptop/framework-laptop-kmod"
	"app-laptop/system76-acpi-module"
	"app-laptop/system76-io-module"
	"app-laptop/system76-module"
	"app-laptop/tp_smapi"
	"app-laptop/tuxedo-drivers"
	"app-laptop/tuxedo-keyboard"
	"bluetooth-drivers/rtbth"
	"dev-debug/scap-driver"
	"dev-libs/gdrcopy"
	"dev-libs/xdna-driver"
	"dev-util/lttng-modules"
	"dev-util/sysdig-kmod"
	"games-util/hid-nintendo"
	"games-util/xone"
	"games-util/xpadneo"
	"media-libs/svgalib"
	"media-sound/netcat-cpi"
	"media-tv/v4l-dvb-saa716x"
	"media-video/droidcam"
	"media-video/v4l2loopback"
	"net-analyzer/pkt-netflow"
	"net-dialup/accel-ppp"
	"net-firewall/ipset"
	"net-firewall/ipt_netflow"
	"net-firewall/ipt-ratelimit"
	"net-firewall/pkt_netflow"
	"net-firewall/rtsp-conntrack"
	"net-firewall/xtables-addons"
	"net-firewall/xt_dns"
	"net-firewall/xt_nat"
	"net-misc/AQtion"
	"net-misc/dahdi"
	"net-misc/ena-driver"
	"net-misc/openvswitch"
	"net-misc/r8125" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/r8126" # Independent repo, not directly from manufacturer
	"net-misc/r8152" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/r8168" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/realtek-r8152" # Not listed in zugaina
	"net-misc/realtek-rtl88x2bu" # Independent repo, see notes above
	"net-vpn/amneziawg"
	"net-vpn/amneziawg-module"
	"net-vpn/amneziawg-modules"
	"net-vpn/ovpn-dco"
	"net-vpn/wireguard-modules"
	"net-wireless/broadcom-wl" # References independent repo, not directly from manufacturer, see notes above
	"net-wireless/mt7610u_ulli-kroll" # Old driver
	"net-wireless/mt7927-dkms" # Independent repo, see notes above
	"net-wireless/rtw88" # Independent repo, see notes above
	"net-wireless/rt3070" # Not listed on zugaina
	"net-wireless/rtl8192eu" # Independent repo, see notes above
	"net-wireless/rtl8723bu" # Independent repo, see notes above
	"net-wireless/rtl8812au" # For pentesting, not for production
	"net-wireless/rtl8812au_aircrack-ng" # For pentesting, not for production
	"net-wireless/rtl8814au" # Independent repo, see notes above
	"net-wireless/rtl8821au" # Independent repo, see notes above
	"net-wireless/rtl8821ce" # EOL
	"net-wireless/rtl8821cu" # For pentesting, not for production
	"net-wireless/rtl8822bu" # EOL
	"net-wireless/rtl88x2bu_morrownr" # Can be used for pentesting but with limitations
	"sci-libs/linux-gpib"
	"sci-libs/linux-gpib-modules"
	"sci-ni/ni_p2p_dkms"
	"sys-apps/openrazer"
	"sys-apps/smc-sum"
	"sys-cluster/knem"
	"sys-cluster/lustre"
	"sys-cluster/xpmem"
	"sys-firmware/lenovolegionlinux"
	"sys-fs/bcachefs-kmod"
	"sys-fs/bcachefs-tools"
	"sys-fs/exfat-nofuse"
	"sys-fs/linux-apfs-rw"
	"sys-fs/linux-ntfs-kmod" # Dedupe, the in-kernel NTFS driver is more preferred for audit.
	"sys-fs/loop-aes" # Less audited compared to dm-crypt/LUKS with AES; not FIPS certified
	"sys-fs/scoutfs"
	"sys-fs/vhba"
	"sys-kernel/amdgpu-dkms" # rocm-7.2.4 not updated since Apr 2026.  therock-10.0 not updated since Aug 2026.
	"sys-kernel/acpi-stuff"
	"sys-kernel/cm-psu"
	"sys-kernel/compat-drivers"
	"sys-kernel/cryptodev"
	"sys-kernel/fragattacks-drivers58"
	"sys-kernel/ft60x_driver"
	"sys-kernel/gasket-driver"
	"sys-kernel/gostcrypt-linux-crypto"
	"sys-kernel/it87"
	"sys-kernel/jupiter-dkms" # Driver not updated since Sep 2024
	"sys-kernel/kpatch" # Currently not supported on the oiledmachine-overlay because of no provider for security update service.  Reboot remediation has a bigger benefit compared to live remediation.
	"sys-kernel/legion-wmi"
	"sys-kernel/msi-ec"
	"sys-kernel/nct6687d"
	"sys-kernel/pcc"
	"sys-kernel/pf_ring-kmod"
	"sys-kernel/rock-dkms" # rocm-6.3.3 not updated since Feb 2025.
	"sys-kernel/rte_kni-kmod"
	"sys-kernel/rtl8822ce-driver" # Independent repo, see notes above
	"sys-kernel/rtl88x2bu-driver" # For pentesting only, not for production
	"sys-kernel/scx"
	"sys-kernel/scx-loader"
	"sys-kernel/tirdad"
	"sys-kernel/ummunotify"
	"sys-kernel/zenergy" # Driver not updated since Aug 2025
	"sys-kernel/zenpower" # Not updated since 2020
	"sys-kernel/zenpower3" # Repo not accessible
	"sys-kernel/zenpower5" # Not updated since Jan 2026
	"sys-kernel/zenstats"
	"sys-power/acer-wmi-battery"
	"sys-power/acpi_call"
	"sys-power/bbswitch"
	"sys-power/nct6687d"
	"sys-power/phc-intel"
	"sys-power/tuxedo-cc-wmi"
	"sys-process/atop"
	"sys-process/falco-bin"
	"x11-drivers/evdi"
	"x11-misc/openrazer"

	# Allowed packages
	#"net-fs/openafs"
	#"net-wireless/aic8800"
	#"net-wireless/broadcom-sta"
	#"sys-fs/zfs" # Userland utils
	#"sys-fs/zfs-kmod"
	#"x11-drivers/nvidia-drivers"
)

SPOW_DISABLED_DRIVERS=(
	# TODO:  audit each package

	#
	# Policy
	#
	# Security fixes in commit history within 4 years:  acceptable
	# No security fixes in commit history within 4 years:  rejected
	#

	# Disabled packages
	"app-admin/ryzen_smu"
	"app-antivirus/lkrg"
	"app-antivirus/tyton"
	"app-backup/tsm"
	"app-crypt/tpm-emulator"
	"app-emulation/la-ow-syscall"
	"app-emulation/vendor-reset"
	"app-emulation/virtualbox"
	"app-emulation/virtualbox-guest-additions"
	"app-emulation/virtualbox-modules"
	"app-emulation/vmware-modules"
	"app-forensics/kjackal"
	"app-forensics/prochunter"
	"app-laptop/framework-laptop-kmod"
	"app-laptop/system76-acpi-module"
	"app-laptop/system76-io-module"
	"app-laptop/system76-module"
	"app-laptop/tp_smapi"
	"app-laptop/tuxedo-drivers"
	"app-laptop/tuxedo-keyboard"
	"bluetooth-drivers/rtbth"
	"dev-debug/scap-driver"
	"dev-libs/gdrcopy"
	"dev-libs/xdna-driver"
	"dev-util/lttng-modules"
	"dev-util/sysdig-kmod"
	"games-util/hid-nintendo"
	"games-util/xone"
	"games-util/xpadneo"
	"media-libs/svgalib"
	"media-sound/netcat-cpi"
	"media-tv/v4l-dvb-saa716x"
	"media-video/droidcam"
	"media-video/v4l2loopback"
	"net-analyzer/pkt-netflow"
	"net-dialup/accel-ppp"
	"net-firewall/ipset"
	"net-firewall/ipt_netflow"
	"net-firewall/ipt-ratelimit"
	"net-firewall/pkt_netflow"
	"net-firewall/rtsp-conntrack"
	"net-firewall/xtables-addons"
	"net-firewall/xt_dns"
	"net-firewall/xt_nat"
	"net-fs/openafs"
	"net-misc/AQtion"
	"net-misc/dahdi"
	"net-misc/ena-driver"
	"net-misc/openvswitch"
	"net-misc/r8125" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/r8126" # Independent repo, not directly from manufacturer
	"net-misc/r8152" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/r8168" # References independent repo, not directly from manufacturer, see notes above
	"net-misc/realtek-r8152" # Not listed in zugaina
	"net-misc/realtek-rtl88x2bu" # Independent repo, see notes above
	"net-vpn/amneziawg"
	"net-vpn/amneziawg-module"
	"net-vpn/amneziawg-modules"
	"net-vpn/ovpn-dco"
	"net-vpn/wireguard-modules"
	"net-wireless/aic8800"
	"net-wireless/broadcom-sta"
	"net-wireless/broadcom-wl" # References independent repo, not directly from manufacturer, see notes above
	"net-wireless/mt7610u_ulli-kroll" # Old driver
	"net-wireless/mt7927-dkms" # Independent repo, see notes above
	"net-wireless/rtw88" # Independent repo, see notes above
	"net-wireless/rt3070" # Not listed on zugaina
	"net-wireless/rtl8192eu" # Independent repo, see notes above
	"net-wireless/rtl8723bu" # Independent repo, see notes above
	"net-wireless/rtl8812au" # For pentesting, not for production
	"net-wireless/rtl8812au_aircrack-ng" # For pentesting, not for production
	"net-wireless/rtl8814au" # Independent repo, see notes above
	"net-wireless/rtl8821au" # Independent repo, see notes above
	"net-wireless/rtl8821ce" # EOL
	"net-wireless/rtl8821cu" # For pentesting, not for production
	"net-wireless/rtl8822bu" # EOL
	"net-wireless/rtl88x2bu_morrownr" # Can be used for pentesting but with limitations
	"sci-libs/linux-gpib"
	"sci-libs/linux-gpib-modules"
	"sci-ni/ni_p2p_dkms"
	"sys-apps/openrazer"
	"sys-apps/smc-sum"
	"sys-cluster/knem"
	"sys-cluster/lustre"
	"sys-cluster/xpmem"
	"sys-firmware/lenovolegionlinux"
	"sys-fs/bcachefs-kmod"
	"sys-fs/bcachefs-tools"
	"sys-fs/exfat-nofuse"
	"sys-fs/linux-apfs-rw"
	"sys-fs/linux-ntfs-kmod" # Dedupe, the in-kernel NTFS driver is more preferred for audit.
	"sys-fs/loop-aes" # Less audited compared to dm-crypt/LUKS with AES; not FIPS certified
	"sys-fs/scoutfs"
	"sys-fs/vhba"
	"sys-kernel/amdgpu-dkms" # rocm-7.2.4 not updated since Apr 2026.  therock-10.0 not updated since Aug 2026.
	"sys-kernel/acpi-stuff"
	"sys-kernel/cm-psu"
	"sys-kernel/compat-drivers"
	"sys-kernel/cryptodev"
	"sys-kernel/fragattacks-drivers58"
	"sys-kernel/ft60x_driver"
	"sys-kernel/gasket-driver"
	"sys-kernel/gostcrypt-linux-crypto"
	"sys-kernel/it87"
	"sys-kernel/jupiter-dkms" # Driver not updated since Sep 2024
	"sys-kernel/kpatch" # Currently not supported on the oiledmachine-overlay because of no provider for security update service.  Reboot remediation has a bigger benefit compared to live remediation.
	"sys-kernel/legion-wmi"
	"sys-kernel/msi-ec"
	"sys-kernel/nct6687d"
	"sys-kernel/pcc"
	"sys-kernel/pf_ring-kmod"
	"sys-kernel/rock-dkms" # rocm-6.3.3 not updated since Feb 2025.
	"sys-kernel/rte_kni-kmod"
	"sys-kernel/rtl8822ce-driver" # Independent repo, see notes above
	"sys-kernel/rtl88x2bu-driver" # For pentesting only, not for production
	"sys-kernel/scx"
	"sys-kernel/scx-loader"
	"sys-kernel/tirdad"
	"sys-kernel/ummunotify"
	"sys-kernel/zenergy" # Driver not updated since Aug 2025
	"sys-kernel/zenpower" # Not updated since 2020
	"sys-kernel/zenpower3" # Repo not accessible
	"sys-kernel/zenpower5" # Not updated since Jan 2026
	"sys-kernel/zenstats"
	"sys-power/acer-wmi-battery"
	"sys-power/acpi_call"
	"sys-power/bbswitch"
	"sys-power/nct6687d"
	"sys-power/phc-intel"
	"sys-power/tuxedo-cc-wmi"
	"sys-process/atop"
	"sys-process/falco-bin"
	"x11-drivers/evdi"
	"x11-misc/openrazer"

	# Allowed packages
	"sys-fs/zfs" # Userland utils
	"sys-fs/zfs-kmod"
	"x11-drivers/nvidia-drivers"
)

# One reason why source based packages are only allowed because the unused
# ciphers need to be disabled.
DSS_FLAVORS=(
	#
	# Rank for kernel sources acceptability according to AI (corporate slop):
	#
	# 1. OS / distro - acceptable
	# 2. Direct / upstream - conditional
	# 3. Independent - rejected
	#

	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/linux-next" # 9999
	"sys-kernel/vanilla-sources" # 7.1.3
)

DSS_FLAVORS_REJ=(
	"sys-kernel/asahi-kernel" # 7.0.12_p1
	"sys-kernel/asahi-sources" # 7.0.9_p2
	"sys-kernel/cachyos-kernel" # 7.0.12-r1, 7.0.12, 7.0.12_p1, 7.2_rc1_p1, 7.2_rc2
	"sys-kernel/cachyos-kernel-bin" # 7.1.2-r2, 7.0.12
	"sys-kernel/cachyos-sources" # 7.1.3, 7.1.2-r2
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/hardened-sources" # 7.1.2, 4.3.3-r5
	"sys-kernel/liquorix-sources" # 7.0.14_p2, 6.6.8
	"sys-kernel/mips-sources" # 5.4.294
	"sys-kernel/pf-sources" # 7.0_p4
	"sys-kernel/ot-sources" # 7.1.3, 7.3.9999
	"sys-kernel/raspberrypi-image" # 9999, 6.18.32_p20260521
	"sys-kernel/raspberrypi-sources" # 6.18.32_p20260521
	"sys-kernel/rt-sources" # 7.0.1_p2
	"sys-kernel/surface-sources" # 7.0.5
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/xanmod-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/xanmod-rt" # 6.12.31
	"sys-kernel/xanmod-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/xanmod-sources-rt" # 6.1.13
	"sys-kernel/zen-sources" # 7.1.2, 7.1.3_p1
)

SPOW_FLAVORS=(
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/hardened-sources" # 7.1.2, 4.3.3-r5
	"sys-kernel/linux-next" # 9999
	"sys-kernel/ot-sources" # 7.1.3, 7.3.9999
)

SPOW_FLAVORS_REJ=(
	"sys-kernel/asahi-kernel" # 7.0.12_p1
	"sys-kernel/asahi-sources" # 7.0.9_p2
	"sys-kernel/cachyos-kernel" # 7.0.12-r1, 7.0.12, 7.0.12_p1, 7.2_rc1_p1, 7.2_rc2
	"sys-kernel/cachyos-kernel-bin" # 7.1.2-r2, 7.0.12
	"sys-kernel/cachyos-sources" # 7.1.3, 7.1.2-r2
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/liquorix-sources" # 7.0.14_p2, 6.6.8
	"sys-kernel/mips-sources" # 5.4.294
	"sys-kernel/pf-sources" # 7.0_p4
	"sys-kernel/raspberrypi-image" # 9999, 6.18.32_p20260521
	"sys-kernel/raspberrypi-sources" # 6.18.32_p20260521
	"sys-kernel/rt-sources" # 7.0.1_p2
	"sys-kernel/surface-sources" # 7.0.5
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/vanilla-sources" # 7.1.3
	"sys-kernel/xanmod-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/xanmod-rt" # 6.12.31
	"sys-kernel/xanmod-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/xanmod-sources-rt" # 6.1.13
	"sys-kernel/zen-sources" # 7.1.2, 7.1.3_p1
)

FLAVORS=(
	"sys-kernel/asahi-kernel" # 7.0.12_p1
	"sys-kernel/asahi-sources" # 7.0.9_p2
	"sys-kernel/cachyos-kernel" # 7.0.12-r1, 7.0.12, 7.0.12_p1, 7.2_rc1_p1, 7.2_rc2
	"sys-kernel/cachyos-kernel-bin" # 7.1.2-r2, 7.0.12
	"sys-kernel/cachyos-sources" # 7.1.3, 7.1.2-r2
	"sys-kernel/gentoo-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/gentoo-kernel-bin" # 7.1.3, 7.1.2_p1, 6.18.38
	"sys-kernel/gentoo-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/git-sources" # 7.2_rc2
	"sys-kernel/hardened-sources" # 7.1.2, 4.3.3-r5
	"sys-kernel/linux-next" # 9999
	"sys-kernel/liquorix-sources" # 7.0.14_p2, 6.6.8
	"sys-kernel/mips-sources" # 5.4.294
	"sys-kernel/ot-sources" # 7.1.3
	"sys-kernel/pf-sources" # 7.0_p4
	"sys-kernel/raspberrypi-image" # 9999, 6.18.32_p20260521
	"sys-kernel/raspberrypi-sources" # 6.18.32_p20260521
	"sys-kernel/rt-sources" # 7.0.1_p2
	"sys-kernel/surface-sources" # 7.0.5
	"sys-kernel/vanilla-kernel" # 7.1.3, 6.18.9999
	"sys-kernel/vanilla-sources" # 7.1.3
	"sys-kernel/xanmod-kernel" # 7.1.3, 7.1.2_p1
	"sys-kernel/xanmod-rt" # 6.12.31
	"sys-kernel/xanmod-sources" # 7.1.3, 7.1.2-r1
	"sys-kernel/xanmod-sources-rt" # 6.1.13
	"sys-kernel/zen-sources" # 7.1.2, 7.1.3_p1
)

FLAVORS_MAJOR_MINOR=(
)

FLAVORS_POINT_RELEASE=(
	"sys-kernel/cachyos-kernel"
	"sys-kernel/cachyos-kernel-bin"
	"sys-kernel/cachyos-sources"
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
	"sys-kernel/gentoo-sources"
	"sys-kernel/hardened-sources"
	"sys-kernel/liquorix-sources"
	"sys-kernel/mips-sources"
	"sys-kernel/ot-sources"
	"sys-kernel/surface-sources"
	"sys-kernel/vanilla-sources"
	"sys-kernel/xanmod-kernel"
	"sys-kernel/xanmod-rt"
	"sys-kernel/xanmod-sources"
	"sys-kernel/xanmod-sources-rt"
	"sys-kernel/zen-sources"
)

FLAVORS_POST_3C_RELEASE=(
	"sys-kernel/asahi-kernel"
	"sys-kernel/asahi-sources"
	"sys-kernel/cachyos-kernel"
	"sys-kernel/gentoo-kernel"
	"sys-kernel/gentoo-kernel-bin"
	"sys-kernel/liquorix-sources"
	"sys-kernel/raspberrypi-image"
	"sys-kernel/raspberrypi-sources"
	"sys-kernel/rt-sources"
	"sys-kernel/xanmod-kernel"
	"sys-kernel/zen-sources"
)

FLAVORS_POST_2C_RELEASE=(
	"sys-kernel/pf-sources"
)

FLAVORS_RC=(
	"sys-kernel/cachyos-kernel"
	"sys-kernel/git-sources"
)

# 9999 only
FLAVORS_LIVE_9999=(
	"sys-kernel/linux-next"
	"sys-kernel/raspberrypi-image"
)

# Stable live only, 6.18.9999
FLAVORS_STABLE_LIVE=(
	"sys-kernel/vanilla-kernel"
)

# 7.3.9999 only
FLAVORS_LIVE_SLOT_9999=(
	"sys-kernel/ot-sources"
)

# @FUNCTION: _seq
# @DESCRIPTION:
# Generates a sequence
# Example:
# _seq 1 5 -> 1 2 3 4
_seq()
{
	local a=${1}
	local b=${2}
	local i
	for ((i=${a}; i<${b}; i+=1)); do
	    echo "${i}"
	done
}

is_flavor() {
	local filter="${1}"
	local flavor="${2}"

	local L=()
	if [[ "${filter}" =~ "dss" ]] ; then
		L=( "${DSS_FLAVORS[@]}" )
	elif [[ "${filter}" =~ "spow" ]] ; then
		L=( "${SPOW_FLAVORS[@]}" )
	fi

	local x
	for x in "${L[@]}" ; do
		[[ "${x}" == "${flavor}" ]] && return 0
	done
	return 1
}

DSS_MIN_SLOT="6.12"
LANDLOCK_MIN_SLOT="5.13"
MSEAL_MIN_SLOT="6.10"
SPOW_MIN_SLOT="6.12"
gen_render_x_list_v2_iuse() {
	local x_min_ver="${1}"
	local x_cond_operator="${2}"
	local x_not_operator="${3}"
	local x_filter_rule="${4}"
	local iuse_list=""
	local eol_list=""
	local o
	local pv
	local x
	local y

	if [[ -n "${CUSTOM_KERNEL_ATOM}" && -z "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" ]] ; then
eerror
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES must be defined when using CUSTOM_KERNEL_ATOM."
eerror
eerror "Valid values:"
eerror
eerror "point-release - ex. 7.1.1"
eerror "post-3c - ex. 7.1.1_p2"
eerror "post-2c - ex. 7.1_p2"
eerror "rc - ex. 7.1_rc1"
eerror "live-9999 - ex. 9999"
eerror "live-slot-9999 - ex. 7.1.9999"
eerror
eerror "Example:"
eerror
eerror "CUSTOM_KERNEL_ATOM=\"sys-kernel/xanmod-kernel\""
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES=\"point-release|post-3c\""
eerror
		die
	fi

	# CUSTOM_KERNEL_ATOM_VERSIONING_STYLES valid values
	# Example:  CUSTOM_KERNEL_ATOM_VERSIONING_STYLES="point-release|post-3c|post-2c|rc|live-9999|live-slot-9999"
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "point-release" ]] ; then
		FLAVORS_POINT_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-3c" ]] ; then
		FLAVORS_POST_3C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-2c" ]] ; then
		FLAVORS_POST_2C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "rc" ]] ; then
		FLAVORS_RC+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-9999" ]] ; then
		FLAVORS_LIVE_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-slot-9999" ]] ; then
		FLAVORS_LIVE_SLOT_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi

	# 7.2.3
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
				local pn="${x#*/}"
				if is_flavor "${filter}" "${x}" ; then
					ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
					iuse_list+="
						${x_not_operator}kernel_targets_${pn}_${slot}
					"
				elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			done
		else
			for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				local pn="${x#*/}"
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			done
		fi
	done

	# 7.2.3_p1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
				local pn="${x#*/}"
				if is_flavor "${filter}" "${x}" ; then
					ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
					iuse_list+="
						${x_not_operator}kernel_targets_${pn}_${slot}
					"
				elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			done
		else
			for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				local pn="${x#*/}"
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			done
		fi
	done

	# 7.2_p1
	for pv in "${ACTIVE_VERSIONS[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
				local pn="${x#*/}"
				if is_flavor "${filter}" "${x}" ; then
					ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
					iuse_list+="
						${x_not_operator}kernel_targets_${pn}_${slot}
					"
				elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
					iuse_list+="
						!kernel_targets_${pn}_${slot}
					"
				fi
			done
		else
			for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				local pn="${x#*/}"
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}
				"
			done
		fi
	done

	# 7.3_rc1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] || continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			for x in "${FLAVORS_RC[@]}" ; do
				local pn="${x#*/}"
				if is_flavor "${filter}" "${x}" ; then
					ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
					iuse_list+="
						${x_not_operator}kernel_targets_${pn}_rc
					"
				elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
					iuse_list+="
						!kernel_targets_${pn}_rc
					"
				fi
			done
		else
			for x in "${FLAVORS_RC[@]}" ; do
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				local pn="${x#*/}"
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_rc
				"
			done
		fi
	done

	# 6.18.9999, stable live
	for pv in "${ACTIVE_VERSIONS[@]}" ; do
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_LTS_SLOT}" && continue
		ver_test "${slot_pv}" "-gt" "${KERNEL_MAX_LTS_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			for x in "${FLAVORS_STABLE_LIVE[@]}" ; do
				local pn="${x#*/}"
				if is_flavor "${filter}" "${x}" ; then
					ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
					iuse_list+="
						${x_not_operator}kernel_targets_${pn}_${slot}_live
					"
				elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
					iuse_list+="
						!kernel_targets_${pn}_${slot}_live
					"
				fi
			done
		else
			for x in "${FLAVORS_STABLE_LIVE[@]}" ; do
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				local pn="${x#*/}"
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_${slot}_live
				"
			done
		fi
	done

	# 7.3.9999
	for x in "${FLAVORS_LIVE_SLOT_9999[@]}" ; do
		local pn="${x#*/}"
		local slot_pv="${KERNEL_LIVE_SLOT}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			if is_flavor "${filter}" "${x}" ; then
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_live
				"
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				iuse_list+="
					!kernel_targets_${pn}_live
				"
			fi
		else
			ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
			iuse_list+="
				${x_not_operator}kernel_targets_${pn}_live
			"
		fi
	done

	# 9999 only
	for x in "${FLAVORS_LIVE_9999[@]}" ; do
		local pn="${x#*/}"
		local pv="9999"
		local slot_pv="${KERNEL_LIVE_SLOT}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		if [[ "${x_filter_rule}" =~ ("dss"|"spow") ]] ; then
			local filter=""
			[[ "${x_filter_rule}" =~ "dss" ]] && filter="dss"
			[[ "${x_filter_rule}" =~ "spow" ]] && filter="spow"
			if is_flavor "${filter}" "${x}" ; then
				ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
				iuse_list+="
					${x_not_operator}kernel_targets_${pn}_live
				"
			elif [[ "${x_filter_rule}" == "dss-reject" ]] ; then
				iuse_list+="
					!kernel_targets_${pn}_live
				"
			fi
		else
			ver_test "${slot_pv}" "${x_cond_operator}" "${x_min_ver}" && continue
			iuse_list+="
				${x_not_operator}kernel_targets_${pn}_live
			"
		fi
	done

	# IUSE list
	o="
		${iuse_list}
	"
	echo "${o}"
#einfo "IUSE list:"
#einfo "${o}"
}

IUSE_KERNELS=( $(gen_render_x_list_v2_iuse "${KERNEL_MIN_SLOT}" '-lt' '') )

# For the rejection, it has to be >= KERNEL_MIN_SLOT and sometimes KERNEL_MIN_LTS_SLOT <= x <= KERNEL_MAX_LTS_SLOT.
IUSE_DSS=( $(gen_render_x_list_v2_iuse "${DSS_MIN_SLOT}" '-lt' '' 'dss-accept') )
IUSE_DSS_REJ=( $(gen_render_x_list_v2_iuse "${DSS_MIN_SLOT}" '-ge' '!' 'dss-reject') )
IUSE_LANDLOCK=( $(gen_render_x_list_v2_iuse "${LANDLOCK_MIN_SLOT}" '-lt' '') )
IUSE_LANDLOCK_REJ=( $(gen_render_x_list_v2_iuse "${LANDLOCK_MIN_SLOT}" '-ge' '!') )
IUSE_MSEAL=( $(gen_render_x_list_v2_iuse "${MSEAL_MIN_SLOT}" '-lt' '') )
IUSE_MSEAL_REJ=( $(gen_render_x_list_v2_iuse "${MSEAL_MIN_SLOT}" '-ge' '!') )
IUSE_SPOW=( $(gen_render_x_list_v2_iuse "${SPOW_MIN_SLOT}" '-lt' '' 'spow-accept') )
IUSE_SPOW_REJ=( $(gen_render_x_list_v2_iuse "${SPOW_MIN_SLOT}" '-ge' '!' 'spow-reject') )

IUSE+="
	${IUSE_KERNELS[@]}
"
REQUIRED_USE+="
	?? (
		dss
		spow
	)
	enforce? (
		!dss? (
			!spow? (
				|| (
					${IUSE_KERNELS[@]}
				)
			)
		)
		dss? (
			|| (
				${IUSE_DSS[@]}
			)
			${IUSE_DSS_REJ[@]}
		)
		landlock? (
			|| (
				${IUSE_LANDLOCK[@]}
			)
			${IUSE_LANDLOCK_REJ[@]}
		)
		mseal? (
			|| (
				${IUSE_MSEAL[@]}
			)
			${IUSE_MSEAL_REJ[@]}
		)
		spow? (
			|| (
				${IUSE_SPOW[@]}
			)
			${IUSE_SPOW_REJ[@]}
		)
	)
"

gen_render_disabled_flavors() {
	local x
	local kernels=""
	for x in "${DISABLED_FLAVORS[@]}" ; do
		kernels+="
			!${x}
		"
	done
	echo "
		${kernels}
	"
}

gen_render_disabled_drivers() {
	local x
	local context="${1}"
	local packages=""

	local L=()
	if [[ "${context}" == "dss" ]] ; then
		L=( "${DSS_DISABLED_DRIVERS[@]}" )
	elif [[ "${context}" == "spow" ]] ; then
		L=( "${SPOW_DISABLED_DRIVERS[@]}" )
	else
eerror "Unsupported context for gen_render_disabled_drivers"
eerror "context: ${context}"
		die
	fi

	for x in "${L[@]}" ; do
		packagess+="
			!${x}
		"
	done
	echo "
		${packagess}
	"
}

gen_render_kernels_list_v2() {
	local acceptable_list=""
	local eol_list=""
	local landlock_list=""
	local mseal_list=""
	local o
	local pv
	local x
	local y

	if [[ -n "${CUSTOM_KERNEL_ATOM}" && -z "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" ]] ; then
eerror
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES must be defined when using CUSTOM_KERNEL_ATOM."
eerror
eerror "Valid values:"
eerror
eerror "point-release - ex. 7.1.1"
eerror "post-3c - ex. 7.1.1_p2"
eerror "post-2c - ex. 7.1_p2"
eerror "rc - ex. 7.1_rc1"
eerror "live-9999 - ex. 9999"
eerror "live-slot-9999 - ex. 7.1.9999"
eerror
eerror "Example:"
eerror
eerror "CUSTOM_KERNEL_ATOM=\"sys-kernel/xanmod-kernel\""
eerror "CUSTOM_KERNEL_ATOM_VERSIONING_STYLES=\"point-release|post-3c\""
eerror
		die
	fi

	# CUSTOM_KERNEL_ATOM_VERSIONING_STYLES valid values
	# Example:  CUSTOM_KERNEL_ATOM_VERSIONING_STYLES="point-release|post-3c|post-2c|rc|live-9999|live-slot-9999"
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "point-release" ]] ; then
		FLAVORS_POINT_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-3c" ]] ; then
		FLAVORS_POST_3C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "post-2c" ]] ; then
		FLAVORS_POST_2C_RELEASE+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "rc" ]] ; then
		FLAVORS_RC+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-9999" ]] ; then
		FLAVORS_LIVE_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi
	if [[ -n "${CUSTOM_KERNEL_ATOM}" && "${CUSTOM_KERNEL_ATOM_VERSIONING_STYLES}" =~ "live-slot-9999" ]] ; then
		FLAVORS_LIVE_SLOT_9999+=(
			${CUSTOM_KERNEL_ATOM}
		)
	fi

	for slot in "${EOL_VERSIONS[@]}" ; do
		for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
			[[ -z "${x}" ]] && continue
			eol_list+="
				!=${x}-${slot}*
			"
		done
	done

	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		local dots="${pv//[^.]}"
		n_dots=${#dots}
		[[ "${pv}" =~ "rc" ]] && continue
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			if (( ${n_dots} == 2 )) && (( ${pv##*.} >= 1 )) ; then
				# if 7.1.1 or newer:
				#   delete 7.1_rc*, 7.1, 7.1_p*, 7.1.0, 7.1.0_p*
				eol_list+="
					!=${x}-${pv%.*}_rc*
					!~${x}-${pv%.*}
					!=${x}-${pv%.*}_p*
					!~${x}-${pv%.*}.0
					!=${x}-${pv%.*}.0_p*
				"
			fi
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!~${x}-${pv%.*}.${y}
				"
			done
		done
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			local _pv=$(ver_cut 1-3 "${pv}")
			if (( ${n_dots} == 2 )) && (( ${_pv##*.} >= 1 )) ; then
				# if 7.1.1_p0 or newer:
				#   delete 7.1_rc*, 7.1, 7.1_p*, 7.1.0, 7.1.0_p*
				eol_list+="
					!=${x}-${pv%.*}_rc*
					!~${x}-${pv%.*}
					!=${x}-${pv%.*}_p*
					!~${x}-${pv%.*}.0
					!=${x}-${pv%.*}.0_p*
				"
			fi
			for y in $(_seq 1 ${pv##*.}) ; do
				eol_list+="
					!=${x}-${pv%.*}.${y}_p*
				"
			done
		done
	done

	# 7.2.3
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		for x in "${FLAVORS_POINT_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					~${x}-${pv}
				)
			"
		done
	done

	# 7.2.3_p1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		for x in "${FLAVORS_POST_3C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					=${x}-${pv}_p*
				)
			"
		done
	done

	# 7.2_p1
	for pv in "${ACTIVE_VERSIONS[@]}" ; do
		[[ "${pv}" =~ "rc" ]] && continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		for x in "${FLAVORS_POST_2C_RELEASE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}? (
					=${x}-${slot_pv}_p*
				)
			"
		done
	done

	# 7.3_rc1
	for pv in "${MULTISLOT_LATEST_KERNEL_RELEASE[@]}" ; do
		[[ "${pv}" =~ "rc" ]] || continue
		local slot_pv=$(ver_cut "1-2" "${pv}")
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		for x in "${FLAVORS_RC[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_rc? (
					~${x}-${pv}
				)
			"
		done
	done

	# 6.18.9999
	for pv in "${ACTIVE_VERSIONS[@]}" ; do
		local slot_pv=$(ver_cut "1-2" "${pv}")
		local slot="${slot_pv/./_}"
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_SLOT}" && continue
		ver_test "${slot_pv}" "-lt" "${KERNEL_MIN_LTS_SLOT}" && continue
		ver_test "${slot_pv}" "-gt" "${KERNEL_MAX_LTS_SLOT}" && continue
		for x in "${FLAVORS_STABLE_LIVE[@]}" ; do
			local pn="${x#*/}"
			acceptable_list+="
				kernel_targets_${pn}_${slot}_live? (
					=${x}-${slot_pv}.9999
				)
			"
		done
	done

	# 7.3.9999
	for x in "${FLAVORS_LIVE_SLOT_9999[@]}" ; do
		local pn="${x#*/}"
		acceptable_list+="
			kernel_targets_${pn}_live? (
				=${x}-${KERNEL_LIVE_SLOT}.9999
			)
		"
	done

	# 9999 only
	for x in "${FLAVORS_LIVE_9999[@]}" ; do
		local pn="${x#*/}"
		acceptable_list+="
			kernel_targets_${pn}_live? (
				=${x}-9999
			)
		"
	done

	# landlock is for PT mitigation
	for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
		[[ -z "${x}" ]] && continue
		landlock_list+="
			!<${x}-${LANDLOCK_MIN_SLOT}
		"
	done

	# mseal is for RCE mitigation
	for x in "${FLAVORS[@]}" ${CUSTOM_KERNEL_ATOM} ; do
		[[ -z "${x}" ]] && continue
		mseal_list+="
			!<${x}-${MSEAL_MIN_SLOT}
		"
	done

	# landlock list
	o="
		landlock? (
			${landlock_list}
		)
	"
	echo "${o}"

	# mseal list
	o="
		mseal? (
			${mseal_list}
		)
	"
	echo "${o}"

	# EOL list
	o="
		${eol_list}
	"
	echo "${o}"
#einfo "EOL list:"
#einfo "${o}"

	# Acceptable list
	o="
		${acceptable_list}
	"
	echo "${o}"
#einfo "Acceptable list:"
#einfo "${o}"
}

_use() {
	local arg="${1}"
	local L=(
		${USE}
	)
	local x
	for x in ${L[@]} ; do
		if [[ "${x}" == "${arg}" ]] ; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION: _check_kernel_cmdline
# @INTERNAL
# @DESCRIPTION:
# Checks the kernel command line for the option.
_check_kernel_cmdline() {
	local option="${1}"
	local cl=$(linux_chkconfig_string "CMDLINE")
	if [[ "${cl}" =~ "${option}" ]] ; then
		return 0
	fi
	if grep -q "${option}" "/etc/default/grub" ; then
		return 0
	fi
	if grep -q "${option}" "/etc/grub.d/40_custom" ; then
		return 0
	fi
	return 1
}

# @FUNCTION: _secure-kernel_get_fallback_version
# @DESCRIPTION:
# Get the fallback version when no microarches selected
_secure-kernel_get_fallback_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		echo "5.4"
	fi
}

# @FUNCTION: _secure-kernel_get_required_version
# @DESCRIPTION:
# Get the required kernel version for custom-kernel.
_secure-kernel_get_required_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
		; then
			echo "5.4"
		fi
	fi
}

# @FUNCTION: secure-kernel_pkg_setup
# @DESCRIPTION:
# Check the kernel config
secure-kernel_pkg_setup() {
	if tc-is-cross-compiler && use auto ; then
eerror "The auto USE flag can only be used in native builds."
		die
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
	fi
}

fi
