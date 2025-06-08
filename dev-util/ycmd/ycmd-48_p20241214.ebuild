# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# The support is based on the CI images (e.g. U24).  Only the current one is
# supported for security reasons because of prebuilt packages and the eager
# Python removal problem on distro's overlay.

# See build.py for dependency versions.
# See https://github.com/golang/tools/releases?after=gopls%2Fv0.16.2

# For the rust version see src/version in https://github.com/rust-lang
# and build.py in archive for nightly date.  Use committer-date:YYYY-MM-DD to search

# For omnisharp-roslyn min requirements, see
# https://github.com/OmniSharp/omnisharp-roslyn/blob/v1.37.11/build.json

# Last update for
# https://github.com/ycm-core/ycmd/commits/master/third_party
# Dec 13, 2024

# Last update for
# https://github.com/ycm-core/ycmd/blob/master/build.py
# Dec 14, 2024

PV_MAJ="${PV%%_*}"
SLOT_MAJ="${PV%%_*}"

BD_REL="ycmd/${SLOT_MAJ}" # Global variable
BD_ABS="" # Global variable
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CLANG_PV="19.1.0"
CLANG_PV_MAJ="${CLANG_PV%%.*}"
CMAKE_IN_SOURCE_BUILD=1
#EGIT_COMMIT="HEAD" # The lastest commit snapshot
EGIT_COMMIT_ABSEIL_CPP="d7aaad83b488fd62bd51c81ecf16cd938532cc0a"
EGIT_COMMIT_DJANGO_STUBS="fd057010f6cbf176f57d1099e82be46d39b99cb9"					# Jedi dep
EGIT_COMMIT_MRAB_REGEX="1bcd42e8381feaf3040f4b4a6a10dab912e6b59c"
EGIT_COMMIT_NUMPYDOC="3a8a96cda5e04ef77caa076be1fcd115e3987b62"
EGIT_COMMIT_TYPESHED="ae9d4f4b21bb5e1239816c301da7b1ea904b44c3"						# Jedi dep
FALLBACK_COMMIT="a51329a55f02ee3f16218c25ed5ee57b44cfc954"						# Dec 14, 2024
CLANGD_PV="${CLANG_PV}"
CMAKE_PV="3.14"
GOPLS_PV="0.9.4"
JAVA_SLOT="17"
JDTLS_PV="1.40.0-202409261450" # MILESTONE-TIMESTAMP in build.py
JEDI_PV="0.19.1"
LIBCLANG_PV="${CLANG_PV}"
MRAB_REGEX_PV="2021.10.23" # bf5e239
NODE_VERSION="22"
OMNISHARP_PV="1.37.11"
PARSO_PV="0.8.4"
PYTHON_COMPAT=( "python3_"{11..13} )
RUST_PV="nightly-2024-12-12"
WATCHDOG_PV="3.0.0"

S_GO="${S}/third_party/go"
S_DJANGO_STUBS="${WORKDIR}/django-stubs-${EGIT_COMMIT_DJANGO_STUBS}"
S_MRAB_REGEX="${WORKDIR}/mrab-regex-${EGIT_COMMIT_MRAB_REGEX}"
S_NUMPYDOC="${WORKDIR}/numpydoc-${EGIT_COMMIT_NUMPYDOC}"
S_JEDI="${WORKDIR}/jedi-${JEDI_PV}"
S_PARSO="${WORKDIR}/parso-${PARSO_PV}"
S_RUST="${S}/third_party/rust-analyzer"
S_TYPESHED="${WORKDIR}/typeshed-${EGIT_COMMIT_TYPESHED}"
S_WATCHDOG="${WORKDIR}/watchdog-${WATCHDOG_PV}"

inherit cflags-hardened cmake flag-o-matic java-pkg-opt-2 python-r1 sandbox-changes

#
# We speed up downloads for rebuilds by precaching the downloads outside of
# sandbox so we don't keep redownloading.  Some CIs will try to do a hermetic
# build by forcing downloads from the beginning, but for the average user
# without corporate Internet, it is annoying.
#
# libclang archives are listed in cpp/ycm/CMakeLists.txt
#
# For rust installers see,
#   https://forge.rust-lang.org/infra/other-installation-methods.html
#
# For rust precompiled binaries see,
#   https://static.rust-lang.org/dist/2021-10-26/channel-rust-nightly.toml
#
# For more info on Rust Release Channels see,
#   https://forge.rust-lang.org/infra/channel-layout.html
#

# For the gtest version, see
# https://github.com/ycm-core/ycmd/blob/a51329a55f02ee3f16218c25ed5ee57b44cfc954/cpp/ycm/tests/CMakeLists.txt
# https://github.com/google/googletest/blob/<googletest-commit-id>/CMakeLists.txt#L11

# For the clang version, see
# https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_PV_MAJ}.0.0/clang-${CLANG_PV_MAJ}.0.0.src.tar.xz

# Live ebuilds do not get KEYWORDed.  No tagged version in repo.
# Versioning based on CORE_VERSION.

# For dependencies, see also
# https://github.com/ycm-core/ycmd/blob/a51329a55f02ee3f16218c25ed5ee57b44cfc954/azure/linux/install_dependencies.sh

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	S_BAK="${WORKDIR}/${P}"
	S="${WORKDIR}/${P}"
else
	ABSEIL_FN="abseil-cpp-${EGIT_COMMIT_ABSEIL_CPP:0:7}.tar.gz"
	DJANGO_STUBS_FN="django-stubs-${EGIT_COMMIT_DJANGO_STUBS}.tar.gz"
	EGIT_COMMIT="${FALLBACK_COMMIT}"
	MRAB_REGEX_FN="mrab-regex-${MRAB_REGEX_PV}-${EGIT_COMMIT_MRAB_REGEX:0:12}.zip"
	NUMPYDOC_FN="numpydoc-${EGIT_COMMIT_NUMPYDOC:0:7}.tar.gz"
	JEDI_FN="jedi-${JEDI_PV}.tar.gz"
	PARSO_FN="parso-${PARSO_PV}.tar.gz"
	TYPESHED_FN="typeshed-${EGIT_COMMIT_TYPESHED:0:7}.tar.gz"
	WATCHDOG_FN="watchdog-${WATCHDOG_PV}.tar.gz"
	YCMD_FN="${P}-${EGIT_COMMIT:0:7}.tar.gz"

	PROPERTIES="live"
	S_BAK="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

	SRC_URI+="
https://github.com/mrabarnett/mrab-regex/archive/${EGIT_COMMIT_MRAB_REGEX}.zip
	-> ${MRAB_REGEX_FN}
https://github.com/davidhalter/django-stubs/archive/${EGIT_COMMIT_DJANGO_STUBS}.tar.gz
	-> ${DJANGO_STUBS_FN}
https://github.com/davidhalter/jedi/archive/refs/tags/v${JEDI_PV}.tar.gz
	-> ${JEDI_FN}
https://github.com/davidhalter/parso/archive/refs/tags/v${PARSO_PV}.tar.gz
	-> ${PARSO_FN}
https://github.com/davidhalter/typeshed/archive/${EGIT_COMMIT_TYPESHED}.tar.gz
	-> ${TYPESHED_FN}
https://github.com/gorakhargosh/watchdog/archive/refs/tags/v${WATCHDOG_PV}.tar.gz
	-> ${WATCHDOG_FN}
https://github.com/numpy/numpydoc/archive/${EGIT_COMMIT_NUMPYDOC}.tar.gz
	-> ${NUMPYDOC_FN}
https://github.com/ycm-core/ycmd/archive/${EGIT_COMMIT}.tar.gz
	-> ${YCMD_FN}
	!system-abseil? (
https://github.com/abseil/abseil-cpp/archive/${EGIT_COMMIT_ABSEIL_CPP}.tar.gz
	-> ${ABSEIL_FN}
	)
"
fi

