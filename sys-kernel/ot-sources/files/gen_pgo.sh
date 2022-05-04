#!/bin/bash
# Copyright 2021 Orson Teodoro <orsonteodoro@hotmail.com>
# License GPL-2+ or MIT, your choice

# For additional package requirements see the pgo_trainer_* in the link below:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/6de2332092a475bc2bc4f4aff350c36fce8f4c85/sys-kernel/genkernel/genkernel-4.2.6-r2.ebuild#L279

PGO_SAMPLE_SIZE=30 # statistics rule of 30
PGO_SAMPLE_SIZE_MEMORY=3 # Cut short due to length of time per run
PGO_MAX_FILESIZE_DEFAULT=26214400 # 25 MB
CHECK_REQUIREMENTS=0 # 1 or 0 or unset, for standalone mode only
ALLOW_SUDO_=${ALLOW_SUDO:=0} # 1 or 0
PAGE_SIZE_=${PAGE_SIZE:=$(getconf PAGESIZE)}
K_PAGE_SIZE_=$(( ${PAGE_SIZE} / 1024 ))
PGO_TRAINER_YT_URI_=${PGO_TRAINER_YT_URI:=https://www.youtube.com/watch?v=UlbyOeMCL0g}

PGO_DISTRO="standalone" # \
# If set to gentoo, script integrates with genkernel otherwise run in standalone mode.
# KERNEL_OUTPUTDIR envvar should be set to the kernel sources if not using gentoo
# KERNEL_DIR envvar should be set to the kernel sources if not using gentoo

if [[ "${PGO_DISTRO}" =~ ("linux"|"standalone") ]] ; then
print_info() {
	local error_code="${1}"
	local msg="${2}"
	echo "${msg}"
}
get_indent() {
	local ntabs="${1}"
	local i
	for i in $(seq ${ntabs}) ; do
		echo -en "\t"
	done
}
fi

is_true() {
	local arg="${1}"
	if [[ -n "${arg}" && "${arg}" == "1" ]]
	then
		return 0
	elif [[ -n "${arg}" && "${arg,,}" == "yes" ]]
	then
		return 0
	fi
	return 1
}

is_pgt() {
	if is_true "${CMD_PGT_ALL}" \
		|| is_true "${CMD_PGT_2D_DRAW}" \
		|| is_true "${CMD_PGT_3D_OGL1_3}" \
		|| is_true "${CMD_PGT_CUSTOM}" \
		|| is_true "${CMD_PGT_CRYPTO_CHN}" \
		|| is_true "${CMD_PGT_CRYPTO_COMMON}" \
		|| is_true "${CMD_PGT_CRYPTO_KOR}" \
		|| is_true "${CMD_PGT_CRYPTO_LESS_COMMON}" \
		|| is_true "${CMD_PGT_CRYPTO_OLD}" \
		|| is_true "${CMD_PGT_CRYPTO_RUS}" \
		|| is_true "${CMD_PGT_CRYPTO_STD}" \
		|| is_true "${CMD_PGT_FILESYSTEM}" \
		|| is_true "${CMD_PGT_EMERGE1}" \
		|| is_true "${CMD_PGT_EMERGE2}" \
		|| is_true "${CMD_PGT_MEMORY}" \
		|| is_true "${CMD_PGT_NETWORK}" \
		|| is_true "${CMD_PGT_P2P}" \
		|| is_true "${CMD_PGT_WEBCAM}" \
		|| is_true "${CMD_PGT_YT}"
	then
		return 0
	fi
	return 1
}

is_genkernel() {
	if [[ "${PGO_DISTRO}" == "gentoo" ]] ; then
		return 0
	else
		return 1
	fi
}

marked_as_trained() {
	! is_genkernel && return
	if (( ${trained} == 1 )) ; then
		if [[ "${USER}" == "root" ]] ; then
			touch "${KERNEL_OUTPUTDIR}/.pgt-trained"
		elif which sudo 2>/dev/null 1>/dev/null \
			&& ( groups | grep -q -e "wheel" ) \
			&& (( ${ALLOW_SUDO_} == 1 )) ; then
			print_info 1 "$(get_indent 1)>> sudo is required to mark PGO progress"
			sudo touch "${KERNEL_OUTPUTDIR}/.pgt-trained"
		fi
	fi
}

get_total_memory() {
	local t=0
	for x in $(grep -E -e "(MemTotal|SwapTotal)" /proc/meminfo \
		| sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ") ; do
		t=$((${t}+ ${x}))
	done
	echo $((${t}*1024))
}

get_total_ram() {
	local t=0
	for x in $(grep -E -e "(MemTotal)" /proc/meminfo \
		| sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ") ; do
		t=$((${t}+ ${x}))
	done
	echo $((${t}*1024))
}

get_total_free_memory() {
	local t=0
	for x in $(grep -E -e "(MemFree|SwapFree)" /proc/meminfo \
		| sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ") ; do
		t=$((${t}+ ${x}))
	done
	echo $((${t}*1024))
}

get_total_used_memory() {
	echo $(( $(get_total_memory) - $(get_total_free_memory) ))
}

get_unswappable_size() {
	local t=0
	# For per-config settings, see https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/proc/meminfo.c
	# It is unknown, if these fields are overapping.
	for x in $(grep -E -e "(Unevictable|SUnreclaim|KernelStack|Mlocked)" /proc/meminfo \
		| sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ") ; do
		t=$((${t}+ ${x}))
	done
	echo $((${t}*1024))
}

get_total_swappable() {
	echo $(( $(get_total_ram) - $(get_unswappable_size) ))
}

pid_exist() {
	local pid="${1}"
	ps -p ${pid} 2>/dev/null 1>/dev/null
}

is_oom() {
	local pid="${1}"
	if dmesg | grep -F -e "Out of memory: Killed process ${pid} " ; then
		return 0
	fi
	return 1
}

pgo_trainer_memory() {
	local m0=0 # Is swapping code paths profiled?
	local m1=0 # Is OOM code paths profiled?
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the PGO memory trainer"

	# It stalls at ~2G per process
	# Let it generate n processes so that bytes(n*2G) > total_memory_bytes
	local nprocs=$(python -c "print(round($(get_total_memory) / (2*1073741824) + 1))")

	free_mem_resources() {
		print_info 1 "$(get_indent 1)>> Freeing memory"
		kill -9 $(get_cmd_pids "cat /dev/urandom | od -t x1")
		exit 1
	}

	trap free_mem_resources INT

	local n_oom=0
	for i in $(seq ${PGO_SAMPLE_SIZE_MEMORY}) ; do
		local bytes_read=0
		print_info 1 "$(get_indent 1)>> This may freeze the computer temporarily.  Ctrl+c to stop profiling. (run:  ${i}/${PGO_SAMPLE_SIZE})"
		unset bash_pids
		for c in $(seq ${nprocs}) ; do
			print_info 1 "$(get_indent 1)>> Generating random data to swap and trigger OOM (process #:  ${c})"
			bash -c "O=\$(cat /dev/urandom | od -t x1)" &
			bash_pids[${c}]=$!
			renice ${bash_pids[${c}]} -p 19
			which ionice 2>/dev/null 1>/dev/null && ionice -c 3 -p ${bash_pids[${c}]}
		done

		print_info 1 "$(get_indent 1)>> Letting memory algorithms do work.  Please wait"

		dmesg -C
		unset swap_maker_done
		for c in $(seq ${nprocs}) ; do
			swap_maker_done[${c}]=0
		done
		local oom_found=0
		local quit=0
		while true ; do
			sleep 0.2
			for c in $(seq ${nprocs}) ; do
				bash_pid=${bash_pids[${c}]}
				if is_oom ${bash_pid} && (( ${swap_maker_done[${c}]} == 0 )) ; then
					swap_maker_done[${c}]=1
					m1=0
					oom_found=1
					print_info 1 "$(get_indent 1)>> Swap maker OOM detected"
				elif ! pid_exist ${bash_pid} ; then
					print_info 1 "$(get_indent 1)>> Missing swap maker.  Stopping test."
					quit=1
				fi
			done
			(( ${oom_found} == 1 || ${quit} == 1 )) && break
		done

		for c in $(seq ${nprocs}) ; do
			bash_pid=${bash_pids[${c}]}
			if pid_exist ${bash_pid} ; then
				print_info 1 "$(get_indent 1)>> Killing swap maker pid ${bash_pid}"
				kill -9 ${bash_pid}
			fi
		done
		m0=1
	done
	print_info 1 "$(get_indent 1)>> Memory training done."
	(( $(( ${m0} + ${m1} )) == 2 )) && trained=1 && marked_as_trained
	renice $$ -p 0
	which ionice 2>/dev/null 1>/dev/null && ionice -c 0 -p $$
}

pgo_trainer_emerge1() {
	local trained=0
	if [ -d /usr/portage/x11-base/xorg-server ] ; then
		pushd /usr/portage/x11-base/xorg-server
			local f=$(basename $(find /usr/portage/x11-base/xorg-server -name "*.ebuild" \
				| sort -V | head -n 1))
			print_info 1 "$(get_indent 1)>> Running the PGO trainer with \`ebuild ${f} unpack prepare compile\`"
			ebuild ${f} clean unpack prepare compile && trained=1
			ebuild ${f} clean
		popd
	else
		if [ -d "${PGO_TRAINER_PORTAGE_DIR}/x11-base/xorg-server" ]
			pushd "${PGO_TRAINER_PORTAGE_DIR}/x11-base/xorg-server"
				local f=$(basename $(find "${PGO_TRAINER_PORTAGE_DIR}/x11-base/xorg-server" -name "*.ebuild" \
					| sort -V | head -n 1))
				print_info 1 "$(get_indent 1)>> Running the PGO trainer with \`ebuild ${f} unpack prepare compile\`"
				ebuild ${f} clean unpack prepare compile && trained=1
				ebuild ${f} clean
			popd
		then
			print_info 1 "$(get_indent 1)>> Set PGO_TRAINER_PORTAGE_DIR in /etc/genkernel.conf to base abspath to the portage tree."
		fi
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_emerge2() {
	print_info 1 "$(get_indent 1)>> Running the PGO trainer for very high memory use and/or very high IO "
	print_info 1 "$(get_indent 1)>> This PGO test has not been implemented yet"
}

_cipher_not_recommended() {
	local name="${1}"
	local reason="${2}"
	if grep -q -e ": ${name}" /proc/crypto ; then
		print_info 1 "$(get_indent 1)>> ${name} is not recommended for hashing or as a cipher for securing data.  Reason:  ${reason}"
	fi
}

_use_crypto_with_mode() {
	local mode_of_operation="${1}"
	local cipher="${2}"
	local min_key_size="${3}"
	local max_key_size="${4}"
	local inc="${5}"
	local block_size="${6}"
	if grep -q ": ${mode_of_operation}(${cipher})" /proc/crypto ; then
		for x in $(seq ${min_key_size} ${inc} ${max_key_size}) ; do
			for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
				cryptsetup benchmark -c ${cipher}-${mode_of_operation} -s ${x} && trained=1
			done
		done
	fi
}

_use_hash() {
	local name="${1}"
	local len="${2}"
	local blocksize="${3}"
	if (( ${len} == 160 )) && [[ "${name}" =~ sha ]] ; then
		name="sha1"
	fi
	if grep -q -e ": ${name}" /proc/crypto ; then
		for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
			# cryptsetup only supports block ciphers
			cryptsetup benchmark -h ${name} -s ${len} && trained=1
		done
	fi
}

pgo_trainer_crypto_std() {
	local trained=0
	if ! which cryptsetup 2>/dev/null 1>/dev/null ; then
		print_info 1 "$(get_indent 1)>> Missing cryptsetup.  Emerge sys-fs/cryptsetup."
		return
	fi
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for industry standard hashes"
	_cipher_not_recommended "sha1" "obsolete, insecure"
	unset BS
	declare -Ax BS=(
		[160]="512" # sha1
		[224]="512"
		[256]="512"
		[384]="1024"
		[512]="1024"
	)
	for ks in 160 224 256 384 512 ; do
		_use_hash "sha${ks}" ${ks} ${BS[${ks}]}
	done
	unset BS
	declare -Ax BS=(
		[224]="1152"
		[256]="1088"
		[384]="832"
		[512]="576"
	)
	for ks in 224 256 384 512 ; do
		_use_hash "sha3-${ks}" ${ks} ${BS[${ks}]}
	done
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for industry standard ciphers"
	_use_crypto_with_mode "cbc" "aes" 128 256 64 128
	_use_crypto_with_mode "ctr" "aes" 128 256 64 128
	_use_crypto_with_mode "xts" "aes" 256 512 128 128
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_common() {
	local trained=0
	if ! which cryptsetup 2>/dev/null 1>/dev/null ; then
		print_info 1 "$(get_indent 1)>> Missing cryptsetup.  Emerge sys-fs/cryptsetup."
		return
	fi
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for common hashes"
	_use_hash "rmd160" 160 512
	for ks in 160 256 384 512 ; do
		_use_hash "wp${ks}" ${ks} 512
	done
	for ks in 160 256 384 512 ; do
		_use_hash "blake2b-${ks}" ${ks} 1024
	done
	for ks in 128 160 224 256 ; do
		_use_hash "blake2s-${ks}" ${ks} 512
	done
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for common ciphers"
	_use_crypto_with_mode "cbc" "cast6" 128 256 32 128
	_use_crypto_with_mode "ctr" "cast6" 128 256 32 128
	_use_crypto_with_mode "xts" "cast6" 256 512 64 128
	_use_crypto_with_mode "cbc" "twofish" 128 256 64 128
	_use_crypto_with_mode "ctr" "twofish" 128 256 64 128
	_use_crypto_with_mode "xts" "twofish" 256 512 128 128
	_use_crypto_with_mode "cbc" "serpent" 128 256 64 128
	_use_crypto_with_mode "ctr" "serpent" 128 256 64 128
	_use_crypto_with_mode "xts" "serpent" 256 512 128 128
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_less_common() {
	local trained=0
	if ! which cryptsetup 2>/dev/null 1>/dev/null ; then
		print_info 1 "$(get_indent 1)>> Missing cryptsetup.  Emerge sys-fs/cryptsetup."
		return
	fi
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for less common ciphers"
	_use_crypto_with_mode "cbc" "anubis" 128 320 32 128
	_use_crypto_with_mode "xts" "anubis" 256 640 64 128
	_use_crypto_with_mode "cbc" "camellia" 128 256 32 128
	_use_crypto_with_mode "xts" "camellia" 256 512 64 128
	_use_crypto_with_mode "cbc" "cast5" 40 128 32 64
	_use_crypto_with_mode "cbc" "fcrypt" 64 64 64 64
	_use_crypto_with_mode "cbc" "khazad" 128 128 128 64
	_use_crypto_with_mode "ctr" "khazad" 128 128 128 64
	_use_crypto_with_mode "cbc" "tea" 128 128 128 64
	_use_crypto_with_mode "ctr" "tea" 128 128 128 64
	_use_crypto_with_mode "cbc" "xeta" 128 128 128 64
	_use_crypto_with_mode "ctr" "xeta" 128 128 128 64
	_use_crypto_with_mode "cbc" "xtea" 128 128 128 64
	_use_crypto_with_mode "ctr" "xtea" 128 128 128 64
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_deprecated() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for deprecated / insecure hashes"
	_use_hash "michael_mic" 64 64 # TKIP

	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for deprecated / insecure ciphers"
	# Deprecated or outdated if 64 block size.
	# See https://en.wikipedia.org/wiki/Cipher_security_summary
	_cipher_not_recommended "arc4" "ARC4 is considered insecure"
	_use_crypto_with_mode "ecb" "arc4" 2048 2048 2048 1 # WEP
	_cipher_not_recommended "blowfish" "Blowfish is considered insecure"
	_use_crypto_with_mode "cbc" "blowfish" 32 448 32 64
	_use_crypto_with_mode "ctr" "blowfish" 32 448 32 64
	_cipher_not_recommended "des" "DES is considered insecure"
	_use_crypto_with_mode "cbc" "des3" 64 64 64 64
	_use_crypto_with_mode "ctr" "des3" 64 64 64 64
	_cipher_not_recommended "des3_ede" "DES is considered insecure"
	_use_crypto_with_mode "cbc" "des3_ede" 192 192 192 64
	_use_crypto_with_mode "ctr" "des3_ede" 192 192 192 64
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_chn() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for CHN hashes"
	_use_hash "sm3" 256 512
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for CHN cipher"
	_use_crypto_with_mode "cbc" "sm4" 128 128 128 128
	_use_crypto_with_mode "ctr" "sm4" 128 128 128 128
	_use_crypto_with_mode "xts" "sm4" 256 256 256 128
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_kor() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for KOR ciphers"
	_use_crypto_with_mode "cbc" "seed" 128 256 64 128
	_use_crypto_with_mode "ctr" "seed" 128 256 64 128
	_use_crypto_with_mode "xts" "seed" 256 512 128 128
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_crypto_rus() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the cryptsetup PGO trainer for RUS hashes"
	for ks in 256 512 ; do
		_use_hash "streebog${ks}" ${ks} 512
	done
	(( ${trained} == 1 )) && marked_as_trained
}

_pgo_trainer_filesystem_sequential_reads() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running sequential reads"
	local sample_set=()
	local c=0
	for f in $(find "${mount_point}/usr/bin" -type f| shuf) ; do
		[ -L "${f}" ] && continue
		sample_set+=( "${f}" )
		c=$((${c} + 1))
		(( ${c} > 500 )) && break
	done
	local READ_LIMIT=${PGO_MAX_FILESIZE_DEFAULT} # Don't read gigabytes / terabytes
	for f in ${sample_set[@]} ; do
		for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
			# 08907: value too great for base (error token is "08907")
			local srand1=$(echo "${RANDOM}" | sed -E -e "s|^[0]+||g")
			local srand2=$(echo "${RANDOM}" | sed -E -e "s|^[0]+||g")
			local rand=$(( ${srand1}${srand2} ))
			local nbytes=$(( ${rand} % ${READ_LIMIT} ))
			print_info 1 "$(get_indent 1)>> Reading the first ${nbytes} bytes from ${f}"
			head -c ${nbytes} "${f}" 2>/dev/null > /dev/null && trained=1
		done
	done
	return ${trained}
}

_pgo_trainer_filesystem_random_reads_single_page() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running random reads single page at a time"
	local sample_set=()
	local c=0
	for f in $(find "${mount_point}/usr/bin" -type f| shuf) ; do
		[ -L "${f}" ] && continue
		# File must be >=2 pages
		local filesize=$(stat -c "%s" "${f}")
		if (( ${filesize} > 8192 && ${filesize} < ${PGO_MAX_FILESIZE:=26214400} )) ; then # 25 MiB
			sample_set+=( "${f}" )
			c=$((${c} + 1))
			(( ${c} > 500 )) && break
		fi
	done
	# Read random pagesize parts of a file
	local sandbox_dir=$(mktemp -p "${mount_point_tmp_path}" -d)
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	pushd "${sandbox_dir}"
		for f in ${sample_set[@]} ; do
			for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
				local file_size=$(stat -c "%s" "${f}")
				(( ${file_size} == 0 )) && continue # avoid mod by zero
				local npages=$((${file_size} / ${PAGE_SIZE_}))
				local srand=$(echo "${RANDOM}" | sed -E -e "s|^[0]+||g") # 08907: value too great for base (error token is "08907")
				local page_index=$(( ${srand} % ${npages} ))
				print_info 1 "$(get_indent 1)>> Reading ${f} at page_index ${page_index}."
				dd if="${f}" of="dump.dat" ibs=${K_PAGE_SIZE_}K skip=${page_index} count=1 && trained=1
				local size_x=$(stat -c "%s" "dump.dat")
				if (( ${size_x} != ${PAGE_SIZE_} )) ; then
					print_info 1 "$(get_indent 1)>> Failed reading a page of a file.  Filesize was ${size_x}."
				fi
			done
		done
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
	return ${trained}
}

_pgo_trainer_filesystem_random_writes_single_page() {
	local sandbox_dir=$(mktemp -p "${mount_point_tmp_path}" -d)
	print_info 1 "$(get_indent 1)>> Running random writes single page at a time"
	# Write data in a single file pagesize writes
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	local trained=0
	pushd "${sandbox_dir}"
		f="test.img"
		dd if=/dev/zero of=${f} bs=${K_PAGE_SIZE_}K iflag=fullblock,count_bytes count=${PGO_MAX_FILESIZE_DEFAULT}
		for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
			local file_size=$(stat -c "%s" "${f}")
			(( ${file_size} == 0 )) && continue # avoid mod by zero
			local npages=$((${file_size} / ${PAGE_SIZE_}))
			local page_index=$(( ${RANDOM}${RANDOM} % ${npages} ))
			print_info 1 "$(get_indent 1)>> Writing ${f} at page_index ${page_index}."
			dd if=${f} of=${f} ibs=${K_PAGE_SIZE_}K seek=${page_index} count=1 conv=notrunc && trained=1
			file_size=$(stat -c "%s" "${f}")
			print_info 1 "$(get_indent 1)>> New filesize is ${file_size}."
			local size_x=$(stat -c "%s" "${f}")
		done
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
	return ${trained}
}

_pgo_trainer_filesystem_grep() {
	local trained=0
	print_info 1 "$(get_indent 1)>> Running grep finds"
	local sample_set=()
	local c=0
	print_info 1 "$(get_indent 1)>> Finding suitable files.  Please wait."
	for f in $(find "${mount_point}/usr/bin" -type f| shuf) ; do
		[ -L "${f}" ] && continue
		filesize=$(stat -c "%s" "${f}")
		if (( ${filesize} < ${PGO_MAX_FILESIZE:=${PGO_MAX_FILESIZE_DEFAULT}} )) ; then
			# Don't read terabytes
			sample_set+=( "${f}" )
			c=$((${c} + 1))
			(( ${c} > 500 )) && break
		fi
	done
	for f in ${sample_set[@]} ; do
		local file_size=$(stat -c "%s" "${f}")
		grep -q -i "copyright" "${f}" && echo "Found pattern in ${f}" && trained=1
	done
	return ${trained}
}

pgo_trainer_filesystem() {
	local trained=0
	local ngroups=0
	local d_i=0
	unset results
	print_info 1 "$(get_indent 1)>> Running the filesystem PGO trainer"
	pgo_filesystem_list=${PGO_FILESYSTEMS_LIST="unk:unk:unk:/:/usr/bin"}
	for x in ${pgo_filesystem_list} ; do
		local io_scheduler_name=$(echo "${x}" | cut -f 1 -d ":")
		local fs_name=$(echo "${x}" | cut -f 2 -d ":")
		local dev_name=$(echo "${x}" | cut -f 3 -d ":")
		local mount_point=$(echo "${x}" | cut -f 4 -d ":")
		local test_dir=$(echo "${x}" | cut -f 5 -d ":")
		print_info 1 "$(get_indent 1)>> io_scheduler_name:  ${io_scheduler_name}"
		print_info 1 "$(get_indent 1)>> fs_name:  ${fs_name}"
		print_info 1 "$(get_indent 1)>> dev_name:  ${dev_name}"
		print_info 1 "$(get_indent 1)>> mount_point:  ${mount_point}"
		print_info 1 "$(get_indent 1)>> test_dir (read-only):  ${test_dir}"
		if [[ "${mount_point}" == "" || "${mount_point}" == "." ]] ; then
			print_info 1 "$(get_indent 1)>> Mount point is empty or just a period.  Skipping this mount point.  quintuple: ${x}"
			continue
		fi
		if [[ -z "${test_dir}" || ! -e "${mount_point}/${test_dir}" ]] ; then
			print_info 1 "$(get_indent 1)>> test_dir is invalid.  Skipping this mountpoint.  quintuple: ${x}"
			continue
		fi
		if (( $(find /sys/devices/ -path "*${dev_name}*scheduler" | wc -l) == 1 )) \
			&& cat $(find /sys/devices/ -path "*${dev_name}*scheduler") | grep -q -e "${io_scheduler_name}" ; then
			#echo "${io_scheduler_name}" > $(find /sys/devices/ -path "*${dev_name}*scheduler")
			# IO scheduler switching is bugged.
			:;
		fi
		local mount_point_tmp_path="${mount_point}/tmp.pgo."$(head -c 7 /dev/random \
			| od -t x2 | cut -c 9- | head -n 1 | sed -e "s| ||g" \
			| head -c 7)
		mkdir -p "${mount_point_tmp_path}"
		[[ "$?" != "0" || ! -d "${mount_point_tmp_path}" ]] \
			&& print_info 1 "$(get_indent 1)>> Failed to create PGO tmp dir for mountpoint.  Skipping test." \
			&& return
		ngroups=$((${ngroups} + 1))
		_pgo_trainer_filesystem_sequential_reads
		results[${d_i}]=$(echo $?)
		d_i=$((${d_i} + 1))
		_pgo_trainer_filesystem_random_reads_single_page
		results[${d_i}]=$(echo $?)
		d_i=$((${d_i} + 1))
		_pgo_trainer_filesystem_random_writes_single_page
		results[${d_i}]=$(echo $?)
		d_i=$((${d_i} + 1))
		_pgo_trainer_filesystem_grep
		results[${d_i}]=$(echo $?)
		d_i=$((${d_i} + 1))

		# TODO multi file reads
		[[ -d "${mount_point_tmp_path}" && "${mount_point_tmp_path}" != "." ]] \
			&& rm -rf "${mount_point_tmp_path}"
	done

	local ntests=4
	if (( ${#results[@]} > 0 )) ; then
		trained=1
		for result in ${results[@]} ; do
			(( ${result} == 0 )) && trained=0
		done
		(( ${#result[@]} / ${ntests} != ${ngroups} )) && trained=0
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_network() {
	local m0=0 # Is ICMP code paths profiled?
	local m1=0 # Is UDP code paths profiled?
	local m2=0 # Is TCP code paths profiled?
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the network PGO trainer"
	# See /proc/sys/net/ipv4/tcp_congestion_control
	# See /proc/sys/net/ipv4/tcp_available_congestion_control
	local tcp_congestions
	if [[ -e /proc/sys/net/ipv4/tcp_congestion_control ]] ; then
		print_info 1 "$(get_indent 1)>> TCP congestion control is $(cat /proc/sys/net/ipv4/tcp_congestion_control)."
		print_info 1 "$(get_indent 1)>> To train multiple particular TCP congestion control set PGO_TRAINER_NETWORK_TCP_CONGESTIONS as a string in /etc/genkernel.conf."
		local tcp_congestion=$(cat /proc/sys/net/ipv4/tcp_congestion_control)
		tcp_congestions=${PGO_TRAINER_NETWORK_TCP_CONGESTIONS:=${tcp_congestion}}
	else
		tcp_congestions="unknown"
	fi

	# Test both IPv4/IPv6
	local domains=(
		kernel.org
		freenode.org
		gentoo.org
		github.com
		gitlab.com
		sourceforge.com
		wikipedia.org
	)

	for domain in $(echo ${domains[@]} | shuf) ; do
		# Test ICMP
		if which ping 2>/dev/null 1>/dev/null ; then
			ping -c 1 ${domain} && m0=1
		else
			print_info 1 "$(get_indent 1)>> Missing ping.  Emerge net-misc/iputils."
		fi
		# Test UDP
		if which traceroute 2>/dev/null 1>/dev/null ; then
			traceroute ${domain} && m1=1
		else
			print_info 1 "$(get_indent 1)>> Missing traceroute.  Emerge net-analyzer/traceroute."
		fi
	done
	for tcp_congestion in ${tcp_congestions} ; do
		if [[ -e "/proc/sys/net/ipv4/tcp_congestion_control" ]] \
			&& grep -q -e "${tcp_congestion}" /proc/sys/net/ipv4/tcp_allowed_congestion_control ; then
			print_info 1 "$(get_indent 1)>> TCP congestion control: ${tcp_congestion} is set"
			echo "${tcp_congestion}" > /proc/sys/net/ipv4/tcp_congestion_control
		fi
		# Test TCP
		if \
			which curl 2>/dev/null 1>/dev/null ; then
			# Total size for linux-5.14.tar.xz is 120669872
			if curl --output /dev/null -r 0-1048576 https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.14.tar.xz ; then
				m2=1
			else
				print_info 1 "$(get_indent 1)>> Failed to download the kernel"
			fi
		else
			print_info 1 "$(get_indent 1)>> Missing curl.  emerge net-misc/curl"
		fi
	done
	(( $(( ${m0} + ${m1} + ${m2} )) == 3 )) && trained=1 && marked_as_trained
}

get_cmd_pids() {
	local cmd="${@}"
	ps -aux | sed -E -e "s|[ ]+| |g" \
		| grep -e "${cmd}"  \
		| grep -v -e "grep.*${cmd}" \
		| cut -f 2 -d " "
}

get_cmd_pid() {
	local cmd="${@}"
	get_cmd_pids "${cmd}" | head -n 1
}

pgo_trainer_p2p() {
	local trained=0
	local url=${PGO_P2P_URI:="https://download.documentfoundation.org/libreoffice/stable/7.1.6/win/x86_64/LibreOffice_7.1.6_Win_x64.msi.torrent"}
	local sandbox_dir=$(mktemp -d)
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	pushd "${sandbox_dir}"
		export BN=$(basename "${url}")
		wget -O "${BN}" "${url}"
		ctorrent -dd "${BN}" 2>&1 >"${sandbox_dir}/ctorrent.log"
		stop_ctorrent() {
			print_info 1 "$(get_indent 1)>> Stopping ctorrent"
			kill -9 $(get_cmd_pid "ctorrent -dd ${BN}")
			sleep 1
			# Wipe sandbox
			[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
				&& rm -rf "${sandbox_dir}"
			exit 1
		}
		trap stop_ctorrent INT
		print_info 1 "$(get_indent 1)>> Running the PGO trainer for p2p.  Do \`tail -f ${sandbox_dir}/ctorrent.log\` for progress."
		local time_now=$(date +%s)
		local time_expire=$(( ${time_now} + 60 ))
		while true ; do
			sleep 0.2s
			time_now=$(date +%s)
			(( ${time_now} > ${time_expire} )) && trained=1 && break
		done
		kill -9 $(get_cmd_pid "ctorrent -dd ${BN}")
		dl_size=$(grep -E -o "[0-9]+MB,[0-9]MB" "${sandbox_dir}/ctorrent.log" | cut -f 1 -d "," | sed -e "s|MB||g")
		dl_rates=$(grep -E -o "[0-9],[0-9]K/s" "${sandbox_dir}/ctorrent.log" | cut -f 1 -d ",")
		for x in ${dl_size} ; do
			(( ${x} > 1 )) && trained=1
		done
		for x in ${dl_rates} ; do
			(( ${x} > 1 )) && trained=1
		done
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_webcam() {
	local m0=0 # Is encoding still photos code paths profiled?
	local m1=0 # Is decoding stills profiled?
	local m2=0 # Is encoding movies code paths profiled?
	local m3=0 # is decoding stills profiled?
	local trained=0
	print_info 1 "$(get_indent 1)>> Running the webcam PGO trainer for still photos"
	if ! which ffmpeg 2>/dev/null 1>/dev/null ; then
		print_info 1 "$(get_indent 1)>> Missing ffmpeg.  Install the media-video/ffmpeg[encode,libv4l] package"
		return
	fi
	if ! which v4l2-ctl 2>/dev/null 1>/dev/null ; then
		print_info 1 "$(get_indent 1)>> Missing ffmpeg.  Install the media-tv/v4l-utils package"
		return
	fi

	local sandbox_dir=$(mktemp -d)
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	pushd "${sandbox_dir}"
		for i in $(seq 0 10) ; do
			local d="/dev/video${i}"
			if test -e "${d}" ; then
				local resolutions=$(v4l2-ctl -d ${d} \
					--list-formats-ext \
					| grep "Size:" \
					| grep -E -o -e "[0-9]+x[0-9]+")
				for res in ${resolutions} ; do
					for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
						ffmpeg -y -f video4linux2 -s ${res} -i ${d} -frames 1 test.jpg && m0=1
						# Decode also to simulate part of video conferencing.
						ffmpeg -y -i test.jpg -f null - && m1=1
					done
				done
			fi
		done
		for i in $(seq 0 10) ; do
			local d="/dev/video${i}"
			if test -e "${d}" ; then
				local resolutions=$(v4l2-ctl -d ${d} \
					--list-formats-ext \
					| grep "Size:" \
					| grep -E -o -e "[0-9]+x[0-9]+")
				for res in ${resolutions} ; do
					for try in $(seq ${PGO_SAMPLE_SIZE}) ; do
						ffmpeg -y -f video4linux2 -s ${res} -i ${d} -t 5 test.webm && m2=1
						# Decode also to simulate part of video conferencing.
						ffmpeg -y -i test.webm -f null - && m3=1
					done
				done
			fi
		done
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
	(( $(( ${m0} + ${m1} + ${m2} + ${m3} )) == 4 )) && trained=1 && marked_as_trained
}

pgo_trainer_2d_draw() {
	local trained=0
	if [[ -n "${DISPLAY}" || (-n "${XDG_SESSION_TYPE}" && "${XDG_SESSION_TYPE}" == "x11") ]] ; then
		local cpus=$(lscpu | grep -E -e "CPU\(s\):" | head -n 1 | grep -E -o -e "[0-9]+")
		local tpc=$(lscpu | grep -E -e "Thread\(s\) per core:" | head -n 1 | grep -E -o -e "[0-9]+")
		local threads=$((${cpus} * ${tpc}))
		print_info 1 "$(get_indent 1)>> Running the PGO trainer for 2D drawing with ${threads} threads"
		for f in $(find /usr/lib*/misc/xscreensaver -type f | shuf) ; do
			if ldd "${f}" 2>/dev/null | grep -q -e "libGL" ; then
				:;
			else
				for i in $(seq $((${threads}))) ; do
					timeout 5 "${f}" 2>/dev/null &
					trained=1
				done
				sleep 5
			fi
		done
		ran_test=1
	fi
	if [[ -n "${XDG_SESSION_TYPE}" && "${XDG_SESSION_TYPE}" == "wayland" ]] ; then
		ran_test=1
	fi
	if (( ${ran_test} == 0 )) ; then
		print_info 1 "$(get_indent 1)>> You must run genkernel in x11 or wayland"
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_3d_ogl1_3() {
	local trained=0
	if [[ -n "${DISPLAY}" || (-n "${XDG_SESSION_TYPE}" && "${XDG_SESSION_TYPE}" == "x11") ]] ; then
		local cpus=$(lscpu | grep -E -e "CPU\(s\):" | head -n 1 | grep -E -o -e "[0-9]+")
		local tpc=$(lscpu | grep -E -e "Thread\(s\) per core:" | head -n 1 | grep -E -o -e "[0-9]+")
		local threads=$((${cpus} * ${tpc}))
		print_info 1 "$(get_indent 1)>> Running the PGO trainer for 3D drawing using Opengl ~1.3 ${threads} threads"
		for f in $(find /usr/lib*/misc/xscreensaver -type f | shuf) ; do
			if ldd "${f}" 2>/dev/null | grep -q -e "libGL" ; then
				for i in $(seq $((${threads}))) ; do
					timeout 5 "${f}" 2>/dev/null &
					trained=1
				done
				sleep 5
			fi
		done
	fi
	if [[ -n "${XDG_SESSION_TYPE}" && "${XDG_SESSION_TYPE}" == "wayland" ]] ; then
		ran_test=1
	fi
	if (( ${ran_test} == 0 )) ; then
		print_info 1 "$(get_indent 1)>> You must run genkernel in x11 or wayland"
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

_launch_video0_cr() {
	local sandbox_dir=$(mktemp -d)
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	pushd "${sandbox_dir}"
		cat <<EOF >"watch_video.py"
#!/usr/bin/env python3
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import time
driver = webdriver.Chrome()
driver.get("${PGO_TRAINER_YT_URI_}")
time.sleep(20) # wait for browser to load
time.sleep(1)
try:
        driver.find_element(By.XPATH, "//*[text() = 'Dismiss']").click()
except NoSuchElementException:
        pass
try:
        driver.find_element(By.XPATH, "//*[text() = 'Not now']").click()
except NoSuchElementException:
        pass
time.sleep(1)
try:
        driver.find_element(By.XPATH, "//button[contains(@class, 'ytp-play-button')]").click()
except NoSuchElementException:
        pass
time.sleep(2*60)
driver.close()
EOF
		:;
		python3 watch_video.py && trained=1
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
}

_launch_video0_ff() {
	local sandbox_dir=$(mktemp -d)
	[[ "$?" != "0" ]] \
		&& print_info 1 "$(get_indent 1)>> Failed to create sandbox dir.  Skipping test." \
		&& return
	pushd "${sandbox_dir}"
		cat <<EOF >"watch_video.py"
#!/usr/bin/env python3
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import time
driver = webdriver.Firefox()
driver.get("${PGO_TRAINER_YT_URI_}")
time.sleep(20) # wait for browser to load
time.sleep(1)
try:
        driver.find_element(By.XPATH, "//*[text() = 'Dismiss']").click()
except NoSuchElementException:
        pass
try:
        driver.find_element(By.XPATH, "//*[text() = 'Not now']").click()
except NoSuchElementException:
        pass
time.sleep(1)
try:
        driver.find_element(By.XPATH, "//button[contains(@class, 'ytp-play-button')]").click()
except NoSuchElementException:
        pass
time.sleep(2*60)
driver.close()
EOF
		:;
		python3 watch_video.py && trained=1
	popd
	[[ -d "${sandbox_dir}" && "${sandbox_dir}" != "." ]] \
		&& rm -rf "${sandbox_dir}"
}

pgo_trainer_yt() {
	local trained=0
	local ran_test=0
	if [[ "${USER}" == "root" ]] ; then
		print_info 1 "$(get_indent 1)>> You must be a non-root user to run the yt test"
		return
	fi
	if [[ -n "${DISPLAY}" || (-n "${XDG_SESSION_TYPE}" && "${XDG_SESSION_TYPE}" == "x11") ]] ; then
		if which chromedriver 2>/dev/null 1>/dev/null ; then
			_launch_video0_cr
			ran_test=1
		elif which geckodriver 2>/dev/null 1>/dev/null ; then
			_launch_video0_ff
			ran_test=1
		fi
	fi
	if (( ${ran_test} == 0 )) ; then
		print_info 1 "$(get_indent 1)>> You must run genkernel in x11 or wayland"
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_custom() {
	local trained=0
	DIR=$(dirname "$BASH_SOURCE")
	if [[ -x "${DIR}/pgo-custom.sh" ]] ; then
		local perms=$(stat -c "%a" "${DIR}/pgo-custom.sh")
		local u=$(stat -c "%G" "${DIR}/pgo-custom.sh")
		local g=$(stat -c "%U" "${DIR}/pgo-custom.sh")
		if [[ "${perms}" == "750" \
			&& ( ( "${u}" == "portage" && "${g}" == "portage" ) \
				|| ( "${g}" == "wheel" ) \
				|| ( "${u}" == "root" && "${g}" == "root" ) ) ]] ; then
			print_info 1 "$(get_indent 1)>> Running the PGO custom trainer(s)"
			./pgo-custom.sh
			trained=1
		else
			print_info 1 "$(get_indent 1)>> Wrong permissions for pgo-custom.sh"
			print_info 1 "$(get_indent 1)>> Inspect the file for malicious modifications."
			print_info 1 "$(get_indent 1)>> Then, reset permissions to 750 and owner to"
			print_info 1 "$(get_indent 1)>> root/root, ${USER}/wheel, or portage/portage."
		fi
	fi
	(( ${trained} == 1 )) && marked_as_trained
}

pgo_trainer_all() {
	print_info 1 "$(get_indent 1)>> Running the all PGO trainers"
	pgo_trainer_2d_draw
	pgo_trainer_3d_ogl1_3
	pgo_trainer_crypto_std
	pgo_trainer_crypto_kor
	pgo_trainer_crypto_chn
	pgo_trainer_crypto_rus
	pgo_trainer_crypto_common
	pgo_trainer_crypto_less_common
	pgo_trainer_crypto_deprecated
	pgo_trainer_custom
	pgo_trainer_emerge1
	pgo_trainer_emerge2
	pgo_trainer_filesystem
	pgo_trainer_memory
	pgo_trainer_network
	pgo_trainer_webcam
}

pgo_trainer_all_non_root() {
	pgo_trainer_p2p
	pgo_trainer_yt
}

check_pgo_applied() {
	if [ ! -d "${KERNEL_DIR}/kernel/pgo" ] ; then
		print_info 1 "$(get_indent 1)>>"
		print_info 1 "$(get_indent 1)>> Missing pgo directory.  Did you apply the patch"
		print_info 1 "$(get_indent 1)>> from:"
		print_info 1 "$(get_indent 1)>> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/patch/?h=for-next/clang/pgo&id=a15058eaefffc37c31326b59fa08b267b2def603&id2=fca41af18e10318e4de090db47d9fa7169e1bf2f"
		print_info 1 "$(get_indent 1)>>"
		print_info 1 "$(get_indent 1)>> Commit history:"
		print_info 1 "$(get_indent 1)>> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/clang/pgo"
		print_info 1 "$(get_indent 1)>>"
		exit 1
	fi
}

check_pgo_profraw_fixes_applied() {
	if [ ! -e "${KERNEL_DIR}/kernel/pgo/pgo.h" ] ; then
		print_info 1 "$(get_indent 1)>>"
		print_info 1 "$(get_indent 1)>> Missing PGO header"
		print_info 1 "$(get_indent 1)>>"
		exit 1
	fi
	if ! grep -q -e "binary_id_size" "${KERNEL_DIR}/kernel/pgo/pgo.h" ; then
		print_info 1 "$(get_indent 1)>>"
		print_info 1 "$(get_indent 1)>> Missing profraw header fix for multislot llvm"
		print_info 1 "$(get_indent 1)>> or for recent llvm releases"
		print_info 1 "$(get_indent 1)>>"
		print_info 1 "$(get_indent 1)>> Apply the following patch to the kernel sources:"
		print_info 1 "$(get_indent 1)>> https://raw.githubusercontent.com/orsonteodoro/oiledmachine-overlay/master/sys-kernel/ot-sources/files/clang-pgo-support-profraw-v6-to-v8.patch"
		print_info 1 "$(get_indent 1)>>"
		exit 1
	fi
}

check_pgo_requirements() {
	if ( is_genkernel && [[ -n "${CMD_PGI}" || -n "${CMD_PGO}" ]] ) \
		|| ( ! is_genkernel && true ) ; then
		check_pgo_applied
		check_pgo_profraw_fixes_applied
	fi
}

if ! is_genkernel ; then
main() {
	[[ -n "${CHECK_REQUIREMENTS}" && "${CHECK_REQUIREMENTS}" == "1" ]] && check_pgo_requirements
	pgo_trainer_all
}
main
fi
