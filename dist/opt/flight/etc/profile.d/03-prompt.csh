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
source "${flight_ROOT}"/etc/flight-starter.cshrc
if ( ! $?flight_STARTER_cluster_name ) then
  set name="your cluster"
else
  set name="${flight_STARTER_cluster_name}"
endif

if ( "$name" != "your cluster" ) then
  echo "$prompt" | grep -q "$name"
  if ( $? != 0 ) then
    if ( ! $?flight_STARTER_prompt_color ) then
      set c="1;32;40"
    else
      set c="$flight_STARTER_prompt_color"
    endif
    set name="%{\033[${c}m%}($name)%{\033[0m%}"
    unset c

    echo "$prompt" | grep -q %m
    if ( $? == 0 ) then
      # If there is a hostname element in the prompt (`%m`), we inject the
      # cluster name after it.
      set src_el="%m"
      set tgt_el="%m $name"
    else
      echo "$prompt" | grep -q %c
      if ( $? == 0 ) then
        # Next we attempt to inject it before any working directory element (`%c`).
        set src_el="%c"
        set tgt_el="$name %c"
      else
        echo "$prompt" | grep -q %#
        if ( $? == 0 ) then
          set src_el="%#"
          set tgt_el="$name %#"
        endif
      endif
    endif
    if ( $?src_el ) then
      set tmpf=`mktemp /tmp/03-prompt.csh.XXXXXX`
      set last=`echo "$prompt" | awk -F "$src_el" '{print NF-1}'`
      echo 'set prompt="'"$prompt"'"' | awk '{ print gensub("'"$src_el"'","'"$tgt_el"'",'"$last"') };' > $tmpf
      source $tmpf
      rm -f $tmpf
      unset last src_el tgt_el tmpf
    endif
    # If none of the above elements exist, we leave the prompt unchanged.
  endif
endif

unset name
foreach var (`set | grep '^flight_STARTER' | cut -f1 | xargs`)
  unset $var
end
unset var
