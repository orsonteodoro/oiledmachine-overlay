# Overlay ebuild style guidelines

* Symmetrical everywhere
  - Symmetrical above and below
  - Symmetrical left and right
* Arrays are symmetrical.
* Strings are symmetrical.
* Indents are tabs only.
* The ebuild coding style should resemble similar higher level programming
  languages coding styles to reduce the learning curve of patching software at
  code level.
* Ebuild explicit and verbose syntax is preferred to encourage fixing code level
  bugs.
* 80 characters per line.
* Comments indented either tab 0 or 1st tab and no more.
- Comments should be in formal language.
* Loops and algorithms can only be O(1), O(n).
* No more than 2 tabs indents.
* Generators should be used instead of repeated blocks of strings.
* All local variables and loop variables should be declared explicitly local.
* All local names should be lower case with underscore separating words.
* All global names should be capitalized with underscores separating words.
* An ASCII inspired sort should be used for lists.  Sorting should be used in
  the following
  - arrays
  - assocative arrays
  - command line arguments if possible
  - *DEPENDs
  - if-else chains
  - In metadata.xml in the
    - use flag section
    - upstream section
  - IUSE
  - LICENSE
  - Local variables declaration section
  - REQUIRED_USE
  - SRC_URI
  - switch-case
  - User defined global variables
* Strings are double quoted.
* Versions are double quoted.
* Integers are not quoted.
* Floats are double quoted.
* File/folder paths are typically double quoted from start to end.
* The metadata.xml style
  - 2 space indent to emphasize detailed oriented and detailed reviewed ebuild
  - 80 characters
  - No personal identifiable information, specifically maintainer section, under upstream section
  - Symmetrical block style
* Simplification by removing explicit phase functions is preferred.
* The oldest CI image is the fallback image if no specific versions specified in
  the build files but distro images are specified in the CI files.  If no CI
  testing is being done, then you don't need to specify the version unless the
  code requires it (e.g. gui-libs/gtk:4).

  - For example,

    - U24 has libgcrypt 1.10.3
    - U22 has libgcrypt 1.9.4
    - D12 has libgcrypt 1.10.1

    If the build files say libgcrypt and image U24 is only being tested, then use
    `>=dev-libs/libgcrypt-1.10.3` for RDEPENDs.

    If the build files say libgcrypt and image D12 and U24 are being tested, then
    use `>=dev-libs/libgcrypt-1.94` for RDEPENDs.

    If the build files say just libgcrypt and no images or CI testing, you
    may use just `dev-libs/libgcrypt` for RDEPENDs.

    If the build files say libgcrypt with minimum version, you may use that
    instead.


