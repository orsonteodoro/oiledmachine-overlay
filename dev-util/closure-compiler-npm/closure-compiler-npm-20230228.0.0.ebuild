# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# All builds require npm/node.

BAZEL_PV="5.3.0"
GRAALVM_JAVA_PV=17
GRAALVM_PV="22.3.0"
NODE_ENV=development
NODE_VERSION=14 # Upstream uses 14 on linux but others 16, 18
inherit bazel check-reqs java-utils-2 graalvm yarn

DESCRIPTION="Check, compile, optimize and compress Javascript with \
Closure-Compiler"
HOMEPAGE="
https://developers.google.com/closure/compiler/
https://github.com/google/closure-compiler-npm
"

LICENSE="
	Apache-2.0
	BSD
	CPL-1.0
	GPL-2+
	LGPL-2.1+
	MIT
	MPL-2.0
	NPL-1.1
	closure_compiler_native? ( ${GRAAL_VM_CE_LICENSES} )
"
KEYWORDS="~amd64 ~arm64"
CC_PV=$(ver_cut 1 ${PV})
SLOT="0/$(ver_cut 1-2 ${PV})"
JAVA_SLOT="11"
NODE_SLOT="0"
MY_PN="closure-compiler"
IUSE+="
	closure_compiler_java
	closure_compiler_js
	closure_compiler_native
	closure_compiler_nodejs
	doc
	test
"
REQUIRED_USE+="
	closure_compiler_nodejs? (
		closure_compiler_java
	)
	|| (
		closure_compiler_java
		closure_compiler_js
		closure_compiler_native
		closure_compiler_nodejs
	)
"
# For the node version, see
# https://github.com/google/closure-compiler-npm/blob/v20230228.0.0/packages/google-closure-compiler/package.json
# For dependencies, see
# https://github.com/google/closure-compiler-npm/blob/v20230228.0.0/.github/workflows/build.yml
JDK_DEPEND="
	|| (
		dev-java/openjdk-bin:${JAVA_SLOT}
		dev-java/openjdk:${JAVA_SLOT}
	)
"
JRE_DEPEND="
	|| (
		${JDK_DEPEND}
		dev-java/openjdk-jre-bin:${JAVA_SLOT}
	)
"
#JDK_DEPEND=" virtual/jdk:${JAVA_SLOT}"
#JRE_DEPEND=" virtual/jre:${JAVA_SLOT}"
# The virtual/jdk not virtual/jre must be in DEPENDs for the eclass not to be stupid.
RDEPEND+="
	!dev-lang/closure-compiler-bin
	closure_compiler_java? (
		${JRE_DEPEND}
	)
	closure_compiler_nodejs? (
		${JRE_DEPEND}
		>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
		>=net-libs/nodejs-${NODE_VERSION}[npm]
	)
"
DEPEND+="
	${RDEPEND}
	${JDK_DEPEND}
"
BDEPEND+="
	${JDK_DEPEND}
	=dev-util/bazel-$(ver_cut 1 ${BAZEL_PV})*
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	dev-java/maven-bin
	dev-vcs/git
	closure_compiler_native? (
		${GRAALVM_CE_DEPENDS}
	)
"

FN_DEST="${PN}-${PV}.tar.gz"
FN_DEST2="closure-compiler-${PV}.tar.gz"
BAZELISK_PV="1.15.0" # From CI (Build Compiler)
BAZELISK_ABIS="
	amd64
	arm64
"
gen_bazelisk_src_uris() {
	local abi
	for abi in ${BAZELISK_ABIS} ; do
		echo "
	${abi}? (
https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_PV}/bazelisk-linux-${abi}
	-> bazelisk-linux-${abi}-${BAZELISK_PV}
	)
		"
	done
}

# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/closure-compiler-npm-20230228.0.0/work/closure-compiler-npm-20230228.0.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@gulp-sourcemaps/identity-map/-/identity-map-1.0.2.tgz -> yarnpkg-@gulp-sourcemaps-identity-map-1.0.2.tgz
https://registry.yarnpkg.com/@gulp-sourcemaps/map-sources/-/map-sources-1.0.0.tgz -> yarnpkg-@gulp-sourcemaps-map-sources-1.0.0.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.3.tgz -> yarnpkg-@types-minimatch-3.0.3.tgz
https://registry.yarnpkg.com/@ungap/promise-all-settled/-/promise-all-settled-1.1.2.tgz -> yarnpkg-@ungap-promise-all-settled-1.1.2.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-5.7.4.tgz -> yarnpkg-acorn-5.7.4.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-1.1.0.tgz -> yarnpkg-ansi-colors-1.1.0.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-gray/-/ansi-gray-0.1.1.tgz -> yarnpkg-ansi-gray-0.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.1.tgz -> yarnpkg-ansi-regex-3.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/ansi-wrap/-/ansi-wrap-0.1.0.tgz -> yarnpkg-ansi-wrap-0.1.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz -> yarnpkg-anymatch-2.0.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz -> yarnpkg-anymatch-3.1.2.tgz
https://registry.yarnpkg.com/append-buffer/-/append-buffer-1.0.2.tgz -> yarnpkg-append-buffer-1.0.2.tgz
https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz -> yarnpkg-aproba-1.2.0.tgz
https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz -> yarnpkg-archy-1.0.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz -> yarnpkg-are-we-there-yet-1.1.5.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz -> yarnpkg-arr-diff-4.0.0.tgz
https://registry.yarnpkg.com/arr-filter/-/arr-filter-1.1.2.tgz -> yarnpkg-arr-filter-1.1.2.tgz
https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz -> yarnpkg-arr-flatten-1.1.0.tgz
https://registry.yarnpkg.com/arr-map/-/arr-map-2.0.2.tgz -> yarnpkg-arr-map-2.0.2.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-differ/-/array-differ-3.0.0.tgz -> yarnpkg-array-differ-3.0.0.tgz
https://registry.yarnpkg.com/array-each/-/array-each-1.0.1.tgz -> yarnpkg-array-each-1.0.1.tgz
https://registry.yarnpkg.com/array-initial/-/array-initial-1.1.0.tgz -> yarnpkg-array-initial-1.1.0.tgz
https://registry.yarnpkg.com/array-last/-/array-last-1.3.0.tgz -> yarnpkg-array-last-1.3.0.tgz
https://registry.yarnpkg.com/array-slice/-/array-slice-1.1.0.tgz -> yarnpkg-array-slice-1.1.0.tgz
https://registry.yarnpkg.com/array-sort/-/array-sort-1.0.0.tgz -> yarnpkg-array-sort-1.0.0.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz -> yarnpkg-array-unique-0.3.2.tgz
https://registry.yarnpkg.com/arrify/-/arrify-2.0.1.tgz -> yarnpkg-arrify-2.0.1.tgz
https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz -> yarnpkg-assign-symbols-1.0.0.tgz
https://registry.yarnpkg.com/async-done/-/async-done-1.3.1.tgz -> yarnpkg-async-done-1.3.1.tgz
https://registry.yarnpkg.com/async-each/-/async-each-1.0.3.tgz -> yarnpkg-async-each-1.0.3.tgz
https://registry.yarnpkg.com/async-settle/-/async-settle-1.0.0.tgz -> yarnpkg-async-settle-1.0.0.tgz
https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz -> yarnpkg-atob-2.1.2.tgz
https://registry.yarnpkg.com/bach/-/bach-1.2.0.tgz -> yarnpkg-bach-1.2.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base/-/base-0.11.2.tgz -> yarnpkg-base-0.11.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz -> yarnpkg-binary-extensions-1.13.1.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz -> yarnpkg-braces-2.3.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/browser-stdout/-/browser-stdout-1.3.1.tgz -> yarnpkg-browser-stdout-1.3.1.tgz
https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-1.0.0.tgz -> yarnpkg-buffer-equal-1.0.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz -> yarnpkg-buffer-from-1.1.1.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz -> yarnpkg-builtin-modules-1.1.1.tgz
https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz -> yarnpkg-cache-base-1.0.1.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-3.0.0.tgz -> yarnpkg-camelcase-3.0.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-6.3.0.tgz -> yarnpkg-camelcase-6.3.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-2.1.8.tgz -> yarnpkg-chokidar-2.1.8.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/chownr/-/chownr-1.1.4.tgz -> yarnpkg-chownr-1.1.4.tgz
https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz -> yarnpkg-class-utils-0.3.6.tgz
https://registry.yarnpkg.com/cliui/-/cliui-3.2.0.tgz -> yarnpkg-cliui-3.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/clone-buffer/-/clone-buffer-1.0.0.tgz -> yarnpkg-clone-buffer-1.0.0.tgz
https://registry.yarnpkg.com/clone-stats/-/clone-stats-1.0.0.tgz -> yarnpkg-clone-stats-1.0.0.tgz
https://registry.yarnpkg.com/clone/-/clone-2.1.2.tgz -> yarnpkg-clone-2.1.2.tgz
https://registry.yarnpkg.com/cloneable-readable/-/cloneable-readable-1.1.2.tgz -> yarnpkg-cloneable-readable-1.1.2.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/collection-map/-/collection-map-1.0.0.tgz -> yarnpkg-collection-map-1.0.0.tgz
https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz -> yarnpkg-collection-visit-1.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.2.1.tgz -> yarnpkg-component-emitter-1.2.1.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.6.0.tgz -> yarnpkg-convert-source-map-1.6.0.tgz
https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> yarnpkg-copy-descriptor-0.1.1.tgz
https://registry.yarnpkg.com/copy-props/-/copy-props-2.0.5.tgz -> yarnpkg-copy-props-2.0.5.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/css/-/css-2.2.4.tgz -> yarnpkg-css-2.2.4.tgz
https://registry.yarnpkg.com/d/-/d-1.0.0.tgz -> yarnpkg-d-1.0.0.tgz
https://registry.yarnpkg.com/dargs/-/dargs-7.0.0.tgz -> yarnpkg-dargs-7.0.0.tgz
https://registry.yarnpkg.com/debug-fabulous/-/debug-fabulous-1.1.0.tgz -> yarnpkg-debug-fabulous-1.1.0.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.6.tgz -> yarnpkg-debug-3.2.6.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-4.0.0.tgz -> yarnpkg-decamelize-4.0.0.tgz
https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> yarnpkg-decode-uri-component-0.2.2.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/default-compare/-/default-compare-1.0.0.tgz -> yarnpkg-default-compare-1.0.0.tgz
https://registry.yarnpkg.com/default-resolution/-/default-resolution-2.0.0.tgz -> yarnpkg-default-resolution-2.0.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz -> yarnpkg-define-properties-1.1.3.tgz
https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz -> yarnpkg-define-property-0.2.5.tgz
https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz -> yarnpkg-define-property-1.0.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz -> yarnpkg-define-property-2.0.2.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz -> yarnpkg-detect-file-1.0.0.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz -> yarnpkg-detect-libc-1.0.3.tgz
https://registry.yarnpkg.com/detect-newline/-/detect-newline-2.1.0.tgz -> yarnpkg-detect-newline-2.1.0.tgz
https://registry.yarnpkg.com/diff/-/diff-5.0.0.tgz -> yarnpkg-diff-5.0.0.tgz
https://registry.yarnpkg.com/duplexify/-/duplexify-3.6.1.tgz -> yarnpkg-duplexify-3.6.1.tgz
https://registry.yarnpkg.com/each-props/-/each-props-1.3.2.tgz -> yarnpkg-each-props-1.3.2.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.1.tgz -> yarnpkg-end-of-stream-1.4.1.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es5-ext/-/es5-ext-0.10.46.tgz -> yarnpkg-es5-ext-0.10.46.tgz
https://registry.yarnpkg.com/es6-iterator/-/es6-iterator-2.0.3.tgz -> yarnpkg-es6-iterator-2.0.3.tgz
https://registry.yarnpkg.com/es6-symbol/-/es6-symbol-3.1.1.tgz -> yarnpkg-es6-symbol-3.1.1.tgz
https://registry.yarnpkg.com/es6-weak-map/-/es6-weak-map-2.0.2.tgz -> yarnpkg-es6-weak-map-2.0.2.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/event-emitter/-/event-emitter-0.3.5.tgz -> yarnpkg-event-emitter-0.3.5.tgz
https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz -> yarnpkg-execa-5.1.1.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz -> yarnpkg-expand-brackets-2.1.4.tgz
https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz -> yarnpkg-expand-tilde-2.0.2.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz -> yarnpkg-extend-shallow-3.0.2.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz -> yarnpkg-extglob-2.0.4.tgz
https://registry.yarnpkg.com/fancy-log/-/fancy-log-1.3.3.tgz -> yarnpkg-fancy-log-1.3.3.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz -> yarnpkg-fill-range-4.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz -> yarnpkg-find-up-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/findup-sync/-/findup-sync-2.0.0.tgz -> yarnpkg-findup-sync-2.0.0.tgz
https://registry.yarnpkg.com/findup-sync/-/findup-sync-3.0.0.tgz -> yarnpkg-findup-sync-3.0.0.tgz
https://registry.yarnpkg.com/fined/-/fined-1.1.0.tgz -> yarnpkg-fined-1.1.0.tgz
https://registry.yarnpkg.com/flagged-respawn/-/flagged-respawn-1.0.0.tgz -> yarnpkg-flagged-respawn-1.0.0.tgz
https://registry.yarnpkg.com/flat/-/flat-5.0.2.tgz -> yarnpkg-flat-5.0.2.tgz
https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> yarnpkg-flush-write-stream-1.1.1.tgz
https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz -> yarnpkg-for-in-1.0.2.tgz
https://registry.yarnpkg.com/for-own/-/for-own-1.0.0.tgz -> yarnpkg-for-own-1.0.0.tgz
https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz -> yarnpkg-fragment-cache-0.2.1.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-1.2.7.tgz -> yarnpkg-fs-minipass-1.2.7.tgz
https://registry.yarnpkg.com/fs-mkdirp-stream/-/fs-mkdirp-stream-1.0.0.tgz -> yarnpkg-fs-mkdirp-stream-1.0.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.9.tgz -> yarnpkg-fsevents-1.2.9.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz -> yarnpkg-gauge-2.7.4.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.3.tgz -> yarnpkg-get-caller-file-1.0.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.1.tgz -> yarnpkg-get-intrinsic-1.1.1.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz -> yarnpkg-get-stream-6.0.1.tgz
https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz -> yarnpkg-get-value-2.0.6.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-stream/-/glob-stream-6.1.0.tgz -> yarnpkg-glob-stream-6.1.0.tgz
https://registry.yarnpkg.com/glob-watcher/-/glob-watcher-5.0.5.tgz -> yarnpkg-glob-watcher-5.0.5.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.3.tgz -> yarnpkg-glob-7.1.3.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.4.tgz -> yarnpkg-glob-7.1.4.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz -> yarnpkg-glob-7.1.7.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz -> yarnpkg-glob-7.2.0.tgz
https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz -> yarnpkg-global-modules-1.0.0.tgz
https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz -> yarnpkg-global-prefix-1.0.2.tgz
https://registry.yarnpkg.com/glogg/-/glogg-1.0.1.tgz -> yarnpkg-glogg-1.0.1.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.3.tgz -> yarnpkg-graceful-fs-4.2.3.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.6.tgz -> yarnpkg-graceful-fs-4.2.6.tgz
https://registry.yarnpkg.com/graphlib/-/graphlib-2.1.8.tgz -> yarnpkg-graphlib-2.1.8.tgz
https://registry.yarnpkg.com/gulp-cli/-/gulp-cli-2.2.0.tgz -> yarnpkg-gulp-cli-2.2.0.tgz
https://registry.yarnpkg.com/gulp-filter/-/gulp-filter-6.0.0.tgz -> yarnpkg-gulp-filter-6.0.0.tgz
https://registry.yarnpkg.com/gulp-mocha/-/gulp-mocha-8.0.0.tgz -> yarnpkg-gulp-mocha-8.0.0.tgz
https://registry.yarnpkg.com/gulp-sourcemaps/-/gulp-sourcemaps-2.6.5.tgz -> yarnpkg-gulp-sourcemaps-2.6.5.tgz
https://registry.yarnpkg.com/gulp/-/gulp-4.0.2.tgz -> yarnpkg-gulp-4.0.2.tgz
https://registry.yarnpkg.com/gulplog/-/gulplog-1.0.0.tgz -> yarnpkg-gulplog-1.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.2.tgz -> yarnpkg-has-symbols-1.0.2.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz -> yarnpkg-has-value-0.3.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz -> yarnpkg-has-value-1.0.0.tgz
https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz -> yarnpkg-has-values-0.1.4.tgz
https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz -> yarnpkg-has-values-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.1.tgz -> yarnpkg-homedir-polyfill-1.0.1.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz -> yarnpkg-human-signals-2.1.0.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-3.0.1.tgz -> yarnpkg-ignore-walk-3.0.1.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.7.tgz -> yarnpkg-ini-1.3.7.tgz
https://registry.yarnpkg.com/interpret/-/interpret-1.2.0.tgz -> yarnpkg-interpret-1.2.0.tgz
https://registry.yarnpkg.com/invert-kv/-/invert-kv-1.0.0.tgz -> yarnpkg-invert-kv-1.0.0.tgz
https://registry.yarnpkg.com/is-absolute/-/is-absolute-1.0.0.tgz -> yarnpkg-is-absolute-1.0.0.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> yarnpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> yarnpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz -> yarnpkg-is-binary-path-1.0.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz -> yarnpkg-is-buffer-1.1.6.tgz
https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-1.0.0.tgz -> yarnpkg-is-builtin-module-1.0.0.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> yarnpkg-is-data-descriptor-0.1.4.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> yarnpkg-is-data-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz -> yarnpkg-is-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz -> yarnpkg-is-descriptor-1.0.2.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz -> yarnpkg-is-extendable-1.0.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> yarnpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz -> yarnpkg-is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.0.tgz -> yarnpkg-is-glob-4.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> yarnpkg-is-negated-glob-1.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz -> yarnpkg-is-number-3.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz -> yarnpkg-is-number-4.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> yarnpkg-is-plain-obj-2.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz -> yarnpkg-is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-promise/-/is-promise-2.1.0.tgz -> yarnpkg-is-promise-2.1.0.tgz
https://registry.yarnpkg.com/is-relative/-/is-relative-1.0.0.tgz -> yarnpkg-is-relative-1.0.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-unc-path/-/is-unc-path-1.0.0.tgz -> yarnpkg-is-unc-path-1.0.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz -> yarnpkg-is-utf8-0.2.1.tgz
https://registry.yarnpkg.com/is-valid-glob/-/is-valid-glob-1.0.0.tgz -> yarnpkg-is-valid-glob-1.0.0.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz -> yarnpkg-isarray-0.0.1.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz -> yarnpkg-isobject-2.1.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/just-debounce/-/just-debounce-1.0.0.tgz -> yarnpkg-just-debounce-1.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz -> yarnpkg-kind-of-3.2.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz -> yarnpkg-kind-of-4.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz -> yarnpkg-kind-of-5.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/last-run/-/last-run-1.1.1.tgz -> yarnpkg-last-run-1.1.1.tgz
https://registry.yarnpkg.com/lazystream/-/lazystream-1.0.0.tgz -> yarnpkg-lazystream-1.0.0.tgz
https://registry.yarnpkg.com/lcid/-/lcid-1.0.0.tgz -> yarnpkg-lcid-1.0.0.tgz
https://registry.yarnpkg.com/lead/-/lead-1.0.0.tgz -> yarnpkg-lead-1.0.0.tgz
https://registry.yarnpkg.com/liftoff/-/liftoff-3.1.0.tgz -> yarnpkg-liftoff-3.1.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz -> yarnpkg-load-json-file-1.1.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/lru-queue/-/lru-queue-0.1.0.tgz -> yarnpkg-lru-queue-0.1.0.tgz
https://registry.yarnpkg.com/make-iterator/-/make-iterator-1.0.1.tgz -> yarnpkg-make-iterator-1.0.1.tgz
https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz -> yarnpkg-map-cache-0.2.2.tgz
https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz -> yarnpkg-map-visit-1.0.0.tgz
https://registry.yarnpkg.com/matchdep/-/matchdep-2.0.0.tgz -> yarnpkg-matchdep-2.0.0.tgz
https://registry.yarnpkg.com/memoizee/-/memoizee-0.4.14.tgz -> yarnpkg-memoizee-0.4.14.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz -> yarnpkg-micromatch-3.1.10.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.0.1.tgz -> yarnpkg-minimatch-5.0.1.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.6.tgz -> yarnpkg-minimist-1.2.6.tgz
https://registry.yarnpkg.com/minipass/-/minipass-2.9.0.tgz -> yarnpkg-minipass-2.9.0.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-1.3.3.tgz -> yarnpkg-minizlib-1.3.3.tgz
https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz -> yarnpkg-mixin-deep-1.3.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/mocha/-/mocha-10.0.0.tgz -> yarnpkg-mocha-10.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/multimatch/-/multimatch-4.0.0.tgz -> yarnpkg-multimatch-4.0.0.tgz
https://registry.yarnpkg.com/mute-stdout/-/mute-stdout-1.0.1.tgz -> yarnpkg-mute-stdout-1.0.1.tgz
https://registry.yarnpkg.com/nan/-/nan-2.14.0.tgz -> yarnpkg-nan-2.14.0.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.3.tgz -> yarnpkg-nanoid-3.3.3.tgz
https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz -> yarnpkg-nanomatch-1.2.13.tgz
https://registry.yarnpkg.com/ncp/-/ncp-2.0.0.tgz -> yarnpkg-ncp-2.0.0.tgz
https://registry.yarnpkg.com/needle/-/needle-2.4.0.tgz -> yarnpkg-needle-2.4.0.tgz
https://registry.yarnpkg.com/next-tick/-/next-tick-1.0.0.tgz -> yarnpkg-next-tick-1.0.0.tgz
https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.12.0.tgz -> yarnpkg-node-pre-gyp-0.12.0.tgz
https://registry.yarnpkg.com/nopt/-/nopt-4.0.1.tgz -> yarnpkg-nopt-4.0.1.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.4.0.tgz -> yarnpkg-normalize-package-data-2.4.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz -> yarnpkg-normalize-path-2.1.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/now-and-later/-/now-and-later-2.0.1.tgz -> yarnpkg-now-and-later-2.0.1.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.0.5.tgz -> yarnpkg-npm-bundled-1.0.5.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-1.4.1.tgz -> yarnpkg-npm-packlist-1.4.1.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz -> yarnpkg-npmlog-4.1.2.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz -> yarnpkg-object-copy-0.1.0.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz -> yarnpkg-object-visit-1.0.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.2.tgz -> yarnpkg-object.assign-4.1.2.tgz
https://registry.yarnpkg.com/object.defaults/-/object.defaults-1.1.0.tgz -> yarnpkg-object.defaults-1.1.0.tgz
https://registry.yarnpkg.com/object.map/-/object.map-1.0.1.tgz -> yarnpkg-object.map-1.0.1.tgz
https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz -> yarnpkg-object.pick-1.3.0.tgz
https://registry.yarnpkg.com/object.reduce/-/object.reduce-1.0.1.tgz -> yarnpkg-object.reduce-1.0.1.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/ordered-read-streams/-/ordered-read-streams-1.0.1.tgz -> yarnpkg-ordered-read-streams-1.0.1.tgz
https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz -> yarnpkg-os-homedir-1.0.2.tgz
https://registry.yarnpkg.com/os-locale/-/os-locale-1.4.0.tgz -> yarnpkg-os-locale-1.4.0.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz -> yarnpkg-osenv-0.1.5.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/parse-filepath/-/parse-filepath-1.0.2.tgz -> yarnpkg-parse-filepath-1.0.2.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/parse-node-version/-/parse-node-version-1.0.1.tgz -> yarnpkg-parse-node-version-1.0.1.tgz
https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz -> yarnpkg-parse-passwd-1.0.0.tgz
https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz -> yarnpkg-pascalcase-0.1.1.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz -> yarnpkg-path-exists-2.1.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-root-regex/-/path-root-regex-0.1.2.tgz -> yarnpkg-path-root-regex-0.1.2.tgz
https://registry.yarnpkg.com/path-root/-/path-root-0.1.1.tgz -> yarnpkg-path-root-0.1.1.tgz
https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz -> yarnpkg-path-type-1.1.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/plugin-error/-/plugin-error-1.0.1.tgz -> yarnpkg-plugin-error-1.0.1.tgz
https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> yarnpkg-posix-character-classes-0.1.1.tgz
https://registry.yarnpkg.com/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz -> yarnpkg-pretty-hrtime-1.0.3.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-1.0.7.tgz -> yarnpkg-process-nextick-args-1.0.7.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz -> yarnpkg-process-nextick-args-2.0.0.tgz
https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz -> yarnpkg-pump-2.0.1.tgz
https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz -> yarnpkg-pumpify-1.5.1.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> yarnpkg-read-pkg-up-1.0.1.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz -> yarnpkg-read-pkg-1.1.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.0.34.tgz -> yarnpkg-readable-stream-1.0.34.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz -> yarnpkg-readable-stream-2.3.6.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.4.0.tgz -> yarnpkg-readable-stream-3.4.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz -> yarnpkg-readable-stream-3.6.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz -> yarnpkg-readdirp-2.2.1.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.6.2.tgz -> yarnpkg-rechoir-0.6.2.tgz
https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz -> yarnpkg-regex-not-1.0.2.tgz
https://registry.yarnpkg.com/remove-bom-buffer/-/remove-bom-buffer-3.0.0.tgz -> yarnpkg-remove-bom-buffer-3.0.0.tgz
https://registry.yarnpkg.com/remove-bom-stream/-/remove-bom-stream-1.2.0.tgz -> yarnpkg-remove-bom-stream-1.2.0.tgz
https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> yarnpkg-remove-trailing-separator-1.1.0.tgz
https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.3.tgz -> yarnpkg-repeat-element-1.1.3.tgz
https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz -> yarnpkg-repeat-string-1.6.1.tgz
https://registry.yarnpkg.com/replace-ext/-/replace-ext-1.0.0.tgz -> yarnpkg-replace-ext-1.0.0.tgz
https://registry.yarnpkg.com/replace-homedir/-/replace-homedir-1.0.0.tgz -> yarnpkg-replace-homedir-1.0.0.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-1.0.1.tgz -> yarnpkg-require-main-filename-1.0.1.tgz
https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz -> yarnpkg-resolve-dir-1.0.1.tgz
https://registry.yarnpkg.com/resolve-options/-/resolve-options-1.1.0.tgz -> yarnpkg-resolve-options-1.1.0.tgz
https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz -> yarnpkg-resolve-url-0.2.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.11.1.tgz -> yarnpkg-resolve-1.11.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.8.1.tgz -> yarnpkg-resolve-1.8.1.tgz
https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz -> yarnpkg-ret-0.1.15.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz -> yarnpkg-safe-regex-1.1.0.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/semver-greatest-satisfied-range/-/semver-greatest-satisfied-range-1.1.0.tgz -> yarnpkg-semver-greatest-satisfied-range-1.1.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.6.0.tgz -> yarnpkg-semver-5.6.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.0.tgz -> yarnpkg-semver-5.7.0.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> yarnpkg-serialize-javascript-6.0.0.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz -> yarnpkg-set-value-2.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/should-equal/-/should-equal-2.0.0.tgz -> yarnpkg-should-equal-2.0.0.tgz
https://registry.yarnpkg.com/should-format/-/should-format-3.0.3.tgz -> yarnpkg-should-format-3.0.3.tgz
https://registry.yarnpkg.com/should-type-adaptors/-/should-type-adaptors-1.1.0.tgz -> yarnpkg-should-type-adaptors-1.1.0.tgz
https://registry.yarnpkg.com/should-type/-/should-type-1.4.0.tgz -> yarnpkg-should-type-1.4.0.tgz
https://registry.yarnpkg.com/should-util/-/should-util-1.0.0.tgz -> yarnpkg-should-util-1.0.0.tgz
https://registry.yarnpkg.com/should/-/should-13.2.3.tgz -> yarnpkg-should-13.2.3.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz -> yarnpkg-signal-exit-3.0.2.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> yarnpkg-snapdragon-node-2.1.1.tgz
https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> yarnpkg-snapdragon-util-3.0.1.tgz
https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz -> yarnpkg-snapdragon-0.8.2.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.2.tgz -> yarnpkg-source-map-resolve-0.5.2.tgz
https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.0.tgz -> yarnpkg-source-map-url-0.4.0.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/sparkles/-/sparkles-1.0.1.tgz -> yarnpkg-sparkles-1.0.1.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.0.2.tgz -> yarnpkg-spdx-correct-3.0.2.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.2.0.tgz -> yarnpkg-spdx-exceptions-2.2.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.0.tgz -> yarnpkg-spdx-expression-parse-3.0.0.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.1.tgz -> yarnpkg-spdx-license-ids-3.0.1.tgz
https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz -> yarnpkg-split-string-3.1.0.tgz
https://registry.yarnpkg.com/stack-trace/-/stack-trace-0.0.10.tgz -> yarnpkg-stack-trace-0.0.10.tgz
https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz -> yarnpkg-static-extend-0.1.2.tgz
https://registry.yarnpkg.com/stream-assert/-/stream-assert-2.0.3.tgz -> yarnpkg-stream-assert-2.0.3.tgz
https://registry.yarnpkg.com/stream-exhaust/-/stream-exhaust-1.0.2.tgz -> yarnpkg-stream-exhaust-1.0.2.tgz
https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.0.tgz -> yarnpkg-stream-shift-1.0.0.tgz
https://registry.yarnpkg.com/streamfilter/-/streamfilter-3.0.0.tgz -> yarnpkg-streamfilter-3.0.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz -> yarnpkg-string-width-2.1.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz -> yarnpkg-string_decoder-0.10.31.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.2.0.tgz -> yarnpkg-string_decoder-1.2.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz -> yarnpkg-strip-ansi-4.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom-string/-/strip-bom-string-1.0.0.tgz -> yarnpkg-strip-bom-string-1.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz -> yarnpkg-strip-bom-2.0.0.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/sver-compat/-/sver-compat-1.5.0.tgz -> yarnpkg-sver-compat-1.5.0.tgz
https://registry.yarnpkg.com/tar/-/tar-4.4.19.tgz -> yarnpkg-tar-4.4.19.tgz
https://registry.yarnpkg.com/through2-filter/-/through2-filter-3.0.0.tgz -> yarnpkg-through2-filter-3.0.0.tgz
https://registry.yarnpkg.com/through2/-/through2-0.6.5.tgz -> yarnpkg-through2-0.6.5.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.3.tgz -> yarnpkg-through2-2.0.3.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/through2/-/through2-4.0.2.tgz -> yarnpkg-through2-4.0.2.tgz
https://registry.yarnpkg.com/time-stamp/-/time-stamp-1.1.0.tgz -> yarnpkg-time-stamp-1.1.0.tgz
https://registry.yarnpkg.com/timers-ext/-/timers-ext-0.1.7.tgz -> yarnpkg-timers-ext-0.1.7.tgz
https://registry.yarnpkg.com/to-absolute-glob/-/to-absolute-glob-2.0.2.tgz -> yarnpkg-to-absolute-glob-2.0.2.tgz
https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz -> yarnpkg-to-object-path-0.3.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz -> yarnpkg-to-regex-range-2.1.1.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz -> yarnpkg-to-regex-3.0.2.tgz
https://registry.yarnpkg.com/to-through/-/to-through-2.0.0.tgz -> yarnpkg-to-through-2.0.0.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> yarnpkg-unc-path-regex-0.1.2.tgz
https://registry.yarnpkg.com/undertaker-registry/-/undertaker-registry-1.0.1.tgz -> yarnpkg-undertaker-registry-1.0.1.tgz
https://registry.yarnpkg.com/undertaker/-/undertaker-1.2.1.tgz -> yarnpkg-undertaker-1.2.1.tgz
https://registry.yarnpkg.com/union-value/-/union-value-1.0.0.tgz -> yarnpkg-union-value-1.0.0.tgz
https://registry.yarnpkg.com/unique-stream/-/unique-stream-2.3.1.tgz -> yarnpkg-unique-stream-2.3.1.tgz
https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz -> yarnpkg-unset-value-1.0.0.tgz
https://registry.yarnpkg.com/upath/-/upath-1.1.2.tgz -> yarnpkg-upath-1.1.2.tgz
https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz -> yarnpkg-urix-0.1.0.tgz
https://registry.yarnpkg.com/use/-/use-3.1.1.tgz -> yarnpkg-use-3.1.1.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/v8flags/-/v8flags-3.1.3.tgz -> yarnpkg-v8flags-3.1.3.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/value-or-function/-/value-or-function-3.0.0.tgz -> yarnpkg-value-or-function-3.0.0.tgz
https://registry.yarnpkg.com/vinyl-fs/-/vinyl-fs-3.0.3.tgz -> yarnpkg-vinyl-fs-3.0.3.tgz
https://registry.yarnpkg.com/vinyl-sourcemap/-/vinyl-sourcemap-1.1.0.tgz -> yarnpkg-vinyl-sourcemap-1.1.0.tgz
https://registry.yarnpkg.com/vinyl-sourcemaps-apply/-/vinyl-sourcemaps-apply-0.2.1.tgz -> yarnpkg-vinyl-sourcemaps-apply-0.2.1.tgz
https://registry.yarnpkg.com/vinyl/-/vinyl-2.2.0.tgz -> yarnpkg-vinyl-2.2.0.tgz
https://registry.yarnpkg.com/which-module/-/which-module-1.0.0.tgz -> yarnpkg-which-module-1.0.0.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.3.tgz -> yarnpkg-wide-align-1.1.3.tgz
https://registry.yarnpkg.com/workerpool/-/workerpool-6.2.1.tgz -> yarnpkg-workerpool-6.2.1.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> yarnpkg-wrap-ansi-2.1.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz -> yarnpkg-xtend-4.0.1.tgz
https://registry.yarnpkg.com/y18n/-/y18n-3.2.2.tgz -> yarnpkg-y18n-3.2.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz -> yarnpkg-yallist-3.1.1.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-13.1.2.tgz -> yarnpkg-yargs-parser-13.1.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.4.tgz -> yarnpkg-yargs-parser-20.2.4.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> yarnpkg-yargs-unparser-2.0.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-7.1.0.tgz -> yarnpkg-yargs-7.1.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
ANT_PV="1.10.11"
ARGS4J_PV="2.33"
COURSIER_PV="2.0.16"
ERROR_PRONE_ANNOTATIONS_PV="2.15.0"
FAILUREACCESS_PV="1.0.1"
GSON_PV="2.9.1"
GUAVA_PV="31.0.1"
JAVA_DIFF_UTILS_PV="4.0"
JAVA_TOOLS_PV="11.9"
JIMFS_PV="1.2"
JQ_PV="1.6"
JSPECIFY_PV="0.2.0"
PROTOBUF_JAVA_PV="3.21.12"
RE2J_PV="1.3"
RULES_JAVA_PV="5.1.0"
RULES_JVM_EXTERNAL_PV="4.2"
RULES_PROTO_PV="4.0.0"
TRUTH_LITEPROTO_EXTENSION_PV="1.1"
TRUTH_PROTO_EXTENSION_PV="1.1"
ZULU_PV="11.56.19-ca-jdk11.0.15"
EGIT_BAZEL_COMMON_COMMIT="aaa4d801588f7744c6f4428e4f133f26b8518f42"
EGIT_BAZEL_JAR_JAR_COMMIT="171f268569384c57c19474b04aebe574d85fde0d"
EGIT_RULES_CC_COMMIT="b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e"
EGIT_RULES_PROTO_COMMIT="7e4afce6fe62dbff0a4a03450143146f9f2d7488"
bazel_external_uris="
https://cdn.azul.com/zulu/bin/zulu${ZULU_PV}-linux_x64.tar.gz
https://github.com/bazelbuild/rules_jvm_external/archive/${RULES_JVM_EXTERNAL_PV}.zip -> rules_jvm_external-${RULES_JVM_EXTERNAL_PV}.zip
https://github.com/coursier/coursier/releases/download/v${COURSIER_PV}/coursier.jar -> coursier-${COURSIER_PV}.jar
https://github.com/google/bazel-common/archive/${EGIT_BAZEL_COMMON_COMMIT}.zip -> bazel-common-${EGIT_BAZEL_COMMON_COMMIT}.zip
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools-v${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools_linux-v${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/refs/tags/${RULES_PROTO_PV}.tar.gz -> rules_proto-${RULES_PROTO_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_java/releases/download/${RULES_JAVA_PV}/rules_java-${RULES_JAVA_PV}.tar.gz -> rules_java-${RULES_JAVA_PV}.tar.gz
https://github.com/johnynek/bazel_jar_jar/archive/${EGIT_BAZEL_JAR_JAR_COMMIT}.zip -> bazel_jar_jar-${EGIT_BAZEL_JAR_JAR_COMMIT}.zip
https://github.com/stedolan/jq/releases/download/jq-${JQ_PV}/jq-linux64 -> jq-${JQ_PV}-linux64
https://github.com/stedolan/jq/releases/download/jq-${JQ_PV}/jq-osx-amd64 -> jq-${JQ_PV}-osx-amd64
https://github.com/stedolan/jq/releases/download/jq-${JQ_PV}/jq-win64.exe -> jq-${JQ_PV}-win64-amd64
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.jar
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.jar
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.jar
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_ANNOTATIONS_PV}/error_prone_annotations-${ERROR_PRONE_ANNOTATIONS_PV}.jar
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.jar
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA_PV}-jre/guava-${GUAVA_PV}-jre.jar
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.jar
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_PV}/protobuf-java-${PROTOBUF_JAVA_PV}.pom
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.jar
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.jar
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PROTO_EXTENSION_PV}/truth-proto-extension-${TRUTH_PROTO_EXTENSION_PV}.jar
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.jar
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.jar
"
SRC_URI="
$(graalvm_gen_base_uris)
$(graalvm_gen_native_image_uris)
${bazel_external_uris}
${YARN_EXTERNAL_URIS}
https://github.com/google/closure-compiler-npm/archive/v${PV}.tar.gz
	-> ${FN_DEST}
