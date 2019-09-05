################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
IFS=: read -a xdg_config <<< "${XDG_CONFIG_HOME:-$HOME/.config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
for a in "${xdg_config[@]}"; do
  if [ -e "${a}"/flight.rc ]; then
    source "${a}"/flight.rc
    break
  fi
done
flight_ROOT="${flight_ROOT:-/opt/flight}"
if [ -d "${flight_ROOT}"/libexec/hooks ]; then
  shopt -s nullglob
  for a in "${flight_ROOT}"/libexec/hooks/*; do
    source "${a}"
  done
  shopt -u nullglob
fi

if [ -f "$HOME"/.config/flight/settings.rc ]; then
  . "$HOME"/.config/flight/settings.rc
fi

if [ -f "${flight_ROOT}"/etc/flight-starter.rc ]; then
  . "${flight_ROOT}"/etc/flight-starter.rc
fi

cluster="${flight_STARTER_cluster_name:-your cluster}"
bold="$(tput bold)"
green="$(tput setaf 2)"
clr="$(tput sgr0)"
if [[ $TERM == "xterm-256color" ]]; then
  white="$(tput setaf 7)"
  bgblue="$(tput setab 68)"
  bgblack="$(tput setab 0)"
  blue="$(tput setaf 68)"
  grey="$(tput setaf 249)"
  bwhite="$(tput setaf 15)"
fi
release="$(cut -f1,2,4 -d' ' /etc/redhat-release)"
cat <<EOF
${bgblack} ${blue}-[${clr}${bgblack} $(eval echo ${flight_STARTER_banner})${clr}${bgblack} ${blue}]- ${clr}
Welcome to ${bold}${green}${cluster}${clr}, based on ${bold}${release}${clr}.

EOF
if [ "${flight_STARTER_hint:-enabled}" == "enabled" ]; then
  cat <<EOF
This cluster provides ${flight_STARTER_desc}.

${bold}${white}'${bgblue}flight start${clr}${bold}${white}'${clr} - activate ${flight_STARTER_product} now
${bold}${white}'${bgblue}flight info${clr}${bold}${white}'${clr}  - get some brief help about ${flight_STARTER_product}
${bold}${white}'${bgblue}flight set${clr}${bold}${white}'${clr}   - change login defaults (see 'flight info' for details)

EOF
fi
