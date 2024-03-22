# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: aocc.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for aocc compiler compatibility
# @DESCRIPTION:
# Eclass to allow aocc.

# @ECLASS_VARIABLE: AOCC_COMPAT
# @DESCRIPTION:
# List of llvm slots compatibile with the package.
# AOCC_COMPAT=( 14 16 )

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_AOCC_ECLASS} ]]; then
_AOCC_ECLASS=1

# @FUNCTION: _aocc_is_slot_compat
# @DESCRIPTION:
# Finds wanted slot in AOCC_COMPAT
_aocc_is_slot_compat() {
	local wanted_slot="${1}"
	local s
	for s in ${AOCC_COMPAT[@]} ; do
		if [[ "${wanted_slot}" == "${s}" ]] ; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION: _aocc_set_globals
# @DESCRIPTION:
# Init global variables
_aocc_set_globals() {
	if [[ -z "${AOCC_COMPAT[@]}" ]] ; then
eerror "AOCC_COMPAT must be defined"
		die
	fi

	IUSE+="
		aocc
	"
	BDEPEND+="
		aocc? (
			|| (
	"
	if _aocc_is_slot_compat "16" ; then
		BDEPEND+="
			~sys-devel/aocc-4.2.0
			~sys-devel/aocc-4.1.0
		"
	elif _aocc_is_slot_compat "14" ; then
		BDEPEND+="
			~sys-devel/aocc-4.0.0
		"
	fi
	BDEPEND+="
			)
		)
	"
}
_aocc_set_globals
unset -f _aocc_set_globals

# @FUNCTION: aocc_pkg_setup
# @DESCRIPTION:
# Setup the path for aocc
aocc_pkg_setup() {
	if use aocc ; then
		local llvm_slot
		if has_version "~sys-devel/aocc-4.2.0" ; then
			llvm_slot=16
		elif has_version "~sys-devel/aocc-4.1.0" ; then
			llvm_slot=16
		elif has_version "~sys-devel/aocc-4.0.0" ; then
			llvm_slot=14
		fi

		# The system llvm path is deleted.
einfo "PATH:  ${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/opt/aocc/${llvm_slot}/bin|g")
einfo "PATH:  ${PATH} (after)"
	fi
}

# @FUNCTION: aocc_src_configure
# @DESCRIPTION:
# Setup environment to use the aocc compiler
aocc_src_configure() {
	if use aocc ; then
		local llvm_slot
		if _aocc_is_slot_compat "16" && has_version "~sys-devel/aocc-4.2.0" ; then
			llvm_slot=16
		elif _aocc_is_slot_compat "16" && has_version "~sys-devel/aocc-4.1.0" ; then
			llvm_slot=16
		elif _aocc_is_slot_compat "14" && has_version "~sys-devel/aocc-4.0.0" ; then
			llvm_slot=14
		fi
		AOCC_ROOT="/opt/aocc/${llvm_slot}"
		if [[ "${ABI}" == "amd64" ]] ; then
			export LD_LIBRARY_PATH="${AOCC_ROOT}/lib/:${AOCC_ROOT}/lib:${LD_LIBRARY_PATH}"
		elif [[ "${ABI}" == "x86" ]] ; then
			export LD_LIBRARY_PATH="${AOCC_ROOT}/lib/:${AOCC_ROOT}/lib32:${LD_LIBRARY_PATH}"
		else
eerror "ABI=${ABI} not supported"
			die
		fi
		# It breaks when doing linking.
		filter-flags '-m32' '-m64' '-mabi*'
		local cflags_abi="CFLAGS_${ABI}"
		export CC="clang ${!cflags_abi}"
		export CXX="clang++ ${!cflags_abi}"
		export CPP="${CXX} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		${CC} --version || die
	fi
}

fi
