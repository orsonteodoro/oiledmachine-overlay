# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# TODO:  complete bazel offline install.  The java implementation is not unpacking completely offline.  For practical solution, just do partial offline?
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

MY_PN="closure-compiler"

export COMPILER_NIGHTLY="false"
export FORCE_COLOR=1
CLOSURE_COMPILER_MAJOR_VER=$(ver_cut 1 "${PV}")
FN_DEST="${PN}-${PV}.tar.gz"
FN_DEST2="${PN%-*}-${PV}.tar.gz"
JAVA_SLOT_BAZEL="11"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L26
JAVA_SLOT_CLOSURE_COMPILER="11"							# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L26
NODE_ENV="development"
NODE_SLOT="18"

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
BAZEL_PV="5.3.0"								# https://github.com/google/closure-compiler/blob/v20240317/.bazelversion
BAZEL_SLOT="${BAZEL_PV%.*}" # This row must go after BAZEL_PV.
BAZEL_SKYLIB_PV="1.4.2"								# https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/repositories.bzl#L17
CHECKER_QUAL_PV="3.33.0"							# https://github.com/google/guava/blob/v32.1.2/pom.xml#L304
COURSIER_PV="2.1.8"								# https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/MODULE.bazel#L68
ERROR_PRONE_2_15_PV="2.15.0"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L11
ERROR_PRONE_2_18_PV="2.18.0"							# https://github.com/google/guava/blob/v32.1.2/pom.xml#L309
FAILUREACCESS_PV="1.0.1"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L12
GRAALVM_JAVA_PV="17"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L96
GRAALVM_PV="22.3.2"								# https://github.com/google/closure-compiler-npm/blob/v20240317.0.0/.github/workflows/build.yml#L95
GSON_PV="2.9.1"									# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L10
GUAVA26_PV="26.0"								# https://github.com/google/guava/blob/v32.1.2/futures/failureaccess/pom.xml#L8
GUAVA32_PV="32.1.2"								# https://github.com/google/closure-compiler/blob/v20240317/license_check/maven_artifacts.bzl#L8
GUAVA33_PV="33.0.0"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L13
GUAVA_BETA_CHECKER_PV="1.0"							# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L133 https://github.com/google/jimfs/blob/v1.2/pom.xml#L229
HAMCREST_PV="1.3"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L273 https://github.com/junit-team/junit4/blob/r4.13.2/pom.xml#L98
J2OBJC_PV="2.8"									# https://github.com/google/guava/blob/v32.1.2/pom.xml#L314
JAVA_DIFF_UTILS_PV="4.12"							# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L20
JAVA_TOOLS_PV="11.11"								# https://github.com/bazelbuild/rules_java/blob/5.4.1/java/repositories.bzl#L28
JIMFS_PV="1.2"									# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L15
JSPECIFY_PV="0.2.0"								# https://github.com/google/closure-compiler/blob/v20240317/maven_artifacts.bzl#L22
JSR256_PV="1.0"									# https://github.com/google/gson/blob/gson-parent-2.9.1/extras/pom.xml#L35
JSR305_PV="3.0.2"								# https://github.com/google/guava/blob/v32.1.2/pom.xml#L299
JUNIT_PV="4.13.2"								# https://github.com/google/bazel-common/blob/65f295afec03cce3807df5b06ef42bf8e46df4e4/workspace_defs.bzl#L232 https://github.com/google/guava/blob/v33.0.0/guava-testlib/pom.xml#L42 https://github.com/google/truth/blob/v1.4.0/pom.xml#L81
LISTENABLEFUTURE_PV="9999.0"							# https://github.com/google/guava/blob/v32.1.3/guava/module.json#L40

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

EGIT_BAZEL_COMMON_COMMIT="65f295afec03cce3807df5b06ef42bf8e46df4e4"		# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L57
EGIT_BAZEL_JAR_JAR_COMMIT="171f268569384c57c19474b04aebe574d85fde0d"		# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L74
EGIT_RULES_CC_COMMIT="b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e"			# https://github.com/bazelbuild/rules_proto/blob/4.0.0/proto/private/dependencies.bzl#L102 with https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L35
EGIT_RULES_PROTO_COMMIT="7e4afce6fe62dbff0a4a03450143146f9f2d7488"		# https://github.com/bazelbuild/buildtools/blob/5.1.0/WORKSPACE with https://github.com/bazelbuild/rules_jvm_external/blob/77c3538b33cf195879b337fd48c480b77815b9a0/MODULE.bazel#L94 ; 2 tarballs needed from this project
EGIT_RULES_JVM_EXTERNAL_COMMIT="77c3538b33cf195879b337fd48c480b77815b9a0"	# https://github.com/google/closure-compiler/blob/v20240317/WORKSPACE.bazel#L18

BAZELISK_ABIS=(
	"amd64"
	"arm64"
)

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

inherit bazel check-reqs java-pkg-opt-2 graalvm npm yarn

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

