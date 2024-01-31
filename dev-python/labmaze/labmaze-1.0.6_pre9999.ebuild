# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3 java-utils-2

bazel_external_uris="

"
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
${bazel_external_uris}
https://github.com/deepmind/labmaze/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A standalone release of DeepMind Lab's maze generator with Python bindings."
HOMEPAGE="https://github.com/deepmind/labmaze"
LICENSE="
	Apache-2.0
"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Live ebuilds do not get keyworded
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
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
	!=dev-python/setuptools-50.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
	${JDK_DEPEND}
"
BDEPEND+="
	dev-build/bazel
"

S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
)

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
# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe reported by Bazel.
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
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		EGIT_REPO_URI="https://github.com/deepmind/labmaze.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="HEAD"
		use fallback-commit && EGIT_COMMIT="6d7e8f058428025cd4253f1ef6a1ed6618d9b0ea"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi

	local actual_pv=$(grep -e "__version__ =" "${S}/setup.py" \
		| cut -f 2 -d "'")
	local expected_pv=$(ver_cut 1-3 ${PV})
	if ver_test ${actual_pv} -ne ${expected_pv} ; then
eerror
eerror "Version changed detected which may have different *DEPENDs or break packages"
eerror
eerror "Expected version:\t${expected_pv}"
eerror "Actual version:\t${actual_pv}"
eerror
eerror "Use the fallback-commit USE flag to continue."
eerror
		die
	fi
}

src_prepare() {
	cd "${S}" || die
	local path
	for path in $(find . -name "BUILD") ; do
einfo "Editing ${path}"
		sed -i -E -e 's$@bazel_tools//platforms:(linux|osx|windows|android|freebsd|ios|os)$@platforms//os:\1$' "${path}" || die
		sed -i -E -e 's$@bazel_tools//platforms:(cpu|x86_32|x86_64|ppc|arm|aarch64|s390x)$@platforms//cpu:\1$' "${path}" || die
	done
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
