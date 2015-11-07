#!/bin/bash

ROLES="mysql httpd rsyslog users cron ntp keystone nova rabbitmq"

echo "Downloading/updating ansible roles..."

[ ! -d roles ] && mkdir roles
pushd roles >/dev/null
for role in $(echo $ROLES); do
  if [ -d $role ]; then
    cd $role
    git status | grep 'nothing to commit, working directory clean' >/dev/null 2>&1
    printf "*** %-20s " "$role:"
    if [ $? -eq 1 ]; then
      echo "local changes, skipping pull..."
    else
      git pull
    fi
    cd - >/dev/null
  else
    printf "*** %-20s ******************************\n" "$role:"
    git clone https://github.com/gsfjohnson/ansible-${role}-role $role >/dev/null
    # cd $role; git remote set-url origin git@github.com:gsfjohnson/ansible-${role}-role.git
    # cd - >/dev/null
  fi
done
popd >/dev/null
[ "$(grep vagrant /etc/passwd)" != "" ] && chown -R vagrant:vagrant roles

