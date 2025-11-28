# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  ffmpeg.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot ffmpeg config for build systems
# @DESCRIPTION:
# Helpers to support multislot FFmpeg.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FFMPEG_ECLASS} ]] ; then
_FFMPEG_ECLASS=1

FFMPEG_COMPAT_SLOTS_4=(
	"56.58.58"
)

FFMPEG_COMPAT_SLOTS_5=(
	"57.59.59"
)

FFMPEG_COMPAT_SLOTS_6=(
	"58.60.60"
)

FFMPEG_COMPAT_SLOTS_7=(
	"59.61.61"
)

FFMPEG_COMPAT_SLOTS_8=(
	"60.62.62"
)

FFMPEG_COMPAT_SLOTS_ALL=(
	"60.62.62" # 8
	"59.61.61" # 7
	"58.60.60" # 6
	"57.59.59" # 5
	"56.58.58" # 4
)

inherit flag-o-matic

# @FUNCTION:  ffmpeg_src_configure
# @DESCRIPTION:
# Update all flags for C/C++ for autotools or meson based projects.
#
# Example:
#
# inherit ffmpeg
#
# FFMPEG_COMPAT_SLOTS=( "${FFMPEG_COMPAT_SLOTS_4[@]}" ) # After inherit ffmpeg to init array
# FFMPEG_LINK_MODE="direct"
#
# src_configure() {
#   ffmpeg_src_configure
# }
#
ffmpeg_src_configure() {
	local _FFMPEG_SLOT=""

	if [[ -z "${FFMPEG_COMPAT_SLOTS[@]}" ]] ; then
eerror "QA:  FFMPEG_COMPAT_SLOTS must be defined."
		die
	fi

	local x
	for x in "${FFMPEG_COMPAT_SLOTS[@]}" ; do
		if has_version "media-video/ffmpeg:${x}" ; then
			_FFMPEG_SLOT="${x}"
			break
		fi
	done

	if [[ -z "${_FFMPEG_SLOT}" ]] ; then
eerror "No multislot FFmpeg found.  Using monoslot FFmpeg."
		return
	fi

	local libdir=$(get_libdir)

	# Sanitize/isolate multiabi pollution from logs
	filter-flags \
		"-I/usr/lib/ffmpeg/*/include" \
		"-Wl,-L/usr/lib/ffmpeg/*" \
		"-Wl,-rpath,/usr/lib/ffmpeg/*" \
		"-L/usr/lib/ffmpeg/*" \
		"--rpath,/usr/lib/ffmpeg/*"

	append-flags "-I/usr/lib/ffmpeg/${_FFMPEG_SLOT}/include"

	# For manual configuration or sed patch
	if [[ ${FFMPEG_LINK_MODE:-"indirect"} == "indirect" ]] ; then
		# For manual configuration or sed patch
		export FFMPEG_CFLAGS="-I/usr/lib/ffmpeg/${_FFMPEG_SLOT}/include"
		export FFMPEG_CXXFLAGS="${FFMPEG_CXXFLAGS}"
		export FFMPEG_LDFLAGS="-Wl,-L/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir} -Wl,-rpath,/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}"

		append-ldflags \
			"-Wl,-L/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}" \
			"-Wl,-rpath,/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}"
	else
		export FFMPEG_CFLAGS="-I/usr/lib/ffmpeg/${_FFMPEG_SLOT}/include"
		export FFMPEG_CXXFLAGS="${FFMPEG_CXXFLAGS}"
		export FFMPEG_LDFLAGS="-L/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir} --rpath=/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}"

		append-ldflags \
			"-L/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}" \
			"--rpath=/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}"
	fi

	# Sanitize/isolate
	LD_LIBRARY_PATH=$(echo "${LD_LIBRARY_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/ffmpeg/|d" | tr $'\n' ":")
	PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/ffmpeg/|d" | tr $'\n' ":")
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/ffmpeg/|d" | tr $'\n' ":")

	export LD_LIBRARY_PATH="${ESYSROOT}/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}/pkgconfig:${LD_LIBRARY_PATH}"
	export PATH="${ESYSROOT}/usr/lib/ffmpeg/${_FFMPEG_SLOT}/bin:${PATH}"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/ffmpeg/${_FFMPEG_SLOT}/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"

}

# @FUNCTION:  ffmpeg_python_configure
# @DESCRIPTION:
# Alias for ebuild style consistency
#
# Example:
#
# inherit ffmpeg
#
# FFMPEG_COMPAT_SLOTS=( "${FFMPEG_COMPAT_SLOTS_4[@]}" ) # After inherit ffmpeg to init array
# FFMPEG_LINK_MODE="direct"
#
# python_configure() {
#   # For auto adding:
#   # C/C++ include headers
#   # LD linker flags
#   # RPATH correction to find multislotted dynamic libraries
#   ffmpeg_src_configure
# }
#
ffmpeg_python_configure() {
	ffmpeg_src_configure
}

fi
