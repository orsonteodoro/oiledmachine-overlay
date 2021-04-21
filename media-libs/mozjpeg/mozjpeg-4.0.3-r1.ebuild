# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils multilib-minimal

DESCRIPTION="Improved JPEG encoder based on libjpeg-turbo"
HOMEPAGE="https://github.com/mozilla/mozjpeg"
LICENSE="BSD IJG ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" +static-libs"
RDEPEND+=" sys-libs/zlib:=[${MULTILIB_USEDEP},static-libs?]
	 media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP},static-libs?]
	 >=media-libs/libpng-1.6:=[${MULTILIB_USEDEP},static-libs?]"
DEPEND+=" ${RDEPEND}"
SRC_URI="\
https://github.com/mozilla/mozjpeg/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
SO_AGE="3"
SO_MAJOR="62"
SO_MINOR="0"
SO_VERSION="${SO_MAJOR}.${SO_AGE}.${SO_MINOR}" # jpeg6b ABI, default
DOC=( README.md README-mozilla.txt usage.txt wizard.txt )
CMAKE_BUILD_TYPE=Release

src_prepare() {
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}"
		S="${BUILD_DIR}" \
		cmake-utils_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}"
		local mycmakeargs=(
			-DENABLE_STATIC:STRING=$(usex static-libs)
			-DWITH_JAVA=OFF
		)
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}"
		cmake-utils_src_compile
	}
	multilib_foreach_abi compile_abi
}

_newbin() {
	newbin wrapper moz$1
	mv "${D}"/usr/bin/$1 "${D}"/usr/bin/.moz$1 || die
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}"
		cmake-utils_src_install
		# wrapper to use renamed libjpeg.so (allows coexistence with
		# libjpeg-turbo)
		echo -e '#!/bin/sh\nLD_PRELOAD=libmozjpeg.so .$(basename $0) "$@"' \
			> wrapper
		if multilib_is_native_abi ; then
			_newbin cjpeg
			_newbin djpeg
			_newbin jpegtran
			_newbin rdjpgcom
			_newbin tjbench
			_newbin wrjpgcom
			# remove / resolve conflicts between libjpeg-turbo
			rm "${D}"/usr/share/man/man1/{cjpeg,djpeg,jpegtran}.1 \
			   "${D}"/usr/share/man/man1/{rdjpgcom,wrjpgcom}.1 || die
			mkdir -p "${D}/usr/include/libmozjpeg" || die
			mv "${D}"/usr/include/*.h "${D}"/usr/include/libmozjpeg || die
		fi
		# remove / resolve conflicts between libjpeg-turbo
		rm "${D}"/usr/$(get_libdir)/libjpeg.so{,.${SO_MAJOR}} \
			"${D}"/usr/$(get_libdir)/libturbojpeg* \
			"${D}"/usr/$(get_libdir)/pkgconfig/libturbojpeg.pc || die
		if use static-libs ; then
			mv "${D}"/usr/$(get_libdir)/lib{,moz}jpeg.a || die
		fi
		mv "${D}"/usr/$(get_libdir)/lib{,moz}jpeg.so.${SO_VERSION} || die
		mv "${D}"/usr/$(get_libdir)/pkgconfig/lib{,moz}jpeg.pc || die
		sed -i -e "s|\${prefix}/include|\${prefix}/include/libmozjpeg|" \
			"${D}"/usr/$(get_libdir)/pkgconfig/libmozjpeg.pc || die
		sed -i -e "s|-ljpeg|-lmozjpeg|" \
			"${D}"/usr/$(get_libdir)/pkgconfig/libmozjpeg.pc || die
		cd "${D}"/usr/$(get_libdir)/
		ln -s libmozjpeg.so.${SO_VERSION} libmozjpeg.so.${SO_MAJOR}
		ln -s libmozjpeg.so.${SO_VERSION} libmozjpeg.so
	}
	multilib_foreach_abi install_abi
}
