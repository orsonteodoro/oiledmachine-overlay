## PGO/BOLT packages

The following list contains ebuilds modified by this overlay with PGO (Profile
Guided Optimization) support or BOLT, with additional patches from others listed
in the metadata.xml.

* app-arch/zopfli (pgo, bolt)
* app-crypt/libzc (pgo, bolt)
* dev-db/sqlite (pgo, bolt)
* dev-db/mariadb (pgo?, bolt?)
* dev-db/mysql (pgo, bolt)
* dev-lang/ispc (pgo, bolt)
* dev-lang/lua (pgo, bolt)
* dev-lang/mono (pgo)
* dev-lang/php (pgo, bolt)
* dev-libs/jemalloc (pgo, bolt)
* games-engines/box2d (pgo, bolt)
* media-libs/embree (pgo, bolt?)
* media-libs/libaom (pgo, bolt?)
* media-libs/libjpeg-turbo (pgo, bolt)
* media-libs/libspng (pgo, bolt)
* media-libs/libvpx (pgo, bolt)
* media-libs/mesa (epgo, ebolt)
* media-video/ffmpeg (pgo, bolt)
* media-gfx/blender (pgo, bolt?)
* net-libs/nodejs (pgo)
* sci-physics/bullet (pgo)
* sys-kernel/ot-sources (pgo)
* sys-kernel/genkernel (provides pgo flags and training for kernel)
* sys-libs/zlib (pgo)
* x11-libs/cairo (pgo)

Those suffixed with ? are still in testing or not confirmed yet.

epgo and ebolt means with a custom trainer which is usually interactive.

pgo and bolt means pre-selected trainer.

Typical use case training (aka custom trainer) is preferred to optimize cache
use and to minimize junk pages.

The ot-sources usually train with interactive training but can be performed
with automated trainer in [files/pgo-trainer.sh](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/sys-kernel/ot-sources/files/pgo-trainer.sh).
Training should include user-space apps used in typical use, which the automated
trainer may miss.

#### The estimated benefits

* PGO:  compiler(s) ~20% benefit; ~10% on average, ~40% outliers
* BOLT:  compiler(s) ~15% benefit

### EPGO

Some ebuilds will use 3 step PGO per emerge.  Others will use EPGO which
does 1 phase per emerge with the epgo USE flag.  No extra effort is required for
EPGO.

In EPGO, training is done passively.  Instrumentation is or optimized based on
rules or events.

Events triggering PGI (instrumentation):
- Different compiler signatures between PGI and PGO.
- Version bumps that cause breakage or internal dependency updates which are
typically minor versions.
- Forced PGI with UOPTS_PGO_FORCE_PGI
- Differences in {C,CXX,LD}FLAGS.  (via -frecord-gcc-switches tracking) [planned]

Events that may trigger PGO (optimized builds):
- Presence of a PGO profile
- Same compiler signature in PGI and PGO phases
- New patch releases

If a PGI event is observed, PGI takes precedence.

Packages that inherit the tpgo.eclass may skip to 1 step based on same
EPGO event rules.

### uopts per-package options and UOPTS flags

Additional packages that use the tpgo (three step PGO) and epgo (event based
PGO) have additional options that can be changed on a per-package level.

