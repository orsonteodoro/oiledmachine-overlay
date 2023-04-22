# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="13.6.9"
ELECTRON_APP_VUE_PV="2.6.11"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_SKIP_EXIT_CODE_CHECK="1"
NODE_ENV="development"
NODE_VERSION="16" # 14
NPM_INSTALL_PATH="/opt/${PN}"
NPM_INSTALL_UNPACK_ARGS="--legacy-peer-deps"
PYTHON_COMPAT=( python3_{8..10} )

inherit desktop electron-app lcnr python-r1 npm

DESCRIPTION="Free, Cross-Platform, GPU-Accelerated Procedural Texture Generator"
HOMEPAGE="
https://njbrown.itch.io/texturelab
https://github.com/njbrown/texturelab
"

ELECTRON_CHROMEDRIVER_LICENSES="
	(
		custom
		( HPND all-rights-reserved )
		( MIT all-rights-reserved )
		( public-domain BSD )
		BSD
		CPL-1.0
		FTL
		GPL-3.0
		icu-1.8.1
		IJG
		ISC
		LGPL-2.1
		LGPL-3.0
		libpng
		libstdc++
		MIT
		MPL-1.1
		MPL-2.0
		openssl
		trio
		unicode
		ZLIB
		|| ( LGPL-2.1 LGPL-2.1+ )
	)
	( IJG BSD ZLIB )
	( ISC all-rights-reserved no-advertising )
	( HPND all-rights-reserved )
	( MIT all-rights-reserved )
	( UoI-NCSA MIT )
	( || ( LGPL-2.1+ GPL-2+ ) LGPL-2.1+ BSD MIT )
	all-rights-reserved
	custom
	android
	Apache-2.0
	APSL-2
	AFL-2.0
	BitstreamVera
	BSD
	BSD-2
	BSD-4
	BSD-Protection
	curl
	FTL
	GPL-2
	GPL-2-with-classpath-exception
	icu-71.1
	GPL-3
	libpng
	IJG
	ISC
	LGPL-2.1
	LGPL-3.0+
	MIT
	MPL-1.1
	MPL-2.0
	Ms-PL
	openssl
	OFL-1.1
	Prior-BSD-License
	SunPro
	unRAR
	UoI-NCSA
	libwebm-PATENTS
	|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )
"


THIRD_PARTY_LICENSES="
	${ELECTRON_APP_LICENSES}
	${ELECTRON_CHROMEDRIVER_LICENSES}
	( Apache-2.0 all-rights-reserved )
	( custom MIT all-rights-reserved )
	( custom MIT ( MIT all-rights-reserved ) )
	( custom OFL )
	( MIT all-rights-reserved )
	( MIT CC0-1.0 )
	( MIT svgo )
	( ISC CC-BY-SA-4.0 )
	( WTFPL-2 MIT )
	( MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement CC-BY-4.0 W3C-Software-and-Document-Notice-and-License )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC0-1.0
	custom
	ISC
	LGPL-3.0
	MagentaMgOpen
	MIT
	MPL-2.0
	Unlicense
	WTFPL-2
	|| ( BSD GPL-2 )
	|| ( ISC MIT )
	|| ( MIT GPL-3 )
