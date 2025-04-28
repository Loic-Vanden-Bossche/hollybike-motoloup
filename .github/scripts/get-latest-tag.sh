#!/bin/bash

package_name=$1

json_data=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
      "/user/packages/container/${package_name}/versions")

echo "$json_data" | jq '.[0].metadata.container.tags[0]' | tr -d '"'

