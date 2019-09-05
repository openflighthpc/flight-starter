################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
set fd_command = `echo $args | cut -f1 -d' '`

source ${flight_ROOT}/etc/flight-starter.cshrc

if ( "$fd_command" == "start" ) then
  if ($?prompt) then
    source ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.csh
    if ( -f "$HOME"/.config/flight/settings.cshrc ) then
      source "$HOME"/.config/flight/settings.cshrc
    endif
    if ( ! $?flight_STARTER_always ) then
       set flight_STARTER_always disabled
    endif
    if ( "${flight_STARTER_always}" != "enabled" ) then
      echo "${flight_STARTER_product} is now active."
    endif
  else
    source ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.csh >& /dev/null
  endif
  unset flight_STARTER_always flight_STARTER_welcome flight_STARTER_hint
  unset flight_STARTER_cluster_name flight_STARTER_desc flight_STARTER_product flight_STARTER_release flight_STARTER_banner flight_STARTER_help_url
  set _exit=$?
else if ( "$fd_command" == "set" || "$fd_command" == "info" ) then
  ${flight_ROOT}/bin/flight $args
  set _exit=$?
else if ( "$fd_command" == "" ) then
  set bold=`tput bold`
  set clr=`tput sgr0`
  cat <<EOF
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 Your ${flight_STARTER_product} environment is not currently active.

 To activate ${flight_STARTER_product}, use $bold'flight start'$clr.

 For some brief help about ${flight_STARTER_product}, use $bold'flight info'$clr.
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
EOF
  unset bold clr
  set _exit=0
else
  echo "flight: unrecognized command for inactive ${flight_STARTER_product} environment"
  set _exit=1
endif

unset fd_command args
test 0 = $_exit