Details about setting up per-package environment variables see the
[package.env](https://wiki.gentoo.org/wiki//etc/portage/package.env) link.

More details can be found in 
[epgo.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/epgo.eclass)
[tpgo.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/tpgo.eclass)
[ebolt.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ebolt.eclass)
[tbolt.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/tbolt.eclass)

USE flags:

* epgo - Build with 1 step PGO in one emerge
* pgo - Build with three step 3 PGO in one emerge
* ebolt - Build with 1 step BOLT in one emerge
* bolt - Build with three step 3 BOLT in one emerge

No stripping BOLT:

BOLTed binaries should never be STRIPed of .bolt.org* sections.  If you see that
portage did strip add either FEATURES="${FEATURES} nostrip" on a per-package
level or modify the portage package with a per-package patch to with
`-w -K .bolt.org*` changes with the DEF_STRIP_FLAGS variable in
[estrip](https://github.com/gentoo/portage/blob/master/bin/estrip#L177)
or
in installed version `${EPREFIX}/usr/lib/portage/${EPYTHON}/estrip` (see also:
`equery f estrip | grep python`).  To prevent segfaults, we set STRIP=true
in the eclass but from experience, it may not always work.

#### PGO environment variables

UOPTS_PGO_FORCE_PGI - 1 to reset to PGI temporarily.  Remember to remove the
flag or set it to 0 after being PGIed.  If build-time is unreliable for PGO, try
setting it to 1.

UOPTS_PGO_PROFILES_DIR - Change the default PGO profile directory.  The default
is `/var/lib/pgo-profiles`.  You may delete individual profiles to reset the PGO
process.

UOPTS_PGO_PORTABLE - 1 to build untouched functions optimized for speed, 0 to
retain untouched functions as optimized for size.

UOPTS_PGO_EVENT_BASED - 1 to build untouch event handler functions optimized for
speed, 0 to retain untouched functions as optimized for size.  Do not use unless
you encounter a performance regression.

UOPTS_GROUP - the name of the group allowed to access and edit the PGO
profile.

#### BOLT environment variables

BOLTFLAGS - Same as UOPTS_BOLT_OPTIMIZATIONS with the same requirements.
It is like the analog to CFLAGS but for llvm-bolt.

UOPTS_BOLT_FORCE_INST - 1 to reset to INST temporarily.

UOPTS_BOLT_HUGIFY - 1 to enable hugify to minimize iTLB misses with large
libraries and executables, 0 to disable.  Hugify is not compatible with
CONFIG_PREEMPT_RT.  The optimization only applies to hot code not data sections
(e.g. data tables, text, art assets).  At this time, the UOPTS_BOLT_HUGIFY_SIZE
threshold value in the *bolt eclasses will determine when the benefits of hugify
is allowed and it is not clear due to the lack of experimental analysis or
research paper by upstream of size of the executable or shared object is needed
to gain a benefit.  (EXPERIMENTAL, amd64 only)

UOPTS_BOLT_OPTIMIZATIONS - Optimization flags to pass to llvm-bolt, overriding
the defaults.
(It is preferred to change this on a
[per package env](https://wiki.gentoo.org/wiki//etc/portage/package.env)
level instead of systemwide via /etc/portage/make.conf.  To see more
optimizations, do `llvm-bolt --help`.)

UOPTS_BOLT_PROFILES_DIR - Change the default BOLT profile directory.

UOPTS_BOLT_SLOT - force to use a particular LLVM slot number to maintain
compatibility with the BOLT profile.

UOPTS_GROUP - the name of the group allowed to access and edit the
BOLT profile.

### EPGO/EBOLT profile permissions

(This section is tentative.  It's still in testing/development.)

Before using ebolt or epgo some environment variables and user groups must
be created for the shared EPGO/EBOLT profile.  For example the following
files could be added/changes for ebolt/epgo:

```
Contents of /etc/portage/env/uopts_x.conf:
# For PGO/BOLT training on X
# Choose a non-root user:group to perform PGO/BOLT training.
UOPTS_USER="johndoe"
UOPTS_GROUP="johndoe"
```

```
Contents of /etc/portage/env/uopts_wayland.conf:
# For PGO/BOLT training on Wayland
# Choose a non-root user:group to perform PGO/BOLT training.
UOPTS_USER="johndoe"
UOPTS_GROUP="johndoe"
```

```
Contents of /etc/portage/env/uopts_portage.conf:
# For PGO/BOLT training within emerge (aka the portage package manager)
UOPTS_USER="portage" # A non-root user to perform PGO/BOLT training.
UOPTS_GROUP="portage"
```

```
Contents of /etc/portage/env/package.env:
llvm-core/llvm uopts_portage.conf
media-libs/mesa uopts_x.conf
games-fps/foo uopts_x.conf
games-fps/bar uopts_wayland.conf
```

You may use "users" or "uopts" if you do not have a physical multiuser.
It is only an issue if there is a vulnerability in gcc/clang when reading
PGO/BOLT profiles because the PGO/BOLT profiles are shared across users.

The permission affects folders that stores BOLT/PGO profile files
which the non-root user must write to.  Specifically, it pertains to
these folders assuming that defaults were used:
`/var/lib/pgo-profiles/${CATEGORY}/${PN}/${UOPTS_SLOT}/${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}/`
`/var/lib/bolt-profiles/${CATEGORY}/${PN}/${UOPTS_SLOT}/${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_IMPLS}/`

Currently using the limited user for the group is recommended to smooth things
out, but it may break on multiuser setup.  When doing epgo/ebolt in multiuser
environment, it should be done ASAP or during maintenance days if the package
is confirmed to break between multiple users.

You may skip the 3 steps for group changes below if using a non-root user
(ex. johndoe) when doing PGO/BOLT training in production.

To add both these groups:
```
sudo groupadd uopts
```

To add users these groups:
```
sudo gpasswd -a johndoe uopts
```
Relog for changes to take effect.

When you are running under the uopts group, you may need to do
`sudo -g uopts appname` instead.

### BOLT + PGO

Some packages may allow BOLT and PGO.  Upstream recommends building the PGO
build to completion first.  Then, do a BOLT optimized build.

Both BOLT and PGO each require 3 steps:

PGO steps:
- instrumentation (PGI)
- training (PGT)
- optimization (PGO)

- testing (usually optional for temporary data but required if package touches
saved user data and no BOLT steps performed.)

BOLT steps:
- instrument (INST)
- collection (aka training)
- optimize (OPT)

- testing (usually optional for temporary data but required if package touches
saved user data and PGO and BOLT steps performed.)

Follow the 6 steps from top to bottom to properly combine them if using epgo
and ebolt.  The ebuild has access to `emerge --config package_name` to optimize
BOLT instrumented ebuilds avoiding long compile-times.

The testing step is often ignored in documentation but there is a chance of
unintended consequences.  If a BOLT training fails/segfaults, it may indicate
that the optimized PGO build has a bug or BOLT instrumentation is buggy.  The
testing step is important to prevent further data loss or data corruption.
Usually the preferred testing is via the test suite or test USE flag.

For those that prefer three step, the same can be achieved with a shell script.
Try epgo + ebolt try something like:

```
#!/bin/bash
# Emerge dependencies first except for PN.
emerge -1vo PN
# You may try emerge -1vuDNo PN for deeper dependencies.

# Instrument for PGI only.
USE="epgo -ebolt" emerge -1vO PN

# Perform PGO training.
echo "done training?" ; read

#
# You can combine at this point.  It is interpreted as follows:
#
# 1. Optimize the build for PGO first.
# 2. Instrument the build for BOLT afterwards.
#
USE="epgo ebolt" emerge -1vO PN

# Perform BOLT training.
echo "done training?" ; read

# Optimize for PGO and BOLT.
echo "done training?" ; read
USE="epgo ebolt" emerge --config PN
```

For those that do 3 step with USE="bolt pgo", the uopts.eclass will
automatically handle all 6 steps if it fortunate enough to come with a trainer.

An ebuild package may have an optimize.sh script along side the ebuild to take
care of this.

### Custom trainer ###

Ebuilds that inherit tpgo or tbolt eclass can use a per-package custom trainer
script, similar to the ideas of a per-package patch.

Requirements

- A directory `/etc/portage/trainers/${CATEGORY}/${PN}`
- A main script `/etc/portage/trainers/${CATEGORY}/${PN}/main.sh`
- Proper permissions:  directories 755 or 750 or 700, data 644 or 640 or 600, scripts 755 or 750 or 700.
- Proper ownership:  root:root
- rhash installed
- Hashes stored in `/etc/portage/trainers/${CATEGORY}/${PN}/Manifest`

Manifest format:
```
DIST relpath1 byte_size1 BLAKE2B hash1 SHA512 hash2
DIST relpath2 byte_size2 BLAKE2B hash1 SHA512 hash2
...
DIST relpathN byte_sizeN BLAKE2B hash1 SHA512 hash2
```

relpath is the relative path to the file in `${WORKDIR}/trainer`.  The script
folder contents at `/etc/portage/trainers/${CATEGORY}/${PN}` will be copied to
`${WORKDIR}/trainer` and run from there.

Hashes can be obtain with the rhash package.

You can place custom assets, shell scripts, etc.  But the main.sh script
should be a bash script.