"
LICENSE="
	GPL-3+
	${THIRD_PARTY_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( Apache-2.0 all-rights-reserved ) - node_modules/typescript/CopyrightNotice.txt
# ( custom, MIT, all-rights-reserved ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( MIT all-rights-reserved ) - node_modules/spdy-transport/node_modules/readable-stream/LICENSE
# ( MIT all-rights-reserved ) - texturelab-0.3.3/node_modules/convert-source-map/LICENSE
# ( MIT all-rights-reserved ) - node_modules/xml2js/LICENSE
# ( MIT all-rights-reserved ) - node_modules/http-parser-js/LICENSE.md
# ( MIT all-rights-reserved ) - node_modules/@types/eslint-visitor-keys/LICENSE
# ( MIT CC0-1.0 ) - node_modules/lodash.throttle/LICENSE
# ( ISC CC-BY-SA-4.0 ) - node_modules/glob/LICENSE
# ( WTFPL-2 MIT ) - node_modules/path-is-inside/LICENSE.txt
# ( MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement CC-BY-4.0 W3C-Software-and-Document-Notice-and-License ) - node_modules/typescript/ThirdPartyNoticeText.txt
# 0BSD - node_modules/tslib/LICENSE.txt
# Apache-2.0 - node_modules/watch/LICENSE
# BSD
# BSD-2 - node_modules/@vue/cli-plugin-eslint/node_modules/eslint-scope/LICENSE
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# CC0-1.0 - node_modules/csso/node_modules/mdn-data/LICENSE
# custom - node_modules/node-notifier/vendor/terminal-notifier-LICENSE
# custom, MIT, ( MIT all-rights-reserved ) - node_modules/image-q/LICENSE
#   search "indirectly, is granted, free of charge, a full and unrestricted irrevocable"
# custom [Free Font License], OFL - node_modules/image-q/demo/html/lib/webix/fonts/font-license.txt
# GPL-3+ - LICENSE
# ISC - node_modules/sharp/node_modules/semver/LICENSE
# LGPL-3.0 - node_modules/node-notifier/vendor/snoreToast/LICENSE
# MagentaMgOpen - node_modules/three-orbitcontrols-ts/node_modules/three/examples/fonts/LICENSE
# MIT
# MIT, svgo - node_modules/svgo/LICENSE
# MPL-2.0 - node_modules/webpack-chain/LICENSE
# Unlicense - node_modules/tweetnacl/LICENSE
# WTFPL-2 - node_modules/svg2png/LICENSE.txt
# || ( BSD GPL-2 ) - node_modules/node-forge/LICENSE
# || ( ISC MIT ) - node_modules/abbrev/LICENSE
# || ( MIT GPL-3 ) - node_modules/jszip/LICENSE.markdown

# custom \
#   ( HPND all-rights-reserved ) \
#   ( ISC all-rights-reserved no-advertising ) \
#   ( custom MPL-2.0 BSD || ( LGPL-2.1 LGPL-2.1+ ) GPL-3.0 LGPL-3.0 FTL MIT \
#     Mark's-copyright SGI-Free-B BSD LGPL-2 CPL-1.0 LGPL-2.1 icu-1.8.1 \
#     unicode ( MIT all-rights-reserved ) IJG ISC trio ZLIB openssl PCRE8[BSD] \
#     libpng libstdc++ ( public-domain BSD ) ( HPND all-rights-reserved ) \
#     MPL-1.1 ) \
#   ( MIT all-rights-reserved ) \
#   ( UoI-NCSA MIT ) \
#   ( IJG BSD ZLIB ) \
#   ( || ( LGPL-2.1+ GPL-2+ ) LGPL-2.1+ BSD MIT ) \
#   all-rights-reserved \
#   custom \
#     search: "to anyone/anything when using this software" \
#     search: "license to install, copy and use the SDK solely as necessary for" \
#     search: "and this permission notice appear in all copies, and that the names of" \
#     search: "all paragraphs of this notice appear in all copies, and that the" \
#     search: "copyright notice and this permission notice appear in all copies, and that" \
#   android \
#   Apache-2.0 \
#   APSL-2 \
#   AFL-2.0 (Academic Free License) \
#   BitstreamVera \
#   BSD \
#   BSD-2 \
#   BSD-4 \
#   BSD-Protection \
#   CC∅ Public Domain Affirmation and Waiver 1.0 - https://www.creativecommons.org/licenses/zero-waive/1.0/us/legalcode \
#   curl \
#   FTL \
#   GPL-2 \
#   GPL-2-with-classpath-exception \
#   icu-71.1 \
#   GPL-3 \
#   libpng \
#   IJG \
#   ISC \
#   LGPL-2.1 \
#   LGPL-3.0+ \
#   MIT \
#   MPL-1.1 \
#   MPL-2.0 \
#   Ms-PL \
#   newlib-extras \
#   openssl \
#   OFL-1.1 \
#   Prior-BSD-License \
#   SunPro \
#   unRAR \
#   UoI-NCSA \
#   libwebm-PATENTS \
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   node_modules/electron-chromedriver/bin/LICENSES.chromium.html

KEYWORDS="~amd64"
SLOT="0"
IUSE+=" system-vips r2"
REQUIRED_USE="
!wayland X
"
# wayland error:  /usr/bin/texturelab: line 13: 2993280 Trace/breakpoint trap
SHARP_DEPENDS="
	>=net-libs/nodejs-14.15:${NODE_VERSION}
	system-vips? (
		>=media-libs/vips-8.13.3[png,jpeg,tiff]
	)
" # For vips version see https://github.com/lovell/sharp/blob/main/package.json#L158
RDEPEND+="
	${SHARP_DEPENDS}
"
RDEPEND+="
	${DEPEND}
"
NODE_GYP_BDEPENDS="
	${PYTHON_DEPS}
	sys-devel/gcc
	sys-devel/make
"
BDEPEND+="
	${NODE_GYP_BDEPENDS}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
TEXTURELABDATA_COMMIT="eed449f3f9abe8f17ae354ab4cb9932272c7811b"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/texturelab-0.3.3/work/texturelab-0.3.3/npm.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/core/-/core-7.21.4.tgz -> npmpkg-@babel-core-7.21.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@electron/remote/-/remote-1.2.2.tgz -> npmpkg-@electron-remote-1.2.2.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@petamoriken/float16/-/float16-3.8.0.tgz -> npmpkg-@petamoriken-float16-3.8.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/electron/-/electron-3.0.8.tgz -> npmpkg-@sentry-electron-3.0.8.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/webpack-plugin/-/webpack-plugin-1.20.0.tgz -> npmpkg-@sentry-webpack-plugin-1.20.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@types/adm-zip/-/adm-zip-0.4.34.tgz -> npmpkg-@types-adm-zip-0.4.34.tgz
https://registry.npmjs.org/@types/jest/-/jest-23.3.14.tgz -> npmpkg-@types-jest-23.3.14.tgz
https://registry.npmjs.org/@types/jquery/-/jquery-3.5.16.tgz -> npmpkg-@types-jquery-3.5.16.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.23.tgz -> npmpkg-@types-node-16.18.23.tgz
https://registry.npmjs.org/@types/pngjs/-/pngjs-6.0.1.tgz -> npmpkg-@types-pngjs-6.0.1.tgz
https://registry.npmjs.org/@types/sharp/-/sharp-0.29.5.tgz -> npmpkg-@types-sharp-0.29.5.tgz
https://registry.npmjs.org/@types/three/-/three-0.103.2.tgz -> npmpkg-@types-three-0.103.2.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-2.34.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-2.34.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-2.34.0.tgz -> npmpkg-@typescript-eslint-parser-2.34.0.tgz
https://registry.npmjs.org/@vue/cli-plugin-babel/-/cli-plugin-babel-3.12.1.tgz -> npmpkg-@vue-cli-plugin-babel-3.12.1.tgz
https://registry.npmjs.org/@vue/cli-plugin-eslint/-/cli-plugin-eslint-3.12.1.tgz -> npmpkg-@vue-cli-plugin-eslint-3.12.1.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-3.0.1.tgz -> npmpkg-acorn-jsx-3.0.1.tgz
https://registry.npmjs.org/acorn/-/acorn-3.3.0.tgz -> npmpkg-acorn-3.3.0.tgz
https://registry.npmjs.org/ajv/-/ajv-5.5.2.tgz -> npmpkg-ajv-5.5.2.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-2.1.1.tgz -> npmpkg-ajv-keywords-2.1.1.tgz
https://registry.npmjs.org/chardet/-/chardet-0.4.2.tgz -> npmpkg-chardet-0.4.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/eslint/-/eslint-4.19.1.tgz -> npmpkg-eslint-4.19.1.tgz
https://registry.npmjs.org/eslint-plugin-vue/-/eslint-plugin-vue-4.7.1.tgz -> npmpkg-eslint-plugin-vue-4.7.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-3.7.3.tgz -> npmpkg-eslint-scope-3.7.3.tgz
https://registry.npmjs.org/espree/-/espree-3.5.4.tgz -> npmpkg-espree-3.5.4.tgz
https://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz -> npmpkg-external-editor-2.2.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz -> npmpkg-fast-deep-equal-1.1.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-2.0.0.tgz -> npmpkg-file-entry-cache-2.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-1.3.4.tgz -> npmpkg-flat-cache-1.3.4.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/inquirer/-/inquirer-3.3.0.tgz -> npmpkg-inquirer-3.3.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz -> npmpkg-json-schema-traverse-0.3.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/regexpp/-/regexpp-1.1.0.tgz -> npmpkg-regexpp-1.1.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz -> npmpkg-rimraf-2.6.3.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-1.0.0.tgz -> npmpkg-slice-ansi-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/table/-/table-4.0.2.tgz -> npmpkg-table-4.0.2.tgz
https://registry.npmjs.org/vue-eslint-parser/-/vue-eslint-parser-2.0.3.tgz -> npmpkg-vue-eslint-parser-2.0.3.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/write/-/write-0.2.1.tgz -> npmpkg-write-0.2.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/@vue/cli-plugin-typescript/-/cli-plugin-typescript-3.12.1.tgz -> npmpkg-@vue-cli-plugin-typescript-3.12.1.tgz
https://registry.npmjs.org/@vue/cli-plugin-unit-jest/-/cli-plugin-unit-jest-3.12.1.tgz -> npmpkg-@vue-cli-plugin-unit-jest-3.12.1.tgz
https://registry.npmjs.org/@vue/cli-service/-/cli-service-3.12.1.tgz -> npmpkg-@vue-cli-service-3.12.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/@vue/eslint-config-prettier/-/eslint-config-prettier-4.0.1.tgz -> npmpkg-@vue-eslint-config-prettier-4.0.1.tgz
https://registry.npmjs.org/prettier/-/prettier-1.19.1.tgz -> npmpkg-prettier-1.19.1.tgz
https://registry.npmjs.org/@vue/eslint-config-typescript/-/eslint-config-typescript-4.0.0.tgz -> npmpkg-@vue-eslint-config-typescript-4.0.0.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-1.13.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-1.13.0.tgz
https://registry.npmjs.org/@typescript-eslint/experimental-utils/-/experimental-utils-1.13.0.tgz -> npmpkg-@typescript-eslint-experimental-utils-1.13.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-1.13.0.tgz -> npmpkg-@typescript-eslint-parser-1.13.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-1.13.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-1.13.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-1.4.3.tgz -> npmpkg-eslint-utils-1.4.3.tgz
https://registry.npmjs.org/regexpp/-/regexpp-2.0.1.tgz -> npmpkg-regexpp-2.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.5.0.tgz -> npmpkg-semver-5.5.0.tgz
https://registry.npmjs.org/@vue/test-utils/-/test-utils-1.0.0-beta.29.tgz -> npmpkg-@vue-test-utils-1.0.0-beta.29.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.4.16.tgz -> npmpkg-adm-zip-0.4.16.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.0.3.tgz -> npmpkg-7zip-bin-5.0.3.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.6.2.tgz -> npmpkg-tar-stream-1.6.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.0.0.tgz -> npmpkg-camelcase-5.0.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz -> npmpkg-inherits-2.0.1.tgz
https://registry.npmjs.org/util/-/util-0.10.3.tgz -> npmpkg-util-0.10.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz -> npmpkg-js-tokens-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-7.0.0-bridge.0.tgz -> npmpkg-babel-core-7.0.0-bridge.0.tgz
https://registry.npmjs.org/babel-eslint/-/babel-eslint-10.1.0.tgz -> npmpkg-babel-eslint-10.1.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-1.3.0.tgz -> npmpkg-jsesc-1.3.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/babel-helpers/-/babel-helpers-6.24.1.tgz -> npmpkg-babel-helpers-6.24.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/babel-register/-/babel-register-6.26.0.tgz -> npmpkg-babel-register-6.26.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.4.18.tgz -> npmpkg-source-map-support-0.4.18.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/globals/-/globals-9.18.0.tgz -> npmpkg-globals-9.18.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-2.1.2.tgz -> npmpkg-array-flatten-2.1.2.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz -> npmpkg-type-fest-0.3.1.tgz
https://registry.npmjs.org/boxicons/-/boxicons-2.1.4.tgz -> npmpkg-boxicons-2.1.4.tgz
https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz -> npmpkg-resolve-1.1.7.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.0.3.tgz -> npmpkg-7zip-bin-5.0.3.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-3.4.3.tgz -> npmpkg-app-builder-bin-3.4.3.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/ssri/-/ssri-5.3.0.tgz -> npmpkg-ssri-5.3.0.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/bytes/-/bytes-3.0.0.tgz -> npmpkg-bytes-3.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> npmpkg-find-cache-dir-1.0.0.tgz
https://registry.npmjs.org/globby/-/globby-7.1.1.tgz -> npmpkg-globby-7.1.1.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/css-tree/-/css-tree-1.1.3.tgz -> npmpkg-css-tree-1.1.3.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.14.tgz -> npmpkg-mdn-data-2.0.14.tgz
https://registry.npmjs.org/custom-electron-titlebar/-/custom-electron-titlebar-3.2.10.tgz -> npmpkg-custom-electron-titlebar-3.2.10.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/dedent-js/-/dedent-js-1.0.1.tgz -> npmpkg-dedent-js-1.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/execa/-/execa-3.4.0.tgz -> npmpkg-execa-3.4.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/p-finally/-/p-finally-2.0.1.tgz -> npmpkg-p-finally-2.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.2.12.tgz -> npmpkg-fast-glob-3.2.12.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.5.2.tgz -> npmpkg-iconv-lite-0.5.2.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/electron/-/electron-13.6.9.tgz -> npmpkg-electron-13.6.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/electron-devtools-installer/-/electron-devtools-installer-3.2.0.tgz -> npmpkg-electron-devtools-installer-3.2.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/env-paths/-/env-paths-1.0.0.tgz -> npmpkg-env-paths-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-4.0.3.tgz -> npmpkg-fs-extra-4.0.3.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-2.0.2.tgz -> npmpkg-sumchecker-2.0.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/electron-icon-builder/-/electron-icon-builder-2.0.1.tgz -> npmpkg-electron-icon-builder-2.0.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/electron-settings/-/electron-settings-4.0.2.tgz -> npmpkg-electron-settings-4.0.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/@types/node/-/node-14.18.42.tgz -> npmpkg-@types-node-14.18.42.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-1.4.3.tgz -> npmpkg-eslint-utils-1.4.3.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/regexpp/-/regexpp-2.0.1.tgz -> npmpkg-regexpp-2.0.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/cookie/-/cookie-0.5.0.tgz -> npmpkg-cookie-0.5.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> npmpkg-path-to-regexp-0.1.7.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz -> npmpkg-rimraf-2.6.3.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.8.tgz -> npmpkg-minimatch-3.0.8.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> npmpkg-home-or-tmp-2.0.0.tgz
https://registry.npmjs.org/big.js/-/big.js-3.2.0.tgz -> npmpkg-big.js-3.2.0.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-2.1.0.tgz -> npmpkg-emojis-list-2.1.0.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-0.2.17.tgz -> npmpkg-loader-utils-0.2.17.tgz
https://registry.npmjs.org/human-signals/-/human-signals-1.1.1.tgz -> npmpkg-human-signals-1.1.1.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/@types/node/-/node-16.9.1.tgz -> npmpkg-@types-node-16.9.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/indexes-of/-/indexes-of-1.0.1.tgz -> npmpkg-indexes-of-1.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/default-gateway/-/default-gateway-4.2.0.tgz -> npmpkg-default-gateway-4.2.0.tgz
https://registry.npmjs.org/invert-kv/-/invert-kv-2.0.0.tgz -> npmpkg-invert-kv-2.0.0.tgz
https://registry.npmjs.org/ip-regex/-/ip-regex-2.1.0.tgz -> npmpkg-ip-regex-2.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-1.0.1.tgz -> npmpkg-is-path-inside-1.0.1.tgz
https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz -> npmpkg-is-path-in-cwd-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-2.1.0.tgz -> npmpkg-is-path-inside-2.1.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/has-flag/-/has-flag-1.0.0.tgz -> npmpkg-has-flag-1.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-3.2.3.tgz -> npmpkg-supports-color-3.2.3.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-4.1.0.tgz -> npmpkg-cliui-4.1.0.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-1.0.3.tgz -> npmpkg-get-caller-file-1.0.3.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> npmpkg-wrap-ansi-2.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-11.1.1.tgz -> npmpkg-yargs-11.1.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-9.0.2.tgz -> npmpkg-yargs-parser-9.0.2.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-4.1.0.tgz -> npmpkg-cliui-4.1.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-1.0.3.tgz -> npmpkg-get-caller-file-1.0.3.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> npmpkg-wrap-ansi-2.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-11.1.1.tgz -> npmpkg-yargs-11.1.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-9.0.2.tgz -> npmpkg-yargs-parser-9.0.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/parse5/-/parse5-4.0.0.tgz -> npmpkg-parse5-4.0.0.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/klaw/-/klaw-1.3.1.tgz -> npmpkg-klaw-1.3.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/lcid/-/lcid-2.0.0.tgz -> npmpkg-lcid-2.0.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-0.1.1.tgz -> npmpkg-find-cache-dir-0.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-1.0.0.tgz -> npmpkg-pkg-dir-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/map-age-cleaner/-/map-age-cleaner-0.1.3.tgz -> npmpkg-map-age-cleaner-0.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/mem/-/mem-4.3.0.tgz -> npmpkg-mem-4.3.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-1.9.1.tgz -> npmpkg-normalize-url-1.9.1.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-1.0.4.tgz -> npmpkg-prepend-http-1.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/buffer/-/buffer-4.9.2.tgz -> npmpkg-buffer-4.9.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz -> npmpkg-throttleit-0.0.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz -> npmpkg-minimist-0.0.10.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz -> npmpkg-wordwrap-0.0.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-locale/-/os-locale-3.1.0.tgz -> npmpkg-os-locale-3.1.0.tgz
https://registry.npmjs.org/p-defer/-/p-defer-1.0.0.tgz -> npmpkg-p-defer-1.0.0.tgz
https://registry.npmjs.org/p-is-promise/-/p-is-promise-2.1.0.tgz -> npmpkg-p-is-promise-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-1.0.0.tgz -> npmpkg-fs-extra-1.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-2.4.0.tgz -> npmpkg-jsonfile-2.4.0.tgz
https://registry.npmjs.org/progress/-/progress-1.1.8.tgz -> npmpkg-progress-1.1.8.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-3.3.0.tgz -> npmpkg-normalize-url-3.3.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.1.tgz -> npmpkg-detect-libc-2.0.1.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz -> npmpkg-readable-stream-1.1.14.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/through2/-/through2-0.2.3.tgz -> npmpkg-through2-0.2.3.tgz
https://registry.npmjs.org/xtend/-/xtend-2.1.2.tgz -> npmpkg-xtend-2.1.2.tgz
https://registry.npmjs.org/object-keys/-/object-keys-0.4.0.tgz -> npmpkg-object-keys-0.4.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/query-string/-/query-string-4.3.4.tgz -> npmpkg-query-string-4.3.4.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/react-dom/-/react-dom-16.14.0.tgz -> npmpkg-react-dom-16.14.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.6.0.tgz -> npmpkg-dotenv-8.6.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/caller-path/-/caller-path-0.1.0.tgz -> npmpkg-caller-path-0.1.0.tgz
https://registry.npmjs.org/callsites/-/callsites-0.2.0.tgz -> npmpkg-callsites-0.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-1.0.1.tgz -> npmpkg-resolve-from-1.0.1.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.3.tgz -> npmpkg-http-errors-1.6.3.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.1.0.tgz -> npmpkg-setprototypeof-1.1.0.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-1.1.2.tgz -> npmpkg-sort-keys-1.1.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/strict-uri-encode/-/strict-uri-encode-1.1.0.tgz -> npmpkg-strict-uri-encode-1.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-3.0.0.tgz -> npmpkg-camelcase-3.0.0.tgz
https://registry.npmjs.org/cliui/-/cliui-3.2.0.tgz -> npmpkg-cliui-3.2.0.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-1.0.3.tgz -> npmpkg-get-caller-file-1.0.3.tgz
https://registry.npmjs.org/invert-kv/-/invert-kv-1.0.0.tgz -> npmpkg-invert-kv-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/lcid/-/lcid-1.0.0.tgz -> npmpkg-lcid-1.0.0.tgz
https://registry.npmjs.org/os-locale/-/os-locale-1.4.0.tgz -> npmpkg-os-locale-1.4.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/which-module/-/which-module-1.0.0.tgz -> npmpkg-which-module-1.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> npmpkg-wrap-ansi-2.1.0.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-6.6.0.tgz -> npmpkg-yargs-6.6.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-4.2.1.tgz -> npmpkg-yargs-parser-4.2.1.tgz
https://registry.npmjs.org/css-select/-/css-select-2.1.0.tgz -> npmpkg-css-select-2.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-3.4.2.tgz -> npmpkg-css-what-3.4.2.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.2.2.tgz -> npmpkg-dom-serializer-0.2.2.tgz
https://registry.npmjs.org/domutils/-/domutils-1.7.0.tgz -> npmpkg-domutils-1.7.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-1.0.2.tgz -> npmpkg-nth-check-1.0.2.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/execa/-/execa-0.7.0.tgz -> npmpkg-execa-0.7.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/mississippi/-/mississippi-3.0.0.tgz -> npmpkg-mississippi-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://github.com/nicolaspanel/three-orbitcontrols-ts/archive/b5b2685a88b880822c62275f2a76bdaa3954f76c.tar.gz -> npmpkg-three-orbitcontrols-ts.git-b5b2685a88b880822c62275f2a76bdaa3954f76c.tgz
https://registry.npmjs.org/three/-/three-0.94.0.tgz -> npmpkg-three-0.94.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tsutils/-/tsutils-2.29.0.tgz -> npmpkg-tsutils-2.29.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/typeface-open-sans/-/typeface-open-sans-0.0.75.tgz -> npmpkg-typeface-open-sans-0.0.75.tgz
https://registry.npmjs.org/commander/-/commander-2.19.0.tgz -> npmpkg-commander-2.19.0.tgz
https://registry.npmjs.org/uniq/-/uniq-1.0.1.tgz -> npmpkg-uniq-1.0.1.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz -> npmpkg-punycode-1.3.2.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/vue/-/vue-2.6.11.tgz -> npmpkg-vue-2.6.11.tgz
https://registry.npmjs.org/vue-class-component/-/vue-class-component-7.2.6.tgz -> npmpkg-vue-class-component-7.2.6.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-1.5.2.tgz -> npmpkg-deepmerge-1.5.2.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/javascript-stringify/-/javascript-stringify-2.1.0.tgz -> npmpkg-javascript-stringify-2.1.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/webpack-chain/-/webpack-chain-5.2.4.tgz -> npmpkg-webpack-chain-5.2.4.tgz
https://registry.npmjs.org/yargs/-/yargs-14.2.3.tgz -> npmpkg-yargs-14.2.3.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-15.0.3.tgz -> npmpkg-yargs-parser-15.0.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/espree/-/espree-4.1.0.tgz -> npmpkg-espree-4.1.0.tgz
https://registry.npmjs.org/vue-class-component/-/vue-class-component-6.3.2.tgz -> npmpkg-vue-class-component-6.3.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/vue-router/-/vue-router-3.3.4.tgz -> npmpkg-vue-router-3.3.4.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.6.11.tgz -> npmpkg-vue-template-compiler-2.6.11.tgz
https://registry.npmjs.org/vue-toast-notification/-/vue-toast-notification-0.6.2.tgz -> npmpkg-vue-toast-notification-0.6.2.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-2.0.1.tgz -> npmpkg-deepmerge-2.0.1.tgz
https://registry.npmjs.org/ejs/-/ejs-2.5.9.tgz -> npmpkg-ejs-2.5.9.tgz
https://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz -> npmpkg-external-editor-2.2.0.tgz
https://registry.npmjs.org/chardet/-/chardet-0.4.2.tgz -> npmpkg-chardet-0.4.2.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/has-flag/-/has-flag-2.0.0.tgz -> npmpkg-has-flag-2.0.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-3.3.0.tgz -> npmpkg-inquirer-3.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.0.1.tgz -> npmpkg-supports-color-5.0.1.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.2.0.tgz -> npmpkg-acorn-walk-7.2.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-1.5.2.tgz -> npmpkg-deepmerge-1.5.2.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/del/-/del-4.1.1.tgz -> npmpkg-del-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/globby/-/globby-6.1.0.tgz -> npmpkg-globby-6.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-2.0.0.tgz -> npmpkg-import-local-2.0.0.tgz
https://registry.npmjs.org/is-absolute-url/-/is-absolute-url-3.0.3.tgz -> npmpkg-is-absolute-url-3.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.8.0.tgz -> npmpkg-execa-0.8.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-1.0.0.tgz -> npmpkg-normalize-path-1.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
PHANTOMJS_PV="2.1.1"
SENTRY_CLI_PV="1.75.0"
SHARP_PV=""
VIPS_PV="8.11.3"
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/njbrown/texturelab/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
https://github.com/njbrown/texturelabdata/archive/${TEXTURELABDATA_COMMIT}.tar.gz
	-> ${PN}data-${TEXTURELABDATA_COMMIT:0:7}.tar.gz
https://github.com/Medium/phantomjs/releases/download/v${PHANTOMJS_PV}/phantomjs-${PHANTOMJS_PV}-linux-x86_64.tar.bz2
https://downloads.sentry-cdn.com/sentry-cli/${SENTRY_CLI_PV}/sentry-cli-Linux-x86_64 -> sentry-cli-Linux-x86_64.${SENTRY_CLI_PV}
https://github.com/lovell/sharp-libvips/releases/download/v${VIPS_PV}/libvips-${VIPS_PV}-linux-x64.tar.br
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
MY_PN="TextureLab"

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download micropackages and obtain version releases"
eerror "information."
eerror
		die
	fi
}

