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

inherit edo flag-o-matic

_node_sharp_set_globals() {
	if [[ -z "${SHARP_PV}" ]] ; then
eerror "QA:  SHARP_PV needs to be defined"
		die
	fi
	if [[ -z "${VIPS_PV}" ]] ; then
eerror "QA:  VIPS_PV needs to be defined"
		die
	fi
	local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
	if ver_test "${sharp_pv}" -eq "0.34" ; then
# See https://github.com/lovell/sharp/blob/v0.34.2/docs/src/content/docs/install.md
		NODE_SHARP_GLIBC_PV="2.31"
		NODE_SHARP_MUSL_PV="1.2.2"
		NODE_SHARP_NODEJS_CDEPEND="
			|| (
				>=net-libs/nodejs-18.17.0:18
				>=net-libs/nodejs-20.3.0
			)
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.26"
			NODE_SHARP_MUSL_PV="1.2.2"
		elif [[ "${ARCH}" == "arm" ]] ; then
			NODE_SHARP_GLIBC_PV="2.31"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.26"
			NODE_SHARP_MUSL_PV="1.2.2"
		elif [[ "${ARCH}" == "s390x" ]] ; then
			NODE_SHARP_GLIBC_PV="2.31"
		fi
	elif ver_test "${sharp_pv}" -eq "0.33" ; then
# See https://github.com/lovell/sharp/blob/v0.33.5/docs/install.md#prebuilt-binaries
		NODE_SHARP_GLIBC_PV="2.31"
		NODE_SHARP_MUSL_PV="1.2.2"
		NODE_SHARP_NODEJS_CDEPEND="
			|| (
				>=net-libs/nodejs-18.17.0:18
				>=net-libs/nodejs-20.3.0
			)
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.26"
			NODE_SHARP_MUSL_PV="1.2.2"
		elif [[ "${ARCH}" == "arm" ]] ; then
			NODE_SHARP_GLIBC_PV="2.28"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.26"
			NODE_SHARP_MUSL_PV="1.2.2"
		elif [[ "${ARCH}" == "s390x" ]] ; then
			NODE_SHARP_GLIBC_PV="2.31"
		fi
	elif ver_test "${sharp_pv}" -eq "0.32" || ver_test "${sharp_pv}" -eq "0.31" ; then
# See https://github.com/lovell/sharp/blob/v0.31.3/docs/install.md#prebuilt-binaries
# See https://github.com/lovell/sharp/blob/v0.32.6/docs/install.md#prebuilt-binaries
		NODE_SHARP_GLIBC_PV="2.28"
		NODE_SHARP_MUSL_PV="1.1.24"
		NODE_SHARP_NODEJS_CDEPEND="
			>=net-libs/nodejs-14.15.0
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.17"
			NODE_SHARP_MUSL_PV="1.1.24"
		elif [[ "${ARCH}" == "arm" ]] ; then
			NODE_SHARP_GLIBC_PV="2.28"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.17"
			NODE_SHARP_MUSL_PV="1.1.24"
		fi
	elif ver_test "${sharp_pv}" -eq "0.30" ; then
# See https://github.com/lovell/sharp/blob/v0.30.7/docs/install.md#prebuilt-binaries
		NODE_SHARP_GLIBC_PV="2.28"
		NODE_SHARP_MUSL_PV="1.1.24"
		NODE_SHARP_NODEJS_CDEPEND="
			>=net-libs/nodejs-12.13.0
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.17"
			NODE_SHARP_MUSL_PV="1.1.24"
		elif [[ "${ARCH}" == "arm" ]] ; then
			NODE_SHARP_GLIBC_PV="2.28"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.17"
			NODE_SHARP_MUSL_PV="1.1.24"
		fi
	elif ver_test "${sharp_pv}" -eq "0.29" ; then
# See https://github.com/lovell/sharp/blob/v0.29.3/docs/install.md#prebuilt-binaries
		NODE_SHARP_GLIBC_PV="2.29"
		NODE_SHARP_MUSL_PV="1.1.24"
		NODE_SHARP_NODEJS_CDEPEND="
			>=net-libs/nodejs-12.13.0
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.17"
			NODE_SHARP_MUSL_PV="1.1.24"
		elif [[ "${ARCH}" == "arm" ]] ; then
			NODE_SHARP_GLIBC_PV="2.28"
		elif [[ "${ARCH}" == "arm64" ]] ; then
			NODE_SHARP_GLIBC_PV="2.29"
			NODE_SHARP_MUSL_PV="1.1.24"
		fi
	else
einfo "QA:  Update _node_sharp_set_globals for sharp_pv=${sharp_pv}"
einfo "sharp_pv=${sharp_pv} is currently not supported."
		die
	fi
}
_node_sharp_set_globals
unset -f _node_sharp_set_globals

