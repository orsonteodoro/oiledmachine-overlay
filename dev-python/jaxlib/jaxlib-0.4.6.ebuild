# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="jax"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit bazel distutils-r1 git-r3

DESCRIPTION="Support library for JAX"
HOMEPAGE="
https://github.com/google/jax/tree/main/jaxlib
"
LICENSE="
	Apache-2.0
	rocm? (
		custom
		all-rights-reserved
		Apache-2.0
		BSD-2
	)
"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Ebuild is unfinished
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cpu cuda portable rocm"
# We don't add tpu because licensing issue with libtpu_nightly.
REQUIRED_USE+="
	|| (
		cpu
		cuda
		rocm
	)
"
# Missing
# hipsolver
# miopen-hip

ROCM_PV="5.3.0"
ROCM_DEPEND="
	dev-libs/rccl
	dev-libs/rocm-device-libs
	dev-util/hip
	dev-util/roctracer
	sci-libs/hipBLAS
	sci-libs/hipFFT
	sci-libs/hipSPARSE
	sci-libs/miopen
	sci-libs/rocFFT
	sci-libs/rocRAND
"
ROCM_INDIRECT_DEPEND="
	dev-util/rocm-cmake
	dev-libs/rocm-comgr
	dev-libs/rocr-runtime
	dev-libs/roct-thunk-interface
	dev-util/rocm-smi
	dev-util/rocminfo
	sci-libs/rocBLAS
"
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
	!dev-python/jaxlib-bin
	${JRE_DEPEND}
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	rocm? (
		${ROCM_DEPEND}
	)
"
DEPEND+="
	${RDEPEND}
	${JDK_DEPEND}
"
BDEPEND+="
	dev-util/bazel
	|| (
		sys-devel/gcc
		sys-devel/clang
	)
"
EGIT_TENSORFLOW_COMMIT="2aaeef25361311b21b9e81e992edff94bcb6bae3"
# DO NOT HARDWRAP
bazel_external_uris="
	https://github.com/tensorflow/tensorflow/archive/${EGIT_TENSORFLOW_COMMIT}.tar.gz -> tensorflow-${EGIT_TENSORFLOW_COMMIT}.tar.gz
"
SRC_URI="
	${bazel_external_uris}
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
"
S="${WORKDIR}/jax-jax-v${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md CITATION.bib README.md )

distutils_enable_tests "pytest"

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

	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi

	# In the upstream they have /opt/rocm-<ver> for--rocm_path.  This
	# indicates that interdependence is important for all.  Plus, I don't
	# think they test each permutation in this distro, so breakage may
	# likely happen.
	local expected_pv=$(best_version "sci-libs/rocFFT" \
		| sed -e "sci-libs/rocFFT-")
	expected_pv=$(ver_cut 1-3 ${expected_pv})
	local catpn
	for catpn in ${ROCM_DEPEND[@]} ${ROCM_INDIRECT_DEPEND[@]} ; do
		if ! has_version "~${catpn}-${pv}" ; then
			local actual_pv=$(best_version "${catpn}" \
				| sed -e "s|${catpn}-||g")
			actual_pv=$(ver_cut 1-3 ${actual_pv})
eerror
eerror "All ROCm direct/indirect DEPENDs must be the same version"
eerror
eerror "Package:  ${catpn}"
eerror
eerror "Expected version:\t${pv}"
eerror "Actual version:\t${actual_pv}"
eerror
			die
		fi
	done
}

src_unpack() {
	unpack ${A}
	if use rocm ; then
		EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/tensorflow-upstream.git"
		EGIT_BRANCH="develop-upstream" # Default branch
		EGIT_COMMIT="HEAD"
		EGIT_CHECKOUT_DIR="${WORKDIR}/rocm-tensorflow-upstream"
		git-r3_fetch
		git-r3_checkout
	fi
}

python_compile() {
	local args=()

	# The default is release which forces avx by default.
	if is-flagq '-march=native' ; then
		args=( --target_cpu_features=native )
	elif is-flagq '-march=generic' ; then
		args=( --target_cpu_features=default )
	elif ! [[ "${CFLAGS}" =~ "-march=" ]] ; then
		args=( --target_cpu_features=default )
	else
ewarn
ewarn "Downgrading -march=* to generic."
ewarn "Use -march=native to optimize."
ewarn
		args=( --target_cpu_features=default )
	fi

	use cuda && args=( --enable_cuda )
	if use rocm ; then
		local rocm_pv=$(best_version "sci-libs/rocFFT" \
			| sed -e "sci-libs/rocFFT-")
		ewarn "You may need to fork ebuild to complete implementation for rocm"
	# See https://jax.readthedocs.io/en/latest/developer.html#additional-notes-for-building-a-rocm-jaxlib-for-amd-gpus
		${EPYTHON} build/build.py \
			--enable_rocm \
			--rocm_path=/usr \
			--bazel_options=--override_repository=xla=/path/to/xla-upstream \
			${args[@]} \
			|| die
	else
		${EPYTHON} build/build.py \
			${args[@]} \
			|| die
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
