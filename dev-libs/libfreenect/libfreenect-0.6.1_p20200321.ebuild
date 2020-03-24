# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/${PN}"
LICENSE="Apache-2.0 GPL-2 !bindist? ( all-rights-reserved )"
# The all-rights-reserved applies to the firmware.
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit multilib-minimal python-r1
IUSE="+bindist +c_sync +cxx doc +examples fakenect +opencv openni2 python"
EGIT_COMMIT="aa36dcee488b38ff8aec68425a9f596cb706da6d"
PYTHON_DEPEND="!bindist? 2"
CDEPEND="examples? ( media-libs/freeglut[${MULTILIB_USEDEP}]
			virtual/opengl[${MULTILIB_USEDEP}]
			x11-libs/libXi[${MULTILIB_USEDEP}]
			x11-libs/libXmu[${MULTILIB_USEDEP}] )
	opencv? ( media-libs/opencv[${MULTILIB_USEDEP}] )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] )
	virtual/libusb:1[${MULTILIB_USEDEP}]"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig[${MULTILIB_USEDEP}]"
SRC_URI=\
"https://github.com/OpenKinect/libfreenect/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
CMAKE_BUILD_TYPE=Release
inherit cmake-multilib
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
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

