# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mutex-test-release.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: mutex-test-release multibuild helper
# @DESCRIPTION:
# The mutex-test-release eclass helps build for cases where the test build seems
# mutually exclusive from the release version.  This ebuild allows to build
# both in one emerge pass instead by splitting the test and release and
# installing only the release.  The test build will have more relaxed constants
# or static build constants (e.g. prefix to ${D}/usr).  Release will have the
# expected prefixes to /usr.

inherit multibuild

# @ECLASS-VARIABLE: EMTR
# @DESCRIPTION: (Public) Generates a list of implementations for the mutex-test-release-multibuild context

# @ECLASS-VARIABLE: EMTR_ALLOW_TEST_RELEASE
# @DESCRIPTION: (Public) Allows to run test with the release USE flag.  Default 0.  Set to 1 to allow release to call src_test callback.
EMTR_ALLOW_TEST_RELEASE=${EMTR_ALLOW_TEST_RELEASE:=0}

IUSE+=" ${EMTRS} +release"
REQUIRED_USE="|| ( ${EMTRS} ) release"

# @FUNCTION: _mutex-test-release_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EMTR contains the implementination of mutex-test-release to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_mutex-test-release_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EMTR="${MULTIBUILD_VARIANT}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	cd "${BUILD_DIR}" 2>/dev/null

	einfo "The current working directory is "$(pwd)

	if [[ ${EBUILD_PHASE} =~ "inst" && "${EMTR}" == "test" ]] ; then
		einfo "Skipping ${EBUILD_PHASE} for ${EMTR}"
		return
	fi

	if [[ ${EBUILD_PHASE} =~ "test" \
		&& "${EMTR}" == "release" \
		&& "${EMTR_ALLOW_RELEASE}" != "1" ]] ; then
		einfo "Skipping ${EBUILD_PHASE} for ${EMTR}"
		return
	fi

	# run the user supplied function
	"${@}"
}

# @FUNCTION: mutex-test-release_foreach_impl
# @DESCRIPTION:  This will execute a callback for each mutex-test-release implementation
mutex-test-release_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_mutex-test-release_obtain_impls

	multibuild_foreach_variant _mutex-test-release_multibuild_wrapper "${@}"
}

# @FUNCTION: mutex-test-release_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
mutex-test-release_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_mutex-test-release_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _mutex-test-release_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_mutex-test-release_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${EMTRS} ; do
		use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}
