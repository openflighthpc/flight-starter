#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
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

for a in "${flight_DEFINES_exits[@]}"; do
  $a
done
unset flight_DEFINES_exits

for a in $(env | grep '^flight_DEFINES_orig_' | cut -f1 -d= | xargs); do
  tgt=$(echo "$a" | cut -f4- -d'_')
  eval "$tgt=\"${!a//\\/\\\\}\""
  unset tgt
  unset $a
done

for a in "${flight_DEFINES[@]}"; do
  unset $a
done
unset flight_DEFINES a

flight() {
  source "${flight_ROOT}"/libexec/flight-starter/main.sh "$@"
}
export -f flight

if [ "${-#*i}" != "$-" ]; then
  echo "${flight_STARTER_product} is now inactive." 1>&2
fi

unset $(declare | grep ^flight_STARTER | cut -f1 -d= | xargs)
