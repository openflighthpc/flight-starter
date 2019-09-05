################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
set flight_STARTER_always=disabled
set flight_STARTER_welcome=enabled

if ( -f "$HOME"/.config/flight/settings.cshrc ) then
  source "$HOME"/.config/flight/settings.cshrc
endif

if ( "${flight_STARTER_always}" == "enabled" ) then
  flight start
else if ( "${flight_STARTER_welcome}" == "enabled" ) then
  /bin/bash "${flight_ROOT}"/libexec/flight-starter/welcome.sh
endif

unset flight_STARTER_always flight_STARTER_welcome flight_STARTER_hint
