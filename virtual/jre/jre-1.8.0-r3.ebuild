# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="1.8"
KEYWORDS="amd64 arm64 ppc64 x86 ~x64-macos ~x64-solaris"

RDEPEND="
	|| (
		virtual/jdk:1.8
		>=dev-java/openjdk-jre-bin-${OPENJDK_BIN_8_PV}:8
	)
"