SRC_URI+="
	!system-clangd? (
		clangd? (
			amd64? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${CLANGD_PV}/clangd-${CLANGD_PV}-x86_64-unknown-linux-gnu.tar.bz2
				)
			)
			arm64? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${CLANGD_PV}/clangd-${CLANGD_PV}-aarch64-linux-gnu.tar.bz2
				)
			)
			arm? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${CLANGD_PV}/clangd-${CLANGD_PV}-armv7a-linux-gnueabihf.tar.bz2
				)
			)
		)
	)
	!system-libclang? (
		libclang? (
			amd64? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${LIBCLANG_PV}/libclang-${LIBCLANG_PV}-x86_64-unknown-linux-gnu.tar.bz2
				)
			)
			arm? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${LIBCLANG_PV}/libclang-${LIBCLANG_PV}-armv7a-linux-gnueabihf.tar.bz2
				)
			)
			arm64? (
				elibc_glibc? (
https://github.com/ycm-core/llvm/releases/download/${LIBCLANG_PV}/libclang-${LIBCLANG_PV}-aarch64-linux-gnu.tar.bz2
				)
			)
		)
	)
	csharp? (
		amd64? (
https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_PV}/omnisharp.http-linux-x64.tar.gz
	-> omnisharp-${OMNISHARP_PV}.http-linux-x64.tar.gz
https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_PV}/omnisharp.http-linux-x86.tar.gz
	-> omnisharp-${OMNISHARP_PV}.http-linux-x86.tar.gz
		)
	)
	java? (
		!system-jdtls? (
https://download.eclipse.org/jdtls/milestones/${JDTLS_PV%-*}/jdt-language-server-${JDTLS_PV}.tar.gz
		)
	)
	rust? (
		!system-rust? (
https://static.rust-lang.org/dist/${RUST_PV#*-}/rust-src-nightly.tar.gz
	-> rust-src-nightly-${RUST_PV#*-}.tar.gz
		)
	)
"
TRASH="
"

gen_rust_dls()
{
	local gentoo_arch="${1}"
	local elibc_impl="${2}"
	local pkg_name="${3}"
	local arch_triple="${4}"
	local nightly_date="${RUST_PV#*-}"
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

if false ; then
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "cargo" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "clippy" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "rust-docs" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "rust-std" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "rustc" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "rustfmt" "x86_64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_glibc" "rust-analyzer" "x86_64-unknown-linux-gnu")

SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "cargo" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "clippy" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "rust-docs" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "rust-std" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "rustc" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "rustfmt" "x86_64-unknown-linux-musl")
SRC_URI+=" "$(gen_rust_dls "amd64" "elibc_musl" "rust-analyzer" "x86_64-unknown-linux-musl")

SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "cargo" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "clippy" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "rust-docs" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "rust-std" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "rustc" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "rustfmt" "aarch64-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "arm64" "elibc_glibc" "rust-analyzer" "aarch64-unknown-linux-gnu")

SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "cargo" "armv7-unknown-linux-gnueabihf")
SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "clippy" "armv7-unknown-linux-gnueabihf")
#SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "rust-docs" "armv7-unknown-linux-gnueabihf")
SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "rust-std" "armv7-unknown-linux-gnueabihf")
SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "rustc" "armv7-unknown-linux-gnueabihf")
SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "rustfmt" "armv7-unknown-linux-gnueabihf")
SRC_URI+=" "$(gen_rust_dls "arm" "elibc_glibc" "rust-analyzer" "armv7-unknown-linux-gnueabihf")

SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "cargo" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "clippy" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "rust-docs" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "rust-std" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "rustc" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "rustfmt" "i686-unknown-linux-gnu")
SRC_URI+=" "$(gen_rust_dls "x86" "elibc_glibc" "rust-analyzer" "i686-unknown-linux-gnu")

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

SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/tools/gopls" "golang/tools" "gopls/v0.16.2") # only the folder
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/BurntSushi/toml" "BurntSushi/toml" "v1.2.1")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/frankban/quicktest" "frankban/quicktest" "v1.14.6")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/google/go-cmp" "google/go-cmp" "v0.6.0")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/google/safehtml" "google/safehtml" "v0.1.0")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/jba/templatecheck" "jba/templatecheck" "v0.7.0")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/kr/pretty" "kr/pretty" "v0.3.1")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/kr/text" "kr/text" "v0.2.0")
SRC_URI+=" "$(gen_go_dl_gh_url "github.com/rogpeppe/go-internal" "rogpeppe/go-internal" "v1.12.0")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/exp/typeparams" "golang/exp" "v0.0.0-20221212164502-fae10dda9338")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/mod" "golang/mod" "v0.20.0")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/sync" "golang/sync" "v0.8.0")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/sys" "golang/sys" "v0.23.0")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/telemetry" "golang/telemetry" "v0.0.0-20240829154258-f29ab539cc98")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/text" "golang/text" "v0.3.3")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/text" "golang/text" "v0.16.0")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/tools" "golang/tools" "v0.0.0-20180917221912-90fa682c2a6e")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/tools" "golang/tools" "v0.22.1-0.20240829175637-39126e24d653")
SRC_URI+=" "$(gen_go_dl_gh_url "golang.org/x/vuln" "golang/vuln" "v1.0.4")
SRC_URI+=" "$(gen_go_dl_gh_url "gopkg.in/check.v1" "go-check/check" "v0.0.0-20161208181325-20d25e280405")
SRC_URI+=" "$(gen_go_dl_gh_url "gopkg.in/check.v1" "go-check/check" "v1.0.0-20190902080502-41f04d3bba15CC")
SRC_URI+=" "$(gen_go_dl_gh_url "honnef.co/go/tools" "dominikh/go-tools" "v0.4.7")
SRC_URI+=" "$(gen_go_dl_gh_url "mvdan.cc/gofumpt" "mvdan/gofumpt" "v0.6.0")
SRC_URI+=" "$(gen_go_dl_gh_url "mvdan.cc/xurls/v2" "mvdan/xurls" "v2.5.0")
SRC_URI+=" "$(gen_go_dl_gh_url "gopkg.in/yaml.v3" "go-yaml/yaml" "v3.0.1")
fi

DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
LICENSE="
	GPL-3+
	BSD
	!system-libclang? (
		Apache-2.0-with-LLVM-exceptions
		MIT
		UoI-NCSA
	)
	!system-mono? (
		all-rights-reserved
		BSD
		DOTNET-libraries-and-runtime-components-patents
		MIT
		Mono-patents
	)
	!system-mrab-regex? (
		all-rights-reserved
		Apache-2.0
		CNRI
	)
	!system-watchdog? (
		Apache-2.0
	)
	clangd? (
		!system-clangd? (
			Apache-2.0-with-LLVM-exceptions
			UoI-NCSA
		)
	)
	csharp? (
		all-rights-reserved
		MIT
	)
	examples? (
		Apache-2.0
	)
	go? (
		!system-gopls? (
			all-rights-reserved
			Apache-2.0
			BSD
			MIT
		)
	)
	java? (
		!system-jdtls? (
			all-rights-reserved
			Apache-1.1
			Apache-2.0
			BSD
			BSD-2
			dom4j
			EPL-1.0
			EPL-2.0
			JDOM
			LGPL-2.1
			MIT
			MPL-1.1
			W3C
			W3C-Document-License
		)
	)
	javascript? (
		!system-tern? (
			(
				all-rights-reserved
				MIT
			)
			CC-BY-SA-4.0
			ISC
		)
	)
	libclang? (
		!system-libclang? (
			Apache-2.0-with-LLVM-exceptions
			MIT
			UoI-NCSA
		)
	)
	python? (
		!system-jedi? (
			Apache-2.0
			BSD
			BSD-2
			MIT
			PSF-2
		)
	)
	rust? (
		!system-rust? (
			all-rights-reserved
			Apache-2.0
			Apache-2.0-with-LLVM-exceptions
			BSD
			BSD-1
			BSD-2
			BSD-4
			CC-BY-4.0
			GPL-2-with-linking-exception
			LGPL-2.1
			libcurl
			MIT
			OFL-1.1
			openssl
			Unlicense
			UoI-NCSA
			ZLIB
			|| (
				Apache-2.0
				MIT
			)
		)
	)
	test? (
		BSD
		GPL-3+
	)
	typescript? (
		!system-typescript? (
			(
				all-rights-reserved
				Apache-2.0
			)
			CC-BY-4.0
			MIT
			Unicode-DFS-2016
			W3C-Community-Final-Specification-Agreement
			W3C-Software-and-Document-Notice-and-License-2015
		)
	)
"

# Apache-2.0 with all-rights-reserved third_party/tsserver/node_modules/typescript/CopyrightNotice.txt [3]
# The original Apache-2.0 license does not contain all rights reserved

