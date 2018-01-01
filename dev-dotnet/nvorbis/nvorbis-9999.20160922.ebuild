# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils git-r3 mono gac

DESCRIPTION="NVorbis is a C# vorbis decoder"
HOMEPAGE=""
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug opentk +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
	 dev-dotnet/opentk"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/ioctlLR/NVorbis.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="0d40b48a48c4f87bb18b3593e7db0dab74dbb829"
        git-r3_fetch
        git-r3_checkout

}

src_prepare() {
	eapply "${FILESDIR}/nvorbis-9999.20160922-opentksupport.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-nuget.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests-ref.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-testapp.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-disable-testapp.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} NVorbis.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

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
