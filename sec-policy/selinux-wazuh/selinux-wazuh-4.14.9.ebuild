# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is AI generated, partly edited by ebuild maintainer.
# This file is a draft and untested, for devs that use SELinux and want to fix/verify it works.

# We cannot use the inherit selinux-policy-2 because of the versioning and refpolicy.
# wazuh.te is a standalone checkmodule policy.

S="${WORKDIR}/wazuh-${PV}"
SRC_URI="https://github.com/wazuh/wazuh/archive/v${PV}.tar.gz -> wazuh-${PV}.tar.gz"
# or only ship files/wazuh.te in FILESDIR and no SRC_URI

DESCRIPTION="SELinux module for Wazuh agent (upstream wazuh.pp)"
HOMEPAGE="https://wazuh.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""
BDEPEND="
	sys-apps/checkpolicy
	sys-apps/policycoreutils
"
RDEPEND="
	>=sys-apps/policycoreutils-2.5
"

src_compile() {
	checkmodule -M -m -o wazuh.mod "${S}/src/selinux/wazuh.te" || die
	semodule_package -o wazuh.pp -m wazuh.mod || die
}

src_install() {
	insinto /usr/share/selinux/targeted
	doins wazuh.pp
	# optional: other POLICY_TYPES directories if you care
}

pkg_postinst() {
	if [[ -z ${ROOT} ]] && [[ -x /usr/sbin/semodule ]]; then
		semodule -i /usr/share/selinux/targeted/wazuh.pp
		semodule -e wazuh 2>/dev/null || true
	fi
}

pkg_prerm() {
	[[ -z ${ROOT} ]] && semodule -r wazuh 2>/dev/null || true
}
