# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3 mono

DESCRIPTION="NUnit"
HOMEPAGE="http://www.nunit.org"
SRC_URI="https://github.com/nunit/nunit/releases/download/${PV}/NUnit-${PV}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug -net_2_0 -net_4_0 +net_4_5 +add_ins"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	if use net_2_0; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/framework/nunit.framework-2.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/mock-assembly/mock-nunit-assembly-2.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/nunitlite.runner/nunitlite.runner-2.0.csproj || die
	fi

	if use net_4_0; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/framework/nunit.framework-4.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/mock-assembly/mock-nunit-assembly-4.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/nunitlite.runner/nunitlite.runner-4.0.csproj || die
	fi

	if use net_4_5; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/framework/nunit.framework-4.5.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/mock-assembly/mock-nunit-assembly-4.5.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/nunitlite.runner/nunitlite.runner-4.5.csproj || die
	fi

	xbuild /p:Configuration=${mydebug} src/NUnitEngine/nunit.engine.api/nunit.engine.api.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitEngine/nunit.engine/nunit.engine.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitEngine/nunit-agent/nunit-agent.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitEngine/nunit-agent/nunit-agent-x86.csproj || die

	if use add_ins; then
		xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/nunit-project-loader/nunit-project-loader.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/vs-project-loader/vs-project-loader.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/nunit-v2-result-writer/nunit-v2-result-writer.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/nunit.v2.driver/nunit.v2.driver.csproj || die
	fi

	xbuild /p:Configuration=${mydebug} src/NUnitConsole/nunit3-console/nunit3-console.csproj || die

	#run tests
	if use net_2_0; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/slow-tests/slow-nunit-tests-2.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/testdata/nunit.testdata-2.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/tests/nunit.framework.tests-2.0.csproj || die
	fi
	if use net_4_0; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/slow-tests/slow-nunit-tests-4.0.csproj || die
		#xbuild /p:Configuration=${mydebug} src/NUnitFramework/testdata/nunit.testdata-4.0.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/tests/nunit.framework.tests-4.0.csproj || die
	fi
	if use net_4_5; then
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/slow-tests/slow-nunit-tests-4.5.csproj || die
		#xbuild /p:Configuration=${mydebug} src/NUnitFramework/testdata/nunit.testdata-4.5.csproj || die
		xbuild /p:Configuration=${mydebug} src/NUnitFramework/tests/nunit.framework.tests-4.5.csproj || die
	fi

	if use add_ins; then
		xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/addin-tests/addin-tests.csproj || die
		#xbuild /p:Configuration=${mydebug} src/NUnitEngine/Addins/nunit.v2.driver.tests/nunit.v2.driver.tests.csproj || die
	fi

	xbuild /p:Configuration=${mydebug} src/NUnitEngine/nunit.engine.tests/nunit.engine.tests.csproj || die
	xbuild /p:Configuration=${mydebug} src/NUnitConsole/nunit3-console.tests/nunit3-console.tests.csproj || die
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

        ebegin "Installing dlls into the GAC"

	cd "${S}"
	mkdir -p "${D}"/usr/share/NUnit
	cp "${S}"/src/nunit.snk "${D}"/usr/share/NUnit

	SKIP=( slow-nunit-tests.dll nunit.v2.driver.dll nunit-project-loader.dll nunit-v2-result-writer.dll addin-tests.dll vs-project-loader.dll nunit.engine.tests.dll nunit.engine.tests.dll nunit3-console.tests.dll  ) #not strong signed

	for FILE in $(find ${S}/bin -name "*.dll")
	do
		if [[ "${SKIP[@]}" =~ "$(basename ${FILE})" ]]; then
			continue
		fi

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
		        #gacutil -i "${FILE}" -root "${D}/usr/$(get_libdir)" \
		        #        -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"
		else
			cp "${FILE}" "${D}/usr/lib/mono/2.0"
		fi
	done

	eend

	#install addins
	mkdir -p "${D}/usr/lib/monodevelop/AddIns/NUnit"
	cp -r "${S}/bin/${mydebug}/addins" "${D}/usr/lib/monodevelop/AddIns/NUnit"

	cd "${S}"
	dodoc CONTRIBUTORS.md License.rtf LICENSE.txt NOTICES.txt README.md

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
	sed -e "s|@VERSION@|${PV}|g" -e "s|@LIBDIR@|/usr/$(get_libdir)|g" -e "s|@LIBS@|${MYLIBS}|g" "${FILESDIR}/nunit.pc" > "${D}"/usr/lib/pkgconfig/nunit.pc

        #mono_multilib_comply
}
