# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake-multilib flag-o-matic multilib-minimal python-single-r1

DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/${PN}"
LICENSE="
	Apache-2.0
	GPL-2
	!audio-firmware? (
		all-rights-reserved
	)
"
# The all-rights-reserved applies to the firmware.
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
-audio-firmware +bindist -csharp +c-sync +cxx doc +examples +fakenect -opencv
-openni2 -python r1
"
REQUIRED_USE+="
	!bindist? (
		audio-firmware
	)
	audio-firmware? (
		!bindist
	)
	python? (
		${PYTHON_REQUIRED_USE}
		c-sync
	)
"
DEPEND+="
	virtual/libusb:1[${MULTILIB_USEDEP}]
	examples? (
		media-libs/freeglut[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXmu[${MULTILIB_USEDEP}]
	)
	opencv? (
		media-libs/opencv[${MULTILIB_USEDEP}]
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.12.4
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? (
		app-doc/doxygen
	)
	python? (
		${PYTHON_DEPS}
	)
"
PDEPEND+="
	csharp? (
		dev-dotnet/libfreenect
	)
"
SRC_URI="
https://github.com/OpenKinect/libfreenect/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/libfreenect-0.6.0-custom-cmake-lib-path.patch"
	"${FILESDIR}/libfreenect-0.7.0-fix-freenect.pyx-headers.patch"
)
DOCS=( README.md )

pkg_setup() {
	if ! use bindist ; then
		if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added as a"
eerror "per-package environment variable to be able to download the audio"
eerror "firmware."
eerror
			die
		fi
	fi
	use python && python-single-r1_pkg_setup
}

src_configure() {
	export MAKEOPTS="-j1"
	if use python ; then
		append-cppflags -DNPY_NO_DEPRECATED_API=NPY_1_7_API_VERSION
	fi
	local mycmakeargs=(
		-DBUILD_C_SYNC=$(usex c-sync)
		-DBUILD_CPP=$(usex cxx)
		-DBUILD_CV=$(usex opencv)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_FAKENECT=$(usex fakenect)
		-DBUILD_OPENNI2_DRIVER=$(usex openni2)
		-DBUILD_PYTHON=OFF # It actually turns both BUILD_PYTHON2=ON BUILD_PYTHON3=ON on.
		-DBUILD_PYTHON2=OFF
		-DBUILD_PYTHON3=$(usex python)
		-DBUILD_REDIST_PACKAGE=$(usex !audio-firmware REDIST_PACKAGE)
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake-multilib_src_configure
}

src_compile() {
	if use audio-firmware ; then
ewarn
ewarn "The build scripts will be downloading firmware from the background."
ewarn "Please wait."
ewarn
	fi
	cmake-multilib_src_compile
}

src_install() {
	cmake-multilib_src_install

	insinto /lib/udev/rules.d/
	doins "${S}/platform/linux/udev/51-kinect.rules"

	if use doc; then
		cd doc || die
		doxygen || die
		dodoc -r html
	fi

	cd "${S}" || die
	einstalldocs
	docinto licenses
	dodoc APACHE20 GPL2
}

pkg_postinst() {
	if ! use audio-firmware ; then
ewarn
ewarn "The audio-firmware USE flag is enabled.  The resulting binaries may NOT"
ewarn "be legal to re-distribute."
ewarn
	fi
ewarn
ewarn "Make sure your user is in the 'video' group"
ewarn "Run 'gpasswd -a <USER> video', then have <USER> re-login."
ewarn
}
