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
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.3.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.23.0.tgz -> npmpkg-@babel-helper-module-transforms-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> npmpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.0.tgz -> npmpkg-@babel-parser-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-async-generator-functions-7.20.7.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-json-strings-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-object-rest-spread-7.20.7.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.15.tgz -> npmpkg-@babel-plugin-transform-parameters-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-optional-catch-binding-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.0.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.22.15.tgz -> npmpkg-@babel-plugin-transform-classes-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.0.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.22.5.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.22.15.tgz -> npmpkg-@babel-plugin-transform-for-of-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.22.5.tgz -> npmpkg-@babel-plugin-transform-function-name-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.22.5.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.22.5.tgz -> npmpkg-@babel-plugin-transform-new-target-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.22.5.tgz -> npmpkg-@babel-plugin-transform-object-super-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.22.10.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.23.2.tgz -> npmpkg-@babel-plugin-transform-runtime-7.23.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.22.5.tgz -> npmpkg-@babel-plugin-transform-spread-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.22.5.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.3.4.tgz -> npmpkg-@babel-preset-env-7.3.4.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.15.tgz -> npmpkg-@babel-plugin-transform-parameters-7.22.15.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.2.tgz -> npmpkg-@babel-traverse-7.23.2.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/@sentry/utils/-/utils-6.19.2.tgz -> npmpkg-@sentry-utils-6.19.2.tgz
https://registry.npmjs.org/@sentry/hub/-/hub-6.19.2.tgz -> npmpkg-@sentry-hub-6.19.2.tgz
https://registry.npmjs.org/@sentry/minimal/-/minimal-6.19.2.tgz -> npmpkg-@sentry-minimal-6.19.2.tgz
https://registry.npmjs.org/@sentry/utils/-/utils-6.19.2.tgz -> npmpkg-@sentry-utils-6.19.2.tgz
https://registry.npmjs.org/@sentry/utils/-/utils-6.19.2.tgz -> npmpkg-@sentry-utils-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/@sentry/hub/-/hub-6.19.2.tgz -> npmpkg-@sentry-hub-6.19.2.tgz
https://registry.npmjs.org/@sentry/utils/-/utils-6.19.2.tgz -> npmpkg-@sentry-utils-6.19.2.tgz
https://registry.npmjs.org/cookie/-/cookie-0.4.2.tgz -> npmpkg-cookie-0.4.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/lru_map/-/lru_map-0.3.3.tgz -> npmpkg-lru_map-0.3.3.tgz
https://registry.npmjs.org/@sentry/cli/-/cli-1.75.2.tgz -> npmpkg-@sentry-cli-1.75.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/@types/eslint-visitor-keys/-/eslint-visitor-keys-1.0.0.tgz -> npmpkg-@types-eslint-visitor-keys-1.0.0.tgz
https://registry.npmjs.org/@types/jest/-/jest-23.3.14.tgz -> npmpkg-@types-jest-23.3.14.tgz
https://registry.npmjs.org/@types/jquery/-/jquery-3.5.25.tgz -> npmpkg-@types-jquery-3.5.25.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.59.tgz -> npmpkg-@types-node-16.18.59.tgz
https://registry.npmjs.org/@types/pngjs/-/pngjs-6.0.3.tgz -> npmpkg-@types-pngjs-6.0.3.tgz
https://registry.npmjs.org/@types/sharp/-/sharp-0.29.5.tgz -> npmpkg-@types-sharp-0.29.5.tgz
https://registry.npmjs.org/@types/three/-/three-0.103.2.tgz -> npmpkg-@types-three-0.103.2.tgz
https://registry.npmjs.org/regexpp/-/regexpp-3.2.0.tgz -> npmpkg-regexpp-3.2.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-2.34.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-2.34.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-2.34.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-2.34.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-1.13.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-1.13.0.tgz
https://registry.npmjs.org/semver/-/semver-5.5.0.tgz -> npmpkg-semver-5.5.0.tgz
https://registry.npmjs.org/@vue/babel-preset-app/-/babel-preset-app-3.12.1.tgz -> npmpkg-@vue-babel-preset-app-3.12.1.tgz
https://registry.npmjs.org/@vue/babel-plugin-transform-vue-jsx/-/babel-plugin-transform-vue-jsx-1.4.0.tgz -> npmpkg-@vue-babel-plugin-transform-vue-jsx-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-composition-api-inject-h/-/babel-sugar-composition-api-inject-h-1.4.0.tgz -> npmpkg-@vue-babel-sugar-composition-api-inject-h-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-composition-api-render-instance/-/babel-sugar-composition-api-render-instance-1.4.0.tgz -> npmpkg-@vue-babel-sugar-composition-api-render-instance-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-functional-vue/-/babel-sugar-functional-vue-1.4.0.tgz -> npmpkg-@vue-babel-sugar-functional-vue-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-inject-h/-/babel-sugar-inject-h-1.4.0.tgz -> npmpkg-@vue-babel-sugar-inject-h-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-v-model/-/babel-sugar-v-model-1.4.0.tgz -> npmpkg-@vue-babel-sugar-v-model-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-v-on/-/babel-sugar-v-on-1.4.0.tgz -> npmpkg-@vue-babel-sugar-v-on-1.4.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz -> npmpkg-@babel-core-7.23.2.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.23.2.tgz -> npmpkg-@babel-helpers-7.23.2.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.3.0.tgz -> npmpkg-babel-loader-8.3.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint/-/eslint-4.19.1.tgz -> npmpkg-eslint-4.19.1.tgz
https://registry.npmjs.org/eslint-plugin-vue/-/eslint-plugin-vue-4.7.1.tgz -> npmpkg-eslint-plugin-vue-4.7.1.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-23.6.0.tgz -> npmpkg-babel-jest-23.6.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> npmpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.npmjs.org/jest-serializer-vue/-/jest-serializer-vue-2.0.2.tgz -> npmpkg-jest-serializer-vue-2.0.2.tgz
https://registry.npmjs.org/jest-transform-stub/-/jest-transform-stub-2.0.0.tgz -> npmpkg-jest-transform-stub-2.0.0.tgz
https://registry.npmjs.org/@vue/cli-overlay/-/cli-overlay-3.12.1.tgz -> npmpkg-@vue-cli-overlay-3.12.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/thread-loader/-/thread-loader-2.1.3.tgz -> npmpkg-thread-loader-2.1.3.tgz
https://registry.npmjs.org/@vue/cli-shared-utils/-/cli-shared-utils-3.12.1.tgz -> npmpkg-@vue-cli-shared-utils-3.12.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/merge-source-map/-/merge-source-map-1.1.0.tgz -> npmpkg-merge-source-map-1.1.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.13.tgz -> npmpkg-postcss-selector-parser-6.0.13.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-1.13.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-1.13.0.tgz
https://registry.npmjs.org/@typescript-eslint/experimental-utils/-/experimental-utils-1.13.0.tgz -> npmpkg-@typescript-eslint-experimental-utils-1.13.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-1.13.0.tgz -> npmpkg-@typescript-eslint-parser-1.13.0.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.4.16.tgz -> npmpkg-adm-zip-0.4.16.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/babel-core/-/babel-core-7.0.0-bridge.0.tgz -> npmpkg-babel-core-7.0.0-bridge.0.tgz
https://registry.npmjs.org/babel-eslint/-/babel-eslint-10.1.0.tgz -> npmpkg-babel-eslint-10.1.0.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.6.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.6.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.6.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.3.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.3.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/boxicons/-/boxicons-2.1.4.tgz -> npmpkg-boxicons-2.1.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-3.4.3.tgz -> npmpkg-app-builder-bin-3.4.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.33.1.tgz -> npmpkg-core-js-compat-3.33.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> npmpkg-cosmiconfig-5.2.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-2.0.0.tgz -> npmpkg-import-fresh-2.0.0.tgz
https://registry.npmjs.org/custom-electron-titlebar/-/custom-electron-titlebar-3.2.10.tgz -> npmpkg-custom-electron-titlebar-3.2.10.tgz
https://registry.npmjs.org/dedent-js/-/dedent-js-1.0.1.tgz -> npmpkg-dedent-js-1.0.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/electron-icon-builder/-/electron-icon-builder-2.0.1.tgz -> npmpkg-electron-icon-builder-2.0.1.tgz
https://registry.npmjs.org/element-resize-detector/-/element-resize-detector-1.2.4.tgz -> npmpkg-element-resize-detector-1.2.4.tgz
https://registry.npmjs.org/eslint-plugin-vue/-/eslint-plugin-vue-5.2.3.tgz -> npmpkg-eslint-plugin-vue-5.2.3.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-1.4.3.tgz -> npmpkg-eslint-utils-1.4.3.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/fast-png/-/fast-png-5.0.4.tgz -> npmpkg-fast-png-5.0.4.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-0.5.2.tgz -> npmpkg-fork-ts-checker-webpack-plugin-0.5.2.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/globby/-/globby-9.2.0.tgz -> npmpkg-globby-9.2.0.tgz
https://registry.npmjs.org/html-tags/-/html-tags-2.0.0.tgz -> npmpkg-html-tags-2.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/jest/-/jest-23.6.0.tgz -> npmpkg-jest-23.6.0.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-23.6.0.tgz -> npmpkg-babel-jest-23.6.0.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/jquery/-/jquery-3.7.1.tgz -> npmpkg-jquery-3.7.1.tgz
https://registry.npmjs.org/js-levenshtein/-/js-levenshtein-1.1.6.tgz -> npmpkg-js-levenshtein-1.1.6.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.kebabcase/-/lodash.kebabcase-4.1.1.tgz -> npmpkg-lodash.kebabcase-4.1.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/pngjs/-/pngjs-6.0.0.tgz -> npmpkg-pngjs-6.0.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.13.tgz -> npmpkg-postcss-selector-parser-6.0.13.tgz
https://registry.npmjs.org/postcss-colormin/-/postcss-colormin-4.0.3.tgz -> npmpkg-postcss-colormin-4.0.3.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-convert-values/-/postcss-convert-values-4.0.1.tgz -> npmpkg-postcss-convert-values-4.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> npmpkg-cosmiconfig-5.2.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-2.0.0.tgz -> npmpkg-import-fresh-2.0.0.tgz
https://registry.npmjs.org/postcss-merge-longhand/-/postcss-merge-longhand-4.0.11.tgz -> npmpkg-postcss-merge-longhand-4.0.11.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-minify-gradients/-/postcss-minify-gradients-4.0.2.tgz -> npmpkg-postcss-minify-gradients-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/svg-tags/-/svg-tags-1.0.0.tgz -> npmpkg-svg-tags-1.0.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/three/-/three-0.118.3.tgz -> npmpkg-three-0.118.3.tgz
https://github.com/nicolaspanel/three-orbitcontrols-ts/archive/b5b2685a88b880822c62275f2a76bdaa3954f76c.tar.gz -> npmpkg-three-orbitcontrols-ts.git-b5b2685a88b880822c62275f2a76bdaa3954f76c.tgz
https://registry.npmjs.org/typeface-open-sans/-/typeface-open-sans-0.0.75.tgz -> npmpkg-typeface-open-sans-0.0.75.tgz
https://registry.npmjs.org/typescript/-/typescript-3.9.10.tgz -> npmpkg-typescript-3.9.10.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/vue/-/vue-2.6.11.tgz -> npmpkg-vue-2.6.11.tgz
https://registry.npmjs.org/vue-class-component/-/vue-class-component-7.2.6.tgz -> npmpkg-vue-class-component-7.2.6.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/yargs/-/yargs-14.2.3.tgz -> npmpkg-yargs-14.2.3.tgz
https://registry.npmjs.org/vue-color/-/vue-color-2.8.1.tgz -> npmpkg-vue-color-2.8.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/vue-final-modal/-/vue-final-modal-2.4.3.tgz -> npmpkg-vue-final-modal-2.4.3.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> npmpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.npmjs.org/vue-loader/-/vue-loader-15.11.1.tgz -> npmpkg-vue-loader-15.11.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/vue-property-decorator/-/vue-property-decorator-8.5.1.tgz -> npmpkg-vue-property-decorator-8.5.1.tgz
https://registry.npmjs.org/vue-router/-/vue-router-3.3.4.tgz -> npmpkg-vue-router-3.3.4.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.6.11.tgz -> npmpkg-vue-template-compiler-2.6.11.tgz
https://registry.npmjs.org/vue-toast-notification/-/vue-toast-notification-0.6.2.tgz -> npmpkg-vue-toast-notification-0.6.2.tgz
https://registry.npmjs.org/vuex/-/vuex-3.6.2.tgz -> npmpkg-vuex-3.6.2.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/opn/-/opn-5.5.0.tgz -> npmpkg-opn-5.5.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
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
	fi
	if use amd64 || use x64-macos ; then
		arch="x86_64"
	elif use x86 ; then
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
	fi
	if use kernel_linux && use amd64 ; then
		arch="-x86_64"
	elif use kernel_linux && use x86 ; then
		arch="-i686"
	fi
	zip_format="tar.bz2"
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
