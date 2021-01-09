# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop enigma eutils multilib-minimal toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
is an open source cross-platform game development environment influenced by \
the popular software Game Maker."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" android box2d bullet clang curl doc gles gles2 gles3 gme gnome gtk2 kde \
linux minimal +openal +opengl opengl1 opengl3 radialgm sdl2 test +vanilla +X"
REQUIRED_USE+="
	gles? ( sdl2 )
	gles2? ( gles opengl )
	gles3? ( gles opengl )
	opengl? ( || ( sdl2 X ) )
	opengl1? ( opengl )
	opengl3? ( opengl )"
# For some list of dependencies, see
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/install_emake_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/solve_engine_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/build_sdl.sh
# grep -r -F -e "find_library(" -e "find_package("
#
# No code references but only on build files: libvorbis3, vorbisfile,
# pulseaudio, libpulse
# media-libs/libvorbis[${MULTILIB_USEDEP}] # line to be placed in openal RDEPEND
#
# The design for WINE support requires a chroot containing a mingw toolchain.
# See https://wiki.gentoo.org/wiki/Mingw for details.
CDEPEND="dev-libs/protobuf[${MULTILIB_USEDEP}]"
DEPEND="${CDEPEND}
	android? ( dev-util/android-ndk
		   dev-util/android-sdk-update-manager )
	box2d? ( sci-physics/box2d[${MULTILIB_USEDEP}] )
	bullet? ( sci-physics/bullet[${MULTILIB_USEDEP}] )
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	dev-cpp/yaml-cpp[${MULTILIB_USEDEP}]
	dev-libs/boost[${MULTILIB_USEDEP}]
	dev-libs/libffi[${MULTILIB_USEDEP}]
	dev-libs/double-conversion[${MULTILIB_USEDEP}]
	dev-libs/libpcre2[${MULTILIB_USEDEP},pcre16]
	dev-libs/openssl[${MULTILIB_USEDEP}]
	dev-libs/pugixml[${MULTILIB_USEDEP}]
	dev-libs/rapidjson
	games-misc/lgmplugin
	games-util/lateralgm[android?,linux?,vanilla?,${MULTILIB_USEDEP}]
	gles? (	media-libs/glm
		media-libs/libepoxy[${MULTILIB_USEDEP}]
		media-libs/mesa[${MULTILIB_USEDEP}] )
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	gnome? ( gnome-extra/zenity )
	gtk2? ( x11-libs/gtk+[${MULTILIB_USEDEP}] )
	kde? ( kde-apps/kdialog )
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/harfbuzz[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]
	openal? ( media-libs/alure[${MULTILIB_USEDEP}]
		  media-libs/dumb[${MULTILIB_USEDEP}]
		 media-libs/openal[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/glew[${MULTILIB_USEDEP}]
		  media-libs/glm
		  media-libs/mesa[${MULTILIB_USEDEP}] )
	radialgm? ( net-dns/c-ares[${MULTILIB_USEDEP}]
		    net-libs/grpc[${MULTILIB_USEDEP}] )
	sdl2? ( >=media-libs/libsdl2-2.0.12[${MULTILIB_USEDEP},gles2?] )
	sys-libs/zlib[${MULTILIB_USEDEP}]
	wine? ( sys-devel/crossdev
		 virtual/wine )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}]
	     sys-libs/zlib[${MULTILIB_USEDEP}] )
	virtual/jpeg[${MULTILIB_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND="${CDEPEND}
	!clang? (
		>=sys-devel/gcc-9
	)
	clang? (
		>=sys-devel/clang-10[${MULTILIB_USEDEP}]
		>=sys-devel/lld-10
		>=sys-devel/llvm-10[${MULTILIB_USEDEP}]
	)
	>=dev-util/cmake-3.14
	dev-util/pkgconfig[${MULTILIB_USEDEP}]
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}]
		dev-libs/boost[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}] )"
EGIT_COMMIT="4a68e94a9b42dbc150cb695ba30a3838253fa6a1"
SRC_URI=\
"https://github.com/enigma-dev/enigma-dev/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/enigma-dev-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( Readme.md )

