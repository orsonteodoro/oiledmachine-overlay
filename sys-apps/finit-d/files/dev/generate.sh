#!/bin/bash

# The comprehensive version for ebuild developers.  Users should use generate-local.sh instead.

FINIT_COND_NETWORK=${FINIT_COND_NETWORK:-"net/route/default"}
FINIT_SCRIPT_SOURCE=${FINIT_SCRIPT_SOURCE:-"openrc"}
FINIT_SHELL=${FINIT_SHELL:-"/bin/sh"}
MAINTAINER_MODE=${MAINTAINER_MODE:-0}

die() {
	echo "${1}"
	exit 1
}

convert_openrc() {
	rm -rf confs || die "ERR:  $LINENO"
	mkdir -p confs || die "ERR:  $LINENO"
	rm -rf scripts || die "ERR:  $LINENO"
	mkdir -p scripts || die "ERR:  $LINENO"

	CONFS_PATH="$(pwd)/confs"
	NEEDS_NET_PATH="$(pwd)/needs_net.txt"
	NEEDS_DBUS_PATH="$(pwd)/needs_dbus.txt"
	PKGS_PATH="$(pwd)/pkgs.txt"
	SCRIPTS_PATH="$(pwd)/scripts"
	SERVICES_PATH="$(pwd)/services.txt"

	echo > "${PKGS_PATH}" || die "ERR:  $LINENO"
	echo > "${SERVICES_PATH}" || die "ERR:  $LINENO"
	echo > "${NEEDS_NET_PATH}" || die "ERR:  $LINENO"
	echo > "${NEEDS_DBUS_PATH}" || die "ERR:  $LINENO"

	cd "${SCRIPTS_PATH}" || die "ERR:  $LINENO"
	IFS=$'\n'
	local OVERLAYS=()
	if [[ -e "/usr/portage" ]] ; then
		OVERLAYS+=(
			"/usr/portage"
		)
	fi
	if [[ -e "/var/db/repos" ]] ; then
		OVERLAYS+=(
			$(realpath /var/db/repos/*)
		)
	fi
	if [[ -n "${CUSTOM_OVERLAY_LIST}" ]] ; then
	# Example:  CUSTOM_OVERLAY_LIST="/usr/portage /var/db/repos/guru"
		OVERLAYS+=(
			${FINIT_CUSTOM_OVERLAY_LIST}
		)
	fi
if [[ "${MAINTAINER_MODE}" != 1 ]] ; then
		OVERLAYS=( "run-once" )
fi
	for overlay in ${OVERLAYS[@]} ; do
if [[ "${MAINTAINER_MODE}" == 1 ]] ; then
		echo "Processing ${overlay} overlay"
		cd "${overlay}" || die "ERR:  $LINENO"
		L=(
			grep -F -l '#!/sbin/openrc-run' $(find ./ -name "*init*")
		)
else
		script_dir="/etc/init.d"
		echo "Processing ${script_dir}"
		cd "${script_dir}" || die "ERR:  $LINENO"
		L=(
			$(find ./)
		)
fi

		local t=()
		t=( $(echo "${L[@]}" | tr " " "\n" | sort | uniq) )
		L=( ${t[@]} )

		for init_path in ${L[@]} ; do
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

if [[ "${MAINTAINER_MODE}" == 1 ]] ; then
			# Variations
			# Exact set
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z-]+)-[0-9]+-r[0-9]+\.initd$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z]+)-[0-9.]+-r[0-9]+\.initd$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^[0-9.]+-([a-z]+)\.init-r[0-9]+$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d\.([A-Za-z]+)-r[0-9]+$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.init-r[0-9]+\.d$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d\.([a-z]+)\.[0-9]+$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d-${pn}-r[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+-[0-9.]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^([a-z_-]+)-r[0-9]+\.initd$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-r[0-9]+\.initd$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-${pn}-[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-initd-r[0-9]$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}[0-9]+.initd$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+[a]$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}.init[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-r[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init-r[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init-[0-9.]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.${pn}$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}_initd$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.rc$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init.d$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^initd$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init$|${pn}|g") || die "ERR:  $LINENO"
			# Inexact set
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+[a]-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^rc_${pn}-r[0-9]+$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^${pn}-[0-9.]+-init\.d-||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|${pn}d\.initd$|${pn}d|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|${pn}\.initd$|${pn}|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|([a-z])\.initd$|\1|g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d-[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d\.[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init\.d$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd\.[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d-r[0-9]$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|_initd-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-r[0-9]+\.init$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-initd$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.init$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-[0-9]+\.init$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init-r[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.ng$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init-[0-9]+$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init[0-9]+||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.initd-new$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|.initscript$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init\.d$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|^init\.d_||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init\.d$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initrc$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-initd$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|\.init$||g") || die "ERR:  $LINENO"
			fn=$(echo "${fn}" | sed -r -e "s|-init$||g") || die "ERR:  $LINENO"

			# Init script fragments.  Needs manual evaluation
			[[ "${init_path}" =~ "qemu-binfmt" ]] && continue
fi

			grep -q "#!/sbin/openrc-run" "${init_path}" || continue

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
				:;
			elif [[ "${fn}" =~ "htbinit" ]] ; then
				:;
			elif [[ "${fn}" =~ "cbqinit" ]] ; then
				:;
			elif [[ "${fn}" =~ "vboxinit" ]] ; then
				:;
			elif [[ "${fn}" =~ "init" ]] ; then
				echo "${init_path} needs a case.  fn = ${fn}"
				exit 1
			fi
			echo "Generating init for ${c}/${pn}/${fn}.sh from ${init_path}"
			mkdir -p "${SCRIPTS_PATH}/${c}/${pn}"
			dest="${SCRIPTS_PATH}/${c}/${pn}/${fn}.sh"
			echo "${c}/${pn}" >> "${PKGS_PATH}"
			echo "${pn}" >> "${SERVICES_PATH}"

			# Disabled replace if newer
			#if [[ -e "${dest}" ]] ; then
			#	continue
			#fi

			cat "${init_path}" > "${dest}"

			if [[ "${init_path}" =~ "sys-apps/dbus" ]] && echo "${fn}" | grep -q -E -e "dbus.initd.in" ; then
				sed -i -e "s|@rundir@|/run|g" "${dest}" || die "ERR:  $LINENO"
			fi


			# ln = line number
			local top_ln=$(grep -n "# Distributed under" "${dest}" | cut -f 1 -d ":")
			local top_ln_fallback=$(grep -n "#!/sbin/openrc-run" "${dest}" | cut -f 1 -d ":")
			if [[ -n "${top_ln}" ]] ; then
				sed -i -e "${top_ln}a . /lib/finit/scripts/lib.sh" "${dest}" || die "ERR:  $LINENO"
				if grep -q "RC_SVCNAME" "${dest}" ; then
					sed -i -e "${top_ln}a RC_SVCNAME=\"${pn}\"" "${dest}"
				fi
				sed -i -e "${top_ln}a SVCNAME=\"${pn}\"" "${dest}" || die "ERR:  $LINENO"
				sed -i -e "${top_ln}a FN=\"\$1\"" "${dest}" || die "ERR:  $LINENO"
			else
				sed -i -e "${top_ln_fallback}a . /lib/finit/scripts/lib.sh" "${dest}" || die "ERR:  $LINENO"
				if grep -q "RC_SVCNAME" "${dest}" ; then
					sed -i -e "${top_ln_fallback}a RC_SVCNAME=\"${pn}\"" "${dest}" || die "ERR:  $LINENO"
				fi
				sed -i -e "${top_ln_fallback}a SVCNAME=\"${pn}\"" "${dest}" || die "ERR:  $LINENO"
				sed -i -e "${top_ln_fallback}a FN=\"\$1\"" "${dest}" || die "ERR:  $LINENO"
			fi
			local bottom_ln=$(cat "${dest}" | wc -l)
			sed -i -e "${bottom_ln}a . /lib/finit/scripts/event_handlers.sh" "${dest}" || die "ERR:  $LINENO"

			sed -i -e "s|#!/sbin/openrc-run|#!${FINIT_SHELL}|g" "${dest}" || die "ERR:  $LINENO"

			local needs_syslog=0
			local cond=""
			local runlevels=""
			if grep -q -e "need.*net" "${init_path}" ; then
				cond="${FINIT_COND_NETWORK}"
				runlevels="345"
				echo "${c}/${pn}" >> "${NEEDS_NET_PATH}"
			else
				runlevels="2345"
			fi

			if grep -q -e "need.*dbus" "${init_path}" ; then
				echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
			fi

			if grep -q -e "need.*logger" "${init_path}" ; then
				if [[ -n "${cond}" ]] ; then
					cond="${cond},syslogd"
				else
					cond="${cond}"
				fi
			fi

			local pidfile=""
			if grep -q -e "--make-pidfile" "${init_path}" ; then
				pidfile="pid:/run/${pn}.pid"
			fi

			local notify=""
			if grep -q -e "^pidfile=\"" "${init_path}" ; then
				local p=$(grep "^pidfile=\"" "${init_path}" | head -n 1 | cut -f 2 -d '"')
				pidfile="pid:!${p}"
				notify="notify:pid"
			elif grep -q -e "^pidfile=" "${init_path}" ; then
				local p=$(grep "^pidfile=" "${init_path}" | head -n 1 | cut -f 2 -d "=")
				pidfile="pid:!${p}"
				notify="notify:pid"
			else
				notify="notify:none"
			fi

			if grep -q -e "^supervisor=.*s6" "${init_path}" ; then
				notify="notify:s6"
			fi

			mkdir -p "${CONFS_PATH}/${c}/${pn}"
			cat /dev/null > "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			if grep -q -e "^start_pre" "${init_path}" ; then
				echo "run [${runlevels}] name:${pn}-pre-start /lib/finit/scripts/${c}/${pn}/${pn}.sh \"start_pre\" -- ${pn} pre-start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^start" "${init_path}" ; then
				[[ -n "${cond}" ]] && cond="<${cond}>"
				echo "service [${runlevels}] ${cond} name:${pn}-start ${notify} ${pidfile} /lib/finit/scripts/${c}/${pn}/${pn}.sh \"start\" -- ${pn} start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^start_post" "${init_path}" ; then
				echo "run [${runlevels}] name:${pn}-post-start /lib/finit/scripts/${c}/${pn}/${pn}.sh \"start_post\" -- ${pn} post-start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^stop_pre" "${init_path}" ; then
				echo "run [0] name:${pn}-pre-stop /lib/finit/scripts/${c}/${pn}/${pn}.sh \"stop_pre\" -- ${pn} pre-stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^stop" "${init_path}" ; then
				echo "task [0] name:${pn}-stop /lib/finit/scripts/${c}/${pn}/${pn}.sh \"stop\" -- ${pn} stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^stop_post" "${init_path}" ; then
				echo "run [0] name:${pn}-post-stop /lib/finit/scripts/${c}/${pn}/${pn}.sh \"stop_post\" -- ${pn} post-stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
			fi
			if grep -q -e "^extra_commands" "${init_path}" ; then
				local list=$(grep "extra_commands" "${init_path}" | cut -f 2 -d '"')
				local list
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${pn}-${x}" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
					echo "run [${runlevels}] <usr/${pn}-${x}> /lib/finit/scripts/${c}/${pn}/${pn}.sh \"${x}\" -- ${pn} ${x}" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
				done
			fi
			if grep -q -e "^extra_started_commands" "${init_path}" ; then
				local list=$(grep "extra_started_commands" "${init_path}" | cut -f 2 -d '"')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${pn}-${x}  # For started service only" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
					echo "run [${runlevels}] <usr/${pn}-${x}> /lib/finit/scripts/${c}/${pn}/${pn}.sh \"${x}\" -- ${pn} ${x}" >> 	"${CONFS_PATH}/${c}/${pn}/${pn}.conf"
				done
			fi
			if grep -q -e "^extra_stopped_commands" "${init_path}" ; then
				local list=$(grep "extra_started_commands" "${init_path}" | cut -f 2 -d '"')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${pn}-${x}  # For stopped service only" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
					echo "run [${runlevels}] <usr/${pn}-${x}> /lib/finit/scripts/${c}/${pn}/${pn}.sh \"${x}\" -- ${pn} ${x}" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
				done
			fi
		done
	done
	IFS=$' \t\n'

	cat "${NEEDS_NET_PATH}" | sort | uniq > "${NEEDS_NET_PATH}".t || die "ERR:  $LINENO"
	mv "${NEEDS_NET_PATH}"{.t,} || die "ERR:  $LINENO"

	cat "${SERVICES_PATH}" | sort | uniq > "${SERVICES_PATH}".t || die "ERR:  $LINENO"
	mv "${SERVICES_PATH}"{.t,} || die "ERR:  $LINENO"

	cat "${PKGS_PATH}" | sort | uniq > "${PKGS_PATH}".t || die "ERR:  $LINENO"
	mv "${PKGS_PATH}"{.t,} || die "ERR:  $LINENO"
}

convert_systemd() {
	#rm -rf confs || die "ERR:  $LINENO"
	mkdir -p confs || die "ERR:  $LINENO"
	#rm -rf scripts || die "ERR:  $LINENO"
	mkdir -p scripts || die "ERR:  $LINENO"

	CONFS_PATH="$(pwd)/confs"
	NEEDS_NET_PATH="$(pwd)/needs_net.txt"
	NEEDS_DBUS_PATH="$(pwd)/needs_dbus.txt"
	PKGS_PATH="$(pwd)/pkgs.txt"
	SCRIPTS_PATH="$(pwd)/scripts"
	SERVICES_PATH="$(pwd)/services.txt"

	local path
	for init_path in $(find /lib/systemd/system/ -name "*.service") ; do
		[[ "${init_path}" == "./" ]] && continue
		local pkg=$(grep -l $(realpath "${init_path}") $(realpath "/var/db/pkg/"*"/"*"/CONTENTS") | cut -f 5-6 -d "/")
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

		local pidfile=""
		if grep "^PIDFile" ; then
			pidfile=$(grep "^PIDFile" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi
		local exec_start_pre=""
		if grep "^ExecStartPre=" ; then
			exec_start_pre=$(grep "^ExecStartPre=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi
		local exec_start=""
		if grep "^ExecStart=" ; then
			exec_start=$(grep "^ExecStart=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi
		local exec_start_post=""
		if grep "^ExecStartPost=" ; then
			exec_start_post=$(grep "^ExecStartPost=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi
		local exec_stop=""
		if grep "^ExecStop=" ; then
			exec_stop=$(grep "^ExecStop=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi
		local exec_reload=""
		if grep "^ExecReload=" ; then
			exec_reload=$(grep "^ExecReload=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi

		local user=""
		if grep "^User=" ; then
			user=$(grep "^User=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi

		local group=""
		if grep "^Group=" ; then
			group=$(grep "^Group=" "${init_path}" | cut -f 2 -d "=" | sed -E -e "s#^(-|+)##")
		fi

		local needs_syslog=0
		local cond=""
		local runlevels=""
		if grep -q -e "^Wants=.*network.target" "${init_path}" ; then
			cond="${FINIT_COND_NETWORK}"
			runlevels="345"
			echo "${c}/${pn}" >> "${NEEDS_NET_PATH}"
		else
			runlevels="2345"
		fi

		if grep -q -e "^Type=dbus" "${init_path}" ; then
			echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
		fi

		if grep -q -E -e "^StandardOutput=syslog" "${init_path}" \
			|| grep -q -E -e "^StandardError=syslog" "${init_path}" ; then
			if [[ -n "${cond}" ]] ; then
				cond="${cond},syslogd"
			else
				cond="${cond}"
			fi
		fi

		notify="notify:systemd"

		if [[ -n "${exec_start_pre}" ]] ; then
			echo "run [${runlevels}] name:${pn}-pre-start ${exec_start_pre} -- ${pn} pre-start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi
		if [[ -n "${exec_start}" ]] ; then
			[[ -n "${cond}" ]] && cond="<${cond}>"
			local user_group="@"
			[[ -n "${user}" ]] && user_group="${user}"
			[[ -n "${user}" ]] && user_group=":${group}"
			echo "service [${runlevels}] ${cond} ${user_group} name:${pn}-start ${notify} ${pidfile} ${exec_start} \"start\" -- ${pn} start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi
		if [[ -n "${exec_start_post}" ]] ; then
			echo "run [${runlevels}] name:${pn}-post-start ${exec_start_post} -- ${pn} post-start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi
		if [[ -n "${exec_stop_pre}" ]] ; then
			echo "run [0] name:${pn}-pre-stop ${exec_stop_pre} -- ${pn} pre-stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi
		if [[ -n "${exec_stop}" ]] ; then
			echo "task [0] name:${pn}-stop ${exec_stop} -- ${pn} stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi
		if [[ -n "${exec_stop_post}" ]] ; then
			echo "run [0] name:${pn}-post-stop ${exec_stop_post} -- ${pn} post-stop" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
		fi

		mkdir -p "${CONFS_PATH}/${c}/${pn}"
		cat /dev/null > "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
	done
}

main() {
	[[ "${FINIT_SCRIPT_SOURCE}" =~ "openrc" ]] && convert_openrc
	[[ "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] && convert_systemd
}

main
