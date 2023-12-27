# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="13.6.9"
ELECTRON_APP_VUE_PV="2.6.11"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_SHARP_PV="0.29.3"
ELECTRON_APP_SKIP_EXIT_CODE_CHECK="1"
ELECTRON_APP_VIPS_PV="8.11.3"
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
REQUIRED_USE+="
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
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.23.5.tgz -> npmpkg-@babel-code-frame-7.23.5.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.23.5.tgz -> npmpkg-@babel-compat-data-7.23.5.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.6.tgz -> npmpkg-@babel-core-7.23.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.6.tgz -> npmpkg-@babel-generator-7.23.6.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.23.6.tgz -> npmpkg-@babel-helper-compilation-targets-7.23.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.23.6.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.23.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.4.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.4.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.23.0.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> npmpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.23.3.tgz -> npmpkg-@babel-helper-module-transforms-7.23.3.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.22.20.tgz -> npmpkg-@babel-helper-replace-supers-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz -> npmpkg-@babel-helper-simple-access-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.23.4.tgz -> npmpkg-@babel-helper-string-parser-7.23.4.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.23.5.tgz -> npmpkg-@babel-helper-validator-option-7.23.5.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> npmpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.23.6.tgz -> npmpkg-@babel-helpers-7.23.6.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.23.4.tgz -> npmpkg-@babel-highlight-7.23.4.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.6.tgz -> npmpkg-@babel-parser-7.23.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-async-generator-functions-7.20.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-class-properties-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-decorators/-/plugin-proposal-decorators-7.23.6.tgz -> npmpkg-@babel-plugin-proposal-decorators-7.23.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-json-strings-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-object-rest-spread-7.20.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-optional-catch-binding-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-decorators/-/plugin-syntax-decorators-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-decorators-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.23.3.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.23.3.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.23.3.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.4.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.23.4.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.23.5.tgz -> npmpkg-@babel-plugin-transform-classes-7.23.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.23.3.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.3.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.23.3.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.23.3.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.23.3.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.23.6.tgz -> npmpkg-@babel-plugin-transform-for-of-7.23.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.23.3.tgz -> npmpkg-@babel-plugin-transform-function-name-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.23.3.tgz -> npmpkg-@babel-plugin-transform-literals-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.3.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.3.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.3.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.23.3.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.23.3.tgz -> npmpkg-@babel-plugin-transform-new-target-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.23.3.tgz -> npmpkg-@babel-plugin-transform-object-super-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.23.3.tgz -> npmpkg-@babel-plugin-transform-parameters-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.23.3.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.23.6.tgz -> npmpkg-@babel-plugin-transform-runtime-7.23.6.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.23.3.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.23.3.tgz -> npmpkg-@babel-plugin-transform-spread-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.23.3.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.23.3.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.23.3.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.23.3.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.23.3.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.3.4.tgz -> npmpkg-@babel-preset-env-7.3.4.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.23.6.tgz -> npmpkg-@babel-runtime-7.23.6.tgz
https://registry.npmjs.org/@babel/runtime-corejs2/-/runtime-corejs2-7.23.6.tgz -> npmpkg-@babel-runtime-corejs2-7.23.6.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.6.tgz -> npmpkg-@babel-traverse-7.23.6.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.6.tgz -> npmpkg-@babel-types-7.23.6.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.1.0.tgz -> npmpkg-@develar-schema-utils-2.1.0.tgz
https://registry.npmjs.org/@electron/get/-/get-1.14.1.tgz -> npmpkg-@electron-get-1.14.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@electron/remote/-/remote-1.2.2.tgz -> npmpkg-@electron-remote-1.2.2.tgz
https://registry.npmjs.org/@hapi/address/-/address-2.1.4.tgz -> npmpkg-@hapi-address-2.1.4.tgz
https://registry.npmjs.org/@hapi/bourne/-/bourne-1.3.2.tgz -> npmpkg-@hapi-bourne-1.3.2.tgz
https://registry.npmjs.org/@hapi/hoek/-/hoek-8.5.1.tgz -> npmpkg-@hapi-hoek-8.5.1.tgz
https://registry.npmjs.org/@hapi/joi/-/joi-15.1.1.tgz -> npmpkg-@hapi-joi-15.1.1.tgz
https://registry.npmjs.org/@hapi/topo/-/topo-3.1.6.tgz -> npmpkg-@hapi-topo-3.1.6.tgz
https://registry.npmjs.org/@intervolga/optimize-cssnano-plugin/-/optimize-cssnano-plugin-1.0.6.tgz -> npmpkg-@intervolga-optimize-cssnano-plugin-1.0.6.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@jimp/bmp/-/bmp-0.16.13.tgz -> npmpkg-@jimp-bmp-0.16.13.tgz
https://registry.npmjs.org/@jimp/core/-/core-0.16.13.tgz -> npmpkg-@jimp-core-0.16.13.tgz
https://registry.npmjs.org/@jimp/custom/-/custom-0.16.13.tgz -> npmpkg-@jimp-custom-0.16.13.tgz
https://registry.npmjs.org/@jimp/gif/-/gif-0.16.13.tgz -> npmpkg-@jimp-gif-0.16.13.tgz
https://registry.npmjs.org/@jimp/jpeg/-/jpeg-0.16.13.tgz -> npmpkg-@jimp-jpeg-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-blit/-/plugin-blit-0.16.13.tgz -> npmpkg-@jimp-plugin-blit-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-blur/-/plugin-blur-0.16.13.tgz -> npmpkg-@jimp-plugin-blur-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-circle/-/plugin-circle-0.16.13.tgz -> npmpkg-@jimp-plugin-circle-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-color/-/plugin-color-0.16.13.tgz -> npmpkg-@jimp-plugin-color-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-contain/-/plugin-contain-0.16.13.tgz -> npmpkg-@jimp-plugin-contain-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-cover/-/plugin-cover-0.16.13.tgz -> npmpkg-@jimp-plugin-cover-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-crop/-/plugin-crop-0.16.13.tgz -> npmpkg-@jimp-plugin-crop-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-displace/-/plugin-displace-0.16.13.tgz -> npmpkg-@jimp-plugin-displace-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-dither/-/plugin-dither-0.16.13.tgz -> npmpkg-@jimp-plugin-dither-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-fisheye/-/plugin-fisheye-0.16.13.tgz -> npmpkg-@jimp-plugin-fisheye-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-flip/-/plugin-flip-0.16.13.tgz -> npmpkg-@jimp-plugin-flip-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-gaussian/-/plugin-gaussian-0.16.13.tgz -> npmpkg-@jimp-plugin-gaussian-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-invert/-/plugin-invert-0.16.13.tgz -> npmpkg-@jimp-plugin-invert-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-mask/-/plugin-mask-0.16.13.tgz -> npmpkg-@jimp-plugin-mask-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-normalize/-/plugin-normalize-0.16.13.tgz -> npmpkg-@jimp-plugin-normalize-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-print/-/plugin-print-0.16.13.tgz -> npmpkg-@jimp-plugin-print-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-resize/-/plugin-resize-0.16.13.tgz -> npmpkg-@jimp-plugin-resize-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-rotate/-/plugin-rotate-0.16.13.tgz -> npmpkg-@jimp-plugin-rotate-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-scale/-/plugin-scale-0.16.13.tgz -> npmpkg-@jimp-plugin-scale-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-shadow/-/plugin-shadow-0.16.13.tgz -> npmpkg-@jimp-plugin-shadow-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugin-threshold/-/plugin-threshold-0.16.13.tgz -> npmpkg-@jimp-plugin-threshold-0.16.13.tgz
https://registry.npmjs.org/@jimp/plugins/-/plugins-0.16.13.tgz -> npmpkg-@jimp-plugins-0.16.13.tgz
https://registry.npmjs.org/@jimp/png/-/png-0.16.13.tgz -> npmpkg-@jimp-png-0.16.13.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/@jimp/tiff/-/tiff-0.16.13.tgz -> npmpkg-@jimp-tiff-0.16.13.tgz
https://registry.npmjs.org/@jimp/types/-/types-0.16.13.tgz -> npmpkg-@jimp-types-0.16.13.tgz
https://registry.npmjs.org/@jimp/utils/-/utils-0.16.13.tgz -> npmpkg-@jimp-utils-0.16.13.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> npmpkg-regenerator-runtime-0.13.11.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@mrmlnc/readdir-enhanced/-/readdir-enhanced-2.2.1.tgz -> npmpkg-@mrmlnc-readdir-enhanced-2.2.1.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-1.1.3.tgz -> npmpkg-@nodelib-fs.stat-1.1.3.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@one-ini/wasm/-/wasm-0.1.1.tgz -> npmpkg-@one-ini-wasm-0.1.1.tgz
https://registry.npmjs.org/@petamoriken/float16/-/float16-3.8.4.tgz -> npmpkg-@petamoriken-float16-3.8.4.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@sentry/browser/-/browser-6.19.2.tgz -> npmpkg-@sentry-browser-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/cli/-/cli-1.77.1.tgz -> npmpkg-@sentry-cli-1.77.1.tgz
https://registry.npmjs.org/@sentry/core/-/core-6.19.2.tgz -> npmpkg-@sentry-core-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/electron/-/electron-3.0.8.tgz -> npmpkg-@sentry-electron-3.0.8.tgz
https://registry.npmjs.org/@sentry/hub/-/hub-6.19.2.tgz -> npmpkg-@sentry-hub-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/minimal/-/minimal-6.19.2.tgz -> npmpkg-@sentry-minimal-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/node/-/node-6.19.2.tgz -> npmpkg-@sentry-node-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/types/-/types-6.19.2.tgz -> npmpkg-@sentry-types-6.19.2.tgz
https://registry.npmjs.org/@sentry/utils/-/utils-6.19.2.tgz -> npmpkg-@sentry-utils-6.19.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/@sentry/webpack-plugin/-/webpack-plugin-1.21.0.tgz -> npmpkg-@sentry-webpack-plugin-1.21.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz -> npmpkg-@sindresorhus-is-0.14.0.tgz
https://registry.npmjs.org/@soda/friendly-errors-webpack-plugin/-/friendly-errors-webpack-plugin-1.8.1.tgz -> npmpkg-@soda-friendly-errors-webpack-plugin-1.8.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> npmpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.npmjs.org/@tokenizer/token/-/token-0.3.0.tgz -> npmpkg-@tokenizer-token-0.3.0.tgz
https://registry.npmjs.org/@types/adm-zip/-/adm-zip-0.4.34.tgz -> npmpkg-@types-adm-zip-0.4.34.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/eslint-visitor-keys/-/eslint-visitor-keys-1.0.0.tgz -> npmpkg-@types-eslint-visitor-keys-1.0.0.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/jest/-/jest-23.3.14.tgz -> npmpkg-@types-jest-23.3.14.tgz
https://registry.npmjs.org/@types/jquery/-/jquery-3.5.29.tgz -> npmpkg-@types-jquery-3.5.29.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.68.tgz -> npmpkg-@types-node-16.18.68.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> npmpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.npmjs.org/@types/pako/-/pako-1.0.7.tgz -> npmpkg-@types-pako-1.0.7.tgz
https://registry.npmjs.org/@types/pngjs/-/pngjs-6.0.4.tgz -> npmpkg-@types-pngjs-6.0.4.tgz
https://registry.npmjs.org/@types/q/-/q-1.5.8.tgz -> npmpkg-@types-q-1.5.8.tgz
https://registry.npmjs.org/@types/sharp/-/sharp-0.29.5.tgz -> npmpkg-@types-sharp-0.29.5.tgz
https://registry.npmjs.org/@types/sizzle/-/sizzle-2.3.8.tgz -> npmpkg-@types-sizzle-2.3.8.tgz
https://registry.npmjs.org/@types/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-@types-strip-bom-3.0.0.tgz
https://registry.npmjs.org/@types/strip-json-comments/-/strip-json-comments-0.0.30.tgz -> npmpkg-@types-strip-json-comments-0.0.30.tgz
https://registry.npmjs.org/@types/three/-/three-0.103.2.tgz -> npmpkg-@types-three-0.103.2.tgz
https://registry.npmjs.org/@types/webpack-env/-/webpack-env-1.18.4.tgz -> npmpkg-@types-webpack-env-1.18.4.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-2.34.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-2.34.0.tgz
https://registry.npmjs.org/@typescript-eslint/experimental-utils/-/experimental-utils-2.34.0.tgz -> npmpkg-@typescript-eslint-experimental-utils-2.34.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-2.34.0.tgz -> npmpkg-@typescript-eslint-parser-2.34.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-2.34.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-2.34.0.tgz
https://registry.npmjs.org/@vue/babel-helper-vue-jsx-merge-props/-/babel-helper-vue-jsx-merge-props-1.4.0.tgz -> npmpkg-@vue-babel-helper-vue-jsx-merge-props-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-plugin-transform-vue-jsx/-/babel-plugin-transform-vue-jsx-1.4.0.tgz -> npmpkg-@vue-babel-plugin-transform-vue-jsx-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-preset-app/-/babel-preset-app-3.12.1.tgz -> npmpkg-@vue-babel-preset-app-3.12.1.tgz
https://registry.npmjs.org/@vue/babel-preset-jsx/-/babel-preset-jsx-1.4.0.tgz -> npmpkg-@vue-babel-preset-jsx-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-composition-api-inject-h/-/babel-sugar-composition-api-inject-h-1.4.0.tgz -> npmpkg-@vue-babel-sugar-composition-api-inject-h-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-composition-api-render-instance/-/babel-sugar-composition-api-render-instance-1.4.0.tgz -> npmpkg-@vue-babel-sugar-composition-api-render-instance-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-functional-vue/-/babel-sugar-functional-vue-1.4.0.tgz -> npmpkg-@vue-babel-sugar-functional-vue-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-inject-h/-/babel-sugar-inject-h-1.4.0.tgz -> npmpkg-@vue-babel-sugar-inject-h-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-v-model/-/babel-sugar-v-model-1.4.0.tgz -> npmpkg-@vue-babel-sugar-v-model-1.4.0.tgz
https://registry.npmjs.org/@vue/babel-sugar-v-on/-/babel-sugar-v-on-1.4.0.tgz -> npmpkg-@vue-babel-sugar-v-on-1.4.0.tgz
https://registry.npmjs.org/@vue/cli-overlay/-/cli-overlay-3.12.1.tgz -> npmpkg-@vue-cli-overlay-3.12.1.tgz
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
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
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
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@vue/cli-shared-utils/-/cli-shared-utils-3.12.1.tgz -> npmpkg-@vue-cli-shared-utils-3.12.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@vue/component-compiler-utils/-/component-compiler-utils-3.3.0.tgz -> npmpkg-@vue-component-compiler-utils-3.3.0.tgz
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
https://registry.npmjs.org/@vue/preload-webpack-plugin/-/preload-webpack-plugin-1.1.2.tgz -> npmpkg-@vue-preload-webpack-plugin-1.1.2.tgz
https://registry.npmjs.org/@vue/test-utils/-/test-utils-1.0.0-beta.29.tgz -> npmpkg-@vue-test-utils-1.0.0-beta.29.tgz
https://registry.npmjs.org/@vue/web-component-wrapper/-/web-component-wrapper-1.3.0.tgz -> npmpkg-@vue-web-component-wrapper-1.3.0.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.9.0.tgz -> npmpkg-@webassemblyjs-ast-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-code-frame-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-fsm-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-module-context-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> npmpkg-@webassemblyjs-ieee754-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> npmpkg-@webassemblyjs-leb128-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> npmpkg-@webassemblyjs-utf8-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-printer-1.9.0.tgz
https://registry.npmjs.org/@webcomponents/webcomponentsjs/-/webcomponentsjs-2.8.0.tgz -> npmpkg-@webcomponents-webcomponentsjs-2.8.0.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.0.3.tgz -> npmpkg-7zip-bin-5.0.3.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/abbrev/-/abbrev-2.0.0.tgz -> npmpkg-abbrev-2.0.0.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz -> npmpkg-accepts-1.3.8.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-4.3.4.tgz -> npmpkg-acorn-globals-4.3.4.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-6.2.0.tgz -> npmpkg-acorn-walk-6.2.0.tgz
https://registry.npmjs.org/address/-/address-1.2.2.tgz -> npmpkg-address-1.2.2.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.4.16.tgz -> npmpkg-adm-zip-0.4.16.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-errors/-/ajv-errors-1.0.1.tgz -> npmpkg-ajv-errors-1.0.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/alphanum-sort/-/alphanum-sort-1.0.2.tgz -> npmpkg-alphanum-sort-1.0.2.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-3.0.1.tgz -> npmpkg-ansi-align-3.0.1.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-3.2.4.tgz -> npmpkg-ansi-colors-3.2.4.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-html-community/-/ansi-html-community-0.0.8.tgz -> npmpkg-ansi-html-community-0.0.8.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/any-base/-/any-base-1.1.0.tgz -> npmpkg-any-base-1.1.0.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-3.4.3.tgz -> npmpkg-app-builder-bin-3.4.3.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-21.2.0.tgz -> npmpkg-app-builder-lib-21.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/append-transform/-/append-transform-0.4.0.tgz -> npmpkg-append-transform-0.4.0.tgz
https://registry.npmjs.org/aproba/-/aproba-1.2.0.tgz -> npmpkg-aproba-1.2.0.tgz
https://registry.npmjs.org/arch/-/arch-2.2.0.tgz -> npmpkg-arch-2.2.0.tgz
https://registry.npmjs.org/archiver/-/archiver-2.1.1.tgz -> npmpkg-archiver-2.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz -> npmpkg-archiver-utils-1.3.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.6.2.tgz -> npmpkg-tar-stream-1.6.2.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/args/-/args-5.0.3.tgz -> npmpkg-args-5.0.3.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.0.0.tgz -> npmpkg-camelcase-5.0.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-equal/-/array-equal-1.0.2.tgz -> npmpkg-array-equal-1.0.2.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz -> npmpkg-array-flatten-1.1.1.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/array.prototype.reduce/-/array.prototype.reduce-1.0.6.tgz -> npmpkg-array.prototype.reduce-1.0.6.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.2.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.2.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.6.tgz -> npmpkg-asn1-0.2.6.tgz
https://registry.npmjs.org/asn1.js/-/asn1.js-5.4.1.tgz -> npmpkg-asn1.js-5.4.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/assert/-/assert-1.5.1.tgz -> npmpkg-assert-1.5.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/util/-/util-0.10.4.tgz -> npmpkg-util-0.10.4.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-1.0.0.tgz -> npmpkg-astral-regex-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.1.tgz -> npmpkg-async-limiter-1.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-9.8.8.tgz -> npmpkg-autoprefixer-9.8.8.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.12.0.tgz -> npmpkg-aws4-1.12.0.tgz
https://registry.npmjs.org/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> npmpkg-babel-code-frame-6.26.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz -> npmpkg-js-tokens-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-7.0.0-bridge.0.tgz -> npmpkg-babel-core-7.0.0-bridge.0.tgz
https://registry.npmjs.org/babel-eslint/-/babel-eslint-10.1.0.tgz -> npmpkg-babel-eslint-10.1.0.tgz
https://registry.npmjs.org/babel-generator/-/babel-generator-6.26.1.tgz -> npmpkg-babel-generator-6.26.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-1.3.0.tgz -> npmpkg-jsesc-1.3.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/babel-helpers/-/babel-helpers-6.24.1.tgz -> npmpkg-babel-helpers-6.24.1.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-23.6.0.tgz -> npmpkg-babel-jest-23.6.0.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.3.0.tgz -> npmpkg-babel-loader-8.3.0.tgz
https://registry.npmjs.org/babel-messages/-/babel-messages-6.23.0.tgz -> npmpkg-babel-messages-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-dynamic-import-node/-/babel-plugin-dynamic-import-node-2.3.3.tgz -> npmpkg-babel-plugin-dynamic-import-node-2.3.3.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-4.1.6.tgz -> npmpkg-babel-plugin-istanbul-4.1.6.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-23.2.0.tgz -> npmpkg-babel-plugin-jest-hoist-23.2.0.tgz
https://registry.npmjs.org/babel-plugin-module-resolver/-/babel-plugin-module-resolver-3.2.0.tgz -> npmpkg-babel-plugin-module-resolver-3.2.0.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.7.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.7.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.7.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.7.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.4.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.4.tgz
https://registry.npmjs.org/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz -> npmpkg-babel-plugin-syntax-object-rest-spread-6.13.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> npmpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.npmjs.org/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> npmpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-23.2.0.tgz -> npmpkg-babel-preset-jest-23.2.0.tgz
https://registry.npmjs.org/babel-register/-/babel-register-6.26.0.tgz -> npmpkg-babel-register-6.26.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.4.18.tgz -> npmpkg-source-map-support-0.4.18.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.26.0.tgz -> npmpkg-babel-runtime-6.26.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/babel-template/-/babel-template-6.26.0.tgz -> npmpkg-babel-template-6.26.0.tgz
https://registry.npmjs.org/babel-traverse/-/babel-traverse-6.26.0.tgz -> npmpkg-babel-traverse-6.26.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/globals/-/globals-9.18.0.tgz -> npmpkg-globals-9.18.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/babel-types/-/babel-types-6.26.0.tgz -> npmpkg-babel-types-6.26.0.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/babylon/-/babylon-6.18.0.tgz -> npmpkg-babylon-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/batch/-/batch-0.6.1.tgz -> npmpkg-batch-0.6.1.tgz
https://registry.npmjs.org/batch-processor/-/batch-processor-1.0.0.tgz -> npmpkg-batch-processor-1.0.0.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> npmpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.npmjs.org/bfj/-/bfj-6.1.2.tgz -> npmpkg-bfj-6.1.2.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz -> npmpkg-big.js-5.2.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/bmp-js/-/bmp-js-0.1.0.tgz -> npmpkg-bmp-js-0.1.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-5.2.1.tgz -> npmpkg-bn.js-5.2.1.tgz
https://registry.npmjs.org/body-parser/-/body-parser-1.20.1.tgz -> npmpkg-body-parser-1.20.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/bonjour/-/bonjour-3.5.0.tgz -> npmpkg-bonjour-3.5.0.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-2.1.2.tgz -> npmpkg-array-flatten-2.1.2.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/boxen/-/boxen-3.2.0.tgz -> npmpkg-boxen-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz -> npmpkg-type-fest-0.3.1.tgz
https://registry.npmjs.org/boxicons/-/boxicons-2.1.4.tgz -> npmpkg-boxicons-2.1.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/brorand/-/brorand-1.1.0.tgz -> npmpkg-brorand-1.1.0.tgz
https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> npmpkg-browser-process-hrtime-1.0.0.tgz
https://registry.npmjs.org/browser-resolve/-/browser-resolve-1.11.3.tgz -> npmpkg-browser-resolve-1.11.3.tgz
https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz -> npmpkg-resolve-1.1.7.tgz
https://registry.npmjs.org/browserify-aes/-/browserify-aes-1.2.0.tgz -> npmpkg-browserify-aes-1.2.0.tgz
https://registry.npmjs.org/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> npmpkg-browserify-cipher-1.0.1.tgz
https://registry.npmjs.org/browserify-des/-/browserify-des-1.0.2.tgz -> npmpkg-browserify-des-1.0.2.tgz
https://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.1.0.tgz -> npmpkg-browserify-rsa-4.1.0.tgz
https://registry.npmjs.org/browserify-sign/-/browserify-sign-4.2.2.tgz -> npmpkg-browserify-sign-4.2.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> npmpkg-browserify-zlib-0.2.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.2.tgz -> npmpkg-browserslist-4.22.2.tgz
https://registry.npmjs.org/bs-logger/-/bs-logger-0.2.6.tgz -> npmpkg-bs-logger-0.2.6.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> npmpkg-buffer-alloc-1.2.0.tgz
https://registry.npmjs.org/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> npmpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz -> npmpkg-buffer-equal-0.0.1.tgz
https://registry.npmjs.org/buffer-fill/-/buffer-fill-1.0.0.tgz -> npmpkg-buffer-fill-1.0.0.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer-indexof/-/buffer-indexof-1.1.1.tgz -> npmpkg-buffer-indexof-1.1.1.tgz
https://registry.npmjs.org/buffer-xor/-/buffer-xor-1.0.3.tgz -> npmpkg-buffer-xor-1.0.3.tgz
https://registry.npmjs.org/builder-util/-/builder-util-21.2.0.tgz -> npmpkg-builder-util-21.2.0.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.3.0.tgz -> npmpkg-builder-util-runtime-8.3.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.1.tgz -> npmpkg-builtin-modules-1.1.1.tgz
https://registry.npmjs.org/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> npmpkg-builtin-status-codes-3.0.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/cacache/-/cacache-10.0.4.tgz -> npmpkg-cacache-10.0.4.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/ssri/-/ssri-5.3.0.tgz -> npmpkg-ssri-5.3.0.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/cache-loader/-/cache-loader-2.0.1.tgz -> npmpkg-cache-loader-2.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz -> npmpkg-cacheable-request-6.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.5.tgz -> npmpkg-call-bind-1.0.5.tgz
https://registry.npmjs.org/call-me-maybe/-/call-me-maybe-1.0.2.tgz -> npmpkg-call-me-maybe-1.0.2.tgz
https://registry.npmjs.org/caller-callsite/-/caller-callsite-2.0.0.tgz -> npmpkg-caller-callsite-2.0.0.tgz
https://registry.npmjs.org/caller-path/-/caller-path-2.0.0.tgz -> npmpkg-caller-path-2.0.0.tgz
https://registry.npmjs.org/callsites/-/callsites-2.0.0.tgz -> npmpkg-callsites-2.0.0.tgz
https://registry.npmjs.org/camel-case/-/camel-case-3.0.0.tgz -> npmpkg-camel-case-3.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/caniuse-api/-/caniuse-api-3.0.0.tgz -> npmpkg-caniuse-api-3.0.0.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001571.tgz -> npmpkg-caniuse-lite-1.0.30001571.tgz
https://registry.npmjs.org/capture-exit/-/capture-exit-1.2.0.tgz -> npmpkg-capture-exit-1.2.0.tgz
https://registry.npmjs.org/case-sensitive-paths-webpack-plugin/-/case-sensitive-paths-webpack-plugin-2.4.0.tgz -> npmpkg-case-sensitive-paths-webpack-plugin-2.4.0.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/check-types/-/check-types-8.0.3.tgz -> npmpkg-check-types-8.0.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> npmpkg-chrome-trace-event-1.0.3.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-1.6.0.tgz -> npmpkg-ci-info-1.6.0.tgz
https://registry.npmjs.org/cipher-base/-/cipher-base-1.0.4.tgz -> npmpkg-cipher-base-1.0.4.tgz
https://registry.npmjs.org/circular-json/-/circular-json-0.3.3.tgz -> npmpkg-circular-json-0.3.3.tgz
https://registry.npmjs.org/clamp/-/clamp-1.0.1.tgz -> npmpkg-clamp-1.0.1.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/clean-css/-/clean-css-4.2.4.tgz -> npmpkg-clean-css-4.2.4.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-2.2.1.tgz -> npmpkg-cli-boxes-2.2.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-2.1.0.tgz -> npmpkg-cli-cursor-2.1.0.tgz
https://registry.npmjs.org/cli-highlight/-/cli-highlight-2.1.11.tgz -> npmpkg-cli-highlight-2.1.11.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.9.2.tgz -> npmpkg-cli-spinners-2.9.2.tgz
https://registry.npmjs.org/cli-width/-/cli-width-2.2.1.tgz -> npmpkg-cli-width-2.2.1.tgz
https://registry.npmjs.org/clipboardy/-/clipboardy-2.3.0.tgz -> npmpkg-clipboardy-2.3.0.tgz
https://registry.npmjs.org/cliui/-/cliui-5.0.0.tgz -> npmpkg-cliui-5.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/clone/-/clone-2.1.2.tgz -> npmpkg-clone-2.1.2.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/coa/-/coa-2.0.2.tgz -> npmpkg-coa-2.0.2.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color/-/color-3.2.1.tgz -> npmpkg-color-3.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/color-string/-/color-string-1.9.1.tgz -> npmpkg-color-string-1.9.1.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-2.17.1.tgz -> npmpkg-commander-2.17.1.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.1.tgz -> npmpkg-component-emitter-1.3.1.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.2.tgz -> npmpkg-compress-commons-1.2.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/compressible/-/compressible-2.0.18.tgz -> npmpkg-compressible-2.0.18.tgz
https://registry.npmjs.org/compression/-/compression-1.7.4.tgz -> npmpkg-compression-1.7.4.tgz
https://registry.npmjs.org/bytes/-/bytes-3.0.0.tgz -> npmpkg-bytes-3.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/condense-newlines/-/condense-newlines-0.2.1.tgz -> npmpkg-condense-newlines-0.2.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/configstore/-/configstore-4.0.0.tgz -> npmpkg-configstore-4.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz -> npmpkg-connect-history-api-fallback-1.6.0.tgz
https://registry.npmjs.org/console-browserify/-/console-browserify-1.2.0.tgz -> npmpkg-console-browserify-1.2.0.tgz
https://registry.npmjs.org/consolidate/-/consolidate-0.15.1.tgz -> npmpkg-consolidate-0.15.1.tgz
https://registry.npmjs.org/constants-browserify/-/constants-browserify-1.0.0.tgz -> npmpkg-constants-browserify-1.0.0.tgz
https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz -> npmpkg-content-disposition-0.5.4.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz -> npmpkg-content-type-1.0.5.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/cookie/-/cookie-0.4.2.tgz -> npmpkg-cookie-0.4.2.tgz
https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz -> npmpkg-cookie-signature-1.0.6.tgz
https://registry.npmjs.org/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> npmpkg-copy-concurrently-1.0.5.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/copy-webpack-plugin/-/copy-webpack-plugin-4.6.0.tgz -> npmpkg-copy-webpack-plugin-4.6.0.tgz
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
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.34.0.tgz -> npmpkg-core-js-compat-3.34.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> npmpkg-cosmiconfig-5.2.1.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz -> npmpkg-crc32-stream-2.0.0.tgz
https://registry.npmjs.org/create-ecdh/-/create-ecdh-4.0.4.tgz -> npmpkg-create-ecdh-4.0.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/create-hash/-/create-hash-1.2.0.tgz -> npmpkg-create-hash-1.2.0.tgz
https://registry.npmjs.org/create-hmac/-/create-hmac-1.1.7.tgz -> npmpkg-create-hmac-1.1.7.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.12.0.tgz -> npmpkg-crypto-browserify-3.12.0.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-1.0.0.tgz -> npmpkg-crypto-random-string-1.0.0.tgz
https://registry.npmjs.org/css/-/css-2.2.4.tgz -> npmpkg-css-2.2.4.tgz
https://registry.npmjs.org/css-color-names/-/css-color-names-0.0.4.tgz -> npmpkg-css-color-names-0.0.4.tgz
https://registry.npmjs.org/css-declaration-sorter/-/css-declaration-sorter-4.0.1.tgz -> npmpkg-css-declaration-sorter-4.0.1.tgz
https://registry.npmjs.org/css-element-queries/-/css-element-queries-1.2.3.tgz -> npmpkg-css-element-queries-1.2.3.tgz
https://registry.npmjs.org/css-loader/-/css-loader-1.0.1.tgz -> npmpkg-css-loader-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/css-parse/-/css-parse-2.0.0.tgz -> npmpkg-css-parse-2.0.0.tgz
https://registry.npmjs.org/css-select/-/css-select-4.3.0.tgz -> npmpkg-css-select-4.3.0.tgz
https://registry.npmjs.org/css-select-base-adapter/-/css-select-base-adapter-0.1.1.tgz -> npmpkg-css-select-base-adapter-0.1.1.tgz
https://registry.npmjs.org/css-selector-tokenizer/-/css-selector-tokenizer-0.7.3.tgz -> npmpkg-css-selector-tokenizer-0.7.3.tgz
https://registry.npmjs.org/css-tree/-/css-tree-1.0.0-alpha.37.tgz -> npmpkg-css-tree-1.0.0-alpha.37.tgz
https://registry.npmjs.org/css-value/-/css-value-0.0.1.tgz -> npmpkg-css-value-0.0.1.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssnano/-/cssnano-4.1.11.tgz -> npmpkg-cssnano-4.1.11.tgz
https://registry.npmjs.org/cssnano-preset-default/-/cssnano-preset-default-4.0.8.tgz -> npmpkg-cssnano-preset-default-4.0.8.tgz
https://registry.npmjs.org/cssnano-util-get-arguments/-/cssnano-util-get-arguments-4.0.0.tgz -> npmpkg-cssnano-util-get-arguments-4.0.0.tgz
https://registry.npmjs.org/cssnano-util-get-match/-/cssnano-util-get-match-4.0.0.tgz -> npmpkg-cssnano-util-get-match-4.0.0.tgz
https://registry.npmjs.org/cssnano-util-raw-cache/-/cssnano-util-raw-cache-4.0.1.tgz -> npmpkg-cssnano-util-raw-cache-4.0.1.tgz
https://registry.npmjs.org/cssnano-util-same-parent/-/cssnano-util-same-parent-4.0.1.tgz -> npmpkg-cssnano-util-same-parent-4.0.1.tgz
https://registry.npmjs.org/csso/-/csso-4.2.0.tgz -> npmpkg-csso-4.2.0.tgz
https://registry.npmjs.org/css-tree/-/css-tree-1.1.3.tgz -> npmpkg-css-tree-1.1.3.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.14.tgz -> npmpkg-mdn-data-2.0.14.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-1.4.0.tgz -> npmpkg-cssstyle-1.4.0.tgz
https://registry.npmjs.org/current-script-polyfill/-/current-script-polyfill-1.0.0.tgz -> npmpkg-current-script-polyfill-1.0.0.tgz
https://registry.npmjs.org/custom-electron-titlebar/-/custom-electron-titlebar-3.2.10.tgz -> npmpkg-custom-electron-titlebar-3.2.10.tgz
https://registry.npmjs.org/cyclist/-/cyclist-1.0.2.tgz -> npmpkg-cyclist-1.0.2.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/data-urls/-/data-urls-1.1.0.tgz -> npmpkg-data-urls-1.1.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/deasync/-/deasync-0.1.29.tgz -> npmpkg-deasync-0.1.29.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz -> npmpkg-decompress-response-3.3.0.tgz
https://registry.npmjs.org/dedent-js/-/dedent-js-1.0.1.tgz -> npmpkg-dedent-js-1.0.1.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-1.1.2.tgz -> npmpkg-deep-equal-1.1.2.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/default-gateway/-/default-gateway-5.0.5.tgz -> npmpkg-default-gateway-5.0.5.tgz
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
https://registry.npmjs.org/default-require-extensions/-/default-require-extensions-1.0.0.tgz -> npmpkg-default-require-extensions-1.0.0.tgz
https://registry.npmjs.org/defaults/-/defaults-1.0.4.tgz -> npmpkg-defaults-1.0.4.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> npmpkg-defer-to-connect-1.1.3.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.1.tgz -> npmpkg-define-data-property-1.1.1.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.0.tgz -> npmpkg-ignore-5.3.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/des.js/-/des.js-1.1.0.tgz -> npmpkg-des.js-1.1.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz -> npmpkg-destroy-1.2.0.tgz
https://registry.npmjs.org/detect-hover/-/detect-hover-1.0.3.tgz -> npmpkg-detect-hover-1.0.3.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-4.0.0.tgz -> npmpkg-detect-indent-4.0.0.tgz
https://registry.npmjs.org/detect-it/-/detect-it-3.0.7.tgz -> npmpkg-detect-it-3.0.7.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-1.0.3.tgz -> npmpkg-detect-libc-1.0.3.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-2.1.0.tgz -> npmpkg-detect-newline-2.1.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/detect-passive-events/-/detect-passive-events-1.0.5.tgz -> npmpkg-detect-passive-events-1.0.5.tgz
https://registry.npmjs.org/detect-pointer/-/detect-pointer-1.0.3.tgz -> npmpkg-detect-pointer-1.0.3.tgz
https://registry.npmjs.org/detect-touch-events/-/detect-touch-events-2.0.2.tgz -> npmpkg-detect-touch-events-2.0.2.tgz
https://registry.npmjs.org/dev-null/-/dev-null-0.1.1.tgz -> npmpkg-dev-null-0.1.1.tgz
https://registry.npmjs.org/diff/-/diff-3.5.0.tgz -> npmpkg-diff-3.5.0.tgz
https://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> npmpkg-diffie-hellman-5.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-2.2.2.tgz -> npmpkg-dir-glob-2.2.2.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-21.2.0.tgz -> npmpkg-dmg-builder-21.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.5.2.tgz -> npmpkg-iconv-lite-0.5.2.tgz
https://registry.npmjs.org/dns-equal/-/dns-equal-1.0.0.tgz -> npmpkg-dns-equal-1.0.0.tgz
https://registry.npmjs.org/dns-packet/-/dns-packet-1.3.4.tgz -> npmpkg-dns-packet-1.3.4.tgz
https://registry.npmjs.org/dns-txt/-/dns-txt-2.0.2.tgz -> npmpkg-dns-txt-2.0.2.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-converter/-/dom-converter-0.2.0.tgz -> npmpkg-dom-converter-0.2.0.tgz
https://registry.npmjs.org/dom-event-types/-/dom-event-types-1.1.0.tgz -> npmpkg-dom-event-types-1.1.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-1.4.1.tgz -> npmpkg-dom-serializer-1.4.1.tgz
https://registry.npmjs.org/dom-walk/-/dom-walk-0.1.2.tgz -> npmpkg-dom-walk-0.1.2.tgz
https://registry.npmjs.org/domain-browser/-/domain-browser-1.2.0.tgz -> npmpkg-domain-browser-1.2.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domexception/-/domexception-1.0.1.tgz -> npmpkg-domexception-1.0.1.tgz
https://registry.npmjs.org/domhandler/-/domhandler-4.3.1.tgz -> npmpkg-domhandler-4.3.1.tgz
https://registry.npmjs.org/domutils/-/domutils-2.8.0.tgz -> npmpkg-domutils-2.8.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-4.2.1.tgz -> npmpkg-dot-prop-4.2.1.tgz
https://registry.npmjs.org/dotenv/-/dotenv-7.0.0.tgz -> npmpkg-dotenv-7.0.0.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.2.tgz -> npmpkg-duplexer-0.1.2.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.5.tgz -> npmpkg-duplexer3-0.1.5.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/easy-stack/-/easy-stack-1.0.1.tgz -> npmpkg-easy-stack-1.0.1.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> npmpkg-ecc-jsbn-0.1.2.tgz
https://registry.npmjs.org/editorconfig/-/editorconfig-1.0.4.tgz -> npmpkg-editorconfig-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/commander/-/commander-10.0.1.tgz -> npmpkg-commander-10.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.1.tgz -> npmpkg-minimatch-9.0.1.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/ejs/-/ejs-2.7.4.tgz -> npmpkg-ejs-2.7.4.tgz
https://registry.npmjs.org/electron/-/electron-13.6.9.tgz -> npmpkg-electron-13.6.9.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-21.2.0.tgz -> npmpkg-electron-builder-21.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/electron-chromedriver/-/electron-chromedriver-5.0.1.tgz -> npmpkg-electron-chromedriver-5.0.1.tgz
https://registry.npmjs.org/electron-devtools-installer/-/electron-devtools-installer-3.2.0.tgz -> npmpkg-electron-devtools-installer-3.2.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/electron-download/-/electron-download-4.1.1.tgz -> npmpkg-electron-download-4.1.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/env-paths/-/env-paths-1.0.0.tgz -> npmpkg-env-paths-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-4.0.3.tgz -> npmpkg-fs-extra-4.0.3.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-2.0.2.tgz -> npmpkg-sumchecker-2.0.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/electron-icon-builder/-/electron-icon-builder-2.0.1.tgz -> npmpkg-electron-icon-builder-2.0.1.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-21.2.0.tgz -> npmpkg-electron-publish-21.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/electron-settings/-/electron-settings-4.0.2.tgz -> npmpkg-electron-settings-4.0.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.616.tgz -> npmpkg-electron-to-chromium-1.4.616.tgz
https://registry.npmjs.org/@types/node/-/node-14.18.63.tgz -> npmpkg-@types-node-14.18.63.tgz
https://registry.npmjs.org/element-resize-detector/-/element-resize-detector-1.2.4.tgz -> npmpkg-element-resize-detector-1.2.4.tgz
https://registry.npmjs.org/elliptic/-/elliptic-6.5.4.tgz -> npmpkg-elliptic-6.5.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz -> npmpkg-emojis-list-3.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> npmpkg-enhanced-resolve-4.5.0.tgz
https://registry.npmjs.org/entities/-/entities-2.2.0.tgz -> npmpkg-entities-2.2.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/errno/-/errno-0.1.8.tgz -> npmpkg-errno-0.1.8.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/error-stack-parser/-/error-stack-parser-2.1.4.tgz -> npmpkg-error-stack-parser-2.1.4.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.22.3.tgz -> npmpkg-es-abstract-1.22.3.tgz
https://registry.npmjs.org/es-array-method-boxes-properly/-/es-array-method-boxes-properly-1.0.0.tgz -> npmpkg-es-array-method-boxes-properly-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.2.tgz -> npmpkg-es-set-tostringtag-2.0.2.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/es6-promise/-/es6-promise-4.2.8.tgz -> npmpkg-es6-promise-4.2.8.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escodegen/-/escodegen-1.14.3.tgz -> npmpkg-escodegen-1.14.3.tgz
https://registry.npmjs.org/eslint/-/eslint-5.16.0.tgz -> npmpkg-eslint-5.16.0.tgz
https://registry.npmjs.org/eslint-config-prettier/-/eslint-config-prettier-3.6.0.tgz -> npmpkg-eslint-config-prettier-3.6.0.tgz
https://registry.npmjs.org/eslint-loader/-/eslint-loader-2.2.1.tgz -> npmpkg-eslint-loader-2.2.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/eslint-plugin-prettier/-/eslint-plugin-prettier-3.4.1.tgz -> npmpkg-eslint-plugin-prettier-3.4.1.tgz
https://registry.npmjs.org/eslint-plugin-vue/-/eslint-plugin-vue-5.2.3.tgz -> npmpkg-eslint-plugin-vue-5.2.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-1.4.3.tgz -> npmpkg-eslint-utils-1.4.3.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/regexpp/-/regexpp-2.0.1.tgz -> npmpkg-regexpp-2.0.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/espree/-/espree-5.0.1.tgz -> npmpkg-espree-5.0.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/event-pubsub/-/event-pubsub-4.3.0.tgz -> npmpkg-event-pubsub-4.3.0.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/eventsource/-/eventsource-2.0.2.tgz -> npmpkg-eventsource-2.0.2.tgz
https://registry.npmjs.org/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> npmpkg-evp_bytestokey-1.0.3.tgz
https://registry.npmjs.org/exec-sh/-/exec-sh-0.2.2.tgz -> npmpkg-exec-sh-0.2.2.tgz
https://registry.npmjs.org/execa/-/execa-1.0.0.tgz -> npmpkg-execa-1.0.0.tgz
https://registry.npmjs.org/exif-parser/-/exif-parser-0.1.12.tgz -> npmpkg-exif-parser-0.1.12.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/expect/-/expect-23.6.0.tgz -> npmpkg-expect-23.6.0.tgz
https://registry.npmjs.org/express/-/express-4.18.2.tgz -> npmpkg-express-4.18.2.tgz
https://registry.npmjs.org/cookie/-/cookie-0.5.0.tgz -> npmpkg-cookie-0.5.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> npmpkg-path-to-regexp-0.1.7.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extract-from-css/-/extract-from-css-0.4.4.tgz -> npmpkg-extract-from-css-0.4.4.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-diff/-/fast-diff-1.3.0.tgz -> npmpkg-fast-diff-1.3.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-2.2.7.tgz -> npmpkg-fast-glob-2.2.7.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fast-png/-/fast-png-5.0.4.tgz -> npmpkg-fast-png-5.0.4.tgz
https://registry.npmjs.org/fastparse/-/fastparse-1.1.2.tgz -> npmpkg-fastparse-1.1.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.16.0.tgz -> npmpkg-fastq-1.16.0.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.4.tgz -> npmpkg-faye-websocket-0.11.4.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> npmpkg-figgy-pudding-3.5.2.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-5.0.1.tgz -> npmpkg-file-entry-cache-5.0.1.tgz
https://registry.npmjs.org/file-loader/-/file-loader-3.0.1.tgz -> npmpkg-file-loader-3.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/file-type/-/file-type-16.5.4.tgz -> npmpkg-file-type-16.5.4.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/file-url/-/file-url-2.0.2.tgz -> npmpkg-file-url-2.0.2.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/fileset/-/fileset-2.0.3.tgz -> npmpkg-fileset-2.0.3.tgz
https://registry.npmjs.org/filesize/-/filesize-3.6.1.tgz -> npmpkg-filesize-3.6.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.2.0.tgz -> npmpkg-finalhandler-1.2.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/find-babel-config/-/find-babel-config-1.2.0.tgz -> npmpkg-find-babel-config-1.2.0.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-2.0.1.tgz -> npmpkg-flat-cache-2.0.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz -> npmpkg-rimraf-2.6.3.tgz
https://registry.npmjs.org/flatted/-/flatted-2.0.2.tgz -> npmpkg-flatted-2.0.2.tgz
https://registry.npmjs.org/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> npmpkg-flush-write-stream-1.1.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.3.tgz -> npmpkg-follow-redirects-1.15.3.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.1.1.tgz -> npmpkg-foreground-child-3.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-0.5.2.tgz -> npmpkg-fork-ts-checker-webpack-plugin-0.5.2.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.3.tgz -> npmpkg-form-data-2.3.3.tgz
https://registry.npmjs.org/forwarded/-/forwarded-0.2.0.tgz -> npmpkg-forwarded-0.2.0.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/friendly-errors-webpack-plugin/-/friendly-errors-webpack-plugin-1.7.0.tgz -> npmpkg-friendly-errors-webpack-plugin-1.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-7.0.1.tgz -> npmpkg-fs-extra-7.0.1.tgz
https://registry.npmjs.org/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> npmpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gaze/-/gaze-1.1.3.tgz -> npmpkg-gaze-1.1.3.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.2.tgz -> npmpkg-get-intrinsic-1.2.2.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-6.0.0.tgz -> npmpkg-get-stdin-6.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/gifwrap/-/gifwrap-0.9.4.tgz -> npmpkg-gifwrap-0.9.4.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.3.0.tgz -> npmpkg-glob-to-regexp-0.3.0.tgz
https://registry.npmjs.org/global/-/global-4.4.0.tgz -> npmpkg-global-4.4.0.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-0.1.1.tgz -> npmpkg-global-dirs-0.1.1.tgz
https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> npmpkg-global-tunnel-ng-2.7.1.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globby/-/globby-9.2.0.tgz -> npmpkg-globby-9.2.0.tgz
https://registry.npmjs.org/globule/-/globule-1.3.4.tgz -> npmpkg-globule-1.3.4.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.8.tgz -> npmpkg-minimatch-3.0.8.tgz
https://registry.npmjs.org/golden-layout/-/golden-layout-1.5.9.tgz -> npmpkg-golden-layout-1.5.9.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-9.6.0.tgz -> npmpkg-got-9.6.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> npmpkg-grapheme-splitter-1.0.4.tgz
https://registry.npmjs.org/growly/-/growly-1.3.0.tgz -> npmpkg-growly-1.3.0.tgz
https://registry.npmjs.org/gzip-size/-/gzip-size-5.1.1.tgz -> npmpkg-gzip-size-5.1.1.tgz
https://registry.npmjs.org/handle-thing/-/handle-thing-2.0.1.tgz -> npmpkg-handle-thing-2.0.1.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.8.tgz -> npmpkg-handlebars-4.7.8.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.1.5.tgz -> npmpkg-har-validator-5.1.5.tgz
https://registry.npmjs.org/has/-/has-1.0.4.tgz -> npmpkg-has-1.0.4.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.1.tgz -> npmpkg-has-property-descriptors-1.0.1.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-2.1.0.tgz -> npmpkg-has-yarn-2.1.0.tgz
https://registry.npmjs.org/hash-base/-/hash-base-3.1.0.tgz -> npmpkg-hash-base-3.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/hash-sum/-/hash-sum-1.0.2.tgz -> npmpkg-hash-sum-1.0.2.tgz
https://registry.npmjs.org/hash.js/-/hash.js-1.1.7.tgz -> npmpkg-hash.js-1.1.7.tgz
https://registry.npmjs.org/hasha/-/hasha-2.2.0.tgz -> npmpkg-hasha-2.2.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hex-color-regex/-/hex-color-regex-1.1.0.tgz -> npmpkg-hex-color-regex-1.1.0.tgz
https://registry.npmjs.org/highlight.js/-/highlight.js-10.7.3.tgz -> npmpkg-highlight.js-10.7.3.tgz
https://registry.npmjs.org/history/-/history-4.10.1.tgz -> npmpkg-history-4.10.1.tgz
https://registry.npmjs.org/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> npmpkg-hmac-drbg-1.0.1.tgz
https://registry.npmjs.org/hoist-non-react-statics/-/hoist-non-react-statics-2.5.5.tgz -> npmpkg-hoist-non-react-statics-2.5.5.tgz
https://registry.npmjs.org/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> npmpkg-home-or-tmp-2.0.0.tgz
https://registry.npmjs.org/hoopy/-/hoopy-0.1.4.tgz -> npmpkg-hoopy-0.1.4.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/hpack.js/-/hpack.js-2.1.6.tgz -> npmpkg-hpack.js-2.1.6.tgz
https://registry.npmjs.org/hsl-regex/-/hsl-regex-1.0.0.tgz -> npmpkg-hsl-regex-1.0.0.tgz
https://registry.npmjs.org/hsla-regex/-/hsla-regex-1.0.0.tgz -> npmpkg-hsla-regex-1.0.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-1.0.2.tgz -> npmpkg-html-encoding-sniffer-1.0.2.tgz
https://registry.npmjs.org/html-entities/-/html-entities-1.4.0.tgz -> npmpkg-html-entities-1.4.0.tgz
https://registry.npmjs.org/html-minifier/-/html-minifier-3.5.21.tgz -> npmpkg-html-minifier-3.5.21.tgz
https://registry.npmjs.org/html-tags/-/html-tags-2.0.0.tgz -> npmpkg-html-tags-2.0.0.tgz
https://registry.npmjs.org/html-webpack-plugin/-/html-webpack-plugin-3.2.0.tgz -> npmpkg-html-webpack-plugin-3.2.0.tgz
https://registry.npmjs.org/big.js/-/big.js-3.2.0.tgz -> npmpkg-big.js-3.2.0.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-2.1.0.tgz -> npmpkg-emojis-list-2.1.0.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-0.2.17.tgz -> npmpkg-loader-utils-0.2.17.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-6.1.0.tgz -> npmpkg-htmlparser2-6.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-deceiver/-/http-deceiver-1.2.7.tgz -> npmpkg-http-deceiver-1.2.7.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz -> npmpkg-http-errors-2.0.0.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.5.8.tgz -> npmpkg-http-parser-js-0.5.8.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-proxy-middleware/-/http-proxy-middleware-0.19.1.tgz -> npmpkg-http-proxy-middleware-0.19.1.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/https-browserify/-/https-browserify-1.0.0.tgz -> npmpkg-https-browserify-1.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-1.1.1.tgz -> npmpkg-human-signals-1.1.1.tgz
https://registry.npmjs.org/icon-gen/-/icon-gen-2.1.0.tgz -> npmpkg-icon-gen-2.1.0.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/icss-replace-symbols/-/icss-replace-symbols-1.1.0.tgz -> npmpkg-icss-replace-symbols-1.1.0.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-2.1.0.tgz -> npmpkg-icss-utils-2.1.0.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/iferr/-/iferr-0.1.5.tgz -> npmpkg-iferr-0.1.5.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/image-q/-/image-q-4.0.0.tgz -> npmpkg-image-q-4.0.0.tgz
https://registry.npmjs.org/@types/node/-/node-16.9.1.tgz -> npmpkg-@types-node-16.9.1.tgz
https://registry.npmjs.org/immediate/-/immediate-3.0.6.tgz -> npmpkg-immediate-3.0.6.tgz
https://registry.npmjs.org/import-cwd/-/import-cwd-2.1.0.tgz -> npmpkg-import-cwd-2.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-2.0.0.tgz -> npmpkg-import-fresh-2.0.0.tgz
https://registry.npmjs.org/import-from/-/import-from-2.1.0.tgz -> npmpkg-import-from-2.1.0.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-2.1.0.tgz -> npmpkg-import-lazy-2.1.0.tgz
https://registry.npmjs.org/import-local/-/import-local-1.0.0.tgz -> npmpkg-import-local-1.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/indexes-of/-/indexes-of-1.0.1.tgz -> npmpkg-indexes-of-1.0.1.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/inquirer/-/inquirer-6.5.2.tgz -> npmpkg-inquirer-6.5.2.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/internal-ip/-/internal-ip-4.3.0.tgz -> npmpkg-internal-ip-4.3.0.tgz
https://registry.npmjs.org/default-gateway/-/default-gateway-4.2.0.tgz -> npmpkg-default-gateway-4.2.0.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.6.tgz -> npmpkg-internal-slot-1.0.6.tgz
https://registry.npmjs.org/intersection-observer/-/intersection-observer-0.5.1.tgz -> npmpkg-intersection-observer-0.5.1.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/invert-kv/-/invert-kv-2.0.0.tgz -> npmpkg-invert-kv-2.0.0.tgz
https://registry.npmjs.org/iobuffer/-/iobuffer-5.3.2.tgz -> npmpkg-iobuffer-5.3.2.tgz
https://registry.npmjs.org/ip/-/ip-1.1.8.tgz -> npmpkg-ip-1.1.8.tgz
https://registry.npmjs.org/ip-regex/-/ip-regex-2.1.0.tgz -> npmpkg-ip-regex-2.1.0.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> npmpkg-ipaddr.js-1.9.1.tgz
https://registry.npmjs.org/is-absolute-url/-/is-absolute-url-2.1.0.tgz -> npmpkg-is-absolute-url-2.1.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.1.tgz -> npmpkg-is-accessor-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-1.2.1.tgz -> npmpkg-is-ci-1.2.1.tgz
https://registry.npmjs.org/is-color-stop/-/is-color-stop-1.1.0.tgz -> npmpkg-is-color-stop-1.1.0.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.1.tgz -> npmpkg-is-data-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.3.tgz -> npmpkg-is-descriptor-1.0.3.tgz
https://registry.npmjs.org/is-directory/-/is-directory-0.3.1.tgz -> npmpkg-is-directory-0.3.1.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finite/-/is-finite-1.1.0.tgz -> npmpkg-is-finite-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-function/-/is-function-1.0.2.tgz -> npmpkg-is-function-1.0.2.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-1.0.0.tgz -> npmpkg-is-generator-fn-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.1.0.tgz -> npmpkg-is-installed-globally-0.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-1.0.1.tgz -> npmpkg-is-path-inside-1.0.1.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-npm/-/is-npm-3.0.0.tgz -> npmpkg-is-npm-3.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-1.0.1.tgz -> npmpkg-is-obj-1.0.1.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz -> npmpkg-is-path-in-cwd-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-2.1.0.tgz -> npmpkg-is-path-inside-2.1.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-resolvable/-/is-resolvable-1.1.0.tgz -> npmpkg-is-resolvable-1.1.0.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.12.tgz -> npmpkg-is-typed-array-1.1.12.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-whitespace/-/is-whitespace-0.3.0.tgz -> npmpkg-is-whitespace-0.3.0.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> npmpkg-is-yarn-global-0.3.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/istanbul-api/-/istanbul-api-1.3.7.tgz -> npmpkg-istanbul-api-1.3.7.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-1.2.1.tgz -> npmpkg-istanbul-lib-coverage-1.2.1.tgz
https://registry.npmjs.org/istanbul-lib-hook/-/istanbul-lib-hook-1.2.2.tgz -> npmpkg-istanbul-lib-hook-1.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-1.10.2.tgz -> npmpkg-istanbul-lib-instrument-1.10.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-1.1.5.tgz -> npmpkg-istanbul-lib-report-1.1.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-1.0.0.tgz -> npmpkg-has-flag-1.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-3.2.3.tgz -> npmpkg-supports-color-3.2.3.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-1.2.6.tgz -> npmpkg-istanbul-lib-source-maps-1.2.6.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-1.5.1.tgz -> npmpkg-istanbul-reports-1.5.1.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-2.3.6.tgz -> npmpkg-jackspeak-2.3.6.tgz
https://registry.npmjs.org/javascript-stringify/-/javascript-stringify-1.6.0.tgz -> npmpkg-javascript-stringify-1.6.0.tgz
https://registry.npmjs.org/jest/-/jest-23.6.0.tgz -> npmpkg-jest-23.6.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-23.4.2.tgz -> npmpkg-jest-changed-files-23.4.2.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-23.6.0.tgz -> npmpkg-jest-cli-23.6.0.tgz
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
https://registry.npmjs.org/jest-config/-/jest-config-23.6.0.tgz -> npmpkg-jest-config-23.6.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
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
https://registry.npmjs.org/jest-diff/-/jest-diff-23.6.0.tgz -> npmpkg-jest-diff-23.6.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-23.2.0.tgz -> npmpkg-jest-docblock-23.2.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-23.6.0.tgz -> npmpkg-jest-each-23.6.0.tgz
https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-23.4.0.tgz -> npmpkg-jest-environment-jsdom-23.4.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-23.4.0.tgz -> npmpkg-jest-environment-node-23.4.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-22.4.3.tgz -> npmpkg-jest-get-type-22.4.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-23.6.0.tgz -> npmpkg-jest-haste-map-23.6.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/jest-jasmine2/-/jest-jasmine2-23.6.0.tgz -> npmpkg-jest-jasmine2-23.6.0.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-23.6.0.tgz -> npmpkg-jest-leak-detector-23.6.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-23.6.0.tgz -> npmpkg-jest-matcher-utils-23.6.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-23.4.0.tgz -> npmpkg-jest-message-util-23.4.0.tgz
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
https://registry.npmjs.org/jest-mock/-/jest-mock-23.2.0.tgz -> npmpkg-jest-mock-23.2.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-23.3.0.tgz -> npmpkg-jest-regex-util-23.3.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-23.6.0.tgz -> npmpkg-jest-resolve-23.6.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-23.6.0.tgz -> npmpkg-jest-resolve-dependencies-23.6.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-23.6.0.tgz -> npmpkg-jest-runner-23.6.0.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-23.6.0.tgz -> npmpkg-jest-runtime-23.6.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-4.1.0.tgz -> npmpkg-cliui-4.1.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
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
https://registry.npmjs.org/jest-serializer/-/jest-serializer-23.0.1.tgz -> npmpkg-jest-serializer-23.0.1.tgz
https://registry.npmjs.org/jest-serializer-vue/-/jest-serializer-vue-2.0.2.tgz -> npmpkg-jest-serializer-vue-2.0.2.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-23.6.0.tgz -> npmpkg-jest-snapshot-23.6.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/jest-transform-stub/-/jest-transform-stub-2.0.0.tgz -> npmpkg-jest-transform-stub-2.0.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-23.4.0.tgz -> npmpkg-jest-util-23.4.0.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-23.6.0.tgz -> npmpkg-jest-validate-23.6.0.tgz
https://registry.npmjs.org/jest-watch-typeahead/-/jest-watch-typeahead-0.2.1.tgz -> npmpkg-jest-watch-typeahead-0.2.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-23.4.0.tgz -> npmpkg-jest-watcher-23.4.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-23.2.0.tgz -> npmpkg-jest-worker-23.2.0.tgz
https://registry.npmjs.org/jimp/-/jimp-0.16.13.tgz -> npmpkg-jimp-0.16.13.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> npmpkg-regenerator-runtime-0.13.11.tgz
https://registry.npmjs.org/jpeg-js/-/jpeg-js-0.4.4.tgz -> npmpkg-jpeg-js-0.4.4.tgz
https://registry.npmjs.org/jquery/-/jquery-3.7.1.tgz -> npmpkg-jquery-3.7.1.tgz
https://registry.npmjs.org/js-beautify/-/js-beautify-1.14.11.tgz -> npmpkg-js-beautify-1.14.11.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/glob/-/glob-10.3.10.tgz -> npmpkg-glob-10.3.10.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.3.tgz -> npmpkg-minimatch-9.0.3.tgz
https://registry.npmjs.org/js-levenshtein/-/js-levenshtein-1.1.6.tgz -> npmpkg-js-levenshtein-1.1.6.tgz
https://registry.npmjs.org/js-message/-/js-message-1.0.7.tgz -> npmpkg-js-message-1.0.7.tgz
https://registry.npmjs.org/js-queue/-/js-queue-2.0.2.tgz -> npmpkg-js-queue-2.0.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/jsdom/-/jsdom-11.12.0.tgz -> npmpkg-jsdom-11.12.0.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/parse5/-/parse5-4.0.0.tgz -> npmpkg-parse5-4.0.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz -> npmpkg-json-buffer-3.0.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.2.tgz -> npmpkg-jsprim-1.4.2.tgz
https://registry.npmjs.org/jszip/-/jszip-3.10.1.tgz -> npmpkg-jszip-3.10.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/kew/-/kew-0.7.0.tgz -> npmpkg-kew-0.7.0.tgz
https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz -> npmpkg-keyv-3.1.0.tgz
https://registry.npmjs.org/killable/-/killable-1.0.1.tgz -> npmpkg-killable-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/klaw/-/klaw-1.3.1.tgz -> npmpkg-klaw-1.3.1.tgz
https://registry.npmjs.org/kleur/-/kleur-2.0.2.tgz -> npmpkg-kleur-2.0.2.tgz
https://registry.npmjs.org/latest-version/-/latest-version-5.1.0.tgz -> npmpkg-latest-version-5.1.0.tgz
https://registry.npmjs.org/launch-editor/-/launch-editor-2.6.1.tgz -> npmpkg-launch-editor-2.6.1.tgz
https://registry.npmjs.org/launch-editor-middleware/-/launch-editor-middleware-2.6.1.tgz -> npmpkg-launch-editor-middleware-2.6.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/lcid/-/lcid-2.0.0.tgz -> npmpkg-lcid-2.0.0.tgz
https://registry.npmjs.org/left-pad/-/left-pad-1.3.0.tgz -> npmpkg-left-pad-1.3.0.tgz
https://registry.npmjs.org/leven/-/leven-2.1.0.tgz -> npmpkg-leven-2.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/lie/-/lie-3.3.0.tgz -> npmpkg-lie-3.3.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/load-bmfont/-/load-bmfont-1.4.1.tgz -> npmpkg-load-bmfont-1.4.1.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/loader-fs-cache/-/loader-fs-cache-1.0.3.tgz -> npmpkg-loader-fs-cache-1.0.3.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-0.1.1.tgz -> npmpkg-find-cache-dir-0.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-1.0.0.tgz -> npmpkg-pkg-dir-1.0.0.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-2.4.0.tgz -> npmpkg-loader-runner-2.4.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaultsdeep/-/lodash.defaultsdeep-4.6.1.tgz -> npmpkg-lodash.defaultsdeep-4.6.1.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz -> npmpkg-lodash.get-4.4.2.tgz
https://registry.npmjs.org/lodash.has/-/lodash.has-4.5.2.tgz -> npmpkg-lodash.has-4.5.2.tgz
https://registry.npmjs.org/lodash.kebabcase/-/lodash.kebabcase-4.1.1.tgz -> npmpkg-lodash.kebabcase-4.1.1.tgz
https://registry.npmjs.org/lodash.mapvalues/-/lodash.mapvalues-4.6.0.tgz -> npmpkg-lodash.mapvalues-4.6.0.tgz
https://registry.npmjs.org/lodash.memoize/-/lodash.memoize-4.1.2.tgz -> npmpkg-lodash.memoize-4.1.2.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.set/-/lodash.set-4.3.2.tgz -> npmpkg-lodash.set-4.3.2.tgz
https://registry.npmjs.org/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> npmpkg-lodash.sortby-4.7.0.tgz
https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> npmpkg-lodash.throttle-4.1.1.tgz
https://registry.npmjs.org/lodash.transform/-/lodash.transform-4.6.0.tgz -> npmpkg-lodash.transform-4.6.0.tgz
https://registry.npmjs.org/lodash.unescape/-/lodash.unescape-4.0.1.tgz -> npmpkg-lodash.unescape-4.0.1.tgz
https://registry.npmjs.org/lodash.uniq/-/lodash.uniq-4.5.0.tgz -> npmpkg-lodash.uniq-4.5.0.tgz
https://registry.npmjs.org/lodash.unset/-/lodash.unset-4.5.2.tgz -> npmpkg-lodash.unset-4.5.2.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-2.2.0.tgz -> npmpkg-log-symbols-2.2.0.tgz
https://registry.npmjs.org/loglevel/-/loglevel-1.8.1.tgz -> npmpkg-loglevel-1.8.1.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lower-case/-/lower-case-1.1.4.tgz -> npmpkg-lower-case-1.1.4.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru_map/-/lru_map-0.3.3.tgz -> npmpkg-lru_map-0.3.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/map-age-cleaner/-/map-age-cleaner-0.1.3.tgz -> npmpkg-map-age-cleaner-0.1.3.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/material-colors/-/material-colors-1.2.6.tgz -> npmpkg-material-colors-1.2.6.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/md5.js/-/md5.js-1.3.5.tgz -> npmpkg-md5.js-1.3.5.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.4.tgz -> npmpkg-mdn-data-2.0.4.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz -> npmpkg-media-typer-0.3.0.tgz
https://registry.npmjs.org/mem/-/mem-4.3.0.tgz -> npmpkg-mem-4.3.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.5.0.tgz -> npmpkg-memory-fs-0.5.0.tgz
https://registry.npmjs.org/merge/-/merge-1.2.1.tgz -> npmpkg-merge-1.2.1.tgz
https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz -> npmpkg-merge-descriptors-1.0.1.tgz
https://registry.npmjs.org/merge-source-map/-/merge-source-map-1.1.0.tgz -> npmpkg-merge-source-map-1.1.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-1.0.1.tgz -> npmpkg-merge-stream-1.0.1.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/methods/-/methods-1.1.2.tgz -> npmpkg-methods-1.1.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/miller-rabin/-/miller-rabin-4.0.1.tgz -> npmpkg-miller-rabin-4.0.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-1.2.0.tgz -> npmpkg-mimic-fn-1.2.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/min-document/-/min-document-2.19.0.tgz -> npmpkg-min-document-2.19.0.tgz
https://registry.npmjs.org/mini-css-extract-plugin/-/mini-css-extract-plugin-0.8.2.tgz -> npmpkg-mini-css-extract-plugin-0.8.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-1.9.1.tgz -> npmpkg-normalize-url-1.9.1.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-1.0.4.tgz -> npmpkg-prepend-http-1.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> npmpkg-minimalistic-assert-1.0.1.tgz
https://registry.npmjs.org/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> npmpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-7.0.4.tgz -> npmpkg-minipass-7.0.4.tgz
https://registry.npmjs.org/mississippi/-/mississippi-2.0.0.tgz -> npmpkg-mississippi-2.0.0.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/move-concurrently/-/move-concurrently-1.0.1.tgz -> npmpkg-move-concurrently-1.0.1.tgz
https://registry.npmjs.org/mri/-/mri-1.1.4.tgz -> npmpkg-mri-1.1.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/multicast-dns/-/multicast-dns-6.2.3.tgz -> npmpkg-multicast-dns-6.2.3.tgz
https://registry.npmjs.org/multicast-dns-service-types/-/multicast-dns-service-types-1.1.0.tgz -> npmpkg-multicast-dns-service-types-1.1.0.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.7.tgz -> npmpkg-mute-stream-0.0.7.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/nan/-/nan-2.18.0.tgz -> npmpkg-nan-2.18.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz -> npmpkg-negotiator-0.6.3.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/no-case/-/no-case-2.3.2.tgz -> npmpkg-no-case-2.3.2.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.52.0.tgz -> npmpkg-node-abi-3.52.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-4.3.0.tgz -> npmpkg-node-addon-api-4.3.0.tgz
https://registry.npmjs.org/node-cache/-/node-cache-4.2.1.tgz -> npmpkg-node-cache-4.2.1.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz -> npmpkg-node-fetch-2.7.0.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/node-forge/-/node-forge-0.10.0.tgz -> npmpkg-node-forge-0.10.0.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-ipc/-/node-ipc-9.2.1.tgz -> npmpkg-node-ipc-9.2.1.tgz
https://registry.npmjs.org/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> npmpkg-node-libs-browser-2.2.1.tgz
https://registry.npmjs.org/buffer/-/buffer-4.9.2.tgz -> npmpkg-buffer-4.9.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/node-notifier/-/node-notifier-5.4.5.tgz -> npmpkg-node-notifier-5.4.5.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.14.tgz -> npmpkg-node-releases-2.0.14.tgz
https://registry.npmjs.org/nopt/-/nopt-7.2.0.tgz -> npmpkg-nopt-7.2.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.1.tgz -> npmpkg-normalize-url-4.5.1.tgz
https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz -> npmpkg-npm-conf-1.1.3.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/npm-install-package/-/npm-install-package-2.1.0.tgz -> npmpkg-npm-install-package-2.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nugget/-/nugget-2.2.0.tgz -> npmpkg-nugget-2.2.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz -> npmpkg-throttleit-0.0.2.tgz
https://registry.npmjs.org/num2fraction/-/num2fraction-1.2.2.tgz -> npmpkg-num2fraction-1.2.2.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.7.tgz -> npmpkg-nwsapi-2.2.7.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.9.0.tgz -> npmpkg-oauth-sign-0.9.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/object-hash/-/object-hash-1.3.1.tgz -> npmpkg-object-hash-1.3.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.5.tgz -> npmpkg-object-is-1.1.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/object.getownpropertydescriptors/-/object.getownpropertydescriptors-2.1.7.tgz -> npmpkg-object.getownpropertydescriptors-2.1.7.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.7.tgz -> npmpkg-object.values-1.1.7.tgz
https://registry.npmjs.org/obuf/-/obuf-1.1.2.tgz -> npmpkg-obuf-1.1.2.tgz
https://registry.npmjs.org/omggif/-/omggif-1.0.10.tgz -> npmpkg-omggif-1.0.10.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz -> npmpkg-on-finished-2.4.1.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.0.2.tgz -> npmpkg-on-headers-1.0.2.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-2.0.1.tgz -> npmpkg-onetime-2.0.1.tgz
https://registry.npmjs.org/open/-/open-6.4.0.tgz -> npmpkg-open-6.4.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/opener/-/opener-1.5.2.tgz -> npmpkg-opener-1.5.2.tgz
https://registry.npmjs.org/opn/-/opn-5.5.0.tgz -> npmpkg-opn-5.5.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz -> npmpkg-optimist-0.6.1.tgz
https://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz -> npmpkg-minimist-0.0.10.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz -> npmpkg-wordwrap-0.0.3.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/ora/-/ora-3.4.0.tgz -> npmpkg-ora-3.4.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/os-browserify/-/os-browserify-0.3.0.tgz -> npmpkg-os-browserify-0.3.0.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-locale/-/os-locale-3.1.0.tgz -> npmpkg-os-locale-3.1.0.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz -> npmpkg-p-cancelable-1.1.0.tgz
https://registry.npmjs.org/p-defer/-/p-defer-1.0.0.tgz -> npmpkg-p-defer-1.0.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/p-is-promise/-/p-is-promise-2.1.0.tgz -> npmpkg-p-is-promise-2.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/p-retry/-/p-retry-3.0.1.tgz -> npmpkg-p-retry-3.0.1.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/package-json/-/package-json-6.5.0.tgz -> npmpkg-package-json-6.5.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/pako/-/pako-2.1.0.tgz -> npmpkg-pako-2.1.0.tgz
https://registry.npmjs.org/parallel-transform/-/parallel-transform-1.2.0.tgz -> npmpkg-parallel-transform-1.2.0.tgz
https://registry.npmjs.org/param-case/-/param-case-2.1.1.tgz -> npmpkg-param-case-2.1.1.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/parse-asn1/-/parse-asn1-5.1.6.tgz -> npmpkg-parse-asn1-5.1.6.tgz
https://registry.npmjs.org/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> npmpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> npmpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz -> npmpkg-parse-bmfont-xml-1.1.4.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/parse-headers/-/parse-headers-2.0.5.tgz -> npmpkg-parse-headers-2.0.5.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-5.1.1.tgz -> npmpkg-parse5-5.1.1.tgz
https://registry.npmjs.org/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-6.0.1.tgz -> npmpkg-parse5-htmlparser2-tree-adapter-6.0.1.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-0.0.1.tgz -> npmpkg-path-browserify-0.0.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.2.tgz -> npmpkg-path-is-inside-1.0.2.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.10.1.tgz -> npmpkg-path-scurry-1.10.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.1.0.tgz -> npmpkg-lru-cache-10.1.0.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-1.8.0.tgz -> npmpkg-path-to-regexp-1.8.0.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pbkdf2/-/pbkdf2-3.1.2.tgz -> npmpkg-pbkdf2-3.1.2.tgz
https://registry.npmjs.org/peek-readable/-/peek-readable-4.1.0.tgz -> npmpkg-peek-readable-4.1.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/phantomjs-prebuilt/-/phantomjs-prebuilt-2.1.16.tgz -> npmpkg-phantomjs-prebuilt-2.1.16.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-1.0.0.tgz -> npmpkg-fs-extra-1.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-2.4.0.tgz -> npmpkg-jsonfile-2.4.0.tgz
https://registry.npmjs.org/progress/-/progress-1.1.8.tgz -> npmpkg-progress-1.1.8.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/phin/-/phin-2.9.3.tgz -> npmpkg-phin-2.9.3.tgz
https://registry.npmjs.org/picocolors/-/picocolors-0.2.1.tgz -> npmpkg-picocolors-0.2.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pixelmatch/-/pixelmatch-4.0.2.tgz -> npmpkg-pixelmatch-4.0.2.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/pkg-up/-/pkg-up-2.0.0.tgz -> npmpkg-pkg-up-2.0.0.tgz
https://registry.npmjs.org/pluralize/-/pluralize-7.0.0.tgz -> npmpkg-pluralize-7.0.0.tgz
https://registry.npmjs.org/pn/-/pn-1.1.0.tgz -> npmpkg-pn-1.1.0.tgz
https://registry.npmjs.org/pngjs/-/pngjs-6.0.0.tgz -> npmpkg-pngjs-6.0.0.tgz
https://registry.npmjs.org/portfinder/-/portfinder-1.0.32.tgz -> npmpkg-portfinder-1.0.32.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/postcss/-/postcss-7.0.39.tgz -> npmpkg-postcss-7.0.39.tgz
https://registry.npmjs.org/postcss-calc/-/postcss-calc-7.0.5.tgz -> npmpkg-postcss-calc-7.0.5.tgz
https://registry.npmjs.org/postcss-colormin/-/postcss-colormin-4.0.3.tgz -> npmpkg-postcss-colormin-4.0.3.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-convert-values/-/postcss-convert-values-4.0.1.tgz -> npmpkg-postcss-convert-values-4.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-discard-comments/-/postcss-discard-comments-4.0.2.tgz -> npmpkg-postcss-discard-comments-4.0.2.tgz
https://registry.npmjs.org/postcss-discard-duplicates/-/postcss-discard-duplicates-4.0.2.tgz -> npmpkg-postcss-discard-duplicates-4.0.2.tgz
https://registry.npmjs.org/postcss-discard-empty/-/postcss-discard-empty-4.0.1.tgz -> npmpkg-postcss-discard-empty-4.0.1.tgz
https://registry.npmjs.org/postcss-discard-overridden/-/postcss-discard-overridden-4.0.1.tgz -> npmpkg-postcss-discard-overridden-4.0.1.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-2.1.2.tgz -> npmpkg-postcss-load-config-2.1.2.tgz
https://registry.npmjs.org/postcss-loader/-/postcss-loader-3.0.0.tgz -> npmpkg-postcss-loader-3.0.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/postcss-merge-longhand/-/postcss-merge-longhand-4.0.11.tgz -> npmpkg-postcss-merge-longhand-4.0.11.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-merge-rules/-/postcss-merge-rules-4.0.3.tgz -> npmpkg-postcss-merge-rules-4.0.3.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss-minify-font-values/-/postcss-minify-font-values-4.0.2.tgz -> npmpkg-postcss-minify-font-values-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-minify-gradients/-/postcss-minify-gradients-4.0.2.tgz -> npmpkg-postcss-minify-gradients-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-minify-params/-/postcss-minify-params-4.0.2.tgz -> npmpkg-postcss-minify-params-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-minify-selectors/-/postcss-minify-selectors-4.0.2.tgz -> npmpkg-postcss-minify-selectors-4.0.2.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-1.2.1.tgz -> npmpkg-postcss-modules-extract-imports-1.2.1.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-1.2.0.tgz -> npmpkg-postcss-modules-local-by-default-1.2.0.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-1.1.0.tgz -> npmpkg-postcss-modules-scope-1.1.0.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-1.3.0.tgz -> npmpkg-postcss-modules-values-1.3.0.tgz
https://registry.npmjs.org/postcss/-/postcss-6.0.23.tgz -> npmpkg-postcss-6.0.23.tgz
https://registry.npmjs.org/postcss-normalize-charset/-/postcss-normalize-charset-4.0.1.tgz -> npmpkg-postcss-normalize-charset-4.0.1.tgz
https://registry.npmjs.org/postcss-normalize-display-values/-/postcss-normalize-display-values-4.0.2.tgz -> npmpkg-postcss-normalize-display-values-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-positions/-/postcss-normalize-positions-4.0.2.tgz -> npmpkg-postcss-normalize-positions-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-repeat-style/-/postcss-normalize-repeat-style-4.0.2.tgz -> npmpkg-postcss-normalize-repeat-style-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-string/-/postcss-normalize-string-4.0.2.tgz -> npmpkg-postcss-normalize-string-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-timing-functions/-/postcss-normalize-timing-functions-4.0.2.tgz -> npmpkg-postcss-normalize-timing-functions-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-unicode/-/postcss-normalize-unicode-4.0.1.tgz -> npmpkg-postcss-normalize-unicode-4.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-url/-/postcss-normalize-url-4.0.1.tgz -> npmpkg-postcss-normalize-url-4.0.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-3.3.0.tgz -> npmpkg-normalize-url-3.3.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-normalize-whitespace/-/postcss-normalize-whitespace-4.0.2.tgz -> npmpkg-postcss-normalize-whitespace-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-ordered-values/-/postcss-ordered-values-4.1.2.tgz -> npmpkg-postcss-ordered-values-4.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-reduce-initial/-/postcss-reduce-initial-4.0.3.tgz -> npmpkg-postcss-reduce-initial-4.0.3.tgz
https://registry.npmjs.org/postcss-reduce-transforms/-/postcss-reduce-transforms-4.0.2.tgz -> npmpkg-postcss-reduce-transforms-4.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.14.tgz -> npmpkg-postcss-selector-parser-6.0.14.tgz
https://registry.npmjs.org/postcss-svgo/-/postcss-svgo-4.0.3.tgz -> npmpkg-postcss-svgo-4.0.3.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-unique-selectors/-/postcss-unique-selectors-4.0.1.tgz -> npmpkg-postcss-unique-selectors-4.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.1.tgz -> npmpkg-prebuild-install-7.1.1.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.2.tgz -> npmpkg-detect-libc-2.0.2.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz -> npmpkg-prepend-http-2.0.0.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz -> npmpkg-prettier-linter-helpers-1.0.0.tgz
https://registry.npmjs.org/pretty/-/pretty-2.0.0.tgz -> npmpkg-pretty-2.0.0.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-4.0.2.tgz -> npmpkg-pretty-bytes-4.0.2.tgz
https://registry.npmjs.org/pretty-error/-/pretty-error-2.1.2.tgz -> npmpkg-pretty-error-2.1.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-23.6.0.tgz -> npmpkg-pretty-format-23.6.0.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/progress-stream/-/progress-stream-1.2.0.tgz -> npmpkg-progress-stream-1.2.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-0.4.0.tgz -> npmpkg-object-keys-0.4.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz -> npmpkg-readable-stream-1.1.14.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/through2/-/through2-0.2.3.tgz -> npmpkg-through2-0.2.3.tgz
https://registry.npmjs.org/xtend/-/xtend-2.1.2.tgz -> npmpkg-xtend-2.1.2.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/prompts/-/prompts-0.1.14.tgz -> npmpkg-prompts-0.1.14.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proxy-addr/-/proxy-addr-2.0.7.tgz -> npmpkg-proxy-addr-2.0.7.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz -> npmpkg-prr-1.0.1.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/public-encrypt/-/public-encrypt-4.0.3.tgz -> npmpkg-public-encrypt-4.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/q/-/q-1.5.1.tgz -> npmpkg-q-1.5.1.tgz
https://registry.npmjs.org/qs/-/qs-6.5.3.tgz -> npmpkg-qs-6.5.3.tgz
https://registry.npmjs.org/query-string/-/query-string-4.3.4.tgz -> npmpkg-query-string-4.3.4.tgz
https://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz -> npmpkg-querystring-es3-0.2.1.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/randomfill/-/randomfill-1.0.4.tgz -> npmpkg-randomfill-1.0.4.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.1.tgz -> npmpkg-range-parser-1.2.1.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.1.tgz -> npmpkg-raw-body-2.5.1.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/react/-/react-16.14.0.tgz -> npmpkg-react-16.14.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-16.14.0.tgz -> npmpkg-react-dom-16.14.0.tgz
https://registry.npmjs.org/react-interactive/-/react-interactive-0.8.3.tgz -> npmpkg-react-interactive-0.8.3.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/react-router/-/react-router-4.3.1.tgz -> npmpkg-react-router-4.3.1.tgz
https://registry.npmjs.org/react-router-dom/-/react-router-dom-4.3.1.tgz -> npmpkg-react-router-dom-4.3.1.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-5.0.0.tgz -> npmpkg-read-config-file-5.0.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.6.0.tgz -> npmpkg-dotenv-8.6.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> npmpkg-read-pkg-up-1.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-web-to-node-stream/-/readable-web-to-node-stream-3.0.2.tgz -> npmpkg-readable-web-to-node-stream-3.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/realpath-native/-/realpath-native-1.1.0.tgz -> npmpkg-realpath-native-1.1.0.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> npmpkg-regenerator-runtime-0.14.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.1.tgz -> npmpkg-regexp.prototype.flags-1.5.1.tgz
https://registry.npmjs.org/regexpp/-/regexpp-3.2.0.tgz -> npmpkg-regexpp-3.2.0.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-4.2.2.tgz -> npmpkg-registry-auth-token-4.2.2.tgz
https://registry.npmjs.org/registry-url/-/registry-url-5.1.0.tgz -> npmpkg-registry-url-5.1.0.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/relateurl/-/relateurl-0.2.7.tgz -> npmpkg-relateurl-0.2.7.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/renderkid/-/renderkid-2.0.7.tgz -> npmpkg-renderkid-2.0.7.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/repeating/-/repeating-2.0.1.tgz -> npmpkg-repeating-2.0.1.tgz
https://registry.npmjs.org/request/-/request-2.88.2.tgz -> npmpkg-request-2.88.2.tgz
https://registry.npmjs.org/request-progress/-/request-progress-2.0.1.tgz -> npmpkg-request-progress-2.0.1.tgz
https://registry.npmjs.org/request-promise-core/-/request-promise-core-1.1.4.tgz -> npmpkg-request-promise-core-1.1.4.tgz
https://registry.npmjs.org/request-promise-native/-/request-promise-native-1.0.9.tgz -> npmpkg-request-promise-native-1.0.9.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-1.0.1.tgz -> npmpkg-require-main-filename-1.0.1.tgz
https://registry.npmjs.org/require-uncached/-/require-uncached-1.0.3.tgz -> npmpkg-require-uncached-1.0.3.tgz
https://registry.npmjs.org/caller-path/-/caller-path-0.1.0.tgz -> npmpkg-caller-path-0.1.0.tgz
https://registry.npmjs.org/callsites/-/callsites-0.2.0.tgz -> npmpkg-callsites-0.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-1.0.1.tgz -> npmpkg-resolve-from-1.0.1.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/reselect/-/reselect-3.0.1.tgz -> npmpkg-reselect-3.0.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> npmpkg-resolve-cwd-2.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-3.0.0.tgz -> npmpkg-resolve-from-3.0.0.tgz
https://registry.npmjs.org/resolve-pathname/-/resolve-pathname-3.0.0.tgz -> npmpkg-resolve-pathname-3.0.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz -> npmpkg-responselike-1.0.2.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-2.0.0.tgz -> npmpkg-restore-cursor-2.0.0.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rgb-regex/-/rgb-regex-1.0.1.tgz -> npmpkg-rgb-regex-1.0.1.tgz
https://registry.npmjs.org/rgb2hex/-/rgb2hex-0.1.10.tgz -> npmpkg-rgb2hex-0.1.10.tgz
https://registry.npmjs.org/rgba-regex/-/rgba-regex-1.0.0.tgz -> npmpkg-rgba-regex-1.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/ripemd160/-/ripemd160-2.0.2.tgz -> npmpkg-ripemd160-2.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/rsvp/-/rsvp-3.6.2.tgz -> npmpkg-rsvp-3.6.2.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/run-queue/-/run-queue-1.0.3.tgz -> npmpkg-run-queue-1.0.3.tgz
https://registry.npmjs.org/rx-lite/-/rx-lite-4.0.8.tgz -> npmpkg-rx-lite-4.0.8.tgz
https://registry.npmjs.org/rx-lite-aggregates/-/rx-lite-aggregates-4.0.8.tgz -> npmpkg-rx-lite-aggregates-4.0.8.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.0.1.tgz -> npmpkg-safe-array-concat-1.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sane/-/sane-2.5.2.tgz -> npmpkg-sane-2.5.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.3.0.tgz -> npmpkg-sax-1.3.0.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.19.1.tgz -> npmpkg-scheduler-0.19.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/select-hose/-/select-hose-2.0.0.tgz -> npmpkg-select-hose-2.0.0.tgz
https://registry.npmjs.org/selfsigned/-/selfsigned-1.10.14.tgz -> npmpkg-selfsigned-1.10.14.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-2.1.0.tgz -> npmpkg-semver-diff-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/send/-/send-0.18.0.tgz -> npmpkg-send-0.18.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-1.9.1.tgz -> npmpkg-serialize-javascript-1.9.1.tgz
https://registry.npmjs.org/serve-index/-/serve-index-1.9.1.tgz -> npmpkg-serve-index-1.9.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.3.tgz -> npmpkg-http-errors-1.6.3.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.1.0.tgz -> npmpkg-setprototypeof-1.1.0.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/serve-static/-/serve-static-1.15.0.tgz -> npmpkg-serve-static-1.15.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.1.1.tgz -> npmpkg-set-function-length-1.1.1.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.1.tgz -> npmpkg-set-function-name-2.0.1.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/sha.js/-/sha.js-2.4.11.tgz -> npmpkg-sha.js-2.4.11.tgz
https://registry.npmjs.org/sharp/-/sharp-0.29.3.tgz -> npmpkg-sharp-0.29.3.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-loader/-/shebang-loader-0.0.1.tgz -> npmpkg-shebang-loader-0.0.1.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.1.tgz -> npmpkg-shell-quote-1.8.1.tgz
https://registry.npmjs.org/shellwords/-/shellwords-0.1.1.tgz -> npmpkg-shellwords-0.1.1.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> npmpkg-simple-swizzle-0.2.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/single-line-log/-/single-line-log-1.1.2.tgz -> npmpkg-single-line-log-1.1.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-0.1.1.tgz -> npmpkg-sisteransi-0.1.1.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-2.1.0.tgz -> npmpkg-slice-ansi-2.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/sockjs/-/sockjs-0.3.24.tgz -> npmpkg-sockjs-0.3.24.tgz
https://registry.npmjs.org/sockjs-client/-/sockjs-client-1.6.1.tgz -> npmpkg-sockjs-client-1.6.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-1.1.2.tgz -> npmpkg-sort-keys-1.1.2.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.16.tgz -> npmpkg-spdx-license-ids-3.0.16.tgz
https://registry.npmjs.org/spdy/-/spdy-4.0.2.tgz -> npmpkg-spdy-4.0.2.tgz
https://registry.npmjs.org/spdy-transport/-/spdy-transport-3.0.0.tgz -> npmpkg-spdy-transport-3.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/spectron/-/spectron-7.0.0.tgz -> npmpkg-spectron-7.0.0.tgz
https://registry.npmjs.org/speedometer/-/speedometer-0.1.4.tgz -> npmpkg-speedometer-0.1.4.tgz
https://registry.npmjs.org/split/-/split-1.0.1.tgz -> npmpkg-split-1.0.1.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/split2/-/split2-3.2.2.tgz -> npmpkg-split2-3.2.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.18.0.tgz -> npmpkg-sshpk-1.18.0.tgz
https://registry.npmjs.org/ssri/-/ssri-6.0.2.tgz -> npmpkg-ssri-6.0.2.tgz
https://registry.npmjs.org/stable/-/stable-0.1.8.tgz -> npmpkg-stable-0.1.8.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-1.0.5.tgz -> npmpkg-stack-utils-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/stackframe/-/stackframe-1.3.4.tgz -> npmpkg-stackframe-1.3.4.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-0.3.0.tgz -> npmpkg-stat-mode-0.3.0.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/stealthy-require/-/stealthy-require-1.1.1.tgz -> npmpkg-stealthy-require-1.1.1.tgz
https://registry.npmjs.org/stream-browserify/-/stream-browserify-2.0.2.tgz -> npmpkg-stream-browserify-2.0.2.tgz
https://registry.npmjs.org/stream-each/-/stream-each-1.2.3.tgz -> npmpkg-stream-each-1.2.3.tgz
https://registry.npmjs.org/stream-http/-/stream-http-2.8.3.tgz -> npmpkg-stream-http-2.8.3.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.1.tgz -> npmpkg-stream-shift-1.0.1.tgz
https://registry.npmjs.org/strict-uri-encode/-/strict-uri-encode-1.1.0.tgz -> npmpkg-strict-uri-encode-1.1.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-length/-/string-length-2.0.0.tgz -> npmpkg-string-length-2.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.padend/-/string.prototype.padend-3.1.5.tgz -> npmpkg-string.prototype.padend-3.1.5.tgz
https://registry.npmjs.org/string.prototype.padstart/-/string.prototype.padstart-3.1.5.tgz -> npmpkg-string.prototype.padstart-3.1.5.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.8.tgz -> npmpkg-string.prototype.trim-1.2.8.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.7.tgz -> npmpkg-string.prototype.trimend-1.0.7.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.7.tgz -> npmpkg-string.prototype.trimstart-1.0.7.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/strip-eof/-/strip-eof-1.0.0.tgz -> npmpkg-strip-eof-1.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-2.0.0.tgz -> npmpkg-strip-indent-2.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/strtok3/-/strtok3-6.3.0.tgz -> npmpkg-strtok3-6.3.0.tgz
https://registry.npmjs.org/stylehacks/-/stylehacks-4.0.3.tgz -> npmpkg-stylehacks-4.0.3.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svg-tags/-/svg-tags-1.0.0.tgz -> npmpkg-svg-tags-1.0.0.tgz
https://registry.npmjs.org/svg2png/-/svg2png-4.1.1.tgz -> npmpkg-svg2png-4.1.1.tgz
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
https://registry.npmjs.org/svgo/-/svgo-1.3.2.tgz -> npmpkg-svgo-1.3.2.tgz
https://registry.npmjs.org/css-select/-/css-select-2.1.0.tgz -> npmpkg-css-select-2.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-3.4.2.tgz -> npmpkg-css-what-3.4.2.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.2.2.tgz -> npmpkg-dom-serializer-0.2.2.tgz
https://registry.npmjs.org/domutils/-/domutils-1.7.0.tgz -> npmpkg-domutils-1.7.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-1.0.2.tgz -> npmpkg-nth-check-1.0.2.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/table/-/table-5.4.6.tgz -> npmpkg-table-5.4.6.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz -> npmpkg-tapable-1.1.3.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/term-size/-/term-size-1.2.0.tgz -> npmpkg-term-size-1.2.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.7.0.tgz -> npmpkg-execa-0.7.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/terser/-/terser-4.8.1.tgz -> npmpkg-terser-4.8.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-1.4.5.tgz -> npmpkg-terser-webpack-plugin-1.4.5.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/mississippi/-/mississippi-3.0.0.tgz -> npmpkg-mississippi-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-4.2.3.tgz -> npmpkg-test-exclude-4.2.3.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/thread-loader/-/thread-loader-2.1.3.tgz -> npmpkg-thread-loader-2.1.3.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/three/-/three-0.118.3.tgz -> npmpkg-three-0.118.3.tgz
https://github.com/nicolaspanel/three-orbitcontrols-ts/archive/b5b2685a88b880822c62275f2a76bdaa3954f76c.tar.gz -> npmpkg-three-orbitcontrols-ts.git-b5b2685a88b880822c62275f2a76bdaa3954f76c.tgz
https://registry.npmjs.org/three/-/three-0.94.0.tgz -> npmpkg-three-0.94.0.tgz
https://registry.npmjs.org/throat/-/throat-4.1.0.tgz -> npmpkg-throat-4.1.0.tgz
https://registry.npmjs.org/throttleit/-/throttleit-1.0.1.tgz -> npmpkg-throttleit-1.0.1.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-3.0.0.tgz -> npmpkg-through2-filter-3.0.0.tgz
https://registry.npmjs.org/through2-map/-/through2-map-3.0.0.tgz -> npmpkg-through2-map-3.0.0.tgz
https://registry.npmjs.org/thunky/-/thunky-1.1.0.tgz -> npmpkg-thunky-1.1.0.tgz
https://registry.npmjs.org/timers-browserify/-/timers-browserify-2.0.12.tgz -> npmpkg-timers-browserify-2.0.12.tgz
https://registry.npmjs.org/timm/-/timm-1.7.1.tgz -> npmpkg-timm-1.7.1.tgz
https://registry.npmjs.org/timsort/-/timsort-0.3.0.tgz -> npmpkg-timsort-0.3.0.tgz
https://registry.npmjs.org/tiny-invariant/-/tiny-invariant-1.3.1.tgz -> npmpkg-tiny-invariant-1.3.1.tgz
https://registry.npmjs.org/tiny-warning/-/tiny-warning-1.0.3.tgz -> npmpkg-tiny-warning-1.0.3.tgz
https://registry.npmjs.org/tinycolor2/-/tinycolor2-1.6.0.tgz -> npmpkg-tinycolor2-1.6.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> npmpkg-to-arraybuffer-1.0.1.tgz
https://registry.npmjs.org/to-buffer/-/to-buffer-1.1.1.tgz -> npmpkg-to-buffer-1.1.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> npmpkg-to-readable-stream-1.0.0.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/token-types/-/token-types-4.2.1.tgz -> npmpkg-token-types-4.2.1.tgz
https://registry.npmjs.org/toposort/-/toposort-1.0.7.tgz -> npmpkg-toposort-1.0.7.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.5.0.tgz -> npmpkg-tough-cookie-2.5.0.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/trim-right/-/trim-right-1.0.1.tgz -> npmpkg-trim-right-1.0.1.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/tryer/-/tryer-1.0.1.tgz -> npmpkg-tryer-1.0.1.tgz
https://registry.npmjs.org/ts-jest/-/ts-jest-23.10.5.tgz -> npmpkg-ts-jest-23.10.5.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/ts-loader/-/ts-loader-5.4.5.tgz -> npmpkg-ts-loader-5.4.5.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/tsconfig/-/tsconfig-7.0.0.tgz -> npmpkg-tsconfig-7.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/tslint/-/tslint-5.20.1.tgz -> npmpkg-tslint-5.20.1.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tsutils/-/tsutils-2.29.0.tgz -> npmpkg-tsutils-2.29.0.tgz
https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz -> npmpkg-tsutils-3.21.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz -> npmpkg-tty-browserify-0.0.0.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz -> npmpkg-type-is-1.6.18.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.0.tgz -> npmpkg-typed-array-buffer-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.0.tgz -> npmpkg-typed-array-byte-length-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.0.tgz -> npmpkg-typed-array-byte-offset-1.0.0.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/typeface-open-sans/-/typeface-open-sans-0.0.75.tgz -> npmpkg-typeface-open-sans-0.0.75.tgz
https://registry.npmjs.org/typescript/-/typescript-3.9.10.tgz -> npmpkg-typescript-3.9.10.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.4.10.tgz -> npmpkg-uglify-js-3.4.10.tgz
https://registry.npmjs.org/commander/-/commander-2.19.0.tgz -> npmpkg-commander-2.19.0.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/uniq/-/uniq-1.0.1.tgz -> npmpkg-uniq-1.0.1.tgz
https://registry.npmjs.org/uniqs/-/uniqs-2.0.0.tgz -> npmpkg-uniqs-2.0.0.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-1.1.1.tgz -> npmpkg-unique-filename-1.1.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-2.0.2.tgz -> npmpkg-unique-slug-2.0.2.tgz
https://registry.npmjs.org/unique-string/-/unique-string-1.0.0.tgz -> npmpkg-unique-string-1.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unquote/-/unquote-1.1.1.tgz -> npmpkg-unquote-1.1.1.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/unzip-crx/-/unzip-crx-0.2.0.tgz -> npmpkg-unzip-crx-0.2.0.tgz
https://registry.npmjs.org/unzip-crx-3/-/unzip-crx-3-0.2.0.tgz -> npmpkg-unzip-crx-3-0.2.0.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-3.0.1.tgz -> npmpkg-update-notifier-3.0.1.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/upng-js/-/upng-js-2.1.0.tgz -> npmpkg-upng-js-2.1.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/upper-case/-/upper-case-1.1.3.tgz -> npmpkg-upper-case-1.1.3.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url/-/url-0.11.3.tgz -> npmpkg-url-0.11.3.tgz
https://registry.npmjs.org/url-loader/-/url-loader-1.1.2.tgz -> npmpkg-url-loader-1.1.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> npmpkg-url-parse-lax-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/qs/-/qs-6.11.2.tgz -> npmpkg-qs-6.11.2.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/utif/-/utif-2.0.1.tgz -> npmpkg-utif-2.0.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/util/-/util-0.11.1.tgz -> npmpkg-util-0.11.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/util.promisify/-/util.promisify-1.0.0.tgz -> npmpkg-util.promisify-1.0.0.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/utila/-/utila-0.4.0.tgz -> npmpkg-utila-0.4.0.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz -> npmpkg-utils-merge-1.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz -> npmpkg-uuid-8.3.2.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/value-equal/-/value-equal-1.0.1.tgz -> npmpkg-value-equal-1.0.1.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/vendors/-/vendors-1.0.4.tgz -> npmpkg-vendors-1.0.4.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/vm-browserify/-/vm-browserify-1.1.2.tgz -> npmpkg-vm-browserify-1.1.2.tgz
https://registry.npmjs.org/vue/-/vue-2.6.11.tgz -> npmpkg-vue-2.6.11.tgz
https://registry.npmjs.org/vue-class-component/-/vue-class-component-7.2.6.tgz -> npmpkg-vue-class-component-7.2.6.tgz
https://registry.npmjs.org/vue-cli-plugin-electron-builder/-/vue-cli-plugin-electron-builder-1.4.6.tgz -> npmpkg-vue-cli-plugin-electron-builder-1.4.6.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-1.5.2.tgz -> npmpkg-deepmerge-1.5.2.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/javascript-stringify/-/javascript-stringify-2.1.0.tgz -> npmpkg-javascript-stringify-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/webpack-chain/-/webpack-chain-5.2.4.tgz -> npmpkg-webpack-chain-5.2.4.tgz
https://registry.npmjs.org/yargs/-/yargs-14.2.3.tgz -> npmpkg-yargs-14.2.3.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-15.0.3.tgz -> npmpkg-yargs-parser-15.0.3.tgz
https://registry.npmjs.org/vue-color/-/vue-color-2.8.1.tgz -> npmpkg-vue-color-2.8.1.tgz
https://registry.npmjs.org/vue-eslint-parser/-/vue-eslint-parser-5.0.0.tgz -> npmpkg-vue-eslint-parser-5.0.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/espree/-/espree-4.1.0.tgz -> npmpkg-espree-4.1.0.tgz
https://registry.npmjs.org/vue-final-modal/-/vue-final-modal-2.4.3.tgz -> npmpkg-vue-final-modal-2.4.3.tgz
https://registry.npmjs.org/vue-golden-layout/-/vue-golden-layout-1.6.0.tgz -> npmpkg-vue-golden-layout-1.6.0.tgz
https://registry.npmjs.org/vue-class-component/-/vue-class-component-6.3.2.tgz -> npmpkg-vue-class-component-6.3.2.tgz
https://registry.npmjs.org/vue-hot-reload-api/-/vue-hot-reload-api-2.3.4.tgz -> npmpkg-vue-hot-reload-api-2.3.4.tgz
https://registry.npmjs.org/vue-jest/-/vue-jest-3.0.7.tgz -> npmpkg-vue-jest-3.0.7.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/vue-loader/-/vue-loader-15.11.1.tgz -> npmpkg-vue-loader-15.11.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/vue-property-decorator/-/vue-property-decorator-8.5.1.tgz -> npmpkg-vue-property-decorator-8.5.1.tgz
https://registry.npmjs.org/vue-resize-directive/-/vue-resize-directive-1.2.0.tgz -> npmpkg-vue-resize-directive-1.2.0.tgz
https://registry.npmjs.org/vue-router/-/vue-router-3.3.4.tgz -> npmpkg-vue-router-3.3.4.tgz
https://registry.npmjs.org/vue-storage-decorator/-/vue-storage-decorator-1.0.7.tgz -> npmpkg-vue-storage-decorator-1.0.7.tgz
https://registry.npmjs.org/vue-style-loader/-/vue-style-loader-4.1.3.tgz -> npmpkg-vue-style-loader-4.1.3.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.6.11.tgz -> npmpkg-vue-template-compiler-2.6.11.tgz
https://registry.npmjs.org/vue-template-es2015-compiler/-/vue-template-es2015-compiler-1.9.1.tgz -> npmpkg-vue-template-es2015-compiler-1.9.1.tgz
https://registry.npmjs.org/vue-toast-notification/-/vue-toast-notification-0.6.2.tgz -> npmpkg-vue-toast-notification-0.6.2.tgz
https://registry.npmjs.org/vuex/-/vuex-3.6.2.tgz -> npmpkg-vuex-3.6.2.tgz
https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> npmpkg-w3c-hr-time-1.0.2.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/warning/-/warning-4.0.3.tgz -> npmpkg-warning-4.0.3.tgz
https://registry.npmjs.org/watch/-/watch-0.18.0.tgz -> npmpkg-watch-0.18.0.tgz
https://registry.npmjs.org/watchpack/-/watchpack-1.7.5.tgz -> npmpkg-watchpack-1.7.5.tgz
https://registry.npmjs.org/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> npmpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/wbuf/-/wbuf-1.7.3.tgz -> npmpkg-wbuf-1.7.3.tgz
https://registry.npmjs.org/wcwidth/-/wcwidth-1.0.1.tgz -> npmpkg-wcwidth-1.0.1.tgz
https://registry.npmjs.org/wdio-dot-reporter/-/wdio-dot-reporter-0.0.10.tgz -> npmpkg-wdio-dot-reporter-0.0.10.tgz
https://registry.npmjs.org/webdriverio/-/webdriverio-4.14.4.tgz -> npmpkg-webdriverio-4.14.4.tgz
https://registry.npmjs.org/chardet/-/chardet-0.4.2.tgz -> npmpkg-chardet-0.4.2.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-2.0.1.tgz -> npmpkg-deepmerge-2.0.1.tgz
https://registry.npmjs.org/ejs/-/ejs-2.5.9.tgz -> npmpkg-ejs-2.5.9.tgz
https://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz -> npmpkg-external-editor-2.2.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/has-flag/-/has-flag-2.0.0.tgz -> npmpkg-has-flag-2.0.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-3.3.0.tgz -> npmpkg-inquirer-3.3.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.0.1.tgz -> npmpkg-supports-color-5.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/webpack/-/webpack-4.47.0.tgz -> npmpkg-webpack-4.47.0.tgz
https://registry.npmjs.org/webpack-bundle-analyzer/-/webpack-bundle-analyzer-3.9.0.tgz -> npmpkg-webpack-bundle-analyzer-3.9.0.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.2.0.tgz -> npmpkg-acorn-walk-7.2.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/webpack-chain/-/webpack-chain-4.12.1.tgz -> npmpkg-webpack-chain-4.12.1.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-1.5.2.tgz -> npmpkg-deepmerge-1.5.2.tgz
https://registry.npmjs.org/webpack-dev-middleware/-/webpack-dev-middleware-3.7.3.tgz -> npmpkg-webpack-dev-middleware-3.7.3.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/webpack-dev-server/-/webpack-dev-server-3.11.3.tgz -> npmpkg-webpack-dev-server-3.11.3.tgz
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
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/webpack-log/-/webpack-log-2.0.0.tgz -> npmpkg-webpack-log-2.0.0.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/webpack-merge/-/webpack-merge-4.2.2.tgz -> npmpkg-webpack-merge-4.2.2.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.4.tgz -> npmpkg-websocket-driver-0.7.4.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> npmpkg-websocket-extensions-0.1.4.tgz
https://registry.npmjs.org/wgxpath/-/wgxpath-1.0.0.tgz -> npmpkg-wgxpath-1.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> npmpkg-whatwg-encoding-1.0.5.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> npmpkg-whatwg-mimetype-2.3.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-6.5.0.tgz -> npmpkg-whatwg-url-6.5.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.1.tgz -> npmpkg-which-module-2.0.1.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.13.tgz -> npmpkg-which-typed-array-1.1.13.tgz
https://registry.npmjs.org/widest-line/-/widest-line-2.0.1.tgz -> npmpkg-widest-line-2.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/worker-farm/-/worker-farm-1.7.0.tgz -> npmpkg-worker-farm-1.7.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> npmpkg-wrap-ansi-5.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write/-/write-1.0.3.tgz -> npmpkg-write-1.0.3.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/ws/-/ws-5.2.3.tgz -> npmpkg-ws-5.2.3.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-3.0.0.tgz -> npmpkg-xdg-basedir-3.0.0.tgz
https://registry.npmjs.org/xhr/-/xhr-2.6.0.tgz -> npmpkg-xhr-2.6.0.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> npmpkg-xml-name-validator-3.0.0.tgz
https://registry.npmjs.org/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> npmpkg-xml-parse-from-string-1.0.1.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.4.23.tgz -> npmpkg-xml2js-0.4.23.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> npmpkg-xmlbuilder-11.0.1.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/yaku/-/yaku-0.16.7.tgz -> npmpkg-yaku-0.16.7.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-10.1.0.tgz -> npmpkg-yargs-parser-10.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/yorkie/-/yorkie-2.0.0.tgz -> npmpkg-yorkie-2.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.8.0.tgz -> npmpkg-execa-0.8.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-1.0.0.tgz -> npmpkg-normalize-path-1.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-1.2.0.tgz -> npmpkg-zip-stream-1.2.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
PHANTOMJS_PV="2.1.1"
SENTRY_CLI_PV="1.75.0"
SHARP_PV=""
VIPS_PV="${ELECTRON_APP_VIPS_PV}"
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
" # the .br is not a mistake.
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
	electron-app_set_sharp_env
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
