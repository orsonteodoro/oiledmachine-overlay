# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_11 ) # CI does not list 3.10 for this package.
inherit cmake python-single-r1
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	EGIT_GLFW_COMMIT="e130e55a990998c78fd323f21076e798e0efe8a4"
	EGIT_IMGUI_COMMIT="9aae45eb4a05a5a1f96be1ef37eb503a12ceb889"
	EGIT_IMGUI_NODE_EDITOR_COMMIT="2f99b2d613a400f6579762bd7e7c343a0d844158"
	EGIT_NANOBIND_COMMIT="07b4e1fc9e94eeaf5e9c2f4a63bdb275a25c82c6"
	EGIT_NANOGUI_COMMIT="f5020e2f3e5114d517642e67afbb21cb88cf04c0"
	EGIT_NANOVG_COMMIT="bf2320d1175122374a9b806d91e9e666c9336375"
	EGIT_NANOVG_METAL_COMMIT="075b04f16c579728c693b46a2ce408f2325968cf"
	EGIT_ROBIN_MAP_COMMIT="a603419b9a0687c9148e02c8bd5e3db180bb9ac0"
	SRC_URI="
https://github.com/AcademySoftwareFoundation/MaterialX/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ocornut/imgui/archive/${EGIT_IMGUI_COMMIT}.tar.gz
	-> imgui-${EGIT_IMGUI_COMMIT:0:7}.tar.gz
https://github.com/thedmd/imgui-node-editor/archive/${EGIT_IMGUI_NODE_EDITOR_COMMIT}.tar.gz
	-> imgui-node-editor-${EGIT_IMGUI_NODE_EDITOR_COMMIT:0:7}.tar.gz
https://github.com/mitsuba-renderer/nanogui/archive/${EGIT_NANOGUI_COMMIT}.tar.gz
	-> nanogui-${EGIT_NANOGUI_COMMIT:0:7}.tar.gz

https://github.com/wjakob/nanobind/archive/${EGIT_NANOBIND_COMMIT}.tar.gz
	-> nanobind-${EGIT_NANOBIND_COMMIT:0:7}.tar.gz
https://github.com/wjakob/glfw/archive/${EGIT_GLFW_COMMIT}.tar.gz
	-> glfw-${EGIT_GLFW_COMMIT:0:7}.tar.gz
https://github.com/wjakob/nanovg/archive/${EGIT_NANOVG_COMMIT}.tar.gz
	-> nanovg-${EGIT_NANOVG_COMMIT:0:7}.tar.gz
https://github.com/wjakob/nanovg_metal/archive/${EGIT_NANOVG_METAL_COMMIT}.tar.gz
	-> nanovg_metal-${EGIT_NANOVG_METAL_COMMIT:0:7}.tar.gz

https://github.com/Tessil/robin-map/archive/${EGIT_ROBIN_MAP_COMMIT}.tar.gz
	-> robin-map-${EGIT_ROBIN_MAP_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="MaterialX is an open standard for the exchange of rich material \
and look-development content across applications and renderers."
HOMEPAGE="
https://materialx.org/
https://github.com/AcademySoftwareFoundation/MaterialX
"
LICENSE="
	Apache-2.0
	Boost-1.0
	BSD
	CC0-1.0
	MIT
	ZLIB
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" -examples -oiio -python test wayland +X r1"
REQUIRED_USE+="
	python? (
		${PYTHON_REQUIRED_USE}
	)
	kernel_linux? (
		X
	)
"
RDEPEND+="
	media-libs/openimageio
	virtual/opengl
	kernel_linux? (
		x11-libs/libX11
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
		x11-libs/libxkbcommon
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.1
	|| (
		>=sys-devel/gcc-6
		>=sys-devel/clang-6
	)
"
S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}/materialx-1.38.8_pre9999-setup.py-fix-sandbox-violation.patch"
)
DOCS=( )

pkg_setup() {
	use python && python_setup
}

