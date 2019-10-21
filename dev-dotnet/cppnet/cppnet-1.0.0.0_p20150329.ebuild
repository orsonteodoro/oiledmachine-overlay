# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CppNet is a quick and dirty port of jcpp to .NET, with features"
DESCRIPTION+=" to support Clang preprocessing."
HOMEPAGE="https://github.com/xtravar/CppNet"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="CppNet"
EGIT_COMMIT="643098b5397d06336addec4b097066bcc2f489a8"
inherit dotnet eutils
SRC_URI=\
"https://github.com/xtravar/${PROJECT_NAME}/archive/${EGIT_COMMIT}.zip \
	-> ${P}.zip"
inherit gac
SLOT="0/${PV}"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	eapply "${FILESDIR}/cppnet-9999.20150329-uninit.patch"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
	        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.csproj || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
		doins bin/${mydebug}/${PROJECT_NAME}.dll
		if use developer ; then
			doins bin/${mydebug}/${PROJECT_NAME}.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/${PROJECT_NAME}.dll" \
				"bin/${mydebug}/${PROJECT_NAME}.dll.mdb"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
