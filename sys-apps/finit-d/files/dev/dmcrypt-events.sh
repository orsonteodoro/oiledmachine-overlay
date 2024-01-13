if [ -n "$HOOK_ROOTFS_UP" ]; then
	FN="start"
elif [ -n "$HOOK_SVC_DN" ]; then
	FN="stop"
fi
