#!/usr/bin/env bash

set -e
set -o pipefail

host=$1
repo=$2

if [ -z "$host" ]
then
  echo "Aborting, please provide a host."
  exit 0;
fi

if [ -z "$repo" ]
then
  echo "Aborting, please provide a Github repo in SSH format."
  exit 0;
fi

echo "----------"
echo "Creating project"
echo "----------"
echo "Project: $host"
echo "----------"
echo "Resetting..."
(
  set -x
  rm -rf ~/.ssh/bot@$host
  rm -rf /var/www/$host
)

echo "----------"
echo "Generating SSH key..."
(
  set -x
  ssh-keygen -t rsa -b 4096 -C "bot@$host" -f ~/.ssh/bot@$host -P ""
  cat ~/.ssh/bot@$host.pub
)

echo "----------"
echo "ACTION REQUIRED:"
echo "1. Please copy the public key above."
echo "2. Open Github and go to the repository of $host."
echo "3. Add public key as read-only deploy key."
echo "4. Done? y/n"

while :
do
read -s -n 1 input
case $input in
  y)
    echo "Done!"
    break;
    ;;
  n)
    echo "Quit"
    exit 0;
    ;;
esac
done

echo "----------"
echo "Cloning repo..."
(
  set -x
  GIT_SSH_COMMAND="ssh -i ~/.ssh/bot@$host" git clone $repo /var/www/$host
  cd /var/www/$host
)

# Funnily enough we can't run this within these closed loops
cd /var/www/$host

echo "----------"
echo "Configuring Git SSH..."
( set -x; git config core.sshCommand "ssh -i ~/.ssh/bot@$host -F /dev/null" )

echo "----------"
echo "Testing if SSH works..."
(
  set -x
  git checkout production
  git pull
)

echo "----------"
echo "Installing Node..."
echo "+ nvm install"

# This hack makes the nvm binary available to this script.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install

echo "----------"
echo "Installing Node packages..."
( set -x; yarn install )

echo "----------"
echo "Building dist..."
( set -x; yarn build )

if [ -f "fastboot.js" ]; then
  echo "----------"
  echo "Spinning up Fastboot"
  ( set -x; pm2 start fastboot.js )
fi

echo "----------"
echo "Configuring Nginx for HTTP..."
( set -x; ln -nsf /var/www/$host/remote/nginx-http.conf /etc/nginx/sites-enabled/$host.conf )

echo "----------"
echo "Testing Nginx configs..."
( set -x; sudo nginx -t )

echo "----------"
echo "Restarting Nginx..."
( set -x; sudo systemctl restart nginx )

echo "----------"
echo "Creating SSL certificates..."
(
  set -x
  sudo certbot certonly --nginx -d $host
  sudo certbot certonly --nginx -d www.$host
)

echo "----------"
echo "Configuring Nginx for HTTPS..."
( set -x; ln -nsf /var/www/$host/remote/nginx-https.conf /etc/nginx/sites-enabled/$host.conf )

echo "----------"
echo "Testing Nginx configs... (again)"
( set -x; sudo nginx -t )

echo "----------"
echo "Restarting Nginx... (again)"
( set -x; sudo systemctl restart nginx )

echo "----------"
echo "Done! Open $host in your browser :)"
echo "----------"
