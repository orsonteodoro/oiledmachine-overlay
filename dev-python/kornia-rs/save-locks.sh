mkdir -p lockfiles


for x in $(find . -name "Cargo.lock" -type f -o -name "Cargo.toml" -type f) ; do
	[[ "${x}" =~ "tasks" ]] && continue
	[[ "${x}" =~ "lockfiles" ]] && continue
echo "Inspecting ${x}"
	d=$(dirname "${x}")
	mkdir -p "lockfiles/${d}"
	cp -a "${x}" "lockfiles/${d}"
done
