# Security policy

(This page is still a rough draft.)

The security policy is based on the name of the overlay, with the focus on
eliminating performance slow downs that manifest as memory leaks, heavy I/O,
large FPS drops.  The overlay is also interested in a crashless experience.

## General goals

* Denial of Service mitigations first
* Patched vulnerabilities are best effort
* Version bumps to eliminate EOL versions
* Prioritizing fixes over newer releases
* Triaging broken ebuilds and mitigating against vulnerability/update backlog

## Best effort policy

The policy is based on the implications of Godel's Incompleteness Theorem.
See also hardware vulnerabilities.

For example, if the software has pointer security gaurantees but relies on
hardware which was later to be discovered with a design flaw in the pointer
security, then it cannot be easily fixed and maybe the hardware needs to be
replaced.

For example, if the software requires a Rust component that uses GTK3 but
the fix in the GTK4 release.  The fix will be likely skipped until upstream
updates both the Rust dependencies and the code that references those
libraries.  Most of the vulnerable cargo packages will be bumped to
non-vulernable except for this breaking GTK4 change.

## The current security posture

The current security posture of this overlay is neutral-defensive.

- Default well tested and secure upstream settings (neutral posture)
- Proactive vulnerability discovery and remediation (defensive posture)

## Definitions

* Zero Click Attack (ZCA) - a network based attack that doesn't require UI interaction and no changes in privileges are necessary (AV:N UI:N PR:N)
* Social Engineering Attack (SEA) - a type of attack that manipulates the user by deceptive Hollywood acting to change or gain sensitive information
* Spoof Attack (SA) - a type of attack that uses look-alike deception to trick users into using the attacker's asset or website
* C:H - high confidentiality loss possible, serious impact possible, all sensitive information can be disclosed
* C:L - low confidentiality loss possible, miniscule impact possible, some information can be disclosed
* I:H - high data integrity loss possible, serious impact possible, full data integrity loss or full modification of data files or security metadata or user privileges
* I:L - low data integrity loss possible, miniscule impact possible, possiblity of integrity loss or partial modification that may lead to serious loss
* A:H - high availablity loss possible, serious impact possible, completely unavailable resources
* A:L - low availability loss possible, miniscule impact possible, partial or full available resources with possibly degraded performance

## Severity levels

Severity | Technical meaning                   | In layman's terms                                                                                             | Proper remediation response times (ebuild dev) | Proper remediation response times (admin)
---      | ---                                 | ---                                                                                                           | ---                                            | ---
Critical | ZCA + C:H + I:H + A:H               | An unmitigable immediate serious loss possibility with full attacker capabilities                             | 10 days or less                                | 24 hours or less especially if actively exploited in the wild
High     | 2 or more C:H, I:H, or A:H          | A challenging serious loss possibility with more attacker capabilities                                        | 10 days or less                                | 24 hours or less for C and I; 1 week or less for A
High     | ZCA + C:L + I:L + A:L + (SEA or SA) | An unmitigable immediate limited loss possibility with more attacker capabilities or may lead to serious loss | 10 days or less                                | 24 hours or less
Medium   | At least one C:H, I:H, or A:H       | A challenging serious loss possibility                                                                        | 10 days or less                                | 24 hours or less for C and I; 1 week or less for A
Medium   | ZCA + at least one C:L or I:L       | An unmitigable immediate limited loss possibility                                                             | 10 days or less                                | 24 hours or less
Low      | At least one C:L, I:L, or A:L       | A challenging limited loss possibility                                                                        | 17 days or less                                | 13 days or less

## Remediation

The remediation response times apply to this overlay only and may actually be longer.

The proper total remediation time is ebuild developer time + administrator time.

Total remediation time for customers should be 12 days before billing time ends.
This is the overlay's primary demographic.

### The web browser case

Let's take web browsers for example with two proper remediation periods.

The first remediation period should start immediately after the billing deadline
(18th of the month) for early spender personalities.  The browser should be
secure ready at the beginning of the month.

The second remediation period should start at 1st of the month for last minute
spenders personalities.  The browser should be secure ready to use a few days
before the deadline.

The initial start time is not always constant in reality due to backlogs,
package triage fairness, or understaffing.

### Small packages cases

Remediation start time happens when there is a version bump and the period
is relative to that release date.  Usually the point release and the
security advisory date are relatively close.

### Fast turnaround remediation (unsupported)

Total remediation time for organizations and businesses should be 4 hours or
less before elevated worry time from service disruptions, user performance
stress, or aligned with the system maintenance period.  This case is not
supported due to the lack of developers.

This case applies to web services, web servers, game servers, or kiosk
applications assuming continuous uninterrupted availability with performance
problems resolved quickly.

## Patching/triage priorities (ranked high top)

0. Ebuilds that block (security) updates
1. Fixing untested ebuilds
2. Critical severity vulernabilities
3. High severity vulernabilities
4. Bumping versions for high value assets with weekly or biweekly vulnerability recurrence intervals
5. Zero click attack
6. Uncaught Information Disclosure (ID)
7. Uncaught Data Tampering (DT)
8. Uncaught Denial of Service (DoS)
9. Uncaught security vulnerability advisories
10. Memory leaks (CWE-401)
11. Heavy I/O (CWE-400, CWE-770)
12. Modifying or speeding up ebuilds to mitigate against vulnerability backlog
13. Bumping EOL software (CWE-1104)
14. Pruning or substituting EOL software (CWE-1329)
15. Testing untested software (CWE-1357)

