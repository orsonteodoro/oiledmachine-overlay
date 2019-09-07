# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet.eclass
# @MAINTAINER: cynede@gentoo.org
# @BLURB: common settings and functions for mono and dotnet related packages
# @DESCRIPTION:
# The dotnet eclass contains common environment settings that are useful for
# dotnet packages.  Currently, it provides no functions, just exports
# MONO_SHARED_DIR and sets LC_ALL in order to prevent errors during compilation
# of dotnet packages.

case ${EAPI:-0} in
	0) die "this eclass doesn't support EAPI 0" ;;
	1|2|3) ;;
	*) ;; #if [[ ${USE_DOTNET} ]]; then REQUIRED_USE="|| (${USE_DOTNET})"; fi;;
esac

inherit eutils multibuild mono-env versionator

# @ECLASS-VARIABLE: USE_DOTNET
# @DESCRIPTION:
# Use flags added to IUSE

IUSE+=" debug developer"

_DOTNET_ECLASS_MODE="" # can be netfx or netcore or netstandard (private variable not to be used outside of eclass)

_SET_DEPENDS_NETCORE=""

_NETCORE_TOOLS_DEPS="|| ( dev-dotnet/cli-tools dev-dotnet/dotnetcore-sdk-bin )"

# SET default use flags according on DOTNET_TARGETS
for x in ${USE_DOTNET}; do
	case ${x} in
		netstandard20) if [[ ${DOTNET_TARGETS} == *netstandard20* ]]; then IUSE+=" +netstandard20"; else IUSE+=" netstandard20"; _CDEPEND=" netstandard20? ( >=dev-lang/mono-5.2 )" ; DEPEND+=" ${_CDEPEND} netstandard20? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard16) if [[ ${DOTNET_TARGETS} == *netstandard16* ]]; then IUSE+=" +netstandard16"; else IUSE+=" netstandard16"; _CDEPEND=" netstandard16? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard16? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard15) if [[ ${DOTNET_TARGETS} == *netstandard15* ]]; then IUSE+=" +netstandard15"; else IUSE+=" netstandard15"; _CDEPEND=" netstandard15? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard15? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard14) if [[ ${DOTNET_TARGETS} == *netstandard14* ]]; then IUSE+=" +netstandard14"; else IUSE+=" netstandard14"; _CDEPEND=" netstandard14? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard14? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard13) if [[ ${DOTNET_TARGETS} == *netstandard13* ]]; then IUSE+=" +netstandard13"; else IUSE+=" netstandard13"; _CDEPEND=" netstandard13? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard13? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard12) if [[ ${DOTNET_TARGETS} == *netstandard12* ]]; then IUSE+=" +netstandard12"; else IUSE+=" netstandard12"; _CDEPEND=" netstandard12? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard12? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard11) if [[ ${DOTNET_TARGETS} == *netstandard11* ]]; then IUSE+=" +netstandard11"; else IUSE+=" netstandard11"; _CDEPEND=" netstandard11? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard11? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netstandard10) if [[ ${DOTNET_TARGETS} == *netstandard10* ]]; then IUSE+=" +netstandard10"; else IUSE+=" netstandard10"; _CDEPEND=" netstandard10? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard10? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netcoreapp22) if [[ ${DOTNET_TARGETS} == *netcoreapp22* ]]; then IUSE+=" +netcoreapp22"; else IUSE+=" netcoreapp22"; _CDEPEND=" netcoreapp22? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp22? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netcoreapp21) if [[ ${DOTNET_TARGETS} == *netcoreapp21* ]]; then IUSE+=" +netcoreapp21"; else IUSE+=" netcoreapp21"; _CDEPEND=" netcoreapp21? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp21? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netcoreapp20) if [[ ${DOTNET_TARGETS} == *netcoreapp20* ]]; then IUSE+=" +netcoreapp20"; else IUSE+=" netcoreapp20"; _CDEPEND=" netcoreapp20? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp20? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netcoreapp11) if [[ ${DOTNET_TARGETS} == *netcoreapp11* ]]; then IUSE+=" +netcoreapp11"; else IUSE+=" netcoreapp11"; _CDEPEND=" netcoreapp11? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp11? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		netcoreapp10) if [[ ${DOTNET_TARGETS} == *netcoreapp10* ]]; then IUSE+=" +netcoreapp10"; else IUSE+=" netcoreapp10"; _CDEPEND=" netcoreapp10? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp10? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}"; fi;;
		net472) if [[ ${DOTNET_TARGETS} == *net472* ]]; then IUSE+=" +net472"; else IUSE+=" net472"; _CDEPEND=" net472? ( >=dev-lang/mono-5.18 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net471) if [[ ${DOTNET_TARGETS} == *net471* ]]; then IUSE+=" +net471"; else IUSE+=" net471"; _CDEPEND=" net471? ( >=dev-lang/mono-5.10 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net47) if [[ ${DOTNET_TARGETS} == *net47* ]]; then IUSE+=" +net47"; else IUSE+=" net47"; _CDEPEND=" net47? ( >=dev-lang/mono-5.2 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net462) if [[ ${DOTNET_TARGETS} == *net462* ]]; then IUSE+=" +net462"; else IUSE+=" net462"; _CDEPEND=" net462? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net461) if [[ ${DOTNET_TARGETS} == *net461* ]]; then IUSE+=" +net461"; else IUSE+=" net461"; _CDEPEND=" net461? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net46) if [[ ${DOTNET_TARGETS} == *net46* ]]; then IUSE+=" +net46"; else IUSE+=" net46"; _CDEPEND=" net46? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net452) if [[ ${DOTNET_TARGETS} == *net452* ]]; then IUSE+=" +net452"; else IUSE+=" net452"; _CDEPEND=" net452? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net451) if [[ ${DOTNET_TARGETS} == *net451* ]]; then IUSE+=" +net451"; else IUSE+=" net451"; _CDEPEND=" net451? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net45) if [[ ${DOTNET_TARGETS} == *net45* ]]; then IUSE+=" +net45"; else IUSE+=" net45"; _CDEPEND=" net45? ( >=dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; fi;;
		net40) if [[ ${DOTNET_TARGETS} == *net40* ]]; then IUSE+=" +net40"; else IUSE+=" net40"; _CDEPEND=" net40? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; die "no longer supported"; fi;; # dropped in mono 4.0
		net35) if [[ ${DOTNET_TARGETS} == *net35* ]]; then IUSE+=" +net35"; else IUSE+=" net35"; _CDEPEND=" net35? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; die "no longer supported"; fi;; # dropped in mono 4.0
		net20) if [[ ${DOTNET_TARGETS} == *net20* ]]; then IUSE+=" +net20"; else IUSE+=" net20"; _CDEPEND=" net20? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}"; die "no longer supported"; fi;; # dropped in mono 4.0
	esac