# Additional typescript licenses can be found in
#   third_party/tsserver/node_modules/typescript/ThirdPartyNoticeText.txt

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
# Apache-2.0-with-LLVM-exceptions third_party/rust-analyzer/lib/rustlib/src/rust/src/llvm-project/libunwind
# Apache-2.0 third_party/rust-analyzer/share/doc/rust/html/nomicon/fonts/OPEN-SANS-LICENSE.txt
# BSD third_party/rust-analyzer/share/doc/rust/html/nomicon/highlight.js
# CC-BY-4.0 third_party/rust-analyzer/share/doc/rust/html/nomicon/favicon.svg
# MIT Apache-2.0 \
#   third_party/rust-analyzer/lib/rustlib/src/rust/library/stdarch \
#   third_party/rust-analyzer/lib/rustlib/src/rust/library/stdarch/crates/core_arch \
#   third_party/rust-analyzer/lib/rustlib/src/rust/library/stdarch/crates/std_detect \
#   third_party/rust-analyzer/lib/rustlib/src/rust/library/backtrace
# OFL-1.1 MIT third_party/rust-analyzer/share/doc/rust/html/nomicon/FontAwesome/css/font-awesome.css
# OFL-1.1 third_party/rust-analyzer/share/doc/rust/html/nomicon/fonts/SOURCE-CODE-PRO-LICENSE.txt
# OFL-1.1 with all rights reserved third_party/rust-analyzer/share/doc/rust/html/SourceSerifPro-LICENSE.md [2]
# openssl GPL-2-with-linking-exception MIT LGPL-2.1 BSD libcurl Unlicense ZLIB \
#   third_party/rust-analyzer/share/doc/cargo/LICENSE-THIRD-PARTY

# [2] The OFL-1.1 does not come with all rights reserved

# The internal jedi with dependencies lists additional licenses for third party
#   Apache-2.0 BSD PSF-2 - scipy-sphinx-theme
#   Apache-2.0 MIT - jedi

# In jdt-language-server-0.68.0-202101202016.tar.gz
# MIT with all rights reserved [1] \
#   ./org.eclipse.m2e.maven.runtime.slf4j.simple_1.16.0.20200610-1735/about_files/slf4j-simple-LICENSE.txt
# MIT with all rights reserved [1] \
#   ./org.slf4j.api_1.7.30.v20200204-2150/about_files/SLF4J-LICENSE.txt

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

RESTRICT="mirror"
SLOT="${SLOT_MAJ}/${PVR}"
IUSE+="
c clangd csharp cuda cxx debug developer doc examples fallback-commit go java javascript
libclang minimal netcore netfx objc objcxx python rust system-abseil
system-clangd system-gopls system-jdtls system-jedi
system-libclang system-mono system-mrab-regex system-requests system-rust
system-rust system-tern system-typescript system-watchdog test typescript vim
ebuild_revision_2
"
if [[ "${PV}" =~ "9999" || "${PV}" =~ "_p" ]] ; then
	IUSE+="
		fallback-commit
	"
fi
# Missing rust-analyzer (aka rust-analyzer-preview) from rust packages because
# it is only available on nightly.  Forced nightly.
REQUIRED_USE+="
	!system-rust
	${PYTHON_REQUIRED_USE}
	c? (
		cxx
		|| (
			clangd
			libclang
		)
	)
	clangd? (
		|| (
			c
			cxx
			objc
			objcxx
		)
	)
	csharp? (
		|| (
			netcore
			netfx
		)
	)
	cuda? (
		cxx
		|| (
			clangd
			libclang
		)
	)
	cxx? (
		|| (
			clangd
			libclang
		)
	)
	libclang? (
		|| (
			c
			cxx
			objc
			objcxx
		)
	)
	objc? (
		cxx
		|| (
			clangd
			libclang
		)
	)
	objcxx? (
		cxx
		|| (
			clangd
			libclang
		)
	)
	system-clangd? (
		clangd
		|| (
			c
			cxx
			objc
			objcxx
		)
	)
	system-gopls? (
		go
	)
	system-jdtls? (
		java
	)
	system-jedi? (
		python
	)
	system-libclang? (
		libclang
		|| (
			c
			cxx
			objc
			objcxx
		)
	)
	system-rust? (
		rust
	)
	system-tern? (
		javascript
	)
	test? (
		system-requests
	)
"

NODEJS_RDEPEND="
	net-libs/nodejs:${NODE_VERSION%%.*}
"
NODEJS_BDEPEND="
	net-libs/nodejs:${NODE_VERSION%%.*}[npm]
