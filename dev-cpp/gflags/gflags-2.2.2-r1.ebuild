# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gflags/gflags"
else
	SRC_URI="https://github.com/gflags/gflags/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="https://gflags.github.io/gflags/"

LICENSE="BSD"
SLOT="0/2.2"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

# AUTHORS.txt only links the google group
DOCS=( ChangeLog.txt README.md )

pkg_setup() {
ewarn "The release for version is more than 7 years ago.  Consider using the live ebuild instead."
	libcxx-slot_verify
	libstdcxx-slot_verify
}

multilib_src_configure() {
	append-lfs-flags

	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTING=$(usex test)
		# avoid installing .cmake/packages, e.g.:
		# >>> /tmp/portage/dev-cpp/gflags-9999/homedir/.cmake/packages/gflags/a7fca4708532331c2d656af0fdc8b8b9
		-DREGISTER_INSTALL_PREFIX=OFF
	)
	cmake_src_configure
}
