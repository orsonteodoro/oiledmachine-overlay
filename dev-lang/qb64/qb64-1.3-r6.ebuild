# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils

DESCRIPTION="QB64 is a modern extended BASIC+OpenGL language that retains QB4.5/QBasic compatibility and compiles native binaries for Windows (XP and up), Linux and macOS."
HOMEPAGE="http://www.qb64.net/"
# Many licenses because of the mingw compiler and internal third party packages
LICENSE="Apache-2.0 BSD CC-BY-SA-3.0 CC0-1.0 FTL gcc-runtime-library-exception-3.1 GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT openssl SGI-B-2.0 ZLIB ZPL"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Galleondragon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE="android +auto-install-per-user pkg-config samples systemwide"
RDEPEND="android? ( dev-util/android-studio )
         media-libs/libsdl
	 media-libs/sdl-image
	 media-libs/sdl-mixer
         media-libs/sdl-net
	 media-libs/sdl-ttf"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${PV}"
CHECKREQS_DISK_BUILD="808M"
CHECKREQS_DISK_USR="795M"
PROPERTIES="interactive"
REQUIRED_USE="^^ ( auto-install-per-user pkg-config systemwide )"

src_prepare() {
	use systemwide && ewarn "Systemwide is insecure and not multiuser safe."

	default
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;

	if use auto-install-per-user ; then
		if [[ -z "${QB64_USERS}" ]]; then
			eerror "You need to have per package environmental variable named QB64_USERS that is semicolon delimited of all the user:home_directory_path pairs that want this package."
			eerror "It should look like:  QB64_USERS=\"person1:/home/person1;person2:/home/my home;person3:/home/person3 home\""
			die
		fi
	fi
}

src_compile() {
	sed -i "s|./${PN} &||g" setup_lnx.sh || die
	sed -i "s|cat > ~/.local/share/applications/${PN}.desktop <<EOF|cat > ${T}/${PN}.desktop <<EOF|g" setup_lnx.sh || die
	./setup_lnx.sh
}


# Sets file permissions and owner to get product working
fpo() {
	if [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]] ; then
		chmod g+w $@ || die
		chown ${name}:${name} $@ || die
	else
		fperms g+w $@
		fowners root:users $@
	fi
}

# Recursive version
fpor() {
	if [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]] ; then
		chmod g+w $@ || die
		chown -R ${name}:${name} $@ || die
	else
		fperms g+w $@
		fowners -R root:users $@
	fi
}

fix_perms() {
	# Relax permissions in order for it to function properly or run examples.
	fpo "${prefix}" \
	    "${prefix}/internal/" \
	    "${prefix}/internal/c/makedat_lnx32.txt" \
	    "${prefix}/internal/c/makedat_lnx64.txt" \
	    "${prefix}/internal/c/makeline_lnx.txt" \
	    $(find "${d}${prefix}/programs" -name "*.bas" | sed -e "s|${d}||") \
	    $(find "${d}${prefix}/source/virtual_keyboard" -name "*.bas" | sed -e "s|${d}||")
	fpor $(find "${d}${prefix}/internal" -type d -name "temp" -o -name "lnx" | sed -e "s|${d}||")
}

src_install() {
	if use systemwide || use pkg-config ; then
		local prefix="/opt/${PN}"
		exeinto "${prefix}"
		doexe ${PN}

		insinto "${prefix}"
		doins -r internal LICENSE source

		insinto "${prefix}/programs"
		use samples && doins -r programs/samples
		use android && doins -r programs/android
	fi

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	if use systemwide ; then
		sed -i -e "s|/usr/lib64/qb64|${prefix}|" "${D}/usr/bin/${PN}" || die
	else
		sed -i -e "s|/usr/lib64/qb64|\${HOME}/.bin/${PN}|" "${D}/usr/bin/${PN}" || die
	fi

	# TODO: for systemwide ... it may need a mutex check in /usr/bin/${PN} to isolate simultaneous compiles via qb64 run command

	if use systemwide ; then
		d="${D}" \
		fix_perms
	fi

	if use auto-install-per-user ; then
		OIFS="${IFS}"
		IFS=';'
		for p in ${QB64_USERS} ; do
		        IFS=':' read -ra U <<< "${p}"
			IFS="${OIFS}"
			local user="${U[0]}"
			local home_path="${U[1]}"
			einfo "Installing a copy for ${user} at ${home_path}"
			_per_user_installer "${user}" "${home_path}"
		done
	fi

	newicon internal/source/${PN}icon32.png ${PN}.png
	make_desktop_entry "/usr/bin/${PN}" "${PN^^} Programming IDE" "/usr/share/pixmaps/${PN}.png" "Development;IDE"
}

pkg_postinst() {
	einfo "If you are playing sound, ${PN} may not run your program.  Close the other sound program and try running again."
	einfo "You need to be part of the users group in order to run ${PN}."
	if use pkg-config ; then
		einfo "Do \`emerge --config qb64\` to install qb64 on the user profile."
	fi
}

_per_user_installer() {
	local name="${1}"
	local home="${2}"

	local user_bin="${home}/.bin"
	local prefix="${user_bin}/${PN}"

	# It is userstood that ${home}/.bin is an unencrypted part of the filesystem
	# just override if it already exists for updates
	exeinto "${prefix}"
	doexe ${PN}

	insinto "${prefix}"
	doins -r internal LICENSE source

	insinto "${prefix}/programs"
	use samples && doins -r programs/samples
	use android && doins -r programs/android

	d="${D}" \
	fix_perms
	fowners -R ${name}:${name} "${prefix}" || die
}

pkg_config() {
	if use pkg-config ; then
		local home
		local existing
		read -p "Enter the user's login name for ownership:  " name
		export name
		read -p "Enter the path of the user's home directory:  " home
		read -p "Do you want to delete the existing user's installation? (y/n):  " existing

		local user_bin="${home}/.bin"
		local prefix="${user_bin}/${PN}"

		if [[ "${existing,,}" =~ y ]] ; then
			# preserve user files
			local d="${user_bin}/programs-$(date +%Y%m%d_%H%M)"
			if [ -d "${prefix}/programs" ] ; then
				cp -a "${prefix}/programs" "${d}" || die
				mkdir -p "${d}/found" || die
				find "${prefix}" -maxdepth 1 -iname "*.bas" -exec cp -a '{}' "${d}/found" \;
				ewarn "Your saved programs have been moved to ${d} and in ${d}/found"
			fi
			rm -rf "${prefix}"
		else
			einfo "Aborting per user install"
			return 0
		fi

		local logged
		w | grep -F "${name}" > /dev/null || read -p "User didn't log on.  They need to log on to decrypt or mount their home directory.  Did they log in? (y/n):  "
		if w | grep -F "${name}" > /dev/null ; then
			mkdir -p "${home}/.bin" || die
			cp -a /opt/${PN} "${home}/.bin" || die
			d="" \
			fix_perms
			chown -R ${n}:${n} "${prefix}" || die
		else
			einfo "Aborting.  User didn't log on."
		fi
	fi
}
