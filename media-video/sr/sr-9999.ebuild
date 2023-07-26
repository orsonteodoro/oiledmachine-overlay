# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 ) # Limited by tensorflow
inherit git-r3 python-r1 security-scan

DESCRIPTION="Image and video super resolution"
HOMEPAGE="https://github.com/HighVoltageRocknRoll/sr"
LICENSE="
	MIT
	!pretrained? (
		convert? (
			LGPL-2.1
		)
		div2k? (
			custom
		)
		harmonic? (
			all-rights-reserved
		)
	)
	pretrained? (
		all-rights-reserved
	)
"
# DIV2K License:  https://data.vision.ee.ethz.ch/cvl/DIV2K/

# E. Agustsson, R. Timofte.  NTIRE 2017 Challenge on Single Image Super-Resolution: Dataset and Study, August 2017.

# @InProceedings{Timofte_2018_CVPR_Workshops,
# author = {Timofte, Radu and Gu, Shuhang and Wu, Jiqing and Van Gool, Luc and Zhang, Lei and
# Yang, Ming-Hsuan and Haris, Muhammad and others},
# title = {NTIRE 2018 Challenge on Single Image Super-Resolution: Methods and Results},
# booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR) Workshops},
# month = {June},
# year = {2018}
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
convert div2k fallback-commit ffmpeg gstreamer harmonic nvdec +pretrained
vaapi vdpau vpx
"
# See formats see, https://ffmpeg.org/ffmpeg-filters.html#sr-1
# We use the tensorflow .pb because it is multicore.
REQUIRED_USE="
	!pretrained? (
		${PYTHON_REQUIRED_USE}
		gstreamer? (
			ffmpeg
		)
		nvdec? (
			ffmpeg
		)
		vpx? (
			gstreamer
		)
		|| (
			ffmpeg
			gstreamer
		)
	)
	convert? (
		!pretrained
	)
	|| (
		${FORMATS[@]}
	)
	|| (
		${ALGS[@]}
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
	!pretrained? (
		${PYTHON_DEPS}
	)
"
BDEPEND+="
	!pretrained? (
		${PYTHON_DEPS}
		>=sci-libs/tensorflow-2[${PYTHON_USEDEP},python]
		app-crypt/rhash
		dev-python/pillow[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},ffmpeg?,gstreamer?,python]
		ffmpeg? (
			>=media-video/ffmpeg-4[nvdec?,vaapi?,vdpau?,vpx?]
		)
		gstreamer? (
			media-plugins/gst-plugins-meta[ffmpeg?]
		)
	)
"
# See https://github.com/HighVoltageRocknRoll/sr/issues/8
FFMPEG_PV="5.1.2"

# Save outside sandbox to avoid redownloads
# Still needs rehash.  About 3-4 GiB each
DISABLED_SRC_URI="
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
		div2k? (
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_HR.zip
			espcn? (
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_HR.zip
			)
			srcnn? (
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_HR.zip
			)
		)
		harmonic? (
https://harmonicinc.box.com/shared/static/wrlzswfdvyprz10hegws74d4wzh7270o.mp4
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
	)
	pretrained? (
https://github.com/HighVoltageRocknRoll/sr/files/6957728/dnn_models.tar.gz
	-> ${PN}-dnn_models-ac3e1b2.tar.gz
	)
"
# dnn_models.tar.gz:  sha256 ac3e1b20bb942a3156042a07b7e68ed2aec66f49d92b48f5a4dfbf6cb5283417
RESTRICT="mirror"

