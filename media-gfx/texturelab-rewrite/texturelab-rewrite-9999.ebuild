# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="TextureLab"

PYTHON_COMPAT=( python3_{8..10} )
QT5_PV="5.5"
QT6_PV="6"
TEXTURELAB_DATA_COMMIT="5996a27d943382fabeafb18217f9de212c62d420" # Jan 7, 2023
QT_ADVANCED_DOCKING_SYSTEM_COMMIT="efd88565a9db513054a1795dd6bf756fc95989c3" # Aug 29, 2022

inherit cmake desktop python-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="rewrite"
	EGIT_REPO_URI="https://github.com/njbrown/texturelab.git"
	FALLBACK_COMMIT="844fac980fccc54deae1605c9ec38c1a58a9520b"
	inherit git-r3
	IUSE+=" fallback-commit"
	SRC_URI=""
else
	# KEYWORDS="~amd64" # Still pre-alpha.  Cannot save texture
	TARBALL_SNAPSHOT=0
	SNAPSHOT_COMMIT="844fac980fccc54deae1605c9ec38c1a58a9520b"
	if [[ "${TARBALL_SNAPSHOT}" == "1" ]] ; then
		SRC_URI+="
https://github.com/njbrown/texturelab/archive/${TARBALL_SNAPSHOT}.tar.gz
	-> texturelab-rewrite-${TARBALL_SNAPSHOT}.tar.gz
		"
	else
		SRC_URI+="
https://github.com/njbrown/texturelab/archive/refs/tags/v${PV}.tar.gz
	-> texture-lab-rewrite-${PV}.tar.gz
		"
	fi

	SRC_URI+="
https://github.com/njbrown/texturelabdata/archive/${TEXTURELAB_DATA_COMMIT}.tar.gz
	-> texturelabdata-${TEXTURELAB_DATA_COMMIT:0:7}.tar.gz
https://github.com/githubuser0xFFFF/Qt-Advanced-Docking-System/archive/${QT_ADVANCED_DOCKING_SYSTEM_COMMIT}.tar.gz
	-> githubuser0xFFFF-Qt-Advanced-Docking-System-${QT_ADVANCED_DOCKING_SYSTEM_COMMIT:0:7}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="A rewrite of the Free, Cross-Platform, GPU-Accelerated Procedural Texture Generator in Qt"
HOMEPAGE="
https://github.com/njbrown/texturelab/tree/rewrite
"
LICENSE="
	GPL-3+
	LGPL-2.1+
"
RESTRICT="mirror"
SLOT="0"
IUSE+=" qt5 qt6 wayland X"
REQUIRED_USE+="
	|| (
		wayland
		X
	)
	^^ (
		qt5
		qt6
	)
"
RDEPEND+="
	qt5? (
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5[png,wayland?,X?]
		>=dev-qt/qtopengl-${QT5_PV}:5
		>=dev-qt/qtwayland-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5[png,X?]
	)
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:6[gui,opengl,wayland?,widgets,X?]
		>=dev-qt/qtwayland-${QT5_PV}:6
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.5
	dev-util/patchelf
"
PATCHES=( "${FILESDIR}/texturelab-rewrite-844fac9-libdir.patch" )

pkg_setup() {
ewarn "This branch is pre-alpha.  Cannot save."
	python_setup
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${libdir}"
	)
	cmake_src_configure
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		rm -rf "${S}/public/assets"
		rm -rf "${S}/src/ads"
		mv "${WORKDIR}/Qt-Advanced-Docking-System-${QT_ADVANCED_DOCKING_SYSTEM_COMMIT}" "${S}/src/ads" || die
		mv "${WORKDIR}/texturelabdata-${TEXTURELAB_DATA_COMMIT}" "${S}/public/assets" || die
	fi
}

src_install() {
	cmake_src_install
	dodir "/usr/$(get_libdir)/texturelab"
	patchelf --add-rpath "/usr/$(get_libdir)/texturelab/$(get_libdir)" \
		"${ED}/usr/bin/texturelab" \
		|| die
}
