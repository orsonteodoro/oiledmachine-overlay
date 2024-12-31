# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:
# With jit USE:
#ERROR: /var/tmp/portage/sci-libs/dmlab2d-1.0.0/homedir/.cache/bazel/_bazel_portage/e9835fc74ba2809dfc36f6dc41fecf6b/external/luajit_archive/BUILD.bazel:281:10: Middleman _middlemen/@luajit_Uarchive_S_S_Cbuildvm-BazelCppSemantics_build_arch_k8-opt-exec-2B5CBBC6 failed: missing input file '@luajit_archive//:src/luajit.h'
#ERROR: /var/tmp/portage/sci-libs/dmlab2d-1.0.0/homedir/.cache/bazel/_bazel_portage/e9835fc74ba2809dfc36f6dc41fecf6b/external/luajit_archive/BUILD.bazel:281:10: Middleman _middlemen/@luajit_Uarchive_S_S_Cbuildvm-BazelCppSemantics_build_arch_k8-opt-exec-2B5CBBC6 failed: 1 input file(s) do not exist
#ERROR: /var/tmp/portage/sci-libs/dmlab2d-1.0.0/homedir/.cache/bazel/_bazel_portage/e9835fc74ba2809dfc36f6dc41fecf6b/external/luajit_archive/BUILD.bazel:281:10 Middleman _middlemen/@luajit_Uarchive_S_S_Cbuildvm-BazelCppSemantics_build_arch_k8-opt-exec-2B5CBBC6 failed: 1 input file(s) do not exist

APPLE_SUPPORT_PV="1.6.0"						# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L133
ABSEIL_CPP_COMMIT="9f1dcc70d64232e77964de9b90e209e23e0110db"		# From patch
ABSEIL_PY_COMMIT="9e543208a72300a4f8677fe725550fe8dc242bac"		# From patch
BAZEL_SKYLIB_COMMIT="288731ef9f7f688932bd50e704a91a45ec185f9b"		# From patch
BAZEL_SLOT="6.1"							# Undocumented version
BENCHMARK_COMMIT="27d64a2351b98d48dd5b18c75ff536982a4ce26a"		# From patch
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
DM_ENV_COMMIT="3c6844db2aa4ed5994b2c45dbfd9f31ad948fbb8"		# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L113
DM_TREE_COMMIT="df359fddcd8db21f6065a418ebf8873e2c9aedd5"		# From patch
EIGEN_COMMIT="b02c384ef4e8eba7b8bdef16f9dc6f8f4d6a6b2b"			# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L54
GOOGLETEST_COMMIT="1ed6a8c67a0bd675149ece27bbec0ef1759854cf"		# From patch
LIBPNG_PV="1.6.37"							# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L66
LUAJIT_PV="2.1"								# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L106
LUA_PV="5.1.5"								# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L88
PYBIND11_COMMIT="8d08dc64ca300342852ceaa7b1d65fe9f69dab06"		# From patch
PYTHON_COMPAT=( "python3_"{10..12} )
RULES_CC_COMMIT="22d91c627c81513d27d8ab0a90b01d08b8b76349"		# From patch
RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"		# From https://github.com/bazelbuild/bazel/blob/6.1.2/distdir_deps.bzl#L69
RULES_LICENSE_PV="0.0.3"						# https://github.com/bazelbuild/bazel/blob/6.1.2/src/MODULE.tools#L5
RULES_PYTHON_COMMIT="5c5ab5bd9577a284784d1c8b27bf58336de06010"		# From patch
ZLIB_PV="1.2.11"							# https://github.com/google-deepmind/lab2d/blob/release_v1.0.0/WORKSPACE#L77

inherit bazel distutils-r1 flag-o-matic pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google-deepmind/lab2d.git"
	FALLBACK_COMMIT="f889febd208cdf13ac379ed648781107f4db0769" # Jul 20, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/lab2d-release_v${PV}"
bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT}.zip -> abseil-cpp-${ABSEIL_CPP_COMMIT}.zip
https://github.com/abseil/abseil-py/archive/${ABSEIL_PY_COMMIT}.zip -> abseil-py-${ABSEIL_PY_COMMIT}.zip
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/archive/${BAZEL_SKYLIB_COMMIT}.zip -> bazel-skylib-${BAZEL_SKYLIB_COMMIT}.zip
https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.zip -> rules_cc-${RULES_CC_COMMIT}.zip
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_license/releases/download/${RULES_LICENSE_PV}/rules_license-${RULES_LICENSE_PV}.tar.gz
https://github.com/bazelbuild/rules_python/archive/${RULES_PYTHON_COMMIT}.zip -> rules_python-${RULES_PYTHON_COMMIT}.zip
https://github.com/deepmind/dm_env/archive/${DM_ENV_COMMIT}.zip -> dm_env-${DM_ENV_COMMIT}.zip
https://github.com/glennrp/libpng/archive/v${LIBPNG_PV}.zip -> libpng-${LIBPNG_PV}.zip
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.zip -> benchmark-${BENCHMARK_COMMIT}.zip
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.zip -> googletest-${GOOGLETEST_COMMIT}.zip
https://github.com/google-deepmind/tree/archive/${DM_TREE_COMMIT}.zip -> dm-tree-${DM_TREE_COMMIT}.zip
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.zip -> pybind11-${PYBIND11_COMMIT}.zip
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
https://zlib.net/zlib-${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
!jit? (
	https://www.lua.org/ftp/lua-${LUA_PV}.tar.gz -> lua-${LUA_PV}.tar.gz
)
jit? (
	https://github.com/LuaJIT/LuaJIT/archive/v${LUAJIT_PV}.tar.gz -> LuaJIT-${LUAJIT_PV}.tar.gz
)
"
	SRC_URI="
	${bazel_external_uris}
https://github.com/google-deepmind/lab2d/archive/refs/tags/release_v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A customisable 2D platform for agent-based AI research"
HOMEPAGE="
	https://github.com/google-deepmind/lab2d
	https://pypi.org/project/dmlab2d
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" -jit ebuild_revision_1"
REQUIRED_USE="
	!jit
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/bazel-${BAZEL_SLOT}:${BAZEL_SLOT}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "AUTHORS" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-pin-commits.patch" # Generated from committer-date:<=2023-07-20
	"${FILESDIR}/${PN}-1.0.0-add-sha256-checksums.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi

	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_SLOT}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_SLOT}" || die "dev-build/bazel:${BAZEL_SLOT} is not installed"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	replace-flags '-O0' '-O1' # Fix _FORITIFY_SOURCE
	bazel_setup_bazelrc
	cat "${T}/bazelrc" >> "${S}/.bazelrc"
	default
	python_copy_sources
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	bazel build --lua_version=lua5_1 ... || die

	local wheel_path
	local d="${WORKDIR}/lab2d-release_v${PV}-${EPYTHON/./_}/install"

	local version="${EPYTHON/python}"
	version="${version/./}"
	local wheel_dir=$(realpath "${HOME}/.cache/bazel/_bazel_portage/"*"/execroot/org_deepmind_lab2d/bazel-out/k8-opt/bin/dmlab2d/")

	wheel_path=$(realpath "${wheel_dir}/${PN}-${PV}-"*"cp${version}-"*".whl")
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
