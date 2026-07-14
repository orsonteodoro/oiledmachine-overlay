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
	local atom="${1}" # sys-libs/readline
	local expected_repo_id="${2}"
	local reason="${3}"

	local k
	k="${atom}"
	k=$(echo "${k}" | sed -e "s|[/.-]|_|g")

	has_version "${atom}" || return
	local actual_repo_id=$(cat "/var/db/pkg/${atom}"*"/repository" | head -n 1)
	if [[ "${actual_repo_id}" != "${expected_repo_id}" ]] ; then
		local category="${atom#*/}"
		local pn="${atom%/*}"
eerror
eerror "${atom} is using the wrong ebuild from the wrong repo."
eerror
eerror "Actual repo:  ${actual_repo_id}"
eerror "Expected repo:  ${expected_repo_id}"
eerror "Reason:  ${reason}"
eerror
eerror "Do"
eerror
eerror "  echo \"${atom}::${actual_repo_id}\" >> /etc/portage/package.mask/${pn}"
eerror "  echo \"${atom}::${expected_repo_id} ~amd64 ~arm64 **\" >> /etc/portage/package.accept_keywords/${pn}"
eerror "  echo \"${atom}::${expected_repo_id}\" >> /etc/portage/package.unmask/${pn}"
eerror
eerror "AND either"
eerror
eerror "  \`emerge -a1vO ${atom}::${expected_repo_id}\` for recent merges"
eerror
eerror "or"
eerror
eerror "  \`emerge -a1ovuDN ${atom}::${expected_repo_id} && emerge -a1vO ${atom}::${expected_repo_id}\` for unrecent merges"
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
	local atom
	local repo_id
	local reason
	local row
	for row in "${CHKREPO_IDS[@]}" ; do
		IFS=";" read -r atom repo_id reason <<< "$string"
		chkrepo_check_one_repo_id "${atom}" "${repo_id}" "${reason}"
	done
}

fi