https://github.com/google/closure-compiler/archive/v${CC_PV}.tar.gz
	-> ${FN_DEST2}
"
SRC_URI+="
	$(gen_bazelisk_src_uris)
"
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${CC_PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/closure-compiler-npm-20230228.0.0-maven_install-m2Local.patch"
)

_set_check_reqs_requirements() {
	CHECKREQS_DISK_BUILD="1688M"
	CHECKREQS_DISK_USR="315M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find \
		/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find \
		/opt/openjdk-bin-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/opt/openjdk-bin-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
eerror
eerror "dev-java/openjdk:${JAVA_SLOT} or dev-java/openjdk-bin:${JAVA_SLOT} must be installed"
eerror
		die
	fi
}

pkg_setup() {
	if ! [[ "${BAZEL_LD_PRELOAD_IGNORED_RISKS}" =~ ("allow"|"accept") ]] ; then
# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe reported by Bazel.
eerror
eerror "Precaution taken..."
eerror
eerror "LD_PRELOAD gets ignored by a build tool which could bypass the"
eerror "ebuild sandbox.  Set one of the following as a per-package"
eerror "environment variable:"
eerror
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"allow\"     # to continue and consent to accepting risks"
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"deny\"      # to stop (default)"
eerror
		die
	fi

	setup_openjdk

	# Bug
	unset ANDROID_HOME
	unset ANDROID_NDK_HOME
	unset ANDROID_SDK_HOME

einfo "JAVA_HOME:\t${JAVA_HOME}"
einfo "PATH:\t${PATH}"

	# java-pkg_init

	# the eclass/eselect system is broken
	X_JAVA_SLOT=$(best_version "dev-java/openjdk-bin:${JAVA_SLOT}" \
		| sed \
			-e "s|dev-java/openjdk-bin-||g" \
			-e "s|-r[0-9]$||g")
	export JAVA_HOME="/opt/openjdk-bin-${X_JAVA_SLOT}" # basedir

einfo "JAVA_HOME:\t${JAVA_HOME}"
	if [[ -n "${JAVA_HOME}" && -f "${JAVA_HOME}/bin/java" ]] ; then
		export JAVA="${JAVA_HOME}/bin/java"
	else
eerror
eerror "JAVA_HOME is set to ${JAVA_HOME} but cannot locate ${JAVA_HOME}/bin/java."
eerror
		die
	fi

	if ver_test ${X_JAVA_SLOT} -lt ${JAVA_SLOT} ; then
eerror
eerror "You must have OpenJDK >= ${JAVA_SLOT}.  Best is ${X_JAVA_SLOT}."
eerror
		die
	fi

	if ! which mvn 2>/dev/null 1>/dev/null ; then
eerror
eerror "Missing mvn.  Install dev-java/maven-bin"
eerror
		die
	fi

	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
:;#		die
	fi

	# Do not make conditional.
	yarn_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if [[ ! -e "/usr/include/node/node_version.h" ]] ; then
eerror
eerror "Use eselect nodejs to fix missing header location."
eerror
		die
	fi
}

