# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet gac nupkg

NAME="nunitv2"
HOMEPAGE="https://github.com/nunit/${NAME}"

EGIT_COMMIT="1b549f4f8b067518c7b54a5b263679adb83ccda4"
SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.zip -> ${PF}.zip"
S="${WORKDIR}/${NAME}-${EGIT_COMMIT}"

SLOT="2" # NUnit V2 IS NO LONGER MAINTAINED OR UPDATED.

DESCRIPTION="NUnit test suite for mono applications"
LICENSE="NUnit-License" # http://nunit.org/nuget/license.html
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="net45 developer debug gac nupkg doc"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RDEPEND=">=dev-lang/mono-4.0.2.5
	dev-util/nant[nupkg]
"
#	dev-dotnet/log4net
DEPEND="${RDEPEND}
"

S="${WORKDIR}/${NAME}-${EGIT_COMMIT}"
FILE_TO_BUILD=nunit.sln
METAFILETOBUILD="${S}/${FILE_TO_BUILD}"

# PN = Package name, for example vim.
# PV = Package version (excluding revision, if any), for example 6.3.

src_prepare() {
	chmod -R +rw "${S}" || die
	enuget_restore "${METAFILETOBUILD}"

	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi
	sed -i '/x86/d' "${S}/nuget/"*.nuspec || die
	sed -i '/log4net/d' "${S}/nuget/"*.nuspec || die
	sed -i 's#\\#/#g' "${S}/nuget/"*.nuspec || die
	sed -i "s#\${package.version}#$(get_version_component_range 1-3)#g" "${S}/nuget/"*.nuspec || die
	sed -i "s#\${project.base.dir}##g" "${S}/nuget/"*.nuspec || die
	sed -i "s#\${current.build.dir}#bin/${DIR}#g" "${S}/nuget/"*.nuspec || die

	default
}

src_compile() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	exbuild "${METAFILETOBUILD}"

	NUSPEC_PROPERTIES="" enuspec "${S}/nuget/nunit.nuspec"
	NUSPEC_PROPERTIES="" enuspec "${S}/nuget/nunit.runners.nuspec"
}

src_install() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	SLOTTEDDIR="/usr/share/nunit-${SLOT}/"
	insinto "${SLOTTEDDIR}"
	doins bin/${DIR}/*.{config,dll,exe}
	# install: cannot stat 'bin/Release/*.mdb': No such file or directory
	if use developer; then
		doins bin/${DIR}/*.mdb
	fi

	#monogame deps
	doins bin/Release/tests/nunit.framework.tests.dll || die

#	into /usr
#	dobin ${FILESDIR}/nunit-console
	make_wrapper nunit264 "mono ${SLOTTEDDIR}/nunit-console.exe"

	if use gac; then
		if use debug; then
			DIR="Debug"
		else
			DIR="Release"
		fi

		egacinstall "${S}/bin/${DIR}/lib/nunit-console-runner.dll"
	fi

	if use doc; then
#		dodoc ${WORKDIR}/doc/*.txt
#		dohtml ${WORKDIR}/doc/*.html
#		insinto /usr/share/${P}/samples
#		doins -r ${WORKDIR}/samples/*
		doins license.txt
	fi

	if use developer ; then
		insinto "${SLOTTEDDIR}"
		doins bin/${DIR}/nunit.framework.dll.mdb
		doins bin/${DIR}/nunit-agent.exe.mdb
		doins bin/${DIR}/pnunit-launcher.exe.mdb
		doins bin/${DIR}/pnunit-agent.exe.mdb
		doins bin/${DIR}/pnunit.framework.dll.mdb
		doins bin/${DIR}/nunit.core.interfaces.dll.mdb
		doins bin/${DIR}/nunit.core.dll.mdb
		doins bin/${DIR}/framework/nunit.framework.dll.mdb
		#doins bin/${DIR}/framework/nunit.mocks.dll.mdb
		doins bin/${DIR}/lib/nunit-console-runner.dll.mdb
		#doins bin/${DIR}/lib/nunit-gui-runner.dll.mdb
		#doins bin/${DIR}/lib/nunit.uikit.dll.mdb
		#doins bin/${DIR}/lib/nunit.uiexception.dll.mdb
		doins bin/${DIR}/lib/nunit.core.interfaces.dll.mdb
		doins bin/${DIR}/lib/nunit.core.dll.mdb
		doins bin/${DIR}/lib/nunit.util.dll.mdb
		doins bin/${DIR}/nunit.util.dll.mdb
		doins bin/${DIR}/nunit-console.exe.mdb
		doins bin/${DIR}/pnunit.tests.dll.mdb
		doins bin/${DIR}/nunit.exe.mdb
		doins bin/${DIR}/nunit-editor.exe.mdb
		doins src/nunit.snk
		doins addins/RowTest/nunitextension.snk
	fi

	#has its own package
	rm "${D}/usr/share/${SLOTTEDDIR}/log4net.dll"

	enupkg "${WORKDIR}/NUnit.$(get_version_component_range 1-3).nupkg"
	enupkg "${WORKDIR}/NUnit.Runners.$(get_version_component_range 1-3).nupkg"

	dotnet_multilib_comply
}
