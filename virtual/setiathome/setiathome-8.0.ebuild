# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="setiathome"
SLOT="8"
KEYWORDS="amd64"
IUSE="ap-cpu ap-gpu sah-cpu sah-gpu"
RDEPEND="sah-cpu? ( sci-misc/setiathome-cpu:8 )
         sah-gpu? ( sci-misc/setiathome-gpu:8 )
         ap-gpu? ( sci-misc/astropulse-gpu:7 )
         ap-gpu? ( sci-misc/astropulse-gpu:7 )
	 sci-misc/setiathome-cfg
        "
