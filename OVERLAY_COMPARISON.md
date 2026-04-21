# Overlay comparison

| Topic                               | gentoo [overlay]                           | oiledmachine-overlay                                         |
| ---                                 | ---                                        | ---                                                          |
| Core developers                     | Many                                       | 1                                                            |
| AI ban                              | Y (opportunity cost, lowered security, more evil and less utilitarian, the [1] policy is more evil to the developer and unaffected by big tech which will continue doing what they will do, hypocritical use of energy by being a source based distro, and wasting more energy on non AI assisted rebuilds, the policy has a similarity to luddite narratives) | N (AI is used to fix trivial security compiler warnings like UAF and string format vulnerabilies that are typically rated critical to high severity; generate and secure ebuilds and artifacts (e.g. build files, config files, patches) with human critical oversight and change) |
| Ebuild code style                   | The original language docs style from the 70s-80s (reputation damaging, bad hire), messy/inconsistent or >= 80 characters | Custom contemporary (pretty, job friendly style).  Mostly within 80 characters |
| Distro owned/backed                 | Y                                          | N                                                            |
| Primary ebuild package goals        | Build customization, simple/basic ebuilds  | Anti DoS, anti lag, production grade performance             |
| Secondary ebuild package goals      | Cross compile portability | Feature complete (aka full version) ebuilds, power user customization; packaging awesome software; new/custom feature patches exclusives, dummy proofing, guardrails |
| Documentation style                 | Simple, undocumented mods or undocumented known settings leading to performance regressions | Transparent and comprehensive, mods and regressions are documented and warned to user |
| Runtime performance                 | Slow sometimes or difficult to find bottleneck if ricing | Reproducible with guardrails and warnings      |
| Compiler hardening                  | Balanced, outdated or missing flags, inappropriate static hardening level | Custom, recent hardening flags, dynamic increased hardening by threat |
| C++ consistency                     | N, user is responsible, difficult to resolve when build logging is off by default and multiple C++ standard versions are involved. | Y, enforced by gcc_slot_* USE flags and REQUIRED_USE |
| Multiple AI platform co-existence (e.g. TensorFlow + LocalAI installed at the same time) | N, impossible (require containers or the container may require newer CPU ISA level) | Y                                          |
| Submission/contributor contracts    | Y                                          | N (no blackmail or further oppression or no subverting of your rights or no micromanaging by the new guard, just enjoy the open source software license freedoms) |
| Ebuild/patch submission barrier     | High                                       | Lower                                                        |
| Node/cargo lockfile security scanning | N (GitHub Dependabot which uses AI)      | Y (GitHub Dependabot is used for security alerts but not editing.  Editing is done by hand by human or by the package manager.) |
| Vulnerability DB sources            | CPE/CVE (NVD), GLSA                        | NVD, GLSA, CISA KEV, GHSA, HW/SW vendors, podcasts, AI apps  |
| Fixes submitted to upstream         | Sometimes                                  | Very rare                                                    |
| Containerization policy             | Decontainerize packages to be consistent with the build everything by source distro core value (lowers security and increases blast radius, contributes to or (subversively) promotes bad security architecture, is a bad habit or ignorance by an obsolete (or possibly compromised) security team) | Containerize if EOL or if complex build, otherwise decontainerize.  Change possible to increase container ebuilds and use them as dependencies to better security architecture if community approves. |
| LICENSE variable transparency       | Missing sometimes.  Usually only software and some patent licenses are listed but missing maybe service licenses, privacy policy.  License variations may be inappropriately tagged. | More comprehensive if ebuild created by overlay |
| CPU support                         | x86-64-v2 or x86-64-v3 newer CPUs are sometimes required | The lowest CPU requirements if possible for hardware/software immortality reasons |
| Toolchain stability                 | Rolling compiler slots used by distro unstable releases or rolling only distros are preferred.  Possible build failure if the default C/C++ version changes or possibily new security issue (e.g. DoS, crash, or worst RCE). | LTS compiler slots used by distro LTS releases are preferred.  Virtually no build time failures as a result of using practically complete C++ standards that default to stable C++ version that are used and tested by most projects. |
| Ebuild operationality               | Ready, low failure rate with simple @world set, but high strategic failure with complex @world set. | Varies, most are ready but some fail if long compile times or unresolved issues.  Tries to have higher strategic success for complex @world set. |
| Multislot leanings                  | Monoslot is preferred to maintain the facade that the latest package version releases are used | Multislot is preferred to solve strategic success               |
| Ebuild exclusives or unique ebuilds | Y                                          | Y                                                            |
| Build suffering policy              | Rip the bandaid slowly (more suffering, less happiness) | Rip the bandaid fast (less suffering, more happiness) |
| Tarball micropackage bundle for Go / Rust | Y (untrusted in the zero trust model) | N                                                           |
| Reproducible live ebuilds           | N, user is responsible, quality is overlooked or poor due to rashness | Y, with USE=fallback-commit capable ebuilds, some ebuilds have high quality green CI checkmarks threshold requirements to reduce build failure especially for large codebases or long build time ebuild packages |
| Ebuild package count                | ~19230 (Apr 20, 2026)                      | ~1233 (Apr 20, 2026)                                         |
| Quality sought for package inclusion | Actively maintained projects              | Ebuild forks to correct [2] issues or new package additions from awesome lists, hidden gems on GitHub, etc. |

