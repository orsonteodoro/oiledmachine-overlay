# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# TODO:  complete bazel offline install.
# All builds require npm/node.

# For the node version, see
# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/packages/google-closure-compiler/package.json#L67
# For dependencies, see
# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml
# The virtual/jdk not virtual/jre must be in DEPENDs for the eclass not to be stupid.

# You need two slotted OpenJDKs to build this.
# You need OpenJDK == 11 for running bazel.
# You need OpenJDK == 11 to build closure-compiler.

# The closure-compiler-npm/compiler/BUILD.bazel indicates 11 but the CI uses 17.  Using 11 seems to work.

export COMPILER_NIGHTLY="false"
export FORCE_COLOR=1

# For constants without links, the versions are obtained by console inspection.
# https://github.com/google/closure-templates/blob/master/maven_install.json may expose the pom/jar dependency tree.
ANT_PV="1.10.11"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L21
ARGS4J_PV="2.33"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L9
ASM_PV="9.0"									# https://github.com/google/truth/blob/release_1_1/pom.xml#L160
AUTO_COMMON_PV="1.2.2"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L157
AUTO_SERVICE_PV="1.1.1"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L170
AUTO_VALUE_1_7_PV="1.7.4"							# https://github.com/google/truth/blob/release_1_1/pom.xml#L26
AUTO_VALUE_1_10_PV="1.10.4"							# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L187 https://github.com/google/truth/blob/v1.4.0/pom.xml#L17
BAZELISK_PV="1.19.0" # From CI logs for "Build Compiler"
BAZELISK_ABIS=(
	"amd64"
	"arm64"
)
BAZEL_PV="5.3.0"								# https://github.com/google/closure-compiler/blob/v20240317/.bazelversion
BAZEL_SLOT="${BAZEL_PV%.*}"
BAZEL_SKYLIB_PV="1.4.2"								# https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/repositories.bzl#L17
CHECKER_QUAL_PV="3.33.0"							# https://github.com/google/guava/blob/v32.1.2/pom.xml#L304
CLOSURE_COMPILER_MAJOR_VER=$(ver_cut 1 "${PV}")
COURSIER_PV="2.1.8"								# https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/MODULE.bazel#L68
EGIT_BAZEL_COMMON_COMMIT="65f295afec03cce3807df5b06ef42bf8e46df4e4"		# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L57
EGIT_BAZEL_JAR_JAR_COMMIT="171f268569384c57c19474b04aebe574d85fde0d"		# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L74
EGIT_RULES_CC_COMMIT="b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e"			# https://github.com/bazelbuild/rules_proto/blob/4.0.0/proto/private/dependencies.bzl#L102 with https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L35
EGIT_RULES_PROTO_COMMIT="7e4afce6fe62dbff0a4a03450143146f9f2d7488"		# https://github.com/bazelbuild/buildtools/blob/5.1.0/WORKSPACE with https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/MODULE.bazel#L94 ; 2 tarballs needed from this project
EGIT_RULES_JVM_EXTERNAL_COMMIT="77c3538b33cf195879b337fd48c480b77815b9a0"	# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L18
ERROR_PRONE_2_15_PV="2.15.0"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L11
ERROR_PRONE_2_18_PV="2.18.0"							# https://github.com/google/guava/blob/v32.1.2/pom.xml#L309
FAILUREACCESS_PV="1.0.1"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L12
FN_DEST="${PN}-${PV}.tar.gz"
FN_DEST2="${PN%-*}-${PV}.tar.gz"
GRAALVM_JAVA_PV="17"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L96
GRAALVM_PV="22.3.2"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L95
GSON_PV="2.9.1"									# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L10
GUAVA26_PV="26.0"								# https://github.com/google/guava/blob/v32.1.2/futures/failureaccess/pom.xml#L8
GUAVA32_PV="32.1.2"								# https://github.com/google/closure-compiler/blob/v20240317/license_check/maven_artifacts.bzl#L8
GUAVA33_PV="33.0.0"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L13
GUAVA_BETA_CHECKER_PV="1.0"							# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L133 https://github.com/google/jimfs/blob/v1.2/pom.xml#L229
HAMCREST_PV="1.3"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L273 https://github.com/junit-team/junit4/blob/r4.13.2/pom.xml#L98
J2OBJC_PV="2.8"									# https://github.com/google/guava/blob/v32.1.2/pom.xml#L314
JAVA_SLOT_BAZEL="11"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L26
JAVA_SLOT_CLOSURE_COMPILER="11"							# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L26
JAVA_DIFF_UTILS_PV="4.12"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L20
JAVA_TOOLS_PV="11.11"								# https://github.com/bazelbuild/rules_java/blob/5.4.1/java/repositories.bzl#L28
JIMFS_PV="1.2"									# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L15
JSPECIFY_PV="0.2.0"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L22
JSR256_PV="1.0"									# https://github.com/google/gson/blob/gson-parent-2.9.1/extras/pom.xml#L35
JSR305_PV="3.0.2"								# https://github.com/google/guava/blob/v32.1.2/pom.xml#L299
JUNIT_PV="4.13.2"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L232 https://github.com/google/guava/blob/v33.0.0/guava-testlib/pom.xml#L42 https://github.com/google/truth/blob/v1.4.0/pom.xml#L81
LISTENABLEFUTURE_PV="9999.0"							# https://github.com/google/guava/blob/v32.1.3/guava/module.json#L40
MY_PN="closure-compiler"
MAVEN_TARBALLS=(
"${HOME}/.m2/repository/args4j/args4j/2.33/args4j-2.33.jar"
"${HOME}/.m2/repository/io/github/java-diff-utils/java-diff-utils/4.12/java-diff-utils-4.12.jar"
"${HOME}/.m2/repository/org/apache/ant/ant/1.10.11/ant-1.10.11.jar"
"${HOME}/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar"
"${HOME}/.m2/repository/org/jspecify/jspecify/0.2.0/jspecify-0.2.0.jar"
"${HOME}/.m2/repository/com/google/j2objc/j2objc-annotations/2.8/j2objc-annotations-2.8.jar"
"${HOME}/.m2/repository/com/google/guava/guava-testlib/32.1.2-jre/guava-testlib-32.1.2-jre.j"ar
"${HOME}/.m2/repository/com/google/guava/guava/32.1.2-jre/guava-32.1.2-jre.jar"
"${HOME}/.m2/repository/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar"
"${HOME}/.m2/repository/com/google/code/gson/gson/2.9.1/gson-2.9.1.jar"
"${HOME}/.m2/repository/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar"
"${HOME}/.m2/repository/com/google/protobuf/protobuf-java/3.21.12/protobuf-java-3.21.12.jar"
"${HOME}/.m2/repository/com/google/re2j/re2j/1.3/re2j-1.3.jar"
"${HOME}/.m2/repository/com/google/jimfs/jimfs/1.2/jimfs-1.2.jar"
"${HOME}/.m2/repository/com/google/errorprone/error_prone_annotations/2.15.0/error_prone_annotations-2.15.0.jar"
"${HOME}/.m2/repository/com/google/truth/extensions/truth-proto-extension/1.1/truth-proto-extension-1.1.jar"
"${HOME}/.m2/repository/com/google/truth/extensions/truth-liteproto-extension/1.4.0/truth-liteproto-extension-1.4.0.jar"
)
NODE_ENV="development"
NODE_VERSION=14 # Upstream uses 14 on linux but others 16, 18
#OPENJDK_PV="17.0.10"
OPENJDK_PV="11"
OSS7_PV="7"									# https://github.com/google/guava-beta-checker/blob/v1.0/pom.xml#L24
OSS9_PV="9"									# https://github.com/google/guava/blob/v33.0.0/guava-bom/pom.xml#L17
OW2_PV="1.5"									# Exposed in asm-9.0.pom L78
POM_PV="14"									# Exposed in args4j-site-2.33.pom L6
PROTOBUF_JAVA_3_17_PV="3.17.0"							# https://github.com/bazelbuild/rules_proto/blob/4.0.0/proto/private/dependencies.bzl#L29 with https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L35
PROTOBUF_JAVA_3_21_PV="3.21.12"							# https://github.com/google/closure-compiler/blob/v20240317/license_check/maven_artifacts.bzl#L11
RE2J_PV="1.3"									# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L17
RULES_JAVA_PV="5.4.1"								# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L8
RULES_PROTO_PV="4.0.0"								# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L35     ; 2 tarballs needed from this project
TRUTH_LITEPROTO_EXTENSION_PV="1.4.0"						# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L18
TRUTH_PV="1.1"									# https://github.com/google/closure-compiler/blob/v20240317/license_check/maven_artifacts.bzl#L14
ZULU11_PV="11.56.19-ca-jdk11.0.15"						# https://github.com/bazelbuild/rules_java/blob/5.4.1/java/repositories.bzl#L172
ZULU17_PV="17.32.13-ca-jdk17.0.2"						# https://github.com/bazelbuild/rules_java/blob/5.4.1/java/repositories.bzl#L434

