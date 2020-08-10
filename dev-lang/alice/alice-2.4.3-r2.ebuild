# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit check-reqs desktop eutils

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
MY_V="$(ver_cut 1-2 ${PV})"
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

CHECKREQS_DISK_BUILD="804M"
CHECKREQS_DISK_USR="804M"

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
		d="/opt/alice2/${l}"
		S="${WORKDIR}/${l}/Alice ${MY_V}"
		insinto "${d}"
		doins -r "${S}"/Required/*
		fperms g+x "${d}"/run-alice
		fowners root:users "${d}"/run-alice

		ewarn "TODO/FIXME: fix possible security problem (folder with users group with g+w) with ${d}/jython-2.1/cachedir/packages in src_install"
		dodir "${d}"/jython-2.1/cachedir/packages
		fperms g+w "${d}"/jython-2.1/cachedir/packages
		fowners root:users "${d}"/jython-2.1/cachedir/packages

		cd "${S}/Required/lib"
		jar xvf alice.jar "edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif" || die
		newicon edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif alice2.gif
		rm -rf edu || die

		cp "${FILESDIR}/alice2-en" "${T}/alice2-${l}" || die
		sed -i -e "s|/opt/alice2/en|/opt/alice2/${l}|g" "${T}/alice2-${l}" || die
		exeinto /usr/bin
		doexe "${T}/alice2-${l}"

		make_desktop_entry "/usr/bin/${cmd}" "Alice 2 (${l})" "/usr/share/pixmaps/alice2.gif" "Education;ComputerScience"
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
