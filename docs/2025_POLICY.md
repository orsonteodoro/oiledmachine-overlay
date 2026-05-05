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

| USE flag         | LTS or rolling? [1] | Indirect libstdc++ compatibility                                                                                            | Default C++     |
|------------------|---------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------|
| gcc_slot_11_5    | LTS                 | U22 (EOL 2027), CUDA 12.6, CUDA 12.8, CUDA 12.9                                                                             | C++17           |
| gcc_slot_12_5    | LTS                 | D12 (EOL 2028), F37, CUDA 12.6, CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0                                                    | C++17           |
| gcc_slot_13_4    | LTS                 | U24 (EOL 2036), CUDA-12.6, CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0                                                         | C++17           |
| gcc_slot_14_3    | LTS                 | D13 (EOL 2030), F41, CUDA 12.8, CUDA 12.9                                                                                   | C++17           |

| USE flag [3] [4] | LTS or rolling?     | Indirect Clang/LLVM compatibility                                                                                           | Default C++ [2] |
|------------------|---------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------|
| llvm_slot_18     | LTS                 | U24, CUDA 12.6, CUDA 12.8, CUDA 12.9                                                                                        | C++17           |
| llvm_slot_19     | LTS                 | D13, CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0 [5]                                                                           | C++17           |
| llvm_slot_20     | Rolling             |                                                                                                                             | C++17           |
| llvm_slot_21     | Rolling             |                                                                                                                             | C++17           |

EOL dates should be taken with a gain of salt because this distro only respects
the latest release of the other distros.  The main distro repo will delete or
break support for a core component (e.g. Python) so full support for an older
LTS version is unreliable.

[1] The LTS support simply means compatible with LTS distro version ranges
but can change based on G23 distro policy and access to ebuilds.

[2] The libc++ requires to be built with -std=c++23, but can link
userland to -std=c++17.  The -std=c++17 is determined by either the userland
program or the default setting in the Clang program itself.

[3] There are fewer slots supported because of the manifest update ban of
Python 3.10 and older by the distro's python-utils-r1 eclass and the distro
community removal of markings for Python 3.10 support in PYTHON_COMPAT.  Only
full access Python will be made available on this overlay.  The older Python is
necessary for QA testing for both the Clang compiler and downstream projects but
denied by the distro.  The distro's manifest update ban for older Python 3.10
ebuilds is bad because it goes against the spirit of the GPL with the right to
hack.

[4] The current LLVM slot minimum for C++ 17 is based on GPU compatibility,
LTS distro default and max allowed LLVM, and LLVM availability on this overlay
which currently is set at LLVM 18 minimum.

[5] While it is true that ROCm 6.4 and 7.0 uses LLVM 19, full ROCm support
    assumes that GCC 12 or 13 is available for prebuilt binaries built
    against libstdc++.

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