request_sandbox_permissions() {
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
	if use pretrained ; then
eerror
eerror "The trained version is still a Work In Progress (WIP)."
eerror "Use the pretrained USE flag instead."
eerror
	else
einfo
einfo "Using the pretrained version."
einfo
	fi
	export SR_QUICK_TEST=${SR_QUICK_TEST:-0}
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

copy_div2k_assets() {
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
	if use espcn || use srcnn ; then
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
	fi
}

copy_harmonic_assets() {
	if [[ "${name}" =~ ".mp4" ]] ; then
		cp -v -a \
			"${EDISTDIR}/${name}" \
			"${S}/datasets/loaded_harmonic" \
			|| die
	fi
}

verify_integrity() {
	local esize=$(echo "${row}" | cut -f 2 -d ":")
	local eblake2b=$(echo "${row}" | cut -f 3 -d ":")
	local esha512=$(echo "${row}" | cut -f 4 -d ":")
	local asize=$(stat -c "%s" "${path}")
	local ablake2b=$(rhash --blake2b "${path}" | cut -f 1 -d " ")
	local asha512=$(sha512sum "${path}" | cut -f 1 -d " ")
	if [[ \
		   "${esize}" == "${asize}" \
		&& "${eblake2b}" == "${ablake2b}" \
		&& "${esha512}" == "${asha512}" \
	]] ; then
		:;
	else
eerror
eerror "Asset integrity failure detected"
eerror
eerror "Path:\t${path}"
eerror
eerror "Actual size:\t${asize}"
eerror "Expected size:\t${esize}"
eerror
eerror "Actual blake2b:\t${ablake2b}"
eerror "Expected blake2b:\t${eblake2b}"
eerror
eerror "Actual sha512:\t${asha512}"
eerror "Expected sha512:\t${esha512}"
eerror
		die
	fi
}

copy_custom_still_image_assets() {
	if [[ -n "${STILL_IMAGE_HR_TEST_PATHS}" ]] ; then
einfo "Adding highres still image test assets"
		local row
		for row in ${STILL_IMAGE_HR_TEST_PATHS} ; do
			local path=$(echo "${row}" | cut -f 1 -d ":")
			verify_integrity
			cp -v -a \
				"${path}" \
				"${S}/datasets/loaded_div2k/test/hr" \
				|| die
		done
	fi
	if [[ -n "${STILL_IMAGE_HR_TRAINING_PATHS}" ]] ; then
einfo "Adding highres still image training assets"
		local row
		for row in ${STILL_IMAGE_HR_TRAINING_PATHS} ; do
			local path=$(echo "${row}" | cut -f 1 -d ":")
			verify_integrity
			cp -v -a \
				"${path}" \
				"${S}/datasets/loaded_div2k/train/hr" \
				|| die
		done
	fi
	if [[ -n "${STILL_IMAGE_LR_TEST_PATHS}" ]] ; then
einfo "Adding lowres still image test assets"
		local row
		for row in ${STILL_IMAGE_LR_TEST_PATHS} ; do
			local path=$(echo "${row}" | cut -f 1 -d ":")
			verify_integrity
			cp -v -a \
				"${path}" \
				"${S}/datasets/loaded_div2k/test/lr" \
				|| die
		done
	fi
	if [[ -n "${STILL_IMAGE_LR_TRAINING_PATHS}" ]] ; then
einfo "Adding lowres still image training assets"
		local row
		for row in ${STILL_IMAGE_LR_TRAINING_PATHS} ; do
			local path=$(echo "${row}" | cut -f 1 -d ":")
			verify_integrity
			cp -v -a \
				"${path}" \
				"${S}/datasets/loaded_div2k/train/lr" \
				|| die
		done
	fi
}

copy_custom_movie_assets() {
	if [[ -n "${VIDEO_ASSET_PATHS}" ]] ; then
einfo "Adding video assets"
		local path
		for path in ${VIDEO_ASSET_PATHS} ; do
			local path=$(echo "${row}" | cut -f 1 -d ":")
			verify_integrity
			cp -a \
				"${path}" \
				"${S}/datasets/loaded_harmonic" \
				|| die
		done
	fi
}

keep_one_asset() {
	local path="${1}"
	rm $(find "${path}" -type f \
		| tr " " "\n" \
		| sort \
		| tail -n +2)
}

copy_assets() {
	mkdir -p "${S}/datasets/loaded_div2k/train" || die
	mkdir -p "${S}/datasets/loaded_div2k/test" || die
	mkdir -p "${S}/datasets/loaded_harmonic" || die
einfo "Custom assets may be used.  See metadata.xml for details."
	local name
	for name in ${A} ; do
		use div2k && copy_div2k_assets
		use harmonic && copy_harmonic_assets
		copy_custom_still_image_assets
		copy_custom_movie_assets
	done

	# For testing ebuild correctness
	if [[ "${SR_QUICK_TEST}" == "1" ]] ; then
einfo "Removing extra still image assets"
	# For debug, save just one of each
		keep_one_asset "${S}/datasets/loaded_div2k/train/hr"
		keep_one_asset "${S}/datasets/loaded_div2k/train/lr"
		if use espcn || use srcnn ; then
			keep_one_asset "${S}/datasets/loaded_div2k/test/hr"
			keep_one_asset "${S}/datasets/loaded_div2k/test/lr"
		fi

einfo "Removing extra movie assets"
	# For debug, save just one
		keep_one_asset "${S}/datasets/loaded_harmonic"
	fi

	local L=(
		"${S}/datasets/loaded_div2k/train/hr"
		"${S}/datasets/loaded_div2k/train/lr"
		"${S}/datasets/loaded_harmonic"
	)
	if use espcn || use srcnn ; then
		L+=(
			"${S}/datasets/loaded_div2k/test/hr"
			"${S}/datasets/loaded_div2k/test/lr"
		)
	fi

	local path
	for path in ${L[@]} ; do
		local nrows=$(ls -1 "${path}" \
			| tr " " "\n" \
			| wc -l)
		if (( ${nrows} <= 0 )) ; then
eerror "${path} must have at least 1 asset."
			die
		fi
	done
}

av_scan_assets() {
	security-scan_avscan "${WORKDIR}"
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
		eapply "${FILESDIR}/${PN}-9999-tensorflow2-compat.patch"
		eapply "${FILESDIR}/${PN}-9999-use-pillow-resize.patch"

		sed -i -e "1aset -e" "${S}/generate_datasets.sh" || die
		if use espcn || use srcnn ; then
			:;
		else
			sed -i -e "/test/d" "${S}/generate_datasets.sh" || die
		fi
	fi
	if [[ "${SR_SECURITY_SCAN:-1}" == "1" ]] ; then
		av_scan_assets
	fi
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
einfo "CWD:\t"$(pwd)
		./train_${alg}.sh || die
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
		insinto /usr/share/${PN}/models
		if use native ; then
			doins ${alg}.model
		fi
		if use tensorflow ; then
			doins ${alg}.pb
		fi
	done
}
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES but only pretrained
