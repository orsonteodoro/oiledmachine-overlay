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

# @FUNCTION: cython_set_cython_slot
# @DESCRIPTION:
# Setup CYTHON_SLOT automatically based on major, major.minor, or rolling version.
#
# Examples
#
# python_configure() {
#	# Major version example
#	cython_set_cython_slot 3
#	cython_python_configure
# }
#
# python_configure() {
#	# Major.minor version example
#	cython_set_cython_slot 3.0
#	cython_python_configure
# }
#
# python_configure() {
#	# Rolling version example
#	cython_set_cython_slot
#	cython_python_configure
# }
#
cython_set_cython_slot() {
	local pv="${1}"
	local cython_slot
	if [[ -z "${version}" ]] ; then
		cython_slot=$(best_version "=dev-python/cython-${pv}*" | sed -e "s|dev-python/cython-||g")
	else
		cython_slot=$(best_version "dev-python/cython" | sed -e "s|dev-python/cython-||g")
	fi
	local cython_slot=$(best_version "dev-python/cython-${major_version}" | sed -e "s|dev-python/cython-||g")
	cython_slot=$(ver_cut "1-2" "${cython_slot}")
	export CYTHON_SLOT="${cython_slot}"
}

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
eerror "QA:  CYTHON_SLOT needs to be set before \`inherit cython\`."
		die
	fi

	if [[ -z "${EPYTHON}" ]] ; then
eerror "QA:  EPYTHON is not defined"
eerror "QA:  Call python-single_r1_pkg_setup or python_setup first"
		die
	fi
einfo "Setting up Cython ${CYTHON_SLOT} support for ${EPYTHON}"
	# Sanitize/isolate first
	export LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")
	export PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/cython|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/$(get_libdir):${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/bin:${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/lib/python-exec/${EPYTHON}:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
	which "cython" >/dev/null || die "Missing cython"
}

fi
