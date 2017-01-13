# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils multilib python-r1


DESCRIPTION="Core library for accessing the Microsoft Kinect."
HOMEPAGE="https://github.com/OpenKinect/${PN}"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bindist +c_sync +cpp doc examples fakenect opencv openni2 python"
SRC_URI="https://github.com/OpenKinect/libfreenect/archive/v${PV}.tar.gz"

PYTHON_DEPEND="!bindist? 2"

COMMON_DEP="virtual/libusb:1
            examples? ( media-libs/freeglut
                        virtual/opengl
                        x11-libs/libXi
                        x11-libs/libXmu )
            opencv? ( media-libs/opencv )
            python? ( dev-python/numpy )"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
         dev-util/cmake
         virtual/pkgconfig
         doc? ( app-doc/doxygen )
         python? ( dev-python/cython )"


src_configure() {
    local mycmakeargs=(
        -DREDIST_PACKAGE=$(usex bindist  REDIST_PACKAGE)
        -DC_SYNC=$(usex c_sync)
        -DCPP=$(usex cpp)
        -DEXAMPLES=$(usex examples)
        -DFAKENECT=$(usex fakenect)
        -DCV=$(usex opencv)
        -DOPENNI2_DRIVER=$(usex openni2)
        -DPYTHON=$(usex python)
    )
    cmake-utils_src_configure
}

src_install() {
    cmake-utils_src_install

    # udev rules
    insinto /lib/udev/rules.d/
    doins "${S}"/platform/linux/udev/51-kinect.rules

    # documentation
    dodoc README.md
    if use doc; then
        cd doc
        doxygen || ewarn "doxygen failed"
        dodoc -r html || ewarn "dodoc failed"
        cd -
    fi
}

pkg_postinst() {
    if ! use bindist; then
        ewarn "The bindist USE flag is disabled. Resulting binaries may not be legal to re-distribute."
    fi
    elog "Make sure your user is in the 'video' group"
    elog "Just run 'gpasswd -a <USER> video', then have <USER> re-login."
}

