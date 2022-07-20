# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CXX_STANDARD="-std=c++17"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"

EPLATFORMS="vanilla android linux wine"
inherit desktop eutils flag-o-matic git-r3 multilib-minimal platforms \
toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation,
is an open source cross-platform game development environment."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"

# Live ebuilds don't get KEYWORDS

# CI/install_emake_deps.sh
H1_EXPECTED="\
6aa51272355b17e5deb0a45fb273da7c89cb04310effe1b8af2c7157c97f9fd6\
1134396a323c77de3199f5842792afdf8bd8fb537c7592f237f154891b6ade42\
"
# CI/solve_engine_deps.sh
H2_EXPECTED="\
7280ba40ef064b63a626626a35082d216e2cb705637ed87e9e707cdd28f1fa2d\
7bdb2256a0c54413313eabf7b44d0ad2e7ed39f1a663a755bdbe28e202494193\
"

DEPENDS_FINGERPRINT="5f085da2480c8f666890b0997357735fe48ce6dd8356e998d1fba23539d2ca2a92f244e30a25763f006901a164b1f2ab27b9df2926302a945ea8a70c7d412428"
SLOT="0/${DEPENDS_FINGERPRINT}"
IUSE+=" android box2d bullet clang curl doc gles gles2 gles3 gme gnome gtk2 kde
linux minimal +openal +opengl opengl1 +opengl3 radialgm sdl2 test +vanilla +X"
REQUIRED_USE+="
	gles? ( sdl2 )
	gles2? ( gles opengl )
	gles3? ( gles opengl )
	opengl? ( || ( sdl2 X ) )
	opengl1? ( opengl )
	opengl3? ( opengl )
"
#
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
# See CI for *DEPENDs
CLANG_PV="10.0.0"
GCC_PV="10.2.0"
BOOST_PV="1.71"
GLM_PV="0.9.9.7"
MESA_PV="20.2.6"
ZLIB_PV="1.2.11"
CDEPEND="
	>=dev-libs/protobuf-3.6.1.3[${MULTILIB_USEDEP}]
	>=sys-devel/gcc-${GCC_PV}
	radialgm? ( >=net-libs/grpc-1.16.1[${MULTILIB_USEDEP}] )
"
DEPEND+="
	${CDEPEND}
	dev-cpp/abseil-cpp[${MULTILIB_USEDEP}]
	>=dev-cpp/yaml-cpp-0.6.2[${MULTILIB_USEDEP}]
	>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
	dev-libs/double-conversion[${MULTILIB_USEDEP}]
	dev-libs/libffi[${MULTILIB_USEDEP}]
	dev-libs/libpcre2[${MULTILIB_USEDEP},pcre16]
	>=dev-libs/openssl-1.1.1f[${MULTILIB_USEDEP}]
	>=dev-libs/pugixml-1.10[${MULTILIB_USEDEP}]
	>=dev-libs/rapidjson-1.1.0
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/harfbuzz[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.37[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	virtual/libc
	android? (
		>=dev-util/android-ndk-23
		dev-util/android-sdk-update-manager
	)
	box2d? (
		|| (
			<dev-games/box2d-2.4:2.3[${MULTILIB_USEDEP}]
			<games-engines/box2d-2.4:2.3.0[${MULTILIB_USEDEP}]
		)
	)
	bullet? ( sci-physics/bullet[${MULTILIB_USEDEP}] )
	curl? ( >=net-misc/curl-7.68[${MULTILIB_USEDEP}] )
	gles? (
		>=media-libs/glm-${GLM_PV}
		>=media-libs/libepoxy-1.5.4[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
	)
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	gnome? ( gnome-extra/zenity )
	gtk2? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	kde? ( kde-apps/kdialog )
	openal? (
		media-libs/alure[${MULTILIB_USEDEP}]
		media-libs/dumb[${MULTILIB_USEDEP}]
		media-libs/openal[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=media-libs/glew-2.1.0[${MULTILIB_USEDEP}]
		>=media-libs/glm-${GLM_PV}
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
	)
	radialgm? ( >=net-dns/c-ares-1.15[${MULTILIB_USEDEP}] )
	sdl2? ( >=media-libs/libsdl2-2.0.10[${MULTILIB_USEDEP},gles2?] )
	wine? (
		sys-devel/crossdev
		virtual/wine
	)
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	)
"

RDEPEND+=" ${DEPEND}"
LLVM_SLOTS=(10 11 12 13 14 15)

gen_clang_deps() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			>=sys-devel/lld-${s}
		)
		"
	done
}

BDEPEND+=" ${CDEPEND}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-util/cmake-3.16.8
	clang? ( || ( $(gen_clang_deps) ) )
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
		>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
"
S="${WORKDIR}/enigma-dev-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( Readme.md )

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	if tc-is-gcc ; then
		if ver_test $(gcc-version) -lt ${GCC_PV} ; then
eerror
eerror "You need to update your GCC to >= ${GCC_PV} via eselect or switch to"
eerror "Clang/LLVM to >= ${CLANG_PV} in your per-package environmental variable"
eerror "settings."
eerror
			die
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_PV} ; then
eerror
eerror "You need to update your Clang/LLVM to >= ${CLANG_PV} or switch to"
eerror "GCC >= ${GCC_PV} via eselect in your per-package environmental variable"
eerror "settings."
eerror
			die
		fi
	else
		die "Compiler CC=${CC} CXX=${CXX} is not supported"
	fi
	if test-flags ${CXX_STANDARD} ; then
