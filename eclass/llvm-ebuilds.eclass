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

# The algorithm to pick the fallback-commit has changed on Aug 3, 2026.

# This section is AI assisted to better explain the formula.

#
# Commit snapshot quality comparison on Aug 2, 2026
#
# | Source                 | Commit ID  | Date     | LLVM slot  | Checkmarks | sanitizer-* test fails    | sanitizer-* checks    | llvm-clang-pauth pass | llvm-clang-pac-ret pass | libc-asan passed | [6] |
# | -----------------------|------------|----------|------------|------------|---------------------------|-----------------------|-----------------------|-------------------------|------------------|-----|
# | chromium-toolchain     | 53d1880    | 20260616 | 23.0.0-git | 6/6        | 0 [3]                     | 0 [3]                 | 0 [3]                 | 0 [3]                   | 0 [3]            | N   |
# | distro                 | 0bf3638    | 20260725 | 24.0.0-git | 120/134    | 0                         | 17                    | 1                     | 1                       | 2                | Y   |
# | distro                 | bb9934d    | 20260724 | 23.1.0-rc1 | 27/32      | 0 [2]                     | 0 [1]                 | 0 [1][2]              | 0 [1]                   | 0 [1]            | Y   |
# | oiledmachine-overlay   | 11038cc    | 20260801 | 24.0.0-git | 122/133    | 0                         | 17                    | 1                     | 1                       | 2                | Y   |
# | oiledmachine-overlay   | edb9efb    | 20260802 | 23.1.0-rc2 | 20/24 [5]  | 0 [2]                     | 0 [1]                 | 0 [1][2]              | 0 [1]                   | 0 [1]            | Y   |
# | -                      | bd6bfba    | 20260802 | 23.0.0-git | 99/126     | 0 [4]                     | 9                     | 0 [2]                 | 0                       | 2                | N   |
# | -                      | 8b68596    | 20260616 | 23.0.0-git | 77/81      | 2                         | 10                    | 0                     | 1                       | 2                | N   |
#
# [1] See bd6bfba3 (tagged llvmorg-23-init)
# [2] Passes with adjacent commit 1546138, adjacent to bd6bfba3 (code freeze)
# [3] See 8b68596 adjacent commit, adjacent to 53d1880 (git repo snapshot)
# [4] Fail detected with adjacent commit 1546138, adjacent to bd6bfba3 (code freeze)
# [5] The updated 23.x branch is preferred over an older pre llvmorg-23-init development snapshot to address miscompilation vulnerabilities
# [6] Contains f2dfbf0 (20260710) miscompilation fix?
#     UB - https://github.com/llvm/llvm-project/pull/208683
#     OOBR, segfault - https://github.com/llvm/llvm-project/issues/208611

