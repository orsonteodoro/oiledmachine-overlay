# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake-utils eutils flag-o-matic multilib-build python-r1

DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
LICENSE="GPL-3+ BSD
	clangd? ( !system-clangd? ( Apache-2.0-with-LLVM-exceptions UoI-NCSA ) )
	csharp? ( all-rights-reserved MIT )
	examples? ( Apache-2.0 )
	go? ( !system-go-tools? ( BSD MIT all-rights-reserved Apache-2.0 ) )
	java? ( !system-jdtls? ( Apache-1.1 Apache-2.0 BSD BSD-2 dom4j EPL-2.0 icu
		JDOM MIT all-rights-reserved MPL-1.1 NAIST-IPADIC unicode W3C
		W3C-document ) )
	javascript? ( !system-tern? ( MIT all-rights-reserved CC-BY-SA-4.0 ISC ) )
	libclang? ( !system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT
		UoI-NCSA ) )
	python? ( !system-jedi? ( Apache-2.0 BSD BSD-2 MIT PSF-2 ) )
	!system-mrab-regex? ( all-rights-reserved CNRI PSF-2 )
	rust? ( !system-rust? ( || ( MIT Apache-2.0 ) Apache-2.0
		BSD BSD-1 BSD-2 BSD-4 CC-BY-SA-4.0 GPL-2-with-linking-exception
		LGPL-2.1 libcurl MIT OFL-1.1 all-rights-reserved openssl
		Unlicense UoI-NCSA ZLIB ) )
	!system-bottle? ( MIT )
	!system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA )
	!system-mono? ( all-rights-reserved MIT )
	!system-pathtools? ( BSD MIT )
	!system-requests? ( Apache-2.0 BSD LGPL-2.1+ MIT MPL-2.0 PSF-2
		unicode )
	!system-waitress? ( ZPL )
	!system-watchdog? ( Apache-2.0 )
	typescript? ( !system-typescript? ( all-rights-reserved Apache-2.0
		CC-BY-4.0 MIT unicode W3C ) )
	test? ( BSD GPL-3+ )"

# Apache-2.0 with all-rights-reserved third_party/tsserver/lib64/node_modules/typescript/CopyrightNotice.txt [3]
# The original Apache-2.0 license does not contain all rights reserved

# Additional typescript licenses can be found in
#   third_party/tsserver/lib64/node_modules/typescript/ThirdPartyNoticeText.txt

# Third party tern dependencies:
# MIT all-rights-reserved third_party/tern_runtime/node_modules/string_decoder/LICENSE [1]
# MIT all-rights-reserved third_party/tern_runtime/node_modules/readable-stream/LICENSE [1]
# MIT all-rights-reserved third_party/tern_runtime/node_modules/core-util-is/LICENSE [1]
# ISC CC-BY-SA-4.0 third_party/tern_runtime/node_modules/glob/LICENSE

# Licenses under the rust USE flag:
#
# The license field for the rust USE flag was originally been copied from the
#   dev-lang/rust ebuild but with additions based on cargo, rust-doc, ....
#
# Some of these licenses (such as some of the BSD variants, UoI-NCSA) may not
#   be in the binary distribution of rust but may be found in the source code
#   version or have been obsoleted.
#
# Licenses for the rust USE flag are repeated for the rust USE flag because of
#   multiple packages.
#
# BSD third_party/rls/share/doc/rust/html/nomicon/highlight.js
# MIT Apache-2.0 \
#   third_party/rls/lib/rustlib/src/rust/library/stdarch \
#   third_party/rls/lib/rustlib/src/rust/library/stdarch/crates/core_arch \
#   third_party/rls/lib/rustlib/src/rust/library/stdarch/crates/std_detect \
#   third_party/rls/lib/rustlib/src/rust/library/backtrace
# MIT Apache-2.0 CC-BY-SA-4.0 third_party/rls/share/doc/rust/html/embedded-book/intro/index.html
# OFL-1.1 MIT third_party/rls/share/doc/rust/html/nomicon/FontAwesome/css/font-awesome.css
# OFL-1.1 with all rights reserved third_party/rls/share/doc/rust/html/SourceSerifPro-LICENSE.md [2]
# openssl GPL-2-with-linking-exception MIT LGPL-2.1 BSD libcurl Unlicense ZLIB \
#   third_party/rls/share/doc/cargo/LICENSE-THIRD-PARTY

# [2] The OFL-1.1 does not come with all rights reserved

# The internal jedi with dependencies lists additional licenses for third party
#   Apache-2.0 BSD PSF-2 - scipy-sphinx-theme
#   Apache-2.0 MIT - jedi

# In jdt-language-server-0.54.0-202004152304.tar.gz,
# MIT with all rights reserved [1] \
#   ./org.eclipse.m2e.maven.runtime.slf4j.simple_1.15.0.20200304-0718/about_files/slf4j-simple-LICENSE.txt
# MIT with all rights reserved [1] \
#   ./org.slf4j.api_1.7.2.v20121108-1250/about_files/SLF4J-LICENSE.txt

# [1] There is no all rights reserved in the vanilla MIT license.

# To unpack jdt*, use:
# tar -xvf jdt*; \
# cd plugins; \
# for f in $(find ./ -name "*.jar"); do \
#   D=$(echo "${f}"|sed -e "s|.jar$||g") ; \
#   mkdir "${D}" ; \
#   pushd "${D}" ; \
#     unzip ../${f}; \
#   popd; \
# done

# The vanilla MIT license doesn't contain all rights reserved but it is stated
# in the .target(s), .prop files., .dll files (System.ComponentModel.Composition)
# Additional licenses on internal omnisharp-rosyln refer to .target(s), .rsp, .config files

# The vanilla MIT license doesn't contain all rights reserved.  It is mentioned in
# third_party/go/src/github.com/sergi/go-diff/LICENSE

# Live ebuilds do not get KEYWORDed.  No tagged version in repo.
# Versioning based on CORE_VERSION.

# Dependencies assume U 18.04
# For dependencies, see also
# https://github.com/ycm-core/ycmd/blob/ef48cfe1b63bcc07b88e537fb5b6d17b513e319c/azure/linux/install_dependencies.sh

SLOT_MAJ=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJ}/${PVR}"
IUSE+=" c clangd csharp cuda cxx debug developer doc examples go java javascript
libclang minimal netcore netfx objc objcxx python rust system-bottle
system-boost system-clangd system-go-tools system-jdtls system-jedi system-libclang
system-mono system-mrab-regex system-requests system-pathtools system-rust
system-rust system-tern system-typescript system-waitress system-watchdog test
typescript vim"
CLANG_V="10.0"
CLANG_V_MAJ=$(ver_cut 1 ${CLANG_V})
PV_MAJ=$(ver_cut 1 ${PV})
REQUIRED_USE+="
	c? ( || ( clangd libclang ) )
	clangd? ( || ( c cxx objc objcxx ) )
	csharp? ( || ( netcore netfx ) )
	cxx? ( || ( clangd libclang ) )
	libclang? ( || ( c cxx objc objcxx ) )
	objc? ( || ( clangd libclang ) )
	objcxx? ( || ( clangd libclang ) )
	system-clangd? ( || ( c cxx objc objcxx ) clangd )
	system-go-tools? ( go )
	system-jdtls? ( java )
	system-jedi? ( python )
	system-libclang? ( || ( c cxx objc objcxx ) libclang )
	system-rust? ( rust )
	system-tern? ( javascript )"

# Versions must match
# https://github.com/ycm-core/ycmd/blob/ef48cfe1b63bcc07b88e537fb5b6d17b513e319c/cpp/BoostParts/boost/version.hpp
# The hash is based on ${EGIT_COMMIT}.

# gopls is 0.6.4
# See build.py for dependency versions.
# See https://github.com/golang/tools/releases?after=gopls%2Fv0.6.5

# For the rust version see src/bootstrap/channel.rs in https://github.com/rust-lang
# and build.py in archive for nightly date.  Use committer-date:YYYY-MM-DD to search

