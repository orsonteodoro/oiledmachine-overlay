# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: platforms.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: platforms multibuild helper
# @DESCRIPTION:
# The platforms eclass helps build for multiple platforms.

inherit multibuild

# @ECLASS-VARIABLE: EPLATFORMS
# @DESCRIPTION: (Public) Generates a list of implementations for the platforms-multibuild context

IUSE+=" ${EPLATFORMS}"
REQUIRED_USE="|| ( ${EPLATFORMS} )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EPLATFORM contains the implementination of platforms to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_platforms_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EPLATFORM="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}" 2>/dev/null

	# run it
	"${@}"
}

# @FUNCTION: platforms_foreach_impl
# @DESCRIPTION:  This will execute a callback for each platforms implementation
platforms_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_platforms_obtain_impls

	multibuild_foreach_variant _platforms_multibuild_wrapper "${@}"
}

# @FUNCTION: platforms_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
platforms_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_platforms_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _platforms_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_platforms_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${EPLATFORMS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
