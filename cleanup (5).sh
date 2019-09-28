#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2

rm -f secretstuff.txt
pkill -u student ssh
ssh student@${H3} "rm -f backpipe; pkill -u student nc"
ssh student@${DMZ} "rm -f secretstuff.txt supersecretstuff.txt"