done

_dotnet_sandbox_disabled_check() {
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die "${PN} require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

_dotnet_sandbox_network_disabled_check() {
	if has network-sandbox $FEATURES ; then
		die "${PN} require network-sandbox to be disabled in FEATURES."
	fi
}

# @FUNCTION: dotnet_pkg_pretend
# @DESCRIPTION:  This function will inspect sandbox readiness for dotnet build (which implies dotnet restore) or nuget restore
dotnet_pkg_pretend() {
	for x in ${USE_DOTNET} ; do
		case ${x} in
			netcorestandard20) if use netstandard20; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard16) if use netstandard16; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard15) if use netstandard15; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard14) if use netstandard14; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard13) if use netstandard13; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard12) if use netstandard12; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard11) if use netstandard11; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcorestandard10) if use netstandard10; then _DOTNET_ECLASS_MODE="netstandard"; fi;;
			netcoreapp22) if use netcoreapp22; then _DOTNET_ECLASS_MODE="netcore"; fi;;
			netcoreapp21) if use netcoreapp21; then _DOTNET_ECLASS_MODE="netcore"; fi;;
			netcoreapp20) if use netcoreapp20; then _DOTNET_ECLASS_MODE="netcore"; fi;;
			netcoreapp11) if use netcoreapp11; then _DOTNET_ECLASS_MODE="netcore"; fi;;
			netcoreapp10) if use netcoreapp10; then _DOTNET_ECLASS_MODE="netcore"; fi;;
			*) _DOTNET_ECLASS_MODE="netfx" ;;
		esac

		if [[ "${_DOTNET_ECLASS_MODE}" == "netstandard" || "${_DOTNET_ECLASS_MODE}" == "netcore" ]] ; then
			_dotnet_sandbox_disabled_check
		fi

		# applies to netfx or those that use nuget as well; almost always for netcore and netstandard packages
		if [[ -n "${USE_DOTNET_RESTORE}" || "${_DOTNET_ECLASS_MODE}" == "netstandard" || "${_DOTNET_ECLASS_MODE}" == "netcore" ]] ; then
			_dotnet_sandbox_network_disabled_check
		fi
	done
}

