# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="20.4.8"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}/${PV}"
NPM_EXE_LIST="
"${NPM_INSTALL_PATH}/bin/tsc"
"${NPM_INSTALL_PATH}/bin/tsserver"
"
inherit npm

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	CC-BY-4.0
	MIT
	Unicode-DFS-2016
	W3C-Community-Final-Specification-Agreement
	W3C-Software-and-Document-Notice-and-License-2015
"
# TODO:  Inspect downloaded dependencies
# (Apache-2.0 all-rights-reserved) - CopyrightNotice.txt
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})/${PV}"
IUSE+="
test ebuild-revision-3
"
RDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	app-eselect/eselect-typescript
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	dev-util/synp
	media-libs/vips
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-lang/typescript-5.2.2/work/TypeScript-5.2.2/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.18.20.tgz -> npmpkg-@esbuild-android-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.18.20.tgz -> npmpkg-@esbuild-android-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.18.20.tgz -> npmpkg-@esbuild-android-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.18.20.tgz -> npmpkg-@esbuild-darwin-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.18.20.tgz -> npmpkg-@esbuild-darwin-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.18.20.tgz -> npmpkg-@esbuild-linux-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.18.20.tgz -> npmpkg-@esbuild-linux-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.18.20.tgz -> npmpkg-@esbuild-linux-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.18.20.tgz -> npmpkg-@esbuild-linux-loong64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.18.20.tgz -> npmpkg-@esbuild-linux-mips64el-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.18.20.tgz -> npmpkg-@esbuild-linux-ppc64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.18.20.tgz -> npmpkg-@esbuild-linux-riscv64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.18.20.tgz -> npmpkg-@esbuild-linux-s390x-0.18.20.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-netbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-openbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz -> npmpkg-@esbuild-sunos-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz -> npmpkg-@esbuild-win32-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz -> npmpkg-@esbuild-win32-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.20.tgz -> npmpkg-@esbuild-win32-x64-0.18.20.tgz
https://registry.npmjs.org/@esfx/canceltoken/-/canceltoken-1.0.0.tgz -> npmpkg-@esfx-canceltoken-1.0.0.tgz
https://registry.npmjs.org/@octokit/rest/-/rest-19.0.13.tgz -> npmpkg-@octokit-rest-19.0.13.tgz
https://registry.npmjs.org/@types/chai/-/chai-4.3.14.tgz -> npmpkg-@types-chai-4.3.14.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-8.1.0.tgz -> npmpkg-@types-glob-8.1.0.tgz
https://registry.npmjs.org/@types/microsoft__typescript-etw/-/microsoft__typescript-etw-0.1.3.tgz -> npmpkg-@types-microsoft__typescript-etw-0.1.3.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.5.tgz -> npmpkg-@types-minimist-1.2.5.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-10.0.6.tgz -> npmpkg-@types-mocha-10.0.6.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-20.4.8.tgz -> npmpkg-@types-node-20.4.8.tgz
https://registry.npmjs.org/@types/source-map-support/-/source-map-support-0.5.10.tgz -> npmpkg-@types-source-map-support-0.5.10.tgz
https://registry.npmjs.org/@types/which/-/which-2.0.2.tgz -> npmpkg-@types-which-2.0.2.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-6.21.0.tgz -> npmpkg-@typescript-eslint-eslint-plugin-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-6.21.0.tgz -> npmpkg-@typescript-eslint-parser-6.21.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-6.21.0.tgz -> npmpkg-@typescript-eslint-utils-6.21.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/array-back/-/array-back-4.0.2.tgz -> npmpkg-array-back-4.0.2.tgz
https://registry.npmjs.org/azure-devops-node-api/-/azure-devops-node-api-12.5.0.tgz -> npmpkg-azure-devops-node-api-12.5.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/c8/-/c8-7.14.0.tgz -> npmpkg-c8-7.14.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/chai/-/chai-4.4.1.tgz -> npmpkg-chai-4.4.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/command-line-usage/-/command-line-usage-6.1.3.tgz -> npmpkg-command-line-usage-6.1.3.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/diff/-/diff-5.0.0.tgz -> npmpkg-diff-5.0.0.tgz
https://registry.npmjs.org/diff/-/diff-5.2.0.tgz -> npmpkg-diff-5.2.0.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.18.20.tgz -> npmpkg-esbuild-0.18.20.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint-formatter-autolinkable-stylish/-/eslint-formatter-autolinkable-stylish-1.3.0.tgz -> npmpkg-eslint-formatter-autolinkable-stylish-1.3.0.tgz
https://registry.npmjs.org/eslint-plugin-local/-/eslint-plugin-local-1.0.0.tgz -> npmpkg-eslint-plugin-local-1.0.0.tgz
https://registry.npmjs.org/eslint-plugin-no-null/-/eslint-plugin-no-null-1.0.2.tgz -> npmpkg-eslint-plugin-no-null-1.0.2.tgz
https://registry.npmjs.org/eslint-plugin-simple-import-sort/-/eslint-plugin-simple-import-sort-10.0.0.tgz -> npmpkg-eslint-plugin-simple-import-sort-10.0.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.57.0.tgz -> npmpkg-eslint-8.57.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-4.3.6.tgz -> npmpkg-fast-xml-parser-4.3.6.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hereby/-/hereby-1.8.9.tgz -> npmpkg-hereby-1.8.9.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-2.2.2.tgz -> npmpkg-import-meta-resolve-2.2.2.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/irregular-plurals/-/irregular-plurals-3.5.0.tgz -> npmpkg-irregular-plurals-3.5.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.2.1.tgz -> npmpkg-jsonc-parser-3.2.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mocha-fivemat-progress-reporter/-/mocha-fivemat-progress-reporter-0.1.0.tgz -> npmpkg-mocha-fivemat-progress-reporter-0.1.0.tgz
https://registry.npmjs.org/mocha/-/mocha-10.4.0.tgz -> npmpkg-mocha-10.4.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-3.3.2.tgz -> npmpkg-node-fetch-3.3.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.1.tgz -> npmpkg-object-inspect-1.13.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-3.0.0.tgz -> npmpkg-parse-ms-3.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-8.0.0.tgz -> npmpkg-pretty-ms-8.0.0.tgz
https://registry.npmjs.org/qs/-/qs-6.12.0.tgz -> npmpkg-qs-6.12.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/table-layout/-/table-layout-1.0.2.tgz -> npmpkg-table-layout-1.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/typescript/-/typescript-5.4.5.tgz -> npmpkg-typescript-5.4.5.tgz
https://registry.npmjs.org/typical/-/typical-5.2.0.tgz -> npmpkg-typical-5.2.0.tgz
https://registry.npmjs.org/underscore/-/underscore-1.13.6.tgz -> npmpkg-underscore-1.13.6.tgz
https://registry.npmjs.org/wordwrapjs/-/wordwrapjs-4.0.1.tgz -> npmpkg-wordwrapjs-4.0.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

npm_update_lock_install_pre() {
	enpm install "@types/node@${NPM_SECAUDIT_AT_TYPES_NODE_PV}"
}

src_install() {
	npm_src_install

	# Move wrappers
	mv "${ED}/usr/bin/tsc" \
		"${ED}/opt/${PN}/${PV}" || die
	mv "${ED}/usr/bin/tsserver" \
		"${ED}/opt/${PN}/${PV}" || die
einfo "Removing npm-packages-offline-cache"
        rm -rf "${ED}/opt/${PN}/npm-packages-offline-cache"
}

pkg_postinst() {
	if eselect typescript list | grep ${PV} >/dev/null ; then
		eselect typescript set ${PV}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.3 (20230607)
# 87465 passing (17m)

# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.6 (20230709)
#  87478 passing (15m)
#
#Finished do-runtests-parallel in 15m 11.9s
