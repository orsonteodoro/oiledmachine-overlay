# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We don't eager bump because of torchvision requirements is not up to date.

MY_PN="Open WebUI"

AT_TYPES_NODE_PV="20.11.30"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
NODE_VERSION="22" # From https://github.com/open-webui/open-webui/blob/v0.5.20/Dockerfile#L24
NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)
PYTHON_COMPAT=( "python3_"{11..12} )

inherit desktop distutils-r1 pypi npm xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/open-webui/open-webui.git"
	FALLBACK_COMMIT="506dc0149ca973e20768fa3d6f171afac289f606" # Jan 5, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/open-webui/open-webui/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A user-friendly AI interface with web search RAG, document RAG, AI image generation, Ollama, OpenAI API support"
HOMEPAGE="
	https://openwebui.com/
	https://github.com/open-webui/open-webui
	https://pypi.org/project/open-webui
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cuda ollama +openrc rag-ocr systemd
ebuild_revision_10
"
REQUIRED_USE="
	|| (
		openrc
		systemd
	)
"
# For missing dev-python/moto[s3] rdepends
MOTO_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/moto-5.0.26[${PYTHON_USEDEP},s3(+)]
		>=dev-python/py-partiql-parser-0.6.1[${PYTHON_USEDEP}]
	')
"
# For missing >=dev-python/passlib-1.7.4[bcrypt(+)] rdepends
PASSLIB_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/passlib-1.7.4[${PYTHON_USEDEP},bcrypt(+)]
		dev-python/bcrypt[${PYTHON_USEDEP}]
	')
"
# For missing dev-python/pyjwt[crypto] rdepends
PYJWT_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
	')
"
# For missing dev-python/uvicorn[standard] rdepends
UVICORN_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/uvloop-0.14.0[${PYTHON_USEDEP}]
		>=dev-python/watchfiles-0.13[${PYTHON_USEDEP}]
	')
"
TORCH_TRIPLES=(
	# torch:torchaudio:torchvison
	"2.0.1:2.0.1:0.15.2"
	"2.1.2:2.1.2:0.16.2"
	"2.2.2:2.2.2:0.17.2"
	"2.3.1:2.3.1:0.18.1"
	"2.4.1:2.4.1:0.19.1"
	"2.5.1:2.5.1:0.20.1"
)
gen_torch_rdepend() {
	local r
	for r in ${TORCH_TRIPLES[@]} ; do
		local torch_pv="${r%%:*}"
		local torchaudio_pv="${r%%:*}"
		torchaudio_pv="${torchaudio_pv##*:}"
		local torchvision_pv="${r##*:}"
		echo "
			(
				~sci-ml/pytorch-${torch_pv}[${PYTHON_SINGLE_USEDEP},cuda?]
				~sci-ml/torchaudio-${torchaudio_pv}[${PYTHON_SINGLE_USEDEP}]
				~sci-ml/torchvision-${torchvision_pv}[${PYTHON_SINGLE_USEDEP},cuda?]
			)
		"
	done
}
DOCKER_REPEND="
	|| (
		$(gen_torch_rdepend)
	)
	sci-ml/pytorch:=
	sci-ml/torchaudio:=
	sci-ml/torchvision:=
	rag-ocr? (
		media-video/ffmpeg
		x11-libs/libSM
		x11-libs/libXext
	)
