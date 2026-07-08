# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The Debian ca-certificates package merely takes the CA database as it exists
# in the nss package and repackages it for use by openssl.
#
# The issue with using the compiled debs directly is two fold:
# - they do not update frequently enough for us to rely on them
# - they pull the CA database from nss tip of tree rather than the release
#
# So we take the Debian source tools and combine them with the latest nss
# release to produce (largely) the same end result.  The difference is that
# now we know our cert database is kept in sync with nss and, if need be,
# can be sync with nss tip of tree more frequently to respond to bugs.

# Where possible, bump to stable/LTS releases of NSS for the last part
# of the version (when not using a pure Debian release).

# When triaging user reports, refer to our wiki for tips:
# https://wiki.gentoo.org/wiki/Certificates#Debugging_certificate_issues

EAPI=8

# This ebuild fork uses AI for clarification, USE description, testing

PYTHON_COMPAT=( python3_{10..14} )

# For releases, see also https://sources.debian.org/src/ca-certificates/
# For the type of release, see also https://firefox-source-docs.mozilla.org/security/nss/releases/index.html#mozilla-projects-nss-releases
# For certdata commits IDs, see https://github.com/mozilla/nss/commits/master/lib/ckfw/builtins/certdata.txt
NSS_LIVE_COMMIT="3729152fcc02ead350034bff2061a802610c11ee" # Jun 11, 2026 (NSS master) # oiledmachine-overlay preference
NSS_ESR_COMMIT="6e2ba79aada69c4f7d8dca95e93fcfe0248319aa" # Apr 22, 2026 (NSS 3.112.5) # distro preference
NSS_LATEST_COMMIT="3729152fcc02ead350034bff2061a802610c11ee" # Jun 11, 2026 (NSS 3.125)

NSS_FLAVORS=(
	"certdata-esr"
	"certdata-latest"
	"+certdata-live"
)

inherit edo prefix python-any-r1

# Compile from source ourselves.
PRECOMPILED=false

if [[ "${PRECOMPILED}" == "true" ]] ; then
	# Debian precompiled version.
	inherit unpacker
else
	DEB_VER=$(ver_cut 1)
fi

DESCRIPTION="Common CA Certificates PEM files"
HOMEPAGE="https://packages.debian.org/sid/ca-certificates"
NMU_PR=""
if ${PRECOMPILED} ; then
	SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}${NMU_PR:++nmu}${NMU_PR}_all.deb"
else
	SRC_URI="
		mirror://debian/pool/main/c/${PN}/${PN}_${DEB_VER}${NMU_PR:++nmu}${NMU_PR}.tar.xz
		cacert? (
			mirror://gentoo/d1/nss-cacert-class1-class3-r2.patch
		)
		certdata-esr? (
			https://github.com/mozilla/nss/raw/${NSS_ESR_COMMIT}/lib/ckfw/builtins/certdata.txt -> certdata-${NSS_ESR_COMMIT:0:7}.txt
			https://github.com/mozilla/nss/raw/${NSS_ESR_COMMIT}/lib/ckfw/builtins/nssckbi.h -> nssckbi-${NSS_ESR_COMMIT:0:7}.h
		)
		certdata-latest? (
			https://github.com/mozilla/nss/raw/${NSS_LATEST_COMMIT}/lib/ckfw/builtins/certdata.txt -> certdata-${NSS_LATEST_COMMIT:0:7}.txt
			https://github.com/mozilla/nss/raw/${NSS_LATEST_COMMIT}/lib/ckfw/builtins/nssckbi.h -> nssckbi-${NSS_LATEST_COMMIT:0:7}.h
		)
		certdata-live? (
			https://github.com/mozilla/nss/raw/${NSS_LIVE_COMMIT}/lib/ckfw/builtins/certdata.txt -> certdata-${NSS_LIVE_COMMIT:0:7}.txt
			https://github.com/mozilla/nss/raw/${NSS_LIVE_COMMIT}/lib/ckfw/builtins/nssckbi.h -> nssckbi-${NSS_LIVE_COMMIT:0:7}.h
		)
	"
fi

S="${WORKDIR}"

LICENSE="
	MPL-2.0
	GPL-2+
"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
${PRECOMPILED} || IUSE+=" cacert"
IUSE+=" ${NSS_FLAVORS[@]}"
REQUIRED_USE+="
	^^ (
		${NSS_FLAVORS[@]/+}
	)
"

BDEPEND="${COMMON_DEPEND}"
if ! ${PRECOMPILED} ; then
	BDEPEND+=" ${PYTHON_DEPS}"
fi

if ${PRECOMPILED} ; then
	DEPEND+=" !<sys-apps/portage-2.1.10.41"
fi

RDEPEND="
	${COMMON_DEPEND}
	${DEPEND}
"

pkg_setup() {
	# For the conversion to having it in CONFIG_PROTECT_MASK,
	# we need to tell users about it once manually first.
	[[ -f "${EPREFIX}"/etc/env.d/98ca-certificates ]] \
		|| ewarn "You should run update-ca-certificates manually after etc-update"

	if ! ${PRECOMPILED} ; then
		python-any-r1_pkg_setup
	fi
}

get_certdata_commit() {
	if use certdata-live ; then
		echo "${NSS_LIVE_COMMIT}"
	elif use certdata-esr ; then
		echo "${NSS_ESR_COMMIT}"
	elif use certdata-latest ; then
		echo "${NSS_LATEST_COMMIT}"
	fi
}

get_certdata_desc() {
	if use certdata-live ; then
		echo "live"
	elif use certdata-esr ; then
		echo "stable"
	elif use certdata-latest ; then
		echo "rolling"
	fi
}

