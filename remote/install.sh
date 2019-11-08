#!/usr/bin/fish

set user (whoami)
set host (hostname)
set path (dirname (status --current-filename))
set branch $argv[1]
set revision $argv[2]

echo ----------
echo User: $user
echo Host: $host
echo Path: $path
echo Branch: $branch
echo Revision: $revision
echo ----------
echo cd $path
cd $path
and echo ----------
and echo git checkout $branch -f
and git checkout $branch -f
and echo ----------
and echo git pull
and git pull
and echo ----------
and echo nvm install
and nvm install
and echo ----------
and echo yarn install
and yarn install
and echo ----------
and echo yarn build
and yarn build
and echo ----------
and echo Deploy successful!
and echo ----------
