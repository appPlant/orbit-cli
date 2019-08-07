## Release Notes: _orbit_

### 1.5.0 - Initial release (not yet released)

The command-line interface for _Orbit_.

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

#### Usage

Run a sql script on a database:

    $ orbit exec script "path/to/script.sql" type=db@tags:ora11

Execute a command on a server:

    $ orbit exec "hostname" -p type=server

Download a file from a server:

    $ orbit download "remote/file/path" -l "local/file/path" app-package-1 app-package-2