# @FUNCTION: dotnet_pkg_setup
# @DESCRIPTION:  This function set FRAMEWORK
dotnet_pkg_setup() {
	EBUILD_FRAMEWORK=""
	mono-env_pkg_setup
	for x in ${USE_DOTNET} ; do
		case ${x} in
			netcorestandard20) EBF="2.0"; if use netstandard20; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard16) EBF="1.6"; if use netstandard16; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard15) EBF="1.5"; if use netstandard15; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard14) EBF="1.4"; if use netstandard14; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard13) EBF="1.3"; if use netstandard13; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard12) EBF="1.2"; if use netstandard12; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard11) EBF="1.1"; if use netstandard11; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcorestandard10) EBF="1.0"; if use netstandard10; then F="${EBF}"; _DOTNET_ECLASS_MODE="netstandard";fi;;
			netcoreapp22) EBF="2.2"; if use netcoreapp22; then F="${EBF}"; _DOTNET_ECLASS_MODE="netcore";fi;;
			netcoreapp21) EBF="2.1"; if use netcoreapp21; then F="${EBF}"; _DOTNET_ECLASS_MODE="netcore";fi;;
			netcoreapp20) EBF="2.0"; if use netcoreapp20; then F="${EBF}"; _DOTNET_ECLASS_MODE="netcore";fi;;
			netcoreapp11) EBF="1.1"; if use netcoreapp11; then F="${EBF}"; _DOTNET_ECLASS_MODE="netcore";fi;;
			netcoreapp10) EBF="1.0"; if use netcoreapp10; then F="${EBF}"; _DOTNET_ECLASS_MODE="netcore";fi;;
			net472) EBF="4.8"; if use net48; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net472) EBF="4.8"; if use net48; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net472) EBF="4.72"; if use net472; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net471) EBF="4.71"; if use net471; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net47) EBF="4.7"; if use net47; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net462) EBF="4.62"; if use net462; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net461) EBF="4.61"; if use net461; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net46) EBF="4.6"; if use net46; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net45) EBF="4.5"; if use net45; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net40) EBF="4.0"; if use net40; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net35) EBF="3.5"; if use net35; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
			net20) EBF="2.0"; if use net20; then F="${EBF}"; _DOTNET_ECLASS_MODE="netfx";fi;;
		esac
		if [[ -z ${FRAMEWORK} ]]; then
			if [[ -n ${F} ]]; then
				FRAMEWORK="${F}";
			fi
		else
			version_is_at_least "${F}" "${FRAMEWORK}" || FRAMEWORK="${FRAMEWORK:=${F}}"
		fi
		if [[ -z ${EBUILD_FRAMEWORK} ]]; then
			if [[ ${EBF} ]]; then
				EBUILD_FRAMEWORK="${EBF}";
			fi
		else
			version_is_at_least "${EBF}" "${EBUILD_FRAMEWORK}" || EBUILD_FRAMEWORK="${EBF}"
		fi
	done
	if [[ -z ${FRAMEWORK} ]]; then
		if [[ -z ${EBUILD_FRAMEWORK} ]]; then
			FRAMEWORK="${FRAMEWORK:=4.5}"
			elog "Ebuild doesn't contain USE_DOTNET="
		else
			FRAMEWORK="${EBUILD_FRAMEWORK}"
			elog "User did not set any netNN use-flags in make.conf or profile, .ebuild demands USE_DOTNET=""${USE_DOTNET}"""
		fi
	fi
	einfo " -- USING .NET ${FRAMEWORK} FRAMEWORK -- "
}

