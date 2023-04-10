# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# FIXME: broken unpack time
# FIXME: broken runtime

EAPI=8

MY_PN="${PN^}"

YARN_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${PN}_${PV}_amd64.snap"
ELECTRON_APP_ELECTRON_PV="21.2.3"
ELECTRON_APP_TYPESCRIPT_PV="4.8.4"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
NODE_VERSION=16
NODE_ENV=development
ELECTRON_APP_ELECTRON_PV="21.4.4"

inherit desktop electron-app lcnr yarn

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

KEYWORDS="~amd64"
SLOT="0"
# Deps based on their CI
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-16[npm]
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/net-im/caprine-2.57.0/work/caprine-2.57.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.1.1.tgz -> yarnpkg-7zip-bin-5.1.1.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.21.4.tgz -> yarnpkg-@babel-code-frame-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz -> yarnpkg-@babel-helper-validator-identifier-7.19.1.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz -> yarnpkg-@babel-highlight-7.18.6.tgz
https://registry.yarnpkg.com/@colors/colors/-/colors-1.5.0.tgz -> yarnpkg-@colors-colors-1.5.0.tgz
https://registry.yarnpkg.com/@csstools/selector-specificity/-/selector-specificity-2.2.0.tgz -> yarnpkg-@csstools-selector-specificity-2.2.0.tgz
https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> yarnpkg-@develar-schema-utils-2.6.5.tgz
https://registry.yarnpkg.com/@electron/get/-/get-1.14.1.tgz -> yarnpkg-@electron-get-1.14.1.tgz
https://registry.yarnpkg.com/@electron/get/-/get-2.0.2.tgz -> yarnpkg-@electron-get-2.0.2.tgz
https://registry.yarnpkg.com/@electron/remote/-/remote-2.0.9.tgz -> yarnpkg-@electron-remote-2.0.9.tgz
https://registry.yarnpkg.com/@electron/universal/-/universal-1.2.1.tgz -> yarnpkg-@electron-universal-1.2.1.tgz
https://registry.yarnpkg.com/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> yarnpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.yarnpkg.com/@eslint-community/regexpp/-/regexpp-4.5.0.tgz -> yarnpkg-@eslint-community-regexpp-4.5.0.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-1.4.1.tgz -> yarnpkg-@eslint-eslintrc-1.4.1.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-2.0.2.tgz -> yarnpkg-@eslint-eslintrc-2.0.2.tgz
https://registry.yarnpkg.com/@eslint/js/-/js-8.38.0.tgz -> yarnpkg-@eslint-js-8.38.0.tgz
https://registry.yarnpkg.com/@gar/promisify/-/promisify-1.1.3.tgz -> yarnpkg-@gar-promisify-1.1.3.tgz
https://registry.yarnpkg.com/@humanwhocodes/config-array/-/config-array-0.11.8.tgz -> yarnpkg-@humanwhocodes-config-array-0.11.8.tgz
https://registry.yarnpkg.com/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> yarnpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.yarnpkg.com/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz -> yarnpkg-@humanwhocodes-object-schema-1.2.1.tgz
https://registry.yarnpkg.com/@leichtgewicht/ip-codec/-/ip-codec-2.0.4.tgz -> yarnpkg-@leichtgewicht-ip-codec-2.0.4.tgz
https://registry.yarnpkg.com/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> yarnpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.yarnpkg.com/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> yarnpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-2.1.2.tgz -> yarnpkg-@npmcli-fs-2.1.2.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-3.1.0.tgz -> yarnpkg-@npmcli-fs-3.1.0.tgz
https://registry.yarnpkg.com/@npmcli/git/-/git-4.0.4.tgz -> yarnpkg-@npmcli-git-4.0.4.tgz
https://registry.yarnpkg.com/@npmcli/installed-package-contents/-/installed-package-contents-2.0.2.tgz -> yarnpkg-@npmcli-installed-package-contents-2.0.2.tgz
https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-2.0.1.tgz -> yarnpkg-@npmcli-move-file-2.0.1.tgz
https://registry.yarnpkg.com/@npmcli/node-gyp/-/node-gyp-3.0.0.tgz -> yarnpkg-@npmcli-node-gyp-3.0.0.tgz
https://registry.yarnpkg.com/@npmcli/promise-spawn/-/promise-spawn-6.0.2.tgz -> yarnpkg-@npmcli-promise-spawn-6.0.2.tgz
https://registry.yarnpkg.com/@npmcli/run-script/-/run-script-6.0.0.tgz -> yarnpkg-@npmcli-run-script-6.0.0.tgz
https://registry.yarnpkg.com/@pnpm/config.env-replace/-/config.env-replace-1.1.0.tgz -> yarnpkg-@pnpm-config.env-replace-1.1.0.tgz
https://registry.yarnpkg.com/@pnpm/network.ca-file/-/network.ca-file-1.0.2.tgz -> yarnpkg-@pnpm-network.ca-file-1.0.2.tgz
https://registry.yarnpkg.com/@pnpm/npm-conf/-/npm-conf-2.1.1.tgz -> yarnpkg-@pnpm-npm-conf-2.1.1.tgz
https://registry.yarnpkg.com/@samverschueren/stream-to-observable/-/stream-to-observable-0.3.1.tgz -> yarnpkg-@samverschueren-stream-to-observable-0.3.1.tgz
https://registry.yarnpkg.com/@sigstore/protobuf-specs/-/protobuf-specs-0.1.0.tgz -> yarnpkg-@sigstore-protobuf-specs-0.1.0.tgz
https://registry.yarnpkg.com/@sindresorhus/do-not-disturb/-/do-not-disturb-1.1.0.tgz -> yarnpkg-@sindresorhus-do-not-disturb-1.1.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.14.0.tgz -> yarnpkg-@sindresorhus-is-0.14.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-2.1.1.tgz -> yarnpkg-@sindresorhus-is-2.1.1.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-4.6.0.tgz -> yarnpkg-@sindresorhus-is-4.6.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-5.3.0.tgz -> yarnpkg-@sindresorhus-is-5.3.0.tgz
https://registry.yarnpkg.com/@sindresorhus/tsconfig/-/tsconfig-0.7.0.tgz -> yarnpkg-@sindresorhus-tsconfig-0.7.0.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> yarnpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> yarnpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-5.0.1.tgz -> yarnpkg-@szmarczak-http-timer-5.0.1.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-2.0.0.tgz -> yarnpkg-@tootallnate-once-2.0.0.tgz
https://registry.yarnpkg.com/@tufjs/models/-/models-1.0.1.tgz -> yarnpkg-@tufjs-models-1.0.1.tgz
https://registry.yarnpkg.com/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> yarnpkg-@types-cacheable-request-6.0.3.tgz
https://registry.yarnpkg.com/@types/debug/-/debug-4.1.7.tgz -> yarnpkg-@types-debug-4.1.7.tgz
https://registry.yarnpkg.com/@types/electron-localshortcut/-/electron-localshortcut-3.1.0.tgz -> yarnpkg-@types-electron-localshortcut-3.1.0.tgz
https://registry.yarnpkg.com/@types/eslint/-/eslint-7.29.0.tgz -> yarnpkg-@types-eslint-7.29.0.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.0.tgz -> yarnpkg-@types-estree-1.0.0.tgz
https://registry.yarnpkg.com/@types/facebook-locales/-/facebook-locales-1.0.0.tgz -> yarnpkg-@types-facebook-locales-1.0.0.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz -> yarnpkg-@types-fs-extra-9.0.13.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz -> yarnpkg-@types-glob-7.2.0.tgz
https://registry.yarnpkg.com/@types/http-cache-semantics/-/http-cache-semantics-4.0.1.tgz -> yarnpkg-@types-http-cache-semantics-4.0.1.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/@types/keyv/-/keyv-3.1.4.tgz -> yarnpkg-@types-keyv-3.1.4.tgz
https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.192.tgz -> yarnpkg-@types-lodash-4.14.192.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.2.tgz -> yarnpkg-@types-minimist-1.2.2.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz -> yarnpkg-@types-ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.15.11.tgz -> yarnpkg-@types-node-18.15.11.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.18.23.tgz -> yarnpkg-@types-node-16.18.23.tgz
https://registry.yarnpkg.com/@types/normalize-package-data/-/normalize-package-data-2.4.1.tgz -> yarnpkg-@types-normalize-package-data-2.4.1.tgz
https://registry.yarnpkg.com/@types/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-@types-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/@types/plist/-/plist-3.0.2.tgz -> yarnpkg-@types-plist-3.0.2.tgz
https://registry.yarnpkg.com/@types/responselike/-/responselike-1.0.0.tgz -> yarnpkg-@types-responselike-1.0.0.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.3.13.tgz -> yarnpkg-@types-semver-7.3.13.tgz
https://registry.yarnpkg.com/@types/verror/-/verror-1.10.6.tgz -> yarnpkg-@types-verror-1.10.6.tgz
https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-21.0.0.tgz -> yarnpkg-@types-yargs-parser-21.0.0.tgz
https://registry.yarnpkg.com/@types/yargs/-/yargs-17.0.24.tgz -> yarnpkg-@types-yargs-17.0.24.tgz
https://registry.yarnpkg.com/@types/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-@types-yauzl-2.10.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.57.1.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-5.57.1.tgz -> yarnpkg-@typescript-eslint-parser-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-5.57.1.tgz -> yarnpkg-@typescript-eslint-scope-manager-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/type-utils/-/type-utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-type-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-5.57.1.tgz -> yarnpkg-@typescript-eslint-types-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-5.57.1.tgz -> yarnpkg-@typescript-eslint-typescript-estree-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/utils/-/utils-5.57.1.tgz -> yarnpkg-@typescript-eslint-utils-5.57.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-5.57.1.tgz -> yarnpkg-@typescript-eslint-visitor-keys-5.57.1.tgz
https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> yarnpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> yarnpkg-acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.8.2.tgz -> yarnpkg-acorn-8.8.2.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/agentkeepalive/-/agentkeepalive-4.3.0.tgz -> yarnpkg-agentkeepalive-4.3.0.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-4.0.1.tgz -> yarnpkg-aggregate-error-4.0.1.tgz
https://registry.yarnpkg.com/ajv-formats/-/ajv-formats-2.1.1.tgz -> yarnpkg-ajv-formats-2.1.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.12.0.tgz -> yarnpkg-ajv-8.12.0.tgz
https://registry.yarnpkg.com/ansi-align/-/ansi-align-3.0.1.tgz -> yarnpkg-ansi-align-3.0.1.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> yarnpkg-ansi-escapes-3.2.0.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> yarnpkg-ansi-escapes-4.3.2.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.1.tgz -> yarnpkg-ansi-regex-3.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.1.tgz -> yarnpkg-ansi-regex-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-6.0.1.tgz -> yarnpkg-ansi-regex-6.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz -> yarnpkg-ansi-styles-2.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-6.2.1.tgz -> yarnpkg-ansi-styles-6.2.1.tgz
https://registry.yarnpkg.com/any-observable/-/any-observable-0.3.0.tgz -> yarnpkg-any-observable-0.3.0.tgz
https://registry.yarnpkg.com/any-observable/-/any-observable-0.5.1.tgz -> yarnpkg-any-observable-0.5.1.tgz
https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> yarnpkg-app-builder-bin-4.0.0.tgz
https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-23.6.0.tgz -> yarnpkg-app-builder-lib-23.6.0.tgz
https://registry.yarnpkg.com/aproba/-/aproba-2.0.0.tgz -> yarnpkg-aproba-2.0.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-3.0.1.tgz -> yarnpkg-are-we-there-yet-3.0.1.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-find/-/array-find-1.0.0.tgz -> yarnpkg-array-find-1.0.0.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz -> yarnpkg-array-includes-3.1.6.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> yarnpkg-array.prototype.flat-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> yarnpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz -> yarnpkg-arrify-1.0.1.tgz
https://registry.yarnpkg.com/arrify/-/arrify-3.0.0.tgz -> yarnpkg-arrify-3.0.0.tgz
https://registry.yarnpkg.com/asar/-/asar-3.2.0.tgz -> yarnpkg-asar-3.2.0.tgz
https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz -> yarnpkg-assert-plus-1.0.0.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> yarnpkg-async-exit-hook-2.0.1.tgz
https://registry.yarnpkg.com/async/-/async-3.2.4.tgz -> yarnpkg-async-3.2.4.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/atomically/-/atomically-1.7.0.tgz -> yarnpkg-atomically-1.7.0.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-2.0.0.tgz -> yarnpkg-balanced-match-2.0.0.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> yarnpkg-bluebird-lst-1.0.9.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz -> yarnpkg-boolean-3.2.0.tgz
https://registry.yarnpkg.com/boxen/-/boxen-5.1.2.tgz -> yarnpkg-boxen-5.1.2.tgz
https://registry.yarnpkg.com/boxen/-/boxen-7.0.2.tgz -> yarnpkg-boxen-7.0.2.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
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
https://registry.yarnpkg.com/builtins/-/builtins-1.0.3.tgz -> yarnpkg-builtins-1.0.3.tgz
https://registry.yarnpkg.com/builtins/-/builtins-5.0.1.tgz -> yarnpkg-builtins-5.0.1.tgz
https://registry.yarnpkg.com/cacache/-/cacache-16.1.3.tgz -> yarnpkg-cacache-16.1.3.tgz
https://registry.yarnpkg.com/cacache/-/cacache-17.0.5.tgz -> yarnpkg-cacache-17.0.5.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-2.0.1.tgz -> yarnpkg-cacheable-lookup-2.0.1.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> yarnpkg-cacheable-lookup-5.0.4.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-7.0.0.tgz -> yarnpkg-cacheable-lookup-7.0.0.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-10.2.9.tgz -> yarnpkg-cacheable-request-10.2.9.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-6.1.0.tgz -> yarnpkg-cacheable-request-6.1.0.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-7.0.2.tgz -> yarnpkg-cacheable-request-7.0.2.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> yarnpkg-camelcase-keys-6.2.2.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-7.0.2.tgz -> yarnpkg-camelcase-keys-7.0.2.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-6.3.0.tgz -> yarnpkg-camelcase-6.3.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-7.0.1.tgz -> yarnpkg-camelcase-7.0.1.tgz
https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz -> yarnpkg-chalk-1.1.3.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-5.2.0.tgz -> yarnpkg-chalk-5.2.0.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz -> yarnpkg-chownr-2.0.0.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> yarnpkg-chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-3.8.0.tgz -> yarnpkg-ci-info-3.8.0.tgz
https://registry.yarnpkg.com/clean-regexp/-/clean-regexp-1.0.0.tgz -> yarnpkg-clean-regexp-1.0.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-4.2.0.tgz -> yarnpkg-clean-stack-4.2.0.tgz
https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-2.2.1.tgz -> yarnpkg-cli-boxes-2.2.1.tgz
https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-3.0.0.tgz -> yarnpkg-cli-boxes-3.0.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-2.1.0.tgz -> yarnpkg-cli-cursor-2.1.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-3.1.0.tgz -> yarnpkg-cli-cursor-3.1.0.tgz
https://registry.yarnpkg.com/cli-table3/-/cli-table3-0.6.3.tgz -> yarnpkg-cli-table3-0.6.3.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-0.2.1.tgz -> yarnpkg-cli-truncate-0.2.1.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz -> yarnpkg-cli-truncate-2.1.0.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-2.2.1.tgz -> yarnpkg-cli-width-2.2.1.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-3.0.0.tgz -> yarnpkg-cli-width-3.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-8.0.1.tgz -> yarnpkg-cliui-8.0.1.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz -> yarnpkg-clone-response-1.0.3.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/colord/-/colord-2.9.3.tgz -> yarnpkg-colord-2.9.3.tgz
https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz -> yarnpkg-colors-1.0.3.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.9.0.tgz -> yarnpkg-commander-2.9.0.tgz
https://registry.yarnpkg.com/commander/-/commander-10.0.0.tgz -> yarnpkg-commander-10.0.0.tgz
https://registry.yarnpkg.com/commander/-/commander-5.1.0.tgz -> yarnpkg-commander-5.1.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/compare-version/-/compare-version-0.1.2.tgz -> yarnpkg-compare-version-0.1.2.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/conf/-/conf-10.2.0.tgz -> yarnpkg-conf-10.2.0.tgz
https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.13.tgz -> yarnpkg-config-chain-1.1.13.tgz
https://registry.yarnpkg.com/configstore/-/configstore-5.0.1.tgz -> yarnpkg-configstore-5.0.1.tgz
https://registry.yarnpkg.com/configstore/-/configstore-6.0.0.tgz -> yarnpkg-configstore-6.0.0.tgz
https://registry.yarnpkg.com/confusing-browser-globals/-/confusing-browser-globals-1.0.11.tgz -> yarnpkg-confusing-browser-globals-1.0.11.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> yarnpkg-cosmiconfig-7.1.0.tgz
https://registry.yarnpkg.com/crc/-/crc-3.8.0.tgz -> yarnpkg-crc-3.8.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> yarnpkg-crypto-random-string-2.0.0.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-4.0.0.tgz -> yarnpkg-crypto-random-string-4.0.0.tgz
https://registry.yarnpkg.com/css-functions-list/-/css-functions-list-3.1.0.tgz -> yarnpkg-css-functions-list-3.1.0.tgz
https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz -> yarnpkg-cssesc-3.0.0.tgz
https://registry.yarnpkg.com/date-fns/-/date-fns-1.30.1.tgz -> yarnpkg-date-fns-1.30.1.tgz
https://registry.yarnpkg.com/debounce-fn/-/debounce-fn-4.0.0.tgz -> yarnpkg-debounce-fn-4.0.0.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> yarnpkg-decamelize-keys-1.1.1.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-5.0.1.tgz -> yarnpkg-decamelize-5.0.1.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz -> yarnpkg-decompress-response-3.3.0.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-5.0.0.tgz -> yarnpkg-decompress-response-5.0.0.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz -> yarnpkg-decompress-response-6.0.0.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> yarnpkg-defer-to-connect-1.1.3.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> yarnpkg-defer-to-connect-2.0.1.tgz
https://registry.yarnpkg.com/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> yarnpkg-define-lazy-prop-2.0.0.tgz
https://registry.yarnpkg.com/define-lazy-prop/-/define-lazy-prop-3.0.0.tgz -> yarnpkg-define-lazy-prop-3.0.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/del-cli/-/del-cli-5.0.0.tgz -> yarnpkg-del-cli-5.0.0.tgz
https://registry.yarnpkg.com/del/-/del-6.1.1.tgz -> yarnpkg-del-6.1.1.tgz
https://registry.yarnpkg.com/del/-/del-7.0.0.tgz -> yarnpkg-del-7.0.0.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz -> yarnpkg-depd-2.0.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/dir-compare/-/dir-compare-2.4.0.tgz -> yarnpkg-dir-compare-2.4.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-23.6.0.tgz -> yarnpkg-dmg-builder-23.6.0.tgz
https://registry.yarnpkg.com/dmg-license/-/dmg-license-1.0.11.tgz -> yarnpkg-dmg-license-1.0.11.tgz
https://registry.yarnpkg.com/dns-packet/-/dns-packet-5.5.0.tgz -> yarnpkg-dns-packet-5.5.0.tgz
https://registry.yarnpkg.com/dns-socket/-/dns-socket-4.2.2.tgz -> yarnpkg-dns-socket-4.2.2.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-5.3.0.tgz -> yarnpkg-dot-prop-5.3.0.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-6.0.1.tgz -> yarnpkg-dot-prop-6.0.1.tgz
https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> yarnpkg-dotenv-expand-5.1.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-9.0.2.tgz -> yarnpkg-dotenv-9.0.2.tgz
https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.5.tgz -> yarnpkg-duplexer3-0.1.5.tgz
https://registry.yarnpkg.com/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> yarnpkg-eastasianwidth-0.2.0.tgz
https://registry.yarnpkg.com/ejs/-/ejs-3.1.9.tgz -> yarnpkg-ejs-3.1.9.tgz
https://registry.yarnpkg.com/electron-better-ipc/-/electron-better-ipc-2.0.1.tgz -> yarnpkg-electron-better-ipc-2.0.1.tgz
https://registry.yarnpkg.com/electron-builder/-/electron-builder-23.6.0.tgz -> yarnpkg-electron-builder-23.6.0.tgz
https://registry.yarnpkg.com/electron-context-menu/-/electron-context-menu-3.6.1.tgz -> yarnpkg-electron-context-menu-3.6.1.tgz
https://registry.yarnpkg.com/electron-debug/-/electron-debug-3.2.0.tgz -> yarnpkg-electron-debug-3.2.0.tgz
https://registry.yarnpkg.com/electron-dl/-/electron-dl-3.5.0.tgz -> yarnpkg-electron-dl-3.5.0.tgz
https://registry.yarnpkg.com/electron-is-accelerator/-/electron-is-accelerator-0.1.2.tgz -> yarnpkg-electron-is-accelerator-0.1.2.tgz
https://registry.yarnpkg.com/electron-is-dev/-/electron-is-dev-1.2.0.tgz -> yarnpkg-electron-is-dev-1.2.0.tgz
https://registry.yarnpkg.com/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> yarnpkg-electron-is-dev-2.0.0.tgz
https://registry.yarnpkg.com/electron-localshortcut/-/electron-localshortcut-3.2.1.tgz -> yarnpkg-electron-localshortcut-3.2.1.tgz
https://registry.yarnpkg.com/electron-osx-sign/-/electron-osx-sign-0.6.0.tgz -> yarnpkg-electron-osx-sign-0.6.0.tgz
https://registry.yarnpkg.com/electron-publish/-/electron-publish-23.6.0.tgz -> yarnpkg-electron-publish-23.6.0.tgz
https://registry.yarnpkg.com/electron-store/-/electron-store-8.1.0.tgz -> yarnpkg-electron-store-8.1.0.tgz
https://registry.yarnpkg.com/electron-updater/-/electron-updater-5.3.0.tgz -> yarnpkg-electron-updater-5.3.0.tgz
https://registry.yarnpkg.com/electron-util/-/electron-util-0.12.3.tgz -> yarnpkg-electron-util-0.12.3.tgz
https://registry.yarnpkg.com/electron-util/-/electron-util-0.17.2.tgz -> yarnpkg-electron-util-0.17.2.tgz
https://registry.yarnpkg.com/electron/-/electron-24.0.0.tgz -> yarnpkg-electron-24.0.0.tgz
https://registry.yarnpkg.com/electron/-/electron-21.4.4.tgz -> yarnpkg-electron-21.4.4.tgz
https://registry.yarnpkg.com/elegant-spinner/-/elegant-spinner-1.0.1.tgz -> yarnpkg-elegant-spinner-1.0.1.tgz
https://registry.yarnpkg.com/element-ready/-/element-ready-5.0.0.tgz -> yarnpkg-element-ready-5.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-9.2.2.tgz -> yarnpkg-emoji-regex-9.2.2.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/encoding/-/encoding-0.1.13.tgz -> yarnpkg-encoding-0.1.13.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhance-visitors/-/enhance-visitors-1.0.0.tgz -> yarnpkg-enhance-visitors-1.0.0.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-0.9.1.tgz -> yarnpkg-enhanced-resolve-0.9.1.tgz
https://registry.yarnpkg.com/env-editor/-/env-editor-1.1.0.tgz -> yarnpkg-env-editor-1.1.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/err-code/-/err-code-2.0.3.tgz -> yarnpkg-err-code-2.0.3.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> yarnpkg-es-shim-unscopables-1.0.0.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-goat/-/escape-goat-2.1.1.tgz -> yarnpkg-escape-goat-2.1.1.tgz
https://registry.yarnpkg.com/escape-goat/-/escape-goat-3.0.0.tgz -> yarnpkg-escape-goat-3.0.0.tgz
https://registry.yarnpkg.com/escape-goat/-/escape-goat-4.0.0.tgz -> yarnpkg-escape-goat-4.0.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> yarnpkg-escape-string-regexp-5.0.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/eslint-config-prettier/-/eslint-config-prettier-8.8.0.tgz -> yarnpkg-eslint-config-prettier-8.8.0.tgz
https://registry.yarnpkg.com/eslint-config-xo-typescript/-/eslint-config-xo-typescript-0.57.0.tgz -> yarnpkg-eslint-config-xo-typescript-0.57.0.tgz
https://registry.yarnpkg.com/eslint-config-xo/-/eslint-config-xo-0.41.0.tgz -> yarnpkg-eslint-config-xo-0.41.0.tgz
https://registry.yarnpkg.com/eslint-formatter-pretty/-/eslint-formatter-pretty-4.1.0.tgz -> yarnpkg-eslint-formatter-pretty-4.1.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> yarnpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.yarnpkg.com/eslint-import-resolver-webpack/-/eslint-import-resolver-webpack-0.13.2.tgz -> yarnpkg-eslint-import-resolver-webpack-0.13.2.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> yarnpkg-eslint-module-utils-2.7.4.tgz
https://registry.yarnpkg.com/eslint-plugin-ava/-/eslint-plugin-ava-13.2.0.tgz -> yarnpkg-eslint-plugin-ava-13.2.0.tgz
https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-4.1.0.tgz -> yarnpkg-eslint-plugin-es-4.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-eslint-comments/-/eslint-plugin-eslint-comments-3.2.0.tgz -> yarnpkg-eslint-plugin-eslint-comments-3.2.0.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> yarnpkg-eslint-plugin-import-2.27.5.tgz
https://registry.yarnpkg.com/eslint-plugin-n/-/eslint-plugin-n-15.7.0.tgz -> yarnpkg-eslint-plugin-n-15.7.0.tgz
https://registry.yarnpkg.com/eslint-plugin-no-use-extend-native/-/eslint-plugin-no-use-extend-native-0.5.0.tgz -> yarnpkg-eslint-plugin-no-use-extend-native-0.5.0.tgz
https://registry.yarnpkg.com/eslint-plugin-prettier/-/eslint-plugin-prettier-4.2.1.tgz -> yarnpkg-eslint-plugin-prettier-4.2.1.tgz
https://registry.yarnpkg.com/eslint-plugin-unicorn/-/eslint-plugin-unicorn-42.0.0.tgz -> yarnpkg-eslint-plugin-unicorn-42.0.0.tgz
https://registry.yarnpkg.com/eslint-rule-docs/-/eslint-rule-docs-1.1.235.tgz -> yarnpkg-eslint-rule-docs-1.1.235.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-7.1.1.tgz -> yarnpkg-eslint-scope-7.1.1.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz -> yarnpkg-eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-3.0.0.tgz -> yarnpkg-eslint-utils-3.0.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz -> yarnpkg-eslint-visitor-keys-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-3.4.0.tgz -> yarnpkg-eslint-visitor-keys-3.4.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-8.38.0.tgz -> yarnpkg-eslint-8.38.0.tgz
https://registry.yarnpkg.com/esm-utils/-/esm-utils-4.1.2.tgz -> yarnpkg-esm-utils-4.1.2.tgz
https://registry.yarnpkg.com/espree/-/espree-9.5.1.tgz -> yarnpkg-espree-9.5.1.tgz
https://registry.yarnpkg.com/espurify/-/espurify-2.1.1.tgz -> yarnpkg-espurify-2.1.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz -> yarnpkg-esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/execa/-/execa-2.1.0.tgz -> yarnpkg-execa-2.1.0.tgz
https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz -> yarnpkg-execa-5.1.1.tgz
https://registry.yarnpkg.com/ext-list/-/ext-list-2.2.2.tgz -> yarnpkg-ext-list-2.2.2.tgz
https://registry.yarnpkg.com/ext-name/-/ext-name-5.0.0.tgz -> yarnpkg-ext-name-5.0.0.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-2.0.1.tgz -> yarnpkg-extract-zip-2.0.1.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.1.tgz -> yarnpkg-extsprintf-1.4.1.tgz
https://registry.yarnpkg.com/facebook-locales/-/facebook-locales-1.0.916.tgz -> yarnpkg-facebook-locales-1.0.916.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-diff/-/fast-diff-1.2.0.tgz -> yarnpkg-fast-diff-1.2.0.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fast-memoize/-/fast-memoize-2.5.2.tgz -> yarnpkg-fast-memoize-2.5.2.tgz
https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> yarnpkg-fastest-levenshtein-1.0.16.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz -> yarnpkg-fastq-1.15.0.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/figures/-/figures-1.7.0.tgz -> yarnpkg-figures-1.7.0.tgz
https://registry.yarnpkg.com/figures/-/figures-2.0.0.tgz -> yarnpkg-figures-2.0.0.tgz
https://registry.yarnpkg.com/figures/-/figures-3.2.0.tgz -> yarnpkg-figures-3.2.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/filelist/-/filelist-1.0.4.tgz -> yarnpkg-filelist-1.0.4.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> yarnpkg-find-cache-dir-3.3.2.tgz
https://registry.yarnpkg.com/find-root/-/find-root-1.1.0.tgz -> yarnpkg-find-root-1.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-6.3.0.tgz -> yarnpkg-find-up-6.3.0.tgz
https://registry.yarnpkg.com/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> yarnpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz -> yarnpkg-flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.7.tgz -> yarnpkg-flatted-3.2.7.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/form-data-encoder/-/form-data-encoder-2.1.4.tgz -> yarnpkg-form-data-encoder-2.1.4.tgz
https://registry.yarnpkg.com/form-data/-/form-data-4.0.0.tgz -> yarnpkg-form-data-4.0.0.tgz
https://registry.yarnpkg.com/fp-and-or/-/fp-and-or-0.1.3.tgz -> yarnpkg-fp-and-or-0.1.3.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz -> yarnpkg-fs-extra-10.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz -> yarnpkg-fs-extra-9.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz -> yarnpkg-fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-3.0.1.tgz -> yarnpkg-fs-minipass-3.0.1.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/gauge/-/gauge-4.0.4.tgz -> yarnpkg-gauge-4.0.4.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-set-props/-/get-set-props-0.1.0.tgz -> yarnpkg-get-set-props-0.1.0.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-8.0.0.tgz -> yarnpkg-get-stdin-8.0.0.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-9.0.0.tgz -> yarnpkg-get-stdin-9.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz -> yarnpkg-get-stream-4.1.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz -> yarnpkg-get-stream-5.2.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz -> yarnpkg-get-stream-6.0.1.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/github-url-from-git/-/github-url-from-git-1.5.0.tgz -> yarnpkg-github-url-from-git-1.5.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz -> yarnpkg-glob-parent-6.0.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-8.1.0.tgz -> yarnpkg-glob-8.1.0.tgz
https://registry.yarnpkg.com/glob/-/glob-9.3.4.tgz -> yarnpkg-glob-9.3.4.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz -> yarnpkg-global-agent-3.0.0.tgz
https://registry.yarnpkg.com/global-dirs/-/global-dirs-2.1.0.tgz -> yarnpkg-global-dirs-2.1.0.tgz
https://registry.yarnpkg.com/global-dirs/-/global-dirs-3.0.1.tgz -> yarnpkg-global-dirs-3.0.1.tgz
https://registry.yarnpkg.com/global-modules/-/global-modules-2.0.0.tgz -> yarnpkg-global-modules-2.0.0.tgz
https://registry.yarnpkg.com/global-prefix/-/global-prefix-3.0.0.tgz -> yarnpkg-global-prefix-3.0.0.tgz
https://registry.yarnpkg.com/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> yarnpkg-global-tunnel-ng-2.7.1.tgz
https://registry.yarnpkg.com/globals/-/globals-13.20.0.tgz -> yarnpkg-globals-13.20.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz -> yarnpkg-globby-11.1.0.tgz
https://registry.yarnpkg.com/globby/-/globby-13.1.3.tgz -> yarnpkg-globby-13.1.3.tgz
https://registry.yarnpkg.com/globjoin/-/globjoin-0.1.4.tgz -> yarnpkg-globjoin-0.1.4.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/got/-/got-10.7.0.tgz -> yarnpkg-got-10.7.0.tgz
https://registry.yarnpkg.com/got/-/got-11.8.6.tgz -> yarnpkg-got-11.8.6.tgz
https://registry.yarnpkg.com/got/-/got-12.6.0.tgz -> yarnpkg-got-12.6.0.tgz
https://registry.yarnpkg.com/got/-/got-9.6.0.tgz -> yarnpkg-got-9.6.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.10.tgz -> yarnpkg-graceful-fs-4.2.10.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz -> yarnpkg-graceful-readlink-1.0.1.tgz
https://registry.yarnpkg.com/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> yarnpkg-grapheme-splitter-1.0.4.tgz
https://registry.yarnpkg.com/hard-rejection/-/hard-rejection-2.1.0.tgz -> yarnpkg-hard-rejection-2.1.0.tgz
https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz -> yarnpkg-has-ansi-2.0.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/has-yarn/-/has-yarn-2.1.0.tgz -> yarnpkg-has-yarn-2.1.0.tgz
https://registry.yarnpkg.com/has-yarn/-/has-yarn-3.0.0.tgz -> yarnpkg-has-yarn-3.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-3.0.8.tgz -> yarnpkg-hosted-git-info-3.0.8.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> yarnpkg-hosted-git-info-4.1.0.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-5.2.1.tgz -> yarnpkg-hosted-git-info-5.2.1.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-6.1.1.tgz -> yarnpkg-hosted-git-info-6.1.1.tgz
https://registry.yarnpkg.com/html-tags/-/html-tags-3.3.1.tgz -> yarnpkg-html-tags-3.3.1.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> yarnpkg-http-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> yarnpkg-http2-wrapper-1.0.3.tgz
https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-2.2.0.tgz -> yarnpkg-http2-wrapper-2.2.0.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz -> yarnpkg-human-signals-2.1.0.tgz
https://registry.yarnpkg.com/humanize-ms/-/humanize-ms-1.2.1.tgz -> yarnpkg-humanize-ms-1.2.1.tgz
https://registry.yarnpkg.com/husky/-/husky-8.0.3.tgz -> yarnpkg-husky-8.0.3.tgz
https://registry.yarnpkg.com/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> yarnpkg-iconv-corefoundation-1.1.7.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-3.0.4.tgz -> yarnpkg-ignore-walk-3.0.4.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-6.0.2.tgz -> yarnpkg-ignore-walk-6.0.2.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.2.4.tgz -> yarnpkg-ignore-5.2.4.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz -> yarnpkg-import-lazy-2.1.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-4.0.0.tgz -> yarnpkg-import-lazy-4.0.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-3.1.0.tgz -> yarnpkg-import-local-3.1.0.tgz
https://registry.yarnpkg.com/import-meta-resolve/-/import-meta-resolve-2.2.2.tgz -> yarnpkg-import-meta-resolve-2.2.2.tgz
https://registry.yarnpkg.com/import-modules/-/import-modules-2.1.0.tgz -> yarnpkg-import-modules-2.1.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-3.2.0.tgz -> yarnpkg-indent-string-3.2.0.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-5.0.0.tgz -> yarnpkg-indent-string-5.0.0.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.7.tgz -> yarnpkg-ini-1.3.7.tgz
https://registry.yarnpkg.com/ini/-/ini-2.0.0.tgz -> yarnpkg-ini-2.0.0.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/ini/-/ini-4.0.0.tgz -> yarnpkg-ini-4.0.0.tgz
https://registry.yarnpkg.com/inquirer-autosubmit-prompt/-/inquirer-autosubmit-prompt-0.2.0.tgz -> yarnpkg-inquirer-autosubmit-prompt-0.2.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-6.5.2.tgz -> yarnpkg-inquirer-6.5.2.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-7.3.3.tgz -> yarnpkg-inquirer-7.3.3.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz -> yarnpkg-interpret-1.4.0.tgz
https://registry.yarnpkg.com/ip-regex/-/ip-regex-4.3.0.tgz -> yarnpkg-ip-regex-4.3.0.tgz
https://registry.yarnpkg.com/ip/-/ip-2.0.0.tgz -> yarnpkg-ip-2.0.0.tgz
https://registry.yarnpkg.com/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> yarnpkg-irregular-plurals-3.5.0.tgz
https://registry.yarnpkg.com/is-absolute/-/is-absolute-1.0.0.tgz -> yarnpkg-is-absolute-1.0.0.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> yarnpkg-is-builtin-module-3.2.1.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-3.0.1.tgz -> yarnpkg-is-ci-3.0.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-docker/-/is-docker-2.2.1.tgz -> yarnpkg-is-docker-2.2.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> yarnpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-get-set-prop/-/is-get-set-prop-1.0.0.tgz -> yarnpkg-is-get-set-prop-1.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.3.2.tgz -> yarnpkg-is-installed-globally-0.3.2.tgz
https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.4.0.tgz -> yarnpkg-is-installed-globally-0.4.0.tgz
https://registry.yarnpkg.com/is-interactive/-/is-interactive-1.0.0.tgz -> yarnpkg-is-interactive-1.0.0.tgz
https://registry.yarnpkg.com/is-ip/-/is-ip-3.1.0.tgz -> yarnpkg-is-ip-3.1.0.tgz
https://registry.yarnpkg.com/is-js-type/-/is-js-type-2.0.0.tgz -> yarnpkg-is-js-type-2.0.0.tgz
https://registry.yarnpkg.com/is-lambda/-/is-lambda-1.0.1.tgz -> yarnpkg-is-lambda-1.0.1.tgz
https://registry.yarnpkg.com/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> yarnpkg-is-negated-glob-1.0.0.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-npm/-/is-npm-5.0.0.tgz -> yarnpkg-is-npm-5.0.0.tgz
https://registry.yarnpkg.com/is-npm/-/is-npm-6.0.0.tgz -> yarnpkg-is-npm-6.0.0.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-obj-prop/-/is-obj-prop-1.0.0.tgz -> yarnpkg-is-obj-prop-1.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-2.0.0.tgz -> yarnpkg-is-obj-2.0.0.tgz
https://registry.yarnpkg.com/is-observable/-/is-observable-1.1.0.tgz -> yarnpkg-is-observable-1.1.0.tgz
https://registry.yarnpkg.com/is-online/-/is-online-9.0.1.tgz -> yarnpkg-is-online-9.0.1.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> yarnpkg-is-path-cwd-2.2.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-3.0.0.tgz -> yarnpkg-is-path-cwd-3.0.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz -> yarnpkg-is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-4.0.0.tgz -> yarnpkg-is-path-inside-4.0.0.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz -> yarnpkg-is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-promise/-/is-promise-2.2.2.tgz -> yarnpkg-is-promise-2.2.2.tgz
https://registry.yarnpkg.com/is-proto-prop/-/is-proto-prop-2.0.0.tgz -> yarnpkg-is-proto-prop-2.0.0.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-relative/-/is-relative-1.0.0.tgz -> yarnpkg-is-relative-1.0.0.tgz
https://registry.yarnpkg.com/is-scoped/-/is-scoped-2.1.0.tgz -> yarnpkg-is-scoped-2.1.0.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz -> yarnpkg-is-stream-1.1.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-unc-path/-/is-unc-path-1.0.0.tgz -> yarnpkg-is-unc-path-1.0.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-url-superb/-/is-url-superb-4.0.0.tgz -> yarnpkg-is-url-superb-4.0.0.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz -> yarnpkg-is-wsl-2.2.0.tgz
https://registry.yarnpkg.com/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> yarnpkg-is-yarn-global-0.3.0.tgz
https://registry.yarnpkg.com/is-yarn-global/-/is-yarn-global-0.4.1.tgz -> yarnpkg-is-yarn-global-0.4.1.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> yarnpkg-isbinaryfile-3.0.3.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> yarnpkg-isbinaryfile-4.0.10.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/issue-regex/-/issue-regex-3.1.0.tgz -> yarnpkg-issue-regex-3.1.0.tgz
https://registry.yarnpkg.com/jake/-/jake-10.8.5.tgz -> yarnpkg-jake-10.8.5.tgz
https://registry.yarnpkg.com/jju/-/jju-1.4.0.tgz -> yarnpkg-jju-1.4.0.tgz
https://registry.yarnpkg.com/js-sdsl/-/js-sdsl-4.4.0.tgz -> yarnpkg-js-sdsl-4.4.0.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-types/-/js-types-1.0.0.tgz -> yarnpkg-js-types-1.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.0.tgz -> yarnpkg-json-buffer-3.0.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.1.tgz -> yarnpkg-json-buffer-3.0.1.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.0.tgz -> yarnpkg-json-parse-even-better-errors-3.0.0.tgz
https://registry.yarnpkg.com/json-parse-helpfulerror/-/json-parse-helpfulerror-1.0.3.tgz -> yarnpkg-json-parse-helpfulerror-1.0.3.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-schema-typed/-/json-schema-typed-7.0.3.tgz -> yarnpkg-json-schema-typed-7.0.3.tgz
https://registry.yarnpkg.com/json-schema-typed/-/json-schema-typed-8.0.1.tgz -> yarnpkg-json-schema-typed-8.0.1.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz -> yarnpkg-json5-2.2.3.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsonlines/-/jsonlines-0.1.1.tgz -> yarnpkg-jsonlines-0.1.1.tgz
https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz -> yarnpkg-jsonparse-1.3.1.tgz
https://registry.yarnpkg.com/keyboardevent-from-electron-accelerator/-/keyboardevent-from-electron-accelerator-2.0.0.tgz -> yarnpkg-keyboardevent-from-electron-accelerator-2.0.0.tgz
https://registry.yarnpkg.com/keyboardevents-areequal/-/keyboardevents-areequal-0.2.2.tgz -> yarnpkg-keyboardevents-areequal-0.2.2.tgz
https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz -> yarnpkg-keyv-3.1.0.tgz
https://registry.yarnpkg.com/keyv/-/keyv-4.5.2.tgz -> yarnpkg-keyv-4.5.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/klaw-sync/-/klaw-sync-6.0.0.tgz -> yarnpkg-klaw-sync-6.0.0.tgz
https://registry.yarnpkg.com/kleur/-/kleur-4.1.5.tgz -> yarnpkg-kleur-4.1.5.tgz
https://registry.yarnpkg.com/known-css-properties/-/known-css-properties-0.26.0.tgz -> yarnpkg-known-css-properties-0.26.0.tgz
https://registry.yarnpkg.com/latest-version/-/latest-version-5.1.0.tgz -> yarnpkg-latest-version-5.1.0.tgz
https://registry.yarnpkg.com/latest-version/-/latest-version-7.0.0.tgz -> yarnpkg-latest-version-7.0.0.tgz
https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.5.tgz -> yarnpkg-lazy-val-1.0.5.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/line-column-path/-/line-column-path-3.0.0.tgz -> yarnpkg-line-column-path-3.0.0.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> yarnpkg-lines-and-columns-1.2.4.tgz
https://registry.yarnpkg.com/listr-input/-/listr-input-0.2.1.tgz -> yarnpkg-listr-input-0.2.1.tgz
https://registry.yarnpkg.com/listr-silent-renderer/-/listr-silent-renderer-1.1.1.tgz -> yarnpkg-listr-silent-renderer-1.1.1.tgz
https://registry.yarnpkg.com/listr-update-renderer/-/listr-update-renderer-0.5.0.tgz -> yarnpkg-listr-update-renderer-0.5.0.tgz
https://registry.yarnpkg.com/listr-verbose-renderer/-/listr-verbose-renderer-0.5.0.tgz -> yarnpkg-listr-verbose-renderer-0.5.0.tgz
https://registry.yarnpkg.com/listr/-/listr-0.14.3.tgz -> yarnpkg-listr-0.14.3.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-7.2.0.tgz -> yarnpkg-locate-path-7.2.0.tgz
https://registry.yarnpkg.com/lodash-es/-/lodash-es-4.17.21.tgz -> yarnpkg-lodash-es-4.17.21.tgz
https://registry.yarnpkg.com/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> yarnpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> yarnpkg-lodash.isequal-4.5.0.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> yarnpkg-lodash.truncate-4.4.2.tgz
https://registry.yarnpkg.com/lodash.zip/-/lodash.zip-4.2.0.tgz -> yarnpkg-lodash.zip-4.2.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-1.0.2.tgz -> yarnpkg-log-symbols-1.0.2.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/log-update/-/log-update-2.3.0.tgz -> yarnpkg-log-update-2.3.0.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> yarnpkg-lowercase-keys-1.0.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-3.0.0.tgz -> yarnpkg-lowercase-keys-3.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-7.18.3.tgz -> yarnpkg-lru-cache-7.18.3.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> yarnpkg-make-fetch-happen-10.2.1.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-11.0.3.tgz -> yarnpkg-make-fetch-happen-11.0.3.tgz
https://registry.yarnpkg.com/many-keys-map/-/many-keys-map-1.0.3.tgz -> yarnpkg-many-keys-map-1.0.3.tgz
https://registry.yarnpkg.com/map-age-cleaner/-/map-age-cleaner-0.1.3.tgz -> yarnpkg-map-age-cleaner-0.1.3.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz -> yarnpkg-map-obj-1.0.1.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-4.3.0.tgz -> yarnpkg-map-obj-4.3.0.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/mathml-tag-names/-/mathml-tag-names-2.1.3.tgz -> yarnpkg-mathml-tag-names-2.1.3.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.2.0.tgz -> yarnpkg-memory-fs-0.2.0.tgz
https://registry.yarnpkg.com/meow/-/meow-10.1.5.tgz -> yarnpkg-meow-10.1.5.tgz
https://registry.yarnpkg.com/meow/-/meow-8.1.2.tgz -> yarnpkg-meow-8.1.2.tgz
https://registry.yarnpkg.com/meow/-/meow-9.0.0.tgz -> yarnpkg-meow-9.0.0.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/micro-spelling-correcter/-/micro-spelling-correcter-1.1.1.tgz -> yarnpkg-micro-spelling-correcter-1.1.1.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz -> yarnpkg-mime-2.6.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-1.2.0.tgz -> yarnpkg-mimic-fn-1.2.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-3.1.0.tgz -> yarnpkg-mimic-fn-3.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-2.1.0.tgz -> yarnpkg-mimic-response-2.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz -> yarnpkg-mimic-response-3.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-4.0.0.tgz -> yarnpkg-mimic-response-4.0.0.tgz
https://registry.yarnpkg.com/min-indent/-/min-indent-1.0.1.tgz -> yarnpkg-min-indent-1.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz -> yarnpkg-minimatch-3.0.4.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-7.4.5.tgz -> yarnpkg-minimatch-7.4.5.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-8.0.3.tgz -> yarnpkg-minimatch-8.0.3.tgz
https://registry.yarnpkg.com/minimist-options/-/minimist-options-4.1.0.tgz -> yarnpkg-minimist-options-4.1.0.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/minipass-collect/-/minipass-collect-1.0.2.tgz -> yarnpkg-minipass-collect-1.0.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> yarnpkg-minipass-fetch-2.1.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-3.0.1.tgz -> yarnpkg-minipass-fetch-3.0.1.tgz
https://registry.yarnpkg.com/minipass-flush/-/minipass-flush-1.0.5.tgz -> yarnpkg-minipass-flush-1.0.5.tgz
https://registry.yarnpkg.com/minipass-json-stream/-/minipass-json-stream-1.0.1.tgz -> yarnpkg-minipass-json-stream-1.0.1.tgz
https://registry.yarnpkg.com/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> yarnpkg-minipass-pipeline-1.2.4.tgz
https://registry.yarnpkg.com/minipass-sized/-/minipass-sized-1.0.3.tgz -> yarnpkg-minipass-sized-1.0.3.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.6.tgz -> yarnpkg-minipass-3.3.6.tgz
https://registry.yarnpkg.com/minipass/-/minipass-4.2.5.tgz -> yarnpkg-minipass-4.2.5.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz -> yarnpkg-minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz -> yarnpkg-mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/modify-filename/-/modify-filename-1.1.0.tgz -> yarnpkg-modify-filename-1.1.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.7.tgz -> yarnpkg-mute-stream-0.0.7.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.8.tgz -> yarnpkg-mute-stream-0.0.8.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.6.tgz -> yarnpkg-nanoid-3.3.6.tgz
https://registry.yarnpkg.com/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz -> yarnpkg-natural-compare-lite-1.4.0.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.3.tgz -> yarnpkg-negotiator-0.6.3.tgz
https://registry.yarnpkg.com/new-github-issue-url/-/new-github-issue-url-0.2.1.tgz -> yarnpkg-new-github-issue-url-0.2.1.tgz
https://registry.yarnpkg.com/new-github-release-url/-/new-github-release-url-1.0.0.tgz -> yarnpkg-new-github-release-url-1.0.0.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-1.7.2.tgz -> yarnpkg-node-addon-api-1.7.2.tgz
https://registry.yarnpkg.com/node-gyp/-/node-gyp-9.3.1.tgz -> yarnpkg-node-gyp-9.3.1.tgz
https://registry.yarnpkg.com/nopt/-/nopt-6.0.0.tgz -> yarnpkg-nopt-6.0.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> yarnpkg-normalize-package-data-3.0.3.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-5.0.0.tgz -> yarnpkg-normalize-package-data-5.0.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.1.tgz -> yarnpkg-normalize-url-4.5.1.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz -> yarnpkg-normalize-url-6.1.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-8.0.0.tgz -> yarnpkg-normalize-url-8.0.0.tgz
https://registry.yarnpkg.com/np/-/np-7.7.0.tgz -> yarnpkg-np-7.7.0.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-3.0.0.tgz -> yarnpkg-npm-bundled-3.0.0.tgz
https://registry.yarnpkg.com/npm-check-updates/-/npm-check-updates-16.10.7.tgz -> yarnpkg-npm-check-updates-16.10.7.tgz
https://registry.yarnpkg.com/npm-conf/-/npm-conf-1.1.3.tgz -> yarnpkg-npm-conf-1.1.3.tgz
https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-6.1.0.tgz -> yarnpkg-npm-install-checks-6.1.0.tgz
https://registry.yarnpkg.com/npm-name/-/npm-name-6.0.1.tgz -> yarnpkg-npm-name-6.0.1.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.0.tgz -> yarnpkg-npm-normalize-package-bin-3.0.0.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-10.1.0.tgz -> yarnpkg-npm-package-arg-10.1.0.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-7.0.4.tgz -> yarnpkg-npm-packlist-7.0.4.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-8.0.1.tgz -> yarnpkg-npm-pick-manifest-8.0.1.tgz
https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-14.0.3.tgz -> yarnpkg-npm-registry-fetch-14.0.3.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-3.1.0.tgz -> yarnpkg-npm-run-path-3.1.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-6.0.2.tgz -> yarnpkg-npmlog-6.0.2.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/obj-props/-/obj-props-1.4.0.tgz -> yarnpkg-obj-props-1.4.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz -> yarnpkg-object.values-1.1.6.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-2.0.1.tgz -> yarnpkg-onetime-2.0.1.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/open-editor/-/open-editor-4.0.0.tgz -> yarnpkg-open-editor-4.0.0.tgz
https://registry.yarnpkg.com/open/-/open-7.4.2.tgz -> yarnpkg-open-7.4.2.tgz
https://registry.yarnpkg.com/open/-/open-8.4.2.tgz -> yarnpkg-open-8.4.2.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz -> yarnpkg-optionator-0.9.1.tgz
https://registry.yarnpkg.com/org-regex/-/org-regex-1.0.0.tgz -> yarnpkg-org-regex-1.0.0.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/ow/-/ow-0.21.0.tgz -> yarnpkg-ow-0.21.0.tgz
https://registry.yarnpkg.com/p-any/-/p-any-3.0.0.tgz -> yarnpkg-p-any-3.0.0.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-1.1.0.tgz -> yarnpkg-p-cancelable-1.1.0.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-2.1.1.tgz -> yarnpkg-p-cancelable-2.1.1.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-3.0.0.tgz -> yarnpkg-p-cancelable-3.0.0.tgz
https://registry.yarnpkg.com/p-defer/-/p-defer-1.0.0.tgz -> yarnpkg-p-defer-1.0.0.tgz
https://registry.yarnpkg.com/p-defer/-/p-defer-3.0.0.tgz -> yarnpkg-p-defer-3.0.0.tgz
https://registry.yarnpkg.com/p-event/-/p-event-4.2.0.tgz -> yarnpkg-p-event-4.2.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz -> yarnpkg-p-finally-1.0.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-2.0.1.tgz -> yarnpkg-p-finally-2.0.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-4.0.0.tgz -> yarnpkg-p-limit-4.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-6.0.0.tgz -> yarnpkg-p-locate-6.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-2.1.0.tgz -> yarnpkg-p-map-2.1.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-3.0.0.tgz -> yarnpkg-p-map-3.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-5.5.0.tgz -> yarnpkg-p-map-5.5.0.tgz
https://registry.yarnpkg.com/p-memoize/-/p-memoize-4.0.4.tgz -> yarnpkg-p-memoize-4.0.4.tgz
https://registry.yarnpkg.com/p-reflect/-/p-reflect-2.1.0.tgz -> yarnpkg-p-reflect-2.1.0.tgz
https://registry.yarnpkg.com/p-settle/-/p-settle-4.1.1.tgz -> yarnpkg-p-settle-4.1.1.tgz
https://registry.yarnpkg.com/p-some/-/p-some-5.0.0.tgz -> yarnpkg-p-some-5.0.0.tgz
https://registry.yarnpkg.com/p-timeout/-/p-timeout-3.2.0.tgz -> yarnpkg-p-timeout-3.2.0.tgz
https://registry.yarnpkg.com/p-timeout/-/p-timeout-4.1.0.tgz -> yarnpkg-p-timeout-4.1.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/p-wait-for/-/p-wait-for-3.2.0.tgz -> yarnpkg-p-wait-for-3.2.0.tgz
https://registry.yarnpkg.com/package-json/-/package-json-6.5.0.tgz -> yarnpkg-package-json-6.5.0.tgz
https://registry.yarnpkg.com/package-json/-/package-json-8.1.0.tgz -> yarnpkg-package-json-8.1.0.tgz
https://registry.yarnpkg.com/pacote/-/pacote-15.1.1.tgz -> yarnpkg-pacote-15.1.1.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-github-url/-/parse-github-url-1.0.2.tgz -> yarnpkg-parse-github-url-1.0.2.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz -> yarnpkg-parse-json-5.2.0.tgz
https://registry.yarnpkg.com/patch-package/-/patch-package-6.5.1.tgz -> yarnpkg-patch-package-6.5.1.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-5.0.0.tgz -> yarnpkg-path-exists-5.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.6.3.tgz -> yarnpkg-path-scurry-1.6.3.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-5.0.0.tgz -> yarnpkg-pkg-dir-5.0.0.tgz
https://registry.yarnpkg.com/pkg-up/-/pkg-up-3.1.0.tgz -> yarnpkg-pkg-up-3.1.0.tgz
https://registry.yarnpkg.com/plist/-/plist-3.0.6.tgz -> yarnpkg-plist-3.0.6.tgz
https://registry.yarnpkg.com/plur/-/plur-4.0.0.tgz -> yarnpkg-plur-4.0.0.tgz
https://registry.yarnpkg.com/pluralize/-/pluralize-8.0.0.tgz -> yarnpkg-pluralize-8.0.0.tgz
https://registry.yarnpkg.com/postcss-media-query-parser/-/postcss-media-query-parser-0.2.3.tgz -> yarnpkg-postcss-media-query-parser-0.2.3.tgz
https://registry.yarnpkg.com/postcss-resolve-nested-selector/-/postcss-resolve-nested-selector-0.1.1.tgz -> yarnpkg-postcss-resolve-nested-selector-0.1.1.tgz
https://registry.yarnpkg.com/postcss-safe-parser/-/postcss-safe-parser-6.0.0.tgz -> yarnpkg-postcss-safe-parser-6.0.0.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.11.tgz -> yarnpkg-postcss-selector-parser-6.0.11.tgz
https://registry.yarnpkg.com/postcss-sorting/-/postcss-sorting-7.0.1.tgz -> yarnpkg-postcss-sorting-7.0.1.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> yarnpkg-postcss-value-parser-4.2.0.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.21.tgz -> yarnpkg-postcss-8.4.21.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-2.0.0.tgz -> yarnpkg-prepend-http-2.0.0.tgz
https://registry.yarnpkg.com/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz -> yarnpkg-prettier-linter-helpers-1.0.0.tgz
https://registry.yarnpkg.com/prettier/-/prettier-2.8.7.tgz -> yarnpkg-prettier-2.8.7.tgz
https://registry.yarnpkg.com/proc-log/-/proc-log-3.0.0.tgz -> yarnpkg-proc-log-3.0.0.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise-retry/-/promise-retry-2.0.1.tgz -> yarnpkg-promise-retry-2.0.1.tgz
https://registry.yarnpkg.com/prompts-ncu/-/prompts-ncu-3.0.0.tgz -> yarnpkg-prompts-ncu-3.0.0.tgz
https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz -> yarnpkg-proto-list-1.2.4.tgz
https://registry.yarnpkg.com/proto-props/-/proto-props-2.0.0.tgz -> yarnpkg-proto-props-2.0.0.tgz
https://registry.yarnpkg.com/public-ip/-/public-ip-4.0.4.tgz -> yarnpkg-public-ip-4.0.4.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/pupa/-/pupa-2.1.1.tgz -> yarnpkg-pupa-2.1.1.tgz
https://registry.yarnpkg.com/pupa/-/pupa-3.1.0.tgz -> yarnpkg-pupa-3.1.0.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-4.0.1.tgz -> yarnpkg-quick-lru-4.0.1.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz -> yarnpkg-quick-lru-5.1.1.tgz
https://registry.yarnpkg.com/rc-config-loader/-/rc-config-loader-4.1.2.tgz -> yarnpkg-rc-config-loader-4.1.2.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.2.0.tgz -> yarnpkg-read-config-file-6.2.0.tgz
https://registry.yarnpkg.com/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz -> yarnpkg-read-package-json-fast-3.0.2.tgz
https://registry.yarnpkg.com/read-package-json/-/read-package-json-6.0.1.tgz -> yarnpkg-read-package-json-6.0.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> yarnpkg-read-pkg-up-7.0.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-8.0.0.tgz -> yarnpkg-read-pkg-up-8.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-5.2.0.tgz -> yarnpkg-read-pkg-5.2.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-6.0.0.tgz -> yarnpkg-read-pkg-6.0.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.2.tgz -> yarnpkg-readable-stream-3.6.2.tgz
https://registry.yarnpkg.com/redent/-/redent-3.0.0.tgz -> yarnpkg-redent-3.0.0.tgz
https://registry.yarnpkg.com/redent/-/redent-4.0.0.tgz -> yarnpkg-redent-4.0.0.tgz
https://registry.yarnpkg.com/regexp-tree/-/regexp-tree-0.1.24.tgz -> yarnpkg-regexp-tree-0.1.24.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.2.0.tgz -> yarnpkg-regexpp-3.2.0.tgz
https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-4.2.2.tgz -> yarnpkg-registry-auth-token-4.2.2.tgz
https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-5.0.2.tgz -> yarnpkg-registry-auth-token-5.0.2.tgz
https://registry.yarnpkg.com/registry-url/-/registry-url-5.1.0.tgz -> yarnpkg-registry-url-5.1.0.tgz
https://registry.yarnpkg.com/registry-url/-/registry-url-6.0.1.tgz -> yarnpkg-registry-url-6.0.1.tgz
https://registry.yarnpkg.com/remote-git-tags/-/remote-git-tags-3.0.0.tgz -> yarnpkg-remote-git-tags-3.0.0.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> yarnpkg-resolve-alpn-1.2.1.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> yarnpkg-resolve-cwd-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz -> yarnpkg-resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz -> yarnpkg-resolve-1.22.2.tgz
https://registry.yarnpkg.com/responselike/-/responselike-1.0.2.tgz -> yarnpkg-responselike-1.0.2.tgz
https://registry.yarnpkg.com/responselike/-/responselike-2.0.1.tgz -> yarnpkg-responselike-2.0.1.tgz
https://registry.yarnpkg.com/responselike/-/responselike-3.0.0.tgz -> yarnpkg-responselike-3.0.0.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-2.0.0.tgz -> yarnpkg-restore-cursor-2.0.0.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-3.1.0.tgz -> yarnpkg-restore-cursor-3.1.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz -> yarnpkg-retry-0.12.0.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-4.4.1.tgz -> yarnpkg-rimraf-4.4.1.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz -> yarnpkg-roarr-2.15.4.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.7.tgz -> yarnpkg-rxjs-6.6.7.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-7.8.0.tgz -> yarnpkg-rxjs-7.8.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-2.1.1.tgz -> yarnpkg-safe-regex-2.1.1.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/scoped-regex/-/scoped-regex-2.1.0.tgz -> yarnpkg-scoped-regex-2.1.0.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver-diff/-/semver-diff-3.1.1.tgz -> yarnpkg-semver-diff-3.1.1.tgz
https://registry.yarnpkg.com/semver-diff/-/semver-diff-4.0.0.tgz -> yarnpkg-semver-diff-4.0.0.tgz
https://registry.yarnpkg.com/semver-utils/-/semver-utils-1.1.4.tgz -> yarnpkg-semver-utils-1.1.4.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/semver/-/semver-7.0.0.tgz -> yarnpkg-semver-7.0.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-8.1.0.tgz -> yarnpkg-serialize-error-8.1.0.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/sigstore/-/sigstore-1.2.0.tgz -> yarnpkg-sigstore-1.2.0.tgz
https://registry.yarnpkg.com/simple-update-notifier/-/simple-update-notifier-1.1.0.tgz -> yarnpkg-simple-update-notifier-1.1.0.tgz
https://registry.yarnpkg.com/sisteransi/-/sisteransi-1.0.5.tgz -> yarnpkg-sisteransi-1.0.5.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz -> yarnpkg-slash-3.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-4.0.0.tgz -> yarnpkg-slash-4.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-0.0.4.tgz -> yarnpkg-slice-ansi-0.0.4.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz -> yarnpkg-slice-ansi-3.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz -> yarnpkg-slice-ansi-4.0.0.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz -> yarnpkg-smart-buffer-4.2.0.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> yarnpkg-socks-proxy-agent-7.0.0.tgz
https://registry.yarnpkg.com/socks/-/socks-2.7.1.tgz -> yarnpkg-socks-2.7.1.tgz
https://registry.yarnpkg.com/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> yarnpkg-sort-keys-length-1.0.1.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz -> yarnpkg-sort-keys-1.1.2.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz -> yarnpkg-source-map-js-1.0.2.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/spawn-please/-/spawn-please-2.0.1.tgz -> yarnpkg-spawn-please-2.0.1.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> yarnpkg-spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/split/-/split-1.0.1.tgz -> yarnpkg-split-1.0.1.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz -> yarnpkg-sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/ssri/-/ssri-10.0.2.tgz -> yarnpkg-ssri-10.0.2.tgz
https://registry.yarnpkg.com/ssri/-/ssri-9.0.1.tgz -> yarnpkg-ssri-9.0.1.tgz
https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz -> yarnpkg-stat-mode-1.0.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz -> yarnpkg-string-width-2.1.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-5.1.2.tgz -> yarnpkg-string-width-5.1.2.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz -> yarnpkg-strip-ansi-4.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz -> yarnpkg-strip-ansi-5.2.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-7.0.1.tgz -> yarnpkg-strip-ansi-7.0.1.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-3.0.0.tgz -> yarnpkg-strip-indent-3.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-4.0.0.tgz -> yarnpkg-strip-indent-4.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-5.0.0.tgz -> yarnpkg-strip-json-comments-5.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/style-search/-/style-search-0.1.0.tgz -> yarnpkg-style-search-0.1.0.tgz
https://registry.yarnpkg.com/stylelint-config-xo/-/stylelint-config-xo-0.21.1.tgz -> yarnpkg-stylelint-config-xo-0.21.1.tgz
https://registry.yarnpkg.com/stylelint-declaration-block-no-ignored-properties/-/stylelint-declaration-block-no-ignored-properties-2.7.0.tgz -> yarnpkg-stylelint-declaration-block-no-ignored-properties-2.7.0.tgz
https://registry.yarnpkg.com/stylelint-order/-/stylelint-order-5.0.0.tgz -> yarnpkg-stylelint-order-5.0.0.tgz
https://registry.yarnpkg.com/stylelint/-/stylelint-14.16.1.tgz -> yarnpkg-stylelint-14.16.1.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz -> yarnpkg-supports-color-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-hyperlinks/-/supports-hyperlinks-2.3.0.tgz -> yarnpkg-supports-hyperlinks-2.3.0.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/svg-tags/-/svg-tags-1.0.0.tgz -> yarnpkg-svg-tags-1.0.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.2.0.tgz -> yarnpkg-symbol-observable-1.2.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-3.0.0.tgz -> yarnpkg-symbol-observable-3.0.0.tgz
https://registry.yarnpkg.com/table/-/table-6.8.1.tgz -> yarnpkg-table-6.8.1.tgz
https://registry.yarnpkg.com/tapable/-/tapable-0.1.10.tgz -> yarnpkg-tapable-0.1.10.tgz
https://registry.yarnpkg.com/tar/-/tar-6.1.13.tgz -> yarnpkg-tar-6.1.13.tgz
https://registry.yarnpkg.com/temp-file/-/temp-file-3.4.0.tgz -> yarnpkg-temp-file-3.4.0.tgz
https://registry.yarnpkg.com/terminal-link/-/terminal-link-2.1.1.tgz -> yarnpkg-terminal-link-2.1.1.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/tmp-promise/-/tmp-promise-3.0.3.tgz -> yarnpkg-tmp-promise-3.0.3.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz -> yarnpkg-tmp-0.2.1.tgz
https://registry.yarnpkg.com/to-absolute-glob/-/to-absolute-glob-2.0.2.tgz -> yarnpkg-to-absolute-glob-2.0.2.tgz
https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> yarnpkg-to-readable-stream-1.0.0.tgz
https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-2.1.0.tgz -> yarnpkg-to-readable-stream-2.1.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-3.0.1.tgz -> yarnpkg-trim-newlines-3.0.1.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-4.1.1.tgz -> yarnpkg-trim-newlines-4.1.1.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> yarnpkg-tsconfig-paths-3.14.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.5.0.tgz -> yarnpkg-tslib-2.5.0.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tuf-js/-/tuf-js-1.1.2.tgz -> yarnpkg-tuf-js-1.1.2.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.10.0.tgz -> yarnpkg-type-fest-0.10.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.18.1.tgz -> yarnpkg-type-fest-0.18.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz -> yarnpkg-type-fest-0.20.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.21.3.tgz -> yarnpkg-type-fest-0.21.3.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.4.1.tgz -> yarnpkg-type-fest-0.4.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.6.0.tgz -> yarnpkg-type-fest-0.6.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz -> yarnpkg-type-fest-0.8.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-1.4.0.tgz -> yarnpkg-type-fest-1.4.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-2.19.0.tgz -> yarnpkg-type-fest-2.19.0.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typed-emitter/-/typed-emitter-2.1.0.tgz -> yarnpkg-typed-emitter-2.1.0.tgz
https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> yarnpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.9.5.tgz -> yarnpkg-typescript-4.9.5.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> yarnpkg-unc-path-regex-0.1.2.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-2.0.1.tgz -> yarnpkg-unique-filename-2.0.1.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-3.0.0.tgz -> yarnpkg-unique-filename-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-3.0.0.tgz -> yarnpkg-unique-slug-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-4.0.0.tgz -> yarnpkg-unique-slug-4.0.0.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-2.0.0.tgz -> yarnpkg-unique-string-2.0.0.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-3.0.0.tgz -> yarnpkg-unique-string-3.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/untildify/-/untildify-4.0.0.tgz -> yarnpkg-untildify-4.0.0.tgz
https://registry.yarnpkg.com/unused-filename/-/unused-filename-2.1.0.tgz -> yarnpkg-unused-filename-2.1.0.tgz
https://registry.yarnpkg.com/update-notifier/-/update-notifier-5.1.0.tgz -> yarnpkg-update-notifier-5.1.0.tgz
https://registry.yarnpkg.com/update-notifier/-/update-notifier-6.0.2.tgz -> yarnpkg-update-notifier-6.0.2.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/url-or-path/-/url-or-path-2.1.0.tgz -> yarnpkg-url-or-path-2.1.0.tgz
https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> yarnpkg-url-parse-lax-3.0.0.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> yarnpkg-utf8-byte-length-1.0.4.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz -> yarnpkg-v8-compile-cache-2.3.0.tgz
https://registry.yarnpkg.com/vali-date/-/vali-date-1.0.0.tgz -> yarnpkg-vali-date-1.0.0.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-3.0.0.tgz -> yarnpkg-validate-npm-package-name-3.0.0.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-5.0.0.tgz -> yarnpkg-validate-npm-package-name-5.0.0.tgz
https://registry.yarnpkg.com/verror/-/verror-1.10.1.tgz -> yarnpkg-verror-1.10.1.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/which/-/which-3.0.0.tgz -> yarnpkg-which-3.0.0.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.5.tgz -> yarnpkg-wide-align-1.1.5.tgz
https://registry.yarnpkg.com/widest-line/-/widest-line-3.1.0.tgz -> yarnpkg-widest-line-3.1.0.tgz
https://registry.yarnpkg.com/widest-line/-/widest-line-4.0.1.tgz -> yarnpkg-widest-line-4.0.1.tgz
https://registry.yarnpkg.com/wnpm-ci/-/wnpm-ci-8.0.131.tgz -> yarnpkg-wnpm-ci-8.0.131.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-3.0.1.tgz -> yarnpkg-wrap-ansi-3.0.1.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> yarnpkg-wrap-ansi-8.1.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> yarnpkg-write-file-atomic-3.0.3.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> yarnpkg-write-file-atomic-4.0.2.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> yarnpkg-xdg-basedir-4.0.0.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-5.1.0.tgz -> yarnpkg-xdg-basedir-5.1.0.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> yarnpkg-xmlbuilder-15.1.1.tgz
https://registry.yarnpkg.com/xo/-/xo-0.51.0.tgz -> yarnpkg-xo-0.51.0.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yaml/-/yaml-1.10.2.tgz -> yarnpkg-yaml-1.10.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.1.1.tgz -> yarnpkg-yargs-parser-21.1.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.7.1.tgz -> yarnpkg-yargs-17.7.1.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-1.0.0.tgz -> yarnpkg-yocto-queue-1.0.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
https://github.com/electron/electron/releases/download/v21.4.4/electron-v21.4.4-linux-x64.zip
"
RESTRICT="mirror"
S="${WORKDIR}/${P}"

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
	:;#check_network_sandbox
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder \
		install-app-deps \
		|| die
}

