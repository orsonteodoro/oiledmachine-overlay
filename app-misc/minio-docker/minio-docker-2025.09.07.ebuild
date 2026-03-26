# Copyright 2025-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CPU_FLAGS_X86_ISA1=(
        "cpu_flags_x86_sse"
        "cpu_flags_x86_sse2"
)

CPU_FLAGS_X86_ISA2=(
        "${CPU_FLAGS_X86_ISA1[@]}"
        "cpu_flags_x86_sse3"
        "cpu_flags_x86_ssse3"
        "cpu_flags_x86_sse4_1"
        "cpu_flags_x86_sse4_2"
        "cpu_flags_x86_popcnt"
        "cpu_flags_x86_cx16"
)

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"

DESCRIPTION="MinIO object storage for LobeHub (Docker-based)"
HOMEPAGE="https://min.io/"
LICENSE="AGPL-3"
SLOT="0"
IUSE="
${CPU_FLAGS_X86_ISA1[@]}
${CPU_FLAGS_X86_ISA2[@]}
+openrc systemd
ebuild_revision_11
"
REQUIRED_USE="
	|| (
		openrc
		systemd
	)
"
DEPEND="
	app-containers/docker
	app-containers/docker-compose
"
RDEPEND="
	${DEPEND}
	acct-group/minio
	acct-user/minio
	net-fs/mc
	openrc? (
		sys-apps/openrc[bash]
	)
	systemd? (
		sys-apps/systemd
	)
"
BDEPEND="
	dev-libs/openssl
"

is_x86_isa_level1() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA1[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

is_x86_isa_level2() {
	has_all_flags=1
	local x
	for x in "${CPU_FLAGS_X86_ISA2[@]}" ; do
		if ! use "${x}" ; then
			has_all_flags=0
			break
		fi
	done

	if (( ${has_all_flags} == 1 )) ; then
		return 0
	else
		return 1
	fi
}

src_install() {
	insinto "/opt/minio"
	local minio_uid=$(id -u "minio")
	local minio_gid=$(id -g "minio")
	local MINIO_ROOT_PASSWORD="MinioLobe$(openssl rand -hex 16)"
	echo "MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}" > "${T}/minio-password.env" || die
	cat \
		"${FILESDIR}/docker-compose.yml" \
			> \
		"${T}/docker-compose.yml" \
		|| die

	# Prevent:
	# docker run --rm -it --entrypoint /bin/bash 69b2ec208575
	# Fatal glibc error: CPU does not support x86-64-v2
	# See also https://hub.docker.com/r/minio/minio/tags
	local tag
	if [[ "${ABI}" == "amd64" ]] ; then
		if is_x86_isa_level2 ; then
			tag="RELEASE.2025-09-07T16-13-09Z"
		elif is_x86_isa_level1 ; then
			tag="RELEASE.2025-09-07T16-13-09Z-cpuv1"
		else
eerror "CPU is not supported.  Make sure the cpu_flags_x86_* are properly updated."
			die
		fi
	elif [[ "${ABI}" == "arm64" ]] ; then
		tag="RELEASE.2025-09-07T16-13-09Z"
	elif [[ "${ABI}" == "ppc64" ]] ; then
		tag="RELEASE.2025-09-07T16-13-09Z"
	else
eerror "ABI=${ABI} is not supported"
		die
	fi

	sed -i \
		-e "s|@MINIO_PASSWORD@|${MINIO_ROOT_PASSWORD}|g" \
		-e "s|@MINIO_UID@|${minio_uid}|g" \
		-e "s|@MINIO_GID@|${minio_gid}|g" \
		-e "s|@TAG@|${tag}|g" \
		"${T}/docker-compose.yml" \
		|| die
	doins "${T}/docker-compose.yml"
	MINIO_ROOT_PASSWORD=$(openssl rand -base64 32)$(openssl rand -base64 32)
	unset MINIO_ROOT_PASSWORD

	# Set correct permissions for docker-compose.yml
	fowners "root:root" "/opt/minio/docker-compose.yml"
	fperms 0600 "/opt/minio/docker-compose.yml"

	if use systemd ; then
		# Install systemd unit
		insinto "/usr/lib/systemd/system"
		doins "${FILESDIR}/minio.service"
	fi

	if use openrc ; then
		# Install OpenRC init script
		newinitd "${FILESDIR}/minio.initd" "minio"
	fi

	# Persistent data directory owned by minio user
	keepdir "/var/lib/minio/data"
	fowners "minio:minio" "/var/lib/minio/data"
	fperms 0750 "/var/lib/minio/data"
	fperms 0755 "/var/lib/minio"

	# Keep data directory
	keepdir "/var/lib/minio/data"

	# Install password file with strict permissions (600)
	insinto "/etc/minio"
	newins "${T}/minio-password.env" "minio-password.env"
	fperms 0600 "/etc/minio/minio-password.env"
	fowners "root:root" "/etc/minio/minio-password.env"
}

pkg_postinst() {
ewarn
ewarn "Security Notice:"
ewarn
ewarn "MinIO is EOL (End of Life) and will stop receiving security updates."
ewarn
einfo
einfo "MinIO for LobeHub has been installed successfully."
einfo
	if use openrc ; then
einfo
einfo "To start MinIO for OpenRC:"
einfo
einfo "    rc-service minio start"
einfo
einfo "To enable at boot for OpenRC:"
einfo
einfo "    rc-update add minio default"
einfo
	fi
	if use systemd ; then
einfo
einfo "To start MinIO manually for systemd:"
einfo
einfo "    systemctl start minio.service"
einfo
einfo "To enable MinIO at boot for systemd:"
einfo
einfo "    systemctl enable minio.service"
einfo
einfo "Important: After first installation or updates, run:"
einfo
einfo "    systemctl daemon-reload"
einfo
	fi
einfo
elog "MinIO Console: http://127.0.0.1:9001"
elog "Access Key : lobehub"
elog "Secret Key : cat /etc/minio/minio-password.env"
elog "Data directory: /var/lib/minio/data (owned by user 'minio')"
einfo
einfo "After starting MinIO, create the bucket:"
einfo
einfo "    minio-client alias set lobehub-minio http://127.0.0.1:9000 lobehub \$(cat /etc/minio/minio-password.env | cut -d= -f2)"
einfo "    minio-client mb lobehub-minio/lobehub"
einfo "    minio-client anonymous set public lobehub-minio/lobehub"
einfo
einfo "Note: If you see 'Unit minio.service not found', run 'systemctl daemon-reload' first."
einfo "See also \`epkginfo -x minio-docker\` to reset or remove the container."
einfo "Use etc-update to update the password in /etc/minio/minio-password.env"
}