# For omnisharp-roslyn min requirements, see
# .netcore version https://github.com/OmniSharp/omnisharp-roslyn/blob/v1.35.3/.pipelines/init.yml
# .netfx version https://github.com/OmniSharp/omnisharp-roslyn/blob/v1.35.3/azure-pipelines.yml

EGIT_COMMIT="ef48cfe1b63bcc07b88e537fb5b6d17b513e319c" # Last commit before the CORE_VERSION is 44.
#EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"
EGIT_COMMIT_FLASK_SPHINX_THEMES="3d964b660442e23faedf801caed6e3c7bd42d5c9"
EGIT_COMMIT_NUMPYDOC="c8513c5db6088a305711851519f944b33f7e1b25"
EGIT_COMMIT_PATHTOOLS="a3522fc61b00ee2d992ca375c600513bfb9020e9"
EGIT_COMMIT_SCIPY_SPHINX_THEME="bc3b4b8383d4cd676fe75b7ca8c3e11d6afa8d97"
EGIT_COMMIT_TYPESHED="d38645247816f862cafeed21a8f4466d306aacf3"
EGIT_COMMIT_YCMD_CORE_REGEX="cc538bb6d0fcf0a6411537a5522d13cc9b86789d"
BOTTLE_V="0.12.18"
CLANGD_V="10.0.0"
CHARDET_V="3.0.4"
GOPLS_V="0.4.2"
IDNA_V="2.8"
JDTLS_V="0.54.0-202004152304" # MILESTONE-TIMESTAMP in build.py
JEDI_V="0.17.0"
OMNISHARP_V="1.35.3"
PARSO_V="0.7.0"
PYTHON_CERTIFI_V="2019.11.28"
REQUESTS_V="2.22.0"
RUST_V="nightly-2020-04-17"
LIBCLANG_V="10.0.0"
URLLIB3_V="1.25.8"
WATCHDOG_V="0.10.2"
WAITRESS_V="1.4.3"

RDEPEND_NODEJS="net-libs/nodejs"
BDEPEND_NODEJS="net-libs/nodejs[npm]"
DEPEND+=" ${PYTHON_DEPS}
	csharp? (
		system-mono? (
			netfx? ( >=dev-lang/mono-6.8.0 )
			netcore? (
				>=dev-lang/mono-6.8.0
				>=dev-dotnet/dotnetcore-sdk-bin-3.1.201:3.1
			)
		)
	)
	java? ( virtual/jre:1.8 )
	javascript? ( ${RDEPEND_NODEJS} )
	system-boost? ( >=dev-libs/boost-1.72:=[python,threads,${PYTHON_USEDEP}] )
	system-bottle? ( >=dev-python/bottle-${BOTTLE_V}[${PYTHON_USEDEP}] )
	system-clangd? ( >=sys-devel/clang-${CLANGD_V}:${CLANG_V_MAJ} )
	system-go-tools? ( >=dev-go/go-tools-0_pre20210119 )
	system-jdtls? ( >=dev-java/jdt-${JDTLS_V%-*} )
	system-jedi? ( >=dev-python/jedi-${JEDI_V}[${PYTHON_USEDEP}]
			>=dev-python/numpydoc-0.9.0_pre20200408[${PYTHON_USEDEP}]
			>=dev-python/parso-${PARSO_V}[${PYTHON_USEDEP}] )
	system-libclang? ( >=sys-devel/clang-${LIBCLANG_V}:${CLANG_V_MAJ} )
	system-mrab-regex? (
		>=dev-python/regex-2019.06.08[${PYTHON_USEDEP}]
	)
	system-pathtools? ( >=dev-python/pathtools-0.1.1_pre20161006 )
	system-requests? ( >=dev-python/requests-${REQUESTS_V}[${PYTHON_USEDEP}] )
	system-rust? ( >=dev-lang/rust-1.44.0_pre20200417[rls] )
	system-tern? ( >=dev-nodejs/tern-0.21.0 )
	system-typescript? ( >=dev-lang/typescript-3.8.3 )
	system-waitress? ( >=dev-python/waitress-${WAITRESS_V}[${PYTHON_USEDEP}] )
	system-watchdog? ( >=dev-python/watchdog-${WATCHDOG_V} )
	typescript? ( ${RDEPEND_NODEJS} )"
