#! /bin/bash
git https://gitlab.com/mateusz.lewicki/aws_poc.git
cd aws_poc/Nomad
cp * /opt/nomad
cd /opt/nomad
for i in $(ls *.nomad); do nomad job run ${i}