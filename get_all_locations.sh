#! /bin/bash

git_upload="$(jq '.git_upload' settings.json)"
python3_exe="$(jq '.python3_executable' settings.json)"

echo "$(date +'[%T] :') Pulling latest information from gihub repository..."
git pull

echo "$(date +'[%T] :') Starting the scraping process..."
jq '.[].id' docs/centers.json \
  | parallel "$python3_exe scrape_availability.py {} results.json &> logs.txt || echo {} >> errors.txt"

ERR_NUM="$(wc -l < errors.txt)"

while [[ $ERR_NUM -gt 0 ]]
do 
  mv errors.txt errors_old.txt
  cat errors_old.txt \
    | parallel "$python3_exe ./scrape_availability.py {} results.json &> logs.txt || echo {} >> errors.txt" 
  ERR_NUM="$(wc -l < errors.txt)"
done 
echo "$(date +'[%T] :') Scraping process completed..."

echo "$(date +'[%T] :') Reorganising results..."
jq -s . results.json > ./docs/results.json &&
echo "$(date +'%Y-%m-%d %H:%M%p')" > ./docs/update-time.txt && 
rm results.json errors_old.txt

if [[ $git_upload == 'true' ]];
  then
    echo "$(date +'[%T] :') Pushing the latest data update back to github..."
    git pull &&
    	git add ./docs/results.json ./docs/update-time.txt && 
    	git commit -m "data update" && 
    	git push --quiet
fi

echo "$(date +'[%T] :') All processes complete."
