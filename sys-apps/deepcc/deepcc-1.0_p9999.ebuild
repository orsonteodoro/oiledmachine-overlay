# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 ) # Constrained by tensorflow
inherit python-r1 git-r3

DESCRIPTION="DeepCC: A Deep Reinforcement Learning Plug-in to Boost the \
performance of your TCP scheme in Cellular Networks!"
HOMEPAGE="
https://github.com/Soheil-ab/DeepCC.v1.0
"
LICENSE="MIT"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Ebuild needs testing
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" build-models evaluate fallback-commit kernel-patch polkit +sudo r3"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/sysv_ipc-1.0.0[${PYTHON_USEDEP}]
	>=net-misc/iperf-3.1.3
	>=sci-libs/tensorflow-1.14[${PYTHON_USEDEP},python]
	app-alternatives/sh
	sys-process/procps
	sys-process/psmisc
	build-models? (
		www-misc/mahimahi
	)
	evaluate? (
		www-misc/mahimahi
	)
	polkit? (
		sys-auth/polkit
	)
	sudo? (
		app-admin/sudo
	)
	|| (
		sys-apps/shadow[su]
		sys-apps/util-linux[su]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	app-alternatives/sh
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	sys-devel/gcc
"
PDEPEND+="
	kernel-patch? (
		|| (
			sys-apps/c2tcp[kernel-patch]
			sys-apps/orca[kernel-patch]
		)
	)
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-1.0_p9999-real-network-with-agnostic-sudo.patch"
)

src_unpack() {
	EGIT_REPO_URI="https://github.com/Soheil-ab/DeepCC.v1.0.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="4edbed5ed0534ad6be84aa2c347b80c74c987cf5"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout

	cd "${S}/models" || die
	local p
	for p in $(find . -name "*.tar.gz") ; do
		unpack "${p}"
		local name=$(basename "${p}" | sed -e "s|\.tar\.gz||g")
		rm -rf "${S}/deepcc.v1.0/rl-module/${name}" || die
		mv "${name}" "${S}/deepcc.v1.0/rl-module" || die
	done
	rm -rf "${WORKDIR}/models" || die
}

src_configure() {
	cd "${S}/deepcc.v1.0"
	local L=(
		"evaluate.sh"
		"run-dcubic.sh"
		"run-deep.sh"
		"setup.sh"
		"training.sh"
	)
	local path
	for path in ${L[@]} ; do
		if use polkit ; then
einfo "Modding ${path} for polkit"
			sed -i -e "s|:-sudo|:-pkexec|g" "${path}"
		elif use sudo ; then
einfo "Modding ${path} for sudo"
			sed -i -e "s|:-sudo|:-sudo|g" "${path}"
		else
einfo "Modding ${path} to remove sudo"
			sed -i -e "s|:-sudo|:-\" \"|g" "${path}"
		fi
	done
	if use polkit ; then
einfo "Modding src/define.h for polkit"
		sed -i -e "s|elevate_cmd=0|elevate_cmd=1|g" "src/define.h" || die
	elif use sudo ; then
einfo "Modding src/define.h for sudo"
		sed -i -e "s|elevate_cmd=0|elevate_cmd=0|g" "src/define.h" || die
	else
einfo "Modding src/define.h to remove sudo"
		sed -i -e "s|elevate_cmd=0|elevate_cmd=2|g" "src/define.h" || die
	fi
}

src_compile() {
	cd "${S}/deepcc.v1.0" || die
	DEEPCC_ELEVATE_CMD=" " ./build.sh || die
	if use build-models ; then
ewarn "The build-models USE flag is a work in progress."
		die "Unfinished / untested"
		./training.sh &
	fi
	rm -rf "build.sh" || die
	rm -rf "linux" || die
}
src_install() {
	insinto /opt/deepcc
	doins -r "${S}/deepcc.v1.0/"*
	local path
	for path in $(find "${ED}" -type f) ; do
		local path="${path/${ED}}"
		if [[ "${path}" =~ ".sh"$ ]] ; then
			einfo "fperms 0755 ${path}"
			fperms 0755 "${path}"
		elif file "${ED}/${path}" | grep -E -q -e "(executable|shell script)" ; then
			einfo "fperms 0755 ${path}"
			fperms 0755 "${path}"
		fi
	done
	dosym real-network.sh /opt/deepcc/drl-agent
}

pkg_postinst() {
einfo
einfo "Kernel changes required for evaluate and the kernel-patch:"
einfo
einfo "  CONFIG_PROC_FS=y"
einfo "  CONFIG_EXPERT=y"
einfo "  CONFIG_PROC_SYSCTL=y"
einfo "  CONFIG_NET=y"
einfo "  CONFIG_INET=y"
einfo "  CONFIG_TCP_CONG_ADVANCED=y"
einfo "  CONFIG_TCP_CONG_BBR=y"
einfo "  CONFIG_TCP_CONG_CUBIC=y"
einfo "  CONFIG_TCP_CONG_ILLINOIS=y"
einfo "  CONFIG_TCP_CONG_WESTWOOD=y"
einfo
	if use kernel-patch ; then
		local found=""
		if has_version "sys-apps/c2tcp[kernel-patch]" \
			|| has_version "sys-apps/orca[kernel-patch]" ; then
			found="/opt/c2tcp/linux-patch or /opt/orca/linux"
		elif has_version "sys-apps/c2tcp[kernel-patch]" ; then
			found="/opt/c2tcp/linux-patch"
		elif has_version "sys-apps/orca[kernel-patch]" ; then
			found="/opt/orca/linux"
		fi
einfo
einfo "The kernel patch can be found in ${found}."
einfo
	fi
einfo
einfo "Use the real-network.sh script to load the DRL Agent for a real"
einfo "network."
einfo
einfo "To use other Congestion Control other than Cubic, you must train a new"
einfo "learned model."
einfo
ewarn
ewarn "real-network.sh is in TESTING."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
