# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="NVorbis is a C# vorbis decoder"
HOMEPAGE="https://github.com/ioctlLR/NVorbis"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net35 net40"
IUSE="${USE_DOTNET} debug developer +gac opentk"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
RDEPEND="dev-dotnet/opentk"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
inherit dotnet eutils
EGIT_COMMIT="0d40b48a48c4f87bb18b3593e7db0dab74dbb829"
SRC_URI="https://github.com/ioctlLR/NVorbis/archive/${EGIT_COMMIT}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/NVorbis-${EGIT_COMMIT}"

src_prepare() {
	default
	eapply "${FILESDIR}/nvorbis-9999.20160922-opentksupport.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-nuget.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests-ref.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-testapp.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-disable-testapp.patch"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild /p:Configuration=$(usex debug "debug" "release") \
		  ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" NVorbis.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall bin/NVorbis.dll
		doins bin/NVorbis.dll
		if use developer ; then
			doins bin/{NVorbis.dll.mdb,NVorbis.XML}
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/NVorbis.dll" \
				"bin/NVorbis.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/NVorbis.dll" \
				"NVorbis.XML"
		fi
		if use opentk ; then
			egacinstall \
			  OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll
			doins \
			  OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll
			if use developer ; then
				doins \
		OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll.mdb
				doins \
		bin/NVorbis.OpenTKSupport.XML
				dotnet_distribute_file_matching_dll_in_gac \
		"OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll" \
		"OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
		"OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll" \
		"bin/NVorbis.OpenTKSupport.XML"
			fi
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

