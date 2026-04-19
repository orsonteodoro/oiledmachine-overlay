# Overlay comparison

| Topic                               | gentoo-overlay                             | oiledmachine-overlay                                         |
| ---                                 | ---                                        | ---                                                          |
| Core developers                     | Many                                       | 1                                                            |
| AI ban                              | Y                                          | N                                                            |
| Ebuild code style                   | Original (reputation damaging, bad hire)   | Custom (pretty, job friendly style)                          |
|                                     | Messy/inconsistent or >= 80 characters     | Mostly within 80 characters                                  |
| Organization                        | Y                                          | N                                                            |
| Primary ebuild goals                | Build customization                        | Anti DoS, anti lag, production grade performance             |
| Secondary ebuild goals              | Portability                                | Feature complete (aka full version) ebuilds                  |
|                                     | Simple/basic ebuilds                       | Power user customization                                     |
|                                     |                                            | Packaging power user or must have software                   |
|                                     |                                            | New/custom feature patches                                   |
|                                     |                                            | Dummy proofing / guardrails                                  |
| Documentation style                 | Simple, undocumented mods or regression    | Transparent and comprehensive, mods and regressions doc'ed   |
|                                     | settings                                   |                                                              |
| Runtime performance                 | Slow sometimes or difficult to find        | Reproducible with guardrails and warnings                    |
|                                     | bottleneck if ricing                       |                                                              |
| Compiler hardening                  | Balanced, outdated or missing flags,       |                                                              |
|                                     | inappropriate static hardening level       | Custom, recent hardening flags, dynamic increase by threat   |
| C++ consistency                     | N, user is responsible, difficult to find  |                                                              |
|                                     | when build logging is off by default for   | Y, enforced by gcc_slot_* USE flags and REQUIRED_USE         |
|                                     | used C++ standard.                         |                                                              |
| Multiple AI platform install        | N, impossible (require containers)         | Y                                                            |
| (TensorFlow + LocalAI same time)    |                                            |                                                              |
| Submission/contributor contracts    | Y                                          | N (no blackmail or futher oppression,                        |
|                                     |                                            | just follow the open source software license freedoms)       |
| Submission barrier                  | High                                       | Lower                                                        |
| Node/cargo lockfile scanning        | N                                          | Y                                                            |
| Vulnerability DB sources            | CPE/CVE (NVD), GLSA                        | NVD, GLSA, CISA KEV, GHSA, HW/SW vendors, podcasts, AI apps  |
| Fixes submitted to upstream         | Sometimes                                  | Very rare                                                    |
| Container ebuilds for               | N                                          | N, possible if community agrees                              |
| blast radius mitigation             |                                            |                                                              |
| LICENSE variable transparency       | Missing sometimes                          | More comprehensive if ebuild created by overlay              |
|                                     | Usually only software and some patent      |                                                              |
|                                     | licenses are listed but missing maybe      |                                                              |
|                                     | service licenses, privacy policy           |                                                              |
| CPU support                         | x86-64-v2 or x86-64-v3 newer CPUs are      | Lower CPU requirements if possible                           |
|                                     | sometimes required                         |                                                              |
| Toolchain stability                 | Rolling compiler versions used by unstable | LTS compilers versions used by LTS distro releases are       |
|                                     | distros releases or rolling only distros   | preferred.  Virtually no build time failures.                |
|                                     | are preferred.  Possible build failure if  |                                                              |
|                                     | if the the default C/C++ changes or        |                                                              |
|                                     | possibily new security issue (e.g. DoS,    |                                                              |
|                                     | crash, or worst RCE).                      |                                                              |
| Ebuild operationality               | Ready, low failure rate                    | Varies, most are ready but some fail if long compile times   |
