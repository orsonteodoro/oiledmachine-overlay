# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderClientLibraries.git"
	FALLBACK_COMMIT="6f1361630983b956efb26f17590293911ef2272c" # Feb 12, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/ThunderClientLibraries/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Thunder supporting libraries"
HOMEPAGE="
	https://github.com/rdkcentral/ThunderClientLibraries
"
LICENSE="
	Apache-2.0
	BSD-2
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
bluetooth-audio-sink bluetooth-audio-source cdmi compositor-buffer-type
compositor-client compositor-mesa compositor-wayland cryptography device-info
display-info ocdm openssl player-info +protocols provision-proxy security-agent
test virtual-input
"
REQUIRED_USE="
	?? (
		compositor-mesa
		compositor-wayland
	)
	compositor-client? (
		^^ (
			compositor-mesa
			compositor-wayland
		)
	)
	openssl? (
		cryptography
	)
	|| (
		bluetooth-audio-sink
		bluetooth-audio-source
		cdmi
		compositor-buffer-type
		compositor-client
		cryptography
		device-info
		display-info
		ocdm
		player-info
		provision-proxy
		security-agent
		virtual-input
	)
"
RDEPEND+="
	~net-libs/Thunder-${PV}
	ocdm? (
		media-libs/gstreamer
	)
	openssl? (
		dev-libs/openssl
	)
	compositor-wayland? (
		dev-libs/weston[gles2]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.15
	virtual/pkgconfig
"
DOCS=( "README.md" )

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
		-DBLUETOOTHAUDIOSINK=$(usex bluetooth-audio-sink)
		-DBLUETOOTHAUDIOSOURCE=$(usex bluetooth-audio-source)
		-DCDMI=$(usex cdmi)
		-DCOMPOSITORBUFFER=$(usex compositor-buffer-type)
		-DCOMPOSITORCLIENT=$(usex compositor-client)
		-DCRYPTOGRAPHY=$(usex cryptography)
		-DDEVICEINFO=$(usex device-info)
		-DDISPLAYINFO=$(usex display-info)
		-DINCLUDE_SOFTWARE_CRYPTOGRAPHY_LIBRARY=$(usex openssl)
		-DPLAYERINFO=$(usex player-info)
		-DPROTOCOLS=$(usex protocols)
		-DPROVISIONPROXY=$(usex provision-proxy)
		-DSECURITYAGENT=$(usex security-agent)
		-DVIRTUALINPUT=$(usex virtual-input)
	)

	if use compositor-mesa ; then
		mycmakeargs+=(
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="Mesa"
		)
	elif use compositor-wayland ; then
		mycmakeargs+=(
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="Wayland"
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="Weston"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