pkg_setup() {
	if use system-vips ; then
		if has_version "media-libs/vips[-graphicsmagick,-imagemagick]" ; then
eerror
eerror "media-libs/vips requires imagemagick or graphicsmagick USE flag"
eerror
			die
		fi
	fi

	# Online is still required for Electron based packages.
	check_network_sandbox

	npm_pkg_setup
}

cp_sentry_cli() {
	local dest
	local arch
	local plat
	local suffix
	# See https://github.com/getsentry/sentry-cli/releases/tag/1.17.0
	if use kernel_linux ; then
		plat="Linux"
	elif use kernel_Darwin ; then
		plat="Darwin"
	elif use kernel_Winnt ; then
		plat="Windows"
		suffix=".exe"
	fi
	if use amd64 || use x64-macos ; then
		arch="x86_64"
	elif use x86 || use x86-winnt ; then
		arch="i686"
	fi
	export SENTRYCLI_USE_LOCAL=1
	dest="${WORKDIR}/bin"
	mkdir -p "${dest}"
	export PATH="${dest}:${PATH}"
	cat \
		"${DISTDIR}/sentry-cli-${plat}-${arch}.${SENTRY_CLI_PV}" \
		> \
		"${dest}/sentry-cli" \
		|| die
	chmod +x "${dest}/sentry-cli"
}

