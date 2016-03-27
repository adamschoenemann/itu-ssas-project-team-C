#!/bin/sh

if [ ! -z "$1" ]; then
  file="$1"
elif [ -f dk.itu.ssas.project.war ]; then
  file=dk.itu.ssas.project.war
elif [ -f ~/dk.itu.ssas.project.war ]; then
  file=~/dk.itu.ssas.project.war
elif [ -f ~/project.war ]; then
  file=project.war
elif [ -f project.war ]; then
  file=project.war
else
  echo "Please sepcify file name of WAR file"
  exit 1
fi

echo "Deploying $file"

key=$(ssh-add -l 2>/dev/null | grep '03:3e:9f:d6:16:f9:df:98:9e:4f:bb:ac:0d:22:46:f2')

if [ -z "$key" ]; then
  if [ -f photoshare_rsa ]; then
     ssh-add photoshare_rsa
  elif [ -f ~/.ssh/photoshare_rsa ]; then
     ssh-add ~/.ssh/photoshare_rsa
  else
     echo "For convenience you should add the key photoshare_rsa with ssh-add before"
     echo "running this script..."
  fi
fi

scp "$file" photoshare@192.168.0.101:dk.itu.ssas.project.war
ssh photoshare@192.168.0.101 ./deploy.sh

