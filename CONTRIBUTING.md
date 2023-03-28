## Contributing ebuilds

You may send contributions many ways.

When you submit an ebuild on this overlay exclusively, they will not be
disseminated or searchable in the overlay search engine.  Consider uploading
them to another overlay if you would like them more searchable.

### Submissions that are considered for acceptance

1. Enhancements and optimization (PGO, BOLT, algorithms, ...)
2. Fixes and completness
3. New ebuilds related to
   - Game development (for programmers, for artists, for producers, for musicians)
   - Game libraries
   - Porting games outside of Linux
   - Programmer developer tools
   - Graphics arts
   - Games and gamer tools
   - Electron based apps
   - Emoji related
   - Security
   - AI (Artificial Intelligence)
4. Version bumps
5. Porting to different hardware

Sending them is covered in the following sections below.

### Code review

Difficulty:  Easy

1. Create an issue request.
2. Add the link to the line with the flaw.
3. Describe the flaw.

### Trivial fixes

These are limited to ebuild only changes.

Difficulty:  Easy

1. Create an issue request.
2. Add the patch in the issue request.

### Longer patches

Difficulty:  Easy

1. Create an issue request.
2. Use pastebin or gist to submit a patch(s) or ebuild(s).
3. Link the patch(s) or ebuild(s) to your issue request.

If you submit a ebuild this way, you still need to follow the rules below.

### Pull request

Difficulty:  Hard for noobs, easy for experienced

#### Rules

All ebuilds must conform to specifically 2023 ebuild style guide only recognized
by this overlay.  We do not use the distro recommendations because they are
based on an outdated style guide.

