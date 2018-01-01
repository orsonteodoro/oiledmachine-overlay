# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs eutils multilib versionator multilib-minimal multilib-build flag-o-matic

MY_PN=FreeImage
MY_PV=${PV//.}
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="Image library supporting many formats"
HOMEPAGE="http://freeimage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	mirror://sourceforge/${PN}/${MY_P}.pdf
	https://dev.gentoo.org/~gienah/2big4tree/media-libs/freeimage/${PN}-3.15.4-libjpeg-turbo.patch.gz"

LICENSE="|| ( GPL-2 FIPL-1.0 )"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="jpeg jpeg2k mng openexr png raw static-libs tiff"

# The tiff/ilmbase isn't a typo.  The TIFF plugin cheats and
# uses code from it to handle 16bit<->float conversions.
RDEPEND="sys-libs/zlib
	jpeg? ( || ( >=media-libs/jpeg-9
		     media-libs/libjpeg-turbo[jpeg7]
		     media-libs/libjpeg-turbo[jpeg8] ) )
	jpeg2k? ( media-libs/openjpeg:2 )
	mng? ( media-libs/libmng )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng:0 )
	raw? ( media-libs/libraw )
	tiff? (
		media-libs/ilmbase
		media-libs/tiff:0
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	cd Source
	if has_version ">=media-libs/libjpeg-turbo-1.2.1"; then
		# Patch from Christian Heimes's fork (thanks) https://bitbucket.org/tiran/freeimageturbo
		epatch "${FILESDIR}"/${PN}-3.17.0-libjpeg-turbo.patch
		sed -i -r -e "s|JCS_BG_YCC|JCS_YCCK|g" LibJPEG/transupp.c || die
		cp LibJPEG/{jpegcomp.h,jpegint.h} . || die
	fi
	cp LibJPEG/{transupp.c,transupp.h,jinclude.h} . || die
	cp LibTIFF4/{tiffiop,tif_dir}.h . || die
	rm -rf LibPNG LibMNG LibOpenJPEG ZLib OpenEXR LibRawLite LibTIFF4 LibJPEG || die
	cd ..
	edos2unix Makefile.{gnu,fip,srcs} fipMakefile.srcs */*.h */*/*.cpp
	sed -i \
		-e "s:/./:/:g" \
		-e "s: ./: :g" \
		-e 's: Source: \\\n\tSource:g' \
		-e 's: Wrapper: \\\n\tWrapper:g' \
		-e 's: Examples: \\\n\tExamples:g' \
		-e 's: TestAPI: \\\n\tTestAPI:g' \
		-e 's: -ISource: \\\n\t-ISource:g' \
		-e 's: -IWrapper: \\\n\t-IWrapper:g' \
		Makefile.srcs fipMakefile.srcs || die
	sed -i \
		-e "/LibJPEG/d" \
		-e "/LibPNG/d" \
		-e "/LibTIFF/d" \
		-e "/Source\/ZLib/d" \
		-e "/LibOpenJPEG/d" \
		-e "/OpenEXR/d" \
		-e "/LibRawLite/d" \
		-e "/LibMNG/d" \
		Makefile.srcs fipMakefile.srcs || die

	epatch "${FILESDIR}"/${PN}-3.17.0-{unbundling,raw}.patch

	FILES=(
		"Source/LibWebP/src/dsp/dsp.dec_mips_dsp_r2.c"
		"Source/LibWebP/src/dsp/dsp.enc_mips32.c"
		"Source/LibWebP/src/dsp/dsp.enc_mips_dsp_r2.c"
		"Source/LibWebP/src/dsp/dsp.filters_mips_dsp_r2.c"
		"Source/LibWebP/src/dsp/dsp.lossless_mips32.c"
		"Source/LibWebP/src/dsp/dsp.lossless_mips_dsp_r2.c"
		"Source/LibWebP/src/dsp/dsp.upsampling_mips_dsp_r2.c"
		"Source/LibWebP/src/dsp/dsp.yuv_mips_dsp_r2.c"
	)

	for f in ${FILES[@]} ; do
		einfo "Patching $f..."
		#fix gcc 5.x compile error
		#from https://chromium.googlesource.com/webm/libwebp/+/eebaf97f5a1cb713d81d311308d8a48c124e5aef
		sed -i -r -e 's|"#TEMP0"|" #TEMP0 "|g' $f
		sed -i -r -e 's|"#TEMP1"|" #TEMP1 "|g' $f
		sed -i -r -e 's|"#TEMP2"|" #TEMP2 "|g' $f
		sed -i -r -e 's|"#TEMP3"|" #TEMP3 "|g' $f
		sed -i -r -e 's|"#TEMP4"|" #TEMP4 "|g' $f
		sed -i -r -e 's|"#TEMP6"|" #TEMP6 "|g' $f
		sed -i -r -e 's|"#TEMP8"|" #TEMP8 "|g' $f
		sed -i -r -e 's|"#TEMP12"|" #TEMP12 "|g' $f

		sed -i -r -e 's|"#A1"|" #A1 "|g' $f
		sed -i -r -e 's|"#B1"|" #B1 "|g' $f
		sed -i -r -e 's|"#C1"|" #C1 "|g' $f
		sed -i -r -e 's|"#D1"|" #D1 "|g' $f
		sed -i -r -e 's|"#E1"|" #E1 "|g' $f
		sed -i -r -e 's|"#F1"|" #F1 "|g' $f
		sed -i -r -e 's|"#G1"|" #G1 "|g' $f
		sed -i -r -e 's|"#H1"|" #H1 "|g' $f
		sed -i -r -e 's|"#N1"|" #N1 "|g' $f

		sed -i -r -e 's|"#O0"|" #O0 "|g' $f
		sed -i -r -e 's|"#O1"|" #O1 "|g' $f
		sed -i -r -e 's|"#O2"|" #O2 "|g' $f
		sed -i -r -e 's|"#O3"|" #O3 "|g' $f
		sed -i -r -e 's|"#O4"|" #O4 "|g' $f
		sed -i -r -e 's|"#O5"|" #O5 "|g' $f
		sed -i -r -e 's|"#O6"|" #O6 "|g' $f
		sed -i -r -e 's|"#O7"|" #O7 "|g' $f

		sed -i -r -e 's|"#IO0"|" #IO0 "|g' $f
		sed -i -r -e 's|"#IO1"|" #IO1 "|g' $f
		sed -i -r -e 's|"#IO2"|" #IO2 "|g' $f
		sed -i -r -e 's|"#IO3"|" #IO3 "|g' $f
		sed -i -r -e 's|"#IO4"|" #IO4 "|g' $f
		sed -i -r -e 's|"#IO5"|" #IO5 "|g' $f
		sed -i -r -e 's|"#IO6"|" #IO6 "|g' $f
		sed -i -r -e 's|"#IO7"|" #IO7 "|g' $f

		sed -i -r -e 's|"#I0"|" #I0 "|g' $f
		sed -i -r -e 's|"#I1"|" #I1 "|g' $f
		sed -i -r -e 's|"#I2"|" #I2 "|g' $f
		sed -i -r -e 's|"#I3"|" #I3 "|g' $f
		sed -i -r -e 's|"#I4"|" #I4 "|g' $f
		sed -i -r -e 's|"#I5"|" #I5 "|g' $f
		sed -i -r -e 's|"#I6"|" #I6 "|g' $f
		sed -i -r -e 's|"#I7"|" #I7 "|g' $f
		sed -i -r -e 's|"#I8"|" #I8 "|g' $f
		sed -i -r -e 's|"#I9"|" #I9 "|g' $f
		sed -i -r -e 's|"#I10"|" #I10 "|g' $f
		sed -i -r -e 's|"#I11"|" #I11 "|g' $f
		sed -i -r -e 's|"#I12"|" #I12 "|g' $f
		sed -i -r -e 's|"#I13"|" #I13 "|g' $f
		sed -i -r -e 's|"#I14"|" #I14 "|g' $f
		sed -i -r -e 's|"#I15"|" #I15 "|g' $f

		sed -i -r -e 's|"#A"|" #A "|g' $f
		sed -i -r -e 's|"#B"|" #B "|g' $f
		sed -i -r -e 's|"#C"|" #C "|g' $f
		sed -i -r -e 's|"#D"|" #D "|g' $f
		sed -i -r -e 's|"#E"|" #E "|g' $f
		sed -i -r -e 's|"#F"|" #F "|g' $f
		sed -i -r -e 's|"#G"|" #G "|g' $f
		sed -i -r -e 's|"#H"|" #H "|g' $f
		sed -i -r -e 's|"#J"|" #J "|g' $f
		sed -i -r -e 's|"#K"|" #K "|g' $f
		sed -i -r -e 's|"#N"|" #N "|g' $f
		sed -i -r -e 's|"#R"|" #R "|g' $f

		sed -i -r -e 's|"#P0"|" #P0 "|g' $f
		sed -i -r -e 's|"#P1"|" #P1 "|g' $f
		sed -i -r -e 's|"#P2"|" #P2 "|g' $f

		sed -i -r -e 's|"#SRC"|" #SRC "|g' $f
		sed -i -r -e 's|"#DST"|" #DST "|g' $f
		sed -i -r -e 's|"#SIZE"|" #SIZE "|g' $f
		sed -i -r -e 's|"#TYPE"|" #TYPE "|g' $f
		sed -i -r -e 's|"#INVERSE"|" #INVERSE "|g' $f
	done


	eapply_user

	multilib_copy_sources
}

multilib_src_configure() {
	default
}

foreach_make() {
	local m
	for m in Makefile.{gnu,fip} ; do
		emake -f ${m} \
			USE_EXR=$(usex openexr) \
			USE_JPEG=$(usex jpeg) \
			USE_JPEG2K=$(usex jpeg2k) \
			USE_MNG=$(usex mng) \
			USE_PNG=$(usex png) \
			USE_TIFF=$(usex tiff) \
			USE_RAW=$(usex raw) \
			$(usex static-libs '' STATICLIB=) \
			"$@"
	done
}

multilib_src_compile() {
	tc-export AR PKG_CONFIG
	foreach_make \
		CXX="$(tc-getCXX) -fPIC" \
		CC="$(tc-getCC) -fPIC" \
		${MY_PN}
}

multilib_src_install() {
	foreach_make install DESTDIR="${ED}" INSTALLDIR="${ED}"/usr/$(get_libdir)
	dodoc Whatsnew.txt "${DISTDIR}"/${MY_P}.pdf
}