"
NUMPYDOC_RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
"
RDEPEND+="
	${PYTHON_DEPS}
	csharp? (
		system-mono? (
			netfx? (
				>=dev-lang/mono-6.6.0
			)
			netcore? (
				>=dev-lang/mono-6.6.0
				|| (
					>=dev-dotnet/dotnetcore-sdk-bin-6.0.100:6.0
				)
			)
		)
	)
	java? (
		virtual/jre:${JAVA_SLOT}
	)
	javascript? (
		${NODEJS_RDEPEND}
	)
	python? (
		${NUMPYDOC_RDEPEND}
	)
	system-abseil? (
		|| (
			>=dev-cpp/abseil-cpp-20240116.2:0/20240116
		)
	)
	system-clangd? (
		>=llvm-core/clang-${CLANGD_PV}:${CLANG_PV_MAJ}
	)
	system-gopls? (
		>=dev-go/gopls-0.16.2
	)
	system-jdtls? (
		>=dev-java/jdt-${JDTLS_PV%-*}
	)
	system-jedi? (
		>=dev-python/jedi-${JEDI_PV}[${PYTHON_USEDEP}]
		>=dev-python/numpydoc-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/parso-${PARSO_PV}[${PYTHON_USEDEP}]
	)
	system-libclang? (
		>=llvm-core/clang-${LIBCLANG_PV}:${CLANG_PV_MAJ}
	)
	system-mrab-regex? (
		>=dev-python/regex-2024.09.11[${PYTHON_USEDEP}]
	)
	system-rust? (
		|| (
			>=dev-lang/rust-9999:1.83.0[clippy,rustfmt]
			>=dev-lang/rust-1.83.0_beta20241212:1.83.0[clippy,rustfmt]
		)
	)
	system-tern? (
		>=dev-nodejs/tern-0.24.3
	)
	system-typescript? (
		>=dev-lang/typescript-5.7.2
	)
	system-watchdog? (
		>=dev-python/watchdog-${WATCHDOG_PV}[${PYTHON_USEDEP}]
	)
	typescript? (
		${NODEJS_RDEPEND}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-${CMAKE_PV}
	dev-util/patchelf
	javascript? (
		${NODEJS_BDEPEND}
	)
	test? (
		>=dev-cpp/gtest-1.10.0
		>=dev-python/codecov-2.0.5[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-ycm-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.6.6[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-1.10.1[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}]
		dev-python/flake8-comprehensions[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
	typescript? (
		${NODEJS_BDEPEND}
	)
	|| (
		>=sys-devel/gcc-10
		>=llvm-core/clang-14
	)
"
DOCS=( "JAVA_SUPPORT.md" "README.md" )

pkg_setup() {
	if \
		( \
			! use system-tern \
				&& \
			  use javascript \
		) \
			|| \
		( \
			! use system-typescript \
				&& \
			  use typescript \
		) \
	; then
		sandbox-changes_no_network_sandbox "To download dependencies"
	fi

	# No standard ebuild yet.
	if use system-jdtls ; then
		if [[ -z "${EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH}" ]] ; then
eerror
eerror "You need to define EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH as a"
eerror "per-package envvar.  Do not include the EPREFIX."
eerror
			die
		fi
	fi

	java-pkg-opt-2_pkg_setup
	if use java ; then
		local java_vendor=$(java-pkg_get-vm-vendor)
		if ! [[ "${java_vendor}" =~ "openjdk" ]] ; then
ewarn
ewarn "Java vendor mismatch.  Runtime failure or quirks may show."
ewarn
ewarn "Actual Java vendor:  ${java_vendor}"
ewarn "Expected java vendor:  openjdk"
ewarn
		fi
		java-pkg_ensure-vm-version-eq "${JAVA_SLOT}"
	fi

	python_setup

	if use javascript ; then
		# prevent unpack problem with clangd or incomplete build
		if ! node --version 2> /dev/null 1>/dev/null ; then
eerror
eerror "Either install Node.js, fix node installation, or disable the"
eerror "javascript USE flag."
eerror
			die
		fi
	fi

	if use typescript ; then
		# prevent unpack problem with clangd or incomplete build
		if ! node --version 2> /dev/null 1>/dev/null ; then
eerror
eerror "Either install Node.js, fix node installation, or disable the"
eerror "typescript USE flag."
eerror
			die
		fi
	fi
}

check_version() {
	local name="${1}"
	local actual_version="${2}"
	local expected_version="${3}"
	if [[ "${actual_version}" != "${expected_version}" ]] ; then
eerror
eerror "${name}'s expected version:  ${expected_version}"
eerror "${name}'s actual version:  ${actual_version}"
eerror
eerror "Detected a version mismatch.  Tell the ebuild maintainer to about this."
eerror
eerror "QA actions required:"
eerror
eerror "  Ebuild version bump"
eerror "  .patch and pkg_prepare() correctness verification"
eerror "  *DEPENDs, IUSE, LICENSE updates"
eerror
		die
	fi
}

unpack_abseil() {
	pushd "${WORKDIR}" 2>&1 >/dev/null || die
		unpack "${ABSEIL_FN}"
		mv \
			"abseil-cpp-${EGIT_COMMIT_ABSEIL_CPP}" \
			"${S}/cpp/absl" \
			|| die
	popd 2>&1 >/dev/null || die
}

verify_versions() {
	# This is necessary for deterministic live ebuilds.
	if ! use system-abseil ; then
		actual_pv=$(grep "GIT_TAG" "cpp/CMakeLists.txt" \
			| grep -E -o -e "[0-9a-f]{40}")
		expected_pv="${EGIT_COMMIT_ABSEIL_CPP}"
		check_version "Abseil" "${actual_pv}" "${expected_pv}"
	fi
	if use clangd ; then
		actual_pv=$(grep "CLANGD_VERSION =" "build.py" \
			| cut -f 2 -d "'")
		expected_pv="${CLANGD_PV}"
		check_version "clangd" "${actual_pv}" "${expected_pv}"
	fi

	actual_pv=$(grep "cmake_minimum_required" "cpp/CMakeLists.txt" \
		| grep -E -o -e "[0-9.]+")
	expected_pv="${CMAKE_PV}"
	check_version "CMake" "${actual_pv}" "${expected_pv}"

	if use rust ; then
		actual_pv=$(grep "RUST_TOOLCHAIN =" "build.py" \
			| cut -f 2 -d "'")
		expected_pv="${RUST_PV}"
		check_version "Rust" "${actual_pv}" "${expected_pv}"
	fi

	if use java ; then
		local pv
		local bts
		pv=$(grep "JDTLS_MILESTONE =" "build.py" | cut -f 2 -d "'")
		bts=$(grep "JDTLS_BUILD_STAMP =" "build.py" | cut -f 2 -d "'")
		actual_pv="${pv}-${bts}"
		expected_pv="${JDTLS_PV}"
		check_version "jdtls" "${actual_pv}" "${expected_pv}"
	fi
	if use csharp ; then
		actual_pv=$(grep "/omnisharp.http-linux-x64" "build.py" \
			| cut -f 3 -d "/" \
			| sed -e "s|v||g")
		expected_pv="${OMNISHARP_PV}"
		check_version "OmniSharp-Roslyn" "${actual_pv}" "${expected_pv}"
	fi

	local range=$(grep -r -e "Python3 " "cpp/CMakeLists.txt" | cut -f 3 -d " ")
	if [[ "${range}" =~ "..." ]] ; then
		local min=$(grep -r -e "Python3 " "cpp/CMakeLists.txt" \
			| cut -f 3 -d " " \
			| sed -E -e "s|[.]{3}|-|g" \
			| cut -f 1 -d "-")
		local max=$(grep -r -e "Python3 " "cpp/CMakeLists.txt" \
			| cut -f 3 -d " " \
			| sed -E -e "s|[.]{3}|-|g" \
			| cut -f 2 -d "-")
		if ver_test ${EPYTHON/python} -lt ${min} \
			|| ver_test ${EPYTHON/python} -gt ${max} ; then
eerror
eerror "Python's expected range:  ${range}"
eerror "Python's actual range:  ${EPYTHON/python}"
eerror
			die
		fi
	else
		local min=$(grep -r -e "Python3 " "cpp/CMakeLists.txt" \
			| cut -f 3 -d " " \
			| sed -E -e "s|[.]{3}|-|g" \
			| cut -f 1 -d "-")
		if ver_test ${EPYTHON/python} -lt ${min} ; then
eerror
eerror "Python's expected minimum version:  ${min}"
eerror "Python's actual version:  ${EPYTHON/python}"
eerror
			die
		fi
	fi
}


src_unpack() {
	local actual_version
	local expected_version
	if [[ "${PV}" =~ "9999" ]] ; then
		EGIT_BRANCH="master"
		EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"
		use fallback-commit && export EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout

		actual_version=$(cat "${S}/CORE_VERSION")
		expected_version="${PV%%_*}"
		check_version "${PN}" "${actual_version}" "${expected_version}"
	else
		# Manually unpacked to prevent double unpack with Rust or Go.
		unpack \
			${YCMD_FN[@]} \
			${DJANGO_STUBS_FN} \
			${MRAB_REGEX_FN} \
			${NUMPYDOC_FN} \
			${JEDI_FN} \
			${PARSO_FN} \
			${SCIPY_SPHINX_THEME_FN} \
			${TYPESHED_FN} \
			${WATCHDOG_FN}
	fi

	cd "${S}" || die

	if [[ ! ( "${PV}" =~ "9999" ) ]] ; then
		local L=(
			"third_party/jedi_deps/jedi"
			"third_party/jedi_deps/numpydoc"
			"third_party/jedi_deps/numpydoc/doc/scipy-sphinx-theme"
			"third_party/jedi_deps/parso"
			"third_party/jedi_deps/jedi/jedi/third_party/typeshed"
			"third_party/jedi_deps/jedi/jedi/third_party/django-stubs"
			"third_party/mrab-regex-github"
			"third_party/watchdog_deps/watchdog"
		)
		rm -rf "${L[@]}" || die

		if ! use system-jedi && use python ; then
			mv \
				"${S_JEDI}" \
				"third_party/jedi_deps/jedi" \
				|| die
			mv \
				"${S_NUMPYDOC}" \
				"third_party/jedi_deps/numpydoc" \
				|| die
			mv \
				"${S_PARSO}" \
				"third_party/jedi_deps/parso" \
				|| die
			mv \
				"${S_TYPESHED}" \
				"third_party/jedi_deps/jedi/jedi/third_party/typeshed" \
				|| die
			mv \
				"${S_DJANGO_STUBS}" \
				"third_party/jedi_deps/jedi/jedi/third_party/django-stubs" \
				|| die
		fi
		if ! use system-mrab-regex ; then
			mv \
				"${S_MRAB_REGEX}" \
				"third_party/mrab-regex-github" \
				|| die
		fi
		if ! use system-watchdog ; then
			mv \
				"${S_WATCHDOG}" \
				"third_party/watchdog_deps/watchdog" \
				|| die
		fi
	fi

	if use clangd && ! use system-clangd ; then
		mkdir -p "third_party/clangd/cache" || die
		if use amd64 ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/clangd-${CLANGD_PV}-x86_64-unknown-linux-gnu.tar.bz2") \
					"third_party/clangd/cache" \
					|| die
			fi
		fi
		if use arm64 ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/clangd-${CLANGD_PV}-aarch64-linux-gnu.tar.bz2") \
					"third_party/clangd/cache" \
					|| die
			fi
		fi
		if use arm ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/clangd-${CLANGD_PV}-armv7a-linux-gnueabihf.tar.bz2") \
					"third_party/clangd/cache" \
					|| die
			fi
		fi
	fi

	if use libclang && ! use system-libclang ; then
		mkdir -p "clang_archives" || die
		if use amd64 ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/libclang-${LIBCLANG_PV}-x86_64-unknown-linux-gnu.tar.bz2") \
					"clang_archives" \
					|| die
			fi
		fi
		if use arm64 ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/libclang-${LIBCLANG_PV}-aarch64-linux-gnu.tar.bz2") \
					"clang_archives" \
					|| die
			fi
		fi
		if use arm ; then
			if use elibc_glibc ; then
				cp -a \
					$(realpath "${DISTDIR}/libclang-${LIBCLANG_PV}-armv7a-linux-gnueabihf.tar.bz2") \
					"clang_archives" \
					|| die
			fi
		fi
	fi

	if use csharp ; then
		mkdir -p "third_party/omnisharp-roslyn/v${OMNISHARP_PV}" || die
		if use amd64 ; then
			cp -a \
				$(realpath "${DISTDIR}/omnisharp-${OMNISHARP_PV}.http-linux-x64.tar.gz") \
				"third_party/omnisharp-roslyn/v${OMNISHARP_PV}/omnisharp.http-linux-x64.tar.gz" \
				|| die
		fi
		if use x86 ; then
			cp -a \
				$(realpath "${DISTDIR}/omnisharp-${OMNISHARP_PV}.http-linux-x86.tar.gz") \
				"third_party/omnisharp-roslyn/v${OMNISHARP_PV}/omnisharp.http-linux-x86.tar.gz" \
				|| die
		fi
	fi

	if use go && ! use system-gopls ; then
		unpack_gopls
	fi

	if use java && ! use system-jdtls ; then
		mkdir -p "third_party/eclipse.jdt.ls/target/cache" || die
		cp -a \
			$(realpath "${DISTDIR}/jdt-language-server-${JDTLS_PV}.tar.gz") \
			"third_party/eclipse.jdt.ls/target/cache" \
			|| die
	fi

	if use rust && ! use system-rust ; then
		_install_rust_locally
	fi

	if ! use system-abseil ; then
		unpack_abseil
	fi

	verify_versions
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
			--exclude="tools-${tag##*-}/gopls" \
			|| die
	elif [[ "${pkg_name}" == "golang.org/x/tools/gopls" ]] ; then
		tar --strip-components=2 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" \
			"tools-gopls-v${GOPLS_PV}/gopls" \
			|| die
	elif [[ "${pkg_name}" == "golang.org/x/tools/gopls" ]] ; then
ewarn "TODO:  Review unpack of golang.org/x/tools/gopls folder"
		tar --strip-components=2 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" \
			"tools-gopls-v${GOPLS_PV}/gopls" \
			|| die
	else
		tar --strip-components=1 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" \
			|| die
	fi
}

unpack_gopls()
{
	# See https://github.com/golang/tools/blob/gopls/v0.16.2/gopls/go.sum

	# The github.com and golang.org domains are trivial for <uri-frag> but
	# other domains need inspection on the "Go Packages" download site with
	# the Repository link.

	# unpack_go_pkg "<pkg-name>" "<uri-frag>" "<tag>"

	# The order matters because of unpacking
	unpack_go_pkg "golang.org/x/tools/gopls" "golang/tools" "gopls/v0.16.2"
	unpack_go_pkg "github.com/BurntSushi/toml" "BurntSushi/toml" "v1.2.1"
	unpack_go_pkg "github.com/frankban/quicktest" "frankban/quicktest" "v1.14.6"
	unpack_go_pkg "github.com/google/go-cmp" "google/go-cmp" "v0.6.0"
	unpack_go_pkg "github.com/google/safehtml" "google/safehtml" "v0.1.0"
	unpack_go_pkg "github.com/jba/templatecheck" "jba/templatecheck" "v0.7.0"
	unpack_go_pkg "github.com/kr/pretty" "kr/pretty" "v0.3.1"
	unpack_go_pkg "github.com/kr/text" "kr/text" "v0.2.0"
	unpack_go_pkg "github.com/rogpeppe/go-internal" "rogpeppe/go-internal" "v1.12.0"
	unpack_go_pkg "golang.org/x/exp/typeparams" "golang/exp" "v0.0.0-20221212164502-fae10dda9338"
	unpack_go_pkg "golang.org/x/mod" "golang/mod" "v0.20.0"
	unpack_go_pkg "golang.org/x/sync" "golang/sync" "v0.8.0"
	unpack_go_pkg "golang.org/x/sys" "golang/sys" "v0.23.0"
	unpack_go_pkg "golang.org/x/telemetry" "golang/telemetry" "v0.0.0-20240829154258-f29ab539cc98"
	unpack_go_pkg "golang.org/x/text" "golang/text" "v0.3.3"
	unpack_go_pkg "golang.org/x/text" "golang/text" "v0.16.0"
	unpack_go_pkg "golang.org/x/tools" "golang/tools" "v0.0.0-20180917221912-90fa682c2a6e"
	unpack_go_pkg "golang.org/x/tools" "golang/tools" "v0.22.1-0.20240829175637-39126e24d653"
	unpack_go_pkg "golang.org/x/vuln" "golang/vuln" "v1.0.4"
	unpack_go_pkg "gopkg.in/check.v1" "go-check/check" "v0.0.0-20161208181325-20d25e280405"
	unpack_go_pkg "gopkg.in/check.v1" "go-check/check" "v1.0.0-20190902080502-41f04d3bba15CC"
	unpack_go_pkg "honnef.co/go/tools" "dominikh/go-tools" "v0.4.7"
	unpack_go_pkg "mvdan.cc/gofumpt" "mvdan/gofumpt" "v0.6.0"
	unpack_go_pkg "mvdan.cc/xurls/v2" "mvdan/xurls" "v2.5.0"
	unpack_go_pkg "gopkg.in/yaml.v3" "go-yaml/yaml" "v3.0.1"
}

src_compile_gopls()
{
einfo "Building gopls"
	export GO111MODULE=auto
	export GOPATH="${BUILD_DIR}/third_party/go"
	export GOBIN="${GOPATH}/bin"
	mkdir -p "${GOBIN}" || die
	pushd "${GOBIN}" 2>&1 >/dev/null || die
		go build "golang.org/x/tools/gopls" || die
	popd 2>&1 >/dev/null || die
}

unpack_rust_pkg()
{
	local pkg_name="${1}"
	local arch_triple="${2}"
	local alt_name="${3}"
	local nightly_date="${RUST_PV#*-}"
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
		-x \
		-C "${dest}" \
		-f "${DISTDIR}/${fn}" \
		"${root_path}/${alt_name}" \
		|| die
}

_install_rust_locally()
{
	mkdir -p "${S_RUST}" || die
	if ! use system-rust && use rust ; then
		local arch="${CHOST%%-*}"
		case "${arch}" in
			"aarch64"*)
				if use elibc_glibc ; then
		unpack_rust_pkg "cargo" "aarch64-unknown-linux-gnu"
		unpack_rust_pkg "clippy" "aarch64-unknown-linux-gnu" "clippy-preview"
		unpack_rust_pkg "rust-docs" "aarch64-unknown-linux-gnu"
		unpack_rust_pkg "rust-std" "aarch64-unknown-linux-gnu" "rust-std-aarch64-unknown-linux-gnu"
		unpack_rust_pkg "rustc" "aarch64-unknown-linux-gnu"
		unpack_rust_pkg "rustfmt" "aarch64-unknown-linux-gnu" "rustfmt-preview"
		unpack_rust_pkg "rust-analyzer" "aarch64-unknown-linux-gnu" "rust-analyzer-preview"
				fi
				;;
			"armv7a"*"h"*)
				if use elibc_glibc ; then
		unpack_rust_pkg "cargo" "armv7-unknown-linux-gnueabihf"
		unpack_rust_pkg "clippy" "armv7-unknown-linux-gnueabihf" "clippy-preview"
		#unpack_rust_pkg "rust-docs" "armv7-unknown-linux-gnueabihf"
		unpack_rust_pkg "rust-std" "armv7-unknown-linux-gnueabihf" "rust-std-armv7-unknown-linux-gnueabihf"
		unpack_rust_pkg "rustc" "armv7-unknown-linux-gnueabihf"
		unpack_rust_pkg "rustfmt" "armv7-unknown-linux-gnueabihf" "rustfmt-preview"
		unpack_rust_pkg "rust-analyzer" "armv7-unknown-linux-gnueabihf" "rust-analyzer-preview"
				fi
				;;
			"x86_64"*)
				if use elibc_glibc ; then
		unpack_rust_pkg "cargo" "x86_64-unknown-linux-gnu"
		unpack_rust_pkg "clippy" "x86_64-unknown-linux-gnu" "clippy-preview"
		unpack_rust_pkg "rust-docs" "x86_64-unknown-linux-gnu"
		unpack_rust_pkg "rust-std" "x86_64-unknown-linux-gnu" "rust-std-x86_64-unknown-linux-gnu"
		unpack_rust_pkg "rustc" "x86_64-unknown-linux-gnu"
		unpack_rust_pkg "rustfmt" "x86_64-unknown-linux-gnu" "rustfmt-preview"
		unpack_rust_pkg "rust-analyzer" "x86_64-unknown-linux-gnu" "rust-analyzer-preview"
				fi
				if use elibc_musl ; then
		unpack_rust_pkg "cargo" "x86_64-unknown-linux-musl"
		unpack_rust_pkg "clippy" "x86_64-unknown-linux-musl" "clippy-preview"
		unpack_rust_pkg "rust-docs" "x86_64-unknown-linux-musl"
		unpack_rust_pkg "rust-std" "x86_64-unknown-linux-musl" "rust-std-x86_64-unknown-linux-musl"
		unpack_rust_pkg "rustc" "x86_64-unknown-linux-musl"
		unpack_rust_pkg "rustfmt" "x86_64-unknown-linux-musl" "rustfmt-preview"
		unpack_rust_pkg "rust-analyzer" "x86_64-unknown-linux-musl" "rust-analyzer-preview"
				fi
				;;
			"x86"*)
				if use elibc_glibc ; then
		unpack_rust_pkg "cargo" "i686-unknown-linux-gnu"
		unpack_rust_pkg "clippy" "i686-unknown-linux-gnu" "clippy-preview"
		unpack_rust_pkg "rust-docs" "i686-unknown-linux-gnu"
		unpack_rust_pkg "rust-std" "i686-unknown-linux-gnu" "rust-std-i686-unknown-linux-gnu"
		unpack_rust_pkg "rustc" "i686-unknown-linux-gnu"
		unpack_rust_pkg "rustfmt" "i686-unknown-linux-gnu" "rustfmt-preview"
		unpack_rust_pkg "rust-analyzer" "i686-unknown-linux-gnu" "rust-analyzer-preview"
				fi
				;;
			*)