# See also node-sharp_pkg_setup().
#
# For system-vips, the reason why there are so many requirements is because they
# do not do testing on the format() checker in
# https://github.com/lovell/sharp/blob/v0.34.2/src/utilities.cc#L120 for
# custom vips builds with enabled/disabled image formats.  All checked are
# required to prevent a segfault and to prevent force adding the old vulnerable
# sharp.  It has been bugged since 0.31.0 for system-wide vips users.
#
# We don't use the prebuilt sharp because it builds for non-portable
# -march=nehalem
# <https://github.com/lovell/sharp-libvips/blob/v8.16.1/platforms/linux-x64/Dockerfile>
# and doesn't work on my machine.
#
# See also:  https://github.com/lovell/sharp-libvips/blob/main/build/posix.sh
#
if [[ -n "${SHARP_PV}" ]] ; then
	NODE_SHARP_CDEPEND+="
		${NODE_SHARP_NODEJS_CDEPEND}
		>=media-libs/sharp-libvips-8.16.1
		media-libs/sharp-libvips:=
		elibc_glibc? (
			>=sys-libs/glibc-${NODE_SHARP_GLIBC_PV}
		)
		elibc_musl? (
			>=sys-libs/musl-${NODE_SHARP_MUSL_PV}
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
	"
fi

# @FUNCTION: node-sharp_pkg_setup
# @DESCRIPTION:
# Sets up the sharp build environment variables.
node-sharp_pkg_setup() {
# Rebuild sharp without prebuilt vips.
# Prebuilt vips is built with sse4.2 which breaks on older processors.
# Reference:  https://sharp.pixelplumbing.com/install#prebuilt-binaries
	unset SHARP_IGNORE_GLOBAL_LIBVIPS
	unset SHARP_FORCE_GLOBAL_LIBVIPS
	export SHARP_FORCE_GLOBAL_LIBVIPS="true" # true (system-vips), false (prebuilt)
}

# @FUNCTION: node-sharp_append_libs
# @DESCRIPTION:
# Appends required libs.  Allows for custom or minified builds by setting NODE_SHARP_USE.
node-sharp_append_libs() {
	einfo "Configuring sharp-libvips with NODE_SHARP_USE=${NODE_SHARP_USE}"

	filter-flags -Wl,--as-needed

	# Base path for sharp-libvips static libraries and headers
	local libdir=$(get_libdir)
	local sharp_vips_base_path="/usr/lib/sharp-vips"
	local sharp_vips_lib_path="${sharp_vips_base_path}/${libdir}"
	local sharp_vips_include_path="${sharp_vips_base_path}/include"

	export NODE_SHARP_INCLUDE_DIR="${sharp_vips_include_path}"
	export NODE_SHARP_LIB_PATH="${sharp_vips_lib_path}"
	export NODE_SHARP_PKG_CONFIG_DIR="${sharp_vips_lib_path}/pkgconfig"

	# Verify sharp-libvips installation
	if [[ ! -d "${sharp_vips_lib_path}" || ! -d "${sharp_vips_include_path}" ]] ; then
		die "sharp-libvips not found at ${sharp_vips_base_path}"
	fi

	# Verify sharp-libvips version
	local vips_version=$(pkg-config --modversion vips 2>/dev/null || echo "0")
	if [[ -z "${vips_version}" ]] || ver_test $(ver_cut 1-2 "${vips_version}") -lt "8.16" ; then
		die "sharp-libvips 8.16 or newer is required"
	fi

	# Check required dependencies
	local dep
	for dep in ${vips_pkgs} ${deps_pkgs} ; do
		if ! pkg-config --modversion "${dep}" >/dev/null 2>&1 ; then
			die "Missing dependency: ${dep}"
		fi
	done

	# Generate cflags and libs recursively using pkg-config
	if [[ -n "${deps_pkgs}" ]] ; then
		deps_cflags="${deps_cflags} "$(pkg-config --cflags --static ${deps_pkgs} 2>/dev/null) || die "Failed to get cflags via pkg-config for ${deps_pkgs}"
		deps_libs="${deps_libs} "$(pkg-config --libs --static ${deps_pkgs} 2>/dev/null) || die "Failed to get libs via pkg-config for ${deps_pkgs}"
	fi
	einfo "deps_libs:  ${deps_libs}"
	einfo "deps_cflags:  ${deps_cflags}"

	# Verify static libvips-cpp.a and libxml2.a exist
	if [[ ! -f "${sharp_vips_lib_path}/libvips-cpp.a" ]] ; then
		die "libvips-cpp.a not found in ${sharp_vips_lib_path}"
	fi

	# Set PKG_CONFIG_PATH to use custom vips.pc
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
einfo "LD_LIBRARY_PATH:  ${LD_LIBRARY_PATH}"

einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
einfo "LIBS:  ${LIBS}"
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
	unset LIBS
}

# @FUNCTION:  node-sharp_verify_loader_symbols
# @DESCRIPTION:
# Check loader symbols
node-sharp_verify_built_symbols() {
	if [[ -d "${S}/node_modules/sharp" ]]; then
		einfo "Rebuilding sharp@0.34.2 from source"
		pushd "${S}/node_modules/sharp" || die "Failed to enter sharp directory"
			local node_path=$(realpath "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node")
			if [[ -f "${node_path}" ]]; then
				einfo "Checking for undefined symbols in sharp-linux-x64.node"
				if nm -D "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
					die "Undefined symbol xmlCtxtUseOptions still present in sharp-linux-x64.node"
				fi
				# Verify static libxml2 via nm
				einfo "Verifying libxml2 static linking"
				if nm "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
					die "libxml2 not statically linked in sharp-linux-x64.node"
				fi

				# Verify format loader symbols
				einfo "Verifying format loader symbols"
				local use_list="${NODE_SHARP_USE:-dzi exif gif heif jpg lcms png svg tiff webp}"  # Defaults if unset
				for u in ${use_list} ; do
				case "${u}" in
					heif)
						einfo "Checking vips_heifload for heif"
						nm "${node_path}" | grep -q "vips_heifload" || die "Missing vips_heifload symbol for heif"
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
			else
				die "sharp-linux-x64.node not found after rebuild"
			fi
		popd
	else
		die "sharp module not found in ${S}/node_modules/sharp. Ensure it is installed."
	fi
}

