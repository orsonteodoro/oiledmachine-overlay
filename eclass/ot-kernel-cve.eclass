# Copyright 2019-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-cve.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for CVE patching the kernel
# @DESCRIPTION:
# The ot-kernel-cve eclass resolves CVE vulnerabilities for any linux kernel
# version, preferably latest stable.

# WARNING: The patch tests assume the whole commit or patch is used.  Do not
# try to manually apply a custom patch to attempt to rig the result as pass.

# These are not enabled by default because of licensing, government interest,
# no crypto applied (as in PGP/GPG signed emails) to messages to authenticate
# or verify them.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

IUSE+=" cve_hotfix"

LICENSE+=" cve_hotfix? ( GPL-2 )"

DEPEND+="
	cve_hotfix? (
		app-arch/gzip
		app-misc/jq
		app-text/html2text
		dev-libs/libpcre
		dev-util/patchutils
		sys-apps/grep[pcre]
	)
"

# _PM = patch message from person who fixed it, _FN = patch file name

# These contants deal with levels of trust with patches.
# Low values imply official fix, higher quality, less buggy.
# High values imply unofficial fix, lower quality, more buggy.
CVE_ALLOW_KERNEL_DOT_ORG_REPO=0x00000001
CVE_ALLOW_GITHUB_TORVALDS=0x00000002
CVE_ALLOW_RESERVED=0x00000004
CVE_ALLOW_MODULE_MAINTAINER=0x00000008 # as in submitted by maintainer

# as in code reviewed by module maintainer
CVE_ALLOW_MODULE_MAINTAINER_REVIEWED=0x00000008

CVE_ALLOW_NVD_IMMEDIATE_LINKED_PATCH=0x00010000 # immediate links only

# Same patch fix author but newer version v2 -> v3 where v3 is chosen
CVE_ALLOW_NVD_INDIRECT_LINKED_PATCH=0x00020000

CVE_ALLOW_CORPORATE_REVIEWED=0x00040000
CVE_ALLOW_MAJOR_DISTRO_REVIEWED=0x00080000
CVE_ALLOW_MAJOR_DISTRO_TEAM_SUGGESTION=0x04000000

# Used typically for backports which may be sourced from *any* source that seem
# like credible fixes
CVE_ALLOW_EBUILD_MAINTAINER_FILESDIR=0x01000000

# has authored a project and released under a FOSS license
CVE_ALLOW_FOSS_CONTRIBUTOR=0x01000000

# has authored a project but not explicitly under a FOSS license
CVE_ALLOW_OPEN_SOURCE_CONTRIBUTOR=0x10000000

CVE_ALLOW_PATRON=0x80000000 # non oss contributor but may use product

# todo, you as a user, maybe xml encoded savedconfig.  it is intended to apply
# patches that the ebuild maintainer missed or wants to apply ahead of time.
CVE_ALLOW_ME=0x80000000

CVE_DISALLOW_UNTRUSTED=0x00000000
CVE_DISALLOW_INCOMPLETE=0x00000000

CVE_FIX_TRUST_DEFAULT=$(( \
	  ${CVE_ALLOW_KERNEL_DOT_ORG_REPO} \
	| ${CVE_ALLOW_GITHUB_TORVALDS} \
	| ${CVE_ALLOW_NVD_IMMEDIATE_LINKED_PATCH} \
	| ${CVE_ALLOW_NVD_INDIRECT_LINKED_PATCH} \
	| ${CVE_ALLOW_CORPORATE_REVIEWED} \
	| ${CVE_ALLOW_MAJOR_DISTRO_REVIEWED} \
	| ${CVE_ALLOW_MAJOR_DISTRO_TEAM_SUGGESTION} \
	| ${CVE_ALLOW_EBUILD_MAINTAINER_FILESDIR} \
	| ${CVE_ALLOW_FOSS_CONTRIBUTOR} \
))

ot-kernel-cve_setup() {
	export CVE_FIX_TRUST_LEVEL=${CVE_FIX_TRUST_LEVEL:-${CVE_FIX_TRUST_DEFAULT}}

	# rejects applying cve fixes for all CVEs marked with disputed flag
	export CVE_FIX_REJECT_DISPUTED=${CVE_FIX_REJECT_DISPUTED:-0}

	# This only applies to dangerous non trivial backports which might
	# result in data loss or data corruption, non functioning driver/device,
	# or irreversible damage.
	export CVE_ALLOW_RISKY_BACKPORTS=${CVE_ALLOW_RISKY_BACKPORTS:-0}

	export CVE_DELAY="${CVE_DELAY:-1}"

	export CVE_LANG="${CVE_LANG:-en}"	# You can define this in your make.conf.
						# Currently en is only supported.

	export CVE_MAX_BULK_CONNECTIONS=${CVE_MAX_BULK_CONNECTIONS:-5}
	export CVE_MAX_PATCH_CONNECTIONS=${CVE_MAX_PATCH_CONNECTIONS:-100}

	# Additional commits not mentioned in NVD CVE report but added by vendor
	# of the same type.  NVD DB will report 1 memory leak then not mention several
	# ones following applied by driver maintainer.  Associated commits should likely
	# be added to CVE/NVD report but are not.
	export CVE_ALLOW_CRASH_PREVENTION=${CVE_ALLOW_CRASH_PREVENTION:-1}

	# This will perform heuristic keyword analysis on the commit itself
	# for fix suitability and to avoid re-introducing flaws by security
	# researchers fully disclosing commits good or bad.
	export CVE_ALLOW_UNTAGGED_PATCHES=${CVE_ALLOW_UNTAGGED_PATCHES:-1}

	# This controls how much is downloaded and the patch starting point.
	if [[ -z "${CVE_MIN_YEAR}" ]] ; then
		local this_year=$(date +"%Y")
		export CVE_MIN_YEAR="${this_year}" # 1999 is the minimal
	fi
}

