# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

YARN_INSTALL_PATH="/opt/${PN}/${PV}"
MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="18.14.1"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.
YARN_EXE_LIST="
"${YARN_INSTALL_PATH}/bin/tsc"
"${YARN_INSTALL_PATH}/bin/tsserver"
"

NPM_SECAUDIT_TYPESCRIPT_PV="${PV}"
inherit yarn

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
LICENSE="
	( Apache-2.0 all-rights-reserved )
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
test r1
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
	sys-apps/yarn
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-lang/typescript-5.0.2/work/TypeScript-5.0.2/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@esbuild/android-arm/-/android-arm-0.17.15.tgz -> yarnpkg-@esbuild-android-arm-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/android-arm64/-/android-arm64-0.17.15.tgz -> yarnpkg-@esbuild-android-arm64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/android-x64/-/android-x64-0.17.15.tgz -> yarnpkg-@esbuild-android-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/darwin-arm64/-/darwin-arm64-0.17.15.tgz -> yarnpkg-@esbuild-darwin-arm64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/darwin-x64/-/darwin-x64-0.17.15.tgz -> yarnpkg-@esbuild-darwin-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/freebsd-arm64/-/freebsd-arm64-0.17.15.tgz -> yarnpkg-@esbuild-freebsd-arm64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/freebsd-x64/-/freebsd-x64-0.17.15.tgz -> yarnpkg-@esbuild-freebsd-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-arm/-/linux-arm-0.17.15.tgz -> yarnpkg-@esbuild-linux-arm-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-arm64/-/linux-arm64-0.17.15.tgz -> yarnpkg-@esbuild-linux-arm64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-ia32/-/linux-ia32-0.17.15.tgz -> yarnpkg-@esbuild-linux-ia32-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-loong64/-/linux-loong64-0.17.15.tgz -> yarnpkg-@esbuild-linux-loong64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-mips64el/-/linux-mips64el-0.17.15.tgz -> yarnpkg-@esbuild-linux-mips64el-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-ppc64/-/linux-ppc64-0.17.15.tgz -> yarnpkg-@esbuild-linux-ppc64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-riscv64/-/linux-riscv64-0.17.15.tgz -> yarnpkg-@esbuild-linux-riscv64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-s390x/-/linux-s390x-0.17.15.tgz -> yarnpkg-@esbuild-linux-s390x-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/linux-x64/-/linux-x64-0.17.15.tgz -> yarnpkg-@esbuild-linux-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/netbsd-x64/-/netbsd-x64-0.17.15.tgz -> yarnpkg-@esbuild-netbsd-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/openbsd-x64/-/openbsd-x64-0.17.15.tgz -> yarnpkg-@esbuild-openbsd-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/sunos-x64/-/sunos-x64-0.17.15.tgz -> yarnpkg-@esbuild-sunos-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/win32-arm64/-/win32-arm64-0.17.15.tgz -> yarnpkg-@esbuild-win32-arm64-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/win32-ia32/-/win32-ia32-0.17.15.tgz -> yarnpkg-@esbuild-win32-ia32-0.17.15.tgz
https://registry.yarnpkg.com/@esbuild/win32-x64/-/win32-x64-0.17.15.tgz -> yarnpkg-@esbuild-win32-x64-0.17.15.tgz
https://registry.yarnpkg.com/@esfx/cancelable/-/cancelable-1.0.0.tgz -> yarnpkg-@esfx-cancelable-1.0.0.tgz
https://registry.yarnpkg.com/@esfx/canceltoken/-/canceltoken-1.0.0.tgz -> yarnpkg-@esfx-canceltoken-1.0.0.tgz
https://registry.yarnpkg.com/@esfx/disposable/-/disposable-1.0.0.tgz -> yarnpkg-@esfx-disposable-1.0.0.tgz
https://registry.yarnpkg.com/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> yarnpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.yarnpkg.com/@eslint-community/regexpp/-/regexpp-4.5.0.tgz -> yarnpkg-@eslint-community-regexpp-4.5.0.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-2.0.2.tgz -> yarnpkg-@eslint-eslintrc-2.0.2.tgz
https://registry.yarnpkg.com/@eslint/js/-/js-8.37.0.tgz -> yarnpkg-@eslint-js-8.37.0.tgz
https://registry.yarnpkg.com/@humanwhocodes/config-array/-/config-array-0.11.8.tgz -> yarnpkg-@humanwhocodes-config-array-0.11.8.tgz
https://registry.yarnpkg.com/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> yarnpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.yarnpkg.com/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz -> yarnpkg-@humanwhocodes-object-schema-1.2.1.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@octokit/auth-token/-/auth-token-3.0.3.tgz -> yarnpkg-@octokit-auth-token-3.0.3.tgz
https://registry.yarnpkg.com/@octokit/core/-/core-4.2.0.tgz -> yarnpkg-@octokit-core-4.2.0.tgz
https://registry.yarnpkg.com/@octokit/endpoint/-/endpoint-7.0.5.tgz -> yarnpkg-@octokit-endpoint-7.0.5.tgz
https://registry.yarnpkg.com/@octokit/graphql/-/graphql-5.0.5.tgz -> yarnpkg-@octokit-graphql-5.0.5.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-16.0.0.tgz -> yarnpkg-@octokit-openapi-types-16.0.0.tgz
https://registry.yarnpkg.com/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-6.0.0.tgz -> yarnpkg-@octokit-plugin-paginate-rest-6.0.0.tgz
https://registry.yarnpkg.com/@octokit/plugin-request-log/-/plugin-request-log-1.0.4.tgz -> yarnpkg-@octokit-plugin-request-log-1.0.4.tgz
https://registry.yarnpkg.com/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-7.0.1.tgz -> yarnpkg-@octokit-plugin-rest-endpoint-methods-7.0.1.tgz
https://registry.yarnpkg.com/@octokit/request-error/-/request-error-3.0.3.tgz -> yarnpkg-@octokit-request-error-3.0.3.tgz
https://registry.yarnpkg.com/@octokit/request/-/request-6.2.3.tgz -> yarnpkg-@octokit-request-6.2.3.tgz
https://registry.yarnpkg.com/@octokit/rest/-/rest-19.0.7.tgz -> yarnpkg-@octokit-rest-19.0.7.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-9.0.0.tgz -> yarnpkg-@octokit-types-9.0.0.tgz
https://registry.yarnpkg.com/@types/chai/-/chai-4.3.4.tgz -> yarnpkg-@types-chai-4.3.4.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz -> yarnpkg-@types-fs-extra-9.0.13.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-8.1.0.tgz -> yarnpkg-@types-glob-8.1.0.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/@types/microsoft__typescript-etw/-/microsoft__typescript-etw-0.1.1.tgz -> yarnpkg-@types-microsoft__typescript-etw-0.1.1.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.2.tgz -> yarnpkg-@types-minimist-1.2.2.tgz
https://registry.yarnpkg.com/@types/mocha/-/mocha-10.0.1.tgz -> yarnpkg-@types-mocha-10.0.1.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz -> yarnpkg-@types-ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.15.11.tgz -> yarnpkg-@types-node-18.15.11.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.3.13.tgz -> yarnpkg-@types-semver-7.3.13.tgz
https://registry.yarnpkg.com/@types/source-map-support/-/source-map-support-0.5.6.tgz -> yarnpkg-@types-source-map-support-0.5.6.tgz
https://registry.yarnpkg.com/@types/which/-/which-2.0.2.tgz -> yarnpkg-@types-which-2.0.2.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.57.1.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-5.57.1.tgz -> yarnpkg-@typescript-eslint-parser-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-5.57.1.tgz -> yarnpkg-@typescript-eslint-scope-manager-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/type-utils/-/type-utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-type-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-5.57.1.tgz -> yarnpkg-@typescript-eslint-types-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-5.57.1.tgz -> yarnpkg-@typescript-eslint-typescript-estree-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/utils/-/utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-5.57.1.tgz -> yarnpkg-@typescript-eslint-visitor-keys-5.57.1.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> yarnpkg-acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.8.2.tgz -> yarnpkg-acorn-8.8.2.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.3.tgz -> yarnpkg-anymatch-3.1.3.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/array-back/-/array-back-4.0.2.tgz -> yarnpkg-array-back-4.0.2.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz -> yarnpkg-array-includes-3.1.6.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> yarnpkg-array.prototype.flat-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> yarnpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.1.0.tgz -> yarnpkg-assertion-error-1.1.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/azure-devops-node-api/-/azure-devops-node-api-11.2.0.tgz -> yarnpkg-azure-devops-node-api-11.2.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/before-after-hook/-/before-after-hook-2.2.3.tgz -> yarnpkg-before-after-hook-2.2.3.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/browser-stdout/-/browser-stdout-1.3.1.tgz -> yarnpkg-browser-stdout-1.3.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-6.3.0.tgz -> yarnpkg-camelcase-6.3.0.tgz
https://registry.yarnpkg.com/chai/-/chai-4.3.7.tgz -> yarnpkg-chai-4.3.7.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/check-error/-/check-error-1.0.2.tgz -> yarnpkg-check-error-1.0.2.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/command-line-usage/-/command-line-usage-6.1.3.tgz -> yarnpkg-command-line-usage-6.1.3.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/data-uri-to-buffer/-/data-uri-to-buffer-4.0.1.tgz -> yarnpkg-data-uri-to-buffer-4.0.1.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-4.0.0.tgz -> yarnpkg-decamelize-4.0.0.tgz
https://registry.yarnpkg.com/deep-eql/-/deep-eql-4.1.3.tgz -> yarnpkg-deep-eql-4.1.3.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/del/-/del-6.1.1.tgz -> yarnpkg-del-6.1.1.tgz
https://registry.yarnpkg.com/deprecation/-/deprecation-2.3.1.tgz -> yarnpkg-deprecation-2.3.1.tgz
https://registry.yarnpkg.com/diff/-/diff-5.0.0.tgz -> yarnpkg-diff-5.0.0.tgz
https://registry.yarnpkg.com/diff/-/diff-5.1.0.tgz -> yarnpkg-diff-5.1.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> yarnpkg-es-shim-unscopables-1.0.0.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/esbuild/-/esbuild-0.17.15.tgz -> yarnpkg-esbuild-0.17.15.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/eslint-formatter-autolinkable-stylish/-/eslint-formatter-autolinkable-stylish-1.3.0.tgz -> yarnpkg-eslint-formatter-autolinkable-stylish-1.3.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> yarnpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> yarnpkg-eslint-module-utils-2.7.4.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> yarnpkg-eslint-plugin-import-2.27.5.tgz
https://registry.yarnpkg.com/eslint-plugin-local/-/eslint-plugin-local-1.0.0.tgz -> yarnpkg-eslint-plugin-local-1.0.0.tgz
https://registry.yarnpkg.com/eslint-plugin-no-null/-/eslint-plugin-no-null-1.0.2.tgz -> yarnpkg-eslint-plugin-no-null-1.0.2.tgz
https://registry.yarnpkg.com/eslint-plugin-simple-import-sort/-/eslint-plugin-simple-import-sort-10.0.0.tgz -> yarnpkg-eslint-plugin-simple-import-sort-10.0.0.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-7.1.1.tgz -> yarnpkg-eslint-scope-7.1.1.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-3.4.0.tgz -> yarnpkg-eslint-visitor-keys-3.4.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-8.37.0.tgz -> yarnpkg-eslint-8.37.0.tgz
https://registry.yarnpkg.com/espree/-/espree-9.5.1.tgz -> yarnpkg-espree-9.5.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz -> yarnpkg-esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fast-xml-parser/-/fast-xml-parser-4.1.3.tgz -> yarnpkg-fast-xml-parser-4.1.3.tgz
https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> yarnpkg-fastest-levenshtein-1.0.16.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz -> yarnpkg-fastq-1.15.0.tgz
https://registry.yarnpkg.com/fetch-blob/-/fetch-blob-3.2.0.tgz -> yarnpkg-fetch-blob-3.2.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz -> yarnpkg-flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flat/-/flat-5.0.2.tgz -> yarnpkg-flat-5.0.2.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.7.tgz -> yarnpkg-flatted-3.2.7.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/formdata-polyfill/-/formdata-polyfill-4.0.10.tgz -> yarnpkg-formdata-polyfill-4.0.10.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz -> yarnpkg-fs-extra-9.1.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-func-name/-/get-func-name-2.0.0.tgz -> yarnpkg-get-func-name-2.0.0.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz -> yarnpkg-glob-parent-6.0.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz -> yarnpkg-glob-7.2.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-8.1.0.tgz -> yarnpkg-glob-8.1.0.tgz
https://registry.yarnpkg.com/globals/-/globals-13.20.0.tgz -> yarnpkg-globals-13.20.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz -> yarnpkg-globby-11.1.0.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> yarnpkg-grapheme-splitter-1.0.4.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/hereby/-/hereby-1.8.1.tgz -> yarnpkg-hereby-1.8.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.2.4.tgz -> yarnpkg-ignore-5.2.4.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-meta-resolve/-/import-meta-resolve-2.2.2.tgz -> yarnpkg-import-meta-resolve-2.2.2.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> yarnpkg-irregular-plurals-3.5.0.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> yarnpkg-is-path-cwd-2.2.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz -> yarnpkg-is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> yarnpkg-is-plain-obj-2.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz -> yarnpkg-is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/js-sdsl/-/js-sdsl-4.4.0.tgz -> yarnpkg-js-sdsl-4.4.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.2.0.tgz -> yarnpkg-jsonc-parser-3.2.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/loupe/-/loupe-2.3.6.tgz -> yarnpkg-loupe-2.3.6.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.0.1.tgz -> yarnpkg-minimatch-5.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/mocha-fivemat-progress-reporter/-/mocha-fivemat-progress-reporter-0.1.0.tgz -> yarnpkg-mocha-fivemat-progress-reporter-0.1.0.tgz
https://registry.yarnpkg.com/mocha/-/mocha-10.2.0.tgz -> yarnpkg-mocha-10.2.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.3.tgz -> yarnpkg-nanoid-3.3.3.tgz
https://registry.yarnpkg.com/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz -> yarnpkg-natural-compare-lite-1.4.0.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/node-domexception/-/node-domexception-1.0.0.tgz -> yarnpkg-node-domexception-1.0.0.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.9.tgz -> yarnpkg-node-fetch-2.6.9.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-3.3.1.tgz -> yarnpkg-node-fetch-3.3.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz -> yarnpkg-object.values-1.1.6.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz -> yarnpkg-optionator-0.9.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-ms/-/parse-ms-3.0.0.tgz -> yarnpkg-parse-ms-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/pathval/-/pathval-1.1.1.tgz -> yarnpkg-pathval-1.1.1.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/plur/-/plur-4.0.0.tgz -> yarnpkg-plur-4.0.0.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/pretty-ms/-/pretty-ms-8.0.0.tgz -> yarnpkg-pretty-ms-8.0.0.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.1.tgz -> yarnpkg-qs-6.11.1.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/reduce-flatten/-/reduce-flatten-2.0.0.tgz -> yarnpkg-reduce-flatten-2.0.0.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> yarnpkg-serialize-javascript-6.0.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz -> yarnpkg-slash-3.0.0.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/strnum/-/strnum-1.0.5.tgz -> yarnpkg-strnum-1.0.5.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/table-layout/-/table-layout-1.0.2.tgz -> yarnpkg-table-layout-1.0.2.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> yarnpkg-tsconfig-paths-3.14.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.5.0.tgz -> yarnpkg-tslib-2.5.0.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz -> yarnpkg-type-detect-4.0.8.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz -> yarnpkg-type-fest-0.20.2.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typed-rest-client/-/typed-rest-client-1.8.9.tgz -> yarnpkg-typed-rest-client-1.8.9.tgz
https://registry.yarnpkg.com/typescript/-/typescript-5.0.0-dev.20230112.tgz -> yarnpkg-typescript-5.0.0-dev.20230112.tgz
https://registry.yarnpkg.com/typical/-/typical-5.2.0.tgz -> yarnpkg-typical-5.2.0.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/underscore/-/underscore-1.13.6.tgz -> yarnpkg-underscore-1.13.6.tgz
https://registry.yarnpkg.com/universal-user-agent/-/universal-user-agent-6.0.0.tgz -> yarnpkg-universal-user-agent-6.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/web-streams-polyfill/-/web-streams-polyfill-3.2.1.tgz -> yarnpkg-web-streams-polyfill-3.2.1.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/wordwrapjs/-/wordwrapjs-4.0.1.tgz -> yarnpkg-wordwrapjs-4.0.1.tgz
https://registry.yarnpkg.com/workerpool/-/workerpool-6.2.1.tgz -> yarnpkg-workerpool-6.2.1.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.4.tgz -> yarnpkg-yargs-parser-20.2.4.tgz
https://registry.yarnpkg.com/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> yarnpkg-yargs-unparser-2.0.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	[[ "${UPDATE_YARN_LOCK}" == "1" ]] && return
	local node_pv=$(/usr/bin/node --version \
		| sed -e "s|v||g" \
		| cut -f 1 -d ".")
        if (( ${node_pv} < ${NODE_VERSION} )) ; then
		eerror
		eerror "node_pv must be >=${NODE_VERSION}"
		eerror "Switch Node.js to >=${NODE_VERSION}"
		eerror
		die
        fi
	einfo "Node.js is ${node_pv}"
}

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		npm i || die
		npm audit fix || die
		yarn import || die
	else
		yarn_src_unpack
	fi
}

pkg_postinst() {
	if eselect typescript list | grep ${PV} >/dev/null ; then
		eselect typescript set ${PV}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
