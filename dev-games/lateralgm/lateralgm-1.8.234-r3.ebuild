# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

DESCRIPTION="A free game maker source file editor"
LICENSE="
	GPL-3+
	libmaker? (
		GPL-3+
	)
"
# lgmplugin is GPL-3+
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
HOMEPAGE="http://lateralgm.org/"
SLOT="0"
IUSE+=" libmaker"

JAVA_SLOT="1.8"
JAVA_SRC_VER="1.7"
JVM_VER="1.8"

# Merged libmaker and lgmplugin to let others find them easier.

JNA_SLOT="4"
DEPEND_LATERALGM="
	virtual/jre:${JAVA_SLOT}
"
DEPEND_LGMPLUGIN="
	>=dev-java/jna-5.8:4=[nio-buffers(+)]
	virtual/jre:${JAVA_SLOT}
"
DEPEND_LIBMAKER="
	virtual/jre:${JAVA_SLOT}
"
CDEPEND="
	${DEPEND_LATERALGM}
	${DEPEND_LGMPLUGIN}
	libmaker? (
		${DEPEND_LIBMAKER}
	)
"
DEPEND+="
	${CDEPEND}
	virtual/jdk:${JAVA_SLOT}
"
RDEPEND+="
	${CDEPEND}
	dev-games/enigma:0/lateralgm-d18d1c0
"
BDEPEND_LATERALGM="
	virtual/jdk:${JAVA_SLOT}
	dev-java/maven-bin
"
BDEPEND_LGMPLUGIN="
	virtual/jdk:${JAVA_SLOT}
"
BDEPEND_LIBMAKER="
	virtual/jdk:${JAVA_SLOT}
"
BDEPEND+="
	${BDEPEND_LATERALGM}
	${BDEPEND_LGMPLUGIN}
	libmaker? (
		${BDEPEND_LIBMAKER}
	)
"

EGIT_COMMIT_LIBMAKER="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
EGIT_COMMIT_JE_LATERALGM="487ddbe470032124dcb50ebee01a24b600ae900e"
EGIT_COMMIT_JE_LIBMAKER="5844d7f047eac15408f7ccf8a9183d2015b962e0" # \
# dated 20120417, this is required because of namespace changes, KeywordSet \
# changes, fails to build
LGMPLUGIN_VER="1.8.227r3" # \
# lgmplugin updates can be found at: \
# https://github.com/enigma-dev/lgmplugin/tags

MY_PN_LATERALGM="LateralGM"
MY_PN_LIBMAKER="LibMaker"
MY_PN_LGMPLUGIN="LateralGM Plugin"
MY_PN_JOSHEDIT="JoshEdit"
JE_LATERALGM_FN="${MY_PN_JOSHEDIT}-${EGIT_COMMIT_JE_LATERALGM:0:7}.tar.gz"
JE_LIBMAKER_FN="${MY_PN_JOSHEDIT}-${EGIT_COMMIT_JE_LIBMAKER:0:7}.tar.gz"
LGMPLUGIN_FN="lgmplugin-${LGMPLUGIN_VER}.tar.gz"
LIBMAKER_FN="${MY_PN_LIBMAKER}-${EGIT_COMMIT_LIBMAKER:0:7}.tar.gz"
BASE_URI_ED="https://github.com/enigma-dev"
BASE_URI_IA="https://github.com/IsmAvatar"
BASE_URI_JD="https://github.com/JoshDreamland"

SRC_URI_LATERALGM="
${BASE_URI_IA}/${MY_PN_LATERALGM}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
${BASE_URI_JD}/JoshEdit/archive/${EGIT_COMMIT_JE_LATERALGM}.tar.gz
	-> ${JE_LATERALGM_FN}
"
SRC_URI_LIBMAKER="
${BASE_URI_IA}/${MY_PN_LIBMAKER}/archive/${EGIT_COMMIT_LIBMAKER}.tar.gz
	-> ${LIBMAKER_FN}
${BASE_URI_JD}/${MY_PN_JOSHEDIT}/archive/${EGIT_COMMIT_JE_LIBMAKER}.tar.gz
	-> ${JE_LIBMAKER_FN}
"

SRC_URI_LGMPLUGIN="
${BASE_URI_ED}/lgmplugin/archive/refs/tags/v${LGMPLUGIN_VER}.tar.gz
	-> ${LGMPLUGIN_FN}
"

SRC_URI="
	${SRC_URI_LATERALGM}
	${SRC_URI_LGMPLUGIN}
	libmaker? ( ${SRC_URI_LIBMAKER} )
