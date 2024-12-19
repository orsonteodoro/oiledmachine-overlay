# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
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

DESCRIPTION="A Python use of nudenet API to render blurred video files using FFMPEG"
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
IUSE+=" cuda"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/nudenet[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},ffmpeg,jpeg,python]
	')
	sci-libs/onnxruntime[${PYTHON_SINGLE_USEDEP},cuda?,python]
	media-video/ffmpeg[encode,x264]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "HISTORY&DEBUG.md" "README.html" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-056604f-frombuffer-arg.patch"
	"${FILESDIR}/${PN}-056604f-move-to-homedir.patch"
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
	sed -i \
		-e "s|@USE_CUDA@|${use_cuda}|g" \
		"nudenet_mod.py" \
		|| die
}

src_install() {
	python_moduleinto "nudenet_video"
	python_domodule "nudenet_video.py" "nudenet_mod.py" "best.onnx"
	insinto "/usr/share/nudenet_video"
	doins -r "timecode_files"
	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/nudenet_video"
#!/bin/bash
cd "/usr/lib/${EPYTHON}/site-packages/nudenet_video"
${EPYTHON} nudenet_video.py "$@"
EOF
	fperms 0744 "/usr/bin/nudenet_video"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