eerror
eerror "CHOST:\t${CHOST}"
eerror "arch:\t${arch}"
eerror
eerror "Please use the system-rust USE flag instead."
eerror
				die
				;;
		esac
		unpack_rust_pkg "rust-src" ""
		echo "${RUST_PV}" > "${S_RUST}/TOOLCHAIN_VERSION" || die
	fi
}

_check_abi_supported()
{
	if ! use system-libclang && use libclang ; then
		if use elibc_musl ; then
eerror "Please use the system-libclang USE flag instead"
			die
		fi
einfo "Checking precompiled libclang support"
		local arch="${CHOST%%-*}"
einfo "CHOST:\t${CHOST}"
einfo "arch:\t${arch}"
		case "${arch}" in
			"aarch64"*)
einfo "Supported ${arch}"
				;;
			"armv7a"*"h"*)
einfo "Supported ${arch}"
				;;
			"x86_64"*)
einfo "Supported ${arch}"
				;;
			*)
eerror
eerror "CHOST:\t${CHOST}"
eerror "arch:\t${arch}"
eerror
eerror "Please use the system-libclang USE flag instead"
eerror
				die
				;;
		esac
	fi
}

src_prepare() {
	default
	local sitedir="$(python_get_sitedir)"
	_check_abi_supported
	eapply "${FILESDIR}/${PN}-44_p20210408-skip-thirdparty-check.patch"
	eapply "${FILESDIR}/${PN}-48_p20241214-system-third-party.patch"
	eapply "${FILESDIR}/${PN}-48_p20241214-system-global-config.patch"
	eapply "${FILESDIR}/${PN}-48_p20241214-disable-fetch-abseil.patch"

	cat \
		"${FILESDIR}/default_settings.json.44_p20200907" \
		> \
		"ycmd/default_settings.json" \
		|| die

	if use clangd ; then
ewarn "Using clangd is experimental."
	fi

	if use system-libclang ; then
		eapply "${FILESDIR}/${PN}-25_20170108-force-python-libs-path.patch"
	fi

	if ! use vim ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-remove-ultisnips.patch"
	fi

	local hash=$(cat "/dev/urandom" \
		| tr -d -c "_A-Z-a-z-0-9" \
		| head -c 16 \
		| base64)
	sed -i \
		-e "s|___HMAC_SECRET___|${hash}|g" \
		"ycmd/default_settings.json" \
		|| die

	sed -i \
		-e "s|___GLOBAL_YCMD_EXTRA_CONF___|/tmp/.ycm_extra_conf.py|" \
		"ycmd/default_settings.json" \
		|| die

	java-pkg-opt-2_src_prepare

	S="${S_BAK}" \
	BUILD_DIR="${S_BAK}" \
	python_copy_sources
}

