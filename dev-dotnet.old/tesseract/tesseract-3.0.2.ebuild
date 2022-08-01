# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A .Net wrapper for tesseract-ocr"
HOMEPAGE="https://github.com/charlesw/tesseract"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND=">=app-text/tesseract-3.0.2
	 <app-text/tesseract-3.1
         =media-libs/leptonica-1.72*"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="https://github.com/charlesw/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/tesseract-3.0.2-refs.patch"
	dotnet_copy_sources
	prepare_impl() {
		cd src
		cp "AssemblyVersionInfo.template.cs" "AssemblyVersionInfo.cs" \
			|| die
		sed -i -r -e "s|[\$]\(Version\)|${PV}|g" AssemblyVersionInfo.cs\
			|| die
	}
	dotnet_foreach_impl prepare_impl
}

src_compile() {
	compile_impl() {
		cd src
	        exbuild /p:Configuration=$(usex debug "Debug45" "Release45") \
		${STRONG_ARGS_NETFX}"$(pwd)/${PN^}.snk" "${PN^}.sln" || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug45" "Release45")
	install_impl() {
		dotnet_install_loc
		local p="src/${PN^}/bin/${mydebug}/Net${EBF}"
		egacinstall ${p}/${PN^}.dll
		doins ${p}/${PN^}.dll
		if use developer; then
			doins ${p}/{${PN^}.dll.mdb,${PN^}.xml}
			dotnet_distribute_file_matching_dll_in_gac \
				"${p}/${PN^}.dll" \
				"${p}/${PN^}.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"${p}/${PN^}.dll" \
				"${p}/${PN^}.xml"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
