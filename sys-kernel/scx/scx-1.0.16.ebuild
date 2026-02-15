# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# For requirements, see https://github.com/sched-ext/scx/tree/v1.0.16?tab=readme-ov-file#build--install

ABSEIL_CPP_SLOT="20220623"
LLVM_COMPAT=( {19..22} )
PROTOBUF_CPP_SLOT="3"
RUST_MIN_VER="1.82.0"

inherit eapi9-ver abseil-cpp llvm-r2 linux-info cargo protobuf rust-toolchain toolchain-funcs meson

KEYWORDS="amd64"
SRC_URI="
${CARGO_CRATE_URIS}
https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
if [[ "${PKGBUMPING}" != "${PVR}" ]]; then
	SRC_URI+="
https://github.com/gentoo-crate-dist/scx/releases/download/v${PV}/scx-${PV}-crates.tar.xz
	"
fi

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	ISC
	MIT
	MPL-2.0
	Unicode-3.0
	ZLIB
"
SLOT="0"
IUSE="systemd"
DEPEND="
	>=dev-libs/libbpf-1.2.2
	dev-libs/libbpf:=
	sys-libs/libseccomp
	virtual/libelf:=
	virtual/zlib:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/bpftool-7.5.0
	app-misc/jq
	dev-libs/protobuf:3/3.21[protoc(+)]
	virtual/pkgconfig
	llvm_slot_19? (
		llvm-core/clang:19[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.86*
			=dav-lang/rust-1.85*
			=dav-lang/rust-1.84*
			=dav-lang/rust-1.83*
			=dav-lang/rust-1.82*
			=dav-lang/rust-bin-1.86*
			=dav-lang/rust-bin-1.85*
			=dav-lang/rust-bin-1.84*
			=dav-lang/rust-bin-1.83*
			=dav-lang/rust-bin-1.82*
		)
	)
	llvm_slot_20? (
		llvm-core/clang:20[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.90*
			=dav-lang/rust-1.89*
			=dav-lang/rust-1.88*
			=dav-lang/rust-1.87*
			=dav-lang/rust-bin-1.90*
			=dav-lang/rust-bin-1.89*
			=dav-lang/rust-bin-1.88*
			=dav-lang/rust-bin-1.87*
		)
	)
	llvm_slot_21? (
		llvm-core/clang:21[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-1.93*
			=dav-lang/rust-1.92*
			=dav-lang/rust-1.91*
			=dav-lang/rust-bin-1.93*
			=dav-lang/rust-bin-1.92*
			=dav-lang/rust-bin-1.91*
		)
	)
	llvm_slot_22? (
		llvm-core/clang:22[llvm_targets_BPF(-)]
		llvm-core/clang:=
		|| (
			=dav-lang/rust-9999*
			=dav-lang/rust-bin-9999*
		)
	)
	|| (
		dav-lang/rust:=
		dav-lang/rust-bin:=
	)
"

CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="
	/usr/bin/scx_loader
	/usr/bin/vmlinux_docify
	/usr/bin/scxctl
"

pkg_setup() {
	linux-info_pkg_setup
	llvm-r2_pkg_setup
	rust_pkg_setup

	local is_nightly=$("${RUSTC}" --version \
		| cut -f 2 -d " " \
		| grep -q -e "nightly")
	is_nightly=$(( ${is_nightly} ? 0 : 1 ))

	if use llvm_slot_22 ; then
		local rust_nightly_date=$("${RUSTC}" --version \
			| cut -f 4 -d " " \
			| sed -e "s|[)]||g" | sed -e "s|-||g")
		if ver_test "${rust_nightly_date}" "-lt" "20260127" ; then
	# From commit history of .gitmodules
eerror "Update Rust nightly to at least 2026-01-27"
			die
		fi
		if (( ${is_nightly} == 0 )) ; then
eerror "llvm_slot_22 requires Rust nightly"
			die
		fi
	fi
}

src_prepare() {
	default
	if tc-is-cross-compiler ; then
	# Inject the rust_abi value into install_rust_user_scheds
		sed -i -e "s;\${MESON_BUILD_ROOT};\${MESON_BUILD_ROOT}/$(rust_abi);" \
			"meson-scripts/install_rust_user_scheds" \
			|| die
	fi
}

src_configure() {
	abseil-cpp_src_configure
	protobuf_src_configure

	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"

	local emesonargs=(
		-Dbpf_clang="$(get_llvm_prefix)/bin/clang"
		-Dbpftool=disabled
		-Dlibbpf_a=disabled
		-Dcargo="${EPREFIX}/usr/bin/cargo"
		-Dcargo_home="${ECARGO_HOME}"
		-Doffline=true
		-Denable_rust=true
		-Dopenrc=disabled
		$(meson_feature systemd)
	)

	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_test() {
	cargo_env meson_src_test
}

src_install() {
	cargo_env meson_src_install

	dodoc "README.md"

	local readme readme_name
	for readme in "scheds/"{"rust","c"}"/"*"/README.md" "./rust/"*"/README.md" ; do
		[[ -e "${readme}" ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done

	newinitd "services/openrc/scx.initrd" "scx"
	insinto "/etc/default"
	doins "services/scx"
	dosym "../default/scx" "/etc/conf.d/scx"

	newinitd "${FILESDIR}/scx_loader.initd" "scx_loader"
	insinto "/etc/scx_loader/"
	newins "services/scx_loader.toml" "config.toml"
}

pkg_postinst() {
	if ver_replacing "-lt" "1.0.16" ; then
ewarn
ewarn "Starting in 1.0.16, the scx service is being replaced with scx_loader."
ewarn "To transition to the new service, first edit"
ewarn "${EPREFIX}/etc/scx_loader/config.toml with your preferred"
ewarn "configuration, then disable the legacy scx service and enable the new"
ewarn "scx_loader service:"
ewarn
ewarn "For openrc users:"
ewarn "  rc-service scx stop"
ewarn "  rc-update del scx default"
ewarn "  rc-service scx_loader start"
ewarn "  rc-update add scx_loader default"
ewarn
ewarn "For systemd users:"
ewarn "  systemctl disable --now scx"
ewarn "  systemctl enable --now scx_loader"
ewarn
ewarn "For more info, see:"
ewarn "https://wiki.cachyos.org/configuration/sched-ext/#transitioning-from-scxservice-to-scx_loader-a-comprehensive-guide"
ewarn
	fi
}
