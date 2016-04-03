# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Box2D"
HOMEPAGE="http://box2d.org/"
SRC_URI="https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz"

LICENSE="ZLIB"
SLOT="${PV:0:3}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc static"

RDEPEND="=dev-util/premake-4.4-r5
	 media-libs/glew
	 media-libs/glfw"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/Box2D-${PV}"

src_prepare() {
	cd "Box2D"
	if use static; then
		true
	else
		sed -i -e "s|StaticLib|SharedLib|g" "${S}"/Box2D/premake4.lua || die
	fi
	premake4 gmake
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" Build/gmake/Box2D.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/gmake/Box2D.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/gmake/GLUI.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/gmake/HelloWorld.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/gmake/Testbed.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" Build/gmake/GLUI.make || die
}

src_configure() {
	true
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	else
		mydebug="release"
	fi
	cd "${S}/Box2D/Build/gmake"
	LDDEPS="-lglfw -lGLEW" emake config="${mydebug}" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	else
		mydebug="Release"
	fi

	cd "${S}/Box2D/Build/gmake/bin/${mydebug}"
	mkdir -p "${D}/usr/$(get_libdir)"
	if use static; then
		cp libBox2D.a libGLUI.a "${D}/usr/$(get_libdir)" || die
	else
		cp libBox2D.so libGLUI.so "${D}/usr/$(get_libdir)" || die
	fi

	mkdir -p "${D}/usr/include/Box2D"
	cd "${S}/Box2D"
	FILES=$(find Box2D -name "*.h")
	for FILE in ${FILES}
	do
		mkdir -p "${D}/usr/include/$(dirname ${FILE})"
		cp "${FILE}" "${D}/usr/include/$(dirname ${FILE})"
	done

	cd "${S}/Box2D/Documentation"
	if use doc; then
		doxygen Doxyfile
		dodoc -r API images manual.docx
	fi
}