* PYTHON_COMPAT fallbacks for setup.py or pyproject.toml

  | Listed                 | PYTHON_COMPAT                              |
  | ---                    | ---                                        |
  | no versions            | (2)                                        |
  | specific version       | python3_11 or python3_12                   |
  | specific versions      | python3_{11,12,13} or python3_{11..13} (1) |
  | python3                | python3_{11,12}                            |
  | python 3.10 or earlier | (2)                                        |

  (1) Fallback rule 1:

    - List all versions from setup.py or pyproject.toml if possible.
    - Do not eager bump unless an app package needs it.
    - If eager bumped leave the reason:  Needed for `<package name>`
    - If you do not leave a reason, it will be reverted back to upstream listed versions.

  (1) Fallback rule 2:

    - If the CI image is D12, use python3_11.
    - If the CI image is U24, use python3_12.
    - If the CI image tests both D12 and U24, use python3_{11,12}.
    - If a Dockerfile exists, use the above rules.
    - If the app is set to USE="python_single_target_python3_11" and you tested lib/app interactively or by test suite, use python3_11.
    - If the app is set to USE="python_single_target_python3_12" and you tested lib/app interactively or by test suite, use python3_12.
    - If your PYTHON_SINGLE_TARGET from /etc/portage/make.conf uses python3_11, use python3_11.
    - If your PYTHON_SINGLE_TARGET from /etc/portage/make.conf uses python3_12, use python3_12.
    - If the Python version is in the build files (CMakeLists.txt, meson.build, etc), add the versions allowed.
    - If none of the above apply and you tested it with python3_13, use python3_13, assuming the distro fallback of PYTHON_SINGLE_TARGET="python3_13".  If you
      do use that Python version, then it may not be compatible with D12, U24 based packages.
    - If the slot is missing in the dependency that the parent package needs, downgrade/upgrade the dependency package.
    - If the slot is missing in the dependency that the parent package needs and the dependency project is defunct, adjust PYTHON_COMPAT based on app package's python_single_python3_11 or python_single_python3_12.
    - Any unofficial Python version added should be documented next to or below PYTHON_COMPAT, or it may be reverted back to the known working versions provided by upstream.
      List of reasons examples:
      - Needed for `<package name>`
      - Test suite passed with Python 3.13
      - Integration test passed with Python 3.13
      - Interactive test passed with Python 3.13
      - Test suite and integration testing passed with Python 3.13
    - Consider deleting the ebuild if PYTHON_COMPAT is python3_10 or less but only if it is not necessary to keep it in order for the app to work.
    - If the Python package contains a prebuilt binary and built using an EOL release, that Python package release should be deleted.

  Commentary

    - Most CI images use D12, U22, U24.
    - Using PYTHON_SINGLE_TARGET from /etc/portage/make.conf or from the app package with testing and fixes performed by you is a good way to increase reproducibility.
    - Adding untested non stable (>= python3_13) can add unintended consequences, more bugs, or Denial of Service (e.g. crash).
    - Adding tested >= python3_13 is allowed.
    - Testing >= python3_13 is unpaid free labor.
    - Only tested versions are allowed.
    - Any untested version is assumed Denial of Service (e.g. crash), decreases or assumed not reproducible, disruptive and increases security fix backlog.
    - Reproducible on this overlay means end-to-end build success and operational end-to-end

* If an ebuild references a PYTHON_SINGLE_USEDEP in *DEPENDs, the ebuild should
  use either `DISTUTILS_SINGLE_IMPL=1` with `inherit distutils-r1` or
  `inherit python-single-r1`.  This edge case is not well documented.
* If a package contains an uncommon license or legal changes that introduce a
  new phrase or clause, it should be documented as a comment near the LICENSE
  variable.
* Live ebuilds should have fallback-commit support to reduce GH issue spam and
  to improve reproducibility for projects without version tags.
* Using sed patches is strongly discouraged.  Use patch files instead.
* Network based daemons should be considered for sandboxing or confinement for
  new projects or packages with high reported vulnerabilities or to prevent
  Information Discloure (ID) or Data Tampering (DT) based path traversal
  attacks.
* Daemons need to be run as non-root user.
* For web apps that require user login, the ssl USE flag should be made
  available and implemented properly if the project does not document it.
* The ebuild should be polished to improve stability and to hide/disable
  unfinshed features at the code level.
* The CFLAGS should be changed with `filter-flags` or `replace-flags` to
  prevent Denial of Service (e.g. crash) vulnerability.
* If -O3 or -Ofast causes a crash, then the CFLAG must be downgraded to -O2 or
  whatever is necessary to prevent a crash.
* -O3 and -Ofast cannot be used in ebuilds/eclass where cflags-hardened or
  rustflags-hardened eclasses are inherited.  Do not change the optimization
  after {c,rust}flags-hardened_append or it may increase the estimated CVSS 3.1
  score/severity or break the security guarantees of -D_FORITIFY_SOURCE.
* The CFLAGS must be bumped or boosted if degraded runtime performance is
  severe.
* If below 24 FPS, then bump the -Oflag minimum allowed.
* If computation is longer than expected, then bump the -Oflag minimum allowed.
* Performance expectations:
  - Servers:  6 days minimum uptime, +60 days uptime preferred
  - Gaming newer titles:  60 FPS
  - Gaming older titles:  30 FPS
  - Hardcore mode gaming:  +60 days uptime
  - Sports:  30 FPS
  - News and vlogs:  30 FPS
  - Movies:  24 FPS
  - Audio production:  No jitter, no studder
  - Live radio reporting:  No jitter, no studder, 5 hours uptime minimum for a 4 hours broadcast uninterrupted
  - Ebuild compliation time: < 24 hours
  - Scrolling:  No delay, no lag
  - Workstation:  48 hours minimum uptime for all nighter scenario
