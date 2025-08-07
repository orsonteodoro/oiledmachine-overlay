# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

export NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}_${PV}.AppImage"
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="37.2.6" # Cr 138.0.7204.185, node 22.17.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="33.3.1" # Cr 130.0.6723.170, node 20.18.1
fi
ELECTRON_APP_AT_TYPES_NODE_PV="20.17.10"
ELECTRON_APP_MODE="npm"
NODE_ENV="development"
NODE_VERSION=${ELECTRON_APP_AT_TYPES_NODE_PV%%.*}
NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS+=(
		"--force"
	)
fi
# See https://releases.electronjs.org/releases.json

inherit desktop edo electron-app lcnr npm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/JannisX11/blockbench/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"

DESCRIPTION="Blockbench is a boxy 3D model editor"
HOMEPAGE="https://www.blockbench.net"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	0BSD
	BSD
	BSD-2
	CC-BY-4.0
	CC0-1.0
	ISC
	MIT
	|| (
		AFL-2.1
		BSD
	)
" # ^^ (mutual exclusion) is not supported. \
# || assumes that user chooses outside of computer.
LICENSE="
	${THIRD_PARTY_LICENSES}
	(
		${ELECTRON_APP_LICENSES}
		Artistic-2
		electron-37.1.0-chromium.html
	)
	GPL-3+
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ^^ ( BSD AFL-2.1 ) - node_modules/json-schema/LICENSE
# Apache-2.0 - node_modules/wintersky/node_modules/three/examples/fonts/droid/NOTICE
# 0BSD - node_modules/rxjs/node_modules/tslib/CopyrightNotice.txt
# BSD - node_modules/json-schema/LICENSE
# BSD-2 - node_modules/configstore/license
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# ISC - node_modules/webpack/node_modules/graceful-fs/LICENSE
# MIT - node_modules/p-locate/node_modules/p-limit/license
# MIT all-rights-reserved - work/blockbench-4.5.2/node_modules/minizlib/LICENSE
# MIT, CC0-1.0 - node_modules/lodash.sortby/LICENSE
# GPL-3 - LICENSE.MD

# For Electron 21.2.2: \
# custom \
#   search "with the mathematical derivations" \
# ( LGPL-2.1+ MIT BSD GPL-2+ ) \
# ( MPL2 || ( BSD LGPL ) ) \
# ( MIT SGI-Free-B SGI-copyright LGPL Mark's-copyright BSD ) \
# ( MIT all-rights-reserved ) \
# ( HPND all-rights-reserved ) \
# ( CC-BY-3.0 MIT CC-BY public-domain ) \
# ( BSD BSD-2 ) \
# android \
# AFL-2.0 \
# Apache-2.0 \
# Apache-2.0-with-LLVM-exceptions \
# APSL-2 \
# Artistic-2 \
# BitstreamVera \
# Boost-1.0 \
# BSD \
# BSD-2 \
# BSD-4 \
# BSD-Protection  \
# CC∅ Public Domain Affirmation and Waiver 1.0 United States (https://www.creativecommons.org/licenses/zero-waive/1.0/us/legalcode) \
# CPL-1.0 \
# curl \
# EPL-1.0 \
# FLEX \
# FTL \
# GPL-2 \
# GPL-2+ \
# GPL-2-with-classpath-exception \
# GPL-3 \
# GPL-3+ \
# HPND \
# icu-70.1 \
# icu-1.8.1 \
# IJG \
# ISC \
# Khronos-CLHPP \
# libpng \
# libpng2 \
# libstdc++ \
# LGPL-2.1 \
# LGPL-3 \
# MIT \
# MPL-1.1 \
# MPL-2.0 \
# Ms-PL \
# neon_2_sse \
# NEWLIB-extra \
# OFL-1.1 \
# ooura \
# openssl \
# public-domain \
# PCRE8 (BSD) \
# SunPro \
# unicode \
# Unicode-DFS-2016 \
# UoI-NCSA \
# unRAR \
# libwebm-PATENTS \
# ZLIB \
# || ( MIT public-domain ( MIT public-domain )) \
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
# - node_modules/electron/dist/LICENSES.chromium.html

RESTRICT="mirror"
SLOT="0"
IUSE+=" ebuild_revision_3"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}[webassembly(+)]
	>=net-libs/nodejs-${NODE_VERSION}[npm,webassembly(+)]
"

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		fix_lockfile() {
			sed -i -e "s|\"serialize-javascript\": \"^4.0.0\"|\"serialize-javascript\": \"^6.0.2\"|g" "package-lock.json" || die
		}
		fix_lockfile
		enpm install "electron-builder@25.1.8" ${NPM_INSTALL_ARGS[@]}
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D ${NPM_INSTALL_ARGS[@]}
		enpm install "serialize-javascript@^6.0.2" -D ${NPM_INSTALL_ARGS[@]}
		fix_lockfile
	fi
}

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

		_npm_setup_offline_cache

		rm -vf package-lock.json
		enpm install ${NPM_INSTALL_ARGS[@]}

		npm_update_lock_install_post

		enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}

		_npm_check_errors
einfo "Updating lockfile done."
		exit 0
	else
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		npm_src_unpack
if false ; then
		cd "${S}" || die
		local pos
		pos=$(grep -n -e "appId" "package.json" \
			| cut -f 1 -d ":")
einfo "DEBUG: pos: ${pos}"
		[[ -z "${pos}" ]] && die
		pos=$(( ${pos} + 1 ))
		sed -i -e "${pos}a \\\t\t\"npmRebuild\": false," "package.json" || die
fi
	fi
}

src_compile() {
	npm_hydrate
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"

	export ELECTRON_CUSTOM_DIR="v${ELECTRON_APP_ELECTRON_PV}"

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	edo electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		-c.electronDownload.customFilename="electron-v${ELECTRON_APP_ELECTRON_PV}-$(electron-app_get_electron_platarch).zip" \
		|| die
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Graphics;3DGraphics"
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/blockbench"
	lcnr_install_files
	electron-app_set_sandbox_suid "/opt/blockbench/chrome-sandbox"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.12.5 (20230629 with electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.12.3 (20250311 with electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.12.2 (20250211 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.11.2 (20241130)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.7.4 (20230528)
# preview (saved screenshot):  passed (vertically stacked rotated cubes)