inherit bazel check-reqs java-pkg-opt-2 graalvm npm yarn

# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/closure-compiler-npm-20240317.0.0/work/closure-compiler-npm-20240317.0.0/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@gulp-sourcemaps/identity-map/-/identity-map-1.0.2.tgz -> npmpkg-@gulp-sourcemaps-identity-map-1.0.2.tgz
https://registry.npmjs.org/@gulp-sourcemaps/map-sources/-/map-sources-1.0.0.tgz -> npmpkg-@gulp-sourcemaps-map-sources-1.0.0.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.3.tgz -> npmpkg-@types-minimatch-3.0.3.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-1.1.0.tgz -> npmpkg-ansi-colors-1.1.0.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.1.tgz -> npmpkg-ansi-colors-4.1.1.tgz
https://registry.npmjs.org/ansi-gray/-/ansi-gray-0.1.1.tgz -> npmpkg-ansi-gray-0.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/ansi-wrap/-/ansi-wrap-0.1.0.tgz -> npmpkg-ansi-wrap-0.1.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.2.tgz -> npmpkg-anymatch-3.1.2.tgz
https://registry.npmjs.org/append-buffer/-/append-buffer-1.0.2.tgz -> npmpkg-append-buffer-1.0.2.tgz
https://registry.npmjs.org/archy/-/archy-1.0.0.tgz -> npmpkg-archy-1.0.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-filter/-/arr-filter-1.1.2.tgz -> npmpkg-arr-filter-1.1.2.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-map/-/arr-map-2.0.2.tgz -> npmpkg-arr-map-2.0.2.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-differ/-/array-differ-3.0.0.tgz -> npmpkg-array-differ-3.0.0.tgz
https://registry.npmjs.org/array-each/-/array-each-1.0.1.tgz -> npmpkg-array-each-1.0.1.tgz
https://registry.npmjs.org/array-initial/-/array-initial-1.1.0.tgz -> npmpkg-array-initial-1.1.0.tgz
https://registry.npmjs.org/array-last/-/array-last-1.3.0.tgz -> npmpkg-array-last-1.3.0.tgz
https://registry.npmjs.org/array-slice/-/array-slice-1.1.0.tgz -> npmpkg-array-slice-1.1.0.tgz
https://registry.npmjs.org/array-sort/-/array-sort-1.0.0.tgz -> npmpkg-array-sort-1.0.0.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/arrify/-/arrify-2.0.1.tgz -> npmpkg-arrify-2.0.1.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async-done/-/async-done-1.3.1.tgz -> npmpkg-async-done-1.3.1.tgz
https://registry.npmjs.org/async-done/-/async-done-2.0.0.tgz -> npmpkg-async-done-2.0.0.tgz
https://registry.npmjs.org/async-settle/-/async-settle-1.0.0.tgz -> npmpkg-async-settle-1.0.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/bach/-/bach-1.2.0.tgz -> npmpkg-bach-1.2.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/browser-stdout/-/browser-stdout-1.3.1.tgz -> npmpkg-browser-stdout-1.3.1.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.0.tgz -> npmpkg-buffer-equal-1.0.0.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.1.tgz -> npmpkg-buffer-from-1.1.1.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.1.tgz -> npmpkg-builtin-modules-1.1.1.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-3.0.0.tgz -> npmpkg-camelcase-3.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/cliui/-/cliui-3.2.0.tgz -> npmpkg-cliui-3.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/clone-buffer/-/clone-buffer-1.0.0.tgz -> npmpkg-clone-buffer-1.0.0.tgz
https://registry.npmjs.org/clone-stats/-/clone-stats-1.0.0.tgz -> npmpkg-clone-stats-1.0.0.tgz
https://registry.npmjs.org/clone/-/clone-2.1.2.tgz -> npmpkg-clone-2.1.2.tgz
https://registry.npmjs.org/cloneable-readable/-/cloneable-readable-1.1.2.tgz -> npmpkg-cloneable-readable-1.1.2.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/collection-map/-/collection-map-1.0.0.tgz -> npmpkg-collection-map-1.0.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz -> npmpkg-color-support-1.1.3.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.2.1.tgz -> npmpkg-component-emitter-1.2.1.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.6.0.tgz -> npmpkg-convert-source-map-1.6.0.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/copy-props/-/copy-props-2.0.5.tgz -> npmpkg-copy-props-2.0.5.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/css/-/css-2.2.4.tgz -> npmpkg-css-2.2.4.tgz
https://registry.npmjs.org/d/-/d-1.0.1.tgz -> npmpkg-d-1.0.1.tgz
https://registry.npmjs.org/dargs/-/dargs-7.0.0.tgz -> npmpkg-dargs-7.0.0.tgz
https://registry.npmjs.org/debug-fabulous/-/debug-fabulous-1.1.0.tgz -> npmpkg-debug-fabulous-1.1.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decamelize/-/decamelize-4.0.0.tgz -> npmpkg-decamelize-4.0.0.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/default-compare/-/default-compare-1.0.0.tgz -> npmpkg-default-compare-1.0.0.tgz
https://registry.npmjs.org/default-resolution/-/default-resolution-2.0.0.tgz -> npmpkg-default-resolution-2.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.3.tgz -> npmpkg-define-properties-1.1.3.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/detect-file/-/detect-file-1.0.0.tgz -> npmpkg-detect-file-1.0.0.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-2.1.0.tgz -> npmpkg-detect-newline-2.1.0.tgz
https://registry.npmjs.org/diff/-/diff-5.0.0.tgz -> npmpkg-diff-5.0.0.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.6.1.tgz -> npmpkg-duplexify-3.6.1.tgz
https://registry.npmjs.org/each-props/-/each-props-1.3.2.tgz -> npmpkg-each-props-1.3.2.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.63.tgz -> npmpkg-es5-ext-0.10.63.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.3.tgz -> npmpkg-es6-symbol-3.1.3.tgz
https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.2.tgz -> npmpkg-es6-weak-map-2.0.2.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/esniff/-/esniff-2.0.1.tgz -> npmpkg-esniff-2.0.1.tgz
https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.5.tgz -> npmpkg-event-emitter-0.3.5.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/expand-tilde/-/expand-tilde-2.0.2.tgz -> npmpkg-expand-tilde-2.0.2.tgz
https://registry.npmjs.org/ext/-/ext-1.7.0.tgz -> npmpkg-ext-1.7.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/fancy-log/-/fancy-log-1.3.3.tgz -> npmpkg-fancy-log-1.3.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-2.0.0.tgz -> npmpkg-findup-sync-2.0.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-3.0.0.tgz -> npmpkg-findup-sync-3.0.0.tgz
https://registry.npmjs.org/fined/-/fined-1.1.0.tgz -> npmpkg-fined-1.1.0.tgz
https://registry.npmjs.org/flagged-respawn/-/flagged-respawn-1.0.0.tgz -> npmpkg-flagged-respawn-1.0.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> npmpkg-flush-write-stream-1.1.1.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-1.0.0.tgz -> npmpkg-for-own-1.0.0.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fs-mkdirp-stream/-/fs-mkdirp-stream-1.0.0.tgz -> npmpkg-fs-mkdirp-stream-1.0.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-1.0.3.tgz -> npmpkg-get-caller-file-1.0.3.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.1.1.tgz -> npmpkg-get-intrinsic-1.1.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob-stream/-/glob-stream-6.1.0.tgz -> npmpkg-glob-stream-6.1.0.tgz
https://registry.npmjs.org/glob-watcher/-/glob-watcher-6.0.0.tgz -> npmpkg-glob-watcher-6.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.0.tgz -> npmpkg-glob-7.2.0.tgz
https://registry.npmjs.org/global-modules/-/global-modules-1.0.0.tgz -> npmpkg-global-modules-1.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-1.0.2.tgz -> npmpkg-global-prefix-1.0.2.tgz
https://registry.npmjs.org/glogg/-/glogg-1.0.1.tgz -> npmpkg-glogg-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.3.tgz -> npmpkg-graceful-fs-4.2.3.tgz
https://registry.npmjs.org/graphlib/-/graphlib-2.1.8.tgz -> npmpkg-graphlib-2.1.8.tgz
https://registry.npmjs.org/gulp-cli/-/gulp-cli-2.2.0.tgz -> npmpkg-gulp-cli-2.2.0.tgz
https://registry.npmjs.org/gulp-filter/-/gulp-filter-6.0.0.tgz -> npmpkg-gulp-filter-6.0.0.tgz
https://registry.npmjs.org/gulp-mocha/-/gulp-mocha-8.0.0.tgz -> npmpkg-gulp-mocha-8.0.0.tgz
https://registry.npmjs.org/gulp-sourcemaps/-/gulp-sourcemaps-2.6.5.tgz -> npmpkg-gulp-sourcemaps-2.6.5.tgz
https://registry.npmjs.org/gulp/-/gulp-4.0.2.tgz -> npmpkg-gulp-4.0.2.tgz
https://registry.npmjs.org/gulplog/-/gulplog-1.0.0.tgz -> npmpkg-gulplog-1.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.2.tgz -> npmpkg-has-symbols-1.0.2.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.1.tgz -> npmpkg-homedir-polyfill-1.0.1.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.7.tgz -> npmpkg-ini-1.3.7.tgz
https://registry.npmjs.org/interpret/-/interpret-1.2.0.tgz -> npmpkg-interpret-1.2.0.tgz
https://registry.npmjs.org/invert-kv/-/invert-kv-1.0.0.tgz -> npmpkg-invert-kv-1.0.0.tgz
https://registry.npmjs.org/is-absolute/-/is-absolute-1.0.0.tgz -> npmpkg-is-absolute-1.0.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-1.0.0.tgz -> npmpkg-is-builtin-module-1.0.0.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-negated-glob/-/is-negated-glob-1.0.0.tgz -> npmpkg-is-negated-glob-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> npmpkg-is-plain-obj-2.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-promise/-/is-promise-2.1.0.tgz -> npmpkg-is-promise-2.1.0.tgz
https://registry.npmjs.org/is-relative/-/is-relative-1.0.0.tgz -> npmpkg-is-relative-1.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-unc-path/-/is-unc-path-1.0.0.tgz -> npmpkg-is-unc-path-1.0.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-valid-glob/-/is-valid-glob-1.0.0.tgz -> npmpkg-is-valid-glob-1.0.0.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/last-run/-/last-run-1.1.1.tgz -> npmpkg-last-run-1.1.1.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz -> npmpkg-lazystream-1.0.0.tgz
https://registry.npmjs.org/lcid/-/lcid-1.0.0.tgz -> npmpkg-lcid-1.0.0.tgz
https://registry.npmjs.org/lead/-/lead-1.0.0.tgz -> npmpkg-lead-1.0.0.tgz
https://registry.npmjs.org/liftoff/-/liftoff-3.1.0.tgz -> npmpkg-liftoff-3.1.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/lru-queue/-/lru-queue-0.1.0.tgz -> npmpkg-lru-queue-0.1.0.tgz
https://registry.npmjs.org/make-iterator/-/make-iterator-1.0.1.tgz -> npmpkg-make-iterator-1.0.1.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matchdep/-/matchdep-2.0.0.tgz -> npmpkg-matchdep-2.0.0.tgz
https://registry.npmjs.org/memoizee/-/memoizee-0.4.14.tgz -> npmpkg-memoizee-0.4.14.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.0.1.tgz -> npmpkg-minimatch-5.0.1.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/mocha/-/mocha-10.2.0.tgz -> npmpkg-mocha-10.2.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/multimatch/-/multimatch-4.0.0.tgz -> npmpkg-multimatch-4.0.0.tgz
https://registry.npmjs.org/mute-stdout/-/mute-stdout-1.0.1.tgz -> npmpkg-mute-stdout-1.0.1.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.3.tgz -> npmpkg-nanoid-3.3.3.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/ncp/-/ncp-2.0.0.tgz -> npmpkg-ncp-2.0.0.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.1.0.tgz -> npmpkg-next-tick-1.1.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.4.0.tgz -> npmpkg-normalize-package-data-2.4.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/now-and-later/-/now-and-later-2.0.1.tgz -> npmpkg-now-and-later-2.0.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.2.tgz -> npmpkg-object.assign-4.1.2.tgz
https://registry.npmjs.org/object.defaults/-/object.defaults-1.1.0.tgz -> npmpkg-object.defaults-1.1.0.tgz
https://registry.npmjs.org/object.map/-/object.map-1.0.1.tgz -> npmpkg-object.map-1.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/object.reduce/-/object.reduce-1.0.1.tgz -> npmpkg-object.reduce-1.0.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/ordered-read-streams/-/ordered-read-streams-1.0.1.tgz -> npmpkg-ordered-read-streams-1.0.1.tgz
https://registry.npmjs.org/os-locale/-/os-locale-1.4.0.tgz -> npmpkg-os-locale-1.4.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/parse-filepath/-/parse-filepath-1.0.2.tgz -> npmpkg-parse-filepath-1.0.2.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/parse-node-version/-/parse-node-version-1.0.1.tgz -> npmpkg-parse-node-version-1.0.1.tgz
https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz -> npmpkg-parse-passwd-1.0.0.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-root-regex/-/path-root-regex-0.1.2.tgz -> npmpkg-path-root-regex-0.1.2.tgz
https://registry.npmjs.org/path-root/-/path-root-0.1.1.tgz -> npmpkg-path-root-0.1.1.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/plugin-error/-/plugin-error-1.0.1.tgz -> npmpkg-plugin-error-1.0.1.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz -> npmpkg-pretty-hrtime-1.0.3.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.7.tgz -> npmpkg-process-nextick-args-1.0.7.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.0.tgz -> npmpkg-process-nextick-args-2.0.0.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> npmpkg-read-pkg-up-1.0.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz -> npmpkg-readable-stream-1.0.34.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.6.tgz -> npmpkg-readable-stream-2.3.6.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.4.0.tgz -> npmpkg-readable-stream-3.4.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.0.tgz -> npmpkg-readable-stream-3.6.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/remove-bom-buffer/-/remove-bom-buffer-3.0.0.tgz -> npmpkg-remove-bom-buffer-3.0.0.tgz
https://registry.npmjs.org/remove-bom-stream/-/remove-bom-stream-1.2.0.tgz -> npmpkg-remove-bom-stream-1.2.0.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/replace-ext/-/replace-ext-1.0.0.tgz -> npmpkg-replace-ext-1.0.0.tgz
https://registry.npmjs.org/replace-homedir/-/replace-homedir-1.0.0.tgz -> npmpkg-replace-homedir-1.0.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-1.0.1.tgz -> npmpkg-require-main-filename-1.0.1.tgz
https://registry.npmjs.org/resolve-dir/-/resolve-dir-1.0.1.tgz -> npmpkg-resolve-dir-1.0.1.tgz
https://registry.npmjs.org/resolve-options/-/resolve-options-1.1.0.tgz -> npmpkg-resolve-options-1.1.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.8.1.tgz -> npmpkg-resolve-1.8.1.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/semver-greatest-satisfied-range/-/semver-greatest-satisfied-range-1.1.0.tgz -> npmpkg-semver-greatest-satisfied-range-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> npmpkg-serialize-javascript-6.0.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/should-equal/-/should-equal-2.0.0.tgz -> npmpkg-should-equal-2.0.0.tgz
https://registry.npmjs.org/should-format/-/should-format-3.0.3.tgz -> npmpkg-should-format-3.0.3.tgz
https://registry.npmjs.org/should-type-adaptors/-/should-type-adaptors-1.1.0.tgz -> npmpkg-should-type-adaptors-1.1.0.tgz
https://registry.npmjs.org/should-type/-/should-type-1.4.0.tgz -> npmpkg-should-type-1.4.0.tgz
https://registry.npmjs.org/should-util/-/should-util-1.0.0.tgz -> npmpkg-should-util-1.0.0.tgz
https://registry.npmjs.org/should/-/should-13.2.3.tgz -> npmpkg-should-13.2.3.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.2.tgz -> npmpkg-source-map-resolve-0.5.2.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.0.tgz -> npmpkg-source-map-url-0.4.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/sparkles/-/sparkles-1.0.1.tgz -> npmpkg-sparkles-1.0.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.0.2.tgz -> npmpkg-spdx-correct-3.0.2.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.2.0.tgz -> npmpkg-spdx-exceptions-2.2.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.0.tgz -> npmpkg-spdx-expression-parse-3.0.0.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.1.tgz -> npmpkg-spdx-license-ids-3.0.1.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/stack-trace/-/stack-trace-0.0.10.tgz -> npmpkg-stack-trace-0.0.10.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/stream-assert/-/stream-assert-2.0.3.tgz -> npmpkg-stream-assert-2.0.3.tgz
https://registry.npmjs.org/stream-exhaust/-/stream-exhaust-1.0.2.tgz -> npmpkg-stream-exhaust-1.0.2.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.0.tgz -> npmpkg-stream-shift-1.0.0.tgz
https://registry.npmjs.org/streamfilter/-/streamfilter-3.0.0.tgz -> npmpkg-streamfilter-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom-string/-/strip-bom-string-1.0.0.tgz -> npmpkg-strip-bom-string-1.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/sver-compat/-/sver-compat-1.5.0.tgz -> npmpkg-sver-compat-1.5.0.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-3.0.0.tgz -> npmpkg-through2-filter-3.0.0.tgz
https://registry.npmjs.org/through2/-/through2-0.6.5.tgz -> npmpkg-through2-0.6.5.tgz
https://registry.npmjs.org/through2/-/through2-2.0.3.tgz -> npmpkg-through2-2.0.3.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/through2/-/through2-4.0.2.tgz -> npmpkg-through2-4.0.2.tgz
https://registry.npmjs.org/time-stamp/-/time-stamp-1.1.0.tgz -> npmpkg-time-stamp-1.1.0.tgz
https://registry.npmjs.org/timers-ext/-/timers-ext-0.1.7.tgz -> npmpkg-timers-ext-0.1.7.tgz
https://registry.npmjs.org/to-absolute-glob/-/to-absolute-glob-2.0.2.tgz -> npmpkg-to-absolute-glob-2.0.2.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-through/-/to-through-2.0.0.tgz -> npmpkg-to-through-2.0.0.tgz
https://registry.npmjs.org/type/-/type-1.2.0.tgz -> npmpkg-type-1.2.0.tgz
https://registry.npmjs.org/type/-/type-2.7.2.tgz -> npmpkg-type-2.7.2.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> npmpkg-unc-path-regex-0.1.2.tgz
https://registry.npmjs.org/undertaker-registry/-/undertaker-registry-1.0.1.tgz -> npmpkg-undertaker-registry-1.0.1.tgz
https://registry.npmjs.org/undertaker/-/undertaker-1.2.1.tgz -> npmpkg-undertaker-1.2.1.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.0.tgz -> npmpkg-union-value-1.0.0.tgz
https://registry.npmjs.org/unique-stream/-/unique-stream-2.3.1.tgz -> npmpkg-unique-stream-2.3.1.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/v8flags/-/v8flags-3.1.3.tgz -> npmpkg-v8flags-3.1.3.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/value-or-function/-/value-or-function-3.0.0.tgz -> npmpkg-value-or-function-3.0.0.tgz
https://registry.npmjs.org/vinyl-fs/-/vinyl-fs-3.0.3.tgz -> npmpkg-vinyl-fs-3.0.3.tgz
https://registry.npmjs.org/vinyl-sourcemap/-/vinyl-sourcemap-1.1.0.tgz -> npmpkg-vinyl-sourcemap-1.1.0.tgz
https://registry.npmjs.org/vinyl-sourcemaps-apply/-/vinyl-sourcemaps-apply-0.2.1.tgz -> npmpkg-vinyl-sourcemaps-apply-0.2.1.tgz
https://registry.npmjs.org/vinyl/-/vinyl-2.2.0.tgz -> npmpkg-vinyl-2.2.0.tgz
https://registry.npmjs.org/which-module/-/which-module-1.0.0.tgz -> npmpkg-which-module-1.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/workerpool/-/workerpool-6.2.1.tgz -> npmpkg-workerpool-6.2.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> npmpkg-wrap-ansi-2.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz -> npmpkg-xtend-4.0.1.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.4.tgz -> npmpkg-yargs-parser-20.2.4.tgz
https://registry.npmjs.org/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> npmpkg-yargs-unparser-2.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-7.1.0.tgz -> npmpkg-yargs-7.1.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
bazel_external_uris="
https://github.com/bazelbuild/rules_proto/archive/refs/tags/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://cdn.azul.com/zulu/bin/zulu${ZULU17_PV}-linux_x64.tar.gz
https://cdn.azul.com/zulu/bin/zulu${ZULU11_PV}-linux_x64.tar.gz
https://github.com/bazelbuild/rules_jvm_external/archive/${EGIT_RULES_JVM_EXTERNAL_COMMIT}.zip -> rules_jvm_external-${EGIT_RULES_JVM_EXTERNAL_COMMIT}.zip
https://github.com/coursier/coursier/releases/download/v${COURSIER_PV}/coursier.jar -> coursier-${COURSIER_PV}.jar
https://github.com/google/bazel-common/archive/${EGIT_BAZEL_COMMON_COMMIT}.zip -> bazel-common-${EGIT_BAZEL_COMMON_COMMIT}.zip
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools-v${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools_linux-v${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/refs/tags/${RULES_PROTO_PV}.tar.gz -> rules_proto-${RULES_PROTO_PV}.tar.gz
https://github.com/bazelbuild/rules_java/releases/download/${RULES_JAVA_PV}/rules_java-${RULES_JAVA_PV}.tar.gz -> rules_java-${RULES_JAVA_PV}.tar.gz
https://github.com/johnynek/bazel_jar_jar/archive/${EGIT_BAZEL_JAR_JAR_COMMIT}.zip -> bazel_jar_jar-${EGIT_BAZEL_JAR_JAR_COMMIT}.zip
https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_JAVA_3_17_PV}.tar.gz -> protobuf-v${PROTOBUF_JAVA_3_17_PV}.tar.gz
https://mirror.bazel.build/github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_JAVA_3_17_PV}/protoc-${PROTOBUF_JAVA_3_17_PV}-linux-x86_64.zip
https://repo1.maven.org/maven2/args4j/args4j-site/${ARGS4J_PV}/args4j-site-${ARGS4J_PV}.pom
https://repo1.maven.org/maven2/args4j/args4j-site/${ARGS4J_PV}/args4j-site-${ARGS4J_PV}.pom.md5
https://repo1.maven.org/maven2/args4j/args4j-site/${ARGS4J_PV}/args4j-site-${ARGS4J_PV}.pom.sha1
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.jar
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.jar.md5
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.jar.sha1
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.pom
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.pom.md5
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/auto/auto-common/${AUTO_COMMON_PV}/auto-common-${AUTO_COMMON_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/auto-common/${AUTO_COMMON_PV}/auto-common-${AUTO_COMMON_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/auto/auto-common/${AUTO_COMMON_PV}/auto-common-${AUTO_COMMON_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/auto/service/auto-service/${AUTO_SERVICE_PV}/auto-service-${AUTO_SERVICE_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/service/auto-service/${AUTO_SERVICE_PV}/auto-service-${AUTO_SERVICE_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/auto/service/auto-service/${AUTO_SERVICE_PV}/auto-service-${AUTO_SERVICE_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/auto/service/auto-service-annotations/${AUTO_SERVICE_PV}/auto-service-annotations-${AUTO_SERVICE_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/service/auto-service-annotations/${AUTO_SERVICE_PV}/auto-service-annotations-${AUTO_SERVICE_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/auto/service/auto-service-annotations/${AUTO_SERVICE_PV}/auto-service-annotations-${AUTO_SERVICE_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_7_PV}/auto-value-annotations-${AUTO_VALUE_1_7_PV}.pom
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_7_PV}/auto-value-annotations-${AUTO_VALUE_1_7_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_7_PV}/auto-value-annotations-${AUTO_VALUE_1_7_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_10_PV}/auto-value-annotations-${AUTO_VALUE_1_10_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_10_PV}/auto-value-annotations-${AUTO_VALUE_1_10_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_1_10_PV}/auto-value-annotations-${AUTO_VALUE_1_10_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-parent/${AUTO_VALUE_1_7_PV}/auto-value-parent-${AUTO_VALUE_1_7_PV}.pom
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-parent/${AUTO_VALUE_1_7_PV}/auto-value-parent-${AUTO_VALUE_1_7_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-parent/${AUTO_VALUE_1_7_PV}/auto-value-parent-${AUTO_VALUE_1_7_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/auto/value/auto-value/${AUTO_VALUE_1_10_PV}/auto-value-${AUTO_VALUE_1_10_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/value/auto-value/${AUTO_VALUE_1_10_PV}/auto-value-${AUTO_VALUE_1_10_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/auto/value/auto-value/${AUTO_VALUE_1_10_PV}/auto-value-${AUTO_VALUE_1_10_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.jar
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.pom
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/code/gson/gson-parent/${GSON_PV}/gson-parent-${GSON_PV}.pom
https://repo1.maven.org/maven2/com/google/code/gson/gson-parent/${GSON_PV}/gson-parent-${GSON_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/code/gson/gson-parent/${GSON_PV}/gson-parent-${GSON_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.jar
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.pom
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.jar
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.pom
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_15_PV}/error_prone_annotations-${ERROR_PRONE_2_15_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_15_PV}/error_prone_parent-${ERROR_PRONE_2_15_PV}.pom
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_15_PV}/error_prone_parent-${ERROR_PRONE_2_15_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_15_PV}/error_prone_parent-${ERROR_PRONE_2_15_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_18_PV}/error_prone_annotations-${ERROR_PRONE_2_18_PV}.pom
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_18_PV}/error_prone_annotations-${ERROR_PRONE_2_18_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_2_18_PV}/error_prone_annotations-${ERROR_PRONE_2_18_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_18_PV}/error_prone_parent-${ERROR_PRONE_2_18_PV}.pom
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_18_PV}/error_prone_parent-${ERROR_PRONE_2_18_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_parent/${ERROR_PRONE_2_18_PV}/error_prone_parent-${ERROR_PRONE_2_18_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.jar
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.pom
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/guava/failureaccess/${FAILUREACCESS_PV}/failureaccess-${FAILUREACCESS_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.jar
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.jar.md5
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.jar.sha1
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.pom
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.pom.md5
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA32_PV}-jre/guava-${GUAVA32_PV}-jre.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA33_PV}-jre/guava-${GUAVA33_PV}-jre.jar
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA33_PV}-jre/guava-${GUAVA33_PV}-jre.jar.md5
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA33_PV}-jre/guava-${GUAVA33_PV}-jre.jar.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-beta-checker/${GUAVA_BETA_CHECKER_PV}/guava-beta-checker-${GUAVA_BETA_CHECKER_PV}.jar
https://repo1.maven.org/maven2/com/google/guava/guava-beta-checker/${GUAVA_BETA_CHECKER_PV}/guava-beta-checker-${GUAVA_BETA_CHECKER_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/guava/guava-beta-checker/${GUAVA_BETA_CHECKER_PV}/guava-beta-checker-${GUAVA_BETA_CHECKER_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA26_PV}-android/guava-parent-${GUAVA26_PV}-android.pom
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA26_PV}-android/guava-parent-${GUAVA26_PV}-android.pom.md5
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA26_PV}-android/guava-parent-${GUAVA26_PV}-android.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-android/guava-parent-${GUAVA32_PV}-android.pom
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-android/guava-parent-${GUAVA32_PV}-android.pom.md5
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-android/guava-parent-${GUAVA32_PV}-android.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-jre/guava-parent-${GUAVA32_PV}-jre.pom
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-jre/guava-parent-${GUAVA32_PV}-jre.pom.md5
https://repo1.maven.org/maven2/com/google/guava/guava-parent/${GUAVA32_PV}-jre/guava-parent-${GUAVA32_PV}-jre.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.jar
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.jar.md5
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.jar.sha1
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.pom
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.pom.md5
https://repo1.maven.org/maven2/com/google/guava/guava-testlib/${GUAVA32_PV}-jre/guava-testlib-${GUAVA32_PV}-jre.pom.sha1
https://repo1.maven.org/maven2/com/google/guava/listenablefuture/${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava/listenablefuture-${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava.pom
https://repo1.maven.org/maven2/com/google/guava/listenablefuture/${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava/listenablefuture-${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava.pom.md5
https://repo1.maven.org/maven2/com/google/guava/listenablefuture/${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava/listenablefuture-${LISTENABLEFUTURE_PV}-empty-to-avoid-conflict-with-guava.pom.sha1
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.jar
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.pom
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/${J2OBJC_PV}/j2objc-annotations-${J2OBJC_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/jimfs/jimfs-parent/${JIMFS_PV}/jimfs-parent-${JIMFS_PV}.pom
https://repo1.maven.org/maven2/com/google/jimfs/jimfs-parent/${JIMFS_PV}/jimfs-parent-${JIMFS_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/jimfs/jimfs-parent/${JIMFS_PV}/jimfs-parent-${JIMFS_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.jar
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.pom
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/jimfs/jimfs/${JIMFS_PV}/jimfs-${JIMFS_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-bom/${PROTOBUF_JAVA_3_21_PV}/protobuf-bom-${PROTOBUF_JAVA_3_21_PV}.pom
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-bom/${PROTOBUF_JAVA_3_21_PV}/protobuf-bom-${PROTOBUF_JAVA_3_21_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-bom/${PROTOBUF_JAVA_3_21_PV}/protobuf-bom-${PROTOBUF_JAVA_3_21_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_17_PV}/protobuf-java-${PROTOBUF_JAVA_3_17_PV}.jar
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_17_PV}/protobuf-java-${PROTOBUF_JAVA_3_17_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_17_PV}/protobuf-java-${PROTOBUF_JAVA_3_17_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_17_PV}/protobuf-java-${PROTOBUF_JAVA_3_17_PV}-sources.jar
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.jar
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.pom
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/${PROTOBUF_JAVA_3_21_PV}/protobuf-java-${PROTOBUF_JAVA_3_21_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-parent/${PROTOBUF_JAVA_3_21_PV}/protobuf-parent-${PROTOBUF_JAVA_3_21_PV}.pom
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-parent/${PROTOBUF_JAVA_3_21_PV}/protobuf-parent-${PROTOBUF_JAVA_3_21_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/protobuf/protobuf-parent/${PROTOBUF_JAVA_3_21_PV}/protobuf-parent-${PROTOBUF_JAVA_3_21_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.jar
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.pom
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/re2j/re2j/${RE2J_PV}/re2j-${RE2J_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-extensions-parent/${TRUTH_PV}/truth-extensions-parent-${TRUTH_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-extensions-parent/${TRUTH_PV}/truth-extensions-parent-${TRUTH_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-extensions-parent/${TRUTH_PV}/truth-extensions-parent-${TRUTH_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_PV}/truth-liteproto-extension-${TRUTH_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_PV}/truth-liteproto-extension-${TRUTH_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_PV}/truth-liteproto-extension-${TRUTH_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.jar
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-liteproto-extension/${TRUTH_LITEPROTO_EXTENSION_PV}/truth-liteproto-extension-${TRUTH_LITEPROTO_EXTENSION_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.jar
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.jar.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.jar.sha1
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/extensions/truth-proto-extension/${TRUTH_PV}/truth-proto-extension-${TRUTH_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/truth-parent/${TRUTH_PV}/truth-parent-${TRUTH_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/truth-parent/${TRUTH_PV}/truth-parent-${TRUTH_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/truth-parent/${TRUTH_PV}/truth-parent-${TRUTH_PV}.pom.sha1
https://repo1.maven.org/maven2/com/google/truth/truth/${TRUTH_PV}/truth-${TRUTH_PV}.pom
https://repo1.maven.org/maven2/com/google/truth/truth/${TRUTH_PV}/truth-${TRUTH_PV}.pom.md5
https://repo1.maven.org/maven2/com/google/truth/truth/${TRUTH_PV}/truth-${TRUTH_PV}.pom.sha1
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils-parent/${JAVA_DIFF_UTILS_PV}/java-diff-utils-parent-${JAVA_DIFF_UTILS_PV}.pom
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils-parent/${JAVA_DIFF_UTILS_PV}/java-diff-utils-parent-${JAVA_DIFF_UTILS_PV}.pom.md5
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils-parent/${JAVA_DIFF_UTILS_PV}/java-diff-utils-parent-${JAVA_DIFF_UTILS_PV}.pom.sha1
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.jar
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.jar.md5
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.jar.sha1
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.pom
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.pom.md5
https://repo1.maven.org/maven2/io/github/java-diff-utils/java-diff-utils/${JAVA_DIFF_UTILS_PV}/java-diff-utils-${JAVA_DIFF_UTILS_PV}.pom.sha1
https://repo1.maven.org/maven2/javax/annotation/jsr250-api/${JSR256_PV}/jsr250-api-${JSR256_PV}.jar
https://repo1.maven.org/maven2/javax/annotation/jsr250-api/${JSR256_PV}/jsr250-api-${JSR256_PV}.jar.md5
https://repo1.maven.org/maven2/javax/annotation/jsr250-api/${JSR256_PV}/jsr250-api-${JSR256_PV}.jar.sha1
https://repo1.maven.org/maven2/junit/junit/${JUNIT_PV}/junit-${JUNIT_PV}.pom
https://repo1.maven.org/maven2/junit/junit/${JUNIT_PV}/junit-${JUNIT_PV}.pom.md5
https://repo1.maven.org/maven2/junit/junit/${JUNIT_PV}/junit-${JUNIT_PV}.pom.sha1
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.jar
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.jar.md5
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.jar.sha1
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.pom
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.pom.md5
https://repo1.maven.org/maven2/org/apache/ant/ant/${ANT_PV}/ant-${ANT_PV}.pom.sha1
https://repo1.maven.org/maven2/org/apache/ant/ant-launcher/${ANT_PV}/ant-launcher-${ANT_PV}.pom
https://repo1.maven.org/maven2/org/apache/ant/ant-launcher/${ANT_PV}/ant-launcher-${ANT_PV}.pom.md5
https://repo1.maven.org/maven2/org/apache/ant/ant-launcher/${ANT_PV}/ant-launcher-${ANT_PV}.pom.sha1
https://repo1.maven.org/maven2/org/apache/ant/ant-parent/${ANT_PV}/ant-parent-${ANT_PV}.pom
https://repo1.maven.org/maven2/org/apache/ant/ant-parent/${ANT_PV}/ant-parent-${ANT_PV}.pom.md5
https://repo1.maven.org/maven2/org/apache/ant/ant-parent/${ANT_PV}/ant-parent-${ANT_PV}.pom.sha1
https://repo1.maven.org/maven2/org/checkerframework/checker-qual/${CHECKER_QUAL_PV}/checker-qual-${CHECKER_QUAL_PV}.pom
https://repo1.maven.org/maven2/org/checkerframework/checker-qual/${CHECKER_QUAL_PV}/checker-qual-${CHECKER_QUAL_PV}.pom.md5
https://repo1.maven.org/maven2/org/checkerframework/checker-qual/${CHECKER_QUAL_PV}/checker-qual-${CHECKER_QUAL_PV}.pom.sha1
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.jar
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.jar.md5
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.jar.sha1
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.pom
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.pom.md5
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/${HAMCREST_PV}/hamcrest-core-${HAMCREST_PV}.pom.sha1
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-parent/${HAMCREST_PV}/hamcrest-parent-${HAMCREST_PV}.pom
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-parent/${HAMCREST_PV}/hamcrest-parent-${HAMCREST_PV}.pom.md5
https://repo1.maven.org/maven2/org/hamcrest/hamcrest-parent/${HAMCREST_PV}/hamcrest-parent-${HAMCREST_PV}.pom.sha1
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.jar
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.jar.md5
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.jar.sha1
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.pom
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.pom.md5
https://repo1.maven.org/maven2/org/jspecify/jspecify/${JSPECIFY_PV}/jspecify-${JSPECIFY_PV}.pom.sha1
https://repo1.maven.org/maven2/org/kohsuke/pom/${POM_PV}/pom-${POM_PV}.pom
https://repo1.maven.org/maven2/org/kohsuke/pom/${POM_PV}/pom-${POM_PV}.pom.md5
https://repo1.maven.org/maven2/org/kohsuke/pom/${POM_PV}/pom-${POM_PV}.pom.sha1
https://repo1.maven.org/maven2/org/ow2/asm/asm/${ASM_PV}/asm-${ASM_PV}.pom
https://repo1.maven.org/maven2/org/ow2/asm/asm/${ASM_PV}/asm-${ASM_PV}.pom.md5
https://repo1.maven.org/maven2/org/ow2/asm/asm/${ASM_PV}/asm-${ASM_PV}.pom.sha1
https://repo1.maven.org/maven2/org/ow2/ow2/${OW2_PV}/ow2-${OW2_PV}.pom
https://repo1.maven.org/maven2/org/ow2/ow2/${OW2_PV}/ow2-${OW2_PV}.pom.md5
https://repo1.maven.org/maven2/org/ow2/ow2/${OW2_PV}/ow2-${OW2_PV}.pom.sha1
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS7_PV}/oss-parent-${OSS7_PV}.pom
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS7_PV}/oss-parent-${OSS7_PV}.pom.md5
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS7_PV}/oss-parent-${OSS7_PV}.pom.sha1
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS9_PV}/oss-parent-${OSS9_PV}.pom
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS9_PV}/oss-parent-${OSS9_PV}.pom.md5
https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/${OSS9_PV}/oss-parent-${OSS9_PV}.pom.sha1
"

gen_bazelisk_src_uris() {
	local abi
	for abi in ${BAZELISK_ABIS[@]} ; do
		echo "
	${abi}? (
https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_PV}/bazelisk-linux-${abi}
	-> bazelisk-linux-${abi}-${BAZELISK_PV}
	)
		"
	done
}

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${CLOSURE_COMPILER_MAJOR_VER}"
SRC_URI="
$(gen_bazelisk_src_uris)
$(graalvm_gen_base_uris)
$(graalvm_gen_native_image_uris)
${bazel_external_uris}
${NPM_EXTERNAL_URIS}
https://github.com/google/closure-compiler-npm/archive/v${PV}.tar.gz
	-> ${FN_DEST}
https://github.com/google/closure-compiler/archive/v${CLOSURE_COMPILER_MAJOR_VER}.tar.gz
	-> ${FN_DEST2}
"

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
	closure_compiler_native? (
		${GRAAL_VM_CE_LICENSES}
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	closure_compiler_java
	closure_compiler_native
	closure_compiler_nodejs
	doc
	java
	test
	r1
"
REQUIRED_USE+="
	java
	closure_compiler_nodejs? (
		closure_compiler_java
	)
	|| (
		closure_compiler_java
		closure_compiler_native
		closure_compiler_nodejs
	)
"
VIRTUAL_JDK_BAZEL="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_PV}:${JAVA_SLOT_BAZEL}[gentoo-vm(+)]
		>=dev-java/openjdk-${OPENJDK_PV}:${JAVA_SLOT_BAZEL}[gentoo-vm(+)]
	)
"
VIRTUAL_JDK_CLOSURE_COMPILER="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_PV}:${JAVA_SLOT_CLOSURE_COMPILER}[gentoo-vm(+)]
		>=dev-java/openjdk-${OPENJDK_PV}:${JAVA_SLOT_CLOSURE_COMPILER}[gentoo-vm(+)]
	)
"
VIRTUAL_JRE_BAZEL="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_PV}:${JAVA_SLOT_BAZEL}[gentoo-vm(+)]
		>=dev-java/openjdk-${OPENJDK_PV}:${JAVA_SLOT_BAZEL}[gentoo-vm(+)]
	)
"
VIRTUAL_JRE_CLOSURE_COMPILER="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_PV}:${JAVA_SLOT_CLOSURE_COMPILER}[gentoo-vm(+)]
		>=dev-java/openjdk-${OPENJDK_PV}:${JAVA_SLOT_CLOSURE_COMPILER}[gentoo-vm(+)]
	)
"
RDEPEND+="
	${VIRTUAL_JRE_BAZEL}
	!dev-lang/closure-compiler-bin
	closure_compiler_java? (
		${VIRTUAL_JRE_CLOSURE_COMPILER}
	)
	closure_compiler_nodejs? (
		${VIRTUAL_JRE_CLOSURE_COMPILER}
		>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
		>=net-libs/nodejs-${NODE_VERSION}[npm]
	)
"
DEPEND+="
	${RDEPEND}
	${VIRTUAL_JDK_BAZEL}
	closure_compiler_java? (
		${VIRTUAL_JDK_CLOSURE_COMPILER}
	)
	closure_compiler_nodejs? (
		${VIRTUAL_JDK_CLOSURE_COMPILER}
	)
"
BDEPEND+="
	${VIRTUAL_JDK_BAZEL}
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_SLOT}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	>=sys-devel/gcc-9.4.0
	dev-java/maven-bin
	dev-vcs/git
	sys-apps/yarn:1
	closure_compiler_native? (
		${GRAALVM_CE_DEPENDS}
	)
"
PATCHES=(
	"${FILESDIR}/closure-compiler-npm-20240317.0.0-init-absolute_javabase.patch"
	"${FILESDIR}/closure-compiler-npm-20240317.0.0-no-loop.patch"
)

_configure_bazel() {
	# https://github.com/bazelbuild/bazel/releases
	bazel-${BAZEL_SLOT} --version | grep -q "bazel ${BAZEL_PV%.*}" || die "=dev-build/bazel:${BAZEL_PV%.*} not installed"
	local bazel_pv=$(bazel-${BAZEL_SLOT} --version \
		| cut -f 2 -d " " \
		| sed -e "s|-||g")

	export BAZELISK_VERIFY_SHA256=$(sha256sum "/usr/bin/bazel-${BAZEL_SLOT}" \
		| cut -f 1 -d " ")

	# bazelisk is needed for the compiler*.jar file

	if ! [[ -e "/usr/bin/bazel-${BAZEL_SLOT}" ]] ; then
# Bazel breaks backwards compatibility by deleting command line arguments in
# future versions.
eerror
eerror "You need bazel ${BAZEL_SLOT} to build this."
eerror
		die
	fi
	local dest="${S}/tools"
	local bazel_path="/usr/bin/bazel-${BAZEL_SLOT}"
einfo "bazel_path:  ${bazel_path}"
	# For this weird workaround to prevent download,
	# see https://github.com/bazelbuild/bazelisk/issues/560
	export USE_BAZEL_VERSION="${bazel_path}"
einfo "Generating bazel ${bazel_pv} wrapper for bazelisk"
	mkdir -p "${dest}"
# For the wrapper, see
# See https://github.com/bazelbuild/bazelisk?tab=readme-ov-file#ensuring-that-your-developers-use-bazelisk-rather-than-bazel
cat <<EOF > "${dest}/bazel"
#!/bin/bash
"${bazel_path}" "$@"
EOF
	export PATH="${dest}:${PATH}"
einfo "BAZELISK_VERIFY_SHA256: ${BAZELISK_VERIFY_SHA256}"
einfo "USE_BAZEL_VERSION: ${USE_BAZEL_VERSION}"

einfo "Configuring bazel"
	echo 'build --noshow_progress' >> "${T}/bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${T}/bazelrc" || die # Increase verbosity

	# There is a bug that keeps popping up when building java packages:
	# /var/lib/portage/home/ should be /var/tmp/portage/dev-util/closure-compiler-npm-20240317.0.0/homedir/
	export MAVEN_REPO="file://$HOME/.m2/repository"
	#echo "bazel run --define \"maven_repo=file://$HOME/.m2/repository\"" >> "${T}/bazelrc" || die # Does not fix

	cat "${T}/bazelrc" >> "${S}/compiler/.bazelrc" || die
}

_set_check_reqs_requirements() {
	CHECKREQS_DISK_BUILD="1688M"
	CHECKREQS_DISK_USR="315M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
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

	java-pkg-opt-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT_CLOSURE_COMPILER}
	javac --version || die
	# JAVA_HOME_11 should be the OpenJDK base path not GraalVM.
	# JAVA_HOME should be the GraalVM base path.

	# Use only Hotspot at this time.
	if has_version "dev-java/openjdk-bin:11" ; then
		local jdk_path=$(realpath "/opt/openjdk-bin-11")
		export JAVA_HOME_11="${jdk_path}"
	elif has_version "dev-java/openjdk:11" ; then
		local jdk_path=$(realpath "/usr/$(get_libdir)/openjdk-11")
		export JAVA_HOME_11="${jdk_path}"
	fi

	if has_version "dev-java/openjdk-bin:17" ; then
		local jdk_path=$(realpath "/opt/openjdk-bin-17")
		export JAVA_HOME_17="${jdk_path}"
	elif has_version "dev-java/openjdk:17" ; then
		local jdk_path=$(realpath "/usr/$(get_libdir)/openjdk-17")
		export JAVA_HOME_17="${jdk_path}"
	fi
einfo "JAVA_HOME_11:  ${JAVA_HOME_11}" # For running bazel and building closure-compiler
einfo "JAVA_HOME_17:  ${JAVA_HOME_17}" #

	# Bug
	unset ANDROID_HOME
	unset ANDROID_NDK_HOME
	unset ANDROID_SDK_HOME

einfo "COMPILER_NIGHTLY:  ${COMPILER_NIGHTLY}"
einfo "FORCE_COLOR:  ${FORCE_COLOR}"
einfo "JAVA_HOME:  ${JAVA_HOME} [from pkg_setup]"
einfo "JAVA_HOME_11:  ${JAVA_HOME_11} [from pkg_setup]"
einfo "PATH:  ${PATH}"

	if ! which mvn 2>/dev/null 1>/dev/null ; then
eerror
eerror "Missing mvn.  Install dev-java/maven-bin"
eerror
		die
	fi

	if false && has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi

	# Do not make conditional.
	npm_pkg_setup
	yarn_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if [[ ! -e "/usr/include/node/node_version.h" ]] ; then
eerror
eerror "Use eselect nodejs to fix missing header location."
eerror
		die
	fi
	bazel_setup_bazelrc
}

src_unpack() {
	unpack ${FN_DEST}
	unpack ${FN_DEST2}

	rm -rf "${S}/compiler" || die
	mv \
		"${S_CLOSURE_COMPILER}" \
		"${S}/compiler" \
		|| die

	bazel_load_distfiles "${bazel_external_uris}"

	if use closure_compiler_native ; then
		unpack $(graalvm_get_base_tarball_name)
		graalvm_attach_graalvm
	fi

	# Do not make this section conditional.
einfo "Building compiler jar (1/2)"
	npm_src_unpack # Part 1/2 of _build_compiler_jar

	if ! use closure_compiler_java ; then
einfo "Removing Java support"
		rm -rf "${S}/packages/google-closure-compiler-java" || die
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
	for abi in ${BAZELISK_ABIS[@]} ; do
		mkdir -p "${WORKDIR}/bazelisk" || die
		if use "${abi}" ; then
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
	git tag "v${PV}" || die

	if grep -e "Read timed out" "${T}/build.log" ; then
eerror
eerror "Download failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -e "Error downloading" "${T}/build.log" ; then
eerror
eerror "Download failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -e "Build did NOT complete successfully" "${T}/build.log" ; then
eerror
eerror "Build failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -e "ERROR:" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -e "exitCode:" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -F -e "cb() never called!" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
}

src_prepare() {
	default
	java-pkg-opt-2_src_prepare

	local x
	for x in ${MAVEN_TARBALLS[@]} ; do
		sed -i -e "89a\"file://${x}\"," "compiler/WORKSPACE.bazel" || die
	done
}

_copy_jar() {
	local pom_dir="${1}"
	local pom_bn="${2}"
	local jar_bn=$(echo "${pom_bn}" | sed -e "s|\.pom$|.jar|g")
	mkdir -p "${HOME}/.m2/repository/${pom_dir}" || die
	cat \
		"${DISTDIR}/${pom_bn}" \
		> \
		"${HOME}/.m2/repository/${pom_dir}/${pom_bn}" \
		|| die
	cat \
		"${DISTDIR}/${pom_bn}.md5" \
		> \
		"${HOME}/.m2/repository/${pom_dir}/${pom_bn}.md5" \
		|| die
	cat \
		"${DISTDIR}/${pom_bn}.sha1" \
		> \
		"${HOME}/.m2/repository/${pom_dir}/${pom_bn}.sha1" \
		|| die
	if [[ -e "${DISTDIR}/${jar_bn}" ]] ; then
		cat \
			"${DISTDIR}/${jar_bn}" \
			> \
			"${HOME}/.m2/repository/${pom_dir}/${jar_bn}" \
			|| die
		cat \
			"${DISTDIR}/${jar_bn}.md5" \
			> \
			"${HOME}/.m2/repository/${pom_dir}/${jar_bn}.md5" \
			|| die
		cat \
			"${DISTDIR}/${jar_bn}.sha1" \
			> \
			"${HOME}/.m2/repository/${pom_dir}/${jar_bn}.sha1" \
			|| die
	fi
}

_copy_jars() {
	local uri
	for uri in ${bazel_external_uris} ; do
		if [[ "${uri}" =~ ".pom"$ ]] ; then
			local bn="${uri##*/}"
			local dir=$(echo "${uri}" | sed -e "s|https://repo1.maven.org/maven2/||g")
			local dir=$(dirname "${dir}")
einfo "Running:  _copy_jar \"${dir}\" \"${bn}\""
			_copy_jar "${dir}" "${bn}"
		fi
	done
}

_configure_java() {
	if use closure_compiler_native || use closure_compiler_java ; then
		export RJE_UNSAFE_CACHE="1"

		# Fix for:
		# not found: /var/lib/portage/home/.m2/repository
		export _JAVA_OPTIONS="${_JAVA_OPTIONS} -Duser.home=${HOME}"

		_copy_jars
	fi
}

src_configure() {
	_configure_bazel
	if use closure_compiler_native || use closure_compiler_java ; then
		_configure_java
	fi
}

_build_compiler_jar() {
einfo "Building compiler jar (2/2)"
einfo "Running:  node ./build-scripts/build_compiler.js"
	node ./build-scripts/build_compiler.js || die # Part 2/2 of _build_compiler_jar

	if grep -q -F -e "ERROR:" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
}

_build_native_image() {
einfo "Building native image (1/2)"
	enpm run build ${extra_args[@]}
	_npm_check_errors

	export PATH="${WORKDIR}/graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-${GRAALVM_PV}/bin:${PATH}"
	java -version 2>&1 | grep -q "GraalVM.*${GRAALVM_PV}" || die

einfo "Building native image (2/2)"
	eyarn workspaces run build
	_npm_check_errors
	_yarn_check_errors

	if grep -q -F -e "Error while fetching artifact" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -q -F -e "Error: Invalid or corrupt jarfile" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
	if grep -q -F -e "Error: non-zero exit code 1" "${T}/build.log" ; then
eerror
eerror "Failure detected.  Re-emerge."
eerror
		die
	fi
}

src_compile() {
# Fixes:
# FATAL: bazel crashed due to an internal error. Printing stack trace:
# java.lang.NoClassDefFoundError: Could not initialize class com.google.devtools.build.lib.unsafe.StringUnsafe
# ...
# Caused by: java.lang.ExceptionInInitializerError: Exception java.lang.reflect.InaccessibleObjectException: Unable to make java.lang.String(byte[],byte) accessible: module java.base does not "opens java.lang" to unnamed module @76552cb [in thread "skyframe-evaluator 2"]
# ...
einfo "JAVA_HOME_11:  ${JAVA_HOME_11}"
	echo \
		"startup --server_javabase=${JAVA_HOME_11}" \
		>> \
		"compiler/.bazelrc" \
		|| die

	# You have to define the build with a java_path with a custom label.
	echo \
		"build --javabase=:absolute_javabase --define=ABSOLUTE_JAVABASE=${JAVA_HOME_11} --define=USE_ABSOLUTE_JAVABASE=true" \
		>> \
		"compiler/.bazelrc" \
		|| die

	export JAVA_HOME="${JAVA_HOME_11}"
        export USER_HOME="${HOME}"
	einfo "JAVA_HOME:  ${JAVA_HOME}"
        einfo "HOME:  ${HOME}"
	einfo "PATH:  ${PATH} (DEBUG)"
        einfo "USER:  ${USER}"
        einfo "USER_HOME:  ${USER_HOME}"
	npm_hydrate
	yarn_hydrate
	local extra_args=()
	local npm_offline="${NPM_OFFLINE:-1}"
	if [[ "${npm_offline}" == "2" ]] ; then
		extra_args=( "--offline" )
	elif [[ "${npm_offline}" == "1" ]] ; then
		extra_args=( "--prefer-offline" )
	fi

	_build_compiler_jar
	_build_native_image # This call depends on _build_compiler_jar.
}

src_install() {
	pushd "packages" || die

	if use closure_compiler_java ; then
		local d_src="google-${MY_PN}-java"
		cp -a \
			"${d_src}/compiler.jar" \
			"${T}/${MY_PN}.jar" || die
		insinto "/usr/share/${MY_PN}/lib"
		doins "${T}/${MY_PN}.jar"
		exeinto "/usr/bin"
		doexe "${FILESDIR}/${MY_PN}-java"
		cp -f \
			"${d_src}/readme.md" \
			"${T}/native-readme.md" || die
		docinto "readmes"
		dodoc "${T}/native-readme.md"
	fi

	if use closure_compiler_nodejs ; then
		export NPM_INSTALL_PATH="/opt/${MY_PN}"
		insinto "${NPM_INSTALL_PATH}"
		pushd ../ || die
		doins -r "node_modules" "package.json" "yarn.lock"
		popd
		insinto "${NPM_INSTALL_PATH}/packages"
		local d_prefix="google-${MY_PN}"
		doins -r "${d_prefix}"
		doins -r "${d_prefix}-java"
		fperms 0755 "${NPM_INSTALL_PATH}/packages/${d_prefix}/cli.js"
		exeinto "/usr/bin"
		cp -f \
			"${FILESDIR}/${MY_PN}-node" \
			"${T}/${MY_PN}-node" \
			|| die
		sed -i \
			-e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
			"${T}/${MY_PN}-node" \
			|| die
		doexe "${T}/${MY_PN}-node"
		local dir_paths=$(
			$(find "${ED}/${NPM_INSTALL_PATH}" \
				-name ".bin" -type d)
		)
		local dir_path
		for dir_path in ${dir_paths} ; do
			local file_abs_path
			for file_abs_path in $(find "${dir_path}") ; do
				chmod 0755 $(realpath "${file_abs_path}") \
					|| die
			done
		done
	fi

	if use closure_compiler_native ; then
		exeinto "/usr/bin"
		local d_src="google-${MY_PN}-linux"
		mv "${d_src}"/{"compiler","${MY_PN}"}
		doexe "${d_src}/${MY_PN}"
		cp -f \
			"${d_src}/readme.md" \
			"${T}/native-readme.md" || die
		docinto "readmes"
		dodoc "${T}/native-readme.md"
	fi
	popd
	docinto "licenses"
	dodoc "LICENSE"
	docinto "readmes"
	dodoc "README.md"
}

pkg_postinst() {
	if use closure_compiler_nodejs || use closure_compiler_java; then
ewarn
ewarn "You need to switch user/system java-vm to == ${JAVA_SLOT_CLOSURE_COMPILER} before using ${PN}"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
