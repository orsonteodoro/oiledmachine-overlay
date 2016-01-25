# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils eutils multilib toolchain-funcs

DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="https://${PN}.googlecode.com/files/${P}-1.tar.gz
	https://dev.gentoo.org/~ssuominen/${P}-patchset-1.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cg cuda glew glut openexr csharp"

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
	csharp? ( dev-lang/mono )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

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
	EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patches
	# fix bug #414509
	epatch "${FILESDIR}"/${P}-cg.patch
	# fix bug #423965
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch
	# fix bug #462494
	epatch "${FILESDIR}"/${P}-openexr.patch
	# fix clang build
	epatch "${FILESDIR}"/${P}-clang.patch

	if use csharp; then
		cd "${S}/project/vc8/Nvidia.TextureTools"
		xbuild Nvidia.TextureTools.csproj /p:
	fi


	#monogame refers to this copy
	wget -O "${S}/project/vc8/Nvidia.TextureTools/TextureTools.cs"  "https://github.com/castano/nvidia-texture-tools/raw/a382ea5b21796b62a25fc1eb99871735a25db64f/project/vc9/Nvidia.TextureTools/TextureTools.cs"
	#sed -i -e "s|private delegate void WriteDataDelegate|public delegate bool WriteDataDelegate|g" "${S}"/project/vc8/Nvidia.TextureTools/TextureTools.cs
	#sed -i -e "s|private delegate void ImageDelegate|public delegate void ImageDelegate|g" "${S}"/project/vc8/Nvidia.TextureTools/TextureTools.cs
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR=$(get_libdir)
		-DNVTT_SHARED=TRUE
		$(cmake-utils_use cg CG)
		$(cmake-utils_use cuda CUDA)
		$(cmake-utils_use glew GLEW)
		$(cmake-utils_use glut GLUT)
		$(cmake-utils_use openexr OPENEXR)
		)

	cmake-utils_src_configure
}

src_compile() {
        mydebug="Net45-Release"
        if use debug; then
                mydebug="Net45-Debug"
        fi

	cmake-utils_src_compile

	if use csharp; then
	        mydebug="Release"
	        if use debug; then
	                mydebug="Debug"
	        fi

		cd "${S}"/project/vc8/Nvidia.TextureTools/
	        xbuild Nvidia.TextureTools.csproj /p:Configuration=${mydebug} || die "xbuild failed"
	fi
}

src_install() {
	cmake-utils_src_install

	if use csharp; then
	        mydebug="Release"
	        if use debug; then
	                mydebug="Debug"
	        fi

	        ebegin "Installing dlls into the GAC"

	        cd "${S}"
	        sn -k "${PN}-keypair.snk"
	        mkdir -p "${D}/usr/share/${PN}/"
	        cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

		cd "${S}/project/vc8/Nvidia.TextureTools/obj/${mydebug}"
	        for FILE in $(ls *.dll)
	        do
	                strong_sign "${S}/${PN}-keypair.snk" "${S}/project/vc8/Nvidia.TextureTools/obj/${mydebug}/${FILE}"
	                gacutil -i "${S}/project/vc8/Nvidia.TextureTools/obj/${mydebug}/${FILE}" -root "${D}/usr/$(get_libdir)" \
        	                -gacdir "/usr/$(get_libdir)" -package "${PN}" #|| die "failed"
	        done

		eend
	fi
}

function strong_sign() {
        pushd "$(dirname ${2})"
        ikdasm "${2}" > "${2}.il" || die "monodis failed"
        mv "${2}" "${2}.orig"
        grep -r -e "permissionset" "${2}.il" #permissionset not supported
        if [[ "$?" == "0" ]]; then
                sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|.permissionset.*\n.*\}\}||g' "${2}.il"
        fi
        grep -e "\[opt\] bool public" "${2}.il" #broken mangling
        if [[ "$?" == "0" ]]; then
                sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|\[opt\] bool public|[opt] bool \'public\'|g" "${2}.il"
        fi

        ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" #|| die "ilasm failed"
        #rm "${2}.orig"
        #rm "${2}.il"
        popd
}



