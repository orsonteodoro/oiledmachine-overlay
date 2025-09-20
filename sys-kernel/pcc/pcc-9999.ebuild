# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAINTAINER_MODE=0
PYTHON_COMPAT=( "python3_"{8..11} )

inherit flag-o-matic linux-info linux-mod-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/PCCproject/PCC-Kernel.git"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="2eeadf0907baea693ee949add800f4ed32f38a88" # Jul 13, 2018
	inherit git-r3
else
	SRC_URI="FIXME"
fi
S="${WORKDIR}"

DESCRIPTION="Performance-oriented Congestion Control"
HOMEPAGE="
http://www.pccproject.net
https://github.com/PCCproject/PCC-Kernel
"
LICENSE="
	allegro? (
		BSD
		GPL-2
	)
	vivace? (
		BSD
		GPL-2
	)
"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip" # No strip required by CONFIG_MODULE_SIG
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
allegro custom-kernel doc +vivace
ebuild_revision_6
"
REQUIRED_USE="
	^^ (
		allegro
		vivace
	)
"
# If you have a custom kernel, it is recommended to maintain a local copy to add
# your own kernel to the list below for auto rebuilds.
CDEPEND="
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
RDEPEND+="
	${CDEPEND}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${CDEPEND}
	|| (
		sys-devel/gcc
		llvm-core/clang
	)
"
MAKEOPTS="-j1"

_pkg_setup_one() {
	local k="${1}"
	[[ -z "${k}" ]] && die "Missing kernel sources for linux-${pat}"
	KERNEL_DIR="/usr/src/linux-${k}"
	[[ -e "${KERNEL_DIR}" ]] || die "Missing kernel sources for linux-${pat}"
	[[ -e "${KERNEL_DIR}/.config" ]] || die "Missing .config for ${k}"
	if ! realpath "/boot/vmlinuz-${k}"* 2>/dev/null 1>/dev/null ; then
		die "The kernel needs to be built first for ${k}."
	fi
}

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
			local pat="${k}"
			local V=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				_pkg_setup_one "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			_pkg_setup_one "${k}"
		else
			_pkg_setup_one "${k}"
		fi
	done
}

src_unpack() {
	if use allegro ; then
		EGIT_BRANCH="master"
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/allegro"
		git-r3_fetch
		git-r3_checkout
	fi
	if use vivace ; then
		EGIT_BRANCH="vivace"
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/vivace"
		git-r3_fetch
		git-r3_checkout
	fi
}

_src_prepare_one() {
	local k="${1}"
	if use allegro ; then
		cp -av \
			"${WORKDIR}/allegro" \
			"${WORKDIR}/allegro-${k}" \
			|| die
	fi
	if use vivace ; then
		cp -av \
			"${WORKDIR}/vivace" \
			"${WORKDIR}/vivace-${k}" \
			|| die
	fi
}

src_prepare() {
	default

	if use allegro ; then
		eapply "${FILESDIR}/${PN}-2eeadf0-allegro-6.10-compat.patch"
	fi

	if use vivace ; then
		eapply "${FILESDIR}/${PN}-2eeadf0-vivace-6.10-compat.patch"
	fi

	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find "/usr/src/" -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				_src_prepare_one "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			_src_prepare_one "${k}"
		else
			_src_prepare_one "${k}"
		fi
	done
}

_src_compile_one() {
	local k="${1}"
	local modlist=()
	if use allegro ; then
		modlist=(
			tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default"
		)
		d="${WORKDIR}/allegro-${k}"
	fi
	if use vivace ; then
		modlist=(
			tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default"
		)
		d="${WORKDIR}/vivace-${k}"
	fi
	cd "${d}" || die

	KERNEL_DIR="/usr/src/linux-${k}"

	export CC=$(grep -E -e "CONFIG_CC_VERSION_TEXT" "${KERNEL_DIR}/.config" \
		| cut -f 1 -d " " \
		| cut -f 2 -d "=" \
		| sed -e "s/[\"|']//g")
einfo "CC:  ${CC}"

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
	${CC} --version || die

	local modargs=(
		NIH_SOURCE="${KERNEL_DIR}"
	)
	KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
	MODULES_MAKEARGS=(
		V=1
		ARCH=$(tc-arch-kernel)
		CC="${CC}"
		CPP="${CC} -E"
		KDIR="/lib/modules/${KV_FULL}/build"
		NIH_KDIR="${KERNEL_DIR}"
		NIH_KSRC="${KERNEL_DIR}"
	)
	linux-mod-r1_src_compile

}

src_compile() {
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find "/usr/src/" -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				_src_compile_one "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			_src_compile_one "${k}"
		else
			_src_compile_one "${k}"
		fi
	done
}

_src_install_one() {
	local k="${1}"
	local modlist=()
	if use allegro ; then
		modlist=(
			tcp_pcc="kernel/net/ipv4:${WORKDIR}/allegro-${k}/src:${WORKDIR}/allegro-${k}/src:default"
		)
		d="${WORKDIR}/allegro-${k}"
	fi
	if use vivace ; then
		modlist=(
			tcp_pcc="kernel/net/ipv4:${WORKDIR}/vivace-${k}/src:${WORKDIR}/vivace-${k}/src:default"
		)
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
	insinto "/lib/modules/${KV_FULL}/kernel/net/ipv4"
	doins "${WORKDIR}/vivace-${k}/src/tcp_pcc.ko"
	modules_post_process
}

src_install() {
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find "/usr/src/" -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			local v
			for v in ${V} ; do
				k="${v}"
				_src_install_one "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			_src_install_one "${k}"
		else
			_src_install_one "${k}"
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

_pkg_postinst_one() {
	local k="${1}"
	KERNEL_DIR="/usr/src/linux-${k}"
	KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
	linux-mod-r1_pkg_postinst
}

pkg_postinst() {
	# Do it this way because linux-mod-r1_pkg_postinst is bugged
	local d
	local k
	for k in ${PCC_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find "/usr/src/" -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			local v
			for v in ${V} ; do
				k="${v}"
				_pkg_postinst_one "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find "/usr/src/" -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||" \
				| sed -e "/^$/d")
			_pkg_postinst_one "${k}"
		else
			_pkg_postinst_one "${k}"
		fi
	done
}
