# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add conditional support for "QtRemoteObjects" via a new "remoteobjects"
# USE flag after an external "dev-qt/qtremoteobjects" package has been created.
# TODO: Add conditional support for apidoc generation via a new "doc" USE flag.
# Note that doing so requires the Qt source tree, sphinx, and graphviz. Once
# ready, pass the ${QT_SRC_DIR} variable to cmake to enable this support.
# TODO: Disable GLES support if the "gles2-only" USE flag is disabled. Note
# that the "PySide2/QtGui/CMakeLists.txt" and
# "PySide2/QtOpenGLFunctions/CMakeLists.txt" files test for GLES support by
# testing whether the "Qt5::Gui" list property defined by
# "/usr/lib64/cmake/Qt5Gui/Qt5GuiConfig.cmake" at "dev-qt/qtgui" installation
# time contains the substring "opengles2". Since cmake does not permit
# properties to be overridden from the command line, these files must instead
# be conditionally patched to avoid these tests. An issue should be filed with
# upstream requesting a CLI-settable variable to control this.

LLVM_SLOTS=( 16 15 14 13 12 11 )
MY_P="pyside-setup-opensource-src-$(ver_cut 1-3 ${PV})"
# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{8..11} )
# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-2)*:5"

inherit cmake llvm python-r1 virtualx

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
LICENSE="
	|| (
		GPL-2
		GPL-3+
		LGPL-3
	)
" # See "sources/pyside2/PySide2/licensecomment.txt" for licensing details.
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
${LLVM_SLOTS[@]/#/llvm-}
3d charts concurrent datavis designer gles2-only +gui help location multimedia
+network positioning printsupport qml quick quickcontrols2 script scripttools
scxml sensors speech sql svg test testlib webchannel webengine websockets
+widgets x11extras xml xmlpatterns

+llvm-16
"
# llvm-n should be the latest stable.

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set.*_deps' PySide2/Qt*/CMakeLists.txt
# Note that the "designer" USE flag corresponds to the "Qt5UiTools" module.
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
	gui
	widgets
	3d? (
		gui
		network
	)
	charts? (
		gui
		widgets
	)
	datavis? (
		gui
	)
	designer? (
		gui
		widgets
		xml
	)
	gles2-only? (
		gui
	)
	help? (
		gui
		widgets
	)
	location? (
		positioning
	)
	multimedia? (
		gui
		network
	)
	printsupport? (
		gui
		widgets
	)
	qml? (
		gui
		network
	)
	quick? (
		gui
		network
		qml
	)
	quickcontrols2? (
		gui
		network
		qml
		quick
	)
	scripttools? (
		gui
		script
		widgets
	)
	speech? (
		multimedia
	)
	sql? (
		gui
		widgets
	)
	svg? (
		gui
		widgets
	)
	testlib? (
		gui
		widgets
	)
	webengine? (
		network
		widgets? (
			gui
			network
			quick
			printsupport
			webchannel
		)
	)
	websockets? (
		network
	)
	widgets? (
		gui
	)
	x11extras? (
		gui
		widgets
	)
"
gen_llvm_rdepend() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				=sys-devel/clang-runtime-${s}*:=
				>=dev-python/shiboken2-${PV}[${PYTHON_USEDEP},llvm-${s}]
				sys-devel/clang:${s}=
			)
		"
	done
}
RDEPEND="
	${PYTHON_DEPS}
	$(gen_llvm_rdepend)
	=dev-qt/qtcore-${QT_PV}
	=dev-qt/qtopengl-${QT_PV}[gles2-only=]
	=dev-qt/qtserialport-${QT_PV}
	3d? (
		=dev-qt/qt3d-${QT_PV}[qml?,gles2-only=]
	)
	charts? (
		=dev-qt/qtcharts-${QT_PV}[qml?]
	)
	concurrent? (
		=dev-qt/qtconcurrent-${QT_PV}
	)
	datavis? (
		=dev-qt/qtdatavis3d-${QT_PV}[gles2-only=,qml?]
	)
	designer? (
		=dev-qt/designer-${QT_PV}
	)
	gui? (
		=dev-qt/qtgui-${QT_PV}[gles2-only=,jpeg]
	)
	help? (
		=dev-qt/qthelp-${QT_PV}
	)
	location? (
		=dev-qt/qtlocation-${QT_PV}
	)
	multimedia? (
		=dev-qt/qtmultimedia-${QT_PV}[gles2-only=,qml?,widgets?]
	)
	network? (
		=dev-qt/qtnetwork-${QT_PV}
	)
	positioning? (
		=dev-qt/qtpositioning-${QT_PV}[qml?]
	)
	printsupport? (
		=dev-qt/qtprintsupport-${QT_PV}[gles2-only=]
	)
	qml? (
		=dev-qt/qtdeclarative-${QT_PV}[widgets?]
	)
	quick? (
		=dev-qt/qtdeclarative-${QT_PV}[widgets?]
		=dev-qt/qtquickcontrols2-${QT_PV}[widgets?]
	)
	quickcontrols2? (
		=dev-qt/qtquickcontrols2-${QT_PV}
	)
	script? (
		=dev-qt/qtscript-${QT_PV}[scripttools?]
	)
	scxml? (
		=dev-qt/qtscxml-${QT_PV}
	)
	sensors? (
		=dev-qt/qtsensors-${QT_PV}[qml?]
	)
	speech? (
		=dev-qt/qtspeech-${QT_PV}
	)
	sql? (
		=dev-qt/qtsql-${QT_PV}
	)
	svg? (
		=dev-qt/qtsvg-${QT_PV}
	)
	testlib? (
		=dev-qt/qttest-${QT_PV}
	)
	webchannel? (
		=dev-qt/qtwebchannel-${QT_PV}[qml]
	)
	webengine? (
		=dev-qt/qtwebengine-${QT_PV}[alsa,widgets?]
	)
	websockets? (
		=dev-qt/qtwebsockets-${QT_PV}[qml?]
	)
	widgets? (
		=dev-qt/qtwidgets-${QT_PV}[gles2-only=]
	)
	x11extras? (
		=dev-qt/qtx11extras-${QT_PV}
	)
	xml? (
		=dev-qt/qtxml-${QT_PV}
	)
	xmlpatterns? (
		=dev-qt/qtxmlpatterns-${QT_PV}[qml?]
	)
	~dev-python/shiboken2-${PV}[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		x11-misc/xvfb-run
	)
