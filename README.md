# orbit - The Command-Line Interface for _Orbit_ <br> ![GitHub release (latest by date)](https://img.shields.io/github/v/release/katzer/orbit) [![Build Status](https://travis-ci.com/katzer/orbit.svg?branch=master)](https://travis-ci.com/katzer/orbit) [![Build status](https://ci.appveyor.com/api/projects/status/y35hwhpf4w51nc9e/branch/master?svg=true)](https://ci.appveyor.com/project/katzer/orbit/branch/master) [![Maintainability](https://api.codeclimate.com/v1/badges/69da9029f3782acc97a4/maintainability)](https://codeclimate.com/github/katzer/orbit/maintainability)

    $ orbit -h

    Usage: orbit [category] [options...] matchers...
    Categories:
    find                      Query infos
    exec "COMMAND"            Run command
    exec job "JOB"            Run job
    exec script "PATH"        Run script
    upload "SOURCE" "TARGET"  Upload file
    download "SOURCE"         Download file
    web start                 Start web app
    web stop                  Stop web app
    docker build              Build container
    docker start              Start container
    docker stop               Stop container
    export "PATH"             Convert KDB file
    env                       Show env vars
    help                      Print this text
    version                   Show version number

## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.

## Usage

Run a sql script on a database:

    $ orbit exec script "path/to/script.sql" type=db@tags:ora11

Execute a command on a server:

    $ orbit exec "hostname" -p type=server

Download a file from a server:

    $ orbit download "remote/file/path" -l "local/file/path" app-package-1 app-package-2

Start web app from inside a docker container:

    $ orbit docker start

__Note:__ `$ORBIT_HOME/docker_compose.yml` takes precedence over `$ORBIT_HOME/Dockerfile.yml`.

## Development

Clone the repo:
    
    $ git clone https://github.com/katzer/orbit.git && cd orbit/

Install the dependencies:

    $ bundle

And then execute:

    $ rake compile

To compile the sources locally for the host machine only:

    $ MRUBY_CLI_LOCAL=1 rake compile

You'll be able to find the binaries in the following directories:

- Linux (AMD64, Musl): `build/x86_64-alpine-linux-musl/bin/orbit`
- Linux (AMD64, GNU): `build/x86_64-pc-linux-gnu/bin/orbit`
- Linux (AMD64, for old distros): `build/x86_64-pc-linux-gnu-glibc-2.9/bin/orbit`
- OS X (AMD64): `build/x86_64-apple-darwin19/bin/orbit`
- OS X (ARM64): `build/arm64-apple-darwin19/bin/orbit`
- Windows (AMD64): `build/x86_64-w64-mingw32/bin/orbit`
- Host: `build/host/bin/orbit`

For the complete list of build tasks:

    $ rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katzer/orbit.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :heart: in Leipzig

© 2016 [appPlant GmbH][appplant]

[releases]: https://github.com/katzer/orbit/releases
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
