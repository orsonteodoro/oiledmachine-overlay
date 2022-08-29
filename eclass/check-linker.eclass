# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-linker.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: linker checks for lto
# @DESCRIPTION:
# Deduped linker checks

inherit flag-o-matic

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_CHECK_LINKER_ECLASS=1

# @FUNCTION: check-linker_get_lto_type
# @DESCRIPTION:
# Gets the requested linker via CFLAGS/LDFLAGS and perform tests to see if
# the toolchain is prepared to use them.
check-linker_get_lto_type() {
	local s=$(clang-major-version)
	if ! is-flagq '-flto*' ; then
		echo "none"
	elif tc-is-clang \
		&& is-flagq '-fuse-ld=lld' \
		&& is-flagq '-flto=thin' \
		&& test-flag '-flto=thin' \
		&& test-flag-CCLD '-fuse-ld=lld' ; then
		echo "thinlto"
	elif tc-is-clang \
		&& is-flagq '-fuse-ld=gold' \
		&& is-flagq '-flto=full' \
		&& test-flag '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "gold"
	elif tc-is-gcc \
		&& is-flagq '-fuse-ld=gold' \
		&& is-flagq '-flto' \
		&& test-flag '-flto' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "gold"
	elif tc-is-clang \
		&& is-flagq '-fuse-ld=bfd' \
		&& is-flagq '-flto=full' \
		&& test-flag '-flto=full' ; then
		echo "bfd"
	elif is-flagq '-fuse-ld=bfd' \
		&& is-flagq '-flto' ; then
		echo "bfd"
	elif tc-is-clang \
		&& has_version "sys-devel/lld" \
		&& test-flag '-flto=thin' \
		&& test-flag-CCLD '-fuse-ld=lld' ; then
		echo "thinlto"
	elif tc-is-clang \
		&& has_version "sys-devel/binutils[gold,plugins]" \
		&& has_version "sys-devel/llvm:${s}[binutils-plugin]" \
		&& has_version ">=sys-devel/llvmgold-${s}" \
		&& test-flag '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "gold"
	elif tc-is-clang \
		&& has_version "sys-devel/binutils[gold,plugins]" \
		&& has_version "sys-devel/llvm:${s}[gold]" \
		&& has_version ">=sys-devel/llvmgold-${s}" \
		&& test-flag '-flto=full' \
		&& test-flag-CCLD '-fuse-ld=gold' ; then
		echo "gold"
	else
		echo "bfd"
	fi
}