RDEPEND+="  ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	|| (
		>=sys-devel/gcc-4.8
		>=sys-devel/clang-3.9
	)
	javascript? ( ${BDEPEND_NODEJS} )
	test? ( >=dev-python/codecov-2.0.5[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.0[${PYTHON_USEDEP}]
		dev-python/flake8-comprehensions[${PYTHON_USEDEP}]
		>=dev-python/flake8-ycm-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.6.6[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-1.10.1[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}] )
	typescript? ( ${BDEPEND_NODEJS} )"
# Speed up downloads for rebuilds.  Precache outside of sandbox so we don't keep
#   redownloading.
# libclang archives are listed in cpp/ycm/CMakeLists.txt
# For rust installers see,
#   https://forge.rust-lang.org/infra/other-installation-methods.html
# For rust precompiled binaries see,
#   https://static.rust-lang.org/dist/2020-04-17/channel-rust-nightly.toml
# For more info on Rust Release Channels see,
#   https://forge.rust-lang.org/infra/channel-layout.html

YCMD_FN="${P}-${EGIT_COMMIT:0:7}.tar.gz"
BOTTLE_FN="bottle-${BOTTLE_V}.tar.gz"
CHARDET_FN="chardet-${CHARDET_V}.tar.gz"
FLASK_SPHINX_THEMES_FN="flask-sphinx-themes-${EGIT_COMMIT_FLASK_SPHINX_THEMES:0:7}.tar.gz"
IDNA_FN="idna-${IDNA_V}.tar.gz"
JEDI_FN="jedi-${JEDI_V}.tar.gz"
NUMPYDOC_FN="numpydoc-${EGIT_COMMIT_NUMPYDOC:0:7}.tar.gz"
PARSO_FN="parso-${PARSO_V}.tar.gz"
PATHTOOLS_FN="pathtools-${EGIT_COMMIT_PATHTOOLS:0:7}.tar.gz"
PYTHON_CERTIFI_FN="python-certifi-${PYTHON_CERTIFI_V}.tar.gz"
REQUESTS_FN="requests-${REQUESTS_V}.tar.gz"
SCIPY_SPHINX_THEME_FN="scipy-sphinx-theme-${EGIT_COMMIT_SCIPY_SPHINX_THEME:0:7}.tar.gz"
TYPESHED_FN="typeshed-${EGIT_COMMIT_TYPESHED:0:7}.tar.gz"
URLLIB3_FN="urllib3-${URLLIB3_V}.tar.gz"
WAITRESS_FN="waitress-${WAITRESS_V}.tar.gz"
WATCHDOG_FN="watchdog-${WATCHDOG_V}.tar.gz"
YCMD_CORE_REGEX_FN="ycm-core-regex-${EGIT_COMMIT_YCMD_CORE_REGEX:0:7}.tar.gz"

SRC_URI="
https://github.com/ycm-core/ycmd/archive/${EGIT_COMMIT}.tar.gz
	-> ${YCMD_FN}
https://github.com/bottlepy/bottle/archive/refs/tags/${BOTTLE_V}.tar.gz
	-> ${BOTTLE_FN}
https://github.com/chardet/chardet/archive/refs/tags/${CHARDET_V}.tar.gz
	-> ${CHARDET_FN}
https://github.com/pallets/flask-sphinx-themes/archive/${EGIT_COMMIT_FLASK_SPHINX_THEMES}.tar.gz
	-> ${FLASK_SPHINX_THEMES_FN}
https://github.com/kjd/idna/archive/refs/tags/v${IDNA_V}.tar.gz
	-> ${IDNA_FN}
https://github.com/davidhalter/jedi/archive/refs/tags/v${JEDI_V}.tar.gz
	-> ${JEDI_FN}
https://github.com/numpy/numpydoc/archive/${EGIT_COMMIT_NUMPYDOC}.tar.gz
	-> ${NUMPYDOC_FN}
https://github.com/davidhalter/parso/archive/refs/tags/v${PARSO_V}.tar.gz
	-> ${PARSO_FN}
https://github.com/gorakhargosh/pathtools/archive/${EGIT_COMMIT_PATHTOOLS}.tar.gz
	-> ${PATHTOOLS_FN}
https://github.com/certifi/python-certifi/archive/refs/tags/${PYTHON_CERTIFI_V}.tar.gz
	-> ${PYTHON_CERTIFI_FN}
https://github.com/psf/requests/archive/refs/tags/v${REQUESTS_V}.tar.gz
	-> ${REQUESTS_FN}
https://github.com/scipy/scipy-sphinx-theme/archive/${EGIT_COMMIT_SCIPY_SPHINX_THEME}.tar.gz
	-> ${SCIPY_SPHINX_THEME_FN}
https://github.com/davidhalter/typeshed/archive/${EGIT_COMMIT_TYPESHED}.tar.gz
	-> ${TYPESHED_FN}
https://github.com/urllib3/urllib3/archive/refs/tags/${URLLIB3_V}.tar.gz
	-> ${URLLIB3_FN}
https://github.com/Pylons/waitress/archive/refs/tags/v${WAITRESS_V}.tar.gz
	-> ${WAITRESS_FN}
https://github.com/gorakhargosh/watchdog/archive/refs/tags/v${WATCHDOG_V}.tar.gz
	-> ${WATCHDOG_FN}
https://github.com/ycm-core/regex/archive/${EGIT_COMMIT_YCMD_CORE_REGEX}.tar.gz
	-> ${YCMD_CORE_REGEX_FN}
!system-clangd? (
	clangd? (
		amd64? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/clangd/clangd-${CLANGD_V}-x86_64-unknown-linux-gnu.tar.bz2
			)
		)
		arm64? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/clangd/clangd-${CLANGD_V}-aarch64-linux-gnu.tar.bz2
			)
		)
		arm? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/clangd/clangd-${CLANGD_V}-armv7a-linux-gnueabihf.tar.bz2
			)
		)
	)
)
!system-libclang? (
	libclang? (
		amd64? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/libclang/libclang-${LIBCLANG_V}-x86_64-unknown-linux-gnu.tar.bz2
			)
		)
		arm? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/libclang/libclang-${LIBCLANG_V}-armv7a-linux-gnueabihf.tar.bz2
			)
		)
		arm64? (
			elibc_glibc? (
https://dl.bintray.com/ycm-core/libclang/libclang-${LIBCLANG_V}-aarch64-linux-gnu.tar.bz2
			)
		)
	)
)
java? ( !system-jdtls? ( http://download.eclipse.org/jdtls/snapshots/jdt-language-server-${JDTLS_V}.tar.gz ) )
csharp? (
https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_V}/omnisharp.http-linux-x64.tar.gz
	-> omnisharp-${OMNISHARP_V}.http-linux-x64.tar.gz
https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_V}/omnisharp.http-linux-x86.tar.gz
	-> omnisharp-${OMNISHARP_V}.http-linux-x86.tar.gz
)
rust? (
	!system-rust? (
		https://static.rust-lang.org/dist/${RUST_V#*-}/rust-src-nightly.tar.gz
			-> rust-src-nightly-${RUST_V#*-}.tar.gz
	)
)
"

gen_rust_dls()
{
	local gentoo_arch="${1}"
	local elibc_impl="${2}"
	local pkg_name="${3}"
	local arch_triple="${4}"
	local nightly_date="${RUST_V#*-}"
	out="
rust? (
	${gentoo_arch}? (
		${elibc_impl}? (
https://static.rust-lang.org/dist/${nightly_date}/${pkg_name}-nightly-${arch_triple}.tar.gz
	-> ${pkg_name}-nightly-${nightly_date}-${arch_triple}.tar.gz
		)
	)
)
"
	echo "${out}"
}

# The Rust x86_64-glibc dependency list is based on the output of rustup-init.
# Other archs downloads are based on that x86-64 list.

SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc cargo x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc clippy x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rust-docs x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rust-std x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rustc x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rustfmt x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rls x86_64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_glibc rust-analysis x86_64-unknown-linux-gnu)

SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl cargo x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl clippy x86_64-unknown-linux-musl)
#SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rust-docs x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rust-std x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rustc x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rustfmt x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rls x86_64-unknown-linux-musl)
SRC_URI+=" "$(gen_rust_dls amd64 elibc_musl rust-analysis x86_64-unknown-linux-musl)

SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc cargo aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc clippy aarch64-unknown-linux-gnu)
#SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rust-docs aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rust-std aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rustc aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rustfmt aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rls aarch64-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls arm64 elibc_glibc rust-analysis aarch64-unknown-linux-gnu)

SRC_URI+=" "$(gen_rust_dls arm elibc_glibc cargo armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc clippy armv7-unknown-linux-gnueabihf)
#SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rust-docs armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rust-std armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rustc armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rustfmt armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rls armv7-unknown-linux-gnueabihf)
SRC_URI+=" "$(gen_rust_dls arm elibc_glibc rust-analysis armv7-unknown-linux-gnueabihf)

SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc cargo i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc clippy i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rust-docs i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rust-std i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rustc i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rustfmt i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rls i686-unknown-linux-gnu)
SRC_URI+=" "$(gen_rust_dls x86 elibc_glibc rust-analysis i686-unknown-linux-gnu)

gen_go_dl_gh_url()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local tag="${3}"
	unset tag_split
	readarray -d - -t tag_split <<<"${tag}"
	local tag_commit="${tag_split[2]}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"

	if [[ -n "${tag_commit}" ]] ; then
		echo "
	go? (
https://codeload.github.com/${uri_frag}/tar.gz/${tag_commit}
	-> ${dest_name}.tar.gz
	)"
	else
		echo "
	go? (
https://github.com/${uri_frag}/archive/refs/tags/${tag}.tar.gz
	-> ${dest_name}.tar.gz
	)"
	fi

}

SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/tools/gopls golang/tools gopls/v0.4.2) # only the folder
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/tools golang/tools v0.0.0-20200701133321-6ddc6be4d35f) # the entire project
SRC_URI+=" "$(gen_go_dl_gh_url honnef.co/go/tools dominikh/go-tools v0.0.1-2020.1.4)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/xerrors golang/xerrors  v0.0.0-20191204190536-9bdfabe68543)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/sergi/go-diff sergi/go-diff v1.1.0)
SRC_URI+=" "$(gen_go_dl_gh_url mvdan.cc/xurls/v2 mvdan/xurls v2.2.0)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/mod golang/mod v0.2.0)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/sync golang/sync v0.0.0-20190911185100-cd5d95a43a6e)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/BurntSushi/toml BurntSushi/toml v0.3.1)

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
S_BOTTLE="${WORKDIR}/bottle-${BOTTLE_V}"
S_CHARDET="${WORKDIR}/chardet-${CHARDET_V}"
S_FLASK_SPHINX_THEMES="${WORKDIR}/flask-sphinx-themes-${EGIT_COMMIT_FLASK_SPHINX_THEMES}"
S_GO="${S}/third_party/go"
S_IDNA="${WORKDIR}/idna-${IDNA_V}"
S_JEDI="${WORKDIR}/jedi-${JEDI_V}"
S_NUMPYDOC="${WORKDIR}/numpydoc-${EGIT_COMMIT_NUMPYDOC}"
S_PARSO="${WORKDIR}/parso-${PARSO_V}"
S_PATHTOOLS="${WORKDIR}/pathtools-${EGIT_COMMIT_PATHTOOLS}"
S_PYTHON_CERTIFI="${WORKDIR}/python-certifi-${PYTHON_CERTIFI_V}"
S_REQUESTS="${WORKDIR}/requests-${REQUESTS_V}"
S_RUST="${S}/third_party/rls"
S_SCIPY_SPHINX_THEME="${WORKDIR}/scipy-sphinx-theme-${EGIT_COMMIT_SCIPY_SPHINX_THEME}"
S_TYPESHED="${WORKDIR}/typeshed-${EGIT_COMMIT_TYPESHED}"
S_URLLIB3="${WORKDIR}/urllib3-${URLLIB3_V}"
S_WAITRESS="${WORKDIR}/waitress-${WAITRESS_V}"
S_WATCHDOG="${WORKDIR}/watchdog-${WATCHDOG_V}"
S_YCM_CORE_REGEX="${WORKDIR}/regex-${EGIT_COMMIT_YCMD_CORE_REGEX}"

