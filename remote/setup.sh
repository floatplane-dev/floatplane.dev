# How to set up a Debian 10 server

# ----------

# DIGITAL OCEAN

# 1. Create droplet
# 2. Add your local public SSH key during creation
cat ~/.ssh/id_rsa.pub
# 3. Configure DNS A-record to point to IP of new droplet

# ----------

# CREATE YOUR USER

ssh root@1.2.3.4
sudo adduser jw
# Religiously store your 64 random character password in 1Password
sudo gpasswd -a jw sudo
groups jw
su - jw
# On your local run:
cat ~/.ssh/id_rsa.pub
# Copy the output
# On the remote run:
mkdir ~/.ssh
vim ~/.ssh/authorized_keys
# Paste your local's public key here, save
touch ~/.hushlogin
logout
ssh jw@1.2.3.4
# Should log you in
# No welcome message is shown

# ----------

# LOCK DOWN ROOT USER

sudo vim /etc/ssh/sshd_config
# PasswordAuthentication no
# PermitRootLogin no
# Save
sudo service ssh restart
logout
ssh root@1.2.3.4
# Should fail
ssh jw@1.2.3.4
# Should work

# ----------

# INSTALL GIT

sudo apt update
sudo apt install git

# ----------

# INSTALL FISH

sudo wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_9.0/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update
sudo apt-get install fish
chsh -s /usr/bin/fish
fish
# Should show fish greeting
curl -L https://get.oh-my.fish | fish
omf install lambda
# Should show you Lambda theme
set fish_greeting
logout
ssh jw@1.2.3.4
# Fish should be your default shell
# No Fish welcome message should be shown

# ----------

# FIREWALL

sudo apt install ufw
sudo ufw status verbose
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
sudo ufw status verbose
# Needs reboot, see next step

# ----------

# RENAME SERVER

sudo vim /etc/hostname
# Update server name if needed"
sudo vim /etc/hosts
# Update 127.0.0.1 to same name
sudo reboot
# Wait 10 sec
ssh jw@1.2.3.4
# Should show new server name

# ----------

# PROJECT DIRECTORY

# Create folder for projects (www) and the git repos (repo).
sudo mkdir /var/www/
# Give the deploy group read and write access to the project folders.
sudo chown -R jw:deploy /var/www/
sudo chmod -R g+w /var/www/
# Make sure these permissions are inherited when future files and folders are created within.
sudo chmod -R g+s /var/www/
# Verify your user is the owner of `./` and you have `drwxr-sr-x` permissions (not `drwxr-xr-x`)
ls -la /var/www/

# ----------

# CREATE SSH KEY

# Without password, with custom file name
ssh-keygen -t rsa -b 4096 -C "cdn@server.interflux.com" -f ~/.ssh/rsa_cdn -P ""
ssh-keygen -t rsa -b 4096 -C "www@server.interflux.com" -f ~/.ssh/rsa_www -P ""

cat ~/.ssh/rsa_cdn.pub
# copy the key to Github, add as deploy key to CDN repo
cat ~/.ssh/rsa_www.pub
# copy the key to Github, add as deploy key to WWW repo

cd /var/www
bash
GIT_SSH_COMMAND='ssh -i ~/.ssh/rsa_www' git clone git@github.com:janwerkhoven/www.interflux.com.git
GIT_SSH_COMMAND='ssh -i ~/.ssh/rsa_cdn' git clone git@github.com:janwerkhoven/cdn.interflux.com.git
fish

cd cdn.interflux.com
git config core.sshCommand "ssh -i ~/.ssh/rsa_cdn -F /dev/null"
git pull

cd ../www.interflux.com
git config core.sshCommand "ssh -i ~/.ssh/rsa_www -F /dev/null"
git pull

# ----------

# NVM, NODE and YARN

# Inside the project, assuming it has `.nvmrc` in the root, run:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
omf install nvm
nvm ls-remote --lts
nvm list
nvm install v10.16.3
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
yarn -v

# ----------

# CLONE, INSTALL and BUILD PROJECT

# We assume your project has `.nvmrc`
# We assume your project has `yarn.lock` and `package.json`
cd /var/www/
git clone git@github.com:janwerkhoven/www.interflux.com.git
cd www.interflux.com
git checkout production
nvm install
yarn install
yarn build

# ----------

# DEPLOY PIPELINE

# Add `deploy.sh` to your project:
# Add `install.sh` to your project:
# Add these scripts to `package.json`

# "scripts": {
#   "start": "./node_modules/.bin/gulp serve",
#   "build": "./node_modules/.bin/gulp build",
#   "deploy": "git checkout production -f; git pull origin master; git push; ./deploy.sh; git checkout master",
#   "bump-patch": "npm version patch; git push origin --tags; git push",
#   "bump-minor": "npm version minor; git push origin --tags; git push",
#   "bump-major": "npm version major; git push origin --tags; git push"
# }

# Deploy to remote!

yarn deploy

# ----------

# NGINX

# Install
sudo apt update
sudo apt install nginx
# Open the firewall for Nginx
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw status verbose
sudo reboot
# Wait 10 sec
ssh jw@1.2.3.4

# Become owner of `sites-available` for easier editing
sudo chown -R jw:jw /etc/nginx/sites-available/
chmod -R g+s /etc/nginx/sites-available/

# Check whether the server blocks are valid:
sudo nginx -t

# Start Nginx:

sudo systemctl start nginx

# You should now see the default Nginx page:

http://server.interflux.com/

# Managing Nginx:

sudo systemctl status nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl stop nginx

# ----------

# CERTBOT

sudo apt-get install certbot python-certbot-nginx

# Managing
sudo certbot certonly --nginx
sudo certbot renew --dry-run
sudo certbot renew

# Certificates expire each 3 months, for automation add the command here:
/etc/crontab/
/etc/cron.*/*
systemctl list-timers

# Testing
https://www.ssllabs.com/ssltest/.

# ----------

# GO LIVE

# On your local, add Nginx config files to your repo
# Add `nginx.conf`
# Add `nginx.temp.conf`
yarn deploy

# On the remote, enable the temporary Nginx config
sudo ln -nsf /var/www/www.interflux.com/nginx.temp.conf /etc/nginx/sites-enabled/www.interflux.com.conf

# Test the config, should pass
sudo nginx -t

# Run Certbot twice, once www and once for non-www
sudo certbot certonly --nginx
sudo certbot certonly --nginx

# Enable the production config, test, should pass
sudo ln -nsf /var/www/www.interflux.com/nginx.conf /etc/nginx/sites-enabled/www.interflux.com.conf
sudo nginx -t

# If all good, restart Nginx
sudo systemctl restart nginx
sudo systemctl status nginx

# Check your website, should be live and redirect HTTP to HTTPS
www.interflux.com
