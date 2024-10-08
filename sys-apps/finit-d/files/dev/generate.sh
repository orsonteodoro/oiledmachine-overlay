#!/bin/bash

# This script will convert OpenRC service scripts or systemd configs into finit
# configuration file and wrapper script.

FINIT_COND_NETWORK=${FINIT_COND_NETWORK:-"net/route/default"}
FINIT_SCRIPT_SOURCE=${FINIT_SCRIPT_SOURCE:-"openrc"}
FINIT_SHELL=${FINIT_SHELL:-"/bin/sh"}

# 1 means process all overlays for every init discovered for tarball
# distribution.
# 0 means process only /etc/init.d for local installs.
MAINTAINER_MODE=${MAINTAINER_MODE:-0}

is_respawnable() {
	local svc_name="${1}"
	local s
	for s in ${FINIT_RESPAWNABLE} ; do
		[[ "${s}" == "${svc_name}" ]] && return 0
	done
	return 1
}

die() {
	echo "${1}"
	exit 1
}

is_instance_svc() {
	local svc="$1"

	local instance_svcs=(
		"net@" # Try symlink to net@<interface>.conf ; no pidfile instance suffix required since oneshot
		"openvpn@"
		"vsftpd@"
		"wg-quick@"
	)

	local x
	for x in ${instance_svcs[@]} ; do
		[[ "${svc}" == "${x}" ]] && return 0
	done
	return 1
}

