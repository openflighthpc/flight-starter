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
if ($?tcsh) then
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

  if ( -f /etc/xdg/flight.cshrc ) then
    source /etc/xdg/flight.cshrc
  endif

  if ( ! $?flight_ROOT ) then
    setenv flight_ROOT /opt/flight
  endif

  set postfix = "set _exit="'$status'"; $postfix; test 0 = "'$_exit;'
  alias flight $prefix'set args="'$histchar'*";source ${flight_ROOT}/libexec/flight-starter/main.tcsh; '$postfix;
  unset prefix postfix

  if($?prompt) then
    source ${flight_ROOT}/libexec/flight-starter/bootstrap.tcsh
  endif
endif
