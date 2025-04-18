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

* PYTHON_COMPAT fallbacks.
  - If setup.py contains only python3, you may list only stable Python KEYWORDS,
    or include up to Python 12 which U24 uses, or include up to Python 11 which
    D12 uses.
  - If setup.py contains Python 3.9 only, you may only list the tested version
    and earlier.  The package by some packagers is considered EOL or a defunct
    project.
  - If setup.py contains Python 3.9, 3.10, but you tested 3.11, you
    may specify `PYTHON_COMPAT=( "python3_"{10..11} )` but you need to
    leave a comment that you tested it or specify which package exactly needs it.
    Otherwise, I revert it back to upstream tested version list.  I assume that
    you made a typo that will introduce a non-reproducable build.
  - If setup.py contains Python 3.9, 3.10, you should put
    `PYTHON_COMPAT=( "python3_10" )` as the default fallback since Python 3.9 is not
    available on distro due to python-utils-r1.eclass restrictions.
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
  be hardened to prevent Arbitrary Code Execution (ACE) based Zero Click Attack (ZCA).

  Apply the following {C,CXX}FLAGS for GCC >= 14

    - `-fhardened`

  or the standard web browser hardening {C,CXX,LD}FLAGS

    - `-fstack-protector`
    - `-D_FORTIFY_SOURCE=2` with `-O1` or higher
    - `-fPIC`
    - `-fPIE -pie`
    - `-Wl,-z,noexecstack`
    - `-Wl,-z,relro -Wl,-z,now`

  The classes of C/C++ packages that should be hardened against CE + ZCA are:

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

* Ebuild digest "no match" warnings should be fixed to avoid short circuiting
  *DEPENDs and avoid breaking upstream security expectations.

* Do not use nested *DEPENDs generators.

* During build, the ebuild should not halt the computer, produce heavy swap, lag
  multitasking, cause data loss with the kernel OOM killer, random build
  failures (undeterministic build order problems).  Halting or slow down could
  be considered a Denial of Service.  See CVSS availability definition for
  details.  The ebuild should override the user provided option with
  `MAKEOPTS="-j1"` with reason in commented code if those problems are present.

* The ebuild should not do unusal activity.
  See [XZ Utils backdoor](https://en.wikipedia.org/wiki/XZ_Utils_backdoor)
  on Wikipedia.

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

