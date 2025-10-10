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

* 2025-01-16 - [Rotate passwords immediately](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2025-01-16-rotate-passwords/2025-01-16-rotate-passwords.txt)
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

See [SECURITY.md](SECURITY.md)

### 2025 policy

(Draft)

#### gcc_slot_* changes

The overlay introduces the gcc_slot_* USE flag prefix.  This USE flag set is
designed to solve the GLIBCXX version symbols issues during the linking phase.
It is safe to use the lowest gcc_slot_* prefixed listed, but there is a risk
that the distro may hard mask that GCC compiler then you will end up rebuilding
all the affected GCC packages.  It is recommended to use a LTS slot that has
the upper version limit bounded by the GPU package.  If no GPU, then it is 
recommended to use the latest LTS USE flag (U24), since this distro tends to
be compatible with the latest distro versions (F42, U24, D13) and
accelerationist-deletionist towards older releases.  Only slots supported by
the GPUs will be made available for this USE prefix.

It was discovered that manually setting the gcc through `eselect gcc` is the
most reliable way to resolve GLIBCXX_ version symbols linking issue.  Using
per-package environment changes to CC/CXX did not resolve the issue.  For
systemwide upgrades and downgrades of the default libstdc++, the parallel
package builds should be disabled.  After the system has been sanitized with
the same libstdc++, you can re-enable parallel package builds.  Per-package
changes to CC/CXX using gcc override should be removed for ebuild packages
that received libstdcxx-slot treatment to avoid inconsistency.  Changes to
CC/CXX using clang can still remain.

| USE flag       | LTS [1] | Indirect libstdc++ compatibility                                                                                              | Default C++     |
|----------------|---------|-------------------------------------------------------------------------------------------------------------------------------|-----------------|
| gcc_slot_11_5  | Yes     | U22 (EOL 2027), CUDA 11.8, CUDA 12.3, CUDA 12.4, CUDA 12.5, CUDA 12.6, CUDA 12.8, CUDA 12.9                                   | C++17           |
| gcc_slot_12_5  | No      | D12 (EOL 2028), F37, CUDA 12.3, CUDA 12.4, CUDA 12.5, CUDA 12.6, CUDA 12.8, CUDA 12.9, ROCm 6.2, ROCm 6.3, ROCm 6.4, ROCm 7.0 | C++17           |
| gcc_slot_13_4  | Yes     | U24 (EOL 2036), CUDA 12.4, CUDA 12.5, CUDA-12.6, CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0                                     | C++17           |
| gcc_slot_14_3  | No      | D13 (EOL 2030), F41, CUDA 12.8, CUDA 12.9                                                                                     | C++17           |

| USE flag [3]   | LTS [1] | Indirect libc++ compatibility                                                                                                 | Default C++ [2] |
|----------------|---------|-------------------------------------------------------------------------------------------------------------------------------|-----------------|
| llvm_slot_18   | Yes     | U24                                                                                                                           | C++17           |
| llvm_slot_19   | No      | D13                                                                                                                           | C++17           |

EOL dates should be taken with a gain of salt because this distro only respects
the latest release of the other distros.  The main distro repo will delete or
break support for a core component (e.g. Python) so full support for an older
LTS version is unreliable.

[1] The LTS support for these USE flags are arbitrary chosen by this overlay.
It is based on feature completeness (aka full version) and public proclamation
of LTS.  Alternatively, you may use the EOL date as your preferred metric.  U22,
D12, U24, D13 are considered LTS by AI.

[2] The libc++ requires to be built with -std=c++23, but can link
userland to -std=c++17.  The -std=c++17 is determined by either the userland
program or the default setting in the Clang program itself.

[3] There are fewer slots supported because of the manifest update ban of
Python 3.10 by the distro's python-utils-r1 eclass and the distro community
removal of markings for Python 3.10 support in PYTHON_COMPAT.  Only full access
Python will be made available on this overlay.  The older Python is necessary
for QA testing for both the Clang compiler and downstream projects but denied by
the distro.  The distro's manifest ban is bad because it goes against the spirit
of the GPL with the right to hack.

Consider the following release cycles when choosing a mutually exclusive
gcc_slot_*:

* CUDA 11.x - LTS (Long Term Support)
* CUDA 12.x - Rolling release cycle
* ROCm - Rolling release cycle

While the older GPU package versions may not be available on overlays, they
may be used by containerized programs.  Older containerized programs may require
an older gcc_slot_* slot.

If the libstdc++ version symbols doesn't change on minor version bump (e.g. from
gcc_slot_13_4 to gcc_slot_13_5), then the flag will stay the same to avoid
unnecessary rebuilds.  The compatibility is based on the mysterious GLIBCXX_
version but presented using the familiarly discussed GCC version.

To use it you may specify it either in your /etc/portage/make.conf or apply it per-package.

Either:

```
# Sample contents of /etc/portage/make.conf:
GCC_SLOT="11_5"
```

or

```
# Sample contents of /etc/portage/env/gcc_slot_11_5.conf:
GCC_SLOT="11_5"
```

```
# Sample contents of /etc/portage/package.env:
media-gfx/blender gcc_slot_11_5.conf
```

or

```
# Sample contents of /etc/portage/package.use/blender:
media-gfx/blender gcc_slot_11_5
```

#### Hardening changes

This overlay will force hardening always on to mitigate against some zero click
attacks.

These default hardening flags have an estimated worst case performance penalty
around 1.35 times the base performance without mitigation which is similar to
-O1 at -40% best case performance penalty relative to -O3 or -Ofast.

Packages are relatively adjusted for CFLAGS_HARDENED_TOLERANCE so that in
packages can be properly secured mitigating repeating past mistakes.
ASan/HWASan/GWP-ASan will be required.  Packages with historical CVE reputation
of heap overflows or use after free will be ASan-ed.  Packages with historical
CVE reputation for integer overflows or bounds issues will get UBSan treatment.
The -fstack-protector does not mitigate heap overflow.

| CFLAGS_HARDENED_TOLERANCE | Package security posture                  | Inherits cflag-hardened or rustflags-hardened eclass
| ----                      | ----                                      | ----
| 1.10 or less              | Performance-critical                      | No
| 1.11-1.50                 | Balanced                                  | Maybe
| 1.35                      | Balanced default to enable Retpoline      | Yes
| 1.80 or more              | Security-critical                         | Yes
| 4.0                       | Security-critical default to enable ASan  | Yes

How to interpret the above table:

- 1.0 means fully performance optimized as -Ofast/-O3 and unmitigated.
- 1.10 means performance-critical like -O2.
- 1.11 means 1.11 times slower than the base performance.  This is the best case balanced performance.
- 1.40 means like -O0 at its best case.
- 1.50 means 1.50 times slower than the base performance.  This is the worst case balanced performance.
- 1.51 to 1.79 means declining performance and additional decent mitigations may be applied.
- 4.0 means 4 times worst case slower than the base performance but enable expensive mitigations against critical severity vulnerabilities/exploits.
- Setting CFLAGS_HARDENED_TOLERANCE_USER means that you are accepting or managing
  the worst case performance as a result of hardening.
- The values are normalized float multiples relative to the base.
- In the above table, ASan means any ASan flavor (ASan, GWP-ASan, HWASan).
- The ASan/UBSan will be allowed if it passes the test suite or passes an
  interactive test.  The test suite has a higher precedence to decide
  if it should be disabled.

For packages marked sensitive-data, there are consideration of adding wrapper to
use a secure heap allocator (scudo, hardened_malloc, etc) for secure erase of
sensitive data from memory on dealloc.