src_unpack() {
eerror "Ebuild under maintenance."
eerror "TODO:  bazel offline install."
eerror "Testing yarn offline install."
:;#die
	unpack ${FN_DEST}
	unpack ${FN_DEST2}

	bazel_load_distfiles "${bazel_external_uris}"

	if use closure_compiler_native ; then
		unpack $(graalvm_get_base_tarball_name)
		graalvm_attach_graalvm
	fi

	# Do not make this section conditional.
	yarn_src_unpack

	rm -rf "${S}/compiler" || die
	mv \
		"${S_CLOSURE_COMPILER}" \
		"${S}/compiler" \
		|| die

	if ! use closure_compiler_java ; then
einfo "Removing Java support"
		rm -rf "${S}/packages/google-closure-compiler-java" || die
	fi
	if ! use closure_compiler_js ; then
einfo "Removing JavaScript support"
		rm -rf "${S}/packages/google-closure-compiler-js" || die
	fi
	if ! use closure_compiler_native ; then
einfo "Removing native binary support"
		rm -rf "${S}/packages/google-closure-compiler-linux" || die
	fi
	if ! use closure_compiler_nodejs ; then
einfo "Removing Node.js support"
		rm -rf "${S}/packages/google-closure-compiler" || die
	fi
einfo "Removing unsupported platforms"
	rm -rf "${S}/packages/google-closure-compiler-osx" || die
	rm -rf "${S}/packages/google-closure-compiler-windows" || die
	# Fetches and builds the closure compiler here.
	cd "${S}" || die

	local abi
	for abi in ${BAZELISK_ABIS} ; do
		mkdir -p "${WORKDIR}/bazelisk" || die
		if use ${abi} ; then
			cp $(realpath \
				"${DISTDIR}/bazelisk-linux-${abi}-${BAZELISK_PV}") \
				"${WORKDIR}/bazelisk/bazelisk" \
				|| die
			chmod +x "${WORKDIR}/bazelisk/bazelisk" || die
		fi
	done
	export PATH="${WORKDIR}/bazelisk:${PATH}"

	# Prevent error
einfo "Adding .git folder"
	git init || die
	git add . || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die

	if grep -e "Read timed out" "${T}/build.log" ; then
eerror
eerror "Detected download failure.  Re-emerge."
eerror
		die
	fi
	if grep -e "Error downloading" "${T}/build.log" ; then
eerror
eerror "Detected download failure.  Re-emerge."
eerror
		die
	fi
	if grep -e "Build did NOT complete successfully" "${T}/build.log" ; then
eerror
eerror "Detected build failure.  Re-emerge."
eerror
		die
	fi
	if grep -e "ERROR:" "${T}/build.log" ; then
eerror
eerror "Detected a failure.  Re-emerge."
eerror
		die
	fi
	if grep -e "exitCode:" "${T}/build.log" ; then
eerror
eerror "Detected a failure.  Re-emerge."
eerror
		die
	fi
	if grep -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected a failure.  Re-emerge."
eerror
		die
	fi
	if grep -F -e "cb() never called!" "${T}/build.log" ; then
eerror
eerror "Detected a failure.  Re-emerge."
eerror
		die
	fi
}