eerror
eerror "The compiler doesn't support ${CXX_STANDARD} flag."
eerror "Switch the compiler."
eerror
		die
	fi
	local dfp=$(echo "${RDEPEND}:${DEPEND}:${BDEPEND}" | sha512sum | cut -f 1 -d " ")
	if [[ "${dfp}" != "${DEPENDS_FINGERPRINT}" ]] ; then
		# No versioning.
eerror
eerror "CURRENT_DEPENDS_FINGERPRINT:	${dfp}"
eerror "EXPECTED_DEPENDS_FINGERPRINT:	${DEPENDS_FINGERPRINT}"
eerror
eerror "Update the DEPENDS_FINGERPRINT."
eerror
		die
	fi
}

src_prepare() {
	default
	F=( Makefile CommandLine/emake/Makefile CompilerSource/Makefile )
	for f in ${F[@]} ; do
		einfo "Editing $f"
		sed -i -e "s|-Wl,-rpath,./||g" "${f}" || die
	done
	platforms_copy_sources
	platform_prepare() {
		cd "${BUILD_DIR}" || die
		multilib_copy_sources
	}
	platforms_foreach_impl platform_prepare
	if use android ; then
ewarn
ewarn "Android support is experimental."
ewarn
	fi
	if use wine ; then
ewarn
ewarn "WINE support is experimental and may not work and be feature complete."
ewarn
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	h1=$(sha512sum "CI/install_emake_deps.sh" | cut -f 1 -d " ")
	h2=$(sha512sum "CI/solve_engine_deps.sh" | cut -f 1 -d " ")
	if [[ "${h1}" != "${H1_EXPECTED}" && "${h2}" != "${H2_EXPECTED}" ]] ; then
eerror
eerror "The dependencies have changed.  Notify ebuild maintainer."
eerror
		die
	fi
	local p="${FILESDIR}/enigma-9999_p20200906-makefile-stripped-for-production.patch"
	if ! patch --dry-run "${p}" ; then
eerror
eerror "Patch dry-run failed.  Please update ${p}"
eerror
		die
	fi
}

