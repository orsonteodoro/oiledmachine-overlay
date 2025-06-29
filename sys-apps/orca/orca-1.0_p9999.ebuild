# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} ) # Constrained by tensorflow

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Soheil-ab/Orca.git"
	FALLBACK_COMMIT="cafaf9a31cb63a5b8754e1f410776d35b8ce47d0"
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

DESCRIPTION="Orca: Towards Mastering Congestion Control In the Internet"
HOMEPAGE="
https://github.com/Soheil-ab/Orca
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
build-models cellular-traces evaluate kernel-patch polkit +sudo
ebuild_revision_4
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	cellular-traces? (
		|| (
			build-models
			evaluate
		)
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/sysv-ipc[${PYTHON_USEDEP}]
	')
	>=sci-ml/tensorflow-2[${PYTHON_SINGLE_USEDEP},python]
	dev-python/gym[${PYTHON_SINGLE_USEDEP}]
	app-alternatives/sh
	sys-process/procps
	sys-process/psmisc
	build-models? (
		www-misc/mahimahi
	)
	cellular-traces? (
		sys-apps/cellular-traces-nyc
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
PATCHES+=(
	"${FILESDIR}/${PN}-1.0_p9999-production-with-agnostic-sudo.patch"
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
}

src_prepare() {
	default
	chmod +x "build.sh" || die
	sed -i -e "s|@PYTHON@|${PYTHON}|g" \
		"learner.sh" \
		"orca.sh" \
		"src/orca-server-mahimahi.cc" \
		|| die
}

src_configure() {
	local L=(
		"actor.sh"
		"build.sh"
		"orca.sh"
		"orca-standalone-emulation.sh"
		"setup.sh"
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
}

src_compile() {
	cd "${S}" || die
	ORCA_ELEVATE_CMD=" " \
	"./build.sh" || die
	if use cellular-traces ; then
		cp -a "/usr/share/celluar-traces-nyc/"* "traces" || die
	fi
	rm -rf "build.sh" || die
	if use kernel-patch ; then
		rm -rf "linux/"*".deb"
	else
		rm -rf "linux"
	fi
}

src_install() {
	insinto "/opt/orca"
	doins -r "${S}/"*
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
	dosym "orca-real-network.sh" "/opt/orca/drl-agent"
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
# The entry point defaults to cubic.
einfo "  CONFIG_TCP_CONG_CUBIC=y"
einfo
einfo
einfo "Use the orca-real-network.sh script to load the DRL Agent for a real"
einfo "network."
einfo
einfo "To use other Congestion Control other than Cubic, you must train a new"
einfo "learned model."
einfo
ewarn
ewarn "orca-real-network.sh is in TESTING."
ewarn
	if use build-models ; then
# Not feasible for most people.
ewarn
ewarn "Build-models requires a cluster, and server with the highest grade"
ewarn "GPUs to finish in 6 hours.  ~400 combined cores and 13.04% are"
ewarn "learning servers and remaining actor clients."
ewarn
	fi
ewarn
ewarn "This package indiscriminately kills all python instances."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