pkg_setup() {
	CC=$(tc-getCC)
	CXX=$(tc-getCXX)
	if tc-is-gcc ; then
		if ver_test $(gcc-version) -lt 9 ; then
			die \
"You need to update your GCC to >=9 via eselect or switch to Clang/LLVM to \
>=10 in your per-package environmental variable settings."
		fi
	elif tc-is-clang ; then
		if ver_test $(gcc-version) -lt 10 ; then
			die \
"You need to update your Clang/LLVM to >=10 or switch to GCC >=9 via eselect \
in your per-package environmental variable settings."
		fi
	else
		die "Compiler CC=${CC} CXX=${CXX} is not supported"
	fi
}

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
	if use android ; then
		ewarn "Android support is experimental"
	fi
	if use wine ; then
		ewarn \
"WINE support is experimental and may not work and be feature complete."
	fi
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

			if use openal ; then
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
			cd "${BUILD_DIR}" || die
			# libpng-util lacks a main()
			if use radialgm ; then
				export CLI_ENABLE_SERVER=TRUE
			fi
			local targets=( ENIGMA emake gm2egm \
					libProtocols libEGM gm2egm )
			if use test ; then
				targets+=( emake-tests test-runner )
			fi
			targets+=( .FORCE )
			emake ${targets[@]}
			if use radialgm ; then
				unset CLI_ENABLE_SERVER
			fi
		}
		multilib_foreach_abi ml_compile_abi
	}
	enigma_foreach_impl platform_compile
}

shrink_install() {
	rm -rf Compilers/{MacOSX,Windows} || die
	rm -rf Compilers/Linux/AppleCross64.ey || die
	rm -rf ENIGMAsystem/SHELL/Audio_Systems/{FMODAudio,iOSOpenAL} || die
	rm -rf \
ENIGMAsystem/SHELL/Bridges/{Cocoa-OpenGL,Cocoa-OpenGL1,Cocoa-OpenGL3,\
iPhone-OpenGLES,SDL-Direct3D,SDL-Direct3D11,SDL-Direct3D9,SDL-Win32} || die
	rm -rf ENIGMAsystem/SHELL/Makefiles/MacOSX || die
	rm -rf ENIGMAsystem/SHELL/Platforms/{Cocoa,iPhone} || die
	rm -rf ENIGMAsystem/SHELL/Widget_Systems/Cocoa || die

	if [[ "${EENIGMA}" == "wine" ]] ; then
		:;
	else
		if ! use wine ; then
			rm -rf Compilers/Linux/{MinGW32.ey,MinGW64.ey} || die
			rm -rf \
ENIGMAsystem/SHELL/Audio_Systems/{DirectSound,XAudio2} || die
			rm -rf \
ENIGMAsystem/SHELL/Bridges/{Win32,Win32-Direct3D11,Win32-Direct3D9,\
Win32-OpenGL,Win32-OpenGL1,Win32-OpenGL3} || die
			rm -rf \
ENIGMAsystem/SHELL/Graphics_Systems/{Direct3D11,Direct3D9} || die
			rm -rf \
ENIGMAsystem/SHELL/Networking_Systems/DirectPlay || die
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
			rm -rf ENIGMAsystem/SHELL/Audio_Systems/androidAudio \
				|| die
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
		rm -rf \
ENIGMAsystem/SHELL/Graphics_Systems/{OpenGL-Debug,OpenGL-Desktop} || die
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
			cd "${BUILD_DIR}" || die
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
"${FILESDIR}/enigma-9999_p20200906-makefile-stripped-for-production.patch"
			fi
			if use radialgm ; then
				doexe emake
			fi
			doexe libcompileEGMf.so libEGM.so libENIGMAShared.so \
				libProtocols.so gm2egm
			doins -r ENIGMAsystem Compilers settings.ey events.ey \
				Config.mk Makefile
			if use radialgm ; then
				insinto \
		"/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}/CommandLine"
				doins -r CommandLine/libEGM
			fi
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
