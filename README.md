# oiledmachine-overlay

## Important special note

Work on this repo may cease or be infrequent.  Please see issue request.

## About

This portage overlay contains various ebuilds for the Gentoo Linux
distribution.  It focuses on optimized ebuilds, some game development, 
software used in computer science courses, C#, Electron apps, and other legacy 
software and hardware support packages.

The name of the repo comes from "well-oiled machine."  A (Gentoo) computer 
should not feel like molasses under high memory pressure or heavy IO 
utilization.  It should run smoothly.

## Adding the repo

```
emerge app-eselect/eselect-repository
eselect repository add oiledmachine-overlay git https://github.com/orsonteodoro/oiledmachine-overlay.git
```

## Keep in sync by

```
emaint sync -A
```

or

```
emaint sync --repo oiledmachine-overlay
```

## Important stuff

## Overlay bugs/fixes/news

Overlay bugs and fixes are addressed with the `eselect news` command, a feature
that I almost never use.  This overlay uses this system to post
**_critical bugs and fixes_** that cannot be simply fixed through automated means
but by required manual intervention.  You may read the full text by navigating
to the .txt file at:

* https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/metadata/news

The selected first 5 news items:

* 2023-11-05 - [ot-sources PGO patch debug output breaks emerge because the distro's linux-info eclass doesn't perform data validation (It addresses the GCC_PGO_PHASE message spam also.)](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2023-11-05-fix-emerge-at-world/2023-11-05-fix-emerge-at-world.txt)
* 2020-07-19 - [Manual removal of npm or electron based packages required](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2020-07-19-manual-removal-npm-and-electron/2020-07-19-manual-removal-npm-and-electron.en.txt)

## Licenses

Many of these packages have special licenses and EULAs attached to them.  I 
recommend that you edit your /etc/portage/make.conf so it looks like this 
ACCEPT_LICENSE="-*" and manually accept each of the licenses.

Licenses can be found in the following locations:

* [The distro overlay license folder](https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses)
* [The oiledmachine-overlay license folder](https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/licenses)

It is assumed that the distro license folders exists on the local system.

The copyright notices are contained in the source code of downloaded
tarballs and in the about section of the program.

The identifier `custom` is recognized by this overlay and used in several
Linux distros in their community package sets with their LICENSE variable.
It is a catch all used when no license template contains the exact phase
or clause.  The ebuild will contain the keywords to find the custom license.
You can use repo search feature in that project to find the license file
and the location of the text before emerging the package.  You may try to
find the text in the monolithic license file (a file containing all the
licenses and copyright notices) referenced in the LICENSE variable.  If
the license text is buried in a git submodule, you need to manually scan
each module or try to do a search engine scan.  You can also try to do the
following in the command line template:

```
#OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"} # if using the old README.md instructions
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"} # if using eselect repository
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd ${PN}
ebuild ${PN}-${PV}.ebuild unpack
grep -l -i -r -e "<KEYWORDS>" "<WORKDIR>"
```

to scan the package locally to find the license file before merge.

Many of these packages especially non-free software also require you to 
manually obtain the installer or files to install and may require you to 
register on their website.  The required files are listed in the ebuild but
may require some mental gynmanstics to find the actual name.

## Broken / Still in development

### Python

Several packages hard depend on Python 3.9 and will emit
"No supported implementation in PYTHON_COMPAT" because of the eager version
bump of this version which is not EOL until Oct 2025 by the Python language
developers but EOL on this distro.

You will need to uninstall these packages.

The maximum slot will not be auto bumped by scripts in this overlay anymore.

Python maximums for PYTHON_COMPAT in this overlay are upstream set listed
in python.py + proof of test (aka summary of the test result(s) passed)
which are listed in the footer of the ebuild as the standard in this
overlay.  This overlay may downgrade the PYTHON_COMPAT if no proof is
provided.

### .NET Framework stack or .NET Core stack

It was decided to keep these packages around; however, they are not tested
in actual programs.

Since there is no official distro package developer guide or eclass for
.NET 6.0+ packages, the install locations may be off for ebuilds in this
overlay.

## Legacy packages

