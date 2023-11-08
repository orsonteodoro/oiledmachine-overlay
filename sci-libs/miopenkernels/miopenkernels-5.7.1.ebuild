# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MAINTAINER_MODE=0
if [[ "${PV##*.}" == "0" ]] ; then
	MY_PV=$(ver_cut 1-2 ${PV})
else
	MY_PV="${PV}"
fi
ROCM_SKIP_COMMON_PATHS_PATCHES=1
ROCM_SLOT="5.7"
ROCM_VERSION="${PV}"

inherit rocm unpacker

if [[ "${MAINTAINER_MODE}" =~ "1" ]] ; then
	:;
elif [[ "${AUPDATE}" =~ "1" ]] ; then
	SRC_URI="
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx1030kdb/miopen-hip-asan-gfx1030kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx900kdb/miopen-hip-asan-gfx900kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx906kdb/miopen-hip-asan-gfx906kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx908kdb/miopen-hip-asan-gfx908kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx90akdb/miopen-hip-asan-gfx90akdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx1030kdb/miopen-hip-gfx1030kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx900kdb/miopen-hip-gfx900kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx906kdb/miopen-hip-gfx906kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx908kdb/miopen-hip-gfx908kdb_2.20.0.50701-98~20.04_amd64.deb
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx90akdb/miopen-hip-gfx90akdb_2.20.0.50701-98~20.04_amd64.deb
	"
else
	SRC_URI="
		asan? (
			amdgpu_targets_gfx1030? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx1030kdb/miopen-hip-asan-gfx1030kdb_2.20.0.50701-98~20.04_amd64.deb
			)
			amdgpu_targets_gfx900? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx900kdb/miopen-hip-asan-gfx900kdb_2.20.0.50701-98~20.04_amd64.deb
			)
			amdgpu_targets_gfx906? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx906kdb/miopen-hip-asan-gfx906kdb_2.20.0.50701-98~20.04_amd64.deb
			)
			amdgpu_targets_gfx908? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx908kdb/miopen-hip-asan-gfx908kdb_2.20.0.50701-98~20.04_amd64.deb
			)
			amdgpu_targets_gfx90a? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-asan-gfx90akdb/miopen-hip-asan-gfx90akdb_2.20.0.50701-98~20.04_amd64.deb
			)
		)
		amdgpu_targets_gfx1030? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx1030kdb/miopen-hip-gfx1030kdb_2.20.0.50701-98~20.04_amd64.deb
		)
		amdgpu_targets_gfx900? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx900kdb/miopen-hip-gfx900kdb_2.20.0.50701-98~20.04_amd64.deb
		)
		amdgpu_targets_gfx906? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx906kdb/miopen-hip-gfx906kdb_2.20.0.50701-98~20.04_amd64.deb
		)
		amdgpu_targets_gfx908? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx908kdb/miopen-hip-gfx908kdb_2.20.0.50701-98~20.04_amd64.deb
		)
		amdgpu_targets_gfx90a? (
https://repo.radeon.com/rocm/apt/${MY_PV}/pool/main/m/miopen-hip-gfx90akdb/miopen-hip-gfx90akdb_2.20.0.50701-98~20.04_amd64.deb
		)
	"
fi

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
IUSE="asan r2"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	!sci-libs/miopenkernels:0
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

check_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download kernels."
eerror
		die
	fi
}

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
		check_sandbox
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
				if [[ "${y}" =~ "asan" ]] && ! use asan ; then
					continue
				fi
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
	insinto "/opt/rocm-${MY_PV}/share/miopen/db"
	local f
	for f in $(find . -name "*.kdb") ; do
		doins "${f}"
	done
einfo "Compressing kernels"
	pushd "${ED}/opt/rocm-${MY_PV}/share/miopen/db" || die
		for f in $(find . -name "*.kdb") ; do
			bzip2 -kv "${f}"
		done
	popd
}

# OILEDMACHINE-OVERLAY-STATUS:  finished
