basedir=$(dirname $(readlink -f "$0"))
filmsdir=$(dirname "$basedir")

people=()
verbose=false

while [ $# -gt 0 ]; do
	cmd="$1"
	shift

	case "$cmd" in
		--verbose|-v)
			verbose=true
		;;
		--)
			break
		;;
		-*)
			echo "unknown option $cmd"
			exit 0
		;;
		*)
			people+=("$cmd")
		;;
	esac
done

while [ $# -gt 0 ]; do
	people+=("$1")
	shift
done

for f in "$filmsdir"/*; do
	if [ -f "$f" ]; then
		fail=false
		for p in "${people[@]}"; do
			if [ "$(sed -e '1,/^---\+$/d' -e '/^---\+$/,$d' "$f" | grep -- "-$p")" != "" ]; then
				fail=true
				break
			fi
		done
		if $fail; then
			continue
		fi

		fail=true
		for p in "${people[@]}"; do
			if [ "$(sed -e '1,/^---\+$/d' -e '/^---\+$/,$d' "$f" | grep -- "+$p")" != "" ]; then
				fail=false
				break
			fi
		done
		if $fail; then
			continue
		fi

		if $verbose; then
			echo "--- ${f##*/} ---"
			sed -e '/^---\+$/,$d' "$f"
			echo
		else
			echo "${f##*/}"
		fi
	fi
done
