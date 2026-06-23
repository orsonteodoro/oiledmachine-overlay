# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: secure versions
# @DESCRIPTION:
# Install *only* secure versions in security-critical systems.

if [[ -z "${_SECURE_VERSION_ECLASS}" ]] ; then
_SECURE_VERSION_ECLASS=1
OPENSSL_PV_4_0_PV="4.0.1"
OPENSSL_PV_3_6_PV="3.6.3"
OPENSSL_PV_3_5_PV="3.5.7"
OPENSSL_PV_3_4_PV="3.4.6"
OPENSSL_PV_3_3_PV="3.3.7"
OPENSSL_PV_3_0_PV="3.0.21"
LINUX_KERNEL_7_1_PV="7.1.1"
LINUX_KERNEL_6_18_PV="6.18.36"
LINUX_KERNEL_6_12_PV="6.12.94"
LINUX_KERNEL_6_6_PV="6.6.143"
LINUX_KERNEL_6_1_PV="6.1.176"
LINUX_KERNEL_5_15_PV="5.15.210"
LINUX_KERNEL_5_10_PV="5.10.259"
LIBGCRYPT_PV="9999"
NETTLE_PV="4.0"
fi
