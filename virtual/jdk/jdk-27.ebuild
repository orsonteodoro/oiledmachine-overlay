# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="${PV}"
KEYWORDS="~amd64"
IUSE="headless-awt"

RDEPEND="
	|| (
		>=dev-java/openjdk-bin-${OPENJDK_BIN_27_PV}:${SLOT}[headless-awt=]
		>=dev-java/openjdk-${OPENJDK_27_PV}:${SLOT}[headless-awt=]
	)
"
