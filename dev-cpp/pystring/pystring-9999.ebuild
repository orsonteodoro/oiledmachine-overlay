# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)

inherit flag-o-matic libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/imageworks/pystring.git"
	FALLBACK_COMMIT="76a2024e132bcc83bec1ecfebeacd5d20d490bfe" # Jul 22, 2023
	inherit git-r3
else
	SRC_URI="FIXME"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="C++ functions matching the interface and behavior of Python string \
methods"
HOMEPAGE="https://github.com/imageworks/pystring"
LICENSE="BSD"
# Live ebuild snapshots do not get keyworded
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" custom-cflags doc test"
RDEPEND+="
	|| (
		sys-devel/gcc[cxx]
		llvm-runtimes/libcxx
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/libtool
	sys-apps/grep
	|| (
		sys-devel/gcc[cxx]
		llvm-core/clang
	)
"
DOCS=( "README" )

pkg_setup() {
	if use test ; then
		if [[ "${FEATURES}" =~ "test" ]] ; then
			:
		else
eerror
eerror "You need to add FEATURES=test before running emerge/ebuild to run"
eerror "tests."
eerror
			die
		fi
	fi
	local gcc_pv=$(\
		gcc --version \
		| head -n 1 \
		| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+" \
		| head -n 1)
	if ver_test ${gcc_pv} -ge 11 ; then
		gcc_pv=$(ver_cut 1 ${gcc_pv})
	fi
	if libtool --config | grep -q -e "linux-gnu/${gcc_pv}" ; then
einfo
einfo "Libtool & GCC compatibility:  Pass"
einfo
	else
eerror
eerror "Libtool & GCC compatibility:  Fail"
eerror
eerror "Everytime GCC is updated, you need to..."
eerror "emerge -1o libtool && emerge -1O libtool"
eerror
		die
	fi
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	sed -i \
		-e '/.\/test/d' "Makefile" \
		|| die
}

src_configure() {
	sed -i \
		-e "s|/usr/lib|${ESYSROOT}/usr/$(get_libdir)|g" \
		"Makefile" \
		|| die
	if use custom-cflags ; then
		sed -i \
			-e "s|-O3|${CXXFLAGS}|g" \
			-e "s|CXXFLAGS =|CXXFLAGS = ${CXXFLAGS}|g" "Makefile" \
			|| die
	else
		strip-flags
		filter-flags -O*
	fi
}

src_compile() {
	emake LIBDIR="${S}" install
	use test && emake LIBDIR="${S}" test
	# Fix header location
	mkdir "${S}/pystring" || die
	mv "${S}/pystring.h" "${S}/pystring" || die
}

src_test() {
	cd "${S}" || die
	./test || die
}

src_install() {
	dolib.so "${S}/libpystring.so"{"",".0"{"",".0.0"}}
	doheader -r "${S}/pystring"
	docinto "licenses"
	dodoc "LICENSE"
	use doc && einstalldocs
}
