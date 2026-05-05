### 2023 policy

Due to recent hacking near the beginning of the year (or earlier) of a prominent
member of the open source community who happens to also use the distro, it was
decided to (1) add proactive scanning of malware for binary blobs and
Electron/NPM based packages; and to (2) add proactive scanning of Electron/NPM
based packages for session-replay dependencies or command line options that may
result in unauthorized screen capture that may steal sensitive information and
also scan for analytics.

To use the proactive malware scan, you must install `app-antivirus/clamav[clamapp]`.

The policy for suspected analytics or session replay is "deny" build and install.

It can be enabled or disabled using per-package USE flags or systemwide through
make.conf.  Examples how to do this are shown below:

```
# Contents of /etc/portage/env/disable-avscan.conf
# 0 to disable, 1 to enable.
SECURITY_SCAN_AVSCAN=0
```

```
# Contents of /etc/portage/env/allow-analytics.conf
# allow means continue build/install, deny or unset means stop build/install.
SECURITY_SCAN_ANALYTICS="allow"
```

```
# Contents of /etc/portage/env/allow-session-replay.conf
# allow means continue build/install, deny or unset means stop build/install.
SECURITY_SCAN_SESSION_REPLAY="allow"
```

```
# Contents of /etc/portage/package.env:
dev-util/devhub allow-analytics.conf
sys-kernel/ot-sources disable-avscan.conf
media-gfx/blockbench disable-avscan.conf
media-gfx/upscayl allow-session-replay.conf
media-video/sr disable-avscan.conf
```
