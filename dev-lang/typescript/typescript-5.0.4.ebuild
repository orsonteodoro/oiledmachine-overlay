# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="18.14.1"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}/${PV}"
NPM_EXE_LIST="
"${NPM_INSTALL_PATH}/bin/tsc"
"${NPM_INSTALL_PATH}/bin/tsserver"
"
inherit npm

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	CC-BY-4.0
	MIT
	Unicode-DFS-2016
	W3C-Community-Final-Specification-Agreement
	W3C-Software-and-Document-Notice-and-License-2015
"
# TODO:  Inspect downloaded dependencies
# (Apache-2.0 all-rights-reserved) - CopyrightNotice.txt
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})/${PV}"
IUSE+="
test r3
"
RDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	app-eselect/eselect-typescript
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	dev-util/synp
	media-libs/vips
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-lang/typescript-5.0.2/work/TypeScript-5.0.2/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@aashutoshrathi/word-wrap/-/word-wrap-1.2.6.tgz -> npmpkg-@aashutoshrathi-word-wrap-1.2.6.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.17.19.tgz -> npmpkg-@esbuild-android-arm-0.17.19.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.17.19.tgz -> npmpkg-@esbuild-android-arm64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.17.19.tgz -> npmpkg-@esbuild-android-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.17.19.tgz -> npmpkg-@esbuild-darwin-arm64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.17.19.tgz -> npmpkg-@esbuild-darwin-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.17.19.tgz -> npmpkg-@esbuild-freebsd-arm64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.17.19.tgz -> npmpkg-@esbuild-freebsd-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.17.19.tgz -> npmpkg-@esbuild-linux-arm-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.17.19.tgz -> npmpkg-@esbuild-linux-arm64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.17.19.tgz -> npmpkg-@esbuild-linux-ia32-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.17.19.tgz -> npmpkg-@esbuild-linux-loong64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.17.19.tgz -> npmpkg-@esbuild-linux-mips64el-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.17.19.tgz -> npmpkg-@esbuild-linux-ppc64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.17.19.tgz -> npmpkg-@esbuild-linux-riscv64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.17.19.tgz -> npmpkg-@esbuild-linux-s390x-0.17.19.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.17.19.tgz -> npmpkg-@esbuild-linux-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.17.19.tgz -> npmpkg-@esbuild-netbsd-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.17.19.tgz -> npmpkg-@esbuild-openbsd-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.17.19.tgz -> npmpkg-@esbuild-sunos-x64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.17.19.tgz -> npmpkg-@esbuild-win32-arm64-0.17.19.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.17.19.tgz -> npmpkg-@esbuild-win32-ia32-0.17.19.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.17.19.tgz -> npmpkg-@esbuild-win32-x64-0.17.19.tgz
https://registry.npmjs.org/@esfx/cancelable/-/cancelable-1.0.0.tgz -> npmpkg-@esfx-cancelable-1.0.0.tgz
https://registry.npmjs.org/@esfx/canceltoken/-/canceltoken-1.0.0.tgz -> npmpkg-@esfx-canceltoken-1.0.0.tgz
https://registry.npmjs.org/@esfx/disposable/-/disposable-1.0.0.tgz -> npmpkg-@esfx-disposable-1.0.0.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.10.0.tgz -> npmpkg-@eslint-community-regexpp-4.10.0.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.2.tgz -> npmpkg-@eslint-eslintrc-2.1.2.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.52.0.tgz -> npmpkg-@eslint-js-8.52.0.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.11.13.tgz -> npmpkg-@humanwhocodes-config-array-0.11.13.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.1.tgz -> npmpkg-@humanwhocodes-object-schema-2.0.1.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@octokit/auth-token/-/auth-token-4.0.0.tgz -> npmpkg-@octokit-auth-token-4.0.0.tgz
https://registry.npmjs.org/@octokit/core/-/core-5.0.1.tgz -> npmpkg-@octokit-core-5.0.1.tgz
https://registry.npmjs.org/@octokit/endpoint/-/endpoint-9.0.1.tgz -> npmpkg-@octokit-endpoint-9.0.1.tgz
https://registry.npmjs.org/@octokit/graphql/-/graphql-7.0.2.tgz -> npmpkg-@octokit-graphql-7.0.2.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-19.0.2.tgz -> npmpkg-@octokit-openapi-types-19.0.2.tgz
https://registry.npmjs.org/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-9.1.2.tgz -> npmpkg-@octokit-plugin-paginate-rest-9.1.2.tgz
https://registry.npmjs.org/@octokit/plugin-request-log/-/plugin-request-log-4.0.0.tgz -> npmpkg-@octokit-plugin-request-log-4.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-10.1.2.tgz -> npmpkg-@octokit-plugin-rest-endpoint-methods-10.1.2.tgz
https://registry.npmjs.org/@octokit/request/-/request-8.1.4.tgz -> npmpkg-@octokit-request-8.1.4.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-5.0.1.tgz -> npmpkg-@octokit-request-error-5.0.1.tgz
https://registry.npmjs.org/@octokit/rest/-/rest-20.0.2.tgz -> npmpkg-@octokit-rest-20.0.2.tgz
https://registry.npmjs.org/@octokit/types/-/types-12.1.1.tgz -> npmpkg-@octokit-types-12.1.1.tgz
https://registry.npmjs.org/@types/chai/-/chai-4.3.9.tgz -> npmpkg-@types-chai-4.3.9.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-8.1.0.tgz -> npmpkg-@types-glob-8.1.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.14.tgz -> npmpkg-@types-json-schema-7.0.14.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/microsoft__typescript-etw/-/microsoft__typescript-etw-0.1.2.tgz -> npmpkg-@types-microsoft__typescript-etw-0.1.2.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.4.tgz -> npmpkg-@types-minimist-1.2.4.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-10.0.3.tgz -> npmpkg-@types-mocha-10.0.3.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.33.tgz -> npmpkg-@types-ms-0.7.33.tgz
https://registry.npmjs.org/@types/node/-/node-18.14.1.tgz -> npmpkg-@types-node-18.14.1.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.4.tgz -> npmpkg-@types-semver-7.5.4.tgz
https://registry.npmjs.org/@types/source-map-support/-/source-map-support-0.5.9.tgz -> npmpkg-@types-source-map-support-0.5.9.tgz
https://registry.npmjs.org/@types/which/-/which-2.0.2.tgz -> npmpkg-@types-which-2.0.2.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.62.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-5.62.0.tgz -> npmpkg-@typescript-eslint-parser-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-5.62.0.tgz -> npmpkg-@typescript-eslint-scope-manager-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-5.62.0.tgz -> npmpkg-@typescript-eslint-type-utils-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-5.62.0.tgz -> npmpkg-@typescript-eslint-types-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-5.62.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-5.62.0.tgz -> npmpkg-@typescript-eslint-utils-5.62.0.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-5.62.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-5.62.0.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.11.2.tgz -> npmpkg-acorn-8.11.2.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.1.tgz -> npmpkg-ansi-colors-4.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/array-back/-/array-back-4.0.2.tgz -> npmpkg-array-back-4.0.2.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.7.tgz -> npmpkg-array-includes-3.1.7.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.3.tgz -> npmpkg-array.prototype.findlastindex-1.2.3.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.2.tgz -> npmpkg-array.prototype.flat-1.3.2.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.2.tgz -> npmpkg-array.prototype.flatmap-1.3.2.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.2.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.2.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-1.1.0.tgz -> npmpkg-assertion-error-1.1.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/azure-devops-node-api/-/azure-devops-node-api-11.2.0.tgz -> npmpkg-azure-devops-node-api-11.2.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/before-after-hook/-/before-after-hook-2.2.3.tgz -> npmpkg-before-after-hook-2.2.3.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/browser-stdout/-/browser-stdout-1.3.1.tgz -> npmpkg-browser-stdout-1.3.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.5.tgz -> npmpkg-call-bind-1.0.5.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chai/-/chai-4.3.10.tgz -> npmpkg-chai-4.3.10.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/check-error/-/check-error-1.0.3.tgz -> npmpkg-check-error-1.0.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/command-line-usage/-/command-line-usage-6.1.3.tgz -> npmpkg-command-line-usage-6.1.3.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/data-uri-to-buffer/-/data-uri-to-buffer-4.0.1.tgz -> npmpkg-data-uri-to-buffer-4.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/decamelize/-/decamelize-4.0.0.tgz -> npmpkg-decamelize-4.0.0.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-4.1.3.tgz -> npmpkg-deep-eql-4.1.3.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.1.tgz -> npmpkg-define-data-property-1.1.1.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/deprecation/-/deprecation-2.3.1.tgz -> npmpkg-deprecation-2.3.1.tgz
https://registry.npmjs.org/diff/-/diff-5.1.0.tgz -> npmpkg-diff-5.1.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.22.3.tgz -> npmpkg-es-abstract-1.22.3.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.2.tgz -> npmpkg-es-set-tostringtag-2.0.2.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz -> npmpkg-es-shim-unscopables-1.0.2.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.17.19.tgz -> npmpkg-esbuild-0.17.19.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.52.0.tgz -> npmpkg-eslint-8.52.0.tgz
https://registry.npmjs.org/eslint-formatter-autolinkable-stylish/-/eslint-formatter-autolinkable-stylish-1.3.0.tgz -> npmpkg-eslint-formatter-autolinkable-stylish-1.3.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz -> npmpkg-eslint-import-resolver-node-0.3.9.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.8.0.tgz -> npmpkg-eslint-module-utils-2.8.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.29.0.tgz -> npmpkg-eslint-plugin-import-2.29.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-local/-/eslint-plugin-local-1.0.0.tgz -> npmpkg-eslint-plugin-local-1.0.0.tgz
https://registry.npmjs.org/eslint-plugin-no-null/-/eslint-plugin-no-null-1.0.2.tgz -> npmpkg-eslint-plugin-no-null-1.0.2.tgz
https://registry.npmjs.org/eslint-plugin-simple-import-sort/-/eslint-plugin-simple-import-sort-10.0.0.tgz -> npmpkg-eslint-plugin-simple-import-sort-10.0.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-4.3.2.tgz -> npmpkg-fast-xml-parser-4.3.2.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/fetch-blob/-/fetch-blob-3.2.0.tgz -> npmpkg-fetch-blob-3.2.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.1.1.tgz -> npmpkg-flat-cache-3.1.1.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.9.tgz -> npmpkg-flatted-3.2.9.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/formdata-polyfill/-/formdata-polyfill-4.0.10.tgz -> npmpkg-formdata-polyfill-4.0.10.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz -> npmpkg-get-func-name-2.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.2.tgz -> npmpkg-get-intrinsic-1.2.2.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/globals/-/globals-13.23.0.tgz -> npmpkg-globals-13.23.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz -> npmpkg-graphemer-1.4.0.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.1.tgz -> npmpkg-has-property-descriptors-1.0.1.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hereby/-/hereby-1.8.7.tgz -> npmpkg-hereby-1.8.7.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-2.2.2.tgz -> npmpkg-import-meta-resolve-2.2.2.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.6.tgz -> npmpkg-internal-slot-1.0.6.tgz
https://registry.npmjs.org/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> npmpkg-irregular-plurals-3.5.0.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> npmpkg-is-plain-obj-2.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.12.tgz -> npmpkg-is-typed-array-1.1.12.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.2.0.tgz -> npmpkg-jsonc-parser-3.2.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/loupe/-/loupe-2.3.7.tgz -> npmpkg-loupe-2.3.7.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mocha/-/mocha-10.2.0.tgz -> npmpkg-mocha-10.2.0.tgz
https://registry.npmjs.org/mocha-fivemat-progress-reporter/-/mocha-fivemat-progress-reporter-0.1.0.tgz -> npmpkg-mocha-fivemat-progress-reporter-0.1.0.tgz
https://registry.npmjs.org/diff/-/diff-5.0.0.tgz -> npmpkg-diff-5.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.0.tgz -> npmpkg-glob-7.2.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.0.1.tgz -> npmpkg-minimatch-5.0.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.3.tgz -> npmpkg-nanoid-3.3.3.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz -> npmpkg-natural-compare-lite-1.4.0.tgz
https://registry.npmjs.org/node-domexception/-/node-domexception-1.0.0.tgz -> npmpkg-node-domexception-1.0.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-3.3.2.tgz -> npmpkg-node-fetch-3.3.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz -> npmpkg-object.assign-4.1.4.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.7.tgz -> npmpkg-object.fromentries-2.0.7.tgz
https://registry.npmjs.org/object.groupby/-/object.groupby-1.0.1.tgz -> npmpkg-object.groupby-1.0.1.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.7.tgz -> npmpkg-object.values-1.1.7.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.3.tgz -> npmpkg-optionator-0.9.3.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-3.0.0.tgz -> npmpkg-parse-ms-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pathval/-/pathval-1.1.1.tgz -> npmpkg-pathval-1.1.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/plur/-/plur-4.0.0.tgz -> npmpkg-plur-4.0.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-8.0.0.tgz -> npmpkg-pretty-ms-8.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/qs/-/qs-6.11.2.tgz -> npmpkg-qs-6.11.2.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/reduce-flatten/-/reduce-flatten-2.0.0.tgz -> npmpkg-reduce-flatten-2.0.0.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.1.tgz -> npmpkg-regexp.prototype.flags-1.5.1.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.0.1.tgz -> npmpkg-safe-array-concat-1.0.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> npmpkg-serialize-javascript-6.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.1.1.tgz -> npmpkg-set-function-length-1.1.1.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.1.tgz -> npmpkg-set-function-name-2.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.8.tgz -> npmpkg-string.prototype.trim-1.2.8.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.7.tgz -> npmpkg-string.prototype.trimend-1.0.7.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.7.tgz -> npmpkg-string.prototype.trimstart-1.0.7.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/strnum/-/strnum-1.0.5.tgz -> npmpkg-strnum-1.0.5.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/table-layout/-/table-layout-1.0.2.tgz -> npmpkg-table-layout-1.0.2.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> npmpkg-tsconfig-paths-3.14.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz -> npmpkg-tsutils-3.21.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.0.tgz -> npmpkg-typed-array-buffer-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.0.tgz -> npmpkg-typed-array-byte-length-1.0.0.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.0.tgz -> npmpkg-typed-array-byte-offset-1.0.0.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typed-rest-client/-/typed-rest-client-1.8.11.tgz -> npmpkg-typed-rest-client-1.8.11.tgz
https://registry.npmjs.org/typescript/-/typescript-5.0.0-dev.20230112.tgz -> npmpkg-typescript-5.0.0-dev.20230112.tgz
https://registry.npmjs.org/typical/-/typical-5.2.0.tgz -> npmpkg-typical-5.2.0.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/underscore/-/underscore-1.13.6.tgz -> npmpkg-underscore-1.13.6.tgz
https://registry.npmjs.org/universal-user-agent/-/universal-user-agent-6.0.0.tgz -> npmpkg-universal-user-agent-6.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/web-streams-polyfill/-/web-streams-polyfill-3.2.1.tgz -> npmpkg-web-streams-polyfill-3.2.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.13.tgz -> npmpkg-which-typed-array-1.1.13.tgz
https://registry.npmjs.org/wordwrapjs/-/wordwrapjs-4.0.1.tgz -> npmpkg-wordwrapjs-4.0.1.tgz
https://registry.npmjs.org/workerpool/-/workerpool-6.2.1.tgz -> npmpkg-workerpool-6.2.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.4.tgz -> npmpkg-yargs-parser-20.2.4.tgz
https://registry.npmjs.org/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> npmpkg-yargs-unparser-2.0.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

npm_update_lock_install_pre() {
	enpm install "@types/node@${NPM_SECAUDIT_AT_TYPES_NODE_PV}"
}

src_install() {
	npm_src_install

	# Move wrappers
	mv "${ED}/usr/bin/tsc" \
		"${ED}/opt/${PN}/${PV}" || die
	mv "${ED}/usr/bin/tsserver" \
		"${ED}/opt/${PN}/${PV}" || die
einfo "Removing npm-packages-offline-cache"
        rm -rf "${ED}/opt/${PN}/npm-packages-offline-cache"
}

pkg_postinst() {
	if eselect typescript list | grep ${PV} >/dev/null ; then
		eselect typescript set ${PV}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.0.4 (20230607)
# 86474 passing (17m)
