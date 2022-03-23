# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR=ninja
inherit cmake linux-info llvm multilib-build python-any-r1

DESCRIPTION="A superoptimizer for LLVM IR"
HOMEPAGE="https://github.com/google/souper"
LICENSE="Apache-2.0
	BSD
	MIT
	UoI-NCSA
"
# Third party licenses:
# klee - UoI-NCSA, BSD
# alive2 - MIT
# llvm-project-disable-peepholes (see llvm ebuilds) - Apache-2.0-with-LLVM-exceptions

# No KEYWORDS for live ebuilds (or snapshotted ones)

SLOT="0"
IUSE+=" doxygen gdb support-tools test"
# U 20.04
# See also
# https://github.com/google/souper/blob/69536e134478ae1d44c912c90c3db96ad06437c1/Dockerfile
# https://github.com/google/souper/blob/69536e134478ae1d44c912c90c3db96ad06437c1/build_deps.sh
LLVM_SLOTS=(15 14 13 12)
gen_iuse() {
	local s
	local o
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}
		"
	done
	echo "${o}"
}
IUSE+=" $(gen_iuse)"
# Both assertions (debug) and dump are default ON upstream,
# but in the distro, both are OFF for the llvm package by default.
IUSE+=" -debug -dump +external-cache openrc tcp usockets r6"
REQUIRED_USE+="
	|| ( $(gen_iuse) )
	external-cache? ( ^^ ( tcp usockets ) openrc )
	openrc? ( external-cache )
	support-tools? ( external-cache )
"
gen_rdepends() {
	local s
	local o
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}? (
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP},debug?,dump?,souper]
				>=sys-devel/lld-${s}
			)
		"
	done
	echo "${o}"
}
RDEPEND+="
	|| ( $(gen_rdepends) )
	>=dev-lang/perl-5.30.0
	>=dev-libs/gmp-6.2.0[${MULTILIB_USEDEP}]
	>=dev-util/re2c-1.3
	>=sci-mathematics/z3-4.8.11.0[${MULTILIB_USEDEP}]
	gdb? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'sys-devel/gdb[${PYTHON_USEDEP}]')
	)
	external-cache? (
		>=dev-libs/hiredis-1.0.1[${MULTILIB_USEDEP},static-libs]
		>=dev-db/redis-5.0.7
	)
"
DEPEND+="
	${DEPEND}
"
# Referenced packages but not used
# >=app-misc/ca-certificates-20210119
# >=dev-vcs/git-2.25.1
# >=dev-vcs/subversion-1.13.0
BDEPEND+="
	|| ( $(gen_rdepends) )
	>=dev-util/cmake-3.16.3
	>=dev-util/ninja-1.1.0
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.16.1
	>=sys-devel/libtool-2.4.6
	>=sys-devel/gcc-10.3.0
	>=sys-devel/make-4.2.1
	virtual/libc
	doxygen? ( >=app-doc/doxygen-1.8.17 )
	test? (
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.10.0[${MULTILIB_USEDEP}]
		>=dev-lang/perl-5.30.0
		>=dev-lang/python-3.8.2
		>=dev-python/lit-10
		>=dev-util/valgrind-3.15.0
	)
"
EGIT_COMMIT="69536e134478ae1d44c912c90c3db96ad06437c1"
EGIT_COMMIT_KLEE="0ba95edbad26fe70c8132f0731778d94f9609874" # HEAD (Jan 7, 2022) as obtained from Feb 8, 2022.
ALIVE2_PV="2"
# Prefetch tarballs to speed up rebuilds
# Track
# https://github.com/rsas/klee/commits/pure-bv-qf-llvm-7.0
# for newer pure-bv-qf-llvm-7.0
SRC_URI="
https://github.com/google/souper/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/klee/klee/archive/0ba95edbad26fe70c8132f0731778d94f9609874.tar.gz
	-> klee-${EGIT_COMMIT_KLEE:0:7}.tar.gz
