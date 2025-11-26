# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO package
# k-diffusion

MY_PN="voltaML-fast-stable-diffusion"

NODE_SLOT="18"
PYTHON_COMPAT=( "python3_"{10..12} )

TORCH_VERSIONS=(
	# pytorch = torchaudio; torchvideo
	"2.1.2;0.16.2"
	"2.2.2;0.17.2"
	"2.3.1;0.18.1"
	"2.4.1;0.19.1"
	"2.5.1;0.20.1"
)

inherit lcnr python-single-r1 pypi yarn

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/voltaML/voltaML-fast-stable-diffusion.git"
	FALLBACK_COMMIT="1aea33bb7a37d251044cc4f04fc095be4d936be4" # Dec 31, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Missing dependencies and ebuild still in development
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/voltaML/voltaML-fast-stable-diffusion/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A beautiful and easy to use Stable Diffusion web user interface"
HOMEPAGE="
	https://voltaml.github.io/voltaML-fast-stable-diffusion/
	https://github.com/voltaML/voltaML-fast-stable-diffusion
"
LICENSE="
	GPL-3
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
aitemplate cuda doc onnx pytorch rocm xformers
"
REQUIRED_USE="
	|| (
		aitemplate
		pytorch
		onnx
	)
	aitemplate? (
		|| (
			cuda
			rocm
		)
	)
