# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cython.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Setup cython
# @DESCRIPTION:
# This eclass sets up cython for parallel builds.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CYTHON_ECLASS} ]] ; then
_CYTHON_ECLASS=1

SUPPORTED_CYTHON_SLOTS=(
	"0.98"
	"3.0"
	"3.1"
)

# @FUNCTION: cython_python_configure
# @DESCRIPTION:
# Configure paths for running multislot cython.
#
# python_configure() {
#   cython_python_configure
# }
#
#
cython_python_configure() {
	if [[ -z "${CYTHON_SLOT}" ]] ; then
eerror "CYTHON_SLOT needs to be set before inherit cython"
		die
	fi

	# Sanitize/isolate first
	export LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")
	export PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/$(get_libdir):${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
}

fi
