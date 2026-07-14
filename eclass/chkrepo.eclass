# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: chkrepo.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB:  check repo for rebuild reproducibility
# @DESCRIPTION:
# Ensure the installed package uses a specific preferred overlay for
# reproducibility.

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CHKREPO_ECLASS} ]] ; then
_CHKREPO_ECLASS=1

# @FUNCTION: chkrepo_check_one_repo_id
# @DESCRIPTION:
# Verify one package for timestamp
#
# Example:
# pkg_setup() {
#	chkl_check_one "sys-libs/readline" "oiledmachine-overlay" "The distro uses wrong live branch for secure updates."
# }
#
chkrepo_check_one_repo_id() {
	local atom="${1}" # dev-lang/rust
	local expected_repo_id="${2}"
	local reason="${3}"

	local k
	k="${atom}"
	k=$(echo "${k}" | sed -e "s|[/.-]|_|g")

	has_version "${atom}" || return
	local actual_repo_id=$(cat "/var/db/pkg/${atom}"*"/repository")
	if [[ "${actual_repo_id}" != "${expected_repo_id}" ]] ; then
eerror
eerror "${atom} is using the wrong ebuild from the wrong repo."
eerror
eerror "Actual repo:  ${actual_repo_id}"
eerror "Expected repo:  ${expected_repo_id}"
eerror "Reason:  ${reason}"
eerror
eerror "Do one of the following:"
eerror
eerror "\`emerge -a1vO ${atom}::${expected_repo_id}\` for recent merges"
eerror
eerror "  or"
eerror
eerror "\`emerge -a1ovuDN ${atom}::${expected_repo_id} && emerge -a1vO ${atom}::${expected_repo_id}\` for unrecent merges"
eerror
eerror "  or"
eerror
			die
		fi
	fi
}

# @FUNCTION: chkrepo_check_many_repo_ids
# @DESCRIPTION:
# Verify many packages for particular repo IDs
#
# Example:
# CHKREPO_IDS=(
#	"sys-libs/readline;oiledmachine-overlay;The distro uses wrong live branch for secure updates."
# )
#
# pkg_setup() {
#	chkrepo_check_many_repo_ids
# }
#
chkrepo_check_many_repo_ids() {
	local row
	for row in "${CHKREPO_IDS[@]}" ; do
		local atom
		local repo_id
		local reason
		IFS=";" read -r atom repo_id reason <<< "$string"
		chkrepo_check_one_repo_id "${atom}" "${repo_id}" "${reason}"
	done
}

fi