"
API_DEPENDS="
	$(python_gen_cond_dep '
		>=dev-python/fastapi-0.95.0[${PYTHON_USEDEP}]
		>=dev-python/fastapi-analytics-1.1.5[${PYTHON_USEDEP}]
		>=dev-python/fastapi-simple-cachecontrol-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/nest-asyncio-1.5.8[${PYTHON_USEDEP}]
		>=dev-python/pyngrok-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.6[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.6.0[${PYTHON_USEDEP}]
		>=dev-python/streaming-form-data-1.13.0[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.24.0_p1[${PYTHON_USEDEP}]
		>=dev-python/websockets-12.0[${PYTHON_USEDEP}]
	')
"
BOT_DEPENDS="
	$(python_gen_cond_dep '
		>=dev-python/discord-py-2.3.0[${PYTHON_USEDEP}]
	')
"
PYTORCH_DEPENDS="
	$(python_gen_cond_dep '
		>=dev-python/boto3-1.28.83[${PYTHON_USEDEP}]
		>=dev-python/coloredlogs-15.0.1[${PYTHON_USEDEP}]
		>=dev-python/cpufeature-0.2.1[${PYTHON_USEDEP}]
		>=dev-python/dataclasses-json-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/hypertile-0.1.5_p9999[${PYTHON_USEDEP}]
		>=dev-python/ftfy-6.1.1[${PYTHON_USEDEP}]
		>=dev-python/gpustat-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/omegaconf-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/piexif-1.1.3[${PYTHON_USEDEP}]
		>=dev-python/pyamdgpuinfo-2.1.6[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10.1[${PYTHON_USEDEP}]
		>=sci-ml/safetensors-0.4.0[${PYTHON_USEDEP}]
	')
	>=dev-python/asdff-0.2.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/controlnet-aux-0.0.7[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/k-diffusion-0.1.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/timm-0.9.10[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/diffusers-0.24.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/invisible-watermark-0.2.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/pytorch-lightning-2.1.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/realesrgan-0.3.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/tomesd-0.1.3[${PYTHON_SINGLE_USEDEP}]
	>=media-libs/opencv-4.7.0.72[${PYTHON_SINGLE_USEDEP},imgproc,png,python]
	>=sci-ml/accelerate-0.24.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/huggingface_hub-0.19.4[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/tokenizers-0.15.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/transformers-4.36.1[${PYTHON_SINGLE_USEDEP}]
"
INTERROGATION_DEPENDS="
	>=dev-python/flamingo-mini-0.0.2_p9999[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/open-clip-torch-2.23.0[${PYTHON_SINGLE_USEDEP}]
"
gen_pytorch_rdepend() {
	local row
	for row in ${TORCH_VERSIONS[@]} ; do
		local torch_pv="${row%;*}"
		local torchvision_pv="${row#*;}"
		echo "
			(
				~sci-ml/pytorch-${torch_pv}[${PYTHON_SINGLE_USEDEP},cuda?,rocm?]
				~sci-ml/torchaudio-${torch_pv}[${PYTHON_SINGLE_USEDEP}]
				~sci-ml/torchvision-${torchvision_pv}[${PYTHON_SINGLE_USEDEP}]
			)
		"
	done
}
# The CUDA and ROCm requirements are limited by PyTorch and AITemplate.
# The Docker images for PyTorch and AITemplate have overlap
# There is no conditional around `import torch`
RDEPEND+="
	${API_DEPENDS}
	${BOT_DEPENDS}
	${PYTORCH_DEPENDS}
	${INTERROGATION_DEPENDS}
	acct-group/voltaml-fast-stable-diffusion
	acct-user/voltaml-fast-stable-diffusion
	x11-misc/xdg-utils
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	|| (
		$(gen_pytorch_rdepend)
	)
	sci-ml/pytorch:=
	sci-ml/torchaudio:=
	sci-ml/torchvision:=
	aitemplate? (
		$(python_gen_cond_dep '
			dev-python/AITemplate[${PYTHON_USEDEP},cuda?,rocm?]
		')
	)
	onnx? (
		$(python_gen_cond_dep '
			sci-ml/onnx[${PYTHON_USEDEP}]
		')
		sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},cuda?,python,rocm?]
	)
	xformers? (
		dev-python/xformers[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/poetry-core[${PYTHON_USEDEP}]
	')
	net-libs/nodejs:${NODE_SLOT}
	net-libs/nodejs:=
	sys-apps/yarn:1
	sys-apps/yarn:=
"
DOCS=( "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
	yarn_pkg_setup
	yarn_check
}

src_unpack() {
	export FORCE_COLOR=0
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		yarn_src_unpack
		pushd "frontend" >/dev/null 2>&1 || die
			eyarn install
		popd >/dev/null 2>&1 || die
	fi
}

src_compile() {
	yarn_hydrate
	#doc && eyarn run "docs:build" # Unreasonably slow or stuck
	eyarn run "frontend:build"
	eyarn run "manager:build"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "License"

	exeinto "/usr/bin"
	doexe "manager/target/release/voltaml-manager"

	ewarn "You need to install a web browser for the frontend"

einfo "The client start script is called voltaml-fsd"
	# Client
cat <<EOF > "${ED}/usr/bin/voltaml-fsd"
#!/bin/bash
xdg-open "localhost:5003"
EOF
	fperms 0755 "/usr/bin/voltaml-fsd"

einfo "The server start script is called voltaml-fsd-server"
	# Server
cat <<EOF > "${ED}/usr/bin/voltaml-fsd-server"
#!/bin/bash
cd "/opt/${PN}"
"./scripts/start.sh"
EOF
	fperms 0755 "/usr/bin/voltaml-fsd-server"

	local dirs=(
		"aitemplate"
		"onnx"
		"models"
		"outputs"
		"lora"
		"vae"
		"upscaler"
		"textual-inversion"
		"lycoris"
		"logs"
		"themes"
		"autofill"
	)

	local d
	for d in "${dirs[@]}" ; do
		keepdir "/opt/${PN}/data/${d}"
		fowners "root:voltaml-fast-stable-diffusion" "/opt/${PN}/data/${d}"
		fperms 0775 "/opt/${PN}/data/${d}"
	done

	lcnr_install_files

	rm -rf "frontend/node_modules" || die
	rm -rf "scripts/start-windows.bat"
	rm -rf "scripts/test-docker-gpu-availability.sh"
	rm -rf "scripts/wsl-install.sh"

	local paths=(
		"api"
		"bot"
		"core"
		"data"
		"frontend"
		"requirements"
		"scripts"
		"README.md"
		"example.env"
		"bot.py"
		"main.py"
		"start.sh"
	)
	insinto "/opt/${PN}"
	for p in "${paths[@]}" ; do
		doins "${p}"
	done

	if use doc ; then
		insinto "/usr/${PN}/doc"
		doins -r "docs" "static"
		doins "README.md"
	fi

	IFS=$'\n'
	for x in $(find "${ED}") ; do
		[[ -L "${x}" ]] && continue
		if file "${x}" | grep -q -e "Python script" ; then
			chmod 0755 "${x}" || die
		elif file "${x}" | grep -q -e "Bourne-Again shell script" ; then
			chmod 0755 "${x}" || die
		fi
	done
	IFS=$' \t\n'

}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