RESTRICT="mirror"
DOCS=( JAVA_SUPPORT.md README.md )
BD_REL="ycmd/${SLOT_MAJ}"
BD_ABS=""

pkg_setup() {
	ewarn
	ewarn "This ebuild is currently undergoing renovation / refactoring and is a (Work In Progress)"
	ewarn
	if \
	   ( ! use system-tern && use javascript ) \
	|| ( ! use system-typescript && use typescript ) ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download the internal dependencies."
		fi
		:;
	fi

	# No standard ebuild yet.
	if use system-jdtls ; then
		if [[ -z "${EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH}" ]] ; then
			die \
"You need to define EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH as a per-package envvar."
		fi
	fi

	python_setup
}

src_unpack() {
	# Manually unpacked to prevent double unpack with Rust or Go.
	unpack ${YCMD_FN} \
		${BOTTLE_FN} \
		${CHARDET_FN} \
		${FLASK_SPHINX_THEMES_FN} \
		${IDNA_FN} \
		${JEDI_FN} \
		${NUMPYDOC_FN} \
		${PARSO_FN} \
		${PATHTOOLS_FN} \
		${PYTHON_CERTIFI_FN} \
		${REQUESTS_FN} \
		${SCIPY_SPHINX_THEME_FN} \
		${TYPESHED_FN} \
		${URLLIB3_FN} \
		${WAITRESS_FN} \
		${WATCHDOG_FN} \
		${YCMD_CORE_REGEX_FN}

	cd "${S}" || die
	rm -rf third_party/bottle \
		third_party/cregex \
		third_party/jedi_deps/jedi \
		third_party/jedi_deps/numpydoc \
		third_party/jedi_deps/numpydoc/doc/scipy-sphinx-theme \
		third_party/jedi_deps/parso \
		third_party/jedi_deps/jedi/jedi/third_party/typeshed \
		third_party/requests_deps/certifi \
		third_party/requests_deps/chardet \
		third_party/requests_deps/idna \
		third_party/requests_deps/requests \
		third_party/requests_deps/urllib3 \
		third_party/waitress \
		third_party/watchdog_deps/pathtools \
		third_party/watchdog_deps/pathtools/docs/source/_themes \
		third_party/watchdog_deps/watchdog || die

	if ! use system-bottle ; then
		mv "${S_BOTTLE}" \
			third_party/bottle || die
	fi
	if ! use system-mrab-regex ; then
		mv "${S_YCM_CORE_REGEX}" \
			third_party/cregex || die
	fi
	if ! use system-jedi && use python ; then
		mv "${S_JEDI}" \
			third_party/jedi_deps/jedi || die
		mv "${S_NUMPYDOC}" \
			third_party/jedi_deps/numpydoc || die
		mv "${S_SCIPY_SPHINX_THEME}" \
			third_party/jedi_deps/numpydoc/doc/scipy-sphinx-theme || die
		mv "${S_PARSO}" \
			third_party/jedi_deps/parso || die
		mv "${S_TYPESHED}" \
			third_party/jedi_deps/jedi/jedi/third_party/typeshed || die
	fi
	if ! use system-requests ; then
		mv "${S_PYTHON_CERTIFI}" \
			third_party/requests_deps/certifi || die
		mv "${S_CHARDET}" \
			third_party/requests_deps/chardet || die
		mv "${S_IDNA}" \
			third_party/requests_deps/idna || die
		mv "${S_REQUESTS}" \
			third_party/requests_deps/requests || die
		mv "${S_URLLIB3}" \
			third_party/requests_deps/urllib3 || die
	fi
	if ! use system-waitress ; then
		mv "${S_WAITRESS}" \
			third_party/waitress || die
	fi
	if ! use system-watchdog ; then
		if ! use system-pathtools ; then
			mv "${S_PATHTOOLS}" \
				third_party/watchdog_deps/pathtools || die
			mv "${S_FLASK_SPHINX_THEMES}" \
				third_party/watchdog_deps/pathtools/docs/source/_themes || die
		fi
		mv "${S_WATCHDOG}" \
			third_party/watchdog_deps/watchdog || die
	fi

	if use clangd && ! use system-clangd ; then
		mkdir -p third_party/clangd/cache || die
		if use amd64 ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/clangd-${CLANGD_V}-x86_64-unknown-linux-gnu.tar.bz2") \
					third_party/clangd/cache || die
			fi
		fi
		if use arm64 ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/clangd-${CLANGD_V}-aarch64-linux-gnu.tar.bz2") \
					third_party/clangd/cache || die
			fi
		fi
		if use arm ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/clangd-${CLANGD_V}-armv7a-linux-gnueabihf.tar.bz2") \
					third_party/clangd/cache || die
			fi
		fi
	fi

	if use libclang && ! use system-libclang ; then
		mkdir -p clang_archives || die
		if use amd64 ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/libclang-${LIBCLANG_V}-x86_64-unknown-linux-gnu.tar.bz2") \
					clang_archives || die
			fi
		fi
		if use arm64 ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/libclang-${LIBCLANG_V}-aarch64-linux-gnu.tar.bz2") \
					clang_archives || die
			fi
		fi
		if use arm ; then
			if use elibc_glibc ; then
				cp -a $(realpath "${DISTDIR}/libclang-${LIBCLANG_V}-armv7a-linux-gnueabihf.tar.bz2") \
					clang_archives || die
			fi
		fi
	fi

	if use csharp ; then
		mkdir -p third_party/omnisharp-roslyn/v${OMNISHARP_V} || die
		cp -a $(realpath "${DISTDIR}/omnisharp-${OMNISHARP_V}.http-linux-x64.tar.gz") \
			third_party/omnisharp-roslyn/v${OMNISHARP_V}/omnisharp.http-linux-x64.tar.gz || die
		cp -a $(realpath "${DISTDIR}/omnisharp-${OMNISHARP_V}.http-linux-x64.tar.gz") \
			third_party/omnisharp-roslyn/v${OMNISHARP_V}/omnisharp.http-linux-x86.tar.gz || die
	fi

	if use go && ! use system-go-tools ; then
		unpack_gopls
	fi

	if use java && ! use system-jdtls ; then
		mkdir -p third_party/eclipse.jdt.ls/target/cache || die
		cp -a $(realpath "${DISTDIR}/jdt-language-server-${JDTLS_V}.tar.gz") \
			third_party/eclipse.jdt.ls/target/cache || die
	fi

	if use rust && ! use system-rust ; then
		_install_rust_locally
	fi
}

unpack_go_pkg()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local tag="${3}"
	local dest="${S_GO}/src/${pkg_name}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"
	einfo "Unpacking ${dest_name}.tar.gz"
	mkdir -p "${dest}" || die
	if [[ "${pkg_name}" == "golang.org/x/tools" ]] ; then
		tar --strip-components=1 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" \
			--exclude=tools-${tag##*-}/gopls || die
	elif [[ "${pkg_name}" == "golang.org/x/tools/gopls" ]] ; then
		tar --strip-components=2 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" \
			tools-gopls-v${GOPLS_V}/gopls || die
	else
		tar --strip-components=1 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" || die
	fi
}

unpack_gopls()
{
	unpack_go_pkg golang.org/x/tools/gopls golang/tools gopls/v0.4.2
	unpack_go_pkg golang.org/x/tools golang/tools v0.0.0-20200701133321-6ddc6be4d35f
	unpack_go_pkg honnef.co/go/tools dominikh/go-tools v0.0.1-2020.1.4
	unpack_go_pkg golang.org/x/xerrors golang/xerrors v0.0.0-20191204190536-9bdfabe68543
	unpack_go_pkg github.com/sergi/go-diff sergi/go-diff v1.1.0
	unpack_go_pkg mvdan.cc/xurls/v2 mvdan/xurls v2.2.0
	unpack_go_pkg golang.org/x/mod golang/mod v0.2.0
	unpack_go_pkg golang.org/x/sync golang/sync v0.0.0-20190911185100-cd5d95a43a6e
	unpack_go_pkg github.com/BurntSushi/toml BurntSushi/toml v0.3.1
}