"
BDEPEND="
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"
RESTRICT="test"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}/sources/pyside2"
PATCHES=(
	"${FILESDIR}/${PN}-5.15.2-python310.patch"
	"${FILESDIR}/${PN}-5.15.2-python311.patch"
	"${FILESDIR}/${PN}-5.15.2-python311-fixups.patch"
)

pkg_setup() {
	python_setup
	llvm_pkg_setup
	if use qml ; then
		# Prevent segfault with shiboken2.
		local U=(
			3d
			charts
			datavis
			multimedia
			positioning
			sensors
			webchannel
			websockets
			xmlpatterns
		)
		for u in ${U[@]} ; do
			local u2="${u}"
			[[ "${u}" == "datavis" ]] && u2="datavis3d"
			if use "${u}" && ! has_version "dev-qt/qt${u2}[qml]" ; then
				die "Missing dev-qt/qt${u2}[qml].  Emerge with -1vuDN instead."
			fi
		done
	fi
}

src_configure() {
	local _PATH=$(echo "${PATH}" | tr ":" "\n" | sed -E -e "\|llvm\/[0-9]+|d")
	export LLVM_PATH=""
	for s in ${LLVM_SLOTS[@]} ; do
		if use "llvm-${s}" ; then
			_PATH=$(echo -e "${_PATH}\n/usr/lib/llvm/${s}/bin" | tr "\n" ":")
			export PATH="${_PATH}"
			LLVM_PATH="/usr/lib/llvm/${s}"
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			strip-unsupported-flags
			break
		fi
	done
	clang --version || die
einfo "PATH:\t\t${PATH}"
einfo "CFLAGS:\t\t${CFLAGS}"
einfo "CXXFLAGS:\t\t${CXXFLAGS}"
einfo "LDFLAGS:\t\t${LDFLAGS}"
einfo "LLVM_PATH:\t\t${LLVM_PATH}"
	export CLANG_INSTALL_DIR="${LLVM_PATH}"
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DCore=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DRender=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DataVisualization=$(usex !datavis)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Location=$(usex !location)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickControls2=$(usex !quickcontrols2)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !quick yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Scxml=$(usex !scxml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sensors=$(usex !sensors)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5TextToSpeech=$(usex !speech)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngine=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineCore=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=$(usex !widgets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=$(usex !x11extras)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Xml=$(usex !xml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5XmlPatterns=$(usex !xmlpatterns)
	)
	pyside2_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
			-DSHIBOKEN_PYTHON_SHARED_LIBRARY_SUFFIX="-${EPYTHON}"
		)
		cmake_src_configure
	}
	python_foreach_impl pyside2_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake_src_test
}

src_install() {
	pyside2_install() {
		cmake_src_install
		python_optimize

		# Uniquify the shiboken2 pkgconfig dependency in the PySide2 pkgconfig
		# file for the current Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		sed -i -e 's~^Requires: shiboken2$~&-'${EPYTHON}'~' \
			"${ED}/usr/$(get_libdir)"/pkgconfig/${PN}.pc || die

		# Uniquify the PySide2 pkgconfig file for the current Python target,
		# preserving an unversioned "pyside2.pc" file arbitrarily associated
		# with the last Python target. (See the previously linked issue.)
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl pyside2_install

	# CMakeLists.txt installs a "PySide2Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., pyside2-tools) to target one
	# "libpyside2-*.so" library linked to one Python interpreter. See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i -e 's~pyside2-python[[:digit:]]\+\.[[:digit:]]\+~pyside2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)/cmake/PySide2*/PySide2Targets-${CMAKE_BUILD_TYPE,,}.cmake" || die
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  shiboken2
