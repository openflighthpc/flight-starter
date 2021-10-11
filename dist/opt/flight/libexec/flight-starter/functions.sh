#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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

# General flight_DEFINES_* definitions
declare -ag flight_DEFINES
declare -ag flight_DEFINES_exits
flight_DEFINES+=(flight_ACTIVE flight_HELPER_remove_path)

# Method for calculating a "Complement Set" of the current PATH
function flight_HELPER_remove_path() {
  # Compute the unsorted complement set
  local new_paths=$(echo "$PATH" | tr : "\n" | sort | uniq)
  local old_paths=$(echo "$1" | tr : "\n" | sort | uniq)
  local unsorted=$(comm -23 <(echo "$new_paths") <(echo "$old_paths"))

  # Convert the unsorted complement into an associative array
  local p
  declare -A unsorted_hash
  while read p; do
    unsorted_hash["$p"]=true
  done <<< "$unsorted"

  # Generate the sorted complement path
  local sorted
  while read -d: p; do
    if [ "${unsorted_hash["$p"]}" == "true" ]; then
      sorted="$sorted:$p"
    fi
  done <<< "$PATH:"

  # Return the sorted path
  printf "$sorted" | sed 's/://'
}
