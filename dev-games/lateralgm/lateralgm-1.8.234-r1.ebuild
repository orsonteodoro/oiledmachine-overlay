# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils java-utils-2

DESCRIPTION="A free game maker source file editor"
LICENSE="
	GPL-3+
	libmaker? ( GPL-3+ )
"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
HOMEPAGE="http://lateralgm.org/"
SLOT="0"
IUSE+=" libmaker"

JAVA_SRC_V="1.7"
JAVA_V="1.8"
JVM_V="1.8"

# Merged libmaker and lgmplugin to let others find them easier.

DEPEND_LATERALGM=" virtual/jre:${JAVA_V}"
DEPEND_LGMPLUGIN="
	dev-java/jna[nio-buffers]
	virtual/jre:${JAVA_V}
"
DEPEND_LIBMAKER=" virtual/jre:${JAVA_V}"
CDEPEND="
	${DEPEND_LATERALGM}
	${DEPEND_LGMPLUGIN}
	libmaker? ( ${DEPEND_LIBMAKER} )
"
DEPEND+="
	${CDEPEND}
	virtual/jdk:${JAVA_V}
"
RDEPEND+="
	${CDEPEND}
	dev-games/enigma
"
BDEPEND_LATERALGM=" virtual/jdk:${JAVA_V}"
BDEPEND_LGMPLUGIN=" virtual/jdk:${JAVA_V}"
BDEPEND_LIBMAKER=" virtual/jdk:${JAVA_V}"
BDEPEND+="
	${BDEPEND_LATERALGM}
	${BDEPEND_LGMPLUGIN}
	libmaker? ( ${BDEPEND_LIBMAKER} )
"

EGIT_COMMIT_LIBMAKER="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
EGIT_COMMIT_JE_LATERALGM="487ddbe470032124dcb50ebee01a24b600ae900e"
EGIT_COMMIT_JE_LIBMAKER="5844d7f047eac15408f7ccf8a9183d2015b962e0" # \
# dated 20120417, this is required because of namespace changes, KeywordSet \
# changes, fails to build
LGMPLUGIN_V="1.8.227r2" # \
# lgmplugin updates can be found at: \
# https://github.com/enigma-dev/lgmplugin/tags

MY_PN_LATERALGM="LateralGM"
MY_PN_LIBMAKER="LibMaker"
MY_PN_LGMPLUGIN="LateralGM Plugin"
JE_PN="JoshEdit"
JE_LATERALGM_FN="${JE_PN}-${EGIT_COMMIT_JE_LATERALGM:0:7}.tar.gz"
LIBMAKER_FN="${MY_PN_LIBMAKER}-${EGIT_COMMIT_LIBMAKER:0:7}.tar.gz"
JE_LIBMAKER_FN="${MY_PN_LIBMAKER}-${EGIT_COMMIT_JE_LIBMAKER:0:7}.tar.gz"
LGMPLUGIN_FN="lgmplugin-${LGMPLUGIN_V}.tar.gz"
BASE_URI_IA="https://github.com/IsmAvatar"
BASE_URI_JD="https://github.com/JoshDreamland"
BASE_URI_ED="https://github.com/enigma-dev"

SRC_URI_LATERALGM="
${BASE_URI_IA}/${MY_PN_LATERALGM}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
${BASE_URI_JD}/JoshEdit/archive/${EGIT_COMMIT_JE_LATERALGM}.tar.gz
	-> ${JE_LATERALGM_FN}
"
SRC_URI_LIBMAKER="
${BASE_URI_IA}/${MY_PN_LIBMAKER}/archive/${EGIT_COMMIT_LIBMAKER}.tar.gz
	-> ${LIBMAKER_FN}
${BASE_URI_JD}/${JE_PN}/archive/${EGIT_COMMIT_JE_LIBMAKER}.tar.gz
	-> ${JE_LIBMAKER_FN}
"

SRC_URI_LGMPLUGIN="
${BASE_URI_ED}/lgmplugin/archive/refs/tags/v${LGMPLUGIN_V}.tar.gz
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
S_LGMPLUGIN="${WORKDIR}/lgmplugin-${LGMPLUGIN_V}"
S="${S_LATERALGM}"

pkg_setup()
{
	java-pkg_init
	if [[	-n "${JAVA_HOME}" && \
		-f "${JAVA_HOME}/bin/java" ]] ; then
		export JAVA="${JAVA_HOME}/bin/java"
	elif [[ -z "${JAVA_HOME}" ]] ; then
eerror
eerror "JAVA_HOME is not set.  Use \`eselect java-vm\` to set this up."
eerror
		die
	else
eerror
eerror "JAVA_HOME is set to ${JAVA_HOME} but cannot locate"
eerror "${JAVA_HOME}/bin/java.  Use \`eselect java-vm\` to set this up."
eerror
		die
	fi
	java-pkg_ensure-vm-version-ge ${JAVA_V}
	export JVM_V=$(java-pkg_get-target)

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
}

