#!/usr/bin/env bash

input=$(cliphist list) || exit 0
[ -z "$input" ] && exit 0 # if empty

chosen=$(printf '%s' "$input" | fuzzel -d -p "Clipboard")

[ -z "$chosen" ] && exit 0

# Try to decode selected id via cliphist; if decoding yields nothing, copy selection directly.
decoded=$(printf '%s' "$chosen" | cliphist decode 2>/dev/null || true)
if [ -n "$decoded" ]; then
	printf '%s' "$decoded" | wl-copy
else
	printf '%s' "$chosen" | wl-copy
fi

exit 0