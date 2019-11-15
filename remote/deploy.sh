#!/usr/local/bin/fish

set remote "rv@server.floatplane.dev"
set path "/var/www/floatplane.dev"

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
  echo scp remote/install.sh $remote:$path
  scp remote/install.sh $remote:$path
  and echo ----------
  and echo ssh $remote "$path/install.sh $branch $revision"
  and ssh $remote "$path/install.sh $branch $revision"
case '*'
    echo Aborting - Only the branch production is deployable.
    echo ----------
end
