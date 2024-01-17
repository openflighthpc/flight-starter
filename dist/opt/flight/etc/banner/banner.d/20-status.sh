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
(
  # Only show for users with sudo
  if ! sudo -l -n sudo >/dev/null 2>&1 ; then
    exit
  fi

  # Don't show unless enabled with 'flight set status on'
  if [[ ${flight_STARTER_status:-'disabled'} != "enabled" ]] ; then
    exit
  fi

  # Skip if flight-profile and flight-hunter are not present
  if ! [[ -f ${flight_ROOT}/libexec/commands/profile && -f ${flight_ROOT}/libexec/commands/hunter ]] ; then
    echo "Cluster Status: Not showing (Profile & Hunter not found)"
    exit
  fi

  # Set formatting
  bold="$(tput bold)"
  clr="$(tput sgr0)"
  if [[ $TERM =~ "256color" ]]; then
    white="$(tput setaf 7)"
    bgblue="$(tput setab 68)"
    bgred="$(tput setab 210)"
    bgorange="$(tput setab 136)"
    bggreen="$(tput setab 64)"
  fi
  echo -e "CLUSTER STATUS:\n"
  shopt -s nullglob

  # Hunter info
  printf "${bold}${white}${bgblue}Hunted Nodes$flight_TIP_command${clr}${bold}${white}${clr}\n"
  printf "  ${bold}${white}${bggreen}Parsed:$flight_TIP_command${clr}${bold}${white}${clr}\
    $(ls ${flight_ROOT}/opt/hunter/var/parsed/ | wc -l)\
    ${bold}${white}${bgorange}Buffer:$flight_TIP_command${clr}${bold}${white}${clr}\
    $(ls ${flight_ROOT}/opt/hunter/var/buffer/ | wc -l)\n"
  echo ""

  # Profile info
  finished="$(grep exit_status ${flight_ROOT}/opt/profile/var/inventory/* |awk '{print $2}' |grep -v '^$')"
  completed_nodes="$(echo "$finished" |grep '^0$' |grep -v '^$' -c )"
  failed_nodes="$(echo "$finished" |grep -v '^0$' |grep -v '^$' -c )"
  applying_nodes="$(grep deployment_pid ${flight_ROOT}/opt/profile/var/inventory/* |awk '{print $2}' |grep -v '^$' -c)"
  printf "${bold}${white}${bgblue}Configured Nodes$flight_TIP_command${clr}${bold}${white}${clr}\n"
  printf "  ${bold}${white}${bggreen}Completed:$flight_TIP_command${clr}${bold}${white}${clr}\
    $completed_nodes\
    ${bold}${white}${bgorange}Applying:$flight_TIP_command${clr}${bold}${white}${clr}\
    $applying_nodes\
    ${bold}${white}${bgred}Failed:$flight_TIP_command${clr}${bold}${white}${clr}\
    $failed_nodes\n"
  shopt -u nullglob
  echo ""
)
