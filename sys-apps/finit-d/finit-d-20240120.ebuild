# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI=""
S="${WORKDIR}"

DESCRIPTION="finit.d/*.conf files for the Finit init system"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	BSD-2
	MIT
	GPL-2
"
if [[ "${PV}" =~ "99999999" ]] ; then
	# No KEYWORDS for live
	:
else
	KEYWORDS="~amd64"
fi
RESTRICT="mirror test"
SLOT="0"
IUSE+="
	${SERVICES[@]}
	dash
	+dbus
	hook-scripts
	netlink
"
REQUIRED_USE="
	?? (
		hook-scripts
		netlink
	)
"
RDEPEND="
	!sys-apps/openrc
	app-admin/sudo
	sys-libs/libcap
	sys-process/procps
	dash? (
		app-shells/dash[libedit]
	)
"
BDEPEND="
	dev-libs/libpcre2
"
PDEPEND="
	sys-apps/finit[dbus?,hook-scripts?,netlink?]
"

pkg_setup() {
	if [[ "${PV}" =~ "99999999" ]] ; then
ewarn
ewarn "This version of the ebuild is currently being converted to an OpenRC -> Finit init converter and considered pre alpha."
ewarn "This will increase the package support init files in a less biased way"
ewarn "Do not use this ebuild this time.  Use the snapshot instead."
ewarn
ewarn "This is the dev version."
	else
einfo "This is the live snapshot version."
	fi
ewarn
ewarn "For wireless, it is recommended to use one of the following instead:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"hook/net/up\"      # needs sys-apps/finit[hook-scripts]"
ewarn "  FINIT_COND_NETWORK=\"net/wlan0/up\"     # needs sys-apps/finit[netlink]"
ewarn "  FINIT_COND_NETWORK=\"net/eth0/up\"      # needs sys-apps/finit[netlink]"
ewarn
ewarn "Prohibited for wireless:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"net/route/default\""
ewarn
ewarn
ewarn "Place one of the above in /etc/portage/env/finit-d.conf"
ewarn
ewarn "Place the following in /etc/portage/package.env:"
ewarn
ewarn "  ${CATEGORY}/${PN} finit-d.conf"
ewarn
	if [[ "${FINIT_SCRIPT_SOURCE}" =~ "openrc" && "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] ; then
ewarn
ewarn "You are enabling both openrc and systemd for FINIT_SCRIPT_SOURCE."
ewarn "The dependency trees in the init files may be incomplete if configs"
ewarn "clobber.  Only one source should be used."
ewarn
	fi
	if [[ "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] ; then
ewarn
ewarn "The systemd FINIT_SCRIPT_SOURCE coverage is less than"
ewarn "FINIT_SCRIPT_SOURCE.  For less bugs, use openrc for FINIT_SCRIPT_SOURCE"
ewarn "instead."
ewarn
	fi
	if [[ -z "${FINIT_RESPAWNABLE}" ]] ; then
ewarn
ewarn "The FINIT_RESPAWNABLE flag is empty.  It should contain a list of"
ewarn "essential services needed for your use case.  See metadata.xml"
ewarn "for details."
ewarn
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		cp -a "${FILESDIR}/dev/"* "${WORKDIR}" || die
	else
		cp -a "${FILESDIR}/${PV}/"* "${WORKDIR}" || die
	fi
}

src_prepare() {
	default
}


is_file_blacklisted_during_pruning() {
	[[ -z "${FINIT_BLACKLISTED_FOR_PRUNING}" ]] && return 1
	local x_path="${1}"
	local L=(
		${FINIT_BLACKLISTED_FOR_PRUNING}
	)
	for _path in ${L[@]} ; do
		local path=$(basename "${_path}")
		[[ "${x_path}" == "${path}" ]] && return 0
	done
	return 1
}

count_left_curly() {
	local str="${1}"
	local n=0
	local i
	for (( i=0 ; i < ${#str} ; i++ )) ; do
		local c="${str:${i}:1}"
		[[ "${c}" == '{' ]] && n=$((${n}+1))
	done
	echo "${n}"
}

count_right_curly() {
	local str="${1}"
	local n=0
	local i
	for (( i=0 ; i < ${#str} ; i++ )) ; do
		local c="${str:${i}:1}"
		[[ "${c}" == '}' ]] && n=$((${n}+1))
	done
	echo "${n}"
}

count_single_quotes() {
	local str="${1}"
	local n=0
	local i
	for (( i=0 ; i < ${#str} ; i++ )) ; do
		local c="${str:${i}:1}"
		[[ "${c}" == "'" ]] && n=$((${n}+1))
	done
	echo "${n}"
}

count_double_quotes() {
	local str="${1}"
	local n=0
	local i
	for (( i=0 ; i < ${#str} ; i++ )) ; do
		local c="${str:${i}:1}"
		[[ "${c}" == '"' ]] && n=$((${n}+1))
	done
	echo "${n}"
}

prune_pound() {
	local str="${1}"
	local buffer=""
	local i
	for (( i=0 ; i < ${#str} ; i++ )) ; do
		local c="${str:${i}:1}"
		if [[ "${c}" == "#" ]] ; then
			local ns=$(count_single_quotes "${buffer}")
			local nd=$(count_double_quotes "${buffer}")
			local nlcurly=$(count_left_curly "${buffer}")
			local nrcurly=$(count_right_curly "${buffer}")
			local ns_odd=$((${ns}%2))
			local nd_odd=$((${nd}%2))
			if (( ${ns_odd} == 1 )) ; then
				buffer+="${c}"
			elif (( ${nd_odd} == 1 )) ; then
				buffer+="${c}"
			elif (( ${nlcurly} != ${nrcurly} )) ; then
				buffer+="${c}"
			else
#einfo "After prune:"
#einfo "B:  ${str}"
#einfo "A:  ${buffer}"
				break
			fi
		else
			buffer+="${c}"
		fi
	done
	echo "${buffer}"
}

# Also perform minification to avoid parse penalties.
minify() {
	local script_path
	for script_path in $(find "${ED}/lib/finit/scripts" -type f) ; do
		# [[ "${script_path}" =~ "lib.sh" ]] && continue
		is_file_blacklisted_during_pruning && continue
einfo "Minifying $(basename ${script_path})"
		IFS=$'\n'

		local passes
		for passes in $(seq 1 2) ; do
			local tpath=$(mktemp -p "${T}")
			local line=""
			while read line; do
				line=$(echo -E "${line}" | sed -r -e "s|^[[:space:]]+||g")
				line=$(echo -E "${line}" | sed -r -e "s|[[:space:]]+$||g")
				line=$(echo -E "${line}" | sed -e "/^$/d")
				if [[ -z "${line}" ]] ; then
					continue
				elif [[ "${line,,}" =~ "copyright" ]] ; then
					echo "${line}" >> "${tpath}" || die
				elif [[ "${line,,}" =~ "distributed" ]] ; then
					echo "${line}" >> "${tpath}" || die
				elif [[ "${line,,}" =~ '#!' ]] ; then
					echo "${line}" >> "${tpath}" || die
				elif [[ "${line}" =~ ^[[:space:]]*'#' ]] ; then
					continue
				elif [[ "${line}" =~ '#' ]] ; then
					local t=$(prune_pound "${line}")
					echo "${t}" >> "${tpath}" || die
				else
					echo "${line}" >> "${tpath}" || die
				fi
			done < "${script_path}"
			cat "${tpath}" > "${script_path}" || die
			rm "${tpath}" || die
		done

		sed -i -e "/^$/d" "${script_path}" || die
		sed -i -e "/^after .*/d" "${script_path}" || die
		sed -i -e "/^before .*/d" "${script_path}" || die
		sed -i -e "/^keyword .*/d" "${script_path}" || die
		sed -i -e "/^need .*/d" "${script_path}" || die
		sed -i -e "/^provides .*/d" "${script_path}" || die
		sed -i -e "/^use .*/d" "${script_path}" || die
		sed -i -r -e "s|[[:space:]]+--| --|g" "${script_path}" || die
		sed -i -r -e "s|[[:space:]]*;[[:space:]]+*then|;then|g" "${script_path}" || die
		sed -i -r -e "s|[[:space:]]*;[[:space:]]+*do|;do|g" "${script_path}" || die

		sed -i -r -e 's#[[:space:]]*\&\&[[:space:]]*#\&\&#g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]*\|\|[[:space:]]*#\|\|#g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]*\{[[:space:]]*#\{#g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]*\}[[:space:]]+#\} #g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]*\|[[:space:]]*#\|#g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]*\&[[:space:]]*#\&#g' "${script_path}" || die

		sed -i -r -e 's#\[[[:space:]]*(\^?)[[:space:]]*\[[[:space:]]*:([a-z]+):[[:space:]]*\][[:space:]]*\]#[\1[:\2:]]#g' "${script_path}" || die

		sed -i -r -e ":a;N;\$!ba s|depend\(\)[[:space:]]*\{\n(:\n)*\}||" "${script_path}" || die
		sed -i -r -e ":a;N;\$!ba s#(:)+#:#g" "${script_path}" || die

		sed -i -r -e '/^$/d' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]+# #g' "${script_path}" || die
		sed -i -r -e 's#[[:space:]]+;;#;;#g' "${script_path}" || die
		IFS=$' \t\n'
	done
}

prune_debug() {
	local script_path
	for script_path in $(grep -r -E -l "(ebegin|einfo|eerror|eend|ewarn)" "${ED}/lib/finit/scripts") ; do
		[[ "${script_path}" =~ "lib.sh" ]] && continue
		is_file_blacklisted_during_pruning && continue
einfo "Pruning debug in $(basename ${script_path})"
		sed -i \
			-e "/ebegin/d" \
			-e "/einfo/d" \
			-e "/eerror/d" \
			-e "/eend/d" \
			-e "/ewarn/d" \
			"${script_path}" \
			|| die
	done
}

src_compile() {
	chmod +x generate.sh || die
	use dash && export FINIT_SHELL="/bin/dash"
	use dash || export FINIT_SHELL="/bin/sh"
	if [ -n "${FINIT_COND_NETWORK}" ] ; then
einfo "Using ${FINIT_COND_NETWORK} for network up."
		export FINIT_COND_NETWORK
	else
einfo "Using net/route/default for network up.  This conditon is bugged.  See metadata.xml for details on FINIT_COND_NETWORK."
		export FINIT_COND_NETWORK="net/route/default"
	fi

	# Save before wipe
	cp -a "${WORKDIR}/confs/getty.conf" "${WORKDIR}" || die
	./generate.sh || die
	cp -a "${WORKDIR}/getty.conf" "${WORKDIR}/confs" || die

	local n=$(cat "${WORKDIR}/needs_net.txt" | wc -l)
	if (( n > 1 )) && ! use hook-scripts && ! use netlink ; then
eerror "You need to enable either hook-scripts or netlink USE flag."
		die
	fi
	local n=$(cat "${WORKDIR}/needs_dbus.txt" | wc -l)
	if (( n > 1 )) && ! use dbus ; then
eerror "You need to enable the dbus USE flag."
		die
	fi

	if has_version "net-firewall/iptables" && [[ -e "confs/net-firewall/iptables/iptables.conf" ]] ; then
		einfo "Generating ip6tables .conf"
		cp -a \
			"confs/net-firewall/iptables/iptables.conf" \
			"confs/net-firewall/iptables/ip6tables.conf" \
			|| die
		sed -i \
			-e "s|-- iptables|-- ip6tables|g" \
			-e "s|name:iptables|name:ip6tables|g" \
			-e "s|set iptables|set ip6tables|g" \
			-e "s|/iptables/|/ip6tables/|g" \
			-e "s|iptables-|ip6tables-|g" \
			-e '1i SVCNAME="ip6tables"' \
			-e '1i RC_SVCNAME="ip6tables"' \
			"confs/net-firewall/iptables/ip6tables.conf" \
			|| die
	fi

	if has_version "sys-power/thermald" ; then
		# Broken
		sed -i -e "s|--adaptive||g" "scripts/sys-power/thermald/thermald.sh" || die
	fi

	if has_version "app-admin/sysklogd" ; then
		# Avoid missing folder /run/systemd/journal/syslog error
		sed -i -e "s|-p /run/systemd/journal/syslog||g" "scripts/app-admin/sysklogd/syslogd.sh" || die
	fi
}

symlink_hooks() {
	local pairs=(
		"hook_banner_fn:hook/sys/banner"
		"hook_rootfs_up_fn:hook/mount/root"
		"hook_mount_error_fn:hook/mount/error"
		"hook_mount_post_fn:hook/mount/post"
		"hook_basefs_up_fn:hook/mount/all"
		"hook_svc_plugin_fn:hook/svc/plugin"
		"hook_network_up_fn:hook/net/up"
		"hook_svc_up_fn:hook/svc/up"
		"hook_system_up_fn:hook/sys/up"
		# "hook_svc_reconf_fn:"
		# "hook_runlevel_change_fn:"
		"hook_network_dn_fn:hook/net/down"
		"hook_shutdown_fn:hook/sys/shutdown"
		"hook_svc_dn_fn:hook/svc/down"
		"hook_system_dn_fn:hook/sys/down"
	)

	local need_hooks=0
	for row in ${pairs[@]} ; do
		local hook="${row%:*}"
		local fragment="${row#*:}"
		if grep -q "${hook}" "${ED}/lib/finit/scripts/${pkg}/${script}" ; then
			need_hooks=1
			dosym \
				"/lib/finit/scripts/${pkg}/${script}" \
				"/libexec/finit/${fragment}/${script}"
		fi
	done

	if (( ${need_hooks} == 1 )) && ! use hook-scripts ; then
eerror "You need to enable the hook-scripts USE flag."
		die
	fi
}

install_scripts() {
	local pkg="${1}"
	exeinto "/lib/finit/scripts/${pkg}"
	[[ -e "${WORKDIR}/scripts/${pkg}" ]] || return
	pushd "${WORKDIR}/scripts/${pkg}" >/dev/null 2>&1 || die
		for script in $(ls) ; do
			is_blacklisted_svc "${script}" && continue
			doexe "${script}"
			fowners root:root "/lib/finit/scripts/${pkg}/${script}"
			fperms 0750 "/lib/finit/scripts/${pkg}/${script}"

			symlink_hooks
		done
	popd >/dev/null 2>&1 || die
}

install_lib() {
	local script="${1}"
	exeinto "/lib/finit/scripts/lib"
	doexe "${script}"
	fowners "root:root" "/lib/finit/scripts/lib/${script}"
	fperms 0750 "/lib/finit/scripts/lib/${script}"
}

is_blacklisted_pkg() {
	local pkg="${1}"
	local x
	for x in ${FINIT_BLACKLIST_PKGS} ; do
		if [[ "${pkg}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}

is_blacklisted_svc() {
	local svc
	svc="${1/.conf}"
	svc="${svc/.sh}"
	local x
	for x in ${FINIT_BLACKLIST_SVCNAMES} ; do
		if [[ "${svc}" == "${x}" ]] ; then
			return 0
		fi
	done
	return 1
}

generate_netifrc_instances() {
	local pkg="net-misc/netifrc"
	local iface
	for iface in $(ls /sys/class/net) ; do
		[[ "${iface}" == "lo" ]] && continue
		is_blacklisted_svc "net@${iface}" && continue
		einfo "Creating instance net@${iface}.conf"
		dosym \
			"/etc/finit.d/available/${pkg}/net@.conf" \
			"/etc/finit.d/available/${pkg}/net@${iface}.conf"
		dosym \
			"/etc/finit.d/available/${pkg}/net@.conf" \
			"/etc/finit.d/enabled/net@${iface}.conf"
	done
}

gen_start_start_daemon_wrapper() {
# A response to:  grep -r -e "start-stop-daemon" /lib/netifrc/net
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/start-stop-daemon"
#!${FINIT_SHELL}
. /lib/finit/scripts/lib/lib.sh
start_stop_daemon \$@
EOF
	fperms 0750 /usr/bin/start-stop-daemon
}

heal_pruned() {
	# This fixes the missing nop in between code blocks.  It's needed when : is pruned.

	# nop is : for non-inline or :; for inline.

	# Add no-op to else case or delete empty else case.
	local path
	for path in $(find "${ED}/lib/finit/scripts" -type f) ; do
		if pcre2grep -q -M "do[[:space:]]+done" "${path}" ; then
	# Missing nop between do and done
	# while true ; do
	# done
	#
	# or
	#
	# for (( i=0 ; i < max ; i++ )) ; do
	# done
			einfo "Healing ${path} : do-done case"
			sed -i -r -e ":a;N;\$!ba s#do[[:space:]]*done#do :;done#g" "${path}" || die
		fi
		if pcre2grep -q -M "then[[:space:]]+fi" "${path}" ; then
	# Missing nop between then and fi
	# if true ; then
	# fi
			einfo "Healing ${path} : then-fi case"
			sed -i -r -e ":a;N;\$!ba s#then[[:space:]]*fi#then :;fi#g" "${path}" || die
		fi
		if pcre2grep -q -M "then[[:space:]]+elif" "${path}" ; then
	# Missing nop between then and elif
	# if true ; then
	# elif
	#
	# or
	#
	# elif true ; then
	# elif
			einfo "Healing ${path} : then-elif case"
			sed -i -r -e ":a;N;\$!ba s#then[[:space:]]*elif#then :;elif#g" "${path}" || die
		fi
		if pcre2grep -q -M "then[[:space:]]+else" "${path}" ; then
	# Missing nop between then and else
	# if true ; then
	# else
	# 	true
	# fi
			einfo "Healing ${path} : then-else case"
			sed -i -r -e ":a;N;\$!ba s#then[[:space:]]*else#then :;else#g" "${path}" || die
		fi
		if pcre2grep -q -M "else[[:space:]]+fi" "${path}" ; then
	# Missing nop between else and fi
	# if true ; then
	# 	true
	# else
	# fi
			einfo "Healing ${path} : else-fi case"
			sed -i -r -e ":a;N;\$!ba s#else[[:space:]]*fi#else :;fi#g" "${path}" || die
		fi
		if pcre2grep -q -M "\{[[:space:]]+\}" "${path}" ; then
	# Missing nop between { and }
	# dummy() {
	# }
			einfo "Healing ${path} : {} case"
			sed -i -r -e ":a;N;\$!ba s#\{[[:space:]]*\}#\{ :;\}#g" "${path}" || die
		fi
	done
}

src_install() {
	local PKGS=( $(cat "${WORKDIR}/pkgs.txt") )
	local pkg
	for pkg in ${PKGS[@]} ; do
		# Duplicate, already done by finit
		[[ "${pkg}" == "sys-apps/dbus" ]] && continue
		[[ "${pkg}" == "sys-fs/udev-init-scripts" ]] && continue
		is_blacklisted_pkg "${pkg}" && continue

		insinto "/etc/finit.d/available/${pkg}"
		pushd "${WORKDIR}/confs/${pkg}" >/dev/null 2>&1 || die
			local svc
			for svc in $(ls) ; do
				is_blacklisted_svc "${svc}" && continue
				doins "${svc}"
				dosym \
					"/etc/finit.d/available/${pkg}/${svc}" \
					"/etc/finit.d/enabled/${svc}"
			done
		popd >/dev/null 2>&1 || die
		install_scripts "${pkg}"
	done

	if is_blacklisted_pkg "net-misc/netifrc" ; then
		:
	elif has_version "net-misc/netifrc" ; then
		generate_netifrc_instances
	fi

	insinto "/etc/finit.d/available/${CATEGORY}/${PN}"
	doins "${WORKDIR}/confs/getty.conf"
	dosym \
		"/etc/finit.d/available/${CATEGORY}/${PN}/getty.conf" \
		"/etc/finit.d/enabled/getty.conf"

	insinto "/etc"
	doins "${WORKDIR}/rc.local"
	doins "${WORKDIR}/finit.conf"
	install_lib "lib.sh"
	install_lib "event.sh"

	if is_blacklisted_pkg "net-firewall/iptables" ; then
		:
	elif is_blacklisted_svc "ip6tables" ; then
		:
	elif has_version "net-firewall/iptables" ; then
		dosym \
			/lib/finit/scripts/net-firewall/iptables/iptables.sh \
			/lib/finit/scripts/net-firewall/iptables/ip6tables.sh
	fi

	# Broken default settings.  Requires METALOG_OPTS+=" -N" for some kernels.
	rm -f "${ED}/etc/finit.d/enabled/metalog.conf"

	if [[ "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] ; then
		# Temporary disable, Causes tty reset if not configured properly
		rm -f "${ED}/etc/finit.d/enabled/greetd.conf"

		# Temporary disable, Prints error on screen
		#rm -f "${ED}/etc/finit.d/enabled/syslogd.conf"

		# Compiles stuff in the background
		rm -rf "${ED}/etc/finit.d/enabled/stap-exporter.conf"

		# Unstuck netifrc's net.$IFACE
		rm -rf "${ED}/etc/finit.d/enabled/wpa"*
		rm -rf "${ED}/libexec/finit/hook/mount/all/wpa"*

		rm -rf "${ED}/libexec/finit/hook/mount/all/ip"*"tables"*
		rm -f "${ED}/etc/finit.d/enabled/ip"*"tables-"*".conf"
	fi

	if [[ "${FINIT_SCRIPT_SOURCE}" =~ "openrc" || -z "${FINIT_SCRIPT_SOURCE}" ]] ; then
		# Causes indefinite pause
		rm -f "${ED}/etc/finit.d/enabled/iptables.conf"
		rm -f "${ED}/etc/finit.d/enabled/ip6tables.conf"
	fi

	gen_start_start_daemon_wrapper

	if [[ "${FINIT_PRUNE_DEBUG_MESSAGES}" == "1" ]] ; then
		prune_debug
	fi
	if [[ "${FINIT_MINIFY}" == "1" ]] ; then
		minify
	fi
	heal_pruned

}

pkg_postinst() {
ewarn
ewarn "Your configs must be correct and exist or you may see crash listed in"
ewarn "initctl.  Debug messages are disabled."
ewarn
ewarn "You must use etc-update for changes to take effect."
ewarn "Save your work before running \`initctl reload\`."
ewarn
	if use netlink ; then
ewarn
ewarn "You may need to disconnect/reconnect not by automated means in order to"
ewarn "trigger network up event."
ewarn
	fi
	if has_version "app-admin/metalog" ; then
ewarn
ewarn "-N may need to be added to METALOG_OPTS in /etc/conf.d/metalog or it"
ewarn "may cause a indefinite pause."
ewarn
ewarn "The /etc/finit.d/enabled/metalog.conf has been disabled to avoid"
ewarn "indefinite pause on misconfigured metalog."
ewarn
	fi
	if has_version "dev-db/mysql-init-scripts" ; then
ewarn
ewarn "You must manually disable some of the mysql-init-scripts in"
ewarn "/etc/finit.d/enabled to prevent blocking init progression or"
ewarn "through FINIT_BLACKLIST_SVCNAMES.  See metadata.xml for details."
ewarn
	fi
ewarn
ewarn "IMPORTANT"
ewarn
ewarn "A rescue cd is required to unstuck the init system."
ewarn
ewarn "Any failed in [S] runlevel may cause an indefinite pause."
ewarn
ewarn "Failed [S] should be moved to runlevels [12345] for rescue, [2345] for"
ewarn "non-network, or [345] for network or deleted from /etc/finit.d/enabled."
ewarn
	if has_version "net-misc/netifrc" && [[ "${FINIT_SCRIPT_SOURCE}" =~ "systemd" ]] ; then
ewarn
ewarn "You must \`killall -9 wpa_supplicant\` before using netifrc's net.* instances."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# openrc conversion:
#   networkmanager - passed
#   netifrc (autoconnect) - passed
#   netifrc (manually connect) - passed.  working secure ssl/tls websites.
#   logger (sysklogd) - passed
#   tty - passed
# systemd conversion:
#   networkmanager - passed
#   netifrc (autoconnect) - fail
#   netifrc (manually connect) - fail.  connects but broken secure ssl/tls websites.
#   logger (sysklogd) - passed
#   tty - passed
#
