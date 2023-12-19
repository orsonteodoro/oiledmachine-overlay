# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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
FALLBACK_LLVM18_COMMIT="9b21866feaea912bdb2d76060ef79da8a4905570" # Dec 18, 2023
FALLBACK_LLVM17_COMMIT="d36324866ee1fb4d1c26552b6b686a463d2b448f" # Jun 28, 2023

_LLVM_EBUILDS_ECLASS=1
inherit flag-o-matic toolchain-funcs

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
			&& has_version "sys-devel/clang:${s}[binutils-plugin]" \
			&& has_version ">=sys-devel/llvmgold-${s}" \
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
			has_version "sys-devel/clang-common[default-lld]" \
			|| is-flagq '-fuse-ld=lld' \
			|| is-flagq '-flto=thin' \
		) ; then
		_fix_linker
	fi
}
