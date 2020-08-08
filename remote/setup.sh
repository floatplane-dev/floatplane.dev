#!/usr/bin/env bash

set -e
set -o pipefail

user=jw
host=sydney.floatplane.dev
domain=floatplane.dev
repo=git@github.com:janwerkhoven/floatplane.dev.git

echo "----------"
echo "Setting up remote server for:"
echo $user@$host
echo $domain
echo $repo
echo "----------"

(
  set -x
  scp remote/setup-remote.sh $user@$host:~/
  ssh -t $user@$host "~/setup-remote.sh $domain $repo; rm -f ~/setup-remote.sh"
)