TUXPARONI_A_FN="tuxparoni.tar.gz"
TUXPARONI_SRC_URI="https://github.com/orsonteodoro/tuxparoni/archive/master.tar.gz"

fetch_tuxparoni() {
einfo "Fetching tuxparoni from a live source..."
	wget -O "${T}/${TUXPARONI_A_FN}" "${TUXPARONI_SRC_URI}" || die
}

unpack_tuxparoni() {
	cd "${WORKDIR}"
	unpack "${T}/${TUXPARONI_A_FN}"
	cp -a "${FILESDIR}/tuxparoni-conflict-resolver" \
		"${WORKDIR}/tuxparoni-master" || die

#	# for debugging or developing tuxparoni
#	mkdir -p "${WORKDIR}/tuxparoni-master"
#	cp "${FILESDIR}"/tuxparoni* "${WORKDIR}/tuxparoni-master"
}

fetch_cve_hotfixes() {
	local allow_crash_prevention=""
	[[ "${CVE_ALLOW_CRASH_PREVENTION}" ]] \
		&& allow_crash_prevention="-acp"
	local allow_crash_untagged=""
	[[ "${CVE_ALLOW_UNTAGGED_PATCHES}" ]] \
		&& allow_crash_untagged_patches="-au"
	local min_year=""
	[[ "${CVE_MIN_YEAR}" ]] \
		&& min_year="-mn ${CVE_MIN_YEAR}"
ewarn
ewarn "The cve_hotfix USE flag is still experimental and unstable and may not"
ewarn "work at random times."
ewarn
	pushd "${WORKDIR}/tuxparoni-master" || die
		local b="${EDISTDIR}/ot-sources-src"
		local d="${b}/tuxparoni"
		addwrite "${b}"
		mkdir -p "${d}"
		chmod +x tuxparoni
		sed -i -e "s|root:root|portage:portage|" tuxparoni || die

einfo "If the CVE fixer fails, do:  rm -rf ${d}"
einfo "Fetching NVD JSONs"
		./tuxparoni -u -c "${d}" -s "${S}" --cmd-fetch-jsons \
			-t "${T}" -mbc ${CVE_MAX_BULK_CONNECTIONS} \
			${min_year} || \
die "You may need to manually remove ${d}/{feeds,jsons} folders"
einfo "Fetching patches"
		./tuxparoni -u -c "${d}" -s "${S}" --cmd-fetch-patches \
			-t "${T}" -au -mpc ${CVE_MAX_PATCH_CONNECTIONS} \
			${allow_crash_prevention} \
			${allow_crash_untagged_patches} \
			${min_year} || \
die "You may need to manually remove ${d}/{feeds,jsons} folders"

		# copy custom backport patches
		cp "${FILESDIR}"/CVE* "${d}/custom_patches"
	popd
}

test_cve_hotfixes() {
	local min_year=""
	[[ "${CVE_MIN_YEAR}" ]] \
		&& min_year="-mn ${CVE_MIN_YEAR}"
	pushd "${WORKDIR}/tuxparoni-master" || die
		local b="${EDISTDIR}/ot-sources-src"
		local d="${b}/tuxparoni"
einfo "Dry testing"
		./tuxparoni -u -c "${d}" -s "${S}" --cmd-dry-test -t "${T}" \
			${min_year} || true
	popd
}

get_cve_report() {
	local min_year=""
	[[ "${CVE_MIN_YEAR}" ]] \
		&& min_year="-mn ${CVE_MIN_YEAR}"
	pushd "${WORKDIR}/tuxparoni-master" || die
		local b="${EDISTDIR}/ot-sources-src"
		local d="${b}/tuxparoni"
einfo "Generating Report"
		./tuxparoni -u -c "${d}" -s "${S}" --cmd-report -t "${T}" \
			${min_year} || true
	popd
}

apply_cve_hotfixes() {
	local min_year=""
	[[ "${CVE_MIN_YEAR}" ]] \
		&& min_year="-mn ${CVE_MIN_YEAR}"
	pushd "${WORKDIR}/tuxparoni-master" || die
		local b="${EDISTDIR}/ot-sources-src"
		local d="${b}/tuxparoni"
einfo "Applying cve hotfixes"
		./tuxparoni -u -c "${d}" -s "${S}" --cmd-apply -t "${T}" \
			${min_year} || die
	popd
}
