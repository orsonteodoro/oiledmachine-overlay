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

# Bash (required)
# See exec.Command sections in x/tools/bash.go
include allow-bin-sh.inc

# Claude Code coding assistant support (optional)
# See exec.Command sections in cmd/launch/claude.go
#noblacklist ${PATH}/claude

# Cline IDE integration support (optional)
# See exec.Command sections in cmd/launch/cline.go
#noblacklist ${PATH}/cline

# Cloud LLM support (optional)
#noblacklist ${PATH}/xdg-open

# Codex CLI coding assistant support (optional)
# See exec.Command sections in cmd/launch/codex.go
#noblacklist ${PATH}/codex

# Droid coding assistant support (optional)
# See exec.Command sections in cmd/launch/droid.go
#noblacklist ${PATH}/droid

# External editor (optional)
# Requires EDITOR environment variable
# See exec.Command sections in cmd/interactive.go

# GitHub Copilot CLI coding agent support (optional)
# See exec.Command sections in cmd/launch/copilot.go
#noblacklist ${PATH}/copilot

# Hermes Agent AI assistant support (optional)
# See exec.Command sections in cmd/launch/hermes.go
#noblacklist ${PATH}/hermes
#include allow-bin-sh.inc
#noblacklist ${PATH}/curl # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)
#noblacklist ${PATH}/bash # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)
#noblacklist ${PATH}/git # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)

# llama-quantize (optional)
# llama-quantize is packaged with llama-server
# See exec.Command sections in server/quantization.go
#noblacklist ${PATH}/llama-quantize

# Kimi support (optional)
# See exec.Command sections in cmd/launch/kimi.go
#noblacklist ${PATH}/kimi
#noblacklist ${PATH}/curl # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)
#noblacklist ${PATH}/bash # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)

# llama-server (optional)
# See exec.Command sections in llm/llama_server.go
# See exec.Command sections in discover/llama_server.go
#noblacklist ${PATH}/llama-server

# mlxrunner (CUDA 13+, sm50, experimental) (optional)
# For Z-Image Turbo and FLUX.2 Klein models
# See exec.Command sections in x/mlxrunner/client.go
# See exec.Command sections in x/imagegen/server.go
#noblacklist ${PATH}/ollama

# OpenClaw AI assistant support (optional)
# See exec.Command sections in cmd/launch/openclaw.go
#noblacklist ${PATH}/clawdbot
#noblacklist ${PATH}/openclaw
#noblacklist ${PATH}/npm # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)
#noblacklist ${PATH}/git # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)

# OpenCode coding assistant support (optional)
#noblacklist ${PATH}/opencode

# Pool coding assistant support (optional)
# See exec.Command sections in cmd/launch/poolside.go
#noblacklist ${PATH}/pool

# Pi coding agent support (optional)
# See exec.Command sections in cmd/launch/pi.go
#noblacklist ${PATH}/npm # (ebuild package manager security bypass, DO NOT USE, use ebuild instead)
#noblacklist ${PATH}/pi

# VSCode IDE integration support (optional)
# See exec.Command sections in cmd/launch/vscode.go
#noblacklist ${PATH}/code
#noblacklist ${PATH}/pkill
#noblacklist ${PATH}/pgrep

# Unix server (optional)
# See exec.Command sections in app/server/server_unix.go
#noblacklist ${PATH}/pgrep
#noblacklist ${PATH}/ps

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
whitelist /etc/passwd # Required, minimal visibility

include landlock-common.inc

# Alternative to no3d but do coarse-grained relaxed restrictions
#blacklist /dev/nvidia*
blacklist /dev/kfd
# but keep /dev/dri whitelisted
noblacklist /dev/dri
whitelist /dev/dri
whitelist /dev/null

# Alternative to noroot but do coarse-grained relaxed restrictions
caps.drop all						# First drop all privileges
caps.keep sys_admin,sys_nice,dac_override,chown		# sys_admin - For GPU memory allocation
							# sys_nice - For GPU priority scheduling
							# dac_override - For /dev/dri access
							# chown - Let ollama manage own files
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

# For --help
private-lib libreadline.so*,libtinfo.so*

private-tmp

dbus-user none
dbus-system none

#deterministic-shutdown
memory-deny-write-execute # Disable to debug with alacritty
#read-only ${HOME}
restrict-namespaces
