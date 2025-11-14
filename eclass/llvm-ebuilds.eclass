# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-ebuilds.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: common ebuild functions
# @DESCRIPTION:
# Deduped common functions in llvm ebuilds

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For deterministic builds and working patches.
# Commits with green checkmarks used.
# The llvm 20.0.0git should be newer (>= Sep 24, 2024 [3dbd929e]) for chromium 131.0.6778.69 with 94/96 green checkmarks.
LLVM_EBUILDS_LLVM20_FALLBACK_COMMIT="1df28554bd6264d44aa2ce12e5a2fc29f61bb027" # Dec 6, 2024 (63 / 63 green checkmarks)
LLVM_EBUILDS_LLVM19_FALLBACK_COMMIT="5b4000dc58572d08754f0b2199c2046871ec8507" # Jun 26, 2024 (72 / 72 green checkmarks)
LLVM_EBUILDS_LLVM18_FALLBACK_COMMIT="2b033a32ea1b45c773158f67b48623ceffbb153d" # Feb 14, 2024 (42 / 43 green checkmarks)
LLVM_EBUILDS_LLVM19_BRANCH="main"
LLVM_EBUILDS_LLVM18_BRANCH="release/18.x"
LLVM_EBUILDS_LLVM17_BRANCH="release/17.x"

if [[ -z "${_LLVM_EBUILDS_ECLASS}" ]] ; then

_LLVM_EBUILDS_ECLASS=1
inherit flag-o-matic toolchain-funcs

llvm_ebuilds_message() {
	local slot="${1}"
	local fn="${2}"
	if [[ "${PV}" =~ "9999" && "${fn}" == "_llvm_set_globals" ]]  ; then
# bbr1 fail
# cubic fail
# htcp fail
# hybla fail
# lp fail
# pcc tested working
# new reno fail
# vegas fail
# westwood fail
#
# Fixes:
# fetch-pack: unexpected disconnect while reading sideband packet
# fatal: early EOF
#
einfo "Using fallback commit"
ewarn
ewarn "Do the following to increase download chances of live ebuilds:"
ewarn
ewarn "1. Emerge net-misc/curl[-http2]"
ewarn "2. Turn off all programs except emerge."
ewarn "3. Move the wireless closer and remove metallic obstacles to increase"
ewarn "   signal strength."
ewarn "4. Fix all dropped packet issues.  If networkmanager causes dropped"
ewarn "   packets, use netifrc instead.  This may help unmask other sources of"
ewarn "   dropped packets."
ewarn "5  Orient the antenna to achieve the lowest ping consistently with the"
ewarn "   wireless router."
ewarn "6. Switch the TCP Congestion Control to one with the highest average"
ewarn "   throughput (e.g. pcc).  For lossy poor quality connections, avoid"
ewarn "   cubic and illinois."
ewarn "7. Perform downloads at non busy times."
ewarn "8. Perform downloads at night to mitigate against solar flare"
ewarn "   disruptions."
ewarn "9. Consider replacing the WiFi antenna/dongle/card if older than 5"
ewarn "   or 10 years old."
ewarn
	fi
}

_fix_linker() {
	if ld.lld --help | grep -q -e "symbol lookup error:" \
		|| ld.lld --help | grep -q -e "undefined symbol:" ; then
ewarn "Switching to fallback linker.  Detected symbol errors from lld."
		unset LD
ewarn "Stripping -fuse-ld=*"
		filter-flags "-fuse-ld=*"
ewarn "Stripping -flto=thin"
		filter-flags "-flto=thin"
		local s
		s=$(clang-major-version)
		if tc-is-clang \
			&& has_version "sys-devel/binutils[gold,plugins]" \
			&& has_version "llvm-core/clang:${s}[binutils-plugin]" \
			&& has_version ">=llvm-core/llvmgold-${s}" \
			&& test-flag-CCLD '-fuse-ld=gold' ; then
ewarn "Switching to -fuse-ld=gold"
			append-ldflags "-fuse-ld=gold"
		elif tc-is-gcc \
			&& has_version "sys-devel/binutils[gold,plugins]" \
			&& test-flag-CCLD '-fuse-ld=gold' ; then
ewarn "Switching to -fuse-ld=gold"
			append-ldflags "-fuse-ld=gold"
		else
ewarn "Switching to -fuse-ld=bfd"
			append-ldflags "-fuse-ld=bfd"
		fi
		strip-unsupported-flags
	fi
}

llvm-ebuilds_fix_toolchain() {
	if [[ "${CC}" =~ "clang" ]] ; then
		if "${CC}" --help | grep "symbol lookup error" ; then
ewarn
ewarn "Detected symbol lookup error for CC=${CC}"
ewarn "Switching to default compiler toolchain (GCC)"
ewarn
ewarn "Any -fsanitizer=cfi* applied needs =${CATEGORY}/${P} be rebuild with"
ewarn "clang after all missing symbols have been resolved."
ewarn
			export CC="${CHOST}-gcc"
			export CXX="${CHOST}-g++"
			export CPP="${CC} -E"
			local L=(
				CPP
				AR
				AS
				NM
				OBJCOPY
				OBJDUMP
				RANLIB
				READELF
				STRIP
			)
			# Avoid any further symbol errors
			local flag
			for flag in ${L[@]} ; do
				unset ${flag}
			done
			strip-unsupported-flags
		fi
	fi
	if tc-is-gcc && is-flagq '-flto*' ; then
#
# We allow -flto for clang so that it can use CFI, but disallow -flto when"
# using GCC.
#
# gcc + -flto + -fuse-ld=lld also fails, but gcc + -fuse-ld=lld works for
# non-broken lld.
#
einfo
einfo "Removing lto flags to avoid possible IR incompatibilities with"
einfo "static-libs."
einfo
		filter-flags "-flto*"
	fi
	if [[ "${CC}" =~ ("gcc") || -z "${CC}" ]] \
		&& ( \
			is-flagq '-fuse-ld=lld' \
			|| is-flagq '-flto=thin' \
		) ; then
# Avoid ld.lld: error: version script assignment of 'LLVM_13' to symbol" 'LLVMCreateDisasm' failed: symbol not defined
		unset LD
ewarn "Stripping -fuse-ld=*"
		filter-flags "-fuse-ld=*"
	elif [[ "${CC}" =~ ("clang") ]] \
		&& ( \
			has_version "llvm-core/clang-common[default-lld]" \
			|| is-flagq '-fuse-ld=lld' \
			|| is-flagq '-flto=thin' \
		) ; then
		_fix_linker
	fi
}

fi
