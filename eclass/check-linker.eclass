# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-linker.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: linker checks for lto
# @DESCRIPTION:
# Deduped linker checks

inherit flag-o-matic toolchain-funcs

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_CHECK_LINKER_ECLASS=1

_is_lld() {
	if has_version "llvm-core/clang-common[default-lld]" ; then
		return 0
	elif is-flagq '-fuse-ld=lld' ; then
		return 0
	fi
	return 1
}

# @FUNCTION: check-linker_get_lto_type
# @DESCRIPTION:
# Gets the requested linker via CFLAGS/LDFLAGS and perform tests to see if
# the toolchain is prepared to use them.
check-linker_get_lto_type() {
	local s=$(clang-major-version)
	if ! is-flagq '-flto*' ; then
		echo "none"
	elif ( tc-is-clang || tc-is-gcc ) \
		&& is-flagq '-flto' \
		&& test-flags '-flto' \
		&& test-flag-CCLD '-fuse-ld=mold' ; then
		echo "moldlto"
	elif tc-is-clang \
		&& _is_lld \
		&& is-flagq '-flto=thin' \
		&& test-flags '-flto=thin' \
		&& test-flag-CCLD '-fuse-ld=lld' ; then
		echo "thinlto"
	elif tc-is-clang \
		&& is-flagq '-fuse-ld=gold' \
		&& is-flagq '-flto=full' \
		&& test-flags '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "goldlto"
	elif tc-is-gcc \
		&& is-flagq '-fuse-ld=gold' \
		&& is-flagq '-flto' \
		&& test-flags '-flto' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "goldlto"
	elif tc-is-clang \
		&& is-flagq '-fuse-ld=bfd' \
		&& is-flagq '-flto=full' \
		&& test-flags '-flto=full' ; then
		echo "bfdlto"
	elif tc-is-gcc \
		&& is-flagq '-fuse-ld=bfd' \
		&& is-flagq '-flto' ; then
		echo "bfdlto"
	elif tc-is-clang \
		&& has_version "llvm-core/lld" \
		&& has_version "llvm-core/clang-common[default-lld]" \
		&& test-flags '-flto=thin' ; then
		echo "thinlto"
	elif tc-is-clang \
		&& has_version "llvm-core/lld" \
		&& test-flags '-flto=thin' \
		&& test-flag-CCLD '-fuse-ld=lld' ; then
		echo "thinlto"
	elif tc-is-clang \
		&& has_version "sys-devel/binutils[gold,plugins]" \
		&& has_version "llvm-core/llvm:${s}[binutils-plugin]" \
		&& has_version ">=llvm-core/llvmgold-${s}" \
		&& test-flags '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "goldlto"
	elif tc-is-clang \
		&& has_version "sys-devel/binutils[gold,plugins]" \
		&& has_version "llvm-core/llvm:${s}[gold]" \
		&& has_version ">=llvm-core/llvmgold-${s}" \
		&& test-flags '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "goldlto"
	else
		echo "none"
	fi
}
