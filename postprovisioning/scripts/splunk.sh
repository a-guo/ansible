#!/bin/bash

echo "Installing Splunk! ... please wait "
sudo su -
apt-get update > /dev/null 2>&1
apt-get install -y wget > /dev/null 2>&1


# add splunk user
useradd -m -c "splunk user" splunk  -s /bin/bash

echo "Downloading Splunk"

wget -O splunk-7.2.3-06d57c595b80-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.2.3&product=splunk&filename=splunk-7.2.3-06d57c595b80-Linux-x86_64.tgz&wget=true' > /dev/null 2>&1

echo "moving splunk to /opt"

mv splunk-7.2.3-06d57c595b80-Linux-x86_64.tgz /opt > /dev/null 2>&1

cd /opt

echo "untar the splunk"

tar -xzvf splunk-7.2.3-06d57c595b80-Linux-x86_64.tgz > /dev/null 2>&1 && chown -R splunk.splunk splunk > /dev/null 2>&1

echo "su splunk"

su - splunk

cd splunk/bin

cat > /opt/splunk/etc/system/local/user-seed.conf << EOF
[user_info]
USERNAME = admin
PASSWORD = changeme
EOF

echo "Starting Splunk"
./splunk start --accept-license

echo "Splunk is available on http://localhost:8011 or http://localhost:8012"
