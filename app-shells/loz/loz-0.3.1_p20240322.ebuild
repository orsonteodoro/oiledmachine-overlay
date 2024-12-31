# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="55d6998a48eeedc92c3789ba96bea55e3f6cd15f"
NODE_VERSION=20
NPM_EXE_LIST="
/opt/loz/dist/index.js
/opt/loz/node_modules/rimraf/bin.js
/opt/loz/node_modules/typescript/bin/tsc
/opt/loz/node_modules/typescript/bin/tsserver
/opt/loz/node_modules/eslint/bin/eslint.js
/opt/loz/node_modules/@cspotcode/source-map-support/register.d.ts
/opt/loz/node_modules/@cspotcode/source-map-support/source-map-support.d.ts
/opt/loz/node_modules/@cspotcode/source-map-support/register-hook-require.d.ts
/opt/loz/node_modules/ts-node/dist/bin.js
/opt/loz/node_modules/ts-node/dist/bin-esm.js
/opt/loz/node_modules/ts-node/dist/bin-transpile.js
/opt/loz/node_modules/ts-node/dist/bin-cwd.js
/opt/loz/node_modules/ts-node/dist/bin-script-deprecated.js
/opt/loz/node_modules/ts-node/dist/bin-script.js
/opt/loz/node_modules/acorn/bin/acorn
/opt/loz/node_modules/esrecurse/package.json
/opt/loz/node_modules/semver/bin/semver.js
/opt/loz/node_modules/prettier/bin/prettier.cjs
/opt/loz/node_modules/openai/bin/cli
/opt/loz/node_modules/which/bin/node-which
/opt/loz/node_modules/he/bin/he
/opt/loz/node_modules/uri-js/yarn.lock
/opt/loz/node_modules/uri-js/dist/es5/uri.all.js
/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.js
/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.js.map
/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.d.ts
/opt/loz/node_modules/uri-js/dist/es5/uri.all.js.map
/opt/loz/node_modules/uri-js/dist/es5/uri.all.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.js
/opt/loz/node_modules/uri-js/dist/esnext/index.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/util.js.map
/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/uri.js.map
/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/uri.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/index.js
/opt/loz/node_modules/uri-js/dist/esnext/util.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.js.map
/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.js
/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.js
/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.js
/opt/loz/node_modules/uri-js/dist/esnext/index.js.map
/opt/loz/node_modules/uri-js/dist/esnext/uri.js
/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.js.map
/opt/loz/node_modules/uri-js/dist/esnext/util.d.ts
/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.js.map
/opt/loz/node_modules/uri-js/LICENSE
/opt/loz/node_modules/uri-js/README.md
/opt/loz/node_modules/uri-js/package.json
/opt/loz/node_modules/queue-microtask/LICENSE
/opt/loz/node_modules/js-yaml/bin/js-yaml.js
/opt/loz/node_modules/flat/cli.js
/opt/loz/node_modules/wrap-ansi/index.js
/opt/loz/node_modules/micromatch/LICENSE
/opt/loz/node_modules/mock-stdin/test/stdin.spec.js
/opt/loz/node_modules/mock-stdin/lib/index.d.ts
/opt/loz/node_modules/mock-stdin/lib/mock/stdin.js
/opt/loz/node_modules/mock-stdin/lib/index.js
/opt/loz/node_modules/mock-stdin/LICENSE
/opt/loz/node_modules/mock-stdin/README.md
/opt/loz/node_modules/mock-stdin/package.json
/opt/loz/node_modules/mock-stdin/tools/travis.sh
/opt/loz/node_modules/mock-stdin/.travis.yml
/opt/loz/node_modules/mocha/lib/cli/cli.js
/opt/loz/node_modules/mocha/bin/_mocha
/opt/loz/node_modules/mocha/bin/mocha.js
/opt/loz/install.sh
/opt/loz/scripts/prepare-commit-msg
/opt/loz/tools/git_scripts/pre-commit
/opt/loz/bump_version.sh
"
NPM_TARBALL="${P}-${EGIT_COMMIT:0:7}.tar.gz"