#
# My AI prompt:
#
# i need a custom scoring function coefficients that uses uses a cutoff of >=8
# days with heavy penalty, miscompile commit fix(es) that increases the score
# more heavily for recently fixed commits but declines for older, increases the score
# significantly when there is number of ci/cd fixes >= 120 but diminishes when
# the score drops below 120.
#
# If you ask the AI for the answer, it is garbage.  They are giving complex
# answers but still give useful facts to craft the custom score function.
# Intuitively, you know which one is the best commit in the 7 days.
# The most elegant one by AI uses a predefined budget of 1000 and decreases it.
#
# It is based on the GitHub CI/CD results:
#
# S = CHECKS + SAN + ARM + LIBC + MISCOMP + CUT
#
# S = total score
# CHECKS = cost/benefit score for 120 checkmarks baseline
# SAN = cost/benefit score for sanitizers
# ARM = cost/benefit score for Arm sanitizers
# LIBC = cost/benefit score for LLVM libc sanitizers
# MISCOMP = miscompile fix(es) benefit score
# CUT = days cutoff penalty score
#
# Alternatively,
#
# S = (B_1 + C_1) + (B_2 + C_2) + (B_3 + C_3) + (B_4 + C_4) + (B_5 + C_5) + (B_6_6 + C_6_1 ... B_6_N + C_6_N) + (B_7 + C_7),
# when S >= 0 it is a keeper, S < 0 it is a reject
#
# S = Scoring function, aka total score
# B_1 = subscore for the number of green benefit checkmarks
# C_1 = subscore for the number of red cost checkmarks
# B_2 = subscore for the number of sanitizer green benefit checkmarks
# C_2 = subscore for the number of sanitizer red cost checkmarks
# B_3 = subscore for the number of green benefit llvm-clang-pac-ret checkmarks
# C_3 = subscore for the number of red cost llvm-clang-pac-ret checkmarks
# B_4 = subscore for the number of green benefit llvm-clang-pauth checkmarks
# C_4 = subscore for the number of red cost llvm-clang-pauth checkmarks
# B_5 = subscore for the number of green benefit libc-asan checkmarks
# C_5 = subscore for the number of red cost libc-asan checkmarks
# B_6_1 = subscore for the number of green benefit miscompile fixes since today, instance 1
# C_6_1 = subscore for the number of red cost miscompile missed fixes since today, instance 1
# ...
# (There can be multiple miscompile fixes that land on the repo on a single day.)
# ...
# B_6_N = subscore for the number of green benefit miscompile fixes since today, instance N
# C_6_N = subscore for the number of red cost miscompile missed fixes since today, instance N
# B_7 = subscore for the benefit number of days passed since today
# C_7 = subscore for the cost number of days passed since today
#
# B_1 = +75 per green checkmark
# C_1 = -75 per red checkmark
# B_2 = +588 points per gained checkmarks above 120
# C_2 = -588 points per lost checkmarks below 120
# C_3 = -10000 per llvm-clang-pac-ret red checkmark
# B_3 = +10000 per llvm-clang-pac-ret green checkmark
# C_4 = -5000 per llvm-clang-pac-ret red checkmark
# B_4 = +5000 per llvm-clang-pac-ret green checkmark
# C_5 = -5000 per libc-asan red checkmark
# B_5 = +5000 per libc-asan green checkmark
# C_6_1 = 0 for simplification
# B_6_1 = higher base score but diminishes as days pass, instance 1
# ...
# (There can be multiple miscompile fixes that land on the repo on a single day.)
# ...
# C_6_N = 0 for simplification
# B_6_N = higher base score but diminishes as days pass, instance N
# B_7 = 0 for simplification
# C_7 = If days passed >= 8 then - 1000000, else 0
#
# Again, we don't calculate this but use simple rules.  Reject older commits
# that do not address most recently fixed miscompiles.  Prioritize and find
# commits where they are above 120 for pre stable commit snapshots.  Reject
# commits when a red checkmark for sanitizer(s) is/are observed for our
# microarch use case.  Backtrack the search to 7 days as a soft requirement and
# up to 30 days as a hard requirement.
#
# There are consideration for faster bumps for most latest LLVM slot (24) to
# mitigate miscompilations that may lead to vulnerabilities.  The
# fallback-commit policy is still being decided to go with either a
# zero-tolerance policy or bump once a month to balance the costs/benefits.
#

LLVM_EBUILDS_LLVM24_FALLBACK_COMMIT="11038cc1618ac1f801e4029b7149f68f3ad949f5" # Aug 1, 2026 (122 / 133 green checkmarks)
LLVM_EBUILDS_LLVM23_FALLBACK_COMMIT="edb9efb3e0823d32d6b4baa8f5f798bca3e300a3" # Aug 2, 2026 (20 / 24 green checkmarks)

LLVM_EBUILDS_LLVM24_BRANCH="main"
LLVM_EBUILDS_LLVM23_BRANCH="release/23.x"

LLVM_EBUILDS_LLVM24_REVISION=""
LLVM_EBUILDS_LLVM23_REVISION="llvm23_revision_2"

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
