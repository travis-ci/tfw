# Usage

### tfw help help

```sh
Usage: tfw help [topic] [exit-code]

Get more help about a topic, optionally injecting an exit code (mostly used
internally).
```

### tfw help version

```sh
Usage: tfw version 

Print the version and exit 0, and that's about it!
```

### tfw help bootstrap

```sh
Usage: tfw bootstrap 
Ensure dependencies are present on the system; intended to be run early in
instance preparation.

NOTE: ${RUNDIR} is used as prefix for cached calculated values
NOTE: ${TMPDIR} and ${VARTMPDIR} are used for temporary bits
NOTE: ${USRBINDIR} is used as prefix installed executables

```

### tfw help app-extract

```sh
Usage: tfw app-extract <name> <image>

Extract systemd service definition and wrapper script, if present, from a given
docker ${image} to system destinations, defaults being:

service definition: ${ETCDIR:-/etc}/systemd/system/${name}.service
wrapper script:     ${USRSBINDIR:-/usr/sbin}/${name}-wrapper

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/systemd/system${name}.service
NOTE: ${USRSBINDIR} is used as prefix for ${USRSBINDIR}/${name}-wrapper
```

### tfw help app-printenv

```sh
Usage: tfw app-printenv <name> [outfile] [-E/--export]

Print the combined configuration for a given thing by name, optionally writing
to a second ${outfile} argument.  If -E/--export is given, then any leading
"export " statements will not be stripped.

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/default/
```

### tfw help app-writeenv

```sh
Usage: tfw app-writeenv <name> [dest-basename]

Write the combined configuration for a given thing by name to ${RUNDIR}/,
defaulting to ${RUNDIR}/${name}.env, but optionally to a custom dest basename.

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/default/NOTE: ${RUNDIR} is used as prefix for ${RUNDIR}/${name}.env
```

### tfw help urldecode

```sh
Usage: tfw urldecode <url-encoded-string> [url-encoded-string, ...]

URL-decode any number of positional argument strings, handling 'quote plus'
encoding as well, e.g.

  tfw urldecode what%2Fthe+what%3F
```

### tfw help gsub

```sh
Usage: tfw gsub <name> <infile> [outfile]

Substitute strings with platform and instance-dependent runtime values,
optionally writing to an output file.

  ___INSTANCE_ID___   - instance identifier, e.g. i-fafafaf
  ___INSTANCE_NAME___ - instance name, e.g. production-8-juicero-f-2-gce
  ___INSTANCE_IPV4___ - instance ipv4 address, e.g. 10.10.9.8
  ___REGION_ZONE__    - region + zone, e.g. us-central1-d

```

### tfw help admin-bootstrap

```sh
Usage: tfw admin-bootstrap 

Run multiple admin-* tasks, attempting to fetch configuration from
${ETCDIR}/default files in the following order, with relevant variables:

${ETCDIR}/default/tfw
  + TFW_DUO_CONF - path to a duo config file
  + TFW_FAIL2BAN_SSH_BANTIME - int for fail2ban ssh jail ban time
  + TFW_FAIL2BAN_SSH_MAXRETRY - int for fail2ban ssh jail ban retries
  + TFW_GITHUB_USERS - " "-delimited username:github-login pairs
  + TFW_SSH_KEYALGO_BITS  - " "-delimited algo:nbits pairs for ssh keygen

${ETCDIR}/default/fail2ban-ssh
  + FAIL2BAN_SSH_BANTIME (falls back to TFW_FAIL2BAN_SSH_BANTIME)
  + FAIL2BAN_SSH_MAXRETRY (falls back to TFW_FAIL2BAN_SSH_MAXRETRY)

${ETCDIR}/default/github-users
  + GITHUB_USERS (falls back to TFW_GITHUB_USERS)

```

### tfw help admin-docker-volume-setup

```sh
Usage: tfw admin-docker-volume-setup [device] [metadata-size]

Ensure a direct-lvm volume is present for use with the Docker storage backend.
By default, the {device} value is /dev/md0 (as created by admin-raid) and the
{metadata-size} is 2G.

```

### tfw help admin-duo

