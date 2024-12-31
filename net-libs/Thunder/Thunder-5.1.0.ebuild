# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# dobby - https://github.com/rdkcentral/Dobby
# memcr - https://github.com/LibertyGlobal/memcr

PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake optfeature python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/Thunder.git"
	FALLBACK_COMMIT="efe1926a0680bffc29491f1a1304f861ff2fa771" # Oct 8, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/Thunder/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Thunder (aka WPEFramework)"
HOMEPAGE="
	https://github.com/rdkcentral/Thunder
"
LICENSE="
	custom
	Apache-2.0
	BSD
	MIT
	public-domain
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
-awc -bcm43xx -bluetooth -bluetooth-audio -broadcast -crun -debug -dobby -gatt -hibernate
-lxc -privileged-request -process-containers -runc ssl -systemd test
ebuild_revision_1
"
REQUIRED_USE="
	process-containers? (
		|| (
			awc
			crun
			dobby
			lxc
			runc
		)
	)
"
RDEPEND+="
	dev-libs/openssl:=
	sys-libs/zlib
	~net-misc/ThunderTools-${PV}[${PYTHON_SINGLE_USEDEP}]
	awc? (
		app-containers/lxc
		app-misc/slauncher
		dev-libs/glib
	)
	bluetooth? (
		net-wireless/bluez
	)
	bluetooth-audio? (
		media-libs/sbc
	)
	crun? (
		app-containers/crun
	)
	dobby? (
		app-containers/dobby
		sys-apps/systemd
	)
	hibernate? (
		dev-libs/memcr
	)
	lxc? (
		app-containers/lxc
	)
	runc? (
		app-containers/runc
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-build/cmake-3.15
	virtual/pkgconfig
	test? (
		dev-cpp/gtest
	)
"
BDEPEND+="
"
DOCS=()
PATCHES=(
	"${FILESDIR}/${PN}-5.1.0-jsonrpc-install-path.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBCM43XX=$(usex bcm43xx)
		-DBLUETOOTH=$(usex bluetooth)
		-DBLUETOOTH_GATT_SUPPORT=$(usex gatt)
		-DBLUETOOTH_AUDIO_SUPPORT=$(usex bluetooth-audio)
		-DBROADCAST=$(usex broadcast)
		-DHIBERNATESUPPORT=$(usex hibernate)
		-DLOCALTRACER=$(usex debug)
		-DPRIVILEGEDREQUEST=$(usex privileged-request)
		-DPROCESSCONTAINERS=$(usex process-containers)
		-DPROCESSCONTAINERS_AWC=$(usex awc)
		-DPROCESSCONTAINERS_LXC=$(usex lxc)
		-DPROCESSCONTAINERS_RUNC=$(usex runc)
		-DPROCESSCONTAINERS_CRUN=$(usex crun)
		-DPROCESSCONTAINERS_DOBBY=$(usex dobby)
		-DSECURE_SOCKET=$(usex ssl)
		-DSYSTEMD_SERVICE=$(usex systemd)
		-DWARNING_REPORTING=$(usex debug)
		-DWEBSOCKET=$(usex websocket)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "NOTICE"
}

pkg_postinst() {
	optfeature_header "Install optional packages:"

	# Orphaned packages
	optfeature "ClearKey support" "net-misc/OCDM-Clearkey"
	optfeature "Development and test UI" "net-misc/ThunderUI"
	optfeature "Additional WPE Plugins" "net-misc/ThunderNanoServices"
	optfeature "Convenience library for apps to use plugins" "net-misc/ThunderClientLibraries"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