"
# Relaxed pymilvus
RDEPEND+="
	${DOCKER_REPEND}
	${PASSLIB_RDEPEND}
	${PYJWT_RDEPEND}
	${MOTO_RDEPEND}
	${UVICORN_RDEPEND}
	$(python_gen_cond_dep '
		>=dev-python/aiohttp-3.11.11[${PYTHON_USEDEP}]
		>=dev-python/alembic-1.14.0[${PYTHON_USEDEP}]
		>=dev-python/apscheduler-3.10.4[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
		>=dev-python/Authlib-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/azure-ai-documentintelligence-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/azure-identity-1.20.0[${PYTHON_USEDEP}]
		>=dev-python/azure-storage-blob-12.24.1[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
		>=dev-python/boto3-1.35.53[${PYTHON_USEDEP}]
		>=dev-python/docker-7.1.0[${PYTHON_USEDEP}]
		>=dev-python/docx2txt-0.8[${PYTHON_USEDEP}]
		>=dev-python/duckduckgo-search-7.3.2[${PYTHON_USEDEP}]
		>=dev-python/einops-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/elasticsearch-8.17.1[${PYTHON_USEDEP}]
		>=dev-python/fake-useragent-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/fastapi-0.115.7[${PYTHON_USEDEP}]
		>=dev-python/firecrawl-py-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/fpdf2-2.8.2[${PYTHON_USEDEP}]
		>=dev-python/ftfy-6.2.3[${PYTHON_USEDEP}]
		>=dev-python/gcp-storage-emulator-2024.08.03[${PYTHON_USEDEP}]
		>=dev-python/google-cloud-storage-2.19.0[${PYTHON_USEDEP}]
		>=dev-python/google-generativeai-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/googleapis-common-protos-1.63.2[${PYTHON_USEDEP}]
		>=dev-python/ldap3-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/loguru-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/markdown-3.7[${PYTHON_USEDEP}]
		>=dev-python/nltk-3.9.1[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/opensearch-py-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-2.2.3[${PYTHON_USEDEP}]
		>=dev-python/peewee-3.17.9[${PYTHON_USEDEP}]
		>=dev-python/peewee-migrate-1.12.2[${PYTHON_USEDEP}]
		>=dev-python/pgvector-0.3.5[${PYTHON_USEDEP}]
		>=dev-python/playwright-bin-1.49.1[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.9.9:2[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.10.6[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2.10.1[${PYTHON_USEDEP},crypto(+)]
		>=dev-python/pymdown-extensions-10.14.2[${PYTHON_USEDEP}]
		>=dev-python/pymysql-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/pypandoc-1.13[${PYTHON_USEDEP}]
		>=dev-python/pypdf-4.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-docker-3.1.1[${PYTHON_USEDEP}]
		>=dev-python/python-jose-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/python-pptx-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-socketio-5.11.3[${PYTHON_USEDEP}]
		>=dev-python/pytube-15.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyxlsb-1.0.10[${PYTHON_USEDEP}]
		>=dev-python/qdrant-client-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/rank-bm25-0.2.2[${PYTHON_USEDEP}]
		>=dev-python/RestrictedPython-8.0[${PYTHON_USEDEP}]
		>=dev-python/soundfile-0.13.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.34.0[${PYTHON_USEDEP},standard(+)]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-2.0.38[${PYTHON_USEDEP}]
		>=dev-python/validators-0.34.0[${PYTHON_USEDEP}]
		>=dev-python/xlrd-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/youtube-transcript-api-0.6.3[${PYTHON_USEDEP}]
		dev-python/aiocache[${PYTHON_USEDEP}]
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/anthropic[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
		dev-python/extract-msg[${PYTHON_USEDEP}]
		dev-python/google-api-python-client[${PYTHON_USEDEP}]
		dev-python/google-auth-httplib2[${PYTHON_USEDEP}]
		dev-python/google-auth-oauthlib[${PYTHON_USEDEP}]
		dev-python/openai[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pydub[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		dev-python/tiktoken[${PYTHON_USEDEP}]
		sci-ml/sentencepiece[${PYTHON_USEDEP}]
	')
	>=dev-python/chromadb-0.6.2[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/colbert-ai-0.2.21[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/faster-whisper-1.1.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/langchain-0.3.19[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/langchain-community-0.3.18[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/langfuse-2.44.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/pymilvus-2.4.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/rapidocr-onnxruntime-1.3.24[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/sentence-transformers-3.3.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/unstructured-0.16.17[${PYTHON_SINGLE_USEDEP}]
	>=media-libs/opencv-4.11.0[${PYTHON_SINGLE_USEDEP},python]
	sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
	acct-group/${PN}
	acct-user/${PN}
	x11-misc/xdg-utils
"
# xdg-utils is not an upstream requirement but for the launcher wrapper.
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_VERSION}[npm]
"
DOCS=( "CHANGELOG.md" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-0.5.20-symbolize-string-literals.patch"
)

check_virtual_mem() {
	local total_mem=$(free -t \
		| grep "Total:" \
		| sed -r -e "s|[[:space:]]+| |g" \
		| cut -f 2 -d " ")
	local total_mem_gib=$(python -c "import math;print(round(${total_mem}/1024/1024))")
	if (( ${total_mem_gib} < 8 )) ; then
ewarn
ewarn "Please add more swap."
ewarn
ewarn "Current total memory:  ${total_mem_gib} GiB"
ewarn "Minimum total memory:  8 GiB"
ewarn "Tested total memory:  30 GiB"
ewarn
	fi
}

pkg_setup() {
	python-single-r1_pkg_setup
	npm_pkg_setup
	check_virtual_mem
}

npm_update_lock_install_post() {
	patch_lockfile() {
		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect attack)
		# VS = Vulnerable System (Direct attack)

		sed -i -e "s|\"brace-expansion\": \"^1.1.7\"|\"brace-expansion\": \"2.0.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"cookie\": \"^0.6.0\"|\"cookie\": \"0.7.0\"|g" "package-lock.json" || die

		sed -i -e "s|\"dompurify\": \"^3.1.6\"|\"dompurify\": \"3.2.4\"|g" "package-lock.json" || die
		sed -i -e "s|\"dompurify\": \"^3.2.4\"|\"dompurify\": \"3.2.4\"|g" "package-lock.json" || die
		sed -i -e "s|\"dompurify\": \"^3.0.5 <3.1.7\"|\"dompurify\": \"3.2.4\"|g" "package-lock.json" || die

		sed -i -e "s|\"esbuild\": \"^0.25.0\"|\"esbuild\": \"0.25.0\"|g" "package-lock.json" || die
		sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"0.25.0\"|g" "package-lock.json" || die

		sed -i -e "s|\"vite\": \"^5.0.0\"|\"vite\": \"5.4.19\"|g" "package-lock.json" || die
		sed -i -e "s|\"vite\": \"^5.4.14\"|\"vite\": \"5.4.19\"|g" "package-lock.json" || die
		sed -i -e "s#\"vite\": \"^3.0.0 || ^4.0.0 || ^5.0.0\"#\"vite\": \"5.4.19\"#g" "package-lock.json" || die
		sed -i -e "s#\"vite\": \"^5.0.3 || ^6.0.0\"#\"vite\": \"5.4.19\"#g" "package-lock.json" || die

		sed -i -e "s|\"form-data\": \"~4.0.0\"|\"form-data\": \"4.0.4\"|g" "package-lock.json" || die
		sed -i -e "s|\"tmp\": \"~0.2.3\"|\"tmp\": \"0.2.4\"|g" "package-lock.json" || die

		sed -i -e "s|\"jspdf\": \"^3.0.0\"|\"jspdf\": \"3.0.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"devalue\": \"^5.1.0\"|\"devalue\": \"5.3.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"vite-plugin-static-copy\": \"^2.2.0\"|\"vite-plugin-static-copy\": \"2.3.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"mermaid\": \"^10.9.3\"|\"mermaid\": \"10.9.4\"|g" "package-lock.json" || die
	}
	patch_lockfile

	local pkgs
	pkgs=(
		"brace-expansion@2.0.2"						# CVE-2025-5889; DoS; Low
		"cookie@0.7.0"							# CVE-2024-47764; VS(DT); Medium
		"esbuild@0.25.0"						# GHSA-67mh-4wv8-2f99; ID; Moderate
		"vite@5.4.19"							# CVE-2025-46565; VS(ID); Low
		"form-data@4.0.4"						# CVE-2025-7783; VS(DT, ID), SS(DT, ID); Critical
		"tmp@0.2.4"							# CVE-2025-54798; DT; Low
		"devalue@5.3.2"							# CVE-2025-57820; SS(DoS, DT, ID); High
	)
#	enpm install -D --prefer-offline "${pkgs[@]}"
	enpm install -D "${pkgs[@]}"

	pkgs=(
		"dompurify@3.2.4"
		"jspdf@3.0.2"							# CVE-2025-57810; ZC, VS(DoS); High
		"vite-plugin-static-copy@2.3.2"					# CVE-2025-57753; VS(ID); Moderate
		"mermaid@10.9.4"						# CVE-2025-54881; SS(DT, ID); Moderate
	)
#	enpm install -P --prefer-offline "${pkgs[@]}"
	enpm install -P "${pkgs[@]}"

	patch_lockfile
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
	# For maintenance
		#unpack ${A}
		#die

		npm_src_unpack
		if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
ewarn "QA:  modify package.json build with just vite build"
		fi
	fi
}

setup_build_env() {
	USE_CUDA=$(usex cuda "true" "false")
	USE_OLLAMA=$(usex ollama "true" "false")
	if use cuda ; then
		if has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
			local pv=$(best_version "=dev-util/nvidia-cuda-toolkit-11*" | sed -e "s|dev-util/nvidia-cuda-toolkit-||g")
			export USE_CUDA_VER="cu${pv//.}"
		elif has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
			local pv=$(best_version "=dev-util/nvidia-cuda-toolkit-12*" | sed -e "s|dev-util/nvidia-cuda-toolkit-||g")
			export USE_CUDA_VER="cu${pv//.}"
		else
eerror "CUDA other than 11 or 12 are not supported."
			die
		fi
	fi

	# Pass build args to the build
	export USE_OLLAMA_DOCKER=${USE_OLLAMA:-}
	export USE_CUDA_DOCKER=${USE_CUDA:-}
	export USE_CUDA_DOCKER_VER=${USE_CUDA_VER:-}
	export USE_EMBEDDING_MODEL_DOCKER=${USE_EMBEDDING_MODEL:-}
	export USE_RERANKING_MODEL_DOCKER=${USE_RERANKING_MODEL:-}
}

python_prepare_all() {
	distutils-r1_python_prepare_all
einfo "PWD: ${PWD}"
	local file_paths=(
		"backend/dev.sh"
		"backend/open_webui/__init__.py"
		"backend/open_webui/env.py"
		"backend/start.sh"
		"run.sh"
	)

	local cudnn_lib_path="/opt/cuda/targets/x86_64-linux/lib"
	#local backend_path="/opt/${PN}/backend"
	local backend_path="/usr/lib/${EPYTHON}/site-packages/open_webui/backend"
	local hostname=${OPEN_WEBUI_HOST:-"localhost"}
	local listen_host="0.0.0.0" # 127.0.0.1, router, or ISP provided address
	local open_webui_path="/usr/lib/${EPYTHON}/site-packages/open_webui"
	local port=${OPEN_WEBUI_PORT:-8080}
	local pytorch_lib_path="/usr/lib/${EPYTHON}/site-packages/torch/lib"
	local uvicorn_path="/usr/lib/python-exec/${EPYTHON}/uvicorn"

	local path
	for path in ${file_paths[@]} ; do
einfo "Editing ${PWD}/${path}"
		sed -i \
			-e "s|@CUDNN_LIB_PATH@|${cudnn_lib_path}|g" \
			-e "s|@OPEN_WEBUI_BACKEND_DIR@|${backend_path}|g" \
			-e "s|@OPEN_WEBUI_DIR@|${open_webui_path}|g" \
			-e "s|@OPEN_WEBUI_LISTEN_HOST@|${listen_host}|g" \
			-e "s|@OPEN_WEBUI_PORT@|${port}|g" \
			-e "s|@OPEN_WEBUI_HOST@|${hostname}|g" \
			-e "s|@PYTORCH_LIB_PATH@|${pytorch_lib_path}|g" \
			-e "s|@UVICORN_PATH@|${uvicorn_path}|g" \
			"${PWD}/${path}" \
			|| die
	done
}

src_prepare() {
	distutils-r1_src_prepare
}

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	npm_hydrate

	# Prevent:
	# FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS=" --max-old-space-size=4096"

	distutils-r1_src_compile
}

install_backend() {
	# Include hidden files/dirs with *
	shopt -s dotglob

	insinto "/usr/lib/${EPYTHON}/site-packages/open_webui"
	doins -r "backend"

	fperms 0755 "/usr/lib/${EPYTHON}/site-packages/open_webui/backend/dev.sh"
	fperms 0755 "/usr/lib/${EPYTHON}/site-packages/open_webui/backend/start.sh"

	# Exclude hidden files/dirs with *
	shopt -u dotglob
}

install_init_services() {
	sed \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		-e "s|@EPYTHON@|${EPYTHON}|g" \
		"${FILESDIR}/${PN}-start-server" \
		> \
		"${T}/${PN}-start-server" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${PN}-start-server"

	insinto "/etc/conf.d"
	sed \
		-e "s|@OPEN_WEBUI_HOST@|${open_webui_hostname}|g" \
		-e "s|@OPEN_WEBUI_PORT@|${open_webui_port}|g" \
		"${FILESDIR}/${PN}.conf" \
		> \
		"${T}/${PN}.conf" \
		|| die
	doins "${T}/${PN}.conf"

	if use openrc ; then
		exeinto "/etc/init.d"
		newexe "${FILESDIR}/${PN}.openrc" "${PN}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		newins "${FILESDIR}/${PN}.systemd" "${PN}.service"
	fi
}

install_launcher_wrapper() {
	sed \
		-e "s|@OPEN_WEBUI_URI@|${open_webui_uri}|g" \
		"${FILESDIR}/${PN}" \
		> \
		"${T}/${PN}" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${PN}"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"

	local open_webui_hostname=${OPEN_WEBUI_HOSTNAME:-"127.0.0.1"}
	local open_webui_port=${OPEN_WEBUI_PORT:-8080}

einfo "OPEN_WEBUI_HOSTNAME:  ${open_webui_hostname} (user-definable, per-package environment variable)"
einfo "OPEN_WEBUI_PORT:  ${open_webui_port} (user-definable, per-package environment variable)"

	local open_webui_uri=${OPEN_WEBUI_URI:-"http://${open_webui_hostname}:${open_webui_port}"}
einfo "OPEN_WEBUI_URI:  ${open_webui_uri}"

	install_launcher_wrapper
	install_backend
	install_init_services

	keepdir "/var/lib/open-webui/data/cache/whisper/models"
	keepdir "/var/lib/open-webui/data/cache/embedding/models"
	keepdir "/var/lib/open-webui/data/cache/tiktoken"
	keepdir "/var/lib/open-webui/data/cache/torch_extensions"
	fowners "${PN}:${PN}" "/var/lib/open-webui/data/cache/whisper/models"
	fowners "${PN}:${PN}" "/var/lib/open-webui/data/cache/embedding/models"
	fowners "${PN}:${PN}" "/var/lib/open-webui/data/cache/tiktoken"
	fowners "${PN}:${PN}" "/var/lib/open-webui/data/cache/torch_extensions"

	# Junk that should not be there.
	rm -rf "${ED}/usr/lib/python"*"/site-packages/data/"

	# Done to remove error but not necessary
	fowners -R "root:root" "/usr/lib/${EPYTHON}/site-packages/open_webui/static"

	# Necessary
	fowners -R "root:root" "/usr/lib/${EPYTHON}/site-packages/open_webui/backend/data"

	newicon \
		"static/favicon.png" \
		"${PN}.png"

	make_desktop_entry \
		"${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Education;ArtificialIntelligence"
}

pkg_postinst() {
	xdg_pkg_postinst
ewarn
ewarn "The Web Search for RAG is not default on."
ewarn
ewarn "To set Web Search for RAG go to:  Settings > Admin Settings > Web Search"
ewarn
ewarn "More details can be found at"
ewarn
ewarn "  https://docs.openwebui.com/category/-web-search"
ewarn "  https://docs.openwebui.com/features/rag/#web-search-for-rag"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (0.5.20, 20250419)
# UI - passed
# Ollama - passed
# Web RAG - testing
