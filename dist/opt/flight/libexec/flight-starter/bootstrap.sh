################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
_flight_starter_bootstrap() {
  local flight_STARTER_always flight_STARTER_welcome flight_STARTER_hint
  if [ -f "$HOME"/.config/flight/settings.rc ]; then
    . "$HOME"/.config/flight/settings.rc
  fi
  if [ "${flight_STARTER_always:-disabled}" == "enabled" ]; then
    flight start
  elif [ -t 0 -a "${flight_STARTER_welcome:-enabled}" == "enabled" ]; then
    /bin/bash "${flight_ROOT}"/libexec/flight-starter/welcome.sh
  fi
}
_flight_starter_bootstrap
unset _flight_starter_bootstrap
