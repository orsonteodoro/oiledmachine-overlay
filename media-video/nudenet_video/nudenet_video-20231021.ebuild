# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="056604f32abda9dc006f8dc65b752351cafe0585" # Oct 21, 2023
PYTHON_COMPAT=( "python3_"{10..12} )

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ssabug/nudenet_video.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/nudenet_video-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/ssabug/nudenet_video/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A Python script to detect and blur explicit nudity in videos using NudeNet and FFmpeg"
HOMEPAGE="
	https://github.com/ssabug/nudenet_video
"
# No copyright files or copyright notice but
# license implied by linking to notAI-tech/NudeNet (AGPL-3)
LICENSE="
	AGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cuda migraphx openvino rocm tensorrt
ebuild_revision_5
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/nudenet[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},contribdnn,ffmpeg,jpeg,python]
	')
	sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},cuda?,migraphx?,python,rocm?,tensorrt?]
	media-video/ffmpeg[encode,gpl,x264]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "HISTORY&DEBUG.md" "README.html" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-056604f-move-to-homedir.patch"
	"${FILESDIR}/${PN}-056604f-fix-arg-folder-path.patch"
	"${FILESDIR}/${PN}-056604f-change-forbidden-alerts.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local use_cuda=$(usex cuda "True" "False")
	local use_migraphx=$(usex migraphx "True" "False")
	local use_openvino=$(usex openvino "True" "False")
	local use_rocm=$(usex rocm "True" "False")
	local use_tensorrt=$(usex tensorrt "True" "False")
	sed -i \
		-e "s|@USE_CUDA@|${use_cuda}|g" \
		-e "s|@USE_MIGRAPHX@|${use_migraphx}|g" \
		-e "s|@USE_OPENVINO@|${use_openvino}|g" \
		-e "s|@USE_ROCM@|${use_rocm}|g" \
		-e "s|@USE_TENSORRT@|${use_tensorrt}|g" \
		"nudenet_mod.py" \
		|| die
}

src_install() {
	einstalldocs
	python_moduleinto "nudenet_video"
	python_domodule "nudenet_video.py" "nudenet_mod.py" "best.onnx"
	insinto "/usr/share/nudenet_video"
	doins -r "timecode_files"
	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/nudenet_video"
#!/bin/bash
cd "/usr/lib/${EPYTHON}/site-packages/nudenet_video"
${EPYTHON} nudenet_video.py "\$@"
EOF
	fperms 0755 "/usr/bin/nudenet_video"
}

pkg_postinst() {
ewarn
ewarn "It will not 100% sanitize the video, but you still need to manually crop"
ewarn "or blur the edge cases or uncaught cases."
ewarn
einfo
einfo "The NUDENET_VIDEO_FORBIDDEN_ALERTS environment variable can be set"
einfo "before running nudenet_video."
einfo
einfo
einfo "Usage"
einfo
einfo "nudenet_video \"the absolute path to a video folder\""
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  FAIL (056604f3, 20241219)
# A censored version saved:  pass
# Adult video test:  fail (nip slip, does not filter inappropriate behavior)
