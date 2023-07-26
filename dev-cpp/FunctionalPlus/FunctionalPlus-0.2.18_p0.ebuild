# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python_3.10 )
inherit cmake-multilib

DESCRIPTION="Functional Programming Library for C++. Write concise and readable C++ code."
HOMEPAGE="
http://www.editgym.com/fplus-api-search/
https://github.com/Dobiasd/FunctionalPlus
"
LICENSE="Boost-1.0"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc test"
# U 20.04
BDEPEND="
	>=dev-util/cmake-3.14
	test? (
		>=dev-cpp/doctest-2.4.3
	)
	|| (
		>=sys-devel/gcc-4.9
		>=sys-devel/clang-4
	)
"
SRC_URI="
https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV/_/-}"
DOCS=( README.md )

# OILEDMACHINE-OVERLAY-META:  created-ebuild
