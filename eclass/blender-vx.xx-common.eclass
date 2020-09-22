# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-vx.xx-common.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender common implementation
# @DESCRIPTION:
# The blender vx.xx common eclass helps reduce code duplication
# across the blender eclasses to reduce maintenance cost.

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS=${KEYWORDS:="~amd64 ~x86"}

get_dest() {
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		echo "/usr/share/${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	else
		echo "/usr/bin/.${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	fi
}

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

# Dependency PreFiX
dpfx() {
	echo "${EROOT}/usr/$(get_libdir)/${PN}"
}

# EROOT Dependency PreFiX
erdpfx() {
	echo "${EROOT}/$(dpfx)"
}

blender_pkg_pretend() {
	blender_check_requirements
}

check_amdgpu_pro() {
	if ( has_version 'media-libs/mesa[libglvnd]' \
		&& has_version 'x11-drivers/amdgpu-pro[opengl_pro]') \
	|| ( has_version 'media-libs/mesa[libglvnd]' \
		&& has_version 'x11-drivers/amdgpu-pro-lts[opengl_pro]'); then
		die \
"You must switch to x11-drivers/amdgpu-pro[opengl_mesa] or \
x11-drivers/amdgpu-pro-lts[opengl_mesa] instead"
	fi
}

check_cpu() {
	grep -q -i -E -e 'abm( |$)' /proc/cpuinfo
	local has_abm="$?"
	grep -q -i -E -e 'bmi1( |$)' /proc/cpuinfo
	local has_bmi1="$?"
	grep -q -i -E -e 'f16c( |$)' /proc/cpuinfo
	local has_f16c="$?"
	grep -q -i -E -e 'fma( |$)' /proc/cpuinfo
	local has_fma="$?"
	grep -q -i -E -e 'ssse3( |$)' /proc/cpuinfo
	local has_ssse3="$?"

	# For tzcnt
	if use cpu_flags_x86_bmi ; then
		if [[ "${has_bmi1}" != "0" ]] ; then
			ewarn \
"bmi may not be supported on your CPU and was enabled via cpu_flags_x86_bmi"
		fi
	fi

	if use cpu_flags_x86_f16c ; then
		if [[ "${has_f16c}" != "0" ]] ; then
			ewarn \
"f16c may not be supported on your CPU and was enabled via cpu_flags_x86_f16c"
		fi
	fi

	if use cpu_flags_x86_fma ; then
		if [[ "${has_fma}" != "0" ]] ; then
			ewarn \
"fma may not be supported on your CPU and was enabled via cpu_flags_x86_fma"
		fi
	fi

	if use cpu_flags_x86_lzcnt ; then
		if [[ "${has_bmi1}" != "0" && "${has_abm}" != "0" ]] ; then
			ewarn \
"lzcnt may not be supported on your CPU and was enabled via cpu_flags_x86_lzcnt"
		fi
	fi

	if use cpu_flags_x86_ssse3 ; then
		if [[ "${has_ssse3}" != "0" ]] ; then
			ewarn \
"ssse3 may not be supported on your CPU and was enabled via cpu_flags_x86_ssse3"
		fi
	fi

}

check_optimal_compiler_for_cycles_x86() {
	if [[ "${ABI}" == "x86" ]] ; then
		# Cycles says that a bug might be in in gcc so use clang or icc.
		# If you use gcc, it will not optimize cycles except with maybe sse2.
		if [[ -n "${BLENDER_CC_ALT}" && -n "${BLENDER_CXX_ALT}" ]] ; then
			export CC=${BLENDER_CC_ALT}
			export CXX=${BLENDER_CXX_ALT}
		elif [[ -n "${CC}" && -n "${CXX}" ]] \
			&& [[ ! ( "${CC}" =~ gcc ) ]] \
			&& [[ ! ( "${CXX}" =~ "g++" ) ]] ; then
			# Defined by user from per-package environmental variables.
			export CC
			export CXX
		elif has_version 'sys-devel/clang' ; then
			export CC=clang
			export CXX=clang++
		elif has_version 'dev-lang/icc' ; then
			export CC=icc
			export CXX=icpc
		fi
	else
		if [[ ! -n "${CC}" || ! -n "${CXX}" ]] ; then
			export CC=$(tc-getCC $(get_abi_CHOST "${ABI}"))
			export CXX=$(tc-getCXX $(get_abi_CHOST "${ABI}"))
		fi
	fi

	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
}

