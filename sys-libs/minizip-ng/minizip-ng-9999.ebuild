# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"app-arch/xz-utils-9999"
	"app-arch/zstd-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit chkl secure-version cmake-multilib multibuild

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="dc8531deb704715fa57268d5e144f9eed7c8af66"
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/zlib-ng/minizip-ng.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"

LICENSE="ZLIB"
SLOT="0/4"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc64 ~riscv x86"
IUSE="compat lzma openssl test zstd"
RESTRICT="!test? ( test ) mirror" # Speed up downloads

# Automagically prefers sys-libs/zlib-ng if installed, so let's
# just depend on it as presumably it's better tested anyway.
RDEPEND="
	>=app-arch/bzip2-${BZIP2_PV}:=[${MULTILIB_USEDEP}]
	>=dev-libs/libbsd-${LIBBSD_PV}:=[${MULTILIB_USEDEP}]
	sys-libs/zlib-ng[${MULTILIB_USEDEP}]
	virtual/libiconv:*
	compat? ( !sys-libs/zlib[minizip] )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:=[${MULTILIB_USEDEP}] )
	openssl? (
		$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	)
	zstd? ( >=app-arch/zstd-${ZSTD_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

run_both() {
	local MULTIBUILD_VARIANTS=( base )
	use compat && MULTIBUILD_VARIANTS+=( compat )

	multibuild_foreach_variant "${@}"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

my_src_configure() {
	local compat=OFF
	[[ ${MULTIBUILD_VARIANT} == compat ]] && compat=ON
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DMZ_COMPAT="${compat}"
	)

	cmake_src_configure
}

multilib_src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		# Controls installing "minizip" and "minigzip" tools.  Install
		# them unconditionally to avoid divergence with USE=test.
		-DMZ_BUILD_TESTS=ON
		-DMZ_BUILD_UNIT_TESTS=$(usex test)

		-DMZ_FETCH_LIBS=OFF
		-DMZ_FORCE_FETCH_LIBS=OFF

		# Compression library options
		-DMZ_ZLIB=ON
		-DMZ_BZIP2=ON
		-DMZ_LZMA=$(usex lzma)
		-DMZ_ZSTD=$(usex zstd)
		-DMZ_LIBCOMP=OFF
		-DMZ_PPMD=OFF

		# Encryption support options
		-DMZ_PKCRYPT=ON
		-DMZ_WZAES=ON
		-DMZ_OPENSSL=$(usex openssl)
		-DMZ_LIBBSD=ON

		# Character conversion options
		-DMZ_ICONV=ON
	)

	run_both my_src_configure
}

multilib_src_compile() { run_both cmake_src_compile; }

multilib_src_test() {
	# TODO: A bunch of tests end up looping and writing over each other's files
	# It gets better with a patch applied (see https://github.com/zlib-ng/minizip-ng/issues/623#issuecomment-1264518994)
	# but still hangs.
	local CTEST_JOBS=1
	run_both cmake_src_test
}

multilib_src_install() { run_both cmake_src_install; }

pkg_postinst() {
	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}
