################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
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

  if($?loginsh && $?prompt) then
    source ${flight_ROOT}/libexec/flight-starter/bootstrap.tcsh
  endif
endif