"
RESTRICT="mirror"
S_LATERALGM="${WORKDIR}/${MY_PN_LATERALGM}-${PV}"
S_LIBMAKER="${WORKDIR}/${MY_PN_LIBMAKER}-${EGIT_COMMIT_LIBMAKER}"
S_LGMPLUGIN="${WORKDIR}/lgmplugin-${LGMPLUGIN_VER}"
S_JOSHEDIT_FOR_LIBMAKER="${WORKDIR}/${MY_PN_JOSHEDIT}-${EGIT_COMMIT_JE_LIBMAKER}"
S_JOSHEDIT_FOR_LATERALGM="${WORKDIR}/${MY_PN_JOSHEDIT}-${EGIT_COMMIT_JE_LATERALGM}"
S="${S_LATERALGM}"
JNA_PATH="/usr/share/jna-${JNA_SLOT}/lib/jna.jar"

pkg_setup()
{
	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	export JVM_VER=$(java-pkg_get-target)

	# Fixes:
#./org/lateralgm/main/LGM.java:105: error: cannot access ProjectFile
#import org.lateralgm.file.ProjectFile;
#                         ^
#  bad class file: ./org/lateralgm/file/ProjectFile.class
#    class file contains wrong class: org.lateralgm.components.mdi.MDIPane
#    Please remove or make sure it appears in the correct subdirectory of the classpath.
#make: *** [Makefile:6: org/lateralgm/ui/swing/propertylink/DocumentLink.class] Error 1
#make: *** Waiting for unfinished jobs....
	export MAKEOPTS="-j1"
	[[ -e "${JNA_PATH}" ]] || die "Missing lib or in wrong path."
}

src_unpack_lateralgm()
{
	rm -rf "${S_LATERALGM}/modules/joshedit" || die
}

src_unpack_joshedit_for_lateralgm() {
	mv "${S_JOSHEDIT_FOR_LATERALGM}" \
		"${S_LATERALGM}/modules/joshedit" || die
	export S_JOSHEDIT_FOR_LATERALGM="${S_LATERALGM}/modules/joshedit/src/main"
}

src_unpack_joshedit_for_libmaker() {
	cp -aT "${S_JOSHEDIT_FOR_LIBMAKER}" \
		"${S_LIBMAKER}" || die
	export S_JOSHEDIT_FOR_LIBMAKER="${S_LIBMAKER}"
}

src_unpack() {
	unpack ${A}
	src_unpack_lateralgm
	src_unpack_joshedit_for_lateralgm
	src_unpack_joshedit_for_libmaker
	cp -a "${JNA_PATH}" \
		"${WORKDIR}/jna.jar" || die
}

src_prepare_jna() {
	# See https://github.com/java-native-access/jna/blob/master/build.xml#L506
	local d=""
	if [[ "${CHOST}" =~ "aarch64" ]] ; then
		d="com/sun/jna/linux-aarch64"
#	elif [[ "${CHOST}" =~ "arm_le" ]] ; then
		# QA: redo
#		d="com/sun/jna/linux-armle"
	elif [[ "${CHOST}" =~ "arm" ]] ; then
		d="com/sun/jna/linux-arm"
#	elif [[ "${CHOST}" =~ "armel" ]] ; then
		# QA: redo
#		d="com/sun/jna/linux-armel"
	elif [[ "${CHOST}" =~ "ia64" ]] ; then
		d="com/sun/jna/linux-ia64"
	elif [[ "${CHOST}" =~ "mips64el" ]] ; then
		d="com/sun/jna/linux-mips64el"
	elif [[ "${CHOST}" =~ "powerpc64le" ]] ; then
		d="com/sun/jna/linux-ppc64le"
	elif [[ "${CHOST}" =~ "powerpc64" ]] ; then
		d="com/sun/jna/linux-ppc64"
	elif [[ "${CHOST}" =~ "powerpc" ]] ; then
		d="com/sun/jna/linux-ppc"
	elif [[ "${CHOST}" =~ "riscv64" ]] ; then
		d="com/sun/jna/linux-riscv64"
	elif [[ "${CHOST}" =~ "s390x" ]] ; then
		d="com/sun/jna/linux-s390x"
	elif [[ "${CHOST}" =~ "sparcv9" ]] ; then
		d="com/sun/jna/linux-sparcv9"
	elif [[ "${CHOST}" =~ "loongarch64" ]] ; then
		d="com/sun/jna/linux-loongarch64"
	elif [[ "${CHOST}" =~ "x86_64" ]] ; then
		d="com/sun/jna/linux-x86-64"
	elif [[ "${CHOST}" =~ "x86" ]] ; then
		d="com/sun/jna/linux-x86"
	fi
	[[ -z "${d}" ]] && die "${CHOST} my not be supported"
	local f="libjnidispatch.so"
	# The distro package one doesn't work as expected.
	# This project will package it correctly
	local dest="${WORKDIR}/jna.jar"
	mkdir -p "${WORKDIR}/jna-temp/${d}"
	pushd "${WORKDIR}/jna-temp/" || die
		cp -a /usr/$(get_libdir)/jna-${JNA_SLOT}/libjnidispatch.so \
			"${WORKDIR}/jna-temp/${d}" || die
		jar uvf "${dest}" \
			$(find .) \
			|| die
	popd
}