src_compile_gopls()
{
	einfo "Building gopls"
	export GO111MODULE=auto
	export GOPATH="${BUILD_DIR}/third_party/go"
	export GOBIN="${GOPATH}/bin"
	mkdir -p "${GOBIN}" || die
	pushd "${GOBIN}" || die
		go build golang.org/x/tools/gopls || die
	popd
}

unpack_rust_pkg()
{
	local pkg_name="${1}"
	local arch_triple="${2}"
	local alt_name="${3}"
	local nightly_date="${RUST_V#*-}"
	local dest="${S_RUST}"
	if [[ -z "${alt_name}" ]] ; then
		alt_name="${pkg_name}"
	fi
	mkdir -p "${dest}" || die
	local fn=
	if [[ -n "${arch_triple}" ]] ; then
		fn="${pkg_name}-nightly-${nightly_date}-${arch_triple}.tar.gz"
		root_path="${pkg_name}-nightly-${arch_triple}"
	else
		fn="${pkg_name}-nightly-${nightly_date}.tar.gz"
		root_path="${pkg_name}-nightly"
	fi
	einfo "Unpacking ${fn}"
	tar --overwrite \
		--strip-components=2 \
		-x -C "${dest}" \
		-f "${DISTDIR}/${fn}" \
		${root_path}/${alt_name} || die
}

_install_rust_locally()
{
	mkdir -p "${S_RUST}" || die
	if ! use system-rust && use rust ; then
		for abi in $(multilib_get_enabled_abis) ; do
			local chost=$(get_abi_CHOST ${abi})
			local arch="${chost%%-*}"
			einfo "chost: ${chost}"
			einfo "arch: ${arch}"
			case ${arch} in
				aarch64*)
					if use elibc_glibc ; then
			unpack_rust_pkg cargo aarch64-unknown-linux-gnu
			unpack_rust_pkg clippy aarch64-unknown-linux-gnu clippy-preview
			#unpack_rust_pkg rust-docs aarch64-unknown-linux-gnu
			unpack_rust_pkg rust-std aarch64-unknown-linux-gnu rust-std-aarch64-unknown-linux-gnu
			unpack_rust_pkg rustc aarch64-unknown-linux-gnu
			unpack_rust_pkg rustfmt aarch64-unknown-linux-gnu rustfmt-preview
			unpack_rust_pkg rls aarch64-unknown-linux-gnu rls-preview
			unpack_rust_pkg rust-analysis aarch64-unknown-linux-gnu rust-analysis-aarch64-unknown-linux-gnu
					fi
					;;
				armv7a*h*)
					if use elibc_glibc ; then
			unpack_rust_pkg cargo armv7-unknown-linux-gnueabihf
			unpack_rust_pkg clippy armv7-unknown-linux-gnueabihf clippy-preview
			#unpack_rust_pkg rust-docs armv7-unknown-linux-gnueabihf
			unpack_rust_pkg rust-std armv7-unknown-linux-gnueabihf rust-std-armv7-unknown-linux-gnueabihf
			unpack_rust_pkg rustc armv7-unknown-linux-gnueabihf
			unpack_rust_pkg rustfmt armv7-unknown-linux-gnueabihf rustfmt-preview
			unpack_rust_pkg rls armv7-unknown-linux-gnueabihf rls-preview
			unpack_rust_pkg rust-analysis armv7-unknown-linux-gnueabihf rust-analysis-armv7-unknown-linux-gnueabihf
					fi
					;;
				x86_64*)
					if use elibc_glibc ; then
			unpack_rust_pkg cargo x86_64-unknown-linux-gnu
			unpack_rust_pkg clippy x86_64-unknown-linux-gnu clippy-preview
			unpack_rust_pkg rust-docs x86_64-unknown-linux-gnu
			unpack_rust_pkg rust-std x86_64-unknown-linux-gnu rust-std-x86_64-unknown-linux-gnu
			unpack_rust_pkg rustc x86_64-unknown-linux-gnu
			unpack_rust_pkg rustfmt x86_64-unknown-linux-gnu rustfmt-preview
			unpack_rust_pkg rls x86_64-unknown-linux-gnu rls-preview
			unpack_rust_pkg rust-analysis x86_64-unknown-linux-gnu rust-analysis-x86_64-unknown-linux-gnu
					fi
					if use elibc_musl ; then
			unpack_rust_pkg cargo x86_64-unknown-linux-musl
			unpack_rust_pkg clippy x86_64-unknown-linux-musl clippy-preview
			#unpack_rust_pkg rust-docs x86_64-unknown-linux-musl
			unpack_rust_pkg rust-std x86_64-unknown-linux-musl rust-std-x86_64-unknown-linux-musl
			unpack_rust_pkg rustc x86_64-unknown-linux-musl
			unpack_rust_pkg rustfmt x86_64-unknown-linux-musl rustfmt-preview
			unpack_rust_pkg rls x86_64-unknown-linux-musl rls-preview
			unpack_rust_pkg rust-analysis x86_64-unknown-linux-musl rust-analysis-x86_64-unknown-linux-musl
					fi
					;;
				x86*)
					if use elibc_glibc ; then
			unpack_rust_pkg cargo i686-unknown-linux-gnu
			unpack_rust_pkg clippy i686-unknown-linux-gnu clippy-preview
			unpack_rust_pkg rust-docs i686-unknown-linux-gnu
			unpack_rust_pkg rust-std i686-unknown-linux-gnu rust-std-i686-unknown-linux-gnu
			unpack_rust_pkg rustc i686-unknown-linux-gnu
			unpack_rust_pkg rustfmt i686-unknown-linux-gnu rustfmt-preview
			unpack_rust_pkg rls i686-unknown-linux-gnu rls-preview
			unpack_rust_pkg rust-analysis i686-unknown-linux-gnu rust-analysis-i686-unknown-linux-gnu
					fi
					;;
				*)
					einfo "chost: ${chost}"
					einfo "arch: ${arch}"
					die \
			"Please use the system-rust USE flag instead"
					;;
			esac
			unpack_rust_pkg rust-src ""
			echo "${RUST_V}" > "${S_RUST}/TOOLCHAIN_VERSION" || die
		done
	fi
}

_check_abi_supported()
{
	if ! use system-libclang && use libclang ; then
		if use elibc_musl ; then
			die "Please use the system-libclang USE flag instead"
		fi
		einfo "Checking precompiled libclang support"
		for abi in $(multilib_get_enabled_abis) ; do
			local chost=$(get_abi_CHOST ${abi})
			local arch="${chost%%-*}"
			einfo "chost: ${chost}"
			einfo "arch: ${arch}"
			case ${arch} in
				aarch64*) einfo "Supported ${arch}" ;;
				armv7a*h*) einfo "Supported ${arch}" ;;
				x86_64*) einfo "Supported ${arch}" ;;
				*)
					einfo "chost: ${chost}"
					einfo "arch: ${arch}"
					die \
			"Please use the system-libclang USE flag instead" ;;
			esac
		done
	fi
}

src_prepare() {
	default
	local sitedir="$(python_get_sitedir)"
	_check_abi_supported
	eapply "${FILESDIR}/${PN}-42_p20200108-skip-thirdparty-check.patch"
	eapply "${FILESDIR}/${PN}-43_p20200516-system-third-party.patch"
	eapply "${FILESDIR}/${PN}-43_p20200516-system-global-config.patch"

	cat "${FILESDIR}/default_settings.json.43_p20200623" \
		> ycmd/default_settings.json || die

	if use clangd ; then
		ewarn "Using clangd is experimental."
	fi

	if use system-libclang ; then
		eapply "${FILESDIR}/${PN}-25_20170108-force-python-libs-path.patch"
	fi

	if ! use vim ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-remove-ultisnips.patch"
	fi

	sed -i -e "s|\
___HMAC_SECRET___|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
		ycmd/default_settings.json || die

	sed -i -e "s|___GLOBAL_YCMD_EXTRA_CONF___|/tmp/.ycm_extra_conf.py|" \
		ycmd/default_settings.json || die

	CMAKE_USE_DIR="${S}/cpp" \
	cmake-utils_src_prepare

	python_copy_sources
}

