################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
(
  bold="$(tput bold)"
  clr="$(tput sgr0)"
  if [[ $TERM == "xterm-256color" ]]; then
    white="$(tput setaf 7)"
    bgblue="$(tput setab 68)"
  fi
  echo -e "TIPS:\n"
  len=$(echo "${bold}${white}'${bgblue}${clr}${bold}${white}'${clr}" | wc -c)
  len=$(($len+20))
  shopt -s nullglob
  for i in "$flight_ROOT"/etc/banner/tips.d/*.rc; do
    . "$i"
    if [ "$flight_TIP_break" == "true" ]; then
      echo ""
      unset flight_TIP_break
    fi
    printf "%-${len}s - %s\n" \
           "${bold}${white}'${bgblue}$flight_TIP_command${clr}${bold}${white}'${clr}" \
           "$flight_TIP_synopsis"
  done
  shopt -u nullglob
  echo ""
)
