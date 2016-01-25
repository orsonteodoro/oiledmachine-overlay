# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3 mono

DESCRIPTION="NUnit"
HOMEPAGE="http://www.nunit.org"
SRC_URI="http://launchpad.net/nunitv2/trunk/${PV:0:5}/+download/NUnit-${PV}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/NUnit-2.6.0.12051"

src_unpack() {
	unpack "${A}"
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	for FILE in $(find . -name "*.csproj")
	do
		sed -i -e 's|ToolsVersion="3.5"|ToolsVersion="4.0"|g' "${FILE}"
	done

	xbuild /p:Configuration=${mydebug} src/NUnitFramework/tests/nunit.framework.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitFramework/framework/nunit.framework.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/ClientUtilities/tests/nunit.util.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/ClientUtilities/util/nunit.util.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/ConsoleRunner/tests/nunit-console.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/ConsoleRunner/nunit-console/nunit-console.csproj || die
	xbuild /p:Configuration=${mydebug} src/ConsoleRunner/nunit-console-exe/nunit-console.exe.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiRunner/nunit-gui/nunit-gui.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiRunner/tests/nunit-gui.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiRunner/nunit-gui-exe/nunit-gui.exe.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitCore/tests/nunit.core.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitCore/interfaces/nunit.core.interfaces.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitCore/core/nunit.core.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiComponents/tests/nunit.uikit.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiComponents/UiKit/nunit.uikit.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiException/tests/nunit.uiexception.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/GuiException/UiException/nunit.uiexception.dll.csproj || die
	xbuild /p:Configuration=${mydebug} src/tests/mock-assembly/mock-assembly.csproj || die
	xbuild /p:Configuration=${mydebug} src/tests/nonamespace-assembly/nonamespace-assembly.csproj || die
	xbuild /p:Configuration=${mydebug} src/tests/test-utilities/test-utilities.csproj || die
	xbuild /p:Configuration=${mydebug} src/tests/test-assembly/test-assembly.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitMocks/tests/nunit.mocks.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitMocks/mocks/nunit.mocks.csproj || die
	xbuild /p:Configuration=${mydebug} src/PNUnit/agent/pnunit-agent.csproj || die
	xbuild /p:Configuration=${mydebug} src/PNUnit/launcher/pnunit-launcher.csproj || die
	xbuild /p:Configuration=${mydebug} src/PNUnit/tests/pnunit.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/PNUnit/pnunit.framework/pnunit.framework.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitTestServer/nunit-agent-exe/nunit-agent.exe.csproj || die
	xbuild /p:Configuration=${mydebug} src/ProjectEditor/editor/nunit-editor.csproj || die
	xbuild /p:Configuration=${mydebug} src/ProjectEditor/tests/nunit-editor.tests.csproj || die
}

src_test() {
	die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	mv "${S}/usr/lib/NUnit/${PV}/net-2.0" "${S}/usr/lib/NUnit/${PV}/2.0" &>/dev/null
	mv "${S}/usr/lib/NUnit/${PV}/net-4.0" "${S}/usr/lib/NUnit/${PV}/4.0" &>/dev/null
	mv "${S}/usr/lib/NUnit/${PV}/net-4.5" "${S}/usr/lib/NUnit/${PV}/4.5" &>/dev/null

	mkdir -p "${D}/usr/lib/mono/2.0"
	mkdir -p "${D}/usr/lib/mono/4.0"
	mkdir -p "${D}/usr/lib/mono/4.5"
	mkdir -p "${D}/usr/lib/mono/NUnit"

	for FILE in $(find ${S}/bin -name "*.exe")
	do
		if [[ "${FILE}" =~ "2.0" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/2.0"/ &>/dev/null
		elif [[ "${FILE}" =~ "4.0" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/4.0"/ &>/dev/null
		elif [[ "${FILE}" =~ "4.5" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/4.5"/ &>/dev/null
		else
			cp "${FILE}" "${D}/usr/lib/mono/2.0"/ &>/dev/null
		fi
	done

	cd "${S}"
	mkdir -p "${D}"/usr/share/NUnit
	cp "${S}"/src/nunit.snk "${D}"/usr/share/NUnit

	for FILE in $(find ${S}/bin -name "*.dll")
	do
		if [[ "${FILE}" =~ "/addins/" ]]; then
			continue
		fi

		echo "$(dirname ${FILE})" | awk -v A="${S}/bin/${mydebug}" -v B="" '{sub(A,B); print;}' > "${T}/rp"
		RP=$(cat "${T}/rp")
		if [[ "${FILE}" =~ "2.0" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/2.0"
		elif [[ "${FILE}" =~ "4.0" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/4.0"
		elif [[ "${FILE}" =~ "4.5" ]]; then
			cp "${FILE}" "${D}/usr/lib/mono/4.5"
		else
			cp "${FILE}" "${D}/usr/lib/mono/2.0"
		fi
	done

	#install addins
	mkdir -p "${D}/usr/lib/monodevelop/AddIns/NUnit"
	cp -r "${S}/bin/${mydebug}/addins" "${D}/usr/lib/monodevelop/AddIns/NUnit"

	cd "${S}"
	dodoc license.rtf  license.txt
	dodoc -r doc/*

	local MYLIBS=""
	for FILE in $(find ${D}/usr/lib -name "*.dll")
	do
		sn -v "${FILE}" &>/dev/null
		if [[ "$?" != "0" ]]; then
			continue
		fi
		echo "$(dirname ${FILE})" | awk -v A="${D}" -v B="" '{sub(A,B); print;}' > "${T}/rp"
		RP=$(cat "${T}/rp")
		RP="${RP/net-2.0/2.0}"
		RP="${RP/net-4.0/4.0}"
		RP="${RP/net-4.5/4.5}"
		MYLIBS="${MYLIBS} -r:${RP}/$(basename ${FILE}) "
	done

	echo "${MYLIBS}"
	mkdir "${D}"/usr/lib/pkgconfig
	sed -e "s|@VERSION@|${PV}|g" -e "s|@LIBDIR@|/usr/$(get_libdir)/mono|g" -e "s|@LIBS@|${MYLIBS}|g" "${FILESDIR}/nunit.pc" > "${D}"/usr/lib/pkgconfig/nunit.pc

        #mono_multilib_comply
}

