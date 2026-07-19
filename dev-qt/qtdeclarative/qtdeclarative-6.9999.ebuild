# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild has AI generated code

# Add retpoline to textfield widgets which collects passwords
CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="copy-paste-password jit security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VTABLE_VERIFY=1
CXX_STANDARD=17
PYTHON_COMPAT=( python3_{10..14} )
QT6_HAS_STATIC_LIBS=1
# behaves very badly when qtdeclarative is not already installed, also
# other more minor issues (installs junk, sandbox/offscreen issues)
QT6_RESTRICT_TESTS=1

FALLBACK_COMMIT="287ee7fdad2151446548327ac9f7f37664dcac03"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtsvg-6.9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot python-any-r1 qt6-build

DESCRIPTION="Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE+="
accessibility +jit +network opengl qmlls +sql +ssl svg vulkan +widgets
ebuild_revision_3
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},accessibility=,gui,network=,opengl=,sql?,ssl?,vulkan=,widgets=]
	qmlls? ( ~dev-qt/qtlanguageserver-${PV}:6= )
	svg? (
		~dev-qt/qtsvg-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers:= )
"
BDEPEND="
	${PYTHON_DEPS}
	~dev-qt/qtshadertools-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-qt/qtshadertools:=
"

PATCHES=(
#	"${FILESDIR}/extra/${PN}-6.10.2-disable-assert.patch" # oiledmachine-overlay added
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	# oiledmachine-overlay:  Breaks build
	# src/qml/jsruntime/qv4vtable_p.h:174:17: error: non-constant condition for static assertion
	filter-flags "-fno-delete-null-pointer-checks"

	# oiledmachine-overlay:  Breaks linking
	filter-flags "-fno-inline"

	# oiledmachine-overlay: fix build time issue with private header for untested vulkan USE flag
	# /var/tmp/portage/dev-qt/qtdeclarative-6.10.2/work/qtdeclarative-everywhere-src-6.10.2/src/qmltyperegistrar/qanystringviewutils_p.h:17:10: fatal error: QtCore/private/qjson_p.h: No such file or directory
	# /usr/include/qt6/QtCore/6.10.2/QtCore/private/qglobal_p.h:23:10: fatal error: QtCore/private/qtcoreglobal_p.h: No such file or directory
	# /var/tmp/portage/dev-qt/qtdeclarative-6.10.2/work/qtdeclarative-everywhere-src-6.10.2/src/quickdialogs/quickdialogsutils/qquickfilenamefilter_p.h:22:10: fatal error: QtGui/qpa/qplatformdialoghelper.h: No such file or directory
	# /var/tmp/portage/dev-qt/qtdeclarative-6.10.2/work/qtdeclarative-everywhere-src-6.10.2/src/quick/util/qquickdeliveryagent_p_p.h:24:10: fatal error: private/qevent_p.h: No such file or directory
	EXTRA_QMAKEVARS_POST="QT_PRIVATE_HEADERS=1"
	export CXXFLAGS="${CXXFLAGS} -I/usr/include/qt6/QtCore/${PV}"
	export CXXFLAGS="${CXXFLAGS} -I/usr/include/qt6/QtGui/${PV}"
	export CXXFLAGS="${CXXFLAGS} -I/usr/include/qt6/QtGui/${PV}/QtGui"

	local mycmakeargs=(
		$(cmake_use_find_package qmlls Qt6LanguageServerPrivate)
		$(cmake_use_find_package sql Qt6Sql)
		$(cmake_use_find_package svg Qt6Svg)
		$(qt_feature jit qml_jit)
		$(qt_feature network qml_network)
		$(qt_feature ssl qml_ssl)
	)

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	if [[ ! -e ${D}${QT6_LIBDIR}/libQt6QuickControls2.so.6 ]]; then #940675
		eerror "${CATEGORY}/${PF} seems to have been improperly built and"
		eerror "install was aborted to protect the system. Possibly(?) due"
		eerror "to a rare portage ordering bug. If using portage, try:"
		eerror "    emerge -1 qtshadertools:6 qtdeclarative:6"
		eerror "If that did not resolve the issue, please provide build.log"
		eerror "on https://bugs.gentoo.org/940675"
		die "aborting due to incomplete/broken build (see above)"
	fi
}
