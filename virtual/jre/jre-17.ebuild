# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv x86"

RDEPEND="
	|| (
		virtual/jdk:${SLOT}
		>=dev-java/openjdk-jre-bin-${OPENJDK_BIN_17_PV}:${SLOT}[gentoo-vm(+)]
	)
"