get_bazel() {
	# https://github.com/bazelbuild/bazel/releases
	local bazel_pv=$(bazel --version \
		| cut -f 2 -d " " \
		| sed -e "s|-||g")
	if use kernel_linux && use amd64 ; then
		local dest="${HOME}/.cache/bazelisk/downloads/bazelbuild/bazel-${BAZEL_PV}-linux-x86_64/bin"
		mkdir -p "${dest}"
		ln -s $(which bazel) "${dest}/bazel" || die
	elif use kernel_linux && use arm64 ; then
		local dest="${HOME}/.cache/bazelisk/downloads/bazelbuild/bazel-${BAZEL_PV}-linux-arm64/bin"
		mkdir -p "${dest}"
		ln -s $(which bazel) "${dest}/bazel" || die
	else
eerror
eerror "Arch is not supported in the ebuild level."
eerror "Fork ebuild locally."
eerror
		die
	fi
}

src_prepare() {
	default
	if use closure_compiler_native || use closure_compiler_java ; then
		bazel_setup_bazelrc
	fi
}

setup_bazel_slot() {
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local slot
	for slot in 5 ; do
		if has_version "dev-util/bazel:${slot}" ; then
einfo "Detected dev-util/bazel:${slot} (multislot)"
			ln -sf \
				"${ESYSROOT}/usr/bin/bazel-${slot}" \
				"${WORKDIR}/bin/bazel" \
				|| die
			has_multislot_bazel=1
			bazel --version || die
			break
		fi
	done
	if (( ${has_multislot_bazel} == 0 )) ; then
ewarn
ewarn "Using unslotted bazel.  Use the one from the oiledmachine-overlay"
ewarn "instead or downgrade to bazel == 5"
ewarn
	fi

	echo 'build --noshow_progress' >> "${T}/bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${T}/bazelrc" || die # Increase verbosity

	# There is a bug that keeps popping up when building java packages:
	# /var/lib/portage/home/ should be /var/tmp/portage/dev-util/closure-compiler-npm-20230228.0.0/homedir/
	#echo "bazel run --define \"maven_repo=file://$HOME/.m2/repository\"" >> "${T}/bazelrc" || die # Does not fix

	cat "${T}/bazelrc" >> "${S}/compiler/.bazelrc" || die

	if use closure_compiler_native || use closure_compiler_java ; then
einfo "HOME:\t${HOME}"
		export USER_HOME="${HOME}"
		mkdir -p "${HOME}/.m2/repository/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_PV}" || die
		cat "${DISTDIR}/protobuf-java-3.21.12.pom" > "${HOME}/.m2/repository/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_PV}/protobuf-java-${PROTOBUF_JAVA_PV}.pom" || die
	fi
}

