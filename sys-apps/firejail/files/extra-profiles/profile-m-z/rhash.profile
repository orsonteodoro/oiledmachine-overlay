# Firejail profile for sha1sum
# Description: compute and check rhash message digests
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include rhash.local
# Persistent global definitions
include globals.local

private-bin rhash

# Redirect
include hasher-common.profile
