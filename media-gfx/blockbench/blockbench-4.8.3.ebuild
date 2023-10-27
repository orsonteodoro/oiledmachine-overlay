# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

export NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}_${PV}.AppImage"
ELECTRON_APP_ELECTRON_PV="25.7.0"
ELECTRON_APP_MODE="npm"
NODE_VERSION=16
NODE_ENV=development
inherit desktop electron-app lcnr npm

DESCRIPTION="Blockbench - A boxy 3D model editor"
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
	(
		${ELECTRON_APP_LICENSES}
		Artistic-2
	)
	${THIRD_PARTY_LICENSES}
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

KEYWORDS="~amd64"
SLOT="0"
IUSE+=" r1"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/blockbench-4.6.5/work/blockbench-4.6.5/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.12.tgz -> npmpkg-@electron-remote-2.0.12.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-0.0.39.tgz -> npmpkg-@types-estree-0.0.39.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/blockbench-types/-/blockbench-types-4.8.0.tgz -> npmpkg-blockbench-types-4.8.0.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/commander/-/commander-2.9.0.tgz -> npmpkg-commander-2.9.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/electron/-/electron-25.9.3.tgz -> npmpkg-electron-25.9.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/electron-color-picker/-/electron-color-picker-0.2.0.tgz -> npmpkg-electron-color-picker-0.2.0.tgz
https://registry.npmjs.org/electron-notarize/-/electron-notarize-1.2.2.tgz -> npmpkg-electron-notarize-1.2.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> npmpkg-isbinaryfile-3.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.1.tgz -> npmpkg-builder-util-runtime-9.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/semver/-/semver-7.0.0.tgz -> npmpkg-semver-7.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/three/-/three-0.129.0.tgz -> npmpkg-three-0.129.0.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/three/-/three-0.147.0.tgz -> npmpkg-three-0.147.0.tgz
https://registry.npmjs.org/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> npmpkg-@apideck-better-ajv-errors-0.3.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/source-map/-/source-map-0.8.0-beta.0.tgz -> npmpkg-source-map-0.8.0-beta.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/JannisX11/blockbench/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-app_cp_electron
	electron-builder -l dir || die
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.7.4 (20230528)
# preview (saved screenshot):  passed (vertically stacked rotated cubes)
