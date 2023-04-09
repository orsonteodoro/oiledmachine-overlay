# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

export YARN_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}_${PV}.AppImage"
ELECTRON_APP_ELECTRON_PV="22.3.5"
ELECTRON_APP_MODE="npm"
NODE_VERSION=16
NODE_ENV=development
inherit desktop electron-app lcnr yarn

DESCRIPTION="Blockbench - A boxy 3D model editor"
HOMEPAGE="https://www.blockbench.net"
THIRD_PARTY_LICENSES="
	|| ( BSD AFL-2.1 )
	( MIT all-rights-reserved )
	Apache-2.0
	0BSD
	BSD
	BSD-2
	CC-BY-4.0
	ISC
	MIT
	CC0-1.0
" # ^^ (mutual exclusion) is not supported. \
# || assumes that user chooses outside of computer.
LICENSE="
	GPL-3+
	( ${ELECTRON_APP_LICENSES} Artistic-2 )
	${THIRD_PARTY_LICENSES}
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
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/blockbench-4.6.5/work/blockbench-4.6.5/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.1.1.tgz -> yarnpkg-7zip-bin-5.1.1.tgz
https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.1.tgz -> yarnpkg-@ampproject-remapping-2.2.1.tgz
https://registry.yarnpkg.com/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> yarnpkg-@apideck-better-ajv-errors-0.3.6.tgz
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
https://registry.yarnpkg.com/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.18.6.tgz -> yarnpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.20.7.tgz -> yarnpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz -> yarnpkg-@babel-plugin-proposal-async-generator-functions-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-class-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-class-static-block/-/plugin-proposal-class-static-block-7.21.0.tgz -> yarnpkg-@babel-plugin-proposal-class-static-block-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-dynamic-import/-/plugin-proposal-dynamic-import-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-dynamic-import-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-export-namespace-from/-/plugin-proposal-export-namespace-from-7.18.9.tgz -> yarnpkg-@babel-plugin-proposal-export-namespace-from-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-json-strings-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-logical-assignment-operators/-/plugin-proposal-logical-assignment-operators-7.20.7.tgz -> yarnpkg-@babel-plugin-proposal-logical-assignment-operators-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-nullish-coalescing-operator/-/plugin-proposal-nullish-coalescing-operator-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-nullish-coalescing-operator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-numeric-separator/-/plugin-proposal-numeric-separator-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-numeric-separator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz -> yarnpkg-@babel-plugin-proposal-object-rest-spread-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-optional-catch-binding-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.21.0.tgz -> yarnpkg-@babel-plugin-proposal-optional-chaining-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-private-methods/-/plugin-proposal-private-methods-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-private-methods-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0.tgz -> yarnpkg-@babel-plugin-proposal-private-property-in-object-7.21.0.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> yarnpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> yarnpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.20.0.tgz -> yarnpkg-@babel-plugin-syntax-import-assertions-7.20.0.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
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
https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-member-expression-literals-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.20.11.tgz -> yarnpkg-@babel-plugin-transform-modules-amd-7.20.11.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.21.2.tgz -> yarnpkg-@babel-plugin-transform-modules-commonjs-7.21.2.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.20.11.tgz -> yarnpkg-@babel-plugin-transform-modules-systemjs-7.20.11.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-modules-umd-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.20.5.tgz -> yarnpkg-@babel-plugin-transform-named-capturing-groups-regex-7.20.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-new-target-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-object-super-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.21.3.tgz -> yarnpkg-@babel-plugin-transform-parameters-7.21.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-property-literals-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.20.5.tgz -> yarnpkg-@babel-plugin-transform-regenerator-7.20.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-reserved-words-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-shorthand-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.20.7.tgz -> yarnpkg-@babel-plugin-transform-spread-7.20.7.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-sticky-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-template-literals-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-typeof-symbol-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.18.10.tgz -> yarnpkg-@babel-plugin-transform-unicode-escapes-7.18.10.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-unicode-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.21.4.tgz -> yarnpkg-@babel-preset-env-7.21.4.tgz
https://registry.yarnpkg.com/@babel/preset-modules/-/preset-modules-0.1.5.tgz -> yarnpkg-@babel-preset-modules-0.1.5.tgz
https://registry.yarnpkg.com/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> yarnpkg-@babel-regjsgen-0.8.0.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.21.0.tgz -> yarnpkg-@babel-runtime-7.21.0.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.20.7.tgz -> yarnpkg-@babel-template-7.20.7.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.21.4.tgz -> yarnpkg-@babel-traverse-7.21.4.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.21.4.tgz -> yarnpkg-@babel-types-7.21.4.tgz
https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> yarnpkg-@develar-schema-utils-2.6.5.tgz
https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> yarnpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.yarnpkg.com/@electron/get/-/get-2.0.2.tgz -> yarnpkg-@electron-get-2.0.2.tgz
https://registry.yarnpkg.com/@electron/remote/-/remote-2.0.9.tgz -> yarnpkg-@electron-remote-2.0.9.tgz
https://registry.yarnpkg.com/@electron/universal/-/universal-1.2.1.tgz -> yarnpkg-@electron-universal-1.2.1.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> yarnpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz -> yarnpkg-@jridgewell-resolve-uri-3.1.0.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz -> yarnpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/source-map/-/source-map-0.3.3.tgz -> yarnpkg-@jridgewell-source-map-0.3.3.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.18.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.18.tgz
https://registry.yarnpkg.com/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> yarnpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.yarnpkg.com/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> yarnpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.yarnpkg.com/@rollup/plugin-babel/-/plugin-babel-5.3.1.tgz -> yarnpkg-@rollup-plugin-babel-5.3.1.tgz
https://registry.yarnpkg.com/@rollup/plugin-node-resolve/-/plugin-node-resolve-11.2.1.tgz -> yarnpkg-@rollup-plugin-node-resolve-11.2.1.tgz
https://registry.yarnpkg.com/@rollup/plugin-replace/-/plugin-replace-2.4.2.tgz -> yarnpkg-@rollup-plugin-replace-2.4.2.tgz
https://registry.yarnpkg.com/@rollup/pluginutils/-/pluginutils-3.1.0.tgz -> yarnpkg-@rollup-pluginutils-3.1.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-4.6.0.tgz -> yarnpkg-@sindresorhus-is-4.6.0.tgz
https://registry.yarnpkg.com/@surma/rollup-plugin-off-main-thread/-/rollup-plugin-off-main-thread-2.2.3.tgz -> yarnpkg-@surma-rollup-plugin-off-main-thread-2.2.3.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> yarnpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-2.0.0.tgz -> yarnpkg-@tootallnate-once-2.0.0.tgz
https://registry.yarnpkg.com/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> yarnpkg-@types-cacheable-request-6.0.3.tgz
https://registry.yarnpkg.com/@types/debug/-/debug-4.1.7.tgz -> yarnpkg-@types-debug-4.1.7.tgz
https://registry.yarnpkg.com/@types/eslint-scope/-/eslint-scope-3.7.4.tgz -> yarnpkg-@types-eslint-scope-3.7.4.tgz
https://registry.yarnpkg.com/@types/eslint/-/eslint-8.37.0.tgz -> yarnpkg-@types-eslint-8.37.0.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.0.tgz -> yarnpkg-@types-estree-1.0.0.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-0.0.39.tgz -> yarnpkg-@types-estree-0.0.39.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-0.0.51.tgz -> yarnpkg-@types-estree-0.0.51.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz -> yarnpkg-@types-fs-extra-9.0.13.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz -> yarnpkg-@types-glob-7.2.0.tgz
https://registry.yarnpkg.com/@types/http-cache-semantics/-/http-cache-semantics-4.0.1.tgz -> yarnpkg-@types-http-cache-semantics-4.0.1.tgz
https://registry.yarnpkg.com/@types/jquery/-/jquery-3.5.16.tgz -> yarnpkg-@types-jquery-3.5.16.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/keyv/-/keyv-3.1.4.tgz -> yarnpkg-@types-keyv-3.1.4.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz -> yarnpkg-@types-ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.15.11.tgz -> yarnpkg-@types-node-18.15.11.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.18.23.tgz -> yarnpkg-@types-node-16.18.23.tgz
https://registry.yarnpkg.com/@types/plist/-/plist-3.0.2.tgz -> yarnpkg-@types-plist-3.0.2.tgz
https://registry.yarnpkg.com/@types/resolve/-/resolve-1.17.1.tgz -> yarnpkg-@types-resolve-1.17.1.tgz
https://registry.yarnpkg.com/@types/responselike/-/responselike-1.0.0.tgz -> yarnpkg-@types-responselike-1.0.0.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.3.13.tgz -> yarnpkg-@types-semver-7.3.13.tgz
https://registry.yarnpkg.com/@types/sizzle/-/sizzle-2.3.3.tgz -> yarnpkg-@types-sizzle-2.3.3.tgz
https://registry.yarnpkg.com/@types/tinycolor2/-/tinycolor2-1.4.3.tgz -> yarnpkg-@types-tinycolor2-1.4.3.tgz
https://registry.yarnpkg.com/@types/trusted-types/-/trusted-types-2.0.3.tgz -> yarnpkg-@types-trusted-types-2.0.3.tgz
https://registry.yarnpkg.com/@types/verror/-/verror-1.10.6.tgz -> yarnpkg-@types-verror-1.10.6.tgz
https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-21.0.0.tgz -> yarnpkg-@types-yargs-parser-21.0.0.tgz
https://registry.yarnpkg.com/@types/yargs/-/yargs-17.0.24.tgz -> yarnpkg-@types-yargs-17.0.24.tgz
https://registry.yarnpkg.com/@types/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-@types-yauzl-2.10.0.tgz
https://registry.yarnpkg.com/@vue/compiler-sfc/-/compiler-sfc-2.7.14.tgz -> yarnpkg-@vue-compiler-sfc-2.7.14.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.11.1.tgz -> yarnpkg-@webassemblyjs-ast-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.1.tgz -> yarnpkg-@webassemblyjs-floating-point-hex-parser-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-api-error-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-buffer-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-numbers-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-wasm-bytecode-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-wasm-section-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.11.1.tgz -> yarnpkg-@webassemblyjs-ieee754-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.11.1.tgz -> yarnpkg-@webassemblyjs-leb128-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.11.1.tgz -> yarnpkg-@webassemblyjs-utf8-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-edit-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-gen-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-opt-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-parser-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.11.1.tgz -> yarnpkg-@webassemblyjs-wast-printer-1.11.1.tgz
https://registry.yarnpkg.com/@webpack-cli/configtest/-/configtest-1.2.0.tgz -> yarnpkg-@webpack-cli-configtest-1.2.0.tgz
https://registry.yarnpkg.com/@webpack-cli/info/-/info-1.5.0.tgz -> yarnpkg-@webpack-cli-info-1.5.0.tgz
https://registry.yarnpkg.com/@webpack-cli/serve/-/serve-1.7.0.tgz -> yarnpkg-@webpack-cli-serve-1.7.0.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> yarnpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> yarnpkg-@xtuc-long-4.2.2.tgz
https://registry.yarnpkg.com/acorn-import-assertions/-/acorn-import-assertions-1.8.0.tgz -> yarnpkg-acorn-import-assertions-1.8.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.8.2.tgz -> yarnpkg-acorn-8.8.2.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.12.0.tgz -> yarnpkg-ajv-8.12.0.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> yarnpkg-app-builder-bin-4.0.0.tgz
https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-23.6.0.tgz -> yarnpkg-app-builder-lib-23.6.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/asar/-/asar-3.2.0.tgz -> yarnpkg-asar-3.2.0.tgz
https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz -> yarnpkg-assert-plus-1.0.0.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> yarnpkg-async-exit-hook-2.0.1.tgz
https://registry.yarnpkg.com/async/-/async-3.2.4.tgz -> yarnpkg-async-3.2.4.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.3.tgz -> yarnpkg-babel-plugin-polyfill-corejs2-0.3.3.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.6.0.tgz -> yarnpkg-babel-plugin-polyfill-corejs3-0.6.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.4.1.tgz -> yarnpkg-babel-plugin-polyfill-regenerator-0.4.1.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/blockbench-types/-/blockbench-types-4.6.1.tgz -> yarnpkg-blockbench-types-4.6.1.tgz
https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> yarnpkg-bluebird-lst-1.0.9.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz -> yarnpkg-boolean-3.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.21.5.tgz -> yarnpkg-browserslist-4.21.5.tgz
https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> yarnpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> yarnpkg-buffer-alloc-1.2.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-1.0.0.tgz -> yarnpkg-buffer-equal-1.0.0.tgz
https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz -> yarnpkg-buffer-fill-1.0.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz -> yarnpkg-buffer-5.7.1.tgz
https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-9.1.1.tgz -> yarnpkg-builder-util-runtime-9.1.1.tgz
https://registry.yarnpkg.com/builder-util/-/builder-util-23.6.0.tgz -> yarnpkg-builder-util-23.6.0.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-3.3.0.tgz -> yarnpkg-builtin-modules-3.3.0.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> yarnpkg-cacheable-lookup-5.0.4.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-7.0.2.tgz -> yarnpkg-cacheable-request-7.0.2.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001476.tgz -> yarnpkg-caniuse-lite-1.0.30001476.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz -> yarnpkg-chownr-2.0.0.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> yarnpkg-chrome-trace-event-1.0.3.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> yarnpkg-chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-3.8.0.tgz -> yarnpkg-ci-info-3.8.0.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz -> yarnpkg-cli-truncate-2.1.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-8.0.1.tgz -> yarnpkg-cliui-8.0.1.tgz
https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz -> yarnpkg-clone-deep-4.0.1.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz -> yarnpkg-clone-response-1.0.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/colorette/-/colorette-2.0.19.tgz -> yarnpkg-colorette-2.0.19.tgz
https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz -> yarnpkg-colors-1.0.3.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.9.0.tgz -> yarnpkg-commander-2.9.0.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-5.1.0.tgz -> yarnpkg-commander-5.1.0.tgz
https://registry.yarnpkg.com/commander/-/commander-7.2.0.tgz -> yarnpkg-commander-7.2.0.tgz
https://registry.yarnpkg.com/common-tags/-/common-tags-1.8.2.tgz -> yarnpkg-common-tags-1.8.2.tgz
https://registry.yarnpkg.com/compare-version/-/compare-version-0.1.2.tgz -> yarnpkg-compare-version-0.1.2.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.30.0.tgz -> yarnpkg-core-js-compat-3.30.0.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/crc/-/crc-3.8.0.tgz -> yarnpkg-crc-3.8.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> yarnpkg-crypto-random-string-2.0.0.tgz
https://registry.yarnpkg.com/csstype/-/csstype-3.1.2.tgz -> yarnpkg-csstype-3.1.2.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz -> yarnpkg-decompress-response-6.0.0.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.3.1.tgz -> yarnpkg-deepmerge-4.3.1.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> yarnpkg-defer-to-connect-2.0.1.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/dir-compare/-/dir-compare-2.4.0.tgz -> yarnpkg-dir-compare-2.4.0.tgz
https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-23.6.0.tgz -> yarnpkg-dmg-builder-23.6.0.tgz
https://registry.yarnpkg.com/dmg-license/-/dmg-license-1.0.11.tgz -> yarnpkg-dmg-license-1.0.11.tgz
https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> yarnpkg-dotenv-expand-5.1.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-9.0.2.tgz -> yarnpkg-dotenv-9.0.2.tgz
https://registry.yarnpkg.com/ejs/-/ejs-3.1.9.tgz -> yarnpkg-ejs-3.1.9.tgz
https://registry.yarnpkg.com/electron-builder/-/electron-builder-23.6.0.tgz -> yarnpkg-electron-builder-23.6.0.tgz
https://registry.yarnpkg.com/electron-color-picker/-/electron-color-picker-0.2.0.tgz -> yarnpkg-electron-color-picker-0.2.0.tgz
https://registry.yarnpkg.com/electron-notarize/-/electron-notarize-1.2.2.tgz -> yarnpkg-electron-notarize-1.2.2.tgz
https://registry.yarnpkg.com/electron-osx-sign/-/electron-osx-sign-0.6.0.tgz -> yarnpkg-electron-osx-sign-0.6.0.tgz
https://registry.yarnpkg.com/electron-publish/-/electron-publish-23.6.0.tgz -> yarnpkg-electron-publish-23.6.0.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.356.tgz -> yarnpkg-electron-to-chromium-1.4.356.tgz
https://registry.yarnpkg.com/electron-updater/-/electron-updater-5.3.0.tgz -> yarnpkg-electron-updater-5.3.0.tgz
https://registry.yarnpkg.com/electron/-/electron-22.3.5.tgz -> yarnpkg-electron-22.3.5.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.12.0.tgz -> yarnpkg-enhanced-resolve-5.12.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/envinfo/-/envinfo-7.8.1.tgz -> yarnpkg-envinfo-7.8.1.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-module-lexer/-/es-module-lexer-0.9.3.tgz -> yarnpkg-es-module-lexer-0.9.3.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/estree-walker/-/estree-walker-1.0.1.tgz -> yarnpkg-estree-walker-1.0.1.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz -> yarnpkg-events-3.3.0.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-2.0.1.tgz -> yarnpkg-extract-zip-2.0.1.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.1.tgz -> yarnpkg-extsprintf-1.4.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> yarnpkg-fastest-levenshtein-1.0.16.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/filelist/-/filelist-1.0.4.tgz -> yarnpkg-filelist-1.0.4.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/form-data/-/form-data-4.0.0.tgz -> yarnpkg-form-data-4.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz -> yarnpkg-fs-extra-10.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz -> yarnpkg-fs-extra-9.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz -> yarnpkg-fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.2.tgz -> yarnpkg-get-own-enumerable-property-symbols-3.0.2.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz -> yarnpkg-get-stream-5.2.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> yarnpkg-glob-to-regexp-0.4.1.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz -> yarnpkg-global-agent-3.0.0.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/got/-/got-11.8.6.tgz -> yarnpkg-got-11.8.6.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz -> yarnpkg-graceful-readlink-1.0.1.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> yarnpkg-hosted-git-info-4.1.0.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> yarnpkg-http-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> yarnpkg-http2-wrapper-1.0.3.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> yarnpkg-iconv-corefoundation-1.1.7.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/idb/-/idb-7.1.1.tgz -> yarnpkg-idb-7.1.1.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/import-local/-/import-local-3.1.0.tgz -> yarnpkg-import-local-3.1.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/interpret/-/interpret-2.2.0.tgz -> yarnpkg-interpret-2.2.0.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-3.0.1.tgz -> yarnpkg-is-ci-3.0.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-module/-/is-module-1.0.0.tgz -> yarnpkg-is-module-1.0.0.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz -> yarnpkg-is-obj-1.0.1.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-regexp/-/is-regexp-1.0.0.tgz -> yarnpkg-is-regexp-1.0.0.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> yarnpkg-isbinaryfile-3.0.3.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> yarnpkg-isbinaryfile-4.0.10.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/jake/-/jake-10.8.5.tgz -> yarnpkg-jake-10.8.5.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-26.6.2.tgz -> yarnpkg-jest-worker-26.6.2.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.5.1.tgz -> yarnpkg-jest-worker-27.5.1.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.1.tgz -> yarnpkg-json-buffer-3.0.1.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-schema/-/json-schema-0.4.0.tgz -> yarnpkg-json-schema-0.4.0.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz -> yarnpkg-json5-2.2.3.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsonpointer/-/jsonpointer-5.0.1.tgz -> yarnpkg-jsonpointer-5.0.1.tgz
https://registry.yarnpkg.com/keyv/-/keyv-4.5.2.tgz -> yarnpkg-keyv-4.5.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.5.tgz -> yarnpkg-lazy-val-1.0.5.tgz
https://registry.yarnpkg.com/leven/-/leven-3.1.0.tgz -> yarnpkg-leven-3.1.0.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.3.0.tgz -> yarnpkg-loader-runner-4.3.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> yarnpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> yarnpkg-lodash.isequal-4.5.0.tgz
https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> yarnpkg-lodash.sortby-4.7.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz -> yarnpkg-lru-cache-5.1.1.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.25.9.tgz -> yarnpkg-magic-string-0.25.9.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz -> yarnpkg-mime-2.6.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz -> yarnpkg-mimic-response-3.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz -> yarnpkg-minimatch-3.0.4.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.6.tgz -> yarnpkg-minipass-3.3.6.tgz
https://registry.yarnpkg.com/minipass/-/minipass-4.2.5.tgz -> yarnpkg-minipass-4.2.5.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz -> yarnpkg-minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz -> yarnpkg-mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/molangjs/-/molangjs-1.6.2.tgz -> yarnpkg-molangjs-1.6.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.6.tgz -> yarnpkg-nanoid-3.3.6.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz -> yarnpkg-neo-async-2.6.2.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-1.7.2.tgz -> yarnpkg-node-addon-api-1.7.2.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.10.tgz -> yarnpkg-node-releases-2.0.10.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz -> yarnpkg-normalize-url-6.1.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-2.1.1.tgz -> yarnpkg-p-cancelable-2.1.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/plist/-/plist-3.0.6.tgz -> yarnpkg-plist-3.0.6.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.21.tgz -> yarnpkg-postcss-8.4.21.tgz
https://registry.yarnpkg.com/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> yarnpkg-pretty-bytes-5.6.0.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz -> yarnpkg-quick-lru-5.1.1.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.2.0.tgz -> yarnpkg-read-config-file-6.2.0.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.7.1.tgz -> yarnpkg-rechoir-0.7.1.tgz
https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.0.tgz -> yarnpkg-regenerate-unicode-properties-10.1.0.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz -> yarnpkg-regenerate-1.4.2.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> yarnpkg-regenerator-runtime-0.13.11.tgz
https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.15.1.tgz -> yarnpkg-regenerator-transform-0.15.1.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-5.3.2.tgz -> yarnpkg-regexpu-core-5.3.2.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.9.1.tgz -> yarnpkg-regjsparser-0.9.1.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> yarnpkg-resolve-alpn-1.2.1.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> yarnpkg-resolve-cwd-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz -> yarnpkg-resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz -> yarnpkg-resolve-1.22.2.tgz
https://registry.yarnpkg.com/responselike/-/responselike-2.0.1.tgz -> yarnpkg-responselike-2.0.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz -> yarnpkg-roarr-2.15.4.tgz
https://registry.yarnpkg.com/rollup-plugin-terser/-/rollup-plugin-terser-7.0.2.tgz -> yarnpkg-rollup-plugin-terser-7.0.2.tgz
https://registry.yarnpkg.com/rollup/-/rollup-2.79.1.tgz -> yarnpkg-rollup-2.79.1.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-7.8.0.tgz -> yarnpkg-rxjs-7.8.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.1.1.tgz -> yarnpkg-schema-utils-3.1.1.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/semver/-/semver-7.0.0.tgz -> yarnpkg-semver-7.0.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> yarnpkg-serialize-javascript-4.0.0.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.1.tgz -> yarnpkg-serialize-javascript-6.0.1.tgz
https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz -> yarnpkg-shallow-clone-3.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/simple-update-notifier/-/simple-update-notifier-1.1.0.tgz -> yarnpkg-simple-update-notifier-1.1.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz -> yarnpkg-slice-ansi-3.0.0.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz -> yarnpkg-smart-buffer-4.2.0.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz -> yarnpkg-source-map-js-1.0.2.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.8.0-beta.0.tgz -> yarnpkg-source-map-0.8.0-beta.0.tgz
https://registry.yarnpkg.com/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> yarnpkg-sourcemap-codec-1.4.8.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz -> yarnpkg-sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz -> yarnpkg-stat-mode-1.0.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz -> yarnpkg-string.prototype.matchall-4.0.8.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/stringify-object/-/stringify-object-3.3.0.tgz -> yarnpkg-stringify-object-3.3.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-comments/-/strip-comments-2.0.1.tgz -> yarnpkg-strip-comments-2.0.1.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/tapable/-/tapable-2.2.1.tgz -> yarnpkg-tapable-2.2.1.tgz
https://registry.yarnpkg.com/tar/-/tar-6.1.13.tgz -> yarnpkg-tar-6.1.13.tgz
https://registry.yarnpkg.com/temp-dir/-/temp-dir-2.0.0.tgz -> yarnpkg-temp-dir-2.0.0.tgz
https://registry.yarnpkg.com/temp-file/-/temp-file-3.4.0.tgz -> yarnpkg-temp-file-3.4.0.tgz
https://registry.yarnpkg.com/tempy/-/tempy-0.6.0.tgz -> yarnpkg-tempy-0.6.0.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.7.tgz -> yarnpkg-terser-webpack-plugin-5.3.7.tgz
https://registry.yarnpkg.com/terser/-/terser-5.16.8.tgz -> yarnpkg-terser-5.16.8.tgz
https://registry.yarnpkg.com/three/-/three-0.129.0.tgz -> yarnpkg-three-0.129.0.tgz
https://registry.yarnpkg.com/three/-/three-0.147.0.tgz -> yarnpkg-three-0.147.0.tgz
https://registry.yarnpkg.com/tinycolor2/-/tinycolor2-1.6.0.tgz -> yarnpkg-tinycolor2-1.6.0.tgz
https://registry.yarnpkg.com/tmp-promise/-/tmp-promise-3.0.3.tgz -> yarnpkg-tmp-promise-3.0.3.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz -> yarnpkg-tmp-0.2.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-1.0.1.tgz -> yarnpkg-tr46-1.0.1.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.5.0.tgz -> yarnpkg-tslib-2.5.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.16.0.tgz -> yarnpkg-type-fest-0.16.0.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typed-emitter/-/typed-emitter-2.1.0.tgz -> yarnpkg-typed-emitter-2.1.0.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.9.5.tgz -> yarnpkg-typescript-4.9.5.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> yarnpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> yarnpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> yarnpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> yarnpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-2.0.0.tgz -> yarnpkg-unique-string-2.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz -> yarnpkg-upath-1.2.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.10.tgz -> yarnpkg-update-browserslist-db-1.0.10.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> yarnpkg-utf8-byte-length-1.0.4.tgz
https://registry.yarnpkg.com/verror/-/verror-1.10.1.tgz -> yarnpkg-verror-1.10.1.tgz
https://registry.yarnpkg.com/vue/-/vue-2.7.14.tgz -> yarnpkg-vue-2.7.14.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-2.4.0.tgz -> yarnpkg-watchpack-2.4.0.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> yarnpkg-webidl-conversions-4.0.2.tgz
https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-4.10.0.tgz -> yarnpkg-webpack-cli-4.10.0.tgz
https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-5.8.0.tgz -> yarnpkg-webpack-merge-5.8.0.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-3.2.3.tgz -> yarnpkg-webpack-sources-3.2.3.tgz
https://registry.yarnpkg.com/webpack/-/webpack-5.78.0.tgz -> yarnpkg-webpack-5.78.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-7.1.0.tgz -> yarnpkg-whatwg-url-7.1.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.0.tgz -> yarnpkg-wildcard-2.0.0.tgz
https://registry.yarnpkg.com/wintersky/-/wintersky-1.2.1.tgz -> yarnpkg-wintersky-1.2.1.tgz
https://registry.yarnpkg.com/workbox-background-sync/-/workbox-background-sync-6.5.4.tgz -> yarnpkg-workbox-background-sync-6.5.4.tgz
https://registry.yarnpkg.com/workbox-broadcast-update/-/workbox-broadcast-update-6.5.4.tgz -> yarnpkg-workbox-broadcast-update-6.5.4.tgz
https://registry.yarnpkg.com/workbox-build/-/workbox-build-6.5.4.tgz -> yarnpkg-workbox-build-6.5.4.tgz
https://registry.yarnpkg.com/workbox-cacheable-response/-/workbox-cacheable-response-6.5.4.tgz -> yarnpkg-workbox-cacheable-response-6.5.4.tgz
https://registry.yarnpkg.com/workbox-core/-/workbox-core-6.5.4.tgz -> yarnpkg-workbox-core-6.5.4.tgz
https://registry.yarnpkg.com/workbox-expiration/-/workbox-expiration-6.5.4.tgz -> yarnpkg-workbox-expiration-6.5.4.tgz
https://registry.yarnpkg.com/workbox-google-analytics/-/workbox-google-analytics-6.5.4.tgz -> yarnpkg-workbox-google-analytics-6.5.4.tgz
https://registry.yarnpkg.com/workbox-navigation-preload/-/workbox-navigation-preload-6.5.4.tgz -> yarnpkg-workbox-navigation-preload-6.5.4.tgz
https://registry.yarnpkg.com/workbox-precaching/-/workbox-precaching-6.5.4.tgz -> yarnpkg-workbox-precaching-6.5.4.tgz
https://registry.yarnpkg.com/workbox-range-requests/-/workbox-range-requests-6.5.4.tgz -> yarnpkg-workbox-range-requests-6.5.4.tgz
https://registry.yarnpkg.com/workbox-recipes/-/workbox-recipes-6.5.4.tgz -> yarnpkg-workbox-recipes-6.5.4.tgz
https://registry.yarnpkg.com/workbox-routing/-/workbox-routing-6.5.4.tgz -> yarnpkg-workbox-routing-6.5.4.tgz
https://registry.yarnpkg.com/workbox-strategies/-/workbox-strategies-6.5.4.tgz -> yarnpkg-workbox-strategies-6.5.4.tgz
https://registry.yarnpkg.com/workbox-streams/-/workbox-streams-6.5.4.tgz -> yarnpkg-workbox-streams-6.5.4.tgz
https://registry.yarnpkg.com/workbox-sw/-/workbox-sw-6.5.4.tgz -> yarnpkg-workbox-sw-6.5.4.tgz
https://registry.yarnpkg.com/workbox-window/-/workbox-window-6.5.4.tgz -> yarnpkg-workbox-window-6.5.4.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> yarnpkg-xmlbuilder-15.1.1.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz -> yarnpkg-yallist-3.1.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.1.1.tgz -> yarnpkg-yargs-parser-21.1.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.7.1.tgz -> yarnpkg-yargs-17.7.1.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
https://github.com/JannisX11/blockbench/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_unpack() {
        if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
                unpack ${P}.tar.gz
                cd "${S}" || die
                rm package-lock.json
		rm yarn.lock
		npm i || die
		npm audit fix || die
		yarn import || die
		die
        else
		#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		mkdir -p "${S}" || die
		cp -a "${FILESDIR}/${PV}/package.json" "${S}" || die
		yarn_src_unpack
        fi
}

src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-app_cp_electron
	electron-builder -l dir || die
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${YARN_INSTALL_PATH}/${PN}"
	newicon "icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}"
		"${PN^}" \
		"${PN}.png" \
		"Graphics;3DGraphics"
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${YARN_INSTALL_PATH}/blockbench"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
