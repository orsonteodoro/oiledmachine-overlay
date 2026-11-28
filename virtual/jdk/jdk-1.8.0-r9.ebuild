# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.8"
KEYWORDS="amd64 arm64 ppc64 x86 ~x64-macos ~x64-solaris"
IUSE="headless-awt"

RDEPEND="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_BIN_8_PV}:8[headless-awt=]
		>=dev-java/openjdk-${OPENJDK_8_PV}:8[headless-awt=]
	)
"