src_unpack_lateralgm()
{
	rm -rf "${S_LATERALGM}/modules/joshedit" || die
	mv "${WORKDIR}/${JE_PN}-${EGIT_COMMIT_JE_LATERALGM}" \
		"${S_LATERALGM}/modules/joshedit" || die
}

src_unpack() {
	unpack ${A}
	src_unpack_lateralgm
}

src_prepare_lateralgm() {
	einfo "Preparing ${MY_PN_LATERALGM}"
	cd "${S_LATERALGM}" || die
	local bcp="-bootclasspath ${JAVA_HOME}/jre/lib/rt.jar"
	sed -i -e "s|JFLAGS =|JFLAGS = ${bcp}|" \
		-e "s|-source 1.7|-source ${JAVA_SRC_V}|g" \
		-e "s|-target 1.7|-target ${JVM_V}|g" Makefile || die
	# no need to call enigma_copy_sources
	# it will complain about cd (change directory) failure in src_install
	# phase
	eapply "${FILESDIR}/lateralgm-1.8.227-cast-GMXFileReader.patch"
}

src_prepare_libmaker()
{
	einfo "Preparing ${MY_PN_LIBMAKER}"
	cd "${S_LIBMAKER}" || die
	cp -r "${WORKDIR}/${JE_PN}-${EGIT_COMMIT_JE_LIBMAKER}/org/" ./ \
		|| die
}

src_prepare_lgmplugin() {
	einfo "Preparing ${MY_PN_LGMPLUGIN}"
	cd "${S_LGMPLUGIN}" || die
	local bcp="-bootclasspath ${JAVA_HOME}/jre/lib/rt.jar"
	sed -i -e "s|JFLAGS =|JFLAGS = ${bcp}|" \
		-e "s|-source 1.7|-source ${JAVA_SRC_V}|g" \
		-e "s|-target 1.7|-target ${JVM_V}|g" \
		-e "s|jna.jar|/usr/share/jna/lib/jna.jar|" \
		Makefile || die
	ln -s "${S_LATERALGM}" "${WORKDIR}/LateralGM" || die

	# Found in same JoshEdit used by LibMaker but not the same as
	# LateralGM's JoshEdit.
	sed -i -e "/CodeTextArea.updateKeywords/d" \
		org/enigma/frames/EnigmaSettingsHandler.java || die
}

src_prepare() {
	default
	src_prepare_lateralgm
	if use libmaker ; then
		src_prepare_libmaker
	fi
	src_prepare_lgmplugin
}

src_compile_lateralgm()
{
	einfo "Compiling ${MY_PN_LATERALGM}"
	emake jar
}

src_compile_lgmplugin()
{
	einfo "Compiling ${MY_PN_LGMPLUGIN}"
	emake
}

src_compile_libmaker()
{
	einfo "Compiling ${MY_PN_LIBMAKER}"
	MAKEOPTS="-j1" \
	$(java-pkg_get-javac) \
		-bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" \
		-source ${JAVA_SRC_V} -target ${JVM_V} -nowarn -cp . -cp \
		"${S_LATERALGM}/lateralgm.jar" \
		$(find . -name "*.java")
	jar cmvf META-INF/MANIFEST.MF ${PN}.jar \
		$(find . -name '*.class') \
		$(find . -name '*.png') \
		$(find . -name '*.properties') \
		$(find . -name "*.svg") \
		$(find . -name '*.txt') \
		|| die
}

src_compile() {
	S="${S_LATERALGM}"
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	if [[ ! -f .compiled ]] ; then
		src_compile_lateralgm
		touch .compiled || die
	fi

	if use libmaker ; then
		S="${S_LIBMAKER}"
		BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
		src_compile_libmaker
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
	doins lateralgm.jar
	exeinto /usr/bin
	cp "${FILESDIR}/lateralgm" \
		"${T}/lateralgm" || die
	sed -i -e "s|LIBDIR|$(get_libdir)|g" \
		"${T}/lateralgm" || die
	doexe "${T}/lateralgm"
	doicon org/lateralgm/main/lgm-logo.ico
	make_desktop_entry \
		"/usr/bin/lateralgm" \
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
}

src_install_libmaker()
{
	einfo "Installing ${MY_PN_LIBMAKER}"
	insinto "/usr/share/${PN}/lib"
	doins "${PN}.jar"
	exeinto "/usr/bin"
	cat "${FILESDIR}/${MY_PN_LIBMAKER,,}" \
		> "${T}/${MY_PN_LIBMAKER,,}" || die
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
einfo "When you run it the first time, it will compile the"
einfo "/usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is the"
einfo "Run, Debug, and Compile buttons won't appear until it completes."
einfo
einfo "If you are using dwm or non-parenting window manager or a non-responsive"
einfo "title bar menus, you need to:"
einfo "  emerge wmname"
einfo "  wmname LG3D"
einfo
einfo "Run 'wmname LG3D' before you run 'lateralgm' or 'libmaker'"
einfo
}
