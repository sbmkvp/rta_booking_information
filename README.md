This script scrapes and stores the availability of timeslots for 
Car Driving Test at all RTA Serivce NSW centres in the state. 

## Dependencies

 1. Account with RTA NSW where you can have passed knowledge test, hazard test etc.
 2. [chrome driver]() executable in your PATH variable
 3. Python3 and Selenium installed
 4. Optional jq and R for creating reports from results

## Usage

Clone the repo
```
git clone https://github.com/sbmkvp/rta_booking_information
```

Set your working directory to the repo
```
cd rta_booking_information
```

Copy and modify the sample settings file
```
cp settings_sample.json settings.json
```

Change the username, password, if you already have a booking and the specific
centres you are looking for. If you leave the centres `null` all centres will be
searched. 

Run the script (for bash based systems e.g. mac/linux/WSL)
```
./scrape_availability.py
```

Run the script (for windows) 
```
python3 scrape_availability.py
```
The results should be saved in the results folder.
You can convert these to csv report by using the second script 
(requires jq,bash and R with tidyverse)
```
./create_status_report result_file.json
```

This has been tested to work in my system but there are numerous edge cases 
where this might fail.
 - Your account status is different to mine
 - RTA changes website.
 - RTA IT team blocks your IP
 - The website is very slow

## Disclaimer:

 - For personal use only. 
 - Dont break the law or cause disruption using this.
 - Using automated scripts irresponsibily can cause booking loss, disruption of services etc. be careful and know what you are doing.
 - You are responsible for your actions.