src_unpack() {
einfo "PRECOMPILED:  ${PRECOMPILED}"
	if ! ${PRECOMPILED} ; then
		default
		# Initial 20200601 deb release had bad naming inside the debian source tarball.
		DEB_S="${WORKDIR}/${PN}-${DEB_VER}"
		DEB_BAD_S="${WORKDIR}/work"
		if [[ -d "${DEB_BAD_S}" ]] && [[ ! -d "${DEB_S}" ]] ; then
			mv "${DEB_BAD_S}" "${DEB_S}" || die
		fi
	fi

	# Do all the work in the image subdir to avoid conflicting with source
	# dirs in ${WORKDIR}.  Need to perform everything in the offset #381937
	mkdir -p "image/${EPREFIX}" || die
	cd "image/${EPREFIX}" || die

	${PRECOMPILED} && unpacker_src_unpack

	local d="${S}/${PN}/mozilla"
	mkdir -p "${d}" || die
	local commit_id=$(get_certdata_commit)
	local certdata_flavor=$(get_certdata_desc)
einfo "certdata.txt commit id:  ${commit_id}"
einfo "certdata.txt flavor:  ${certdata_flavor}"
	cat "${DISTDIR}/certdata-${commit_id:0:7}.txt" -> "${d}/certdata.txt" || die
	cat "${DISTDIR}/nssckbi-${commit_id:0:7}.h" > "${d}/nssckbi.h" || die
}

src_prepare() {
	cd "image/${EPREFIX}" || die

	if ! ${PRECOMPILED} ; then
		mkdir -p usr/sbin || die
		cp -p "${S}"/${PN}/sbin/update-ca-certificates \
			usr/sbin/ || die

		if use cacert ; then
			local d="${S}/${PN}/mozilla"
			cat "${DISTDIR}/nss-cacert-class1-class3-r2.patch" | tail -n +7 | cut -c 2- > "${T}/nss-cacert-class1-class3.dat" || die
			cat "${T}/nss-cacert-class1-class3.dat" >> "${d}/certdata.txt" || die
			grep -q -e "CA Cert Signing Authority" "${d}/certdata.txt" || die
		fi
	fi

	default
	eapply -p2 "${FILESDIR}"/${PN}-20250419-root.patch
	eapply -p2 "${FILESDIR}"/${PN}-20240203.3.98-update-ca-certificates-drop-pointless-dependency.patch

	if ! ${PRECOMPILED} ; then
		pushd "${S}/${PN}" >/dev/null || die
		# We patch out the dep on cryptography as it's not particularly useful
		# for us. Please see the discussion in bug #821706. Not to be removed lightly!
		eapply "${FILESDIR}"/${PN}-20230311.3.89-no-cryptography.patch
		popd >/dev/null || die
	fi

	hprefixify -q '"' -w '/^[A-Z]+=/' \
		usr/sbin/update-ca-certificates || die
}

src_compile() {
	cd "image/${EPREFIX}" || die

	local c="usr/share/${PN}"
	if ! ${PRECOMPILED} ; then
		local d="${S}/${PN}/mozilla"
		emake -C "${d}"

		# Now move the files to the same places that the precompiled would.
		mkdir -p etc/ssl/certs \
			etc/ca-certificates/update.d \
			"${c}"/mozilla \
			|| die
		if use cacert ; then
			mkdir -p "${c}"/cacert.org || die
			mv "${d}"/CA_Cert_Signing_Authority.crt \
				"${c}"/cacert.org/cacert.org_class1.crt || die
			mv "${d}"/CAcert_Class_3_Root.crt \
				"${c}"/cacert.org/cacert.org_class3.crt || die
		fi
		mv "${d}"/*.crt "${c}"/mozilla/ || die
	else
		mv usr/share/doc/{ca-certificates,${PF}} || die
	fi

	(
		echo "# Automatically generated by ${CATEGORY}/${PF}"
		echo "# Do not edit."
		cd "${c}" || die
		find * -name '*.crt' | LC_ALL=C sort
	) > etc/ca-certificates.conf

	edo sh usr/sbin/update-ca-certificates --sysroot "${S}/image"
}

src_install() {
	cp -pPR image/* "${D}"/ || die
	if ! ${PRECOMPILED} ; then
		cd ${PN} || die
		doman sbin/*.8
		dodoc debian/README.*
	fi

	echo 'CONFIG_PROTECT_MASK="/etc/ca-certificates.conf"' > 98ca-certificates || die
	doenvd 98ca-certificates
}

pkg_postinst() {
	if [[ -d "${EROOT}/usr/local/share/ca-certificates" ]] ; then
		# If the user has local certs, we need to rebuild again
		# to include their stuff in the db.
		# However it's too overzealous when the user has custom certs in place.
		# --fresh is to clean up dangling symlinks
		"${EROOT}"/usr/sbin/update-ca-certificates --sysroot "${ROOT}"
	fi

	if [[ -n "$(find -L "${EROOT}"/etc/ssl/certs/ -type l)" ]] ; then
		ewarn "Removing the following broken symlinks:"
		ewarn "$(find -L "${EROOT}"/etc/ssl/certs/ -type l -printf '%p -> %l\n' -delete)"
	fi
ewarn "You must complete the ${CATEGORY}/${P} update with etc-update"
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 20260601 (test date 20260708)
# curl -I https://google.com :: passed
# curl -vI https://google.com :: passed
# curl -vI https://cacert.org :: passed
# openssl verify /usr/share/ca-certificates/cacert.org/cacert.org_class1.crt :: passed
# openssl verify /usr/share/ca-certificates/cacert.org/cacert.org_class3.crt :: passed
# openssl verify $(ls /usr/share/ca-certificates/mozilla/*) :: passed
# ls -1 /etc/ssl/certs | wc -l :: 244, passed
# ls -1 /usr/share/ca-certificates/* | wc -l :: 124, passed