src_configure() {
	get_bazel
	if use closure_compiler_native || use closure_compiler_java ; then
		setup_bazel_slot
	fi
}

src_compile() {
	# Do not make conditional.
	yarn_src_compile
}

src_install() {
	pushd packages || die

	if use closure_compiler_java ; then
		local d_src="google-${MY_PN}-java"
		cp -a "${d_src}/compiler.jar" \
			"${T}/${MY_PN}.jar" || die
		insinto /usr/share/${MY_PN}/lib
		doins "${T}/${MY_PN}.jar"
		exeinto /usr/bin
		doexe "${FILESDIR}/${MY_PN}-java"
		cp -f "${d_src}/readme.md" \
			"${T}/native-readme.md" || die
		docinto readmes
		dodoc "${T}/native-readme.md"
	fi

	if use closure_compiler_js ; then
		insinto /opt/share/${MY_PN}
		local d_src="google-${MY_PN}-js"
		doins "${d_src}/jscomp.js"
		cp -f "${d_src}/readme.md" \
			"${T}/native-readme.md" || die
		docinto readmes
		dodoc "${T}/native-readme.md"
	fi

	if use closure_compiler_nodejs ; then
		export YARN_INSTALL_PATH="/opt/${MY_PN}"
		insinto "${YARN_INSTALL_PATH}"
		pushd ../ || die
		doins -r node_modules package.json yarn.lock
		popd
		insinto "${YARN_INSTALL_PATH}/packages"
		local d_prefix="google-${MY_PN}"
		doins -r "${d_prefix}"
		doins -r "${d_prefix}-java"
		fperms 0755 "${YARN_INSTALL_PATH}/packages/${d_prefix}/cli.js"
		exeinto /usr/bin
		cp -f \
			"${FILESDIR}/${MY_PN}-node" \
			"${T}/${MY_PN}-node" \
			|| die
		sed -i \
			-e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${NODE_SLOT}|${NODE_SLOT}|g" \
			-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
			"${T}/${MY_PN}-node" \
			|| die
		doexe "${T}/${MY_PN}-node"
		local dir_path
		for dir_path in $(find "${ED}/${YARN_INSTALL_PATH}" \
				-name ".bin" -type d) ; do
			local file_abs_path
			for file_abs_path in $(find "${dir_path}") ; do
				chmod 0755 $(realpath "${file_abs_path}") \
					|| die
			done
		done
	fi

	if use closure_compiler_native ; then
		exeinto /usr/bin
		local d_src="google-${MY_PN}-linux"
		mv "${d_src}"/{compiler,${MY_PN}}
		doexe "${d_src}/${MY_PN}"
		cp -f "${d_src}/readme.md" \
			"${T}/native-readme.md" || die
		docinto readmes
		dodoc "${T}/native-readme.md"
	fi
	popd
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	if use closure_compiler_nodejs ; then
		npm-secaudit_src_install_finalize
	fi
}

pkg_postinst() {
	if use closure_compiler_nodejs ; then
		npm-secaudit_pkg_postinst
	fi
	if use closure_compiler_nodejs || use closure_compiler_java; then
ewarn
ewarn "You need to switch user/system java-vm to >= 11 before using ${PN}"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
