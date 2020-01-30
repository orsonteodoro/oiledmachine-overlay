# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
is an open source cross-platform game development environment based on \
the popular software Game Maker."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="android curl doc gles gles2 gles3 gnome gtk2 kde minimal +openal \
+opengl opengl1 opengl3 sdl2 sfml test +X"
inherit multilib-minimal
RDEPEND="android? ( dev-util/android-ndk
		    dev-util/android-sdk-update-manager )
	 curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	 dev-cpp/yaml-cpp[${MULTILIB_USEDEP}]
	 dev-libs/boost[${MULTILIB_USEDEP}]
	 dev-libs/protobuf[${MULTILIB_USEDEP}]
	 games-misc/lgmplugin
	 games-util/lateralgm
	 gles? ( media-libs/mesa[${MULTILIB_USEDEP}] )
	 gnome? ( gnome-extra/zenity )
	 gtk2? ( x11-libs/gtk+[${MULTILIB_USEDEP}] )
	 kde? ( kde-apps/kdialog )
	 media-libs/libpng[${MULTILIB_USEDEP}]
	 openal? (
		media-libs/alure[${MULTILIB_USEDEP}]
		media-libs/dumb[${MULTILIB_USEDEP}]
		media-libs/libvorbis[${MULTILIB_USEDEP}]
		media-libs/openal[${MULTILIB_USEDEP}] )
	 opengl? ( media-libs/glew[${MULTILIB_USEDEP}]
		   media-libs/mesa[${MULTILIB_USEDEP}] )
	 sdl2? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	 sfml? ( media-libs/libsfml[${MULTILIB_USEDEP}] )
	 sys-libs/zlib[${MULTILIB_USEDEP}]
	 X? ( x11-libs/libX11[${MULTILIB_USEDEP}]
	      sys-libs/zlib[${MULTILIB_USEDEP}] )
"
REQUIRED_USE="
	gles2? ( gles opengl )
	gles3? ( gles opengl )
	opengl1? ( opengl )
	opengl3? ( opengl )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}]
		dev-libs/boost[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}] )"
EGIT_COMMIT="670a3e228ee00d5e76bd61577b1ae9f257d863ca"
SRC_URI=\
"https://github.com/enigma-dev/enigma-dev/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit desktop eutils toolchain-funcs
S="${WORKDIR}/enigma-dev-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( Readme.md )
QA_SONAME="/usr/lib64/libcompileEGMf.so"

src_prepare() {
	default
	F=( Makefile CommandLine/emake/Makefile CompilerSource/Makefile )
	for f in ${F[@]} ; do
		einfo "Editing $f"
		sed -i -e "s|-Wl,-rpath,./||g" "${f}" || die
	done
	multilib_copy_sources
}

multilib_src_configure() {
	if use sfml ; then
		sed -i -e "s|AUDIO \?= OpenAL|AUDIO ?= SFML|" \
			ENIGMAsystem/SHELL/Makefile || die
	elif use openal ; then
		sed -i -e "s|AUDIO \?= OpenAL|AUDIO ?= OpenAL|" \
			ENIGMAsystem/SHELL/Makefile || die
	elif use android ; then
		sed -i -e "s|AUDIO \?= OpenAL|AUDIO ?= androidAudio|" \
			ENIGMAsystem/SHELL/Makefile || die
	fi

	if use curl ; then
		sed -i -e "s|NETWORKING \?= None|NETWORKING ?= BerkeleySockets|" \
			ENIGMAsystem/SHELL/Makefile || die
	fi

	if use sdl2 ; then
		sed -i -e "s|PLATFORM := xlib|PLATFORM ?= SDL|" \
			ENIGMAsystem/SHELL/Makefile || die
	elif use X ; then
		sed -i -e "s|PLATFORM := xlib|PLATFORM ?= xlib|" \
			ENIGMAsystem/SHELL/Makefile || die
	elif use android ; then
		sed -i -e "s|PLATFORM := xlib|PLATFORM ?= Android|" \
			ENIGMAsystem/SHELL/Makefile || die
	fi

	if use gtk2 ; then
		sed -i -e "s|WIDGETS \?= None|WIDGETS ?= GTK+|" \
			ENIGMAsystem/SHELL/Makefile || die
	elif use kde || use gnome ; then
		sed -i -e "s|WIDGETS \?= None|WIDGETS ?= xlib|" \
			ENIGMAsystem/SHELL/Makefile || die
	fi
}

multilib_src_compile() {
	local targets=( libpng-util libProtocols libEGM ENIGMA emake )
	if use test ; then
		targets+=( emake-tests test-runner )
	fi
	targets+=( .FORCE )
	emake ${targets[@]}
}