ycmd_config_use_system()
{
	local X=${1}
	sed -i -e "s|USE_SYSTEM_${X} = False|USE_SYSTEM_${X} = True|" \
		ycmd/extra_conf_store.py || die
}

ycmd_config_set_default_src_path()
{
	local i="${1}"
	local path="${2}"
	sed -i -e "s|${i}|${path}|g" \
		ycmd/extra_conf_store.py || die
}

ycmd_config_set_default_json_path()
{
	local i="${1}"
	local path="${2}"
	sed -i -e "s|${i}|${path}|g" \
		ycmd/default_settings.json || die
}

src_configure() {
	python_configure_all()
	{
		cd "${BUILD_DIR}" || die
		local sitedir="$(python_get_sitedir)"
		BD_ABS="$(python_get_sitedir)/${BD_REL}"

		if use system-bottle ; then
			ycmd_config_use_system BOTTLE
			ycmd_config_set_default_src_path \
				"___SYSTEM_BOTTLE_PATH___" \
				"${sitedir}/bottle"
		fi

#123456789001234567890012345678900123456789001234567890012345678900123456789001234567890
		if use system-clangd ; then
			ycmd_config_use_system CLANGD
			ycmd_config_set_default_src_path \
				"___SYSTEM_CLANGD_PATH___" \
				"/usr/lib/llvm/${CLANG_V_MAJ}/bin/clangd"
			ycmd_config_set_default_json_path \
				"___CLANGD_PATH___" \
				"/usr/lib/llvm/${CLANG_V_MAJ}/bin/clangd"
		else
			ycmd_config_set_default_json_path \
				"___CLANGD_PATH___" \
				"${BD_ABS}/third_party/clangd/output/bin/clangd"
		fi

		if use system-go-tools ; then
			ycmd_config_use_system GOPLS
			ycmd_config_set_default_src_path \
				"___SYSTEM_GOPLS_PATH___" \
				"/usr/bin/gopls"
			ycmd_config_set_default_json_path \
				"___GOPLS_PATH___" \
				"/usr/bin/gopls"
		else
			ycmd_config_set_default_json_path \
				"___GOPLS_PATH___" \
				"${BD_ABS}/third_party/go/bin/gopls"
		fi

		if use system-jdtls && use java ; then
			ycmd_config_use_system JDT
			ycmd_config_set_default_src_path \
				"___SYSTEM_JDTLS_LANGUAGE_SERVER_HOME_PATH___" \
				"${EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH}"
			ycmd_config_set_default_src_path \
				"___SYSTEM_JDTLS_WORKSPACE_ROOT_PATH___" \
				"${EYCMD_JDTLS_WORKSPACE_ROOT_PATH}"
			ycmd_config_set_default_src_path \
				"___SYSTEM_JDTLS_EXTENSION_PATH___" \
				"${EYCMD_JDTLS_EXTENSION_PATH}"
			ycmd_config_set_default_json_path \
				"___JDTLS_WORKSPACE_ROOT_PATH___" \
				"${EYCMD_JDTLS_WORKSPACE_ROOT_PATH}"
			ycmd_config_set_default_json_path \
				"___JDTLS_EXTENSION_PATH___" \
				"${EYCMD_JDTLS_EXTENSION_PATH}"
		else
			ycmd_config_set_default_json_path \
				"___JDTLS_WORKSPACE_ROOT_PATH___" \
				"${BD_ABS}/third_party/eclipse.jdt.ls/workspace"
			ycmd_config_set_default_json_path \
				"___JDTLS_EXTENSION_PATH___" \
				"${BD_ABS}/third_party/eclipse.jdt.ls/extensions"
		fi

		if use system-jedi ; then
			ycmd_config_use_system JEDI
			ycmd_config_set_default_src_path \
				"___SYSTEM_JEDI_PATH___" \
				"${sitedir}/jedi"
		fi

		if use system-libclang ; then
			ycmd_config_use_system LIBCLANG
			ycmd_config_set_default_src_path \
				"___SYSTEM_CLANG_LIB_PATH___" \
				"/usr/lib/llvm/${CLANG_V_MAJ}/$(get_libdir)"
			sed -i -e "s|\
EXTERNAL_LIBCLANG_PATH \${TEMP}|\
EXTERNAL_LIBCLANG_PATH \"/usr/lib/llvm/${CLANG_V_MAJ}/$(get_libdir)/libclang.so\"|g" \
				cpp/ycm/CMakeLists.txt || die

			# Prevent from raising an exception.
			sed -i -e "s|\
^CLANG_RESOURCE_DIR = GetClangResourceDir|\
#CLANG_RESOURCE_DIR = GetClangResourceDir|g" \
				ycmd/utils.py || die
		fi

		if use system-mono ; then
			ycmd_config_set_default_json_path \
				"___MONO_PATH___" \
				"/usr/bin/mono"
		else
			ycmd_config_set_default_json_path \
				"___MONO_PATH___" \
				"${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
		fi

		if use system-mrab-regex ; then
			ycmd_config_use_system REGEX
			ycmd_config_set_default_src_path \
				"___SYSTEM_REGEX_PATH___" \
				"${sitedir}/regex"
			sed -i -e "s|  BuildRegexModule|  #BuildRegexModule|" \
				build.py || die
		fi

		# Disabled because there is no standard ebuild-package and version that matches.
		#if use system-omnisharp ; then
		#	ycmd_config_use_system ROSLYN_OMNISHARP
		#	ycmd_config_set_default_src_path \
		#		"___SYSTEM_OMNISHARP_PATH___" \
		#		""
		#	ycmd_config_set_default_src_path \
		#		"___SYSTEM_ROSYLN_BINARY_PATH___" \
		#		""
		#	ycmd_config_set_default_json_path \
		#		"___ROSYLN_BINARY_PATH___" \
		#		""
		#else
			ycmd_config_set_default_json_path \
				"___ROSYLN_BINARY_PATH___" \
				"${BD_ABS}/third_party/omnisharp-roslyn/Omnisharp.exe"
		#fi

		if use system-requests ; then
			ycmd_config_use_system REQUESTS
			ycmd_config_set_default_src_path \
				"___SYSTEM_REQUESTS_PATH___" \
				"${sitedir}/requests"
		fi

		if use system-rust ; then
			ycmd_config_use_system RUST
			ycmd_config_set_default_src_path \
				"___SYSTEM_RLS_PATH___" \
				"/usr/bin/rls"
			ycmd_config_set_default_src_path \
				"___SYSTEM_RUSTC_PATH___" \
				"/usr/bin/rustc"
			ycmd_config_set_default_json_path \
				"___RLS_PATH___" \
				"/usr/bin/rls"
			ycmd_config_set_default_json_path \
				"___RUSTC_PATH___" \
				"/usr/bin/rustc"
		fi

		if use system-tern ; then
			ycmd_config_use_system TERN
			ycmd_config_set_default_src_path \
				"___SYSTEM_TERN_PATH___" \
				"/usr/bin/tern"
		fi

		if use system-typescript ; then
			ycmd_config_use_system TYPESCRIPT
			ycmd_config_set_default_src_path \
				"___SYSTEM_TSSERVER_PATH___" \
				"/usr/bin/tsserver"
			ycmd_config_set_default_json_path \
				"___TSSERVER_PATH___" \
				"/usr/bin/tsserver"
		else
			ycmd_config_set_default_json_path \
				"___TSSERVER_PATH___" \
"${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
		fi

		if use system-waitress ; then
			ycmd_config_use_system WAITRESS
			ycmd_config_set_default_src_path \
				"___SYSTEM_WAITRESS_PATH___" \
				"${sitedir}/waitress"
		fi

		if use system-watchdog ; then
			ycmd_config_use_system WATCHDOG
			ycmd_config_set_default_src_path \
				"___SYSTEM_WATCHDOG_PATH___" \
				"${sitedir}/watchdog"
			sed -i -e "s|  CompileWatchdog|  #CompileWatchdog|" \
				build.py || die
		fi

		if ! use vim ; then
			sed -i -e 's|"use_ultisnips_completer": 1,||g' \
				ycmd/default_settings.json || die
		fi

		ycmd_config_set_default_json_path \
			"___SYSTEM_PYTHON_PATH___" \
			"/usr/bin/${EPYTHON}"

		sed -i -e "s|\
___PYTHON_LIB_PATH___|\
/usr/$(get_libdir)/lib${EPYTHON}.so|g" \
			build.py || die

		# ---

		filter-flags -O0 -O1 -O3 -O4
		append-cxxflags -O2
		append-cflags -O2
		# We need to do this ourselves instead of rely on the build
		# script.  The build script has racing error when it tries to
		# do it through emerge.
		local mycmakeargs=(
			-DUSE_CLANG_COMPLETER=$(usex system-boost)
			-DUSE_DEV_FLAGS=$(usex debug)
			-DUSE_SYSTEM_BOOST=$(usex system-boost)
			-DUSE_SYSTEM_LIBCLANG=$(usex system-libclang)
			-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		)
		if [ -f /usr/$(get_libdir)/lib${EPYTHON}m.so ] ; then
			mycmakeargs+=(
			-DPYTHON_INCLUDE_DIR=/usr/include/${EPYTHON}m
			-DPYTHON_LIBRARY=/usr/$(get_libdir)/lib${EPYTHON}m.so
			)
		else
			mycmakeargs+=(
			-DPYTHON_INCLUDE_DIR=/usr/include/${EPYTHON}
			-DPYTHON_LIBRARY=/usr/$(get_libdir)/lib${EPYTHON}.so
			)
		fi
		if use c || use cxx || use objc || use objcxx ; then
			mycmakeargs+=( -DUSE_CLANG_COMPLETER=ON )
		fi
		CMAKE_USE_DIR="${BUILD_DIR}/cpp" \
		cmake-utils_src_configure
	}
	python_foreach_impl python_configure_all
}

