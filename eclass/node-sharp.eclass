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
if [[ -n "${SHARP_PV}" ]] ; then
	IUSE+=" +system-vips"
	if ver_test "${SHARP_PV}" -ge "0.30" ; then
		IUSE+=" cpu_flags_x86_sse4_2"
		REQUIRED_USE+="
			!cpu_flags_x86_sse4_2? (
				system-vips
			)
		"
	fi
	NODE_SHARP_CDEPEND+="
		${NODE_SHARP_NODEJS_CDEPEND}
		elibc_glibc? (
			>=sys-libs/glibc-${NODE_SHARP_GLIBC_PV}
		)
		elibc_musl? (
			>=sys-libs/musl-${NODE_SHARP_MUSL_PV}
		)
		system-vips? (
			>=media-libs/vips-${VIPS_PV}
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
	if use system-vips ; then
einfo "Using system vips for sharp"
		export SHARP_FORCE_GLOBAL_LIBVIPS="true"
	else
einfo "Using vendored vips for sharp"
		export SHARP_IGNORE_GLOBAL_LIBVIPS="true"
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

	if use system-vips ; then
		edo rm -vrf "node_modules/@img/sharp"*
		edo rm -vrf "${HOME}/.cache/node-gyp"
		edo rm -vrf "node_modules/sharp"
		export npm_config_build_from_source="true"
	fi

	enpm add "sharp@${SHARP_PV}" \
		${NPM_INSTALL_ARGS[@]} \
		${SHARP_INSTALL_ARGS[@]} \
		--ignore-scripts=false \
		--foreground-scripts \
		--verbose

	if use system-vips ; then
		append-flags $(pkg-config --cflags "glib-2.0")
		edo rm -vrf "node_modules/sharp/build"
		edo rm -vrf "node_modules/@img/sharp"*
		pushd "${S}/node_modules/sharp" >/dev/null 2>&1 || die
			local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
			if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
				edo node "install/check"
			elif ver_test "${sharp_pv}" -lt "0.33" ; then
	# The --build-from-source is not deterministic.
	# The sharp install in package.json does short circuit and bypasses native build.
				edo node "install/can-compile"
				if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
					edo node-gyp rebuild --debug
				else
					edo node-gyp rebuild
				fi
				edo node "install/dll-copy"
			fi
		popd >/dev/null 2>&1 || die
	fi

	unset npm_config_build_from_source

	if use system-vips ; then
		grep -q \
			-e "SOLINK_MODULE.*sharp-.*.node" \
			"${T}/build.log" \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
		grep -q \
			-e "compilation terminated" \
			"${T}/build.log" \
			&& die "Detected error"
		grep -q \
			-e "build error" \
			"${T}/build.log" \
			&& die "Detected error"
	fi
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

	if use system-vips ; then
		append-flags $(pkg-config --cflags "glib-2.0")
		edo rm -vrf "node_modules/@img/sharp"*
		edo rm -vrf "${HOME}/.cache/node-gyp"
		edo rm -vrf "node_modules/sharp"
		export npm_config_build_from_source="true"

		eyarn add "sharp@${SHARP_PV}" \
			-E \
			${YARN_INSTALL_ARGS[@]} \
			${SHARP_INSTALL_ARGS[@]}

		edo rm -vrf "node_modules/sharp/build"
		edo rm -vrf "node_modules/@img/sharp"*
		pushd "${S}/node_modules/sharp" >/dev/null 2>&1 || die
			local sharp_pv=$(ver_cut 1-2 "${SHARP_PV}")
			if ver_test "${sharp_pv}" -eq "0.33" || ver_test "${sharp_pv}" -eq "0.34" ; then
				edo node "install/check"
			elif ver_test "${sharp_pv}" -lt "0.33" ; then
	# The --build-from-source is not deterministic.
	# The sharp install in package.json does short circuit and bypasses native build.
				edo node "install/can-compile"
				if [[ "${NODE_SHARP_DEBUG}" == "1" ]] ; then
					edo node-gyp rebuild --debug
				else
					edo node-gyp rebuild
				fi
				edo node "install/dll-copy"
			fi
		popd >/dev/null 2>&1 || die

		grep -q \
			-e "SOLINK_MODULE.*sharp-.*.node" \
			"${T}/build.log" \
			|| die "Did not build sharp@${SHARP_PV} with node-gyp"
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
	else
		unset npm_config_build_from_source
		eyarn add "sharp@${SHARP_PV}" \
			${YARN_INSTALL_ARGS[@]} \
			${SHARP_INSTALL_ARGS[@]}
	fi
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
