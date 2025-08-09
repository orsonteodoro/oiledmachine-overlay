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

	export SHARP_FORCE_GLOBAL_LIBVIPS="true"
	local libdir=$(get_libdir)
	local sharp_vips_pkgconfig="/usr/lib/sharp-vips/${libdir}/pkgconfig"
	local sharp_vips_lib="/usr/lib/sharp-vips/${libdir}"
	local sharp_vips_include="/usr/lib/sharp-vips/include"
	if [[ ":${PKG_CONFIG_PATH}:" != *":${sharp_vips_pkgconfig}:"* ]]; then
		export PKG_CONFIG_PATH="${sharp_vips_pkgconfig}:${PKG_CONFIG_PATH}"
	fi
	if [[ ":${LD_LIBRARY_PATH}:" != *":${sharp_vips_lib}:"* ]]; then
		export LD_LIBRARY_PATH="${sharp_vips_lib}:${LD_LIBRARY_PATH}"
	fi

	einfo "PKG_CONFIG_PATH set to: ${PKG_CONFIG_PATH}"
	einfo "LD_LIBRARY_PATH set to: ${LD_LIBRARY_PATH}"
	einfo "vips-cpp version:  "$(pkg-config --modversion vips-cpp || die "Failed to find vips-cpp.pc")
	einfo "vips-cpp libs:  "$(pkg-config --static --libs vips-cpp || die "Failed to find vips-cpp.pc libs")

	# Verify libvips-cpp.so exists
	if [[ ! -f "${sharp_vips_lib}/libvips-cpp.a" ]]; then
		die "libvips-cpp.a not found in ${sharp_vips_lib}"
	fi
	einfo "Found libvips-cpp.a in ${sharp_vips_lib}"

	export NODE_SHARP_LIB_PATH="${sharp_vips_lib}"
	export NODE_SHARP_INCLUDE_DIR="${sharp_vips_include}"
	export NODE_SHARP_PKG_CONFIG_DIR="${sharp_vips_lib}/pkgconfig"
	einfo "NODE_SHARP_LIB_PATH:  ${NODE_SHARP_LIB_PATH}"
	einfo "NODE_SHARP_INCLUDE_DIR:  ${NODE_SHARP_INCLUDE_DIR}"
	einfo "NODE_SHARP_PKG_CONFIG_DIR:  ${NODE_SHARP_PKG_CONFIG_DIR}"
}

