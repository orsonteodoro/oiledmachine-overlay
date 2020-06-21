# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: enigma.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: enigma multibuild helper
# @DESCRIPTION:
# The enigma eclass helps build both static and shared.

inherit multibuild

# @ECLASS-VARIABLE: _IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the enigma-multibuild context
_IMPLS="vanilla android linux wine"
IUSE+=" ${_IMPLS}"
REQUIRED_USE="|| ( ${_IMPLS} )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EENIGMA contains the implementination of enigma to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_enigma_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EENIGMA="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}" >/dev/null

	# run it
	"${@}"
}

# @FUNCTION: enigma_foreach_impl
# @DESCRIPTION:  This will execute a callback for each enigma implementation
enigma_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_enigma_obtain_impls

	multibuild_foreach_variant _enigma_multibuild_wrapper "${@}"
}

# @FUNCTION: enigma_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
enigma_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_enigma_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _enigma_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_enigma_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
