################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
source ${flight_ROOT}/etc/flight-starter.rc

if [ "$1" == "start" ]; then
  if [ "${-#*i}" != "$-" ]; then
    . ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.sh
    if [ -f "$HOME"/.config/flight/settings.rc ]; then
      . "$HOME"/.config/flight/settings.rc
    fi
    if [ "${flight_STARTER_always:-disabled}" != "enabled" ]; then
      echo "${flight_STARTER_product} is now active."
    fi
  else
    . ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.sh >/dev/null 2>&1
  fi
elif [ "$1" == "set" -o "$1" == "info" ]; then
  ${flight_ROOT}/bin/flight "$@"
elif [ -z "$1" ]; then
  bold="$(tput bold)"
  clr="$(tput sgr0)"
  cat <<EOF
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 Your ${flight_STARTER_product} environment is not currently active.

 To activate ${flight_STARTER_product}, use $bold\`flight start\`$clr.

 For some brief help about ${flight_STARTER_product}, use $bold\`flight info\`$clr.
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
EOF
  unset bold clr
else
  echo "flight: unrecognized command for inactive ${flight_STARTER_product} environment"
fi
