# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet cmake-utils eutils multilib toolchain-funcs gac

DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="https://github.com/castano/nvidia-texture-tools/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
USE_DOTNET="net45"
NVTT_DLLS="vc10 vc12 vc8 vc9 monogame"
IUSE="${USE_DOTNET} cg cuda glew glut openexr debug +gac monogame ${NVTT_DLLS}"
REQUIRED_USE="gac? ( || ( ${USE_DOTNET} ) vc12 )"

RDEPEND="media-libs/libpng:0
	media-libs/ilmbase
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	glew? ( media-libs/glew )
	glut? ( media-libs/freeglut )
	openexr? ( media-libs/openexr )
	gac? ( dev-lang/mono )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	if use gac ; then
		dotnet_pkg_setup
	fi
	if use cuda; then
		if [[ $(( $(gcc-major-version) * 10 + $(gcc-minor-version) )) -gt 44 ]] ; then
			eerror "gcc 4.5 and up are not supported for useflag cuda!"
			die "gcc 4.5 and up are not supported for useflag cuda!"
		fi
	fi
}

src_prepare() {
	edos2unix cmake/*
	#EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patches
	# fix bug #414509
	#epatch "${FILESDIR}"/${PN}-2.0.8-cg.patch
	# fix bug #423965
	#epatch "${FILESDIR}"/${PN}-2.0.8-gcc-4.7.patch
	# fix bug #462494
	#epatch "${FILESDIR}"/${PN}-2.0.8-openexr.patch
	# fix clang build
	#epatch "${FILESDIR}"/${PN}-2.0.8-clang.patch

	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc8/Nvidia.TextureTools/TextureTools.cs
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc9/Nvidia.TextureTools/TextureTools.cs
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc10/Nvidia.TextureTools/TextureTools.cs
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc12/Nvidia.TextureTools/TextureTools.cs

	#monogame refers to this copy
	if use monogame ; then
		cp -a "${S}/project/vc9" "${S}/project/monogame"
		wget -O "${S}/project/monogame/Nvidia.TextureTools/TextureTools.cs"  "https://github.com/castano/nvidia-texture-tools/raw/a382ea5b21796b62a25fc1eb99871735a25db64f/project/vc9/Nvidia.TextureTools/TextureTools.cs" || die
		sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/monogame/Nvidia.TextureTools/TextureTools.cs
	fi

	for dll in $NVTT_DLLS
	do
		if use $dll ; then
			egenkey "${PN}-${dll}.snk"
		fi
	done

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR=$(get_libdir)
		-DNVTT_SHARED=TRUE
		-DCG=$(usex cg)
		-DCUDA=$(usex cuda)
		-DGLEW=$(usex glew)
		-DGLUT=$(usex glut)
		-DOPENEXR=$(usex openexr)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use gac; then
		for dll in $NVTT_DLLS
		do
			if use $dll ; then
				cd "${S}"/project/$dll/Nvidia.TextureTools/
				SNK_FILENAME="${S}/${PN}-${dll}.snk" \
			        exbuild_strong Nvidia.TextureTools.csproj || die "exbuild_strong failed"
			fi
		done
	fi
}

src_install() {
	addpredict /etc/gconf/gconf.xml.defaults/.testing.writeability
	cmake-utils_src_install

        mydebug="Release"
        if use debug; then
                mydebug="Debug"
        fi

	if use gac; then
	        ebegin "Installing dlls into the GAC"

		for x in ${USE_DOTNET} ; do
       		        FW_UPPER=${x:3:1}
        	        FW_LOWER=${x:4:1}
			for dll in $NVTT_DLLS
			do
				if use $dll ; then
			                egacinstall "${S}/project/$dll/Nvidia.TextureTools/bin/${mydebug}/Nvidia.TextureTools.dll" "${PN}/$dll"
			               	insinto "/usr/$(get_libdir)/mono/${PN}/$dll"
					if use developer ; then
						doins "${S}/project/$dll/Nvidia.TextureTools/bin/${mydebug}/Nvidia.TextureTools.dll.mdb"
						esavekey "${S}/${PN}-${dll}.snk"
					fi
				fi
			done
	        done

		eend
	fi

        FILES=$(find "${D}" -name "*.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/Nvidia.TextureTools.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