inherit git-r3 npm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.11.1.tgz -> npmpkg-@eslint-community-regexpp-4.11.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> npmpkg-@eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.57.1.tgz -> npmpkg-@eslint-js-8.57.1.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.13.0.tgz -> npmpkg-@humanwhocodes-config-array-0.13.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz -> npmpkg-@humanwhocodes-object-schema-2.0.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.11.tgz -> npmpkg-@tsconfig-node10-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@types/chai/-/chai-4.3.20.tgz -> npmpkg-@types-chai-4.3.20.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-10.0.9.tgz -> npmpkg-@types-mocha-10.0.9.tgz
https://registry.npmjs.org/@types/node/-/node-20.11.28.tgz -> npmpkg-@types-node-20.11.28.tgz
https://registry.npmjs.org/@types/node-fetch/-/node-fetch-2.6.11.tgz -> npmpkg-@types-node-fetch-2.6.11.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.33.tgz -> npmpkg-@types-yargs-17.0.33.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.3.tgz -> npmpkg-@types-yargs-parser-21.0.3.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-7.18.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-7.18.0.tgz -> npmpkg-@typescript-eslint-parser-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-7.18.0.tgz -> npmpkg-@typescript-eslint-scope-manager-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-7.18.0.tgz -> npmpkg-@typescript-eslint-type-utils-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-7.18.0.tgz -> npmpkg-@typescript-eslint-types-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-7.18.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-7.18.0.tgz -> npmpkg-@typescript-eslint-utils-7.18.0.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-7.18.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-7.18.0.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/abort-controller/-/abort-controller-3.0.0.tgz -> npmpkg-abort-controller-3.0.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.13.0.tgz -> npmpkg-acorn-8.13.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.4.tgz -> npmpkg-acorn-walk-8.3.4.tgz
https://registry.npmjs.org/agentkeepalive/-/agentkeepalive-4.5.0.tgz -> npmpkg-agentkeepalive-4.5.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.3.tgz -> npmpkg-ansi-colors-4.1.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-1.1.0.tgz -> npmpkg-assertion-error-1.1.0.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/browser-stdout/-/browser-stdout-1.3.1.tgz -> npmpkg-browser-stdout-1.3.1.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chai/-/chai-4.5.0.tgz -> npmpkg-chai-4.5.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/check-error/-/check-error-1.0.3.tgz -> npmpkg-check-error-1.0.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decamelize/-/decamelize-4.0.0.tgz -> npmpkg-decamelize-4.0.0.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-4.1.4.tgz -> npmpkg-deep-eql-4.1.4.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/diff/-/diff-5.2.0.tgz -> npmpkg-diff-5.2.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.57.1.tgz -> npmpkg-eslint-8.57.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.6.0.tgz -> npmpkg-esquery-1.6.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/event-target-shim/-/event-target-shim-5.0.1.tgz -> npmpkg-event-target-shim-5.0.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz -> npmpkg-flat-cache-3.2.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.3.1.tgz -> npmpkg-flatted-3.3.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.1.tgz -> npmpkg-form-data-4.0.1.tgz
https://registry.npmjs.org/form-data-encoder/-/form-data-encoder-1.7.2.tgz -> npmpkg-form-data-encoder-1.7.2.tgz
https://registry.npmjs.org/formdata-node/-/formdata-node-4.4.1.tgz -> npmpkg-formdata-node-4.4.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz -> npmpkg-get-func-name-2.0.2.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz -> npmpkg-graphemer-1.4.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/humanize-ms/-/humanize-ms-1.2.1.tgz -> npmpkg-humanize-ms-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz -> npmpkg-ignore-5.3.2.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> npmpkg-is-plain-obj-2.1.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/loupe/-/loupe-2.3.7.tgz -> npmpkg-loupe-2.3.7.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/mocha/-/mocha-10.7.3.tgz -> npmpkg-mocha-10.7.3.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/mock-stdin/-/mock-stdin-1.0.0.tgz -> npmpkg-mock-stdin-1.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/node-domexception/-/node-domexception-1.0.0.tgz -> npmpkg-node-domexception-1.0.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz -> npmpkg-node-fetch-2.7.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/ollama-node/-/ollama-node-0.1.28.tgz -> npmpkg-ollama-node-0.1.28.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/openai/-/openai-4.67.3.tgz -> npmpkg-openai-4.67.3.tgz
https://registry.npmjs.org/@types/node/-/node-18.19.55.tgz -> npmpkg-@types-node-18.19.55.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz -> npmpkg-optionator-0.9.4.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pathval/-/pathval-1.1.1.tgz -> npmpkg-pathval-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-3.3.3.tgz -> npmpkg-prettier-3.3.3.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-1.3.0.tgz -> npmpkg-ts-api-utils-1.3.0.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.2.tgz -> npmpkg-ts-node-10.9.2.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.1.0.tgz -> npmpkg-type-detect-4.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/typescript/-/typescript-5.6.3.tgz -> npmpkg-typescript-5.6.3.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/web-streams-polyfill/-/web-streams-polyfill-4.0.0-beta.3.tgz -> npmpkg-web-streams-polyfill-4.0.0-beta.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/workerpool/-/workerpool-6.5.1.tgz -> npmpkg-workerpool-6.5.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> npmpkg-yargs-unparser-2.0.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/joone/loz/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Loz is a command-line tool that enables your preferred LLM to execute system commands and utilize Unix pipes, integrating AI capabilities with other Unix tools."
LICENSE="
	(
		Apache-2.0
		BSD
		BSD-2
		ISC
		MIT
	)
	(
		CC-BY-4.0
		custom
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		CC-BY-SA-4.0
		ISC
	)
	(
		CC0-1.0
		MIT
	)
	Apache-2.0
	BSD
	BSD-2
	ISC
	MIT
	PSF-2.2