## Binary packages

Mitigation is limited or disallowed due to legal reasons.  You can try to report
it upstream, but many times it is ignored.

It is recommended to use open source packages whenever possible.

## Known patched vulnerabilies

Report it as an issue request but only if it has a patch or fixed in a particular version.

The issue report should have the following:
- Summary (recommended)
- Packages affected (required)
- CVE ID (optional)
- Either a CVSS 3.1 vector string, vulnerability classes, or universally recognized bug name (required)
  - Vulernability classes (multiple allowed):
    - DoS - Denial of Service - e.g. crash, memory leak - same as availability in CVSS 3.1
    - DT - Data Tampering - e.g. corrupted data, compromised data integrity - same as integrity in CVSS 3.1
    - ID - Information Disclosure - e.g. sensitive data leak - same as confidentiality in CVSS 3.1
  - Universally recognized bug names:
    - Null Pointer Dereference
    - Free After Use
    - Double Free
    - Race Condition
    - Sandbox Escape
    - Improper Permissions
    - Privilege Escalation
    - Arbitrary Code Execution
    - Supply Chain Attack
    - Malware
    - See the CWE website or https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/vf.eclass
- CWE ID (optional)
- A patch or version(s) that fixes it (required)

## Unpatched vulnerabilities (aka 0-day vulnerabilities)

These generally should not be reported.  They may be reported on these cases:

- Proprietary software packages to encorage switching to open source packages or
  to encourage that vendor to fix the package.
- It was reported upstream but upstream does not want to fix it after 2 or 4
  year(s) it was reported, or if those versions are EOL.  If it was EOL, note it
  so we can bump the package.
- If the vulnerability is Information Disclosure (ID), Data Tampering (DT),
  Privilege Escalation (PE), Arbitary Code Execution (CE), or two or more
  classes of vulnerabilities please report it to upstream first privately,
  especially if upstream has a bug bounty program.  DO NOT SEND AN ISSUE
  REQUEST YET.
- If the vulnerability is strictly a Denial of Service (DoS) vulnerability, you
  may report it here as an issue request here and on the upstream repo.
- If you suspect that this DoS is linked to ID or DT, report it privately to
  upstream.  DO NOT SEND AN ISSUE REQUEST YET.
- If the vulnerability has a critical to high severity and in the wild and being
  actively exploited but the vendor is unwilling to fix it, it is recommended
  to discuss in private first.  DO NOT SEND AN ISSUE REQUEST YET.

If you make a report, there is a chance it will be ignored or closed so don't
be offended.

The report may be done via issue request but only if it contains no sensitive
information, no personal attacks, and nothing that violates the website rules.

## AI based fixes

This overlay accepts AI based security fixes.  If the compiler or a runtime
error is reported or encountered that is a common memory corruption or undefined
behavior, it could be fixed.

AI qualifications:

* The AI must be able to recognize open source licenses.
* The AI must be able to submit contributions under approved open source licenses.
* The AI must be able to understand CVEs.
* The AI must be able to fix ASan, UBSan type of errors.
* AI are known to fix the following vulnerabilities.  Patch fixes are accepted
  for the following:
  - Dangling Pointer (-Wdangling-pointer=; DoS, PE, DoS, DT, ID; medium-high severity)
  - Double Free (-fsanitize=address, runtime error; CE, PE, DoS, DT, ID; high-critical severity)
  - Infinite loops/recursion (-Winfinite-recursion, -Wanalyzer-infinite-loop, -Wanalyzer-infinite-recursion, runtime error; DoS; low-medium severity)
  - Null Pointer Dereference (-Wnull-dereference; DoS; low-medium severity)
  - Out of Bounds Access/Read/Write (-Warray-bounds; CE, PE, DoS, DT, ID; high-critical severity)
  - Race Condition (Runtime error; CE, PE, DoS, DT, ID; medium-high severity)
  - Stack Overflow (-Wstringop-overflow or runtime error; CE, PE, DoS, DT, ID; high-critical severity)
  - String format vulnerabilities (-Wformat-security; CE, PE, DoS, DT, ID; high-critical serverity)
  - Uninitalized memory/variables (-Wuninitialized, -Wmaybe-uninitialized; CE, PE, DT, ID; medium-high severity)
  - Use After Free (-Wuse-after-free; CE, PE, DoS, DT, ID; high-critical severity)

Contributing AI fixes:

* Locate the code.  Show the code or function to the AI and present the compiler warning or runtime error.
* You can submit a pull request.
* The submission must be a patch file or an ebuild version bump.

## Personal identifiable information

The scope of personal identifiable information includes e-mail, names, etc.

These are not easily removed due to the fork nature of git.

It may be removed directly from this repo but not inactive forked ones in or
have non-responding users.

(WIP) Reports may be done via email or encrypted messaging.

DO NOT SEND AN ISSUE REQUEST.

## Sensitive information

The scope of sensitive information includes password tokens, raw passwords,
personal numbers, private keys, memory dump, etc

These are not easily removed due to the fork nature of git.

It may be removed directly from this repo but not inactive forked ones in or
have non-responding users.

(WIP) Reports should be done over encrypted messaging.  Coordinate over e-mail
first.

DO NOT SEND AN ISSUE REQUEST.

See also https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

