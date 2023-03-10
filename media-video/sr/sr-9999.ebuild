# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit git-r3 python-any-r1

DESCRIPTION="Image and video super resolution"
HOMEPAGE="https://github.com/HighVoltageRocknRoll/sr"
LICENSE="
	MIT
	!pretrained? (
		convert? ( LGPL-2.1 )
		custom
		all-rights-reserved
	)
	pretrained? (
		all-rights-reserved
	)
"
# DIV2K License:  https://data.vision.ee.ethz.ch/cvl/DIV2K/

# E. Agustsson, R. Timofte.  NTIRE 2017 Challenge on Single Image Super-Resolution: Dataset and Study, August 2017.

# @InProceedings{Ignatov_2018_ECCV_Workshops,
# author = {Ignatov, Andrey and Timofte, Radu and others},
# title = {PIRM challenge on perceptual image enhancement on smartphones: report},
# booktitle = {European Conference on Computer Vision (ECCV) Workshops},
# month = {January},
# year = {2019}
# }

# harmonicinc.box.com assets - all-rights-reserved (unknown license)
# dnn_models-ac3e1b2 - all-rights-reserved (unknown license)

# Ebuild developer(s) may plan to regenerate .pbs and .models and release it under CC0-1.0.
# Assets may be possibly used to PGO/BOLT optimize tensorflow package.

# TODO:
# Extract quality, resolutions, duration from assets.
# Modify source code with custom asset support to make licensing more free.

KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
ALGS=(
	"espcn"
	"srcnn"
	"vespcn"
	"vespcn-mc"
	"vsrnet"
)
FORMATS=(
	"native"
	"tensorflow"
)
IUSE+="
${ALGS[@]}
${FORMATS[@]}
convert fallback-commit libavfilter-headers +pretrained
"
# See formats see, https://ffmpeg.org/ffmpeg-filters.html#sr-1
# We use the tensorflow .pb because it is multicore.
REQUIRED_USE="
	|| (
		${FORMATS[@]}
	)
	|| (
		${ALGS[@]}
	)
	convert? (
		!pretrained
	)
"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	sci-libs/tensorflow[python]
"
# See https://github.com/HighVoltageRocknRoll/sr/issues/8
FFMPEG_PV="5.1.2"

# Save outside sandbox to avoid redownloads
# Still needs rehash.  About 3 GiB each
DISABLED_ASSETS_SRC_URI="
	!pretrained? (
https://harmonicinc.box.com/shared/static/58pxpuh1dsieye19pkj182hgv6fg4gof.mp4
https://harmonicinc.box.com/shared/static/6uws3kg4ldxtkeg5k5jwubueaolkqsr0.mp4
https://harmonicinc.box.com/shared/static/51ma04aviaeunhzelpw455sodv7judiu.mp4
https://harmonicinc.box.com/shared/static/uaj2o8ku7qhwwzviga9znzviwqg14x1g.mp4
https://harmonicinc.box.com/shared/static/e425git3jtnugqh8llzlgvr0r2j4j351.mp4
https://harmonicinc.box.com/shared/static/29b0z4w9lj4p54q2hf7il9jz6codx36v.mp4
https://harmonicinc.box.com/shared/static/n8x168w6vhpv240hggw7wtj8mszg7wnb.mp4
https://harmonicinc.box.com/shared/static/6inss29is5b7jzxv1qkuf2p9qeaomi04.mp4
https://harmonicinc.box.com/shared/static/v21fqn77ib1r8zlrbnl6fsyzt6rrjj0v.mp4
https://harmonicinc.box.com/shared/static/tmzm8y7bfzpote9obs7le3olh5j87iir.mp4
	)
"

SRC_URI="
	!pretrained? (
		convert? (
https://raw.githubusercontent.com/FFmpeg/FFmpeg/n${FFMPEG_PV}/tools/python/convert.py
	-> convert.py.${FFMPEG_PV}
https://raw.githubusercontent.com/FFmpeg/FFmpeg/n${FFMPEG_PV}/tools/python/convert_from_tensorflow.py
	-> convert_from_tensorflow.py.${FFMPEG_PV}
https://raw.githubusercontent.com/FFmpeg/FFmpeg/n${FFMPEG_PV}/tools/python/convert_header.py
	-> convert_header.py.${FFMPEG_PV}
https://raw.githubusercontent.com/FFmpeg/FFmpeg/n${FFMPEG_PV}/tools/python/tf_sess_config.py
	-> tf_sess_config.py.${FFMPEG_PV}
		)
https://harmonicinc.box.com/shared/static/wrlzswfdvyprz10hegws74d4wzh7270o.mp4
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_HR.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_HR.zip
	)
	pretrained? (
https://github.com/HighVoltageRocknRoll/sr/files/6957728/dnn_models.tar.gz
	-> ${PN}-dnn_models-ac3e1b2.tar.gz
	)
