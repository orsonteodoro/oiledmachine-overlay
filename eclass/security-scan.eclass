# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: security-scan.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for security scan
# @DESCRIPTION:
# Performs security scans.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: security-scan_avscan
# @DESCRIPTION:
# Scans arg for malware.
#
# Run every time a new file is added to ${WORKDIR} or ${ED} before running
# anything.
#
# arg - path to scan
security-scan_avscan() {
	local path="${1}"
	if [[ "${SECURITY_SCAN_AV}" == "1" ]] ; then
		if has_version "app-antivirus/clamav[clamapp]" ; then
einfo "Running avscan on ${path}"
			clamscan -r "${path}" || die
		fi
	fi
}

analytics_keywords=(
	# Translation provided by Wikipedia
	# Major languages scanned only

	# analytics
	"أناليتكس"		# arabic
	"分析"			# chinese
	"אנאליטיקס"		# hebrew/yiddish
	"एनालिटिक्स"		# hindi (indian)
	"アナリティクス"	# japanese
	"애널리틱스"		# korean
	"آنالیتیکس"		# persian
	"Аналитика"		# russian
	"แอนะลิติกส์"		# thai
	"Аналітика"		# ukrainian

	# telemetry
	"قياس عن بعد"		# arabic
	"遠測"			# chinese
	"télémesure"		# french
	"telemetrie"		# german
	"טלמטריה"		# hebrew
	"दूरमिति"		# hindi (indian)
	"telemetria"		# italian
	"遠隔測定法"		# japanese
	"원격 측정법"		# korean
	"دورسنجی"		# persian
	"Телеметри́я"		# russian
	"telemetría"		# spanish
	"โทรมาตร"		# thai
	"telemetri"		# turkish
	"Телеметрія"		# ukrainian
)

# @FUNCTION: _security-scan_get_analytics_keywords
# @DESCRIPTION:
# Prints a new line separated list with spaces.
_security-scan_get_analytics_keywords() {
	IFS=$'\n'
	local row
	for row in ${analytics_keywords[@]} ; do
		echo "${row}"
	done
	IFS=$' \t\n'
}

# @FUNCTION: security-scan_find_analytics
# @DESCRIPTION:
# Inspect and block apps that may spy on users without consent or no opt-out.
security-scan_find_analytics() {
	[[ "${SECURITY_SCAN_ANALYTICS}" =~ ("allow"|"accept") ]] && return
	local path

	IFS=$'\n'
	local L=(
		$(find "${WORKDIR}" \
			-name "package.json" \
			-o -name "package.json" \
			-o -name "package-lock.json" \
			-o -name "yarn.lock")
	)

	local analytics_packages=(
		"analytics"
		"telemetry"
		"glean"
	)

einfo "Scanning for analytics packages in package*.json or yarn.lock."
	for path in ${L[@]} ; do
		path=$(realpath "${path}")
		local ap
		for ap in ${analytics_packages[@]} ; do
			if grep -q -e "${ap}" "${path}" ; then
eerror
eerror "An analytics package has been detected in ${PN} that may track user"
eerror "behavior.  Often times, this kind of collection is unannounced in"
eerror "in READMEs, or cowardly buried hidden under several subfolders, and"
eerror "many times no way to opt out."
eerror
eerror "Keyword found:\t${ap}"
eerror "Details:"
	grep -n -e "${ap}" "${path}"
eerror
eerror "SECURITY_SCAN_ANALYTICS=\"allow\"  # to continue installing"
eerror "SECURITY_SCAN_ANALYTICS=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
				die
			fi
		done

	done
	IFS=$' \t\n'
}

# @FUNCTION: security-scan_find_session_replay
# @DESCRIPTION:
# Inspect and block apps that may spy on users without consent or no opt-out.
security-scan_find_session_replay() {
	[[ "${SECURITY_SCAN_SESSION_REPLAY}" =~ ("allow"|"accept") ]] && return
	local path

	IFS=$'\n'
	local L=(
		$(find "${WORKDIR}" \
			-name "package.json" \
			-o -name "package.json" \
			-o -name "package-lock.json" \
			-o -name "yarn.lock")
	)

	local session_replay_packages=(
		"ffmpeg" # may access system ffmpeg with x11grab
		"ffmpeg-screen-recorder" # tagged x11grab
		"puppeteer-stream" # tagged x11grab
		"record-screen" # tagged x11grab
		"rrweb"
		"recorder"
		"screencast"
		"woobi" # tagged x11grab

		# User can define this globally in /etc/make.conf.
		# It must be a space delimited string.
		${SECURITY_SCAN_SESSION_REPLAY_BLACKLIST}
	)

einfo "Scanning for session replay packages or recording packages in package*.json or yarn.lock."
	for path in ${L[@]} ; do
		path=$(realpath "${path}")
		local ap
		for ap in ${session_replay_packages[@]} ; do
			if grep -q -e "${ap}" "${path}" ; then
eerror
eerror "A possible session replay or recording package has been detected in"
eerror "${PN} that may record user behavior or sensitive data with greater"
eerror "specificity which can be abused or compromise anonymity."
eerror
eerror "Package/pattern:\t${ap}"
eerror "Details:"
	grep -n -e "${ap}" "${path}"
eerror
eerror "SECURITY_SCAN_SESSION_REPLAY=\"allow\"  # to continue installing"
eerror "SECURITY_SCAN_SESSION_REPLAY=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
				die
			fi
		done

	done
	IFS=$' \t\n'
}

