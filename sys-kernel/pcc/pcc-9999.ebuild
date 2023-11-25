# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAINTAINER_MODE=0
PYTHON_COMPAT=( python3_{8..11} )
inherit git-r3 linux-info linux-mod-r1

DESCRIPTION="Performance-oriented Congestion Control"
HOMEPAGE="
http://www.pccproject.net
https://github.com/PCCproject/PCC-Kernel
"
LICENSE="
	allegro? (
		BSD GPL-2
	)
	vivace? (
		BSD GPL-2
	)
"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" allegro custom-kernel doc +vivace r1"
REQUIRED_USE="
	^^ (
		allegro
		vivace
	)
"
# If you have a custom kernel, it is recommended to maintain a local copy to add
# your own kernel to the list below for auto rebuilds.
RDEPEND+="
	!custom-kernel? (
	        || (
			sys-kernel/gentoo-kernel:=
			sys-kernel/gentoo-kernel-bin:=
			sys-kernel/gentoo-sources:=
			sys-kernel/git-sources:=
			sys-kernel/linux-next:=
			sys-kernel/mips-sources:=
			sys-kernel/ot-sources:=
			sys-kernel/pf-sources:=
			sys-kernel/raspberrypi-sources:=
			sys-kernel/rt-sources:=
			sys-kernel/vanilla-kernel:=
			sys-kernel/vanilla-sources:=
			sys-kernel/zen-sources:=
		)
	)
"
DEPEND+="
"
BDEPEND+="
	|| (
		sys-devel/gcc
		sys-devel/clang
	)
"
S="${WORKDIR}"
RESTRICT="mirror"
MAKEOPTS="-j1"

pkg_setup() {
	linux-info_pkg_setup
	linux-mod-r1_pkg_setup
	if [[ -z "${PCC_KERNELS}" ]] ; then
eerror
eerror "You must define PCC_KERNELS in /etc/portage/make.conf or as a"
eerror "per-package environment variable."
eerror
eerror "Examples:"
eerror
eerror "PCC_KERNELS=\"5.4.^-builder 5.15.^-builder\" # for latest installed point release"
eerror "PCC_KERNELS=\"5.4.*-builder 5.15.*-builder\" # for all installed point releases"
eerror "PCC_KERNELS=\"5.4.261-builder 5.15.139-builder\" # for exact point releases"
eerror "PCC_KERNELS=\"5.4.261-builder 5.15.^-builder 6.1.*-builder\" # for all three cases releases"
eerror
eerror "This is to allow to support LTS, stable, and live kernels at the same time."
eerror
		die
	fi

	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				KERNEL_DIR="/usr/src/linux-${k}"
				[[ "${KERNEL_DIR}/.config" ]] || die "Missing .config for ${k}"
				[[ "/boot/.config" ]] || die "Missing .config for ${k}"
				if ! ls /boot/vmlinuz-${k}* >/dev/null ; then
					die "The kernel needs to be built first for ${k}."
				fi
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			KERNEL_DIR="/usr/src/linux-${k}"
			[[ "${KERNEL_DIR}/.config" ]] || die "Missing .config for ${k}"
			if ! ls /boot/vmlinuz-${k}* >/dev/null ; then
				die "The kernel needs to be built first for ${k}."
			fi
			check_kernel_built
		else
			KERNEL_DIR="/usr/src/linux-${k}"
			[[ "${KERNEL_DIR}/.config" ]] || die "Missing .config for ${k}"
			if ! ls /boot/vmlinuz-${k}* >/dev/null ; then
				die "The kernel needs to be built first for {k}."
			fi
		fi
	done
}