cp_phantomjs() {
	local dest
	dest="${T}/phantomjs"
	# https://github.com/Medium/phantomjs/releases/tag/v2.1.1
	local plat
	local zip_format
	if use kernel_linux ; then
		plat="linux"
	elif use kernel_Darwin ; then
		plat="macosx"
	elif use kernel_Winnt ; then
		plat="windows"
	fi
	if use kernel_linux && use amd64 ; then
		arch="-x86_64"
	elif use kernel_linux && use x86 ; then
		arch="-i686"
	fi
	if use kernel_Winnt ; then
		zip_format="zip"
	else
		zip_format="tar.bz2"
	fi
	mkdir -p "${dest}" || die
	cp -a \
		"${DISTDIR}/phantomjs-${PHANTOMJS_PV}-${plat}${arch}.${zip_format}" \
		"${dest}" \
		|| die
}

cp_assets() {
	local dest
	dest="${S}/public/assets"
	cd "${WORKDIR}" || die
	unpack "${PN}data-${TEXTURELABDATA_COMMIT:0:7}.tar.gz"
	rm -rf "${dest}" || die
	mkdir -p "${dest}" || die
	cp -aT \
		"${WORKDIR}/${PN}data-${TEXTURELABDATA_COMMIT}" \
		"${dest}" \
		|| die
}

