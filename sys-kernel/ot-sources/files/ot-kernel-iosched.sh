#!/bin/bash
# This file is part of the ot-sources package.

# "Sets I/O scheduler of each drive individually."

set_iosched() {
	arg="${1}"
	[[ -z "${x}" ]] && return
	if [[ -e "/sys/block/${x}/queue/scheduler" ]] ; then
		t_sched="${arg}"
		if (( "${k_major}" < 5 )) ; then
			[[ "${t_sched}" == "none" ]] && t_sched="noop"
		else
			[[ "${t_sched}" == "noop" ]] && t_sched="none"
		fi
		ioschedr="${t_sched}" # raw
		ioschedc="${t_sched}" # to be canonicalized
		if [[ "${ioschedr}" == "hdd" || "${ioschedr}" == "rotational" ]] ; then
			[[ "${IOSCHED_HDD}" == "bfq-throughput" ]] && ioschedr="bfq-throughput"
			[[ "${IOSCHED_HDD}" == "bfq-low-latency" ]] && ioschedr="bfq-low-latency"
			[[ "${IOSCHED_HDD}" == "bfq-custom-interactive" ]] && ioschedr="bfq-custom-interactive"
			[[ "${IOSCHED_HDD}" == "bfq-streaming" ]] && ioschedr="bfq-streaming"
		elif [[ "${ioschedr}" == "ssd" || "${ioschedr}" == "flash" ]] ; then
			[[ "${IOSCHED_SSD}" == "bfq-throughput" ]] && ioschedr="bfq-throughput"
			[[ "${IOSCHED_SSD}" == "bfq-low-latency" ]] && ioschedr="bfq-low-latency"
			[[ "${IOSCHED_SSD}" == "bfq-custom-interactive" ]] && ioschedr="bfq-custom-interactive"
			[[ "${IOSCHED_SSD}" == "bfq-streaming" ]] && ioschedr="bfq-streaming"
		fi
		[[ "${ioschedr}" =~ "bfq" ]] && ioschedc="bfq"
		[[ -z "${ioschedc}" ]] && return
		grep -q -E -e "(\[| |^)${ioschedc}(\]| |$)" "/sys/block/${x}/queue/scheduler" || return
		if declare -f einfo >/dev/null ; then
			einfo "Setting ${ioschedr} for ${x}"
		else
			echo "Setting ${ioschedr} for ${x}"
		fi
		echo "${ioschedc}" > "/sys/block/${x}/queue/scheduler"
		if [[ "${ioschedc}" == "bfq-throughput" ]] ; then
			echo "0" > "/sys/block/${x}/queue/iosched/low_latency"
			if grep -q -e "0" "/sys/block/${x}/queue/rotational" ; then
				# SSD
				echo "0" > "/sys/block/${x}/queue/iosched/slice_idle_us"
			elif [[ "${HW_RAID}" == "1" ]] ; then
				echo "0" > "/sys/block/${x}/queue/iosched/slice_idle_us"
			fi
		elif [[ "${ioschedc}" == "bfq-low-latency" ]] ; then
			# Use automatic weight adjustments
			echo "1" > "/sys/block/${x}/queue/iosched/low_latency"
		elif [[ "${ioschedc}" == "bfq-custom-interactive" ]] ; then
			# Use manual weight adjustments via ionice
			# https://docs.kernel.org/block/bfq-iosched.html#per-process-ioprio-and-weight
			echo "0" > "/sys/block/${x}/queue/iosched/low_latency"
			echo "1" > "/sys/block/${x}/queue/iosched/strict_guarantees"
		elif [[ "${ioschedc}" == "bfq-streaming" ]] ; then
			echo "1" > "/sys/block/${x}/queue/iosched/low_latency"
			echo "1" > "/sys/block/${x}/queue/iosched/strict_guarantees"
		fi
	fi
}

get_id() {
	local x
	local h
	local arg="${1}"

	local ALGS=(
		"sha256sum"
		"sha384sum"
		"sha512sum"
	)

	for x in $(ls "/dev/disk/by-id") ; do
		for a in ${ALGS[@]} ; do
			which "${a}" 2>/dev/null 1>/dev/null || continue
			h=$(echo "${x};${SALT}" | "${a}" | cut -f 1 -d " ")
			if [[ "${h}" == "${arg}" ]] ; then
				echo "${x}"
				return
			fi
			h=$(echo -n "${x};${SALT}" | "${a}" | cut -f 1 -d " ")
			if [[ "${h}" == "${arg}" ]] ; then
				echo "${x}"
				return
			fi
		done
	done
}

_load_modules() {
	local kpva="${1}"
	local M
	M=(
		"bfq"
		"bfq-iosched"
		"cfq-iosched"
		"deadline-iosched"
		"kyber-iosched"
		"mq-deadline"
	)

	local m
	for m in ${M[@]} ; do
		local nmods=$(find "/lib/modules/${kpva}" -name "${m}.ko*" | wc -l)
		if (( ${nmods} > 0 )) ; then
			if declare -f einfo >/dev/null ; then
				einfo "Loading ${m}"
			else
				echo "Loading ${m}"
			fi
			modprobe ${m}
		fi
	done
}

start()
{
	local kpva=$(cat /proc/version | cut -f 3 -d " ") # ${PV}-${extraverson}-${arch}
	local kv="${kpva%%-*}"
	local k_major=${kv%%.*}
	local extraversion="${kpva%-*}"
	extraversion="${extraversion#*-}"
	[[ -e "/etc/ot-sources/iosched/conf/${kpva}" ]] || return
	source "/etc/ot-sources/iosched/conf/${kpva}"

	_load_modules "${kpva}"

	if declare -f einfo >/dev/null ; then
		einfo "Setting I/O schedulers for the -${extraversion} kernel"
	else
		echo "Setting I/O schedulers for the -${extraversion} kernel"
	fi
	for x in $(ls "/sys/block/") ; do
		[[ "${x}" =~ "dm-"[0-9]+ ]] && continue
		[[ "${x}" =~ "loop"[0-9]+ ]] && continue
		if grep -q -e "1" "/sys/block/${x}/queue/rotational" ; then
			# HDD
			set_iosched "${IOSCHED_HDD}"
		fi
		if grep -q -e "0" "/sys/block/${x}/queue/rotational" || realpath "/sys/block/${x}/device" | grep -q "usb" ; then
			# SSD
			# USB flash reported as rotational.
			set_iosched "${IOSCHED_SSD}"
		fi
	done

	for x in ${IOSCHED_OVERRIDES} ; do
		[[ "${x}" =~ ";" ]] || continue
		id="${x%;*}"
		iosched="${x#*;}"
		if [[ -e "/dev/disk/by-id/${id}" ]] ; then
			p=$(realpath "/dev/disk/by-id/${id}")
			x=$(basename "${p}")
			set_iosched "${iosched}"
		fi
	done

	for x in ${IOSCHED_ANON_OVERRIDES} ; do
		[[ "${x}" =~ ";" ]] || continue
		hash="${x%;*}"
		iosched="${x#*;}"

		id=$(get_id "${hash}")

		if [[ -e "/dev/disk/by-id/${id}" ]] ; then
			p=$(realpath "/dev/disk/by-id/${id}")
			x=$(basename "${p}")
			set_iosched "${iosched}"
		fi
	done
}

start
