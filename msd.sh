#!/usr/bin/env bash
# msd.sh - 从 ModelScope 下载模型文件的 shell 脚本
# Copyright (C) 2026 BlueArchive-Git
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

command -v figlet >/dev/null 2>&1 && figlet msd.sh
build_url() {
    local repo="$1"
    local file="$2"
    local rev="$3"

    curl -s -o /dev/null \
        --get \
        --data-urlencode "Revision=${rev}" \
        --data-urlencode "FilePath=${file}" \
        --write-out '%{url_effective}' \
        "https://modelscope.cn/api/v1/models/${repo}/repo"
}

main() {
    local repo=""
    local file=""
    local local_dir="."
    local save_name=""
    local rev="${REV:-master}"
    local split="${SPLIT:-1}"
    local server_connection="${SERVER_CONNECTION:-1}"
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <REPO> <FILE> [--local-dir <DIR>] [--name <NAME>] [--split <SPLIT>] [--rev <REV>] [--server <MAXSERVER_CONNECTION>]" >&2
        return 1
    fi

    repo="$1"
    file="$2"
    shift 2

    while [ $# -gt 0 ]; do
        case "$1" in
            --local-dir)
                [ -n "$2" ] || { echo "Missing value for --local-dir" >&2; return 1; }
                local_dir="$2"
                shift 2
                ;;
            --name)
                [ -n "$2" ] || { echo "Missing value for --name" >&2; return 1; }
                save_name="$2"
                shift 2
                ;;
            --split)
                [ -n "$2" ] || { echo "Missing value for --split" >&2; return 1; }
                split="$2"
                shift 2
                ;;
            --rev)
                [ -n "$2" ] || { echo "Missing value for --rev" >&2; return 1; }
                rev="$2"
                shift 2
		;;
	    --server)
		[ -n "$2" ] || { echo "Missing value for --server" >&2; return 1; }
                server_connection="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1" >&2
                return 1
                ;;
        esac
    done

    [ -n "$save_name" ] || save_name="$(basename "$file")"

    mkdir -p "$local_dir"

    local url
    url="$(build_url "$repo" "$file" "$rev")"

    if [ -z "$url" ]; then
        echo "Failed to build URL" >&2
        return 1
    fi


    aria2c \
    -d "$local_dir" \
    -o "$save_name" \
    --allow-overwrite=true \
    --auto-file-renaming=false \
    --continue=true \
    --download-result=hide \
    --summary-interval=0 \
    --console-log-level=error \
    --split=$split \
    --max-connection-per-server=$server_connection \
    --min-split-size=1M \
    "$url"
    if [ "$?" = 0 ]; then
        echo
        echo "✓ $file => $local_dir/$save_name"
        return 0
    fi
}
main "$@"
