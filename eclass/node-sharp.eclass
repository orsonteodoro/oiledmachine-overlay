# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: node-sharp.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for the sharp node packages
# @DESCRIPTION:
# The node-sharp eclass is used to manage sharp in node packages.

# This eclass contains AI generated code.

# Security warning, if sharp is not added or built correctly it can cause a
# crash (aka DoS) during either build time or runtime.

# pnpm rebuild with sharp is not supported.  Switch package to npm for
# reproducibility.  sharp issue #4304

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_NODE_SHARP_ECLASS}" ]] ; then
_NODE_SHARP_ECLASS=1

CHKL_TIMESTAMPS+=(
	"media-libs/freetype-9999"
)

inherit chkl edo flag-o-matic secure-version secure-version-node

# Only latest supported for sharp and libvips security reasons.

# See also node-sharp_pkg_setup().
#
# We don't support the prebuilt vips because of security reasons.  The
# sharp-libvips repo does not backport security fixes from main/master branches.
# Many of the vendored libraries are missing security fixes.  It can be easily
# remediated like in the Chromium by using live snapshots.
#
# We don't use the prebuilt sharp because it builds for non-portable -march=nehalem
# <https://github.com/lovell/sharp-libvips/blob/v8.16.1/platforms/linux-x64/Dockerfile>
# and doesn't work on my machine.
#
# See also:
# https://github.com/lovell/sharp-libvips/blob/main/build/posix.sh
# https://github.com/lovell/sharp-libvips/blob/v1.3.2/versions.properties
#
if [[ -n "${NODE_SHARP_PV}" ]] ; then
	# Upstream uses lcms, but not forced on for security reasons for vips.
	NODE_SHARP_CDEPEND+="
		>=media-libs/vips-${VIPS_PV}:=[avif,cairo,cgif,cxx,dzi,exif,fontconfig,avif,heif,highway,imagequant,pango,png,svg,tiff,uhdr,webp,zlib]
		>=media-libs/freetype-${FREETYPE_PV}:=[harfbuzz]
		net-libs/nodejs:=
		|| (
			>=net-libs/nodejs-${NODEJS_22_PV}:22
			>=net-libs/nodejs-${NODEJS_24_PV}:24
		)
		elibc_glibc? (
			>=sys-libs/glibc-${GLIBC_PV}:=
		)
		elibc_musl? (
			>=sys-libs/musl-${MUSL_PV}:=
		)
	"
	RDEPEND+="
		${NODE_SHARP_CDEPEND}
	"
	DEPEND+="
		${NODE_SHARP_CDEPEND}
	"
	BDEPEND+="
		virtual/pkgconfig
		net-libs/nodejs:=
		|| (
			>=net-libs/nodejs-${NODEJS_22_PV}:22
			>=net-libs/nodejs-${NODEJS_24_PV}:24
		)
	"
fi

# Prebuilt vips is built with sse4.2 which breaks on older processors.
# Reference:  https://sharp.pixelplumbing.com/install#prebuilt-binaries
node-sharp_use_system_vips() {
	local arg=${1}
	if [[ "${arg}" == "1" ]] ; then
einfo "Sharp will be using the system's libvips"
		export SHARP_IGNORE_GLOBAL_LIBVIPS="false"
		export SHARP_FORCE_GLOBAL_LIBVIPS="true"
	else
ewarn "Sharp will be using sharp's vendored libvips"
		export SHARP_IGNORE_GLOBAL_LIBVIPS="true"
		export SHARP_FORCE_GLOBAL_LIBVIPS="false"
	fi
}

