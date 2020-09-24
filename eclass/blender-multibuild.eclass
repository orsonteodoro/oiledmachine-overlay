# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-multibuild.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender multibuild helper
# @DESCRIPTION:
# The blender-multibuild.eclass helps build multiple configurations of blender.

inherit multibuild

# @ECLASS-VARIABLE: _IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the blender-multibuild context
_IMPLS="build_creator build_headless"
if [[ -n "${HAS_PLAYER}" && "${HAS_PLAYER}" == 1 ]] ; then
	_IMPLS+=" build_portable"
fi
IUSE+=" ${_IMPLS/build_creator/+build_creator}"
REQUIRED_USE+=" || ( ${IMPLS} )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EBLENDER contains the implementination of blender to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_blender_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EBLENDER="${MULTIBUILD_VARIANT}"
	EBLENDER_NAME="${MULTIBUILD_VARIANT#build_}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: blender_foreach_impl
# @DESCRIPTION:  This will execute a callback for each blender implementation
blender-multibuild_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_blender_obtain_impls

	multibuild_foreach_variant _blender_multibuild_wrapper "${@}"
}

# @FUNCTION: blender_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
blender-multibuild_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_blender_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _blender_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_blender_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
