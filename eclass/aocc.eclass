# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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

inherit flag-o-matic

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
	elif _aocc_is_slot_compat "13" ; then
		BDEPEND+="
			~sys-devel/aocc-3.2.0
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
		if [[ -n "${AOCC_SLOT}" ]] ; then
			llvm_slot="${AOCC_SLOT}"
		elif has_version "~sys-devel/aocc-4.2.0" ; then
			llvm_slot=16
			AOCC_SLOT=16
		elif has_version "~sys-devel/aocc-4.1.0" ; then
			llvm_slot=16
			AOCC_SLOT=16
		elif has_version "~sys-devel/aocc-4.0.0" ; then
			llvm_slot=14
			AOCC_SLOT=14
		fi

		# The system llvm path is deleted.
einfo "PATH:  ${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/opt/aocc/${llvm_slot}/bin|g")
einfo "PATH:  ${PATH} (after)"

		if [[ -z "${AOCC_SLOT}" ]] ; then
eerror
eerror "QA:  AOCC_SLOT needs to be defined."
eerror
			die
		fi
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
			export LD_LIBRARY_PATH="${AOCC_ROOT}/lib/:${LD_LIBRARY_PATH}"
		elif [[ "${ABI}" == "x86" ]] ; then
			export LD_LIBRARY_PATH="${AOCC_ROOT}/lib32:${LD_LIBRARY_PATH}"
		else
eerror "ABI=${ABI} is not supported"
			die
		fi
		# It breaks when doing linking.
		filter-flags '-m32' '-m64' '-mabi*'
		local cflags_abi="CFLAGS_${ABI}"
		export CC="clang ${!cflags_abi}"
		export CXX="clang++ ${!cflags_abi}"
		export CPP="${CC} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		${CC} --version || die
		strip-unsupported-flags
	fi
}

# @FUNCTION: aocc_get_libdir
# @DESCRIPTION:
# Prints out the corresponding lib folder matchin the ABI.
aocc_get_libdir() {
	if [[ "${_ABI}" == "amd64" ]] ; then
		echo "lib"
	elif [[ "${_ABI}" == "x86" ]] ; then
		echo "lib32"
	else
eerror "ABI=${ABI} is not supported."
		die
	fi
}