```sh
Usage: tfw admin-duo [duo-conf]

If a configuration file is present at [duo-conf] (default /var/tmp/duo.conf),
install duo-unix package and configure pam and sshd bits accordingly.  Any users
that are members of the 'sudo' group will also be added to the 'duo' group.

```

### tfw help admin-hostname

```sh
Usage: tfw admin-hostname [hostname-template]

Set system hostname and add /etc/hosts record based on runtime values and
optional {hostname-template} (default=${RUNDIR}/instance-hostname.tmpl).

```

### tfw help admin-librato

```sh
Usage: tfw admin-librato 

If both ${LIBRATO_EMAIL} and ${LIBRATO_TOKEN} are defined, either in the
current env or after evaluating 'app-printenv librato', ensure the librato
collectd APT source is available, install collectd, and configure accordingly.

```

### tfw help admin-raid

```sh
Usage: tfw admin-raid [device] [raid-level]

Set up a multi-disk volume at [device] (default /dev/md0) with raid level
[raid-level] (default 0) from all available disks, as determined by looking at
all available /dev/sd* devices.

```

### tfw help admin-rsyslog

```sh
Usage: tfw admin-rsyslog [syslog-address]

Ensure rsyslog forwarding is enabled if a [syslog-address] is available, reading
from ${RUNDIR}/syslog-address by default.

```

### tfw help admin-run-docker

```sh
Usage: tfw admin-run-docker 

Run dockerd in the foreground after reading the necessary configuration bits and
potentially running admin-docker-volume-setup.

```

### tfw help admin-ssh

```sh
Usage: tfw admin-ssh [ssh-maxretry] [ssh-bantime] [keyalgo:bits, keyalgo:bits, ...]

Enable and configure SSH server keys and fail2ban SSH jail.

```

### tfw help admin-travis-sudo

```sh
Usage: tfw admin-travis-sudo 

Disable sudo access for travis user if it exists.

```

### tfw help admin-users

```sh
Usage: tfw admin-users <username:github-login> [username:github-login, ]

Ensure local users exist with SSH authorized keys added from GitHub.

```
# Usage

## tfw help help

```sh
Usage: tfw help [topic] [exit-code]

Get more help about a topic, optionally injecting an exit code (mostly used
internally).
```

## tfw help version

```sh
Usage: tfw version 

Print the version and exit 0, and that's about it!
```

## tfw help bootstrap

```sh
Usage: tfw bootstrap 
Ensure dependencies are present on the system; intended to be run early in
instance preparation.

NOTE: ${RUNDIR} is used as prefix for cached calculated values
NOTE: ${TMPDIR} and ${VARTMPDIR} are used for temporary bits
NOTE: ${USRBINDIR} is used as prefix installed executables

```

## tfw help app-extract

```sh
Usage: tfw app-extract <name> <image>

Extract systemd service definition and wrapper script, if present, from a given
docker ${image} to system destinations, defaults being:

service definition: ${ETCDIR:-/etc}/systemd/system/${name}.service
wrapper script:     ${USRSBINDIR:-/usr/sbin}/${name}-wrapper

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/systemd/system${name}.service
NOTE: ${USRSBINDIR} is used as prefix for ${USRSBINDIR}/${name}-wrapper
```

## tfw help app-printenv

```sh
Usage: tfw app-printenv <name> [outfile] [-E/--export]

Print the combined configuration for a given thing by name, optionally writing
to a second ${outfile} argument.  If -E/--export is given, then any leading
"export " statements will not be stripped.

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/default/
```

## tfw help app-writeenv

```sh
Usage: tfw app-writeenv <name> [dest-basename]

Write the combined configuration for a given thing by name to ${RUNDIR}/,
defaulting to ${RUNDIR}/${name}.env, but optionally to a custom dest basename.

NOTE: ${ETCDIR} is used as prefix for ${ETCDIR}/default/NOTE: ${RUNDIR} is used as prefix for ${RUNDIR}/${name}.env
```

## tfw help urldecode

```sh
Usage: tfw urldecode <url-encoded-string> [url-encoded-string, ...]

URL-decode any number of positional argument strings, handling 'quote plus'
encoding as well, e.g.

  tfw urldecode what%2Fthe+what%3F
```

