# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} ) # Constrained by tensorflow
TENSORFLOW_SLOTS=(
	"2.14"
	"2.15"
	"2.16"
)

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Soheil-ab/DeepCC.v1.0.git"
	FALLBACK_COMMIT="4edbed5ed0534ad6be84aa2c347b80c74c987cf5"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	#KEYWORDS="~amd64" # Ebuild needs testing
	S="${WORKDIR}/${P}"
	SRC_URI="
		FIXME
	"
fi

DESCRIPTION="DeepCC: A Deep Reinforcement Learning Plug-in to Boost the \
performance of your TCP scheme in Cellular Networks!"
HOMEPAGE="
https://github.com/Soheil-ab/DeepCC.v1.0
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" build-models evaluate kernel-patch polkit +sudo ebuild_revision_3"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
# Keras is not an upstream requirement but used to replace deprecated functions/methods
RDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/sysv-ipc-1.0.0[${PYTHON_USEDEP}]
	')
	>=net-misc/iperf-3.1.3
	|| (
		=sci-ml/tensorflow-2.17*[${PYTHON_SINGLE_USEDEP},-keras3,python]
		=sci-ml/tensorflow-2.18*[${PYTHON_SINGLE_USEDEP},-keras3,python]
		=sci-ml/tensorflow-2.19*[${PYTHON_SINGLE_USEDEP},-keras3,python]
	)
	sci-ml/tensorflow:=
	!dev-python/keras
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
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	')
	app-alternatives/sh
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
PATCHES=(
	"${FILESDIR}/${PN}-1.0_p9999-real-network-with-agnostic-sudo.patch"
	"A${FILESDIR}/${PN}-1.0_p9999-tf2.patch"
)

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi

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
			sed -i -e "s|:-sudo|:-pkexec|g" "${path}" || die
		elif use sudo ; then
einfo "Modding ${path} for sudo"
			sed -i -e "s|:-sudo|:-sudo|g" "${path}" || die
		else
einfo "Modding ${path} to remove sudo"
			sed -i -e "s|:-sudo|:-\" \"|g" "${path}" || die
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

	sed -i -e "s|@PYTHON@|${PYTHON}|g" "src/server.cc" || die
}

src_compile() {
	cd "${S}/deepcc.v1.0" || die
	DEEPCC_ELEVATE_CMD=" " \
	"./build.sh" || die
	if use build-models ; then
ewarn "The build-models USE flag is a work in progress."
		die "Unfinished / untested"
		"./training.sh" &
	fi
	rm -rf "build.sh" || die
	rm -rf "linux" || die
}

src_install() {
	insinto "/opt/deepcc"
	doins -r "${S}/deepcc.v1.0/"*
	local path
	for path in $(find "${ED}" -type f) ; do
		local path="${path/${ED}}"
		if [[ "${path}" =~ ".sh"$ ]] ; then
			einfo "fperms 0755 ${path}"
			fperms 0755 "${path}"
		elif \
			file "${ED}/${path}" \
				| grep -E -q -e "(executable|shell script)" \
		; then
			einfo "fperms 0755 ${path}"
			fperms 0755 "${path}"
		fi
	done
	dosym "real-network.sh" "/opt/deepcc/drl-agent"
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
ewarn
ewarn "FIXME:  The package indescriminately kills all running python instances."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
