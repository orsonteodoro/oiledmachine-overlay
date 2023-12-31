# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_SLOTS=(12 11 10 9) # Verified working
LLVM_MAX_SLOT=14 # Based on CI distro
LLVM_SLOTS=(14 13 12 11 10) # Upstream supports starting from 8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="Library for reading and writing large multi-dimensional arrays"
HOMEPAGE="
https://google.github.io/tensorstore/
https://github.com/google/tensorstore
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" clang doc"
JAVA_SLOT="11"
JDK_DEPEND="
	|| (
		dev-java/openjdk-bin:${JAVA_SLOT}
		dev-java/openjdk:${JAVA_SLOT}
	)
"
JRE_DEPEND="
	|| (
		${JDK_DEPEND}
		dev-java/openjdk-jre-bin:${JAVA_SLOT}
	)
"
RDEPEND+="
	${JRE_DEPEND}
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
	>=media-libs/libjpeg-turbo-2.1.4
	>=media-libs/libpng-1.6.37
"
DEPEND+="
	${RDEPEND}
"
gen_llvm_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				sys-devel/lld:${s}
			)
		"
	done
}
# TODO create package:
# dev-python/sphinx-immaterial
# Bazel needs --host_per_file_copt in 7.0.0*
BDEPEND+="
	>=dev-util/bazel-6.1.0
	>=dev-util/cmake-3.24
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-util/patchutils
	dev-lang/nasm
	dev-lang/perl
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-immaterial[${PYTHON_USEDEP}]
	)
	clang? (
		$(gen_llvm_depends)
	)
	|| (
		$(gen_llvm_depends)
		>=sys-devel/gcc-10
	)
"
# All versioning is first found in the console output and confirmed via links below.
# The links below are shown for faster future updates.

LIBJPEG_TURBO_PV="2.1.4"	# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/jpeg/workspace.bzl
LIBPNG_PV="1.6.37"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/png/workspace.bzl

EGIT_AOM_COMMIT="d730cef03ac754f2b6a233e926cd925d8ce8de81"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/org_aomedia_aom/workspace.bzl
EGIT_BLAKE3_COMMIT="64747d48ffe9d1fbf4b71e94cabeb8a211461081"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/blake3/workspace.bzl
EGIT_BORINGSSL_COMMIT="098695591f3a2665fccef83a3732ecfc99acdcdd"	# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/com_google_boringssl/workspace.bzl
EGIT_BROTLI_COMMIT="6d03dfbedda1615c4cba1211f8d81735575209c8"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/com_google_brotli/workspace.bzl
# Different zlib lib
EGIT_CR_ZLIB_COMMIT="2d44c51ada6d325b85b53427b02dabf44648bca4"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/net_zlib/workspace.bzl

# We may need to prefix with gh so that the fingerprints do not conflict between releases and snapshots.
bazel_external_uris="
https://github.com/BLAKE3-team/blake3/archive/${EGIT_BLAKE3_COMMIT}.tar.gz -> blake3-${EGIT_BLAKE3_COMMIT}.tar.gz
https://github.com/google/boringssl/archive/${EGIT_BORINGSSL_COMMIT}.tar.gz -> boringssl-${EGIT_BORINGSSL_COMMIT}.tar.gz
https://github.com/google/brotli/archive/${EGIT_BROTLI_COMMIT}.zip -> brotli-${EGIT_BROTLI_COMMIT}.zip
https://storage.googleapis.com/tensorstore-bazel-mirror/aomedia.googlesource.com/aom/+archive/${EGIT_AOM_COMMIT}.tar.gz -> aom-${EGIT_AOM_COMMIT}.tar.gz
https://storage.googleapis.com/tensorstore-bazel-mirror/chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${EGIT_CR_ZLIB_COMMIT}.tar.gz -> cr-zlib-${EGIT_CR_ZLIB_COMMIT}.tar.gz
"
#https://github.com/glennrp/libpng/archive/v${LIBPNG_PV}.tar.gz -> libpng-${LIBPNG_PV}.tar.gz
#https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_TURBO_PV}.tar.gz -> libjpeg-turbo-2.1.4.tar.gz
SRC_URI="
	${bazel_external_uris}
https://github.com/google/tensorstore/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-0.1.34-invoke-bazel-directly.patch"
)

distutils_enable_sphinx "docs"

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find \
		/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find \
		/opt/openjdk-bin-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/opt/openjdk-bin-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
eerror
eerror "dev-java/openjdk:${JAVA_SLOT} or dev-java/openjdk-bin:${JAVA_SLOT} must be installed"
eerror
		die
	fi
}

request_network_sandbox_permissions() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

