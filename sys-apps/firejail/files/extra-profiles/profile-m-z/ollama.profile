# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include ollama.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/ollama
noblacklist /usr/lib/ollama/bin/ollama
noblacklist /usr/lib/ollama
noblacklist /var/lib/ollama

noblacklist /usr/lib/gcc
noblacklist /usr/lib/llvm

include disable-common.inc
include disable-devel.inc # Prevent bypass of disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

whitelist /var/lib/ollama
whitelist ${HOME}/.ollama

whitelist /usr/share/vulkan # For GPU acceleraton

whitelist /etc/ld.so.cache # Required, minimal visibility

include landlock-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
#net none
netfilter
#no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
#tracelog

disable-mnt
private-cache
private-cwd
private-dev
private-etc ld.so.cache
private-lib ollama

# For libstdc++ systems:
private-lib gcc/*/*/libstdc++.so*,gcc/*/*/libgcc_s.so*

# TODO:  libc++ systems:

# For Vulkan support
private-lib libvulkan.so*

# For GPU Vulkan support
private-lib libvulkan*.so*,llvm/*/lib*/libLLVM.so*

private-tmp

dbus-user none
dbus-system none

#deterministic-shutdown
memory-deny-write-execute
#read-only ${HOME}
restrict-namespaces
