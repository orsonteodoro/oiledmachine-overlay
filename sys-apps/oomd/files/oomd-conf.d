# Defaults and same as the Systemd service
OOMD_JSONCFG="/etc/oomd/oomd.json"
OOMD_CGROUPV2_MOUNT_POINT="/sys/fs/cgroup"
OOMD_AUTOMOUNT_CGROUPV2="1" # Can be 1 to mount; 0 (no mount), "", unset for no mount
OOMD_ARGS="--interval 1 --config ${OOMD_JSONCFG} --cgroup-fs ${OOMD_CGROUPV2_MOUNT_POINT}"

# Set to 1 to enable.  Set empty or unset to disable boosting.
OOMD_BOOST="1"

# For boosting CPU priority class scheduling on oomd to preempt an OOM process.
# Use only -R (round robin realtime) or -I (pseudo-realtime but not realtime).
# Do not use -F (FIFO).  Most effective but can lock up or slow things if done
# incorrectly.
#
# The static prio, -p N, where N is from 1-99 should be same as other
# userspace daemons like sshd if made realtime round-robin.
#
# In the systemd version, oomd is supposed to be the critical cgroup.
OOMD_SCHEDTOOL_ARGS="-R -p 99" # At lowest realtime round robin

# For boosting CPU virtual time schedule on oomd to preempt an OOM process.
OOMD_RENICE_ARGS=""

# For boosting IO scheduling on oomd to preempt an OOM process.
# Try to bring oomd dynamic memory pages uninterrupted
OOMD_IONICE_ARGS="-c 1 -n 7" # At realtime at shortest time slice
