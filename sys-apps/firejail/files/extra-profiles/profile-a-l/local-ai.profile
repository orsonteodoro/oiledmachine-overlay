# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include local-ai.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/dirname
noblacklist ${PATH}/head
noblacklist ${PATH}/local-ai
#noblacklist ${PATH}/mkdir
noblacklist /opt/local-ai
noblacklist /opt/local-ai/local-ai
noblacklist /var/lib/local-ai
noblacklist /etc/hosts
noblacklist /usr/share/hwdata

noblacklist ${PATH}/ls
noblacklist ${PATH}/bash
noblacklist ${PATH}/sh

noblacklist /usr/lib/gcc
noblacklist /usr/lib/llvm

noblacklist /dev/dri
noblacklist /dev/loop

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc # broken
include disable-devel.inc # Prevent bypass of disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc # below not an issue
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

include whitelist-var-common.inc

whitelist /var/lib/local-ai

whitelist /usr/share/vulkan # For GPU acceleraton

whitelist /usr/share/hwdata # For warning

whitelist /etc/ld.so.cache # Required, minimal visibility
whitelist /etc/hosts

include landlock-common.inc

# Alternative to no3d but do coarse-grained relaxed restrictions
#blacklist /dev/nvidia*
blacklist /dev/kfd
# but keep /dev/dri whitelisted
noblacklist /dev/dri
noblacklist /dev/loop
whitelist /dev/dri
whitelist /dev/loop
whitelist /dev/null

# Alternative to noroot but do coarse-grained relaxed restrictions
caps.drop all						# First drop all privileges
caps.keep sys_admin,sys_nice,dac_override,chown		# sys_admin - For GPU memory allocation
							# sys_nice - For GPU priority scheduling
							# dac_override - For /dev/dri access
							# chown - Let local-ai manage own files
nonewprivs						# Prevent privilege escalaction
seccomp !kexec_load,!ptrace,!perf_event_open		# Allow most of seccomp and allow Mesa syscalls

apparmor
ipc-namespace
machine-id
#net none
netfilter
#no3d
nodvd
#nogroups
noinput
#noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
#tracelog

disable-mnt
#private-bin mkdir
private-bin dirname,head,sh
private-bin openssl,grpc_cpp_plugin,grpc_python_plugin
private-cache
private-cwd /opt/local-ai
private-dev
private-etc ld.so.cache,hosts,conf.d/local-ai
#private-etc conf.d/local-ai # Don't enable unless you need it

# Dependencies
private-lib abseil-cpp/20240722,grpc/5,protobuf/5,re2/20250512,protobuf-python/5

# For libstdc++ systems:
private-lib gcc/*/*/libstdc++.so*,gcc/*/*/libgcc_s.so*,gcc/*/*/libgomp.so*

# TODO:  libc++ systems:

# For Vulkan support
private-lib libvulkan.so*

# For GPU Vulkan support
private-lib libvulkan*.so*,llvm/*/lib*/libLLVM.so*

# For grpc depends
private-lib libcares.so*,libcrypto.so*,libssl.so*

private-tmp

dbus-user none
dbus-system none

#deterministic-shutdown
memory-deny-write-execute # Disable to debug with alacritty
#read-only ${HOME}
restrict-namespaces
