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
_flight_starter_bootstrap() {
  if [ -f /etc/xdg/flight/settings.rc ]; then
    . /etc/xdg/flight/settings.rc
  fi
  if [ -f "$HOME"/.config/flight/settings.rc ]; then
    . "$HOME"/.config/flight/settings.rc
  fi
  if ( ( shopt -q login_shell || \
           [ "${flight_STARTER_secondary:-enabled}" == "enabled" ]
       ) && \
         [ "${flight_STARTER_always}" == "enabled" ]
     ) || \
       [ "${flight_SYSTEM_start:-${flight_STARTER_force}}" == "true" ]; then
    flight start
  elif [ -t 0 -a "${flight_STARTER_welcome:-enabled}" == "enabled" ]; then
      /bin/bash "${flight_ROOT}"/libexec/flight-starter/welcome.sh
  fi
  unset $(declare | grep ^flight_STARTER | cut -f1 -d= | xargs)
}

_flight_starter_needs_restart() {
  if [ ${BASH_VERSINFO[0]} -gt 4 ] ||
     [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -gt 3 ] ||
     [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -eq 3 -a ${BASH_VERSINFO[2]} -ge 27 ]; then
    if xargs -n1 -0 -a /proc/self/environ 2>/dev/null | grep -q 'BASH_FUNC_flight()=()' &&
       ! xargs -n1 -0 -a /proc/self/environ 2>/dev/null | grep -q 'BASH_FUNC_flight%%=()'; then
      return 0
    fi
  fi
}

if [ "${flight_ACTIVE}" != "true" ]; then
    _flight_starter_bootstrap
elif _flight_starter_needs_restart; then
    flight_STARTER_force=true
    _flight_starter_bootstrap
fi
unset _flight_starter_bootstrap _flight_starter_needs_restart
