# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cflags-depends.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Compiler Oflag dependencies
# @DESCRIPTION:
# This eclass will check dependencies for performance impact caused by the
# compiler O flag level.  The goal is to have those dependencies with the
# >= 50% performance penalty (or 50% time cost) built with the proper O level.
# When performance penalty is too much, it can lead to poor quality build, bad
# reviews, skippy playback, out of sync lips, stress, wasted hours trying to
# find the package that caused the performance penalty.

# Use this eclass in cases where the penalty is a major concern like
# exam software, emergency broadcast receiver software, unfair gameplay.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: CFLAGS_RDEPEND
# @DESCRIPTION:
# A required associative array of package to optimization flag declared in
# global scope.  The flag is the minimum required to acheive performance
# expectations which are greater than half relative to the most optimized
# setting.
#
# Example:
#
# declare -A CFLAGS_RDEPEND=(
#	["foo/bar"]="-O2"
#	["category/package-name"]="-O2"
# )

# @FUNCTION: _cflags-depends_is_exact
# @INTERNAL
# @DESCRIPTION:
# Check if arg 1 is exactly one of varargs
_cflags-depends_is_exact() {
	local needle="${1}"
	shift
	local haystack=($@)
	local turd
	for turd in ${haystack[@]} ; do
		[[ "${x}" == "${turd}" ]] && return 0
	done
	return 1
}

# @FUNCTION: _cflags-depends_is_opt_lt
# @INTERNAL
# @DESCRIPTION:
# Check if a <= b, with a and b optimization flags.
# Examples
# _cflags-depends_is_opt_lt -O1 -O3 # same as -O1 < -O3 which returns 0.
# _cflags-depends_is_opt_lt -O3 -O1 # same as -O1 < -O3 which returns 1.
_cflags-depends_is_opt_lt() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a="${a/4/3}"
	b="${b/4/3}"

	# O0 < Og < O1 < Oz < Os < O2 < O3 < Ofast

	if _cflags-depends_is_exact "${a}" "0" "g" "1" "z" "s" "2" "3" && [[ "${b}" == "fast" ]] ; then
		return 0
	elif _cflags-depends_is_exact "${a}" "0" "g" "1" "z" "s" "2"  && [[ "${b}" == "3" ]] ; then
		return 0
	elif _cflags-depends_is_exact "${a}" "0" "g" "1" "z" "s" && [[ "${b}" == "2" ]] ; then
		return 0
	elif _cflags-depends_is_exact "${a}" "0" "g" "1" "z" && [[ "${b}" == "s" ]] ; then
		return 0
	elif _cflags-depends_is_exact "${a}" "0" "g" && [[ "${b}" == "1" ]] ; then
		return 0
	elif _cflags-depends_is_exact "${a}" "0" && [[ "${b}" == "g" ]] ; then
		return 0
	fi
	return 1
}

# @FUNCTION: _cflags-depends_get_last_oflag
# @INTERNAL
# @DESCRIPTION:
# Gets the last optimization flag from CFLAGS
_cflags-depends_get_last_oflag() {
	local p="${1}"

	# portageq is bugged
	local cflags=$(cat "${EROOT}/var/db/pkg/${p}"*"/CFLAGS" 2>/dev/null)
	cflags=($(echo "${cflags[@]}" | tr " " "\n" | sort -r))

	if [[ -n "${cflags}" ]] ; then
		local flag
		for flag in ${cflags[@]} ; do
			if [[ "${flag}" =~ (-O0|-O1|-O2|-O3|-O4|-Ofast|-Og|-Os|-Oz) ]] ; then
				echo "${flag}"
				return
			fi
		done
	fi
	echo "-O0"
}

# @FUNCTION: cflags-depends_check
# @DESCRIPTION:
# Checks the cflags to meet performance and quality standards.
cflags-depends_check() {
	local PKGS=(
		${!CFLAGS_RDEPEND[@]}
	)
	local p
	for p in ${PKGS[@]} ; do
		! has_version "${p}" && continue
		local actual_oflag=$(_cflags-depends_get_last_oflag "${p}")
		local required_oflag="${CFLAGS_RDEPEND[${p}]}"
einfo "Actual oflag:\t${actual_oflag} (${p})"
einfo "Required oflag:\t${required_oflag} (${p})"
		if _cflags-depends_is_opt_lt "${actual_oflag}" "${required_oflag}" ; then
eerror
eerror "Recompile ${p} with ${required_oflag} or better"
eerror
			die
		fi
	done
}