* ebuild rules:
  - Ebuilds contents must be symmetric/even or ANSI C like code style.
  - The ~90% of the code must be within 80 characters boundary.
    - Long strings need to be hard wrapped.
    - URIs processed by bazel should not be hard wrapped.
  - Constants are capitalized.
  - Most strings should be in double quotes.
  - Floats should be in double quotes.
  - Integers do not need to be double quotes.
  - Paths should be completely in double quotes from start to end of the string.
  - Conditional blocks are symmetric.
  - Inline conditionals should only fit in 80 characters.
  - Use of a pipe (|) line should always be the next line
  - The operator should start the new line most of the time, unless better
    symmetric presentation is found.
  - The uploaded point release is not vulnerable and does not have security
    advisories.  Use NVD, CVE, GLSA to see if the package is vulerable.
  - Phase functions must be sorted in chronological order.
  - || conditionals in REQUIRED_USE and *DEPENDs must have free alternatives at
    the top of the list and proprietary alternatives at the bottom of the list.
  - Indents are mostly tabs.
  - *DEPENDs sources should be documented if not centralized.
  - Sorting is generally ASCII sorted.
    - RDEPEND, DEPEND, BDEPEND, PDEPEND are using an ASCII inspired decision
      tree sort.
    - USE flags in *DEPENDs need to be ASCII sorted.
  - Comments should be placed in either column 0 or first tab and no more.
  - User output commands (echo/einfo) should be column 0 and only 80 characters.
    Additional einfos may follow.
  - You must put `OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO` in the footer and
    disable the KEYWORDS variable if the ebuild is unfinished.
  - Refrain from using non free trademarks.
  - Variables in functions must be scoped with the `local` keyword.
  - Ebuilds should be Prefix aware for C/C++ programs.
    - Use "${ESYSROOT}/usr/include" as a source.
    - Use "${ESYSROOT}/usr/$(get_libdir)" as a source.
    - Use "${EPREFIX}/" as destination.
    - Use of prefix USE flags.
      [kernel USE flags](https://packages.gentoo.org/useflags/kernel_linux)
      [libc USE flags](https://packages.gentoo.org/useflags/elibc_glibc)
    - etc...
  - Giving write permissions is disallowed in certain scenarios.
  - Adding test USE flag and dependencies is required for dev-python.
  - If a python package does provide a test suite but not through pytest,
    then src_test() must be explicitly defined in the ebuild.
  - Adding src_test and test *DEPENDs for C/C++ libraries is optional, but
    highly recommended and may be required in the future in this overlay.
  - If an ebuild can be trivially PGOed, then it is highly recommended to
    add tpgo USE flag.
  - The default IUSE must mostly respect upstream defaults by prefixing
    `+` or - in front of the USE flag.  You may go against upstream defaults
    if the setting is not platform agnostic or would likely lead to
    breakage.
  - Daemons/servers must run as limited (non-root) user.

* eclass rules:
  - All `.eclass`es must be GPL2 only or have a GPL2 compatible license header.
  - All `.eclass`es have the basic headers rows @ECLASS, @MAINTAINER, 
    @SUPPORTED_EAPIS, @BLURB, @DESCRIPTION.
  - All public functions must have the following @FUNCTION, @DESCRIPTION,
    and the same prefix matching the filename without extension.
  - All internal functions must have @INTERNAL and be prefixed with _.
  - All eclass variables and globals must have the following
    @ECLASS_VARIABLE, @DESCRIPTION
  - All eclasses must have EAPI compatibility switch-case or conditional
    check.

* ebuild license rules:
  - All `.ebuild`s must be GPL2 only or have a GPL2 compatible license header.
  - You may add your name to the license header, or AUTHORS.md of the root of
    the overlay, or remain anonymous.
  - Attach custom licenses to the license folder.
  - The licenses of all vendored internal dependencies should be disclosed in
    the LICENSE variable.
  - If the license header says all rights reserved but the license does not
    have it in the license template, it should be disclosed.
  - All patents licenses should be disclosed and should be free.

* metadata.xml rules:
  - Everything is space indented.
  - Generally indents are two spaces.
  - Tags are symmetric.
  - Contents are symmetric.
  - Instructions should be in comments.
  - longdescription is only promo.
  - Do not put personal info or *marks if project is BSDed.
  - If the project is ZLIBed, you must clearly put that you made
    the ebuild and not the project that you are packaging.

* upload rules:
  - You may submit many ebuilds at the same time, but do not send more than
    reasonable amount.
  - It is better to send one package folder at a time.

* code review checklist:
  - Header copyright notices
  - License files for free open source compatibility
  - The URIs will be reviewed.
  - *DEPENDs will be check for sorting.
  - IUSE will be checked for sorting.
  - Each and every ebuild will be manually checked for security.
  - File permissions and ownership.
  - The project licenses will be reviewed.
  - All eclasses are inspected for comprehensive documentation.
  - Vulnerability database checks for each submitted package.
  - The security of init scripts if any.

#### Uploading to this repo

1. Fork the repo
2. Create a feature branch
3. Make changes to the feature branch
4. Follow and create a
[pull request from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).
5. In your pull request state the following:
   - The purpose/summary.
   - Estimate of long you expect to finish.
     - Do not exceed a week.
     - For scheduled submissions like ot-kernel eclass, you are only allowed
       8 hours.
   - State all `<category>/<package>` that you will be editing so we avoid merge
     conflicts.
6. After the merges are done, you may delete the feature branch and forked repo.

#### Rejected pull requests

Your pull request may be rejected for reasons below:

1. The ebuilds were planned earlier for removal because the upstream project is
   end of life (EOL).
2. Security reasons.
   - The point release is vulnerable and will be replaced with a non-vulnerable.
   - Project owners have a questionable background.
   - The project credibility is in question.
3. Exceeded time limits.
   - Submissions are to be evaluated merged no more than a week.
   (The reason is that I may edit the whole thing or whole category).
   - For scheduled submissions like ot-kernel eclass, you are only allowed
     8 hours.
4. Licensing rejections.
   - The license has overtones of non free is rejected.
   - No code repository and with explicit UNKNOWN is rejected.
5. Code review checklist violations.

#### Deleted ebuilds

Your ebuilds may be deleted for the following reasons:

1. No bumps for 6 months [considered sometimes EOL] to 10 years.
2. The branch/project is is EOL.
3. A better alternative with duplicated functionality.
4. Improved fork.
5. Clearly pre alpha when better alternatives exists.
6. The minor branch is older than 2, except when they are needed for testing.

## Overlay maintainers

Spots for overlay maintainers are available.  Due to security reasons, extra
level of qualification standards and checks are required.

You need at least one of the following to qualify:

1. You have an open source project on a well known repo service.
2. We have met in person.
3. Brief interview over voice with a demo of your project on a video sharing
site and code samples.