__npm_run() {
	local cmd=("${@}")
	local tries
	tries=0
	while (( ${tries} < 5 )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\t${cmd[@]}"
		"${cmd[@]}" || die
		if ! grep -q -r -e "ERR_SOCKET_TIMEOUT" "${HOME}/.npm/_logs" ; then
			break
		fi
		rm -rf "${HOME}/.npm/_logs"
		tries=$((${tries} + 1))
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

src_unpack() {
eerror
eerror "This ebuild is under maintenance."
eerror "Undergoing Yarn offline install conversion."
eerror
#die
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json

		__npm_run npm i

	# Change to ^0.51.1
		__npm_run npm i "eslint-config-xo-typescript@^0.51.1" || die

	# Change to ^5.27.1
		__npm_run npm i "@typescript-eslint/eslint-plugin@^5.27.1" || die

	# Change to ^5.27.1
		__npm_run npm i "@typescript-eslint/parser@^5.27.1" || die

		__npm_run npm audit fix || die
		yarn import || die
		die
	else
		#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		yarn_src_unpack
		get_deps
	fi
}

src_compile() {
	cd "${S}" || die
	chmod +x "${S}/node_modules/electron/install.js" || die
	tsc || die

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		|| die
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${YARN_INSTALL_PATH}/${PN}"
	newicon "static/Icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Network"
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${YARN_INSTALL_PATH}/${PN}"
	lcnr_install_files
}

pkg_postinst() {
einfo
einfo "If you see"
einfo
einfo "  \"Config schema violation: vibrancy should be string; \
vibrancy should be equal to one of the allowed values,\""
einfo
einfo "then you may need to run \`rm -rf ~/.config/Caprine\`"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