# >=mono-0.92 versions using mcs -pkg:foo-sharp require shared memory, so we set the
# shared dir to ${T} so that ${T}/.wapi can be used during the install process.
export MONO_SHARED_DIR="${T}"

# Building mono, nant and many other dotnet packages is known to fail if LC_ALL
# variable is not set to C. To prevent this all mono related packages will be
# build with LC_ALL=C (see bugs #146424, #149817)
export LC_ALL=C

# Monodevelop-using applications need this to be set or they will try to create config
# files in the user's ~ dir.

export XDG_CONFIG_HOME="${T}"

# Fix bug 83020:
# "Access Violations Arise When Emerging Mono-Related Packages with MONO_AOT_CACHE"

unset MONO_AOT_CACHE

# @FUNCTION: output_relpath
# @DESCRIPTION:  returns default relative directory for Debug or Release configuration depending from USE="debug"
function output_relpath ( ) {
	local DIR=""
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi
	echo "bin/${DIR}"
}

# @FUNCTION: exbuild_netfx_raw
# @DESCRIPTION: run xbuild with given parameters
_exbuild_netfx_raw() {
	elog """$@"""
	xbuild "$@" || die
}


# @FUNCTION: _exbuild_netstandard_raw
# @DESCRIPTION: alias for _exbuild_netcore_raw
_exbuild_netstandard_raw() {
	_exbuild_netcore_raw $@
}

# @FUNCTION: _exbuild_netcore_raw
# @DESCRIPTION: run dotnet with given parameters
_exbuild_netcore_raw() {
	elog """$@"""
	dotnet "$@" || die
}

# @FUNCTION: exbuild_raw
# @DESCRIPTION: run xbuild or dotnet with given parameters
exbuild_raw() {
	if [[ "${_DOTNET_ECLASS_MODE}" == "netfx" ]] ; then
		_exbuild_netfx_raw $@
	elif [[ "${_DOTNET_ECLASS_MODE}" == "netcore" || "${_DOTNET_ECLASS_MODE}" == "netstandard" ]] ; then
		_exbuild_netcore_raw $@
	fi
}

# @FUNCTION: _exbuild_netfx
# @DESCRIPTION: run xbuild with Release configuration and configurated FRAMEWORK, for .NET Framework.
_exbuild_netfx() {
	if use debug; then
		CARGS=/p:Configuration=Debug
	else
		CARGS=/p:Configuration=Release
	fi

	if use developer; then
		SARGS=/p:DebugSymbols=True
	else
		SARGS=/p:DebugSymbols=False
	fi

	if [[ -z ${TOOLS_VERSION} ]]; then
		TOOLS_VERSION=4.0
	fi

	_exbuild_netcore_raw "/v:detailed" "/tv:${TOOLS_VERSION}" "/p:TargetFrameworkVersion=v${FRAMEWORK}" "${CARGS}" "${SARGS}" "$@"
}

# @FUNCTION: _exbuild_netstandard
# @DESCRIPTION: alias for _exbuild_netcore
_exbuild_netstandard() {
	_exbuild_netcore $@
}

# @FUNCTION: _exbuild_netcore
# @DESCRIPTION: run dotnet msbuild with Release configuration and configurated FRAMEWORK, for .NET Core and .NET Standard
_exbuild_netcore() {
	if use debug; then
		CARGS=-p:Configuration=Debug
	else
		CARGS=-p:Configuration=Release
	fi

	if use developer; then
		SARGS=-p:DebugSymbols=True
	else
		SARGS=-p:DebugSymbols=False
	fi

	if [[ -z ${TOOLS_VERSION} ]]; then
		TOOLS_VERSION=15.0
	fi

	_exbuild_netcore_raw msbuild "-verbosity=detailed" "-toolsVersion:${TOOLS_VERSION}" "-f ${_DOTNET_ECLASS_MODE}${FRAMEWORK}" "${CARGS}" "${SARGS}" "$@"
}

