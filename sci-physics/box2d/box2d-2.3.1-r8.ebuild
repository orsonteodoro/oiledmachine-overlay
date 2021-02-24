# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake-utils multilib-build static-libs

DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT_MAJ="$(ver_cut 1-2 ${PV})"
SLOT="${SLOT_MAJ}/${PV}"
IUSE+=" doc examples test"
REQUIRED_USE+=" test? ( examples )"
DEPEND+=" examples? (
		media-libs/glew[${MULTILIB_USEDEP}]
		media-libs/glfw[${MULTILIB_USEDEP}]
		media-libs/glui[${MULTILIB_USEDEP}]
		media-libs/freeglut:=[${MULTILIB_USEDEP},static-libs] )
	virtual/libc"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-2.6"
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Box2D-${PV}/Box2D"
RESTRICT="mirror"
_PATCHES=(
	"${FILESDIR}/box2d-2.3.1-cmake-fixes.patch"
)
CMAKE_BUILD_TYPE="Release"
MY_PN="Box2D"

src_prepare() {
	default

	cd "${S}/.." || die
	eapply "${_PATCHES[@]}"
	cd "${S}" || die

	prepare_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_prepare
		}
		static-libs_copy_sources
		static-libs_foreach_impl \
			static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	local mycmakeargs=(
		-DDOC_DEST_DIR=${PN}-${PVR}
		-DBOX2D_INSTALL_DOC=$(usex doc)
		-DBOX2D_BUILD_EXAMPLES=$(usex examples)
	)
	configure_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_configure() {
			cd "${BUILD_DIR}" || die
			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				mycmakeargs+=( -DBOX2D_BUILD_SHARED=ON )
			elif [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
				mycmakeargs+=( -DBOX2D_BUILD_STATIC=ON )
			fi
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_configure
		}
		static-libs_foreach_impl \
			static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_test() {
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}"
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
			cd "${BUILD_DIR}" || die

			if [[ -x HelloWorld/HelloWorld ]] ; then
				./HelloWorld/HelloWorld || die
			else
				die "No unit test exist for ABI=${ABI} STSH=${ESTSH_LIB_TYPE}"
			fi
		}
		static-libs_foreach_impl \
			static-libs_test
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_install

			if use examples ; then
				exeinto /usr/share/${PN}/Testbed
				doexe Testbed/Testbed

				exeinto /usr/share/${PN}/HelloWorld
				doexe HelloWorld/HelloWorld
			fi
		}
		static-libs_foreach_impl \
			static-libs_install
	}
	multilib_foreach_abi install_abi

	if use examples ; then
		cd "${S}"
		insinto /usr/share/${PN}/HelloWorld
		doins -r HelloWorld/*
	fi
}

pkg_postinst() {
	ewarn "This was the last major.minor version released in 2014 and is no longer receiving updates."
}
