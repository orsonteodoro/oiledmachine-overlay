# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_ENV=development
NODE_VERSION=14 # Upstream uses 14 on linux but others 16, 18
inherit check-reqs java-utils-2 npm-secaudit

DESCRIPTION="Check, compile, optimize and compress Javascript with \
Closure-Compiler"
HOMEPAGE="https://developers.google.com/closure/compiler/"

GRAAL_VM_CE_LICENSES="
	GraalVM_CE_22.3_LICENSE
	GraalVM_CE_22.3_LICENSE_NATIVEIMAGE
	GraalVM_CE_22.3_THIRD_PARTY_LICENSE
	UPL-1.0
	GPL-2-with-classpath-exception
	( MIT all-rights-reserved )
	Apache-2.0
	BSD
	BSD-2
	CPL-1.0
	CDDL
	CDDL-1.1
	CC0-1.0
	EPL-1.0
	EPL-2.0
	icu-68.1
	JDOM
	JSON
	LGPL-2.1
	LGPL-2.1+
	MIT
	NAIST-IPADIC
	unicode
	Unicode-DFS-2016
	W3C
	W3C-Software-Notice-and-License
	W3C-Software-and-Document-Notice-and-License
	W3C-Software-and-Document-Notice-and-License-20021231
	|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )
	|| ( Apache-2.0 GPL-2+-with-classpath-exception )
" # It includes third party licenses.

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
# https://github.com/google/closure-compiler-npm/blob/v20230103.0.0/packages/google-closure-compiler/package.json
# For dependencies, see
# https://github.com/google/closure-compiler-npm/blob/v20230103.0.0/.github/workflows/build.yml
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
GRAALVM_CE_DEPENDS="
	sys-devel/gcc[cxx]
	sys-libs/glibc
	sys-libs/zlib
"
BDEPEND+="
	${JDK_DEPEND}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	dev-java/maven-bin
	dev-vcs/git
	sys-apps/yarn
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
GRAAL_VM_CE_PV="22.3.0"
GRAAL_VM_CE_JAVA_VER="17"
gen_bazelisk_src_uris() {
	for abi in ${BAZELISK_ABIS} ; do
		echo "
	${abi}? (
https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_PV}/bazelisk-linux-${abi}
	-> bazelisk-linux-${abi}-${BAZELISK_PV}
	)
		"
	done
}
declare -A GRAALVM_ABIS=(
	[amd64]="amd64"
	[arm64]="aarch64"
)

gen_graalvm_ce_uris() {
	for abi in ${!GRAALVM_ABIS[@]} ; do
		echo "
	${abi}? (
		closure_compiler_native? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VM_CE_PV}/graalvm-ce-java${GRAAL_VM_CE_JAVA_VER}-linux-${GRAALVM_ABIS[${abi}]}-${GRAAL_VM_CE_PV}.tar.gz
		)
	)
		"
	done
}
SRC_URI="
https://github.com/google/closure-compiler-npm/archive/v${PV}.tar.gz
	-> ${FN_DEST}
https://github.com/google/closure-compiler/archive/v${CC_PV}.tar.gz
	-> ${FN_DEST2}
"
SRC_URI+="
	$(gen_bazelisk_src_uris)
	$(gen_graalvm_ce_uris)
"
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${CC_PV}"
RESTRICT="mirror"

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
	if ! [[ "${CLOSURE_COMPILER_NPM_LD_PRELOAD_RISKS}" =~ ("allow"|"accept") ]] ; then
# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe reported by Bazel.
eerror
eerror "Precaution taken..."
eerror
eerror "LD_PRELOAD gets ignored by a build tool which could make the"
eerror "ebuild sandbox ineffective.  Set one of the following as a per-package"
eerror "environment variable:"
eerror
eerror "CLOSURE_COMPILER_NPM_LD_PRELOAD_RISKS=\"allow\"     # to continue and consent to accepting risks"
eerror "CLOSURE_COMPILER_NPM_LD_PRELOAD_RISKS=\"deny\"      # to stop (default)"
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
		die
	fi
	npm-secaudit_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if [[ ! -e "/usr/include/node/node_version.h" ]] ; then
eerror
eerror "Use eselect nodejs to fix missing header location."
eerror
		die
	fi
	if [[ "${NPM_UTILS_ALLOW_AUDIT}" != "0" ]] ; then
eerror
eerror "NPM_UTILS_ALLOW_AUDIT=0 needs to be added as a per-package envvar"
eerror
		die
	fi
}

attach_graalvm_ce() {
	export GRAALVM_HOME="${WORKDIR}/graalvm-ce-java${GRAAL_VM_CE_JAVA_VER}-${GRAAL_VM_CE_PV}"
	export PATH="${WORKDIR}/graalvm-ce-java${GRAAL_VM_CE_JAVA_VER}-${GRAAL_VM_CE_PV}/bin:${PATH}"
	export JAVA_HOME="${WORKDIR}/graalvm-ce-java${GRAAL_VM_CE_JAVA_VER}-${GRAAL_VM_CE_PV}"
einfo "GRAALVM_HOME:\t${GRAALVM_HOME}"
einfo "PATH:\t${PATH}"
einfo "JAVA_HOME:\t${JAVA_HOME}"
	java -version 2>&1 | grep -q "GraalVM CE ${GRAAL_VM_CE_PV}" || die
	gu install native-image || die
}

src_unpack() {
	unpack ${A}
	if use closure_compiler_native ; then
		attach_graalvm_ce
	fi
	rm -rf "${S}/compiler" || die
	mv "${S_CLOSURE_COMPILER}" \
		"${S}/compiler" || die

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

	npm-secaudit_src_unpack

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
		local d_node="/opt/${MY_PN}"
		insinto "${d_node}"
		pushd ../ || die
		doins -r node_modules package.json yarn.lock
		popd
		insinto "${d_node}/packages"
		local d_prefix="google-${MY_PN}"
		doins -r "${d_prefix}"
		doins -r "${d_prefix}-java"
		fperms 0755 "${d_node}/packages/${d_prefix}/cli.js"
		exeinto /usr/bin
		cp -f "${FILESDIR}/${MY_PN}-node" \
			"${T}/${MY_PN}-node" || die
		sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${NODE_SLOT}|${NODE_SLOT}|g" \
			-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
			"${T}/${MY_PN}-node" || die
		doexe "${T}/${MY_PN}-node"
		for dir_path in $(find "${ED}/${d_node}" \
				-name ".bin" -type d) ; do
			for file_abs_path in $(find "${dir_path}") ; do
				chmod 0755 $(realpath "${file_abs_path}") \
					|| die
			done
		done
		export NPM_SECAUDIT_INSTALL_PATH="${d_node}"
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
