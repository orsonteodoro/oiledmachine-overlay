#!/bin/sh

# Compatibility lib

if [ -e "/etc/conf.d/${SVCNAME}" ] ; then
	. "/etc/conf.d/${SVCNAME}"
fi

MAINTENANCE_MODE=${MAINTENANCE_MODE:-0}
if cat /proc/cmdline | grep -q -e "finit.systemd=debug" ; then
	MAINTENANCE_MODE=1
elif cat /proc/cmdline | grep -q -e "finit.openrc=debug" ; then
	MAINTENANCE_MODE=1
fi

_checkpath_once() {
	local path="$1"
	path=$(realpath "${path}")

	if [ $truncate_dir -eq 1 ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		rm -rf "${path}"
	fi

	if [ $truncate_file -eq 1 ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		rm -rf "${path}"
	fi

	if [ "${type}" = "d" ] && [ ! -d "${path}" ] ; then
		mkdir -p "${path}"
	fi

	if [ "${type}" = "f" ] && [ ! -f "${path}" ] ; then
		if echo "${path}" | grep -q "/" ; then
			mkdir -p $(dirname "${path}")
		fi
		touch "${path}"
	fi

	if [ "${type}" = "s" ] ; then
		if [ -s "${path}" ] ; then
			return 0
		else
			return 1
		fi
	fi

	if [ "${type}" = "p" ] ; then
		if echo "${path}" | grep -q "/" ; then
			mkdir -p $(dirname "${path}")
		fi
		mkfifo "${path}"
	fi

	if [ -n "${owner}" ] ; then
		chown "${owner}" "${path}"
	fi
	if [ -n "${mode}" ] ; then
		chmod "${mode}" "${path}"
	elif [ "${type}" = "d" ] ; then
		chmod "0775" "${path}"
	elif [ "${type}" = "f" ] ; then
		chmod "0644" "${path}"
	fi
}

checkpath() {
	local mode=""
	local owner=""
	local quiet=0
	local truncate_file=0
	local truncate_dir=0
	local type=""
	local writeable=0
	while [ -n "$1" ] ; do
		case $1 in
			--directory|-d)
				type="d"
				;;
			--directory-truncate|-D)
				type="d"
				truncate_dir=1
				;;
			--file|-f)
				type="f"
				;;
			--mode|-m)
				shift
				mode="$1"
				;;
			--owner|-o)
				shift
				owner="$1"
				;;
			--pipe|-p)
				type="p"
				;;
			--quiet|-q)
				quiet=1
				;;
			--file-truncate|-F)
				type="f"
				truncate_file=1
				;;
			--symlinks|-s)
				type="s"
				;;
			--writable|-W)
				writeable=1
				;;
			*)
				break
				;;
		esac
		shift
	done

	while [ -n "$1" ] ; do
		_checkpath_once "$1"
		shift
	done
}

is_debug() {
	if [ ${MAINTENANCE_MODE} -eq 1 ] ; then
		return 0
	else
		return 1
	fi
}

# Assumes eend called to add either [OK] or [FAILED]
ebegin() {
	is_debug && echo -n "${1}"
}

eend() {
	local ret=${1}
	local message="${2}"
	if [ -n "${message}" ] && [ ${ret} -eq 0 ] ; then
		is_debug && echo "${message} [  OK  ]"
	elif [ -n "${message}" ] && [ ${ret} -ne 0 ] ; then
		is_debug && echo "${message} [FAILED]"
	elif [ ${ret} -eq 0 ] ; then
		is_debug && echo "[  OK  ]"
	else
		is_debug && echo "[FAILED]"
	fi
	return ${ret}
}

ewend() {
	eend
}

einfo() {
	is_debug && echo "${1}"
}

ewarn() {
	is_debug && echo "[w] ${1}"
}

eerror() {
	is_debug && echo "[e] ${1}"
	exit 1
}

einfon() {
	is_debug && echo -n "${1}"
}

