# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-tw.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: twiddle-wakka
# @DESCRIPTION:
# Support for twiddle-wakka versioning for ruby ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: RUBY_TW_DISABLE
# @DESCRIPTION:
# Setting to 1 to convert ~> to >=
# Set to 0 to use ~> twiddle-wakka

# @FUNCTION: __tw2
# @INTERNAL
# @DESCRIPTION:
# Generate conditional for case for 2 . separators
__tw2(){
	local cn="${1}"
	local pv="${2}"
	echo "
		(
			>=${cn}-${pv}
			<${cn}-$(ver_cut 1 ${pv}).$(( $(ver_cut 2 ${pv}) + 1 ))
		)
	"
}
# @FUNCTION: __tw1
# @INTERNAL
# @DESCRIPTION:
# Generate conditional for case for 1 . separators
__tw1(){
	local cn="${1}"
	local pv="${2}"
	echo "
		(
			>=${cn}-${pv}
			<${cn}-$(( $(ver_cut 1 ${pv}) + 1 ))
		)
	"
}

# @FUNCTION: __tw_nseparators
# @INTERNAL
# @DESCRIPTION:
# Count dot separators
__tw_nseparators() {
	local s="${pv}"
	local i
	local n=0
	for (( i=0 ; i < ${#s} ; i=( $i + 1 ) )) ; do
		local c="${s:$i:1}"
		[[ "${c}" == "." ]] && n=$(($n+1))
	done
	echo ${n}
}

# @FUNCTION: __tw_off
# @INTERNAL
# @DESCRIPTION:
# Generates >= in place of ~>
__tw_off() {
	local pn="${1}"
	local pv="${2}"
	echo ">=${pn}-${pv}"
}


# @FUNCTION: __tw_on
# @INTERNAL
# @DESCRIPTION:
# Generates a conditonal for twiddle-wakkaed entries.
__tw_on() {
	local cn="${1}"
	local pv="${2}"
	local n=$(__tw_nseparators "${pv}")
	if (( ${n} == 2 )) ; then
		__tw2 "${cn}" "${pv}"
	elif (( ${n} == 1 || ${n} == 0 )) ; then
		__tw1 "${cn}" "${pv}"
	else
		die "Undefined twiddle-wakka case.  num_dot_separators=${n}"
	fi
}

# @FUNCTION: tw
# @DESCRIPTION:
# Generates a conditonal for twiddle-wakkaed entries.
#
# Examples:
# ruby_add_rdepend "
#   $(tw dev-ruby/foo 1.0) # Same as ~>dev-ruby/foo-1.0
#   $(tw dev-ruby/bar 1.0.1) # Same as ~>dev-ruby/bar-1.0.1
# "
#
tw() {
	local cn="${1}"
	local pv="${2}"
	if [[ "${RUBY_TW_DISABLE}" == "1" ]] ; then
		__tw_off "${cn}" "${pv}"
	else
		__tw_on "${cn}" "${pv}"
	fi
}