# Modified tc_use_major_version_only() from toolchain.eclass
gcc_symlink_ver() {
	local slot="${1}"
	local ncomponents=3

	local pv=$(best_version "sys-devel/gcc:${slot}" \
		| sed -e "s|sys-devel/gcc-||g")
	if [[ -z "${pv}" ]] ; then
		return
	fi

	if ver_test ${pv} -lt 10 ; then
		ncomponents=3
	elif [[ ${slot} -eq 10 ]] && ver_test ${pv} -ge 10.4.1_p20220929 ; then
		ncomponents=1
	elif [[ ${slot} -eq 11 ]] && ver_test ${pv} -ge 11.3.1_p20220930 ; then
		ncomponents=1
	elif [[ ${slot} -eq 12 ]] && ver_test ${pv} -ge 12.2.1_p20221001 ; then
		ncomponents=1
	elif [[ ${slot} -eq 13 ]] && ver_test ${pv} -ge 13.0.0_pre20221002 ; then
		ncomponents=1
	elif [[ ${slot} -gt 13 ]] ; then
		ncomponents=1
	fi

	if [[ ${ncomponents} -eq 1 ]] ; then
		ver_cut 1 ${pv}
		return
	fi

	ver_cut 1-3 ${pv}
}

use_gcc() {
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -e "\|/usr/lib/llvm|d" \
		| tr "\n" ":")
einfo "PATH:\t${PATH}"
	local found=0
	local s
	for s in ${GCC_SLOTS[@]} ; do
		symlink_ver=$(gcc_symlink_ver ${s})
		export CC=${CHOST}-gcc-${symlink_ver}
		export CXX=${CHOST}-g++-${symlink_ver}
		export CPP="${CHOST}-g++-${symlink_ver} -E"
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to gcc:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only gcc slots ${GCC_SLOTS[@]}"
eerror
		die
	fi
	${CC} --version || die
	strip-unsupported-flags
}

use_clang() {
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
eerror
eerror "For this package, ccache cannot be combined with clang."
eerror "Disable ccache or use GCC with ccache."
eerror
		die
	fi

einfo "FORCE_LLVM_SLOT may be specified."
	local _LLVM_SLOTS=(${LLVM_SLOTS[@]})
	if [[ -n "${FORCE_LLVM_SLOT}" ]] ; then
		_LLVM_SLOTS=( ${FORCE_LLVM_SLOT} )
	fi

	local found=0
	local s
	for s in ${_LLVM_SLOTS[@]} ; do
		which "${CHOST}-clang-${s}" || continue
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		export CPP="${CHOST}-clang++-${s} -E"
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to clang:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only clang slots ${LLVM_SLOTS[@]}"
eerror
		die
	fi
	LLVM_MAX_SLOT=${s}
	llvm_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

setup_tc() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCC)
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
einfo "CFLAGS:\t${CFLAGS}"
einfo "CXXFLAGS:\t${CXXFLAGS}"
einfo "LDFLAGS:\t${LDFLAGS}"
einfo "PATH:\t${PATH}"
	if tc-is-clang || use clang ; then
		use_clang
	elif tc-is-gcc ; then
		use_gcc
	else
einfo
einfo "Use only GCC or Clang.  This package (CC=${CC}) also might not be"
einfo "completely installed."
einfo
		die
	fi
}

pkg_setup() {
	if ! [[ "${BAZEL_LD_PRELOAD_IGNORED_RISKS}" =~ ("allow"|"accept") ]] ; then
	# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe
	# reported by Bazel.
eerror
eerror "Precaution taken..."
eerror
eerror "LD_PRELOAD gets ignored by a build tool which could bypass the"
eerror "ebuild sandbox.  Set one of the following as a per-package"
eerror "environment variable:"
eerror
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"allow\"     # to continue and consent to accepting risks"
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"deny\"      # to stop (default)"
eerror
		die
	fi

	setup_openjdk

	request_network_sandbox_permissions

	setup_tc
}

src_unpack() {
	unpack ${P}.tar.gz
}

python_configure() {
	export TENSORSTORE_BAZELISK="/usr/bin/bazel"

	local TS_SYS_LIBS=(
		"jpeg"
		"png"
	)

	export TENSORSTORE_SYSTEM_LIBS=$(echo "${TS_SYS_LIBS[@]}" \
		| tr " " ",")
	export TENSORSTORE_BAZEL_STARTUP_OPTIONS="--disk_cache=${DISTDIR}"

	echo 'build --noshow_progress' >> "${S}/.bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${S}/.bazelrc" || die # Increase verbosity

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		local ccache_dir=$(ccache -sv \
			| grep "Cache directory" \
			| cut -f 2 -d ":" \
			| sed -r -e "s|^[ ]+||g")
		einfo "S=${S}"
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to ${S}/.bazelrc"
		echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${S}/.bazelrc" || die
		echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${S}/.bazelrc" || die
		echo "build --sandbox_writable_path=${ccache_dir}" >> "${S}/.bazelrc" || die
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
