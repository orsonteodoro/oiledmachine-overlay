# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CppNet is a quick and dirty port of jcpp to .NET, with features to support Clang preprocessing."
HOMEPAGE="https://github.com/xtravar/CppNet"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="CppNet"
EGIT_COMMIT="643098b5397d06336addec4b097066bcc2f489a8"
inherit dotnet eutils mono
SRC_URI="https://github.com/xtravar/${PROJECT_NAME}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
inherit gac
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	eapply "${FILESDIR}/cppnet-9999.20150329-uninit.patch"
}

src_compile() {
	cd "${S}"
        exbuild /p:Configuration=$(usex debug "Debug" "Release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.csproj || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/${mydebug}/${PROJECT_NAME}.dll.mdb
	fi

	dotnet_multilib_comply
}
