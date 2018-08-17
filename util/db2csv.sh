#!/bin/bash

input="$1"
output="$2"

echo "cuid,ruid,ssn,fname,minit,lname,stnum,stadd,apmt,city,state,zip" > $output
sed -re 's/:/,/g' $input >> $output