"
# Apache-2.0 - ./node_modules/eslint-visitor-keys/LICENSE
# Apache-2.0 BSD BSD-2 ISC MIT - ./node_modules/prettier/LICENSE
# BSD-2 - ./node_modules/eslint-scope/LICENSE
# BSD - ./node_modules/ts-node/node_modules/diff/LICENSE
# CC-BY-SA-4.0 ISC - ./node_modules/rimraf/node_modules/glob/LICENSE
# CC0-1.0 MIT - ./node_modules/lodash.merge/LICENSE
# ISC - ./node_modules/rimraf/node_modules/minimatch/LICENSE
# MIT - ./node_modules/dir-glob/license
# PSF-2.2 - ./node_modules/argparse/LICENSE
# CC-BY-4.0 custom MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement W3C-Software-and-Document-Notice-and-License - ./node_modules/typescript/ThirdPartyNoticeText.txt
HOMEPAGE="https://github.com/joone/loz"
SLOT="0"
IUSE="codellama llama2 ollama"
REQUIRED_USE="
	ollama? (
		|| (
			codellama
			llama2
		)
	)
"
RDEPEND="
	ollama? (
		codellama? (
			app-misc/ollama[ollama_llms_codellama]
		)
		llama2? (
			app-misc/ollama[ollama_llms_llama2]
		)
	)
"
RESTRICT="mirror"
DOCS=( "README.md" )

npm_update_lock_audit_post() {
	# Fix breaking changes
	enpm add "@types/node@20.11.28" -D
}

src_unpack() {
	npm_src_unpack
}

configure_ollama_support() {
	local name
# Sort by security benchmark score.
	if use llama2 ; then
		name="llama2"
	elif use codellama ; then
		name="codellama"
	else
		name="llama2"
	fi
	sed \
		-i \
		-e "s|DEFAULT_OLLAMA_MODEL = \"llama2\"|DEFAULT_OLLAMA_MODEL = \"${name}\"|g" \
		"src/config/index.ts" \
		|| die
}

src_prepare() {
	default
	if use ollama ; then
		configure_ollama_support
	fi
}

pkg_postinst() {
	if use ollama ; then
		if use codellama ; then
einfo "You still need to download the model, run \`ollama run codellama\` to install."
		fi
		if use llama2 ; then
einfo "You still need to download the model, run \`ollama run llama2\` to install."
		fi
einfo
einfo "You can change the values of ollama.model and model in"
einfo "\"~/.loz/config.json\" to either llama2 or codellama."
einfo
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  TESTING (0.3.1_p20240322, 20241201)
# ls | loz "all rows uppercase" (with yi-coder:1.5b) - failed (produces junk on the top of output and bottom)
# ls | loz "all rows uppercase" (with llama3.2:1b-text-q5_1) - failed (the model variant is poor quality)
