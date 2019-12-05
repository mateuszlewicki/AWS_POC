#! /bin/bash
for i in $(ls *.nomad); do nomad job run ${i}