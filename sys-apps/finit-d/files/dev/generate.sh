#!/bin/bash

DEFAULT_SHELL=${DEFAULT_SHELL:-"/bin/dash"}

add_overlays() {
	$(realpath /var/db/repos/*/*/*/*)
}

main() {
	echo > pkgs.txt
	echo > services.txt
	echo > needs_net.txt
	echo > needs_dbus.txt
	rm -rf confs
	mkdir -p confs
	rm -rf scripts
	mkdir -p scripts
	SCRIPTS_PATH="$(pwd)/scripts"
	CONFS_PATH="$(pwd)/confs"
	NEEDS_NET_PATH="$(pwd)/needs_net.txt"
	SERVICES_PATH="$(pwd)/services.txt"
	PKGS_PATH="$(pwd)/pkgs.txt"
	NEEDS_DBUS_PATH="$(pwd)/needs_dbus.txt"
	cd "${SCRIPTS_PATH}"
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
		for overlay in ${OVERLAYS[@]} ; do
			echo "Processing ${overlay} overlay"
			cd "${overlay}"
			L=(
				grep -F -l '#!/sbin/openrc-run' $(find ./ -name "*init*")
			)

			local t=()
			t=( $(echo "${L[@]}" | tr " " "\n" | sort | uniq) )
			L=( ${t[@]} )

			for init_path in ${L[@]} ; do
				local c=$(echo "${init_path}" | cut -f 2 -d "/")
				local pn=$(echo "${init_path}" | cut -f 3 -d "/")
				[[ -f "${init_path}" ]] || continue
				[[ "${init_path}" =~ ".ebuild"$ ]] && continue
				[[ "${init_path}" =~ ".patch"$ ]] && continue
				[[ "${c}/${pn}" = "metadata/md5-cache" ]] && continue
				local fn=$(basename "${init_path}")

				# Variations
				# Exact set
				fn=$(echo "${fn}" | sed -r -e "s|([a-z-]+)-[0-9]+-r[0-9]+\.initd$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|([a-z]+)-[0-9.]+-r[0-9]+\.initd$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|[0-9.]+-([a-z]+)\.init-r[0-9]+$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init\.d\.([A-Za-Z]+)-r[0-9]$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.init-r[0-9]+\.d$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init\.d-${pn}-r[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+-[0-9.]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-${pn}-[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^${pn}[0-9]+.initd$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+[a]$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^${pn}.init[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-r[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init-r[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init-[0-9.]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init\.${pn}$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|${pn}_initd$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^${pn}\.rc$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd-[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|^init.d$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^initd$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|^init$|${pn}|g")
				# Inexact set
				fn=$(echo "${fn}" | sed -r -e "s|init\.d\.([a-z]+)\.[0-9]+$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+[a]-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|([a-z_]+)-r[0-9]+.initd$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|${pn}-initd-r[0-9]$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|^rc_${pn}-r[0-9]+$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|^${pn}-[0-9.]+-init\.d-||g")
				fn=$(echo "${fn}" | sed -r -e "s|${pn}d\.initd$|${pn}d|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|${pn}\.initd$|${pn}|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|([a-z])\.initd$|\1|g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d-[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init\.d-[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init\.d\.[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init\.d$||g")
				fn=$(echo "${fn}" | sed -r -e "s|_init\.d_[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd-[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd\.[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.initd$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init\.d-r[0-9]$||g")
				fn=$(echo "${fn}" | sed -r -e "s|_initd-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-r[0-9]+\.init$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-initd$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+\.init$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9.]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init-[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9.]+-init$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-[0-9]+\.init$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init-r[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-initd-[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d\.ng$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init\.[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init-[0-9]+$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init[0-9]+||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.initd-new$||g")
				fn=$(echo "${fn}" | sed -r -e "s|.initscript$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init\.d$||g")
				fn=$(echo "${fn}" | sed -r -e "s|^init\.d_||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init\.d$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-initrc$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-initd$||g")
				fn=$(echo "${fn}" | sed -r -e "s|\.init$||g")
				fn=$(echo "${fn}" | sed -r -e "s|-init$||g")

				# Init script fragments.  Needs manual evaluation
				[[ "${init_path}" =~ "qemu-binfmt" ]] && continue

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
#				elif [[ "${init_path}" =~ "dev-ruby/rubygems" ]] && echo "${fn}" | grep -q -E -e "init.d-gem_server2" ; then
#					fn="gem_server"
#				elif [[ "${init_path}" =~ "mail-filter/MailScanner" ]] && echo "${fn}" | grep -q -E -e "initd.mailscanner" ; then
#					fn="MailScanner"
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
				sed -i -e "s|#!/sbin/openrc-run|#!${DEFAULT_SHELL}|g" "${dest}"

				if [[ "${init_path}" =~ "sys-apps/dbus" ]] && echo "${fn}" | grep -q -E -e "dbus.initd.in" ; then
					sed -i -e "s|@rundir@|/run|g" "${dest}"
				fi


				# ln = line number
				local top_ln=$(grep -n "# Distributed under" "${dest}" | cut -f 1 -d ":")
				local top_ln_fallback=$(grep -n "#!/sbin/openrc-run" "${dest}" | cut -f 1 -d ":")
				if [[ -n "${top_ln}" ]] ; then
					sed -i -e "${top_ln}a . /lib/finit/scripts/lib.sh" "${dest}"
					if grep -q "RC_SVCNAME" "${dest}" ; then
						sed -i -e "${top_ln}a RC_SVCNAME=\"${pn}\"" "${dest}"
					fi
					sed -i -e "${top_ln}a SVCNAME=\"${pn}\"" "${dest}"
				else
					sed -i -e "${top_ln_fallback}a . /lib/finit/scripts/lib.sh" "${dest}"
					if grep -q "RC_SVCNAME" "${dest}" ; then
						sed -i -e "${top_ln_fallback}a RC_SVCNAME=\"${pn}\"" "${dest}"
					fi
					sed -i -e "${top_ln_fallback}a SVCNAME=\"${pn}\"" "${dest}"
				fi
				local bottom_ln=$(cat "${dest}" | wc -l)
				sed -i -e "${bottom_ln}a . /lib/finit/scripts/event_handlers.sh" "${dest}"

				local runlevels=""
				if grep -q -e "need.*net" "${init_path}" ; then
					runlevels="345"
					echo "${c}/${pn}" >> "${NEEDS_NET_PATH}"
				else
					runlevels="2345"
				fi

				if grep -q -e "need.*dbus" "${init_path}" ; then
					echo "${c}/${pn}" >> "${NEEDS_DBUS_PATH}"
				fi

				local pidfile=""
				if grep -q -e "--make-pidfile" "${init_path}" ; then
					pidfile="pid:/run/${pn}.pid"
				fi

				if grep -q -e "^pidfile=\"" "${init_path}" ; then
					local p=$(grep "^pidfile=\"" "${init_path}" | head -n 1 | cut -f 2 -d '"')
					pidfile="pid:!${p}"
				fi
				if grep -q -e "^pidfile=" "${init_path}" ; then
					local p=$(grep "^pidfile=" "${init_path}" | head -n 1 | cut -f 2 -d "=")
					pidfile="pid:!${p}"
				fi

				mkdir -p "${CONFS_PATH}/${c}/${pn}"
				cat /dev/null > "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
				if grep -q -e "^start_pre" "${init_path}" ; then
					echo "run [${runlevels}] name:${pn}-pre-start /lib/finit/scripts/${c}/${pn}/${pn}.sh \"start_pre\" -- ${pn} pre-start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
				fi
				if grep -q -e "^start" "${init_path}" ; then
					echo "service [${runlevels}] name:${pn}-start ${pidfile} /lib/finit/scripts/${c}/${pn}/${pn}.sh \"start\" -- ${pn} start" >> "${CONFS_PATH}/${c}/${pn}/${pn}.conf"
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

	cat "${NEEDS_NET_PATH}" | sort | uniq > "${NEEDS_NET_PATH}".t
	mv "${NEEDS_NET_PATH}"{.t,}

	cat "${SERVICES_PATH}" | sort | uniq > "${SERVICES_PATH}".t
	mv "${SERVICES_PATH}"{.t,}

	cat "${PKGS_PATH}" | sort | uniq > "${PKGS_PATH}".t
	mv "${PKGS_PATH}"{.t,}
}
main
