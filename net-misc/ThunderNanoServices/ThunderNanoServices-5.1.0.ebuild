# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderNanoServices.git"
	FALLBACK_COMMIT="2235972f41a8452467b34a25a4ae71b328d9c958" # Oct 8, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/ThunderNanoServices/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Thunder NanoServices & AppEngines (aka WPEFrameworkPlugins)"
HOMEPAGE="
	https://github.com/rdkcentral/ThunderNanoServices
"
LICENSE="
	custom
	Apache-2.0
	BSD-2
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
avs avs-keyword-detection avs-smart-screen backoffice bluetooth bluetooth-audio
bluetooth-remote-control bluetooth-sdp-server cec-control cobalt commander
compositor compositor-mesa compositor-wayland dhcp-server dial-server
dial-server-amazon-prime dial-server-netflix dial-server-youtube dictionary
dump-on-completed example-client-server example-comrpc-client
example-config-update-example example-dynamic-loading
example-dynamic-loading-yang example-dynamic-loading-yin example-file-transfer
example-io-connector-test example-jsonrpc example-message-control-udp-client
example-out-of-process example-simple-comrpc-test example-state-controller
example-smart-interface-type firmware-control input-switch
language-administrator network-control performance-monitor portaudio power
power-mfr-persist-state process-containers process-monitor rdk-audio-hal
remote-control remote-control-cec +remote-control-rf4ce resource-monitor
rust-bridge ssh-server snapshot spark streamer streamer-aamp streamer-cenc
streamer-qam subsystem-controller svalbard switchboard system-commands systemd
test test-automation-tools test-cec test-compositor test-compositor-client
test-compositor-server test-controller test-store time-sync test-utility
vault-provisioning volume-control watchdog webpa webpa-ccsp webpa-device-info
webpa-generic-adapter webproxy webserver webserver-device-info
webserver-dial-server webserver-security-agent webshell wifi-control
"
REQUIRED_USE="
	?? (
		compositor-mesa
		compositor-wayland
	)
	compositor-mesa? (
		compositor
	)
	compositor-wayland? (
		compositor
	)
	dial-server-amazon-prime? (
		dial-server
	)
	dial-server-netflix? (
		dial-server
	)
	dial-server-youtube? (
		dial-server
	)
	avs-keyword-detection? (
		avs
	)
	avs-smart-screen? (
		avs
	)
