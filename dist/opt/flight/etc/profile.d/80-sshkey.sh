################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
if [ -x "${flight_ROOT:-/opt/flight}"/libexec/flight-starter/setup-sshkey ]; then
    "${flight_ROOT:-/opt/flight}"/libexec/flight-starter/setup-sshkey
fi
