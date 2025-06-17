# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MEMMAX_SIZES=(
	# Limit to half 4 GiB RAM to mitigate DoS.
	# Assuming the machine has >= 4 GiB of RAM.
	2048 # 2 GiB
	1024 # 1 GiB
	512 # 512 MiB
)
STRMAX_SIZES=(
	# Limit to half 4 GiB RAM to mitigate DoS.
	# Assuming the machine has >= 4 GiB of RAM.
	524288 # 2 GiB
	262144 # 1 GiB
	128000 # 512 MiB
	65536 # 256 MiB
	32768 # 128 MiB
	16384 # 64 MiB
	8192 # 32 MiB
	4096 # 16 MiB
	2048 # 8 MiB
	1024 # 4 MiB
	512 # 2 MiB
	256 # 1 MiB
	128 # KiB
	64 # KiB
	32 # KiB
	16 # KiB
	8 # KiB
)

inherit autotools check-compiler-switch flag-o-matic

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/rurban/safeclib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="safec libc extension with all C11 Annex K functions"
HOMEPAGE="
	https://rurban.github.io/safeclib/
	https://github.com/rurban/safeclib
"
LICENSE="MIT"
SLOT="0"
gen_iuse_memmax() {
	local x
	for x in ${MEMMAX_SIZES[@]} ; do
		echo " memmax-${x}mb "
	done
}
gen_iuse_strmax() {
	local x
	for x in ${STRMAX_SIZES[@]} ; do
		echo " strmax-${x}k "
	done
}
IUSE="
$(gen_iuse_memmax)
$(gen_iuse_strmax)
doc static-libs
ebuild_revision_1
"
RDEPEND="
"
DEPEND="
"
BDEPEND="
	dev-build/autoconf:2.69
	dev-build/automake
	dev-build/libtool
	dev-build/make
	dev-perl/Text-Diff
	sys-apps/file
	sys-devel/gcc
	virtual/pkgconfig
"

pkg_setup() {
	check-compiler-switch_start
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Removing LTO."
		filter-lto
	fi
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Dedupe flags
	filter-flags \
		"-fstack-protector-strong" \
		"-fstack-clash-protection" \
		"-fcf-protection" \
		"-fno-strict-overflow" \
		"-fno-delete-null-pointer-checks" \
		"-fno-lifetime-dse"
	local myconf=(
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	if [[ -n "${SAFECLIB_MEMMAX}" ]] ; then
einfo "SAFECLIB_MEMMAX=${SAFECLIB_MEMMAX}"
		myconf+=(
			--enable-memmax=$(python -c "print(${SAFECLIB_MEMMAX}<<20)")
		)
	else
		local x
		for x in ${MEMMAX_SIZES[@]} ; do
			if use "memmax-${x}mb" ; then
einfo "SAFECLIB_MEMMAX=${x}MB"
				myconf+=(
					--enable-memmax=$(python -c "print(${x}<<20)")
				)
				break
			fi
		done
	fi

	if [[ -n "${SAFECLIB_STRMAX}" ]] ; then
einfo "SAFECLIB_STRMAX=${SAFECLIB_STRMAX}"
		myconf+=(
			--enable-strmax=$(python -c "print(${SAFECLIB_STRMAX}<<10)")
		)
	else
		local x
		for x in ${STRMAX_SIZES[@]} ; do
			if use "strmax-${x}k" ; then
einfo "SAFECLIB_STRMAX=${x}K"
				myconf+=(
					--enable-strmax=$(python -c "print(${x}<<10)")
				)
				break
			fi
		done
	fi
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
