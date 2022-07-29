# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for MinGW64-w64 (for 64-bit)"
# U 20.04
RDEPEND="
	>=dev-util/mingw64-runtime-7
	>=sys-devel/gcc-9.3
	>=sys-devel/binutils-2.34
"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

pkg_setup() {
	export CTARGET="${CHOST:-${CTARGET}}"
	[[ "${CTARGET}" =~ "x86_64" ]] || die "CTARGET must contain x86_64"
	which "${CTARGET}-gcc" --version || die "Fix CTARGET"
	if ! test-flags -mwindows ; then
eerror
eerror "-mwindows test fail.  Toolchain needs to be fixed."
eerror
		die
	fi
}

src_configure() {
	default
cat << EOF > hello.c
#include <windows.h>

int WINAPI
WinMain (HINSTANCE hInstance, HINSTANCE hPrevInst, LPTSTR lpCmdLine, int nShowCmd)
{
	MessageBoxW (NULL, L"Hello World", L"Hello world", MB_OK);
	return 0;
}
EOF
	${CTARGET}-gcc hello.c -o hello.exe -mwindows || die
	if ! ( file hello.exe | grep -q -e "PE32\+ executable.*x86-64" ) ; then
eerror
eerror "Not 64-bit.  Change CTARGET."
eerror
		die
	fi
}
