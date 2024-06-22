# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
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
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test ebuild-revision-1"
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
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.24.7.tgz -> npmpkg-@babel-code-frame-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.24.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.24.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.24.7.tgz -> npmpkg-@babel-highlight-7.24.7.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz -> npmpkg-@colors-colors-1.5.0.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-arm64/-/denolint-darwin-arm64-2.0.9.tgz -> npmpkg-@denolint-denolint-darwin-arm64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-x64/-/denolint-darwin-x64-2.0.9.tgz -> npmpkg-@denolint-denolint-darwin-x64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-freebsd-x64/-/denolint-freebsd-x64-2.0.9.tgz -> npmpkg-@denolint-denolint-freebsd-x64-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm-gnueabihf/-/denolint-linux-arm-gnueabihf-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-arm-gnueabihf-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm64-gnu/-/denolint-linux-arm64-gnu-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-arm64-gnu-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-x64-gnu/-/denolint-linux-x64-gnu-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-x64-gnu-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-linux-x64-musl/-/denolint-linux-x64-musl-2.0.9.tgz -> npmpkg-@denolint-denolint-linux-x64-musl-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-arm64-msvc/-/denolint-win32-arm64-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-arm64-msvc-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-ia32-msvc/-/denolint-win32-ia32-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-ia32-msvc-2.0.9.tgz
https://registry.npmjs.org/@denolint/denolint-win32-x64-msvc/-/denolint-win32-x64-msvc-2.0.9.tgz -> npmpkg-@denolint-denolint-win32-x64-msvc-2.0.9.tgz
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
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@octokit/auth-token/-/auth-token-5.1.1.tgz -> npmpkg-@octokit-auth-token-5.1.1.tgz
https://registry.npmjs.org/@octokit/core/-/core-6.1.2.tgz -> npmpkg-@octokit-core-6.1.2.tgz
https://registry.npmjs.org/@octokit/endpoint/-/endpoint-10.1.1.tgz -> npmpkg-@octokit-endpoint-10.1.1.tgz
https://registry.npmjs.org/@octokit/graphql/-/graphql-8.1.1.tgz -> npmpkg-@octokit-graphql-8.1.1.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-22.2.0.tgz -> npmpkg-@octokit-openapi-types-22.2.0.tgz
https://registry.npmjs.org/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-11.3.0.tgz -> npmpkg-@octokit-plugin-paginate-rest-11.3.0.tgz
https://registry.npmjs.org/@octokit/plugin-retry/-/plugin-retry-7.1.1.tgz -> npmpkg-@octokit-plugin-retry-7.1.1.tgz
https://registry.npmjs.org/@octokit/plugin-throttling/-/plugin-throttling-9.3.0.tgz -> npmpkg-@octokit-plugin-throttling-9.3.0.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-6.1.1.tgz -> npmpkg-@octokit-request-error-6.1.1.tgz
https://registry.npmjs.org/@octokit/request/-/request-9.1.1.tgz -> npmpkg-@octokit-request-9.1.1.tgz
https://registry.npmjs.org/@octokit/types/-/types-13.5.0.tgz -> npmpkg-@octokit-types-13.5.0.tgz
https://registry.npmjs.org/@pnpm/config.env-replace/-/config.env-replace-1.1.0.tgz -> npmpkg-@pnpm-config.env-replace-1.1.0.tgz
https://registry.npmjs.org/@pnpm/network.ca-file/-/network.ca-file-1.0.2.tgz -> npmpkg-@pnpm-network.ca-file-1.0.2.tgz
https://registry.npmjs.org/@pnpm/npm-conf/-/npm-conf-2.2.2.tgz -> npmpkg-@pnpm-npm-conf-2.2.2.tgz
https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-24.1.0.tgz -> npmpkg-@rollup-plugin-commonjs-24.1.0.tgz
https://registry.npmjs.org/@rollup/plugin-json/-/plugin-json-6.0.0.tgz -> npmpkg-@rollup-plugin-json-6.0.0.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.0.2.tgz -> npmpkg-@rollup-plugin-node-resolve-15.0.2.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-5.1.0.tgz -> npmpkg-@rollup-pluginutils-5.1.0.tgz
https://registry.npmjs.org/@sec-ant/readable-stream/-/readable-stream-0.4.1.tgz -> npmpkg-@sec-ant-readable-stream-0.4.1.tgz
https://registry.npmjs.org/@semantic-release/changelog/-/changelog-6.0.3.tgz -> npmpkg-@semantic-release-changelog-6.0.3.tgz
https://registry.npmjs.org/@semantic-release/commit-analyzer/-/commit-analyzer-13.0.0.tgz -> npmpkg-@semantic-release-commit-analyzer-13.0.0.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-3.0.0.tgz -> npmpkg-@semantic-release-error-3.0.0.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-4.0.0.tgz -> npmpkg-@semantic-release-error-4.0.0.tgz
https://registry.npmjs.org/@semantic-release/git/-/git-10.0.1.tgz -> npmpkg-@semantic-release-git-10.0.1.tgz
https://registry.npmjs.org/@semantic-release/github/-/github-10.0.6.tgz -> npmpkg-@semantic-release-github-10.0.6.tgz
https://registry.npmjs.org/@semantic-release/npm/-/npm-12.0.1.tgz -> npmpkg-@semantic-release-npm-12.0.1.tgz
https://registry.npmjs.org/@semantic-release/release-notes-generator/-/release-notes-generator-14.0.0.tgz -> npmpkg-@semantic-release-release-notes-generator-14.0.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@sindresorhus/merge-streams/-/merge-streams-2.3.0.tgz -> npmpkg-@sindresorhus-merge-streams-2.3.0.tgz
https://registry.npmjs.org/@sindresorhus/merge-streams/-/merge-streams-4.0.0.tgz -> npmpkg-@sindresorhus-merge-streams-4.0.0.tgz
https://registry.npmjs.org/@swc/core-darwin-arm64/-/core-darwin-arm64-1.6.5.tgz -> npmpkg-@swc-core-darwin-arm64-1.6.5.tgz
https://registry.npmjs.org/@swc/core-darwin-x64/-/core-darwin-x64-1.6.5.tgz -> npmpkg-@swc-core-darwin-x64-1.6.5.tgz
https://registry.npmjs.org/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.6.5.tgz -> npmpkg-@swc-core-linux-arm-gnueabihf-1.6.5.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.6.5.tgz -> npmpkg-@swc-core-linux-arm64-gnu-1.6.5.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.6.5.tgz -> npmpkg-@swc-core-linux-arm64-musl-1.6.5.tgz
https://registry.npmjs.org/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.6.5.tgz -> npmpkg-@swc-core-linux-x64-gnu-1.6.5.tgz
https://registry.npmjs.org/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.6.5.tgz -> npmpkg-@swc-core-linux-x64-musl-1.6.5.tgz
https://registry.npmjs.org/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.6.5.tgz -> npmpkg-@swc-core-win32-arm64-msvc-1.6.5.tgz
https://registry.npmjs.org/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.6.5.tgz -> npmpkg-@swc-core-win32-ia32-msvc-1.6.5.tgz
https://registry.npmjs.org/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.6.5.tgz -> npmpkg-@swc-core-win32-x64-msvc-1.6.5.tgz
https://registry.npmjs.org/@swc/core/-/core-1.6.5.tgz -> npmpkg-@swc-core-1.6.5.tgz
https://registry.npmjs.org/@swc/counter/-/counter-0.1.3.tgz -> npmpkg-@swc-counter-0.1.3.tgz
https://registry.npmjs.org/@swc/types/-/types-0.1.9.tgz -> npmpkg-@swc-types-0.1.9.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz -> npmpkg-@types-estree-1.0.5.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.6.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.6.tgz
https://registry.npmjs.org/@types/node/-/node-18.16.1.tgz -> npmpkg-@types-node-18.16.1.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> npmpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.20.2.tgz -> npmpkg-@types-resolve-1.20.2.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.8.tgz -> npmpkg-@types-semver-7.5.8.tgz
https://registry.npmjs.org/@unixcompat/cat.js/-/cat.js-2.0.0.tgz -> npmpkg-@unixcompat-cat.js-2.0.0.tgz
https://registry.npmjs.org/@unixcompat/mv.js/-/mv.js-2.0.0.tgz -> npmpkg-@unixcompat-mv.js-2.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-5.0.0.tgz -> npmpkg-aggregate-error-5.0.0.tgz
https://registry.npmjs.org/ajv-draft-04/-/ajv-draft-04-1.0.0.tgz -> npmpkg-ajv-draft-04-1.0.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-7.0.0.tgz -> npmpkg-ansi-escapes-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz -> npmpkg-any-promise-1.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/argv-formatter/-/argv-formatter-1.0.0.tgz -> npmpkg-argv-formatter-1.0.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/array-ify/-/array-ify-1.0.0.tgz -> npmpkg-array-ify-1.0.0.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz -> npmpkg-basic-auth-2.0.1.tgz
https://registry.npmjs.org/before-after-hook/-/before-after-hook-3.0.2.tgz -> npmpkg-before-after-hook-3.0.2.tgz
https://registry.npmjs.org/bottleneck/-/bottleneck-2.19.5.tgz -> npmpkg-bottleneck-2.19.5.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/c8/-/c8-7.13.0.tgz -> npmpkg-c8-7.13.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz -> npmpkg-char-regex-1.0.2.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-5.2.0.tgz -> npmpkg-clean-stack-5.2.0.tgz
https://registry.npmjs.org/cli-highlight/-/cli-highlight-2.1.11.tgz -> npmpkg-cli-highlight-2.1.11.tgz
https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.5.tgz -> npmpkg-cli-table3-0.6.5.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/compare-func/-/compare-func-2.0.0.tgz -> npmpkg-compare-func-2.0.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/conventional-changelog-angular/-/conventional-changelog-angular-8.0.0.tgz -> npmpkg-conventional-changelog-angular-8.0.0.tgz
https://registry.npmjs.org/conventional-changelog-writer/-/conventional-changelog-writer-8.0.0.tgz -> npmpkg-conventional-changelog-writer-8.0.0.tgz
https://registry.npmjs.org/conventional-commits-filter/-/conventional-commits-filter-5.0.0.tgz -> npmpkg-conventional-commits-filter-5.0.0.tgz
https://registry.npmjs.org/conventional-commits-parser/-/conventional-commits-parser-6.0.0.tgz -> npmpkg-conventional-commits-parser-6.0.0.tgz
https://registry.npmjs.org/convert-hrtime/-/convert-hrtime-5.0.0.tgz -> npmpkg-convert-hrtime-5.0.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/corser/-/corser-2.0.1.tgz -> npmpkg-corser-2.0.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.1.3.tgz -> npmpkg-cosmiconfig-8.1.3.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-9.0.0.tgz -> npmpkg-cosmiconfig-9.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-4.0.0.tgz -> npmpkg-crypto-random-string-4.0.0.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/debug/-/debug-4.3.5.tgz -> npmpkg-debug-4.3.5.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/denolint/-/denolint-2.0.9.tgz -> npmpkg-denolint-2.0.9.tgz
https://registry.npmjs.org/diff/-/diff-5.1.0.tgz -> npmpkg-diff-5.1.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/duplexer2/-/duplexer2-0.1.4.tgz -> npmpkg-duplexer2-0.1.4.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emojilib/-/emojilib-2.4.0.tgz -> npmpkg-emojilib-2.4.0.tgz
https://registry.npmjs.org/env-ci/-/env-ci-11.0.0.tgz -> npmpkg-env-ci-11.0.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/environment/-/environment-1.1.0.tgz -> npmpkg-environment-1.1.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.3.tgz -> npmpkg-es-abstract-1.23.3.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz -> npmpkg-es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> npmpkg-es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.17.18.tgz -> npmpkg-esbuild-0.17.18.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.2.tgz -> npmpkg-escalade-3.1.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/execa/-/execa-8.0.1.tgz -> npmpkg-execa-8.0.1.tgz
https://registry.npmjs.org/execa/-/execa-9.3.0.tgz -> npmpkg-execa-9.3.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.2.12.tgz -> npmpkg-fast-glob-3.2.12.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/figures/-/figures-6.1.0.tgz -> npmpkg-figures-6.1.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-up-simple/-/find-up-simple-1.0.0.tgz -> npmpkg-find-up-simple-1.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/find-versions/-/find-versions-6.0.0.tgz -> npmpkg-find-versions-6.0.0.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.6.tgz -> npmpkg-follow-redirects-1.15.6.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-2.0.0.tgz -> npmpkg-foreground-child-2.0.0.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function-timeout/-/function-timeout-1.0.2.tgz -> npmpkg-function-timeout-1.0.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-7.0.1.tgz -> npmpkg-get-stream-7.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-8.0.1.tgz -> npmpkg-get-stream-8.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-9.0.1.tgz -> npmpkg-get-stream-9.0.1.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/git-log-parser/-/git-log-parser-1.2.0.tgz -> npmpkg-git-log-parser-1.2.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globby/-/globby-14.0.1.tgz -> npmpkg-globby-14.0.1.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.8.tgz -> npmpkg-handlebars-4.7.8.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/highlight.js/-/highlight.js-10.7.3.tgz -> npmpkg-highlight.js-10.7.3.tgz
https://registry.npmjs.org/hook-std/-/hook-std-3.0.0.tgz -> npmpkg-hook-std-3.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-7.0.2.tgz -> npmpkg-hosted-git-info-7.0.2.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz -> npmpkg-http-server-14.1.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.4.tgz -> npmpkg-https-proxy-agent-7.0.4.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/human-signals/-/human-signals-5.0.0.tgz -> npmpkg-human-signals-5.0.0.tgz
https://registry.npmjs.org/human-signals/-/human-signals-7.0.0.tgz -> npmpkg-human-signals-7.0.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.1.tgz -> npmpkg-ignore-5.3.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-from-esm/-/import-from-esm-1.3.4.tgz -> npmpkg-import-from-esm-1.3.4.tgz
https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-4.1.0.tgz -> npmpkg-import-meta-resolve-4.1.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/index-to-position/-/index-to-position-0.1.2.tgz -> npmpkg-index-to-position-0.1.2.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/into-stream/-/into-stream-7.0.0.tgz -> npmpkg-into-stream-7.0.0.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> npmpkg-is-builtin-module-3.2.1.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.14.0.tgz -> npmpkg-is-core-module-2.14.0.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/is-reference/-/is-reference-1.2.1.tgz -> npmpkg-is-reference-1.2.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-4.0.1.tgz -> npmpkg-is-stream-4.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-2.0.0.tgz -> npmpkg-is-unicode-supported-2.0.0.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/issue-parser/-/issue-parser-7.0.1.tgz -> npmpkg-issue-parser-7.0.1.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.7.tgz -> npmpkg-istanbul-reports-3.1.7.tgz
https://registry.npmjs.org/java-properties/-/java-properties-1.0.2.tgz -> npmpkg-java-properties-1.0.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash-es/-/lodash-es-4.17.21.tgz -> npmpkg-lodash-es-4.17.21.tgz
https://registry.npmjs.org/lodash.capitalize/-/lodash.capitalize-4.2.1.tgz -> npmpkg-lodash.capitalize-4.2.1.tgz
https://registry.npmjs.org/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> npmpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.isstring/-/lodash.isstring-4.0.1.tgz -> npmpkg-lodash.isstring-4.0.1.tgz
https://registry.npmjs.org/lodash.uniqby/-/lodash.uniqby-4.7.0.tgz -> npmpkg-lodash.uniqby-4.7.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.2.2.tgz -> npmpkg-lru-cache-10.2.2.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.27.0.tgz -> npmpkg-magic-string-0.27.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/marked-terminal/-/marked-terminal-7.1.0.tgz -> npmpkg-marked-terminal-7.1.0.tgz
https://registry.npmjs.org/marked/-/marked-12.0.2.tgz -> npmpkg-marked-12.0.2.tgz
https://registry.npmjs.org/meow/-/meow-13.2.0.tgz -> npmpkg-meow-13.2.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.7.tgz -> npmpkg-micromatch-4.0.7.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime/-/mime-4.0.3.tgz -> npmpkg-mime-4.0.3.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/mz/-/mz-2.7.0.tgz -> npmpkg-mz-2.7.0.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nerf-dart/-/nerf-dart-1.0.0.tgz -> npmpkg-nerf-dart-1.0.0.tgz
https://registry.npmjs.org/node-emoji/-/node-emoji-2.1.3.tgz -> npmpkg-node-emoji-2.1.3.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-6.0.1.tgz -> npmpkg-normalize-package-data-6.0.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-8.0.1.tgz -> npmpkg-normalize-url-8.0.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.3.0.tgz -> npmpkg-npm-run-path-5.3.0.tgz
https://registry.npmjs.org/npm/-/npm-10.8.1.tgz -> npmpkg-npm-10.8.1.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/opener/-/opener-1.5.2.tgz -> npmpkg-opener-1.5.2.tgz
https://registry.npmjs.org/os-lock/-/os-lock-2.0.0.tgz -> npmpkg-os-lock-2.0.0.tgz
https://registry.npmjs.org/p-each-series/-/p-each-series-3.0.0.tgz -> npmpkg-p-each-series-3.0.0.tgz
https://registry.npmjs.org/p-filter/-/p-filter-4.1.0.tgz -> npmpkg-p-filter-4.1.0.tgz
https://registry.npmjs.org/p-is-promise/-/p-is-promise-3.0.0.tgz -> npmpkg-p-is-promise-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-7.0.2.tgz -> npmpkg-p-map-7.0.2.tgz
https://registry.npmjs.org/p-reduce/-/p-reduce-2.1.0.tgz -> npmpkg-p-reduce-2.1.0.tgz
https://registry.npmjs.org/p-reduce/-/p-reduce-3.0.0.tgz -> npmpkg-p-reduce-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-8.1.0.tgz -> npmpkg-parse-json-8.1.0.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-4.0.0.tgz -> npmpkg-parse-ms-4.0.0.tgz
https://registry.npmjs.org/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-6.0.1.tgz -> npmpkg-parse5-htmlparser2-tree-adapter-6.0.1.tgz
https://registry.npmjs.org/parse5/-/parse5-5.1.1.tgz -> npmpkg-parse5-5.1.1.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/path-type/-/path-type-5.0.0.tgz -> npmpkg-path-type-5.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.1.tgz -> npmpkg-picocolors-1.0.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-2.1.0.tgz -> npmpkg-pkg-conf-2.1.0.tgz
https://registry.npmjs.org/portfinder/-/portfinder-1.0.32.tgz -> npmpkg-portfinder-1.0.32.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-9.0.0.tgz -> npmpkg-pretty-ms-9.0.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/qs/-/qs-6.12.1.tgz -> npmpkg-qs-6.12.1.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/read-package-up/-/read-package-up-11.0.0.tgz -> npmpkg-read-package-up-11.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-11.0.0.tgz -> npmpkg-read-pkg-up-11.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-9.0.1.tgz -> npmpkg-read-pkg-9.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz -> npmpkg-regexp.prototype.flags-1.5.2.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-5.0.2.tgz -> npmpkg-registry-auth-token-5.0.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup-plugin-swc-minify/-/rollup-plugin-swc-minify-1.0.6.tgz -> npmpkg-rollup-plugin-swc-minify-1.0.6.tgz
https://registry.npmjs.org/rollup/-/rollup-3.21.0.tgz -> npmpkg-rollup-3.21.0.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/secure-compare/-/secure-compare-3.0.1.tgz -> npmpkg-secure-compare-3.0.1.tgz
https://registry.npmjs.org/semantic-release/-/semantic-release-24.0.0.tgz -> npmpkg-semantic-release-24.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-4.0.0.tgz -> npmpkg-semver-diff-4.0.0.tgz
https://registry.npmjs.org/semver-regex/-/semver-regex-4.0.5.tgz -> npmpkg-semver-regex-4.0.5.tgz
https://registry.npmjs.org/semver/-/semver-7.6.2.tgz -> npmpkg-semver-7.6.2.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/signale/-/signale-1.4.0.tgz -> npmpkg-signale-1.4.0.tgz
https://registry.npmjs.org/skin-tone/-/skin-tone-2.0.0.tgz -> npmpkg-skin-tone-2.0.0.tgz
https://registry.npmjs.org/slash/-/slash-5.1.0.tgz -> npmpkg-slash-5.1.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/spawn-error-forwarder/-/spawn-error-forwarder-1.0.0.tgz -> npmpkg-spawn-error-forwarder-1.0.0.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.18.tgz -> npmpkg-spdx-license-ids-3.0.18.tgz
https://registry.npmjs.org/split2/-/split2-1.0.0.tgz -> npmpkg-split2-1.0.0.tgz
https://registry.npmjs.org/stream-combiner2/-/stream-combiner2-1.1.1.tgz -> npmpkg-stream-combiner2-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-4.0.0.tgz -> npmpkg-strip-final-newline-4.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/super-regex/-/super-regex-1.0.0.tgz -> npmpkg-super-regex-1.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-3.0.0.tgz -> npmpkg-supports-hyperlinks-3.0.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tehanu-repo-coco/-/tehanu-repo-coco-1.0.0.tgz -> npmpkg-tehanu-repo-coco-1.0.0.tgz
https://registry.npmjs.org/tehanu-teru/-/tehanu-teru-1.0.0.tgz -> npmpkg-tehanu-teru-1.0.0.tgz
https://registry.npmjs.org/tehanu/-/tehanu-1.0.1.tgz -> npmpkg-tehanu-1.0.1.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-3.0.0.tgz -> npmpkg-temp-dir-3.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-3.1.0.tgz -> npmpkg-tempy-3.1.0.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz -> npmpkg-thenify-all-1.6.0.tgz
https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz -> npmpkg-thenify-3.3.1.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/time-span/-/time-span-5.1.0.tgz -> npmpkg-time-span-5.1.0.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/traverse/-/traverse-0.6.9.tgz -> npmpkg-traverse-0.6.9.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.20.1.tgz -> npmpkg-type-fest-4.20.1.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz -> npmpkg-typed-array-byte-offset-1.0.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.6.tgz -> npmpkg-typed-array-length-1.0.6.tgz
https://registry.npmjs.org/typedarray.prototype.slice/-/typedarray.prototype.slice-1.0.3.tgz -> npmpkg-typedarray.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/typescript/-/typescript-5.0.4.tgz -> npmpkg-typescript-5.0.4.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.18.0.tgz -> npmpkg-uglify-js-3.18.0.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/unicode-emoji-modifier-base/-/unicode-emoji-modifier-base-1.0.0.tgz -> npmpkg-unicode-emoji-modifier-base-1.0.0.tgz
https://registry.npmjs.org/unicorn-magic/-/unicorn-magic-0.1.0.tgz -> npmpkg-unicorn-magic-0.1.0.tgz
https://registry.npmjs.org/union/-/union-0.5.0.tgz -> npmpkg-union-0.5.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-3.0.0.tgz -> npmpkg-unique-string-3.0.0.tgz
https://registry.npmjs.org/universal-user-agent/-/universal-user-agent-7.0.2.tgz -> npmpkg-universal-user-agent-7.0.2.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-join/-/url-join-4.0.1.tgz -> npmpkg-url-join-4.0.1.tgz
https://registry.npmjs.org/url-join/-/url-join-5.0.0.tgz -> npmpkg-url-join-5.0.0.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.2.0.tgz -> npmpkg-v8-to-istanbul-9.2.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/yoctocolors/-/yoctocolors-2.0.2.tgz -> npmpkg-yoctocolors-2.0.2.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/prantlf/jsonlint/archive/refs/tags/v${PV}.tar.gz
	-> prantlf-${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test" # Missing dev dependencies