# @FUNCTION: node-sharp_pkg_setup
# @DESCRIPTION:
# Sets up the sharp build environment variables.
node-sharp_pkg_setup() {
	node-sharp_use_system_vips 1

	if ! pkg-config --modversion vips-cpp >/dev/null 2>&1 ; then
eerror "Failed detecting vips-cpp."
eerror "Rebuild media-libs/vips[avif,cairo,cgif,cxx,dzi,exif,fontconfig,avif,heif,highway,imagequant,lcms,pango,png,svg,tiff,uhdr,webp,zlib]."
		die
	fi

	if [[ -z "${NODE_SLOT}" ]] ; then
eerror "QA:  NODE_SLOT needs to be defined"
		die
	else
		export PATH="/usr/lib/node/${NODE_SLOT}/bin:${PATH}"
		local node_pv=$(node --version | sed -e "s|^v||g" || die)
einfo "Node version:  ${node_pv}"
	fi

	local libdir=$(get_libdir)
	local sharp_vips_pkgconfig="/usr/${libdir}/pkgconfig"
	local sharp_vips_lib="/usr/${libdir}"
	local sharp_vips_include="/usr/include"
	if [[ ":${PKG_CONFIG_PATH}:" != *":${sharp_vips_pkgconfig}:"* ]]; then
		export PKG_CONFIG_PATH="${sharp_vips_pkgconfig}:${PKG_CONFIG_PATH}"
	fi
	if [[ ":${LD_LIBRARY_PATH}:" != *":${sharp_vips_lib}:"* ]]; then
		export LD_LIBRARY_PATH="${sharp_vips_lib}:${LD_LIBRARY_PATH}"
	fi

	einfo "PKG_CONFIG_PATH set to: ${PKG_CONFIG_PATH}"
	einfo "LD_LIBRARY_PATH set to: ${LD_LIBRARY_PATH}"
	einfo "vips-cpp version:  "$(pkg-config --modversion vips-cpp || die "Failed to find vips-cpp.pc")
	einfo "vips-cpp libs:  "$(pkg-config --libs vips-cpp || die "Failed to find vips-cpp.pc libs")

	# Verify libvips-cpp.so exists
	if [[ ! -f "${sharp_vips_lib}/libvips-cpp.so" ]]; then
		die "libvips-cpp.so not found in ${sharp_vips_lib}"
	fi
	einfo "Found libvips-cpp.so in ${sharp_vips_lib}"

	export NODE_SHARP_LIB_PATH="${sharp_vips_lib}"
	export NODE_SHARP_INCLUDE_DIR="${sharp_vips_include}"
	export NODE_SHARP_PKG_CONFIG_DIR="${sharp_vips_lib}/pkgconfig"
	einfo "NODE_SHARP_LIB_PATH:  ${NODE_SHARP_LIB_PATH}"
	einfo "NODE_SHARP_INCLUDE_DIR:  ${NODE_SHARP_INCLUDE_DIR}"
	einfo "NODE_SHARP_PKG_CONFIG_DIR:  ${NODE_SHARP_PKG_CONFIG_DIR}"
}

node-sharp_append_includes() {
	filter-flags "-I/usr/include/glib-2.0"
	filter-flags "-I/usr/lib/glib-2.0/include"
	# For vips header
einfo "Adding glib-2.0 includes path to CPPFLAGS for glib-object.h for vips8"
	append-cppflags "-I/usr/include/glib-2.0"
einfo "Adding glib-2.0/include includes path to CPPFLAGS for glibconfig.h for glib/gtypes.h"
	append-cppflags "-I/usr/lib/glib-2.0/include"

}

# @FUNCTION: node-sharp_append_libs
# @DESCRIPTION:
# Appends required libs.  Allows for custom or minified builds by setting NODE_SHARP_USE.
node-sharp_append_libs() {
	local libdir=$(get_libdir)
	local sharp_vips_lib="/usr/${libdir}"
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH} (1)"
	local pkg_config_libs=$(pkg-config --libs vips-cpp glib-2.0 libxml2 libpng libjpeg-turbo tiff libwebp libheif libexif lcms2 aom cgif harfbuzz fontconfig cairo pango fribidi pixman-1 | sed 's/-l/ /g')
	local libs="\"${sharp_vips_lib}/libvips-cpp.so ${sharp_vips_lib}/libvips.so $(pkg-config --libs vips-cpp glib-2.0 libxml2 libpng libjpeg-turbo tiff libwebp libheif libexif lcms2 aom cgif harfbuzz fontconfig cairo pango fribidi pixman-1)\""
	einfo "Appending libraries to binding.gyp: ${libs}"
	sed -i \
		-e "s|\"libraries\": \[\],|\"libraries\": [ ${libs} ],|" \
		-e "s|\"include_dirs\": \[\],|\"include_dirs\": [ \"/usr/include\", \"$(pkg-config --cflags-only-I vips-cpp | sed 's/-I//g')\" ],|" \
		"${S}/node_modules/sharp/src/binding.gyp" \
		|| die "Failed to append libraries to binding.gyp"

	node-sharp_append_includes

	# Set PKG_CONFIG_PATH to use custom vips.pc
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH} (2)"
einfo "LD_LIBRARY_PATH:  ${LD_LIBRARY_PATH}"

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "LIBS:  ${LIBS}"
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
	unset LIBS
}