## tfw help gsub

```sh
Usage: tfw gsub <name> <infile> [outfile]

Substitute strings with platform and instance-dependent runtime values,
optionally writing to an output file.

  ___INSTANCE_ID___   - instance identifier, e.g. i-fafafaf
  ___INSTANCE_NAME___ - instance name, e.g. production-8-juicero-f-2-gce
  ___INSTANCE_IPV4___ - instance ipv4 address, e.g. 10.10.9.8
  ___REGION_ZONE__    - region + zone, e.g. us-central1-d

```

## tfw help admin-bootstrap

```sh
Usage: tfw admin-bootstrap 

Run multiple admin-* tasks, attempting to fetch configuration from
${ETCDIR}/default files in the following order, with relevant variables:

${ETCDIR}/default/tfw
  + TFW_DUO_CONF - path to a duo config file
  + TFW_FAIL2BAN_SSH_BANTIME - int for fail2ban ssh jail ban time
  + TFW_FAIL2BAN_SSH_MAXRETRY - int for fail2ban ssh jail ban retries
  + TFW_GITHUB_USERS - " "-delimited username:github-login pairs
  + TFW_SSH_KEYALGO_BITS  - " "-delimited algo:nbits pairs for ssh keygen

${ETCDIR}/default/fail2ban-ssh
  + FAIL2BAN_SSH_BANTIME (falls back to TFW_FAIL2BAN_SSH_BANTIME)
  + FAIL2BAN_SSH_MAXRETRY (falls back to TFW_FAIL2BAN_SSH_MAXRETRY)

${ETCDIR}/default/github-users
  + GITHUB_USERS (falls back to TFW_GITHUB_USERS)

```

## tfw help admin-docker-volume-setup

```sh
Usage: tfw admin-docker-volume-setup [device] [metadata-size]

Ensure a direct-lvm volume is present for use with the Docker storage backend.
By default, the {device} value is /dev/md0 (as created by admin-raid) and the
{metadata-size} is 2G.

```

## tfw help admin-duo

```sh
Usage: tfw admin-duo [duo-conf]

If a configuration file is present at [duo-conf] (default /var/tmp/duo.conf),
install duo-unix package and configure pam and sshd bits accordingly.  Any users
that are members of the 'sudo' group will also be added to the 'duo' group.

```

## tfw help admin-hostname

```sh
Usage: tfw admin-hostname [hostname-template]

Set system hostname and add /etc/hosts record based on runtime values and
optional {hostname-template} (default=${RUNDIR}/instance-hostname.tmpl).

```

## tfw help admin-librato

```sh
Usage: tfw admin-librato 

If both ${LIBRATO_EMAIL} and ${LIBRATO_TOKEN} are defined, either in the
current env or after evaluating 'app-printenv librato', ensure the librato
collectd APT source is available, install collectd, and configure accordingly.

```

## tfw help admin-raid

```sh
Usage: tfw admin-raid [device] [raid-level]

Set up a multi-disk volume at [device] (default /dev/md0) with raid level
[raid-level] (default 0) from all available disks, as determined by looking at
all available /dev/sd* devices.

```

## tfw help admin-rsyslog

```sh
Usage: tfw admin-rsyslog [syslog-address]

Ensure rsyslog forwarding is enabled if a [syslog-address] is available, reading
from ${RUNDIR}/syslog-address by default.

```

## tfw help admin-run-docker

```sh
Usage: tfw admin-run-docker 

Run dockerd in the foreground after reading the necessary configuration bits and
potentially running admin-docker-volume-setup.

```

## tfw help admin-ssh

```sh
Usage: tfw admin-ssh [ssh-maxretry] [ssh-bantime] [keyalgo:bits, keyalgo:bits, ...]

Enable and configure SSH server keys and fail2ban SSH jail.

```

## tfw help admin-travis-sudo

```sh
Usage: tfw admin-travis-sudo 

Disable sudo access for travis user if it exists.

```

## tfw help admin-users

```sh
Usage: tfw admin-users <username:github-login> [username:github-login, ]

Ensure local users exist with SSH authorized keys added from GitHub.

```