src_compile() {
	python_compile_all() {
		cd "${BUILD_DIR}"
		if use go && ! use system-go-tools ; then
			src_compile_gopls
		fi

		local myargs=()
		if use c || use cxx || use objc || use objcxx ; then
			if use clangd ; then
				myargs+=( --clangd-completer )
			fi
			if use libclang ; then
				myargs+=( --clang-completer )
			fi
		fi
		if use csharp ; then
			myargs+=( --cs-completer )
		fi
		if use debug ; then
			myargs+=( --enable-debug )
		fi
#		go already installed
#		if use go \
#			&& ! use system-go-tools ; then
#			myargs+=( --go-completer )
#		fi
		if use java && ! use system-jdtls ; then
			myargs+=( --java-completer )
		fi
		if use javascript \
			&& ! use system-tern ; then
			myargs+=( --tern-completer )
		fi
#		rust already installed
#		if use rust \
#			&& ! use system-rust ; then
#			myargs+=( --rust-completer )
#		fi
		if use system-boost ; then
			myargs+=( --system-boost )
		fi
		if use system-libclang ; then
			myargs+=( --system-libclang )
		fi
		if use typescript \
			&& ! use system-typescript ; then
			myargs+=( --ts-completer )
		fi
		if \
			! use system-boost \
			|| ! use system-clangd \
			|| ! use system-go-tools \
			|| ! use system-jedi \
			|| ! use system-libclang \
			|| ! use system-rust \
			|| ! use system-tern \
			|| ! use system-typescript ; then
			einfo "Path A: Running build.py"
			einfo "${EPYTHON} build.py ${myargs[@]}"
			${EPYTHON} build.py ${myargs[@]}
		elif use system-libclang ; then
			einfo "Path B: Running cmake-utils_src_compile"
			cmake-utils_src_compile
		fi

		if use csharp && use system-mono ; then
			eapply \
"${FILESDIR}/${PN}-43_p20200516-omnisharp-use-system-omnisharp-run.patch"
		fi
	}
	python_foreach_impl python_compile_all
}

src_test() {
	python_test_all() {
		local allowed_completers=()
		if use c || use cxx || use objc || use objcxx ; then
			allowed_completers+=( cfamily )
		fi
		if use csharp ; then
			allowed_completers+=( cs )
		fi
		if use java ; then
			allowed_completers+=( java )
		fi
		if use python ; then
			allowed_completers+=( python )
		fi
		if use typescript ; then
			allowed_completers+=( typescript )
		fi
		cd "${BUILD_DIR}" || die
		${EPYTHON} run_tests.py --skip-build --completers \
			${allowed_completers[@]} || die
	}
	python_foreach_impl python_test_all
}

_shrink_install() {
	local arg_docs=( -false )
	if use doc ; then
		arg_docs=( -ipath "*/*doc*/*" )
	fi
	local arg_developer=( -false )
	if use developer ; then
		arg_developer=( -iname "*CODE_OF_CONDUCT*"
		-o -iname "*CONTRIBUT*"
		-o -iname "*TODO*" )
	fi
	local arg_legal=( -iname "*AUTHORS*"
		-o -iname "*CHANGELOG*"
		-o -iname "*COPYING*"
		-o -iname "*COPYRIGHT*"
		-o -iname "*HISTORY*"
		-o -iname "*license*"
		-o -iname "*licence*"
		-o -iname "*NOTICE*"
		-o -iname "*PATENTS*"
		-o -iname "*README*" )
	einfo "Cleaning third_party"
	find {third_party/bottle,third_party/jedi_deps,\
third_party/requests_deps,third_party/waitress,ycmd} \
		! \( -name "*.py" \
			-o -name "*.pyc" \
			-o -name "*.pyi" \
			-o -name "*.so" \
			-o -name "*.so.*" \
			-o -iname "default_settings.json" \
			-o -path "*/*.egg-info/*" \
			-o ${arg_docs[@]} \
			-o ${arg_developer[@]} \
			-o ${arg_legal[@]} \) \
		-exec rm -f "{}" + 2>/dev/null
	rm -rf third_party/jedi_deps/jedi/scripts || die
	rm -rf third_party/bottle/plugins || die
	if use csharp ; then
		einfo "Cleaning omnisharp-roslyn"
		find third_party/omnisharp-roslyn \
			! \(	-name "*.dll" \
				-o -name "*.so" \
				-o -name "*.config" \
				-o -name "*.pdb" \
				-o -name "*.exe" \
				-o -name "config" \
				-o -name "run" \
				-o -name "machine.config" \
				-o ${arg_docs[@]} \
				-o ${arg_developer[@]} \
				-o ${arg_legal[@]} \) \
			-exec rm -f "{}" + 2>/dev/null
		if ! use system-mono ; then
			rm -rf third_party/omnisharp-roslyn/{bin,lib,etc} || die
			# remove?
			#rm -rf third_party/omnisharp-roslyn/omnisharp/.msbuild || die
		fi
	fi
	if ! use system-mrab-regex ; then
		einfo "Cleaning regex"
		find third_party/cregex \
			! \( -name "*.so" \
				-o -path "*/*.egg-info/*" \
				-o -name "*.pyc" \
				-o -name "*.py" \
				-o ${arg_legal[@]} \) \
			-exec rm -f "{}" + 2>/dev/null
			# Only 3 supported upstream
			rm -rf third_party/cregex/regex_2 || die
	fi
	if use system-watchdog ; then
		einfo "Cleaning watchdog"
		rm -rf third_party/watchdog_deps/watchdog || die
	fi
	if use system-pathtools ; then
		einfo "Cleaning pathtools"
		rm -rf third_party/watchdog_deps/pathtools || die
	fi

	einfo "Cleaning out cpp build time files"
	rm -rf cpp || die

	if use go ; then
		einfo "Cleaning out go folders"
		find third_party/go ! \( -executable \
			-o ${arg_legal[@]} \) \
			-exec rm "{}" +
	fi

	einfo "Cleaning out VCS, CI, testing"
	find . \( -name ".git*" \
			-o -name "azure" \
			-o -name "azure-pipelines.yml" \
			-o -name "_travis" \
		\) \
		-exec rm -rf "{}" +
	if use rust \
		&& ! use system-rust ; then
		rm -rf "third_party/rls/lib/rustlib/src/rust/src/stdarch/ci" \
			|| die
	fi

	einfo "Cleaning out installer files"
	find . \( -name "setup.py" \) \
		-exec rm -rf "{}" +

	einfo "Cleaning out completers"
	pushd ycmd/completers || die
		if ! use c ; then
			rm -rf c || die
		fi
		if ! use cxx ; then
			rm -rf cpp || die
		fi
		if ! use csharp ; then
			rm -rf cs || die
		fi
		if ! use cuda ; then
			rm -rf cuda || die
		fi
		if ! use go ; then
			rm -rf go || die
		fi
		if ! use java ; then
			rm -rf java || die
		fi
		if ! use javascript ; then
			rm -rf javascript || die
		fi
		if ! use objc ; then
			rm -rf objc || die
		fi
		if ! use objcxx ; then
			rm -rf objcpp || die
		fi
		if ! use python ; then
			rm -rf python || die
		fi
		if ! use rust ; then
			rm -rf rust || die
		fi
		if ! use typescript ; then
			rm -rf typescript typescriptreact || die
		fi
		if ! use vim ; then
			rm -rf general/ultisnips_completer.py || die
		fi
	popd

	einfo "Cleaning out test files"
	find . \( -name "conftest.py" \
			-o -name "test.py" \) \
		-delete
	if use javascript \
		&& ! use system-tern ; then
		rm -rf "third_party/tern_runtime/node_modules/tern/bin/test" \
			"third_party/tern_runtime/node_modules/errno/build.js" \
			|| die
	fi
	rm -rf third_party/requests_deps/urllib3/dummyserver || die
	rm -rf third_party/generic_server

	einfo "Cleaning out test folders"
	find {third_party,ycmd} -ipath "*/*test*/*" \
		-exec rm -rf "{}" +

	einfo "Cleaning out unused platforms"
	if use java && ! use system-jdtls ; then
		rm -rf \
		third_party/eclipse.jdt.ls/target/repository/config_{mac,win} \
		|| die
	fi

	einfo "Cleaning out cached archives"
	if use clangd \
		&& ! use system-clangd ; then
		rm -rf third_party/clangd/cache
	fi

	einfo "Cleaning out empty files and folders"
	find . -empty -type f -delete
	find . -empty -type d -delete
}