# @FUNCTION:  node-sharp_get_platform
# @DESCRIPTION:
# Gets the arch
node-sharp_get_platform() {
	if use kernel_linux ; then
		if [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "armv6" ]] ; then
			echo "linux-armv6"
		elif [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "aarch64" ]] ; then
			echo "linux-arm64v8"
		elif [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "powerpc64le" ]] ; then
			echo "linux-ppc64le"
		elif [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "riscv64" ]] ; then
			echo "linux-riscv64"
		elif [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "s390x" ]] ; then
			echo "linux-s390x"
		elif [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "x86_64" ]] ; then
			echo "linux-x64"

		elif [[ "${ELIBC}" == "musl" && "${CHOST}" =~ "x86_64" ]] ; then
			echo "linuxmusl-x64"
		elif [[ "${ELIBC}" == "musl" && "${CHOST}" =~ "aarch64" ]] ; then
			echo "linuxmusl-arm64v8"

		else
eerror "Unsupported ARCH=${ARCH} ELIBC=${ELIBC}"
			die
		fi
	else
eerror "The current Project Prefix is currently not supported."
		die
	fi
}

# @FUNCTION:  node-sharp_verify_loader_symbols
# @DESCRIPTION:
# Check loader symbols
node-sharp_verify_built_symbols() {
	if [[ -d "${S}/node_modules/sharp" ]]; then
		local sharp_platform=$(node-sharp_get_platform)
		einfo "Verifying Sharp symbols"
		pushd "${S}/node_modules/sharp" >/dev/null 2>&1 || die "Failed to enter sharp directory"
			local fn="sharp-${sharp_platform}-${NODE_SHARP_PV}.node"
			local node_path=$(realpath "${S}/node_modules/sharp/src/build/"*"/${fn}")
			if [[ -f "${node_path}" ]]; then
				if false && [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
					einfo "Checking for undefined symbols in ${fn}"
					if nm -D "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
						die "Undefined symbol xmlCtxtUseOptions still present in ${fn}"
					fi
					# Verify static libxml2 via nm
					einfo "Verifying libxml2 static linking"
					if nm "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
						die "libxml2 not statically linked in ${fn}"
					fi

					# Verify format loader symbols
					einfo "Verifying format loader symbols"
					local use_list=${NODE_SHARP_USE:-"dzi exif gif heif jpg lcms png svg tiff webp"}  # Defaults if unset
					for u in ${use_list} ; do
					case "${u}" in
						heif)
							einfo "Checking vips_heifload for heif"
							nm "${node_path}" | grep -q "vips_heifload" || die "Missing vips_heifload symbol for heif"
							;;
						gif)
							einfo "Checking vips_nsgifload for gif"
							nm "${node_path}" | grep -q "vips_nsgifload" || die "Missing vips_nsgifload symbol for gif"
							;;
						jpg|jpeg)
							einfo "Checking vips_jpegload for jpeg"
							nm "${node_path}" | grep -q "vips_jpegload" || die "Missing vips_jpegload symbol for jpeg"
							;;
						png)
							einfo "Checking vips_pngload for png"
							nm "${node_path}" | grep -q "vips_pngload" || die "Missing vips_pngload symbol for png"
							;;
						svg)
							einfo "Checking vips_svgload for svg"
							nm "${node_path}" | grep -q "vips_svgload" || die "Missing vips_svgload symbol for svg"
							;;
						tiff)
							einfo "Checking vips_tiffload for tiff"
							nm "${node_path}" | grep -q "vips_tiffload" || die "Missing vips_tiffload symbol for tiff"
							;;
						webp)
							einfo "Checking vips_webpload for webp"
							nm "${node_path}" | grep -q "vips_webpload" || die "Missing vips_webpload symbol for webp"
							;;
						esac
					done
				fi
			else
				die "${fn} not found after rebuild"
			fi
		popd >/dev/null 2>&1 || die
	else
		die "sharp module not found in ${S}/node_modules/sharp. Ensure it is installed."
	fi
}

