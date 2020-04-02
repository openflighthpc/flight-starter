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
    source ${flight_ROOT}/etc/flight-starter.rc
    if [ -f /etc/redhat-release ]; then
      release="$(cut -f1,2,4 -d' ' /etc/redhat-release)"
    elif [ -f /etc/lsb-release ]; then
      . /etc/lsb-release
      release="${DISTRIB_DESCRIPTION:-${DISTRIB_ID} ${DISTRIB_RELEASE}}"
    fi
    ${flight_ROOT}/libexec/flight-starter/banner \
                  "${flight_STARTER_cluster_name:-your cluster}" \
                  "${flight_STARTER_product} ${flight_STARTER_release}" \
                  "${release}"
    shopt -s nullglob
    for i in "$flight_ROOT"/etc/banner/banner.d/*.{sh,txt}; do
      if [ -r "$i" ]; then
        if [ "${i: -4}" == '.txt' ]; then
          cat "$i" | sed '/^#/ d'
        elif [ "${i: -3}" == '.sh' ]; then
          . "$i"
        fi
      fi
    done
    shopt -u nullglob
)
