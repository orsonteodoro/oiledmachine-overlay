# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# See godot-editor for additional hardening comments
# Hardening is applied to protect password code paths.
# There is an open_encrypted_with_pass() API that these bindings makes available.
CFLAGS_HARDENED_USE_CASES="network server sensitive-data untrusted-data"
CFLAGS_HARDENED_VTABLE_VERIFY=1
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX14[@]}
)
LLVM_COMPAT=( "17" )
STATUS="stable"

GODOT_PN="godot"
GODOT_PV="3.6.1"
GODOT_P="${GODOT_PN}-${GODOT_PV}"
EGIT_COMMIT="07153d40e0e5c25de1fd2d00da3a1669e7ea7e64"
#GODOT_HEADERS_COMMIT="1049927a596402cd2e8215cd6624868929f5f18d"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
SRC_URI="
https://github.com/godotengine/godot-cpp/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
"
if [[ -n "${GODOT_HEADERS_COMMIT}" ]] ; then
# Repo source as a submodule of godot-cpp
	SRC_URI+="
https://github.com/godotengine/godot-headers/archive/${GODOT_HEADERS_COMMIT}.tar.gz
	-> godot-headers-${GODOT_HEADERS_COMMIT:0:7}.tar.gz
	"
else
# The Godot latest for 3.6.1 in the 3.x series.
	SRC_URI+="
https://github.com/godotengine/${GODOT_PN}/archive/${GODOT_PV}-${STATUS}.tar.gz -> ${GODOT_P}.tar.gz
	"
fi

inherit cflags-hardened flag-o-matic libstdcxx-slot virtualx

DESCRIPTION="C++ bindings for the Godot script API"
HOMEPAGE="
	https://github.com/godotengine/godot-cpp
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="$(ver_cut 1-2)"
IUSE+="
android +debug-export-template-plugin -debug-game-engine web
ebuild_revision_19
"
# Consider relaxing the requirements.  The bindings are forwards compatibile, but not backwards compatible.
RDEPEND+="
	!debug-game-engine? (
		~dev-games/godot-editor-${GODOT_PV}[-debug,gdnative]
	)
	debug-game-engine? (
		~dev-games/godot-editor-${GODOT_PV}[debug,gdnative]
	)
	web? (
		>=dev-util/emscripten-3.1.38:17-3.1
	)
"
DEPEND+="
	${RDEPEND}
"
# Force GCC for portable builds.  Using the GCC default for U20.
BDEPEND+="
	web? (
		>=dev-build/cmake-3.16.3
	)
	>=dev-build/scons-4.0.0
	virtual/pkgconfig
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/godot-cpp-3.6.20240724-07153d4-env-changes.patch"
)

pkg_setup() {
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/godot-headers"
	if [[ -n "${GODOT_HEADERS_COMMIT}" ]] ; then
		mv \
			"${WORKDIR}/godot-headers-${GODOT_HEADERS_COMMIT}" \
			"${S}/godot-headers" \
			|| die
		if [[ ! -f "${S}/godot-headers/api.json" ]] ; then
eerror "Missing ${S}/godot-headers/api.json"
			die
		fi
	else
		mv \
			"${WORKDIR}/${GODOT_P}-${STATUS}/modules/gdnative" \
			"${S}/godot-headers" \
			|| die
	fi
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast|g)" \
		| tr " " "\n" \
		| tail -n 1)
	echo "${olast}"
}

src_configure() {
	# Assumes glibc for prebuilt templates
	use elibc_musl && die "musl is not currently supported.  Fork ebuild."
}

# Currently broken and hangs
generate_api_json() {
	local x
	for x in $(seq 0 18) ; do
		addpredict "/dev/input/event${x}"
	done
	virtx /usr/bin/godot${SLOT} \
		-q \
		--audio-driver 'Dummy' \
		--gdnative-generate-json-api \
		api.json \
		|| die
einfo "Generate api.json done"
}

build_android() {
# TODO: Update CC, CXX, CPP
	if use android ; then
ewarn "USE=android is untested"
		strip-flags
		filter-lto
		scons \
			platform=android \
			custom_api_file="${path}" \
			|| die
	fi
}

