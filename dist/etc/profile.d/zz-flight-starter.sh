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
if [ -z "$BASH_VERSION" ]; then
  return
fi

export flight_ROOT=${flight_ROOT:-/opt/flight}
# record the value of nounset
if [ "${-#*u}" != "$-" ]; then
  set +u
  _nounset_set=true
fi
IFS=: read -a xdg_config <<< "${XDG_CONFIG_HOME:-$HOME/.config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
for a in "${xdg_config[@]}"; do
  if [ -e "${a}"/flight.rc ]; then
    source "${a}"/flight.rc
    break
  fi
done

if [ "$1" == "start" ]; then
  flight_SYSTEM_start=true
fi

if [ -d "${flight_ROOT}"/libexec/hooks ]; then
  shopt -s nullglob
  for a in "${flight_ROOT}"/libexec/hooks/*.sh; do
    source "${a}"
  done
  shopt -u nullglob
fi
unset a xdg_config

if [ "$(type -t flight)" != "function" ]; then
  flight() {
    source "${flight_ROOT}"/libexec/flight-starter/main.sh "$@"
  }
  export -f flight
fi

source "${flight_ROOT}"/libexec/flight-starter/bootstrap.sh

if [ "${_nounset_set}" == "true" ]; then
  set -u
fi
unset flight_SYSTEM_start _nounset_set
