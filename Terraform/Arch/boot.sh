#! /bin/bash
git clone https://gitlab.com/mateusz.lewicki/aws_poc.git
cd aws_poc/Nomad
cp -r * /opt/nomad
cd /opt/nomad
sleep 3
for i in $(ls *.nomad); do nomad job run ${i}; done