# @FUNCTION: exbuild
# @DESCRIPTION: frontend for xbuild and dotnet
exbuild() {
	if [[ "${_DOTNET_ECLASS_MODE}" == "netfx" ]] ; then
		_exbuild_netfx $@
	elif [[ "${_DOTNET_ECLASS_MODE}" == "netcore" || "${_DOTNET_ECLASS_MODE}" == "netstandard" ]] ; then
		_exbuild_netcore $@
	fi
}

# @FUNCTION: dotnet_multilib_comply
# @DESCRIPTION:  multilib comply
dotnet_multilib_comply() {
	use !prefix && has "${EAPI:-0}" 0 1 2 && ED="${D}"
	local dir finddirs=() mv_command=${mv_command:-mv}
	if [[ -d "${ED}/usr/lib" && "$(get_libdir)" != "lib" ]]
	then
		if ! [[ -d "${ED}"/usr/"$(get_libdir)" ]]
		then
			mkdir "${ED}"/usr/"$(get_libdir)" || die "Couldn't mkdir ${ED}/usr/$(get_libdir)"
		fi
		${mv_command} "${ED}"/usr/lib/* "${ED}"/usr/"$(get_libdir)"/ || die "Moving files into correct libdir failed"
		rm -rf "${ED}"/usr/lib
		for dir in "${ED}"/usr/"$(get_libdir)"/pkgconfig "${ED}"/usr/share/pkgconfig
		do

			if [[ -d "${dir}" && "$(find "${dir}" -name '*.pc')" != "" ]]
			then
				pushd "${dir}" &> /dev/null
				sed  -i -r -e 's:/(lib)([^a-zA-Z0-9]|$):/'"$(get_libdir)"'\2:g' \
					*.pc \
					|| die "Sedding some sense into pkgconfig files failed."
				popd "${dir}" &> /dev/null
			fi
		done
		if [[ -d "${ED}/usr/bin" ]]
		then
			for exe in "${ED}/usr/bin"/*
			do
				if [[ "$(file "${exe}")" == *"shell script text"* ]]
				then
					sed -r -i -e ":/lib(/|$): s:/lib(/|$):/$(get_libdir)\1:" \
						"${exe}" || die "Sedding some sense into ${exe} failed"
				fi
			done
		fi

	fi
}

# @FUNCTION: estrong_assembly_info
# @DESCRIPTION:  This will inject the key in AssemblyInfo.cs
# @CODE
# Parameters:
# $1 - injection line usually "using System.Runtime.InteropServices;"
# $2 - path to the private key
# $3 - the path to the AssemblyInfo.cs file to inject the key into
# @CODE
function estrong_assembly_info() {
	sed -i -r -e "s|$1|$1\n[assembly:AssemblyKeyFileAttribute(\"$2\")]|" "$3" || die
}

# @FUNCTION: estrong_resign
# @DESCRIPTION:  This will re-sign the dll with the key
# @CODE
# Parameters:
# $1 - the path to the dll
# $2 - the private key
# @CODE
function estrong_resign() {
	sn -R "$1" "$2" || die
}

_IMPLS="net{20,35,40,45,46,461,462,47,471,472,48} netcore{10,11,20,21,22} netstandard{10,11,12,13,14,15,16,20}"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
_dotnet_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	einfo "MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}"

	# run it
	"${@}"
}

# @FUNCTION: dotnet_foreach_impl
# @DESCRIPTION:  This will execute a callback for each dotnet implementation
dotnet_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_dotnet_obtain_impls

	multibuild_foreach_variant _dotnet_multibuild_wrapper "${@}"
}

# @FUNCTION: dotnet_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
dotnet_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_dotnet_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _dotnet_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_dotnet_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		has "${impl}" "${_IMPLS}" && MULTIBUILD_VARIANTS+=( ${impl} )
	done
}

EXPORT_FUNCTIONS pkg_setup pkg_pretend