* C/C++ packages that process user generated content from the Internet need to
  be hardened to prevent Arbitrary Code Execution (ACE) based Zero Click Attack
  (ZCA), in addition we should also mitigate against some Information
  Disclosure (ID) based Zero Click Attacks (ZCA).

  Use the cflags-hardened or the rustflags-hardened eclass to apply hardening
  consistently.

  Packages that use sanitizers must perform both test-suite testing and
  integration testing before being permanently default on.  For integration
  testing, you must make sure that the package that uses the library or
  executible does not break the security-critical package(s) or any of the
  packages in the @system set.

  The classes of C/C++ packages that should be hardened against CE + ZCA or
  ID + ZCA are:

  - Web video codecs
  - Web audio codecs
  - Web image codecs
  - PDF packages
  - Font libraries
  - Web browser packages
  - Messaging apps
  - Networked multimedia apps
  - Network libraries
  - Streaming media libraries
  - Image libraries
  - Kernel
  - Network apps that use vendored librares (aka internal forked libraries) of the types above instead of system libraries
  - Any network app or direct dependency with a CVSS history of AV:N C:H I:H A:H

  You must verify the compiler's hardening is on and/or apply the hardening
  flags unconditionally.  Don't assume that the user is using the default on
  hardened USE flag settings for the C/C++ compiler or hardened linker.

  We want to mitigate against inspired attacks based on the following

  - [Pegasus](https://en.wikipedia.org/wiki/Pegasus_(spyware))
  - [FORCEDENTRY](https://en.wikipedia.org/wiki/FORCEDENTRY)
  - [CVE-2025-27363](https://nvd.nist.gov/vuln/detail/CVE-2025-27363)

* All C/C++ programs that handle untrusted data or sensitive data must use the
  cflags-hardened eclass.  This is to prevent the possibility that the distro
  forgets to apply hardening patches to clang, which they have done in the
  past, and to apply hardening flags to packages consistently.  In addition
  to apply missed hardening flags which they still forget to do today.  While
  hardening does not completely mitigate, we want to increase the difficulty
  for the attacker or increase the height of the security fence higher.

* C/C++ daemons and suid packages require `-fstack-clash-protection` C{,XX}FLAG.

* Telemetry should be disabled by default.  Any telemetry requires additional
  LICENSE variable changes.

* Eclasses
  - Should be well documented
  - Must support EAPI 8

* Supported versions
  - Stable: Yes
  - LTS:  Yes
  - Beta:  Generally no, with exceptions
  - Alpha:  No
  - Preview:  No
  - Live:  Yes
  - Live snapshot:  Yes

* Ebuild digest "no match" non-fatal errors must be fixed to avoid short
  circuiting *DEPENDs, to avoid breaking upstream security expectations, and to
  avoid runtime failures.

* Do not use nested *DEPENDs generators.

* During build, the ebuild should not
   - halt or freeze the computer
   - produce heavy swap
   - lag multitasking
   - cause data loss with the kernel (Out Of Memory) OOM killer
   - have random build failures (undeterministic build order problems)

  Halting or slow down could be considered a Denial of Service (DoS).  See CVSS
  availability definition for details.  The ebuild should override the user
  provided option with `MAKEOPTS="-j1"` with reason in commented code if those
  problems are present.

* The ebuild should not do unusal activity.
  See [XZ Utils backdoor](https://en.wikipedia.org/wiki/XZ_Utils_backdoor)
  on Wikipedia.

* Hardcoded `-march=` in the compiler output is unsupported.  The package must
  be modified or ebuild changed to accommodate older architectures with
  possibly custom-optimization USE flag or removed of that -march in build
  flag.  The use of hardcoded flags can be result in an illegal instruction
  runtime error; or perceived as offensive by some as vendor lock-in, as an
  undisclosed sponsored project by that vendor, as fanboyism by the
  project, or as underoptimized.  It must also accommodate builder machines
  building portable prebuilt packages.

* The use of SIMD build time autodetection or forced SIMD flags are not
  unsupported.  The package must be modified or ebuild changed to accommodate
  older architectures via cpu_flags_* USE flags.  The build files may be
  modified to optionalize them.  Again, these hardcoded SIMD flags may result in
  an illegal instruction runtime error; or perceived as offensive by some as
  vendor lock-in, as an undisclosed sponsored project, as fanboyism by the
  project, or as underoptimized.  It must also accommodate builder machines
  building portable prebuilt packages.

* Ebuilds that do a compiler switch must filter-lto.  This overlay should resolve
  all LTO issues without user intervention.
  1.  filter-lto when the compiler at the beginning of the pkg_setup phase is
      not the same after a forced compiler switch.  It is assumed that the
      initial compiler is the default systemwide LTO compiler.
  2.  filter-lto when the user verified default system LTO compiler, set as
      DETECT_COMPILER_SWITCH_LTO_CC_NAME and DETECT_COMPILER_SWITCH_LTO_CC_SLOT,
      is not the same after the compiler switch phase for static-libs contained
      in any of IUSE or *DEPENDS variables, or for ebuilds that link to
      static-libs during static builds or have static in IUSE.
  3.  filter-lto when using a GPU compiler
  4.  filter-lto when not using system compilers
  5.  filter-lto when using forked compilers
  6.  filter-lto when ODR violation(s) are encountered while LTOing
  7.  filter-lto when runtime issue(s) are encountered.
  8.  filter-lto when LTO build issue(s) are encountered.
  9.  filter-lto when switching between an unstable compiler slot and stable
      compiler slot to mitigate against the possibility of an unstable
      Intermediate Representation (IR) mixed in for static-libs for the same
      compiler slot (e.g. upgrading/downgrading between =sys-devel/gcc-14.4.9999
      and =sys-devel/gcc-14.3.0, upgrading/downgrading between or
      =llvm-core/clang-21.0.0.9999 and =llvm-core/clang-21.0.1). (proposed rule)
  10. filter-lto when there is a performance regression.

# Ebuild organization

1. Header
   - A copyright notice is required

2. EAPI=8

3. Comments (optional)
   - TODO package list
   - FIXME task lisk and compiler errors

4. Package atom overrides
   - MY_PN
   - MY_PV
   - MY_P

5. Pre inherits (optional)

6. User defined global variables

7. General eclass inherits

8. Download section
   - Typically a conditional with PV == *9999*
   - Live repo info (optional)
     - EGIT_BRANCH
     - EGIT_REPO_URI
     - EGIT_CHECKOUT_DIR
     - FALLBACK_COMMIT
     - inherit git-r3
     - IUSE+=" fallback-commit"
   - Stable download info
     - KEYWORDS
     - SRC_URI

9. Commonly used global variables
   - DESCRIPTION
     - Typically an adjective phrase
     - It should be simplified if too long
   - HOMEPAGE
   - LICENSE
     - Must disclose copyright licenses
     - Must disclose patent licenses
     - Must disclose end user agreements
     - Must disclose acceptable use agreement (e.g. AI ethics)
     - Must disclose terms of service
     - Must disclose privacy policy
     - Must disclose data collection policy (e.g. telemetry)
     - Must disclose all legal text or provide a link to the policy
     - Must disclose all vendored packages (from submodules or third-party folder) licenses
     - Must disclose all assets (e.g. graphics, audio, fonts, themes, etc) licenses
     - List license commentary below this variable.
   - RESTRICT
   - SLOT
   - IUSE
   - REQUIRED_USE
   - RDEPEND
   - DEPEND
   - BDEPEND
   - PDEPEND
   - DOCS
   - PATCHES

10. Ebuild phases
   - These should be in chronological order.
   - pkg_setup()
   - pkg_nofetch()
   - src_unpack()
     - For live ebuilds, it should have a fallback-commit.
   - src_configure()
   - src_compile()
   - src_install()

