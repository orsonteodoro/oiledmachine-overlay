# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="13.6.9"
ELECTRON_APP_VUE_PV="2.6.11"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_SKIP_EXIT_CODE_CHECK="1"
NODE_ENV="development"
NODE_VERSION="16" # 14
YARN_INSTALL_PATH="/opt/${PN}"
PYTHON_COMPAT=( python3_{8..10} )

inherit desktop electron-app lcnr python-r1 yarn

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
IUSE+=" system-vips"
REQUIRED_USE="
	!wayland
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
	sys-apps/yarn
"
TEXTURELABDATA_COMMIT="eed449f3f9abe8f17ae354ab4cb9932272c7811b"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/texturelab-0.3.3/work/texturelab-0.3.3/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.0.3.tgz -> yarnpkg-7zip-bin-5.0.3.tgz
https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.0.tgz -> yarnpkg-@ampproject-remapping-2.2.0.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.21.4.tgz -> yarnpkg-@babel-code-frame-7.21.4.tgz
https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.21.4.tgz -> yarnpkg-@babel-compat-data-7.21.4.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.21.4.tgz -> yarnpkg-@babel-core-7.21.4.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.21.4.tgz -> yarnpkg-@babel-generator-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.18.6.tgz -> yarnpkg-@babel-helper-annotate-as-pure-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.18.9.tgz -> yarnpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.21.4.tgz -> yarnpkg-@babel-helper-compilation-targets-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.21.4.tgz -> yarnpkg-@babel-helper-create-class-features-plugin-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.21.4.tgz -> yarnpkg-@babel-helper-create-regexp-features-plugin-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.3.tgz -> yarnpkg-@babel-helper-define-polyfill-provider-0.3.3.tgz
https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.18.9.tgz -> yarnpkg-@babel-helper-environment-visitor-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-explode-assignable-expression/-/helper-explode-assignable-expression-7.18.6.tgz -> yarnpkg-@babel-helper-explode-assignable-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.21.0.tgz -> yarnpkg-@babel-helper-function-name-7.21.0.tgz
https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.18.6.tgz -> yarnpkg-@babel-helper-hoist-variables-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.21.0.tgz -> yarnpkg-@babel-helper-member-expression-to-functions-7.21.0.tgz
https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.21.4.tgz -> yarnpkg-@babel-helper-module-imports-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.21.2.tgz -> yarnpkg-@babel-helper-module-transforms-7.21.2.tgz
https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.18.6.tgz -> yarnpkg-@babel-helper-optimise-call-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.20.2.tgz -> yarnpkg-@babel-helper-plugin-utils-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.18.9.tgz -> yarnpkg-@babel-helper-remap-async-to-generator-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.20.7.tgz -> yarnpkg-@babel-helper-replace-supers-7.20.7.tgz
https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.20.2.tgz -> yarnpkg-@babel-helper-simple-access-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.20.0.tgz -> yarnpkg-@babel-helper-skip-transparent-expression-wrappers-7.20.0.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.18.6.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-string-parser/-/helper-string-parser-7.19.4.tgz -> yarnpkg-@babel-helper-string-parser-7.19.4.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz -> yarnpkg-@babel-helper-validator-identifier-7.19.1.tgz
https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.21.0.tgz -> yarnpkg-@babel-helper-validator-option-7.21.0.tgz
https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.20.5.tgz -> yarnpkg-@babel-helper-wrap-function-7.20.5.tgz
https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.21.0.tgz -> yarnpkg-@babel-helpers-7.21.0.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz -> yarnpkg-@babel-highlight-7.18.6.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.21.4.tgz -> yarnpkg-@babel-parser-7.21.4.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz -> yarnpkg-@babel-plugin-proposal-async-generator-functions-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-class-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-decorators/-/plugin-proposal-decorators-7.21.0.tgz -> yarnpkg-@babel-plugin-proposal-decorators-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-json-strings-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz -> yarnpkg-@babel-plugin-proposal-object-rest-spread-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-optional-catch-binding-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> yarnpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-decorators/-/plugin-syntax-decorators-7.21.0.tgz -> yarnpkg-@babel-plugin-syntax-decorators-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.21.4.tgz -> yarnpkg-@babel-plugin-syntax-jsx-7.21.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.20.7.tgz -> yarnpkg-@babel-plugin-transform-arrow-functions-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.20.7.tgz -> yarnpkg-@babel-plugin-transform-async-to-generator-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-block-scoped-functions-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.21.0.tgz -> yarnpkg-@babel-plugin-transform-block-scoping-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.21.0.tgz -> yarnpkg-@babel-plugin-transform-classes-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.20.7.tgz -> yarnpkg-@babel-plugin-transform-computed-properties-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.21.3.tgz -> yarnpkg-@babel-plugin-transform-destructuring-7.21.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-dotall-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-duplicate-keys-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-exponentiation-operator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.21.0.tgz -> yarnpkg-@babel-plugin-transform-for-of-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-function-name-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-literals-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.20.11.tgz -> yarnpkg-@babel-plugin-transform-modules-amd-7.20.11.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.21.2.tgz -> yarnpkg-@babel-plugin-transform-modules-commonjs-7.21.2.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.20.11.tgz -> yarnpkg-@babel-plugin-transform-modules-systemjs-7.20.11.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-modules-umd-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.20.5.tgz -> yarnpkg-@babel-plugin-transform-named-capturing-groups-regex-7.20.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-new-target-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-object-super-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.21.3.tgz -> yarnpkg-@babel-plugin-transform-parameters-7.21.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.20.5.tgz -> yarnpkg-@babel-plugin-transform-regenerator-7.20.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.21.4.tgz -> yarnpkg-@babel-plugin-transform-runtime-7.21.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-shorthand-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.20.7.tgz -> yarnpkg-@babel-plugin-transform-spread-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-sticky-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-template-literals-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-typeof-symbol-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-unicode-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.3.4.tgz -> yarnpkg-@babel-preset-env-7.3.4.tgz
https://registry.yarnpkg.com/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> yarnpkg-@babel-regjsgen-0.8.0.tgz
https://registry.yarnpkg.com/@babel/runtime-corejs2/-/runtime-corejs2-7.21.0.tgz -> yarnpkg-@babel-runtime-corejs2-7.21.0.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.21.0.tgz -> yarnpkg-@babel-runtime-7.21.0.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.20.7.tgz -> yarnpkg-@babel-template-7.20.7.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.21.4.tgz -> yarnpkg-@babel-traverse-7.21.4.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.21.4.tgz -> yarnpkg-@babel-types-7.21.4.tgz
https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.1.0.tgz -> yarnpkg-@develar-schema-utils-2.1.0.tgz
https://registry.yarnpkg.com/@electron/get/-/get-1.14.1.tgz -> yarnpkg-@electron-get-1.14.1.tgz
https://registry.yarnpkg.com/@electron/remote/-/remote-1.2.2.tgz -> yarnpkg-@electron-remote-1.2.2.tgz
https://registry.yarnpkg.com/@hapi/address/-/address-2.1.4.tgz -> yarnpkg-@hapi-address-2.1.4.tgz
https://registry.yarnpkg.com/@hapi/bourne/-/bourne-1.3.2.tgz -> yarnpkg-@hapi-bourne-1.3.2.tgz
https://registry.yarnpkg.com/@hapi/hoek/-/hoek-8.5.1.tgz -> yarnpkg-@hapi-hoek-8.5.1.tgz
https://registry.yarnpkg.com/@hapi/joi/-/joi-15.1.1.tgz -> yarnpkg-@hapi-joi-15.1.1.tgz
https://registry.yarnpkg.com/@hapi/topo/-/topo-3.1.6.tgz -> yarnpkg-@hapi-topo-3.1.6.tgz
https://registry.yarnpkg.com/@intervolga/optimize-cssnano-plugin/-/optimize-cssnano-plugin-1.0.6.tgz -> yarnpkg-@intervolga-optimize-cssnano-plugin-1.0.6.tgz
https://registry.yarnpkg.com/@jimp/bmp/-/bmp-0.16.13.tgz -> yarnpkg-@jimp-bmp-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/core/-/core-0.16.13.tgz -> yarnpkg-@jimp-core-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/custom/-/custom-0.16.13.tgz -> yarnpkg-@jimp-custom-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/gif/-/gif-0.16.13.tgz -> yarnpkg-@jimp-gif-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/jpeg/-/jpeg-0.16.13.tgz -> yarnpkg-@jimp-jpeg-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-blit/-/plugin-blit-0.16.13.tgz -> yarnpkg-@jimp-plugin-blit-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-blur/-/plugin-blur-0.16.13.tgz -> yarnpkg-@jimp-plugin-blur-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-circle/-/plugin-circle-0.16.13.tgz -> yarnpkg-@jimp-plugin-circle-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-color/-/plugin-color-0.16.13.tgz -> yarnpkg-@jimp-plugin-color-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-contain/-/plugin-contain-0.16.13.tgz -> yarnpkg-@jimp-plugin-contain-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-cover/-/plugin-cover-0.16.13.tgz -> yarnpkg-@jimp-plugin-cover-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-crop/-/plugin-crop-0.16.13.tgz -> yarnpkg-@jimp-plugin-crop-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-displace/-/plugin-displace-0.16.13.tgz -> yarnpkg-@jimp-plugin-displace-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-dither/-/plugin-dither-0.16.13.tgz -> yarnpkg-@jimp-plugin-dither-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-fisheye/-/plugin-fisheye-0.16.13.tgz -> yarnpkg-@jimp-plugin-fisheye-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-flip/-/plugin-flip-0.16.13.tgz -> yarnpkg-@jimp-plugin-flip-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-gaussian/-/plugin-gaussian-0.16.13.tgz -> yarnpkg-@jimp-plugin-gaussian-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-invert/-/plugin-invert-0.16.13.tgz -> yarnpkg-@jimp-plugin-invert-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-mask/-/plugin-mask-0.16.13.tgz -> yarnpkg-@jimp-plugin-mask-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-normalize/-/plugin-normalize-0.16.13.tgz -> yarnpkg-@jimp-plugin-normalize-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-print/-/plugin-print-0.16.13.tgz -> yarnpkg-@jimp-plugin-print-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-resize/-/plugin-resize-0.16.13.tgz -> yarnpkg-@jimp-plugin-resize-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-rotate/-/plugin-rotate-0.16.13.tgz -> yarnpkg-@jimp-plugin-rotate-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-scale/-/plugin-scale-0.16.13.tgz -> yarnpkg-@jimp-plugin-scale-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-shadow/-/plugin-shadow-0.16.13.tgz -> yarnpkg-@jimp-plugin-shadow-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugin-threshold/-/plugin-threshold-0.16.13.tgz -> yarnpkg-@jimp-plugin-threshold-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/plugins/-/plugins-0.16.13.tgz -> yarnpkg-@jimp-plugins-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/png/-/png-0.16.13.tgz -> yarnpkg-@jimp-png-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/tiff/-/tiff-0.16.13.tgz -> yarnpkg-@jimp-tiff-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/types/-/types-0.16.13.tgz -> yarnpkg-@jimp-types-0.16.13.tgz
https://registry.yarnpkg.com/@jimp/utils/-/utils-0.16.13.tgz -> yarnpkg-@jimp-utils-0.16.13.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.1.1.tgz -> yarnpkg-@jridgewell-gen-mapping-0.1.1.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.2.tgz -> yarnpkg-@jridgewell-gen-mapping-0.3.2.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz -> yarnpkg-@jridgewell-resolve-uri-3.1.0.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz -> yarnpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.17.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.17.tgz
https://registry.yarnpkg.com/@mrmlnc/readdir-enhanced/-/readdir-enhanced-2.2.1.tgz -> yarnpkg-@mrmlnc-readdir-enhanced-2.2.1.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-1.1.3.tgz -> yarnpkg-@nodelib-fs.stat-1.1.3.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@petamoriken/float16/-/float16-3.8.0.tgz -> yarnpkg-@petamoriken-float16-3.8.0.tgz
https://registry.yarnpkg.com/@sentry/browser/-/browser-6.19.2.tgz -> yarnpkg-@sentry-browser-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/cli/-/cli-1.75.0.tgz -> yarnpkg-@sentry-cli-1.75.0.tgz
https://registry.yarnpkg.com/@sentry/core/-/core-6.19.2.tgz -> yarnpkg-@sentry-core-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/electron/-/electron-3.0.8.tgz -> yarnpkg-@sentry-electron-3.0.8.tgz
https://registry.yarnpkg.com/@sentry/hub/-/hub-6.19.2.tgz -> yarnpkg-@sentry-hub-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/minimal/-/minimal-6.19.2.tgz -> yarnpkg-@sentry-minimal-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/node/-/node-6.19.2.tgz -> yarnpkg-@sentry-node-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/types/-/types-6.19.2.tgz -> yarnpkg-@sentry-types-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/utils/-/utils-6.19.2.tgz -> yarnpkg-@sentry-utils-6.19.2.tgz
https://registry.yarnpkg.com/@sentry/webpack-plugin/-/webpack-plugin-1.20.0.tgz -> yarnpkg-@sentry-webpack-plugin-1.20.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.14.0.tgz -> yarnpkg-@sindresorhus-is-0.14.0.tgz
https://registry.yarnpkg.com/@soda/friendly-errors-webpack-plugin/-/friendly-errors-webpack-plugin-1.8.1.tgz -> yarnpkg-@soda-friendly-errors-webpack-plugin-1.8.1.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> yarnpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.yarnpkg.com/@tokenizer/token/-/token-0.3.0.tgz -> yarnpkg-@tokenizer-token-0.3.0.tgz
https://registry.yarnpkg.com/@types/adm-zip/-/adm-zip-0.4.34.tgz -> yarnpkg-@types-adm-zip-0.4.34.tgz
https://registry.yarnpkg.com/@types/debug/-/debug-4.1.7.tgz -> yarnpkg-@types-debug-4.1.7.tgz
https://registry.yarnpkg.com/@types/eslint-visitor-keys/-/eslint-visitor-keys-1.0.0.tgz -> yarnpkg-@types-eslint-visitor-keys-1.0.0.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz -> yarnpkg-@types-glob-7.2.0.tgz
https://registry.yarnpkg.com/@types/jest/-/jest-23.3.14.tgz -> yarnpkg-@types-jest-23.3.14.tgz
https://registry.yarnpkg.com/@types/jquery/-/jquery-3.5.16.tgz -> yarnpkg-@types-jquery-3.5.16.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz -> yarnpkg-@types-ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.15.11.tgz -> yarnpkg-@types-node-18.15.11.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.9.1.tgz -> yarnpkg-@types-node-16.9.1.tgz
https://registry.yarnpkg.com/@types/node/-/node-14.18.42.tgz -> yarnpkg-@types-node-14.18.42.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.18.23.tgz -> yarnpkg-@types-node-16.18.23.tgz
https://registry.yarnpkg.com/@types/normalize-package-data/-/normalize-package-data-2.4.1.tgz -> yarnpkg-@types-normalize-package-data-2.4.1.tgz
https://registry.yarnpkg.com/@types/pako/-/pako-1.0.4.tgz -> yarnpkg-@types-pako-1.0.4.tgz
https://registry.yarnpkg.com/@types/pngjs/-/pngjs-6.0.1.tgz -> yarnpkg-@types-pngjs-6.0.1.tgz
https://registry.yarnpkg.com/@types/q/-/q-1.5.5.tgz -> yarnpkg-@types-q-1.5.5.tgz
https://registry.yarnpkg.com/@types/sharp/-/sharp-0.29.5.tgz -> yarnpkg-@types-sharp-0.29.5.tgz
https://registry.yarnpkg.com/@types/sizzle/-/sizzle-2.3.3.tgz -> yarnpkg-@types-sizzle-2.3.3.tgz
https://registry.yarnpkg.com/@types/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-@types-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/@types/strip-json-comments/-/strip-json-comments-0.0.30.tgz -> yarnpkg-@types-strip-json-comments-0.0.30.tgz
https://registry.yarnpkg.com/@types/three/-/three-0.103.2.tgz -> yarnpkg-@types-three-0.103.2.tgz
https://registry.yarnpkg.com/@types/webpack-env/-/webpack-env-1.18.0.tgz -> yarnpkg-@types-webpack-env-1.18.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-1.13.0.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-1.13.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-2.34.0.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-2.34.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/experimental-utils/-/experimental-utils-1.13.0.tgz -> yarnpkg-@typescript-eslint-experimental-utils-1.13.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/experimental-utils/-/experimental-utils-2.34.0.tgz -> yarnpkg-@typescript-eslint-experimental-utils-2.34.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-1.13.0.tgz -> yarnpkg-@typescript-eslint-parser-1.13.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-2.34.0.tgz -> yarnpkg-@typescript-eslint-parser-2.34.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-1.13.0.tgz -> yarnpkg-@typescript-eslint-typescript-estree-1.13.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-2.34.0.tgz -> yarnpkg-@typescript-eslint-typescript-estree-2.34.0.tgz
https://registry.yarnpkg.com/@vue/babel-helper-vue-jsx-merge-props/-/babel-helper-vue-jsx-merge-props-1.4.0.tgz -> yarnpkg-@vue-babel-helper-vue-jsx-merge-props-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-plugin-transform-vue-jsx/-/babel-plugin-transform-vue-jsx-1.4.0.tgz -> yarnpkg-@vue-babel-plugin-transform-vue-jsx-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-preset-app/-/babel-preset-app-3.12.1.tgz -> yarnpkg-@vue-babel-preset-app-3.12.1.tgz
https://registry.yarnpkg.com/@vue/babel-preset-jsx/-/babel-preset-jsx-1.4.0.tgz -> yarnpkg-@vue-babel-preset-jsx-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-composition-api-inject-h/-/babel-sugar-composition-api-inject-h-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-composition-api-inject-h-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-composition-api-render-instance/-/babel-sugar-composition-api-render-instance-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-composition-api-render-instance-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-functional-vue/-/babel-sugar-functional-vue-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-functional-vue-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-inject-h/-/babel-sugar-inject-h-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-inject-h-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-v-model/-/babel-sugar-v-model-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-v-model-1.4.0.tgz
https://registry.yarnpkg.com/@vue/babel-sugar-v-on/-/babel-sugar-v-on-1.4.0.tgz -> yarnpkg-@vue-babel-sugar-v-on-1.4.0.tgz
https://registry.yarnpkg.com/@vue/cli-overlay/-/cli-overlay-3.12.1.tgz -> yarnpkg-@vue-cli-overlay-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-plugin-babel/-/cli-plugin-babel-3.12.1.tgz -> yarnpkg-@vue-cli-plugin-babel-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-plugin-eslint/-/cli-plugin-eslint-3.12.1.tgz -> yarnpkg-@vue-cli-plugin-eslint-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-plugin-typescript/-/cli-plugin-typescript-3.12.1.tgz -> yarnpkg-@vue-cli-plugin-typescript-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-plugin-unit-jest/-/cli-plugin-unit-jest-3.12.1.tgz -> yarnpkg-@vue-cli-plugin-unit-jest-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-service/-/cli-service-3.12.1.tgz -> yarnpkg-@vue-cli-service-3.12.1.tgz
https://registry.yarnpkg.com/@vue/cli-shared-utils/-/cli-shared-utils-3.12.1.tgz -> yarnpkg-@vue-cli-shared-utils-3.12.1.tgz
https://registry.yarnpkg.com/@vue/component-compiler-utils/-/component-compiler-utils-3.3.0.tgz -> yarnpkg-@vue-component-compiler-utils-3.3.0.tgz
https://registry.yarnpkg.com/@vue/eslint-config-prettier/-/eslint-config-prettier-4.0.1.tgz -> yarnpkg-@vue-eslint-config-prettier-4.0.1.tgz
https://registry.yarnpkg.com/@vue/eslint-config-typescript/-/eslint-config-typescript-4.0.0.tgz -> yarnpkg-@vue-eslint-config-typescript-4.0.0.tgz
https://registry.yarnpkg.com/@vue/preload-webpack-plugin/-/preload-webpack-plugin-1.1.2.tgz -> yarnpkg-@vue-preload-webpack-plugin-1.1.2.tgz
https://registry.yarnpkg.com/@vue/test-utils/-/test-utils-1.0.0-beta.29.tgz -> yarnpkg-@vue-test-utils-1.0.0-beta.29.tgz
https://registry.yarnpkg.com/@vue/web-component-wrapper/-/web-component-wrapper-1.3.0.tgz -> yarnpkg-@vue-web-component-wrapper-1.3.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.9.0.tgz -> yarnpkg-@webassemblyjs-ast-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-floating-point-hex-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-api-error-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-buffer-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-code-frame-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-fsm-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-module-context-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-wasm-section-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> yarnpkg-@webassemblyjs-ieee754-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> yarnpkg-@webassemblyjs-leb128-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> yarnpkg-@webassemblyjs-utf8-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-edit-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-gen-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-opt-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-wast-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> yarnpkg-@webassemblyjs-wast-printer-1.9.0.tgz
https://registry.yarnpkg.com/@webcomponents/webcomponentsjs/-/webcomponentsjs-2.8.0.tgz -> yarnpkg-@webcomponents-webcomponentsjs-2.8.0.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> yarnpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> yarnpkg-@xtuc-long-4.2.2.tgz
https://registry.yarnpkg.com/abab/-/abab-2.0.6.tgz -> yarnpkg-abab-2.0.6.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/accepts/-/accepts-1.3.8.tgz -> yarnpkg-accepts-1.3.8.tgz
https://registry.yarnpkg.com/acorn-globals/-/acorn-globals-4.3.4.tgz -> yarnpkg-acorn-globals-4.3.4.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-3.0.1.tgz -> yarnpkg-acorn-jsx-3.0.1.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> yarnpkg-acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-6.2.0.tgz -> yarnpkg-acorn-walk-6.2.0.tgz
https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.2.0.tgz -> yarnpkg-acorn-walk-7.2.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-3.3.0.tgz -> yarnpkg-acorn-3.3.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-5.7.4.tgz -> yarnpkg-acorn-5.7.4.tgz
https://registry.yarnpkg.com/acorn/-/acorn-6.4.2.tgz -> yarnpkg-acorn-6.4.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz -> yarnpkg-acorn-7.4.1.tgz
https://registry.yarnpkg.com/address/-/address-1.2.2.tgz -> yarnpkg-address-1.2.2.tgz
https://registry.yarnpkg.com/adm-zip/-/adm-zip-0.4.16.tgz -> yarnpkg-adm-zip-0.4.16.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv-errors/-/ajv-errors-1.0.1.tgz -> yarnpkg-ajv-errors-1.0.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-2.1.1.tgz -> yarnpkg-ajv-keywords-2.1.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-5.5.2.tgz -> yarnpkg-ajv-5.5.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/alphanum-sort/-/alphanum-sort-1.0.2.tgz -> yarnpkg-alphanum-sort-1.0.2.tgz
https://registry.yarnpkg.com/ansi-align/-/ansi-align-3.0.1.tgz -> yarnpkg-ansi-align-3.0.1.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-3.2.4.tgz -> yarnpkg-ansi-colors-3.2.4.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> yarnpkg-ansi-escapes-3.2.0.tgz
https://registry.yarnpkg.com/ansi-html-community/-/ansi-html-community-0.0.8.tgz -> yarnpkg-ansi-html-community-0.0.8.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.1.tgz -> yarnpkg-ansi-regex-3.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.1.tgz -> yarnpkg-ansi-regex-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz -> yarnpkg-ansi-styles-2.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/any-base/-/any-base-1.1.0.tgz -> yarnpkg-any-base-1.1.0.tgz
https://registry.yarnpkg.com/any-promise/-/any-promise-1.3.0.tgz -> yarnpkg-any-promise-1.3.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz -> yarnpkg-anymatch-2.0.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.3.tgz -> yarnpkg-anymatch-3.1.3.tgz
https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-3.4.3.tgz -> yarnpkg-app-builder-bin-3.4.3.tgz
https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-21.2.0.tgz -> yarnpkg-app-builder-lib-21.2.0.tgz
https://registry.yarnpkg.com/append-transform/-/append-transform-0.4.0.tgz -> yarnpkg-append-transform-0.4.0.tgz
https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz -> yarnpkg-aproba-1.2.0.tgz
https://registry.yarnpkg.com/arch/-/arch-2.2.0.tgz -> yarnpkg-arch-2.2.0.tgz
https://registry.yarnpkg.com/archiver-utils/-/archiver-utils-1.3.0.tgz -> yarnpkg-archiver-utils-1.3.0.tgz
https://registry.yarnpkg.com/archiver/-/archiver-2.1.1.tgz -> yarnpkg-archiver-2.1.1.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/args/-/args-5.0.3.tgz -> yarnpkg-args-5.0.3.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-2.0.0.tgz -> yarnpkg-arr-diff-2.0.0.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz -> yarnpkg-arr-diff-4.0.0.tgz
https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz -> yarnpkg-arr-flatten-1.1.0.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-equal/-/array-equal-1.0.0.tgz -> yarnpkg-array-equal-1.0.0.tgz
https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz -> yarnpkg-array-flatten-1.1.1.tgz
https://registry.yarnpkg.com/array-flatten/-/array-flatten-2.1.2.tgz -> yarnpkg-array-flatten-2.1.2.tgz
https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz -> yarnpkg-array-union-1.0.2.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz -> yarnpkg-array-uniq-1.0.3.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.2.1.tgz -> yarnpkg-array-unique-0.2.1.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz -> yarnpkg-array-unique-0.3.2.tgz
https://registry.yarnpkg.com/array.prototype.reduce/-/array.prototype.reduce-1.0.5.tgz -> yarnpkg-array.prototype.reduce-1.0.5.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz -> yarnpkg-arrify-1.0.1.tgz
https://registry.yarnpkg.com/asn1.js/-/asn1.js-5.4.1.tgz -> yarnpkg-asn1.js-5.4.1.tgz
https://registry.yarnpkg.com/asn1/-/asn1-0.2.6.tgz -> yarnpkg-asn1-0.2.6.tgz
https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz -> yarnpkg-assert-plus-1.0.0.tgz
https://registry.yarnpkg.com/assert/-/assert-1.5.0.tgz -> yarnpkg-assert-1.5.0.tgz
https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz -> yarnpkg-assign-symbols-1.0.0.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-1.0.0.tgz -> yarnpkg-astral-regex-1.0.0.tgz
https://registry.yarnpkg.com/async-each/-/async-each-1.0.6.tgz -> yarnpkg-async-each-1.0.6.tgz
https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> yarnpkg-async-exit-hook-2.0.1.tgz
https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.1.tgz -> yarnpkg-async-limiter-1.0.1.tgz
https://registry.yarnpkg.com/async/-/async-2.6.4.tgz -> yarnpkg-async-2.6.4.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz -> yarnpkg-atob-2.1.2.tgz
https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-9.8.8.tgz -> yarnpkg-autoprefixer-9.8.8.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz -> yarnpkg-aws-sign2-0.7.0.tgz
https://registry.yarnpkg.com/aws4/-/aws4-1.12.0.tgz -> yarnpkg-aws4-1.12.0.tgz
https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> yarnpkg-babel-code-frame-6.26.0.tgz
https://registry.yarnpkg.com/babel-core/-/babel-core-7.0.0-bridge.0.tgz -> yarnpkg-babel-core-7.0.0-bridge.0.tgz
https://registry.yarnpkg.com/babel-core/-/babel-core-6.26.3.tgz -> yarnpkg-babel-core-6.26.3.tgz
https://registry.yarnpkg.com/babel-eslint/-/babel-eslint-10.1.0.tgz -> yarnpkg-babel-eslint-10.1.0.tgz
https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.26.1.tgz -> yarnpkg-babel-generator-6.26.1.tgz
https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.24.1.tgz -> yarnpkg-babel-helpers-6.24.1.tgz
https://registry.yarnpkg.com/babel-jest/-/babel-jest-23.6.0.tgz -> yarnpkg-babel-jest-23.6.0.tgz
https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.3.0.tgz -> yarnpkg-babel-loader-8.3.0.tgz
https://registry.yarnpkg.com/babel-messages/-/babel-messages-6.23.0.tgz -> yarnpkg-babel-messages-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-dynamic-import-node/-/babel-plugin-dynamic-import-node-2.3.3.tgz -> yarnpkg-babel-plugin-dynamic-import-node-2.3.3.tgz
https://registry.yarnpkg.com/babel-plugin-istanbul/-/babel-plugin-istanbul-4.1.6.tgz -> yarnpkg-babel-plugin-istanbul-4.1.6.tgz
https://registry.yarnpkg.com/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-23.2.0.tgz -> yarnpkg-babel-plugin-jest-hoist-23.2.0.tgz
https://registry.yarnpkg.com/babel-plugin-module-resolver/-/babel-plugin-module-resolver-3.2.0.tgz -> yarnpkg-babel-plugin-module-resolver-3.2.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.3.tgz -> yarnpkg-babel-plugin-polyfill-corejs2-0.3.3.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.6.0.tgz -> yarnpkg-babel-plugin-polyfill-corejs3-0.6.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.4.1.tgz -> yarnpkg-babel-plugin-polyfill-regenerator-0.4.1.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz -> yarnpkg-babel-plugin-syntax-object-rest-spread-6.13.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.yarnpkg.com/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> yarnpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.yarnpkg.com/babel-preset-jest/-/babel-preset-jest-23.2.0.tgz -> yarnpkg-babel-preset-jest-23.2.0.tgz
https://registry.yarnpkg.com/babel-register/-/babel-register-6.26.0.tgz -> yarnpkg-babel-register-6.26.0.tgz
https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz -> yarnpkg-babel-runtime-6.26.0.tgz
https://registry.yarnpkg.com/babel-template/-/babel-template-6.26.0.tgz -> yarnpkg-babel-template-6.26.0.tgz
https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.26.0.tgz -> yarnpkg-babel-traverse-6.26.0.tgz
https://registry.yarnpkg.com/babel-types/-/babel-types-6.26.0.tgz -> yarnpkg-babel-types-6.26.0.tgz
https://registry.yarnpkg.com/babylon/-/babylon-6.18.0.tgz -> yarnpkg-babylon-6.18.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/base/-/base-0.11.2.tgz -> yarnpkg-base-0.11.2.tgz
https://registry.yarnpkg.com/batch-processor/-/batch-processor-1.0.0.tgz -> yarnpkg-batch-processor-1.0.0.tgz
https://registry.yarnpkg.com/batch/-/batch-0.6.1.tgz -> yarnpkg-batch-0.6.1.tgz
https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> yarnpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.yarnpkg.com/bfj/-/bfj-6.1.2.tgz -> yarnpkg-bfj-6.1.2.tgz
https://registry.yarnpkg.com/big.js/-/big.js-3.2.0.tgz -> yarnpkg-big.js-3.2.0.tgz
https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz -> yarnpkg-big.js-5.2.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz -> yarnpkg-binary-extensions-1.13.1.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz -> yarnpkg-bindings-1.5.0.tgz
https://registry.yarnpkg.com/bl/-/bl-1.2.3.tgz -> yarnpkg-bl-1.2.3.tgz
https://registry.yarnpkg.com/bl/-/bl-4.1.0.tgz -> yarnpkg-bl-4.1.0.tgz
https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> yarnpkg-bluebird-lst-1.0.9.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/bmp-js/-/bmp-js-0.1.0.tgz -> yarnpkg-bmp-js-0.1.0.tgz
https://registry.yarnpkg.com/bn.js/-/bn.js-4.12.0.tgz -> yarnpkg-bn.js-4.12.0.tgz
https://registry.yarnpkg.com/bn.js/-/bn.js-5.2.1.tgz -> yarnpkg-bn.js-5.2.1.tgz
https://registry.yarnpkg.com/body-parser/-/body-parser-1.20.1.tgz -> yarnpkg-body-parser-1.20.1.tgz
https://registry.yarnpkg.com/bonjour/-/bonjour-3.5.0.tgz -> yarnpkg-bonjour-3.5.0.tgz
https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz -> yarnpkg-boolbase-1.0.0.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz -> yarnpkg-boolean-3.2.0.tgz
https://registry.yarnpkg.com/boxen/-/boxen-3.2.0.tgz -> yarnpkg-boxen-3.2.0.tgz
https://registry.yarnpkg.com/boxicons/-/boxicons-2.1.4.tgz -> yarnpkg-boxicons-2.1.4.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-1.8.5.tgz -> yarnpkg-braces-1.8.5.tgz
https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz -> yarnpkg-braces-2.3.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/brorand/-/brorand-1.1.0.tgz -> yarnpkg-brorand-1.1.0.tgz
https://registry.yarnpkg.com/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> yarnpkg-browser-process-hrtime-1.0.0.tgz
https://registry.yarnpkg.com/browser-resolve/-/browser-resolve-1.11.3.tgz -> yarnpkg-browser-resolve-1.11.3.tgz
https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.2.0.tgz -> yarnpkg-browserify-aes-1.2.0.tgz
https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> yarnpkg-browserify-cipher-1.0.1.tgz
https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.2.tgz -> yarnpkg-browserify-des-1.0.2.tgz
https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.1.0.tgz -> yarnpkg-browserify-rsa-4.1.0.tgz
https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.2.1.tgz -> yarnpkg-browserify-sign-4.2.1.tgz
https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> yarnpkg-browserify-zlib-0.2.0.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.21.5.tgz -> yarnpkg-browserslist-4.21.5.tgz
https://registry.yarnpkg.com/bs-logger/-/bs-logger-0.2.6.tgz -> yarnpkg-bs-logger-0.2.6.tgz
https://registry.yarnpkg.com/bser/-/bser-2.1.1.tgz -> yarnpkg-bser-2.1.1.tgz
https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> yarnpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> yarnpkg-buffer-alloc-1.2.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz -> yarnpkg-buffer-equal-0.0.1.tgz
https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz -> yarnpkg-buffer-fill-1.0.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/buffer-indexof/-/buffer-indexof-1.1.1.tgz -> yarnpkg-buffer-indexof-1.1.1.tgz
https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz -> yarnpkg-buffer-xor-1.0.3.tgz
https://registry.yarnpkg.com/buffer/-/buffer-4.9.2.tgz -> yarnpkg-buffer-4.9.2.tgz
https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz -> yarnpkg-buffer-5.7.1.tgz
https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.3.0.tgz -> yarnpkg-builder-util-runtime-8.3.0.tgz
https://registry.yarnpkg.com/builder-util/-/builder-util-21.2.0.tgz -> yarnpkg-builder-util-21.2.0.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz -> yarnpkg-builtin-modules-1.1.1.tgz
https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> yarnpkg-builtin-status-codes-3.0.0.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.0.0.tgz -> yarnpkg-bytes-3.0.0.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.2.tgz -> yarnpkg-bytes-3.1.2.tgz
https://registry.yarnpkg.com/cacache/-/cacache-10.0.4.tgz -> yarnpkg-cacache-10.0.4.tgz
https://registry.yarnpkg.com/cacache/-/cacache-12.0.4.tgz -> yarnpkg-cacache-12.0.4.tgz
https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz -> yarnpkg-cache-base-1.0.1.tgz
https://registry.yarnpkg.com/cache-loader/-/cache-loader-2.0.1.tgz -> yarnpkg-cache-loader-2.0.1.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-6.1.0.tgz -> yarnpkg-cacheable-request-6.1.0.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/call-me-maybe/-/call-me-maybe-1.0.2.tgz -> yarnpkg-call-me-maybe-1.0.2.tgz
https://registry.yarnpkg.com/caller-callsite/-/caller-callsite-2.0.0.tgz -> yarnpkg-caller-callsite-2.0.0.tgz
https://registry.yarnpkg.com/caller-path/-/caller-path-0.1.0.tgz -> yarnpkg-caller-path-0.1.0.tgz
https://registry.yarnpkg.com/caller-path/-/caller-path-2.0.0.tgz -> yarnpkg-caller-path-2.0.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-0.2.0.tgz -> yarnpkg-callsites-0.2.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-2.0.0.tgz -> yarnpkg-callsites-2.0.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camel-case/-/camel-case-3.0.0.tgz -> yarnpkg-camel-case-3.0.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.0.0.tgz -> yarnpkg-camelcase-5.0.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-3.0.0.tgz -> yarnpkg-camelcase-3.0.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-4.1.0.tgz -> yarnpkg-camelcase-4.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/caniuse-api/-/caniuse-api-3.0.0.tgz -> yarnpkg-caniuse-api-3.0.0.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001474.tgz -> yarnpkg-caniuse-lite-1.0.30001474.tgz
https://registry.yarnpkg.com/capture-exit/-/capture-exit-1.2.0.tgz -> yarnpkg-capture-exit-1.2.0.tgz
https://registry.yarnpkg.com/case-sensitive-paths-webpack-plugin/-/case-sensitive-paths-webpack-plugin-2.4.0.tgz -> yarnpkg-case-sensitive-paths-webpack-plugin-2.4.0.tgz
https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz -> yarnpkg-caseless-0.12.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz -> yarnpkg-chalk-1.1.3.tgz
https://registry.yarnpkg.com/chalk/-/chalk-3.0.0.tgz -> yarnpkg-chalk-3.0.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.4.2.tgz -> yarnpkg-chardet-0.4.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/check-types/-/check-types-8.0.3.tgz -> yarnpkg-check-types-8.0.3.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-2.1.8.tgz -> yarnpkg-chokidar-2.1.8.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/chownr/-/chownr-1.1.4.tgz -> yarnpkg-chownr-1.1.4.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> yarnpkg-chrome-trace-event-1.0.3.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> yarnpkg-chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-1.6.0.tgz -> yarnpkg-ci-info-1.6.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.4.tgz -> yarnpkg-cipher-base-1.0.4.tgz
https://registry.yarnpkg.com/circular-json/-/circular-json-0.3.3.tgz -> yarnpkg-circular-json-0.3.3.tgz
https://registry.yarnpkg.com/clamp/-/clamp-1.0.1.tgz -> yarnpkg-clamp-1.0.1.tgz
https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz -> yarnpkg-class-utils-0.3.6.tgz
https://registry.yarnpkg.com/clean-css/-/clean-css-4.2.4.tgz -> yarnpkg-clean-css-4.2.4.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-2.2.1.tgz -> yarnpkg-cli-boxes-2.2.1.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-2.1.0.tgz -> yarnpkg-cli-cursor-2.1.0.tgz
https://registry.yarnpkg.com/cli-highlight/-/cli-highlight-2.1.11.tgz -> yarnpkg-cli-highlight-2.1.11.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.8.0.tgz -> yarnpkg-cli-spinners-2.8.0.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-2.2.1.tgz -> yarnpkg-cli-width-2.2.1.tgz
https://registry.yarnpkg.com/clipboardy/-/clipboardy-2.3.0.tgz -> yarnpkg-clipboardy-2.3.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-3.2.0.tgz -> yarnpkg-cliui-3.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-4.1.0.tgz -> yarnpkg-cliui-4.1.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-5.0.0.tgz -> yarnpkg-cliui-5.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz -> yarnpkg-clone-response-1.0.3.tgz
https://registry.yarnpkg.com/clone/-/clone-2.1.2.tgz -> yarnpkg-clone-2.1.2.tgz
https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz -> yarnpkg-clone-1.0.4.tgz
https://registry.yarnpkg.com/co/-/co-4.6.0.tgz -> yarnpkg-co-4.6.0.tgz
https://registry.yarnpkg.com/coa/-/coa-2.0.2.tgz -> yarnpkg-coa-2.0.2.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz -> yarnpkg-collection-visit-1.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-string/-/color-string-1.9.1.tgz -> yarnpkg-color-string-1.9.1.tgz
https://registry.yarnpkg.com/color/-/color-3.2.1.tgz -> yarnpkg-color-3.2.1.tgz
https://registry.yarnpkg.com/color/-/color-4.2.3.tgz -> yarnpkg-color-4.2.3.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.17.1.tgz -> yarnpkg-commander-2.17.1.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-6.2.1.tgz -> yarnpkg-commander-6.2.1.tgz
https://registry.yarnpkg.com/commander/-/commander-2.19.0.tgz -> yarnpkg-commander-2.19.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/compress-commons/-/compress-commons-1.2.2.tgz -> yarnpkg-compress-commons-1.2.2.tgz
https://registry.yarnpkg.com/compressible/-/compressible-2.0.18.tgz -> yarnpkg-compressible-2.0.18.tgz
https://registry.yarnpkg.com/compression/-/compression-1.7.4.tgz -> yarnpkg-compression-1.7.4.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/condense-newlines/-/condense-newlines-0.2.1.tgz -> yarnpkg-condense-newlines-0.2.1.tgz
https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.13.tgz -> yarnpkg-config-chain-1.1.13.tgz
https://registry.yarnpkg.com/configstore/-/configstore-4.0.0.tgz -> yarnpkg-configstore-4.0.0.tgz
https://registry.yarnpkg.com/connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz -> yarnpkg-connect-history-api-fallback-1.6.0.tgz
https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.2.0.tgz -> yarnpkg-console-browserify-1.2.0.tgz
https://registry.yarnpkg.com/consolidate/-/consolidate-0.15.1.tgz -> yarnpkg-consolidate-0.15.1.tgz
https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz -> yarnpkg-constants-browserify-1.0.0.tgz
https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.4.tgz -> yarnpkg-content-disposition-0.5.4.tgz
https://registry.yarnpkg.com/content-type/-/content-type-1.0.5.tgz -> yarnpkg-content-type-1.0.5.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz -> yarnpkg-cookie-signature-1.0.6.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.5.0.tgz -> yarnpkg-cookie-0.5.0.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.4.2.tgz -> yarnpkg-cookie-0.4.2.tgz
https://registry.yarnpkg.com/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> yarnpkg-copy-concurrently-1.0.5.tgz
https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> yarnpkg-copy-descriptor-0.1.1.tgz
https://registry.yarnpkg.com/copy-webpack-plugin/-/copy-webpack-plugin-4.6.0.tgz -> yarnpkg-copy-webpack-plugin-4.6.0.tgz
https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.30.0.tgz -> yarnpkg-core-js-compat-3.30.0.tgz
https://registry.yarnpkg.com/core-js/-/core-js-2.6.12.tgz -> yarnpkg-core-js-2.6.12.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> yarnpkg-cosmiconfig-5.2.1.tgz
https://registry.yarnpkg.com/crc32-stream/-/crc32-stream-2.0.0.tgz -> yarnpkg-crc32-stream-2.0.0.tgz
https://registry.yarnpkg.com/crc/-/crc-3.8.0.tgz -> yarnpkg-crc-3.8.0.tgz
https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.4.tgz -> yarnpkg-create-ecdh-4.0.4.tgz
https://registry.yarnpkg.com/create-hash/-/create-hash-1.2.0.tgz -> yarnpkg-create-hash-1.2.0.tgz
https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.7.tgz -> yarnpkg-create-hmac-1.1.7.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz -> yarnpkg-cross-spawn-5.1.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.12.0.tgz -> yarnpkg-crypto-browserify-3.12.0.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-1.0.0.tgz -> yarnpkg-crypto-random-string-1.0.0.tgz
https://registry.yarnpkg.com/css-color-names/-/css-color-names-0.0.4.tgz -> yarnpkg-css-color-names-0.0.4.tgz
https://registry.yarnpkg.com/css-declaration-sorter/-/css-declaration-sorter-4.0.1.tgz -> yarnpkg-css-declaration-sorter-4.0.1.tgz
https://registry.yarnpkg.com/css-element-queries/-/css-element-queries-1.2.3.tgz -> yarnpkg-css-element-queries-1.2.3.tgz
https://registry.yarnpkg.com/css-loader/-/css-loader-1.0.1.tgz -> yarnpkg-css-loader-1.0.1.tgz
https://registry.yarnpkg.com/css-parse/-/css-parse-2.0.0.tgz -> yarnpkg-css-parse-2.0.0.tgz
https://registry.yarnpkg.com/css-select-base-adapter/-/css-select-base-adapter-0.1.1.tgz -> yarnpkg-css-select-base-adapter-0.1.1.tgz
https://registry.yarnpkg.com/css-select/-/css-select-2.1.0.tgz -> yarnpkg-css-select-2.1.0.tgz
https://registry.yarnpkg.com/css-select/-/css-select-4.3.0.tgz -> yarnpkg-css-select-4.3.0.tgz
https://registry.yarnpkg.com/css-selector-tokenizer/-/css-selector-tokenizer-0.7.3.tgz -> yarnpkg-css-selector-tokenizer-0.7.3.tgz
https://registry.yarnpkg.com/css-tree/-/css-tree-1.0.0-alpha.37.tgz -> yarnpkg-css-tree-1.0.0-alpha.37.tgz
https://registry.yarnpkg.com/css-tree/-/css-tree-1.1.3.tgz -> yarnpkg-css-tree-1.1.3.tgz
https://registry.yarnpkg.com/css-value/-/css-value-0.0.1.tgz -> yarnpkg-css-value-0.0.1.tgz
https://registry.yarnpkg.com/css-what/-/css-what-3.4.2.tgz -> yarnpkg-css-what-3.4.2.tgz
https://registry.yarnpkg.com/css-what/-/css-what-6.1.0.tgz -> yarnpkg-css-what-6.1.0.tgz
https://registry.yarnpkg.com/css/-/css-2.2.4.tgz -> yarnpkg-css-2.2.4.tgz
https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz -> yarnpkg-cssesc-3.0.0.tgz
https://registry.yarnpkg.com/cssnano-preset-default/-/cssnano-preset-default-4.0.8.tgz -> yarnpkg-cssnano-preset-default-4.0.8.tgz
https://registry.yarnpkg.com/cssnano-util-get-arguments/-/cssnano-util-get-arguments-4.0.0.tgz -> yarnpkg-cssnano-util-get-arguments-4.0.0.tgz
https://registry.yarnpkg.com/cssnano-util-get-match/-/cssnano-util-get-match-4.0.0.tgz -> yarnpkg-cssnano-util-get-match-4.0.0.tgz
https://registry.yarnpkg.com/cssnano-util-raw-cache/-/cssnano-util-raw-cache-4.0.1.tgz -> yarnpkg-cssnano-util-raw-cache-4.0.1.tgz
https://registry.yarnpkg.com/cssnano-util-same-parent/-/cssnano-util-same-parent-4.0.1.tgz -> yarnpkg-cssnano-util-same-parent-4.0.1.tgz
https://registry.yarnpkg.com/cssnano/-/cssnano-4.1.11.tgz -> yarnpkg-cssnano-4.1.11.tgz
https://registry.yarnpkg.com/csso/-/csso-4.2.0.tgz -> yarnpkg-csso-4.2.0.tgz
https://registry.yarnpkg.com/cssom/-/cssom-0.3.8.tgz -> yarnpkg-cssom-0.3.8.tgz
https://registry.yarnpkg.com/cssstyle/-/cssstyle-1.4.0.tgz -> yarnpkg-cssstyle-1.4.0.tgz
https://registry.yarnpkg.com/current-script-polyfill/-/current-script-polyfill-1.0.0.tgz -> yarnpkg-current-script-polyfill-1.0.0.tgz
https://registry.yarnpkg.com/custom-electron-titlebar/-/custom-electron-titlebar-3.2.3.tgz -> yarnpkg-custom-electron-titlebar-3.2.3.tgz
https://registry.yarnpkg.com/cyclist/-/cyclist-1.0.1.tgz -> yarnpkg-cyclist-1.0.1.tgz
https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz -> yarnpkg-dashdash-1.14.1.tgz
https://registry.yarnpkg.com/data-urls/-/data-urls-1.1.0.tgz -> yarnpkg-data-urls-1.1.0.tgz
https://registry.yarnpkg.com/de-indent/-/de-indent-1.0.2.tgz -> yarnpkg-de-indent-1.0.2.tgz
https://registry.yarnpkg.com/deasync/-/deasync-0.1.28.tgz -> yarnpkg-deasync-0.1.28.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> yarnpkg-decode-uri-component-0.2.2.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz -> yarnpkg-decompress-response-3.3.0.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz -> yarnpkg-decompress-response-6.0.0.tgz
https://registry.yarnpkg.com/dedent-js/-/dedent-js-1.0.1.tgz -> yarnpkg-dedent-js-1.0.1.tgz
https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.1.1.tgz -> yarnpkg-deep-equal-1.1.1.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-1.5.2.tgz -> yarnpkg-deepmerge-1.5.2.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.3.1.tgz -> yarnpkg-deepmerge-4.3.1.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-2.0.1.tgz -> yarnpkg-deepmerge-2.0.1.tgz
https://registry.yarnpkg.com/default-gateway/-/default-gateway-4.2.0.tgz -> yarnpkg-default-gateway-4.2.0.tgz
https://registry.yarnpkg.com/default-gateway/-/default-gateway-5.0.5.tgz -> yarnpkg-default-gateway-5.0.5.tgz
https://registry.yarnpkg.com/default-require-extensions/-/default-require-extensions-1.0.0.tgz -> yarnpkg-default-require-extensions-1.0.0.tgz
https://registry.yarnpkg.com/defaults/-/defaults-1.0.4.tgz -> yarnpkg-defaults-1.0.4.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> yarnpkg-defer-to-connect-1.1.3.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz -> yarnpkg-define-property-0.2.5.tgz
https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz -> yarnpkg-define-property-1.0.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz -> yarnpkg-define-property-2.0.2.tgz
https://registry.yarnpkg.com/del/-/del-4.1.1.tgz -> yarnpkg-del-4.1.1.tgz
https://registry.yarnpkg.com/del/-/del-6.1.1.tgz -> yarnpkg-del-6.1.1.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz -> yarnpkg-depd-2.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz -> yarnpkg-depd-1.1.2.tgz
https://registry.yarnpkg.com/des.js/-/des.js-1.0.1.tgz -> yarnpkg-des.js-1.0.1.tgz
https://registry.yarnpkg.com/destroy/-/destroy-1.2.0.tgz -> yarnpkg-destroy-1.2.0.tgz
https://registry.yarnpkg.com/detect-hover/-/detect-hover-1.0.3.tgz -> yarnpkg-detect-hover-1.0.3.tgz
https://registry.yarnpkg.com/detect-indent/-/detect-indent-4.0.0.tgz -> yarnpkg-detect-indent-4.0.0.tgz
https://registry.yarnpkg.com/detect-it/-/detect-it-3.0.7.tgz -> yarnpkg-detect-it-3.0.7.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz -> yarnpkg-detect-libc-1.0.3.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-2.0.1.tgz -> yarnpkg-detect-libc-2.0.1.tgz
https://registry.yarnpkg.com/detect-newline/-/detect-newline-2.1.0.tgz -> yarnpkg-detect-newline-2.1.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/detect-passive-events/-/detect-passive-events-1.0.5.tgz -> yarnpkg-detect-passive-events-1.0.5.tgz
https://registry.yarnpkg.com/detect-pointer/-/detect-pointer-1.0.3.tgz -> yarnpkg-detect-pointer-1.0.3.tgz
https://registry.yarnpkg.com/detect-touch-events/-/detect-touch-events-2.0.2.tgz -> yarnpkg-detect-touch-events-2.0.2.tgz
https://registry.yarnpkg.com/dev-null/-/dev-null-0.1.1.tgz -> yarnpkg-dev-null-0.1.1.tgz
https://registry.yarnpkg.com/diff/-/diff-3.5.0.tgz -> yarnpkg-diff-3.5.0.tgz
https://registry.yarnpkg.com/diff/-/diff-4.0.2.tgz -> yarnpkg-diff-4.0.2.tgz
https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> yarnpkg-diffie-hellman-5.0.3.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-2.2.2.tgz -> yarnpkg-dir-glob-2.2.2.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-21.2.0.tgz -> yarnpkg-dmg-builder-21.2.0.tgz
https://registry.yarnpkg.com/dns-equal/-/dns-equal-1.0.0.tgz -> yarnpkg-dns-equal-1.0.0.tgz
https://registry.yarnpkg.com/dns-packet/-/dns-packet-1.3.4.tgz -> yarnpkg-dns-packet-1.3.4.tgz
https://registry.yarnpkg.com/dns-txt/-/dns-txt-2.0.2.tgz -> yarnpkg-dns-txt-2.0.2.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dom-converter/-/dom-converter-0.2.0.tgz -> yarnpkg-dom-converter-0.2.0.tgz
https://registry.yarnpkg.com/dom-event-types/-/dom-event-types-1.1.0.tgz -> yarnpkg-dom-event-types-1.1.0.tgz
https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.2.2.tgz -> yarnpkg-dom-serializer-0.2.2.tgz
https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-1.4.1.tgz -> yarnpkg-dom-serializer-1.4.1.tgz
https://registry.yarnpkg.com/dom-walk/-/dom-walk-0.1.2.tgz -> yarnpkg-dom-walk-0.1.2.tgz
https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.2.0.tgz -> yarnpkg-domain-browser-1.2.0.tgz
https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.3.1.tgz -> yarnpkg-domelementtype-1.3.1.tgz
https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.3.0.tgz -> yarnpkg-domelementtype-2.3.0.tgz
https://registry.yarnpkg.com/domexception/-/domexception-1.0.1.tgz -> yarnpkg-domexception-1.0.1.tgz
https://registry.yarnpkg.com/domhandler/-/domhandler-4.3.1.tgz -> yarnpkg-domhandler-4.3.1.tgz
https://registry.yarnpkg.com/domutils/-/domutils-1.7.0.tgz -> yarnpkg-domutils-1.7.0.tgz
https://registry.yarnpkg.com/domutils/-/domutils-2.8.0.tgz -> yarnpkg-domutils-2.8.0.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-4.2.1.tgz -> yarnpkg-dot-prop-4.2.1.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-5.3.0.tgz -> yarnpkg-dot-prop-5.3.0.tgz
https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> yarnpkg-dotenv-expand-5.1.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-7.0.0.tgz -> yarnpkg-dotenv-7.0.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-8.6.0.tgz -> yarnpkg-dotenv-8.6.0.tgz
https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.5.tgz -> yarnpkg-duplexer3-0.1.5.tgz
https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.2.tgz -> yarnpkg-duplexer-0.1.2.tgz
https://registry.yarnpkg.com/duplexify/-/duplexify-3.7.1.tgz -> yarnpkg-duplexify-3.7.1.tgz
https://registry.yarnpkg.com/easy-stack/-/easy-stack-1.0.1.tgz -> yarnpkg-easy-stack-1.0.1.tgz
https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> yarnpkg-ecc-jsbn-0.1.2.tgz
https://registry.yarnpkg.com/editorconfig/-/editorconfig-0.15.3.tgz -> yarnpkg-editorconfig-0.15.3.tgz
https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz -> yarnpkg-ee-first-1.1.1.tgz
https://registry.yarnpkg.com/ejs/-/ejs-2.7.4.tgz -> yarnpkg-ejs-2.7.4.tgz
https://registry.yarnpkg.com/ejs/-/ejs-2.5.9.tgz -> yarnpkg-ejs-2.5.9.tgz
https://registry.yarnpkg.com/electron-builder/-/electron-builder-21.2.0.tgz -> yarnpkg-electron-builder-21.2.0.tgz
https://registry.yarnpkg.com/electron-chromedriver/-/electron-chromedriver-5.0.1.tgz -> yarnpkg-electron-chromedriver-5.0.1.tgz
https://registry.yarnpkg.com/electron-devtools-installer/-/electron-devtools-installer-3.2.0.tgz -> yarnpkg-electron-devtools-installer-3.2.0.tgz
https://registry.yarnpkg.com/electron-download/-/electron-download-4.1.1.tgz -> yarnpkg-electron-download-4.1.1.tgz
https://registry.yarnpkg.com/electron-icon-builder/-/electron-icon-builder-2.0.1.tgz -> yarnpkg-electron-icon-builder-2.0.1.tgz
https://registry.yarnpkg.com/electron-publish/-/electron-publish-21.2.0.tgz -> yarnpkg-electron-publish-21.2.0.tgz
https://registry.yarnpkg.com/electron-settings/-/electron-settings-4.0.2.tgz -> yarnpkg-electron-settings-4.0.2.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.354.tgz -> yarnpkg-electron-to-chromium-1.4.354.tgz
https://registry.yarnpkg.com/electron/-/electron-13.6.9.tgz -> yarnpkg-electron-13.6.9.tgz
https://registry.yarnpkg.com/element-resize-detector/-/element-resize-detector-1.2.4.tgz -> yarnpkg-element-resize-detector-1.2.4.tgz
https://registry.yarnpkg.com/elliptic/-/elliptic-6.5.4.tgz -> yarnpkg-elliptic-6.5.4.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-7.0.3.tgz -> yarnpkg-emoji-regex-7.0.3.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-2.1.0.tgz -> yarnpkg-emojis-list-2.1.0.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz -> yarnpkg-emojis-list-3.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> yarnpkg-enhanced-resolve-4.5.0.tgz
https://registry.yarnpkg.com/entities/-/entities-2.2.0.tgz -> yarnpkg-entities-2.2.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-1.0.0.tgz -> yarnpkg-env-paths-1.0.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/errno/-/errno-0.1.8.tgz -> yarnpkg-errno-0.1.8.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/error-stack-parser/-/error-stack-parser-2.1.4.tgz -> yarnpkg-error-stack-parser-2.1.4.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-array-method-boxes-properly/-/es-array-method-boxes-properly-1.0.0.tgz -> yarnpkg-es-array-method-boxes-properly-1.0.0.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.8.tgz -> yarnpkg-es6-promise-4.2.8.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz -> yarnpkg-escape-html-1.0.3.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> yarnpkg-escape-string-regexp-2.0.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/escodegen/-/escodegen-1.14.3.tgz -> yarnpkg-escodegen-1.14.3.tgz
https://registry.yarnpkg.com/eslint-config-prettier/-/eslint-config-prettier-3.6.0.tgz -> yarnpkg-eslint-config-prettier-3.6.0.tgz
https://registry.yarnpkg.com/eslint-loader/-/eslint-loader-2.2.1.tgz -> yarnpkg-eslint-loader-2.2.1.tgz
https://registry.yarnpkg.com/eslint-plugin-prettier/-/eslint-plugin-prettier-3.4.1.tgz -> yarnpkg-eslint-plugin-prettier-3.4.1.tgz
https://registry.yarnpkg.com/eslint-plugin-vue/-/eslint-plugin-vue-4.7.1.tgz -> yarnpkg-eslint-plugin-vue-4.7.1.tgz
https://registry.yarnpkg.com/eslint-plugin-vue/-/eslint-plugin-vue-5.2.3.tgz -> yarnpkg-eslint-plugin-vue-5.2.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-3.7.3.tgz -> yarnpkg-eslint-scope-3.7.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-4.0.3.tgz -> yarnpkg-eslint-scope-4.0.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-1.4.3.tgz -> yarnpkg-eslint-utils-1.4.3.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz -> yarnpkg-eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-4.19.1.tgz -> yarnpkg-eslint-4.19.1.tgz
https://registry.yarnpkg.com/eslint/-/eslint-5.16.0.tgz -> yarnpkg-eslint-5.16.0.tgz
https://registry.yarnpkg.com/espree/-/espree-3.5.4.tgz -> yarnpkg-espree-3.5.4.tgz
https://registry.yarnpkg.com/espree/-/espree-4.1.0.tgz -> yarnpkg-espree-4.1.0.tgz
https://registry.yarnpkg.com/espree/-/espree-5.0.1.tgz -> yarnpkg-espree-5.0.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz -> yarnpkg-esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz -> yarnpkg-etag-1.8.1.tgz
https://registry.yarnpkg.com/event-pubsub/-/event-pubsub-4.3.0.tgz -> yarnpkg-event-pubsub-4.3.0.tgz
https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.7.tgz -> yarnpkg-eventemitter3-4.0.7.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz -> yarnpkg-events-3.3.0.tgz
https://registry.yarnpkg.com/eventsource/-/eventsource-2.0.2.tgz -> yarnpkg-eventsource-2.0.2.tgz
https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> yarnpkg-evp_bytestokey-1.0.3.tgz
https://registry.yarnpkg.com/exec-sh/-/exec-sh-0.2.2.tgz -> yarnpkg-exec-sh-0.2.2.tgz
https://registry.yarnpkg.com/execa/-/execa-0.7.0.tgz -> yarnpkg-execa-0.7.0.tgz
https://registry.yarnpkg.com/execa/-/execa-0.8.0.tgz -> yarnpkg-execa-0.8.0.tgz
https://registry.yarnpkg.com/execa/-/execa-1.0.0.tgz -> yarnpkg-execa-1.0.0.tgz
https://registry.yarnpkg.com/execa/-/execa-3.4.0.tgz -> yarnpkg-execa-3.4.0.tgz
https://registry.yarnpkg.com/exif-parser/-/exif-parser-0.1.12.tgz -> yarnpkg-exif-parser-0.1.12.tgz
https://registry.yarnpkg.com/exit/-/exit-0.1.2.tgz -> yarnpkg-exit-0.1.2.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz -> yarnpkg-expand-brackets-0.1.5.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz -> yarnpkg-expand-brackets-2.1.4.tgz
https://registry.yarnpkg.com/expand-range/-/expand-range-1.8.2.tgz -> yarnpkg-expand-range-1.8.2.tgz
https://registry.yarnpkg.com/expand-template/-/expand-template-2.0.3.tgz -> yarnpkg-expand-template-2.0.3.tgz
https://registry.yarnpkg.com/expect/-/expect-23.6.0.tgz -> yarnpkg-expect-23.6.0.tgz
https://registry.yarnpkg.com/express/-/express-4.18.2.tgz -> yarnpkg-express-4.18.2.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz -> yarnpkg-extend-shallow-3.0.2.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-2.2.0.tgz -> yarnpkg-external-editor-2.2.0.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/extglob/-/extglob-0.3.2.tgz -> yarnpkg-extglob-0.3.2.tgz
https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz -> yarnpkg-extglob-2.0.4.tgz
https://registry.yarnpkg.com/extract-from-css/-/extract-from-css-0.4.4.tgz -> yarnpkg-extract-from-css-0.4.4.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz -> yarnpkg-extract-zip-1.7.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz -> yarnpkg-extsprintf-1.3.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.1.tgz -> yarnpkg-extsprintf-1.4.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz -> yarnpkg-fast-deep-equal-1.1.0.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-diff/-/fast-diff-1.2.0.tgz -> yarnpkg-fast-diff-1.2.0.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-2.2.7.tgz -> yarnpkg-fast-glob-2.2.7.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fast-png/-/fast-png-5.0.4.tgz -> yarnpkg-fast-png-5.0.4.tgz
https://registry.yarnpkg.com/fastparse/-/fastparse-1.1.2.tgz -> yarnpkg-fastparse-1.1.2.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz -> yarnpkg-fastq-1.15.0.tgz
https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.11.4.tgz -> yarnpkg-faye-websocket-0.11.4.tgz
https://registry.yarnpkg.com/fb-watchman/-/fb-watchman-2.0.2.tgz -> yarnpkg-fb-watchman-2.0.2.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> yarnpkg-figgy-pudding-3.5.2.tgz
https://registry.yarnpkg.com/figures/-/figures-2.0.0.tgz -> yarnpkg-figures-2.0.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-2.0.0.tgz -> yarnpkg-file-entry-cache-2.0.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-5.0.1.tgz -> yarnpkg-file-entry-cache-5.0.1.tgz
https://registry.yarnpkg.com/file-loader/-/file-loader-3.0.1.tgz -> yarnpkg-file-loader-3.0.1.tgz
https://registry.yarnpkg.com/file-type/-/file-type-16.5.4.tgz -> yarnpkg-file-type-16.5.4.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> yarnpkg-file-uri-to-path-1.0.0.tgz
https://registry.yarnpkg.com/file-url/-/file-url-2.0.2.tgz -> yarnpkg-file-url-2.0.2.tgz
https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.1.tgz -> yarnpkg-filename-regex-2.0.1.tgz
https://registry.yarnpkg.com/fileset/-/fileset-2.0.3.tgz -> yarnpkg-fileset-2.0.3.tgz
https://registry.yarnpkg.com/filesize/-/filesize-3.6.1.tgz -> yarnpkg-filesize-3.6.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-2.2.4.tgz -> yarnpkg-fill-range-2.2.4.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz -> yarnpkg-fill-range-4.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.2.0.tgz -> yarnpkg-finalhandler-1.2.0.tgz
https://registry.yarnpkg.com/find-babel-config/-/find-babel-config-1.2.0.tgz -> yarnpkg-find-babel-config-1.2.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-0.1.1.tgz -> yarnpkg-find-cache-dir-0.1.1.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> yarnpkg-find-cache-dir-1.0.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> yarnpkg-find-cache-dir-2.1.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> yarnpkg-find-cache-dir-3.3.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz -> yarnpkg-find-up-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-1.3.4.tgz -> yarnpkg-flat-cache-1.3.4.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-2.0.1.tgz -> yarnpkg-flat-cache-2.0.1.tgz
https://registry.yarnpkg.com/flatted/-/flatted-2.0.2.tgz -> yarnpkg-flatted-2.0.2.tgz
https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> yarnpkg-flush-write-stream-1.1.1.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.2.tgz -> yarnpkg-follow-redirects-1.15.2.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz -> yarnpkg-for-in-1.0.2.tgz
https://registry.yarnpkg.com/for-own/-/for-own-0.1.5.tgz -> yarnpkg-for-own-0.1.5.tgz
https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz -> yarnpkg-forever-agent-0.6.1.tgz
https://registry.yarnpkg.com/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-0.5.2.tgz -> yarnpkg-fork-ts-checker-webpack-plugin-0.5.2.tgz
https://registry.yarnpkg.com/form-data/-/form-data-2.3.3.tgz -> yarnpkg-form-data-2.3.3.tgz
https://registry.yarnpkg.com/forwarded/-/forwarded-0.2.0.tgz -> yarnpkg-forwarded-0.2.0.tgz
https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz -> yarnpkg-fragment-cache-0.2.1.tgz
https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz -> yarnpkg-fresh-0.5.2.tgz
https://registry.yarnpkg.com/friendly-errors-webpack-plugin/-/friendly-errors-webpack-plugin-1.7.0.tgz -> yarnpkg-friendly-errors-webpack-plugin-1.7.0.tgz
https://registry.yarnpkg.com/from2/-/from2-2.3.0.tgz -> yarnpkg-from2-2.3.0.tgz
https://registry.yarnpkg.com/fs-constants/-/fs-constants-1.0.0.tgz -> yarnpkg-fs-constants-1.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-1.0.0.tgz -> yarnpkg-fs-extra-1.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz -> yarnpkg-fs-extra-10.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-4.0.3.tgz -> yarnpkg-fs-extra-4.0.3.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.1.tgz -> yarnpkg-fs-extra-7.0.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> yarnpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.13.tgz -> yarnpkg-fsevents-1.2.13.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> yarnpkg-functional-red-black-tree-1.0.1.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/gaze/-/gaze-1.1.3.tgz -> yarnpkg-gaze-1.1.3.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.3.tgz -> yarnpkg-get-caller-file-1.0.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-6.0.0.tgz -> yarnpkg-get-stdin-6.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-3.0.0.tgz -> yarnpkg-get-stream-3.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz -> yarnpkg-get-stream-4.1.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz -> yarnpkg-get-stream-5.2.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz -> yarnpkg-get-value-2.0.6.tgz
https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz -> yarnpkg-getpass-0.1.7.tgz
https://registry.yarnpkg.com/gifwrap/-/gifwrap-0.9.4.tgz -> yarnpkg-gifwrap-0.9.4.tgz
https://registry.yarnpkg.com/github-from-package/-/github-from-package-0.0.0.tgz -> yarnpkg-github-from-package-0.0.0.tgz
https://registry.yarnpkg.com/glob-base/-/glob-base-0.3.0.tgz -> yarnpkg-glob-base-0.3.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-2.0.0.tgz -> yarnpkg-glob-parent-2.0.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz -> yarnpkg-glob-parent-3.1.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.3.0.tgz -> yarnpkg-glob-to-regexp-0.3.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-8.1.0.tgz -> yarnpkg-glob-8.1.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz -> yarnpkg-glob-7.1.7.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz -> yarnpkg-global-agent-3.0.0.tgz
https://registry.yarnpkg.com/global-dirs/-/global-dirs-0.1.1.tgz -> yarnpkg-global-dirs-0.1.1.tgz
https://registry.yarnpkg.com/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> yarnpkg-global-tunnel-ng-2.7.1.tgz
https://registry.yarnpkg.com/global/-/global-4.4.0.tgz -> yarnpkg-global-4.4.0.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globals/-/globals-9.18.0.tgz -> yarnpkg-globals-9.18.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz -> yarnpkg-globby-11.1.0.tgz
https://registry.yarnpkg.com/globby/-/globby-6.1.0.tgz -> yarnpkg-globby-6.1.0.tgz
https://registry.yarnpkg.com/globby/-/globby-7.1.1.tgz -> yarnpkg-globby-7.1.1.tgz
https://registry.yarnpkg.com/globby/-/globby-9.2.0.tgz -> yarnpkg-globby-9.2.0.tgz
https://registry.yarnpkg.com/globule/-/globule-1.3.4.tgz -> yarnpkg-globule-1.3.4.tgz
https://registry.yarnpkg.com/golden-layout/-/golden-layout-1.5.9.tgz -> yarnpkg-golden-layout-1.5.9.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/got/-/got-9.6.0.tgz -> yarnpkg-got-9.6.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> yarnpkg-grapheme-splitter-1.0.4.tgz
https://registry.yarnpkg.com/growly/-/growly-1.3.0.tgz -> yarnpkg-growly-1.3.0.tgz
https://registry.yarnpkg.com/gzip-size/-/gzip-size-5.1.1.tgz -> yarnpkg-gzip-size-5.1.1.tgz
https://registry.yarnpkg.com/handle-thing/-/handle-thing-2.0.1.tgz -> yarnpkg-handle-thing-2.0.1.tgz
https://registry.yarnpkg.com/handlebars/-/handlebars-4.7.7.tgz -> yarnpkg-handlebars-4.7.7.tgz
https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz -> yarnpkg-har-schema-2.0.0.tgz
https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.5.tgz -> yarnpkg-har-validator-5.1.5.tgz
https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz -> yarnpkg-has-ansi-2.0.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-1.0.0.tgz -> yarnpkg-has-flag-1.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-2.0.0.tgz -> yarnpkg-has-flag-2.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz -> yarnpkg-has-value-0.3.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz -> yarnpkg-has-value-1.0.0.tgz
https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz -> yarnpkg-has-values-0.1.4.tgz
https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz -> yarnpkg-has-values-1.0.0.tgz
https://registry.yarnpkg.com/has-yarn/-/has-yarn-2.1.0.tgz -> yarnpkg-has-yarn-2.1.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hash-base/-/hash-base-3.1.0.tgz -> yarnpkg-hash-base-3.1.0.tgz
https://registry.yarnpkg.com/hash-sum/-/hash-sum-1.0.2.tgz -> yarnpkg-hash-sum-1.0.2.tgz
https://registry.yarnpkg.com/hash.js/-/hash.js-1.1.7.tgz -> yarnpkg-hash.js-1.1.7.tgz
https://registry.yarnpkg.com/hasha/-/hasha-2.2.0.tgz -> yarnpkg-hasha-2.2.0.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/hex-color-regex/-/hex-color-regex-1.1.0.tgz -> yarnpkg-hex-color-regex-1.1.0.tgz
https://registry.yarnpkg.com/highlight.js/-/highlight.js-10.7.3.tgz -> yarnpkg-highlight.js-10.7.3.tgz
https://registry.yarnpkg.com/history/-/history-4.10.1.tgz -> yarnpkg-history-4.10.1.tgz
https://registry.yarnpkg.com/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> yarnpkg-hmac-drbg-1.0.1.tgz
https://registry.yarnpkg.com/hoist-non-react-statics/-/hoist-non-react-statics-2.5.5.tgz -> yarnpkg-hoist-non-react-statics-2.5.5.tgz
https://registry.yarnpkg.com/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> yarnpkg-home-or-tmp-2.0.0.tgz
https://registry.yarnpkg.com/hoopy/-/hoopy-0.1.4.tgz -> yarnpkg-hoopy-0.1.4.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/hpack.js/-/hpack.js-2.1.6.tgz -> yarnpkg-hpack.js-2.1.6.tgz
https://registry.yarnpkg.com/hsl-regex/-/hsl-regex-1.0.0.tgz -> yarnpkg-hsl-regex-1.0.0.tgz
https://registry.yarnpkg.com/hsla-regex/-/hsla-regex-1.0.0.tgz -> yarnpkg-hsla-regex-1.0.0.tgz
https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-1.0.2.tgz -> yarnpkg-html-encoding-sniffer-1.0.2.tgz
https://registry.yarnpkg.com/html-entities/-/html-entities-1.4.0.tgz -> yarnpkg-html-entities-1.4.0.tgz
https://registry.yarnpkg.com/html-minifier/-/html-minifier-3.5.21.tgz -> yarnpkg-html-minifier-3.5.21.tgz
https://registry.yarnpkg.com/html-tags/-/html-tags-2.0.0.tgz -> yarnpkg-html-tags-2.0.0.tgz
https://registry.yarnpkg.com/html-webpack-plugin/-/html-webpack-plugin-3.2.0.tgz -> yarnpkg-html-webpack-plugin-3.2.0.tgz
https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-6.1.0.tgz -> yarnpkg-htmlparser2-6.1.0.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-deceiver/-/http-deceiver-1.2.7.tgz -> yarnpkg-http-deceiver-1.2.7.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-2.0.0.tgz -> yarnpkg-http-errors-2.0.0.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.3.tgz -> yarnpkg-http-errors-1.6.3.tgz
https://registry.yarnpkg.com/http-parser-js/-/http-parser-js-0.5.8.tgz -> yarnpkg-http-parser-js-0.5.8.tgz
https://registry.yarnpkg.com/http-proxy-middleware/-/http-proxy-middleware-0.19.1.tgz -> yarnpkg-http-proxy-middleware-0.19.1.tgz
https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.1.tgz -> yarnpkg-http-proxy-1.18.1.tgz
https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz -> yarnpkg-http-signature-1.2.0.tgz
https://registry.yarnpkg.com/https-browserify/-/https-browserify-1.0.0.tgz -> yarnpkg-https-browserify-1.0.0.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-1.1.1.tgz -> yarnpkg-human-signals-1.1.1.tgz
https://registry.yarnpkg.com/icon-gen/-/icon-gen-2.1.0.tgz -> yarnpkg-icon-gen-2.1.0.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.5.2.tgz -> yarnpkg-iconv-lite-0.5.2.tgz
https://registry.yarnpkg.com/icss-replace-symbols/-/icss-replace-symbols-1.1.0.tgz -> yarnpkg-icss-replace-symbols-1.1.0.tgz
https://registry.yarnpkg.com/icss-utils/-/icss-utils-2.1.0.tgz -> yarnpkg-icss-utils-2.1.0.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/iferr/-/iferr-0.1.5.tgz -> yarnpkg-iferr-0.1.5.tgz
https://registry.yarnpkg.com/ignore/-/ignore-3.3.10.tgz -> yarnpkg-ignore-3.3.10.tgz
https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz -> yarnpkg-ignore-4.0.6.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.2.4.tgz -> yarnpkg-ignore-5.2.4.tgz
https://registry.yarnpkg.com/image-q/-/image-q-4.0.0.tgz -> yarnpkg-image-q-4.0.0.tgz
https://registry.yarnpkg.com/immediate/-/immediate-3.0.6.tgz -> yarnpkg-immediate-3.0.6.tgz
https://registry.yarnpkg.com/import-cwd/-/import-cwd-2.1.0.tgz -> yarnpkg-import-cwd-2.1.0.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-2.0.0.tgz -> yarnpkg-import-fresh-2.0.0.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-from/-/import-from-2.1.0.tgz -> yarnpkg-import-from-2.1.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz -> yarnpkg-import-lazy-2.1.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-1.0.0.tgz -> yarnpkg-import-local-1.0.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-2.0.0.tgz -> yarnpkg-import-local-2.0.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/indexes-of/-/indexes-of-1.0.1.tgz -> yarnpkg-indexes-of-1.0.1.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz -> yarnpkg-inherits-2.0.1.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz -> yarnpkg-inherits-2.0.3.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-3.3.0.tgz -> yarnpkg-inquirer-3.3.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-6.5.2.tgz -> yarnpkg-inquirer-6.5.2.tgz
https://registry.yarnpkg.com/internal-ip/-/internal-ip-4.3.0.tgz -> yarnpkg-internal-ip-4.3.0.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/intersection-observer/-/intersection-observer-0.5.1.tgz -> yarnpkg-intersection-observer-0.5.1.tgz
https://registry.yarnpkg.com/invariant/-/invariant-2.2.4.tgz -> yarnpkg-invariant-2.2.4.tgz
https://registry.yarnpkg.com/invert-kv/-/invert-kv-1.0.0.tgz -> yarnpkg-invert-kv-1.0.0.tgz
https://registry.yarnpkg.com/invert-kv/-/invert-kv-2.0.0.tgz -> yarnpkg-invert-kv-2.0.0.tgz
https://registry.yarnpkg.com/iobuffer/-/iobuffer-5.3.2.tgz -> yarnpkg-iobuffer-5.3.2.tgz
https://registry.yarnpkg.com/ip-regex/-/ip-regex-2.1.0.tgz -> yarnpkg-ip-regex-2.1.0.tgz
https://registry.yarnpkg.com/ip/-/ip-1.1.8.tgz -> yarnpkg-ip-1.1.8.tgz
https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> yarnpkg-ipaddr.js-1.9.1.tgz
https://registry.yarnpkg.com/is-absolute-url/-/is-absolute-url-2.1.0.tgz -> yarnpkg-is-absolute-url-2.1.0.tgz
https://registry.yarnpkg.com/is-absolute-url/-/is-absolute-url-3.0.3.tgz -> yarnpkg-is-absolute-url-3.0.3.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> yarnpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> yarnpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-arguments/-/is-arguments-1.1.1.tgz -> yarnpkg-is-arguments-1.1.1.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.3.2.tgz -> yarnpkg-is-arrayish-0.3.2.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz -> yarnpkg-is-binary-path-1.0.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz -> yarnpkg-is-buffer-1.1.6.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-1.2.1.tgz -> yarnpkg-is-ci-1.2.1.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-color-stop/-/is-color-stop-1.1.0.tgz -> yarnpkg-is-color-stop-1.1.0.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> yarnpkg-is-data-descriptor-0.1.4.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> yarnpkg-is-data-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz -> yarnpkg-is-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz -> yarnpkg-is-descriptor-1.0.2.tgz
https://registry.yarnpkg.com/is-directory/-/is-directory-0.3.1.tgz -> yarnpkg-is-directory-0.3.1.tgz
https://registry.yarnpkg.com/is-docker/-/is-docker-2.2.1.tgz -> yarnpkg-is-docker-2.2.1.tgz
https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.3.tgz -> yarnpkg-is-dotfile-1.0.3.tgz
https://registry.yarnpkg.com/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> yarnpkg-is-equal-shallow-0.1.3.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz -> yarnpkg-is-extendable-1.0.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-1.0.0.tgz -> yarnpkg-is-extglob-1.0.0.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-finite/-/is-finite-1.1.0.tgz -> yarnpkg-is-finite-1.1.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> yarnpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-function/-/is-function-1.0.2.tgz -> yarnpkg-is-function-1.0.2.tgz
https://registry.yarnpkg.com/is-generator-fn/-/is-generator-fn-1.0.0.tgz -> yarnpkg-is-generator-fn-1.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz -> yarnpkg-is-glob-2.0.1.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz -> yarnpkg-is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.1.0.tgz -> yarnpkg-is-installed-globally-0.1.0.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-npm/-/is-npm-3.0.0.tgz -> yarnpkg-is-npm-3.0.0.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-2.1.0.tgz -> yarnpkg-is-number-2.1.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz -> yarnpkg-is-number-3.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz -> yarnpkg-is-number-4.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz -> yarnpkg-is-obj-1.0.1.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-2.0.0.tgz -> yarnpkg-is-obj-2.0.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> yarnpkg-is-path-cwd-2.2.0.tgz
https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz -> yarnpkg-is-path-in-cwd-2.1.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.1.tgz -> yarnpkg-is-path-inside-1.0.1.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-2.1.0.tgz -> yarnpkg-is-path-inside-2.1.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz -> yarnpkg-is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> yarnpkg-is-posix-bracket-0.1.1.tgz
https://registry.yarnpkg.com/is-primitive/-/is-primitive-2.0.0.tgz -> yarnpkg-is-primitive-2.0.0.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-resolvable/-/is-resolvable-1.1.0.tgz -> yarnpkg-is-resolvable-1.1.0.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz -> yarnpkg-is-stream-1.1.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz -> yarnpkg-is-utf8-0.2.1.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-whitespace/-/is-whitespace-0.3.0.tgz -> yarnpkg-is-whitespace-0.3.0.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz -> yarnpkg-is-wsl-1.1.0.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz -> yarnpkg-is-wsl-2.2.0.tgz
https://registry.yarnpkg.com/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> yarnpkg-is-yarn-global-0.3.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz -> yarnpkg-isarray-0.0.1.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> yarnpkg-isbinaryfile-4.0.10.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz -> yarnpkg-isobject-2.1.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz -> yarnpkg-isstream-0.1.2.tgz
https://registry.yarnpkg.com/istanbul-api/-/istanbul-api-1.3.7.tgz -> yarnpkg-istanbul-api-1.3.7.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-1.2.1.tgz -> yarnpkg-istanbul-lib-coverage-1.2.1.tgz
https://registry.yarnpkg.com/istanbul-lib-hook/-/istanbul-lib-hook-1.2.2.tgz -> yarnpkg-istanbul-lib-hook-1.2.2.tgz
https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-1.10.2.tgz -> yarnpkg-istanbul-lib-instrument-1.10.2.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-1.1.5.tgz -> yarnpkg-istanbul-lib-report-1.1.5.tgz
https://registry.yarnpkg.com/istanbul-lib-source-maps/-/istanbul-lib-source-maps-1.2.6.tgz -> yarnpkg-istanbul-lib-source-maps-1.2.6.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-1.5.1.tgz -> yarnpkg-istanbul-reports-1.5.1.tgz
https://registry.yarnpkg.com/javascript-stringify/-/javascript-stringify-1.6.0.tgz -> yarnpkg-javascript-stringify-1.6.0.tgz
https://registry.yarnpkg.com/javascript-stringify/-/javascript-stringify-2.1.0.tgz -> yarnpkg-javascript-stringify-2.1.0.tgz
https://registry.yarnpkg.com/jest-changed-files/-/jest-changed-files-23.4.2.tgz -> yarnpkg-jest-changed-files-23.4.2.tgz
https://registry.yarnpkg.com/jest-cli/-/jest-cli-23.6.0.tgz -> yarnpkg-jest-cli-23.6.0.tgz
https://registry.yarnpkg.com/jest-config/-/jest-config-23.6.0.tgz -> yarnpkg-jest-config-23.6.0.tgz
https://registry.yarnpkg.com/jest-diff/-/jest-diff-23.6.0.tgz -> yarnpkg-jest-diff-23.6.0.tgz
https://registry.yarnpkg.com/jest-docblock/-/jest-docblock-23.2.0.tgz -> yarnpkg-jest-docblock-23.2.0.tgz
https://registry.yarnpkg.com/jest-each/-/jest-each-23.6.0.tgz -> yarnpkg-jest-each-23.6.0.tgz
https://registry.yarnpkg.com/jest-environment-jsdom/-/jest-environment-jsdom-23.4.0.tgz -> yarnpkg-jest-environment-jsdom-23.4.0.tgz
https://registry.yarnpkg.com/jest-environment-node/-/jest-environment-node-23.4.0.tgz -> yarnpkg-jest-environment-node-23.4.0.tgz
https://registry.yarnpkg.com/jest-get-type/-/jest-get-type-22.4.3.tgz -> yarnpkg-jest-get-type-22.4.3.tgz
https://registry.yarnpkg.com/jest-haste-map/-/jest-haste-map-23.6.0.tgz -> yarnpkg-jest-haste-map-23.6.0.tgz
https://registry.yarnpkg.com/jest-jasmine2/-/jest-jasmine2-23.6.0.tgz -> yarnpkg-jest-jasmine2-23.6.0.tgz
https://registry.yarnpkg.com/jest-leak-detector/-/jest-leak-detector-23.6.0.tgz -> yarnpkg-jest-leak-detector-23.6.0.tgz
https://registry.yarnpkg.com/jest-matcher-utils/-/jest-matcher-utils-23.6.0.tgz -> yarnpkg-jest-matcher-utils-23.6.0.tgz
https://registry.yarnpkg.com/jest-message-util/-/jest-message-util-23.4.0.tgz -> yarnpkg-jest-message-util-23.4.0.tgz
https://registry.yarnpkg.com/jest-mock/-/jest-mock-23.2.0.tgz -> yarnpkg-jest-mock-23.2.0.tgz
https://registry.yarnpkg.com/jest-regex-util/-/jest-regex-util-23.3.0.tgz -> yarnpkg-jest-regex-util-23.3.0.tgz
https://registry.yarnpkg.com/jest-resolve-dependencies/-/jest-resolve-dependencies-23.6.0.tgz -> yarnpkg-jest-resolve-dependencies-23.6.0.tgz
https://registry.yarnpkg.com/jest-resolve/-/jest-resolve-23.6.0.tgz -> yarnpkg-jest-resolve-23.6.0.tgz
https://registry.yarnpkg.com/jest-runner/-/jest-runner-23.6.0.tgz -> yarnpkg-jest-runner-23.6.0.tgz
https://registry.yarnpkg.com/jest-runtime/-/jest-runtime-23.6.0.tgz -> yarnpkg-jest-runtime-23.6.0.tgz
https://registry.yarnpkg.com/jest-serializer-vue/-/jest-serializer-vue-2.0.2.tgz -> yarnpkg-jest-serializer-vue-2.0.2.tgz
https://registry.yarnpkg.com/jest-serializer/-/jest-serializer-23.0.1.tgz -> yarnpkg-jest-serializer-23.0.1.tgz
https://registry.yarnpkg.com/jest-snapshot/-/jest-snapshot-23.6.0.tgz -> yarnpkg-jest-snapshot-23.6.0.tgz
https://registry.yarnpkg.com/jest-transform-stub/-/jest-transform-stub-2.0.0.tgz -> yarnpkg-jest-transform-stub-2.0.0.tgz
https://registry.yarnpkg.com/jest-util/-/jest-util-23.4.0.tgz -> yarnpkg-jest-util-23.4.0.tgz
https://registry.yarnpkg.com/jest-validate/-/jest-validate-23.6.0.tgz -> yarnpkg-jest-validate-23.6.0.tgz
https://registry.yarnpkg.com/jest-watch-typeahead/-/jest-watch-typeahead-0.2.1.tgz -> yarnpkg-jest-watch-typeahead-0.2.1.tgz
https://registry.yarnpkg.com/jest-watcher/-/jest-watcher-23.4.0.tgz -> yarnpkg-jest-watcher-23.4.0.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-23.2.0.tgz -> yarnpkg-jest-worker-23.2.0.tgz
https://registry.yarnpkg.com/jest/-/jest-23.6.0.tgz -> yarnpkg-jest-23.6.0.tgz
https://registry.yarnpkg.com/jimp/-/jimp-0.16.13.tgz -> yarnpkg-jimp-0.16.13.tgz
https://registry.yarnpkg.com/jpeg-js/-/jpeg-js-0.4.4.tgz -> yarnpkg-jpeg-js-0.4.4.tgz
https://registry.yarnpkg.com/jquery/-/jquery-3.6.4.tgz -> yarnpkg-jquery-3.6.4.tgz
https://registry.yarnpkg.com/js-beautify/-/js-beautify-1.14.7.tgz -> yarnpkg-js-beautify-1.14.7.tgz
https://registry.yarnpkg.com/js-levenshtein/-/js-levenshtein-1.1.6.tgz -> yarnpkg-js-levenshtein-1.1.6.tgz
https://registry.yarnpkg.com/js-message/-/js-message-1.0.7.tgz -> yarnpkg-js-message-1.0.7.tgz
https://registry.yarnpkg.com/js-queue/-/js-queue-2.0.2.tgz -> yarnpkg-js-queue-2.0.2.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.2.tgz -> yarnpkg-js-tokens-3.0.2.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz -> yarnpkg-js-yaml-3.14.1.tgz
https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz -> yarnpkg-jsbn-0.1.1.tgz
https://registry.yarnpkg.com/jsdom/-/jsdom-11.12.0.tgz -> yarnpkg-jsdom-11.12.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-1.3.0.tgz -> yarnpkg-jsesc-1.3.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.0.tgz -> yarnpkg-json-buffer-3.0.0.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> yarnpkg-json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz -> yarnpkg-json-schema-traverse-0.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema/-/json-schema-0.4.0.tgz -> yarnpkg-json-schema-0.4.0.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz -> yarnpkg-json5-2.2.3.tgz
https://registry.yarnpkg.com/json5/-/json5-0.5.1.tgz -> yarnpkg-json5-0.5.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-2.4.0.tgz -> yarnpkg-jsonfile-2.4.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.2.tgz -> yarnpkg-jsprim-1.4.2.tgz
https://registry.yarnpkg.com/jszip/-/jszip-3.10.1.tgz -> yarnpkg-jszip-3.10.1.tgz
https://registry.yarnpkg.com/kew/-/kew-0.7.0.tgz -> yarnpkg-kew-0.7.0.tgz
https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz -> yarnpkg-keyv-3.1.0.tgz
https://registry.yarnpkg.com/killable/-/killable-1.0.1.tgz -> yarnpkg-killable-1.0.1.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz -> yarnpkg-kind-of-3.2.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz -> yarnpkg-kind-of-4.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz -> yarnpkg-kind-of-5.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/klaw/-/klaw-1.3.1.tgz -> yarnpkg-klaw-1.3.1.tgz
https://registry.yarnpkg.com/kleur/-/kleur-2.0.2.tgz -> yarnpkg-kleur-2.0.2.tgz
https://registry.yarnpkg.com/latest-version/-/latest-version-5.1.0.tgz -> yarnpkg-latest-version-5.1.0.tgz
https://registry.yarnpkg.com/launch-editor-middleware/-/launch-editor-middleware-2.6.0.tgz -> yarnpkg-launch-editor-middleware-2.6.0.tgz
https://registry.yarnpkg.com/launch-editor/-/launch-editor-2.6.0.tgz -> yarnpkg-launch-editor-2.6.0.tgz
https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.5.tgz -> yarnpkg-lazy-val-1.0.5.tgz
https://registry.yarnpkg.com/lazystream/-/lazystream-1.0.1.tgz -> yarnpkg-lazystream-1.0.1.tgz
https://registry.yarnpkg.com/lcid/-/lcid-1.0.0.tgz -> yarnpkg-lcid-1.0.0.tgz
https://registry.yarnpkg.com/lcid/-/lcid-2.0.0.tgz -> yarnpkg-lcid-2.0.0.tgz
https://registry.yarnpkg.com/left-pad/-/left-pad-1.3.0.tgz -> yarnpkg-left-pad-1.3.0.tgz
https://registry.yarnpkg.com/leven/-/leven-2.1.0.tgz -> yarnpkg-leven-2.1.0.tgz
https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz -> yarnpkg-levn-0.3.0.tgz
https://registry.yarnpkg.com/lie/-/lie-3.3.0.tgz -> yarnpkg-lie-3.3.0.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> yarnpkg-lines-and-columns-1.2.4.tgz
https://registry.yarnpkg.com/load-bmfont/-/load-bmfont-1.4.1.tgz -> yarnpkg-load-bmfont-1.4.1.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz -> yarnpkg-load-json-file-1.1.0.tgz
https://registry.yarnpkg.com/loader-fs-cache/-/loader-fs-cache-1.0.3.tgz -> yarnpkg-loader-fs-cache-1.0.3.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-2.4.0.tgz -> yarnpkg-loader-runner-2.4.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-0.2.17.tgz -> yarnpkg-loader-utils-0.2.17.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.2.tgz -> yarnpkg-loader-utils-1.4.2.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.4.tgz -> yarnpkg-loader-utils-2.0.4.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.defaultsdeep/-/lodash.defaultsdeep-4.6.1.tgz -> yarnpkg-lodash.defaultsdeep-4.6.1.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash.has/-/lodash.has-4.5.2.tgz -> yarnpkg-lodash.has-4.5.2.tgz
https://registry.yarnpkg.com/lodash.kebabcase/-/lodash.kebabcase-4.1.1.tgz -> yarnpkg-lodash.kebabcase-4.1.1.tgz
https://registry.yarnpkg.com/lodash.mapvalues/-/lodash.mapvalues-4.6.0.tgz -> yarnpkg-lodash.mapvalues-4.6.0.tgz
https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-4.1.2.tgz -> yarnpkg-lodash.memoize-4.1.2.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash.set/-/lodash.set-4.3.2.tgz -> yarnpkg-lodash.set-4.3.2.tgz
https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> yarnpkg-lodash.sortby-4.7.0.tgz
https://registry.yarnpkg.com/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> yarnpkg-lodash.throttle-4.1.1.tgz
https://registry.yarnpkg.com/lodash.transform/-/lodash.transform-4.6.0.tgz -> yarnpkg-lodash.transform-4.6.0.tgz
https://registry.yarnpkg.com/lodash.unescape/-/lodash.unescape-4.0.1.tgz -> yarnpkg-lodash.unescape-4.0.1.tgz
https://registry.yarnpkg.com/lodash.uniq/-/lodash.uniq-4.5.0.tgz -> yarnpkg-lodash.uniq-4.5.0.tgz
https://registry.yarnpkg.com/lodash.unset/-/lodash.unset-4.5.2.tgz -> yarnpkg-lodash.unset-4.5.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-2.2.0.tgz -> yarnpkg-log-symbols-2.2.0.tgz
https://registry.yarnpkg.com/loglevel/-/loglevel-1.8.1.tgz -> yarnpkg-loglevel-1.8.1.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz -> yarnpkg-loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/lower-case/-/lower-case-1.1.4.tgz -> yarnpkg-lower-case-1.1.4.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> yarnpkg-lowercase-keys-1.0.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz -> yarnpkg-lru-cache-4.1.5.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz -> yarnpkg-lru-cache-5.1.1.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru_map/-/lru_map-0.3.3.tgz -> yarnpkg-lru_map-0.3.3.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz -> yarnpkg-make-dir-1.3.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-2.1.0.tgz -> yarnpkg-make-dir-2.1.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/make-error/-/make-error-1.3.6.tgz -> yarnpkg-make-error-1.3.6.tgz
https://registry.yarnpkg.com/makeerror/-/makeerror-1.0.12.tgz -> yarnpkg-makeerror-1.0.12.tgz
https://registry.yarnpkg.com/map-age-cleaner/-/map-age-cleaner-0.1.3.tgz -> yarnpkg-map-age-cleaner-0.1.3.tgz
https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz -> yarnpkg-map-cache-0.2.2.tgz
https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz -> yarnpkg-map-visit-1.0.0.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/material-colors/-/material-colors-1.2.6.tgz -> yarnpkg-material-colors-1.2.6.tgz
https://registry.yarnpkg.com/math-random/-/math-random-1.0.4.tgz -> yarnpkg-math-random-1.0.4.tgz
https://registry.yarnpkg.com/md5.js/-/md5.js-1.3.5.tgz -> yarnpkg-md5.js-1.3.5.tgz
https://registry.yarnpkg.com/mdn-data/-/mdn-data-2.0.14.tgz -> yarnpkg-mdn-data-2.0.14.tgz
https://registry.yarnpkg.com/mdn-data/-/mdn-data-2.0.4.tgz -> yarnpkg-mdn-data-2.0.4.tgz
https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz -> yarnpkg-media-typer-0.3.0.tgz
https://registry.yarnpkg.com/mem/-/mem-4.3.0.tgz -> yarnpkg-mem-4.3.0.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz -> yarnpkg-memory-fs-0.4.1.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.5.0.tgz -> yarnpkg-memory-fs-0.5.0.tgz
https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz -> yarnpkg-merge-descriptors-1.0.1.tgz
https://registry.yarnpkg.com/merge-source-map/-/merge-source-map-1.1.0.tgz -> yarnpkg-merge-source-map-1.1.0.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-1.0.1.tgz -> yarnpkg-merge-stream-1.0.1.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/merge/-/merge-1.2.1.tgz -> yarnpkg-merge-1.2.1.tgz
https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz -> yarnpkg-methods-1.1.2.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-2.3.11.tgz -> yarnpkg-micromatch-2.3.11.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz -> yarnpkg-micromatch-3.1.10.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.1.tgz -> yarnpkg-miller-rabin-4.0.1.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz -> yarnpkg-mime-1.6.0.tgz
https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz -> yarnpkg-mime-2.6.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-1.2.0.tgz -> yarnpkg-mimic-fn-1.2.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz -> yarnpkg-mimic-response-3.1.0.tgz
https://registry.yarnpkg.com/min-document/-/min-document-2.19.0.tgz -> yarnpkg-min-document-2.19.0.tgz
https://registry.yarnpkg.com/mini-css-extract-plugin/-/mini-css-extract-plugin-0.8.2.tgz -> yarnpkg-mini-css-extract-plugin-0.8.2.tgz
https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> yarnpkg-minimalistic-assert-1.0.1.tgz
https://registry.yarnpkg.com/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> yarnpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.8.tgz -> yarnpkg-minimatch-3.0.8.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/minimist/-/minimist-0.0.10.tgz -> yarnpkg-minimist-0.0.10.tgz
https://registry.yarnpkg.com/mississippi/-/mississippi-2.0.0.tgz -> yarnpkg-mississippi-2.0.0.tgz
https://registry.yarnpkg.com/mississippi/-/mississippi-3.0.0.tgz -> yarnpkg-mississippi-3.0.0.tgz
https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz -> yarnpkg-mixin-deep-1.3.2.tgz
https://registry.yarnpkg.com/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> yarnpkg-mkdirp-classic-0.5.3.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz -> yarnpkg-mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/move-concurrently/-/move-concurrently-1.0.1.tgz -> yarnpkg-move-concurrently-1.0.1.tgz
https://registry.yarnpkg.com/mri/-/mri-1.1.4.tgz -> yarnpkg-mri-1.1.4.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/multicast-dns-service-types/-/multicast-dns-service-types-1.1.0.tgz -> yarnpkg-multicast-dns-service-types-1.1.0.tgz
https://registry.yarnpkg.com/multicast-dns/-/multicast-dns-6.2.3.tgz -> yarnpkg-multicast-dns-6.2.3.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.7.tgz -> yarnpkg-mute-stream-0.0.7.tgz
https://registry.yarnpkg.com/mz/-/mz-2.7.0.tgz -> yarnpkg-mz-2.7.0.tgz
https://registry.yarnpkg.com/nan/-/nan-2.17.0.tgz -> yarnpkg-nan-2.17.0.tgz
https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz -> yarnpkg-nanomatch-1.2.13.tgz
https://registry.yarnpkg.com/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> yarnpkg-napi-build-utils-1.0.2.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.3.tgz -> yarnpkg-negotiator-0.6.3.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz -> yarnpkg-neo-async-2.6.2.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/no-case/-/no-case-2.3.2.tgz -> yarnpkg-no-case-2.3.2.tgz
https://registry.yarnpkg.com/node-abi/-/node-abi-3.35.0.tgz -> yarnpkg-node-abi-3.35.0.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-1.7.2.tgz -> yarnpkg-node-addon-api-1.7.2.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-4.3.0.tgz -> yarnpkg-node-addon-api-4.3.0.tgz
https://registry.yarnpkg.com/node-cache/-/node-cache-4.2.1.tgz -> yarnpkg-node-cache-4.2.1.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.9.tgz -> yarnpkg-node-fetch-2.6.9.tgz
https://registry.yarnpkg.com/node-forge/-/node-forge-0.10.0.tgz -> yarnpkg-node-forge-0.10.0.tgz
https://registry.yarnpkg.com/node-int64/-/node-int64-0.4.0.tgz -> yarnpkg-node-int64-0.4.0.tgz
https://registry.yarnpkg.com/node-ipc/-/node-ipc-9.2.1.tgz -> yarnpkg-node-ipc-9.2.1.tgz
https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> yarnpkg-node-libs-browser-2.2.1.tgz
https://registry.yarnpkg.com/node-notifier/-/node-notifier-5.4.5.tgz -> yarnpkg-node-notifier-5.4.5.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.10.tgz -> yarnpkg-node-releases-2.0.10.tgz
https://registry.yarnpkg.com/nopt/-/nopt-6.0.0.tgz -> yarnpkg-nopt-6.0.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-1.0.0.tgz -> yarnpkg-normalize-path-1.0.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz -> yarnpkg-normalize-path-2.1.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz -> yarnpkg-normalize-range-0.1.2.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-1.9.1.tgz -> yarnpkg-normalize-url-1.9.1.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-3.3.0.tgz -> yarnpkg-normalize-url-3.3.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.1.tgz -> yarnpkg-normalize-url-4.5.1.tgz
https://registry.yarnpkg.com/npm-conf/-/npm-conf-1.1.3.tgz -> yarnpkg-npm-conf-1.1.3.tgz
https://registry.yarnpkg.com/npm-install-package/-/npm-install-package-2.1.0.tgz -> yarnpkg-npm-install-package-2.1.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz -> yarnpkg-npm-run-path-2.0.2.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/nth-check/-/nth-check-1.0.2.tgz -> yarnpkg-nth-check-1.0.2.tgz
https://registry.yarnpkg.com/nth-check/-/nth-check-2.1.1.tgz -> yarnpkg-nth-check-2.1.1.tgz
https://registry.yarnpkg.com/nugget/-/nugget-2.2.0.tgz -> yarnpkg-nugget-2.2.0.tgz
https://registry.yarnpkg.com/num2fraction/-/num2fraction-1.2.2.tgz -> yarnpkg-num2fraction-1.2.2.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/nwsapi/-/nwsapi-2.2.2.tgz -> yarnpkg-nwsapi-2.2.2.tgz
https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz -> yarnpkg-oauth-sign-0.9.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz -> yarnpkg-object-copy-0.1.0.tgz
https://registry.yarnpkg.com/object-hash/-/object-hash-1.3.1.tgz -> yarnpkg-object-hash-1.3.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-is/-/object-is-1.1.5.tgz -> yarnpkg-object-is-1.1.5.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-0.4.0.tgz -> yarnpkg-object-keys-0.4.0.tgz
https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz -> yarnpkg-object-visit-1.0.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.getownpropertydescriptors/-/object.getownpropertydescriptors-2.1.5.tgz -> yarnpkg-object.getownpropertydescriptors-2.1.5.tgz
https://registry.yarnpkg.com/object.omit/-/object.omit-2.0.1.tgz -> yarnpkg-object.omit-2.0.1.tgz
https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz -> yarnpkg-object.pick-1.3.0.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz -> yarnpkg-object.values-1.1.6.tgz
https://registry.yarnpkg.com/obuf/-/obuf-1.1.2.tgz -> yarnpkg-obuf-1.1.2.tgz
https://registry.yarnpkg.com/omggif/-/omggif-1.0.10.tgz -> yarnpkg-omggif-1.0.10.tgz
https://registry.yarnpkg.com/on-finished/-/on-finished-2.4.1.tgz -> yarnpkg-on-finished-2.4.1.tgz
https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.2.tgz -> yarnpkg-on-headers-1.0.2.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-2.0.1.tgz -> yarnpkg-onetime-2.0.1.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/open/-/open-6.4.0.tgz -> yarnpkg-open-6.4.0.tgz
https://registry.yarnpkg.com/opener/-/opener-1.5.2.tgz -> yarnpkg-opener-1.5.2.tgz
https://registry.yarnpkg.com/opn/-/opn-5.5.0.tgz -> yarnpkg-opn-5.5.0.tgz
https://registry.yarnpkg.com/optimist/-/optimist-0.6.1.tgz -> yarnpkg-optimist-0.6.1.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz -> yarnpkg-optionator-0.8.3.tgz
https://registry.yarnpkg.com/ora/-/ora-3.4.0.tgz -> yarnpkg-ora-3.4.0.tgz
https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.3.0.tgz -> yarnpkg-os-browserify-0.3.0.tgz
https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz -> yarnpkg-os-homedir-1.0.2.tgz
https://registry.yarnpkg.com/os-locale/-/os-locale-1.4.0.tgz -> yarnpkg-os-locale-1.4.0.tgz
https://registry.yarnpkg.com/os-locale/-/os-locale-3.1.0.tgz -> yarnpkg-os-locale-3.1.0.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-1.1.0.tgz -> yarnpkg-p-cancelable-1.1.0.tgz
https://registry.yarnpkg.com/p-defer/-/p-defer-1.0.0.tgz -> yarnpkg-p-defer-1.0.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz -> yarnpkg-p-finally-1.0.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-2.0.1.tgz -> yarnpkg-p-finally-2.0.1.tgz
https://registry.yarnpkg.com/p-is-promise/-/p-is-promise-2.1.0.tgz -> yarnpkg-p-is-promise-2.1.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-2.1.0.tgz -> yarnpkg-p-map-2.1.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/p-retry/-/p-retry-3.0.1.tgz -> yarnpkg-p-retry-3.0.1.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/package-json/-/package-json-6.5.0.tgz -> yarnpkg-package-json-6.5.0.tgz
https://registry.yarnpkg.com/pako/-/pako-1.0.11.tgz -> yarnpkg-pako-1.0.11.tgz
https://registry.yarnpkg.com/pako/-/pako-2.1.0.tgz -> yarnpkg-pako-2.1.0.tgz
https://registry.yarnpkg.com/parallel-transform/-/parallel-transform-1.2.0.tgz -> yarnpkg-parallel-transform-1.2.0.tgz
https://registry.yarnpkg.com/param-case/-/param-case-2.1.1.tgz -> yarnpkg-param-case-2.1.1.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.1.6.tgz -> yarnpkg-parse-asn1-5.1.6.tgz
https://registry.yarnpkg.com/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> yarnpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.yarnpkg.com/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> yarnpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.yarnpkg.com/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz -> yarnpkg-parse-bmfont-xml-1.1.4.tgz
https://registry.yarnpkg.com/parse-glob/-/parse-glob-3.0.4.tgz -> yarnpkg-parse-glob-3.0.4.tgz
https://registry.yarnpkg.com/parse-headers/-/parse-headers-2.0.5.tgz -> yarnpkg-parse-headers-2.0.5.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz -> yarnpkg-parse-json-5.2.0.tgz
https://registry.yarnpkg.com/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-6.0.1.tgz -> yarnpkg-parse5-htmlparser2-tree-adapter-6.0.1.tgz
https://registry.yarnpkg.com/parse5/-/parse5-4.0.0.tgz -> yarnpkg-parse5-4.0.0.tgz
https://registry.yarnpkg.com/parse5/-/parse5-5.1.1.tgz -> yarnpkg-parse5-5.1.1.tgz
https://registry.yarnpkg.com/parse5/-/parse5-6.0.1.tgz -> yarnpkg-parse5-6.0.1.tgz
https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz -> yarnpkg-parseurl-1.3.3.tgz
https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz -> yarnpkg-pascalcase-0.1.1.tgz
https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.1.tgz -> yarnpkg-path-browserify-0.0.1.tgz
https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz -> yarnpkg-path-dirname-1.0.2.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz -> yarnpkg-path-exists-2.1.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz -> yarnpkg-path-is-inside-1.0.2.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> yarnpkg-path-to-regexp-0.1.7.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.8.0.tgz -> yarnpkg-path-to-regexp-1.8.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz -> yarnpkg-path-type-1.1.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz -> yarnpkg-path-type-3.0.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.1.2.tgz -> yarnpkg-pbkdf2-3.1.2.tgz
https://registry.yarnpkg.com/peek-readable/-/peek-readable-4.1.0.tgz -> yarnpkg-peek-readable-4.1.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz -> yarnpkg-performance-now-2.1.0.tgz
https://registry.yarnpkg.com/phantomjs-prebuilt/-/phantomjs-prebuilt-2.1.16.tgz -> yarnpkg-phantomjs-prebuilt-2.1.16.tgz
https://registry.yarnpkg.com/phin/-/phin-2.9.3.tgz -> yarnpkg-phin-2.9.3.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-0.2.1.tgz -> yarnpkg-picocolors-0.2.1.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz -> yarnpkg-pify-4.0.1.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/pixelmatch/-/pixelmatch-4.0.2.tgz -> yarnpkg-pixelmatch-4.0.2.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-1.0.0.tgz -> yarnpkg-pkg-dir-1.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz -> yarnpkg-pkg-dir-2.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-3.0.0.tgz -> yarnpkg-pkg-dir-3.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz -> yarnpkg-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/pluralize/-/pluralize-7.0.0.tgz -> yarnpkg-pluralize-7.0.0.tgz
https://registry.yarnpkg.com/pn/-/pn-1.1.0.tgz -> yarnpkg-pn-1.1.0.tgz
https://registry.yarnpkg.com/pngjs/-/pngjs-3.4.0.tgz -> yarnpkg-pngjs-3.4.0.tgz
https://registry.yarnpkg.com/pngjs/-/pngjs-6.0.0.tgz -> yarnpkg-pngjs-6.0.0.tgz
https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.32.tgz -> yarnpkg-portfinder-1.0.32.tgz
https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> yarnpkg-posix-character-classes-0.1.1.tgz
https://registry.yarnpkg.com/postcss-calc/-/postcss-calc-7.0.5.tgz -> yarnpkg-postcss-calc-7.0.5.tgz
https://registry.yarnpkg.com/postcss-colormin/-/postcss-colormin-4.0.3.tgz -> yarnpkg-postcss-colormin-4.0.3.tgz
https://registry.yarnpkg.com/postcss-convert-values/-/postcss-convert-values-4.0.1.tgz -> yarnpkg-postcss-convert-values-4.0.1.tgz
https://registry.yarnpkg.com/postcss-discard-comments/-/postcss-discard-comments-4.0.2.tgz -> yarnpkg-postcss-discard-comments-4.0.2.tgz
https://registry.yarnpkg.com/postcss-discard-duplicates/-/postcss-discard-duplicates-4.0.2.tgz -> yarnpkg-postcss-discard-duplicates-4.0.2.tgz
https://registry.yarnpkg.com/postcss-discard-empty/-/postcss-discard-empty-4.0.1.tgz -> yarnpkg-postcss-discard-empty-4.0.1.tgz
https://registry.yarnpkg.com/postcss-discard-overridden/-/postcss-discard-overridden-4.0.1.tgz -> yarnpkg-postcss-discard-overridden-4.0.1.tgz
https://registry.yarnpkg.com/postcss-load-config/-/postcss-load-config-2.1.2.tgz -> yarnpkg-postcss-load-config-2.1.2.tgz
https://registry.yarnpkg.com/postcss-loader/-/postcss-loader-3.0.0.tgz -> yarnpkg-postcss-loader-3.0.0.tgz
https://registry.yarnpkg.com/postcss-merge-longhand/-/postcss-merge-longhand-4.0.11.tgz -> yarnpkg-postcss-merge-longhand-4.0.11.tgz
https://registry.yarnpkg.com/postcss-merge-rules/-/postcss-merge-rules-4.0.3.tgz -> yarnpkg-postcss-merge-rules-4.0.3.tgz
https://registry.yarnpkg.com/postcss-minify-font-values/-/postcss-minify-font-values-4.0.2.tgz -> yarnpkg-postcss-minify-font-values-4.0.2.tgz
https://registry.yarnpkg.com/postcss-minify-gradients/-/postcss-minify-gradients-4.0.2.tgz -> yarnpkg-postcss-minify-gradients-4.0.2.tgz
https://registry.yarnpkg.com/postcss-minify-params/-/postcss-minify-params-4.0.2.tgz -> yarnpkg-postcss-minify-params-4.0.2.tgz
https://registry.yarnpkg.com/postcss-minify-selectors/-/postcss-minify-selectors-4.0.2.tgz -> yarnpkg-postcss-minify-selectors-4.0.2.tgz
https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-1.2.1.tgz -> yarnpkg-postcss-modules-extract-imports-1.2.1.tgz
https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-1.2.0.tgz -> yarnpkg-postcss-modules-local-by-default-1.2.0.tgz
https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-1.1.0.tgz -> yarnpkg-postcss-modules-scope-1.1.0.tgz
https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-1.3.0.tgz -> yarnpkg-postcss-modules-values-1.3.0.tgz
https://registry.yarnpkg.com/postcss-normalize-charset/-/postcss-normalize-charset-4.0.1.tgz -> yarnpkg-postcss-normalize-charset-4.0.1.tgz
https://registry.yarnpkg.com/postcss-normalize-display-values/-/postcss-normalize-display-values-4.0.2.tgz -> yarnpkg-postcss-normalize-display-values-4.0.2.tgz
https://registry.yarnpkg.com/postcss-normalize-positions/-/postcss-normalize-positions-4.0.2.tgz -> yarnpkg-postcss-normalize-positions-4.0.2.tgz
https://registry.yarnpkg.com/postcss-normalize-repeat-style/-/postcss-normalize-repeat-style-4.0.2.tgz -> yarnpkg-postcss-normalize-repeat-style-4.0.2.tgz
https://registry.yarnpkg.com/postcss-normalize-string/-/postcss-normalize-string-4.0.2.tgz -> yarnpkg-postcss-normalize-string-4.0.2.tgz
https://registry.yarnpkg.com/postcss-normalize-timing-functions/-/postcss-normalize-timing-functions-4.0.2.tgz -> yarnpkg-postcss-normalize-timing-functions-4.0.2.tgz
https://registry.yarnpkg.com/postcss-normalize-unicode/-/postcss-normalize-unicode-4.0.1.tgz -> yarnpkg-postcss-normalize-unicode-4.0.1.tgz
https://registry.yarnpkg.com/postcss-normalize-url/-/postcss-normalize-url-4.0.1.tgz -> yarnpkg-postcss-normalize-url-4.0.1.tgz
https://registry.yarnpkg.com/postcss-normalize-whitespace/-/postcss-normalize-whitespace-4.0.2.tgz -> yarnpkg-postcss-normalize-whitespace-4.0.2.tgz
https://registry.yarnpkg.com/postcss-ordered-values/-/postcss-ordered-values-4.1.2.tgz -> yarnpkg-postcss-ordered-values-4.1.2.tgz
https://registry.yarnpkg.com/postcss-reduce-initial/-/postcss-reduce-initial-4.0.3.tgz -> yarnpkg-postcss-reduce-initial-4.0.3.tgz
https://registry.yarnpkg.com/postcss-reduce-transforms/-/postcss-reduce-transforms-4.0.2.tgz -> yarnpkg-postcss-reduce-transforms-4.0.2.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> yarnpkg-postcss-selector-parser-3.1.2.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.11.tgz -> yarnpkg-postcss-selector-parser-6.0.11.tgz
https://registry.yarnpkg.com/postcss-svgo/-/postcss-svgo-4.0.3.tgz -> yarnpkg-postcss-svgo-4.0.3.tgz
https://registry.yarnpkg.com/postcss-unique-selectors/-/postcss-unique-selectors-4.0.1.tgz -> yarnpkg-postcss-unique-selectors-4.0.1.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> yarnpkg-postcss-value-parser-3.3.1.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> yarnpkg-postcss-value-parser-4.2.0.tgz
https://registry.yarnpkg.com/postcss/-/postcss-6.0.23.tgz -> yarnpkg-postcss-6.0.23.tgz
https://registry.yarnpkg.com/postcss/-/postcss-7.0.39.tgz -> yarnpkg-postcss-7.0.39.tgz
https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-7.1.1.tgz -> yarnpkg-prebuild-install-7.1.1.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz -> yarnpkg-prelude-ls-1.1.2.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz -> yarnpkg-prepend-http-1.0.4.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-2.0.0.tgz -> yarnpkg-prepend-http-2.0.0.tgz
https://registry.yarnpkg.com/preserve/-/preserve-0.2.0.tgz -> yarnpkg-preserve-0.2.0.tgz
https://registry.yarnpkg.com/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz -> yarnpkg-prettier-linter-helpers-1.0.0.tgz
https://registry.yarnpkg.com/prettier/-/prettier-1.19.1.tgz -> yarnpkg-prettier-1.19.1.tgz
https://registry.yarnpkg.com/prettier/-/prettier-2.8.7.tgz -> yarnpkg-prettier-2.8.7.tgz
https://registry.yarnpkg.com/pretty-bytes/-/pretty-bytes-4.0.2.tgz -> yarnpkg-pretty-bytes-4.0.2.tgz
https://registry.yarnpkg.com/pretty-error/-/pretty-error-2.1.2.tgz -> yarnpkg-pretty-error-2.1.2.tgz
https://registry.yarnpkg.com/pretty-format/-/pretty-format-23.6.0.tgz -> yarnpkg-pretty-format-23.6.0.tgz
https://registry.yarnpkg.com/pretty/-/pretty-2.0.0.tgz -> yarnpkg-pretty-2.0.0.tgz
https://registry.yarnpkg.com/private/-/private-0.1.8.tgz -> yarnpkg-private-0.1.8.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/process/-/process-0.11.10.tgz -> yarnpkg-process-0.11.10.tgz
https://registry.yarnpkg.com/progress-stream/-/progress-stream-1.2.0.tgz -> yarnpkg-progress-stream-1.2.0.tgz
https://registry.yarnpkg.com/progress/-/progress-1.1.8.tgz -> yarnpkg-progress-1.1.8.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/prompts/-/prompts-0.1.14.tgz -> yarnpkg-prompts-0.1.14.tgz
https://registry.yarnpkg.com/prop-types/-/prop-types-15.8.1.tgz -> yarnpkg-prop-types-15.8.1.tgz
https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz -> yarnpkg-proto-list-1.2.4.tgz
https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.7.tgz -> yarnpkg-proxy-addr-2.0.7.tgz
https://registry.yarnpkg.com/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> yarnpkg-proxy-from-env-1.1.0.tgz
https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz -> yarnpkg-prr-1.0.1.tgz
https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz -> yarnpkg-pseudomap-1.0.2.tgz
https://registry.yarnpkg.com/psl/-/psl-1.9.0.tgz -> yarnpkg-psl-1.9.0.tgz
https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.3.tgz -> yarnpkg-public-encrypt-4.0.3.tgz
https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz -> yarnpkg-pump-2.0.1.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz -> yarnpkg-pumpify-1.5.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz -> yarnpkg-punycode-1.3.2.tgz
https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz -> yarnpkg-punycode-1.4.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/q/-/q-1.5.1.tgz -> yarnpkg-q-1.5.1.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.0.tgz -> yarnpkg-qs-6.11.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.5.3.tgz -> yarnpkg-qs-6.5.3.tgz
https://registry.yarnpkg.com/query-string/-/query-string-4.3.4.tgz -> yarnpkg-query-string-4.3.4.tgz
https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz -> yarnpkg-querystring-es3-0.2.1.tgz
https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz -> yarnpkg-querystring-0.2.0.tgz
https://registry.yarnpkg.com/querystringify/-/querystringify-2.2.0.tgz -> yarnpkg-querystringify-2.2.0.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/randomatic/-/randomatic-3.1.1.tgz -> yarnpkg-randomatic-3.1.1.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/randomfill/-/randomfill-1.0.4.tgz -> yarnpkg-randomfill-1.0.4.tgz
https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz -> yarnpkg-range-parser-1.2.1.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.5.1.tgz -> yarnpkg-raw-body-2.5.1.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/react-dom/-/react-dom-16.14.0.tgz -> yarnpkg-react-dom-16.14.0.tgz
https://registry.yarnpkg.com/react-interactive/-/react-interactive-0.8.3.tgz -> yarnpkg-react-interactive-0.8.3.tgz
https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz -> yarnpkg-react-is-16.13.1.tgz
https://registry.yarnpkg.com/react-router-dom/-/react-router-dom-4.3.1.tgz -> yarnpkg-react-router-dom-4.3.1.tgz
https://registry.yarnpkg.com/react-router/-/react-router-4.3.1.tgz -> yarnpkg-react-router-4.3.1.tgz
https://registry.yarnpkg.com/react/-/react-16.14.0.tgz -> yarnpkg-react-16.14.0.tgz
https://registry.yarnpkg.com/read-config-file/-/read-config-file-5.0.0.tgz -> yarnpkg-read-config-file-5.0.0.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> yarnpkg-read-pkg-up-1.0.1.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz -> yarnpkg-read-pkg-1.1.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-5.2.0.tgz -> yarnpkg-read-pkg-5.2.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz -> yarnpkg-readable-stream-2.3.8.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.2.tgz -> yarnpkg-readable-stream-3.6.2.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz -> yarnpkg-readable-stream-1.1.14.tgz
https://registry.yarnpkg.com/readable-web-to-node-stream/-/readable-web-to-node-stream-3.0.2.tgz -> yarnpkg-readable-web-to-node-stream-3.0.2.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz -> yarnpkg-readdirp-2.2.1.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/realpath-native/-/realpath-native-1.1.0.tgz -> yarnpkg-realpath-native-1.1.0.tgz
https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.0.tgz -> yarnpkg-regenerate-unicode-properties-10.1.0.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz -> yarnpkg-regenerate-1.4.2.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> yarnpkg-regenerator-runtime-0.11.1.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> yarnpkg-regenerator-runtime-0.13.11.tgz
https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.15.1.tgz -> yarnpkg-regenerator-transform-0.15.1.tgz
https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.4.tgz -> yarnpkg-regex-cache-0.4.4.tgz
https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz -> yarnpkg-regex-not-1.0.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-1.1.0.tgz -> yarnpkg-regexpp-1.1.0.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-2.0.1.tgz -> yarnpkg-regexpp-2.0.1.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.2.0.tgz -> yarnpkg-regexpp-3.2.0.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-5.3.2.tgz -> yarnpkg-regexpu-core-5.3.2.tgz
https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-4.2.2.tgz -> yarnpkg-registry-auth-token-4.2.2.tgz
https://registry.yarnpkg.com/registry-url/-/registry-url-5.1.0.tgz -> yarnpkg-registry-url-5.1.0.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.9.1.tgz -> yarnpkg-regjsparser-0.9.1.tgz
https://registry.yarnpkg.com/relateurl/-/relateurl-0.2.7.tgz -> yarnpkg-relateurl-0.2.7.tgz
https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> yarnpkg-remove-trailing-separator-1.1.0.tgz
https://registry.yarnpkg.com/renderkid/-/renderkid-2.0.7.tgz -> yarnpkg-renderkid-2.0.7.tgz
https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.4.tgz -> yarnpkg-repeat-element-1.1.4.tgz
https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz -> yarnpkg-repeat-string-1.6.1.tgz
https://registry.yarnpkg.com/repeating/-/repeating-2.0.1.tgz -> yarnpkg-repeating-2.0.1.tgz
https://registry.yarnpkg.com/request-progress/-/request-progress-2.0.1.tgz -> yarnpkg-request-progress-2.0.1.tgz
https://registry.yarnpkg.com/request-promise-core/-/request-promise-core-1.1.4.tgz -> yarnpkg-request-promise-core-1.1.4.tgz
https://registry.yarnpkg.com/request-promise-native/-/request-promise-native-1.0.9.tgz -> yarnpkg-request-promise-native-1.0.9.tgz
https://registry.yarnpkg.com/request/-/request-2.88.2.tgz -> yarnpkg-request-2.88.2.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-1.0.1.tgz -> yarnpkg-require-main-filename-1.0.1.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz -> yarnpkg-require-main-filename-2.0.0.tgz
https://registry.yarnpkg.com/require-uncached/-/require-uncached-1.0.3.tgz -> yarnpkg-require-uncached-1.0.3.tgz
https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz -> yarnpkg-requires-port-1.0.0.tgz
https://registry.yarnpkg.com/reselect/-/reselect-3.0.1.tgz -> yarnpkg-reselect-3.0.1.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> yarnpkg-resolve-cwd-2.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-1.0.1.tgz -> yarnpkg-resolve-from-1.0.1.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz -> yarnpkg-resolve-from-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-pathname/-/resolve-pathname-3.0.0.tgz -> yarnpkg-resolve-pathname-3.0.0.tgz
https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz -> yarnpkg-resolve-url-0.2.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz -> yarnpkg-resolve-1.1.7.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz -> yarnpkg-resolve-1.22.2.tgz
https://registry.yarnpkg.com/responselike/-/responselike-1.0.2.tgz -> yarnpkg-responselike-1.0.2.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-2.0.0.tgz -> yarnpkg-restore-cursor-2.0.0.tgz
https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz -> yarnpkg-ret-0.1.15.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz -> yarnpkg-retry-0.12.0.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rgb-regex/-/rgb-regex-1.0.1.tgz -> yarnpkg-rgb-regex-1.0.1.tgz
https://registry.yarnpkg.com/rgb2hex/-/rgb2hex-0.1.10.tgz -> yarnpkg-rgb2hex-0.1.10.tgz
https://registry.yarnpkg.com/rgba-regex/-/rgba-regex-1.0.0.tgz -> yarnpkg-rgba-regex-1.0.0.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.3.tgz -> yarnpkg-rimraf-2.6.3.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/ripemd160/-/ripemd160-2.0.2.tgz -> yarnpkg-ripemd160-2.0.2.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz -> yarnpkg-roarr-2.15.4.tgz
https://registry.yarnpkg.com/rsvp/-/rsvp-3.6.2.tgz -> yarnpkg-rsvp-3.6.2.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/run-queue/-/run-queue-1.0.3.tgz -> yarnpkg-run-queue-1.0.3.tgz
https://registry.yarnpkg.com/rx-lite-aggregates/-/rx-lite-aggregates-4.0.8.tgz -> yarnpkg-rx-lite-aggregates-4.0.8.tgz
https://registry.yarnpkg.com/rx-lite/-/rx-lite-4.0.8.tgz -> yarnpkg-rx-lite-4.0.8.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.7.tgz -> yarnpkg-rxjs-6.6.7.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz -> yarnpkg-safe-regex-1.1.0.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sane/-/sane-2.5.2.tgz -> yarnpkg-sane-2.5.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/scheduler/-/scheduler-0.19.1.tgz -> yarnpkg-scheduler-0.19.1.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-1.0.0.tgz -> yarnpkg-schema-utils-1.0.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.1.tgz -> yarnpkg-schema-utils-2.7.1.tgz
https://registry.yarnpkg.com/select-hose/-/select-hose-2.0.0.tgz -> yarnpkg-select-hose-2.0.0.tgz
https://registry.yarnpkg.com/selfsigned/-/selfsigned-1.10.14.tgz -> yarnpkg-selfsigned-1.10.14.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver-diff/-/semver-diff-2.1.0.tgz -> yarnpkg-semver-diff-2.1.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-5.5.0.tgz -> yarnpkg-semver-5.5.0.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/send/-/send-0.18.0.tgz -> yarnpkg-send-0.18.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-1.9.1.tgz -> yarnpkg-serialize-javascript-1.9.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> yarnpkg-serialize-javascript-4.0.0.tgz
https://registry.yarnpkg.com/serve-index/-/serve-index-1.9.1.tgz -> yarnpkg-serve-index-1.9.1.tgz
https://registry.yarnpkg.com/serve-static/-/serve-static-1.15.0.tgz -> yarnpkg-serve-static-1.15.0.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz -> yarnpkg-set-value-2.0.1.tgz
https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz -> yarnpkg-setimmediate-1.0.5.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.0.tgz -> yarnpkg-setprototypeof-1.1.0.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.2.0.tgz -> yarnpkg-setprototypeof-1.2.0.tgz
https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.11.tgz -> yarnpkg-sha.js-2.4.11.tgz
https://registry.yarnpkg.com/sharp/-/sharp-0.29.3.tgz -> yarnpkg-sharp-0.29.3.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-loader/-/shebang-loader-0.0.1.tgz -> yarnpkg-shebang-loader-0.0.1.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/shell-quote/-/shell-quote-1.8.0.tgz -> yarnpkg-shell-quote-1.8.0.tgz
https://registry.yarnpkg.com/shellwords/-/shellwords-0.1.1.tgz -> yarnpkg-shellwords-0.1.1.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/sigmund/-/sigmund-1.0.1.tgz -> yarnpkg-sigmund-1.0.1.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/simple-concat/-/simple-concat-1.0.1.tgz -> yarnpkg-simple-concat-1.0.1.tgz
https://registry.yarnpkg.com/simple-get/-/simple-get-4.0.1.tgz -> yarnpkg-simple-get-4.0.1.tgz
https://registry.yarnpkg.com/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> yarnpkg-simple-swizzle-0.2.2.tgz
https://registry.yarnpkg.com/single-line-log/-/single-line-log-1.1.2.tgz -> yarnpkg-single-line-log-1.1.2.tgz
https://registry.yarnpkg.com/sisteransi/-/sisteransi-0.1.1.tgz -> yarnpkg-sisteransi-0.1.1.tgz
https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz -> yarnpkg-slash-1.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz -> yarnpkg-slash-3.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-1.0.0.tgz -> yarnpkg-slice-ansi-1.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-2.1.0.tgz -> yarnpkg-slice-ansi-2.1.0.tgz
https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> yarnpkg-snapdragon-node-2.1.1.tgz
https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> yarnpkg-snapdragon-util-3.0.1.tgz
https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz -> yarnpkg-snapdragon-0.8.2.tgz
https://registry.yarnpkg.com/sockjs-client/-/sockjs-client-1.6.1.tgz -> yarnpkg-sockjs-client-1.6.1.tgz
https://registry.yarnpkg.com/sockjs/-/sockjs-0.3.24.tgz -> yarnpkg-sockjs-0.3.24.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz -> yarnpkg-sort-keys-1.1.2.tgz
https://registry.yarnpkg.com/source-list-map/-/source-list-map-2.0.1.tgz -> yarnpkg-source-list-map-2.0.1.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> yarnpkg-source-map-resolve-0.5.3.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz -> yarnpkg-source-map-support-0.4.18.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.1.tgz -> yarnpkg-source-map-url-0.4.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> yarnpkg-spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/spdy-transport/-/spdy-transport-3.0.0.tgz -> yarnpkg-spdy-transport-3.0.0.tgz
https://registry.yarnpkg.com/spdy/-/spdy-4.0.2.tgz -> yarnpkg-spdy-4.0.2.tgz
https://registry.yarnpkg.com/spectron/-/spectron-7.0.0.tgz -> yarnpkg-spectron-7.0.0.tgz
https://registry.yarnpkg.com/speedometer/-/speedometer-0.1.4.tgz -> yarnpkg-speedometer-0.1.4.tgz
https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz -> yarnpkg-split-string-3.1.0.tgz
https://registry.yarnpkg.com/split2/-/split2-3.2.2.tgz -> yarnpkg-split2-3.2.2.tgz
https://registry.yarnpkg.com/split/-/split-1.0.1.tgz -> yarnpkg-split-1.0.1.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz -> yarnpkg-sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/sshpk/-/sshpk-1.17.0.tgz -> yarnpkg-sshpk-1.17.0.tgz
https://registry.yarnpkg.com/ssri/-/ssri-5.3.0.tgz -> yarnpkg-ssri-5.3.0.tgz
https://registry.yarnpkg.com/ssri/-/ssri-6.0.2.tgz -> yarnpkg-ssri-6.0.2.tgz
https://registry.yarnpkg.com/stable/-/stable-0.1.8.tgz -> yarnpkg-stable-0.1.8.tgz
https://registry.yarnpkg.com/stack-utils/-/stack-utils-1.0.5.tgz -> yarnpkg-stack-utils-1.0.5.tgz
https://registry.yarnpkg.com/stackframe/-/stackframe-1.3.4.tgz -> yarnpkg-stackframe-1.3.4.tgz
https://registry.yarnpkg.com/stat-mode/-/stat-mode-0.3.0.tgz -> yarnpkg-stat-mode-0.3.0.tgz
https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz -> yarnpkg-static-extend-0.1.2.tgz
https://registry.yarnpkg.com/statuses/-/statuses-2.0.1.tgz -> yarnpkg-statuses-2.0.1.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz -> yarnpkg-statuses-1.5.0.tgz
https://registry.yarnpkg.com/stealthy-require/-/stealthy-require-1.1.1.tgz -> yarnpkg-stealthy-require-1.1.1.tgz
https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.2.tgz -> yarnpkg-stream-browserify-2.0.2.tgz
https://registry.yarnpkg.com/stream-each/-/stream-each-1.2.3.tgz -> yarnpkg-stream-each-1.2.3.tgz
https://registry.yarnpkg.com/stream-http/-/stream-http-2.8.3.tgz -> yarnpkg-stream-http-2.8.3.tgz
https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.1.tgz -> yarnpkg-stream-shift-1.0.1.tgz
https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-1.1.0.tgz -> yarnpkg-strict-uri-encode-1.1.0.tgz
https://registry.yarnpkg.com/string-length/-/string-length-2.0.0.tgz -> yarnpkg-string-length-2.0.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz -> yarnpkg-string-width-2.1.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-3.1.0.tgz -> yarnpkg-string-width-3.1.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string.prototype.padend/-/string.prototype.padend-3.1.4.tgz -> yarnpkg-string.prototype.padend-3.1.4.tgz
https://registry.yarnpkg.com/string.prototype.padstart/-/string.prototype.padstart-3.1.4.tgz -> yarnpkg-string.prototype.padstart-3.1.4.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz -> yarnpkg-string_decoder-0.10.31.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz -> yarnpkg-strip-ansi-4.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz -> yarnpkg-strip-ansi-5.2.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz -> yarnpkg-strip-bom-2.0.0.tgz
https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz -> yarnpkg-strip-eof-1.0.0.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-2.0.0.tgz -> yarnpkg-strip-indent-2.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/strtok3/-/strtok3-6.3.0.tgz -> yarnpkg-strtok3-6.3.0.tgz
https://registry.yarnpkg.com/stylehacks/-/stylehacks-4.0.3.tgz -> yarnpkg-stylehacks-4.0.3.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-2.0.2.tgz -> yarnpkg-sumchecker-2.0.2.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz -> yarnpkg-supports-color-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-3.2.3.tgz -> yarnpkg-supports-color-3.2.3.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-6.1.0.tgz -> yarnpkg-supports-color-6.1.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.0.1.tgz -> yarnpkg-supports-color-5.0.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/svg-tags/-/svg-tags-1.0.0.tgz -> yarnpkg-svg-tags-1.0.0.tgz
https://registry.yarnpkg.com/svg2png/-/svg2png-4.1.1.tgz -> yarnpkg-svg2png-4.1.1.tgz
https://registry.yarnpkg.com/svgo/-/svgo-1.3.2.tgz -> yarnpkg-svgo-1.3.2.tgz
https://registry.yarnpkg.com/symbol-tree/-/symbol-tree-3.2.4.tgz -> yarnpkg-symbol-tree-3.2.4.tgz
https://registry.yarnpkg.com/table/-/table-4.0.2.tgz -> yarnpkg-table-4.0.2.tgz
https://registry.yarnpkg.com/table/-/table-5.4.6.tgz -> yarnpkg-table-5.4.6.tgz
https://registry.yarnpkg.com/tapable/-/tapable-1.1.3.tgz -> yarnpkg-tapable-1.1.3.tgz
https://registry.yarnpkg.com/tar-fs/-/tar-fs-2.1.1.tgz -> yarnpkg-tar-fs-2.1.1.tgz
https://registry.yarnpkg.com/tar-stream/-/tar-stream-1.6.2.tgz -> yarnpkg-tar-stream-1.6.2.tgz
https://registry.yarnpkg.com/tar-stream/-/tar-stream-2.2.0.tgz -> yarnpkg-tar-stream-2.2.0.tgz
https://registry.yarnpkg.com/temp-file/-/temp-file-3.4.0.tgz -> yarnpkg-temp-file-3.4.0.tgz
https://registry.yarnpkg.com/term-size/-/term-size-1.2.0.tgz -> yarnpkg-term-size-1.2.0.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-1.4.5.tgz -> yarnpkg-terser-webpack-plugin-1.4.5.tgz
https://registry.yarnpkg.com/terser/-/terser-4.8.1.tgz -> yarnpkg-terser-4.8.1.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-4.2.3.tgz -> yarnpkg-test-exclude-4.2.3.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/thenify-all/-/thenify-all-1.6.0.tgz -> yarnpkg-thenify-all-1.6.0.tgz
https://registry.yarnpkg.com/thenify/-/thenify-3.3.1.tgz -> yarnpkg-thenify-3.3.1.tgz
https://registry.yarnpkg.com/thread-loader/-/thread-loader-2.1.3.tgz -> yarnpkg-thread-loader-2.1.3.tgz
https://github.com/nicolaspanel/three-orbitcontrols-ts/archive/b5b2685a88b880822c62275f2a76bdaa3954f76c.tar.gz -> yarnpkg-three-orbitcontrols-ts.git-b5b2685a88b880822c62275f2a76bdaa3954f76c.tgz
https://registry.yarnpkg.com/three/-/three-0.151.3.tgz -> yarnpkg-three-0.151.3.tgz
https://registry.yarnpkg.com/three/-/three-0.118.3.tgz -> yarnpkg-three-0.118.3.tgz
https://registry.yarnpkg.com/three/-/three-0.94.0.tgz -> yarnpkg-three-0.94.0.tgz
https://registry.yarnpkg.com/throat/-/throat-4.1.0.tgz -> yarnpkg-throat-4.1.0.tgz
https://registry.yarnpkg.com/throttleit/-/throttleit-0.0.2.tgz -> yarnpkg-throttleit-0.0.2.tgz
https://registry.yarnpkg.com/throttleit/-/throttleit-1.0.0.tgz -> yarnpkg-throttleit-1.0.0.tgz
https://registry.yarnpkg.com/through2-filter/-/through2-filter-3.0.0.tgz -> yarnpkg-through2-filter-3.0.0.tgz
https://registry.yarnpkg.com/through2-map/-/through2-map-3.0.0.tgz -> yarnpkg-through2-map-3.0.0.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/through2/-/through2-0.2.3.tgz -> yarnpkg-through2-0.2.3.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/thunky/-/thunky-1.1.0.tgz -> yarnpkg-thunky-1.1.0.tgz
https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-2.0.12.tgz -> yarnpkg-timers-browserify-2.0.12.tgz
https://registry.yarnpkg.com/timm/-/timm-1.7.1.tgz -> yarnpkg-timm-1.7.1.tgz
https://registry.yarnpkg.com/timsort/-/timsort-0.3.0.tgz -> yarnpkg-timsort-0.3.0.tgz
https://registry.yarnpkg.com/tiny-invariant/-/tiny-invariant-1.3.1.tgz -> yarnpkg-tiny-invariant-1.3.1.tgz
https://registry.yarnpkg.com/tiny-warning/-/tiny-warning-1.0.3.tgz -> yarnpkg-tiny-warning-1.0.3.tgz
https://registry.yarnpkg.com/tinycolor2/-/tinycolor2-1.6.0.tgz -> yarnpkg-tinycolor2-1.6.0.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/tmpl/-/tmpl-1.0.5.tgz -> yarnpkg-tmpl-1.0.5.tgz
https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> yarnpkg-to-arraybuffer-1.0.1.tgz
https://registry.yarnpkg.com/to-buffer/-/to-buffer-1.1.1.tgz -> yarnpkg-to-buffer-1.1.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> yarnpkg-to-fast-properties-1.0.3.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz -> yarnpkg-to-object-path-0.3.0.tgz
https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> yarnpkg-to-readable-stream-1.0.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz -> yarnpkg-to-regex-range-2.1.1.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz -> yarnpkg-to-regex-3.0.2.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.1.tgz -> yarnpkg-toidentifier-1.0.1.tgz
https://registry.yarnpkg.com/token-types/-/token-types-4.2.1.tgz -> yarnpkg-token-types-4.2.1.tgz
https://registry.yarnpkg.com/toposort/-/toposort-1.0.7.tgz -> yarnpkg-toposort-1.0.7.tgz
https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.5.0.tgz -> yarnpkg-tough-cookie-2.5.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-1.0.1.tgz -> yarnpkg-tr46-1.0.1.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/trim-right/-/trim-right-1.0.1.tgz -> yarnpkg-trim-right-1.0.1.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/tryer/-/tryer-1.0.1.tgz -> yarnpkg-tryer-1.0.1.tgz
https://registry.yarnpkg.com/ts-jest/-/ts-jest-23.10.5.tgz -> yarnpkg-ts-jest-23.10.5.tgz
https://registry.yarnpkg.com/ts-loader/-/ts-loader-5.4.5.tgz -> yarnpkg-ts-loader-5.4.5.tgz
https://registry.yarnpkg.com/tsconfig/-/tsconfig-7.0.0.tgz -> yarnpkg-tsconfig-7.0.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.5.0.tgz -> yarnpkg-tslib-2.5.0.tgz
https://registry.yarnpkg.com/tslint/-/tslint-5.20.1.tgz -> yarnpkg-tslint-5.20.1.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-2.29.0.tgz -> yarnpkg-tsutils-2.29.0.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.0.tgz -> yarnpkg-tty-browserify-0.0.0.tgz
https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> yarnpkg-tunnel-agent-0.6.0.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz -> yarnpkg-tweetnacl-0.14.5.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz -> yarnpkg-type-check-0.3.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.3.1.tgz -> yarnpkg-type-fest-0.3.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.6.0.tgz -> yarnpkg-type-fest-0.6.0.tgz
https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz -> yarnpkg-type-is-1.6.18.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> yarnpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/typeface-open-sans/-/typeface-open-sans-0.0.75.tgz -> yarnpkg-typeface-open-sans-0.0.75.tgz
https://registry.yarnpkg.com/typescript/-/typescript-3.9.10.tgz -> yarnpkg-typescript-3.9.10.tgz
https://registry.yarnpkg.com/uglify-js/-/uglify-js-3.4.10.tgz -> yarnpkg-uglify-js-3.4.10.tgz
https://registry.yarnpkg.com/uglify-js/-/uglify-js-3.17.4.tgz -> yarnpkg-uglify-js-3.17.4.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> yarnpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> yarnpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> yarnpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> yarnpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz -> yarnpkg-union-value-1.0.1.tgz
https://registry.yarnpkg.com/uniq/-/uniq-1.0.1.tgz -> yarnpkg-uniq-1.0.1.tgz
https://registry.yarnpkg.com/uniqs/-/uniqs-2.0.0.tgz -> yarnpkg-uniqs-2.0.0.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.1.tgz -> yarnpkg-unique-filename-1.1.1.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.2.tgz -> yarnpkg-unique-slug-2.0.2.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-1.0.0.tgz -> yarnpkg-unique-string-1.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/unquote/-/unquote-1.1.1.tgz -> yarnpkg-unquote-1.1.1.tgz
https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz -> yarnpkg-unset-value-1.0.0.tgz
https://registry.yarnpkg.com/unzip-crx-3/-/unzip-crx-3-0.2.0.tgz -> yarnpkg-unzip-crx-3-0.2.0.tgz
https://registry.yarnpkg.com/unzip-crx/-/unzip-crx-0.2.0.tgz -> yarnpkg-unzip-crx-0.2.0.tgz
https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz -> yarnpkg-upath-1.2.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.10.tgz -> yarnpkg-update-browserslist-db-1.0.10.tgz
https://registry.yarnpkg.com/update-notifier/-/update-notifier-3.0.1.tgz -> yarnpkg-update-notifier-3.0.1.tgz
https://registry.yarnpkg.com/upng-js/-/upng-js-2.1.0.tgz -> yarnpkg-upng-js-2.1.0.tgz
https://registry.yarnpkg.com/upper-case/-/upper-case-1.1.3.tgz -> yarnpkg-upper-case-1.1.3.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz -> yarnpkg-urix-0.1.0.tgz
https://registry.yarnpkg.com/url-loader/-/url-loader-1.1.2.tgz -> yarnpkg-url-loader-1.1.2.tgz
https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> yarnpkg-url-parse-lax-3.0.0.tgz
https://registry.yarnpkg.com/url-parse/-/url-parse-1.5.10.tgz -> yarnpkg-url-parse-1.5.10.tgz
https://registry.yarnpkg.com/url/-/url-0.11.0.tgz -> yarnpkg-url-0.11.0.tgz
https://registry.yarnpkg.com/use/-/use-3.1.1.tgz -> yarnpkg-use-3.1.1.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> yarnpkg-utf8-byte-length-1.0.4.tgz
https://registry.yarnpkg.com/utif/-/utif-2.0.1.tgz -> yarnpkg-utif-2.0.1.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/util.promisify/-/util.promisify-1.0.0.tgz -> yarnpkg-util.promisify-1.0.0.tgz
https://registry.yarnpkg.com/util.promisify/-/util.promisify-1.1.1.tgz -> yarnpkg-util.promisify-1.1.1.tgz
https://registry.yarnpkg.com/util.promisify/-/util.promisify-1.0.1.tgz -> yarnpkg-util.promisify-1.0.1.tgz
https://registry.yarnpkg.com/util/-/util-0.10.3.tgz -> yarnpkg-util-0.10.3.tgz
https://registry.yarnpkg.com/util/-/util-0.11.1.tgz -> yarnpkg-util-0.11.1.tgz
https://registry.yarnpkg.com/utila/-/utila-0.4.0.tgz -> yarnpkg-utila-0.4.0.tgz
https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz -> yarnpkg-utils-merge-1.0.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz -> yarnpkg-uuid-3.4.0.tgz
https://registry.yarnpkg.com/uuid/-/uuid-8.3.2.tgz -> yarnpkg-uuid-8.3.2.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/value-equal/-/value-equal-1.0.1.tgz -> yarnpkg-value-equal-1.0.1.tgz
https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz -> yarnpkg-vary-1.1.2.tgz
https://registry.yarnpkg.com/vendors/-/vendors-1.0.4.tgz -> yarnpkg-vendors-1.0.4.tgz
https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz -> yarnpkg-verror-1.10.0.tgz
https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-1.1.2.tgz -> yarnpkg-vm-browserify-1.1.2.tgz
https://registry.yarnpkg.com/vue-class-component/-/vue-class-component-6.3.2.tgz -> yarnpkg-vue-class-component-6.3.2.tgz
https://registry.yarnpkg.com/vue-class-component/-/vue-class-component-7.2.6.tgz -> yarnpkg-vue-class-component-7.2.6.tgz
https://registry.yarnpkg.com/vue-cli-plugin-electron-builder/-/vue-cli-plugin-electron-builder-1.4.6.tgz -> yarnpkg-vue-cli-plugin-electron-builder-1.4.6.tgz
https://registry.yarnpkg.com/vue-color/-/vue-color-2.8.1.tgz -> yarnpkg-vue-color-2.8.1.tgz
https://registry.yarnpkg.com/vue-eslint-parser/-/vue-eslint-parser-2.0.3.tgz -> yarnpkg-vue-eslint-parser-2.0.3.tgz
https://registry.yarnpkg.com/vue-eslint-parser/-/vue-eslint-parser-5.0.0.tgz -> yarnpkg-vue-eslint-parser-5.0.0.tgz
https://registry.yarnpkg.com/vue-final-modal/-/vue-final-modal-2.4.3.tgz -> yarnpkg-vue-final-modal-2.4.3.tgz
https://registry.yarnpkg.com/vue-golden-layout/-/vue-golden-layout-1.6.0.tgz -> yarnpkg-vue-golden-layout-1.6.0.tgz
https://registry.yarnpkg.com/vue-hot-reload-api/-/vue-hot-reload-api-2.3.4.tgz -> yarnpkg-vue-hot-reload-api-2.3.4.tgz
https://registry.yarnpkg.com/vue-jest/-/vue-jest-3.0.7.tgz -> yarnpkg-vue-jest-3.0.7.tgz
https://registry.yarnpkg.com/vue-loader/-/vue-loader-15.10.1.tgz -> yarnpkg-vue-loader-15.10.1.tgz
https://registry.yarnpkg.com/vue-property-decorator/-/vue-property-decorator-8.5.1.tgz -> yarnpkg-vue-property-decorator-8.5.1.tgz
https://registry.yarnpkg.com/vue-resize-directive/-/vue-resize-directive-1.2.0.tgz -> yarnpkg-vue-resize-directive-1.2.0.tgz
https://registry.yarnpkg.com/vue-router/-/vue-router-3.3.4.tgz -> yarnpkg-vue-router-3.3.4.tgz
https://registry.yarnpkg.com/vue-storage-decorator/-/vue-storage-decorator-1.0.7.tgz -> yarnpkg-vue-storage-decorator-1.0.7.tgz
https://registry.yarnpkg.com/vue-style-loader/-/vue-style-loader-4.1.3.tgz -> yarnpkg-vue-style-loader-4.1.3.tgz
https://registry.yarnpkg.com/vue-template-compiler/-/vue-template-compiler-2.6.14.tgz -> yarnpkg-vue-template-compiler-2.6.14.tgz
https://registry.yarnpkg.com/vue-template-es2015-compiler/-/vue-template-es2015-compiler-1.9.1.tgz -> yarnpkg-vue-template-es2015-compiler-1.9.1.tgz
https://registry.yarnpkg.com/vue-toast-notification/-/vue-toast-notification-0.6.2.tgz -> yarnpkg-vue-toast-notification-0.6.2.tgz
https://registry.yarnpkg.com/vue/-/vue-2.6.14.tgz -> yarnpkg-vue-2.6.14.tgz
https://registry.yarnpkg.com/vuex/-/vuex-3.6.2.tgz -> yarnpkg-vuex-3.6.2.tgz
https://registry.yarnpkg.com/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> yarnpkg-w3c-hr-time-1.0.2.tgz
https://registry.yarnpkg.com/walker/-/walker-1.0.8.tgz -> yarnpkg-walker-1.0.8.tgz
https://registry.yarnpkg.com/warning/-/warning-4.0.3.tgz -> yarnpkg-warning-4.0.3.tgz
https://registry.yarnpkg.com/watch/-/watch-0.18.0.tgz -> yarnpkg-watch-0.18.0.tgz
https://registry.yarnpkg.com/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> yarnpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-1.7.5.tgz -> yarnpkg-watchpack-1.7.5.tgz
https://registry.yarnpkg.com/wbuf/-/wbuf-1.7.3.tgz -> yarnpkg-wbuf-1.7.3.tgz
https://registry.yarnpkg.com/wcwidth/-/wcwidth-1.0.1.tgz -> yarnpkg-wcwidth-1.0.1.tgz
https://registry.yarnpkg.com/wdio-dot-reporter/-/wdio-dot-reporter-0.0.10.tgz -> yarnpkg-wdio-dot-reporter-0.0.10.tgz
https://registry.yarnpkg.com/webdriverio/-/webdriverio-4.14.4.tgz -> yarnpkg-webdriverio-4.14.4.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> yarnpkg-webidl-conversions-4.0.2.tgz
https://registry.yarnpkg.com/webpack-bundle-analyzer/-/webpack-bundle-analyzer-3.9.0.tgz -> yarnpkg-webpack-bundle-analyzer-3.9.0.tgz
https://registry.yarnpkg.com/webpack-chain/-/webpack-chain-4.12.1.tgz -> yarnpkg-webpack-chain-4.12.1.tgz
https://registry.yarnpkg.com/webpack-chain/-/webpack-chain-5.2.4.tgz -> yarnpkg-webpack-chain-5.2.4.tgz
https://registry.yarnpkg.com/webpack-dev-middleware/-/webpack-dev-middleware-3.7.3.tgz -> yarnpkg-webpack-dev-middleware-3.7.3.tgz
https://registry.yarnpkg.com/webpack-dev-server/-/webpack-dev-server-3.11.3.tgz -> yarnpkg-webpack-dev-server-3.11.3.tgz
https://registry.yarnpkg.com/webpack-log/-/webpack-log-2.0.0.tgz -> yarnpkg-webpack-log-2.0.0.tgz
https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-4.2.2.tgz -> yarnpkg-webpack-merge-4.2.2.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-1.4.3.tgz -> yarnpkg-webpack-sources-1.4.3.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-3.2.3.tgz -> yarnpkg-webpack-sources-3.2.3.tgz
https://registry.yarnpkg.com/webpack/-/webpack-4.46.0.tgz -> yarnpkg-webpack-4.46.0.tgz
https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.7.4.tgz -> yarnpkg-websocket-driver-0.7.4.tgz
https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> yarnpkg-websocket-extensions-0.1.4.tgz
https://registry.yarnpkg.com/wgxpath/-/wgxpath-1.0.0.tgz -> yarnpkg-wgxpath-1.0.0.tgz
https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> yarnpkg-whatwg-encoding-1.0.5.tgz
https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> yarnpkg-whatwg-mimetype-2.3.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-6.5.0.tgz -> yarnpkg-whatwg-url-6.5.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-7.1.0.tgz -> yarnpkg-whatwg-url-7.1.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-module/-/which-module-1.0.0.tgz -> yarnpkg-which-module-1.0.0.tgz
https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz -> yarnpkg-which-module-2.0.0.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/widest-line/-/widest-line-2.0.1.tgz -> yarnpkg-widest-line-2.0.1.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/wordwrap/-/wordwrap-1.0.0.tgz -> yarnpkg-wordwrap-1.0.0.tgz
https://registry.yarnpkg.com/wordwrap/-/wordwrap-0.0.3.tgz -> yarnpkg-wordwrap-0.0.3.tgz
https://registry.yarnpkg.com/worker-farm/-/worker-farm-1.7.0.tgz -> yarnpkg-worker-farm-1.7.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> yarnpkg-wrap-ansi-2.1.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> yarnpkg-wrap-ansi-5.1.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> yarnpkg-write-file-atomic-2.4.3.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> yarnpkg-write-file-atomic-3.0.3.tgz
https://registry.yarnpkg.com/write/-/write-1.0.3.tgz -> yarnpkg-write-1.0.3.tgz
https://registry.yarnpkg.com/write/-/write-0.2.1.tgz -> yarnpkg-write-0.2.1.tgz
https://registry.yarnpkg.com/ws/-/ws-5.2.3.tgz -> yarnpkg-ws-5.2.3.tgz
https://registry.yarnpkg.com/ws/-/ws-6.2.2.tgz -> yarnpkg-ws-6.2.2.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-3.0.0.tgz -> yarnpkg-xdg-basedir-3.0.0.tgz
https://registry.yarnpkg.com/xhr/-/xhr-2.6.0.tgz -> yarnpkg-xhr-2.6.0.tgz
https://registry.yarnpkg.com/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> yarnpkg-xml-name-validator-3.0.0.tgz
https://registry.yarnpkg.com/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> yarnpkg-xml-parse-from-string-1.0.1.tgz
https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.23.tgz -> yarnpkg-xml2js-0.4.23.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> yarnpkg-xmlbuilder-11.0.1.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz -> yarnpkg-xtend-4.0.2.tgz
https://registry.yarnpkg.com/xtend/-/xtend-2.1.2.tgz -> yarnpkg-xtend-2.1.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-3.2.2.tgz -> yarnpkg-y18n-3.2.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-4.0.3.tgz -> yarnpkg-y18n-4.0.3.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yaku/-/yaku-0.16.7.tgz -> yarnpkg-yaku-0.16.7.tgz
https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz -> yarnpkg-yallist-2.1.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz -> yarnpkg-yallist-3.1.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-10.1.0.tgz -> yarnpkg-yargs-parser-10.1.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-13.1.2.tgz -> yarnpkg-yargs-parser-13.1.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-15.0.3.tgz -> yarnpkg-yargs-parser-15.0.3.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-4.2.1.tgz -> yarnpkg-yargs-parser-4.2.1.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-9.0.2.tgz -> yarnpkg-yargs-parser-9.0.2.tgz
https://registry.yarnpkg.com/yargs/-/yargs-11.1.1.tgz -> yarnpkg-yargs-11.1.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-13.3.2.tgz -> yarnpkg-yargs-13.3.2.tgz
https://registry.yarnpkg.com/yargs/-/yargs-14.2.3.tgz -> yarnpkg-yargs-14.2.3.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-6.6.0.tgz -> yarnpkg-yargs-6.6.0.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
https://registry.yarnpkg.com/yorkie/-/yorkie-2.0.0.tgz -> yarnpkg-yorkie-2.0.0.tgz
https://registry.yarnpkg.com/zip-stream/-/zip-stream-1.2.0.tgz -> yarnpkg-zip-stream-1.2.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
PHANTOMJS_PV="2.1.1"
SENTRY_CLI_PV="1.75.0"
SHARP_PV=""
VIPS_PV="8.11.3"
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
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

