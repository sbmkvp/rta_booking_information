This script scrapes and stores the availability of timeslots for 
Car Driving Test at all RTA Serivce NSW centres in the state. 


## Dependencies

 1. Account with RTA NSW where you can have passed knowledge test, hazard test etc.
 2. [chrome driver](https://sites.google.com/chromium.org/driver/) executable in your PATH variable
 3. Python3 and Selenium installed
 4. jq for json processing (for querying multiple locations and creating reports)
 5. GNU parallel for querying availability for multiple locations

## Usage

#### Setting up the repo

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

Change the username, password to your own account. If you already have a booking
in the system then set the `have_booking` variable to true. If you want to see the
chromedriver UI then set the `headless` variable to false. The variables `wait_timer`
and `wait_timer_car` can be increased to make the script suitable for slower internet
connections. When the `git_upload` variable is set to true, the `get_all_locations.sh`
script will try to commit the results back to github to update the website.

#### Running the script for one location

the scrape_availability.py script takes two inputs - the id of the location and
the file in which the result should be stored. The location ids are given in 
`docs/centers.json`. The output is a json file with an array of available timeslots
and a variable showing the earliest timeslots.

Run the script (for bash based systems e.g. mac/linux/WSL)
```
./scrape_availability.py locationid file_to_save_results.json
```

Run the script (for windows) 
```
python3 scrape_availability.py locationid file_to_save_results.json
```

#### Running the script for multiple locations

Availability for multiple locations could be scraped using the `get_all_locations.sh` 
script. Make sure there is a centers.json file in the docs folder with a list of
centers you want to find availabilty for. This file is included in the repo but note
that this changes regularly in the  rta website so make sure you pull the latest
file from the repo before running. Remove any files created during the last
run (errors.txt, errors_old.txt,results.json etc). The script when successful outputs
results.json file in the docs folder and updates the `update-time.txt` file there.

```
./get_all_locations.sh
```
Once completed, the results could be viewed at http://localhost:8888 after running 
a simple http server at the docs folder by running,

```
python3 -m http.server 8888
```
This script and the one below works only in systems with POSIX compliant shell.

#### Create a csv report

Alternatively you can convert the results stored in the docs folder into a csv by
using the `create_status_report` script.

```
./create_status_report docs/centers.json docs/results.json
```

### Note

This has been tested to work in my system but there are numerous edge cases 
where this might fail.
 - Your account status is different to mine
 - RTA changes website.
 - RTA IT team blocks your IP
 - The website is very slow

If the website is slow and the script fails at selecting the driving test on a new booking
try increasing the wait_timer.

## Disclaimer:

 - For personal use only. 
 - Dont break the law or cause disruption using this.
 - Using automated scripts irresponsibily can cause booking loss, disruption of services etc. be careful and know what you are doing.
 - You are responsible for your actions.
