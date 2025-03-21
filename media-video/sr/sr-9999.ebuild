# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: undo keras3 changes

# FIXME:
#  File "/var/tmp/portage/media-video/sr-9999/work/sr-9999/models/model_espcn.py", line 32, in load_model
#    net = tf.layers.conv2d(lr_batch, 64, 5, activation=tf.nn.tanh, padding='valid', name='conv1',
#          ^^^^^^^^^^^^^^^^
#  File "/usr/lib/python3.11/site-packages/tensorflow/python/util/lazy_loader.py", line 207, in __getattr__
#    raise AttributeError(
#AttributeError: `conv2d` is not available with Keras 3.


# If you encounter:
# !!! Multiple package instances within a single package slot have been pulled
# !!! into the dependency graph, resulting in a slot conflict:
# media-video/ffmpeg:0
#  (media-video/ffmpeg-6.0.1:0/58.60.60::oiledmachine-overlay, ebuild scheduled for merge) ...
#  (media-video/ffmpeg-4.4.4:0/56.58.58::oiledmachine-overlay, ebuild scheduled for merge) ...
# Fix:  emerge with --ignore-built-slot-operator-deps=y if `emerge -vuDN sr`

# See https://github.com/HighVoltageRocknRoll/sr/issues/8
ALGS=(
	"espcn"
	"srcnn"
	"vespcn"
	"vespcn-mc"
	"vsrnet"
)
FFMPEG_SUBSLOTS=(
	"56.58.58" # 4.x
)
FORMATS=(
	"native"
	"tensorflow"
)
MAINTAINER_MODE=0
PYTHON_COMPAT=( "python3_"{10..12} ) # Limited by tensorflow
QUICK_TEST_VIDEO_ASSET="29b0z4w9lj4p54q2hf7il9jz6codx36v"

inherit edo git-r3 python-single-r1 security-scan

