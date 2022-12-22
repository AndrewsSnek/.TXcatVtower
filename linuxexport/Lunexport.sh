#!/bin/sh
echo -ne '\033c\033]0;TXcatVtower\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Lunexport.x86_64" "$@"
