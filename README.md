# tfw

[![Build Status](https://travis-ci.org/travis-ci/tfw.svg?branch=master)](https://travis-ci.org/travis-ci/tfw)

:sparkles: The Tiny Floating Whale of infrastructure at Travis CI :sparkles:

[![oooOOOOoooooo](https://vignette.wikia.nocookie.net/steven-universe/images/7/7b/TFW.png/revision/latest)](http://steven-universe.wikia.com/wiki/Tiny_Floating_Whale)

This repository contains a script, `./bin/tfw`, and some adjacent supporting
bits, which are meant to be used for a variety of tasks performed during the
lifetime of a Docker-empowered VM.

## Installation

Installation may be done by downloading the `./bin/tfw` script alone, or by
downloading a tarball of this repo and running `make install` accordingly, e.g.:

``` bash
mkdir -p /tmp/tfw
curl -sSL https://api.github.com/repos/travis-ci/tfw/tarball/master |
    tar -C /tmp/tfw --strip-components=1 -xzf -
# Use whatever PREFIX you like!
make -C /tmp/tfw install PREFIX=/usr/local
```

## Usage

Ask for help:

``` bash
tfw help
```

Ask for help about a particular command:

``` bash
tfw help printenv
```

See also: [USAGE.md](USAGE.md)
