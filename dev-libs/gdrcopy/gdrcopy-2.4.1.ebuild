# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Based on distro's list:
DRIVER_VERSIONS=(
	560.31.02
	555.58.02
	555.58
	550.107.02
	550.100
	550.40.67
	535.183.01
	525.147.05
	# 515.43.04 is the last tag
)
declare -A CUDA_GCC_SLOT=(
	["12.6"]="13"
	["12.5"]="13"
	["12.4"]="13"
	["12.3"]="12"
	["11.8"]="11"
)

inherit check-compiler-switch flag-o-matic linux-mod-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
gen_src_uri() {
	local ver
	for ver in ${DRIVER_VERSIONS[@]} ; do
		echo "
https://github.com/NVIDIA/open-gpu-kernel-modules/archive/refs/tags/${ver}.tar.gz
	-> open-gpu-kernel-modules-${ver}.tar.gz
		"
	done
}
SRC_URI="
	$(gen_src_uri)
https://github.com/NVIDIA/gdrcopy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
DESCRIPTION="A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology"
HOMEPAGE="https://github.com/NVIDIA/gdrcopy"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD
	GPL-2
"
# ( all-rights-reserved MIT ) GPL-2 - open-gpu-kernel-modules-550.100/COPYING
# BSD - open-gpu-kernel-modules-550.100/src/common/softfloat/COPYING.txt
# The distro's MIT license template does not contain all rights reserved.
SLOT="0"
IUSE="
ebuild_revision_5
"
gen_driver_versions() {
	local ver
	for ver in ${DRIVER_VERSIONS[@]} ; do
		echo "
			~x11-drivers/nvidia-drivers-${ver}[kernel-open]
		"
	done
}
RDEPEND="
	dev-util/nvidia-cuda-toolkit:=
	|| (
		$(gen_driver_versions)
	)
	x11-drivers/nvidia-drivers:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/make
"
PATCHES=(
)

get_arch() {
	if use amd64 ; then
		echo "x86"
	elif use arm64 ; then
		echo "arm64"
	fi
}

libstdcxx_check() {
	local required_gcc_slot="${1}"
        local gcc_current_profile=$(gcc-config -c)
        local gcc_current_profile_slot=${gcc_current_profile##*-}
        if ver_test "${gcc_current_profile_slot}" -ne "${required_gcc_slot}" ; then
eerror
eerror "You must switch to =sys-devel/gcc-${required_gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${required_gcc_slot}"
eerror "  source /etc/profile"
eerror
                die
        fi
}

pkg_setup() {
	check-compiler-switch_start
	linux-mod-r1_pkg_setup
}

src_unpack() {
	unpack "${P}.tar.gz"
	local found=0
	local ver
	for ver in ${DRIVER_VERSIONS[@]} ; do
		if has_version "~x11-drivers/nvidia-drivers-${ver}" ; then
			found=1
export DRIVER_VERSION="${ver}"
einfo "Detected ${ver}"
			unpack "open-gpu-kernel-modules-${ver}.tar.gz"
			break
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "A compatible x11-drivers/nvidia-drivers is not installed."
eerror "Acceptable versions:  ${DRIVER_VERSIONS[@]}"
eerror
		die
	fi
}

src_configure() {
	local found=0
	local ver
	for ver in ${!CUDA_GCC_SLOT[@]} ; do
		if has_version "=dev-util/nvidia-cuda-toolkit-${ver}*" ; then
			found=1
			local cuda_gcc_slot=${CUDA_GCC_SLOT["${ver}"]}
			libstdcxx_check ${cuda_gcc_slot}
			break
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "A compatible dev-util/nvidia-cuda-toolkit is not installed."
eerror "Acceptable major-minor versions:  ${!CUDA_GCC_SLOT[@]}"
eerror
		die
	fi

	local kver=""
	if [[ -n "${KVER}" ]] ; then
		kver="${KVER}"
	else
		kver=$(uname -r)
	fi

	# Check if the driver module matches
	if [[ ! -f "/lib/modules/${kver}/video/nvidia.ko" ]] ; then
eerror
eerror "Inconsistent kernel module install path"
eerror
eerror "Expected:  /lib/modules/${kver}/video/nvidia.ko"
eerror "Actual:  "$(realpath "/lib/modules/"*"/video/nvidia.ko")
eerror
eerror "Rebuild x11-drivers/nvidia-drivers or you may also set the KVER"
eerror "environment variable corresponding to /lib/modules/KVER to change the"
eerror "module install path so that the to be built gdrdrv.ko will be under"
eerror "the same driver root as nvidia.ko.  See metadata.xml for details."
eerror
		die
	fi

	if [[ -n "${KVER}" ]] ; then
		local k=$(echo "${KVER}" | cut -f 1-2 -d "-")
	else
		local k=$(uname -r | cut -f 1-2 -d "-")
	fi
	if [[ ! -d "/usr/src/linux-${k}" ]] ; then
eerror
eerror "Path to kernel source is unreachable.  The correct path is required for"
eerror "updating module dependencies in during post-install."
eerror
eerror "Expected:"
eerror
eerror "  /usr/src/linux-${k}"
eerror
eerror "Solutions:"
eerror
eerror "  (1) Install a kernel source at the correct location."
eerror "  (e.g. /usr/src/linux-4.15.164-gentoo and symlink from /usr/src/linux)"
eerror "  (2) Change KVER environment variable so that it corresponds to the"
eerror "  path /lib/modules/\$KVER.  The path to /usr/src/linux-${k} will be"
eerror "  partly based on the first 2 parts of the hyphen delimited KVER, so"
eerror "  that 4.15.164-gentoo-x86 becomes /usr/src/linux-4.15.164-gentoo."
eerror "  (3) Use a kernel source that uses correct install path syntax to"
eerror "  sources not your own manually installed one installed directly in"
eerror "  /usr/src/linux.  (i.e. emerge the gentoo-sources package)"
eerror
		die
	fi

	if [[ -e "${KERNEL_DIR}/.config" ]] ; then
		export CC=$(grep -E -e "CONFIG_CC_VERSION_TEXT" "${KERNEL_DIR}/.config" \
			| cut -f 1 -d " " \
			| cut -f 2 -d "=" \
			| sed -e "s/[\"|']//g")
		export CPP="${CC} -E"
einfo "PATH (before):  ${PATH}"
		if tc-is-gcc ; then
			local slot=$(gcc-major-version)
			local path="/usr/${CHOST}/gcc-bin/${slot}"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "\|/usr/lib/llvm/|d" \
				| sed -e "\|/usr/${CHOST}/gcc-bin/|d" \
				| sed -e "s|/usr/local/sbin|${path}\n/usr/local/sbin|g" \
				| tr "\n" ":")
		else
			local slot=$(clang-major-version)
			local path="/usr/lib/llvm/${slot}/bin"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "\|/usr/lib/llvm/|d" \
				| sed -e "\|/usr/${CHOST}/gcc-bin/|d" \
				| sed -e "s|/usr/local/sbin|${path}\n/usr/local/sbin|g" \
				| tr "\n" ":")
		fi
