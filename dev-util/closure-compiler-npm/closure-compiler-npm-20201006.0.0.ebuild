# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Check, compile, optimize and compress Javascript with Closure-Compiler"
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
SLOT="0/${PV}"
NODE_SLOT="0"
MY_PN="closure-compiler"
JAVA_V="1.8"
IUSE="closure_compiler_java closure_compiler_js \
closure_compiler_nodejs closure_compiler_native doc"
REQUIRED_USE="closure_compiler_nodejs? ( closure_compiler_java )
|| ( closure_compiler_java closure_compiler_js closure_compiler_nodejs \
closure_compiler_native )"
# For the node version, see
# https://github.com/google/closure-compiler-npm/blob/master/packages/google-closure-compiler/package.json
NODE_V="10"
CDEPEND="closure_compiler_nodejs? ( >=net-libs/nodejs-${NODE_V} )"
RDEPEND="${CDEPEND}
	!dev-lang/closure-compiler-bin
	closure_compiler_java? (
		>=virtual/jre-${JAVA_V}
	)
	closure_compiler_nodejs? (
		>=virtual/jre-${JAVA_V}
	)"
DEPEND="${CDEPEND}
	|| (
		>=virtual/jre-${JAVA_V}
		>=virtual/jdk-${JAVA_V}
	)"
BDEPEND="dev-java/maven-bin
	sys-apps/yarn"
inherit check-reqs eutils java-utils-2 npm-secaudit
FN_DEST="${PN}-${PV}.tar.gz"
CLOSURE_COMPILER_COMMIT="17f14e8fd09e503328d55cdcce7ae5d6be33a9be"
FN_DEST2="closure-compiler-${CLOSURE_COMPILER_COMMIT}.tar.gz"
SRC_URI=\
"https://github.com/google/closure-compiler-npm/archive/v${PV}.tar.gz \
	-> ${FN_DEST}
https://github.com/google/closure-compiler/archive/${CLOSURE_COMPILER_COMMIT}.tar.gz \
	-> ${FN_DEST2}"
S="${WORKDIR}/${PN}-${PV}"
S_CLOSURE_COMPILER="${WORKDIR}/closure-compiler-${CLOSURE_COMPILER_COMMIT}"
RESTRICT="mirror"

_set_check_reqs_requirements() {
	CHECKREQS_DISK_BUILD="1688M"
	CHECKREQS_DISK_USR="315M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

pkg_setup() {
	java-pkg_init
	if [[ -n "${JAVA_HOME}" && -f "${JAVA_HOME}/bin/java" ]] ; then
		export JAVA="${JAVA_HOME}/bin/java"
	else
		die \
"JAVA_HOME is set to ${JAVA_HOME} but cannot locate ${JAVA_HOME}/bin/java.\n\
Use \`eselect java-vm\` to set this up."
	fi
	java-pkg_ensure-vm-version-ge ${JAVA_V}

	if ! which mvn 2>/dev/null 1>/dev/null ; then
		die "Missing mvn.  Install dev-java/maven-bin"
	fi

	if has network-sandbox $FEATURES ; then
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download micropackages."
	fi
	npm-secaudit_pkg_setup

	_set_check_reqs_requirements
	check-reqs_pkg_setup
	if use closure_compiler_nodejs ; then
		# Check nodejs still in a multislot scenario
		X_NODE_V=$(node --version | grep -E -o -e "[0-9.]+" | cut -f 1 -d ".")
		if ver_test "${X_NODE_V}" -lt "${NODE_V}" ; then
			die \
"Your active nodejs needs to be at least >=${NODE_V}.  See \`eselect nodejs\`"
		else
			einfo "NODE_V:  ${NODE_V}"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/compiler" || die
	ln -s "${S_CLOSURE_COMPILER}" \
		"${S}/compiler" || die

	if ! use closure_compiler_java ; then
		rm -rf "${S}/packages/google-closure-compiler-java" || die
	fi
	if ! use closure_compiler_js ; then
		rm -rf "${S}/packages/google-closure-compiler-js" || die
	fi
	if ! use closure_compiler_native ; then
		rm -rf "${S}/packages/google-closure-compiler-linux" || die
	fi
	if ! use closure_compiler_nodejs ; then
		rm -rf "${S}/packages/google-closure-compiler" || die
	fi
	rm -rf "${S}/packages/google-closure-compiler-osx" || die
	rm -rf "${S}/packages/google-closure-compiler-windows" || die
	# Fetches and builds the closure compiler here.
	npm-secaudit_src_unpack
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
		local d_node="/usr/$(get_libdir)/node/${MY_PN}/${NODE_SLOT}"
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
		for dir_path in $(find "${ED}/${d_node}" -name ".bin" -type d) ; do
			for file_abs_path in $(find "${dir_path}") ; do
				chmod 0755 $(realpath "${file_abs_path}") || die
			done
		done
		export NPM_SECAUDIT_REG_PATH="${d_node}"
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
