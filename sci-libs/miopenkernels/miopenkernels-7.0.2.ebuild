# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
)
MAINTAINER_MODE=0
if [[ "${PV##*.}" == "0" ]] ; then
	MY_PV=$(ver_cut 1-2 ${PV})
else
	MY_PV="${PV}"
fi
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit rocm sandbox-changes unpacker

if [[ "${MAINTAINER_MODE}" =~ "1" ]] ; then
	:
else
	# Same hash for U24 and U22
	SRC_URI="
		amdgpu_targets_gfx1030? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx1030kdb/miopen-hip-gfx1030kdb_3.5.0.70002-56~24.04_amd64.deb
		)
		amdgpu_targets_gfx900? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx900kdb/miopen-hip-gfx900kdb_3.5.0.70002-56~24.04_amd64.deb
		)
		amdgpu_targets_gfx906? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx906kdb/miopen-hip-gfx906kdb_3.5.0.70002-56~24.04_amd64.deb
		)
		amdgpu_targets_gfx908? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx908kdb/miopen-hip-gfx908kdb_3.5.0.70002-56~24.04_amd64.deb
		)
		amdgpu_targets_gfx90a? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx90akdb/miopen-hip-gfx90akdb_3.5.0.70002-56~24.04_amd64.deb
		)
		amdgpu_targets_gfx942? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx942kdb/miopen-hip-gfx942kdb_3.5.0.70002-56~24.04_amd64.deb
		)
	"
fi

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/${ROCM_SLOT}"
IUSE="ebuild_revision_4"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	net-misc/wget
"
RESTRICT="
"
S="${WORKDIR}"
PATCHES=(
)

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack ${1}
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	# Obtained from after csplit below manually removing junk items:
	local uri_base="https://repo.radeon.com/rocm/apt/${MY_PV}/"

	if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
	# For minimizing copy-paste human error.
		sandbox-changes_no_network_sandbox "To download kernels"
		# For hashes
		wget "https://repo.radeon.com/rocm/apt/${MY_PV}/dists/ubuntu/main/binary-amd64/Packages"
		csplit \
			--quiet \
			--prefix=Packages \
			--suffix-format=%02d.txt \
			--suppress-matched \
			Packages /^$/ {*}

		IFS=$'\n'
		local L=(
			$(grep -i -r -e "miopen-hip.*deb" "${WORKDIR}" \
			| cut -f 2 -d " " \
			| sort \
			| uniq)
		)

		einfo "Update files array with the following:"
		einfo
		local p
		for p in ${L[@]} ; do
			[[ "${p}" =~ "${PV}" ]] && continue # Skip duplicate
			echo "${p}"
		done
		einfo

		die
	fi

	export EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${EDISTDIR}" || die
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		for y in $(echo "${SRC_URI}" | grep "deb") ; do
			if use "amdgpu_targets_${x}" && [[ "${y}" =~ "${x}" ]] ; then
				local bn=$(basename "${y}")
				[[ "${bn}" =~ "${PV}" ]] && continue # Skip duplicate
				pushd "${WORKDIR}" || die
					unpack_deb "${EDISTDIR}/${bn}"
				popd
			fi
		done
	done
}

src_prepare() {
	default
}

src_install() {
	insinto "/opt/rocm-${PV}/share/miopen/db"
	local f
	for f in $(find . -name "*.kdb") ; do
		doins "${f}"
	done
einfo "Compressing kernels"
	pushd "${ED}/opt/rocm-${PV}/share/miopen/db" || die
		for f in $(find . -name "*.kdb") ; do
			bzip2 -kv "${f}"
		done
	popd
	find "${ED}" -name "gfx*.kdb" -delete || die
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs install test