blender_pkg_setup_common() {
	llvm_pkg_setup
	blender_check_requirements
	python-single-r1_pkg_setup
	check_amdgpu_pro
	check_cpu
	check_optimal_compiler_for_cycles_x86
}

_src_compile() {
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_compile
}

_src_compile_docs() {
	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background \
			--python doc/python_api/sphinx_doc_gen.py -noaudio \
			|| die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

blender_src_compile() {
	blender_compile() {
		cd "${BUILD_DIR}" || die
		_src_compile
		if [[ "${EBLENDER}" == "build_creator" ]] ; then
			_src_compile_docs
		fi
	}
	blender_foreach_impl blender_compile
}

_src_test() {
	if use test; then
		einfo "Running Blender Unit Tests for ${EBLENDER} ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

blender_src_test() {
	blender_test() {
		cd "${BUILD_DIR}" || die
		_src_test
	}
	blender_foreach_impl blender_test
}

_src_install_cycles_network() {
	if use cycles-network ; then
		exeinto "${d_dest}"
		dosym "../../..${d_dest}/cycles_server" \
			"/usr/bin/cycles_server-${SLOT_MAJ}" || die
		doexe "${CMAKE_BUILD_DIR}${d_dest}/cycles_server"
	fi
}

_src_install_doc() {
	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die
}

install_licenses() {
	for f in $(find "${BUILD_DIR}" -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -path "*/license/*" \
	  -o -path "*/macholib/README.ctypes" \
	  -o -path "*/materials_library_vx/README.txt" ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
}

install_readmes() {
	for f in $(find "${BUILD_DIR}" -iname "*readme*") ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		docinto "readmes/${d}"
		dodoc -r "${f}"
	done
}

_src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_install
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		CMAKE_USE_DIR="${BUILD_DIR}" \
		_src_install_doc
	fi

	local d_dest=$(get_dest)
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		python_fix_shebang "${ED%/}${d_dest}/blender-thumbnailer.py"
		python_optimize "${ED%/}/usr/share/${PN}/${SLOT_MAJ}/scripts"
	fi

	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		_src_install_cycles_network
	fi

	_LD_LIBRARY_PATH=()
	_PATH=()
	if declare -f blender_set_wrapper_deps > /dev/null ; then
		blender_set_wrapper_deps
	fi
	_LD_LIBRARY_PATH=$(echo -e "${_LD_LIBRARY_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")
	_PATH=$(echo -e "${_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")

	local ed_icon_hc
	if $(ver_cut 1-2 ${PV}) -lt 2.80 ; then
		ed_icon_hc="${ED}/usr/share/icons/hicolor"
	fi
	local suffix=
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications"/blender{,-${SLOT_MAJ}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT_MAJ}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=/usr/bin/${PN}-${SLOT_MAJ}|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT_MAJ}|g" "${menu_file}" || die
		if $(ver_cut 1-2 ${PV}) -lt 2.80 ; then
			for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
				mv "${ed_icon_hc}/"${size}"/apps/blender"{,-${SLOT_MAJ}}".png" || die
			done
			mv "${ed_icon_hc}/scalable/apps/blender"{,-${SLOT_MAJ}}".svg" || die
		fi
		if [[ -n "${IS_LTS}" && "${IS_LTS}" == "1" ]] ; then
			touch "${ED}/${d_dest}/.lts"
		fi
	fi

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		if [[ "${EBLENDER_NAME}" == "creator" ]] ; then
			suffix=""
		elif [[ "${EBLENDER_NAME}" == "headless" ]] ; then
			suffix="-headless"
		fi
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		if declare -f blender_set_wrapper_deps > /dev/null ; then
			sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
				-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}\"|g" \
				-e "s|#PATH|export PATH=\"${_PATH}\"|g" \
				"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		else
			sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
				"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		fi
		exeinto /usr/bin
		doexe "${T}/${PN}${suffix}-${SLOT_MAJ}"
		if use cycles-network ; then
			cp "${FILESDIR}/blender-wrapper" \
				"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			if declare -f blender_set_wrapper_deps > /dev/null ; then
				sed -i -e "s|\${BLENDER_EXE}|${d_dest}/cycles_network|g" \
					-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}\"|g" \
					-e "s|#PATH|export PATH=\"${_PATH}\"|g" \
					"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			else
				sed -i -e "s|\${BLENDER_EXE}|${d_dest}/cycles_network|g" \
					"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			fi
			doexe "${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}"
		fi
	fi
	install_licenses
	if use doc ; then
		install_readmes
	fi
}

