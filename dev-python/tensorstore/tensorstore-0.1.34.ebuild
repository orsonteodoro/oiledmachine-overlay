# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Last build bug
# ERROR: /var/tmp/portage/dev-python/tensorstore-0.1.34/homedir/.cache/bazel/_bazel_portage/59ee02eecb45563c2cef4c9c3d3be912/external/com_google_brotli/BUILD:105:11: 
# Compiling c/common/context.c failed: (Exit 1): x86_64-pc-linux-gnu-gcc failed: error executing command (from target @com_google_brotli//:brotlicommon) 

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit bazel distutils-r1

DESCRIPTION="Library for reading and writing large multi-dimensional arrays"
HOMEPAGE="
https://google.github.io/tensorstore/
https://github.com/google/tensorstore
"
LICENSE="
	Apache-2.0
"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # On hold until the above bug is fixed
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
LLVM_SLOTS=(17 16 15 14 13) # Upstream supports starting from 8
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

EGIT_BLAKE3_COMMIT="64747d48ffe9d1fbf4b71e94cabeb8a211461081"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/blake3/workspace.bzl
EGIT_BORINGSSL_COMMIT="098695591f3a2665fccef83a3732ecfc99acdcdd"	# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/com_google_boringssl/workspace.bzl
EGIT_BROTLI_COMMIT="6d03dfbedda1615c4cba1211f8d81735575209c8"		# Found in https://github.com/google/tensorstore/blob/v0.1.34/third_party/com_google_brotli/workspace.bzl

# We may need to prefix with gh so that the fingerprints do not conflict between releases and snapshots.
bazel_external_uris="
https://github.com/BLAKE3-team/blake3/archive/${EGIT_BLAKE3_COMMIT}.tar.gz -> blake3-${EGIT_BLAKE3_COMMIT}.tar.gz
https://github.com/google/boringssl/archive/${EGIT_BORINGSSL_COMMIT}.tar.gz -> boringssl-${EGIT_BORINGSSL_COMMIT}.tar.gz
https://github.com/google/brotli/archive/${EGIT_BROTLI_COMMIT}.zip -> brotli-${EGIT_BROTLI_COMMIT}.zip
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
	# Needs bazel-7 which is not packaged by distro.
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
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
	MAKEOPTS="-j1"
}

src_unpack() {
	unpack ${P}.tar.gz
	bazel_load_distfiles "${bazel_external_uris}"
}

python_configure() {
	bazel_setup_bazelrc

	cat "${T}/bazelrc" >> "${S}/.bazelrc" || die

	export TENSORSTORE_BAZELISK="/usr/bin/bazel"
#	export USE_BAZEL_VERSION=$(best_version "dev-util/bazel" \
#		| sed -e "s|dev-util/bazel-||g")

	local TS_SYS_LIBS=(
#		"com_google_brotli"
		"jpeg"
		"png"
	)

	export TENSORSTORE_SYSTEM_LIBS=$(echo "${TS_SYS_LIBS[@]}" \
		| tr " " ",")
#	export TENSORSTORE_BAZEL_STARTUP_OPTIONS="--disk_cache=${DISTDIR}"

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
