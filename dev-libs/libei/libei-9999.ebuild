# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

CHKL_TIMESTAMPS=(
	"sys-apps/systemd-9999"
)

inherit chkl meson python-any-r1 secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="1498fcc0ffdcaa6f8db8f688df8d09cb71726f5e"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libinput/libei.git"
	SONAME="1.6.0"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	SRC_URI="https://gitlab.freedesktop.org/libinput/${PN}/-/archive/${PV}/${P}.tar.bz2"
	MUNIT_COMMIT="fbbdf1467eb0d04a6ee465def2e529e4c87f2118"
	SRC_URI+=" https://github.com/nemequ/munit/archive/${MUNIT_COMMIT}.tar.gz -> munit-${MUNIT_COMMIT}.tar.gz"
fi

DESCRIPTION="Library for Emulated Input, primarily aimed at the Wayland stack"
HOMEPAGE="https://gitlab.freedesktop.org/libinput/libei"

LICENSE="MIT"
if [[ -z "${SONAME}" ]] ; then
	SONAME="${PV}"
fi
SLOT="0/${SONAME}"
IUSE+="
basu elogind systemd test
ebuild_revision_1
"
REQUIRED_USE="
	|| (
		systemd
		elogind
		basu
	)
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libevdev-1.9.902:=
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	elogind? ( >=sys-auth/elogind-${ELOGIND_PV}:= )
	basu? ( sys-libs/basu:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/structlog[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/1.3.0-skip-protocol-test.patch
)

python_check_deps() {
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/python-dbusmock[${PYTHON_USEDEP}]" \
			"dev-python/pyyaml[${PYTHON_USEDEP}]" \
			"dev-python/structlog[${PYTHON_USEDEP}]" \
			|| return 1
	fi
	python_has_version \
		"dev-python/jinja2[${PYTHON_USEDEP}]" \
		|| return 1
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		mv "${WORKDIR}"/munit-${MUNIT_COMMIT} "${WORKDIR}"/${P}/subprojects/munit || die
		rm "${WORKDIR}"/${P}/subprojects/munit.wrap || die
	fi
	local actual_soname=$(grep -E -e "version: '[0-9.]+'" "${S}/meson.build" | grep -E -o -e "[0-9.]+")
	local expected_soname="${SONAME}"
	if ver_test "${actual_soname}" "-ne" "${expected_soname}" ; then
eerror "QA:  Update SONAME in ebuild"
eerror "Actual SONAME:  ${actual_soname}"
eerror "Expected SONAME:  ${expected_soname}"
		die
	fi
}

src_prepare() {
	default

	sed -i -e 's:^valgrind = .*:valgrind = disabler():g' test/meson.build || die
}

src_configure() {
	chkl_check_many_timestamps
	local emesonargs=(
		-Ddocumentation=""
		-Dliboeffis=enabled
		$(meson_feature test tests)
	)
	if use systemd; then
		emesonargs+=(-Dsd-bus-provider=libsystemd)
	elif use elogind; then
		emesonargs+=(-Dsd-bus-provider=libelogind)
	else
		emesonargs+=(-Dsd-bus-provider=basu)
	fi
	meson_src_configure
}

src_install() {
	meson_src_install

	# munit subproject is installed but not wanted
	if use test; then
		rm "${ED}"/usr/lib*/libmunit.so || die
	fi
}
