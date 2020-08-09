# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop eutils

DESCRIPTION="QB64 is a modern extended BASIC+OpenGL language that retains \
QB4.5/QBasic compatibility and compiles native binaries for Windows (XP and \
up), Linux and macOS."
HOMEPAGE="http://www.qb64.net/"
# Many licenses because of the mingw compiler and internal third party packages
LICENSE="Apache-2.0 BSD CC-BY-SA-3.0 CC0-1.0 FTL \
gcc-runtime-library-exception-3.1 GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT \
openssl SGI-B-2.0 ZLIB ZPL"
KEYWORDS="~amd64 ~x86"
SRC_URI=\
"https://github.com/Galleondragon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE="android samples"
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

src_prepare() {
	default
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;

	if [[ -z "${QB64_USERS}" ]]; then
		eerror \
"You need to have per package environmental variable named QB64_USERS that is\n\
semicolon delimited of all the users that want this\n\
package.\n\
\n\
It should look like:\n\
QB64_USERS=\"person1;person2;person3\""
		die
	fi
}

src_compile() {
	sed -i "s|./${PN} &||g" setup_lnx.sh || die
	sed -i "s|\
cat > ~/.local/share/applications/${PN}.desktop <<EOF|\
cat > ${T}/${PN}.desktop <<EOF|g" setup_lnx.sh || die
	./setup_lnx.sh
}

# Sets file permissions and owner to get product working
fpo() {
	fperms g+w $@
	fowners ${name}:${name} $@
}

# Recursive version
fpor() {
	fperms g+w $@
	fowners -R ${name}:${name} $@
}

fix_perms() {
	# Relax permissions in order for it to function properly or run
	# examples.
	fpo "${prefix}" \
	    "${prefix}/internal/" \
	    "${prefix}/internal/c/makedat_lnx32.txt" \
	    "${prefix}/internal/c/makedat_lnx64.txt" \
	    "${prefix}/internal/c/makeline_lnx.txt" \
	    $(find "${ED}${prefix}/programs" -name "*.bas" \
		| sed -e "s|${ED}||") \
	    $(find "${ED}${prefix}/source/virtual_keyboard" -name "*.bas" \
		| sed -e "s|${ED}||")
	fpor $(find "${ED}${prefix}/internal" -type d -name "temp" \
		-o -name "lnx" | sed -e "s|${ED}||")
}

_per_user_installer() {
	local name="${1}"
	local home="${2}"

	local prefix="/opt/${PN}/${name}"

	exeinto "${prefix}"
	doexe ${PN}

	insinto "${prefix}"
	doins -r internal LICENSE source

	insinto "${prefix}/programs"
	use samples && doins -r programs/samples
	use android && doins -r programs/android

	# It needs to be done this way so that users do not delete each other
	# projects or inject malicious scripts inside the wrappers or add
	# malicious programs in the compiled output folder.  When the users
	# in the "users" group have write permission and the files are marked
	# "users", it is insecure and can cause the above problems.  If you
	# use another group name like "qb64", it is still insecure.
	fix_perms
	fowners -R ${name}:${name} "${prefix}" || die
}

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"

	OIFS="${IFS}"
	IFS=';'
	for p in ${QB64_USERS} ; do
	        IFS=':' read -ra U <<< "${p}"
		IFS="${OIFS}"
		local user="${U[0]}"
		local home_path="${U[1]}"
		einfo "Installing a copy for ${user} at /opt/${PN}/${user}"
		_per_user_installer "${user}" "${home_path}"
	done
	IFS="${OIFS}"

	newicon -s 32 internal/source/${PN}icon32.png ${PN}.png
	make_desktop_entry "/usr/bin/${PN}" "${PN^^} Programming IDE" \
		"/usr/share/pixmaps/${PN}.png" "Development;IDE"
}

pkg_postinst() {
	einfo \
"If you are playing sound, ${PN} may not run your program.  Close the other\n\
sound program and try running again."
	ewarn \
"This product contains internal dependencies with critical vulnerabilities.\n\
For details see:\n\
bzip2:  https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=bz2&search_type=all\n\
Python 2.7:  https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%202.7&search_type=all"
}
