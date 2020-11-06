#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Starter.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Starter is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Starter. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Starter, please visit:
# https://github.com/openflighthpc/flight-starter
#==============================================================================
set fd_command = `echo $args | cut -f1 -d' '`

source ${flight_ROOT}/etc/flight-starter.cshrc

if ( "$fd_command" == "start" ) then
  if (! $?flight_DEFINES) then
     setenv flight_DEFINES_exits ""
     setenv flight_DEFINES "flight_ACTIVE"
  endif
  if ($?prompt) then
    source ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.csh
    source ${flight_ROOT}/etc/flight-starter.cshrc
    if ( -f /etc/xdg/flight/settings.cshrc ) then
      source /etc/xdg/flight/settings.cshrc
    endif
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
  setenv flight_ACTIVE true
  set _exit=$?
else if ( "$fd_command" == "stop" ) then
  if ($?prompt) then
    echo "${flight_STARTER_product} is already inactive."
  endif
  set _exit=$?
else if ( "$fd_command" == "set" || "$fd_command" == "info" ) then
  ${flight_ROOT}/bin/flight $args
  set _exit=$?
else if ( "$fd_command" == "" ) then
  if ( ! $?TERM ) then
    setenv TERM=dumb
  endif
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
foreach var (`set | grep '^flight_STARTER' | cut -f1 | xargs`)
  unset $var
end
unset var
test 0 = $_exit
