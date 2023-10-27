#!/bin/bash

# Converts cargo.lock to a format used by CRATES variable used by the cargo.eclass.
# cargo-ebuild is broken

CATEGORY="media-plugins"
PN="gst-plugins-rs"
PV="${1}" # left
MY_PV="${2}" # right

# - has ambiguous means
declare -A CARGO_PATHS=(
	[cairo-rs]="gtk-rs-core-%commit%/cairo"
	[cairo-sys-rs]="gtk-rs-core-%commit%/cairo/sys"
	[ffv1]="ffv1-%commit%"
	[flavors]="flavors-%commit%"
	[gdk-pixbuf-sys]="gtk-rs-core-%commit%/gdk-pixbuf/sys"
	[gdk-pixbuf]="gtk-rs-core-%commit%/gdk-pixbuf"
	[gdk4-sys]="gtk4-rs-%commit%/gdk4/sys"
	[gdk4-wayland-sys]="gtk4-rs-%commit%/gdk4-wayland/sys"
	[gdk4-wayland]="gtk4-rs-%commit%/gdk4-wayland"
	[gdk4-x11-sys]="gtk4-rs-%commit%/gdk4-x11/sys"
	[gdk4-x11]="gtk4-rs-%commit%/gdk4-x11"
	[gdk4]="gtk4-rs-%commit%/gdk4"
	[gio-sys]="gtk-rs-core-%commit%/gio/sys"
	[gio]="gtk-rs-core-%commit%/gio"
	[glib]="gtk-rs-core-%commit%/glib"
	[glib-macros-sys]="gtk-rs-core-%commit%/glib-macros/sys"
	[glib-macros]="gtk-rs-core-%commit%/glib-macros"
	[glib-sys]="gtk-rs-core-%commit%/glib/sys"
	[gobject-sys]="gtk-rs-core-%commit%/glib/gobject-sys"
	[graphene-sys]="gtk-rs-core-%commit%/graphene/sys"
	[graphene-rs]="gtk-rs-core-%commit%/graphene"
	[gstreamer-app-sys]="gstreamer-rs-%commit%/gstreamer-app/sys"
	[gstreamer-app]="gstreamer-rs-%commit%/gstreamer-app"
	[gstreamer-audio-sys]="gstreamer-rs-%commit%/gstreamer-audio/sys"
	[gstreamer-audio]="gstreamer-rs-%commit%/gstreamer-audio"
	[gstreamer-base-sys]="gstreamer-rs-%commit%/gstreamer-base/sys"
	[gstreamer-base]="gstreamer-rs-%commit%/gstreamer-base"
	[gstreamer-check-sys]="gstreamer-rs-%commit%/gstreamer-check/sys"
	[gstreamer-check]="gstreamer-rs-%commit%/gstreamer-check"
	[gstreamer-gl-egl-sys]="gstreamer-rs-%commit%/gstreamer-gl/egl/sys"
	[gstreamer-gl-egl]="gstreamer-rs-%commit%/gstreamer-gl/egl"
	[gstreamer-gl-sys]="gstreamer-rs-%commit%/gstreamer-gl/sys"
	[gstreamer-gl-wayland-sys]="gstreamer-rs-%commit%/gstreamer-gl/wayland/sys"
	[gstreamer-gl-wayland]="gstreamer-rs-%commit%/gstreamer-gl/wayland"
	[gstreamer-gl-x11-sys]="gstreamer-rs-%commit%/gstreamer-gl/x11/sys"
	[gstreamer-gl-x11]="gstreamer-rs-%commit%/gstreamer-gl/x11"
	[gstreamer-gl]="gstreamer-rs-%commit%/gstreamer-gl"
	[gstreamer-net-sys]="gstreamer-rs-%commit%/gstreamer-net/sys"
	[gstreamer-net]="gstreamer-rs-%commit%/gstreamer-net"
	[gstreamer-pbutils-sys]="gstreamer-rs-%commit%/gstreamer-pbutils/sys"
	[gstreamer-pbutils]="gstreamer-rs-%commit%/gstreamer-pbutils"
	[gstreamer-rtp-sys]="gstreamer-rs-%commit%/gstreamer-rtp/sys"
	[gstreamer-rtp]="gstreamer-rs-%commit%/gstreamer-rtp"
	[gstreamer-sdp-sys]="gstreamer-rs-%commit%/gstreamer-sdp/sys"
	[gstreamer-sdp]="gstreamer-rs-%commit%/gstreamer-sdp"
	[gstreamer-sys]="gstreamer-rs-%commit%/gstreamer/sys"
	[gstreamer-utils]="gstreamer-rs-%commit%/gstreamer-utils"
	[gstreamer-video-sys]="gstreamer-rs-%commit%/gstreamer-video/sys"
	[gstreamer-video]="gstreamer-rs-%commit%/gstreamer-video"
	[gstreamer-webrtc-sys]="gstreamer-rs-%commit%/gstreamer-webrtc/sys"
	[gstreamer-webrtc]="gstreamer-rs-%commit%/gstreamer-webrtc"
	[gstreamer]="gstreamer-rs-%commit%/gstreamer"
	[gsk4-sys]="gtk4-rs-%commit%/gsk4/sys"
	[gsk4]="gtk4-rs-%commit%/gsk4"
	[gtk4-macros]="gtk4-rs-%commit%/gtk4-macros"
	[gtk4-sys]="gtk4-rs-%commit%/gtk4/sys"
	[gtk4]="gtk4-rs-%commit%/gtk4"
	[pango-sys]="gtk-rs-core-%commit%/pango/sys"
	[pango]="gtk-rs-core-%commit%/pango"
	[pangocairo-sys]="gtk-rs-core-%commit%/pangocairo/sys"
	[pangocairo]="gtk-rs-core-%commit%/pangocairo"
)

