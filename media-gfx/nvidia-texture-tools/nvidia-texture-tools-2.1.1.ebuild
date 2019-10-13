# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
LICENSE="MIT"
KEYWORDS="amd64 x86"
SLOT="0"
USE_DOTNET="net20 net40"
NVTT_DLLS="vc8 vc9 vc10 vc12 monogame"
IUSE="${USE_DOTNET} cg cuda glew glut openexr debug +gac monogame ${NVTT_DLLS}"
REQUIRED_USE="gac? ( || ( net40 ) vc12 )"
RDEPEND="cg? ( media-gfx/nvidia-cg-toolkit )
	 cuda? ( dev-util/nvidia-cuda-toolkit )
	 glew? ( media-libs/glew )
	 glut? ( media-libs/freeglut )
	 openexr? ( media-libs/openexr )
	 media-libs/libpng:0
	 media-libs/ilmbase
	 media-libs/tiff:0
	 sys-libs/zlib
	 virtual/jpeg
	 virtual/opengl
	 x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet cmake-utils eutils multilib toolchain-funcs
SRC_URI="https://github.com/castano/nvidia-texture-tools/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	if use gac ; then
		dotnet_pkg_setup
	fi
	if use cuda; then
		if [[ $(( $(gcc-major-version) * 10 + $(gcc-minor-version) )) -gt 44 ]] ; then
			die "GCC 4.5 and up are not supported for USE flag cuda!"
		fi
	fi
}

src_prepare() {
	default
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

	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc8/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc9/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc10/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/vc12/Nvidia.TextureTools/TextureTools.cs || die

	#monogame refers to this copy
	if use monogame ; then
		cp -a "${S}/project/vc9" "${S}/project/monogame"
		wget -O "${S}/project/monogame/Nvidia.TextureTools/TextureTools.cs"  "https://github.com/castano/nvidia-texture-tools/raw/a382ea5b21796b62a25fc1eb99871735a25db64f/project/vc9/Nvidia.TextureTools/TextureTools.cs" || die
		sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g"  ./project/monogame/Nvidia.TextureTools/TextureTools.cs
	fi
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
				exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" Nvidia.TextureTools.csproj || die "exbuild_strong failed"
			fi
		done
	fi
}

src_install() {
	addpredict /etc/gconf/gconf.xml.defaults/.testing.writeability
	cmake-utils_src_install

	local mydebug=$(usex debug "Debug" "Release")

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
