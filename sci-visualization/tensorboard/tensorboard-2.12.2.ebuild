# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_{8..11} )
YARN_SLOT="1"
inherit bazel flag-o-matic llvm distutils-r1 yarn

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="
https://www.tensorflow.org/
https://github.com/tensorflow/tensorboard
"
# TODO:  List licenses of third party if any.
LICENSE="
	all-rights-reserved
	Apache-2.0
" # The distro Apache-2.0 template doesn't have all-rights-reserved
SLOT="0"
KEYWORDS="~amd64"
IUSE+=" test r2"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
PROPERTIES="live"
# See https://github.com/tensorflow/tensorboard/blob/2.12.0/tensorboard/pip_package/requirements.txt
# Not used:
#	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
# Requirements for dev-python/protobuf-python modified by this ebuild to avoid multi instance single slot issue.
PROTOBUF_SLOT="0/32"
LLVM_MAX_SLOT=14
LLVM_MIN_SLOT=10
LLVM_SLOTS=( ${LLVM_MAX_SLOT} 13 12 11 ${LLVM_MIN_SLOT} )

gen_llvm_bdepend() {
	for s in ${LLVM_SLOTS[@]} ; do
		if (( ${s} >= ${LLVM_MIN_SLOT} && ${s} < ${LLVM_MAX_SLOT} )) ; then
			echo "
				(
					sys-devel/clang:${s}
					sys-devel/llvm:${s}
					>=sys-devel/lld-10
				)
			"
		else
			echo "
				(
					sys-devel/clang:${s}
					sys-devel/llvm:${s}
					sys-devel/lld:${s}
				)
			"
		fi
	done
}

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		(
			<dev-python/google-auth-3[${PYTHON_USEDEP}]
			>=dev-python/google-auth-1.6.3[${PYTHON_USEDEP}]
		)
		(
			<dev-python/google-auth-oauthlib-1.1[${PYTHON_USEDEP}]
			>=dev-python/google-auth-oauthlib-0.5[${PYTHON_USEDEP}]
		)
		(
			<dev-python/requests-3[${PYTHON_USEDEP}]
			>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
		)
		>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
		>=dev-python/markdown-2.6.8[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/tensorboard-plugin-wit-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/werkzeug-1.0.1[${PYTHON_USEDEP}]
		dev-python/bleach[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/protobuf-python:'${PROTOBUF_SLOT}'[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		|| (
			=dev-python/grpcio-1.49*:=[${PYTHON_USEDEP}]
			=dev-python/grpcio-1.50*:=[${PYTHON_USEDEP}]
			=dev-python/grpcio-1.51*:=[${PYTHON_USEDEP}]
			=dev-python/grpcio-1.52*:=[${PYTHON_USEDEP}]
		)
	')
	=sci-visualization/tensorboard-data-server-0.8*[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/setuptools-41[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.26[${PYTHON_USEDEP}]
		>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.7.8[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.0.31[${PYTHON_USEDEP}]
		>=dev-util/yamllint-1.17.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/boto3-1.9.86[${PYTHON_USEDEP}]
			>=dev-python/fsspec-0.7.4[${PYTHON_USEDEP}]
			>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
			>=dev-python/pandas-1.0[${PYTHON_USEDEP}]
			|| (
				=dev-python/grpcio-testing-1.49*:=[${PYTHON_USEDEP}]
				=dev-python/grpcio-testing-1.50*:=[${PYTHON_USEDEP}]
				=dev-python/grpcio-testing-1.51*:=[${PYTHON_USEDEP}]
				=dev-python/grpcio-testing-1.52*:=[${PYTHON_USEDEP}]
			)
		)
	')
	(
		<dev-util/bazel-7
		>=dev-util/bazel-4.2.2
	)
	app-arch/unzip
	dev-java/java-config
	|| (
		$(gen_llvm_bdepend)
	)
"
PDEPEND="
	$(python_gen_cond_dep '
		=sci-libs/tensorflow-'$(ver_cut 1-2 ${PV})'*[${PYTHON_USEDEP},python]
	')
"
bazel_external_uris="
https://mirror.bazel.build/cdn.azul.com/zulu/bin/zulu11.56.19-ca-jdk11.0.15-linux_x64.tar.gz
https://mirror.bazel.build/bazel_java_tools/releases/java/v11.9/java_tools-v11.9.zip
"
SRC_URI="
${bazel_external_uris}
https://github.com/tensorflow/tensorboard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
PATCHES=(
	"${FILESDIR}/tensorboard-2.12.0-regex_edit_dialog_component-window-settimeout.patch"
	"${FILESDIR}/tensorboard-2.12.0-vz_projector-BUILD-add-types-three.patch"
)

check_network_sandbox() {
	# It takes too much time to package and third party bazel ruins offline install.
	# Required for yarn config set yarn-offline-mirror
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download micropackages and obtain version releases"
eerror "information."
eerror
		die
	fi
}

# Fix linking problems.  gcc+lld cannot be combined.
use_clang() {
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
	if (( ${s} == 10 || ${s} == 11 || ${s} == 14 )) ; then
		:;
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_MAX_SLOT=${s}
	llvm_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

pkg_setup() {
	check_network_sandbox
	use_clang
	python_setup
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
einfo "CFLAGS:\t${CFLAGS}"
einfo "CXXFLAGS:\t${CXXFLAGS}"
einfo "LDFLAGS:\t${LDFLAGS}"
einfo "PATH:\t${PATH}"
}

src_unpack() {
	YARN_OFFLINE=0
	yarn_hydrate

	unpack ${P}.tar.gz
	bazel_load_distfiles "${bazel_external_uris}"
	cd "${S}" || die
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	addwrite "${distdir}"
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		yarn config set yarn-offline-mirror "${distdir}/${PN}/${PV}/npm-packages-offline-cache" || die
		cp "${HOME}/.yarnrc" "${WORKDIR}" || die
	fi
}

src_prepare() {
	default
	export JAVA_HOME=$(java-config --jre-home)
	eapply "${FILESDIR}/tensorboard-2.11.2-yarn-local-cache.patch"
	sed -i -e "s|\.yarnrc|${WORKDIR}/.yarnrc|g" WORKSPACE || die
	sed -i -e "s|\.cache/yarn2|${HOME}/.cache/yarn2|g" WORKSPACE || die

	filter-flags '-fuse-ld=*'
	bazel_setup_bazelrc
}

# From bazel.eclass
_ebazel_configure() {
	# Use different build folders for each multibuild variant.
	local output_base="${BUILD_DIR:-${S}}"
	output_base="${output_base%/}-bazel-base"
	mkdir -p "${output_base}" || die

#	echo 'fetch --noshow_progress' >> "${T}/bazelrc" || die # Disable high CPU usage on xfce4-terminal
#	echo 'build --noshow_progress' >> "${T}/bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${T}/bazelrc" || die # Increase verbosity

	# Place cache outside of ebuild sandbox to reduce redownloads
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	echo "fetch --repository_cache=${distdir}/${PN}/${PV}/bazel" >> "${T}/bazelrc" || die
	echo "build --repository_cache=${distdir}/${PN}/${PV}/bazel" >> "${T}/bazelrc" || die

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		local ccache_dir=$(ccache -sv \
			| grep "Cache directory" \
			| cut -f 2 -d ":" \
			| sed -r -e "s|^[ ]+||g")
		echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to ${T}/bazelrc"
		echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc" || die
		echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc" || die
		echo "build --sandbox_writable_path=${ccache_dir}" >> "${T}/bazelrc" || die
		export CCACHE_DIR="${ccache_dir}"
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
	fi

	export CARGO_HOME="${distdir}/${PN}/${PV}/cargo"
	mkdir -p "${CARGO_HOME}"
	echo "build --action_env=CARGO_HOME=\"${CARGO_HOME}\"" >> "${T}/bazelrc" || die
	echo "build --host_action_env=CARGO_HOME=\"${CARGO_HOME}\"" >> "${T}/bazelrc" || die

	echo "build --repo_env PYTHON_BIN_PATH=\"${PYTHON}\"" >> "${T}/bazelrc" || die
	echo "build --action_env=PYENV_ROOT=\"${HOME}/.pyenv\"" >> "${T}/bazelrc" || die
	echo "build --python_path=\"${PYTHON}\"" >> "${T}/bazelrc" || die

	if [[ -e "${S}/.bazelrc" ]] ; then
		cat "${S}/.bazelrc" >> "${T}/bazelrc" || die
		rm "${S}/.bazelrc" || die
	fi
}

src_configure() {
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local slot
	for slot in 6 5 4 ; do
		if has_version "dev-util/bazel:${slot}" ; then
einfo "Detected dev-util/bazel:${slot} (multislot)"
			ln -sf \
				"${ESYSROOT}/usr/bin/bazel-${slot}" \
				"${WORKDIR}/bin/bazel" \
				|| die
			has_multislot_bazel=1
			bazel --version || die
			break
		fi
	done
	if (( ${has_multislot_bazel} == 0 )) ; then
ewarn
ewarn "Using unslotted bazel.  Use the one from the oiledmachine-overlay"
ewarn "instead or downgrade to bazel < 7"
ewarn
	fi
	_ebazel_configure
}

_ebazel() {
	set -- bazel --bazelrc="${T}/bazelrc" --output_base="${output_base}" ${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

check_file_count() {
	local nfiles_expected=1769
	local nfiles_actual
	nfiles_actual=$(find "${distdir}/${PN}/${PV}" \
		-type f 2>/dev/null \
		| wc -l)
	if (( ${nfiles_actual} != ${nfiles_expected} )) ; then
ewarn
ewarn "Detected missing files.  Run \`rm -rf ${distdir}/${PN}/${PV}\` if build"
ewarn "doesn't work."
ewarn
ewarn "nfile_actual:\t${nfiles_actual}."
ewarn "nfile_expected:\t${nfiles_expected}."
ewarn
	fi
}

src_compile() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
# Repeated fails when fetch is incomplete or not completely atomic.
	if [[ ! -e "${distdir}/${PN}/${PV}/.finished" ]] ; then
# The build system/scripts doesn't to extra checks and complains about the wrong
# tarball hash code even though the tarball is not present.
einfo "Wiping incomplete yarn download."
		rm -rf "${distdir}/${PN}/${PV}/npm-packages-offline-cache"
		rm -rf "${distdir}/${PN}/${PV}/bazel"
	fi

	_ebazel fetch \
		//tensorboard/...
	touch "${distdir}/${PN}/${PV}/.finished" || die
	check_file_count
	_ebazel build \
		//tensorboard/...
	mkdir -p "${T}/pip_package"
	_ebazel run //tensorboard/pip_package:build_pip_package -- "${T}/pip_package"

	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	local wheel_path=$(realpath "${T}/pip_package/"*".whl")
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	# The distutils eclass is broken.
	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	multibuild_merge_root "${d}" "${D%/}"
}
