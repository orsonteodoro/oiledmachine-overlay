# Copyright 2021 Orson Teodoro <orsonteodoro@hotmail.com>
# License: GPL2

# Regenerates the REQUIRED_USE dependency graph.

# #1 identify and find all the nodes (aka points)
# #2 connect the edges via conditional dependency

ETC_FOLDER="/var/tmp/portage/sys-apps/firejail-0.9.66/work/firejail-0.9.66/etc"

unset nodes
nodes=()

for f in $(find "${ETC_FOLDER}/"{profile-a-l,profile-m-z} -name "*.profile") ; do
	n=$(basename "${f}" | sed -e "s|.profile||g")
	nodes+=(${n})
done

unset g
declare -A g

# The parent is always left hand side, the child is the right hand side in the bucket list

for p in $(echo "${nodes[@]}" | tr " " "\n" | sort) ; do
	profiles=$(grep -E -e "include .*.profile" $(ls "${ETC_FOLDER}/"*/${p}.profile))
	childs=$(echo "${profiles}" | sed -e "s|.profile||" -e "s|include ||")
	if [[ -n "${childs}" ]] ; then
		childs=$(echo "${childs}" | sed -e "s|^|firejail_profiles_|g")
		echo -e "\tfirejail_profiles_${p}? ( ${childs} )"  # parent: childs
	fi
done
