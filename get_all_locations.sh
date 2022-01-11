#! /bin/bash

jq '.[].id' docs/centers.json \
  | parallel "./scrape_availability.py {} results.json || echo {} >> errors.txt"

ERR_NUM="$(wc -l < errors.txt)"

while [[ $ERR_NUM -gt 0 ]]
do 
  mv errors.txt errors_old.txt
  cat errors_old.txt \
    | parallel "./scrape_availability.py {} results.json || echo {} >> errors.txt" 
  ERR_NUM="$(wc -l < errors.txt)"
done 

git pull &&
  jq -s . results.json > ./docs/results.json &&
  echo "$(date +'%Y-%m-%d %H:%M%p')" > ./docs/update-time.txt && 
  git add ./docs/results.json ./docs/update-time.txt && 
  git commit -m "data update" && 
  git push

rm results.json errors_old.txt
