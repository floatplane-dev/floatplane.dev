#!/usr/bin/env bash

set -e
set -o pipefail

echo "----------"
echo "Preparing SSH:"
echo "----------"
(set -x; mkdir ~/.ssh)
echo "----------"
(set -x; chmod -R 0755 ~/.ssh)
echo "----------"
(set -x; ssh-keyscan -H singapore.server.floatplane.dev > ~/.ssh/known_hosts)
echo "----------"
