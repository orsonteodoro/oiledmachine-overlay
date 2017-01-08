# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils eutils multilib toolchain-funcs gac

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

	#monogame refers to this copy
	if use monogame ; then
		cp -a "${S}/project/vc9" "${S}/project/monogame"
		wget -O "${S}/project/monogame/Nvidia.TextureTools/TextureTools.cs"  "https://github.com/castano/nvidia-texture-tools/raw/a382ea5b21796b62a25fc1eb99871735a25db64f/project/vc9/Nvidia.TextureTools/TextureTools.cs" || die
	fi
	#sed -i -e "s|private delegate void WriteDataDelegate|public delegate bool WriteDataDelegate|g" "${S}"/project/vc8/Nvidia.TextureTools/TextureTools.cs
	#sed -i -e "s|private delegate void ImageDelegate|public delegate void ImageDelegate|g" "${S}"/project/vc8/Nvidia.TextureTools/TextureTools.cs

	genkey

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
        mydebug="Net45-Release"
        if use debug; then
                mydebug="Net45-Debug"
        fi

	cmake-utils_src_compile

	if use gac; then
	        mydebug="Release"
	        if use debug; then
	                mydebug="Debug"
	        fi

		for dll in $NVTT_DLLS
		do
			if use $dll ; then
				cd "${S}"/project/$dll/Nvidia.TextureTools/
			        xbuild Nvidia.TextureTools.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die "xbuild failed"
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

		savekey

		for x in ${USE_DOTNET} ; do
        	        FW_UPPER=${x:3:1}
	                FW_LOWER=${x:4:1}
	                egacinstall "${S}/project/vc12/Nvidia.TextureTools/bin/${mydebug}/Nvidia.TextureTools.dll"
	        done

		eend
	fi

	for dll in $NVTT_DLLS
	do
		if use $dll ; then
			#we have multiple versions of the same library. developers may invertently choose the older one (anything but vc12)
			#we store each implementation in different folders so they preserve the same class and assembly name
			mkdir -p "${D}/usr/lib/mono/${PN}/$dll"
			cp "${S}/project/$dll/Nvidia.TextureTools/bin/${mydebug}/Nvidia.TextureTools.dll" \
			   "${D}/usr/lib/mono/${PN}/$dll/Nvidia.TextureTools.dll"
		fi
	done
}

function genkey() {
	einfo "Generating Key Pair"
	cd "${S}"
	sn -k "${PN}-keypair.snk"
}

function savekey() {
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"
}
