# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: flag-o-matic-om.eclass
# @MAINTAINER:
# orsonteodoro@hotmail.com
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Additional functions to flag-o-matic
# @DESCRIPTION:
# This eclass contains compiler flag conversion functions or
# functions to manage sanitizer options.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FLAG_O_MATIC_OM_ECLASS} ]]; then
_FLAG_O_MATIC_OM_ECLASS=1

inherit flag-o-matic

# @FUNCTION: translate_retpoline
# @DESCRIPTION:
# Translates retpoline flags in the best possible way between compilers.
translate_retpoline() {
	# Translation is necessary when package.env is a static list
	# It is preferred to do it in the compiler level.

	# mapping
	# clang				-- gcc
	# -mretpoline			~ -mindirect-branch=(thunk|thunk-inline)
	# -mretpoline-external-thunk	~ -mindirect-branch=thunk-extern

	# Filter/translate flags
	einfo "Auto translating retpoline flags"
	local f
	if tc-is-clang ; then
		local found=0
		for f in ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS ; do
			if [[ "${!f}" =~ "-mindirect-branch-register" ]]  ; then
				found=1
			fi
		done
		(( ${found} == 1 )) \
			&& ewarn "No direct translation for -mindirect-branch-register.  Removing."
		replace-flags -mindirect-branch=thunk -mretpoline
		replace-flags -mindirect-branch=thunk-inline -mretpoline
		filter-flags -mindirect-branch=keep
		filter-flags -mindirect-branch-register
		for f in ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS ; do
			if [[ "${!f}" =~ "-mindirect-branch=thunk-extern" ]]  ; then
				eerror
				eerror "-mindirect-branch=thunk-extern cannot be directly translated.  Remove"
				eerror "the flag and rename the flag and manually code this function."
				eerror
				die
			fi
		done
	fi
	if tc-is-gcc ; then
		replace-flags -mretpoline -mindirect-branch=thunk
		for f in ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS ; do
			if [[ "${!f}" =~ "-mretpoline-external-thunk" ]]  ; then
				eerror
				eerror "-mretpoline-external-thunk cannot be directly translated.  Remove the"
				eerror "flag and provide a custom preprocessor flag and possibly code changes."
				eerror
				die
			fi
		done
	fi
	export ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS
}

# It should belong in pkg_setup, but src_configure is fine
# @FUNCTION: autofix_flags
# @DESCRIPTION:
# Removes incompatible flags and translates flags.
autofix_flags() {
	translate_retpoline
	strip-unsupported-flags
}

# @FUNCTION: strip-flag-value
# @DESCRIPTION:
# Removes a value from an option for when the sanitizer option is known to cause
# failures.
#
# Example:
#
#   -fsanitize=cfi,asan -> -fsanitize=asan
#
strip-flag-value() {
	local value="${1}"
	for flag in ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS ; do
		local t=$(echo "${!flag}" \
			| sed  -r -e "s#(,|=)${value}#\1#g" \
			| sed -r -e "s|[,]+|,|g" \
			| sed -e "s|=,|=|g" \
			| sed -r -e "s#,( |$)#\1#g")
		: "${flag}"="${t}"
        done
	export ADAFLAGS CFLAGS CPPFLAGS CXXFLAGS CCASFLAGS FFLAGS FCFLAGS LDFLAGS
}

fi
