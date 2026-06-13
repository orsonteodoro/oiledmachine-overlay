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
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CHKL_ECLASS} ]] ; then
_CHKL_ECLASS=1

# @FUNCTION: chkl_check_one_timestamp
# @DESCRIPTION:
# Verify one package for timestamp
#
# Example:
# pkg_setup() {
#	chkl_check_one "dev-lang/rust-9999" "May 22, 2026 00:33:25 -0700"
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
	local live_timestamp="${2}"

	has_version "=${atom}" || return
	local compatible_time=$(date --date="${live_timestamp}" "+%s")
	local merge_time=$(cat "/var/db/pkg/${atom}/BUILD_TIME")
	if has_version "=${atom}" && (( ${merge_time} < ${compatible_time} )) ; then
eerror
eerror "Detected old live timestamp for live ebuild.  Do one of the following:"
eerror
eerror "Do \`emerge -a1ovuDN ${category_pn}-${pv};emerge -a1vO ${category_pn}-${pv}\`"
eerror
eerror "  or"
eerror
eerror "\`emerge -a @live-rebuild\`."
eerror
eerror "  or"
eerror
eerror "Use a stable tagged version if the ebuild allows it."
eerror
eerror "Current timestamp:  "$(date --date="@${merge_time}")
eerror "Expected timestamp:  >= "$(date --date="@${compatible_time}")
eerror
		die
	fi
}

# @FUNCTION: chkl_check_many_timestamps
# @DESCRIPTION:
# Verify many packages for timestamps
#
# Example:
# CHKL_TIMESTAMPS=(
#	"dev-lang/rust-9999;May 22, 2026 00:33:25 -0700"
#	"dev-lang/rust-bin-9999;May 22, 2026 00:33:25 -0700"
# )
#
# pkg_setup() {
#	chkl_check_many_timestamps
# }
#
chkl_check_many_timestamps() {
	local row
	for row in "${CHKL_TIMESTAMPS[@]}" ; do
		local atom=$(echo "${row}" | cut -f 1 -d ";")
		local live_timestamp=$(echo "${row}" | cut -f 2 -d ";")
		chkl_check_one_timestamp "${atom}" "${live_timestamp}"
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
eerror "Live is banned.  Downgrade ${atom} to LTS."
		die
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
