# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

EGIT_REPO_URI="https://github.com/dell/dkms"
EGIT_COMMIT=872b837d37fb50578731b69b135fac1ec6e0d67c

inherit eutils git-r3

DESCRIPTION="Dynamic Kernel Module Support"
HOMEPAGE="https://github.com/dell/dkms"
LICENSE="GPL-2"
DEPEND=""
KEYWORDS="~x86 ~amd64"
SLOT="0"

src_install () {
	sed -i "s:prepare-all:prepare:g" ./dkms || die
	dosbin dkms
	dosbin dkms_mkkerneldoth

	keepdir /var/lib/dkms
	insinto /var/lib/dkms
	doins dkms_dbversion

	keepdir /etc/dkms
	insinto /etc/dkms
	newins dkms_framework.conf framework.conf
	doins template-dkms-mkrpm.spec

	doman dkms.8
	dodoc AUTHORS sample.conf sample.spec
}
