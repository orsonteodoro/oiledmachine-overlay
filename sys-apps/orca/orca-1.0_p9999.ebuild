# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 ) # Constrained by tensorflow
inherit distutils-r1 git-r3

DESCRIPTION="Orca: Towards Mastering Congestion Control In the Internet"
HOMEPAGE="
https://github.com/Soheil-ab/Orca
"
LICENSE="MIT"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Build in development
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" build-models cellular-traces fallback-commit kernel-patch"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	>=sci-libs/tensorflow-1.14[${PYTHON_USEDEP},python]
	app-admin/sudo
	app-alternatives/sh
	dev-python/sysv_ipc[${PYTHON_USEDEP}]
	sys-process/procps
	sys-process/psmisc
	www-misc/mahimahi
	cellular-traces? (
		sys-apps/cellular-traces-nyc
	)
	build-models? (
		dev-python/gym[${PYTHON_USEDEP}]
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
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

src_unpack() {
	EGIT_REPO_URI="https://github.com/Soheil-ab/Orca.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="cafaf9a31cb63a5b8754e1f410776d35b8ce47d0"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_configure() { :; }

src_compile() {
	cd "${S}" || die
	./build.sh || die
	if use celluar-traces ; then
		cp -a /usr/share/celluar-traces-nyc/* traces || die
	fi
	if use build-models ; then
ewarn "The build-models USE flag is a work in progress."
		die "Unfinished / untested"
		./orca.sh 1 44444 || die
	fi
	rm -rf "build.sh" || die
	if use kernel-patch ; then
		rm -rf "linux/"*.deb
	else
		rm -rf "linux"
	fi
}
src_install() {
	insinto /opt/deepcc
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
}