shrink_install() {
	rm -rf Compilers/{MacOSX,Windows} || die
	rm -rf Compilers/Linux/{AppleCross64.ey,MinGW32.ey,MinGW64.ey} || die
	rm -rf ENIGMAsystem/SHELL/Audio_Systems/{DirectSound,FMODAudio,\
iOSOpenAL,XAudio2} || die
	rm -rf ENIGMAsystem/SHELL/Bridges/{Cocoa-OpenGL,Cocoa-OpenGL1,\
Cocoa-OpenGL3,iPhone-OpenGLES,SDL-Direct3D,SDL-Direct3D11,SDL-Direct3D9,\
SDL-Win32,Win32,Win32-Direct3D11,Win32-Direct3D9,Win32-OpenGL,Win32-OpenGL1,\
Win32-OpenGL3} || die
	rm -rf ENIGMAsystem/SHELL/Graphics_Systems/{Direct3D11,Direct3D9} || die
	rm -rf ENIGMAsystem/SHELL/Makefiles/MacOSX || die
	rm -rf ENIGMAsystem/SHELL/Networking_Systems/DirectPlay || die
	rm -rf ENIGMAsystem/SHELL/Platforms/{Cocoa,iPhone,Win32} || die
	rm -rf ENIGMAsystem/SHELL/Widget_Systems/{Cocoa,Win32} || die

	if [[ "${ABI}" == amd64 ]] ; then
		rm -rf Compilers/Linux/{clang32.ey,gcc32.ey} || die
	elif [[ "${ABI}" == x86 ]] ; then
		rm -rf Compilers/Linux/{clang.ey,gcc.ey} || die
	fi

	if ! use android ; then
		rm -rf Compilers/Linux/{Android.ey,AndroidSym.ey} || die
		rm -rf ENIGMAsystem/SHELL/Audio_Systems/androidAudio || die
		rm -rf ENIGMAsystem/SHELL/Platforms/Android || die
	fi

	if ! use gles ; then
		rm -rf ENIGMAsystem/SHELL/Bridges/OpenGLES || die
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/OpenGLES || die
	fi

	if ! use gles2 ; then
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/OpenGLES2 || die
	fi

	if ! use gles3 ; then
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/OpenGLES3 || die
	fi

	if ! use gtk2 ; then
		rm -rf ENIGMAsystem/SHELL/Widget_Systems/GTK+ || die
	fi

	if ! use openal ; then
		rm -rf ENIGMAsystem/SHELL/Audio_Systems/OpenAL || die
	fi

	if ! use opengl ; then
		rm -rf ENIGMAsystem/SHELL/Bridges/OpenGL || die
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/{OpenGL-Debug,\
OpenGL-Desktop} || die
	fi

	if ! use opengl1 ; then
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/OpenGL1 || die
	fi

	if ! use opengl3 ; then
		rm -rf ENIGMAsystem/SHELL/Graphics_Systems/OpenGL3 || die
	fi

	if ! use sdl2 ; then
		rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL || die
		rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL1 || die
		rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL3 || die
		rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGLES2 || die
		rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGLES3 || die
		rm -rf ENIGMAsystem/SHELL/Platforms/SDL || die
	else
		if ! use opengl ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL || die
		fi
		if ! use opengl1 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL1 || die
		fi
		if ! use opengl3 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGL3 || die
		fi
		if ! use gles2 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGLES2 || die
		fi
		if ! use gles3 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/SDL-OpenGLES3 || die
		fi
	fi

	if ! use sfml ; then
		rm -rf ENIGMAsystem/SHELL/Audio_Systems/SFML || die
	fi

	if ! use test ; then
		rm -rf Compilers/Linux/TestHarness.ey || die
	fi

	if ! use X ; then
		rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL || die
		rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL1 || die
		rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL3 || die
		rm -rf ENIGMAsystem/SHELL/Platforms/xlib || die
		rm -rf ENIGMAsystem/SHELL/Widget_Systems/xlib || die
	else
		if ! use opengl ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL || die
		fi
		if ! use opengl1 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL1 || die
		fi
		if ! use opengl3 ; then
			rm -rf ENIGMAsystem/SHELL/Bridges/xlib-OpenGL3 || die
		fi
		if ! use gnome && ! use kde ; then
			rm -rf ENIGMAsystem/SHELL/Widget_Systems/xlib || die
		fi
	fi
}

multilib_src_install() {
	local b
	if [[ "${ABI}" == amd64 ]] ; then
		b=64
	elif [[ "${ABI}" == x86 ]] ; then
		b=32
	fi
	if use minimal ; then
		shrink_install
	fi
	insinto /usr/$(get_libdir)/enigma/
	doins -r ENIGMAsystem Compilers settings.ey events.res
	exeinto /usr/bin
	cp "${FILESDIR}/enigma" "${FILESDIR}/enigma-cli" "${T}"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" "${T}"/enigma || die
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" "${T}"/enigma-cli || die
	mv "${T}/enigma"{,-${b}}
	mv "${T}/enigma-cli"{,-${b}}
	doexe "${T}/enigma-${b}" "${T}/enigma-cli-${b}"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/enigma-${b}" || die
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/enigma-cli-${b}" || die
	insinto "/usr/$(get_libdir)/enigma/"
	doins Makefile
	exeinto "/usr/$(get_libdir)/enigma/"
	doexe libcompileEGMf.so libEGM.so libProtocols.so emake
	# new line replace
	NLR=( -e ':a;N;$!ba' )
	sed -i ${NLR[@]} -e 's|.PHONY: ENIGMA||g' \
		"${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i ${NLR[@]} -e 's|ENIGMA:\n\t\$(MAKE) -j 3 -C CompilerSource||g' \
		"${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i ${NLR[@]} -e 's|clean:\n\t\$(MAKE) -C CompilerSource clean||g' \
		"${D}/usr/$(get_libdir)/enigma/Makefile" || die
	newicon Resources/logo.png enigma.png
	make_desktop_entry "/usr/bin/enigma-${b}" "ENIGMA (${b}-bit)" \
		"/usr/share/pixmaps/enigma.png" "Development;IDE"
}

pkg_postinst()
{
	einfo \
"When you run it the first time, it will compile the \n\
/usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is that the\n\
Run, Debug, and Compile buttons on LateralGM will not be available until\n\
ENIGMA is done.  You need to wait."
}