# @FUNCTION: aocc_fix_rpath
# @DESCRIPTION:
# Fix issue of selecting the wrong libomp or toolchain libs
aocc_fix_rpath() {
	use aocc || return
	IFS=$'\n'
	local aocc_libs=(
	)
	local llvm_libs=(
		"libflang.so"
		"libflangrti.so"
		"libLLVMCore.so"
		"libLLVMFrontendOpenMP.so"
		"libLLVMOption.so"
		"libLLVMSupport.so"
	)
	local clang_libs=(
		"libclangBasic.so"
	)
	local libomp_libs=(
		"libomp.so"
	)
	local l
	local path
	for path in $(find "${ED}" -type f) ; do
		local is_exe=0
		local is_so=0
		if file "${path}" | grep -q "shared object" ; then
			is_so=1
		elif file "${path}" | grep -q "ELF.*executable" ; then
			is_exe=1
		elif file "${path}" | grep -q "symbolic link" ; then
			continue
		fi

		local _ABI
		if file "${path}" | grep -q "32-bit" && file "${file}" | grep -q "x86-64" ; then
			local _ABI="x32"
		elif file "${path}" | grep -q "x86-64" ; then
			local _ABI="amd64"
		elif file "${path}" | grep -q "80386" ; then
			local _ABI="x86"
		else
			continue
		fi

		local needs_rpath_patch_aocc=0
		local needs_rpath_patch_clang=0
		local needs_rpath_patch_libomp=0
		local needs_rpath_patch_llvm=0
		if (( ${is_so} || ${is_exe} )) ; then
			for l in "${aocc_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						needs_rpath_patch_aocc=1
					fi
				fi
			done


			for l in "${llvm_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						needs_rpath_patch_llvm=1
					fi
				fi
			done

			for l in "${clang_libs[@]}" ; do
			if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						needs_rpath_patch_clang=1
					fi
				fi
			done

			for l in "${libomp_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						needs_rpath_patch_libomp=1
					fi
				fi
			done
		fi

		AOCC_PATH="/opt/aocc/${AOCC_SLOT}"
		if (( ${needs_rpath_patch_aocc} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${AOCC_PATH}/$(aocc_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${needs_rpath_patch_clang} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${AOCC_PATH}/$(aocc_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${needs_rpath_patch_llvm} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${AOCC_PATH}/$(aocc_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${needs_rpath_patch_libomp} )) ; then
einfo "Fixing rpath for ${path}"
			patchelf \
				--add-rpath "${EPREFIX}${AOCC_PATH}/$(aocc_get_libdir)" \
				"${path}" \
				|| die
		fi

		if (( ${is_so} || ${is_exe} )) && ldd "${path}" 2>/dev/null | grep -q "not found" ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			fi
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: aocc_verify_rpath_correctness
# @DESCRIPTION:
# Check if selecting the wrong libomp or toolchain libs
aocc_verify_rpath_correctness() {
	use aocc || return
	local source
	if [[ -z "${AOCC_RPATH_SCAN_FOLDER}" ]] ; then
		source="${ED}"
	else
		source="${AOCC_RPATH_SCAN_FOLDER}"
	fi
	IFS=$'\n'
	local aocc_libs=(
	)
	local llvm_libs=(
		"libflang.so"
		"libflangrti.so"
		"libLLVMCore.so"
		"libLLVMFrontendOpenMP.so"
		"libLLVMOption.so"
		"libLLVMSupport.so"
	)
	local clang_libs=(
		"libclangBasic.so"
	)
	local libomp_libs=(
		"libomp.so"
	)
	local l
	local path
	for path in $(find "${source}" -type f) ; do
		local is_exe=0
		local is_so=0
		if file "${path}" | grep -q "shared object" ; then
			is_so=1
		elif file "${path}" | grep -q "ELF.*executable" ; then
			is_exe=1
		elif file "${path}" | grep -q "symbolic link" ; then
			continue
		fi

		local _ABI
		if file "${path}" | grep -q "32-bit" && file "${file}" | grep -q "x86-64" ; then
			local _ABI="x32"
		elif file "${path}" | grep -q "x86-64" ; then
			local _ABI="amd64"
		elif file "${path}" | grep -q "80386" ; then
			local _ABI="x86"
		else
			continue
		fi

		local reason_aocc=""
		local reason_clang=""
		local reason_libomp=""
		local reason_llvm=""
		local needs_rpath_patch_aocc=0
		local needs_rpath_patch_clang=0
		local needs_rpath_patch_libomp=0
		local needs_rpath_patch_llvm=0
		if (( ${is_so} || ${is_exe} )) ; then
			for l in "${aocc_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						reason_aocc="${l}"
						needs_rpath_patch_aocc=1
					fi
				fi
			done

			for l in "${llvm_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						reason_llvm="${l}"
						needs_rpath_patch_llvm=1
					fi
				fi
			done

			for l in "${clang_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						reason_clang="${l}"
						needs_rpath_patch_clang=1
					fi
				fi
			done

			for l in "${libomp_libs[@]}" ; do
				if ldd "${path}" 2>/dev/null | grep -q "${l}" ; then
					if ldd "${path}" 2>/dev/null | grep "${l}" | grep -q "/aocc/" ; then
						:;
					else
						reason_libomp="${l}"
						needs_rpath_patch_libomp=1
					fi
				fi
			done
		fi

		if (( ${needs_rpath_patch_aocc} )) ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (aocc)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (aocc)"
			fi
		fi

		if (( ${needs_rpath_patch_llvm} )) ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (llvm)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (llvm)"
			fi
		fi

		if (( ${needs_rpath_patch_clang} )) ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (clang)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (clang)"
			fi
		fi

		if (( ${needs_rpath_patch_libomp} )) ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} (libomp)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} (libomp)"
			fi
		fi

		if (( ${is_so} || ${is_exe} )) && ldd "${path}" 2>/dev/null | grep -q "not found" ; then
			if [[ "${AOCC_RPATH_SCAN_FATAL}" == "1" ]] ; then
				# Use 1 in src_install
				die "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			else
				# Use 0 or unset in pkg_postinst
				ewarn "Q/A:  Missing rpath for ${path} ; Reason:  (not found)"
			fi
		fi
	done
	IFS=$' \t\n'
}

fi
