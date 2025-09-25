# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

GCC_SLOT="11"
LLVM_COMPAT=( "17" )
STATUS="stable"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${PN}-godot-${PV}-${STATUS}"
SRC_URI="
https://github.com/godotengine/godot-cpp/archive/refs/tags/godot-${PV}-${STATUS}.tar.gz
	-> ${P}.tar.gz
"

inherit flag-o-matic

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
android debug fp64 web
ebuild_revision_12
"
# Consider relaxing the requirements.  The bindings are forwards compatibile, but not backwards compatible.
RDEPEND+="
	~dev-games/godot-editor-${PV}[fp64=]
	web? (
		>=dev-util/emscripten-3.1.39:17-3.1
	)
"
DEPEND+="
	${RDEPEND}
"
# Force GCC for portable builds.  Using the GCC default for U22.
BDEPEND+="
	sys-devel/gcc:${GCC_SLOT}
	web? (
		>=dev-build/cmake-3.16.3
	)
	>=dev-build/scons-4.0.0
	virtual/pkgconfig
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	unpack ${A}
}

generate_extension_api_json() {
	local x
	for x in $(seq 0 18) ; do
		addpredict "/dev/input/event${x}"
	done
	/usr/bin/godot${SLOT} \
		--headless \
		--dump-extension-api \
		|| die
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

build_linux() {
	local gcc_slot=$(gcc-config -l \
		| grep "*" \
		| cut -f 3 -d " ")
	gcc_slot="${gcc_slot##*-}"
	if ver_test ${gcc_slot} -ne "${GCC_SLOT}" ; then
# Avoid versioned symbols issues
eerror
eerror "GCC ${GCC_SLOT} required for portability."
eerror
eerror "You must do:"
eerror
eerror "eselect gcc set ${CHOST}-${GCC_SLOT}"
eerror "source /etc/profile"
eerror
		die
	fi
	export CC="${CHOST}-gcc-${GCC_SLOT}"
	export CXX="${CHOST}-g++-${GCC_SLOT}"
	export CPP="${CC} -E"
	strip-flags
	filter-lto
	local path="$(pwd)/extension_api.json"
	local configuration=$(usex debug "template_debug" "template_release")
	local precision=$(usex fp64 "double" "single")
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
einfo "abi:  ${abi}"
einfo "bitness:  ${bitness}"
einfo "libdir:  ${libdir}"
			scons \
				arch="${abi}" \
				bits=${bitness} \
				custom_api_file="${path}" \
				platform="linux" \
				precision="${precision}" \
				optimize="${OPTIMIZE_LEVEL}" \
				target="${configuration}" \
				verbose=yes \
				|| die
		fi
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
	# We want to use optimize=custom but you cannot set the CFLAGS yet and the build system is too hermetic.
	# It would require build scripts changes to apply custom {C,CXX,LD}FLAGS.
	local olast=$(get_olast)
	if [[ "${olast}" =~ ("-O3"|"-O4"|"-Ofast") ]] ; then
		OPTIMIZE_LEVEL="speed"
	elif [[ "${olast}" == "-O2" ]] ; then
		OPTIMIZE_LEVEL="speed_trace"
	elif [[ "${olast}" =~ ("-Os"|"-Oz") ]] ; then
		OPTIMIZE_LEVEL="size"
	elif [[ "${olast}" == "-Og" ]] ; then
		OPTIMIZE_LEVEL="debug"
	elif [[ "${olast}" == "-O1" ]] ; then
	# There is no -O1 in build script so use -O2 for hardened compilers to prevent _FORTIFY_SOURCE issues.
		OPTIMIZE_LEVEL="speed_trace"
	else
		OPTIMIZE_LEVEL="none"
	fi
	export OPTIMIZE_LEVEL
	filter-flags '-O*'
}

src_compile() {
	generate_extension_api_json
	build_android
	build_linux
	build_web
}

get_libdir2() {
	local abi="${1}"
	local t="LIBDIR_${abi}"
	echo "${!t}"
}

install_linux() {
	# We don't install it to the /usr prefix because the headers may be different per Godot slot.
	local configuration=$(usex debug "template_debug" "template_release")
	local configuration2=$(usex debug "debug" "release")
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
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration2}-${abi}/${libdir}"
			doins "bin/libgodot-cpp.linux.${configuration}.${abi}.a"
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration2}-${abi}"
			doins -r "include"
cat <<EOF > "${T}/godot-cpp.pc" || die
prefix=/usr/lib/godot-cpp/${SLOT}/linux-${configuration2}-${abi}
exec_prefix=\${prefix}
libdir=\${prefix}/${libdir}
includedir=\${prefix}/include

Name: godot-cpp
Description: C++ bindings for Godot Engine GDExtension API
Version: ${PV}
Libs: -L\${libdir} -lgodot-cpp.linux.${configuration}.${abi}
Cflags: -I\${includedir}
Requires:
EOF
			insinto "/usr/lib/godot-cpp/${SLOT}/linux-${configuration2}-${abi}/${libdir}/pkgconfig"
			doins "${T}/godot-cpp.pc"
		fi
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
