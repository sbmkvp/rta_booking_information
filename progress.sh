#! /bin/bash

WIDTH="$(tput cols)"
MAX="$(($(wc -l docs/centers.json | awk '{print $1}')-2))"
CURRENT="$(wc -l results.json | awk '{print $1}')"
REPS_F="$(echo $WIDTH/$MAX*$CURRENT | bc -l)"
REPS=$(printf '%.0f' $REPS_F)
echo ''
for i in $(seq 1 $REPS); do printf '='; done;
echo ''