cp_sharp_deps() {
	local dest
	dest="${T}/sharp-deps"
#	export sharp_libvips_local_prebuilds="${T}/sharp-deps"
	mkdir -p "${dest}" || die
#	cat \
#		"${DISTDIR}/libvips-${VIPS_PV}-linux-x64.tar.br" \
#		> \
#		"${dest}/libvips-${VIPS_PV}-linux-x64.tar.br" \
#		|| die

	export sharp_local_prebuilds="${T}/sharp-deps"
	mkdir -p "${dest}" || die
	cat \
		"${DISTDIR}/libvips-${VIPS_PV}-linux-x64.tar.br" \
		> \
		"${dest}/libvips-${VIPS_PV}-linux-x64.tar.br" \
		|| die
}

add_deps() {
	cd "${S}" || die
	export SHARP_IGNORE_GLOBAL_LIBVIPS=1
	if use system-vips ; then
		export SHARP_IGNORE_GLOBAL_LIBVIPS=0
		#enpm add "node-gyp@9.3.1"
	fi
}

src_unpack() {
        if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
                unpack ${P}.tar.gz
                cd "${S}" || die
                rm package-lock.json
		rm yarn.lock

		enpm install --legacy-peer-deps
		enpm audit fix --legacy-peer-deps

	# Fix the following upgrade breakage manually by downgrading:

	# Change to ^2.6.10 afterwards.
		enpm install "vue@2.6.11" --legacy-peer-deps # Exact version in upstream lockfile

	# Change to ^2.6.10 afterwards.
		enpm install "vue-template-compiler@2.6.11" --legacy-peer-deps # Exact version in upstream lockfile

	# Change to ^3.0.3 afterwards.
		enpm install "vue-router@3.3.4" --legacy-peer-deps # Exact version in upstream lockfile

	# Change to ^0.6.2 afterwards.
		enpm install "vue-toast-notification@0.6.2" --legacy-peer-deps # Exact version in upstream lockfile

		die
        else
		#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		mkdir -p "${S}" || die
		cp -a "${FILESDIR}/${PV}/package.json" "${S}" || die
		cp_sharp_deps
		cp_phantomjs
		cp_sentry_cli
		npm_src_unpack
		cp_assets
		add_deps
        fi
}

src_prepare() {
	default
	cd "${S}" || die
	if use system-vips ; then
		eapply "${FILESDIR}/texturelab-0.3.3-node-gyp-openssl_fips.patch"
		export ELECTRON_APP_SKIP_EXIT_CODE_CHECK=0
	fi
}

src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	NODE_VERSION="16"
	export ELECTRON_OVERRIDE_DIST_PATH="${S}/node_modules/.bin/electron"
	electron-app_cp_electron
	enpm run electron:build --publish=never
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist_electron/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/texturelab"
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "src/assets/logo.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Graphics;2DGraphics"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
