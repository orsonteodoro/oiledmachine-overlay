# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson multilib-build toolchain-funcs uopts

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

DESCRIPTION="libspng is a C library for reading and writing Portable Network \
Graphics (PNG) format files with a focus on security and ease of use."
HOMEPAGE="https://libspng.org"
LICENSE="
	BSD-2
	test? (
		libpng2
	)
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples +opt -static-libs -test -threads zlib"
REQUIRED_USE+="
	pgo? (
		examples
	)
"
RDEPEND+="
	!zlib? (
		dev-libs/miniz:=[static-libs?]
	)
	virtual/libc
	test? (
		>=media-libs/libpng-1.6
	)
	zlib? (
		sys-libs/zlib:=[${MULTILIB_USEDEP},static-libs?]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-util/meson-0.54.0
	dev-util/meson-format-array
	doc? (
		dev-python/mkdocs
		dev-python/mkdocs-material
	)
"
PATCHES=(
	"${FILESDIR}/libspng-0.7.4-disable-target-clones.patch"
)
DOCS=( "${S}/CONTRIBUTING.md" "${S}/README.md" "${S}/docs" )
HTML_DOCS=( "${S}/site" )

pkg_setup() {
	uopts_setup
}

src_unpack() {
	unpack ${A}
	if use pgo ; then
		local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
		local dbi="${WORKDIR}/benchmark_images"
		mkdir -p "${dbi}" || die
		cp -a \
			"${distdir}/libspng-medium_rgb8-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/medium_rgb8.png" \
			|| die
		cp -a \
			"${distdir}/libspng-medium_rgba8-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/medium_rgba8.png" \
			|| die
		cp -a \
			"${distdir}/libspng-large_palette-${BENCHMARK_IMAGES_COMMIT}.png" \
			"${dbi}/large_palette.png" \
			|| die
	fi
}

src_prepare() {
	default
	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

_src_configure() {
	cd "${EMESON_SOURCE}" || die
	append-cppflags -I"${EPREFIX}/usr/include/miniz"
	local d="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}-${lib_type}"
	mkdir -p "${d}" || die
	uopts_src_configure

	local emesonargs=(
		$(meson_feature threads multithreading)
		$(meson_use examples build_examples)
		$(meson_use opt enable_opt)
		$(meson_use test dev_build)
		$(tpgo_meson_src_configure)
		-Duse_miniz=$(usex zlib "false" "true")
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
	meson_src_configure
}

src_configure() {
	:;
}

train_trainer_list() {
	seq 0 2 | tr " " "\n"
}

declare -A ARGS=(
	[0]="${WORKDIR}/benchmark_images/medium_rgb8.png"
	[1]="${WORKDIR}/benchmark_images/medium_rgba8.png"
	[2]="${WORKDIR}/benchmark_images/large_palette.png"
)

train_get_trainer_args() {
	local trainer="${1}"
	echo "${ARGS[${trainer}]}"
}

train_get_trainer_exe() {
	echo "examples/example"
}

_src_compile() {
	cd "${BUILD_DIR}" || die
	meson_src_compile
}

# The order does matter with PGO.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export EMESON_SOURCE="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
# See https://github.com/randy408/libspng/blob/master/docs/build.md#profile-guided-optimization
			if [[ "${lib_type}" == "static" ]] ; then
				uopts_n_training
			else
				uopts_y_training
			fi
			uopts_src_compile
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
			uopts_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	dodoc LICENSE
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