src_install() {
	if use developer ; then
		DOCS+=( CODE_OF_CONDUCT.md CONTRIBUTING.md )
	fi
	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	python_install_all() {
		cd "${BUILD_DIR}" || die
		BD_ABS="$(python_get_sitedir)/${BD_REL}"
		python_moduleinto "${BD_REL}"
		python_domodule CORE_VERSION
		exeinto "${BD_ABS}"
		doexe ycm_core.so
		if use minimal ; then
			_shrink_install
		fi
		python_domodule ycmd
		insinto "/usr/share/${PN}-${PV_MAJ}"
		if use examples ; then
			doins -r examples
		fi

		python_moduleinto "${BD_REL}"

		if ! use system-libclang \
			&& ( use c || use cxx || use objc || use objcxx ) \
			&& use libclang ; then
			python_domodule lib
			fperms 0755 "${BD_ABS}/lib/libclang.so.${CLANG_V_MAJ}"
			python_moduleinto "${BD_REL}/third_party"
			python_domodule third_party/clang
			fperms 0755 \
"${BD_ABS}/third_party/clang/lib/libclang.so.${CLANG_V_MAJ}"
		fi

		python_moduleinto "${BD_REL}/third_party"
		if use java && ! use system-jdtls ; then
			python_domodule third_party/eclipse.jdt.ls
		fi

		if ! use system-bottle ; then
			python_domodule third_party/bottle
		fi

		if ! use system-clangd \
			&& ( use c || use cxx || use objc || use objcxx ) \
			&& use clangd ; then
			python_domodule third_party/clangd
			fperms 0755 \
				"${BD_ABS}/third_party/clangd/output/bin/clangd"
		fi

		if ! use system-mrab-regex ; then
			python_domodule third_party/cregex
			fperms 0755 \
			"${BD_ABS}/third_party/cregex/regex_3/_regex.so"
		fi

		if ! use system-go-tools \
			&& use go ; then
			python_domodule third_party/go
			fperms 0755 "${BD_ABS}/third_party/go/bin/gopls"
		fi

		if ! use system-jedi \
			&& use python ; then
			python_domodule third_party/jedi_deps
		fi

		if use csharp ; then
			python_domodule third_party/omnisharp-roslyn
			pushd "${ED}${BD_ABS}/third_party/omnisharp-roslyn" || die
				for f in $(find . -name "*.dll" \
						-o -name "*.so" \
						| sed -e "s|^./||g") ; do
					fperms 0755 \
				"${BD_ABS}/third_party/omnisharp-roslyn/${f}"
				done
			popd
			fperms 0755 \
		"${BD_ABS}/third_party/omnisharp-roslyn/run"
			if ! use system-mono ; then
				fperms 0755 \
		"${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
			fi
		fi

		if ! use system-requests ; then
			python_domodule third_party/requests_deps
		fi

		if ! use system-rust \
			&& use rust ; then
			python_domodule third_party/rls
			pushd "${ED}${BD_ABS}/third_party/rls" || die
				for f in $(find . -name "*.so" \
					-o \( -ipath "*/bin/*" -type f \) ) ; do
					fperms 0755 "${BD_ABS}/third_party/rls/${f}"
				done
			popd
		fi

		if ! use system-tern \
			&& use javascript ; then
			python_domodule third_party/tern_runtime
			fperms 0755 \
	"${BD_ABS}/third_party/tern_runtime/node_modules/errno/cli.js" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/acorn/bin/acorn" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/tern/bin/condense" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/tern/bin/tern"
		fi

		if ! use system-typescript \
			&& use typescript ; then
			python_domodule third_party/tsserver
			fperms 0755 \
"${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsc" \
"${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
		fi

		if ! use system-waitress ; then
			python_domodule third_party/waitress
		fi
	}
	python_foreach_impl python_install_all

#	if ! use system-libclang ; then
#		cat <<-EOF > "${T}"/50${P}-ycmd-${SLOT_MAJ}
#LDPATH="${BD_ABS}/lib"
#EOF
#		doenvd "${T}"/50${P}-ycmd-${SLOT_MAJ}
#	fi

	if use doc ; then
		einstalldocs
	fi
	docinto licenses
	dodoc COPYING.txt
	if use developer ; then
		docinto developer
		dodoc CODE_OF_CONDUCT.md CONTRIBUTING.md DEBUG.md TESTS.md
	fi
	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

pkg_postinst() {
	local m=\
"Examples of the .json files can be found at:\n\
\n\
/usr/$(get_libdir)/python*/site-packages/${BD_REL}/ycmd/default_settings.json\n"

	if use c || use cxx || use objc || use objcxx ; then
		m+="\
\n\
Consider emerging ycm-generator to properly generate a .ycm_extra_conf.py\n\
which is mandatory for the c/c++/objc/objc++ completer.\n\
\n\
After generating it, it may need to be slightly modified.\n"
	fi

	if use csharp ; then
		m+="\
\n\
You need a .sln file in your project for C# support\n"
	fi

	if use javascript ; then
		m+="\
\n\
You need a .tern-project in your project for javascript support.\n"
	fi

	if use system-rust ; then
		m+="\
\n\
You need to download the rust source code manually and tell YCMD to locate it
in the default_settings.json file.\n"
	fi
	einfo "${m}"
}