https://github.com/manasij7479/alive2/archive/refs/tags/v${ALIVE2_PV}.tar.gz
	-> manasij7479-alive2-v${ALIVE2_PV}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-9999_pre20210629-use-system-packages.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-install.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-klee-header-paths-for-klee-0ba95ed.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm13-compat.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-disable-llvm-version-change.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-constraintmanager-klee-0ba95ed.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-KLEEBuilder-use-arraycache.patch"
	#"${FILESDIR}/temp-disable.patch"							# didn't build llvm with disable-peephole patch yet
	"${FILESDIR}/${PN}-9999_pre20210629-optional-redis.patch"
	"${FILESDIR}/alive2-v2-disable-unused-variables.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm-version-get-and-define.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm-dump-optional.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-use-clang-monolithic-lib.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-report_fatal_error-changes-llvm14rc1.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-optimizationlevel-llvm14rc1.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-check-stdcxx20-flag.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-custom-docs-prefix.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-use-ccache.patch"
	"${FILESDIR}/alive2-v2-change-saturate-operations.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-optional-tests.patch"
)
MIN_CXX="20"

pkg_setup()
{
	ewarn "This ebuild is a Work In Progress (WIP) and is incomplete."
	if use llvm-15 ; then
		ewarn "LLVM 15 has not been compile time tested."
	fi
	if use test ; then
		ewarn "The test USE flag has not been tested."
	fi
	ewarn "This package with compatibility patches has not been unit tested yet."
	python-any-r1_pkg_setup

	if use external-cache ; then
		if use usockets ; then
			CONFIG_CHECK="~NET ~UNIX"
		else
			CONFIG_CHECK="~NET ~INET ~IPV6"
		fi
		linux-info_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
	mkdir -p "${S}/third_party" || die
	mv "${WORKDIR}/klee-${EGIT_COMMIT_KLEE}" "${S}/third_party/klee" || die
	mv "${WORKDIR}/alive2-${ALIVE2_PV}" "${S}/third_party/alive2" || die
}

src_prepare() {
	cmake_src_prepare
	pushd "${S}/third_party/klee" || die
		# Most commits have been upstreamed or a better commit provided.
		local KLEE_RSAS_PURE_BV_QF=(
			"${FILESDIR}/0000_klee_rsas_pure-bv-qf-llvm-7.0.patch"
		)
		eapply ${KLEE_RSAS_PURE_BV_QF[@]}
	popd
	if ! use external-cache ; then
		sed -i -e "s|USE_EXTERNAL_CACHE=1|USE_EXTERNAL_CACHE=0|g" \
			"${S}/utils/sclang.in" || die
	fi

	_prepare_abi() {
		for s in ${LLVM_SLOTS[@]} ; do
			if use "llvm-${s}" ; then
				local souper_build_dir="${WORKDIR}/${P}_llvm${s}_${ABI}_build"
				cp -a "${S}" "${souper_build_dir}" || die
			fi
		done
	}
	multilib_foreach_abi _prepare_abi
}

src_configure() { :; }

_configure_compiler() {
	# Make sure the bitcode is the same or highest especially if LTOing.
	local clang_v_maj=$(ver_cut 1 $(best_version "sys-devel/clang:${s}" | sed -e "s|sys-devel/clang-||"))
	local lld_v_maj=$(ver_cut 1 $(best_version "sys-devel/lld" | sed -e "s|sys-devel/lld-||"))
	export CC="clang-${s} $(get_abi_CFLAGS ${ABI})"
	export CXX="clang++-${s} $(get_abi_CFLAGS ${ABI})"
	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
	has_version "sys-devel/clang:${s}" || die
	v_major_lld=$(ver_cut 1 "${v_major_lld}")
	PATH=$(echo "${PATH}" | tr ":" "\n" | sed -e "/llvm/d" | tr "\n" ":" | sed -e 's|:$||')
	export PATH="${PATH}:$(get_llvm_prefix ${clang_v_maj})/bin:$(get_llvm_prefix ${lld_v_maj})/bin"
	einfo "PATH=${PATH}"
	test-flags-CXX "-std=c++${MIN_CXX}" 2>/dev/null 1>/dev/null \
		|| die "You cannot use the llvm-${s} USE flag because ${CXX} is not c++${MIN_CXX} compatible."
}

_configure_souper() {
	if (( ${s} != 12 )) ; then
ewarn
ewarn "Compatibility with LLVM ${s} is experimental.  Use the llvm-12 USE flag"
ewarn
	fi
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doxygen)
		-DBUILD_TESTS=$(usex test)
		-DCLANG_INCLUDE_DIR="/usr/lib/llvm/${s}/include/clang"
		-DCMAKE_INSTALL_BINDIR="bin"
		-DCMAKE_INSTALL_DATAROOTDIR="/usr/share"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DCMAKE_INSTALL_PREFIX="/usr/lib/souper/${s}"
		-DCMAKE_INSTALL_DOCS="/usr/share/doc/${P}"
		-DCMAKE_INSTALL_RUNSTATEDIR="/var/run"
		-DSYSTEM_LIB_PATH="/usr/$(get_libdir)"
		-DEXTERNAL_CACHE_SOCK_PATH="/run/souper/${PN}-${ABI}.sock"
		-DFEATURE_EXTERNAL_CACHE=$(usex external-cache)
		-DINSTALL_GDB_PRETTY_PRINT=$(usex gdb)
		-DINSTALL_SUPPORT_TOOLS=$(usex support-tools)
		-DLLVM_CONFIG_PATH="/usr/lib/llvm/${s}/bin/${CHOST}-llvm-config"
		-DTEST_SYNTHESIS=$(usex test)
	)
	cmake_src_configure
}