_build_target_linux() {
	local target="${1}"
	local dev_build
	local debug_symbols
	if [[ "${target}" == "release" ]] ; then
		dev_build="False"
		debug_symbols="False"
	elif [[ "${target}" == "debug" ]] ; then
	# For target=debug:
	# If dev_build=True, -O2 + debug engine off + additional debug paths and reporting.
	# If dev_build=False -O0 + debug engine on + additional debug paths and reporting.
		dev_build=$(usex debug-game-engine "True" "False")
		debug_symbols="True"
	fi
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-flags
	filter-lto
	cflags-hardened_append
	local path="${S}/godot-headers/api.json"
	declare -A ABI_MAP=(
		["amd64"]="x86_64"
		["x86"]="x86_32"
		["arm"]="arm32"
		["arm64"]="arm64"
		["riscv"]="rv64"
		["ppc"]="ppc32"
		["ppc64"]="ppc64"
	)
	declare -A BITNESS_MAP=(
		["amd64"]="64"
		["x86"]="32"
		["arm"]="32"
		["arm64"]="64"
		["riscv"]="64"
		["ppc"]="32"
		["ppc64"]="64"
	)
	declare -A LIB_MAP=()
	LIB_MAP["amd64"]=$(get_libdir2 "amd64")
	LIB_MAP["x86"]=$(get_libdir2 "x86")
	LIB_MAP["arm"]=$(get_libdir2 "arm")
	LIB_MAP["arm64"]=$(get_libdir2 "arm64")
	LIB_MAP["riscv"]=$(get_libdir2 "riscv")
	LIB_MAP["ppc"]=$(get_libdir2 "ppc")
	LIB_MAP["ppc64"]=$(get_libdir2 "ppc64")
	local ALL_ARCHES=(
		"amd64"
		"x86"
		"arm"
		"arm64"
		"riscv"
		"ppc"
		"ppc64"
	)
	local x
	for x in ${ALL_ARCHES[@]} ; do
		if [[ "${MULTILIB_ABIS}" =~ (^|" ")"${x}"($|" ") ]] ; then
einfo "Building bindings for ${x}"
			local libdir="${LIB_MAP[${x}]}"
			local abi="${ABI_MAP[${x}]}"
			local bitness="${BITNESS_MAP[${x}]}"
			local extra_conf=()
			if [[ -n "${CCACHE_DIR}" ]] ; then
				extra_conf=(
					c_compiler_launcher="ccache"
					cpp_compiler_launcher="ccache"
				)
			fi
einfo "abi:  ${abi}"
einfo "bitness:  ${bitness}"
einfo "libdir:  ${libdir}"
			scons \
				arch="${abi}" \
				bits=${bitness} \
				custom_api_file="${path}" \
				debug_symbols="${debug_symbols}" \
				dev_build="${dev_build}" \
				platform="linux" \
				optimize="custom" \
				target="${target}" \
				use_custom_api_file="yes" \
				"CFLAGS=${CFLAGS}" \
				"CXXFLAGS=${CXXFLAGS}" \
				"LINKFLAGS=${LDFLAGS}" \
				verbose=yes \
				${extra_conf[@]} \
				|| die
		fi
	done
}

build_linux() {
	local targets=(
		"debug"
		"release"
	)
	local target
	for target in ${targets[@]} ; do
		if [[ "${target}" == "debug" ]] && ! use debug-export-template-plugin ; then
			continue
		fi
		_build_target_linux "${target}"
	done
}

build_web() {
# TODO: Test
	export CC="emcc"
	export CXX="em++"
	unset CPP
	unset LD
	strip-flags
	filter-lto
	if use web ; then
ewarn "USE=web is untested"
		scons \
			platform=web \
			custom_api_file="${path}" \
			|| die
	fi
}

src_compile() {
	if ! [[ -n "${GODOT_HEADERS_COMMIT}" ]] ; then
		generate_api_json
	fi
#	build_android
	build_linux
#	build_web
}

get_libdir2() {
	local abi="${1}"
	local t="LIBDIR_${abi}"
	echo "${!t}"
}

_install_target_linux() {
	# We don't install it to the /usr prefix because the headers may be different per Godot slot.
	local target="${1}"
	local target2="export template plugin"
	local target3="export-template-plugin"
	local configuration
	if [[ "${target}" == "release" ]] ; then
		configuration="release"
	elif [[ "${target}" == "debug" ]] ; then
		configuration="debug"
	fi
	declare -A ABI_MAP=(
		["amd64"]="x86_64"
		["x86"]="x86_32"
		["arm"]="arm32"
		["arm64"]="arm64"
		["riscv"]="rv64"
		["ppc"]="ppc32"
		["ppc64"]="ppc64"
	)
	declare -A BITNESS_MAP=(
		["amd64"]="64"
		["x86"]="32"
		["arm"]="32"
		["arm64"]="64"
		["riscv"]="64"
		["ppc"]="32"
		["ppc64"]="64"
	)
	declare -A LIB_MAP=()
	LIB_MAP["amd64"]=$(get_libdir2 "amd64")
	LIB_MAP["x86"]=$(get_libdir2 "x86")
	LIB_MAP["arm"]=$(get_libdir2 "arm")
	LIB_MAP["arm64"]=$(get_libdir2 "arm64")
	LIB_MAP["riscv"]=$(get_libdir2 "riscv")
	LIB_MAP["ppc"]=$(get_libdir2 "ppc")
	LIB_MAP["ppc64"]=$(get_libdir2 "ppc64")
	local ALL_ARCHES=(
		"amd64"
		"x86"
		"arm"
		"arm64"
		"riscv"
		"ppc"
		"ppc64"
	)
	local x
	for x in ${ALL_ARCHES[@]} ; do
		if [[ "${MULTILIB_ABIS}" =~ (^|" ")"${x}"($|" ") ]] ; then
einfo "Installing bindings for ${x}"
			local libdir="${LIB_MAP[${x}]}"
			local abi="${ABI_MAP[${x}]}"
			local bitness="${BITNESS_MAP[${x}]}"
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration}-${abi}/${libdir}"
			doins "bin/libgodot-cpp.linux.${target}.${bitness}.a"
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration}-${abi}"
			doins -r "include"
cat <<EOF > "${T}/godot-cpp-${target3}.pc" || die
prefix=/usr/lib/godot-cpp/${SLOT}/linux-${configuration}-${abi}
exec_prefix=\${prefix}
libdir=\${prefix}/${libdir}
includedir=\${prefix}/include

Name: godot-cpp-${target3}
Description: C++ ${target2} bindings for Godot Engine GDNative API
Version: ${PV}
Libs: -L\${libdir} -lgodot-cpp.linux.${target}.${bitness}
Cflags: -I\${includedir}
Requires:
EOF
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration}-${abi}/${libdir}/pkgconfig"
			doins "${T}/godot-cpp-${target3}.pc"
		fi
	done
}

install_linux() {
	local targets=(
		"debug"
		"release"
	)
	local target
	for target in ${targets[@]} ; do
		if [[ "${target}" == "debug" ]] && ! use debug-export-template-plugin ; then
			continue
		fi
		_install_target_linux "${target}"
	done
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE.md"
	install_linux
# TODO web
# TODO android
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
