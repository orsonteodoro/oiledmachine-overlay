#!/bin/sh

# Compatibility lib

if [ -e "/etc/conf.d/${SVCNAME}" ] ; then
	. "/etc/conf.d/${SVCNAME}"
fi

_checkpath_once() {
	local path="$1"
	path=$(realpath "${path}")

	if [ $truncate_dir -eq 1 ] ; then
		rm -rf "${path}"
	fi

	if [ $truncate_file -eq 1 ] ; then
		rm -rf "${path}"
	fi

	if [ "${type}" = "d" ] && [ ! -d "${path}" ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		mkdir -p "${path}"
	fi

	if [ "${type}" = "f" ] && [ ! -f "${path}" ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		if echo "${path}" | grep -q "/" ; then
			mkdir -p $(dirname "${path}")
		fi
		touch "${path}"
	fi

	if [ "${type}" = "s" ] ; then
		if [ -s "${path}" ] ;
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

default_start() {
	if [ "$command_background" = "true" ] || [ "$command_background" = "1" ] ; then
		"${command}" ${command_args} &
	else
		"${command}" ${command_args}
	fi
}

start-stop-daemon() {
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
	local signal=""
	local status=0
	local stderr=""
	local stdout=""
	local user=""
	while [ -n "$1" ] ; do
		case $1 in
			--)
				shift
				break
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
				:;
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
			--nicelevel|N)
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
			--procsched|-P)
				shift
				procsched_arg="$1"
			--quiet|-q)
				quiet=1
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
				:;
			--status|-T)
				status=1
				:;
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
				:;
			--verbose|-v)
				quiet=0
				:;
			--version|-V)
				:;
			--help|-H)
				:;
		esac
		shift
	done

	if [ -n "${chdir_path}" ] ; then
		cd "${chdir_path}"
	fi

	local _pid=0
	if [ "${phase}" = "start" ] ; then
		if [ $pid -gt 0 ] ; then
			ps $pid >/dev/null 2>&1
		elif [ $ppid -gt 0 ] ; then
			ps $ppid >/dev/null 2>&1
		elif [ -n $pidfile ] ; then
			ps $(cat "${pidfile}") >/dev/null 2>&1
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}")
		elif [ -n $user ] ; then
			pgrep -U "${user}"
		elif [ -n $group ] ; then
			pgrep -G "${group}"
		fi

		if [ $? -eq 0 ] ; then
			return 1
		else
			"${exec_path}" "$@" &
			_pid=$!
		fi
	elif [ "${phase}" = "stop" ] ; then
		if [ $pid -gt 0 ] ; then
			ps $pid >/dev/null 2>&1
		elif [ $ppid -gt 0 ] ; then
			ps $ppid >/dev/null 2>&1
		elif [ -n $pidfile ] ; then
			pgrep $(cat "${pidfile}")
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}")
		elif [ -n $user ] ; then
			pgrep -U "${user}"
		elif [ -n $group ] ; then
			pgrep -G "${group}"
		elif [ -e $pidfile ] ; then
			ps $(cat "${pidfile}") >/dev/null 2>&1
		else
			false
		fi
		is_running="$?"

		local _signal

		if [ -n "$signal" ] ; then
			_signal="${signal}"
		else
			_signal="SIGTERM"
		fi

		if [ $is_running -ne 0 ] ; then
			:;
		elif [ $pid -gt 0 ] ; then
			kill -s ${_signal} $pid
		elif [ $ppid -gt 0 ] ; then
			kill -s ${_signal} $ppid
		elif [ -e $pidfile ] ; then
			kill -s ${_signal} $(cat "${pidfile}")
		elif [ -n "$user" ] ; then
			kill -s ${_signal} $(pgrep -U $(basename "${user}"))
		elif [ -n "$group" ] ; then
			kill -s ${_signal} $(pgrep -G $(basename "${group}"))
		fi
	elif [ "${status}" -eq 1 ] ; then
		if [ $pid -gt 0 ] ; then
			ps $pid >/dev/null 2>&1
		elif [ $ppid -gt 0 ] ; then
			ps $ppid >/dev/null 2>&1
		elif [ -n $pidfile ] ; then
			pgrep $(cat "${pidfile}")
		elif [ -n $exec_path ] ; then
			pgrep $(basename "${exec_path}")
		elif [ -n $user ] ; then
			pgrep -U "${user}"
		elif [ -n $group ] ; then
			pgrep -G "${group}"
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
		if [ -n "$pid" ] ; then
			args+=" -p $pid"
		fi
		if [ -n "$ppid" ] ; then
			args+=" -p $ppid"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" -p "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+="-p "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+="-p "$(pgrep -U $(basename "${user}"))
		fi
		if [ -n $group ] ; then
			args+="-p "$(pgrep -G $(basename "${group}"))
		fi
		if [ -n $name ] ; then
			args+="-p "$(pgrep $name)
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
		if [ -n "$pid" ] ; then
			args+=" $pid"
		fi
		if [ -n "$ppid" ] ; then
			args+=" $ppid"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+=" "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+=" "$(pgrep -U $(basename "${user}"))
		fi
		if [ -n $group ] ; then
			args+=" "$(pgrep -G $(basename "${group}"))
		fi
		if [ -n $name ] ; then
			args+=" "$(pgrep $name)
		fi
		chrt --${policy} -p $priority ${args}
	fi

	if [ -n "$nicelevel" ] ; then
		local args=""
		if [ -n "$pid" ] ; then
			args+=" -p $pid"
		fi
		if [ -n "$ppid" ] ; then
			args+=" -p $ppid"
		fi
		if [ -n "$pidfile" ] ; then
			args+=" -p "$(cat "${pidfile}")
		fi
		if [ -n $exec_path ] ; then
			args+="-p "$(pgrep $(basename "${exec_path}"))
		fi
		if [ -n $user ] ; then
			args+="-p "$(pgrep -u $(basename "${user}"))
		fi
		if [ -n $group ] ; then
			args+="-p "$(pgrep -G $(basename "${group}"))
		fi
		if [ -n $name ] ; then
			args+="-p "$(pgrep $name)
		fi
		renice -n $nicelevel ${args}
	fi
	if [ $make_pidfile -eq 1 ] ; then
		echo "${_pid}" > "${pidfile_path}"
	fi
	if [ $daemon -eq 1 ] || [ $background -eq 1 ] ; then
		:;
	else
		# Bring to foreground
		fg
	fi
}

supervise-daemon() {
	start-stop-daemon "$@"
}
