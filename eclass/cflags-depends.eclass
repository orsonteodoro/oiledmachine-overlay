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
#	["foo/bar"]=">=;-O2"			# Same as x >= -O2
#	["category/package-name"]="<;-O3"	# Same as x < -O3
# )

# @FUNCTION: _cflags-depends_weigh
# @INTERNAL
# @DESCRIPTION:
# Convert the symbol to a numerical weight.
_cflags-depends_weigh() {
	local a="${1}"
	# O0 < Og < O1 < Oz < Os < O2 < O3 < Ofast
	if [[ "${a}" == "0" ]] ; then
		echo "0"
	elif [[ "${a}" == "1" ]] ; then
		echo "1"
	elif [[ "${a}" == "z" ]] ; then
		echo "2"
	elif [[ "${a}" == "s" ]] ; then
		echo "3"
	elif [[ "${a}" == "2" ]] ; then
		echo "4"
	elif [[ "${a}" == "3" ]] ; then
		echo "5"
	elif [[ "${a}" == "4" ]] ; then
		echo "5"
	elif [[ "${a}" == "fast" ]] ; then
		echo "6"
	fi
}

# @FUNCTION: _cflags-depends_is_eq
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_eq() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -eq "${b}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: _cflags-depends_is_ne
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_ne() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -ne "${b}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: _cflags-depends_is_lt
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_lt() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -lt "${b}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: _cflags-depends_is_le
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_le() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -le "${b}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: _cflags-depends_is_gt
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_gt() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -gt "${b}" ]] ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: _cflags-depends_is_ge
# @INTERNAL
# @DESCRIPTION:
_cflags-depends_is_ge() {
	local a="${1}"
	local b="${2}"

	a="${a/-}"
	b="${b/-}"

	a="${a/O}"
	b="${b/O}"

	a=$(_cflags-depends_weigh "${a}")
	b=$(_cflags-depends_weigh "${b}")

	if [[ "${a}" -ge "${b}" ]] ; then
		return 0
	else
		return 1
	fi
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

# @FUNCTION: _cflags-depends_error_msg
# @DESCRIPTION:
# Show the error message
_cflags-depends_error_msg(){
eerror
eerror "Recompile ${p} with ${op} ${b}"
eerror
			die
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
		local a=$(_cflags-depends_get_last_oflag "${p}")
		local t="${CFLAGS_RDEPEND[${p}]}"
		local op="${t%;*}"
		local b="${t#*;}"
einfo "Actual oflag:\t   ${a} (${p})"
einfo "Required oflag:\t${op} ${b} (${p})"
		if [[ "${op}" == "!=" ]] ; then
			if _cflags-depends_is_ne "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		elif [[ "${op}" == "<" ]] ; then
			if _cflags-depends_is_lt "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		elif [[ "${op}" == "<=" ]] ; then
			if _cflags-depends_is_le "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		elif [[ "${op}" == "==" ]] ; then
			if _cflags-depends_is_eq "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		elif [[ "${op}" == ">" ]] ; then
			if _cflags-depends_is_gt "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		elif [[ "${op}" == ">=" ]] ; then
			if _cflags-depends_is_ge "${a}" "${b}" ; then
				:;
			else
				_cflags-depends_error_msg
			fi
		fi
	done
}
