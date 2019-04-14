# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils versionator #check-reqs

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
MY_V="$(get_version_component_range 1-2 ${PV})"
FILE_V="${MY_V//./_}"
LANGS="en es"
SRC_URI="l10n_en? ( minimal? ( http://www.alice.org/wp-content/uploads/2017/05/Alice${FILE_V}c.tar )
		       !minimal? ( http://www.alice.org/wp-content/uploads/2017/05/Alice${FILE_V}e.tar  ) )
	 l10n_es? ( http://www.alice.org/wp-content/uploads/2017/05/Alice${FILE_V}s.tar.gz )"

LICENSE="ALICE2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="minimal +l10n_en l10n_es"
RDEPEND="|| ( virtual/jre virtual/jdk  )"
DEPEND="${RDEPEND}"
REQUIRED_USE="|| ( l10n_en l10n_es )"

#CHECKREQS_DISK_BUILD="914M"
#CHECKREQS_DISK_USR="475M"

S="${WORKDIR}/Alice ${MY_V}"

src_unpack() {
	if use l10n_en ; then
		S="${WORKDIR}/en"
		mkdir -p "${S}"
		cd "${S}"
		if use minimal ; then
			unpack "Alice${FILE_V}c.tar"
		else
			unpack "Alice${FILE_V}e.tar"
		fi
	fi
	if use l10n_es ; then
		S="${WORKDIR}/es"
		mkdir -p "${S}"
		cd "${S}"
		unpack "Alice${FILE_V}s.tar.gz"
	fi
}

src_install() {
	local d

	for l in ${L10N} ; do
		einfo "Installing for language ${l}"
		l="${l}"
		d="/opt/alice2/${l}"
		if [[ "${l}" == "en" ]] ; then
			S="${WORKDIR}/en/Alice ${MY_V}"
		elif [[ "${l}" == "es" ]] ; then
			S="${WORKDIR}/es/Alice ${MY_V}"
		fi
		dodir "${d}"
		insinto "${d}"
		doins -r "${S}"/Required/*
		fperms o+x "${d}"/run-alice
		dodir "${d}"/jython-2.1/cachedir/packages
		fperms o+w "${d}"/jython-2.1/cachedir/packages

		cd "${S}/Required/lib"
		jar xvf alice.jar "edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif"
		dodir /usr/share/alice2
		insinto "${d}"
		doins edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif
		rm -rf edu

		dodir /usr/bin
		exeinto /usr/bin

		local cmd="alice2-${l}"
		echo '#!/bin/bash' > ${cmd} || die
		echo 'which wmname' >> ${cmd} || die
		echo 'R_WMNAME="$?"' >> ${cmd} || die
		echo 'pidof dwm > /dev/null' >> ${cmd} || die
		echo 'R_DWM="$?"' >> ${cmd} || die
		echo 'if [[ "$R_DWM" == "0" && "$R_WMNAME" == "0" ]] ; then' >> ${cmd} || die
		echo '  wmname LG3D &' >> ${cmd} || die
		echo 'fi' >> ${cmd} || die
		echo "cd \"${d}\"" >> ${cmd} || die
		echo './run-alice' >> ${cmd} || die
		doexe ${cmd}

		make_desktop_entry "/usr/bin/${cmd}" "Alice 2 ${l}" "/usr/share/alice2/aliceHead.gif" "Education;ComputerScience"
	done

	exeinto /usr/bin
	if [ -e /usr/bin/alice2-en ] ; then
		dosym /usr/bin/alice2-en /usr/bin/alice2
	else
		dosym /usr/bin/alice2-es /usr/bin/alice2
	fi
}

pkg_postinst() {
	elog "If you are using dwm or non-parenting window manager or just get grey windows, you need to:"
	elog "  emerge wmname"
	elog "  wmname LG3D"
	elog "Run 'wmname LG3D' before you run 'run-alice'"
}
