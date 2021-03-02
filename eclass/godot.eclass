# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: godot.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: godot multibuild helper
# @DESCRIPTION:
# The godot eclass helps isolate the builds for server and X client.

inherit multibuild

# @ECLASS-VARIABLE: _GODOT_IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the godot-multibuild context
_GODOT_IMPLS="X server"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EGODOT contains the implementination of godot to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_godot_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EGODOT="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: godot_foreach_impl
# @DESCRIPTION:  This will execute a callback for each godot implementation
godot_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_godot_obtain_impls

	multibuild_foreach_variant _godot_multibuild_wrapper "${@}"
}

# @FUNCTION: godot_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
godot_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_godot_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _godot_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_godot_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_GODOT_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
