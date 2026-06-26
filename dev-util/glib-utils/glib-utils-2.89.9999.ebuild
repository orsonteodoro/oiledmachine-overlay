# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14} )
GNOME_ORG_MODULE="glib"

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="bd3322219e6ed895d6f81e5a3c575e41a34875a5" # Tue, 16 Jun 2026 17:24:11 -0400
fi

inherit gnome.org python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	S="${WORKDIR}/glib-${PV}"
fi

DESCRIPTION="Build utilities for GLib using projects"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2.1+"
SLOT="0" # /usr/bin utilities that can't be parallel installed by their nature
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/docutils-0.21.1
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		local expected_pv=$(ver_cut "1-2" "${PV}")
		if ! ( grep "version" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'" | grep -q "${expected_pv}" ) ; then
			local actual_pv=$(grep "version" "${S}/meson.build" \
				| head -n 1 \
				| cut -f 2 -d "'" \
				| cut -f 1-2 -d ".")
eerror "QA:  Version mismatch.  Bump PV to ${actual_pv}.9999 or USE=fallback-commit"
eerror "QA:  Expected PV:  ${expected_pv}"
eerror "QA:  Actual PV:  ${actual_pv}"
			die
		fi
	else
		unpack ${A}
	fi
}

src_configure() { :; }

do_rst2man_command() {
	rst2man \
		--syntax-highlight=none \
		"${1}" "${2}" || die "manpage generation failed"
}

src_compile() {
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-genmarshal.in > gobject/glib-genmarshal || die
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-mkenums.in > gobject/glib-mkenums || die
	sed -e "s:@GLIB_VERSION@:${PV}:g;s:@PYTHON@:python:g" glib/gtester-report.in > glib/gtester-report || die
	do_rst2man_command docs/reference/gobject/glib-genmarshal.rst docs/reference/gobject/glib-genmarshal.1
	do_rst2man_command docs/reference/gobject/glib-mkenums.rst docs/reference/gobject/glib-mkenums.1
	do_rst2man_command docs/reference/glib/gtester-report.rst docs/reference/glib/gtester-report.1
}

src_install() {
	python_fix_shebang gobject/glib-genmarshal
	python_fix_shebang gobject/glib-mkenums
	python_fix_shebang glib/gtester-report
	exeinto /usr/bin
	doexe gobject/glib-genmarshal
	doexe gobject/glib-mkenums
	doexe glib/gtester-report
	doman docs/reference/gobject/glib-genmarshal.1
	doman docs/reference/gobject/glib-mkenums.1
	doman docs/reference/glib/gtester-report.1
}