verify_version() {
	local actual_major_pv=$(grep -r -e "MATERIALX_MAJOR_VERSION" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| grep -E -o "[0-9]+")
	local actual_minor_pv=$(grep -r -e "MATERIALX_MINOR_VERSION" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| grep -E -o "[0-9]+")
	local actual_build_pv=$(grep -r -e "MATERIALX_BUILD_VERSION" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| grep -E -o "[0-9]+")
	local actual_version="${actual_major_pv}.${actual_minor_pv}.${actual_build_pv}"
	local expected_version=$(ver_cut 1-3 "${PV}")
	if [[ "${actual_version}" != "${expected_version}" ]] ; then
eerror
eerror "QA:  Version bump detected"
eerror
eerror "Actual version:    ${actual_version}"
eerror "Expected version:  ${expected_version}"
eerror
eerror "Use the fallback-commit to rewind the commit or send an issue request"
eerror "to the ebuild maintainer."
eerror
		die
	fi
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="3e838e2f4b4bcc434bd0e99f0e382c8d475b322a"
		EGIT_BRANCH="main"
		EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/MaterialX.git"
		git-r3_fetch
		git-r3_checkout
		verify_version
	else
		unpack ${A}
		pushd "nanogui-${EGIT_NANOGUI_COMMIT}" || die
			rm -rf \
				source/MaterialXView/NanoGUI/ext/nanovg \
				source/MaterialXView/NanoGUI/ext/nanovg_metal \
				source/MaterialXView/NanoGUI/ext/glfw \
				source/MaterialXView/NanoGUI/ext/nanobind \
				|| die
			mv \
				"${WORKDIR}/nanovg-${EGIT_NANOVG_COMMIT}" \
				"ext/nanovg" \
				|| die
			mv \
				"${WORKDIR}/nanovg_metal-${EGIT_NANOVG_METAL_COMMIT}" \
				"ext/nanovg_metal" \
				|| die
			mv \
				"${WORKDIR}/glfw-${EGIT_GLFW_COMMIT}" \
				"ext/glfw" \
				|| die
			pushd "${WORKDIR}/nanobind-${EGIT_NANOBIND_COMMIT}" || die
				rm -rf \
					"ext/robin_map" \
					|| die
				mv "${WORKDIR}/robin-map-${EGIT_ROBIN_MAP_COMMIT}" \
					ext/robin_map \
					|| die
			popd
			mv \
				"${WORKDIR}/nanobind-${EGIT_NANOBIND_COMMIT}" \
				"ext/nanobind" \
				|| die
		popd || die

		pushd "${MY_P}" || die
			rm -rf \
				source/MaterialXView/NanoGUI \
				source/MaterialXGraphEditor/External/ImGui \
				source/MaterialXGraphEditor/External/ImGuiNodeEditor \
				|| die
			mv \
				"${WORKDIR}/nanogui-${EGIT_NANOGUI_COMMIT}" \
				source/MaterialXView/NanoGUI \
				|| die
			mv \
				"${WORKDIR}/imgui-${EGIT_IMGUI_COMMIT}" \
				source/MaterialXGraphEditor/External/ImGui \
				|| die
			mv \
				"${WORKDIR}/imgui-node-editor-${EGIT_IMGUI_NODE_EDITOR_COMMIT}" \
				source/MaterialXGraphEditor/External/ImGuiNodeEditor \
				|| die
		popd || die
	fi
}

src_configure() {
	addpredict /usr/lib/materialx
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}"
		-DGLFW_USE_OSMESA=OFF
		-DGLFW_USE_WAYLAND=$(usex wayland "ON" "OFF")
		-DMATERIALX_BUILD_OIIO=$(usex oiio "ON" "OFF")
		-DMATERIALX_BUILD_PYTHON=$(usex python "ON" "OFF")
		-DMATERIALX_BUILD_SHARED_LIBS=ON
		-DMATERIALX_BUILD_TESTS=$(usex test "ON" "OFF")
		-DMATERIALX_INSTALL_PYTHON=OFF
	)
	if use python ; then
		mycmakeargs+=(
			-Dpybind11_ROOT="$(python_get_sitedir)/pybind11"
			-DMATERIALX_PYTHON_EXECUTABLE=${PYTHON}
			-DMATERIALX_PYTHON_VERSION=${EPYTHON/python/}
			-DPYTHON_EXECUTABLE=${PYTHON}
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -rf "${ED}/var/tmp" || die
	if use python ; then
		python_domodule python/MaterialX
		if use examples ; then
			insinto /usr/share/${PN}/python
			doins python/Scripts/*
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
