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
IFS=: read -a xdg_config <<< "${XDG_CONFIG_HOME:-$HOME/.config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
for a in "${xdg_config[@]}"; do
  if [ -e "${a}"/flight.rc ]; then
    source "${a}"/flight.rc
    break
  fi
done
flight_ROOT="${flight_ROOT:-/opt/flight}"
if [ -d "${flight_ROOT}"/libexec/hooks ]; then
  shopt -s nullglob
  for a in "${flight_ROOT}"/libexec/hooks/*.sh; do
    source "${a}"
  done
  shopt -u nullglob
fi

if [ -f /etc/xdg/flight/settings.rc ]; then
  . /etc/xdg/flight/settings.rc
fi

if [ -f "$HOME"/.config/flight/settings.rc ]; then
  . "$HOME"/.config/flight/settings.rc
fi

if [ -f "${flight_ROOT}"/etc/flight-starter.rc ]; then
  . "${flight_ROOT}"/etc/flight-starter.rc
fi

cluster="${flight_STARTER_cluster_name:-your cluster}"
bold="$(tput bold)"
green="$(tput setaf 2)"
clr="$(tput sgr0)"
bgblack="$(tput setab 0)"
if [[ $TERM == "xterm-256color" ]]; then
  white="$(tput setaf 7)"
  bgblue="$(tput setab 68)"
  blue="$(tput setaf 68)"
  grey="$(tput setaf 249)"
  bwhite="$(tput setaf 15)"
fi
release="$(cut -f1,2,4 -d' ' /etc/redhat-release)"
cat <<EOF
${bgblack} ${blue}-[${clr}${bgblack} $(eval echo ${flight_STARTER_banner})${clr}${bgblack} ${blue}]- ${clr}
Welcome to ${bold}${bgblack}${green}${cluster}${clr}, based on ${bold}${release}${clr}.

EOF
if [ "${flight_STARTER_hint:-enabled}" == "enabled" ]; then
  cat <<EOF
This cluster provides ${flight_STARTER_desc}.

${bold}${white}'${bgblue}flight start${clr}${bold}${white}'${clr} - activate ${flight_STARTER_product} now
${bold}${white}'${bgblue}flight info${clr}${bold}${white}'${clr}  - get some brief help about ${flight_STARTER_product}
${bold}${white}'${bgblue}flight set${clr}${bold}${white}'${clr}   - change login defaults (see 'flight info' for details)

EOF
fi
