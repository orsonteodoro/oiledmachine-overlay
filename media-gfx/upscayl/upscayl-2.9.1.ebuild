# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${PN}-${PV}-linux.AppImage"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_ELECTRON_PV="27.0.2"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_REACT_PV="18.2.0"
NODE_ENV="development"
NODE_VERSION="16"

inherit desktop electron-app git-r3 lcnr npm
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/upscayl-2.0.1/work/upscayl-2.0.1/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@alloc/quick-lru/-/quick-lru-5.2.0.tgz -> npmpkg-@alloc-quick-lru-5.2.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.13.tgz -> npmpkg-@babel-code-frame-7.22.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> npmpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz -> npmpkg-@babel-helper-string-parser-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.20.tgz -> npmpkg-@babel-highlight-7.22.20.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.23.2.tgz -> npmpkg-@babel-runtime-7.23.2.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.7.tgz -> npmpkg-@electron-asar-3.2.7.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.1.0.tgz -> npmpkg-@electron-notarize-2.1.0.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.0.5.tgz -> npmpkg-@electron-osx-sign-1.0.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.4.1.tgz -> npmpkg-@electron-universal-1.4.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@emotion/babel-plugin/-/babel-plugin-11.11.0.tgz -> npmpkg-@emotion-babel-plugin-11.11.0.tgz
https://registry.npmjs.org/@emotion/cache/-/cache-11.11.0.tgz -> npmpkg-@emotion-cache-11.11.0.tgz
https://registry.npmjs.org/@emotion/hash/-/hash-0.9.1.tgz -> npmpkg-@emotion-hash-0.9.1.tgz
https://registry.npmjs.org/@emotion/memoize/-/memoize-0.8.1.tgz -> npmpkg-@emotion-memoize-0.8.1.tgz
https://registry.npmjs.org/@emotion/react/-/react-11.11.1.tgz -> npmpkg-@emotion-react-11.11.1.tgz
https://registry.npmjs.org/@emotion/serialize/-/serialize-1.1.2.tgz -> npmpkg-@emotion-serialize-1.1.2.tgz
https://registry.npmjs.org/@emotion/sheet/-/sheet-1.2.2.tgz -> npmpkg-@emotion-sheet-1.2.2.tgz
https://registry.npmjs.org/@emotion/unitless/-/unitless-0.8.1.tgz -> npmpkg-@emotion-unitless-0.8.1.tgz
https://registry.npmjs.org/@emotion/use-insertion-effect-with-fallbacks/-/use-insertion-effect-with-fallbacks-1.0.1.tgz -> npmpkg-@emotion-use-insertion-effect-with-fallbacks-1.0.1.tgz
https://registry.npmjs.org/@emotion/utils/-/utils-1.2.1.tgz -> npmpkg-@emotion-utils-1.2.1.tgz
https://registry.npmjs.org/@emotion/weak-memoize/-/weak-memoize-0.3.1.tgz -> npmpkg-@emotion-weak-memoize-0.3.1.tgz
https://registry.npmjs.org/@firebase/analytics/-/analytics-0.10.0.tgz -> npmpkg-@firebase-analytics-0.10.0.tgz
https://registry.npmjs.org/@firebase/analytics-compat/-/analytics-compat-0.2.6.tgz -> npmpkg-@firebase-analytics-compat-0.2.6.tgz
https://registry.npmjs.org/@firebase/analytics-types/-/analytics-types-0.8.0.tgz -> npmpkg-@firebase-analytics-types-0.8.0.tgz
https://registry.npmjs.org/@firebase/app/-/app-0.9.22.tgz -> npmpkg-@firebase-app-0.9.22.tgz
https://registry.npmjs.org/@firebase/app-check/-/app-check-0.8.0.tgz -> npmpkg-@firebase-app-check-0.8.0.tgz
https://registry.npmjs.org/@firebase/app-check-compat/-/app-check-compat-0.3.7.tgz -> npmpkg-@firebase-app-check-compat-0.3.7.tgz
https://registry.npmjs.org/@firebase/app-check-interop-types/-/app-check-interop-types-0.3.0.tgz -> npmpkg-@firebase-app-check-interop-types-0.3.0.tgz
https://registry.npmjs.org/@firebase/app-check-types/-/app-check-types-0.5.0.tgz -> npmpkg-@firebase-app-check-types-0.5.0.tgz
https://registry.npmjs.org/@firebase/app-compat/-/app-compat-0.2.22.tgz -> npmpkg-@firebase-app-compat-0.2.22.tgz
https://registry.npmjs.org/@firebase/app-types/-/app-types-0.9.0.tgz -> npmpkg-@firebase-app-types-0.9.0.tgz
https://registry.npmjs.org/@firebase/auth/-/auth-1.3.2.tgz -> npmpkg-@firebase-auth-1.3.2.tgz
https://registry.npmjs.org/@firebase/auth-compat/-/auth-compat-0.4.8.tgz -> npmpkg-@firebase-auth-compat-0.4.8.tgz
https://registry.npmjs.org/@firebase/auth-interop-types/-/auth-interop-types-0.2.1.tgz -> npmpkg-@firebase-auth-interop-types-0.2.1.tgz
https://registry.npmjs.org/@firebase/auth-types/-/auth-types-0.12.0.tgz -> npmpkg-@firebase-auth-types-0.12.0.tgz
https://registry.npmjs.org/@firebase/component/-/component-0.6.4.tgz -> npmpkg-@firebase-component-0.6.4.tgz
https://registry.npmjs.org/@firebase/database/-/database-1.0.1.tgz -> npmpkg-@firebase-database-1.0.1.tgz
https://registry.npmjs.org/@firebase/database-compat/-/database-compat-1.0.1.tgz -> npmpkg-@firebase-database-compat-1.0.1.tgz
https://registry.npmjs.org/@firebase/database-types/-/database-types-1.0.0.tgz -> npmpkg-@firebase-database-types-1.0.0.tgz
https://registry.npmjs.org/@firebase/firestore/-/firestore-4.3.2.tgz -> npmpkg-@firebase-firestore-4.3.2.tgz
https://registry.npmjs.org/@firebase/firestore-compat/-/firestore-compat-0.3.21.tgz -> npmpkg-@firebase-firestore-compat-0.3.21.tgz
https://registry.npmjs.org/@firebase/firestore-types/-/firestore-types-3.0.0.tgz -> npmpkg-@firebase-firestore-types-3.0.0.tgz
https://registry.npmjs.org/@firebase/functions/-/functions-0.10.0.tgz -> npmpkg-@firebase-functions-0.10.0.tgz
https://registry.npmjs.org/@firebase/functions-compat/-/functions-compat-0.3.5.tgz -> npmpkg-@firebase-functions-compat-0.3.5.tgz
https://registry.npmjs.org/@firebase/functions-types/-/functions-types-0.6.0.tgz -> npmpkg-@firebase-functions-types-0.6.0.tgz
https://registry.npmjs.org/@firebase/installations/-/installations-0.6.4.tgz -> npmpkg-@firebase-installations-0.6.4.tgz
https://registry.npmjs.org/@firebase/installations-compat/-/installations-compat-0.2.4.tgz -> npmpkg-@firebase-installations-compat-0.2.4.tgz
https://registry.npmjs.org/@firebase/installations-types/-/installations-types-0.5.0.tgz -> npmpkg-@firebase-installations-types-0.5.0.tgz
https://registry.npmjs.org/idb/-/idb-7.0.1.tgz -> npmpkg-idb-7.0.1.tgz
https://registry.npmjs.org/@firebase/logger/-/logger-0.4.0.tgz -> npmpkg-@firebase-logger-0.4.0.tgz
https://registry.npmjs.org/@firebase/messaging/-/messaging-0.12.4.tgz -> npmpkg-@firebase-messaging-0.12.4.tgz
https://registry.npmjs.org/@firebase/messaging-compat/-/messaging-compat-0.2.4.tgz -> npmpkg-@firebase-messaging-compat-0.2.4.tgz
https://registry.npmjs.org/@firebase/messaging-interop-types/-/messaging-interop-types-0.2.0.tgz -> npmpkg-@firebase-messaging-interop-types-0.2.0.tgz
https://registry.npmjs.org/idb/-/idb-7.0.1.tgz -> npmpkg-idb-7.0.1.tgz
https://registry.npmjs.org/@firebase/performance/-/performance-0.6.4.tgz -> npmpkg-@firebase-performance-0.6.4.tgz
https://registry.npmjs.org/@firebase/performance-compat/-/performance-compat-0.2.4.tgz -> npmpkg-@firebase-performance-compat-0.2.4.tgz
https://registry.npmjs.org/@firebase/performance-types/-/performance-types-0.2.0.tgz -> npmpkg-@firebase-performance-types-0.2.0.tgz
https://registry.npmjs.org/@firebase/remote-config/-/remote-config-0.4.4.tgz -> npmpkg-@firebase-remote-config-0.4.4.tgz
https://registry.npmjs.org/@firebase/remote-config-compat/-/remote-config-compat-0.2.4.tgz -> npmpkg-@firebase-remote-config-compat-0.2.4.tgz
https://registry.npmjs.org/@firebase/remote-config-types/-/remote-config-types-0.3.0.tgz -> npmpkg-@firebase-remote-config-types-0.3.0.tgz
https://registry.npmjs.org/@firebase/storage/-/storage-0.11.2.tgz -> npmpkg-@firebase-storage-0.11.2.tgz
https://registry.npmjs.org/@firebase/storage-compat/-/storage-compat-0.3.2.tgz -> npmpkg-@firebase-storage-compat-0.3.2.tgz
https://registry.npmjs.org/@firebase/storage-types/-/storage-types-0.8.0.tgz -> npmpkg-@firebase-storage-types-0.8.0.tgz
https://registry.npmjs.org/@firebase/util/-/util-1.9.3.tgz -> npmpkg-@firebase-util-1.9.3.tgz
https://registry.npmjs.org/@firebase/webchannel-wrapper/-/webchannel-wrapper-0.10.3.tgz -> npmpkg-@firebase-webchannel-wrapper-0.10.3.tgz
https://registry.npmjs.org/@floating-ui/core/-/core-1.5.0.tgz -> npmpkg-@floating-ui-core-1.5.0.tgz
https://registry.npmjs.org/@floating-ui/dom/-/dom-1.5.3.tgz -> npmpkg-@floating-ui-dom-1.5.3.tgz
https://registry.npmjs.org/@floating-ui/utils/-/utils-0.1.6.tgz -> npmpkg-@floating-ui-utils-0.1.6.tgz
https://registry.npmjs.org/@grpc/grpc-js/-/grpc-js-1.9.8.tgz -> npmpkg-@grpc-grpc-js-1.9.8.tgz
https://registry.npmjs.org/@grpc/proto-loader/-/proto-loader-0.7.10.tgz -> npmpkg-@grpc-proto-loader-0.7.10.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/@next/env/-/env-13.5.6.tgz -> npmpkg-@next-env-13.5.6.tgz
https://registry.npmjs.org/@next/swc-darwin-arm64/-/swc-darwin-arm64-13.5.6.tgz -> npmpkg-@next-swc-darwin-arm64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-darwin-x64/-/swc-darwin-x64-13.5.6.tgz -> npmpkg-@next-swc-darwin-x64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-gnu/-/swc-linux-arm64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-musl/-/swc-linux-arm64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-gnu/-/swc-linux-x64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-x64-musl/-/swc-linux-x64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-x64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-arm64-msvc/-/swc-win32-arm64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-arm64-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-ia32-msvc/-/swc-win32-ia32-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-ia32-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-x64-msvc/-/swc-win32-x64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-x64-msvc-13.5.6.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@protobufjs/aspromise/-/aspromise-1.1.2.tgz -> npmpkg-@protobufjs-aspromise-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/base64/-/base64-1.1.2.tgz -> npmpkg-@protobufjs-base64-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/codegen/-/codegen-2.0.4.tgz -> npmpkg-@protobufjs-codegen-2.0.4.tgz
https://registry.npmjs.org/@protobufjs/eventemitter/-/eventemitter-1.1.0.tgz -> npmpkg-@protobufjs-eventemitter-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/fetch/-/fetch-1.1.0.tgz -> npmpkg-@protobufjs-fetch-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/float/-/float-1.0.2.tgz -> npmpkg-@protobufjs-float-1.0.2.tgz
https://registry.npmjs.org/@protobufjs/inquire/-/inquire-1.1.0.tgz -> npmpkg-@protobufjs-inquire-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/path/-/path-1.1.2.tgz -> npmpkg-@protobufjs-path-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/pool/-/pool-1.1.0.tgz -> npmpkg-@protobufjs-pool-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/utf8/-/utf8-1.1.0.tgz -> npmpkg-@protobufjs-utf8-1.1.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@swc/helpers/-/helpers-0.5.2.tgz -> npmpkg-@swc-helpers-0.5.2.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.10.tgz -> npmpkg-@types-debug-4.1.10.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.3.tgz -> npmpkg-@types-http-cache-semantics-4.0.3.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.33.tgz -> npmpkg-@types-ms-0.7.33.tgz
https://registry.npmjs.org/@types/node/-/node-18.18.7.tgz -> npmpkg-@types-node-18.18.7.tgz
https://registry.npmjs.org/@types/parse-json/-/parse-json-4.0.1.tgz -> npmpkg-@types-parse-json-4.0.1.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.4.tgz -> npmpkg-@types-plist-3.0.4.tgz
https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.9.tgz -> npmpkg-@types-prop-types-15.7.9.tgz
https://registry.npmjs.org/@types/react/-/react-18.2.33.tgz -> npmpkg-@types-react-18.2.33.tgz
https://registry.npmjs.org/@types/react-dom/-/react-dom-18.2.14.tgz -> npmpkg-@types-react-dom-18.2.14.tgz
https://registry.npmjs.org/@types/react-transition-group/-/react-transition-group-4.4.8.tgz -> npmpkg-@types-react-transition-group-4.4.8.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.2.tgz -> npmpkg-@types-responselike-1.0.2.tgz
https://registry.npmjs.org/@types/scheduler/-/scheduler-0.16.5.tgz -> npmpkg-@types-scheduler-0.16.5.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.8.tgz -> npmpkg-@types-verror-1.10.8.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.2.tgz -> npmpkg-@types-yauzl-2.10.2.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-24.6.4.tgz -> npmpkg-app-builder-lib-24.6.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/app-root-path/-/app-root-path-3.1.0.tgz -> npmpkg-app-root-path-3.1.0.tgz
https://registry.npmjs.org/arg/-/arg-5.0.2.tgz -> npmpkg-arg-5.0.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz -> npmpkg-async-3.2.4.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.16.tgz -> npmpkg-autoprefixer-10.4.16.tgz
https://registry.npmjs.org/b4a/-/b4a-1.6.4.tgz -> npmpkg-b4a-1.6.4.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-3.1.0.tgz -> npmpkg-babel-plugin-macros-3.1.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.1.tgz -> npmpkg-browserslist-4.22.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.1.tgz -> npmpkg-buffer-equal-1.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.5.0.tgz -> npmpkg-builder-util-24.5.0.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.1.tgz -> npmpkg-builder-util-runtime-9.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/busboy/-/busboy-1.6.0.tgz -> npmpkg-busboy-1.6.0.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz -> npmpkg-camelcase-css-2.0.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001555.tgz -> npmpkg-caniuse-lite-1.0.30001555.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/classnames/-/classnames-2.3.2.tgz -> npmpkg-classnames-2.3.2.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/client-only/-/client-only-0.0.1.tgz -> npmpkg-client-only-0.0.1.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/color/-/color-4.2.3.tgz -> npmpkg-color-4.2.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-string/-/color-string-1.9.1.tgz -> npmpkg-color-string-1.9.1.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-file-ts/-/config-file-ts-0.2.4.tgz -> npmpkg-config-file-ts-0.2.4.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/cross-env/-/cross-env-7.0.3.tgz -> npmpkg-cross-env-7.0.3.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/css-selector-tokenizer/-/css-selector-tokenizer-0.8.0.tgz -> npmpkg-css-selector-tokenizer-0.8.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/daisyui/-/daisyui-3.9.4.tgz -> npmpkg-daisyui-3.9.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.1.tgz -> npmpkg-define-data-property-1.1.1.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.2.tgz -> npmpkg-detect-libc-2.0.2.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz -> npmpkg-didyoumean-1.2.2.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-3.3.0.tgz -> npmpkg-dir-compare-3.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz -> npmpkg-dlv-1.1.3.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.6.4.tgz -> npmpkg-dmg-builder-24.6.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dom-helpers/-/dom-helpers-5.2.1.tgz -> npmpkg-dom-helpers-5.2.1.tgz
https://registry.npmjs.org/dotenv/-/dotenv-16.3.1.tgz -> npmpkg-dotenv-16.3.1.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.9.tgz -> npmpkg-ejs-3.1.9.tgz
https://registry.npmjs.org/electron/-/electron-27.0.2.tgz -> npmpkg-electron-27.0.2.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-24.6.4.tgz -> npmpkg-electron-builder-24.6.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-log/-/electron-log-5.0.0.tgz -> npmpkg-electron-log-5.0.0.tgz
https://registry.npmjs.org/electron-next/-/electron-next-3.1.5.tgz -> npmpkg-electron-next-3.1.5.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-24.5.0.tgz -> npmpkg-electron-publish-24.5.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.569.tgz -> npmpkg-electron-to-chromium-1.4.569.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-6.1.4.tgz -> npmpkg-electron-updater-6.1.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-fifo/-/fast-fifo-1.3.2.tgz -> npmpkg-fast-fifo-1.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fastparse/-/fastparse-1.1.2.tgz -> npmpkg-fastparse-1.1.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.4.tgz -> npmpkg-faye-websocket-0.11.4.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-root/-/find-root-1.1.0.tgz -> npmpkg-find-root-1.1.0.tgz
https://registry.npmjs.org/firebase/-/firebase-10.5.2.tgz -> npmpkg-firebase-10.5.2.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.3.7.tgz -> npmpkg-fraction.js-4.3.7.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.2.tgz -> npmpkg-get-intrinsic-1.2.2.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.1.tgz -> npmpkg-has-property-descriptors-1.0.1.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/hoist-non-react-statics/-/hoist-non-react-statics-3.3.2.tgz -> npmpkg-hoist-non-react-statics-3.3.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.5.8.tgz -> npmpkg-http-parser-js-0.5.8.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.0.tgz -> npmpkg-isbinaryfile-5.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jake/-/jake-10.8.7.tgz -> npmpkg-jake-10.8.7.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/jiti/-/jiti-1.20.0.tgz -> npmpkg-jiti-1.20.0.tgz
https://registry.npmjs.org/jotai/-/jotai-2.5.0.tgz -> npmpkg-jotai-2.5.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-2.1.0.tgz -> npmpkg-lilconfig-2.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz -> npmpkg-lodash.camelcase-4.3.0.tgz
https://registry.npmjs.org/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> npmpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/long/-/long-5.2.3.tgz -> npmpkg-long-5.2.3.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/memoize-one/-/memoize-one-6.0.0.tgz -> npmpkg-memoize-one-6.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.6.tgz -> npmpkg-nanoid-3.3.6.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/next/-/next-13.5.6.tgz -> npmpkg-next-13.5.6.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.51.0.tgz -> npmpkg-node-abi-3.51.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz -> npmpkg-node-fetch-2.6.7.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.13.tgz -> npmpkg-node-releases-2.0.13.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz -> npmpkg-object-hash-3.0.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.6.tgz -> npmpkg-pirates-4.0.6.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/postcss-import/-/postcss-import-15.1.0.tgz -> npmpkg-postcss-import-15.1.0.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-4.0.1.tgz -> npmpkg-postcss-load-config-4.0.1.tgz
https://registry.npmjs.org/yaml/-/yaml-2.3.3.tgz -> npmpkg-yaml-2.3.3.tgz
https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.0.1.tgz -> npmpkg-postcss-nested-6.0.1.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.13.tgz -> npmpkg-postcss-selector-parser-6.0.13.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.1.tgz -> npmpkg-prebuild-install-7.1.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/prettier/-/prettier-3.0.3.tgz -> npmpkg-prettier-3.0.3.tgz
https://registry.npmjs.org/prettier-plugin-tailwindcss/-/prettier-plugin-tailwindcss-0.4.1.tgz -> npmpkg-prettier-plugin-tailwindcss-0.4.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-7.2.5.tgz -> npmpkg-protobufjs-7.2.5.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/queue-tick/-/queue-tick-1.0.1.tgz -> npmpkg-queue-tick-1.0.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/react/-/react-18.2.0.tgz -> npmpkg-react-18.2.0.tgz
https://registry.npmjs.org/react-compare-slider/-/react-compare-slider-2.2.0.tgz -> npmpkg-react-compare-slider-2.2.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-18.2.0.tgz -> npmpkg-react-dom-18.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/react-select/-/react-select-5.7.7.tgz -> npmpkg-react-select-5.7.7.tgz
https://registry.npmjs.org/react-tooltip/-/react-tooltip-5.21.6.tgz -> npmpkg-react-tooltip-5.21.6.tgz
https://registry.npmjs.org/react-transition-group/-/react-transition-group-4.4.5.tgz -> npmpkg-react-transition-group-4.4.5.tgz
https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz -> npmpkg-read-cache-1.0.0.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.3.2.tgz -> npmpkg-read-config-file-6.3.2.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.3.0.tgz -> npmpkg-sax-1.3.0.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.23.0.tgz -> npmpkg-scheduler-0.23.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/sharp/-/sharp-0.32.6.tgz -> npmpkg-sharp-0.32.6.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-6.1.0.tgz -> npmpkg-node-addon-api-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz -> npmpkg-simple-get-4.0.1.tgz
https://registry.npmjs.org/simple-swizzle/-/simple-swizzle-0.2.2.tgz -> npmpkg-simple-swizzle-0.2.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.0.2.tgz -> npmpkg-source-map-js-1.0.2.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/streamsearch/-/streamsearch-1.1.0.tgz -> npmpkg-streamsearch-1.1.0.tgz
https://registry.npmjs.org/streamx/-/streamx-2.15.1.tgz -> npmpkg-streamx-2.15.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/styled-jsx/-/styled-jsx-5.1.1.tgz -> npmpkg-styled-jsx-5.1.1.tgz
https://registry.npmjs.org/stylis/-/stylis-4.2.0.tgz -> npmpkg-stylis-4.2.0.tgz
https://registry.npmjs.org/sucrase/-/sucrase-3.34.0.tgz -> npmpkg-sucrase-3.34.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tailwind-scrollbar/-/tailwind-scrollbar-3.0.5.tgz -> npmpkg-tailwind-scrollbar-3.0.5.tgz
https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.3.5.tgz -> npmpkg-tailwindcss-3.3.5.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-3.0.4.tgz -> npmpkg-tar-fs-3.0.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-3.1.6.tgz -> npmpkg-tar-stream-3.1.6.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/theme-change/-/theme-change-2.5.0.tgz -> npmpkg-theme-change-2.5.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/tiny-typed-emitter/-/tiny-typed-emitter-2.1.0.tgz -> npmpkg-tiny-typed-emitter-2.1.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz -> npmpkg-ts-interface-checker-0.1.13.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/use-isomorphic-layout-effect/-/use-isomorphic-layout-effect-1.1.2.tgz -> npmpkg-use-isomorphic-layout-effect-1.1.2.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.0.tgz -> npmpkg-watchpack-2.4.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.4.tgz -> npmpkg-websocket-driver-0.7.4.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> npmpkg-websocket-extensions-0.1.4.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
#$(electron-app_gen_electron_uris)
	SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/upscayl/upscayl/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Upscayl - Free and Open Source AI Image Upscaler for Linux, MacOS and Windows built with Linux-First philosophy."