build_alive2() {
	einfo "Building internal dep alive"
	local mycmakeargs=(
		-DZ3_INCLUDE_DIR="/usr/include"
		-DZ3_LIBRARIES="/usr/$(get_libdir)/libz3.so"
	)
	export CMAKE_USE_DIR="${souper_build_dir}/third_party/alive2"
	export BUILD_DIR="${souper_build_dir}/third_party/alive2-build"
	pushd "${CMAKE_USE_DIR}" || die
		git init || die
		touch dummy.txt || die
		git config --local user.email "you@example.com"
		git config --local user.name "John Doe"
		git add dummy.txt || die
		git commit -m "alive2 v${ALIVE2_PV}" || die
		git tag v${ALIVE2_PV} || die
	popd
	cmake_src_configure
	cmake_src_compile
}

src_compile() {
	_compile_abi() {
		for s in ${LLVM_SLOTS[@]} ; do
			if use "llvm-${s}" ; then
				local souper_build_dir="${WORKDIR}/${P}_llvm${s}_${ABI}_build"
				einfo "LLVM ${s}, ${ABI}"
				_configure_compiler
				build_alive2
				export CMAKE_USE_DIR="${souper_build_dir}"
				export BUILD_DIR="${souper_build_dir}"
				_configure_souper
				cmake_src_compile
			fi
		done
	}
	multilib_foreach_abi _compile_abi
}

_gen_template_tcp() {
	local fn="${PN}-tcp-${ABI}.conf"
	cat <<EOF > "${T}/${fn}"
port ${tcp_port}
bind 127.0.0.1 -::1
protected-mode yes
dir /var/lib/${PN}/
unixsocketperm 700
timeout 0
dbfilename ${PN}-${ABI}.rdb
pidfile /run/souper/${PN}-${ABI}.pid.dummy
EOF
	insinto /etc/souper
	doins "${T}/${fn}"
}

_gen_template_usockets() {
	local fn="${PN}-usockets-${ABI}.conf"
	cat <<EOF > "${T}/${fn}"
port 0
unixsocket /run/souper/${PN}-${ABI}.sock
dir /var/lib/${PN}/
unixsocketperm 700
timeout 0
dbfilename ${PN}-${ABI}.rdb
pidfile /run/souper/${PN}-${ABI}.pid.dummy
EOF
	insinto /etc/souper
	doins "${T}/${fn}"
}


_gen_openrc_conf_d() {
	local fn="${PN}"
	cat <<EOF > "${T}/${fn}"
# Extra options
SOUPER_OPTS=""

# For Redis bind in the .conf
rc_need="net.lo"

# Can be TCP or USOCKETS
SOUPER_IPC_MODE="${SOUPER_IPC_MODE}"

SOUPER_TCP_PORTS="
${SOUPER_TCP_PORTS}
"

SOUPER_USOCK_FILES="
${SOUPER_USOCK_FILES}
"

SOUPER_CONFIGS="
${SOUPER_CONFIGS}
"
EOF
	insinto /etc/conf.d
	doins "${T}/${fn}"
}

_gen_openrc_init_d() {
	local fn="${PN}"
	mkdir -p "${T}/init.d" || die
	cat "${FILESDIR}/init.d/${fn}.in" \
		> "${T}/init.d/${fn}" || die
	sed -i \
		-e "s|___SOUPER_IPC_MODE___|${SOUPER_IPC_MODE}|" \
		-e "s|___SOUPER_TCP_PORTS___|${SOUPER_TCP_PORTS}|" \
		-e "s|___SOUPER_USOCK_FILES___|${SOUPER_USOCK_FILES}|" \
		-e "s|___SOUPER_CONFIGS___|${SOUPER_CONFIGS}|" \
		"${T}/init.d/${fn}" || die
	exeinto /etc/init.d
	doexe "${T}/init.d/${fn}"
}

