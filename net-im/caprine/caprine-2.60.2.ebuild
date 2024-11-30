# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security bump electron every week

MY_PN="${PN^}"

NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${PN}_${PV}_amd64.snap"
# See https://releases.electronjs.org/releases.json for version details.
ELECTRON_APP_ELECTRON_PV="34.0.0-beta.7" # Cr 132.0.6834.15 (dev).  Similar to nightly since nightly does not have prebuilt.
#ELECTRON_APP_ELECTRON_PV="29.4.2" # lockfile
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
ELECTRON_APP_TYPESCRIPT_PV="5.4.4"
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS="--force"
fi
NODE_VERSION=20 # Upstream uses 20.11.1
NODE_ENV="development"

inherit desktop electron-app lcnr npm

# Initially generated from:
#   grep "resolved" /var/tmp/portage/net-im/caprine-2.60.1/work/caprine-2.60.1/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.26.2.tgz -> npmpkg-@babel-code-frame-7.26.2.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.9.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.9.tgz
https://registry.npmjs.org/@bconnorwhite/module/-/module-2.0.2.tgz -> npmpkg-@bconnorwhite-module-2.0.2.tgz
https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz -> npmpkg-@colors-colors-1.5.0.tgz
https://registry.npmjs.org/@csstools/selector-specificity/-/selector-specificity-2.2.0.tgz -> npmpkg-@csstools-selector-specificity-2.2.0.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.17.tgz -> npmpkg-@electron-asar-3.2.17.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.2.1.tgz -> npmpkg-@electron-notarize-2.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.0.5.tgz -> npmpkg-@electron-osx-sign-1.0.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.1.2.tgz -> npmpkg-@electron-remote-2.1.2.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.5.1.tgz -> npmpkg-@electron-universal-1.5.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.1.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.1.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.12.1.tgz -> npmpkg-@eslint-community-regexpp-4.12.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-3.2.0.tgz -> npmpkg-@eslint-eslintrc-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.57.1.tgz -> npmpkg-@eslint-js-8.57.1.tgz
https://registry.npmjs.org/@gar/promisify/-/promisify-1.1.3.tgz -> npmpkg-@gar-promisify-1.1.3.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.13.0.tgz -> npmpkg-@humanwhocodes-config-array-0.13.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz -> npmpkg-@humanwhocodes-object-schema-2.0.3.tgz
https://registry.npmjs.org/@inquirer/figures/-/figures-1.0.8.tgz -> npmpkg-@inquirer-figures-1.0.8.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.6.tgz -> npmpkg-@jridgewell-source-map-0.3.6.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@leichtgewicht/ip-codec/-/ip-codec-2.0.5.tgz -> npmpkg-@leichtgewicht-ip-codec-2.0.5.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-3.1.1.tgz -> npmpkg-@npmcli-fs-3.1.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/@npmcli/git/-/git-4.1.0.tgz -> npmpkg-@npmcli-git-4.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/which/-/which-3.0.1.tgz -> npmpkg-which-3.0.1.tgz
https://registry.npmjs.org/@npmcli/installed-package-contents/-/installed-package-contents-2.1.0.tgz -> npmpkg-@npmcli-installed-package-contents-2.1.0.tgz
https://registry.npmjs.org/@npmcli/move-file/-/move-file-2.0.1.tgz -> npmpkg-@npmcli-move-file-2.0.1.tgz
https://registry.npmjs.org/@npmcli/node-gyp/-/node-gyp-3.0.0.tgz -> npmpkg-@npmcli-node-gyp-3.0.0.tgz
https://registry.npmjs.org/@npmcli/promise-spawn/-/promise-spawn-6.0.2.tgz -> npmpkg-@npmcli-promise-spawn-6.0.2.tgz
https://registry.npmjs.org/which/-/which-3.0.1.tgz -> npmpkg-which-3.0.1.tgz
https://registry.npmjs.org/@npmcli/run-script/-/run-script-6.0.2.tgz -> npmpkg-@npmcli-run-script-6.0.2.tgz
https://registry.npmjs.org/which/-/which-3.0.1.tgz -> npmpkg-which-3.0.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@pkgr/core/-/core-0.1.1.tgz -> npmpkg-@pkgr-core-0.1.1.tgz
https://registry.npmjs.org/@pnpm/config.env-replace/-/config.env-replace-1.1.0.tgz -> npmpkg-@pnpm-config.env-replace-1.1.0.tgz
https://registry.npmjs.org/@pnpm/network.ca-file/-/network.ca-file-1.0.2.tgz -> npmpkg-@pnpm-network.ca-file-1.0.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/@pnpm/npm-conf/-/npm-conf-2.3.1.tgz -> npmpkg-@pnpm-npm-conf-2.3.1.tgz
https://registry.npmjs.org/@rtsao/scc/-/scc-1.1.0.tgz -> npmpkg-@rtsao-scc-1.1.0.tgz
https://registry.npmjs.org/@samverschueren/stream-to-observable/-/stream-to-observable-0.3.1.tgz -> npmpkg-@samverschueren-stream-to-observable-0.3.1.tgz
https://registry.npmjs.org/@sigstore/bundle/-/bundle-1.1.0.tgz -> npmpkg-@sigstore-bundle-1.1.0.tgz
https://registry.npmjs.org/@sigstore/protobuf-specs/-/protobuf-specs-0.2.1.tgz -> npmpkg-@sigstore-protobuf-specs-0.2.1.tgz
https://registry.npmjs.org/@sigstore/sign/-/sign-1.0.0.tgz -> npmpkg-@sigstore-sign-1.0.0.tgz
https://registry.npmjs.org/@sigstore/tuf/-/tuf-1.0.3.tgz -> npmpkg-@sigstore-tuf-1.0.3.tgz
https://registry.npmjs.org/@sindresorhus/do-not-disturb/-/do-not-disturb-1.1.0.tgz -> npmpkg-@sindresorhus-do-not-disturb-1.1.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-1.2.0.tgz -> npmpkg-electron-is-dev-1.2.0.tgz
https://registry.npmjs.org/electron-util/-/electron-util-0.12.3.tgz -> npmpkg-electron-util-0.12.3.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@sindresorhus/merge-streams/-/merge-streams-2.3.0.tgz -> npmpkg-@sindresorhus-merge-streams-2.3.0.tgz
https://registry.npmjs.org/@sindresorhus/tsconfig/-/tsconfig-0.7.0.tgz -> npmpkg-@sindresorhus-tsconfig-0.7.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@tufjs/canonical-json/-/canonical-json-1.0.0.tgz -> npmpkg-@tufjs-canonical-json-1.0.0.tgz
https://registry.npmjs.org/@tufjs/models/-/models-1.0.4.tgz -> npmpkg-@tufjs-models-1.0.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/electron-localshortcut/-/electron-localshortcut-3.1.3.tgz -> npmpkg-@types-electron-localshortcut-3.1.3.tgz
https://registry.npmjs.org/@types/eslint/-/eslint-8.56.12.tgz -> npmpkg-@types-eslint-8.56.12.tgz
https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.7.tgz -> npmpkg-@types-eslint-scope-3.7.7.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/facebook-locales/-/facebook-locales-1.0.2.tgz -> npmpkg-@types-facebook-locales-1.0.2.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.17.13.tgz -> npmpkg-@types-lodash-4.17.13.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.5.tgz -> npmpkg-@types-minimist-1.2.5.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-20.17.9.tgz -> npmpkg-@types-node-20.17.9.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> npmpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.npmjs.org/@types/parse-json/-/parse-json-4.0.2.tgz -> npmpkg-@types-parse-json-4.0.2.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.5.tgz -> npmpkg-@types-plist-3.0.5.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.8.tgz -> npmpkg-@types-semver-7.5.8.tgz
https://registry.npmjs.org/@types/semver-utils/-/semver-utils-1.1.3.tgz -> npmpkg-@types-semver-utils-1.1.3.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.10.tgz -> npmpkg-@types-verror-1.10.10.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.3.tgz -> npmpkg-@types-yauzl-2.10.3.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-6.21.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-6.21.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-6.21.0.tgz -> npmpkg-@typescript-eslint-parser-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-6.21.0.tgz -> npmpkg-@typescript-eslint-scope-manager-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-6.21.0.tgz -> npmpkg-@typescript-eslint-type-utils-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-6.21.0.tgz -> npmpkg-@typescript-eslint-types-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-6.21.0.tgz -> npmpkg-@typescript-eslint-typescript-estree-6.21.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.3.tgz -> npmpkg-minimatch-9.0.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-6.21.0.tgz -> npmpkg-@typescript-eslint-utils-6.21.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-6.21.0.tgz -> npmpkg-@typescript-eslint-visitor-keys-6.21.0.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.14.1.tgz -> npmpkg-@webassemblyjs-ast-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.13.2.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.14.1.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.14.1.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.13.2.tgz -> npmpkg-@webassemblyjs-ieee754-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.13.2.tgz -> npmpkg-@webassemblyjs-leb128-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.13.2.tgz -> npmpkg-@webassemblyjs-utf8-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.14.1.tgz -> npmpkg-@webassemblyjs-wast-printer-1.14.1.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.2.0.tgz -> npmpkg-7zip-bin-5.2.0.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.14.0.tgz -> npmpkg-acorn-8.14.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/agentkeepalive/-/agentkeepalive-4.5.0.tgz -> npmpkg-agentkeepalive-4.5.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-4.0.1.tgz -> npmpkg-aggregate-error-4.0.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-formats/-/ajv-formats-2.1.1.tgz -> npmpkg-ajv-formats-2.1.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/all-package-names/-/all-package-names-2.0.897.tgz -> npmpkg-all-package-names-2.0.897.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-3.0.1.tgz -> npmpkg-ansi-align-3.0.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-observable/-/any-observable-0.3.0.tgz -> npmpkg-any-observable-0.3.0.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-24.13.3.tgz -> npmpkg-app-builder-lib-24.13.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/aproba/-/aproba-2.0.0.tgz -> npmpkg-aproba-2.0.0.tgz
https://registry.npmjs.org/archiver/-/archiver-5.3.2.tgz -> npmpkg-archiver-5.3.2.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-2.1.0.tgz -> npmpkg-archiver-utils-2.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-3.0.1.tgz -> npmpkg-are-we-there-yet-3.0.1.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.8.tgz -> npmpkg-array-includes-3.1.8.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.5.tgz -> npmpkg-array.prototype.findlastindex-1.2.5.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.2.tgz -> npmpkg-array.prototype.flat-1.3.2.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.2.tgz -> npmpkg-array.prototype.flatmap-1.3.2.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/atomically/-/atomically-1.7.0.tgz -> npmpkg-atomically-1.7.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/big-integer/-/big-integer-1.6.52.tgz -> npmpkg-big-integer-1.6.52.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/boxen/-/boxen-8.0.1.tgz -> npmpkg-boxen-8.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-8.0.0.tgz -> npmpkg-camelcase-8.0.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-10.4.0.tgz -> npmpkg-emoji-regex-10.4.0.tgz
https://registry.npmjs.org/string-width/-/string-width-7.2.0.tgz -> npmpkg-string-width-7.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.29.0.tgz -> npmpkg-type-fest-4.29.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-9.0.0.tgz -> npmpkg-wrap-ansi-9.0.0.tgz
https://registry.npmjs.org/bplist-parser/-/bplist-parser-0.2.0.tgz -> npmpkg-bplist-parser-0.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.2.tgz -> npmpkg-browserslist-4.24.2.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.1.tgz -> npmpkg-buffer-equal-1.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/builtins/-/builtins-1.0.3.tgz -> npmpkg-builtins-1.0.3.tgz
https://registry.npmjs.org/bundle-name/-/bundle-name-3.0.0.tgz -> npmpkg-bundle-name-3.0.0.tgz
https://registry.npmjs.org/cacache/-/cacache-17.1.4.tgz -> npmpkg-cacache-17.1.4.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-4.2.0.tgz -> npmpkg-callsites-4.2.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-7.0.2.tgz -> npmpkg-camelcase-keys-7.0.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001684.tgz -> npmpkg-caniuse-lite-1.0.30001684.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chalk-template/-/chalk-template-1.1.0.tgz -> npmpkg-chalk-template-1.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.4.tgz -> npmpkg-chrome-trace-event-1.0.4.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/clean-regexp/-/clean-regexp-1.0.0.tgz -> npmpkg-clean-regexp-1.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-4.2.0.tgz -> npmpkg-clean-stack-4.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-3.0.0.tgz -> npmpkg-cli-boxes-3.0.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-2.1.0.tgz -> npmpkg-cli-cursor-2.1.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.9.2.tgz -> npmpkg-cli-spinners-2.9.2.tgz
https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.5.tgz -> npmpkg-cli-table3-0.6.5.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-4.1.0.tgz -> npmpkg-cli-width-4.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz -> npmpkg-color-support-1.1.3.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/commander-version/-/commander-version-1.1.0.tgz -> npmpkg-commander-version-1.1.0.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/common-path-prefix/-/common-path-prefix-3.0.0.tgz -> npmpkg-common-path-prefix-3.0.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-4.1.2.tgz -> npmpkg-compress-commons-4.1.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/conf/-/conf-10.2.0.tgz -> npmpkg-conf-10.2.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/json-schema-typed/-/json-schema-typed-7.0.3.tgz -> npmpkg-json-schema-typed-7.0.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/config-file-ts/-/config-file-ts-0.2.6.tgz -> npmpkg-config-file-ts-0.2.6.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/configstore/-/configstore-7.0.0.tgz -> npmpkg-configstore-7.0.0.tgz
https://registry.npmjs.org/atomically/-/atomically-2.0.3.tgz -> npmpkg-atomically-2.0.3.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-9.0.0.tgz -> npmpkg-dot-prop-9.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.29.0.tgz -> npmpkg-type-fest-4.29.0.tgz
https://registry.npmjs.org/confusing-browser-globals/-/confusing-browser-globals-1.0.11.tgz -> npmpkg-confusing-browser-globals-1.0.11.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.39.0.tgz -> npmpkg-core-js-compat-3.39.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.3.6.tgz -> npmpkg-cosmiconfig-8.3.6.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc-32/-/crc-32-1.2.2.tgz -> npmpkg-crc-32-1.2.2.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-4.0.3.tgz -> npmpkg-crc32-stream-4.0.3.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz -> npmpkg-cross-spawn-7.0.6.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-4.0.0.tgz -> npmpkg-crypto-random-string-4.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/css-functions-list/-/css-functions-list-3.2.3.tgz -> npmpkg-css-functions-list-3.2.3.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/date-fns/-/date-fns-1.30.1.tgz -> npmpkg-date-fns-1.30.1.tgz
https://registry.npmjs.org/debounce-fn/-/debounce-fn-4.0.0.tgz -> npmpkg-debounce-fn-4.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decamelize/-/decamelize-5.0.1.tgz -> npmpkg-decamelize-5.0.1.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/default-browser/-/default-browser-4.0.0.tgz -> npmpkg-default-browser-4.0.0.tgz
https://registry.npmjs.org/default-browser-id/-/default-browser-id-3.0.0.tgz -> npmpkg-default-browser-id-3.0.0.tgz
https://registry.npmjs.org/execa/-/execa-7.2.0.tgz -> npmpkg-execa-7.2.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.3.0.tgz -> npmpkg-npm-run-path-5.3.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/defaults/-/defaults-1.0.4.tgz -> npmpkg-defaults-1.0.4.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-3.0.0.tgz -> npmpkg-define-lazy-prop-3.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/del/-/del-7.1.0.tgz -> npmpkg-del-7.1.0.tgz
https://registry.npmjs.org/del-cli/-/del-cli-5.1.0.tgz -> npmpkg-del-cli-5.1.0.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-3.3.0.tgz -> npmpkg-dir-compare-3.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.13.3.tgz -> npmpkg-dmg-builder-24.13.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dns-packet/-/dns-packet-5.6.1.tgz -> npmpkg-dns-packet-5.6.1.tgz
https://registry.npmjs.org/dns-socket/-/dns-socket-4.2.2.tgz -> npmpkg-dns-socket-4.2.2.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-6.0.1.tgz -> npmpkg-dot-prop-6.0.1.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron/-/electron-34.0.0-beta.7.tgz -> npmpkg-electron-34.0.0-beta.7.tgz
https://registry.npmjs.org/electron-better-ipc/-/electron-better-ipc-2.0.1.tgz -> npmpkg-electron-better-ipc-2.0.1.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-24.13.3.tgz -> npmpkg-electron-builder-24.13.3.tgz
https://registry.npmjs.org/electron-builder-squirrel-windows/-/electron-builder-squirrel-windows-24.13.3.tgz -> npmpkg-electron-builder-squirrel-windows-24.13.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-context-menu/-/electron-context-menu-3.6.1.tgz -> npmpkg-electron-context-menu-3.6.1.tgz
https://registry.npmjs.org/electron-debug/-/electron-debug-3.2.0.tgz -> npmpkg-electron-debug-3.2.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-1.2.0.tgz -> npmpkg-electron-is-dev-1.2.0.tgz
https://registry.npmjs.org/electron-dl/-/electron-dl-3.5.2.tgz -> npmpkg-electron-dl-3.5.2.tgz
https://registry.npmjs.org/electron-is-accelerator/-/electron-is-accelerator-0.1.2.tgz -> npmpkg-electron-is-accelerator-0.1.2.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-localshortcut/-/electron-localshortcut-3.2.1.tgz -> npmpkg-electron-localshortcut-3.2.1.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-24.13.1.tgz -> npmpkg-electron-publish-24.13.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-store/-/electron-store-8.2.0.tgz -> npmpkg-electron-store-8.2.0.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.67.tgz -> npmpkg-electron-to-chromium-1.5.67.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-6.3.9.tgz -> npmpkg-electron-updater-6.3.9.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.10.tgz -> npmpkg-builder-util-runtime-9.2.10.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-util/-/electron-util-0.17.2.tgz -> npmpkg-electron-util-0.17.2.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-1.2.0.tgz -> npmpkg-electron-is-dev-1.2.0.tgz
https://registry.npmjs.org/elegant-spinner/-/elegant-spinner-1.0.1.tgz -> npmpkg-elegant-spinner-1.0.1.tgz
https://registry.npmjs.org/element-ready/-/element-ready-5.0.0.tgz -> npmpkg-element-ready-5.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz -> npmpkg-encoding-0.1.13.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhance-visitors/-/enhance-visitors-1.0.0.tgz -> npmpkg-enhance-visitors-1.0.0.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-0.9.1.tgz -> npmpkg-enhanced-resolve-0.9.1.tgz
https://registry.npmjs.org/env-editor/-/env-editor-1.1.0.tgz -> npmpkg-env-editor-1.1.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.5.tgz -> npmpkg-es-abstract-1.23.5.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.5.4.tgz -> npmpkg-es-module-lexer-1.5.4.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz -> npmpkg-es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> npmpkg-es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz -> npmpkg-es-shim-unscopables-1.0.2.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.3.0.tgz -> npmpkg-es-to-primitive-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-4.0.0.tgz -> npmpkg-escape-goat-4.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.57.1.tgz -> npmpkg-eslint-8.57.1.tgz
https://registry.npmjs.org/eslint-compat-utils/-/eslint-compat-utils-0.5.1.tgz -> npmpkg-eslint-compat-utils-0.5.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/eslint-config-prettier/-/eslint-config-prettier-9.1.0.tgz -> npmpkg-eslint-config-prettier-9.1.0.tgz
https://registry.npmjs.org/eslint-config-xo/-/eslint-config-xo-0.44.0.tgz -> npmpkg-eslint-config-xo-0.44.0.tgz
https://registry.npmjs.org/eslint-config-xo-typescript/-/eslint-config-xo-typescript-2.1.1.tgz -> npmpkg-eslint-config-xo-typescript-2.1.1.tgz
https://registry.npmjs.org/eslint-formatter-pretty/-/eslint-formatter-pretty-6.0.1.tgz -> npmpkg-eslint-formatter-pretty-6.0.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-6.2.1.tgz -> npmpkg-ansi-escapes-6.2.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-10.4.0.tgz -> npmpkg-emoji-regex-10.4.0.tgz
https://registry.npmjs.org/string-width/-/string-width-7.2.0.tgz -> npmpkg-string-width-7.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-3.1.0.tgz -> npmpkg-supports-hyperlinks-3.1.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz -> npmpkg-eslint-import-resolver-node-0.3.9.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/eslint-import-resolver-webpack/-/eslint-import-resolver-webpack-0.13.9.tgz -> npmpkg-eslint-import-resolver-webpack-0.13.9.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.12.0.tgz -> npmpkg-eslint-module-utils-2.12.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-ava/-/eslint-plugin-ava-14.0.0.tgz -> npmpkg-eslint-plugin-ava-14.0.0.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-5.0.0.tgz -> npmpkg-pkg-dir-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/eslint-plugin-es-x/-/eslint-plugin-es-x-7.8.0.tgz -> npmpkg-eslint-plugin-es-x-7.8.0.tgz
https://registry.npmjs.org/eslint-plugin-eslint-comments/-/eslint-plugin-eslint-comments-3.2.0.tgz -> npmpkg-eslint-plugin-eslint-comments-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.31.0.tgz -> npmpkg-eslint-plugin-import-2.31.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/eslint-plugin-n/-/eslint-plugin-n-16.6.2.tgz -> npmpkg-eslint-plugin-n-16.6.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/builtins/-/builtins-5.1.0.tgz -> npmpkg-builtins-5.1.0.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/eslint-plugin-no-use-extend-native/-/eslint-plugin-no-use-extend-native-0.5.0.tgz -> npmpkg-eslint-plugin-no-use-extend-native-0.5.0.tgz
https://registry.npmjs.org/eslint-plugin-prettier/-/eslint-plugin-prettier-5.2.1.tgz -> npmpkg-eslint-plugin-prettier-5.2.1.tgz
https://registry.npmjs.org/eslint-plugin-unicorn/-/eslint-plugin-unicorn-51.0.1.tgz -> npmpkg-eslint-plugin-unicorn-51.0.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> npmpkg-@eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/ci-info/-/ci-info-4.1.0.tgz -> npmpkg-ci-info-4.1.0.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/eslint-rule-docs/-/eslint-rule-docs-1.1.235.tgz -> npmpkg-eslint-rule-docs-1.1.235.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-3.0.0.tgz -> npmpkg-eslint-utils-3.0.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz -> npmpkg-eslint-visitor-keys-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> npmpkg-@eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/esm-utils/-/esm-utils-4.3.0.tgz -> npmpkg-esm-utils-4.3.0.tgz
https://registry.npmjs.org/espree/-/espree-10.3.0.tgz -> npmpkg-espree-10.3.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-4.2.0.tgz -> npmpkg-eslint-visitor-keys-4.2.0.tgz
https://registry.npmjs.org/espurify/-/espurify-2.1.1.tgz -> npmpkg-espurify-2.1.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.6.0.tgz -> npmpkg-esquery-1.6.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/execa/-/execa-2.1.0.tgz -> npmpkg-execa-2.1.0.tgz
https://registry.npmjs.org/exit-hook/-/exit-hook-4.0.0.tgz -> npmpkg-exit-hook-4.0.0.tgz
https://registry.npmjs.org/exponential-backoff/-/exponential-backoff-3.1.1.tgz -> npmpkg-exponential-backoff-3.1.1.tgz
https://registry.npmjs.org/ext-list/-/ext-list-2.2.2.tgz -> npmpkg-ext-list-2.2.2.tgz
https://registry.npmjs.org/ext-name/-/ext-name-5.0.0.tgz -> npmpkg-ext-name-5.0.0.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/facebook-locales/-/facebook-locales-1.0.916.tgz -> npmpkg-facebook-locales-1.0.916.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-diff/-/fast-diff-1.3.0.tgz -> npmpkg-fast-diff-1.3.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fast-memoize/-/fast-memoize-2.5.2.tgz -> npmpkg-fast-memoize-2.5.2.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.0.3.tgz -> npmpkg-fast-uri-3.0.3.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/figures/-/figures-1.7.0.tgz -> npmpkg-figures-1.7.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-5.0.0.tgz -> npmpkg-find-cache-dir-5.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-6.3.0.tgz -> npmpkg-find-up-6.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-7.2.0.tgz -> npmpkg-locate-path-7.2.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-4.0.0.tgz -> npmpkg-p-limit-4.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-6.0.0.tgz -> npmpkg-p-locate-6.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-7.0.0.tgz -> npmpkg-pkg-dir-7.0.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.1.1.tgz -> npmpkg-yocto-queue-1.1.1.tgz
https://registry.npmjs.org/find-root/-/find-root-1.1.0.tgz -> npmpkg-find-root-1.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/find-up-simple/-/find-up-simple-1.0.0.tgz -> npmpkg-find-up-simple-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> npmpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz -> npmpkg-flat-cache-3.2.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.3.2.tgz -> npmpkg-flatted-3.3.2.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.1.tgz -> npmpkg-form-data-4.0.1.tgz
https://registry.npmjs.org/form-data-encoder/-/form-data-encoder-2.1.4.tgz -> npmpkg-form-data-encoder-2.1.4.tgz
https://registry.npmjs.org/fp-and-or/-/fp-and-or-0.1.4.tgz -> npmpkg-fp-and-or-0.1.4.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-3.0.3.tgz -> npmpkg-fs-minipass-3.0.3.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gauge/-/gauge-4.0.4.tgz -> npmpkg-gauge-4.0.4.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-east-asian-width/-/get-east-asian-width-1.3.0.tgz -> npmpkg-get-east-asian-width-1.3.0.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-set-props/-/get-set-props-0.1.0.tgz -> npmpkg-get-set-props-0.1.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-8.0.0.tgz -> npmpkg-get-stdin-8.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/get-tsconfig/-/get-tsconfig-4.8.1.tgz -> npmpkg-get-tsconfig-4.8.1.tgz
https://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.5.0.tgz -> npmpkg-github-url-from-git-1.5.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/global-directory/-/global-directory-4.0.1.tgz -> npmpkg-global-directory-4.0.1.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-3.0.1.tgz -> npmpkg-global-dirs-3.0.1.tgz
https://registry.npmjs.org/ini/-/ini-2.0.0.tgz -> npmpkg-ini-2.0.0.tgz
https://registry.npmjs.org/global-modules/-/global-modules-2.0.0.tgz -> npmpkg-global-modules-2.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-3.0.0.tgz -> npmpkg-global-prefix-3.0.0.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/globals/-/globals-14.0.0.tgz -> npmpkg-globals-14.0.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/globby/-/globby-13.2.2.tgz -> npmpkg-globby-13.2.2.tgz
https://registry.npmjs.org/globjoin/-/globjoin-0.1.4.tgz -> npmpkg-globjoin-0.1.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.1.0.tgz -> npmpkg-gopd-1.1.0.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz -> npmpkg-graphemer-1.4.0.tgz
https://registry.npmjs.org/hard-rejection/-/hard-rejection-2.1.0.tgz -> npmpkg-hard-rejection-2.1.0.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-3.0.0.tgz -> npmpkg-has-yarn-3.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/html-tags/-/html-tags-3.3.1.tgz -> npmpkg-html-tags-3.3.1.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-4.3.1.tgz -> npmpkg-human-signals-4.3.1.tgz
https://registry.npmjs.org/humanize-ms/-/humanize-ms-1.2.1.tgz -> npmpkg-humanize-ms-1.2.1.tgz
https://registry.npmjs.org/husky/-/husky-9.1.7.tgz -> npmpkg-husky-9.1.7.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz -> npmpkg-ignore-5.3.2.tgz
https://registry.npmjs.org/ignore-walk/-/ignore-walk-6.0.5.tgz -> npmpkg-ignore-walk-6.0.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-4.0.0.tgz -> npmpkg-import-lazy-4.0.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.2.0.tgz -> npmpkg-import-local-3.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-4.1.0.tgz -> npmpkg-import-meta-resolve-4.1.0.tgz
https://registry.npmjs.org/import-modules/-/import-modules-2.1.0.tgz -> npmpkg-import-modules-2.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-3.2.0.tgz -> npmpkg-indent-string-3.2.0.tgz
https://registry.npmjs.org/index-to-position/-/index-to-position-0.1.2.tgz -> npmpkg-index-to-position-0.1.2.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-4.1.1.tgz -> npmpkg-ini-4.1.1.tgz
https://registry.npmjs.org/inquirer/-/inquirer-9.3.7.tgz -> npmpkg-inquirer-9.3.7.tgz
https://registry.npmjs.org/inquirer-autosubmit-prompt/-/inquirer-autosubmit-prompt-0.2.0.tgz -> npmpkg-inquirer-autosubmit-prompt-0.2.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/cli-width/-/cli-width-2.2.1.tgz -> npmpkg-cli-width-2.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-6.5.2.tgz -> npmpkg-inquirer-6.5.2.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.7.tgz -> npmpkg-mute-stream-0.0.7.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/ip-address/-/ip-address-9.0.5.tgz -> npmpkg-ip-address-9.0.5.tgz
https://registry.npmjs.org/ip-regex/-/ip-regex-4.3.0.tgz -> npmpkg-ip-regex-4.3.0.tgz
https://registry.npmjs.org/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> npmpkg-irregular-plurals-3.5.0.tgz
https://registry.npmjs.org/is-absolute/-/is-absolute-1.0.0.tgz -> npmpkg-is-absolute-1.0.0.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-async-function/-/is-async-function-2.0.0.tgz -> npmpkg-is-async-function-2.0.0.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> npmpkg-is-builtin-module-3.2.1.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-docker/-/is-docker-3.0.0.tgz -> npmpkg-is-docker-3.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finalizationregistry/-/is-finalizationregistry-1.1.0.tgz -> npmpkg-is-finalizationregistry-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.0.10.tgz -> npmpkg-is-generator-function-1.0.10.tgz
https://registry.npmjs.org/is-get-set-prop/-/is-get-set-prop-1.0.0.tgz -> npmpkg-is-get-set-prop-1.0.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-in-ci/-/is-in-ci-1.0.0.tgz -> npmpkg-is-in-ci-1.0.0.tgz
https://registry.npmjs.org/is-inside-container/-/is-inside-container-1.0.0.tgz -> npmpkg-is-inside-container-1.0.0.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-1.0.0.tgz -> npmpkg-is-installed-globally-1.0.0.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-2.0.0.tgz -> npmpkg-is-interactive-2.0.0.tgz
https://registry.npmjs.org/is-ip/-/is-ip-3.1.0.tgz -> npmpkg-is-ip-3.1.0.tgz
https://registry.npmjs.org/is-js-type/-/is-js-type-2.0.0.tgz -> npmpkg-is-js-type-2.0.0.tgz
https://registry.npmjs.org/is-lambda/-/is-lambda-1.0.1.tgz -> npmpkg-is-lambda-1.0.1.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz -> npmpkg-is-map-2.0.3.tgz
https://registry.npmjs.org/is-name-taken/-/is-name-taken-2.0.0.tgz -> npmpkg-is-name-taken-2.0.0.tgz
https://registry.npmjs.org/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> npmpkg-is-negated-glob-1.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-npm/-/is-npm-6.0.0.tgz -> npmpkg-is-npm-6.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-obj-prop/-/is-obj-prop-1.0.0.tgz -> npmpkg-is-obj-prop-1.0.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/is-observable/-/is-observable-1.1.0.tgz -> npmpkg-is-observable-1.1.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-1.2.0.tgz -> npmpkg-symbol-observable-1.2.0.tgz
https://registry.npmjs.org/is-online/-/is-online-9.0.1.tgz -> npmpkg-is-online-9.0.1.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-3.0.0.tgz -> npmpkg-is-path-cwd-3.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-4.0.0.tgz -> npmpkg-is-path-inside-4.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz -> npmpkg-is-promise-2.2.2.tgz
https://registry.npmjs.org/is-proto-prop/-/is-proto-prop-2.0.0.tgz -> npmpkg-is-proto-prop-2.0.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.2.0.tgz -> npmpkg-is-regex-1.2.0.tgz
https://registry.npmjs.org/is-relative/-/is-relative-1.0.0.tgz -> npmpkg-is-relative-1.0.0.tgz
https://registry.npmjs.org/is-scoped/-/is-scoped-3.0.0.tgz -> npmpkg-is-scoped-3.0.0.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz -> npmpkg-is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-unc-path/-/is-unc-path-1.0.0.tgz -> npmpkg-is-unc-path-1.0.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-1.3.0.tgz -> npmpkg-is-unicode-supported-1.3.0.tgz
https://registry.npmjs.org/is-url-superb/-/is-url-superb-6.1.0.tgz -> npmpkg-is-url-superb-6.1.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz -> npmpkg-is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.3.tgz -> npmpkg-is-weakset-2.0.3.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-yarn-global/-/is-yarn-global-0.4.1.tgz -> npmpkg-is-yarn-global-0.4.1.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.4.tgz -> npmpkg-isbinaryfile-5.0.4.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/issue-regex/-/issue-regex-4.3.0.tgz -> npmpkg-issue-regex-4.3.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/jake/-/jake-10.9.2.tgz -> npmpkg-jake-10.9.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz -> npmpkg-jest-worker-27.5.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jju/-/jju-1.4.0.tgz -> npmpkg-jju-1.4.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-types/-/js-types-1.0.0.tgz -> npmpkg-js-types-1.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsbn/-/jsbn-1.1.0.tgz -> npmpkg-jsbn-1.1.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-3.0.2.tgz -> npmpkg-jsesc-3.0.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-parse-helpfulerror/-/json-parse-helpfulerror-1.0.3.tgz -> npmpkg-json-parse-helpfulerror-1.0.3.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-schema-typed/-/json-schema-typed-8.0.1.tgz -> npmpkg-json-schema-typed-8.0.1.tgz
https://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-1.1.1.tgz -> npmpkg-json-stable-stringify-1.1.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/jsonify/-/jsonify-0.0.1.tgz -> npmpkg-jsonify-0.0.1.tgz
https://registry.npmjs.org/jsonlines/-/jsonlines-0.1.1.tgz -> npmpkg-jsonlines-0.1.1.tgz
https://registry.npmjs.org/jsonparse/-/jsonparse-1.3.1.tgz -> npmpkg-jsonparse-1.3.1.tgz
https://registry.npmjs.org/keyboardevent-from-electron-accelerator/-/keyboardevent-from-electron-accelerator-2.0.0.tgz -> npmpkg-keyboardevent-from-electron-accelerator-2.0.0.tgz
https://registry.npmjs.org/keyboardevents-areequal/-/keyboardevents-areequal-0.2.2.tgz -> npmpkg-keyboardevents-areequal-0.2.2.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/klaw-sync/-/klaw-sync-6.0.0.tgz -> npmpkg-klaw-sync-6.0.0.tgz
https://registry.npmjs.org/kleur/-/kleur-4.1.5.tgz -> npmpkg-kleur-4.1.5.tgz
https://registry.npmjs.org/known-css-properties/-/known-css-properties-0.26.0.tgz -> npmpkg-known-css-properties-0.26.0.tgz
https://registry.npmjs.org/ky/-/ky-1.7.2.tgz -> npmpkg-ky-1.7.2.tgz
https://registry.npmjs.org/latest-version/-/latest-version-9.0.0.tgz -> npmpkg-latest-version-9.0.0.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/line-column-path/-/line-column-path-3.0.0.tgz -> npmpkg-line-column-path-3.0.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/listr/-/listr-0.14.3.tgz -> npmpkg-listr-0.14.3.tgz
https://registry.npmjs.org/listr-input/-/listr-input-0.2.1.tgz -> npmpkg-listr-input-0.2.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-3.0.0.tgz -> npmpkg-cli-width-3.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/figures/-/figures-3.2.0.tgz -> npmpkg-figures-3.2.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-7.3.3.tgz -> npmpkg-inquirer-7.3.3.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.8.tgz -> npmpkg-mute-stream-0.0.8.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/listr-silent-renderer/-/listr-silent-renderer-1.1.1.tgz -> npmpkg-listr-silent-renderer-1.1.1.tgz
https://registry.npmjs.org/listr-update-renderer/-/listr-update-renderer-0.5.0.tgz -> npmpkg-listr-update-renderer-0.5.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-0.2.1.tgz -> npmpkg-cli-truncate-0.2.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-1.0.2.tgz -> npmpkg-log-symbols-1.0.2.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-0.0.4.tgz -> npmpkg-slice-ansi-0.0.4.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/listr-verbose-renderer/-/listr-verbose-renderer-0.5.0.tgz -> npmpkg-listr-verbose-renderer-0.5.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash-es/-/lodash-es-4.17.21.tgz -> npmpkg-lodash-es-4.17.21.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> npmpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> npmpkg-lodash.truncate-4.4.2.tgz
https://registry.npmjs.org/lodash.union/-/lodash.union-4.6.0.tgz -> npmpkg-lodash.union-4.6.0.tgz
https://registry.npmjs.org/lodash.zip/-/lodash.zip-4.2.0.tgz -> npmpkg-lodash.zip-4.2.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-6.0.0.tgz -> npmpkg-log-symbols-6.0.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/log-update/-/log-update-2.3.0.tgz -> npmpkg-log-update-2.3.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-3.0.1.tgz -> npmpkg-wrap-ansi-3.0.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-11.1.1.tgz -> npmpkg-make-fetch-happen-11.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/many-keys-map/-/many-keys-map-1.0.3.tgz -> npmpkg-many-keys-map-1.0.3.tgz
https://registry.npmjs.org/map-obj/-/map-obj-4.3.0.tgz -> npmpkg-map-obj-4.3.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/mathml-tag-names/-/mathml-tag-names-2.1.3.tgz -> npmpkg-mathml-tag-names-2.1.3.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.2.0.tgz -> npmpkg-memory-fs-0.2.0.tgz
https://registry.npmjs.org/meow/-/meow-10.1.5.tgz -> npmpkg-meow-10.1.5.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micro-spelling-correcter/-/micro-spelling-correcter-1.1.1.tgz -> npmpkg-micro-spelling-correcter-1.1.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.53.0.tgz -> npmpkg-mime-db-1.53.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-3.1.0.tgz -> npmpkg-mimic-fn-3.1.0.tgz
https://registry.npmjs.org/mimic-function/-/mimic-function-5.0.1.tgz -> npmpkg-mimic-function-5.0.1.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-4.1.0.tgz -> npmpkg-minimist-options-4.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minipass-collect/-/minipass-collect-1.0.2.tgz -> npmpkg-minipass-collect-1.0.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-3.0.5.tgz -> npmpkg-minipass-fetch-3.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz -> npmpkg-minipass-flush-1.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-json-stream/-/minipass-json-stream-1.0.2.tgz -> npmpkg-minipass-json-stream-1.0.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> npmpkg-minipass-pipeline-1.2.4.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-sized/-/minipass-sized-1.0.3.tgz -> npmpkg-minipass-sized-1.0.3.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/modify-filename/-/modify-filename-1.1.0.tgz -> npmpkg-modify-filename-1.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-1.0.0.tgz -> npmpkg-mute-stream-1.0.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.8.tgz -> npmpkg-nanoid-3.3.8.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.4.tgz -> npmpkg-negotiator-0.6.4.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/new-github-issue-url/-/new-github-issue-url-0.2.1.tgz -> npmpkg-new-github-issue-url-0.2.1.tgz
https://registry.npmjs.org/new-github-release-url/-/new-github-release-url-2.0.0.tgz -> npmpkg-new-github-release-url-2.0.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-gyp/-/node-gyp-9.4.1.tgz -> npmpkg-node-gyp-9.4.1.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-2.1.2.tgz -> npmpkg-@npmcli-fs-2.1.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/cacache/-/cacache-16.1.3.tgz -> npmpkg-cacache-16.1.3.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> npmpkg-make-fetch-happen-10.2.1.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> npmpkg-minipass-fetch-2.1.2.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/ssri/-/ssri-9.0.1.tgz -> npmpkg-ssri-9.0.1.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-2.0.1.tgz -> npmpkg-unique-filename-2.0.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-3.0.0.tgz -> npmpkg-unique-slug-3.0.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/nopt/-/nopt-6.0.0.tgz -> npmpkg-nopt-6.0.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> npmpkg-normalize-package-data-3.0.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/np/-/np-9.2.0.tgz -> npmpkg-np-9.2.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-7.0.2.tgz -> npmpkg-hosted-git-info-7.0.2.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/meow/-/meow-12.1.1.tgz -> npmpkg-meow-12.1.1.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.3.0.tgz -> npmpkg-npm-run-path-5.3.0.tgz
https://registry.npmjs.org/onetime/-/onetime-7.0.0.tgz -> npmpkg-onetime-7.0.0.tgz
https://registry.npmjs.org/p-timeout/-/p-timeout-6.1.3.tgz -> npmpkg-p-timeout-6.1.3.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/npm-bundled/-/npm-bundled-3.0.1.tgz -> npmpkg-npm-bundled-3.0.1.tgz
https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.20.tgz -> npmpkg-npm-check-updates-16.14.20.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-5.6.0.tgz -> npmpkg-@sindresorhus-is-5.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-5.0.1.tgz -> npmpkg-@szmarczak-http-timer-5.0.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/boxen/-/boxen-7.1.1.tgz -> npmpkg-boxen-7.1.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-7.0.0.tgz -> npmpkg-cacheable-lookup-7.0.0.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-10.2.14.tgz -> npmpkg-cacheable-request-10.2.14.tgz
https://registry.npmjs.org/camelcase/-/camelcase-7.0.1.tgz -> npmpkg-camelcase-7.0.1.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/commander/-/commander-10.0.1.tgz -> npmpkg-commander-10.0.1.tgz
https://registry.npmjs.org/configstore/-/configstore-6.0.0.tgz -> npmpkg-configstore-6.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/got/-/got-12.6.1.tgz -> npmpkg-got-12.6.1.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-5.2.1.tgz -> npmpkg-hosted-git-info-5.2.1.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-2.2.1.tgz -> npmpkg-http2-wrapper-2.2.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.4.0.tgz -> npmpkg-is-installed-globally-0.4.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/latest-version/-/latest-version-7.0.0.tgz -> npmpkg-latest-version-7.0.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-3.0.0.tgz -> npmpkg-lowercase-keys-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-4.0.0.tgz -> npmpkg-mimic-response-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-8.0.1.tgz -> npmpkg-normalize-url-8.0.1.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-3.0.0.tgz -> npmpkg-p-cancelable-3.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/package-json/-/package-json-8.1.1.tgz -> npmpkg-package-json-8.1.1.tgz
https://registry.npmjs.org/pupa/-/pupa-3.1.0.tgz -> npmpkg-pupa-3.1.0.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-5.0.3.tgz -> npmpkg-registry-auth-token-5.0.3.tgz
https://registry.npmjs.org/responselike/-/responselike-3.0.0.tgz -> npmpkg-responselike-3.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-5.0.10.tgz -> npmpkg-rimraf-5.0.10.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-6.0.2.tgz -> npmpkg-update-notifier-6.0.2.tgz
https://registry.npmjs.org/widest-line/-/widest-line-4.0.1.tgz -> npmpkg-widest-line-4.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/npm-install-checks/-/npm-install-checks-6.3.0.tgz -> npmpkg-npm-install-checks-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/npm-name/-/npm-name-7.1.1.tgz -> npmpkg-npm-name-7.1.1.tgz
https://registry.npmjs.org/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.1.tgz -> npmpkg-npm-normalize-package-bin-3.0.1.tgz
https://registry.npmjs.org/npm-package-arg/-/npm-package-arg-10.1.0.tgz -> npmpkg-npm-package-arg-10.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-6.1.3.tgz -> npmpkg-hosted-git-info-6.1.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/validate-npm-package-name/-/validate-npm-package-name-5.0.1.tgz -> npmpkg-validate-npm-package-name-5.0.1.tgz
https://registry.npmjs.org/npm-packlist/-/npm-packlist-7.0.4.tgz -> npmpkg-npm-packlist-7.0.4.tgz
https://registry.npmjs.org/npm-pick-manifest/-/npm-pick-manifest-8.0.2.tgz -> npmpkg-npm-pick-manifest-8.0.2.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/npm-registry-fetch/-/npm-registry-fetch-14.0.5.tgz -> npmpkg-npm-registry-fetch-14.0.5.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-3.1.0.tgz -> npmpkg-npm-run-path-3.1.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-6.0.2.tgz -> npmpkg-npmlog-6.0.2.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/obj-props/-/obj-props-1.4.0.tgz -> npmpkg-obj-props-1.4.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.3.tgz -> npmpkg-object-inspect-1.13.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.8.tgz -> npmpkg-object.fromentries-2.0.8.tgz
https://registry.npmjs.org/object.groupby/-/object.groupby-1.0.3.tgz -> npmpkg-object.groupby-1.0.3.tgz
https://registry.npmjs.org/object.values/-/object.values-1.2.0.tgz -> npmpkg-object.values-1.2.0.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/open/-/open-9.1.0.tgz -> npmpkg-open-9.1.0.tgz
https://registry.npmjs.org/open-editor/-/open-editor-4.1.1.tgz -> npmpkg-open-editor-4.1.1.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz -> npmpkg-optionator-0.9.4.tgz
https://registry.npmjs.org/ora/-/ora-5.4.1.tgz -> npmpkg-ora-5.4.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-1.0.0.tgz -> npmpkg-is-interactive-1.0.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/org-regex/-/org-regex-1.0.0.tgz -> npmpkg-org-regex-1.0.0.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/ow/-/ow-1.1.1.tgz -> npmpkg-ow-1.1.1.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-5.6.0.tgz -> npmpkg-@sindresorhus-is-5.6.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-7.2.0.tgz -> npmpkg-dot-prop-7.2.0.tgz
https://registry.npmjs.org/p-any/-/p-any-3.0.0.tgz -> npmpkg-p-any-3.0.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/p-defer/-/p-defer-3.0.0.tgz -> npmpkg-p-defer-3.0.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-2.0.1.tgz -> npmpkg-p-finally-2.0.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-lock/-/p-lock-2.1.0.tgz -> npmpkg-p-lock-2.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-5.5.0.tgz -> npmpkg-p-map-5.5.0.tgz
https://registry.npmjs.org/p-memoize/-/p-memoize-7.1.1.tgz -> npmpkg-p-memoize-7.1.1.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-3.13.1.tgz -> npmpkg-type-fest-3.13.1.tgz
https://registry.npmjs.org/p-some/-/p-some-5.0.0.tgz -> npmpkg-p-some-5.0.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/p-timeout/-/p-timeout-3.2.0.tgz -> npmpkg-p-timeout-3.2.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/p-wait-for/-/p-wait-for-3.2.0.tgz -> npmpkg-p-wait-for-3.2.0.tgz
https://registry.npmjs.org/package-json/-/package-json-10.0.1.tgz -> npmpkg-package-json-10.0.1.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-5.0.3.tgz -> npmpkg-registry-auth-token-5.0.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/package-name-conflict/-/package-name-conflict-1.0.3.tgz -> npmpkg-package-name-conflict-1.0.3.tgz
https://registry.npmjs.org/pacote/-/pacote-15.2.0.tgz -> npmpkg-pacote-15.2.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/parse-github-url/-/parse-github-url-1.0.3.tgz -> npmpkg-parse-github-url-1.0.3.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse-json-object/-/parse-json-object-2.0.1.tgz -> npmpkg-parse-json-object-2.0.1.tgz
https://registry.npmjs.org/patch-package/-/patch-package-8.0.0.tgz -> npmpkg-patch-package-8.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz -> npmpkg-picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-8.0.0.tgz -> npmpkg-pkg-dir-8.0.0.tgz
https://registry.npmjs.org/pkg-up/-/pkg-up-3.1.0.tgz -> npmpkg-pkg-up-3.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/plur/-/plur-5.1.0.tgz -> npmpkg-plur-5.1.0.tgz
https://registry.npmjs.org/pluralize/-/pluralize-8.0.0.tgz -> npmpkg-pluralize-8.0.0.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.49.tgz -> npmpkg-postcss-8.4.49.tgz
https://registry.npmjs.org/postcss-media-query-parser/-/postcss-media-query-parser-0.2.3.tgz -> npmpkg-postcss-media-query-parser-0.2.3.tgz
https://registry.npmjs.org/postcss-resolve-nested-selector/-/postcss-resolve-nested-selector-0.1.6.tgz -> npmpkg-postcss-resolve-nested-selector-0.1.6.tgz
https://registry.npmjs.org/postcss-safe-parser/-/postcss-safe-parser-6.0.0.tgz -> npmpkg-postcss-safe-parser-6.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/postcss-sorting/-/postcss-sorting-8.0.2.tgz -> npmpkg-postcss-sorting-8.0.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-3.4.1.tgz -> npmpkg-prettier-3.4.1.tgz
https://registry.npmjs.org/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz -> npmpkg-prettier-linter-helpers-1.0.0.tgz
https://registry.npmjs.org/proc-log/-/proc-log-3.0.0.tgz -> npmpkg-proc-log-3.0.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/prompts-ncu/-/prompts-ncu-3.0.1.tgz -> npmpkg-prompts-ncu-3.0.1.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proto-props/-/proto-props-2.0.0.tgz -> npmpkg-proto-props-2.0.0.tgz
https://registry.npmjs.org/public-ip/-/public-ip-4.0.4.tgz -> npmpkg-public-ip-4.0.4.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/pupa/-/pupa-2.1.1.tgz -> npmpkg-pupa-2.1.1.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-2.1.1.tgz -> npmpkg-escape-goat-2.1.1.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/rc-config-loader/-/rc-config-loader-4.1.3.tgz -> npmpkg-rc-config-loader-4.1.3.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.3.2.tgz -> npmpkg-read-config-file-6.3.2.tgz
https://registry.npmjs.org/read-file-safe/-/read-file-safe-1.0.10.tgz -> npmpkg-read-file-safe-1.0.10.tgz
https://registry.npmjs.org/read-json-safe/-/read-json-safe-1.0.5.tgz -> npmpkg-read-json-safe-1.0.5.tgz
https://registry.npmjs.org/parse-json-object/-/parse-json-object-1.1.0.tgz -> npmpkg-parse-json-object-1.1.0.tgz
https://registry.npmjs.org/read-package-json/-/read-package-json-6.0.4.tgz -> npmpkg-read-package-json-6.0.4.tgz
https://registry.npmjs.org/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz -> npmpkg-read-package-json-fast-3.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.2.tgz -> npmpkg-json-parse-even-better-errors-3.0.2.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-6.1.3.tgz -> npmpkg-hosted-git-info-6.1.3.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.2.tgz -> npmpkg-json-parse-even-better-errors-3.0.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-5.0.0.tgz -> npmpkg-normalize-package-data-5.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/read-package-up/-/read-package-up-11.0.0.tgz -> npmpkg-read-package-up-11.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.29.0.tgz -> npmpkg-type-fest-4.29.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-9.0.1.tgz -> npmpkg-read-pkg-9.0.1.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-8.0.0.tgz -> npmpkg-read-pkg-up-8.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-6.0.0.tgz -> npmpkg-read-pkg-6.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-7.0.2.tgz -> npmpkg-hosted-git-info-7.0.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-6.0.2.tgz -> npmpkg-normalize-package-data-6.0.2.tgz
https://registry.npmjs.org/parse-json/-/parse-json-8.1.0.tgz -> npmpkg-parse-json-8.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.29.0.tgz -> npmpkg-type-fest-4.29.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdir-glob/-/readdir-glob-1.1.3.tgz -> npmpkg-readdir-glob-1.1.3.tgz
https://registry.npmjs.org/redent/-/redent-4.0.0.tgz -> npmpkg-redent-4.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/reflect.getprototypeof/-/reflect.getprototypeof-1.0.7.tgz -> npmpkg-reflect.getprototypeof-1.0.7.tgz
https://registry.npmjs.org/regexp-tree/-/regexp-tree-0.1.27.tgz -> npmpkg-regexp-tree-0.1.27.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.3.tgz -> npmpkg-regexp.prototype.flags-1.5.3.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-4.2.2.tgz -> npmpkg-registry-auth-token-4.2.2.tgz
https://registry.npmjs.org/registry-url/-/registry-url-6.0.1.tgz -> npmpkg-registry-url-6.0.1.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.10.0.tgz -> npmpkg-regjsparser-0.10.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/remote-git-tags/-/remote-git-tags-3.0.0.tgz -> npmpkg-remote-git-tags-3.0.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.5.tgz -> npmpkg-resolve-2.0.0-next.5.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-pkg-maps/-/resolve-pkg-maps-1.0.0.tgz -> npmpkg-resolve-pkg-maps-1.0.0.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-2.0.0.tgz -> npmpkg-restore-cursor-2.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-1.2.0.tgz -> npmpkg-mimic-fn-1.2.0.tgz
https://registry.npmjs.org/onetime/-/onetime-2.0.1.tgz -> npmpkg-onetime-2.0.1.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/run-applescript/-/run-applescript-5.0.0.tgz -> npmpkg-run-applescript-5.0.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/run-async/-/run-async-3.0.0.tgz -> npmpkg-run-async-3.0.0.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/rxjs/-/rxjs-7.8.1.tgz -> npmpkg-rxjs-7.8.1.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.4.1.tgz -> npmpkg-sax-1.4.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/scoped-regex/-/scoped-regex-3.0.0.tgz -> npmpkg-scoped-regex-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-4.0.0.tgz -> npmpkg-semver-diff-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/semver-utils/-/semver-utils-1.1.4.tgz -> npmpkg-semver-utils-1.1.4.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-8.1.0.tgz -> npmpkg-serialize-error-8.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/sigstore/-/sigstore-1.9.0.tgz -> npmpkg-sigstore-1.9.0.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/socks/-/socks-2.8.3.tgz -> npmpkg-socks-2.8.3.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> npmpkg-socks-proxy-agent-7.0.0.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-1.1.2.tgz -> npmpkg-sort-keys-1.1.2.tgz
https://registry.npmjs.org/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> npmpkg-sort-keys-length-1.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/spawn-please/-/spawn-please-2.0.2.tgz -> npmpkg-spawn-please-2.0.2.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.20.tgz -> npmpkg-spdx-license-ids-3.0.20.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/ssri/-/ssri-10.0.6.tgz -> npmpkg-ssri-10.0.6.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-4.0.0.tgz -> npmpkg-strip-indent-4.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-5.0.1.tgz -> npmpkg-strip-json-comments-5.0.1.tgz
https://registry.npmjs.org/stubborn-fs/-/stubborn-fs-1.2.5.tgz -> npmpkg-stubborn-fs-1.2.5.tgz
https://registry.npmjs.org/style-search/-/style-search-0.1.0.tgz -> npmpkg-style-search-0.1.0.tgz
https://registry.npmjs.org/stylelint/-/stylelint-14.16.1.tgz -> npmpkg-stylelint-14.16.1.tgz
https://registry.npmjs.org/stylelint-config-xo/-/stylelint-config-xo-0.22.0.tgz -> npmpkg-stylelint-config-xo-0.22.0.tgz
https://registry.npmjs.org/stylelint-declaration-block-no-ignored-properties/-/stylelint-declaration-block-no-ignored-properties-2.8.0.tgz -> npmpkg-stylelint-declaration-block-no-ignored-properties-2.8.0.tgz
https://registry.npmjs.org/stylelint-order/-/stylelint-order-6.0.4.tgz -> npmpkg-stylelint-order-6.0.4.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-2.0.0.tgz -> npmpkg-balanced-match-2.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> npmpkg-camelcase-keys-6.2.2.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/meow/-/meow-9.0.0.tgz -> npmpkg-meow-9.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-4.0.1.tgz -> npmpkg-quick-lru-4.0.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-3.0.1.tgz -> npmpkg-trim-newlines-3.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.18.1.tgz -> npmpkg-type-fest-0.18.1.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-2.3.0.tgz -> npmpkg-supports-hyperlinks-2.3.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svg-tags/-/svg-tags-1.0.0.tgz -> npmpkg-svg-tags-1.0.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-4.0.0.tgz -> npmpkg-symbol-observable-4.0.0.tgz
https://registry.npmjs.org/synckit/-/synckit-0.9.2.tgz -> npmpkg-synckit-0.9.2.tgz
https://registry.npmjs.org/table/-/table-6.8.2.tgz -> npmpkg-table-6.8.2.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/tapable/-/tapable-0.1.10.tgz -> npmpkg-tapable-0.1.10.tgz
https://registry.npmjs.org/tar/-/tar-6.2.1.tgz -> npmpkg-tar-6.2.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/terminal-link/-/terminal-link-3.0.0.tgz -> npmpkg-terminal-link-3.0.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-5.0.0.tgz -> npmpkg-ansi-escapes-5.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/terser/-/terser-5.36.0.tgz -> npmpkg-terser-5.36.0.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz -> npmpkg-terser-webpack-plugin-5.3.10.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/tiny-typed-emitter/-/tiny-typed-emitter-2.1.0.tgz -> npmpkg-tiny-typed-emitter-2.1.0.tgz
https://registry.npmjs.org/titleize/-/titleize-3.0.0.tgz -> npmpkg-titleize-3.0.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz -> npmpkg-tmp-0.2.3.tgz
https://registry.npmjs.org/to-absolute-glob/-/to-absolute-glob-3.0.0.tgz -> npmpkg-to-absolute-glob-3.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-4.1.1.tgz -> npmpkg-trim-newlines-4.1.1.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-1.4.3.tgz -> npmpkg-ts-api-utils-1.4.3.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz -> npmpkg-tsconfig-paths-3.15.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz -> npmpkg-tslib-2.8.1.tgz
https://registry.npmjs.org/tuf-js/-/tuf-js-1.1.7.tgz -> npmpkg-tuf-js-1.1.7.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.3.tgz -> npmpkg-typed-array-byte-offset-1.0.3.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.7.tgz -> npmpkg-typed-array-length-1.0.7.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/types-eslintrc/-/types-eslintrc-1.0.3.tgz -> npmpkg-types-eslintrc-1.0.3.tgz
https://registry.npmjs.org/types-json/-/types-json-1.2.2.tgz -> npmpkg-types-json-1.2.2.tgz
https://registry.npmjs.org/types-pkg-json/-/types-pkg-json-1.2.1.tgz -> npmpkg-types-pkg-json-1.2.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.7.2.tgz -> npmpkg-typescript-5.7.2.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> npmpkg-unc-path-regex-0.1.2.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz -> npmpkg-undici-types-6.19.8.tgz
https://registry.npmjs.org/unicorn-magic/-/unicorn-magic-0.1.0.tgz -> npmpkg-unicorn-magic-0.1.0.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-3.0.0.tgz -> npmpkg-unique-filename-3.0.0.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-4.0.0.tgz -> npmpkg-unique-slug-4.0.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-3.0.0.tgz -> npmpkg-unique-string-3.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/untildify/-/untildify-4.0.0.tgz -> npmpkg-untildify-4.0.0.tgz
https://registry.npmjs.org/unused-filename/-/unused-filename-2.1.0.tgz -> npmpkg-unused-filename-2.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-7.3.1.tgz -> npmpkg-update-notifier-7.3.1.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/pupa/-/pupa-3.1.0.tgz -> npmpkg-pupa-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-or-path/-/url-or-path-2.3.2.tgz -> npmpkg-url-or-path-2.3.2.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.5.tgz -> npmpkg-utf8-byte-length-1.0.5.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.4.0.tgz -> npmpkg-v8-compile-cache-2.4.0.tgz
https://registry.npmjs.org/vali-date/-/vali-date-1.0.0.tgz -> npmpkg-vali-date-1.0.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/validate-npm-package-name/-/validate-npm-package-name-3.0.0.tgz -> npmpkg-validate-npm-package-name-3.0.0.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.2.tgz -> npmpkg-watchpack-2.4.2.tgz
https://registry.npmjs.org/wcwidth/-/wcwidth-1.0.1.tgz -> npmpkg-wcwidth-1.0.1.tgz
https://registry.npmjs.org/webpack/-/webpack-5.96.1.tgz -> npmpkg-webpack-5.96.1.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.17.1.tgz -> npmpkg-enhanced-resolve-5.17.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/when-exit/-/when-exit-2.1.3.tgz -> npmpkg-when-exit-2.1.3.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-builtin-type/-/which-builtin-type-1.2.0.tgz -> npmpkg-which-builtin-type-1.2.0.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz -> npmpkg-which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.16.tgz -> npmpkg-which-typed-array-1.1.16.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz -> npmpkg-wide-align-1.1.5.tgz
https://registry.npmjs.org/widest-line/-/widest-line-5.0.0.tgz -> npmpkg-widest-line-5.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-10.4.0.tgz -> npmpkg-emoji-regex-10.4.0.tgz
https://registry.npmjs.org/string-width/-/string-width-7.2.0.tgz -> npmpkg-string-width-7.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wnpm-ci/-/wnpm-ci-8.0.131.tgz -> npmpkg-wnpm-ci-8.0.131.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-5.1.0.tgz -> npmpkg-xdg-basedir-5.1.0.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xo/-/xo-0.57.0.tgz -> npmpkg-xo-0.57.0.tgz
https://registry.npmjs.org/arrify/-/arrify-3.0.0.tgz -> npmpkg-arrify-3.0.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-9.0.0.tgz -> npmpkg-get-stdin-9.0.0.tgz
https://registry.npmjs.org/globby/-/globby-14.0.2.tgz -> npmpkg-globby-14.0.2.tgz
https://registry.npmjs.org/meow/-/meow-13.2.0.tgz -> npmpkg-meow-13.2.0.tgz
https://registry.npmjs.org/path-type/-/path-type-5.0.0.tgz -> npmpkg-path-type-5.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slash/-/slash-5.1.0.tgz -> npmpkg-slash-5.1.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-2.6.1.tgz -> npmpkg-yaml-2.6.1.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/yoctocolors-cjs/-/yoctocolors-cjs-2.1.2.tgz -> npmpkg-yoctocolors-cjs-2.1.2.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-4.1.1.tgz -> npmpkg-zip-stream-4.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-3.0.4.tgz -> npmpkg-archiver-utils-3.0.4.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="
	MIT
	electron-34.0.0-alpha.7-chromium.html
	${ELECTRON_APP_LICENSES}
