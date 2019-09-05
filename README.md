# Flight Starter

Profile scripts and infrastructure for activating an OpenFlight HPC environment.

## Overview

Flight Starter is installed on OpenFlight clusters to provide users
with a straightforward way of activating the OpenFlight HPC
environment.

## Installation

Flight Starter requires an installation of
[Flight Runway](https://github.com/openflighthpc/flight-runway). Once Flight Runway is installed and available:

1. Clone or download this repository to a convenient temporary location, e.g.:

    ```
    git clone https://github.com/openflighthpc/flight-starter /tmp/flight-starter
    ```

2. Install Flight Starter to your system:

    ```
    cp -Rv /tmp/flight-starter/dist/* /
    ```

3. Clean up the installation area:

    ```
    rm -rf /tmp/flight-starter
    ```

## Operation

Flight Starter hooks in to `/etc/profile.d` and will display a banner
on log in, e.g.:

```
 -[ OpenFlightHPC ]-
Welcome to your cluster, based on CentOS Linux 7.6.1810.

This cluster provides an OpenFlight HPC environment.

'flight start' - activate OpenFlight now
'flight info'  - get some brief help about OpenFlight
'flight set'   - change login defaults (see 'flight info' for details)
```

As outlined, to activate the OpenFlight environment execute the
`flight start` command.

# Contributing

Fork the project. Make your feature addition or bug fix. Send a pull
request. Bonus points for topic branches.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

# Copyright and License

Eclipse Public License 2.0, see [LICENSE.txt](LICENSE.txt) for details.

Copyright (C) 2019-present Alces Flight Ltd.

This program and the accompanying materials are made available under
the terms of the Eclipse Public License 2.0 which is available at
[https://www.eclipse.org/legal/epl-2.0](https://www.eclipse.org/legal/epl-2.0),
or alternative license terms made available by Alces Flight Ltd -
please direct inquiries about licensing to
[licensing@alces-flight.com](mailto:licensing@alces-flight.com).

Flight Starter is distributed in the hope that it will be
useful, but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR
A PARTICULAR PURPOSE. See the [Eclipse Public License 2.0](https://opensource.org/licenses/EPL-2.0) for more
details.
