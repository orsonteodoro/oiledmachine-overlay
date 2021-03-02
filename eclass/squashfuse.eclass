# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: squashfuse.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: squashfuse multibuild helper
# @DESCRIPTION:
# The squashfuse eclass helps build both normal squashfuse and squashfuse modified for libappimage

inherit multibuild

# @ECLASS-VARIABLE: _SQUASHFUSE_IMPLS
# @DESCRIPTION: (Private) Generates a list of implementations for the squashfuse-multibuild context
_SQUASHFUSE_IMPLS="libsquashfuse-vanilla libsquashfuse-appimage"
IUSE+=" +libsquashfuse-vanilla libsquashfuse-appimage"
REQUIRED_USE+=" || ( ${_SQUASHFUSE_IMPLS} )"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# ESQUASHFUSE_TYPE contains the implementination of squashfuse to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_squashfuse_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	ESQUASHFUSE_TYPE="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}"

	# run it
	"${@}"
}

# @FUNCTION: squashfuse_foreach_impl
# @DESCRIPTION:  This will execute a callback for each squashfuse implementation
squashfuse_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_squashfuse_obtain_impls

	multibuild_foreach_variant _squashfuse_multibuild_wrapper "${@}"
}

# @FUNCTION: squashfuse_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
squashfuse_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_squashfuse_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _squashfuse_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_squashfuse_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_SQUASHFUSE_IMPLS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