#KEYWORDS="~amd64 ~arm64" # This ebuild is broken and unfinished.
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${CLOSURE_COMPILER_MAJOR_VER}"
SRC_URI="
$(gen_bazelisk_src_uris)
$(graalvm_gen_base_uris)
$(graalvm_gen_native_image_uris)
${bazel_external_uris}
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
	ebuild_revision_2
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
		>=net-libs/nodejs-${NODE_SLOT}:${NODE_SLOT}
		>=net-libs/nodejs-${NODE_SLOT}[npm]
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
	>=net-libs/nodejs-${NODE_SLOT}:${NODE_SLOT}
	>=net-libs/nodejs-${NODE_SLOT}[npm]
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
	"bazel-${BAZEL_SLOT}" --version | grep -q "bazel ${BAZEL_PV%.*}" || die "=dev-build/bazel:${BAZEL_PV%.*} not installed"
	local bazel_pv=$("bazel-${BAZEL_SLOT}" --version \
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
	java-pkg_ensure-vm-version-eq "${JAVA_SLOT_CLOSURE_COMPILER}"
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
eerror "Missing mvn.  Install dev-java/maven-bin"
		die
	fi

	# Do not make conditional.
	npm_pkg_setup
	yarn_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	bazel_setup_bazelrc
}

npm_update_lock_audit_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
einfo "Fixing vulnerabilities"
		patch_lockfiles() {
			sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"nanoid\": \"3.1.20\"|\"nanoid\": \"^3.1.31\"|g" "package-lock.json" || die
			sed -i -e "s|\"serialize-javascript\": \"5.0.1\"|\"serialize-javascript\": \"^6.0.2\"|g" "package-lock.json" || die
			sed -i -e "s|\"serialize-javascript\": \"6.0.0\"|\"serialize-javascript\": \"^6.0.2\"|g" "package-lock.json" || die
		}
		patch_lockfiles

		enpm install "braces@3.0.3" -D -w "packages/google-closure-compiler" --prefer-offline			# CVE-2024-4068; DoS; High
ewarn "QA:  Manually remove node_modules/gulp-mocha/node_modules/nanoid in ${S}/package-lock.json"
		enpm install "nanoid@3.1.31" -D -w "packages/google-closure-compiler" --prefer-offline			# CVE-2021-23566; ID; Medium
		enpm install "serialize-javascript@^6.0.2" -D --prefer-offline						# CVE-2024-11831; DT, ID; Medium
		patch_lockfiles
	fi
}

src_unpack() {
	unpack "${FN_DEST}"
	unpack "${FN_DEST2}"

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
	for abi in "${BAZELISK_ABIS[@]}" ; do
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
	touch "dummy" || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag "v${PV}" || die

	if grep -e "Read timed out" "${T}/build.log" ; then
eerror "Download failure detected.  Re-emerge."
		die
	fi
	if grep -e "Error downloading" "${T}/build.log" ; then
eerror "Download failure detected.  Re-emerge."
		die
	fi
	if grep -e "Build did NOT complete successfully" "${T}/build.log" ; then
eerror "Build failure detected.  Re-emerge."
		die
	fi
	if grep -e "ERROR:" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
	if grep -e "exitCode:" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
	if grep -e "Exit code:" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
	if grep -F -e "cb() never called!" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
}

src_prepare() {
	default
	java-pkg-opt-2_src_prepare

	local x
	for x in "${MAVEN_TARBALLS[@]}" ; do
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
	node "./build-scripts/build_compiler.js" || die # Part 2/2 of _build_compiler_jar

	if grep -q -F -e "ERROR:" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
}

_build_native_image() {
einfo "Building native image (1/2)"
	enpm run build "${extra_args[@]}"
	_npm_check_errors

	export PATH="${WORKDIR}/graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-${GRAALVM_PV}/bin:${PATH}"
	java -version 2>&1 | grep -q "GraalVM.*${GRAALVM_PV}" || die

einfo "Building native image (2/2)"
	eyarn workspaces run build
	_npm_check_errors
	_yarn_check_errors

	if grep -q -F -e "Error while fetching artifact" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
	if grep -q -F -e "Error: Invalid or corrupt jarfile" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
		die
	fi
	if grep -q -F -e "Error: non-zero exit code 1" "${T}/build.log" ; then
eerror "Failure detected.  Re-emerge."
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
		pushd "../" >/dev/null 2>&1 || die
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
			-e "s|@LIBDIR@|$(get_libdir)|g" \
			-e "s|@NODE_SLOT@|${NODE_SLOT}|g" \
			"${T}/${MY_PN}-node" \
			|| die
		doexe "${T}/${MY_PN}-node"
		IFS=$'\n'
		local dir_paths=(
			$(find "${ED}/${NPM_INSTALL_PATH}" -name ".bin" -type d)
		)
		IFS=$' \t\n'
		local dir_path
		for dir_path in "${dir_paths[@]}" ; do
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
ewarn "You need to switch user/system java-vm to == ${JAVA_SLOT_CLOSURE_COMPILER} before using ${PN}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
