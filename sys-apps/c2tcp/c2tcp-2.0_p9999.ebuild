# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-r1 git-r3

DESCRIPTION="C2TCP: A Flexible Cellular TCP to Meet Stringent Delay \
Requirements."
HOMEPAGE="
https://github.com/Soheil-ab/c2tcp
"
LICENSE="MIT"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Ebuild needs testing
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit kernel-patch polkit sudo"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/sysv_ipc-1.0.0[${PYTHON_USEDEP}]
	>=net-misc/iperf-3.1.3
	app-alternatives/sh
	dev-lang/perl
	sys-apps/cellular-traces-y2018
	sys-process/procps
	sys-process/psmisc
	www-misc/mahimahi
	polkit? (
		sys-auth/polkit
	)
	sudo? (
		app-admin/sudo
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	app-alternatives/sh
	sys-devel/gcc
"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/c2tcp-2.0_p9990-bash-edits.patch"
)

src_unpack() {
	EGIT_REPO_URI="https://github.com/Soheil-ab/c2tcp.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="4b5b2413543eec935144172330cd96c230294f0f"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_configure() {
	local L=(
		"run-sample.sh"
		"setup.sh"
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
}

src_compile() {
	cd "${S}" || die
	./build.sh || die
	local L=(
		$(cat /var/db/pkg/sys-apps/cellular-traces-y2018*/CONTENTS \
			| cut -f 2 -d " ")
	)
	local path
	for path in ${L[@]} ; do
		if [[ -f "${path}" ]] ; then
			cp -a "${path}" traces || die
		fi
	done
	rm -rf "build.sh" || die
	if use kernel-patch ; then
		rm -rf "linux-patch/"*.deb || die
	else
		rm -rf "linux-patch" || die
	fi
}
src_install() {
	insinto /opt/${PN}
	doins -r *
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
einfo "  CONFIG_TCP_CONG_CUBIC=y"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
