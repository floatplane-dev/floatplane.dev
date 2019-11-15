#!/usr/local/bin/fish

set remote "rv@server.interflux.com"

set branch (git rev-parse --abbrev-ref HEAD)
set revision (git rev-parse --short HEAD)

echo ----------
echo Deploying:
echo Branch: $branch
echo Revision: $revision
echo Remote: $remote
echo ----------

switch $branch
case production
  set path "/var/www/floatplane.dev"
  echo scp remote/install.sh $remote:$path
  scp remote/install.sh $remote:$path
  and echo ----------
  and echo ssh $remote "$path/install.sh $branch $revision"
  and ssh $remote "$path/install.sh $branch $revision"
case staging
  set path "/var/www/staging.floatplane.dev"
  echo scp remote/install.sh $remote:$path
  scp remote/install.sh $remote:$path
  and echo ----------
  and echo ssh $remote "$path/install.sh $branch $revision"
  and ssh $remote "$path/install.sh $branch $revision"
case '*'
    echo Aborting - Only the branch production and staging are deployable.
    echo ----------
end
