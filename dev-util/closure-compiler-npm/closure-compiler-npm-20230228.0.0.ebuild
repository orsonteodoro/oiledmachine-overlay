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
inherit bazel check-reqs java-utils-2 graalvm npm

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
#   grep "resolved" /var/tmp/portage/dev-util/closure-compiler-npm-20230228.0.0/work/closure-compiler-npm-20230228.0.0/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
"
# UPDATER_END_NPM_EXTERNAL_URIS
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
${NPM_EXTERNAL_URIS}
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
	npm_pkg_setup

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
eerror "Testing npm offline install."
die
	unpack ${FN_DEST}
	unpack ${FN_DEST2}

	bazel_load_distfiles "${bazel_external_uris}"

	if use closure_compiler_native ; then
		unpack $(graalvm_get_base_tarball_name)
		graalvm_attach_graalvm
	fi

	# Do not make this section conditional.
	npm_src_unpack

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
	npm_src_compile
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
		export NPM_INSTALL_PATH="/opt/${MY_PN}"
		insinto "${NPM_INSTALL_PATH}"
		pushd ../ || die
		doins -r node_modules package.json npm.lock
		popd
		insinto "${NPM_INSTALL_PATH}/packages"
		local d_prefix="google-${MY_PN}"
		doins -r "${d_prefix}"
		doins -r "${d_prefix}-java"
		fperms 0755 "${NPM_INSTALL_PATH}/packages/${d_prefix}/cli.js"
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
		for dir_path in $(find "${ED}/${NPM_INSTALL_PATH}" \
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
