# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs eutils java-utils-2 npm-secaudit

DESCRIPTION="Check, compile, optimize and compress Javascript with \
Closure-Compiler"
HOMEPAGE="https://developers.google.com/closure/compiler/"
LICENSE="
	Apache-2.0
	BSD
	CPL-1.0
	GPL-2+
	LGPL-2.1+
	MIT
	MPL-2.0
	NPL-1.1"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
PV_CC=$(ver_cut 1 ${PV})
SLOT="0/${PV}"
NODE_SLOT="0"
MY_PN="closure-compiler"
JAVA_V="11"
IUSE+="	closure_compiler_java
	closure_compiler_js
	closure_compiler_native
	closure_compiler_nodejs
	doc"
REQUIRED_USE+="
	closure_compiler_nodejs? ( closure_compiler_java )
	|| (	closure_compiler_java
		closure_compiler_js
		closure_compiler_native
		closure_compiler_nodejs	)"
# For the node version, see
# https://github.com/google/closure-compiler-npm/blob/v20220104.0.0/packages/google-closure-compiler/package.json
# For dependencies, see
# https://github.com/google/closure-compiler-npm/blob/v20220104.0.0/.github/workflows/build.yml
NODE_V="14" # Upstream uses 14 on linux but others 10, 12
CDEPEND="closure_compiler_nodejs? ( >=net-libs/nodejs-${NODE_V} )"
JDK_DEPEND="
|| (
	dev-java/openjdk-bin:${JAVA_V}
	dev-java/openjdk:${JAVA_V}
)"
JRE_DEPEND="
|| (
	${JDK_DEPEND}
	dev-java/openjdk-jre-bin:${JAVA_V}
)"
#JDK_DEPEND=" virtual/jdk:${JAVA_V}"
#JRE_DEPEND=" virtual/jre:${JAVA_V}"
# The virtual/jdk not virtual/jre must be in DEPENDs for the eclass not to be stupid.
RDEPEND+=" ${CDEPEND}
	!dev-lang/closure-compiler-bin
	closure_compiler_java? (
		${JRE_DEPEND}
	)
	closure_compiler_nodejs? (
		${JRE_DEPEND}
	)"
DEPEND+=" ${RDEPEND}
	${JDK_DEPEND}"
BDEPEND+=" ${CDEPEND}
	${JDK_DEPEND}
	dev-java/maven-bin
	>=dev-util/bazel-3.4.1
	dev-vcs/git
	sys-apps/yarn"
FN_DEST="${PN}-${PV}.tar.gz"
FN_DEST2="closure-compiler-${PV}.tar.gz"
SRC_URI="
https://github.com/google/closure-compiler-npm/archive/v${PV}.tar.gz
	-> ${FN_DEST}
https://github.com/google/closure-compiler/archive/v${PV_CC}.tar.gz
	-> ${FN_DEST2}"
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${PV_CC}"
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

	if find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
		die "dev-java/openjdk:${JDK_V} or dev-java/openjdk-bin:${JDK_V} must be installed"
	fi
}

pkg_setup() {
	setup_openjdk

	einfo "JAVA_HOME=${JAVA_HOME}"
	einfo "PATH=${PATH}"

	# java-pkg_init

	# the eclass/eselect system is broken
	X_JDK_V=$(best_version "dev-java/openjdk-bin:${JAVA_V}" | sed -e "s|dev-java/openjdk-bin-||g" -e "s|-r[0-9]$||g")
	export JAVA_HOME="/opt/openjdk-bin-${X_JDK_V}" # basedir

	einfo "JAVA_HOME=${JAVA_HOME}"
	if [[ -n "${JAVA_HOME}" && -f "${JAVA_HOME}/bin/java" ]] ; then
		export JAVA="${JAVA_HOME}/bin/java"
	else
eerror
eerror "JAVA_HOME is set to ${JAVA_HOME} but cannot locate ${JAVA_HOME}/bin/java."
eerror
		die
	fi

	if ver_test ${X_JDK_V} -lt ${JAVA_V} ; then
		die "You must have OpenJDK >= ${JAVA_V}.  Best is ${X_JDK_V}."
	fi

	if ! which mvn 2>/dev/null 1>/dev/null ; then
		die "Missing mvn.  Install dev-java/maven-bin"
	fi

	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to download micropackages."
eerror
		die
	fi
	npm-secaudit_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	ewarn
	ewarn "Re-emerge if it randomly fails with message: cb() never called!"
	ewarn "Re-emerge if exitCode: 18 when downloading graal image for google-closure-compiler-linux."
	ewarn
}

src_unpack() {
	unpack ${A}
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

	einfo "Adding package-lock.json file from project root."
	npm i --package-lock-only || die
	[[ ! -f package-lock.json ]] && die "Missing package-lock.json from dir=$(pwd)"

	if use closure_compiler_nodejs ; then
		pushd packages/google-closure-compiler || die
			einfo "Adding package-lock.json file for closure_compiler_nodejs package."
			npm i --package-lock-only || die
			[[ ! -f package-lock.json ]] && die "Missing package-lock.json from dir=$(pwd)"
		popd
	fi

	npm-secaudit_src_unpack

	if grep -e "Read timed out" "${T}/build.log" ; then
		die "Detected download failure.  Re-emerge."
	fi
	if grep -e "Error downloading" "${T}/build.log" ; then
		die "Detected download failure.  Re-emerge."
	fi
	if grep -e "Build did NOT complete successfully" "${T}/build.log" ; then
		die "Detected build failure.  Re-emerge."
	fi
	if grep -i -e "ERROR:" "${T}/build.log" ; then
		die "Detected a failure.  Re-emerge."
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
}

pkg_postinst() {
	if use closure_compiler_nodejs ; then
		npm-secaudit_pkg_postinst
	fi
}
