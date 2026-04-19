# Overlay comparison

| Topic                               | gentoo-overlay                             | oiledmachine-overlay                                         |
| ---                                 | ---                                        | ---                                                          |
| Core developers                     | Many                                       | 1                                                            |
| AI ban                              | Y                                          | N                                                            |
| Ebuild code style                   | Original (reputation damaging, bad hire), Messy/inconsistent or >= 80 characters | Custom (pretty, job friendly style).  Mostly within 80 characters |
| Organization                        | Y                                          | N                                                            |
| Primary ebuild goals                | Build customization, simple/basic ebuilds  | Anti DoS, anti lag, production grade performance             |
| Secondary ebuild goals              | Portability | Feature complete (aka full version) ebuilds, Power user customization, packaging power user or must have software, new/custom feature patches, dummy proofing / guardrails |
| Documentation style                 | Simple, undocumented mods or undocumented known settings that lead to performance regressions | Transparent and comprehensive, mods and regressions doc'ed |
| Runtime performance                 | Slow sometimes or difficult to find bottleneck if ricing | Reproducible with guardrails and warnings      |
| Compiler hardening                  | Balanced, outdated or missing flags, inappropriate static hardening level | Custom, recent hardening flags, dynamic increased hardening by threat |
| C++ consistency                     | N, user is responsible, difficult to find when build logging is off by default for used C++ standard. | Y, enforced by gcc_slot_* USE flags and REQUIRED_USE |
| Multiple AI platform install (e.g. TensorFlow + LocalAI installed at the same time) | N, impossible (require containers) | Y                                          |
| Submission/contributor contracts    | Y                                          | N (no blackmail or futher oppression, just follow the open source software license freedoms) |
| Submission barrier                  | High                                       | Lower                                                        |
| Node/cargo lockfile security scanning        | N                                          | Y                                                            |
| Vulnerability DB sources            | CPE/CVE (NVD), GLSA                        | NVD, GLSA, CISA KEV, GHSA, HW/SW vendors, podcasts, AI apps  |
| Fixes submitted to upstream         | Sometimes                                  | Very rare                                                    |
| Container ebuilds for blast radius mitigation | N                                | N, possible if community agrees                              |
| LICENSE variable transparency       | Missing sometimes.  Usually only software and some patent licenses are listed but missing maybe service licenses, privacy policy | More comprehensive if ebuild created by overlay |
| CPU support                         | x86-64-v2 or x86-64-v3 newer CPUs are sometimes required | The lowest CPU requirements if possible for hardware/software immortality reasons |
| Toolchain stability                 | Rolling compiler versions used by distro unstable releases or rolling only distros are preferred.  Possible build failure if the default C/C++ changes or possibily new security issue (e.g. DoS, crash, or worst RCE). | LTS compiler versions used by LTS distro releases are preferred.  Virtually no build time failures. |
| Ebuild operationality               | Ready, low failure rate                    | Varies, most are ready but some fail if long compile times   |