"
RDEPEND+="
	~net-libs/Thunder-${PV}
	~net-misc/ThunderTools-${PV}[${PYTHON_SINGLE_USEDEP}]
	avs? (
		media-libs/gstreamer
	)
	avs-smart-screen? (
		dev-cpp/asio
		media-libs/gstreamer
		portaudio? (
			media-libs/portaudio
		)
	)
	compositor-mesa? (
		media-libs/libpng
		media-libs/mesa
		x11-libs/libdrm
	)
	compositor-wayland? (
		dev-libs/wayland
		media-libs/libpng
		media-libs/mesa[wayland]
	)
	spark? (
		media-libs/freetype
	)
	ssh-server? (
		net-misc/dropbear
	)
	snapshot? (
		media-libs/libpng
	)
	streamer-aamp? (
		dev-libs/glib
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? (
		sys-apps/systemd
	)
	webpa-generic-adapter? (
		dev-libs/glib
		dev-libs/nanomsg
		dev-libs/tinyxml
		sys-process/procps
	)
	webpa-ccsp? (
		dev-libs/cJSON
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
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
		-DBUILD_COMPOSITOR_TEST_CLIENT=$(usex test-compositor-client)
		-DBUILD_COMPOSITOR_TEST_SERVER=$(usex test-compositor-server)
		-DCEC_TESTS=$(usex test-cec)
		-DENABLE_DUMP_ON_COMPLETED=$(usex dump-on-completed)
		-DEXAMPLE_CLIENT_SERVER=$(usex example-client-server)
		-DEXAMPLE_COMRPCCLIENT=$(usex example-comrpc-client)
		-DEXAMPLE_DYNAMICLOADING=$(usex example-dynamic-loading)
		-DEXAMPLE_DYNAMICLOADING_YIN=$(usex example-dynamic-loading-yin)
		-DEXAMPLE_DYNAMICLOADING_YANG=$(usex example-dynamic-loading-yang)
		-DEXAMPLE_MESSAGECONTROL_UDP_CLIENT=$(usex example-message-control-udp-client)
		-DEXAMPLE_PLUGINSMARTINTERFACETYPE_EXAMPLE=$(usex example-smart-interface-type)
		-DEXAMPLE_SIMPLECOMRPC_TEST=$(usex example-simple-comrpc-test)
		-DEXAMPLE_IOCONNECTOR_TEST=$(usex example-io-connector-test)
		-DINSTALL_COMPOSITOR_CLIENT_TEST=$(usex test-compositor-client)
		-DINSTALL_COMPOSITOR_SERVER_TEST=$(usex test-compositor-server)
		-DPLUGIN_AVS=$(usex avs)
		-DPLUGIN_AVS_ENABLE_KWD=$(usex avs-keyword-detection)
		-DPLUGIN_AVS_ENABLE_SMART_SCREEN=$(usex avs-smart-screen)
		-DPLUGIN_BACKOFFICE=$(usex backoffice)
		-DPLUGIN_BLUETOOTH=$(usex bluetooth)
		-DPLUGIN_BLUETOOTH_DEVELOPMENT=$(usex debug)
		-DPLUGIN_BLUETOOTH_KERNEL_CONNECION_CONTROL=$(usex bluetooth-kernel-connection-control)
		-DPLUGIN_BLUETOOTHAUDIO=$(usex bluetooth-audio)
		-DPLUGIN_BLUETOOTHREMOTECONTROL=$(usex bluetooth-remote-control)
		-DPLUGIN_BLUETOOTHSDPSERVER=$(usex bluetooth-spd-server)
		-DPLUGIN_CECCONTROL=$(usex cec-control)
		-DPLUGIN_COBALT=$(usex cobalt)
		-DPLUGIN_COMMANDER=$(usex commander)
		-DPLUGIN_COMPOSITOR=$(usex compositor)
		-DPLUGIN_COMPOSITOR_HARDWAREREADY=0
		-DPLUGIN_COMPOSITOR_TEST=$(usex test-compositor)
		-DPLUGIN_COMPOSITOR_NXSERVER=OFF
		-DPLUGIN_CONFIGUPDATEEXAMPLE=$(usex example-config-update-example)
		-DPLUGIN_DHCPSERVER=$(usex dhcp-server)
		-DPLUGIN_DIALSERVER=$(usex dial-server)
		-DPLUGIN_DIALSERVER_ENABLE_YOUTUBE=$(usex dial-server-youtube)
		-DPLUGIN_DIALSERVER_ENABLE_NETFLIX=$(usex dial-server-netflix)
		-DPLUGIN_DIALSERVER_ENABLE_AMAZON_PRIME=$(usex dial-server-amazon-prime)
		-DPLUGIN_DICTIONARY=$(usex dictionary)
		-DPLUGIN_DOGGO=$(usex watchdog)
		-DPLUGIN_FILETRANSFER=$(usex example-file-transfer)
		-DPLUGIN_FIRMWARECONTROL=$(usex firmware-control)
		-DPLUGIN_INPUTSWITCH=$(usex input-switch)
		-DPLUGIN_JSONRPC=$(usex example-jsonrpc)
		-DPLUGIN_LANGUAGEADMINISTRATOR=$(usex language-adminstrator)
		-DPLUGIN_NETWORKCONTROL=$(usex network-control)
		-DPLUGIN_OUTOFPROCESS=$(usex example-out-of-process)
		-DPLUGIN_PERFORMANCEMONITOR=$(usex performance-monitor)
		-DPLUGIN_POWER=$(usex power)
		-DPLUGIN_POWER_MFRPERSIST_STATE=$(usex power-mfr-persist-state)
		-DPLUGIN_PROCESSCONTAINERS=$(usex process-containers)
		-DPLUGIN_PROCESSMONITOR=$(usex process-monitor)
		-DPLUGIN_REMOTECONTROL=$(usex remote-control)
		-DPLUGIN_REMOTECONTROL_CEC=$(usex remote-control-cec)
		-DPLUGIN_REMOTECONTROL_RFCE=$(usex remote-control-rf4ce)
		-DPLUGIN_RESOURCEMONITOR=$(usex resource-monitor)
		-DPLUGIN_RUSTBRIDGE=$(usex rust-bridge)
		-DPLUGIN_SECURESHELLSERVER=$(usex ssh-server)
		-DPLUGIN_SNAPSHOT=$(usex snapshot)
		-DPLUGIN_SPARK=$(usex spark)
		-DPLUGIN_STATECONTROLLER=$(usex example-state-controller)
		-DPLUGIN_STREAMER=$(usex streamer)
		-DPLUGIN_SUBSYSTEMCONTROLLER=$(usex subsystem-controller)
		-DPLUGIN_SVALBARD=$(usex salbard)
		-DPLUGIN_SYSTEMDCONNECTOR=$(usex systemd)
		-DPLUGIN_SWITCHBOARD=$(usex switchboard)
		-DPLUGIN_SYSTEMCOMMANDS=$(usex system-commands)
		-DPLUGIN_TESTCONTROLLER=$(usex test-controller)
		-DPLUGIN_TESTUTILITY=$(usex test-utility)
		-DPLUGIN_TIMESYNC=$(usex time-sync)
		-DPLUGIN_VAULTPROVISIONING=$(usex vault-provisioning)
		-DPLUGIN_VOLUMECONTROL=$(usex volume-control)
		-DPLUGIN_WEBPA=$(usex webpa)
		-DPLUGIN_WEBPA_CCSP=$(usex webpa-ccsp)
		-DPLUGIN_WEBPA_DEVICE_INFO=$(usex webpa-device-info)
		-DPLUGIN_WEBPA_GENERIC_ADAPTER=$(usex webpa-generic-adapter)
		-DPLUGIN_WEBPROXY=$(usex webproxy)
		-DPLUGIN_WEBSERVER=$(usex webserver)
		-DPLUGIN_WEBSHELL=$(usex webshell)
		-DPLUGIN_WEBSERVER_PROXY_DEVICEINFO=$(usex webserver-device-info)
		-DPLUGIN_WEBSERVER_PROXY_DIALSERVER=$(usex webserver-dial-server)
		-DPLUGIN_WEBSERVER_SECURITYAGENT=$(usex webserver-security-agent)
		-DPLUGIN_WIFICONTROL=$(usex wifi-control)
		-DRDK_AUDIO_HAL=$(usex rdk-audio-hal)
		-DSTORE_TEST=$(usex test-store)
		-DTEST_AUTOMATION_TOOLS=$(usex test-automation-tools)
	)

	if use compositor-mesa ; then
		mycmakeargs+=(
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="Mesa"
		)
	elif use compositor-wayland ; then
		mycmakeargs+=(
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="Wayland"
		)
	else
		mycmakeargs+=(
			-DPLUGIN_COMPOSITOR_IMPLEMENTATION="None"
		)
	fi

	local impls=""
	if use streamer-aamp ; then
		impls=";Aamp"
	fi
	if use streamer-cenc ; then
		impls=";CENC"
	fi
	if use streamer-qam ; then
		impls=";QAM"
	fi
	if [[ -n "${impls}" ]] ; then
		impls="${impls:1}"
		mycmakeargs+=(
			-DPLUGIN_STREAMER_IMPLEMENTATIONS="${impls}"
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
