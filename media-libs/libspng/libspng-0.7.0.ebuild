# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson multilib-build static-libs toolchain-funcs

DESCRIPTION="libspng is a C library for reading and writing Portable Network \
Graphics (PNG) format files with a focus on security and ease of use."
HOMEPAGE="https://libspng.org"
LICENSE="BSD-2
	test? ( libpng2 )"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
SLOT="0/${PV}"
IUSE+=" doc examples pgo +opt -static-libs -test -threads zlib"
REQUIRED_USE+=" pgo? ( examples )"
DEPEND+=" virtual/libc
	 test? ( >=media-libs/libpng-1.6 )
	 !zlib? ( dev-libs/miniz:=[static-libs?] )
	 zlib? ( sys-libs/zlib:=[static-libs?] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	|| (
		dev-util/pkgconf[${MULTILIB_USEDEP}]
		dev-util/pkgconfig[${MULTILIB_USEDEP}]
	)
	dev-util/meson-format-array
	doc? (
		dev-python/mkdocs
		dev-python/mkdocs-material
	)"
# GitHub is bugged?  The ZIP does not have a image so download manually
BENCHMARK_IMAGES_COMMIT="2478ec174d74d66343449f850d22e0eabb0f01b0"
SRC_URI="https://github.com/randy408/libspng/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	pgo? (
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/medium_rgb8.png
	-> libspng-medium_rgb8-${BENCHMARK_IMAGES_COMMIT}.png
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/medium_rgba8.png
	-> libspng-medium_rgba8-${BENCHMARK_IMAGES_COMMIT}.png
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/large_palette.png
	-> libspng-large_palette-${BENCHMARK_IMAGES_COMMIT}.png
	)"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CONTRIBUTING.md README.md "${S}/docs" )
HTML_DOCS=( "${S}/site" )

src_unpack() {
	unpack ${A}
	if use pgo ; then
		local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
		local dbi="${WORKDIR}/benchmark_images"
		mkdir -p "${dbi}" || die
		cp -a "${distdir}/libspng-medium_rgb8-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/medium_rgb8.png" || die
		cp -a "${distdir}/libspng-medium_rgba8-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/medium_rgba8.png" || die
		cp -a "${distdir}/libspng-large_palette-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/large_palette.png" || die
	fi
}

src_prepare() {
	default
	# Breaks pgo
	eapply "${FILESDIR}/libspng-0.6.2-disable-target-clones.patch"
	multilib_copy_sources
	prepare_abi() {
		static-libs_copy_sources
	}
	multilib_foreach_abi prepare_abi
}

_src_configure() {
	local emesonargs=(
		-Duse_miniz=$(usex zlib "false" "true")
		$(meson_feature threads multithreading)
		$(meson_use examples build_examples)
		$(meson_use opt enable_opt)
		$(meson_use test dev_build)
		--buildtype release
	)
	if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
		emesonargs+=(
			-Dbuild.default_library=shared
			-Dstatic_zlib=false
		)
	else
		emesonargs+=(
			-Dbuild.default_library=static
			-Dstatic_zlib=true
		)
	fi
	EMESON_SOURCE="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}-build-${ABI}-${ESTSH_LIB_TYPE}" \
	meson_src_configure ${1}
}

src_configure_pgo_instrumented() {
	einfo "Instrumenting a PGO build"
	mkdir -p "${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}" || die
	filter-flags '-fprofile-generate*' '-fprofile-use*' '-fprofile-dir=*'
	if tc-is-clang ; then
		append-cflags -fprofile-generate="${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}"
	else
		append-cflags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}"
	fi
	_src_configure
}

src_configure_pgo_optimized() {
	einfo "Optimizing a PGO build"
	filter-flags '-fprofile-generate*' '-fprofile-use*' '-fprofile-dir=*'
	if tc-is-clang ; then
		llvm-profdata merge -output="${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}/code.profdata" \
			"${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}" || die
		append-cflags -fprofile-use="${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}/code.profdata"
	else
		append-cflags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}-${ESTSH_LIB_TYPE}"
	fi
	_src_configure --wipe
}

src_configure_non_pgo() {
	_src_configure
}

src_configure() {
	:;
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_stsh() {
			cd "${BUILD_DIR}" || die
			_compile() {
				EMESON_SOURCE="${BUILD_DIR}" \
				BUILD_DIR="${WORKDIR}/${P}-build-${ABI}-${ESTSH_LIB_TYPE}" \
				meson_src_compile
			}
			if use pgo ; then
# See https://github.com/randy408/libspng/blob/master/docs/build.md#profile-guided-optimization
				src_configure_pgo_instrumented
				_compile
				pushd "${WORKDIR}/${P}-build-${ABI}-${ESTSH_LIB_TYPE}/examples" || die
					./example ../../benchmark_images/medium_rgb8.png || die
					./example ../../benchmark_images/medium_rgba8.png || die
					./example ../../benchmark_images/large_palette.png || die
				popd
				src_configure_pgo_optimized
				_compile
			else
				src_configure_non_pgo
				_compile
			fi
		}
		static-libs_foreach_impl compile_stsh
	}
	multilib_foreach_abi compile_abi
	cd "${S}" || die
	if use doc ; then
		mkdocs build || die
	fi
}

src_install() {
	use doc || unset HTML_DOCS
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_stsh() {
			cd "${BUILD_DIR}" || die
			EMESON_SOURCE="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}-build-${ABI}-${ESTSH_LIB_TYPE}" \
			meson_src_install
		}
		static-libs_foreach_impl install_stsh
	}
	multilib_foreach_abi install_abi
	use doc && einstalldocs
	dodoc LICENSE
}
