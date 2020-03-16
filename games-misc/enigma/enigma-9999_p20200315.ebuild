# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
is an open source cross-platform game development environment influenced by \
the popular software Game Maker."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="android curl doc gles gles2 gles3 gnome gtk2 kde linux minimal \
+openal +opengl opengl1 opengl3 sdl2 sfml test +vanilla +X"
inherit multilib-minimal
RDEPEND="android? ( dev-util/android-ndk
		    dev-util/android-sdk-update-manager )
	 curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	 dev-cpp/yaml-cpp[${MULTILIB_USEDEP}]
	 dev-libs/boost[${MULTILIB_USEDEP}]
	 dev-libs/protobuf[${MULTILIB_USEDEP}]
	 dev-libs/pugixml[${MULTILIB_USEDEP}]
	 dev-libs/rapidjson[${MULTILIB_USEDEP}]
	 games-misc/lgmplugin
	 games-util/lateralgm[android?,linux?,vanilla?,${MULTILIB_USEDEP}]
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
	 wine? ( sys-devel/crossdev
		 virtual/wine )
	 X? ( x11-libs/libX11[${MULTILIB_USEDEP}]
	      sys-libs/zlib[${MULTILIB_USEDEP}] )
"
REQUIRED_USE="
	!android
	gles2? ( gles opengl )
	gles3? ( gles opengl )
	opengl1? ( opengl )
	opengl3? ( opengl )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}]
		dev-libs/boost[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}] )"
EGIT_COMMIT="9bdb4528e7e3ee76e93ed798b35f0b7847493315"
SRC_URI=\
"https://github.com/enigma-dev/enigma-dev/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit desktop enigma eutils toolchain-funcs
S="${WORKDIR}/enigma-dev-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( Readme.md )

src_prepare() {
	default
	F=( Makefile CommandLine/emake/Makefile CompilerSource/Makefile )
	for f in ${F[@]} ; do
		einfo "Editing $f"
		sed -i -e "s|-Wl,-rpath,./||g" "${f}" || die
	done
	enigma_copy_sources
	platform_prepare() {
		cd "${BUILD_DIR}" || die
		multilib_copy_sources
	}
	enigma_foreach_impl platform_prepare
}

src_configure() {
	platform_configure() {
		cd "${BUILD_DIR}" || die
		ml_configure_abi() {
			cd "${BUILD_DIR}" || die
			if [[ "${EENIGMA}" == "android" ]] ; then
				sed -i \
				-e "s|AUDIO \?= OpenAL|AUDIO ?= androidAudio|" \
					ENIGMAsystem/SHELL/Makefile || die
				sed -i \
				-e "s|PLATFORM := xlib|PLATFORM ?= Android|" \
					ENIGMAsystem/SHELL/Makefile || die
				# todo see Compilers/MacOSX/Android.ey
				# depends on if we are using autotools or
				# ndk-build?
				#sed -i -e "s|make: make|make: |g" \
				#	Compilers/Linux/Android.ey
				#sed -i -e "s|make: make|make: |g" \
				#	Compilers/Linux/AndroidSym.ey
			fi

			if use sfml ; then
				sed -i -e "s|AUDIO \?= OpenAL|AUDIO ?= SFML|" \
					ENIGMAsystem/SHELL/Makefile || die
			elif use openal ; then
				sed -i \
				-e "s|AUDIO \?= OpenAL|AUDIO ?= OpenAL|" \
					ENIGMAsystem/SHELL/Makefile || die
			fi

			if use curl ; then
				sed -i \
		-e "s|NETWORKING \?= None|NETWORKING ?= BerkeleySockets|" \
					ENIGMAsystem/SHELL/Makefile || die
			fi

			if use sdl2 ; then
				sed -i \
				-e "s|PLATFORM := xlib|PLATFORM ?= SDL|" \
					ENIGMAsystem/SHELL/Makefile || die
			elif use X ; then
				sed -i \
				-e "s|PLATFORM := xlib|PLATFORM ?= xlib|" \
					ENIGMAsystem/SHELL/Makefile || die
			fi

			if use gtk2 ; then
				sed -i \
				-e "s|WIDGETS \?= None|WIDGETS ?= GTK+|" \
					ENIGMAsystem/SHELL/Makefile || die
			elif use kde || use gnome ; then
				sed -i \
				-e "s|WIDGETS \?= None|WIDGETS ?= xlib|" \
					ENIGMAsystem/SHELL/Makefile || die
			fi
		}
		multilib_foreach_abi ml_configure_abi
	}
	enigma_foreach_impl platform_configure
}

src_compile() {
	platform_compile () {
		cd "${BUILD_DIR}" || die
		ml_compile_abi() {
			if [[ "${EENIGMA}" == "vanilla" ]] ; then
				return
			fi
			cd "${BUILD_DIR}" || die
			local targets=( libpng-util libProtocols libEGM ENIGMA \
					emake )
			if use test ; then
				targets+=( emake-tests test-runner )
			fi
			targets+=( .FORCE )
			emake ${targets[@]}
		}
		multilib_foreach_abi ml_compile_abi
	}
	enigma_foreach_impl platform_compile
}

