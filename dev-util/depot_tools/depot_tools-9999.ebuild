# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_COMPAT=( python2_7 )

inherit eutils git-r3

DESCRIPTION="Chromium uses a package of scripts, the depot_tools, to manage interaction with the Chromium source code repository and the Chromium development process."
HOMEPAGE="http://dev.chromium.org/developers/how-tos/install-depot-tools"
EGIT_REPO_URI="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
LICENSE="GPL2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="app-admin/sudo"

src_install() {
    mkdir -p "${D}/usr/lib/depot_tools"
    FILELIST=$(find . ! -path "*/.git/*" \
                      ! -name ".*" \
                      ! -name "*.bat" \
                      ! -name "*.exe" \
                      ! -name "*.dll" \
                      ! -path "*/man/*" \
                      ! -name "man" \
                      ! -name "README*" \
                      ! -name "AUTHORS*" \
                      ! -name "COPYING" \
                      ! -name "LICENSE*" \
                      ! -name "OWNERS"  \
                      ! -path "*/win_toolchain/*" \
                      ! -name "win_toolchain" \
                      ! -path "*/tests/*" \
                      ! -name "tests" \
                      ! -path "*/testing_support/*" \
                      ! -name "testing_support" \
                      )
#    echo "${FILELIST[@]:1}"
#    die
    cp --parents ${FILELIST[@]:1} "${D}/usr/lib/depot_tools" 2>>/dev/null

    FILELIST=$(find . -name "README*" -o -name "COPYING" -o -name "AUTHORS*" -o -name "LICENSE*" )
    for f in ${FILELIST}; do
        docinto "/usr/share/doc/${P}/$(dirname $f)"
        dodoc ${f}
    done

    chgrp users "${D}/usr/lib/depot_tools/external_bin"

    #ln -s "support/chromite_wrapper" "cros_sdk"
    #ln -s "support/chromite_wrapper" "cros"
    #ln -s "support/chromite_wrapper" "chrome_set_ver"
    #ln -s "support/chromite_wrapper" "cbuildbot"

    #dobin support/chromite_wrapper

    #insinto /usr/bin
    #dosym chromite_wrapper /usr/bin/cros_sdk
}

pkg_postinst() {
	ewarn "Add /usr/lib/depot_tools to your PATH"
}