Users can override the tolerance level by changing
CFLAGS_HARDENED_TOLERANCE_USER.  Details about what runtime mitigations will be
activated can be found at
[cflags-hardened.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/cflags-hardened.eclass#L123).

CFLAGS_HARDENED_TOLERANCE_USER and RUSTFLAGS_HARDENED_TOLERANCE_USER mean the
same, but not necessary one affecting the other.

If a package is ASan-able, the *flags-hardened eclass will dedupe the
overlapping check to prevent double checking stack overflow.  If a package is
UBSan-able, it will dedupe the overlapping signed integer check to avoid double
checking signed overflow.

| Flag               | Heap overflow mitigation | Stack overflow mitigation |
| ----               | ----                     | ----                      |
| -fstack-protector  | No                       | Yes                       |
| -fsanitize=address | Yes                      | Yes                       |

Heap overflow is implied ranked higher than stack overflow for vulnerabilities
reported on the Top 25 list of vulnerabilities classes.  -fstack-protector*
is a pre-2014 mitigation.  For 2025, hardened allocators, sanitizers, MTE are
preferred for the security-critical perimeter.

| Flag                 | Signed integer overflow mitigation | Unsigned integer overflow mitigation |
| ----                 | ----                               | ----                                 |
| -ftrapv              | Yes                                | No                                   |
| -fsanitize=undefined | Yes                                | Yes                                  |

Integer overflow is typically associated with signed integer overflow.

When does a package meet performance critical?  If it is not marked
cflags-critical or rustflags-critical.

The hardening benefits will include some execution-integrity mitigations,
some information disclosure mitigations, some denial of service
mitigations, and some data tampering mitigations.

Execution-integrity mitigations with LLVM CFI (and CET or PAC) will mitigate
against some unauthorized transactions in trusted compiled code.   If you have
CET or PAC, you can ignore the LLVM CFI requirement.  The LLVM CFI
requirement in this overlay only applies to ARCH=amd64 users without CET.

This overlay will set LLVM CFI default off.  Then, it will prioritize candidate
packages individually for those where costly or devastating unauthorized
transactions could take place.  Then, it will slow evaluate each candidate
package for LLVM CFI mitigation enablement.

The not safe for production sanitizers will default to opt-in in this overlay to
decrease the success chances for vulnerability scanning.  Users can choose to
opt-out and follow upstream's opt-out performance-first security posture.
However, there are trade-offs.  Many of the sanitizers mitigate a combination of
Code Execution (CE), Privilege Escalation (PE), Denial of Service (DoS), Data
Tampering (DT), Information Disclosure (ID) during runtime.  It is not clear why
it was an issue but the LLM did explain it clearly.  You should ask the AI.  I
don't disclose it here for security reasons.  Users can opt-out by setting
CFLAGS_HARDENED_TOLERANCE_USER to a lower multiple to exclude them.  This
opt-in/opt-out is a Faustian bargain.  If you opt-in, you lose.  If you opt-out,
you lose.  For opt-out, you accept many vulnerabilities with full & partial
attacker capabilities + performance increase.  For opt-in, you accept ID
leading to 1 concerning full attacker capabilities vulnerability + performance
penalty.  There are several non production sanitizers that have this issue.
There is a disable logging workaround to mitigate the latter case.

The UBSan minimal runtime will be default on in this overlay for hardened marked
packages.  UBSan will protect against some of each CE, PE, DoS, DT, ID before
they happen.  Only a few vulnerabilities will be blocked on the top 50
vulnerabilities reported per month ranking.

The HWASan will be optional but secure-critical may consider enabling this
sanitizer since many top 50 vulnerabilities reported per month rankings will be
mitigated.  To enable it, set CFLAGS_HARDENED_TOLERANCE_USER=3.0 for ARCH=amd64
or CFLAGS_HARDENED_TOLERANCE_USER=1.5 for ARCH=arm64.  For ARCH=amd64, this is
about -O0 worst case with heavy swapping.  For ARCH=arm64, this is about -O0
best case with light swapping to no swapping.

To get the vulnerabilities reported per month ranking, ask the AI/LLM this:

Give me the top 50 vulnerabilities with corresponding temperature based on
reported vulnerabilities per month sorted by reported vulnerabilities per month
and another column that list the corresponding llvm sanitizer to stop the
vulnerability. Allow for multiple sanitizer possibilities so that HWASan can be
used when just ASan presented. Give me the full list. The temperature should use
red, orange, yellow, blue. I only want the vulnerabilities from now to previous
year. The vulnerabilities should be deduped and unique only one cwe per row.
After that list is generated, create a separate list listing the statistical
frequency of sanitizers used in the first table and sort that bottom list by
frequency.

To get a nice table of vulnerability protection per sanitizer, ask the AI/LLM this:

Give me a y, n, n/a table of what would be protected for code execution,
privilege escalation, data tampering, information, denial of service for all of
the llvm sanitizers.  Also include performance impact as a normalized decimal
multiple per each sanitizer.  Also include llvm's status as y, n, n/a for
production use.  Also include practioners' y, n, n/a endorsement for production
use.  Also include minimum llvm runtime sanitizer implementations like
-fsanitize-minimal-runtime.  Give me the performance impacts for both amd64 and
arm64 and as a best case and worst case.

To get a nice table of vulnerability protection per `<flag>`, ask the AI/LLM this:

Give me a y, n, n/a table of what would be protected against for code execution,
privilege escalation, data tampering, information disclosure, denial of service
for `<flag>`.  Also include performance impact as a normalized decimal multiple.
Give me the performance impacts for both amd64 and arm64 and as a best case and
worst case.


While it may upset minimalists, this forced mitigation may prevent some classes
of real world cost loss.

The classes of software that will be forced hardening on can be found at
[cflags-hardened.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/cflags-hardened.eclass#L186)
under the CFLAGS_HARDENED_USE_CASES.  This class and the rustflags-hardened
eclass have @USER_VARIABLE marked environment variables which can be placed
as a [per-package env configuration](https://wiki.gentoo.org/wiki//etc/portage/package.env)
or in [/etc/portage/make.conf](https://wiki.gentoo.org/wiki//etc/portage/make.conf).

The overlay will fork some distro ebuilds to apply the `cflags-hardended`
and `rustflags-hardened` mitigations since the distro ebuilds do not do
a good job verifying that mitigations are applied to security-critical
packages.

The requirement is based partly on the overlay's maintainer shift towards a
more defensive posture on cybersecurity.

##### -D_FORTIFY_SOURCE integrity re-evaluated

-D_FORTIFY_SOURCE provides stack overflow and heap overflow protection for str*,
and mem* functions for packages that use GLIBC.  If compromised or not applied
carefully, it may result in a critical severity vulnerability.

-D_FORTIFY_SOURCE is like the poor man's version of ASan but limited to these
cases and not comprehensive memory corruption mitigation.  It is the fallback
when ASan cannot be applied.

###### Extra flags added fix lost fortify source integrity

When -O1, -O2, -O3 is added, -D_FORTIFY_SOURCE's integrity may be compromised.

This overlay applies 3 sets of flags to ensure that the integrity of fortify source
checks and thunks are not compromised by compiler optimizations.

* Set 1 for trusted secure data packages.  95% Coverage
* Set 2 for practical security-critical packages.  99 Coverage
* Set 3 for theoretical security-critcal packages.  ~99 Coverage

Medium severity without sanitizers + SSP-strong,  Low severity with ASan + UBSan + SSP-strong

Doesn't -O flags achieve the same thing?  Yes but it doesn't give the fine
grained control compared to these sets.  The set is selected to counter the most
prevalent compromises with the most effectiveness.  With the -O flags, it
doesn't necessary follow that order.

###### BOLT/PGO is here stay in cflags-hardened contexts

There was some thought to remove BOLT/PGO in packages marked with
cflags-hardened to eliminate a source of -D_FORTIFY_SOURCE integrity loss.
After hearing the perspectives, it was decided it can stay.  BOLT and PGO will
still be a user choice.  It is not clear which opinion is correct and the most
secure.

There are two narratives in this Faustian bargain.

* PGO/BOLT will increase the attack complexity lowering the CVSS score.  The
  mitigation drops to almost half the CVSS score when complexity increased in
  this narrative.
* PGO/BOLT will compromise the integrity of -D_FORTIFY_SOURCE checks or thunks.
  It may override/undo the above Sets.  It may even prune the critical
  vulnerability check or thunk function.  When you remove the Set, you are
  allowing the attacker to do code execution and not halting it as intended.
  The CVSS score maybe drops a quarter in this narrative but estimated to be
  high severity.

###### CFI is optional on untested arches

While it may be ideal to auto opt-in into CFI, it is not so easy and straightforward
based on past experience.  This is why it was decided to make it optional
especially for untested ARCHes.  The worst case possible scenario is that it
can break the entire toolchain which makes it very risky especially with LLVM CFI.

Environment variables that control CFI.  New user environment variables for
cflags-hardened and rustflags-hardened.

* CFLAGS_HARDENED_SANITIZERS_DISABLE_USER - Per-package disable sanitizers for C/C++ packages.
* RUSTFLAGS_HARDENED_SANITIZERS_DISABLE_USER - Per-package disable sanitizers for Rust packages.

The above flag if set to 1 will disable sanitizers for a package.

```
Examples:

Contents of /etc/portage/env/disable-sanitizers.conf:
CFLAGS_HARDENED_SANITIZERS_DISABLE_USER=1
RUSTFLAGS_HARDENED_SANITIZERS_DISABLE_USER=1

Contents of /etc/portage/env/package.env:
dev-libs/libxml2 disable-sanitizers.conf

```

* CFLAGS_HARDENED_AUTO_SANITIZE_USER - Add ASan, LLVM CFI, TSan, UBSan for C/C++ packages.
* CFLAGS_HARDENED_ARM_CFI_USER - Add -mbranch-protection for C/C++ packages.
* CFLAGS_HARDENED_BTI_USER - Add BTI support for C/C++ packages.
* CFLAGS_HARDENED_CF_PROTECTION_USER - Add -fcf-protection for C/C++ packages.
* CFLAGS_HARDENED_FHARDENED_USER - Add -fhardened for C/C++ packages.
* CFLAGS_HARDENED_MTE_USER - Add MTE support for C/C++ packages.
* CFLAGS_HARDENED_PAC_USER - Add PAC support for C/C++ packages.

* RUSTFLAGS_HARDENED_ARM_CFI_USER - Add -mbranch-protection for Rust packages.
* RUSTFLAGS_HARDENED_AUTO_SANITIZE_USER - Add ASan, LLVM CFI, TSan, UBSan for C/C++ packages.
* RUSTFLAGS_HARDENED_BTI_USER - Add BTI support for Rust packages.
* RUSTFLAGS_HARDENED_CF_PROTECTION_USER - Add -fcf-protection for Rust packages.
* RUSTFLAGS_HARDENED_MTE_USER - Add MTE support for Rust packages.
* RUSTFLAGS_HARDENED_PAC_USER - Add PAC support for Rust packages.

The above flags accept 1, 0, or unset.  By default CFI is opt-out (0) and
retpoline is default opt-in (1).

* CFLAGS_HARDENED_AUTO_SANITIZE_USER - Select between `asan`, `cfi`, `hwasan`, `lsan`, `msan`, `scs`, `tsan`, `ubsan` for C/C++ programs.
* CFLAGS_HARDENED_PROTECT_SPECTRUM_USER - Select between `arm-cfi`, `cet`, `llvm-cfi`, `retpoline`, `none` for C/C++ programs.
* RUSTFLAGS_HARDENED_AUTO_SANITIZE_USER - Select between `asan`, `cfi`, `hwasan`, `lsan`, `msan`, `scs`, `tsan`, `ubsan` for Rust programs.
* RUSTFLAGS_HARDENED_PROTECT_SPECTRUM_USER - Select between `arm-cfi`, `cet`, `llvm-cfi`, `retpoline`, `none` for Rust programs.

The *FLAGS_HARDENED_PROTECT_SPECTRUM_USER options can be used to optimize
security for either confidentiality or for execution-integrity on a per-package
basis or override the auto selected option.  `retpoline` is associated with
confidentiality.  `arm-cfi`, `cet`, `llvm-cfi` are associated with
execution-integrity or anti execution hijack.  If you do not select, it will
automatically decide based on the vulnerability history of the package and how
it processes sensitive or untrusted data.  So if a package has memory corruption,
it is likely to choose either `cet`, `arm-cfi`, `llvm-cfi`.  If the package only
handles sensitive data, has past vulnerability history of uninitalized memory,
or has only support for retpoline will automatically choose `retpoline`.  If a
package handles both untrusted data and sensitive data, it will prioritize CFI
otherwise retpoline.  These options are mutually exclusive so you can only choose
one on the protect spectrum.  This is another Faustian bargan.  If you choose
`retpoline` you are vulnerable to JOP/ROP attack.  If you choose ROP/JOP, you are
vulnerable to Spectre v2 attack.  If you choose `none` to disable both CFI and
Repoline, you are vulnerable to both ROP/JOP and Spectre v2 attack.

A compromised execution-integrity is more dangerous than compromised
confidentiality because it can do impersonation or increase attacker capabilties.
If an attacker compromised execution-integrity, then it can also lead to
compromised confidentiality, run attacker code, and irreversable damage.

For `llvm-cfi` using `RUSTFLAGS_HARDENED_LLVM_CFI_USER` doesn't automatically
allow you to use it.  The package must be marked and tested with
`RUSTFLAGS_HARDENED_LLVM_CFI=1` before it can be used.

```
Examples:

Contents of /etc/portage/make.conf
CFLAGS_HARDENED_AUTO_SANITIZE_USER="asan ubsan"
CFLAGS_HARDENED_FHARDENED_USER=1
CFLAGS_HARDENED_SANITIZER_CC_NAME="gcc"
CFLAGS_HARDENED_SANITIZER_CC_SLOT=13
DETECT_COMPILER_SWITCH_LTO_CC_NAME="gcc"
DETECT_COMPILER_SWITCH_LTO_CC_SLOT=13
RUSTFLAGS_HARDENED_AUTO_SANITIZE_USER="asan ubsan"
RUSTFLAGS_HARDENED_SANITIZER_CC_NAME="gcc"
RUSTFLAGS_HARDENED_SANITIZER_CC_SLOT=13

Contents of /etc/portage/env/libxml.conf
CFLAGS_HARDENED_FHARDENED_USER=0
CFLAGS_HARDENED_CF_PROTECTION_USER=1
CFLAGS_HARDENED_TOLERANCE_USER="2.0"

Contents of /etc/portage/env/mesa.conf
CFLAGS_HARDENED_TOLERANCE_USER="1.0"

Contents of /etc/portage/env/package.env:
dev-libs/libxml2 libxml2.conf
media-libs/mesa mesa.conf

```

For eclass documentation, see the options marked `@USER_VARIABLE` in
* [check-compiler-switch.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/check-compiler-switch.eclass)
* [cflags-hardened.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/cflags-hardened.eclass)
* [rustflags-hardened.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/rustflags-hardened.eclass)

Why environment variables over per-package cflags?  Because the eclasses have
scripting capabilities, but the per-package env files do not have this
capabilities and are typically static not dynamically applied.  The eclasses are
more consistent when applying per-package cflags.  The coverage is also increased
as more packages are reviewed and more metatags are added.  The eclasses also can
take advantage of other environment variables that act like metadata or use hints
to apply hardening.  The eclasses/ebuilds can be modified to add more hints to
improve auto applying CFI flags or to minimize build time failures.

##### Requirements

```
sys-devel/gcc[sanitize,vtv]
sys-devel/llvm
sys-devel/clang
sys-devel/lld
llvm-runtimes/compiler-rt
llvm-runtimes/compiler-rt-sanitizers-logging[production]

# Choose one for ASan/UBSan sanitizers support for Rust
# The -Zsanitizer option is only available for live ebuilds
=dev-lang/rust-9999
=dev-lang/rust-bin-9999

# For ARCH=amd64
llvm-runtimes/compiler-rt-sanitizers[asan,cfi,gwp-asan,ubsan,safestack]

# For ARCH=arm64
llvm-runtimes/compiler-rt-sanitizers[asan,hwsan,gwp-asan,ubsan,safestack]
```

They are required because it assumed that the vulnerability is unpatched and
the fix require these features to be present.

In addition, ARCH=amd64 users without CET must build and rebuild all packages
that use LTO with Clang or disable selectively LTO in to prevent building or
linking issues when LLVM CFI is being used.  LLVM CFI requires LTO to work.
There may be issues with static-libs.  If problems are encountered with
static-libs, the package should either disable static-libs or the static-libs
recompiled with with Clang only.  This is to prevent any link-time issues or
intermediate representation (IR) or LTO bytecode incompability since LTO will
use that information to IPO optimize (or finish compiling) in link phase.  The
eclass will require that -ffat-lto-objects be not used to speed up linking
and lower the size cost.  It will transfer two representations to the HDD, so
it is like worst case double the copy time with -ffat-lto-objects when
transfering the library which could be like for the static-library 1GB
without LTO and 2GB with LTO -ffat-lto-objects.

ASLR must be enabled for mitigation for sanitizers to prevent a critical
severity vulnerability.  These checks are verified in the compiler-rt-sanitizers
ebuild.

Users must use the same default compiler vendor when a package is using
sanitizers systemwide.  It is suggested by the AI/LLMs that you cannot mix GCC
sanitizers with LLVM sanitizers on the same package/project.  The overlay
maintainer opinion about mixing is to avoid the possibility symbol collsion
with wrong signatures in static-libs using different vendors.  The ebuilds
manage it with CFLAGS_HARDENED_SANITIZERS_COMPAT and eclass assist.  The users
must choose only one default compiler vendor via CC and CXX and discourage
switching between vendors via per-package flags for LTO, CFI, ASan, UBSan, etc.

##### Troubleshooting

###### Run failure #1 or broken decrypted login

A broken login may be encountered and cause a profile not to decrypt home as a
result of broken simultaneously use of ASan and UBSan with curl.

If an ASan-ed curl gets updated, it may complain with:

```
==<id>==ASan runtime does not come first in initial library list; you should either link runtime to your application or manually preload it with LD_PRELOAD.
```

Try doing a `source /etc/profile` to fix the issue temporarily.

Try emerging curl from this overlay with the fix or use the distro curl instead
for the permanent fix.


###### Run failure #2

If missing ASan or UBSan symbols are encoutered in the build system toolchain,
replace the broken shared library or executable using the distro tarball.

Only a few packages are affected

- app-misc/jq
- net-misc/curl
- dev-libs/jemalloc
- dev-libs/jemalloc-usd
- dev-libs/libpcre2
- dev-libs/libtasn1
- dev-libs/nxjson
- dev-libs/pugixml

The issue has been fixed by linking statically with the sanitizer libraries.
While the packages above were tested thoroughly with the test suite with
intra-package self testing, bugs in inter-package integration testing between
packages will appear randomly and unexpectedly.  This is why a slow rollout for
ASan-ed and UBSan-ed packages are used to catch inter-package bugs easily for
packages that may affect the @system set.  It is preferred to avoid
ASan-ing/UBSan-ing the @system set to avoid an unfixable @system or the compiler
toolchain, but it is not obvious sometimes if a package will affect @system.

###### Breaking Qt based packages at configure time

You can either make a copy of the ebuild to your local overlay and modify the
ebuild to set abort_on_error=0 for ASan and halt_on_error=0 for UBSan in
configure time check for ASAN_OPTIONS and UBSAN_OPTIONS environment variables.
Then, for src_test() make both variables 1.

or

Disable sanitizers for dev-libs/libpcre2 package with the following...

The CFLAGS_HARDENED_SANITIZERS_DEACTIVATE=1 and
RUSTFLAGS_HARDENED_SANITIZERS_DEACTIVATE=1 can be used to turn off sanitizers on
a per-package basis.  Some packages force using gcc or llvm to get the package
built and as a result force sanitizers on when they should be disabled.  These
per-package flags can be used to avoid incompatibility problems.  Add the flag
to the package and then rebuild the problematic package or deep dependency
causing the problem.

###### Missing ASan symbols with Flatpak because of missing ASan symbols in curl

You may get an error with sys-apps/flatpak interaction with broken linked curl.
Delete /usr/bin/flatpak, re-emerge curl without ASan with per-package env containing
CFLAGS_HARDENED_SANITIZERS_DEACTIVATE=1 or with fixed cflags-hardened eclass with
changes linking to just the static library not shared ASan library.  Re-emerge
sys-apps/flatpak.

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

## Packages

<!--
Autogenerated from:

for x in $(grep -l -e "^DESCRIPTION" $(find . -name "*ebuild")) ; do d=$(cat "${x}" | tr '\n' ' ' | tr '\\\\' ' ' | grep -o -E "DESCRIPTION=\"[^\"]+" | cut -f 2 -d '"'); atom=$(echo "${x}" | cut -f 2-3 -d "/"); echo "| ${atom} | ${d} |" ; done | sort | uniq | sed -r -e "s|[ ]+| |g"
-->

| package | description |
| --- | --- |
| acct-group/lobe-chat | A group for Lobe Chat |
| acct-group/local-ai | A group for LocalAI |
| acct-group/ollama | A group for ollama |
| acct-group/open-webui | A group for Open WebUI |
| acct-group/voltaml-fast-stable-diffusion | A group for VoltaML - Fast Stable Diffusion |
| acct-user/lobe-chat | A user for Lobe Chat |
| acct-user/local-ai | A user for LocalAI |
| acct-user/ollama | A user for ollama |
| acct-user/open-webui | A user for Open WebUI |
| acct-user/voltaml-fast-stable-diffusion | A user for VoltaML - Fast Stable Diffusion |
| app-accessibility/whisper-cpp | Port of OpenAI's Whisper model in C/C++ |
| app-admin/coreboot-utils | A selection from coreboot/utils useful in general |
| app-admin/howdy | Facial authentication for Linux |
| app-admin/keepassxc | KeePassXC - KeePass Cross-platform Community Edition |
| app-antivirus/clamav | Clam Anti-Virus Scanner |
| app-arch/brotli | Generic-purpose lossless compression algorithm |
| app-arch/bzip2 | A high-quality data compressor used extensively by Gentoo Linux |
| app-arch/libarchive | Multi-format archive and compression library |
| app-arch/lz4 | Extremely Fast Compression algorithm |
| app-arch/pigz | A parallel implementation of gzip |
| app-arch/unzip | unzipper for pkzip-compressed files |
| app-arch/xz-utils | Utils for managing LZMA compressed files |
| app-arch/zip | Info ZIP (encryption support) |
| app-arch/zopfli | A very good, but slow, deflate or zlib compression |
| app-arch/zstd | zstd fast compression library |
| app-benchmarks/mixbench | A GPU benchmark tool for evaluating GPUs and CPUs on mixed operational intensity kernels (CUDA, OpenCL, HIP, SYCL, OpenMP) |
| app-benchmarks/opencl-benchmark | A small OpenCL benchmark program to measure peak GPU/CPU performance. |
| app-benchmarks/transferbench | TransferBench is a utility capable of benchmarking simultaneous copies between user-specified devices (CPUs/GPUs) |
| app-crypt/argon2 | Password hashing software that won the Password Hashing Competition (PHC) |
| app-crypt/gcr | Libraries for cryptographic UIs and accessing PKCS#11 modules |
| app-crypt/hashcat | The World's fastest and most advanced password recovery utility |
| app-crypt/hashtopolis | Hashtopolis is a Hashcat wrapper for distributed password recovery |
| app-crypt/hashtopolis-python-agent | The official Python agent for using the distributed hashcracker Hashtopolis |
| app-crypt/libzc | Tool and library for cracking legacy zip files. |
| app-crypt/webhashcat | Hashcat web interface |
| app-editors/leafpad | Simple GTK2 text editor |
| app-editors/mousepad | GTK+-based editor for the Xfce Desktop Environment |
| app-editors/nano | GNU GPL'd Pico clone with more functionality |
| app-editors/nano-ycmd | GNU GPL'd Pico clone with more functionality with ycmd support |
| app-emacs/emacs-ycmd | Emacs client for ycmd, the code completion system |
| app-eselect/eselect-cython | Manages the cython symlinks |
| app-eselect/eselect-emscripten | Manages the emscripten environment |
| app-eselect/eselect-nodejs | Manages the /usr/include/node symlink |
| app-eselect/eselect-rocm | Manages the rocm symlinks |
| app-eselect/eselect-typescript | Manages the /usr/bin/tsc /usr/bin/tsserver symlinks |
| app-misc/alpaca | An Ollama AI client made with GTK4 and Adwaita |
| app-misc/amica | Amica is a customizable friendly interactive AI with 3D characters, voice synthesis, speech recognition, emotion engine |
| app-misc/elfx86exts | Disassemble a x86 binary and print out used instruction sets |
| app-misc/jq | A lightweight and flexible command-line JSON processor |
| app-misc/june | Local voice AI chatbot for engaging conversations, powered by Ollama, Hugging Face Transformers, and Coqui TTS Toolkit |
| app-misc/liquidctl | Cross-platform tool and drivers for liquid coolers and other devices |
| app-misc/llocal | Aiming to provide a seamless and privacy driven AI chatting experience with open-sourced technologies |
| app-misc/LocalAI | A REST API featuring integrated WebUI, P2P inference, generation of text, audio, video, images, voice cloning |
| app-misc/ollama | Get up and running with Llama 3, Mistral, Gemma, and other local large language models (LLMs) synonymous with AI chatbots or AI assistants. |
| app-misc/screen | screen manager with VT100/ANSI terminal emulation |
| app-misc/ssl-cert-snakeoil | A self-signed certificate required by some *.deb packages or projects |
| app-shells/emoji-cli | Emoji completion on the command line |
| app-shells/emojify | Emoji on the command line |
| app-shells/loz | Loz is a command-line tool that enables your preferred LLM to execute system commands and utilize Unix pipes, integrating AI capabilities with other Unix tools. |
| app-shells/ohmyzsh | A delightful community-driven framework for managing your zsh configuration that includes optional plugins and themes. |
| app-shells/percol | Adds flavor of interactive filtering to the traditional pipe concept of shell |
| app-shells/shell-gpt | An AI command-line productivity tool powered by OpenAI's GPT models or Ollama local LLMs. |
| app-text/aspell | Free and Open Source spell checker designed to replace Ispell |
| app-text/enchant | Generic spell checking library |
| app-text/hunspell | Spell checker, morphological analyzer library and command-line tool |
| app-text/pdfchain | Graphical User Interface for PDF Toolkit (PDFtk) |
| app-text/poppler | PDF rendering library based on the xpdf-3.0 code base |
| dev-build/bazel | Fast and correct automated build system |
| dev-build/rocm-cmake | Radeon Open Compute CMake Modules |
| dev-cpp/abseil-cpp | Abseil Common Libraries (C++), LTS Branch |
| dev-cpp/antlr4 | C++ runtime support for ANTLR 4 |
| dev-cpp/blaze | A high performance C++ math library |
| dev-cpp/frugally-deep | Header-only library for using Keras (TensorFlow) models in C++. |
| dev-cpp/FunctionalPlus | Functional Programming Library for C++. Write concise and readable C++ code. |
| dev-cpp/glaze | Extremely fast, in memory, JSON and interface library for modern C++ |
| dev-cpp/highway | Performance-portable, length-agnostic SIMD with runtime dispatch |
| dev-cpp/nlohmann_json | JSON for Modern C++ |
| dev-cpp/opentelemetry-cpp | The OpenTelemetry C++ Client |
| dev-cpp/pystring | C++ functions matching the interface and behavior of Python string methods |
| dev-cpp/selfrando | Function order shuffling to defend against ROP and other types of code reuse |
| dev-cpp/sqlitecpp | SQLiteC++ (SQLiteCpp) is a smart and easy to use C++ SQLite3 wrapper |
| dev-cpp/yaml-cpp | YAML parser and emitter in C++ |
| dev-db/mariadb | An enhanced, drop-in replacement for MySQL |
| dev-db/mysql | A fast, multi-threaded, multi-user SQL database server |
| dev-db/nanodbc | A small C++ wrapper for the native C ODBC API |
| dev-db/sqlite | SQL database engine |
| dev-dotnet/aforgedotnet | AForge.NET Framework is a C# framework designed for developers and researchers in the fields of Computer Vision and Artificial Intelligence - image processing, neural networks, genetic algorithms, machine learning, robotics, etc. |
| dev-dotnet/BulletSharpPInvoke | .NET wrapper for the Bullet physics library using Platform Invoke |
| dev-dotnet/dotdevelop | DotDevelop will hopefully be a full-featured integrated development environment (IDE) for .NET using GTK. |
| dev-dotnet/faudio | FAudio - Accuracy-focused XAudio reimplementation for open platforms |
| dev-dotnet/fna3d | FNA3D - 3D Graphics Library for FNA |
| dev-dotnet/fna | FNA - Accuracy-focused XNA4 reimplementation for open platforms |
| dev-dotnet/fsharp-mono-bin | The F# compiler, F# core library, and F# editor tools |
| dev-dotnet/gtk-sharp | GTK bindings for Mono |
| dev-dotnet/gtk-sharp | Gtk# is a Mono/.NET binding to the cross platform Gtk+ GUI toolkit and the foundation of most GUI apps built with Mono |
| dev-dotnet/GtkSharp | .NET wrapper for Gtk and other related libraries |
| dev-dotnet/libfreenect | Drivers and libraries for the Xbox Kinect |
| dev-dotnet/monodevelop-bin | MonoDevelop is a cross platform .NET IDE |
| dev-dotnet/monodevelop-database-bin | Database Addin for MonoDevelop |
| dev-dotnet/monodevelop-nunit-bin | NUnit plugin for MonoDevelop |
| dev-dotnet/monodevelop-versioncontrol-bin | VersionControl plugin for MonoDevelop |
| dev-dotnet/monogame-extended | MonoGame.Extended are classes and extensions to make MonoGame more awesome |
| dev-dotnet/monogame | One framework for creating powerful cross-platform games. |
| dev-dotnet/mono-msbuild-bin | MSBuild is the build platform for .NET and VS. |
| dev-dotnet/sdl2-cs | SDL2# - C# Wrapper for SDL2 |
| dev-dotnet/sfmldotnet | SFML.Net is a C# language binding for SFML |
| dev-dotnet/sharpnav | SharpNav is an advanced pathfinding library for C# |
| dev-dotnet/theorafile | An Ogg Theora Video Decoder Library |
| dev-dotnet/tiledsharp | C# library for parsing and importing TMX and TSX files generated by Tiled, a tile map generation tool. |
| dev-dotnet/velcrophysics | High performance 2D collision detection system with realistic physics responses. |
| dev-games/enigma | ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, is an open source cross-platform game development environment. |
| dev-games/godot-cpp | C++ bindings for the Godot script API |
| dev-games/godot-demo-projects | Demonstration and Template Projects |
| dev-games/godot-editor | Godot editor |
| dev-games/godot-export-templates-bin | Godot export templates |
| dev-games/godot-meta | Godot metapackage |
| dev-games/lateralgm | A free game maker source file editor |
| dev-games/radialgm | A native IDE for ENIGMA written in C++ using the Qt Framework. |
| dev-games/recastnavigation | Navigation-mesh Toolset for Games |
| dev-go/protobuf-go | Go support for Google's protocol buffers |
| dev-go/protoc-gen-go-grpc | This tool generates Go language bindings of services in protobuf definition files for gRPC |
| dev-java/gradle-bin | A project automation and build tool with a Groovy based DSL |
| dev-java/grpc-java | Java libraries for the high performance gRPC framework |
| dev-lang/classic-flang | Flang is a Fortran language front-end designed for integration with LLVM. |
| dev-lang/gambas | Gambas is a free development environment and a full powerful development platform based on a Basic interpreter with object extensions and form designer. |
| dev-lang/halide | A language for fast, portable data-parallel computation |
| dev-lang/ispc | Intel® SPMD Program Compiler |
| dev-lang/llvm-flang | LLVM Flang is a continuation of F18 to replace Classic Flang |
| dev-lang/lua | A powerful light-weight programming language designed for extending applications |
| dev-lang/lua-extra-headers | Installs extra headers required by Lua applications |
| dev-lang/mono | Mono open source ECMA CLI, C# and .NET implementation |
| dev-lang/perl | Larry Wall's Practical Extraction and Report Language |
| dev-lang/php | The PHP language runtime engine |
| dev-lang/python-exec | Python script wrapper |
| dev-lang/rocm-flang | ROCm's fork of Classic Flang with GPU offload support |
| dev-lang/spidermonkey | A JavaScript engine written in C and C++ |
| dev-lang/typescript | TypeScript is a statically typed superset of JavaScript that compiles to clean JavaScript output |
| dev-libs/amdgpu-pro-opencl-legacy | Legacy OpenCL support for AMDGPU-PRO drivers |
| dev-libs/blake3 | A fast cryptographic hash function |
| dev-libs/botan | C++ crypto library |
| dev-libs/cJSON | Ultralightweight JSON parser in ANSI C |
| dev-libs/crc32c | CRC32C implementation with support for CPU-specific acceleration instructions |
| dev-libs/dlpack | Common in-memory tensor structure |
| dev-libs/double-conversion | Binary-decimal and decimal-binary conversion routines for IEEE doubles |
| dev-libs/expat | Stream-oriented XML parser library |
| dev-libs/gdrcopy | A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology |
| dev-libs/glib | The GLib library of C routines |
| dev-libs/hardened_malloc | A hardened allocator designed for modern systems |
| dev-libs/hip-cpu | An implementation of HIP that works on CPUs |
| dev-libs/hipother | Other HIP backend compatibility |
| dev-libs/hsa-amd-aqlprofile | AQLPROFILE library for AMD HSA runtime API extension support |
| dev-libs/hyphen | ALTLinux hyphenation library |
| dev-libs/icu | International Components for Unicode |
| dev-libs/imath | Imath basic math package |
| dev-libs/jemalloc | A general-purpose scalable concurrent allocator |
| dev-libs/jemalloc-usd | USD support for Jemalloc, a general-purpose scalable concurrent allocator |
| dev-libs/leveldb | A fast key-value storage library |
| dev-libs/libappimage | Implements functionality for dealing with AppImage files |
| dev-libs/libdatachannel | C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets |
| dev-libs/libfreenect | Drivers and libraries for the Xbox Kinect device |
| dev-libs/libpcre2 | Perl-compatible regular expression library |
| dev-libs/libsodium | Portable fork of NaCl, a higher-level cryptographic library |
| dev-libs/libtasn1 | ASN.1 library |
| dev-libs/libxml2 | XML C parser and toolkit |
| dev-libs/libxslt | XSLT libraries and tools |
| dev-libs/lief | Library to instrument executable formats |
| dev-libs/log4c | Logging FrameWork for C, as Log4j or Log4Cpp |
| dev-libs/mimalloc | A compact general purpose allocator with excellent performance |
| dev-libs/miniz | A lossless, high performance data compression library |
| dev-libs/nccl | Optimized primitives for collective multi-GPU communication |
| dev-libs/nccl-rdma-sharp-plugins | RDMA and SHARP plugins for the NCCL library |
| dev-libs/ncnn | High-performance neural network inference framework |
| dev-libs/nettle | Low-level cryptographic library |
| dev-libs/nss | Mozilla's Network Security Services library that implements PKI support |
| dev-libs/nxjson | A very small JSON parser written in C |
| dev-libs/openssl | Robust, full-featured Open Source Toolkit for the Transport Layer Security (TLS) |
| dev-libs/Orochi | Orochi is a library loading HIP and CUDA APIs dynamically, allowing the user to switch APIs at runtime |
| dev-libs/protobuf | An extensible mechanism for serializing structured data |
| dev-libs/pugixml | Light-weight, simple, and fast XML parser for C++ with XPath support |
| dev-libs/rapidjson | A fast JSON parser/generator for C++ with both SAX/DOM style API |
| dev-libs/rccl-rdma-sharp-plugins | rccl-rdma-sharp plugin enables RDMA and Switch based collectives (SHARP) with AMD's RCCL library |
| dev-libs/rccl | ROCm Communication Collectives Library (RCCL) |
| dev-libs/re2 | An efficient, principled regular expression library |
| dev-libs/ROCdbgapi | AMD Debugger API |
| dev-libs/rocm-comgr | Radeon Open Compute Code Object Manager |
| dev-libs/rocm-core | rocm-core is a utility which can be used to get ROCm release version. |
| dev-libs/rocm-debug-agent | Radeon Open Compute Debug Agent |
| dev-libs/rocm-device-libs | Radeon Open Compute Device Libraries |
| dev-libs/rocm-opencl-runtime | Radeon Open Compute OpenCL Compatible Runtime |
| dev-libs/rocprofiler-register | The rocprofiler-register helper library |
| dev-libs/rocr-runtime | Radeon Open Compute Runtime |
| dev-libs/roct-thunk-interface | Radeon Open Compute Thunk Interface |
| dev-libs/safeclib | safec libc extension with all C11 Annex K functions |
| dev-libs/spdlog | Very fast, header only, C++ logging library |
| dev-libs/unittest++ | A lightweight unit testing framework for C++ |
| dev-libs/utf8_range | Fast UTF-8 validation with Range algorithm (NEON+SSE4+AVX2) |
| dev-lua/luafilesystem | File System Library for the Lua Programming Language |
| dev-lua/luasqlite3 | LuaSQLite 3 is a thin wrapper around the public domain SQLite3 database engine |
| dev-lua/luaxml | A minimal set of XML processing funcs & simple XML<->Tables mapping |
| dev-nodejs/acorn | A small, fast, JavaScript-based JavaScript parser Resources |
| dev-perl/Alien-Build-Git | Alien::Build tools for interacting with git |
| dev-perl/Alien-caca | Alien package for the Colored ASCII Art library |
| dev-perl/Alien-FFI | Build and make available libffi |
| dev-perl/Crypt-Rijndael | Crypt::CBC compliant Rijndael encryption module |
| dev-perl/FFI-Platypus | Write Perl bindings to non-Perl libraries with FFI. No XS required. |
| dev-perl/Mojo-DOM58 | Minimalistic HTML/XML DOM parser with CSS selectors |
| dev-perl/MooseX-MungeHas | Munge your 'has' (works with Moo, Moose and Mouse) |
| dev-perl/PerlX-Maybe | Return a pair only if they are both defined |
| dev-perl/PerlX-Maybe-XS | XS backend for PerlX::Maybe |
| dev-perl/Term-Caca | A perl interface for libcaca (Colour AsCii Art library) |
| dev-perl/TermReadKey | Change terminal modes, and perform non-blocking reads |
| dev-perl/Test2-Tools-URL | Compare a URL in your Test2 test |
| dev-perl/Test-Vars | Detects unused variables in perl modules |
| dev-perl/URI-git | URI handler for git scheme |
| dev-php/grpc | PHP libraries for the high performance gRPC framework |
| dev-php/libcaca | A library that creates colored ASCII-art graphics |
| dev-python/aafigure | ASCII art to image converter |
| dev-python/aioquic | QUIC and HTTP/3 implementation in Python |
| dev-python/AITemplate | A Python framework rendering neural network into high performance CUDA/HIP C++ code |
| dev-python/ale-py | The Arcade Learning Environment (ALE) is a platform for AI research |
| dev-python/anthropic | The official Python library for the anthropic API |
| dev-python/anyio | A compatibility layer for multiple asynchronous event loop implementations |
| dev-python/apscheduler | In-process task scheduler with Cron-like capabilities |
| dev-python/array-record | A file format that achieves a new frontier of IO efficiency |
| dev-python/asdff | Adetailer Stable Diffusion diFFusers pipeline |
| dev-python/astunparse | An Abstract Syntax Tree (AST) unparser for Python |
| dev-python/auditwheel | Auditing and relabeling cross-distribution Linux wheels |
| dev-python/Authlib | The ultimate Python library in building OAuth and OpenID Connect servers |
| dev-python/autorom-accept-rom-license | AutoROM ROMs |
| dev-python/autorom | A tool to automate installing Atari ROMs for the Arcade Learning Environment |
| dev-python/av | Pythonic bindings for FFmpeg's libraries. |
| dev-python/azure-ai-documentintelligence | Microsoft Azure AI Document Intelligence Client Library for Python |
| dev-python/azure-identity | Microsoft Azure Identity Library for Python |
| dev-python/azure-storage-blob | Microsoft Azure Blob Storage Client Library for Python |
| dev-python/backcall | Backwards compatible callback APIs |
| dev-python/barectf | Generator of ANSI C tracers which output CTF data streams |
| dev-python/basicsr | An open source image and video super-resolution toolbox |
| dev-python/blis | A self-contained 💥 fast matrix-multiplication Python library without system dependencies! |
| dev-python/box2d-py | A repackaged version of pybox2d |
| dev-python/bsuite | bsuite is a collection of carefully-designed experiments that investigate core capabilities of a reinforcement learning (RL) agent |
| dev-python/cachetools | Extensible memoizing collections and decorators |
| dev-python/catalogue | Super lightweight function registries for your library |
| dev-python/celshast | A Sphinx documentation theme based on the Furo template |
| dev-python/chex | Chex is a library of utilities for helping to write reliable JAX code. |
| dev-python/chromadb | the AI-native open-source embedding database |
| dev-python/chroma-hnswlib | Chroma's fork of hnswlib - a header-only C++/python library for fast approximate nearest neighbors |
| dev-python/clean-fid | FID calculation in PyTorch with proper image resizing and quantization steps |
| dev-python/clip-anytorch | Contrastive Language-Image Pretraining |
| dev-python/cli-ui | Python library for better command line interfaces |
| dev-python/cloudpathlib | Python pathlib-style classes for cloud storage services |
| dev-python/clu | A set of libraries for Machine Learning (ML) training loops in JAX |
| dev-python/cmake-build-extension | Setuptools extension to build and package CMake projects |
| dev-python/colbert-ai | Efficient and Effective Passage Search via Contextualized Late Interaction over BERT |
| dev-python/colorlover | Color scales in Python for humans |
| dev-python/commoncode | Set of common utilities, originally split from ScanCode |
| dev-python/compressed-rtf | Compressed Rich Text Format (RTF) compression and decompression in Python |
| dev-python/confection | 🍬 Confection: the sweetest config system for Python |
| dev-python/container-inspector | Docker, containers, rootfs and virtual machine related software composition analysis (SCA) utilities |
| dev-python/contextlib2 | contextlib2 is a backport of the standard library's contextlib module to earlier Python versions. |
| dev-python/controlnet-aux | Auxillary models for controlnet |
| dev-python/coqpit | A simple but maybe too simple config management through Python data classes used for machine learning |
| dev-python/coqui-tts | 🐸💬 - a deep learning toolkit for Text-to-Speech, battle-tested in research and production |
| dev-python/coqui-tts-trainer | 🐸 - A general purpose model trainer, as flexible as it gets |
| dev-python/cpufeature | CPU feature detection with Python |
| dev-python/cryptography | Library providing cryptographic recipes and primitives |
| dev-python/ctranslate2 | Fast inference engine for Transformer models |
| dev-python/cuda-python | Python bindings for CUDA |
| dev-python/cx-Freeze-bin | Create standalone executables from Python scripts |
| dev-python/cymem | 💥 Cython memory pool for RAII-style memory management |
| dev-python/cython | A Python to C compiler |
| dev-python/dash-bootstrap-components | Bootstrap components for Plotly Dash |
| dev-python/dash-svg | SVG support library for Plotly/Dash |
| dev-python/dataclass-wizard | A simple, yet elegant, set of wizarding tools for interacting with Python dataclasses. |
| dev-python/dctorch | Fast discrete cosine transforms for PyTorch |
| dev-python/debian-inspector | Utilities to parse Debian package, copyright and control files |
| dev-python/dek | The decorator-decorator |
| dev-python/diffusers | State-of-the-art diffusion in PyTorch and JAX. |
| dev-python/discord-py | An API wrapper for Discord written in Python |
| dev-python/distrax | Distrax: Probability distributions in JAX. |
| dev-python/dm-control | DeepMind's software stack for physics-based simulation and Reinforcement Learning environments, using MuJoCo. |
| dev-python/dm-env | A Python interface for reinforcement learning environments |
| dev-python/dm-haiku | JAX-based neural network library |
| dev-python/dmlab2d | A customisable 2D platform for agent-based AI research |
| dev-python/dm-meltingpot | A suite of test scenarios for multi-agent reinforcement learning. |
| dev-python/dm-sonnet | Sonnet is a library for building neural networks in TensorFlow. |
| dev-python/dm-tree | tree is a library for working with nested data structures |
| dev-python/docker-pycreds | Python bindings for the docker credentials store API |
| dev-python/docutils | Python Documentation Utilities (reference reStructuredText impl.) |
| dev-python/docx2txt | A pure python based utility to extract text and images from docx files |
| dev-python/dopamine-rl | Dopamine is a research framework for fast prototyping of reinforcement learning algorithms. |
| dev-python/dparse2 | A parser for Python dependency files |
| dev-python/duckduckgo-search | AI chat and search for text, news, images and videos using the DuckDuckGo.com search engine |
| dev-python/durationpy | Module for converting between datetime.timedelta and Go 's Duration strings |
| dev-python/ebcdic | Additional EBCDIC codecs |
| dev-python/ecos | A Python interface for the Embedded Conic Solver (ECOS) |
| dev-python/editor | A Python library to open the default text editor |
| dev-python/effdet | A PyTorch implementation of EfficientDet |
| dev-python/einops-exts | Implementation of some personal helper functions for Einops, my most favorite tensor manipulation library ❤️ |
| dev-python/elevate | A Python library for requesting root privileges |
| dev-python/encodec | State-of-the-art deep learning based audio codec supporting both mono 24 kHz audio and stereo 48 kHz audio. |
| dev-python/etils | Collection of eclectic utils for Python |
| dev-python/exhale | Automatic C++ library api documentation generation: breathe doxygen in and exhale it out |
| dev-python/extractcode_7z | A ScanCode path provider plugin to provide a prebuilt native sevenzip binary |
| dev-python/extractcode | A mostly universal archive extractor using 7zip, libarchive and the Python standard library for reliable archive extraction |
| dev-python/extractcode-libarchive | A ScanCode path provider plugin to provide a prebuilt native libarchive binary |
| dev-python/extract-msg | Extracts emails and attachments saved in Microsoft Outlook's .msg files |
| dev-python/facemorpher | 👼 Morph faces with Python, Numpy, Scipy |
| dev-python/face_recognition_models | Models used by the face_recognition package. |
| dev-python/face-recognition | Recognize faces from Python or from the command line |
| dev-python/facexlib | FaceXlib provides face-related functions |
| dev-python/Farama-Notifications | Gymnasium Notices |
| dev-python/fastapi | A modern, fast (high-performance), web framework for building APIs with Python |
| dev-python/fastapi-analytics | Lightweight monitoring and analytics for API frameworks |
| dev-python/fastapi-simple-cachecontrol | Cache-Control header management for FastAPI |
| dev-python/fastbencode | Fast implementation of bencode |
| dev-python/faster-whisper | Faster Whisper transcription with CTranslate2 |
| dev-python/filterpy | Kalman filters filtering optimal estimation tracking |
| dev-python/fingerprints | A library to generate entity fingerprints |
| dev-python/firecrawl-py | Python SDK for Firecrawl API |
| dev-python/flake8-colors | ANSI colors highlight for Flake8 |
| dev-python/flake8-docstrings | Integration of pydocstyle and flake8 for combined linting and reporting |
| dev-python/flake8-future-import | Flake8 extension to check imports |
| dev-python/flake8-import-order | Flake8 plugin that checks import order against various Python Style Guides |
| dev-python/flake8-print | Check for print statements in Python files |
| dev-python/flamingo-mini | Implementation of the deepmind Flamingo vision-language model, based on Hugging Face language models and ready for training |
| dev-python/flash-attn | Fast and memory-efficient exact attention |
| dev-python/Flask-HTTPAuth | Simple extension that provides Basic, Digest and Token HTTP authentication for Flask routes |
| dev-python/flax | Flax is a neural network library for JAX that is designed for flexibility. |
| dev-python/fpdf2 | Simple PDF generation for Python |
| dev-python/gcp-storage-emulator | Local emulator for Google Cloud Storage |
| dev-python/gemfileparser2 | Parse Ruby Gemfile, .gemspec and Cocoapod .podspec files using Python |
| dev-python/gfpgan | GFPGAN aims at developing Practical Algorithms for Real-world Face Restoration |
| dev-python/gin-config | Gin-Config: A lightweight configuration library for Python |
| dev-python/gitdb | IO of git-style object databases |
| dev-python/go-inspector | A scancode plugin to extract symbols and dependencies found in Go binaries |
| dev-python/google-ai-generativelanguage | Google AI Generative Language API client library |
| dev-python/google-api-core | Core Library for Google Client Libraries |
| dev-python/google-auth-oauthlib | oauthlib integration for the Google Auth library |
| dev-python/google-auth | The Google Auth library simplifies server-to-server authentication to Google APIs |
| dev-python/google-generativeai | Google Generative AI High level API client library and tools |
| dev-python/google | Python bindings to the Google search engine. |
| dev-python/grpcio | Python libraries for the high performance gRPC framework |
| dev-python/grpcio-status | Reference package for GRPC Python status proto mapping |
| dev-python/grpcio-testing | Testing utilities for gRPC Python |
| dev-python/grpcio-tools | Protobuf code generator for gRPC |
| dev-python/gruut | A tokenizer, text cleaner, and phonemizer for many human languages. |
| dev-python/gruut-ipa | Python library for manipulating pronunciations using the International Phonetic Alphabet (IPA) |
| dev-python/gviz-api | Python API for Google Visualization |
| dev-python/gym | A toolkit for developing and comparing reinforcement learning algorithms. |
| dev-python/gymnasium | A standard API for single-agent reinforcement learning environments, with popular reference environments and related utilities (formerly Gym) |
| dev-python/gymnasium-notices | Gymnasium Notices |
| dev-python/gym-notices | Gym Notices |
| dev-python/h2 | HTTP/2 State-Machine based protocol implementation |
| dev-python/hanabi-learning-environment | hanabi_learning_environment is a research platform for Hanabi experiments. |
| dev-python/hpack | Pure-Python HPACK header compression |
| dev-python/httpx-sse | Consume Server-Sent Event (SSE) messages with HTTPX |
| dev-python/hyperframe | HTTP/2 framing layer for Python |
| dev-python/inquirer | Collection of common interactive command line user interfaces, based on Inquirer.js |
| dev-python/instructor | Structured outputs for LLMs |
| dev-python/intbitset | Python C-based extension implementing fast integer bit sets |
| dev-python/invisible-watermark | A Python library for invisible image watermark (blind image watermark) |
| dev-python/ivy | Convert machine learning code between frameworks |
| dev-python/JaroWinkler | Python library for fast approximate string matching using Jaro and Jaro-Winkler similarity |
| dev-python/javaproperties | Read & write Java .properties files |
| dev-python/jax | Differentiate, compile, and transform Numpy code |
| dev-python/jaxlib | Support library for JAX |
| dev-python/jaxtyping | Type annotations and runtime checking for shape and dtype of JAX/NumPy/PyTorch/etc. arrays. |
| dev-python/jiter | Fast iterable JSON parser |
| dev-python/js8py | Python module for parsing messages from the 'js8' command line decoder |
| dev-python/jsonpath-python | A more powerful JSONPath implementation in modern python |
| dev-python/jsonstreams | A JSON streaming writer |
| dev-python/jumpy | On-the-fly conversions between Jax and NumPy tensors |
| dev-python/kaggle | The Official Kaggle API |
| dev-python/kaldi-io | Python functions for reading kaldi data formats which is useful for rapid prototyping |
| dev-python/k-diffusion | Diffusion models for PyTorch |
| dev-python/keras-applications | Keras deep learning library reference implementations of deep learning models |
| dev-python/keras | Deep Learning for humans |
| dev-python/keras-preprocessing | Easy data preprocessing and data augmentation for deep learning models |
| dev-python/kornia | Geometric computer vision library for spatial AI |
| dev-python/kornia-rs | A low-level 3D computer vision library in Rust |
| dev-python/kubernetes | Official Python client library for kubernetes |
| dev-python/labmaze | A standalone release of DeepMind Lab's maze generator with Python bindings. |
| dev-python/langchain | ⚡ Building applications with LLMs through composability ⚡ |
| dev-python/langchain-community | Community contributed LangChain integrations |
| dev-python/langchain-core | LangChain Core contains the base abstractions that power the rest of the LangChain ecosystem |
| dev-python/langchain-text-splitters | LangChain text splitting utilities |
| dev-python/langcodes | A Python library for working with and comparing language codes. |
| dev-python/langfuse | A client library for accessing langfuse |
| dev-python/langsmith | Client library to connect to the LangSmith LLM Tracing and Evaluation Platform |
| dev-python/language-data | An optional supplement to `langcodes ` that stores names and statistics of languages |
| dev-python/Levenshtein | The Levenshtein Python C extension module contains functions for fast computation of Levenshtein distance and string similarity |
| dev-python/librosa | A Python package for music and audio analysis |
| dev-python/lightning-api-access | Lightning Frontend Showing how a given API can be accessed |
| dev-python/lightning-app | Use Lightning Apps to build everything from production-ready, multi-cloud ML systems to simple research demos. |
| dev-python/lightning-cloud | Lightning Cloud |
| dev-python/lightning-fabric | Fabric is the fast and lightweight way to scale PyTorch models without boilerplate |
| dev-python/lightning | The Deep Learning framework to train, deploy, and ship AI products Lightning fast. |
| dev-python/lightning-utilities | Common Python utilities and GitHub Actions in Lightning Ecosystem |
| dev-python/llvmlite | A lightweight wrapper around basic LLVM functionality |
| dev-python/lxml | A Pythonic binding for the libxml2 and libxslt libraries |
| dev-python/marisa-trie | Static memory-efficient Trie-like structures for Python |
| dev-python/merge3 | Python implementation of 3-way merge |
| dev-python/milvus-lite-bin | A lightweight version of Milvus |
| dev-python/milvus-model | A library that provides the integration with common embedding and reranker models for Milvus, a high performance open-source vector database built for AI applications |
| dev-python/mizani | A scales package for Python |
| dev-python/ml-collections | ML Collections is a library of Python Collections designed for ML use cases. |
| dev-python/ml-datasets | 🌊 Machine learning dataset loaders for testing and example scripts |
| dev-python/ml-dtypes | A stand-alone implementation of several NumPy dtype extensions used in machine learning. |
| dev-python/model-index | Create a source of truth for ML model results and browse it on Papers with Code |
| dev-python/monotonic | An implementation of time.monotonic() for Python 2 & Python 3 |
| dev-python/moviepy | Video editing with Python |
| dev-python/msal-extensions | Microsoft Authentication Extensions for Python |
| dev-python/msal | Microsoft Authentication Library (MSAL) for Python |
| dev-python/mujoco | Python bindings for MuJoCo (Multi-Joint dynamics with Contact), a general purpose physics simulator. |
| dev-python/multi-agent-ale-py | A fork of the the Arcade Learning Environment (ALE) platform for AI research with multiplayer support |
| dev-python/murmurhash | 💥 Cython bindings for MurmurHash2 |
| dev-python/mypy | Optional static typing for Python |
| dev-python/myst-parser | An extended commonmark compliant parser, with bridges to docutils/sphinx |
| dev-python/namex | Clean up the public namespace of your package! |
| dev-python/nashpy | A Python library for 2 player games |
| dev-python/ncnn | Python bindings for the high-performance neural network inference framework |
| dev-python/neural-compressor | State of the art low-bit LLM quantization (INT8/FP8/INT4/FP4/NF4) & sparsity; leading model compression techniques on TensorFlow, PyTorch, and ONNX Runtime |
| dev-python/nltk | A suite of open source Python modules, data sets, and tutorials supporting research and development in Natural Language Processing |
| dev-python/nnef-parser | A parser to add support for neural network NNEF files |
| dev-python/nnef-tools | Convert neural networks models to NNEF format |
| dev-python/nose_xunitmp | A nosetest xunit plugin with multiprocessor support |
| dev-python/nudenet | Lightweight nudity detection |
| dev-python/num2words | Modules to convert numbers to words. |
| dev-python/numba | NumPy aware dynamic Python compiler using LLVM |
| dev-python/numpy | Fast array and numerical Python library |
| dev-python/ollama | Ollama Python library |
| dev-python/omegaconf | A flexible configuration library |
| dev-python/onnxoptimizer | A C++ library for performing arbitrary optimizations on ONNX models |
| dev-python/onnx-simplifier | Simplify your ONNX model |
| dev-python/openai | The official Python library for the OpenAI API |
| dev-python/open-clip-torch | An open source implementation of CLIP |
| dev-python/opensearch-py | Python client for OpenSearch |
| dev-python/open-spiel | OpenSpiel is a collection of environments and algorithms for research in general reinforcement learning and search/planning in games. |
| dev-python/opentelemetry-api | OpenTelemetry Python API |
| dev-python/opentelemetry-exporter-otlp-proto-common | OpenTelemetry Protobuf encoding |
| dev-python/opentelemetry-exporter-otlp-proto-grpc | OpenTelemetry Collector Protobuf over gRPC Exporter |
| dev-python/opentelemetry-instrumentation-asgi | ASGI instrumentation for OpenTelemetry |
| dev-python/opentelemetry-instrumentation-fastapi | OpenTelemetry FastAPI Instrumentation |
| dev-python/opentelemetry-instrumentation | Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python |
| dev-python/opentelemetry-proto | OpenTelemetry Python Proto |
| dev-python/opentelemetry-sdk | OpenTelemetry Python SDK |
| dev-python/opentelemetry-semantic-conventions | OpenTelemetry Semantic Conventions |
| dev-python/opentelemetry-util-http | Web util for OpenTelemetry |
| dev-python/optax | Optax is a gradient processing and optimization library for JAX. |
| dev-python/optree | tree is a library for working with nested data structures |
| dev-python/orbax-checkpoint | A checkpointing library for Orbax |
| dev-python/orbax | Orbax is a library providing common utilities for JAX users. |
| dev-python/packagedcode-msitools | A ScanCode path provider plugin to provide prebuilt binaries from msitools |
| dev-python/packvers | Core utilities for Python packages. Fork to support LegacyVersion |
| dev-python/parameter-expansion-patched | Shell parameter expansion in Python |
| dev-python/pathlib-abc | Python base classes for rich path objects |
| dev-python/pathy | A simple, flexible, offline capable, cloud storage with a Python path-like interface |
| dev-python/patiencediff | A Patience Diff implementation in Python |
| dev-python/peewee-migrate | Simple migration engine for Peewee |
| dev-python/pep8-naming | Naming Convention checker for Python |
| dev-python/pettingzoo | A standard API for multi-agent reinforcement learning environments, with popular reference environments and related utilities |
| dev-python/pgvector | pgvector support for Python |
| dev-python/pillow-simd | The friendly PIL fork |
| dev-python/pip-requirements-parser | A mostly correct pip requirements parsing library because it uses pip's own code |
| dev-python/pkginfo2 | Query metadatdata from sdists / bdists / installed packages. Safer fork of pkginfo to avoid doing arbitrary imports and eval() |
| dev-python/playwright-bin | Automate Chromium, Firefox and WebKit browsers with a single API |
| dev-python/plotille | Plot in the terminal using braille dots. |
| dev-python/plotnine | A Grammar of Graphics for Python |
| dev-python/plugincode | plugincode is a library that provides plugin functionality for ScanCode toolkit |
| dev-python/pocket | A Python wrapper for the Pocket API |
| dev-python/portalocker | A library for Python file locking |
| dev-python/portpicker | A module to find available network ports for testing. |
| dev-python/posthog | Integrate PostHog product analytics into any Python application |
| dev-python/preshed | 💥 Cython hash tables that assume keys are pre-hashed |
| dev-python/pretrainedmodels | Pretrained Convolutional Neural Networks for PyTorch: NASNet, ResNeXt, ResNet, InceptionV4, InceptionResnetV2, Xception, DPN, etc. |
| dev-python/primp | HTTP client that can impersonate web browsers, mimicking their headers and `TLS/JA3/JA4/HTTP2 ` fingerprints |
| dev-python/proglog | Logs and progress bars manager for Python |
| dev-python/protobuf | Python bindings for Google's Protocol Buffers |
| dev-python/py3c | A Python 2/3 compatibility layer for C extensions |
| dev-python/pyahocorasick | A fast and memory efficient library for exact or approximate multi-pattern string search |
| dev-python/pyamdgpuinfo | AMD GPU stats |
| dev-python/pyarrow | Python library for Apache Arrow |
| dev-python/pyaudio | Python bindings for PortAudio |
| dev-python/pybboxes | A Lightweight toolkit for bounding boxes providing conversion between bounding box types and simple computations |
| dev-python/pyclibrary | C parser and ctypes automation for Python |
| dev-python/pycsdr | Python bindings for the csdr library |
| dev-python/pydantic-settings | Settings management using Pydantic |
| dev-python/pydigiham | Python bindings for the digiham library |
| dev-python/pyee | A port of node.js's EventEmitter to python. |
| dev-python/pyfiglet | An implementation of figlet written in Python |
| dev-python/pyglfw | Python bindings for GLFW |
| dev-python/pygmars | Craft simple regex-based small language lexers and parsers. Build parsers from grammars and accept Pygments lexers as an input. Derived from NLTK |
| dev-python/pygobject | Python bindings for GObject Introspection |
| dev-python/pylsqpack | Python bindings for ls-qpack |
| dev-python/pymaven-patch | Python access to maven. nexB advanced patch |
| dev-python/pymilvus | A Python SDK for Milvus |
| dev-python/pymunk | A Pythonic 2D rigid body physics library |
| dev-python/pyngrok | A Python wrapper for ngrok |
| dev-python/pynvml | Python Bindings for the NVIDIA Management Library |
| dev-python/py-partiql-parser | A tokenizer/parser/executor for the PartiQL-language |
| dev-python/pyperf | Toolkit to run Python benchmarks |
| dev-python/pypika | A SQL query builder API for Python |
| dev-python/pyreadline3 | Windows implementation of the GNU readline library Resources |
| dev-python/pysbd | 🐍💯pySBD (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box. |
| dev-python/py-stackexchange | A Python binding for the StackExchange API |
| dev-python/pytest-docker | Simple pytest fixtures for Docker and Docker Compose based tests |
| dev-python/pytest-markdown-docs | Run pytest on markdown code fence blocks |
| dev-python/pytest-raises | An implementation of pytest.raises as a pytest.mark fixture |
| dev-python/python-chess | A chess library for Python, with move generation and validation, PGN parsing and writing, Polyglot opening book reading, Gaviota tablebase probing, Syzygy tablebase probing, and UCI/XBoard engine communication |
| dev-python/python-crfsuite | A Python binding for CRFsuite |
| dev-python/python-decouple | Strict separation of config from code. |
| dev-python/python-iso639 | ISO 639 language codes |
| dev-python/python-oxmsg | Extract Outlook email messages and attachments from MSG files |
| dev-python/python-plexapi | Python bindings for the Plex API. |
| dev-python/python-pptx | Create Open XML PowerPoint documents in Python |
| dev-python/python-resize-image | A small Python package to easily resize images |
| dev-python/python-soxr | Fast and high quality sample-rate conversion library for Python |
| dev-python/python-uinput | Pythonic API to Linux uinput module |
| dev-python/pytorch-lightning | PyTorch Lightning is the lightweight PyTorch wrapper for ML researchers. Scale your models. Write less boilerplate. |
| dev-python/pytube | Python tools for downloading YouTube Videos |
| dev-python/pyv4l2 | A simple Video4Linux2 (v4l2) library for Python |
| dev-python/pyvips | Python bindings for libvips |
| dev-python/pyxlsb | Excel 2007+ Binary Workbook (xlsb) reader for Python |
| dev-python/qdrant-client | Python client for Qdrant vector search engine |
| dev-python/rank-bm25 | A collection of BM25 algorithms in Python |
| dev-python/RapidFuzz | Rapid fuzzy string matching in Python using various string metrics |
| dev-python/rapidocr-onnxruntime | A cross platform OCR Library based on OnnxRuntime |
| dev-python/realesrgan | Real-ESRGAN aims at developing practical algorithms for general image or video restoration |
| dev-python/red-black-tree-mod | Flexible python implementation of red black trees |
| dev-python/regipy | Python Registry Parser |
| dev-python/RestrictedPython | A subset of Python which allows program input into a trusted environment |
| dev-python/rife-ncnn-vulkan-python-tntwise | Video frame interpolation using the Real-Time Intermediate Flow Estimation (RIFE) algorithm, neural networks, and a Python wrapper |
| dev-python/rivalcfg | CLI tool and Python library to configure SteelSeries gaming mice |
| dev-python/rlax | A library of reinforcement learning building blocks in JAX. |
| dev-python/rlcard | Reinforcement Learning or AI bots for card games like Blackjack, Leduc, Texas, DouDizhu, Mahjong, UNO |
| dev-python/rocPyDecode | rocPyDecode is a set of Python bindings to rocDecode C++ library which provides full HW acceleration for video decoding on AMD GPUs |
| dev-python/rpm-inspector-rpm | A ScanCode path provider plugin to provide a prebuilt native rpm binary built with many rpm backend database formats supported. The rpm binary is built from sources that are bundled in the repo and sdist. |
| dev-python/RTFDE | RTFDE: RTF De-Encapsulator - A python3 library for extracting encapsulated `HTML ` & `plain text ` content from the `RTF ` bodies of .msg files |
| dev-python/runs | Run a block of text as a subprocess |
| dev-python/rust-inspector | A scancode plugin to extract symbols and dependencies found in Rust binaries |
| dev-python/saneyaml | Read and write readable YAML safely preserving order and avoiding bad surprises with unwanted infered type conversions |
| dev-python/scenedetect | 🎥 Python and OpenCV-based scene cut/transition detection program & library |
| dev-python/SciencePlots | Matplotlib styles for scientific plotting |
| dev-python/scipy | Scientific algorithms library for Python |
| dev-python/sentence-transformers | State-of-the-Art Text Embeddings |
| dev-python/setuptools-gettext | A setuptools plugin for building multilingual MO files |
| dev-python/setuptools-git-versioning | Use git repo data (latest tag, current commit hash, etc) for building a version number according PEP-440 |
| dev-python/shimmy | An API conversion tool for popular external reinforcement learning environments |
| dev-python/simple-parsing | A small utility for simplifying and cleaning up argument parsing scripts. |
| dev-python/soundfile | SoundFile is an audio library based on libsndfile, CFFI, and NumPy |
| dev-python/spacy | 💫 Industrial-strength Natural Language Processing (NLP) in Python |
| dev-python/spacy-legacy | 🕸️ Legacy architectures and other registered spaCy v3.x functions for backwards-compatibility |
| dev-python/spacy-loggers | 📟 Logging utilities for spaCy |
| dev-python/sphinx-theme-builder | Clean up the public namespace of your package! |
| dev-python/sqlmodel | SQL databases in Python, designed for simplicity, compatibility, and robustness |
| dev-python/srsly | 🦉 Modern high-performance serialization utilities for Python (JSON, MessagePack, Pickle) |
| dev-python/stasm | Python wrapper for finding features in faces |
| dev-python/statsmodels | Statistical computations and models for use with SciPy |
| dev-python/streaming-form-data | Streaming (and fast!) parser for multipart/form-data written in Cython |
| dev-python/sysv-ipc | System V IPC primitives (semaphores, shared memory and message queues) for Python |
| dev-python/tdir | Create, fill a temporary directory |
| dev-python/tf-keras | The TensorFlow-specific implementation of the Keras API |
| dev-python/thinc | 🔮 A refreshing functional take on deep learning, compatible with your favorite libraries |
| dev-python/tiktoken | tiktoken is a fast BPE tokeniser for use with OpenAI's models |
| dev-python/timm | PyTorch Image Models |
| dev-python/tomesd | Token merging for Stable Diffusion |
| dev-python/toml | A Python library for TOML |
| dev-python/torchdiffeq | Differentiable Ordinary Differential Equation (ODE) solvers with full GPU support and O(1)-memory backpropagation |
| dev-python/torchsde | Differentiable SDE solvers with GPU support and efficient sensitivity analysis |
| dev-python/trampoline | Simple and tiny yield-based trampoline implementation |
| dev-python/trfl | trfl is a library of building blocks for reinforcement learning algorithms. |
| dev-python/triton | Development repository for the Triton language and compiler |
| dev-python/triton | The Triton language and compiler |
| dev-python/typecode | Comprehensive filetype and mimetype detection using libmagic and Pygments |
| dev-python/typecode-libmagic | A ScanCode path provider plugin to provide a prebuilt native libmagic binary and database |
| dev-python/typer | Typer, build great CLIs. Easy to code. Based on Python type hints. |
| dev-python/types-aiofiles | Typing stubs for aiofiles |
| dev-python/types-dataclasses | Typing stubs for dataclasses |
| dev-python/types-toml | Typing stubs for toml |
| dev-python/typing-extensions | Backported and experimental type hints for Python |
| dev-python/ultralytics-thop | Ultralytics THOP package for fast computation of PyTorch model FLOPs and parameters |
| dev-python/ultralytics | Ultralytics YOLO 🚀 for SOTA object detection, multi-object tracking, instance segmentation, pose estimation and image classification |
| dev-python/unstructured-client | A Python client for the Unstructured hosted API |
| dev-python/unstructured | Open source libraries and APIs to build custom preprocessing pipelines for labeling, training, or production machine learning pipelines |
| dev-python/upscale-ncnn-py | Python bindings for upscaling using neural networks and Vulkan |
| dev-python/urlpy | Simple URL parsing, canonicalization and equivalence |
| dev-python/wandb | A CLI and library for interacting with the Weights & Biases API |
| dev-python/wasabi | 🍣 A lightweight console printing and formatting toolkit |
| dev-python/weasel | 🦦 weasel: A small and easy workflow system |
| dev-python/weaviate-client | A python native client for easy interaction with a Weaviate instance |
| dev-python/wrapt | Module for decorators, wrappers and monkey patching |
| dev-python/xformers | Hackable and optimized Transformers building blocks, supporting a composable construction |
| dev-python/xmod | Turn any object into a module |
| dev-python/youtube-transcript-api | A Python API which allows you to get the transcript/subtitles for a given YouTube video |
| dev-qt/qtbase | Cross-platform application development framework |
| dev-qt/qtdeclarative | Qt Declarative (Quick 2) |
| dev-qt/qtimageformats | Additional format plugins for the Qt image I/O system |
| dev-qt/qtmultimedia | Multimedia (audio, video, radio, camera) library for the Qt6 framework |
| dev-qt/qtsvg | SVG rendering library for the Qt6 framework |
| dev-qt/qtwayland | Wayland platform plugin for Qt |
| dev-qt/qtwebengine | Library for rendering dynamic web content in Qt6 C++ and QML applications |
| dev-ruby/libcaca | A library that creates colored ASCII-art graphics |
| dev-util/amd-smi | ROCm Application for Reporting System Info |
| dev-util/android-ndk | The Android Native Development Kit |
| dev-util/android-sdk-build-tools | Android SDK Build-Tools |
| dev-util/android-sdk-commandlinetools | Android SDK Command-line Tools |
| dev-util/android-sdk-platform-tools | Android SDK Platform |
| dev-util/bear | Bear is a tool that generates a compilation database for clang tooling. |
| dev-util/binaryen | Compiler infrastructure and toolchain library for WebAssembly |
| dev-util/carbon-now-cli | Beautiful images of your code from right inside your terminal. |
| dev-util/closure-compiler-npm | Check, compile, optimize and compress Javascript with Closure-Compiler |
| dev-util/DOCA-Host | DOCA-Host |
| dev-util/dyninst | DyninstAPI: Tools for binary instrumentation, analysis, and modification. |
| dev-util/emscripten | LLVM-to-JavaScript Compiler |
| dev-util/geany | GTK+ based fast and lightweight IDE |
| dev-util/grex | grex generates regular expressions from user-provided test cases. |
| dev-util/gycm | A Geany plugin to support the ycmd code completion server |
| dev-util/hip | C++ Heterogeneous-Compute Interface for Portability |
| dev-util/hipfort | Fortran interfaces for ROCm libraries |
| dev-util/HIPIFY | HIPIFY: Convert CUDA to Portable C++ Code |
| dev-util/hip-meta | HIP metapackage |
| dev-util/jsonlint | JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript. |
| dev-util/omniperf | Advanced Profiling and Analytics for AMD Hardware |
| dev-util/omnitrace | Omnitrace: Application Profiling, Tracing, and Analysis |
| dev-util/pnnx | pnnx is an open standard for PyTorch model interoperability |
| dev-util/ROCgdb | Heterogeneous debugging for x86 and AMDGPU on ROCm™ software |
| dev-util/rocm_bandwidth_test | Bandwidth test for ROCm |
| dev-util/rocminfo | ROCm Application for Reporting System Info |
| dev-util/rocm-meta | ROCm metapackage |
| dev-util/rocm-smi | ROCm System Management Interface Library |
| dev-util/rocm-validation-suite | The ROCm Validation Suite is a system administrator’s and cluster manager's tool for detecting and troubleshooting common problems affecting AMD GPU(s) running in a high-performance computing environment. |
| dev-util/rocprofiler | The ROC profiler library for profiling with perf-counters and derived metrics |
| dev-util/roctracer | Callback/Activity Library for Performance tracing AMD GPU's |
| dev-util/scancode-toolkit | ScanCode detects licenses, copyrights, package manifests, direct dependencies, and more |
| dev-util/synp | Convert yarn.lock to package-lock.json and vice versa |
| dev-util/tbump | tbump helps you bump the version of your project easily |
| dev-util/Tensile | Stretching GPU performance for GEMMs and tensor contractions |
| dev-util/theia | Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript. |
| dev-util/uglifyjs | JavaScript parser / mangler / compressor / beautifier toolkit |
| dev-util/ycmd | A code-completion & code-comprehension server |
| dev-util/ycm-generator | Generates config files for YouCompleteMe |
| dev-vcs/breezy | Breezy is a friendly powerful distributed version control system. |
| dev-vcs/git | Stupid content tracker: distributed VCS designed for speed and efficiency |
| games-engines/box2d | Box2D is a 2D physics engine for games |
| games-rpg/RisuAI | Make your own story. User-friendly software for LLM roleplaying |
| gnome-base/librsvg | Scalable Vector Graphics (SVG) rendering library |
| gui-apps/taigo | A virtual pet for your desktop built with GTK+, Vala, and love. |
| gui-apps/windowpet | Adorable anime pet companions on your screen |
| gui-libs/gtk | GTK is a multi-platform toolkit for creating graphical user interfaces |
| gui-libs/libdecor | A client-side decorations library for Wayland clients |
| gui-wm/hyprland | A dynamic tiling Wayland compositor that doesn't sacrifice on its looks |
| gui-wm/sway | i3-compatible Wayland window manager |
| llvm-core/clang | C language family frontend for LLVM |
| llvm-core/clang-common | Common files shared between multiple slots of clang |
| llvm-core/lld | The LLVM linker (link editor) |
| llvm-core/llvm-common | Common files shared between multiple slots of LLVM |
| llvm-core/llvm | Low Level Virtual Machine |
| llvm-core/mlir | Multi Level Intermediate Representation for LLVM |
| llvm-core/pstl | Parallel STL is an implementation of the C++ standard library algorithms with support for execution policies |
| llvm-runtimes/clang-runtime | A meta-ebuild for the Clang runtime libraries |
| llvm-runtimes/clang-runtime | Meta-ebuild for clang runtime libraries |
| llvm-runtimes/compiler-rt | Compiler runtime library for clang (built-in part) |
| llvm-runtimes/compiler-rt-sanitizers | Compiler runtime libraries for clang (sanitizers & xray) |
| llvm-runtimes/compiler-rt-sanitizers-logging | Enable/disable sanitizer system-wide |
| llvm-runtimes/libcxxabi | Low level support for a standard C++ library |
| llvm-runtimes/libcxx | New implementation of the C++ standard library, targeting C++11 |
| llvm-runtimes/libunwind | C++ runtime stack unwinder from LLVM |
| llvm-runtimes/openmp | OpenMP runtime library for LLVM/clang compiler |
| media-fonts/noto-color-emoji-bin | A prebuilt font for colored emojis |
| media-fonts/noto-color-emoji-config | A minimal config for using Noto colored emojis |
| media-fonts/noto-emoji | A redirect or compatibility package to noto-color-emoji-bin |
| media-gfx/alembic | Alembic is an open framework for storing and sharing scene data that includes a C++ library, a file format, and client plugins and applications. |
| media-gfx/blockbench | Blockbench is a boxy 3D model editor |
| media-gfx/dssim | Image similarity comparison simulating human perception |
| media-gfx/face-morpher-plus | Face morpher plus based on facemorpher |
| media-gfx/gimp | GNU Image Manipulation Program |
| media-gfx/gmic | GREYC's Magic for Image Computing: A full-featured open-source framework for image processing |
| media-gfx/gmic-qt | G'MIC-Qt is a versatile frontend to the image processing framework G'MIC |
| media-gfx/graphite2 | Library providing rendering capabilities for complex non-Roman writing systems |
| media-gfx/imagemagick | A collection of tools and libraries for many image formats |
| media-gfx/inkscape | SVG based generic vector-drawing program |
| media-gfx/material-maker | A procedural textures authoring and 3D model painting tool based on the Godot game engine |
| media-gfx/openvdb | Library for the efficient manipulation of volumetric data |
| media-gfx/upscayl-custom-models | Extra custom models for Upscayl. |
| media-gfx/upscayl | Upscayl is an AI based image upscaler |
| media-gfx/voltaml-fast-stable-diffusion | A beautiful and easy to use Stable Diffusion web user interface |
| media-libs/alure | The OpenAL Utility Toolkit |
| media-libs/aras-p-opencollada | OpenCOLLADA Cleanup Fork |
| media-libs/assimp | Importer library to import assets from 3D files |
| media-libs/cgif | A fast and lightweight GIF encoder |
| media-libs/cimg | C++ template image processing toolkit |
| media-libs/csfml | The official binding of SFML for C |
| media-libs/dav1d | dav1d is an AV1 Decoder :) |
| media-libs/embree | Collection of high-performance ray tracing kernels |
| media-libs/flac | free lossless audio encoder and decoder |
| media-libs/fontconfig | A library for configuring and customizing font access |
| media-libs/freetype | High-quality and portable font engine |
| media-libs/glui | GLUI User Interface Library |
| media-libs/gst-plugins-bad | A set of bad plugins that fall short of code quality or support needs of GStreamer |
| media-libs/gst-plugins-base | A based set of plugins meeting code quality and support needs of GStreamer |
| media-libs/gst-plugins-good | A set of good plugins that meet licensing, code quality, and support needs of GStreamer |
| media-libs/gst-plugins-ugly | A set of ugly plugins that may have patent or licensing issues for GStreamer and distributors |
| media-libs/gstreamer | Open source multimedia framework |
| media-libs/gst-rtsp-server | A GStreamer based RTSP server library |
| media-libs/harfbuzz | An OpenType text shaping engine |
| media-libs/HIPRT | HIP RT is a ray tracing library in HIP |
| media-libs/imlib2 | Version 2 of an advanced replacement library for libraries like libXpm |
| media-libs/libaom | Alliance for Open Media AV1 Codec SDK |
| media-libs/libcaca | A library that creates colored ASCII-art graphics |
| media-libs/libdicom | C library for reading DICOM files |
| media-libs/libexif | Library for parsing, editing, and saving EXIF data |
| media-libs/libfishsound | Simple programming interface to decode and encode audio with vorbis or speex |
| media-libs/libheif | A HEIF and AVIF file format decoder and encoder |
| media-libs/libjpeg-turbo | MMX, SSE, and SSE2 SIMD accelerated JPEG library |
| media-libs/libmediainfo | MediaInfo libraries |
| media-libs/libogg | The Ogg media file format library |
| media-libs/libplacebo | Reusable library for GPU-accelerated image processing primitives |
| media-libs/libpng | Portable Network Graphics library |
| media-libs/libsdl2 | Simple Direct Media Layer |
| media-libs/libsfml | Simple and Fast Multimedia Library (SFML) |
| media-libs/libspng | libspng is a C library for reading and writing Portable Network Graphics (PNG) format files with a focus on security and ease of use. |
| media-libs/libtheora | The Theora Video Compression Codec |
| media-libs/libvorbis | The Ogg Vorbis sound file format library |
| media-libs/libvpx | WebM VP8 and VP9 Codec SDK |
| media-libs/libwebp | A lossy image compression format |
| media-libs/libyuv | libyuv is an open source project that includes YUV scaling and conversion functionality. |
| media-libs/libzen | Shared library for libmediainfo and mediainfo |
| media-libs/materialx | MaterialX is an open standard for the exchange of rich material and look-development content across applications and renderers. |
| media-libs/mesa | OpenGL-like graphic library for Linux |
| media-libs/mlt-flowblade | MLT Multimedia Framework for the flowblade ebuild |
| media-libs/mojoshader | Use Direct3D shaders with other 3D rendering APIs. |
| media-libs/nifti_clib | C libraries for NIFTI support |
| media-libs/oidn | Intel® Open Image Denoise library |
| media-libs/opencolorio | A color management framework for visual effects and animation |
| media-libs/opencv | A collection of algorithms and sample code for various computer vision problems |
| media-libs/openexr | ILM's OpenEXR high dynamic-range image file format libraries |
| media-libs/openimageio | A library for reading and writing images |
| media-libs/openpgl | Implements a set of representations and training algorithms needed to integrate path guiding into a renderer |
| media-libs/openslide | C library with simple interface to read virtual slides |
| media-libs/opensubdiv | A subdivision surface library |
| media-libs/opentimelineio | An interchange format for editorial timeline information |
| media-libs/openusd | Universal Scene Description is a system for 3D scene interexchange between apps |
| media-libs/openxr | Generated headers and sources for OpenXR loader. |
| media-libs/opusfile | A high-level decoding and seeking API for .opus files |
| media-libs/opus | Open codec for interactive speech and music transmission over the Internet |
| media-libs/osl | Advanced shading language for production GI renderers |
| media-libs/partio | Library for particle IO and manipulation |
| media-libs/sharp-libvips | libvips static build for sharp, matching sharp-libvips |
| media-libs/speex | Audio compression format designed for speech |
| media-libs/theoraplay | TheoraPlay is a simple library to make decoding of Ogg Theora videos easier. |
| media-libs/tremor | A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec) |
| media-libs/vaapi-drivers | A metapackage for libva drivers |
| media-libs/vips | VIPS Image Processing Library |
| media-libs/vulkan-drivers | Vulkan drivers |
| media-libs/woff2 | Encode/decode WOFF2 font format |
| media-plugins/filmic-blender | Film Emulsion-Like Camera Rendering Transforms for Blender® |
| media-plugins/gst-plugins-a52dec | ATSC A/52 audio decoder plugin for GStreamer |
| media-plugins/gst-plugins-aalib | aalib text console plugin for GStreamer |
| media-plugins/gst-plugins-adaptivedemux2 | Adaptive demuxer plugins for GStreamer |
| media-plugins/gst-plugins-aes | AES encryption/decryption plugin for GStreamer |
| media-plugins/gst-plugins-amr | AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer |
| media-plugins/gst-plugins-analyticsoverlay | The analyticsoverlay plugin can highlight and assign AI categorized labels to detected objects for GStreamer |
| media-plugins/gst-plugins-aom | Alliance for Open Media AV1 plugin for GStreamer |
| media-plugins/gst-plugins-assrender | ASS/SSA rendering with effects support plugin for GStreamer |
| media-plugins/gst-plugins-avtp | Audio/Video Transport Protocol (AVTP) plugin for GStreamer |
| media-plugins/gst-plugins-aws | A redirect ebuild for gst-plugins-aws |
| media-plugins/gst-plugins-bluez | AVDTP source/sink and A2DP sink plugin for GStreamer |
| media-plugins/gst-plugins-bs2b | bs2b elements for GStreamer |
| media-plugins/gst-plugins-cairo | Video overlay plugin based on cairo for GStreamer |
| media-plugins/gst-plugins-cdg | A redirect ebuild for gst-plugins-cdg |
| media-plugins/gst-plugins-cdio | A libcdio based CD Digital Audio (CDDA) source plugin for GStreamer |
| media-plugins/gst-plugins-cdparanoia | A cdparanoia based CD Digital Audio (CDDA) source plugin for GStreamer |
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
| media-plugins/gst-plugins-dts | DTS audio decoder plugin for GStreamer |
| media-plugins/gst-plugins-dvb | DVB device capture plugin for GStreamer |
| media-plugins/gst-plugins-dvdread | DVD read plugin for GStreamer |
| media-plugins/gst-plugins-dv | DV demuxer and decoder plugin for GStreamer |
| media-plugins/gst-plugins-elevenlabs | A redirect ebuild for gst-plugins-elevenlabs |
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
| media-plugins/gst-plugins-gopbuffer | A redirect ebuild for gst-plugins-gopbuffer |
| media-plugins/gst-plugins-gs | Elements to interact with Google Cloud Storage for GStreamer |
| media-plugins/gst-plugins-gsm | GSM plugin for GStreamer |
| media-plugins/gst-plugins-gtk4 | A redirect ebuild for gst-plugins-gtk4 |
| media-plugins/gst-plugins-gtk | Video sink plugin for GStreamer that renders to a GtkWidget |
| media-plugins/gst-plugins-hls | HTTP live streaming plugin for GStreamer |
| media-plugins/gst-plugins-hlsmultivariantsink | A redirect ebuild for gst-plugins-hlsmultivariantsink |
| media-plugins/gst-plugins-hlssink3 | A redirect ebuild for gst-plugins-hlssink3 |
| media-plugins/gst-plugins-hsv | A redirect ebuild for gst-plugins-hsv |
| media-plugins/gst-plugins-iqa | Image quality assessment plugin for GStreamer |
| media-plugins/gst-plugins-isac | iSAC plugin for GStreamer |
| media-plugins/gst-plugins-jack | JACK audio server source/sink plugin for GStreamer |
| media-plugins/gst-plugins-jpeg | JPEG image encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-json | A redirect ebuild for gst-plugins-json |
| media-plugins/gst-plugins-ladspa | Ladspa elements for GStreamer |
| media-plugins/gst-plugins-lame | MP3 encoder plugin for GStreamer |
| media-plugins/gst-plugins-lc3 | LC3 (Bluetooth) LE audio codec plugin for GStreamer |
| media-plugins/gst-plugins-ldac | LDAC plugin for GStreamer |
| media-plugins/gst-plugins-lewton | A redirect ebuild for gst-plugins-lewton |
| media-plugins/gst-plugins-libav | A FFmpeg based GStreamer plugin |
| media-plugins/gst-plugins-libcaca | libcaca text console plugin for GStreamer |
| media-plugins/gst-plugins-libde265 | H.265 decoder plugin for GStreamer |
| media-plugins/gst-plugins-libnice | GStreamer plugin for ICE (RFC 5245) support |
| media-plugins/gst-plugins-libpng | PNG image encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-libvisual | Visualization elements for GStreamer |
| media-plugins/gst-plugins-livesync | A redirect ebuild for gst-plugins-livesync |
| media-plugins/gst-plugins-lv2 | LV2 elements for GStreamer |
| media-plugins/gst-plugins-mdns | A device provider plugin and RTSP server discovery for GStreamer |
| media-plugins/gst-plugins-meta | A metapackage to pull in gst plugins for apps |
| media-plugins/gst-plugins-modplug | MOD audio decoder plugin for GStreamer |
| media-plugins/gst-plugins-mp4 | A redirect ebuild for gst-plugins-mp4 |
| media-plugins/gst-plugins-mpeg2dec | MPEG2 decoder plugin for GStreamer |
| media-plugins/gst-plugins-mpeg2enc | MPEG-1/2 video encoding plugin for GStreamer |
| media-plugins/gst-plugins-mpegtslive | A redirect ebuild for gst-plugins-mpegtslive |
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
| media-plugins/gst-plugins-originalbuffer | A redirect ebuild for gst-plugins-originalbuffer |
| media-plugins/gst-plugins-oss | OSS (Open Sound System) support plugin for GStreamer |
| media-plugins/gst-plugins-pulse | PulseAudio sound server plugin for GStreamer |
| media-plugins/gst-plugins-qroverlay | Overlay QR codes on an element from a buffer for GStreamer |
| media-plugins/gst-plugins-qt6 | A Qt6 video sink plugin for GStreamer |
| media-plugins/gst-plugins-qt | A Qt5 video sink plugin for GStreamer |
| media-plugins/gst-plugins-quinn | A redirect ebuild for gst-plugins-quinn |
| media-plugins/gst-plugins-raptorq | A redirect ebuild for gst-plugins-raptorq |
| media-plugins/gst-plugins-rav1e | A redirect ebuild for gst-plugins-rav1e |
| media-plugins/gst-plugins-raw1394 | A FireWire DV/HDV capture plugin for GStreamer |
| media-plugins/gst-plugins-regex | A redirect ebuild for gst-plugins-regex |
| media-plugins/gst-plugins-reqwest | A redirect ebuild for gst-plugins-reqwest |
| media-plugins/gst-plugins-resindvd | DVD playback support plugin for GStreamer |
| media-plugins/gst-plugins-rsanalytics | A redirect ebuild for gst-plugins-analytics |
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
| media-plugins/gst-plugins-rs | Various GStreamer plugins written in Rust |
| media-plugins/gst-plugins-rsvg | SVG overlay and decoder plugin for GStreamer |
| media-plugins/gst-plugins-rsvideofx | A redirect ebuild for gst-plugins-videofx |
| media-plugins/gst-plugins-rswebp | A redirect ebuild for gst-plugins-webp (Rust implementation) |
| media-plugins/gst-plugins-rswebrtc | A redirect ebuild for gst-plugins-webrtc (Rust implementation) |
| media-plugins/gst-plugins-rtmp | RTMP source/sink plugin for GStreamer |
| media-plugins/gst-plugins-sbc | SBC encoder and decoder plugin for GStreamer |
| media-plugins/gst-plugins-sctp | SCTP plugins for GStreamer |
| media-plugins/gst-plugins-shout2 | Icecast server sink plugin for GStreamer |
| media-plugins/gst-plugins-sidplay | Sid decoder plugin for GStreamer |
| media-plugins/gst-plugins-skia | A redirect ebuild for gst-plugins-skia |
| media-plugins/gst-plugins-smoothstreaming | Smooth Streaming plugin for GStreamer |
| media-plugins/gst-plugins-sndfile | libsndfile plugin for GStreamer |
| media-plugins/gst-plugins-sndio | Sndio audio sink and source for GStreamer |
| media-plugins/gst-plugins-sodium | A redirect ebuild for gst-plugins-sodium |
| media-plugins/gst-plugins-soundtouch | Beats-per-minute detection and pitch controlling plugin for GStreamer |
| media-plugins/gst-plugins-soup | HTTP client source/sink plugin for GStreamer |
| media-plugins/gst-plugins-spandsp | Packet loss concealment audio plugin for GStreamer |
| media-plugins/gst-plugins-speechmatics | A redirect ebuild for gst-plugins-speechmatics |
| media-plugins/gst-plugins-speex | Speex encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-spotify | A redirect ebuild for gst-plugins-spotify |
| media-plugins/gst-plugins-srtp | SRTP encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-srt | Secure reliable transport (SRT) transfer plugin for GStreamer |
| media-plugins/gst-plugins-streamgrouper | A redirect ebuild for gst-plugins-streamgrouper |
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
| media-plugins/gst-plugins-vvdec | A redirect ebuild for gst-plugins-vvdec |
| media-plugins/gst-plugins-wavpack | Wavpack audio encoder/decoder plugin for GStreamer |
| media-plugins/gst-plugins-webp | WebP image format support for GStreamer |
| media-plugins/gst-plugins-webrtchttp | A redirect ebuild for gst-plugins-webrtchttp |
| media-plugins/gst-plugins-webrtc | WebRTC plugins for GStreamer |
| media-plugins/gst-plugins-wildmidi | WildMIDI soft synth plugin for GStreamer |
| media-plugins/gst-plugins-wpe | WPE Web browser plugin for GStreamer |
| media-plugins/gst-plugins-x264 | H.264 encoder plugin for GStreamer |
| media-plugins/gst-plugins-x265 | H.265 encoder plugin for GStreamer |
| media-plugins/gst-plugins-ximagesrc | X11 video capture stream plugin for GStreamer |
| media-plugins/gst-plugins-zbar | Bar codes detection in video streams for GStreamer |
| media-plugins/gst-plugins-zxing | Barcode image scanner plugin using zxing-cpp for GStreamer |
| media-plugins/imlib2_loaders | Additional image loaders for Imlib2 |
| media-plugins/openvino-ai-plugins-gimp | GIMP AI plugins with OpenVINO Backend |
| media-radio/codecserver | Modular audio codec server |
| media-radio/csdr | A simple DSP library and command-line tool for Software Defined Radio. |
| media-radio/digiham | Tools for decoding digital ham communication |
| media-radio/dream | A software radio for AM and Digital Radio Mondiale (DRM) |
| media-radio/hpsdrconnector | An OpenWebRX connector for HPSDR radios |
| media-radio/m17-cxx-demod | M17 Demodulator in C++ |
| media-radio/openwebrx | A multi-user Software Defined Radio (SDR) receiver software with a web interface |
| media-radio/owrx_connector | A direct connection layer for OpenWebRX |
| media-radio/runds_connector | OpenWebRX connector implementation for R&S EB200 or Ammos protocol based receivers |
| media-radio/sddc_connector | Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on libsddc |
| media-sound/puddletag | An audio tag editor |
| media-sound/spotify | A social music platform |
| media-sound/w3crapcli-lastfm | w3crapcli/last.fm provides a command line interface for the last.fm web service |
| media-video/blurfaces | Blurs faces in video |
| media-video/dashcam_anonymizer | Blur human faces and vehicle license plates in video and images |
| media-video/deface | Video anonymization by face detection |
| media-video/ffmpeg | Complete solution to record/convert/stream audio and video. Includes libavcodec |
| media-video/flowblade | Non-linear video editor |
| media-video/gspca_ep800 | Kernel Modules for Endpoints EP800/SE402/SE401* |
| media-video/linux-enable-ir-emitter | Provides support for infrared cameras that are not directly enabled out-of-the box. |
| media-video/lossless-cut | The swiss army knife of lossless video/audio editing |
| media-video/mpv | Media player for the command line |
| media-video/nudenet_video | A Python script to detect and blur explicit nudity in videos using NudeNet and FFmpeg |
| media-video/obs-studio | Software for live streaming and screen recording |
| media-video/olive | Professional open-source non-linear video editor |
| media-video/REAL-Video-Enhancer | Interpolate for faster framerates and AI upscale video easily |
| media-video/video2x | A machine learning based video super resolution and frame interpolation framework |
| media-video/video2x-qt6 | An AI video upscaler with a graphical user friendly Qt6 frontend |
| net-im/caprine | Elegant Facebook Messenger desktop app |
| net-im/chatterino | Chat client for https://twitch.tv |
| net-im/signal-desktop | Allows you to send and receive messages of Signal Messenger on your computer |
| net-libs/cef-bin | Chromium Embedded Framework (CEF) is a simple framework for embedding Chromium-based browsers in other applications. |
| net-libs/gnutls | A secure communications library implementing the SSL, TLS and DTLS protocols |
| net-libs/google-cloud-cpp | Google Cloud Client Library for C++ |
| net-libs/grpc | Modern open source high performance RPC framework |
| net-libs/libavtp | Open source implementation of Audio Video Transport Protocol (AVTP) specified in IEEE 1722-2016 spec. |
| net-libs/librist | Reliable Internet Streaming Transport |
| net-libs/libsoup | HTTP client/server library for GNOME |
| net-libs/nghttp2 | HTTP/2 C Library |
| net-libs/nodejs | A JavaScript runtime built on the V8 JavaScript engine |
| net-libs/Thunder | Thunder (aka WPEFramework) |
| net-libs/webkit-gtk | Open source web browser engine (GTK+3 with HTTP/1.1 support) |
| net-libs/webkit-gtk | Open source web browser engine (GTK+3 with HTTP/2 support) |
| net-libs/webkit-gtk | Open source web browser engine (GTK 4 with HTTP/2 support) |
| net-misc/curl | A Client that groks URLs |
| net-misc/OCDM-Clearkey | ClearKey OpenCDM(i) plugin |
| net-misc/ThunderClientLibraries | Thunder supporting libraries |
| net-misc/ThunderInterfaces | Thunder interface definitions |
| net-misc/ThunderNanoServices | Thunder NanoServices & AppEngines (aka WPEFrameworkPlugins) |
| net-misc/ThunderTools | Thunder (aka WPEFramework) |
| net-misc/ThunderUI | ThunderUI is the development and test UI that runs on top of Thunder |
| net-misc/wget | Network utility to retrieve files from the WWW |
| sci-geosciences/google-earth-pro | A 3D interface to the planet |
| sci-libs/composable-kernel | Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators |
| sci-libs/ctranslate2 | Fast inference engine for Transformer models |
| sci-libs/dlib | Numerical and networking C++ library |
| sci-libs/hipBLASLt | hipBLASLt is a library that provides general matrix-matrix operations with a flexible API and extends functionalities beyond a traditional BLAS library |
| sci-libs/hipBLAS | ROCm BLAS marshalling library |
| sci-libs/hipCUB | Wrapper of rocPRIM or CUB for GPU parallel primitives |
| sci-libs/hipFFT | CU / ROCM agnostic hip FFT implementation |
| sci-libs/hipRAND | CU / ROCM agnostic hip RAND implementation |
| sci-libs/hipSOLVER | ROCm SOLVER marshalling library |
| sci-libs/hipSPARSELt | hipSPARSELt is a SPARSE marshalling library, with multiple supported backends. |
| sci-libs/hipSPARSE | ROCm SPARSE marshalling library |
| sci-libs/hipTensor | AMD’s C++ library for accelerating tensor primitives |
| sci-libs/MIGraphX | AMD's graph optimization engine |
| sci-libs/miopen | AMD's Machine Intelligence Library |
| sci-libs/miopenkernels | Prebuilt kernels to reduce startup latency |
| sci-libs/MIVisionX | MIVisionX toolkit is a set of comprehensive computer vision and machine intelligence libraries, utilities, and applications bundled into a single toolkit. |
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
| sci-libs/rocThrust | A ported Thrust parallel library for AMD GPUs |
| sci-libs/rocWMMA | AMD's C++ library for accelerating mixed-precision matrix multiply-accumulate (MMA) operations leveraging AMD GPU hardware |
| sci-libs/rpp | AMD ROCm Performance Primitives (RPP) library is a comprehensive high-performance computer vision library for AMD processors with HIP/OpenCL/CPU back-ends. |
| sci-libs/tensorstore | Library for reading and writing large multi-dimensional arrays |
| sci-ml/caffe2 | A deep learning framework |
| sci-ml/FBGEMM | Facebook GEneral Matrix Multiplication |
| sci-ml/huggingface_hub | The official Python client for the Huggingface Hub |
| sci-ml/intel-extension-for-pytorch | A Python package for extending the official PyTorch that can easily obtain performance on Intel platform |
| sci-ml/kineto | A CPU+GPU Profiling library that provides access to timeline traces and hardware performance counters |
| sci-ml/nnef-models | A collection of neural network NNEF models for image recognition and classification |
| sci-ml/onnxruntime | Cross-platform inference and training machine-learning accelerator. |
| sci-ml/openvino | OpenVINO™ is an open-source toolkit for optimizing and deploying AI inference |
| sci-ml/pytorch | Tensors and dynamic neural networks in Python |
| sci-ml/sentencepiece | Unsupervised text tokenizer for neural network based text generation |
| sci-ml/tensorflow | Computation framework using data flow graphs for scalable machine learning |
| sci-ml/tensorflow-datasets | TFDS is a collection of datasets ready to use with TensorFlow, Jax, ... |
| sci-ml/tensorflow-estimator | A high-level TensorFlow API that greatly simplifies machine learning programming |
| sci-ml/tensorflow-hub | Clean up the public namespace of your package! |
| sci-ml/tensorflow-io | Dataset, streaming, and file system extensions maintained by TensorFlow SIG-IO |
| sci-ml/tensorflow-metadata | Utilities for passing TensorFlow related metadata between tools |
| sci-ml/tensorflow-probability | Probabilistic reasoning and statistical analysis in TensorFlow |
| sci-ml/tensorflow-text | Text processing in TensorFlow |
| sci-ml/tf-models-official | Models and examples built with TensorFlow |
| sci-ml/tf-slim | TensorFlow-Slim: A lightweight library for defining, training and evaluating complex models in TensorFlow |
| sci-ml/torchaudio | Data manipulation and transformation for audio signal processing, powered by PyTorch |
| sci-ml/torchmetrics | PyTorch native Metrics |
| sci-ml/torchvision | Datasets, transforms and models to specific to computer vision |
| sci-ml/transformers | State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow |
| sci-ml/XNNPACK | library of floating-point neural network inference operators |
| sci-physics/bullet | Continuous Collision Detection and Physics Library |
| sci-physics/mujoco | MuJoCo (Multi-Joint dynamics with Contact) is a general purpose physics simulator. |
| sci-visualization/tensorboard-data-server | Fast data loading for TensorBoard |
| sci-visualization/tensorboard-plugin-profile | Clean up the public namespace of your package! |
| sci-visualization/tensorboard-plugin-wit | What-If Tool TensorBoard plugin |
| sci-visualization/tensorboard | TensorFlow's Visualization Toolkit |
| sci-visualization/tensorboardx | TensorBoardX lets you watch tensors flow without TensorFlow |
| sys-apps/bubblewrap | Unprivileged sandboxing tool, namespaces-powered chroot-like solution |
| sys-apps/c2tcp | C2TCP: A Flexible Cellular TCP to Meet Stringent Delay Requirements. |
| sys-apps/cellular-traces-nyc | Cellular Traces Collected in New York City for different scenarios |
| sys-apps/cellular-traces-y2018 | Cellular Traces Collected in New York City for different scenarios |
| sys-apps/coolercontrol | Cooling device control for Linux |
| sys-apps/coolercontrold | The CoolerControl system service that handles controlling hardware |
| sys-apps/coolercontrol-qt6 | A standalone desktop app for CoolerControl based on Qt6 |
| sys-apps/deepcc | DeepCC: A Deep Reinforcement Learning Plug-in to Boost the performance of your TCP scheme in Cellular Networks! |
| sys-apps/evhz | Show mouse refresh rate under linux + evdev |
| sys-apps/finit-d | finit.d/*.conf files for the Finit init system |
| sys-apps/finit | Fast init for Linux. Cookies included |
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
| sys-devel/aocc | The AOCC compiler system |
| sys-devel/llvm-roc-alt | AOCC for ROCm™ |
| sys-devel/llvm-roc-alt-symlinks | llvm-roc-alt symlinks |
| sys-devel/llvm-roc-symlinks | llvm-roc symlinks |
| sys-devel/llvm-roc | The ROCm™ fork of the LLVM project |
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
| sys-libs/libbacktrace | C library that may be linked into a C/C++ program to produce symbolic backtraces |
| sys-libs/llvm-roc-libomp | The ROCm™ fork of LLVM's libomp |
| sys-libs/zlib | Standard (de)compression library |
| sys-power/cpupower-gui | This program is designed to allow you to change the frequency limits of your cpu and its governor similar to cpupower. |
| sys-process/nvtop | GPU & Accelerator process monitoring |
| sys-process/psdoom-ng | A First Person Shooter (FPS) process killer |
| virtual/kfd-lb | KFD (Kernel Fusion Driver) with version limited lower boundary |
| virtual/kfd | The Kernel Fusion Driver (KFD) |
| virtual/kfd-ub | KFD (Kernel Fusion Driver) with version limited upper boundary |
| virtual/linux-sources | Virtual for Linux kernel sources |
| virtual/ot-sources-lts | Virtual for the ot-sources LTS ebuilds for |
| virtual/ot-sources-stable | Virtual for the ot-sources stable ebuilds |
| virtual/patent-status | A virtual package for patent status consistency across ebuilds |
| virtual/pillow | Virtual for Python Pillow packages |
| virtual/tmpfiles | Virtual to select between different tmpfiles.d handlers |
| www-apps/lobe-chat | A modern-design progressive web app supporting AI chat, function call plugins, multiple open/closed LLM models, RAG, TTS, vision |
| www-apps/open-webui | A user-friendly AI interface with web search RAG, document RAG, AI image generation, Ollama, OpenAI API support |
| www-apps/xpra-html5 | HTML5 client for Xpra |
| www-client/chromium-sources | Chromium sources |
| www-client/chromium | The open-source version of the Chrome web browser |
| www-client/chromium-toolchain | The Chromium toolchain (Clang + Rust + gn) |
| www-client/firefox | Firefox Web Browser |
| www-client/surf | A simple web browser based on WebKitGTK |
| www-misc/ddgr | DuckDuckGo from the terminal |
| www-misc/mahimahi | Web performance measurement toolkit |
| www-misc/socli | A search and browse Stack Overflow command line terminal client |
| www-servers/civetweb | CivetWeb is an embedded C++ web server |
| x11-base/xorg-server | X.Org X servers |
| x11-libs/cairo | A vector graphics library with cross-device output support |
| x11-libs/gdk-pixbuf | Image loading library for GTK+ |
| x11-libs/gtk+ | Gimp ToolKit + |
| x11-libs/libX11 | X.Org X11 library |
| x11-libs/pango | Internationalized text layout and rendering library |
| x11-libs/pixman | Low-level pixel manipulation routines |
| x11-libs/startup-notification | Application startup notification and feedback library |
| x11-libs/vte | Library providing a virtual terminal emulator widget |
| x11-misc/aprs-symbols | An Automatic Packet Reporting System (APRS) symbol set for amateur radio maps |
| x11-misc/copyq | Clipboard manager with advanced features |
| x11-misc/sddm | Simple Desktop Display Manager |
| x11-misc/xsnow | Let it snow on your desktop and windows |
| x11-themes/paper-icon-theme | Paper Icon Theme |
| x11-wm/dwm | A dynamic window manager for X11 |
| x11-wm/xpra | X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy |

### Contributing ebuilds

See [CONTRIBUTING.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/CONTRIBUTING.md)