vrun() {
einfo "Running:\t${@}"
	"${@}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

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

	check_network_sandbox
	yarn_pkg_setup
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
		#vrun yarn add "node-gyp@9.3.1"
	fi
}

src_unpack() {
        if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
                unpack ${P}.tar.gz
                cd "${S}" || die
                rm package-lock.json
		rm yarn.lock
                npm i --legacy-peer-deps || die
                npm audit fix || die
                yarn import || die

	# Fix the following upgrade breakage manually:

	# Change to ^2.6.10 afterwards.
		yarn upgrade "vue@2.6.x" || die

	# change to ^2.6.10 afterwards.
		yarn upgrade "vue-template-compiler@2.6.x" || die

	# Change to ^3.0.3 afterwards.
		yarn upgrade "vue-router@3.3.x" || die

	# Change to ^0.6.2 afterwards.
		yarn upgrade "vue-toast-notification@0.6.2" || die

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
		yarn_src_unpack
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
	electron-app_cp_electron
	vrun yarn electron:build --publish=never
}

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist_electron/linux-unpacked/"*
	fperms 0755 "${YARN_INSTALL_PATH}/texturelab"
	electron-app_gen_wrapper \
		"${PN}" \
		"${YARN_INSTALL_PATH}/${PN}"
	newicon "src/assets/logo.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Graphics;2DGraphics"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
