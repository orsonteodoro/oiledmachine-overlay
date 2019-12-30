# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="C API package to utilize the Spotify music streaming service"
HOMEPAGE="https://developer.spotify.com/technologies/libspotify/"
LICENSE="Spotify"
KEYWORDS="~arm"
IUSE="armv6hf"
SLOT="0/${PV}"
inherit multilib-minimal
DEPEND="virtual/pkgconfig[${MULTILIB_USEDEP}]"
SRC_URI="arm? ( armv6hf? ( https://github.com/mopidy/libspotify-archive/raw/master/libspotify-12.1.103-Linux-armv6-bcm2708hardfp-release.tar.gz ) )"
S="${WORKDIR}"

_fill_arch() {
	if [[ "${CHOST}" =~ armv6 && "${CHOST}" =~ hf ]] ; then
		arch="armv6-bcm2708hardfp"
	else
		die "ARCH/ABI not supported"
	fi
	echo "${arch}"
}

src_prepare() {
	default
	prepare_abi() {
		local arch=$(_fill_arch)
		export S="${WORKDIR}/${P}-Linux-${arch}-release"
		cd "${S}" || die
		sed -i -e 's|PKG_PREFIX:$(prefix)|PKG_PREFIX:$(real_prefix)|' \
			-e 's/ldconfig.*//'\
			-e "s|prefix)/lib|prefix)/$(get_libdir)|g" \
			Makefile || die
		sed -i -e "s|{exec_prefix}/lib|{exec_prefix}/$(get_libdir)|" \
			lib/pkgconfig/${PN}.pc || die
	}
	multilib_foreach_abi prepare_abi
}

src_compile() {
	:
}

src_install() {
	install_abi() {
		export QA_PRESTRIPPED+=" /usr/$(get_libdir)/${PN}.so.${PV}"
		local arch=$(_fill_arch)
		export S="${WORKDIR}/${P}-Linux-${arch}-release"
		cd "${S}" || die
		emake prefix="${D}/usr" real_prefix="${ROOT}/usr" install

		if multilib_is_native_abi ; then
			dodoc README ChangeLog

			# install man
			doman share/man3/*
		fi
	}
	multilib_foreach_abi install_abi
}