ycmd_config_use()
{
	local i="${1}"
	sed -i -e "s|USE_${i} = False|USE_${i} = True|" \
		"ycmd/build_prefs.py" \
		|| die
}

ycmd_config_use_system()
{
	local i="${1}"
	sed -i \
		-e "s|USE_SYSTEM_${i} = False|USE_SYSTEM_${i} = True|" \
		"ycmd/build_prefs.py" \
		|| die
}

ycmd_config_set_default_src_path()
{
	local i="${1}"
	local path="${2}"
	sed -i \
		-e "s|${i}|${path}|g" \
		"ycmd/build_prefs.py" \
		|| die
}

ycmd_config_set_default_json_path()
{
	local i="${1}"
	local path="${2}"
	sed -i \
		-e "s|${i}|${path}|g" \
		"ycmd/default_settings.json" \
		|| die
}

src_configure() {
	export VERBOSE=1 # Show CMAKE compile flags for hardened inspection.
	cflags-hardened_append

	python_configure_all()
	{
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
		local sitedir="$(python_get_sitedir)"
		BD_ABS="$(python_get_sitedir)/${BD_REL}"

		if use clangd ; then
			ycmd_config_use "CLANGD"
		fi

		if use libclang ; then
			ycmd_config_use "LIBCLANG"
		fi

		if use system-clangd ; then
			ycmd_config_use_system "CLANGD"
			ycmd_config_set_default_src_path \
				"___SYSTEM_CLANGD_PATH___" \
				"${EPREFIX}/usr/lib/llvm/${CLANG_PV_MAJ}/bin/clangd"
			ycmd_config_set_default_json_path \
				"___CLANGD_PATH___" \
				"${EPREFIX}/usr/lib/llvm/${CLANG_PV_MAJ}/bin/clangd"
		else
			ycmd_config_set_default_json_path \
				"___CLANGD_PATH___" \
				"${BD_ABS}/third_party/clangd/output/bin/clangd"
		fi

		if use system-gopls ; then
			ycmd_config_use_system "GOPLS"
			ycmd_config_set_default_src_path \
				"___SYSTEM_GOPLS_PATH___" \
				"${EPREFIX}/usr/bin/gopls"
			ycmd_config_set_default_json_path \
				"___GOPLS_PATH___" \
				"${EPREFIX}/usr/bin/gopls"
		else
			ycmd_config_set_default_json_path \
				"___GOPLS_PATH___" \
				"${BD_ABS}/third_party/go/bin/gopls"
		fi

		local java_path=""

		if use java ; then
			local java_vendor=$(java-pkg_get-vm-vendor)
			  if [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${JAVA_SLOT}" ]] ; then
				java_path="${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${JAVA_SLOT}"
			elif [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-${JAVA_SLOT}" ]] ; then
				java_path="${EPREFIX}/usr/lib/jvm/${java_vendor}-${JAVA_SLOT}"
			fi
			[[ -n "${java_path}" ]] && java_path="${java_path}/bin/java"
		fi

		sed -i \
			-e "s|___JAVA_PATH___|${java_path}|g" \
			"ycmd/default_settings.json" \
			|| die

		if use system-jdtls && use java ; then
			ycmd_config_use_system "JDT"
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
				"\"${BD_ABS}/third_party/eclipse.jdt.ls/extensions\""
		fi

		if use system-jedi ; then
			ycmd_config_use_system "JEDI"
			ycmd_config_set_default_src_path \
				"___SYSTEM_JEDI_PATH___" \
				"${sitedir}/jedi"
		fi

		if use system-libclang ; then
			ycmd_config_use_system "LIBCLANG"
			ycmd_config_set_default_src_path \
				"___SYSTEM_CLANG_LIB_PATH___" \
				"${EPREFIX}/usr/lib/llvm/${CLANG_PV_MAJ}/$(get_libdir)"
			sed -i -e "s|\
EXTERNAL_LIBCLANG_PATH \${TEMP}|\
EXTERNAL_LIBCLANG_PATH \"${EPREFIX}/usr/lib/llvm/${CLANG_PV_MAJ}/$(get_libdir)/libclang.so\"|g" \
				"cpp/ycm/CMakeLists.txt" \
				|| die

			# Prevent from raising an exception.
			sed -i \
				-e "s|\
^CLANG_RESOURCE_DIR = GetClangResourceDir|\
#CLANG_RESOURCE_DIR = GetClangResourceDir|g" \
				"ycmd/utils.py" \
				|| die
		fi

		if use system-mono ; then
			ycmd_config_set_default_json_path \
				"___MONO_PATH___" \
				"${EPREFIX}/usr/bin/mono"
		else
			ycmd_config_set_default_json_path \
				"___MONO_PATH___" \
				"${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
		fi

		if use system-mrab-regex ; then
			ycmd_config_use_system "REGEX"
			ycmd_config_set_default_src_path \
				"___SYSTEM_REGEX_PATH___" \
				"${sitedir}/regex"
			sed -i \
				-e "s|  BuildRegexModule|  #BuildRegexModule|" \
				"build.py" \
				|| die
		fi

		# Disabled because there is no standard ebuild-package and version that matches.
		#if use system-omnisharp ; then
		#	ycmd_config_use_system "ROSLYN_OMNISHARP"
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
			ycmd_config_use_system "REQUESTS"
			ycmd_config_set_default_src_path \
				"___SYSTEM_REQUESTS_PATH___" \
				"${sitedir}/requests"
		fi

		if use system-rust ; then
			ycmd_config_use_system "RUST"
			ycmd_config_set_default_src_path \
				"___SYSTEM_RA_PATH___" \
				"${EPREFIX}/usr/bin/rust-analyzer"
			ycmd_config_set_default_src_path \
				"___SYSTEM_RUSTC_PATH___" \
				"${EPREFIX}/usr/bin/rustc"
			ycmd_config_set_default_json_path \
				"___RUST_TC_ROOT___" \
				"/usr"
		else
			ycmd_config_set_default_json_path \
				"___RUST_TC_ROOT___" \
				"${BD_ABS}/third_party/rust-analyzer"
		fi

		if use system-tern ; then
			ycmd_config_use_system "TERN"
			ycmd_config_set_default_src_path \
				"___SYSTEM_TERN_PATH___" \
				"${EPREFIX}/usr/bin/tern"
		fi

		if use system-typescript ; then
			ycmd_config_use_system "TYPESCRIPT"
			ycmd_config_set_default_src_path \
				"___SYSTEM_TSSERVER_PATH___" \
				"${EPREFIX}/usr/bin/tsserver"
			ycmd_config_set_default_json_path \
				"___TSSERVER_PATH___" \
				"${EPREFIX}/usr/bin/tsserver"
		else
			ycmd_config_set_default_json_path \
				"___TSSERVER_PATH___" \
				"${BD_ABS}/third_party/tsserver/node_modules/typescript/bin/tsserver"
		fi

		if use system-watchdog ; then
			ycmd_config_use_system "WATCHDOG"
			ycmd_config_set_default_src_path \
				"___SYSTEM_WATCHDOG_PATH___" \
				"${sitedir}/watchdog"
			sed -i \
				-e "s|  CompileWatchdog|  #CompileWatchdog|" \
				"build.py" \
				|| die
		fi

		if ! use vim ; then
			sed -i \
				-e 's|"use_ultisnips_completer": 1,||g' \
				"ycmd/default_settings.json" \
				|| die
		fi

		ycmd_config_set_default_json_path \
			"___SYSTEM_PYTHON_PATH___" \
			"${EPREFIX}/usr/bin/${EPYTHON}"

		sed -i \
			-e "s|\
___PYTHON_LIB_PATH___|\
/usr/$(get_libdir)/lib${EPYTHON}.so|g" \
			"build.py" \
			|| die
	}
	S="${S_BAK}" \
	BUILD_DIR="${S_BAK}" \
	python_foreach_impl python_configure_all
}

src_compile() {
	python_compile_all() {
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}"
		if use go && ! use system-gopls ; then
			src_compile_gopls
		fi

		local myargs=(
			--verbose
		)
		if \
			   use c \
			|| use cxx \
			|| use objc \
			|| use objcxx \
		; then
			if use clangd ; then
				myargs+=(
					--clangd-completer
				)
			fi
			if use libclang ; then
				myargs+=(
					--clang-completer
				)
			fi
		fi
		if use csharp ; then
			myargs+=(
				--cs-completer
			)
		fi
		if use debug ; then
			myargs+=(
				--enable-debug
			)
		fi
#		go already installed
#		if use go && ! use system-gopls ; then
#			myargs+=(
#				--go-completer
#			)
#		fi
		if use java && ! use system-jdtls ; then
			myargs+=(
				--java-completer
			)
		fi
		if use javascript && ! use system-tern ; then
			myargs+=(
				--tern-completer
			)
		fi
#		rust already installed
#		if use rust && ! use system-rust ; then
#			myargs+=(
#				--rust-completer
#			)
#		fi
		if use system-libclang ; then
			myargs+=(
				--system-libclang
			)
		fi
		if use typescript && ! use system-typescript ; then
			myargs+=(
				--ts-completer
			)
		fi
einfo "pwd="$(pwd)
einfo "Running:  ${EPYTHON} build.py ${myargs[@]}"
		${EPYTHON} "build.py" ${myargs[@]}

		if use csharp && use system-mono ; then
			eapply \
"${FILESDIR}/${PN}-45_p20220706-omnisharp-use-system-omnisharp-run.patch"
		fi
	}
	S="${S_BAK}" \
	BUILD_DIR="${S_BAK}" \
	python_foreach_impl python_compile_all
}

src_test() {
	python_test_all() {
		local allowed_completers=()
		if \
			   use c \
			|| use cxx \
			|| use objc \
			|| use objcxx \
		; then
			allowed_completers+=(
				"cfamily"
			)
		fi
		if use csharp ; then
			allowed_completers+=(
				"cs"
			)
		fi
		if use java ; then
			allowed_completers+=(
				"java"
			)
		fi
		if use python ; then
			allowed_completers+=(
				"python"
			)
		fi
		if use typescript ; then
			allowed_completers+=(
				"typescript"
			)
		fi
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
		${EPYTHON} "run_tests.py" \
			--skip-build \
			--completers \
			${allowed_completers[@]} \
			|| die
	}
	S="${S_BAK}" \
	BUILD_DIR="${S_BAK}" \
	python_foreach_impl python_test_all
}

_shrink_install() {
	local arg_docs=(
		-false
	)
	if use doc ; then
		arg_docs=(
			-ipath "*/*doc*/*"
		)
	fi
	local arg_developer=(
		-false
	)
	if use developer ; then
		arg_developer=(
			   -iname "*CODE_OF_CONDUCT*"
			-o -iname "*TODO*"
		)
	fi
	local arg_legal=(
		   -iname "*AUTHORS*"
		-o -iname "*CHANGELOG*"
		-o -iname "*CONTRIBUT*"
		-o -iname "*COPYING*"
		-o -iname "*COPYRIGHT*"
		-o -iname "*HISTORY*"
		-o -iname "*licen*"
		-o -iname "*NOTICE*"
		-o -iname "*PATENTS*"
		-o -iname "*README*"
	)
einfo "Cleaning third_party"
	find {"third_party/jedi_deps","ycmd"} \
		! \( \
			   -name "*.py" \
			-o -name "*.pyc" \
			-o -name "*.pyi" \
			-o -name "*.so" \
			-o -name "*.so.*" \
			-o -iname "default_settings.json" \
			-o -path "*/*.egg-info/*" \
			-o ${arg_docs[@]} \
			-o ${arg_developer[@]} \
			-o ${arg_legal[@]} \
		\) \
		-exec rm -f "{}" + 2>/dev/null
	rm -rf "third_party/jedi_deps/jedi/scripts" || die
	if use csharp ; then
einfo "Cleaning omnisharp-roslyn"
		find third_party/omnisharp-roslyn \
			! \( \
				   -name "*.dll" \
				-o -name "*.so" \
				-o -name "*.config" \
				-o -name "*.pdb" \
				-o -name "*.exe" \
				-o -name "config" \
				-o -name "run" \
				-o -name "machine.config" \
				-o ${arg_docs[@]} \
				-o ${arg_developer[@]} \
				-o ${arg_legal[@]} \
			\) \
			-exec rm -f "{}" + 2>/dev/null
		if ! use system-mono ; then
			rm -rf "third_party/omnisharp-roslyn/"{"bin","lib","etc"} || die
			# remove?
			#rm -rf "third_party/omnisharp-roslyn/omnisharp/.msbuild" || die
		fi
	fi
	if ! use system-mrab-regex ; then
einfo "Cleaning regex"
		rm -rf "third_party/mrab-regex" || die
		find "third_party/regex-build" \
			! \( \
				   -name "*.so" \
				-o -path "*/*.egg-info/*" \
				-o -name "*.pyc" \
				-o -name "*.py" \
				-o ${arg_legal[@]} \
			\) \
			-exec rm -f "{}" + 2>/dev/null
	fi
	if use system-watchdog ; then
einfo "Cleaning watchdog"
		rm -rf "third_party/watchdog_deps/watchdog" || die
	fi

einfo "Cleaning out cpp build time files"
	rm -rf "cpp" || die

	if use go ; then
einfo "Cleaning out go folders"
		find "third_party/go" \
			! \( \
				-executable \
				-o ${arg_legal[@]} \
			\) \
			-exec rm "{}" +
	fi

einfo "Cleaning out VCS, CI, testing"
	find . \
		\( \
			   -name ".git*" \
			-o -name "azure" \
			-o -name "azure-pipelines.yml" \
			-o -name "_travis" \
		\) \
		-exec rm -rf "{}" +
	if use rust && ! use system-rust ; then
		# TODO
		rm -rf "third_party/rls/lib/rustlib/src/rust/src/stdarch/ci" \
			|| die
	fi

einfo "Cleaning out installer files"
	find . \
		\( \
			-name "setup.py" \
		\) \
		-exec rm -rf "{}" +

einfo "Cleaning out completers"
	pushd "ycmd/completers" 2>&1 >/dev/null || die
		if ! use c ; then
			rm -rf "c" || die
		fi
		if ! use cxx ; then
			rm -rf "cpp" || die
		fi
		if ! use csharp ; then
			rm -rf "cs" || die
		fi
		if ! use cuda ; then
			rm -rf "cuda" || die
		fi
		if ! use go ; then
			rm -rf "go" || die
		fi
		if ! use java ; then
			rm -rf "java" || die
		fi
		if ! use javascript ; then
			rm -rf "javascript" || die
		fi
		if ! use objc ; then
			rm -rf "objc" || die
		fi
		if ! use objcxx ; then
			rm -rf "objcpp" || die
		fi
		if ! use python ; then
			rm -rf "python" || die
		fi
		if ! use rust ; then
			rm -rf "rust" || die
		fi
		if ! use typescript ; then
			rm -rf "typescript" "typescriptreact" || die
		fi
		if ! use vim ; then
			rm -rf "general/ultisnips_completer.py" || die
		fi
	popd 2>&1 >/dev/null || die

einfo "Cleaning out test files"
	find . \
		\( \
			   -name "conftest.py" \
			-o -name "test.py" \
		\) \
		-delete
	if use javascript && ! use system-tern ; then
		rm -rf "third_party/tern_runtime/node_modules/tern/bin/test" \
			"third_party/tern_runtime/node_modules/errno/build.js" \
			|| die
	fi
	rm -rf "third_party/generic_server" || die

einfo "Cleaning out test folders"
	find {"third_party","ycmd"} -ipath "*/*test*/*" \
		-exec rm -rf "{}" +

einfo "Cleaning out unused platforms"
	if use java && ! use system-jdtls ; then
		rm -rf \
		"third_party/eclipse.jdt.ls/target/repository/config_"{"mac","win"} \
		|| die
	fi

einfo "Cleaning out cached archives"
	if use clangd && ! use system-clangd ; then
		rm -rf "third_party/clangd/cache" || die
	fi
	if use csharp ; then
		rm -rf "third_party/omnisharp-roslyn/v${OMNISHARP_PV}/omnisharp.http-linux-"*".tar.gz" || die
	fi
	if use java && ! use system-jdtls ; then
		rm -rf "third_party/eclipse.jdt.ls/target/cache" || die
	fi

einfo "Cleaning out empty files and folders"
	find . -empty -type f -delete
	find . -empty -type d -delete
}

# From python-utils-r1.eclass
# Forked because it tries to optimize test cases which results in error.
python_domodule_no_optimize() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'

	local d
	if [[ "${_PYTHON_MODULEROOT}" == "/"* ]]; then
		# absolute path
		d="${_PYTHON_MODULEROOT}"
	else
		# relative to site-packages
		local sitedir=$(python_get_sitedir)
		d="${sitedir#${EPREFIX}}/${_PYTHON_MODULEROOT//.//}"
	fi

	if [[ "${EBUILD_PHASE}" == "install" ]]; then
		(
			insopts -m 0644
			insinto "${d}"
			doins -r "${@}" || return ${?}
		)
		#python_optimize "${ED%/}/${d}"
	elif [[ -n "${BUILD_DIR}" ]]; then
		local dest="${BUILD_DIR}/install${EPREFIX}/${d}"
		mkdir -p "${dest}" || die
		cp -pR "${@}" "${dest}/" || die
		(
			cd "${dest}" &&
			chmod -R a+rX "${@##*/}"
		) || die
	else
		die "${FUNCNAME} can only be used in src_install or with BUILD_DIR set"
	fi
}

