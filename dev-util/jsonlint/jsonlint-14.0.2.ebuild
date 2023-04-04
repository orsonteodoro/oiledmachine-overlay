# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION="18"
YARN_INSTALL_PATH="/opt/${PN}"
YARN_EXE_LIST="
"
YARN_TEST_SCRIPT="test"
inherit yarn

DESCRIPTION="JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript."
HOMEPAGE="
http://prantlf.github.io/jsonlint/
https://github.com/prantlf/jsonlint
"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}
	dev-util/yarn
"
# grep "resolved" /var/tmp/portage/dev-util/jsonlint-14.0.2/work/jsonlint-14.0.2/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.21.4.tgz -> yarnpkg-@babel-code-frame-7.21.4.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz -> yarnpkg-@babel-helper-validator-identifier-7.19.1.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz -> yarnpkg-@babel-highlight-7.18.6.tgz
https://registry.yarnpkg.com/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> yarnpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.yarnpkg.com/@denolint/denolint-darwin-arm64/-/denolint-darwin-arm64-2.0.7.tgz -> yarnpkg-@denolint-denolint-darwin-arm64-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-darwin-x64/-/denolint-darwin-x64-2.0.7.tgz -> yarnpkg-@denolint-denolint-darwin-x64-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-freebsd-x64/-/denolint-freebsd-x64-2.0.7.tgz -> yarnpkg-@denolint-denolint-freebsd-x64-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-linux-arm-gnueabihf/-/denolint-linux-arm-gnueabihf-2.0.7.tgz -> yarnpkg-@denolint-denolint-linux-arm-gnueabihf-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-linux-arm64-gnu/-/denolint-linux-arm64-gnu-2.0.7.tgz -> yarnpkg-@denolint-denolint-linux-arm64-gnu-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-linux-x64-gnu/-/denolint-linux-x64-gnu-2.0.7.tgz -> yarnpkg-@denolint-denolint-linux-x64-gnu-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-linux-x64-musl/-/denolint-linux-x64-musl-2.0.7.tgz -> yarnpkg-@denolint-denolint-linux-x64-musl-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-win32-arm64-msvc/-/denolint-win32-arm64-msvc-2.0.7.tgz -> yarnpkg-@denolint-denolint-win32-arm64-msvc-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-win32-ia32-msvc/-/denolint-win32-ia32-msvc-2.0.7.tgz -> yarnpkg-@denolint-denolint-win32-ia32-msvc-2.0.7.tgz
https://registry.yarnpkg.com/@denolint/denolint-win32-x64-msvc/-/denolint-win32-x64-msvc-2.0.7.tgz -> yarnpkg-@denolint-denolint-win32-x64-msvc-2.0.7.tgz
https://registry.yarnpkg.com/@esbuild/android-arm/-/android-arm-0.17.11.tgz -> yarnpkg-@esbuild-android-arm-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/android-arm64/-/android-arm64-0.17.11.tgz -> yarnpkg-@esbuild-android-arm64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/android-x64/-/android-x64-0.17.11.tgz -> yarnpkg-@esbuild-android-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/darwin-arm64/-/darwin-arm64-0.17.11.tgz -> yarnpkg-@esbuild-darwin-arm64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/darwin-x64/-/darwin-x64-0.17.11.tgz -> yarnpkg-@esbuild-darwin-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/freebsd-arm64/-/freebsd-arm64-0.17.11.tgz -> yarnpkg-@esbuild-freebsd-arm64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/freebsd-x64/-/freebsd-x64-0.17.11.tgz -> yarnpkg-@esbuild-freebsd-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-arm/-/linux-arm-0.17.11.tgz -> yarnpkg-@esbuild-linux-arm-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-arm64/-/linux-arm64-0.17.11.tgz -> yarnpkg-@esbuild-linux-arm64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-ia32/-/linux-ia32-0.17.11.tgz -> yarnpkg-@esbuild-linux-ia32-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-loong64/-/linux-loong64-0.17.11.tgz -> yarnpkg-@esbuild-linux-loong64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-mips64el/-/linux-mips64el-0.17.11.tgz -> yarnpkg-@esbuild-linux-mips64el-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-ppc64/-/linux-ppc64-0.17.11.tgz -> yarnpkg-@esbuild-linux-ppc64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-riscv64/-/linux-riscv64-0.17.11.tgz -> yarnpkg-@esbuild-linux-riscv64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-s390x/-/linux-s390x-0.17.11.tgz -> yarnpkg-@esbuild-linux-s390x-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/linux-x64/-/linux-x64-0.17.11.tgz -> yarnpkg-@esbuild-linux-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/netbsd-x64/-/netbsd-x64-0.17.11.tgz -> yarnpkg-@esbuild-netbsd-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/openbsd-x64/-/openbsd-x64-0.17.11.tgz -> yarnpkg-@esbuild-openbsd-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/sunos-x64/-/sunos-x64-0.17.11.tgz -> yarnpkg-@esbuild-sunos-x64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/win32-arm64/-/win32-arm64-0.17.11.tgz -> yarnpkg-@esbuild-win32-arm64-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/win32-ia32/-/win32-ia32-0.17.11.tgz -> yarnpkg-@esbuild-win32-ia32-0.17.11.tgz
https://registry.yarnpkg.com/@esbuild/win32-x64/-/win32-x64-0.17.11.tgz -> yarnpkg-@esbuild-win32-x64-0.17.11.tgz
https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.3.tgz -> yarnpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz -> yarnpkg-@jridgewell-resolve-uri-3.1.0.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.17.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.17.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@rollup/plugin-commonjs/-/plugin-commonjs-24.0.1.tgz -> yarnpkg-@rollup-plugin-commonjs-24.0.1.tgz
https://registry.yarnpkg.com/@rollup/plugin-json/-/plugin-json-6.0.0.tgz -> yarnpkg-@rollup-plugin-json-6.0.0.tgz
https://registry.yarnpkg.com/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.0.1.tgz -> yarnpkg-@rollup-plugin-node-resolve-15.0.1.tgz
https://registry.yarnpkg.com/@rollup/pluginutils/-/pluginutils-5.0.2.tgz -> yarnpkg-@rollup-pluginutils-5.0.2.tgz
https://registry.yarnpkg.com/@semantic-release/changelog/-/changelog-6.0.2.tgz -> yarnpkg-@semantic-release-changelog-6.0.2.tgz
https://registry.yarnpkg.com/@semantic-release/error/-/error-3.0.0.tgz -> yarnpkg-@semantic-release-error-3.0.0.tgz
https://registry.yarnpkg.com/@semantic-release/git/-/git-10.0.1.tgz -> yarnpkg-@semantic-release-git-10.0.1.tgz
https://registry.yarnpkg.com/@swc/core-darwin-arm64/-/core-darwin-arm64-1.3.44.tgz -> yarnpkg-@swc-core-darwin-arm64-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-darwin-x64/-/core-darwin-x64-1.3.44.tgz -> yarnpkg-@swc-core-darwin-x64-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.3.44.tgz -> yarnpkg-@swc-core-linux-arm-gnueabihf-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.3.44.tgz -> yarnpkg-@swc-core-linux-arm64-gnu-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.3.44.tgz -> yarnpkg-@swc-core-linux-arm64-musl-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.3.44.tgz -> yarnpkg-@swc-core-linux-x64-gnu-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.3.44.tgz -> yarnpkg-@swc-core-linux-x64-musl-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.3.44.tgz -> yarnpkg-@swc-core-win32-arm64-msvc-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.3.44.tgz -> yarnpkg-@swc-core-win32-ia32-msvc-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.3.44.tgz -> yarnpkg-@swc-core-win32-x64-msvc-1.3.44.tgz
https://registry.yarnpkg.com/@swc/core/-/core-1.3.44.tgz -> yarnpkg-@swc-core-1.3.44.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.0.tgz -> yarnpkg-@types-estree-1.0.0.tgz
https://registry.yarnpkg.com/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.4.tgz -> yarnpkg-@types-istanbul-lib-coverage-2.0.4.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.14.6.tgz -> yarnpkg-@types-node-18.14.6.tgz
https://registry.yarnpkg.com/@types/resolve/-/resolve-1.20.2.tgz -> yarnpkg-@types-resolve-1.20.2.tgz
https://registry.yarnpkg.com/@unixcompat/cat.js/-/cat.js-1.0.2.tgz -> yarnpkg-@unixcompat-cat.js-1.0.2.tgz
https://registry.yarnpkg.com/@unixcompat/mv.js/-/mv.js-1.0.1.tgz -> yarnpkg-@unixcompat-mv.js-1.0.1.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv-draft-04/-/ajv-draft-04-1.0.0.tgz -> yarnpkg-ajv-draft-04-1.0.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.12.0.tgz -> yarnpkg-ajv-8.12.0.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/async/-/async-2.6.4.tgz -> yarnpkg-async-2.6.4.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/basic-auth/-/basic-auth-2.0.1.tgz -> yarnpkg-basic-auth-2.0.1.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-3.3.0.tgz -> yarnpkg-builtin-modules-3.3.0.tgz
https://registry.yarnpkg.com/c8/-/c8-7.13.0.tgz -> yarnpkg-c8-7.13.0.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/corser/-/corser-2.0.1.tgz -> yarnpkg-corser-2.0.1.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-8.1.0.tgz -> yarnpkg-cosmiconfig-8.1.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.3.1.tgz -> yarnpkg-deepmerge-4.3.1.tgz
https://registry.yarnpkg.com/denolint/-/denolint-2.0.7.tgz -> yarnpkg-denolint-2.0.7.tgz
https://registry.yarnpkg.com/diff/-/diff-5.1.0.tgz -> yarnpkg-diff-5.1.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/esbuild/-/esbuild-0.17.11.tgz -> yarnpkg-esbuild-0.17.11.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/estree-walker/-/estree-walker-2.0.2.tgz -> yarnpkg-estree-walker-2.0.2.tgz
https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.7.tgz -> yarnpkg-eventemitter3-4.0.7.tgz
https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz -> yarnpkg-execa-5.1.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz -> yarnpkg-fastq-1.15.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.2.tgz -> yarnpkg-follow-redirects-1.15.2.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-2.0.0.tgz -> yarnpkg-foreground-child-2.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-11.1.1.tgz -> yarnpkg-fs-extra-11.1.1.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz -> yarnpkg-get-stream-6.0.1.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-8.1.0.tgz -> yarnpkg-glob-8.1.0.tgz
https://registry.yarnpkg.com/globalyzer/-/globalyzer-0.1.0.tgz -> yarnpkg-globalyzer-0.1.0.tgz
https://registry.yarnpkg.com/globrex/-/globrex-0.1.2.tgz -> yarnpkg-globrex-0.1.2.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> yarnpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz -> yarnpkg-html-escaper-2.0.2.tgz
https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.1.tgz -> yarnpkg-http-proxy-1.18.1.tgz
https://registry.yarnpkg.com/http-server/-/http-server-14.1.1.tgz -> yarnpkg-http-server-14.1.1.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz -> yarnpkg-human-signals-2.1.0.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-3.2.1.tgz -> yarnpkg-is-builtin-module-3.2.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-module/-/is-module-1.0.0.tgz -> yarnpkg-is-module-1.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-reference/-/is-reference-1.2.1.tgz -> yarnpkg-is-reference-1.2.1.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.0.tgz -> yarnpkg-istanbul-lib-coverage-3.2.0.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> yarnpkg-istanbul-lib-report-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.1.5.tgz -> yarnpkg-istanbul-reports-3.1.5.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> yarnpkg-lines-and-columns-1.2.4.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.27.0.tgz -> yarnpkg-magic-string-0.27.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz -> yarnpkg-mime-1.6.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/opener/-/opener-1.5.2.tgz -> yarnpkg-opener-1.5.2.tgz
https://registry.yarnpkg.com/os-lock/-/os-lock-2.0.0.tgz -> yarnpkg-os-lock-2.0.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-reduce/-/p-reduce-2.1.0.tgz -> yarnpkg-p-reduce-2.1.0.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz -> yarnpkg-parse-json-5.2.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.32.tgz -> yarnpkg-portfinder-1.0.32.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz -> yarnpkg-punycode-2.3.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.1.tgz -> yarnpkg-qs-6.11.1.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz -> yarnpkg-requires-port-1.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/rollup-plugin-swc-minify/-/rollup-plugin-swc-minify-1.0.5.tgz -> yarnpkg-rollup-plugin-swc-minify-1.0.5.tgz
https://registry.yarnpkg.com/rollup/-/rollup-3.18.0.tgz -> yarnpkg-rollup-3.18.0.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/secure-compare/-/secure-compare-3.0.1.tgz -> yarnpkg-secure-compare-3.0.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/tehanu-repo-coco/-/tehanu-repo-coco-1.0.0.tgz -> yarnpkg-tehanu-repo-coco-1.0.0.tgz
https://registry.yarnpkg.com/tehanu-teru/-/tehanu-teru-1.0.0.tgz -> yarnpkg-tehanu-teru-1.0.0.tgz
https://registry.yarnpkg.com/tehanu/-/tehanu-1.0.1.tgz -> yarnpkg-tehanu-1.0.1.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz -> yarnpkg-test-exclude-6.0.0.tgz
https://registry.yarnpkg.com/tiny-glob/-/tiny-glob-0.2.9.tgz -> yarnpkg-tiny-glob-0.2.9.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.9.5.tgz -> yarnpkg-typescript-4.9.5.tgz
https://registry.yarnpkg.com/union/-/union-0.5.0.tgz -> yarnpkg-union-0.5.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/url-join/-/url-join-4.0.1.tgz -> yarnpkg-url-join-4.0.1.tgz
https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-9.1.0.tgz -> yarnpkg-v8-to-istanbul-9.1.0.tgz
https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> yarnpkg-whatwg-encoding-2.0.0.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/prantlf/jsonlint/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test" # Missing dev dependencies

pkg_setup() {
	[[ "${UPDATE_YARN_LOCK}" == "1" ]] && return
	local node_pv=$(/usr/bin/node --version \
		| sed -e "s|v||g" \
		| cut -f 1 -d ".")
        if (( ${node_pv} < ${NODE_VERSION} )) ; then
		eerror
		eerror "node_pv must be >=${NODE_VERSION}"
		eerror "Switch Node.js to >=${NODE_VERSION}"
		eerror
		die
        fi
	einfo "Node.js is ${node_pv}"
}

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		npm i --prod || die
		npm audit fix || die
		yarn import || die
	else
		yarn_src_unpack
	fi
}
