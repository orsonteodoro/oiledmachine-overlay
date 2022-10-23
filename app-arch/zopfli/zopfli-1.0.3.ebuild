# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic uopts

DESCRIPTION="Very good, but slow, deflate or zlib compression"
HOMEPAGE="https://github.com/google/zopfli/"
LICENSE="
	Apache-2.0
	trainer-zopflipng-with-noto-emoji? (
		( Apache-2.0 all-rights-reserved )
		OFL-1.1
	)
"
# The Apache-2.0 does not have all rights reserved in the template.
IUSE+="
	trainer-zopflipng-with-noto-emoji
"
REQUIRED_USE+="
	bolt? (
		trainer-zopflipng-with-noto-emoji
	)
	pgo? (
		trainer-zopflipng-with-noto-emoji
	)
"
NOTO_EMOJI_PV="2.038"
SRC_URI="
	https://github.com/google/zopfli/archive/${P}.tar.gz
	trainer-zopflipng-with-noto-emoji? (
		https://github.com/googlefonts/noto-emoji/archive/refs/tags/v${NOTO_EMOJI_PV}.tar.gz
			-> noto-emoji-${NOTO_EMOJI_PV}.tar.gz
	)
"

S="${WORKDIR}/${PN}-${P}"
# The noto-emoji tarball is OFL-1.1, Apache-2.0, public-domain.
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
DOCS=( CONTRIBUTORS README README.zopflipng )

pkg_setup() {
	uopts_setup
	export ZOPFLI_TRAINER_NOTO_EMOJI_PERCENT_IMAGES_=${ZOPFLI_TRAINER_NOTO_EMOJI_PERCENT_IMAGES:-1}
	if ( has bolt ${IUSE} && use bolt ) || ( has ebolt ${IUSE} && use ebolt ) ; then
		# For the basic block reorder branch-predictor summary,
		# see https://github.com/llvm/llvm-project/blob/main/bolt/include/bolt/Passes/BinaryPasses.h#L139
		export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-"-reorder-blocks=branch-predictor -reorder-functions=hfsort -split-functions -split-all-cold -split-eh -dyno-stats"}
	fi
}

src_unpack() {
	unpack ${P}.tar.gz
	if use trainer-zopflipng-with-noto-emoji ; then
		unpack noto-emoji-${NOTO_EMOJI_PV}.tar.gz
	fi
}

src_prepare() {
	cmake_src_prepare
	uopts_src_prepare
}

src_configure() { :; }

_src_configure() {
	uopts_src_configure

	# Upstream uses -O3 instead of -O2 recently
	replace-flags -O0 -O3
	replace-flags -O1 -O3
	replace-flags -O2 -O3
	replace-flags -Os -O3
	replace-flags -Oz -O3
	# Allow -Ofast
	if ! ( is-flagq '-O3' || is-flag '-Ofast' ) ; then
		append-flags -O3
	fi

	cmake_src_configure
}

_src_compile() {
	cmake_src_compile
}

_src_install() {
	cmake_src_install
}

src_compile() {
	export PATH_ORIG="${PATH}"
	uopts_src_compile
}

_src_pre_train() {
	export PATH="${BUILD_DIR}:${PATH}"
	einfo "PATH:\t${PATH}"
}

_src_post_train() {
	export PATH="${PATH_ORIG}"
	einfo "PATH:\t${PATH}"
}

trainer_zopflipng_with_noto_emoji() {
	mkdir -p "${T}/trash" || die
	local L=( $(find "${WORKDIR}/noto-emoji-${NOTO_EMOJI_PV}/png" -type f -name "*.png" | shuf) )
	local max=${#L[@]}
	local path
	local i=0

	max=$(python -c "print(int( ${max} * ( ${ZOPFLI_TRAINER_NOTO_EMOJI_PERCENT_IMAGES_} / 100 ) ))")
einfo "ZOPFLI_TRAINER_NOTO_EMOJI_PERCENT_IMAGES:\t${ZOPFLI_TRAINER_NOTO_EMOJI_PERCENT_IMAGES_}"
einfo "N training assets:\t${max} out of ${#L[@]}"
	for path in $(find "${WORKDIR}/noto-emoji-${NOTO_EMOJI_PV}/png" -type f -name "*.png") ; do
		(( ${i} > ${max} )) && break
		local cmd=(
			zopflipng -y "${path}" "${T}/trash/"$(basename "${path}")
		)
		einfo "Running:  ${cmd[@]}"
		"${cmd[@]}" || die
		i=$((${i} + 1))
	done
}

train_trainer_custom() {
	if use trainer-zopflipng-with-noto-emoji ; then
		trainer_zopflipng_with_noto_emoji
	fi
}

src_install() {
	uopts_src_install
}
