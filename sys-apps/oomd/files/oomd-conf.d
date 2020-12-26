# Defaults and same as the Systemd service
OOMD_JSONCFG="/etc/oomd/oomd.json"
OOMD_ARGS="--interval 1 --config ${OOMD_JSONCFG}"

# Set to 1 to enable.  Set empty or unset to disable boosting.
OOMD_BOOST="1"

# For boosting CPU priority class scheduling on oomd to preempt an OOM process.
# Use only -R (round robin realtime) or -I (pseudo-realtime but not realtime).
# Do not use -F (FIFO).  Most effective but can lock up or slow things if done
# incorrectly.
# In the systemd version, oomd is supposed to be the critical cgroup.
OOMD_SCHEDTOOL_ARGS="-R -p 99" # needs testing

# For boosting CPU virtual time schedule on oomd to preempt an OOM process.
OOMD_RENICE_ARGS=""

# For boosting IO scheduling on oomd to preempt an OOM process.
OOMD_IONICE_ARGS=""
