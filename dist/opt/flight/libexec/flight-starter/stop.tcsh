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
source ${flight_ROOT}/etc/flight-starter.cshrc

foreach rvar (${flight_DEFINES_exits})
  eval $rvar
end
unset rvar
unsetenv flight_DEFINES_exits

setenv flight_DEFINES_paths $flight_DEFINES_paths
set path = `bash -c 'source ${flight_ROOT}/libexec/flight-starter/strip-path.sh; echo $PATH'`
unsetenv flight_DEFINES_paths
unset flight_DEFINES_paths

foreach evar (${flight_DEFINES})
  unsetenv $evar
end
unset evar

foreach avar (${flight_DEFINES})
  unalias $avar
end
unset avar

foreach var (${flight_DEFINES})
  unset $var
end
unset var

foreach var (`env | grep '^flight_DEFINES_orig_' | cut -f1 -d= | xargs`)
  set tgt=`echo "$var" | cut -f4- -d'_'`
  set val="`env | grep ^${var}= | cut -f2- -d=`"
  eval "set $tgt='${val}'"
  unset tgt val
  unsetenv $var
end
unset var

unsetenv flight_DEFINES

set prefix=""
set postfix=""

if ( $?histchars ) then
  set histchar = `echo $histchars | cut -c1`
  set _histchars = $histchars

  set prefix  = 'unset histchars;'
  set postfix = 'set histchars = $_histchars;'
else
  set histchar = \!
endif

set postfix = "set _exit="'$status'"; $postfix; test 0 = "'$_exit;'
alias flight $prefix'set args="'$histchar'*";source ${flight_ROOT}/libexec/flight-starter/main.tcsh; '$postfix;
unset prefix postfix

if ( ! $?flight_ACTIVE ) then
  setenv flight_ACTIVE false
endif

if ($?prompt) then
  echo "${flight_STARTER_product} is now inactive."
endif

foreach var (`set | grep '^flight_STARTER' | cut -f1 | xargs`)
  unset $var
end
unset var

unset _exit