src_unpack() {
	if use allegro ; then
		EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/allegro"
		git-r3_fetch
		git-r3_checkout
	fi
	if use vivace ; then
		EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
		EGIT_COMMIT="HEAD"
		EGIT_BRANCH="vivace"
		EGIT_CHECKOUT_DIR="${WORKDIR}/vivace"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_prepare() {
	default
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				if use allegro ; then
					cp -av "${WORKDIR}/allegro" "${WORKDIR}/allegro-${k}"
				fi
				if use vivace ; then
					cp -av "${WORKDIR}/vivace" "${WORKDIR}/vivace-${k}"
				fi
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			if use allegro ; then
				cp -av "${WORKDIR}/allegro" "${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				cp -av "${WORKDIR}/vivace" "${WORKDIR}/vivace-${k}"
			fi
		else
			if use allegro ; then
				cp -av "${WORKDIR}/allegro" "${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				cp -av "${WORKDIR}/vivace" "${WORKDIR}/vivace-${k}"
			fi
		fi
	done
}

src_compile() {
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				local modlist=()
				if use allegro ; then
					modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
					d="${WORKDIR}/allegro-${k}"
				fi
				if use vivace ; then
					modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
					d="${WORKDIR}/vivace-${k}"
				fi
				cd "${d}" || die
				KERNEL_DIR="/usr/src/linux-${k}"
				local modargs=( NIH_SOURCE="${KERNEL_DIR}" )
				KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
				MODULES_MAKEARGS=(
					V=1
					ARCH=$(tc-arch-kernel)
					KDIR="/lib/modules/${KV_FULL}/build"
					NIH_KDIR="${KERNEL_DIR}"
					NIH_KSRC="${KERNEL_DIR}"
				)
				linux-mod-r1_src_compile
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			local modlist=()
			if use allegro ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
				d="${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
				d="${WORKDIR}/vivace-${k}"
			fi
			cd "${d}" || die
			KERNEL_DIR="/usr/src/linux-${k}"
			local modargs=( NIH_SOURCE="${KERNEL_DIR}" )
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			MODULES_MAKEARGS=(
				V=1
				ARCH=$(tc-arch-kernel)
				KDIR="/lib/modules/${KV_FULL}/build"
				NIH_KDIR="${KERNEL_DIR}"
				NIH_KSRC="${KERNEL_DIR}"
			)
			linux-mod-r1_src_compile
		else
			local modlist=()
			if use allegro ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
				d="${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
				d="${WORKDIR}/vivace-${k}"
			fi
			cd "${d}" || die
			KERNEL_DIR="/usr/src/linux-${k}"
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			MODULES_MAKEARGS=(
				V=1
				ARCH=$(tc-arch-kernel)
				KDIR="/lib/modules/${KV_FULL}/build"
				NIH_KDIR="${KERNEL_DIR}"
				NIH_KSRC="${KERNEL_DIR}"
			)
			linux-mod-r1_src_compile
		fi
	done
}

src_install() {
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			local v
			for v in ${V} ; do
				k="${v}"
				local modlist=()
				if use allegro ; then
					modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
					d="${WORKDIR}/allegro-${k}"
				fi
				if use vivace ; then
					modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
					d="${WORKDIR}/vivace-${k}"
				fi
				cd "${d}" || die
				KERNEL_DIR="/usr/src/linux-${k}"
				KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
				MODULES_MAKEARGS=(
					V=1
					ARCH=$(tc-arch-kernel)
					KDIR="/lib/modules/${KV_FULL}/build"
					NIH_KDIR="${KERNEL_DIR}"
					NIH_KSRC="${KERNEL_DIR}"
				)
				einfo "KV_FULL:  ${KV_FULL}"
				einfo "ARCH:  $(tc-arch-kernel)"
				# Do it this way because linux-mod-r1_src_compile is bugged
				insinto /lib/modules/${KV_FULL}/kernel/net/ipv4
				doins "${WORKDIR}/vivace-${k}/src/tcp_pcc.ko"
				modules_post_process
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			local modlist=()
			if use allegro ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
				d="${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
				d="${WORKDIR}/vivace-${k}"
			fi
			cd "${d}" || die
			KERNEL_DIR="/usr/src/linux-${k}"
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			MODULES_MAKEARGS=(
				V=1
				ARCH=$(tc-arch-kernel)
				KDIR="/lib/modules/${KV_FULL}/build"
				NIH_KDIR="${KERNEL_DIR}"
				NIH_KSRC="${KERNEL_DIR}"
			)
			einfo "KV_FULL:  ${KV_FULL}"
			einfo "ARCH:  $(tc-arch-kernel)"
			# Do it this way because linux-mod-r1_src_compile is bugged
			insinto /lib/modules/${KV_FULL}/kernel/net/ipv4
			doins "${WORKDIR}/vivace-${k}/src/tcp_pcc.ko"
			modules_post_process
		else
			local modlist=()
			if use allegro ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default" )
				d="${WORKDIR}/allegro-${k}"
			fi
			if use vivace ; then
				modlist=( tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default" )
				d="${WORKDIR}/vivace-${k}"
			fi
			cd "${d}" || die
			KERNEL_DIR="/usr/src/linux-${k}"
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			MODULES_MAKEARGS=(
				V=1
				ARCH=$(tc-arch-kernel)
				KDIR="/lib/modules/${KV_FULL}/build"
				NIH_KDIR="${KERNEL_DIR}"
				NIH_KSRC="${KERNEL_DIR}"
			)
			einfo "KV_FULL:  ${KV_FULL}"
			einfo "ARCH:  $(tc-arch-kernel)"
			# Do it this way because linux-mod-r1_src_compile is bugged
			insinto /lib/modules/${KV_FULL}/kernel/net/ipv4
			doins "${WORKDIR}/vivace-${k}/src/tcp_pcc.ko"
			modules_post_process
		fi
	done

	if use allegro ; then
		cd "${WORKDIR}/allegro" || die
		docinto "allegro"
		dodoc "LICENSE"
		use doc && dodoc "src/README.rst"
	fi
	if use vivace ; then
		cd "${WORKDIR}/vivace" || die
		docinto "vivace"
		dodoc "LICENSE"
		use doc && dodoc "src/README.rst"
	fi
}

pkg_postinst() {
	# Do it this way because linux-mod-r1_pkg_postinst is bugged
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			local v
			for v in ${V} ; do
				k="${v}"
				KERNEL_DIR="/usr/src/linux-${k}"
				KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
				linux-mod-r1_pkg_postinst
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			KERNEL_DIR="/usr/src/linux-${k}"
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			linux-mod-r1_pkg_postinst
		else
			KERNEL_DIR="/usr/src/linux-${k}"
			KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
			linux-mod-r1_pkg_postinst
		fi
	done
}