"
# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67
RESTRICT="mirror"
SLOT="0"
# Deps based on their CI
IUSE+="
	firejail
	ebuild-revision-7
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-16[npm]
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[X?,firejail_profiles_caprine]
	)
"

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
	check_network_sandbox
	npm_pkg_setup
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder \
		install-app-deps \
		|| die
}

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

		rm -vf package-lock.json
		enpm install \
			${NPM_INSTALL_ARGS[@]}
		enpm audit fix \
			${NPM_AUDIT_FIX_ARGS[@]}

einfo "Applying mitigation"
		patch_edits() {
			sed -i -e "s|\"got\": \"^11.8.0\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die
			sed -i -e "s|\"got\": \"^9.6.0\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die
		}
		patch_edits

	# DT = Data Tampering
		enpm install "got@^11.8.5" -P					# DT		# CVE-2022-33987
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D

		patch_edits

		_npm_check_errors
einfo "Updating lockfile done."
		exit 0
	else
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		npm_src_unpack
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
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "static/Icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Network"
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/${PN}"
	lcnr_install_files
	electron-app_set_sandbox_suid "/opt/caprine/chrome-sandbox"
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
	electron-app_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20240924)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20241009 with Electron 33.0.0-beta.9)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20241031 with Electron 34.0.0-alpha.5)
