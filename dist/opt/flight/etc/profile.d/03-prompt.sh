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
  c=${flight_STARTER_prompt_color:-1;32;40}
  name="\[\e[${c}m\]($name)\[\e[0m\]"
  unset c

  if [[ "$PS1" == *'\h'* ]]; then
    # If there is a hostname element in the prompt (`\h`), we inject the
    # cluster name after it.
    PS1=${PS1/\\h/\\h $name}
  elif [[ "$PS1" == *'\W'* ]]; then
    # Next we attempt to inject it before any working directory element (`\W`).
    PS1=${PS1/\\W/$name \\W}
  elif [[ "$PS1" == *'\$'* ]]; then
    # Finally, we fallback to injecting it before the prompt terminator (`\$`).
    PS1=${PS1/\\\$/$name \\\$}
  fi
  # If none of the above elements exist, we leave the prompt unchanged.
fi

if [ ${SHLVL:-1} -gt 1 ]; then
  if [[ "$PS1" == *'\$'* ]]; then
    # Try injecting subshell indicator before the prompt terminator (`\$`).
    PS1=${PS1/\\\$/(+)\\\$}
  elif [[ "$PS1" == *'\u'* ]]; then
    # If there is a username element in the prompt (`\u`), we inject the
    # subshell indicator before it.
    PS1=${PS1/\\u/(+)\\u}
  elif [[ "$PS1" == *'\h'* ]]; then
    # If there is a hostname element in the prompt (`\h`), we inject the
    # subshell indicator before it.
    PS1=${PS1/\\h/(+)\\h}
  elif [[ "$PS1" == *'\W'* ]]; then
    # Finally we attempt to inject it after any working directory element (`\W`).
    PS1=${PS1/\\W/\\W(+)}
  fi
  # If none of the above elements exist, we leave the prompt unchanged.
fi

unset name
unset $(declare | grep ^flight_STARTER | cut -f1 -d= | xargs)
