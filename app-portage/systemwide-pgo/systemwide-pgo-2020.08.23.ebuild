# Copyright 2016-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Portage Systemwide PGO"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
IUSE="llvm"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc \
~ppc64 ~riscv ~ppc-macos ~s390 ~sh ~sparc ~x64-macos ~x86 ~x86-macos"
RDEPEND="app-shells/bash
	llvm? ( >=sys-devel/llvm-3.7.0 )
	sys-apps/portage"
inherit eutils autotools
S="${WORKDIR}"

src_install() {
	insinto /etc/portage
	cat "${FILESDIR}/bashrc.pgo.${PV}" > "${T}/bashrc.pgo" || die
	doins "${T}/bashrc.pgo"
}

pkg_postinst() {
	if [[ ! -f "${ROOT}"/etc/portage/bashrc ]]; then
		touch "${ROOT}/etc/portage/bashrc"
	fi
	if ! grep -F -q -e "bashrc.pgo" "${ROOT}/etc/portage/bashrc" ; then
		echo "source /etc/portage/bashrc.pgo" \
			>> "${ROOT}/etc/portage/bashrc"
	fi

	einfo \
"Steps to use...\n\
1. Is it PGOable?  It must be a C or a C++ program that runs on the CPU.\n\
   GPU apps not supported.  Precompiled packages are not supported.\n\
2. Disable PGO on the package level if you enabled the use flag.\n\
3. You need to whitelist your package at /etc/portage/package.pgo.whitelist.\n\
   It contains a list of packages in category/packagename format.\n\
4. You emerge your whitelisted package.\n\
5. If it fails here, you will need to delete your package from the\n\
   ${ROOT}/etc/portage/package.pgo.phases and try again\n\
6. After emerge completes, you will simulate your app passively as normal\n\
   or applicable to the use case.  No need to rush.  If your behavior is\n\
   abnormal or you force to run under abnormal circumstances, you may\n\
   degrade the performance.\n\
7. After a week has passed, you will then complete the emerge process with\n\
   @pgo-update.\n\
8. If it fails here, your package is not PGOable or needs to be manually\n\
   bug fixed.\n\
9. After the last emerge, your package is PGO optimized.\n\
\n\
Notes and potential problems:\n\
  -If you use LLVM/clang, LLVM 3.7 is only supported.\n\
  -Each revision builds a unique PGO profile which can only be used with\n\
   the same version of the package.\n\
  -Don't use it for every package in your computer.  There is an overhead\n\
   cost and that is not natural.\n\
  -The LLVM version does poor PGO profiling and may not even collect data\n\
   at all.  Use GCC if you want more data collection.\n\
  -You may edit the time window for profiling for packages by editing the\n\
   ${ROOT}/etc/portage/bashrc.pgo.  By default it is set to 1 week.\n\
  -Chromium currently doesn't work with these scripts."
}
