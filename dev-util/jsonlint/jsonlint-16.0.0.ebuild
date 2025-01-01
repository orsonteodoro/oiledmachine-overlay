# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION="18"
NPM_INSTALL_PATH="/opt/${PN}"
NPM_TARBALL="prantlf-${P}.tar.gz"
# Partially generated from:  find ${NPM_INSTALL_PATH} -path "*/.bin/*" -o -path "*/.bin"
NPM_EXE_LIST="
${NPM_INSTALL_PATH}/lib/cli.js

${NPM_INSTALL_PATH}/node_modules/@semantic-release/github/node_modules/.bin
${NPM_INSTALL_PATH}/node_modules/@semantic-release/github/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/cross-spawn/node_modules/.bin
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/cross-spawn/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/pacote
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/arborist
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/glob
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/installed-package-contents
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/cssesc
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-gyp
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/nopt
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/qrcode-terminal
${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/.bin
${NPM_INSTALL_PATH}/node_modules/.bin/teru
${NPM_INSTALL_PATH}/node_modules/.bin/http-server
${NPM_INSTALL_PATH}/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/.bin/npx
${NPM_INSTALL_PATH}/node_modules/.bin/tsc
${NPM_INSTALL_PATH}/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/.bin/semantic-release
${NPM_INSTALL_PATH}/node_modules/.bin/marked
${NPM_INSTALL_PATH}/node_modules/.bin/denolint
${NPM_INSTALL_PATH}/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/.bin/mv-j
${NPM_INSTALL_PATH}/node_modules/.bin/conventional-commits-parser
${NPM_INSTALL_PATH}/node_modules/.bin/rc
${NPM_INSTALL_PATH}/node_modules/.bin/highlight
${NPM_INSTALL_PATH}/node_modules/.bin/he
${NPM_INSTALL_PATH}/node_modules/.bin/tsserver
${NPM_INSTALL_PATH}/node_modules/.bin/rollup
${NPM_INSTALL_PATH}/node_modules/.bin/resolve
${NPM_INSTALL_PATH}/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/.bin/npm
${NPM_INSTALL_PATH}/node_modules/.bin/js-yaml
${NPM_INSTALL_PATH}/node_modules/.bin/handlebars
${NPM_INSTALL_PATH}/node_modules/.bin/teru-cjs
${NPM_INSTALL_PATH}/node_modules/.bin/uglifyjs
${NPM_INSTALL_PATH}/node_modules/.bin/opener
${NPM_INSTALL_PATH}/node_modules/.bin/conventional-changelog-writer
${NPM_INSTALL_PATH}/node_modules/.bin/c8
${NPM_INSTALL_PATH}/node_modules/.bin/cat-j
${NPM_INSTALL_PATH}/node_modules/.bin/tehanu
${NPM_INSTALL_PATH}/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/.bin/teru-esm
${NPM_INSTALL_PATH}/node_modules/.bin/esbuild
"
NPM_TEST_SCRIPT="test"
inherit npm

DESCRIPTION="JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript."
HOMEPAGE="
http://prantlf.github.io/jsonlint/
https://github.com/prantlf/jsonlint
"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test ebuild_revision_2"
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
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.25.7.tgz -> npmpkg-@babel-code-frame-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.25.7.tgz -> npmpkg-@babel-highlight-7.25.7.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@biomejs/biome/-/biome-1.9.3.tgz -> npmpkg-@biomejs-biome-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-darwin-arm64/-/cli-darwin-arm64-1.9.3.tgz -> npmpkg-@biomejs-cli-darwin-arm64-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-darwin-x64/-/cli-darwin-x64-1.9.3.tgz -> npmpkg-@biomejs-cli-darwin-x64-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-linux-arm64/-/cli-linux-arm64-1.9.3.tgz -> npmpkg-@biomejs-cli-linux-arm64-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-linux-arm64-musl/-/cli-linux-arm64-musl-1.9.3.tgz -> npmpkg-@biomejs-cli-linux-arm64-musl-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-linux-x64/-/cli-linux-x64-1.9.3.tgz -> npmpkg-@biomejs-cli-linux-x64-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-linux-x64-musl/-/cli-linux-x64-musl-1.9.3.tgz -> npmpkg-@biomejs-cli-linux-x64-musl-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-win32-arm64/-/cli-win32-arm64-1.9.3.tgz -> npmpkg-@biomejs-cli-win32-arm64-1.9.3.tgz
https://registry.npmjs.org/@biomejs/cli-win32-x64/-/cli-win32-x64-1.9.3.tgz -> npmpkg-@biomejs-cli-win32-x64-1.9.3.tgz
https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.23.0.tgz -> npmpkg-@esbuild-aix-ppc64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.23.0.tgz -> npmpkg-@esbuild-android-arm-0.23.0.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.23.0.tgz -> npmpkg-@esbuild-android-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.23.0.tgz -> npmpkg-@esbuild-android-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.23.0.tgz -> npmpkg-@esbuild-darwin-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.23.0.tgz -> npmpkg-@esbuild-darwin-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.23.0.tgz -> npmpkg-@esbuild-freebsd-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.23.0.tgz -> npmpkg-@esbuild-freebsd-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.23.0.tgz -> npmpkg-@esbuild-linux-arm-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.23.0.tgz -> npmpkg-@esbuild-linux-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.23.0.tgz -> npmpkg-@esbuild-linux-ia32-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.23.0.tgz -> npmpkg-@esbuild-linux-loong64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.23.0.tgz -> npmpkg-@esbuild-linux-mips64el-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.23.0.tgz -> npmpkg-@esbuild-linux-ppc64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.23.0.tgz -> npmpkg-@esbuild-linux-riscv64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.23.0.tgz -> npmpkg-@esbuild-linux-s390x-0.23.0.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.23.0.tgz -> npmpkg-@esbuild-linux-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.23.0.tgz -> npmpkg-@esbuild-netbsd-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/openbsd-arm64/-/openbsd-arm64-0.23.0.tgz -> npmpkg-@esbuild-openbsd-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.23.0.tgz -> npmpkg-@esbuild-openbsd-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.23.0.tgz -> npmpkg-@esbuild-sunos-x64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.23.0.tgz -> npmpkg-@esbuild-win32-arm64-0.23.0.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.23.0.tgz -> npmpkg-@esbuild-win32-ia32-0.23.0.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.23.0.tgz -> npmpkg-@esbuild-win32-x64-0.23.0.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-26.0.1.tgz -> npmpkg-@rollup-plugin-commonjs-26.0.1.tgz
https://registry.npmjs.org/@rollup/plugin-json/-/plugin-json-6.1.0.tgz -> npmpkg-@rollup-plugin-json-6.1.0.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.2.3.tgz -> npmpkg-@rollup-plugin-node-resolve-15.2.3.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-5.1.2.tgz -> npmpkg-@rollup-pluginutils-5.1.2.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.24.0.tgz -> npmpkg-@rollup-rollup-android-arm-eabi-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.24.0.tgz -> npmpkg-@rollup-rollup-android-arm64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.24.0.tgz -> npmpkg-@rollup-rollup-darwin-arm64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.24.0.tgz -> npmpkg-@rollup-rollup-darwin-x64-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm-gnueabihf-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm-musleabihf/-/rollup-linux-arm-musleabihf-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm-musleabihf-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-arm64-musl-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-powerpc64le-gnu/-/rollup-linux-powerpc64le-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-powerpc64le-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-riscv64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-s390x-gnu/-/rollup-linux-s390x-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-s390x-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-x64-gnu-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.24.0.tgz -> npmpkg-@rollup-rollup-linux-x64-musl-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-arm64-msvc-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-ia32-msvc-4.24.0.tgz
https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.24.0.tgz -> npmpkg-@rollup-rollup-win32-x64-msvc-4.24.0.tgz
https://registry.npmjs.org/@swc/core/-/core-1.7.26.tgz -> npmpkg-@swc-core-1.7.26.tgz
https://registry.npmjs.org/@swc/core-darwin-arm64/-/core-darwin-arm64-1.7.26.tgz -> npmpkg-@swc-core-darwin-arm64-1.7.26.tgz
https://registry.npmjs.org/@swc/core-darwin-x64/-/core-darwin-x64-1.7.26.tgz -> npmpkg-@swc-core-darwin-x64-1.7.26.tgz
https://registry.npmjs.org/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.7.26.tgz -> npmpkg-@swc-core-linux-arm-gnueabihf-1.7.26.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.7.26.tgz -> npmpkg-@swc-core-linux-arm64-gnu-1.7.26.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.7.26.tgz -> npmpkg-@swc-core-linux-arm64-musl-1.7.26.tgz
https://registry.npmjs.org/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.7.26.tgz -> npmpkg-@swc-core-linux-x64-gnu-1.7.26.tgz
https://registry.npmjs.org/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.7.26.tgz -> npmpkg-@swc-core-linux-x64-musl-1.7.26.tgz
https://registry.npmjs.org/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.7.26.tgz -> npmpkg-@swc-core-win32-arm64-msvc-1.7.26.tgz
https://registry.npmjs.org/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.7.26.tgz -> npmpkg-@swc-core-win32-ia32-msvc-1.7.26.tgz
https://registry.npmjs.org/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.7.26.tgz -> npmpkg-@swc-core-win32-x64-msvc-1.7.26.tgz
https://registry.npmjs.org/@swc/counter/-/counter-0.1.3.tgz -> npmpkg-@swc-counter-0.1.3.tgz
https://registry.npmjs.org/@swc/types/-/types-0.1.12.tgz -> npmpkg-@swc-types-0.1.12.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.6.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.6.tgz
https://registry.npmjs.org/@types/node/-/node-22.2.0.tgz -> npmpkg-@types-node-22.2.0.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.20.2.tgz -> npmpkg-@types-resolve-1.20.2.tgz
https://registry.npmjs.org/@unixcompat/cat.js/-/cat.js-2.0.0.tgz -> npmpkg-@unixcompat-cat.js-2.0.0.tgz
https://registry.npmjs.org/@unixcompat/mv.js/-/mv.js-2.0.0.tgz -> npmpkg-@unixcompat-mv.js-2.0.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.2.12.tgz -> npmpkg-fast-glob-3.2.12.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ajv-draft-04/-/ajv-draft-04-1.0.0.tgz -> npmpkg-ajv-draft-04-1.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz -> npmpkg-basic-auth-2.0.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/c8/-/c8-10.1.2.tgz -> npmpkg-c8-10.1.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/corser/-/corser-2.0.1.tgz -> npmpkg-corser-2.0.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-9.0.0.tgz -> npmpkg-cosmiconfig-9.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/diff/-/diff-5.2.0.tgz -> npmpkg-diff-5.2.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.23.0.tgz -> npmpkg-esbuild-0.23.0.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.0.2.tgz -> npmpkg-fast-uri-3.0.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz -> npmpkg-http-server-14.1.1.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> npmpkg-is-builtin-module-3.2.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-reference/-/is-reference-1.2.1.tgz -> npmpkg-is-reference-1.2.1.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.7.tgz -> npmpkg-istanbul-reports-3.1.7.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.11.tgz -> npmpkg-magic-string-0.30.11.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/opener/-/opener-1.5.2.tgz -> npmpkg-opener-1.5.2.tgz
https://registry.npmjs.org/os-lock/-/os-lock-2.0.0.tgz -> npmpkg-os-lock-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/portfinder/-/portfinder-1.0.32.tgz -> npmpkg-portfinder-1.0.32.tgz
https://registry.npmjs.org/qs/-/qs-6.13.0.tgz -> npmpkg-qs-6.13.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rollup/-/rollup-4.24.0.tgz -> npmpkg-rollup-4.24.0.tgz
https://registry.npmjs.org/rollup-plugin-swc-minify/-/rollup-plugin-swc-minify-1.1.2.tgz -> npmpkg-rollup-plugin-swc-minify-1.1.2.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/secure-compare/-/secure-compare-3.0.1.tgz -> npmpkg-secure-compare-3.0.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tehanu/-/tehanu-1.0.1.tgz -> npmpkg-tehanu-1.0.1.tgz
https://registry.npmjs.org/tehanu-repo-coco/-/tehanu-repo-coco-1.0.1.tgz -> npmpkg-tehanu-repo-coco-1.0.1.tgz
https://registry.npmjs.org/tehanu-teru/-/tehanu-teru-1.0.1.tgz -> npmpkg-tehanu-teru-1.0.1.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-7.0.1.tgz -> npmpkg-test-exclude-7.0.1.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.5.4.tgz -> npmpkg-typescript-5.5.4.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.13.0.tgz -> npmpkg-undici-types-6.13.0.tgz
https://registry.npmjs.org/union/-/union-0.5.0.tgz -> npmpkg-union-0.5.0.tgz
https://registry.npmjs.org/url-join/-/url-join-4.0.1.tgz -> npmpkg-url-join-4.0.1.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.3.0.tgz -> npmpkg-v8-to-istanbul-9.3.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/prantlf/jsonlint/archive/refs/tags/v${PV}.tar.gz
	-> prantlf-${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test" # Missing dev dependencies

npm_update_lock_audit_post() {
einfo "Applying mitigation"
	patch_edits() {
		sed -i -e "s|\"rollup\": \"4.20.0\"|\"rollup\": \"^4.22.4\"|g" "package-lock.json" || die
	}
	patch_edits
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	enpm install "rollup@^4.22.4" -D # DoS, DT, ID		# CVE-2024-47068, GHSA-gcx4-mw62-g8wm
	patch_edits
}
