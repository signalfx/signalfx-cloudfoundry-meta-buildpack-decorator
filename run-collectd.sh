#!/bin/bash

BUNDLE_DIR=/home/vcap/app/collectd
CONFIG_DIR=/home/vcap/app/.signalfx

vcap_app_jq() {
  echo $VCAP_APPLICATION | $BUNDLE_DIR/bin/jq -r $@
}

# The token should be provided in the app manifest as an envvar
export API_TOKEN=$SIGNALFX_API_TOKEN
export SFX_DIM_app_id=$(vcap_app_jq '.application_id')
export SFX_DIM_app_name=$(vcap_app_jq '.application_name')
export SFX_DIM_app_instance_index=$(vcap_app_jq '.instance_index')
export SFX_DIM_space_name=$(vcap_app_jq '.space_name')

if [[ $SIGNALFX_ENABLE_SYSTEM_METRICS != "yes" ]] && \
   [[ $SIGNALFX_ENABLE_SYSTEM_METRICS != "true" ]]
then
  export NO_SYSTEM_METRICS=yes
fi

for conf in $(find $CONFIG_DIR -name "*.conf")
do
  echo "Detected configuration file $(basename $conf)."
  cp $conf $BUNDLE_DIR/etc/managed_config/
done

bash $BUNDLE_DIR/run.sh