# @FUNCTION: node-sharp_npm_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with npm
node-sharp_npm_rebuild_sharp() {
	if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
		enpm add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
		enpm add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
	fi

	einfo "Cleaning prebuilt for system-vips"
	edo rm -vrf "node_modules/@img/sharp"*
	edo rm -vrf "${HOME}/.cache/node-gyp"
	edo rm -vrf "node_modules/sharp"
	export npm_config_build_from_source="true"

	enpm add "sharp@${SHARP_PV}" \
		${NPM_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]} \
		--ignore-scripts=false \
		--foreground-scripts \
		--verbose

	if (( ${#NODE_SHARP_PATCHES[@]} > 0 )) ; then
		local patch_path
		for patch_path in ${NODE_SHARP_PATCHES[@]} ; do
			eapply "${patch_path}"
		done
	else
		ewarn "QA:  Missing NODE_SHARP_PATCHES"
	fi

	local libdir=$(get_libdir)
	export PKG_CONFIG_PATH="/usr/lib/sharp-vips/${libdir}/pkgconfig"
	export LD_LIBRARY_PATH="/usr/lib/sharp-vips/${libdir}"
	node-sharp_append_libs

	edo rm -vrf "node_modules/sharp/build"
	edo rm -vrf "node_modules/@img/sharp"*
	pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
		local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
		if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
			if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
				edo node "../install/check" --debug
			else
				edo node "../install/check"
			fi
		elif ver_test "${sharp_pv}" -lt "0.33" ; then
	# The --build-from-source is not deterministic.
	# The sharp install in package.json does short circuit and bypasses native build.
			edo node "install/can-compile"
			if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
				edo node-gyp configure --debug
				edo node-gyp build --debug --verbose
			else
				edo node-gyp rebuild
			fi
			edo node "../install/dll-copy"
		fi
	popd >/dev/null 2>&1 || die

	node-sharp_verify_built_symbols

	unset npm_config_build_from_source

	if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
		ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
	else
		ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
	fi
	grep -q \
		-e "compilation terminated" \
		"${T}/build.log" \
		&& die "Detected error"
	grep -q \
		-e "build error" \
		"${T}/build.log" \
		&& die "Detected error"
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
	if [[ -n "${NODE_GYP_PV}" ]] ; then
		enpm install "node-gyp@${NODE_GYP_PV}" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		enpm install "node-gyp" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	enpm add "sharp@${SHARP_PV}" ${NPM_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}


# @FUNCTION: node-sharp_yarn_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with yarn
node-sharp_yarn_rebuild_sharp() {
	if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
		eyarn add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${YARN_INSTALL_ARGS[@]}
		eyarn add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${YARN_INSTALL_ARGS[@]}
	fi

	if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
einfo "Adding debug flags for sharp"
		append-flags -ggdb3 -O0 -UNDEBUG -DG_ENABLE_DEBUG -DDEBUG
	fi

	edo rm -vrf "node_modules/@img/sharp"*
	edo rm -vrf "${HOME}/.cache/node-gyp"
	edo rm -vrf "node_modules/sharp"
	export npm_config_build_from_source="true"

	eyarn add "sharp@${SHARP_PV}" \
		-E \
		${YARN_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]}

	if (( ${#NODE_SHARP_PATCHES[@]} > 0 )) ; then
		local patch_path
		for patch_path in ${NODE_SHARP_PATCHES[@]} ; do
			eapply "${patch_path}"
		done
	else
		ewarn "QA:  Missing NODE_SHARP_PATCHES"
	fi

	local libdir=$(get_libdir)
	export PKG_CONFIG_PATH="/usr/lib/sharp-vips/${libdir}/pkgconfig"
	export LD_LIBRARY_PATH="/usr/lib/sharp-vips/${libdir}"
	node-sharp_append_libs

	edo rm -vrf "node_modules/sharp/build"
	edo rm -vrf "node_modules/@img/sharp"*
	pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
		local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
		if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
			if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
				edo node "../install/check" --debug
			else
				edo node "../install/check"
			fi
		elif ver_test "${sharp_pv}" -lt "0.33" ; then
	# The --build-from-source is not deterministic.
	# The sharp install in package.json does short circuit and bypasses native build.
			edo node "install/can-compile"
			if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
				edo node-gyp configure --debug
				edo node-gyp build --debug --verbose
			else
				edo node-gyp rebuild
			fi
			edo node "../install/dll-copy"
		fi
	popd >/dev/null 2>&1 || die

	node-sharp_verify_built_symbols

	if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
		ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
	else
		ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
	fi
	grep -q \
		-e "compilation terminated" \
		"${T}/build.log" \
		&& die "Detected error"
	grep -q \
		-e "build error" \
		"${T}/build.log" \
		&& die "Detected error"

	unset npm_config_build_from_source
# TODO:  verify rebuilt.  For an example, see node-sharp_npm_rebuild_sharp.
ewarn "QA:  You must manually verify sharp@${SHARP_PV} rebuild correctness"
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
	if [[ -n "${NODE_GYP_PV}" ]] ; then
		eyarn add "node-gyp@${NODE_GYP_PV}" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		eyarn add "node-gyp" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	eyarn add "sharp@${SHARP_PV}" ${YARN_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

fi