main() {
	unset IFS
	local l

	csplit \
		--quiet \
		--prefix=gst-plugins-rs-config \
		--suffix-format=%02d.txt  \
		/var/tmp/portage/${CATEGORY}/${PN}-${PV}/work/${PN}-${MY_PV}/Cargo.lock \
		/^$/ \
		{*}

	echo "Done splitting"

	local NL=$(grep -v -l -F "git+" gst-plugins-rs-config*.txt)
	local L=$(grep -l -F "git+" gst-plugins-rs-config*.txt)

	local s_live=""
	local s_nlive=""
	local live_packages=()

	# live (GIT_CRATES)
	local L=$(grep -l -F "git+" gst-plugins-rs-config*.txt)
	for l in ${L[@]} ; do
		local name=$(grep "name = " ${l} \
			| cut -f 2 -d '"')
		local version=$(grep "version = " ${l} \
			| cut -f 2 -d '"')
		local source=$(grep "source = " ${l} \
			| cut -f 2 -d '"' \
			| sed -r \
				-e "s|git[+]||g" \
				-e "s|[?]branch=[a-zA-Z0-9.]+||" \
				-e "s|#|;|g" \
				-e "s|[?]rev=[a-zA-Z0-9]{0,40}||" \
				-e "s|\.git||")
		[[ -z "${version}" ]] && continue
		cargo_path="${CARGO_PATHS[${name}]}"
		s_live+="[${name}]=\"${source};${cargo_path}\" # ${version}\n"
		live_packages+=("${name}")
	done

	# non-live (CRATES)
	for l in ${NL[@]} ; do
		local name=$(grep "name = " ${l} | cut -f 2 -d '"')
		local version=$(grep "version = " ${l} | cut -f 2 -d '"')

		local is_live=0
		local x
		for x in ${live_packages[@]} ; do
			if [[ "${x}" == "${name}" ]] ; then
				is_live=1
			fi
		done

		[[ "${name}" =~ "gst-plugin-" ]] && continue # internal
		[[ -z "${name}" ]] && continue
		[[ "${is_live}" == "1" ]] && continue
		s_nlive+="${name}-${version}\n"
	done

	echo
	echo "Live:"
	echo
	echo -e "${s_live}" | sort

	echo
	echo "Non-live:"
	echo
	echo -e "${s_nlive}" | sort

	echo ""

	rm gst-plugins-rs-config*.txt
}

main
