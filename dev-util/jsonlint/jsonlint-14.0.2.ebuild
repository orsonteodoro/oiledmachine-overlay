# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.21.4.tgz -> npmpkg-@babel-code-frame-7.21.4.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz -> npmpkg-@babel-helper-validator-identifier-7.19.1.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.18.6.tgz -> npmpkg-@babel-highlight-7.18.6.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz -> npmpkg-@colors-colors-1.5.0.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-arm64/-/denolint-darwin-arm64-2.0.7.tgz -> npmpkg-@denolint-denolint-darwin-arm64-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-darwin-x64/-/denolint-darwin-x64-2.0.7.tgz -> npmpkg-@denolint-denolint-darwin-x64-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-freebsd-x64/-/denolint-freebsd-x64-2.0.7.tgz -> npmpkg-@denolint-denolint-freebsd-x64-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm-gnueabihf/-/denolint-linux-arm-gnueabihf-2.0.7.tgz -> npmpkg-@denolint-denolint-linux-arm-gnueabihf-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-linux-arm64-gnu/-/denolint-linux-arm64-gnu-2.0.7.tgz -> npmpkg-@denolint-denolint-linux-arm64-gnu-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-linux-x64-gnu/-/denolint-linux-x64-gnu-2.0.7.tgz -> npmpkg-@denolint-denolint-linux-x64-gnu-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-linux-x64-musl/-/denolint-linux-x64-musl-2.0.7.tgz -> npmpkg-@denolint-denolint-linux-x64-musl-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-win32-arm64-msvc/-/denolint-win32-arm64-msvc-2.0.7.tgz -> npmpkg-@denolint-denolint-win32-arm64-msvc-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-win32-ia32-msvc/-/denolint-win32-ia32-msvc-2.0.7.tgz -> npmpkg-@denolint-denolint-win32-ia32-msvc-2.0.7.tgz
https://registry.npmjs.org/@denolint/denolint-win32-x64-msvc/-/denolint-win32-x64-msvc-2.0.7.tgz -> npmpkg-@denolint-denolint-win32-x64-msvc-2.0.7.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.17.11.tgz -> npmpkg-@esbuild-android-arm-0.17.11.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.17.11.tgz -> npmpkg-@esbuild-android-arm64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.17.11.tgz -> npmpkg-@esbuild-android-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.17.11.tgz -> npmpkg-@esbuild-darwin-arm64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.17.11.tgz -> npmpkg-@esbuild-darwin-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.17.11.tgz -> npmpkg-@esbuild-freebsd-arm64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.17.11.tgz -> npmpkg-@esbuild-freebsd-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.17.11.tgz -> npmpkg-@esbuild-linux-arm-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.17.11.tgz -> npmpkg-@esbuild-linux-arm64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.17.11.tgz -> npmpkg-@esbuild-linux-ia32-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.17.11.tgz -> npmpkg-@esbuild-linux-loong64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.17.11.tgz -> npmpkg-@esbuild-linux-mips64el-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.17.11.tgz -> npmpkg-@esbuild-linux-ppc64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.17.11.tgz -> npmpkg-@esbuild-linux-riscv64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.17.11.tgz -> npmpkg-@esbuild-linux-s390x-0.17.11.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.17.11.tgz -> npmpkg-@esbuild-linux-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.17.11.tgz -> npmpkg-@esbuild-netbsd-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.17.11.tgz -> npmpkg-@esbuild-openbsd-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.17.11.tgz -> npmpkg-@esbuild-sunos-x64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.17.11.tgz -> npmpkg-@esbuild-win32-arm64-0.17.11.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.17.11.tgz -> npmpkg-@esbuild-win32-ia32-0.17.11.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.17.11.tgz -> npmpkg-@esbuild-win32-x64-0.17.11.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.0.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.18.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.18.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@octokit/auth-token/-/auth-token-3.0.3.tgz -> npmpkg-@octokit-auth-token-3.0.3.tgz
https://registry.npmjs.org/@octokit/core/-/core-4.2.0.tgz -> npmpkg-@octokit-core-4.2.0.tgz
https://registry.npmjs.org/@octokit/endpoint/-/endpoint-7.0.5.tgz -> npmpkg-@octokit-endpoint-7.0.5.tgz
https://registry.npmjs.org/@octokit/graphql/-/graphql-5.0.5.tgz -> npmpkg-@octokit-graphql-5.0.5.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-16.0.0.tgz -> npmpkg-@octokit-openapi-types-16.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-6.0.0.tgz -> npmpkg-@octokit-plugin-paginate-rest-6.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-request-log/-/plugin-request-log-1.0.4.tgz -> npmpkg-@octokit-plugin-request-log-1.0.4.tgz
https://registry.npmjs.org/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-7.0.1.tgz -> npmpkg-@octokit-plugin-rest-endpoint-methods-7.0.1.tgz
https://registry.npmjs.org/@octokit/request/-/request-6.2.3.tgz -> npmpkg-@octokit-request-6.2.3.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-3.0.3.tgz -> npmpkg-@octokit-request-error-3.0.3.tgz
https://registry.npmjs.org/@octokit/rest/-/rest-19.0.7.tgz -> npmpkg-@octokit-rest-19.0.7.tgz
https://registry.npmjs.org/@octokit/types/-/types-9.0.0.tgz -> npmpkg-@octokit-types-9.0.0.tgz
https://registry.npmjs.org/@pnpm/config.env-replace/-/config.env-replace-1.1.0.tgz -> npmpkg-@pnpm-config.env-replace-1.1.0.tgz
https://registry.npmjs.org/@pnpm/network.ca-file/-/network.ca-file-1.0.2.tgz -> npmpkg-@pnpm-network.ca-file-1.0.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/@pnpm/npm-conf/-/npm-conf-2.1.1.tgz -> npmpkg-@pnpm-npm-conf-2.1.1.tgz
https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-24.0.1.tgz -> npmpkg-@rollup-plugin-commonjs-24.0.1.tgz
https://registry.npmjs.org/@rollup/plugin-json/-/plugin-json-6.0.0.tgz -> npmpkg-@rollup-plugin-json-6.0.0.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.0.1.tgz -> npmpkg-@rollup-plugin-node-resolve-15.0.1.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-5.0.2.tgz -> npmpkg-@rollup-pluginutils-5.0.2.tgz
https://registry.npmjs.org/@semantic-release/changelog/-/changelog-6.0.2.tgz -> npmpkg-@semantic-release-changelog-6.0.2.tgz
https://registry.npmjs.org/@semantic-release/commit-analyzer/-/commit-analyzer-9.0.2.tgz -> npmpkg-@semantic-release-commit-analyzer-9.0.2.tgz
https://registry.npmjs.org/@semantic-release/error/-/error-3.0.0.tgz -> npmpkg-@semantic-release-error-3.0.0.tgz
https://registry.npmjs.org/@semantic-release/git/-/git-10.0.1.tgz -> npmpkg-@semantic-release-git-10.0.1.tgz
https://registry.npmjs.org/@semantic-release/github/-/github-8.0.7.tgz -> npmpkg-@semantic-release-github-8.0.7.tgz
https://registry.npmjs.org/mime/-/mime-3.0.0.tgz -> npmpkg-mime-3.0.0.tgz
https://registry.npmjs.org/@semantic-release/npm/-/npm-10.0.3.tgz -> npmpkg-@semantic-release-npm-10.0.3.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-4.0.1.tgz -> npmpkg-aggregate-error-4.0.1.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-4.2.0.tgz -> npmpkg-clean-stack-4.2.0.tgz
https://registry.npmjs.org/execa/-/execa-7.1.1.tgz -> npmpkg-execa-7.1.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-4.3.1.tgz -> npmpkg-human-signals-4.3.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.4.0.tgz -> npmpkg-semver-7.4.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/@semantic-release/release-notes-generator/-/release-notes-generator-10.0.3.tgz -> npmpkg-@semantic-release-release-notes-generator-10.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/@swc/core/-/core-1.3.49.tgz -> npmpkg-@swc-core-1.3.49.tgz
https://registry.npmjs.org/@swc/core-darwin-arm64/-/core-darwin-arm64-1.3.49.tgz -> npmpkg-@swc-core-darwin-arm64-1.3.49.tgz
https://registry.npmjs.org/@swc/core-darwin-x64/-/core-darwin-x64-1.3.49.tgz -> npmpkg-@swc-core-darwin-x64-1.3.49.tgz
https://registry.npmjs.org/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.3.49.tgz -> npmpkg-@swc-core-linux-arm-gnueabihf-1.3.49.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.3.49.tgz -> npmpkg-@swc-core-linux-arm64-gnu-1.3.49.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.3.49.tgz -> npmpkg-@swc-core-linux-arm64-musl-1.3.49.tgz
https://registry.npmjs.org/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.3.49.tgz -> npmpkg-@swc-core-linux-x64-gnu-1.3.49.tgz
https://registry.npmjs.org/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.3.49.tgz -> npmpkg-@swc-core-linux-x64-musl-1.3.49.tgz
https://registry.npmjs.org/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.3.49.tgz -> npmpkg-@swc-core-win32-arm64-msvc-1.3.49.tgz
https://registry.npmjs.org/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.3.49.tgz -> npmpkg-@swc-core-win32-ia32-msvc-1.3.49.tgz
https://registry.npmjs.org/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.3.49.tgz -> npmpkg-@swc-core-win32-x64-msvc-1.3.49.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.0.tgz -> npmpkg-@types-estree-1.0.0.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.4.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.4.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.2.tgz -> npmpkg-@types-minimist-1.2.2.tgz
https://registry.npmjs.org/@types/node/-/node-18.14.6.tgz -> npmpkg-@types-node-18.14.6.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.1.tgz -> npmpkg-@types-normalize-package-data-2.4.1.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.20.2.tgz -> npmpkg-@types-resolve-1.20.2.tgz
https://registry.npmjs.org/@types/retry/-/retry-0.12.0.tgz -> npmpkg-@types-retry-0.12.0.tgz
https://registry.npmjs.org/@unixcompat/cat.js/-/cat.js-1.0.2.tgz -> npmpkg-@unixcompat-cat.js-1.0.2.tgz
https://registry.npmjs.org/@unixcompat/mv.js/-/mv.js-1.0.1.tgz -> npmpkg-@unixcompat-mv.js-1.0.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/ajv-draft-04/-/ajv-draft-04-1.0.0.tgz -> npmpkg-ajv-draft-04-1.0.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-5.0.0.tgz -> npmpkg-ansi-escapes-5.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/ansicolors/-/ansicolors-0.3.2.tgz -> npmpkg-ansicolors-0.3.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/argv-formatter/-/argv-formatter-1.0.0.tgz -> npmpkg-argv-formatter-1.0.0.tgz
https://registry.npmjs.org/array-ify/-/array-ify-1.0.0.tgz -> npmpkg-array-ify-1.0.0.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz -> npmpkg-basic-auth-2.0.1.tgz
https://registry.npmjs.org/before-after-hook/-/before-after-hook-2.2.3.tgz -> npmpkg-before-after-hook-2.2.3.tgz
https://registry.npmjs.org/bottleneck/-/bottleneck-2.19.5.tgz -> npmpkg-bottleneck-2.19.5.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/c8/-/c8-7.13.0.tgz -> npmpkg-c8-7.13.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> npmpkg-camelcase-keys-6.2.2.tgz
https://registry.npmjs.org/cardinal/-/cardinal-2.1.1.tgz -> npmpkg-cardinal-2.1.1.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.3.tgz -> npmpkg-cli-table3-0.6.3.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/compare-func/-/compare-func-2.0.0.tgz -> npmpkg-compare-func-2.0.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/conventional-changelog-angular/-/conventional-changelog-angular-5.0.13.tgz -> npmpkg-conventional-changelog-angular-5.0.13.tgz
https://registry.npmjs.org/conventional-changelog-writer/-/conventional-changelog-writer-5.0.1.tgz -> npmpkg-conventional-changelog-writer-5.0.1.tgz
https://registry.npmjs.org/conventional-commits-filter/-/conventional-commits-filter-2.0.7.tgz -> npmpkg-conventional-commits-filter-2.0.7.tgz
https://registry.npmjs.org/conventional-commits-parser/-/conventional-commits-parser-3.2.4.tgz -> npmpkg-conventional-commits-parser-3.2.4.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/corser/-/corser-2.0.1.tgz -> npmpkg-corser-2.0.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.1.0.tgz -> npmpkg-cosmiconfig-8.1.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-4.0.0.tgz -> npmpkg-crypto-random-string-4.0.0.tgz
https://registry.npmjs.org/dateformat/-/dateformat-3.0.3.tgz -> npmpkg-dateformat-3.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/denolint/-/denolint-2.0.7.tgz -> npmpkg-denolint-2.0.7.tgz
https://registry.npmjs.org/deprecation/-/deprecation-2.3.1.tgz -> npmpkg-deprecation-2.3.1.tgz
https://registry.npmjs.org/diff/-/diff-5.1.0.tgz -> npmpkg-diff-5.1.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/duplexer2/-/duplexer2-0.1.4.tgz -> npmpkg-duplexer2-0.1.4.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/env-ci/-/env-ci-9.0.0.tgz -> npmpkg-env-ci-9.0.0.tgz
https://registry.npmjs.org/execa/-/execa-7.1.1.tgz -> npmpkg-execa-7.1.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-4.3.1.tgz -> npmpkg-human-signals-4.3.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.17.11.tgz -> npmpkg-esbuild-0.17.11.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.2.12.tgz -> npmpkg-fast-glob-3.2.12.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/figures/-/figures-5.0.0.tgz -> npmpkg-figures-5.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/find-versions/-/find-versions-5.1.0.tgz -> npmpkg-find-versions-5.1.0.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.2.tgz -> npmpkg-follow-redirects-1.15.2.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-2.0.0.tgz -> npmpkg-foreground-child-2.0.0.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.1.1.tgz -> npmpkg-fs-extra-11.1.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> npmpkg-get-intrinsic-1.2.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/git-log-parser/-/git-log-parser-1.2.0.tgz -> npmpkg-git-log-parser-1.2.0.tgz
https://registry.npmjs.org/split2/-/split2-1.0.0.tgz -> npmpkg-split2-1.0.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globalyzer/-/globalyzer-0.1.0.tgz -> npmpkg-globalyzer-0.1.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/globrex/-/globrex-0.1.2.tgz -> npmpkg-globrex-0.1.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.7.tgz -> npmpkg-handlebars-4.7.7.tgz
https://registry.npmjs.org/hard-rejection/-/hard-rejection-2.1.0.tgz -> npmpkg-hard-rejection-2.1.0.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hook-std/-/hook-std-3.0.0.tgz -> npmpkg-hook-std-3.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-6.1.1.tgz -> npmpkg-hosted-git-info-6.1.1.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz -> npmpkg-http-server-14.1.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-from/-/import-from-4.0.0.tgz -> npmpkg-import-from-4.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/into-stream/-/into-stream-6.0.0.tgz -> npmpkg-into-stream-6.0.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> npmpkg-is-builtin-module-3.2.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.12.0.tgz -> npmpkg-is-core-module-2.12.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-reference/-/is-reference-1.2.1.tgz -> npmpkg-is-reference-1.2.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-text-path/-/is-text-path-1.0.1.tgz -> npmpkg-is-text-path-1.0.1.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-1.3.0.tgz -> npmpkg-is-unicode-supported-1.3.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/issue-parser/-/issue-parser-6.0.0.tgz -> npmpkg-issue-parser-6.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.0.tgz -> npmpkg-istanbul-lib-coverage-3.2.0.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> npmpkg-istanbul-lib-report-3.0.0.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.5.tgz -> npmpkg-istanbul-reports-3.1.5.tgz
https://registry.npmjs.org/java-properties/-/java-properties-1.0.2.tgz -> npmpkg-java-properties-1.0.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonparse/-/jsonparse-1.3.1.tgz -> npmpkg-jsonparse-1.3.1.tgz
https://registry.npmjs.org/JSONStream/-/JSONStream-1.3.5.tgz -> npmpkg-JSONStream-1.3.5.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash-es/-/lodash-es-4.17.21.tgz -> npmpkg-lodash-es-4.17.21.tgz
https://registry.npmjs.org/lodash.capitalize/-/lodash.capitalize-4.2.1.tgz -> npmpkg-lodash.capitalize-4.2.1.tgz
https://registry.npmjs.org/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> npmpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.npmjs.org/lodash.ismatch/-/lodash.ismatch-4.4.0.tgz -> npmpkg-lodash.ismatch-4.4.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.isstring/-/lodash.isstring-4.0.1.tgz -> npmpkg-lodash.isstring-4.0.1.tgz
https://registry.npmjs.org/lodash.uniqby/-/lodash.uniqby-4.7.0.tgz -> npmpkg-lodash.uniqby-4.7.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.27.0.tgz -> npmpkg-magic-string-0.27.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/map-obj/-/map-obj-4.3.0.tgz -> npmpkg-map-obj-4.3.0.tgz
https://registry.npmjs.org/marked/-/marked-4.3.0.tgz -> npmpkg-marked-4.3.0.tgz
https://registry.npmjs.org/marked-terminal/-/marked-terminal-5.1.1.tgz -> npmpkg-marked-terminal-5.1.1.tgz
https://registry.npmjs.org/chalk/-/chalk-5.2.0.tgz -> npmpkg-chalk-5.2.0.tgz
https://registry.npmjs.org/meow/-/meow-8.1.2.tgz -> npmpkg-meow-8.1.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.18.1.tgz -> npmpkg-type-fest-0.18.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-4.1.0.tgz -> npmpkg-minimist-options-4.1.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/modify-values/-/modify-values-1.0.1.tgz -> npmpkg-modify-values-1.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nerf-dart/-/nerf-dart-1.0.0.tgz -> npmpkg-nerf-dart-1.0.0.tgz
https://registry.npmjs.org/node-emoji/-/node-emoji-1.11.0.tgz -> npmpkg-node-emoji-1.11.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.9.tgz -> npmpkg-node-fetch-2.6.9.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> npmpkg-normalize-package-data-3.0.3.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.4.0.tgz -> npmpkg-semver-7.4.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-8.0.0.tgz -> npmpkg-normalize-url-8.0.0.tgz
https://registry.npmjs.org/npm/-/npm-9.6.4.tgz -> npmpkg-npm-9.6.4.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/opener/-/opener-1.5.2.tgz -> npmpkg-opener-1.5.2.tgz
https://registry.npmjs.org/os-lock/-/os-lock-2.0.0.tgz -> npmpkg-os-lock-2.0.0.tgz
https://registry.npmjs.org/p-each-series/-/p-each-series-3.0.0.tgz -> npmpkg-p-each-series-3.0.0.tgz
https://registry.npmjs.org/p-filter/-/p-filter-2.1.0.tgz -> npmpkg-p-filter-2.1.0.tgz
https://registry.npmjs.org/p-is-promise/-/p-is-promise-3.0.0.tgz -> npmpkg-p-is-promise-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/p-reduce/-/p-reduce-2.1.0.tgz -> npmpkg-p-reduce-2.1.0.tgz
https://registry.npmjs.org/p-retry/-/p-retry-4.6.2.tgz -> npmpkg-p-retry-4.6.2.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-2.1.0.tgz -> npmpkg-pkg-conf-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/portfinder/-/portfinder-1.0.32.tgz -> npmpkg-portfinder-1.0.32.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/q/-/q-1.5.1.tgz -> npmpkg-q-1.5.1.tgz
https://registry.npmjs.org/qs/-/qs-6.11.1.tgz -> npmpkg-qs-6.11.1.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-4.0.1.tgz -> npmpkg-quick-lru-4.0.1.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-8.0.0.tgz -> npmpkg-read-pkg-8.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-9.1.0.tgz -> npmpkg-read-pkg-up-9.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-6.3.0.tgz -> npmpkg-find-up-6.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-7.2.0.tgz -> npmpkg-locate-path-7.2.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-4.0.0.tgz -> npmpkg-p-limit-4.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-6.0.0.tgz -> npmpkg-p-locate-6.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-7.1.0.tgz -> npmpkg-read-pkg-7.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.0.0.tgz -> npmpkg-yocto-queue-1.0.0.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.0.tgz -> npmpkg-json-parse-even-better-errors-3.0.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-2.0.3.tgz -> npmpkg-lines-and-columns-2.0.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-5.0.0.tgz -> npmpkg-normalize-package-data-5.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-7.0.0.tgz -> npmpkg-parse-json-7.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.4.0.tgz -> npmpkg-semver-7.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-3.8.0.tgz -> npmpkg-type-fest-3.8.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/redeyed/-/redeyed-2.1.1.tgz -> npmpkg-redeyed-2.1.1.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-5.0.2.tgz -> npmpkg-registry-auth-token-5.0.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/retry/-/retry-0.13.1.tgz -> npmpkg-retry-0.13.1.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/rollup/-/rollup-3.18.0.tgz -> npmpkg-rollup-3.18.0.tgz
https://registry.npmjs.org/rollup-plugin-swc-minify/-/rollup-plugin-swc-minify-1.0.5.tgz -> npmpkg-rollup-plugin-swc-minify-1.0.5.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/secure-compare/-/secure-compare-3.0.1.tgz -> npmpkg-secure-compare-3.0.1.tgz
https://registry.npmjs.org/semantic-release/-/semantic-release-21.0.1.tgz -> npmpkg-semantic-release-21.0.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-4.0.1.tgz -> npmpkg-aggregate-error-4.0.1.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-4.2.0.tgz -> npmpkg-clean-stack-4.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/execa/-/execa-7.1.1.tgz -> npmpkg-execa-7.1.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-4.3.1.tgz -> npmpkg-human-signals-4.3.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-4.0.0.tgz -> npmpkg-mimic-fn-4.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-5.1.0.tgz -> npmpkg-npm-run-path-5.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-6.0.0.tgz -> npmpkg-onetime-6.0.0.tgz
https://registry.npmjs.org/p-reduce/-/p-reduce-3.0.0.tgz -> npmpkg-p-reduce-3.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz -> npmpkg-path-key-4.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.4.0.tgz -> npmpkg-semver-7.4.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-3.0.0.tgz -> npmpkg-strip-final-newline-3.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.1.tgz -> npmpkg-yargs-17.7.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-4.0.0.tgz -> npmpkg-semver-diff-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.4.0.tgz -> npmpkg-semver-7.4.0.tgz
https://registry.npmjs.org/semver-regex/-/semver-regex-4.0.5.tgz -> npmpkg-semver-regex-4.0.5.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/signale/-/signale-1.4.0.tgz -> npmpkg-signale-1.4.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/spawn-error-forwarder/-/spawn-error-forwarder-1.0.0.tgz -> npmpkg-spawn-error-forwarder-1.0.0.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> npmpkg-spdx-license-ids-3.0.13.tgz
https://registry.npmjs.org/split/-/split-1.0.1.tgz -> npmpkg-split-1.0.1.tgz
https://registry.npmjs.org/split2/-/split2-3.2.2.tgz -> npmpkg-split2-3.2.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/stream-combiner2/-/stream-combiner2-1.1.1.tgz -> npmpkg-stream-combiner2-1.1.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-2.3.0.tgz -> npmpkg-supports-hyperlinks-2.3.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tehanu/-/tehanu-1.0.1.tgz -> npmpkg-tehanu-1.0.1.tgz
https://registry.npmjs.org/tehanu-repo-coco/-/tehanu-repo-coco-1.0.0.tgz -> npmpkg-tehanu-repo-coco-1.0.0.tgz
https://registry.npmjs.org/tehanu-teru/-/tehanu-teru-1.0.0.tgz -> npmpkg-tehanu-teru-1.0.0.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-3.0.0.tgz -> npmpkg-tempy-3.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-3.0.0.tgz -> npmpkg-is-stream-3.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/text-extensions/-/text-extensions-1.9.0.tgz -> npmpkg-text-extensions-1.9.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-4.0.2.tgz -> npmpkg-through2-4.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/tiny-glob/-/tiny-glob-0.2.9.tgz -> npmpkg-tiny-glob-0.2.9.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/traverse/-/traverse-0.6.7.tgz -> npmpkg-traverse-0.6.7.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-3.0.1.tgz -> npmpkg-trim-newlines-3.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.17.4.tgz -> npmpkg-uglify-js-3.17.4.tgz
https://registry.npmjs.org/union/-/union-0.5.0.tgz -> npmpkg-union-0.5.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-3.0.0.tgz -> npmpkg-unique-string-3.0.0.tgz
https://registry.npmjs.org/universal-user-agent/-/universal-user-agent-6.0.0.tgz -> npmpkg-universal-user-agent-6.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-join/-/url-join-4.0.1.tgz -> npmpkg-url-join-4.0.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.1.0.tgz -> npmpkg-v8-to-istanbul-9.1.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
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
