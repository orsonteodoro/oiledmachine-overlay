# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xdg-utils-cxx.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: xdg-utils-cxx multibuild helper
# @DESCRIPTION:
# The xdg-utils-cxx eclass helps build both static and shared.

inherit multibuild

# @ECLASS-VARIABLE: _IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the xdg-utils-cxx-multibuild context
_IMPLS="static shared"
IUSE+=" static +shared"
REQUIRED_USE+=" || ( static shared )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EXDG_UTILS_CXX contains the implementination of xdg-utils-cxx to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_xdg-utils-cxx_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EXDG_UTILS_CXX="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: xdg-utils-cxx_foreach_impl
# @DESCRIPTION:  This will execute a callback for each xdg-utils-cxx implementation
xdg-utils-cxx_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_xdg-utils-cxx_obtain_impls

	multibuild_foreach_variant _xdg-utils-cxx_multibuild_wrapper "${@}"
}

# @FUNCTION: xdg-utils-cxx_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
xdg-utils-cxx_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_xdg-utils-cxx_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _xdg-utils-cxx_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_xdg-utils-cxx_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
