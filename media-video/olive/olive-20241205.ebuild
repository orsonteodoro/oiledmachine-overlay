# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

EGIT_COMMIT="7e0e94abf6610026aebb9ddce8564c39522fac6e"
KDDOCWIDGETS_COMMIT="8d2d0a5764f8393cc148a2296d511276a8ffe559"
OLIVE_EDITOR_CORE_COMMIT="277792824801495e868580ca86f6e7a1b53e4779"
QT5_PV="5.6.0"
QT6_PV="6.0.0"

inherit cmake dep-prepare xdg

if [[ "${PV}" == *"9999" ]]; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/olive-editor/olive.git"
	FALLBACK_COMMIT="7e0e94abf6610026aebb9ddce8564c39522fac6e" # Dec 5, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/olive-editor/olive/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/olive-editor/KDDockWidgets/archive/${KDDOCWIDGETS_COMMIT}.tar.gz
	-> KDDockWidgets-${KDDOCWIDGETS_COMMIT:0:7}.tar.gz
https://github.com/olive-editor/core/archive/${OLIVE_EDITOR_CORE_COMMIT}.tar.gz
	-> olive-editor-core-${OLIVE_EDITOR_CORE_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Professional open-source non-linear video editor"
HOMEPAGE="
	https://www.olivevideoeditor.org/
	https://github.com/olive-editor/olive
"
LICENSE="GPL-3"
SLOT="0"
IUSE+="
doc qt5 qt6 test
"
REQUIRED_USE="
	^^ (
		qt5
		qt6
	)
"
RESTRICT="
	!test? (
		test
	)
"
#	media-libs/olivecore
DEPEND="
	>=media-libs/opencolorio-2.1.1:=
	>=media-libs/openimageio-2.1.12:=
	>=media-video/ffmpeg-3.0.0
	>=media-libs/portaudio-19.06.0
	>=media-libs/openexr-2.3.0:=
	media-libs/opentimelineio:=
	virtual/opengl
	qt5? (
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		dev-qt/qtconcurrent:=
		>=dev-qt/qtcore-${QT5_PV}:5
		dev-qt/qtcore:=
		>=dev-qt/qtgui-${QT5_PV}:5
		dev-qt/qtgui:=
		>=dev-qt/qtopengl-${QT5_PV}:5
		dev-qt/qtopengl:=
		>=dev-qt/qtsvg-${QT5_PV}:5
		dev-qt/qtsvg:=
		>=dev-qt/qtwidgets-${QT5_PV}:5
		dev-qt/qtwidgets:=
	)
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,gui,opengl,widgets]
		dev-qt/qtbase:=
		>=dev-qt/qtsvg-${QT6_PV}:6
		dev-qt/qtsvg:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.13
	doc? (
		>=app-text/doxygen-1.8.17[dot]
	)
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
	)
"

src_unpack() {
	if [[ "${PV}" == *"9999" ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/KDDockWidgets-${KDDOCWIDGETS_COMMIT}" "${S}/ext/KDDockWidgets"
		dep_prepare_mv "${WORKDIR}/core-${OLIVE_EDITOR_CORE_COMMIT}" "${S}/ext/core"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOXYGEN="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use doc; then
		docinto "html"
		dodoc -r "${BUILD_DIR}/docs/html/"*
	fi
}
