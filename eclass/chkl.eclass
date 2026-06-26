# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: chkl.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: check live appropriateness
# @DESCRIPTION:
# Check if live is appropriate in the security context.
#
# There is a tendency for some to flood the zone with unverified live ebuilds in
# order to weaken the security and reproducible builds.  Rash users will
# immediately accept the live alternative without reading the ebuild contents.

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CHKL_ECLASS} ]] ; then
_CHKL_ECLASS=1

inherit secure-timestamp

# @ECLASS_VARIABLE: CHKL_NONFATAL
# @USER_VARIABLE
# @DESCRIPTION:
# Change the error into warning.
# Valid values:  1, 0, unset

# @FUNCTION: chkl_check_one_timestamp
# @DESCRIPTION:
# Verify one package for timestamp
#
# Example:
# pkg_setup() {
#	chkl_check_one "dev-lang/rust-9999"
# }
#
chkl_check_one_timestamp() {
	local atom="${1}" # dev-lang/rust-9999

	# From the git Date field in commit
	#
	# Acceptable formats:
	#
	# 2026-06-10 17:58:03 UTC
	# 2026-06-10 17:58:03 -0700
	# Apr 28, 2026 14:53:32 -0700
	# Tue, Apr 28, 2026 14:53:32 -0700
	# May 22, 2026 00:33:25 -0700
	# 2026/06/10 17:58:03
	# 2026/06/10 17:58:03 -0700
	# 2026/06/10 17:58:03 UTC-7
	#
	local k
	k="${atom}"
	k=$(echo "${k}" | sed -e "s|[/.-]|_|g")

#einfo "DEBUG:  ${k}"
	local t=$(get_secure_timestamps)
	eval "${t}"
	local live_timestamp=${SECURE_TIMESTAMP["${k}"]}
	if [[ -z "${live_timestamp}" ]] ; then
eerror "QA:  Missing live timestamp for ${atom}"
		die
	fi

	has_version "=${atom}" || return
	local non_vulernable_time=$(date --date="${live_timestamp}" "+%s")
	local merge_time=$(cat "/var/db/pkg/${atom}/BUILD_TIME")
#einfo "DEBUG:  merge_time:  "$(date --date="@${merge_time}")" (${merge_time}) for ${atom}"
#einfo "DEBUG:  non_vulernable_time:  "$(date --date="@${non_vulernable_time}")" (${non_vulernable_time}) for ${atom}"
	if has_version "=${atom}" && (( ${merge_time} >= ${non_vulernable_time} )) ; then
einfo "Security timestamp for =${atom}:  PASSED"
	elif has_version "=${atom}" ; then
einfo "Security timestamp for =${atom}:  FAILED (OLD)"
		if [[ "${CHKL_NONFATAL}" == "1" ]] ; then
ewarn "Current timestamp:  "$(date --date="@${merge_time}")
ewarn "Expected timestamp:  >= "$(date --date="@${non_vulernable_time}")
			:
		else
eerror
eerror "Do one of the following:"
eerror
eerror "\`emerge -a1vO =${atom}\` for recent merges"
eerror
eerror "  or"
eerror
eerror "\`emerge -a1ovuDN =${atom} && emerge -a1vO =${atom}\` for unrecent merges"
eerror
eerror "  or"
eerror
eerror "\`emerge -a @live-rebuild\`."
eerror
eerror "  or"
eerror
eerror "Emerge a stable tagged version if the ebuild allows it"
eerror
eerror "  or"
eerror
eerror "Set CHKL_NONFATAL=1 per-package or as an environment-variable."
eerror
eerror "Current timestamp:  "$(date --date="@${merge_time}")
eerror "Expected timestamp:  >= "$(date --date="@${non_vulernable_time}")
eerror
			die
		fi
	fi
}

# @FUNCTION: chkl_check_many_timestamps
# @DESCRIPTION:
# Verify many packages for timestamps
#
# Example:
# CHKL_TIMESTAMPS=(
#	"dev-lang/rust-9999"
#	"dev-lang/rust-bin-9999"
# )
#
# pkg_setup() {
#	chkl_check_many_timestamps
# }
#
chkl_check_many_timestamps() {
	local row
	for row in "${CHKL_TIMESTAMPS[@]}" ; do
		local atom=$(echo "${row}")
		chkl_check_one_timestamp "${atom}"
	done
}

# @FUNCTION: chkl_check_many_stable
# @DESCRIPTION:
# Verify one package for stable
#
# Example
# pkg_setup() {
#	chkl_check_one_live_ban "dev-lang/rust-9999"
# }
chkl_check_one_live_ban() {
	local atom="${1}" # dev-lang/rust-9999
	if has_version "=${atom}" ; then
		if [[ "${CHKL_NONFATAL}" == "1" ]] ; then
ewarn "The live is banned for ${atom}.  Downgrade ${atom} to LTS."
		else
eerror "The live is banned for ${atom}.  Downgrade ${atom} to LTS"
eerror "or set CHKL_NONFATAL=1 per-package or as an environment-variable."
			die
		fi
	fi
}

# @FUNCTION: chkl_check_many_stable
# @DESCRIPTION:
# Verify many packages for stable
#
# Example
# CHKL_BLACKLIST=(
#	"dev-lang/rust-9999"
#	"dev-lang/rust-bin-9999"
#	"x11-libs/cairo-9999"
# )
# pkg_setup() {
#	chkl_check_many_live_bans
# }
chkl_check_many_live_bans() {
	local row
	for row in "${CHKL_BLACKLIST[@]}" ; do
		local atom="${row}"
		chkl_check_one_live_ban "${atom}"
	done
}

fi
