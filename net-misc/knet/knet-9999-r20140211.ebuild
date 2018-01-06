# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils git-r3

DESCRIPTION="kNet"
HOMEPAGE="https://github.com/juj/kNet"
SRC_URI="https://github.com/juj/kNet/archive/2.7.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="samples boost tinyxml qt4 debug static static-libs"

RDEPEND="boost? ( dev-libs/boost[threads,static-libs=,knet] )
	 tinyxml? ( dev-libs/tinyxml )
	 qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 dev-qt/designer:4 )
        "
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"

S="${WORKDIR}/knet-9999"
REQUIRED_USE="static? ( static-libs ) static-libs? ( static )"

pkg_setup() {
        if use debug; then
                if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
                        die Emerge again with FEATURES="nostrip" or remove the debug use flag
                fi
        fi

	grep -r -e "<Ptr, Ptr (\*)(reference)>" /usr/include/boost/intrusive/pointer_traits.hpp
	if [[ "$?" == "0" ]]; then
		die "Your boost is broken.  You need to patch it.  See dev-libs/boost in oiledmachine-overlay."
	fi
}

src_unpack() {
        EGIT_REPO_URI="https://github.com/juj/kNet.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="e8fd26003d06ef14a296ddb130a8373313b5a26d"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	sed -i -r -e 's|#include <sys/socket.h>|#include <sys/socket.h>\n#include <unistd.h>|' src/Network.cpp || die p14
	sed -i -r -e 's|#include <sys/socket.h>|#include <sys/socket.h>\n#include <unistd.h>|' include/kNet/Socket.h || die p14a
	if use boost; then
		sed -i -e "s|set(USE_BOOST TRUE)||" CMakeLists.txt || die p13
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/HelloClient/CMakeLists.txt || die p1
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/HelloServer/CMakeLists.txt || die p2
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/ConnectFlood/CMakeLists.txt || die p3
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/LatencyTest/CMakeLists.txt || die p4
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/FirewallTest/CMakeLists.txt || die p5
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/SpeedTest/CMakeLists.txt || die p6
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/SimpleChat/CMakeLists.txt || die p7
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/TrashTalk/CMakeLists.txt || die p8
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/SilenceTest/CMakeLists.txt || die p9
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" samples/MessageCompiler/CMakeLists.txt || die p10
		sed -i -e "s|target_link_libraries(\${PROJECT_NAME} kNet)|target_link_libraries(\${PROJECT_NAME} kNet boost_system boost_thread pthread)|" tests/CMakeLists.txt || die p11
		sed -i -e "s|target_link_libraries(kNet \${kNetLinkLibraries})|target_link_libraries(kNet \${kNetLinkLibraries} boost_system boost_thread pthread)|" CMakeLists.txt || die p12
	else
		sed -i -e "s|set(USE_BOOST TRUE)|set(USE_BOOST FALSE)|" CMakeLists.txt || die p13
		sed -i -e 's|option(USE_BOOST "Specifies whether Boost is used." TRUE)|option(USE_BOOST "Specifies whether Boost is used." FALSE)|' CMakeLists.txt || die p14
	fi
	if use qt4; then
		cd ui
		uic -o ../include/kNet/qt/ui/ui_Graph.h Graph.ui
		uic -o ../include/kNet/qt/ui/ui_MessageConnectionDialog.h MessageConnectionDialog.ui
		uic -o ../include/kNet/qt/ui/ui_NetworkDialog.h NetworkDialog.ui
		uic -o ../include/kNet/qt/ui/ui_NetworkSimulationDialog.h NetworkSimulationDialog.ui
	fi

	cd "${S}"
	if ! use samples; then
		sed -i -e 's|add_subdirectory(samples|#add_subdirectory(samples|g' CMakeLists.txt || die p13
	fi

	if use debug; then
		sed -i -e 's|add_subdirectory(tests|#add_subdirectory(tests|g' CMakeLists.txt || die p14
		sed -i -e 's|-Wno-variadic-macros|-Wno-variadic-macros -g -O0|' CMakeLists.txt || die p14a
		append-cflags -g -O0
		append-cxxflags -g -O0
		append-cppflags -g -O0
	fi

	if ! use static; then
		sed -i -e 's|add_library(kNet STATIC|add_library(kNet SHARED|' CMakeLists.txt || die p15
	fi

	A="if (listen->TransportLayer() == SocketOverTCP)" B="if (listen && listen->TransportLayer() == SocketOverTCP)" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' src/NetworkServer.cpp || die p16

	#eapply "${FILESDIR}"/knet-9999-debug-listensockets.patch

	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
	myboost=""
	if use boost; then
		myboost="-DUSE_BOOST=$(usex boost)"
	fi
        local mycmakeargs=(
                -DBUILD_SAMPLES=$(usex samples)
                ${myboost}
                -DUSE_TINYXML=$(usex tinyxml)
                -DUSE_QT=$(usex qt4)
		-DBoost_INCLUDE_DIRS="/usr/include"
		-DBoost_LIBRARY_DIRS="/usr/$(get_libdir)"
		-DBoost_ADDITIONAL_VERSIONS="1.56.0"
        )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	#cmake-utils_src_install
	cd lib
	mkdir -p "${D}/usr/$(get_libdir)"
	if ! use static; then
		cp libkNet.so "${D}/usr/$(get_libdir)"
	else
		cp libkNet.a "${D}/usr/$(get_libdir)"
	fi

	mkdir -p "${D}/usr/include/kNet"
	cd "${S}/include"
	for FILE in $(find . -name "*.h")
	do
		mkdir -p "${D}/usr/include/kNet/$(dirname ${FILE})"
		cp "${FILE}" "${D}/usr/include/kNet/$(dirname ${FILE})"
	done
	for FILE in $(find . -name "*.inl")
	do
		mkdir -p "${D}/usr/include/kNet/$(dirname ${FILE})"
		cp "${FILE}" "${D}/usr/include/kNet/$(dirname ${FILE})"
	done

	#let user define this... impossible to unset
	rm "${D}"/usr/include/kNet/kNetBuildConfig.h
	touch "${D}"/usr/include/kNet/kNetBuildConfig.h
}
