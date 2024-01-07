#!/bin/sh

# Compatibility lib

if [ -e "/etc/conf.d/${SVCNAME}" ] ; then
	. "/etc/conf.d/${SVCNAME}"
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
	if [ "${MAINTENANCE_MODE}" = "1" ] ; then
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
		if [ ${c} -eq ${#L[@]} ] ; then
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

start_stop_daemon() {
	local background=0
	local daemon=0
	local chdir_path=""
	local dirmode=""
	local exec_path=""
	local group=""
	local iosched_arg=""
	local mode=""
	local make_pidfile=0
	local name=""
	local nicelevel=0
	local pid=0
	local ppid=0
	local pidfile_path=""
	local procsched_arg=""
	local phase=""
	local quiet=0
	local remove_pidfile=0
	local signal=""
	local status=0
	local stderr=""
	local stdout=""
	local user=""
	local service_pid=0
	local su_pid
	while [ -n "$1" ] ; do
		case $1 in
			--)
				shift
				break
				;;
			--background|-b)
				background=1
				;;
			--chdir=*)
				chdir_path="${1#*=}"
				;;
			--chdir|-d)
				shift
				chdir_path="$1"
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
			--signal)
				shift
				signal="$1"
				;;
			--start|-S)
				phase="start"
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

	if [ -n "${chdir_path}" ] ; then
		cd "${chdir_path}"
	fi

	local _pid=0
	if [ "${phase}" = "start" ] ; then
		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid >/dev/null
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid >/dev/null
		elif [ -n $pidfile ] ; then
			is_pid_alive $(cat "${pidfile}") >/dev/null
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}") >/dev/null
		elif [ -n $user ] ; then
			pgrep -U "${user}" >/dev/null
		elif [ -n $group ] ; then
			pgrep -G "${group}" >/dev/null
		fi

		if [ $? -eq 0 ] ; then
			return 1
		else
			local ug_args=""
			[[ -n "${group}" ]] && ug_args=" -g ${group}"
			[[ -n "${user}" ]] && ug_args=" ${user}"
			[[ -n "${user}" ]] || ug_args=" root"
			su ${ug_args} -c "${exec_path} $@" &
			su_pid=$!
			service_pid=$(pgrep -P ${su_pid})
		fi

		if [ $make_pidfile -eq 1 ] ; then
			echo "${service_pid}" > "${pidfile_path}"
		fi
	elif [ "${phase}" = "stop" ] ; then
		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid >/dev/null
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid >/dev/null
		elif [ -n $pidfile ] ; then
			pgrep $(cat "${pidfile}") >/dev/null
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}") >/dev/null
		elif [ -n $user ] ; then
			pgrep -U "${user}" >/dev/null
		elif [ -n $group ] ; then
			pgrep -G "${group}" >/dev/null
		elif [ -e $pidfile ] ; then
			is_pid_alive $(cat "${pidfile}") >/dev/null
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
		elif [ -e $pidfile ] ; then
			service_pid=$(cat "${pidfile}")
			kill -s ${_signal} $service_pid
		elif [ -n "$user" ] ; then
			service_pid=$(pgrep -U "${user}")
			kill -s ${_signal} $service_pid
		elif [ -n "$group" ] ; then
			service_pid=$(pgrep -G "${group}")
			kill -s ${_signal} $service_pid
		fi

		is_pid_alive ${service_pid} >/dev/null || return 0

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
				is_pid_alive ${service_pid} >/dev/null || return 0
				now=$(date +"%s")
			done

			if [ -n "${pair2}" ] ; then
				sig="${pair2%/*}"
				duration=${pair2#*/}
				now=$(date +"%s")
				time_final=$(( ${now} + ${duration} ))
				kill -s ${sig} ${service_pid}
				while [ $now -lt ${time_final} ] ; do
					is_pid_alive ${service_pid} >/dev/null || return 0
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
				is_pid_alive ${service_pid} >/dev/null || return 0
				now=$(date +"%s")
			done
		else
			sig="TERM"
			duration=5
			now=$(date +"%s")
			time_final=$(( ${now} + ${duration} ))
			kill -s ${sig} ${service_pid}
			while [ $now -lt ${time_final} ] ; do
				is_pid_alive ${service_pid} >/dev/null || return 0
				now=$(date +"%s")
			done
		fi

		if [ $remove_pidfile -eq 1 ] && [ -n "${pidfile_path}" ] ; then
			rm -f "${pidfile_path}"
		fi

		is_pid_alive ${service_pid} >/dev/null || return 2
		return 0
	elif [ "${status}" -eq 1 ] ; then
		if [ $pid -gt 0 ] ; then
			is_pid_alive $pid >/dev/null
		elif [ $ppid -gt 0 ] ; then
			is_pid_alive $ppid >/dev/null
		elif [ -n $pidfile ] ; then
			pgrep $(cat "${pidfile}") >/dev/null
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}") >/dev/null
		elif [ -n $user ] ; then
			pgrep -U "${user}" >/dev/null
		elif [ -n $group ] ; then
			pgrep -G "${group}" >/dev/null
		elif [ -e $pidfile ] && grep -q -E "[0-9]" "$pidfile" ; then
			true
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
		local args=""
		if [ $pid -gt 0 ] ; then
			args+=" -p $pid"
		fi
		if [ $ppid -gt 0 ] ; then
			args+=" -p $ppid"
		fi
		if [ $service_pid -gt 0 ] ; then
			args+=" -p ${service_pid}"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" -p "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+=" -p "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+=" -p "$(pgrep -U "${user}")
		fi
		if [ -n $group ] ; then
			args+=" -p "$(pgrep -G "${group}")
		fi
		if [ -n $name ] ; then
			args+=" -p "$(pgrep $name)
		fi
		ionice -c ${class} -n ${priority} ${args}
	fi

	if [ -n "${procsched_arg}" ] ; then
		local policy="${procsched_arg%:*}"
		local priority="${procsched_arg#*:}"
		if [ -z "${priority}" ] ; then
			priority=0
		fi
		local args=""
		if [ $pid -gt 0 ] ; then
			args+=" $pid"
		fi
		if [ $ppid -gt 0 ] ; then
			args+=" $ppid"
		fi
		if [ $service_pid -gt 0 ] ; then
			args+=" ${service_pid}"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+=" "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+=" "$(pgrep -U "${user}")
		fi
		if [ -n $group ] ; then
			args+=" "$(pgrep -G "${group}")
		fi
		if [ -n $name ] ; then
			args+=" "$(pgrep $name)
		fi
		set -- ${args}
		local x
		for x in $@ ; do
			chrt --${policy} -p $priority ${x}
		done
	fi

	if [ -n "$nicelevel" ] ; then
		local args=""
		if [ $pid -gt 0 ] ; then
			args+=" -p $pid"
		fi
		if [ $ppid -gt 0 ] ; then
			args+=" -p $ppid"
		fi
		if [ $service_pid -gt 0 ] ; then
			args+=" -p ${service_pid}"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" -p "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+=" -p "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+=" -p "$(pgrep -u "${user}")
		fi
		if [ -n $group ] ; then
			args+=" -p "$(pgrep -G "${group}")
		fi
		if [ -n $name ] ; then
			args+=" -p "$(pgrep $name)
		fi
		renice -n $nicelevel ${args}
	fi
	if [ $daemon -eq 1 ] || [ $background -eq 1 ] ; then
		:;
	else
		# Bring to foreground
		fg
	fi
}

supervise_daemon() {
	start-stop-daemon "$@"
}

default_start() {
	local args=""
	if [ "$command_background" = "true" ] || [ "$command_background" = "1" ] ; then
		args="--background"
	fi
	start-stop-daemon \
		--exec "${command}" \
		${start_stop_daemon_args} \
		${args} \
		-- \
		${command_args}
}