Old packages can be found at 
[oiledmachine-overlay-legacy](https://github.com/orsonteodoro/oiledmachine-overlay-legacy).

A package may be moved to oiledmachine-overlay-legacy if bundled dependencies
are not fixed within several following discoveries of critical vulnerabilties
typically in several months.

A package also moves to legacy if the project is defunct.

A package does not move to legacy if a newer different package replacement is
found or same ebuild found in the gentoo-overlay.

A package does not move to legacy if the project's source code or possibly the
dependency's source code was deleted.

## Enhanced ebuild metadata.xml info

Some of the ebuilds in this repo contain improved comprehensive information
describing USE flags, developer API documentation info, or special per-package
environmental variables that improve the build process that can be found in
the metadata.xml, or obtainable through `epkginfo -x =games-engines/box2d-2.4.1-r2`
for example.  Some of that information is only obtained by inspecting the
comments of that file.  See `epkginfo --help` for details.

Additional troubleshooting details can also be found by inspecting the header
and footer of the ebuild.

## Ebuild quality

Most ebuilds in this ebuild are assumed production ready.

Disabled KEYWORDS has ambiguous meanings.  It can mean that it is either a live
ebuild, or is incomplete, etc.

### Markings for not production ready

To clarify which ebuilds are not production ready, this overlay has added to the
footer the following metainfo:

```
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
```

To see a list which ebuilds are not production ready, run the following at the
root of this overlay:
```
grep -l --exclude-dir=.git -r -e "OILEDMACHINE-OVERLAY-EBUILD-FINISHED:.*NO" ./
```

KEYWORDS does the same thing but it has different meanings over time.  It could
mean fresh install without problems or widely tested.

Production ready means that it simply installs and the package is working
acceptably without necessarily running test suites with minimal install
features or the arbitrary tested USE flag combination at that time.

But in this overlay, running test suites are optional but done so for mostly
library packages or packages that are rarely used with unknown runtime
correctness.  Many python packages in this overlay have been tested but for
other programming languages this has not been done.  In this overlay, it is
planned to prioritize PGO capable first, running test-suites for libraries
next, smaller/trivial packages next, then high MLOC packages over time.
This testing will be limited to only latest stable for dependencies.  This
overlay has fixed missing required USE flags and applied regressions fixes
as a result of running test suites.  These test suites are also inspected
for usefulness (e.g. a benchmark, demos, or similar real world tasks) in
PGO optimization on the ebuild level which some ebuilds exploit.

### Markings for test-suite testing or interactive testing

Test-suite testing is done randomly.  Tentative details can be found at the
footer of the ebuild:

For interactive testing, some most used functionality will be tested.

```
# OILEDMACHINE-OVERLAY-EBUILD-TESTED-VERSIONS:  1.2.1 1.2.1[python_targets_python3_10] commit-id
# OILEDMACHINE-OVERLAY-TEST:  PASS (INTERACTIVE) 113.0.1 (May 15, 2023)
```

## Security policy

### 2020 policy

In 2020 for this overlay only, it was decided that ebuild-packages would be
dropped or migrated into oiledmachine-legacy to ideally eliminate
vulnerable packages.

Packages are updated if a critical vulnerability has been announced.
Send an [issue request](https://github.com/orsonteodoro/oiledmachine-overlay/issues)
if you find one.

Web engines and browsers such as firefox, chromium, webkit-gtk, cef-bin,
CEF/Electron web based apps, are updated everytime a critical
vulnerability is announced or after several strings of high vulnerabilties.

ot-kernel is updated every release to minimize unpatched 0-day exploits.  Old
ebuilds are removed intentionally and assume to contain one or an unannounced
one by comparing keywords in the kernel changelog with the
[CWE Top 25 Most Dangerous Software Weaknesses (2022)](https://cwe.mitre.org/top25/archive/2022/2022_cwe_top25.html)
list.

Packages are updated based on [GLSA](https://security.gentoo.org/glsa) and
random [NVD](https://nvd.nist.gov/vuln/search) searches.

Any binary package with dependencies with critical or high security
advisories matching the version of the dependency will be mentioned in
the ebuild at the time of packaging.  Only upstream can fix those problems
especially if dependencies are statically linked.

Some packages or ebuilds may be hard masked in 
[profiles/package.mask](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/profiles/package.mask)
if the package still has some utility but unable to be removed, or
contains a known infamous critical vulnerability.

### 2023 policy

Due to recent hacking near the beginning of the year (or earlier) of a prominent
member of the open source community who happens to also use the distro, it was
decided to (1) add proactive scanning of malware for binary blobs and
Electron/NPM based packages; and to (2) add proactive scanning of Electron/NPM
based packages for session-replay dependencies or command line options that may
result in unauthorized screen capture that may steal sensitive information and
also scan for analytics.

To use the proactive malware scan, you must install `app-antivirus/clamav[clamapp]`.

The policy for suspected analytics or session replay is "deny" build and install.

It can be enabled or disabled using per-package USE flags or systemwide through
make.conf.  Examples how to do this are shown below:

```
# Contents of /etc/portage/env/disable-avscan.conf
# 0 to disable, 1 to enable.
SECURITY_SCAN_AVSCAN=0
```

```
# Contents of /etc/portage/env/allow-analytics.conf
# allow means continue build/install, deny or unset means stop build/install.
SECURITY_SCAN_ANALYTICS="allow"
```

```
# Contents of /etc/portage/env/allow-session-replay.conf
# allow means continue build/install, deny or unset means stop build/install.
SECURITY_SCAN_SESSION_REPLAY="allow"
```

```
# Contents of /etc/portage/package.env:
dev-util/devhub allow-analytics.conf
sys-kernel/ot-sources disable-avscan.conf
media-gfx/blockbench disable-avscan.conf
media-gfx/upscayl allow-session-replay.conf
media-video/sr disable-avscan.conf
```

#### Limitations

These scans may, however, be too sensitive or may result in false positives.
The scans for session-replay/analytics are limited to plaintext only and can be
easily circumvented with obfuscated forms or written language change (i.e.
non-English) in source code form.  Only firmware/logos provided to ot-sources,
Electron and NPM based packages, media-video/sr are scanned.  You may need to
set up your own
[/etc/portage/bashrc](https://wiki.gentoo.org/wiki//etc/portage/bashrc)
for additional comprehensive scans that scan again malware, and session replay
and analytics keywords.

Additional packages with binary blobs or prebuilt packages may be modified with
these extra scans.

Source code scans are limited to command line patterns and keyword search.
Scanning based on library API calls or function names is not done.

Source code scans for unauthorized microphone and webcam use are currently not
done but can be added via the bashrc with a grep on found die check.  Some of
these issues can be mitigated by running the app under isolation or in a
sandbox.

These scans are ineffective against physical or side-channel attacks such as
unencrypted keyboard/input connection capture (e.g. evil maid attack).

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
sys-devel/llvm uopts_portage.conf
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

## Packages

<!--
Autogenerated from:

for x in $(grep -l -e "^DESCRIPTION" $(find . -name "*ebuild")) ; do d=$(cat "${x}" | tr '\n' ' ' | tr '\\\\' ' ' | grep -o -E "DESCRIPTION=\"[^\"]+" | cut -f 2 -d '"'); atom=$(echo "${x}" | cut -f 2-3 -d "/"); echo "| ${atom} | ${d} |" ; done | sort | uniq | sed -r -e "s|[ ]+| |g"
-->

| package | description |
| --- | --- |
| acct-group/ollama | A group for ollama |
| acct-user/ollama | A user for ollama |
| app-admin/coreboot-utils | A selection from coreboot/utils useful in general |
| app-admin/howdy | Facial authentication for Linux |
| app-admin/keepassxc | KeePassXC - KeePass Cross-platform Community Edition |
| app-antivirus/clamav | Clam Anti-Virus Scanner |
| app-arch/go-appimage | Purely experimental playground for Go implementation of AppImage tools |
| app-arch/pigz | A parallel implementation of gzip |
| app-arch/static-tools | Building static binaries of some tools using an Alpine chroot with musl |
| app-arch/static-tools-appstreamcli | appstreamcli for static-tools |
| app-arch/static-tools-bsdtar | bsdtar for static-tools |
| app-arch/static-tools-desktop-file-utils | desktop-file-utils for static-tools |
| app-arch/static-tools-patchelf | patchelf for static-tools |
| app-arch/static-tools-runtime-fuse | runtime-fuse for static-tools |
| app-arch/static-tools-squashfs-tools | squashfuse for static-tools |
| app-arch/static-tools-squashfuse | squashfuse for static-tools |
| app-arch/static-tools-zsyncmake | zsyncmake for static-tools |
| app-arch/zopfli | A very good, but slow, deflate or zlib compression |
| app-benchmarks/mixbench | A GPU benchmark tool for evaluating GPUs and CPUs on mixed operational intensity kernels (CUDA, OpenCL, HIP, SYCL, OpenMP) |
| app-benchmarks/opencl-benchmark | A small OpenCL benchmark program to measure peak GPU/CPU performance. |
| app-benchmarks/transferbench | TransferBench is a utility capable of benchmarking simultaneous copies between user-specified devices (CPUs/GPUs) |
| app-crypt/gcr | Libraries for cryptographic UIs and accessing PKCS#11 modules |
| app-crypt/hashcat | The World's fastest and most advanced password recovery utility |
| app-crypt/hashtopolis | Hashtopolis is a Hashcat wrapper for distributed password recovery |
| app-crypt/hashtopolis-python-agent | The official Python agent for using the distributed hashcracker Hashtopolis |
| app-crypt/libzc | Tool and library for cracking legacy zip files. |
| app-crypt/webhashcat | Hashcat web interface |
| app-editors/nano-ycmd | GNU GPL'd Pico clone with more functionality with ycmd support |
| app-emacs/emacs-ycmd | Emacs client for ycmd, the code completion system |
| app-eselect/eselect-cython | Manages the cython symlinks |
| app-eselect/eselect-emscripten | Manages the emscripten environment |
| app-eselect/eselect-nodejs | Manages the /usr/include/node symlink |
| app-eselect/eselect-rocm | Manages the rocm symlinks |
| app-eselect/eselect-typescript | Manages the /usr/bin/tsc /usr/bin/tsserver symlinks |
| app-misc/alpaca | An Ollama AI client made with GTK4 and Adwaita |
| app-misc/amica | Amica is a customizable friendly interactive AI with 3D characters, voice synthesis, speech recognition, emotion engine |
| app-misc/june | Local voice AI chatbot for engaging conversations, powered by Ollama, Hugging Face Transformers, and Coqui TTS Toolkit |
| app-misc/liquidctl | Cross-platform tool and drivers for liquid coolers and other devices |
| app-misc/llocal | Aiming to provide a seamless and privacy driven AI chatting experience with open-sourced technologies |
| app-misc/ollama | Get up and running with Llama 3, Mistral, Gemma, and other local large language models (LLMs) synonymous with AI chatbots or AI assistants. |
| app-misc/ssl-cert-snakeoil | A self-signed certificate required by some *.deb packages or projects |
| app-shells/emoji-cli | Emoji completion on the command line |
| app-shells/emojify | Emoji on the command line |
| app-shells/loz | Loz is a command-line tool that enables your preferred LLM to execute system commands and utilize Unix pipes, integrating AI capabilities with other Unix tools. |
| app-shells/ohmyzsh | A delightful community-driven framework for managing your zsh configuration that includes optional plugins and themes. |
| app-shells/percol | Adds flavor of interactive filtering to the traditional pipe concept of shell |
| app-shells/shell-gpt | A command-line productivity tool powered by OpenAI's GPT models. |
| app-text/aspell | Free and Open Source spell checker designed to replace Ispell |
| app-text/enchant | Generic spell checking library |
| app-text/hunspell | Spell checker, morphological analyzer library and command-line tool |
| app-text/pdfchain | Graphical User Interface for PDF Toolkit (PDFtk) |
| app-text/poppler | PDF rendering library based on the xpdf-3.0 code base |
| dev-build/bazel | Fast and correct automated build system |
| dev-build/rocm-cmake | Radeon Open Compute CMake Modules |
| dev-cpp/FunctionalPlus | Functional Programming Library for C++. Write concise and readable C++ code. |
| dev-cpp/abseil-cpp | Abseil Common Libraries (C++), LTS Branch |
| dev-cpp/blaze | A high performance C++ math library |
| dev-cpp/frugally-deep | Header-only library for using Keras (TensorFlow) models in C++. |
| dev-cpp/nlohmann_json | JSON for Modern C++ |
| dev-cpp/pystring | C++ functions matching the interface and behavior of python string methods |
| dev-cpp/selfrando | Function order shuffling to defend against ROP and other types of code reuse |
| dev-cpp/tbb | High level abstract threading library |
| dev-cpp/tbb | oneAPI Threading Building Blocks (oneTBB) |
| dev-db/mariadb | An enhanced, drop-in replacement for MySQL |
| dev-db/mysql | A fast, multi-threaded, multi-user SQL database server |
| dev-db/nanodbc | A small C++ wrapper for the native C ODBC API |
| dev-db/sqlite | SQL database engine |
| dev-dotnet.old/assimp-net | AssimpNet is a C# language binding to the Assimp library |
| dev-dotnet.old/atitextureconverter | A C# Wrapper for the TextureConverter native library to allow |
| dev-dotnet.old/freeimagenet | FreeImage.NET is a wrapper for the FreeImage library for popular |
| dev-dotnet.old/gnome-sharp | Bindings to the core Gnome APIs |
| dev-dotnet.old/gwen-dotnet | GWEN.Net is a .Net port of GWEN, and is a lightweight GUI library aimed at games. |
| dev-dotnet.old/libgdiplus | Library for using System.Drawing with Mono |
| dev-dotnet.old/libgit2sharp | A C# PInvoke wrapper library for LibGit2 C library |
| dev-dotnet.old/mono-addins | A generic framework for creating extensible applications |
| dev-dotnet.old/ndesk-options | NDesk.Options |
| dev-dotnet.old/nvorbis | NVorbis is a C# vorbis decoder |
| dev-dotnet.old/opentk | OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL |
| dev-dotnet.old/pvrtexlibnet | Simple C# wrapper around PVRTexLib from Imagination Technologies |
| dev-dotnet.old/sharpfont | Cross-platform FreeType bindings for .NET |
| dev-dotnet.old/xwt | Cross platform GUI framework for desktop and mobile applications |
| dev-dotnet/BulletSharpPInvoke | .NET wrapper for the Bullet physics library using Platform Invoke |
| dev-dotnet/GtkSharp | .NET wrapper for Gtk and other related libraries |
| dev-dotnet/aforgedotnet | AForge.NET Framework is a C# framework designed for developers and researchers in the fields of Computer Vision and Artificial Intelligence - image processing, neural networks, genetic algorithms, machine learning, robotics, etc. |
| dev-dotnet/dotdevelop | DotDevelop will hopefully be a full-featured integrated development environment (IDE) for .NET using GTK. |
| dev-dotnet/faudio | FAudio - Accuracy-focused XAudio reimplementation for open platforms |
| dev-dotnet/fna | FNA - Accuracy-focused XNA4 reimplementation for open platforms |
| dev-dotnet/fna3d | FNA3D - 3D Graphics Library for FNA |
| dev-dotnet/fsharp-mono-bin | The F# compiler, F# core library, and F# editor tools |
| dev-dotnet/gtk-sharp | GTK bindings for Mono |
| dev-dotnet/gtk-sharp | Gtk# is a Mono/.NET binding to the cross platform Gtk+ GUI toolkit and the foundation of most GUI apps built with Mono |
| dev-dotnet/libfreenect | Drivers and libraries for the Xbox Kinect |
| dev-dotnet/mono-msbuild-bin | MSBuild is the build platform for .NET and VS. |
| dev-dotnet/monodevelop-bin | MonoDevelop is a cross platform .NET IDE |
| dev-dotnet/monodevelop-database-bin | Database Addin for MonoDevelop |
| dev-dotnet/monodevelop-nunit-bin | NUnit plugin for MonoDevelop |
| dev-dotnet/monodevelop-versioncontrol-bin | VersionControl plugin for MonoDevelop |
| dev-dotnet/monogame | One framework for creating powerful cross-platform games. |
| dev-dotnet/monogame-extended | MonoGame.Extended are classes and extensions to make MonoGame more awesome |
| dev-dotnet/sdl2-cs | SDL2# - C# Wrapper for SDL2 |
| dev-dotnet/sfmldotnet | SFML.Net is a C# language binding for SFML |
| dev-dotnet/sharpnav | SharpNav is an advanced pathfinding library for C# |
| dev-dotnet/theorafile | An Ogg Theora Video Decoder Library |
| dev-dotnet/tiledsharp | C# library for parsing and importing TMX and TSX files generated by Tiled, a tile map generation tool. |
| dev-dotnet/velcrophysics | High performance 2D collision detection system with realistic physics responses. |
| dev-games/enigma | ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, is an open source cross-platform game development environment. |
| dev-games/gdevelop | GDevelop is an open-source, cross-platform game engine designed to be used by everyone. |
| dev-games/godot-demo-projects | Demonstration and Template Projects |
| dev-games/godot-editor | Godot editor |
| dev-games/godot-export-templates-bin | Godot export templates |
| dev-games/godot-meta | Godot metapackage |
| dev-games/lateralgm | A free game maker source file editor |
| dev-games/radialgm | A native IDE for ENIGMA written in C++ using the Qt Framework. |
| dev-games/recastnavigation | Navigation-mesh Toolset for Games |
| dev-go/protobuf-go | Go support for Google's protocol buffers |
| dev-go/protoc-gen-go-grpc | This tool generates Go language bindings of services in protobuf definition files for gRPC |
| dev-java/grpc-java | High-performance RPC framework (Java libraries) |
| dev-lang/classic-flang | Flang is a Fortran language front-end designed for integration with LLVM. |
| dev-lang/gambas | Gambas is a free development environment and a full powerful development platform based on a Basic interpreter with object extensionsand form designer. |
| dev-lang/ispc | Intel® SPMD Program Compiler |
| dev-lang/llvm-flang | LLVM Flang is a continuation of F18 to replace Classic Flang |
| dev-lang/lua | A powerful light-weight programming language designed for extending applications |
| dev-lang/lua-extra-headers | Installs extra headers required by Lua applications |
| dev-lang/mono | Mono runtime and class libraries, a C# compiler/interpreter |
| dev-lang/php | The PHP language runtime engine |
| dev-lang/python-exec | Python script wrapper |
| dev-lang/rocm-flang | ROCm's fork of Classic Flang with GPU offload support |
| dev-lang/spidermonkey | A JavaScript engine written in C and C++ |
| dev-lang/typescript | TypeScript is a superset of JavaScript that compiles to clean JavaScript output |
| dev-libs/Orochi | Orochi is a library loading HIP and CUDA APIs dynamically, allowing the user to switch APIs at runtime |
| dev-libs/ROCdbgapi | AMD Debugger API |
| dev-libs/amdgpu-pro-opencl-legacy | Legacy OpenCL support for AMDGPU-PRO drivers |
| dev-libs/atmi | ATMI is a runtime framework for efficient task management in heterogeneous CPU-GPU systems |
| dev-libs/cJSON | Ultralightweight JSON parser in ANSI C |
| dev-libs/cpuinfo | CPU INFOrmation library |
| dev-libs/crc32c | CRC32C implementation with support for CPU-specific acceleration instructions |
| dev-libs/double-conversion | Binary-decimal and decimal-binary conversion routines for IEEE doubles |
| dev-libs/gdrcopy | A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology |
| dev-libs/hardened_malloc | A hardened allocator designed for modern systems |
| dev-libs/hip-cpu | An implementation of HIP that works on CPUs, across OSes. |
| dev-libs/hipother | Other HIP backend compatibility |
| dev-libs/hsa-amd-aqlprofile | AQLPROFILE library for AMD HSA runtime API extension support |
| dev-libs/hyphen | ALTLinux hyphenation library |
| dev-libs/icu | International Components for Unicode |
| dev-libs/jemalloc | Jemalloc is a general-purpose scalable concurrent allocator |
| dev-libs/jemalloc-usd | Jemalloc is a general-purpose scalable concurrent allocator |
| dev-libs/leveldb | A fast key-value storage library |
| dev-libs/libappimage | Implements functionality for dealing with AppImage files |
| dev-libs/libdatachannel | C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets |
| dev-libs/libfmt | Small, safe and fast formatting library |
| dev-libs/libfreenect | Drivers and libraries for the Xbox Kinect device |
| dev-libs/log4c | Logging FrameWork for C, as Log4j or Log4Cpp |
| dev-libs/miniz | A lossless, high performance data compression library |
| dev-libs/nccl | Optimized primitives for collective multi-GPU communication |
| dev-libs/nccl-rdma-sharp-plugins | RDMA and SHARP plugins for the NCCL library |
| dev-libs/nxjson | A very small JSON parser written in C |
| dev-libs/protobuf | An extensible mechanism for serializing structured data |
| dev-libs/pugixml | Light-weight, simple, and fast XML parser for C++ with XPath support |
| dev-libs/rapidjson | A fast JSON parser/generator for C++ with both SAX/DOM style API |
| dev-libs/rccl | ROCm Communication Collectives Library (RCCL) |
| dev-libs/rccl-rdma-sharp-plugins | rccl-rdma-sharp plugin enables RDMA and Switch based collectives (SHARP) with AMD's RCCL library |
| dev-libs/re2 | An efficient, principled regular expression library |
| dev-libs/rocm-comgr | Radeon Open Compute Code Object Manager |
| dev-libs/rocm-core | rocm-core is a utility which can be used to get ROCm release version. |
| dev-libs/rocm-debug-agent | Radeon Open Compute Debug Agent |
| dev-libs/rocm-device-libs | Radeon Open Compute Device Libraries |
| dev-libs/rocm-opencl-runtime | Radeon Open Compute OpenCL Compatible Runtime |
| dev-libs/rocprofiler-register | The rocprofiler-register helper library |
| dev-libs/rocr-runtime | Radeon Open Compute Runtime |
| dev-libs/roct-thunk-interface | Radeon Open Compute Thunk Interface |
| dev-libs/spdlog | Very fast, header only, C++ logging library |
| dev-libs/unittest++ | A lightweight unit testing framework for C++ |
| dev-libs/utf8_range | Fast UTF-8 validation with Range algorithm (NEON+SSE4+AVX2) |
| dev-lua/luafilesystem | File System Library for the Lua Programming Language |
| dev-lua/luasqlite3 | LuaSQLite 3 is a thin wrapper around the public domain SQLite3 database engine |
| dev-lua/luaxml | A minimal set of XML processing funcs & simple XML<->Tables mapping |
| dev-nodejs/acorn | A small, fast, JavaScript-based JavaScript parser Resources |
| dev-perl/Alien-Build-Git | Alien::Build tools for interacting with git |
| dev-perl/Alien-FFI | Build and make available libffi |
| dev-perl/Alien-caca | Alien package for the Colored ASCII Art library |
| dev-perl/FFI-Platypus | Write Perl bindings to non-Perl libraries with FFI. No XS required. |
| dev-perl/Mojo-DOM58 | Minimalistic HTML/XML DOM parser with CSS selectors |
| dev-perl/MooseX-MungeHas | Munge your 'has' (works with Moo, Moose and Mouse) |
| dev-perl/PerlX-Maybe | Return a pair only if they are both defined |
| dev-perl/PerlX-Maybe-XS | XS backend for PerlX::Maybe |
| dev-perl/Term-Caca | A perl interface for libcaca (Colour AsCii Art library) |
| dev-perl/Test-Vars | Detects unused variables in perl modules |
| dev-perl/Test2-Tools-URL | Compare a URL in your Test2 test |
| dev-perl/URI-git | URI handler for git scheme |
| dev-php/grpc | High-performance RPC framework (PHP libraries) |
| dev-php/libcaca | A library that creates colored ASCII-art graphics |
| dev-python/Farama-Notifications | Gymnasium Notices |
| dev-python/Flask-HTTPAuth | Simple extension that provides Basic, Digest and Token HTTP authentication for Flask routes |
| dev-python/JaroWinkler | Python library for fast approximate string matching using Jaro and Jaro-Winkler similarity |
| dev-python/Levenshtein | The Levenshtein Python C extension module contains functions for fast computation of Levenshtein distance and string similarity |
| dev-python/RapidFuzz | Rapid fuzzy string matching in Python using various string metrics |
| dev-python/SciencePlots | Matplotlib styles for scientific plotting |
| dev-python/aafigure | ASCII art to image converter |
| dev-python/aioquic | QUIC and HTTP/3 implementation in Python |
| dev-python/ale-py | The Arcade Learning Environment (ALE) is a platform for AI research |
| dev-python/anyio | A compatibility layer for multiple asynchronous event loop implementations |
| dev-python/array-record | A file format that achieves a new frontier of IO efficiency |
| dev-python/astunparse | An Abstract Syntax Tree (AST) unparser for Python |
| dev-python/autorom | A tool to automate installing Atari ROMs for the Arcade Learning Environment |
| dev-python/autorom-accept-rom-license | AutoROM ROMs |
| dev-python/barectf | Generator of ANSI C tracers which output CTF data streams |
| dev-python/blis | A self-contained 💥 fast matrix-multiplication Python library without system dependencies! |
| dev-python/box2d-py | A repackaged version of pybox2d |
| dev-python/bsuite | bsuite is a collection of carefully-designed experiments that investigate core capabilities of a reinforcement learning (RL) agent |
| dev-python/cachetools | Extensible memoizing collections and decorators |
| dev-python/catalogue | Super lightweight function registries for your library |
| dev-python/celshast | A Sphinx documentation theme based on the Furo template |
| dev-python/chex | Chex is a library of utilities for helping to write reliable JAX code. |
| dev-python/cloudpathlib | Python pathlib-style classes for cloud storage services |
| dev-python/clu | A set of libraries for Machine Learning (ML) training loops in JAX |
| dev-python/colorlover | Color scales in Python for humans |
| dev-python/confection | 🍬 Confection: the sweetest config system for Python |
| dev-python/contextlib2 | contextlib2 is a backport of the standard library's contextlib module to earlier Python versions. |
| dev-python/controlnet-aux | Auxillary models for controlnet |
| dev-python/coqpit | A simple but maybe too simple config management through Python data classes used for machine learning |
| dev-python/coqui-tts | 🐸💬 - a deep learning toolkit for Text-to-Speech, battle-tested in research and production |
| dev-python/coqui-tts-trainer | Create, fill a temporary directory |
| dev-python/cuda-python | Python bindings for CUDA |
| dev-python/cymem | 💥 Cython memory pool for RAII-style memory management |
| dev-python/cython | A Python to C compiler |
| dev-python/dash-bootstrap-components | Bootstrap components for Plotly Dash |
| dev-python/dash-svg | SVG support library for Plotly/Dash |
| dev-python/dataclass-wizard | A simple, yet elegant, set of wizarding tools for interacting with Python dataclasses. |
| dev-python/dek | The decorator-decorator |
| dev-python/diffusers | State-of-the-art diffusion in PyTorch and JAX. |
| dev-python/distrax | Distrax: Probability distributions in JAX. |
| dev-python/dm-control | DeepMind's software stack for physics-based simulation and Reinforcement Learning environments, using MuJoCo. |
| dev-python/dm-env | A Python interface for reinforcement learning environments |
| dev-python/dm-haiku | JAX-based neural network library |
| dev-python/dm-meltingpot | A suite of test scenarios for multi-agent reinforcement learning. |
| dev-python/dm-sonnet | Sonnet is a library for building neural networks in TensorFlow. |
| dev-python/dm-tree | tree is a library for working with nested data structures |
| dev-python/dmlab2d | A customisable 2D platform for agent-based AI research |
| dev-python/docker-pycreds | Python bindings for the docker credentials store API |
| dev-python/docutils | Python Documentation Utilities (reference reStructuredText impl.) |
| dev-python/dopamine-rl | Dopamine is a research framework for fast prototyping of reinforcement learning algorithms. |
| dev-python/ecos | Python interface for ECOS |
| dev-python/editor | A Python library to open the default text editor |
| dev-python/elevate | A Python library for requesting root privileges |
| dev-python/encodec | State-of-the-art deep learning based audio codec supporting both mono 24 kHz audio and stereo 48 kHz audio. |
| dev-python/etils | Collection of eclectic utils for python. |
| dev-python/exhale | Automatic C++ library api documentation generation: breathe doxygen in and exhale it out |
| dev-python/fastbencode | Fast implementation of bencode |
| dev-python/flake8-colors | ANSI colors highlight for Flake8 |
| dev-python/flake8-docstrings | Integration of pydocstyle and flake8 for combined linting and reporting |
| dev-python/flake8-future-import | Flake8 extension to check imports |
| dev-python/flake8-import-order | Flake8 plugin that checks import order against various Python Style Guides |
| dev-python/flake8-print | Check for Print statements in python files. |
| dev-python/flash-attn | Fast and memory-efficient exact attention |
| dev-python/flax | Flax is a neural network library for JAX that is designed for flexibility. |
| dev-python/gin-config | Gin-Config: A lightweight configuration library for Python |
| dev-python/gitdb | IO of git-style object databases |
| dev-python/google | Python bindings to the Google search engine. |
| dev-python/google-auth | Google Authentication Library |
| dev-python/google-auth-oauthlib | oauthlib integration for the Google Auth library |
| dev-python/grpcio | High-performance RPC framework (python libraries) |
| dev-python/grpcio-testing | Testing utilities for gRPC Python |
| dev-python/grpcio-tools | Protobuf code generator for gRPC |
| dev-python/gruut | A tokenizer, text cleaner, and phonemizer for many human languages. |
| dev-python/gruut-ipa | Python library for manipulating pronunciations using the International Phonetic Alphabet (IPA) |
| dev-python/gviz-api | Python API for Google Visualization |
| dev-python/gym | A toolkit for developing and comparing reinforcement learning algorithms. |
| dev-python/gym-notices | Gym Notices |
| dev-python/gymnasium | A standard API for single-agent reinforcement learning environments, with popular reference environments and related utilities (formerly Gym) |
| dev-python/gymnasium-notices | Gymnasium Notices |
| dev-python/hanabi-learning-environment | hanabi_learning_environment is a research platform for Hanabi experiments. |
| dev-python/inquirer | Collection of common interactive command line user interfaces, based on Inquirer.js |
| dev-python/instructor | Structured outputs for LLMs |
| dev-python/jax | Differentiate, compile, and transform Numpy code |
| dev-python/jaxlib | Support library for JAX |
| dev-python/jaxtyping | Type annotations and runtime checking for shape and dtype of JAX/NumPy/PyTorch/etc. arrays. |
| dev-python/js8py | Python module for parsing messages from the 'js8' command line decoder |
| dev-python/jumpy | On-the-fly conversions between Jax and NumPy tensors |
| dev-python/kaggle | The Official Kaggle API |
| dev-python/kaldi-io | Python functions for reading kaldi data formats. Useful for rapid prototyping with python. |
| dev-python/keras | Deep Learning for humans |
| dev-python/keras-applications | Keras deep learning library reference implementations of deep learning models |
| dev-python/keras-preprocessing | Easy data preprocessing and data augmentation for deep learning models |
| dev-python/labmaze | A standalone release of DeepMind Lab's maze generator with Python bindings. |
| dev-python/langcodes | A Python library for working with and comparing language codes. |
| dev-python/language-data | Create, fill a temporary directory |
| dev-python/librosa | A python package for music and audio analysis. |
| dev-python/lightning | The Deep Learning framework to train, deploy, and ship AI products Lightning fast. |
| dev-python/lightning-api-access | Lightning Frontend Showing how a given API can be accessed |
| dev-python/lightning-app | Use Lightning Apps to build everything from production-ready, multi-cloud ML systems to simple research demos. |
| dev-python/lightning-cloud | Lightning Cloud |
| dev-python/lightning-fabric | Fabric is the fast and lightweight way to scale PyTorch models without boilerplate |
| dev-python/lightning-utilities | Common Python utilities and GitHub Actions in Lightning Ecosystem |
| dev-python/llvmlite | A lightweight wrapper around basic LLVM functionality |
| dev-python/marisa-trie | Static memory-efficient Trie-like structures for Python |
| dev-python/merge3 | Python implementation of 3-way merge |
| dev-python/mizani | A scales package for python |
| dev-python/ml-collections | ML Collections is a library of Python Collections designed for ML use cases. |
| dev-python/ml-datasets | Create, fill a temporary directory |
| dev-python/ml-dtypes | A stand-alone implementation of several NumPy dtype extensions used in machine learning. |
| dev-python/model-index | Create a source of truth for ML model results and browse it on Papers with Code |
| dev-python/moviepy | Video editing with Python |
| dev-python/mujoco | Python bindings for MuJoCo (Multi-Joint dynamics with Contact), a general purpose physics simulator. |
| dev-python/multi-agent-ale-py | A fork of the the Arcade Learning Environment (ALE) platform for AI research with multiplayer support |
| dev-python/murmurhash | 💥 Cython bindings for MurmurHash2 |
| dev-python/mypy | Optional static typing for Python |
| dev-python/myst-parser | An extended commonmark compliant parser, with bridges to docutils/sphinx |
| dev-python/namex | Clean up the public namespace of your package! |
| dev-python/nashpy | A python library for 2 player games. |
| dev-python/neural-compressor | State of the art low-bit LLM quantization (INT8/FP8/INT4/FP4/NF4) & sparsity; leading model compression techniques on TensorFlow, PyTorch, and ONNX Runtime |
| dev-python/nnef-parser | The NNEF parser |
| dev-python/nnef-tools | NNEF Tools |
| dev-python/nose_xunitmp | A nosetest xunit plugin with multiprocessor support |
| dev-python/num2words | Modules to convert numbers to words. |
| dev-python/numba | NumPy aware dynamic Python compiler using LLVM |
| dev-python/numpy | Fast array and numerical python library |
| dev-python/ollama | Ollama Python library |
| dev-python/onnx-simplifier | Simplify your ONNX model |
| dev-python/onnxoptimizer | A C++ library for performing arbitrary optimizations on ONNX models |
| dev-python/open-spiel | OpenSpiel is a collection of environments and algorithms for research in general reinforcement learning and search/planning in games. |
| dev-python/openai | The official Python library for the OpenAI API |
| dev-python/optax | Optax is a gradient processing and optimization library for JAX. |
| dev-python/optree | tree is a library for working with nested data structures |
| dev-python/orbax | Orbax is a library providing common utilities for JAX users. |
| dev-python/orbax-checkpoint | A checkpointing library for Orbax |
| dev-python/pathlib-abc | Python base classes for rich path objects |
| dev-python/pathy | A simple, flexible, offline capable, cloud storage with a Python path-like interface |
| dev-python/patiencediff | A Patience Diff implementation in Python |
| dev-python/pep8-naming | Naming Convention checker for Python |
| dev-python/pettingzoo | A standard API for multi-agent reinforcement learning environments, with popular reference environments and related utilities |
| dev-python/pillow-simd | The friendly PIL fork |
| dev-python/plotille | Plot in the terminal using braille dots. |
| dev-python/plotnine | A Grammar of Graphics for Python |
| dev-python/pocket | A Python wrapper for the Pocket API |
| dev-python/portpicker | A module to find available network ports for testing. |
| dev-python/preshed | 💥 Cython hash tables that assume keys are pre-hashed |
| dev-python/pretrainedmodels | Pretrained Convolutional Neural Networks for PyTorch:  NASNet, ResNeXt, ResNet, InceptionV4, InceptionResnetV2, Xception, DPN, etc. |
| dev-python/proglog | Logs and progress bars manager for Python |
| dev-python/protobuf | Python bindings for Google's Protocol Buffers |
| dev-python/py-stackexchange | A Python binding for the StackExchange API |
| dev-python/py3c | A Python 2/3 compatibility layer for C extensions |
| dev-python/pyaudio | Python bindings for PortAudio |
| dev-python/pyclibrary | C parser and ctypes automation for python |
| dev-python/pycsdr | Python bindings for the csdr library |
| dev-python/pydantic-settings | Settings management using Pydantic |
| dev-python/pydigiham | Python bindings for the digiham library |
| dev-python/pyfiglet | An implementation of figlet written in Python |
| dev-python/pyglfw | Python bindings for GLFW |
| dev-python/pylsqpack | Python bindings for ls-qpack |
| dev-python/pymunk | Pymunk is a easy-to-use pythonic 2d physics library that can be used whenever you need 2d rigid body physics from Python |
| dev-python/pynvml | Python Bindings for the NVIDIA Management Library |
| dev-python/pyperf | Toolkit to run Python benchmarks |
| dev-python/pyreadline3 | Windows implementation of the GNU readline library Resources |
| dev-python/pysbd | 🐍💯pySBD (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box. |
| dev-python/pytest-markdown-docs | Run pytest on markdown code fence blocks |
| dev-python/pytest-raises | An implementation of pytest.raises as a pytest.mark fixture |
| dev-python/python-chess | A chess library for Python, with move generation and validation, PGN parsing and writing, Polyglot opening book reading, Gaviota tablebase probing, Syzygy tablebase probing, and UCI/XBoard engine communication |
| dev-python/python-crfsuite | Create, fill a temporary directory |
| dev-python/python-decouple | Strict separation of config from code. |
| dev-python/python-plexapi | Python bindings for the Plex API. |
| dev-python/python-resize-image | A small Python package to easily resize images |
| dev-python/python-soxr | Fast and high quality sample-rate conversion library for Python |
| dev-python/python-uinput | Pythonic API to Linux uinput module |
| dev-python/pytorch-lightning | PyTorch Lightning is the lightweight PyTorch wrapper for ML researchers. Scale your models. Write less boilerplate. |
| dev-python/pytube | Python tools for downloading YouTube Videos |
| dev-python/pyv4l2 | A simple Video4Linux2 (v4l2) library for Python |
| dev-python/pyvips | Python bindings for libvips |
| dev-python/rlax | A library of reinforcement learning building blocks in JAX. |
| dev-python/rlcard | Reinforcement Learning / AI Bots in Card (Poker) Games - Blackjack, Leduc, Texas, DouDizhu, Mahjong, UNO. |
| dev-python/runs | Run a block of text as a subprocess |
| dev-python/scipy | Scientific algorithms library for Python |
| dev-python/sentencepiece | Unsupervised text tokenizer for Neural Network-based text generation. |
| dev-python/setuptools-gettext | A setuptools plugin for building mo files |
| dev-python/setuptools-git-versioning | Use git repo data (latest tag, current commit hash, etc) for building a version number according PEP-440 |
| dev-python/shimmy | An API conversion tool for popular external reinforcement learning environments |
| dev-python/simple-parsing | A small utility for simplifying and cleaning up argument parsing scripts. |
| dev-python/spacy | 💫 Industrial-strength Natural Language Processing (NLP) in Python |
| dev-python/spacy-legacy | 🕸️ Legacy architectures and other registered spaCy v3.x functions for backwards-compatibility |
| dev-python/spacy-loggers | 📟 Logging utilities for spaCy |
| dev-python/sphinx-theme-builder | Clean up the public namespace of your package! |
| dev-python/srsly | 🦉 Modern high-performance serialization utilities for Python (JSON, MessagePack, Pickle) |
| dev-python/sysv-ipc | System V IPC primitives (semaphores, shared memory and message queues) for Python |
| dev-python/tdir | Create, fill a temporary directory |
| dev-python/tf-keras | The TensorFlow-specific implementation of the Keras API |
| dev-python/thinc | 🔮 A refreshing functional take on deep learning, compatible with your favorite libraries |
| dev-python/timm | PyTorch Image Models |
| dev-python/toml | Python lib for TOML |
| dev-python/trfl | trfl is a library of building blocks for reinforcement learning algorithms. |
| dev-python/triton | Development repository for the Triton language and compiler |
| dev-python/triton | The Triton language and compiler |
| dev-python/typer | Typer, build great CLIs. Easy to code. Based on Python type hints. |
| dev-python/types-aiofiles | Typing stubs for aiofiles |
| dev-python/types-dataclasses | Typing stubs for dataclasses |
| dev-python/types-toml | Typing stubs for toml |
| dev-python/typing-extensions | Backported and experimental type hints for Python |
| dev-python/wandb | A CLI and library for interacting with the Weights & Biases API |
| dev-python/wasabi | 🍣 A lightweight console printing and formatting toolkit |
| dev-python/weasel | 🦦 weasel: A small and easy workflow system |
| dev-python/wrapt | Module for decorators, wrappers and monkey patching |
| dev-python/xmod | Turn any object into a module |
| dev-ruby/libcaca | A library that creates colored ASCII-art graphics |
| dev-util/DOCA-Host | DOCA-Host |
| dev-util/HIPIFY | HIPIFY: Convert CUDA to Portable C++ Code |
| dev-util/ROCgdb | Heterogeneous debugging for x86 and AMDGPU on ROCm™ software |
| dev-util/Tensile | Stretching GPU performance for GEMMs and tensor contractions |
| dev-util/amd-smi | ROCm Application for Reporting System Info |
| dev-util/android-ndk | The Android Native Development Kit |
| dev-util/android-sdk-build-tools | Android SDK Build-Tools |
| dev-util/android-sdk-commandlinetools | Android SDK Command-line Tools |
| dev-util/android-sdk-platform-tools | Android SDK Platform |
| dev-util/bear | Bear is a tool that generates a compilation database for clang tooling. |
| dev-util/binaryen | Compiler infrastructure and toolchain library for WebAssembly |
| dev-util/carbon-now-cli | Beautiful images of your code from right inside your terminal. |
| dev-util/closure-compiler-npm | Check, compile, optimize and compress Javascript with Closure-Compiler |
| dev-util/dyninst | DyninstAPI: Tools for binary instrumentation, analysis, and modification. |
| dev-util/emscripten | LLVM-to-JavaScript Compiler |
| dev-util/geany | GTK+ based fast and lightweight IDE |
| dev-util/grex | grex generates regular expressions from user-provided test cases. |
| dev-util/gycm | A Geany plugin to support the ycmd code completion server |
| dev-util/hip | C++ Heterogeneous-Compute Interface for Portability |
| dev-util/hip-meta | HIP metapackage |
| dev-util/hipfort | Fortran interfaces for ROCm libraries |
| dev-util/jsonlint | JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript. |
| dev-util/omniperf | Advanced Profiling and Analytics for AMD Hardware |
| dev-util/omnitrace | Omnitrace: Application Profiling, Tracing, and Analysis |
| dev-util/rocm-meta | ROCm metapackage |
| dev-util/rocm-smi | ROCm System Management Interface Library |
| dev-util/rocm-validation-suite | The ROCm Validation Suite is a system administrator’s and cluster manager's tool for detecting and troubleshooting common problems affecting AMD GPU(s) running in a high-performance computing environment. |
| dev-util/rocm_bandwidth_test | Bandwidth test for ROCm |
| dev-util/rocminfo | ROCm Application for Reporting System Info |
| dev-util/rocprofiler | Callback/Activity Library for Performance tracing AMD GPU's |
| dev-util/roctracer | Callback/Activity Library for Performance tracing AMD GPU's |
| dev-util/synp | Convert yarn.lock to package-lock.json and vice versa |
| dev-util/theia | Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript. |
| dev-util/uglifyjs | JavaScript parser / mangler / compressor / beautifier toolkit |
| dev-util/ycm-generator | Generates config files for YouCompleteMe |
| dev-util/ycmd | A code-completion & code-comprehension server |
| dev-vcs/breezy | Breezy is a friendly powerful distributed version control system. |
| games-engines/box2d | Box2D is a 2D physics engine for games |
| games-rpg/RisuAI | Make your own story. User-friendly software for LLM roleplaying |
| gui-apps/taigo | A virtual pet for your desktop built with GTK+, Vala, and love. |
| gui-apps/windowpet | Pet overlay app built with tauri and react that lets you have adorable companion such as pets, anime characters on your screen. |
| gui-libs/libdecor | A client-side decorations library for Wayland clients |
| media-fonts/noto-color-emoji-bin | A prebuilt font for colored emojis |
| media-fonts/noto-color-emoji-config | Minimal config to get colored Noto emojis working on Gentoo. |
| media-gfx/alembic | Alembic is an open framework for storing and sharing scene data that includes a C++ library, a file format, and client plugins and applications. |
| media-gfx/blockbench | Blockbench is a boxy 3D model editor |
| media-gfx/dssim | Image similarity comparison simulating human perception |
| media-gfx/material-maker | A procedural textures authoring and 3D model painting tool based on the Godot game engine |
| media-gfx/nanovdb | A lightweight GPU friendly version of VDB initially targeting rendering applications. |
| media-gfx/openvdb | Library for the efficient manipulation of volumetric data |
| media-gfx/upscayl | Upscayl is an AI based image upscaler |
| media-gfx/upscayl-custom-models | Extra custom models for Upscayl. |
| media-libs/HIPRT | HIP RT is a ray tracing library in HIP |
| media-libs/alure | The OpenAL Utility Toolkit |
| media-libs/assimp | Importer library to import assets from 3D files |
| media-libs/csfml | The official binding of SFML for C |
| media-libs/embree | Collection of high-performance ray tracing kernels |
| media-libs/flac | free lossless audio encoder and decoder |
| media-libs/glui | GLUI User Interface Library |
| media-libs/gst-plugins-bad | A set of bad plugins that fall short of code quality or support needs of GStreamer |
| media-libs/gst-plugins-base | A based set of plugins meeting code quality and support needs of GStreamer |
| media-libs/gst-plugins-good | A set of good plugins that meet licensing, code quality, and support needs of GStreamer |
| media-libs/gst-plugins-ugly | A set of ugly plugins that may have patent or licensing issues for GStreamer and distributors |
| media-libs/gst-rtsp-server | A GStreamer based RTSP server library |
| media-libs/gstreamer | Open source multimedia framework |
| media-libs/libaom | Alliance for Open Media AV1 Codec SDK |
| media-libs/libcaca | A library that creates colored ASCII-art graphics |
| media-libs/libfishsound | Simple programming interface to decode and encode audio with vorbis or speex |
| media-libs/libjpeg-turbo | MMX, SSE, and SSE2 SIMD accelerated JPEG library |
| media-libs/libmediainfo | MediaInfo libraries |
| media-libs/libsdl2 | Simple Direct Media Layer |
| media-libs/libsfml | Simple and Fast Multimedia Library (SFML) |
| media-libs/libspng | libspng is a C library for reading and writing Portable Network Graphics (PNG) format files with a focus on security and ease of use. |
| media-libs/libvpx | WebM VP8 and VP9 Codec SDK |
| media-libs/libyuv | libyuv is an open source project that includes YUV scaling and conversion functionality. |
| media-libs/libzen | Shared library for libmediainfo and mediainfo |
| media-libs/materialx | MaterialX is an open standard for the exchange of rich material and look-development content across applications and renderers. |
| media-libs/mesa | OpenGL-like graphic library for Linux |
| media-libs/mojoshader | Use Direct3D shaders with other 3D rendering APIs. |
| media-libs/oidn | Intel® Open Image Denoise library |
| media-libs/opencolorio | A color management framework for visual effects and animation |
| media-libs/opencv | A collection of algorithms and sample code for various computer vision problems |
| media-libs/openimageio | A library for reading and writing images |
| media-libs/openpgl | Implements a set of representations and training algorithms needed to integrate path guiding into a renderer |
| media-libs/opensubdiv | A subdivision surface library |
| media-libs/openusd | Universal Scene Description is a system for 3D scene interexchange between apps |
| media-libs/openxr | Generated headers and sources for OpenXR loader. |
| media-libs/opusfile | A high-level decoding and seeking API for .opus files |
| media-libs/osl | Advanced shading language for production GI renderers |
| media-libs/partio | Library for particle IO and manipulation |
| media-libs/theoraplay | TheoraPlay is a simple library to make decoding of Ogg Theora videos easier. |
| media-libs/tremor | A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec) |
| media-libs/vaapi-drivers | A metapackage for libva drivers |
| media-libs/vips | VIPS Image Processing Library |
| media-libs/woff2 | Encode/decode WOFF2 font format |
| media-plugins/RadeonProRenderBlenderAddon | A Blender rendering plug-in for accurate ray-tracing to produce images and animations of your scenes, providing real-time interactive rendering and continuous adjustment of effects. |
| media-plugins/RadeonProRenderMaterialLibrary | Radeon ProRender for Blender Material Library for Linux |
| media-plugins/filmic-blender | Film Emulsion-Like Camera Rendering Transforms for Blender |
| media-plugins/gst-plugins-a52dec | ATSC A/52 audio decoder plugin for GStreamer |
| media-plugins/gst-plugins-adaptivedemux2 | Adaptive demuxer plugins for Gstreamer |
| media-plugins/gst-plugins-aes | AES encryption/decryption plugin for GStreamer |
| media-plugins/gst-plugins-amr | AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer |
| media-plugins/gst-plugins-analyticsoverlay | The analyticsoverlay plugin can highlight and assign AI categorized labels to detected objects for GStreamer |
| media-plugins/gst-plugins-aom | Alliance for Open Media AV1 plugin for GStreamer |
| media-plugins/gst-plugins-assrender | ASS/SSA rendering with effects support plugin for GStreamer |
| media-plugins/gst-plugins-avtp | Audio/Video Transport Protocol (AVTP) plugin for GStreamer |
| media-plugins/gst-plugins-aws | A redirect ebuild for gst-plugins-aws |
| media-plugins/gst-plugins-bluez | AVDTP source/sink and A2DP sink plugin for GStreamer |
| media-plugins/gst-plugins-bs2b | bs2b elements for Gstreamer |
| media-plugins/gst-plugins-cairo | Video overlay plugin based on cairo for GStreamer |
| media-plugins/gst-plugins-cdg | A redirect ebuild for gst-plugins-cdg |
| media-plugins/gst-plugins-cdio | CD Audio Source (cdda) plugin for GStreamer |
| media-plugins/gst-plugins-cdparanoia | CD Audio Source (cdda) plugin for GStreamer |
| media-plugins/gst-plugins-chromaprint | Calculate Chromaprint fingerprint from audio files for GStreamer |
| media-plugins/gst-plugins-claxon | A redirect ebuild for gst-plugins-claxon |
| media-plugins/gst-plugins-closedcaption | A closed caption plugin for GStreamer |
| media-plugins/gst-plugins-codec2json | Debugging/testing support by convert frame parameters to json plugin for GStreamer |
| media-plugins/gst-plugins-colormanagement | Color management correction GStreamer plugins |
| media-plugins/gst-plugins-csound | A redirect ebuild for gst-plugins-csound |
| media-plugins/gst-plugins-curl | cURL network source and sink for GStreamer |
| media-plugins/gst-plugins-dash | MPEG-DASH plugin for GStreamer |
| media-plugins/gst-plugins-dav1d | A redirect ebuild for gst-plugins-dav1d |
| media-plugins/gst-plugins-dc1394 | libdc1394 IIDC camera source plugin for GStreamer |
| media-plugins/gst-plugins-dtls | DTLS encoder/decoder with SRTP support plugin for GStreamer |
| media-plugins/gst-plugins-dts | DTS audio decoder plugin for Gstreamer |
| media-plugins/gst-plugins-dv | DV demuxer and decoder plugin for GStreamer |
| media-plugins/gst-plugins-dvb | DVB device capture plugin for GStreamer |
| media-plugins/gst-plugins-dvdread | DVD read plugin for GStreamer |
| media-plugins/gst-plugins-faac | AAC audio encoder plugin for GStreamer |
| media-plugins/gst-plugins-faad | AAC audio decoder plugin |
| media-plugins/gst-plugins-fallbackswitch | A redirect ebuild for gst-plugins-fallbackswitch |
| media-plugins/gst-plugins-fdkaac | Fraunhofer AAC audio codec plugin for GStreamer |
| media-plugins/gst-plugins-ffv1 | A redirect ebuild for gst-plugins-ffv1 |
| media-plugins/gst-plugins-flac | FLAC encoder/decoder/tagger plugin for GStreamer |
| media-plugins/gst-plugins-flite | The Flite speech synthesis plugin for GStreamer |
| media-plugins/gst-plugins-fluidsynth | FluidSynth plugin for GStreamer |
| media-plugins/gst-plugins-fmp4 | A redirect ebuild for gst-plugins-fmp4 |
| media-plugins/gst-plugins-gdkpixbuf | Image decoder, overlay and sink plugin for GStreamer |
| media-plugins/gst-plugins-gif | A redirect ebuild for gst-plugins-gif |
| media-plugins/gst-plugins-gme | libgme, a video game music file emulator, decoder plugin for GStreamer |
| media-plugins/gst-plugins-gs | Elements to interact with Google Cloud Storage for GStreamer |
| media-plugins/gst-plugins-gsm | GSM plugin for GStreamer |
| media-plugins/gst-plugins-gtk | Video sink plugin for GStreamer that renders to a GtkWidget |
| media-plugins/gst-plugins-gtk4 | A redirect ebuild for gst-plugins-gtk4 |
| media-plugins/gst-plugins-hls | HTTP live streaming plugin for GStreamer |
| media-plugins/gst-plugins-hlssink3 | A redirect ebuild for gst-plugins-hlssink3 |
| media-plugins/gst-plugins-hsv | A redirect ebuild for gst-plugins-hsv |
| media-plugins/gst-plugins-iqa | Image quality assessment plugin for GStreamer |
| media-plugins/gst-plugins-isac | iSAC plugin for GStreamer |
| media-plugins/gst-plugins-jack | JACK audio server source/sink plugin for GStreamer |
| media-plugins/gst-plugins-jpeg | JPEG image encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-json | A redirect ebuild for gst-plugins-json |
| media-plugins/gst-plugins-ladspa | Ladspa elements for Gstreamer |
| media-plugins/gst-plugins-lame | MP3 encoder plugin for GStreamer |
| media-plugins/gst-plugins-lc3 | LC3 (Bluetooth) LE audio codec plugin for GStreamer |
| media-plugins/gst-plugins-ldac | LDAC plugin for GStreamer |
| media-plugins/gst-plugins-lewton | A redirect ebuild for gst-plugins-lewton |
| media-plugins/gst-plugins-libav | FFmpeg based gstreamer plugin |
| media-plugins/gst-plugins-libde265 | H.265 decoder plugin for GStreamer |
| media-plugins/gst-plugins-libnice | GStreamer plugin for ICE (RFC 5245) support |
| media-plugins/gst-plugins-libpng | PNG image encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-libvisual | Visualization elements for GStreamer |
| media-plugins/gst-plugins-livesync | A redirect ebuild for gst-plugins-livesync |
| media-plugins/gst-plugins-lv2 | Lv2 elements for Gstreamer |
| media-plugins/gst-plugins-mdns | A device provider plugin and RTSP server discovery for GStreamer |
| media-plugins/gst-plugins-meta | A metapackage to pull in gst plugins for apps |
| media-plugins/gst-plugins-modplug | MOD audio decoder plugin for GStreamer |
| media-plugins/gst-plugins-mp4 | A redirect ebuild for gst-plugins-mp4 |
| media-plugins/gst-plugins-mpeg2dec | MPEG2 decoder plugin for GStreamer |
| media-plugins/gst-plugins-mpeg2enc | MPEG-1/2 video encoding plugin for GStreamer |
| media-plugins/gst-plugins-mpg123 | MP3 decoder plugin for GStreamer |
| media-plugins/gst-plugins-mplex | MPEG/DVD/SVCD/VCD video/audio multiplexing plugin for GStreamer |
| media-plugins/gst-plugins-musepack | Musepack plugin for GStreamer |
| media-plugins/gst-plugins-ndi | A redirect ebuild for gst-plugins-ndi |
| media-plugins/gst-plugins-neon | HTTP client source plugin for GStreamer |
| media-plugins/gst-plugins-onnx | ONNX neural network plugin for GStreamer |
| media-plugins/gst-plugins-openal | OpenAL plugin for GStreamer |
| media-plugins/gst-plugins-openaptx | openaptx plugin for GStreamer |
| media-plugins/gst-plugins-opencv | OpenCV elements for GStreamer |
| media-plugins/gst-plugins-openexr | OpenEXR plugin for GStreamer |
| media-plugins/gst-plugins-openh264 | H.264 encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-openjpeg | JPEG2000 image codec plugin for GStreamer |
| media-plugins/gst-plugins-openmpt | OpenMPT module music library plugin for GStreamer |
| media-plugins/gst-plugins-openni2 | OpenNI2 plugin for GStreamer |
| media-plugins/gst-plugins-opus | Opus audio parser plugin for GStreamer |
| media-plugins/gst-plugins-oss | OSS (Open Sound System) support plugin for GStreamer |
| media-plugins/gst-plugins-pulse | PulseAudio sound server plugin for GStreamer |
| media-plugins/gst-plugins-qroverlay | Overlay QR codes on an element from a buffer for GStreamer |
| media-plugins/gst-plugins-qt | A Qt5 video sink plugin for GStreamer |
| media-plugins/gst-plugins-qt6 | A Qt6 video sink plugin for GStreamer |
| media-plugins/gst-plugins-raptorq | A redirect ebuild for gst-plugins-raptorq |
| media-plugins/gst-plugins-rav1e | A redirect ebuild for gst-plugins-rav1e |
| media-plugins/gst-plugins-raw1394 | A FireWire DV/HDV capture plugin for GStreamer |
| media-plugins/gst-plugins-regex | A redirect ebuild for gst-plugins-regex |
| media-plugins/gst-plugins-reqwest | A redirect ebuild for gst-plugins-reqwest |
| media-plugins/gst-plugins-resindvd | DVD playback support plugin for GStreamer |
| media-plugins/gst-plugins-rs | Various GStreamer plugins written in Rust |
| media-plugins/gst-plugins-rsaudiofx | A redirect ebuild for gst-plugins-audiofx |
| media-plugins/gst-plugins-rsclosedcaption | A redirect ebuild for gst-plugins-closedcaption (Rust implementation) |
| media-plugins/gst-plugins-rsfile | A redirect ebuild for gst-plugins-file |
| media-plugins/gst-plugins-rsflv | A redirect ebuild for gst-plugins-flavors |
| media-plugins/gst-plugins-rsinter | A redirect ebuild for gst-plugins-inter |
| media-plugins/gst-plugins-rsonvif | A redirect ebuild for gst-plugins-onvif |
| media-plugins/gst-plugins-rspng | A redirect ebuild for gst-plugins-png |
| media-plugins/gst-plugins-rsrtp | A redirect ebuild for gst-plugins-rtp |
| media-plugins/gst-plugins-rsrtsp | A redirect ebuild for gst-plugins-rtsp |
| media-plugins/gst-plugins-rstracers | A redirect ebuild for gst-plugins-tracers |
| media-plugins/gst-plugins-rsvg | SVG overlay and decoder plugin for GStreamer |
| media-plugins/gst-plugins-rsvideofx | A redirect ebuild for gst-plugins-videofx |
| media-plugins/gst-plugins-rswebp | A redirect ebuild for gst-plugins-webp (Rust implementation) |
| media-plugins/gst-plugins-rswebrtc | A redirect ebuild for gst-plugins-webrtc (Rust implementation) |
| media-plugins/gst-plugins-rtmp | RTMP source/sink plugin for GStreamer |
| media-plugins/gst-plugins-sbc | SBC encoder and decoder plugin for GStreamer |
| media-plugins/gst-plugins-sctp | SCTP plugins for GStreamer |
| media-plugins/gst-plugins-shout2 | Icecast server sink plugin for GStreamer |
| media-plugins/gst-plugins-sidplay | Sid decoder plugin for GStreamer |
| media-plugins/gst-plugins-smoothstreaming | Smooth Streaming plugin for GStreamer |
| media-plugins/gst-plugins-sndfile | libsndfile plugin for GStreamer |
| media-plugins/gst-plugins-sndio | Sndio audio sink and source for GStreamer |
| media-plugins/gst-plugins-sodium | A redirect ebuild for gst-plugins-sodium |
| media-plugins/gst-plugins-soundtouch | Beats-per-minute detection and pitch controlling plugin for GStreamer |
| media-plugins/gst-plugins-soup | HTTP client source/sink plugin for GStreamer |
| media-plugins/gst-plugins-spandsp | Packet loss concealment audio plugin for GStreamer |
| media-plugins/gst-plugins-speex | Speex encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-spotify | A redirect ebuild for gst-plugins-spotify |
| media-plugins/gst-plugins-srt | Secure reliable transport (SRT) transfer plugin for GStreamer |
| media-plugins/gst-plugins-srtp | SRTP encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-svtav1 | Scalable Video Technology for AV1 plugin for GStreamer |
| media-plugins/gst-plugins-svthevcenc | AES encryption/decryption plugin for GStreamer |
| media-plugins/gst-plugins-taglib | ID3v2/APEv2 tagger plugin for GStreamer |
| media-plugins/gst-plugins-teletext | VBI subtitles plugin for GStreamer |
| media-plugins/gst-plugins-textahead | A redirect ebuild for gst-plugins-textahead |
| media-plugins/gst-plugins-textwrap | A redirect ebuild for gst-plugins-textwrap |
| media-plugins/gst-plugins-threadshare | A redirect ebuild for gst-plugins-threadshare |
| media-plugins/gst-plugins-togglerecord | A redirect ebuild for gst-plugins-togglerecord |
| media-plugins/gst-plugins-ttml | TTML subtitles support for GStreamer |
| media-plugins/gst-plugins-twolame | MPEG2 encoder plugin for GStreamer |
| media-plugins/gst-plugins-uriplaylistbin | A redirect ebuild for gst-plugins-uriplaylistbin |
| media-plugins/gst-plugins-uvch264 | UVC compliant H.264 encoding cameras plugin for GStreamer |
| media-plugins/gst-plugins-v4l2 | V4L2 source/sink plugin for GStreamer |
| media-plugins/gst-plugins-vaapi | Hardware accelerated video codecs through VA-API for GStreamer |
| media-plugins/gst-plugins-voaacenc | AAC encoder plugin for GStreamer |
| media-plugins/gst-plugins-voamrwbenc | AMR-WB audio encoder plugin for GStreamer |
| media-plugins/gst-plugins-vpx | VP8/VP9 video encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-wavpack | Wavpack audio encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-webp | WebP image format support for GStreamer |
| media-plugins/gst-plugins-webrtc | WebRTC plugins for GStreamer |
| media-plugins/gst-plugins-webrtchttp | A redirect ebuild for gst-plugins-webrtchttp |
| media-plugins/gst-plugins-wildmidi | WildMIDI soft synth plugin for GStreamer |
| media-plugins/gst-plugins-wpe | WPE Web browser plugin for GStreamer |
| media-plugins/gst-plugins-x264 | H.264 encoder plugin for GStreamer |
| media-plugins/gst-plugins-x265 | H.265 encoder plugin for GStreamer |
| media-plugins/gst-plugins-ximagesrc | X11 video capture stream plugin for GStreamer |
| media-plugins/gst-plugins-zbar | Bar codes detection in video streams for GStreamer |
| media-plugins/gst-plugins-zxing | Barcode image scanner plugin using zxing-cpp for GStreamer |
| media-plugins/openvino-ai-plugins-gimp | GIMP AI plugins with OpenVINO Backend |
| media-radio/codecserver | Modular audio codec server |
| media-radio/csdr | A simple DSP library and command-line tool for Software Defined Radio. |
| media-radio/digiham | Tools for decoding digital ham communication |
| media-radio/dream | A software radio for AM and Digital Radio Mondiale (DRM) |
| media-radio/hpsdrconnector | An OpenWebRX connector for HPSDR radios |
| media-radio/m17-cxx-demod | M17 Demodulator in C++ |
| media-radio/openwebrx | A multi-user Software Defined Radio (SDR) receiver software with a web interface |
| media-radio/owrx_connector | Direct conection layer for OpenWebRX |
| media-radio/runds_connector | OpenWebRX connector implementation for R&S EB200 or Ammos protocol based receivers |
| media-radio/sddc_connector | Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on llibsddc |
| media-sound/puddletag | An audio tag editor |
| media-sound/spotify | A social music platform |
| media-sound/w3crapcli-lastfm | w3crapcli/last.fm provides a command line interface for the last.fm web service |
| media-video/ffmpeg | Complete solution to record/convert/stream audio and video. Includes libavcodec |
| media-video/gspca_ep800 | Kernel Modules for Endpoints EP800/SE402/SE401* |
| media-video/linux-enable-ir-emitter | Provides support for infrared cameras that are not directly enabled out-of-the box. |
| media-video/obs-studio | Software for live streaming and screen recording |
| media-video/sr | Image and video super resolution |
| net-im/caprine | Elegant Facebook Messenger desktop app |
| net-im/chatterino | Chat client for https://twitch.tv |
| net-libs/Thunder | Thunder (aka WPEFramework) |
| net-libs/cef-bin | Chromium Embedded Framework (CEF) is a simple framework for embedding Chromium-based browsers in other applications. |
| net-libs/google-cloud-cpp | Google Cloud Client Library for C++ |
| net-libs/grpc | Modern open source high performance RPC framework |
| net-libs/libavtp | Open source implementation of Audio Video Transport Protocol (AVTP) specified in IEEE 1722-2016 spec. |
| net-libs/librist | Reliable Internet Streaming Transport |
| net-libs/nghttp2 | HTTP/2 C Library |
| net-libs/nodejs | A JavaScript runtime built on the V8 JavaScript engine |
| net-libs/webkit-gtk:6 | Open source web browser engine (GTK 4 with HTTP/2 support) |
| net-libs/webkit-gtk:4 | Open source web browser engine (GTK+3 with HTTP/1.1 support) |
| net-libs/webkit-gtk:4.1 | Open source web browser engine (GTK+3 with HTTP/2 support) |
| net-misc/OCDM-Clearkey | ClearKey OpenCDM(i) plugin |
| net-misc/ThunderClientLibraries | Thunder supporting libraries |
| net-misc/ThunderInterfaces | Thunder interface definitions |
| net-misc/ThunderNanoServices | Thunder NanoServices & AppEngines (aka WPEFrameworkPlugins) |
| net-misc/ThunderTools | Thunder (aka WPEFramework) |
| net-misc/ThunderUI | ThunderUI is the development and test UI that runs on top of Thunder |
| sci-geosciences/google-earth-pro | A 3D interface to the planet |
| sci-libs/FBGEMM | Facebook GEneral Matrix Multiplication |
| sci-libs/MIGraphX | AMD's graph optimization engine |
| sci-libs/MIVisionX | MIVisionX toolkit is a set of comprehensive computer vision and machine intelligence libraries, utilities, and applications bundled into a single toolkit. |
| sci-libs/XNNPACK | library of floating-point neural network inference operators |
| sci-libs/caffe2 | A deep learning framework |
| sci-libs/composable_kernel | Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators |
| sci-libs/hipBLAS | ROCm BLAS marshalling library |
| sci-libs/hipBLASLt | hipBLASLt is a library that provides general matrix-matrix operations with a flexible API and extends functionalities beyond a traditional BLAS library |
| sci-libs/hipCUB | Wrapper of rocPRIM or CUB for GPU parallel primitives |
| sci-libs/hipFFT | CU / ROCM agnostic hip FFT implementation |
| sci-libs/hipRAND | CU / ROCM agnostic hip RAND implementation |
| sci-libs/hipSOLVER | ROCm SOLVER marshalling library |
| sci-libs/hipSPARSE | ROCm SPARSE marshalling library |
| sci-libs/hipSPARSELt | hipSPARSELt is a SPARSE marshalling library, with multiple supported backends. |
| sci-libs/hipTensor | AMD’s C++ library for accelerating tensor primitives |
| sci-libs/intel-extension-for-pytorch | A Python package for extending the official PyTorch that can easily obtain performance on Intel platform |
| sci-libs/miopen | AMD's Machine Intelligence Library |
| sci-libs/miopengemm | An OpenCL general matrix multiplication (GEMM) API and kernel generator |
| sci-libs/miopenkernels | Prebuilt kernels to reduce startup latency |
| sci-libs/onnxruntime | Cross-platform inference and training machine-learning accelerator. |
| sci-libs/openvino | OpenVINO™ is an open-source toolkit for optimizing and deploying AI inference |
| sci-libs/pytorch | Tensors and Dynamic neural networks in Python |
| sci-libs/rocAL | The AMD rocAL is designed to efficiently decode and process images and videos from a variety of storage formats and modify them through a processing graph programmable by the user. |
| sci-libs/rocALUTION | Next generation library for iterative sparse solvers for ROCm platform |
| sci-libs/rocBLAS | AMD's library for BLAS on ROCm |
| sci-libs/rocDecode | rocDecode is a high performance video decode SDK for AMD hardware |
| sci-libs/rocFFT | Next generation FFT implementation for ROCm |
| sci-libs/rocMLIR | MLIR-based convolution and GEMM kernel generator for ROCm |
| sci-libs/rocPRIM | HIP parallel primitives for developing performant GPU-accelerated code on ROCm |
| sci-libs/rocRAND | Generate pseudo-random and quasi-random numbers |
| sci-libs/rocSOLVER | Implementation of a subset of LAPACK functionality on the ROCm platform |
| sci-libs/rocSPARSE | Basic Linear Algebra Subroutines for sparse computation |
| sci-libs/rocThrust | HIP back-end for the parallel algorithm library Thrust |
| sci-libs/rocWMMA | AMD's C++ library for accelerating mixed-precision matrix multiply-accumulate (MMA) operations leveraging AMD GPU hardware |
| sci-libs/rpp | AMD ROCm Performance Primitives (RPP) library is a comprehensive high-performance computer vision library for AMD processors with HIP/OpenCL/CPU back-ends. |
| sci-libs/tensorflow | Computation framework using data flow graphs for scalable machine learning |
| sci-libs/tensorflow-estimator | A high-level TensorFlow API that greatly simplifies machine learning programming |
| sci-libs/tensorflow-hub | Clean up the public namespace of your package! |
| sci-libs/tensorflow-io | Dataset, streaming, and file system extensions maintained by TensorFlow SIG-IO |
| sci-libs/tensorflow-metadata | Utilities for passing TensorFlow-related metadata between tools |
| sci-libs/tensorflow-probability | Probabilistic reasoning and statistical analysis in TensorFlow |
| sci-libs/tensorflow-text | Text processing in TensorFlow |
| sci-libs/tensorstore | Library for reading and writing large multi-dimensional arrays |
| sci-libs/tf-slim | TensorFlow-Slim: A lightweight library for defining, training and evaluating complex models in TensorFlow |
| sci-libs/torchaudio | Data manipulation and transformation for audio signal processing, powered by PyTorch |
| sci-libs/torchmetrics | PyTorch native Metrics |
| sci-libs/torchvision | Datasets, transforms and models to specific to computer vision |
| sci-libs/transformers | State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow |
| sci-misc/kineto | A CPU+GPU Profiling library that provides access to timeline traces and hardware performance counters |
| sci-misc/nnef-models | The NNEF model zoo |
| sci-misc/tensorflow-datasets | TFDS is a collection of datasets ready to use with TensorFlow, Jax, ... |
| sci-misc/tf-models-official | Models and examples built with TensorFlow |
| sci-physics/bullet | Continuous Collision Detection and Physics Library |
| sci-physics/mujoco | MuJoCo (Multi-Joint dynamics with Contact) is a general purpose physics simulator. |
| sci-visualization/tensorboard | TensorFlow's Visualization Toolkit |
| sci-visualization/tensorboard-data-server | Fast data loading for TensorBoard |
| sci-visualization/tensorboard-plugin-profile | Clean up the public namespace of your package! |
| sci-visualization/tensorboard-plugin-wit | What-If Tool TensorBoard plugin |
| sci-visualization/tensorboardx | TensorBoardX lets you watch tensors flow without TensorFlow |
| sys-apps/c2tcp | C2TCP: A Flexible Cellular TCP to Meet Stringent Delay Requirements. |
| sys-apps/cellular-traces-nyc | Cellular Traces Collected in New York City for different scenarios |
| sys-apps/cellular-traces-y2018 | Cellular Traces Collected in New York City for different scenarios |
| sys-apps/coolercontrol | Cooling device control for Linux |
| sys-apps/coolercontrol-liqctld | liqctld is a daemon for interacting with liquidctl on a system level |
| sys-apps/coolercontrol-ui | coolercontrol-ui is the new UI for coolercontrol using Tauri, GTK 3, Rust, Vue 3, webkit2gtk |
| sys-apps/coolercontrold | coolercontrold is the main daemon containing the core logic for interfacing with devices |
| sys-apps/deepcc | DeepCC: A Deep Reinforcement Learning Plug-in to Boost the performance of your TCP scheme in Cellular Networks! |
| sys-apps/finit | Fast init for Linux. Cookies included |
| sys-apps/finit-d | finit.d/*.conf files for the Finit init system |
| sys-apps/firejail | Security sandbox for any type of processes |
| sys-apps/lact | Linux AMDGPU Controller |
| sys-apps/npm | The package manager for JavaScript |
| sys-apps/oomd | A customizable Out-Of-Memory (OOM) killer for userspace |
| sys-apps/orca | Orca: Towards Mastering Congestion Control In the Internet |
| sys-apps/pnpm | Fast, disk space efficient package manager |
| sys-apps/yarn | Fast, reliable, and secure dependency management. |
| sys-auth/pam-python | Enables PAM modules to be written in Python |
| sys-cluster/knem | High-Performance Intra-Node MPI Communication |
| sys-cluster/openmpi | A high-performance message passing library (MPI) |
| sys-cluster/rdc | The ROCm™ Data Center Tool simplifies the administration and addresses key infrastructure challenges in AMD GPUs in cluster and datacenter environments. |
| sys-cluster/ucx | Unified Communication X is a network High Performance Computing (HPC) framework |
| sys-cluster/xpmem | XPMEM is a Linux kernel module that enables a process to map the memory of another process into its virtual address space. |
| sys-devel/DPC++ | oneAPI Data Parallel C++ compiler |
| sys-devel/aocc | The AOCC compiler system |
| sys-devel/clang | C language family frontend for LLVM |
| sys-devel/clang-common | Common files shared between multiple slots of clang |
| sys-devel/clang-ocl | OpenCL compilation with the Clang compiler |
| sys-devel/clang-runtime | Meta-ebuild for clang runtime libraries |
| sys-devel/clang-toolchain-symlinks | Symlinks to use Clang on a GCC-free system |
| sys-devel/lld | The LLVM linker (link editor) |
| sys-devel/lld-toolchain-symlinks | Symlinks to use LLD on a binutils-free system |
| sys-devel/llvm | Low Level Virtual Machine |
| sys-devel/llvm-common | Common files shared between multiple slots of LLVM |
| sys-devel/llvm-roc | The ROCm™ fork of the LLVM project |
| sys-devel/llvm-roc-alt | AOCC for ROCm™ |
| sys-devel/llvm-roc-alt-symlinks | llvm-roc-alt symlinks |
| sys-devel/llvm-roc-symlinks | llvm-roc symlinks |
| sys-devel/llvm-toolchain-symlinks | Symlinks to use LLVM on a binutils-free system |
| sys-devel/llvmgold | LLVMgold plugin symlink for autoloading |
| sys-devel/mlir | Multi Level Intermediate Representation for LLVM |
| sys-devel/mold | A Modern Linker |
| sys-firmware/amdgpu-dkms-firmware | Firmware blobs used by the amdgpu kernel driver |
| sys-fs/ecryptfs-utils | eCryptfs userspace utilities |
| sys-kernel/genkernel | Gentoo automatic kernel building scripts |
| sys-kernel/gostcrypt-linux-crypto | GOST algorithms implementation for Linux Crypto subsystem |
| sys-kernel/mitigate-dos | Enforce Denial of Service mitigations |
| sys-kernel/mitigate-dt | Enforce Data Tampering mitigations |
| sys-kernel/mitigate-id | Enforce Information Disclosure mitigations |
| sys-kernel/pcc | Performance-oriented Congestion Control |
| sys-kernel/rock-dkms | ROCk DKMS kernel module |
| sys-kernel/rock-dkms.bak | ROCk DKMS kernel module |
| sys-libs/compiler-rt | Compiler runtime library for clang (built-in part) |
| sys-libs/compiler-rt-sanitizers | Compiler runtime libraries for clang (sanitizers & xray) |
| sys-libs/libbacktrace | C library that may be linked into a C/C++ program to produce symbolic backtraces |
| sys-libs/libcxx | New implementation of the C++ standard library, targeting C++11 |
| sys-libs/libcxxabi | Low level support for a standard C++ library |
| sys-libs/libomp | OpenMP runtime library for LLVM/clang compiler |
| sys-libs/llvm-libunwind | C++ runtime stack unwinder from LLVM |
| sys-libs/llvm-roc-libomp | The ROCm™ fork of LLVM's libomp |
| sys-libs/pstl | Parallel STL is an implementation of the C++ standard library algorithms with support for execution policies |
| sys-libs/zlib | Standard (de)compression library |
| sys-power/cpupower-gui | This program is designed to allow you to change the frequency limits of your cpu and its governor similar to cpupower. |
| sys-process/nvtop | GPU & Accelerator process monitoring |
| sys-process/psdoom-ng | A First Person Shooter (FPS) process killer |
| virtual/blender-lts | Virtual for Blender LTS |
| virtual/blender-stable | Virtual for Blender stable |
| virtual/kfd | Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module |
| virtual/linux-sources | Virtual for Linux kernel sources |
| virtual/ot-sources-lts | Virtual for the ot-sources LTS ebuilds for |
| virtual/ot-sources-stable | Virtual for the ot-sources stable ebuilds |
| virtual/pillow | Virtual for python pillow packages |
| virtual/tmpfiles | Virtual to select between different tmpfiles.d handlers |
| www-apps/xpra-html5 | HTML5 client for Xpra |
| www-client/chromium | The open-source version of the Chrome web browser |
| www-client/chromium-sources | Chromium sources |
| www-client/chromium-toolchain | The Chromium toolchain (Clang + Rust + gn) |
| www-client/firefox | Firefox Web Browser |
| www-client/surf | a simple web browser based on WebKit/GTK+ |
| www-misc/ddgr | DuckDuckGo from the terminal |
| www-misc/mahimahi | Web performance measurement toolkit |
| www-misc/socli | A search and browse Stack Overflow command line terminal client |
| www-servers/civetweb | CivetWeb is an embedded C++ web server |
| x11-libs/cairo | A vector graphics library with cross-device output support |
| x11-libs/startup-notification | Application startup notification and feedback library |
| x11-misc/aprs-symbols | aprs.fi APRS symbol set, high-resolution, vector |
| x11-misc/sddm | Simple Desktop Display Manager |
| x11-misc/xsnow | Let it snow on your desktop and windows |
| x11-themes/paper-icon-theme | Paper Icon Theme |
| x11-wm/dwm | A dynamic window manager for X11 |
| x11-wm/xpra | X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy |

### Contributing ebuilds

See [CONTRIBUTING.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/CONTRIBUTING.md)