convert_openrc() {
	rm -rf confs || die "ERR:  line number - $LINENO"
	mkdir -p confs || die "ERR:  line number - $LINENO"
	rm -rf scripts || die "ERR:  line number - $LINENO"
	mkdir -p scripts || die "ERR:  line number - $LINENO"

	CONFS_PATH="$(pwd)/confs"
	NEEDS_NET_PATH="$(pwd)/needs_net.txt"
	NEEDS_DBUS_PATH="$(pwd)/needs_dbus.txt"
	PKGS_PATH="$(pwd)/pkgs.txt"
	SCRIPTS_PATH="$(pwd)/scripts"
	SERVICES_PATH="$(pwd)/services.txt"

	echo > "${PKGS_PATH}" || die "ERR:  line number - $LINENO"
	echo > "${SERVICES_PATH}" || die "ERR:  line number - $LINENO"
	echo > "${NEEDS_NET_PATH}" || die "ERR:  line number - $LINENO"
	echo > "${NEEDS_DBUS_PATH}" || die "ERR:  line number - $LINENO"

	cd "${SCRIPTS_PATH}" || die "ERR:  line number - $LINENO"
	local overlays=()
	if [[ -e "/usr/portage" ]] ; then
		overlays+=(
			"/usr/portage"
		)
	fi
	if [[ -e "/var/db/repos" ]] ; then
		overlays+=(
			$(realpath /var/db/repos/*)
		)
	fi
	if [[ -n "${CUSTOM_OVERLAY_LIST}" ]] ; then
	# Example:  CUSTOM_OVERLAY_LIST="/usr/portage /var/db/repos/guru"
		overlays+=(
			${FINIT_CUSTOM_OVERLAY_LIST}
		)
	fi

	unset service_types
	declare -A service_types

	unset service_names
	declare -A service_names

if [[ "${MAINTAINER_MODE}" != 1 ]] ; then
	overlays=( "run-once" )
fi
	for overlay in ${overlays[@]} ; do
		local init_paths=()
if [[ "${MAINTAINER_MODE}" == 1 ]] ; then
		echo "Processing ${overlay} overlay"
		cd "${overlay}" || die "ERR:  line number - $LINENO"
		init_paths=(
			$(grep -F -l '#!/sbin/openrc-run' $(find ./ -name "*init*"))
		)
else
		script_dir="/etc/init.d"
		echo "Processing ${script_dir}"
		cd "${script_dir}" || die "ERR:  line number - $LINENO"
		init_paths=(
			$(find ./ -type f)
		)
fi

		local t=()
		t=( $(echo "${L[@]}" | tr " " "\n" | sort | uniq) )
		L=( ${t[@]} )

		for init_path in ${init_paths[@]} ; do
if [[ "${MAINTAINER_MODE}" == 1 ]] ; then
			local c=$(echo "${init_path}" | cut -f 2 -d "/")
			local pn=$(echo "${init_path}" | cut -f 3 -d "/")
			init_path=$(realpath "${overlay}/${init_path}")
else
			[[ "${init_path}" == "./" ]] && continue
			local pkg=$(grep -l $(realpath "${script_dir}/${init_path}") $(realpath "/var/db/pkg/"*"/"*"/CONTENTS") | cut -f 5-6 -d "/")
			if [[ ! -f $(realpath "/var/db/pkg/${pkg}/environment.bz2") ]] ; then
				local c="unknown"
				local pn="unknown"
				pkg="${c}/${pn}"
				echo "Missing environment.bz2 for pkg:${pkg} for ${init_path}"
			else
				local c=$(bzcat "/var/db/pkg/${pkg}/environment.bz2" | grep "declare -x CATEGORY=" | cut -f 2 -d '"')
				local pn=$(bzcat "/var/db/pkg/${pkg}/environment.bz2" | grep "declare -x PN=" | cut -f 2 -d '"')
			fi
			init_path=$(realpath "${script_dir}/${init_path}")
fi
			[[ -f "${init_path}" ]] || continue
			[[ "${init_path}" =~ ".ebuild"$ ]] && continue
			[[ "${init_path}" =~ ".patch"$ ]] && continue
			[[ "${c}/${pn}" = "metadata/md5-cache" ]] && continue
			local fn=$(basename "${init_path}")

			grep -q "#!/sbin/openrc-run" "${init_path}" || continue

if [[ "${MAINTAINER_MODE}" == 1 ]] ; then
			# Variations
			# Exact set
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z-]+)-[0-9]+-r[0-9]+\.initd$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z]+)-[0-9.]+-r[0-9]+\.initd$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^[0-9.]+-([a-z]+)\.init-r[0-9]+$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d\.([A-Za-z]+)-r[0-9]+$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.init-r[0-9]+\.d$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d\.([a-z]+)\.[0-9]+$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d-${pn}-r[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+-[0-9.]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z_-]+)-r[0-9]+\.initd$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-r[0-9]+\.initd$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-${pn}-[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-initd-r[0-9]$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}[0-9]+.initd$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+[a]$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}.init[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-r[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init-r[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init-[0-9.]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.${pn}$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}_initd$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.rc$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init.d$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init$|${pn}|g") || die "ERR:  line number - $LINENO"
			# Inexact set
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+[a]-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^rc_${pn}-r[0-9]+$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-[0-9.]+-init\.d-||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|${pn}d\.initd$|${pn}d|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|${pn}\.initd$|${pn}|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|([a-z])\.initd$|\1|g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d-[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d\.[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init\.d$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd\.[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d-r[0-9]$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_initd-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-r[0-9]+\.init$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-initd$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.init$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9]+\.init$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init-r[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.ng$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init-[0-9]+$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init[0-9]+||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-new$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|.initscript$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d_||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initrc$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init$||g") || die "ERR:  line number - $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init$||g") || die "ERR:  line number - $LINENO"

			# Init script fragments.  Needs manual evaluation
			[[ "${init_path}" =~ "qemu-binfmt" ]] && continue

			if [[ "${init_path}" =~ "app-admin/supervisor" ]] && echo "${fn}" | grep -q -E -e "init\.d-r[0-9]+" ; then
				fn="supervisord"
			elif [[ "${init_path}" =~ "app-forensics/aide" ]] && echo "${fn}" | grep -q -E -e "aideinit" ; then
				continue
			elif [[ "${init_path}" =~ "dev-db/mysql-init-scripts" ]] && echo "${fn}" | grep -q -E -e "init\.d-[0-9.]+" ; then
				fn="mysql"
			elif [[ "${init_path}" =~ "dev-db/mysql-init-scripts" ]] && echo "${fn}" | grep -q -E -e "init\.d-s6-[0-9.]+" ; then
				fn="mysql-s6"
			elif [[ "${init_path}" =~ "dev-db/mysql-init-scripts" ]] && echo "${fn}" | grep -q -E -e "init\.d-supervise-[0-9.]+" ; then
				fn="mysql-supervise"
#			elif [[ "${init_path}" =~ "dev-ruby/rubygems" ]] && echo "${fn}" | grep -q -E -e "init.d-gem_server2" ; then
#				fn="gem_server"
#			elif [[ "${init_path}" =~ "mail-filter/MailScanner" ]] && echo "${fn}" | grep -q -E -e "initd.mailscanner" ; then
#				fn="MailScanner"
			elif [[ "${init_path}" =~ "net-dns/dnsmasq" ]] && echo "${fn}" | grep -q -E -e "dnsmasq-init-dhcp-r[0-9]+" ; then
				echo "${fn} could be clobbering"
				# FIXME resolve clobbered cases
				fn="dnsmasq"
			elif [[ "${init_path}" =~ "sys-apps/dbus" ]] && echo "${fn}" | grep -q -E -e "dbus.initd.in" ; then
				fn="${pn}"
			elif [[ "${init_path}" =~ "sys-apps/preload" ]] && echo "${fn}" | grep -q -E -e "preload-[0-9.]+\.init\.in-r[0-9]+" ; then
				fn="${pn}"
			elif [[ "${init_path}" =~ "sys-cluster/torque" ]] && echo "${fn}" | grep -q -E -e "-init\.d-munge" ; then
				fn=$(echo "${fn}" | sed -r -e "s|-init\.d-munge$||g")
			elif [[ "${init_path}" =~ "sys-fs/iprutils" ]] && echo "${fn}" | grep -q -E -e "-r[0-9]+" ; then
				fn=$(echo "${fn}" | sed -r -e "s|-r[0-9]+$||g")
			fi

			fn=$(echo "${fn}" | sed -r -e "s|^init\.d-||g")
			fn=$(echo "${fn}" | sed -r -e "s|^initd\.||g")

			if [[ "${fn}" =~ "iprinit" ]] ; then
				:
			elif [[ "${fn}" =~ "htbinit" ]] ; then
				:
			elif [[ "${fn}" =~ "cbqinit" ]] ; then
				:
			elif [[ "${fn}" =~ "vboxinit" ]] ; then
				:
			elif [[ "${fn}" =~ "init" ]] ; then
				echo "${init_path} needs a case.  fn = ${fn}"
				exit 1
			fi
fi

			# TODO: rtorrent instancing
			if [[ "${fn}" == "net.lo" ]] ; then
				fn="net@"
			elif [[ "${fn}" == "openvpn" ]] ; then
				fn="openvpn@"
			elif [[ "${fn}" == "vsftpd" ]] ; then
				fn="vsftpd@"
			elif [[ "${fn}" == "wg-quick" ]] ; then
				fn="wg-quick@"
			fi

			mkdir -p "${SCRIPTS_PATH}/${c}/${pn}"
			local init_sh="${SCRIPTS_PATH}/${c}/${pn}/${fn}.sh"
			echo "Converting ${init_path} -> ${init_sh}"
			echo "${c}/${pn}" >> "${PKGS_PATH}"
			echo "${pn}" >> "${SERVICES_PATH}"

			# Disabled replace if newer
			#if [[ -e "${init_sh}" ]] ; then
			#	continue
			#fi

			cat "${init_path}" > "${init_sh}"
			perl -pe 's/\\\n//' -i "${init_sh}" # Remove hardbreak

			if [[ "${init_path}" =~ "sys-apps/dbus" ]] && echo "${fn}" | grep -q -E -e "dbus.initd.in" ; then
				sed -i -e "s|@rundir@|/run|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			# ln = line number
			local top_ln_copyright_notice=$(grep -n "# Distributed under" "${init_sh}" | cut -f 1 -d ":")
			local top_ln_shebang=$(grep -n "#!/sbin/openrc-run" "${init_sh}" | cut -f 1 -d ":")
			local top_ln=""
			if [[ -n "${top_ln_copyright_notice}" ]] ; then
				top_ln="${top_ln_copyright_notice}"
			else
				top_ln="${top_ln_shebang}"
			fi
			sed -i -e "${top_ln}a . /lib/finit/scripts/lib/lib.sh" "${init_sh}" || die "ERR:  line number - $LINENO"
			local svc_name=$(basename "${init_path}")
			svc_name=$(echo "${svc_name}" | sed -e "s|\.sh$||g")
			if [[ "${svc_name}" == "net.lo" ]] ; then
				svc_name="net@"
			elif [[ "${svc_name}" == "openvpn" ]] ; then
				svc_name="openvpn@"
			elif [[ "${svc_name}" == "vsftpd" ]] ; then
				svc_name="vsftpd@"
			elif [[ "${svc_name}" == "wg-quick" ]] ; then
				svc_name="wg-quick@"
			fi

			local instance=""
			local instance_desc=""
			local instance_pid_suffix=""
			if is_instance_svc "${svc_name}" ; then
				instance_pid_suffix="@%i"
				instance=":%i"
				instance_desc=" for %i"
			fi

			if [[ "${svc_name}" =~ "net@" ]] ; then
				sed -i -e "${top_ln}a export RC_SVCNAME=\${RC_SVCNAME:-\"net.\${2}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			elif [[ -n "${instance}" ]] ; then
			# svc_name may have @
				sed -i -e "${top_ln}a [ -n \"\${2}\" ] && export RC_SVCNAME=\${RC_SVCNAME:-\"${svc_name}.\${2}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a [ -z \"\${2}\" ] && export RC_SVCNAME=\${RC_SVCNAME:-\"${svc_name}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			else
				sed -i -e "${top_ln}a export RC_SVCNAME=\${RC_SVCNAME:-\"${svc_name}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			# Mostly chronological order...
			# banner     ; pre [S]
			# rootfs_up  ; post /
			# mount_err  ; current/partial mount -a
			# mount_post ; post mount -a
			# basefs_up  ; post /swap
			# svc_plugin ; pre finit.conf
			# network_up ; post [S]
			# svc_up     ; post [current]
			# system_up  ; finit.d/* started

			if grep -q -E -e "before.* (checkfs|fsck)( |$)" "${init_path}" ; then
			# It includes dmcrypt.
				sed -i -e "${top_ln}a hook_rootfs_up_fn=\"start\"" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a hook_system_dn_fn=\"stop\"" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a uses_hooks=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			elif grep -q -E -e "before.* net( |$)" "${init_path}" ; then
				sed -i -e "${top_ln}a hook_basefs_up_fn=\"start\"" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a uses_hooks=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			if ! grep -q -e "^start[(]" "${init_sh}" ; then
				sed -i -e "${top_ln}a export call_default_start=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi
			if ! grep -q -e "^stop[(]" "${init_sh}" ; then
				sed -i -e "${top_ln}a export call_default_stop=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi
			if [[ "${svc_name}" =~ "net@" ]] ; then
				sed -i -e "${top_ln}a export SVCNAME=\${SVCNAME:-\"net.\${2}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			elif [[ -n "${instance}" ]] ; then
			# svc_name may have @
				sed -i -e "${top_ln}a [ -n \"\${2}\" ] && export SVCNAME=\${SVCNAME:-\"${svc_name}.\${2}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a [ -z \"\${2}\" ] && export SVCNAME=\${SVCNAME:-\"${svc_name}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			else
				sed -i -e "${top_ln}a export SVCNAME=\${SVCNAME:-\"${svc_name}\"}" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			local bottom_ln=$(cat "${init_sh}" | wc -l)
			sed -i -e "${bottom_ln}a . /lib/finit/scripts/lib/event.sh" "${init_sh}" || die "ERR:  line number - $LINENO"

			sed -i -e "s|#!/sbin/openrc-run|#!${FINIT_SHELL}|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "s|rc-service|rc_service|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "s|start-stop-daemon|start_stop_daemon|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "s|supervise-daemon|supervise_daemon|g" "${init_sh}" || die "ERR:  line number - $LINENO"

			# Fixes
			sed -i \
				-e "s|supervisor:-start_stop_daemon|supervisor:-start-stop-daemon|g" \
				-e "s|supervisor:-supervise_daemon|supervisor:-supervise-daemon|g" \
				-e "s|supervisor:=start_stop_daemon|supervisor:=start-stop-daemon|g" \
				-e "s|supervisor:=supervise_daemon|supervisor:=supervise-daemon|g" \
				-e "s|supervisor=start_stop_daemon|supervisor=start-stop-daemon|g" \
				-e "s|supervisor=supervise_daemon|supervisor=supervise-daemon|g" \
				"${init_sh}" || die "ERR:  line number - $LINENO"

			local needs_syslog=0
			local start_runlevels=""
			local extra_runlevels=""
			if grep -q -E -e "before.* (checkfs|fsck)( |$)" "${init_path}" ; then
			# It includes dmcrypt
				start_runlevels="S"
				extra_runlevels="12345"
			elif grep -q -E -e "before.* net( |$)" "${init_path}" ; then
				start_runlevels="S"
				extra_runlevels="345"
			elif grep -q -E -e "provide.* logger( |$)" "${init_path}" ; then
				start_runlevels="S12345"
				extra_runlevels="12345"
			elif \
				   grep -q -E -e "after.* net( |$)" "${init_path}" \
				|| grep -q -E -e "need.* net( |$)" "${init_path}" \
				|| grep -q -E -e "provide.* net( |$)" "${init_path}" \
				|| grep -q -E -e "use.* (dns|net)( |$)" "${init_path}" \
				|| [[ "${svc_name}" == "avahi-daemon" ]] \
				|| [[ "${svc_name}" == "bitlbee" ]] \
				|| [[ "${svc_name}" == "cups-browsed" ]] \
				|| [[ "${svc_name}" == "pppoe-server" ]] \
				|| [[ "${svc_name}" == "pure-ftpd" ]] \
				|| [[ "${svc_name}" == "pure-uploadscript" ]] \
				|| [[ "${svc_name}" =~ "pydoc-" ]] \
			; then
				start_runlevels="345"
				extra_runlevels="345"
				echo "${c}/${pn}" >> "${NEEDS_NET_PATH}"
			else
				start_runlevels="2345"
				extra_runlevels="2345"
			fi

			if grep -q -e "need.*dbus" "${init_path}" ; then
				echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
			fi

			local svcs=(
				$(grep -o -E -r "^[[:space:]]+need [ 0-9a-zA-Z_-]+" "${init_path}" \
					| sed -E -e "s|[[:space:]]+| |g" -e "s| need ||g")
			)
			if [[ "${FINIT_SOFT_DEPS_MANDATORY}" == "1" ]] ; then
				svcs+=(
					$(grep -o -E -r "^[[:space:]]+use [ 0-9a-zA-Z_-]+" "${init_path}" \
						| sed -E -e "s|[[:space:]]+| |g" -e "s| use ||g")
					$(grep -o -E -r "^[[:space:]]+want [ 0-9a-zA-Z_-]+" "${init_path}" \
						| sed -E -e "s|[[:space:]]+| |g" -e "s| want ||g")
				)
			fi

			local start_cond=""
			local svc
			for svc in ${svcs[@]} ; do
				[[ "${svc}" == "dbus" ]] && continue
				[[ "${svc}" == "hostname" ]] && continue
				[[ "${svc}" == "localmount" ]] && continue
				[[ "${svc}" == "s6-svscan" ]] && continue
				[[ "${svc}" == "udev" ]] && continue
				if echo "${start_cond}" | grep -q -E "pid/${svc}(,|$)" ; then
					# Dedupe
					continue
				fi
				if [[ "${svc}" == "net" ]] ; then # meta-category
					start_cond="${start_cond},${FINIT_COND_NETWORK}"
				else
					start_cond="${start_cond},pid/${svc}"
				fi
			done

			if [[ "${svc_name}" == "acpid" ]] ; then
				start_cond="${start_cond},service/logger/running"
			fi

			if [[ "${start_cond:0:1}" == "," ]] ; then
				start_cond="${start_cond:1}"
			fi

			mkdir -p "${CONFS_PATH}/${c}/${pn}"
			local init_conf="${CONFS_PATH}/${c}/${pn}/${svc_name}.conf"
			echo "Generating ${c}/${pn}/${svc_name}.conf"
			cat /dev/null > "${init_conf}"

			local pid_file=""
			local pid_file_instanced=""
			if [[ "${svc_name}" == "sysklogd" ]] ; then
				pid_file="pid:/run/${pn}.pid"
				sed -i -e "${top_ln}a export do_exec=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			elif grep -q -e "--make-pidfile" "${init_path}" ; then
				pid_file="pid:!/run/${pn}.pid"
			fi

			local create_pid=0
			if grep -E -q -e '(--make-pidfile|start_stop_daemon.*-m |command_background=["]?true|command_background=["]?1)' "${init_path}" ; then
				# It means call exec.
				create_pid=1
			fi

			# Only systemd style of instancing with @ is supported by finit.


			# .conf doesn't support variable expansion in pid:

# Most services should have a pidfile except for oneshot equivalent.
			local notify=""
			if [[ "${svc_name}" == "actkbd" ]] ; then
				pid_file="pid:!/var/run/actkbd.pid"
				notify="notify:pid"
echo "pidfile case -2:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "avahi-daemon" ]] ; then
				pid_file="pid:!/run/avahi-daemon/pid"
				notify="notify:pid"
echo "pidfile case -1:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "avahi-dnsconfd" ]] ; then
				pid_file="pid:!/run/avahi-dnsconfd.pid"
				notify="notify:pid"
echo "pidfile case 0:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "bitcoind" ]] ; then
				pid_file="pid:!/run/bitcoind/bicoind.pid"
				notify="notify:pid"
echo "pidfile case 1:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "display-manager" ]] ; then
				if grep -q -E -o "DISPLAYMANAGER.*" /etc/conf.d/display-manager ; then
					local dm=$(grep -E -o "DISPLAYMANAGER.*" "/etc/conf.d/display-manager" | cut -f 2 -d '"')
					if [[ "${dm}" == "kdm" || "${dm}" == "kde" ]] ; then
						pid_file="pid:!/run/kdm.pid"
					elif [[ "${dm}" =~ "entrance" ]] ; then
						pid_file="pid:!/run/entrance.pid"
					elif [[ "${dm}" == "gdm" || "${dm}" == "gnome" ]] ; then
						if [[ -f "/usr/sbin/gdm" ]] ; then
							pid_file="pid:!/run/gdm/gdm.pid"
						else
							pid_file="pid:!/run/gdm.pid"
						fi
					elif [[ "${dm}" == "greetd" ]] ; then
						pid_file="pid:!/run/greetd.pid"
					elif [[ "${dm}" == "wdm" ]] ; then
						pid_file="pid:!/usr/bin/wdm"
					elif [[ "${dm}" == "gpe" ]] ; then
						pid_file="pid:!/run/gpe-dm.pid"
					elif [[ "${dm}" == "lxdm" ]] ; then
						pid_file="pid:!/run/lxdm.pid"
					elif [[ "${dm}" == "lightdm" ]] ; then
						pid_file="pid:!/run/lightdm.pid"
					elif [[ "${dm}" == "sddm" ]] ; then
						pid_file="pid:!/run/sddm.pid"
					else
						pid_file="pid:!/run/${dm}.pid"
					fi
				fi
				notify="notify:pid"
echo "pidfile case 2:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "mysql-s6" || "${svc_name}" == "mysql" ]] ; then
				if bzcat "/var/db/pkg/dev-db/mysql-"*"/environment.bz2" | grep -q PN=\"mysql\" ; then
					pid_file="pid:!/var/run/mysqld/mysql.pid"
				elif bzcat "/var/db/pkg/dev-db/mariadb-"*"/environment.bz2" | grep -q PN=\"mariadb\" ; then
					pid_file="pid:!/var/run/mysqld/mariadb.pid"
				fi
				notify="notify:pid"
echo "pidfile case 3:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" =~ "openvpn" ]] ; then
				pid_file_instanced="pid:/run/openvpn.%i.pid"
				pid_file="pid:/run/openvpn.pid"
				notify="notify:pid"
echo "pidfile case 4:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "squid" ]] ; then
				pid_file="pid:!/run/squid.pid"
				notify="notify:pid"
echo "pidfile case 5:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" == "tox-dht-daemon" ]] ; then
				pid_file="pid:!/run/tox-bootstrapd/tox-bootstrapd.pid"
				notify="notify:pid"
echo "pidfile case 6:  init_path - ${init_path} ; ${pid_file}"
			elif [[ "${svc_name}" =~ "vsftpd" ]] ; then
				path_instanced="/run/vsftpd.%i.pid"
				pid_file_instanced="pid:!${path_instanced}"

				path="/run/vsftpd.pid"
				pid_file="pid:!${path}"

				notify="notify:pid"
echo "pidfile case 7:  init_path - ${init_path} ; ${pid_file}"
			elif grep -q -E -e '^pidfile=["]?[$].*:-' "${init_path}" ; then
				local path=$(grep -E -e '^pidfile=["]?[$].*:-' "${init_path}" | cut -f 2 -d "-" | sed -e 's|["]||g' -e 's|}$||g')
				if (( ${create_pid} == 1 )) ; then
					# Case:  pidfile=${PKG_PIDFILE:-/run/service.pid}
					# Case:  pidfile="${PIDFILE:-/run/service.pid}"
					# start-stop-daemon ... --make-pidfile
					pid_file="pid:!${path}"
				else
					# Case:  pidfile=${PKG_PIDFILE:-/run/service.pid}
					# start-stop-daemon ...
					pid_file="pid:!${path}"
				fi
				notify="notify:pid"
echo "pidfile case 8:  init_path - ${init_path} ; pid_file=${pid_file}"
			elif grep -q -E -e '^pidfile=["]?[$][{].*[}]["]?$' "${init_path}" ; then
				# Case:  pidfile="${PKG_PIDFILE}"
				# Any value can be used for PKG_PIDFILE if
				# : ${PKG_PIDFILE:=/run/${svc_name}.pid}
				local varname=$(grep -E -e '^pidfile=["]?[$][{].*[}]["]?$' "${init_path}" | cut -f 2- -d "=" | cut -f 1 -d ":" | sed -e 's|[${}"]||g')

				local default_value=""
				if grep -q "${varname}:=" "${init_path}" ; then
					default_value=$(grep -E "${varname}:=" "${init_path}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:-" "${init_path}" ; then
					default_value=$(grep -E "${varname}:-" "${init_path}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:=" "/etc/conf.d/${svc_name}" ; then
					default_value=$(grep -E "${varname}:=" "/etc/conf.d/${svc_name}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:-" "/etc/conf.d/${svc_name}" ; then
					default_value=$(grep -E "${varname}:-" "/etc/conf.d/${svc_name}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				else
					default_value="/run/${svc_name}.pid"
				fi

				echo "set ${varname}=${default_value}" >> "${init_conf}" # Override pidfile path
				if (( ${create_pid} == 1 )) ; then
					pid_file="pid:!${default_value}"
				else
					pid_file="pid:!${default_value}"
				fi
				notify="notify:pid"
echo "pidfile case 9:  init_path - ${init_path} ; pid_file=${pid_file}"
			elif grep -q -e '--pidfile="[$].*}"' "${init_path}" \
				&& ! grep -q -e '^pidfile=' "${init_path}" ; then
				# DEADCODE
				# Case: --pidfile="${PKG_PIDFILE}"
				local varname=$(grep -o -E -e '--pidfile="[$].*}"' "${init_path}" | head -n -1 | cut -f 2 -d '"' | sed -e 's|[${}]||g')


				local default_value=""
				if grep -q "${varname}:=" "${init_path}" ; then
					default_value=$(grep -E "${varname}:=" "${init_path}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:-" "${init_path}" ; then
					default_value=$(grep -E "${varname}:-" "${init_path}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:=" "/etc/conf.d/${svc_name}" ; then
					default_value=$(grep -E "${varname}:=" "/etc/conf.d/${svc_name}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				elif grep -q "${varname}:-" "/etc/conf.d/${svc_name}" ; then
					default_value=$(grep -E "${varname}:-" "/etc/conf.d/${svc_name}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
				else
					default_value="/run/${svc_name}.pid"
				fi

				echo "set ${varname}=${default_value}" >> "${init_conf}" # Override pidfile path
				if (( ${create_pid} == 1 )) ; then
					pid_file="pid:!${default_value}"
				else
					pid_file="pid:!${default_value}"
				fi
				notify="notify:pid"
echo "pidfile case 10:  init_path - ${init_path} ; pid_file=${pid_file}"
			elif grep -q -e "--pidfile" "${init_path}" \
				&& grep -E -o -e "--pidfile [^ ]+" "${init_path}" | cut -f 2 -d " " | cut -c 1 | grep -q -e "/"  ; then
				local path=$(grep -E -o -e "--pidfile [^ ]+" "${init_path}" | head -n 1 | cut -f 2 -d " ")
				if (( ${create_pid} == 1 )) ; then
					# Case:  start-stop-daemon ... --make-pidfile --pidfile /run/service.pid
					pid_file="pid:!${path}"
				else
					# Case:  start-stop-daemon ... --pidfile /run/service.pid
					pid_file="pid:!${path}"
				fi
				notify="notify:pid"
echo "pidfile case 11:  init_path - ${init_path} ; pid_file=${pid_file}"
			elif grep -q -e "^pidfile=\"" "${init_path}" ; then
				local path=$(grep "^pidfile=\"" "${init_path}" | head -n 1 | cut -f 2 -d '"')
				if [[ "${path:0:1}" == "/" ]] ; then
				# Case:  pidfile="/run/service.pid"
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${path}"
					else
						pid_file="pid:!${path}"
					fi
					notify="notify:pid"
				fi
echo "pidfile case 12:  init_path - ${init_path} ; pid_file=${pid_file} ; path=${path}"
			elif grep -q -e "^pidfile=" "${init_path}" ; then
				local path=$(grep "^pidfile=" "${init_path}" | head -n 1 | cut -f 2 -d "=")
				if [[ "${path:0:1}" == "/" ]] ; then
				# Case:  pidfile=/run/service.pid
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${path}"
					else
						pid_file="pid:!${path}"
					fi
					notify="notify:pid"
				elif [[ "${path:0:1}" == '$' ]] ; then
				# Case:  pidfile=${RC_PREFIX}/run/service.pid
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${path}"
					else
						pid_file="pid:!${path}"
					fi
					notify="notify:pid"
				fi
echo "pidfile case 13:  init_path - ${init_path} ; pid_file=${pid_file} ; path=${path}"
			elif grep -q -E -e "--pidfile [^ ]+ " "${init_path}" \
				&& ! grep -q -E -e "^pidfile=" "${init_path}" ; then
				local path=$(grep -E -o -e "--pidfile [^ ]+ " "${init_path}" | head -n 1 | cut -f 2 -d " " | sed -e 's|"||g')
				if [[ "${svc_name}" == "actkbd" ]] ; then
					local t=$(grep -e "^PIDFILE=" "/etc/conf.d/actkbd")
					echo "set ${t}" >> "${init_conf}"
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${path}"
					else
						pid_file="pid:!${path}"
					fi
					notify="notify:pid"
echo "pidfile case 14A:  init_path - ${init_path} ; pid_file=${pid_file}"
				elif [[ "${path:0:1}" == "/" ]] ; then
					# Case:  --pidfile /run/service.pid
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${path}"
					else
						pid_file="pid:!${path}"
					fi
					notify="notify:pid"
echo "pidfile case 14B:  init_path - ${init_path} ; pid_file=${pid_file}"
				elif [[ "${path:0:1}" == "$" ]] && ! ( echo "${path}" | grep -q -E ":" ) ; then
					local varname=$(echo "${path}" | sed -e 's|^\${||g' -e 's|}||g')
					local default_value=""
					if grep -q "${varname}:=" "${init_path}" ; then
						default_value=$(grep -E "${varname}:=" "${init_path}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
					elif grep -q "${varname}:-" "${init_path}" ; then
						default_value=$(grep -E "${varname}:-" "${init_path}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
					elif grep -q "${varname}:=" "/etc/conf.d/${svc_name}" ; then
						default_value=$(grep -E "${varname}:=" "/etc/conf.d/${svc_name}" | cut -f 2 -d "=" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
					elif grep -q "${varname}:-" "/etc/conf.d/${svc_name}" ; then
						default_value=$(grep -E "${varname}:-" "/etc/conf.d/${svc_name}" | cut -f 2 -d "-" | sed -e "s|}$||g" -e 's|^"||g' -e 's|"$||g' -e "s|}$||g")
					else
						default_value="/run/${svc_name}.pid"
					fi

					echo "set ${varname}=${default_value}" >> "${init_conf}" # Override pidfile path
					# Case:  --pidfile ${PIDFILE}
					if (( ${create_pid} == 1 )) ; then
						pid_file="pid:!${default_value}"
					else
						pid_file="pid:!${default_value}"
					fi
					notify="notify:pid"
echo "pidfile case 14C:  init_path - ${init_path} ; pid_file=${pid_file}"
				fi
			elif grep -q -E  -e 'supervisor[:]?=["]?supervise-daemon' "${init_path}" ; then
				pid_file="pid:!/run/${svc_name}.pid"
				notify="notify:pid"
				sed -i -e "${top_ln}a export indirect_make_pidfile=1" "${init_sh}" || die "ERR:  line number - $LINENO"
echo "pidfile case 15:  init_path - ${init_path} ; pid_file=${pid_file}"
			elif grep -q -e "start-stop-daemon" "${init_path}" ; then
				pid_file="pid:!/run/${svc_name}.pid"
				sed -i -e "${top_ln}a export indirect_make_pidfile=1" "${init_sh}" || die "ERR:  line number - $LINENO"
				notify="notify:pid"
echo "pidfile case 16:  init_path - ${init_path} ; pid_file=${pid_file}"
			else
echo "pidfile case 17:  init_path - ${init_path}"
				notify="notify:none"
			fi

			local force_check_list=(
				"actkbd"
			)

			local x
			for x in ${force_check_lists[@]} ; do
				sed -i -e "${top_ln}a export indirect_make_pidfile=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			done

			if [[ -n "${FINIT_PID_OVERRIDE}" ]] ; then
				local x
				for x in ${FINIT_PID_OVERRIDE} ; do
					local k="${x#*:}"
					local v="${x%:*}"
					if [[ "${k}" == "${svc_name}" ]] ; then
						pid_file="${v}"
					fi
				done
			fi

			if [[ -n "${pid_file}" ]] && [[ "${pid_file}" =~ "${RC_SVCNAME}" ]] ; then
				pid_file=$(echo "${pid_file}" | sed -e "s|\${RC_SVCNAME}|${svc_name}|g")
			fi

			if [[ -n "${pid_file}" ]] && [[ "${pid_file}" =~ "${SVCNAME}" ]] ; then
				pid_file=$(echo "${pid_file}" | sed -e "s|\${SVCNAME}|${svc_name}|g")
			fi

			if [[ -n "${pid_file}" ]] && [[ "${pid_file}" =~ "${RC_PREFIX%/}" ]] ; then
				pid_file=$(echo "${pid_file}" | sed -e "s|\${RC_PREFIX%/}||g")
			fi
			if [[ -n "${pid_file}" ]] && [[ "${pid_file}" =~ "${RC_PREFIX}" ]] ; then
				pid_file=$(echo "${pid_file}" | sed -e "s|\${RC_PREFIX}||g")
			fi

			if [[ -n "${pid_file}" ]] && [[ "${pid_file}" =~ "$" ]] ; then
echo "[*warn*] pid_file=${pid_file} for ${svc_name} should not be a variable"
			fi

			if [[ "${svc_name}" =~ "vsftpd" ]] ; then
				:
			elif [[ "${svc_name}" =~ "openvpn" ]] ; then
				local _pid_file=$(echo "${pid_file}" | sed -r -e 's|pid:!?||g')
				local _pid_file_instanced=$(echo "${pid_file_instanced}" | sed -r -e 's|pid:!?||g')
echo "Adding pidfile=${_pid_file_instanced} conditional to ${init_sh}"
echo "Adding pidfile=${_pid_file} conditional to ${init_sh}"
				sed -i -e "${top_ln}a [ -n \"\${2}\" ] && pidfile=\"${_pid_file_instanced}\"" "${init_sh}" || die "ERR:  line number - $LINENO"
				sed -i -e "${top_ln}a [ -z \"\${2}\" ] && pidfile=\"${_pid_file}\"" "${init_sh}" || die "ERR:  line number - $LINENO"
			elif [[ -n "${pid_file}" ]] && ! grep -q "^pidfile=" "${init_sh}" ; then
				local _pid_file=$(echo "${pid_file}" | sed -r -e "s|pid:!?||g")
echo "Adding pidfile=${_pid_file} to ${init_sh}"
				sed -i -e "${top_ln}a pidfile=${_pid_file}" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			if [[ -z "${pid_file}" ]] && grep -q -i "pidfile" "${init_path}" ; then
				echo "[*warn*] Missing pidfile for ${svc_name} (confirmed)"
			elif [[ -z "${pid_file}" ]] ; then
				echo "[warn] Missing pidfile for ${svc_name}"
			fi

			if grep -q -e "^supervisor=.*s6" "${init_path}" ; then
				notify="notify:s6"
			fi

			local user=""
			local group=""
			if grep -q -e "^command_user=" "${init_path}" ; then
				command_user=$(grep -e "^command_user=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				user=$(echo "${command_user}" | cut -f 1 -d ":")
				group=$(echo "${command_user}" | cut -f 1 -d ":")
			else
				if grep -q -e "^user=" "${init_path}" ; then
					user=$(grep -e "^user=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				fi
				if grep -q -e "^group=" "${init_path}" ; then
					group=$(grep -e "^group=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				fi
			fi

			local basename_fn=$(basename "${init_sh}")
			#basename_fn=$(echo "${basename_fn}" | sed -e "s|\.sh$|%i.sh|g")

			local svc_type_start_pre=""
			local svc_type_start=""
			local svc_type_start_post=""
			local svc_type_stop_pre=""
			local svc_type_stop=""
			local svc_type_stop_post=""

			local svc_type
			if grep -q -e "^start_pre" "${init_path}" ; then
				svc_type_start_pre="task"
				service_types["${svc_name}-pre${instance}"]="${svc_type_start}"
				echo "${svc_type_start_pre} [${start_runlevels}] name:${svc_name}-pre ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start_pre\" \"%i\" -- ${svc_name} pre${instance_desc}" >> "${init_conf}"
			fi

			needs_openrc_default_start() {
				if ! grep -q -e "^start[(]" "${init_path}" && ( grep -q -e "^command=" "${init_path}" || grep -q -F -e ': ${command=' "${init_path}" ) ; then
					return 0
				fi
				return 1
			}

			needs_openrc_default_stop() {
				if ! grep -q -e "^stop[(]" "${init_path}" && ( grep -q -e "^command=" "${init_path}" || grep -q -F -e ': ${command=' "${init_path}" ) ; then
					return 0
				fi
				return 1
			}

			if grep -q -e "^start" "${init_path}" || needs_openrc_default_start ; then
				local user_group=""
				if [[ -n "${user}" && -n "${group}" ]] ; then
					user_group="@${user}:${group}"
				elif [[ -n "${user}" ]] ; then
					user_group="@${user}"
				elif [[ -n "${group}" ]] ; then
					# Based on https://github.com/troglobit/finit/blob/4.6/src/service.c#L1443
					user_group="@root:${group}"
				fi

				local name=""
				local provide=""
				if grep -q -E -e "^[[:space:]]+provide [ 0-9a-zA-Z-]+" "${init_path}" ; then
					provide=$(grep -E -e "^[[:space:]]+provide [ 0-9a-zA-Z-]+" "${init_path}" \
						| sed -E -e "s|^[[:space:]]+||g" -e "s|provide ||")
				fi

				local envfile=""
				if [[ -f "/etc/conf.d/${svc_name}" ]] ; then
					envfile="env:/etc/conf.d/${svc_name}"
				fi

				local respawn=""
				if is_respawnable "${svc_name}" ; then
					respawn="respawn"
				fi

				local start_cond_extra=""
				[[ "${svc_type_start_pre}" =~ ("run"|"task") ]] && start_cond_extra=",${svc_type_start_pre}/${svc_name}-pre${instance}/success"

				is_daemon_without_pidfile() {
				# Inits that not use start-stop-daemon but run daemons
					local name=""
					if [[ -n "${provide}" ]] ; then
						name="${provide}"
					else
						name="${svc_name}"
					fi

					local L=(
					#	"avahi-daemon"
					#	"avahi-dnsconfd"
						"mysql"
						"mysql-s6"
						"mysql-supervise"
					)
					local x
					for x in ${L[@]} ; do
						[[ "${x}" == "${name}" ]] && return 0
					done
					return 1
				}

				# env: is required for variables
				if [[ "${notify}" == "notify:pid" ]] ; then
					if [[ -n "${provide}" ]] ; then
						name="${provide}"
					else
						name="${svc_name}"
					fi

					svc_type_start="service"
					service_names["${svc_name}"]="${name}"
					service_types["${svc_name}${instance}"]="${svc_type_start}"
					echo "${svc_type_start} [${start_runlevels}] <${start_cond}${start_cond_extra}> ${envfile} ${user_group} name:${name} ${instance} ${notify} ${pid_file} ${respawn} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start\" \"%i\" -- ${svc_name}${instance_desc}" >> "${init_conf}"
				elif is_daemon_without_pidfile ; then
					if [[ -n "${provide}" ]] ; then
						name="${provide}"
					else
						name="${svc_name}"
					fi

					svc_type_start="service"
					service_names["${svc_name}"]="${name}"
					service_types["${svc_name}${instance}"]="${svc_type_start}"
					echo "${svc_type_start} [${start_runlevels}] <${start_cond}${start_cond_extra}> ${envfile} ${user_group} name:${name} ${instance} notify:none ${respawn} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start\" \"%i\" -- ${svc_name}${instance_desc}" >> "${init_conf}"
				else
					svc_type_start="task"
					service_names["${svc_name}${instance}"]="${svc_name}"
					service_types["${svc_name}${instance}"]="${svc_type_start}"
					echo "${svc_type_start} [${start_runlevels}] <${start_cond}${start_cond_extra}> ${envfile} ${user_group} name:${svc_name} ${instance} ${notify} ${pid_file} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start\" \"%i\" -- ${svc_name}${instance_desc}" >> "${init_conf}"
				fi
			fi
			if grep -q -e "^start_post" "${init_path}" ; then
				local start_post_cond=""
				[[ "${svc_type_start}" =~ ("run"|"task") ]] && start_post_cond="${svc_type_start}/${svc_name}${instance}/success"
				[[ "${svc_type_start}" == "service" ]] && start_post_cond="${svc_type_start}/${svc_name}${instance}/cleanup"
				svc_type_start_post="task"
				service_types["${svc_name}-post${instance}"]="${svc_type_start}"
				echo "${svc_type_start_post} [${start_runlevels}] <${start_post_cond}> name:${svc_name}-post ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start_post\" \"%i\" -- ${svc_name} post${instance_desc}" >> "${init_conf}"
			fi
			if grep -q -e "^stop_pre" "${init_path}" ; then
				svc_type_stop_pre="task"
				service_types["${svc_name}-pre-stop${instance}"]="${svc_type_start}"
				echo "${svc_type_stop_pre} [0] name:${svc_name}-pre-stop ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop_pre\" \"%i\" -- ${svc_name} pre-stop${instance_desc}" >> "${init_conf}"
			fi
			if grep -q -e "^stop" "${init_path}" || needs_openrc_default_stop ; then
				local stop_cond=""
				[[ "${svc_type_stop_pre}" =~ ("run"|"task") ]] && stop_cond="${svc_type_stop_pre}/${svc_name}-pre-stop${instance}/success"
				svc_type_stop="task"
				service_types["${svc_name}-stop${instance}"]="${svc_type_start}"
				echo "${svc_type_stop} [0] <${stop_cond}> name:${svc_name}-stop ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop\" \"%i\" -- ${svc_name} stop${instance_desc}" >> "${init_conf}"
			fi
			if grep -q -e "^stop_post" "${init_path}" ; then
				local stop_post_cond=""
				[[ "${svc_type_stop}" =~ ("run"|"task") ]] && stop_post_cond="${svc_type_stop}/${svc_name}-stop${instance}/success"
				[[ "${svc_type_stop}" == "service" ]] && stop_post_cond="${svc_type_stop}/${svc_name}-stop${instance}/cleanup"
				svc_type_stop_post="task"
				service_types["${svc_name}-post-stop${instance}"]="${svc_type_start}"
				echo "${svc_type_stop_post} [0] <${stop_post_cond}> name:${svc_name}-post-stop ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop_post\" \"%i\" -- ${svc_name} post-stop${instance_desc}" >> "${init_conf}"
			fi
			if grep -q -e "^extra_commands=" "${init_path}" ; then
				local list=$(grep "^extra_commands=" "${init_path}" | cut -f 2 -d '=' | sed -e 's|^"||' -e 's|"$||')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${svc_name}-${x}" >> "${init_conf}"
					echo "run [${extra_runlevels}] name:${svc_name}-${x} ${instance} <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" \"%i\" -- ${svc_name} ${x}${instance_desc}" >> "${init_conf}"
				done
			fi
			if grep -q -e "^extra_started_commands=" "${init_path}" ; then
				local list=$(grep "^extra_started_commands=" "${init_path}" | cut -f 2 -d '=' | sed -e 's|^"||' -e 's|"$||')
				for x in ${list} ; do
					if [[ "${x}" == "reload" ]] ; then
						echo "# Run as:  initctl cond set ${svc_name}-${x}-paused" >> "${init_conf}"
						echo "run [${extra_runlevels}] <${svc_type_start}/${svc_name}${instance}/paused> name:${svc_name}-${x}-paused ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" \"%i\" -- ${svc_name} ${x}${instance_desc} on paused" >> "${init_conf}"
						echo "# Run as:  initctl cond set ${svc_name}-${x}-waiting" >> "${init_conf}"
						echo "run [${extra_runlevels}] <${svc_type_start}/${svc_name}${instance}/waiting> name:${svc_name}-${x}-waiting ${instance} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" \"%i\" -- ${svc_name} ${x}${instance_desc} on waiting" >> "${init_conf}"
					else
						echo "# Run as:  initctl cond set ${svc_name}-${x}  # For started service only" >> "${init_conf}"
						echo "run [${extra_runlevels}] name:${svc_name}-${x} ${instance} <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" \"%i\" -- ${svc_name} ${x}${instance_desc}" >> "${init_conf}"
					fi
				done
			fi
			if grep -q -e "^extra_stopped_commands=" "${init_path}" ; then
				local list=$(grep "^extra_started_commands=" "${init_path}" | cut -f 2 -d '=' | sed -e 's|^"||' -e 's|"$||')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${svc_name}-${x}  # For stopped service only" >> "${init_conf}"
					echo "run [${extra_runlevels}] name:${svc_name}-${x} ${instance} <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" -- ${svc_name} ${x}${instance_desc}" >> "${init_conf}"
				done
			fi

			if grep -q -e "RC_PREFIX" "${init_conf}" ; then
				sed -i -e "1i set RC_PREFIX=" "${init_conf}"
			fi
			if grep -q -E -e "SVCNAME[}]?( |$)" "${init_conf}" ; then
				sed -i -e "1i set SVCNAME=${svc_name}  # This should match the filename without suffix." "${init_conf}"
			fi
			if grep -q -e "RC_SVCNAME" "${init_conf}" ; then
				sed -i -e "1i set RC_SVCNAME=${svc_name}  # This should match the filename without suffix." "${init_conf}"
			fi

			if ! grep -q -e "[$]" "${init_conf}" ; then
				sed -i -E -e "s|env:[^ ]+||g" "${init_conf}"
			fi
			sed -i -e "s|<>||g" "${init_conf}"
			sed -i -e "s|<,|<|g" "${init_conf}"
		done

		# The two checks below prevent indefinite pauses from missing pid/services.

if false ; then
		echo "Removing non-daemon service conditionals"

		# Delete one shot service conditionals which the pids disappear.
		local x
		for x in $(grep -l -o -E "<[^>]+" $(find "${CONFS_PATH}" -name "*.conf" -type f)) ; do
			local ps=(
				$(grep -o -E "<[^>]+" "${x}" | sed -e "s|<||g" | tr "," " ")
			)
			local p
			for p in ${ps[@]} ; do
				[[ "${p}" =~ "-pre" ]] && continue
				[[ "${p}" =~ "-post" ]] && continue
				[[ "${p}" =~ "-stop" ]] && continue
				[[ "${p}" =~ "/cleanup" ]] && continue
				[[ "${p}" =~ "/paused" ]] && continue
				[[ "${p}" =~ "/waiting" ]] && continue
				[[ "${p}" =~ ^"boot/" ]] && continue
				[[ "${p}" =~ ^"dev/" ]] && continue
				[[ "${p}" =~ ^"hook/" ]] && continue
				[[ "${p}" =~ ^"net/" ]] && continue
				[[ "${p}" =~ ^"sys/" ]] && continue
				[[ "${p}" =~ ^"usr/" ]] && continue

				local svc_name_raw=""
				if [[ "${p}" =~ ^"pid/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^pid[/]||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"task/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^task[/]||" -e "s|[/]done$||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"service/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -r -e "s|^service[/]||" -e "s,[/](cleanup|paused|running)$,,") || die "ERR:  line number - $LINENO"
				fi

				svc_name="${svc_name_raw%:*}"

				if grep -q -E -r -e "^(run|task).*name:${svc_name} " $(find "${CONFS_PATH}" -name "*.conf" -type f) ; then
					echo "Deleting conditional <...>/${svc_name}"
					sed -i -r -e "s#^(pid|task|service)/${svc_name}##g" $(find "${CONFS_PATH}" -name "*.conf" -type f) || die "ERR:  line number - $LINENO"
				fi
			done
		done
fi

		echo "Removing service conditionals which services don't exist"

		# Delete conditionals with services that are not installed.
		local x
		for x in $(grep -l -o -E "<[^>]+" $(find "${CONFS_PATH}" -name "*.conf" -type f)) ; do
			local ps=(
				$(grep -o -E "<[^>]+" "${x}" | sed -e "s|<||g" | tr "," " ")
			)
			local p
			for p in ${ps[@]} ; do
				[[ "${p}" =~ "-pre" ]] && continue
				[[ "${p}" =~ "-post" ]] && continue
				[[ "${p}" =~ "-stop" ]] && continue
				[[ "${p}" =~ "/cleanup" ]] && continue
				[[ "${p}" =~ "/paused" ]] && continue
				[[ "${p}" =~ "/waiting" ]] && continue
				[[ "${p}" =~ ^"boot/" ]] && continue
				[[ "${p}" =~ ^"dev/" ]] && continue
				[[ "${p}" =~ ^"hook/" ]] && continue
				[[ "${p}" =~ ^"net/" ]] && continue
				[[ "${p}" =~ ^"sys/" ]] && continue
				[[ "${p}" =~ ^"usr/" ]] && continue

				local svc_name_raw=""
				if [[ "${p}" =~ ^"pid/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^pid[/]||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"task/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^task[/]||" -e "s|[/]done$||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"service/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -r -e "s|^service[/]||" -e "s,[/](cleanup|paused|running)$,,") || die "ERR:  line number - $LINENO"
				fi

				svc_name="${svc_name_raw%:*}"
				local instance=""
				if [[ "${svc_name_raw}" =~ ":" ]] ; then
					instance=":${svc_name_raw#*:}"
				fi

				local n_files_conf=$(find "${CONFS_PATH}" -name "${svc_name}.conf" | wc -l)
				if (( ${n_files_conf} == 0 )) ; then
					echo "Deleting conditional <...>/${svc_name} by svc_name"
					sed -i -r -e "s|pid/${svc_name}[,]?||g" $(find "${CONFS_PATH}" -name "*.conf" -type f) || die "ERR:  line number - $LINENO"
				fi

				# name is alias
				local name=${service_names["${svc_name}"]}

				local n_files_scripts=$(grep -l -r "provide.*${name}" "${SCRIPTS_PATH}" | wc -l)
				if [[ "${svc_name}" != "${name}" ]] && (( ${n_files_scripts} == 0 )) ; then
					echo "Deleting conditional <...>/${name} by alias"
					sed -i -r -e "s|pid/${name}[,]?||g" $(find "${CONFS_PATH}" -name "*.conf" -type f) || die "ERR:  line number - $LINENO"
				fi
			done
		done

		echo "Changing pid created state to service/<service_name[:ID]>/running state"
		echo "Changing pid created state to {task,run}/<service_name[:ID]>/success state"
		local x
		for x in $(grep -l -o -E "<[^>]+" $(find "${CONFS_PATH}" -name "*.conf" -type f)) ; do
			local ps=(
				$(grep -o -E "<[^>]+" "${x}" | sed -e "s|<||g" | tr "," " ")
			)
			local p
			for p in ${ps[@]} ; do
				[[ "${p}" =~ "-pre" ]] && continue
				[[ "${p}" =~ "-post" ]] && continue
				[[ "${p}" =~ "-stop" ]] && continue
				[[ "${p}" =~ "/cleanup" ]] && continue
				[[ "${p}" =~ "/paused" ]] && continue
				[[ "${p}" =~ "/waiting" ]] && continue
				[[ "${p}" =~ ^"boot/" ]] && continue
				[[ "${p}" =~ ^"dev/" ]] && continue
				[[ "${p}" =~ ^"hook/" ]] && continue
				[[ "${p}" =~ ^"net/" ]] && continue
				[[ "${p}" =~ ^"sys/" ]] && continue
				[[ "${p}" =~ ^"usr/" ]] && continue

				[[ "${p}" =~ ^"pid/" ]] || continue

				local svc_name_raw=""
				if [[ "${p}" =~ ^"pid/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^pid[/]||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"task/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -e "s|^task[/]||" -e "s|[/]done$||") || die "ERR:  line number - $LINENO"
				elif [[ "${p}" =~ ^"service/" ]] ; then
					svc_name_raw=$(echo "${p}" | sed -r -e "s|^service[/]||" -e "s,[/](cleanup|paused|running)$,,") || die "ERR:  line number - $LINENO"
				fi

				svc_name="${svc_name_raw%:*}"
				local instance=""
				if [[ "${svc_name_raw}" =~ ":" ]] ; then
					instance=":${svc_name_raw#*:}"
				fi

				# name is alias
				local name=${service_names["${svc_name}"]}

				local svc_type_start=${service_types["${svc_name}${instance}"]}
				local cond
				if [[ "${svc_type_start}" =~ ("run"|"task") ]] ; then
					cond="${svc_type_start}/${name}${instance}/success"
				elif [[ "${svc_type_start}" == "service" ]] ; then
					cond="${svc_type_start}/${name}${instance}/running"
				fi

				if grep -q "pid/${svc_name}" $(find "${CONFS_PATH}" -name "*.conf" -type f)  ; then
					echo "Converting pid/${svc_name} -> ${cond}"
					sed -i -r \
						-e "s|pid/${svc_name},|${cond},|g" \
						-e "s|pid/${svc_name}>|${cond}>|g" \
						$(find "${CONFS_PATH}" -name "*.conf" -type f) || die "ERR:  line number - $LINENO"
				fi
			done
		done
	done
	sed -i -e "s|<>||g" $(find "${CONFS_PATH}" -name "*.conf")
	sed -i -e "s|<,|<|g" $(find "${CONFS_PATH}" -name "*.conf")

	cat "${NEEDS_NET_PATH}" | sort | uniq > "${NEEDS_NET_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${NEEDS_NET_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${SERVICES_PATH}" | sort | uniq > "${SERVICES_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${SERVICES_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${PKGS_PATH}" | sort | uniq > "${PKGS_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${PKGS_PATH}"{.t,} || die "ERR:  line number - $LINENO"
}

gen_systemd_wrapper() {
	mkdir -p "${SCRIPTS_PATH}/${c}/${pn}"
	[[ -z "${exec_start_pres}" ]] && exec_start_pres=":"
	[[ -z "${exec_starts}" ]] && exec_starts=":"
	[[ -z "${exec_start_posts}" ]] && exec_start_posts=":"
	[[ -z "${exec_stop_pres}" ]] && exec_stop_pres=":"
	local has_exec_stops=1
	if [[ -z "${exec_stops}" ]] ; then
		exec_stops=":"
		has_exec_stops=0
	fi
	[[ -z "${exec_stop_posts}" ]] && exec_stop_posts=":"
	[[ -z "${exec_reloads}" ]] && exec_reloads=":"
	local exec_start_exe=""
	if [[ -n "${exec_start}" ]] ; then
		exec_start_exe=$(basename $(echo "${exec_start}" | cut -f 1 -d " "))
	fi

	# Banned for PID kill
	if [[ "${exec_start_exe}" == "sh" ]] ; then
		exec_start_exe=""
	fi
	if [[ "${exec_start_exe}" =~ ".sh"$ ]] ; then
		exec_start_exe=""
	fi

	if [ -n "${cpu_affinity}" ] ; then
		if echo "${cpu_affinity}" | grep -q " " ; then
			cpu_affinity=$(echo "${cpu_affinity}" | tr " " ",")
		elif echo "${cpu_affinity}" | grep -q "," ; then
			:
		fi
	fi

	local command=""
	local command_args=""
	if [[ "${type}" != "oneshot" ]] && echo -e "${exec_starts}" | sed -e "/^$/d" | wc -l | grep -q "1" ; then
		command=$(echo -e "${exec_starts}" | sed -e "/^$/d" | head -n 1 | cut -f 1 -d " ")
		command_args=$(echo -e "${exec_starts}" | sed -e "/^$/d" | head -n 1 | cut -f 2- -d " ")
		[[ "${command}" == "${command_args}" ]] && command_args=""
	fi

	local service_fns=""
	if [[ "${svc_name}" == "dmcrypt" ]] ; then
service_init='
hook_rootfs_up_fn="start"
hook_system_dn_fn="stop"
uses_hooks=1
'
	elif grep -q "^Before=.*network" "${init_path}" ; then
service_fns='
hook_basefs_up_fn="start"
uses_hooks=1
'
	fi

	if [[ "${request_make_pid}" == "1" ]] ; then
_indirect_make_pidfile='
indirect_make_pidfile=1
'
	else
_indirect_make_pidfile=''
	fi

	local kill_wpa_supplicant=""
	if [[ "${svc_name}" == "net@" ]] ; then
kill_wpa_supplicant="
rm -f /run/wpa_supplicant-\${instance}.pid
"
	fi

#/run/wpa_supplicant-wlan0.pid
	pidfile=$(echo "${pid_file}" | sed -r -e "s|pid:[!]?||g")

cat <<EOF >"${SCRIPTS_PATH}/${c}/${pn}/${svc_name}.sh"
#!${FINIT_SHELL}
instance="\${2}"
${service_fns}
${_indirect_make_pidfile}
$(echo -e ${environments})
if [ -n "\${environment_file}" ] && [ -e "\${environment_file}" ] ; then
	. \${environment_file}
fi
. /lib/finit/scripts/lib/lib.sh
ambient_capabilities="${ambient_capabilities}"
bounding_capabilities="${bounding_capabilities}"
cache_directory="${cache_directory}"
cache_directory_mode="${cache_directory_mode}"
command="${command}"
command_args="${command_args}"
configuration_directory="${configuration_directory}"
configuration_directory_mode="${configuration_directory_mode}"
cpu_affinity="${cpu_affinity}"
cpu_scheduling_policy="${cpu_scheduling_policy}"
cpu_scheduling_priority="${cpu_scheduling_priority}"
cpu_scheduling_reset_on_fork="${cpu_scheduling_reset_on_fork}"
environment_file="${environment_file}"
exec_start="${exec_start}"
exec_start_exe="${exec_start_exe}"
final_kill_signal="${final_kill_signal}"
has_exec_stops=${has_exec_stops}
io_scheduling_class="${io_scheduling_class}"
io_scheduling_priority="${io_scheduling_priority}"
kill_mode="${kill_mode}"
kill_signal="${kill_signal}"
limit_as="${limit_as}"
limit_core="${limit_core}"
limit_cpu="${limit_cpu}"
limit_data="${limit_data}"
limit_fsize="${limit_fsize}"
limit_locks="${limit_locks}"
limit_memlock="${limit_memlock}"
limit_msgqueue="${limit_msgqueue}"
limit_nice="${limit_nice}"
limit_nofile="${limit_nofile}"
limit_nproc="${limit_nproc}"
limit_rss="${limit_rss}"
limit_rtprio="${limit_rtprio}"
limit_rttime="${limit_rttime}"
limit_sigpending="${limit_sigpending}"
limit_stack="${limit_stack}"
logs_directory="${logs_directory}"
logs_directory_mode="${logs_directory_mode}"
numa_mask="${numa_mask}"
numa_policy="${numa_policy}"
nice="${nice}"
not_ambient_capabilities="${not_ambient_capabilities}"
not_bounding_capabilities="${not_bounding_capabilities}"
pidfile="${pidfile}"
runtime_directory="${runtime_directory}"
runtime_directory_mode="${runtime_directory_mode}"
runtime_directory_preserve="${runtime_directory_preserve}"
send_sighup="${send_sighup}"
send_sigkill="${send_sigkill}"
state_directory="${state_directory}"
state_directory_mode="${state_directory_mode}"
timeout_stop_sec="${timeout_stop_sec}"
type="${type}"

get_service_pid() {
	# service_pid may capture 2 pids -- blank cmd, real command.
	local service_pid=\$(ps --no-headers -C "\${exec_start_exe}" -o pid 2>/dev/null)
	if [ -n "\${service_pid}" ] && [ \$service_pid -gt 0 ] ; then
		local x
		for x in \${service_pid} ; do
			if ps -o pid,cmd \${x} | grep -q "\${command}" ; then
				service_pid="\${x}"
				break
			fi
		done
	fi
	echo "${service_pid}"
}

start_dirs() {
	local x
	if [ -n "\${runtime_directory}" ] ; then
		set -- \${runtime_directory}
		for x in \$@ ; do
			if echo "\${x}" | cut -c 1 | grep "/" ; then
				mkdir -p "\${x}"
				if [ -n "\${runtime_directory_mode}" ] ; then
					chmod "\${runtime_directory_mode}" "\${x}"
				fi
			else
				mkdir -p "/run/\${x}"
				if [ -n "\${runtime_directory_mode}" ] ; then
					chmod "\${runtime_directory_mode}" "/run/\${x}"
				fi
			fi
		done
	fi
	if [ -n "\${state_directory}" ] ; then
		set -- \${state_directory}
		for x in \$@ ; do
			if echo "\${x}" | cut -c 1 | grep "/" ; then
				mkdir -p "\${x}"
				if [ -n "\${state_directory_mode}" ] ; then
					chmod "\${state_directory_mode}" "\${x}"
				fi
			else
				mkdir -p "/var/lib/\${x}"
				if [ -n "\${state_directory_mode}" ] ; then
					chmod "\${state_directory_mode}" "/var/lib/\${x}"
				fi
			fi
		done
	fi
	if [ -n "\${cache_directory}" ] ; then
		set -- \${cache_directory}
		for x in \$@ ; do
			if echo "\${x}" | cut -c 1 | grep "/" ; then
				mkdir -p "\${x}"
				if [ -n "\${cache_directory_mode}" ] ; then
					chmod "\${cache_directory_mode}" "\${x}"
				fi
			else
				mkdir -p "/var/cache/\${x}"
				if [ -n "\${cache_directory_mode}" ] ; then
					chmod "\${cache_directory_mode}" "/var/cache/\${x}"
				fi
			fi
		done
	fi
	if [ -n "\${logs_directory}" ] ; then
		set -- \${logs_directory}
		for x in \$@ ; do
			if echo "\${x}" | cut -c 1 | grep "/" ; then
				mkdir -p "\${x}"
				if [ -n "\${logs_directory_mode}" ] ; then
					chmod "\${logs_directory_mode}" "\${x}"
				fi
			else
				mkdir -p "/var/log/\${x}"
				if [ -n "\${logs_directory_mode}" ] ; then
					chmod "\${logs_directory_mode}" "/var/log/\${x}"
				fi
			fi
		done
	fi
	if [ -n "\${configuration_directory}" ] ; then
		set -- \${configuration_directory}
		for x in \$@ ; do
			if echo "\${x}" | cut -c 1 | grep "/" ; then
				mkdir -p "\${x}"
				if [ -n "\${configuration_directory_mode}" ] ; then
					chmod "\${configuration_directory_mode}" "\${x}"
				fi
			else
				mkdir -p "/etc/\${x}"
				if [ -n "\${configuration_directory_mode}" ] ; then
					chmod "\${configuration_directory_mode}" "/etc/\${x}"
				fi
			fi
		done
	fi
}

start_pre() {
	start_dirs
	$(echo -e "${exec_start_pres}")
}

start_ulimit() {
	local args=""
	[ -n "\${limit_as}" ] && args="\${args} -v \${limit_as}"
	[ -n "\${limit_core}" ] && args="\${args} -c \${limit_core}"
	[ -n "\${limit_cpu}" ] && args="\${args} -t \${limit_cpu}"
	[ -n "\${limit_data}" ] && args="\${args} -d \${limit_data}"
	[ -n "\${limit_fsize}" ] && args="\${args} -f \${limit_fsize}"
	[ -n "\${limit_locks}" ] && args="\${args} -x \${limit_locks}"
	[ -n "\${limit_memlock}" ] && args="\${args} -l \${limit_memlock}"
	[ -n "\${limit_msgqueue}" ] && args="\${args} -q \${limit_msgqueue}"
	[ -n "\${limit_nice}" ] && args="\${args} -e \${limit_nice}"
	[ -n "\${limit_nofile}" ] && args="\${args} -n \${limit_nofile}"
	[ -n "\${limit_nproc}" ] && args="\${args} -u \${limit_nproc}"
	[ -n "\${limit_rss}" ] && args="\${args} -m \${limit_rss}"
	[ -n "\${limit_rtprio}" ] && args="\${args} -r \${limit_rtprio}"
	[ -n "\${limit_rttime}" ] && args="\${args} -R \${limit_rttime}"
	[ -n "\${limit_sigpending}" ] && args="\${args} -i \${limit_sigpending}"
	[ -n "\${limit_stack}" ] && args="\${args} -s \${limit_stack}"
	if [ -n "\${args}" ] ; then
		ulimit \$@
	fi
}

start_scheduler() {
	if [ "\${type}" = "oneshot" ] ; then
		return 0
	elif [ -n "\${pidfile}" ] ; then
		MAINPID=\$(cat "\${pidfile}")
	else
		MAINPID=\$(get_service_pid)
	fi
	[ -z "\${MAINPID}" ] && return 0
	if [ -n "\${numa_mask}" ] ; then
		:
	fi
	if [ -n "\${numa_policy}" ] ; then
		:
	fi
}

start() {
	start_ulimit
	if [ "\${type}" = "oneshot" ] ; then
		${kill_wpa_supplicant}
		$(echo -e "${exec_starts}")
	else
		default_start
	fi
	start_scheduler
}

start_post() {
	$(echo -e "${exec_start_posts}")
}

stop_pre() {
	$(echo -e "${exec_stop_pres}")
}

_stop_control_group() {
	local sig=""
	if [ -n "\${kill_signal}" ] ; then
		sig="\${kill_signal}"
		sig=\$("\${sig#*G}")
	else
		sig="TERM"
	fi
	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -\${sig} \${x}
	done
}

_stop_mixed() {
	local sig=""
	if [ -n "\${kill_signal}" ] ; then
		sig="\${kill_signal}"
		sig=\$("\${sig#*G}")
	else
		sig="TERM"
	fi
	kill -\${sig} \${MAINPID}
	local x
	for x in \${cgroup_unit_pids} ; do
		[ "\${x}" = \${MAINPID} ] && continue
		ps \${x} >/dev/null || continue
		kill -KILL \${x}
	done
}

_stop_process() {
	local sig=""
	if [ -n "\${kill_signal}" ] ; then
		sig="\${kill_signal}"
		sig=\$("\${sig#*G}")
	else
		sig="TERM"
	fi
	kill -\${sig} \${MAINPID}
}

_stop_sighup() {
	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -HUP \${x}
	done
}

_stop_final_sigkill() {
	local sig=""
	if [ -n "\${final_kill_signal}" ] ; then
		sig="\${final_kill_signal}"
		sig=\$("\${sig#*G}")
	else
		sig="KILL"
	fi

	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -\${sig} \${x}
	done
}

is_cgroup_unit_alive() {
	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null && return 0
	done
	return 1
}

stop_dirs() {
	local x
	if [ -n "\${runtime_directory}" ] ; then
		set -- \${runtime_directory}
		for x in \$@ ; do
			if [ "\${runtime_directory_preserve}" = "yes" ] || [ "\${runtime_directory_preserve}" = "restart" ] ; then
				if echo "\${x}" | cut -c 1 | grep "/" ; then
					local t=\$(realpath "\${x}")
					[ "\${t}" = "/" ] && continue
					[ -z "\${t}" ] && continue
					rm -rf "\${x}"
				else
					rm -rf "/run/\${x}"
				fi
			fi
		done
	fi
}

stop() {
	if [ "\${type}" = "oneshot" ] ; then
		return 0
	elif [ -n "\${pidfile}" ] ; then
		MAINPID=\$(cat "\${pidfile}")
	else
		MAINPID=\$(get_service_pid)
	fi
	local main_cgroup_name=\$(ps -p \${MAINPID} -o pid,cgroup \
		| tail -n 1 \
		| cut -f 2 -d " ")
	local cgroup_unit_pids=\$(ps -p \${MAINPID} -eo pid,cgroup \
		| grep "\${main_cgroup_name}" \
		| cut -f 1 -d " ")

	is_cgroup_unit_alive || return 0

	# Let it shut down
	now=\$(date +"%s")
	time_final=\$(( \${now} + \${timeout_stop_sec} ))
	while [ \${now} -lt \${time_final} ] ; do
		[ -e /proc/\${MAINPID} ] || break
		now=\$(date +"%s")
	done

	is_cgroup_unit_alive || return 0

	if [ \${has_exec_stops} -eq 1 ] ; then
		$(echo -e "${exec_stops}")
	fi

	local all_pids="\${child_pids} \${MAIN_PID}"
	if [ "\${kill_mode}" = "control-group" ] ; then
		_stop_control_group
	elif [ "\${kill_mode}" = "mixed" ] ; then
		_stop_mixed
	elif [ "\${kill_mode}" = "process" ] ; then
		_stop_process
	elif [ "\${kill_mode}" = "none" ] ; then
		:
	fi

	is_cgroup_unit_alive || return 0

	if [ "\${send_sighup}" = "yes" ] ; then
		_stop_sighup
	fi

	is_cgroup_unit_alive || return 0

	now=\$(date +"%s")
	time_final=\$(( \${now} + \${timeout_stop_sec} ))
	while [ \${now} -lt \${time_final} ] ; do
		[ -e /proc/\${MAINPID} ] || exit 0
		now=\$(date +"%s")
	done

	is_cgroup_unit_alive || return 0

	if [ "\${send_sigkill}" = "yes" ] ; then
		_stop_final_sigkill
	fi

	is_cgroup_unit_alive || return 0

	return 0
}

stop_post() {
	stop_dirs
	$(echo -e "${exec_stop_posts}")
}

reload() {
	if [ -n "\${pidfile}" ] ; then
		MAINPID=\$(cat "\${pidfile}")
	else
		MAINPID=\$(get_service_pid)
	fi
	$(echo -e "${exec_reloads}")
}
. /lib/finit/scripts/lib/event.sh
EOF
}

convert_systemd() {
	#rm -rf confs || die "ERR:  line number - $LINENO"
	mkdir -p confs || die "ERR:  line number - $LINENO"
	#rm -rf scripts || die "ERR:  line number - $LINENO"
	mkdir -p scripts || die "ERR:  line number - $LINENO"

	CONFS_PATH="$(pwd)/confs"
	NEEDS_NET_PATH="$(pwd)/needs_net.txt"
	NEEDS_DBUS_PATH="$(pwd)/needs_dbus.txt"
	PKGS_PATH="$(pwd)/pkgs.txt"
	SCRIPTS_PATH="$(pwd)/scripts"
	SERVICES_PATH="$(pwd)/services.txt"

	echo >> "${PKGS_PATH}" || die "ERR:  line number - $LINENO"
	echo >> "${SERVICES_PATH}" || die "ERR:  line number - $LINENO"
	echo >> "${NEEDS_NET_PATH}" || die "ERR:  line number - $LINENO"
	echo >> "${NEEDS_DBUS_PATH}" || die "ERR:  line number - $LINENO"

	unset service_types
	declare -A service_types

	unset service_aliases
	declare -A service_aliases

	local init_path
	local init_path_orig
	for init_path_orig in $(find /lib/systemd/system /usr/lib/systemd/system -name "*.service" -type f) ; do
		[[ "${init_path_orig}" == "./" ]] && continue
		local init_path_tmp=$(mktemp)
		cat "${init_path_orig}" > "${init_path_tmp}"
		local svc_name=$(basename "${init_path_orig}" | sed -e "s|\.service$||g") || die "ERR:  line number - $LINENO"
		local pkg=$(grep -l $(realpath "${init_path_orig}") $(realpath "/var/db/pkg/"*"/"*"/CONTENTS") | cut -f 5-6 -d "/")
		if [[ ! -f $(realpath "/var/db/pkg/${pkg}/environment.bz2") ]] ; then
			local c="unknown"
			local pn="unknown"
			pkg="${c}/${pn}"
			echo "Missing environment.bz2 for pkg:${pkg} for ${init_path_orig}"
		else
			local c=$(bzcat "/var/db/pkg/${pkg}/environment.bz2" | grep "declare -x CATEGORY=" | cut -f 2 -d '"')
			local pn=$(bzcat "/var/db/pkg/${pkg}/environment.bz2" | grep "declare -x PN=" | cut -f 2 -d '"')
		fi
		init_path="${init_path_tmp}"
		perl -pe 's/\\\n//' -i "${init_path}" # Remove hardbreak

		local pid_file=""
		if grep -q "^PIDFile" "${init_path}" ; then
			pid_file="pid:!"$(grep "^PIDFile" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local kill_signal=""
		if grep -q "^KillSignal=" "${init_path}" ; then
			kill_signal=$(grep "^KillSignal=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local final_kill_signal=""
		if grep -q "^FinalKillSignal=" "${init_path}" ; then
			final_kill_signal=$(grep "^FinalKillSignal=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local send_sighup=""
		if grep -q "^SendSIGHUP=" "${init_path}" ; then
			send_sighup=$(grep "^SendSIGHUP=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local send_sigkill=""
		if grep -q "^SendSIGKILL=" "${init_path}" ; then
			send_sigkill=$(grep "^SendSIGKILL=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local timeout_stop_sec="90"
		if grep -q "^TimeoutStopSec=" "${init_path}" ; then
			timeout_stop_sec=$(grep "^TimeoutStopSec=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local user=""
		if grep -q "^User=" "${init_path}" ; then
			user=$(grep "^User=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local group=""
		if grep -q "^Group=" "${init_path}" ; then
			group=$(grep "^Group=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local kill_mode="control-group"
		if grep -q "^KillMode=" "${init_path}" ; then
			kill_mode=$(grep "^KillMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local environment_file=""
		if grep -q "^EnvironmentFile=" "${init_path}" ; then
			environment_file=$(grep "^EnvironmentFile=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local runtime_directory=""
		if grep -q "^RuntimeDirectory=" "${init_path}" ; then
			runtime_directory=$(grep "^RuntimeDirectory=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local runtime_directory_mode=""
		if grep -q "^RuntimeDirectoryMode=" "${init_path}" ; then
			runtime_directory_mode=$(grep "^RuntimeDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local runtime_directory_preserve=""
		if grep -q "^RuntimeDirectoryPreserve=" "${init_path}" ; then
			runtime_directory_preserve=$(grep "^RuntimeDirectoryPreserve=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local state_directory=""
		if grep -q "^StateDirectory=" "${init_path}" ; then
			state_directory=$(grep "^StateDirectory=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local state_directory_mode=""
		if grep -q "^StateDirectoryMode=" "${init_path}" ; then
			state_directory_mode=$(grep "^StateDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cache_directory=""
		if grep -q "^CacheDirectory=" "${init_path}" ; then
			cache_directory=$(grep "^CacheDirectory=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cache_directory_mode=""
		if grep -q "^CacheDirectoryMode=" "${init_path}" ; then
			cache_directory_mode=$(grep "^CacheDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local logs_directory=""
		if grep -q "^LogsDirectory=" "${init_path}" ; then
			logs_directory=$(grep "^LogsDirectory=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local logs_directory_mode=""
		if grep -q "^LogsDirectoryMode=" "${init_path}" ; then
			logs_directory_mode=$(grep "^LogsDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local configuration_directory=""
		if grep -q "^ConfigurationDirectory=" "${init_path}" ; then
			configuration_directory=$(grep "^ConfigurationDirectory=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local configuration_directory_mode=""
		if grep -q "^ConfigurationDirectoryMode=" "${init_path}" ; then
			configuration_directory_mode=$(grep "^ConfigurationDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local configuration_directory_mode=""
		if grep -q "^ConfigurationDirectoryMode=" "${init_path}" ; then
			configuration_directory_mode=$(grep "^ConfigurationDirectoryMode=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_cpu=""
		if grep -q "^LimitCPU=" "${init_path}" ; then
			limit_cpu=$(grep "^LimitCPU=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_fsize=""
		if grep -q "^LimitFSIZE=" "${init_path}" ; then
			limit_fsize=$(grep "^LimitFSIZE=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_data=""
		if grep -q "^LimitDATA=" "${init_path}" ; then
			limit_data=$(grep "^LimitDATA=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_stack=""
		if grep -q "^LimitSTACK=" "${init_path}" ; then
			limit_stack=$(grep "^LimitSTACK=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_core=""
		if grep -q "^LimitCORE=" "${init_path}" ; then
			limit_core=$(grep "^LimitCORE=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_rss=""
		if grep -q "^LimitRSS=" "${init_path}" ; then
			limit_rss=$(grep "^LimitRSS=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_nofile=""
		if grep -q "^LimitNOFILE=" "${init_path}" ; then
			limit_nofile=$(grep "^LimitNOFILE=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_as=""
		if grep -q "^LimitAS=" "${init_path}" ; then
			limit_as=$(grep "^LimitAS=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_nproc=""
		if grep -q "^LimitNPROC=" "${init_path}" ; then
			limit_nproc=$(grep "^LimitNPROC=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_memlock=""
		if grep -q "^LimitMEMLOCK=" "${init_path}" ; then
			limit_memlock=$(grep "^LimitMEMLOCK=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_locks=""
		if grep -q "^LimitLOCKS=" "${init_path}" ; then
			limit_locks=$(grep "^LimitLOCKS=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_sigpending=""
		if grep -q "^LimitSIGPENDING=" "${init_path}" ; then
			limit_sigpending=$(grep "^LimitSIGPENDING=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_msgqueue=""
		if grep -q "^LimitMSGQUEUE=" "${init_path}" ; then
			limit_msgqueue=$(grep "^LimitMSGQUEUE=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_nice=""
		if grep -q "^LimitNICE=" "${init_path}" ; then
			limit_nice=$(grep "^LimitNICE=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_rtprio=""
		if grep -q "^LimitRTPRIO=" "${init_path}" ; then
			limit_rtprio=$(grep "^LimitRTPRIO=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local limit_rttime=""
		if grep -q "^LimitRTTIME=" "${init_path}" ; then
			limit_rttime=$(grep "^LimitRTTIME=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi


		local nice=""
		if grep -q "^Nice=" "${init_path}" ; then
			nice=$(grep "^Nice=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cpu_scheduling_policy=""
		if grep -q "^CPUSchedulingPolicy=" "${init_path}" ; then
			cpu_scheduling_policy=$(grep "^CPUSchedulingPolicy=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cpu_scheduling_priority=""
		if grep -q "^CPUSchedulingPriority=" "${init_path}" ; then
			cpu_scheduling_priority=$(grep "^CPUSchedulingPriority=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cpu_scheduling_reset_on_fork=""
		if grep -q "^CPUSchedulingResetOnFork=" "${init_path}" ; then
			cpu_scheduling_reset_on_fork=$(grep "^CPUSchedulingResetOnFork=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local cpu_affinity=""
		if grep -q "^CPUAffinity=" "${init_path}" ; then
			cpu_affinity=$(grep "^CPUAffinity=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local numa_policy=""
		if grep -q "^NUMAPolicy=" "${init_path}" ; then
			numa_policy=$(grep "^NUMAPolicy=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local numa_mask=""
		if grep -q "^NUMAMask=" "${init_path}" ; then
			numa_mask=$(grep "^NUMAMask=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local io_scheduling_class=""
		if grep -q "^IOSchedulingClass=" "${init_path}" ; then
			io_scheduling_class=$(grep "^IOSchedulingClass=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local io_scheduling_priority=""
		if grep -q "^IOSchedulingPriority=" "${init_path}" ; then
			io_scheduling_priority=$(grep "^IOSchedulingPriority=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi

		local init_conf="${CONFS_PATH}/${c}/${pn}/${svc_name}.conf"
		mkdir -p $(dirname "${init_conf}")
		echo "Generating ${c}/${pn}/${svc_name}.conf"
		cat /dev/null > "${init_conf}"
		echo "${c}/${pn}" >> "${PKGS_PATH}"
		echo "${pn}" >> "${SERVICES_PATH}"

		local environments=""
		local _env_file="/etc/systemd/system/${svc_name}.service.d/00gentoo.conf"
		if [[ -f "${_env_file}" ]] ; then
			if grep -q "^User=" "${_env_file}" ; then
				user=$(grep -q "^User=" "${_env_file}" | cut -f 2 -d "=")
			fi
			if grep -q "^Group=" "${_env_file}" ; then
				group=$(grep -q "^Group=" "${_env_file}" | cut -f 2 -d "=")
			fi
			if grep -q "^Environment=" "${_env_file}" ; then
				local environment=$(grep -q "^Environment=" "${_env_file}" | cut -f 2 -d "=")
				IFS=$'\n'
				local rows=(
					$(grep "^Environment=" "${_env_file}" \
						| cut -f 2- -d "=" \
						| sed -e 's|" "|"\n"|g')
				)
				local row=""
				for row in ${rows[@]} ; do
					row=$(echo "${row}" | cut -f 2 -d '"')
					local name=$(echo "${row}" | cut -f 1 -d '=')
					local value=$(echo "${row}" | cut -f 2 -d '=')
					echo "set ${name}=\"${value}\"" >> "${init_conf}"
					environments+="\n${name}=\"${value}\""
				done
				IFS=$' \t\n'
			fi
		fi

		local needs_syslog=0
		local start_cond=""
		local start_runlevels=""
		local extra_runlevels=""
		if grep -q "Alias=syslog.service" "${init_path}" ; then
			start_runlevels="S12345"
			extra_runlevels="12345"
		elif [[ \
			   "${svc_name}" == "NetworkManager" \
			|| "${svc_name}" == "NetworkManager-wait-online-systemd-pre200" ]] ; then
			start_runlevels="345"
			extra_runlevels="345"
		elif \
			   grep -q -E -e "^Before=.*(network|network-online).target( |$)" "${init_path}" \
			|| grep -q -E -e "^Wants=.*network-pre.target( |$)" "${init_path}" \
		; then
			start_runlevels="S"
			extra_runlevels="345"
		elif \
			   grep -q -E -e "^After=.*(network|network-online|nss-lookup|remote-fs).target( |$)" "${init_path}" \
			|| grep -q -E -e "^Requires=.*(network|network-online).target( |$)" "${init_path}" \
			|| grep -q -E -e "^Wants=.*(network|network-online).target( |$)" "${init_path}" \
			|| [[ "${svc_name}" == "avahi-daemon" ]] \
			|| [[ "${svc_name}" == "avahi-dnsconfd" ]] \
			|| [[ "${svc_name}" == "bitlbee" ]] \
			|| [[ "${svc_name}" == "geoclue" ]] \
			|| [[ "${svc_name}" == "ip6tables-store" ]] \
			|| [[ "${svc_name}" == "iptables-store" ]] \
			|| [[ "${svc_name}" == "net@" ]] \
			|| [[ "${svc_name}" == "NetworkManager-dispatcher" ]] \
			|| [[ "${svc_name}" == "nm-cloud-setup" ]] \
			|| [[ "${svc_name}" == "nm-priv-helper" ]] \
			|| [[ "${svc_name}" == "ntpd" ]] \
			|| [[ "${svc_name}" == "proftpd" ]] \
		; then
		# After.*nss-lookup is for DNS lookups
			start_runlevels="345"
			extra_runlevels="345"
			echo "${c}/${pn}" >> "${NEEDS_NET_PATH}"
		else
			start_runlevels="2345"
			extra_runlevels="2345"
		fi

		if grep -q -e "^StandardOutput=syslog" "${init_path}" ; then
			start_cond="${start_cond},service/syslog/running"
		elif grep -q -e "^StandardError=syslog" "${init_path}" ; then
			start_cond="${start_cond},service/syslog/running"
		fi

		if [[ "${svc_name}" == "acpid" ]] ; then
			start_cond="${start_cond},service/logger/running"
		fi

		if [[ "${start_cond:0:1}" == "," ]] ; then
			start_cond="${start_cond:1}"
		fi

		local svcs=(
			$(grep -r -e "^Requires=" "${init_path}" \
				| cut -f 2- -d "=")
		)
		if [[ "${FINIT_SOFT_DEPS_MANDATORY}" == "1" ]] ; then
			svcs+=(
				$(grep -r -e "^Wants=" "${init_path}" \
					| cut -f 2- -d "=")
			)
		fi

		local svc
		for svc in ${svcs[@]} ; do
			#[[ "${svc}" == "%i" ]] && continue
			[[ "${svc}" =~ ".socket" ]] && continue
			[[ "${svc}" =~ ".target" ]] && continue
			svc=$(echo "${svc}" | sed -E -e "s/(\.device|\.service|\.target)//g")
			[[ "${svc}" == "local-fs" ]] && continue
			[[ "${svc}" == "network-pre" ]] && continue
			[[ "${svc}" == "nss-lookup" ]] && continue # not portable
			[[ "${svc}" == "systemd-machined" ]] && continue # not portable
			if [[ "${svc}" == "network" ]] ; then
				start_cond="${start_cond},${FINIT_COND_NETWORK}"
			elif [[ "${svc}" == "network-online" ]] ; then
				start_cond="${start_cond},${FINIT_COND_NETWORK}"
			elif [[ "${svc}" == "sys-subsystem-net-devices-%i" ]] ; then
				local found=0
				local x
				for iface in $(ls /sys/class/net) ; do
					if [[ "${FINIT_COND_NETWORK}" =~ "net/${iface}/" ]] ; then
						start_cond="${start_cond},${FINIT_COND_NETWORK}"
						found=1
					fi
				done
				(( ${found} == 0 )) && continue
			else
				start_cond="${start_cond},pid/${svc}"
			fi
		done
		if [[ "${start_cond:0:1}" == "," ]] ; then
			start_cond="${start_cond:1}"
		fi

		local type="simple"
		if grep -q "^Type=" "${init_path}" ; then
			type=$(grep "^Type=" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
		fi
		if [[ "${type}" == "oneshot" ]] ; then
			notify=""
		elif [[ "${type}" == "notify" || "${type}" == "notify-reload" ]] ; then
			notify="notify:systemd"
		elif [[ "${type}" == "notify" ]] ; then
			notify="notify:systemd"
		elif [[ "${type}" == "simple" ]] ; then
			notify="notify:none"
		else
			notify="notify:pid"
		fi

		if [[ "${type}" == "dbus" ]] ; then
			echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
		fi

		if grep -q -e "^Type=dbus" "${init_path}" ; then
			echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
		fi


		if [[ "${svc_name}" == "sysklogd" ]] ; then
			pid_file="pid:/run/${pn}.pid"
			sed -i -e "${top_ln}a export do_exec=1" "${init_sh}" || die "ERR:  line number - $LINENO"
		fi

		if grep -q -e "^Environment=" "${init_path}" ; then
			IFS=$'\n'
			local ROWS=( $(grep -e "^Environment=" "${init_path}" | cut -f 2- -d "=") ) || die "ERR:  line number - $LINENO"
			local row
			for row in ${ROWS[@]} ; do
				if echo "${row}" | grep -q -e '^"' && echo "${row}" | grep -q -e '"$' ; then
					row=$(echo "${row}" | sed -r -e 's|"(.*)"|\1|g')
				fi
				echo "set ${row}" >> "${init_conf}"
			done
			IFS=$' \t\n'
		fi

		local n_bounding_capabilities=0
		local bounding_capabilities=""
		local not_bounding_capabilities=""
		if grep -q -e "^CapabilityBoundingSet=" "${init_path}" ; then
			local bc0=() # deny
			local bc1=() # permit
			local n_bounding_capabilities=$(grep -q -e "^CapabilityBoundingSet=" "${init_path}" | wc -l)
			IFS=$'\n'
			local ROWS=( $(grep -e "^CapabilityBoundingSet" "${init_path}" | cut -f 2- -d "=") ) || die "ERR:  line number - $LINENO"
			local row
			for row in ${ROWS[@]} ; do
				if [[ "${row}" =~ "~" ]] ; then
					bc0+=( $(echo "${row}" | sed -e "s|^CapabilityBoundingSet=~||g") )
				else
					bc1+=( $(echo "${row}" | sed -e "s|^CapabilityBoundingSet=||g") )
				fi
			done
			bounding_capabilities="${bc1[@]}"
			not_bounding_capabilities="${bc0[@]}"
			IFS=$' \t\n'
		fi

		local n_ambient_capabilities=0
		local ambient_capabilities=""
		local not_ambient_capabilities=""
		if grep -q -e "^AmbientCapabilities=" "${init_path}" ; then
			local ac0=() # deny
			local ac1=() # permit
			local n_ambient_capabilities=$(grep -q -e "^AmbientCapabilities=" "${init_path}" | wc -l)
			IFS=$'\n'
			local ROWS=( $(grep -e "^AmbientCapabilities" "${init_path}" | cut -f 2- -d "=") ) || die "ERR:  line number - $LINENO"
			local row
			for row in ${ROWS[@]} ; do
				if [[ "${row}" =~ "~" ]] ; then
					ac0+=( $(echo "${row}" | sed -e "s|^AmbientCapabilities=~||g") )
				else
					ac1+=( $(echo "${row}" | sed -e "s|^AmbientCapabilities=||g") )
				fi
			done
			ambient_capabilities="${ac1[@]}"
			not_ambient_capabilities="${ac0[@]}"
			IFS=$' \t\n'
		fi

		exec_start_pres=""
		exec_starts=""
		exec_start_posts=""

		exec_stop_pres=""
		exec_stops=""
		exec_stop_posts=""

		exec_reloads=""

		IFS=$'\n'
		local row
		for row in $(grep -E -e "^(ExecStartPre|ExecStart|ExecStartPost|ExecStop|ExecStopPost|ExecReload)=" "${init_path}") ; do
			local exec_start_pre=""
			if echo "${row}" | grep -q "^ExecStartPre=" ; then
				exec_start_pre=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"

				# TODO: process prefix:
				echo "${exec_start_pre}" | grep -q "^@"
				echo "${exec_start_pre}" | grep -q "^-"
				echo "${exec_start_pre}" | grep -q "^[+]"
				echo "${exec_start_pre}" | grep -q '^[!]'
				echo "${exec_start_pre}" | grep -q '^[!!]'

				exec_start_pre=$(echo "${exec_start_pre}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_start_pre=$(echo "${exec_start_pre}" | sed -e "s|%I|%i|g") # For instancing
				exec_start_pre=$(echo "${exec_start_pre}" | sed -e "s|%i|\${instance}|g")
				exec_start_pres="${exec_start_pres}\n${exec_start_pre}"
			fi
			local exec_start=""
			if echo "${row}" | grep -q "^ExecStart=" ; then
				exec_start=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_start=$(echo "${exec_start}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_start=$(echo "${exec_start}" | sed -e "s|%I|%i|g") # For instancing
				exec_start=$(echo "${exec_start}" | sed -e "s|%i|\${instance}|g")
				exec_starts="${exec_starts}\n${exec_start}"
			fi
			local exec_start_post=""
			if echo "${row}" | grep -q "^ExecStartPost=" ; then
				exec_start_post=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_start_post=$(echo "${exec_start_post}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_start_post=$(echo "${exec_start_post}" | sed -e "s|%I|%i|g") # For instancing
				exec_start_post=$(echo "${exec_start_post}" | sed -e "s|%i|\${instance}|g")
				exec_start_posts="${exec_start_posts}\n${exec_start_post}"
			fi

			local exec_stop_pre=""
			if echo "${row}" | grep -q "^ExecStopPre=" ; then
				exec_stop_pre=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop_pre=$(echo "${exec_stop_pre}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stop_pre=$(echo "${exec_stop_pre}" | sed -e "s|%I|%i|g") # For instancing
				exec_stop_pre=$(echo "${exec_stop_pre}" | sed -e "s|%i|\${instance}|g")
				exec_stop_pres="${exec_stop_pres}\n${exec_stop_pre}"
			fi

			local exec_stop=""
			if echo "${row}" | grep -q "^ExecStop=" ; then
				exec_stop=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop=$(echo "${exec_stop}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stop=$(echo "${exec_stop}" | sed -e "s|%I|%i|g") # For instancing
				exec_stop=$(echo "${exec_stop}" | sed -e "s|%i|\${instance}|g")
				exec_stops="${exec_stops}\n${exec_stop}"
			fi

			local exec_stop_post=""
			if echo "${row}" | grep -q "^ExecStopPost=" ; then
				exec_stop_post=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop_post=$(echo "${exec_stop_post}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stop_post=$(echo "${exec_stop_post}" | sed -e "s|%I|%i|g") # For instancing
				exec_stop_post=$(echo "${exec_stop_post}" | sed -e "s|%i|\${instance}|g")
				exec_stop_posts="${exec_stop_posts}\n${exec_stop_post}"
			fi

			local exec_reload=""
			if echo "${row}" | grep -q "^ExecReload=" ; then
				exec_reload=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_reload=$(echo "${exec_reload}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_reload=$(echo "${exec_reload}" | sed -e "s|%I|%i|g") # For instancing
				exec_reload=$(echo "${exec_reload}" | sed -e "s|%i|\${instance}|g")
				exec_reloads="${exec_reloads}\n${exec_reload}"
			fi
		done
		IFS=$' \t\n'

		exec_start_pres="${exec_start_pres:2}"
		exec_starts="${exec_starts:2}"
		exec_start_posts="${exec_start_posts:2}"
		exec_stop_pres="${exec_stop_pres:2}"
		exec_stops="${exec_stops:2}"
		exec_stop_posts="${exec_stop_posts:2}"
		exec_reloads="${exec_reloads:2}"

		local instance=""
		local instance_desc=""
		local instance_script_suffix=""
		if [[ "${svc_name}" =~ "@" ]] ; then
			instance_script_suffix="%i"
			instance=":%i"
			instance_desc=" for %i"
		fi

		local svc_type_start_pre=""
		local svc_type_start=""
		local svc_type_start_post=""
		local svc_type_stop_pre=""
		local svc_type_stop=""
		local svc_type_stop_post=""

		local svc_type
		if (( "${#exec_start_pres}" > 0 )) ; then
			svc_type_start_pre="task"
			service_types["${svc_name}-pre${instance}"]="${svc_type_start}"
			echo "${svc_type_start_pre} [${start_runlevels}] name:${svc_name}-pre ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"start_pre\" \"%i\" -- ${svc_name} pre${instance_desc}" >> "${init_conf}"
		fi
		if (( "${#exec_starts}" > 0 )) ; then
			local user_group=""
			if [[ -n "${user}" && -n "${group}" ]] ; then
				user_group="@${user}:${group}"
			elif [[ -n "${user}" ]] ; then
				user_group="@${user}"
			elif [[ -n "${group}" ]] ; then
				user_group="@:${group}"
			fi

			local name=""
			local alias=$(grep -r -e "Alias" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s/(.service)//g")

			local respawn=""
			if is_respawnable "${svc_name}" ; then
				respawn="respawn"
			fi

			local request_make_pid=0
			local start_cond_extra=""
			[[ "${svc_type_start_pre}" =~ ("run"|"task") ]] && start_cond_extra=",${svc_type_start_pre}/${svc_name}-pre${instance}/success"

			if [[ "${type}" == "oneshot" ]] ; then
				svc_type_start="task"
				service_aliases["${svc_name}"]="${svc_name}"
				service_types["${svc_name}${instance}"]="${svc_type_start}"
				echo "${svc_type_start} [${start_runlevels}] <${start_cond}${start_cond_extra}> ${user_group} name:${svc_name} ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"start\" \"%i\" -- ${svc_name}${instance_desc}" >> "${init_conf}"
			else
				if [[ -z "${pid_file}" ]] ; then
					#echo "[warn] Missing pidfile for ${svc_name}"
					request_make_pid=1
					if [[ -n "${instance}" ]] ; then
						pid_file="pid:!/run/${svc_name}%i.pid"
					else
						pid_file="pid:!/run/${svc_name}.pid"
					fi
				fi
				if [[ -n "${alias}" ]] ; then
					name="${alias}"
				else
					name="${svc_name}"
				fi
				svc_type_start="service"
				service_aliases["${svc_name}"]="${name}"
				service_types["${svc_name}${instance}"]="${svc_type_start}"
				echo "${svc_type_start} [${start_runlevels}] <${start_cond}${start_cond_extra}> ${user_group} name:${name} ${instance} ${notify} ${pid_file} ${respawn} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"start\" \"%i\" -- ${svc_name}${instance_desc}" >> "${init_conf}"
			fi
		fi
		if (( "${#exec_start_posts}" > 0 )) ; then
			svc_type_start_post="task"
			service_types["${svc_name}-post${instance}"]="${svc_type_start}"
			local start_post_cond=""
			[[ "${svc_type_start}" =~ ("run"|"task") ]] && start_post_cond="${svc_type_start}/${svc_name}${instance}/success"
			[[ "${svc_type_start}" == "service" ]] && start_post_cond="${svc_type_start}/${svc_name}${instance}/cleanup"
			echo "${svc_type_start_post} [${start_runlevels}] <${start_post_cond}> name:${svc_name}-post ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"start_post\" \"%i\" -- ${svc_name} post${instance_desc}" >> "${init_conf}"
		fi
		if (( "${#exec_stop_pres}" > 0 )) ; then
			svc_type_stop_pre="task"
			service_types["${svc_name}-pre-stop${instance}"]="${svc_type_start}"
			echo "${svc_type_stop_pre} [0] name:${svc_name}-pre-stop ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"stop_pre\" \"%i\" -- ${svc_name} pre-stop${instance_desc}" >> "${init_conf}"
		fi
		if (( "${#exec_stops}" > 0 )) ; then
			svc_type_stop="task"
			service_types["${svc_name}-stop${instance}"]="${svc_type_start}"
			local stop_cond=""
			[[ "${svc_type_stop_pre}" =~ ("run"|"task") ]] && stop_cond="${svc_type_stop_pre}/${svc_name}-pre-stop${instance}/success"
			echo "${svc_type_stop} [0] <${stop_cond}> name:${svc_name}-stop ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"stop\" \"%i\" -- ${svc_name} stop${instance_desc}" >> "${init_conf}"
		fi
		if (( "${#exec_stop_posts}" > 0 )) ; then
			svc_type_stop_post="task"
			service_types["${svc_name}-post-stop${instance}"]="${svc_type_start}"
			local stop_post_cond=""
			[[ "${svc_type_stop}" =~ ("run"|"task") ]] && stop_post_cond="${svc_type_stop}/${svc_name}-stop${instance}/success"
			[[ "${svc_type_stop}" == "service" ]] && stop_post_cond="${svc_type_stop}/${svc_name}-stop${instance}/cleanup"
			echo "${svc_type_stop_post} [0] <${stop_post_cond}> name:${svc_name}-post-stop ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"stop_post\" \"%i\" -- ${svc_name} post-stop${instance_desc}" >> "${init_conf}"
		fi
		if (( "${#exec_reloads}" > 0 )) ; then
			local x="reload"
			echo "# Run as:  initctl cond set ${svc_name}-${x}-paused" >> "${init_conf}"
			echo "run [${extra_runlevels}] <${svc_type_start}/${svc_name}${instance}/paused> name:${svc_name}-${x}-paused ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"reload\" \"%i\" -- ${svc_name} ${x}${instance_desc} on paused" >> "${init_conf}"
			echo "# Run as:  initctl cond set ${svc_name}-${x}-waiting" >> "${init_conf}"
			echo "run [${extra_runlevels}] <${svc_type_start}/${svc_name}${instance}/waiting> name:${svc_name}-${x}-waiting ${instance} /lib/finit/scripts/${c}/${pn}/${svc_name}.sh \"reload\" \"%i\" -- ${svc_name} ${x}${instance_desc} on waiting" >> "${init_conf}"
		fi
		gen_systemd_wrapper
		rm "${init_path}"
	done

	echo "Changing pid created state to service/<service_name[:ID]>/running state"
	echo "Changing pid created state to {task,run}/<service_name[:ID]>/success state"
	local x
	for x in $(grep -l -o -E "<[^>]+" $(find "${CONFS_PATH}" -name "*.conf" -type f)) ; do
		local ps=(
			$(grep -o -E "<[^>]+" "${x}" | sed -e "s|<||g" | tr "," " ")
		)
		local p
		for p in ${ps[@]} ; do
			[[ "${p}" =~ "-pre" ]] && continue
			[[ "${p}" =~ "-post" ]] && continue
			[[ "${p}" =~ "-stop" ]] && continue
			[[ "${p}" =~ "/cleanup" ]] && continue
			[[ "${p}" =~ "/paused" ]] && continue
			[[ "${p}" =~ "/waiting" ]] && continue
			[[ "${p}" =~ ^"boot/" ]] && continue
			[[ "${p}" =~ ^"dev/" ]] && continue
			[[ "${p}" =~ ^"hook/" ]] && continue
			[[ "${p}" =~ ^"net/" ]] && continue
			[[ "${p}" =~ ^"sys/" ]] && continue
			[[ "${p}" =~ ^"usr/" ]] && continue

			[[ "${p}" =~ ^"pid/" ]] || continue

			local svc_name=""
			local svc_name_raw=""
			if [[ "${p}" =~ ^"pid/" ]] ; then
				svc_name_raw=$(echo "${p}" | sed -e "s|^pid[/]||") || die "ERR:  line number - $LINENO"
			elif [[ "${p}" =~ ^"task/" ]] ; then
				svc_name_raw=$(echo "${p}" | sed -e "s|^task[/]||" -e "s|[/]done$||") || die "ERR:  line number - $LINENO"
			elif [[ "${p}" =~ ^"service/" ]] ; then
				svc_name_raw=$(echo "${p}" | sed -r -e "s|^service[/]||" -e "s,[/](cleanup|paused|running)$,,") || die "ERR:  line number - $LINENO"
			fi

			svc_name="${svc_name_raw%:*}"
			local instance=""
			if [[ "${svc_name_raw}" =~ ":" ]] ; then
				instance=":${svc_name_raw#*:}"
			fi

			local name=${service_aliases["${svc_name}"]}

			local svc_type_start=${service_types["${svc_name}${instance}"]}

			local cond
			if [[ "${svc_type_start}" =~ ("run"|"task") ]] ; then
				cond="${svc_type_start}/${name}${instance}/success"
			elif [[ "${svc_type_start}" == "service" ]] ; then
				cond="${svc_type_start}/${name}${instance}/running"
			fi

			if grep -q "pid/${svc_name}" $(find "${CONFS_PATH}" -name "*.conf" -type f) ; then
				echo "Converting pid/${svc_name} -> ${cond}"
				sed -i -r \
					-e "s|pid/${svc_name},|${cond},|g" \
					-e "s|pid/${svc_name}>|${cond}>|g" \
					$(find "${CONFS_PATH}" -name "*.conf" -type f) || die "ERR:  line number - $LINENO"
			fi
		done
	done
	sed -i -e "s|<>||g" $(find "${CONFS_PATH}" -name "*.conf")
	sed -i -e "s|<,|<|g" $(find "${CONFS_PATH}" -name "*.conf")

	cat "${NEEDS_NET_PATH}" | sort | uniq > "${NEEDS_NET_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${NEEDS_NET_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${SERVICES_PATH}" | sort | uniq > "${SERVICES_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${SERVICES_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${PKGS_PATH}" | sort | uniq > "${PKGS_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${PKGS_PATH}"{.t,} || die "ERR:  line number - $LINENO"
}

main() {
	[[ "${FINIT_SCRIPT_SOURCE}" =~ "openrc" ]] && convert_openrc
	[[ "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] && convert_systemd
	exit 0
}

main
