# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION="18"
NPM_INSTALL_PATH="/opt/${PN}"
NPM_TARBALL="prantlf-${P}.tar.gz"
NPM_EXE_LIST="
${NPM_INSTALL_PATH}/lib/cli.js

${NPM_INSTALL_PATH}/node_modules/.bin/JSONStream
${NPM_INSTALL_PATH}/node_modules/.bin/c8
${NPM_INSTALL_PATH}/node_modules/.bin/cat.js
${NPM_INSTALL_PATH}/node_modules/.bin/cdl
${NPM_INSTALL_PATH}/node_modules/.bin/conventional-changelog-writer
${NPM_INSTALL_PATH}/node_modules/.bin/conventional-commits-parser
${NPM_INSTALL_PATH}/node_modules/.bin/denolint
${NPM_INSTALL_PATH}/node_modules/.bin/esbuild
${NPM_INSTALL_PATH}/node_modules/.bin/esparse
${NPM_INSTALL_PATH}/node_modules/.bin/esvalidate
${NPM_INSTALL_PATH}/node_modules/.bin/handlebars
${NPM_INSTALL_PATH}/node_modules/.bin/he
${NPM_INSTALL_PATH}/node_modules/.bin/http-server
${NPM_INSTALL_PATH}/node_modules/.bin/js-yaml
${NPM_INSTALL_PATH}/node_modules/.bin/marked
${NPM_INSTALL_PATH}/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/.bin/mv.js
${NPM_INSTALL_PATH}/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/.bin/npm
${NPM_INSTALL_PATH}/node_modules/.bin/npx
${NPM_INSTALL_PATH}/node_modules/.bin/opener
${NPM_INSTALL_PATH}/node_modules/.bin/rc
${NPM_INSTALL_PATH}/node_modules/.bin/resolve
${NPM_INSTALL_PATH}/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/.bin/rollup
${NPM_INSTALL_PATH}/node_modules/.bin/semantic-release
${NPM_INSTALL_PATH}/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/.bin/tehanu
${NPM_INSTALL_PATH}/node_modules/.bin/teru
${NPM_INSTALL_PATH}/node_modules/.bin/teru-cjs
${NPM_INSTALL_PATH}/node_modules/.bin/teru-esm
${NPM_INSTALL_PATH}/node_modules/.bin/tsc
${NPM_INSTALL_PATH}/node_modules/.bin/tsserver
${NPM_INSTALL_PATH}/node_modules/.bin/uglifyjs
${NPM_INSTALL_PATH}/node_modules/@semantic-release/github/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/@semantic-release/npm/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/@semantic-release/release-notes-generator/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/meow/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/normalize-package-data/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/arborist
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/color-support
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/cssesc
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/installed-package-contents
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-gyp
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/nopt
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/pacote
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/qrcode-terminal
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/sigstore
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/node-gyp/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/node-gyp/node_modules/.bin/nopt
${NPM_INSTALL_PATH}/node_modules/read-pkg/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/semantic-release/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/semver-diff/node_modules/.bin/semver
"
NPM_TEST_SCRIPT="test"
inherit npm