src_install() {
	local s_max=0
	local socket_start="${SOCKET_START:-6379}"
	local tcp_port=${socket_start}
	SOUPER_TCP_PORTS=""
	SOUPER_USOCK_FILES=""
	SOUPER_CONFIGS=""
	SOUPER_IPC_MODE=""
	if use tcp ; then
		SOUPER_IPC_MODE="TCP"
	elif use usockets ; then
		SOUPER_IPC_MODE="USOCKETS"
	fi
	_install_abi() {
		for s in ${LLVM_SLOTS[@]} ; do
			if use "llvm-${s}" ; then
				local souper_build_dir="${WORKDIR}/${P}_llvm${s}_${ABI}_build"
				export BUILD_DIR="${souper_build_dir}"
				cmake_src_install
				dosym /usr/lib/souper/${s}/bin/sclang /usr/bin/sclang-${s}
				dosym /usr/lib/souper/${s}/bin/sclang++ /usr/bin/sclang++-${s}
				(( ${s} > ${s_max} )) && s_max=${s}

				if use usockets ; then
					_gen_template_usockets
					SOUPER_USOCK_FILES+=" ${ABI}:/run/souper/${PN}-${ABI}.sock"
					SOUPER_CONFIGS+=" ${ABI}:/etc/${PN}/${PN}-usockets-${ABI}.conf"
				elif use tcp ; then
					_gen_template_tcp
					SOUPER_TCP_PORTS+=" ${ABI}:${tcp_port}"
					SOUPER_CONFIGS+=" ${ABI}:/etc/${PN}/${PN}-tcp-${ABI}.conf"
					tcp_port=$((${tcp_port} + 1))
				fi
			fi
		done
	}
	multilib_foreach_abi _install_abi

	einfo "sclang defaults to highest slot LLVM ${s_max}"
	dosym /usr/lib/souper/${s_max}/bin/sclang /usr/bin/sclang
	dosym /usr/lib/souper/${s_max}/bin/sclang++ /usr/bin/sclang++

	if ! use external-cache ; then
		cat <<-EOF > "${T}"/50${P}-external-cache
			SOUPER_NO_EXTERNAL_CACHE=1
		EOF
		doenvd "${T}"/50${P}-external-cache
	fi
	dodoc LICENSE
	dodir /var/lib/souper
	fowners portage:portage /var/lib/souper

	if use openrc ; then
		_gen_openrc_conf_d
		_gen_openrc_init_d
	fi
	fowners -R portage:portage /etc/souper
}

src_test() {
	for s in ${LLVM_SLOTS[@]} ; do
		local souper_build_dir="${WORKDIR}/${P}_llvm${s}_${ABI}_build"
		einfo "Running tests for ${PN} linked to LLVM ${s}"
		export SOUPER_UTILS_MODE=1 # Set to testing mode
		export BUILD_DIR="${souper_build_dir}"
		cd "${BUILD_DIR}" || die
		./run_lit || die
	done
}

pkg_postinst() {
	env-update
	if use external-cache ; then
		for abi in ${MULTILIB_ABIS} ; do
			local native_db_path="/var/lib/souper/souper-${abi}.rdb"
			if [[ -e "/usr/sbin/redis-server" && -e "${native_db_path}" ]] ; then
				local redis_v=$(/usr/sbin/redis-server --version | cut -f 3 -d " " | sed -e "s|v=||g")
				local redis_db_v=$(/usr/sbin/redis-check-rdb ${native_db_path} | grep "redis-ver" | cut -f 2 -d "'")
				if ver_test ${redis_v} -ne ${redis_db_v} ; then
					# TODO: put mutex around this because the possibility of parallel emerges.
					ewarn "Removing incompatible external cache"
					rm "${native_db_path}" || die
				else
					ewarn "Reusing external cache for ${abi}"
					chown portage:portage "${native_db_path}" || die
				fi
			fi
		done
		chown portage:portage /var/lib/souper || die
ewarn
ewarn "The redis server should be listening in port 6379 if communicating with"
ewarn "Redis through TCP but may be changed.  The TCP interface has not been"
ewarn "tested but Redis communicating with UNIX sockets with Souper has been"
ewarn "tested working."
ewarn
	fi
einfo
einfo "See \`epkginfo -x sys-devel/souper\` or"
einfo "https://github.com/google/souper#using-souper"
einfo "for usage details."
einfo
}