src_prepare_lateralgm() {
	einfo "Preparing ${MY_PN_LATERALGM}"
	cd "${S_LATERALGM}" || die
	einfo "JAVA_HOME:  ${JAVA_HOME}"
	local bcp="-bootclasspath ${JAVA_HOME}/jre/lib/rt.jar"
	sed -i \
		-e "s|JFLAGS =|JFLAGS = ${bcp} |" \
		-e "s|JFLAGS =|JFLAGS = -Xlint:deprecation -Xlint:unchecked |" \
		"Makefile" || die
	eapply "${FILESDIR}/lateralgm-1.8.227-cast-GMXFileReader.patch"
	ln -s "${S_LATERALGM}" "${WORKDIR}/LateralGM" || die
}

src_prepare_libmaker()
{
	einfo "Preparing ${MY_PN_LIBMAKER}"
	cd "${S_LIBMAKER}" || die
}

src_prepare_lgmplugin() {
	einfo "Preparing ${MY_PN_LGMPLUGIN}"
	cd "${S_LGMPLUGIN}" || die
	local bcp="-bootclasspath ${JAVA_HOME}/jre/lib/rt.jar"
	sed -i \
		-e "s|JFLAGS =|JFLAGS = ${bcp} -Xlint:deprecation |" \
		-e "s|JFLAGS =|JFLAGS = -Xlint:deprecation -Xlint:unchecked |" \
		-e "s|jna.jar|${JNA_BPATH}|" \
		"Makefile" || die
	eapply "${FILESDIR}/lgmplugin-1.8.227r3-use-native-load.patch"
	eapply "${FILESDIR}/lgmplugin-1.8.227r3-disable-compiler-check.patch"
}

src_prepare() {
	export JNA_BPATH="${JNA_PATH}"
	default
	src_prepare_lateralgm
	use libmaker && src_prepare_libmaker
	src_prepare_lgmplugin
	java-pkg-2_src_prepare
}

src_compile_joshedit_for_lateralgm() {
	local dest_fn
	# We cannot use the mvn thing because of sandbox violations.
	einfo "Compiling ${MY_PN_JOSHEDIT} for ${MY_PN_LATERALGM}"
	local dest="${S_LATERALGM}/${PN}.jar"
	pushd "${S_JOSHEDIT_FOR_LATERALGM}" || die
		$(java-pkg_get-javac) \
			-bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" \
			-source 1.7 -target 1.7 \
			-Xlint:deprecation -Xlint:unchecked \
			-nowarn \
			-cp . \
			$(find . -name "*.java") \
			|| die
	popd
	pushd "${S_JOSHEDIT_FOR_LATERALGM}/java" || die
		jar uvf "${dest}" \
			$(find "org" -not -name '*.java') \
			|| die
	popd
	pushd "${S_JOSHEDIT_FOR_LATERALGM}/resources/" || die
		jar uvf "${dest}" \
			$(find "org") \
			|| die
	popd
}

src_compile_joshedit_for_libmaker() {
	local dest_fn
	einfo "Compiling ${MY_PN_JOSHEDIT} for ${MY_PN_LIBMAKER}"
	local dest="${S_LIBMAKER}/${MY_PN_LIBMAKER,,}.jar"
	pushd "${S_JOSHEDIT_FOR_LIBMAKER}/org/lateralgm/joshedit" || die
		$(java-pkg_get-javac) \
			-bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" \
			-source 1.7 -target 1.7 \
			-Xlint:deprecation -Xlint:unchecked \
			-nowarn \
			-cp . \
			$(find . -name "*.java") \
			|| die
	popd
	pushd "${S_JOSHEDIT_FOR_LIBMAKER}" || die
		jar uvf "${dest}" \
			$(find "org" -not -name '*.java') \
			|| die
	popd
}

src_compile_lateralgm()
{
	einfo "Compiling ${MY_PN_LATERALGM}"
	emake jar
}

src_compile_lgmplugin()
{
	# This needs to be integrated because of security of unsigned jars.
	einfo "Compiling ${MY_PN_LGMPLUGIN}"
	emake
}

src_compile_libmaker()
{
	einfo "Compiling ${MY_PN_LIBMAKER}"
#		-source ${JAVA_SRC_VER} -target ${JVM_VER} -nowarn \
	MAKEOPTS="-j1" \
	$(java-pkg_get-javac) \
		-bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" \
		-source 1.7 -target 1.7 \
		-nowarn \
		-cp ".:" \
		$(find . -name "*.java") \
		|| die
	jar cmvf "META-INF/MANIFEST.MF" "${MY_PN_LIBMAKER,,}.jar" \
		$(find . -not -name '*.java') \
		|| die
}

