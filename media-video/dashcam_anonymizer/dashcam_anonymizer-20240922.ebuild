# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_LOCATION="https://github.com/varungupta31/dashcam_anonymizer/tree/${FALLBACK_COMMIT}?tab=readme-ov-file#-blurring-images-in-a-directory--"
FALLBACK_COMMIT="644883f54ce4903e0d2f70e9e4e9e82b261b892b" # Sep 22, 2024
PYTHON_COMPAT=( "python3_"{10..12} )
MODELS=(
	# original file ; rename to ; size ; blake2b ; sha512
	"best.pt;dashcam_anonymizer-6dd713f-best.pt;83.6MB;5bde9b74b04e29a6164e13ab35a6d0d8d8628c02ed5286de82331fe9061e53a402af29bdca8a7853943ba8481a66b55184ddb6c41170196e45ede2a8a411aab3;6dd713ffe679bd3b0cf41795e39cc04d030f75754ba26683c36b48d6a74a78e51700850e813c0aa7b0cd245bb3b0be0d9846537fe5983805a40029dfbe6baa84"
)
MODEL_GDOWN_ID="1uV8IMuGDbmDabdjyeSy4SUKV9OS-ULbe"

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/varungupta31/dashcam_anonymizer.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
fetch+https://github.com/varungupta31/dashcam_anonymizer/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
best.pt -> dashcam_anonymizer-6dd713f-best.pt
	"
fi

DESCRIPTION="Blur human faces and vehicle license plates in video and images"
HOMEPAGE="
	https://github.com/varungupta31/dashcam_anonymizer
"
LICENSE="
	AGPL-3
	MIT
"
# AGPL-3 - YOLOv8 (best.pt)
RESTRICT="fetch mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cuda ffmpeg gstreamer openh264 rocm vaapi x264 xla xpu
ebuild_revision_8
"
REQUIRED_USE="
	|| (
		ffmpeg
		gstreamer
	)
	|| (
		openh264
		vaapi
		x264
	)
	openh264? (
		ffmpeg
	)
	vaapi? (
		gstreamer
	)
	x264? (
		gstreamer
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.25.1[${PYTHON_USEDEP}]
		dev-python/natsort[${PYTHON_USEDEP}]
		dev-python/pybboxes[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	')
	>=dev-python/ultralytics-8.0.144[${PYTHON_SINGLE_USEDEP}]
	>=media-libs/opencv-4.6.0[${PYTHON_SINGLE_USEDEP},ffmpeg?,gstreamer?,imgproc,jpeg,openh264?,png,python]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP},cuda?,rocm?]
	ffmpeg? (
		media-video/ffmpeg[openh264]
	)
	gstreamer? (
		media-plugins/gst-plugins-meta[openh264?,vaapi?,x264?]
	)
"
#	net-misc/gdown[${PYTHON_USEDEP}]
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-644883f-path-changes.patch"
	"${FILESDIR}/${PN}-644883f-device-options.patch"
	"${FILESDIR}/${PN}-644883f-use-yellow.patch"
)

pkg_nofetch() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "You need to download the model manually."
einfo "Download URI:  ${DOWNLOAD_LOCATION}"
einfo "Copy renamed files to:  ${EDISTDIR}"
einfo
printf "%-20s %-40s %-10s %-10s %-10s\n" "filename" "rename to" "size" "blake2b" "sha512"
	local row
	for row in ${MODELS[@]} ; do
		local orig_name=$(echo "${row}" | cut -f 1 -d ";")
		local new_name=$(echo "${row}" | cut -f 2 -d ";")
		local size=$(echo "${row}" | cut -f 3 -d ";")
		local blake2b=$(echo "${row}" | cut -f 4 -d ";")
		local sha512=$(echo "${row}" | cut -f 5 -d ";")
printf "%-20s %-40s %-10s %-10s %-10s\n" "${orig_name}" "${new_name}" "${size}" "${blake2b:0:7}" "${sha512:0:7}"
	done
einfo "Alternatively, you may also download the model with \`gdown ${MODEL_GDOWN_ID}\` via net-misc/gdown"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		mkdir -p "${S}/model" || die
		cat \
			$(realpath "${DISTDIR}/dashcam_anonymizer-6dd713f-best.pt") \
			> \
			"${S}/model/best.pt" \
			|| die
	fi
}

src_configure() {
	local dir="/usr/lib/${EPYTHON}/site-packages/${PN}"
	local use_gpu
	if use cuda || use rocm ; then
		use_gpu="True"
	else
		use_gpu="False"
	fi
	local use_xla=$(usex xla "True" "False")
	local use_xpu=$(usex xpu "True" "False")
	sed -i \
		-e "s|@INSTALL_PATH@|${dir}|g" \
		-e "s|@USE_GPU@|${use_gpu}|g" \
		-e "s|@USE_XLA@|${use_xla}|g" \
		-e "s|@USE_XPU@|${use_xpu}|g" \
		"${S}/configs/img_blur.yaml" \
		"${S}/configs/vid_blur.yaml" \
		|| die
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"

	einstalldocs
	python_moduleinto "${PN}"
	python_domodule "blur_images.py" "blur_videos.py" "model"
	insinto "/usr/share/${PN}"
	doins -r "configs"
	dodir "/usr/bin"

cat <<EOF > "${ED}/usr/bin/blur_images"
#!/bin/bash
export IMAGE_CWD=\$(realpath "\$(pwd)")
cd "/usr/lib/${EPYTHON}/site-packages/${PN}"
${EPYTHON} blur_images.py "\$@"
EOF
	fperms 0755 "/usr/bin/blur_images"

cat <<EOF > "${ED}/usr/bin/blur_videos"
#!/bin/bash
export VIDEO_CWD=\$(realpath "\$(pwd)")
cd "/usr/lib/${EPYTHON}/site-packages/${PN}"
${EPYTHON} blur_videos.py "\$@"
EOF
	fperms 0755 "/usr/bin/blur_videos"
}

pkg_postinst() {
einfo
einfo "Usage:"
einfo
einfo "To blur images:"
einfo
einfo "cp -a /usr/share/dashcam_anonymizer/configs/img_blur.yaml to folder containing images"
einfo "Run \`blur_images --config \$(pwd)/img_blur.yaml\`"
einfo
einfo
einfo "To blur videos:"
einfo
einfo "cp -a /usr/share/dashcam_anonymizer/configs/vid_blur.yaml to folder containing videos"
einfo "Run \`blur_videos --config \$(pwd)/vid_blur.yaml\`"
einfo
ewarn "The ~/.cache/dashcam_anonymizer may need to be removed if processing was disrupted."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  FAILED (644883f, 20241220)
# Image license plate blur - passed
# Video license plate blur - failed
