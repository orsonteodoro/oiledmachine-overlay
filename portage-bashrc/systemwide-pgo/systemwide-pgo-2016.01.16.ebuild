EAPI=5
inherit eutils autotools

DESCRIPTION="Portage Systemwide PGO"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="
        sys-apps/portage
        app-shells/bash
        llvm? ( >=sys-devel/llvm-3.7.0 )
"
IUSE="llvm"

S="${WORKDIR}"
src_install() {
	mkdir -p "${D}"/etc/portage
	cp "${FILESDIR}/bashrc.pgo" "${D}"/etc/portage/
	if [[ ! -f "${ROOT}"/etc/portage/bashrc ]]; then
		touch "${D}"/etc/portage/bashrc
	else
		cp "${ROOT}"/etc/portage/bashrc "${D}"/etc/portage/
	fi
	grep -r -e "bashrc.pgo" "${D}"/etc/portage/bashrc
	if [[ "$?" != "0" ]]; then
		echo "source ${ROOT}/etc/portage/bashrc.pgo" >> "${D}"/etc/portage/bashrc
		cat "${D}"/etc/portage/bashrc
	fi
}

pkg_postinst() {
	einfo ""
	einfo "Steps to use..."
	einfo "1. Is it PGOable?  It must be a C or a C++ program that runs on the CPU.  GPU apps not supported.  Precompiled packages are not supported."
	einfo "2. Disable PGO on the package level if you enabled the use flag."
	einfo "3. You need to whitelist your package at /etc/portage/package.pgo.whitelist.  It contains a list of packages in category/packagename format."
	einfo "4. You emerge your whitelisted package."
	einfo "4a.  If it fails here, you will need to delete your package from the ${ROOT}/etc/portage/package.pgo.phases and try again"
	einfo "5. After emerge completes, you will simulate your app passively as normal or applicable to the use case.  No need to rush.  If your behavior is abnormal or you force to run under abnormal circumstances, you may degrade the performance."
	einfo "6. After a week has passed, you will then complete the emerge process with @pgo-update."
	einfo "6a.  If it fails here, your package is not PGOable or needs to be manually bug fixed."
	einfo "7. After the last emerge, your package is PGO optimized."
	einfo ""
	einfo "Notes and potential problems:"
	einfo "  -If you use LLVM/clang, LLVM 3.7 is only supported."
	einfo "  -Each revision builds a unique PGO profile which can only be used with the same version of the package."
	einfo "  -Don't use it for every package in your computer.  There is an overhead cost and that is not natural."
	einfo "  -The LLVM version does poor PGO profiling and may not even collect data at all.  Use GCC if you want more data collection."
	einfo "  -You may edit the time window for profiling for packages by editing the ${ROOT}/etc/portage/bashrc.pgo.  By default it is set to 1 week."
	einfo "  -Chromium currently doesn't work with these scripts."
	einfo ""
}