ewaitfile() {
	local duration=${1}
	shift
	sleep ${duration}
	local s0=$(date +"%s")
	local sf=$(( ${s0} + ${duration} ))
	while true ; do
		local c=0
		for x in "$@" ; do
			if [ -e "${x}" ] ; then
				c=$(( ${c} + 1 ))
			fi
		done
		if [ ${c} -eq ${#} ] ; then
			return 0
		fi
		local now=$(date +"%s")
		if [ ${now} -gt ${sf} ] ; then
			return 1
		fi
	done
	return 1
}

service_started() {
	local name="${1}"
	if initctl \
		| grep "running" \
		| grep "${name}" 2>/dev/null 1>/dev/null ; then
		return 0
	else
		return 1
        fi
}

is_pid_alive() {
	local pid=$1
	if [ -e /proc/$pid ] ; then
		true
	else
		false
	fi
}

gen_chroot_start() {
	mkdir -p "${chroot_dir}/tmp"
	rm -f "${chroot_dir}/tmp/run.sh"
	: ${FINIT_SHELL:=/bin/sh}
	# TODO:
cat <<EOF >"${chroot_dir}/tmp/run.sh"
#!${FINIT_SHELL}
background=${background}
capabilities="${capabilities}"
chdir_path="${chdir_path}"
cpu_affinity="${cpu_affinity}"
daemon=${daemon}
exec_args="${exec_args}"
exec_path="${exec_path}"
group="${group}"
iosched_arg="${iosched_arg}"
make_pidfile=${make_pidfile}
nicelevel=${nicelevel}
phase="start"
pid=${pid}
pidfile_path="${pidfile_path}"
ppid=${ppid}
service_pid=0
umask="${umask}"
user="${user}"

is_pid_alive() {
	local pid=\$1
	if [ -e /proc/\$pid ] ; then
		true
	else
		false
	fi
}

chroot_start() {
	if [ -n "\${chdir_path}" ] ; then
		chdir_path=\$(echo "\${chdir_path}" | sed -e 's|"||g')
		cd "\${chdir_path}"
	fi

	local ug_args=""
	if [ -n "\${user}" ] ; then
		local uid=\$(getent passwd "\${user}" | cut -f 3 -d ":")
		ug_args="\${ug_args} --uid=\${uid}"
	fi
	if [ -z "\${user}" ] ; then
		local uid=\$(getent passwd "root" | cut -f 3 -d ":")
		ug_args="\${ug_args} --uid=\${uid}"
	fi
	if [ -n "\${group}" ] ; then
		local gid=\$(getent group "\${group}" | cut -f 3 -d ":")
		 ug_args="\${ug_args} --gid=\${gid}"
	fi

	# TODO:  add capabilities

	local exec_args="\$@"
	set --
	for x in \${exec_args} ; do
		set -- \$@ \$(echo "\${x}" | sed -e 's|"||g')
	done

	if [ -n "${umask}" ] ; then
		umask \${umask}
	fi

	if [ \$do_exec -eq 1 ] ; then
		exec "\${exec_path}" \$@ &
	else
		sudo \${ug_args} -- "\${exec_path}" \$@ &
	fi
	local c=0
	while [ \$c -lt 100 ] ; do
		service_pid=\$(ps --no-headers -C $(basename "\${exec_path}") -o pid 2>/dev/null)
		if [ -n "\${service_pid}" ] && [ \$service_pid -gt 0 ] ; then
			break
		fi
		c=\$(( \${c} + 1 ))
		sleep 0.1
	done


	if [ -z "\${service_pid}" ] ; then
		return 1
	fi

	if [ \$make_pidfile -eq 1 ]  || [ "\$indirect_make_pidfile" = "1" ] ; then
		mkdir -p \$(dirname "\${pidfile_path}")
		echo "\${service_pid}" > "\${pidfile_path}"
	fi

	if [ -n "\${iosched_arg}" ] ; then
		local class="\${iosched_arg%:*}"
		local priority="\${iosched_arg#*:}"
		if [ \$class -eq 3 ] && [ -z "\$priority" ] ; then
			priority=7
		fi
		if [ \$class -ne 3 ] && [ -z "\$priority" ] ; then
			priority=4
		fi
		ionice -c \${class} -n \${priority} \${service_pid}
	fi

	if [ -n "\${procsched_arg}" ] ; then
		local policy="\${procsched_arg%:*}"
		local priority="\${procsched_arg#*:}"
		if [ -z "\${priority}" ] ; then
			priority=0
		fi
		chrt --\${policy} -p \$priority \${service_pid}
	fi

	if [ -n "\$nicelevel" ] ; then
		renice -n \$nicelevel -p \${service_pid}
	fi

	if [ -n "\${cpu_affinity}" ] ; then
		taskset --cpu-list \${cpu_afinity} -p \${service_pid}
	fi

	if [ "\${phase}" = "start" ] ; then
		if ! is_pid_alive \$service_pid ; then
			echo "Did not detect pid"
			return 1
		fi
		echo "service_pid:  \$service_pid"
		if [ \$daemon -eq 1 ] || [ \$background -eq 1 ] ; then
	# Keep as background
			:;
		else
	# Bring to foreground
			fg
		fi
	fi
}
chroot_start

EOF
	chmod +x "${chroot_dir}/tmp/run.sh"
	chroot "${chroot_dir}" "/tmp/run.sh"

}

# Fix dash quirk
check_pgrep() {
	local v=$(pgrep $@ 2>/dev/null)
	if [ -z "${v}" ] ; then
		false
	else
		true
	fi
}

check_alive_by_name() {
	local name="${1}"
	name=$(basename "${name}")
	if ps --no-headers -C "${name}" | wc -l | grep -q "0" ; then
		false
	else
		true
	fi
}


start_stop_daemon() {
	# systemd
	local ambient_capabilities=""
	local not_ambient_capabilities=""
	local bounding_capabilities=""
	local not_bounding_capabilities=""

	# openrc
	local background=0
	local capabilities=""
	local cpu_affinity=""
	local daemon=0
	local chdir_path=""
	local chroot_path=""
	local chuid=""
	local dirmode=""
	local exec_path=""
	local group=""
	local iosched_arg=""
	local make_pidfile=0
	local mode=""
	local name=""
	local nicelevel=0
	local phase=""
	local pid=0
	local pidfile_path=""
	local ppid=0
	local procsched_arg=""
	local quiet=0
	local remove_pidfile=0
	local sched_reset_on_fork=0
	local service_pid=0
	local signal=""
	local status=0
	local stderr=""
	local stdout=""
	local umask=""
	local user=""
	while [ -n "$1" ] ; do
		case $1 in
			--)
				shift
				break
				;;
			# TODO:  deprecate and use --capabilities
			--ambient-capabilities=*)
				ambient_capabilities="${1#*=}"
				;;
			--background|-b)
				background=1
				;;
			# TODO:  deprecate and use --capabilities
			--bounding-capabilities=*)
				bounding_capabilities="${1#*=}"
				;;
			--capabilities=*)
				capabilities="${1#*=}"
				;;
			--chdir=*)
				chdir_path="${1#*=}"
				;;
			--chdir|-d)
				shift
				chdir_path="$1"
				;;
			--chroot|-r)
				shift
				chroot_path="$1"
				;;
			--chuid|-c)
				shift
				chuid="$1"
				;;
			--cpu-affinity)
				shift
				cpu_affinity="$1"
				;;
			--daemon)
				daemon=1
				;;
			--dirmode)
				;;
			--group=*)
				group="${1#*=}"
				;;
			--groups|--group|-g)
				shift
				group="$1"
				;;
			--iosched|-I)
				shift
				iosched_arg="$1"
				;;
			--exec=*)
				exec_path="${1#*=}"
				;;
			--exec|-x)
				shift
				exec_path="$1"
				;;
			--make-pidfile|-m)
				make_pidfile=1
				;;
			--mode)
				;;
			--name|-n)
				shift
				name="$1"
				;;
			--nice=*)
				nicelevel="${1#*=}"
				;;
			--nicelevel|-N)
				shift
				nicelevel="$1"
				;;
			# TODO:  deprecate and use --capabilities
			--not-ambient-capabilities=*)
				not_ambient_capabilities="${1#*=}"
				;;
			# TODO:  deprecate and use --capabilities
			--not-bounding-capabilities=*)
				not_bounding_capabilities="${1#*=}"
				;;
			--pid)
				pid="$1"
				;;
			--ppid)
				ppid="$1"
				;;
			--pidfile=*)
				pidfile_path="${1#*=}"
				;;
			--pidfile|-p)
				shift
				pidfile_path="$1"
				;;
			--procsched|-P)
				shift
				procsched_arg="$1"
				;;
			--quiet|-q)
				quiet=1
				;;
			--remove-pidfile)
				remove_pidfile=1
				;;
			--retry=*)
				retry="${1#*=}"
				;;
			--retry|-R)
				shift
				retry="$1"
				;;
			--sched-reset-on-fork)
				sched_reset_on_fork=1
				;;
			--signal)
				shift
				signal="$1"
				;;
			--start|-S)
				phase="start"
				;;
			--startas|-a)
				shift
				phase="start"
				exec_path="$1"
				;;
			--status|-T)
				status=1
				;;
			--stderr)
				shift
				stderr="$1"
				;;
			--stdout)
				shift
				stdout="$1"
				;;
			--stop|-K)
				phase="stop"
				;;
			--umask|-k)
				shift
				umask="$1"
				;;
			--user=*)
				user="${1#*=}"
				;;
			--user|-u)
				shift
				user="$1"
				;;
			--verbose|-v)
				quiet=0
				;;
			--version|-V)
				;;
			--help|-H)
				;;
		esac
		shift
	done

	if [ -n "${chuid}" ] ; then
		user=$(echo "${chuid}" | cut -f 1 -d ":")
		group=$(echo "${chuid}" | cut -f 2 -d ":")
	fi

	local _pid=0
	if [ "${phase}" = "start" ] ; then
		if [ -n "${chroot_dir}" ] ; then
			gen_chroot_start
			return 0
		fi

		if [ -n "${chdir_path}" ] ; then
			chdir_path=$(echo "${chdir_path}" | sed -e 's|"||g')
			cd "${chdir_path}"
		fi

		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid
		elif [ -e "${pidfile_path}" ] ; then
			if is_pid_alive $(cat "${pidfile_path}") ; then
				true
			else
				rm -f "${pidfile_path}"
				false
			fi
		elif [ -n "${exec_path}" ] ; then
			check_alive_by_name "${exec_path}"
		elif [ -n "${name}" ] ; then
			check_alive_by_name "${name}"
		elif [ -n "${user}" ] ; then
			check_pgrep -U "${user}" >/dev/null 2>&1
		fi

		if [ $? -eq 0 ] ; then
			return 1
		fi

		local ug_args=""
		if [ -n "${user}" ] ; then
			local uid=$(getent passwd "${user}" | cut -f 3 -d ":")
			ug_args="${ug_args} -u ${uid}"
		fi
		if [ -z "${user}" ] ; then
			local uid=$(getent passwd "root" | cut -f 3 -d ":")
			ug_args="${ug_args} -u root"
		fi
		if [ -n "${group}" ] ; then
			local gid=$(getent group "${group}" | cut -f 3 -d ":")
			 ug_args="${ug_args} -g ${gid}"
		fi

		# TODO:  capabilities

		local exec_args="$@"
		set --
		for x in ${exec_args} ; do
			set -- $@ $(echo "${x}" | sed -e 's|"||g')
		done

		if [ -n "${umask}" ] ; then
			umask ${umask}
		fi

		if [ $do_exec -eq 1 ] ; then
			exec "${exec_path}" $@ &
		else
			sudo ${ug_args} -- "${exec_path}" $@ &
		fi
		local c=0
		while [ $c -lt 10 ] ; do
			service_pid=$(ps --no-headers -C $(basename "${exec_path}") -o pid 2>/dev/null)
			if [ -n "${service_pid}" ] ; then
				break
			fi
			c=$(( ${c} + 1 ))
			sleep 0.1
		done

		if [ -z "${service_pid}" ] ; then
			return 1
		fi

		if [ $make_pidfile -eq 1 ] || [ "$indirect_make_pidfile" = "1" ] ; then
			mkdir -p $(dirname "${pidfile_path}")
			echo "${service_pid}" > "${pidfile_path}"
		fi
	elif [ "${phase}" = "stop" ] ; then
		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid
		elif [ -e "${pidfile_path}" ] ; then
			is_pid_alive $(cat "${pidfile_path}")
		elif [ -n "${exec_path}" ] ; then
			check_alive_by_name "${exec_path}"
		elif [ -n "${name}" ] ; then
			check_alive_by_name "${name}"
		elif [ -n "${user}" ] ; then
			check_pgrep -U "${user}" >/dev/null 2>&1
		else
			return 0
		fi

		local _signal

		if [ -n "$signal" ] ; then
			_signal="${signal}"
		else
			_signal="SIGTERM"
		fi

		if [ $pid -gt 0 ] ; then
			service_pid=$pid
			kill -s ${_signal} $service_pid
		elif [ $ppid -gt 0 ] ; then
			service_pid=$ppid
			kill -s ${_signal} $service_pid
		elif [ -e "${pidfile_path}" ] ; then
			service_pid=$(cat "${pidfile_path}")
			kill -s ${_signal} $service_pid
		elif [ -n "${exec_path}" ] ; then
			local bn=$(basename "${exec_path}")
			service_pid=$(pgrep "${bn}")
			kill -s ${_signal} $service_pid
		elif [ -n "${name}" ] ; then
			service_pid=$(pgrep "${name}")
			kill -s ${_signal} $service_pid
		elif [ -n "${user}" ] ; then
			service_pid=$(pgrep -U "${user}")
			kill -s ${_signal} $service_pid
		fi

		is_pid_alive ${service_pid} || return 0

		if [ -n "${retry}" ] && echo "${retry}" | grep -q "/" ; then
			local _retry=$(echo "${retry}" | sed -e "s| |/|g")
			local pair1=$(echo "${_retry}" | cut -f 1-2 -d "/")
			local pair2=$(echo "${_retry}" | cut -f 3-4 -d "/")

			local sig
			local duration
			local now
			local time_finished

			sig="${pair1%/*}"
			duration=${pair1#*/}
			now=$(date +"%s")
			time_final=$(( ${now} + ${duration} ))
			kill -s ${sig} ${service_pid}
			while [ $now -lt ${time_final} ] ; do
				is_pid_alive ${service_pid} || return 0
				now=$(date +"%s")
			done

			if [ -n "${pair2}" ] ; then
				sig="${pair2%/*}"
				duration=${pair2#*/}
				now=$(date +"%s")
				time_final=$(( ${now} + ${duration} ))
				kill -s ${sig} ${service_pid}
				while [ $now -lt ${time_final} ] ; do
					is_pid_alive ${service_pid} || return 0
					now=$(date +"%s")
				done
			fi
		elif [ -n "${retry}" ] ; then
			sig="TERM"
			duration=${retry}
			now=$(date +"%s")
			time_final=$(( ${now} + ${duration} ))
			kill -s ${sig} ${service_pid}
			while [ $now -lt ${time_final} ] ; do
				is_pid_alive ${service_pid} || return 0
				now=$(date +"%s")
			done
		else
			sig="TERM"
			duration=5
			now=$(date +"%s")
			time_final=$(( ${now} + ${duration} ))
			kill -s ${sig} ${service_pid}
			while [ $now -lt ${time_final} ] ; do
				is_pid_alive ${service_pid} || return 0
				now=$(date +"%s")
			done
		fi

		if [ $remove_pidfile -eq 1 ] && [ -e "${pidfile_path}" ] ; then
			rm -f "${pidfile_path}"
		fi

		is_pid_alive ${service_pid} || return 2
		return 0
	elif [ "${status}" -eq 1 ] ; then
		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid
		elif [ -e "${pidfile_path}" ] ; then
			check_pgrep $(cat "${pidfile_path}") >/dev/null 2>&1
		elif [ -n "${exec_path}" ] ; then
			check_alive_by_name "${exec_path}"
		elif [ -n "${name}" ] ; then
			check_alive_by_name "${name}"
		elif [ -n "${user}" ] ; then
			check_pgrep -U "${user}" >/dev/null 2>&1
		else
			false
		fi

		if [ $? -eq 0 ] ; then
			return 0
		else
			return 1
		fi
	fi

	if [ -n "${iosched_arg}" ] ; then
		local class="${iosched_arg%:*}"
		local priority="${iosched_arg#*:}"
		if [ $class -eq 3 ] && [ -z "$priority" ] ; then
			priority=7
		fi
		if [ $class -ne 3 ] && [ -z "$priority" ] ; then
			priority=4
		fi
		ionice -c ${class} -n ${priority} -p ${service_pid}
	fi

	if [ -n "${procsched_arg}" ] ; then
		local policy="${procsched_arg%:*}"
		local priority="${procsched_arg#*:}"
		if [ -z "${priority}" ] ; then
			priority=0
		fi
		local reset_on_fork=""
		if [ ${sched_reset_on_fork} -eq 1 ] ; then
			reset_on_fork="-R"
		fi
		chrt ${reset_on_fork} --${policy} -p $priority ${service_pid}
	fi

	if [ -n "$nicelevel" ] ; then
		renice -n $nicelevel -p ${service_pid}
	fi


	if [ -n "${cpu_affinity}" ] ; then
		taskset --cpu-list ${cpu_afinity} -p ${service_pid}
	fi

	if [ "${phase}" = "start" ] ; then
		if ! is_pid_alive $service_pid ; then
			echo "Did not detect pid"
			return 1
		fi
		echo "service_pid:  $service_pid"
		if [ $daemon -eq 1 ] || [ $background -eq 1 ] ; then
	# Keep as background
			:;
		else
	# Bring to foreground
			fg 2>/dev/null
		fi
	fi
	return 0
}

supervise_daemon() {
	start_stop_daemon $@
}

default_start() {
	local args=""
	if [ "${command_background}" = "true" ] || [ "${command_background}" = "1" ] || [ "${command_background}" = "yes" ] ; then
		args="${args} --background --make-pidfile"
	fi
	local prefix=$(echo "${ambient_capabilities}" | cut -c 1)
	if [ -n "${ambient_capabilities}" ] && [ "${prefix}" != "-" ] ; then
		args="${args} --ambient-capabilities ${ambient_capabilities}"
	fi
	if [ -n "${not_ambient_capabilities}" ] && [ "${prefix}" = "-" ] ; then
		args="${args} --not-ambient-capabilities ${not_ambient_capabilities}"
	fi
	local prefix=$(echo "${bounding_capabilities}" | cut -c 1)
	if [ -n "${bounding_capabilities}" ] && [ "${prefix}" != "-" ] ; then
		args="${args} --bounding-capabilities ${bounding_capabilities}"
	fi
	if [ -n "${not_bounding_capabilities}" ] && [ "${prefix}" = "-" ] ; then
		args="${args} --not-bounding-capabilities ${not_bounding_capabilities}"
	fi
	if [ -n "${user}" ] ; then
		args="${args} --user ${user} ${args}"
	fi
	if [ -n "${group}" ] ; then
		args="${args} --group ${group} ${args}"
	fi
	if [ -n "${nice}" ] ; then
		args="${args} --nicelevel ${nice}"
	fi
	if [ -n "${command_user}" ] ; then
		if echo "${command_user}" && grep ":" ; then
			local u=$(echo "${command_user}" | cut -f 1 -d ":")
			local g=$(echo "${command_user}" | cut -f 2 -d ":")
			args="${args} --user ${u}"
			args="${args} --group ${g}"
		else
			local u=$(echo "${command_user}" | cut -f 1 -d ":")
			args="${args} --user ${u}"
		fi
	fi

	if [ -n "${cpu_scheduling_policy}" ] && [ -z "${cpu_scheduling_priority}" ] ; then
		args="${args} --procsched ${cpu_scheduling_policy}"
	elif [ -n "${cpu_scheduling_policy}" ] && [ -n "${cpu_scheduling_priority}" ] ; then
		args="${args} --procsched ${cpu_scheduling_policy}:${cpu_scheduling_priority}"
	fi

	if [ -n "${io_scheduling_class}" ] && [ -z "${io_scheduling_priority}" ] ; then
		args="${args} --iosched ${io_scheduling_class}"
	elif [ -n "${io_scheduling_class}" ] && [ -n "${io_scheduling_priority}" ] ; then
		args="${args} --iosched ${io_scheduling_class}:${io_scheduling_priority}"
	fi

	if [ "${cpu_scheduling_reset_on_fork}" = "true" ] ; then
		args="${args} --sched-reset-on-fork"
	fi

	if [ -n "${cpu_affinity}" ] ; then
		args="${args} --cpu-affinity ${cpu_affinity}"
	fi

	if [ -n "${pidfile}" ] ;then
		args="${args} --pidfile ${pidfile}"
	fi
	start_stop_daemon \
		--start \
		--exec "${command}" \
		${start_stop_daemon_args} \
		${args} \
		-- \
		${command_args}
}

mark_service_inactive() {
	local svcname="${1}"
}

mark_service_starting() {
	:;
}

mark_service_started() {
	:;
}

mark_service_stopped() {
	:;
}

yesno() {
	local val="${1}"
	local ret=0
	case ${val} in
		Y*|y*)
			ret=0
			;;
		N*|n*)
			ret=1
			;;
		*)
			ret=1
			;;
	esac
	return ${ret}
}

