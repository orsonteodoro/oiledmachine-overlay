# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild uses the exact revision in 111_p20170609.

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin secure-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT=( "gcc" "llvm" ) # Needs integration testing
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="PE"
LANGS=( "ca" )
PYTHON_COMPAT=( "python3_11" )

inherit autotools cflags-hardened flag-o-matic linux-info pam python-single-r1

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
EBRZ_REPO_URI="lp:~ecryptfs/ecryptfs/trunk"
EBRZ_REVISION="$(ver_cut 3)"

DESCRIPTION="eCryptfs userspace utilities"
HOMEPAGE="https://launchpad.net/ecryptfs"
LICENSE="
	CC-BY-SA-3.0
	GPL-2
	GPL-2+
	GPL-2-with-linking-exception
	python? (
		GPL-3+
	)
"
RESTRICT="fetch"
SLOT="0"
IUSE+="
${LANGS[@]/#/l10n_}
doc gpg gtk nls openssl pam pkcs11 python suid test tpm
ebuild_revision_26
"
REQUIRED_USE+="
	pam? (
		suid
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
RDEPEND+="
	>=sys-apps/keyutils-1.5.11-r1:=
	>=dev-libs/libgcrypt-1.2.0:0
	dev-libs/nss
	sys-devel/gettext
	gpg? (
		app-crypt/gpgme
	)
	gtk? (
		x11-libs/gtk+:2
	)
	openssl? (
		>=dev-libs/openssl-0.9.7:=
	)
	pam? (
		sys-libs/pam
	)
	pkcs11? (
		>=dev-libs/openssl-0.9.7:=
		>=dev-libs/pkcs11-helper-1.04
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/future[${PYTHON_USEDEP}]
		')
	)
	tpm? (
		app-crypt/trousers
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/intltool-0.41.0
	$(python_gen_cond_dep '
		dev-vcs/breezy[${PYTHON_USEDEP}]
	')
	sys-devel/gettext
	virtual/pkgconfig
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-111-python3-ac_python_devel_m4.patch"
	"${FILESDIR}/${PN}-111-swig-fixes.patch"
	"${FILESDIR}/${PN}-111-update-libecryptfs_i.patch"
	"${FILESDIR}/${PN}-112_pre894-fix-tests.patch"
)

pkg_setup() {
	einfo "EBRZ_REVISION=${EBRZ_REVISION}"
	python-single-r1_pkg_setup
	CONFIG_CHECK="~ECRYPT_FS"
	linux-info_pkg_setup
	sandbox-changes_no_network_sandbox "To download the project"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	addwrite "${distdir}"
	if [[ ! -d "${distdir}/ecryptfs-utils-src" ]] ; then
		mkdir -p "${distdir}/ecryptfs-utils-src" || die
	fi
	chown portage:portage "${distdir}/ecryptfs-utils-src" || die
	if use test ; then
		if [[ ! "${FEATURES}" =~ test ]] ; then
eerror
eerror "The test USE flag requires the environmental variable test to be added"
eerror "to FEATURES"
eerror
			die
		fi
	fi
einfo "EPYTHON: ${EPYTHON}"
}

src_unpack() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
einfo "Remove ${distdir}/ecryptfs-utils-src if it fails."
	addwrite "${distdir}/ecryptfs-utils-src"
	cd "${distdir}/ecryptfs-utils-src" || die
	if [[ ! -f "${distdir}/ecryptfs-utils-src/configure.ac" ]] ; then
		brz init-repo . || die
		brz branch ${EBRZ_REPO_URI} . || die
		brz reconfigure --tree || die
	fi
	brz update -r${EBRZ_REVISION} || die
	mkdir -p "${S}" || die
	cp -a . "${S}" || die
	cd "${S}" || die
}

src_prepare() {
	default
	eautoreconf
	if use python ; then
		futurize -0 -v -w "./" || die
	fi
	if use python ; then
		# Remove to regenerate  Don't fail on cached version.
		rm "src/libecryptfs-swig/libecryptfs_wrap.c" || die
		sed -i \
			-e "s|#!/usr/bin/env python|#!/usr/bin/env ${EPYTHON}|g" \
			"src/python/ecryptfsapi.py" || die
	fi
}

src_configure() {
	cflags-hardened_append
	append-cppflags -D_FILE_OFFSET_BITS=64
	local myconf=(
		--enable-nss
		--libdir=/usr/$(get_libdir)
		--with-pamdir=$(getpam_mod_dir)
		$(use_enable doc docs)
		$(use_enable gpg)
		$(use_enable gtk gui)
		$(use_enable nls)
		$(use_enable openssl)
		$(use_enable pam)
		$(use_enable pkcs11 pkcs11-helper)
		$(use_enable python pywrap)
		$(use_enable test tests)
		$(use_enable tpm tspi)
	)
	econf ${myconf[@]}
}

src_test() {
	if use test ; then
		pushd "tests" || die
			./run_tests.sh -U -c "safe" || die
			if use python ; then
				PYTHONPATH="${S}/src/libecryptfs-swig:${PYTHONPATH}" \
				LD_LIBRARY_PATH="${S}/src/libecryptfs-swig/.libs:${LD_LIBRARY_PATH}" \
				"${EPYTHON}" -c "import libecryptfs" || die
			fi
		popd
	fi
}

_install_specific_locales() {
	[[ ! -d "${ED}/usr/share/locale/" ]] && return
	mkdir -p "${T}/langs" || die
	mv "${ED}/usr/share/locale/"* "${T}/langs" || die
	insinto "/usr/share/locale"
	for l in ${L10N} ; do
		einfo "Installing language ${l}"
		doins -r "${T}/langs/${l}"
	done
}

src_install() {
	emake DESTDIR="${D}" install
	if use python; then
		echo "ecryptfs-utils" > "${T}/ecryptfs-utils.pth" || die
		insinto $(python_get_sitedir)
		doins "${T}/ecryptfs-utils.pth"
		head \
			-n 21 \
			"src/python/ecryptfsapi.py" \
			> \
			"${T}/LICENSE.ecryptfsapi"
		docinto "licenses"
		dodoc "${T}/LICENSE.ecryptfsapi"
	fi
	use suid && fperms u+s "/sbin/mount.ecryptfs_private"
	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
	docinto "licenses"
	dodoc "debian/copyright"
	dodoc "COPYING"
	if use doc ; then
		docinto "readmes"
		dodoc "AUTHORS" "ChangeLog" "CONTRIBUTING" "THANKS"
	fi

	_install_specific_locales
}

pkg_postinst() {
	if use suid; then
ewarn
ewarn "You have chosen to install ${PN} with the binary setuid root. This means"
ewarn "that if there are any undetected vulnerabilities in the binary, then"
ewarn "local users may be able to gain root access on your machine."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, source-directly-upstream, live-snapshot
# OILEDMACHINE-OVERLAY-TEST:  PASSED (112_pre894, 20250515) with Python 3.11
# test suite with clang:  passed
# test suite with gcc:  passed
