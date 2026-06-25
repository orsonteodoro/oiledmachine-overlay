# Copyright 2014-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )
PYTHON_COMPAT=( python3_{10..14} )

inherit lua-single meson optfeature python-any-r1 udev

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="4c7f7b1e5c1e270e8be4108082f8e769a640bbbc"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libinput/libinput.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	if [[ $(ver_cut 3) -lt 900 ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	fi
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2"
fi

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libinput/ https://gitlab.freedesktop.org/libinput/libinput"

LICENSE="MIT"
SOVER="10"
SLOT="0/${SOVER}"
IUSE+=" doc input_devices_wacom lua test"
RESTRICT="!test? ( test )"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	lua? ( ${LUA_DEPS} )
	input_devices_wacom? ( >=dev-libs/libwacom-2.15:= )
	>=dev-libs/libevdev-1.9.902
	>=sys-libs/mtdev-1.1
	virtual/libudev:=
	virtual/udev
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-libs/check-0.9.10 )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/commonmark[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			>=dev-python/sphinx-rtd-theme-0.2.4[${PYTHON_USEDEP}]
		')
		>=app-text/doxygen-1.8.3
		>=media-gfx/graphviz-2.38.0
	)
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
	)
"
#	test? ( dev-debug/valgrind )

python_check_deps() {
	if use doc; then
		python_has_version \
			"dev-python/commonmark[${PYTHON_USEDEP}]" \
			"dev-python/recommonmark[${PYTHON_USEDEP}]" \
			"dev-python/sphinx[${PYTHON_USEDEP}]" \
			">=dev-python/sphinx-rtd-theme-0.2.4[${PYTHON_USEDEP}]" \
		|| return
	fi
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/pytest-xdist[${PYTHON_USEDEP}]" \
		|| return
	fi
}

pkg_setup() {
	use lua && lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local c=$(grep -e "libinput_lt_c=" "${S}/meson.build" | cut -f 2 -d "=")
	local a=$(grep -e "libinput_lt_a=" "${S}/meson.build" | cut -f 2 -d "=")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER"
eerror "QA:  Actual sover:  ${actual_sover}"
eerror "QA:  Expected sover:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default
	sed "s@, '-Werror'@@" -i meson.build || die #744250
}

src_configure() {
	# gui can be built but will not be installed
	local emesonargs=(
		-Ddebug-gui=false
		$(meson_use doc documentation)
		$(meson_use input_devices_wacom libwacom)
		$(meson_use test tests)
		$(meson_feature lua lua-plugins)
		-Dudev-dir="${EPREFIX}$(get_udevdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc ; then
		docinto html
		dodoc -r "${BUILD_DIR}"/Documentation/.
	fi
}

pkg_postinst() {
	optfeature "measure and replay tools" dev-python/libevdev
	udev_reload
}

pkg_postrm() {
	udev_reload
}
