# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="0916d8dd64f06580d640e645334586d8ba319cbf"
NPM_TARBALL="${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
NPM_INSTALL_PATH="/opt/${PN}"
ELECTRON_APP_ELECTRON_PV="18.3.15"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
NODE_ENV=development
NODE_VERSION="16"
inherit desktop electron-app lcnr npm

DESCRIPTION="A simple Instagram desktop uploader & client app build with \
electron.Mobile Instagram on desktop!"
HOMEPAGE="https://github.com/alexdevero/instatron"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

KEYWORDS="~amd64"
SLOT="0"
IUSE+=" r1"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/www-misc/instatron-1.5.0_p20221110/work/instatron-0916d8dd64f06580d640e645334586d8ba319cbf/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@electron/get/-/get-1.14.1.tgz -> npmpkg-@electron-get-1.14.1.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz -> npmpkg-@sindresorhus-is-0.14.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> npmpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.npmjs.org/@types/color-name/-/color-name-1.1.1.tgz -> npmpkg-@types-color-name-1.1.1.tgz
https://registry.npmjs.org/@types/events/-/events-3.0.0.tgz -> npmpkg-@types-events-3.0.0.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.1.1.tgz -> npmpkg-@types-glob-7.1.1.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.3.tgz -> npmpkg-@types-minimatch-3.0.3.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.3.tgz -> npmpkg-@types-node-16.18.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.2.1.tgz -> npmpkg-ansi-styles-4.2.1.tgz
https://registry.npmjs.org/asar/-/asar-2.1.0.tgz -> npmpkg-asar-2.1.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/author-regex/-/author-regex-1.0.0.tgz -> npmpkg-author-regex-1.0.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.5.1.tgz -> npmpkg-bluebird-3.5.1.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.1.tgz -> npmpkg-builtin-modules-1.1.1.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz -> npmpkg-cacheable-request-6.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.1.0.tgz -> npmpkg-get-stream-5.1.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.0.0.tgz -> npmpkg-camelcase-5.0.0.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.2.tgz -> npmpkg-clone-response-1.0.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.12.tgz -> npmpkg-config-chain-1.1.12.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/cross-env/-/cross-env-7.0.2.tgz -> npmpkg-cross-env-7.0.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.2.tgz -> npmpkg-cross-spawn-7.0.2.tgz
https://registry.npmjs.org/cross-zip/-/cross-zip-3.1.0.tgz -> npmpkg-cross-zip-3.1.0.tgz
https://registry.npmjs.org/cuint/-/cuint-0.2.2.tgz -> npmpkg-cuint-0.2.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz -> npmpkg-decompress-response-3.3.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> npmpkg-defer-to-connect-1.1.3.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.3.tgz -> npmpkg-define-properties-1.1.3.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.0.4.tgz -> npmpkg-detect-node-2.0.4.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.4.tgz -> npmpkg-duplexer3-0.1.4.tgz
https://registry.npmjs.org/electron/-/electron-18.3.15.tgz -> npmpkg-electron-18.3.15.tgz
https://registry.npmjs.org/electron-context-menu/-/electron-context-menu-2.0.1.tgz -> npmpkg-electron-context-menu-2.0.1.tgz
https://registry.npmjs.org/electron-dl/-/electron-dl-3.0.0.tgz -> npmpkg-electron-dl-3.0.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-1.0.1.tgz -> npmpkg-electron-is-dev-1.0.1.tgz
https://registry.npmjs.org/electron-notarize/-/electron-notarize-0.2.1.tgz -> npmpkg-electron-notarize-0.2.1.tgz
https://registry.npmjs.org/electron-osx-sign/-/electron-osx-sign-0.4.11.tgz -> npmpkg-electron-osx-sign-0.4.11.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/electron-packager/-/electron-packager-14.2.1.tgz -> npmpkg-electron-packager-14.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.0.tgz -> npmpkg-env-paths-2.2.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.1.tgz -> npmpkg-error-ex-1.3.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-2.1.1.tgz -> npmpkg-escape-goat-2.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/ext-list/-/ext-list-2.2.2.tgz -> npmpkg-ext-list-2.2.2.tgz
https://registry.npmjs.org/ext-name/-/ext-name-5.0.0.tgz -> npmpkg-ext-name-5.0.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/flora-colossus/-/flora-colossus-1.0.0.tgz -> npmpkg-flora-colossus-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-3.1.0.tgz -> npmpkg-debug-3.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-4.0.3.tgz -> npmpkg-fs-extra-4.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/galactus/-/galactus-0.2.1.tgz -> npmpkg-galactus-0.2.1.tgz
https://registry.npmjs.org/debug/-/debug-3.1.0.tgz -> npmpkg-debug-3.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-4.0.3.tgz -> npmpkg-fs-extra-4.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/get-package-info/-/get-package-info-1.0.0.tgz -> npmpkg-get-package-info-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> npmpkg-global-tunnel-ng-2.7.1.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.1.tgz -> npmpkg-globalthis-1.0.1.tgz
https://registry.npmjs.org/got/-/got-9.6.0.tgz -> npmpkg-got-9.6.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/ini/-/ini-1.3.7.tgz -> npmpkg-ini-1.3.7.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-1.0.0.tgz -> npmpkg-is-builtin-module-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-3.0.2.tgz -> npmpkg-isbinaryfile-3.0.2.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz -> npmpkg-json-buffer-3.0.0.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/junk/-/junk-3.1.0.tgz -> npmpkg-junk-3.1.0.tgz
https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz -> npmpkg-keyv-3.1.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-2.0.0.tgz -> npmpkg-load-json-file-2.0.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz -> npmpkg-lodash.get-4.4.2.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.33.0.tgz -> npmpkg-mime-db-1.33.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz -> npmpkg-mkdirp-0.5.5.tgz
https://registry.npmjs.org/modify-filename/-/modify-filename-1.1.0.tgz -> npmpkg-modify-filename-1.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.4.0.tgz -> npmpkg-normalize-package-data-2.4.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.1.tgz -> npmpkg-normalize-url-4.5.1.tgz
https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz -> npmpkg-npm-conf-1.1.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz -> npmpkg-p-cancelable-1.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.2.0.tgz -> npmpkg-p-limit-1.2.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/parse-author/-/parse-author-2.0.0.tgz -> npmpkg-parse-author-2.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-2.0.0.tgz -> npmpkg-path-type-2.0.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/plist/-/plist-3.0.5.tgz -> npmpkg-plist-3.0.5.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz -> npmpkg-prepend-http-2.0.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/pupa/-/pupa-2.0.1.tgz -> npmpkg-pupa-2.0.1.tgz
https://registry.npmjs.org/rcedit/-/rcedit-2.2.0.tgz -> npmpkg-rcedit-2.2.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-2.0.0.tgz -> npmpkg-read-pkg-2.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> npmpkg-read-pkg-up-2.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/resolve/-/resolve-1.5.0.tgz -> npmpkg-resolve-1.5.0.tgz
https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz -> npmpkg-responselike-1.0.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.1.tgz -> npmpkg-sanitize-filename-1.6.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-1.1.2.tgz -> npmpkg-sort-keys-1.1.2.tgz
https://registry.npmjs.org/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> npmpkg-sort-keys-length-1.0.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-1.0.2.tgz -> npmpkg-spdx-correct-1.0.2.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-1.0.4.tgz -> npmpkg-spdx-expression-parse-1.0.4.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-1.2.2.tgz -> npmpkg-spdx-license-ids-1.2.2.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.0.tgz -> npmpkg-string-width-4.2.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.0.tgz -> npmpkg-strip-ansi-6.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/tmp/-/tmp-0.1.0.tgz -> npmpkg-tmp-0.1.0.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-1.1.0.tgz -> npmpkg-tmp-promise-1.1.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> npmpkg-to-readable-stream-1.0.0.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.1.tgz -> npmpkg-universalify-0.1.1.tgz
https://registry.npmjs.org/unused-filename/-/unused-filename-2.1.0.tgz -> npmpkg-unused-filename-2.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> npmpkg-url-parse-lax-3.0.0.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.1.tgz -> npmpkg-validate-npm-package-license-3.0.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-9.0.7.tgz -> npmpkg-xmlbuilder-9.0.7.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-16.1.0.tgz -> npmpkg-yargs-parser-16.1.0.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/alexdevero/instatron/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-app_cp_electron
	sed -i -e "s|--platform=|--electron-zip-dir=${ELECTRON_CACHE} --build-version=${ELECTRON_APP_ELECTRON_PV} --platform=|g" package.json || die
	if use kernel_linux ; then
		npm run "package:linux" || die
	elif use kernel_Darwin ; then
		npm run "package:osx" || die
	fi
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "builds/${PN}-$(electron-app_get_electron_platarch)/"*
	fperms 0755 "${NPM_INSTALL_PATH}/${PN}"
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "assets/instagram-uploader-icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Network"
	LCNR_SOURCE="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
