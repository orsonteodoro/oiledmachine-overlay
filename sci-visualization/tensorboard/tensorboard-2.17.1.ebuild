# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# Bazel downloads are treated as like a live ebuild to simplify ebuild.

CXX_STANDARD=17 # Compiler default
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
GRPC_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..11} )
YARN_SLOT="1"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

inherit bazel check-compiler-switch flag-o-matic flag-o-matic-om libcxx-slot libstdcxx-slot llvm-r1 distutils-r1 yarn

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/tensorflow/tensorboard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="
https://www.tensorflow.org/
https://github.com/tensorflow/tensorboard
"
# TODO:  List licenses of third party if any.
LICENSE="
	all-rights-reserved
	Apache-2.0
"
# The distro Apache-2.0 template doesn't have all-rights-reserved
PROPERTIES="live"
SLOT="0"
IUSE+="
dev test
ebuild_revision_10
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# See https://github.com/tensorflow/tensorboard/blob/2.13.0/tensorboard/pip_package/requirements.txt
# Not used:
#	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
# Requirements for dev-python/protobuf modified by this ebuild to avoid multi instance single slot issue.

gen_llvm_bdepend() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
			)
		"
	done
}

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
		>=dev-python/markdown-2.6.8[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/werkzeug-1.0.1[${PYTHON_USEDEP}]
		>dev-python/six-1.9[${PYTHON_USEDEP}]
		dev-python/bleach[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]

		gcc_slot_11_5? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.30[${PYTHON_USEDEP},gcc_slot_11_5,cxx_standard_cxx17]
			dev-python/protobuf:3.12['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.30['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.30[${PYTHON_USEDEP}]
			)
		)
		gcc_slot_12_5? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP},gcc_slot_12_5,cxx_standard_cxx17]
			dev-python/protobuf:4.21['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.51['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP}]
			)
		)
		gcc_slot_13_4? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP},gcc_slot_13_4,cxx_standard_cxx17]
			dev-python/protobuf:4.21['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.51['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP}]
			)
		)
		gcc_slot_14_3? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP},gcc_slot_14_3,cxx_standard_cxx17]
			dev-python/protobuf:4.21['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.51['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP}]
			)
		)
		llvm_slot_18? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP},llvm_slot_18,cxx_standard_cxx17]
			dev-python/protobuf:4.21['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.51['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP}]
			)
		)
		llvm_slot_19? (
			dev-python/grpcio:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP},llvm_slot_19,cxx_standard_cxx17]
			dev-python/protobuf:4.21['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP}]
			net-libs/grpc:'${GRPC_SLOT}'/1.51['"${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},"'${PYTHON_USEDEP},python]
			test? (
				dev-python/grpcio-testing:'${GRPC_SLOT}'/1.51[${PYTHON_USEDEP}]
			)
		)

		dev-python/grpcio:=
		dev-python/protobuf:=
		net-libs/grpc:=
		test? (
			dev-python/grpcio-testing:=
		)
	')
	=sci-visualization/tensorboard-data-server-0.7*[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	$(gen_llvm_bdepend)
	$(python_gen_cond_dep '
		>=dev-python/setuptools-41.0.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/black-24.3.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-3.7.8[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20.0.31[${PYTHON_USEDEP}]
			>=dev-util/yamllint-1.17.0[${PYTHON_USEDEP}]
			test? (
				>=dev-python/boto3-1.9.86[${PYTHON_USEDEP}]
				>=dev-python/fsspec-2021.06.0[${PYTHON_USEDEP}]
				>=dev-python/grpcio-testing-1.24.3[${PYTHON_USEDEP}]
				dev-python/grpcio-testing:=
				>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
				>=dev-python/pandas-1.0[${PYTHON_USEDEP}]
			)
		)
	')
	|| (
		dev-build/bazel:6.5
		dev-build/bazel:6.1
		dev-build/bazel:5.4
		dev-build/bazel:5.3
	)
	app-arch/unzip
	dev-java/java-config
"
PDEPEND="
	=sci-ml/tensorflow-$(ver_cut 1-2 ${PV})*[${PYTHON_SINGLE_USEDEP},python]
"
PATCHES=(
	"${FILESDIR}/tensorboard-2.12.0-regex_edit_dialog_component-window-settimeout.patch"
	"${FILESDIR}/tensorboard-2.12.0-vz_projector-BUILD-add-types-three.patch"
)

# Fix linking problems.  gcc+lld cannot be combined.
use_clang() {
	local found=0
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		which "${CHOST}-clang-${s}" || continue
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		export CPP="${CC} -E"
		strip-unsupported-flags
		if "${CC}" --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to clang:${s}"
			found=1
			break
		fi
	done
	LLVM_SLOT="${s}"
	llvm-r1_pkg_setup
	"${CC}" --version || die
	strip-unsupported-flags
	fix_mb_len_max
}

pkg_setup() {
	check-compiler-switch_start
	yarn_pkg_setup
	use_clang

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	python-single-r1_pkg_setup

	libcxx-slot_verify
	libstdcxx-slot_verify

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

	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	if has_version "dev-build/bazel:6.5" ; then
		BAZEL_SLOT="6.5"
	elif has_version "dev-build/bazel:6.1" ; then
		BAZEL_SLOT="6.1"
	elif has_version "dev-build/bazel:5.4" ; then
		BAZEL_SLOT="5.4"
	elif has_version "dev-build/bazel:5.3" ; then
		BAZEL_SLOT="5.3"
	else
eerror
eerror "You must install either one of the following:"
eerror
eerror "dev-build/bazel:6.5"
eerror "dev-build/bazel:6.1"
eerror "dev-build/bazel:5.4"
eerror "dev-build/bazel:5.3"
eerror
		die
	fi
	ln -s "/usr/bin/bazel-${BAZEL_SLOT}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_SLOT}" || die "dev-build/bazel:${BAZEL_SLOT} is not installed"

	unpack "${P}.tar.gz"
	bazel_external_uris=""
	bazel_load_distfiles "${bazel_external_uris}"
	cd "${S}" || die
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	addwrite "${distdir}"
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		cp "${HOME}/.yarnrc" "${WORKDIR}" || die
	fi
}

src_prepare() {
	default
	export JAVA_HOME=$(java-config --jre-home)
	eapply "${FILESDIR}/tensorboard-2.11.2-yarn-local-cache.patch"
	sed -i -e "s|\.yarnrc|${WORKDIR}/.yarnrc|g" "WORKSPACE" || die
	sed -i -e "s|\.cache/yarn2|${HOME}/.cache/yarn2|g" "WORKSPACE" || die

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
	if use gcc_slot_11_5 ; then
		ABSEIL_CPP_SLOT="20200225"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
		RE2_SLOT="20220623"
	fi
	if use gcc_slot_12_5 ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	fi
	if use gcc_slot_13_4 ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	fi
	if use gcc_slot_14_3 ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	fi
	if use llvm_slot_18 ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	fi
	if use llvm_slot_19 ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	fi
	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure

	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local BAZEL_SLOTS=(
		{6..4}
	)
	local slot
	for slot in "${BAZEL_SLOTS[@]}" ; do
		if has_version "dev-build/bazel:${slot}" ; then
einfo "Detected dev-build/bazel:${slot} (multislot)"
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
ewarn "Detected missing files."
ewarn
ewarn "1. Retry again to re-download missing tarballs."
ewarn "2. If the build doesn't work during the build step, run"
ewarn "\`rm -rf ${distdir}/${PN}/${PV}\` if build fails."
ewarn
ewarn "nfile_actual:\t${nfiles_actual}."
ewarn "nfile_expected:\t${nfiles_expected}."
ewarn
	fi
}

add_sandbox_rules() {
	local exceptions=()
	local CYTHON_SLOTS=(
		"0.29"
		"3.0"
		"3.1"
	)
	local s
	for s in "${CYTHON_SLOTS[@]}" ; do
		exceptions+=(
			"/usr/lib/cython/${s}/lib/${EPYTHON}/site-packages/Distutils/__pycache__"
			"/usr/lib/cython/${s}/lib/${EPYTHON}/site-packages/__pycache__"
		)
	done
einfo "Adding sandbox rules"
	local path
	for path in "${exceptions[@]}" ; do
einfo "addpredict ${path}"
		addpredict "${path}"
	done
}

src_compile() {
	# There is a determinism problem.
	# It will try to use cython with python 3.10 but it should use cython
	# with python 3.11 if python 3.11 selected.
	local i
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		EPYTHON="${i/_/.}" \
		add_sandbox_rules
	done
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
		"//tensorboard/..."
	touch "${distdir}/${PN}/${PV}/.finished" || die
	check_file_count
	_ebazel build \
		"//tensorboard/..."
	mkdir -p "${T}/pip_package"
	_ebazel run "//tensorboard/pip_package:build_pip_package" -- "${T}/pip_package"

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
