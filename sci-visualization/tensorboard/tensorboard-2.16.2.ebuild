# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
GCC_SLOT=12
LLVM_COMPAT=( {17..15} )
PYTHON_COMPAT=( "python3_"{10..11} )
YARN_SLOT="1"

inherit bazel check-compiler-switch flag-o-matic llvm-r1 distutils-r1 yarn

KEYWORDS="~amd64 ~arm64"
bazel_external_uris="
"
#${bazel_external_uris}
SRC_URI="
https://github.com/tensorflow/tensorboard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

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
test
ebuild_revision_7
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# See https://github.com/tensorflow/tensorboard/blob/2.13.0/tensorboard/pip_package/requirements.txt
# Not used:
#	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
# Requirements for dev-python/protobuf modified by this ebuild to avoid multi instance single slot issue.

gen_llvm_bdepend() {
	for s in ${LLVM_COMPAT[@]} ; do
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

		|| (
			(
				=dev-python/grpcio-1.62*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.62*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.25[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.62*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.61*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.61*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.25[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.61*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.60*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.60*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.25[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.60*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.59*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.59*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.24[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.59*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.58*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.58*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.23[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.58*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.57*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.57*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.23[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.57*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.56*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.56*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.23[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.56*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.55*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.55*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/4.23[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.55*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.54*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.54*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/3.21[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.54*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.53*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.53*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/3.21[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.53*[${PYTHON_USEDEP}]
				)
			)
			(
				=dev-python/grpcio-1.49*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.49*[${PYTHON_USEDEP},python]
				dev-python/protobuf:0/3.21[${PYTHON_USEDEP}]
				test? (
					=dev-python/grpcio-testing-1.49*[${PYTHON_USEDEP}]
				)
			)
		)
		dev-python/grpcio:=
		dev-python/protobuf:=
		net-libs/grpc:=
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
		>=dev-python/setuptools-41[${PYTHON_USEDEP}]
		>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.7.8[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.0.31[${PYTHON_USEDEP}]
		>=dev-util/yamllint-1.17.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/boto3-1.9.86[${PYTHON_USEDEP}]
			>=dev-python/fsspec-2021.06.0[${PYTHON_USEDEP}]
			>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
			>=dev-python/pandas-1.0[${PYTHON_USEDEP}]

			dev-python/grpcio-testing:=[${PYTHON_USEDEP}]
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
	sys-devel/gcc:${GCC_SLOT}
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
einfo "FORCE_LLVM_SLOT may be specified."
	local _LLVM_COMPAT=(${LLVM_COMPAT[@]})
	if [[ -n "${FORCE_LLVM_SLOT}" ]] ; then
		_LLVM_COMPAT=( ${FORCE_LLVM_SLOT} )
	fi

	local found=0
	local s
	for s in ${_LLVM_COMPAT[@]} ; do
		which "${CHOST}-clang-${s}" || continue
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		export CPP="${CC} -E"
		strip-unsupported-flags
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to clang:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only clang slots ${LLVM_COMPAT[@]}"
eerror
		die
	fi
	if (( ${s} == 10 || ${s} == 11 || ${s} == 14 )) ; then
		:;
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_SLOT=${s}
	llvm-r1_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

check_libstdcxx() {
	local slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${slot}" ; then
eerror
eerror "You must switch to GCC ${slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
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

# Avoid /usr/include/bits/stdlib.h:86:3: error: "Assumed value of MB_LEN_MAX wrong" \
	check_libstdcxx ${GCC_SLOT}
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

	unpack ${P}.tar.gz
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
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local slot
	for slot in 6 5 4 ; do
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
	local exceptions=(
		"/usr/lib/${EPYTHON}/site-packages/Cython/Distutils/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0/Distutils/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3/Distutils/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/__pycache__"
	)
einfo "Adding sandbox rules"
	local path
	for path in ${exceptions[@]} ; do
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
		EPYTHON="${i/_/.}" add_sandbox_rules
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
