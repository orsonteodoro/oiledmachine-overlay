# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="0916d8dd64f06580d640e645334586d8ba319cbf"
YARN_TARBALL="${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
YARN_INSTALL_PATH="/opt/${PN}"
ELECTRON_APP_ELECTRON_PV="18.3.7"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
NODE_ENV=development
NODE_VERSION="16"
inherit desktop electron-app lcnr yarn

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
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/www-misc/instatron-1.5.0_p20221110/work/instatron-0916d8dd64f06580d640e645334586d8ba319cbf/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@electron/get/-/get-1.14.1.tgz -> yarnpkg-@electron-get-1.14.1.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.14.0.tgz -> yarnpkg-@sindresorhus-is-0.14.0.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> yarnpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz -> yarnpkg-@types-glob-7.2.0.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.18.23.tgz -> yarnpkg-@types-node-16.18.23.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/asar/-/asar-2.1.0.tgz -> yarnpkg-asar-2.1.0.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/author-regex/-/author-regex-1.0.0.tgz -> yarnpkg-author-regex-1.0.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz -> yarnpkg-boolean-3.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> yarnpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> yarnpkg-buffer-alloc-1.2.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz -> yarnpkg-buffer-fill-1.0.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-6.1.0.tgz -> yarnpkg-cacheable-request-6.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> yarnpkg-chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz -> yarnpkg-cli-truncate-2.1.0.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz -> yarnpkg-clone-response-1.0.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/compare-version/-/compare-version-0.1.2.tgz -> yarnpkg-compare-version-0.1.2.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.13.tgz -> yarnpkg-config-chain-1.1.13.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cross-env/-/cross-env-7.0.3.tgz -> yarnpkg-cross-env-7.0.3.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/cross-zip/-/cross-zip-3.1.0.tgz -> yarnpkg-cross-zip-3.1.0.tgz
https://registry.yarnpkg.com/cuint/-/cuint-0.2.2.tgz -> yarnpkg-cuint-0.2.2.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz -> yarnpkg-decompress-response-3.3.0.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> yarnpkg-defer-to-connect-1.1.3.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.5.tgz -> yarnpkg-duplexer3-0.1.5.tgz
https://registry.yarnpkg.com/electron-context-menu/-/electron-context-menu-2.5.2.tgz -> yarnpkg-electron-context-menu-2.5.2.tgz
https://registry.yarnpkg.com/electron-dl/-/electron-dl-3.5.0.tgz -> yarnpkg-electron-dl-3.5.0.tgz
https://registry.yarnpkg.com/electron-is-dev/-/electron-is-dev-1.2.0.tgz -> yarnpkg-electron-is-dev-1.2.0.tgz
https://registry.yarnpkg.com/electron-notarize/-/electron-notarize-0.2.1.tgz -> yarnpkg-electron-notarize-0.2.1.tgz
https://registry.yarnpkg.com/electron-osx-sign/-/electron-osx-sign-0.4.17.tgz -> yarnpkg-electron-osx-sign-0.4.17.tgz
https://registry.yarnpkg.com/electron-packager/-/electron-packager-14.2.1.tgz -> yarnpkg-electron-packager-14.2.1.tgz
https://registry.yarnpkg.com/electron/-/electron-18.3.15.tgz -> yarnpkg-electron-18.3.15.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escape-goat/-/escape-goat-2.1.1.tgz -> yarnpkg-escape-goat-2.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/ext-list/-/ext-list-2.2.2.tgz -> yarnpkg-ext-list-2.2.2.tgz
https://registry.yarnpkg.com/ext-name/-/ext-name-5.0.0.tgz -> yarnpkg-ext-name-5.0.0.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz -> yarnpkg-extract-zip-1.7.0.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/flora-colossus/-/flora-colossus-1.0.1.tgz -> yarnpkg-flora-colossus-1.0.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-4.0.3.tgz -> yarnpkg-fs-extra-4.0.3.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.1.tgz -> yarnpkg-fs-extra-7.0.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/galactus/-/galactus-0.2.1.tgz -> yarnpkg-galactus-0.2.1.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-package-info/-/get-package-info-1.0.0.tgz -> yarnpkg-get-package-info-1.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz -> yarnpkg-get-stream-4.1.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz -> yarnpkg-get-stream-5.2.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz -> yarnpkg-global-agent-3.0.0.tgz
https://registry.yarnpkg.com/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> yarnpkg-global-tunnel-ng-2.7.1.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/got/-/got-9.6.0.tgz -> yarnpkg-got-9.6.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> yarnpkg-isbinaryfile-3.0.3.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.0.tgz -> yarnpkg-json-buffer-3.0.0.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/junk/-/junk-3.1.0.tgz -> yarnpkg-junk-3.1.0.tgz
https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz -> yarnpkg-keyv-3.1.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-2.0.0.tgz -> yarnpkg-load-json-file-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> yarnpkg-lowercase-keys-1.0.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/modify-filename/-/modify-filename-1.1.0.tgz -> yarnpkg-modify-filename-1.1.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.1.tgz -> yarnpkg-normalize-url-4.5.1.tgz
https://registry.yarnpkg.com/npm-conf/-/npm-conf-1.1.3.tgz -> yarnpkg-npm-conf-1.1.3.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-1.1.0.tgz -> yarnpkg-p-cancelable-1.1.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/parse-author/-/parse-author-2.0.0.tgz -> yarnpkg-parse-author-2.0.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-type/-/path-type-2.0.0.tgz -> yarnpkg-path-type-2.0.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/plist/-/plist-3.0.6.tgz -> yarnpkg-plist-3.0.6.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-2.0.0.tgz -> yarnpkg-prepend-http-2.0.0.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz -> yarnpkg-proto-list-1.2.4.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/pupa/-/pupa-2.1.1.tgz -> yarnpkg-pupa-2.1.1.tgz
https://registry.yarnpkg.com/rcedit/-/rcedit-2.3.0.tgz -> yarnpkg-rcedit-2.3.0.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> yarnpkg-read-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-2.0.0.tgz -> yarnpkg-read-pkg-2.0.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz -> yarnpkg-readable-stream-2.3.8.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz -> yarnpkg-resolve-1.22.2.tgz
https://registry.yarnpkg.com/responselike/-/responselike-1.0.2.tgz -> yarnpkg-responselike-1.0.2.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz -> yarnpkg-roarr-2.15.4.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz -> yarnpkg-slice-ansi-3.0.0.tgz
https://registry.yarnpkg.com/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> yarnpkg-sort-keys-length-1.0.1.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz -> yarnpkg-sort-keys-1.1.2.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> yarnpkg-spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz -> yarnpkg-sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/tmp-promise/-/tmp-promise-1.1.0.tgz -> yarnpkg-tmp-promise-1.1.0.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.1.0.tgz -> yarnpkg-tmp-0.1.0.tgz
https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> yarnpkg-to-readable-stream-1.0.0.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/unused-filename/-/unused-filename-2.1.0.tgz -> yarnpkg-unused-filename-2.1.0.tgz
https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> yarnpkg-url-parse-lax-3.0.0.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> yarnpkg-utf8-byte-length-1.0.4.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> yarnpkg-xmlbuilder-15.1.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-16.1.0.tgz -> yarnpkg-yargs-parser-16.1.0.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/alexdevero/instatron/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		rm yarn.lock
		npm i || die
		npm audit fix || die
		yarn import || die
		die
	else
		yarn_src_unpack
	fi
}

src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	if use kernel_linux ; then
		yarn run "package:linux" || die
	elif use kernel_Darwin ; then
		yarn run "package:osx" || die
	elif use kernel_Winnt ; then
		yarn run "package:win" || die
	fi
}

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r "builds/${PN}-$(electron-app_get_electron_platarch)/"*
	fperms 0755 "${YARN_INSTALL_PATH}/${PN}"
	electron-app_gen_wrapper \
		"${PN}" \
		"${YARN_INSTALL_PATH}/${PN}"
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
