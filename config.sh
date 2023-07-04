#!/bin/bash 
docker run --privileged --name ssh-container -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 4500:22 -d  03b80c777ac0 /usr/sbin/sshd -D
