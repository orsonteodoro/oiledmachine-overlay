#/bin/bash
#
# Checks only dependency lists and options
#
# Usage:
# ./compare-point-releases.sh 2.38.2 2.38.3

PV1="${1}"
PV2="${2}"
main() {
	S_OLD="/var/tmp/portage/net-libs/webkit-gtk-${PV1}/work/webkitgtk-${PV1}"
	S_NEW="/var/tmp/portage/net-libs/webkit-gtk-${PV2}/work/webkitgtk-${PV2}"
	local P=(
		CMakeLists.txt
		Source/cmake/BubblewrapSandboxChecks.cmake
		Source/cmake/FindGStreamer.cmake
		Source/cmake/GStreamerChecks.cmake
		Source/cmake/OptionsGTK.cmake
		Source/cmake/WebKitCommon.cmake
		Tools/buildstream/elements/sdk-platform.bst
		Tools/buildstream/elements/sdk/gst-plugin-dav1d.bst
		Tools/gtk/install-dependencies
		Tools/gtk/dependencies
		Tools/glib/dependencies
	)
	for p in ${P[@]} ; do
		echo
		echo "Comparing ${p}:"
		C="${p}" D1="${S_OLD}" ; D2="${S_NEW}" ; diff  -urp "${D1}/${C}" "${D2}/${C}" # For individual comparisons
		echo
	done
}

main
