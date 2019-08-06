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
echo "scp install.sh deploy@server-singapore.nabu.io:/var/www/floatplane.dev"
scp install.sh deploy@server-singapore.nabu.io:/var/www/floatplane.dev
echo "----------"
echo 'ssh deploy@server-singapore.nabu.io "/var/www/floatplane.dev/install.sh $branch $revision"'
ssh deploy@server-singapore.nabu.io "/var/www/floatplane.dev/install.sh $branch $revision"
