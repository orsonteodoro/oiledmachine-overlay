# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions-rust.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: secure versions for Rust
# @DESCRIPTION:
# Install *only* secure versions for Rust.

case ${EAPI:-0} in
	[789]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_RUST_ECLASS}" ]] ; then
_SECURE_VERSION_RUST_ECLASS=1

# You must prefix your entry with RUST_

RUST_ZIP_PV=${RUST_ZIP_PV:-"9.0.5"}

fi