KEYWORDS="~amd64 ~x86"
# Save outside sandbox to avoid redownloads
SRC_URI="
	!pretrained? (
		!quick-test? (
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
		quick-test? (
https://harmonicinc.box.com/shared/static/${QUICK_TEST_VIDEO_ASSET}.mp4
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_train_HR.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_LR_bicubic_X2.zip
http://data.vision.ee.ethz.ch/cvl/DIV2K/DIV2K_valid_HR.zip
		)
	)
	pretrained? (
https://github.com/HighVoltageRocknRoll/sr/files/6957728/dnn_models.tar.gz
	-> ${PN}-dnn_models-ac3e1b2.tar.gz
	)
"
# dnn_models.tar.gz:  sha256 ac3e1b20bb942a3156042a07b7e68ed2aec66f49d92b48f5a4dfbf6cb5283417

DESCRIPTION="Image and video super resolution models"
HOMEPAGE="https://github.com/HighVoltageRocknRoll/sr"
LICENSE="
	MIT
	!pretrained? (
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

RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${ALGS[@]}
${FORMATS[@]}
div2k fallback-commit ffmpeg gstreamer harmonic -hvrr nvdec +pretrained
quick-test vaapi vdpau vpx
ebuild_revision_2
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
	native? (
		tensorflow
	)
	quick-test? (
		!pretrained
		harmonic
		div2k
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
if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
	NOT_PRETRAINED_DEPENDS="
		$(python_gen_cond_dep '
			(
				>=sci-ml/tensorflow-2[${PYTHON_USEDEP},python]
			)
			dev-python/tf-keras[${PYTHON_USEDEP}]
		')
	"
else
	NOT_PRETRAINED_DEPENDS="
		$(python_gen_cond_dep '
			(
				>=sci-ml/tensorflow-2[${PYTHON_USEDEP},python]
				<sci-ml/tensorflow-2.16[${PYTHON_USEDEP},python]
			)
			<dev-python/tf-keras-3[${PYTHON_USEDEP}]
		')
	"
fi

DEPEND+="
	${RDEPEND}
	!pretrained? (
		${NOT_PRETRAINED_DEPENDS}
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/tqdm[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},ffmpeg?,gstreamer?,python]
		')
	)
"
BDEPEND+="
	!pretrained? (
		${PYTHON_DEPS}
		app-crypt/rhash
		ffmpeg? (
			|| (
				media-video/ffmpeg:56.58.58[nvdec?,vaapi?,vdpau?,vpx?]
				media-video/ffmpeg:0/56.58.58[nvdec?,vaapi?,vdpau?,vpx?]
			)
		)
		gstreamer? (
			media-plugins/gst-plugins-meta[ffmpeg?]
		)
	)
	|| (
		media-video/ffmpeg:56.58.58[tensorflow?]
		media-video/ffmpeg:0/56.58.58[tensorflow?]
	)
	media-video/ffmpeg:=
"

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
einfo
einfo "Using the pretrained version."
einfo
	else
eerror
eerror "The trained version is still a Work In Progress (WIP)."
eerror "Use the pretrained USE flag instead."
eerror
	fi
	if use quick-test ; then
einfo "Quick test:  enabled"
	else
einfo "Quick test:  disabled"
	fi
	python_setup
	use pretrained || request_sandbox_permissions

	if use hvrr ; then
		export EGIT_REPO_PROVIDER="HighVoltageRocknRoll"
	else
		export EGIT_REPO_PROVIDER="XueweiMeng"
	fi
}

unpack_live() {
	if [[ "${EGIT_REPO_PROVIDER}" == "HighVoltageRocknRoll" ]] ; then
		EGIT_REPO_URI="https://github.com/HighVoltageRocknRoll/sr.git" # old
		EGIT_BRANCH="master"
		use fallback-commit && EGIT_COMMIT="11b1d6fa38e5f1842d6b60d0b00db8b6cb7f63ec" # May 24, 2019
	else
		# More compatible format
		EGIT_REPO_URI="https://github.com/XueweiMeng/sr.git"
		EGIT_BRANCH="sr_dnn_native"
		use fallback-commit && EGIT_COMMIT="59ba04394885f79b442f007c07e21169cd81a001" # May 22, 2019
	fi
	EGIT_COMMIT="HEAD"
	git-r3_fetch
	git-r3_checkout
}

copy_div2k_assets() {
	if [[ "${name}" =~ "DIV2K_train_LR" ]] ; then
		unpack "${name}"
		mv \
			"${WORKDIR}/DIV2K_train_LR_bicubic/X2/"* \
			"${S}/datasets/loaded_div2k/train/lr/X2" \
			|| die
	fi
	if [[ "${name}" =~ "DIV2K_train_HR" ]] ; then
		unpack "${name}"
		mv \
			"${WORKDIR}/DIV2K_train_HR/"* \
			"${S}/datasets/loaded_div2k/train/hr" \
			|| die
	fi
	if use espcn || use srcnn ; then
		if [[ "${name}" =~ "DIV2K_valid_LR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_valid_LR_bicubic/X2/"* \
				"${S}/datasets/loaded_div2k/test/lr/X2" \
				|| die
		fi
		if [[ "${name}" =~ "DIV2K_valid_HR" ]] ; then
			unpack "${name}"
			mv \
				"${WORKDIR}/DIV2K_valid_HR/"* \
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
		:
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
				"${S}/datasets/loaded_div2k/test/lr/X2" \
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
				"${S}/datasets/loaded_div2k/train/lr/X2" \
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

copy_assets() {
	mkdir -p "${S}/datasets/loaded_div2k/train/hr" || die
	mkdir -p "${S}/datasets/loaded_div2k/test/hr" || die
	mkdir -p "${S}/datasets/loaded_div2k/train/lr/X2" || die
	mkdir -p "${S}/datasets/loaded_div2k/test/lr/X2" || die
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
	if use quick-test ; then
einfo "Removing extra still image assets for quick test"
	# For debug, save just one of each
		rm -v $(find "${S}/datasets/loaded_div2k/train/hr" | sort | tail -n +3)
		rm -v $(find "${S}/datasets/loaded_div2k/train/lr/X2" | sort | tail -n +3)
		if use espcn || use srcnn ; then
			rm -v $(find "${S}/datasets/loaded_div2k/test/hr" | sort | tail -n +3)
			rm -v $(find "${S}/datasets/loaded_div2k/test/lr/X2" | sort | tail -n +3)
		fi

einfo "Removing extra movie assets for quick test"
	# For debug, save just one
	# Save the one with the fewest frames.
		rm -v $(find "${S}/datasets/loaded_harmonic" | sort | sed -e "/${QUICK_TEST_VIDEO_ASSET}/d")

	# Copy a few second(s) only
		pushd "${S}/datasets/loaded_harmonic" || die
			ffmpeg -i "${QUICK_TEST_VIDEO_ASSET}.mp4" -ss 0 -t 3 -c copy ${QUICK_TEST_VIDEO_ASSET}.t.mp4
			mv ${QUICK_TEST_VIDEO_ASSET}.t.mp4 ${QUICK_TEST_VIDEO_ASSET}.mp4
		popd || die
	fi

	local L=(
		"${S}/datasets/loaded_div2k/train/hr"
		"${S}/datasets/loaded_div2k/train/lr/X2"
		"${S}/datasets/loaded_harmonic"
	)
	if use espcn || use srcnn ; then
		L+=(
			"${S}/datasets/loaded_div2k/test/hr"
			"${S}/datasets/loaded_div2k/test/lr/X2"
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
		copy_assets
	fi
}

src_prepare() {
	default
	if ! use pretrained ; then
		eapply "${FILESDIR}/${PN}-9999-skip-unpack.patch"
		eapply "${FILESDIR}/${PN}-9999-tensorflow2-compat.patch"
		eapply "${FILESDIR}/${PN}-9999-use-pillow-resize.patch"
		eapply "${FILESDIR}/${PN}-9999-remove-scene-changes-arg.patch"
		eapply "${FILESDIR}/${PN}-9999-numpy-array-for-cvtColor.patch"

		sed -i -e "1aset -e" "${S}/generate_datasets.sh" || die
		if use espcn || use srcnn ; then
			:
		else
			sed -i -e "/test/d" "${S}/generate_datasets.sh" || die
		fi
	fi
	if [[ "${SR_SECURITY_SCAN:-1}" == "1" ]] ; then
		av_scan_assets
	fi
}

src_configure() {
	if has_version "media-video/56.58.58" ; then
		export PATH="/usr/$(get_libdir)/ffmpeg/56.58.58/bin:${PATH}"
	fi
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

train() {
	generate_datasets
	train_algs
}

src_compile() {
	local prefix
	if has_version "media-video/56.58.58" ; then
		prefix="/usr/$(get_libdir)/ffmpeg/56.58.58"
	else
		prefix="/usr"
	fi
	use pretrained || train
	if [[ -e "${prefix}/lib/ffmpeg/scripts/convert.py" ]] ; then
		local alg
		for alg in $(get_algs) ; do
			rm -f "${alg}.model"
			[[ "${alg}" == "vespcn-mc" ]] && continue # Conversion broken
	# The prebuilt .models are missing the FFMPEGDNNNATIVE header.
			edo ${EPYTHON} "${prefix}/lib/ffmpeg/scripts/convert.py" "${alg}.pb"
		done
	fi
	if [[ -e "/usr/$(get_libdir)/ffmpeg/scripts/tf_sess_config.py" ]] ; then
		edo ${EPYTHON} "${prefix}/lib/ffmpeg/scripts/tf_sess_config.py" | sed -e "/a serialized protobuf string/d" > "sess_config"
	fi
}

src_install() {
	local alg
	for alg in $(get_algs) ; do
		insinto "/usr/share/${PN}/models"
		if use native && [[ -e "${alg}.model" ]] ; then
			doins "${alg}.model"
		fi
		if use tensorflow ; then
			doins "${alg}.pb"
		fi
		if [[ -e "sess_config" ]] ; then
			doins "sess_config"
		fi
	done
}

pkg_postinst() {
	if [[ -e "/usr/share/${PN}/models/sess_config" ]] ; then
einfo
einfo "The session config to dnn_processing for the machine can be passed as"
einfo "follows:"
einfo
einfo "  dnn_processing=sess_config=$(cat /usr/share/${PN}/models/sess_config)"
einfo
einfo "The value can be obtained by running \`cat /usr/share/${PN}/models/sess_config\`"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES but only pretrained
