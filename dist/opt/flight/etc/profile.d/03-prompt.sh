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
export flight_DEFINES_orig_PS1="${PS1}"

if [ "$PS1" = "\\s-\\v\\\$ " ]; then
  # prompt hasn't been set yet, give it a default
  PS1="[\u@\h \W]\\$ "
fi

source "${flight_ROOT}"/etc/flight-starter.rc
name=${flight_STARTER_cluster_name:-your cluster}

if [ "${name}" != "your cluster" ] && ! echo "$PS1" | grep -q "$name"; then
  PS1="$(
    "${flight_ROOT}"/bin/ruby \
    "${flight_ROOT}"/libexec/flight-starter/augment-bash-prompt \
      "$PS1" \
      "$SHLVL" \
      "$name" \
      "${flight_STARTER_prompt_color:-1;32;40}"
  )"
fi

# add activation hint to prompt terminator
if [[ "$TERM" =~ 256color ]]; then
    PS1="$(echo "$PS1" | sed 's/\\\$/\\[\\e[38;2;174;225;249m\\]\\$\\[\\e[0m\\]/')"
else
    PS1="$(echo "$PS1" | sed 's/\\\$/\\[\\e[1;34m\\]\\$\\[\\e[0m\\]/')"
fi

unset name
unset $(declare | grep ^flight_STARTER | cut -f1 -d= | xargs)
