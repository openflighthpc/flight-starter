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