blender_src_install() {
	blender_install() {
		cd "${BUILD_DIR}" || die
		_src_install
	}
	blender_foreach_impl blender_install
	local ed_icon_hc="${ED}/usr/share/icons/hicolor"
	local ed_icon_scale="${ed_icon_hc}/scalable"
	local ed_icon_sym="${ed_icon_hc}/symbolic"
	if $(ver_cut 1-2 "${PV}") -lt "2.80" ; then
		if [[ -d "${ed_icon_hc}" ]] ; then
			for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
				mv "${ed_icon_hc}/"${size}"/apps/blender"{,-${SLOT_MAJ}}".png" || die
			done
		fi
	fi
	if [[ -e "${ed_icon_scale}/apps/blender.svg" ]] ; then
		mv "${ed_icon_scale}/apps/blender"{,-${SLOT_MAJ}}".svg" || die
		if $(ver_cut 1-2) -ge 2.80 ; then
			mv "${ed_icon_sym}/apps/blender-symbolic"{,-${SLOT_MAJ}}".svg"
		fi
	fi
	rm -rf "${ED}/usr/share/applications/blender.desktop" || die
	if [[ -d "${ED}/usr/share/doc/blender" ]] ; then
		mv "${ED}/usr/share/doc/blender"{,-${SLOT_MAJ}} || die
	fi
	mv "${ED}/usr/share/man/man1/blender"{,-${SLOT_MAJ}}".1"
}

blender_pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	if use cycles-network ; then
		einfo
		ewarn "The Cycles Networking support is experimental and"
		ewarn "incomplete."
		einfo
		einfo "To make a OpenCL GPU available do:"
		einfo "cycles_server --device OPENCL"
		einfo
		einfo "To make a CUDA GPU available do:"
		einfo "cycles_server --device CUDA"
		einfo
		einfo "To make a CPU available do:"
		einfo "cycles_server --device CPU"
		einfo
		einfo "Only one instance of a cycles_server can be used on a host."
		einfo
		einfo "You may want to run cycles_server on the client too, but"
		einfo "it is not necessary."
		einfo
		einfo "Clients need to set the Rendering Engine to Cycles and"
		einfo "Device to Networked Device.  Finding the server is done"
		einfo "automatically."
		einfo
	fi
	xdg_pkg_postinst
	local d_src="${EROOT}/usr/bin/.${PN}"
	local V=""
	if [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# highest lts
		V=$(ls "${d_src}"/*/creator/.lts | sort -V | tail -n 1 \
			| cut -f 5 -d "/")
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# highest v
		V=$(ls "${EROOT}${d_src}/" | sort -V | tail -n 1)
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
		# custom v
		V=$(echo "${BLENDER_MAIN_SYMLINK_MODE}" | cut -f 2 -d "-")
	fi
	if [[ -n "${V}" ]] ; then
		if use build_creator ; then
			ln -sf "${EROOT}/usr/bin/${PN}-${V}" \
				"${EROOT}/usr/bin/${PN}" || die
			if use cycles-network ; then
				ln -sf "${EROOT}/usr/bin/cycles_server-${V}" \
					"${EROOT}/usr/bin/cycles_server" || die
			fi
		fi
		if use build_headless ; then
			ln -sf "${EROOT}/usr/bin/${PN}-headless-${V}" \
				"${EROOT}/usr/bin/${PN}-headless" || die
			if use cycles-network ; then
				ln -sf "${EROOT}/usr/bin/cycles_server_headless-${V}" \
					"${EROOT}/usr/bin/cycles_server_headless" || die
			fi
		fi
	fi
}

blender_pkg_postrm() {
	xdg_pkg_postrm

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${SLOT_MAJ}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
	if [[ ! -d "${EROOT}/usr/bin/.blender" ]] ; then
		if [[ -e "${EROOT}/usr/bin/blender" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender" || die
		fi
		if [[ -e "${EROOT}/usr/bin/blender-headless" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender-headless" || die
		fi
		if [[ -e "${EROOT}/usr/bin/cycles_server" ]] ; then
			rm -rf "${EROOT}/usr/bin/cycles_server" || die
		fi
		if [[ -e "${EROOT}/usr/bin/cycles_server_headless" ]] ; then
			rm -rf "${EROOT}/usr/bin/cycles_server_headless" || die
		fi
	fi
}
