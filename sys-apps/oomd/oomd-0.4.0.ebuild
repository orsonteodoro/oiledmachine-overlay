# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="oomd is userspace Out-Of-Memory (OOM) killer for linux systems."
HOMEPAGE="https://github.com/facebookincubator/oomd"
LICENSE="GPL-2
	test? ( all-rights-reserved )"
# src/oomd/util/FixtureTest.cpp contains all-rights-reserved
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
inherit linux-info meson toolchain-funcs
PLUGINS_CORE=(
	BaseKillPlugin
	ContinuePlugin
	CorePluginsTest
	DumpCgroupOverview
	DumpKillInfoNoOp
	Exists
	KillIOCost
	KillMemoryGrowth
	KillPressure
	KillSwapUsage
	MemoryAbove
	MemoryReclaim
	NrDyingDescendants
	PressureAbove
	PressureRisingBeyond
	Senpai
	StopPlugin
	SwapFree
)
PLUGINS_SYSTEMD=(
	BaseSystemdPlugin
	SystemdPluginsTest
	SystemdRestart
)
IUSE+=" doc man openrc plugins savedconfig +setup_check_hard systemd test \
${PLUGINS_CORE[@]/#/plugin_} ${PLUGINS_SYSTEMD[@]/#/plugin_}"
PLUGINS_CORE_RU=("${PLUGINS_CORE[@]/#/plugin_}")
PLUGINS_CORE_RU=("${PLUGINS_CORE_RU[@]/%/? ( plugins )}")
PLUGINS_SYSTEMD_RU=("${PLUGINS_SYSTEMD[@]/#/plugin_}")
PLUGINS_SYSTEMD_RU=("${PLUGINS_SYSTEMD_RU[@]/%/? ( plugins systemd )}")
REQUIRED_USE="
	${PLUGINS_CORE_RU[@]}
	${PLUGINS_SYSTEMD_RU[@]}
	plugins? ( || (
		${PLUGINS_CORE[@]/#/plugin_}
		${PLUGINS_SYSTEMD[@]/#/plugin_}
		savedconfig
		)     )
	plugin_CorePluginsTest? (
		plugin_BaseKillPlugin
		plugin_KillIOCost
		plugin_KillMemoryGrowth
		plugin_KillPressure
		plugin_KillSwapUsage
	)
	plugin_DumpKillInfoNoOp? (
		plugin_BaseKillPlugin
	)
	plugin_KillIOCost? (
		plugin_BaseKillPlugin
	)
	plugin_KillMemoryGrowth? (
		plugin_BaseKillPlugin
	)
	plugin_KillPressure? (
		plugin_BaseKillPlugin
	)
	plugin_KillSwapUsage? (
		plugin_BaseKillPlugin
	)
	plugin_SystemdPluginsTest? (
		plugin_BaseSystemdPlugin
		plugin_SystemdRestart
	)
	plugin_SystemdRestart? (
		plugin_BaseSystemdPlugin
	)"
RDEPEND="dev-libs/jsoncpp
	openrc? ( dev-util/vmtouch
		sys-apps/openrc
		sys-process/procps
		sys-process/schedtool )
	systemd? ( sys-apps/systemd )"
DEPEND="test? ( dev-cpp/gtest )"
GCC_V_MIN="8" # for c++17
CLANG_V_MIN="6" # for c++17
BDEPEND="${BDEPEND}
	|| ( >=sys-devel/gcc-${GCC_V_MIN}
	     >=sys-devel/clang-${CLANG_V_MIN} )
	>=dev-util/meson-0.45"
SLOT="0/${PV}"
SRC_URI="https://github.com/facebookincubator/oomd/archive/v${PV}.tar.gz ->
	${PN}-${PV}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( "${S}/CODE_OF_CONDUCT.md" "${S}/CONTRIBUTING.md" "${S}/README.md" \
	"${S}/docs" )
PATCHES=( "${FILESDIR}/oomd-0.4.0-savedconfig.patch" )
CGROUP_V2_MOUNT_POINT="${CGROUP_V2_MOUNT_POINT:=/sys/fs/cgroup}"

# Conditional die
cdie() {
	if use setup_check_hard ; then
		die "${1}"
	else
		ewarn "${1}"
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists ; then
		cdie "Missing a .config in the kernel sources"
	fi
	if ver_test $(get_running_version) -lt 4.20 ; then
		cdie \
"You need a currently running kernel of >=4.20 for PSI (Pressure stall \
information tracking) support"
	fi
	if ! linux_chkconfig_present PSI ; then
		cdie \
"${PN} requires CONFIG_PSI=y in the kernel .config.  It can be found in: \
General setup > CPU/Task time and stats accounting \
> Pressure stall information tracking"
	fi
	if ! linux_chkconfig_present CGROUPS ; then
		cdie \
"${PN} requires CONFIG_CGROUPS=y in the kernel .config.  It can be found in: \
General setup > Control Group support"
	fi
	if [[ -d "${CGROUP_V2_MOUNT_POINT}/pids" ]] ; then
		cdie "You must use cgroups v2 only monuted on ${CGROUP_V2_MOUNT_POINT}."
	fi
	if [[ ! -e "${CGROUP_V2_MOUNT_POINT}/cgroup.stat" ]] ; then
		cdie "Could not detect cgroups v2 mounted on ${CGROUP_V2_MOUNT_POINT}."
	fi
	if ! linux_chkconfig_present PROC_FS ; then
		cdie \
"${PN} requires CONFIG_PROC_FS=y in the kernel .config.  It can be found in: \
File systems > Pseudo filesystems > /proc file system support"
	fi
	if ! linux_chkconfig_present SWAP ; then
# Swap is used to delay livelock a little bit longer, see link for details
# https://github.com/facebookincubator/oomd/blob/master/docs/production_setup.md#swap
		cdie \
"${PN} requires CONFIG_SWAP=y in the kernel .config.  It can be found in: \
General setup > Support for paging of anonymous memory (swap)"
	fi
	CXX=$(tc-getCXX)
	CC=$(tc-getCC)
	if tc-is-gcc ; then
		gcc_v=$(gcc-fullversion)
		if ! ver_test ${gcc_v} -ge ${GCC_V_MIN} ; then
			die \
"Switch the GCC compiler to >=${GCC_V_MIN}.  Detected ${gcc_v} instead."
		fi
	elif tc-is-clang ; then
		clang_v=$(clang-fullversion)
		if ! ver_test ${clang_v} -ge ${CLANG_V_MIN} ; then
			die \
"Switch the Clang compiler to >=${CLANG_V_MIN}.  Detected ${clang_v} instead."
		fi
	else
		die \
"Compiler is not supported.  Switch to GCC or Clang with c++17 support."
	fi
}

src_configure() {
	local req_plugins=$(echo "$USE" | grep -E -o -e "plugin_[^ ]+")
	local rej_plugins=()
	for x in ${PLUGINS_CORE[@]} ${PLUGINS_SYSTEMD[@]} ; do
		local found=0
		for y in ${req_plugins} ; do
			y=${y/plugin_/}
			if [[ ${y} == ${x} ]] ; then
				found=1
			fi
		done
		if (( ${found} == 0 )) ; then
			rej_plugins+=( ${x} )
		else
			einfo "Keeping ${x}"
		fi
	done
	for x in ${rej_plugins[@]} ; do
		einfo "Removing ${x}"
		sed -i "/${x}/d" "${S}/meson.build" || die
		rm -rf "${S}/src/oomd/plugins/"${x}*{cpp,h} \
			"${S}/src/oomd/plugins/systemd/"${x}*{cpp,h}
	done
	if ! use savedconfig ; then
		sed -i -e "/SAVEDCONFIG_CORE_PLUGINS/d" \
			-e "/SAVEDCONFIG_SYSTEMD_PLUGINS/d" \
			"${S}/meson.build" || die
	else
		pushd "${S}/src/oomd/plugins" || die
		local plugins=$(find . -name "*.cpp" | sed -e "s|\./||g")
		local custom_plugins=()
		for y in ${plugins} ; do
			local found_new=1
			for x in ${PLUGINS_CORE[@]} ${PLUGINS_SYSTEMD[@]} ; do
				if [[ ${x}.cpp =~ ${y} ]] ; then
					found_new=0
				fi
			done
			if (( ${found_new} == 1 )) ; then
				custom_plugins+=( ${y} )
			fi
		done
		popd
		build_units_basic=
		build_units_systemd=
		for x in ${custom_plugins[@]} ; do
			local y=$(echo "${x}" | sed -e "s|\.cpp$||g")
			einfo "Added custom plugin ${y}"
			if [[ "${x}" =~ ^systemd/ ]] ; then
				build_units_systemd+="    src/oomd/plugins/${x}\n"
			else
				build_units_basic+="    src/oomd/plugins/${x}\n"
			fi
		done
		sed -i -e "s|\${SAVEDCONFIG_BASIC_PLUGINS}|${build_units_basic}|g" \
			-e "s|\${SAVEDCONFIG_SYSTEMD_PLUGINS}|${build_units_systemd}|g" \
			"${S}/meson.build" || die
	fi
	default
	meson_src_configure
}

src_install() {
	cd "${BUILD_DIR}" || die
	meson_src_install
	cd "${S}" || die
	if use doc ; then
		einstalldocs
	fi
	dodoc LICENSE
	if use man ; then
		rm -rf "${ED}/usr/share/man" || die
	fi
	if use systemd ; then
		rm -rf "${ED}/usr/lib/systemd" || die
	fi
	if use openrc ; then
		insinto /etc/conf.d
		newins "${FILESDIR}/${PN}-conf.d" ${PN}
		exeinto /etc/init.d
		newexe "${FILESDIR}/${PN}-openrc" ${PN}
	fi
	mv "${ED}/etc/oomd/oomd.json" "${T}"
	dodoc "${T}/oomd.json"
}

pkg_postinst() {
	einfo \
"The basic configuration example has been moved to \
/usr/share/doc/oomd-${PV}/${PN}/oomd.json.bz2. Make sure you change and \
\`bzcat /usr/share/doc/oomd-${PV}/${PN}/oomd.json.bz2 > /etc/oomd/oomd.json\` \
 if you want copy and hand edit the example."
	if use openrc ; then
		einfo "You need to \`rc-update add ${PN}\` to auto-start on boot."
		einfo "If you want to run now, do \`rc-update restart ${PN}\`."
	fi
	if use systemd ; then
		einfo "systemd users may need to do the following:"
		einfo "systemctl stop ${PN} # for stoping the old installed instance"
		einfo "systemctl enable ${PN} # for auto-starting on boot."
		einfo "systemctl start ${PN} # for running now"
	fi
}