* [1] https://wiki.gentoo.org/wiki/Project:Council/AI_policy
* [2] Security, performance, and dependency resolution are commonly broad categories for reasons for forking.  Forking is undesired but necessary for needs.  The oiledmachine-overlay desires to eliminate forks but forks will stay until the issue is addressed by the distro overlay.  A sample list of issues or fixes for ebuilds encountered reiterated in detail:
- Concern about possibly inconsistent data semantics that may lead to incompatibility or JIT RCE because of lax version constraints in the ebuilds (e.g. rocm ebuilds and dependents)
- Missing LTS support (e.g. multislot nodejs ebuilds)
- Missing x86-64 ISA Level 1 support (e.g. blender ebuild)
- Hardening flags coverage inconsistencies between internal vendored packages and system packages used for web browsers (e.g. -fno-delete-null-pointer-checks, -ftrivial-auto-var-init=zero, etc.)
- Outdated *DEPENDs section which the system packages that are older than vendored secure packages should be a fatal error but is not fatal (e.g. Firefox fatal versus Chromium not fatal in build scripts, defense by depth)
- Resolving multiple versions pulled issue (e.g. abseil-cpp, grpc, protobuf ebuilds)
- Resolving the GLIBCXX versioned symbols issue once and for all for C++ programs touched
- Resolving unpatched vulnerabilies with version bumps (e.g. gstreamer ebuild)
- Version bumps to resolve minimum required version
- Missing features found in well known counterparts, possibly politicalization by banning big tech contributions or FUD components which end users are not given a chance to use them hurting their learning or harm rapport building which is anti-utilitarian, denying features that upstream developed and promotes outstandingly.  Typically, the end user doesn't care but the distro packager or team are too political or hold a grudge against certain companies.  (e.g. C# and mobile support in Godot.)
- Insufficient USE flags as a result of disagreement of packaging (e.g. embree ebuild)
- An observation of a better security configuration which the distro denies you or ignorant about (e.g. mimalloc ebuild)
- Fixing inappropriate security configurations by FAFO users or a package used in the red zone (e.g. mimalloc ebuild, web dependencies)
- Resolving performance issues below motion picture FPS caused by FAFO users using the wrong optimization level or USE flag (e.g. dav1d, firefox ebuilds)
- Forced slow build performance (e.g. ninja-utils.eclass -l flag; webkitgtk ebuild's -Wl,--no-keep-memory time complexity; chromium ebuild's forced mksnapshot build that doubles build time)
