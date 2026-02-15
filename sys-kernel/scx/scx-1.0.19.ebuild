# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# For requirements, see https://github.com/sched-ext/scx/tree/v1.0.19?tab=readme-ov-file#build--install

LLVM_COMPAT=( {19..22} )
RUST_MIN_VER="1.82.0"

inherit cargo llvm-r2 linux-info

KEYWORDS="~amd64"
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
	dev-libs/protobuf[protoc(+)]
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
PDEPEND="
	~sys-kernel/scx-loader-${PV}
	sys-kernel/scx-loader:=
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

QA_PREBUILT="/usr/bin/vmlinux_docify"

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

src_compile() {
einfo "Building rust schedulers"
	cargo_src_compile

einfo "Building C schedulers"
	emake BPF_CLANG="$(get_llvm_prefix)/bin/clang"
}

src_install() {
einfo "Installing rust schedulers"
	local sched
	for sched in "scheds/rust/scx_"* ; do
einfo "Installing ${sched#scheds/rust/}"
		local configuration=$(usex debug "debug" "release")
		dobin "target/${configuration}/${sched#scheds/rust}"
	done

einfo "Installing C schedulers"
	emake INSTALL_DIR="${ED}/usr/bin" install

einfo "Installing tools"
	local configuration=$(usex debug "debug" "release")
	dobin "target/${configuration}/"{"scx"{"cash","top"},"vmlinux_docify"}

	dodoc "README.md"

	local readme readme_name
	for readme in "scheds/"{"rust","c"}"/"*"/README.md" "./rust/"*"/README.md" ; do
		[[ -e "${readme}" ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}