DESCRIPTION="JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript."
HOMEPAGE="
http://prantlf.github.io/jsonlint/
https://github.com/prantlf/jsonlint
"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test r1"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}
"
# grep "resolved" ${NPM_INSTALL_PATH}/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.17.18.tgz -> npmpkg-@esbuild-android-arm-0.17.18.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.17.18.tgz -> npmpkg-@esbuild-android-arm64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.17.18.tgz -> npmpkg-@esbuild-android-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.17.18.tgz -> npmpkg-@esbuild-darwin-arm64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.17.18.tgz -> npmpkg-@esbuild-darwin-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.17.18.tgz -> npmpkg-@esbuild-freebsd-arm64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.17.18.tgz -> npmpkg-@esbuild-freebsd-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.17.18.tgz -> npmpkg-@esbuild-linux-arm-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.17.18.tgz -> npmpkg-@esbuild-linux-arm64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.17.18.tgz -> npmpkg-@esbuild-linux-ia32-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.17.18.tgz -> npmpkg-@esbuild-linux-loong64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.17.18.tgz -> npmpkg-@esbuild-linux-mips64el-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.17.18.tgz -> npmpkg-@esbuild-linux-ppc64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.17.18.tgz -> npmpkg-@esbuild-linux-riscv64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.17.18.tgz -> npmpkg-@esbuild-linux-s390x-0.17.18.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.17.18.tgz -> npmpkg-@esbuild-linux-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.17.18.tgz -> npmpkg-@esbuild-netbsd-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.17.18.tgz -> npmpkg-@esbuild-openbsd-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.17.18.tgz -> npmpkg-@esbuild-sunos-x64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.17.18.tgz -> npmpkg-@esbuild-win32-arm64-0.17.18.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.17.18.tgz -> npmpkg-@esbuild-win32-ia32-0.17.18.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.17.18.tgz -> npmpkg-@esbuild-win32-x64-0.17.18.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-24.1.0.tgz -> npmpkg-@rollup-plugin-commonjs-24.1.0.tgz
https://registry.npmjs.org/@rollup/plugin-json/-/plugin-json-6.0.0.tgz -> npmpkg-@rollup-plugin-json-6.0.0.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.0.2.tgz -> npmpkg-@rollup-plugin-node-resolve-15.0.2.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/@semantic-release/changelog/-/changelog-6.0.3.tgz -> npmpkg-@semantic-release-changelog-6.0.3.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-4.0.0.tgz -> npmpkg-@semantic-release-error-4.0.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-5.0.0.tgz -> npmpkg-aggregate-error-5.0.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-5.2.0.tgz -> npmpkg-clean-stack-5.2.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/mime/-/mime-3.0.0.tgz -> npmpkg-mime-3.0.0.tgz
https://registry.npmjs.org/url-join/-/url-join-5.0.0.tgz -> npmpkg-url-join-5.0.0.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-4.0.0.tgz -> npmpkg-@semantic-release-error-4.0.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-5.0.0.tgz -> npmpkg-aggregate-error-5.0.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-5.2.0.tgz -> npmpkg-clean-stack-5.2.0.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-7.0.1.tgz -> npmpkg-get-stream-7.0.1.tgz
https://registry.npmjs.org/@swc/core-darwin-arm64/-/core-darwin-arm64-1.3.95.tgz -> npmpkg-@swc-core-darwin-arm64-1.3.95.tgz
https://registry.npmjs.org/@swc/core-darwin-x64/-/core-darwin-x64-1.3.95.tgz -> npmpkg-@swc-core-darwin-x64-1.3.95.tgz
https://registry.npmjs.org/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.3.95.tgz -> npmpkg-@swc-core-linux-arm-gnueabihf-1.3.95.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.3.95.tgz -> npmpkg-@swc-core-linux-arm64-gnu-1.3.95.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.3.95.tgz -> npmpkg-@swc-core-linux-arm64-musl-1.3.95.tgz
https://registry.npmjs.org/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.3.95.tgz -> npmpkg-@swc-core-win32-arm64-msvc-1.3.95.tgz
https://registry.npmjs.org/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.3.95.tgz -> npmpkg-@swc-core-win32-ia32-msvc-1.3.95.tgz
https://registry.npmjs.org/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.3.95.tgz -> npmpkg-@swc-core-win32-x64-msvc-1.3.95.tgz
https://registry.npmjs.org/@types/node/-/node-18.16.1.tgz -> npmpkg-@types-node-18.16.1.tgz
https://registry.npmjs.org/@unixcompat/cat.js/-/cat.js-2.0.0.tgz -> npmpkg-@unixcompat-cat.js-2.0.0.tgz
https://registry.npmjs.org/@unixcompat/mv.js/-/mv.js-2.0.0.tgz -> npmpkg-@unixcompat-mv.js-2.0.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.1.3.tgz -> npmpkg-cosmiconfig-8.1.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-arm64/-/denolint-darwin-arm64-2.0.9.tgz -> npmpkg-@denolint-denolint-darwin-arm64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-x64/-/denolint-darwin-x64-2.0.9.tgz -> npmpkg-@denolint-denolint-darwin-x64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-freebsd-x64/-/denolint-freebsd-x64-2.0.9.tgz -> npmpkg-@denolint-denolint-freebsd-x64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm-gnueabihf/-/denolint-linux-arm-gnueabihf-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-arm-gnueabihf-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm64-gnu/-/denolint-linux-arm64-gnu-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-arm64-gnu-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-x64-musl/-/denolint-linux-x64-musl-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-x64-musl-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-arm64-msvc/-/denolint-win32-arm64-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-arm64-msvc-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-ia32-msvc/-/denolint-win32-ia32-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-ia32-msvc-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-x64-msvc/-/denolint-win32-x64-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-x64-msvc-2.0.9.tgz
https://registry.npmjs.org/diff/-/diff-5.1.0.tgz -> npmpkg-diff-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.17.18.tgz -> npmpkg-esbuild-0.17.18.tgz
https://registry.npmjs.org/split2/-/split2-1.0.0.tgz -> npmpkg-split2-1.0.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-4.0.1.tgz -> npmpkg-aggregate-error-4.0.1.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-4.2.0.tgz -> npmpkg-clean-stack-4.2.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/find-up/-/find-up-6.3.0.tgz -> npmpkg-find-up-6.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-7.2.0.tgz -> npmpkg-locate-path-7.2.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-4.0.0.tgz -> npmpkg-p-limit-4.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-6.0.0.tgz -> npmpkg-p-locate-6.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.6.0.tgz -> npmpkg-type-fest-4.6.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.0.0.tgz -> npmpkg-yocto-queue-1.0.0.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.0.tgz -> npmpkg-json-parse-even-better-errors-3.0.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-2.0.3.tgz -> npmpkg-lines-and-columns-2.0.3.tgz
https://registry.npmjs.org/parse-json/-/parse-json-7.1.1.tgz -> npmpkg-parse-json-7.1.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-3.13.1.tgz -> npmpkg-type-fest-3.13.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.6.0.tgz -> npmpkg-type-fest-4.6.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/semantic-release/-/semantic-release-22.0.5.tgz -> npmpkg-semantic-release-22.0.5.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-4.0.0.tgz -> npmpkg-@semantic-release-error-4.0.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-5.0.0.tgz -> npmpkg-aggregate-error-5.0.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-5.2.0.tgz -> npmpkg-clean-stack-5.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/p-reduce/-/p-reduce-3.0.0.tgz -> npmpkg-p-reduce-3.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tehanu-teru/-/tehanu-teru-1.0.0.tgz -> npmpkg-tehanu-teru-1.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/typescript/-/typescript-5.0.4.tgz -> npmpkg-typescript-5.0.4.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/prantlf/jsonlint/archive/refs/tags/v${PV}.tar.gz
	-> prantlf-${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test" # Missing dev dependencies
