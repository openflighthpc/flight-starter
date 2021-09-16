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
source ${flight_ROOT}/etc/flight-starter.rc

if [ "$1" == "start" ]; then
  if [ -z "${flight_DEFINES}" ]; then
    flight_DEFINES=(flight_ACTIVE)
    flight_DEFINES_exits=()
    flight_DEFINES_paths=" "
    # NOTE: The "export flight_DEFINES" and "export flight_DEFINES_exists"
    # does not work as bash cannot export arrays.
    #
    # The broken exports are being maintained for reference, one of the
    # following should be done:
    # * Update the relevant calls to use a string, or
    # * Remove the exports
    export flight_DEFINES flight_DEFINES_exits
  fi
  if [ "${-#*i}" != "$-" ]; then
    . ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.sh
    . ${flight_ROOT}/etc/flight-starter.rc
    if [ -f /etc/xdg/flight/settings.rc ]; then
      . /etc/xdg/flight/settings.rc
    fi
    if [ -f "$HOME"/.config/flight/settings.rc ]; then
      . "$HOME"/.config/flight/settings.rc
    fi
    if [ "${flight_STARTER_always:-disabled}" != "enabled" ]; then
      echo "${flight_STARTER_product} is now active."
    fi
  else
    . ${flight_ROOT}/opt/runway/dist/etc/profile.d/alces-flight.sh >/dev/null 2>&1
  fi
  export flight_ACTIVE=true
elif [ "$1" == "stop" ]; then
  if [ "${-#*i}" != "$-" ]; then
    echo "${flight_STARTER_product} is already inactive."
  fi
elif [ "$1" == "set" -o "$1" == "info" ]; then
  ${flight_ROOT}/bin/flight "$@"
elif [ -z "$1" ]; then
  export TERM=${TERM:-dumb}
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

unset $(declare | grep ^flight_STARTER | cut -f1 -d= | xargs)
