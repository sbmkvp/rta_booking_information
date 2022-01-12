#! /bin/bash

join -a 1 -t, \
  <(jq -r '.[] | [(.id | tojson),.name] | @csv' $1 | sort -k 1) \
  <(jq -r '.[]| [.location, .result.ajaxresult.slots.nextAvailableDate] | @csv' $2 | sort -k 1) \
  | sort -t, -k 2
