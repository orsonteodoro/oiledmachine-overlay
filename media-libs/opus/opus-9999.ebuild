# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO"
PYTHON_COMPAT=( "python3_"{10..13} )

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
)

OPUS_DATA_ID="a5177ec6fb7d15058e99e57029746100121f68e4890b1467d4094aa336b6013e"

inherit cflags-hardened check-compiler-switch flag-o-matic meson-multilib python-any-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="3da9f7a6db1c05c3996cb363a9d1931a978bf1be"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/xiph/opus.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86
	"
	SRC_URI+=" https://downloads.xiph.org/releases/opus/${P}.tar.gz"
fi
SRC_URI+="
	https://media.xiph.org/opus/models/opus_data-${OPUS_DATA_ID}.tar.gz
"

DESCRIPTION="Open codec for interactive speech and music transmission over the Internet"
HOMEPAGE="https://opus-codec.org/"
LICENSE="BSD"
SLOT="0"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
custom-modes debug deep-plc dred doc hardened osce static-libs test
ebuild_revision_26
"
REQUIRED_USE="
	dred? (
		deep-plc
	)
	osce? (
		deep-plc
	)
"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.3.1-libdir-macro.patch"
	"${FILESDIR}/${PN}-1.4-arm64-neon.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout

		if [[ -n "${A}" ]] ; then
			unpack ${A}
		fi
	else
		unpack ${A}
	fi

	local expected_id="${OPUS_DATA_ID}"
	local actual_id=$(grep -r -e "download_model.sh" "${S}/autogen.sh" | cut -f 2 -d '"')
	if ! grep -r -e "${expected_id}" "${S}/autogen.sh" ; then
eerror "QA:  Update OPUS_DATA_ID"
eerror "Expected OPUS_DATA_ID:  ${expected_id}"
eerror "Actual OPUS_DATA_ID:  ${actual_id}"
		die
	fi
	mv "dnn/"* "${S}/dnn" || die
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	local emesonargs=(
		$(meson_feature deep-plc)
		$(meson_feature dred)
		$(meson_feature osce)
		$(meson_feature test tests)
		$(meson_native_use_feature doc docs)
		$(meson_use custom-modes)
		$(meson_use debug assertions)
		$(meson_use hardened hardening)
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
	)

	# Disable intrinsics if no flags are enabled (bug #752069)
	# bug #752069
	# TODO: What is -Dasm for?
	local i
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} \
			&& \
		emesonargs+=( -Dintrinsics=enabled ) \
			&& \
		break
	done || emesonargs+=(
		-Dintrinsics=disabled
	)

	if is-flagq "-ffast-math" || is-flagq "-Ofast" ; then
		emesonargs+=(
			-Dfloat-approx=true
		)
	fi

	meson_src_configure
}

multilib_src_test() {
	meson_src_test --timeout-multiplier=2
}
