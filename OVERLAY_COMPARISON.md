# Overlay comparison

| Topic                               | gentoo-overlay                                            | oiledmachine-overlay                                        |
| ---                                 | ---                                                       | ---                                                         |
| Core developers                     | Many                                                      | 1                                                           |
| AI ban                              | Y                                                         | N                                                           |
| Ebuild code style                   | Original (reputation damaging, bad hire)                  | Custom (pretty, job friendly style)                         |
|                                     | Messy/inconsistent or >= 80 characters                    | Mostly within 80 characters                                 |
| Organization                        | Y                                                         | N                                                           |
| Primary ebuild goals                | Build customization                                       | Anti DoS, anti lag, production grade performance            |
| Secondary ebuild goals              | Portability                                               | Feature complete (aka full version) ebuilds                 |
|                                     | Simple/basic ebuilds                                      | Power user customization                                    |
|                                     |                                                           | Packaging power user or must have software                  |
|                                     |                                                           | New/custom feature patches                                  |
|                                     |                                                           | Dummy proofing / guardrails                                 |
| Runtime performance                 | Slow sometimes or difficult to find bottleneck if ricing  | Reproducible with guardrails and warnings                   |
| Compiler hardening                  | Balanced, outdated or missing flags                       | Custom, recent hardening flags                              |
| C++ consistency                     | N, user is responsible, difficult to find when            | Y, enforced by gcc_slot_* USE flags and REQUIRED_USE        |
|                                     | build logging is off by default for used C++ standard.    |                                                             |
| Multiple AI platform install        | N, impossible (require containers)                        | Y                                                           |
| (e.g. Ollama and LocalAI same time) |                                                           |                                                             |
| Submission/contributor contracts    | Y                                                         | N (no blackmail or futher oppression,                       |
|                                     |                                                           | just follow the open source software license)               |
| Submission barrier                  | High                                                      | Lower                                                       |
| Node/cargo lockfile scanning        | N                                                         | Y                                                           |
| Vulnerability DB sources            | CPE/CVE (NVD), GLSA                                       | NVD, GLSA, CISA KEV, GHSA, HW/SW vendors, podcasts, AI apps |
| Fixes submitted to upstream         | Sometimes                                                 | Very rare                                                   |
| Container ebuilds for               | N                                                         | N, possible if community agrees                             |
| blast radius mitigation             |                                                           |                                                             |
| LICENSE variable transparency       | Missing sometimes                                         | More comprehensive if ebuild created by overlay             |
|                                     | Only software and some patent licenses                    |                                                             |
|                                     | but missing maybe service licenses and                    |                                                             |
|                                     | privacy policy                                            |                                                             |
| CPU support                         | x86-64-v2 or x86-64-v3 is sometimes required              | Lower CPU requirements if possible                          |
