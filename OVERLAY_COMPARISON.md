# Overlay comparison

| Topic                               | gentoo-overlay                             | oiledmachine-overlay                                         |
| ---                                 | ---                                        | ---                                                          |
| Core developers                     | Many                                       | 1                                                            |
| AI ban                              | Y                                          | N                                                            |
| Ebuild code style                   | The original language docs style (reputation damaging, bad hire), messy/inconsistent or >= 80 characters | Custom (pretty, job friendly style).  Mostly within 80 characters |
| Organization                        | Y                                          | N                                                            |
| Primary ebuild package goals        | Build customization, simple/basic ebuilds  | Anti DoS, anti lag, production grade performance             |
| Secondary ebuild package goals      | Cross compile portability | Feature complete (aka full version) ebuilds, power user customization; packaging aethetically pleasing, cool, or trending software; new/custom feature patches exclusives, dummy proofing, guardrails |
| Documentation style                 | Simple, undocumented mods or undocumented known settings lead to performance regressions | Transparent and comprehensive, mods and regressions are documented and warned to user |
| Runtime performance                 | Slow sometimes or difficult to find bottleneck if ricing | Reproducible with guardrails and warnings      |
| Compiler hardening                  | Balanced, outdated or missing flags, inappropriate static hardening level | Custom, recent hardening flags, dynamic increased hardening by threat |
| C++ consistency                     | N, user is responsible, difficult to resolve when build logging is off by default and multiple C++ standard versions are involved. | Y, enforced by gcc_slot_* USE flags and REQUIRED_USE |
| Multiple AI platform install (e.g. TensorFlow + LocalAI installed at the same time) | N, impossible (require containers or the container may not be CPU compatible) | Y                                          |
| Submission/contributor contracts    | Y                                          | N (no blackmail or further oppression or no subverting of your rights, just follow the open source software license freedoms) |
| Ebuild/patch submission barrier     | High                                       | Lower                                                        |
| Node/cargo lockfile security scanning        | N                                 | Y                                                            |
| Vulnerability DB sources            | CPE/CVE (NVD), GLSA                        | NVD, GLSA, CISA KEV, GHSA, HW/SW vendors, podcasts, AI apps  |
| Fixes submitted to upstream         | Sometimes                                  | Very rare                                                    |
| Container ebuilds for blast radius mitigation | N                                | N, possible if community agrees                              |
| LICENSE variable transparency       | Missing sometimes.  Usually only software and some patent licenses are listed but missing maybe service licenses, privacy policy.  License variations may be inappropriately tagged. | More comprehensive if ebuild created by overlay |
| CPU support                         | x86-64-v2 or x86-64-v3 newer CPUs are sometimes required | The lowest CPU requirements if possible for hardware/software immortality reasons |
| Toolchain stability                 | Rolling compiler slots used by distro unstable releases or rolling only distros are preferred.  Possible build failure if the default C/C++ version changes or possibily new security issue (e.g. DoS, crash, or worst RCE). | LTS compiler slots used by distro LTS releases are preferred.  Virtually no build time failures as a result of using practically complete C++ standards that default to stable C++ version that are used and tested by most projects. |
| Ebuild operationality               | Ready, low failure rate with simple @world set, but high strategic failure with complex @world set. | Varies, most are ready but some fail if long compile times or unresolved issues.  Tries to have higher strategic success for complex @world set. |
| Multislot lean                      | Monoslot preferred to maintain the latest release used facade | Multislot preferred to solve strategic success               |
| Ebuild exclusives or unique ebuilds | Y                                          | Y                                                            |
| Build suffering policy              | Rip the bandaid slowly                     | Rip the bandaid fast                                         |
| Tarball micropackage bundle for Go / Rust | Y (untrusted in the zero trust model) | N                                                           |
| Reproducible live ebuilds           | N, user is reponsible, quality is overlooked or poor due to rashness | Y, with USE=fallback-commit capable ebuilds, some ebuilds have high quality green CI checkmarks threshold requirements to reduce build failure especially for large codebases or long build time ebuild packages |
