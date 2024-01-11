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
		cd "${overlay}" || die "ERR:  line number - $LINENO"
		L=(
			grep -F -l '#!/sbin/openrc-run' $(find ./ -name "*init*")
		)
else
		script_dir="/etc/init.d"
		echo "Processing ${script_dir}"
		cd "${script_dir}" || die "ERR:  line number - $LINENO"
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

			if grep -q "RC_SVCNAME" "${init_sh}" ; then
				sed -i -e "${top_ln}a export RC_SVCNAME=\"${svc_name}\"" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi
			sed -i -e "${top_ln}a export SVCNAME=\"${svc_name}\"" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "${top_ln}a export FN=\"\$1\"" "${init_sh}" || die "ERR:  line number - $LINENO"
			if ! grep -q -e "^start[(]" "${init_sh}" ; then
				sed -i -e "${top_ln}a export missing_start_fn=1" "${init_sh}" || die "ERR:  line number - $LINENO"
			fi

			local bottom_ln=$(cat "${init_sh}" | wc -l)
			sed -i -e "${bottom_ln}a . /lib/finit/scripts/lib/event.sh" "${init_sh}" || die "ERR:  line number - $LINENO"

			sed -i -e "s|#!/sbin/openrc-run|#!${FINIT_SHELL}|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "s|start-stop-daemon|start_stop_daemon|g" "${init_sh}" || die "ERR:  line number - $LINENO"
			sed -i -e "s|supervise-daemon|supervise_daemon|g" "${init_sh}" || die "ERR:  line number - $LINENO"

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
					cond="${cond},${FINIT_LOGGER}"
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

			local user=""
			local group=""
			if grep -q -e "^command_user=" "${init_path}" ; then
				command_user=$(grep -e "^command_user=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				if [[ "${command_user}" =~ "$" ]] ; then
					command_user="" # Temporary ignore
				else
					user=$(echo "${command_user}" | cut -f 1 -d ":")
					group=$(echo "${command_user}" | cut -f 1 -d ":")
				fi
			else
				if grep -q -e "^user=" "${init_path}" ; then
					user=$(grep -e "^user=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				fi
				if grep -q -e "^group=" "${init_path}" ; then
					group=$(grep -e "^group=" "${init_path}" | cut -f 2 -d "=" | sed -e 's|"||g') || die "ERR:  line number - $LINENO"
				fi
			fi

			# Calls setenv() from c which is assumed literal
			if [[ "${user}" =~ "$" ]] ; then
				user=""
			fi
			if [[ "${group}" =~ "$" ]] ; then
				group=""
			fi

			local basename_fn=$(basename "${init_sh}")

			mkdir -p "${CONFS_PATH}/${c}/${pn}"
			local init_conf="${CONFS_PATH}/${c}/${pn}/${svc_name}.conf"
			echo "Generating ${c}/${pn}/${svc_name}.conf"
			cat /dev/null > "${init_conf}"
			if grep -q -e "^start_pre" "${init_path}" ; then
				echo "run [${runlevels}] name:${svc_name}-pre /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start_pre\" -- ${svc_name} pre" >> "${init_conf}"
			fi

			needs_openrc_default_start() {
				if ! grep -q -e "^start" "${init_path}" && grep -q -e "^command=" "${init_path}" ; then
					return 0
				fi
				return 1
			}

			if grep -q -e "^start" "${init_path}" || needs_openrc_default_start ; then
				[[ -n "${cond}" ]] && cond="<${cond}>"
				local user_group=""
				if [[ -n "${user}" && -n "${group}" ]] ; then
					user_group="@${user}:${group}"
				elif [[ -n "${user}" ]] ; then
					user_group="@${user}"
				elif [[ -n "${group}" ]] ; then
					# Based on https://github.com/troglobit/finit/blob/4.6/src/service.c#L1443
					user_group="@root:${group}"
				fi
				echo "service [${runlevels}] ${cond} ${user_group} name:${svc_name} ${notify} ${pidfile} /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start\" -- ${svc_name}" >> "${init_conf}"
			fi
			if grep -q -e "^start_post" "${init_path}" ; then
				echo "run [${runlevels}] name:${svc_name}-post /lib/finit/scripts/${c}/${pn}/${basename_fn} \"start_post\" -- ${svc_name} post" >> "${init_conf}"
			fi
			if grep -q -e "^stop_pre" "${init_path}" ; then
				echo "run [0] name:${svc_name}-pre-stop /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop_pre\" -- ${svc_name} pre-stop" >> "${init_conf}"
			fi
			if grep -q -e "^stop" "${init_path}" ; then
				echo "task [0] name:${svc_name}-stop /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop\" -- ${svc_name} stop" >> "${init_conf}"
			fi
			if grep -q -e "^stop_post" "${init_path}" ; then
				echo "run [0] name:${svc_name}-post-stop /lib/finit/scripts/${c}/${pn}/${basename_fn} \"stop_post\" -- ${svc_name} post-stop" >> "${init_conf}"
			fi
			if grep -q -e "^extra_commands" "${init_path}" ; then
				local list=$(grep "extra_commands" "${init_path}" | cut -f 2 -d '"')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${svc_name}-${x}" >> "${init_conf}"
					echo "run [${runlevels}] <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" -- ${svc_name} ${x}" >> "${init_conf}"
				done
			fi
			if grep -q -e "^extra_started_commands" "${init_path}" ; then
				local list=$(grep "extra_started_commands" "${init_path}" | cut -f 2 -d '"')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${svc_name}-${x}  # For started service only" >> "${init_conf}"
					echo "run [${runlevels}] <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" -- ${svc_name} ${x}" >> 	"${init_conf}"
				done
			fi
			if grep -q -e "^extra_stopped_commands" "${init_path}" ; then
				local list=$(grep "extra_started_commands" "${init_path}" | cut -f 2 -d '"')
				for x in ${list} ; do
					echo "# Run as:  initctl cond set ${svc_name}-${x}  # For stopped service only" >> "${init_conf}"
					echo "run [${runlevels}] <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${basename_fn} \"${x}\" -- ${svc_name} ${x}" >> "${init_conf}"
				done
			fi
		done
	done

	cat "${NEEDS_NET_PATH}" | sort | uniq > "${NEEDS_NET_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${NEEDS_NET_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${SERVICES_PATH}" | sort | uniq > "${SERVICES_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${SERVICES_PATH}"{.t,} || die "ERR:  line number - $LINENO"

	cat "${PKGS_PATH}" | sort | uniq > "${PKGS_PATH}".t || die "ERR:  line number - $LINENO"
	mv "${PKGS_PATH}"{.t,} || die "ERR:  line number - $LINENO"
}

gen_systemd_wrapper() {
	mkdir -p "${SCRIPTS_PATH}/${c}/${pn}"
	[[ -z "${exec_start_pres}" ]] && exec_start_pres=":;"
	[[ -z "${exec_starts}" ]] && exec_starts=":;"
	[[ -z "${exec_start_posts}" ]] && exec_start_posts=":;"
	[[ -z "${exec_stop_pres}" ]] && exec_stop_pres=":;"
	local has_exec_stops=1
	if [[ -z "${exec_stops}" ]] ; then
		exec_stops=":;"
		has_exec_stops=0
	fi
	[[ -z "${exec_stop_posts}" ]] && exec_stop_posts=":;"
	[[ -z "${exec_reloads}" ]] && exec_reloads=":;"
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
			:;
		fi
	fi

	if [[ "${type}" != "oneshot" ]] && echo -e "${exec_starts}" | sed -e "/^$/d" | wc -l | grep -q "1" ; then
		command=$(echo -e "${exec_starts}" | sed -e "/^$/d" | head -n 1 | cut -f 1 -d " ")
		command_args=$(echo -e "${exec_starts}" | sed -e "/^$/d" | head -n 1 | cut -f 2- -d " ")
		[[ "${command}" == "${command_args}" ]] && command_args=""
	fi

cat <<EOF >"${SCRIPTS_PATH}/${c}/${pn}/${svc_name}.sh"
#!${FINIT_SHELL}
FN="\${1}"
. /lib/finit/scripts/lib/lib.sh
svc_name="${svc_name}"
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
		MAINPID=\$(pgrep "\${exec_start_exe}")
	fi
	[ -z "\${MAINPID}" ] && return 0
	if [ -n "\${numa_mask}" ] ; then
		:;
	fi
	if [ -n "\${numa_policy}" ] ; then
		:;
	fi
}

start() {
	start_ulimit
	if [ "\${type}" = "oneshot" ] ; then
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
	else
		sig="SIGTERM"
	fi
	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -s \${sig} \${x}
	done
}

_stop_mixed() {
	local sig=""
	if [ -n "\${kill_signal}" ] ; then
		sig="\${kill_signal}"
	else
		sig="SIGTERM"
	fi
	kill -s \${sig} \${MAINPID}
	local x
	for x in \${cgroup_unit_pids} ; do
		[ "\${x}" = \${MAINPID} ] && continue
		ps \${x} >/dev/null || continue
		kill -s SIGKILL \${x}
	done
}

_stop_process() {
	local sig=""
	if [ -n "\${kill_signal}" ] ; then
		sig="\${kill_signal}"
	else
		sig="SIGTERM"
	fi
	kill -s \${sig} \${MAINPID}
}

_stop_sighup() {
	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -s SIGHUP \${x}
	done
}

_stop_final_sigkill() {
	local sig=""
	if [ -n "\${final_kill_signal}" ] ; then
		sig="\${final_kill_signal}"
	else
		sig="SIGKILL"
	fi

	local x
	for x in \${cgroup_unit_pids} ; do
		ps \${x} >/dev/null || continue
		kill -s \${sig} \${x}
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
	elif [[ -n "\${pidfile}" ]] ; then
		MAINPID=\$(cat "\${pidfile}")
	else
		MAINPID=\$(pgrep "\${exec_start_exe}")
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
		:;
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
		MAINPID=\$(pgrep "\${exec_start_exe}")
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

	local init_path
	local init_path_orig
	for init_path_orig in $(find /lib/systemd/system /usr/lib/systemd/system -name "*.service") ; do
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

		local pidfile=""
		if grep -q "^PIDFile" "${init_path}" ; then
			pidfile=$(grep "^PIDFile" "${init_path}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
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



		# Calls setenv() from c which is assumed literal
		if [[ "${user}" =~ ("$"|"%") ]] ; then
			user=""
		fi
		if [[ "${group}" =~ ("$"|"%") ]] ; then
			group=""
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

		if grep -q -E -e "^StandardOutput=syslog" "${init_path}" \
			|| grep -q -E -e "^StandardError=syslog" "${init_path}" ; then
			if [[ -n "${cond}" ]] ; then
				cond="${cond},syslogd"
			else
				cond="${cond}"
			fi
		fi

		local init_conf="${CONFS_PATH}/${c}/${pn}/${svc_name}.conf"
		mkdir -p $(dirname "${init_conf}")
		echo "Generating ${c}/${pn}/${svc_name}.conf"
		cat /dev/null > "${init_conf}"
		echo "${c}/${pn}" >> "${PKGS_PATH}"
		echo "${pn}" >> "${SERVICES_PATH}"

		if grep -q -e "^Environment=" "${init_path}" ; then
			IFS=$'\n'
			local ROWS=( $(grep -e "^Environment" "${init_path}" | cut -f 2- -d "=") ) || die "ERR:  line number - $LINENO"
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
		exec_stops=""
		exec_stop_pres=""
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
				exec_start_pres="${exec_start_pres}\n${exec_start_pre}"
			fi
			local exec_start=""
			if echo "${row}" | grep -q "^ExecStart=" ; then
				exec_start=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_start=$(echo "${exec_start}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_starts="${exec_starts}\n${exec_start}"
			fi
			local exec_start_post=""
			if echo "${row}" | grep -q "^ExecStartPost=" ; then
				exec_start_post=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_start_post=$(echo "${exec_start_post}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_start_posts="${exec_start_posts}\n${exec_start_post}"
			fi

			local exec_stop_pre=""
			if echo "${row}" | grep -q "^ExecStopPre=" ; then
				exec_stop_pre=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop_pre=$(echo "${exec_stop_pre}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stop_pres="${exec_stop_pres}\n${exec_stop_pre}"
			fi

			local exec_stop=""
			if echo "${row}" | grep -q "^ExecStop=" ; then
				exec_stop=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop=$(echo "${exec_stop}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stops="${exec_stops}\n${exec_stop}"
			fi

			local exec_stop_post=""
			if echo "${row}" | grep -q "^ExecStopPost=" ; then
				exec_stop_post=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_stop_post=$(echo "${exec_stop_post}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_stop_posts="${exec_stop_posts}\n${exec_stop_post}"
			fi

			local exec_reload=""
			if echo "${row}" | grep -q "^ExecReload=" ; then
				exec_reload=$(echo "${row}" | cut -f 2 -d "=") || die "ERR:  line number - $LINENO"
				exec_reload=$(echo "${exec_reload}" | sed -r -e 's#^(@|-|[+]|!!|!)##')
				exec_reloads="${exec_reloads}\n${exec_reload}"
			fi
		done
		IFS=$' \t\n'
		gen_systemd_wrapper

		if (( "${#exec_start_pres}" > 0 )) ; then
			echo "run [${runlevels}] name:${pn}-pre /lib/finit/scripts/${c}/${pn}/${svc_name}.sh start_pre -- ${svc_name} pre" >> "${init_conf}"
		fi
		if (( "${#exec_starts}" > 0 )) ; then
			[[ -n "${environment_file}" ]] && environment_file="env:${environment_file}"
			[[ -n "${cond}" ]] && cond="<${cond}>"
			local user_group=""
			if [[ -n "${user}" && -n "${group}" ]] ; then
				user_group="@${user}:${group}"
			elif [[ -n "${user}" ]] ; then
				user_group="@${user}"
			elif [[ -n "${group}" ]] ; then
				user_group="@:${group}"
			fi
			if [[ "${type}" == "oneshot" ]] && grep -E -e "^ExecStart=" | wc -l "${init_path}" | grep -q "1" ; then
				echo "task [${runlevels}] ${cond} ${user_group} name:${svc_name} ${environment_file} ${pidfile} /lib/finit/scripts/${svc_name}.sh start -- ${svc_name}" >> "${init_conf}"
			elif [[ "${type}" == "oneshot" ]] ; then
				# It is unknown if they must be run sequentially if more than 1.
				echo "run [${runlevels}] ${cond} ${user_group} name:${svc_name} ${environment_file} ${pidfile} /lib/finit/scripts/${svc_name}.sh start -- ${svc_name}" >> "${init_conf}"
			else
				echo "service [${runlevels}] ${cond} ${user_group} name:${svc_name} ${notify} ${environment_file} ${pidfile} /lib/finit/scripts/${svc_name}.sh start -- ${svc_name}" >> "${init_conf}"
			fi
		fi
		if (( "${#exec_start_posts}" > 0 )) ; then
			echo "run [${runlevels}] name:${svc_name}-post /lib/finit/scripts/${c}/${pn}/${svc_name}.sh start_post -- ${svc_name} post" >> "${init_conf}"
		fi
		if (( "${#exec_stop_pres}" > 0 )) ; then
			echo "run [0] name:${svc_name}-pre-stop /lib/finit/scripts/${c}/${pn}/${svc_name}.sh stop_pre -- ${svc_name} pre-stop" >> "${init_conf}"
		fi
		if (( "${#exec_stops}" > 0 )) ; then
			echo "task [0] name:${svc_name}-stop /lib/finit/scripts/${c}/${pn}/${svc_name}.sh stop -- ${svc_name} stop" >> "${init_conf}"
		fi
		if (( "${#exec_stop_posts}" > 0 )) ; then
			echo "run [0] name:${svc_name}-post-stop /lib/finit/scripts/${c}/${pn}/${svc_name}.sh stop_post -- ${svc_name} post-stop" >> "${init_conf}"
		fi
		if (( "${#exec_reloads}" > 0 )) ; then
			local x="reload"
			echo "# Run as:  initctl cond set ${svc_name}-${x}  # For stopped service only" >> "${init_conf}"
			echo "run [${runlevels}] <usr/${svc_name}-${x}> /lib/finit/scripts/${c}/${pn}/${svc_name}.sh reload -- ${svc_name} ${x}" >> "${init_conf}"
		fi
		rm "${init_path}"
	done

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
