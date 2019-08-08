# orbit - The Command-Line Interface for _Orbit_ <br> 
[![GitHub release](https://img.shields.io/github/release/appplant/orbit.svg)](https://github.com/appplant/orbit/releases) [![Build Status](https://travis-ci.com/appPlant/orbit.svg?branch=master)](https://travis-ci.com/appPlant/orbit) [![Build status](https://ci.appveyor.com/api/projects/status/y35hwhpf4w51nc9e/branch/master?svg=true)](https://ci.appveyor.com/project/katzer/orbit/branch/master) [![Maintainability](https://api.codeclimate.com/v1/badges/69da9029f3782acc97a4/maintainability)](https://codeclimate.com/github/appPlant/orbit/maintainability)

    $ orbit -h

    Usage: orbit [category] [options...] matchers...
    Categories:
    find                      Query planet infos
    exec "COMMAND"            Run command
    exec job "JOB"            Run job
    exec script "PATH"        Run script
    upload "TARGET" "SOURCE"  Upload file
    download "SOURCE"         Download file
    web start                 Start web app
    web stop                  Stop web app
    export "PATH"             Convert KDB file
    env                       Show env vars
    help                      Print this text
    version                   Show version number

## Prerequisites

Add `ORBIT_PATH` to your profile:

    $ export ORBIT_PATH=/path/to/orbit/bin

And copy the other tools like [fifa][fifa] to `ORBIT_PATH`.

## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.

## Usage

Run a sql script on a database:

    $ orbit exec script "path/to/script.sql" type=db@tags:ora11

Execute a command on a server:

    $ orbit exec "hostname" -p type=server

Download a file from a server:

    $ orbit download "remote/file/path" -l "local/file/path" app-package-1 app-package-2

## Development

Clone the repo:
    
    $ git clone https://github.com/appplant/orbit.git && cd orbit/

Install the dependencies:

    $ bundle

And then execute:

    $ rake compile

To compile the sources locally for the host machine only:

    $ MRUBY_CLI_LOCAL=1 rake compile

You'll be able to find the binaries in the following directories:

- Linux (64-bit Musl): `build/x86_64-alpine-linux-musl/bin/orbit`
- Linux (64-bit GNU): `build/x86_64-pc-linux-gnu/bin/orbit`
- Linux (64-bit, for old distros): `build/x86_64-pc-linux-gnu-glibc-2.9/bin/orbit`
- OS X (64-bit): `build/x86_64-apple-darwin17/bin/orbit`
- Windows (64-bit): `build/x86_64-w64-mingw32/bin/orbit`
- Host: `build/host/bin/orbit`

For the complete list of build tasks:

    $ rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appplant/orbit.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :heart: in Leipzig

© 2016 [appPlant GmbH][appplant]

[fifa]: https://github.com/appplant/fifa
[releases]: https://github.com/appplant/orbit/releases
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
