# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="gperftools-${PV}"

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO"

inherit flag-o-matic autotools cflags-hardened libcxx-slot libstdcxx-slot vcs-snapshot multilib-minimal

# contains ASM code, with support for
# freebsd x86/amd64
# linux amd64/arm/arm64/ppc/ppc64/riscv/x86
# OSX ppc/amd64
# AIX ppc/ppc64
KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://github.com/gperftools/gperftools/archive/${MY_P}.tar.gz"

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="https://github.com/gperftools/gperftools"
LICENSE="MIT"
SLOT="0/4"
IUSE="
+debug llvm-libunwind minimal optimisememory test static-libs
ebuild_revision_8
"
REQUIRED_USE="
	?? (
		${PAGE_SIZES[@]}
	)
"

RESTRICT="!test? ( test )"

RDEPEND="
	llvm-libunwind? ( llvm-runtimes/libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	# set up the make options in here so that we can actually make use
	# of them on both compile and install.

	# Avoid building the unit testing if we're not going to execute
	# tests; this trick here allows us to ignore the tests without
	# touching the build system (and thus without rebuilding
	# autotools). Keep commented as long as it's restricted.
	use test || \
		MAKEOPTS+=" noinst_PROGRAMS= "

	libcxx-slot_verify
	libstdcxx-slot_verify
	if [[ -z "${TC_MALLOC_PAGE_SIZES}" ]] ; then
ewarn
ewarn "TC_MALLOC_PAGE_SIZES is undefined, using defaults."
ewarn
ewarn "Examples of use:"
ewarn
ewarn
ewarn "Contents of /etc/portage/env/tcmalloc-default-page-size.conf:"
ewarn
ewarn "# Acceptable page sizes in KiB:  4, 8, 16, 32, 64, 128, 256"
ewarn "# General case defaults in KiB:  8 for non PPC64, 64 for PPC64"
ewarn "# For apps using GiB heaps, consider 32 or 256 to reduce page fault penalty."
ewarn "# 3x fragmentation means 3x memory cost."
ewarn
ewarn "# Worst case relative performance penalty multiples:"
ewarn
ewarn "#                L1 cache hit:  1"
ewarn "#          Page fragmentation:  2"
ewarn "#                L2 cache hit:  3"
ewarn "#                L3 cache hit:  10"
ewarn "#  L1 -> L2 walk for TLB miss:  10"
ewarn "#       RAM walk for TLB miss:  100"
ewarn "#                  RAM access:  100"
ewarn "#                 RAM reclaim:  1K"
ewarn "#             RAM fault fetch:  10K"
ewarn "#        NVMe SSD fault fetch:  100K"
ewarn "#            SATA fault fetch:  500K"
ewarn "#             HDD fault fetch:  10M"
ewarn
ewarn "TC_MALLOC_PAGE_SIZES=\"amd64:8 x86:4\" # For ARCH=amd64"
ewarn "# TC_MALLOC_PAGE_SIZES=\"n64:8 n32:4 o32:4\" # For ARCH=mips64el"
ewarn "# TC_MALLOC_PAGE_SIZES=\"lp64d:8 lp64:8 ilp32d:4 ilp32:4\" # For ARCH=riscv"
ewarn "# TC_MALLOC_PAGE_SIZES=\"ppc64:64\" # For ARCH=ppc64"
ewarn
ewarn
ewarn "Contents of /etc/portage/package.env:"
ewarn
ewarn "dev-util/google-perftools tcmalloc-default-page-size.conf"
ewarn
	fi
}

src_prepare() {
	default

	eautoreconf
	multilib_copy_sources
}

set_default_tcmalloc_page_size() {
ewarn "Large page sizes are less secure."
	filter-flags '-DTCMALLOC_PAGE_SIZE_SHIFT=*'
	if [[ -z "${TC_MALLOC_PAGE_SIZES}" ]] ; then
		if [[ "${ABI}" == "ppc64" ]] ; then
			append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=16
		else
			append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=13
		fi
	else
		local pair
		for pair in ${TC_MALLOC_PAGE_SIZES} ; do
			if [[ "${pair}" =~ ":" ]] ; then
				local abi="${pair%:*}"
				local page_size="${pair#*:}" # in KiB

				local d
				if [[ "${abi}" == "ppc64" ]] ; then
					[[ -z "${page_size}" ]] && page_size=64
					d=16
				else
					[[ -z "${page_size}" ]] && page_size=8
					d=13
				fi

				(( ${page_size} > 256 )) && page_size=256
				(( ${page_size} < 4 )) && page_size=4

				local n
				case ${page_size} in
					256)
						n=18
						;;
					128)
						n=17
						;;
					64)
						n=16
						;;
					32)
						n=15
						;;
					16)
						n=14
						;;
					8)
						n=13
						;;
					4)
						n=12
						;;
					*)
						n=${d}
						;;
				esac
einfo "ABI:  ${abi}"
einfo "Page size:  ${page_size}"

				if [[ "${abi}" =~ "ppc64" ]] && [[ "${page_size}" != "64" ]] ; then
ewarn "64 KiB page size is the upstream default for ${abi}."
				fi

				if ! [[ "${abi}" =~ "ppc64" ]] && [[ "${page_size}" != "8" ]] ; then
ewarn "8 KiB page size the upstream default for ${abi}."
				fi

				append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=${n}
			fi
		done
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	use optimisememory && append-cppflags -DTCMALLOC_SMALL_BUT_SLOW
	set_default_tcmalloc_page_size
	append-flags -fno-strict-aliasing -fno-omit-frame-pointer

	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable debug debugalloc)
	)

	if [[ "${ABI}" == "x32" ]]; then
		myeconfargs+=( --enable-minimal )
	else
		myeconfargs+=( $(use_enable minimal) )
	fi

	if use arm64 || use s390; then
		# Use the same arches for disabling TLS (thread local storage)
		# as Fedora, but we might need to expand this list if we get
		# more odd segfaults in consumers like in bug #818871.
		myeconfargs+=( --disable-general-dynamic-tls )
	fi

	econf "${myeconfargs[@]}"
}

src_test() {
	multilib-minimal_src_test
}

src_install() {
	if ! use minimal && has "x32" ${MULTILIB_ABIS} ; then
		MULTILIB_WRAPPED_HEADERS=(
			"/usr/include/gperftools/heap-checker.h"
			"/usr/include/gperftools/heap-profiler.h"
			"/usr/include/gperftools/stacktrace.h"
			"/usr/include/gperftools/profiler.h"
		)
	fi

	multilib-minimal_src_install
}

multilib_src_install_all() {
	einstalldocs

	use static-libs || find "${ED}" -name '*.la' -delete || die
}