src_install() {
	if use developer ; then
		DOCS+=(
			"CODE_OF_CONDUCT.md"
			"CONTRIBUTING.md"
		)
	fi
	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	python_install_all() {
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
		BD_ABS="$(python_get_sitedir)/${BD_REL}"
		python_moduleinto "${BD_REL}"
		python_domodule "CORE_VERSION"
		exeinto "${BD_ABS}"
		doexe $(ls "ycm_core.cpython-"*"-"*".so")
		if use minimal ; then
			_shrink_install
		fi
		python_domodule_no_optimize "ycmd"
		insinto "/usr/share/${PN}-${PV_MAJ}"
		if use examples ; then
			doins -r "examples"
		fi

		python_moduleinto "${BD_REL}"

		if \
			! use system-libclang \
				&& \
			( \
				   use c \
				|| use cxx \
				|| use objc \
				|| use objcxx \
			) \
				&& \
			use libclang \
		; then
			[[ -d "lib" ]] && python_domodule "lib"
			python_moduleinto "${BD_REL}/third_party"
			python_domodule "third_party/clang"
		fi

		python_moduleinto "${BD_REL}/third_party"

		if use csharp ; then
			python_domodule "third_party/omnisharp-roslyn"
		fi

		if \
			! use system-clangd \
				&& \
			( \
				   use c \
				|| use cxx \
				|| use objc \
				|| use objcxx \
			) \
				&& \
			use clangd \
		; then
			python_domodule "third_party/clangd"
		fi

		if ! use system-jdtls && use java ; then
			python_domodule "third_party/eclipse.jdt.ls"
		fi

		if ! use system-gopls && use go ; then
			python_domodule "third_party/go"
		fi

		if ! use system-jedi && use python ; then
			python_domodule "third_party/jedi_deps"
		fi

		if ! use system-mrab-regex ; then
			python_domodule "third_party/regex-build"
			pushd "${ED}${BD_ABS}/third_party/regex-build/regex" || die
			popd
		fi

		if ! use system-rust && use rust ; then
			python_domodule "third_party/rust-analyzer"
		fi

		if ! use system-tern && use javascript ; then
			python_domodule "third_party/tern_runtime"
		fi

		if ! use system-typescript && use typescript ; then
			python_domodule "third_party/tsserver"
		fi

		if ! use system-watchdog ; then
			python_moduleinto "${BD_REL}/third_party/watchdog_deps/watchdog/build"
			python_domodule "third_party/watchdog_deps/watchdog/build/lib3"
		fi

		local L=(
			$(realpath "${ED}/usr/lib/${EPYTHON}/site-packages/ycmd/${SLOT_MAJ}/ycm_core.cpython-"*"-"*"-linux-gnu.so")
		)

		local x
		for x in "${L[@]}" ; do
einfo "Updating RPATH for ${x}"
			[[ -e "${x}" ]] || die "Missing file"
			patchelf \
				--add-rpath "/usr/lib/${EPYTHON}/site-packages/ycmd/${SLOT_MAJ}/third_party/clang/lib/" \
				"${x}" \
				|| die
		done
	}
	S="${S_BAK}" \
	BUILD_DIR="${S_BAK}" \
	python_foreach_impl python_install_all
einfo "Restoring permissions"
	local x
	for x in $(find "${ED}" -type f) ; do
		[[ -L "${x}" ]] && continue
		local is_exe=0
		file "${x}" | grep -q -e "executable" && is_exe=1
		file "${x}" | grep -q -e "shared object" && is_exe=1
		file "${x}" | grep -q -e "shell script" && is_exe=1
		file "${x}" | grep -q -e "Python script" && is_exe=1
		if (( ${is_exe} )) ; then
			local f=$(echo "${x}" | sed -e "s|${ED}||g")
			fperms 0755 "${f}"
		fi
	done

#	if ! use system-libclang ; then
#		cat <<-EOF > "${T}"/50${P}-ycmd-${SLOT_MAJ}
#LDPATH="${BD_ABS}/lib"
#EOF
#		doenvd "${T}"/50${P}-ycmd-${SLOT_MAJ}
#	fi

	if use doc ; then
		einstalldocs
	fi
	docinto "licenses"
	dodoc "COPYING.txt"
	if use developer ; then
		docinto "developer"
		dodoc "CODE_OF_CONDUCT.md" "CONTRIBUTING.md" "DEBUG.md" "TESTS.md"
	fi

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

pkg_postinst() {
	if \
		   use c \
		|| use cxx \
		|| use objc \
		|| use objcxx \
	; then
einfo
einfo "Consider emerging ycm-generator to properly generate a"
einfo ".ycm_extra_conf.py which is mandatory for the c/c++/objc/objc++"
einfo "completer."
einfo
einfo "After generating it, it may need to be slightly modified."
einfo
	fi

	if use csharp ; then
einfo "You need a .sln file in your project for C# support\n"
	fi

	if use javascript ; then
einfo "You need a .tern-project in your project for javascript support."
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
