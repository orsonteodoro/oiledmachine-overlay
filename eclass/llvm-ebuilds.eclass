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

_LLVM_EBUILDS_ECLASS=1
inherit flag-o-matic toolchain-funcs

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
einfo
einfo "Removing lto flags to avoid possible IR incompatibilities with"
einfo "static-libs."
einfo
		filter-flags "-flto*"
	fi
	if [[ "${LD}" =~ ("lld"|"clang") ]] || is-flagq '-fuse-ld=lld' ; then
		if ld.lld --help | grep -q "symbol lookup error" \
			|| ld.lld --help | grep -q "undefined symbol" ; then
ewarn
ewarn "Detected symbol errors for lld (linker)"
ewarn "Switching to fallback linker"
ewarn
			unset LD
			filter-flags "-fuse-ld=*"
			local s
			s=$(clang-major-version)
			if tc-is-clang \
				&& has_version "sys-devel/binutils[gold,plugins]" \
				&& has_version "sys-devel/clang:${s}[binutils-plugin]" \
				&& has_version ">=sys-devel/llvmgold-${s}" \
				&& test-flag-CCLD '-fuse-ld=gold' ; then
ewarn
ewarn "Switching to -fuse-ld=gold"
ewarn
				append-ldflags "-fuse-ld=gold"
			elif tc-is-gcc \
				&& has_version "sys-devel/binutils[gold,plugins]" \
				&& test-flag-CCLD '-fuse-ld=gold' ; then
ewarn
ewarn "Switching to -fuse-ld=gold"
ewarn
				append-ldflags "-fuse-ld=gold"
			else
ewarn
ewarn "Switching to -fuse-ld=bfd"
ewarn
				append-ldflags "-fuse-ld=bfd"
			fi
			strip-unsupported-flags
		fi
	fi
}