service_set_value() {
	local name="${1}"
	local value="${2}"
	mkdir -p "/var/cache/finit/kv-database/${SVCNAME}"
	echo "${value}" > "/var/cache/finit/kv-database/${SVCNAME}/${name}"
}

service_get_value() {
	local name="${1}"
	if [ -e "/var/cache/finit/kv-database/${SVCNAME}/${name}" ] ; then
		cat "/var/cache/finit/kv-database/${SVCNAME}/${name}"
	else
		echo ""
	fi
}

clear_kv_store() {
	rm -rf "/var/cache/finit/kv-database/${SVCNAME}"
}

# A bashism
type() {
	while [ -n "$1" ] ; do
		case $1 in
			-a)
				;;
			-f)
				;;
			-P)
				;;
			-p)
				;;
			-t)
				;;
			*)
				break
		esac
		shift
	done
	which $@ >/dev/null 2>&1
}

eoutdent() {
	return 0
}

eindent() {
	return 0
}

vebegin() {
	local msg="${1}"
	is_debug && echo "${msg}"
	return 0
}

veend() {
	local ret="${1}"
	local msg="${2}"
	is_debug && echo "${msg}"
	return ${ret}
}

veinfo() {
	local msg="${1}"
	is_debug && echo "${msg}"
	return 0
}

vewarn() {
	local msg="${1}"
	is_debug && echo "[w] ${msg}"
	return 0
}

veerror() {
	local msg="${1}"
	is_debug && echo "[e] ${msg}"
	return 0
}

einfon() {
	local msg="${1}"
	is_debug && echo "${msg}"
	return 0
}

rc_service() {
	local svcname="${1}"
	local phase="${2}"
	return 0
}
