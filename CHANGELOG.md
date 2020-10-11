# Release Notes: _orbit_

The command-line interface for _Orbit_.

## 1.5.1

Released at: 18.03.2020

1. Added `docker start` and `docker stop` categories.

2. Fixed `web start` and `web stop` for Windows.

3. Singularized folder names.

4. Fixed potential memory leaks.

5. Compiled with `MRB_WITHOUT_FLOAT`

6. Compiled binary for OSX build with MacOSX10.15 SDK.

7. Upgraded to mruby 2.1.0

[Full Changelog](https://github.com/appplant/orbit/compare/1.5.0...1.5.1)

## 1.5.0

Released at: 13.08.2019

Initial release

<details><summary>Releasenotes</summary>
<p>

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

Run a sql script on a database:

    $ orbit exec script "path/to/script.sql" type=db@tags:ora11

Execute a command on a server:

    $ orbit exec "hostname" -p type=server

Download a file from a server:

    $ orbit download "remote/file/path" -l "local/file/path" app-package-1 app-package-2

</p>

[Full Changelog](https://github.com/appplant/orbit/compare/eeddffe3cda06958d88e4750f719ae07412c7a3c...1.5.0)
</details>
