# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TRAIN_SIGNAL=6
TRAIN_USE_X_GPU=1
TRAIN_TEST_DURATION=15
#TRAIN_USE_X=1
inherit cmake multilib-build uopts

DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT_MAJ="$(ver_cut 1-2 ${PV})"
SLOT="${SLOT_MAJ}/${PV}"
IUSE+=" doc examples static-libs test r1"
REQUIRED_USE+="
	test? (
		examples
	)
	bolt? (
		examples
	)
	pgo? (
		examples
	)
	ebolt? (
		examples
	)
	epgo? (
		examples
	)
"
DEPEND+="
	virtual/libc
	examples? (
		media-libs/freeglut:=[${MULTILIB_USEDEP},static-libs]
		media-libs/glew[${MULTILIB_USEDEP}]
		media-libs/glfw[${MULTILIB_USEDEP}]
		media-libs/glui[${MULTILIB_USEDEP}]
		media-fonts/droid
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-2.6"
SRC_URI="
https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}/Box2D"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-2.3.1-cmake-fixes.patch"
	"${FILESDIR}/${PN}-2.3.1-change-font.patch"
	"${FILESDIR}/${PN}-2.3.1-envvar-testbed-select.patch"
	"${FILESDIR}/${PN}-2.3.1-testbed-close-handlers.patch"
	"${FILESDIR}/${PN}-2.3.1-testbed-autoshoot.patch"
)
CMAKE_BUILD_TYPE="Release"
MY_PN="Box2D"

# Order matters when PGOing
get_lib_types() {
	echo "shared"
	if use static-libs ; then
		echo "static"
	fi
}

pkg_setup() {
	uopts_setup

	# The GLFW does not allow for software rendering.
	# This is why hardware rendering is required.
	if ( use pgo || use bolt ) \
		&& ( has pid-sandbox ${FEATURES} ) ; then
eerror
eerror "You must disable the pid-sandbox for PGO/BOLT training."
eerror
eerror "pid-sandbox is required for checking if X11 is being used."
eerror
eerror "Add a per-package environment rule with the following additions or"
eerror "changes..."
eerror
eerror "${EROOT}/etc/portage/env/no-pid-sandbox.conf:"
eerror "FEATURE=\"\${FEATURES} -pid-sandbox\""
eerror
eerror "${EROOT}/etc/portage/package.env:"
eerror "${CATEGORY}/${PN} no-pid-sandbox.conf"
eerror
		die
	fi

	local pid="$$"
einfo "PID=${pid}"
	local display=$(grep -z "^DISPLAY=" "/proc/${pid}/environ" \
		| cut -f 2 -d "=")
einfo "DISPLAY=${display}"
	if ( use pgo || use bolt ) \
		&& [[ -z "${display}" ]] ; then
eerror
eerror "You must run X to do GPU based PGO/BOLT training."
eerror
		die
	fi

	if ( use pgo || use bolt ) \
		&& ! ( DISPLAY="${TRAIN_DISPLAY:-${display}}" xhost \
			| grep -q -e "LOCAL:" ) ; then
eerror
eerror "You must do:  \`xhost +local:root:\` to do GPU based PGO/BOLT training."
eerror
		die
	fi
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cp -a "${S}" "${CMAKE_USE_DIR}" || die
			uopts_src_prepare
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() { :; }

_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"
	export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${CMAKE_USE_DIR}" || die
	uopts_src_configure

	# Big performance drop with Testbed's tumbler with all -O* flags

	local mycmakeargs=(
		-DDOC_DEST_DIR=${PN}-${PVR}
		-DBOX2D_INSTALL_DOC=$(usex doc)
		-DBOX2D_BUILD_EXAMPLES=$(usex examples)
	)
	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=( -DBOX2D_BUILD_SHARED=ON )
	else
		mycmakeargs+=( -DBOX2D_BUILD_STATIC=ON )
	fi
	cmake_src_configure
}

_src_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			if [[ "${lib_type}" == "static" ]] ; then
				uopts_n_training
			else
				uopts_y_training
			fi

			uopts_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

TRAINER_MAX=51
train_pre_trainer() {
	local trainer="${1}"
	export BOX2D_TESTBED_INDEX=${trainer}
	einfo "pwd:  $(pwd)"
	einfo "trainer:  ${trainer}/${TRAINER_MAX}"
}

train_post_trainer() {
	unset BOX2D_TESTBED_INDEX
}

train_get_trainer_exe() {
	echo "Testbed/Testbed"
}

train_trainer_list() {
	seq 0 ${TRAINER_MAX} | tr " " "\n"
}

_src_post_train() {
	killall -9 Testbed
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			if [[ -x HelloWorld/HelloWorld ]] ; then
				./HelloWorld/HelloWorld || die
			else
				die "No unit test exist for ABI=${ABI} lib_type=${lib_type}"
			fi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
			if use examples ; then
				exeinto /usr/share/${PN}/Testbed
				doexe Testbed/Testbed

				exeinto /usr/share/${PN}/HelloWorld
				doexe HelloWorld/HelloWorld
			fi
			uopts_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	if use examples ; then
		cd "${S}"
		insinto /usr/share/${PN}/HelloWorld
		doins -r HelloWorld/*
	fi
}

pkg_postinst() {
ewarn
ewarn "This was the last major.minor version released in 2014 and is no longer"
ewarn "receiving updates."
ewarn
	uopts_pkg_postinst
	if ( use pgo || use bolt ) ; then
ewarn
ewarn "You must run \`xhost -local:root:\` after PGO training to restore the"
ewarn "security default."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib-support, static-libs
