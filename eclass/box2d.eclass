# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: box2d.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: box2d multibuild helper
# @DESCRIPTION:
# The box2d eclass helps build both static and shared.

inherit multibuild

# @ECLASS-VARIABLE: _IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the box2d-multibuild context
_IMPLS="static shared"
IUSE+=" ${_IMPLS}"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EBOX2D contains the implementination of box2d to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_box2d_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EBOX2D="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: box2d_foreach_impl
# @DESCRIPTION:  This will execute a callback for each box2d implementation
box2d_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_box2d_obtain_impls

	multibuild_foreach_variant _box2d_multibuild_wrapper "${@}"
}

# @FUNCTION: box2d_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
box2d_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_box2d_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _box2d_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_box2d_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
