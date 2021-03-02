# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: urho3d.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: urho3d multibuild helper
# @DESCRIPTION:
# The urho3d eclass helps build both static and shared.

inherit multibuild

# @ECLASS-VARIABLE: _URHO3D_IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the urho3d-multibuild context
_URHO3D_IMPLS="android native rpi web"
IUSE+=" ${_URHO3D_IMPLS}"
REQUIRED_USE="|| ( ${_URHO3D_IMPLS} )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EURHO3D contains the implementination of urho3d to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_urho3d_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EURHO3D="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}" >/dev/null

	# run it
	"${@}"
}

# @FUNCTION: urho3d_foreach_impl
# @DESCRIPTION:  This will execute a callback for each urho3d implementation
urho3d_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_urho3d_obtain_impls

	multibuild_foreach_variant _urho3d_multibuild_wrapper "${@}"
}

# @FUNCTION: urho3d_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
urho3d_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_urho3d_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _urho3d_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_urho3d_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_URHO3D_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
