# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson multilib-build toolchain-funcs

DESCRIPTION="libspng is a C library for reading and writing Portable Network
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
	 zlib? ( sys-libs/zlib:=[static-libs?,${MULTILIB_USEDEP}] )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	dev-util/meson-format-array
	doc? (
		dev-python/mkdocs
		dev-python/mkdocs-material
	)
"
# GitHub is bugged?  The ZIP does not have a image so download manually
BENCHMARK_IMAGES_COMMIT="2478ec174d74d66343449f850d22e0eabb0f01b0"
SRC_URI="
	https://github.com/randy408/libspng/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	pgo? (
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/medium_rgb8.png
	-> libspng-medium_rgb8-${BENCHMARK_IMAGES_COMMIT}.png
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/medium_rgba8.png
	-> libspng-medium_rgba8-${BENCHMARK_IMAGES_COMMIT}.png
https://github.com/libspng/benchmark_images/raw/${BENCHMARK_IMAGES_COMMIT}/large_palette.png
	-> libspng-large_palette-${BENCHMARK_IMAGES_COMMIT}.png
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( "${S}/CONTRIBUTING.md" "${S}/README.md" "${S}/docs" )
HTML_DOCS=( "${S}/site" )
PATCHES=(
	"${FILESDIR}/libspng-0.6.2-disable-target-clones.patch"
)

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

_src_configure() {
	local emesonargs=(
		-Duse_miniz=$(usex zlib "false" "true")
		$(meson_feature threads multithreading)
		$(meson_use examples build_examples)
		$(meson_use opt enable_opt)
		$(meson_use test dev_build)
		--buildtype release
	)
	if [[ "${lib_type}" == "shared" ]] ; then
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
	meson_src_configure ${1}
}

_configure_pgx() {
	cd "${EMESON_SOURCE}" || die
	append-cppflags -I"${EPREFIX}/usr/include/miniz"
	local d="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}-${lib_type}"
	mkdir -p "${d}" || die
	filter-flags '-fprofile*'
	local arg=""
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] ; then
		einfo "Instrumenting a PGO build"
		if tc-is-clang ; then
			append-cflags -fprofile-generate="${d}"
		else
			append-cflags -fprofile-generate -fprofile-dir="${d}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] ; then
		einfo "Optimizing a PGO build"
		if tc-is-clang ; then
			llvm-profdata merge -output="${d}/code.profdata" \
				"${d}" || die
			append-cflags -fprofile-use="${d}/code.profdata"
		else
			append-cflags -fprofile-use -fprofile-correction -fprofile-dir="${d}"
		fi
		arg="--wipe"
	else
		einfo "Building as normal"
	fi
	_src_configure ${arg}
}

src_configure() {
	:;
}

_run_trainer() {
	pushd "${BUILD_DIR}/examples" || die
		./example ../../benchmark_images/medium_rgb8.png || die
		./example ../../benchmark_images/medium_rgba8.png || die
		./example ../../benchmark_images/large_palette.png || die
	popd
}

_compile() {
	cd "${BUILD_DIR}" || die
	meson_src_compile
}

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export EMESON_SOURCE="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			if use pgo ; then
# See https://github.com/randy408/libspng/blob/master/docs/build.md#profile-guided-optimization
				PGO_PHASE="pgi"
				_configure_pgx
				_compile
				_run_trainer
				PGO_PHASE="pgo"
				_configure_pgx
				_compile
			else
				PGO_PHASE="pg0"
				_configure_pgx
				_compile
			fi
		done
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export EMESON_SOURCE="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			meson_src_install
		done
	}
	multilib_foreach_abi install_abi
	cd "${S}" || die
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
