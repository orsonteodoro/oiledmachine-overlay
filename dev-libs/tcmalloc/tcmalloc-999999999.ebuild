# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_SLOT=21 # https://github.com/bazelbuild/bazel/blob/8.4.2/scripts/bootstrap/buildenv.sh#L80
CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"

BAZEL_PV="8.4.2"

inherit bazel cflags-hardened java-pkg-2 libcxx-slot libstdcxx-slot sandbox-changes

if [[ "${PV}" =~ "99999999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/tcmalloc.git"
	FALLBACK_COMMIT="84acd18b4ddaced75c74c53d29790b971725add6" # Oct 30, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/google/tcmalloc/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Abseil TCMalloc"
HOMEPAGE="
	https://github.com/google/tcmalloc
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	!dev-util/google-perftools
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=virtual/jre-${JAVA_SLOT}:${JAVA_SLOT}
	virtual/jdk:${JAVA_SLOT}
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
	dev-java/java-config
"
DOCS=( "README.md" "docs/*" )

pkg_setup() {
	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	libcxx-slot_verify
	libstdcxx-slot_verify
#	sandbox-changes_no_network_sandbox "To download internal dependencies"
}

setup_multilib_bazel() {
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
}

unpack_tcmalloc() {
	setup_multilib_bazel
	if [[ "${PV}" =~ "99999999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	#bazel_load_distfiles "${bazel_external_uris}"
	echo "${BAZEL_PV}" > "${S}/.bazelversion" || die
}

src_unpack() {
	unpack_tcmalloc
}

src_configure() {
	cflags-hardened_append
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
	export BUILD_CFLAGS="${CFLAGS}"
	export BUILD_CXXFLAGS="${CXXFLAGS}"
	export BUILD_LDFLAGS="${LDFLAGS}"
	bazel_setup_bazelrc # Save CFLAGS
	cat "${T}/bazelrc" >> "${S}/.bazelrc" || die
	sed -i "/nodistinct_host_configuration/d" "${S}/.bazelrc" || die
}

src_compile() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local BAZEL_CACHE_FOLDER="${distdir}/bazel-cache/${CATEGORY}/${P}"
einfo "BAZEL_CACHE_FOLDER:  ${BAZEL_CACHE_FOLDER}"
	addwrite "${distdir}"
	mkdir -p "${BAZEL_CACHE_FOLDER}" || die
	export JAVA_HOME=$(java-config --jre-home)
	local extra_args=(
		--repository_cache="${BAZEL_CACHE_FOLDER}"
		--subcommands # Increase verbosity
	)
	if [[ -n "${CCACHE_DIR}" ]] ; then
einfo "CCACHE_DIR:  ${CCACHE_DIR}"
		extra_args+=(
			--host_action_env=CCACHE_DIR="${CCACHE_DIR}"
			--action_env=CCACHE_DIR="${CCACHE_DIR}"
			--sandbox_writable_path="${CCACHE_DIR}"
		)
else
ewarn "CCACHE_DIR not set.  Disabling ccache."
		export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "\|ccache/bin|d" | tr $'\n' ":")
einfo "PATH:  ${PATH}"
	fi
#		//tcmalloc:tcmalloc \
	bazel build \
		"${extra_args[@]}" \
		... \
		|| die
	bazel shutdown || die
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
