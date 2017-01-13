# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils multilib-minimal multilib-build

DESCRIPTION="libbulletc is a BulletSharpPInvoke dependency that merges all Bullet Physics Library modules into one."
HOMEPAGE=""
LIBBULLETC_VERSION="0.9"
PROJECT_NAME="BulletSharpPInvoke"
SRC_URI="https://github.com/AndresTraks/${PROJECT_NAME}/archive/${LIBBULLETC_VERSION}.tar.gz -> ${PN}-${LIBBULLETC_VERSION}.tar.gz
         https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz -> bullet-${PV}.tar.gz"

LICENSE="MIT zlib"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="bullet3"
REQUIRED_USE=""

RDEPEND=""
DEPEND="${RDEPEND}
"

S="${WORKDIR}/${PROJECT_NAME}-${LIBBULLETC_VERSION}"

src_unpack() {
	unpack ${A}
	mv bullet3-${PV} bullet
}

src_prepare() {
	sed -i -r -e 's|ADD_SUBDIRECTORY\(test\)||g' libbulletc/CMakeLists.txt || die
	S="${WORKDIR}/${PROJECT_NAME}-${LIBBULLETC_VERSION}/libbulletc" \
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
        local mycmakeargs=(
		-DBUILD_BULLET3=$(usex bullet3)
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	mkdir -p "${D}/usr/$(get_libdir)"
	cp -a "${WORKDIR}/${PROJECT_NAME}-${LIBBULLETC_VERSION}-${MULTILIB_ABI_FLAG}.${ABI}/libbulletc.so" "${D}/usr/$(get_libdir)"
}
