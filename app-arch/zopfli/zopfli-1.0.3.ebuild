# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NOTO_EMOJI_PV="2.038"
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
TRAINERS=(
zopfli_trainers_zopflipng_with_noto_emoji
)

inherit check-compiler-switch cmake flag-o-matic uopts

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${P}"
SRC_URI="
	https://github.com/google/zopfli/archive/${P}.tar.gz
	zopfli_trainers_zopflipng_with_noto_emoji? (
		https://github.com/googlefonts/noto-emoji/archive/refs/tags/v${NOTO_EMOJI_PV}.tar.gz
			-> noto-emoji-${NOTO_EMOJI_PV}.tar.gz
	)
"

DESCRIPTION="A very good, but slow, deflate or zlib compression"
HOMEPAGE="https://github.com/google/zopfli/"
LICENSE="
	Apache-2.0
	zopfli_trainers_zopflipng_with_noto_emoji? (
		(
			all-rights-reserved
			Apache-2.0
		)
		OFL-1.1
	)
"
# The Apache-2.0 does not have all rights reserved in the template.
# The noto-emoji tarball is OFL-1.1, Apache-2.0, public-domain.
SLOT="0/1"
IUSE+="
${TRAINERS[@]}
bolt-aggressive-optimizations
"
REQUIRED_USE+="
	bolt-aggressive-optimizations? (
		|| (
			bolt
		)
	)
	bolt? (
		zopfli_trainers_zopflipng_with_noto_emoji
	)
	pgo? (
		zopfli_trainers_zopflipng_with_noto_emoji
	)
"
DOCS=( CONTRIBUTORS README README.zopflipng )

pkg_setup() {
	check-compiler-switch_start
	export ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_=${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES:-30}
	if [[ -z "${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_}" ]] ; then
		ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_=30
	fi
	if (( ${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_} > 13739 )) ; then
		ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_=13739
	fi
	if (( ${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_} < 1 )) ; then
		ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_=1
	fi
	if ( has bolt ${IUSE_EFFECTIVE} && use bolt ) || ( has ebolt ${IUSE_EFFECTIVE} && use ebolt ) ; then
		# For the basic block reorder branch-predictor summary,
		# see https://github.com/llvm/llvm-project/blob/main/bolt/include/bolt/Passes/BinaryPasses.h#L139
		local extra_args=""
		use bolt-aggressive-optimizations && extra_args+=" \
-icf \
-indirect-call-promotion=all \
-frame-opt=hot \
-jump-tables=aggressive \
-reg-reassign \
-simplify-rodata-loads \
-use-aggr-reg-reassign \
"
		export UOPTS_BOLT_OPTIMIZATIONS=${UOPTS_BOLT_OPTIMIZATIONS:-" \
-reorder-blocks=ext-tsp \
-reorder-functions=hfsort \
-split-functions \
-split-all-cold \
-split-eh \
-dyno-stats \
${extra_args} \
"}
	fi
	uopts_setup
}

src_unpack() {
	unpack ${P}.tar.gz
	if use zopfli_trainers_zopflipng_with_noto_emoji ; then
		unpack noto-emoji-${NOTO_EMOJI_PV}.tar.gz
	fi
}

src_prepare() {
	cmake_src_prepare
	uopts_src_prepare
}

src_configure() { :; }

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

_src_configure() {
	uopts_src_configure

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Upstream uses -O3 instead of -O2 recently
	replace-flags -O0 -O3
	replace-flags -O1 -O3
	replace-flags -O2 -O3
	replace-flags -Os -O3
	replace-flags -Oz -O3
	# Allow -Ofast
	if is-flagq '-O3' || is-flag '-Ofast' ; then
		:
	else
		append-flags -O3
	fi

	cmake_src_configure
}

_src_compile() {
	cmake_src_compile
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
	local path
	local i=0

einfo "ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES:\t${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_} out of ${#L[@]}"
	for path in ${L[@]} ; do
		(( ${i} > ${ZOPFLI_TRAINER_NOTO_EMOJI_N_IMAGES_} )) && break
		local cmd=(
			zopflipng -y "${path}" "${T}/trash/"$(basename "${path}")
		)
		einfo "Running:  ${cmd[@]}"
		"${cmd[@]}" || die
		i=$((${i} + 1))
	done
}

train_trainer_custom() {
	if use zopfli_trainers_zopflipng_with_noto_emoji ; then
		trainer_zopflipng_with_noto_emoji
	fi
}

src_install() {
	cmake_src_install
	uopts_src_install
}
