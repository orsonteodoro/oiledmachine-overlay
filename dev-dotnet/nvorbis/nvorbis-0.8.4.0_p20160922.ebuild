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
inherit dotnet eutils git-r3 mono
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
}

src_compile() {
	cd "${S}"
	exbuild /p:Configuration=$(usex debug "debug" "release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" NVorbis.sln || die
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
		egacinstall "${S}/bin/NVorbis.dll"
		insinto "/usr/$(get_libdir)/mono/${PN}"
		if use developer ; then
			doins "${S}/bin/NVorbis.dll"
			doins bin/{NVorbis.dll.mdb,NVorbis.XML}
		fi
        done

	if use opentk ; then
		for x in ${USE_DOTNET} ; do
			FW_UPPER=${x:3:1}
			FW_LOWER=${x:4:1}
			egacinstall "${S}/OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			if use developer ; then
				doins OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll.mdb
				doins bin/NVorbis.OpenTKSupport.XML
			fi
		done
	fi

	eend

	dotnet_multilib_comply
}
