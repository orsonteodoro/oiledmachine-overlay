## Contributing ebuilds

### Submissions that are considered for acceptance

1. Artificial Intelligence (AI) libraries and apps
2. Machine Learning (ML) libraries and apps
3. Game development apps
4. Graphic arts apps
5. Electron based apps
6. Tauri based apps
7. Security libs or apps
8. Utility apps
9. Developer tools
10. Bug fixes
11. Security fixes

#### See also

[The security policy](SECURITY.md)
[The overlay ebuild style guideline](EBUILD_STYLE_GUIDELINE.md)

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

#### Uploading to this repo

1. Fork the repo
2. Create a feature branch
3. Make changes to the feature branch
4. Follow and create a
[pull request from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).
5. In your pull request state the following:
   - The purpose/summary.
   - Estimate of how long you expect to finish.
     - Do not exceed a week.
     - For scheduled updates like ot-kernel eclass, you are only allowed
       8 hours.
   - State all `<category>/<package>` or paths that you will be editing so we
     avoid merge conflicts.
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
   - Submissions are to be evaluated and merged no more than a week.
   (The reason is that I may edit the whole thing or whole category).
   - For submissions that edit scheduled updates like ot-kernel eclass, you are
     only allowed 8 hours.
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
6. The minor branch is older than 2 relative to the current version, except
when they are needed for testing.

## Overlay maintainers

Spots for overlay maintainers are available.  Due to security reasons, extra
level of qualification standards and checks are required.

You need at least one of the following to qualify:

1. You have an open source project on a well known repo service.
2. We have met in person.
3. Brief interview over voice with a demo of your project on a video sharing
site and code samples.
4. You were an overlay maintainer.

### Skills required

1. git command line experience (or prior experience with version control
and willing to learn git)
2. Shell scripting
3. Ebuild experience
4. Experience with this distro
5. Experience with creating patch files
6. Be able to follow the terms and obligations of the project licenses.