"
# dnn_models.tar.gz:  sha256 ac3e1b20bb942a3156042a07b7e68ed2aec66f49d92b48f5a4dfbf6cb5283417
RESTRICT="mirror"

request_sandbox_permissions() {
eerror "The trained version is still a Work In Progress (WIP)"
eerror "QA:  Assets still needs to be downloaded for Manifest."
	die
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download the internal dependencies."
eerror
		die
	fi
}

pkg_setup()
{
	python_setup
	use pretrained || request_sandbox_permissions
}

unpack_live() {
	EGIT_REPO_URI="https://github.com/HighVoltageRocknRoll/sr.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	use fallback-commit && EGIT_COMMIT="11b1d6fa38e5f1842d6b60d0b00db8b6cb7f63ec"
	git-r3_fetch
	git-r3_checkout
}

copy_converters() {
	mkdir -p "python" || die
	local L=(
		"convert.py"
		"convert_from_tensorflow.py"
		"convert_header.py"
		"tf_sess_config.py"
	)

	local name
	for name in ${L[@]} ; do
		cp -a \
			"${EDISTDIR}/${name}.${FFMPEG_PV}" \
			"${S}/python/${name}" \
			|| die
	done
}

copy_assets() {
	mkdir -p "${S}/datasets/loaded_div2k/train" || die
	mkdir -p "${S}/datasets/loaded_div2k/test" || die
	mkdir -p "${S}/datasets/loaded_harmonic" || die
	local name
	for name in ${A} ; do
		if [[ "${name}" =~ "DIV2K_train_LR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_train_LR_bicubic/X2" \
				"${S}/datasets/loaded_div2k/train/lr" \
				|| die
		fi
		if [[ "${name}" =~ "DIV2K_train_HR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_train_HR" \
				"${S}/datasets/loaded_div2k/train/hr" \
				|| die
		fi
		if [[ "${name}" =~ "DIV2K_valid_LR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_valid_LR_bicubic/X2" \
				"${S}/datasets/loaded_div2k/test/lr" \
				|| die
		fi
		if [[ "${name}" =~ "DIV2K_valid_HR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_valid_HR" \
				"${S}/datasets/loaded_div2k/test/hr" \
				|| die
		fi
		if [[ "${name}" =~ ".mp4" ]] ; then
			cp -a \
				"${EDISTDIR}/${name}" \
				"${S}/datasets/loaded_harmonic" \
				|| die
		fi
	done
}

av_scan_assets() {
	if has_version "app-antivirus/clamav[clamapp]" ; then
		einfo "Scanning assets for malware"
		clamscan -r "${WORKDIR}" || die
	fi
}

src_unpack() {
	if use pretrained ; then
		unpack ${A}
		export S="${WORKDIR}/dnn_models"
	else
		export S="${WORKDIR}/${P}"
ewarn "Expect training to last hours"
		local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
		unpack_live
		use convert && copy_converters
		copy_assets
	fi
}

src_prepare() {
	default
	if ! use pretrained ; then
		eapply "${FILESDIR}/${PN}-9999-skip-unpack.patch"
	fi
	av_scan_assets
}

src_configure() {
	:;
}

get_algs() {
	local alg
	for alg in ${ALGS[@]} ; do
		use "${alg}" && echo "${alg}"
	done
}

generate_datasets() {
	einfo "Generating datasets"
	./generate_datasets.sh || die
}

train_algs() {
	local alg
	for alg in $(get_algs) ; do
		einfo "Generating binary model for ${alg^^}"
		train_${alg}.sh
		# See https://github.com/HighVoltageRocknRoll/sr/issues/2#issuecomment-691790435
		${EPYTHON} generate_header_and_model.py \
			--model="${alg}" \
			--ckpt_path="logdir/${alg}_batch_32_lr_1e-3_decay_adam/train" \
			|| die
		# The above produces ./${alg}.pb
	done
}

convert_all_pb_to_model() {
	einfo "Converting .pb to .model"
	local alg
	for alg in $(get_algs) ; do
		${EPYTHON} "${S}/python/convert.py" \
			--infmt tensorflow \
			--outdir . \
			${alg}.pb \
			|| die
		# The above produces ./${alg}.model
	done
}

train() {
	generate_datasets
	train_algs
	use convert && convert_all_pb_to_model
}

src_compile() {
	use pretrained || train
}

src_install() {
	local alg
	for alg in $(get_algs) ; do
		insinto /usr/share/${PN}/headers
		if use libavfilter-headers ; then
			doins dnn_${alg}.h
		fi
		insinto /usr/share/${PN}/models
		if use native ; then
			doins ${alg}.model
		fi
		if use tensorflow ; then
			doins ${alg}.pb
		fi
	done
}
