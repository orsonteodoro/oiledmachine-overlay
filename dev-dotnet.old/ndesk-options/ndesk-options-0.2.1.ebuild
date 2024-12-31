# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="NDesk.Options"
HOMEPAGE="http://www.ndesk.org/Options"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net20 net40"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit autotools dotnet eutils
SRC_URI="http://www.ndesk.org/archive/ndesk-options/ndesk-options-0.2.1.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/ndesk-options-${PV}"

src_prepare() {
	default
	sed -i -r -e "s|gmcs|mcs|g" configure.ac || die
	eautoreconf
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
	  CSFLAGS="${CSFLAGS} -sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\"" \
	  emake || die "emake failed"
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		if [[ "${EDOTNET}" == "net40" ]] ; then
			egacinstall "lib/ndesk-options/NDesk.Options.dll"
		fi
		doins lib/ndesk-options/NDesk.Options.dll
		dodoc AUTHORS ChangeLog README COPYING
		dodoc -r doc
		if use developer ; then
			doins lib/ndesk-options/NDesk.Options.dll.mdb
			if [[ "${EDOTNET}" == "net40" ]] ; then
				dotnet_distribute_file_matching_dll_in_gac \
				  "lib/ndesk-options/NDesk.Options.dll" \
				  "lib/ndesk-options/NDesk.Options.dll.mdb"
			fi
		fi
	}
	dotnet_foreach_impl install_impl
        mono_multilib_comply
}
