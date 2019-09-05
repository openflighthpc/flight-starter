################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
if ( ! $?flight_ROOT ) then
  setenv flight_ROOT /opt/flight
endif
/bin/bash ${flight_ROOT}/etc/profile.d/01-banner.sh
