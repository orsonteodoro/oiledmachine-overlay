# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="NVorbis is a C# vorbis decoder"
HOMEPAGE="https://github.com/ioctlLR/NVorbis"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net35 net40"
IUSE="${USE_DOTNET} debug developer +gac opentk"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net40 )"
RDEPEND="dev-dotnet/opentk"
DEPEND="${RDEPEND}"
RESTRICT="fetch"
inherit dotnet eutils git-r3
SRC_URI=""
inherit gac
S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	unpack "${A}"
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/ioctlLR/NVorbis.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="0d40b48a48c4f87bb18b3593e7db0dab74dbb829"
        git-r3_fetch
        git-r3_checkout

}

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
		exbuild /p:Configuration=$(usex debug "debug" "release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" NVorbis.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall bin/NVorbis.dll
		if use developer ; then
			doins bin/NVorbis.dll
			doins bin/{NVorbis.dll.mdb,NVorbis.XML}
		fi
		if use opentk ; then
			egacinstall OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll
			if use developer ; then
				doins OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll.mdb
				doins bin/NVorbis.OpenTKSupport.XML
			fi
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
