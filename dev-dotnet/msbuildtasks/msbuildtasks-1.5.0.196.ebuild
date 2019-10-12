# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
HOMEPAGE="https://github.com/loresoft/msbuildtasks"
DESCRIPTION="The MSBuild Community Tasks Project is an open source project for MSBuild tasks."
LICENSE="BSD" # https://github.com/loresoft/msbuildtasks/blob/master/LICENSE
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
USE_DOTNET="net45"
IUSE="+${USE_DOTNET} +debug developer doc"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND="=dev-dotnet/dotnetzip-semverd-1.9.3-r1[gac]"
DEPEND="${RDEPEND}"
inherit dotnet pc-file
SRC_URI="https://github.com/loresoft/msbuildtasks/archive/1.5.0.196.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	eapply "${FILESDIR}/references-2016052301.patch"
	eapply "${FILESDIR}/location.patch"
}

src_compile() {
	exbuild "Source/MSBuild.Community.Tasks/MSBuild.Community.Tasks.csproj"
}

src_install() {
	DIR=$(usex debug "Debug" "Release")
	egacinstall "Source/MSBuild.Community.Tasks/obj/${DIR}/MSBuild.Community.Tasks.dll"
	einstall_pc_file "${PN}" "${PV}" "MSBuild.Community.Tasks.dll"
	insinto "/usr/$(get_libdir)/mono/${EBF}"
	doins "Source/MSBuild.Community.Tasks/MSBuild.Community.Tasks.Targets"

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins Source/MSBuild.Community.Tasks/MSBuild.Community.Tasks.snk
		doins Source/MSBuild.Community.Tasks/obj/Release/MSBuild.Community.Tasks.dll.mdb
	fi

	dotnet_multilib_comply
}
