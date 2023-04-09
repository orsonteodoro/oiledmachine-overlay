# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

YARN_INSTALL_PATH="/opt/${PN}/${PV}"
MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="18.11.7"
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
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-lang/typescript-4.9.5/work/TypeScript-4.9.5/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@es-joy/jsdoccomment/-/jsdoccomment-0.36.1.tgz -> yarnpkg-@es-joy-jsdoccomment-0.36.1.tgz
https://registry.yarnpkg.com/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> yarnpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.yarnpkg.com/@eslint-community/regexpp/-/regexpp-4.5.0.tgz -> yarnpkg-@eslint-community-regexpp-4.5.0.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-2.0.2.tgz -> yarnpkg-@eslint-eslintrc-2.0.2.tgz
https://registry.yarnpkg.com/@eslint/js/-/js-8.37.0.tgz -> yarnpkg-@eslint-js-8.37.0.tgz
https://registry.yarnpkg.com/@gulp-sourcemaps/identity-map/-/identity-map-2.0.1.tgz -> yarnpkg-@gulp-sourcemaps-identity-map-2.0.1.tgz
https://registry.yarnpkg.com/@gulp-sourcemaps/map-sources/-/map-sources-1.0.0.tgz -> yarnpkg-@gulp-sourcemaps-map-sources-1.0.0.tgz
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
https://registry.yarnpkg.com/@types/expect/-/expect-1.20.4.tgz -> yarnpkg-@types-expect-1.20.4.tgz
https://registry.yarnpkg.com/@types/fancy-log/-/fancy-log-2.0.0.tgz -> yarnpkg-@types-fancy-log-2.0.0.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz -> yarnpkg-@types-fs-extra-9.0.13.tgz
https://registry.yarnpkg.com/@types/glob-stream/-/glob-stream-6.1.1.tgz -> yarnpkg-@types-glob-stream-6.1.1.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-8.1.0.tgz -> yarnpkg-@types-glob-8.1.0.tgz
https://registry.yarnpkg.com/@types/gulp-concat/-/gulp-concat-0.0.33.tgz -> yarnpkg-@types-gulp-concat-0.0.33.tgz
https://registry.yarnpkg.com/@types/gulp-newer/-/gulp-newer-1.4.0.tgz -> yarnpkg-@types-gulp-newer-1.4.0.tgz
https://registry.yarnpkg.com/@types/gulp-rename/-/gulp-rename-2.0.1.tgz -> yarnpkg-@types-gulp-rename-2.0.1.tgz
https://registry.yarnpkg.com/@types/gulp-sourcemaps/-/gulp-sourcemaps-0.0.35.tgz -> yarnpkg-@types-gulp-sourcemaps-0.0.35.tgz
https://registry.yarnpkg.com/@types/gulp/-/gulp-4.0.10.tgz -> yarnpkg-@types-gulp-4.0.10.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/@types/merge2/-/merge2-1.4.0.tgz -> yarnpkg-@types-merge2-1.4.0.tgz
https://registry.yarnpkg.com/@types/microsoft__typescript-etw/-/microsoft__typescript-etw-0.1.1.tgz -> yarnpkg-@types-microsoft__typescript-etw-0.1.1.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.2.tgz -> yarnpkg-@types-minimist-1.2.2.tgz
https://registry.yarnpkg.com/@types/mkdirp/-/mkdirp-2.0.0.tgz -> yarnpkg-@types-mkdirp-2.0.0.tgz
https://registry.yarnpkg.com/@types/mocha/-/mocha-10.0.1.tgz -> yarnpkg-@types-mocha-10.0.1.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz -> yarnpkg-@types-ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.15.11.tgz -> yarnpkg-@types-node-18.15.11.tgz
https://registry.yarnpkg.com/@types/rimraf/-/rimraf-2.0.5.tgz -> yarnpkg-@types-rimraf-2.0.5.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.3.13.tgz -> yarnpkg-@types-semver-7.3.13.tgz
https://registry.yarnpkg.com/@types/source-map-support/-/source-map-support-0.5.6.tgz -> yarnpkg-@types-source-map-support-0.5.6.tgz
https://registry.yarnpkg.com/@types/undertaker-registry/-/undertaker-registry-1.0.1.tgz -> yarnpkg-@types-undertaker-registry-1.0.1.tgz
https://registry.yarnpkg.com/@types/undertaker/-/undertaker-1.2.8.tgz -> yarnpkg-@types-undertaker-1.2.8.tgz
https://registry.yarnpkg.com/@types/vinyl-fs/-/vinyl-fs-3.0.1.tgz -> yarnpkg-@types-vinyl-fs-3.0.1.tgz
https://registry.yarnpkg.com/@types/vinyl/-/vinyl-2.0.7.tgz -> yarnpkg-@types-vinyl-2.0.7.tgz
https://registry.yarnpkg.com/@types/which/-/which-2.0.2.tgz -> yarnpkg-@types-which-2.0.2.tgz
https://registry.yarnpkg.com/@types/xml2js/-/xml2js-0.4.11.tgz -> yarnpkg-@types-xml2js-0.4.11.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.57.1.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-5.57.1.tgz -> yarnpkg-@typescript-eslint-parser-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-5.57.1.tgz -> yarnpkg-@typescript-eslint-scope-manager-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/type-utils/-/type-utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-type-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-5.57.1.tgz -> yarnpkg-@typescript-eslint-types-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-5.57.1.tgz -> yarnpkg-@typescript-eslint-typescript-estree-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/utils/-/utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-5.57.1.tgz -> yarnpkg-@typescript-eslint-visitor-keys-5.57.1.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> yarnpkg-acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-6.4.2.tgz -> yarnpkg-acorn-6.4.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.8.2.tgz -> yarnpkg-acorn-8.8.2.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-1.1.0.tgz -> yarnpkg-ansi-colors-1.1.0.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-cyan/-/ansi-cyan-0.1.1.tgz -> yarnpkg-ansi-cyan-0.1.1.tgz
https://registry.yarnpkg.com/ansi-gray/-/ansi-gray-0.1.1.tgz -> yarnpkg-ansi-gray-0.1.1.tgz
https://registry.yarnpkg.com/ansi-red/-/ansi-red-0.1.1.tgz -> yarnpkg-ansi-red-0.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/ansi-wrap/-/ansi-wrap-0.1.0.tgz -> yarnpkg-ansi-wrap-0.1.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz -> yarnpkg-anymatch-2.0.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.3.tgz -> yarnpkg-anymatch-3.1.3.tgz
https://registry.yarnpkg.com/append-buffer/-/append-buffer-1.0.2.tgz -> yarnpkg-append-buffer-1.0.2.tgz
https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz -> yarnpkg-archy-1.0.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-1.1.0.tgz -> yarnpkg-arr-diff-1.1.0.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz -> yarnpkg-arr-diff-4.0.0.tgz
https://registry.yarnpkg.com/arr-filter/-/arr-filter-1.1.2.tgz -> yarnpkg-arr-filter-1.1.2.tgz
https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz -> yarnpkg-arr-flatten-1.1.0.tgz
https://registry.yarnpkg.com/arr-map/-/arr-map-2.0.2.tgz -> yarnpkg-arr-map-2.0.2.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-2.1.0.tgz -> yarnpkg-arr-union-2.1.0.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-each/-/array-each-1.0.1.tgz -> yarnpkg-array-each-1.0.1.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz -> yarnpkg-array-includes-3.1.6.tgz
https://registry.yarnpkg.com/array-initial/-/array-initial-1.1.0.tgz -> yarnpkg-array-initial-1.1.0.tgz
https://registry.yarnpkg.com/array-last/-/array-last-1.3.0.tgz -> yarnpkg-array-last-1.3.0.tgz
https://registry.yarnpkg.com/array-slice/-/array-slice-0.2.3.tgz -> yarnpkg-array-slice-0.2.3.tgz
https://registry.yarnpkg.com/array-slice/-/array-slice-1.1.0.tgz -> yarnpkg-array-slice-1.1.0.tgz
https://registry.yarnpkg.com/array-sort/-/array-sort-1.0.0.tgz -> yarnpkg-array-sort-1.0.0.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz -> yarnpkg-array-unique-0.3.2.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> yarnpkg-array.prototype.flat-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> yarnpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.1.0.tgz -> yarnpkg-assertion-error-1.1.0.tgz
https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz -> yarnpkg-assign-symbols-1.0.0.tgz
https://registry.yarnpkg.com/async-done/-/async-done-1.3.2.tgz -> yarnpkg-async-done-1.3.2.tgz
https://registry.yarnpkg.com/async-each/-/async-each-1.0.6.tgz -> yarnpkg-async-each-1.0.6.tgz
https://registry.yarnpkg.com/async-settle/-/async-settle-1.0.0.tgz -> yarnpkg-async-settle-1.0.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz -> yarnpkg-atob-2.1.2.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/azure-devops-node-api/-/azure-devops-node-api-11.2.0.tgz -> yarnpkg-azure-devops-node-api-11.2.0.tgz
https://registry.yarnpkg.com/bach/-/bach-1.2.0.tgz -> yarnpkg-bach-1.2.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base/-/base-0.11.2.tgz -> yarnpkg-base-0.11.2.tgz
https://registry.yarnpkg.com/before-after-hook/-/before-after-hook-2.2.3.tgz -> yarnpkg-before-after-hook-2.2.3.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz -> yarnpkg-binary-extensions-1.13.1.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz -> yarnpkg-bindings-1.5.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz -> yarnpkg-braces-2.3.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/browser-stdout/-/browser-stdout-1.3.1.tgz -> yarnpkg-browser-stdout-1.3.1.tgz
https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-1.0.1.tgz -> yarnpkg-buffer-equal-1.0.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz -> yarnpkg-cache-base-1.0.1.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-3.0.0.tgz -> yarnpkg-camelcase-3.0.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-6.3.0.tgz -> yarnpkg-camelcase-6.3.0.tgz
https://registry.yarnpkg.com/chai/-/chai-4.3.7.tgz -> yarnpkg-chai-4.3.7.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/check-error/-/check-error-1.0.2.tgz -> yarnpkg-check-error-1.0.2.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-2.1.8.tgz -> yarnpkg-chokidar-2.1.8.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz -> yarnpkg-class-utils-0.3.6.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-3.2.0.tgz -> yarnpkg-cliui-3.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/clone-buffer/-/clone-buffer-1.0.0.tgz -> yarnpkg-clone-buffer-1.0.0.tgz
https://registry.yarnpkg.com/clone-stats/-/clone-stats-1.0.0.tgz -> yarnpkg-clone-stats-1.0.0.tgz
https://registry.yarnpkg.com/clone/-/clone-2.1.2.tgz -> yarnpkg-clone-2.1.2.tgz
https://registry.yarnpkg.com/cloneable-readable/-/cloneable-readable-1.1.3.tgz -> yarnpkg-cloneable-readable-1.1.3.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/collection-map/-/collection-map-1.0.0.tgz -> yarnpkg-collection-map-1.0.0.tgz
https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz -> yarnpkg-collection-visit-1.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/comment-parser/-/comment-parser-1.3.1.tgz -> yarnpkg-comment-parser-1.3.1.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/concat-with-sourcemaps/-/concat-with-sourcemaps-1.1.0.tgz -> yarnpkg-concat-with-sourcemaps-1.1.0.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> yarnpkg-copy-descriptor-0.1.1.tgz
https://registry.yarnpkg.com/copy-props/-/copy-props-2.0.5.tgz -> yarnpkg-copy-props-2.0.5.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/css/-/css-3.0.0.tgz -> yarnpkg-css-3.0.0.tgz
https://registry.yarnpkg.com/d/-/d-1.0.1.tgz -> yarnpkg-d-1.0.1.tgz
https://registry.yarnpkg.com/data-uri-to-buffer/-/data-uri-to-buffer-4.0.1.tgz -> yarnpkg-data-uri-to-buffer-4.0.1.tgz
https://registry.yarnpkg.com/debug-fabulous/-/debug-fabulous-1.1.0.tgz -> yarnpkg-debug-fabulous-1.1.0.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-4.0.0.tgz -> yarnpkg-decamelize-4.0.0.tgz
https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> yarnpkg-decode-uri-component-0.2.2.tgz
https://registry.yarnpkg.com/deep-eql/-/deep-eql-4.1.3.tgz -> yarnpkg-deep-eql-4.1.3.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/default-compare/-/default-compare-1.0.0.tgz -> yarnpkg-default-compare-1.0.0.tgz
https://registry.yarnpkg.com/default-resolution/-/default-resolution-2.0.0.tgz -> yarnpkg-default-resolution-2.0.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz -> yarnpkg-define-property-0.2.5.tgz
https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz -> yarnpkg-define-property-1.0.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz -> yarnpkg-define-property-2.0.2.tgz
https://registry.yarnpkg.com/del/-/del-6.1.1.tgz -> yarnpkg-del-6.1.1.tgz
https://registry.yarnpkg.com/deprecation/-/deprecation-2.3.1.tgz -> yarnpkg-deprecation-2.3.1.tgz
https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz -> yarnpkg-detect-file-1.0.0.tgz
https://registry.yarnpkg.com/detect-newline/-/detect-newline-2.1.0.tgz -> yarnpkg-detect-newline-2.1.0.tgz
https://registry.yarnpkg.com/diff/-/diff-5.0.0.tgz -> yarnpkg-diff-5.0.0.tgz
https://registry.yarnpkg.com/diff/-/diff-5.1.0.tgz -> yarnpkg-diff-5.1.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/duplexify/-/duplexify-3.7.1.tgz -> yarnpkg-duplexify-3.7.1.tgz
https://registry.yarnpkg.com/each-props/-/each-props-1.3.2.tgz -> yarnpkg-each-props-1.3.2.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> yarnpkg-es-shim-unscopables-1.0.0.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es5-ext/-/es5-ext-0.10.53.tgz -> yarnpkg-es5-ext-0.10.53.tgz
https://registry.yarnpkg.com/es6-iterator/-/es6-iterator-2.0.3.tgz -> yarnpkg-es6-iterator-2.0.3.tgz
https://registry.yarnpkg.com/es6-symbol/-/es6-symbol-3.1.3.tgz -> yarnpkg-es6-symbol-3.1.3.tgz
https://registry.yarnpkg.com/es6-weak-map/-/es6-weak-map-2.0.3.tgz -> yarnpkg-es6-weak-map-2.0.3.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/eslint-formatter-autolinkable-stylish/-/eslint-formatter-autolinkable-stylish-1.3.0.tgz -> yarnpkg-eslint-formatter-autolinkable-stylish-1.3.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> yarnpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> yarnpkg-eslint-module-utils-2.7.4.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> yarnpkg-eslint-plugin-import-2.27.5.tgz
https://registry.yarnpkg.com/eslint-plugin-jsdoc/-/eslint-plugin-jsdoc-39.9.1.tgz -> yarnpkg-eslint-plugin-jsdoc-39.9.1.tgz
https://registry.yarnpkg.com/eslint-plugin-local/-/eslint-plugin-local-1.0.0.tgz -> yarnpkg-eslint-plugin-local-1.0.0.tgz
https://registry.yarnpkg.com/eslint-plugin-no-null/-/eslint-plugin-no-null-1.0.2.tgz -> yarnpkg-eslint-plugin-no-null-1.0.2.tgz
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
https://registry.yarnpkg.com/event-emitter/-/event-emitter-0.3.5.tgz -> yarnpkg-event-emitter-0.3.5.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz -> yarnpkg-expand-brackets-2.1.4.tgz
https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz -> yarnpkg-expand-tilde-2.0.2.tgz
https://registry.yarnpkg.com/ext/-/ext-1.7.0.tgz -> yarnpkg-ext-1.7.0.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-1.1.4.tgz -> yarnpkg-extend-shallow-1.1.4.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz -> yarnpkg-extend-shallow-3.0.2.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz -> yarnpkg-extglob-2.0.4.tgz
https://registry.yarnpkg.com/fancy-log/-/fancy-log-1.3.3.tgz -> yarnpkg-fancy-log-1.3.3.tgz
https://registry.yarnpkg.com/fancy-log/-/fancy-log-2.0.0.tgz -> yarnpkg-fancy-log-2.0.0.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-fifo/-/fast-fifo-1.1.0.tgz -> yarnpkg-fast-fifo-1.1.0.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-1.1.4.tgz -> yarnpkg-fast-levenshtein-1.1.4.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz -> yarnpkg-fastq-1.15.0.tgz
https://registry.yarnpkg.com/fetch-blob/-/fetch-blob-3.2.0.tgz -> yarnpkg-fetch-blob-3.2.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> yarnpkg-file-uri-to-path-1.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz -> yarnpkg-fill-range-4.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz -> yarnpkg-find-up-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/findup-sync/-/findup-sync-2.0.0.tgz -> yarnpkg-findup-sync-2.0.0.tgz
https://registry.yarnpkg.com/findup-sync/-/findup-sync-3.0.0.tgz -> yarnpkg-findup-sync-3.0.0.tgz
https://registry.yarnpkg.com/fined/-/fined-1.2.0.tgz -> yarnpkg-fined-1.2.0.tgz
https://registry.yarnpkg.com/flagged-respawn/-/flagged-respawn-1.0.1.tgz -> yarnpkg-flagged-respawn-1.0.1.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz -> yarnpkg-flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flat/-/flat-5.0.2.tgz -> yarnpkg-flat-5.0.2.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.7.tgz -> yarnpkg-flatted-3.2.7.tgz
https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> yarnpkg-flush-write-stream-1.1.1.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz -> yarnpkg-for-in-1.0.2.tgz
https://registry.yarnpkg.com/for-own/-/for-own-1.0.0.tgz -> yarnpkg-for-own-1.0.0.tgz
https://registry.yarnpkg.com/formdata-polyfill/-/formdata-polyfill-4.0.10.tgz -> yarnpkg-formdata-polyfill-4.0.10.tgz
https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz -> yarnpkg-fragment-cache-0.2.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz -> yarnpkg-fs-extra-9.1.0.tgz
https://registry.yarnpkg.com/fs-mkdirp-stream/-/fs-mkdirp-stream-1.0.0.tgz -> yarnpkg-fs-mkdirp-stream-1.0.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.13.tgz -> yarnpkg-fsevents-1.2.13.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.3.tgz -> yarnpkg-get-caller-file-1.0.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-func-name/-/get-func-name-2.0.0.tgz -> yarnpkg-get-func-name-2.0.0.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz -> yarnpkg-get-value-2.0.6.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz -> yarnpkg-glob-parent-3.1.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz -> yarnpkg-glob-parent-6.0.2.tgz
https://registry.yarnpkg.com/glob-stream/-/glob-stream-6.1.0.tgz -> yarnpkg-glob-stream-6.1.0.tgz
https://registry.yarnpkg.com/glob-watcher/-/glob-watcher-5.0.5.tgz -> yarnpkg-glob-watcher-5.0.5.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz -> yarnpkg-glob-7.2.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-9.3.4.tgz -> yarnpkg-glob-9.3.4.tgz
https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz -> yarnpkg-global-modules-1.0.0.tgz
https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz -> yarnpkg-global-prefix-1.0.2.tgz
https://registry.yarnpkg.com/globals/-/globals-13.20.0.tgz -> yarnpkg-globals-13.20.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz -> yarnpkg-globby-11.1.0.tgz
https://registry.yarnpkg.com/glogg/-/glogg-1.0.2.tgz -> yarnpkg-glogg-1.0.2.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> yarnpkg-grapheme-splitter-1.0.4.tgz
https://registry.yarnpkg.com/gulp-cli/-/gulp-cli-2.3.0.tgz -> yarnpkg-gulp-cli-2.3.0.tgz
https://registry.yarnpkg.com/gulp-concat/-/gulp-concat-2.6.1.tgz -> yarnpkg-gulp-concat-2.6.1.tgz
https://registry.yarnpkg.com/gulp-insert/-/gulp-insert-0.5.0.tgz -> yarnpkg-gulp-insert-0.5.0.tgz
https://registry.yarnpkg.com/gulp-newer/-/gulp-newer-1.4.0.tgz -> yarnpkg-gulp-newer-1.4.0.tgz
https://registry.yarnpkg.com/gulp-rename/-/gulp-rename-2.0.0.tgz -> yarnpkg-gulp-rename-2.0.0.tgz
https://registry.yarnpkg.com/gulp-sourcemaps/-/gulp-sourcemaps-3.0.0.tgz -> yarnpkg-gulp-sourcemaps-3.0.0.tgz
https://registry.yarnpkg.com/gulp/-/gulp-4.0.2.tgz -> yarnpkg-gulp-4.0.2.tgz
https://registry.yarnpkg.com/gulplog/-/gulplog-1.0.0.tgz -> yarnpkg-gulplog-1.0.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz -> yarnpkg-has-value-0.3.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz -> yarnpkg-has-value-1.0.0.tgz
https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz -> yarnpkg-has-values-0.1.4.tgz
https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz -> yarnpkg-has-values-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> yarnpkg-homedir-polyfill-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.2.4.tgz -> yarnpkg-ignore-5.2.4.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz -> yarnpkg-interpret-1.4.0.tgz
https://registry.yarnpkg.com/invert-kv/-/invert-kv-1.0.0.tgz -> yarnpkg-invert-kv-1.0.0.tgz
https://registry.yarnpkg.com/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> yarnpkg-irregular-plurals-3.5.0.tgz
https://registry.yarnpkg.com/is-absolute/-/is-absolute-1.0.0.tgz -> yarnpkg-is-absolute-1.0.0.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> yarnpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> yarnpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz -> yarnpkg-is-binary-path-1.0.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz -> yarnpkg-is-buffer-1.1.6.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> yarnpkg-is-data-descriptor-0.1.4.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> yarnpkg-is-data-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz -> yarnpkg-is-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz -> yarnpkg-is-descriptor-1.0.2.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz -> yarnpkg-is-extendable-1.0.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz -> yarnpkg-is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> yarnpkg-is-negated-glob-1.0.0.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz -> yarnpkg-is-number-3.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz -> yarnpkg-is-number-4.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> yarnpkg-is-path-cwd-2.2.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz -> yarnpkg-is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> yarnpkg-is-plain-obj-2.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz -> yarnpkg-is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-promise/-/is-promise-2.2.2.tgz -> yarnpkg-is-promise-2.2.2.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-relative/-/is-relative-1.0.0.tgz -> yarnpkg-is-relative-1.0.0.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-unc-path/-/is-unc-path-1.0.0.tgz -> yarnpkg-is-unc-path-1.0.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz -> yarnpkg-is-utf8-0.2.1.tgz
https://registry.yarnpkg.com/is-valid-glob/-/is-valid-glob-1.0.0.tgz -> yarnpkg-is-valid-glob-1.0.0.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz -> yarnpkg-isarray-0.0.1.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz -> yarnpkg-isobject-2.1.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/js-sdsl/-/js-sdsl-4.4.0.tgz -> yarnpkg-js-sdsl-4.4.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/jsdoc-type-pratt-parser/-/jsdoc-type-pratt-parser-3.1.0.tgz -> yarnpkg-jsdoc-type-pratt-parser-3.1.0.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/just-debounce/-/just-debounce-1.1.0.tgz -> yarnpkg-just-debounce-1.1.0.tgz
https://registry.yarnpkg.com/kew/-/kew-0.7.0.tgz -> yarnpkg-kew-0.7.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-1.1.0.tgz -> yarnpkg-kind-of-1.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz -> yarnpkg-kind-of-3.2.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz -> yarnpkg-kind-of-4.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz -> yarnpkg-kind-of-5.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/last-run/-/last-run-1.1.1.tgz -> yarnpkg-last-run-1.1.1.tgz
https://registry.yarnpkg.com/lazystream/-/lazystream-1.0.1.tgz -> yarnpkg-lazystream-1.0.1.tgz
https://registry.yarnpkg.com/lcid/-/lcid-1.0.0.tgz -> yarnpkg-lcid-1.0.0.tgz
https://registry.yarnpkg.com/lead/-/lead-1.0.0.tgz -> yarnpkg-lead-1.0.0.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/liftoff/-/liftoff-3.1.0.tgz -> yarnpkg-liftoff-3.1.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz -> yarnpkg-load-json-file-1.1.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/loupe/-/loupe-2.3.6.tgz -> yarnpkg-loupe-2.3.6.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-7.18.3.tgz -> yarnpkg-lru-cache-7.18.3.tgz
https://registry.yarnpkg.com/lru-queue/-/lru-queue-0.1.0.tgz -> yarnpkg-lru-queue-0.1.0.tgz
https://registry.yarnpkg.com/make-iterator/-/make-iterator-1.0.1.tgz -> yarnpkg-make-iterator-1.0.1.tgz
https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz -> yarnpkg-map-cache-0.2.2.tgz
https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz -> yarnpkg-map-visit-1.0.0.tgz
https://registry.yarnpkg.com/matchdep/-/matchdep-2.0.0.tgz -> yarnpkg-matchdep-2.0.0.tgz
https://registry.yarnpkg.com/memoizee/-/memoizee-0.4.15.tgz -> yarnpkg-memoizee-0.4.15.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz -> yarnpkg-micromatch-3.1.10.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.0.1.tgz -> yarnpkg-minimatch-5.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-8.0.3.tgz -> yarnpkg-minimatch-8.0.3.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/minipass/-/minipass-4.2.5.tgz -> yarnpkg-minipass-4.2.5.tgz
https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz -> yarnpkg-mixin-deep-1.3.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-2.1.6.tgz -> yarnpkg-mkdirp-2.1.6.tgz
https://registry.yarnpkg.com/mocha-fivemat-progress-reporter/-/mocha-fivemat-progress-reporter-0.1.0.tgz -> yarnpkg-mocha-fivemat-progress-reporter-0.1.0.tgz
https://registry.yarnpkg.com/mocha/-/mocha-10.2.0.tgz -> yarnpkg-mocha-10.2.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/mute-stdout/-/mute-stdout-1.0.1.tgz -> yarnpkg-mute-stdout-1.0.1.tgz
https://registry.yarnpkg.com/nan/-/nan-2.17.0.tgz -> yarnpkg-nan-2.17.0.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.3.tgz -> yarnpkg-nanoid-3.3.3.tgz
https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz -> yarnpkg-nanomatch-1.2.13.tgz
https://registry.yarnpkg.com/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz -> yarnpkg-natural-compare-lite-1.4.0.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/next-tick/-/next-tick-1.0.0.tgz -> yarnpkg-next-tick-1.0.0.tgz
https://registry.yarnpkg.com/next-tick/-/next-tick-1.1.0.tgz -> yarnpkg-next-tick-1.1.0.tgz
https://registry.yarnpkg.com/node-domexception/-/node-domexception-1.0.0.tgz -> yarnpkg-node-domexception-1.0.0.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.9.tgz -> yarnpkg-node-fetch-2.6.9.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-3.3.1.tgz -> yarnpkg-node-fetch-3.3.1.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz -> yarnpkg-normalize-path-2.1.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/now-and-later/-/now-and-later-2.0.1.tgz -> yarnpkg-now-and-later-2.0.1.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz -> yarnpkg-object-copy-0.1.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz -> yarnpkg-object-visit-1.0.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.defaults/-/object.defaults-1.1.0.tgz -> yarnpkg-object.defaults-1.1.0.tgz
https://registry.yarnpkg.com/object.map/-/object.map-1.0.1.tgz -> yarnpkg-object.map-1.0.1.tgz
https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz -> yarnpkg-object.pick-1.3.0.tgz
https://registry.yarnpkg.com/object.reduce/-/object.reduce-1.0.1.tgz -> yarnpkg-object.reduce-1.0.1.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz -> yarnpkg-object.values-1.1.6.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz -> yarnpkg-optionator-0.9.1.tgz
https://registry.yarnpkg.com/ordered-read-streams/-/ordered-read-streams-1.0.1.tgz -> yarnpkg-ordered-read-streams-1.0.1.tgz
https://registry.yarnpkg.com/os-locale/-/os-locale-1.4.0.tgz -> yarnpkg-os-locale-1.4.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-filepath/-/parse-filepath-1.0.2.tgz -> yarnpkg-parse-filepath-1.0.2.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/parse-node-version/-/parse-node-version-1.0.1.tgz -> yarnpkg-parse-node-version-1.0.1.tgz
https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz -> yarnpkg-parse-passwd-1.0.0.tgz
https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz -> yarnpkg-pascalcase-0.1.1.tgz
https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz -> yarnpkg-path-dirname-1.0.2.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz -> yarnpkg-path-exists-2.1.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-root-regex/-/path-root-regex-0.1.2.tgz -> yarnpkg-path-root-regex-0.1.2.tgz
https://registry.yarnpkg.com/path-root/-/path-root-0.1.1.tgz -> yarnpkg-path-root-0.1.1.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.6.3.tgz -> yarnpkg-path-scurry-1.6.3.tgz
https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz -> yarnpkg-path-type-1.1.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/pathval/-/pathval-1.1.1.tgz -> yarnpkg-pathval-1.1.1.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-0.2.1.tgz -> yarnpkg-picocolors-0.2.1.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/plugin-error/-/plugin-error-0.1.2.tgz -> yarnpkg-plugin-error-0.1.2.tgz
https://registry.yarnpkg.com/plur/-/plur-4.0.0.tgz -> yarnpkg-plur-4.0.0.tgz
https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> yarnpkg-posix-character-classes-0.1.1.tgz
https://registry.yarnpkg.com/postcss/-/postcss-7.0.39.tgz -> yarnpkg-postcss-7.0.39.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz -> yarnpkg-pretty-hrtime-1.0.3.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz -> yarnpkg-pump-2.0.1.tgz
https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz -> yarnpkg-pumpify-1.5.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.1.tgz -> yarnpkg-qs-6.11.1.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/queue-tick/-/queue-tick-1.0.1.tgz -> yarnpkg-queue-tick-1.0.1.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> yarnpkg-read-pkg-up-1.0.1.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz -> yarnpkg-read-pkg-1.1.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz -> yarnpkg-readable-stream-1.1.14.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz -> yarnpkg-readable-stream-2.3.8.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz -> yarnpkg-readdirp-2.2.1.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.6.2.tgz -> yarnpkg-rechoir-0.6.2.tgz
https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz -> yarnpkg-regex-not-1.0.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/remove-bom-buffer/-/remove-bom-buffer-3.0.0.tgz -> yarnpkg-remove-bom-buffer-3.0.0.tgz
https://registry.yarnpkg.com/remove-bom-stream/-/remove-bom-stream-1.2.0.tgz -> yarnpkg-remove-bom-stream-1.2.0.tgz
https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> yarnpkg-remove-trailing-separator-1.1.0.tgz
https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.4.tgz -> yarnpkg-repeat-element-1.1.4.tgz
https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz -> yarnpkg-repeat-string-1.6.1.tgz
https://registry.yarnpkg.com/replace-ext/-/replace-ext-1.0.1.tgz -> yarnpkg-replace-ext-1.0.1.tgz
https://registry.yarnpkg.com/replace-ext/-/replace-ext-2.0.0.tgz -> yarnpkg-replace-ext-2.0.0.tgz
https://registry.yarnpkg.com/replace-homedir/-/replace-homedir-1.0.0.tgz -> yarnpkg-replace-homedir-1.0.0.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-1.0.1.tgz -> yarnpkg-require-main-filename-1.0.1.tgz
https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz -> yarnpkg-resolve-dir-1.0.1.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-options/-/resolve-options-1.1.0.tgz -> yarnpkg-resolve-options-1.1.0.tgz
https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz -> yarnpkg-resolve-url-0.2.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz -> yarnpkg-ret-0.1.15.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz -> yarnpkg-safe-regex-1.1.0.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/semver-greatest-satisfied-range/-/semver-greatest-satisfied-range-1.1.0.tgz -> yarnpkg-semver-greatest-satisfied-range-1.1.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> yarnpkg-serialize-javascript-6.0.0.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz -> yarnpkg-set-value-2.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz -> yarnpkg-slash-3.0.0.tgz
https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> yarnpkg-snapdragon-node-2.1.1.tgz
https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> yarnpkg-snapdragon-util-3.0.1.tgz
https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz -> yarnpkg-snapdragon-0.8.2.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> yarnpkg-source-map-resolve-0.5.3.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.6.0.tgz -> yarnpkg-source-map-resolve-0.6.0.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.1.tgz -> yarnpkg-source-map-url-0.4.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/sparkles/-/sparkles-1.0.1.tgz -> yarnpkg-sparkles-1.0.1.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> yarnpkg-spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz -> yarnpkg-split-string-3.1.0.tgz
https://registry.yarnpkg.com/stack-trace/-/stack-trace-0.0.10.tgz -> yarnpkg-stack-trace-0.0.10.tgz
https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz -> yarnpkg-static-extend-0.1.2.tgz
https://registry.yarnpkg.com/stream-exhaust/-/stream-exhaust-1.0.2.tgz -> yarnpkg-stream-exhaust-1.0.2.tgz
https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.1.tgz -> yarnpkg-stream-shift-1.0.1.tgz
https://registry.yarnpkg.com/streamqueue/-/streamqueue-0.0.6.tgz -> yarnpkg-streamqueue-0.0.6.tgz
https://registry.yarnpkg.com/streamx/-/streamx-2.13.2.tgz -> yarnpkg-streamx-2.13.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz -> yarnpkg-string_decoder-0.10.31.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom-string/-/strip-bom-string-1.0.0.tgz -> yarnpkg-strip-bom-string-1.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz -> yarnpkg-strip-bom-2.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/sver-compat/-/sver-compat-1.5.0.tgz -> yarnpkg-sver-compat-1.5.0.tgz
https://registry.yarnpkg.com/teex/-/teex-1.0.1.tgz -> yarnpkg-teex-1.0.1.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/through2-filter/-/through2-filter-3.0.0.tgz -> yarnpkg-through2-filter-3.0.0.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/through2/-/through2-3.0.2.tgz -> yarnpkg-through2-3.0.2.tgz
https://registry.yarnpkg.com/time-stamp/-/time-stamp-1.1.0.tgz -> yarnpkg-time-stamp-1.1.0.tgz
https://registry.yarnpkg.com/timers-ext/-/timers-ext-0.1.7.tgz -> yarnpkg-timers-ext-0.1.7.tgz
https://registry.yarnpkg.com/to-absolute-glob/-/to-absolute-glob-2.0.2.tgz -> yarnpkg-to-absolute-glob-2.0.2.tgz
https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz -> yarnpkg-to-object-path-0.3.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz -> yarnpkg-to-regex-range-2.1.1.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz -> yarnpkg-to-regex-3.0.2.tgz
https://registry.yarnpkg.com/to-through/-/to-through-2.0.0.tgz -> yarnpkg-to-through-2.0.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> yarnpkg-tsconfig-paths-3.14.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz -> yarnpkg-type-detect-4.0.8.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz -> yarnpkg-type-fest-0.20.2.tgz
https://registry.yarnpkg.com/type/-/type-1.2.0.tgz -> yarnpkg-type-1.2.0.tgz
https://registry.yarnpkg.com/type/-/type-2.7.2.tgz -> yarnpkg-type-2.7.2.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typed-rest-client/-/typed-rest-client-1.8.9.tgz -> yarnpkg-typed-rest-client-1.8.9.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.9.5.tgz -> yarnpkg-typescript-4.9.5.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> yarnpkg-unc-path-regex-0.1.2.tgz
https://registry.yarnpkg.com/underscore/-/underscore-1.13.6.tgz -> yarnpkg-underscore-1.13.6.tgz
https://registry.yarnpkg.com/undertaker-registry/-/undertaker-registry-1.0.1.tgz -> yarnpkg-undertaker-registry-1.0.1.tgz
https://registry.yarnpkg.com/undertaker/-/undertaker-1.3.0.tgz -> yarnpkg-undertaker-1.3.0.tgz
https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz -> yarnpkg-union-value-1.0.1.tgz
https://registry.yarnpkg.com/unique-stream/-/unique-stream-2.3.1.tgz -> yarnpkg-unique-stream-2.3.1.tgz
https://registry.yarnpkg.com/universal-user-agent/-/universal-user-agent-6.0.0.tgz -> yarnpkg-universal-user-agent-6.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz -> yarnpkg-unset-value-1.0.0.tgz
https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz -> yarnpkg-upath-1.2.0.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz -> yarnpkg-urix-0.1.0.tgz
https://registry.yarnpkg.com/use/-/use-3.1.1.tgz -> yarnpkg-use-3.1.1.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/v8flags/-/v8flags-3.2.0.tgz -> yarnpkg-v8flags-3.2.0.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/value-or-function/-/value-or-function-3.0.0.tgz -> yarnpkg-value-or-function-3.0.0.tgz
https://registry.yarnpkg.com/vinyl-fs/-/vinyl-fs-3.0.3.tgz -> yarnpkg-vinyl-fs-3.0.3.tgz
https://registry.yarnpkg.com/vinyl-sourcemap/-/vinyl-sourcemap-1.1.0.tgz -> yarnpkg-vinyl-sourcemap-1.1.0.tgz
https://registry.yarnpkg.com/vinyl/-/vinyl-2.2.1.tgz -> yarnpkg-vinyl-2.2.1.tgz
https://registry.yarnpkg.com/vinyl/-/vinyl-3.0.0.tgz -> yarnpkg-vinyl-3.0.0.tgz
https://registry.yarnpkg.com/web-streams-polyfill/-/web-streams-polyfill-3.2.1.tgz -> yarnpkg-web-streams-polyfill-3.2.1.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-module/-/which-module-1.0.0.tgz -> yarnpkg-which-module-1.0.0.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/workerpool/-/workerpool-6.2.1.tgz -> yarnpkg-workerpool-6.2.1.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> yarnpkg-wrap-ansi-2.1.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.23.tgz -> yarnpkg-xml2js-0.4.23.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> yarnpkg-xmlbuilder-11.0.1.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz -> yarnpkg-xtend-4.0.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-3.2.2.tgz -> yarnpkg-y18n-3.2.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.4.tgz -> yarnpkg-yargs-parser-20.2.4.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-5.0.1.tgz -> yarnpkg-yargs-parser-5.0.1.tgz
https://registry.yarnpkg.com/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> yarnpkg-yargs-unparser-2.0.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-7.1.2.tgz -> yarnpkg-yargs-7.1.2.tgz
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
