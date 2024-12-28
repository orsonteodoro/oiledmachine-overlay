# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATENT_STATUS=(
        patent_status_free_for_codec_developers
        patent_status_free_for_end_users
        patent_status_new_or_renewed
        patent_status_nonfree
	patent_status_sponsored_ncp_nb
)

DESCRIPTION="A virtual for patent status consistency across ebuilds"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
${PATENT_STATUS[@]}
"

