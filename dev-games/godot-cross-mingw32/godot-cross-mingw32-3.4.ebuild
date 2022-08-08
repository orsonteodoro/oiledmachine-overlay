# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for MinGW64-w64 (for 32-bit)"
# U 20.04
RDEPEND="
	>=dev-util/mingw64-runtime-7
	>=sys-devel/gcc-9.3
	>=sys-devel/binutils-2.34
"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	[[ "${CHOST}" =~ "i686" ]] || die "CHOST must contain i686"
	which "${CHOST}-gcc" --version || die "Fix CHOST"
	if ! test-flags -mwindows ; then
eerror
eerror "-mwindows test fail.  Toolchain needs to be fixed."
eerror
		die
	fi
}

src_configure() {
	default
	einfo "Checking if the compiler is working properly"
cat << EOF > hello.c
#include <windows.h>

int WINAPI
WinMain (HINSTANCE hInstance, HINSTANCE hPrevInst, LPTSTR lpCmdLine, int nShowCmd)
{
	MessageBoxW (NULL, L"Hello world", L"Hello world", MB_OK);
	return 0;
}
EOF
	${CHOST}-gcc hello.c -o hello.exe -mwindows || die
	if ! ( file hello.exe | grep -q -e "PE32 executable.*386" ) ; then
eerror
eerror "Not 32-bit.  Change CHOST."
eerror
		die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