# @FUNCTION: node-sharp_npm_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with npm
node-sharp_npm_rebuild_sharp() {
	chkl_check_many_timestamps

einfo "DEBUG:  Called node-sharp_npm_rebuild_sharp()"
	if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
		enpm add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
		if ! npm list --depth=0 | grep -q "node-gyp" ; then
			enpm add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
		fi
	fi

	einfo "Cleaning prebuilt for system-vips"
	edo rm -vrf "node_modules/@img/sharp"* || true
	edo rm -vrf "${HOME}/.cache/node-gyp" || treu
	edo rm -vrf "node_modules/sharp" || true
	export npm_config_build_from_source="true"

	local libdir=$(get_libdir)
	export PKG_CONFIG_PATH="/usr/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
	export LD_LIBRARY_PATH="/usr/${libdir}:${LD_LIBRARY_PATH}"
	einfo "PKG_CONFIG_PATH in npm_rebuild: ${PKG_CONFIG_PATH}"

	node-sharp_append_includes

	enpm add "sharp@${NODE_SHARP_PV}" \
		${NPM_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]} \
		--ignore-scripts=false \
		--foreground-scripts \
		--verbose

	if (( ${#NODE_SHARP_PATCHES[@]} > 0 )) ; then
		local patch_path
		for patch_path in ${NODE_SHARP_PATCHES[@]} ; do
			eapply "${patch_path}" || die "Failed to apply patch ${patch_path}"
		done
	else
		ewarn "QA:  Missing NODE_SHARP_PATCHES"
	fi

	node-sharp_append_libs

	edo rm -vrf "node_modules/sharp/build"
	edo rm -vrf "node_modules/@img/sharp"*
	pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
einfo "DEBUG:  PATH:  ${PATH}"
einfo "DEBUG:  PWD:  ${PWD}"
		which node >/dev/null || die "DEBUG:  Missing node (1)"
		local sharp_pv=$(ver_cut 1-2 "${NODE_SHARP_PV}")
		local sharp_full_pv=$(ver_cut 1-3 "${NODE_SHARP_PV}")
# Keep in sync with build script from https://github.com/lovell/sharp/blob/v0.35.3/package.json#L97
		if ! ls ../install/build.js >/dev/null ; then
ewarn "DEBUG:  Missing ../install/build.js for sharp (1)"
		elif [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
einfo "Building Sharp from source (Debug)"
			node ../install/build.js --debug || die
		else
einfo "Building Sharp from source (Release)"
			node ../install/build.js || die
		fi
	popd >/dev/null 2>&1 || die

	node-sharp_verify_built_symbols

	unset npm_config_build_from_source

	if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
		ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with node-gyp"
	else
		ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with node-gyp"
	fi
	grep -q \
		-e "compilation terminated" \
		"${T}/build.log" \
		&& die "Detected compilation error"
	grep -q \
		-e "build error" \
		"${T}/build.log" \
		&& die "Detected build error"
}

# @FUNCTION: node-sharp_pnpm_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with npm
node-sharp_pnpm_rebuild_sharp() {
	chkl_check_many_timestamps

	if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
		epnpm add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${PNPM_INSTALL_ARGS[@]}
		if ! npm list --depth=0 | grep -q "node-gyp" ; then
			epnpm add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${PNPM_INSTALL_ARGS[@]}
		fi
	fi

	einfo "Cleaning prebuilt for system-vips"
	edo rm -vrf "node_modules/@img/sharp"* || true
	edo rm -vrf "${HOME}/.cache/node-gyp" || true
	edo rm -vrf "node_modules/sharp" || true
	export npm_config_build_from_source="true"

	local libdir=$(get_libdir)
	export PKG_CONFIG_PATH="/usr/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
	export LD_LIBRARY_PATH="/usr/${libdir}:${LD_LIBRARY_PATH}"
	einfo "PKG_CONFIG_PATH in npm_rebuild: ${PKG_CONFIG_PATH}"

	node-sharp_append_includes

	epnpm add "sharp@${NODE_SHARP_PV}" \
		${PNPM_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]}

	if (( ${#NODE_SHARP_PATCHES[@]} > 0 )) ; then
		local patch_path
		for patch_path in ${NODE_SHARP_PATCHES[@]} ; do
			eapply "${patch_path}" || die "Failed to apply patch ${patch_path}"
		done
	else
		ewarn "QA:  Missing NODE_SHARP_PATCHES"
	fi

	node-sharp_append_libs

	edo rm -vrf "node_modules/sharp/build"
	edo rm -vrf "node_modules/@img/sharp"*
	pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
einfo "DEBUG:  PATH:  ${PATH}"
einfo "DEBUG:  PWD:  ${PWD}"
		which node >/dev/null || die "DEBUG:  Missing node (2)"
		local sharp_pv=$(ver_cut 1-2 "${NODE_SHARP_PV}")
		local sharp_full_pv=$(ver_cut 1-3 "${NODE_SHARP_PV}")
# Keep in sync with build script from https://github.com/lovell/sharp/blob/v0.35.3/package.json#L97
		if ! ls ../install/build.js >/dev/null ; then
ewarn "DEBUG:  Missing ../install/build.js for sharp (2)"
		elif [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
einfo "Building Sharp from source (Debug)"
			node ../install/build.js --debug || die
		else
einfo "Building Sharp from source (Release)"
			node ../install/build.js || die
		fi
	popd >/dev/null 2>&1 || die

	node-sharp_verify_built_symbols

	unset npm_config_build_from_source

	if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
		ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with node-gyp"
	else
		ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with node-gyp"
	fi
	grep -q \
		-e "compilation terminated" \
		"${T}/build.log" \
		&& die "Detected compilation error"
	grep -q \
		-e "build error" \
		"${T}/build.log" \
		&& die "Detected build error"
}

# @FUNCTION: node-sharp_npm_lockfile_add_sharp
# @DESCRIPTION:
# Add sharp to npm lockfile
node-sharp_npm_lockfile_add_sharp() {
	if [[ -n "${NODE_ADDON_API_PV}" ]] ; then
		enpm install "node-addon-api@${NODE_ADDON_API_PV}" ${NPM_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	else
		enpm install "node-addon-api" ${NPM_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	fi
	if npm list --depth=0 | grep -q "node-gyp" ; then
		:
	elif [[ -n "${NODE_GYP_PV}" ]] ; then
		enpm install "node-gyp@${NODE_GYP_PV}" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		enpm install "node-gyp" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	node-sharp_append_includes
	enpm add "sharp@${NODE_SHARP_PV}" ${NPM_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

# @FUNCTION: node-sharp_pnpm_lockfile_add_sharp
# @DESCRIPTION:
# Add sharp to pnpm lockfile
node-sharp_pnpm_lockfile_add_sharp() {
	if [[ -n "${NODE_ADDON_API_PV}" ]] ; then
		epnpm install "node-addon-api@${NODE_ADDON_API_PV}" ${PNPM_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	else
		epnpm install "node-addon-api" ${PNPM_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	fi
	if pnpm list --depth 0 | grep -q "node-gyp" ; then
		:
	elif [[ -n "${NODE_GYP_PV}" ]] ; then
		epnpm install "node-gyp@${NODE_GYP_PV}" ${PNPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		epnpm install "node-gyp" ${PNPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	node-sharp_append_includes
	epnpm add "sharp@${NODE_SHARP_PV}" ${PNPM_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

# @FUNCTION: node-sharp_yarn_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with yarn
node-sharp_yarn_rebuild_sharp() {
	chkl_check_many_timestamps

	if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
		eyarn add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
		if ! npm list --depth=0 | grep -q "node-gyp" ; then
			eyarn add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
		fi
	fi

	einfo "Cleaning prebuilt for system-vips"
	edo rm -vrf "node_modules/@img/sharp"* || true
	edo rm -vrf "${HOME}/.cache/node-gyp" || true
	edo rm -vrf "node_modules/sharp" || true
	export npm_config_build_from_source="true"

	local libdir=$(get_libdir)
	local sharp_vips_pkgconfig="/usr/${libdir}/pkgconfig"
	local sharp_vips_lib="/usr/${libdir}"
	if [[ ":${PKG_CONFIG_PATH}:" != *":${sharp_vips_pkgconfig}:"* ]]; then
		export PKG_CONFIG_PATH="${sharp_vips_pkgconfig}:${PKG_CONFIG_PATH}"
	fi
	if [[ ":${LD_LIBRARY_PATH}:" != *":${sharp_vips_lib}:"* ]]; then
		export LD_LIBRARY_PATH="${sharp_vips_lib}:${LD_LIBRARY_PATH}"
	fi

	einfo "PKG_CONFIG_PATH in yarn_rebuild: ${PKG_CONFIG_PATH}"
	einfo "LD_LIBRARY_PATH in yarn_rebuild: ${LD_LIBRARY_PATH}"
	einfo "vips-cpp version:  "$(pkg-config --modversion vips-cpp || die "Failed to find vips-cpp.pc")
	einfo "vips-cpp libs:  "$(pkg-config --libs vips-cpp || die "Failed to find vips-cpp.pc libs")
	if [[ ! -f "${sharp_vips_lib}/libvips-cpp.so" ]]; then
		die "libvips-cpp.so not found in ${sharp_vips_lib}"
	fi
	einfo "Found libvips-cpp.so in ${sharp_vips_lib}"

	node-sharp_append_includes

	einfo "Running yarn add sharp@${NODE_SHARP_PV} --verbose"
	eyarn add "sharp@${NODE_SHARP_PV}" -E \
		${YARN_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]}

	# Skip patching if already done in src_prepare
	if [[ -n "${NODE_SHARP_PATCHES_APPLIED}" ]]; then
		einfo "Skipping patch application in node-sharp_yarn_rebuild_sharp as already applied in src_prepare"
	else
		if (( ${#NODE_SHARP_PATCHES[@]} > 0 )) ; then
			local patch_path
			for patch_path in ${NODE_SHARP_PATCHES[@]} ; do
				pushd "${S}" >/dev/null 2>&1 || die "Failed to enter ${S}"
					eapply "${patch_path}" || die "Failed to apply patch ${patch_path}"
				popd >/dev/null 2>&1
			done
			export NODE_SHARP_PATCHES_APPLIED=1
		else
			ewarn "QA:  Missing NODE_SHARP_PATCHES"
		fi
	fi

	node-sharp_append_libs

	edo rm -vrf "node_modules/sharp/build"
	edo rm -vrf "node_modules/@img/sharp"*
	pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
einfo "DEBUG:  PATH:  ${PATH}"
einfo "DEBUG:  PWD:  ${PWD}"
		which node >/dev/null || die "DEBUG:  Missing node (3)"
		local sharp_pv=$(ver_cut 1-2 "${NODE_SHARP_PV}")
		local sharp_full_pv=$(ver_cut 1-3 "${NODE_SHARP_PV}")
# Keep in sync with build script from https://github.com/lovell/sharp/blob/v0.35.3/package.json#L97
		if ! ls ../install/build.js >/dev/null ; then
ewarn "DEBUG:  Missing ../install/build.js for sharp (3)"
		elif [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
einfo "Building Sharp from source (Debug)"
			node ../install/build.js --debug || die
		else
einfo "Building Sharp from source (Release)"
			node ../install/build.js || die
		fi
	popd >/dev/null 2>&1 || die

	node-sharp_verify_built_symbols

	unset npm_config_build_from_source

	if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
		ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with yarn"
	else
		ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
			|| die "Did not build sharp@${NODE_SHARP_PV} with yarn"
	fi
	grep -q \
		-e "compilation terminated" \
		"${T}/build.log" \
		&& die "Detected compilation error"
	grep -q \
		-e "build error" \
		"${T}/build.log" \
		&& die "Detected build error"
}

# @FUNCTION: node-sharp_yarn_lockfile_add_sharp
# @DESCRIPTION:
# Add sharp to yarn lockfile
node-sharp_yarn_lockfile_add_sharp() {
	if [[ -n "${NODE_ADDON_API_PV}" ]] ; then
		eyarn add "node-addon-api@${NODE_ADDON_API_PV}" ${YARN_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	else
		eyarn add "node-addon-api" ${YARN_INSTALL_ARGS[@]} ${NODE_ADDON_API_INSTALL_ARGS[@]}
	fi
	if grep -q '"node-gyp":' "package.json" ; then
		:
	elif [[ -n "${NODE_GYP_PV}" ]] ; then
		eyarn add "node-gyp@${NODE_GYP_PV}" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		eyarn add "node-gyp" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	node-sharp_append_includes
	eyarn add "sharp@${NODE_SHARP_PV}" ${YARN_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

# @FUNCTION: node-sharp_verify_dedupe
# @DESCRIPTION:
# Check if the node-sharp package is completely deduped.
node-sharp_verify_dedupe() {
# If sharp is not dedupe, the patches not be applied correctly
	local sharp_platform=$(node-sharp_get_platform)
	local NODE_SHARP_PROJECT_ROOT=${PROJECT_ROOT:-"${S}"}
	local L=(
		$(find "${NODE_SHARP_PROJECT_ROOT}" -name "sharp-${sharp_platform}-${NODE_SHARP_PV}.node")
	)
	local n_hashes=$(sha1sum "${L[@]}" \
		| cut -f 1 -d " " \
		| sort \
		| uniq \
		| wc -l)
	if (( ${n_hashes} > 1 )) ; then
		eerror "sharp is not deduped"
		die
	fi
}

fi
