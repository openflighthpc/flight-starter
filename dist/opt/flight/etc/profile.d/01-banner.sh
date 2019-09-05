################################################################################
##
## Flight Starter
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
(
    source ${flight_ROOT}/etc/flight-starter.rc
    release="$(cut -f1,2,4 -d' ' /etc/redhat-release)"
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
