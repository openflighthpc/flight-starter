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
set flight_STARTER_always=disabled
set flight_STARTER_welcome=enabled

if ( -f "$HOME"/.config/flight/settings.cshrc ) then
  source "$HOME"/.config/flight/settings.cshrc
endif

if ( ! $?flight_STARTER_always ) then
  set flight_STARTER_always disabled
endif

if ( ! $?flight_STARTER_force ) then
  set flight_STARTER_force false
endif

if ( ! $?flight_STARTER_welcome ) then
  set flight_STARTER_welcome enabled
endif

if ( "${flight_STARTER_always}" == "enabled" || "${flight_STARTER_force}" == "true" ) then
  flight start
else
  if ( "${flight_STARTER_welcome}" == "enabled" ) then
    /bin/bash "${flight_ROOT}"/libexec/flight-starter/welcome.sh
  endif
endif

foreach var (`set | grep '^flight_STARTER' | cut -f1 | xargs`)
  unset $var
end
unset var
