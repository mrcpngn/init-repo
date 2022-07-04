#!/bin/sh
TARGET=$1
# Wait for the json file to finish writing
sleep 10
if  [ ! -e ./results/csv ]
    then
    mkdir ./results/csv
fi
# Display the values and place into a CSV format
echo "Summary Report: " > ~/csv-out.csv
echo "duration, example_count, failure_count, pending_count, errors_outside_of_examples_count"  >> ~/csv-out.csv
cat ~/json/path/*.json | jq '.summary' | jq -r 'flatten | @csv' >> ~/csv-out.csv
echo "RSpec Report: " >> ~/csv-out.csv
echo  "id, full_description, run_time, status"  >> ~/csv-out.csv
cat ~/json/path/*.json | jq '.examples' | jq -r '. [] | [.id, .full_description, .run_time, .status] | @csv' >> ~/csv-out.csv
