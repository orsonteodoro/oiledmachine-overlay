# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# We use the upstream lockfiles for both pnpm and cargo.
# Assuming frequent ebuild updates.

# This ebuild uses AI generated code.

# Rust 1.95.0

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# PNPM_UPDATER_VERSIONS="52.0.0" pnpm_updater_update_locks.sh

MY_PN="vercel"
MY_P="${MY_PN}-${PV}"

NODE_SLOT="24" # Based on https://github.com/vercel/vercel/blob/vercel%4056.5.0/.github/workflows/release.yml
PNPM_SLOT="9"
PNPM_TARBALL="${MY_P}.tar.gz"
RUST_MAX_VER="1.95.0" # Inclusive
RUST_MIN_VER="1.95.0" # llvm-22.1
RUST_PV="${RUST_MIN_VER}"
RUST_EXPECTED_TIMESTAMP=20260414 # Same as 1.95.0 release date

LLVM_SLOT=22
LLVM_COMPAT=( ${LLVM_SLOT} )

PNPM_AUDIT_FIX_ARGS=(
)

PNPM_INSTALL_ARGS=(
)

inherit flag-o-matic pnpm rust

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="fabae940acf33ca050f0767d3d5dadc61fcffe32"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/vercel/vercel.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
https://github.com/vercel/vercel/archive/refs/tags/vercel@${PV}.tar.gz
	-> ${MY_P}.tar.gz
	"
fi

S="${WORKDIR}/${MY_PN}-${MY_PN}-${PV}"

DESCRIPTION="Vercel CLI"
HOMEPAGE="
	https://github.com/vercel/vercel
	https://vercel.com/docs/cli
"
LICENSE="
	Apache-2.0
	Vercel-Legal
	Vercel-Privacy-Policy
"
KEYWORDS="~amd64"
IUSE+=" ebuild_revision_11"
SLOT="0"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-util/rustup
	dev-vcs/git
	net-libs/nodejs:${NODE_SLOT}
	llvm-core/clang:${LLVM_SLOT}
	llvm-core/llvm:${LLVM_SLOT}
	llvm-core/lld:${LLVM_SLOT}
	sys-apps/pnpm:${PNPM_SLOT}
	|| (
		dev-lang/rust-bin:${RUST_PV}
		dev-lang/rust:${RUST_PV}
	)
	|| (
		dev-lang/rust-bin:=
		dev-lang/rust:=
	)
"
RESTRICT="mirror"

verify_rust() {
	if "${RUSTC}" --version | grep -q "nightly" ; then
		local actual_timestamp=$(rustc --version | cut -f 4 -d " " | sed -e "s|)||g" | sed -e "s|-||g")
		local expected_timestamp=${RUST_EXPECTED_TIMESTAMP}
		if (( ${current_timestamp} < ${expected_timestamp} )) ; then
eerror "You need to re-emerge =dev-lang/rust-bin-9999 or =dev-lang/rust"
eerror "Actual timestamp:  ${actual_timestamp}"
eerror "Expected timestamp:  >= ${expected_timestamp}"
			die
		fi
	fi
}

pkg_setup() {
	# Reduce downloads for frequently versioned bumped releases.
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${PN}-${PV%%.*}"

	export TURBO_TELEMETRY_DISABLED=1
	export DO_NOT_TRACK=1
	pnpm_pkg_setup
	rust_pkg_setup
	verify_rust
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		pnpm_src_unpack
	else
		pnpm_src_unpack
	fi
}

src_configure() {
	export TURBO_TELEMETRY_DISABLED=1
	export DO_NOT_TRACK=1

	export PATH="/usr/lib/llvm/${LLVM_SLOT}/bin:${PATH}"
# Prevent
# note: gcc: error: unrecognized command-line option '--target=wasm32-wasip2'
	export CC="${CHOST}-clang-22" # Same as Rust's 1.95.0 LLVM slot
	export CXX="${CHOST}-clang++-22"
	export CPP="${CC} -E"
	unset LD
	filter-flags "-fuse-ld=*"

	rustup-init-gentoo -s || die
	export PATH="${HOME}/.cargo/bin:${PATH}"
	"${RUSTC}" --version || die

	filter-flags "-fuse-ld=*"
	append-flags "-fuse-ld=lld"

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "LD:  ${LD}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
}

src_compile() {
	pnpm_hydrate
	epnpm --version
	epnpm "build"
}

sanitize_file_permissions() {
	einfo "Sanitizing file/folder permissions in ${ED}"

	# 1. Set ownership once (very fast)
	find "${ED}" ! -type l -exec chown root:root {} + || die "chown failed"

	# 2. All directories get 0755
	find "${ED}" -type d -exec chmod 0755 {} + || die "chmod directories failed"

	# 3. All regular files start as 0644 (this is the safe default)
	find "${ED}" -type f -exec chmod 0644 {} + || die "chmod files to 0644 failed"

	# 4. Make executables 0755 - Fast + targeted for node_modules/.bin
	find "${ED}" -type f \( \
		-path "*/.bin/*" -o \
		-name "*.sh" -o \
		-name "*.bash" -o \
		-name "*.node" -o \
		-name "*.so" -o \
		-regex '.*/*.so\.[0-9.]+' -o \
		-name "*.py" -o \
		-name "*.js" -o \
		-name "*.mjs" -o \
		-name "*.cjs" -o \
		-name "*.wasm" -o \
		-name "*.rb" -o \
		-name "*.pl" -o \
		-perm -100 \) \
		-exec chmod 0755 {} + \
		|| die "chmod executables failed"
}

src_install() {
	shopt -s dotglob # Copy hidden files

	local d

	# There are a lot of dangling symlink references.
	# We just copy everything since we don't know what deep dependencies are
	# required for dependency of dependency.
	d="/opt/vercel"
	dodir "${d}"
	mv * "${ED}/${d}" || die

	cat "${FILESDIR}/vc" > "${T}/vc" || die
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/vc"
	exeinto "/usr/bin"
	doexe "${T}/vc"
	dosym "/usr/bin/vc" "/usr/bin/vercel"

	sanitize_file_permissions
	fperms 0755 "/usr/bin/vc"

	shopt -u dotglob # Skip hidden files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 52.2.1 (20260430)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 53.0.1 (20260430)
