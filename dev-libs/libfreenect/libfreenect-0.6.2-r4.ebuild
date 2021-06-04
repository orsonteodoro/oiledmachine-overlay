# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib multilib-minimal python-single-r1

DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/${PN}"
LICENSE="Apache-2.0 GPL-2 !bindist? ( all-rights-reserved )"
# The all-rights-reserved applies to the firmware.
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" +bindist +c_sync +cxx doc +examples fakenect +opencv openni2 python"
REQUIRED_USE+=" python? ( ${PYTHON_REQUIRED_USE} )"
DEPEND+="
	examples? ( media-libs/freeglut[${MULTILIB_USEDEP}]
			virtual/opengl[${MULTILIB_USEDEP}]
			x11-libs/libXi[${MULTILIB_USEDEP}]
			x11-libs/libXmu[${MULTILIB_USEDEP}] )
	opencv? ( media-libs/opencv[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
	)
	virtual/libusb:1[${MULTILIB_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.12.4
	python? ( ${PYTHON_DEPS} )
	doc? ( app-doc/doxygen )
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)"
SRC_URI="
https://github.com/OpenKinect/libfreenect/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/libfreenect-0.6.0-custom-cmake-lib-path.patch" )
DOCS=( README.md )

pkg_setup() {
	if ! use bindist ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to download\n\
the audio firmware."
		fi
	fi
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_C_SYNC=$(usex c_sync)
		-DBUILD_CPP=$(usex cxx)
		-DBUILD_CV=$(usex opencv)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_FAKENECT=$(usex fakenect)
		-DBUILD_OPENNI2_DRIVER=$(usex openni2)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_REDIST_PACKAGE=$(usex bindist REDIST_PACKAGE)
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	insinto /lib/udev/rules.d/
	doins "${S}"/platform/linux/udev/51-kinect.rules

	if use doc; then
		cd doc || die
		doxygen || die
		dodoc -r html
	fi

	cd "${S}" || die
	docinto licenses
	dodoc APACHE20 GPL2
}

pkg_postinst() {
	if ! use bindist; then
		ewarn \
"The bindist USE flag is disabled. Resulting binaries may not be legal to \
	re-distribute."
	fi
	elog "Make sure your user is in the 'video' group"
	elog "Just run 'gpasswd -a <USER> video', then have <USER> re-login."
}
