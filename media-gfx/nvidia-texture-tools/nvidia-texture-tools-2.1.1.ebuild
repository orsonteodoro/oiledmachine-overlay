# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
LICENSE="MIT"
KEYWORDS="amd64 x86"
SLOT="0/${PV}"
USE_DOTNET="net20 net40 net45"
NVTT_DLLS="vc8 vc9 vc10 vc12 monogame"
IUSE="${USE_DOTNET} cg cuda glew glut openexr debug +gac monogame ${NVTT_DLLS}"
REQUIRED_USE="gac? ( ^^ ( net40 net45 ) ) \
	      monogame? ( vc9 ) \
	      vc8? ( || ( net20 net40 net45 ) ) \
	      vc9? ( || ( net20 net40 net45 ) ) \
	      vc10? ( || ( net40 net45 ) ) \
	      vc12? ( || ( net45 ) )"
inherit multilib-minimal
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
inherit dotnet cmake-utils eutils toolchain-funcs
NVTT_CS_COMMIT="a382ea5b21796b62a25fc1eb99871735a25db64f"
SRC_URI=\
"https://github.com/castano/nvidia-texture-tools/archive/${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz
https://github.com/castano/nvidia-texture-tools/raw/${NVTT_CS_COMMIT}/project/vc9/Nvidia.TextureTools/TextureTools.cs \
	-> TextureTools.cs.${NVTT_CS_COMMIT}"
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
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g" \
		project/vc8/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g" \
		project/vc9/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g" \
		project/vc10/Nvidia.TextureTools/TextureTools.cs || die
	sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g" \
		project/vc12/Nvidia.TextureTools/TextureTools.cs || die
	# MonoGame refers to this copy.
	if use monogame ; then
		cp -a "${S}/project/vc9" "${S}/project/monogame" || die
		cp -a "${DISTFILES}/TextureTools.cs.${NVTT_CS_COMMIT}" \
		  "project/monogame/Nvidia.TextureTools/TextureTools.cs" || die
		sed -i -r -e "s|\"nvtt\"|\"libnvtt.dll\"|g" \
		  project/monogame/Nvidia.TextureTools/TextureTools.cs || die
	fi
	if use net20 || use net40 || use net45 ; then
		dotnet_copy_sources
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
	if use net20 || use net40 || use net45 ; then
		cmake-utils_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile
	compile_impl () {
		for dll in $NVTT_DLLS
		do
			if use $dll ; then
				cd project/$dll/Nvidia.TextureTools
				exbuild \
				  ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				  Nvidia.TextureTools.csproj \
				  || die "exbuild_strong failed"
			fi
		done
	}
	if use net20 || use net40 || use net45 ; then
		dotnet_foreach_impl compile_impl
	fi
}

src_install() {
	addpredict /etc/gconf/gconf.xml.defaults/.testing.writeability
	cmake-utils_src_install
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		for dll in $NVTT_DLLS
		do
			if use $dll ; then
		  local p="project/$dll/Nvidia.TextureTools/bin/${mydebug}/"
				egacinstall \
					"${p}/Nvidia.TextureTools.dll" \
					"${PN}/$dll"
				insinto "/usr/$(get_libdir)/mono/${PN}/$dll"
				if use developer ; then
				  doins \
					"${p}/Nvidia.TextureTools.dll.mdb"
				  dotnet_distribute_file_matching_dll_in_gac \
					"${p}/Nvidia.TextureTools.dll" \
					"${p}/Nvidia.TextureTools.dll.mdb"
				fi
				dotnet_distribute_file_matching_dll_in_gac \
				  "${p}/Nvidia.TextureTools.dll" \
				  "${FILESDIR}/Nvidia.TextureTools.dll.config"
			fi
		done
		doins "${FILESDIR}/Nvidia.TextureTools.dll.config"
	}
	if use net20 || use net40 || use net45 ; then
		dotnet_foreach_impl install_impl
		dotnet_multilib_comply
	fi
}
