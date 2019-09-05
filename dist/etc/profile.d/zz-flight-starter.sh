################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
export flight_ROOT=${flight_ROOT:-/opt/flight}
IFS=: read -a xdg_config <<< "${XDG_CONFIG_HOME:-$HOME/.config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
for a in "${xdg_config[@]}"; do
  if [ -e "${a}"/flight.rc ]; then
    source "${a}"/flight.rc
    break
  fi
done
if [ -d "${flight_ROOT}"/libexec/hooks ]; then
  shopt -s nullglob
  for a in "${flight_ROOT}"/libexec/hooks/*; do
    source "${a}"
  done
  shopt -u nullglob
fi
unset a xdg_config

flight() {
  source "${flight_ROOT}"/libexec/flight-starter/main.sh "$@"
}
export -f flight

if shopt -q login_shell && [ "${-#*i}" != "$-" ]; then
  source "${flight_ROOT}"/libexec/flight-starter/bootstrap.sh
fi
