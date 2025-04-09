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
hardware design flaw in the pointer security, then it cannot be easily fixed
and maybe the hardware be replaced.

For example, if the software requires a Rust component that uses GTK3 but
the fix in the GTK4 release.  The fix will be likely skipped until upstream
updates both the Rust dependencies and the code that references those
libraries.

## Patching/triage priorities (ranked high top)

0. Ebuilds that block (security) updates
1. Fixing untested ebuilds
2. Critical severity vulernabilities
3. High severity vulernabilities
4. Bumping versions for high value assets with weekly or biweekly vulnerability recurrence intervals
5. Zero click attack (CVSS AV:N, PR:N, UI:N)
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
- Either a CVSS 3.1 vector string, vulnerability classes, or univeral recognized bug name (required)
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
    - Privelege Escalation
    - Arbitary Code Execution
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
- The vulnerability is in the wild and being actively exploited but the
  vendor is unwilling to fix it.  It is recommended to discuss in private
  first.  DO NOT SEND A ISSUE REQUEST YET.

If you make a report, there is a chance it will be ignored or closed so don't
be offended.

The report may be done via issue request but only if it contains no sensitive
information, no personal attacks, and nothing that violates the website rules.

## Personal identifiable information

The scope of personal identifiable information includes e-mail, names, etc.

These are not easily removed due to the fork nature of git.

It may be removed directly from this repo but not inactive forked ones in or
have non-responding users.

(WIP) Reports may be done via email or encrypted messaging.

DO NOT SEND A ISSUE REQUEST.

## Sensitive information

The scope of sensitive information includes password tokens, raw passwords,
personal numbers, private keys, memory dump, etc

These are not easily removed due to the fork nature of git.

It may be removed directly from this repo but not inactive forked ones in or
have non-responding users.

(WIP) Reports should be done over encrypted messaging.  Coordinate over e-mail
first.

DO NOT SEND A ISSUE REQUEST.

See also https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

