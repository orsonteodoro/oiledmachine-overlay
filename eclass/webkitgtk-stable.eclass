# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: webkitgtk-stable.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Eclass for obtaining the stable WebKitGTK version used for Tauri apps
# @DESCRIPTION:
# Centralizes the location for the stable WebKitGTK

case ${EAPI:-0} in
	[789]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# Even numbers only and the latest for security reasons
WEBKITGTK_STABLE=(
        "2.52"
)
