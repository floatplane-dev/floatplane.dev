#!/usr/bin/env bash

set -e
set -o pipefail

branch=$(git rev-parse --abbrev-ref HEAD)
revision=$(git rev-parse --short HEAD)

echo "----------"
echo "Deploying:"
echo $branch
echo $revision
echo "----------"

(set -x; scp install.sh deploy@singapore.server.floatplane.dev:/var/www/reddust.org.au)

echo "----------"

(set -x; ssh deploy@singapore.server.floatplane.dev "/var/www/reddust.org.au/install.sh $branch $revision")