shrink_install() {
	rm -rf Compilers/{MacOSX,Windows} || die
	rm -rf Compilers/Linux/AppleCross64.ey || die
	rm -rf ENIGMAsystem/SHELL/Audio_Systems/{FMODAudio,iOSOpenAL} \
		|| die
	rm -rf ENIGMAsystem/SHELL/Bridges/{Cocoa-OpenGL,Cocoa-OpenGL1,\
Cocoa-OpenGL3,iPhone-OpenGLES,SDL-Direct3D,SDL-Direct3D11,SDL-Direct3D9,\
SDL-Win32} || die
	rm -rf ENIGMAsystem/SHELL/Makefiles/MacOSX || die
	rm -rf ENIGMAsystem/SHELL/Platforms/{Cocoa,iPhone} || die
	rm -rf ENIGMAsystem/SHELL/Widget_Systems/Cocoa || die

	if [[ "${EENIGMA}" == "wine" ]] ; then
		:;
	else
		if ! use wine ; then
			rm -rf Compilers/Linux/{MinGW32.ey,MinGW64.ey} || die
			rm -rf ENIGMAsystem/SHELL/Audio_Systems/\
{DirectSound,XAudio2} || die
			rm -rf ENIGMAsystem/SHELL/Bridges/{Win32,\
Win32-Direct3D11,Win32-Direct3D9,Win32-OpenGL,Win32-OpenGL1,Win32-OpenGL3} \
|| die
			rm -rf ENIGMAsystem/SHELL/Graphics_Systems/\
{Direct3D11,Direct3D9} || die
			rm -rf ENIGMAsystem/SHELL/Networking_Systems/\
DirectPlay || die
			rm -rf ENIGMAsystem/SHELL/Platforms/Win32 || die
			rm -rf ENIGMAsystem/SHELL/Widget_Systems/Win32 || die
		fi
	fi

	if [[ "${EENIGMA}" == "linux" ]] ; then
		if [[ "${ABI}" == amd64 ]] ; then
			rm -rf Compilers/Linux/{clang32.ey,gcc32.ey} || die
		elif [[ "${ABI}" == x86 ]] ; then
			rm -rf Compilers/Linux/{clang.ey,gcc.ey} || die
		fi
	elif [[ "${EENIGMA}" == "android" ]] ; then
		rm -rf Compilers/Linux/{clang32.ey,gcc32.ey} || die
		rm -rf Compilers/Linux/{clang.ey,gcc.ey} || die
	fi

	if [[ "${EENIGMA}" == "android" ]] ; then
		:;
	else
		if ! use android ; then
			rm -rf Compilers/Linux/{Android.ey,AndroidSym.ey} || die
			rm -rf ENIGMAsystem/SHELL/Audio_Systems/androidAudio || die
			rm -rf ENIGMAsystem/SHELL/Platforms/Android || die
		fi
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

src_install() {
	platform_install() {
		cd "${BUILD_DIR}" || die
		ml_install_abi() {
			if [[ "${EENIGMA}" == "vanilla" ]] \
				&& ! multilib_is_native_abi; then
				return
			fi

			cd "${BUILD_DIR}" || die
			local suffix=""
			local descriptor_suffix=""
			if [[ "${EENIGMA}" == "linux" ]] ; then
				suffix="-${ABI}"
				descriptor_suffix=" (${ABI})"
			fi
			insinto "/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}"
			exeinto "/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}"
			if [[ "${EENIGMA}" == "vanilla" ]] ; then
				doins -r CompilerSource CommandLine shared
			else
				if use minimal ; then
					shrink_install
				fi
				eapply \
"${FILESDIR}/enigma-9999_p20200124-makefile-stripped-for-production.patch"
			fi
			if [[ "${EENIGMA}" == "vanilla" ]] ; then
				:;
			else
				doexe emake
			fi
			doins -r ENIGMAsystem Compilers settings.ey events.res \
				Makefile
			exeinto /usr/bin
			cp "${FILESDIR}/enigma" "${FILESDIR}/enigma-cli" "${T}"
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${T}"/enigma || die
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${T}"/enigma-cli || die
			sed -i -e "s|PLATFORM|${EENIGMA}${suffix}|g" \
				"${T}"/enigma || die
			sed -i -e "s|PLATFORM|${EENIGMA}${suffix}|g" \
				"${T}"/enigma-cli || die
			mv "${T}/enigma"{,-${EENIGMA}${suffix}}
			mv "${T}/enigma-cli"{,-${EENIGMA}${suffix}}
			doexe "${T}/enigma-${EENIGMA}${suffix}" \
				"${T}/enigma-cli-${EENIGMA}${suffix}"
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${D}/usr/bin/enigma-${EENIGMA}${suffix}" || die
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${D}/usr/bin/enigma-cli-${EENIGMA}${suffix}" \
				|| die
			if [[ "${EENIGMA}" == "vanilla" ]] ; then
				:;
			else
				dolib.so libcompileEGMf.so libEGM.so \
					libProtocols.so
			fi
			newicon Resources/logo.png enigma.png
			make_desktop_entry \
				"/usr/bin/enigma-${EENIGMA}${suffix}" \
				"ENIGMA${descriptor_suffix}" \
				"/usr/share/pixmaps/enigma.png" \
				"Development;IDE"
		}
		multilib_foreach_abi ml_install_abi
	}
	enigma_foreach_impl platform_install

	cat ENIGMAsystem/SHELL/Universal_System/random.cpp | head -n 86 \
		> "${T}/license.random_cpp" || die
	dodoc "${T}/license.random_cpp"
}

pkg_postinst()
{
	einfo \
"When you run it the first time, it will compile the \n\
/usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is that the\n\
Run, Debug, and Compile buttons on LateralGM will not be available until\n\
ENIGMA is done.  You need to wait."
	if use android ; then
		einfo \
	"You need to modify /usr/$(get_libdir)/Compilers/Android.ey manually"
	fi
}