# @FUNCTION: security-scan_find_session_replay_within_source_code
# @DESCRIPTION:
# Check abuse with exec/spawn
security-scan_find_session_replay_within_source_code() {
	[[ "${SECURITY_SCAN_SESSION_REPLAY}" =~ ("allow"|"accept") ]] && return
einfo "Scanning for possible unauthorized recording within code."
	magick_formats="aai|ai|apng|art|ashlar|avs|bayer|bayera|bgr|bgra|bgro|bmp|bmp2|bmp3|brf|cal|cals|cin|cip|clip|cmyk|cmyka|cur|data|dcx|dds|dpx|dxt1|dxt5|epdf|epi|eps|eps2|eps3|epsf|epsi|ept|ept2|ept3|farbfeld|fax|ff|fits|fl32|flv|fts|ftxt|g3|g4|gif|gif87|gray|graya|group4|hdr|histogram|hrz|htm|html|icb|ico|icon|info|inline|ipl|isobrl|isobrl6|jng|jpe|jpeg|jpg|jps|json|kernel|m2v|m4v|map|mask|mat|matte|miff|mkv|mng|mono|mov|mp4|mpc|mpeg|mpg|msl|msvg|mtv|mvg|null|otb|pal|palm|pam|pbm|pcd|pcds|pcl|pct|pcx|pdb|pdf|pdfa|pfm|pgm|pgx|phm|picon|pict|pjpeg|png|png00|png24|png32|png48|png64|png8|pnm|pocketmod|ppm|ps|ps2|ps3|psb|psd|ptif|qoi|ras|rgb|rgba|rgbo|rgf|rsvg|sgi|shtml|six|sixel|sparse-co|strimg|sun|svg|svgz|tga|thumbnail|tiff|tiff64|txt|ubrl|ubrl6|uil|uyvy|vda|vicar|vid|viff|vips|vst|wbmp|webm|wmv|wpg|xbm|xpm|xv|yaml|ycbcr|ycbcra|yuv"
	local pat="(magick.*import|import.*\.(${magick_formats})|kmsgrab|x11grab|xcbgrab|screen://|recordmydesktop)"
	IFS=$'\n'
	local path
	for path in $(find "${WORKDIR}" -type f) ; do
		path=$(realpath "${path}")
		if grep -E -r -e "${pat}" "${path}" ; then
eerror
eerror "Possible unauthorized screen recording has been detected in"
eerror "${PN} that may record user behavior or sensitive data with greater"
eerror "specificity which can be abused or compromise anonymity."
eerror
eerror "Pattern:\t${pat}"
eerror "Details:"
	grep -n -e "${pat}" "${path}"
eerror
eerror "SECURITY_SCAN_SESSION_REPLAY=\"allow\"  # to continue installing"
eerror "SECURITY_SCAN_SESSION_REPLAY=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
			die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: security-scan-app_find_analytics_within_source_code
# @DESCRIPTION:
# Check unauthorized analytics within source code
security-scan_find_analytics_within_source_code() {
	[[ "${SECURITY_SCAN_ANALYTICS}" =~ ("allow"|"accept") ]] && return
einfo "Scanning for possible analytics within code."
	local pat="analytics|$(_security-scan_get_analytics_keywords)"
	IFS=$'\n'
	local path
	for path in $(find "${WORKDIR}" -type f) ; do
		path=$(realpath "${path}")
		if grep -E -i -r -e "(${pat})" "${path}" ; then
eerror
eerror "Analytics use within the code has detected in ${PN} that may track user"
eerror "behavior.  Often times, this kind of collection is unannounced in"
eerror "in READMEs, or cowardly buried hidden under several subfolders, and"
eerror "many times no way to opt out."
eerror
eerror "Pattern:\t${pat}"
eerror "Details:"
	grep -n -e "${pat}" "${path}"
eerror
eerror "SECURITY_SCAN_ANALYTICS=\"allow\"  # to continue installing"
eerror "SECURITY_SCAN_ANALYTICS=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
			die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: security-scan_js_scan_all
# @DESCRIPTION:
# Run all scans for npm/yarn/electron based packages.
security-scan_js_scan_all() {
	security-scan_avscan "${WORKDIR}"
	security-scan_find_analytics
	security-scan_find_analytics_within_source_code
	security-scan_find_session_replay
	security-scan_find_session_replay_within_source_code
}
