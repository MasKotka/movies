basedir=$(dirname $(readlink -f "$0"))
filmsdir=$(dirname "$basedir")

people=()
verbose=false

while [ $# -gt 0 ]; do
	cmd="$1"
	shift

	case "$cmd" in
		*)
			echo "unknown option $cmd"
		;;
	esac
done

names=""

for f in "$filmsdir"/*; do
	if [ -f "$f" ]; then
		names="$(sed -e '1,/^---\+$/d' -e '/^---\+$/,$d' -e '/^[^+-]/d' -e 's/^[+-]//' "$f")
$names"
	fi
done

echo "$names" | sed -e '/^[[:space:]]*$/d' | sort -u