HOMEPAGE="https://upscayl.github.io/"
# Upstream uses U 18.04.6 for CI
THIRD_PARTY_LICENSES="
	( Apache-2.0 all-rights-reserved )
	( custom MIT Unicode-DFS-2016 CC-BY-4.0 W3C-Software-and-Document-Notice-and-License-2015 W3C-Community-Final-Specification-Agreement )
	( MIT all-rights-reserved )
	( MIT CC0-1.0 )
	( MIT ISC BSD-2 BSD Apache-2.0 0BSD ( MIT all-rights-reserved ) )
	( WTFPL-2 ISC )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-4.0
	CC-BY-SA-4.0
	ISC
	GPL-3
	MIT
	PSF-2.4
	|| ( MIT GPL-2 )
	|| ( MIT CC0-1.0 )
"
LICENSE="
	AGPL-3
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
"

KEYWORDS="~amd64"
SLOT="0"
IUSE+=" r2"
RDEPEND+="
	media-libs/vulkan-loader
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
	npm_pkg_setup
}

npm_update_lock_install_post() {
	enpm uninstall "@types/electron"
}

src_compile() {
	export NEXT_TELEMETRY_DISABLED=1
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	npm_hydrate
	electron-app_cp_electron
	enpm run build
	electron-builder build --linux dir
	cd "${S}" || die
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|\${INSTALL_DIR}|${NPM_INSTALL_PATH}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${PN}|${PN}|g" \
		"${ED}/usr/bin/${PN}" || die
        newicon "build/icon.png" "${PN}.png"
        make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		 "Graphics"
	# Generated from:
	# find "${S}/dist" -executable -type f | cut -f 11- -d "/" | sort
	local L=(
chrome-sandbox
chrome_crashpad_handler
libEGL.so
libGLESv2.so
libffmpeg.so
libvk_swiftshader.so
libvulkan.so.1
resources/bin/upscayl-realesrgan
upscayl
	)
	for f in ${L[@]} ; do
		fperms 0755 "${NPM_INSTALL_PATH}/${f}"
	done
	lcnr_install_files
}

pkg_postinst() {
ewarn
ewarn "You need vulkan drivers to use ${PN}."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.5.5 (20230608)
# USE="X unpacked wayland -r2"
# X:  passed
# wayland:  passed
# digital art:  passed
# real-esrgan:  passed
# fast real-esrgan:  passed
# ultramix balanced:  passed
# color theme (randomly chosen):  passed