src_compile() {
	S="${S_LATERALGM}"
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	src_prepare_jna
	src_compile_lateralgm
	src_compile_joshedit_for_lateralgm
	touch .compiled || die

	if use libmaker ; then
		S="${S_LIBMAKER}"
		BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
		src_compile_libmaker
		src_compile_joshedit_for_libmaker
	fi

	S="${S_LGMPLUGIN}"
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	src_compile_lgmplugin
}

src_install_lateralgm()
{
	einfo "Installing ${MY_PN_LATERALGM}"
	insinto "/usr/$(get_libdir)/enigma"
	doins "${PN}.jar"
	exeinto "/usr/bin"
	cp "${FILESDIR}/${PN}" \
		"${T}/${PN}" || die
	sed -i -e "s|LIBDIR|$(get_libdir)|g" \
		-e "s|JNA_PATH|${JNA_IPATH}|" \
		"${T}/${PN}" || die
	doexe "${T}/${PN}"
	doicon "org/lateralgm/main/lgm-logo.ico"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN_LATERALGM}" \
		"/usr/share/pixmap/lgm-logo.ico" \
		"Development;IDE"
	docinto "licenses/lateralgm"
	dodoc "COPYING" "LICENSE" "README.md"
	docinto "licenses/fonts/Calico"
	dodoc "org/lateralgm/icons/Calico/LICENSE"
}

src_install_lgmplugin()
{
	einfo "Installing ${MY_PN_LGMPLUGIN}"
	insinto "/usr/$(get_libdir)/enigma/plugins"
	doins "enigma.jar"
	cd "${S_LATERALGM}" || die
	docinto "licenses/lgmplugin"
	dodoc "COPYING" "LICENSE" "README.md"
	docinto "licenses/fonts/calico"
	dodoc "org/lateralgm/icons/Calico/LICENSE"
	insinto "/usr/$(get_libdir)/enigma/plugins/shared"
	doins "${WORKDIR}/jna.jar"
}

src_install_libmaker()
{
	einfo "Installing ${MY_PN_LIBMAKER}"
	insinto "/usr/$(get_libdir)/enigma"
	doins "${MY_PN_LIBMAKER,,}.jar"
	exeinto "/usr/bin"
	cat "${FILESDIR}/${MY_PN_LIBMAKER,,}" \
		> "${T}/${MY_PN_LIBMAKER,,}" || die
	sed -i -e "s|LIBDIR|$(get_libdir)|g" \
		-e "s|JNA_PATH|${JNA_IPATH}|" \
		"${T}/${MY_PN_LIBMAKER,,}" || die
	doexe "${T}/${MY_PN_LIBMAKER,,}"
	doicon \
"${S_LIBMAKER}/org/lateralgm/${MY_PN_LIBMAKER,,}/icons/lgl-128.png"
	make_desktop_entry \
		"/usr/bin/${MY_PN_LIBMAKER,,}" \
		"${MY_PN_LIBMAKER}" \
		"/usr/share/pixmaps/lgl-128.png" \
		"Utility;FileTools"
	docinto "licenses/libmaker"
	dodoc "COPYING" "LICENSE" "README"
}

src_install() {
	export JNA_IPATH="/usr/$(get_libdir)/enigma/plugins/shared/jna.jar"
	S="${S_LATERALGM}"
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	src_install_lateralgm

	if use libmaker ; then
		S="${S_LIBMAKER}"
		BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
		src_install_libmaker
	fi

	S="${S_LGMPLUGIN}"
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	src_install_lgmplugin
}

pkg_postinst() {
einfo
einfo "A build failure may happen in a simple hello world test if the"
einfo "appropriate subsystem USE flag in the enigma ebuild was disabled when"
einfo "building it or a dependency is not available, but the game settings are"
einfo "the opposite.  Both the USE flag and the game setting and/or extensions"
einfo "must match."
einfo
einfo "You must carefully enable/disable the Game Settings > ENIGMA > API"
einfo "section and extensions in Settings > ENIGMA > Extensions in LateralGM."
einfo "to fix inconsistencies to prevent game build failures."
einfo
	if has_version "dev-games/enigma[-openal]" ; then
ewarn
ewarn "You need change to Game Settings > ENIGMA > API > Audio > None in order"
ewarn "to compile your game successfully."
ewarn
	fi
einfo
einfo "If you are using dwm or non-parenting window manager or a non-responsive"
einfo "title bar menus, you need to:"
einfo "  emerge wmname"
einfo "  wmname LG3D"
einfo
einfo "Run 'wmname LG3D' before you run 'lateralgm' or 'libmaker'"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 1.8.234 (20230712)
# player+floor platformer prototype:  passed
