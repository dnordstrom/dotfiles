#!/usr/bin/env sh

set -eu

df -Ph "$HOME" | tail -n 1 | \
  jq --compact-output --unbuffered -R -s '
          gsub(" +"; " ") | split(" ") | {
            mount: .[0],
            total: .[1],
            used: .[2],
            free: .[3],
            percentage_used: .[4],
            text: "\(.[3])B",
            tooltip: "\(.[2])B / \(.[1])B"
           }'