einfo "PATH (after):  ${PATH}"
		strip-unsupported-flags
einfo "CC: ${CC}"
		local kernel_gcc_slot=$(gcc-major-version)
		if tc-is-gcc && ver_test ${kernel_gcc_slot} -ne ${cuda_gcc_slot} ; then
eerror
eerror "The kernel slot must be the same as the max supported GCC for"
eerror "dev-util/nvidia-cuda-toolkit."
eerror
eerror "GCC slot of dev-util/nvidia-cuda-toolkit:  ${cuda_gcc_slot}"
eerror "GCC slot of kernel:  ${kernel_gcc_slot}"
eerror
			die
		fi
	fi
}

get_config() {
	local myconf=(
		ARCH=$(get_arch)
		CUDA="/opt/cuda"
		libdir="/usr/$(get_libdir)"
		NVIDIA_IS_OPENSOURCE=1 # Fix nv-frontend.c spam and detection
		NVIDIA_SRC_DIR="${WORKDIR}/open-gpu-kernel-modules-${DRIVER_VERSION}/kernel-open/nvidia"
		prefix="/usr"
		V=1
		VERBOSE=1
	)
	if [[ -n "${KVER}" ]] ; then
		myconf=(
			KVER="${KVER}"
		)
	fi
	echo ${myconf[@]}
}

src_compile() {
	emake $(get_config)
}

src_install() {
	emake \
		$(get_config) \
		DESTDIR="${D}" \
		install
	docinto license
	dodoc "LICENSE"

	# The script is eagerly wrong.
	local kver
	if [[ -n "${KVER}" ]] ; then
		kver="${KVER}"
	else
		kver=$(uname -r)
	fi
	insinto "/lib/modules/${KVER}/kernel/drivers/misc/"
	doins "src/gdrdrv/gdrdrv.ko"
}

_pkg_postinst_one() {
        local k="${1}"
        KERNEL_DIR="/usr/src/linux-${k}"
        KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
	linux-mod-r1_pkg_postinst
}

pkg_postinst() {
	local k
	if [[ -n "${KVER}" ]] ; then
		k=$(echo "${KVER}" | cut -f 1-2 -d "-")
	else
		k=$(uname -r | cut -f 1-2 -d "-")
	fi
	_pkg_postinst_one "${k}"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
