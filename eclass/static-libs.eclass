# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: static-libs.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: static-libs multibuild helper
# @DESCRIPTION:
# The static-libs eclass helps build both static and shared.

inherit multibuild

# @ECLASS-VARIABLE: _IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the static-libs-multibuild context
_IMPLS="static-libs shared-libs"
IUSE+=" static-libs +shared-libs"
REQUIRED_USE+=" || ( static-libs shared-libs ) shared-libs"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# ECMAKE_LIB_TYPE contains the implementination of static-libs to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_static-libs_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	ECMAKE_LIB_TYPE="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: static-libs_foreach_impl
# @DESCRIPTION:  This will execute a callback for each static-libs implementation
static-libs_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_static-libs_obtain_impls

	multibuild_foreach_variant _static-libs_multibuild_wrapper "${@}"
}

# @FUNCTION: static-libs_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
static-libs_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_static-libs_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _static-libs_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_static-libs_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