src_configure() {
	platform_configure() {
		cd "${BUILD_DIR}" || die
		ml_configure_abi() {
			cd "${BUILD_DIR}" || die
			if [[ "${EPLATFORM}" == "android" ]] ; then
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
	platforms_foreach_impl platform_configure
}

src_compile() {
	platform_compile () {
		cd "${BUILD_DIR}" || die
		ml_compile_abi() {
			cd "${BUILD_DIR}" || die
			# libpng-util lacks a main()
			use radialgm && export CLI_ENABLE_SERVER=TRUE
			local targets=(
				ENIGMA
				emake
				gm2egm
				libProtocols
				libEGM
				gm2egm
			)
			use test && targets+=( emake-tests test-runner )
			targets+=( .FORCE )
			emake ${targets[@]}
			use radialgm && unset CLI_ENABLE_SERVER
		}
		multilib_foreach_abi ml_compile_abi
	}
	platforms_foreach_impl platform_compile
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

	if [[ "${EPLATFORM}" == "wine" ]] ; then
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

	if [[ "${EPLATFORM}" == "linux" ]] ; then
		if [[ "${ABI}" == amd64 ]] ; then
			rm -rf Compilers/Linux/{clang32.ey,gcc32.ey} || die
		elif [[ "${ABI}" == x86 ]] ; then
			rm -rf Compilers/Linux/{clang.ey,gcc.ey} || die
		fi
	elif [[ "${EPLATFORM}" == "android" ]] ; then
		rm -rf Compilers/Linux/{clang32.ey,gcc32.ey} || die
		rm -rf Compilers/Linux/{clang.ey,gcc.ey} || die
	fi

	if [[ "${EPLATFORM}" == "android" ]] ; then
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

ml_install_abi() {
	cd "${BUILD_DIR}" || die
	if [[ "${EPLATFORM}" == "vanilla" ]] \
		&& ! multilib_is_native_abi; then
		return
	fi

	cd "${BUILD_DIR}" || die
	local suffix=""
	local descriptor_suffix=""
	if [[ "${EPLATFORM}" == "linux" ]] ; then
		suffix="-${ABI}"
		descriptor_suffix=" (${ABI})"
	fi
	insinto "/usr/$(get_libdir)/enigma/${EPLATFORM}${suffix}"
	exeinto "/usr/$(get_libdir)/enigma/${EPLATFORM}${suffix}"
	if [[ "${EPLATFORM}" == "vanilla" ]] ; then
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
"/usr/$(get_libdir)/enigma/${EPLATFORM}${suffix}/CommandLine"
		doins -r CommandLine/libEGM
	fi
	exeinto /usr/bin
	cp "${FILESDIR}/enigma" "${FILESDIR}/enigma-cli" "${T}"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${T}"/enigma || die
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${T}"/enigma-cli || die
	sed -i -e "s|PLATFORM|${EPLATFORM}${suffix}|g" \
		"${T}"/enigma || die
	sed -i -e "s|PLATFORM|${EPLATFORM}${suffix}|g" \
		"${T}"/enigma-cli || die
	mv "${T}/enigma"{,-${EPLATFORM}${suffix}}
	mv "${T}/enigma-cli"{,-${EPLATFORM}${suffix}}
	doexe "${T}/enigma-${EPLATFORM}${suffix}" \
		"${T}/enigma-cli-${EPLATFORM}${suffix}"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/enigma-${EPLATFORM}${suffix}" || die
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/enigma-cli-${EPLATFORM}${suffix}" \
		|| die
	newicon Resources/logo.png enigma.png
	make_desktop_entry \
		"/usr/bin/enigma-${EPLATFORM}${suffix}" \
		"ENIGMA${descriptor_suffix}" \
		"/usr/share/pixmaps/enigma.png" \
		"Development;IDE"
}

src_install() {
	platform_install() {
		cd "${BUILD_DIR}" || die
		multilib_foreach_abi ml_install_abi
	}
	platforms_foreach_impl platform_install

	cat ENIGMAsystem/SHELL/Universal_System/random.cpp | head -n 86 \
		> "${T}/license.random_cpp" || die
	dodoc "${T}/license.random_cpp"
}

pkg_postinst()
{
	if use android ; then
einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/Android.ey manually"
einfo
	fi
}