# @FUNCTION: node-sharp_append_libs
# @DESCRIPTION:
# Appends required libs.  Allows for custom or minified builds by setting NODE_SHARP_USE.
node-sharp_append_libs() {
	local libdir=$(get_libdir)
	local sharp_vips_lib="/usr/lib/sharp-vips/${libdir}"
	local pkg_config_libs=$(pkg-config --libs --static vips-cpp glib-2.0 libxml2 libpng libjpeg-turbo tiff libwebp libheif libexif lcms2 aom cgif harfbuzz fontconfig cairo pango fribidi pixman-1 | sed 's/-l/ /g')
	local libs="\"${sharp_vips_lib}/libvips-cpp.a ${sharp_vips_lib}/libvips.a $(pkg-config --libs --static vips-cpp glib-2.0 libxml2 libpng libjpeg-turbo tiff libwebp libheif libexif lcms2 aom cgif harfbuzz fontconfig cairo pango fribidi pixman-1)\""
	einfo "Appending libraries to binding.gyp: ${libs}"
	sed -i \
		-e "s|\"libraries\": \[\],|\"libraries\": [ ${libs} ],|" \
		-e "s|\"include_dirs\": \[\],|\"include_dirs\": [ \"/usr/lib/sharp-vips/include\", \"$(pkg-config --cflags-only-I vips-cpp | sed 's/-I//g')\" ],|" \
		"${S}/node_modules/sharp/src/binding.gyp" \
		|| die "Failed to append libraries to binding.gyp"

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


# @FUNCTION:  node-sharp_get_platform
# @DESCRIPTION:
# Gets the arch
node-sharp_get_platform() {
	if use kernel_linux ; then
		if  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "armv6" ]] ; then
			echo "linux-armv6"
		elif  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "aarch64" ]] ; then
			echo "linux-arm64v8"
		elif  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "powerpc64le" ]] ; then
			echo "linux-ppc64le"
		elif  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "riscv64" ]] ; then
			echo "linux-riscv64"
		elif  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "s390x" ]] ; then
			echo "linux-s390x"
		elif  [[ "${ELIBC}" == "glibc" && "${CHOST}" =~ "x86_64" ]] ; then
			echo "linux-x64"

		elif  [[ "${ELIBC}" == "musl" && "${CHOST}" =~ "x86_64" ]] ; then
			echo "linuxmusl-x64"
		elif  [[ "${ELIBC}" == "musl" && "${CHOST}" =~ "aarch64" ]] ; then
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
		einfo "Rebuilding sharp from source"
		pushd "${S}/node_modules/sharp" >/dev/null 2>&1 || die "Failed to enter sharp directory"
			local node_path=$(realpath "${S}/node_modules/sharp/src/build/"*"/sharp-${sharp_platform}.node")
			if [[ -f "${node_path}" ]]; then
				einfo "Checking for undefined symbols in sharp-${sharp_platform}.node"
				if nm -D "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
					die "Undefined symbol xmlCtxtUseOptions still present in sharp-${sharp_platform}.node"
				fi
				# Verify static libxml2 via nm
				einfo "Verifying libxml2 static linking"
				if nm "${node_path}" | grep -q "U xmlCtxtUseOptions"; then
					die "libxml2 not statically linked in sharp-${sharp_platform}.node"
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
			else
				die "sharp-${sharp_platform}.node not found after rebuild"
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
    if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
        enpm add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
        enpm add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
    fi

    einfo "Cleaning prebuilt for system-vips"
    edo rm -vrf "node_modules/@img/sharp"*
    edo rm -vrf "${HOME}/.cache/node-gyp"
    edo rm -vrf "node_modules/sharp"
    export npm_config_build_from_source="true"

    local libdir=$(get_libdir)
    export PKG_CONFIG_PATH="/usr/lib/sharp-vips/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
    export LD_LIBRARY_PATH="/usr/lib/sharp-vips/${libdir}:${LD_LIBRARY_PATH}"
    einfo "PKG_CONFIG_PATH in npm_rebuild: ${PKG_CONFIG_PATH}"

    enpm add "sharp@${SHARP_PV}" \
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
        local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
        if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node "../install/check" --debug || die "Failed to run install/check --debug"
            else
                edo node "../install/check" || die "Failed to run install/check"
            fi
        elif ver_test "${sharp_pv}" -lt "0.33" ; then
            edo node "install/can-compile" || die "Failed to run install/can-compile"
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node-gyp configure --debug || die "Failed to configure node-gyp --debug"
                edo node-gyp build --debug --verbose || die "Failed to build node-gyp --debug"
            else
                edo node-gyp rebuild || die "Failed to rebuild node-gyp"
            fi
            edo node "../install/dll-copy" || die "Failed to run dll-copy"
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
    if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
        epnpm add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${PNPM_INSTALL_ARGS[@]}
        epnpm add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${PNPM_INSTALL_ARGS[@]}
    fi

    einfo "Cleaning prebuilt for system-vips"
    edo rm -vrf "node_modules/@img/sharp"*
    edo rm -vrf "${HOME}/.cache/node-gyp"
    edo rm -vrf "node_modules/sharp"
    export npm_config_build_from_source="true"

    local libdir=$(get_libdir)
    export PKG_CONFIG_PATH="/usr/lib/sharp-vips/${libdir}/pkgconfig:${PKG_CONFIG_PATH}"
    export LD_LIBRARY_PATH="/usr/lib/sharp-vips/${libdir}:${LD_LIBRARY_PATH}"
    einfo "PKG_CONFIG_PATH in npm_rebuild: ${PKG_CONFIG_PATH}"

    epnpm add "sharp@${SHARP_PV}" \
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
        local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
        if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node "../install/check" --debug || die "Failed to run install/check --debug"
            else
                edo node "../install/check" || die "Failed to run install/check"
            fi
        elif ver_test "${sharp_pv}" -lt "0.33" ; then
            edo node "install/can-compile" || die "Failed to run install/can-compile"
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node-gyp configure --debug || die "Failed to configure node-gyp --debug"
                edo node-gyp build --debug --verbose || die "Failed to build node-gyp --debug"
            else
                edo node-gyp rebuild || die "Failed to rebuild node-gyp"
            fi
            edo node "../install/dll-copy" || die "Failed to run dll-copy"
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
	if [[ -n "${NODE_GYP_PV}" ]] ; then
		enpm install "node-gyp@${NODE_GYP_PV}" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		enpm install "node-gyp" ${NPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	enpm add "sharp@${SHARP_PV}" ${NPM_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
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
	if [[ -n "${NODE_GYP_PV}" ]] ; then
		epnpm install "node-gyp@${NODE_GYP_PV}" ${PNPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		epnpm install "node-gyp" ${PNPM_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	epnpm add "sharp@${SHARP_PV}" ${PNPM_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

# @FUNCTION: node-sharp_yarn_rebuild_sharp
# @DESCRIPTION:
# Rebuild sharp with yarn
node-sharp_yarn_rebuild_sharp() {
    if [[ "${SHARP_ADD_DEPS:-0}" == "1" ]] ; then
        eyarn add "node-addon-api" ${NODE_ADDON_API_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
        eyarn add "node-gyp" ${NODE_GYP_INSTALL_ARGS[@]} ${NPM_INSTALL_ARGS[@]}
    fi

    einfo "Cleaning prebuilt for system-vips"
    edo rm -vrf "node_modules/@img/sharp"* || die "Failed to clean @img/sharp"
    edo rm -vrf "${HOME}/.cache/node-gyp" || die "Failed to clean node-gyp cache"
    edo rm -vrf "node_modules/sharp" || die "Failed to clean node_modules/sharp"
    export npm_config_build_from_source="true"

    local libdir=$(get_libdir)
    local sharp_vips_pkgconfig="/usr/lib/sharp-vips/${libdir}/pkgconfig"
    local sharp_vips_lib="/usr/lib/sharp-vips/${libdir}"
    if [[ ":${PKG_CONFIG_PATH}:" != *":${sharp_vips_pkgconfig}:"* ]]; then
        export PKG_CONFIG_PATH="${sharp_vips_pkgconfig}:${PKG_CONFIG_PATH}"
    fi
    if [[ ":${LD_LIBRARY_PATH}:" != *":${sharp_vips_lib}:"* ]]; then
        export LD_LIBRARY_PATH="${sharp_vips_lib}:${LD_LIBRARY_PATH}"
    fi

    einfo "PKG_CONFIG_PATH in yarn_rebuild: ${PKG_CONFIG_PATH}"
    einfo "LD_LIBRARY_PATH in yarn_rebuild: ${LD_LIBRARY_PATH}"
    einfo "vips-cpp version:  "$(pkg-config --modversion vips-cpp || die "Failed to find vips-cpp.pc")
    einfo "vips-cpp libs:  "$(pkg-config --static --libs vips-cpp || die "Failed to find vips-cpp.pc libs")
    if [[ ! -f "${sharp_vips_lib}/libvips-cpp.a" ]]; then
        die "libvips-cpp.a not found in ${sharp_vips_lib}"
    fi
    einfo "Found libvips-cpp.a in ${sharp_vips_lib}"

    einfo "Running yarn add sharp@${SHARP_PV} --verbose"
    eyarn add "sharp@${SHARP_PV}" -E \
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

    edo rm -vrf "node_modules/sharp/build" || die "Failed to clean sharp build directory"
    edo rm -vrf "node_modules/@img/sharp"* || die "Failed to clean @img/sharp"
    pushd "${S}/node_modules/sharp/src" >/dev/null 2>&1 || die
        local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
        if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node "../install/check" --debug || die "Failed to run install/check --debug"
            else
                edo node "../install/check" || die "Failed to run install/check"
            fi
        elif ver_test "${sharp_pv}" -lt "0.33" ; then
            edo node "install/can-compile" || die "Failed to run install/can-compile"
            if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
                edo node-gyp configure --debug || die "Failed to configure node-gyp --debug"
                edo node-gyp build --debug --verbose || die "Failed to build node-gyp --debug"
            else
                edo node-gyp rebuild || die "Failed to rebuild node-gyp"
            fi
            edo node "../install/dll-copy" || die "Failed to run dll-copy"
        fi
    popd >/dev/null 2>&1 || die

    node-sharp_verify_built_symbols

    unset npm_config_build_from_source

    if [[ -e "${NODE_SHARP_NODE_MODULE_PATH}" ]] ; then
        ls "${NODE_SHARP_NODE_MODULE_PATH}" >/dev/null \
            || die "Did not build sharp@${SHARP_PV} with yarn"
    else
        ls "${S}/node_modules/sharp/src/build/"*"/sharp-linux-"*".node" >/dev/null \
            || die "Did not build sharp@${SHARP_PV} with yarn"
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
	if [[ -n "${NODE_GYP_PV}" ]] ; then
		eyarn add "node-gyp@${NODE_GYP_PV}" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	else
		eyarn add "node-gyp" ${YARN_INSTALL_ARGS[@]} ${NODE_GYP_INSTALL_ARGS[@]}
	fi
	eyarn add "sharp@${SHARP_PV}" ${YARN_INSTALL_ARGS[@]} ${SHARP_INSTALL_ARGS[@]}
}

# @FUNCTION: node-sharp_verify_dedupe
# @DESCRIPTION:
# Check if the node-sharp package is completely deduped.
node-sharp_verify_dedupe() {
# If sharp is not dedupe, the patches not be applied correctly
	local sharp_platform=$(node-sharp_get_platform)
	local NODE_SHARP_PROJECT_ROOT=${PROJECT_ROOT:-"${S}"}
	local L=(
		$(find "${NODE_SHARP_PROJECT_ROOT}" -name "sharp-${sharp_platform}.node")
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
