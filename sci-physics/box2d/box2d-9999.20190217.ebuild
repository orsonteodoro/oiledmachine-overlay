# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Box2D"
HOMEPAGE="http://box2d.org/"
COMMIT="ef96a4f17f1c5527d20993b586b400c2617d6ae1"
SRC_URI="https://github.com/erincatto/Box2D/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc static"

RDEPEND=">=dev-util/premake-5.0
	 media-libs/glew
	 media-libs/glfw"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/Box2D-${COMMIT}"

src_prepare() {
	if use static; then
		true
	else
		sed -i -e "s|StaticLib|SharedLib|g" "${S}"/premake5.lua || die
	fi
	premake5 gmake
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" Build/Box2D.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/Box2D.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/HelloWorld.make || die
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" -e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" Build/Testbed.make || die

	eapply_user
}

src_configure() {
	true
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug_x86_64"
	else
		mydebug="release_x86_64"
	fi
	cd "${S}/Build"
	LDDEPS="-lglfw -lGLEW" emake config="${mydebug}" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	else
		mydebug="Release"
	fi

	cd "${S}/Build/bin/x86_64/${mydebug}"
	mkdir -p "${D}/usr/$(get_libdir)"
	if use static; then
		cp libBox2D.a "${D}/usr/$(get_libdir)" || die
	else
		cp libBox2D.so "${D}/usr/$(get_libdir)" || die
	fi

	mkdir -p "${D}/usr/include/Box2D"
	cd "${S}/Box2D"
	FILES=$(find . -name "*.h")
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
