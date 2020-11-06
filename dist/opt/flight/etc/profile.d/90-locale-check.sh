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

# Checks if all the LC_* variables are set to the same value
# NOTE: The LC_* vars often have different quotes and capitalizations.
#       These differences are ignored, but as a result empty strings are lost

function warn_locale() {
  cat <<EOF >&2
# Your locale appears to be set inconsistently or does not use unicode.
# This could cause various application to break unexpectedly.

# Run the following commands to set the locale to unicode:
$(printf "$1")

# Alternatively, any locale in this list can be used:
locale -a | grep -i UTF8
EOF
}

function check_locale() {
  # Check for missing LC_* variables excluding LC_ALL
  local var
  for var in $(locale); do
    if [ $(echo "$var" | cut -d= -f1) == 'LC_ALL' ]; then
      continue
    elif [ -z "$(echo "$var" | cut -d= -f2)" ]; then
      warn_locale "$1"
      return
    fi
  done

  # Check if all the locale variables are the same
  # NOTE: The variables may have different casing and quotes. These
  #       differences are ignored. In the process, LC_ALL is ignored
  #       if it is an empty string
  #
  # NOTE: Technically this consider en_US.UTF8 and en_US.UTF-8 as
  #       different locales. Both form valid syntax for the same
  #       locale, but detecting this edge case is tricky.
  #       In practice user's won't use a combination of the two
  local list
  list=$(locale | cut -d= -f2 | xargs -n1 echo | sort | uniq -i)
  if [ "$(echo "$list" | wc -l)" != "1" ]; then
    warn_locale "$1"
    return
  fi

  # Checks that unicode is being used
  if ! echo "$list" | grep -i -E utf-?8 >/dev/null; then
    warn_locale "$1"
    return
  fi
}

if [ "$1" ]; then
  check_locale "$1"
else
  check_locale "export LANG=en_US.utf8\nexport LC_ALL=en_US.utf8"
fi

unset -f warn_locale
unset -f check_locale